$BackupDirectory = "<DESIRED_BACKUP_PATH>"
$BackupLimit = 20
$IntervalInSeconds = 600

$Games = @(
	[PSCustomObject]@{
		Name = 'Dark Souls'
		Process = 'DarkSouls'
		SaveDirectory = '<USERPROFILE>\Documents\NBGI\DarkSouls'
		SaveFileName = 'DRAKS0005.sl2'
	},
	[PSCustomObject]@{
		Name = 'Dark Souls - Remastered'
		Process = 'DarkSoulsRemastered'
		SaveDirectory = '<MY_DOCUMENTS>\NBGI\DARK SOULS REMASTERED\57515145'
		SaveFileName = 'DRAKS0005.sl2'
	},
	[PSCustomObject]@{
		Name = 'Dark Souls II - SotFS'
		Process = 'DarkSoulsII'
		SaveDirectory = 'C:\Users\<USERNAME>\AppData\Roaming\DarkSoulsII\<PROFILE_ID>'
		SaveFileName = 'DS2SOFS0000.sl2'
	},
	[PSCustomObject]@{
		Name = 'Dark Souls III'
		Process = 'DarkSoulsIII'
		SaveDirectory = 'C:\Users\<USERNAME>\AppData\Roaming\DarkSoulsIII\<PROFILE_ID>'
		SaveFileName = 'DS30000.sl2'
	},
	[PSCustomObject]@{
		Name = 'Sekiro'
		Process = 'Sekiro'
		SaveDirectory = 'C:\Users\<USERNAME>\AppData\Roaming\Sekiro\<PROFILE_ID>'
		SaveFileName = 'S0000.sl2'
	},
	[PSCustomObject]@{
		Name = 'Elden Ring'
		Process = 'EldenRing'
		SaveDirectory = 'C:\Users\<USERNAME>\AppData\Roaming\EldenRing\<PROFILE_ID>'
		SaveFileName = 'ER0000.sl2'
	},
	[PSCustomObject]@{
		Name = 'Armored Core VI'
		Process = 'armoredcore6'
		SaveDirectory = 'C:\Users\<USERNAME>\AppData\Roaming\ArmoredCore6\<PROFILE_ID>'
		SaveFileName = 'AC60000.sl2'
	}
)

Write-Output "Backup Souls started ..."
Write-Output "Backup directory: $BackupDirectory"
Write-Output "Backup limit: $BackupLimit"
Write-Output "Backup interval: $($IntervalInSeconds)s"
Write-Output "..."

while ($true) {
	foreach ($Game in $Games) {
		$SourceFile = Get-Item -Path "$($Game.SaveDirectory)\$($Game.SaveFileName)"
		$TargetDirectory = "$BackupDirectory\$($Game.Name)"
		
		if (Test-Path -Path $SourceFile) {
			$IsGameRunning = Get-Process -Name $Game.Process -ErrorAction SilentlyContinue
			
			if ($IsGameRunning) {
				if (!(Test-Path -Path $TargetDirectory)) {
					New-Item -ItemType Directory -Force -Path $TargetDirectory > $null
				}
				
				$LastBackup = Get-ChildItem -Path $TargetDirectory | Sort-Object LastWriteTime | Select-Object -Last 1
				
				if ($LastBackup.LastWriteTime -ne $SourceFile.LastWriteTime) {
					Write-Output "[$(Get-Date -f "yyyy-MM-dd HH:mm:ss")] [$($Game.Name)] Creating new backup"
					
					Copy-Item $SourceFile "$TargetDirectory\$(Get-Date -f "yyyy-MM-dd_HH-mm-ss")_$($Game.SaveFileName)" -Force
					
					while ((Get-ChildItem -Path $TargetDirectory).Count -gt $BackupLimit) {
						Write-Output "[$(Get-Date -f "yyyy-MM-dd HH:mm:ss")] [$($Game.Name)] Limit exceeded - removing oldest backup"
						
						Get-ChildItem -Path $TargetDirectory | Sort-Object LastWriteTime | Select-Object -First 1 | Remove-Item
					}
				} else {
					Write-Output "[$(Get-Date -f "yyyy-MM-dd HH:mm:ss")] [$($Game.Name)] No changes - skipping backup"
				}
			}
		}
	}
	
	Start-Sleep -Seconds $IntervalInSeconds
}
