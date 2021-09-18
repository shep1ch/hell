script_name("Admin Tools")

local script_version_str = "0.0.1"

local tag = "{5301d8}[Admin Tools]{ffffff} : "
local author = "{e80505}Shepi"
local version = "{ea0be6}0.3"
local vkeys = require("vkeys")
local sampev = require('lib.samp.events')
local q = require 'lib.samp.events'
local vk = require 'vkeys'
local speed = 0.2
local ips =
{
    ['Server'] = 's3.mordor-rp.ru:7777'
}

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

local imgui = require 'imgui'

selected_item = imgui.ImInt(0)
AirBrakeSpeed = imgui.ImFloat(2.0)


local samem = require 'SAMemory'
local Matrix3X3 = require "matrix3x3"
local ffi = require "ffi"
local getBonePosition = ffi.cast("int (__thiscall*)(void*, float*, int, bool)", 0x5E4280)
plates = {}

lua_thread.create(function()
	while true do
		wait(10000)
		for k, v in pairs(plates) do
			if not doesVehicleExist(select(2, sampGetCarHandleBySampVehicleId(tonumber(k)))) then
				plates[tonumber(k)] = nil
			end
		end
	end
end)


function sampev.onSetVehicleNumberPlate(id, text)
	plates[id] = text
end

function getPlate(id)
	if plates[tonumber(id)] ~= nil then
		return plates[tonumber(id)]
	else
		return "ГЌГҐГІ Г¤Г Г­Г­Г»Гµ"
	end
end

colours = {
-- The existing colours from San Andreas
"0x080808FF", "0xF5F5F5FF", "0x2A77A1FF", "0x840410FF", "0x263739FF", "0x86446EFF", "0xD78E10FF", "0x4C75B7FF", "0xBDBEC6FF", "0x5E7072FF",
"0x46597AFF", "0x656A79FF", "0x5D7E8DFF", "0x58595AFF", "0xD6DAD6FF", "0x9CA1A3FF", "0x335F3FFF", "0x730E1AFF", "0x7B0A2AFF", "0x9F9D94FF",
"0x3B4E78FF", "0x732E3EFF", "0x691E3BFF", "0x96918CFF", "0x515459FF", "0x3F3E45FF", "0xA5A9A7FF", "0x635C5AFF", "0x3D4A68FF", "0x979592FF",
"0x421F21FF", "0x5F272BFF", "0x8494ABFF", "0x767B7CFF", "0x646464FF", "0x5A5752FF", "0x252527FF", "0x2D3A35FF", "0x93A396FF", "0x6D7A88FF",
"0x221918FF", "0x6F675FFF", "0x7C1C2AFF", "0x5F0A15FF", "0x193826FF", "0x5D1B20FF", "0x9D9872FF", "0x7A7560FF", "0x989586FF", "0xADB0B0FF",
"0x848988FF", "0x304F45FF", "0x4D6268FF", "0x162248FF", "0x272F4BFF", "0x7D6256FF", "0x9EA4ABFF", "0x9C8D71FF", "0x6D1822FF", "0x4E6881FF",
"0x9C9C98FF", "0x917347FF", "0x661C26FF", "0x949D9FFF", "0xA4A7A5FF", "0x8E8C46FF", "0x341A1EFF", "0x6A7A8CFF", "0xAAAD8EFF", "0xAB988FFF",
"0x851F2EFF", "0x6F8297FF", "0x585853FF", "0x9AA790FF", "0x601A23FF", "0x20202CFF", "0xA4A096FF", "0xAA9D84FF", "0x78222BFF", "0x0E316DFF",
"0x722A3FFF", "0x7B715EFF", "0x741D28FF", "0x1E2E32FF", "0x4D322FFF", "0x7C1B44FF", "0x2E5B20FF", "0x395A83FF", "0x6D2837FF", "0xA7A28FFF",
"0xAFB1B1FF", "0x364155FF", "0x6D6C6EFF", "0x0F6A89FF", "0x204B6BFF", "0x2B3E57FF", "0x9B9F9DFF", "0x6C8495FF", "0x4D8495FF", "0xAE9B7FFF",
"0x406C8FFF", "0x1F253BFF", "0xAB9276FF", "0x134573FF", "0x96816CFF", "0x64686AFF", "0x105082FF", "0xA19983FF", "0x385694FF", "0x525661FF",
"0x7F6956FF", "0x8C929AFF", "0x596E87FF", "0x473532FF", "0x44624FFF", "0x730A27FF", "0x223457FF", "0x640D1BFF", "0xA3ADC6FF", "0x695853FF",
"0x9B8B80FF", "0x620B1CFF", "0x5B5D5EFF", "0x624428FF", "0x731827FF", "0x1B376DFF", "0xEC6AAEFF", "0x000000FF",
-- SA-MP extended colours (0.3x)
"0x177517FF", "0x210606FF", "0x125478FF", "0x452A0DFF", "0x571E1EFF", "0x010701FF", "0x25225AFF", "0x2C89AAFF", "0x8A4DBDFF", "0x35963AFF",
"0xB7B7B7FF", "0x464C8DFF", "0x84888CFF", "0x817867FF", "0x817A26FF", "0x6A506FFF", "0x583E6FFF", "0x8CB972FF", "0x824F78FF", "0x6D276AFF",
"0x1E1D13FF", "0x1E1306FF", "0x1F2518FF", "0x2C4531FF", "0x1E4C99FF", "0x2E5F43FF", "0x1E9948FF", "0x1E9999FF", "0x999976FF", "0x7C8499FF",
"0x992E1EFF", "0x2C1E08FF", "0x142407FF", "0x993E4DFF", "0x1E4C99FF", "0x198181FF", "0x1A292AFF", "0x16616FFF", "0x1B6687FF", "0x6C3F99FF",
"0x481A0EFF", "0x7A7399FF", "0x746D99FF", "0x53387EFF", "0x222407FF", "0x3E190CFF", "0x46210EFF", "0x991E1EFF", "0x8D4C8DFF", "0x805B80FF",
"0x7B3E7EFF", "0x3C1737FF", "0x733517FF", "0x781818FF", "0x83341AFF", "0x8E2F1CFF", "0x7E3E53FF", "0x7C6D7CFF", "0x020C02FF", "0x072407FF",
"0x163012FF", "0x16301BFF", "0x642B4FFF", "0x368452FF", "0x999590FF", "0x818D96FF", "0x99991EFF", "0x7F994CFF", "0x839292FF", "0x788222FF",
"0x2B3C99FF", "0x3A3A0BFF", "0x8A794EFF", "0x0E1F49FF", "0x15371CFF", "0x15273AFF", "0x375775FF", "0x060820FF", "0x071326FF", "0x20394BFF",
"0x2C5089FF", "0x15426CFF", "0x103250FF", "0x241663FF", "0x692015FF", "0x8C8D94FF", "0x516013FF", "0x090F02FF", "0x8C573AFF", "0x52888EFF",
"0x995C52FF", "0x99581EFF", "0x993A63FF", "0x998F4EFF", "0x99311EFF", "0x0D1842FF", "0x521E1EFF", "0x42420DFF", "0x4C991EFF", "0x082A1DFF",
"0x96821DFF", "0x197F19FF", "0x3B141FFF", "0x745217FF", "0x893F8DFF", "0x7E1A6CFF", "0x0B370BFF", "0x27450DFF", "0x071F24FF", "0x784573FF",
"0x8A653AFF", "0x732617FF", "0x319490FF", "0x56941DFF", "0x59163DFF", "0x1B8A2FFF", "0x38160BFF", "0x041804FF", "0x355D8EFF", "0x2E3F5BFF",
"0x561A28FF", "0x4E0E27FF", "0x706C67FF", "0x3B3E42FF", "0x2E2D33FF", "0x7B7E7DFF", "0x4A4442FF", "0x28344EFF"
}

