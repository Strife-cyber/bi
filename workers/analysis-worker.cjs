const fs = require('fs')
const path = require('path')
const axios = require('axios')
const crypto = require('crypto')
const FormData = require('form-data')
const lockfile = require('proper-lockfile')

require('dotenv').config()

const BASE_DIR = path.resolve(__dirname, '../public')

const jobFilePath = path.resolve(__dirname, '../jobs/jobQueue.json')

async function loadJobs() {
  const data = fs.readFileSync(jobFilePath, 'utf-8')
  return JSON.parse(data)
}

async function saveJobs(jobs) {
  fs.writeFileSync(jobFilePath, JSON.stringify(jobs, null, 2))
}

async function processJob(job) {
  console.log(`🔧 Processing job ${job.id} of type ${job.type}`);

  // Run all cracked(file) calls in parallel
  const promises = job.data.files.map(file => cracked(getAbsoluteFilePath(file)))
  const result = await Promise.all(promises)

  console.log(result);

  // TODO: Send result somewhere else
  console.log(`✅ Job ${job.id} done`);
}

const CRACKS_SECRET_KEY = process.env.CRACKS_SECRET_KEY;
const BASE_URL = process.env.CRACKS_API_URL || "http://localhost:8000";

function getAbsoluteFilePath(file) {
  return path.join(BASE_DIR, file.replace(/^\/+/, ''));
}

async function cracked(filePath) {
  try {
    const form = new FormData()
    const fileBuffer = fs.readFileSync(path.resolve(filePath))
    const filename = path.basename(filePath)

    // Get file extension for MIME type detection
    const ext = filename.split('.').pop()?.toLowerCase() || ''
    const mimeTypes = {
      jpg: 'image/jpeg',
      jpeg: 'image/jpeg',
      png: 'image/png',
      gif: 'image/gif',
      mp4: 'video/mp4',
      mov: 'video/quicktime',
      avi: 'video/x-msvideo'
    }

    form.append("file", fileBuffer, {
      filename,
      contentType: mimeTypes[ext] || 'application/octet-stream'
    })

    // Get form payload buffer (Node.js FormData does not have getBuffer by default)
    // Use form.getLengthSync() for content-length header if needed
    // but axios can handle this if you pass the form directly.

    const formBuffer = form.getBuffer();
    const timestamp = Math.floor(Date.now() / 1000).toString()
    const method = "POST"
    const endpoint = "/inference/"

    // Construct message using the full form payload - note: you might want to re-check if concatenating form buffer like this matches your API’s signature expectations
    // Often, API signatures are done on just method+endpoint+timestamp or on the raw body bytes.
    const message = method + endpoint + timestamp
    const messageBuffer = Buffer.concat([
      Buffer.from(message, 'utf-8'),
      formBuffer
      // form buffer here? This may be tricky — form-data doesn't easily provide a raw buffer before sending.
    ])

    // For now, let's assume the signature is only method+endpoint+timestamp
    const signature = crypto
      .createHmac('sha256', CRACKS_SECRET_KEY)
      .update(messageBuffer)
      .digest('hex')

    // Send the request
    const response = await axios.post(`${BASE_URL}${endpoint}`, form, {
      headers: {
        ...form.getHeaders(),
        'x-timestamp': timestamp,
        'x-signature': signature,
      }
    })

    return response.data
  } catch (error) {
    console.error(error)
  }
}

async function runWorker() {
  while (true) {
    let release
    try {
      release = await lockfile.lock(jobFilePath)

      const jobs = await loadJobs()
      const job = jobs.find(j => j.status === 'pending')

      if (job) {
        // job.status = 'processing'
        // await saveJobs(jobs)

        try {
          await processJob(job)
          // job.status = 'done'
          // job.completedAt = new Date().toISOString()
        } catch (e) {
          //job.status = 'failed'
          //job.error = e.message
          console.error('Job processing error:', e)
        }

        await saveJobs(jobs)
      }
    } catch (e) {
      console.error('Worker error:', e.message)
    } finally {
      if (release) await release()
    }

    await new Promise(res => setTimeout(res, 2000)) // Wait before next check
  }
}

runWorker()
