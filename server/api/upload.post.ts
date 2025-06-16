import { promises as fs } from "fs";
import path from "path";

export default defineEventHandler(async (event) => {
  // Define allowed file types (MIME types)
  /*const allowedMimeTypes = [
    'image/jpeg',
    'image/png',
    'image/gif',
    'video/mp4',
    'video/webm',
    'video/ogg'
  ];*/

  const formData = await readMultipartFormData(event);

  // Use a generic name "file" for the form field
  const file = formData?.find(item => item.name === 'file');

  // Early exit if no file is found
  if (!file || !file.data || !file.filename) {
    throw createError({
      statusCode: 400,
      statusMessage: 'No file uploaded or data is missing.',
    });
  }

  // --- SECURITY: Validate the file's MIME type ---
  /*if (!allowedMimeTypes.includes(file.type!)) {
    throw createError({
      statusCode: 415, // Unsupported Media Type
      statusMessage: `Unsupported file type. Please upload one of: ${allowedMimeTypes.join(', ')}`,
    });
  }*/

  const uploadDir = path.join(process.cwd(), 'public/uploads');

  try {
    await fs.access(uploadDir);
  } catch {
    await fs.mkdir(uploadDir, { recursive: true });
  }

  const uniqueFilename = `${Date.now()}-${file.filename}`;
  const filePath = path.join(uploadDir, uniqueFilename);

  await fs.writeFile(filePath, file.data);

  const fileUrl = `/uploads/${uniqueFilename}`;

  return {
    status: 'success',
    fileUrl,
    message: 'File uploaded successfully',
  };
});