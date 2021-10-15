-----------------------script---------------------
script_name("Admin Tools")
script_author("Shepi")

-----------------------script---------------------

-----------------------require-------------------
local imgui = require 'imgui'
local encoding = require "lib.encoding"
    require 'lib.moonloader'
    local fa = require 'faIcons'
local inicfg = require "inicfg"
local sampev = require 'lib.samp.events'
local memory = require 'memory'
local ffi = require 'ffi'

local notify = import 'lib_imgui_notf.lua'


------------------autoupdate-----------

local dlstatus = require('moonloader').download_status

------------------autoupdate-----------

local script_vers = 1.0
local script_vers_text = "v1.0" -- Название нашей версии. В будущем будем её выводить ползователю.

local update_url = 'https://raw.githubusercontent.com/shep1ch/hell/main/update.ini' -- Путь к ini файлу. Позже нам понадобиться.
local update_path = getWorkingDirectory() .. "/update.ini"

local script_url = 'https://raw.githubusercontent.com/shep1ch/hell/main/MRPAtools1.lua' -- Путь скрипту.
local script_path = thisScript().path


function check_update() -- Создаём функцию которая будет проверять наличие обновлений при запуске скрипта.
    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then -- Сверяем версию в скрипте и в ini файле на github
                sampAddChatMessage(tag .. " {FFFFFF}Имеется {32CD32}новая {FFFFFF}версия скрипта. Версия: {32CD32}"..updateIni.info.vers_text..". {FFFFFF}В скором времени обновление будет загружено.", 0xFF0000) -- Сообщаем о новой версии.
				notify.addNotify("{5301d8}AdminTools", "Загружается обновление " .. updateIni.info.vers_text .. , "Ожидайте обновления", 2, 1, 1, 5)
                update_found == true -- если обновление найдено, ставим переменной значение true
            end
            os.remove(update_path)
        end
    end)
end
-----------------------require-------------------


--------------------------трейсера пуль----------------------------

--------------------------трейсера пуль: иникфг----------------

local HLcfg = inicfg.load({
    config = {
        staticObjectMy = 29056040,
        dinamicObjectMy = 90139629,
        pedPMy = 18629728,
        carPMy = 62825729,
        staticObject = 29056040,
        dinamicObject = 90139629,
        pedP = 18629728,
        carP = 62825729,
        colorPlayerI = 23222712,
        drawMyBullets = true,
        drawBullets = true,
        cbEndMy = true,
        cbEnd = true,
        showPlayerInfo = false,
        onlyId = true,
        onlyNick = true,
        timeRenderMyBullets = 10,
        timeRenderBullets = 10, -- время линий
        sizeOffMyLine = 1,
        sizeOffLine = 1, -- толщина линий 
        sizeOffMyPolygonEnd = 1,
        sizeOffPolygonEnd = 1, -- размер окончания
        rotationMyPolygonEnd = 10, 
        rotationPolygonEnd = 10, -- количество углов окончания
        degreeMyPolygonEnd = 50,
        degreePolygonEnd = 50,  -- градус поворота окончаний 
        maxLineMyLimit = 30,
        maxLineLimit = 30 -- макс кол-во линий
    }
}, "MrpAdminTools.ini")
inicfg.save(HLcfg, "MrpAdminTools.ini")


--------------------------трейсера пуль: иникфг----------------


local elements = {
    checkbox = {
        drawMyBullets = imgui.ImBool(HLcfg.config.drawMyBullets),
        drawBullets = imgui.ImBool(HLcfg.config.drawBullets),
        cbEndMy = imgui.ImBool(HLcfg.config.cbEndMy),
        cbEnd = imgui.ImBool(HLcfg.config.cbEnd),
        showPlayerInfo = imgui.ImBool(HLcfg.config.showPlayerInfo),
        onlyId = imgui.ImBool(HLcfg.config.onlyId),
        onlyNick = imgui.ImBool(HLcfg.config.onlyNick)
    },
    int = {
        timeRenderMyBullets = imgui.ImInt(HLcfg.config.timeRenderMyBullets),
        timeRenderBullets = imgui.ImInt(HLcfg.config.timeRenderBullets),
        sizeOffMyLine = imgui.ImInt(HLcfg.config.sizeOffMyLine),
        sizeOffLine = imgui.ImInt(HLcfg.config.sizeOffLine),
        sizeOffMyPolygonEnd = imgui.ImInt(HLcfg.config.sizeOffMyPolygonEnd),
        sizeOffPolygonEnd = imgui.ImInt(HLcfg.config.sizeOffPolygonEnd),
        rotationMyPolygonEnd = imgui.ImInt(HLcfg.config.rotationMyPolygonEnd),
        rotationPolygonEnd = imgui.ImInt(HLcfg.config.rotationPolygonEnd),
        degreeMyPolygonEnd = imgui.ImInt(HLcfg.config.degreeMyPolygonEnd),
        degreePolygonEnd = imgui.ImInt(HLcfg.config.degreePolygonEnd),
        maxLineMyLimit = imgui.ImInt(HLcfg.config.maxLineMyLimit),
        maxLineLimit = imgui.ImInt(HLcfg.config.maxLineLimit)
    }
}

-- BOOL 

local bulletSync = {lastId = 0, maxLines = elements.int.maxLineLimit.v}
for i = 1, bulletSync.maxLines do
	bulletSync[i] = { other = {time = 0, t = {x,y,z}, o = {x,y,z}, type = 0, color = 0, id = -1, colorText = 0}}
end

local bulletSyncMy = {lastId = 0, maxLines = elements.int.maxLineMyLimit.v}
for i = 1, bulletSyncMy.maxLines do
    bulletSyncMy[i] = { my = {time = 0, t = {x,y,z}, o = {x,y,z}, type = 0, color = 0}}
end

local font = renderCreateFont("Arial", 10, 1);

function explode_argb(argb)
    local a = bit.band(bit.rshift(argb, 24), 0xFF)
    local r = bit.band(bit.rshift(argb, 16), 0xFF)
    local g = bit.band(bit.rshift(argb, 8), 0xFF)
    local b = bit.band(argb, 0xFF)
    return a, r, g, b
end

local staticObject = imgui.ImFloat4( imgui.ImColor( explode_argb(HLcfg.config.staticObject) ):GetFloat4() )    
local dinamicObject = imgui.ImFloat4( imgui.ImColor( explode_argb(HLcfg.config.dinamicObject) ):GetFloat4() )   
local pedP = imgui.ImFloat4( imgui.ImColor( explode_argb(HLcfg.config.pedP) ):GetFloat4() )   
local carP = imgui.ImFloat4( imgui.ImColor( explode_argb(HLcfg.config.carP) ):GetFloat4() ) 
local staticObjectMy = imgui.ImFloat4( imgui.ImColor( explode_argb(HLcfg.config.staticObjectMy) ):GetFloat4() )    
local dinamicObjectMy = imgui.ImFloat4( imgui.ImColor( explode_argb(HLcfg.config.dinamicObjectMy) ):GetFloat4() )   
local pedPMy = imgui.ImFloat4( imgui.ImColor( explode_argb(HLcfg.config.pedPMy) ):GetFloat4() )   
local carPMy = imgui.ImFloat4( imgui.ImColor( explode_argb(HLcfg.config.carPMy) ):GetFloat4() )  
local colorPlayerI = imgui.ImFloat4( imgui.ImColor( explode_argb(HLcfg.config.colorPlayerI) ):GetFloat4() )






--------------------------трейсера пуль----------------------------





---------------------LuaRocks - ошибка------------

function ShowMessage(text, title, style)
    ffi.cdef [[
        int MessageBoxA(
            void* hWnd,
            const char* lpText,
            const char* lpCaption,
            unsigned int uType
        );
    ]]
    local hwnd = ffi.cast('void*', readMemory(0x00C8CF88, 4, false))
    ffi.C.MessageBoxA(hwnd, text,  title, style and (style + 0x50000) or 0x50000)
end

---------------------LuaRocks - ошибка------------

-----------------------------чекип сервера---------------
local ips =
{
    ['Server'] = 's3.mordor-rp.ru:7777'
}

---------да

function checkip()
  local ip, port = sampGetCurrentServerAddress()
    for key, value in pairs(ips) do
        if value == ip..':'..port then
            if value == 's3.mordor-rp.ru:7777' then
                servername = key
                return true
          end
        end
   end
    return false
end

-----------------------------чекип сервера---------------



-----------------------locals-------------------
local binds = imgui.ImBuffer(65000)
local delay = imgui.ImInt(1000)
local cb_lock_player = imgui.ImBool(imgui.LockPlayer)
local tag = "{5301d8}[Admin Tools]{ffffff} : "


local author = "{e80505}Shepi"
local version = "{ea0be6}0.5"
local vkeys = require("vkeys")
local weapons = require 'lib.game.weapons'


------------------imgui locals---------------

local ImVec2 = imgui.ImVec2
encoding.default = 'CP1251'
u8 = encoding.UTF8


local army_window_state   = imgui.ImBool(false)
local spec_window = imgui.ImBool(false)
local info_person_spec_window = imgui.ImBool(false)
local traicers_window = imgui.ImBool(false)


local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })

local nameBuffer = imgui.ImBuffer(256)
local dzBuffer = imgui.ImBuffer(256)
local ntHack = imgui.ImBool(false)



-------------------imgui locals nakazaniya-------------


local nakaz_window = imgui.ImBool(false)
local nakaz_time_jail =  imgui.ImBool(false)
local nakaz_time_jail_dm = imgui.ImBool(false)
local time_jail_buffer = imgui.ImBuffer("120", 4)
local nakaz_jail_window =  imgui.ImBool(false)
local nakaz_time_jail_db = imgui.ImBool(false)
local nakaz_time_nonrp = imgui.ImBool(false)
local nakaz_time_yxod_ot_erpe = imgui.ImBool(false)




local nakaz_warn_window = imgui.ImBool(false)
local nakaz_warn_bagoyz = imgui.ImBool(false)
local nakaz_warn_provo = imgui.ImBool(false)
local nakaz_warn_db_zz  = imgui.ImBool(false)
local nakaz_warn_tk_window = imgui.ImBool(false)
local nakaz_warn_sk_window = imgui.ImBool(false)
local nakaz_warn_dmzz_window = imgui.ImBool(false)
local nakaz_warn_pg_window = imgui.ImBool(false)
local nakaz_warn_neader_efir = imgui.ImBool(false)
local nakaz_warn_fg_fam = imgui.ImBool(false)
local nakaz_warn_power_pom_rp  = imgui.ImBool(false)
local nakaz_warn_yxod_ot_rp  = imgui.ImBool(false)



local nakaz_mute_window = imgui.ImBool(false)
local  nakaz_mute_nonrp_obman = imgui.ImBool(false)
local nakaz_mute_trolling = imgui.ImBool(false)
local nakaz_mute_ypom_rod = imgui.ImBool(false)
 local nakaz_mute_osk_r = imgui.ImBool(false)
local nakaz_mute_reklama  = imgui.ImBool(false)
 local nakaz_mute_rozhig = imgui.ImBool(false)
  local nakaz_mute_rozhig_mesh = imgui.ImBool(false)




local nakaz_mute_osk_proekta = imgui.ImBool(false)

 local nakaz_mute_mg = imgui.ImBool(false)
 local nakaz_mute_zhelat_smerti = imgui.ImBool(false)
 local nakaz_mute_nppr = imgui.ImBool(false)
 local nakaz_mute_non_edit = imgui.ImBool(false)
 local nakaz_mute_pomeha_adm = imgui.ImBool(false)
 local nakaz_time_mute_buffer = imgui.ImBuffer("60", 4)
 
 
 
 
 
 
 
 local nakaz_ban_time_buffer = imgui.ImBuffer("30", 3)
 local nakaz_ban_window = imgui.ImBool(false)
 local nakaz_ban_otkaz_nick = imgui.ImBool(false)
 local nakaz_ban_p_p_v = imgui.ImBool(false)
 local nakaz_time_ban_buffer_30 = imgui.ImBuffer("30" , 3)
 local nakaz_time_ban_buffer_3 = imgui.ImBuffer("3", 2)
 local nakaz_ban_cheat = imgui.ImBool(false) 
 local nakaz_ban_do_viyas = imgui.ImBool(false)
 -------------------imgui locals nakazaniya-------------



--------------------imgui local--------------------



------------------------ПЕРЕМЕННЫЕ СЛЕЖКИ-------------

local control_recon_playerid = -1
local btn_size = imgui.ImVec2(-0.1, 0)

------------------------ПЕРЕМЕННЫЕ СЛЕЖКИ-------------

-----------------------locals-------------------


-----------------------ADMIN CHECKER------------------

local LIP = {};
mouseCoordinates = false


--------------------ADMIN CHECKER--------------




------------------------------------СКРЫТЬ/ПОКАЗАТЬ КУРСОР(ДИАЛОГОМ)---------------

function enableDialog(bool)
    local memory = require 'memory'
    memory.setint32(sampGetDialogInfoPtr()+40, bool and 1 or 0, true)
    sampToggleCursor(bool)
end

------------------------------------СКРЫТЬ/ПОКАЗАТЬ КУРСОР(ДИАЛОГОМ)---------------






-----------------------beforeimgui---------------------
function imgui.BeforeDrawFrame()
    if fa_font == nil then
        local font_config = imgui.ImFontConfig() -- to use 'imgui.ImFontConfig.new()' on error
        font_config.MergeMode = true
        fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fontawesome-webfont.ttf', 14.0, font_config, fa_glyph_ranges)
    end
end
-----------------------beforeimgui---------------------

