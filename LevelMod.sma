/* 
	LevelMod @ 2012 by LordOfNothinG

	This project has been started in 2011 now, latest update has been
	made in 2014, i hope you will enjoy my latest version of levelmod

	This software is a free / public software and is illegal to edit
	or sell or made money with him, For more info, plugins please visit:
			

			Thanks Hattrick !
*/

#include <amxmodx>
#include <amxmisc>
#include <fun>
#include <hamsandwich>
#include <nvault>
#include <cstrike>
#include <fakemeta>
 
#define TAG "hNsX.eCiLa.Ro"
 
new const PLUGIN_NAME[] = "Level Mod";
new const hnsxp_version[] = "6.0.0.0";
new const LEVELS[151] = {
       
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
        290200000, //32
        290300000, // 33
        290400000, // 34
        290500000, // 35
        290600000, // 36
        290700000, // 37
        290800000, // 38
        290900000, // 39
        291000000, // 40
        292000000, // 41
        293000000, // 42
        294000000, // 43
        295000000, // 44
        296000000, // 45
        297000000, // 46
        298000000, // 47
        299000000, // 48
        299990000, // 97
        300000000, // 98
        300050000, // 99
        300060000, // 100
        300070000, // 1
        300080000,// 2
        300090000,
        300100000,
        300200000,
        300300000,
        300400000,
        300500000,
        300600000,
        300700000,
        301000000,
        302000000,
        303000000,
        304000000,
        305000000,
        306000000,
        307000000,
        308000000,
        309000000,
        310000000,
        340000000,
        350000000,
        360000000,
        370000000,
        380000000,
        390000000,
        400000000,
        400500000,
        400600000,
        400700000,
        400800000,
        400900000,
        401000000,
        402000000,
        403000000,
        404000000,
        405000000,
        406000000,
        407000000,
        408000000,
        409000000,
        410000000,
        420000000,
        430000000,
        440000000,
        450000000,
        460000000,
        470000000,
        480000000,
        490000000,
        500000000
}
new hnsxp_playerxp[33], hnsxp_playerlevel[33];
new g_hnsxp_vault, wxp, xlevel;
 
#define is_user_vip(%1)         ( get_user_flags(%1) & ADMIN_IMMUNITY )
#define IsPlayer(%1) ( 1 <= %1 <=  g_iMaxPlayers )
new g_iMaxPlayers
 
 
new Data[64];
 
new toplevels[33];
new topnames[33][33];
 
 
enum Color
{
        NORMAL = 1, // clients scr_concolor cvar color
        YELLOW = 1, // NORMAL alias
        GREEN, // Green Color
        TEAM_COLOR, // Red, grey, blue
        GREY, // grey
        RED, // Red
        BLUE, // Blue
}
 
