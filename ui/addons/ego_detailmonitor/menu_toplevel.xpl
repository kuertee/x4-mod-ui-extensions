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
menu.uix_callbacks = {}
function menu.uix_get_config() return config end
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

	-- kuertee start: callback
	if menu.uix_callbacks ["cleanup"] then
		for uix_id, uix_callback in pairs (menu.uix_callbacks ["cleanup"]) do
			uix_callback()
		end
	end
	-- kuertee end: callback
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

	-- kuertee custom HUD start:
	local isShowCustomHUD = kHUD.getIsOpenOrClose()
	-- kuertee custom HUD end

	local frameProperties = {
		standardButtons = {},
		width = menu.width + 2 * Helper.borderSize,
		x = (Helper.viewWidth - menu.width - 2 * Helper.borderSize) / 2,
		y = Helper.scaleY(config.offsetY),
		layer = config.layer,
		startAnimation = false,
		playerControls = true,
		-- kuertee custom HUD start:
		-- useMiniWidgetSystem = (not menu.showTabs) and (not menu.over),
		useMiniWidgetSystem = (not menu.showTabs) and (not menu.over) and (not isShowCustomHUD),
		-- kuertee custom HUD end

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

		-- kuertee custom HUD start:
		menu.infoFrame.properties.width = Helper.viewWidth
		menu.infoFrame.properties.x = 0
		ftable.properties.x = menu.infoFrame.properties.width / 2 - ftable.properties.width / 2
		-- menu.infoFrame.properties.height = ftable.properties.y + ftable:getVisibleHeight() + Helper.borderSize
		-- kuertee custom HUD end

		-- kuertee start: callback
		if menu.uix_callbacks ["createInfoFrame_on_add_table"] then
			for uix_id, uix_callback in pairs (menu.uix_callbacks ["createInfoFrame_on_add_table"]) do
				uix_callback (menu.infoFrame, ftable)
			end
		end
		-- kuertee end: callback

		-- kuertee start: callback
		if menu.uix_callbacks ["createInfoFrame_on_before_frame_display"] then
			for uix_id, uix_callback in pairs (menu.uix_callbacks ["createInfoFrame_on_before_frame_display"]) do
				uix_callback (menu.infoFrame)
			end
		end
		-- kuertee end: callback
	end

	menu.infoFrame:display()
end

function menu.createTable(frame, tableProperties)
	local ftable = frame:addTable(1, { tabOrder = menu.over and 1 or 0, width = tableProperties.width, x = tableProperties.x, y = tableProperties.y })

	if menu.over then
		local row = ftable:addRow(true, { fixed = true })
		row[1]:createButton({ width = config.width, height = config.height - 10, bgColor = Color["button_background_hidden"], highlightColor = Color["button_highlight_hidden"] }):setText("\27[tlt_arrow]", { color = Color["toplevel_arrow"], halign = "center", fontsize = Helper.scaleFont(Helper.standardFont, 18), x = 0, y = 2, scaling = false })
		row[1].handlers.onClick = menu.buttonShowTopLevel
	else
		local row = ftable:addRow(false, { fixed = true })
		row[1]:createText("\27[tlt_arrow]", { width = config.width, height = config.height, color = Color["toplevel_arrow_inactive"], halign = "center", fontsize = 18, x = 0, y = 0 })
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
	if menu.uix_callbacks ["onUpdate_start"] then
		for uix_id, uix_callback in pairs (menu.uix_callbacks ["onUpdate_start"]) do
			uix_callback(curtime)
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
		return
	end

	-- kuertee start: callback
	if menu.uix_callbacks ["onUpdate_before_frame_update"] then
		for uix_id, uix_callback in pairs (menu.uix_callbacks ["onUpdate_before_frame_update"]) do
			uix_callback (menu.infoFrame)
		end
	end
	-- kuertee end: callback

	menu.infoFrame:update()
end

-- kuertee custom HUD start:
local onTableMouseOver_uitable = nil
local onTableMouseOver_row = nil
-- kuertee custom HUD end

function menu.onTableMouseOut(uitable, row)
	-- kuertee custom HUD start:
	if uitable ~= onTableMouseOver_uitable or row ~= onTableMouseOver_row then
		return
	end
	-- kuertee custom HUD end

	if (not menu.showTabs) and (not menu.lock) then
		menu.over = false
		menu.lock = getElapsedTime()
		menu.createInfoFrame()
	end
end

function menu.onTableMouseOver(uitable, row)
	if (not menu.showTabs) and ((not menu.lock) or (not menu.over)) then
		-- kuertee custom HUD start:
		onTableMouseOver_uitable = uitable
		onTableMouseOver_row = row
		-- kuertee custom HUD end

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
	Helper.closeMenu(menu, "close", nil, false)
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
		Helper.closeMenu(menu, dueToClose, nil, false)
		menu.cleanup()
	else
		Helper.closeMenuAndOpenNewMenu(menu, "OptionsMenu", nil)
		menu.cleanup()
	end
end

-- menu helpers

-- kuertee custom HUD start:
-- note that custom HUD elements are only shown when the TopLevelMenu is collapsed.
-- to add custom HUD elements, add these in your lua file:
-- as an example, review "ui\menu_toplevel_uix.lua" of the kuertee_alternatives_to_death mod
-- 1. topLevelMenu.registerCallback("kHUD_get_is_show_custom_hud", YourMenu.kHUD_get_is_show_custom_hud)
-- 2. function YourMenu.kHUD_get_is_show_custom_hud() return true|false depending on whether your custom HUD should be shown or not end
-- 3. topLevelMenu.registerCallback("kHUD_add_tables", YourMenu.kHUD_add_tables)
-- 4. function YourMenu.kHUD_add_tables(frame) local ftable = frame:addTable(); local row = ftable:addRow(); etc.; end
kHUD = {
	name = "kHUD",
	isDebug = nil,
}

function kHUD.init()
    Menus = Menus or {}
    table.insert(Menus, kHUD)
    if Helper then
        Helper.registerMenu(kHUD)
    end
	menu.registerCallback ("createInfoFrame_on_add_table", kHUD.OpenOrClose)
end

function kHUD.getIsOpenOrClose()
	local isCreateHUDFrame
	if isCreateHUDFrame ~= true then
		if menu.uix_callbacks["kHUD_get_is_show_custom_hud"] and next(menu.uix_callbacks["kHUD_get_is_show_custom_hud"]) then
			for uix_id, uix_callback in pairs (menu.uix_callbacks ["kHUD_get_is_show_custom_hud"]) do
				isCreateHUDFrame = uix_callback ()
				if isCreateHUDFrame == true then
					break
				end
			end
		end
	end
	if isCreateHUDFrame ~= true then
		isCreateHUDFrame = nil
	end
	return isCreateHUDFrame
end

function kHUD.OpenOrClose()
	if kHUD.getIsOpenOrClose() then
		kHUD.display()
	elseif kHUD.frame then
		kHUD.cleanup()
	end
end

function kHUD.display()
	if kHUD.isDebug then
		Helper.debugText_forced("kHUD.display")
	end
	kHUD.createFrame()
	kHUD.createTables()
end

function kHUD.cleanup()
	if kHUD.isDebug then
		Helper.debugText_forced("kHUD.cleanUp")
	end
	kHUD.frame = nil
end

function kHUD.createFrame()
	kHUD.frame = menu.infoFrame
	if kHUD.isDebug then
		Helper.debugText_forced("createFrame kHUD.frame", tostring(kHUD.frame))
	end
end

function kHUD.createTables()
	if kHUD.frame then
		local ftables_created = {}
		if menu.uix_callbacks["kHUD_add_tables"] and next(menu.uix_callbacks["kHUD_add_tables"]) then
			for uix_id, uix_callback in pairs (menu.uix_callbacks ["kHUD_add_tables"]) do
				local ftables = uix_callback (kHUD.frame)
				if ftables and type(ftables) == "table" and #ftables > 0 then
					for j, ftable in ipairs(ftables) do
						table.insert(ftables_created, ftable)
					end
				end
			end
		end
		if menu.uix_callbacks["kHUD_add_HUD_tables"] and next(menu.uix_callbacks["kHUD_add_HUD_tables"]) then
			-- kHUD_add_HUD_tables is for backward compatibility
			for uix_id, uix_callback in pairs (menu.uix_callbacks ["kHUD_add_HUD_tables"]) do
				local ftables = uix_callback (kHUD.frame)
				if ftables and type(ftables) == "table" and #ftables > 0 then
					for j, ftable in ipairs(ftables) do
						table.insert(ftables_created, ftable)
					end
				end
			end
		end
		if kHUD.isDebug then
			Helper.debugText_forced("createTables #ftables_created", #ftables_created)
		end
		if kHUD.isDebug and #ftables_created < 1 then
			-- set to true to force a row for testing
			local ftable = kHUD.frame:addTable(1)
			local row = ftable:addRow()
			row[1]:createText("kHUD")
		end
		kHUD.updateFrameHeight()
	end
end

function kHUD.updateFrameHeight()
	local y_max = kHUD.getFrameHeight(kHUD.frame)
	if kHUD.isDebug then
		Helper.debugText_forced("updateFrameHeight kHUD.frame.properties.height (pre set)", kHUD.frame.properties.height)
	end
	if kHUD.frame.properties.height ~= y_max then
		kHUD.frame.properties.height = y_max + Helper.borderSize
	end
	if kHUD.isDebug then
		Helper.debugText_forced("updateFrameHeight kHUD.frame.properties.height", kHUD.frame.properties.height)
	end
end

function kHUD.getFrameHeight(frame)
	local y_max = 0
	local y_tableBottom = 0
	local ftable
	for i = 1, #frame.content do
		if frame.content [i].type == "table" then
			ftable = frame.content [i]
			local visibleHeight = ftable:getVisibleHeight ()
			Helper.debugText("ftable.properties.x", ftable.properties.x)
			Helper.debugText("ftable.properties.width", ftable.properties.width)
			Helper.debugText("ftable.properties.y", ftable.properties.y)
			Helper.debugText("visibleHeight", visibleHeight)
			y_tableBottom = ftable.properties.y + visibleHeight
			Helper.debugText("y_tableBottom", y_tableBottom)
			if y_tableBottom > y_max then
				y_max = y_tableBottom
				Helper.debugText("y_max", y_max)
			end
		end
	end
	return y_max
end

function kHUD.getNextY()
	return kHUD.getFrameHeight(menu.infoFrame)
end
-- kuertee custom HUD end

-- kuertee start:
function menu.requestUpdate (adj)
	Helper.debugText("menu.requestUpdate")
	if adj == nil then
		adj = 0
	end
	if menu.refresh == nil then
		menu.refresh = getElapsedTime () + adj
	end
end

menu.uix_callbackCount = 0
function menu.registerCallback(callbackName, callbackFunction, id)
    -- note 1: format is generally [function name]_[action]. e.g.: in kuertee_menu_transporter, "display_on_set_room_active" overrides the room's active property with the return of the callback.
    -- note 2: events have the word "_on_" followed by a PRESENT TENSE verb. e.g.: in kuertee_menu_transporter, "display_on_set_buttontable" is called after all of the rows of buttontable are set.
    -- note 3: new callbacks can be added or existing callbacks can be edited. but commit your additions/changes to the mod's GIT repository.
    -- note 4: search for the callback names to see where they are executed.
    -- note 5: if a callback requires a return value, return it in an object var. e.g. "display_on_set_room_active" requires a return of {active = true | false}.
    if menu.uix_callbacks [callbackName] == nil then
        menu.uix_callbacks [callbackName] = {}
    end
    if not menu.uix_callbacks[callbackName][id] then
        if not id then
            menu.uix_callbackCount = menu.uix_callbackCount + 1
            id = "_" .. tostring(menu.uix_callbackCount)
        end
        menu.uix_callbacks[callbackName][id] = callbackFunction
        if Helper.isDebugCallbacks then
            Helper.debugText_forced(menu.name .. " uix registerCallback: menu.uix_callbacks[" .. tostring(callbackName) .. "][" .. tostring(id) .. "]: " .. tostring(menu.uix_callbacks[callbackName][id]))
        end
    else
        Helper.debugText_forced(menu.name .. " uix registerCallback: callback at " .. callbackName .. " with id " .. tostring(id) .. " was already previously registered")
    end
end

menu.uix_isDeregisterQueued = nil
menu.uix_callbacks_toDeregister = {}
function menu.deregisterCallback(callbackName, callbackFunction, id)
    if not menu.uix_callbacks_toDeregister[callbackName] then
        menu.uix_callbacks_toDeregister[callbackName] = {}
    end
    if id then
        table.insert(menu.uix_callbacks_toDeregister[callbackName], id)
    else
        if menu.uix_callbacks[callbackName] then
            for id, func in pairs(menu.uix_callbacks[callbackName]) do
                if func == callbackFunction then
                    table.insert(menu.uix_callbacks_toDeregister[callbackName], id)
                end
            end
        end
    end
    if not menu.uix_isDeregisterQueued then
        menu.uix_isDeregisterQueued = true
        Helper.addDelayedOneTimeCallbackOnUpdate(menu.deregisterCallbacksNow, true, getElapsedTime() + 1)
    end
end

function menu.deregisterCallbacksNow()
    menu.uix_isDeregisterQueued = nil
    for callbackName, ids in pairs(menu.uix_callbacks_toDeregister) do
        if menu.uix_callbacks[callbackName] then
            for _, id in ipairs(ids) do
                if menu.uix_callbacks[callbackName][id] then
                    if Helper.isDebugCallbacks then
                        Helper.debugText_forced(menu.name .. " uix deregisterCallbacksNow (pre): menu.uix_callbacks[" .. tostring(callbackName) .. "][" .. tostring(id) .. "]: " .. tostring(menu.uix_callbacks[callbackName][id]))
                    end
                    menu.uix_callbacks[callbackName][id] = nil
                    if Helper.isDebugCallbacks then
                        Helper.debugText_forced(menu.name .. " uix deregisterCallbacksNow (post): menu.uix_callbacks[" .. tostring(callbackName) .. "][" .. tostring(id) .. "]: " .. tostring(menu.uix_callbacks[callbackName][id]))
                    end
                else
                    Helper.debugText_forced(menu.name .. " uix deregisterCallbacksNow: callback at " .. callbackName .. " with id " .. tostring(id) .. " doesn't exist")
                end
            end
        end
    end
    menu.uix_callbacks_toDeregister = {}
end

menu.uix_isUpdateQueued = nil
menu.uix_callbacks_toUpdate = {}
function menu.updateCallback(callbackName, id, callbackFunction)
    if not menu.uix_callbacks_toUpdate[callbackName] then
        menu.uix_callbacks_toUpdate[callbackName] = {}
    end
    if id then
        table.insert(menu.uix_callbacks_toUpdate[callbackName], {id = id, callbackFunction = callbackFunction})
    end
    if not menu.uix_isUpdateQueued then
        menu.uix_isUpdateQueued = true
        Helper.addDelayedOneTimeCallbackOnUpdate(menu.updateCallbacksNow, true, getElapsedTime() + 1)
    end
end

function menu.updateCallbacksNow()
    menu.uix_isUpdateQueued = nil
    for callbackName, updateDatas in pairs(menu.uix_callbacks_toUpdate) do
        if menu.uix_callbacks[callbackName] then
            for _, updateData in ipairs(updateDatas) do
                if menu.uix_callbacks[callbackName][updateData.id] then
                    if Helper.isDebugCallbacks then
                        Helper.debugText_forced(menu.name .. " uix updateCallbacksNow (pre): menu.uix_callbacks[" .. tostring(callbackName) .. "][" .. tostring(updateData.id) .. "]: " .. tostring(menu.uix_callbacks[callbackName][updateData.id]))
                    end
                    menu.uix_callbacks[callbackName][updateData.id] = updateData.callbackFunction
                    if Helper.isDebugCallbacks then
                        Helper.debugText_forced(menu.name .. " uix updateCallbacksNow (post): menu.uix_callbacks[" .. tostring(callbackName) .. "][" .. tostring(updateData.id) .. "]: " .. tostring(menu.uix_callbacks[callbackName][updateData.id]))
                    end
                else
                    Helper.debugText_forced(menu.name .. " uix updateCallbacksNow: callback at " .. callbackName .. " with id " .. tostring(id) .. " doesn't exist")
                end
            end
        end
    end
end
-- kuertee end

init()
