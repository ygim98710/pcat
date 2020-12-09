import cv2
import datetime

video_path = "train_sample.mp4"
interval = 10

vcapture = cv2.VideoCapture(video_path) #video
wcapture = cv2.VideoCapture(0) #webcam

vwidth, vheight = int(vcapture.get(3)), int(wcapture.get(4))
capture_second, now_second = 0, 0

if not vcapture.isOpened():
    print("video opened error")
elif not wcapture.isOpened():
    print("webcam opened error")

while True:
    vret, vframe = vcapture.read()
    wret, wframe = wcapture.read()

    cv2.imshow("VideoFrame", vframe)
    cv2.imshow("WebCamFrame", wframe)

    if not vret:
        print("video frame error")
        break
    elif not wret:
        print("webcam frame error")
        break

    now = datetime.datetime.now()
    now_second = now.second

    key = cv2.waitKey(1)
    if abs(capture_second - now_second) >= interval:
        capture_second = now_second
        image_name = str(now.strftime("%d_%H-%M-%S"))
        print("capture"+str(capture_second))

        cv2.imwrite("v_" + image_name + ".png", vframe)
        cv2.imwrite("w_" + image_name + ".png", wframe)

    if key == 27: # esc
        print("esc")
        break

vcapture.release()
wcapture.release()
cv2.destroyAllWindows()

