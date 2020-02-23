# FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env
# FROM mono:latest AS build-env
FROM debian:buster AS build-env
WORKDIR /app

# FROM https://github.com/mono/docker/blob/master/6.8.0.96/slim/Dockerfile

ENV MONO_VERSION 6.8.0.96

# RUN apt-get update \
#   && apt-get install -y --no-install-recommends gnupg dirmngr \
#   && rm -rf /var/lib/apt/lists/* \
#   && export GNUPGHOME="$(mktemp -d)" \
#   && gpg --batch --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
#   && gpg --batch --export --armor 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF > /etc/apt/trusted.gpg.d/mono.gpg.asc \
#   && gpgconf --kill all \
#   && rm -rf "$GNUPGHOME" \
#   && apt-key list | grep Xamarin \
#   && apt-get purge -y --auto-remove gnupg dirmngr

# RUN echo "deb https://download.mono-project.com/repo/debian stable-stretch/snapshots/$MONO_VERSION main" > /etc/apt/sources.list.d/mono-official-vs.list \
#   && apt-get update \
#   && apt-get install -y mono-runtime \
#   && rm -rf /var/lib/apt/lists/* /tmp/*


## End mono docker file

# from https://github.com/dotnet/dotnet-docker/blob/74c92451ecbd2876280ad51736a6eea4e98a1fb2/2.1/sdk/stretch/amd64/Dockerfile


RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
    && rm -rf /var/lib/apt/lists/*

# Install .NET Core
# ENV DOTNET_SDK_VERSION 2.1.804

# RUN curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/$DOTNET_SDK_VERSION/dotnet-sdk-$DOTNET_SDK_VERSION-linux-x64.tar.gz \
#     && dotnet_sha512='82b039856dadd2b47fa56a262d1a1a389132f0db037d4ee5c0872f2949c2cd447c33a978e1f532783119aa416860e03f26b840863ca3a97392a4b77f8df5bf66' \
#     && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
#     && mkdir -p /usr/share/dotnet \
#     && tar -zxf dotnet.tar.gz -C /usr/share/dotnet \
#     && rm dotnet.tar.gz \
#     && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# END FROM docker-netcore

RUN ls /usr/bin/dotnet
RUN /usr/bin/dotnet --version

# Copy csproj and restore as distinct layers
COPY ./*.sln ./
COPY ConsoleApp/*.csproj ConsoleApp/
COPY ClassLibrary1/*.csproj ClassLibrary1/
RUN nuget restore

# Copy everything else and build
COPY . ./
# RUN dotnet publish -c Release -o out --framework net472
# RUN dotnet build -c Release 
RUN msbuild 

# Build runtime image
# FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
# WORKDIR /app
# COPY --from=build-env /app/out .
# ENTRYPOINT ["dotnet", "ConsoleApp.dll"]