function getBodyPartCoordinates(id, handle)
  local pedptr = getCharPointer(handle)
  local vec = ffi.new("float[3]")
  getBonePosition(ffi.cast("void*", pedptr), vec, id, true)
  return vec[0], vec[1], vec[2]
end

lua_thread.create(function()
	font = renderCreateFont("Roboto", 9, 5)
	while true do
	wait(0)
	if activation then

	if isCharInAnyCar(PLAYER_PED) then
		mycar = getCarCharIsUsing(PLAYER_PED)
	end

    for _, handle in ipairs(getAllVehicles()) do
    	if handle ~= mycar and doesVehicleExist(handle) and isCarOnScreen(handle) then
      		vehName = getGxtText(getNameOfVehicleModel(getCarModel(handle)))
      			myX, myY, myZ = getBodyPartCoordinates(8, PLAYER_PED)
      			X, Y, Z = getCarCoordinates(handle)
      				distance = getDistanceBetweenCoords3d(X, Y, Z, myX, myY, myZ)
      				X, Y = convert3DCoordsToScreen(X, Y, Z + 1)
              _, id = sampGetVehicleIdByCarHandle(handle)
							local primaryColor, secondaryColor = getCarColours(handle)
							color = colours[primaryColor + 1]
							color = color:sub(3, -3)
							if primaryColor ~= secondaryColor then
								secColor = colours[secondaryColor + 1]
								secColor = secColor:sub(3, -3)
								if vehName:find(" ") then
									vehName = vehName:gsub(" ", " {"..secColor.."}")
									vehName = "{"..color.."}"..vehName
								else
									if (#vehName % 2 == 0) then
										first = math.ceil(#vehName / 2)
										second = #vehName - first + 1
										vehName = "{"..color.."}"..vehName:sub(1, first).."{"..secColor.."}"..vehName:sub(second)
									else
										first = math.ceil(#vehName / 2)
										second = #vehName - first + 2
										vehName = "{"..color.."}"..vehName:sub(1, first).."{"..secColor.."}"..vehName:sub(second)
									end
								end
							else
								vehName = "{"..color.."}"..vehName
							end
      				renderFontDrawText(font, vehName .. "{ffffff}[".. id .."]", X - 10, Y, -1)
      	end
  	end

  	end

  	end
end)

function sendOnfootSync(x, y, z)
	local _, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
	local data = allocateMemory(68)
	sampStorePlayerOnfootData(myId, data)
	setStructElement(data, 37, 1, 3, false)
	setStructFloatElement(data, 6, x, false)
	setStructFloatElement(data, 10, y, false)
	setStructFloatElement(data, 14, z, false)
	setStructElement(data, 62, 2, veh, false)
	sampSendOnfootData(data)
	freeMemory(data)
end

function q.onSendOnfootSync(data)
    local speed1 = data.moveSpeed
    if fly then
        speed.y = -0.00001
        speed.z = -0.00001
        data.position.z = -10
    else
        local X, Y, Z = getCharCoordinates(PLAYER_PED)
        while Z ~= data.position.z do
            data.position.z = data.position.z + 1
            X, Y, Z = getCharCoordinates(PLAYER_PED)
        end
    end
end

local Vector3D = require "vector3d"
local slot = 0

local name = imgui.ImBuffer(20)
local combo  = imgui.ImInt(0)
local text1 = imgui.ImBuffer(65536)
local text2 = imgui.ImBuffer(65536)
local text3 = imgui.ImBuffer(65536)
local text4 = imgui.ImBuffer(65536)
local text5 = imgui.ImBuffer(65536)

keyToggle = VK_MBUTTON
keyApply = VK_LBUTTON
MAX_DISTANCE = 3000
local memory = require 'memory'
local textbloknot = imgui.ImBuffer(65536)
require"lib.sampfuncs"
local events = require 'lib.samp.events'
local event = require('lib.samp.events')

local slider = imgui.ImFloat(0)
local direct = 'moonloader\\config\\MrpAdminTools.ini'
local encoding = require "lib.encoding"
    require 'lib.moonloader'
    local fa = require 'faIcons'
local inicfg = require "inicfg"
local options = inicfg.main

local cmd_gm = 'gmc'
local enabled_gm = false

local ntHack = imgui.ImBool(false)
local brake = imgui.ImBool(false)
local speedbuffer = imgui.ImBuffer(25)
local namebuffer = imgui.ImBuffer(25)
local CheckBox = imgui.ImBool(false)
local obnova_window_state = imgui.ImBool(false)
local note_window_state = imgui.ImBool(false)
local ImVec2 = imgui.ImVec2
encoding.default = 'CP1251'
u8 = encoding.UTF8
local moonimgui_text_buffer = imgui.ImBuffer(u8'/замена\\/команда', 256)


-----------------------ini-------------------

    local directIni = 'MrpAdminTools.ini'
    local ini = inicfg.load(inicfg.load({
    	main = {
            name = "",

    	},
    }, directIni))
    inicfg.save(ini, directIni)
	
	local mainIni = inicfg.load(nil, directIni)

    if not doesFileExist("moonloader\\config\\MrpAdminTools.ini")
 then
  file = io.open("moonloader\\config\\MrpAdminTools.ini", "a")
  for i = 1, 50 do
   file:write("[" .. i .. "]\n" .. "name=Заметка №" .. i .. "\ntable=0\ntext1=\ntext2=\ntext3=\ntext4=\ntext5=\n")
  end
  file:close()
end

local ImBuffer = imgui.ImBuffer
local ImFloat = imgui.ImFloat
local ImBool = imgui.ImBool
local Matrix3X3 = require "matrix3x3"
local Vector3D = require "vector3d"
key = require("vkeys")
ev = require("lib.samp.events")


------------------------ini-------------------



local admin_window_state = imgui.ImBool(false)

local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })

function imgui.BeforeDrawFrame()
    if fa_font == nil then
        local font_config = imgui.ImFontConfig() -- to use 'imgui.ImFontConfig.new()' on error
        font_config.MergeMode = true
        fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fontawesome-webfont.ttf', 14.0, font_config, fa_glyph_ranges)
    end
end

  function createPointMarker(x, y, z)
	pointMarker = createUser3dMarker(x, y, z + 0.3, 4)
  end

  function removePointMarker()
	if pointMarker then
	  removeUser3dMarker(pointMarker)
	  pointMarker = nil
	end
  end
  
  function ev.onClearPlayerAnimation(id)
	local _, id = sampGetPlayerIdByCharHandle(1)
	if _ and thread_tp then
		thread_tp:terminate()
		thread_tp = false
	end
end

function loadSettings()
    local date = os.date('*t')
    local dir = getWorkingDirectory() .. '/config/AdminToolsMRP'
    
end




function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
	autoupdate("https://raw.githubusercontent.com/shep1ch/hell/main/script_version.json", '['..string.upper(thisScript().name)..']: ', "https://raw.githubusercontent.com/shep1ch/hell/main/MRPTools.lua")
	  initializeRender()

    while not isSampAvailable() do wait(100) end
	
	--if not checkip() then
          --sampAddChatMessage(tag .. '{02e984}Данный скрипт привязан к серверу проекта: {FF0000} Mordor Role Play 03,{02e984} произошла выгрузка.', -1)
		  --sampAddChatMessage(tag .. '{02e984}Данный скрипт привязан к серверу проекта: {FF0000} Mordor Role Play 03,{02e984} произошла выгрузка.', -1)
		  --sampAddChatMessage(tag .. '{02e984}Данный скрипт привязан к серверу проекта: {FF0000} Mordor Role Play 03,{02e984} произошла выгрузка.', -1)
		  --sampAddChatMessage(tag .. '{02e984}Данный скрипт привязан к серверу проекта: {FF0000} Mordor Role Play 03,{02e984} произошла выгрузка.', -1)
		 -- sampAddChatMessage(tag .. '{02e984}Данный скрипт привязан к серверу проекта: {FF0000} Mordor Role Play 03,{02e984} произошла выгрузка.', -1)
		 -- sampAddChatMessage(tag .. '{02e984}Данный скрипт привязан к серверу проекта: {FF0000} Mordor Role Play 03,{02e984} произошла выгрузка.', -1)
		 -- printStringNow("~y~ Mordor ~b~~h~ 03 ~r~~h~ one love", 10000)
        --thisScript():unload()
     -- else sampAddChatMessage(tag .. ' Айпи адрес совпадает с айпи адресом Мордора, скрипт загружен.',-1)
     -- end





DarkTheme() -----------тема имгуи
 wait(5000) --------------задержка
sampAddChatMessage(tag .. "загружен!", -1)
sampAddChatMessage(tag .. "Автор скрипта: " .. author , -1)
sampAddChatMessage(tag .. "Информация о скрипте - {FFFFFF}/amenu", -1)
sampAddChatMessage(tag .. "Актуальная версия тулса - " .. version, -1)
sampRegisterChatCommand("amenu", cmd_adminimgui)



imgui.Process = admin_window_state.v or obnova_window_state.v
loadSettings()
  while true do
      wait(0)  
	  
	   while isPauseMenuActive() do
      if cursorEnabled then
        showCursor(false)
      end
      wait(100)
    end

    if isKeyDown(4) then
      cursorEnabled = not cursorEnabled
      showCursor(cursorEnabled)
      while isKeyDown(4) do wait(80) end
    end

    if cursorEnabled then
      local mode = sampGetCursorMode()
      if mode == 0 then
        showCursor(true)
      end
      local sx, sy = getCursorPos()
      local sw, sh = getScreenResolution()
      -- is cursor in game window bounds?
      if sx >= 0 and sy >= 0 and sx < sw and sy < sh then
        local posX, posY, posZ = convertScreenCoordsToWorld3D(sx, sy, 700.0)
        local camX, camY, camZ = getActiveCameraCoordinates()
        -- search for the collision point
        local result, colpoint = processLineOfSight(camX, camY, camZ, posX, posY, posZ, true, true, false, true, false, false, false)
        if result and colpoint.entity ~= 0 then
          local normal = colpoint.normal
          local pos = Vector3D(colpoint.pos[1], colpoint.pos[2], colpoint.pos[3]) - (Vector3D(normal[1], normal[2], normal[3]) * 0.1)
          local zOffset = 300
          if normal[3] >= 0.5 then zOffset = 1 end
          -- search for the ground position vertically down
          local result, colpoint2 = processLineOfSight(pos.x, pos.y, pos.z + zOffset, pos.x, pos.y, pos.z - 0.3,
            true, true, false, true, false, false, false)
          if result then
            pos = Vector3D(colpoint2.pos[1], colpoint2.pos[2], colpoint2.pos[3] + 1)

            local curX, curY, curZ  = getCharCoordinates(playerPed)
            local dist              = getDistanceBetweenCoords3d(curX, curY, curZ, pos.x, pos.y, pos.z)
            local hoffs             = renderGetFontDrawHeight(font)

            sy = sy - 2
            sx = sx - 2
            renderFontDrawText(font, string.format("%0.2fm", dist), sx, sy - hoffs, 0xEEEEEEEE)

            local tpIntoCar = nil
            if colpoint.entityType == 2 then
              local car = getVehiclePointerHandle(colpoint.entity)
              if doesVehicleExist(car) and (not isCharInAnyCar(playerPed) or storeCarCharIsInNoSave(playerPed) ~= car) then
                displayVehicleName(sx, sy - hoffs * 2, getNameOfVehicleModel(getCarModel(car)))
                local color = 0xAAFFFFFF
                if isKeyDown(VK_RBUTTON) then
                  tpIntoCar = car
                  color = 0xFFFFFFFF
				  if isKeyDown(key.VK_LMENU) then
					--teleportPlayer(pos.x, pos.y, pos.z)
					jumpIntoCar(car)
					showCursor(false)
					removePointMarker()
				  end
                end
                renderFontDrawText(font2, "Hold right mouse button to teleport into the car", sx, sy - hoffs * 3, color)
              end
            end

            createPointMarker(pos.x, pos.y, pos.z)

            -- teleport!
            if isKeyDown(1) then
				if dist <= MAX_DISTANCE then
				  if tpIntoCar then
					if not jumpIntoCar(tpIntoCar) then
					  -- teleport to the car if there is no free seats
					  teleportPlayer(pos.x, pos.y, pos.z)
					end
				  else
					if isCharInAnyCar(playerPed) then
					  local norm = Vector3D(colpoint.normal[1], colpoint.normal[2], 0)
					  local norm2 = Vector3D(colpoint2.normal[1], colpoint2.normal[2], colpoint2.normal[3])
					  rotateCarAroundUpAxis(storeCarCharIsInNoSave(playerPed), norm2)
					  pos = pos - norm * 1.8
					  pos.z = pos.z - 0.8
					end
					teleportPlayer(pos.x, pos.y, pos.z)
				  end
				  removePointMarker()

				  while isKeyDown(1) do wait(0) end
				  showCursor(false)
				end
			end
          end
        end
      end
    end
    wait(0)
    removePointMarker()
  
	  
	 
	
	  
	  if testCheat("CM") then
      admin_window_state.v = not admin_window_state.v 
	  imgui.Process = admin_window_state.v
    end	
	  
	  if isKeyJustPressed(17) then -- airbrake
			AirBrk = not AirBrk
			if AirBrk then
				local posX, posY, posZ = getCharCoordinates(playerPed)
				airBrkCoords = {posX, posY, posZ, 0.0, 0.0, getCharHeading(playerPed)}
			end
		end
		local time = os.clock() * 1000
		if AirBrk then -- airbrake
			if isCharInAnyCar(playerPed) then heading = getCarHeading(storeCarCharIsInNoSave(playerPed))
			else heading = getCharHeading(playerPed) end
			local camCoordX, camCoordY, camCoordZ = getActiveCameraCoordinates()
			local targetCamX, targetCamY, targetCamZ = getActiveCameraPointAt()
			local angle = getHeadingFromVector2d(targetCamX - camCoordX, targetCamY - camCoordY)
			if isCharInAnyCar(playerPed) then difference = 0.79 else difference = 1.0 end
			setCharCoordinates(playerPed, airBrkCoords[1], airBrkCoords[2], airBrkCoords[3] - difference)
			if isKeyDown(VK_W) then
				airBrkCoords[1] = airBrkCoords[1] + AirBrakeSpeed.v * math.sin(-math.rad(angle))
				airBrkCoords[2] = airBrkCoords[2] + AirBrakeSpeed.v * math.cos(-math.rad(angle))
				if not isCharInAnyCar(playerPed) then setCharHeading(playerPed, angle)
				else setCarHeading(storeCarCharIsInNoSave(playerPed), angle) end
			elseif isKeyDown(VK_S) then
				airBrkCoords[1] = airBrkCoords[1] - AirBrakeSpeed.v * math.sin(-math.rad(heading))
				airBrkCoords[2] = airBrkCoords[2] - AirBrakeSpeed.v * math.cos(-math.rad(heading))
			end
			if isKeyDown(VK_A) then
				airBrkCoords[1] = airBrkCoords[1] - AirBrakeSpeed.v * math.sin(-math.rad(heading - 90))
				airBrkCoords[2] = airBrkCoords[2] - AirBrakeSpeed.v * math.cos(-math.rad(heading - 90))
			elseif isKeyDown(VK_D) then
				airBrkCoords[1] = airBrkCoords[1] - AirBrakeSpeed.v * math.sin(-math.rad(heading + 90))
				airBrkCoords[2] = airBrkCoords[2] - AirBrakeSpeed.v * math.cos(-math.rad(heading + 90))
			end
			if isKeyDown(VK_UP) then airBrkCoords[3] = airBrkCoords[3] + AirBrakeSpeed.v / 2.0 end
			if isKeyDown(VK_DOWN) and airBrkCoords[3] > -95.0 then airBrkCoords[3] = airBrkCoords[3] - AirBrakeSpeed.v / 2.0 end
			if not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then
				if isKeyDown(VK_OEM_PLUS) and time - tick.Keys.Plus > tick.Time.PlusMinus then
					if AirBrakeSpeed.v < 14.9 then AirBrakeSpeed.v = AirBrakeSpeed.v + 0.5 end
					post_of_notification(string.format('AirBrk speed changed to: %.1f.', AirBrakeSpeed.v))
					tick.Keys.Plus = os.clock() * 1000
				elseif isKeyDown(VK_OEM_MINUS) and time - tick.Keys.Minus > tick.Time.PlusMinus then
					if AirBrakeSpeed.v > 0.5 then AirBrakeSpeed.v = AirBrakeSpeed.v - 0.5 end
					post_of_notification(string.format('AirBrk speed changed to: %.1f.', AirBrakeSpeed.v))
					tick.Keys.Minus = os.clock() * 1000
				end
			end
		end
		
	  
	  
	  if wasKeyPressed(88) and not sampIsChatInputActive() then
	   		activation = not activation
	   	end


	  if enabled_gm then
            setCarProofs(storeCarCharIsInNoSave(playerPed), true, true, true, true, true)
        end



        if not admin_window_state.v and not obnova_window_state.v then imgui.Process = false end

        end
		end
		


	

function initializeRender()
  font = renderCreateFont("Tahoma", 10, FCR_BOLD + FCR_BORDER)
  font2 = renderCreateFont("Arial", 8, FCR_ITALICS + FCR_BORDER)
end


--- Functions
function rotateCarAroundUpAxis(car, vec)
  local mat = Matrix3X3(getVehicleRotationMatrix(car))
  local rotAxis = Vector3D(mat.up:get())
  vec:normalize()
  rotAxis:normalize()
  local theta = math.acos(rotAxis:dotProduct(vec))
  if theta ~= 0 then
    rotAxis:crossProduct(vec)
    rotAxis:normalize()
    rotAxis:zeroNearZero()
    mat = mat:rotate(rotAxis, -theta)
  end
  setVehicleRotationMatrix(car, mat:get())
end

function readFloatArray(ptr, idx)
  return representIntAsFloat(readMemory(ptr + idx * 4, 4, false))
end

function writeFloatArray(ptr, idx, value)
  writeMemory(ptr + idx * 4, 4, representFloatAsInt(value), false)
end

function getVehicleRotationMatrix(car)
  local entityPtr = getCarPointer(car)
  if entityPtr ~= 0 then
    local mat = readMemory(entityPtr + 0x14, 4, false)
    if mat ~= 0 then
      local rx, ry, rz, fx, fy, fz, ux, uy, uz
      rx = readFloatArray(mat, 0)
      ry = readFloatArray(mat, 1)
      rz = readFloatArray(mat, 2)

      fx = readFloatArray(mat, 4)
      fy = readFloatArray(mat, 5)
      fz = readFloatArray(mat, 6)

      ux = readFloatArray(mat, 8)
      uy = readFloatArray(mat, 9)
      uz = readFloatArray(mat, 10)
      return rx, ry, rz, fx, fy, fz, ux, uy, uz
    end
  end
end

function setVehicleRotationMatrix(car, rx, ry, rz, fx, fy, fz, ux, uy, uz)
  local entityPtr = getCarPointer(car)
  if entityPtr ~= 0 then
    local mat = readMemory(entityPtr + 0x14, 4, false)
    if mat ~= 0 then
      writeFloatArray(mat, 0, rx)
      writeFloatArray(mat, 1, ry)
      writeFloatArray(mat, 2, rz)

      writeFloatArray(mat, 4, fx)
      writeFloatArray(mat, 5, fy)
      writeFloatArray(mat, 6, fz)

      writeFloatArray(mat, 8, ux)
      writeFloatArray(mat, 9, uy)
      writeFloatArray(mat, 10, uz)
    end
  end
end

function displayVehicleName(x, y, gxt)
  x, y = convertWindowScreenCoordsToGameScreenCoords(x, y)
  useRenderCommands(true)
  setTextWrapx(640.0)
  setTextProportional(true)
  setTextJustify(false)
  setTextScale(0.33, 0.8)
  setTextDropshadow(0, 0, 0, 0, 0)
  setTextColour(255, 255, 255, 230)
  setTextEdge(1, 0, 0, 0, 100)
  setTextFont(1)
  displayText(x, y, gxt)
end

function createPointMarker(x, y, z)
  pointMarker = createUser3dMarker(x, y, z + 0.3, 4)
end

function removePointMarker()
  if pointMarker then
    removeUser3dMarker(pointMarker)
    pointMarker = nil
  end
end

function getCarFreeSeat(car)
  if doesCharExist(getDriverOfCar(car)) then
    local maxPassengers = getMaximumNumberOfPassengers(car)
    for i = 0, maxPassengers do
      if isCarPassengerSeatFree(car, i) then
        return i
      end
	  i = i+1
    end
    return nil -- no free seats
  else
    return nil -- driver seat
  end
end

function jumpIntoCar(car)
  if not isKeyDown(key.VK_LCONTROL) then
	for i=0,1999 do
		local _, c = sampGetCarHandleBySampVehicleId(i)
		if _ and car == c then
			thread_tp = lua_thread.create(function()
				sampSendEnterVehicle(i,false)
				wait(1000)
				if doesVehicleExist(car) then
					warpCharIntoCar(playerPed, car)
					thread_tp = nil
				end
			end)
			break
		end
	end -- driver seat
  else
  local seat = -1
  for i=0, getMaximumNumberOfPassengers(car) do
	if isCarPassengerSeatFree(car, i) then
		seat = i
	end
  end
	if seat == -1 then return false end    
	for i=0,1999 do
		local _, c = sampGetCarHandleBySampVehicleId(i)
		if _ and car == c then
			thread_tp = lua_thread.create(function()
				sampSendEnterVehicle(i,true)
				wait(1000)
				if doesVehicleExist(car) then
					if seat ~= nil then
						warpCharIntoCarAsPassenger(playerPed, car, seat) -- passenger seat
						thread_tp = nil
					end
				end
			end)
			break
		end
	end
  end
  --restoreCameraJumpcut()
  return true
end

function teleportPlayer(x, y, z)
  if isCharInAnyCar(playerPed) then
    setCharCoordinates(playerPed, x, y, z)
  end
  setCharCoordinatesDontResetAnim(playerPed, x, y, z)
end

function setCharCoordinatesDontResetAnim(char, x, y, z)
  if doesCharExist(char) then
    local ptr = getCharPointer(char)
    setEntityCoordinates(ptr, x, y, z)
  end
end

function setEntityCoordinates(entityPtr, x, y, z)
  if entityPtr ~= 0 then
    local matrixPtr = readMemory(entityPtr + 0x14, 4, false)
    if matrixPtr ~= 0 then
      local posPtr = matrixPtr + 0x30
      writeMemory(posPtr + 0, 4, representFloatAsInt(x), false) -- X
      writeMemory(posPtr + 4, 4, representFloatAsInt(y), false) -- Y
      writeMemory(posPtr + 8, 4, representFloatAsInt(z), false) -- Z
    end
  end
end

function showCursor(toggle)
  if toggle then
    sampSetCursorMode(CMODE_LOCKCAM)
  else
    sampToggleCursor(false)
  end
  cursorEnabled = toggle
end

        function imgui.OnDrawFrame()
		if admin_window_state.v then

                imgui.SetNextWindowPos(imgui.ImVec2(19, 325 ), imgui.Cond.FirstUseEver)
                imgui.SetNextWindowSize(imgui.ImVec2(950, 550), imgui.Cond.FirstUseEver)
                imgui.Begin(fa.ICON_USER_O .. " Admin Tools for Mordor RP | by shepi", admin_window_state, imgui.WindowFlags.NoResize)
                imgui.BeginChild('##121', imgui.ImVec2(320, 500), true)
                if imgui.Button(u8'Основное меню', imgui.ImVec2(250, 25), admin_window_state) then menu = 1 end

                if imgui.Button(u8'Настройки', imgui.ImVec2(250, 25), admin_window_state) then menu = 2 end

                if imgui.Button(u8'Заметки', imgui.ImVec2(250, 25), admin_window_state) then note_window_state.v = true end

                if imgui.Button(u8"Читы", imgui.ImVec2(250, 25), admin_window_state) then menu = 4 end

                if imgui.Button(u8"Все функции в скрипте", imgui.ImVec2(250, 25), admin_window_state) then menu = 5 end
				imgui.SameLine()
                imgui.EndChild()





			 imgui.SameLine()
			  imgui.SameLine()
			   imgui.SameLine()
              if menu == 1 then
			  imgui.SameLine()
				
                imgui.Text(u8"Вас приветствует админ тулс.\nКнопки переключения менюшек находятся слева.\nПриятного пользования ^-^")
				
              end
							

              if menu == 2 then



		if imgui.CollapsingHeader(u8"Настройки цвета имгуи") then


                  if imgui.Combo(u8' ', selected_item, {u8'Фиолетовая', u8'Тёмная', u8'Красная', u8'Вишнёвая'}, 4) then

  if selected_item.v == 0 then
    FiollaTheme()
  end
    if selected_item.v == 1 then
        DarkTheme()
    end
    if selected_item.v == 2 then
        RedTheme()
    end
    if selected_item.v == 3 then
        ShepiTheme()
    end


end

end

end

              if menu == 3 then
				

              end


              if menu == 4 then
							imgui.BeginChild(" cum ", imgui.ImVec2(700, 500), false)	
			 imgui.SameLine()

                 if imgui.Checkbox(u8'WallHack',ntHack)
			then
				ntHack.v = ntHack.v
				if ntHack.v then nameTagOn() else nameTagOff() end

		end
		imgui.SliderFloat(u8'Airbrake',AirBrakeSpeed,0.00,100.00, '%.2f', 0.2)
		
		imgui.EndChild()












      end
              if menu == 5 then

								
                imgui.Text(u8"/amenu - Данный диалог\n'X' - активировать модифицированный /dl\n'CTRL' - AirBrake\n'На клавиатуре - CM' - Тоже самое что и /amenu\n'Кликварп:\nНажать на колёсико мыши, далее навести курсор н анужное вам место..\n..и нажать левую кнопку мыши\nТП В КАР пи помощи кликварпа:\nОпять-же, колесико мыши, наводитесь на машину и...\n..зажимаете правую кнопку мыши и нажмаете левую\nВкратце про кликварп:\nПри открытии данного окна, по умолчанию кликварп включен и вы можете тпшнуться\nПо поводу метки мигающей, я сделал её мигающей, думаю, что так будет лучше'" )
				imgui.SameLine()
				if imgui.Button(u8"Инфо о обновлениях") then
				obnova_window_state.v = true
				end
				
              end
						


                 imgui.End()
              end
			  if note_window_state.v then 
			     imgui.SetNextWindowSize(imgui.ImVec2(750, 500), imgui.Cond.FirstUseEver)
				 imgui.SetNextWindowPos(imgui.ImVec2(1032, 344), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5)) 
				 imgui.Begin(fa.ICON_FA_ENVELOPE_OPEN_TEXT .. u8" Заметки", imgui.WindowFlags.NoResize)
				 imgui.BeginChild("", imgui.ImVec2(150, 464), true)
   for i = 1, 50 do
    if imgui.Selectable(u8(mainIni[i].name))
	 then
	  name.v = u8(mainIni[i].name)
	  combo.v = mainIni[i].table
	  text1.v = string.gsub(u8(mainIni[i].text1), "&", "\n")
      text2.v = string.gsub(u8(mainIni[i].text2), "&", "\n")
	  text3.v = string.gsub(u8(mainIni[i].text3), "&", "\n")
	  text4.v = string.gsub(u8(mainIni[i].text4), "&", "\n")
	  text5.v = string.gsub(u8(mainIni[i].text5), "&", "\n")
	  slot = i
	end
   end
   imgui.EndChild()
   imgui.SameLine()
   imgui.BeginChild(" ", imgui.ImVec2(579, 464), true)
   if slot ~= 0
    then
     imgui.Text(u8"Название:")
     imgui.SameLine()
	 imgui.PushItemWidth(150)
     imgui.InputText(u8"Столбцы:", name)
     imgui.SameLine()
	 imgui.PushItemWidth(40)
	 imgui.Combo("  ", combo, {"1", "2", "3", "4", "5"})
	 imgui.PopItemWidth(2)
	 imgui.SameLine(331)
	 if imgui.Button(fa.ICON_FA_SAVE .. u8" Сохранить", imgui.ImVec2(125, 20))
	  then
	   mainIni[slot].name = u8:decode(name.v)
	   mainIni[slot].table = combo.v
	   mainIni[slot].text1 = string.gsub(u8:decode(text1.v), "\n", "&")
	   mainIni[slot].text2 = string.gsub(u8:decode(text2.v), "\n", "&")
	   mainIni[slot].text3 = string.gsub(u8:decode(text3.v), "\n", "&")
	   mainIni[slot].text4 = string.gsub(u8:decode(text4.v), "\n", "&")
	   mainIni[slot].text5 = string.gsub(u8:decode(text5.v), "\n", "&")
	   inicfg.save(mainIni, directIni)
	   sampAddChatMessage('[Note] {FFFFFF}Заметка "' .. u8:decode(name.v) .. '" сохранена.', 0x3399FF)
	 end
	 if combo.v == 0 then
	  imgui.InputTextMultiline("    ", text1, imgui.ImVec2(562, 423))
	 elseif combo.v == 1 then
	  imgui.InputTextMultiline("    ", text1, imgui.ImVec2(279, 423))
	  imgui.SameLine()
	  imgui.InputTextMultiline("     ", text2, imgui.ImVec2(279, 423))
	 elseif combo.v == 2 then
	  imgui.InputTextMultiline("    ", text1, imgui.ImVec2(184, 423))
	  imgui.SameLine()
	  imgui.InputTextMultiline("     ", text2, imgui.ImVec2(184, 423))
	  imgui.SameLine()
	  imgui.InputTextMultiline("      ", text3, imgui.ImVec2(184, 423))
	 elseif combo.v == 3 then
	  imgui.InputTextMultiline("    ", text1, imgui.ImVec2(137, 423))
	  imgui.SameLine()
	  imgui.InputTextMultiline("     ", text2, imgui.ImVec2(137, 423))
	  imgui.SameLine()
	  imgui.InputTextMultiline("      ", text3, imgui.ImVec2(137, 423))
	  imgui.SameLine()
	  imgui.InputTextMultiline("       ", text4, imgui.ImVec2(137, 423))
	 elseif combo.v == 4 then
	  imgui.InputTextMultiline("    ", text1, imgui.ImVec2(108, 423))
	  imgui.SameLine()
	  imgui.InputTextMultiline("     ", text2, imgui.ImVec2(108, 423))
	  imgui.SameLine()
	  imgui.InputTextMultiline("      ", text3, imgui.ImVec2(108, 423))
	  imgui.SameLine()
	  imgui.InputTextMultiline("       ", text4, imgui.ImVec2(108, 423))
	  imgui.SameLine()
	  imgui.InputTextMultiline("        ", text5, imgui.ImVec2(108, 423))
	 end
   end
  
   imgui.EndChild()

              
				 imgui.End() 
				 end
			  if obnova_window_state.v then

        imgui.SetNextWindowPos(imgui.ImVec2(1032, 344), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(500, 250), imgui.Cond.FirstUseEver)
                imgui.Begin(fa.ICON_USER_O .. u8" Информация о  обновлениях", obnova_window_state, imgui.WindowFlags.NoResize)
				imgui.Text(u8"Да")
				imgui.End()
				end
				end



              function cmd_adminimgui()
              admin_window_state.v = not admin_window_state.v
                imgui.Process = admin_window_state.v
              end

			  function nameTagOn()
			  sampAddChatMessage(tag .. " WallHack включен!", -1)
	local pStSet = sampGetServerSettingsPtr()
	NTdist = memory.getfloat(pStSet + 80) -- дальность
	NTwalls = memory.getint8(pStSet + 47) -- видимость через стены
	NTshow = memory.getint8(pStSet + 56) -- видимость тегов
	memory.setfloat(pStSet + 39, 1488.0)
	memory.setint8(pStSet + 47, 0)
	memory.setint8(pStSet + 56, 1)
