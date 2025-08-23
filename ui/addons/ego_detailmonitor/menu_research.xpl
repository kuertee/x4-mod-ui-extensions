-- param == { 0, 0 }

-- ffi setup
local ffi = require("ffi")
local C = ffi.C
ffi.cdef[[
	void ClearProductionItems(UniverseID productionmoduleid);
	uint32_t GetAmountOfWareAvailable(const char* wareid, UniverseID productionmoduleid);
	uint32_t GetHQs(UniverseID* result, uint32_t resultlen, const char* factionid);
	uint32_t GetNumHQs(const char* factionid);
	uint32_t GetNumResearchModules(UniverseID containerid);
	uint32_t GetNumWares(const char* tags, bool research, const char* licenceownerid, const char* exclusiontags);
	uint32_t GetResearchModules(UniverseID* result, uint32_t resultlen, UniverseID containerid);
	uint32_t GetWares(const char** result, uint32_t resultlen, const char* tags, bool research, const char* licenceownerid, const char* exclusiontags);
	bool HasResearched(const char* wareid);
	void StartResearch(const char* wareid, UniverseID researchmoduleid);
	void UpdateProduction(UniverseID containerormoduleid, bool force);
]]

-- menu variable - used by Helper and used for dynamic variables (e.g. inventory content, etc.)
local menu = {
	name = "ResearchMenu",
	activeresearch = {},
	techtree = {}
}

-- config variable - put all static setup here
local config = {
	mainFrameLayer = 5,
	expandedMenuFrameLayer = 4,
	nodeoffsetx = 30,
	nodewidth = 270,
}

-- kuertee start:
menu.uix_callbacks = {}
-- kuertee end

-- init menu and register with Helper
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

-- cleanup variables in menu, no need for the menu variable to keep all the data while the menu is not active
function menu.cleanup()
	unregisterForEvent("inputModeChanged", getElement("Scene.UIContract"), menu.onInputModeChanged)
	menu.topLevelOffsetY = nil

	menu.techtree = {}
	menu.researchmodules = nil
	menu.availableresearchmodule = nil
	menu.currentResearch = {}

	menu.checkResearch = nil
	menu.restoreNode = nil
	menu.restoreNodeTech = nil

	menu.flowchartRows = nil
	menu.flowchartCols = nil

	menu.expandedNode = nil
	menu.expandedMenuFrame = nil
	menu.expandedMenuTable = nil

	menu.topRows = {}
	menu.firstCols = {}
	menu.selectedRows = {}
	menu.selectedCols = {}

	menu.frame = nil
end

-- Menu member functions

