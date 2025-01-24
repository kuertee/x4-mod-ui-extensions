local ModLua = {}

local ffi = require("ffi")
local C = ffi.C
ffi.cdef[[]]

-- kuertee start: colour backward compatibility
Helper.standardColor = { r = 255, g = 255, b = 255, a = 100 }
Helper.defaultHeaderBackgroundColor = { r = 0, g = 0, b = 0, a = 60 }
Helper.defaultSimpleBackgroundColor = { r = 66, g = 92, b = 111, a = 60 }
Helper.defaultTitleBackgroundColor = { r = 49, g = 69, b = 83, a = 60 }
Helper.defaultArrowRowBackgroundColor = { r = 83, g = 116, b = 139, a = 60 }
Helper.defaultUnselectableBackgroundColor = { r = 35, g = 53, b = 71, a = 60 }
Helper.defaultUnselectableFontColor = { r = 163, g = 193, b = 227, a = 100 }
Helper.defaultButtonBackgroundColor = { r = 49, g = 69, b = 83, a = 60 }
Helper.defaultUnselectableButtonBackgroundColor = { r = 31, g = 31, b = 31, a = 100 }
Helper.defaultButtonHighlightColor = { r = 71, g = 136, b = 184, a = 100 }
Helper.defaultUnselectableButtonHighlightColor = { r = 80, g = 80, b = 80, a = 100 }
Helper.defaultCheckBoxBackgroundColor = { r = 66, g = 92, b = 111, a = 100 }
Helper.defaultEditBoxBackgroundColor = { r = 49, g = 69, b = 83, a = 60 }
Helper.defaultSliderCellBackgroundColor = { r = 22, g = 34, b = 41, a = 60 }
Helper.defaultSliderCellInactiveBackgroundColor = { r = 40, g = 40, b = 40, a = 60 }
Helper.defaultSliderCellValueColor = { r = 99, g = 138, b = 166, a = 100 }
Helper.defaultSliderCellPositiveValueColor = { r = 29, g = 216, b = 35, a = 30 }
Helper.defaultSliderCellNegativeValueColor = { r = 216, g = 68, b = 29, a = 30 }
Helper.defaultStatusBarValueColor = { r = 71, g = 136, b = 184, a = 100 }
Helper.defaultStatusBarPosChangeColor = { r = 20, g = 222, b = 20, a = 30 }
Helper.defaultStatusBarNegChangeColor = { r = 236, g = 53, b = 0, a = 30 }
Helper.defaultStatusBarMarkerColor = { r = 151, g = 192, b = 223, a = 100 }
Helper.defaultBoxTextBoxColor = { r = 49, g = 69, b = 83, a = 60 }
Helper.defaultFlowchartOutlineColor = { r = 90, g = 146, b = 186, a = 100 }			-- light cyan
Helper.defaultFlowchartBackgroundColor = { r = 25, g = 25, b = 25, a = 100 }			-- dark grey
Helper.defaultFlowchartValueColor = { r = 0, g = 116, b = 153, a = 100 }				-- cyan
Helper.defaultFlowchartSlider1Color = { r = 225, g = 149, b = 0, a = 100 }			-- orange
Helper.defaultFlowchartDiff1Color = { r = 89, g = 52, b = 0, a = 100 }				-- brown
Helper.defaultFlowchartSlider2Color = { r = 66, g = 171, b = 61, a = 100 }			-- green
Helper.defaultFlowchartDiff2Color = { r = 4, g = 89, b = 0, a = 100 }					-- dark green
Helper.defaultFlowchartConnector1Color = { r = 255, g = 220, b = 0, a = 100 }			-- yellow
Helper.defaultFlowchartConnector2Color = { r = 0, g = 154, b = 204, a = 100 }			-- light cyan
Helper.defaultFlowchartConnector3Color = { r = 224, g = 79, b = 0, a = 100 }			-- dark orange
Helper.defaultFlowchartConnector4Color = { r = 255, g = 153, b = 255, a = 100 }		-- pink
Helper.defaultTitleTrapezoidBackgroundColor = { r = 66, g = 92, b = 111, a = 100 }
Helper.statusRed = {r = 255, g = 0, b = 0, a = 100}
Helper.statusOrange = {r = 255, g = 64, b = 0, a = 100}
Helper.statusYellow = {r = 255, g = 255, b = 0, a = 100}
Helper.statusGreen = {r = 0, g = 255, b = 0, a = 100}
-- kuertee end: colour backward compatibility

-- kuertee start: colour backward compatibility
Helper.color = {
	black = { r = 0, g = 0, b = 0, a = 100 },
	slidervalue = { r = 71, g = 136, b = 184, a = 100 },
	green = { r = 0, g = 255, b = 0, a = 100 },
	playergreen = { r = 170, g = 255, b = 139, a = 100 },
	grey = { r = 128, g = 128, b = 128, a = 100 },
	lightgreen = { r = 100, g = 225, b = 0, a = 100 },
	lightgrey = { r = 192, g = 192, b = 192, a = 100 },
	orange = { r = 255, g = 192, b = 0, a = 100 },
	darkorange = { r = 128, g = 95, b = 0, a = 100 },
	red = { r = 255, g = 0, b = 0, a = 100 },
	semitransparent = { r = 0, g = 0, b = 0, a = 95 },
	transparent60 = { r = 0, g = 0, b = 0, a = 60 },
	transparent = { r = 0, g = 0, b = 0, a = 0 },
	white = { r = 255, g = 255, b = 255, a = 100 },
	yellow = { r = 144, g = 144, b = 0, a = 100 },
	brightyellow = { r = 255, g = 255, b = 0, a = 100 },
	warning = { r = 192, g = 192, b = 0, a = 100 },
	done = { r = 38, g = 61, b = 78, a = 100 },
	available = { r = 7, g = 29, b = 46, a = 100 },
	darkgrey = { r = 32, g = 32, b = 32, a = 100 },
	mission = { r = 255, g = 190, b = 0, a = 100 },
	warningorange = { r = 255, g = 138, b = 0, a = 100 },
	blue = { r = 90, g = 146, b = 186, a = 100 },
	changedvalue = { r = 255, g = 236, b = 81, a = 100 },
	cyan = { r = 46, g = 209, b = 255, a = 100 },
	checkboxgroup = { r = 0, g = 102, b = 238, a = 60 },
	unselectable = { r = 32, g = 32, b = 32, a = 100 },
	cover = { r = 231, g = 244, b = 70, a = 100 },
	textred = { r = 255, g = 80, b = 80, a = 100 },
	grey64 = { r = 64, g = 64, b = 64, a = 100 },
	illegal = { r = 255, g = 64, b = 0, a = 100 },
	illegaldark = { r = 128, g = 32, b = 0, a = 100 },
}
-- kuertee end: colour backward compatibility

local origreadtext = ReadText
ReadText = function(page, line) 
	-- kuertee start:
	if page and line then
		local refstr = page .. "-" .. line
		local text = Helper.texts[refstr]
		if not text then
			text = origreadtext(page, line)
			Helper.texts[refstr] = text
		end
		return text
	else
		return ""
	end
	-- kuertee end
end

-- kuertee start: more save games
-- for i = 1, 10 do
Helper.maxSaveFiles = 20
for i = 1, Helper.maxSaveFiles do
-- kuertee end: more save games
	Helper.validSaveFilenames[string.format("save_%03d", i)] = true
end

-- kuertee start: rewrites

local OldFuncs = {}
local uix_callbacks = {}

