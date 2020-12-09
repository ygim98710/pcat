import cv2
import math


image3=[(385, 91), (385, 143), (332, 169), (262, 169), (192, 156), (438, 169), (525, 156), (595, 143), (350, 326), (315, 444), (280, 535), (420, 326), (455, 444), (490, 522), (385, 248)]
image4=[(225, 136), (225, 212), (184, 212), (123, 151), (92, 121), (277, 212), (318, 167), (359, 106), (184, 349), (184, 471), (205, 577), (236, 364), (266, 501), (236, 577), (215, 288)]
image5=[(175, 91), (175, 148), (144, 171), (91, 182), (38, 205), (205, 171), (243, 194), (289, 216), (159, 273), (152, 365), (144, 467), (190, 273), (197, 365), (197, 456), (175, 228)]

points=[(3,2,1),(14,1,2),(4,3,2),(6,5,1),(7,6,5),(11,14,1),(9,8,14),(10,9,8),(12,11,14),(13,12,11)]

result1=[]
result2=[]
result3=[]


def calAngle(img):
    angArr=[]
    for i in range(10):
        n1 = points[i][0]
        n2 = points[i][1]
        n3 = points[i][2]

        #print('img[n1]: ', img[n1], ' img[n2]: ', img[n2], ' img[n3]: ', img[n3])
        ang = math.degrees(
            math.atan2(img[n3][1] - img[n2][1], img[n3][0] - img[n2][0]) - math.atan2(img[n1][1] - img[n2][1],img[n1][0] - img[n2][0]))

        if (ang < 0):
            ang += 360

        angArr.append(round(ang,2))
        print(i, ':result: ', ang)
    return angArr


def calScore(res1,res2):
    cnt,total = 0,0
    state=""

    for i in range(10):
        num = abs(res1[i] - res2[i])
        if num > 10:
            cnt += 1
            total += num;
    if cnt>6: state="bad"
    elif cnt<=6 and cnt>3: state="good"
    elif cnt<=3: state="perfect"

    print('10도 이상 개수:',cnt, '총합:',total , "state: ",state)

result1=calAngle(image3)
result2=calAngle(image4)
result3=calAngle(image5)

print('사진1',result1)
print('사진2',result2)
print('사진3',result3)

calScore(result1,result2)
calScore(result1,result3)
calScore(result2,result3)
