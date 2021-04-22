# The `FROM` instruction specifies the base image. You are
# extending the `microsoft/aspnet` image.

FROM  mcr.microsoft.com/dotnet/framework/aspnet:4.8


# The final instruction copies the site you published earlier into the container.
COPY ./bin/app.publish/ /inetpub/wwwroot