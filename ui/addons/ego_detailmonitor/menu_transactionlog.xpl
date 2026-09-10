-- param == { 0, 0, container }

-- ffi setup
local ffi = require("ffi")
local C = ffi.C
ffi.cdef[[
	bool IsComponentOperational(UniverseID componentid);
	bool IsMouseEmulationActive(void);
	bool IsRealComponentClass(UniverseID componentid, const char* classname);
]]

local menu = {
	name = "TransactionLogMenu",
	lastRefreshTime = 0,
}

local config = {
	infoLayer = 4,
	contextLayer = 2,
	mouseOutRange = 100,
}

-- kuertee start:
menu.uix_callbacks = {}
function menu.uix_getConfig() return config end
-- kuertee end

local function init()
	Menus = Menus or { }
	table.insert(Menus, menu)
	if Helper then
		Helper.registerMenu(menu)
	end

	-- kuertee start:
	menu.init_kuertee()
	-- kuertee end
end

-- kuertee start:
function menu.init_kuertee ()
end
-- kuertee end

function menu.cleanup()
	menu.infoFrame = nil
	menu.sidebar = nil
	menu.topNavbar = nil
	menu.infoTable = nil

	menu.settoprow = nil
	menu.setselectedrow = nil
	menu.settoprowid = nil

	menu.selectedRows = {}

	-- Chem begin: station selector
	menu.uix_stationOptions = nil
	menu.uix_stations = nil
	menu.uix_curStationIdx = nil
	menu.uix_hasSelector = nil
	menu.uix_selectorTable = nil
	-- Chem end: station selector

	-- start: kuertee call-back
	if menu.uix_callbacks ["cleanup"] then
		for uix_id, uix_callback in pairs (menu.uix_callbacks ["cleanup"]) do
			uix_callback ()
		end
	end
	-- end: kuertee call-back
end

-- widget scripts

function menu.buttonRightBar(newmenu, params)
	Helper.closeMenuAndOpenNewMenu(menu, newmenu, params, true)
	menu.cleanup()
end

function menu.buttonContainerInfo(controllable)
	Helper.closeMenuAndOpenNewMenu(menu, "MapMenu", { 0, 0, true, nil, nil, "infomode", { "info", controllable } })
	menu.cleanup()
end

function menu.buttonTransactionLog(controllable)
	Helper.closeMenuAndOpenNewMenu(menu, "TransactionLogMenu", { 0, 0, controllable });
	menu.cleanup()
end

-- Chem begin: station selector
-- called before the first row exists, because addRow() finalises the column widths
function menu.uix_setupSelectorColumns(ftable)
	ftable:setColWidthPercent(1, 25)
	ftable:setColWidth(2, Helper.standardButtonHeight)
	ftable:setColWidth(4, Helper.standardButtonHeight)
	ftable:setColWidthPercent(5, 25)
	-- col 3 is left undefined, so the dropdown takes everything the others leave
end

