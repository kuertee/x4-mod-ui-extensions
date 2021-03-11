local config = {
	width = Helper.sidebarWidth,
	height = Helper.sidebarWidth,
	offsetY = 0,
	layer = 3,
	mouseOutRange = 100,
}
local pullDownArrowsHeight = Helper.sidebarWidth
local isDisplayed = false
function newFuncs.createInfoFrame(param)
	local menu = topLevelMenu

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
		useMiniWidgetSystem = (not menu.showTabs) and (not menu.over) and isDisplayed,
		enableDefaultInteractions = false,
	}
	isDisplayed = true

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
		pullDownArrowsHeight = ftable:getVisibleHeight()
		menu.infoFrame.properties.height = ftable.properties.y + pullDownArrowsHeight + Helper.borderSize

		-- start kuertee_lua_with_callbacks:
		if callbacks ["createInfoFrame_on_before_frame_display"] then
			for _, callback in ipairs (callbacks ["createInfoFrame_on_before_frame_display"]) do
				callback (menu.infoFrame)
			end
			newFuncs.updateFrameHeight ()
		end
		-- end kuertee_lua_with_callbacks:

	end

	menu.infoFrame:display()
end
function newFuncs.updateFrameHeight ()
	local menu = topLevelMenu

	local yBottomMax = 0
	local yBottomFTable = 0
	local frame = menu.infoFrame
	local ftable
	for i = 1, #frame.content do
		if frame.content [i].type == "table" then
			ftable = frame.content [i]
			yBottomFTable = ftable.properties.y + ftable:getVisibleHeight ()
			-- DebugError ("kuertee_menu_toplevel.newFuncs.updateFrameHeight yBottomFTable " .. tostring (yBottomFTable))
			-- DebugError ("kuertee_menu_toplevel.newFuncs.updateFrameHeight yBottomMax " .. tostring (yBottomMax))
			if yBottomFTable > yBottomMax then
				yBottomMax = yBottomFTable
			end
		end
	end
	local frameHeight = yBottomMax - frame.properties.y
	if menu.infoFrame.properties.height ~= frameHeight then
		-- DebugError ("kuertee_menu_toplevel.newFuncs.updateFrameHeight frameHeight " .. tostring (frameHeight))
		frame.properties.height = frameHeight
		menu.height = Helper.scaleX (frameHeight)
	end
end
function newFuncs.onUpdate()
	local menu = topLevelMenu

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
	if menu.lock and (menu.lock + 0.11 < curtime) then
		menu.lock = nil
	end

	-- if menu.over and (not menu.lock) then
	-- 	if (GetControllerInfo() ~= "gamepad") or (C.IsMouseEmulationActive()) then
	-- 		local mouseOutBox = {
	-- 			x1 = - menu.width / 2,
	-- 			x2 =   menu.width / 2,
	-- 			y1 = Helper.viewHeight / 2,
	-- 			y2 = Helper.viewHeight / 2 - menu.infoFrame.properties.height,
	-- 		}

	-- 		local curpos = table.pack(GetLocalMousePosition())
	-- 		if curpos[1] and ((curpos[1] < mouseOutBox.x1) or (curpos[1] > mouseOutBox.x2)) then
	-- 			menu.over = false
	-- 			menu.lock = getElapsedTime()
	-- 			menu.createInfoFrame()
	-- 			return
	-- 		elseif curpos[2] and ((curpos[2] > mouseOutBox.y1) or (curpos[2] < mouseOutBox.y2)) then
	-- 			menu.over = false
	-- 			menu.lock = getElapsedTime()
	-- 			menu.createInfoFrame()
	-- 			return
	-- 		end
	-- 	end
	-- end
	if not menu.lock then
		if menu.over and (GetControllerInfo() ~= "gamepad") or (C.IsMouseEmulationActive()) then
			local mouseOutBox = {
				x1 = - Helper.sidebarWidth / 2,
				x2 =   Helper.sidebarWidth / 2,
				y1 = Helper.viewHeight / 2,
				y2 = Helper.viewHeight / 2 - pullDownArrowsHeight,
			}
			local curpos = table.pack (GetLocalMousePosition ())
			local isOut = false
			if curpos[1] and (curpos[1] < mouseOutBox.x1 or curpos[1] > mouseOutBox.x2) then
				isOut = true
			elseif curpos[2] and (curpos[2] > mouseOutBox.y1 or curpos[2] < mouseOutBox.y2) then
				isOut = true
			end
			if isOut then
				menu.over = false
				menu.lock = getElapsedTime()
				menu.createInfoFrame ({isFromUpdate = true})
				return
			end
		else
			local mouseInBox = {
				x1 = - Helper.scaleX (config.width) / 2,
				x2 =   Helper.scaleX (config.width) / 2,
				y1 = Helper.viewHeight / 2,
				y2 = Helper.viewHeight / 2 - pullDownArrowsHeight,
			}
			local curpos = table.pack (GetLocalMousePosition ())
			local isIn = false
			if curpos[1] and curpos[1] > mouseInBox.x1 and curpos[1] < mouseInBox.x2 then
				if curpos[2] and curpos[2] < mouseInBox.y1 and curpos[2] > mouseInBox.y2 then
					isIn = true
				end
			end
			if isIn then
				menu.over = true
				menu.lock = getElapsedTime()
				menu.createInfoFrame ({isFromUpdate = true})
				return
			end
		end
	end

	if menu.refresh and menu.refresh <= curtime then
		menu.createInfoFrame ({isFromUpdate = true})
		menu.refresh = nil
		return
	end

	-- start kuertee_lua_with_callbacks:
	if callbacks ["createInfoFrame_onUpdate_before_frame_update"] then
		for _, callback in ipairs (callbacks ["createInfoFrame_onUpdate_before_frame_update"]) do
			callback (menu.infoFrame)
			newFuncs.updateFrameHeight ()
		end
	end
	-- end kuertee_lua_with_callbacks:

	menu.infoFrame:update()
end
function newFuncs.cleanup ()
	oldFuncs.cleanup ()
	isDisplayed = false
end