function ModLua.rewriteFunctions()
	OldFuncs.onUpdate = Helper.onUpdate
	Helper.onUpdate = ModLua.onUpdate
	OldFuncs.getPassedTime = Helper.getPassedTime
	Helper.getPassedTime = ModLua.getPassedTime
	OldFuncs.checkTopLevelConditions = Helper.checkTopLevelConditions
	Helper.checkTopLevelConditions = ModLua.checkTopLevelConditions
	OldFuncs.createLSOStorageNode = Helper.createLSOStorageNode
	Helper.createLSOStorageNode = ModLua.createLSOStorageNode
	OldFuncs.updateLSOStorageNode = Helper.updateLSOStorageNode
	Helper.updateLSOStorageNode = ModLua.updateLSOStorageNode
	OldFuncs.onExpandLSOStorageNode = Helper.onExpandLSOStorageNode
	Helper.onExpandLSOStorageNode = ModLua.onExpandLSOStorageNode
	OldFuncs.checkboxSetTradeRuleOverride = Helper.checkboxSetTradeRuleOverride
	Helper.checkboxSetTradeRuleOverride = ModLua.checkboxSetTradeRuleOverride
	OldFuncs.dropdownTradeRule = Helper.dropdownTradeRule
	Helper.dropdownTradeRule = ModLua.dropdownTradeRule
	OldFuncs.onCollapseLSOStorageNode = Helper.onCollapseLSOStorageNode
	Helper.onCollapseLSOStorageNode = ModLua.onCollapseLSOStorageNode
	OldFuncs.getLimitedWareAmount = Helper.getLimitedWareAmount
	Helper.getLimitedWareAmount = ModLua.getLimitedWareAmount
	OldFuncs.getLimitedWareAmount = Helper.getLimitedWareAmount
	Helper.getLimitedWareAmount = ModLua.getLimitedWareAmount
end

function ModLua.onUpdate()
	-- call registered onUpdate callbacks
	if #onUpdateOneTimeCallbacks > 0 then
		-- clear list of one-time callbacks before calling them
		local currentcallbacks = onUpdateOneTimeCallbacks
		onUpdateOneTimeCallbacks = {}
		for _, callback in ipairs(currentcallbacks) do
			callback()
		end
	end
	if onUpdateHandler then
		onUpdateHandler()
	end
	if onChatUpdateHandler then
		onChatUpdateHandler()
	end

	-- kuertee start: callback
	if uix_callbacks ["onUpdate"] then
		for uix_id, uix_callback in pairs (uix_callbacks ["onUpdate"]) do
			name = uix_callback ()
		end
	end
	-- kuertee end: callback
end

function ModLua.getPassedTime(time)
	local passedtime = C.GetCurrentGameTime() - time
	if passedtime < 0 then
		print("Helper.getPassedTime(): given time is in the future. Returning empty result")
		return ""
	end

	-- kuertee start:
	if passedtime < 60 * 60 then
		local timeformat = ReadText(1001, 209)
		return ConvertTimeString(passedtime, timeformat)
	end
	-- kuertee end

	local timeformat = ReadText(1001, 211)
	if passedtime < 3600 then
		timeformat = ReadText(1001, 213)
	elseif passedtime < 3600 * 24 then
		timeformat = ReadText(1001, 212)
	end

	return ConvertTimeString(passedtime, timeformat)
end

function ModLua.checkTopLevelConditions(entry)
	local isdocked = false
	local currentplayership = ConvertStringTo64Bit(tostring(C.GetPlayerOccupiedShipID()))
	if currentplayership ~= 0 then
		if GetComponentData(currentplayership, "isdocked") then
			isdocked = true
		end
	else
		local currentcontainer = ConvertStringTo64Bit(tostring(C.GetContextByClass(C.GetPlayerID(), "container", false)))
		if (not C.IsComponentClass(currentcontainer, "ship")) or GetComponentData(currentcontainer, "isdocked") then
			isdocked = true
		end
	end

	if (entry.needsdock ~= nil) and (entry.needsdock ~= isdocked) then
		return false
	end
	if (entry.demo ~= nil) and (entry.demo ~= C.IsDemoVersion()) then
		return false
	end
	if (entry.canresearch ~= nil) and (entry.canresearch ~= C.CanResearch()) then
		return false
	end
	if (entry.canterraform ~= nil) then
		local stationhqlist = {}
		Helper.ffiVLA(stationhqlist, "UniverseID", C.GetNumHQs, C.GetHQs, "player")
		local hq = stationhqlist[1] or 0

		if hq == 0 then
			return not entry.canterraform
		end

		local hqcluster = C.GetContextByClass(hq, "cluster", false)
		return GetComponentData(ConvertStringTo64Bit(tostring(hqcluster)), "hasterraforming") and (C.GetNumTerraformingProjects(hqcluster, false) > 0)
	end
	if (entry.isonline ~= nil) and (entry.isonline ~= (C.AreVenturesCompatible() and (C.IsVentureSeasonSupported() or C.WasSessionOnline()))) then
		return false
	end
	if (entry.istimelinescenario ~= nil) and (entry.istimelinescenario ~= (C.IsTimelinesScenario() or (ffi.string(C.GetGameStartName()) == "x4ep1_gamestart_hub"))) then
		return false
	end

	-- kuertee start: callback
	if uix_callbacks ["checkTopLevelConditions_get_is_entry_available"] then
		local isAvailable = true
		for uix_id, uix_callback in pairs (uix_callbacks ["checkTopLevelConditions_get_is_entry_available"]) do
			isAvailable = uix_callback (entry)
			if isAvailable ~= true then
				return false
			end
		end
	end
	-- kuertee end: callback

	return true
end

function ModLua.createLSOStorageNode(menu, container, ware, planned, hasstorage, iscargo)
	local storageinfo_amounts  = C.IsInfoUnlockedForPlayer(container, "storage_amounts")
	local storageinfo_warelist = C.IsInfoUnlockedForPlayer(container, "storage_warelist")
	local storageinfo_capacity = C.IsInfoUnlockedForPlayer(container, "storage_capacity")

	local name, transporttype = GetWareData(ware, "name", "transport")

	-- kuertee start: callback
	if uix_callbacks ["createLSOStorageNode_get_ware_name"] then
		for uix_id, uix_callback in pairs (uix_callbacks ["createLSOStorageNode_get_ware_name"]) do
			name = uix_callback (ware)
		end
	end
	-- kuertee end: callback

	local cargo, isplayerowned = GetComponentData(container, "cargo", "isplayerowned")
	local productionlimit = 0
	if C.IsComponentClass(container, "container") then
		productionlimit = GetWareProductionLimit(container, ware)
	end
	local hasrestrictions = Helper.isTradeRestricted(container, ware)

	local shownamount = storageinfo_amounts and cargo[ware] or 0
	local shownmax = storageinfo_capacity and math.max(shownamount, productionlimit) or shownamount
	local buylimit, selllimit
	if isplayerowned then
		if C.HasContainerBuyLimitOverride(container, ware) then
			buylimit = math.max(0, math.min(shownmax, C.GetContainerBuyLimit(container, ware)))
		end
		if C.HasContainerSellLimitOverride(container, ware) then
			selllimit = math.max(buylimit or 0, math.min(shownmax, C.GetContainerSellLimit(container, ware)))
		end
	end

	local warenode = {
		cargo = iscargo,
		ware = ware,
		text = Helper.unlockInfo(storageinfo_warelist, name),
		type = transporttype,
		planned = planned,
		hasstorage = hasstorage,
		row = iscargo and 1 or nil,
		col = iscargo and 1 or nil,
		numrows = iscargo and 1 or nil,
		numcols = iscargo and 1 or nil,
		-- storage module
		{
			properties = {
				value = shownamount,
				max = shownmax,
				step = 1,
				slider1 = buylimit,
				slider2 = selllimit,
				helpOverlayID = "station_overview_storage_" .. ware,
				helpOverlayText = " ",
				helpOverlayHighlightOnly = true,
				uiTriggerID = "storage_" .. ware,
			},
			isstorage = true,
			expandedTableNumColumns = 3,
			expandHandler = function (...) return Helper.onExpandLSOStorageNode(menu, container, ...) end,
			collapseHandler = function (...) return Helper.onCollapseLSOStorageNode(menu, ...) end,
			sliderHandler = function (...) return Helper.onSliderChangedLSOStorageNode(container, ...) end,
			color = (not hasstorage) and Color["lso_node_inactive"] or nil,
			statuscolor = (not iscargo) and ((not hasstorage) and Color["icon_error"] or (hasrestrictions and Color["icon_warning"] or nil) or nil),
			statusIcon = (not iscargo) and ((not hasstorage) and "lso_warning" or (hasrestrictions and "lso_error" or nil) or nil),
		}
	}
	return warenode
end

