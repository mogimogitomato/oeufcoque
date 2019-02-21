@echo off

rem ######################################################
rem In order to execute this bat when Windows starts up,
rem make shortcut of this bat and put it below.
rem C:\Users\(user name)\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
rem ######################################################

rem Network Setting
net use [PATH] [PASSWORD] /USER:[USER]

rem Just do it
start /b /min "" "https://hoge.com"

rem Specify browser
start microsoft-edge:http://piyo.com