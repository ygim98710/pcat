import socket
import cv2
import glob
import numpy
import math

# MPII에서 각 파트 번호, 선으로 연결될 POSE_PAIRS
BODY_PARTS = {"Head": 0, "Neck": 1, "RShoulder": 2, "RElbow": 3, "RWrist": 4,
              "LShoulder": 5, "LElbow": 6, "LWrist": 7, "RHip": 8, "RKnee": 9,
              "RAnkle": 10, "LHip": 11, "LKnee": 12, "LAnkle": 13, "Chest": 14,
              "Background": 15}

POSE_PAIRS = [["Head", "Neck"], ["Neck", "RShoulder"], ["RShoulder", "RElbow"],
              ["RElbow", "RWrist"], ["Neck", "LShoulder"], ["LShoulder", "LElbow"],
              ["LElbow", "LWrist"], ["Neck", "Chest"], ["Chest", "RHip"], ["RHip", "RKnee"],
              ["RKnee", "RAnkle"], ["Chest", "LHip"], ["LHip", "LKnee"], ["LKnee", "LAnkle"]]

POSE_CHECK = [["Head", "Neck"], ["Neck", "Chest"], ["LElbow", "LWrist"], ["LElbow", "LWrist"],
              ["RShoulder", "RElbow"], ["RElbow", "RWrist"], ["LHip", "LKnee"], ["LKnee", "LAnkle"],
              ["RHip", "RKnee"], ["RKnee", "RAnkle"]]

BODY_LOCATION = [[0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0],
                 [0, 0], [0, 0], [0, 0], [0, 0], [0, 0]]

# 각 파일 path
protoFile = "pose_deploy_linevec_faster_4_stages.prototxt"
weightsFile = "pose_iter_160000.caffemodel"

def angel(x1, y1, x2, y2):
    dx = abs(x2 - x1)
    dy = abs(y2 - y1)

    rad = math.atan2(dy, dx)
    degree = rad * 180 / 3.14159265
    return degree

def image_openpose(image_path):
    # 위의 path에 있는 network 불러오기
    net = cv2.dnn.readNetFromCaffe(protoFile, weightsFile)
    # 이미지 읽어오기
    image = image_path
    # frame.shape = 불러온 이미지에서 height, width, color 받아옴
    imageHeight, imageWidth, _ = image.shape
    # network에 넣기위해 전처리
    inpBlob = cv2.dnn.blobFromImage(image, 1.0 / 255, (imageWidth, imageHeight), (0, 0, 0), swapRB=False, crop=False)
    # network에 넣어주기
    net.setInput(inpBlob)
    # 결과 받아오기
    output = net.forward()

    # output.shape[0] = 이미지 ID, [1] = 출력 맵의 높이, [2] = 너비
    H = output.shape[2]
    W = output.shape[3]
    #print("이미지 ID : ", len(output[0]), ", H : ", output.shape[2], ", W : ", output.shape[3])  # 이미지 ID

    # 키포인트 검출시 이미지에 그려줌
    points = []
    for i in range(0, 15):
        # 해당 신체부위 신뢰도 얻음.
        probMap = output[0, i, :, :]

        # global 최대값 찾기
        minVal, prob, minLoc, point = cv2.minMaxLoc(probMap)

        # 원래 이미지에 맞게 점 위치 변경
        x = (imageWidth * point[0]) / W
        y = (imageHeight * point[1]) / H

        # 키포인트 검출한 결과가 0.1보다 크면(검출한곳이 위 BODY_PARTS랑 맞는 부위면) points에 추가, 검출했는데 부위가 없으면 None으로
        if prob > 0.1:
            cv2.circle(image, (int(x), int(y)), 3, (0, 255, 255), thickness=-1,
                       lineType=cv2.FILLED)  # circle(그릴곳, 원의 중심, 반지름, 색)
            cv2.putText(image, "{}".format(i), (int(x), int(y)), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 255), 1,
                        lineType=cv2.LINE_AA)
            points.append((int(x), int(y)))

            BODY_LOCATION[i] = [x, y]
        else:
            points.append(None)

    cv2.imshow("Output-Keypoints", image)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

    #imageCopy = image

    angel_list = []

    # 각 POSE_PAIRS별로 선 그어줌 (머리 - 목, 목 - 왼쪽어깨, ...)
    for pair in POSE_PAIRS:
        partA = pair[0]  # Head
        partA = BODY_PARTS[partA]  # 0
        partB = pair[1]  # Neck
        partB = BODY_PARTS[partB]  # 1

        x1, y1 = BODY_LOCATION[partA]
        x2, y2 = BODY_LOCATION[partB]
        print(partA, " 와 ", partB, " 연결")
        print(partA, "의 x : ", x1, ", y :", y1)
        print(partB, "의 x : ", x2, ", y :", y2)
        ang = angel(x1, y1, x2, y2)
        print("각도 : ", ang)
        angel_list.append(ang)

    #cv2.imshow("output", imageCopy)
    #cv2.waitKey(0)
    return angel_list

#socket 수신 버퍼를 읽어서 반환하는 함수
def recvall(sock, count):
    buf = b''
    while count:
        newbuf = sock.recv(count)
        if not newbuf: return None
        buf += newbuf
        count -= len(newbuf)
    return buf

HOST = ''
#PORT = 8080
PORT = 9999

server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
server_socket.bind((HOST, PORT))
server_socket.listen(5)

while True:
    client_socket, addr = server_socket.accept()
    print('Connected by', addr)

    v_length = recvall(client_socket, 16)
    v_stringData = recvall(client_socket, int(v_length))
    v_data = numpy.fromstring(v_stringData, dtype='uint8')
    v_decimg=cv2.imdecode(v_data,1)

    w_length = recvall(client_socket, 16)
    w_stringData = recvall(client_socket, int(w_length))
    w_data = numpy.fromstring(w_stringData, dtype='uint8')
    w_decimg = cv2.imdecode(w_data, 1)

    client_socket.close()

    v_angel_list = image_openpose(v_decimg)
    w_angel_list = image_openpose(w_decimg)

    angel_diffs = []
    for i in range(0, len(v_angel_list)):
        angel_diffs.append(abs(v_angel_list[i] - w_angel_list[i]))
    #print(angel_diffs)

    print("acuurenty : ", 100 - (sum(angel_diffs) / sum(v_angel_list) * 100))

    #cv2.waitKey(0)
    #cv2.destroyAllWindows()

cv2.destroyAllWindows()
server_socket.close()
