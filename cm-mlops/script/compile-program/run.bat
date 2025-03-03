rem Compile program

set BIN_NAME=%CM_BIN_NAME%
IF NOT DEFINED CM_BIN_NAME SET BIN_NAME=run.exe

set RUN_DIR=%CM_RUN_DIR%
IF NOT DEFINED CM_RUN_DIR SET RUN_DIR=.

echo.
echo Checking compiler version ...
echo.

if "%CM_C_COMPILER_BIN%" == "cl.exe" (
  "%CM_C_COMPILER_WITH_PATH%"
) else (
  "%CM_C_COMPILER_WITH_PATH%" --version
)

echo.
echo Compiling source files ...
echo.

if not exist %RUN_DIR% mkdir %RUN_DIR%

cd %CM_SOURCE_FOLDER_PATH%
IF %ERRORLEVEL% NEQ 0 EXIT %ERRORLEVEL%

echo "%CM_C_COMPILER_WITH_PATH% %CM_C_COMPILER_FLAGS% %CM_C_INCLUDE_PATH% %CM_C_SOURCE_FILES% -o %RUN_DIR%\%BIN_NAME%"
"%CM_C_COMPILER_WITH_PATH%" %CM_C_COMPILER_FLAGS% %CM_C_INCLUDE_PATH% %CM_C_SOURCE_FILES% -o %RUN_DIR%\%BIN_NAME%
IF %ERRORLEVEL% NEQ 0 EXIT %ERRORLEVEL%
