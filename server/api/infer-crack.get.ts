import axios from "axios";

const BASE_URL = process.env.CRACKS_API_URL || "http://localhost:8000";

export default defineEventHandler(async (event) => {
    try {
        const response = await axios.get(`${BASE_URL}/metrics`);
        console.log(response.data);
        return response.data;
    } catch (error) {
        console.error(`Could not get training parameters: ${error}`);
    }
});