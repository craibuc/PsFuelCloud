FormatTaskName "-------- {0} --------"

Task Symlink {
    $Module='PsFuelCloud'
    $Here = Get-Location
    Push-Location ~/.local/share/powershell/Modules
    ln -s "$Here/$Module" $Module
    Pop-Location
}

Task default -depends Publish

Task Publish {
    publish-module -name ./PsFuelCloud -Repository Lorenz
}