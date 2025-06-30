//import path from 'path';
//import fs from 'fs/promises';
//import { v4 as uuid } from 'uuid';
import FormData from 'form-data';
import axios from 'axios';

const SHEDULER_URL =  'http://192.168.1.30:3001'; // process.env.SHEDULER_URL || 
//const UPLOAD_BASE_PATH = path.join(process.cwd(), 'public'); // resolves to your root/public

export default defineEventHandler(async (event) => {
  try {
    const body = await readBody(event);
    console.log(SHEDULER_URL);
    console.log('Received job creation request:', body);
    console.log('Scheduler URL:', SHEDULER_URL);

    // const filePaths = body.data.files || [];
    const form = new FormData();

    /*for (const filePath of filePaths) {
      const relativePath = filePath.replace(/^\/+/, ''); // removes leading "/"
      const fullPath = path.join(UPLOAD_BASE_PATH, relativePath); // e.g., public/uploads/...

      try {
        const fileBuffer = await fs.readFile(fullPath);
        const fileName = path.basename(fullPath);
        form.append('files', fileBuffer, fileName);
      } catch (e: any) {
        console.warn(`⚠️ Failed to read file: ${fullPath} — ${e.message}`);
      }
    }*/

    form.append('userId', body.user);
    form.append('analysis', JSON.stringify(body.data.files));
    form.append('projectId', body.data.projectId);
    form.append('type', body.type);

    const response = await axios.post(`${SHEDULER_URL}/enqueue-job`, form, {
      headers: form.getHeaders()
    });

    return { success: true, jobId: response.data.jobId };
  } catch (error: any) {
    console.error('❌ Job submission failed:', error);
    return {
      error: true,
      message: error.message || 'Internal server error'
    };
  }
});
