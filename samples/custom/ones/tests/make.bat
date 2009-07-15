@echo off
dcc32 -cc shuffle.dpr

shuffle.exe

dcc32 -cc ..\ones_rs.dpr
copy ..\ones_rs.exe ones_rs.exe >nul 2>&1

call make_answers.bat
