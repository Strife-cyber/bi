const path = require('path');
const multer = require('multer');
const fs = require('fs/promises');
const express = require('express');
const { v4: uuid } = require('uuid');
const lockfile = require('proper-lockfile');
const runWorker = require('./analysis.worker.cjs');
const sendNotification = require('./notification.cjs'); // Adjust path if needed

const app = express();
const PORT = process.env.PORT || 3001;
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

// Wrap async init inside an IIFE to allow await usage
(async () => {
  // Ensure upload directory exists
  await fs.mkdir(uploadDir, { recursive: true });

  app.use(express.json());

  app.post('/enqueue-job', upload.array('files'), async (req, res) => {
    try {
      const { type, userId, projectId } = req.body;
      const files = req.files || [];

      const filePaths = files.map(f => `/uploads/${f.filename}`);
      const now = new Date().toISOString();

      const job = {
        id: uuid(),
        type,
        data: {
          files: filePaths,
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
        message: 'Votre demande d\'analyse a bien été reçue...'
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

  app.listen(PORT, () => {
    console.log(`🚀 Server running on http://localhost:${PORT}`);
  });
  await runWorker();
})();
