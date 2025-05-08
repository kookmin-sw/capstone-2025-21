# 🍱 Menu: 당신의 언어로, 당신의 취향에 맞게 메뉴를 추천해드립니다

# 🗂️프로젝트 소개
한국을 방문하는 외국인을 위한 음식점 메뉴판 번역을 제공하고, 사용자 취향 및 알러지 정보를 이용해서 음식을 추천해주는 애플리케이션

## 📌 프로젝트 문서
- 📃주제 정의 문서 -> <a href="https://github.com/kookmin-sw/capstone-2025-21/wiki/주제-정의-문서">문서 바로가기</a>
- 📈Market potential & Business model -> <a href="https://github.com/kookmin-sw/capstone-2025-21/wiki/Market-potential-&-Business-model">문서 바로가기</a>
- 🙋‍♂️ 페르소나 분석 -> <a href="https://github.com/kookmin-sw/capstone-2025-21/wiki/페르소나-분석">문서 바로가기</a>

---
# 🏗️ 시스템 설계
## ✅ UseCase Diagram
<img src="https://github.com/user-attachments/assets/872286c5-f019-4657-9d2a-822916f1a834" width="400"/>

## ✅ Sequence Diagram
<img src="https://github.com/user-attachments/assets/cd93c758-010c-4f25-a3b0-b8df76a6e2e5" width="400"/>

## ✅ Architecture
<img src="https://github.com/user-attachments/assets/edd16e72-e021-4023-a246-96a15f9995c4" width="430"/>

### 관련 문서 
- Github 컨벤션 <a href="https://github.com/kookmin-sw/capstone-2025-21/wiki/Github-이슈,-PR,-커밋-컨벤션">문서 바로가기</a>
- 
- 


# 🗂️ 개발 과정 설명

## AI
```
작성예정
```
## Front

### 아키텍쳐 그래프
<img width="850" alt="image" src="https://github.com/user-attachments/assets/2eca019a-1540-476a-9d65-6fd7c43791ee" />


 
### 1. DIContainer를 사용하여 의존성 주입을 구현하고 있으며, 다음과 같은 주요 구성 요소에 접근할 수 있게 합니다
<details>
 <summary>자세한 내용</summary>
- NavigationRouter: 특정 플로우 내에서의 화면 이동 관리
- WindowRouter: 주요 애플리케이션 화면/플로우 간의 전환 관리
    
```Swift
import Foundation

typealias NavigationRoutableType = NavigationRoutable & ObservableObjectSettable
typealias WindowRoutableType = WindowRoutable & ObservableObjectSettable

final class DIContainer: ObservableObject {
    var navigationRouter: NavigationRoutableType
    var windowRouter: WindowRoutableType
    
    private init(
        navigationRouter: NavigationRoutableType = NavigationRouter(),
        windowRouter: WindowRoutableType = WindowRouter()
    ) {
        self.navigationRouter = navigationRouter
        self.windowRouter = windowRouter
        
        navigationRouter.setObjectWillChange(objectWillChange)
        windowRouter.setObjectWillChange(objectWillChange)
    }
}

extension DIContainer {
    static let `default` = DIContainer()
    static let stub = DIContainer()
}

```
</details>

### 2. 네비게이션 시스템
<details>
 <summary>자세한 내용</summary>
앱은 다음과 같은 맞춤형 네비게이션 아키텍처를 구현하고 있습니다:
**1. 윈도우 라우팅 - 주요 애플리케이션 상태 처리:**
.splash - 앱 초기 로딩 화면
.onboarding - 사용자 등록 단계
.home - 메인 애플리케이션 인터페이스
    
```Swift
import Foundation
import Combine

protocol WindowRoutable {
    var destination: WindowDestination { get }
    func `switch`(to destination: WindowDestination)
}


class WindowRouter: WindowRoutable, ObservableObjectSettable {
    
    var objectWillChange: ObservableObjectPublisher?
    
    var destination: WindowDestination = .splash {
        didSet {
            objectWillChange?.send()
        }
    }
    
    func `switch`(to destination: WindowDestination) {
        self.destination = destination
    }
    
}
```

