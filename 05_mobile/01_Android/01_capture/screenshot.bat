@echo off
rem Android�X�N�V���擾
set time_tmp=%time: =0%
set now=%date:/=%-%time_tmp:~0,2%%time_tmp:~3,2%%time_tmp:~6,2%
set pf=/sdcard/Screenshot_%now%.png

adb shell "screencap -p %pf%"
adb pull %pf%
adb shell "rm %pf%"
