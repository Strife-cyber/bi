import path from 'path';
import dotenv from 'dotenv';
import cracked from '../utils/cracked'; // Adjust path to match your file
import { describe, it, expect } from 'vitest';

dotenv.config(); // Loads .env for CRACKS_SECRET_KEY and CRACKS_API_URL

describe('loaded .env', () => {
  it('should display the .env variables', () => {
    console.log(process.env.CRACKS_SECRET_KEY);
    expect(process.env.CRACKS_SECRET_KEY).toBeDefined();
  })
})

describe('cracked inference', () => {
  it('should upload an image and return a result', async () => {
    const imagePath = path.resolve('C:/Users/Strife-Cyber/Downloads/b-cracks/i-1.webp');
    const userId = 'test-user-id';

    const result = await cracked(imagePath, userId, false, process.env.CRACKS_SECRET_KEY);

    console.log(result); // optional, for debug

    expect(result).toBeDefined();
    expect(result).not.toHaveProperty('error');
    // Optionally assert on specific fields if you know the expected output structure
    // expect(result).toHaveProperty('label');
  });
});
