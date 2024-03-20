Get-ChildItem examples -Filter *.qml -Recurse | Foreach-Object {
    Write-Output $_.FullName
    pyside6-qmllint.exe $_.FullName -I stubs -I ../build-QuickGraphLib-Desktop_Qt_6_5_1_MSVC2019_64bit-RelWithDebInfo
}
Get-ChildItem QuickGraphLib -Filter *.qml -Recurse | Foreach-Object {
    Write-Output $_.FullName
    pyside6-qmllint.exe $_.FullName -I stubs -I ../build-QuickGraphLib-Desktop_Qt_6_5_1_MSVC2019_64bit-RelWithDebInfo
}