function ModLua.updateLSOStorageNode(menu, node, container, ware)
	local hasrestrictions = Helper.isTradeRestricted(container, ware)
	local hasstorage = node.customdata.nodedata.hasstorage
	local edgecolor = Color["flowchart_edge_default"]

	local statusicon = hasrestrictions and "lso_error" or nil
	local statusiconmouseovertext = hasrestrictions and (ColorText["text_warning"] .. ReadText(1026, 8404)) or ""
	local statuscolor = hasrestrictions and Color["icon_warning"] or nil

	if not hasstorage then
		statusicon = "lso_warning"
		statuscolor = Color["icon_error"]
		statusiconmouseovertext = ColorText["text_error"] .. ReadText(1001, 8416)
	elseif menu.resourcesmissing[ware] then
		statusicon = "lso_warning"
		statuscolor = Color["icon_error"]
		statusiconmouseovertext = ColorText["text_error"] .. ReadText(1001, 8437)
	elseif menu.storagemissing[ware] then
		statusicon = "lso_warning"
		statuscolor = Color["icon_error"]
		statusiconmouseovertext = ColorText["text_error"] .. ReadText(1001, 8438)
	end

	if not statusicon then
		if C.IsComponentClass(container, "container") then
			if HasContainerStockLimitOverride(container, ware) then
				statusicon = "lso_override"
				statuscolor = Color["flowchart_node_default"]
				statusiconmouseovertext = ReadText(1026, 8410)

				local currentlimit = GetWareProductionLimit(container, ware)
				local defaultlimit = C.GetContainerWareMaxProductionStorageForTime(container, ware, 7200, true)
				local waretype = Helper.getContainerWareType(container, ware)
				if (waretype ~= "trade") and (currentlimit < defaultlimit) then
					statuscolor = Color["icon_warning"]
					statusiconmouseovertext = ColorText["text_warning"] .. ReadText(1001, 8467)
				end
			end
		end
	end

	if not C.IsInfoUnlockedForPlayer(container, "storage_amounts") then
		statusicon = nil
		statusbgicon = nil
	end

	if menu.storagemissing[ware] then
		edgecolor = Color["lso_node_error"]
	end

	local storageinfo_amounts = C.IsInfoUnlockedForPlayer(container, "storage_amounts")
	local amount = 0
	if storageinfo_amounts then
		amount = GetComponentData(container, "cargo")[ware] or 0
	end
	local max = 0
	if C.IsComponentClass(container, "controllable") then
		max = math.max(amount, GetWareProductionLimit(container, ware))
	end
	if max < node.properties.value then
		node:updateValue(amount)
	end
	if max > node.properties.max then
		node:updateMaxValue(max)
	end
	if node.properties.slider1 >= 0 then
		local slider1 = math.max(0, math.min(max, C.GetContainerBuyLimit(container, ware)))
		node:updateSlider1(slider1)
	end
	if node.properties.slider2 >= 0 then
		local slider2 = math.max(0, math.min(max, C.GetContainerSellLimit(container, ware)))
		node:updateSlider2(slider2)
	end
	if max < node.properties.max then
		node:updateMaxValue(max)
	end
	node:updateValue(amount)

	-- kuertee start: callback
	if uix_callbacks ["updateLSOStorageNode_pre_update_expanded_node"] then
		-- function widgetPrototypes.flowchartnode:updateStatus(text, icon, bgicon, color, mouseovertext)
		local status_text = nil
		local status_icon = statusicon
		local status_bgicon = nil
		local status_color = statuscolor
		local status_mouseovertext = statusiconmouseovertext
		for uix_id, uix_callback in pairs (uix_callbacks ["updateLSOStorageNode_pre_update_expanded_node"]) do
			status_text, status_icon, status_bgicon, status_color, status_mouseovertext = uix_callback(menu, node, container, ware, status_text, status_icon, status_bgicon, status_color, status_mouseovertext)
		end
		node:updateStatus(status_text, status_icon, status_bgicon, status_color, status_mouseovertext)
	else

		node:updateStatus(nil, statusicon, nil, statuscolor, statusiconmouseovertext)
	end
	-- kuertee end: callback

	for _, edge in ipairs(node.incomingEdges) do
		menu.updateEdgeColorRecursively(edge, edgecolor)
	end
end

