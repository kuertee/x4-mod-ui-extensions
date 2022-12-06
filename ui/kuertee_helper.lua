local ffi = require ("ffi")
local C = ffi.C
local Lib = require ("extensions.sn_mod_support_apis.lua_interface").Library
local stationOverviewMenu = Lib.Get_Egosoft_Menu ("StationOverviewMenu")
local oldFuncs = {}
local newFuncs = {}
local callbacks = {}
local isInited
local function init ()
	-- DebugError ("kuertee_helper.init")
	if not isInited then
		isInited = true
		-- rewrites:
		oldFuncs.createLSOStorageNode = Helper.createLSOStorageNode
		Helper.createLSOStorageNode = newFuncs.createLSOStorageNode
		oldFuncs.onExpandLSOStorageNode = Helper.onExpandLSOStorageNode
		Helper.onExpandLSOStorageNode = newFuncs.onExpandLSOStorageNode
	end
end
function Helper.registerCallback (callbackName, callbackFunction)
	-- note 1: format is generally [function name]_[action]. e.g.: in kuertee_menu_transporter, "display_on_set_room_active" overrides the room's active property with the return of the callback.
	-- note 2: events have the word "_on_" followed by a PRESET TENSE verb. e.g.: in kuertee_menu_transporter, "display_on_set_buttontable" is called after all of the rows of buttontable are set.
	-- note 3: new callbacks can be added or existing callbacks can be edited. but commit your additions/changes to the mod's GIT repository.
	-- note 4: search for the callback names to see where they are executed.
	-- note 5: if a callback requires a return value, return it in an object var. e.g. "display_on_set_room_active" requires a return of {active = true | false}.
	-- available callbacks:
	-- name = createLSOStorageNode_get_ware_name(ware)
	-- onExpandLSOStorageNode_list_incoming_trade(row, name, reservation)
	--
	if callbacks [callbackName] == nil then
		callbacks [callbackName] = {}
	end
	table.insert (callbacks [callbackName], callbackFunction)
end
function newFuncs.createLSOStorageNode(menu, container, ware, planned, hasstorage, iscargo)
	local storageinfo_amounts  = C.IsInfoUnlockedForPlayer(container, "storage_amounts")
	local storageinfo_warelist = C.IsInfoUnlockedForPlayer(container, "storage_warelist")
	local storageinfo_capacity = C.IsInfoUnlockedForPlayer(container, "storage_capacity")

	local name, transporttype = GetWareData(ware, "name", "transport")

	-- kuertee start: callback
	if callbacks ["createLSOStorageNode_get_ware_name"] then
		for _, callback in ipairs (callbacks ["createLSOStorageNode_get_ware_name"]) do
			name = callback (ware)
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
			},
			isstorage = true,
			expandedTableNumColumns = 3,
			expandHandler = function (...) return Helper.onExpandLSOStorageNode(menu, container, ...) end,
			collapseHandler = function (...) return Helper.onCollapseLSOStorageNode(menu, ...) end,
			sliderHandler = function (...) return Helper.onSliderChangedLSOStorageNode(container, ...) end,
			color = (not hasstorage) and Helper.color.grey or nil,
			statuscolor = (not iscargo) and ((not hasstorage) and Helper.color.red or (hasrestrictions and Helper.color.warningorange or nil) or nil),
			statusIcon = (not iscargo) and ((not hasstorage) and "lso_warning" or (hasrestrictions and "lso_error" or nil) or nil),
		}
	}
	return warenode
