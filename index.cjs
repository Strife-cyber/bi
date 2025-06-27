const os = require('os');
const path = require('path');
const multer = require('multer');
const fs = require('fs/promises');
const express = require('express');
const { v4: uuid } = require('uuid');
const jobsRoutes = require('./routes.cjs');
const lockfile = require('proper-lockfile');
const runWorker = require('./analysis.worker.cjs');
const sendNotification = require('./notification.cjs'); // Adjust path if needed

const app = express();
const PORT = process.env.PORT || 10000; // 3001
const uploadDir = path.resolve('uploads');
const jobFilePath = path.resolve('jobs.json');

// Setup multer for handling uploads
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, uploadDir);
  },
  filename: function (req, file, cb) {
    const uniqueName = `${Date.now()}-${file.originalname}`;
    cb(null, uniqueName);
  }
});
const upload = multer({ storage });

function getLocalIP() {
  const interfaces = os.networkInterfaces()

  // Prioritize known Wi-Fi names
  const preferredNames = ['Wi-Fi', 'Wi-Fi 2', 'WLAN', 'WiFi']

  for (const name of preferredNames) {
    const iface = interfaces[name]
    if (!iface) continue

    for (const config of iface) {
      if (config.family === 'IPv4' && !config.internal) {
        return config.address
      }
    }
  }

  // Fallback to any 192.168.*.* interface
  for (const name in interfaces) {
    for (const config of interfaces[name] || []) {
      if (config.family === 'IPv4' && !config.internal && config.address.startsWith('192.168.')) {
        return config.address
      }
    }
  }

  return 'localhost'
}

// Wrap async init inside an IIFE to allow await usage
(async () => {
  // Ensure upload directory exists
  await fs.mkdir(uploadDir, { recursive: true });

  app.use(express.json());
  app.use(express.static("public"));
  app.use('/api/jobs', jobsRoutes);

  app.post('/enqueue-job', upload.array('files'), async (req, res) => {
    try {
      const { type, userId, projectId, analysis } = req.body;
      // const files = req.files || [];

      // const filePaths = files.map(f => `/uploads/${f.filename}`);
      const now = new Date().toISOString();

      const job = {
        id: uuid(),
        type,
        data: {
          files: analysis,
          result: {},
          createdAt: now,
          updatedAt: now,
          userId,
          projectId
        },
        status: 'pending'
      };

      let release;
      try {
        release = await lockfile.lock(jobFilePath);

        let jobs = [];
        try {
          const raw = await fs.readFile(jobFilePath, 'utf8');
          jobs = JSON.parse(raw);
        } catch (readError) {
          if (readError.code !== 'ENOENT') throw readError;
        }

        jobs.push(job);
        await fs.writeFile(jobFilePath, JSON.stringify(jobs, null, 2), 'utf8');
      } finally {
        if (release) await release();
      }

      await sendNotification({
        userId,
        title: 'Analyse en cours',
        message: 'Votre demande d\'analyse a bien été reçue...',
        FIREBASE_DB_URL: process.env.FIREBASE_DATABASE_URL
      });

      res.json({ success: true, jobId: job.id });

    } catch (error) {
      console.error('Job submission failed:', error);
      res.status(500).json({
        error: true,
        message: error.message || 'Internal server error'
      });
    }
  });

  const ip = getLocalIP();

  app.listen(PORT, ip, () => {
    console.log(`🚀 Server running on http://${ip}:${PORT}`);
  });
  await runWorker();
})();
