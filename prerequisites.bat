

docker pull mclasson/redis:bionic
docker pull microsoft/dotnet:2.0-runtime
docker pull microsoft/aspnetcore-build:2.0
docker pull microsoft/dotnet:2.1-aspnetcore-runtime
docker pull microsoft/dotnet:2.1-sdk
docker pull microsoft/aspnetcore:2.0
docker pull microsoft/dotnet:2.0-sdk
docker pull microsoft/dotnet:2.1-runtime
docker pull microsoft/dotnet:2.1-sdk
docker pull microsoft/mssql-server-linux:2017-latest
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
choco install kubernetes-helm -y
helm init --upgrade --service-account default
helm repo update
rem helm search
