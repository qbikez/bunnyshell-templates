# Learn about building .NET container images:
# https://github.com/dotnet/dotnet-docker/blob/main/samples/README.md
FROM node:18 as clientapp-builder
WORKDIR /source

COPY ["ClientApp/package.json", "ClientApp/package-lock.json", "ClientApp/"]
RUN cd ClientApp && npm ci

COPY ["ClientApp/", "ClientApp/"]
RUN cd ClientApp && npm run build

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS dotnet-builder
WORKDIR /source
COPY --from=clientapp-builder ["/source/ClientApp/dist/", "./ClientApp/dist"]

# copy csproj and restore as distinct layers
COPY *.csproj .
RUN dotnet restore

# copy everything else and build app
COPY . .
RUN dotnet build   --configuration Release --no-restore 
RUN dotnet publish --configuration Release --self-contained false --no-build -p NoNpm=true -o /app


# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
COPY --from=dotnet-builder /app .
ENTRYPOINT ["dotnet", "frontend.dll"]