new TeamName[][] =
{
        "",
        "TERRORIST",
        "CT",  
        "SPECTATOR"
}
 
 
public plugin_init()
{
        register_plugin(PLUGIN_NAME, hnsxp_version, "LordOfNothing");
 
        RegisterHam(Ham_Spawn, "player", "hnsxp_spawn", 1);
	register_event("DeathMsg", "hnsxp_playerdie", "a");		
 
 
        register_clcmd("say /level","plvl");
        register_clcmd("say /xp","plvl");
 
        register_clcmd("say /levels","plvls");
        register_clcmd("say_team /level","plvl");
        register_clcmd("say_team /xp","plvl");
 
        register_clcmd("say /lvl","tlvl");
        g_hnsxp_vault = nvault_open("levelmod_vault");
       
 
        register_event("SendAudio", "t_win", "a", "2&%!MRAD_terwin")
 
        xlevel = CreateMultiForward("PlayerMakeNextLevel", ET_IGNORE, FP_CELL);
        wxp = CreateMultiForward("PlayerIsHookXp", ET_IGNORE, FP_CELL);
        register_forward(FM_ClientUserInfoChanged, "ClientUserInfoChanged")
 
        RegisterHam ( Ham_TakeDamage, "player", "Ham_CheckDamage_Bonus", .Post = false );
        RegisterHam ( Ham_Item_PreFrame, "player", "Ham_CheckSpeed_Bonus", 1);
       
        register_clcmd("say /toplevel","sayTopLevel");
        register_clcmd("say_team /toplevel","sayTopLevel");
        register_concmd("amx_resetleveltop","concmdReset_Top");
       
        get_datadir(Data, 63);
        read_top();
 
        register_concmd("amx_xp", "xp_cmd", ADMIN_LEVEL_H, "amx_xp <NICK> <NUMARUL DE XP>")
        register_concmd("amx_givexp", "givexp_cmd", ADMIN_LEVEL_H, "amx_givexp <NICK> <NUMARUL DE XP>")
        register_concmd("amx_takexp", "takexp_cmd", ADMIN_LEVEL_H, "amx_takexp <NICK> <NUMARUL DE XP>")
        register_concmd("amx_level", "level_cmd", ADMIN_LEVEL_H, "amx_level <NICK> <NUMARUL DE LEVEL>")
        register_concmd("amx_takelevel", "takelevel_cmd", ADMIN_LEVEL_H, "amx_takelevel <NICK> <NUMARUL DE LEVEL>")
        register_concmd("amx_givelevel", "givelevel_cmd", ADMIN_LEVEL_H, "amx_givelevel <NICK> <NUMARUL DE LEVEL>")

	set_task(120.0,"LevelMod_msg",0,"",0,"b",0)
}
 
public Ham_CheckDamage_Bonus( pevVictim, pevInflictor, pevAttacker, Float:flDamage, iDmgBits )
{
    if( !( 1 <= pevAttacker <= g_iMaxPlayers) )
    {
        return HAM_HANDLED;
    }
     
    if( !is_user_alive( pevAttacker )  )
    {
        return HAM_HANDLED;
    }
 
    SetHamParamFloat( 4 , flDamage + 10 * hnsxp_playerlevel[ pevAttacker ] )
 
    return HAM_IGNORED;
}

public LevelMod_msg(id)
{
	ColorChat(0, TEAM_COLOR, "^1[ ^3%s^1 ] ^4%s^1 ^3(^1R^3)^1 by ^3LordOfNothinG^1 versiune ^4%s^1 !",TAG,PLUGIN_NAME,hnsxp_version)
}
 
/*      Speed Check      */
public Ham_CheckSpeed_Bonus( id )
{
        if( !is_user_alive( id ) || cs_get_user_team( id ) != CS_TEAM_T )
        {
                return HAM_IGNORED;
        }
       
        set_user_maxspeed( id, 250.0 + 3 * hnsxp_playerlevel[ id ] );
                       
        return HAM_IGNORED;
}
 
public xp_cmd(id,level,cid)
{
        if(!cmd_access(id,level,cid,3))
                return PLUGIN_HANDLED;
       
        new arg[33], amount[220]
        read_argv(1, arg, 32)
        new target = cmd_target(id, arg, 7)
        read_argv(2, amount, charsmax(amount) - 1)
       
        new exp = str_to_num(amount)
       
        if(!target)
        {
                return 1
        }
       
        hnsxp_playerxp[target] = exp
        checkandupdatetop(target,hnsxp_playerlevel[target])
        UpdateLevel(target)
        return 0
}
 
 
public givexp_cmd(id,level,cid)
{
        if(!cmd_access(id,level,cid,3))
                return PLUGIN_HANDLED;
       
        new arg[33], amount[220]
        read_argv(1, arg, 32)
        new target = cmd_target(id, arg, 7)
        read_argv(2, amount, charsmax(amount) - 1)
       
        new exp = str_to_num(amount)
       
        if(!target)
        {
                return 1
        }
       
        hnsxp_playerxp[target] = hnsxp_playerxp[target] + exp
        checkandupdatetop(target,hnsxp_playerlevel[target])
        UpdateLevel(target)
        return 0
}
 
 
public takexp_cmd(id,level,cid)
{
        if(!cmd_access(id,level,cid,3))
                return PLUGIN_HANDLED;
       
        new arg[33], amount[220]
        read_argv(1, arg, 32)
        new target = cmd_target(id, arg, 7)
        read_argv(2, amount, charsmax(amount) - 1)
 
        new exp = str_to_num(amount)
       
        if(!target)
        {
                return 1
        }
       
        hnsxp_playerxp[target] = hnsxp_playerxp[target] - exp
        checkandupdatetop(target,hnsxp_playerlevel[target])
        return 0
}
 