end

function nameTagOff()
sampAddChatMessage(tag .. " WallHack выключен!", -1)
	local pStSet = sampGetServerSettingsPtr()
	memory.setfloat(pStSet + 39, NTdist)
	memory.setint8(pStSet + 47, NTwalls)
	memory.setint8(pStSet + 56, NTshow)
end

--
--     _   _   _ _____ ___  _   _ ____  ____    _  _____ _____   
--    / \ | | | |_   _/ _ \| | | |  _ \|  _ \  / \|_   _| ____| 
--   / _ \| | | | | || | | | | | | |_) | | | |/ _ \ | | |  _|   
--  / ___ \ |_| | | || |_| | |_| |  __/| |_| / ___ \| | | |___  
-- /_/   \_\___/  |_| \___/ \___/|_|   |____/_/   \_\_| |_____|                                                                                                                                                                                                                 
--
-- 
--
function autoupdate(json_url, prefix, url)
  local dlstatus = require('moonloader').download_status
  local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
  if doesFileExist(json) then os.remove(json) end
  downloadUrlToFile(json_url, json,
    function(id, status, p1, p2)
      if status == dlstatus.STATUSEX_ENDDOWNLOAD then
        if doesFileExist(json) then
          local f = io.open(json, 'r')
          if f then
            local info = decodeJson(f:read('*a'))
            updatelink = info.updateurl
            updateversion = info.latest
            f:close()
            os.remove(json)
            if updateversion ~= thisScript().version then
              lua_thread.create(function(prefix)
                local dlstatus = require('moonloader').download_status
                local color = -1
                sampAddChatMessage((prefix..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion), color)
                wait(250)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('Загружено %d из %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('Загрузка обновления завершена.')
                      sampAddChatMessage((prefix..'Обновление завершено!'), color)
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        sampAddChatMessage((prefix..'Обновление прошло неудачно. Запускаю устаревшую версию..'), color)
                        update = false
                      end
                    end
                  end
                )
                end, prefix
              )
            else
              update = false
              print('v'..thisScript().version..': Обновление не требуется.')
            end
          end
        else
          print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..url)
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
end


    function FiollaTheme()


      imgui.SwitchContext()
  	local style  = imgui.GetStyle()
  	local colors = style.Colors
  	local clr    = imgui.Col
  	local ImVec4 = imgui.ImVec4
  	local ImVec2 = imgui.ImVec2

  	style.WindowPadding       = ImVec2(3, 5)
  	style.WindowRounding      = 12
  	style.ChildWindowRounding = 16
  	style.FramePadding        = ImVec2(10, 5)
  	style.FrameRounding       = 15
  	style.ItemSpacing         = ImVec2(13, 20)
  	style.TouchExtraPadding   = ImVec2(10, 10)
  	style.IndentSpacing       = 30
  	style.ScrollbarSize       = 9
  	style.ScrollbarRounding   = 16
  	style.GrabMinSize         = 1
  	style.GrabRounding        = 16
  	style.WindowTitleAlign    = ImVec2(0, 1)
  	style.ButtonTextAlign     = ImVec2(1, 1)

  	colors[clr.Text]                 = ImVec4(1.00, 1.00, 1.00, 1.00)
  	colors[clr.TextDisabled]         = ImVec4(0.73, 0.75, 0.74, 1.00)
  	colors[clr.WindowBg]             = ImVec4(0.00, 0.00, 0.00, 0.73)
  	colors[clr.ChildWindowBg]        = ImVec4(0.00, 0.00, 0.00, 0.00)
  	colors[clr.PopupBg]              = ImVec4(0.00, 0.00, 0.00, 0.94)
  	colors[clr.Border]               = ImVec4(0.20, 0.20, 0.20, 0.50)
  	colors[clr.BorderShadow]         = ImVec4(0.00, 0.00, 0.00, 0.00)
  	colors[clr.FrameBg]              = ImVec4(0.64, 0.00, 0.91, 0.54)
  	colors[clr.FrameBgHovered]       = ImVec4(0.84, 0.66, 0.66, 0.40)
  	colors[clr.FrameBgwa]        = ImVec4(0.64, 0.00, 0.91, 0.54)
  	colors[clr.TitleBg]              = ImVec4(0.64, 0.00, 0.91, 0.54)
  	colors[clr.TitleBgActive]        = ImVec4(0.00, 0.00, 0.00, 1.00)
  	colors[clr.TitleBgCollapsed]     = ImVec4(0.47, 0.22, 0.22, 0.67)
  	colors[clr.MenuBarBg]            = ImVec4(0.34, 0.16, 0.16, 1.00)
  	colors[clr.ScrollbarBg]          = ImVec4(0.02, 0.02, 0.02, 0.53)
  	colors[clr.ScrollbarGrab]        = ImVec4(0.31, 0.31, 0.31, 1.00)
  	colors[clr.ScrollbarGrabHovered] = ImVec4(0.41, 0.41, 0.41, 1.00)
  	colors[clr.ScrollbarGrabActive]  = ImVec4(0.51, 0.51, 0.51, 1.00)
  	colors[clr.ComboBg]              = ImVec4(0.20, 0.20, 0.20, 0.99)
  	colors[clr.CheckMark]            = ImVec4(1.00, 1.00, 1.00, 1.00)
  	colors[clr.SliderGrab]           = ImVec4(0.00, 0.00, 0.00, 0.54)
  	colors[clr.SliderGrabActive]     = ImVec4(0.84, 0.66, 0.66, 1.00)
  	colors[clr.Button]               = ImVec4(0.64, 0.00, 0.91, 0.54)
  	colors[clr.ButtonHovered]        = ImVec4(0.71, 0.39, 0.39, 0.65)
  	colors[clr.ButtonActive]         = ImVec4(0.20, 0.20, 0.20, 0.50)
  	colors[clr.Header]               = ImVec4(0.64, 0.00, 0.91, 0.78)
  	colors[clr.HeaderHovered]        = ImVec4(0.64, 0.00, 0.91, 0.50)
  	colors[clr.HeaderActive]         = ImVec4(0.64, 0.00, 0.91, 1.00)
  	colors[clr.Separator]            = ImVec4(0.64, 0.00, 0.91, 1.00)
  	colors[clr.SeparatorHovered]     = ImVec4(0.71, 0.39, 0.39, 0.54)
  	colors[clr.SeparatorActive]      = ImVec4(0.71, 0.39, 0.39, 0.54)
  	colors[clr.ResizeGrip]           = ImVec4(0.71, 0.39, 0.39, 0.54)
  	colors[clr.ResizeGripHovered]    = ImVec4(0.84, 0.66, 0.66, 0.66)
  	colors[clr.ResizeGripActive]     = ImVec4(0.84, 0.66, 0.66, 0.66)
  	colors[clr.CloseButton]          = ImVec4(0.64, 0.00, 0.91, 0.54)
  	colors[clr.CloseButtonHovered]   = ImVec4(1.00, 1.00, 1.00, 1.00)
  	colors[clr.CloseButtonActive]    = ImVec4(1.00, 0.05, 0.00, 1.00)
  	colors[clr.PlotLines]            = ImVec4(0.61, 0.61, 0.61, 1.00)
  	colors[clr.PlotLinesHovered]     = ImVec4(1.00, 0.43, 0.35, 1.00)
  	colors[clr.PlotHistogram]        = ImVec4(0.90, 0.70, 0.00, 1.00)
  	colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
  	colors[clr.TextSelectedBg]       = ImVec4(0.26, 0.59, 0.98, 0.35)
  	colors[clr.ModalWindowDarkening] = ImVec4(0.80, 0.80, 0.80, 0.35)


end
function RedTheme()
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

