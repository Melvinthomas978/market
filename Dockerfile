#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["market/market.csproj", "market/"]
RUN dotnet restore "market/market.csproj"
COPY . .
WORKDIR "/src/market"
RUN dotnet build "market.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "market.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "market.dll"]