public level_cmd(id,level,cid)
{
        if(!cmd_access(id,level,cid,3))
                return PLUGIN_HANDLED;
       
        new arg[33], amount[220]
        read_argv(1, arg, 32)
        new target = cmd_target(id, arg, 7)
        read_argv(2, amount, charsmax(amount) - 1)
       
        new exp = str_to_num(amount)
       
        if(!target)
        {
                return 1
        }
       
        hnsxp_playerlevel[target] = exp
        checkandupdatetop(target,hnsxp_playerlevel[target])
        UpdateLevel(target)
        return 0
}
 
 
public takelevel_cmd(id,level,cid)
{
        if(!cmd_access(id,level,cid,3))
                return PLUGIN_HANDLED;
       
        new arg[33], amount[220]
        read_argv(1, arg, 32)
        new target = cmd_target(id, arg, 7)
        read_argv(2, amount, charsmax(amount) - 1)
       
        new exp = str_to_num(amount)
       
        if(!target)
        {
                return 1
        }
       
        hnsxp_playerlevel[target] = hnsxp_playerlevel[target] - exp
        checkandupdatetop(target,hnsxp_playerlevel[target])
        return 0
}
 
 
public givelevel_cmd(id,level,cid)
{
        if(!cmd_access(id,level,cid,3))
                return PLUGIN_HANDLED;
       
        new arg[33], amount[220]
        read_argv(1, arg, 32)
        new target = cmd_target(id, arg, 7)
        read_argv(2, amount, charsmax(amount) - 1)
       
        new exp = str_to_num(amount)
       
        if(!target)
        {
                return 1
        }
       
        hnsxp_playerlevel[target] = hnsxp_playerlevel[target] - exp
        checkandupdatetop(target,hnsxp_playerlevel[target])
        UpdateLevel(target)
        return 0
}
 
