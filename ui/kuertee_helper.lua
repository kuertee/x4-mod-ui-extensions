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
		oldFuncs.createTransactionLog = Helper.createTransactionLog
		Helper.createTransactionLog = newFuncs.createTransactionLog
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
function newFuncs.createTransactionLog(frame, container, tableProperties, refreshCallback, selectionData)
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

	local row = table_data:addRow(nil, { fixed = true, bgColor = Helper.defaultTitleBackgroundColor })
	row[1]:setColSpan(9):createText(ReadText(1001, 7702), Helper.titleTextProperties)

	local row = table_data:addRow("search", { fixed = true })
	-- searchbar
	row[1]:setColSpan(2):createEditBox({ description = ReadText(1001, 7740), defaultText = ReadText(1001, 3250), height = Helper.subHeaderHeight }):setText(Helper.transactionLogData.searchtext, { halign = "left", x = Helper.standardTextOffsetx }):setHotkey("INPUT_STATE_DETAILMONITOR_0", { displayIcon = true })
	row[1].handlers.onEditBoxDeactivated = function (_, text) if text ~= Helper.transactionLogData.searchtext then Helper.transactionLogData.searchtext = text; Helper.transactionLogData.noupdate = nil; refreshCallback() end end
	-- clear search
	local buttonheight = math.max(Helper.editboxMinHeight, Helper.scaleY(Helper.subHeaderHeight))
	row[3]:createButton({ scaling = false, width = buttonsize, height = buttonheight, cellBGColor = Helper.color.transparent }):setText("X", { halign = "center", font = Helper.standardFontBold })
	row[3].handlers.onClick = function () Helper.transactionLogData.searchtext = ""; refreshCallback() end
	-- pages
	row[4]:createButton({ scaling = false, active = Helper.transactionLogData.curPage > 1, width = buttonsize, height = buttonheight, cellBGColor = Helper.color.transparent }):setIcon("widget_arrow_skip_left_01", { width = buttonsize, height = buttonsize, y = (row:getHeight() - buttonsize) / 2 })
	row[4].handlers.onClick = function () Helper.transactionLogData.curEntry = nil; Helper.transactionLogData.curPage = 1; refreshCallback() end
	row[5]:createButton({ scaling = false, active = Helper.transactionLogData.curPage > 1, width = buttonsize, height = buttonheight, cellBGColor = Helper.color.transparent }):setIcon("widget_arrow_left_01", { width = buttonsize, height = buttonsize, y = (row:getHeight() - buttonsize) / 2 })
	row[5].handlers.onClick = function () Helper.transactionLogData.curEntry = nil; Helper.transactionLogData.curPage = Helper.transactionLogData.curPage - 1; refreshCallback() end
	Helper.transactionLogData.pageEditBox = row[6]:setColSpan(2):createEditBox({ description = ReadText(1001, 7739) }):setText(Helper.transactionLogData.curPage .. " / " .. Helper.transactionLogData.numPages, { halign = "center" })
	row[6].handlers.onEditBoxDeactivated = function (_, text, textchanged) Helper.transactionLogData.noupdate = nil; return Helper.editboxTransactionLogPage(text, textchanged, refreshCallback) end
	row[8]:createButton({ scaling = false, active = Helper.transactionLogData.curPage < Helper.transactionLogData.numPages, width = buttonsize, height = buttonheight, cellBGColor = Helper.color.transparent }):setIcon("widget_arrow_right_01", { width = buttonsize, height = buttonsize, y = (row:getHeight() - buttonsize) / 2 })
	row[8].handlers.onClick = function () Helper.transactionLogData.curEntry = nil; Helper.transactionLogData.curPage = Helper.transactionLogData.curPage + 1; refreshCallback() end
	row[9]:createButton({ scaling = false, active = Helper.transactionLogData.curPage < Helper.transactionLogData.numPages, width = buttonsize, height = buttonheight, cellBGColor = Helper.color.transparent }):setIcon("widget_arrow_skip_right_01", { width = buttonsize, height = buttonsize, y = (row:getHeight() - buttonsize) / 2 })
	row[9].handlers.onClick = function () Helper.transactionLogData.curEntry = nil; Helper.transactionLogData.curPage = Helper.transactionLogData.numPages; refreshCallback() end

	local headerHeight = table_data:getFullHeight()

	if #Helper.transactionLogData.accountLog > 0 then
		local total = 0
		for i = startIndex, endIndex, -1 do
			local entry = Helper.transactionLogData.accountLog[i]
			local row = table_data:addRow(entry.entryid, { bgColor = Helper.color.transparent })
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
			row[2]:createText(((entry.partnername ~= "") and (entry.partnername .. " - ") or "") .. entry.eventtypename, { color = entry.destroyedpartner and Helper.color.grey or nil, mouseOverText = entry.destroyedpartner and ReadText(1026, 5701) or "" })
			row[3]:setColSpan(4):createText(Helper.getPassedTime(entry.time), { halign = "right" })
			row[7]:setColSpan(3):createText(((entry.money > 0) and "+" or "") .. ConvertMoneyString(entry.money, false, true, 0, true) .. " " .. ReadText(1001, 101), { halign = "right", color = (entry.money > 0) and Helper.color.green or Helper.color.red })
			total = total + entry.money
			if Helper.transactionLogData.expandedEntries[entry.entryid] then
				local row = table_data:addRow(nil, { bgColor = Helper.color.unselectable })
				row[1].properties.cellBGColor = Helper.color.transparent
				row[2]:setColSpan(8):createText(entry.description, { x = Helper.standardTextHeight, wordwrap = true, color = entry.destroyedpartner and Helper.color.grey or nil })
			end
		end

		if Helper.transactionLogData.xZoom < #Helper.transactionLogConfig.zoomSteps then
			local row = table_data:addRow("showmore", { bgColor = Helper.color.transparent })
			row[1]:setColSpan(9):createButton({ bgColor = Helper.color.transparent }):setText(ReadText(1001, 7778), { halign = "center" })
			if endIndex == 1 then
				row[1].handlers.onClick = function () return Helper.buttonTransactionLogZoom(1, refreshCallback) end
			else
				row[1].handlers.onClick = function () Helper.transactionLogData.curEntry = nil; Helper.transactionLogData.curPage = Helper.transactionLogData.curPage + 1; refreshCallback(_, 1) end
			end
		end

		local table_total = frame:addTable(2, { tabOrder = 0, width = tableProperties.width, x = tableProperties.x, y = tableProperties.y })
		table_total:setColWidthPercent(1, 75)

		table_total:addEmptyRow()

		local row = table_total:addRow(nil, { bgColor = Helper.color.lightgrey })
		row[1]:setColSpan(2):createText("", { fontsize = 1, minRowHeight = 2 })

		local row = table_total:addRow(nil, { bgColor = Helper.color.transparent })
		row[1]:createText(ReadText(1001, 7776) .. ReadText(1001, 120))
		row[2]:createText(((total > 0) and "+" or "") .. ConvertMoneyString(total, false, true, 0, true) .. " " .. ReadText(1001, 101), { halign = "right", color = (total > 0) and Helper.color.green or Helper.color.red })

		local maxVisibleHeight = table_data.properties.maxVisibleHeight - table_total:getFullHeight() - Helper.frameBorder
		table_total.properties.y = table_total.properties.y + math.min(maxVisibleHeight, table_data:getFullHeight())
		table_data.properties.maxVisibleHeight = table_total.properties.y - table_data.properties.y

		table_data:addConnection(1, 2, true)
		table_total:addConnection(2, 2)
	else
		local row = table_data:addRow("none", { bgColor = Helper.color.transparent })
		row[1]:setColSpan(9):createText("--- " .. ReadText(1001, 5705) .. " ---", { halign = "center" })

		if Helper.transactionLogData.xZoom < #Helper.transactionLogConfig.zoomSteps then
			local row = table_data:addRow("showmore", { bgColor = Helper.color.transparent })
			row[1]:setColSpan(9):createButton({ bgColor = Helper.color.transparent }):setText(ReadText(1001, 7778), { halign = "center" })
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

	-- kuertee start: ensure graph is only half viewHeight so that trade analytics can fit
	-- local height = math.min(Helper.viewHeight - tableProperties.y - Helper.frameBorder - Helper.scaleY(Helper.standardTextHeight) - Helper.borderSize, math.floor(width * 9 / 16))
	-- local table_graph = frame:addTable(4, { tabOrder = 3, width = width, x = xoffset, y = tableProperties.y })
	local height = Helper.viewHeight * 0.5 - tableProperties.y - Helper.frameBorder - Helper.scaleY(Helper.standardTextHeight) - Helper.borderSize
	local table_graph = frame:addTable(4, { tabOrder = 3, width = width, height = height, x = xoffset, y = tableProperties.y })
	-- kuertee end: ensure graph is only half viewHeight so that trade analytics can fit

	table_graph:setColWidthPercent(2, 15)
	table_graph:setColWidthPercent(3, 15)

	-- graph cell
	local row = table_graph:addRow(false, { fixed = true, bgColor = Helper.color.transparent })

	local minY, maxY = 0, 1
	local datarecords = {}

	local data = {}
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
		table.insert(data, Helper.createGraphDataPoint((point.t - endtime) / Helper.transactionLogData.xScale, point.y, nil, nil, inactive))
	end

	table.insert(datarecords, Helper.createGraphDataRecord(Helper.transactionLogConfig.point.type, Helper.transactionLogConfig.point.size, Helper.color.brightyellow, Helper.transactionLogConfig.line.type, Helper.transactionLogConfig.line.size, Helper.color.brightyellow, data, false))

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

	local xaxis = Helper.createGraphAxis(Helper.createGraphText(Helper.transactionLogData.xTitle, Helper.standardFont, 9, Helper.color.white), -xRange, 0, xGranularity, xOffset, true, Helper.color.white, { r = 96, g = 96, b = 96, a = 80 })
	local yaxis = Helper.createGraphAxis(Helper.createGraphText(ReadText(1001, 7773) .. " [" .. ReadText(1001, 101) .. "]", Helper.standardFont, 9, Helper.color.white), minY, maxY, granularity, yOffset, true, Helper.color.white, { r = 96, g = 96, b = 96, a = 80 })

	-- graph
	local title = ffi.string(C.GetComponentName(container))
	if container ~= C.GetPlayerID() then
		title = title .. " (" .. ffi.string(C.GetObjectIDCode(container)) .. ")"
	end
	Helper.transactionLogData.graph = row[1]:setColSpan(4):createGraph("line", true, Helper.color.semitransparent, { text = title, font = Helper.titleFont, size = Helper.scaleFont(Helper.titleFont, Helper.titleFontSize), color = Helper.color.white }, xaxis, yaxis, datarecords, 0, 0, nil, height)
	row[1].handlers.onClick = function (_, data) return Helper.graphDataSelection(data, refreshCallback) end

	-- zoom
	local row = table_graph:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
	row[2]:createButton({ active = Helper.transactionLogData.xZoom > 1 }):setText(ReadText(1001, 7777), { halign = "center" })
	row[2].handlers.onClick = function () return Helper.buttonTransactionLogZoom(-1, refreshCallback) end
	row[3]:createButton({ active = Helper.transactionLogData.xZoom < #Helper.transactionLogConfig.zoomSteps }):setText(ReadText(1001, 7778), { halign = "center" })
	row[3].handlers.onClick = function () return Helper.buttonTransactionLogZoom(1, refreshCallback) end

	table_graph:addConnection(1, 3, true)
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
					-- row[1]:createText(function () return Helper.getETAString(name, reservation.eta) end, { font = Helper.standardFontMono })
					if callbacks ["onExpandLSOStorageNode_list_incoming_trade"] then
						for _, callback in ipairs (callbacks ["onExpandLSOStorageNode_list_incoming_trade"]) do
							callback (row, name, reservation, isplayerowned)
						end
					else
						row[1]:createText(function () return Helper.getETAString(name, reservation.eta) end, { font = Helper.standardFontMono })
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
					-- row[1]:createText(function () return Helper.getETAString(name, reservation.eta) end, { font = Helper.standardFontMono })
					if callbacks ["onExpandLSOStorageNode_list_incoming_trade"] then
						for _, callback in ipairs (callbacks ["onExpandLSOStorageNode_list_incoming_trade"]) do
							callback (row, name, reservation, isplayerowned)
						end
					else
						row[1]:createText(function () return Helper.getETAString(name, reservation.eta) end, { font = Helper.standardFontMono })
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
