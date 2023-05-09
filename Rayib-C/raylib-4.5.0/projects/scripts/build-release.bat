xcopy /s assets\fonts builds\windows-msvc\assets\fonts\ /Y
xcopy /s assets\shaders builds\windows-msvc\assets\shaders\ /Y
xcopy /s assets\textures builds\windows-msvc\assets\textures\ /Y
xcopy /s assets\models builds\windows-msvc\assets\models\ /Y
xcopy /s assets\sounds builds\windows-msvc\assets\sounds\ /Y
echo f | xcopy /f /y icon.png builds\windows-msvc\icon.png
echo f | xcopy /f /y assets\positions.bin builds\windows-msvc\assets\positions.bin
build-windows.bat -v -c