**2. 내비게이션 라우팅 - 각 플로우 내에서의 화면 이동 처리:**
```Swift
import Foundation
import Combine

protocol NavigationRoutable {
  var destinations: [NavigationDestination] { get set }
  
  func push(to view: NavigationDestination)
  func pop()
  func popToRootView()
}


class NavigationRouter: NavigationRoutable, ObservableObjectSettable {
  
  var objectWillChange: ObservableObjectPublisher?
  
  var destinations: [NavigationDestination] = [] {
    didSet {
      objectWillChange?.send()
    }
  }
  
  func push(to view: NavigationDestination) {
    destinations.append(view)
  }
  
  func pop() {
    _ = destinations.popLast()
  }
  
  func popToRootView() {
    destinations = []
  }
}
```

**3. 스택 기반 접근 방식으로 push/pop 연산 사용**
- 내비게이션 목적지는 NavigationDestination 열거형에 정의
- NavigationRoutingView가 목적지를 구체적인 뷰 인스턴스로 변환

</details>

### 3. MVVM 패턴
<details>
 <summary>자세한 내용</summary>
    <img width="754" alt="image" src="https://github.com/user-attachments/assets/1e43b148-2420-430d-9546-15774719d912" />

각 화면은 MVVM(Model-View-ViewModel) 패턴을 따릅니다:
- 뷰: UI를 표시하고 사용자 입력을 캡처하는 SwiftUI 뷰
- 뷰모델: 상태 관리, 비즈니스 로직, 서비스와의 통신 담당
- 모델: 도메인 객체를 나타내는 데이터 구조
</details>


### 4. 주요 플로우 & 홈 탭 구조
<details>
 <summary>자세한 내용</summary>
 
 ### 세 개의 탭으로 구성된 메인 애플리케이션 인터페이스:
 - **ArchivingView** - 사용자 선호 음식을 기반한 맛집 추천 리스트 제공
 - **MenuImagePickerView** - 메인 메뉴 분석 기능
 - **MyPageView** - 사용자 프로필 및 설정
 
 ### 온보딩 플로우
 다단계 등록 프로세스:
 - SelectNationalityView - 국가 선택
        - SelectAllergyView - 알레르기 및 매운 음식 선호도 지정
        - SelectKoreanFoodView - 선호하는 한국 음식 선택
        - EnterIdPasswordView - 계정 인증 정보 생성
        
 ### 메뉴 분석 플로우
 사용자가 메뉴 항목을 분석할 수 있는 핵심 기능:
 - MenuImagePickerView - 메뉴 이미지 업로드
 - MenuAnalysisLoadingView - 메뉴 분석 중 로딩 화면
 - MenuAnalysisResultView - 사용자 선호도 기반 추천을 포함한 분석 결과 표시
</details>






## Back
### 1. MySQL 데이터베이스
<details>
 <summary>자세한 내용</summary>
    database 명 : menu_db
DB 관리자 명 : admin
- users table
    - id : 사용자 id
    - nationality : 사용자 국적
    - password : 사용자 비밀번호
    - username : 사용자 이름
<img width="780" alt="image" src="https://github.com/user-attachments/assets/c3df5d97-e3f9-48fe-bba9-a1393e089cb3" />

- user_allergies table
    - user_id : 사용자 id
    - allergy : 사용자가 가지고 있는 알러지
<img width="225" alt="image" src="https://github.com/user-attachments/assets/46ba2393-0177-4433-a4ab-0c9bf399fec2" />

- user_favorite_foods
    - user_id : 사용자 id
    - food : 사용자가 좋아하는 한국 음식
<img width="220" alt="image" src="https://github.com/user-attachments/assets/b5c22b7e-64e2-42f2-8b02-0b7a69f4228a" />

- restaurants (평점, 이미지 추가 예정)
    - id : 식당 id
    - address : 식당 주소
    - food_name : 식당 대표메뉴 이름
    - restaurant_name : 식당 이름
<img width="695" alt="image" src="https://github.com/user-attachments/assets/335f834c-e86b-4132-b35d-ab805110c7b9" />
</details>

### 2. API 문서
<details>
 <summary>자세한 내용</summary>
    
### POST /api/auth/signup
    ```jsx
    status: 200
    respose: {"success": true, "message": "회원가입 성공", "data": {}}
    ```
    
### POST /api/auth/login
    
    ```jsx
    status: 200
    respose: { "success": true, "message": "로그인 성공", "data": { "token": "string", "userId": “string”, "username": "string"}}
    ```
    
