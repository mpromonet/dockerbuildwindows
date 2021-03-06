# build
FROM cirrusci/windowsservercore:2019
LABEL maintainer=michel.promonet@free.fr

ENV chocolateyUseWindowsCompression="true"
       
# Install Chocolatey & packages
RUN powershell.exe -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
RUN choco install --no-progress -y curl --version 7.68.0
RUN choco install --no-progress -y git python2 sed windows-sdk-10 
RUN choco install --no-progress -y cmake --installargs 'ADD_CMAKE_TO_PATH=System'
RUN choco install --no-progress -y visualstudio2017buildtools --package-parameters "--add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Workload.NativeDesktop --add Microsoft.VisualStudio.Component.VC.ATLMFC --includeRecommended --nocache --installPath C:\BuildTools" || IF "%ERRORLEVEL%"=="3010" EXIT 0   

