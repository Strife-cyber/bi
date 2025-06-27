const fs = require('fs');
const path = require('path');
const axios = require('axios');
const crypto = require('crypto');
const FormData = require('form-data');
const lockfile = require('proper-lockfile');
const sendNotification = require('./notification.cjs');
const updateAnalysisResult = require('./firestore-utils.cjs');

require('dotenv').config();

const jobFilePath = path.resolve(__dirname, './jobs.json');

const MOULD_SECRET_KEY = process.env.MOULD_SECRET_KEY;
const CRACKS_SECRET_KEY = process.env.CRACKS_SECRET_KEY;
const FIREBASE_DB_URL = process.env.FIREBASE_DATABASE_URL;
const MOULD_URL = process.env.MOULD_URL || "http://localhost:3003";
const BASE_URL = process.env.CRACKS_API_URL || "http://localhost:3002";

async function loadJobs() {
  const data = fs.readFileSync(jobFilePath, 'utf-8');
  return JSON.parse(data);
}

async function saveJobs(jobs) {
  fs.writeFileSync(jobFilePath, JSON.stringify(jobs, null, 2));
}

async function fetchFileBuffer(url) {
  const response = await axios.get(url, { responseType: 'arraybuffer' });
  const filename = path.basename(url.split('?')[0]); // handles URLs with query params
  return { buffer: Buffer.from(response.data), filename };
}

async function processJob(job) {
  console.log(`🔧 Processing job ${job.id} of type ${job.type}`);

  const jobFiles = JSON.parse(job.data.files);
  const promises = jobFiles.map(url => cracked(url));
  const mouldPromises = jobFiles.map(url => mould(url));
  
  const results = await Promise.all(promises);
  const mouldResults = await Promise.all(mouldPromises);

  const finalResults = [];

  for (let i = 0; i < results.length; i++) {
    const cracked = results[i];
    const moulded = mouldResults[i];

    const type = cracked['type'];

    let combinedResult = {
      'type': type,
      'valid_detections': cracked['valid_detections'] + moulded['valid_detections'],
      'confidence_threshold': (cracked['confidence_threshold'] + moulded['confidence_threshold']) / 2,
      'class_distribution': {
        '0': cracked['class_distribution']['0'] || 0,
        '1': moulded['class_distribution']['0'] || 0,
      }
    }

    if (type == 'video') {
      combinedResult = {
        ...combinedResult,
        'frames_analyzed': cracked['frames_analyzed'],
      }
    }

    finalResults.push(combinedResult);
  }

  job.data.result = JSON.stringify(finalResults);

  await updateAnalysisResult(job.data.userId, job.data.projectId, job.data.createdAt, finalResults);
  await sendNotification(
    job.data.userId,
    'Analyse terminée',
    'Votre analyse est terminée. Vous pouvez consulter les résultats dans votre projet.',
    'info',
    FIREBASE_DB_URL
  )

  // TODO: Add result logic and reporting
  console.log(`✅ Job ${job.id} done`);
}


async function cracked(fileUrl) {
  try {
    const { buffer, filename } = await fetchFileBuffer(fileUrl);

    const ext = filename.split('.').pop()?.toLowerCase() || '';
    const mimeTypes = {
      jpg: 'image/jpeg',
      jpeg: 'image/jpeg',
      png: 'image/png',
      gif: 'image/gif',
      mp4: 'video/mp4',
      mov: 'video/quicktime',
      avi: 'video/x-msvideo'
    };

    const form = new FormData();
    form.append("file", buffer, {
      filename,
      contentType: mimeTypes[ext] || 'application/octet-stream'
    });

    const formBuffer = form.getBuffer();
    const timestamp = Math.floor(Date.now() / 1000).toString();
    const method = "POST";
    const endpoint = "/inference/";

    const message = method + endpoint + timestamp;
    const messageBuffer = Buffer.concat([Buffer.from(message, 'utf-8'), formBuffer]);

    const signature = crypto
      .createHmac('sha256', CRACKS_SECRET_KEY)
      .update(messageBuffer)
      .digest('hex');

    const response = await axios.post(`${BASE_URL}${endpoint}`, form, {
      headers: {
        ...form.getHeaders(),
        'x-timestamp': timestamp,
        'x-signature': signature,
      }
    });

    return response.data;
  } catch (error) {
    console.error(`❌ Mould inference error for file ${fileUrl}:`, error.message);
  }
}

async function mould(fileUrl) {
  try {
    const { buffer, filename } = await fetchFileBuffer(fileUrl);

    const ext = filename.split('.').pop()?.toLowerCase() || '';
    const mimeTypes = {
      jpg: 'image/jpeg',
      jpeg: 'image/jpeg',
      png: 'image/png',
      gif: 'image/gif',
      mp4: 'video/mp4',
      mov: 'video/quicktime',
      avi: 'video/x-msvideo'
    };

    const form = new FormData();
    form.append("file", buffer, {
      filename,
      contentType: mimeTypes[ext] || 'application/octet-stream'
    });

    const formBuffer = form.getBuffer();
    const timestamp = Math.floor(Date.now() / 1000).toString();
    const method = "POST";
    const endpoint = "/inference/";

    const message = method + endpoint + timestamp;
    const messageBuffer = Buffer.concat([Buffer.from(message, 'utf-8'), formBuffer]);

    const signature = crypto
      .createHmac('sha256', MOULD_SECRET_KEY)
      .update(messageBuffer)
      .digest('hex');

    const response = await axios.post(`${MOULD_URL}${endpoint}`, form, {
      headers: {
        ...form.getHeaders(),
        'x-timestamp': timestamp,
        'x-signature': signature,
      }
    });

    return response.data;
  } catch (error) {
    console.error(`❌ Mould inference error for file ${fileUrl}:`, error.message);
  }
}

async function runWorker() {
  while (true) {
    let release;
    try {
      release = await lockfile.lock(jobFilePath);

      const jobs = await loadJobs();
      const job = jobs.find(j => j.status === 'pending');

      if (job) {
        job.status = 'processing';
        await saveJobs(jobs);

        try {
          await processJob(job);
          job.status = 'done';
          job.completedAt = new Date().toISOString();
        } catch (e) {
          job.status = 'failed';
          job.error = e.message;
          console.error('Job processing error:', e);
        }

        await saveJobs(jobs);
      }
    } catch (e) {
      console.error('Worker error:', e.message);
    } finally {
      if (release) await release();
    }

    await new Promise(res => setTimeout(res, 2000));
  }
}

module.exports = runWorker;