public save_top() {
        new path[128];
        formatex(path, 127, "%s/LevelTop.dat", Data);
        if( file_exists(path) ) {
                delete_file(path);
        }
        new Buffer[256];
        new f = fopen(path, "at");
        for(new i = 0; i < 15; i++)
        {
                formatex(Buffer, 255, "^"%s^" ^"%d^"^n",topnames[i],toplevels[i] );
                fputs(f, Buffer);
        }
        fclose(f);
}
public concmdReset_Top(id) {
       
        if( !(get_user_flags(id) & read_flags("abcdefghijklmnopqrstu"))) {
                       return PLUGIN_HANDLED;
        }
        new path[128];
        formatex(path, 127, "%s/LevelTop.dat", Data);
        if( file_exists(path) ) {
                delete_file(path);
        }        
        static info_none[33];
        info_none = "";
        for( new i = 0; i < 15; i++ ) {
                formatex(topnames[i], 31, info_none);
                toplevels[i]= 0;
        }
        save_top();
        new aname[32];
        get_user_name(id, aname, 31);
        ColorChat(0, TEAM_COLOR,"^1[^3 %s^1 ] Adminul ^4%s^1 a resetat top level!",TAG, aname);
        return PLUGIN_CONTINUE;
}
public checkandupdatetop(id, levels) {        
 
        new name[32];
        get_user_name(id, name, 31);
        for (new i = 0; i < 15; i++)
        {
                if( levels > toplevels[i] )
                {
                        new pos = i;        
                        while( !equal(topnames[pos],name) && pos < 15 )
                        {
                                pos++;
                        }
                       
                        for (new j = pos; j > i; j--)
                        {
                                formatex(topnames[j], 31, topnames[j-1]);
                                toplevels[j] = toplevels[j-1];
                               
                        }
                        formatex(topnames[i], 31, name);
                       
                        toplevels[i]= levels;
                       
                        ColorChat(0, TEAM_COLOR,"^1[^3 %s^1 ] Jucatorul ^4%s^1 a intrat pe locul ^4%i^1 in top level !",TAG, name,(i+1));
                        if(i+1 == 1) {
                                client_cmd(0, "spk vox/doop");
                        } else {
                                client_cmd(0, "spk buttons/bell1");
                        }
                        save_top();
                        break;
                }
                else if( equal(topnames[i], name))
                break;        
        }
}
public read_top() {
        new Buffer[256],path[128];
        formatex(path, 127, "%s/LevelTop.dat", Data);
       
        new f = fopen(path, "rt" );
        new i = 0;
        while( !feof(f) && i < 15+1)
        {
                fgets(f, Buffer, 255);
                new lvls[25];
                parse(Buffer, topnames[i], 31, lvls, 24);
                toplevels[i]= str_to_num(lvls);
               
                i++;
        }
        fclose(f);
}
public sayTopLevel(id) {       
        static buffer[2368], name[131], len, i;
        len = formatex(buffer, 2047, "<body bgcolor=#FFFFFF><table width=100%% cellpadding=2 cellspacing=0 border=0>");
        len += format(buffer[len], 2367-len, "<tr align=center bgcolor=#52697B><th width=10%% > # <th width=45%%> Nume <th width=45%%>Level");
        for( i = 0; i < 15; i++ ) {            
                if( toplevels[i] == 0) {
                        len += formatex(buffer[len], 2047-len, "<tr align=center%s><td> %d <td> %s <td> %s",((i%2)==0) ? "" : " bgcolor=#A4BED6", (i+1), "-", "-");
                        //i = NTOP
                }
                else {
                        name = topnames[i];
                        while( containi(name, "<") != -1 )
                                replace(name, 129, "<", "&lt;");
                        while( containi(name, ">") != -1 )
                                replace(name, 129, ">", "&gt;");
                        len += formatex(buffer[len], 2047-len, "<tr align=center%s><td> %d <td> %s <td> %d",((i%2)==0) ? "" : " bgcolor=#A4BED6", (i+1), name,toplevels[i]);
                }
        }
        len += format(buffer[len], 2367-len, "</table>");
        len += formatex(buffer[len], 2367-len, "<tr align=bottom font-size:11px><Center><br><br><br><br>LevelMod 2013 by LordOfNothing</body>");
        static strin[20];
        format(strin,33, "Top Level");
        show_motd(id, buffer, strin);
}
public GiveExp(index)
{
        switch(hnsxp_playerlevel[index])
        {
                case 0..10:
                {
                        hnsxp_playerxp[index] = hnsxp_playerxp[index] + 1000;
                }
 
                case 11..20:
                {
                        hnsxp_playerxp[index] = hnsxp_playerxp[index] + 5000;
                }
                case 21..30:
                {
                        hnsxp_playerxp[index] = hnsxp_playerxp[index] + 15040;
                }
 
                case 31..40:
                {
                        hnsxp_playerxp[index] = hnsxp_playerxp[index] + 25030;
                }
 
                case 41..50:
                {
                        hnsxp_playerxp[index] = hnsxp_playerxp[index] + 45060;
                }
 
                case 51..80:
                {
                        hnsxp_playerxp[index] = hnsxp_playerxp[index] + 15000;
                }
 
                case 81..100:
                {
                        hnsxp_playerxp[index] = hnsxp_playerxp[index] + 180050;
                }
 
                case 101..150:
                {
                        hnsxp_playerxp[index] = hnsxp_playerxp[index] + 10000000;
                }
 
                default:
                {
                        hnsxp_playerxp[index] = hnsxp_playerxp[index] + 0;
                }
        }
}
public ClientUserInfoChanged(id)
{
        static const name[] = "name"
        static szOldName[32], szNewName[32]
        pev(id, pev_netname, szOldName, charsmax(szOldName))
        if( szOldName[0] )
        {
                get_user_info(id, name, szNewName, charsmax(szNewName))
                if( !equal(szOldName, szNewName) )
                {
                        set_user_info(id, name, szOldName)
                        ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Pe acest server nu este permisa schimbarea numelui !",TAG);
                        return FMRES_HANDLED
                }
        }
        return FMRES_IGNORED
}
 
