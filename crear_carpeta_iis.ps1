# Ejecutar como Administrador

$iisPath = "C:\inetpub\wwwroot\Monolito"

if (!(Test-Path $iisPath)) {
    New-Item -Path $iisPath -ItemType Directory
    Write-Host "Carpeta $iisPath creada exitosamente." -ForegroundColor Green
} else {
    Write-Host "La carpeta $iisPath ya existe." -ForegroundColor Yellow
}

# (Opcional) Asignar permisos a IIS_IUSRS si es necesario
$acl = Get-Acl $iisPath
$permission = "BUILTIN\IIS_IUSRS","Modify","Allow"
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
$acl.SetAccessRule($accessRule)
Set-Acl $iisPath $acl

Write-Host "Permisos asignados para IIS_IUSRS." -ForegroundColor Green
Pause