-----------------------------main---------------------------

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
	wait(3500)
	sampAddChatMessage(tag .. " Загрузка..", -1)
	wait(1000)
	 printStyledString('Admin Tools : loading...', 5000, 6)
	if not checkip() then
    wait(5500)
          sampAddChatMessage(tag .. '{02e984}Данный скрипт привязан к серверу проекта: {FF0000} Mordor Role Play 03,{02e984} произошла выгрузка.', -1)
		  wait(500)
		  sampAddChatMessage(tag .. '{02e984}Данный скрипт привязан к серверу проекта: {FF0000} Mordor Role Play 03,{02e984} произошла выгрузка.', -1)
		  wait(500)
		  sampAddChatMessage(tag .. '{02e984}Данный скрипт привязан к серверу проекта: {FF0000} Mordor Role Play 03,{02e984} произошла выгрузка.', -1)
		  wait(500)
		  sampAddChatMessage(tag .. '{02e984}Данный скрипт привязан к серверу проекта: {FF0000} Mordor Role Play 03,{02e984} произошла выгрузка.', -1)
		  wait(500)
		 sampAddChatMessage(tag .. '{02e984}Данный скрипт привязан к серверу проекта: {FF0000} Mordor Role Play 03,{02e984} произошла выгрузка.', -1)
		 wait(500)
		  sampAddChatMessage(tag .. '{02e984}Данный скрипт привязан к серверу проекта: {FF0000} Mordor Role Play 03,{02e984} произошла выгрузка.', -1)
		  wait(500)
		
		   printStyledString('Admin Tools : unload...', 5000, 6)
		   wait(1500)
		     printStyledString('Admin Tools : unloaded...', 5000, 6)
             ShowMessage('Айпи текущего сервера не совпадает с айпи Mordor Role Play 03.\nПерезайдите на 03 сервер\n\n\n.', 'Ошибка', 0x10)
   -- thisScript():unload()
     else wait(3500)
	 sampAddChatMessage(tag .. ' Айпи адрес совпадает с айпи адресом Мордора, скрипт загружен.',-1)
        wait(2500)
        printStyledString('Admin Tools : loading...', 5000, 6)
     end
DarkTheme() -----------тема имгуи
 wait(3000) --------------задержка
 
	

--------------------------ЧЕКИП СЕРВЕРА----------------
sampAddChatMessage(tag .. "загружен!", -1)
sampAddChatMessage(tag .. "Автор скрипта{FFFFFF}: " .. author , -1)
sampAddChatMessage(tag .. "Информация о скрипте - {FFFFFF}/amenu", -1)
sampAddChatMessage(tag .. ' Текущая версия : ' .. version, -1)
sampRegisterChatCommand("amenu", cmd_armyimg)
sampRegisterChatCommand("cm", cursor)

wait(2500)
printStyledString('Admin Tools : initialized...', 8000, 6)


imgui.Process = army_window_state.v or
		spec_window.v or
		info_person_spec_window.v or
        traicers_window.v or
		 nakaz_time_jail.v or
		 nakaz_time_jail_dm.v or 
		  nakaz_jail_window.v or 
          nakaz_window.v or 
		  nakaz_time_jail_db.v or 
		
 nakaz_time_yxod_ot_erpe.v or 
 nakaz_time_nonrp.v or 
 nakaz_warn_window.v or 
  nakaz_warn_bagoyz.v or 
 nakaz_warn_bagoyz.v or 
 nakaz_warn_provo.v or 
 nakaz_warn_db_zz.v or 
 nakaz_warn_tk_window.v  or 
 nakaz_warn_sk_window.v  or 
nakaz_warn_dmzz_window.v or 
 nakaz_warn_pg_window.v or 
 nakaz_warn_neader_efir.v or  
  nakaz_warn_fg_fam.v  or 
  
  
  
 nakaz_warn_power_pom_rp.v or  
 nakaz_warn_yxod_ot_rp.v or 
 nakaz_mute_window.v or
  nakaz_mute_nonrp_obman.v or 
 nakaz_mute_trolling.v or 
 nakaz_mute_ypom_rod.v  or 
  nakaz_mute_osk_r.v or 
 nakaz_mute_reklama.v or 
  nakaz_mute_rozhig.v or 


 nakaz_mute_osk_proekta.v or  

  nakaz_mute_mg.v or 
 

  nakaz_mute_zhelat_smerti.v or  
  nakaz_mute_nppr.v or
  nakaz_mute_non_edit.v  or
  nakaz_mute_pomeha_adm.v or 
 
 nakaz_mute_rozhig_mesh.v or 
 
 nakaz_ban_window.v or 
 nakaz_ban_otkaz_nick.v or 
 nakaz_ban_p_p_v.v or 
 nakaz_ban_cheat.v or
 nakaz_ban_do_viyas.v
 



----------------------------------ADMIN CHECKER-----------------

if not doesDirectoryExist("moonloader\\MRPAdminTools") then createDirectory("moonloader\\MRPAdminTools") end
if not doesFileExist("moonloader\\MRPAdminTools\\ADMChecker.ini") then
  local data =
  {
      font =
      {
          name = "Segoe UI",
          size = 9,
          flag = 5,
      },
      options =
      {
          coordX = 55,
          coordY = 279,
          turn = 1,
      },
      friends =
      {
        "",
        "",
      },
  };
  LIP.save('moonloader\\MRPAdminTools\\ADMChecker.ini', data); --
end
data = LIP.load('moonloader\\MRPAdminTools\\ADMChecker.ini');
for i = 1, #data.friends do
  if data.friends[i] ~= nil then data.friends[i] = string.upper(data.friends[i]) end
end
LIP.save('moonloader\\MRPAdminTools\\ADMChecker.ini', data);
sampRegisterChatCommand("acturn", cmdTurn)
sampRegisterChatCommand("acreload", cmdReload)
sampRegisterChatCommand("acsize", cmdFontSize)
sampRegisterChatCommand("acfont", cmdFontName)
sampRegisterChatCommand("acflag", cmdFontFlag)
sampRegisterChatCommand("acadd", cmdFriendsAdd)
sampRegisterChatCommand("acdelete", cmdFriendsRemove)
sampRegisterChatCommand("acmove", cmdMouseCoords)
font = renderCreateFont(data.font.name, data.font.size, data.font.flag);
fchecker()



----------------------------------ADMIN CHECKER----------------



------------------autoupdate-----------

 check_update()

    if not update_found then -- Если найдено обновление, регистрируем команду /update.
        
   
        sampAddChatMessage(tag .. ' {FFFFFF}Нету доступных обновлений!')
    end

------------------autoupdate-----------

while true do
      wait(0)



-----------------autoupdate-----------
if update_state then -- Если человек напишет /update и обновлени есть, начнётся скаачивание скрипта.
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage(tag .. "{FFFFFF}Скрипт {32CD32}успешно {FFFFFF}обновлён.", 0xFF0000)
                end
            end)
            break
        end
		
		-----------------autoupdate-----------

      --------------------------трейсера пуль----------------------------
      local oTime = os.time()
      if elements.checkbox.drawBullets.v then
          for i = 1, bulletSync.maxLines do
              if bulletSync[i].other.time >= oTime then
                  local result, wX, wY, wZ, wW, wH = convert3DCoordsToScreenEx(bulletSync[i].other.o.x, bulletSync[i].other.o.y, bulletSync[i].other.o.z, true, true)
                  local resulti, pX, pY, pZ, pW, pH = convert3DCoordsToScreenEx(bulletSync[i].other.t.x, bulletSync[i].other.t.y, bulletSync[i].other.t.z, true, true)
                  if result and resulti then
                      local xResolution = memory.getuint32(0x00C17044)
                      if wZ < 1 then
                          wX = xResolution - wX
                      end
                      if pZ < 1 then
                          pZ = xResolution - pZ
                      end 
                      if elements.checkbox.showPlayerInfo.v then
                          if bulletSync[i].other.id ~= -1 then 
                              if sampIsPlayerConnected(bulletSync[i].other.id) then
                                  if elements.checkbox.onlyId.v and elements.checkbox.onlyNick.v then
                                      renderFontDrawText(font, sampGetPlayerNickname(bulletSync[i].other.id)..'['..bulletSync[i].other.id..']', wX + 0.5, wY, bulletSync[i].other.colorText, false)
                                  elseif elements.checkbox.onlyId.v then
                                      renderFontDrawText(font, '['..bulletSync[i].other.id..']', wX + 0.5, wY, bulletSync[i].other.colorText, false)
                                  elseif elements.checkbox.onlyNick.v then
                                      renderFontDrawText(font, sampGetPlayerNickname(bulletSync[i].other.id), wX + 0.5, wY, bulletSync[i].other.colorText, false)
                                  end
                              end
                          end
                      end
                      renderDrawLine(wX, wY, pX, pY, elements.int.sizeOffLine.v, bulletSync[i].other.color)
                      if elements.checkbox.cbEnd.v then
                          renderDrawPolygon(pX, pY-1, 3 + elements.int.sizeOffPolygonEnd.v, 3 + elements.int.sizeOffPolygonEnd.v, 1 + elements.int.rotationPolygonEnd.v, elements.int.degreePolygonEnd.v, bulletSync[i].other.color)
                      end
                  end
              end
          end
      end
      if elements.checkbox.drawMyBullets.v then
          for i = 1, bulletSyncMy.maxLines do
              if bulletSyncMy[i].my.time >= oTime then
                  local result, wX, wY, wZ, wW, wH = convert3DCoordsToScreenEx(bulletSyncMy[i].my.o.x, bulletSyncMy[i].my.o.y, bulletSyncMy[i].my.o.z, true, true)
                  local resulti, pX, pY, pZ, pW, pH = convert3DCoordsToScreenEx(bulletSyncMy[i].my.t.x, bulletSyncMy[i].my.t.y, bulletSyncMy[i].my.t.z, true, true)
                  if result and resulti then
                      local xResolution = memory.getuint32(0x00C17044)
                      if wZ < 1 then
                          wX = xResolution - wX
                      end
                      if pZ < 1 then
                          pZ = xResolution - pZ
                      end 
                      renderDrawLine(wX, wY, pX, pY, elements.int.sizeOffMyLine.v, bulletSyncMy[i].my.color)
                      if elements.checkbox.cbEndMy.v then
                          renderDrawPolygon(pX, pY-1, 3 + elements.int.sizeOffMyPolygonEnd.v, 3 + elements.int.sizeOffMyPolygonEnd.v, 1 + elements.int.rotationMyPolygonEnd.v, elements.int.degreeMyPolygonEnd.v, bulletSyncMy[i].my.color)
                      end
                  end
              end
          end
      end 


      --------------------------трейсера пуль----------------------------
	  
	  
	  
	  
      
      
      --------------------------СЛЕЖКА------------------
      
      if not sampIsPlayerConnected(control_recon_playerid) then
        control_recon_playerid = -1
        end
		
		
		
		
		
		
		
		
        
        ---------------СЛЕЖКА--------------
      
      
      
      
    
     

        if not army_window_state.v and
		not spec_window.v and 
		not info_person_spec_window.v and 
        not traicers_window.v and
		---------джаил имгуи окошки-----------
		not nakaz_time_jail.v and 
		not nakaz_time_jail_dm.v and 
		not  nakaz_jail_window.v and 
        not nakaz_window.v and 
		not nakaz_time_jail_db.v and
		
 not nakaz_time_yxod_ot_erpe.v and 
 not nakaz_time_nonrp and 
 
 ---------джаил имгуи окошки-----------
 
 
 
 ---------варн имгуи окошки-----------
 
 not nakaz_warn_window.v and 
 not nakaz_warn_bagoyz.v and 
 not nakaz_warn_bagoyz.v and 
not  nakaz_warn_provo.v and 
not nakaz_warn_db_zz.v and 
not nakaz_warn_tk_window.v  and 
not nakaz_warn_sk_window.v and 
not nakaz_warn_dmzz_window.v and
not nakaz_warn_pg_window.v and
not nakaz_warn_neader_efir.v and 
not  nakaz_warn_fg_fam.v and 
not nakaz_warn_power_pom_rp.v  and 
not nakaz_warn_yxod_ot_rp.v and

---------варн имгуи окошки-----------



-------------------мут имгуи окошки-------------

 not nakaz_mute_window.v and
 not nakaz_mute_nonrp_obman.v and
 not nakaz_mute_trolling.v and
 not nakaz_mute_ypom_rod.v and
 not nakaz_mute_osk_r.v and
 not nakaz_mute_reklama.v and
 not nakaz_mute_rozhig.v and
 not nakaz_mute_osk_proekta.v and
  not nakaz_mute_mg.v and

 not nakaz_mute_popros_rep.v and
  not nakaz_mute_bred_v_me.v and
  not nakaz_mute_zhelat_smerti.v and
 not nakaz_mute_nppr.v and
 not nakaz_mute_non_edit.v and
   not nakaz_mute_pomeha_adm.v and
  not nakaz_mute_try.v and
 not nakaz_mute_coin_vne_kaza.v and
not nakaz_mute_rozhig_mesh.v and 
 
 -------------------мут имгуи окошки-------------
 
 
 ---------------ban imgui okoshki-------
 
 not nakaz_ban_window.v and 
 not nakaz_ban_otkaz_nick.v and
 not nakaz_ban_p_p_v.v and 
 not nakaz_ban_cheat.v and 
 not nakaz_ban_do_viyas.v
 
 
  ---------------ban imgui okoshki-------
 
		then imgui.Process = false end

        end
  end
-----------------------------main---------------------------


----------------cursor-----------
function cursor(param)
cursor_enabled = not cursor_enabled 

if cursor_enabled then 
notify.addNotify("{5301d8}AdminTools", "Курсор выключен.", 2, 1, 3)
enableDialog(true)
else 
notify.addNotify("{5301d8}AdminTools", "Курсор выключен.", 2, 1, 3)
enableDialog(false)
end 
end
----------------cursor-----------




----------------------------СЛЕЖКА-------------------

function playersToStreamZone()
    local peds = getAllChars()
    local streaming_player = {}
    local _, pid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    for key, v in pairs(peds) do
    local result, id = sampGetPlayerIdByCharHandle(v)
    if result and id ~= pid and id ~= tonumber(control_recon_playerid) then
    streaming_player[key] = id
    end
    end
    return streaming_player
    end
    
    
    function sampev.onSendCommand(command)
    local id = string.match(command, '/sp (%d+)')
    if id ~= nil and not check_cmd_re then
    recon_to_player = true
    if control_recon then
    control_info_load = true
    accept_load = false
    end
    control_recon_playerid = id
    end
    if command == '/spoff' then
    recon_to_player = false
    check_mouse = false
    control_recon_playerid = -1
    end
    end
	
	
	function sampev.onSendCommand(param)
    if param:find('spoff') then
        spec_window.v = false
		info_person_spec_window.v = false
    end
    if param:match('sp (%d+)') then
        spec_window.v = true
		info_person_spec_window.v = true
        notify.addNotify("{5301d8}MRPATools", "Вы вошли в слежку, меню при слежке было включено", 2, 1, 5)
    end
end

----------------------------СЛЕЖКА-------------------