end
function newFuncs.onExpandLSOStorageNode(menu, container, _, ftable, _, nodedata)
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
		local ware = ffi.string(buf[i].ware)
		local buyflag = buf[i].isbuyreservation and "selloffer" or "buyoffer" -- sic! Reservation to buy -> container is selling
		local invbuyflag = buf[i].isbuyreservation and "buyoffer" or "selloffer"
		local tradedeal = buf[i].tradedealid
		if not Helper.dirtyreservations[tostring(tradedeal)] then
			if reservations[ware] then
				table.insert(reservations[ware][buyflag], { reserver = buf[i].reserverid, amount = buf[i].amount, eta = buf[i].eta, tradedeal = tradedeal })
			else
				reservations[ware] = { [buyflag] = { { reserver = buf[i].reserverid, amount = buf[i].amount, eta = buf[i].eta, tradedeal = tradedeal } }, [invbuyflag] = {} }
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
				row = ftable:addRow(nil, { bgColor = Helper.color.transparent })
				row[1]:setColSpan(3):createText(ReadText(1001, 8437), { color = Helper.color.red })
			end
			if menu.storagemissing[nodedata.ware] then
				shown = true
				row = ftable:addRow(nil, { bgColor = Helper.color.transparent })
				row[1]:setColSpan(3):createText(ReadText(1001, 8438), { color = Helper.color.red })
			end
			if shown then
				row = ftable:addRow(nil, { bgColor = Helper.color.transparent })
				row[1]:setColSpan(3):createText("")
			end
		end
	end

	local limitslider
	if isprocessed then
		-- resource buffer
		row = ftable:addRow(nil, { bgColor = Helper.color.transparent })
		row[1]:createText(ReadText(1001, 2415) .. ReadText(1001, 120))
		row[2]:setColSpan(2):createText(ReadText(20206, 1301), { halign = "right" })
		-- amount
		row = ftable:addRow(nil, { bgColor = Helper.color.transparent })
		row[1]:createText(ReadText(1001, 6521) .. ReadText(1001, 120))
		row[2]:setColSpan(2):createText(function () return Helper.getResourceBufferAmount(container, nodedata.ware, storageinfo_amounts) end, { halign = "right" })
	else
		-- storage
		row = ftable:addRow(nil, { bgColor = Helper.color.transparent })
		row[1]:createText(ReadText(1001, 2415) .. ReadText(1001, 120))
		row[2]:setColSpan(2):createText(storagename, { halign = "right" })
		-- missing storage type
		if not nodedata.hasstorage then
			row = ftable:addRow(nil, { bgColor = Helper.color.transparent })
			row[1]:setColSpan(3):createText(ReadText(1001, 8416), { color = Helper.color.red, wordwrap = true })
		end
		if C.IsComponentClass(container, "container") then
			if not isprocessed then
				-- amount
				row = ftable:addRow(nil, { bgColor = Helper.color.transparent })
				row[1]:createText(ReadText(1001, 6521) .. ReadText(1001, 120))
				row[2]:setColSpan(2):createText(function () return Helper.getStorageAmount(container, nodedata, storageinfo_amounts, storageinfo_capacity) end, { halign = "right", mouseOverText = function () return Helper.getStorageAmount(container, nodedata, storageinfo_amounts, storageinfo_capacity, 0, true) end })
		
				ftable:addEmptyRow(Helper.standardTextHeight / 2)

				row = ftable:addRow(nil, { bgColor = Helper.color.transparent })
				row[1]:createText(ReadText(1001, 1600) .. " / " .. ReadText(1001, 102) .. ReadText(1001, 120))
				row[2]:setColSpan(2):createText(function () local production = C.GetContainerWareProduction(container, nodedata.ware, false); return Helper.unlockInfo(storageinfo_amounts, (production > 0) and ConvertIntegerString(production, true, 3, true, true) or "-") end, { halign = "right" })
				row = ftable:addRow(nil, { bgColor = Helper.color.transparent })
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

						row = ftable:addRow(nil, { bgColor = Helper.color.transparent })
						row[1]:setColSpan(3):createText(ReadText(1001, 8444) .. ReadText(1001, 120), { mouseOverText = ReadText(1026, 8403) })
						row = ftable:addRow(nil, { bgColor = Helper.color.transparent })
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
								local color = Helper.color.white
								if available == 0 then
									color = Helper.color.red
								elseif available < 0.1 * capacity then
									color = Helper.color.warningorange
								end
								return Helper.unlockInfo(storageinfo_amounts, Helper.convertColorToText(color) .. ConvertIntegerString(available, true, 3, true, true) .. " " .. ReadText(1001, 110))
							end,
							{ halign = "right" }
						)
					end
					-- automatic storage level
					local row = ftable:addRow("autostoragecheckbox", { bgColor = Helper.color.transparent })
					if menu.selectedRowData["nodeTable"] == "autostoragecheckbox" then
						menu.selectedRows["nodeTable"] = row.index
						menu.selectedRowData["nodeTable"] = nil
					end
					row[1]:setColSpan(2):createText(ReadText(1001, 8439) .. ReadText(1001, 120))
					row[3]:createCheckBox(not haslimitoverride, { height = Helper.standardButtonHeight })
					row[3].handlers.onClick = function (_, checked) return Helper.checkboxStorageLevelOverride(menu, container, nodedata.ware, row.index, currentlimit, checked) end
					if haslimitoverride then
						-- price
						local row = ftable:addRow("autostorageslider", { bgColor = Helper.color.transparent })
						if menu.selectedRowData["nodeTable"] == "autostorageslider" then
							menu.selectedRows["nodeTable"] = row.index
							menu.selectedRowData["nodeTable"] = nil
						end
						local max = GetWareCapacity(container, nodedata.ware)
						limitslider = row[1]:setColSpan(3):createSliderCell({
							height = Helper.standardTextHeight,
							valueColor = haslimitoverride and Helper.defaultSliderCellValueColor or Helper.color.grey,
							min = 0,
							minSelect = 1,
							max = max,
							start = math.max(1, math.min(max, currentlimit)),
							hideMaxValue = true,
							readOnly = not haslimitoverride,
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
			local currentprice = math.max(minprice, math.min(maxprice, RoundTotalTradePrice(GetContainerWarePrice(container, nodedata.ware, true))))
			local haspriceoverride = HasContainerWarePriceOverride(container, nodedata.ware, true)
			local istradewarebought = C.GetContainerWareIsBuyable(container, nodedata.ware)
			local currentlimit = C.GetContainerBuyLimit(container, nodedata.ware)
			local haslimitoverride = C.HasContainerBuyLimitOverride(container, nodedata.ware)
			-- title
			row = ftable:addRow(nil, { bgColor = Helper.color.transparent })
			row[1]:setColSpan(3):createText(ReadText(1001, 8309), Helper.subHeaderTextProperties)
			row[1].properties.halign = "center"
			if (waretype == "resource") or (waretype == "intermediate") or istradewarebought or haslimitoverride then
				-- automatic buy limit
				local row = ftable:addRow("autobuylimitcheckbox", { bgColor = Helper.color.transparent })
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
				if haslimitoverride then
					-- buy limit
					local row = ftable:addRow("autobuylimitslider", { bgColor = Helper.color.transparent })
					if menu.selectedRowData["nodeTable"] == "autobuylimitslider" then
						menu.selectedRows["nodeTable"] = row.index
						menu.selectedRowData["nodeTable"] = nil
					end
					local max = GetWareProductionLimit(container, nodedata.ware)
					Helper.LSOStorageNodeBuySlider = { ware = nodedata.ware, widget = row[1]:setColSpan(3):createSliderCell({
						height = Helper.standardTextHeight,
						valueColor = haslimitoverride and Helper.defaultSliderCellValueColor or Helper.color.grey,
						min = 0,
						minSelect = max == 0 and 0 or 1,
						max = max,
						start = math.min(max, currentlimit),
						hideMaxValue = true,
						readOnly = not haslimitoverride,
					})}
				end
				-- automatic pricing
				local row = ftable:addRow("autobuypricecheckbox", { bgColor = Helper.color.transparent })
				if menu.selectedRowData["nodeTable"] == "autobuypricecheckbox" then
					menu.selectedRows["nodeTable"] = row.index
					menu.selectedRowData["nodeTable"] = nil
				end
				if haspriceoverride then
					row[1]:setColSpan(2):createText(ReadText(1001, 8402) .. ReadText(1001, 120), { wordwrap = true })
				else
					row[1]:createText(ReadText(1001, 8402) .. ReadText(1001, 120), { wordwrap = true })
					row[2]:createText(function () return math.max(minprice, math.min(maxprice, RoundTotalTradePrice(GetContainerWarePrice(container, nodedata.ware, true)))) .. " " .. ReadText(1001, 101) end, { halign = "right" })
				end
				row[3]:createCheckBox(not haspriceoverride, { height = Helper.standardButtonHeight })
				row[3].handlers.onClick = function (_, checked) return Helper.checkboxStorageWarePriceOverride(menu, container, nodedata.ware, row.index, true, currentprice, checked) end
				if haspriceoverride then
					-- price
					local row = ftable:addRow("autobuypriceslider", { bgColor = Helper.color.transparent })
					if menu.selectedRowData["nodeTable"] == "autobuypriceslider" then
						menu.selectedRows["nodeTable"] = row.index
						menu.selectedRowData["nodeTable"] = nil
					end
					row[1]:setColSpan(3):createSliderCell({
						height = Helper.standardTextHeight,
						valueColor = haspriceoverride and Helper.defaultSliderCellValueColor or Helper.color.grey,
						min = minprice,
						max = maxprice,
						start = currentprice,
						hideMaxValue = true,
						suffix = ReadText(1001, 101),
						readOnly = not haspriceoverride,
					})
					row[1].handlers.onSliderCellChanged = function(_, value) return Helper.slidercellStorageWarePriceOverride(container, nodedata.ware, true, value) end
					row[1].handlers.onSliderCellActivated = function (id) menu.noupdate = true end
					row[1].handlers.onSliderCellDeactivated = function (id) menu.noupdate = false end
				end
				-- trade rule
				local hasownlist = C.HasContainerOwnTradeRule(container, "buy", nodedata.ware)
				local traderuleid = C.GetContainerTradeRuleID(container, "buy", nodedata.ware)
				local row = ftable:addRow(nil, { bgColor = Helper.color.transparent })
				row[1]:setColSpan(3):createText(ReadText(1001, 11013) .. ReadText(1001, 120), textproperties)
				-- global
				local row = ftable:addRow("buytraderule_global", { bgColor = Helper.color.transparent })
				row[1]:setColSpan(2):createText(ReadText(1001, 11025) .. ReadText(1001, 120), textproperties)
				row[3]:createCheckBox(not hasownlist, { height = Helper.standardButtonHeight })
				row[3].handlers.onClick = function(_, checked) return Helper.checkboxSetTradeRuleOverride(menu, container, "buy", nodedata.ware, checked) end
				-- current
				local row = ftable:addRow("buytraderule_current", { bgColor = Helper.color.transparent })
				row[1]:setColSpan(2):createDropDown(Helper.traderuleOptions, { startOption = (traderuleid ~= 0) and traderuleid or -1, active = hasownlist }):setTextProperties({ fontsize = config.mapFontSize })
				row[1].handlers.onDropDownConfirmed = function (_, id) return Helper.dropdownTradeRule(menu, container, "buy", nodedata.ware, id) end
				row[3]:createButton({ mouseOverText = ReadText(1026, 8407) }):setIcon("menu_edit")
				row[3].handlers.onClick = function () return Helper.buttonEditTradeRule(menu) end
			end
			-- create / remove offer
			if (waretype == "trade") or (waretype == "product") then
				row = ftable:addRow("tradebuy", { bgColor = Helper.color.transparent })
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
				row = ftable:addRow(nil, { bgColor = Helper.color.transparent })
				row[1]:setColSpan(3):createText(string.format(ReadText(1001, 7994), GetWareData(nodedata.ware, "name")) .. ReadText(1001, 120), { wordwrap = true })
				for i, reservation in ipairs(reservations[nodedata.ware].buyoffer) do
					row = ftable:addRow("buyreservation" .. i, { bgColor = Helper.color.transparent })
					if menu.selectedRowData["nodeTable"] == "buyreservation" then
						menu.selectedRows["nodeTable"] = row.index
						menu.selectedRowData["nodeTable"] = nil
					end
					local isplayerowned = GetComponentData(ConvertStringTo64Bit(tostring(reservation.reserver)), "isplayerowned")
					local name = (isplayerowned and Helper.convertColorToText(Helper.color.green) or "") .. ffi.string(C.GetComponentName(reservation.reserver)) .. " (" .. ffi.string(C.GetObjectIDCode(reservation.reserver)) .. ")\27X"

					-- kuertee start: callback
					-- row[1]:createText(function () return Helper.getETAString(name, reservation.eta) end, { font = Helper.standardFontMono, mouseOverText = name })
					if callbacks ["onExpandLSOStorageNode_list_incoming_trade"] then
						for _, callback in ipairs (callbacks ["onExpandLSOStorageNode_list_incoming_trade"]) do
							callback (row, name, reservation, isplayerowned)
						end
					end
					-- kuertee end: callback

					row[2]:createText(ConvertIntegerString(reservation.amount, true, 3, false), { halign = "right" })
					row[3]:createButton({ active = function () return C.CancelPlayerInvolvedTradeDeal(container, reservation.tradedeal, true) end, mouseOverText = ReadText(1026, 7924) }):setText("X", { halign = "center" })
					row[3].handlers.onClick = function () return Helper.buttonCancelTrade(menu, container, reservation.tradedeal) end
				end
			end
		end

		-- sell offer
		if (not isprocessed) and ((waretype == "resource") or (waretype == "product") or (waretype == "intermediate") or (waretype == "trade")) then
			local currentprice = math.max(minprice, math.min(maxprice, RoundTotalTradePrice(GetContainerWarePrice(container, nodedata.ware, false))))
			local haspriceoverride = HasContainerWarePriceOverride(container, nodedata.ware, false)
			local istradewaresold = C.GetContainerWareIsSellable(container, nodedata.ware)
			local currentlimit = C.GetContainerSellLimit(container, nodedata.ware)
			local haslimitoverride = C.HasContainerSellLimitOverride(container, nodedata.ware)
			-- title
			row = ftable:addRow(nil, { bgColor = Helper.color.transparent })
			row[1]:setColSpan(3):createText(ReadText(1001, 8308), Helper.subHeaderTextProperties)
			row[1].properties.halign = "center"
			if (waretype == "product") or (waretype == "intermediate") or istradewaresold or haslimitoverride then
				-- automatic sell limit
				local row = ftable:addRow("autoselllimitcheckbox", { bgColor = Helper.color.transparent })
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
				if haslimitoverride then
					-- sell limit
					local row = ftable:addRow("autoselllimitslider", { bgColor = Helper.color.transparent })
					if menu.selectedRowData["nodeTable"] == "autoselllimitslider" then
						menu.selectedRows["nodeTable"] = row.index
						menu.selectedRowData["nodeTable"] = nil
					end
					local max = GetWareProductionLimit(container, nodedata.ware)
					Helper.LSOStorageNodeSellSlider = { ware = nodedata.ware, widget = row[1]:setColSpan(3):createSliderCell({
						height = Helper.standardTextHeight,
						valueColor = haslimitoverride and Helper.defaultSliderCellValueColor or Helper.color.grey,
						min = 0,
						minSelect = max == 0 and 0 or 1,
						max = max,
						start = math.min(max, currentlimit),
						hideMaxValue = true,
						readOnly = not haslimitoverride,
					})}
				end
				-- automatic pricing
				local row = ftable:addRow("autosellpricecheckbox", { bgColor = Helper.color.transparent })
				if menu.selectedRowData["nodeTable"] == "autosellpricecheckbox" then
					menu.selectedRows["nodeTable"] = row.index
					menu.selectedRowData["nodeTable"] = nil
				end
				if haspriceoverride then
					row[1]:createText(ReadText(1001, 8402) .. ReadText(1001, 120), { wordwrap = true })
				else
					row[1]:createText(ReadText(1001, 8402) .. ReadText(1001, 120), { wordwrap = true })
					row[2]:createText(function () return math.max(minprice, math.min(maxprice, RoundTotalTradePrice(GetContainerWarePrice(container, nodedata.ware, false)))) .. " " .. ReadText(1001, 101) end, { halign = "right" })
				end
				row[3]:createCheckBox(not haspriceoverride, { height = Helper.standardButtonHeight })
				row[3].handlers.onClick = function (_, checked) return Helper.checkboxStorageWarePriceOverride(menu, container, nodedata.ware, row.index, false, currentprice, checked) end
				if haspriceoverride then
					-- price
					local row = ftable:addRow("autosellpriceslider", { bgColor = Helper.color.transparent })
					if menu.selectedRowData["nodeTable"] == "autosellpriceslider" then
						menu.selectedRows["nodeTable"] = row.index
						menu.selectedRowData["nodeTable"] = nil
					end
					row[1]:setColSpan(3):createSliderCell({
						height = Helper.standardTextHeight,
						valueColor = haspriceoverride and Helper.defaultSliderCellValueColor or Helper.color.grey,
						min = minprice,
						max = maxprice,
						start = currentprice,
						hideMaxValue = true,
						suffix = ReadText(1001, 101),
						readOnly = not haspriceoverride,
					})
					row[1].handlers.onSliderCellChanged = function(_, value) return Helper.slidercellStorageWarePriceOverride(container, nodedata.ware, false, value) end
					row[1].handlers.onSliderCellActivated = function (id) menu.noupdate = true end
					row[1].handlers.onSliderCellDeactivated = function (id) menu.noupdate = false end
				end
				-- trade rule
				local hasownlist = C.HasContainerOwnTradeRule(container, "sell", nodedata.ware)
				local traderuleid = C.GetContainerTradeRuleID(container, "sell", nodedata.ware)
				local row = ftable:addRow(nil, { bgColor = Helper.color.transparent })
				row[1]:setColSpan(3):createText(ReadText(1001, 11013) .. ReadText(1001, 120), textproperties)
				-- global
				local row = ftable:addRow("selltraderule_global", { bgColor = Helper.color.transparent })
				row[1]:setColSpan(2):createText(ReadText(1001, 11025) .. ReadText(1001, 120), textproperties)
				row[3]:createCheckBox(not hasownlist, { height = Helper.standardButtonHeight })
				row[3].handlers.onClick = function(_, checked) return Helper.checkboxSetTradeRuleOverride(menu, container, "sell", nodedata.ware, checked) end
				-- current
				local row = ftable:addRow("selltraderule_current", { bgColor = Helper.color.transparent })
				row[1]:setColSpan(2):createDropDown(Helper.traderuleOptions, { startOption = (traderuleid ~= 0) and traderuleid or -1, active = hasownlist }):setTextProperties({ fontsize = config.mapFontSize })
				row[1].handlers.onDropDownConfirmed = function (_, id) return Helper.dropdownTradeRule(menu, container, "sell", nodedata.ware, id) end
				row[3]:createButton({ mouseOverText = ReadText(1026, 8407) }):setIcon("menu_edit")
				row[3].handlers.onClick = function () return Helper.buttonEditTradeRule(menu) end
			end
			-- create / remove offer
			if (waretype == "trade") or (waretype == "resource") then
				row = ftable:addRow("tradesell", { bgColor = Helper.color.transparent })
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
				row = ftable:addRow(nil, { bgColor = Helper.color.transparent })
				row[1]:setColSpan(3):createText(string.format(ReadText(1001, 7993), GetWareData(nodedata.ware, "name")) .. ReadText(1001, 120), { wordwrap = true })
				for i, reservation in ipairs(reservations[nodedata.ware].selloffer) do
					row = ftable:addRow("sellreservation" .. i, { bgColor = Helper.color.transparent })
					if menu.selectedRowData["nodeTable"] == "sellreservation" then
						menu.selectedRows["nodeTable"] = row.index
						menu.selectedRowData["nodeTable"] = nil
					end
					local isplayerowned = GetComponentData(ConvertStringTo64Bit(tostring(reservation.reserver)), "isplayerowned")
					local name = (isplayerowned and Helper.convertColorToText(Helper.color.green) or "") .. ffi.string(C.GetComponentName(reservation.reserver)) .. " (" .. ffi.string(C.GetObjectIDCode(reservation.reserver)) .. ")\27X"

					-- kuertee start: callback
					-- row[1]:createText(function () return Helper.getETAString(name, reservation.eta) end, { font = Helper.standardFontMono, mouseOverText = name })
					if callbacks ["onExpandLSOStorageNode_list_incoming_trade"] then
						for _, callback in ipairs (callbacks ["onExpandLSOStorageNode_list_incoming_trade"]) do
							callback (row, name, reservation, isplayerowned)
						end
					end
					-- kuertee end: callback

					row[2]:createText(ConvertIntegerString(reservation.amount, true, 3, false), { halign = "right" })
					row[3]:createButton({ active = function () return C.CancelPlayerInvolvedTradeDeal(container, reservation.tradedeal, true) end, mouseOverText = ReadText(1026, 7924) }):setText("X", { halign = "center" })
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
			Helper.LSOStorageNodeBuySlider.widget.handlers.onSliderCellChanged = function(_, value) return Helper.slidercellBuyLimitOverride(menu, container, nodedata.ware, value) end
			Helper.LSOStorageNodeBuySlider.widget.handlers.onSliderCellActivated = function (id) menu.noupdate = true end
			Helper.LSOStorageNodeBuySlider.widget.handlers.onSliderCellDeactivated = function (id) menu.noupdate = false end
		end
		if Helper.LSOStorageNodeSellSlider then 
			Helper.LSOStorageNodeSellSlider.widget.handlers.onSliderCellChanged = function(_, value) return Helper.slidercellSellLimitOverride(menu, container, nodedata.ware, value) end
			Helper.LSOStorageNodeSellSlider.widget.handlers.onSliderCellActivated = function (id) menu.noupdate = true end
			Helper.LSOStorageNodeSellSlider.widget.handlers.onSliderCellDeactivated = function (id) menu.noupdate = false end
		end
	end

	if menu.selectedRowData["nodeTable"] then
		menu.selectedCols["nodeTable"] = nil
	end
	menu.restoreTableState("nodeTable", ftable)
end
init()
