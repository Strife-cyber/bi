from ultralytics import YOLO

model = YOLO("model/best.pt")

def inference(img):
    """
    This is responsible for the inference of the presence of a crack on a particular image
    We train the model using YOLO 11s and has around 89% accuracy
    :param img: The path to the image file, the image itself or even a numpy array the model is supposed to infer from
    :return: The boxes, scores, classes etc.
    """
    results = model(img)
    # Uncomment this line to show the image with the inference
    # results[0].show()
    return results[0]
