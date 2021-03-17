function menu.buttonToggleObjectList(objectlistparam)
	local oldidx, newidx
	local leftbar = menu.showMultiverse and config.leftBarMultiverse or config.leftBar
	local count = 1
	for _, entry in ipairs(leftbar) do
		if (entry.condition == nil) or entry.condition() then
			if entry.mode then
				if type(entry.mode) == "table" then
					for _, mode in ipairs(entry.mode) do
						if mode == menu.infoTableMode then
							oldidx = count
						end
						if mode == objectlistparam then
							newidx = count
						end
					end
				else
					if entry.mode == menu.infoTableMode then
						oldidx = count
					end
					if entry.mode == objectlistparam then
						newidx = count
					end
				end
			end
			count = count + 1
		end
		if oldidx and newidx then
			break
		end
	end
	if newidx then
		Helper.updateButtonColor(menu.sideBar, newidx, 1, Helper.defaultArrowRowBackgroundColor)
	end
	if oldidx then
		Helper.updateButtonColor(menu.sideBar, oldidx, 1, Helper.defaultButtonBackgroundColor)
	end

	menu.createInfoFrameRunning = true
	if (menu.infoTableMode == "missionoffer") or (menu.infoTableMode == "mission") then
		menu.missionModeCurrent = nil
		if menu.missionModeContext then
			menu.closeContextMenu()
			menu.missionModeContext = nil
		end
	elseif menu.infoTableMode == "ventureoperation" then
		menu.currentOperationSelection = nil
	end
	AddUITriggeredEvent(menu.name, objectlistparam, menu.infoTableMode == objectlistparam and "off" or "on")
	if menu.infoTableMode == objectlistparam then
		menu.settoprow = GetTopRow(menu.infoTable)
		PlaySound("ui_negative_back")
		menu.infoTableMode = nil
		if oldidx then
			SelectRow(menu.sideBar, oldidx)
		end
	else
		menu.infoTable = nil
		menu.infoTable2 = nil
		PlaySound("ui_positive_select")
		if (menu.infoTableMode == "missionoffer") or (menu.infoTableMode == "mission") then
			if menu.missionModeContext then
				menu.closeContextMenu()
				menu.missionModeContext = nil
			end
		end
		menu.infoTableMode = objectlistparam
		if newidx then
			SelectRow(menu.sideBar, newidx)
		end
		if menu.infoTableMode == "plots" then
			menu.updatePlotData("plots_new", true)
			menu.storeCurrentPlots()
			--menu.plotDoNotUpdate = true
			menu.mode = "selectbuildlocation"
			C.ShowBuildPlotPlacementMap(menu.holomap, menu.currentsector)
		elseif (menu.mode ~= "selectCV") and (menu.mode ~= "hire") and (menu.mode ~= "orderparam_object") and (menu.mode ~= "selectComponent") then
			menu.plots_initialized = nil
			menu.plotData = {}
			menu.mode = nil
			menu.removeMouseCursorOverride(3)
			if not menu.showMultiverse then
				local startpos = ffi.new("UIPosRot")
				C.ShowUniverseMap2(menu.holomap, false, false, false, 0, startpos)
			end
		end
		if menu.infoTableMode == "missionoffer" then
			menu.updateMissionOfferList(true)
		end
		Helper.textArrayHelper(menu.searchtext, function (numtexts, texts) return C.SetMapFilterString(menu.holomap, numtexts, texts) end, "text")
		menu.applyFilterSettings()
	end
	menu.setrow = nil
	menu.setcol = nil
	menu.refreshMainFrame = true
	menu.createInfoFrame()
end
function menu.buttonSelectHandler()
	if menu.mode == "hire" then
		if C.IsComponentClass(menu.contextMenuData.component, "controllable") then
			local isplayerowned, isdock, isonlineobject = GetComponentData(menu.contextMenuData.component, "isplayerowned", "isdock", "isonlineobject")
			if not isonlineobject and (isplayerowned or (isdock and C.IsComponentClass(menu.contextMenuData.component, "station"))) then
				if menu.hireShip ~= menu.contextMenuData.component then
					menu.hireShip = menu.contextMenuData.component
					menu.hireRole = nil
					menu.hireIsPost = nil
					menu.hireIsMission = nil

					menu.refreshMainFrame = true
				end
			end
		end
	elseif menu.mode == "selectCV" then
		menu.selectCV(menu.contextMenuData.component)
	elseif menu.mode == "orderparam_object" then
		if menu.checkForOrderParamObject(menu.contextMenuData.component) then
			menu.modeparam[1](ConvertStringToLuaID(tostring(menu.contextMenuData.component)))
		end
	elseif menu.mode == "selectComponent" then
		if menu.checkForSelectComponent(menu.contextMenuData.component) then
			Helper.closeMenuForSection(menu, menu.modeparam[1], { ConvertStringToLuaID(tostring(menu.contextMenuData.component)) })
			menu.cleanup()
		end
	end
	menu.closeContextMenu()
end
function menu.createInfoFrame()
	menu.createInfoFrameRunning = true
	menu.refreshed = true
	menu.noupdate = false

	-- remove old data
	Helper.clearDataForRefresh(menu, config.infoFrameLayer)

	-- infoTable
	local infoTableHeight = Helper.viewHeight - menu.infoTableOffsetY - menu.borderOffset

	menu.infoFrame = Helper.createFrameHandle(menu, {
		x = menu.infoTableOffsetX,
		y = menu.infoTableOffsetY,
		width = menu.infoTableWidth,
		height = infoTableHeight,
		layer = config.infoFrameLayer,
		backgroundID = "solid",
		backgroundColor = Helper.color.semitransparent,
		standardButtons = {},
		autoFrameHeight = true,
		helpOverlayID = "map_infoframe",
	})

	menu.autopilottarget = GetAutoPilotTarget()
	menu.softtarget = C.GetSofttarget().softtargetID
	menu.populateUpkeepMissionData()

	if (menu.infoTableMode ~= "info") and (menu.mode ~= "orderparam_object") then
		menu.infoTablePersistentData.left.cashtransferdetails = {}
		menu.infoTablePersistentData.left.drops = {}
		menu.infoTablePersistentData.left.crew.object = nil
		menu.infoTablePersistentData.left.macrostolaunch = {}
	end

	if menu.holomap ~= 0 then
		if menu.infoTableMode then
			C.SetMapStationInfoBoxMargin(menu.holomap, "left", menu.infoTableOffsetX + menu.infoTableWidth + config.contextBorder)
		else
			C.SetMapStationInfoBoxMargin(menu.holomap, "left", 0)
		end
	end

	Helper.clearTableConnectionColumn(menu, 2)

	local helpOverlayText = ""

	local infotabledesc, infotabledesc2
	menu.infoTableData = menu.infoTableData or {}
	menu.infoTableData.left = {}
	if menu.infoTableMode == "objectlist" then
		infotabledesc, infotabledesc2 = menu.createObjectList(menu.infoFrame, "left")
	elseif menu.infoTableMode == "propertyowned" then
		infotabledesc = menu.createPropertyOwned(menu.infoFrame, "left")
	elseif menu.infoTableMode == "plots" then
		menu.createPlotMode(menu.infoFrame)
	elseif menu.infoTableMode == "info" then
		if menu.infoMode.left == "objectinfo" then
			menu.infoFrame.properties.autoFrameHeight = false
			menu.createInfoSubmenu(menu.infoFrame, "left")
		elseif menu.infoMode.left == "objectcrew" then
			menu.createCrewInfoSubmenu(menu.infoFrame, "left")
		elseif menu.infoMode.left == "objectloadout" then
			menu.createLoadoutInfoSubmenu(menu.infoFrame, "left")
		elseif menu.infoMode.left == "objectlogbook" then
			menu.createLogbookInfoSubmenu(menu.infoFrame, "left")
		elseif menu.infoMode.left == "orderqueue" then
			menu.createOrderQueue(menu.infoFrame, menu.infoMode.left, "left")
		elseif menu.infoMode.left == "orderqueue_advanced" then
			menu.createOrderQueue(menu.infoFrame, menu.infoMode.left, "left")
		elseif menu.infoMode.left == "standingorders" then
			menu.createStandingOrdersMenu(menu.infoFrame, "left")
		end
	elseif menu.infoTableMode == "missionoffer" then
		menu.createMissionMode(menu.infoFrame)
	elseif menu.infoTableMode == "mission" then
		menu.createMissionMode(menu.infoFrame)
	elseif menu.infoTableMode == "ventureseason" then
		if menu.seasonMode.left == "currentseason" then
			menu.createVentureSeason(menu.infoFrame, "left")
		elseif menu.seasonMode.left == "coalition" then
			menu.createVentureCoalition(menu.infoFrame, "left")
		elseif menu.seasonMode.left == "pastseasons" then
			menu.createVenturePastSeasons(menu.infoFrame, "left")
		end
	elseif menu.infoTableMode == "ventureoperation" then
		menu.createVentureOperation(menu.infoFrame, "left")
	elseif menu.infoTableMode == "ventureoutcomes" then
		menu.createVentureOutcomes(menu.infoFrame, "left")
	elseif menu.infoTableMode == "venturelogbook" then
		menu.createVentureLogbook(menu.infoFrame, "left")
	elseif menu.infoTableMode == "ventureteam" then
		menu.createVentureTeam(menu.infoFrame, "left")
	elseif menu.infoTableMode == "ventureinventory" then
		if menu.ventureInventoryMode.left == "playerinventory" then
			menu.createVenturePlayerInventory(menu.infoFrame, "left")
		elseif menu.ventureInventoryMode.left == "teaminventory" then
			menu.createVentureTeamInventory(menu.infoFrame, "left")
		end
	elseif menu.infoTableMode == "cheats" then
		menu.createCheats(menu.infoFrame)
	else
		-- empty
		menu.infoFrame.properties.backgroundID = ""
		menu.infoFrame.properties.autoFrameHeight = false
		menu.infoFrame:addTable(0)
	end

	if menu.infoFrame then
		menu.infoFrame.properties.helpOverlayText = helpOverlayText
		menu.infoFrame:display()
	else
		-- create legacy info frame
		-- NOTE: descriptor table is {infotabledesc} if infotabledesc2 == nil
		Helper.displayFrame(menu, {infotabledesc, infotabledesc2}, false, "solid", "", {}, nil, config.infoFrameLayer, Helper.color.semitransparent, nil, false, true, nil, nil, menu.infoTableWidth, infoTableHeight, menu.infoTableOffsetX, menu.infoTableOffsetY)
	end

	if menu.holomap and (menu.holomap ~= 0) then
		menu.setSelectedMapComponents()
	end
end
function menu.refreshInfoFrame(setrow, setcol)
	if (menu.mode == "tradecontext") or (menu.mode == "dropwarescontext") or (menu.mode == "renamecontext") or (menu.mode == "crewtransfercontext") or (menu.mode == "venturepatroninfo") then
		return
	end
	if not menu.createInfoFrameRunning then
		menu.settoprow = menu.settoprow or GetTopRow(menu.infoTable)
		menu.topRows.infotableleft = menu.settoprow
		if menu.setplottoprow then
			menu.settoprow = menu.setplottoprow
			menu.setplottoprow = nil
		end
		if (menu.infoTableMode ~= "objectlist") and (menu.infoTableMode ~= "propertyowned") then
			menu.setrow = setrow or Helper.currentTableRow[menu.infoTable]
			menu.selectedRows.infotableleft = menu.setrow
			if menu.setplotrow then
				menu.setrow = menu.setplotrow
				menu.setplotrow = nil
			end
			menu.setcol = setcol or Helper.currentTableCol[menu.infoTable]
			menu.selectedCols.infotableleft = menu.setcol
		end

		menu.selectedRows.infotable2 = nil
		if menu.infoTable2 then
			menu.selectedRows.infotable2 = Helper.currentTableRow[menu.infoTable2]
		end
		if menu.infoTable3 then
			menu.topRows.infotable3left = GetTopRow(menu.infoTable3)
			menu.selectedRows.infotable3left = Helper.currentTableRow[menu.infoTable3]
		end
		if menu.orderHeaderTable and menu.lastactivetable == menu.orderHeaderTable.id then
			menu.selectedRows.orderHeaderTableleft = menu.selectedRows.orderHeaderTableleft or Helper.currentTableRow[menu.orderHeaderTable.id] or 1
			menu.selectedCols.orderHeaderTableleft = menu.selectedCols.orderHeaderTableleft or Helper.currentTableCol[menu.orderHeaderTable.id]
		end
		if menu.ventureSeasonHeaderTableLeft and menu.lastactivetable == menu.ventureSeasonHeaderTableLeft.id then
			menu.selectedRows.ventureSeasonHeaderTableleft = menu.selectedRows.ventureSeasonHeaderTableleft or Helper.currentTableRow[menu.ventureSeasonHeaderTableLeft.id] or 1
			menu.selectedCols.ventureSeasonHeaderTableleft = menu.selectedCols.ventureSeasonHeaderTableleft or Helper.currentTableCol[menu.ventureSeasonHeaderTableLeft.id]
		end
		if menu.ventureInventoryHeaderTableLeft and menu.lastactivetable == menu.ventureInventoryHeaderTableLeft.id then
			menu.selectedRows.ventureInventoryHeaderTableleft = menu.selectedRows.ventureInventoryHeaderTableleft or Helper.currentTableRow[menu.ventureInventoryHeaderTableLeft.id] or 1
			menu.selectedCols.ventureInventoryHeaderTableleft = menu.selectedCols.ventureInventoryHeaderTableleft or Helper.currentTableCol[menu.ventureInventoryHeaderTableLeft.id]
		end
		menu.createInfoFrame()
	end
	menu.refreshInfoFrame2()
