
/* AMX Mod X
* Level Mod Plugin
*
* by LordOfNothing
*
* This file is part of AMX Mod X.
*
*
* This program is free software; you can redistribute it and/or modify it
* under the terms of the GNU General Public License as published by the
* Free Software Foundation; either version 2 of the License, or (at
* your option) any later version.
*
* This program is distributed in the hope that it will be useful, but
* WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program; if not, write to the Free Software Foundation,
* Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
*
* In addition, as a special exception, the author gives permission to
* link the code of this program with the Half-Life Game Engine ("HL
* Engine") and Modified Game Libraries ("MODs") developed by Valve,
* L.L.C ("Valve"). You must obey the GNU General Public License in all
* respects for all of the code used other than the HL Engine and MODs
* from Valve. If you modify this file, you may extend this exception
* to your version of the file, but you are not obligated to do so. If
* you do not wish to do so, delete this exception statement from your
* version.
*/

#include <amxmodx>
#include <amxmisc>
#include <fun>
#include <hamsandwich>
#include <nvault>
#include <cstrike>

new const PLUGIN_NAME[] = "Level Mod";
new const hnsxp_version[] = "5.2";
new const LEVELS[100] = {
        
        1000, // 1
        3000, // 2
        5000, // 3
        7000, // 4
        9000, // 5
        10000, // 6
        15000, // 7
        20000, // 8
        25000, // 10
        30000, // 11
        40000, // 12
        50000, // 13
        60000, // 14
        70000, // 15
        100000, // 16
        120000, // 17
        130000, // 18
        150000, // 19
        200000, // 20
        250000, // 21
        300000, // 22
        350000, // 23
        400000, // 24
        450000, // 25
        500000, // 26
        600000, // 27
        700000, // 28
        800000, // 29
        1000000, // 30
        1200000, // 31
        1300000, //32
        1400000, // 33
        1500000, // 34
        1600000, // 35
        1700000, // 36
        1800000, // 37
        1900000, // 38
        1950000, // 39
        2000000, // 40
        2500000, // 41
        3000000, // 42
        3500000, // 43
        4000000, // 44
        5000000, // 45
        6000000, // 46
        7000000, // 47
        8000000, // 48
        9000000, // 49
        10000000, // 50
        13000000, // 51
        15000000, // 2
        18000000, // 3
        20000000, // 4
        22500000, // 5
        25000000, // 6
        27500000, // 7
        29000000, // 8
        30000000, // 10
        35000000, // 11
        40000000, // 12
        45000000, // 13
        50000000, // 14
        55000000, // 15
        60000000, // 16
        65000000, // 17
        70000000, // 18
        75000000, // 19
        85000000, // 20
        90000000, // 21
        100000000, // 22
        110000000, // 23
        220000000, // 24
        230000000, // 25
        240000000, // 26
        250000000, // 27
        260000000, // 28
        270000000, // 29
        280000000, // 30
        290000000, // 31
        300000000, //32
        400000000, // 33
        500000000, // 34
        600000000, // 35
        700000000, // 36
        800000000, // 37
        900000000, // 38
        1000000000, // 39
        1500000000, // 40
        2000000000, // 41
        3000000000, // 42
        4000000000, // 43
        5000000000, // 44
        6000000000, // 45
        7000000000, // 46
        7500000000, // 47
        8500000000, // 48
        9099090000, // 97
        10000000000, // 98
        10000500000, // 99
        20000000000 // 100
        
        
}
new hnsxp_playerxp[33], hnsxp_playerlevel[33];
new hnsxp_kill, hnsxp_savexp, g_hnsxp_vault, tero_win, vip_enable, vip_xp, xlevel, wxp;


