Import-Module activedirectory

$BASEDIR = "\\srvfs01\home$"
foreach ($SAM in Get-Content seznam.txt){
    $HOMEDIR = "$BASEDIR\$SAM"
	Write-Host "Setting HOME in profile for: $SAM: $HOMEDIR\$SAM"
	set-aduser $SAM -homedirectory $HOMEDIR -homedrive H:
	$CheckUserhomedir=$(try {Test-Path $HOMEDIR} catch {$null}) 
    if ($CheckUserhomedir -ne $True) {
		try {
			New-Item -ItemType directory -Path $HOMEDIR -EA Stop | Out-Null
		} catch {
			Write-Host "ERROR: Nelze vytvorit adresar: $HOMEDIR"
		}
		$acl = Get-Acl $HOMEDIR
		$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule ($SAM, "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
		$acl.SetAccessRule($AccessRule)
		Set-Acl -Path $HOMEDIR -AclObject $acl -ea Stop
		Write-Host "Opravneni nastaveno pro: $HOMEDIR"
	}
}