local ffi = require ("ffi")
local C = ffi.C
local Lib = require ("extensions.sn_mod_support_apis.lua_library")
local mapMenu
local oldFuncs = {}
local newFuncs = {}
local callbacks = {}
local isInited
local function init ()
	DebugError ("kuertee_menu_map.init")
	if not isInited then
		isInited = true
		mapMenu = Lib.Get_Egosoft_Menu ("MapMenu")
		mapMenu.registerCallback = newFuncs.registerCallback
		oldFuncs.createPropertyOwned = mapMenu.createPropertyOwned
		mapMenu.createPropertyOwned = newFuncs.createPropertyOwned
		oldFuncs.createPropertyRow = mapMenu.createPropertyRow
		mapMenu.createPropertyRow = newFuncs.createPropertyRow
	end
end
function newFuncs.registerCallback (callbackName, callbackFunction)
	-- DebugError ("kuertee_menu_transporter.registerCallback " .. tostring (callbackName) .. " " .. tostring (callbackFunction))
	-- note 1: format is generally [function name]_[action]. e.g.: in kuertee_menu_transporter, "display_on_set_room_active" overrides the room's active property with the return of the callback.
	-- note 2: events have the word "_on_" followed by a PRESENT TENSE verb. e.g.: in kuertee_menu_transporter, "display_on_set_buttontable" is called after all of the rows of buttontable are set.
	-- note 3: new callbacks can be added or existing callbacks can be edited. but commit your additions/changes to the mod's GIT repository.
	-- note 4: search for the callback names to see where they are executed.
	-- note 5: if a callback requires a return value, return it in an object var. e.g. "display_on_set_room_active" requires a return of {active = true | false}.
	-- available callbacks:
	-- createPropertyOwned_on_start (config)
	-- createPropertyOwned_on_init_infoTableData (infoTableData)
	-- createPropertyOwned_on_add_ship_infoTableData (infoTableData, object)
	-- {numdisplayed = numdisplayed} = createPropertyOwned_on_createPropertySection_unassignedships (numdisplayed, instance, ftable, infoTableData)
	-- {maxicons = maxicons, subordinates = subordinates, dockedships = dockedships, constructions = constructions, convertedComponent = convertedComponent} = createPropertyRow_on_init_vars (maxicons, subordinates, dockedships, constructions, convertedComponent)
	-- {locationtext = locationtext} = createPropertyRow_on_set_locationtext (locationtext, component)
	-- {locationtext = createtext text, createText properties} = createPropertyRow_override_row_location_createText (locationtext, createTextProperties, component)
	--
	if callbacks [callbackName] == nil then
		callbacks [callbackName] = {}
	end
	table.insert (callbacks [callbackName], callbackFunction)