public plugin_init()
{
        register_plugin(PLUGIN_NAME, hnsxp_version, "LordOfNothing");

        RegisterHam(Ham_Spawn, "player", "hnsxp_spawn", 1);
        RegisterHam(Ham_Killed, "player", "hnsxp_death", 1);

        hnsxp_savexp = register_cvar("hnsxp_savexp","1");
        hnsxp_kill = register_cvar("hnsxp_kill", "1000");
        tero_win = register_cvar("hnsxp_terowin_xp","1500");
        vip_enable = register_cvar("hnsxp_vip_enable","1");
        vip_xp = register_cvar("hnsxp_vip_xp","100000");


        register_clcmd("say /level","plvl");
        register_clcmd("say /xp","plvl");

        register_clcmd("say /levels","plvls");
        register_clcmd("say_team /level","plvl");
        register_clcmd("say_team /xp","plvl");

        register_clcmd("say /lvl","tlvl");
        g_hnsxp_vault = nvault_open("deathrun_xp");

        register_concmd("amx_level", "cmd_give_level", ADMIN_IMMUNITY, "<target> <amount>");
        register_concmd("amx_takelevel", "cmd_take_level", ADMIN_IMMUNITY, "<target> <amount>");
        
        register_concmd("amx_xp", "cmd_give_xp", ADMIN_IMMUNITY, "<target> <amount>");
        register_concmd("amx_takexp", "cmd_take_xp", ADMIN_IMMUNITY, "<target> <amount>");

        register_event("SendAudio", "t_win", "a", "2&%!MRAD_terwin")

	xlevel = CreateMultiForward("PlayerMakeNextLevel", ET_IGNORE, FP_CELL);
	wxp = CreateMultiForward("PlayerIsHookXp", ET_IGNORE, FP_CELL);

}

public plugin_natives()
{
        register_native("get_user_xp","_get_user_xp");
        register_native("get_user_level","_get_user_level");
}

public _get_user_xp(plugin, params)
{
        return hnsxp_playerxp[get_param(1)];
}

public _get_user_level(plugin, params)
{
        return hnsxp_playerlevel[get_param(1)];
}

