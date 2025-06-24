import fs from 'fs';
import { IncomingForm } from 'formidable';
import { v2 as cloudinary } from 'cloudinary';

cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME!,
  api_key: process.env.CLOUDINARY_API_KEY!,
  api_secret: process.env.CLOUDINARY_API_SECRET!
});

export default defineEventHandler(async (event) => {
  const form = new IncomingForm();
  const data: any = await new Promise((resolve, reject) => {
    form.parse(event.node.req, (err, fields, files) => {
      if (err) reject(err)
      else resolve({ fields, files })
    })
  });
  const file = data.files.file[0];
  const result = await cloudinary.uploader.upload(file.filepath, {
    resource_type: 'auto' // accepts image, video, etc.
  })

  return {
    status: 'success',
    fileUrl: result.secure_url,
    message: 'File uploaded successfully',
  };
})

/*import path from "path";
import { promises as fs } from "fs";

export default defineEventHandler(async (event) => {
  // Define allowed file types (MIME types)
  /*const allowedMimeTypes = [
    'image/jpeg',
    'image/png',
    'image/gif',
    'video/mp4',
    'video/webm',
    'video/ogg'
  ];/

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
  }/

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
});*/