end
-- only have config stuff here that are used in this file
local config = {
	mapRowHeight = Helper.standardTextHeight,
	mapFontSize = Helper.standardFontSize,
	propertyCategories = {
		{ category = "propertyall",                name = ReadText(1001, 8380),    icon = "mapst_propertyowned",        helpOverlayID = "mapst_po_propertyowned",        helpOverlayText = ReadText(1028, 3220) },
		{ category = "stations",                name = ReadText(1001, 8379),    icon = "mapst_ol_stations",            helpOverlayID = "mapst_po_stations",            helpOverlayText = ReadText(1028, 3221) },
		{ category = "fleets",                    name = ReadText(1001, 8326),    icon = "mapst_ol_fleets",            helpOverlayID = "mapst_po_fleets",                helpOverlayText = ReadText(1028, 3223) },
		{ category = "unassignedships",            name = ReadText(1001, 8327),    icon = "mapst_ol_unassigned",        helpOverlayID = "mapst_po_unassigned",            helpOverlayText = ReadText(1028, 3224) },
		{ category = "inventoryships",            name = ReadText(1001, 8381),    icon = "mapst_ol_inventory",        helpOverlayID = "mapst_po_inventory",            helpOverlayText = ReadText(1028, 3225) },
		{ category = "deployables",                name = ReadText(1001, 1332),    icon = "mapst_ol_deployables",        helpOverlayID = "mapst_po_deployables",            helpOverlayText = ReadText(1028, 3226) },
	}
}
function newFuncs.createPropertyOwned(frame, instance)
	local menu = mapMenu

	-- start kuertee_lua_with_callbacks:
	if callbacks ["createPropertyOwned_on_start"] then
		for _, callback in ipairs (callbacks ["createPropertyOwned_on_start"]) do
			callback (config)
		end
	end
	-- end kuertee_lua_with_callbacks:

	local infoTableData = menu.infoTableData[instance]

	-- TODO: Move to config table?
	infoTableData.maxIcons = 5
	infoTableData.shipIconWidth = math.max(math.ceil(C.GetTextHeight("99", Helper.standardFont, Helper.scaleFont(Helper.standardFont, config.mapFontSize), Helper.viewWidth)), math.ceil(C.GetTextWidth("99", Helper.standardFont, Helper.scaleFont(Helper.standardFont, config.mapFontSize))))
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

	-- start kuertee_lua_with_callbacks:
	if callbacks ["createPropertyOwned_on_init_infoTableData"] then
		for _, callback in ipairs (callbacks ["createPropertyOwned_on_init_infoTableData"]) do
			callback (infoTableData)
		end
	end
	-- end kuertee_lua_with_callbacks:

	local onlineitems = {}
	if menu.propertyMode == "inventoryships" then
		onlineitems = OnlineGetUserItems(false)
		local persistentonlineitems = OnlineGetUserItems(true)
		for k, v in pairs(persistentonlineitems) do
			onlineitems[k] = v
		end
	end

	local playerobjects = GetContainedObjectsByOwner("player")

	for i = #playerobjects, 1, -1 do
		local object = playerobjects[i]
		local object64 = ConvertIDTo64Bit(object)
		if menu.isObjectValid(object64) then
			local hull, purpose = GetComponentData(object, "hullpercent", "primarypurpose")
			playerobjects[i] = { id = object, name = ffi.string(C.GetComponentName(object64)), fleetname = menu.getFleetName(object64), objectid = ffi.string(C.GetObjectIDCode(object64)), class = ffi.string(C.GetComponentClass(object64)), hull = hull, purpose = purpose }
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
			-- builds in progress
			local n = C.GetNumBuildTasks(object64, 0, true, false)
			local buf = ffi.new("BuildTaskInfo[?]", n)
			n = C.GetBuildTasks(buf, n, object64, 0, true, false)
			for i = 0, n - 1 do
				table.insert(constructions, { id = buf[i].id, buildingcontainer = buf[i].buildingcontainer, component = buf[i].component, macro = ffi.string(buf[i].macro), factionid = ffi.string(buf[i].factionid), buildercomponent = buf[i].buildercomponent, price = buf[i].price, ismissingresources = buf[i].ismissingresources, queueposition = buf[i].queueposition, inprogress = true })
			end
			-- other builds
			local n = C.GetNumBuildTasks(object64, 0, false, false)
			local buf = ffi.new("BuildTaskInfo[?]", n)
			n = C.GetBuildTasks(buf, n, object64, 0, false, false)
			for i = 0, n - 1 do
				table.insert(constructions, { id = buf[i].id, buildingcontainer = buf[i].buildingcontainer, component = buf[i].component, macro = ffi.string(buf[i].macro), factionid = ffi.string(buf[i].factionid), buildercomponent = buf[i].buildercomponent, price = buf[i].price, ismissingresources = buf[i].ismissingresources, queueposition = buf[i].queueposition, inprogress = false })
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

			-- start kuertee_lua_with_callbacks:
			if callbacks ["createPropertyOwned_on_add_ship_infoTableData"] then
				for _, callback in ipairs (callbacks ["createPropertyOwned_on_add_ship_infoTableData"]) do
					callback (infoTableData, object)
				end
			end
			-- end kuertee_lua_with_callbacks:

		end
	end

	local n = C.GetNumPlayerShipBuildTasks(true, false)
	local buf = ffi.new("BuildTaskInfo[?]", n)
	n = C.GetPlayerShipBuildTasks(buf, n, true, false)
	for i = 0, n - 1 do
		local factionid = ffi.string(buf[i].factionid)
		if factionid == "player" then
			table.insert(infoTableData.constructionShips, { id = buf[i].id, buildingcontainer = buf[i].buildingcontainer, component = buf[i].component, macro = ffi.string(buf[i].macro), factionid = factionid, buildercomponent = buf[i].buildercomponent, price = buf[i].price, ismissingresources = buf[i].ismissingresources, queueposition = buf[i].queueposition, inprogress = true })
		end
	end
	local n = C.GetNumPlayerShipBuildTasks(false, false)
	local buf = ffi.new("BuildTaskInfo[?]", n)
	n = C.GetPlayerShipBuildTasks(buf, n, false, false)
	for i = 0, n - 1 do
		local factionid = ffi.string(buf[i].factionid)
		if factionid == "player" then
			table.insert(infoTableData.constructionShips, { id = buf[i].id, buildingcontainer = buf[i].buildingcontainer, component = buf[i].component, macro = ffi.string(buf[i].macro), factionid = factionid, buildercomponent = buf[i].buildercomponent, price = buf[i].price, ismissingresources = buf[i].ismissingresources, queueposition = buf[i].queueposition, inprogress = false })
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

		-- start kuertee_lua_with_callbacks:
		if callbacks ["createPropertyOwned_on_createPropertySection_unassignedships"] then
			local result
			for _, callback in ipairs (callbacks ["createPropertyOwned_on_createPropertySection_unassignedships"]) do
				result = callback (numdisplayed, instance, ftable, infoTableData)
				if result.numdisplayed > numdisplayed then
					numdisplayed = result.numdisplayed
				end
			end
		end
		-- end kuertee_lua_with_callbacks:

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
		tabtable.properties.nextTable = ftable.index
		ftable.properties.prevTable = tabtable.index
	end
	function newFuncs.createPropertyRow(instance, ftable, component, iteration, commanderlocation, showmodules, hidesubordinates, numdisplayed, sorter)
		local menu = mapMenu

		local maxicons = menu.infoTableData[instance].maxIcons

		local subordinates = menu.infoTableData[instance].subordinates[tostring(component)] or {}
		local dockedships = menu.infoTableData[instance].dockedships[tostring(component)] or {}
		local constructions = menu.infoTableData[instance].constructions[tostring(component)] or {}
		local convertedComponent = ConvertStringTo64Bit(tostring(component))

		-- start kuertee_lua_with_callbacks:
		if callbacks ["createPropertyRow_on_init_vars"] then
			local result
			for _, callback in ipairs (callbacks ["createPropertyRow_on_init_vars"]) do
				result = callback (maxicons, subordinates, dockedships, constructions, convertedComponent)
			end
			subordinates = result.maxicons
			subordinates = result.subordinates
			dockedships = result.dockedships
			constructions = result.constructions
			convertedComponent = result.convertedComponent
		end
		-- end kuertee_lua_with_callbacks:

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
			local name, color, bgcolor, font, mouseover = menu.getContainerNameAndColors(component, iteration, isdoublerow, false)
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

			if menu.mode == "selectCV" then
				local isplayerowned, isenemy = GetComponentData(component, "isplayerowned", "isenemy")
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

			local location, locationtext, isdocked, aipilot, isplayerowned, isonlineobject = GetComponentData(component, "sectorid", "sector", "isdocked", "assignedaipilot", "isplayerowned", "isonlineobject")
			local displaylocation = location and not (commanderlocation and IsSameComponent(location, commanderlocation))
			local currentordericon, currentorderrawicon, currentordercolor, currentordername, currentorderisoverride = "", "", nil, "", false
			if IsComponentClass(component, "ship") then
				currentordericon, currentorderrawicon, currentordercolor, currentordername, currentorderisoverride = menu.getOrderInfo(convertedComponent)
			end
			local fleettypes = IsComponentClass(component, "controllable") and menu.getPropertyOwnedFleetData(instance, component, maxicons) or {}

			if isplayerowned and isonlineobject then
				locationtext = Helper.convertColorToText(menu.holomapcolor.visitorcolor) .. ReadText(1001, 11231) .. "\27X"
				currentordericon = Helper.convertColorToText(menu.holomapcolor.visitorcolor) .. "\27[order_venture]\27X"
				currentorderrawicon = "order_venture"
				currentordercolor = menu.holomapcolor.visitorcolor
				currentordername = ReadText(1001, 7868)
				isdocked = false
			end

			-- start kuertee_lua_with_callbacks:
			if callbacks ["createPropertyRow_on_set_locationtext"] then
				local result
				for _, callback in ipairs (callbacks ["createPropertyRow_on_set_locationtext"]) do
					result = callback (locationtext, component)
				end
				locationtext = result.locationtext
			end
			-- end kuertee_lua_with_callbacks:

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
						mouseovertext = mouseovertext .. currentordername
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

					-- row[3 + namecolspan]:createText(locationtext, { halign = "right", font = font, mouseOverText = mouseovertext, x = 0 })
					-- start kuertee_lua_with_callbacks:
					if not callbacks ["createPropertyRow_override_row_location_createText"] then
						row[3 + namecolspan]:createText(locationtext, { halign = "right", font = font, mouseOverText = mouseovertext, x = 0 })
					else
						local result
						for _, callback in ipairs (callbacks ["createPropertyRow_override_row_location_createText"]) do
							result = callback (locationtext, {halign = "right", font = font, mouseOverText = mouseovertext, x = 0}, component)
						end
						-- only the last callback is used
						row[3 + namecolspan]:createText(result.locationtext, result.properties)
					end
					-- end kuertee_lua_with_callbacks:
				end

				if (currentordericon ~= "") or isdocked then
					if isdocked then
						row[4 + maxicons]:createIcon("order_dockat", { width = config.mapRowHeight, height = config.mapRowHeight, mouseOverText = ReadText(1001, 3249) })
						if currentordericon ~= "" then
							row[3 + maxicons]:createIcon(currentorderrawicon, { color = currentorderisoverride and function () return menu.overrideOrderIcon(currentordercolor, false) end or currentordercolor, width = config.mapRowHeight, height = config.mapRowHeight, mouseOverText = currentordername })
						end
					else
						row[4 + maxicons]:createIcon(currentorderrawicon, { color = currentorderisoverride and function () return menu.overrideOrderIcon(currentordercolor, false) end or currentordercolor, width = config.mapRowHeight, height = config.mapRowHeight, mouseOverText = currentordername })
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
				AddKnownItem("stationtypes", GetComponentData(component, "macro"))
			elseif IsComponentClass(component, "ship_xl") then
				AddKnownItem("shiptypes_xl", GetComponentData(component, "macro"))
			elseif IsComponentClass(component, "ship_l") then
				AddKnownItem("shiptypes_l", GetComponentData(component, "macro"))
			elseif IsComponentClass(component, "ship_m") then
				AddKnownItem("shiptypes_m", GetComponentData(component, "macro"))
			elseif IsComponentClass(component, "ship_s") then
				AddKnownItem("shiptypes_s", GetComponentData(component, "macro"))
			elseif IsComponentClass(component, "ship_xs") then
				AddKnownItem("shiptypes_xs", GetComponentData(component, "macro"))
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
	init ()