public gItem(id)
{
        
        switch(hnsxp_playerlevel[id])
        {
                case 1..10:
                {
                        give_item(id, "weapon_hegrenade");
                        give_item(id, "weapon_flashbang");
                        give_item(id, "weapon_smokegrenade");
                        cs_set_user_bpammo(id, CSW_HEGRENADE, 3);
                        cs_set_user_bpammo(id, CSW_FLASHBANG, 3);
                        cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 3);
                        remove_task(id);
                
                }
                
                case 11..20:
                {
                        give_item(id, "weapon_hegrenade");
                        give_item(id, "weapon_flashbang");
                        give_item(id, "weapon_smokegrenade");
                        cs_set_user_bpammo(id, CSW_HEGRENADE, 3);
                        cs_set_user_bpammo(id, CSW_FLASHBANG, 3);
                        cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 3);
                        
                        cs_set_weapon_ammo(give_item(id, "weapon_deagle"), 1)
                        cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                        remove_task(id);
                
                }
                
                case 21..30:
                {
                
                        give_item(id, "weapon_hegrenade");
                        give_item(id, "weapon_flashbang");
                        give_item(id, "weapon_smokegrenade");
                        cs_set_user_bpammo(id, CSW_HEGRENADE, 3);
                        cs_set_user_bpammo(id, CSW_FLASHBANG, 3);
                        cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 3);
                        
                        cs_set_weapon_ammo(give_item(id, "weapon_deagle"), 2)
                        cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                        remove_task(id);                
                }

                case 31..40:
                {
                
                        give_item(id, "weapon_hegrenade");
                        give_item(id, "weapon_flashbang");
                        give_item(id, "weapon_smokegrenade");
                        cs_set_user_bpammo(id, CSW_HEGRENADE, 3);
                        cs_set_user_bpammo(id, CSW_FLASHBANG, 3);
                        cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 3);
                        
                        cs_set_weapon_ammo(give_item(id, "weapon_deagle"), 3)
                        cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                        remove_task(id);                
                }
                
                case 41..50:
                {
                
                        give_item(id, "weapon_hegrenade");
                        give_item(id, "weapon_flashbang");
                        give_item(id, "weapon_smokegrenade");
                        cs_set_user_bpammo(id, CSW_HEGRENADE, 4);
                        cs_set_user_bpammo(id, CSW_FLASHBANG, 4);
                        cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 4);
                        
                        cs_set_weapon_ammo(give_item(id, "weapon_deagle"), 4)
                        cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                        set_user_health(id, get_user_health(id) + 15);
                        remove_task(id);                
                }
                
                case 51..60:
                {
                
                        give_item(id, "weapon_hegrenade");
                        give_item(id, "weapon_flashbang");
                        give_item(id, "weapon_smokegrenade");
                        cs_set_user_bpammo(id, CSW_HEGRENADE, 4);
                        cs_set_user_bpammo(id, CSW_FLASHBANG, 4);
                        cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 4);
                        
                        cs_set_weapon_ammo(give_item(id, "weapon_deagle"), 4)
                        cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                        set_user_health(id, get_user_health(id) + 20);
                        remove_task(id);                
                }
                case 61..70:
                {
                
                        give_item(id, "weapon_hegrenade");
                        give_item(id, "weapon_flashbang");
                        give_item(id, "weapon_smokegrenade");
                        cs_set_user_bpammo(id, CSW_HEGRENADE, 4);
                        cs_set_user_bpammo(id, CSW_FLASHBANG, 4);
                        cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 4);
                        
                        cs_set_weapon_ammo(give_item(id, "weapon_deagle"), 4)
                        cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                        set_user_health(id, get_user_health(id) + 25);
                        remove_task(id);                
                }
                case 71..80:
                {
                
                        give_item(id, "weapon_hegrenade");
                        give_item(id, "weapon_flashbang");
                        give_item(id, "weapon_smokegrenade");
                        cs_set_user_bpammo(id, CSW_HEGRENADE, 5);
                        cs_set_user_bpammo(id, CSW_FLASHBANG, 5);
                        cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 5);
                        
                        cs_set_weapon_ammo(give_item(id, "weapon_deagle"), 4)
                        cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                        set_user_health(id, get_user_health(id) + 30);
                        remove_task(id);                
                }
                case 81..90:
                {
                
                        give_item(id, "weapon_hegrenade");
                        give_item(id, "weapon_flashbang");
                        give_item(id, "weapon_smokegrenade");
                        cs_set_user_bpammo(id, CSW_HEGRENADE, 5);
                        cs_set_user_bpammo(id, CSW_FLASHBANG, 5);
                        cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 5);
                        
                        cs_set_weapon_ammo(give_item(id, "weapon_deagle"), 5)
                        cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                        set_user_health(id, get_user_health(id) + 35);
                        remove_task(id);                
                }
                
                case 91..100:
                {
                
                        give_item(id, "weapon_hegrenade");
                        give_item(id, "weapon_flashbang");
                        give_item(id, "weapon_smokegrenade");
                        cs_set_user_bpammo(id, CSW_HEGRENADE, 6);
                        cs_set_user_bpammo(id, CSW_FLASHBANG, 6);
                        cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 6);
                        
                        cs_set_weapon_ammo(give_item(id, "weapon_deagle"), 6)
                        cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                        set_user_health(id, get_user_health(id) + 40);
                        remove_task(id);                
                }
                
        
        
        }

}

UpdateLevel(id)
{
        if((hnsxp_playerlevel[id] < 101) && (hnsxp_playerxp[id] >= LEVELS[hnsxp_playerlevel[id]]))
        {
                MesajColorat(id,"!echipa[%s] !verdeAi trecut levelul", PLUGIN_NAME);
                new ret;
                ExecuteForward(xlevel, ret, id);
                while(hnsxp_playerxp[id] >= LEVELS[hnsxp_playerlevel[id]])
                {
                        hnsxp_playerlevel[id] += 1;
                }
        }
        
}

public hnsxp_spawn(id)
{
        set_task(2.0, "gItem", id);
        UpdateLevel(id);
        
}

public plvl(id)
{
        
        MesajColorat(id, "!normal[!echipaLevel Mod!normal] !verdeLVL !normal: !echipa%i !normal, !verdeXP !normal: !echipa %i !normal/ !echipa%i ", hnsxp_playerlevel[id], hnsxp_playerxp[id], LEVELS[hnsxp_playerlevel[id]]);
        return PLUGIN_HANDLED
}

