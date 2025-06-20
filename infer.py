import os
import cv2
import tempfile
import numpy as np
import tensorflow as tf
from collections import Counter

# Load TensorFlow Lite model
interpreter = tf.lite.Interpreter(model_path="model/best_float32.tflite")
interpreter.allocate_tensors()

# Get model input/output details
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

CONF_THRESHOLD = 0.40
INPUT_SIZE = tuple(input_details[0]['shape'][1:3])  # (height, width)

def preprocess_image(img):
    """
    Resize and normalize image for the model.
    """
    image = cv2.resize(img, INPUT_SIZE)
    image = image.astype(np.float32) / 255.0
    return np.expand_dims(image, axis=0)

def analyze_image(img_path):
    """
    Analyze a single image using the .tflite model.
    """
    img = cv2.imread(img_path)
    if img is None:
        raise ValueError(f"Unable to load image: {img_path}")

    input_tensor = preprocess_image(img)
    interpreter.set_tensor(input_details[0]['index'], input_tensor)
    interpreter.invoke()
    preds = interpreter.get_tensor(output_details[0]['index'])[0]

    valid_indices = np.where(preds >= CONF_THRESHOLD)[0]
    class_counts = {int(i): 1 for i in valid_indices}

    return {
        "type": "image",
        "valid_detections": len(valid_indices),
        "confidence_threshold": CONF_THRESHOLD,
        "class_distribution": class_counts,
    }

def analyze_video(vid_path, frame_interval=5):
    """
    Analyze a video by extracting and processing frames using the .tflite model.
    """
    cap = cv2.VideoCapture(vid_path)
    frame_count = 0
    valid_classes = []

    while cap.isOpened():
        success, frame = cap.read()
        if not success:
            break

        if frame_count % frame_interval == 0:
            input_tensor = preprocess_image(frame)
            interpreter.set_tensor(input_details[0]['index'], input_tensor)
            interpreter.invoke()
            preds = interpreter.get_tensor(output_details[0]['index'])[0]

            for i, conf in enumerate(preds):
                if conf >= CONF_THRESHOLD:
                    valid_classes.append(i)

        frame_count += 1

    cap.release()
    class_counts = dict(Counter(valid_classes))
    return {
        "type": "video",
        "total_frames": frame_count,
        "frames_analyzed": frame_count // frame_interval,
        "valid_detections": len(valid_classes),
        "confidence_threshold": CONF_THRESHOLD,
        "class_distribution": class_counts,
    }

def is_video(filename: str):
    video_exts = ['.mp4', '.avi', '.mov', '.mkv', '.webm']
    return os.path.splitext(filename)[1].lower() in video_exts

async def run_analysis(upload_file):
    """
    Handle UploadFile object by saving to temp file.
    """
    suffix = os.path.splitext(upload_file.filename)[1]
    with tempfile.NamedTemporaryFile(delete=False, suffix=suffix) as temp_file:
        contents = await upload_file.read()
        temp_file.write(contents)
        temp_path = temp_file.name

    try:
        if is_video(upload_file.filename):
            result = analyze_video(temp_path)
        else:
            result = analyze_image(temp_path)
    finally:
        os.unlink(temp_path)

    return result

if __name__ == "__main__":
    print(analyze_image(r"C:\Users\Strife-Cyber\Downloads\m1.jpg"))
