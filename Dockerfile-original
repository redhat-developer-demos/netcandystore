# The `FROM` instruction specifies the base image. You are
# extending the `microsoft/aspnet` image.

FROM  mcr.microsoft.com/dotnet/framework/aspnet:4.8

RUN Powershell Add-WindowsFeature web-server
RUN Powershell Add-WindowsFeature NET-Framework-45-ASPNET
RUN Powershell Add-WindowsFeature Web-Asp-Net45


# The final instruction copies the site you published earlier into the container.
COPY ./bin/app.publish/ /inetpub/wwwroot