function menu.onShowMenu()
	Helper.setTabScrollCallback(menu, menu.onTabScroll)
	registerForEvent("inputModeChanged", getElement("Scene.UIContract"), menu.onInputModeChanged)

	menu.topRows = {}
	menu.firstCols = {}
	menu.selectedRows = {}
	menu.selectedCols = {}

	local stationhqlist = {}
	Helper.ffiVLA(stationhqlist, "UniverseID", C.GetNumHQs, C.GetHQs, "player")
	menu.hq = stationhqlist[1] or 0

	menu.researchmodules = {}
	for i = 1, #stationhqlist do
		Helper.ffiVLA(menu.researchmodules, "UniverseID", C.GetNumResearchModules, C.GetResearchModules, stationhqlist[i])
		-- trigger a production update to ensure any completed research items have been added to the player research database
		C.UpdateProduction(stationhqlist[i], false)
	end
	menu.availableresearchmodule = nil

	if #menu.techtree == 0 then
		-- Get all research wares from the WareDB.
		local numtechs = C.GetNumWares("", true, "", "hidden")
		local rawtechlist = ffi.new("const char*[?]", numtechs)
		local temptechlist = {}
		numtechs = C.GetWares(rawtechlist, numtechs, "", true, "", "hidden")
		for i = 0, numtechs - 1 do
			local tech = ffi.string(rawtechlist[i])
			if IsKnownItem("researchables", tech) then
				table.insert(temptechlist, tech)
			end
		end
		-- NB: don't really need to sort at this point, but will help the entries in the menu stay consistent.
		table.sort(temptechlist, Helper.sortWareSortOrder)

		-- print("searching for wares without precursor")
		for i = #temptechlist, 1, -1 do
			local techprecursors, sortorder = GetWareData(temptechlist[i], "researchprecursors", "sortorder")
			if #techprecursors == 0 then
				if not GetWareData(temptechlist[i], "ismissiononly") then
					-- print("found " .. temptechlist[i])
					local state_completed = C.HasResearched(temptechlist[i])
					table.insert(menu.techtree, { [1] = { [1] = { tech = temptechlist[i], sortorder = sortorder, completed = state_completed } } })
				end
				table.remove(temptechlist, i)
			else
				local hasonlymissionprecursors = true
				for i, precursor in ipairs(techprecursors) do
					if not GetWareData(precursor, "ismissiononly") then
						hasonlymissionprecursors = false
						break
					end
				end
				if hasonlymissionprecursors then
					-- print("found with only mission precursors" .. temptechlist[i])
					local state_completed = C.HasResearched(temptechlist[i])
					table.insert(menu.techtree, { [1] = { [1] = { tech = temptechlist[i], sortorder = sortorder, completed = state_completed } } })
					table.remove(temptechlist, i)
				end
			end
		end

		-- print("\ngoing through remaining wares")
		local loopcounter = 0
		local idx = 1
		while #temptechlist > 0 do
			-- print("looking at: " .. temptechlist[idx])
			local techprecursors, sortorder = GetWareData(temptechlist[idx], "researchprecursors", "sortorder")
			-- print("    #precusors: " .. #techprecursors)
			local precursordata = {}
			local smallestMainIdx, foundPrecusorCol
			-- try to find all precusors in existing data
			for i, precursor in ipairs(techprecursors) do
				local mainIdx, precursorCol = menu.findTech(menu.techtree, precursor)
				-- print("    precusor " .. precursor .. ": " .. tostring(mainIdx) .. ", " .. tostring(precursorCol))
				if mainIdx and ((not smallestMainIdx) or (smallestMainIdx > mainIdx)) then
					smallestMainIdx = mainIdx
					foundPrecusorCol = precursorCol
				end
				precursordata[i] = { mainIdx = mainIdx, precursorCol = precursorCol }
			end
			-- sort so that highest index comes first - important for deletion order and keeping smallestMainIdx valid
			table.sort(precursordata, menu.precursorSorter)

			if smallestMainIdx then
				-- print("    smallestMainIdx: " .. smallestMainIdx .. ", foundPrecusorCol: " .. foundPrecusorCol)
				-- fix wares without precursors that there wrongly placed in different main entries
				for i, entry in ipairs(precursordata) do
					if entry.mainIdx and (entry.mainIdx ~= smallestMainIdx) then
						-- print("    precusor " .. techprecursors[i] .. " @ " .. entry.mainIdx .. " ... merging")
						for col, columndata in ipairs(menu.techtree[entry.mainIdx]) do
							for techidx, techentry in ipairs(columndata) do
								-- print("    adding menu.techtree[" .. entry.mainIdx .. "][" .. col .. "][" .. techidx .. "] to menu.techtree[" .. smallestMainIdx .. "][" .. col .. "]")
								table.insert(menu.techtree[smallestMainIdx][col], techentry)
							end
						end
						-- print("    removing mainIdx " .. entry.mainIdx)
						table.remove(menu.techtree, entry.mainIdx)
					end
				end

				-- add this tech to the tree and remove it from the list
				local state_completed = C.HasResearched(temptechlist[idx])
				if menu.techtree[smallestMainIdx][foundPrecusorCol + 1] then
					-- print("    adding")
					table.insert(menu.techtree[smallestMainIdx][foundPrecusorCol + 1], { tech = temptechlist[idx], sortorder = sortorder, completed = state_completed })
				else
					-- print("    new entry")
					menu.techtree[smallestMainIdx][foundPrecusorCol + 1] = { [1] = { tech = temptechlist[idx], sortorder = sortorder, completed = state_completed } }
				end
				-- print("    removed")
				table.remove(temptechlist, idx)
			end

			if idx >= #temptechlist then
				loopcounter = loopcounter + 1
				idx = 1
			else
				idx = idx + 1
			end
			if loopcounter > 100 then
				DebugError("Infinite loop detected - aborting.")
				break
			end
		end
	end

	menu.flowchartRows = 0
	menu.flowchartCols = 0
	local lastsortorder = 0
	for i, mainentry in ipairs(menu.techtree) do
		if (menu.flowchartRows ~= 0) and (math.floor(mainentry[1][1].sortorder / 100) ~= math.floor(lastsortorder / 100)) then
			menu.flowchartRows = menu.flowchartRows + 1
		end
		lastsortorder = mainentry[1][1].sortorder

		menu.flowchartCols = math.max(menu.flowchartCols, #mainentry)
		local maxRows = 0
		for col, columnentry in ipairs(mainentry) do
			maxRows = math.max(maxRows, #columnentry)
			table.sort(columnentry, menu.sortTechName)
		end

		menu.flowchartRows = menu.flowchartRows + maxRows
	end
	-- add column for account node
	menu.flowchartCols = menu.flowchartCols + 1

	menu.display()
end

function menu.display()
	-- remove old data
	Helper.clearDataForRefresh(menu)

	-- Organize Visual Menu
	local width = Helper.viewWidth
	local height = Helper.viewHeight
	local xoffset = 0
	local yoffset = 0

	local numcategories = 0

	menu.frame = Helper.createFrameHandle(menu, { height = height, width = width, x = xoffset, y = yoffset, layer = config.mainFrameLayer })
	menu.frame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	menu.createTopLevel(menu.frame)

	width = width - 2 * Helper.frameBorder
	xoffset = xoffset + Helper.frameBorder

	-- HACK: Disabling the top level tab table as interactive object
	local table_data = menu.frame:addTable( 1, { tabOrder = 1, highlightMode = "column", width = width, x = xoffset, y = menu.topLevelOffsetY + Helper.borderSize } )
	
	local rightBarX = Helper.viewWidth - Helper.scaleX(Helper.sidebarWidth) - Helper.frameBorder
	local width = rightBarX - Helper.frameBorder - Helper.borderSize

	menu.flowchart = menu.frame:addFlowchart(menu.flowchartRows, menu.flowchartCols, { borderHeight = 3, borderColor = Color["row_background_blue"], minRowHeight = 45, minColWidth = 80, x = Helper.frameBorder, y = menu.topLevelOffsetY + Helper.borderSize, width = width })
	menu.flowchart:setDefaultNodeProperties({
		expandedFrameLayer = config.expandedMenuFrameLayer,
		expandedTableNumColumns = 2,
		x = config.nodeoffsetx,
		width = config.nodewidth,
	})
	for col = 2, menu.flowchartCols, 2 do
		menu.flowchart:setColBackgroundColor(col, Color["row_background_blue"])
	end

	-- update current research and available research module
	menu.currentResearch = {}
	for _, module in ipairs(menu.researchmodules) do
		local module64 = ConvertStringTo64Bit(tostring(module))
		local proddata = GetProductionModuleData(module64)
		if (proddata.state == "empty") and (not GetComponentData(module64, "ishacked")) then
			if not menu.availableresearchmodule then
				menu.availableresearchmodule = module
			end
		elseif (proddata.state == "producing") or (proddata.state == "waitingforresources") then
			menu.currentResearch[proddata.blueprintware] = module
		end
	end

	-- update research status of given tech if any
	if menu.checkResearch then
		local mainIdx, col, techIdx = menu.findTech(menu.techtree, menu.checkResearch)
		menu.techtree[mainIdx][col][techIdx].completed = C.HasResearched(menu.checkResearch)
		menu.checkResearch = nil
	end

	-- account info
	if menu.hq ~= 0 then
		local container = ConvertStringTo64Bit(tostring(menu.hq))
		local money, productionmoney = GetComponentData(container, "money", "productionmoney")
		local supplymoney = tonumber(C.GetSupplyBudget(container)) / 100
		local tradewaremoney = tonumber(C.GetTradeWareBudget(container)) / 100
		local budget = math.floor(productionmoney + supplymoney + tradewaremoney)

		local shownamount = money
		local shownmax = math.max(shownamount, budget)

		local statustext = string.format("%s/%s %s", ConvertMoneyString(money, false, true, 3, true, false), ConvertMoneyString(productionmoney + supplymoney + tradewaremoney, false, true, 3, true, false), ReadText(1001, 101))
		menu.accountnode = menu.flowchart:addNode(1, 1, { data = { account = true }, expandHandler = menu.expandAccountNode }, { shape = "rectangle", value = shownamount, max = shownmax }):setText(ReadText(1001, 7413)):setStatusText(statustext)

		menu.accountnode.handlers.onExpanded = menu.onFlowchartNodeExpanded
		menu.accountnode.handlers.onCollapsed = menu.onFlowchartNodeCollapsed
	end

	local rowCounter = 1
	local lastsortorder = 0
	for i, mainentry in ipairs(menu.techtree) do
		if (rowCounter ~= 1) and (math.floor(mainentry[1][1].sortorder / 100) ~= math.floor(lastsortorder / 100)) then
			rowCounter = rowCounter + 1
		end
		lastsortorder = mainentry[1][1].sortorder

		local maxRows = 0
		for col, columnentry in ipairs(mainentry) do
			maxRows = math.max(maxRows, #columnentry)
			for j, techentry in ipairs(columnentry) do
				local value, max = 0, 100
				local statusText
				local icon
				local iconmouseovertext
				if techentry.completed then
					value = 100
				elseif menu.currentResearch[techentry.tech] then
					local proddata = GetProductionModuleData(ConvertStringTo64Bit(tostring(menu.currentResearch[techentry.tech])))
					value = function() return Helper.round(math.max(1, menu.currentResearch[techentry.tech] and (GetProductionModuleData(ConvertStringTo64Bit(tostring(menu.currentResearch[techentry.tech]))).cycleprogress or 0) or 100)) end
					statusText = function() return Helper.round(math.max(1, menu.currentResearch[techentry.tech] and (GetProductionModuleData(ConvertStringTo64Bit(tostring(menu.currentResearch[techentry.tech]))).cycleprogress or 0) or 100)) .. " %" end

					if proddata.state == "waitingforresources" then
						local resources = GetWareData(techentry.tech, "resources")
						for _, resourcedata in ipairs(resources) do
							local locamount = C.GetAmountOfWareAvailable(resourcedata.ware, menu.currentResearch[techentry.tech])
							if locamount < resourcedata.amount then
								icon = "lso_warning"
								iconmouseovertext = ColorText["text_warning"] .. ReadText(1026, 8007)
								break
							end
						end
					end
				elseif menu.availableresearchmodule and menu.isResearchAvailable(techentry.tech, i, col) then
					local resources = GetWareData(techentry.tech, "resources")
					for _, resourcedata in ipairs(resources) do
						local locamount = C.GetAmountOfWareAvailable(resourcedata.ware, menu.availableresearchmodule)
						if locamount < resourcedata.amount then
							icon = "lso_warning"
							iconmouseovertext = ColorText["text_warning"] .. ReadText(1026, 8007)
							break
						end
					end
				end
				local color
				if (not techentry.completed) and (not menu.currentResearch[techentry.tech]) and (not menu.isResearchAvailable(techentry.tech, i, col)) then
					color = Color["research_incomplete"]
				end

				techentry.node = menu.flowchart:addNode(rowCounter + j - 1, col + 1, { data = { mainIdx = i, col = col, techdata = techentry }, expandHandler = menu.expandNode }, { shape = "stadium", value = value, max = max, statusIconMouseOverText = iconmouseovertext }):setText(GetWareData(techentry.tech, "name"), { color = color }):setStatusText(statusText, { color = color })
				techentry.node.properties.outlineColor = color

				if icon then
					techentry.node:setStatusIcon(icon, { color = Color["icon_warning"] })
				end

				techentry.node.handlers.onExpanded = menu.onFlowchartNodeExpanded
				techentry.node.handlers.onCollapsed = menu.onFlowchartNodeCollapsed

				if menu.restoreNodeTech and menu.restoreNodeTech == techentry.tech then
					menu.restoreNode = techentry.node
					menu.restoreNodeTech = nil
				end

				if col > 1 then
					for k, previousentry in ipairs(mainentry[col - 1]) do
						-- print("adding edge from node " .. previousentry.tech .. " to " .. techentry.tech)
						local edge = previousentry.node:addEdgeTo(techentry.node)
						if not previousentry.completed then
							edge.properties.sourceSlotColor = Color["research_incomplete"]
							edge.properties.color = Color["research_incomplete"]
						end
						edge.properties.destSlotColor = color
					end
				end
			end
		end

		local skiprow = false
		if math.floor(mainentry[1][1].sortorder / 100) ~= math.floor(lastsortorder / 100) then
			lastsortorder = mainentry[1][1].sortorder
			skiprow = true
		end

		rowCounter = rowCounter + maxRows
	end

	menu.restoreFlowchartState("flowchart", menu.flowchart)

	local stationhqlist = {}
	Helper.ffiVLA(stationhqlist, "UniverseID", C.GetNumHQs, C.GetHQs, "player")
	Helper.createRightSideBar(menu.frame, ConvertStringTo64Bit(tostring(stationhqlist[1] or 0)), #menu.researchmodules > 0, "research", menu.buttonRightBar)

	-- display view/frame
	menu.frame:display()
end

function menu.onFlowchartNodeExpanded(node, frame, ftable, ftable2)
	node.flowchart:collapseAllNodes()
	local data = node.customdata
	local expandHandler = data.expandHandler
	if expandHandler then
		expandHandler(frame, ftable, ftable2, data.data)
		menu.expandedNode = node
		menu.expandedMenuFrame = frame
		menu.expandedMenuTable = ftable
	end
end

function menu.researchStateText(researchware)
	if menu.currentResearch[researchware] ~= nil then 
		local proddata = GetProductionModuleData(ConvertStringTo64Bit(tostring(menu.currentResearch[researchware])))
		return ((proddata.state == "waitingforresources") and ReadText(1001, 4231) or ReadText(1001, 7409)) .. ReadText(1001, 120)
	end
	return ReadText(1001, 7408)
end

function menu.researchTimeText(researchware, researchtime)
	if menu.currentResearch[researchware] ~= nil then 
		local proddata = GetProductionModuleData(ConvertStringTo64Bit(tostring(menu.currentResearch[researchware])))
		return (proddata.state == "waitingforresources") and ConvertTimeString(researchtime) or ConvertTimeString(menu.currentResearch[researchware] and (proddata.remainingcycletime or 0) or 0)
	end
	return ""
end

function menu.expandNode(_, ftable, _, data)
	AddUITriggeredEvent(menu.name, "research_selected", data.techdata.tech)
	local description, researchtime = GetWareData(data.techdata.tech, "description", "researchtime")
	-- description
	local row = ftable:addRow(nil, { fixed = true })
	row[1]:setColSpan(2):createText(description .. "\n ", { wordwrap = true })
	if menu.currentResearch[data.techdata.tech] then
		-- remaining time
		local row = ftable:addRow(nil, { fixed = true })
		row[1]:setColSpan(2):createText(function () return menu.researchStateText(data.techdata.tech) end)
		local row = ftable:addRow(nil, { fixed = true })
		row[1]:setColSpan(2):createText(function () return menu.researchTimeText(data.techdata.tech, researchtime) end, { halign = "right" })
		if GetProductionModuleData(ConvertStringTo64Bit(tostring(menu.currentResearch[data.techdata.tech]))).state == "waitingforresources" then
			local resources, precursors = GetWareData(data.techdata.tech, "resources", "researchprecursors")
			-- mission precursors
			local hasmissionprecursors = false
			for i, precursor in ipairs(precursors) do
				if GetWareData(precursor, "ismissiononly") and (not C.HasResearched(precursor)) then
					hasmissionprecursors = true
					break
				end
			end
			if (#precursors > 0) and hasmissionprecursors then
				local row = ftable:addRow(nil, { fixed = true })
				row[1]:setColSpan(2):createText(ReadText(1001, 7412) .. ReadText(1001, 120))
				for i, precursor in ipairs(precursors) do
					local name, ismissiononly = GetWareData(precursor, "name", "ismissiononly")
					if ismissiononly and (not C.HasResearched(precursor)) then
						local row = ftable:addRow(nil, { fixed = true })
						row[1]:setColSpan(2):createText("  " .. name)
					end
				end
			end
			-- resources
			if #resources > 0 then
				local row = ftable:addRow(nil, { fixed = true })
				row[1]:setColSpan(2):createText(ReadText(1001, 7411) .. ReadText(1001, 120))
				for _, resourcedata in ipairs(resources) do
					local locamount = C.GetAmountOfWareAvailable(resourcedata.ware, menu.currentResearch[data.techdata.tech])
					local color
					if locamount and (locamount < resourcedata.amount) then
						color = Color["text_warning"]
					end
					local row = ftable:addRow(nil, { fixed = true })
					row[1]:createText("  " .. GetWareData(resourcedata.ware, "name"), { color = color })
					row[2]:createText((locamount and (locamount .. " / ") or "") .. resourcedata.amount, { halign = "right", color = color })
				end
			end
			-- cancel
			local row = ftable:addRow(true, { fixed = true })
			row[1]:setColSpan(2):createButton({ active = function () return GetProductionModuleData(ConvertStringTo64Bit(tostring(menu.currentResearch[data.techdata.tech]))).state == "waitingforresources" end }):setText(ReadText(1001, 7410))
			row[1].handlers.onClick = function () return menu.buttonCancelResearch(data.techdata) end
			row[1].properties.uiTriggerID = data.techdata.tech .. "_cancel"
		end
	elseif data.techdata.completed then
		-- completed
		local row = ftable:addRow(nil, { fixed = true })
		row[1]:setColSpan(2):createText(ReadText(1001, 7408))
	else
		-- research time
		local row = ftable:addRow(nil, { fixed = true })
		row[1]:setColSpan(2):createText(ReadText(1001, 7406) .. ReadText(1001, 120))
		local row = ftable:addRow(nil, { fixed = true })
		row[1]:setColSpan(2):createText(ConvertTimeString(researchtime), { halign = "right" })
		local resources, precursors = GetWareData(data.techdata.tech, "resources", "researchprecursors")
		-- mission precursors
		local hasmissionprecursors = false
		for i, precursor in ipairs(precursors) do
			if GetWareData(precursor, "ismissiononly") and (not C.HasResearched(precursor)) then
				hasmissionprecursors = true
				break
			end
		end
		if (#precursors > 0) and hasmissionprecursors then
			local row = ftable:addRow(nil, { fixed = true })
			row[1]:setColSpan(2):createText(ReadText(1001, 7412) .. ReadText(1001, 120))
			for i, precursor in ipairs(precursors) do
				local name, ismissiononly = GetWareData(precursor, "name", "ismissiononly")
				if ismissiononly and (not C.HasResearched(precursor)) then
					local row = ftable:addRow(nil, { fixed = true })
					row[1]:setColSpan(2):createText("  " .. name)
				end
			end
		end
		-- resources
		if #resources > 0 then
			local row = ftable:addRow(nil, { fixed = true })
			row[1]:setColSpan(2):createText(ReadText(1001, 7411) .. ReadText(1001, 120))
			for _, resourcedata in ipairs(resources) do
				local locamount = menu.availableresearchmodule and C.GetAmountOfWareAvailable(resourcedata.ware, menu.availableresearchmodule) or nil
				local color
				if locamount and (locamount < resourcedata.amount) then
					color = Color["text_warning"]
				end
				local row = ftable:addRow(nil, { fixed = true })
				row[1]:createText("  " .. GetWareData(resourcedata.ware, "name"), { color = color })
				row[2]:createText((locamount and (locamount .. " / ") or "") .. resourcedata.amount, { halign = "right", color = color })
			end
		end

        -- start: kuertee call-back
        if menu.uix_callbacks ["expandNode_before_start_button"] then
            for uix_id, uix_callback in pairs (menu.uix_callbacks ["expandNode_before_start_button"]) do
                uix_callback (ftable, resources, data)
            end
        end
        -- end: kuertee call-back

		-- start button
		local row = ftable:addRow(true, { fixed = true })
		local isavailable = menu.isResearchAvailable(data.techdata.tech, data.mainIdx, data.col)
		local mouseovertext = ""
		if not isavailable then
			if menu.availableresearchmodule then
				mouseovertext = ColorText["text_error"] .. ReadText(1026, 7402)
			else
				if (#menu.researchmodules > 0) and GetComponentData(ConvertStringTo64Bit(tostring(menu.researchmodules[1])), "ishacked") then
					mouseovertext = ColorText["text_error"] .. ReadText(1026, 7403)
				else
					mouseovertext = ColorText["text_error"] .. ReadText(1026, 7401)
				end
			end
		end
		row[1]:setColSpan(2):createButton({ active = isavailable, mouseOverText = mouseovertext }):setText(ReadText(1001, 7407))
		row[1].handlers.onClick = function () return menu.buttonStartResearch(data.techdata) end
		row[1].properties.uiTriggerID = data.techdata.tech
	end

	menu.restoreTableState("nodeTable", ftable)
end

function menu.expandAccountNode(_, ftable, _, data)
	if menu.hq ~= 0 then
		local container = ConvertStringTo64Bit(tostring(menu.hq))
		local money, productionmoney = GetComponentData(container, "money", "productionmoney")
		local supplymoney = tonumber(C.GetSupplyBudget(container)) / 100
		local trademoney = tonumber(C.GetTradeWareBudget(container)) / 100
		local budget = math.floor(productionmoney + supplymoney + trademoney)
		local playermoney = math.max(0, GetPlayerMoney())

		local row
		-- missing funds
		if money < budget then
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(2):createText(menu.getAccountWarningText, { color = menu.getAccountWarningColor, wordwrap = true })

			ftable:addEmptyRow(Helper.standardTextHeight / 2)
		end
		-- wanted money
		row = ftable:addRow(nil, {  })
		row[1]:setColSpan(2):createText(ReadText(1001, 1919) .. ReadText(1001, 120))
		row = ftable:addRow(nil, {  })
		row[1]:setColSpan(2):createText(ConvertMoneyString(budget, false, true, 0, true, false) .. " " .. ReadText(1001, 101), { halign = "right" })
		-- production and building
		row = ftable:addRow(nil, {  })
		local numproductionmodules = #GetProductionModules(container)
		local numbuildmodules = C.GetNumBuildModules(container)
		local text = ReadText(1001, 8420)
		if numbuildmodules > 0 then
			if numproductionmodules > 0 then
				text = ReadText(1001, 8422)
			else
				text = ReadText(1001, 8421)
			end
		end
		row[1]:setColSpan(2):createText(text .. ReadText(1001, 120))
		row = ftable:addRow(nil, {  })
		row[1]:setColSpan(2):createText(ConvertMoneyString(productionmoney, false, true, 0, true, false) .. " " .. ReadText(1001, 101), { halign = "right" })
		-- supplies
		row = ftable:addRow(nil, {  })
		row[1]:setColSpan(2):createText(ReadText(1001, 8423) .. ReadText(1001, 120))
		row = ftable:addRow(nil, {  })
		row[1]:setColSpan(2):createText(ConvertMoneyString(supplymoney, false, true, 0, true, false) .. " " .. ReadText(1001, 101), { halign = "right" })
		-- trade wares
		row = ftable:addRow(nil, {  })
		row[1]:setColSpan(2):createText(ReadText(1001, 8447) .. ReadText(1001, 120))
		row = ftable:addRow(nil, {  })
		row[1]:setColSpan(2):createText(ConvertMoneyString(trademoney, false, true, 0, true, false) .. " " .. ReadText(1001, 101), { halign = "right" })
		-- current money
		row = ftable:addRow(true, {  })
		row[1]:setColSpan(2):createSliderCell({
			height = Helper.standardTextHeight,
			min = 0,
			max = playermoney + money,
			start = money,
			hideMaxValue = true,
			suffix = ReadText(1001, 101),
		}):setText(ReadText(1001, 7710))
		row[1].handlers.onSliderCellChanged = menu.slidercellAccount
		-- confirm
		row = ftable:addRow(true, {  })
		row[1]:createButton({ active = function () return (menu.newAccountValue ~= nil) and GetComponentData(container, "isplayerowned") end }):setText(ReadText(1001, 2821), { halign = "center" })
		row[1].handlers.onClick = menu.buttonAccountConfirm
		row[2]:createButton({ active = function () local money, estimate, isplayerowned = GetComponentData(container, "money", "productionmoney", "isplayerowned"); estimate = estimate + tonumber(C.GetSupplyBudget(container)) / 100; estimate = estimate + tonumber(C.GetTradeWareBudget(container)) / 100; return isplayerowned and ((money + GetPlayerMoney()) > estimate) end }):setText(ReadText(1001, 7965), { halign = "center" })
		row[2].handlers.onClick = menu.buttonAccountToEstimate

		menu.restoreTableState("nodeTable", ftable)
	end
end

function menu.getAccountWarningText()
	if menu.hq ~= 0 then
		local container = ConvertStringTo64Bit(tostring(menu.hq))
		local money, productionmoney = GetComponentData(container, "money", "productionmoney")
		local supplymoney = tonumber(C.GetSupplyBudget(container)) / 100
		local trademoney = tonumber(C.GetTradeWareBudget(container)) / 100
		local budget = math.floor(productionmoney + supplymoney + trademoney)

		if money < budget then
			if money == 0 then
				return ReadText(1001, 8465)
			else
				return ReadText(1001, 8466)
			end
		end
	end
	return ""
end

function menu.getAccountWarningColor()
	if menu.hq ~= 0 then
		local container = ConvertStringTo64Bit(tostring(menu.hq))
		local money, productionmoney = GetComponentData(container, "money", "productionmoney")
		local supplymoney = tonumber(C.GetSupplyBudget(container)) / 100
		local trademoney = tonumber(C.GetTradeWareBudget(container)) / 100
		local budget = math.floor(productionmoney + supplymoney + trademoney)

		if money < budget then
			if money == 0 then
				return Color["text_error"]
			else
				return Color["text_warning"]
			end
		end
	end
	return Color["text_normal"]
end

function menu.onFlowchartNodeCollapsed(node, frame)
	if menu.expandedNode == node and menu.expandedMenuFrame == frame then
		local data = node.customdata
		local collapseHandler = data.collapseHandler
		if collapseHandler then
			collapseHandler(data)
		end
		Helper.clearFrame(menu, config.expandedMenuFrameLayer)
		menu.expandedMenuTable = nil
		menu.expandedMenuFrame = nil
		menu.expandedNode = nil
	end
end

function menu.createTopLevel(frame)
	menu.topLevelOffsetY = Helper.createTopLevelTab(menu, "research", frame, "", nil, true)
end

function menu.onTabScroll(direction)
	if direction == "right" then
		Helper.scrollTopLevel(menu, "research", 1)
	elseif direction == "left" then
		Helper.scrollTopLevel(menu, "research", -1)
	end
end

function menu.onInputModeChanged(_, mode)
	menu.display()
end

-- widget scripts

function menu.buttonStartResearch(techdata)
	if menu.availableresearchmodule then
		menu.currentResearch[techdata.tech] = menu.availableresearchmodule
		C.StartResearch(techdata.tech, menu.availableresearchmodule)
		menu.availableresearchmodule = nil

		menu.restoreNodeTech = techdata.tech
		menu.updateExpandedNode()
		menu.refresh = getElapsedTime()
	end
end

function menu.buttonCancelResearch(techdata)
	if menu.currentResearch[techdata.tech] then
		C.ClearProductionItems(menu.currentResearch[techdata.tech])
		menu.currentResearch[techdata.tech] = nil

		menu.restoreNodeTech = techdata.tech
		menu.updateExpandedNode()
		menu.refresh = getElapsedTime()
	end
end

function menu.buttonRightBar(newmenu, params)
	Helper.closeMenuAndOpenNewMenu(menu, newmenu, params, true)
	menu.cleanup()
end

function menu.buttonAccountConfirm()
	if menu.hq ~= 0 then
		local container = ConvertStringTo64Bit(tostring(menu.hq))
		if menu.newAccountValue then
			local stationmoney, productionmoney = GetComponentData(container, "money", "productionmoney")
			local supplymoney = tonumber(C.GetSupplyBudget(container)) / 100
			local tradewaremoney = tonumber(C.GetTradeWareBudget(container)) / 100
			local estimate = productionmoney + supplymoney + tradewaremoney
			local amount = menu.newAccountValue - stationmoney

			SetMaxBudget(container, (menu.newAccountValue * 3) / 2)
			SetMinBudget(container, menu.newAccountValue)
		
			if amount > 0 then
				TransferPlayerMoneyTo(amount, container)
			else
				TransferMoneyToPlayer(-amount, container)
			end

			local shownmax = math.max(menu.newAccountValue, estimate)
			if amount > 0 then
				menu.expandedNode:updateMaxValue(shownmax)
			end
			menu.expandedNode:updateValue(menu.newAccountValue)
			if amount < 0 then
				menu.expandedNode:updateMaxValue(shownmax)
			end
			menu.newAccountValue = nil
			menu.refreshnode = getElapsedTime() + 0.1
		end
	end
end

function menu.buttonAccountToEstimate()
	if menu.hq ~= 0 then
		local container = ConvertStringTo64Bit(tostring(menu.hq))
		local stationmoney, productionmoney = GetComponentData(container, "money", "productionmoney")
		local supplymoney = tonumber(C.GetSupplyBudget(container)) / 100
		local tradewaremoney = tonumber(C.GetTradeWareBudget(container)) / 100
		local estimate = productionmoney + supplymoney + tradewaremoney
		local amount = estimate - stationmoney

		SetMaxBudget(container, (estimate * 3) / 2)
		SetMinBudget(container, estimate)

		if amount > 0 then
			TransferPlayerMoneyTo(amount, container)
		else
			TransferMoneyToPlayer(-amount, container)
		end

		menu.expandedNode:updateValue(estimate)
		menu.expandedNode:updateMaxValue(estimate)
		menu.newAccountValue = nil
		menu.refreshnode = getElapsedTime() + 0.1
	end
end

function menu.slidercellAccount(_, value)
	if value then
		menu.newAccountValue = value
	end
end

menu.updateInterval = 0.1

-- hook to update the menu while it is being displayed
function menu.onUpdate()
	local curtime = getElapsedTime()
	if next(menu.currentResearch) then
		for tech, module in pairs(menu.currentResearch) do
			local proddata = GetProductionModuleData(ConvertStringTo64Bit(tostring(module)))
			if proddata.state == "empty" then
				menu.currentResearch[tech] = nil
				menu.restoreNodeTech = tech
				menu.checkResearch = tech
				menu.refresh = curtime + 2.0
			end
		end
	end

	if menu.refresh and (menu.refresh <= curtime) then
		menu.refresh = nil
		menu.saveFlowchartState("flowchart", menu.flowchart)
		if menu.expandedNode then
			menu.expandedNode:collapse()
		end
		menu.display()
		return
	end

	if menu.restoreNode and menu.restoreNode.id then
		menu.restoreNode:expand()
		menu.restoreNode = nil
	end

	if menu.refreshnode and (menu.refreshnode < curtime) then
		menu.refreshnode = nil
		menu.updateExpandedNode()
	end

	if menu.accountnode then
		menu.updateAccountNode(menu.accountnode)
	end

	-- 1 second updates are enough for frame content
	if (not menu.frameUpdateTimer) or (menu.frameUpdateTimer < curtime) then
		menu.frameUpdateTimer = curtime + 1
		menu.frame:update()
		if menu.expandedMenuFrame then
			menu.expandedMenuFrame:update()
		end
	end
end

function menu.updateAccountNode(node)
	if menu.hq ~= 0 then
		local container = ConvertStringTo64Bit(tostring(menu.hq))
		local money, productionmoney = GetComponentData(container, "money", "productionmoney")
		local supplymoney = tonumber(C.GetSupplyBudget(container)) / 100
		local tradewaremoney = tonumber(C.GetTradeWareBudget(container)) / 100
		local budget = math.floor(productionmoney + supplymoney + tradewaremoney)

		local shownamount = money
		local shownmax = math.max(shownamount, budget)

		if shownamount ~= node.properties.value then
			menu.refreshnode = getElapsedTime()
		end
		if shownmax < node.properties.value then
			node:updateValue(shownamount)
		end
		node:updateMaxValue(shownmax)
		node:updateValue(shownamount)

		local statustext = string.format("%s/%s %s", ConvertMoneyString(money, false, true, 3, true, false), ConvertMoneyString(productionmoney + supplymoney + tradewaremoney, false, true, 3, true, false), ReadText(1001, 101))
		local statuscolor = (money < budget) and ((money == 0) and Color["lso_node_error"] or Color["lso_node_warning"]) or Color["flowchart_node_default"]
		node:updateStatus(statustext)
		node:updateOutlineColor(statuscolor)
	end
end

function menu.onColChanged(row, col)
end

-- hook if the highlighted row is selected
function menu.onSelectElement(table, modified)
end

-- hook if the menu is being closed
function menu.onCloseElement(dueToClose, layer)
	if layer == config.expandedMenuFrameLayer then
		menu.expandedNode:collapse()
		return
	end

	if dueToClose == "back" then
		if Helper.checkDiscardStationEditorChanges(menu) then
			return
		end
	end

	Helper.closeMenu(menu, dueToClose)
	menu.cleanup()
end

function menu.findTech(ftable, tech)
	for i, mainentry in ipairs(menu.techtree) do
		for col, columnentry in ipairs(mainentry) do
			for j, techentry in ipairs(columnentry) do
				if techentry.tech == tech then
					return i, col, j
				end
			end
		end
	end
end

function menu.precursorSorter(a, b)
	local aIdx = a.mainIdx or 0
	local bIdx = b.mainIdx or 0
	return aIdx > bIdx
end

function menu.isResearchAvailable(tech, mainIdx, col)
	if menu.availableresearchmodule then
		if col > 1 then
			for _, techentry in ipairs(menu.techtree[mainIdx][col - 1]) do
				if not techentry.completed then
					return false
				end
			end
		end
		return true
	end
	return false
end

function menu.sortTechName(a, b)
	local aname = GetWareData(a.tech, "name")
	local bname = GetWareData(b.tech, "name")

	return aname < bname
end

function menu.updateExpandedNode()
	local node = menu.expandedNode
	node:collapse()
	node:expand()
end

-- helpers to maintain row/column states while frame is re-created
function menu.saveFlowchartState(name, flowchart)
	menu.topRows[name], menu.firstCols[name] = GetFlowchartFirstVisibleCell(flowchart.id)
	menu.selectedRows[name], menu.selectedCols[name] = GetFlowchartSelectedCell(flowchart.id)
end

function menu.restoreFlowchartState(name, flowchart)
	flowchart.properties.firstVisibleRow = menu.topRows[name] or 1
	flowchart.properties.firstVisibleCol = menu.firstCols[name] or 1
	menu.topRows[name] = nil
	menu.firstCols[name] = nil
	flowchart.properties.selectedRow = menu.selectedRows[name] or 1
	flowchart.properties.selectedCol = menu.selectedCols[name] or 1
	menu.selectedRows[name] = nil
	menu.selectedCols[name] = nil
end

function menu.saveTableState(name, ftable, row, col)
	menu.topRows[name] = GetTopRow(ftable.id)
	menu.selectedRows[name] = row or Helper.currentTableRow[ftable.id]
	menu.selectedCols[name] = col or Helper.currentTableCol[ftable.id]
end

function menu.restoreTableState(name, ftable)
	ftable:setTopRow(menu.topRows[name])
	ftable:setSelectedRow(menu.selectedRows[name])
	ftable:setSelectedCol(menu.selectedCols[name] or 0)

	menu.topRows[name] = nil
	menu.selectedRows[name] = nil
	menu.selectedCols[name] = nil
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
