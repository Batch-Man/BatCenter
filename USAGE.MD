 ## This program will help you download the batch plugins from selected sources, you can search and see details about them before downloading.  
 
 
### CREDITS: Bat 1.0 by Kvc

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
```

 Example: ``Call Bat Update``  
 Example: ``Call Bat Update Microsoft``  
 Example: ``Call Bat List``  
 Example: ``Call Bat Search batbox 3.1``  
 Example: ``Call Bat Install batbox 3.1``  
 Example: ``Call Bat Install 10``  
 Example: ``Call Bat Detail batbox 3.1``  
 Example: ``Call Bat Detail 10``  
 Example: ``Call Bat Reset``  
 Example: ``Call Bat Reset all``  
 Example: ``Call Bat ver``  
 Example: ``Call Bat /?``  


 ### PLUGINS REQUIRED FOR THIS PROJECT...  **
 ```
 7za.exe  
 jq.exe  
 ReadLine.exe  
 StrSplit.exe  
 StrSurr.exe  
 wget.exe  
```
 
**[#Batch-man](https://batch-man.com)** 