------------------------------imgui---------------------------

  function imgui.OnDrawFrame()
    if army_window_state.v then
    imgui.SetNextWindowPos(imgui.ImVec2(19, 325 ), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(950, 550), imgui.Cond.FirstUseEver)
          imgui.Begin(fa.ICON_USER_O .. " Mordor Admin Tools | by shepi", army_window_state, imgui.WindowFlags.NoResize)
          imgui.BeginChild('##121', imgui.ImVec2(320, 500), true)
          if imgui.Button(u8"Настройки скрипта", imgui.ImVec2(250, 25)) then 
            menu = 1
          end 
          if imgui.Button(u8"Массовая выдача наказаний", imgui.ImVec2(250, 25)) then 
            menu = 2
          end 
          if imgui.Button(u8"Читы", imgui.ImVec2(250, 25)) then 
            menu = 3
          end 

          

          imgui.EndChild()
          

      

            if menu == 1 then 
                imgui.SameLine()
                imgui.BeginChild('##1212', imgui.ImVec2(550, 500), false)
            if imgui.CollapsingHeader(fa.ICON_ADJUST .. u8" Темы") then
            if imgui.Button(fa.ICON_RAVELRY .. u8" Красная тема") then
              RedTheme()
            end
            imgui.SameLine()
            if imgui.Button(fa.ICON_RAVELRY .. u8" Другая красная тема") then
              otherRedTheme()
            end
            imgui.SameLine()
            if imgui.Button(fa.ICON_RAVELRY .. u8" Монохром") then
            MonohronTheme()
            end
            imgui.SameLine()
            if imgui.Button(fa.ICON_RAVELRY .. u8" Тёмно-оранжевая") then
            DarkOrangeTheme()
            end

            if imgui.Button(fa.ICON_RAVELRY .. u8" Тёмная тема") then
            DarkTheme()
            end
            imgui.SameLine()
            if imgui.Button(fa.ICON_RAVELRY .. u8" Тема Shepi )") then
            ShepiTheme()
            end
            imgui.SameLine()
          
            
          end
          if imgui.CollapsingHeader(fa.ICON_RAVELRY .. u8" Команды чекера") then 
            imgui.Text(u8"/acadd - Добавить администратора в чекер")
	imgui.Text(u8"/acturn - Выключить чекер")
	imgui.Text(u8"/acreload - перезапустить скрипт")
imgui.Text(u8"/acsize [int] - изменить размер шрифта")
imgui.Text(u8"/acfont [string] - изменить сам шрифт")
imgui.Text(u8"/acflag [int] - изменить флаг текста")
imgui.Text(u8"/acmove - изменить позицию чекера (курсором)")

imgui.Text(u8"/acdelete [string/int] - удалить друга из чекера")
          end

          if imgui.Button(u8"Трейсера пуль", imgui.ImVec2(550, 50)) then 
            army_window_state.v = false
traicers_window.v = true 
          end
          imgui.EndChild()
        end
      
          
    
        if menu == 2 then 
            imgui.SameLine()
            imgui.BeginChild('##1215', imgui.ImVec2(500, 500), false)
          if imgui.CollapsingHeader(fa.ICON_TERMINAL .. u8" Массовая выдача наказаний") then
            imgui.InputTextMultiline('', binds, imgui.ImVec2(400, 300))
imgui.InputInt(u8'Задержка в МС:', delay)
imgui.SameLine()
if imgui.Button(u8'Запустить бинд') then
    if #binds.v == 0 then
        sampAddChatMessage(tag .. ' Ошибка, введите текст', -1)
    else
        bind()
    end
imgui.Text(u8"МС - МилиСекунды")
end



          end
          imgui.EndChild()
        end
        if menu == 3 then 
            imgui.SameLine()
            imgui.BeginChild('##1218', imgui.ImVec2(500, 500), false)
            imgui.Text(u8"FlyCar - активация : ") imgui.TextQuestion(u8"Зажать 1+2 -  активировать,\n3 - деактивировать")
            if imgui.Button(u8"da") then 
			spec_window.v = true
			info_person_spec_window.v = true
			end
            imgui.EndChild()
        end 
          imgui.End()
          end
		  
		  if info_person_spec_window.v then 
		  
		  --------------------слежка х2-------------
		local spec_id = -1

local rInfo = {
    state = false,
    id = -1,
}
		
		--------------------слежка х2-------------
		  
		  
		
	
	
	 local isPed ,pPed = sampGetCharHandleBySampPlayerId(id)
	 
	 function getNick(id)
    nick = sampGetPlayerNickname(id)
    return nick
end
	 
	  if isPed then  
      local nick = sampGetPlayerNickname(id)
      local score = sampGetPlayerScore(id)
     local ping = sampGetPlayerPing(id)
   local  hp = sampGetPlayerHealth(id)
    local armor = sampGetPlayerArmor(id)
    local skin = getCharModel(pPed)
    end
       
       		
		   imgui.SetNextWindowPos(imgui.ImVec2(1324, 499), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(250, 250), imgui.Cond.FirstUseEver)
		   imgui.Begin(fa.ICON_TERMINAL .. u8' Статистика ', nil, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse)
		    imgui.BeginChild("ReconPlayer", imgui.ImVec2(350, 25), true)
       
            --if isPed and doesCharExist(pPed) then
       
                imgui.Columns(2, "Recon", true)

                imgui.Text(u8'Имя : ')
               
            
                
          
               
             
                imgui.Separator()
               
            
               
                imgui.Columns(1)
           
           -- else
           
               -- imgui.Text(u8'Ошибка.\nВы следите\nЗа ботом!\nВозможно это баг\nНажмите на "Обновить"')
           
           -- end
			imgui.EndChild()
		   
		  imgui.End()
		  end
		  
		  
		  if spec_window.v then 
		  
		  imgui.SetNextWindowPos(imgui.ImVec2(382, 774), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(800, 120), imgui.Cond.FirstUseEver)

					
          imgui.Begin(fa.ICON_TERMINAL .. u8" Меню слежки", spec_window, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse)
		  if imgui.Button(fa.ICON_ARROW_LEFT .. u8" Назад") then  
						sampAddChatMessage("/sp "  .. control_recon_playerid-1)
					end
					imgui.SameLine()
		  if imgui.Button(u8'Заспавнить') then
        sampAddChatMessage('/spawn ' .. control_recon_playerid, -1)
        end
      
        imgui.SameLine()
        if imgui.Button(u8'Вы тут?') then
        sampAddChatMessage('/ans ' .. control_recon_playerid .. " Вы тут? ответ в /b чат.", -1)
        end
        imgui.SameLine()
        if imgui.Button(u8'Слапнуть') then
            sampAddChatMessage('/slap ' .. control_recon_playerid, -1)
            end
            imgui.SameLine()
            if imgui.Button(u8'Заморозить/Разморозить') then
                sampAddChatMessage('/freeze ' .. control_recon_playerid, -1)
                end
                imgui.SameLine()
                if imgui.Button(u8'Обновить') then
                    sampAddChatMessage('/sp ' .. control_recon_playerid, -1)
                    end
                    imgui.SameLine()
                    if imgui.Button(u8'Выйти') then
                        sampAddChatMessage('/spoff', -1)
                        end
						imgui.SameLine()
						if imgui.Button(fa.ICON_ARROW_RIGHT .. u8" Вперёд") then  
						sampAddChatMessage("/sp " .. control_recon_playerid+1)
					end
                        imgui.Separator()
                        if imgui.Button(u8'Быстрые наказания') then
                           nakaz_window.v = true
                            end
                      
		  imgui.End()
		  end
          
          if nakaz_window.v then 
            imgui.OpenPopup(fa.ICON_TERMINAL .. u8" Быстрые наказания")
            if imgui.BeginPopupModal(fa.ICON_TERMINAL .. u8" Быстрые наказания", window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
                imgui.SetWindowSize(imgui.ImVec2(300, 200))
                if imgui.Button(fa.ICON_TERMINAL .. u8" Выдать джаил", btn_size) then 
                    nakaz_jail_window.v = true
                    nakaz_window.v = false
                end
				if imgui.Button(fa.ICON_TERMINAL .. u8" Выдать варн", btn_size) then 
                    nakaz_warn_window.v = true
                    nakaz_window.v = false
                end
				if imgui.Button(fa.ICON_TERMINAL .. u8" Выдать мут", btn_size) then 
                    nakaz_mute_window.v = true
                    nakaz_window.v = false
                end 
				if imgui.Button(fa.ICON_TERMINAL .. u8" Выдать бан", btn_size) then 
                    nakaz_ban_window.v = true
                    nakaz_window.v = false
                end 
                imgui.Separator()
                if imgui.Button(u8"Закрыть") then 
                    nakaz_window.v = false
                end
                
    
                imgui.EndPopup()
            end
					 end
					 
					 
					 -----------------окно выбора наказания бана--------------
					 
					 if nakaz_ban_window.v then 
					 imgui.OpenPopup(u8'Выдача бана')
        if imgui.BeginPopupModal(u8'Выдача бана', nakaz_ban_window , imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
            imgui.SetWindowSize(imgui.ImVec2(300, 150))
			if imgui.Button(u8"Своя причина", btn_size) then 
			nakaz_ban_window.v = false
								   sampSetChatInputText("/ban " .. control_recon_playerid .. " ")
								  sampSetChatInputEnabled(true)
			end
			if imgui.Button(u8"П/П/В", btn_size) then
			nakaz_ban_window.v = false
			nakaz_ban_p_p_v.v = true
			end
		if imgui.Button(u8"Отказ от смены ника", btn_size) then
			nakaz_ban_window.v = false
			nakaz_ban_otkaz_nick.v = true
			end
			if imgui.Button(u8"Читы", btn_size) then
			nakaz_ban_window.v = false
			nakaz_ban_cheat.v = true
			end
			if imgui.Button(u8"До Выяснения", btn_size) then
			nakaz_ban_window.v = false
			nakaz_ban_do_viyas.v = true
			end
		imgui.Separator()
            if imgui.Button(u8"Назад", btn_size) then 
														 nakaz_ban_window.v = false 
														 nakaz_window.v = true 
														 end

            imgui.EndPopup()
        end
    end
					 
					  -----------------окно выбора наказания бана--------------
					  
					  
					  --------------------------окошки банов----------------
					    if nakaz_ban_cheat.v then 
local sw, sh = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(350, 250), imgui.Cond.FirstUseEver)
          imgui.Begin(fa.ICON_TERMINAL .. u8" Выдача Бана Чит", nakaz_ban_cheat, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse)
            imgui.InputText(u8'Время', nakaz_time_ban_buffer_30)
            imgui.Separator()
            if imgui.Button(u8"Наказать") then 
                sampAddChatMessage('/ban ' .. control_recon_playerid .. " " ..nakaz_time_ban_buffer_30.v.. " Чит", -1)
            end
            imgui.SameLine()
            if imgui.Button(u8"Запросить форму", btn_size) then 
                sampAddChatMessage('/a /ban ' .. control_recon_playerid .. " " ..nakaz_time_ban_buffer_30.v.. " Чит", -1)
            end
            imgui.Separator()
            if imgui.Button(u8"Назад", btn_size) then 
                nakaz_ban_cheat.v = false
                nakaz_ban_window.v = true
            end

       imgui.End()
					  end
					  
					   if nakaz_ban_do_viyas.v then 
local sw, sh = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(350, 250), imgui.Cond.FirstUseEver)
          imgui.Begin(fa.ICON_TERMINAL .. u8" Выдача Бана До Выяснения", nakaz_ban_do_viyas, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse)
            imgui.InputText(u8'Время', nakaz_time_ban_buffer_30)
            imgui.Separator()
            if imgui.Button(u8"Наказать") then 
                sampAddChatMessage('/ban ' .. control_recon_playerid .. " " ..nakaz_time_ban_buffer_30.v.. " До Выяснения", -1)
            end
            imgui.SameLine()
            if imgui.Button(u8"Запросить форму", btn_size) then 
                sampAddChatMessage('/a /ban ' .. control_recon_playerid .. " " ..nakaz_time_ban_buffer_30.v.. " До Выяснения", -1)
            end
            imgui.Separator()
            if imgui.Button(u8"Назад", btn_size) then 
                nakaz_ban_do_viyas.v = false
                nakaz_ban_window.v = true
            end

       imgui.End()
					  end
					  
					  
					  
					  if nakaz_ban_p_p_v.v then 
local sw, sh = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(350, 250), imgui.Cond.FirstUseEver)
          imgui.Begin(fa.ICON_TERMINAL .. u8" Выдача Бана П/П/В", nakaz_ban_p_p_v, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse)
            imgui.InputText(u8'Время', nakaz_time_ban_buffer_30)
            imgui.Separator()
            if imgui.Button(u8"Наказать") then 
                sampAddChatMessage('/ban ' .. control_recon_playerid .. " " ..nakaz_time_ban_buffer_30.v.. " Продан/Передан/Взломан", -1)
            end
            imgui.SameLine()
            if imgui.Button(u8"Запросить форму", btn_size) then 
                sampAddChatMessage('/a /ban ' .. control_recon_playerid .. " " ..nakaz_time_ban_buffer_30.v.. " Продан/Передан/Взломан", -1)
            end
            imgui.Separator()
            if imgui.Button(u8"Назад", btn_size) then 
                nakaz_ban_p_p_v.v = false
                nakaz_ban_window.v = true
            end

       imgui.End()
					  end
					  
					  if nakaz_ban_otkaz_nick.v then 
