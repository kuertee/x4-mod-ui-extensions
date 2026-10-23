
@echo off
setlocal EnableExtensions DisableDelayedExpansion

REM ==========================================
REM CONFIGURATION
REM ==========================================
set "FOLDER_A=D:\games\steam\steamapps\common\X4 Foundations\ui"
set "FOLDER_B=D:\games\steam\steamapps\common\X4 Foundations\extensions\kuertee_ui_extensions\ui"

REM 1 = Preview only; 0 = Execute changes
set "PREVIEW=0"

REM Log file next to this batch file
set "LOG_FILE=%~dp0batch.log"

REM ==========================================
REM RESOLVE PATHS
REM ==========================================
for %%I in ("%FOLDER_A%") do set "FOLDER_A=%%~fI"
for %%I in ("%FOLDER_B%") do set "FOLDER_B=%%~fI"

REM ==========================================
REM INITIALIZE LOG
REM ==========================================
> "%LOG_FILE%" echo Started: %DATE% %TIME%
>>"%LOG_FILE%" echo Preview mode: %PREVIEW%
>>"%LOG_FILE%" echo Destination: "%FOLDER_A%"
>>"%LOG_FILE%" echo Source: "%FOLDER_B%"
>>"%LOG_FILE%" echo.

echo Log file: "%LOG_FILE%"

REM ==========================================
REM VALIDATE CONFIGURATION
REM ==========================================
if not "%PREVIEW%"=="0" if not "%PREVIEW%"=="1" (
    echo ERROR: PREVIEW must be 0 or 1.
    >>"%LOG_FILE%" echo ERROR: Invalid PREVIEW setting.
    pause
    exit /b 1
)

if not exist "%FOLDER_A%\" (
    echo ERROR: Destination folder does not exist:
    echo "%FOLDER_A%"
    >>"%LOG_FILE%" echo ERROR: Destination folder does not exist.
    pause
    exit /b 1
)

if not exist "%FOLDER_B%\" (
    echo ERROR: Source folder does not exist:
    echo "%FOLDER_B%"
    >>"%LOG_FILE%" echo ERROR: Source folder does not exist.
    pause
    exit /b 1
)

if /I "%FOLDER_A%"=="%FOLDER_B%" (
    echo ERROR: Source and destination are identical.
    >>"%LOG_FILE%" echo ERROR: Source and destination are identical.
    pause
    exit /b 1
)

REM Prevent destination from being an ancestor of source
for %%I in ("%FOLDER_B%\..") do set "SOURCE_PARENT=%%~fI"

if /I "%FOLDER_A%"=="%SOURCE_PARENT%" (
    echo ERROR: Destination is the parent of the source.
    >>"%LOG_FILE%" echo ERROR: Unsafe source/destination relationship.
    pause
    exit /b 1
)

REM ==========================================
REM PROCESS SOURCE FILES RECURSIVELY
REM ==========================================
echo.
echo Processing files...

>>"%LOG_FILE%" echo --- PROCESSING FILES ---

for /r "%FOLDER_B%" %%F in (*) do (
    call :CreateLink "%%~fF"
)

echo.
if "%PREVIEW%"=="1" (
    echo PREVIEW COMPLETE - no changes made.
    >>"%LOG_FILE%" echo PREVIEW COMPLETE - no changes made.
) else (
    echo EXECUTION COMPLETE.
    >>"%LOG_FILE%" echo EXECUTION COMPLETE.
)

>>"%LOG_FILE%" echo Finished: %DATE% %TIME%
echo See log: "%LOG_FILE%"
pause
exit /b


REM ==========================================
REM PROCESS ONE SOURCE FILE
REM ==========================================
:CreateLink
set "SOURCE_FILE=%~1"
set "RELATIVE_PATH=%SOURCE_FILE%"
call set "RELATIVE_PATH=%%RELATIVE_PATH:%FOLDER_B%\=%%"
set "TARGET_FILE=%FOLDER_A%\%RELATIVE_PATH%"

REM Create missing parent directories inside folder a
for %%D in ("%TARGET_FILE%") do (
    if not exist "%%~dpD" (
        echo MKDIR "%%~dpD"
        >>"%LOG_FILE%" echo MKDIR "%%~dpD"

        if "%PREVIEW%"=="0" (
            mkdir "%%~dpD" >>"%LOG_FILE%" 2>&1
            if errorlevel 1 (
                echo ERROR: Could not create directory "%%~dpD"
                >>"%LOG_FILE%" echo ERROR: Could not create directory "%%~dpD"
                exit /b
            )
        )
    )

    REM Do not delete a directory at a file target path
    if exist "%%~fD\" (
        echo CONFLICT: Directory exists at "%%~fD"
        >>"%LOG_FILE%" echo CONFLICT: Directory exists at "%%~fD"
        exit /b
    )

    REM Delete only the matching destination file
    if exist "%%~fD" (
        echo DELETE "%%~fD"
        >>"%LOG_FILE%" echo DELETE "%%~fD"

        if "%PREVIEW%"=="0" (
            del /f /q "%%~fD" >>"%LOG_FILE%" 2>&1

            if exist "%%~fD" (
                echo ERROR: Could not delete "%%~fD"
                >>"%LOG_FILE%" echo ERROR: Could not delete "%%~fD"
                exit /b
            )
        )
    )

    REM Create symbolic link to the source file
    echo MKLINK "%%~fD" "%SOURCE_FILE%"
    >>"%LOG_FILE%" echo MKLINK "%%~fD" "%SOURCE_FILE%"

    if "%PREVIEW%"=="0" (
        mklink "%%~fD" "%SOURCE_FILE%" >>"%LOG_FILE%" 2>&1

        if errorlevel 1 (
            echo ERROR: Failed to create link "%%~fD"
            >>"%LOG_FILE%" echo ERROR: Failed to create link "%%~fD"
        )
    )
)
exit /b

