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

path = "C:/Users/20175/Desktop/IMAGE/"
#HOST = "210.115.230.154"
HOST = "127.0.0.1"
#PORT = 8088
PORT = 9999

v_path = path + "video_img.png"
w_path = path + "webcam_img.png"
vframe = cv2.imread(v_path)
wframe = cv2.imread(w_path)
vheight, vwidth, vchannels = vframe.shape
wheight, wwidth, wchannels = wframe.shape

stringData = imageToString(vframe)

#vcapture = cv2.VideoCapture(path + "video_img.png", cv2.CAP_IMAGES)  # video
# wcapture = cv2.VideoCapture(path + "webcam_img.png")  # webcam
#vwidth, vheight = int(vcapture.get(3)), int(vcapture.get(4))

#vret, vframe = vcapture.read()
# wret, wframe = wcapture.read()


#cv2.imshow("video", vframe)
#cv2.imshow("webcam", wframe)
#cv2.waitKey()

v_stringData = imageToString(vframe)
w_stringData = imageToString(wframe)

client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client_socket.connect((HOST, PORT))

client_socket.send(str(len(v_stringData)).ljust(16).encode())
client_socket.send(v_stringData)

client_socket.send(str(len(w_stringData)).ljust(16).encode())
client_socket.send(w_stringData)
client_socket.close()