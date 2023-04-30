# Yogit-iOS
## 📱 로컬기반 관심사별 글로벌 모임 iOS앱
#### 앱 스토어 <https://apps.apple.com/app/yogit-%EC%9A%94%EA%B9%83/id644736114>

### Development achievement

- 세션 관리 | 유저 상태 처리, 키체인, 자동 로그인, 애플 로그인
- 네트워크 관리 | Alamofire, logger, interceptor, 라우터 분리, 네트워크 상태 처리
- 병렬, 비동기 코드 스케줄링
    - 동시성 제어 `asyn, await / semaphore` >>  Race condition 문제 해결
    - 비동기 이미지 리스트 병렬 캐싱  `asyn, await` >> 성능 향상
    - 현재  `Task` 실행전, 이전 `Tasks` 취소 후 실행  >>  불필요한 비동기 작업들을 취소하여 반응 속도 향상
- Realm  crud (Local DB)
- 채팅형 게시판 (빠른 MVP 개발을 위해, 게시판을 채팅 UI로 구현)
- Infinte scroll (paging)
- Push notification
- 주소 및 장소 검색, 지역 설정 및 지도 관련 기능
    - Mapkit
    - CoreLocation
    - GooglePlace API
- Localizing
    - 주소, 지역, 날짜, 국적 선택, 언어 선택 - 모든 언어
    - Push notification,  사용자 권한 문구,  서비스 문구 - 한국어, 영어