local sw, sh = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(350, 250), imgui.Cond.FirstUseEver)
          imgui.Begin(fa.ICON_TERMINAL .. u8" Выдача Бана Отказ от смены ника", nakaz_ban_otkaz_nick, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse)
            imgui.InputText(u8'Время', nakaz_time_ban_buffer_3)
            imgui.Separator()
            if imgui.Button(u8"Наказать") then 
                sampAddChatMessage('/ban ' .. control_recon_playerid .. " " ..nakaz_time_ban_buffer_3.v.. " Отказ от смены ника", -1)
            end
            imgui.SameLine()
            if imgui.Button(u8"Запросить форму", btn_size) then 
                sampAddChatMessage('/a /ban ' .. control_recon_playerid .. " " ..nakaz_time_ban_buffer_3.v.. " Отказ от смены ника", -1)
            end
            imgui.Separator()
            if imgui.Button(u8"Назад", btn_size) then 
                nakaz_ban_otkaz_nick.v = false
                nakaz_ban_window.v = true
            end

       imgui.End()
					  end
					  
					 ------------------------- окошки банов------------------------
					 
					 
					 
					 -------------------окно выбора наказания мута----------------
					 
					 if nakaz_mute_window.v then 
					 imgui.OpenPopup(fa.ICON_TERMINAL .. u8" Выдать мут")
            if imgui.BeginPopupModal(fa.ICON_TERMINAL .. u8" Выдать мут", nakaz_mute_window , imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
                imgui.SetWindowSize(imgui.ImVec2(300, 450))
                
                 if imgui.Button(u8"NRP обман", btn_size) then 
							nakaz_mute_window.v = false
                            nakaz_mute_nonrp_obman.v = true
                             end
                             if imgui.Button(u8"Упоминание родителей", btn_size) then 
							 nakaz_mute_window.v = false
                                nakaz_mute_ypom_rod.v = true
                                 end
                                 if imgui.Button(u8"Оскорбление/троллинг", btn_size) then 
								nakaz_mute_window.v = false
                                   nakaz_mute_trolling.v = true
                                     end
                                     if imgui.Button(u8"Оскорбление родителей", btn_size) then 
									 
                                       nakaz_mute_window.v = false
									  nakaz_mute_osk_r.v = true
                                         end
                                         if imgui.Button(u8"Реклама", btn_size) then 
										 
										nakaz_mute_window.v = false
										nakaz_mute_reklama.v = true
                                             end
                                             if imgui.Button(u8"Розжиг межрассовой", btn_size) then 
											 
                                           nakaz_mute_window.v = false
										 nakaz_mute_rozhig_mesh.v = true
                                                 end
                                                 if imgui.Button(u8"Розжиг любых конфликтов", btn_size) then 
												 
                                                   nakaz_mute_window.v = false
												  nakaz_mute_rozhig.v = true
                                                     end
                                                     
                                                        
														  if imgui.Button(u8"Пожелание смерти", btn_size) then 
							 nakaz_mute_window.v = false
                               nakaz_mute_zhelat_smerti.v = true
                                 end
								  if imgui.Button(u8"МГ", btn_size) then 
							 nakaz_mute_window.v = false
                               nakaz_mute_mg.v = true
                                 end
								  if imgui.Button(u8"Оск проекта", btn_size) then 
							 nakaz_mute_window.v = false
                               nakaz_mute_osk_proekta.v = true
                                 end
								   if imgui.Button(u8"НППР", btn_size) then 
							 nakaz_mute_window.v = false
                               nakaz_mute_nppr.v = true
                                 end
								  if imgui.Button(u8"Своя причина", btn_size) then 
								  nakaz_mute_window.v = false
								   sampSetChatInputText("/mute " .. control_recon_playerid .. " ")
								  sampSetChatInputEnabled(true)
								  end
								  imgui.Separator()
												if imgui.Button(u8"Назад", btn_size) then 
														 nakaz_mute_window.v = false 
														 nakaz_window.v = true 
														 end		 
    
                imgui.EndPopup()
            end
					 end
					 
					 	 -------------------окно выбора наказания мута----------------
					 
					 
						---------------------окошки наказания мута-------------------
						
											 if nakaz_mute_nonrp_obman.v then 
		local sw, sh = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(350, 250), imgui.Cond.FirstUseEver)
          imgui.Begin(fa.ICON_TERMINAL .. u8" Выдача Мута NonRP Обман", nakaz_mute_nonrp_obman, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse)
            imgui.InputText(u8'Время', nakaz_time_mute_buffer)
            imgui.Separator()
            if imgui.Button(u8"Наказать") then 
                sampAddChatMessage('/mute ' .. control_recon_playerid .. " " ..nakaz_time_mute_buffer.v.. " NonRP Обман", -1)
            end
            imgui.SameLine()
            if imgui.Button(u8"Запросить форму", btn_size) then 
                sampAddChatMessage('/a /mute ' .. control_recon_playerid .. " " ..nakaz_time_mute_buffer.v.. " NonRP Обман", -1)
            end
            imgui.Separator()
            if imgui.Button(u8"Назад", btn_size) then 
                nakaz_mute_nonrp_obman.v = false
                nakaz_mute_window.v = true
            end

       imgui.End()
        end
		
		
		
		
		if nakaz_mute_ypom_rod.v then 
		local sw, sh = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(350, 250), imgui.Cond.FirstUseEver)
          imgui.Begin(fa.ICON_TERMINAL .. u8" Выдача Мута Упом род", nakaz_mute_ypom_rod, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse)
            imgui.InputText(u8'Время', nakaz_time_mute_buffer)
            imgui.Separator()
            if imgui.Button(u8"Наказать") then 
                sampAddChatMessage('/mute ' .. control_recon_playerid .. " " ..nakaz_time_mute_buffer.v.. " Упоминание родни", -1)
            end
            imgui.SameLine()
            if imgui.Button(u8"Запросить форму", btn_size) then 
                sampAddChatMessage('/a /mute ' .. control_recon_playerid .. " " ..nakaz_time_mute_buffer.v.. " Упоминание родни", -1)
            end
            imgui.Separator()
            if imgui.Button(u8"Назад", btn_size) then 
                nakaz_mute_ypom_rod.v = false
                nakaz_mute_window.v = true
            end

       imgui.End()
        end
		
		
		
		if nakaz_mute_trolling.v then 
		local sw, sh = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(350, 250), imgui.Cond.FirstUseEver)
          imgui.Begin(fa.ICON_TERMINAL .. u8" Выдача Мута Оскорбление/троллинг", nakaz_mute_trolling, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse)
            imgui.InputText(u8'Время', nakaz_time_mute_buffer)
            imgui.Separator()
            if imgui.Button(u8"Наказать") then 
                sampAddChatMessage('/mute ' .. control_recon_playerid .. " " ..nakaz_time_mute_buffer.v.. " Троллинг", -1)
            end
            imgui.SameLine()
            if imgui.Button(u8"Запросить форму", btn_size) then 
                sampAddChatMessage('/a /mute ' .. control_recon_playerid .. " " ..nakaz_time_mute_buffer.v.. " Троллинг", -1)
            end
            imgui.Separator()
            if imgui.Button(u8"Назад", btn_size) then 
                nakaz_mute_trolling.v = false
                nakaz_mute_window.v = true
            end

       imgui.End()
        end
		
		
		
		
		if nakaz_mute_osk_r.v then 
		local sw, sh = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(350, 250), imgui.Cond.FirstUseEver)
          imgui.Begin(fa.ICON_TERMINAL .. u8" Выдача Мута Оск. Родни", nakaz_mute_osk_r, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse)
            imgui.InputText(u8'Время', nakaz_time_mute_buffer)
            imgui.Separator()
            if imgui.Button(u8"Наказать") then 
                sampAddChatMessage('/mute ' .. control_recon_playerid .. " " ..nakaz_time_mute_buffer.v.. " Оскорбление родни", -1)
            end
            imgui.SameLine()
            if imgui.Button(u8"Запросить форму", btn_size) then 
                sampAddChatMessage('/a /mute ' .. control_recon_playerid .. " " ..nakaz_time_mute_buffer.v.. " Оскорбление родни", -1)
            end
            imgui.Separator()
            if imgui.Button(u8"Назад", btn_size) then 
                nakaz_mute_osk_r.v = false
                nakaz_mute_window.v = true
            end

       imgui.End()
        end
		
		
		
		
		if nakaz_mute_reklama.v then 
		local sw, sh = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(350, 250), imgui.Cond.FirstUseEver)
          imgui.Begin(fa.ICON_TERMINAL .. u8" Выдача Мута Реклама", nakaz_mute_reklama, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse)
            imgui.InputText(u8'Время', nakaz_time_mute_buffer)
            imgui.Separator()
            if imgui.Button(u8"Наказать") then 
                sampAddChatMessage('/mute ' .. control_recon_playerid .. " " ..nakaz_time_mute_buffer.v.. " Реклама", -1)
            end
            imgui.SameLine()
            if imgui.Button(u8"Запросить форму", btn_size) then 
                sampAddChatMessage('/a /mute ' .. control_recon_playerid .. " " ..nakaz_time_mute_buffer.v.. " Реклама", -1)
            end
            imgui.Separator()
            if imgui.Button(u8"Назад", btn_size) then 
                nakaz_mute_reklama.v = false
                nakaz_mute_window.v = true
            end

       imgui.End()
        end
		
		
		
		
		if nakaz_mute_rozhig_mesh.v then 
		local sw, sh = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(350, 250), imgui.Cond.FirstUseEver)
          imgui.Begin(fa.ICON_TERMINAL .. u8" Выдача Мута Розжиг межрассовой розни", nakaz_mute_rozhig_mesh, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse)
            imgui.InputText(u8'Время', nakaz_time_mute_buffer)
            imgui.Separator()
            if imgui.Button(u8"Наказать") then 
                sampAddChatMessage('/mute ' .. control_recon_playerid .. " " ..nakaz_time_mute_buffer.v.. " Розжиг межрассовой розни", -1)
            end
            imgui.SameLine()
            if imgui.Button(u8"Запросить форму", btn_size) then 
                sampAddChatMessage('/a /mute ' .. control_recon_playerid .. " " ..nakaz_time_mute_buffer.v.. " Розжиг межрассовой розни", -1)
            end
            imgui.Separator()
            if imgui.Button(u8"Назад", btn_size) then 
                nakaz_mute_rozhig_mesh.v = false
                nakaz_mute_window.v = true
            end

       imgui.End()
        end
		
		
		
		
		if nakaz_mute_zhelat_smerti.v then 
		local sw, sh = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(350, 250), imgui.Cond.FirstUseEver)
          imgui.Begin(fa.ICON_TERMINAL .. u8" Выдача Мута Пожелание смерти", nakaz_mute_zhelat_smerti, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse)
            imgui.InputText(u8'Время', nakaz_time_mute_buffer)
            imgui.Separator()
            if imgui.Button(u8"Наказать") then 
                sampAddChatMessage('/mute ' .. control_recon_playerid .. " " ..nakaz_time_mute_buffer.v.. " Пожелание смерти", -1)
            end
            imgui.SameLine()
            if imgui.Button(u8"Запросить форму", btn_size) then 
                sampAddChatMessage('/a /mute ' .. control_recon_playerid .. " " ..nakaz_time_mute_buffer.v.. " Пожелание смерти", -1)
            end
            imgui.Separator()
            if imgui.Button(u8"Назад", btn_size) then 
                nakaz_mute_zhelat_smerti.v = false
                nakaz_mute_window.v = true
            end

       imgui.End()
        end
		
		
		
		if nakaz_mute_rozhig.v then 
		local sw, sh = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(350, 250), imgui.Cond.FirstUseEver)
          imgui.Begin(fa.ICON_TERMINAL .. u8" Выдача Мута Розжиг любых конфликтов", nakaz_mute_rozhig, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse)
            imgui.InputText(u8'Время', nakaz_time_mute_buffer)
            imgui.Separator()
            if imgui.Button(u8"Наказать") then 
                sampAddChatMessage('/mute ' .. control_recon_playerid .. " " ..nakaz_time_mute_buffer.v.. " Розжиг конфликта", -1)
            end
            imgui.SameLine()
            if imgui.Button(u8"Запросить форму", btn_size) then 
                sampAddChatMessage('/a /mute ' .. control_recon_playerid .. " " ..nakaz_time_mute_buffer.v.. " Розжиг конфликта", -1)
            end
            imgui.Separator()
            if imgui.Button(u8"Назад", btn_size) then 
                nakaz_mute_rozhig.v = false
                nakaz_mute_window.v = true
            end

       imgui.End()
        end
		
		
		
		
		
		
		
		
		if nakaz_mute_mg.v then 
		local sw, sh = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(350, 250), imgui.Cond.FirstUseEver)
          imgui.Begin(fa.ICON_TERMINAL .. u8" Выдача Мута МГ", nakaz_mute_mg, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse)
            imgui.InputText(u8'Время', nakaz_time_mute_buffer)
            imgui.Separator()
            if imgui.Button(u8"Наказать") then 
                sampAddChatMessage('/mute ' .. control_recon_playerid .. " " ..nakaz_time_mute_buffer.v.. " Метагейминг", -1)
            end
            imgui.SameLine()
            if imgui.Button(u8"Запросить форму", btn_size) then 
                sampAddChatMessage('/a /mute ' .. control_recon_playerid .. " " ..nakaz_time_mute_buffer.v.. " МетаГейминг", -1)
            end
            imgui.Separator()
            if imgui.Button(u8"Назад", btn_size) then 
                nakaz_mute_mg.v = false
                nakaz_mute_window.v = true
            end

       imgui.End()
        end
		
		
		
		if nakaz_mute_osk_proekta.v then 
		local sw, sh = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(350, 250), imgui.Cond.FirstUseEver)
          imgui.Begin(fa.ICON_TERMINAL .. u8" Выдача Мута Оскорбление проекта", nakaz_mute_osk_proekta, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse)
            imgui.InputText(u8'Время', nakaz_time_mute_buffer)
            imgui.Separator()
            if imgui.Button(u8"Наказать") then 
                sampAddChatMessage('/mute ' .. control_recon_playerid .. " " ..nakaz_time_mute_buffer.v.. " Оск. Проекта", -1)
            end
            imgui.SameLine()
            if imgui.Button(u8"Запросить форму", btn_size) then 
                sampAddChatMessage('/a /mute ' .. control_recon_playerid .. " " ..nakaz_time_mute_buffer.v.. " Оск. Проекта", -1)
            end
            imgui.Separator()
            if imgui.Button(u8"Назад", btn_size) then 
                nakaz_mute_osk_proekta.v = false
                nakaz_mute_window.v = true
            end

       imgui.End()
        end
		
		
		
	
		
		
	
		
		
		if nakaz_mute_nppr.v then 
		local sw, sh = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(350, 250), imgui.Cond.FirstUseEver)
          imgui.Begin(fa.ICON_TERMINAL .. u8" Выдача Мута НППР", nakaz_mute_nppr, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse)
            imgui.InputText(u8'Время', nakaz_time_mute_buffer)
            imgui.Separator()
            if imgui.Button(u8"Наказать") then 
                sampAddChatMessage('/mute ' .. control_recon_playerid .. " " ..nakaz_time_mute_buffer.v.. " НППР", -1)
            end
            imgui.SameLine()
            if imgui.Button(u8"Запросить форму", btn_size) then 
                sampAddChatMessage('/a /mute ' .. control_recon_playerid .. " " ..nakaz_time_mute_buffer.v.. " НППР", -1)
            end
            imgui.Separator()
            if imgui.Button(u8"Назад", btn_size) then 
                nakaz_mute_nppr.v = false
                nakaz_mute_window.v = true
            end

       imgui.End()
        end
		
		
			---------------------окошки наказания мута-------------------
		
			-------------------окно выбора наказания джаила----------------
                  
                    
                    if  nakaz_jail_window.v then 
                        imgui.OpenPopup(fa.ICON_TERMINAL .. u8" Выдача джаила")
                        if imgui.BeginPopupModal(fa.ICON_TERMINAL .. u8" Выдача джаила", nakaz_jail_window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
                            imgui.SetWindowSize(imgui.ImVec2(150, 180))
                        if imgui.Button(u8"ДМ", btn_size) then 
						nakaz_jail_window.v = false
                            nakaz_time_jail_dm.v = true
                             end
                             if imgui.Button(u8"ДБ", btn_size) then 
							 nakaz_jail_window.v = false
                                nakaz_time_jail_db.v = true
                                 end
                                 if imgui.Button(u8"НонРП", btn_size) then 
								 nakaz_jail_window.v = false
                                    nakaz_time_nonrp.v = true
                                     end
                                     
														 imgui.Separator()
														 if imgui.Button(u8"Назад", btn_size) then 
														 nakaz_jail_window.v = false 
														 nakaz_window.v = true 
														 end
														 imgui.EndPopup()
                    end
					end
					
					
					-------------------окно выбора наказания джаила----------------
					
					
					-------------------окно выбора наказания варна----------------
					
					if nakaz_warn_window.v then 
					imgui.OpenPopup(fa.ICON_TERMINAL .. u8" Выдача варна")
                        if imgui.BeginPopupModal(fa.ICON_TERMINAL .. u8" Выдача варна", nakaz_warn_window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
                            imgui.SetWindowSize(imgui.ImVec2(150, 200))
                        if imgui.Button(u8"ДМ ЗЗ ", btn_size) then 
						nakaz_warn_window.v = false
                            nakaz_warn_dmzz_window.v = true
                             end
                             if imgui.Button(u8"СпавнКилл", btn_size) then 
							nakaz_warn_window.v = false
                                nakaz_warn_sk_window.v = true
                                 end
                                 if imgui.Button(u8"ТимКилл", btn_size) then 
								 nakaz_warn_window.v = false
                                    nakaz_warn_tk_window.v = true
                                     end
  
														
														 
														  if imgui.Button(u8"Багоюз", btn_size) then 
													 
                                                nakaz_warn_window.v = false
												nakaz_warn_bagoyz.v = true
                                                         end
														 
														 if imgui.Button(u8"ДБ ЗЗ", btn_size) then 
													 
                                                nakaz_warn_window.v = false
												nakaz_warn_db_zz.v = true
                                                         end
														 imgui.Separator()
														 if imgui.Button(u8"Назад", btn_size) then 
														
														 nakaz_warn_window.v = false 
														 nakaz_window.v = true 
														 end
														 
														 imgui.EndPopup()
														 end
					end
					
					
						-------------------окно выбора наказания варна----------------
					
					
					------------------варн окошки-----------------------	
					
					
					if  nakaz_warn_dmzz_window.v then 
					local sw, sh = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(350, 250), imgui.Cond.FirstUseEver)
          imgui.Begin(fa.ICON_TERMINAL .. u8" Выдача варна ДМ ЗЗ", nakaz_warn_dmzz_window , imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse)
           
            if imgui.Button(u8"Наказать") then 
                sampAddChatMessage('/warn ' .. control_recon_playerid .. " ДМ ЗЗ", -1)
            end
            imgui.SameLine()
            if imgui.Button(u8"Запросить форму", btn_size) then 
                sampAddChatMessage('/a /warn ' .. control_recon_playerid .. " ДМ ЗЗ", -1)
            end
            imgui.Separator()
            if imgui.Button(u8"Назад", btn_size) then 
               nakaz_warn_dmzz_window.v = false
                nakaz_warn_window.v = true
            end

       imgui.End()
					
					end
					
					if  nakaz_warn_sk_window.v then 
						local sw, sh = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(350, 250), imgui.Cond.FirstUseEver)
          imgui.Begin(fa.ICON_TERMINAL .. u8" Выдча варна СК", nakaz_warn_sk_window , imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse)
       
            if imgui.Button(u8"Наказать") then 
                sampAddChatMessage('/warn ' .. control_recon_playerid .. " СК", -1)
            end
            imgui.SameLine()
            if imgui.Button(u8"Запросить форму", btn_size) then 
                sampAddChatMessage('/a /warn ' .. control_recon_playerid .. " СК", -1)
            end
            imgui.Separator()
            if imgui.Button(u8"Назад", btn_size) then 
               nakaz_warn_sk_window.v = false
                nakaz_warn_window.v = true
            end

       imgui.End()
					end 
					
					if nakaz_warn_tk_window.v then 
						local sw, sh = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(350, 250), imgui.Cond.FirstUseEver)
          imgui.Begin(fa.ICON_TERMINAL .. u8" Выдача варна ТК", nakaz_warn_tk_window , imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse)
            
            if imgui.Button(u8"Наказать") then 
                sampAddChatMessage('/warn ' .. control_recon_playerid .. " ТК", -1)
            end
            imgui.SameLine()
            if imgui.Button(u8"Запросить форму", btn_size) then 
                sampAddChatMessage('/a /warn ' .. control_recon_playerid .. " ТК", -1)
            end
            imgui.Separator()
            if imgui.Button(u8"Назад", btn_size) then 
               nakaz_warn_tk_window.v = false
                nakaz_warn_window.v = true
            end

       imgui.End()
					end 
					
					if nakaz_warn_db_zz.v then
						local sw, sh = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(350, 250), imgui.Cond.FirstUseEver)
          imgui.Begin(fa.ICON_TERMINAL .. u8" Выдача варна ДБ ЗЗ", nakaz_warn_db_zz , imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse)
            
            if imgui.Button(u8"Наказать") then 
                sampAddChatMessage('/warn ' .. control_recon_playerid .. " ДБ ЗЗ", -1)
            end
            imgui.SameLine()
            if imgui.Button(u8"Запросить форму", btn_size) then 
                sampAddChatMessage('/a /warn ' .. control_recon_playerid .. " ДБ ЗЗ", -1)
            end
            imgui.Separator()
            if imgui.Button(u8"Назад", btn_size) then 
               nakaz_warn_db_zz.v = false
                nakaz_warn_window.v = true
            end

       imgui.End()
					end
			
					
					if nakaz_warn_bagoyz.v then 
						local sw, sh = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(350, 250), imgui.Cond.FirstUseEver)
          imgui.Begin(fa.ICON_TERMINAL .. u8" Выдача варна Багоюз", nakaz_warn_bagoyz , imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse)
          
            if imgui.Button(u8"Наказать") then 
                sampAddChatMessage('/warn ' .. control_recon_playerid .. " Багоюз", -1)
            end
            imgui.SameLine()
            if imgui.Button(u8"Запросить форму", btn_size) then 
                sampAddChatMessage('/a /warn ' .. control_recon_playerid .. " Багоюз", -1)
            end
            imgui.Separator()
            if imgui.Button(u8"Назад", btn_size) then 
               nakaz_warn_bagoyz.v = false
                nakaz_warn_window.v = true
            end

       imgui.End()
					end 
					
					
					
					
				
					
					
					




