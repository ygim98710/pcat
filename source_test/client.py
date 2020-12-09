import socket
import cv2
import numpy
import datetime
import glob
import os

def imageToString(frame):
    # 추출한 이미지를 String 형태로 변환(인코딩)시키는 과정
    encode_param = [int(cv2.IMWRITE_JPEG_QUALITY), 90]
    result, imgencode = cv2.imencode('.png', frame, encode_param)
    data = numpy.array(imgencode)
    stringData = data.tostring()
    return stringData

video_path = "train_sample.mp4"
interval = 10
#HOST = '127.0.0.1'
HOST = "210.115.230.154"
#PORT = 9999
PORT = 8080

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
    #wret, wframe = wcapture.read()

    cv2.imshow("VideoFrame", vframe)
    #cv2.imshow("WebCamFrame", wframe)

    if not vret:
        print("video frame error")
        break
    #elif not wret:
    #    print("webcam frame error")
    #    break

    now = datetime.datetime.now()
    now_second = now.second

    key = cv2.waitKey(1)
    if abs(capture_second - now_second) >= interval:
        capture_second = now_second
        image_name = str(now.strftime("%d_%H-%M-%S"))
        print("capture"+str(capture_second))

        cv2.imwrite("v_" + image_name + ".png", vframe)
        #cv2.imwrite("w_" + image_name + ".png", wframe)

        client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        client_socket.connect((HOST, PORT))
        #client_socket.send("v_"+image_name+".png")

        stringData = imageToString(vframe)
        client_socket.send(str(len(stringData)).ljust(16).encode());
        client_socket.send(stringData);
        client_socket.close()
        print("Send")

    if key == 27: # esc
        print("esc")
        break

vcapture.release()
wcapture.release()
cv2.destroyAllWindows()