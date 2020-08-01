#include <sourcemod>
#include <sdktools>
#include <colorlib>
#include <clientprefs>

#pragma semicolon 1
#pragma newdecls required

// -- Globals
Handle g_hRestartLoad[MAXPLAYERS+1];
Handle g_hSpawnLoad[MAXPLAYERS+1];
Handle g_hGK = INVALID_HANDLE;
bool g_bGK[MAXPLAYERS+1]; 
ConVar g_cPluginTag = null;
char g_sPluginTag[PLATFORM_MAX_PATH];

public Plugin myinfo =
{
	name = "Golden Knife",
	author = "Zxx",
	description = "",
	version = "1.1.0",
	url = ""
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_goldknife", commandGK); 
	RegConsoleCmd("sm_gk", commandGK); 
	RegConsoleCmd("sm_gn", commandGK);
	g_hGK = RegClientCookie("GoldKnife", "Golden Knife", CookieAccess_Private);
	CreateTimer(2.0, lateload);
	AddCommandListener(RestartHook, "sm_restart");   
	AddCommandListener(RestartHook, "sm_r"); 
	HookEvent("player_spawn",SpawnEvent);	  
}
public Action lateload(Handle timer)
{
	g_cPluginTag = FindConVar("ck_chat_prefix");
	g_cPluginTag.AddChangeHook(OnConVarChanged);
	g_cPluginTag.GetString(g_sPluginTag, sizeof(g_sPluginTag));
	LogMessage("Hooked Cvars");
}
public void OnClientCookiesCached(int client)
{
    char sValue[8];
    GetClientCookie(client, g_hGK, sValue, sizeof(sValue));
    g_bGK[client] = (sValue[0] != '\0' && StringToInt(sValue));
}
public void OnConVarChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
    if (convar == g_cPluginTag)
    {
        g_cPluginTag.GetString(g_sPluginTag, sizeof(g_sPluginTag));
    }
}
public Action commandGK(int client, int args)
{
	char sValue[8];
	char sMap[32];
	g_bGK[client] = !g_bGK[client]; 
	IntToString(g_bGK[client], sValue, sizeof(sValue)); 
	SetClientCookie(client, g_hGK, sValue); 
	GetCurrentMap(sMap, sizeof(sMap)); 
	// To add more maps just copy this part and change surf_utopia_v3 ----------------------------------------
	if(StrContains(sMap, "surf_utopia_v3")) 
	{
		CPrintToChat(client, "%s {default}Current map does not have Golden Knife!", g_sPluginTag);
		return Plugin_Handled;
	} 
	// -------------------------------------------------------------------------------------------------------
	if(g_bGK[client])
	{
		CPrintToChat(client, "%s {default}Golden Knife {red}Disabled{default}!", g_sPluginTag);
		SetSpeed(client, 1.0);
		return Plugin_Handled;	
	} 
	else if(!g_bGK[client])
	{
		CPrintToChat(client, "%s {default}Golden Knife {green}Enabled{default}!", g_sPluginTag);
		SetSpeed(client, 1.25);
		return Plugin_Handled;
	}
	return Plugin_Handled;
}
public Action SpawnEvent(Handle event,char[] name,bool dontBroadcast)
{
	int client_id = GetEventInt(event, "userid");
	int client = GetClientOfUserId(client_id);

	if(g_bGK[client])
	{
		SetSpeed(client, 1.0);
	} 
	else if(!g_bGK[client])
	{
		SetSpeed(client, 1.25);
	}	
}
public Action RestartLate(Handle timer, int client) 
{
	if(g_bGK[client])
	{
		SetSpeed(client, 1.0);
	} 
	else if(!g_bGK[client])
	{
		SetSpeed(client, 1.25);
	}	
	g_hRestartLoad[client] = null;
}
public Action RestartHook(int client, char[] command, int args)  
{
	char sMap[32];
	GetCurrentMap(sMap, sizeof(sMap));
	if(!StrContains( sMap, "surf_utopia_v3"))
	{
    g_hRestartLoad[client] = CreateTimer(0.1, RestartLate, client);
	}
	return 	Plugin_Continue;
}
void SetSpeed(int client, float speed)
{
	if(IsClientInGame(client))
	{
		SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", speed); 
	}
}