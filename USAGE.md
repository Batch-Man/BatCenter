#### Bat centre supports the following parameters / commands that you can use to install different batch tools / utilities aka batch plugins in your computer directly from windows command line / CMD. You can find the complete technical help directly by calling '***Bat /?***' in the cmd after installing the BatCenter in your system.

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

___

# 2. List
Displays a list of available batch utility / plugins in the CMD console.

___

# 3. Search
You can use search keywords in order to search for the the required batch plugin / utility from list of available plugins.

___

# 4. Install
Downloads and installs the selected batch plugins in the current computer so that they can be used as an internal/inbuilt CMD command.

___

# 5. Detail
Displays formatted detail about the selected batch plugin so that user can verify before downloading it in the system.

___

# 6. Reset
Resets the BatCentre to its initial form (New installation) or uninstalls BatCentre from the current system without leaving any traces behind.

___

# 7. Help
Displays the help menu and command usage examples syntax.

___

# 8. ver
Prints the current version of installed BatCenter



 Syntax: ``Call Bat Update [Github_User]``  
 Syntax: ``Call Bat List``  
 Syntax: ``Call Bat Search [Term1] [Term2] [Term3] ...``  
 Syntax: ``Call Bat Install [Local-ID | [Term1] [Term2] [Term3] ...]``  
 Syntax: ``Call Bat Detail [Local-ID | [Term1] [Term2] [Term3] ...]``  
 Syntax: ``Call Bat Reset [all]``  
 Syntax: ``call Bat [help | /? | -h | -help]``  
 Syntax: ``call Bat ver``  

 ### Where:-
```
 ver			: Displays version of program  
 help			: Displays help for the program  
 Update [User]		: Updates DATABASE with given user's plugins  
 List			: Lists out list of all Plugins in DATABASE  
 Search			: Filters out plugins as per the given keywords  
 Install		: Downloads and installs batch plugin in the PATH  
 Detail			: Provides detail about the filtered Project  
 Reset [all]		: Removes installed plugins | with [all] it removes BAT  

 Switch:-
 -y | /Y		: Suppresses prompting to confirm your action
 			  ALWAYS USE -Y or /Y at the end of your command.

```


 Example: ``Call Bat Update``  
 Example: ``Call Bat Update Microsoft``  
 Example: ``Call Bat List``  
 Example: ``Call Bat Search batbox 3.1``  
 Example: ``Call Bat Install batbox 3.1``  
 Example: ``Call Bat Install batbox 3.1 -y``  
 Example: ``Call Bat Install 10``  
 Example: ``Call Bat Detail batbox 3.1``  
 Example: ``Call Bat Detail 10``  
 Example: ``Call Bat Reset``  
 Example: ``Call Bat Reset all``  
 Example: ``Call Bat ver``  
 Example: ``Call Bat /?``  


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
  
