# BatCenter by Kvc

This program will help you download the batch plugins from selected sources, you can search and see details about them before downloading.

## Installation  

### Windows 10:


```curl -L https://batch-man.com/batcenter.bat --output batcenter.bat && batcenter.bat & del batcenter.bat /q /f > nul```

### Windows 8:

```PowerShell -Command Invoke-WebRequest -Uri "https://batch-man.com/batcenter.bat" -Outfile "%cd%\batcenter.bat" && batcenter.bat & del batcenter.bat /q /f > nul```

### Windows 7:


```bitsadmin /transfer debjob /download /priority Normal https://batch-man.com/batcenter.bat "%cd%\batcenter.bat" > nul && batcenter.bat & del batcenter.bat /q /f > nul```

## Usage

Read [USAGE.md](https://github.com/Batch-Man/BatCenter-by-Kvc/blob/main/USAGE.md) to get the usage about this plugin.
