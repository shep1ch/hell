--------------scirpt--------
script_name("Admin Tools")


local memory = require 'memory'
require"lib.sampfuncs"

local sampev = require 'lib.samp.events'
local imgui = require 'imgui'
local godmode = {state = false, BP = false, FP = false, EP = false, CP = false, MP = false, affectCar = false}

 -------прочее*---------

local spec_window = imgui.ImBool(false)
function sampev.onSendSpectatorSync()

        spec_window.v = true
end
 ------------прочее--------



-------------locals-------------
local tag = "{5301d8}[Admin Tools]{ffffff} : "

local dlstatus = require('moonloader').download_status
local author = "{e80505}Shepi"
local version = "{ea0be6}0.5"
local vkeys = require("vkeys")


local vk = require 'vkeys'
local inicfg = require "inicfg"
local speed = 0.2
selected_item = imgui.ImInt(0)
AirBrakeSpeed = imgui.ImFloat(2.0)
local samem = require 'SAMemory'
local Matrix3X3 = require "matrix3x3"
local ffi = require "ffi"
local getBonePosition = ffi.cast("int (__thiscall*)(void*, float*, int, bool)", 0x5E4280)
plates = {}
local window = imgui.ImBool(false)
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
MAX_DISTANCE = 8000
local textbloknot = imgui.ImBuffer(65536)
local slider = imgui.ImFloat(0)
local direct = 'moonloader\\MordorTools\\MrpAdminTools.ini'
local encoding = require "lib.encoding"
    require 'lib.moonloader'
    local fa = require 'faIcons'

stop = 0
started = 0
prinato = 0
active_report = 0
active_report2 = 0

local options = inicfg.main
local ImBuffer = imgui.ImBuffer
local ImFloat = imgui.ImFloat
local ImBool = imgui.ImBool
local Matrix3X3 = require "matrix3x3"
local Vector3D = require "vector3d"
key = require("vkeys")
ev = require("lib.samp.events")
local ntHack = imgui.ImBool(false)
local invis = imgui.ImBool(false)
local brake = imgui.ImBool(false)
local speedbuffer = imgui.ImBuffer(25)
local namebuffer = imgui.ImBuffer(25)
local CheckBox = imgui.ImBool(false)
local gmbox = imgui.ImBool(false)
local obnova_window_state = imgui.ImBool(false)
local note_window_state = imgui.ImBool(false)

local ImVec2 = imgui.ImVec2
encoding.default = 'CP1251'
u8 = encoding.UTF8
local moonimgui_text_buffer = imgui.ImBuffer(u8'/замена\\/команда', 256)

local admin_window_state = imgui.ImBool(false)



local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })

function imgui.BeforeDrawFrame()
    if fa_font == nil then
        local font_config = imgui.ImFontConfig() -- to use 'imgui.ImFontConfig.new()' on error
        font_config.MergeMode = true
        fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fontawesome-webfont.ttf', 14.0, font_config, fa_glyph_ranges)
    end
end

local ppc = {}
local scripts = false
local cars = 0
local hook = require 'lib.samp.events'
local state1 = false
local key = require 'vkeys'
-----------------locals-----------------
-------fly car-----------
function getMoveSpeed(heading, speed)
    moveSpeed = {x = math.sin(-math.rad(heading)) * (speed), y = math.cos(-math.rad(heading)) * (speed), z = 0.25}
    return moveSpeed
end
--------fly car-----------


----------ini---------------
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
}, "MRPAdminTools.ini")
inicfg.save(HLcfg, "MRPAdminTools.ini")
----------ini---------------


-- BOOL
--------------------------трейсера------------
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
local colorPlayerI = imgui.ImFloat4( imgui.ImColor( explode_argb(HLcfg.config.colorPlayerI) ):GetFloat4())
--------------------------трейсера------------




-----------------------------чекип сервера---------------
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

-----------------------------чекип сервера---------------




---------------/dl-------------------------

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

	if isKeyDown(71) and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() and not isSampfuncsConsoleActive() then
						while isKeyDown(71) do wait(0) end
				if(active_report == 2) then
						  sampSendChat("/"..cmd.." "..paramssss)
									status("true", 1)
						  sampSendChat("/a [Forma] +")
								active_report2 = 1
				end
					end

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


---------------/dl-------------------------




------------прочее------------

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

function sampev.onSendOnfootSync(data)
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

-------------прочее------------


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




------------------------ini-------------------




-------------clickwarp-------------
function initializeRender()
  font = renderCreateFont("Tahoma", 10, FCR_BOLD + FCR_BORDER)
  font2 = renderCreateFont("Arial", 8, FCR_ITALICS + FCR_BORDER)
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
        return i + 1
      end
    end
    return nil -- no free seats
  else
    return 0 -- driver seat
  end