function menu.uix_displayStationSelector(ftable)
	-- a non-player station is not in the list, so stepping into it is always possible
	local canStep = (#menu.uix_stations > 1) or (menu.uix_curStationIdx == nil)

	local row = ftable:addRow(true)

	row[2]:createButton({ active = canStep, mouseOverText = ReadText(1005, 357) }):setIcon("widget_arrow_left_01")
	row[2].handlers.onClick = function () return menu.uix_buttonStepStation(-1) end

	row[3]:createDropDown(menu.uix_stationOptions, {
		startOption = menu.uix_curStationIdx and tostring(menu.uix_curStationIdx) or "",
		textOverride = (menu.uix_curStationIdx == nil) and Helper.getNameAndIdString(menu.container) or nil,
		height = Helper.standardButtonHeight,
		mouseOverText = ReadText(1001, 2305),
	})
	row[3]:setTextProperties({ halign = "left" })
	row[3]:setText2Properties({ halign = "right" })
	-- the log refreshes itself every 10s, which would close an open dropdown
	row[3].handlers.onDropDownActivated = function () Helper.transactionLogData.noupdate = true end
	row[3].handlers.onDropDownDeactivated = function () Helper.transactionLogData.noupdate = nil end
	row[3].handlers.onDropDownConfirmed = function (_, id) return menu.uix_dropdownStation(id) end

	row[4]:createButton({ active = canStep, mouseOverText = ReadText(1005, 358) }):setIcon("widget_arrow_right_01")
	row[4].handlers.onClick = function () return menu.uix_buttonStepStation(1) end
end

function menu.uix_getStationOptions()
	local stations = {}
	for _, station in ipairs(GetContainedStationsByOwner("player", nil, true) or {}) do
		local station64 = ConvertIDTo64Bit(station)
		if station64 and (station64 ~= 0) and C.IsComponentOperational(station64) then
			local name, faction, icon, idcode, sector = GetComponentData(station, "name", "owner", "icon", "idcode", "sector")
			table.insert(stations, {
				station = station64,
				color = Helper.convertColorToText(GetFactionData(faction, "color")),
				name = name or "",
				icon = icon or "",
				idcode = idcode or "",
				sector = sector or "",
			})
		end
	end
	table.sort(stations, function (a, b)
		if a.sector ~= b.sector then
			return a.sector < b.sector
		end
		return a.name < b.name
	end)

	local options = {}
	menu.uix_stations = {}
	menu.uix_curStationIdx = nil
	for i, entry in ipairs(stations) do
		local displayName = string.format("%s (%s)", entry.name, entry.idcode)
		-- ids are the sorted position, so no component id has to survive the widget round-trip
		table.insert(options, {
			id = tostring(i),
			icon = "",
			-- faction colour and station icon are inlined, so the option needs no widget icon of its own
			text = string.format("%s\027[%s] %s", entry.color, entry.icon, displayName),
			text2 = entry.sector,
			displayremoveoption = false,
			mouseovertext = displayName,
		})
		menu.uix_stations[i] = entry.station
		if IsSameComponent(entry.station, menu.container) then
			menu.uix_curStationIdx = i
		end
	end

	return options
end

function menu.uix_switchStation(station)
	if station and (station ~= 0) and (not IsSameComponent(station, menu.container)) then
		-- the station editor parks its construction map state when it jumps here, and every vanilla
		-- exit releases it again; skipping that makes the next station reuse the parked plan
		if Helper.checkDiscardStationEditorChanges(menu) then
			return
		end
		-- noreturn = true forwards menu.param2, so "back" still leads to whatever opened this menu
		Helper.closeMenuAndOpenNewMenu(menu, "TransactionLogMenu", { 0, 0, station }, true)
		menu.cleanup()
	end
end

function menu.uix_dropdownStation(id)
	Helper.transactionLogData.noupdate = nil
	menu.uix_switchStation(menu.uix_stations[tonumber(id)])
end

function menu.uix_buttonStepStation(step)
	local numstations = #menu.uix_stations
	if numstations == 0 then
		return
	end
	local newidx
	if menu.uix_curStationIdx then
		newidx = ((menu.uix_curStationIdx - 1 + step) % numstations) + 1
	else
		-- current station is not player owned: enter the list at either end
		newidx = (step > 0) and 1 or numstations
	end
	menu.uix_switchStation(menu.uix_stations[newidx])
end
-- Chem end: station selector

-- Menu member functions

function menu.onShowMenu()
	-- Init
	menu.containerid = menu.param[3]
	menu.container = ConvertIDTo64Bit(menu.containerid)

	menu.isstation = C.IsRealComponentClass(menu.container, "station")

	menu.selectedRows = {}

	-- display main frame
	menu.createFrame()
end

function menu.refreshInfoFrame(toprow, selectedrow)
	if menu.infoTable then
		menu.settoprow = toprow or GetTopRow(menu.infoTable)
		if menu.settoprow and Helper.transactionLogData then
			Helper.transactionLogData.topRowId = menu.rowDataMap[menu.infoTable] and menu.rowDataMap[menu.infoTable][menu.settoprow]
		end
		menu.setselectedrow = selectedrow or Helper.currentTableRow[menu.infoTable]
	end

	menu.createFrame()
end

function menu.createFrame()
	-- remove old data
	Helper.clearDataForRefresh(menu, config.infoLayer)

	local frameProperties = {
		layer = config.infoLayer,
		standardButtons = { back = true, close = true, help = true  },
		width = Helper.viewWidth,
		height = Helper.viewHeight,
		x = 0,
		y = 0,
	}
	menu.infoFrame = Helper.createFrameHandle(menu, frameProperties)
	menu.infoFrame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	menu.sidebarWidth = Helper.scaleX(Helper.sidebarWidth)

	if menu.isstation then
		local rightbartable = Helper.createRightSideBar(menu, menu.infoFrame, menu.container, true, "transactions", menu.buttonRightBar)
		rightbartable:addConnection(1, 4, true)
	end

	local tableProperties = {
		width = Helper.round(Helper.playerInfoConfig.width * 1.5),
		height = Helper.viewHeight - 2 * Helper.frameBorder,
		x = Helper.frameBorder,
		y = Helper.frameBorder,
		x2 = menu.isstation and (menu.sidebarWidth + Helper.borderSize + Helper.frameBorder) or Helper.frameBorder,
	}
	-- Chem begin: station selector
	-- the selector goes above the log, and everything below is shifted down by its height:
	-- the log tables and the graph all derive their y and height from tableProperties, so they stay aligned
	menu.uix_hasSelector = nil
	menu.uix_stationOptions = menu.isstation and menu.uix_getStationOptions() or {}
	if #menu.uix_stationOptions > 0 then
		local selectortable = menu.infoFrame:addTable(5, { tabOrder = 5, width = Helper.viewWidth - tableProperties.x - tableProperties.x2, x = tableProperties.x, y = tableProperties.y })
		menu.uix_setupSelectorColumns(selectortable)		-- must happen before the first addRow(), which finalises the widths
		menu.uix_displayStationSelector(selectortable)
		menu.uix_hasSelector = true

		local selectorheight = selectortable:getFullHeight() + Helper.borderSize
		tableProperties.y = tableProperties.y + selectorheight
		tableProperties.height = tableProperties.height - selectorheight
	end
	-- Chem end: station selector
	Helper.createTransactionLog(menu, menu.container, tableProperties, menu.refreshInfoFrame, 0)

	-- start: kuertee call-back
	if menu.uix_callbacks ["createFrame_on_create_transaction_log"] then
			for uix_id, uix_callback in pairs (menu.uix_callbacks ["createFrame_on_create_transaction_log"]) do
				uix_callback ()
			end
		end
	-- end: kuertee call-back

	menu.infoFrame:display()
	menu.lastRefreshTime = getElapsedTime()
end

function menu.createContextFrame(data, x, y, width, nomouseout)
	Helper.removeAllWidgetScripts(menu, config.contextLayer)
	PlaySound("ui_positive_click")

	local contextmenuwidth = width or menu.contextMenuWidth

	menu.contextFrame = Helper.createFrameHandle(menu, {
		layer = config.contextLayer,
		standardButtons = { close = true },
		width = contextmenuwidth,
		x = x,
		y = 0,
		autoFrameHeight = true,
	})
	menu.contextFrame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	local ftable = menu.contextFrame:addTable(1, { tabOrder = 4, highlightMode = "off" })

	-- fill data
	Helper.createTransactionLogTableContext(menu, ftable, data)

	if menu.contextFrame.properties.x + contextmenuwidth > Helper.viewWidth then
		menu.contextFrame.properties.x = Helper.viewWidth - contextmenuwidth - Helper.frameBorder
	end
	local height = menu.contextFrame:getUsedHeight()
	if y + height > Helper.viewHeight then
		menu.contextFrame.properties.y = Helper.viewHeight - height - Helper.frameBorder
	else
		menu.contextFrame.properties.y = y
	end

	menu.contextFrame:display()

	if not nomouseout then
		menu.mouseOutBox = {
			x1 =   menu.contextFrame.properties.x -  Helper.viewWidth / 2                    - config.mouseOutRange,
			x2 =   menu.contextFrame.properties.x -  Helper.viewWidth / 2 + contextmenuwidth + config.mouseOutRange,
			y1 = - menu.contextFrame.properties.y + Helper.viewHeight / 2                    + config.mouseOutRange,
			y2 = - menu.contextFrame.properties.y + Helper.viewHeight / 2 - height           - config.mouseOutRange
		}
	end
end

function menu.viewCreated(layer, ...)
	if menu.isstation then
		-- Chem begin: station selector. was: menu.sidebar, menu.topNavbar, menu.infoTable = ...
		-- the selector table is created before the log tables, so it comes second in the list
		if menu.uix_hasSelector then
			menu.sidebar, menu.uix_selectorTable, menu.topNavbar, menu.infoTable = ...
		else
		-- Chem end: station selector
		menu.sidebar, menu.topNavbar, menu.infoTable = ...
		-- Chem begin: station selector
		end
		-- Chem end: station selector
	else
		menu.topNavbar, menu.infoTable = ...
	end
end

-- update
menu.updateInterval = 0.1

function menu.onUpdate()
	-- kuertee start: in case onUpdate is called without the menu being opened. i.e. from kuertee_trade_analytics mod.
	if not menu.infoFrame then
		return
	end
	-- kuertee end: in case onUpdate is called without the menu being opened. i.e. from kuertee_trade_analytics mod.

	menu.infoFrame:update()

	if not Helper.transactionLogData.noupdate then
		local curtime = getElapsedTime()
		if curtime > menu.lastRefreshTime + 10 then
			menu.refreshInfoFrame()
		end
	end

	if Helper.transactionLogData and Helper.transactionLogData.graphUpdateSelection then
		Helper.updateTransactionLogGraphSelection()
		Helper.transactionLogData.graphUpdateSelection = false
	end

	if menu.mouseOutBox then
		if (GetControllerInfo() ~= "gamepad") or (C.IsMouseEmulationActive()) then
			local curpos = table.pack(GetLocalMousePosition())
			if curpos[1] and ((curpos[1] < menu.mouseOutBox.x1) or (curpos[1] > menu.mouseOutBox.x2)) then
				menu.closeContextMenu()
			elseif curpos[2] and ((curpos[2] > menu.mouseOutBox.y1) or (curpos[2] < menu.mouseOutBox.y2)) then
				menu.closeContextMenu()
			end
		end
	end
end

function menu.onRowChanged(row, rowdata, uitable)
	if uitable == menu.infoTable then
		Helper.onTransactionLogRowChanged(rowdata)
	end
end

function menu.onSelectElement(uitable, modified, row)
end

function menu.onEditBoxActivated(widget)
	Helper.onTransactionLogEditBoxActivated(widget)
end

function menu.onTableRightMouseClick(uitable, row, posx, posy)
	if uitable == menu.infoTable then
		Helper.onTransactionLogTableRightMouseClick(menu, uitable, row, posx, posy)
	end
end

function menu.closeContextMenu()
	Helper.clearFrame(menu, config.contextLayer)
	menu.contextMenuMode = nil
	menu.mouseOutBox = nil
end

function menu.onCloseElement(dueToClose)
	if dueToClose == "back" then
		if menu.contextMenuMode then
			menu.closeContextMenu()
			return
		end

		if Helper.checkDiscardStationEditorChanges(menu) then
			return
		end
	end

	Helper.closeMenu(menu, dueToClose)
	menu.cleanup()
end

-- kuertee start:
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