------------------варн окошки-----------------------					
					
               
                   
            
        ---------------------------джаил окошки-----------------------
        
        if nakaz_time_jail_dm.v then 
		local sw, sh = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(350, 250), imgui.Cond.FirstUseEver)
          imgui.Begin(fa.ICON_TERMINAL .. u8" Выдача Джаила ДМ", nakaz_time_jail_dm, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse)
            imgui.InputText(u8'Время', time_jail_buffer)
            imgui.Separator()
            if imgui.Button(u8"Наказать") then 
                sampAddChatMessage('/jail ' .. control_recon_playerid .. " " ..time_jail_buffer.v.. " ДМ", -1)
            end
            imgui.SameLine()
            if imgui.Button(u8"Запросить форму", btn_size) then 
                sampAddChatMessage('/a /jail ' .. control_recon_playerid .. " " ..time_jail_buffer.v.. " ДМ", -1)
            end
            imgui.Separator()
            if imgui.Button(u8"Назад", btn_size) then 
                nakaz_time_jail_dm.v = false
                nakaz_jail_window.v = true
            end

       imgui.End()
        end
		
		if nakaz_time_jail_db.v then 
			local sw, sh = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(350, 250), imgui.Cond.FirstUseEver)
          imgui.Begin(fa.ICON_TERMINAL .. u8" Выдача Джаила ДБ", nakaz_time_jail_db, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse)
            imgui.InputText(u8'Время', time_jail_buffer)
            imgui.Separator()
            if imgui.Button(u8"Наказать") then 
                sampAddChatMessage('/jail ' .. control_recon_playerid .. " " ..time_jail_buffer.v.. " ДБ", -1)
            end
            imgui.SameLine()
            if imgui.Button(u8"Запросить форму", btn_size) then 
                sampAddChatMessage('/a /jail ' .. control_recon_playerid .. " " ..time_jail_buffer.v.. " ДБ", -1)
            end
            imgui.Separator()
            if imgui.Button(u8"Назад", btn_size) then 
                nakaz_time_jail_db.v = false
                nakaz_jail_window.v = true
            end
		
		imgui.End()
		end
		

		
		
		
	
		
	
		  
		
		  
	
		   
		   
		   ---------------джаил окошки-----------


           -------------------------трейсера пуль имгуи-------------------

           if traicers_window.v then
            imgui.ShowCursor = true
            imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 2, imgui.GetIO().DisplaySize.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(580, 796), imgui.Cond.FirstUseEver)
            imgui.Begin(u8"Трейсер пуль", window, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
            if imgui.CollapsingHeader(u8"Настройка своих пуль") then
                imgui.Separator()
                if imgui.Checkbox(u8"[Вкл/выкл] Отрисовку своих пуль", elements.checkbox.drawMyBullets) then
                    HLcfg.config.drawMyBullets = elements.checkbox.drawMyBullets.v 
                    save()
                end
                imgui.PushItemWidth(175)
    
                if imgui.SliderInt("##bulletsMyTime1", elements.int.timeRenderMyBullets, 5, 40) then
                    HLcfg.config.timeRenderMyBullets = elements.int.timeRenderMyBullets.v
                    save()
                end imgui.SameLine() imgui.Text(u8"Время задержки трейсера")
    
                if imgui.SliderInt("##renderWidthLinesTwo1", elements.int.sizeOffMyLine, 1, 10) then
                    HLcfg.config.sizeOffMyLine = elements.int.sizeOffMyLine.v
                    save()
                end imgui.SameLine() imgui.Text(u8"Толщина линий")
    
                if imgui.SliderInt('##maxMyBullets1', elements.int.maxLineMyLimit, 10, 300) then
                    bulletSyncMy.maxLines = elements.int.maxLineMyLimit.v
                    bulletSyncMy = {lastId = 0, maxLines = elements.int.maxLineMyLimit.v}
                    for i = 1, bulletSyncMy.maxLines do
                        bulletSyncMy[i] = { my = {time = 0, t = {x,y,z}, o = {x,y,z}, type = 0, color = 0}}
                    end
                    HLcfg.config.maxLineMyLimit = elements.int.maxLineMyLimit.v
                    save()
                end imgui.SameLine() imgui.Text(u8"Максимальное количество линий")
    
                imgui.Separator()
    
                if imgui.Checkbox(u8"[Вкл/выкл] Окончания у линий##1", elements.checkbox.cbEndMy) then
                    HLcfg.config.cbEndMy = elements.checkbox.cbEndMy.v
                    save()
                end
    
                if imgui.SliderInt('##endNumber1s', elements.int.rotationMyPolygonEnd, 2, 10) then
                    HLcfg.config.rotationMyPolygonEnd = elements.int.rotationMyPolygonEnd.v 
                    save()
                end imgui.SameLine() imgui.Text(u8"Количество углов на окончаниях")
    
                if imgui.SliderInt('##rotationOne1', elements.int.degreeMyPolygonEnd, 0, 360) then
                    HLcfg.config.degreeMyPolygonEnd = elements.int.degreeMyPolygonEnd.v
                    save()
                end imgui.SameLine() imgui.Text(u8"Градус поворота окончания")
    
                if imgui.SliderInt('##sizeTraicerEnd1', elements.int.sizeOffMyPolygonEnd, 1, 10) then
                    HLcfg.config.sizeOffMyPolygonEnd = elements.int.sizeOffMyPolygonEnd.v
                    save()
                end  imgui.SameLine() imgui.Text(u8"Размер окончания трейсера")
    
                imgui.Separator()
    
                imgui.PopItemWidth()
                imgui.Text(u8"Укажите цвет трейсера, если: ")
                imgui.PushItemWidth(325)
                if imgui.ColorEdit4("##dinamicObjectMy", dinamicObjectMy) then
                    HLcfg.config.dinamicObjectMy = join_argb(dinamicObjectMy.v[1] * 255, dinamicObjectMy.v[2] * 255, dinamicObjectMy.v[3] * 255, dinamicObjectMy.v[4] * 255)
                    save()
                end imgui.SameLine() imgui.Text(u8"Вы попали в динамический объект")
                if imgui.ColorEdit4("##staticObjectMy", staticObjectMy) then
                    HLcfg.config.staticObjectMy = join_argb(staticObjectMy.v[1] * 255, staticObjectMy.v[2] * 255, staticObjectMy.v[3] * 255, staticObjectMy.v[4] * 255)
                    save()
                end imgui.SameLine() imgui.Text(u8"Вы попали в статический объект")
                if imgui.ColorEdit4("##pedMy", pedPMy) then
                    HLcfg.config.pedPMy = join_argb(pedPMy.v[1] * 255, pedPMy.v[2] * 255, pedPMy.v[3] * 255, pedPMy.v[4] * 255)
                    save()
                end imgui.SameLine() imgui.Text(u8"Вы попали в игрока")
                if imgui.ColorEdit4("##carMy", carPMy) then
                    HLcfg.config.carPMy = join_argb(carPMy.v[1] * 255, carPMy.v[2] * 255, carPMy.v[3] * 255, carPMy.v[4] * 255)
                    save()
                end imgui.SameLine() imgui.Text(u8"Вы попали в машину")
                imgui.PopItemWidth()
                imgui.Separator()
            end
            if imgui.CollapsingHeader(u8"Настройка чужих пуль") then
                imgui.Separator()
                if imgui.Checkbox(u8"[Вкл/выкл] Отрисовку чужих пуль", elements.checkbox.drawBullets) then
                    HLcfg.config.drawBullets = elements.checkbox.drawBullets.v
                    save()
                end
                imgui.PushItemWidth(175)
    
                if imgui.SliderInt("##bulletsTime2", elements.int.timeRenderBullets, 5, 40) then
                    HLcfg.config.timeRenderBullets = elements.int.timeRenderBullets.v
                    save()
                end imgui.SameLine() imgui.Text(u8"Время задержки трейсера")
    
                if imgui.SliderInt("##renderWidthLines2", elements.int.sizeOffLine, 1, 10) then
                    HLcfg.config.sizeOffLine = elements.int.sizeOffLine.v
                    save()
                end imgui.SameLine() imgui.Text(u8"Толщина линий")
    
                if imgui.SliderInt('##maxMyBullets2', elements.int.maxLineLimit, 10, 300) then
                    bulletSync.maxLines = elements.int.maxLineLimit.v
                    bulletSync = {lastId = 0, maxLines = elements.int.maxLineLimit.v}
                    for i = 1, bulletSync.maxLines do
                        bulletSync[i] = { other = {time = 0, t = {x,y,z}, o = {x,y,z}, type = 0, color = 0}}
                    end
                    HLcfg.config.maxLineLimit = elements.int.maxLineLimit.v
                    save()
                end imgui.SameLine() imgui.Text(u8"Максимальное количество линий")
    
                imgui.Separator()
    
                if imgui.Checkbox(u8"[Вкл/выкл] Окончания у линий##2", elements.checkbox.cbEnd) then
                    HLcfg.config.cbEnd = elements.checkbox.cbEnd.v
                    save()
                end
    
                if imgui.SliderInt('##endNumber2', elements.int.rotationPolygonEnd, 2, 10) then
                    HLcfg.config.rotationPolygonEnd = elements.int.rotationPolygonEnd.v 
                    save()
                end imgui.SameLine() imgui.Text(u8"Количество углов на окончаниях")
    
                if imgui.SliderInt('##rotationOne2', elements.int.degreePolygonEnd, 0, 360) then
                    HLcfg.config.degreePolygonEnd = elements.int.degreePolygonEnd.v
                    save()
                end imgui.SameLine() imgui.Text(u8"Градус поворота окончания")
    
                if imgui.SliderInt('##sizeTraicerEnd2', elements.int.sizeOffPolygonEnd, 1, 10) then
                    HLcfg.config.sizeOffPolygonEnd = elements.int.sizeOffPolygonEnd.v
                    save()
                end  imgui.SameLine() imgui.Text(u8"Размер окончания трейсера")
    
                imgui.PopItemWidth()
    
                imgui.Separator()
    
                if imgui.Checkbox(u8"[Вкл/выкл] ИД и никнейм игрока при выстреле", elements.checkbox.showPlayerInfo) then
                    HLcfg.config.showPlayerInfo = elements.checkbox.showPlayerInfo.v
                    save()
                end
    
                if imgui.Button(u8"Настроить информацию о стрелке", imgui.ImVec2(325, 0)) then
                    imgui.OpenPopup(u8"Настройка информации о стрелке")
                end
    
                if imgui.BeginPopup(u8"Настройка информации о стрелке") then
                    if imgui.Checkbox(u8"Показывать ИД", elements.checkbox.onlyId) then
                        HLcfg.config.onlyId = elements.checkbox.onlyId.v
                        save()
                    end
                    if imgui.Checkbox(u8"Показывать никнейм", elements.checkbox.onlyNick) then
                        HLcfg.config.onlyNick = elements.checkbox.onlyNick.v
                        save()
                    end
                    imgui.EndPopup()
                end
    
                imgui.PushItemWidth(325)
    
                if imgui.ColorEdit4("##infoNickId", colorPlayerI) then
                    HLcfg.config.colorPlayerI = join_argb(colorPlayerI.v[1] * 255, colorPlayerI.v[2] * 255, colorPlayerI.v[3] * 255, colorPlayerI.v[4] * 255)
                    save()
                end imgui.SameLine() imgui.Text(u8"Укажите цвет никнейма стрелка")
    
                imgui.PopItemWidth()
    
                imgui.Separator()
                imgui.Text(u8"Укажите цвет трейсера, если: ")
                imgui.PushItemWidth(325)
                if imgui.ColorEdit4("##dinamicObject", dinamicObject) then
                    HLcfg.config.dinamicObject = join_argb(dinamicObject.v[1] * 255, dinamicObject.v[2] * 255, dinamicObject.v[3] * 255, dinamicObject.v[4] * 255)
                    save()
                end imgui.SameLine() imgui.Text(u8"Игрок попал в динамический объект")
                if imgui.ColorEdit4("##staticObject", staticObject) then
                    HLcfg.config.staticObject = join_argb(staticObject.v[1] * 255, staticObject.v[2] * 255, staticObject.v[3] * 255, staticObject.v[4] * 255)
                    save()
                end imgui.SameLine() imgui.Text(u8"Игрок попал в статический объект")
                if imgui.ColorEdit4("##ped", pedP) then
                    HLcfg.config.pedP = join_argb(pedP.v[1] * 255, pedP.v[2] * 255, pedP.v[3] * 255, pedP.v[4] * 255)
                    save()
                end imgui.SameLine() imgui.Text(u8"Игрок попал в игрока")
                if imgui.ColorEdit4("##car", carP) then
                    HLcfg.config.carP = join_argb(carP.v[1] * 255, carP.v[2] * 255, carP.v[3] * 255, carP.v[4] * 255)
                    save()
                end imgui.SameLine() imgui.Text(u8"Игрок попал в машину")
                imgui.PopItemWidth()
                imgui.Separator()
				
            end
			  imgui.Separator()
				
				if imgui.Button(u8"Закрыть данное окно", imgui.ImVec2(550, 50)) then 
            traicers_window.v = false
			 

          end
	
		  if imgui.Button(u8"Закрыть данное окно и открыть основное", imgui.ImVec2(550, 50)) then 
            traicers_window.v = false
			army_window_state.v = true 
          end
		  imgui.Separator()
            imgui.End()
        end

         -------------------------трейсера пуль имгуи-------------------
		  
		  
		  end

------------------------------imgui---------------------------

function imgui.TextQuestion(text)
    imgui.SameLine()
    imgui.TextDisabled('[?]')
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(450)
        imgui.TextUnformatted(text)
        imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
end
------------------------------bind---------------------------

          function bind()
    lua_thread.create(function()
        local delay = tonumber(delay.v)
        for str in string.gmatch(binds.v, "[^\r\n]+") do
            sampProcessChatInput(u8:decode(str), -1)
            wait(delay)
        end
    end)
end
------------------------------bind---------------------------





 -------------------------трейсера пуль-------------------
 function sampev.onSendBulletSync(data)
    if elements.checkbox.drawMyBullets.v then
        if data.center.x ~= 0 then
            if data.center.y ~= 0 then
                if data.center.z ~= 0 then
                    bulletSyncMy.lastId = bulletSyncMy.lastId + 1
                    if bulletSyncMy.lastId < 1 or bulletSyncMy.lastId > bulletSyncMy.maxLines then
                        bulletSyncMy.lastId = 1
                    end
                    bulletSyncMy[bulletSyncMy.lastId].my.time = os.time() + elements.int.timeRenderMyBullets.v
                    bulletSyncMy[bulletSyncMy.lastId].my.o.x, bulletSyncMy[bulletSyncMy.lastId].my.o.y, bulletSyncMy[bulletSyncMy.lastId].my.o.z = data.origin.x, data.origin.y, data.origin.z
                    bulletSyncMy[bulletSyncMy.lastId].my.t.x, bulletSyncMy[bulletSyncMy.lastId].my.t.y, bulletSyncMy[bulletSyncMy.lastId].my.t.z = data.target.x, data.target.y, data.target.z
                    if data.targetType == 0 then
                        bulletSyncMy[bulletSyncMy.lastId].my.color = join_argb(255, staticObjectMy.v[1]*255, staticObjectMy.v[2]*255, staticObjectMy.v[3]*255)
                    elseif data.targetType == 1 then
                        bulletSyncMy[bulletSyncMy.lastId].my.color = join_argb(255, pedPMy.v[1]*255, pedPMy.v[2]*255, pedPMy.v[3]*255)
                    elseif data.targetType == 2 then
                        bulletSyncMy[bulletSyncMy.lastId].my.color = join_argb(255, carPMy.v[1]*255, carPMy.v[2]*255, carPMy.v[3]*255)
                    elseif data.targetType == 3 then
                        bulletSyncMy[bulletSyncMy.lastId].my.color = join_argb(255, dinamicObjectMy.v[1]*255, dinamicObjectMy.v[2]*255, dinamicObjectMy.v[3]*255)
                    end
                end
            end
        end
    end
end 

function sampev.onBulletSync(playerid, data)
    if elements.checkbox.drawBullets.v then
        if data.center.x ~= 0 then
            if data.center.y ~= 0 then
                if data.center.z ~= 0 then
                    bulletSync.lastId = bulletSync.lastId + 1
                    if bulletSync.lastId < 1 or bulletSync.lastId > bulletSync.maxLines then
                        bulletSync.lastId = 1
                    end
                    if elements.checkbox.showPlayerInfo.v then
                        bulletSync[bulletSync.lastId].other.id = playerid
                        bulletSync[bulletSync.lastId].other.colorText = join_argb(255, colorPlayerI.v[1]*255, colorPlayerI.v[2]*255, colorPlayerI.v[3]*255)
                    end
                    bulletSync[bulletSync.lastId].other.time = os.time() + elements.int.timeRenderBullets.v
                    bulletSync[bulletSync.lastId].other.o.x, bulletSync[bulletSync.lastId].other.o.y, bulletSync[bulletSync.lastId].other.o.z = data.origin.x, data.origin.y, data.origin.z
                    bulletSync[bulletSync.lastId].other.t.x, bulletSync[bulletSync.lastId].other.t.y, bulletSync[bulletSync.lastId].other.t.z = data.target.x, data.target.y, data.target.z
                    bulletSync[bulletSync.lastId].other.type = data.targetType
                    if data.targetType == 0 then
                        bulletSync[bulletSync.lastId].other.color = join_argb(255, staticObject.v[1]*255, staticObject.v[2]*255, staticObject.v[3]*255)
                    elseif data.targetType == 1 then
                        bulletSync[bulletSync.lastId].other.color = join_argb(255, pedP.v[1]*255, pedP.v[2]*255, pedP.v[3]*255)
                    elseif data.targetType == 2 then
                        bulletSync[bulletSync.lastId].other.color = join_argb(255, carP.v[1]*255, carP.v[2]*255, carP.v[3]*255)
                    elseif data.targetType == 3 then
                        bulletSync[bulletSync.lastId].other.color = join_argb(255, dinamicObject.v[1]*255, dinamicObject.v[2]*255, dinamicObject.v[3]*255)
                    end
                end
            end
        end
    end
end

function onScriptTerminate(script, quitGame)
	if script == thisScript() then thisScript():reload() end
end

function join_argb(a, r, g, b)
    local argb = b  -- b
    argb = bit.bor(argb, bit.lshift(g, 8))  -- g
    argb = bit.bor(argb, bit.lshift(r, 16)) -- r
    argb = bit.bor(argb, bit.lshift(a, 24)) -- a
    return argb
end

function save()
    inicfg.save(HLcfg, "MrpAdminTools.ini")
end


  -------------------------трейсера пуль-------------------



-------------------------ADMIN CHECKER---------------------

function fchecker()
    while true do
      wait(0)
      if not isPauseMenuActive() and not isKeyDown(VK_F8) and data.options.turn == 1 then
        if mouseCoordinates then
          sampToggleCursor(true)
            mouseX, mouseY = getCursorPos()
        end
        friendsText = " Админы в сети:\n"
        for b = 0, 1001 do
          if sampIsPlayerConnected(b) then name = sampGetPlayerNickname(b) end
          for i = 1, #data.friends do
            if sampIsPlayerConnected(b) then
              if data.friends[i] ~= nil then data.friends[i] = string.upper(data.friends[i]) end
              if name ~= nil then regPlayer = string.upper(name) end
              regName = string.match(data.friends[i], regPlayer)
              if regName == data.friends[i] then
                friendStreamed, friendPed = sampGetCharHandleBySampPlayerId(b)
                if friendStreamed then
                  friendX, friendY, friendZ = getCharCoordinates(friendPed)
                  myX, myY, myZ = getCharCoordinates(playerPed)
                  distance = getDistanceBetweenCoords3d(friendX, friendY, friendZ, myX, myY, myZ)
                  distanceInteger = math.floor(distance)
                end
                friendPaused = sampIsPlayerPaused(b)
                color = sampGetPlayerColor(b)
                color = string.format("%X", color)
                if friendPaused then color = string.gsub(color, "..(......)", "66%1") else color = string.gsub(color, "..(......)", "FF%1")
                end
                if friendStreamed then friendList = string.format("{%s}%s[%d] (%dm)", color, name, b, distanceInteger) else friendList = string.format("{%s}%s[%d]", color, name, b) end
                friendsText = string.format("%s %s\n", friendsText, friendList)
              end
            end
          end
        end
        if mouseCoordinates then
          renderFontDrawText(font, friendsText, mouseX, mouseY, -1)
          if isKeyDown(VK_LBUTTON) then
            mouseCoordinates = false
            local data = LIP.load('moonloader\\MRPAdminTools\\ADMChecker.ini');
            data.options.coordX = mouseX
            data.options.coordY = mouseY
            LIP.save('moonloader\\MRPAdminTools\\ADMChecker.ini', data);
            sampToggleCursor(false)
            local script = thisScript()
            script:reload()
			sampAddChatMessage(tag .. " Успешно, перезагружаю скрипт.", -1)
          end
        else
          if friendsText ~= " Админы в сети:\n" and friendsText ~= "nil" then renderFontDrawText(font, friendsText, data.options.coordX, data.options.coordY, -1) else renderFontDrawText(font, "Админы спят", data.options.coordX, data.options.coordY, -1) end
        end
      end
    end
  end
  
  function cmdMouseCoords()
      mouseCoordinates = true
  end
  
  function cmdTurn()
    local data = LIP.load('moonloader\\MRPAdminTools\\ADMChecker.ini');
    if data.options.turn == 1 then
      data.options.turn = 0
      LIP.save('moonloader\\MRPAdminTools\\ADMChecker.ini', data);
      local script = thisScript()
      script:reload()
	  sampAddChatMessage(tag .. "Успешно, перезагружаю скрипт." , -1 )
    else
      data.options.turn = 1
      LIP.save('moonloader\\MRPAdminTools\\ADMChecker.ini', data);
      local script = thisScript()
      script:reload()
	  sampAddChatMessage(tag .. "Успешно, перезагружаю скрипт." , -1 )
    end
  end
  
  function cmdReload()
    local script = thisScript()
    script:reload()
  end
  
  function cmdFontSize(newSize)
    local data = LIP.load('moonloader\\MRPAdminTools\\ADMChecker.ini');
    data.font.size = newSize
    LIP.save('moonloader\\MRPAdminTools\\ADMChecker.ini', data);
    local script = thisScript()
    script:reload()
	sampAddChatMessage(tag .. "Успешно, перезагружаю скрипт." , -1 )
  end
  
  function cmdFontName(newName)
    local data = LIP.load('moonloader\\MRPAdminTools\\ADMChecker.ini');
    data.font.name = newName
    LIP.save('moonloader\\MRPAdminTools\\ADMChecker.ini', data);
    local script = thisScript()
    script:reload()
	sampAddChatMessage(tag .. "Успешно, перезагружаю скрипт." , -1 )
  end
  
  function cmdFontFlag(newFlag)
    local data = LIP.load('moonloader\\MRPAdminTools\\ADMChecker.ini');
    data.font.flag = newFlag
    LIP.save('moonloader\\MRPAdminTools\\ADMChecker.ini', data);
    local script = thisScript()
    script:reload()
	sampAddChatMessage(tag .. "Успешно, перезагружаю скрипт." , -1 )
  end
  

  
  function cmdFriendsAdd(newFriend)
    newFriendN = tonumber(newFriend)
    if newFriendN ~= nil then
      if sampIsPlayerConnected(newFriendN) then newFriend = sampGetPlayerNickname(newFriendN) end
      if newFriend ~= nil then newFriend = string.upper(newFriend) end
    end
    local data = LIP.load('moonloader\\MRPAdminTools\\ADMChecker.ini');
    myIndex = 0
    abc = 1
    while abc == 1 do
      myIndex = myIndex + 1
       if data.friends[myIndex] == nil then abc = 2 end
    end
    data.friends[myIndex] = newFriend
    if data.friends[myIndex] ~= nil then data.friends[myIndex] = string.upper(data.friends[myIndex]) end
    LIP.save('moonloader\\MRPAdminTools\\ADMChecker.ini', data);
    local script = thisScript()
	sampAddChatMessage(tag .. "Успешно, перезагружаю скрипт." , -1 )
    script:reload()
  end
  
  function cmdFriendsRemove(delFriend)
    delFriendN = tonumber(delFriend)
    if delFriendN ~= nil then
      if sampIsPlayerConnected(delFriendN) then delFriend = sampGetPlayerNickname(delFriendN) end
      if delFriend ~= nil then delFriend = string.upper(delFriend) end
    end
    local data = LIP.load('moonloader\\MRPAdminTools\\ADMChecker.ini');
    if delFriend ~= nil then delFriend = string.upper(delFriend) end
    for i = 1, #data.friends do
      if data.friends[i] == delFriend then data.friends[i] = nil end
    end
    LIP.save('moonloader\\MRPAdminTools\\ADMChecker.ini', data);
    local script = thisScript()
    script:reload()
	sampAddChatMessage(tag .. "Успешно, перезагружаю скрипт." , -1 )
  end
  
  
  
  
  
  
  
  
  
  


--------------------------ADMIN CHECKER-------------------

------------------------------imgui---------------------------
function cmd_armyimg()
army_window_state.v = not army_window_state.v
imgui.Process = army_window_state.v
 end
------------------------------imgui---------------------------




         


---------------------------------themes for imgui---------------------------







          function otherRedTheme()
            imgui.SwitchContext()
  local style = imgui.GetStyle()
  local colors = style.Colors
  local clr = imgui.Col
  local ImVec4 = imgui.ImVec4
  local ImVec2 = imgui.ImVec2

  style.WindowPadding = imgui.ImVec2(8, 8)
  style.WindowRounding = 6
  style.ChildWindowRounding = 5
  style.FramePadding = imgui.ImVec2(5, 3)
  style.FrameRounding = 3.0
  style.ItemSpacing = imgui.ImVec2(5, 4)
  style.ItemInnerSpacing = imgui.ImVec2(4, 4)
  style.IndentSpacing = 21
  style.ScrollbarSize = 10.0
  style.ScrollbarRounding = 13
  style.GrabMinSize = 8
  style.GrabRounding = 1
  style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
  style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)

  colors[clr.Text]                   = ImVec4(0.95, 0.96, 0.98, 1.00);
  colors[clr.TextDisabled]           = ImVec4(0.29, 0.29, 0.29, 1.00);
  colors[clr.WindowBg]               = ImVec4(0.14, 0.14, 0.14, 1.00);
  colors[clr.ChildWindowBg]          = ImVec4(0.12, 0.12, 0.12, 1.00);
  colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94);
  colors[clr.Border]                 = ImVec4(0.14, 0.14, 0.14, 1.00);
  colors[clr.BorderShadow]           = ImVec4(1.00, 1.00, 1.00, 0.10);
  colors[clr.FrameBg]                = ImVec4(0.22, 0.22, 0.22, 1.00);
  colors[clr.FrameBgHovered]         = ImVec4(0.18, 0.18, 0.18, 1.00);
  colors[clr.FrameBgActive]          = ImVec4(0.09, 0.12, 0.14, 1.00);
  colors[clr.TitleBg]                = ImVec4(0.14, 0.14, 0.14, 0.81);
  colors[clr.TitleBgActive]          = ImVec4(0.14, 0.14, 0.14, 1.00);
  colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51);
  colors[clr.MenuBarBg]              = ImVec4(0.20, 0.20, 0.20, 1.00);
  colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.39);
  colors[clr.ScrollbarGrab]          = ImVec4(0.36, 0.36, 0.36, 1.00);
  colors[clr.ScrollbarGrabHovered]   = ImVec4(0.18, 0.22, 0.25, 1.00);
  colors[clr.ScrollbarGrabActive]    = ImVec4(0.24, 0.24, 0.24, 1.00);
  colors[clr.ComboBg]                = ImVec4(0.24, 0.24, 0.24, 1.00);
  colors[clr.CheckMark]              = ImVec4(1.00, 0.28, 0.28, 1.00);
  colors[clr.SliderGrab]             = ImVec4(1.00, 0.28, 0.28, 1.00);
  colors[clr.SliderGrabActive]       = ImVec4(1.00, 0.28, 0.28, 1.00);
  colors[clr.Button]                 = ImVec4(1.00, 0.28, 0.28, 1.00);
  colors[clr.ButtonHovered]          = ImVec4(1.00, 0.39, 0.39, 1.00);
  colors[clr.ButtonActive]           = ImVec4(1.00, 0.21, 0.21, 1.00);
  colors[clr.Header]                 = ImVec4(1.00, 0.28, 0.28, 1.00);
  colors[clr.HeaderHovered]          = ImVec4(1.00, 0.39, 0.39, 1.00);
  colors[clr.HeaderActive]           = ImVec4(1.00, 0.21, 0.21, 1.00);
  colors[clr.ResizeGrip]             = ImVec4(1.00, 0.28, 0.28, 1.00);
  colors[clr.ResizeGripHovered]      = ImVec4(1.00, 0.39, 0.39, 1.00);
  colors[clr.ResizeGripActive]       = ImVec4(1.00, 0.19, 0.19, 1.00);
  colors[clr.CloseButton]            = ImVec4(0.40, 0.39, 0.38, 0.16);
  colors[clr.CloseButtonHovered]     = ImVec4(0.40, 0.39, 0.38, 0.39);
  colors[clr.CloseButtonActive]      = ImVec4(0.40, 0.39, 0.38, 1.00);
  colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00);
  colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00);
  colors[clr.PlotHistogram]          = ImVec4(1.00, 0.21, 0.21, 1.00);
  colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.18, 0.18, 1.00);
  colors[clr.TextSelectedBg]         = ImVec4(1.00, 0.32, 0.32, 1.00);
  colors[clr.ModalWindowDarkening]   = ImVec4(0.26, 0.26, 0.26, 0.60);
