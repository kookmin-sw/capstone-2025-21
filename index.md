# menu : 당신의 언어로, 당신의 취향을 기반으로, 메뉴를 추천해줍니다.

```
작성예정
```


# 🗂️프로젝트 소개
```
작성예정
```

## 관련 문서 
- 📃주제 정의 문서 -> <a href="https://github.com/kookmin-sw/capstone-2025-21/wiki/주제-정의-문서">문서 바로가기</a>
- 📈Market potential & Business model -> <a href="https://github.com/kookmin-sw/capstone-2025-21/wiki/Market-potential-&-Business-model">문서 바로가기</a>
- 🙋‍♂️ 페르소나 분석 -> <a href="https://github.com/kookmin-sw/capstone-2025-21/wiki/페르소나-분석">문서 바로가기</a>

### 🗒사용자 정의 문서

<details>
 <summary>📈시스템 흐름도</summary>
 
 ### User-case Diagram
 <p align='center'><img src="https://user-images.githubusercontent.com/40621030/134690667-abe8f797-01a8-44db-ae89-ef7809c22d64.png"/></p>
 
 ### Sequence Diagram
  <p align='center'><img src="https://user-images.githubusercontent.com/40621030/136720501-bbe98072-abbc-4797-a0c2-c66771f7e04a.png"/></p>
 
 ### Architecture
  <p align='center'><img src="https://user-images.githubusercontent.com/40621030/136720255-0456ffd4-4d7d-4d2e-b5c5-09387c5861fa.png"/></p>
</details>

<details>
 <summary>🖊개발 문서</summary>



</details>

# 🗂️ 개발 과정 설명

## AI
```
작성예정
```
## Front
```
작성예정
```
## Back
```
작성예정
```




# 📔기능 설명

```
작성예정
```

---

## 🔨기술 스택 (Technique Used) 
### Server(back-end)
<table>
 <tr>
  <td><a href='https://nodejs.org/ko/'><img src='https://user-images.githubusercontent.com/40621030/136699173-a5a2e626-9161-4e30-85fd-93898671896e.png' height=80/></a></td>
  <td><a href='https://www.mysql.com/'><img src='https://user-images.githubusercontent.com/40621030/136699174-e540729d-0092-447c-b672-dfa5dcfd41a7.png' height=80/></a></td>
  <td><a href='https://www.goorm.io//'><img src='https://res.cloudinary.com/crunchbase-production/image/upload/c_lpad,f_auto,q_auto:eco,dpr_1/uifol9klj1ht0squxhje' width = 200 height=120/></a></td>
 </tr>
 <tr>
  <td align='center'>Node js</td>
  <td align='center'>MySQL</td>
  <td align='center'>Goorm Server Deploy</td>
 </tr>
</table>

<details>
 <summary>Node js 설명</summary>

 ```
작성예정
```
 
 </details>
 
### Front-end
<table>
 <tr>
  <td align='center'><img src='https://user-images.githubusercontent.com/40621030/136700782-179675b0-9bae-4ecf-b94a-e73073d24be5.png' height=80></td>
  <td align='center'><img src='https://user-images.githubusercontent.com/19565940/137632602-01a7fc0f-00af-49af-bc96-8aee25b83a9d.png' height=80></td>
  <td align='center'><img src='https://user-images.githubusercontent.com/19565940/137632657-bf613560-c27e-4dcf-b229-024230185e3b.png' height=80></td>
 </tr>
 <tr>
  <td align='center'>Flutter</td>
  <td align='center'>Libraries from pub.dev</td>
  <td align='center'>Dart</td>
 </tr>
</table>
<details>
 <summary>Flutter / Dart Packages</summary>
 
