@ECHO OFF
SETLOCAL EnableDelayedExpansion
SET me=%~n0
SET parent=%~dp0
set R_Script="C:\Program Files\R\R-3.4.2\bin\RScript.exe"
set log_folder="C:\Users\Hume Dickie\Desktop\Github\Senior-Project\logs"
cd src



::As of Jan 28, there is no updateData.R file in this project. However, data updates and webpage rendering should maybe be split up in the future, so I'm leaving this here.
%R_Script% updateData.R
::IF UPDATE FAILS
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

git pull

::re-render Driver.Rmd into index.html
cd src
%R_Script% -e "rmarkdown::render('Driver.Rmd',output_file='C:/Users/Work/Desktop/Github/Senior-Project/index.html')"

cd %parent%
git add *
git commit -m "Automated push."
git push

echo Finished Successfully.
pause