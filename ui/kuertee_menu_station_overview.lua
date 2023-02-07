local ffi = require ("ffi")
local C = ffi.C
local Lib = require ("extensions.sn_mod_support_apis.lua_interface").Library
local stationOverviewMenu = Lib.Get_Egosoft_Menu ("StationOverviewMenu")
local menu = stationOverviewMenu
local oldFuncs = {}
local newFuncs = {}
local callbacks = {}
local isInited
local function init ()
	-- DebugError ("kuertee_menu_station_overview.init")
	if not isInited then
		isInited = true
		stationOverviewMenu = Lib.Get_Egosoft_Menu ("StationOverviewMenu")
		stationOverviewMenu.registerCallback = newFuncs.registerCallback
		-- rewrites:
		oldFuncs.cleanup = stationOverviewMenu.cleanup
		stationOverviewMenu.cleanup = newFuncs.cleanup
		oldFuncs.setupFlowchartData = stationOverviewMenu.setupFlowchartData
		stationOverviewMenu.setupFlowchartData = newFuncs.setupFlowchartData
		oldFuncs.onExpandTradeWares = stationOverviewMenu.onExpandTradeWares
		stationOverviewMenu.onExpandTradeWares = newFuncs.onExpandTradeWares
	end
end
function newFuncs.registerCallback (callbackName, callbackFunction)
	-- note 1: format is generally [function name]_[action]. e.g.: in kuertee_menu_transporter, "display_on_set_room_active" overrides the room's active property with the return of the callback.
	-- note 2: events have the word "_on_" followed by a PRESET TENSE verb. e.g.: in kuertee_menu_transporter, "display_on_set_buttontable" is called after all of the rows of buttontable are set.
	-- note 3: new callbacks can be added or existing callbacks can be edited. but commit your additions/changes to the mod's GIT repository.
	-- note 4: search for the callback names to see where they are executed.
	-- note 5: if a callback requires a return value, return it in an object var. e.g. "display_on_set_room_active" requires a return of {active = true | false}.
	-- available callbacks:
	-- cleanup ()
	-- setupFlowchartData_on_start ()
	-- setupFlowchartData_pre_trade_wares_button(remainingcargonodes)
	-- onExpandTradeWares_on_start()
	-- onExpandTradeWares_insert_ware_to_allwares(allwares, ware)
	--
	if callbacks [callbackName] == nil then
		callbacks [callbackName] = {}
	end
	table.insert (callbacks [callbackName], callbackFunction)
end
-- just copy the whole config - but ensure that all references to "menu." is correct.
local config = {
	mainFrameLayer = 5,
	expandedMenuFrameLayer = 4,
	contextFrameLayer = 2,
	nodeoffsetx = 30,
	nodewidth = 270,
	dronetypes = { 
		{ type = "transport",	name = ReadText(1001, 7104),	autoname = ReadText(1001, 4207) },
		{ type = "defence",		name = ReadText(1001, 1310),	autoname = ReadText(1001, 4216) },
		{ type = "repair",		name = ReadText(1001, 3000),	autoname = ReadText(1001, 4232) },
		{ type = "build",		name = ReadText(1001, 7833),	autoname = ReadText(1001, 4233) },
	},
	missilestypes = {
		{ type = "missile",		name = ReadText(1001, 1304),	autoname = ReadText(1001, 4234) },
	},
	graph = {
		maxshowndata = 4,
		numdatapoints = 21,
		factors = { 0.2, 0.5, 1, 2, 5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000, 50000, 100000, 200000, 500000, 1000000, 2000000, 5000000, 10000000, 20000000, 50000000, 100000000 },
		datarecordcolors = {
			[1] = { buy = { r = 253, g =  91, b =  91, a = 100 }, buyhex = "\27#FFFD5B5B#", sell = { r = 252, g = 171, b =  92, a = 100 }, sellhex = "\27#FFFCAB5C#" },
			[2] = { buy = { r =  85, g = 172, b =   0, a = 100 }, buyhex = "\27#FF55AC00#", sell = { r = 180, g = 250, b = 200, a = 100 }, sellhex = "\27#FFB4FAC8#" },
			[3] = { buy = { r =   0, g = 175, b = 180, a = 100 }, buyhex = "\27#FF00AFB4#", sell = { r =  91, g = 133, b = 253, a = 100 }, sellhex = "\27#FF5B85FD#" },
			[4] = { buy = { r = 171, g =  91, b = 253, a = 100 }, buyhex = "\27#FFAB5BFD#", sell = { r = 253, g =  91, b = 213, a = 100 }, sellhex = "\27#FFFD5BD5#" }
		},
		point = {
			type = "square",
			size = 8,
			highlightSize = 8,
		},
		line = {
			type = "normal",
			size = 2,
			highlightSize = 4,
		},
	},
}
function newFuncs.cleanup()
	oldFuncs.cleanup()

	-- kuertee start: callback
	if callbacks ["cleanup"] then
		for _, callback in ipairs (callbacks ["cleanup"]) do
			callback ()
		end
	end
	-- kuertee end: callback
