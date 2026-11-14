@echo off
chcp 65001 >nul
cd /d "%~dp0"
if not exist "realtime_gui.py" (
  echo 请把这个文件放到 RVC 根目录，和 realtime_gui.py 放在一起。
  pause
  exit /b 1
)
if not exist ".venv\Scripts\python.exe" (
  echo 还没有 2080S 环境。先双击 install-cu118-2080s.bat
  pause
  exit /b 1
)
if not exist "assets\weights\guanguanV1.pth" (
  echo 找不到 assets\weights\guanguanV1.pth
  pause
  exit /b 1
)
if not exist "configs" mkdir "configs"
if exist "configs\config.json" copy /Y "configs\config.json" "configs\config.json.bak" >nul
copy /Y "%~dp0rvc-realtime-2080s.json" "configs\config.json" >nul
echo 2080S 实时配置已写入。块时长 0.16，fcpe，40kHz。
echo 输入选麦克风，输出选 CABLE Input。接口选 Windows WASAPI。
".venv\Scripts\python.exe" realtime_gui.py
pause
