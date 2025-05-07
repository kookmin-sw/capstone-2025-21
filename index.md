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

## **🍽️ Menu app**

### ➡️ 회원가입 Flow

### 1. 온보딩 뷰 & 로그인 뷰
 앱을 처음 실행 시, 앱을 설명하는 온보딩 화면이 나타나고, start 버튼을 누르게 되면 로그인 화면으로 이동하게 됩니다!
 <table>
  <tr>
   <td><img src="https://github.com/user-attachments/assets/20e44560-5baa-426d-9dd7-1a4e27c95314" width="600"/></td>
   <td><img src="https://github.com/user-attachments/assets/771542ab-0228-4320-9c75-36b0283a947c" width="200"/></td>
  </tr>
 </table>

 ### ➡️ 회원가입 Flow
 로그인 화면에서 sign up 버튼을 누르면 회원가입으로 연결된다

 ### 1. 국적 & 알러지 선택 뷰
 현재 국적은 미국, 일본, 중국으로 세 나라를 선택할 수 있으며, 알러지는 총 25개 중에서 중복적으로 선택할 수 있습니다
  <table>
  <tr>
   <td><img src="https://github.com/user-attachments/assets/9d6d1ab1-2a96-4c09-a1f5-d000db355ef7" width="400"/></td>
   <td><img src="https://github.com/user-attachments/assets/a62c62cf-7c44-4f89-a944-2bcf14994790" width="400"/></td>
  </tr>
 <table>

 ### 2. 선호하는 음식 선택 & 개인정보 입력 뷰
 메뉴판 분석을 통해서 선호하는 음식 추천 및 맛집 추천 아카이빙 뷰에서 사용하기 위한 정보인 선호하는 한국 음식을 받는다
 마지막으로는 username, password를 받고 회원가입을 실행한다.
  <table>
  <tr>
   <td><img src="https://github.com/user-attachments/assets/0d08c2d4-cb4d-49e2-b302-32295f55f33f" width="400"/></td>
   <td><img src="https://github.com/user-attachments/assets/04f58b54-2fc2-4cd5-b56c-0b0cd1dbbe86" width="200"/></td>
  </tr>
 <table>
 

 ### 메뉴판 업로드 & 로딩 뷰 & 메뉴판 분석
 갤러리에서 메뉴판 이미지를 업로드 하고 분석하는 동안 로딩뷰를 보여준다
 메뉴판 분석 페이지에서는 해당 메뉴판에서 추천하는 음식과 알러지와 관련된 메뉴들을 한눈에 보기 편하도록 보여준다
 또한 메뉴판 번역 이미지를 제공해줌으로써 확인할 수 있도록 한다

 <table>
  <tr>
   <td><img src="https://github.com/user-attachments/assets/22b876d1-d527-4be1-a4ac-ce99267bc5a1" width="400"/></td>
   <td><img src="https://github.com/user-attachments/assets/46367d31-1093-4849-a82d-0854a53bfcac" width="200"/></td>
   <td><img src="https://github.com/user-attachments/assets/7c692e67-476d-4c57-b197-4acb1b2e551d" width="400"/></td>
  </tr>
<table>

### 마이페이지 & 맛집 아카이빙 뷰
마이페이지에서 회원정보 확인, 로그아웃, 회원탈퇴 등의 정보를 확인할 수 있으며
맛집 아카이빙 뷰에서는 자신의 선호음식을 기반으로 맛집 리스트를 추천해주고 해당 맛집을 누르면 인터넷을 통해서 정보를 확인할 수 있도록 연결해준다.
<table>
  <tr>
   <td><img src="https://github.com/user-attachments/assets/cdf5dcaf-ae61-41f8-b83f-60ad3e1aa14e" width="200"/></td>
   <td><img src="https://github.com/user-attachments/assets/262afbb9-28b1-463c-b0b6-6c71243c7cd4" width="400"/></td>
  </tr>
<table>

---
## 컴퓨터 구성 / 필수 조건 안내 (Prerequisites)
* 
* 
* iOS >= 16.0 
* swift >= 4.2


## 🔨기술 스택 (Technique Used) 
### Server(back-end)
<table>
 <tr>
  <td><img src='https://github.com/user-attachments/assets/1ca31597-0dee-4610-8488-a18194968531' height=80/></a></td>
  <td><img src='https://github.com/user-attachments/assets/7bec55bb-ba90-4e69-b124-19d2bc2b65d6' height=80/></a></td>
 </tr>
 <tr>
  <td align='center'>Amazon RDS</td>
  <td align='center'>Springboot</td>
 </tr>
</table>

 
### Front-end
<table>
 <tr>
  <td align='center'><img src='https://github.com/user-attachments/assets/818e32ef-0d91-429a-8e5f-f01e80cbf6c3' height=80></td>
  <td align='center'><img src='https://github.com/user-attachments/assets/2f726182-4902-43c6-81ef-1830d6b28fb7' height=80></td>
 </tr>
 <tr>
  <td align='center'>Swift</td>
  <td align='center'>SwiftUI</td>
 </tr>
</table>
<details>
 <summary>Swift Packages</summary>



</details>



### AI
 <table>
 <tr>
  <td><img src='https://user-images.githubusercontent.com/40621030/136698820-2c869052-ff44-4629-b1b9-7e1ae02df669.png' height=80></a></td>
  <td><img src='https://github.com/user-attachments/assets/46546f67-8f4b-48e4-8c1b-5e52f565822c' height=80></a></td>
 </tr>
 <tr>
  <td align='center'>PyTorch</td>
  <td align='center'>Python</td>
 </tr>
 </table>
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
 </tr>

 <tr>
  <td align='center'><img src="https://github.com/user-attachments/assets/29b1a86d-d38f-40d8-8b45-392e3619c108" width="50" height="50"></td>
  <td align='center'>박상혁</td>
  <td align='center'>Leader / AI</td>
  <td align='center'><a href="https://github.com/sanghyeok1000"><img src="http://img.shields.io/badge/sanghyeok1000-green?style=social&logo=github"/></a></td>
 </tr>

 <tr>
  <td align='center'><img src="" width="50" height="50"></td>
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
  <td align='center'><img src="https://github.com/user-attachments/assets/7d205f52-451b-4b47-83df-1b34faa2fc12" width="50" height="50"></td>
  <td align='center'>박세현</td>
  <td align='center'>Back-End (Spring)</td>
  <td align='center'><a href="https://github.com/nf1kelly"><img src="http://img.shields.io/badge/nf1kelly-green?style=social&logo=github"/></a></td>
 </tr>

 <tr>
  <td align='center'><img src="" width="50" height="50"></td>
  <td align='center'>허서영</td>
  <td align='center'>Back-End (Spring)</td>
  <td align='center'><a href="https://github.com/se0y0ung12"><img src="http://img.shields.io/badge/se0y0ung12-green?style=social&logo=github"/></a></td>
 </tr>
</table>

---
