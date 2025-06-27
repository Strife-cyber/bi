const fs = require('fs').promises;
const path = require('path');
const { v4: uuidv4 } = require('uuid');

const JOBS_FILE = path.join(__dirname, '../jobs.json');
const LOCK_FILE = path.join(__dirname, '../jobs.lock');

// Lockfile utilities
async function acquireLock() {
  const maxRetries = 50;
  const retryDelay = 100;

  for (let i = 0; i < maxRetries; i++) {
    try {
      await fs.writeFile(LOCK_FILE, process.pid.toString(), { flag: 'wx' });
      return true;
    } catch (err) {
      if (err.code === 'EEXIST') {
        await new Promise(resolve => setTimeout(resolve, retryDelay));
        continue;
      }
      throw err;
    }
  }
  throw new Error('Could not acquire lock');
}

async function releaseLock() {
  try {
    await fs.unlink(LOCK_FILE);
  } catch (_) {}
}

async function readJobs() {
  try {
    const data = await fs.readFile(JOBS_FILE, 'utf-8');
    return JSON.parse(data);
  } catch (err) {
    return [];
  }
}

async function writeJobs(jobs) {
  await fs.writeFile(JOBS_FILE, JSON.stringify(jobs, null, 2));
}

module.exports = {
  async getAllJobs(req, res) {
    try {
      await acquireLock();
      const jobs = await readJobs();
      await releaseLock();
      res.json(jobs);
    } catch (err) {
      await releaseLock();
      res.status(500).json({ error: err.message });
    }
  },

  async getJobById(req, res) {
    try {
      await acquireLock();
      const jobs = await readJobs();
      const job = jobs.find(j => j.id === req.params.id);
      await releaseLock();

      if (!job) return res.status(404).json({ error: 'Job not found' });
      res.json(job);
    } catch (err) {
      await releaseLock();
      res.status(500).json({ error: err.message });
    }
  },

  async createJob(req, res) {
    try {
      await acquireLock();
      const jobs = await readJobs();

      const newJob = {
        id: uuidv4(),
        type: req.body.type || 'Analysis',
        data: {
          files: req.body.files || '[]',
          result: req.body.result || {},
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString(),
          userId: req.body.userId || '',
          projectId: req.body.projectId || ''
        },
        status: req.body.status || 'pending',
        completedAt: req.body.status === 'done' ? new Date().toISOString() : null
      };

      jobs.push(newJob);
      await writeJobs(jobs);
      await releaseLock();
      res.status(201).json(newJob);
    } catch (err) {
      await releaseLock();
      res.status(500).json({ error: err.message });
    }
  },

  async updateJob(req, res) {
    try {
      await acquireLock();
      const jobs = await readJobs();
      const index = jobs.findIndex(j => j.id === req.params.id);
      if (index === -1) {
        await releaseLock();
        return res.status(404).json({ error: 'Job not found' });
      }

      const updated = {
        ...jobs[index],
        type: req.body.type || jobs[index].type,
        data: {
          ...jobs[index].data,
          files: req.body.files || jobs[index].data.files,
          result: req.body.result || jobs[index].data.result,
          updatedAt: new Date().toISOString(),
          userId: req.body.userId || jobs[index].data.userId,
          projectId: req.body.projectId || jobs[index].data.projectId
        },
        status: req.body.status || jobs[index].status,
        completedAt: req.body.status === 'done' ? new Date().toISOString() : jobs[index].completedAt
      };

      jobs[index] = updated;
      await writeJobs(jobs);
      await releaseLock();
      res.json(updated);
    } catch (err) {
      await releaseLock();
      res.status(500).json({ error: err.message });
    }
  },

  async deleteJob(req, res) {
    try {
      await acquireLock();
      const jobs = await readJobs();
      const index = jobs.findIndex(j => j.id === req.params.id);
      if (index === -1) {
        await releaseLock();
        return res.status(404).json({ error: 'Job not found' });
      }

      jobs.splice(index, 1);
      await writeJobs(jobs);
      await releaseLock();
      res.json({ message: 'Job deleted' });
    } catch (err) {
      await releaseLock();
      res.status(500).json({ error: err.message });
    }
  }
};
