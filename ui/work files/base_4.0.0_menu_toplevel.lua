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
	end

	menu.infoFrame:display()
end
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

	menu.infoFrame:update()
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
end
