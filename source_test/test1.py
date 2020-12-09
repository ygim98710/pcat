import cv2
import glob
import math
import datetime

# MPII에서 각 파트 번호, 선으로 연결될 POSE_PAIRS
BODY_PARTS = {"Head": 0, "Neck": 1, "RShoulder": 2, "RElbow": 3, "RWrist": 4,
              "LShoulder": 5, "LElbow": 6, "LWrist": 7, "RHip": 8, "RKnee": 9,
              "RAnkle": 10, "LHip": 11, "LKnee": 12, "LAnkle": 13, "Chest": 14,
              "Background": 15}

POSE_PAIRS = [["Head", "Neck"], ["Neck", "RShoulder"], ["RShoulder", "RElbow"],
              ["RElbow", "RWrist"], ["Neck", "LShoulder"], ["LShoulder", "LElbow"],
              ["LElbow", "LWrist"], ["Neck", "Chest"], ["Chest", "RHip"], ["RHip", "RKnee"],
              ["RKnee", "RAnkle"], ["Chest", "LHip"], ["LHip", "LKnee"], ["LKnee", "LAnkle"]]

# 각 파일 path
protoFile = "pose_deploy_linevec_faster_4_stages.prototxt"
weightsFile = "pose_iter_160000.caffemodel"

wcapture = cv2.VideoCapture(0) #webcam
wwidth, wheight = int(wcapture.get(3)), int(wcapture.get(4))
capture_second, now_second = 0, 0
interval = 3

while True:
    now = datetime.datetime.now()
    now_second = now.second
    wret, wframe = wcapture.read()
    cv2.imshow("WebCamFrame", wframe)
    key = cv2.waitKey(1)

    if abs(capture_second - now_second) >= interval:
        capture_second = now_second
        image_name = str(now.strftime("%d_%H-%M-%S"))

        cv2.imwrite("w_" + image_name + ".png", wframe)

    if key == 27: # esc
        print("esc")
        break

wcapture.release()
cv2.destroyAllWindows()