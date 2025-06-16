const fs = require('fs')
const path = require('path')
const lockfile = require('proper-lockfile')

const jobFilePath = path.resolve(__dirname, '../jobs/jobQueue.json')

async function loadJobs() {
  const data = fs.readFileSync(jobFilePath, 'utf-8')
  return JSON.parse(data)
}

async function saveJobs(jobs) {
  fs.writeFileSync(jobFilePath, JSON.stringify(jobs, null, 2))
}

async function processJob(job) {
  console.log(`🔧 Processing job ${job.id} of type ${job.type}`)

  // Simulated task
  await new Promise(res => setTimeout(res, 1000))

  // TODO: Send result somewhere else
  console.log(`✅ Job ${job.id} done`)
}

async function runWorker() {
  while (true) {
    let release
    try {
      release = await lockfile.lock(jobFilePath)

      const jobs = await loadJobs()
      const job = jobs.find(j => j.status === 'pending')

      if (job) {
        job.status = 'processing'
        await saveJobs(jobs)

        try {
          await processJob(job)
          job.status = 'done'
          job.completedAt = new Date().toISOString()
        } catch (e) {
          job.status = 'failed'
          job.error = e.message
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