end
function menu.createPropertyOwned(frame, instance)
	local infoTableData = menu.infoTableData[instance]

	-- TODO: Move to config table?
	infoTableData.maxIcons = 5
	infoTableData.shipIconWidth = menu.getShipIconWidth()
	local maxicons = infoTableData.maxIcons

	local ftable = frame:addTable(5 + maxicons, { tabOrder = 1, multiSelect = true })
	ftable:setDefaultCellProperties("text", { minRowHeight = config.mapRowHeight, fontsize = config.mapFontSize })
	ftable:setDefaultCellProperties("button", { height = config.mapRowHeight })
	ftable:setDefaultComplexCellProperties("button", "text", { fontsize = config.mapFontSize })

	--  [+/-] [Object Name][Location] [Sub_1] [Sub_2] [Sub_3] ... [Sub_N] [Shield/Hull Bar]
	ftable:setColWidth(1, Helper.scaleY(config.mapRowHeight), false)
	ftable:setDefaultBackgroundColSpan(2, 4 + maxicons)
	ftable:setColWidthMinPercent(2, 14)
	ftable:setColWidthMinPercent(4, 5)
	for i = 1, maxicons do
		ftable:setColWidth(5 + i - 1, infoTableData.shipIconWidth, false)
	end
	ftable:setColWidth(5 + maxicons, infoTableData.shipIconWidth, false)

	local row = ftable:addRow(false, { fixed = true, bgColor = Helper.defaultTitleBackgroundColor })
	row[1]:setColSpan(5 + maxicons):createText(ReadText(1001, 1000), Helper.headerRowCenteredProperties)

	infoTableData.stations = { }
	infoTableData.fleetLeaderShips = { }
	infoTableData.unassignedShips = { }
	infoTableData.constructionShips = { }
	infoTableData.inventoryShips = { }
	infoTableData.deployables = { }
	infoTableData.subordinates = { }
	infoTableData.dockedships = { }
	infoTableData.constructions = { }
	infoTableData.moduledata = { }

	local onlineitems = {}
	if menu.propertyMode == "inventoryships" then
		onlineitems = OnlineGetUserItems(false)
		local persistentonlineitems = OnlineGetUserItems(true)
		for k, v in pairs(persistentonlineitems) do
			onlineitems[k] = v
		end
	end

	local playerobjects = {}
	if Helper.isPlayerCovered() and (not C.IsUICoverOverridden()) then
		playerobjects[1] = ConvertStringTo64Bit(tostring(C.GetPlayerOccupiedShipID()))
	else
		playerobjects = GetContainedObjectsByOwner("player")
	end
	for i = #playerobjects, 1, -1 do
		local object = playerobjects[i]
		local object64 = ConvertIDTo64Bit(object)
		if menu.isObjectValid(object64) then
			local hull, purpose, uirelation = GetComponentData(object, "hullpercent", "primarypurpose", "uirelation")
			playerobjects[i] = { id = object, name = ffi.string(C.GetComponentName(object64)), fleetname = menu.getFleetName(object64), objectid = ffi.string(C.GetObjectIDCode(object64)), class = ffi.string(C.GetComponentClass(object64)), hull = hull, purpose = purpose, relation = uirelation }
		else
			table.remove(playerobjects, i)
		end
	end

	table.sort(playerobjects, menu.componentSorter(menu.propertySorterType))

	for _, entry in ipairs(playerobjects) do
		local object = entry.id
		local object64 = ConvertIDTo64Bit(object)
		-- Determine subordinates that may appear in the menu
		local subordinates = {}
		if C.IsComponentClass(object64, "controllable") then
			subordinates = GetSubordinates(object)
		end
		for i = #subordinates, 1, -1 do
			local subordinate = subordinates[i]
			if not menu.isObjectValid(ConvertIDTo64Bit(subordinate)) then
				table.remove(subordinates, i)
			end
		end
		subordinates.hasRendered = #subordinates > 0
		infoTableData.subordinates[tostring(object)] = subordinates
		-- Find docked ships
		local dockedships = {}
		if C.IsComponentClass(object64, "container") then
			Helper.ffiVLA(dockedships, "UniverseID", C.GetNumDockedShips, C.GetDockedShips, object64, nil)
		end
		for i = #dockedships, 1, -1 do
			local convertedID = ConvertStringToLuaID(tostring(dockedships[i]))
			local loccommander = GetCommander(convertedID)
			if not loccommander then
				dockedships[i] = convertedID
			else
				table.remove(dockedships, i)
			end
		end
		infoTableData.dockedships[tostring(object)] = dockedships
		-- Check if object is station, fleet leader or unassigned
		local commander
		if C.IsComponentClass(object64, "controllable") then
			commander = GetCommander(object)
		end
		if not commander then
			if C.IsRealComponentClass(object64, "station") then
				table.insert(infoTableData.stations, object)
			elseif GetComponentData(object, "isdeployable") or C.IsComponentClass(object64, "lockbox") then
				table.insert(infoTableData.deployables, object)
			elseif #subordinates > 0 then
				table.insert(infoTableData.fleetLeaderShips, object)
			else
				table.insert(infoTableData.unassignedShips, object)
			end
		end

		if C.IsRealComponentClass(object64, "station") then
			local constructions = {}
			local constructionshipsbymacro = {}
			-- builds in progress
			local n = C.GetNumBuildTasks(object64, 0, true, false)
			local buf = ffi.new("BuildTaskInfo[?]", n)
			n = C.GetBuildTasks(buf, n, object64, 0, true, false)
			for i = 0, n - 1 do
				table.insert(constructions, { id = buf[i].id, buildingcontainer = buf[i].buildingcontainer, component = buf[i].component, macro = ffi.string(buf[i].macro), factionid = ffi.string(buf[i].factionid), buildercomponent = buf[i].buildercomponent, price = buf[i].price, ismissingresources = buf[i].ismissingresources, queueposition = buf[i].queueposition, inprogress = true })
			end
			if #constructions > 0 then
				table.insert(constructions, { empty = true })
			end
			-- other builds
			local n = C.GetNumBuildTasks(object64, 0, false, false)
			local buf = ffi.new("BuildTaskInfo[?]", n)
			n = C.GetBuildTasks(buf, n, object64, 0, false, false)
			for i = 0, n - 1 do
				local component = buf[i].component
				local macro = ffi.string(buf[i].macro)
				if (component == 0) and (macro ~= "") then
					if constructionshipsbymacro[macro] then
						constructions[constructionshipsbymacro[macro]].amount = constructions[constructionshipsbymacro[macro]].amount + 1
					else
						table.insert(constructions, { id = buf[i].id, buildingcontainer = buf[i].buildingcontainer, component = component, macro = macro, factionid = ffi.string(buf[i].factionid), buildercomponent = buf[i].buildercomponent, price = buf[i].price, ismissingresources = buf[i].ismissingresources, queueposition = buf[i].queueposition, inprogress = false, amount = 1 })
						constructionshipsbymacro[macro] = #constructions
					end
				else
					table.insert(constructions, { id = buf[i].id, buildingcontainer = buf[i].buildingcontainer, component = component, macro = macro, factionid = ffi.string(buf[i].factionid), buildercomponent = buf[i].buildercomponent, price = buf[i].price, ismissingresources = buf[i].ismissingresources, queueposition = buf[i].queueposition, inprogress = false })
				end
			end
			infoTableData.constructions[tostring(object)] = constructions
		elseif C.IsComponentClass(object64, "ship") then
			if menu.propertyMode == "inventoryships" then
				local pilot = ConvertIDTo64Bit(GetComponentData(object, "assignedpilot"))
				if pilot and (pilot ~= C.GetPlayerID()) then
					local inventory = GetInventory(pilot)
					if next(inventory) then
						local sortedWares = {}
						for ware, entry in pairs(inventory) do
							local ispersonalupgrade = GetWareData(ware, "ispersonalupgrade")
							if (not ispersonalupgrade) and (not onlineitems[ware]) then
								table.insert(infoTableData.inventoryShips, object)
								break
							end
						end
					end
				end
			end
		end
	end

	local constructionshipsbymacro = {}
	local n = C.GetNumPlayerShipBuildTasks(true, false)
	local buf = ffi.new("BuildTaskInfo[?]", n)
	n = C.GetPlayerShipBuildTasks(buf, n, true, false)
	for i = 0, n - 1 do
		local factionid = ffi.string(buf[i].factionid)
		if factionid == "player" then
			table.insert(infoTableData.constructionShips, { id = buf[i].id, buildingcontainer = buf[i].buildingcontainer, component = buf[i].component, macro = ffi.string(buf[i].macro), factionid = factionid, buildercomponent = buf[i].buildercomponent, price = buf[i].price, ismissingresources = buf[i].ismissingresources, queueposition = buf[i].queueposition, inprogress = true })
		end
	end
	if #infoTableData.constructionShips > 0 then
		table.insert(infoTableData.constructionShips, { empty = true })
	end
	local n = C.GetNumPlayerShipBuildTasks(false, false)
	local buf = ffi.new("BuildTaskInfo[?]", n)
	n = C.GetPlayerShipBuildTasks(buf, n, false, false)
	for i = 0, n - 1 do
		local factionid = ffi.string(buf[i].factionid)
		if factionid == "player" then
			local component = buf[i].component
			local macro = ffi.string(buf[i].macro)
			if (component == 0) and (macro ~= "") then
				if constructionshipsbymacro[macro] then
					infoTableData.constructionShips[constructionshipsbymacro[macro]].amount = infoTableData.constructionShips[constructionshipsbymacro[macro]].amount + 1
				else
					table.insert(infoTableData.constructionShips, { id = buf[i].id, buildingcontainer = buf[i].buildingcontainer, component = component, macro = macro, factionid = factionid, buildercomponent = buf[i].buildercomponent, price = buf[i].price, ismissingresources = buf[i].ismissingresources, queueposition = buf[i].queueposition, inprogress = false, amount = 1 })
					constructionshipsbymacro[macro] = #infoTableData.constructionShips
				end
			else
				table.insert(infoTableData.constructionShips, { id = buf[i].id, buildingcontainer = buf[i].buildingcontainer, component = component, macro = macro, factionid = factionid, buildercomponent = buf[i].buildercomponent, price = buf[i].price, ismissingresources = buf[i].ismissingresources, queueposition = buf[i].queueposition, inprogress = false })
			end
		end
	end

	local numdisplayed = 0
	local maxvisibleheight = ftable:getFullHeight()
	if menu.mode ~= "selectCV" then
		if (menu.propertyMode == "stations") or (menu.propertyMode == "propertyall") then
			numdisplayed = menu.createPropertySection(instance, "ownedstations", ftable, ReadText(1001, 8379), infoTableData.stations, "-- " .. ReadText(1001, 33) .. " --", true, numdisplayed, nil, menu.propertySorterType)
		end
	end
	if (menu.propertyMode == "fleets") or (menu.propertyMode == "propertyall") then
		numdisplayed = menu.createPropertySection(instance, "ownedfleets", ftable, ReadText(1001, 8326), infoTableData.fleetLeaderShips, "-- " .. ReadText(1001, 34) .. " --", nil, numdisplayed, nil, menu.propertySorterType)			-- {1001,8326} = Fleets
	end
	if (menu.propertyMode == "unassignedships") or (menu.propertyMode == "propertyall") then
		numdisplayed = menu.createPropertySection(instance, "ownedships", ftable, ReadText(1001, 8327), infoTableData.unassignedShips, "-- " .. ReadText(1001, 34) .. " --", nil, numdisplayed, nil, menu.propertySorterType)	-- {1001,8327} = Unassigned Ships
	end
	if menu.propertyMode == "inventoryships" then
		numdisplayed = menu.createPropertySection(instance, "inventoryships", ftable, ReadText(1001, 8381), infoTableData.inventoryShips, "-- " .. ReadText(1001, 34) .. " --", nil, numdisplayed, true, menu.propertySorterType)	-- {1001,8327} = Ships with Inventory
	end
	if (menu.propertyMode == "unassignedships") or (menu.propertyMode == "propertyall") then
		-- construction rows do not use the shield/hull bar widget
		menu.createConstructionSection(instance, "constructionships", ftable, ReadText(1001, 8328), infoTableData.constructionShips)
	end
	if menu.mode ~= "selectCV" then
		if menu.propertyMode == "deployables" then
			numdisplayed = menu.createPropertySection(instance, "owneddeployables", ftable, ReadText(1001, 1332), infoTableData.deployables, "-- " .. ReadText(1001, 34) .. " --", nil, numdisplayed, nil, menu.propertySorterType)
		end
	end

	if numdisplayed > 50 then
		ftable.properties.maxVisibleHeight = maxvisibleheight + 50 * (Helper.scaleY(config.mapRowHeight) + Helper.borderSize)
	end

	menu.numFixedRows = ftable.numfixedrows

	menu.settoprow = ((not menu.settoprow) or (menu.settoprow == 0)) and ((menu.setrow and menu.setrow > 31) and (menu.setrow - 27) or 3) or menu.settoprow
	ftable:setTopRow(menu.settoprow)
	if menu.infoTable then
		local result = GetShiftStartEndRow(menu.infoTable)
		if result then
			ftable:setShiftStartEnd(table.unpack(result))
		end
	end
	ftable:setSelectedRow(menu.sethighlightborderrow or menu.setrow)
	menu.setrow = nil
	menu.settoprow = nil
	menu.setcol = nil
	menu.sethighlightborderrow = nil

	local tabtable = frame:addTable(#config.propertyCategories + 3, { tabOrder = 2, reserveScrollBar = false })
	for i = 1, #config.propertyCategories do
		tabtable:setColWidth(i, menu.sideBarWidth, false)
	end
	local sorterWidth = menu.infoTableWidth - 3 * (menu.sideBarWidth + Helper.borderSize) - (#config.propertyCategories - 1) * Helper.borderSize
	local availableWidthForExtraColumns = menu.infoTableWidth - #config.propertyCategories * (menu.sideBarWidth + Helper.borderSize) - 2 * Helper.borderSize
	local colwidth = sorterWidth / 3
	local colspan = 3
	if colwidth > 3 * menu.sideBarWidth + 2 * Helper.borderSize then
		colspan = 4
	elseif colwidth < 2 * menu.sideBarWidth + Helper.borderSize then
		colspan = 2
		colwidth = (menu.infoTableWidth - 6 * (menu.sideBarWidth + Helper.borderSize) - 2 * Helper.borderSize) / 2
	end

	if 2 * colwidth >= availableWidthForExtraColumns then
		colwidth = math.floor((availableWidthForExtraColumns - 1) / 2)
	end

	tabtable:setColWidth(#config.propertyCategories + 2, colwidth, false)
	tabtable:setColWidth(#config.propertyCategories + 3, colwidth, false)

	local row = tabtable:addRow("property_tabs", { fixed = true, bgColor = Helper.color.transparent })
	for i, entry in ipairs(config.propertyCategories) do
		local bgcolor = Helper.defaultTitleBackgroundColor
		local color = Helper.color.white
		if entry.category == menu.propertyMode then
			bgcolor = Helper.defaultArrowRowBackgroundColor
		end

		local active = true
		if menu.mode == "selectCV" then
			active = entry.category == "propertyall"
		elseif (menu.mode == "selectComponent") and (menu.modeparam[3] == "deployables") then
			active = entry.category == "deployables"
			if active and (menu.selectedCols.propertytabs == nil) then
				menu.selectedCols.propertytabs = i
			end
		end

		row[i]:createButton({ height = menu.sideBarWidth, bgColor = bgcolor, mouseOverText = entry.name, scaling = false, helpOverlayID = entry.helpOverlayID, helpOverlayText = entry.helpOverlayText, active = active }):setIcon(entry.icon, { color = color})
		row[i].handlers.onClick = function () return menu.buttonPropertySubMode(entry.category, i) end
	end

	local row = tabtable:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
	row[1]:setColSpan(3):createText(ReadText(1001, 2906) .. ReadText(1001, 120))

	local buttonheight = Helper.scaleY(config.mapRowHeight)
	local button = row[4]:setColSpan(colspan):createButton({ scaling = false, height = buttonheight }):setText(ReadText(1001, 8026), { halign = "center", scaling = true })
	if menu.propertySorterType == "class" then
		button:setIcon("table_arrow_inv_down", { width = buttonheight, height = buttonheight, x = button:getColSpanWidth() - buttonheight })
	elseif menu.propertySorterType == "classinverse" then
		button:setIcon("table_arrow_inv_up", { width = buttonheight, height = buttonheight, x = button:getColSpanWidth() - buttonheight })
	end
	row[4].handlers.onClick = function () return menu.buttonPropertySorter("class") end
	local button = row[#config.propertyCategories + colspan - 2]:setColSpan(5 - colspan):createButton({ scaling = false, height = buttonheight }):setText(ReadText(1001, 2809), { halign = "center", scaling = true })
	if menu.propertySorterType == "name" then
		button:setIcon("table_arrow_inv_down", { width = buttonheight, height = buttonheight, x = button:getColSpanWidth() - buttonheight })
	elseif menu.propertySorterType == "nameinverse" then
		button:setIcon("table_arrow_inv_up", { width = buttonheight, height = buttonheight, x = button:getColSpanWidth() - buttonheight })
	end
	row[#config.propertyCategories + colspan - 2].handlers.onClick = function () return menu.buttonPropertySorter("name") end
	local button = row[#config.propertyCategories + 3]:createButton({ scaling = false, height = buttonheight }):setText(ReadText(1001, 1), { halign = "center", scaling = true })
	if menu.propertySorterType == "hull" then
		button:setIcon("table_arrow_inv_down", { width = buttonheight, height = buttonheight, x = button:getColSpanWidth() - buttonheight })
	elseif menu.propertySorterType == "hullinverse" then
		button:setIcon("table_arrow_inv_up", { width = buttonheight, height = buttonheight, x = button:getColSpanWidth() - buttonheight })
	end
	row[#config.propertyCategories + 3].handlers.onClick = function () return menu.buttonPropertySorter("hull") end
	
	tabtable:setSelectedRow(menu.selectedRows.propertytabs or menu.selectedRows.infotable2 or 0)
	tabtable:setSelectedCol(menu.selectedCols.propertytabs or Helper.currentTableCol[menu.infoTable2] or 0)
	menu.selectedRows.propertytabs = nil
	menu.selectedCols.propertytabs = nil

	ftable.properties.y = tabtable.properties.y + tabtable:getFullHeight() + Helper.borderSize

	tabtable:addConnection(1, 2, true)
	ftable:addConnection(2, 2)
end
function menu.createPropertyRow(instance, ftable, component, iteration, commanderlocation, showmodules, hidesubordinates, numdisplayed, sorter)
	local maxicons = menu.infoTableData[instance].maxIcons

	local subordinates = menu.infoTableData[instance].subordinates[tostring(component)] or {}
	local dockedships = menu.infoTableData[instance].dockedships[tostring(component)] or {}
	local constructions = menu.infoTableData[instance].constructions[tostring(component)] or {}
	local convertedComponent = ConvertStringTo64Bit(tostring(component))

	if (#menu.searchtext == 0) or Helper.textArrayHelper(menu.searchtext, function (numtexts, texts) return C.FilterComponentByText(convertedComponent, numtexts, texts, true) end, "text") then
		numdisplayed = numdisplayed + 1

		if (not menu.isPropertyExtended(tostring(component))) and (menu.isCommander(component) or menu.isConstructionContext(convertedComponent)) then
			menu.extendedproperty[tostring(component)] = true
		end
		if (not menu.isPropertyExtended(tostring(component))) and menu.isDockContext(convertedComponent) then
			if menu.infoTableMode ~= "propertyowned" then
				menu.extendedproperty[tostring(component)] = true
			end
		end

		local isstation = IsComponentClass(component, "station")
		local isdoublerow = (iteration == 0 and (isstation or #subordinates > 0))
		local name, color, bgcolor, font, mouseover, factioncolor = menu.getContainerNameAndColors(component, iteration, isdoublerow, false)
		local alertString = ""
		local alertMouseOver = ""
		if menu.getFilterOption("layer_think") then
			local alertStatus, missionlist = menu.getContainerAlertLevel(component)
			local minAlertLevel = menu.getFilterOption("think_alert")
			if (minAlertLevel ~= 0) and alertStatus >= minAlertLevel then
				local color = Helper.color.white
				if alertStatus == 1 then
					color = menu.holomapcolor.lowalertcolor
				elseif alertStatus == 2 then
					color = menu.holomapcolor.mediumalertcolor
				else
					color = menu.holomapcolor.highalertcolor
				end
				alertString = Helper.convertColorToText(color) .. "\027[workshop_error]\027X"
				alertMouseOver = ReadText(1001, 3305) .. ReadText(1001, 120) .. "\n" .. missionlist
			end
		end
		local location, locationtext, isdocked, aipilot, isplayerowned, isonlineobject, iscovered, isenemy, macro = GetComponentData(component, "sectorid", "sector", "isdocked", "assignedaipilot", "isplayerowned", "isonlineobject", "iscovered", "isenemy", "macro")
		if isplayerowned and iscovered then
			alertString = alertString .. factioncolor .. "\27[menu_hidden]\27X"
		end

		if menu.mode == "selectCV" then
			if isenemy then
				mouseover = "\027R" .. ReadText(1026, 8014) .. "\027X"
			elseif C.IsBuilderBusy(convertedComponent) then
				mouseover = "\027R" .. ReadText(1001, 7939) .. "\027X"
			elseif not isplayerowned then
				local fee = tonumber(C.GetBuilderHiringFee())
				mouseover = ((fee > GetPlayerMoney()) and "\027R" or "\027G") .. ReadText(1001, 7940) .. ReadText(1001, 120) .. " " .. ConvertMoneyString(fee, false, true, nil, true) .. " " .. ReadText(1001, 101) .. "\027X"
			end
		end

		local row = ftable:addRow({"property", component, nil, iteration}, { bgColor = bgcolor, multiSelected = menu.isSelectedComponent(component) })
		if (menu.getNumSelectedComponents() == 1) and menu.isSelectedComponent(component) then
			menu.setrow = row.index
		end
		if IsSameComponent(component, menu.highlightedbordercomponent) then
			menu.sethighlightborderrow = row.index
		end

		-- Set up columns
		--  [+/-] [Object Name] [Top Level Shield/Hull Bar] [Location] [Sub_1] [Sub_2] [Sub_3] ... [Sub_N or Shield/Hull Bar]
		if showmodules or (subordinates.hasRendered and (not hidesubordinates)) or (#dockedships > 0) or (isstation and (#constructions > 0)) then
			row[1]:createButton({ scaling = false }):setText(menu.isPropertyExtended(tostring(component)) and "-" or "+", { scaling = true, halign = "center" })
			row[1].handlers.onClick = function () return menu.buttonExtendProperty(tostring(component)) end
		end

		local displaylocation = location and not (commanderlocation and IsSameComponent(location, commanderlocation))
		local currentordericon, currentorderrawicon, currentordercolor, currentordername, currentorderisoverride, currentordermouseovertext = "", "", nil, "", false
		if IsComponentClass(component, "ship") then
			currentordericon, currentorderrawicon, currentordercolor, currentordername, currentorderisoverride, currentordermouseovertext = menu.getOrderInfo(convertedComponent)
		end
		local fleettypes = IsComponentClass(component, "controllable") and menu.getPropertyOwnedFleetData(instance, component, maxicons) or {}

		if isplayerowned and isonlineobject then
			locationtext = Helper.convertColorToText(menu.holomapcolor.visitorcolor) .. ReadText(1001, 11231) .. "\27X"
			currentordericon = Helper.convertColorToText(menu.holomapcolor.visitorcolor) .. "\27[order_venture]\27X"
			currentorderrawicon = "order_venture"
			currentordercolor = menu.holomapcolor.visitorcolor
			currentordername = ReadText(1001, 7868)
			currentordermouseovertext = nil
			isdocked = false
		end

		local namecolspan = 1
		if menu.infoTableMode == "objectlist" then
			displaylocation = false
		end
		if not displaylocation then
			if (currentordericon ~= "") or isdocked then
				namecolspan = namecolspan + maxicons - 2
			else
				namecolspan = namecolspan + maxicons
			end
		end

		if isdoublerow then
			if isstation then
				-- station case
				local secondline = ""
				if displaylocation then
					secondline = locationtext
				end
				row[2]:setColSpan(4 + maxicons - #fleettypes - 1)
				local stationname = alertString .. Helper.convertColorToText(color) .. name .. "\27X"
				local stationnametruncated = TruncateText(stationname, font, Helper.scaleFont(font, config.mapFontSize), row[2]:getColSpanWidth() - Helper.scaleX(Helper.standardTextOffsetx))
				if stationnametruncated ~= stationname then
					mouseover = stationname .. ((mouseover ~= "") and ("\n" .. mouseover) or "")
				end
				if alertMouseOver ~= "" then
					if mouseover ~= "" then
						mouseover = mouseover .. "\n\n"
					end
					mouseover = mouseover .. alertMouseOver
				end
				row[2]:createText(stationname .. "\n" .. secondline, { font = font, mouseOverText = mouseover })
			else
				-- fleet case
				local textheight = C.GetTextHeight(" \n ", font, Helper.scaleFont(font, config.mapFontSize), Helper.viewWidth)
				local icon = row[2]:setColSpan(4 + maxicons - #fleettypes - 1):createIcon("solid", { scaling = false, color = { r = 0, g = 0, b = 0, a = 1 }, height = textheight })
				
				local secondtext1 = ""
				local secondtext2 = ""
				if displaylocation or (currentordericon ~= "") or isdocked then
					if displaylocation then
						secondtext1 = locationtext
					end
					secondtext2 = (currentordericon ~= "") and currentordericon or ""
					if isdocked then
						secondtext2 = secondtext2 .. " \27[order_dockat]"
					end
				end
				secondtext1truncated = TruncateText(secondtext1, font, Helper.scaleFont(font, config.mapFontSize), icon:getColSpanWidth() - Helper.scaleX(Helper.standardTextOffsetx))
				local secondtext1width = C.GetTextWidth(secondtext1truncated, font, Helper.scaleFont(font, config.mapFontSize))
				local secondtext2width = C.GetTextWidth(secondtext2, font, Helper.scaleFont(font, config.mapFontSize))

				local fleetname = ffi.string(C.GetFleetName(convertedComponent))
				local shipname = alertString .. name
				local fleetnametruncated = TruncateText(fleetname, font, Helper.scaleFont(font, config.mapFontSize), icon:getColSpanWidth() - Helper.scaleX(Helper.standardTextOffsetx) - secondtext1width - Helper.scaleX(10))
				local shipnametruncated = TruncateText(shipname, font, Helper.scaleFont(font, config.mapFontSize), icon:getColSpanWidth() - Helper.scaleX(Helper.standardTextOffsetx) - secondtext2width - Helper.scaleX(10))

				local mouseovertext = ""
				if fleetnametruncated ~= fleetname then
					mouseovertext = mouseovertext .. fleetname
				end
				if shipnametruncated ~= shipname then
					if mouseovertext ~= "" then
						mouseovertext = mouseovertext .. "\n"
					end
					mouseovertext = mouseovertext .. alertString .. Helper.convertColorToText(color) .. name .. "\27X"
				end
				if secondtext1truncated ~= secondtext1 then
					if mouseovertext ~= "" then
						mouseovertext = mouseovertext .. "\n"
					end
					mouseovertext = mouseovertext .. secondtext1
				end
				if currentordername ~= "" then
					if mouseovertext ~= "" then
						mouseovertext = mouseovertext .. "\n"
					end
					mouseovertext = mouseovertext .. currentordername .. (currentordermouseovertext and ("\n\27R" .. currentordermouseovertext .. "\27X") or "")
				end
				if alertMouseOver ~= "" then
					if mouseovertext ~= "" then
						mouseovertext = mouseovertext .. "\n\n"
					end
					mouseovertext = mouseovertext .. alertMouseOver
				end
				icon.properties.mouseOverText = mouseovertext

				icon:setText(string.format("%s\n%s%s", fleetnametruncated, Helper.convertColorToText(color), shipnametruncated), { scaling = true, font = font, x = Helper.standardTextOffsetx })
				icon:setText2(currentorderisoverride and function () return menu.overrideOrderIcon(currentordercolor, true, currentorderrawicon, secondtext1truncated .. "\n", isdocked and "\27[order_dockat]" or "") end or (secondtext1truncated .. "\n" .. secondtext2), { scaling = true, font = font, halign = "right", x = Helper.standardTextOffsetx })
			end
			-- fleet info
			for i, fleetdata in ipairs(fleettypes) do
				local colidx = 5 + maxicons - #fleettypes + i - 1
				if fleetdata.icon then
					row[colidx]:createText(string.format("\027[%s]\n%d", fleetdata.icon, fleetdata.count), { halign = "center", x = 0 })
				else
					row[colidx]:createText(string.format("...\n%d", fleetdata.count), { halign = "center", x = 0 })
				end
			end
			-- shieldhullbar
			row[5 + maxicons]:createObjectShieldHullBar(component, { y = isstation and Helper.standardTextHeight / 2 or 1.5 * Helper.standardTextHeight })
		else
			-- unassigned ship case
			row[2]:setColSpan(namecolspan + 1)
			local indentation, actualname = string.match(name, "([ ]*)(.*)")
			local shipname = indentation .. alertString .. actualname
			local shipnametruncated = TruncateText(shipname, font, Helper.scaleFont(font, config.mapFontSize), row[2]:getColSpanWidth() - Helper.scaleX(Helper.standardTextOffsetx))
			if shipnametruncated ~= shipname then
				mouseover = indentation .. alertString .. actualname .. "\27X" .. ((mouseover ~= "") and ("\n" .. mouseover) or "")
			end
			if alertMouseOver ~= "" then
				if mouseover ~= "" then
					mouseover = mouseover .. "\n\n"
				end
				mouseover = mouseover .. alertMouseOver
			end
			row[2]:createText(shipname, { font = font, color = color, mouseOverText = mouseover })
			-- location / order
			if displaylocation then
				local colspan = 5 + maxicons - 3 - namecolspan
				if currentordericon ~= "" then
					colspan = colspan - 1
				end
				if isdocked then
					colspan = colspan - 1
				end
				row[3 + namecolspan]:setColSpan(colspan)
				local locationtexttruncated = TruncateText(locationtext, font, Helper.scaleFont(font, config.mapFontSize), row[3 + namecolspan]:getColSpanWidth())
				local mouseovertext = ""
				if locationtexttruncated ~= locationtext then
					mouseovertext = locationtext
				end
				row[3 + namecolspan]:createText(locationtext, { halign = "right", font = font, mouseOverText = mouseovertext, x = 0 })
			end
			if (currentordericon ~= "") or isdocked then
				if isdocked then
					row[4 + maxicons]:createIcon("order_dockat", { width = config.mapRowHeight, height = config.mapRowHeight, mouseOverText = ReadText(1001, 3249) })
					if currentordericon ~= "" then
						row[3 + maxicons]:createIcon(currentorderrawicon, { color = currentorderisoverride and function () return menu.overrideOrderIcon(currentordercolor, false) end or currentordercolor, width = config.mapRowHeight, height = config.mapRowHeight, mouseOverText = currentordername .. (currentordermouseovertext and ("\n\27R" .. currentordermouseovertext .. "\27X") or "") })
					end
				else
					row[4 + maxicons]:createIcon(currentorderrawicon, { color = currentorderisoverride and function () return menu.overrideOrderIcon(currentordercolor, false) end or currentordercolor, width = config.mapRowHeight, height = config.mapRowHeight, mouseOverText = currentordername .. (currentordermouseovertext and ("\n\27R" .. currentordermouseovertext .. "\27X") or "") })
				end
			end
			-- shieldhullbar
			row[5 + maxicons]:createObjectShieldHullBar(component)
		end

		if row[1].type == "button" then
			if isdoublerow and (not isstation) then
				row[1].properties.height = row[2]:getHeight()
			else
				row[1].properties.height = row[2]:getMinTextHeight(true)
			end
		end

		if IsComponentClass(component, "station") then
			AddKnownItem("stationtypes", macro)
		elseif IsComponentClass(component, "ship_xl") then
			AddKnownItem("shiptypes_xl", macro)
		elseif IsComponentClass(component, "ship_l") then
			AddKnownItem("shiptypes_l", macro)
		elseif IsComponentClass(component, "ship_m") then
			AddKnownItem("shiptypes_m", macro)
		elseif GetMacroData(macro, "islasertower") then
			AddKnownItem("lasertowers", macro)
		elseif IsComponentClass(component, "ship_s") then
			AddKnownItem("shiptypes_s", macro)
		elseif IsComponentClass(component, "ship_xs") then
			AddKnownItem("shiptypes_xs", macro)
		end

		if menu.isPropertyExtended(tostring(component)) then
			-- modules
			if showmodules then
				menu.createModuleSection(instance, ftable, component, iteration)
			end
			-- subordinates
			if subordinates.hasRendered and (not hidesubordinates) then
				numdisplayed = menu.createSubordinateSection(instance, ftable, component, isstation, iteration, location or commanderlocation, numdisplayed, sorter)
			end
			-- dockedships
			if #dockedships > 0 then
				local isdockedshipsextended = menu.isDockedShipsExtended(tostring(component), isstation)
				if (not isdockedshipsextended) and menu.isDockContext(convertedComponent) then
					if menu.infoTableMode ~= "propertyowned" then
						menu.extendeddockedships[tostring(component)] = true
						isdockedshipsextended = true
					end
				end

				local row = ftable:addRow({"dockedships", component}, { bgColor = Helper.color.transparent })
				row[1]:createButton():setText(isdockedshipsextended and "-" or "+", { halign = "center" })
				row[1].handlers.onClick = function () return menu.buttonExtendDockedShips(tostring(component), isstation) end
				local text = ReadText(1001, 3265)
				for i = 1, iteration + 1 do
					text = "    " .. text
				end
				row[2]:setColSpan(3):createText(text)
				if IsSameComponent(component, menu.highlightedbordercomponent) and (menu.highlightedborderstationcategory == "dockedships") then
					menu.sethighlightborderrow = row.index
				end
				if isdockedshipsextended then
					dockedships = menu.sortComponentListHelper(dockedships, sorter)
					for _, dockedship in ipairs(dockedships) do
						numdisplayed = menu.createPropertyRow(instance, ftable, dockedship, iteration + 2, location or commanderlocation, nil, true, numdisplayed, sorter)
					end
				end
			end
			if isstation then
				-- construction
				if #constructions > 0 then
					menu.createConstructionSubSection(ftable, component, constructions)
				end
			end
		end
	end

	return numdisplayed
end
function menu.createSideBar(firsttime, frame, width, height, offsetx, offsety)
	local spacingHeight = menu.sideBarWidth / 4
	local ftable = frame:addTable(1, { tabOrder = 3, width = width, height = height, x = offsetx, y = offsety, scaling = false, borderEnabled = false, reserveScrollBar = false, defaultInteractiveObject = menu.infoTableMode == nil })
	ftable:addConnection(1, 1, true)

	local firstactive, foundselection
	local leftbar = menu.showMultiverse and config.leftBarMultiverse or config.leftBar
	for _, entry in ipairs(leftbar) do
		if (entry.condition == nil) or entry.condition() then
			if not entry.spacing then
				entry.active = true
				if menu.showMultiverse then
					if entry.mode ~= "ventureseason" then
						local isonline = Helper.isOnlineGame()
						entry.active = isonline
					end
				else
					if menu.mode == "selectCV" then
						if (entry.mode ~= "objectlist") and (entry.mode ~= "propertyowned") then
							entry.active = false
						end
					elseif menu.mode == "hire" then
						if entry.mode ~= "propertyowned" then
							entry.active = false
						end
					elseif menu.mode == "orderparam_object" then
						if (entry.mode ~= "objectlist") and (entry.mode ~= "propertyowned") then
							entry.active = false
						end
					elseif menu.mode == "selectComponent" then
						if (entry.mode ~= "objectlist") and (entry.mode ~= "propertyowned") then
							entry.active = false
						end
					end
				end
				if entry.active then
					local selectedmode = false
					if type(entry.mode) == "table" then
						for _, mode in ipairs(entry.mode) do
							if mode == menu.infoTableMode then
								selectedmode = true
								break
							end
						end
					else
						if entry.mode == menu.infoTableMode then
							selectedmode = true
						end
					end
					if selectedmode then
						firstactive = nil
						foundselection = true
					end
					if (not foundselection) and (not firstactive) then
						firstactive = entry.mode
					end
				end
			end
		end
	end
	if firstactive and firsttime then
		menu.infoTableMode = firstactive
		firstactive = nil
	end

	for _, entry in ipairs(leftbar) do
		if (entry.condition == nil) or entry.condition() then
			if entry.spacing then
				local row = ftable:addRow(false, { fixed = true })
				row[1]:createIcon("mapst_seperator_line", { width = menu.sideBarWidth, height = spacingHeight })
			else
				local mode = entry.mode
				if type(entry.mode) == "table" then
					mode = mode[1]
				end
				local row = ftable:addRow(true, { fixed = true })
				local bgcolor = Helper.defaultTitleBackgroundColor
				if type(entry.mode) == "table" then
					for _, mode in ipairs(entry.mode) do
						if mode == menu.infoTableMode then
							bgcolor = Helper.defaultArrowRowBackgroundColor
							break
						end
					end
				else
					if entry.mode == menu.infoTableMode then
						bgcolor = Helper.defaultArrowRowBackgroundColor
					end
				end
				local color = Helper.color.white
				if menu.highlightLeftBar[mode] then
					color = Helper.color.mission
				end
				
				row[1]:createButton({ active = entry.active, height = menu.sideBarWidth, bgColor = bgcolor, mouseOverText = entry.name, helpOverlayID = entry.helpOverlayID, helpOverlayText = entry.helpOverlayText }):setIcon(entry.icon, { color = color })
				row[1].handlers.onClick = function () return menu.buttonToggleObjectList(mode) end
			end
		end
	end

	ftable:setSelectedRow(menu.selectedRows.sideBar)
	menu.selectedRows.sideBar = nil
end
function menu.createMissionContext(frame)
	local tablespacing = Helper.standardTextHeight
	local maxObjectiveLines = 10

	-- description table
	local desctable = frame:addTable(1, { tabOrder = 3, highlightMode = "off", maxVisibleHeight = menu.contextMenuData.descriptionHeight, x = Helper.borderSize, y = Helper.borderSize, width = menu.contextMenuData.width })

	-- title
	local visibleHeight
	local row = desctable:addRow(false, { fixed = true })
	row[1]:createText(menu.contextMenuData.name, Helper.headerRowCenteredProperties)

	-- briefing icon if any
	local icontable
	if menu.contextMenuData.briefingicon then
		icontable = frame:addTable(1, { tabOrder = 0, highlightMode = "off", maxVisibleHeight = menu.contextMenuData.descriptionHeight, x = Helper.borderSize, y = desctable.properties.y + desctable:getFullHeight() + Helper.borderSize, width = menu.contextMenuData.briefingiconwidth })

		local row = icontable:addRow(nil, { bgColor = Helper.color.transparent })
		row[1]:createIcon(menu.contextMenuData.briefingicon, { scaling = false, height = menu.contextMenuData.briefingiconwidth })
		
		local row = icontable:addRow(nil, { bgColor = Helper.color.transparent })
		row[1]:createText(menu.contextMenuData.briefingiconcaption, { wordwrap = true })
	end

	-- description
	for linenum, descline in ipairs(menu.contextMenuData.description) do
		local row = desctable:addRow(true, { bgColor = Helper.color.transparent })
		row[1]:createText(descline, { scaling = false, fontsize = Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), x = menu.contextMenuData.briefingiconwidth and (menu.contextMenuData.briefingiconwidth + Helper.borderSize + Helper.scaleX(Helper.standardTextOffsetx)) or nil, minRowHeight = Helper.scaleY(Helper.standardTextHeight) })
		if linenum == menu.contextMenuData.descriptionLines then
			visibleHeight = desctable:getFullHeight()
		end
	end
	if visibleHeight then
		desctable.properties.maxVisibleHeight = visibleHeight
	else
		desctable.properties.maxVisibleHeight = desctable:getFullHeight()
	end

	local objectiveOffsetY = desctable.properties.y + desctable:getVisibleHeight()
	if icontable then
		objectiveOffsetY = math.max(objectiveOffsetY, menu.contextMenuData.descriptionHeight)
	end
	objectiveOffsetY = objectiveOffsetY + tablespacing + Helper.borderSize

	-- objectives table
	local objectivetable = frame:addTable(2, { tabOrder = 4, highlightMode = "off", x = Helper.borderSize, y = objectiveOffsetY, maxVisibleHeight = menu.contextMenuData.objectiveHeight, width = menu.contextMenuData.width })
	objectivetable:setColWidth(2, Helper.standardTextHeight)
	objectivetable:setDefaultColSpan(1, 2)

	-- objectives
	local visibleHeight
	if menu.contextMenuData.threadtype ~= "" then
		-- title
		local row = objectivetable:addRow(false, { fixed = true })
		row[1]:createText(ReadText(1001, 3418), Helper.headerRowCenteredProperties)
		if menu.contextMenuData.isoffer then
			if #menu.contextMenuData.briefingmissions > 0 then
				for i, details in ipairs(menu.contextMenuData.briefingmissions) do
					local infotext = ""
					local textProperties = {}
					if i < details.activeobjective then
						infotext = " - " .. ReadText(1001, 3416)
						textProperties.color = Helper.color.grey
					end
					local row = objectivetable:addRow(true, { bgColor = Helper.color.transparent })
					row[1]:setColSpan(1):createText(((menu.contextMenuData.threadtype == "sequential") and (i .. ReadText(1001, 120)) or "·") .. " " .. details.name .. infotext, textProperties)
					row[2]:createIcon("missiontype_" .. details.type, { height = Helper.standardTextHeight })
					if i == maxObjectiveLines then
						visibleHeight = objectivetable:getFullHeight()
					end
				end
			else
				local row = objectivetable:addRow(true, { bgColor = Helper.color.transparent })
				row[1]:createText("--- " .. ReadText(1001, 3410) .. " ---")
			end
		else
			if #menu.contextMenuData.subMissions > 0 then
				for i, submissionEntry in ipairs(menu.contextMenuData.subMissions) do
					local infotext = ""
					local textProperties = {}
					if i < submissionEntry.activebriefingstep then
						infotext = " - " .. ReadText(1001, 3416)
						textProperties.color = Helper.color.grey
					elseif i == submissionEntry.activebriefingstep then
						if submissionEntry.active then
							textProperties.color = Helper.color.mission
						end
					else
						-- nothing to do
					end
					local row = objectivetable:addRow(true, { bgColor = Helper.color.transparent })
					row[1]:setColSpan(1):createText(((menu.contextMenuData.threadtype == "sequential") and (i .. ReadText(1001, 120)) or "·") .. " " .. submissionEntry.name .. infotext, textProperties)
					row[2]:createIcon("missiontype_" .. submissionEntry.type, { height = Helper.standardTextHeight })
					if i == maxObjectiveLines then
						visibleHeight = objectivetable:getFullHeight()
					end
				end
			else
				local row = objectivetable:addRow(true, { bgColor = Helper.color.transparent })
				row[1]:createText("--- " .. ReadText(1001, 3410) .. " ---")
			end
		end
	else
		-- title
		local row = objectivetable:addRow(false, { fixed = true })
		row[1]:createText(ReadText(1001, 3402), Helper.headerRowCenteredProperties)
		if #menu.contextMenuData.briefingobjectives > 0 then
			for linenum, briefingobjective in ipairs(menu.contextMenuData.briefingobjectives) do
				local infotext = ""
				local textProperties = {}
				if linenum < menu.contextMenuData.activebriefingstep then
					infotext = " - " .. (briefingobjective.failed and ReadText(1001, 3422) or ReadText(1001, 3416))
					textProperties.color = Helper.color.grey
				elseif linenum == menu.contextMenuData.activebriefingstep then
					if (not menu.isOffer) and (menu.contextMenuData.missionid == C.GetActiveMissionID()) then
						textProperties.color = Helper.color.mission
					end
				else
					if briefingobjective.completedoutofsequence then
						infotext = " - " .. ReadText(1001, 3416)
						textProperties.color = Helper.color.grey
					end
				end
				local row = objectivetable:addRow(true, { bgColor = Helper.color.transparent })
				row[1]:setColSpan(briefingobjective.encyclopedia and 1 or 2):createText(briefingobjective.step .. ReadText(1001, 120) .. " " .. briefingobjective.text .. infotext, textProperties)
				if briefingobjective.encyclopedia then
					row[2]:createButton({ active = briefingobjective.encyclopedia.known, height = Helper.standardTextHeight, mouseOverText = briefingobjective.encyclopedia.known and ReadText(1001, 2416) or ReadText(1026, 3259) }):setIcon("mm_externallink")
					row[2].handlers.onClick = function () Helper.closeMenuAndOpenNewMenu(menu, "EncyclopediaMenu", { 0, 0, briefingobjective.encyclopedia.mode, briefingobjective.encyclopedia.library, briefingobjective.encyclopedia.id, briefingobjective.encyclopedia.object }); menu.cleanup() end
				end
				if linenum == maxObjectiveLines then
					visibleHeight = objectivetable:getFullHeight()
				end
			end
		else
			local row = objectivetable:addRow(true, { bgColor = Helper.color.transparent })
			row[1]:createText("--- " .. ReadText(1001, 3410) .. " ---")
		end
	end
	if visibleHeight then
		objectivetable.properties.maxVisibleHeight = visibleHeight
	else
		objectivetable.properties.maxVisibleHeight = objectivetable:getFullHeight()
	end

	-- bottom table (info and buttons)
	local bottomtable = frame:addTable(2, { tabOrder = 2, x = Helper.borderSize, y = objectivetable.properties.y + objectivetable:getVisibleHeight() + tablespacing, width = menu.contextMenuData.width, highlightMode = "off" })

	-- faction
	if menu.contextMenuData.factionName then
		local row = bottomtable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
		row[1]:createText(ReadText(1001, 43) .. ReadText(1001, 120))
		row[2]:createText(menu.contextMenuData.factionName, { halign = "right" })
	end
	-- reward
	local rewardtext
	if menu.contextMenuData.rewardmoney ~= 0 then
		rewardtext = ConvertMoneyString(menu.contextMenuData.rewardmoney, false, true, 0, true) .. " " .. ReadText(1001, 101)
		if menu.contextMenuData.rewardtext ~= "" then
			rewardtext = rewardtext .. " \n" .. menu.contextMenuData.rewardtext
		end
	else
		rewardtext = menu.contextMenuData.rewardtext
	end
	local row = bottomtable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
	row[1]:createText(ReadText(1001, 3301) .. ReadText(1001, 120))
	row[2]:createText(rewardtext, { halign = "right", wordwrap = true })
	-- difficulty
	if menu.contextMenuData.difficulty ~= 0 then
		local row = bottomtable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
		row[1]:createText(ReadText(1001, 3403) .. ReadText(1001, 120))
		row[2]:createText(ConvertMissionLevelString(menu.contextMenuData.difficulty), { halign = "right" })
	end
	-- time left
	local row = bottomtable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
	row[1]:createText(ReadText(1001, 3404) .. ReadText(1001, 120))
	row[2]:createText(menu.getMissionContextTime, { halign = "right" })

	-- buttons
	if menu.contextMenuData.isoffer then
		-- Accept & Briefing
		local row = bottomtable:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
		local active = true
		local mouseovertext
		if C.IsMissionLimitReached(false, false, false) then
			active = false
			mouseovertext = ReadText(1026, 3242)
		end
		row[1]:createButton({ active = active, mouseOverText = mouseovertext, helpOverlayID = "map_accpetmission", helpOverlayText = " ", helpOverlayHighlightOnly = true }):setText(ReadText(1001, 57), { halign = "center" })
		row[1].handlers.onClick = menu.buttonMissionOfferAccept
		row[1].properties.uiTriggerID = "missionofferaccept"
		row[2]:createButton({  }):setText(ReadText(1001, 3326), { halign = "center" })
		row[2].handlers.onClick = menu.buttonMissionOfferBriefing
		row[2].properties.uiTriggerID = "missionofferbriefing"
	else
		-- Abort & Briefing
		local active = menu.contextMenuData.abortable
		local mouseovertext = ""
		if menu.contextMenuData.threadMissionID ~= 0 then
			local details = menu.getMissionIDInfoHelper(menu.contextMenuData.threadMissionID)
			active = active and (details.threadtype ~= "sequential")
			if details.threadtype == "sequential" then
				mouseovertext = ReadText(1026, 3405)
			end
		end
		local row = bottomtable:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
		row[1]:createButton({ active = active, mouseOverText = mouseovertext, helpOverlayID = "map_abortmission", helpOverlayText = " ",  helpOverlayHighlightOnly = true }):setText(ReadText(1001, 3407), { halign = "center" })
		row[1].handlers.onClick = menu.buttonMissionAbort
		row[1].properties.uiTriggerID = "missionabort"
		row[2]:createButton({  }):setText(ReadText(1001, 3326), { halign = "center" })
		row[2].handlers.onClick = menu.buttonMissionBriefing
		row[2].properties.uiTriggerID = "missionbriefing"
		if menu.contextMenuData.type ~= "guidance" then
			-- Set active
			local active = menu.contextMenuData.missionid == C.GetActiveMissionID()
			for _, submissionEntry in ipairs(menu.contextMenuData.subMissions) do
				if submissionEntry.active then
					active = true
				end
			end
			local row = bottomtable:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
			row[1]:createButton({  }):setText(active and ReadText(1001, 3413) or ReadText(1001, 3406), { halign = "center" })
			row[1].handlers.onClick = menu.buttonMissionActivate
			row[1].properties.uiTriggerID = "missionactivate"
		end
	end
	local neededheight = bottomtable.properties.y + bottomtable:getFullHeight() + Helper.frameBorder
	if frame.properties.y + neededheight > Helper.viewHeight then
		frame.properties.y = Helper.viewHeight - neededheight
	end

	desctable.properties.nextTable = objectivetable.index
	objectivetable.properties.prevTable = desctable.index

	objectivetable.properties.nextTable = bottomtable.index
	bottomtable.properties.prevTable = objectivetable.index
end
function menu.onRowChanged(row, rowdata, uitable, modified, input, source)
	-- Lock button over updates
	menu.lock = getElapsedTime()

	-- handle map modes without a holomap first
	if (menu.mode == "boardingcontext") and menu.boardingtable_shipselection and (uitable == menu.boardingtable_shipselection.id) and (type(rowdata) == "table") and (rowdata[1] == "boardingship") and C.IsComponentClass(rowdata[2], "defensible") and (menu.boardingData.selectedship ~= rowdata[2]) then
		--print("queueing refresh on next frame. ship: " .. ffi.string(C.GetComponentName(rowdata[2])) .. " " .. tostring(rowdata[2]))
		menu.boardingData.selectedship = rowdata[2]
		menu.queuecontextrefresh = true
	elseif menu.contextMenuMode == "trade" then
		if uitable == menu.contextshiptable then
			if rowdata then
				if (type(rowdata) == "table") and next(rowdata) then
					menu.selectedTradeWare = rowdata
				else
					menu.selectedTradeWare = nil
				end
				if (not menu.skipTradeRowChange) and (not menu.tradeSliderLock) then
					menu.queuetradecontextrefresh = true
				end
				menu.skipTradeRowChange = nil
			end
		end
	end

	if menu.holomap == 0 then
		return
	end

	if (menu.infoTableMode == "info") then
		if uitable == menu.infoTable then
			if (menu.infoMode.left == "objectinfo") or (menu.infoMode.left == "objectcrew") or (menu.infoMode.left == "objectloadout") then
				menu.selectedRows.infotableleft = row
				if menu.infoMode.left == "objectloadout" then
					local infomacrostolaunch = menu.infoTablePersistentData.left.macrostolaunch
					if (type(rowdata) == "table") and (rowdata[1] == "info_deploy") then
						if GetMacroData(rowdata[2], "islasertower") and (infomacrostolaunch.lasertower ~= rowdata[2]) then
							menu.infoTablePersistentData.left.macrostolaunch = { lasertower = rowdata[2] }
						elseif IsMacroClass(rowdata[2], "mine") and (infomacrostolaunch.mine ~= rowdata[2]) then
							menu.infoTablePersistentData.left.macrostolaunch = { mine = rowdata[2] }
						elseif IsMacroClass(rowdata[2], "navbeacon") and (infomacrostolaunch.navbeacon ~= rowdata[2]) then
							menu.infoTablePersistentData.left.macrostolaunch = { navbeacon = rowdata[2] }
						elseif IsMacroClass(rowdata[2], "resourceprobe") and (infomacrostolaunch.resourceprobe ~= rowdata[2]) then
							menu.infoTablePersistentData.left.macrostolaunch = { resourceprobe = rowdata[2] }
						elseif IsMacroClass(rowdata[2], "satellite") and (infomacrostolaunch.satellite ~= rowdata[2]) then
							menu.infoTablePersistentData.left.macrostolaunch = { satellite = rowdata[2] }
						end
					else
						menu.infoTablePersistentData.left.macrostolaunch = {}
					end
				end
			elseif (menu.infoMode.left == "orderqueue") or (menu.infoMode.left == "orderqueue_advanced") or (menu.infoMode.left == "standingorders") then
				menu.infoTablePersistentData.left.selectedorder = rowdata
				if type(menu.infoTablePersistentData.left.selectedorder) == "table" then
					menu.infoTablePersistentData.left.selectedorder.object = menu.infoSubmenuObject
				end
			end
		end
	elseif (menu.infoTableMode == "objectlist") or (menu.infoTableMode == "propertyowned") then
		if uitable == menu.infoTable then
			if type(rowdata) == "table" then
				local convertedComponent = ConvertIDTo64Bit(rowdata[2])
				if (source ~= "auto") and convertedComponent then
					local convertedcomponentclass = ffi.string(C.GetComponentClass(convertedComponent))
					if convertedcomponentclass  == "station" then
						AddUITriggeredEvent(menu.name, "selection_station", convertedComponent)
					end
					if (convertedcomponentclass  == "ship_s") or (convertedcomponentclass  == "ship_m") or (convertedcomponentclass  == "ship_l") or (convertedcomponentclass  == "ship_xl") then
						AddUITriggeredEvent(menu.name, "selection_ship", convertedComponent)
					end
					if (convertedcomponentclass == "resourceprobe") then
						AddUITriggeredEvent(menu.name, "selection_resourceprobe", convertedComponent)
					end

					if (menu.mode ~= "orderparam_object") and (input ~= "rightmouse") then
						menu.infoSubmenuObject = convertedComponent
						if menu.infoTableMode == "info" then
							menu.refreshInfoFrame(nil, 0)
						elseif menu.searchTableMode == "info" then
							menu.refreshInfoFrame2(nil, 0)
						end
					end
				end
				menu.updateSelectedComponents(modified, source == "auto", convertedComponent)
				menu.setSelectedMapComponents()
			end
		end
	elseif menu.infoTableMode == "plots" then
		if menu.plotDoNotUpdate then
			menu.plotDoNotUpdate = nil
		elseif menu.table_plotlist and (uitable == menu.table_plotlist.id) then
			menu.settoprow = GetTopRow(menu.table_plotlist)
			menu.setrow = Helper.currentTableRow[menu.table_plotlist]
			if not rowdata then
				print("rowdata empty. table id: " .. tostring(uitable) .. ", row: " .. tostring(row) .. ", rowdata: " .. tostring(rowdata))
			elseif input == "mouse" then
				--print("table id: " .. tostring(uitable) .. ", row: " .. tostring(row) .. ", rowdata: " .. tostring(rowdata) .. ", menu.table_plotlist.id: " .. tostring(menu.table_plotlist.id) .. ", uitable == menu.table_plotlist.id? " .. tostring(uitable == menu.table_plotlist.id))
				if rowdata == "plots_new" then
					menu.updatePlotData("plots_new", true)
				else
					C.SetFocusMapComponent(menu.holomap, rowdata, true)
				end
				menu.updatePlotData(rowdata)
			end
		end
	elseif (menu.infoTableMode == "missionoffer") or (menu.infoTableMode == "mission") then
		if uitable == menu.infoTable then
			local oldmission = menu.missionModeCurrent
			if type(rowdata) == "table" then
				local missionid = ConvertStringTo64Bit(rowdata[1])
				menu.missionModeCurrent = rowdata[1]
				if menu.missionDoNotUpdate then
					menu.missionDoNotUpdate = nil
				elseif input == "mouse" then
					if menu.contextMenuData and menu.contextMenuData.missionid and (menu.contextMenuData.missionid == missionid) then
						menu.closeContextMenu()
						menu.missionModeContext = nil
					else
						menu.closeContextMenu()
						menu.showMissionContext(missionid)
						menu.missionModeContext = true
					end
				end
			elseif type(rowdata) == "string" then
				menu.missionModeCurrent = rowdata
				if menu.missionDoNotUpdate then
					menu.missionDoNotUpdate = nil
				elseif input == "mouse" then
					menu.closeContextMenu()
					menu.missionModeContext = nil
				end
			end
			if menu.missionDoNotUpdate then
				menu.missionDoNotUpdate = nil
			elseif menu.missionModeCurrent ~= oldmission then
				if source ~= "auto" then
					menu.refreshInfoFrame()
				end
			end
		end
	elseif menu.infoTableMode == "ventureoutcomes" then
		if uitable == menu.infoTable then
			if type(rowdata) == "table" then
				if (rowdata[1] == "outcome") and ((not menu.infoTablePersistentData.left.selectedOutcome) or (rowdata[2].id ~= menu.infoTablePersistentData.left.selectedOutcome.id)) then
					menu.infoTablePersistentData.left.selectedOutcome = rowdata[2]
					menu.infoTablePersistentData.left.selectedVenture = nil
					menu.refreshIF = getElapsedTime()
				elseif (rowdata[1] == "venture") and ((not menu.infoTablePersistentData.left.selectedVenture) or (rowdata[2].platform.id ~= menu.infoTablePersistentData.left.selectedVenture.platform.id)) then
					menu.infoTablePersistentData.left.selectedVenture = rowdata[2]
					menu.infoTablePersistentData.left.selectedOutcome = nil
					menu.refreshIF = getElapsedTime()
				end
			else
				if menu.infoTablePersistentData.left.selectedOutcome or menu.infoTablePersistentData.left.selectedVenture then
					menu.infoTablePersistentData.left.selectedOutcome = nil
					menu.infoTablePersistentData.left.selectedVenture = nil
					menu.refreshIF = getElapsedTime()
				end
			end
		end
	elseif menu.infoTableMode == "ventureoperation" then
		if uitable == menu.infoTable then
			if type(rowdata) == "table" then
				if rowdata[1] == "venture" then
					menu.currentOperationSelection = rowdata[2].id
					if input == "mouse" then
						if menu.contextMenuData and menu.contextMenuData.venture and (menu.contextMenuData.venture == rowdata[2].id) then
							menu.closeContextMenu()
						else
							menu.contextMenuMode = "ventureconfig"
							local offsetx = menu.infoTableOffsetX + menu.infoTableWidth + Helper.borderSize + config.contextBorder
							local offsety = menu.infoTableOffsetY
							menu.contextMenuData = { xoffset = offsetx, yoffset = offsety, venture = rowdata[2].id, selectedShips = {} }
							menu.createContextFrame(menu.ventureConfigWidth)
						end
					end
				elseif (rowdata[1] == "mission") or (rowdata[1] == "missionoffer") then
					local missionid = ConvertStringTo64Bit(rowdata[2].ID)
					menu.currentOperationSelection = missionid
					if input == "mouse" then
						if menu.contextMenuData and menu.contextMenuData.missionid and (menu.contextMenuData.missionid == missionid) then
							menu.closeContextMenu()
						else
							menu.closeContextMenu()
							menu.showMissionContext(missionid, rowdata[1] == "missionoffer")
						end
					end
				else
					menu.currentOperationSelection = nil
				end
				if source ~= "auto" then
					menu.refreshInfoFrame()
				end
			end
		end
	end

	if (menu.searchTableMode == "info") then
		if uitable == menu.infoTableRight then
			if (menu.infoMode.right == "objectinfo") or (menu.infoMode.right == "objectcrew") or (menu.infoMode.right == "objectloadout") then
				menu.selectedRows.infotableright = row
				if menu.infoMode.right == "objectloadout" then
					local infomacrostolaunch = menu.infoTablePersistentData.right.macrostolaunch
					if (type(rowdata) == "table") and (rowdata[1] == "info_deploy") then
						if GetMacroData(rowdata[2], "islasertower") and (infomacrostolaunch.lasertower ~= rowdata[2]) then
							menu.infoTablePersistentData.right.macrostolaunch = { lasertower = rowdata[2] }
						elseif IsMacroClass(rowdata[2], "mine") and (infomacrostolaunch.mine ~= rowdata[2]) then
							menu.infoTablePersistentData.right.macrostolaunch = { mine = rowdata[2] }
						elseif IsMacroClass(rowdata[2], "navbeacon") and (infomacrostolaunch.navbeacon ~= rowdata[2]) then
							menu.infoTablePersistentData.right.macrostolaunch = { navbeacon = rowdata[2] }
						elseif IsMacroClass(rowdata[2], "resourceprobe") and (infomacrostolaunch.resourceprobe ~= rowdata[2]) then
							menu.infoTablePersistentData.right.macrostolaunch = { resourceprobe = rowdata[2] }
						elseif IsMacroClass(rowdata[2], "satellite") and (infomacrostolaunch.satellite ~= rowdata[2]) then
							menu.infoTablePersistentData.right.macrostolaunch = { satellite = rowdata[2] }
						end
					else
						menu.infoTablePersistentData.right.macrostolaunch = {}
					end
				end
			elseif (menu.infoMode.right == "orderqueue") or (menu.infoMode.right == "orderqueue_advanced") or (menu.infoMode.right == "standingorders") then
				menu.infoTablePersistentData.right.selectedorder = rowdata
				if type(menu.infoTablePersistentData.right.selectedorder) == "table" then
					menu.infoTablePersistentData.right.selectedorder.object = menu.infoSubmenuObject
				end
			end
		end
	end
end
function menu.onSelectElement(uitable, modified, row, isdblclick, input)
	local rowdata = Helper.getCurrentRowData(menu, uitable)
	if (menu.infoTableMode == "objectlist") or (menu.infoTableMode == "propertyowned") then
		if uitable == menu.infoTable then
			if type(rowdata) == "table" then
				local convertedRowComponent = ConvertIDTo64Bit(rowdata[2])
				menu.setSelectedMapComponents()

				if convertedRowComponent and (convertedRowComponent ~= 0) then
					local isonlineobject, isplayerowned = GetComponentData(rowdata[2], "isonlineobject", "isplayerowned")
					if (isdblclick or (input ~= "mouse")) and (ffi.string(C.GetComponentClass(convertedRowComponent)) ~= "sector") then
						if string.find(rowdata[1], "subordinates") then
							local subordinates = menu.infoTableData.left.subordinates[tostring(rowdata[2])] or {}
							local groups = {}
							for _, subordinate in ipairs(subordinates) do
								local group = GetComponentData(subordinate, "subordinategroup")
								if group and group > 0 then
									if groups[group] then
										table.insert(groups[group].subordinates, subordinate)
									else
										groups[group] = { assignment = ffi.string(C.GetSubordinateGroupAssignment(convertedRowComponent, group)), subordinates = { subordinate } }
									end
								end
							end

							if groups[rowdata[3]] then
								C.SetFocusMapComponent(menu.holomap, ConvertIDTo64Bit(groups[rowdata[3]].subordinates[1]), true)
								menu.addSelectedComponents(groups[rowdata[3]].subordinates, modified ~= "shift")
							end
						elseif isplayerowned and isonlineobject then
							local assigneddock = ConvertIDTo64Bit(GetComponentData(convertedRowComponent, "assigneddock"))
							if assigneddock then
								local container = C.GetContextByClass(assigneddock, "container", false)
								if container then
									C.SetFocusMapComponent(menu.holomap, container, true)
								end
							end
						else
							C.SetFocusMapComponent(menu.holomap, convertedRowComponent, true)
						end
					end
				end
			end
		end
	elseif menu.infoTableMode == "plots" then
		if menu.plotDoNotUpdate then
			menu.plotDoNotUpdate = nil
		elseif menu.table_plotlist and (uitable == menu.table_plotlist.id) then
			if rowdata == "plots_new" then
				menu.updatePlotData("plots_new", true)
			else
				C.SetFocusMapComponent(menu.holomap, rowdata, true)
			end
			menu.updatePlotData(rowdata)
		end
	elseif (menu.infoTableMode == "missionoffer") or (menu.infoTableMode == "mission") then
		if uitable == menu.infoTable then
			if type(rowdata) == "table" then
				menu.missionModeCurrent = rowdata[1]
				local missionid = ConvertStringTo64Bit(rowdata[1])
				if menu.contextMenuData and menu.contextMenuData.missionid and (menu.contextMenuData.missionid == missionid) then
					menu.closeContextMenu()
					menu.missionModeContext = nil
				else
					menu.closeContextMenu()
					menu.showMissionContext(missionid)
					menu.missionModeContext = true
				end
			elseif type(rowdata) == "string" then
				menu.missionModeCurrent = rowdata
				if menu.missionDoNotUpdate then
					menu.missionDoNotUpdate = nil
				else
					menu.closeContextMenu()
					menu.missionModeContext = nil
				end
			end
		end
	elseif (menu.infoTableMode == "info") then
		if (isdblclick or (input ~= "mouse")) then
			if (rowdata == "info_focus") or ((type(rowdata) == "table") and (rowdata[1] == "info_focus")) then
				C.SetFocusMapComponent(menu.holomap, menu.infoSubmenuObject, true)
			end
			if (menu.infoMode.left == "orderqueue") or (menu.infoMode.left == "orderqueue_advanced") then
				if (type(rowdata) == "table") and (type(rowdata[1]) == "number") then
					C.SetFocusMapOrder(menu.holomap, menu.infoSubmenuObject, rowdata[1], true)
				end
			end
		end
	elseif menu.infoTableMode == "ventureoperation" then
		if uitable == menu.infoTable then
			if type(rowdata) == "table" then
				if rowdata[1] == "venture" then
					if menu.contextMenuData and menu.contextMenuData.venture and (menu.contextMenuData.venture == rowdata[2].id) then
						menu.closeContextMenu()
					else
						menu.contextMenuMode = "ventureconfig"
						local offsetx = menu.infoTableOffsetX + menu.infoTableWidth + Helper.borderSize + config.contextBorder
						local offsety = menu.infoTableOffsetY
						menu.contextMenuData = { xoffset = offsetx, yoffset = offsety, venture = rowdata[2].id, selectedShips = {} }
						menu.createContextFrame(menu.ventureConfigWidth)
					end
				elseif (rowdata[1] == "mission") or (rowdata[1] == "missionoffer") then
					local missionid = ConvertStringTo64Bit(rowdata[2].ID)
					if menu.contextMenuData and menu.contextMenuData.missionid and (menu.contextMenuData.missionid == missionid) then
						menu.closeContextMenu()
					else
						menu.closeContextMenu()
						menu.showMissionContext(missionid, rowdata[1] == "missionoffer")
					end
				end
			end
		end
	end

	if (menu.searchTableMode == "info") then
		if (isdblclick or (input ~= "mouse")) then
			if (rowdata == "info_focus") or ((type(rowdata) == "table") and (rowdata[1] == "info_focus")) then
				C.SetFocusMapComponent(menu.holomap, menu.infoSubmenuObject, true)
			end
			if (menu.infoMode.right == "orderqueue") or (menu.infoMode.right == "orderqueue_advanced") then
				if (type(rowdata) == "table") and (type(rowdata[1]) == "number") then
					C.SetFocusMapOrder(menu.holomap, menu.infoSubmenuObject, rowdata[1], true)
				end
			end
		end
	end
end
function menu.onRenderTargetSelect(modified)
	local offset = table.pack(GetLocalMousePosition())
	-- Check if the mouse button was down less than 0.5 seconds and the mouse was moved more than a distance of 5px
	if (not menu.leftdown) or ((menu.leftdown.time + 0.5 > getElapsedTime()) and not Helper.comparePositions(menu.leftdown.position, offset, 5)) then
		if menu.showMultiverse then
			local pickedplayer = C.GetPickedMultiverseMapPlayer(menu.holomap)
			-- TODO
		elseif menu.mode == "selectbuildlocation" then
			local station = 0
			if menu.plotData.active then
				local offset = ffi.new("UIPosRot")
				local offsetsector = C.GetBuildMapStationLocation2(menu.holomap, offset)
				if offsetsector ~= 0 then
					AddUITriggeredEvent(menu.name, "plotplaced")
					menu.plotData.sector = offsetsector
					station = C.ReserveBuildPlot(offsetsector, "player", menu.plotData.set, offset, menu.plotData.size.x * 1000, menu.plotData.size.y * 1000, menu.plotData.size.z * 1000)
					if GetComponentData(ConvertStringTo64Bit(tostring(offsetsector)), "isplayerowned") then
						local size = { x = menu.plotData.size.x * 1000, y = menu.plotData.size.y * 1000, z = menu.plotData.size.z * 1000 }
						local plotcenter = { x = offset.x, y = offset.y, z = offset.z }
						C.PayBuildPlotSize(station, size, plotcenter)
					end
					C.ClearMapBuildPlot(menu.holomap)
					menu.plotData.active = nil
					SetMouseOverOverride(menu.map, nil)
				end
			else
				local pickedcomponent = C.GetPickedMapComponent(menu.holomap)
				local pickedcomponentclass = ffi.string(C.GetRealComponentClass(pickedcomponent))
				if (pickedcomponentclass == "station") and GetComponentData(ConvertStringToLuaID(tostring(pickedcomponent)), "isplayerowned") then
					station = pickedcomponent
				end
			end

			if station ~= 0 then
				for _, row in ipairs(menu.table_plotlist.rows) do
					if row.rowdata == station then
						menu.setplotrow = row.index
						menu.setplottoprow = (row.index - 12) > 1 and (row.index - 12) or 1
						break
					end
				end

				menu.updatePlotData(station, true)
				menu.refreshInfoFrame()
			end
		elseif menu.mode == "orderparam_position" then
			local offset = ffi.new("UIPosRot")
			local eclipticoffset = ffi.new("UIPosRot")
			local offsetcomponent = C.GetMapPositionOnEcliptic2(menu.holomap, offset, false, 0, eclipticoffset)
			if offsetcomponent ~= 0 then
				local class = ffi.string(C.GetComponentClass(offsetcomponent))
				if (not menu.modeparam[2].inputparams.class) or (class == menu.modeparam[2].inputparams.class) then
					menu.modeparam[1]({ConvertStringToLuaID(tostring(offsetcomponent)), {offset.x, offset.y, offset.z}})
				elseif (menu.modeparam[2].inputparams.class == "zone") and (class == "sector") then
					offsetcomponent = C.GetZoneAt(offsetcomponent, offset)
					menu.modeparam[1]({ConvertStringToLuaID(tostring(offsetcomponent)), {offset.x, offset.y, offset.z}})
				end
			end
		elseif (menu.mode == "orderparam_selectenemies") or (menu.mode == "orderparam_selectplayerdeployables") then
			menu.mode = nil
			menu.modeparam = {}
			SetMouseCursorOverride("default")
			menu.removeMouseCursorOverride(3)
		elseif menu.mode == "boardingcontext" then

		else
			local colspan = 1
			if menu.editboxHeight >= Helper.scaleY(config.mapRowHeight) then
				colspan = 2
			end
			if menu.searchField then
				Helper.confirmEditBoxInput(menu.searchField, 1, colspan + 2)
			end
			local pickedcomponent = C.GetPickedMapComponent(menu.holomap)
			local pickedorder = ffi.new("Order")
			local isintermediate = ffi.new("bool[1]", 0)
			local pickedordercomponent = C.GetPickedMapOrder(menu.holomap, pickedorder, isintermediate)
			local pickedcomponentclass = ffi.string(C.GetComponentClass(pickedcomponent))
			local ispickedcomponentship = C.IsComponentClass(pickedcomponent, "ship") and not C.IsUnit(pickedcomponent)
			local pickedtradeoffer = C.GetPickedMapTradeOffer(menu.holomap)
			if pickedordercomponent ~= 0 then
				local sectorcontext = C.GetContextByClass(pickedordercomponent, "sector", false)
				if sectorcontext ~= menu.currentsector then
					menu.currentsector = sectorcontext
				end

				menu.createInfoFrame()
			elseif pickedtradeoffer ~= 0 then
				local tradeid = ConvertStringToLuaID(tostring(pickedtradeoffer))
				local tradedata = GetTradeData(tradeid)
				if tradedata.ware then
					local setting = config.layersettings["layer_trade"][1]
					local rawwarelist = menu.getFilterOption(setting.id) or {}
					local found = false
					for i, ware in ipairs(rawwarelist) do
						if ware == tradedata.ware then
							found = i
							break
						end
					end
					AddUITriggeredEvent(menu.name, "filterwareselected", tradedata.isbuyoffer and "buyoffer" or "selloffer")
					if found then
						menu.removeFilterOption(setting, setting.id, found)
					else
						menu.setFilterOption("layer_trade", setting, setting.id, tradedata.ware)
					end
				end
			elseif pickedcomponent ~= 0 then
				if (not menu.sound_selectedelement) or (menu.sound_selectedelement ~= pickedcomponent) or (modified == "ctrl") or (modified == "shift") then
					local isselected = menu.isSelectedComponent(pickedcomponent)
					if (not isselected) and (modified == "shift") then
						PlaySound("ui_positive_multiselect")
					elseif modified == "ctrl" then
						if isselected then
							PlaySound("ui_positive_deselect")
						else
							PlaySound("ui_positive_multiselect")
						end
					elseif (pickedcomponentclass == "sector") then
						PlaySound("ui_positive_deselect")
					else
						PlaySound("ui_positive_select")
					end
				end
				menu.sound_selectedelement = pickedcomponent
				if menu.mode ~= "orderparam_object" then
					menu.infoSubmenuObject = ConvertStringTo64Bit(tostring(pickedcomponent))
					if menu.infoTableMode == "info" then
						menu.refreshInfoFrame(nil, 0)
					elseif menu.searchTableMode == "info" then
						menu.refreshInfoFrame2(nil, 0)
					end
				end

				if pickedcomponentclass == "sector" then
					AddUITriggeredEvent(menu.name, "selection_reset")
					menu.clearSelectedComponents()
					if pickedcomponent ~= menu.currentsector then
						menu.currentsector = pickedcomponent
						menu.updateMapAndInfoFrame()
					end
				elseif (#menu.searchtext == 0) or Helper.textArrayHelper(menu.searchtext, function (numtexts, texts) return C.FilterComponentByText(pickedcomponent, numtexts, texts, true) end) then
					local isconstruction = IsComponentConstruction(ConvertStringTo64Bit(tostring(pickedcomponent)))
					if (C.IsComponentOperational(pickedcomponent) and (pickedcomponentclass ~= "player") and (pickedcomponentclass ~= "collectablewares") and (not menu.createInfoFrameRunning)) or
						(pickedcomponentclass == "gate") or (pickedcomponentclass == "asteroid") or isconstruction
					then
						local sectorcontext = C.GetContextByClass(pickedcomponent, "sector", false)
						if sectorcontext ~= menu.currentsector then
							menu.currentsector = sectorcontext
						end
						
						if modified == "ctrl" then
							menu.toggleSelectedComponent(pickedcomponent)
						else
							if pickedcomponentclass == "station" then
								AddUITriggeredEvent(menu.name, "selection_station", ConvertStringTo64Bit(tostring(pickedcomponent)))
							end
							if (pickedcomponentclass == "ship_s") or (pickedcomponentclass == "ship_m") or (pickedcomponentclass == "ship_l") or (pickedcomponentclass == "ship_xl") then
								AddUITriggeredEvent(menu.name, "selection_ship", ConvertStringTo64Bit(tostring(pickedcomponent)))
							end
							if (pickedcomponentclass == "resourceprobe") then
								AddUITriggeredEvent(menu.name, "selection_resourceprobe", ConvertStringTo64Bit(tostring(pickedcomponent)))
							end

							local newmode
							if (menu.mode ~= "selectComponent") or (menu.modeparam[3] ~= "deployables") then
								if menu.infoTableMode == "objectlist" then
									local isdeployable = GetComponentData(ConvertStringTo64Bit(tostring(pickedcomponent)), "isdeployable")
									if isdeployable or (pickedcomponentclass == "lockbox") then
										newmode = "deployables"
									elseif menu.objectMode ~= "objectall" then
										if C.IsRealComponentClass(pickedcomponent, "station") then
											newmode = "stations"
										elseif ispickedcomponentship then
											local found = false
											local commanderlist = GetAllCommanders(ConvertStringTo64Bit(tostring(pickedcomponent)))
											for i, entry in ipairs(commanderlist) do
												if IsComponentClass(entry, "station") then
													found = true
													break
												end
											end
											if found then
												newmode = "stations"
											else
												newmode = "ships"
											end
										end
									end
								elseif menu.infoTableMode == "propertyowned" then
									local isplayerowned, isdeployable = GetComponentData(ConvertStringTo64Bit(tostring(pickedcomponent)), "isplayerowned", "isdeployable")
									if isplayerowned then
										if isdeployable or (pickedcomponentclass == "lockbox") then
											newmode = "deployables"
										elseif menu.propertyMode ~= "propertyall" then
											if C.IsRealComponentClass(pickedcomponent, "station") then
												newmode = "stations"
											elseif ispickedcomponentship then
												local found = false
												local commanderlist = GetAllCommanders(ConvertStringTo64Bit(tostring(pickedcomponent)))
												for i, entry in ipairs(commanderlist) do
													if IsComponentClass(entry, "station") then
														found = true
														break
													end
												end
												if found then
													newmode = "stations"
												else
													if #commanderlist > 0 then
														newmode = "fleets"
													else
														newmode = "unassignedships"
													end
												end
											end
										end
									end
								end
							end
							menu.addSelectedComponent(pickedcomponent, not modified)
							if newmode then
								if menu.infoTableMode == "objectlist" then
									if newmode ~= menu.objectMode then
										menu.objectMode = newmode
										menu.refreshInfoFrame()
									end
								elseif menu.infoTableMode == "propertyowned" then
									if newmode ~= menu.propertyMode then
										menu.propertyMode = newmode
										menu.refreshInfoFrame()
									end
								end
							end
						end
					end
				end
			else
				if (menu.mode ~= "info") or (not menu.infoMode.left) or (menu.infoMode.left == "objectinfo") or (menu.infoMode.left == "objectcrew") or (menu.infoMode.left == "objectloadout") or (menu.infoMode.left == "objectlogbook") then
					AddUITriggeredEvent(menu.name, "selection_reset")
					menu.clearSelectedComponents()
				end
			end
		end
	end
	menu.leftdown = nil
end
function menu.onTableRightMouseClick(uitable, row, posx, posy)
	if (menu.mode == "orderparam_position") then
		menu.resetOrderParamMode()
	else
		if row > (menu.numFixedRows or 0) then
			local rowdata = menu.rowDataMap[uitable] and menu.rowDataMap[uitable][row]
			if (menu.infoTableMode == "objectlist") or (menu.infoTableMode == "propertyowned") then
				if uitable == menu.infoTable then
					if type(rowdata) == "table" then
						local convertedRowComponent = ConvertIDTo64Bit(rowdata[2])
						if convertedRowComponent and (convertedRowComponent ~= 0) then
							local x, y = GetLocalMousePosition()
							if menu.mode == "hire" then
								if GetComponentData(convertedRowComponent, "isplayerowned") and C.IsComponentClass(convertedRowComponent, "controllable") then
									menu.contextMenuData = { component = convertedRowComponent, xoffset = x + Helper.viewWidth / 2, yoffset = Helper.viewHeight / 2 - y }
									menu.contextMenuMode = "select"
									menu.createContextFrame(menu.selectWidth)
								end
							elseif menu.mode == "selectCV" then
								menu.contextMenuData = { component = convertedRowComponent, xoffset = x + Helper.viewWidth / 2, yoffset = Helper.viewHeight / 2 - y }
								menu.contextMenuMode = "select"
								menu.createContextFrame(menu.selectWidth)
							elseif menu.mode == "orderparam_object" then
								if menu.checkForOrderParamObject(convertedRowComponent) then
									menu.contextMenuData = { component = convertedRowComponent, xoffset = x + Helper.viewWidth / 2, yoffset = Helper.viewHeight / 2 - y }
									menu.contextMenuMode = "select"
									menu.createContextFrame(menu.selectWidth)
								end
							elseif menu.mode == "selectComponent" then
								if menu.checkForSelectComponent(convertedRowComponent) then
									menu.contextMenuData = { component = convertedRowComponent, xoffset = x + Helper.viewWidth / 2, yoffset = Helper.viewHeight / 2 - y }
									menu.contextMenuMode = "select"
									menu.createContextFrame(menu.selectWidth)
								end
							else
								local missions = {}
								Helper.ffiVLA(missions, "MissionID", C.GetNumMapComponentMissions, C.GetMapComponentMissions, menu.holomap, convertedRowComponent)
								
								local playerships, otherobjects, playerdeployables = menu.getSelectedComponentCategories()
								if rowdata[1] == "construction" then
									menu.interactMenuComponent = convertedRowComponent
									Helper.openInteractMenu(menu, { component = convertedRowComponent, playerships = playerships, otherobjects = otherobjects, playerdeployables = playerdeployables, mouseX = posx, mouseY = posy, construction = rowdata[3], componentmissions = missions })
								elseif string.find(rowdata[1], "subordinates") then
									menu.interactMenuComponent = convertedRowComponent
									Helper.openInteractMenu(menu, { component = convertedRowComponent, playerships = playerships, otherobjects = otherobjects, playerdeployables = playerdeployables, mouseX = posx, mouseY = posy, subordinategroup = rowdata[3], componentmissions = missions })
								else
									menu.interactMenuComponent = convertedRowComponent
									Helper.openInteractMenu(menu, { component = convertedRowComponent, playerships = playerships, otherobjects = otherobjects, playerdeployables = playerdeployables, mouseX = posx, mouseY = posy, componentmissions = missions })
								end
							end
						end
					end
				end
			elseif menu.infoTableMode == "info" then
				if uitable == menu.infoTable then
					menu.prepareInfoContext(rowdata, "left")
				end
			elseif menu.infoTableMode == "missionoffer" then
				if uitable == menu.infoTable then
					if type(rowdata) == "table" then
						menu.closeContextMenu()

						local missionid = ConvertStringTo64Bit(rowdata[1])
						local playerships, otherobjects, playerdeployables = menu.getSelectedComponentCategories()
						Helper.openInteractMenu(menu, { missionoffer = missionid, playerships = playerships, otherobjects = otherobjects, playerdeployables = playerdeployables })
					end
				end
			elseif menu.infoTableMode == "mission" then
				if uitable == menu.infoTable then
					if type(rowdata) == "table" then
						menu.closeContextMenu()

						local missionid = ConvertStringTo64Bit(rowdata[1])
						local playerships, otherobjects, playerdeployables = menu.getSelectedComponentCategories()
						Helper.openInteractMenu(menu, { mission = missionid, playerships = playerships, otherobjects = otherobjects, playerdeployables = playerdeployables })
					end
				end
			end

			if menu.searchTableMode == "info" then
				if uitable == menu.infoTableRight then
					menu.prepareInfoContext(rowdata, "right")
				end
			end
		else
			menu.closeContextMenu()
		end
	end
end
function menu.onInteractiveElementChanged(element)
	menu.lastactivetable = element
end
function menu.closeContextMenu(dueToClose)
	if Helper.closeInteractMenu() then
		return true
	end
	if menu.contextMenuMode then
		if menu.contextMenuMode == "trade" then
			if C.IsComponentOperational(menu.contextMenuData.currentShip) then
				SetVirtualCargoMode(ConvertStringToLuaID(tostring(menu.contextMenuData.currentShip)), false)
			end
			if menu.contextMenuData.wareexchange then
				if C.IsComponentOperational(menu.contextMenuData.component) then
					SetVirtualCargoMode(ConvertStringToLuaID(tostring(menu.contextMenuData.component)), false)
				end
			end
			menu.selectedTradeWare = nil
		elseif menu.contextMenuMode == "mission" then
			if menu.holomap ~= 0 then
				C.SetMapRenderMissionGuidance(menu.holomap, 0)
			end
			if menu.contextMenuData.isoffer then
				UnregisterEvent("missionofferremoved", menu.onMissionOfferRemoved)
			else
				UnregisterEvent("missionremoved", menu.onMissionRemoved)
			end
		elseif menu.contextMenuMode == "boardingcontext" then
			-- restore old mode and old info table mode
			menu.mode = menu.oldmode
			menu.oldmode = nil
			menu.infoTableMode = menu.oldInfoTableMode
			menu.refreshMainFrame = true
			menu.oldInfoTableMode = nil
			menu.boardingData = {}
			menu.contexttoprow = nil
			menu.contextselectedrow = nil
		elseif menu.contextMenuMode == "onlinemode" then
			if dueToClose == "back" then
				return false
			end
		elseif menu.contextMenuMode == "ventureconfig" then
			Helper.clearTableConnectionColumn(menu, 3)
			Helper.clearTableConnectionColumn(menu, 4)
		end
		-- REMOVE this block once the mouse out/over event order is correct -> This should be unnessecary due to the global tablemouseout event reseting the picking
		if menu.currentMouseOverTable and (
			(menu.currentMouseOverTable == menu.contexttable)
			or (menu.currentMouseOverTable == menu.contextshiptable)
			or (menu.currentMouseOverTable == menu.contextbuttontable)
			or (menu.currentMouseOverTable == menu.contextdesctable)
			or (menu.currentMouseOverTable == menu.contextobjectivetable)
			or (menu.currentMouseOverTable == menu.contextbottomtable)
			or (menu.contextMenuMode == "boardingcontext")
			or (menu.contextMenuMode == "dropwares")
			or (menu.contextMenuMode == "crewtransfer")
			or (menu.contextMenuMode == "rename")
			or (menu.contextMenuMode == "userquestion")
			or (menu.contextMenuMode == "mission")
			or (menu.contextMenuMode == "venturepatron")
		) then
			menu.picking = true
			menu.currentMouseOverTable = nil
		end
		-- END
		menu.contextFrame = nil
		Helper.clearFrame(menu, config.contextFrameLayer)
		menu.contextMenuData = {}
		menu.contextMenuMode = nil
		if (menu.mode == "tradecontext") or (menu.mode == "dropwarescontext") or (menu.mode == "renamecontext") or (menu.mode == "crewtransfercontext") or(menu.mode == "venturepatroninfo") or menu.closemapwithmenu then
			Helper.closeMenu(menu, dueToClose)
			menu.cleanup()
		end
		return true
	end
	return false
end
function menu.updateSelectedComponents(modified, keepselection, changedComponent)
	local components = {}
	local rows, highlightedborderrow = GetSelectedRows(menu.infoTable)

	for _, row in ipairs(rows) do
		local rowdata = menu.rowDataMap[menu.infoTable][row]
		if type(rowdata) == "table" then
			if (rowdata[1] ~= "moduletype") and (not string.find(rowdata[1], "subordinates")) and (rowdata[1] ~= "dockedships") and (rowdata[1] ~= "constructions") then
				if rowdata[1] == "construction" then
					if rowdata[3].component ~= 0 then
						table.insert(components, ConvertStringTo64Bit(tostring(rowdata[3].component)))
					end
				else
					table.insert(components, rowdata[2])
				end
			end
		end
	end

	if modified or keepselection then
		for id in pairs(menu.selectedcomponents) do
			local component = ConvertStringTo64Bit(id)
			-- keep gates, satellites, etc. selected even if they don't have their own list entries
			if C.IsComponentClass(component, "gate") or C.IsComponentClass(component, "asteroid") or C.IsComponentClass(component, "buildstorage") or C.IsComponentClass(component, "highwayentrygate") then
				table.insert(components, component)
			end
			if menu.infoTableMode == "propertyowned" then
				local isplayerowned, isdeployable = GetComponentData(component, "isplayerowned", "isdeployable")
				if not isplayerowned then
					-- keep npc ships selected
					table.insert(components, component)
				elseif menu.propertyMode ~= "propertyall" then
					-- keep other property selected that is currently not displayed
					if (menu.propertyMode ~= "stations") and C.IsRealComponentClass(component, "station") then
						table.insert(components, component)
					end
					if (modified ~= "ctrl") or (component ~= changedComponent) then
						if C.IsComponentClass(component, "ship") then
							table.insert(components, component)
						end
					end
				end
				if (menu.propertyMode ~= "deployables") and (isdeployable or C.IsComponentClass(component, "lockbox")) then
					table.insert(components, component)
				end
			elseif menu.infoTableMode == "objectlist" then
				local isdeployable = GetComponentData(component, "isdeployable")
				if menu.objectMode ~= "objectall" then
					-- keep other property selected that is currently not displayed
					if (menu.objectMode ~= "stations") and C.IsRealComponentClass(component, "station") then
						table.insert(components, component)
					end
						if (modified ~= "ctrl") or (component ~= changedComponent) then
						if C.IsComponentClass(component, "ship") then
							table.insert(components, component)
						end
					end
				end
				if (menu.objectMode ~= "deployables") and (isdeployable or C.IsComponentClass(component, "lockbox")) then
					table.insert(components, component)
				end
			end
		end
	end

	local rowdata = menu.rowDataMap[menu.infoTable][highlightedborderrow]
	if type(rowdata) == "table" then
		menu.highlightedbordercomponent = rowdata[2]
		if rowdata[1] == "construction" then
			if rowdata[3].component ~= 0 then
				menu.highlightedbordercomponent = ConvertStringTo64Bit(tostring(rowdata[3].component))
			end
		end
		local oldselectedstationcategory = menu.selectedstationcategory
		menu.highlightedbordermoduletype = nil
		menu.highlightedborderstationcategory = nil
		menu.selectedstationcategory = nil
		menu.highlightedplannedmodule = nil
		menu.highlightedconstruction = nil
		menu.selectedconstruction = nil
		if rowdata[1] == "moduletype" then
			menu.highlightedbordermoduletype = rowdata[3]
		elseif rowdata[1] == "module" then
			menu.highlightedbordermoduletype = rowdata[3]
			if rowdata[6] then
				menu.highlightedbordercomponent = rowdata[5]
				menu.highlightedplannedmodule = rowdata[6]
			end
		elseif string.find(rowdata[1], "subordinates") then
			menu.highlightedborderstationcategory = rowdata[1]
			if (keepselection and (oldselectedstationcategory == rowdata[1])) or (modified ~= "ctrl") then
				menu.selectedstationcategory = rowdata[1]
			end
		elseif rowdata[1] == "dockedships" then
			menu.highlightedborderstationcategory = "dockedships"
		elseif rowdata[1] == "constructions" then
			menu.highlightedborderstationcategory = "constructions"
		elseif rowdata[1] == "construction" then
			menu.highlightedconstruction = rowdata[3]
			if (modified ~= "ctrl") then
				menu.selectedconstruction = rowdata[3]
			end
		end
		menu.highlightedbordersection = nil
	elseif type(rowdata) == "string" then
		menu.highlightedbordercomponent = nil
		menu.highlightedbordermoduletype = nil
		menu.highlightedborderstationcategory = nil
		menu.selectedstationcategory = nil
		menu.highlightedconstruction = nil
		menu.selectedconstruction = nil
		menu.highlightedbordersection = rowdata
	end

	menu.addSelectedComponents(components, modified)
end
function menu.updateTableSelection(lastcomponent)
	menu.refreshMainFrame = true
	if (menu.infoTableMode == "objectlist") or (menu.infoTableMode == "propertyowned") then
		-- check if sections need to be extended - if so we need a refresh
		local refresh = false
		for id in pairs(menu.selectedcomponents) do
			local component = ConvertStringTo64Bit(id)
			-- build queues contain components that are not connected to the universe yet
			if IsValidComponent(component) then
				local commanderlist = C.IsComponentClass(component, "controllable") and GetAllCommanders(component) or {}
				for i, entry in ipairs(commanderlist) do
					if (not menu.isPropertyExtended(tostring(entry))) then
						menu.extendedproperty[tostring(entry)] = true
						refresh = true
					end
				end
			end
		end
		if refresh then
			menu.refreshInfoFrame()
			return
		end

		if menu.rowDataMap[menu.infoTable] then
			local rows = {}
			local curRow
			for row, rowdata in pairs(menu.rowDataMap[menu.infoTable]) do
				if type(rowdata) == "table" then
					if rowdata[1] == nil then
						print(TraceBack())
					end
					if (rowdata[1] ~= "moduletype") and (not string.find(rowdata[1], "subordinates")) and (rowdata[1] ~= "dockedships") and (rowdata[1] ~= "constructions") and (rowdata[1] ~= "construction") and menu.isSelectedComponent(rowdata[2]) then
						table.insert(rows, row)
						if ConvertStringTo64Bit(tostring(rowdata[2])) == lastcomponent then
							curRow = row
						end
					elseif (rowdata[1] == "construction") and (rowdata[3].component ~= 0) and menu.isSelectedComponent(rowdata[3].component) then
						table.insert(rows, row)
						if ConvertStringTo64Bit(tostring(rowdata[3].component)) == lastcomponent then
							curRow = row
						end
					elseif (rowdata[1] == "construction") and rowdata[2] and menu.selectedconstruction and (menu.selectedconstruction.id == rowdata[3].id) then
						table.insert(rows, row)
						if ConvertStringTo64Bit(tostring(rowdata[2])) == lastcomponent then
							curRow = row
						end
					elseif string.find(rowdata[1], "subordinates") and (rowdata[1] == menu.selectedstationcategory) then
						table.insert(rows, row)
					end
				end
			end
			SetSelectedRows(menu.infoTable, rows, curRow or (Helper.currentTableRow[menu.infoTable] or 0))
		end
	end
	menu.setSelectedMapComponents()
end
function menu.createSearchField(frame, width, height, offsetx, offsety, refresh)
	local editboxwidth = menu.infoTableWidth - Helper.round(2.5 * menu.editboxHeight) - Helper.borderSize

	local numCols = 6 + #config.layers
	local ftable = frame:addTable(numCols, { tabOrder = 4, width = width, height = height, x = offsetx, y = offsety, skipTabChange = true, backgroundID = "solid", backgroundColor = Helper.color.semitransparent })
	if menu.searchTableMode ~= "info" then
		ftable:addConnection(1, 3, true)
	end
	ftable:setDefaultCellProperties("text", { minRowHeight = config.mapRowHeight, fontsize = config.mapFontSize })
	ftable:setDefaultCellProperties("button", { height = config.mapRowHeight })
	ftable:setDefaultComplexCellProperties("button", "text", { fontsize = config.mapFontSize })

	ftable:setColWidth(1, Helper.scaleY(config.mapRowHeight), false)
	ftable:setColWidth(2, math.max(4, Helper.scaleY(Helper.headerRow1Height) - Helper.scaleY(config.mapRowHeight) - Helper.borderSize), false)
	ftable:setColWidth(3, menu.sideBarWidth - Helper.scaleY(Helper.headerRow1Height) - Helper.borderSize, false)
	for i = 2, #config.layers do
		ftable:setColWidth(i + 2, menu.sideBarWidth, false)
	end
	ftable:setColWidth(numCols - 1, Helper.scaleY(config.mapRowHeight), false)
	ftable:setColWidth(numCols, Helper.scaleY(config.mapRowHeight), false)

	-- search field
	local row = ftable:addRow(true, { fixed = true })
	-- toggle trade filter
	local colspan = 1
	if menu.editboxHeight >= Helper.scaleY(config.mapRowHeight) then
		colspan = 2
	end
	local entry = config.layers[1]
	local icon = entry.icon
	if not menu.getFilterOption(entry.mode) then
		icon = icon .. "_disabled"
	end
	row[1]:setColSpan(colspan):createButton({ height = menu.editboxHeight, bgColor = bgcolor, mouseOverText = entry.name, scaling = false, helpOverlayID = "toggle_trade", helpOverlayText = " ", helpOverlayHighlightOnly = true}):setIcon(icon, { })
	row[1].handlers.onClick = function () return menu.buttonSetFilterLayer(entry.mode, row.index, 1) end
	-- reset camera view
	row[colspan + 1]:setColSpan(1):createButton({ active = true, height = menu.editboxHeight, mouseOverText = ffi.string(C.GetLocalizedText(1026, 7911, ReadText(1026, 7902))), bgColor = {r = 33, g = 46, b = 55, a = 40}, scaling = false }):setIcon("menu_reset_view"):setHotkey("INPUT_STATE_DETAILMONITOR_RESET_VIEW", { displayIcon = false })
	row[colspan + 1].handlers.onClick = menu.buttonResetView
	-- editbox
	row[colspan + 2]:setColSpan(numCols - colspan - 1):createEditBox({ height = menu.editboxHeight, defaultText = ReadText(1001, 3250), scaling = false, helpOverlayID = "map_searchbar", helpOverlayText = " ", helpOverlayHighlightOnly = true, restoreInteractiveObject = true }):setText("", { x = Helper.standardTextOffsetx, scaling = true }):setHotkey("INPUT_STATE_DETAILMONITOR_0", { displayIcon = true })
	row[colspan + 2].handlers.onEditBoxDeactivated = menu.searchTextConfirmed
	local editboxRowHeight = row:getHeight()

	-- search terms
	local setting = config.layersettings["layer_trade"][1]
	local warefilter = menu.getFilterOption(setting.id) or {}

	local row = ftable:addRow((#menu.searchtext > 0) or (#warefilter > 0), { fixed = true, bgColor = Helper.color.transparent })
	local searchindex = 0
	for i = 1, math.min(3, #menu.searchtext) do
		local col = i
		local colspan = 1
		if col == 1 then
			colspan = 5
		else
			col = col + 4
		end
		searchindex = searchindex + 1
		row[col]:setColSpan(colspan)
		local truncatedString = TruncateText(menu.searchtext[i].text, Helper.standardFont, Helper.scaleFont(Helper.standardFont, config.mapFontSize), row[col]:getWidth() - 2 * Helper.scaleX(10))

		if menu.searchtext[i].blockRemove then
			row[col]:createText(truncatedString, { halign = "center", cellBGColor = Helper.defaultButtonBackgroundColor })
		else
			row[col]:createButton({
				helpOverlayID = "FilterItem" .. searchindex,		
				helpOverlayText = " ", 
				helpOverlayHighlightOnly = true,
			}):setText(truncatedString, { halign = "center" }):setText2("X", { halign = "right" })
			row[col].handlers.onClick = function () return menu.buttonRemoveSearchEntry(i) end
		end
	end

	local searchindex = 0
	if #menu.searchtext < 3 then
		for i = 1, math.min(3 - #menu.searchtext, #warefilter) do
			local col = i + #menu.searchtext
			local colspan = 1
			if col == 1 then
				colspan = 5
			else
				col = col + 4
			end
			searchindex = searchindex + 1
			row[col]:setColSpan(colspan)
			local truncatedString = TruncateText(GetWareData(warefilter[i], "name"), Helper.standardFont, Helper.scaleFont(Helper.standardFont, config.mapFontSize), row[col]:getWidth() - 2 * Helper.scaleX(10))

			row[col]:createButton({
				helpOverlayID = "FilterWare" .. searchindex,		
				helpOverlayText = " ", 
				helpOverlayHighlightOnly = true,
			}):setText(truncatedString, { halign = "center" }):setText2("X", { halign = "right" }):setIcon("maptr_supply", { width = Helper.standardTextHeight, height = Helper.standardTextHeight })
			row[col].handlers.onClick = function () return menu.removeFilterOption(setting, setting.id, i) end
			row[col].properties.uiTriggerID = "removefilteroption"
		end
	end

	if (#menu.searchtext + #warefilter) > 3 then
		row[5 + #config.layers]:setColSpan(2):createText(string.format("%+d", (#menu.searchtext + #warefilter) - 3))
	else
		row[5 + #config.layers]:setColSpan(2):createText("")
	end

	if menu.searchTableMode then
		if menu.holomap ~= 0 then
			C.SetMapStationInfoBoxMargin(menu.holomap, "right", menu.infoTableOffsetX + menu.infoTableWidth + config.contextBorder)
		end
		if (#menu.searchtext + #warefilter) > 0 then
			local row = ftable:addRow(nil, { fixed = true, bgColor = Helper.color.transparent })
			row[1]:createText("")
		end

		if menu.searchTableMode == "filter" then
			menu.createFilterMode(ftable, numCols)
		elseif menu.searchTableMode == "legend" then
			menu.createLegendMode(ftable, numCols)
		elseif menu.searchTableMode == "hire" then
			menu.createHireMode(ftable, numCols)
		end
	else
		if menu.holomap ~= 0 then
			C.SetMapStationInfoBoxMargin(menu.holomap, "right", 0)
		end
		--[[
		local row = ftable:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
		for i, entry in ipairs(config.layers) do
			local icon = entry.icon
			if not menu.getFilterOption(entry.mode) then
				icon = icon .. "_disabled"
			end

			local colindex = i
			if i > 1 then
				colindex = colindex + 2
			end

			row[colindex]:setColSpan((i == 1) and 3 or 1):createButton({ height = menu.sideBarWidth / 2, width = menu.sideBarWidth / 2 , bgColor = bgcolor, mouseOverText = entry.name, scaling = false }):setIcon(icon, { })
			row[colindex].handlers.onClick = function () return menu.buttonSetFilterLayer(entry.mode, row.index, 1) end
		end--]]
	end

	ftable:setTopRow(menu.topRows.filterTable)
	ftable:setSelectedRow(menu.selectedRows.filterTable)
	ftable:setSelectedCol(menu.selectedCols.filterTable or 0)

	menu.topRows.filterTable = nil
	menu.selectedRows.filterTable = nil
	menu.selectedCols.filterTable = nil

	if not refresh then
		menu.createInfoFrame2()
	end
end
function menu.createFilterMode(ftable, numCols)
	local title = ""
	local row = ftable:addRow("tabs", { fixed = true, bgColor = Helper.color.transparent })
	for i, entry in ipairs(config.layers) do
		local icon = entry.icon
		local bgcolor = Helper.defaultTitleBackgroundColor
		-- active filter groups get different colors
		if entry.mode == menu.displayedFilterLayer then
			title = entry.name
			bgcolor = Helper.defaultArrowRowBackgroundColor
		end
		if not menu.getFilterOption(entry.mode) then
			icon = icon .. "_disabled"
		end

		local colindex = i
		if i > 1 then
			colindex = colindex + 2
		end

		row[colindex]:setColSpan((i == 1) and 3 or 1):createButton({ height = menu.sideBarWidth, bgColor = bgcolor, mouseOverText = entry.name, scaling = false, helpOverlayID = entry.helpOverlayID, helpOverlayText = entry.helpOverlayText }):setIcon(icon, { })
		row[colindex].handlers.onClick = function () return menu.buttonFilterSwitch(entry.mode, row.index, colindex) end
	end

	local row = ftable:addRow(true, { fixed = true, bgColor = Helper.defaultTitleBackgroundColor })
	local color = Helper.color.white
	local onoffcolor = Helper.color.white
	local active = true
	if not __CORE_DETAILMONITOR_MAPFILTER[menu.displayedFilterLayer] then
		color = Helper.color.grey
		onoffcolor = Helper.color.red
		active = false
	end
	row[1]:setColSpan(2):createButton({ height = Helper.headerRow1Height, helpOverlayID = "toggle_trade_filter", helpOverlayText = " ", helpOverlayHighlightOnly = true}):setIcon("menu_on_off", { color = onoffcolor })
	row[1].handlers.onClick = function () return menu.buttonSetFilterLayer(menu.displayedFilterLayer, row.index, 1) end
	row[3]:setColSpan(numCols - 2):createText(title, Helper.headerRowCenteredProperties)

	local settings = config.layersettings[menu.displayedFilterLayer]
	for i, setting in ipairs(settings) do
		if i > 1 then
			ftable:addEmptyRow(config.mapRowHeight / 2)
		end

		local row = ftable:addRow(false, { bgColor = Helper.defaultTitleBackgroundColor })
		row[1]:setColSpan(numCols):createText(setting.caption, Helper.subHeaderTextProperties)
		row[1].properties.color = color

		if setting.type == "multiselectlist" then
			local list = menu.getFilterOption(setting.id) or {}
			for i, curOption in ipairs(list) do
				local index = i

				local row = ftable:addRow(true, { bgColor = Helper.color.transparent })
				row[1]:setColSpan(numCols - 1):createText(setting.displayOption(curOption), { fontsize = config.mapFontSize })
				row[1].properties.color = color
				row[numCols]:createButton({ active = active }):setText("x", { halign = "center" })
				row[numCols].handlers.onClick = function () return menu.removeFilterOption(setting, setting.id, index) end
			end
			local row = ftable:addRow(true, {  })
			row[1]:setColSpan(numCols):createButton({ mouseOverText = setting.info, active = active }):setText(setting.overrideText, { halign = "center", fontsize = config.mapFontSize })
			row[1].handlers.onClick = function () return menu.setFilterOption(menu.displayedFilterLayer, setting, setting.id) end
		else
			for _, option in ipairs(setting) do
				local optionactive = true
				if option.active then
					optionactive = option.active()
				end
				if setting.type == "checkbox" then
					local row = ftable:addRow(true, { bgColor = Helper.color.transparent })
					row[1]:createCheckBox(menu.getFilterOption(option.id) or false, { scaling = false, width = Helper.scaleY(config.mapRowHeight), height = Helper.scaleY(config.mapRowHeight), active = active and optionactive })
					row[1].handlers.onClick = function () return menu.setFilterOption(menu.displayedFilterLayer, setting, option.id) end
					row[2]:setColSpan(numCols - 1):createText(option.name, { mouseOverText = option.info })
					row[2].properties.color = color
				elseif setting.type == "slidercell" then
					if option.scale.exceedmax then
						option.scale.start = math.max(option.scale.min, menu.getFilterOption(option.id)) or option.scale.max
					else
						option.scale.start = math.max(option.scale.min, math.min(option.scale.max, menu.getFilterOption(option.id))) or option.scale.max
					end
					local row = ftable:addRow(true, { bgColor = Helper.color.transparent })
					row[1]:setColSpan(numCols):createSliderCell({ height = config.mapRowHeight, min = option.scale.min, minSelect = option.scale.minSelect, max = option.scale.max, maxSelect = option.scale.maxSelect, start = option.scale.start, step = option.scale.step, suffix = option.scale.suffix, exceedMaxValue = option.scale.exceedmax, mouseOverText = option.info, readOnly = not active, bgColor = (not active) and Helper.color.transparent or nil, valueColor = (not active) and color or nil }):setText(option.name, {fontsize = config.mapFontSize})
					row[1].handlers.onSliderCellChanged = function (_, value) menu.noupdate = true; return menu.setFilterOption(menu.displayedFilterLayer, setting, option.id, value) end
					row[1].handlers.onSliderCellConfirm = function() menu.noupdate = false end
				elseif setting.type == "dropdown" then
					local listOptions = option.listOptions()
					local row = ftable:addRow(true, {  })
					row[1]:setColSpan(numCols):createDropDown(listOptions, { height = config.mapRowHeight, startOption = menu.getFilterOption(option.id), mouseOverText = option.info, active = active }):setTextProperties({ fontsize = config.mapFontSize }):setText2Properties({ fontsize = config.mapFontSize, halign = "right" })
					row[1].handlers.onDropDownConfirmed = function (_, id) return menu.setFilterOption(menu.displayedFilterLayer, setting, option.id, id) end
					row[1].handlers.onDropDownActivated = function () menu.noupdate = true end
				end
			end
		end
	end
end