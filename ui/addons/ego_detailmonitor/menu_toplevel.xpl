-- ffi setup
local ffi = require("ffi")
local C = ffi.C
ffi.cdef[[
	void SetTrackedMenuFullscreen(const char* menu, bool fullscreen);
]]

local menu = {
	name = "TopLevelMenu",
	mouseOutBox = {},
}

local config = {
	width = Helper.sidebarWidth,
	height = Helper.sidebarWidth,
	offsetY = 0,
	layer = 2,
	mouseOutRange = 100,
}

-- kuertee start:
menu.callbacks = {}
-- end

local function init()
	Menus = Menus or { }
	table.insert(Menus, menu)
	if Helper then
		Helper.registerMenu(menu)
	end

	menu.init = true
	registerForEvent("gameplanchange", getElement("Scene.UIContract"), menu.onGamePlanChange)
	RegisterEvent("playerUndocked", menu.playerUndocked)

	-- kuertee start:
	menu.init_kuertee()
	kHUD.init()
	-- kuertee end
end

-- kuertee start:
function menu.init_kuertee ()
	menu.loadModLuas()
	-- if Helper.modLuas[menu.name] then
	-- 	if not next(Helper.modLuas[menu.name].failedByExtension) then
	-- 		DebugError("uix init success: " .. tostring(debug.getinfo(1).source))
	-- 	else
	-- 		for extension, modLua in pairs(Helper.modLuas[menu.name].failedByExtension) do
	-- 			DebugError("uix init failed: " .. tostring(debug.getinfo(modLua.init).source):gsub("@.\\", ""))
	-- 		end
	-- 	end
	-- else
		DebugError("uix load success: " .. tostring(debug.getinfo(1).source))
	-- end
end
-- kuertee end

function menu.onGamePlanChange(_, mode)
	if menu.init then
		if (mode == "cockpit") or (mode == "external") then
			local occupiedship = ConvertStringTo64Bit(tostring(C.GetPlayerOccupiedShipID()))
			if (occupiedship ~= 0) and (not GetComponentData(occupiedship, "isdocked")) then
				OpenMenu("TopLevelMenu", { 0, 0 }, nil)
			end
			menu.init = nil
		elseif (mode == "firstperson") or (mode == "externalfirstperson") then
			menu.init = nil
		end
	else
		if (mode == "firstperson") or (mode == "externalfirstperson") then
			if menu.shown then
				menu.close()
			end
		end
	end
end

function menu.playerUndocked()
	local occupiedship = ConvertStringTo64Bit(tostring(C.GetPlayerOccupiedShipID()))
	if (occupiedship ~= 0) and (not GetComponentData(occupiedship, "isdocked")) then
		OpenMenu("TopLevelMenu", { 0, 0 }, nil)
	end
end

function menu.cleanup()
	menu.infoFrame = nil

	menu.showTabs = nil
	menu.over = nil
	menu.mouseOutBox = {}

	if menu.hasRegistered then
		unregisterForEvent("inputModeChanged", getElement("Scene.UIContract"), menu.onInputModeChanged)
		menu.hasRegistered = nil
	end

	-- kuertee custom HUD start:
	kHUD.cleanUp()
	-- kuertee custom HUD end
end

function menu.buttonShowTopLevel()
	menu.showTabs = true
	menu.refresh = getElapsedTime()
end

-- Menu member functions

function menu.onShowMenu()
	C.SetTrackedMenuFullscreen(menu.name, false)
	menu.width = Helper.scaleX(config.width)
	menu.height = Helper.scaleX(config.height)

	-- display info
	menu.createInfoFrame()
end

