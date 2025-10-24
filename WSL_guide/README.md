<div align="center">

# NORDIC_NCS_WSL_Environment_KR_v2

</div>



일반적으로 개발환경을 윈도우즈에서 꾸미게 되는데, 멀티이미지를 빌드하게 될 경우 윈도우즈 시스템은 상당히 느린 환경을 제공하게 됩니다.

이를 개선하기 위해서는 우분투를 사용해야 하지만 현실적으로 윈도우 시스템을 버리기 어렵기 때문에, 마이크로소프트에서 제공하는 WSL(Windows Subsystem for Linux)이라는 경량 VM기반에서 Ubuntu를 실행하여 사용하는 방법을 안내합니다

## wsl_configurator.sh
Oneshot Installation script<br><br>
WSL에서 VSCode와 nRF connect extension을 설치 후 첨부된 스크립트를 실행하시면 설정이 완료 됩니다.<br>

### 실행방법

``` Bash
chmod a+x wsl_configurator.sh 
./wsl_configurator.sh
```
또는<br>
``` Bash
sh ./wsl_configurator.sh
```
전체 재설정이 필요할 경우<br>
``` Bash
sh ./wsl_configurator.sh reconfigure
```
또는<br>
``` Bash
chmod a+x wsl_configurator.sh reconfigure
```

이 내용 관련해서는 추후 한번 더 메뉴얼이 업데이트 될 예정입니다.

## Author
Nordic KR 유진혁 이사