public plvls(id)
{
        new players[32], playersnum, name[40], motd[1024], len;
        
        len = formatex(motd, charsmax(motd), "<html> <center> <font color=red> <b>LEVEL		NUME		XP	<br ></font> </b> <body bgcolor=black> ");
        get_players(players, playersnum);
        
        for ( new i = 0 ; i < playersnum ; i++ ) {
                get_user_name(players[i], name, charsmax(name));
                len += formatex(motd[len], charsmax(motd) - len, "<br><font color=red>  <b> [%i]	%s:  	%i</font> </b> </center> ",hnsxp_playerlevel[players[i]], name, hnsxp_playerxp[players[i]]);
        }
        
        formatex(motd[len], charsmax(motd) - len, "</html>");
        show_motd(id, motd);
        return PLUGIN_HANDLED
        
        
}
public tlvl(id)
{
        new poj_Name [ 32 ];
        get_user_name(id, poj_Name, 31)
        MesajColorat(0, "!normal[!echipaLevel-Mod!normal] Jucatorul !echipa%s !normalare nivelul !verde%i",poj_Name, hnsxp_playerlevel[id]);
        return PLUGIN_HANDLED
}

public hnsxp_death( iVictim, attacker, shouldgib )
{
        
        if( !attacker || attacker == iVictim )
                return;
        
        hnsxp_playerxp[attacker] += get_pcvar_num(hnsxp_kill);
	new ret;
      	ExecuteForward(wxp, ret, attacker);
        MesajColorat(attacker,"!echipa[%s] !verdeAi primit %i XP pentru ca l-ai omorat pe %s!", PLUGIN_NAME, get_pcvar_num(hnsxp_kill), iVictim);
        
	UpdateLevel(attacker);

        if(get_user_flags(attacker) & ADMIN_IMMUNITY && get_pcvar_num(vip_enable))
        {
                        hnsxp_playerxp[attacker] += get_pcvar_num(vip_xp);
                        MesajColorat(attacker, "!echipa[%s]!verde Ai primit un bonus de %i xp pentru ca esti VIP !",PLUGIN_NAME,get_pcvar_num(vip_xp));
        }
}

