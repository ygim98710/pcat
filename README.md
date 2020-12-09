# 개요
2020-2 캡스톤 디자인(openpos를 이용한 홈 트레이닝 서비스)

# 팀
- 팀명 : Pcat(피켓)
- 팀원 및 역할
    * 김윤하 : 웹 개발, OpenPose 이용한 정확도 계산, 서버 구축
    * 김진아 : 웹 개발 및 디자인, OpenPose 이용한 정확도 계산
- 지도교수님 : 김백섭 교수님

# 작품설명
- 개발목표
   * OpenPose 라이브러리를 이용해 두 이미지의 신체 골격 추출
   * 두 신체 골격의 일치율 계산
   * 사용자가 이용하기 편리한 웹 서비스 개발

# 개발환경
- Upuntu 18 
- tomcat 7.5
- mysql 
- Matrox MGA G200e (GPU)

# 프로젝트 구성도
![image](https://user-images.githubusercontent.com/55430276/101646961-87e12600-3a7b-11eb-85a7-6fbb6cdd93d3.png)

#openpose 이용
- 사용 전
![image](https://user-images.githubusercontent.com/55430276/101647173-c37bf000-3a7b-11eb-82e3-409c7b54231a.png)
- 사용 후
![image](https://user-images.githubusercontent.com/55430276/101647183-c545b380-3a7b-11eb-98c7-e469193d4380.png)

# 활용방안 및 기대효과
 - 기존의 홈 트레이닝 서비스는 혼자서 운동을 하기 때문에, 정확한 자세 체크를 못 했지만, 저희의 서비스를 사용하면 바로바로 자신의 운동 자세를 체크 할 수 있을 것입니다. 또한, 기존의 홈 트레이닝 서비스보다 한 단계 발전형으로 1인 개인별 코칭 서비스가 증가할 것으로 보입니다.

# 디렉토리 구조
 - etc : openpose를 하는 데 사용되는 prototxt 파일과 caffee 파일
 - mid-data : 시연영상을 찍는 도중에 내부적으로 사용자의 골격 파악하는 것을 저장한 사진들
 - presentation : 발표 ppt와 포스터
 - source : 실행과 관계가 있는 폴더들
 - source_test : 프로젝트를 진행하면서 작성된 파일들(실행과는 관계 없음)