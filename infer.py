import os
import cv2
import tempfile
from ultralytics import YOLO
from collections import Counter

# Load YOLO model
model = YOLO("model/best.pt")  # path to your .pt model

CONF_THRESHOLD = 0.4


def analyze_image(img_path):
    """
    Analyze a single image using Ultralytics YOLO model.
    """
    results = model(img_path)[0]  # run inference and get first result

    class_ids = [
        int(box.cls)
        for box in results.boxes
        if float(box.conf) >= CONF_THRESHOLD
    ]

    class_counts = dict(Counter(class_ids))

    return {
        "type": "image",
        "valid_detections": len(class_ids),
        "confidence_threshold": CONF_THRESHOLD,
        "class_distribution": class_counts,
    }


def analyze_video(vid_path, frame_interval=5):
    """
    Analyze a video by extracting frames and processing them using YOLO.
    """
    cap = cv2.VideoCapture(vid_path)
    frame_count = 0
    valid_classes = []

    while cap.isOpened():
        success, frame = cap.read()
        if not success:
            break

        if frame_count % frame_interval == 0:
            results = model(frame, verbose=False)[0]

            for box in results.boxes:
                if float(box.conf) >= CONF_THRESHOLD:
                    valid_classes.append(int(box.cls))

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
    Handle UploadFile object by saving to temp file and analyzing.
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
    for i in range(2, 7):
        print(f"Analysing image {i}")
        print(analyze_image(rf"C:\Users\dunam\Downloads\mould walls\m{i}.jpg"))
        print("\n")
