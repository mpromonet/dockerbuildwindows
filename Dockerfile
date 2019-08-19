# build
FROM mcr.microsoft.com/windows/servercore:ltsc2019 as builder
LABEL maintainer=michel.promonet@free.fr

ENV    DEPOT_TOOLS_WIN_TOOLCHAIN=0 \
       CLANG_VERSION=ToT \
       PYTHONIOENCODING=UTF-8 \
       GYP_MSVS_OVERRIDE_PATH=C:\\BuildTools \
       GYP_MSVS_VERSION=2017

# Install Chocolatey & packages
RUN powershell.exe -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SETX PATH "%PATH%;%ALLUSERSPROFILE%\chocolatey\bin" 
RUN choco install --no-progress -y git python2 sed curl windows-sdk-10 \
       && choco install --no-progress -y cmake --installargs 'ADD_CMAKE_TO_PATH=User' \
       && choco install --no-progress -y visualstudio2017buildtools --package-parameters "--add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Workload.NativeDesktop --add Microsoft.VisualStudio.Component.VC.ATLMFC --includeRecommended --nocache --installPath C:\BuildTools" || IF "%ERRORLEVEL%"=="3010" EXIT 0   

# install WebRTC 
RUN git config --global core.autocrlf false \
       && git config --global core.filemode false \
       && git config --global branch.autosetuprebase always \
       && git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git --depth 1 C:\depot_tools \
       && SETX PATH "%PATH%;C:\depot_tools" 
# workaround bootstraping that delete the cipd.ps1 file       
#RUN powershell -NoProfile -ExecutionPolicy RemoteSigned -Command C:\depot_tools\cipd.ps1 -CipdBinary C:\depot_tools\.cipd_client.exe -BackendURL https://chrome-infra-packages.appspot.com -VersionFile C:\depot_tools\cipd_client_version   
RUN gclient --version
