@echo off
chcp 65001 >nul
cd /d "%~dp0"
if not exist "realtime_gui.py" (
  echo 请把这个文件放到 RVC 根目录，和 realtime_gui.py 放在一起。
  pause
  exit /b 1
)
if not exist "requirments_cu118_py312.txt" (
  echo 找不到 requirments_cu118_py312.txt
  pause
  exit /b 1
)
py -3.12 -c "import sys" >nul 2>&1
if errorlevel 1 (
  echo 这台 2080S 需要先安装 Python 3.12 x64。
  echo https://www.python.org/ftp/python/3.12.10/python-3.12.10-amd64.exe
  pause
  exit /b 1
)
echo 正在为 2080S 安装 CUDA 11.8 环境，不要用原包里的 runtime。
py -3.12 -m venv .venv
call ".venv\Scripts\activate.bat"
python -m pip install --upgrade pip setuptools wheel
python -m pip install torch==2.7.1+cu118 torchaudio==2.7.1+cu118 --index-url https://download.pytorch.org/whl/cu118 --extra-index-url https://pypi.org/simple
if errorlevel 1 (
  echo 官方源失败，改用南京大学镜像。
  python -m pip install torch==2.7.1+cu118 torchaudio==2.7.1+cu118 --index-url https://mirrors.nju.edu.cn/pytorch/whl/cu118 --extra-index-url https://mirrors.pku.edu.cn/pypi/simple
)
python -m pip install -r requirments_cu118_py312.txt
python -c "import torch; print('torch', torch.__version__); print('cuda', torch.version.cuda); print('available', torch.cuda.is_available()); print(torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'NO CUDA')"
echo 安装结束。看到 available True 和 2080 后再运行 start-realtime-2080s.bat
pause
