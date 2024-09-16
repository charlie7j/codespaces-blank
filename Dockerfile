FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 5130

ENV ASPNETCORE_URLS=http://+:5130

USER app
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG configuration=Release
WORKDIR /src
COPY ["codespaces-blank.csproj", "./"]
RUN dotnet restore "codespaces-blank.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "codespaces-blank.csproj" -c $configuration -o /app/build

FROM build AS publish
ARG configuration=Release
RUN dotnet publish "codespaces-blank.csproj" -c $configuration -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "codespaces-blank.dll"]