public client_connect(id)
{
        if(get_pcvar_num(hnsxp_savexp) == 1)
                LoadData(id);
}
public client_disconnect(id)
{
        if(get_pcvar_num(hnsxp_savexp) == 1)
                SaveData(id);
        
        hnsxp_playerxp[id] = 0;
        hnsxp_playerlevel[id] = 0;
}
public SaveData(id)
{
        new PlayerName[35];
        get_user_name(id,PlayerName,34);
        
        new vaultkey[64],vaultdata[256];
        format(vaultkey,63,"%s",PlayerName);
        format(vaultdata,255,"%i`i%",hnsxp_playerxp[id],hnsxp_playerlevel[id]);
        nvault_set(g_hnsxp_vault,vaultkey,vaultdata);
        return PLUGIN_CONTINUE;
}
public LoadData(id)
{
        new PlayerName[35];
        get_user_name(id,PlayerName,34);
        
        new vaultkey[64],vaultdata[256];
        format(vaultkey,63,"%s",PlayerName);
        format(vaultdata,255,"%i`%i",hnsxp_playerxp[id],hnsxp_playerlevel[id]);
        nvault_get(g_hnsxp_vault,vaultkey,vaultdata,255);
        
        replace_all(vaultdata, 255, "`", " ");
        
        new playerxp[32], playerlevel[32];
        
        parse(vaultdata, playerxp, 31, playerlevel, 31);
        
        hnsxp_playerxp[id] = str_to_num(playerxp);
        hnsxp_playerlevel[id] = str_to_num(playerlevel);
        
        return PLUGIN_CONTINUE;
}
public cmd_give_level(id, level, cid)
{
        if(!cmd_access(id, level, cid, 3))
                return PLUGIN_HANDLED
        
        new target[32], amount[21], reason[21]
        
        read_argv(1, target, 31)
        read_argv(2, amount, 20)
        read_argv(3, reason, 20)
        
        new player = cmd_target(id, target, 8)
        
        if(!player)
                return PLUGIN_HANDLED
        
        new admin_name[32], player_name[32]
        get_user_name(id, admin_name, 31)
        get_user_name(player, player_name, 31)
        
        new expnum = str_to_num(amount)
        MesajColorat(0, "!normal[ADMIN] !echipa%s: !verdeia dat !echipa%s !verdelevel-uri lui !echipa%s", admin_name, amount, player_name)
        
        hnsxp_playerlevel[player] += expnum
        SaveData(player)
        
        return PLUGIN_CONTINUE
}
public cmd_give_xp(id, level, cid)
{
        if(!cmd_access(id, level, cid, 3))
                return PLUGIN_HANDLED
        
        new target[32], amount[21], reason[21]
        
        read_argv(1, target, 31)
        read_argv(2, amount, 20)
        read_argv(3, reason, 20)
        
        new player = cmd_target(id, target, 8)
        
        if(!player)
                return PLUGIN_HANDLED
        
        new admin_name[32], player_name[32]
        get_user_name(id, admin_name, 31)
        get_user_name(player, player_name, 31)
        
        new expnum = str_to_num(amount)
        MesajColorat(0, "!normal[ADMIN] !echipa%s: !verdeia dat !echipa%s !verdexp lui !echipa%s", admin_name, amount, player_name)
        
        hnsxp_playerxp[player] += expnum
	new ret;
      	ExecuteForward(wxp, ret, player);

	UpdateLevel(player);

        SaveData(player)
        
        return PLUGIN_CONTINUE
}
public cmd_take_level(id, level, cid)
{
        if(!cmd_access(id, level, cid, 3))
                return PLUGIN_HANDLED
        
        new target[32], amount[21], reason[21]
        
        read_argv(1, target, 31)
        read_argv(2, amount, 20)
        read_argv(3, reason, 20)
        
        new player = cmd_target(id, target, 8)
        
        if(!player)
                return PLUGIN_HANDLED
        
        new admin_name[32], player_name[32]
        
        get_user_name(id, admin_name, 31)
        get_user_name(player, player_name, 31)
        
        new expnum = str_to_num(amount)
        MesajColorat(0, "!normal[ADMIN] !echipa%s: !verdeia luat !echipa%s !verdelevel-uri lui !echipa%s", admin_name, amount, player_name)
        
        hnsxp_playerlevel[player] -= expnum
        SaveData(player)
        
        return PLUGIN_CONTINUE
}
public cmd_take_xp(id, level, cid)
{
        if(!cmd_access(id, level, cid, 3))
                return PLUGIN_HANDLED
        
        new target[32], amount[21], reason[21]
        
        read_argv(1, target, 31)
        read_argv(2, amount, 20)
        read_argv(3, reason, 20)
        
        new player = cmd_target(id, target, 8)
        
        if(!player)
                return PLUGIN_HANDLED
        
        new admin_name[32], player_name[32]
        
        get_user_name(id, admin_name, 31)
        get_user_name(player, player_name, 31)
        
        new expnum = str_to_num(amount)
        MesajColorat(0, "!normal[ADMIN] !echipa%s: !verdeia luat !echipa%s !verdelevel-uri lui !echipa%s", admin_name, amount, player_name)
        
        hnsxp_playerxp[player] -= expnum
        SaveData(player)
        
        return PLUGIN_CONTINUE
}

public plugin_cfg()
{
	new Players[32]
	new playerCount, i, player
	get_players(Players, playerCount, "b")	
	for (i=0; i<playerCount; i++)
	   player = Players[i] 

	SaveData(player);
}

public t_win(id)
{
        
        new iPlayer [ 32 ], iNum;
        get_players(iPlayer, iNum, "ae", "TERRORIST")
        for ( new i = 0; i < iNum; i++ ) {
                hnsxp_playerxp[iPlayer [ i ]] += get_pcvar_num(tero_win);
                MesajColorat(iPlayer[i], "!echipa[Level Mod] !verdeAi primit !echipa %i xp !verde pentru ca echipa !echipaT !verdea castigat !",get_pcvar_num(tero_win));
        }
}
stock MesajColorat(const id, const input[], any:...)
{
        new count = 1, players[32]
        static msg[191]
        vformat(msg, 190, input, 3)
        
        replace_all(msg, 190, "!verde", "^4")
        replace_all(msg, 190, "!normal", "^1")
        replace_all(msg, 190, "!echipa", "^3")
        
        if (id) players[0] = id; else get_players(players, count, "ch")
        {
		for (new i = 0; i < count; i++)
		{
			if (is_user_connected(players[i]))
			{
				message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("SayText"), _, players[i])
                        	write_byte(players[i]);
                        	write_string(msg);
                        	message_end();
			}
		}
	}
}
