@echo off
setlocal ENABLEDELAYEDEXPANSION


set PORT=8000


for /f "usebackq tokens=* delims=" %%A in (".env") do (
    set "line=%%A"
    rem Ignorer les lignes vides et les commentaires
    if not "!line!"=="" if not "!line:~0,1!"=="#" (
        for /f "tokens=1,* delims==" %%B in ("!line!") do (
            set "%%B=%%C"
        )
    )
)


:: start .\.venv\Scripts\activate

echo NGROK_AUTHTOKEN=!NGROK_AUTHTOKEN!


echo Lancement de FastAPI...
start /B uvicorn webhook:app --host 0.0.0.0 --port %PORT%

timeout /T 3 >nul


ngrok config add-authtoken !NGROK_AUTHTOKEN!


set http_proxy=
set https_proxy=


echo Démarrage de ngrok...
start /B ngrok http %PORT%

timeout /T 6 >nul


for /f "tokens=*" %%i in ('curl -s http://localhost:4040/api/tunnels ^| findstr "public_url"') do (
    set "line=%%i"
    goto :parse
)

:parse
for /f %%i in ('powershell -Command "$env:line -match \"https://[^\"]+\" | Out-Null; $matches[0]"') do (
    set NGROK_URL=%%i
)

echo Webhook est disponible à : !NGROK_URL!/webhook
echo Colle cette URL dans ton GitHub (Settings > Webhooks)

endlocal
pause
