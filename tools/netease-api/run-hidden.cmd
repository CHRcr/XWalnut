@echo off
cd /d "%~dp0"
if not exist "%LOCALAPPDATA%\XWalnut" mkdir "%LOCALAPPDATA%\XWalnut"
set "NODE_EXE=%~dp0runtime\node.exe"
if not exist "%NODE_EXE%" set "NODE_EXE=node"
"%NODE_EXE%" "%~dp0server.js" >> "%LOCALAPPDATA%\XWalnut\music-bridge.log" 2>&1
