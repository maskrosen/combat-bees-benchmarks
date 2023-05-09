xcopy /s assets\fonts builds-debug\windows-msvc\assets\fonts\ /Y
xcopy /s assets\shaders builds-debug\windows-msvc\assets\shaders\ /Y
xcopy /s assets\textures builds-debug\windows-msvc\assets\textures\ /Y
xcopy /s assets\models builds-debug\windows-msvc\assets\models\ /Y
xcopy /s assets\sounds builds-debug\windows-msvc\assets\sounds\ /Y
echo f | xcopy /f /y icon.png builds-debug\windows-msvc\icon.png
echo f | xcopy /f /y assets\positions.bin builds-debug\windows-msvc\assets\positions.bin
build-windows.bat -d -r -v