@ECHO OFF
SETLOCAL EnableDelayedExpansion
SET me=%~n0
SET parent=%~dp0
set R_Script="C:\Program Files\R\R-3.4.2\bin\RScript.exe"
set log_folder="C:\Users\Hume Dickie\Desktop\Github\Senior-Project\logs"
cd %parent%
cd src
%R_Script% updateData.R  ::this may have to be done manually
IF NOT "0" == "%ERRORLEVEL%" (
  cd %log_folder%
  echo %date% %time% ; Failed to Update Data >> log.txt
  cd %parent%

  set /P continue=The data failed to refresh. Do you want to continue with this update? [y/n]

  IF NOT "!continue!"=="y" (
    echo %me% Exiting without updating.
    pause
    exit /B 
  )
)
echo %me% Finished Successfully.
pause