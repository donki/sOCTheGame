@echo off
cd /d "%~dp0"
echo Instalando dependencias (flask, pillow, requests)...
python -m pip install -q flask pillow requests
echo Arrancando SpriteManager en http://127.0.0.1:5000
start "" http://127.0.0.1:5000
python app.py
