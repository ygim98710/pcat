import cv2
import glob
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
    image = cv2.imread(image_path)
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
    # print("이미지 ID : ", len(output[0]), ", H : ", output.shape[2], ", W : ", output.shape[3])  # 이미지 ID

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

    #cv2.imshow("Output-Keypoints", image)

    # 이미지 복사
    imageCopy = image

    angel_list = []

    for pair in POSE_CHECK:
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
    # 각 POSE_PAIRS별로 선 그어줌 (머리 - 목, 목 - 왼쪽어깨, ...)
    for pair in POSE_PAIRS:
        partA = pair[0]  # Head
        partA = BODY_PARTS[partA]  # 0
        partB = pair[1]  # Neck
        partB = BODY_PARTS[partB]  # 1

        print(partA," 와 ", partB, " 연결\n")
        if points[partA] and points[partB]:
            cv2.line(imageCopy, points[partA], points[partB], (0, 255, 0), 2)

    cv2.imshow("output", imageCopy)
    #cv2.imwrite("p_" + image_path + ".png", imageCopy)
    cv2.waitKey(0)
    return angel_list


image_list = glob.glob("Test3/*.png")
for i in image_list:
    print("image path : " + i)
    image_openpose(i)

#image2 = image_list[1]
#print("image path : " + image2)
#angel_list2 = image_openpose(image2)

#image3 = image_list[2]
#print("image path : " + image3)
#angel_list3 = image_openpose(image3)

#image4_list = glob.glob("./temp/v_10_17-08-00.png")
#image4 = image4_list[0]
#print("image path : " + image4)
#angel_list4 = image_openpose(image4)

#angel_diffs1 = []
#for i in range(0, len(angel_list1)):
#    angel_diffs1.append(abs(angel_list1[i] - angel_list2[i]))
#print(angel_diffs1)

#angel_diffs2 = []
#for i in range(0, len(angel_list1)):
#    angel_diffs2.append(abs(angel_list1[i] - angel_list3[i]))
#print(angel_diffs2)

#angel_diffs3 = []
#for i in range(0, len(angel_list2)):
#    angel_diffs3.append(abs(angel_list2[i] - angel_list3[i]))
#print(angel_diffs3)

#angel_diffs2to4 = []
#for i in range(0, len(angel_list2)):
#    angel_diffs3.append(abs(angel_list2[i] - angel_list4[i]))
#print(angel_diffs2to4)

#print("첫번째 사진 각도 리스트 합 : ", sum(angel_list1))
#print("두번째 사진 각도 리스트 합 : ", sum(angel_list2))
#print("세번째 사진 각도 리스트 합 : ", sum(angel_list3))
#print("네번째 사진 각도 리스트 합 : ", sum(angel_list4))

#print("첫번째-두번째 사진 각도 차이 리스트 합 : ", sum(angel_diffs1))
#print("첫번째-세번째 사진 각도 차이 리스트 합 : ", sum(angel_diffs2))
#print("두번째-네번째 사진 각도 차이 리스트 합 : ", sum(angel_diffs2to4))

# 일부값 ÷ 전체값 X 100
#print("첫번째-두번째 정확도율 : ", 100 - (sum(angel_diffs1) / sum(angel_list1) * 100))
#print("첫번째-세번째 정확도율 : ", 100 - (sum(angel_diffs2) / sum(angel_list1) * 100))
#print("두번째-네번째 정확도율 : ", 100 - (sum(angel_diffs2to4) / sum(angel_list2) * 100))

cv2.destroyAllWindows()

