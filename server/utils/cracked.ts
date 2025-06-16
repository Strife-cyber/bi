import fs from "fs";
import axios from "axios";
import crypto from "crypto";
import FormData from "form-data";

const CRACKS_SECRET_KEY = process.env.CRACKS_SECRET_KEY!;
const BASE_URL = process.env.CRACKS_API_URL || "http://localhost:8000";

export default async function cracked(path: string, userId: string, notify = false, key = '') {
    try {
        const form = new FormData();
        const fileBuffer = fs.readFileSync(path);
        const filename = path.split('/').pop() || 'file';
        
        // Get file extension for MIME type detection
        const ext = filename.split('.').pop()?.toLowerCase() || '';
        const mimeTypes: Record<string, string> = {
            jpg: 'image/jpeg',
            jpeg: 'image/jpeg',
            png: 'image/png',
            gif: 'image/gif',
            mp4: 'video/mp4',
            mov: 'video/quicktime',
            avi: 'video/x-msvideo'
        };
        
        form.append("file", fileBuffer, {
            filename,
            contentType: mimeTypes[ext] || 'application/octet-stream'
        });

        // Get form payload synchronously
        const formBuffer = form.getBuffer();
        const timestamp = Math.floor(Date.now() / 1000).toString();
        const method = "POST";
        const endpoint = "/inference/";

        // Construct message using the full form payload
        const message = method + endpoint + timestamp;
        const messageBuffer = Buffer.concat([
            Buffer.from(message, 'utf-8'),
            formBuffer
        ]);

        const signature = crypto
            .createHmac('sha256', CRACKS_SECRET_KEY ?? key)
            .update(messageBuffer)
            .digest('hex');

        // Send the request
        const response = await axios.post(`${BASE_URL}${endpoint}`, form, {
            headers: {
                ...form.getHeaders(),
                'x-timestamp': timestamp,
                'x-signature': signature,
            }
        });

        if (notify) {
            sendNotification({
                userId: userId,
                title: "Résultat de Fissure Disponible",
                message: `L'analyse de fissure pour l'image ${path} est terminée ! Connectez-vous à l'application pour découvrir les résultats.`,
            });
        }
        
        return response.data;
    } catch (error: any) {
        console.error("Error trying to infer on image:", error?.response?.data || error.message);
        return { error: error?.response?.data || error.message };
    }
};