public plugin_natives()
{
        register_native("get_user_xp","_get_user_xp");
        register_native("get_user_level","_get_user_level");
        register_native("set_user_xp","_set_user_xp");
        register_native("set_user_level","_set_user_level");
}
 
public _get_user_xp(plugin, params)
{
        return hnsxp_playerxp[get_param(1)];
}
 
public _get_user_level(plugin, params)
{
        return hnsxp_playerlevel[get_param(1)];
}
 
public _set_user_xp(plugin, xer)
{
        new id = get_param(1)
        new value = get_param(2)
 
        if(is_user_connected(id))
        {
                hnsxp_playerxp[id] = value;
                return 0
        }
 
        else
        {
                log_error(AMX_ERR_NATIVE,"User %d is not connected !",id)
                return 0
        }
        return 1
}
 
 
public _set_user_level(plugin, eat)
{
        new id = get_param(1)
        new valuex = get_param(2)
 
        if(is_user_connected(id))
        {
                hnsxp_playerlevel[id] = valuex;
                return 0
        }
 
        else
        {
                log_error(AMX_ERR_NATIVE,"User %d is not connected !",id)
                return 0
        }
        return 1
}
 
public gItem(id)
{
 
        new dgl = give_item(id, "weapon_deagle")
 
        if(is_user_alive(id))
        {
                switch(hnsxp_playerlevel[id])
                {
               
                        case 0:
                        {
                                cs_set_weapon_ammo(dgl, 1);
                                ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Ai primit ^4 1DGL !",TAG);
                                remove_task(id);
                        }
                       
                        case 1..20:
                        {
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 1);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 1);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 1);
                                set_user_health(id, get_user_health(id) + 3);
                                cs_set_weapon_ammo(dgl, 1);
                                ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Ai primit ^4 3HP ^1, ^4 1DGL ^1, ^4 1SG ^1, ^4 1FL ^1, ^4 1HE ^1!",TAG);
                                remove_task(id);
               
                        }
                   
               
                        case 21..40:
                        {
                       
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 2);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 2);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 2);
                               
                                cs_set_weapon_ammo(dgl, 2);
                                cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                               
                                set_user_health(id, get_user_health(id) + 5);
                                ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Ai primit ^4 5HP ^1, ^4 2DGL ^1, ^4 2 SG ^1, ^4 2FL ^1, ^4 2HE ^1!",TAG);
                                remove_task(id);
                        }
 
                        case 41..60:
                        {
               
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 3);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 3);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 3);
                       
                                cs_set_weapon_ammo(dgl, 3);
                                cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                       
                                set_user_health(id, get_user_health(id) + 10);
                                ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Ai primit ^4 10HP ^1, ^4 3DGL ^1, ^4 3SG ^1, ^4 3FL ^1, ^4 3HE ^1!",TAG);
                                remove_task(id);
                        }
               
                        case 61..80:
                        {
                       
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 3);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 4);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 4);
                               
                                cs_set_weapon_ammo(dgl, 4);
                               
                                cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                                set_user_health(id, get_user_health(id) + 20);
                                ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Ai primit ^4 20HP ^1, ^4 4DGL ^1, ^4 4SG ^1, ^4 4FL ^1, ^4 3HE ^1!",TAG);
                                remove_task(id);
                        }
                       
                        case 81..100:
                        {
                       
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 4);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 2);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 5);
                               
                                cs_set_weapon_ammo(dgl, 5);
                               
                                cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                                set_user_health(id, get_user_health(id) + 20);
                                ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Ai primit ^4 20HP ^1, ^4 4DGL ^1, ^4 3SG ^1, ^4 3FL ^1, ^4 3HE ^1!",TAG);
                                remove_task(id);
                        }
 
                    case 101..150:
                        {
                       
                                give_item(id, "weapon_hegrenade");
                                give_item(id, "weapon_flashbang");
                                give_item(id, "weapon_smokegrenade");
                                cs_set_user_bpammo(id, CSW_HEGRENADE, 5);
                                cs_set_user_bpammo(id, CSW_FLASHBANG, 5);
                                cs_set_user_bpammo(id, CSW_SMOKEGRENADE, 5);
                               
                                cs_set_weapon_ammo(dgl, 6);
                               
                                cs_set_user_bpammo(id, CSW_DEAGLE, 0);
                                set_user_health(id, get_user_health(id) + 30);
                                ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Ai primit ^4 30HP ^1, ^4 6DGL ^1, ^4 5SG ^1, ^4 5FL ^1, ^4 5HE ^1!",TAG);
                                remove_task(id);
                        }
                       
 
                }
                       
        }
 
}
 