function ModLua.onExpandLSOStorageNode(menu, container, _, ftable, _, nodedata)
	if not menu.wareReservationRegistered then
		RegisterEvent("newWareReservation", menu.newWareReservationCallback)
		menu.wareReservationRegistered = true
	end

	local storagename, minprice, maxprice, isprocessed = GetWareData(nodedata.ware, "storagename", "minprice", "maxprice", "isprocessed")
	local storageinfo_capacity =	C.IsInfoUnlockedForPlayer(container, "storage_capacity")
	local storageinfo_amounts =		C.IsInfoUnlockedForPlayer(container, "storage_amounts")

	local waretype = Helper.getContainerWareType(container, nodedata.ware)

	local reservations = {}
	local n = C.GetNumContainerWareReservations2(container, false, false, true)
	local buf = ffi.new("WareReservationInfo2[?]", n)
	n = C.GetContainerWareReservations2(buf, n, container, false, false, true)
	for i = 0, n - 1 do
		local issupply = buf[i].issupply
		if not issupply then
			local ware = ffi.string(buf[i].ware)
			local buyflag = buf[i].isbuyreservation and "selloffer" or "buyoffer" -- sic! Reservation to buy -> container is selling
			local invbuyflag = buf[i].isbuyreservation and "buyoffer" or "selloffer"
			local tradedeal = buf[i].tradedealid
			if not Helper.dirtyreservations[tostring(tradedeal)] then
				if reservations[ware] then
					table.insert(reservations[ware][buyflag], { reserver = buf[i].reserverid, amount = buf[i].amount, eta = buf[i].eta, tradedeal = tradedeal, issupply = issupply })
				else
					reservations[ware] = { [buyflag] = { { reserver = buf[i].reserverid, amount = buf[i].amount, eta = buf[i].eta, tradedeal = tradedeal, issupply = buf[i].issupply } }, [invbuyflag] = {} }
				end
			end
		end
	end
	for _, data in pairs(reservations) do
		table.sort(data.buyoffer, Helper.sortETA)
		table.sort(data.selloffer, Helper.sortETA)
	end

	ftable:setColWidthPercent(2, 30)
	ftable:setColWidth(3, Helper.scaleY(Helper.standardButtonHeight), false)
	local row
	if storageinfo_amounts then
		if nodedata.hasstorage and (not nodedata.planned) then
			local shown = false
			if menu.resourcesmissing[nodedata.ware] then
				shown = true
				row = ftable:addRow(nil, {  })
				row[1]:setColSpan(3):createText(ReadText(1001, 8437), { color = Color["text_error"] })
			end
			if menu.storagemissing[nodedata.ware] then
				shown = true
				row = ftable:addRow(nil, {  })
				row[1]:setColSpan(3):createText(ReadText(1001, 8438), { color = Color["text_error"] })
			end
			if shown then
				row = ftable:addRow(nil, {  })
				row[1]:setColSpan(3):createText("")
			end
		end
	end

	local limitslider
	if isprocessed then
		-- resource buffer
		row = ftable:addRow(nil, {  })
		row[1]:createText(ReadText(1001, 2415) .. ReadText(1001, 120))
		row[2]:setColSpan(2):createText(ReadText(20206, 1301), { halign = "right" })
		-- amount
		row = ftable:addRow(nil, {  })
		row[1]:createText(ReadText(1001, 6521) .. ReadText(1001, 120))
		row[2]:setColSpan(2):createText(function () return Helper.getResourceBufferAmount(container, nodedata.ware, storageinfo_amounts) end, { halign = "right" })
	else
		-- storage
		row = ftable:addRow(nil, {  })
		row[1]:createText(ReadText(1001, 2415) .. ReadText(1001, 120))
		row[2]:setColSpan(2):createText(storagename, { halign = "right" })
		-- missing storage type
		if not nodedata.hasstorage then
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(3):createText(ReadText(1001, 8416), { color = Color["text_error"], wordwrap = true })
		end
		if C.IsComponentClass(container, "container") then
			if not isprocessed then
				-- amount
				row = ftable:addRow(nil, {  })
				row[1]:createText(ReadText(1001, 6521) .. ReadText(1001, 120))
				row[2]:setColSpan(2):createText(function () return Helper.getStorageAmount(container, nodedata, storageinfo_amounts, storageinfo_capacity) end, { halign = "right", mouseOverText = function () return Helper.getStorageAmount(container, nodedata, storageinfo_amounts, storageinfo_capacity, 0, true) end })

				ftable:addEmptyRow(Helper.standardTextHeight / 2)

				row = ftable:addRow(nil, {  })
				row[1]:createText(ReadText(1001, 1600) .. " / " .. ReadText(1001, 102) .. ReadText(1001, 120))
				row[2]:setColSpan(2):createText(function () local production = C.GetContainerWareProduction(container, nodedata.ware, false); return Helper.unlockInfo(storageinfo_amounts, (production > 0) and ConvertIntegerString(production, true, 3, true, true) or "-") end, { halign = "right" })
				row = ftable:addRow(nil, {  })
				row[1]:createText(ReadText(1001, 1609) .. " / " .. ReadText(1001, 102) .. ReadText(1001, 120))
				row[2]:setColSpan(2):createText(function () local consumption = C.GetContainerWareConsumption(container, nodedata.ware, false) + Helper.getWorkforceConsumption(container, nodedata.ware); return Helper.unlockInfo(storageinfo_amounts, (consumption > 0) and ConvertIntegerString(consumption, true, 3, true, true) or "-") end, { halign = "right" })
				ftable:addEmptyRow(Helper.standardTextHeight / 2)
			end

			if nodedata.hasstorage and (not nodedata.planned) and GetComponentData(container, "isplayerowned") then
				local currentlimit = GetWareProductionLimit(container, nodedata.ware)
				if (not nodedata.cargo) or (currentlimit > 0) then
					local haslimitoverride = HasContainerStockLimitOverride(container, nodedata.ware)
					-- Automatically allocated capacity
					local n = C.GetNumContainerStockLimitOverrides(container)
					if n > 0 then
						local name, capacity = "", 0
						local n = C.GetNumCargoTransportTypes(container, true)
						local buf = ffi.new("StorageInfo[?]", n)
						n = C.GetCargoTransportTypes(buf, n, container, true, false)
						for i = 0, n - 1 do
							if ffi.string(buf[i].transport) == nodedata.type then
								name = ffi.string(buf[i].name)
								capacity = buf[i].capacity
								break
							end
						end

						row = ftable:addRow(nil, {  })
						row[1]:setColSpan(3):createText(ReadText(1001, 8444) .. ReadText(1001, 120), { mouseOverText = ReadText(1026, 8403) })
						row = ftable:addRow(nil, {  })
						row[1]:createText(name)
						row[2]:setColSpan(2):createText(
							function()
								local total = 0
								local n = C.GetNumContainerStockLimitOverrides(container)
								local buf = ffi.new("UIWareInfo[?]", n)
								n = C.GetContainerStockLimitOverrides(buf, n, container)
								for i = 0, n - 1 do
									local ware = ffi.string(buf[i].ware)
									local transporttype, volume = GetWareData(ware, "transport", "volume")
									if transporttype == nodedata.type then
										total = total + buf[i].amount * volume
									end
								end
								local available = math.max(0, capacity - total)
								local color = Color["text_normal"]
								if available == 0 then
									color = Color["text_error"]
								elseif available < 0.1 * capacity then
									color = Color["text_warning"]
								end
								return Helper.unlockInfo(storageinfo_amounts, Helper.convertColorToText(color) .. ConvertIntegerString(available, true, 3, true, true) .. " " .. ReadText(1001, 110))
							end,
							{ halign = "right" }
						)
					end
					-- automatic storage level
					local row = ftable:addRow("autostoragecheckbox", {  })
					if menu.selectedRowData["nodeTable"] == "autostoragecheckbox" then
						menu.selectedRows["nodeTable"] = row.index
						menu.selectedRowData["nodeTable"] = nil
					end
					row[1]:setColSpan(2):createText(ReadText(1001, 8439) .. ReadText(1001, 120))
					row[3]:createCheckBox(not haslimitoverride, { height = Helper.standardButtonHeight })
					row[3].handlers.onClick = function (_, checked) return Helper.checkboxStorageLevelOverride(menu, container, nodedata.ware, row.index, currentlimit, checked) end
					if haslimitoverride then
						-- price
						local row = ftable:addRow("autostorageslider", {  })
						if menu.selectedRowData["nodeTable"] == "autostorageslider" then
							menu.selectedRows["nodeTable"] = row.index
							menu.selectedRowData["nodeTable"] = nil
						end
						local max = GetWareCapacity(container, nodedata.ware)
						limitslider = row[1]:setColSpan(3):createSliderCell({
							height = Helper.standardTextHeight,
							bgColor = haslimitoverride and Color["slider_background_default"] or Color["slider_background_inactive"],
							valueColor = haslimitoverride and Color["slider_value"] or Color["slider_value_inactive"],
							min = 0,
							minSelect = 1,
							max = max,
							start = math.max(1, math.min(max, currentlimit)),
							hideMaxValue = true,
							readOnly = not haslimitoverride,
							forceArrows = true,
						})
					end
				end
			end
		end
	end
	if nodedata.hasstorage and (not nodedata.planned) and GetComponentData(container, "isplayerowned") then
		Helper.LSOStorageNodeBuySlider = nil
		Helper.LSOStorageNodeSellSlider = nil
		-- buy offer
		if (waretype == "resource") or (waretype == "intermediate") or (waretype == "product") or (waretype == "trade") then
			-- kuertee start: callback
			if uix_callbacks ["onExpandLSOStorageNode_pre_buy_offer_title"] then
				for uix_id, uix_callback in pairs (uix_callbacks ["onExpandLSOStorageNode_pre_buy_offer_title"]) do
					uix_callback(menu, container, ftable, nodedata)
				end
			end
			-- kuertee end: callback

			local currentprice = math.max(minprice, math.min(maxprice, RoundTotalTradePrice(GetContainerWarePrice(container, nodedata.ware, true))))
			local haspriceoverride = HasContainerWarePriceOverride(container, nodedata.ware, true)
			local istradewarebought = C.GetContainerWareIsBuyable(container, nodedata.ware)
			local currentlimit = C.GetContainerBuyLimit(container, nodedata.ware)
			local haslimitoverride = C.HasContainerBuyLimitOverride(container, nodedata.ware)
			-- title
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(3):createText(ReadText(1001, 8309), Helper.subHeaderTextProperties)
			row[1].properties.halign = "center"
			if (waretype == "resource") or (waretype == "intermediate") or istradewarebought or haslimitoverride then
				-- automatic buy limit
				local row = ftable:addRow("autobuylimitcheckbox", {  })
				if menu.selectedRowData["nodeTable"] == "autobuylimitcheckbox" then
					menu.selectedRows["nodeTable"] = row.index
					menu.selectedRowData["nodeTable"] = nil
				end
				if (waretype == "product") and istradewarebought then
					-- Valid case, but we need to hide it from the player
					currentlimit = math.max(1, currentlimit)
					Helper.setBuyLimit(menu, container, nodedata.ware, currentlimit)
					haslimitoverride = true
				end
				if (waretype == "product") then
					row[1]:setColSpan(3):createText(ReadText(1001, 11281) .. ReadText(1001, 120), { mouseOverText = ReadText(1026, 8401) })
				else
					if haslimitoverride then
						row[1]:setColSpan(2):createText(ReadText(1001, 11281) .. ReadText(1001, 120), { mouseOverText = ReadText(1026, 8401) })
					else
						row[1]:setColSpan(2):createText(ReadText(1001, 8440), { mouseOverText = ReadText(1026, 8408) })
					end
					row[3]:createCheckBox(not haslimitoverride, { height = Helper.standardButtonHeight })
					row[3].handlers.onClick = function (_, checked) return Helper.checkboxBuyLimitOverride(menu, container, nodedata.ware, row.index, currentlimit, checked) end
				end
				-- buy limit
				local row = ftable:addRow("autobuylimitslider", {  })
				if menu.selectedRowData["nodeTable"] == "autobuylimitslider" then
					menu.selectedRows["nodeTable"] = row.index
					menu.selectedRowData["nodeTable"] = nil
				end
				local max = GetWareProductionLimit(container, nodedata.ware)
				Helper.LSOStorageNodeBuySlider = { ware = nodedata.ware, widget = row[1]:setColSpan(3):createSliderCell({
					height = Helper.standardTextHeight,
					bgColor = haslimitoverride and Color["slider_background_default"] or Color["slider_background_inactive"],
					valueColor = haslimitoverride and Color["slider_value"] or Color["slider_value_inactive"],
					min = 0,
					minSelect = max == 0 and 0 or 1,
					max = max,
					start = math.min(max, currentlimit),
					hideMaxValue = true,
					readOnly = not haslimitoverride,
					forceArrows = true,
				})}
				-- automatic pricing
				local row = ftable:addRow("autobuypricecheckbox", {  })
				if menu.selectedRowData["nodeTable"] == "autobuypricecheckbox" then
					menu.selectedRows["nodeTable"] = row.index
					menu.selectedRowData["nodeTable"] = nil
				end
				if haspriceoverride then
					row[1]:setColSpan(2):createText(ReadText(1001, 8402) .. ReadText(1001, 120), { wordwrap = true })
				else
					row[1]:createText(ReadText(1001, 8402) .. ReadText(1001, 120), { wordwrap = true })
					row[2]:createText(function () return ConvertMoneyString(math.max(minprice, math.min(maxprice, GetContainerWarePrice(container, nodedata.ware, true))), true, true, 2, true) .. " " .. ReadText(1001, 101) end, { halign = "right" })
				end
				row[3]:createCheckBox(not haspriceoverride, { height = Helper.standardButtonHeight })
				row[3].handlers.onClick = function (_, checked) return Helper.checkboxStorageWarePriceOverride(menu, container, nodedata.ware, row.index, true, currentprice, checked) end
				if haspriceoverride then
					-- price
					local row = ftable:addRow("autobuypriceslider", {  })
					if menu.selectedRowData["nodeTable"] == "autobuypriceslider" then
						menu.selectedRows["nodeTable"] = row.index
						menu.selectedRowData["nodeTable"] = nil
					end
					row[1]:setColSpan(3):createSliderCell({
						height = Helper.standardTextHeight,
						bgColor = haslimitoverride and Color["slider_background_default"] or Color["slider_background_inactive"],
						valueColor = haspriceoverride and Color["slider_value"] or Color["slider_value_inactive"],
						min = minprice,
						max = maxprice,
						start = currentprice,
						hideMaxValue = true,
						suffix = ReadText(1001, 101),
						readOnly = not haspriceoverride,
						forceArrows = true,
					})
					row[1].handlers.onSliderCellChanged = function(_, value) return Helper.slidercellStorageWarePriceOverride(container, nodedata.ware, true, value) end
					row[1].handlers.onSliderCellActivated = function (id) menu.noupdate = true end
					row[1].handlers.onSliderCellDeactivated = function (id) menu.noupdate = false end
				end
				-- trade rule
				local hasownlist = C.HasContainerOwnTradeRule(container, "buy", nodedata.ware)
				local traderuleid = C.GetContainerTradeRuleID(container, "buy", nodedata.ware)
				local row = ftable:addRow(nil, {  })
				row[1]:setColSpan(3):createText(ReadText(1001, 11013) .. ReadText(1001, 120), textproperties)
				-- global
				local row = ftable:addRow("buytraderule_global", {  })
				row[1]:setColSpan(2):createText(ReadText(1001, 11025) .. ReadText(1001, 120), textproperties)
				row[3]:createCheckBox(not hasownlist, { height = Helper.standardButtonHeight })
				row[3].handlers.onClick = function(_, checked) return Helper.checkboxSetTradeRuleOverride(menu, container, "buy", nodedata.ware, checked) end
				-- current
				local row = ftable:addRow("buytraderule_current", {  })
				row[1]:setColSpan(2):createDropDown(Helper.traderuleOptions, { startOption = (traderuleid ~= 0) and traderuleid or -1, active = hasownlist }):setTextProperties({ fontsize = config.mapFontSize })
				row[1].handlers.onDropDownConfirmed = function (_, id) return Helper.dropdownTradeRule(menu, container, "buy", nodedata.ware, id) end
				row[1].handlers.onDropDownActivated = function () menu.noupdate = true end
				row[3]:createButton({ mouseOverText = ReadText(1026, 8407) }):setIcon("menu_edit")
				row[3].handlers.onClick = function () return Helper.buttonEditTradeRule(menu) end
			end
			-- create / remove offer
			if (waretype == "trade") or (waretype == "product") then
				row = ftable:addRow("tradebuy", {  })
				if menu.selectedRowData["nodeTable"] == "trade" then
					menu.selectedRows["nodeTable"] = row.index
					menu.selectedRowData["nodeTable"] = nil
				end
				if waretype == "trade" then
					row[1]:setColSpan(3):createButton({  }):setText(istradewarebought and ReadText(1001, 8407) or ReadText(1001, 8406), { halign = "center" })
					row[1].handlers.onClick = function () return Helper.buttonStorageBuyTradeWare(menu, container, nodedata.ware, istradewarebought) end
				elseif waretype == "product" then
					row[1]:setColSpan(3):createButton({  }):setText((haslimitoverride or istradewarebought) and ReadText(1001, 8407) or ReadText(1001, 8406), { halign = "center" })
					row[1].handlers.onClick = function () return Helper.buttonStorageBuyProductWare(menu, container, nodedata.ware, haslimitoverride or istradewarebought, currentlimit) end
				end
			end
			-- reservations
			if reservations[nodedata.ware] and (#reservations[nodedata.ware].buyoffer > 0) then
				-- title
				row = ftable:addRow(nil, {  })
				row[1]:setColSpan(3):createText(string.format(ReadText(1001, 7994), GetWareData(nodedata.ware, "name")) .. ReadText(1001, 120), { wordwrap = true })
				for i, reservation in ipairs(reservations[nodedata.ware].buyoffer) do
					row = ftable:addRow("buyreservation" .. i, {  })
					if menu.selectedRowData["nodeTable"] == "buyreservation" then
						menu.selectedRows["nodeTable"] = row.index
						menu.selectedRowData["nodeTable"] = nil
					end
					local isplayerowned = GetComponentData(ConvertStringTo64Bit(tostring(reservation.reserver)), "isplayerowned")
					local name = (isplayerowned and ColorText["text_player"] or "") .. ffi.string(C.GetComponentName(reservation.reserver)) .. " (" .. ffi.string(C.GetObjectIDCode(reservation.reserver)) .. ")\27X"

					-- kuertee start: callback
					-- row[1]:createText(function () return Helper.getETAString(name, reservation.eta) end, { font = Helper.standardFontMono })
					if uix_callbacks ["onExpandLSOStorageNode_list_incoming_trade"] then
						for uix_id, uix_callback in pairs (uix_callbacks ["onExpandLSOStorageNode_list_incoming_trade"]) do
							uix_callback (row, name, reservation, isplayerowned)
						end
					else
						row[1]:createText(function () return Helper.getETAString(name, reservation.eta) end, { font = Helper.standardFontMono })
					end
					-- kuertee end: callback

					row[2]:createText(ConvertIntegerString(reservation.amount, true, 3, false), { halign = "right" })
					row[3]:createButton({ active = function () return Helper.buttonCancelTradeActive(menu, container, reservation.tradedeal) end, mouseOverText = ReadText(1026, 7924) }):setText("X", { halign = "center" })
					row[3].handlers.onClick = function () return Helper.buttonCancelTrade(menu, container, reservation.tradedeal) end
				end
			end
		end

		-- sell offer
		if (not isprocessed) and ((waretype == "resource") or (waretype == "product") or (waretype == "intermediate") or (waretype == "trade")) then
			-- kuertee start: callback
			if uix_callbacks ["onExpandLSOStorageNode_pre_sell_offer_title"] then
				for uix_id, uix_callback in pairs (uix_callbacks ["onExpandLSOStorageNode_pre_sell_offer_title"]) do
					uix_callback(menu, container, ftable, nodedata)
				end
			end
			-- kuertee end: callback

			local currentprice = math.max(minprice, math.min(maxprice, RoundTotalTradePrice(GetContainerWarePrice(container, nodedata.ware, false))))
			local haspriceoverride = HasContainerWarePriceOverride(container, nodedata.ware, false)
			local istradewaresold = C.GetContainerWareIsSellable(container, nodedata.ware)
			local currentlimit = C.GetContainerSellLimit(container, nodedata.ware)
			local haslimitoverride = C.HasContainerSellLimitOverride(container, nodedata.ware)
			-- title
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(3):createText(ReadText(1001, 8308), Helper.subHeaderTextProperties)
			row[1].properties.halign = "center"
			if (waretype == "product") or (waretype == "intermediate") or istradewaresold or haslimitoverride then
				-- automatic sell limit
				local row = ftable:addRow("autoselllimitcheckbox", {  })
				if menu.selectedRowData["nodeTable"] == "autoselllimitcheckbox" then
					menu.selectedRows["nodeTable"] = row.index
					menu.selectedRowData["nodeTable"] = nil
				end
				if (waretype == "resource") and istradewaresold then
					-- Valid case, but we need to hide it from the player
					Helper.setSellLimit(menu, container, nodedata.ware, currentlimit)
					haslimitoverride = true
				end
				if (waretype == "resource") then
					row[1]:setColSpan(3):createText(ReadText(1001, 11282 ) .. ReadText(1001, 120), { mouseOverText = ReadText(1026, 8402) })
				else
					if haslimitoverride then
						row[1]:setColSpan(2):createText(ReadText(1001, 11282) .. ReadText(1001, 120), { mouseOverText = ReadText(1026, 8402) })
					else
						row[1]:setColSpan(2):createText(ReadText(1001, 8441), { mouseOverText = ReadText(1026, 8409) })
					end
					row[3]:createCheckBox(not haslimitoverride, { height = Helper.standardButtonHeight })
					row[3].handlers.onClick = function (_, checked) return Helper.checkboxSellLimitOverride(menu, container, nodedata.ware, row.index, currentlimit, checked) end
				end
				-- sell limit
				local row = ftable:addRow("autoselllimitslider", {  })
				if menu.selectedRowData["nodeTable"] == "autoselllimitslider" then
					menu.selectedRows["nodeTable"] = row.index
					menu.selectedRowData["nodeTable"] = nil
				end
				local max = GetWareProductionLimit(container, nodedata.ware)
				Helper.LSOStorageNodeSellSlider = { ware = nodedata.ware, widget = row[1]:setColSpan(3):createSliderCell({
					height = Helper.standardTextHeight,
					bgColor = haslimitoverride and Color["slider_background_default"] or Color["slider_background_inactive"],
					valueColor = haslimitoverride and Color["slider_value"] or Color["slider_value_inactive"],
					min = 0,
					minSelect = max == 0 and 0 or 1,
					max = max,
					start = math.min(max, currentlimit),
					hideMaxValue = true,
					readOnly = not haslimitoverride,
					forceArrows = true,
				})}
				-- automatic pricing
				local row = ftable:addRow("autosellpricecheckbox", {  })
				if menu.selectedRowData["nodeTable"] == "autosellpricecheckbox" then
					menu.selectedRows["nodeTable"] = row.index
					menu.selectedRowData["nodeTable"] = nil
				end
				if haspriceoverride then
					row[1]:createText(ReadText(1001, 8402) .. ReadText(1001, 120), { wordwrap = true })
				else
					row[1]:createText(ReadText(1001, 8402) .. ReadText(1001, 120), { wordwrap = true })
					row[2]:createText(function () return ConvertMoneyString(math.max(minprice, math.min(maxprice, GetContainerWarePrice(container, nodedata.ware, false))), true, true, 2, true) .. " " .. ReadText(1001, 101) end, { halign = "right" })
				end
				row[3]:createCheckBox(not haspriceoverride, { height = Helper.standardButtonHeight })
				row[3].handlers.onClick = function (_, checked) return Helper.checkboxStorageWarePriceOverride(menu, container, nodedata.ware, row.index, false, currentprice, checked) end
				if haspriceoverride then
					-- price
					local row = ftable:addRow("autosellpriceslider", {  })
					if menu.selectedRowData["nodeTable"] == "autosellpriceslider" then
						menu.selectedRows["nodeTable"] = row.index
						menu.selectedRowData["nodeTable"] = nil
					end
					row[1]:setColSpan(3):createSliderCell({
						height = Helper.standardTextHeight,
						bgColor = haslimitoverride and Color["slider_background_default"] or Color["slider_background_inactive"],
						valueColor = haspriceoverride and Color["slider_value"] or Color["slider_value_inactive"],
						min = minprice,
						max = maxprice,
						start = currentprice,
						hideMaxValue = true,
						suffix = ReadText(1001, 101),
						readOnly = not haspriceoverride,
						forceArrows = true,
					})
					row[1].handlers.onSliderCellChanged = function(_, value) return Helper.slidercellStorageWarePriceOverride(container, nodedata.ware, false, value) end
					row[1].handlers.onSliderCellActivated = function (id) menu.noupdate = true end
					row[1].handlers.onSliderCellDeactivated = function (id) menu.noupdate = false end
				end
				-- trade rule
				local hasownlist = C.HasContainerOwnTradeRule(container, "sell", nodedata.ware)
				local traderuleid = C.GetContainerTradeRuleID(container, "sell", nodedata.ware)
				local row = ftable:addRow(nil, {  })
				row[1]:setColSpan(3):createText(ReadText(1001, 11013) .. ReadText(1001, 120), textproperties)
				-- global
				local row = ftable:addRow("selltraderule_global", {  })
				row[1]:setColSpan(2):createText(ReadText(1001, 11025) .. ReadText(1001, 120), textproperties)
				row[3]:createCheckBox(not hasownlist, { height = Helper.standardButtonHeight })
				row[3].handlers.onClick = function(_, checked) return Helper.checkboxSetTradeRuleOverride(menu, container, "sell", nodedata.ware, checked) end
				-- current
				local row = ftable:addRow("selltraderule_current", {  })
				row[1]:setColSpan(2):createDropDown(Helper.traderuleOptions, { startOption = (traderuleid ~= 0) and traderuleid or -1, active = hasownlist }):setTextProperties({ fontsize = config.mapFontSize })
				row[1].handlers.onDropDownConfirmed = function (_, id) return Helper.dropdownTradeRule(menu, container, "sell", nodedata.ware, id) end
				row[1].handlers.onDropDownActivated = function () menu.noupdate = true end
				row[3]:createButton({ mouseOverText = ReadText(1026, 8407) }):setIcon("menu_edit")
				row[3].handlers.onClick = function () return Helper.buttonEditTradeRule(menu) end
			end
			-- create / remove offer
			if (waretype == "trade") or (waretype == "resource") then
				row = ftable:addRow("tradesell", {  })
				if menu.selectedRowData["nodeTable"] == "trade" then
					menu.selectedRows["nodeTable"] = row.index
					menu.selectedRowData["nodeTable"] = nil
				end
				if waretype == "trade" then
					row[1]:setColSpan(3):createButton({  }):setText(istradewaresold and ReadText(1001, 8405) or ReadText(1001, 8404), { halign = "center" })
					row[1].handlers.onClick = function () return Helper.buttonStorageSellTradeWare(menu, container, nodedata.ware, istradewaresold) end
				elseif waretype == "resource" then
					row[1]:setColSpan(3):createButton({  }):setText((haslimitoverride or istradewaresold) and ReadText(1001, 8405) or ReadText(1001, 8404), { halign = "center" })
					row[1].handlers.onClick = function () return Helper.buttonStorageSellResourceWare(menu, container, nodedata.ware, haslimitoverride or istradewaresold, currentlimit) end
				end
			end
			-- reservations
			if reservations[nodedata.ware] and (#reservations[nodedata.ware].selloffer > 0) then
				-- title
				row = ftable:addRow(nil, {  })
				row[1]:setColSpan(3):createText(string.format(ReadText(1001, 7993), GetWareData(nodedata.ware, "name")) .. ReadText(1001, 120), { wordwrap = true })
				for i, reservation in ipairs(reservations[nodedata.ware].selloffer) do
					row = ftable:addRow("sellreservation" .. i, {  })
					if menu.selectedRowData["nodeTable"] == "sellreservation" then
						menu.selectedRows["nodeTable"] = row.index
						menu.selectedRowData["nodeTable"] = nil
					end
					local isplayerowned = GetComponentData(ConvertStringTo64Bit(tostring(reservation.reserver)), "isplayerowned")
					local name = (isplayerowned and ColorText["text_player"] or "") .. ffi.string(C.GetComponentName(reservation.reserver)) .. " (" .. ffi.string(C.GetObjectIDCode(reservation.reserver)) .. ")\27X"

					-- kuertee start: callback
					-- row[1]:createText(function () return Helper.getETAString(name, reservation.eta) end, { font = Helper.standardFontMono })
					if uix_callbacks ["onExpandLSOStorageNode_list_incoming_trade"] then
						for uix_id, uix_callback in pairs (uix_callbacks ["onExpandLSOStorageNode_list_incoming_trade"]) do
							uix_callback (row, name, reservation, isplayerowned)
						end
					else
						row[1]:createText(function () return Helper.getETAString(name, reservation.eta) end, { font = Helper.standardFontMono })
					end
					-- kuertee end: callback

					row[2]:createText(ConvertIntegerString(reservation.amount, true, 3, false), { halign = "right" })
					row[3]:createButton({ active = function () return Helper.buttonCancelTradeActive(menu, container, reservation.tradedeal) end, mouseOverText = ReadText(1026, 7924) }):setText("X", { halign = "center" })
					row[3].handlers.onClick = function () return Helper.buttonCancelTrade(menu, container, reservation.tradedeal) end
				end
			end
		end

		-- buy/sell slider hooks
		if limitslider then
			limitslider.handlers.onSliderCellChanged = function (_, value) return Helper.slidercellStorageLevelOverride(menu, container, nodedata.ware, value, Helper.LSOStorageNodeBuySlider, Helper.LSOStorageNodeSellSlider) end
			limitslider.handlers.onSliderCellActivated = function (id) menu.noupdate = true end
			limitslider.handlers.onSliderCellDeactivated = function (id) menu.noupdate = false end
		end
		if Helper.LSOStorageNodeBuySlider then
			Helper.LSOStorageNodeBuySlider.widget.handlers.onSliderCellChanged = function(_, value) return Helper.slidercellBuyLimitOverride(menu, container, nodedata.ware, value, Helper.LSOStorageNodeSellSlider) end
			Helper.LSOStorageNodeBuySlider.widget.handlers.onSliderCellActivated = function (id) menu.noupdate = true end
			Helper.LSOStorageNodeBuySlider.widget.handlers.onSliderCellDeactivated = function (id) menu.noupdate = false end
		end
		if Helper.LSOStorageNodeSellSlider then
			Helper.LSOStorageNodeSellSlider.widget.handlers.onSliderCellChanged = function(_, value) return Helper.slidercellSellLimitOverride(menu, container, nodedata.ware, value, Helper.LSOStorageNodeBuySlider) end
			Helper.LSOStorageNodeSellSlider.widget.handlers.onSliderCellActivated = function (id) menu.noupdate = true end
			Helper.LSOStorageNodeSellSlider.widget.handlers.onSliderCellDeactivated = function (id) menu.noupdate = false end
		end
	end

	if menu.selectedRowData["nodeTable"] then
		menu.selectedCols["nodeTable"] = nil
	end
	menu.restoreTableState("nodeTable", ftable)

	-- kuertee start: callback
	if uix_callbacks ["onExpandLSOStorageNode"] then
		for uix_id, uix_callback in pairs (uix_callbacks ["onExpandLSOStorageNode"]) do
			uix_callback(menu, container, ftable, nodedata)
		end
	end
	-- kuertee end: callback
end

function ModLua.checkboxSetTradeRuleOverride(menu, container, type, ware, checked)
	if checked then
		C.SetContainerTradeRule(container, -1, type, ware, false)
	else
		local currentid = C.GetContainerTradeRuleID(container, type, ware or "")
		C.SetContainerTradeRule(container, (currentid ~= 0) and currentid or -1, type, ware, true)
	end

	if (type == "buy") or (type == "sell") then

		-- kuertee start: callback
		if uix_callbacks ["checkboxSetTradeRuleOverride_pre_update_expanded_node"] then
			-- function widgetPrototypes.flowchartnode:updateStatus(text, icon, bgicon, color, mouseovertext)
			local status_text = nil
			local status_icon = Helper.isTradeRestricted(container, ware) and "lso_error" or nil
			local status_bgicon = nil
			local status_color = Color["icon_warning"]
			local status_mouseovertext
			for uix_id, uix_callback in pairs (uix_callbacks ["checkboxSetTradeRuleOverride_pre_update_expanded_node"]) do
				status_text, status_icon, status_bgicon, status_color, status_mouseovertext = uix_callback(menu, container, type, ware, checked, status_text, status_icon, status_bgicon, status_color, status_mouseovertext)
			end
			menu.expandedNode:updateStatus(status_text, status_icon, status_bgicon, status_color, status_mouseovertext)
		else

			menu.expandedNode:updateStatus(nil, Helper.isTradeRestricted(container, ware) and "lso_error" or nil, nil, Color["icon_warning"])
		end
		-- kuertee end: callback

	end
	menu.updateExpandedNode()
end

function  Helper.dropdownTradeRule(menu, container, type, ware, id)
	C.SetContainerTradeRule(container, tonumber(id), type, ware, true)

	if (type == "buy") or (type == "sell") then

		-- kuertee start: callback
		if uix_callbacks ["dropdownTradeRule_pre_update_expanded_node"] then
			-- function widgetPrototypes.flowchartnode:updateStatus(text, icon, bgicon, color, mouseovertext)
			local status_text = nil
			local status_icon = Helper.isTradeRestricted(container, ware) and "lso_error" or nil
			local status_bgicon = nil
			local status_color = Color["icon_warning"]
			local status_mouseovertext = nil
			for uix_id, uix_callback in pairs (uix_callbacks ["dropdownTradeRule_pre_update_expanded_node"]) do
				status_text, status_icon, status_bgicon, status_color, status_mouseovertext = uix_callback(menu, container, type, ware, id, status_text, status_icon, status_bgicon, status_color, status_mouseovertext)
			end
			menu.expandedNode:updateStatus(status_text, status_icon, status_bgicon, status_color, mouseOverText)
		else

			menu.expandedNode:updateStatus(nil, Helper.isTradeRestricted(container, ware) and "lso_error" or nil, nil, Color["icon_warning"])
		end
		-- kuertee end: callback

	end
	menu.noupdate = false
end

function ModLua.onCollapseLSOStorageNode(menu, nodedata)
	UnregisterEvent("newWareReservation", menu.newWareReservationCallback)
	menu.wareReservationRegistered = nil
	Helper.LSOStorageNodeBuySlider = nil
	Helper.LSOStorageNodeSellSlider = nil

	-- kuertee start: callback
	if uix_callbacks ["onCollapseLSOStorageNode"] then
		for uix_id, uix_callback in pairs (uix_callbacks ["onCollapseLSOStorageNode"]) do
			uix_callback (menu, nodedata)
		end
	end
	-- kuertee end: callback
end

function ModLua.getLimitedWareAmount(ware)

	-- kuertee start: do not fail when modified
	-- if C.IsGameModified() then
	-- 	return tonumber(ffi.string(C.GetUserData("limited_blueprint_" .. ware))) or 0
	-- end
	-- kuertee end: do not fail when modified

	return tonumber(ffi.string(C.GetUserDataSigned("limited_blueprint_" .. ware))) or 0
end

ModLua.rewriteFunctions()

-- kuertee end: rewrites

-- kuertee start: new funcs

function ModLua.addNewFunctions()
	Helper.registerCallback = ModLua.registerCallback
	Helper.deregisterCallback = ModLua.deregisterCallback
	Helper.updateCallback = ModLua.updateCallback
	Helper.debugText = ModLua.debugText
	Helper.debugText_forced = ModLua.debugText_forced
	Helper.setDebugCallbacks = ModLua.setDebugCallbacks
end

local uix_callbackCount = 0
function ModLua.registerCallback(callbackName, callbackFunction, id)
    -- note 1: format is generally [function name]_[action]. e.g.: in kuertee_menu_transporter, "display_on_set_room_active" overrides the room's active property with the return of the callback.
    -- note 2: events have the word "_on_" followed by a PRESENT TENSE verb. e.g.: in kuertee_menu_transporter, "display_on_set_buttontable" is called after all of the rows of buttontable are set.
    -- note 3: new callbacks can be added or existing callbacks can be edited. but commit your additions/changes to the mod's GIT repository.
    -- note 4: search for the callback names to see where they are executed.
    -- note 5: if a callback requires a return value, return it in an object var. e.g. "display_on_set_room_active" requires a return of {active = true | false}.
    if uix_callbacks [callbackName] == nil then
        uix_callbacks [callbackName] = {}
    end
    if not uix_callbacks[callbackName][id] then
        if not id then
            uix_callbackCount = uix_callbackCount + 1
            id = "_" .. tostring(uix_callbackCount)
        end
        uix_callbacks[callbackName][id] = callbackFunction
        if Helper.isDebugCallbacks then
            DebugError("uix registerCallback: uix_callbacks[" .. tostring(callbackName) .. "][" .. tostring(id) .. "]: " .. tostring(uix_callbacks[callbackName][id]))
        end
    else
        DebugError("uix registerCallback: callback at " .. callbackName .. " with id " .. tostring(id) .. " was already previously registered")
    end
end

local uix_isDeregisterQueued
local uix_callbacks_toDeregister = {}
function ModLua.deregisterCallback(callbackName, callbackFunction, id)
    if not uix_callbacks_toDeregister[callbackName] then
        uix_callbacks_toDeregister[callbackName] = {}
    end
    if id then
        table.insert(uix_callbacks_toDeregister[callbackName], id)
    else
        if uix_callbacks[callbackName] then
            for id, func in pairs(uix_callbacks[callbackName]) do
                if func == callbackFunction then
                    table.insert(uix_callbacks_toDeregister[callbackName], id)
                end
            end
        end
    end
    if not uix_isDeregisterQueued then
        uix_isDeregisterQueued = true
        Helper.addDelayedOneTimeCallbackOnUpdate(ModLua.deregisterCallbacksNow, true, getElapsedTime() + 1)
    end
end

function ModLua.deregisterCallbacksNow()
    uix_isDeregisterQueued = nil
    for callbackName, ids in pairs(uix_callbacks_toDeregister) do
        if uix_callbacks[callbackName] then
            for _, id in ipairs(ids) do
                if uix_callbacks[callbackName][id] then
                    if Helper.isDebugCallbacks then
                        DebugError("uix deregisterCallbacksNow (pre): uix_callbacks[" .. tostring(callbackName) .. "][" .. tostring(id) .. "]: " .. tostring(uix_callbacks[callbackName][id]))
                    end
                    uix_callbacks[callbackName][id] = nil
                    if Helper.isDebugCallbacks then
                        DebugError("uix deregisterCallbacksNow (post): uix_callbacks[" .. tostring(callbackName) .. "][" .. tostring(id) .. "]: " .. tostring(uix_callbacks[callbackName][id]))
                    end
                else
                    DebugError("uix deregisterCallbacksNow: callback at " .. callbackName .. " with id " .. tostring(id) .. " doesn't exist")
                end
            end
        end
    end
    uix_callbacks_toDeregister = {}
end

local uix_isUpdateQueued
local uix_callbacks_toUpdate = {}
function ModLua.updateCallback(callbackName, id, callbackFunction)
    if not uix_callbacks_toUpdate[callbackName] then
        uix_callbacks_toUpdate[callbackName] = {}
    end
    if id then
        table.insert(uix_callbacks_toUpdate[callbackName], {id = id, callbackFunction = callbackFunction})
    end
    if not uix_isUpdateQueued then
        uix_isUpdateQueued = true
        Helper.addDelayedOneTimeCallbackOnUpdate(ModLua.updateCallbacksNow, true, getElapsedTime() + 1)
    end
end

function ModLua.updateCallbacksNow()
    uix_isUpdateQueued = nil
    for callbackName, updateDatas in pairs(uix_callbacks_toUpdate) do
        if uix_callbacks[callbackName] then
            for _, updateData in ipairs(updateDatas) do
                if uix_callbacks[callbackName][updateData.id] then
                    if Helper.isDebugCallbacks then
                        DebugError("uix updateCallbacksNow (pre): uix_callbacks[" .. tostring(callbackName) .. "][" .. tostring(updateData.id) .. "]: " .. tostring(uix_callbacks[callbackName][updateData.id]))
                    end
                    uix_callbacks[callbackName][updateData.id] = updateData.callbackFunction
                    if Helper.isDebugCallbacks then
                        DebugError("uix updateCallbacksNow (post): uix_callbacks[" .. tostring(callbackName) .. "][" .. tostring(updateData.id) .. "]: " .. tostring(uix_callbacks[callbackName][updateData.id]))
                    end
                else
                    DebugError("uix updateCallbacksNow: callback at " .. callbackName .. " with id " .. tostring(id) .. " doesn't exist")
                end
            end
        end
    end
end

function ModLua.debugText(data1, data2, indent, isForced, getinfodata)
	local isDebug = false
	if isDebug == true or isForced == true then
		if indent == nil then
			indent = ""
		end
		if data1 == "" then
			data1 = "(empty string)"
		elseif not data1 then
			data1 = "(nil)"
		end
		if data2 == "" then
			data2 = "(empty string)"
		elseif not data2 then
			data2 = "(nil)"
		end
		if not getinfodata then
			getinfodata = debug.getinfo(3)
		end
		local noteFuncName = ""
		local noteLocation = ""
		if (not noteFuncName) or tostring(getinfodata.name) == "callback" or tostring(getinfodata.name) == "nil" then
			noteFuncName = " (approx)"
			noteLocation = " (location of approx funcName)"
		end
		-- DebugError ("uix funcName" .. tostring(noteFuncName) .. ": " .. tostring(getinfodata.name) .. " data1: " .. indent .. tostring (data1) .. " (" .. tostring(type(data1)) .. ") data2: " .. tostring(data2) .. " (" .. tostring(type(data2)) .. ") at" .. tostring(noteLocation) .. ": line: " .. tostring(getinfodata.linedefined) .. " of: " .. tostring(getinfodata.short_src))
		DebugError ("uix funcName" .. tostring(noteFuncName) .. ": " .. tostring(getinfodata.name) .. ": " .. indent .. tostring (data1) .. " = " .. tostring(data2) .. " at" .. tostring(noteLocation) .. ": line: " .. tostring(getinfodata.linedefined) .. " of: " .. tostring(getinfodata.short_src))
		indent = indent .. "  "
		if type(data1) == "table" then
			for key, value in pairs(data1) do
				Helper.debugText(key, value, indent, isForced, getinfodata)
			end
		end
		if type(data2) == "table" then
			Helper.debugText(data2, nil, indent, isForced, getinfodata)
		end
	end
end

function ModLua.debugText_forced(data1, data2, indent)
	local getinfodata = debug.getinfo(2)
	-- DebugError("func: " .. tostring(debug.getinfo(getinfodata.func).name) .. ", " .. tostring(debug.getinfo(getinfodata.func).linedefined) .. ", " .. tostring(debug.getinfo(getinfodata.func).short_src))
	return Helper.debugText(data1, data2, indent, true, getinfodata)
end

Helper.isDebugCallbacks = nil
function ModLua.setDebugCallbacks(isOn)
	if isOn == true then
		Helper.isDebugCallbacks = true
	else
		Helper.isDebugCallbacks = nil
	end
end

ModLua.addNewFunctions()

-- kuertee end: new funcs
