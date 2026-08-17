@echo off
setlocal
cd /d "%~dp0"
if not exist .venv\Scripts\python.exe (
  echo Creating virtual environment...
  python -m venv .venv || goto :error
)
call .venv\Scripts\activate.bat
python -m pip install -r requirements.txt || goto :error
if "%EBAY_TOKEN%"=="" echo WARNING: EBAY_TOKEN is not set. New parts cannot be collected.
if "%APIFY_TOKEN%"=="" echo WARNING: APIFY_TOKEN is not set. New parts cannot be collected.
if "%GROQ_API_KEY%"=="" echo WARNING: GROQ_API_KEY is not set. New parts cannot be fully processed.
python -m uvicorn src.web_app:app --reload
goto :eof
:error
echo.
echo Startup failed. Review the error above.
pause
exit /b 1