end
local function addFlowchartEdge(node1, node2)
	if not node1 or not node2 then DebugError(TraceBack()) end
	node2.predecessors = node2.predecessors or { }
	node2.predecessors[node1] = (node1.type == "solid" and 3 or (node1.type == "liquid" and 2 or 1))
end
function newFuncs.setupFlowchartData()
	-- kuertee start: callback
	if callbacks ["setupFlowchartData_on_start"] then
		for _, callback in ipairs (callbacks ["setupFlowchartData_on_start"]) do
			callback ()
		end
	end
	-- kuertee end: callback

	local nodes, warenodes, workforcenode, researchnode, terraformingnode = menu.getFlowchartProductionNodes()

	-- assign numrows and numcols
	for _, node in ipairs(nodes) do
		local nummodules = #node
		if nummodules > 1 then
			node.numrows = nummodules - 1			-- n-1 production modules
			node.numcols = 2						-- 1 storage module
		end
	end

	-- enable shuffle for testing more random inputs
	--local shuffle = true
	if shuffle then
		for i = 1, #nodes - 1 do
			local rnd = math.random(i, #nodes)
			nodes[i], nodes[rnd] = nodes[rnd], nodes[i]
		end
		local str = ""
		for _, node in ipairs(nodes) do
			str = str .. node.text .. ", "
		end
		print(str)
	end

	-- separate all nodes that are connected to workforce via edges
	local workforcenodes = { }
	if workforcenode then
		-- repeated two-step process to find workforce-related nodes - necessary since we only know a node's predecessors, not its successors
		workforcenode.workforceRelated = true
		local processingqueue = { workforcenode }
		while #processingqueue > 0 do
			-- mark all nodes in the queue and their ancestors as workforce-related
			while #processingqueue > 0 do
				local node = table.remove(processingqueue, 1)
				if node.predecessors then
					for predecessor, _ in pairs(node.predecessors) do
						if not predecessor.workforceRelated then
							predecessor.workforceRelated = true
							table.insert(processingqueue, predecessor)
						end
					end
				end
			end
			-- fill queue with unmarked successors of marked nodes
			for _, node in ipairs(nodes) do
				if not node.workforceRelated and node.predecessors then
					for predecessor, _ in pairs(node.predecessors) do
						if predecessor.workforceRelated then
							node.workforceRelated = true
							table.insert(processingqueue, node)
							break
						end
					end
				end
			end
		end
		-- move workforce-related nodes to other table
		for nodeidx = #nodes, 1, -1 do
			local node = nodes[nodeidx]
			if node.workforceRelated then
				table.remove(nodes, nodeidx)
				table.insert(workforcenodes, 1, node)
			end
		end
	end

	-- separate all nodes that are connected to research via edges
	local researchnodes = { }
	if researchnode then
		-- repeated two-step process to find research-related nodes - necessary since we only know a node's predecessors, not its successors
		researchnode.researchRelated = true
		local processingqueue = { researchnode }
		while #processingqueue > 0 do
			-- mark all nodes in the queue and their ancestors as research-related
			while #processingqueue > 0 do
				local node = table.remove(processingqueue, 1)
				if node.predecessors then
					for predecessor, _ in pairs(node.predecessors) do
						if not predecessor.researchRelated then
							predecessor.researchRelated = true
							table.insert(processingqueue, predecessor)
						end
					end
				end
			end
			-- fill queue with unmarked successors of marked nodes
			for _, node in ipairs(nodes) do
				if not node.researchRelated and node.predecessors then
					for predecessor, _ in pairs(node.predecessors) do
						if predecessor.researchRelated then
							node.researchRelated = true
							table.insert(processingqueue, node)
							break
						end
					end
				end
			end
		end
		-- move research-related nodes to other table
		for nodeidx = #nodes, 1, -1 do
			local node = nodes[nodeidx]
			if node.researchRelated then
				table.remove(nodes, nodeidx)
				table.insert(researchnodes, 1, node)
			end
		end
	end

	-- separate all nodes that are connected to terraforming via edges
	local terraformingnodes = { }
	if terraformingnode then
		-- repeated two-step process to find terraforming-related nodes - necessary since we only know a node's predecessors, not its successors
		terraformingnode.terraformingRelated = true
		local processingqueue = { terraformingnode }
		while #processingqueue > 0 do
			-- mark all nodes in the queue and their ancestors as terraforming-related
			while #processingqueue > 0 do
				local node = table.remove(processingqueue, 1)
				if node.predecessors then
					for predecessor, _ in pairs(node.predecessors) do
						if not predecessor.terraformingRelated then
							predecessor.terraformingRelated = true
							table.insert(processingqueue, predecessor)
						end
					end
				end
			end
			-- fill queue with unmarked successors of marked nodes
			for _, node in ipairs(nodes) do
				if not node.terraformingRelated and node.predecessors then
					for predecessor, _ in pairs(node.predecessors) do
						if predecessor.terraformingRelated then
							node.terraformingRelated = true
							table.insert(processingqueue, node)
							break
						end
					end
				end
			end
		end
		-- move terraforming-related nodes to other table
		for nodeidx = #nodes, 1, -1 do
			local node = nodes[nodeidx]
			if node.terraformingRelated then
				table.remove(nodes, nodeidx)
				table.insert(terraformingnodes, 1, node)
			end
		end
	end

	local flowchartsections = { }
	if #nodes > 0 then
		local numrows, numcols, junctions = Helper.setupDAGLayout(nodes)
		table.insert(flowchartsections, { nodes = nodes, junctions = junctions, numrows = numrows, numcols = numcols })
	end
	if #researchnodes > 0 then
		local numrows, numcols, junctions = Helper.setupDAGLayout(researchnodes)
		table.insert(flowchartsections, { nodes = researchnodes, junctions = junctions, numrows = numrows, numcols = numcols })
	end
	if #terraformingnodes > 0 then
		local numrows, numcols, junctions = Helper.setupDAGLayout(terraformingnodes)
		table.insert(flowchartsections, { nodes = terraformingnodes, junctions = junctions, numrows = numrows, numcols = numcols })
	end
	if #workforcenodes > 0 then
		local numrows, numcols, junctions = Helper.setupDAGLayout(workforcenodes)
		table.insert(flowchartsections, { nodes = workforcenodes, junctions = junctions, numrows = numrows, numcols = numcols })
	end
	-- if one of the two production sections has a production module that doesn't require resources (e.g. Energy Cells production),
	-- the production module is located in the very first column and the associated storage module in the second column (in same node with numcols = 2).
	-- Within the same section, all storage modules in the first tier will be right-aligned and end up in the second column,
	-- but for all other sections in the flowchart we have to do this manually, so there are no storage modules in the first column.
	menu.startwithproduction = false
	for _, section in ipairs(flowchartsections) do
		for _, node in ipairs(section.nodes) do
			if node.col == 1 then
				local nummodules = #node
				if nummodules > 1 then
					section.startswithproduction = true
					menu.startwithproduction = true
					break
				end
			end
		end
	end

	-- protectyon section
	local condensateware = "condensate"
	local transporttype = GetWareData(condensateware, "transport")
	local sector = GetComponentData(menu.containerid, "sectorid")
	local sectorcontainsthewave = GetComponentData(sector, "containsthewave")
	local hascondensatestorage = false
	if C.IsComponentClass(menu.container, "container") then
		hascondensatestorage = CheckSuitableTransportType(menu.containerid, condensateware)
	end
	if #menu.constructionplan > 0 then
		local found = false
		for i = 1, #menu.constructionplan do
			local entry = menu.constructionplan[i]
			if IsMacroClass(entry.macro, "storage") then
				local data = GetLibraryEntry("moduletypes_storage", entry.macro)
				if data.storagetags[transporttype] then
					found = true
					break
				end
			end
		end
		if not found then
			hascondensatestorage = false
		end
	end

	if sectorcontainsthewave and hascondensatestorage then
		local condensatenodes = {}
		local production_products =	C.IsInfoUnlockedForPlayer(menu.container, "production_products")

		-- add condensate shield node
		local condensateshieldnode = {
			condensateshield = condensateware,
			text = Helper.unlockInfo(production_products, ReadText(20104, 92501)),
			type = transporttype,
			row = 1, col = 2, numrows = 1, numcols = 1,
			{
				properties = {
					value = 0,
					max = 0,
					shape = "hexagon",
				},
				expandedTableNumColumns = 2,
				expandHandler = menu.onExpandCondensateShield,
			}
		}
		table.insert(condensatenodes, condensateshieldnode)

		-- add condensate storage node
		local node = Helper.createLSOStorageNode(menu, menu.container, condensateware, false, true, true)
		table.insert(condensatenodes, node)
		warenodes[condensateware] = node
		addFlowchartEdge(node, condensateshieldnode)

		table.insert(flowchartsections, { nodes = condensatenodes, junctions = { }, numrows = 1, numcols = 2 })
	end

	-- supply section
	local nodes = {}
	-- Add drone node
	local unitstoragedata = (menu.container and C.IsComponentClass(menu.container, "container")) and GetUnitStorageData(menu.containerid) or nil
	local unitinfo_capacity =	C.IsInfoUnlockedForPlayer(menu.container, "units_capacity")
	local unitinfo_amount =		C.IsInfoUnlockedForPlayer(menu.container, "units_amount")

	local supplynodecount = 0
	local dronesnode, missilesnode
	if unitstoragedata then
		local shownamount = unitinfo_amount and unitstoragedata.stored or 0
		local shownmax = unitinfo_capacity and math.max(shownamount, unitstoragedata.capacity) or shownamount
		dronesnode = {
			drones = true,
			text = Helper.unlockInfo(unitinfo_capacity, ReadText(1001, 8)),
			type = "container",
			row = 1, col = 2, numrows = 1, numcols = 1,
			{
				properties = {
					value = function () local data = GetUnitStorageData(menu.containerid); return unitinfo_amount and data.stored or 0 end,
					max = shownmax,
					shape = "hexagon",
				},
				expandedTableNumColumns = 3,
				expandHandler = menu.onExpandSupply,
				collapseHandler = menu.onCollapseSupply,
			}
		}
		dronesnode[1].statusText = function () local data = GetUnitStorageData(menu.containerid); return string.format("%s/%s", Helper.unlockInfo(unitinfo_amount, data.stored), Helper.unlockInfo(unitinfo_capacity, unitstoragedata.capacity)) end
		table.insert(nodes, dronesnode)
		supplynodecount = supplynodecount + 1
	end

	-- Add missile node
	local missilecapacity = GetComponentData(menu.containerid, "missilecapacity") or 0
	if missilecapacity > 0 then
		local defenceinfo_low =		C.IsInfoUnlockedForPlayer(menu.container, "defence_level")
		local defenceinfo_high =	C.IsInfoUnlockedForPlayer(menu.container, "defence_status")
		local total = 0
		local n = C.GetNumAllMissiles(menu.container)
		local buf = ffi.new("AmmoData[?]", n)
		n = C.GetAllMissiles(buf, n, menu.container)
		for j = 0, n - 1 do
			total = total + buf[j].amount
		end

		local shownamount = defenceinfo_high and total or 0
		local shownmax = defenceinfo_low and math.max(shownamount, missilecapacity) or shownamount
		missilesnode = {
			missiles = true,
			text = Helper.unlockInfo(defenceinfo_low, ReadText(1001, 2800)),
			type = "container",
			row = #nodes + 1, col = 2, numrows = 1, numcols = 1,
			{
				properties = {
					value = function () return menu.getMissileAmount(defenceinfo_high) end,
					max = shownmax,
					shape = "hexagon",
				},
				expandedTableNumColumns = 3,
				expandHandler = menu.onExpandSupply,
				collapseHandler = menu.onCollapseSupply,
			}
		}
		missilesnode[1].statusText = function () return string.format("%s/%s", Helper.unlockInfo(defenceinfo_high, menu.getMissileAmount(defenceinfo_high)), Helper.unlockInfo(defenceinfo_low, shownmax)) end
		table.insert(nodes, missilesnode)
		supplynodecount = supplynodecount + 1
	end

	-- supply resources
	local supplyresources = {}
	local n = C.GetNumSupplyOrderResources(menu.container)
	menu.numSupplyResources = n
	local buf = ffi.new("SupplyResourceInfo[?]", n)
	n = C.GetSupplyOrderResources(buf, n, menu.container)
	for i = 0, n - 1 do
		local ware = ffi.string(buf[i].ware)
		local total = buf[i].total
		local current = buf[i].current
		table.insert(supplyresources, { ware = ware, name = GetWareData(ware, "name"), max = total, value = current, supplytypes = ffi.string(buf[i].supplytypes) })
	end
	table.sort(supplyresources, Helper.sortName)
	
	local storageinfo_warelist =	C.IsInfoUnlockedForPlayer(menu.container, "storage_warelist")
	for i, entry in ipairs(supplyresources) do
		local hasrestrictions = C.GetContainerTradeRuleID(menu.container, "supply", entry.ware) > 0

		local warenode = {
			ware = entry.ware,
			text = Helper.unlockInfo(storageinfo_warelist, entry.name),
			type = transporttype,
			row = i, col = 1, numrows = 1, numcols = 1,
			{
				properties = {
					value = entry.value,
					max = math.max(entry.value, entry.max),
				},
				issupplyresource = true,
				expandedTableNumColumns = 3,
				expandHandler = menu.onExpandSupplyResource,
				statuscolor = hasrestrictions and Helper.color.warningorange or nil,
				statusIcon = hasrestrictions and "lso_error" or nil,
			}
		}
		table.insert(nodes, warenode)

		for supplytype in string.gmatch(entry.supplytypes, "%a+") do
			if dronesnode and (supplytype == "unit") then
				addFlowchartEdge(warenode, dronesnode)
			elseif missilesnode and (supplytype == "missile") then
				addFlowchartEdge(warenode, missilesnode)
			end
		end
	end

	table.insert(flowchartsections, { nodes = nodes, junctions = { }, numrows = math.max(#supplyresources, supplynodecount), numcols = 2 })

	-- add account section
	if C.IsComponentClass(menu.container, "container") and GetComponentData(menu.containerid, "isplayerowned") then
		local nodes = {}
		local money, productionmoney = GetComponentData(menu.containerid, "money", "productionmoney")
		local supplymoney = tonumber(C.GetSupplyBudget(menu.container)) / 100
		local tradewaremoney = tonumber(C.GetTradeWareBudget(menu.container)) / 100
		local budget = productionmoney + supplymoney + tradewaremoney

		local shownamount = money
		local shownmax = math.max(shownamount, budget)
		local accountnode = {
			account = true,
			text = ReadText(1001, 7710),
			type = "container",
			row = #nodes + 1, col = 1, numrows = 1, numcols = 1,
			{
				properties = {
					value = shownamount,
					max = shownmax,
				},
				expandedTableNumColumns = 2,
				expandHandler = menu.onExpandAccount,
				statusText = string.format("%s/%s %s", ConvertMoneyString(money, false, true, 3, true, false), ConvertMoneyString(productionmoney + supplymoney + tradewaremoney, false, true, 3, true, false), ReadText(1001, 101))
			}
		}
		table.insert(nodes, accountnode)
		table.insert(flowchartsections, { nodes = nodes, junctions = { }, numrows = #nodes, numcols = 1 })
	end

	-- Add non-production section
	local storageinfo_amounts =		C.IsInfoUnlockedForPlayer(menu.container, "storage_amounts")
	local storageinfo_capacity =	C.IsInfoUnlockedForPlayer(menu.container, "storage_capacity")
	local storageinfo_warelist =	C.IsInfoUnlockedForPlayer(menu.container, "storage_warelist")

	local cargo, tradewares, isplayerowned, resources = GetComponentData(menu.containerid, "cargo", "tradewares", "isplayerowned", "pureresources")
	local cargoandtrade = {}
	for ware, amount in pairs(cargo) do
		if (amount > 0) and (not warenodes[ware]) then
			cargoandtrade[ware] = amount
		end
	end
	for _, ware in ipairs(tradewares) do
		if (not cargoandtrade[ware]) and (not warenodes[ware]) then
			cargoandtrade[ware] = 0 -- assuming 0 due to no entry in cargo
		end
	end
	for _, ware in ipairs(resources) do
		if (not cargoandtrade[ware]) and (not warenodes[ware]) then
			cargoandtrade[ware] = 0 -- assuming 0 due to no entry in cargo
		end
	end

	local remainingcargonodes = { }
	for ware, amount in pairs(cargoandtrade) do
		local transporttype = GetWareData(ware, "transport")
		local hasstorage = true -- ware is in the current cargo list
		if #menu.constructionplan > 0 then
			local found = false
			for i = 1, #menu.constructionplan do
				local entry = menu.constructionplan[i]
				if IsMacroClass(entry.macro, "storage") then
					local data = GetLibraryEntry("moduletypes_storage", entry.macro)
					if data.storagetags[transporttype] then
						found = true
						break
					end
				end
			end
			if not found then
				hasstorage = false
			end
		end

		local node = Helper.createLSOStorageNode(menu, menu.container, ware, false, hasstorage, true)
		table.insert(remainingcargonodes, node)
	end
	-- sort to get a consistent result
	table.sort(remainingcargonodes, function (a, b) return a.text < b.text end)
	if isplayerowned and C.IsComponentClass(menu.container, "container") then
		-- kuertee start: callback
		if callbacks ["setupFlowchartData_pre_trade_wares_button"] then
			for _, callback in ipairs (callbacks ["setupFlowchartData_pre_trade_wares_button"]) do
				callback (remainingcargonodes)
			end
		end
		-- kuertee end: callback

		-- add trade wares option
		local node = {
			cargo = true,
			text = ReadText(1001, 6900),
			row = 1,
			col = 1,
			numrows = 1,
			numcols = 1,
			{
				properties = {
				},
				expandedFrameNumTables = 2,
				expandedTableNumColumns = 3,
				expandHandler = menu.onExpandTradeWares,
			}
		}
		table.insert(remainingcargonodes, node)
	end

	-- add flowchart section with all remaining wares
	if #remainingcargonodes > 0 then
		for nodeidx, node in ipairs(remainingcargonodes) do
			node.row = nodeidx
		end
		table.insert(flowchartsections, { nodes = remainingcargonodes, junctions = { }, numrows = #remainingcargonodes, numcols = 1 })
	end

	-- Merge all sections into a single flowchart
	local numrows = 0
	local numcols = 0
	local allnodes = { }
	local alljunctions = { }

	local startrow = 1
	for _, section in ipairs(flowchartsections) do
		local startcol = (menu.startwithproduction and not section.startswithproduction) and 2 or 1
		for _, node in ipairs(section.nodes) do
			node.row = node.row + startrow - 1
			node.col = node.col + startcol - 1
			table.insert(allnodes, node)
		end
		for _, junction in ipairs(section.junctions) do
			junction.row = junction.row + startrow - 1
			junction.col = junction.col + startcol - 1
			table.insert(alljunctions, junction)
		end
		numrows = startrow + section.numrows - 1
		numcols = math.max(numcols, section.numcols + startcol - 1)
		startrow = numrows + 2
	end

	menu.flowchartNumRows = numrows
	menu.flowchartNumCols = numcols
	menu.flowchartNodes = allnodes
	menu.flowchartJunctions = alljunctions
end
function newFuncs.onExpandTradeWares(frame, ftable, ftable2, nodedata)
	ftable:setColWidth(1, Helper.scaleY(Helper.standardButtonHeight), false)
	ftable:setColWidthPercent(3, 50)
	ftable2:setColWidth(1, Helper.scaleY(Helper.standardButtonHeight), false)
	ftable2:setColWidthPercent(3, 50)

	-- kuertee start: callback
	if callbacks ["onExpandTradeWares_on_start"] then
		for _, callback in ipairs (callbacks ["onExpandTradeWares_on_start"]) do
			callback ()
		end
	end
	-- kuertee end: callback

	local excludedwares = {}, {}
	menu.selectedWares, menu.origSelectedWares = {}, {}
	local allresources, allproducts, cargo, rawtradewares = GetComponentData(menu.containerid, "allresources", "products", "cargo", "tradewares")
	for _, ware in ipairs(allresources) do
		excludedwares[ware] = true
	end
	for _, ware in ipairs(allproducts) do
		excludedwares[ware] = true
	end
	for ware in pairs(cargo) do
		excludedwares[ware] = true
	end
	for _, ware in ipairs(rawtradewares) do
		menu.origSelectedWares[ware] = true
		menu.selectedWares[ware] = true
	end

	local allwares = {}
	local n = C.GetNumWares("economy", false, "", "")
	local buf = ffi.new("const char*[?]", n)
	n = C.GetWares(buf, n, "economy", false, "", "")
	for i = 0, n - 1 do
		local ware = ffi.string(buf[i])
		if not excludedwares[ware] then

			-- kuertee start: callback
			-- table.insert(allwares, { ware = ware, name = GetWareData(ware, "name") })
			if callbacks ["onExpandTradeWares_insert_ware_to_allwares"] then
				for _, callback in ipairs (callbacks ["onExpandTradeWares_insert_ware_to_allwares"]) do
					callback (allwares, ware)
				end
			end
			-- kuertee end: callback

		end
	end
	table.sort(allwares, Helper.sortName)

	for _, entry in ipairs(allwares) do
		local row = ftable:addRow(true, { bgColor = Helper.color.transparent })
		row[1]:createCheckBox(menu.selectedWares[entry.ware], { width = Helper.standardButtonHeight, height = Helper.standardButtonHeight })
		row[1].handlers.onClick = function (_, checked) if checked then menu.selectedWares[entry.ware] = true else menu.selectedWares[entry.ware] = nil end end
		row[2]:setColSpan(2):createText(entry.name)
	end
	local row = ftable2:addRow(true, { bgColor = Helper.color.transparent })
	row[1]:setColSpan(2):createButton({ active = function () return not menu.compareTradeWareSelection() end }):setText(ReadText(1001, 2821), { halign = "center" })
	row[1].handlers.onClick = menu.setTradeWares
	row[3]:createButton({  }):setText(ReadText(1001, 64), { halign = "center" })
	row[3].handlers.onClick = function () return menu.expandedNode:collapse() end

	local buttontableheight = ftable2:getFullHeight()
	local maxVisibleHeight = ftable:getFullHeight()
	if maxVisibleHeight + buttontableheight + Helper.borderSize > frame.properties.height then
		maxVisibleHeight = frame.properties.height - buttontableheight - Helper.borderSize
		ftable.properties.maxVisibleHeight = maxVisibleHeight
	end
	ftable2.properties.y = maxVisibleHeight + Helper.borderSize
end
init ()
