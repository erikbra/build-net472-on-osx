# build-net472-on-osx
Demonstrates a problem building net472 projects referencing netstandard2.0 libraries on macOS.

I have several projects I'm working on (external and internal), that target net472, which references `netstandard2.0` 
libraries,
that I have problems with building on macOS box. This is a minimal repo that reproduces the behaviour.

Some notes:

* The problem affects only `net472` full-framework builds, not `netcoreapp3.1`. 
* Everything build fine on GitHub actions (when including ref to Microsoft.NETFramework.ReferenceAssemblies nuget package)
* Builds fine using Docker based on mcr.microsoft.com/dotnet/core/sdk:3.1 
  * Run `docker build -t consoleapp .` in   root dir

So, the problem seems to be when mono is installed?


## Steps to reproduce - on macOS
```
git clone https://github.com/erikbra/build-net472-on-osx.git
cd build-net472-on-osx
dotnet build
```


When building locally on my macOS, I get the following problem (which seems to be a problem everyone is having all around).


## Using msbuild (mono):
```sh
✘-1 ~/src/Repos/build-net472-on-osx [master|✔] 
13:38 $ msbuild -v:q
Microsoft (R) Build Engine version 16.5.0-ci for Mono
Copyright (C) Microsoft Corporation. All rights reserved.

Program.cs(14,32): error CS0012: The type 'Enum' is defined in an assembly that is not referenced. You must add a reference to assembly 'netstandard, Version=2.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. [/Users/erik/src/Repos/build-net472-on-osx/ConsoleApp/ConsoleApp.csproj]
```

## Using dotnet build

```sh

✘-1 ~/src/Repos/build-net472-on-osx [master|✔] 
13:38 $ dotnet build
Microsoft (R) Build Engine version 16.4.0+e901037fe for .NET Core
Copyright (C) Microsoft Corporation. All rights reserved.

  Restore completed in 31.55 ms for /Users/erik/src/Repos/build-net472-on-osx/ConsoleApp/ConsoleApp.csproj.
  Restore completed in 31.55 ms for /Users/erik/src/Repos/build-net472-on-osx/ClassLibrary1/ClassLibrary1.csproj.
  ClassLibrary1 -> /Users/erik/src/Repos/build-net472-on-osx/ClassLibrary1/bin/Debug/netstandard2.0/ClassLibrary1.dll
Program.cs(14,32): error CS0012: The type 'Enum' is defined in an assembly that is not referenced. You must add a reference to assembly 'netstandard, Version=2.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. [/Users/erik/src/Repos/build-net472-on-osx/ConsoleApp/ConsoleApp.csproj]
  ConsoleApp -> /Users/erik/src/Repos/build-net472-on-osx/ConsoleApp/bin/Debug/netcoreapp3.1/ConsoleApp.dll

Build FAILED.

Program.cs(14,32): error CS0012: The type 'Enum' is defined in an assembly that is not referenced. You must add a reference to assembly 'netstandard, Version=2.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'. [/Users/erik/src/Repos/build-net472-on-osx/ConsoleApp/ConsoleApp.csproj]
    0 Warning(s)
    1 Error(s)

Time Elapsed 00:00:01.09
✘-1 ~/src/Repos/build-net472-on-osx [master|✔] 
13:39 $ 
```

## Workarounds

If you look at the ClassLibrary1/ClassLibrary1.csproj file, and change

```
 <TargetFramework>netstandard2.0</TargetFramework>
```

to 

```
 <TargetFrameworks>net472;netstandard2.0</TargetFrameworks>
```

then everything works. Similarly, if I build only for `netcoreapp3.1` by changing the target framework in ConsoleApp1.csproj,
it compiles as well.
