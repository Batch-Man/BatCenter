#### Bat center supports the following parameters / commands that you can use to install different batch tools / utilities aka batch plugins in your computer directly from windows command line / CMD. You can find the complete technical help directly by calling '***Bat /?***' in the cmd after installing the BatCenter in your system.

**[READ INSTALLATION HELP](https://github.com/Batch-Man/BatCenter/blob/main/README.md)** 

# BatCenter Commands:
 This utility supports the following commands:

```
 1. Update
 2. List
 3. Search
 4. Install
 5. Detail
 6. Reset
 7. Help
 8. Ver
```
___

# 1. Update
Checks for the available updates for the BatCentre and refreshes the available local Data with the new data available online.  
Syntax: ``Call Bat Update [Github_User]``  
Example: ``Call Bat Update`` 
Example: ``Call Bat Update Microsoft`` 
___

# 2. List
Displays a list of available batch utility / plugins in the CMD console.  
Syntax: ``Call Bat List``  
Example: ``Call Bat List``  

___

# 3. Search
You can use search keywords in order to search for the the required batch plugin / utility from list of available plugins.  
Syntax: ``Call Bat Search [Term1] [Term2] [Term3] ...``  
Example: ``Call Bat Search batbox 3.1``  
___

# 4. Install
Downloads and installs the selected batch plugins in the current computer so that they can be used as an internal/inbuilt CMD command.  
Syntax: ``Call Bat Install [Local-ID | [Term1] [Term2] [Term3] ...]``  
Example: ``Call Bat Install batbox 3.1``  
Example: ``Call Bat Install batbox 3.1 -y``  
Example: ``Call Bat Install 10``  
___

# 5. Detail
Displays formatted detail about the selected batch plugin so that user can verify before downloading it in the system.  
Syntax: ``Call Bat Detail [Local-ID | [Term1] [Term2] [Term3] ...]``  
Example: ``Call Bat Detail batbox 3.1``  
Example: ``Call Bat Detail 10``  
___

# 6. Reset
Resets the BatCentre to its initial form (New installation) or uninstalls BatCentre from the current system without leaving any traces behind.  
 Syntax: ``Call Bat Reset [all]``  
 Example: ``Call Bat Reset``  
 Example: ``Call Bat Reset all``  
 
___

# 7. Help
Displays the help menu and command usage examples syntax.  
Syntax: ``call Bat [help | /? | -h | -help]``  
Example: ``Call Bat /?``  
___

# 8. ver
Prints the current version of installed BatCenter.  
Syntax: ``call Bat ver``  
Example: ``Call Bat ver``  

```


 
  
 
 
 
 
 
 


 ### PLUGINS REQUIRED FOR THIS PROJECT...  **
 ```
 7za.exe 			by 7z
 jq.exe 			        by stedolan 
 Getlen.bat			by Kvc
 ReadLine.exe			by Kvc
 StrSplit.exe			by Kvc
 StrSurr.exe			by Kvc
 wget.exe			by Hrvoje
```
 
**[#Batch-man](https://batch-man.com)** 
  