UpdateLevel(id)
{
        if((hnsxp_playerlevel[id] < 101) && (hnsxp_playerxp[id] >= LEVELS[hnsxp_playerlevel[id]]))
        {
                ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Felicitari ai trecut la nivelul urmator !",TAG);            
                ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Felicitari ai trecut la nivelul urmator !",TAG);
                ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Felicitari ai trecut la nivelul urmator !",TAG);
                ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Felicitari ai trecut la nivelul urmator !",TAG);
                ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] Felicitari ai trecut la nivelul urmator !",TAG);
                new ret;
                ExecuteForward(xlevel, ret, id);
                while(hnsxp_playerxp[id] >= LEVELS[hnsxp_playerlevel[id]])
                {
                        hnsxp_playerlevel[id]++;
                }
        }
       
}
 
public hnsxp_spawn(id)
{
        set_task(15.0, "gItem", id);
        UpdateLevel(id);
        checkandupdatetop(id,hnsxp_playerlevel[id]);

	new GRAVITYCheck = 800 - 3 * hnsxp_playerlevel[ id ];

	if(is_user_alive(id))
	{
		set_user_gravity( id, float( GRAVITYCheck ) / 800.0 );
	}
}
 
public plvl(id)
{
       
        ColorChat(id, TEAM_COLOR,"^1[^3 %s^1 ] ^4LVL ^1: ^3%i ^1, ^4XP ^1: ^3%i ^1/ ^3%i ",TAG, hnsxp_playerlevel[id], hnsxp_playerxp[id], LEVELS[hnsxp_playerlevel[id]]);
        return PLUGIN_HANDLED
}
 
public plvls(id)
{
        new players[32], playersnum, name[40], motd[1024], len;
       
        len = formatex(motd, charsmax(motd), "<html> <center> <font color=red> <b>LEVEL NUME XP <br ></font> </b> <body bgcolor=black></center> ");
        get_players(players, playersnum);
       
        for ( new i = 0 ; i < playersnum ; i++ ) {
                get_user_name(players[i], name, charsmax(name));
                len += formatex(motd[len], charsmax(motd) - len, "<center> <br><font color=green> <b> [%i] %s: %i</font>  </center> ",hnsxp_playerlevel[players[i]], name, hnsxp_playerxp[players[i]]);
        }
       
        formatex(motd[len], charsmax(motd) - len, "</html>");
        show_motd(id, motd);
        return PLUGIN_HANDLED
       
       
}
public tlvl(id)
{
        new poj_Name [ 32 ];
        get_user_name(id, poj_Name, 31)
        ColorChat(0, TEAM_COLOR,"^1[^3 %s^1 ] Jucatorul ^3%s ^1are nivelul ^4%i",TAG,poj_Name, hnsxp_playerlevel[id]);
        return PLUGIN_HANDLED
}
 
