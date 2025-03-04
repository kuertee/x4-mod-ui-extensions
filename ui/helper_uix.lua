if Helper.uix_callbacks then
    -- OptionsMenu already UIX initialised by stand-alone UIX mod, do not continue with this file.
    Helper.debugText_forced("helper_uix.lua already loaded by stand-alone UIX mod.")
    return
end

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
	Helper.validSaveFilenames[string.format("save_%03d", i)] = true
end
-- kuertee end: more save games

-- kuertee start: rewrites

local OldFuncs = {}
Helper.uix_callbacks = {}

function ModLua.rewriteFunctions()
	OldFuncs.onUpdate = Helper.onUpdate
	Helper.onUpdate = ModLua.onUpdate
	OldFuncs.getPassedTime = Helper.getPassedTime
	Helper.getPassedTime = ModLua.getPassedTime
	OldFuncs.checkTopLevelConditions = Helper.checkTopLevelConditions
	Helper.checkTopLevelConditions = ModLua.checkTopLevelConditions
	OldFuncs.createTransactionLog = Helper.createTransactionLog
	Helper.createTransactionLog = ModLua.createTransactionLog
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
	if Helper.uix_callbacks ["onUpdate"] then
		for uix_id, uix_callback in pairs (Helper.uix_callbacks ["onUpdate"]) do
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
	if Helper.uix_callbacks ["checkTopLevelConditions_get_is_entry_available"] then
		local isAvailable = true
		for uix_id, uix_callback in pairs (Helper.uix_callbacks ["checkTopLevelConditions_get_is_entry_available"]) do
			isAvailable = uix_callback (entry)
			if isAvailable ~= true then
				return false
			end
		end
	end
	-- kuertee end: callback

	return true
end

