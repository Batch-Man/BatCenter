### BatCenter supports the following parameters that you can use to install different batch plugins in your computer directly from CMD. You can find the complete technical help directly by calling _`Bat /?`_ after installing BatCenter in your system.

**[Installation help](https://github.com/Batch-Man/BatCenter/blob/main/README.md)** 

# Commands:
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
 9. iList
```
___

## 1. Update
Checks for the available updates for the BatCentre and refreshes the available local Data with the new data available online.  
**Syntax:** ``Call Bat Update [Github_User]``  
**Example:** ``Call Bat Update`` - To update DB from Default Hosts  
**Example:** ``Call Bat Update Microsoft``- To Update DB from Microsoft github  
___

## 2. List
Displays a list of available batch utility / plugins in the CMD console.  
**Syntax:** ``Call Bat List``  
**Example:** ``Call Bat List``  

___

## 3. Search
You can use search keywords in order to search for the the required batch plugin / utility from list of available plugins.  
**Syntax:** ``Call Bat Search [Term1] [Term2] [Term3] ...``  
**Example:** ``Call Bat Search batbox 3.1``  
**Example:** ``Call Bat Search batbox -y``  -Supresses any Confirmation from the prompt and shows Results  
___

## 4. Install
Downloads and installs the selected batch plugins in the current computer so that they can be used as an internal/inbuilt CMD command.  
**Syntax:** ``Call Bat Install [Local-ID | [Term1] [Term2] [Term3] ...]``  
**Example:** ``Call Bat Install batbox 3.1``  -If only one unique result is found - then -> ***downloads and installs***  
**Example:** ``Call Bat Install batbox 3.1 -y``  -Supresses any Confirmation from the prompt and shows Results  
**Example**: ``Call Bat Install 10``  -uses Local-ID to target and download the plugin to computer  (use ```bat detail 10``` to see details of it)
___

## 5. Detail
Displays formatted detail about the selected batch plugin so that user can verify before downloading it in the system.  
**Syntax:** ``Call Bat Detail [Local-ID | [Term1] [Term2] [Term3] ...]``  
**Example:** ``Call Bat Detail batbox 3.1``  
**Example:** ``Call Bat Detail batbox -y``  -Supresses any Confirmation from the prompt and shows Results  
**Example:** ``Call Bat Detail 10``  -uses Local-ID to target and display details of the plugin  
___

## 6. Reset
Resets the BatCentre to its initial form (New installation) or uninstalls BatCentre from the current system without leaving any traces behind.  
**Syntax:** ``Call Bat Reset [all]``  
**Example:** ``Call Bat Reset``  -Resets the BatCenter to its initial (Newly installed) form - Clearing DB & removing installed plugins.  
**Example:** ``Call Bat Reset all``  -Removes BatCenter from the system without leaving any traces behind.
 
___

## 7. Help
Displays the help menu and command usage examples syntax.  
**Syntax:** ``call Bat [help | /? | -h | -help]``  
**Example:** ``Call Bat /?``  
___

## 8. ver
Prints the current version of installed BatCenter.  
**Syntax:** ``call Bat ver``  
**Example:** ``Call Bat ver``  

___

## 9. iList
List Out all the Currently Installed Plugins in the system.  
**Syntax:** ``call Bat iList``  
**Example:** ``Call Bat iList``  

___
___
## Important
If you are calling BatCenter directly from the CMD console, then you do not need to use the `call` before `bat`, you can skip to the shorter syntax as:  ``Bat Update``
___
___

 ### Plugins required**
 ```
 7za.exe 			by Igor Pavlov
 jq.exe 			        by stedolan 
 Getlen.bat			by Kvc
 ReadLine.exe			by Kvc
 StrSplit.exe			by Kvc
 StrSurr.exe			by Kvc
 wget.exe			by GNU Project
```
 
**[#Batch-man](https://batch-man.com)** 
  
