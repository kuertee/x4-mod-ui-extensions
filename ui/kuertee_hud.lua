local ffi = require ("ffi")
local C = ffi.C
local Lib = require ("extensions.sn_mod_support_apis.lua_library")
local topLevelMenu
local newFuncs = {}
local kHUD = {}
local isInited
local function init ()
	DebugError ("kuertee_hud.init isInited")
	if not isInited then
		isInited = true
		topLevelMenu = Lib.Get_Egosoft_Menu ("TopLevelMenu")
		topLevelMenu.registerCallback ("createInfoFrame_on_before_frame_display", newFuncs.createInfoFrame_on_before_frame_display)
		topLevelMenu.registerCallback ("createInfoFrame_onUpdate_before_frame_update", newFuncs.createInfoFrame_onUpdate_before_frame_update)
	end
end
function newFuncs.createInfoFrame_on_before_frame_display (frame)
	if not topLevelMenu.showTabs then
		kHUD.createTables (frame)
	end
end
function newFuncs.createInfoFrame_onUpdate_before_frame_update (frame)
	if not topLevelMenu.showTabs then
		if topLevelMenu.callbacks ["kHUD_update_HUD_tables"] then
			local result = {ftables = {}}
			for _, callback in ipairs (topLevelMenu.callbacks ["kHUD_update_HUD_tables"]) do
				callback (frame)
			end
		end
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
	if false then
		-- create kHUD label table for test purposes
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
	end
	if topLevelMenu.callbacks ["kHUD_add_HUD_tables"] then
		for _, callback in ipairs (topLevelMenu.callbacks ["kHUD_add_HUD_tables"]) do
			callback (frame)
		end
	end
end
init ()
