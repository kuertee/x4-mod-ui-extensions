local ffi = require ("ffi")
local C = ffi.C
local Lib = require ("extensions.sn_mod_support_apis.lua_library")
local topLevelMenu
local newFuncs = {}
local kHUD = {}
local function init ()
	DebugError ("kuertee_hud.init")
	topLevelMenu = Lib.Get_Egosoft_Menu ("TopLevelMenu")
	topLevelMenu.registerCallback ("createInfoFrame_on_before_frame_display", newFuncs.createInfoFrame_on_before_frame_display)
	topLevelMenu.addTable = newFuncs.addTable
	topLevelMenu.removeTable = newFuncs.removeTable
end
function newFuncs.createInfoFrame_on_before_frame_display (frame)
	DebugError ("kuertee_hud.newFuncs.createInfoFrame_on_before_frame_display frame " .. tostring (frame))
	if not topLevelMenu.showTabs then
		kHUD.createTables (frame)
	end
end
function kHUD.createTables (frame)
	-- DebugError ("kuertee_hud.kHUD.createTables frame " .. tostring (frame))
	-- set frame properties
	frame.properties.width = Helper.viewWidth
	frame.properties.x = 0
	local yBottom = 0
	-- get top level arrows
	local ftable
	local topLevelArrowsTable
	for i = 1, #frame.content do
		if frame.content [i].type == "table" then
			topLevelArrowsTable = frame.content [i]
			break
		end
	end
	topLevelArrowsTable.properties.x = frame.properties.width / 2 - topLevelMenu.width / 2
	yBottom = topLevelArrowsTable.properties.y + topLevelArrowsTable:getFullHeight ()
	-- Lib.Print_Table (topLevelArrowsTable)
	-- create new HUDs
	local lastTableYBottom
	if true then
		-- create kHUD label table
		ftable = frame:addTable (
			1,
			{
				width = 100,
				height = 100,
				x = 0,
				y = 0,
				scaling = true
			}
		)
		local row = ftable:addRow (false, {bgColor = Helper.color.transparent60})
		row [1]:createText ("kHUD", {halign = "center", color = Helper.standardColor})
		lastTableYBottom = ftable.properties.y + ftable:getFullHeight ()
		if lastTableYBottom > yBottom then
			yBottom = lastTableYBottom
		end
	end
	if topLevelMenu.callbacks ["kHUD_create_HUD_table"] then
		for _, callback in ipairs (topLevelMenu.callbacks ["kHUD_create_new_HUD_table"]) do
			ftable = callback (frame)
			lastTableYBottom = ftable.properties.y + ftable:getFullHeight ()
			if lastTableYBottom > yBottom then
				yBottom = lastTableYBottom
			end
		end
	end
	frame.properties.height = yBottom + Helper.borderSize
end
init ()
