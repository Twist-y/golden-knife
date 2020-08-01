# Golden Knife

Commands
```bash
sm_goldKnife
sm_gk
sm_gn
```

## Installation

Download latest Release and upload GoldenKnife.smx to
```bash
csgo/addons/sourcemod/plugins
```


## Maps
Currently only maps supported are 
```bash
surf_utopia_v3
```
To add more maps go into GoldenKnife.sp find 
```sourcepawn
// To add more maps just copy this part and change surf_utopia_v3 ----------------------------------------
if(StrContains(sMap, "surf_utopia_v3")) 
{
	CPrintToChat(client, "%s {default}Current map does not have Golden Knife!", g_sPluginTag);
	return Plugin_Handled;
} 
	// -------------------------------------------------------------------------------------------------------
 ```
 copy and paste it then change surf_utopia_v3 to the map of your choice 
