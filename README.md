# Backup Souls
Simple and configurable PowerShell script for creating automatic save file backups for FromSoftware games.

## Installation & Use
Open the script file (`backup-souls.ps1`) in any text editor and set paths for your save files and for your desired backup folder. Refer to **Configuration** section for details.
Then simply run the script in PowerShell, either by running the file directly (_Run with PowerShell_) or from Windows Terminal by typing in  `./backup-souls.ps1`.
If you want to run the script more easily, you can create a shortcut for it and edit the **Target** field in properties.  Append the start of it with `powershell.exe -ExecutionPolicy Bypass -File`. So it looks like this: `powershell.exe -ExecutionPolicy Bypass -File <PATH_TO_YOUR_SCRIPT>`. Now you can just run the shortcut and it will directly run the script in PowerShell.

## Configuration
 - `$BackupDirectory` - Path to your desired backup folder location. This is where your backups will be saved, separated in folders for each game. Replace `<DESIRED_BACKUP_PATH>` with the path to your backup folder location (folder will be created in case it doesn't exist).
 - `$BackupLimit` - Number of backups that will be kept for each game (when exceeded, oldest backups get deleted). Set to any number value you desire.
 - `$IntervalInSeconds` - Interval in seconds at which backups will be created. Set to any number value you desire.
 - `$Games` - List of custom objects for all suppoted games. If you don't need all of them, you can remove `[PSCustomObject]@{ ... }` elements from the list for games you don't need. Here you need to change `SaveDirectory` value for each game to the path to your save folder location.