function ModLua.createTransactionLog(frame, container, tableProperties, refreshCallback, selectionData)
	Helper.transactionLogData = {
		accountLog = {},
		accountLogUnfiltered = {},
		transactionsByID = {},
		transactionsByIDUnfiltered = {},
		graphdata = {},

		xZoom = Helper.transactionLogData and Helper.transactionLogData.xZoom or 6,
		xScale = Helper.transactionLogData and Helper.transactionLogData.xScale or 60,
		xGranularity = Helper.transactionLogData and Helper.transactionLogData.xGranularity or 300,
		xTitle = Helper.transactionLogData and Helper.transactionLogData.xTitle or (ReadText(1001, 6519) .. " [" .. ReadText(1001, 103) .. "]"),
		expandedEntries = Helper.transactionLogData and Helper.transactionLogData.expandedEntries or {},
		searchtext = Helper.transactionLogData and Helper.transactionLogData.searchtext or "",
		curPage = Helper.transactionLogData and Helper.transactionLogData.curPage or 1,
		curEntry = Helper.transactionLogData and Helper.transactionLogData.curEntry or nil,

		numPages = 1,
		pageEditBox = nil,
		graph = nil,
		noupdate = nil,
	}

	local endtime = C.GetCurrentGameTime()
	local starttime = math.max(0, endtime - 60 * Helper.transactionLogConfig.zoomSteps[Helper.transactionLogData.xZoom].zoom)

	-- transaction entries with data
	local n = C.GetNumTransactionLog(container, starttime, endtime)
	local buf = ffi.new("TransactionLogEntry[?]", n)
	n = C.GetTransactionLog(buf, n, container, starttime, endtime)
	for i = 0, n - 1 do
		local partnername = ffi.string(buf[i].partnername)

		table.insert(Helper.transactionLogData.accountLogUnfiltered, {
			time = buf[i].time,
			money = tonumber(buf[i].money) / 100,
			entryid = ConvertStringTo64Bit(tostring(buf[i].entryid)),
			eventtype = ffi.string(buf[i].eventtype),
			eventtypename = ffi.string(buf[i].eventtypename),
			partner = buf[i].partnerid,
			partnername = (partnername ~= "") and (partnername .. " (" .. ffi.string(buf[i].partneridcode) .. ")") or "",
			tradeentryid = ConvertStringTo64Bit(tostring(buf[i].tradeentryid)),
			tradeeventtype = ffi.string(buf[i].tradeeventtype),
			tradeeventtypename = ffi.string(buf[i].tradeeventtypename),
			buyer = buf[i].buyerid,
			seller = buf[i].sellerid,
			ware = ffi.string(buf[i].ware),
			amount = buf[i].amount,
			price = tonumber(buf[i].price) / 100,
			complete = buf[i].complete,
			description = "",
		})

		local entry = Helper.transactionLogData.accountLogUnfiltered[#Helper.transactionLogData.accountLogUnfiltered]
		if (entry.buyer ~= 0) and (entry.seller ~= 0) then
			if entry.seller == container then
				entry.description = string.format(ReadText(1001, 7780), ffi.string(C.GetComponentName(entry.seller)) .. " (" .. ffi.string(C.GetObjectIDCode(entry.seller)) .. ")", entry.amount, GetWareData(entry.ware, "name"), ffi.string(C.GetComponentName(entry.buyer)) .. " (" .. ffi.string(C.GetObjectIDCode(entry.buyer)) .. ")", ConvertMoneyString(Helper.round(entry.price, 2), true, true, 0, true) .. " " .. ReadText(1001, 101))
			else
				entry.description = string.format(ReadText(1001, 7770), ffi.string(C.GetComponentName(entry.buyer)) .. " (" .. ffi.string(C.GetObjectIDCode(entry.buyer)) .. ")", entry.amount, GetWareData(entry.ware, "name"), ffi.string(C.GetComponentName(entry.seller)) .. " (" .. ffi.string(C.GetObjectIDCode(entry.seller)) .. ")", ConvertMoneyString(Helper.round(entry.price, 2), true, true, 0, true) .. " " .. ReadText(1001, 101))
			end
		elseif entry.buyer ~= 0 then
			entry.description = string.format(ReadText(1001, 7772), ffi.string(C.GetComponentName(entry.buyer)) .. " (" .. ffi.string(C.GetObjectIDCode(entry.buyer)) .. ")", entry.amount, GetWareData(entry.ware, "name"), ConvertMoneyString(Helper.round(entry.price, 2), true, true, 0, true) .. " " .. ReadText(1001, 101))
		elseif entry.seller ~= 0 then
			entry.description = string.format(ReadText(1001, 7771), ffi.string(C.GetComponentName(entry.seller)) .. " (" .. ffi.string(C.GetObjectIDCode(entry.seller)) .. ")", entry.amount, GetWareData(entry.ware, "name"), ConvertMoneyString(Helper.round(entry.price, 2), true, true, 0, true) .. " " .. ReadText(1001, 101))
		elseif entry.ware ~= "" then
			entry.description = entry.amount .. ReadText(1001, 42) .. " " .. GetWareData(entry.ware, "name") .. " - " .. ConvertMoneyString(entry.price, false, true, 0, true) .. " " .. ReadText(1001, 101)
		end
		if entry.partner ~= 0 then
			entry.partnername = ffi.string(C.GetComponentName(entry.partner)) .. " (" .. ffi.string(C.GetObjectIDCode(entry.partner)) .. ")"
			entry.destroyedpartner = not C.IsComponentOperational(entry.partner)
		else
			entry.destroyedpartner = entry.partnername ~= ""
		end
		if entry.eventtype == "trade" then
			if entry.seller and (entry.seller == container) then
				entry.eventtypename = ReadText(1001, 7781)
			elseif entry.buyer and (entry.buyer == container) then
				entry.eventtypename = ReadText(1001, 7782)
			end
		elseif entry.eventtype == "sellship" then
			if entry.partnername ~= "" then
				entry.eventtypename = ReadText(1001, 7783)
			else
				entry.eventtypename = entry.eventtypename .. ReadText(1001, 120) .. " " .. entry.partnername
				entry.partnername = ""
			end
		end

		table.insert(Helper.transactionLogData.accountLog, entry)
	end
	-- pure money stats for graph
	local buf = ffi.new("MoneyLogEntry[?]", Helper.transactionLogConfig.numdatapoints)
	local numdata = C.GetMoneyLog(buf, Helper.transactionLogConfig.numdatapoints, container, starttime, endtime)
	for i = 0, numdata - 1 do
		local money = tonumber(buf[i].money) / 100
		local prevmoney = (i > 0) and (tonumber(buf[i - 1].money) / 100) or nil
		local nextmoney = (i < numdata - 1) and (tonumber(buf[i + 1].money) / 100) or nil
		if (money ~= prevmoney) or (money ~= nextmoney) then
			table.insert(Helper.transactionLogData.graphdata, {
				t = buf[i].time,
				y = money,
				entryid = ConvertStringTo64Bit(tostring(buf[i].entryid)),
			})
			local entry = Helper.transactionLogData.graphdata[#Helper.transactionLogData.graphdata]
		end
	end
	-- apply search
	if Helper.transactionLogData.searchtext ~= "" then
		Helper.transactionLogData.accountLog = {}
		for _, entry in ipairs(Helper.transactionLogData.accountLogUnfiltered) do
			if Helper.transactionLogSearchHelper(entry, Helper.transactionLogData.searchtext) then
				table.insert(Helper.transactionLogData.accountLog, entry)
			end
		end
	end
	-- create transaction index
	for i, entry in ipairs(Helper.transactionLogData.accountLogUnfiltered) do
		Helper.transactionLogData.transactionsByIDUnfiltered[entry.entryid] = i
	end
	for i, entry in ipairs(Helper.transactionLogData.accountLog) do
		Helper.transactionLogData.transactionsByID[entry.entryid] = i
	end
	-- make sure the page of the selected entry is shown
	if Helper.transactionLogData.curEntry then
		local transactionIndex = Helper.transactionLogData.transactionsByID[Helper.transactionLogData.curEntry]
		if transactionIndex then
			Helper.transactionLogData.curPage = math.ceil((#Helper.transactionLogData.accountLog - transactionIndex + 1) / Helper.transactionLogConfig.transactionLogPage)
		end
	end

	Helper.transactionLogData.numPages = math.max(1, math.ceil(#Helper.transactionLogData.accountLog / Helper.transactionLogConfig.transactionLogPage))
	Helper.transactionLogData.curPage = math.max(1, math.min(Helper.transactionLogData.numPages, Helper.transactionLogData.curPage))

	local startIndex = #Helper.transactionLogData.accountLog
	local endIndex = 1
	if #Helper.transactionLogData.accountLog <= Helper.transactionLogConfig.transactionLogPage then
		Helper.transactionLogData.curPage = 1
	else
		endIndex = #Helper.transactionLogData.accountLog - Helper.transactionLogConfig.transactionLogPage * Helper.transactionLogData.curPage + 1
		startIndex = Helper.transactionLogConfig.transactionLogPage + endIndex - 1
		if endIndex < 1 then
			endIndex = 1
		end
	end

	local editboxHeight = math.max(23, Helper.scaleY(Helper.standardTextHeight))
	local buttonsize = Helper.scaleY(Helper.standardTextHeight)

	local table_data = frame:addTable(9, { tabOrder = 1, borderEnabled = true, width = tableProperties.width, x = tableProperties.x, y = tableProperties.y, maxVisibleHeight = tableProperties.height })
	table_data:setColWidth(1, Helper.standardTextHeight)
	table_data:setColWidth(3, Helper.standardTextHeight)
	table_data:setColWidth(4, Helper.standardTextHeight)
	table_data:setColWidth(5, Helper.standardTextHeight)
	table_data:setColWidth(6, tableProperties.width / 6 - 2 * (buttonsize + Helper.borderSize), false)
	table_data:setColWidth(7, tableProperties.width / 6 - 2 * (buttonsize + Helper.borderSize), false)
	table_data:setColWidth(8, Helper.standardTextHeight)
	table_data:setColWidth(9, Helper.standardTextHeight)

	local row = table_data:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
	row[1]:setColSpan(9):createText(ReadText(1001, 7702), Helper.titleTextProperties)

	local row = table_data:addRow("search", { fixed = true, bgColor = Color["row_background_blue"] })
	-- searchbar
	row[1]:setColSpan(2):createEditBox({ description = ReadText(1001, 7740), defaultText = ReadText(1001, 3250), height = Helper.subHeaderHeight }):setText(Helper.transactionLogData.searchtext, { halign = "left", x = Helper.standardTextOffsetx }):setHotkey("INPUT_STATE_DETAILMONITOR_0", { displayIcon = true })
	row[1].handlers.onEditBoxDeactivated = function (_, text) if text ~= Helper.transactionLogData.searchtext then Helper.transactionLogData.searchtext = text; Helper.transactionLogData.noupdate = nil; refreshCallback() end end
	-- clear search
	local buttonheight = math.max(Helper.editboxMinHeight, Helper.scaleY(Helper.subHeaderHeight))
	row[3]:createButton({ scaling = false, width = buttonsize, height = buttonheight, cellBGColor = Color["row_background"] }):setText("X", { halign = "center", font = Helper.standardFontBold })
	row[3].handlers.onClick = function () Helper.transactionLogData.searchtext = ""; refreshCallback() end
	-- pages
	row[4]:createButton({ scaling = false, active = Helper.transactionLogData.curPage > 1, width = buttonsize, height = buttonheight, cellBGColor = Color["row_background"] }):setIcon("widget_arrow_skip_left_01", { width = buttonsize, height = buttonsize, y = (row:getHeight() - buttonsize) / 2 })
	row[4].handlers.onClick = function () Helper.transactionLogData.curEntry = nil; Helper.transactionLogData.curPage = 1; refreshCallback() end
	row[5]:createButton({ scaling = false, active = Helper.transactionLogData.curPage > 1, width = buttonsize, height = buttonheight, cellBGColor = Color["row_background"] }):setIcon("widget_arrow_left_01", { width = buttonsize, height = buttonsize, y = (row:getHeight() - buttonsize) / 2 })
	row[5].handlers.onClick = function () Helper.transactionLogData.curEntry = nil; Helper.transactionLogData.curPage = Helper.transactionLogData.curPage - 1; refreshCallback() end
	Helper.transactionLogData.pageEditBox = row[6]:setColSpan(2):createEditBox({ description = ReadText(1001, 7739) }):setText(Helper.transactionLogData.curPage .. " / " .. Helper.transactionLogData.numPages, { halign = "center" })
	row[6].handlers.onEditBoxDeactivated = function (_, text, textchanged) Helper.transactionLogData.noupdate = nil; return Helper.editboxTransactionLogPage(text, textchanged, refreshCallback) end
	row[8]:createButton({ scaling = false, active = Helper.transactionLogData.curPage < Helper.transactionLogData.numPages, width = buttonsize, height = buttonheight, cellBGColor = Color["row_background"] }):setIcon("widget_arrow_right_01", { width = buttonsize, height = buttonsize, y = (row:getHeight() - buttonsize) / 2 })
	row[8].handlers.onClick = function () Helper.transactionLogData.curEntry = nil; Helper.transactionLogData.curPage = Helper.transactionLogData.curPage + 1; refreshCallback() end
	row[9]:createButton({ scaling = false, active = Helper.transactionLogData.curPage < Helper.transactionLogData.numPages, width = buttonsize, height = buttonheight, cellBGColor = Color["row_background"] }):setIcon("widget_arrow_skip_right_01", { width = buttonsize, height = buttonsize, y = (row:getHeight() - buttonsize) / 2 })
	row[9].handlers.onClick = function () Helper.transactionLogData.curEntry = nil; Helper.transactionLogData.curPage = Helper.transactionLogData.numPages; refreshCallback() end

	local headerHeight = table_data:getFullHeight()

	if #Helper.transactionLogData.accountLog > 0 then
		local total = 0
		for i = startIndex, endIndex, -1 do
			local entry = Helper.transactionLogData.accountLog[i]
			local row = table_data:addRow(entry.entryid, {  })
			if Helper.transactionLogData.curEntry == entry.entryid then
				local numLines = (table_data.properties.maxVisibleHeight - headerHeight) / (Helper.scaleY(Helper.standardTextHeight) + Helper.borderSize)
				if selectionData.toprow and ((selectionData.toprow > row.index - numLines) and (selectionData.toprow < row.index + numLines + 1)) then
					table_data:setTopRow(selectionData.toprow)
				else
					table_data:setTopRow(row.index)
				end
				table_data:setSelectedRow(row.index)
				selectionData = {}
			end
			if entry.ware ~= "" then
				row[1]:createButton({ height = Helper.standardTextHeight }):setText(function() return Helper.transactionLogData.expandedEntries[entry.entryid] and "-" or "+" end, { halign = "center" })
				row[1].handlers.onClick = function() return Helper.buttonExpandTransactionEntry(entry.entryid, row.index, refreshCallback) end
			end
			row[2]:createText(((entry.partnername ~= "") and (entry.partnername .. " - ") or "") .. entry.eventtypename, { color = entry.destroyedpartner and Color["text_inactive"] or nil, mouseOverText = entry.destroyedpartner and ReadText(1026, 5701) or "" })
			row[3]:setColSpan(4):createText(Helper.getPassedTime(entry.time), { halign = "right" })
			row[7]:setColSpan(3):createText(((entry.money > 0) and "+" or "") .. ConvertMoneyString(entry.money, false, true, 0, true) .. " " .. ReadText(1001, 101), { halign = "right", color = (entry.money > 0) and Color["text_positive"] or Color["text_negative"] })
			total = total + entry.money
			if Helper.transactionLogData.expandedEntries[entry.entryid] then
				local row = table_data:addRow(nil, { bgColor = Color["row_background_unselectable"] })
				row[1].properties.cellBGColor = Color["row_background"]
				row[2]:setColSpan(8):createText(entry.description, { x = Helper.standardTextHeight, wordwrap = true, color = entry.destroyedpartner and Color["text_inactive"] or nil })
			end
		end

		if Helper.transactionLogData.xZoom < #Helper.transactionLogConfig.zoomSteps then
			local row = table_data:addRow("showmore", {  })
			row[1]:setColSpan(9):createButton({ bgColor = Color["button_background_hidden"] }):setText(ReadText(1001, 7778), { halign = "center" })
			if endIndex == 1 then
				row[1].handlers.onClick = function () return Helper.buttonTransactionLogZoom(1, refreshCallback) end
			else
				row[1].handlers.onClick = function () Helper.transactionLogData.curEntry = nil; Helper.transactionLogData.curPage = Helper.transactionLogData.curPage + 1; refreshCallback(_, 1) end
			end
		end

		local table_total = frame:addTable(2, { tabOrder = 0, width = tableProperties.width, x = tableProperties.x, y = tableProperties.y })
		table_total:setColWidthPercent(1, 75)

		table_total:addEmptyRow()

		local row = table_total:addRow(nil, { bgColor = Color["row_separator"] })
		row[1]:setColSpan(2):createText("", { fontsize = 1, minRowHeight = 2 })

		local row = table_total:addRow(nil, {  })
		row[1]:createText(ReadText(1001, 7776) .. ReadText(1001, 120))
		row[2]:createText(((total > 0) and "+" or "") .. ConvertMoneyString(total, false, true, 0, true) .. " " .. ReadText(1001, 101), { halign = "right", color = (total > 0) and Color["text_positive"] or Color["text_negative"] })

		local maxVisibleHeight = table_data.properties.maxVisibleHeight - table_total:getFullHeight() - Helper.frameBorder
		table_total.properties.y = table_total.properties.y + math.min(maxVisibleHeight, table_data:getFullHeight())
		table_data.properties.maxVisibleHeight = table_total.properties.y - table_data.properties.y

		table_data:addConnection(1, 2, true)
		table_total:addConnection(2, 2)
	else
		local row = table_data:addRow("none", {  })
		row[1]:setColSpan(9):createText("--- " .. ReadText(1001, 5705) .. " ---", { halign = "center" })

		if Helper.transactionLogData.xZoom < #Helper.transactionLogConfig.zoomSteps then
			local row = table_data:addRow("showmore", {  })
			row[1]:setColSpan(9):createButton({ bgColor = Color["button_background_hidden"] }):setText(ReadText(1001, 7778), { halign = "center" })
			row[1].handlers.onClick = function () return Helper.buttonTransactionLogZoom(1, refreshCallback) end
		end

		table_data:addConnection(1, 2, true)
	end

	if selectionData.selectedrow then
		table_data:setTopRow(selectionData.toprow)
		table_data:setSelectedRow(selectionData.selectedrow)
	end

	-- graph table
	local xoffset = tableProperties.x + tableProperties.width + Helper.borderSize + Helper.frameBorder
	local width = Helper.viewWidth - xoffset - tableProperties.x2
	local height = math.min(Helper.viewHeight - tableProperties.y - Helper.frameBorder - Helper.scaleY(Helper.standardTextHeight) - Helper.borderSize, math.floor(width * 9 / 16))

	-- kuertee start: callback
	if Helper.uix_callbacks ["createTransactionLog_set_graph_height"] then
		for uix_id, uix_callback in pairs (Helper.uix_callbacks ["createTransactionLog_set_graph_height"]) do
			height = math.min(height, uix_callback (tableProperties, width))
		end
	end
	-- kuertee end: callback

	local table_graph = frame:addTable(4, { tabOrder = 3, width = width, x = xoffset, y = tableProperties.y })
	table_graph:setColWidthPercent(2, 15)
	table_graph:setColWidthPercent(3, 15)

	-- graph cell
	local row = table_graph:addRow(false, { fixed = true })

	-- graph
	local title = ffi.string(C.GetComponentName(container))
	if container ~= C.GetPlayerID() then
		title = title .. " (" .. ffi.string(C.GetObjectIDCode(container)) .. ")"
	end
	Helper.transactionLogData.graph = row[1]:setColSpan(4):createGraph({ height = height, scaling = false }):setTitle(title, { font = Helper.titleFont, fontsize = Helper.scaleFont(Helper.titleFont, Helper.titleFontSize) })
	row[1].handlers.onClick = function (_, data) return Helper.graphDataSelection(data, refreshCallback) end

	local minY, maxY = 0, 1

	local datarecord = Helper.transactionLogData.graph:addDataRecord({
		markertype = Helper.transactionLogConfig.point.type,
		markersize = Helper.transactionLogConfig.point.size,
		markercolor = Color["transactionlog_graph_data"],
		linetype = Helper.transactionLogConfig.line.type,
		linewidth = Helper.transactionLogConfig.line.size,
		linecolor = Color["transactionlog_graph_data"],
	})

	local firstNonZeroY = true
	for i, point in pairs(Helper.transactionLogData.graphdata) do
		if (point.y > 0) or (minY > 0) then
			if firstNonZeroY then
				firstNonZeroY = false
				minY = point.y
			else
				minY = math.min(minY, point.y)
			end
		end
		maxY = math.max(maxY, point.y)
		local inactive
		if Helper.transactionLogData.searchtext ~= "" then
			inactive = true

			local transactionIndex = Helper.transactionLogData.transactionsByIDUnfiltered[point.entryid]
			local prevTransactionIndex = 1
			if i > 1 then
				prevTransactionIndex = Helper.transactionLogData.transactionsByIDUnfiltered[Helper.transactionLogData.graphdata[i -1].entryid]
			end

			if transactionIndex and prevTransactionIndex then
				if prevTransactionIndex < transactionIndex then
					-- if the previous transactionlog index is smaller than the current, skip this index, as it is part of the previous data point not the current
					--  prevTimeInterval  |  curTimeInterval
					-- [ ..., prevEntry ] | [ ..., curEntry ]
					prevTransactionIndex = prevTransactionIndex + 1
				end
				for i = prevTransactionIndex, transactionIndex do
					local entry = Helper.transactionLogData.accountLogUnfiltered[i]
					if Helper.transactionLogData.transactionsByID[entry.entryid] then
						inactive = false
						break
					end
				end
			end
		end
		datarecord:addData((point.t - endtime) / Helper.transactionLogData.xScale, point.y, nil, inactive)
	end

	local mingranularity = (maxY - minY) / 12
	local maxgranularity = (maxY - minY) / 8
	local granularity = 0.1
	for _, factor in ipairs(Helper.transactionLogConfig.factors) do
		local testgranularity = math.ceil(mingranularity / factor) * factor
		if testgranularity >= maxgranularity then
			break;
		end
		granularity = testgranularity
	end
	maxY = (math.ceil(maxY / granularity) + 0.5) * granularity
	minY = (math.floor(minY / granularity) - 0.5) * granularity

	local xRange = (endtime - starttime) / Helper.transactionLogData.xScale
	local xGranularity = Helper.transactionLogData.xGranularity
	if endtime > starttime then
		while (endtime - starttime) < xGranularity do
			xGranularity = xGranularity / 2
		end
	end
	xGranularity = Helper.round(xGranularity / Helper.transactionLogData.xScale, 3)
	local xOffset = xRange % xGranularity
	local yOffset = (math.ceil(minY / granularity) * granularity) - minY		-- offset is distance from minY to next multiple of granularity (value of first Y axis label)

	Helper.transactionLogData.graph:setXAxis({ startvalue = -xRange, endvalue = 0, granularity = xGranularity, offset = xOffset, gridcolor = Color["graph_grid"] })
	Helper.transactionLogData.graph:setXAxisLabel(Helper.transactionLogData.xTitle, { fontsize = 9 })
	Helper.transactionLogData.graph:setYAxis({ startvalue = minY, endvalue = maxY, granularity = granularity, offset = yOffset, gridcolor = Color["graph_grid"] })
	Helper.transactionLogData.graph:setYAxisLabel(ReadText(1001, 7773) .. " [" .. ReadText(1001, 101) .. "]", { fontsize = 9 })

	-- zoom
	local row = table_graph:addRow(true, { fixed = true })
	row[2]:createButton({ active = Helper.transactionLogData.xZoom > 1 }):setText(ReadText(1001, 7777), { halign = "center" })
	row[2].handlers.onClick = function () return Helper.buttonTransactionLogZoom(-1, refreshCallback) end
	row[3]:createButton({ active = Helper.transactionLogData.xZoom < #Helper.transactionLogConfig.zoomSteps }):setText(ReadText(1001, 7778), { halign = "center" })
	row[3].handlers.onClick = function () return Helper.buttonTransactionLogZoom(1, refreshCallback) end

	table_graph:addConnection(1, 3, true)
end

function ModLua.createLSOStorageNode(menu, container, ware, planned, hasstorage, iscargo)
	local storageinfo_amounts  = C.IsInfoUnlockedForPlayer(container, "storage_amounts")
	local storageinfo_warelist = C.IsInfoUnlockedForPlayer(container, "storage_warelist")
	local storageinfo_capacity = C.IsInfoUnlockedForPlayer(container, "storage_capacity")

	local name, transporttype = GetWareData(ware, "name", "transport")

	-- kuertee start: callback
	if Helper.uix_callbacks ["createLSOStorageNode_get_ware_name"] then
		for uix_id, uix_callback in pairs (Helper.uix_callbacks ["createLSOStorageNode_get_ware_name"]) do
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
	if Helper.uix_callbacks ["updateLSOStorageNode_pre_update_expanded_node"] then
		-- function widgetPrototypes.flowchartnode:updateStatus(text, icon, bgicon, color, mouseovertext)
		local status_text = nil
		local status_icon = statusicon
		local status_bgicon = nil
		local status_color = statuscolor
		local status_mouseovertext = statusiconmouseovertext
		for uix_id, uix_callback in pairs (Helper.uix_callbacks ["updateLSOStorageNode_pre_update_expanded_node"]) do
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
			if Helper.uix_callbacks ["onExpandLSOStorageNode_pre_buy_offer_title"] then
				for uix_id, uix_callback in pairs (Helper.uix_callbacks ["onExpandLSOStorageNode_pre_buy_offer_title"]) do
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
				row[3].handlers.onClick = function () return Helper.buttonEditTradeRule(menu, C.GetContainerTradeRuleID(container, "buy", nodedata.ware)) end
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
					if Helper.uix_callbacks ["onExpandLSOStorageNode_list_incoming_trade"] then
						for uix_id, uix_callback in pairs (Helper.uix_callbacks ["onExpandLSOStorageNode_list_incoming_trade"]) do
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
			if Helper.uix_callbacks ["onExpandLSOStorageNode_pre_sell_offer_title"] then
				for uix_id, uix_callback in pairs (Helper.uix_callbacks ["onExpandLSOStorageNode_pre_sell_offer_title"]) do
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
				row[3].handlers.onClick = function () return Helper.buttonEditTradeRule(menu, C.GetContainerTradeRuleID(container, "sell", nodedata.ware)) end
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
					if Helper.uix_callbacks ["onExpandLSOStorageNode_list_incoming_trade"] then
						for uix_id, uix_callback in pairs (Helper.uix_callbacks ["onExpandLSOStorageNode_list_incoming_trade"]) do
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
	if Helper.uix_callbacks ["onExpandLSOStorageNode"] then
		for uix_id, uix_callback in pairs (Helper.uix_callbacks ["onExpandLSOStorageNode"]) do
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
		if Helper.uix_callbacks ["checkboxSetTradeRuleOverride_pre_update_expanded_node"] then
			-- function widgetPrototypes.flowchartnode:updateStatus(text, icon, bgicon, color, mouseovertext)
			local status_text = nil
			local status_icon = Helper.isTradeRestricted(container, ware) and "lso_error" or nil
			local status_bgicon = nil
			local status_color = Color["icon_warning"]
			local status_mouseovertext
			for uix_id, uix_callback in pairs (Helper.uix_callbacks ["checkboxSetTradeRuleOverride_pre_update_expanded_node"]) do
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

function  ModLua.dropdownTradeRule(menu, container, type, ware, id)
	C.SetContainerTradeRule(container, tonumber(id), type, ware, true)

	if (type == "buy") or (type == "sell") then

		-- kuertee start: callback
		if Helper.uix_callbacks ["dropdownTradeRule_pre_update_expanded_node"] then
			-- function widgetPrototypes.flowchartnode:updateStatus(text, icon, bgicon, color, mouseovertext)
			local status_text = nil
			local status_icon = Helper.isTradeRestricted(container, ware) and "lso_error" or nil
			local status_bgicon = nil
			local status_color = Color["icon_warning"]
			local status_mouseovertext = nil
			for uix_id, uix_callback in pairs (Helper.uix_callbacks ["dropdownTradeRule_pre_update_expanded_node"]) do
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
	if Helper.uix_callbacks ["onCollapseLSOStorageNode"] then
		for uix_id, uix_callback in pairs (Helper.uix_callbacks ["onCollapseLSOStorageNode"]) do
			uix_callback (menu, nodedata)
		end
	end
	-- kuertee end: callback
end

function ModLua.getLimitedWareAmount(ware)
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

Helper.uix_callbackCount = 0
function ModLua.registerCallback(callbackName, callbackFunction, id)
    -- note 1: format is generally [function name]_[action]. e.g.: in kuertee_menu_transporter, "display_on_set_room_active" overrides the room's active property with the return of the callback.
    -- note 2: events have the word "_on_" followed by a PRESENT TENSE verb. e.g.: in kuertee_menu_transporter, "display_on_set_buttontable" is called after all of the rows of buttontable are set.
    -- note 3: new callbacks can be added or existing callbacks can be edited. but commit your additions/changes to the mod's GIT repository.
    -- note 4: search for the callback names to see where they are executed.
    -- note 5: if a callback requires a return value, return it in an object var. e.g. "display_on_set_room_active" requires a return of {active = true | false}.
    if Helper.uix_callbacks [callbackName] == nil then
        Helper.uix_callbacks [callbackName] = {}
    end
    if not Helper.uix_callbacks[callbackName][id] then
        if not id then
            Helper.uix_callbackCount = Helper.uix_callbackCount + 1
            id = "_" .. tostring(Helper.uix_callbackCount)
        end
        Helper.uix_callbacks[callbackName][id] = callbackFunction
        if Helper.isDebugCallbacks then
            Helper.debugText_forced("Helper uix registerCallback: Helper.uix_callbacks[" .. tostring(callbackName) .. "][" .. tostring(id) .. "]: " .. tostring(Helper.uix_callbacks[callbackName][id]))
        end
    else
        Helper.debugText_forced("Helper uix registerCallback: callback at " .. callbackName .. " with id " .. tostring(id) .. " was already previously registered")
    end
end

Helper.uix_isDeregisterQueued = nil
Helper.uix_callbacks_toDeregister = {}
function ModLua.deregisterCallback(callbackName, callbackFunction, id)
    if not Helper.uix_callbacks_toDeregister[callbackName] then
        Helper.uix_callbacks_toDeregister[callbackName] = {}
    end
    if id then
        table.insert(Helper.uix_callbacks_toDeregister[callbackName], id)
    else
        if Helper.uix_callbacks[callbackName] then
            for id, func in pairs(Helper.uix_callbacks[callbackName]) do
                if func == callbackFunction then
                    table.insert(Helper.uix_callbacks_toDeregister[callbackName], id)
                end
            end
        end
    end
    if not Helper.uix_isDeregisterQueued then
        Helper.uix_isDeregisterQueued = true
        Helper.addDelayedOneTimeCallbackOnUpdate(ModLua.deregisterCallbacksNow, true, getElapsedTime() + 1)
    end
end

function ModLua.deregisterCallbacksNow()
    Helper.uix_isDeregisterQueued = nil
    for callbackName, ids in pairs(Helper.uix_callbacks_toDeregister) do
        if Helper.uix_callbacks[callbackName] then
            for _, id in ipairs(ids) do
                if Helper.uix_callbacks[callbackName][id] then
                    if Helper.isDebugCallbacks then
                        Helper.debugText_forced("Helper uix deregisterCallbacksNow (pre): Helper.uix_callbacks[" .. tostring(callbackName) .. "][" .. tostring(id) .. "]: " .. tostring(Helper.uix_callbacks[callbackName][id]))
                    end
                    Helper.uix_callbacks[callbackName][id] = nil
                    if Helper.isDebugCallbacks then
                        Helper.debugText_forced("Helper uix deregisterCallbacksNow (post): Helper.uix_callbacks[" .. tostring(callbackName) .. "][" .. tostring(id) .. "]: " .. tostring(Helper.uix_callbacks[callbackName][id]))
                    end
                else
                    Helper.debugText_forced("Helper uix deregisterCallbacksNow: callback at " .. callbackName .. " with id " .. tostring(id) .. " doesn't exist")
                end
            end
        end
    end
    Helper.uix_callbacks_toDeregister = {}
end

Helper.uix_isUpdateQueued = nil
Helper.uix_callbacks_toUpdate = {}
function ModLua.updateCallback(callbackName, id, callbackFunction)
    if not Helper.uix_callbacks_toUpdate[callbackName] then
        Helper.uix_callbacks_toUpdate[callbackName] = {}
    end
    if id then
        table.insert(Helper.uix_callbacks_toUpdate[callbackName], {id = id, callbackFunction = callbackFunction})
    end
    if not Helper.uix_isUpdateQueued then
        Helper.uix_isUpdateQueued = true
        Helper.addDelayedOneTimeCallbackOnUpdate(ModLua.updateCallbacksNow, true, getElapsedTime() + 1)
    end
end

function ModLua.updateCallbacksNow()
    Helper.uix_isUpdateQueued = nil
    for callbackName, updateDatas in pairs(Helper.uix_callbacks_toUpdate) do
        if Helper.uix_callbacks[callbackName] then
            for _, updateData in ipairs(updateDatas) do
                if Helper.uix_callbacks[callbackName][updateData.id] then
                    if Helper.isDebugCallbacks then
                        Helper.debugText_forced("Helper uix updateCallbacksNow (pre): Helper.uix_callbacks[" .. tostring(callbackName) .. "][" .. tostring(updateData.id) .. "]: " .. tostring(Helper.uix_callbacks[callbackName][updateData.id]))
                    end
                    Helper.uix_callbacks[callbackName][updateData.id] = updateData.callbackFunction
                    if Helper.isDebugCallbacks then
                        Helper.debugText_forced("Helper uix updateCallbacksNow (post): Helper.uix_callbacks[" .. tostring(callbackName) .. "][" .. tostring(updateData.id) .. "]: " .. tostring(Helper.uix_callbacks[callbackName][updateData.id]))
                    end
                else
                    Helper.debugText_forced("Helper uix updateCallbacksNow: callback at " .. callbackName .. " with id " .. tostring(id) .. " doesn't exist")
                end
            end
        end
    end
end

function ModLua.debugText(data1, data2, indent, isForced)
	local isDebug = false
	if isDebug == true or isForced == true then
		if indent == nil then
			indent = ""
		end
		if data1 then
			if not data2 then
				DebugError ("uix: " .. indent .. tostring (data1))
			else
				DebugError ("uix: " .. indent .. tostring (data1) .. " = " .. tostring(data2))
			end
		end
		indent = indent .. "  "
		if type(data1) == "table" then
			for key, value in pairs(data1) do
				Helper.debugText(key, value, indent, isForced)
			end
		end
		if data2 then
			if type(data2) == "table" then
				Helper.debugText(data2, nil, indent, isForced)
			end
		end
	end
end

function ModLua.debugText_forced(data1, data2, indent)
	return Helper.debugText(data1, data2, indent, true)
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