end

function jumpIntoCar(car)
  local seat = getCarFreeSeat(car)
  if not seat then return false end                         -- no free seats
  if seat == 0 then warpCharIntoCar(playerPed, car)         -- driver seat
  else warpCharIntoCarAsPassenger(playerPed, car, seat - 1) -- passenger seat
  end
  restoreCameraJumpcut()
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

-------------clickwarp-------------

function loadSettings()
    local date = os.date('*t')
    local dir = getWorkingDirectory() .. '/MordorTools/AdminToolsMRP'

end


------------------------------main-----------------

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end

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

--
--     _   _   _ _____ ___  _   _ ____  ____    _  _____ _____
--    / \ | | | |_   _/ _ \| | | |  _ \|  _ \  / \|_   _| ____|
--   / _ \| | | | | || | | | | | | |_) | | | |/ _ \ | | |  _|
--  / ___ \ |_| | | || |_| | |_| |  __/| |_| / ___ \| | | |___
-- /_/   \_\___/  |_| \___/ \___/|_|   |____/_/   \_\_| |_____|
--
--
--



DarkTheme() -----------тема имгуи
 wait(5000) --------------задержка
sampAddChatMessage(tag .. "загружен!", -1)
sampAddChatMessage(tag .. "Автор скрипта: " .. author , -1)
sampAddChatMessage(tag .. "Информация о скрипте - {e40808}'/amenu' {ffffff} либо ввести на клавиатуре как чит-код {e40808} 'CM'", -1)
sampAddChatMessage(tag .. "Актуальная версия тулса - " .. version, -1)
sampRegisterChatCommand("amenu", cmd_adminimgui)




imgui.Process = admin_window_state.v or obnova_window_state.v or window.v or spec_window.v



    -----------------------------------бесконечный цикл----------------------------

  while true do
      wait(0)
	  ---------invis------------


			-----------invis----------------
	  ------------------fly car--------------
	  if not scripts and isKeyDown(VK_1) and isKeyJustPressed(VK_2) and isCharInAnyCar(PLAYER_PED) and not sampIsChatInputActive() and not sampIsDialogActive() then
            sampAddChatMessage(tag .. ' [{00DD00}FlyCar{FFFFFF}] - {FFC000}Активирован', -1)
            scripts = not scripts
            ppc = {}
        elseif scripts and isKeyJustPressed(VK_3) and isCharInAnyCar(PLAYER_PED) and not sampIsChatInputActive() and not sampIsDialogActive() then
            sampAddChatMessage(tag .. ' [{00DD00}FlyCar{FFFFFF}] - {FFC000}Де-активирован', -1)
            cars = 0
            scripts = not scripts
            ppc = {}
        end
        if scripts and isCharInAnyCar(PLAYER_PED) then
            local veh = getCarCharIsUsing(PLAYER_PED)
            if getDriverOfCar(veh) == -1 then pcall(sampForcePassengerSyncSeatId, ppc[1], ppc[2]) pcall(sampForceUnoccupiedSyncSeatId, ppc[1], ppc[2]) else pcall(sampForceVehicleSync, ppc[1]) end
            local speed = getCarSpeed(veh)
            setCarHeavy(veh, false)
            setCarProofs(veh,true,true,true,true,true)
            local var_1, var_2, var_3, var_4 = getPositionOfAnalogueSticks(0)
            local var_1 = var_1 / -64.0
            local var_2 = var_2 / 64.0
            setCarRotationVelocity(veh, var_2, 0.0, var_1)
            if isKeyDown(VK_W) then
                if speed <= 200.0 then
                    cars = cars + 0.4
                end
            elseif isKeyDown(VK_S) then
                if cars >= 0.0 then
                    cars = cars - 0.3
                else
                    cars = 0.0
                end
            end
            if isKeyDown(VK_S) and isKeyDown(VK_SPACE) then
                cars = 0
                setCarRotationVelocity(veh, 0.0, 0.0, 0,0)
                setCarRoll(veh, 0.0)
            end
            setCarForwardSpeed(veh,cars)

        elseif not isCharInAnyCar(PLAYER_PED) and scripts then
            sampAddChatMessage(tag .. ' [{00DD00}FlyCar{FFFFFF}] - {FFC000}Де-активирован', -1)
            scripts = not scripts
            ppc = {}
        end
		--------------------fly car--------------------

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
--
--     _   _   _ _____ ___  _   _ ____  ____    _  _____ _____
--    / \ | | | |_   _/ _ \| | | |  _ \|  _ \  / \|_   _| ____|
--   / _ \| | | | | || | | | | | | |_) | | | |/ _ \ | | |  _|
--  / ___ \ |_| | | || |_| | |_| |  __/| |_| / ___ \| | | |___
-- /_/   \_\___/  |_| \___/ \___/|_|   |____/_/   \_\_| |_____|
--
--
--



   while isPauseMenuActive() do
      if cursorEnabled then
        showCursor(false)
      end
      wait(100)
    end

    if isKeyDown(keyToggle) then
      cursorEnabled = not cursorEnabled
      showCursor(cursorEnabled)
      while isKeyDown(keyToggle) do wait(80) end
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
                end
                renderFontDrawText(font2, "Hold right mouse button to teleport into the car", sx, sy - hoffs * 3, color)
              end
            end

            createPointMarker(pos.x, pos.y, pos.z)

            -- teleport!
            if isKeyDown(keyApply) then
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

              while isKeyDown(keyApply) do wait(0) end
              showCursor(false)
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

