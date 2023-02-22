FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5111

Env ASPERNETCORE_URLS=http://+:5111


FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["mywebsite.csproj", "./"]
RUN dotnet restore "mywebsite.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "mywebsite.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "mywebsite.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet",  "mywebsite.dll"]