function menu.createInfoFrame()
	-- remove old data
	Helper.clearDataForRefresh(menu, config.infoLayer)

	local frameProperties = {
		standardButtons = {},
		width = menu.width + 2 * Helper.borderSize,
		x = (Helper.viewWidth - menu.width) / 2,
		y = Helper.scaleY(config.offsetY),
		layer = config.layer,
		startAnimation = false,
		playerControls = true,
		useMiniWidgetSystem = (not menu.showTabs) and (not menu.over),
		enableDefaultInteractions = false,
	}

	menu.infoFrame = Helper.createFrameHandle(menu, frameProperties)

	local tableProperties = {
		width = menu.width,
		x = Helper.borderSize,
		y = Helper.borderSize,
	}
	
	if menu.showTabs then
		if not menu.hasRegistered then
			menu.hasRegistered = true
			Helper.setTabScrollCallback(menu, menu.onTabScroll)
			registerForEvent("inputModeChanged", getElement("Scene.UIContract"), menu.onInputModeChanged)
		end

		menu.infoFrame.properties.width = Helper.viewWidth
		menu.infoFrame.properties.x = 0
		menu.topLevelHeight, menu.topLevelWidth = Helper.createTopLevelTab(menu, "", menu.infoFrame, "", nil, nil, true)
		menu.infoFrame.properties.height = menu.topLevelHeight + Helper.borderSize

		menu.mouseOutBox = {
			x1 = - menu.topLevelWidth / 2                    - config.mouseOutRange,
			x2 =   menu.topLevelWidth / 2                    + config.mouseOutRange,
			y1 = Helper.viewHeight / 2,
			y2 = Helper.viewHeight / 2 - menu.topLevelHeight - config.mouseOutRange
		}
	else
		if menu.hasRegistered then
			Helper.removeAllTabScrollCallbacks(menu)
			unregisterForEvent("inputModeChanged", getElement("Scene.UIContract"), menu.onInputModeChanged)
			menu.hasRegistered = nil
		end
		local ftable = menu.createTable(menu.infoFrame, tableProperties)
		menu.infoFrame.properties.height = ftable.properties.y + ftable:getVisibleHeight() + Helper.borderSize

		-- kuertee start: callback
		if menu.callbacks ["createInfoFrame_on_before_frame_display"] then
			for _, callback in ipairs (menu.callbacks ["createInfoFrame_on_before_frame_display"]) do
				callback (menu.infoFrame)
			end
		end
		-- kuertee end: callback

	end


	-- kuertee customHUD: start
	if kHUD and kHUD.frame then
		kHUD.frame:display()
	end
	-- kuertee customHUD: end

	menu.infoFrame:display()
end

function menu.createTable(frame, tableProperties)
	local ftable = frame:addTable(1, { tabOrder = menu.over and 1 or 0, width = tableProperties.width, x = tableProperties.x, y = tableProperties.y })

	if menu.over then
		local row = ftable:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
		row[1]:createButton({ width = config.width, height = config.height, bgColor = Helper.color.transparent, highlightColor = Helper.color.transparent }):setText("\27[tlt_arrow]", { color = { r = 128, g = 196, b = 255, a = 100 }, halign = "center", fontsize = 18, x = 0, y = 5 })
		row[1].handlers.onClick = menu.buttonShowTopLevel
	else
		local row = ftable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
		row[1]:createText("\27[tlt_arrow]", { width = config.width, height = config.height, color = { r = 64, g = 98, b = 128, a = 100 }, halign = "center", fontsize = 18, x = 0, y = 0 })
	end

	return ftable
end

function menu.onTabScroll(direction)
	Helper.scrollTopLevel(menu, "playerinfo", 1)
end

function menu.onInputModeChanged(_, mode)
	menu.createInfoFrame()
end

function menu.viewCreated(layer, ...)
end

-- update
menu.updateInterval = 0.1