--------------gm ----------------

-------------------- gm --------------

        if not admin_window_state.v and not obnova_window_state.v and not spec_window.v and not window.v then imgui.Process = false end

        end
		end

------------------------------main-----------------



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






        function imgui.OnDrawFrame()
		if admin_window_state.v then

                imgui.SetNextWindowPos(imgui.ImVec2(19, 325 ), imgui.Cond.FirstUseEver)
                imgui.SetNextWindowSize(imgui.ImVec2(950, 550), imgui.Cond.FirstUseEver)
                imgui.Begin(fa.ICON_USER_O .. " Admin Tools for Mordor RP | by shepi", admin_window_state, imgui.WindowFlags.NoResize)
                imgui.BeginChild('##121', imgui.ImVec2(320, 500), true)
                if imgui.Button(u8'Основное меню', imgui.ImVec2(250, 25), admin_window_state) then menu = 1 end

                if imgui.Button(u8'Настройки', imgui.ImVec2(250, 25), admin_window_state) then menu = 2 end

                if imgui.Button(u8'Заметки', imgui.ImVec2(250, 25), admin_window_state) then menu =  1 end

                if imgui.Button(u8"Читы", imgui.ImVec2(250, 25), admin_window_state) then menu = 4 end

                if imgui.Button(u8"Все функции в скрипте", imgui.ImVec2(250, 25), admin_window_state) then menu = 5 end

				if imgui.Button(u8"Трейсера пуль", imgui.ImVec2(250, 25), admin_window_state) then
				admin_window_state.v = false
				window.v = true end

                imgui.EndChild()




              if menu == 1 then
			  imgui.SameLine()
