import socket
import cv2
import numpy
import datetime
import glob
import os

HOST = 'localhost'
PORT = 9999
interval = 10
HOST = "210.115.230.154"
PORT = 8088

path = "C:/Users/20175/Desktop/IMAGE/"
capture_second, now_second = 0, 0

def imageToString(frame):
    # 추출한 이미지를 String 형태로 변환(인코딩)시키는 과정
    encode_param = [int(cv2.IMWRITE_JPEG_QUALITY), 90]
    result, imgencode = cv2.imencode('.png', frame, encode_param)
    data = numpy.array(imgencode)
    stringData = data.tostring()
    return stringData

def ImageSend(path):
    #client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    #client_socket.connect((HOST, PORT))

    v_path = path + "video_img.png"
    w_path = path + "webcam_img.png"
    vframe = cv2.imread(v_path)
    wframe = cv2.imread(w_path)
    vheight, vwidth, vchannels = vframe.shape
    wheight, wwidth, wchannels = wframe.shape

    stringData = imageToString(vframe)
    #client_socket.send(str(len(stringData)).ljust(16).encode())
    #client_socket.send(stringData)
    #client_socket.close()

while True:
    key = cv2.waitKey(1)

    now = datetime.datetime.now()
    now_second = now.second

    if abs(capture_second - now_second) >= interval:
        capture_second = now_second

        ImageSend(path)
        print("Send")

    if key == 27: # esc
        print("esc")
        break