function menu.onUpdate()
	if menu.showTabs and next(menu.mouseOutBox) then
		if (GetControllerInfo() ~= "gamepad") or (C.IsMouseEmulationActive()) then
			local curpos = table.pack(GetLocalMousePosition())
			if curpos[1] and ((curpos[1] < menu.mouseOutBox.x1) or (curpos[1] > menu.mouseOutBox.x2)) then
				menu.closeTabs()
			elseif curpos[2] and ((curpos[2] > menu.mouseOutBox.y1) or (curpos[2] < menu.mouseOutBox.y2)) then
				menu.closeTabs()
			end
		end
	end

	local curtime = getElapsedTime()

	-- kuertee start: callback
	if menu.callbacks ["onUpdate_start"] then
		for _, callback in ipairs (menu.callbacks ["onUpdate_start"]) do
			callback(curtime)
		end
	end
	-- kuertee end: callback

	if menu.lock and (menu.lock + 0.11 < curtime) then
		menu.lock = nil
	end

	if menu.over and (not menu.lock) then
		if (GetControllerInfo() ~= "gamepad") or (C.IsMouseEmulationActive()) then
			local mouseOutBox = {
				x1 = - menu.width / 2,
				x2 =   menu.width / 2,
				y1 = Helper.viewHeight / 2,
				y2 = Helper.viewHeight / 2 - menu.infoFrame.properties.height,
			}

			local curpos = table.pack(GetLocalMousePosition())
			if curpos[1] and ((curpos[1] < mouseOutBox.x1) or (curpos[1] > mouseOutBox.x2)) then
				menu.over = false
				menu.lock = getElapsedTime()
				menu.createInfoFrame()
				return
			elseif curpos[2] and ((curpos[2] > mouseOutBox.y1) or (curpos[2] < mouseOutBox.y2)) then
				menu.over = false
				menu.lock = getElapsedTime()
				menu.createInfoFrame()
				return
			end
		end
	end

	if menu.refresh and menu.refresh <= curtime then
		menu.createInfoFrame()
		menu.refresh = nil

		-- kuertee start: callback
		if menu.callbacks ["createInfoFrame_onUpdate_before_frame_update"] then
			for _, callback in ipairs (menu.callbacks ["createInfoFrame_onUpdate_before_frame_update"]) do
				callback (menu.infoFrame)
			end
		end
		-- kuertee end: callback

		return
	end

	-- kuertee customHUD: start
	if kHUD.frame and kHUD.frame.content and #kHUD.frame.content > 0 then
		-- Helper.debugText_forced("#kHUD.frame.content", tostring(#kHUD.frame.content))
		kHUD.frame:update()
	end
	-- kuertee customHUD: end

	menu.infoFrame:update()
end

function menu.onTableMouseOut(uitable, row)
	if (not menu.showTabs) and (not menu.lock) then
		menu.over = false
		menu.lock = getElapsedTime()
		menu.createInfoFrame()
	end
end

function menu.onTableMouseOver(uitable, row)
	if (not menu.showTabs) and (not menu.lock) then
		menu.over = true
		menu.lock = getElapsedTime()
		menu.createInfoFrame()
	end
end

function menu.onRowChanged(row, rowdata, uitable)
end

function menu.onSelectElement(uitable, modified, row)
end

function menu.close()
	Helper.closeMenu(menu, "close")
	menu.cleanup()
end

function menu.closeTabs()
	menu.showTabs = nil
	menu.over = nil
	menu.lock = getElapsedTime()
	menu.refresh = getElapsedTime()
end

function menu.onCloseElement(dueToClose, layer)
	if menu.showTabs then
		menu.closeTabs()
	elseif layer == nil then
		Helper.closeMenu(menu, dueToClose)
		menu.cleanup()
	else
		Helper.closeMenuAndOpenNewMenu(menu, "OptionsMenu", nil)
		menu.cleanup()
	end
end

-- menu helpers

-- kuertee custom HUD start:
kHUD = {
	frame = nil,
	layer = 4,
}
function kHUD.init()
	menu.registerCallback ("createInfoFrame_on_before_frame_display", kHUD.createTables)
end

function kHUD.cleanUp()
	kHUD.frame = nil
end

function kHUD.createFrame()
	Helper.clearDataForRefresh(kHUD, kHUD.layer)
	local frameProperties = {
		x = 0,
		y = 0,
		width = Helper.viewWidth,
		height = Helper.viewHeight,
		layer = kHUD.layer,
		backgroundColor = Helper.color.red,
		standardButtons = {},
		startAnimation = false,
		playerControls = true,
		useMiniWidgetSystem = true,
		enableDefaultInteractions = false,
	}
	kHUD.frame = Helper.createFrameHandle(kHUD, frameProperties)
	Helper.debugText_forced("kHUD.frame", tostring(kHUD.frame))
end

function kHUD.createTables()
	if not menu.showTabs then
		if menu.callbacks then
			Helper.debugText_forced("menu.callbacks['kHUD_add_HUD_tables']", tostring(menu.callbacks["kHUD_add_HUD_tables"]))
		end
		if menu.callbacks and menu.callbacks["kHUD_add_HUD_tables"] then
			Helper.debugText_forced("#menu.callbacks['kHUD_add_HUD_tables']", tostring(#menu.callbacks["kHUD_add_HUD_tables"]))
			if not kHUD.frame then
				kHUD.createFrame()
			end
			for i, callback in ipairs (menu.callbacks ["kHUD_add_HUD_tables"]) do
				callback (kHUD.frame)
			end
			kHUD.updateFrameHeight()
		end
	end
end

function kHUD.updateFrameHeight ()
	local yBottomMax = 0
	local yBottomFTable = 0
	local ftable
	kHUD.frame.properties.y = menu.infoFrame.properties.height
	Helper.debugText_forced("kHUD.frame.properties.y", kHUD.frame.properties.y)
	for i = 1, #kHUD.frame.content do
		if kHUD.frame.content [i].type == "table" then
			ftable = kHUD.frame.content [i]
			local visibleHeight = ftable:getVisibleHeight ()
			-- debug start
			if visibleHeight < 100 then
				visibleHeight = 100
			end
			-- debug end
			yBottomFTable = ftable.properties.y + visibleHeight
			if yBottomFTable > yBottomMax then
				yBottomMax = yBottomFTable
			end
		end
	end
	local frameHeight = yBottomMax - kHUD.frame.properties.y
	Helper.debugText_forced("frameHeight", frameHeight)
	if kHUD.frame.properties.height ~= frameHeight then
		kHUD.frame.properties.height = frameHeight
	end
end
-- kuertee custom HUD end

-- kuertee start:
function menu.requestUpdate (adj)
	if adj == nil then
		adj = 0
	end
	if menu.refresh == nil then
		menu.refresh = getElapsedTime () + adj
	end
end

function menu.registerCallback (callbackName, callbackFunction)
	-- note 1: format is generally [function name]_[action]. e.g.: in kuertee_menu_transporter, "display_on_set_room_active" overrides the room's active property with the return of the callback.
	-- note 2: events have the word "_on_" followed by a PRESET TENSE verb. e.g.: in kuertee_menu_transporter, "display_on_set_buttontable" is called after all of the rows of buttontable are set.
	-- note 3: new callbacks can be added or existing callbacks can be edited. but commit your additions/changes to the mod's GIT repository.
	-- note 4: search for the callback names to see where they are executed.
	-- note 5: if a callback requires a return value, return it in an object var. e.g. "display_on_set_room_active" requires a return of {active = true | false}.

	-- to find callbacks available for this menu,
	-- reg-ex search for callbacks.*\[\".*\]

	if menu.callbacks [callbackName] == nil then
		menu.callbacks [callbackName] = {}
	end
	table.insert (menu.callbacks [callbackName], callbackFunction)
end

function menu.deregisterCallback(callbackName, callbackFunction)
	-- for i, callback in ipairs(callbacks[callbackName]) do
	if callbacks[callbackName] and #callbacks[callbackName] > 0 then
		for i = #callbacks[callbackName], 1, -1 do
			if callbacks[callbackName][1] == callbackFunction then
				table.remove(callbacks[callbackName], i)
			end
		end
	end
end

function menu.loadModLuas()
	if Helper then
		Helper.loadModLuas(menu.name, "menu_toplevel_uix")
	end
end
-- kuertee end

init()