public hnsxp_death( iVictim, attacker, shouldgib )
{
       
        if( !attacker || attacker == iVictim )
                return;
       
        GiveExp(attacker);
        new ret;
        ExecuteForward(wxp, ret, attacker);
       
       
        UpdateLevel(attacker);
        UpdateLevel(iVictim);
        checkandupdatetop(iVictim,hnsxp_playerlevel[iVictim]);
        checkandupdatetop(attacker,hnsxp_playerlevel[attacker]);
 
        if(is_user_vip(attacker))
        {
                GiveExp(attacker);
        }
}
 
public client_connect(id)
{
 
        LoadData(id);
        checkandupdatetop(id,hnsxp_playerlevel[id])              
}
public client_disconnect(id)
{
 
        SaveData(id);
        checkandupdatetop(id,hnsxp_playerlevel[id])
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
 
public t_win(id)
{
       
        new iPlayer [ 32 ], iNum;
        get_players(iPlayer, iNum, "ae", "TERRORIST")
        for ( new i = 0; i < iNum; i++ ) {
                GiveExp(iPlayer [ i ]);
                ColorChat(iPlayer[i], TEAM_COLOR,"^1[^3 %s^1 ] Ai primit ^4XP^1 pentru ca echipa ^4TERO^1 a castigat !",TAG);
                UpdateLevel(iPlayer[i]);
                checkandupdatetop(iPlayer[i],hnsxp_playerlevel[iPlayer[i]])
        }
}
ColorChat(id, Color:type, const msg[], {Float,Sql,Result,_}:...)
{
        new message[256];
 
        switch(type)
        {
                case NORMAL: // clients scr_concolor cvar color
                {
                        message[0] = 0x01;
                }
                case GREEN: // Green
                {
                        message[0] = 0x04;
                }
                default: // White, Red, Blue
                {
                        message[0] = 0x03;
                }
        }
         
        vformat(message[1], 251, msg, 4);
 
        // Make sure message is not longer than 192 character. Will crash the server.
        message[191] = '^0';
 
        new team, ColorChange, index, MSG_Type;
        if(id)
        {
                MSG_Type = MSG_ONE;
                index = id;
        } else {
                index = FindPlayer();
                MSG_Type = MSG_ALL;
        }
 
        team = get_user_team(index);
        ColorChange = ColorSelection(index, MSG_Type, type);
 
 
        ShowColorMessage(index, MSG_Type, message);
        if(ColorChange)
        {
                Team_Info(index, MSG_Type, TeamName[team]);
        }
}
 
ShowColorMessage(id, type, message[])
{
        static get_user_msgid_saytext;
        if(!get_user_msgid_saytext)
        {
                get_user_msgid_saytext = get_user_msgid("SayText");
        }
        message_begin(type, get_user_msgid_saytext, _, id);
        write_byte(id) 
        write_string(message);
        message_end(); 
}
 
Team_Info(id, type, team[])
{
        static bool:teaminfo_used;
        static get_user_msgid_teaminfo;
        if(!teaminfo_used)
        {
                get_user_msgid_teaminfo = get_user_msgid("TeamInfo");
                teaminfo_used = true;
        }
        message_begin(type, get_user_msgid_teaminfo, _, id);
        write_byte(id);
        write_string(team);
        message_end();
 
        return 1;
}
 
ColorSelection(index, type, Color:Type)
{
        switch(Type)
        {
                case RED:
                {
                        return Team_Info(index, type, TeamName[1]);
                }
                case BLUE:
                {
                        return Team_Info(index, type, TeamName[2]);
                }
                case GREY:
                {
                        return Team_Info(index, type, TeamName[0]);
                }
        }
 
        return 0;
}
 
FindPlayer()
{
        new i = -1;
        static iMaxPlayers;
        if( !iMaxPlayers )
        {
                iMaxPlayers = get_maxplayers( );
        }
        while(i <= iMaxPlayers)
        {
                if(is_user_connected(++i))
                        return i;
        }
 
        return -1;
}

