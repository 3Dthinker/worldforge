# TerraForge · 현실 공간 실험실

현재 버전: **r25** — Windows 11 / Unreal Engine 5.7.4용 로컬 제어 프로그램과 Unreal 플러그인 소스.

- **사용 설명서:** [브라우저에서 읽기](docs/USER_GUIDE_KO.html) · [텍스트 원문](docs/USER_GUIDE_KO.md)
- **최초 환경 준비:** [Windows 설치 안내](docs/WINDOWS_SETUP.md)
- **이번 변경:** [r25 정리 내역](README_R25.md)
- **외부 Niagara 제작·연결:** [날씨 에셋 안내](weather_external/README.md)

처음 설치: ZIP 전체 해제 → Check-Environment.cmd → Build-Unreal.cmd → Start-TerraForge.cmd.
기존 설치 업데이트: 프로그램·Unreal 종료 → 새 ZIP 별도 해제 → Apply-Update.cmd → 기존 Start-TerraForge.cmd 선택.

이전 Apply-R*.cmd 및 scripts/Apply-R*.ps1은 현재 업데이트 구현으로 연결되는 호환 진입점입니다.
README_R*.md는 버전별 변경 이력이며 현재 사용법은 위의 통합 설명서를 우선합니다.
실제 사용자 자료, 실험 기록 및 Unreal 에셋은 중복 정리 대상으로 자동 삭제하지 않습니다.

현재는 개발 시안입니다. Python 테스트와 Windows·Unreal 실제 실행 검증 범위는 설명서에서 구분합니다.
