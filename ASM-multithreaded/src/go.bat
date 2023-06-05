@echo off

rem Set this value to the location of rc.exe under the VC directory
set rc_directory="C:\Program Files (x86)\Windows Kits\10\bin\10.0.22000.0\x86

rem Set this value to the location of ml64.exe under the VC directory
set ml_directory="C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Tools\MSVC\14.29.30133\bin\Hostx64\x64

rem Set this value to the location of link.exe under the VC directory
set link_directory="C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Tools\MSVC\14.29.30133\bin\Hostx64\x64

%rc_directory%\rc.exe" resource.rc
%ml_directory%\ml64.exe" /c /Cp /Cx /Fm /FR /W2 /Zd /Zf /Zi /Ta DXSample.asm > errors.txt
rem %ml_directory%\ml64.exe" /c /Cp /Cx /Fm /FR /W2 /Zd /Zf /Zi /Ta structures.asm > errorsStructures.txt
%link_directory%\link.exe" DXSample.obj largeArrays.obj font_nasm.obj resource.res /debug:full /opt:ref /opt:noicf /def:DXSample.def /entry:Startup /machine:x64 /map /out:DXSample.exe /PDB:DXSample.pdb /subsystem:windows,6.0^
 "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22000.0\ucrt\x64\ucrt.lib"^
 "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22000.0\um\x64\uuid.lib"^
 "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Tools\MSVC\14.29.30133\lib\x64\msvcrt.lib"^
 "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Tools\MSVC\14.29.30133\lib\x64\libvcruntime.lib"^
 "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22000.0\um\x64\Gdi32.lib"^
 "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22000.0\um\x64\kernel32.lib"^
 "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22000.0\um\x64\user32.lib"^
 "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22000.0\um\x64\d3d11.lib"^
 "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22000.0\um\x64\d3dcompiler.lib"^
 "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22000.0\um\x64\winmm.lib"^
 DXSampleMath.lib

type errors.txt

start /wait DXSample.exe
echo %errorlevel%