imgui.BeginChild("85dfss", imgui.ImVec2(720, 500), false)

                imgui.Text(u8"Вас приветствует админ тулс.\nКнопки переключения менюшек находятся слева.\nПриятного пользования ^-^")

				imgui.EndChild()
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
			  imgui.SameLine()
			  imgui.BeginChild(" cum ", imgui.ImVec2(700, 500), false)


                 if imgui.Checkbox(u8'WallHack',ntHack)
			then
				ntHack.v = ntHack.v
				if ntHack.v then nameTagOn() else nameTagOff() end

		end
		imgui.SameLine()
		if imgui.Checkbox(u8'Godmode',gmbox) then
			setCharProofs = not  setCharProofs
		end






		imgui.SliderFloat(u8'Airbrake',AirBrakeSpeed,0.00,40.00, '%.2f', 0.2)
		imgui.Text(u8"      FlyCar") imgui.TextQuestion(u8"Активация:\n[1+2] - Взлёт\n[3] - Посадка ")
		imgui.EndChild()












      end
              if menu == 5 then


                imgui.Text(u8"/amenu - Данный диалог\n'X' - активировать модифицированный /dl\n'CTRL' - AirBrake\n'На клавиатуре - CM' - Тоже самое что и /amenu\n'Кликварп:\nНажать на колёсико мыши, далее навести курсор н анужное вам место..\n..и нажать левую кнопку мыши\nТП В КАР пи помощи кликварпа:\nОпять-же, колесико мыши, наводитесь на машину и...\n..зажимаете правую кнопку мыши и нажмаете левую\nВкратце про кликварп:\nПри открытии данного окна, по умолчанию кликварп включен и вы можете тпшнуться\nПо поводу метки мигающей, я сделал её мигающей, думаю, что так будет лучше'" )
				imgui.Separator()
				if imgui.Button(u8"Инфо о обновлениях") then
				obnova_window_state.v = true
				end


              end



                 imgui.End()
              end

				 if window.v then
        imgui.ShowCursor = true
        imgui.SetNextWindowPos(imgui.ImVec2(1041, 89), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
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
        imgui.End()
    end
	if spec_window.v then



			     imgui.SetNextWindowSize(imgui.ImVec2(250, 250), imgui.Cond.FirstUseEver)
   imgui.SetNextWindowPos(imgui.ImVec2(1271, 639), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
                imgui.Begin(u8"", spec_window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoBringToFrontOnFocus + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoSavedSettings)
                local nick = sampGetPlayerNickname(id)
                local hp = sampGetPlayerHealth(id)
                local ping = sampGetPlayerPing(id)
                local score = sampGetPlayerScore(id)

        imgui.Text(..nick..)
				imgui.Columns(2, "Columns", true)
				imgui.Text(u8"Уровень - ")

				imgui.NextColumn()
        imgui.Text(..score..)
				imgui.Separator()
        imgui.NextColumn()
				imgui.Text(u8"Здоровье -")
				imgui.NextColumn()
        imgui.Text(..hp..)
				imgui.Separator()
        imgui.NextColumn()
				imgui.Text(u8"Пинг - ")
				imgui.NextColumn()
        imgui.Text(..ping..)




				imgui.Columns(1)
				imgui.Separator()


	imgui.End()
	end
			  if obnova_window_state.v then

        imgui.SetNextWindowPos(imgui.ImVec2(1032, 344), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(500, 250), imgui.Cond.FirstUseEver)
                imgui.Begin(fa.ICON_USER_O .. u8" Информация о  обновлениях", obnova_window_state, imgui.WindowFlags.NoResize)
				imgui.Text(u8"Да")
				if imgui.Button("a") then
				spec_window.v = true
				end
				imgui.End()
				end
				end

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
 ---------------invis------------

-------------invis----------------


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

	function spec_style()
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
      colors[clr.TitleBgActive]          = ImVec4(0.00, 0.00, 0.00, 0.00);
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
----------------------fly car--------------------
function sampev.onSendPassengerSync(data)
    if scripts then
        ppc = {data.vehicleId, data.seatId}
    end
end

function sampev.onSendUnoccupiedSync(data)
    if scripts then
        local _, veh = sampGetCarHandleBySampVehicleId(data.vehicleId)
        local heading = getCarHeading(veh)
        data.moveSpeed = getMoveSpeed(heading, 0.200)
        return data
    end
end

function sampev.onSendVehicleSync(data)
    if scripts then
        ppc = {data.vehicleId}
        local _, veh = sampGetCarHandleBySampVehicleId(data.vehicleId)
        local heading = getCarHeading(veh)
        data.moveSpeed = getMoveSpeed(heading, 1.250)
        return data
    end
end
--------------------fly car-----------


function sampev.onServerMessage(color, text)

local reasons = {'kick','mute','ban','prison','jail','msg','offban','offwarn','warn','offprison','offmute','offunmute','spawn','banip','slap','sethp','agun','freeze','unfreeze',
"goto","sp","stats","tempskin","getip","veh","pm","onick","fuelvehs","respallv","alldelv","setmark","auninvite","re","respv","chip","ar","gethere"}

for k,v in ipairs(reasons) do
	if text:match("%[.*%] (%w+_?%w+)%[(%d+)%]%: /"..v.."%s") then
		started = started + 1
			if started < 2 then
		prikoll = "true"
		admin_nick, admin_id, other = text:match("%[.+%] (%w+_?%w+)%[(%d+)%]%: /"..v.."%s(.*)")
			cmd = v
			paramssss = other
			if stop == 0 then
			lua_thread.create(function()
			for i = 0, 5 do
				if active_report2 == 0 then
				status("false", i)
				else
				status("true", i)
				end
				end
				if prikoll == "true" then
				wait(550)
				printStyledString("You missed form", 1000, 5)
			active_report = 1
			active_report2 = 0
			started = 0
			bbstart = -1
			end
			end)
			end
			end
			end
end
end

function status(parsasm, ggbc)
	if parsasm == "true" then
	active_report2 = 1
	prikoll = "false"
		if ggbc == 5 then
		active_report2 = 0
		started = 0
		end
		active_report = 1
		printStyledString("Admin form accepted", 5000, 5)
		bbstart = -1
	else
	bbstart = -1
	bbstart = bbstart + ggbc
	if bbstart == 0 then
	active_report = 2
	end
		if active_report2 == 0 then
		wait(1000)
		printStyledString('Admin form '..ggbc.." wait", 1000, 5)
		end
	end
end

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
        return i + 1
      end
    end
    return nil -- no free seats
  else
    return 0 -- driver seat
  end
end

function jumpIntoCar(car)
  local seat = getCarFreeSeat(car)
  if not seat then return false end                         -- no free seats
  if seat == 0 then warpCharIntoCar(playerPed, car)         -- driver seat
  else warpCharIntoCarAsPassenger(playerPed, car, seat - 1) -- passenger seat
  end
  restoreCameraJumpcut()
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
