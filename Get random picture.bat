@echo off
:start:
setlocal enabledelayedexpansion
cd %~dp0gallery-dl\images
set count=0

for /d %%x in (*) do (
    set /a count=count+1
    set choice[!count!]=%%~nxx
    for %%y in (!count!) do set "choice[%%y]=!choice[%%y]:%cd%\=!"
)
echo  0] Search in all subfolders

:
:: Print list of files
for /l %%x in (1,1,!count!) do (
     echo  %%x] !choice[%%x]!
)
echo.

:
:: Retrieve User input
set /p select=get a random picture from wich one? 
echo.

:
:: Print out selected filename
cls
if %select% EQU 0 goto all
cd %~dp0gallery-dl\images\!choice[%select%]!

setlocal
:getpic:

:: Create numbered list of files in a temporary file
set "tempFile=%temp%\%~nx0_fileList_%time::=.%.txt"
dir /b /s /a-d %1 | findstr /n "^" >"%tempFile%"

:: Count the files
for /f %%N in ('type "%tempFile%" ^| find /c /v ""') do set cnt=%%N

call :openRandomFile
:anotherone:
echo open another one?
echo.
echo 1. yes, with same parameters
echo 2. yes, with another folder
echo 3. no
echo 4. show it in windows explorer
set /p reopen=your choice? 
if %reopen% EQU 1 cls & goto getpic
if %reopen% EQU 2 cls & goto start
if %reopen% EQU 3 exit
if %reopen% EQU 4 %SystemRoot%\explorer.exe /select, "%fileopened%" & cls & goto anotherone
cls
echo invalid value :/
Timeout /T 3 /NOBREAK > NUL
cls
goto anotherone
exit

:: Delete the temp file
del "%tempFile%"

exit /b

:openRandomFile
set /a "randomNum=(%random% %% cnt) + 1"
for /f "tokens=1* delims=:" %%A in (
  'findstr "^%randomNum%:" "%tempFile%"'
) do start "" "%%B" & echo openned %%B & set fileopened=%%B
exit /b

exit

:all:
cd %~dp0gallery-dl\images
goto getpic