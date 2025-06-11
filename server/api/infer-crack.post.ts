import fs from "fs";
import axios from "axios";
import crypto from "crypto";
import FormData from "form-data";

const CRACKS_SECRET_KEY = process.env.CRACKS_SECRET_KEY!;
const BASE_URL = process.env.CRACKS_API_URL || "http://localhost:8000";

export default defineEventHandler(async (event) => {
    const body = await readBody<{ path: string, userId: string }>(event);

    if (!body.path || !body.userId) {
        return { error: "No image path or user id provided." };
    }

    try {
        const imageBuffer = fs.readFileSync(body.path);
        const timestamp = Math.floor(Date.now() / 1000).toString();
        const method = "POST";
        const endpoint = "/inference/";
        const message = method + endpoint + timestamp + imageBuffer.toString('latin1');

        const signature = crypto
            .createHmac('sha256', CRACKS_SECRET_KEY)
            .update(message)
            .digest('hex');

        const form = new FormData();
        form.append("file", imageBuffer, {
            filename: body.path.split('/').pop(),
            contentType: "image/jpeg"
        });

        const response = await axios.post(`${BASE_URL}${endpoint}`, form, {
            headers: {
                ...form.getHeaders(),
                'x-timestamp': timestamp,
                'x-signature': signature,
            }
        });

        sendNotification({
            userId: body.userId,
            title: "Résultat de Fissure Disponible",
            message: `L'analyse de fissure pour l'image ${body.path} est terminée ! Connectez-vous à l'application pour découvrir les résultats.`,
        });
        
        return response.data;
    } catch (error: any) {
        console.error("Error trying to infer on image:", error?.response?.data || error.message);
        return { error: error?.response?.data || error.message };
    }
});