end


          function ShepiTheme()
    imgui.SwitchContext()
    local style  = imgui.GetStyle()
    local colors = style.Colors
    local clr    = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2
    colors[clr.Text]                 = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextDisabled]         = ImVec4(0.73, 0.75, 0.74, 1.00)
    colors[clr.WindowBg]             = ImVec4(0.14, 0.06, 0.07, 1.00)
    colors[clr.ChildWindowBg]        = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.PopupBg]              = ImVec4(0.14, 0.06, 0.07, 1.00)
    colors[clr.Border]               = ImVec4(0.20, 0.20, 0.20, 0.50)
    colors[clr.BorderShadow]         = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.FrameBg]              = ImVec4(0.25, 0.01, 0.04, 1.00)
    colors[clr.FrameBgHovered]       = ImVec4(1.00, 0.15, 0.29, 1.00)
    colors[clr.FrameBgActive]        = ImVec4(0.14, 0.06, 0.07, 1.00)
    colors[clr.TitleBg]              = ImVec4(0.25, 0.01, 0.04, 1.00)
    colors[clr.TitleBgActive]        = ImVec4(1.00, 0.15, 0.29, 1.00)
    colors[clr.TitleBgCollapsed]     = ImVec4(0.25, 0.01, 0.04, 1.00)
    colors[clr.MenuBarBg]            = ImVec4(0.12, 0.05, 0.06, 1.00)
    colors[clr.ScrollbarBg]          = ImVec4(0.20, 0.20, 0.20, 0.99)
    colors[clr.ScrollbarGrab]        = ImVec4(0.25, 0.01, 0.04, 1.00)
    colors[clr.ScrollbarGrabHovered] = ImVec4(1.00, 0.15, 0.29, 1.00)
    colors[clr.ScrollbarGrabActive]  = ImVec4(0.14, 0.06, 0.07, 1.00)
    colors[clr.ComboBg]              = ImVec4(0.20, 0.20, 0.20, 0.99)
    colors[clr.CheckMark]            = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.SliderGrab]           = ImVec4(1.00, 0.15, 0.29, 1.00)
    colors[clr.SliderGrabActive]     = ImVec4(0.14, 0.06, 0.07, 1.00)
    colors[clr.Button]               = ImVec4(0.25, 0.01, 0.04, 1.00)
    colors[clr.ButtonHovered]        = ImVec4(1.00, 0.15, 0.29, 1.00)
    colors[clr.ButtonActive]         = ImVec4(0.20, 0.20, 0.20, 0.99)
    colors[clr.Header]               = ImVec4(1.00, 0.15, 0.29, 1.00)
    colors[clr.HeaderHovered]        = ImVec4(1.00, 0.15, 0.29, 0.75)
    colors[clr.HeaderActive]         = ImVec4(1.00, 0.15, 0.29, 1.00)
    colors[clr.Separator]            = ImVec4(0.25, 0.01, 0.04, 1.00)
    colors[clr.SeparatorHovered]     = ImVec4(1.00, 0.15, 0.29, 1.00)
    colors[clr.SeparatorActive]      = ImVec4(0.25, 0.01, 0.04, 1.00)
    colors[clr.ResizeGrip]           = ImVec4(0.25, 0.01, 0.04, 1.00)
    colors[clr.ResizeGripHovered]    = ImVec4(1.00, 0.15, 0.29, 1.00)
    colors[clr.ResizeGripActive]     = ImVec4(1.00, 0.15, 0.29, 1.00)
    colors[clr.CloseButton]          = ImVec4(0.25, 0.01, 0.04, 1.00)
    colors[clr.CloseButtonHovered]   = ImVec4(1.00, 0.15, 0.29, 1.00)
    colors[clr.CloseButtonActive]    = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.PlotLines]            = ImVec4(0.61, 0.61, 0.61, 1.00)
    colors[clr.PlotLinesHovered]     = ImVec4(1.00, 0.15, 0.29, 1.00)
    colors[clr.PlotHistogram]        = ImVec4(0.90, 0.70, 0.00, 1.00)
    colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
    colors[clr.TextSelectedBg]       = ImVec4(0.26, 0.59, 0.98, 0.35)
    colors[clr.ModalWindowDarkening] = ImVec4(0.80, 0.80, 0.80, 0.35)