- [`get: ^4.3.8`](https://pub.dev/packages/get)
- [`http: ^0.13.3`](https://pub.dev/packages/http)
- [`validators: ^3.0.0`](https://pub.dev/packages/validators)
- [`image: ^3.0.5`](https://pub.dev/packages/image)
- [`image_picker: ^0.8.4+2`](https://pub.dev/packages/image_picker)
- [`animated_text_kit: ^4.2.1`](https://pub.dev/packages/animated_text_kit)
- [`flutter_pw_validator: ^1.2.1`](https://pub.dev/packages/flutter_pw_validator)
- [`string_validator: ^0.3.0`](https://pub.dev/packages/string_validator)
- [`qr_flutter: ^4.0.0`](https://pub.dev/packages/qr_flutter)
- [`path_provider: ^2.0.5`](https://pub.dev/packages/path_provider)
- [`url_launcher: ^6.0.12`](https://pub.dev/packages/url_launcher)
- [`cupertino_icons: ^0.1.2`](https://pub.dev/packages/cupertino_icons)


</details>



### AI
 <table>
 <tr>
  <td><a href="https://pytorch.org/"><img src='https://user-images.githubusercontent.com/40621030/136698820-2c869052-ff44-4629-b1b9-7e1ae02df669.png' height=80></a></td>
  <td><a href="https://opencv.org/"><img src='https://user-images.githubusercontent.com/40621030/136698821-10434eb5-1a98-4108-8082-f68297012724.png' height=80></a></td>
  <td><a href="https://cvat.org/"><img src='https://user-images.githubusercontent.com/40621030/136698825-f2e1816f-580b-4cf1-960d-295e9f18a329.png' height=80></a></td>
  <td><a href="https://roboflow.com/"><img src='https://user-images.githubusercontent.com/40621030/136698826-e18a44a9-63d1-498b-a63f-c76bdc603f3b.png' height=80></a></td>
 </tr>
 <tr>
  <td align='center'>PyTorch</td>
  <td align='center'>OpenCV</td>
  <td align='center'>CVAT</td>
  <td align='center'>Roboflow</td>
 </tr>
 </table>
 <details>
 <summary>📝AI 설명</summary>
 
### Object detection VS Semantic segmentation

- Semantic segmentation: 사람을 제외한 배경을 처리
  난이도: 상대적으로 낮음(사람을 대상으로 학습된 model 사용)
  장점: 기존 모델을 사용 시 사람을 깔끔하게 구별 가능
  단점: 오직 사람/배경만 구별 가능, 사람 앞의 물체에 대해선 감지하지 못할 수 있음
  (ex: 기밀 문서를 들고 있는 사람)
  
- Object detection: 학습한 Class들을 사진 안에서 검출하여 처리
  난이도: 상대적으로 높음(We need to get dataset, annotate them, train model...)
  장점: 여러 다양한 class들을 검출하여 사진의 상황을 대략적으로 파악 가능,
  보안 위반 객체는 detect만 된다면 처리 가능(보안성), 사람 이외의 객체들도 살려낼 수 있음
  단점: segmentation보다 상대적으로 깔끔하지 못한 사진 처리, 높은 데이터 수집 난이도와 큰 시간 소요
 
보다 높은 보안성을 중시하기로 결정 --> Object detection   
 
 ### 사용 데이터셋
 
### Version 1: [ImageNet Object Localization Challenge](https://www.kaggle.com/c/imagenet-object-localization-challenge)  
 <p align='center'><img src='https://user-images.githubusercontent.com/40621030/137607638-124c1622-6bfe-4a45-a16b-519314916436.jpg' width="500"/></p>  
 
 **문제점**  
 
 1. 데이터 수 부족
 2. 대다수 물체가 정중앙 위치
 3. 대다수 물체가 사진 전체를 차지
 
 **해결방안 1 - 데이터 추가**
 
 <table>
  <tr>
   <td align='center'>Orignal Dataset</td>
   <td align='center'>Add more data</td>
  </tr>
  <tr>
   <td align='center'><img src='https://user-images.githubusercontent.com/40621030/137607638-124c1622-6bfe-4a45-a16b-519314916436.jpg' width="500"/></td>
   <td align='center'><img src='https://user-images.githubusercontent.com/40621030/137607640-9552448f-a39c-4a46-9d50-a523002be0e4.jpg' width="500"/></td>
  </tr>
 </table>
 
 **해결방안 2, 3 - augmentation 방법 변경**  
 
 <table>
  <tr>
   <td align='center'>기존</td>
   <td align='center'>변경</td>
  </tr>
  <tr>
   <td align='center'><img src='https://user-images.githubusercontent.com/40621030/137607771-6509a1f3-872a-4bfd-ac0f-389e7dcd8fdc.jpeg' width="500"/></td>
   <td align='center'><img src='https://user-images.githubusercontent.com/40621030/137607774-68692b66-5324-4184-ba9a-e41151a6a561.jpeg' width="500"/></td>
  </tr>
 </table>
 
 ### 사용 모델
YOLOv5, Efficientnet, SSGlite 등의 모델들을 고려.  
성능과 학습에 들어가는 시간 등을 종합적으로 판단 --> YOLOv5 결정.
(Efficientnet: 학습 시간이 지나치게 많이 소요, SSGlite: YOLOv5보다 낮은 성능)

 - YOLOv5 ([original github](https://github.com/ultralytics/yolov5))  
<p align='center'><img src='https://user-images.githubusercontent.com/40621030/136682963-80100da0-c31c-4df4-8bff-583e1c1c62f1.png' width="500"/></p>

 **문제점**  
 
 <p align='center'><img src='https://user-images.githubusercontent.com/26833433/136901921-abcfcd9d-f978-4942-9b97-0e3f202907df.png' width="500"/></p>  
 

 1. 낮은 성능
 2. 무거운 모델 (ex. yolov5l6)
 
 **해결방안**  
 
 - knowledge distillation ([paper link](https://arxiv.org/abs/1906.03609)) 
   <p align='center'><img src='https://user-images.githubusercontent.com/40621030/136683028-fb1ca2f0-97c0-4581-9b7a-64e26536d7af.png' width="500"/></p>  
 
 ### 성능 향상 
 |          enhance       |   model  | precision | recall | mAP_0.5 | mAP_0.5:0.95 |
 |:----------------------:|:--------:|:---------:|:------:|:-------:|:------------:|
 |   Before add dataset   | yolov5m6 |   0.602   |  0.651 |  0.671  |     0.535    |  
 |   None (Add dataset)   | yolov5m6 |   0.736   |  0.779 |  0.815  |     0.599    |  
 |      mosaic_9 50%      | yolov5m6 |   0.756   |  0.775 |  0.809  |     0.602    |
 |      mosaic_9 100%     | yolov5m6 |   0.739   |  0.813 |  0.806  |     0.594    |
 | knowledge distillation | yolov5m6 |   0.722   |  0.822 |  0.807  |     0.592    |
 
 <table>
  <tr>
   <td align='center'>Original Image</td>
   <td align='center'>Result Image</td>
  </tr>
  <tr>
   <td align='center'><img src='https://user-images.githubusercontent.com/40621030/136698553-a00eb618-7783-41d9-bd2c-203dbbd60946.jpg' width="500"/></td>
   <td align='center'><img src='https://user-images.githubusercontent.com/40621030/136698552-42c71108-9efc-4c88-a68a-3f5aec8452c6.jpg' width="500"/></td>
  </tr>
 </table>
 
 ### 실행 및 예시 ([link](https://github.com/osamhack2021/AI_APP_WEB_Canary_Canary/tree/main/AI(BE)/deeplearning/kwoledge_distillation_yolov5))
</details>
---

## 💽설치 안내 (Installation Process)
```
작성예정
```

---

## 📱프로젝트 사용법 (Getting Started)
<!--
**마크다운 문법을 이용하여 자유롭게 기재**

잘 모를 경우
구글 검색 - 마크다운 문법
[https://post.naver.com/viewer/postView.nhn?volumeNo=24627214&memberNo=42458017](https://post.naver.com/viewer/postView.nhn?volumeNo=24627214&memberNo=42458017)

 편한 마크다운 에디터를 찾아서 사용
 샘플 에디터 [https://stackedit.io/app#](https://stackedit.io/app#)
-->
  ```
작성예정
```
  
 
---

## 📈프로젝트 전망
```
작성예정
```

### 🍎개선할 점
```
작성예정
```
---

## 🕋팀 정보 (Team Information)


<table>
 <tr>
  <td></td>
  <td>Name</td>
  <td>Role</td>
  <td>github</td>
  <td>e-mail</td>
 </tr>
   
 <tr>
  <td align='center'><img src="https://avatars.githubusercontent.com/u/86545225?v=4" width="50" height="50"></td>
  <td align='center'>박상혁</td>
  <td align='center'>Leader / AI</td>
  <td align='center'><a href="https://github.com/sanghyeok1000"><img src="http://img.shields.io/badge/sanghyeok1000-green?style=social&logo=github"/></a></td>
 </tr>

 <tr>
  <td align='center'><img src="https://avatars.githubusercontent.com/u/76638529?v=4" width="50" height="50"></td>
  <td align='center'>손원철 </td>
  <td align='center'>AI</td>
  <td align='center'><a href="https://github.com/sonwon9"><img src="http://img.shields.io/badge/sonwon9-green?style=social&logo=github"/></a></td>
 </tr>
 
 <tr>
  <td align='center'><img src="https://avatars.githubusercontent.com/u/54922625?v=4" width="50" height="50"></td>
  <td align='center'>류희재</td>
  <td align='center'>Front-End (iOS)</td>
  <td align='center'><a href="https://github.com/hellohidi"><img src="http://img.shields.io/badge/hellohidi-green?style=social&logo=github"/></a></td>
 </tr>

 <tr>
  <td align='center'><img src="https://avatars.githubusercontent.com/u/62923434?v=4" width="50" height="50"></td>
  <td align='center'>박세현</td>
  <td align='center'>Back-End (Spring)</td>
  <td align='center'><a href="https://github.com/se0y0ung12"><img src="http://img.shields.io/badge/se0y0ung12-green?style=social&logo=github"/></a></td>
 </tr>

 <tr>
  <td align='center'><img src="https://avatars.githubusercontent.com/u/35412648?v=4" width="50" height="50"></td>
  <td align='center'>허서영</td>
  <td align='center'>Back-End (Spring)</td>
  <td align='center'><a href="https://github.com/zheedong"><img src="http://img.shields.io/badge/zheedong-green?style=social&logo=github"/></a></td>
 </tr>
   
 <tr>
  <td align='center'><img src="https://avatars.githubusercontent.com/u/40621030?v=4" width="50" height="50"></td>
  <td align='center'>Wonbeom Jang</td>
  <td align='center'>Deep Learning (Pytorch)<br>MLOps (Django)</td>
  <td align='center'><a href="https://github.com/wonbeomjang"><img src="http://img.shields.io/badge/wonbeomjang-green?style=social&logo=github"/></a></td>
 </tr>
</table>

---
