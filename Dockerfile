# build
FROM mcr.microsoft.com/windows/servercore:ltsc2019 as builder
LABEL maintainer=michel.promonet@free.fr

# Install Chocolatey & packages
RUN powershell.exe -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SETX PATH "%PATH%;%ALLUSERSPROFILE%\chocolatey\bin" 
RUN choco install --no-progress -y git python2 sed curl windows-sdk-10 \
       && choco install --no-progress -y cmake --installargs 'ADD_CMAKE_TO_PATH=System' \
       && choco install --no-progress -y visualstudio2017buildtools --package-parameters "--add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Workload.NativeDesktop --add Microsoft.VisualStudio.Component.VC.ATLMFC --includeRecommended --nocache --installPath C:\BuildTools" || IF "%ERRORLEVEL%"=="3010" EXIT 0   