### POST /api/auth/logout
    
    ```jsx
    status: 200
    headers: {”Authorization”: “Bearer <JWT>”}
    respose: {"success": true,"message": "로그아웃 성공: 클라이언트는 토큰 삭제 요망","data": null}
    ```
### GET /api/user/profile
    
    ```jsx
    status: 200
    headers: {”Authorization”: “Bearer <JWT>”}
    respose: {"success": true,"message": "사용자 프로필 반환 성공", "data": { "username": "string", "nationality":”string"}}
    ```
### GET /api/restaurant/recommend
    
    ```jsx
    status: 200
    headers: {”Authorization”: “Bearer <JWT>”}
    respose: {"success": true,"message": "사용자 프로필 반환 성공", "data": { "username": "string", "nationality":"string"}}
    ```
    
### POST /api/gallery/upload
    
    ```jsx
    parameters: {”image”: “multipart/form-data, file”}
    headers: {”Authorization”: “Bearer <JWT>”}
    status: 200
    respose: {”success”: true, “message”: “이미지 업로드 성공”, “data”: {”url”: “/api/gallery/images/{filename}”}}
    ```
### GET /api/gallery/images/{filename}
    
    ```jsx
    parameters: {”filename”: “string”}
    headers: {”Authorization”: Bearer <JWT>”}
    status: 200
    respose: 이미지 파일 자체 (image/jpeg 등)
    ```
    
### POST /api/analysis/analyze-image
    
    ```jsx
    parameters: 없음
    headers: {”Authorization”: “Bearer <JWT>”}
    status: 200
    respose: {”success”: true, “message”: “AI 분석 요청 성공 및 결과 캐싱 완료”, “data”: “ok”}
    ```
### GET /api/analysis/analyze
    
    ```jsx
    parameters: 없음
    headers: {”Authorization”: “Bearer <JWT>”}
    status: 200
    respose: {“success”: true, “message”: “분석 결과 조회 성공”}
    ```
    
### GET /api/analysis/translate
    
    ```jsx
    parameters: 없음
    headers: {”Authorization” :”Bearer <JWT>”}
    status: 200
    respose: {”success”: true, “message”: “번역 결과 조회 성공”}
    ```

 </details>






# 🧩 기능 설명

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
 
### ➡️ 메뉴분석 Flow
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

### ➡️ 맛집 아카이빙 & 마이페이지 Flow
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
* iOS >= 16.0 
* swift >= 4.2
* MySQL 8.0 (AWS RDS)
* Spring Boot 3.4.4


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
### Swift

#### Xcode 시뮬레이터로 실행하기
```bash 
git clone https://github.com/kookmin-sw/capstone-2025-21
cd App/capstone21/capstone21
Xcode로 프로젝트 파일 열기
실행하기
 ```

### 서버 실행
- Git clone
```bash 
# EC2로 접속
$ ssh -i ~/capstone2025-key.pem ubuntu@<EC2-IP>

# git clone
$ git clone https://github.com/kookmin-sw/capstone-2025-21.git

# 프로젝트 디렉토리로 이동 후, 빌드한 JAR 파일 업로드
 ```
- Build - 로컬 (intelliJ)에서 실행
```bash 
# Gradle 빌드
./gradlew bootJar

# 생성된 JAR 위치 (예시)
build/libs/allergy-0.0.1-SNAPSHOT.jar
 ```
- EC2 서버에 JAR 업로드 (SCP or FileZilla)
```bash 
# 1. scp 사용
$ scp -i capstone2025-key.pem allergy-0.0.1-SNAPSHOT.jar ubuntu@<EC2-IP>:~/

# 2. 혹은 FileZilla에서 호스트에 IP, 사용자명, 키 파일 PEM 설정 후 접속해서 ~/ 경로에 업로드
 ```
- 서버 실행
 ```bash 
# EC2에 접속
$ ssh -i ~/capstone2025-key.pem ubuntu@<EC2-IP>

# JAR 실행 (백그라운드 실행)
$ nohup java -jar allergy-0.0.1-SNAPSHOT.jar &

# (prod profile로 실행할 경우)
$ nohup java -jar -Dspring.profiles.active=prod.active allergy-0.0.1-SNAPSHOT.jar &
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
