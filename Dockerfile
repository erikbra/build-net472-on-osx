FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY ./*.sln ./
COPY ConsoleApp/*.csproj ConsoleApp/
COPY ClassLibrary1/*.csproj ClassLibrary1/
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish ConsoleApp/ConsoleApp.csproj -c Release -o out --framework net472
#RUN dotnet build -c Release 
#RUN msbuild 

# Build runtime image
#FROM mcr.microsoft.com/dotnet/core/sdk:3.1
#WORKDIR /app
#COPY --from=build-env /app/out .

#RUN ls -lR /app

#ENTRYPOINT ["dotnet", "ConsoleApp.exe"]
#ENTRYPOINT ["./ConsoleApp.exe"]