import path from 'path';
import fs from 'fs/promises';  // Use promises API for async/await
import { v4 as uuid } from 'uuid';
import lockfile from 'proper-lockfile';

const jobFilePath = path.resolve('jobs/JobQueue.json');

export default defineEventHandler(async (event) => {
    try {
        const body = await readBody(event);
        const userId = body.user;  // Declared earlier for potential use

        const job = {
            id: uuid(),
            type: body.type,
            data: body.data,
            status: 'pending'
        };

        let release;
        try {
            // Acquire file lock
            release = await lockfile.lock(jobFilePath);
            
            // Read and parse existing jobs
            let jobs = [];
            try {
                const raw = await fs.readFile(jobFilePath, 'utf8');
                jobs = JSON.parse(raw);
            } catch (readError) {
                // Handle missing file (OK for first job)
                // @ts-ignore
                if (readError.code !== 'ENOENT') throw readError;
            }

            // Add new job and write back to file
            jobs.push(job);
            await fs.writeFile(jobFilePath, JSON.stringify(jobs, null, 2), 'utf8');
        } finally {
            // Always release lock if acquired
            if (release) await release();
        }

        // comment if needed
        await sendNotification({
            userId: userId,
            title: "Analyse en cours",
            message: "Votre demande d'analyse a bien été reçue..."
        });

        return { success: true, jobId: job.id };
    } catch (error) {
        console.error('Job submission failed:', error);
        return { 
            error: true, 
            //@ts-ignore
            message: error.message || 'Internal server error' 
        };
    }
});
