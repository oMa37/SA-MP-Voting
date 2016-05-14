/*
Voting System by _oMa37 
Don't remove the credits!
*/

#define FILTERSCRIPT

#include <a_samp>
#include <ZCMD>
#include <sscanf2>
#include <foreach>

#define red 0xFF0000FF
#define green 0x00FF00FF
#define yellow 0xFFFF00FF
#define SCM SendClientMessage
forward CancelVote();
#define strcpy(%0,%1) \
            strcat((%0[0] = '\0', %0), %1)

new OnVote;
new Voted[MAX_PLAYERS];

enum VOTES
{
	Vote[50],
	VoteY,
	VoteN,
}
new Voting[VOTES];

GetName(playerid)
{
	new pName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pName, MAX_PLAYER_NAME);
	return pName;
}

CMD:vote(playerid, params[])
{
    if(isnull(params)) return SCM(playerid, red, "Make a vote: /vote <Text>");
    new str[128];
    OnVote = 1;
  
    strcpy(Voting[Vote], params, 50);
    format(str, sizeof(str), "%s has started a vote: %s", GetName(playerid), params);
    SendClientMessageToAll(green, str);
    SendClientMessageToAll(green, "Type /yes or /no to vote");
    SetTimer("CancelVote",20000, 0); // 20 Seconds, You can increase it.
    //if(GetPVarInt(playerid,"CMDVOTE") > GetTickCount()) return SCM(playerid,0xFF0000FF,"You have to wait 10 minutes to use the command again"); // To avoid the abusing :3
    //SetPVarInt(playerid,"CMDVOTE",GetTickCount()+600000);
    return 1;
}

CMD:yes(playerid, params[])
{
	new str[128];
	if(OnVote == 1)
	{
		if(Voted[playerid] == 1) return SCM(playerid, red, "You have already voted, You can't vote again!");
		Voted[playerid] = 1;
		Voting[VoteY]++;
		format(str, sizeof(str), "Vote: %s - Yes: %d No: %d", Voting[Vote], Voting[VoteY], Voting[VoteN]);
		SCM(playerid, yellow, str);
		return 1;
	}
	else return SCM(playerid, red, "There is no vote currently");
}

CMD:no(playerid, params[])
{
	new str[128];
	if(OnVote == 1)
	{
		if(Voted[playerid] == 1) return SCM(playerid, red, "You have already voted, You can't vote again!");
		Voted[playerid] = 1;
		Voting[VoteN]++;
		format(str, sizeof(str), "Vote: %s | Yes: %d No: %d", Voting[Vote], Voting[VoteY], Voting[VoteN]);
		SCM(playerid, yellow, str);
		return 1;
	}
	else return SCM(playerid, red, "There is no vote currently");
}

CMD:cvote(playerid, params[])
{
	new str[128], res[50];
	if(!IsPlayerAdmin(playerid)) return SCM(playerid, red, "You're not allowed to use this command");
	if(sscanf(params, "S()[50]", res)) return SCM(playerid, red, "Cancel vote: /cvote <Reason>");
	if(OnVote == 0) return SCM(playerid, red, "There is no vote currently");

	if(!isnull(res))
	format(str, sizeof(str), "Administrator %s has canceled the vote: %s", GetName(playerid), res);
	else format(str, sizeof(str), "Administrator %s has canceled the vote", GetName(playerid));
	SendClientMessageToAll(red, str);
	OnVote = 0;
	foreach(new i : Player) Voted[i] = 0;
	Voting[VoteY] = 0;
	Voting[VoteN] = 0;
	return 1;
}

CMD:votes(playerid, params[])
{
	new Players = 0;
	new string[500], str[128];
	if(!IsPlayerAdmin(playerid)) return SCM(playerid, red, "You're not allowed to use this command");
	new vote_res[][] = {"No", "Yes"};
	string = "{FFFFFF}";

	foreach(new i : Player)
	{
    	if (Voted[i] != -1)
    	{
        	format(str, 128, "{FFFFFF}%s - {00FF00}%s\n", GetName(i), vote_res[Voted[i]]);
        	strcat(string, str, sizeof(string));
        	Players++;
    	}
	}
	if(Players == 0)
   	ShowPlayerDialog(playerid, 135,DIALOG_STYLE_MSGBOX,"Note","{FF0000}No one has voted" ,"Close","");
    if(OnVote == 0)
   	ShowPlayerDialog(playerid, 136,DIALOG_STYLE_MSGBOX,"Note","{FF0000}There is no vote currently" ,"Close","");
   	else ShowPlayerDialog(playerid,165,DIALOG_STYLE_LIST,"Players Votes",string,"OK","");
	return 1;
}

CMD:credits(playerid, params[])
{
	ShowPlayerDialog(playerid, 547, DIALOG_STYLE_MSGBOX, "Credits", "{FFFFFF}Scripter: {00FF00}_oMa37", "Close", "");
    return 1;
}

public CancelVote()
{
	if(OnVote == 0) return 0;
	new str[128], str2[128];
	foreach(new i : Player) Voted[i] = 0;
	format(str, sizeof(str), "Vote: %s is OVER!", Voting[Vote]);
	format(str2, sizeof(str2), "Yes: %d No: %d", Voting[VoteY], Voting[VoteN]);
	SendClientMessageToAll(green, str);
	SendClientMessageToAll(green, str2);
	OnVote = 0;
	Voting[VoteY] = 0;
	Voting[VoteN] = 0;
	return 1;
}