end


          function DarkOrangeTheme()
            imgui.SwitchContext()
local style = imgui.GetStyle()
local colors = style.Colors
local clr = imgui.Col
local ImVec4 = imgui.ImVec4
local ImVec2 = imgui.ImVec2

style.WindowPadding = ImVec2(15, 15)
style.WindowRounding = 6.0
style.FramePadding = ImVec2(5, 5)
style.FrameRounding = 4.0
style.ItemSpacing = ImVec2(12, 8)
style.ItemInnerSpacing = ImVec2(8, 6)
style.IndentSpacing = 25.0
style.ScrollbarSize = 15.0
style.ScrollbarRounding = 9.0
style.GrabMinSize = 5.0
style.GrabRounding = 3.0

colors[clr.Text] = ImVec4(0.80, 0.80, 0.83, 1.00)
colors[clr.TextDisabled] = ImVec4(0.24, 0.23, 0.29, 1.00)
colors[clr.WindowBg] = ImVec4(0.06, 0.05, 0.07, 1.00)
colors[clr.ChildWindowBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
colors[clr.PopupBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
colors[clr.Border] = ImVec4(0.80, 0.80, 0.83, 0.88)
colors[clr.BorderShadow] = ImVec4(0.92, 0.91, 0.88, 0.00)
colors[clr.FrameBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
colors[clr.FrameBgHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
colors[clr.FrameBgActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
colors[clr.TitleBg] = ImVec4(0.76, 0.31, 0.00, 1.00)
colors[clr.TitleBgCollapsed] = ImVec4(1.00, 0.98, 0.95, 0.75)
colors[clr.TitleBgActive] = ImVec4(0.80, 0.33, 0.00, 1.00)
colors[clr.MenuBarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
colors[clr.ScrollbarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
colors[clr.ScrollbarGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
colors[clr.ScrollbarGrabHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
colors[clr.ScrollbarGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
colors[clr.ComboBg] = ImVec4(0.19, 0.18, 0.21, 1.00)
colors[clr.CheckMark] = ImVec4(1.00, 0.42, 0.00, 0.53)
colors[clr.SliderGrab] = ImVec4(1.00, 0.42, 0.00, 0.53)
colors[clr.SliderGrabActive] = ImVec4(1.00, 0.42, 0.00, 1.00)
colors[clr.Button] = ImVec4(0.10, 0.09, 0.12, 1.00)
colors[clr.ButtonHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
colors[clr.ButtonActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
colors[clr.Header] = ImVec4(0.10, 0.09, 0.12, 1.00)
colors[clr.HeaderHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
colors[clr.HeaderActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
colors[clr.ResizeGrip] = ImVec4(0.00, 0.00, 0.00, 0.00)
colors[clr.ResizeGripHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
colors[clr.PlotLines] = ImVec4(0.40, 0.39, 0.38, 0.63)
colors[clr.PlotLinesHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
colors[clr.PlotHistogram] = ImVec4(0.40, 0.39, 0.38, 0.63)
colors[clr.PlotHistogramHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
 end
          function MonohronTheme()
            imgui.SwitchContext()
local style = imgui.GetStyle()
local colors = style.Colors
local clr = imgui.Col
local ImVec4 = imgui.ImVec4

style.Alpha = 1.0
style.ChildWindowRounding = 3
style.WindowRounding = 3
style.GrabRounding = 1
style.GrabMinSize = 20
style.FrameRounding = 3

colors[clr.Text] = ImVec4(0.00, 1.00, 1.00, 1.00)
colors[clr.TextDisabled] = ImVec4(0.00, 0.40, 0.41, 1.00)
colors[clr.WindowBg] = ImVec4(0.00, 0.00, 0.00, 1.00)
colors[clr.ChildWindowBg] = ImVec4(0.00, 0.00, 0.00, 0.00)
colors[clr.Border] = ImVec4(0.00, 1.00, 1.00, 0.65)
colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
colors[clr.FrameBg] = ImVec4(0.44, 0.80, 0.80, 0.18)
colors[clr.FrameBgHovered] = ImVec4(0.44, 0.80, 0.80, 0.27)
colors[clr.FrameBgActive] = ImVec4(0.44, 0.81, 0.86, 0.66)
colors[clr.TitleBg] = ImVec4(0.14, 0.18, 0.21, 0.73)
colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.00, 0.00, 0.54)
colors[clr.TitleBgActive] = ImVec4(0.00, 1.00, 1.00, 0.27)
colors[clr.MenuBarBg] = ImVec4(0.00, 0.00, 0.00, 0.20)
colors[clr.ScrollbarBg] = ImVec4(0.22, 0.29, 0.30, 0.71)
colors[clr.ScrollbarGrab] = ImVec4(0.00, 1.00, 1.00, 0.44)
colors[clr.ScrollbarGrabHovered] = ImVec4(0.00, 1.00, 1.00, 0.74)
colors[clr.ScrollbarGrabActive] = ImVec4(0.00, 1.00, 1.00, 1.00)
colors[clr.ComboBg] = ImVec4(0.16, 0.24, 0.22, 0.60)
colors[clr.CheckMark] = ImVec4(0.00, 1.00, 1.00, 0.68)
colors[clr.SliderGrab] = ImVec4(0.00, 1.00, 1.00, 0.36)
colors[clr.SliderGrabActive] = ImVec4(0.00, 1.00, 1.00, 0.76)
colors[clr.Button] = ImVec4(0.00, 0.65, 0.65, 0.46)
colors[clr.ButtonHovered] = ImVec4(0.01, 1.00, 1.00, 0.43)
colors[clr.ButtonActive] = ImVec4(0.00, 1.00, 1.00, 0.62)
colors[clr.Header] = ImVec4(0.00, 1.00, 1.00, 0.33)
colors[clr.HeaderHovered] = ImVec4(0.00, 1.00, 1.00, 0.42)
colors[clr.HeaderActive] = ImVec4(0.00, 1.00, 1.00, 0.54)
colors[clr.ResizeGrip] = ImVec4(0.00, 1.00, 1.00, 0.54)
colors[clr.ResizeGripHovered] = ImVec4(0.00, 1.00, 1.00, 0.74)
colors[clr.ResizeGripActive] = ImVec4(0.00, 1.00, 1.00, 1.00)
colors[clr.CloseButton] = ImVec4(0.00, 0.78, 0.78, 0.35)
colors[clr.CloseButtonHovered] = ImVec4(0.00, 0.78, 0.78, 0.47)
colors[clr.CloseButtonActive] = ImVec4(0.00, 0.78, 0.78, 1.00)
colors[clr.PlotLines] = ImVec4(0.00, 1.00, 1.00, 1.00)
colors[clr.PlotLinesHovered] = ImVec4(0.00, 1.00, 1.00, 1.00)
colors[clr.PlotHistogram] = ImVec4(0.00, 1.00, 1.00, 1.00)
colors[clr.PlotHistogramHovered] = ImVec4(0.00, 1.00, 1.00, 1.00)
colors[clr.TextSelectedBg] = ImVec4(0.00, 1.00, 1.00, 0.22)
colors[clr.ModalWindowDarkening] = ImVec4(0.04, 0.10, 0.09, 0.51)
          end

          function RedTheme()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4

    style.WindowRounding = 2.0
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
    style.ChildWindowRounding = 2.0
    style.FrameRounding = 2.0
    style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
    style.ScrollbarSize = 13.0
    style.ScrollbarRounding = 0
    style.GrabMinSize = 8.0
    style.GrabRounding = 1.0

    colors[clr.FrameBg]                = ImVec4(0.48, 0.16, 0.16, 0.54)
    colors[clr.FrameBgHovered]         = ImVec4(0.98, 0.26, 0.26, 0.40)
    colors[clr.FrameBgActive]          = ImVec4(0.98, 0.26, 0.26, 0.67)
    colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
    colors[clr.TitleBgActive]          = ImVec4(0.48, 0.16, 0.16, 1.00)
    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
    colors[clr.CheckMark]              = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.SliderGrab]             = ImVec4(0.88, 0.26, 0.24, 1.00)
    colors[clr.SliderGrabActive]       = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.Button]                 = ImVec4(0.98, 0.26, 0.26, 0.40)
    colors[clr.ButtonHovered]          = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.ButtonActive]           = ImVec4(0.98, 0.06, 0.06, 1.00)
    colors[clr.Header]                 = ImVec4(0.98, 0.26, 0.26, 0.31)
    colors[clr.HeaderHovered]          = ImVec4(0.98, 0.26, 0.26, 0.80)
    colors[clr.HeaderActive]           = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.Separator]              = colors[clr.Border]
    colors[clr.SeparatorHovered]       = ImVec4(0.75, 0.10, 0.10, 0.78)
    colors[clr.SeparatorActive]        = ImVec4(0.75, 0.10, 0.10, 1.00)
    colors[clr.ResizeGrip]             = ImVec4(0.98, 0.26, 0.26, 0.25)
    colors[clr.ResizeGripHovered]      = ImVec4(0.98, 0.26, 0.26, 0.67)
    colors[clr.ResizeGripActive]       = ImVec4(0.98, 0.26, 0.26, 0.95)
    colors[clr.TextSelectedBg]         = ImVec4(0.98, 0.26, 0.26, 0.35)
    colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
    colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
    colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
    colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
    colors[clr.ComboBg]                = colors[clr.PopupBg]
    colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
    colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
    colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
    colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
    colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
    colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
    colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
    colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
    colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
    colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
end

function DarkTheme()
    imgui.SwitchContext()
       local style = imgui.GetStyle()
       local colors = style.Colors
       local clr = imgui.Col
       local ImVec4 = imgui.ImVec4
       local ImVec2 = imgui.ImVec2

        style.WindowPadding = ImVec2(15, 15)
        style.WindowRounding = 15.0
        style.FramePadding = ImVec2(5, 5)
        style.ItemSpacing = ImVec2(12, 8)
        style.ItemInnerSpacing = ImVec2(8, 6)
        style.IndentSpacing = 25.0
        style.ScrollbarSize = 15.0
        style.ScrollbarRounding = 15.0
        style.GrabMinSize = 15.0
        style.GrabRounding = 7.0
        style.ChildWindowRounding = 8.0
        style.FrameRounding = 6.0


          colors[clr.Text] = ImVec4(0.95, 0.96, 0.98, 1.00)
          colors[clr.TextDisabled] = ImVec4(0.36, 0.42, 0.47, 1.00)
          colors[clr.WindowBg] = ImVec4(0.11, 0.15, 0.17, 1.00)
          colors[clr.ChildWindowBg] = ImVec4(0.11, 0.15, 0.17, 1.00)
          colors[clr.PopupBg] = ImVec4(0.08, 0.08, 0.08, 0.94)
          colors[clr.Border] = ImVec4(0.43, 0.43, 0.50, 0.50)
          colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
          colors[clr.FrameBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
          colors[clr.FrameBgHovered] = ImVec4(0.12, 0.20, 0.28, 1.00)
          colors[clr.FrameBgActive] = ImVec4(0.09, 0.12, 0.14, 1.00)
          colors[clr.TitleBg] = ImVec4(0.09, 0.12, 0.14, 0.65)
          colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.00, 0.00, 0.51)
          colors[clr.TitleBgActive] = ImVec4(0.08, 0.10, 0.12, 1.00)
          colors[clr.MenuBarBg] = ImVec4(0.15, 0.18, 0.22, 1.00)
          colors[clr.ScrollbarBg] = ImVec4(0.02, 0.02, 0.02, 0.39)
          colors[clr.ScrollbarGrab] = ImVec4(0.20, 0.25, 0.29, 1.00)
          colors[clr.ScrollbarGrabHovered] = ImVec4(0.18, 0.22, 0.25, 1.00)
          colors[clr.ScrollbarGrabActive] = ImVec4(0.09, 0.21, 0.31, 1.00)
          colors[clr.ComboBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
          colors[clr.CheckMark] = ImVec4(0.28, 0.56, 1.00, 1.00)
          colors[clr.SliderGrab] = ImVec4(0.28, 0.56, 1.00, 1.00)
          colors[clr.SliderGrabActive] = ImVec4(0.37, 0.61, 1.00, 1.00)
          colors[clr.Button] = ImVec4(0.20, 0.25, 0.29, 1.00)
          colors[clr.ButtonHovered] = ImVec4(0.28, 0.56, 1.00, 1.00)
          colors[clr.ButtonActive] = ImVec4(0.06, 0.53, 0.98, 1.00)
          colors[clr.Header] = ImVec4(0.20, 0.25, 0.29, 0.55)
          colors[clr.HeaderHovered] = ImVec4(0.26, 0.59, 0.98, 0.80)
          colors[clr.HeaderActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
          colors[clr.ResizeGrip] = ImVec4(0.26, 0.59, 0.98, 0.25)
          colors[clr.ResizeGripHovered] = ImVec4(0.26, 0.59, 0.98, 0.67)
          colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
          colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
          colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
          colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
          colors[clr.PlotLines] = ImVec4(0.61, 0.61, 0.61, 1.00)
          colors[clr.PlotLinesHovered] = ImVec4(1.00, 0.43, 0.35, 1.00)
          colors[clr.PlotHistogram] = ImVec4(0.90, 0.70, 0.00, 1.00)
          colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
          colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
          colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
    end

---------------------------------themes for imgui---------------------------




--------------------------------------названия ганов-----------------

function getweaponname(weapon)
  local names = {
  [0] = "Fist",
  [1] = "Brass Knuckles",
  [2] = "Golf Club",
  [3] = "Nightstick",
  [4] = "Knife",
  [5] = "Baseball Bat",
  [6] = "Shovel",
  [7] = "Pool Cue",
  [8] = "Katana",
  [9] = "Chainsaw",
  [10] = "Purple Dildo",
  [11] = "Dildo",
  [12] = "Vibrator",
  [13] = "Silver Vibrator",
  [14] = "Flowers",
  [15] = "Cane",
  [16] = "Grenade",
  [17] = "Tear Gas",
  [18] = "Molotov Cocktail",
  [22] = "9mm",
  [23] = "Silenced 9mm",
  [24] = "Desert Eagle",
  [25] = "Shotgun",
  [26] = "Sawnoff Shotgun",
  [27] = "Combat Shotgun",
  [28] = "Micro SMG/Uzi",
  [29] = "MP5",
  [30] = "AK-47",
  [31] = "M4",
  [32] = "Tec-9",
  [33] = "Country Rifle",
  [34] = "Sniper Rifle",
  [35] = "RPG",
  [36] = "HS Rocket",
  [37] = "Flamethrower",
  [38] = "Minigun",
  [39] = "Satchel Charge",
  [40] = "Detonator",
  [41] = "Spraycan",
  [42] = "Fire Extinguisher",
  [43] = "Camera",
  [44] = "Night Vis Goggles",
  [45] = "Thermal Goggles",
  [46] = "Parachute" }
  return names[weapon]
end


--------------------------------------названия ганов-----------------


---------------------ADMIN CHECKER------------------
function LIP.load(fileName)
	assert(type(fileName) == 'string', 'Parameter "fileName" must be a string.');
	local file = assert(io.open(fileName, 'r'), 'Error loading file : ' .. fileName);
	local data = {};
	local section;
	for line in file:lines() do
		local tempSection = line:match('^%[([^%[%]]+)%]$');
		if(tempSection)then
			section = tonumber(tempSection) and tonumber(tempSection) or tempSection;
			data[section] = data[section] or {};
		end
		local param, value = line:match('^([%w|_]+)%s-=%s-(.+)$');
		if(param and value ~= nil)then
			if(tonumber(value))then
				value = tonumber(value);
			elseif(value == 'true')then
				value = true;
			elseif(value == 'false')then
				value = false;
			end
			if(tonumber(param))then
				param = tonumber(param);
			end
			data[section][param] = value;
		end
	end
	file:close();
	return data;
end

function LIP.save(fileName, data)
	assert(type(fileName) == 'string', 'Parameter "fileName" must be a string.');
	assert(type(data) == 'table', 'Parameter "data" must be a table.');
	local file = assert(io.open(fileName, 'w+b'), 'Error loading file :' .. fileName);
	local contents = '';
	for section, param in pairs(data) do
		contents = contents .. ('[%s]\n'):format(section);
		for key, value in pairs(param) do
			contents = contents .. ('%s=%s\n'):format(key, tostring(value));
		end
		contents = contents .. '\n';
	end
	file:write(contents);
	file:close();
end

return LIP;

-----------------ADMIN CHECKER-----------------
