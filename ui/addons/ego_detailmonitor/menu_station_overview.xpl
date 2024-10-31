-- param == { 0, 0, container }

-- ffi setup
local ffi = require("ffi")
local C = ffi.C
ffi.cdef[[
	typedef uint64_t BuildTaskID;
	typedef int32_t TradeRuleID;
	typedef uint64_t UniverseID;

	typedef struct {
		const char* macro;
		const char* ware;
		uint32_t amount;
		uint32_t capacity;
	} AmmoData;
	typedef struct {
		BuildTaskID id;
		UniverseID buildingcontainer;
		UniverseID component;
		const char* macro;
		const char* factionid;
		UniverseID buildercomponent;
		int64_t price;
		bool ismissingresources;
		uint32_t queueposition;
	} BuildTaskInfo;
	typedef struct {
		const char* id;
		const char* name;
		const char* shortname;
		const char* description;
		const char* icon;
	} RaceInfo;
	typedef struct {
		int64_t trade;
		int64_t defence;
		int64_t build;
		int64_t repair;
		int64_t missile;
	} SupplyBudget;
	typedef struct {
		const char* ware;
		int total;
		int current;
		const char* supplytypes;
	} SupplyResourceInfo;
	typedef struct {
		const char* macro;
		int amount;
	} SupplyOverride;
	typedef struct {
		double time;
		int64_t money;
	} UIAccountStatData;
	typedef struct {
		const char* macro;
		const char* ware;
		const char* productionmethodid;
	} UIBlueprint;
	typedef struct {
		double time;
		uint64_t amount;
	} UICargoStatData;
	typedef struct {
		const char* wareid;
		UICargoStatData* data;
		uint32_t numdata;
	} UICargoStat;
	typedef struct {
		float x;
		float y;
		float z;
		float yaw;
		float pitch;
		float roll;
	} UIPosRot;
	typedef struct {
		const char* id;
		const char* group;
		const char* name;
		const char* description;
		double duration;
		double repeatcooldown;
		uint32_t timescompleted;
		int32_t successchance;
		bool resilient;
		bool showalways;
		int64_t price;
		float payoutfactor;
		const char* requiredresearchid;
		const char* pricescale;
		const char* pricescaletext;
		bool anypredecessor;
		uint32_t numpredecessors;
		uint32_t numpredecessorgroups;
		uint32_t numblockingprojects;
		uint32_t numconditions;
		uint32_t numprimaryeffects;
		uint32_t numsideeffects;
		uint32_t numblockedprojects;
		uint32_t numblockedgroups;
		uint32_t numrebates;
		uint32_t numresources;
		uint32_t numremovedprojects;
	} UITerraformingProject2;
	typedef struct {
		double time;
		int64_t price;
		int amount;
		int limit;
	} UITradeOfferStatData;
	typedef struct {
		const char* wareid;
		bool isSellOffer;
		UITradeOfferStatData* data;
		uint32_t numdata;
	} UITradeOfferStat;
	typedef struct {
		const char* ware;
		const char* macro;
		int amount;
	} UIWareInfo;
	typedef struct {
		const char* type;
		const char* name;
		float value;
		bool active;
	} UIWorkforceInfluence;
	typedef struct {
		uint32_t numcapacityinfluences;
		uint32_t numgrowthinfluences;
	} WorkforceInfluenceCounts;
	typedef struct {
		uint32_t numcapacityinfluences;
		UIWorkforceInfluence* capacityinfluences;
		uint32_t numgrowthinfluences;
		UIWorkforceInfluence* growthinfluences;
		float basegrowth;
		uint32_t capacity;
		uint32_t current;
		uint32_t sustainable;
		uint32_t target;
		int32_t change;
	} WorkforceInfluenceInfo;
	typedef struct {
		uint32_t current;
		uint32_t capacity;
		uint32_t optimal;
		uint32_t available;
		uint32_t maxavailable;
		double timeuntilnextupdate;
	} WorkForceInfo;

	typedef struct {
		size_t idx;
		const char* macroid;
		UniverseID componentid;
		UIPosRot offset;
		const char* connectionid;
		size_t predecessoridx;
		const char* predecessorconnectionid;
		bool isfixed;
	} UIConstructionPlanEntry;
	void AddTradeWare(UniverseID containerid, const char* wareid);
	bool AreWaresWithinContainerProductionLimits(UniverseID containerid, UIWareAmount* wares, uint32_t numwares);
	void ClearContainerBuyLimitOverride(UniverseID containerid, const char* wareid);
	void ClearContainerSellLimitOverride(UniverseID containerid, const char* wareid);
	uint32_t GetAllRaces(RaceInfo* result, uint32_t resultlen);
	uint32_t GetAmmoStorage(AmmoData* result, uint32_t resultlen, UniverseID defensibleid, const char* ammotype);
	uint32_t GetBlueprints(UIBlueprint* result, uint32_t resultlen, const char* set, const char* category, const char* macroname);
	size_t GetBuildMapConstructionPlan(UniverseID holomapid, UniverseID defensibleid, bool usestoredplan, UIConstructionPlanEntry* result, uint32_t resultlen);
	uint32_t GetBuildModules(UniverseID* result, uint32_t resultlen, UniverseID containerid);
	double GetBuildProcessorEstimatedTimeLeft(UniverseID buildprocessorid);
	uint32_t GetBuildTasks(BuildTaskInfo* result, uint32_t resultlen, UniverseID containerid, UniverseID buildmoduleid, bool isinprogress, bool includeupgrade);
	uint32_t GetCargoStatistics(UICargoStat* result, uint32_t resultlen, size_t numdatapoints);
	float GetContainerBuildPriceFactor(UniverseID containerid);
	uint32_t GetContainerBuildResources(const char** result, uint32_t resultlen, UniverseID containerid);
	TradeRuleID GetContainerTradeRuleID(UniverseID containerid, const char* ruletype, const char* wareid);
	double GetContainerWareConsumptionPerProduct(UniverseID containerid, const char* wareid, const char* productid, bool ignorestate);
	double GetContainerWareProduction(UniverseID containerid, const char* wareid, bool ignorestate);
	void GetContainerWorkforceInfluence(WorkforceInfluenceInfo* result, UniverseID containerid, const char* raceid);
	float GetCurrentBuildProgress(UniverseID containerid);
	double GetCurrentGameTime(void);
	uint32_t GetNPCAccountStatistics(UIAccountStatData* result, size_t resultlen, UniverseID entityid, double starttime, double endtime);
	uint32_t GetNumAllRaces(void);
	uint32_t GetNumAmmoStorage(UniverseID defensibleid, const char* ammotype);
	uint32_t GetNumBlueprints(const char* set, const char* category, const char* macroname);
	size_t GetNumBuildMapConstructionPlan(UniverseID holomapid, bool usestoredplan);
	uint32_t GetNumBuildModules(UniverseID containerid);
	uint32_t GetNumBuildTasks(UniverseID containerid, UniverseID buildmoduleid, bool isinprogress, bool includeupgrade);
	uint32_t GetNumCargoStatistics(UniverseID containerorspaceid, double starttime, double endtime, size_t numdatapoints);
	uint32_t GetNumContainerBuildResources(UniverseID containerid);
	WorkforceInfluenceCounts GetNumContainerWorkforceInfluence(UniverseID containerid, const char* raceid, bool force);
	size_t GetNumPlannedStationModules(UniverseID defensibleid, bool includeall);
	uint32_t GetNumRemovedConstructionPlanModules2(UniverseID holomapid, UniverseID defensibleid, uint32_t* newIndex, bool usestoredplan, uint32_t* numChangedIndices, bool checkupgrades);
	uint32_t GetNumRemovedStationModules2(UniverseID defensibleid, uint32_t* newIndex, uint32_t* numChangedIndices, bool checkupgrades);
	uint32_t GetNumResearchModules(UniverseID containerid);
	uint32_t GetNumStationModules(UniverseID stationid, bool includeconstructions, bool includewrecks);
	uint32_t GetNumStationOverviewGraphWares(UniverseID stationid, bool* initialized);
	uint32_t GetNumSupplyOrderResources(UniverseID containerid);
	uint32_t GetNumSupplyOrders(UniverseID containerid, bool defaultorders);
	uint32_t GetNumTerraformingProjects(UniverseID clusterid, bool useevents);
	uint32_t GetNumTradeOfferStatistics(UniverseID containerorspaceid, double starttime, double endtime, size_t numdatapoints);
	size_t GetPlannedStationModules(UIConstructionPlanEntry* result, uint32_t resultlen, UniverseID defensibleid, bool includeall);
	uint32_t GetRemovedConstructionPlanModules2(UniverseID* result, uint32_t resultlen, uint32_t* changedIndices, uint32_t* numChangedIndices);
	uint32_t GetRemovedStationModules2(UniverseID* result, uint32_t resultlen, uint32_t* changedIndices, uint32_t* numChangedIndices);
	uint32_t GetResearchModules(UniverseID* result, uint32_t resultlen, UniverseID containerid);
	uint32_t GetStationModules(UniverseID* result, uint32_t resultlen, UniverseID stationid, bool includeconstructions, bool includewrecks);
	uint32_t GetStationOverviewGraphWares(const char** result, uint32_t resultlen, UniverseID stationid);
	int64_t GetSupplyBudget(UniverseID containerid);
	uint32_t GetSupplyOrderResources(SupplyResourceInfo* result, uint32_t resultlen, UniverseID containerid);
	uint32_t GetSupplyOrders(SupplyOverride* result, uint32_t resultlen, UniverseID containerid, bool defaultorders);
	const char* GetTerraformingActiveProject(UniverseID clusterid);
	uint32_t GetTerraformingProjects2(UITerraformingProject2* result, uint32_t resultlen, UniverseID clusterid, bool useevents);
	uint32_t GetTradeOfferStatistics(UITradeOfferStat* result, uint32_t resultlen, size_t numdatapoints);
	int64_t GetTradeWareBudget(UniverseID containerid);
	WorkForceInfo GetWorkForceInfo(UniverseID containerid, const char* raceid);
	bool HasContainerOwnTradeRule(UniverseID containerid, const char* ruletype, const char* wareid);
	bool HasEntityMoneyLogEntries(UniverseID entityid);
	bool IsComponentOperational(UniverseID componentid);
	bool IsContainerAmmoMacroCompatible(UniverseID containerid, const char* ammomacroname);
	bool IsHQ(UniverseID componentid);
	bool IsNextStartAnimationSkipped(bool reset);
	bool IsRealComponentClass(UniverseID componentid, const char* classname);
	bool IsSupplyManual(UniverseID containerid, const char* type);
	void PauseProductionModule(UniverseID productionmoduleid, bool pause);
	void PauseProcessingModule(UniverseID processingmoduleid, bool pause);
	void RemoveTradeWare(UniverseID containerid, const char* wareid);
	void SetContainerBuildPriceFactor(UniverseID containerid, float value);
	void SetContainerTradeRule(UniverseID containerid, TradeRuleID id, const char* ruletype, const char* wareid, bool value);
	void SetContainerWareIsBuyable(UniverseID containerid, const char* wareid, bool allowed);
	void SetContainerWareIsSellable(UniverseID containerid, const char* wareid, bool allowed);
	void SetContainerWorkforceFillCapacity(UniverseID containerid, bool value);
	bool SetStationOverviewGraphWare(UniverseID stationid, const char* wareid, bool value);
	void SetSupplyManual(UniverseID containerid, const char* type, bool onoff);
	bool ShouldContainerFillWorkforceCapacity(UniverseID containerid);
	void UpdateProductionTradeOffers(UniverseID containerid);
	void UpdateSupplyOverrides(UniverseID containerid, SupplyOverride* overrides, uint32_t numoverrides);
]]

local utf8 = require("utf8")

local menu = {
	name = "StationOverviewMenu",
	graphmode = "tradeofferprices",
	extendedGroups = {},
	showSingleProduction = {},
	showGraph = false,
}

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
			[1] = { buy = Color["graph_data_1"], sell = Color["graph_data_2"] },
			[2] = { buy = Color["graph_data_3"], sell = Color["graph_data_4"] },
			[3] = { buy = Color["graph_data_5"], sell = Color["graph_data_6"] },
			[4] = { buy = Color["graph_data_7"], sell = Color["graph_data_8"] },
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

-- kuertee start:
local callbacks = {}
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
	menu.loadModLuas()
	-- DebugError("uix load success: " .. tostring(debug.getinfo(1).source))
end
-- kuertee end

-- cleanup variables in menu, no need for the menu variable to keep all the data while the menu is not active
function menu.cleanup()
	menu.title = nil
	menu.container = nil
	menu.containerid = nil
	menu.frame = nil
	menu.flowchart = nil
	menu.keyTable = nil
	menu.expandedNode = nil
	menu.expandedMenuFrame = nil
	if menu.wareReservationRegistered then
		UnregisterEvent("newWareReservation", menu.newWareReservationCallback)
		menu.wareReservationRegistered = nil
	end
	if menu.supplyUpdateRegistered then
		UnregisterEvent("supplyUpdate", menu.supplyUpdate)
		menu.supplyUpdateRegistered = nil
	end
	menu.expandedMenuTable = nil
	menu.noupdate = nil

	menu.restoreNode = nil
	menu.restoreNodeWare = nil
	menu.restoreNodeSupply = nil
	menu.restoreNodeSupplyWare = nil
	menu.restoreNodeBuildModule = nil

	menu.constructionplan = {}
	menu.newModulesIndex = nil
	menu.removedModules = {}
	menu.displayedgraphwares = {}
	menu.graphwaresinit = nil
	menu.productionnodes = { }
	menu.researchnodes = {}
	menu.showSingleProduction = {}
	menu.terraformingnodes = {}

	menu.topRows = {}
	menu.firstCols = {}
	menu.selectedRows = {}
	menu.selectedRowData = {}
	menu.selectedCols = {}

	-- kuertee start: callback
	if callbacks ["cleanup"] then
		for _, callback in ipairs (callbacks ["cleanup"]) do
			callback ()
		end
	end
	-- kuertee end: callback
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
	menu.selectedRowData[name] = nil
	menu.selectedCols[name] = nil
end

function menu.saveTableState(name, ftable, row, col)
	menu.topRows[name] = GetTopRow(ftable.id)
	menu.selectedRows[name] = row or Helper.currentTableRow[ftable.id]
	menu.selectedRowData[name] = menu.rowDataMap[ftable.id] and menu.rowDataMap[ftable.id][menu.selectedRows[name]]
	menu.selectedCols[name] = col or Helper.currentTableCol[ftable.id]
end

function menu.restoreTableState(name, ftable)
	ftable:setTopRow(menu.topRows[name])
	ftable:setSelectedRow(menu.selectedRows[name])
	ftable:setSelectedCol(menu.selectedCols[name] or 0)

	menu.topRows[name] = nil
	menu.selectedRows[name] = nil
	menu.selectedRowData[name] = nil
	menu.selectedCols[name] = nil
end

-- Menu member functions

function menu.onShowMenu(state)
	menu.containerid = menu.param[3]
	menu.container = ConvertIDTo64Bit(menu.containerid)
	menu.displayedgraphwares = {}

	-- kuertee start: callback
	if callbacks ["onShowMenu_start"] then
		for _, callback in ipairs (callbacks ["onShowMenu_start"]) do
			callback (menu.container)
		end
	end
	-- kuertee end: callback

	menu.isdummy = false
	if not menu.container then
		menu.isdummy = true
		menu.containerid = GetPlayerContextByClass("container")
		menu.container = ConvertIDTo64Bit(menu.containerid)
	else
		local boolbuf = ffi.new("bool[1]", 0)
		local n = C.GetNumStationOverviewGraphWares(menu.container, boolbuf)
		menu.graphwaresinit = boolbuf[0]
		if n > 0 then
			local buf = ffi.new("const char*[?]", n)
			n = C.GetStationOverviewGraphWares(buf, n, menu.container)
			for i = 0, n - 1 do
				local ware = ffi.string(buf[i])
				menu.displayedgraphwares[ware] = true
			end
		end
	end

	menu.title = ReadText(1001, 7903)

	menu.topRows = {}
	menu.firstCols = {}
	menu.selectedRows = {}
	menu.selectedRowData = {}
	menu.selectedCols = {}

	menu.numshowndata = 0
	menu.showndata = {}

	-- trade rules
	Helper.updateTradeRules()

	-- flowchart init
	menu.setupFlowchartData()

	-- graph init
	if not menu.graphmode then
		menu.graphmode = "tradeofferprices"
	end
	local curtime = C.GetCurrentGameTime()
	menu.timeframe = "hour"
	menu.xStart = math.max(0, curtime - 3600)
	menu.xEnd = curtime
	menu.xGranularity = 300
	if menu.xEnd > menu.xStart then
		while (menu.xEnd - menu.xStart) < menu.xGranularity do
			menu.xGranularity = menu.xGranularity / 2
		end
	end
	menu.xScale = 60
	menu.xTitle = ReadText(1001, 6519) .. " [" .. ReadText(1001, 103) .. "]"
	menu.yTitle = ReadText(1001, 6520) .. " [" .. ReadText(1001, 101) .. "]"

	menu.getData(config.graph.numdatapoints)

	if state then
		menu.onRestoreState(state)
	end

	menu.display()
end

function menu.onShowMenuSound()
	if not C.IsNextStartAnimationSkipped(false) then
		PlaySound("ui_config_station_open")
	else
		PlaySound("ui_menu_changed")
	end
end

function menu.onSaveState()
	local state = {}

	if menu.expandedNode and menu.expandedNode.customdata and menu.expandedNode.customdata.nodedata then
		if menu.expandedNode.customdata.nodedata[1].isstorage then
			state.restoreNodeWare = menu.expandedNode.customdata.nodedata.ware
		elseif menu.expandedNode.customdata.nodedata[1].issupplyresource then
			state.restoreNodeSupplyWare = menu.expandedNode.customdata.nodedata.ware
		elseif menu.expandedNode.customdata.nodedata[1].buildmodule then
			state.restoreNodeBuildModule = menu.expandedNode.customdata.nodedata[1].buildmodule
		elseif menu.expandedNode.customdata.nodedata.drones then
			state.restoreNodeSupply = "drones"
		elseif menu.expandedNode.customdata.nodedata.missiles then
			state.restoreNodeSupply = "missiles"
		end
	end

	state.flowchartTopRow, state.flowchartFirstCol = GetFlowchartFirstVisibleCell(menu.flowchart.id)
	state.flowchartSelectedRow, state.flowchartSelectedCol = GetFlowchartSelectedCell(menu.flowchart.id)

	return state
end

function menu.onRestoreState(state)
	menu.restoreNodeWare = state.restoreNodeWare
	menu.restoreNodeSupplyWare = state.restoreNodeSupplyWare
	menu.restoreNodeBuildModule = ConvertIDTo64Bit(state.restoreNodeBuildModule)
	menu.restoreNodeSupply = state.restoreNodeSupply

	menu.topRows.flowchart, menu.firstCols.flowchart = state.flowchartTopRow, state.flowchartFirstCol
	menu.selectedRows.flowchart, menu.selectedCols.flowchart = state.flowchartSelectedRow, state.flowchartSelectedCol
end

local function addFlowchartWareNode(nodes, warenodes, productiondata)
	if not warenodes[productiondata.ware] then
		local transporttype = GetWareData(productiondata.ware, "transport")
		local planned = false
		local hasstorage = false
		if C.IsComponentClass(menu.container, "container") then
			hasstorage = CheckSuitableTransportType(menu.containerid, productiondata.ware)
		end
		if hasstorage then
			if #menu.constructionplan > 0 then
				local found = false
				for i = 1, #menu.constructionplan do
					local entry = menu.constructionplan[i]
					if IsMacroClass(entry.macro, "storage") then
						local data = GetLibraryEntry("moduletypes_storage", entry.macro)
						if data.storagetags[transporttype] then
							if menu.changedModulesIndices[i] then
								planned = true
							end
							found = true
							break
						end
					end
				end
				if not found then
					hasstorage = false
				end
			end
		else
			if #menu.constructionplan > 0 then
				for i = menu.newModulesIndex, #menu.constructionplan do
					if menu.changedModulesIndices[i] then
						local entry = menu.constructionplan[i]
						if IsMacroClass(entry.macro, "storage") then
							local data = GetLibraryEntry("moduletypes_storage", entry.macro)
							if data.storagetags[transporttype] then
								planned = true
								hasstorage = true
								break
							end
						end
					end
				end
			end
		end

		local warenode = Helper.createLSOStorageNode(menu, menu.container, productiondata.ware, planned, hasstorage)
		table.insert(nodes, warenode)
		warenodes[productiondata.ware] = warenode
	end
	return warenodes[productiondata.ware]
end

local function addFlowchartEdge(node1, node2)
	if not node1 or not node2 then DebugError(TraceBack()) end
	node2.predecessors = node2.predecessors or { }
	node2.predecessors[node1] = (node1.type == "solid" and 3 or (node1.type == "liquid" and 2 or 1))
end

function menu.getFlowchartProductionNodes()
	if menu.isdummy then
		return menu.getFlowchartDummyProductionNodes()
	end

	local nodes = { }
	local warenodes = { }

	local workforcevisible =			C.IsInfoUnlockedForPlayer(menu.container, "efficiency_amount")
	local productioninfo_resources =	C.IsInfoUnlockedForPlayer(menu.container, "production_resources")

	local buildmodules = {}
	Helper.ffiVLA(buildmodules, "UniverseID", C.GetNumBuildModules, C.GetBuildModules, menu.container)
	for i, buildmodule in ipairs(buildmodules) do
		local docksizes = GetComponentData(ConvertStringToLuaID(tostring(buildmodule)), "docksizes")
		local buildclass = "ship_s"
		if docksizes.docks_xl > 0 then
			buildclass = "ship_xl"
		elseif docksizes.docks_l > 0 then
			buildclass = "ship_l"
		elseif docksizes.docks_m > 0 then
			buildclass = "ship_m"
		end
		buildmodules[i] = { component = buildmodule, class = buildclass }
	end
	table.sort(buildmodules, Helper.sortClass)

	local buildresources = {}
	local n = C.GetNumContainerBuildResources(menu.container)
	local buf = ffi.new("const char*[?]", n)
	n = C.GetContainerBuildResources(buf, n, menu.container)
	for i = 0, n - 1 do
		buildresources[ffi.string(buf[i])] = true
	end

	-- analyse construction plan (if any)
	menu.constructionplan = {}
	menu.newModulesIndex = 0
	menu.removedModules = {}
	if GetComponentData(menu.containerid, "isplayerowned") then
		local n = C.GetNumBuildMapConstructionPlan(0, true)
		local buf = ffi.new("UIConstructionPlanEntry[?]", n)
		n = tonumber(C.GetBuildMapConstructionPlan(0, menu.container, true, buf, n))
		for i = 0, n - 1 do
			local entry = {}
			entry.idx                   = buf[i].idx
			entry.macro                 = ffi.string(buf[i].macroid)
			entry.component             = buf[i].componentid
			entry.offset                = buf[i].offset
			entry.connection            = ffi.string(buf[i].connectionid)
			entry.predecessoridx        = buf[i].predecessoridx
			entry.predecessorconnection = ffi.string(buf[i].predecessorconnectionid)

			table.insert(menu.constructionplan, entry)
		end
		if #menu.constructionplan > 0 then
			menu.changedModulesIndices = {}
			local newIndex = ffi.new("uint32_t[1]", 0)
			local numChangedIndices = ffi.new("uint32_t[1]", 0)
			local n = C.GetNumRemovedConstructionPlanModules2(0, menu.container, newIndex, true, numChangedIndices, false)
			menu.newModulesIndex = tonumber(newIndex[0]) + 1
			local buf = ffi.new("UniverseID[?]", n)
			local changedIndicesBuf = ffi.new("uint32_t[?]", numChangedIndices[0])
			n = tonumber(C.GetRemovedConstructionPlanModules2(buf, n, changedIndicesBuf, numChangedIndices))
			if n > 0 then
				for i = 0, n - 1 do
					local compID = ConvertStringTo64Bit(tostring(buf[i]))
					menu.removedModules[tostring(compID)] = true
				end
			end
			if numChangedIndices[0] > 0 then
				for i = 0, numChangedIndices[0] - 1 do
					menu.changedModulesIndices[changedIndicesBuf[i]] = true
				end
			end
		else
			local n = C.GetNumPlannedStationModules(menu.container, true)
			local buf = ffi.new("UIConstructionPlanEntry[?]", n)
			n = C.GetPlannedStationModules(buf, n, menu.container, true)
			for i = 0, tonumber(n) - 1 do
				local entry = {}
				entry.idx                   = buf[i].idx
				entry.macro                 = ffi.string(buf[i].macroid)
				entry.component             = buf[i].componentid
				entry.offset                = buf[i].offset
				entry.connection            = ffi.string(buf[i].connectionid)
				entry.predecessoridx        = buf[i].predecessoridx
				entry.predecessorconnection = ffi.string(buf[i].predecessorconnectionid)

				table.insert(menu.constructionplan, entry)
			end

			menu.changedModulesIndices = {}
			local newIndex = ffi.new("uint32_t[1]", 0)
			local numChangedIndices = ffi.new("uint32_t[1]", 0)
			local n = C.GetNumRemovedStationModules2(menu.container, newIndex, numChangedIndices, false)
			menu.newModulesIndex = tonumber(newIndex[0]) + 1
			local buf = ffi.new("UniverseID[?]", n)
			local changedIndicesBuf = ffi.new("uint32_t[?]", numChangedIndices[0])
			n = tonumber(C.GetRemovedStationModules2(buf, n, changedIndicesBuf, numChangedIndices))
			if n > 0 then
				for i = 0, n - 1 do
					local compID = ConvertStringTo64Bit(tostring(buf[i]))
					menu.removedModules[tostring(compID)] = true
				end
			end
			if numChangedIndices[0] > 0 then
				for i = 0, numChangedIndices[0] - 1 do
					menu.changedModulesIndices[changedIndicesBuf[i]] = true
				end
			end
		end
	end

	local productionmoduledata = {}
	-- production modules and processing modules (normal, wrecked and in construction)
	local n = C.GetNumStationModules(menu.container, true, true)
	local buf = ffi.new("UniverseID[?]", n)
	n = C.GetStationModules(buf, n, menu.container, true, true)
	for i = 0, n - 1 do
		local module = ConvertStringTo64Bit(tostring(buf[i]))
		local component, destroyedcomponent
		local isproduction = C.IsRealComponentClass(module, "production")
		local isprocessingmodule = C.IsRealComponentClass(module, "processingmodule")
		if isproduction or isprocessingmodule then
			if not C.IsComponentOperational(module) then
				if C.IsComponentWrecked(module) then
					destroyedcomponent = module
				elseif menu.removedModules[tostring(module)] then
					component = module
				end
			else
				component = module
			end
		end
		if component or destroyedcomponent then
			local macro = GetComponentData(module, "macro")
			--print("existing: " .. macro)
			if productionmoduledata[macro] then
				if component then
					table.insert(productionmoduledata[macro].components, component)
				elseif destroyedcomponent then
					table.insert(productionmoduledata[macro].destroyedcomponents, destroyedcomponent)
				end
			else
				if component then
					productionmoduledata[macro] = { macro = macro, components = { component }, destroyedcomponents = {}, numplanned = 0, isprocessingmodule = isprocessingmodule }
				elseif destroyedcomponent then
					productionmoduledata[macro] = { macro = macro, components = {}, destroyedcomponents = { destroyedcomponent }, numplanned = 0, isprocessingmodule = isprocessingmodule }
				end
			end
		end
	end
	-- go through all new modules
	if #menu.constructionplan > 0 then
		for i = menu.newModulesIndex, #menu.constructionplan do
			if menu.changedModulesIndices[i] then
				local entry = menu.constructionplan[i]
				if (entry.component == 0) or IsComponentConstruction(ConvertStringTo64Bit(tostring(entry.component))) then
					local isproduction = IsMacroClass(entry.macro, "production")
					local isprocessingmodule = IsMacroClass(entry.macro, "processingmodule")
					if isproduction or isprocessingmodule then
						if productionmoduledata[entry.macro] then
							local skip = false
							if entry.component ~= 0 then
								for _, destroyedcomponent in ipairs(productionmoduledata[entry.macro].destroyedcomponents) do
									if destroyedcomponent == entry.component then
										skip = true
										break
									end
								end
							end
							if not skip then
								--print("new: " .. entry.macro)
								productionmoduledata[entry.macro].numplanned = productionmoduledata[entry.macro].numplanned + 1
							end
						else
							--print("new: " .. entry.macro)
							productionmoduledata[entry.macro] = { macro = entry.macro, components = {}, destroyedcomponents = {}, numplanned = 1, isprocessingmodule = isprocessingmodule }
						end
					end
				end
			end
		end
	end

	local cargo = GetComponentData(menu.containerid, "cargo")

	for macro, data in pairs(productionmoduledata) do
		local macrodata = GetLibraryEntry(GetMacroData(macro, "infolibrary"), macro)
		for _, productdata in ipairs(macrodata.products) do
			productdata.cycletime = productdata.cycle
			productdata.cycle = productdata.amount
			productdata.amount = cargo[productdata.ware] or 0
			local warenode = addFlowchartWareNode(nodes, warenodes, productdata)
			local resources = { }
			local productresources = productdata.resources
			-- link from resource ware nodes to the product ware node (note: ignoring secondary resources)
			for i, resourcedata in ipairs(productresources) do
				resourcedata.name = GetWareData(resourcedata.ware, "name")
				resourcedata.cycletime = resourcedata.cycle
				resourcedata.cycle = resourcedata.amount
				resourcedata.amount = cargo[resourcedata.ware] or 0
				local resourcenode = addFlowchartWareNode(nodes, warenodes, resourcedata)
				addFlowchartEdge(resourcenode, warenode)
				resources[resourcedata.ware] = true
			end
			local modulenode = {
				productionmodules = data,
				properties = {
					shape = "stadium",
					helpOverlayID = "station_overview_production_" .. productdata.ware,
					helpOverlayText = " ",
					helpOverlayHighlightOnly = true,
					uiTriggerID = "production_" .. productdata.ware,
				},
				resources = resources,
				expandedTableNumColumns = 3,
				expandHandler = data.isprocessingmodule and menu.onExpandProcessing or menu.onExpandProduction,
				-- handle colors in update function
			}
			-- insert before last element, which is the storage module
			table.insert(warenode, #warenode, modulenode)
		end
	end

	local buildmodulenodes = {}
	for _, buildmodule in ipairs(buildmodules) do
		local warenode = {
			text = Helper.unlockInfo(productioninfo_resources, ffi.string(C.GetComponentName(buildmodule.component))),
			type = "container",
			{
				buildmodule = buildmodule.component,
				properties = { shape = "stadium" },
				resources = buildresources,
				expandedTableNumColumns = 4,
				expandHandler = menu.onExpandBuildModule,
				color = menu.removedModules[tostring(ConvertStringTo64Bit(tostring(buildmodule.component)))] and Color["lso_node_removed"] or nil,
			}
		}

		table.insert(nodes, warenode)
		table.insert(buildmodulenodes, warenode)
	end

	-- destroyed build modules
	local n = C.GetNumStationModules(menu.container, false, true)
	local buf = ffi.new("UniverseID[?]", n)
	n = C.GetStationModules(buf, n, menu.container, false, true)
	for i = 0, n - 1 do
		local module = ConvertStringTo64Bit(tostring(buf[i]))
		if not C.IsComponentOperational(module) then
			if C.IsRealComponentClass(module, "buildmodule") then
				local macro = GetComponentData(module, "macro")
				local data = GetLibraryEntry("moduletypes_build", macro)
				for _, waredata in ipairs(data.buildresources) do
					buildresources[waredata.ware] = true
				end

				local warenode = {
					text = Helper.unlockInfo(productioninfo_resources, data.name),
					type = "container",
					{
						buildmodule = { module, macro },
						properties = { shape = "stadium" },
						resources = buildresources,
						expandHandler = menu.onExpandDestroyedModule,
						color = Color["lso_node_inactive"],
						textcolor = Color["lso_node_error"],
						statuscolor = Color["lso_node_error"],
						statusIcon = "lso_warning",
					}
				}

				table.insert(nodes, warenode)
				table.insert(buildmodulenodes, warenode)
			end
		end
	end

	-- go through new buildmodules
	if #menu.constructionplan > 0 then
		for i = menu.newModulesIndex, #menu.constructionplan do
			if menu.changedModulesIndices[i] then
				local entry = menu.constructionplan[i]
				if (entry.component == 0) or IsComponentConstruction(ConvertStringTo64Bit(tostring(entry.component))) then
					if IsMacroClass(entry.macro, "buildmodule") then
						local data = GetLibraryEntry("moduletypes_build", entry.macro)
						for _, waredata in ipairs(data.buildresources) do
							buildresources[waredata.ware] = true
						end

						local warenode = {
							text = Helper.unlockInfo(productioninfo_resources, data.name),
							type = "container",
							{
								buildmodule = { entry.component, entry.macro },
								properties = { shape = "stadium" },
								resources = buildresources,
								expandHandler = menu.onExpandPlannedBuildModule,
								color = Color["lso_node_inactive"],
							}
						}

						table.insert(nodes, warenode)
						table.insert(buildmodulenodes, warenode)
					end
				end
			end
		end
	end

	-- buildmodule resource edges
	local cargo = GetComponentData(menu.containerid, "cargo")
	for ware in pairs(buildresources) do
		local resourcenode = addFlowchartWareNode(nodes, warenodes, { ware = ware, name = GetWareData(ware, "name"), amount = cargo[ware] })
		for _, buildmodulenode in ipairs(buildmodulenodes) do
			addFlowchartEdge(resourcenode, buildmodulenode)
		end
	end

	-- workforce
	local workforcenode = {
		workforce = true,
		text = ReadText(1001, 9415),
		type = "container",
		halign = "left",
		{
			properties = {
				shape = "hexagon",
				value = workforcevisible and function () local workforceinfo = C.GetWorkForceInfo(menu.container, ""); local total = C.ShouldContainerFillWorkforceCapacity(menu.container) and math.max(workforceinfo.optimal, workforceinfo.capacity) or workforceinfo.optimal; return (total ~= 0) and math.min(100, math.floor(workforceinfo.current / total * 100)) or 0 end or 0,
				max = 100,
				helpOverlayID = "station_overview_workforce",
				helpOverlayText = " ",
				helpOverlayHighlightOnly = true,
				uiTriggerID = "workforce",
			},
			resources = { },
			expandedTableNumColumns = 4,
			expandHandler = menu.onExpandWorkforce
		}
	}
	table.insert(nodes, workforcenode)
	local workforceraces = {}
	if C.IsComponentClass(menu.container, "container") then
		workforceraces = GetWorkForceRaceResources(menu.containerid)
	end
	if #workforceraces == 0 then
		workforcenode[1].color = Color["lso_node_inactive"]
		-- TODO: set statusIcon
		-- TODO: Handle case of workforce bonus being non-zero, but no habitation modules present
	else
		-- show workforce bonus in percent
		if workforcevisible then
			if (#GetProductionModules(menu.containerid) > 0) or GetComponentData(menu.containerid, "canequipships") then
				workforcenode[1].statusText = Helper.unlockInfo(workforcevisible, function () local workforceinfo = C.GetWorkForceInfo(menu.container, ""); return ConvertIntegerString(workforceinfo.current, true, 3, true, true) .. "/" .. ConvertIntegerString(C.ShouldContainerFillWorkforceCapacity(menu.container) and math.max(workforceinfo.optimal, workforceinfo.capacity) or workforceinfo.optimal, true, 3, true, true) end)
			end
		end
		-- link from resource ware nodes to the workforce node
		for _, racedata in ipairs(workforceraces) do
			for _, resourcedata in ipairs(racedata.resources) do
				local resourcenode = addFlowchartWareNode(nodes, warenodes, resourcedata)
				addFlowchartEdge(resourcenode, workforcenode)
				workforcenode[1].resources[resourcedata.ware] = true
			end
		end
	end

	-- research
	local researchnode
	if GetComponentData(menu.containerid, "isplayerowned") then
		local researchmodules = {}
		Helper.ffiVLA(researchmodules, "UniverseID", C.GetNumResearchModules, C.GetResearchModules, menu.container)
		for _, researchmodule in ipairs(researchmodules) do
			local researchmodule64 = ConvertStringTo64Bit(tostring(researchmodule))
			local proddata = GetProductionModuleData(researchmodule64)
			if (proddata.state == "producing") or (proddata.state == "waitingforresources") then
				researchnode = {
					research = true,
					text = ReadText(1001, 7400),
					type = "container",
					halign = "left",
					{
						researchmodule = researchmodule64,
						properties = {
							shape = "stadium",
							value = function() return Helper.round(math.max(1, GetProductionModuleData(researchmodule64).cycleprogress or 0)) end,
							max = 100,
						},
						resources = { },
						expandHandler = menu.onExpandResearch
					}
				}
				table.insert(nodes, researchnode)

				local resources = GetWareData(proddata.blueprintware, "resources")
				for _, resourcedata in ipairs(resources) do
					local resourcenode = addFlowchartWareNode(nodes, warenodes, { ware = resourcedata.ware, name = GetWareData(resourcedata.ware, "name"), amount = cargo[resourcedata.ware] or 0 })
					addFlowchartEdge(resourcenode, researchnode)
					researchnode[1].resources[resourcedata.ware] = true
				end
			end
		end
	end

	-- terraforming
	local terraformingnode
	if GetComponentData(menu.containerid, "isplayerowned") and C.IsHQ(menu.container) then
		local cluster = C.GetContextByClass(menu.container, "cluster", false)
		if GetComponentData(ConvertStringTo64Bit(tostring(cluster)), "hasterraforming") then
			local activeprojectid = ffi.string(C.GetTerraformingActiveProject(cluster))
			if activeprojectid ~= "" then
				local activeproject
				local n = C.GetNumTerraformingProjects(cluster, false)
				local buf = ffi.new("UITerraformingProject2[?]", n)
				n = C.GetTerraformingProjects2(buf, n, cluster, false)
				for i = 0, n - 1 do
					local entry = Helper.getProjectEntry(cluster, buf[i], false)
					if entry.id == activeprojectid then
						activeproject = entry
						break
					end
				end
				if activeproject ~= nil then
					terraformingnode = {
						terraforming = true,
						text = ReadText(1001, 3800),
						type = "container",
						halign = "left",
						{
							terraformingproject = { cluster = cluster, project = activeproject },
							properties = {
								shape = "stadium",
								value = function () return menu.nodevalueProject(cluster, activeproject) end,
								max = 100,
							},
							resources = { },
							expandHandler = menu.onExpandTerraforming
						}
					}
					table.insert(nodes, terraformingnode)

					for _, resourcedata in ipairs(activeproject.resources) do
						local resourcenode = addFlowchartWareNode(nodes, warenodes, { ware = resourcedata.ware, name = GetWareData(resourcedata.ware, "name"), amount = cargo[resourcedata.ware] or 0 })
						addFlowchartEdge(resourcenode, terraformingnode)
						terraformingnode[1].resources[resourcedata.ware] = true
					end
				else
					DebugError("Active terraforming project '" .. activeprojectid .. "' not found in list of projects of cluster '" .. ffi.string(C.GetComponentName(cluster)) .. "'.")
				end
			end
		end
	end

	return nodes, warenodes, workforcenode, researchnode, terraformingnode
end

function menu.updateDeliveredWares(cluster, project)
	local curtime = getElapsedTime()
	if (not menu.lastDeliveryUpdateTime) or (curtime > menu.lastDeliveryUpdateTime) then
		menu.lastDeliveryUpdateTime = curtime
		menu.deliveredwares = {}
		local buf_deliveredwares = ffi.new("UIWareInfo[?]", #project.resources)
		local num_deliveredwares = C.GetTerraformingProjectDeliveredResources(buf_deliveredwares, #project.resources, cluster, project.id)
		for i = 0, num_deliveredwares - 1 do
			menu.deliveredwares[ffi.string(buf_deliveredwares[i].ware)] = buf_deliveredwares[i].amount
		end
	end
end

function menu.nodevalueProject(cluster, project)
	local value = 0
	local scale = (#project.resources > 0) and ((project.duration == 0) and 100 or 66) or 0

	if C.HasTerraformingProjectStarted(cluster, project.id) then
		value = scale + C.GetTerraformingProjectCompletionFraction(cluster, project.id) * (100 - scale)
	else
		menu.updateDeliveredWares(cluster, project)
		local sumdeliveries, sumresources = 0, 0
		for _, entry in ipairs(project.resources) do
			local volume = GetWareData(entry.ware, "volume")
			sumresources = sumresources + entry.amount * volume
			sumdeliveries = sumdeliveries + (menu.deliveredwares[entry.ware] or 0) * volume
		end
		value = sumdeliveries / sumresources * scale
	end

	return value
end

function menu.getMissileAmount(defenceinfo_high)
	local total = 0
	local n = C.GetNumAllMissiles(menu.container)
	local buf = ffi.new("AmmoData[?]", n)
	n = C.GetAllMissiles(buf, n, menu.container)
	for j = 0, n - 1 do
		total = total + buf[j].amount
	end

	return defenceinfo_high and total or 0
end

function menu.getSupplyResourceValue(ware)
	local curtime = getElapsedTime()
	if menu.supplyResourceTimeStamp ~= curtime then
		menu.supplyResourceTimeStamp = curtime

		menu.supplyResources = {}
		local n = C.GetNumSupplyOrderResources(menu.container)
		menu.numSupplyResources = n
		local buf = ffi.new("SupplyResourceInfo[?]", n)
		n = C.GetSupplyOrderResources(buf, n, menu.container)
		for i = 0, n - 1 do
			local ware = ffi.string(buf[i].ware)
			local total = buf[i].total
			local current = buf[i].current
			menu.supplyResources[ware] = { value = current, max = total }
		end
	end

	return menu.supplyResources[ware] and menu.supplyResources[ware].value or 0
end

function menu.getSupplyResourceMax(ware, raw)
	local curtime = getElapsedTime()
	if menu.supplyResourceTimeStamp ~= curtime then
		menu.supplyResourceTimeStamp = curtime

		menu.supplyResources = {}
		local n = C.GetNumSupplyOrderResources(menu.container)
		menu.numSupplyResources = n
		local buf = ffi.new("SupplyResourceInfo[?]", n)
		n = C.GetSupplyOrderResources(buf, n, menu.container)
		for i = 0, n - 1 do
			local ware = ffi.string(buf[i].ware)
			local total = buf[i].total
			local current = buf[i].current
			menu.supplyResources[ware] = { value = current, max = total }
		end
	end
	
	if raw then
		return menu.supplyResources[ware] and menu.supplyResources[ware].max or 0
	else
		return menu.supplyResources[ware] and math.max(menu.supplyResources[ware].value, menu.supplyResources[ware].max) or 0
	end
end

function menu.setupFlowchartData()
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
	local sector, haswaveprotectionmodule = GetComponentData(menu.containerid, "sectorid", "haswaveprotectionmodule")
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

		local condensateshieldnode
		if haswaveprotectionmodule then
			local production_products =	C.IsInfoUnlockedForPlayer(menu.container, "production_products")
			-- add condensate shield node
			condensateshieldnode = {
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
		end

		-- add condensate storage node
		local node = Helper.createLSOStorageNode(menu, menu.container, condensateware, false, true, true)
		table.insert(condensatenodes, node)
		warenodes[condensateware] = node
		if condensateshieldnode then
			addFlowchartEdge(node, condensateshieldnode)
		end

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
					helpOverlayID = "station_overview_drones",
					helpOverlayText = " ",
					helpOverlayHighlightOnly = true,
					uiTriggerID = "drones",
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
				statuscolor = hasrestrictions and Color["icon_warning"] or nil,
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
		local budget = math.floor(productionmoney + supplymoney + tradewaremoney)

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
					helpOverlayID = "station_overview_tradewares",
					helpOverlayText = " ",
					helpOverlayHighlightOnly = true,
					uiTriggerID = "tradewares",
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

function menu.getFlowchartDummyProductionNodes()
	local nodeEnergy = { text = "Energy Cells", type = "container",
		{ properties = { width = 250, value = 600, max = 1000, slider1 = 450, step = 1 } }
	}
	local nodeMethane = { text = "Methane", type = "liquid",
		{ properties = { width = 250, value = 350, max = 1000, slider1 = 450, step = 1 } }
	}
	local nodeHelium = { text = "Helium", type = "liquid",
		{ properties = { width = 220, value = 10, max = 100, step = 1 } }
	}
	local nodeSilicon = { text = "Silicon", type = "solid",
		{ properties = { width = 250, value = 120, max = 200, step = 1 } }
	}
	local nodeHydrogen = { text = "Hydrogen", type = "liquid",
		{ properties = { width = 250, value = 0, max = 100, slider1 = 50, step = 1 } }
	}

	local nodeGraphene = { text = "Graphene", type = "container",
		{ properties = { shape = "stadium", width = 250 }, statusIcon = "menu_inventory" },
		{ properties = { width = 250, value = 40, max = 100, slider1 = 50, slider2 = 15, step = 1, mouseOverText = "Mouse-over test 1: With slider text", slider1MouseOverText = "Buy slider", slider2MouseOverText = "Sell slider" } }
	}
	addFlowchartEdge(nodeEnergy, nodeGraphene)
	addFlowchartEdge(nodeMethane, nodeGraphene)

	local nodeCoolant = { text = "Superfluid Coolant", type = "container",
		{ properties = { shape = "stadium", width = 250 }, statusText = "<!>", color = Color["lso_node_error"] },
		{ properties = { width = 250, value = 60, max = 100, slider1 = 75, slider2 = 100, step = 1, mouseOverText = "Mouse-over test 2: Without slider text" } }
	}
	addFlowchartEdge(nodeEnergy, nodeCoolant)
	addFlowchartEdge(nodeHelium, nodeCoolant)

	local nodeWafers = { text = "Silicon Wafers", type = "container",
		{ properties = { shape = "stadium", width = 250 }, statusIcon = "menu_inventory" },
		{ properties = { width = 250, value = 15, max = 100, slider1 = 40, slider2 = 50, step = 1, slider1MouseOverText = "Mouse-over test 3: Buy slider", slider2MouseOverText = "Mouse-over test 3: Sell slider" } }
	}
	addFlowchartEdge(nodeEnergy, nodeWafers)
	addFlowchartEdge(nodeSilicon, nodeWafers)
	addFlowchartEdge(nodeHydrogen, nodeWafers)

	local nodeAntimatter = { text = "Antimatter Cells", type = "container",
		{ properties = { shape = "stadium", width = 250 }, statusIcon = "menu_inventory", color = Color["lso_node_error"] },
		{ properties = { width = 250, value = 30, max = 100, slider2 = 45, step = 1 } }
	}
	addFlowchartEdge(nodeEnergy, nodeAntimatter)
	addFlowchartEdge(nodeHydrogen, nodeAntimatter)

	local nodeTubes = { text = "Quantum Tubes", type = "container",
		{ properties = { shape = "stadium", width = 250 }, statusIcon = "menu_inventory" },
		{ properties = { width = 250, value = 80, max = 100, slider2 = 50, step = 1 } }
	}
	addFlowchartEdge(nodeEnergy, nodeTubes)
	addFlowchartEdge(nodeGraphene, nodeTubes)
	addFlowchartEdge(nodeCoolant, nodeTubes)

	local nodeMicrochips = { text = "Microchips", type = "container",
		{ properties = { shape = "stadium", width = 250 } },
		{ properties = { width = 250, value = 25, max = 100, step = 1 } }
	}
	addFlowchartEdge(nodeEnergy, nodeMicrochips)
	addFlowchartEdge(nodeWafers, nodeMicrochips)

	local nodeClaytronics = { text = "Claytronics", type = "container",
		{ properties = { shape = "stadium", width = 250 } },
		{ properties = { width = 250, value = 10, max = 100, slider2 = 25, step = 1 } }
	}
	addFlowchartEdge(nodeEnergy, nodeClaytronics)
	addFlowchartEdge(nodeTubes, nodeClaytronics)
	addFlowchartEdge(nodeMicrochips, nodeClaytronics)
	addFlowchartEdge(nodeAntimatter, nodeClaytronics)

	-- Workforce
	local nodeMedical = { text = "Medical Supplies", type = "container",
		{ properties = { width = 250, value = 60, max = 100, slider1 = 60, step = 1 } }
	}
	local nodeFood = { text = "Food Rations", type = "container",
		{ properties = { width = 250, value = 60, max = 100, slider1 = 60, step = 1 } }
	}
	local nodeWorkforce = { workforce = true, text = "Workforce", type = "container",
		{ properties = { shape = "hexagon", width = 270, value = 66, max = 100 }, statusText = "66%" }
	}
	addFlowchartEdge(nodeMedical, nodeWorkforce)
	addFlowchartEdge(nodeFood, nodeWorkforce)

	local nodes = { nodeEnergy, nodeMethane, nodeHelium, nodeGraphene, nodeCoolant, nodeTubes, nodeSilicon, nodeHydrogen, nodeWafers, nodeAntimatter, nodeMicrochips, nodeClaytronics, nodeMedical, nodeFood, nodeWorkforce }
	for _, node in ipairs(nodes) do
		for _, modulenode in ipairs(node) do
			modulenode.expandHandler = menu.onExpandDummy
			modulenode.collapseHandler = menu.onCollapseDummy
		end
	end
	local warenodes = { }
	return nodes, warenodes, nodeWorkforce
end

function menu.display()
	--print("Displaying Menu")

	-- remove old data
	Helper.clearDataForRefresh(menu)

	local framewidth = Helper.viewWidth
	local frameheight = Helper.viewHeight
	local xoffset = 0
	local yoffset = 0

	menu.sidebarWidth = Helper.scaleX(Helper.sidebarWidth)
	menu.rightBarX = Helper.viewWidth - menu.sidebarWidth - Helper.frameBorder

	menu.frame = Helper.createFrameHandle(menu, { layer = config.mainFrameLayer, height = frameheight, width = framewidth, x = xoffset, y = yoffset })
	menu.frame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	local usablewidth = menu.frame.properties.width - 2 * Helper.frameBorder

	local ftable, row
	ftable = menu.frame:addTable(1, { tabOrder = 1, width = usablewidth, x = Helper.frameBorder })
	ftable:setDefaultCellProperties("text", { halign = "center" })

	row = ftable:addRow(false)
	row[1]:createText(menu.title, Helper.headerRow1Properties)
	row = ftable:addRow(false)

	-- row[1]:createText(menu.container and GetComponentData(menu.containerid, "name") or "Flowchart Test")
	-- kuertee start: callback
	if callbacks ["display_get_station_name_extras"] then
		local stationName = menu.container and GetComponentData(menu.containerid, "name") or "Flowchart Test"
		local extraNames = {}
		if menu.container then
			for _, callback in ipairs (callbacks ["display_get_station_name_extras"]) do
				table.insert(extraNames, callback(menu.container))
			end
			if #extraNames > 0 then
				for i, extraName in ipairs(extraNames) do
					if i == 1 then
						stationName = stationName .. " (" .. extraName
					else
						stationName = stationName .. ", " .. extraName
					end
				end
				stationName = stationName .. ")"
			end
		end
		row[1]:createText(stationName)
	else
		row[1]:createText(menu.container and GetComponentData(menu.containerid, "name") or "Flowchart Test")
	end
	-- kuertee end: callback

	--row = ftable:addRow(false)
	--row[1]:createText("Antigone Memorial")

	usablewidth = menu.rightBarX - Helper.borderSize - Helper.frameBorder 

	menu.flowchart = menu.frame:addFlowchart(menu.flowchartNumRows, menu.flowchartNumCols, { borderHeight = 3, borderColor = Color["row_background_blue"], minRowHeight = 45, minColWidth = 80, x = Helper.frameBorder, y = ftable:getVisibleHeight() + Helper.borderSize, width = usablewidth })
	menu.flowchart:setDefaultNodeProperties({
		expandedFrameLayer = config.expandedMenuFrameLayer,
		expandedTableNumColumns = 2,
		x = config.nodeoffsetx,
		width = config.nodewidth,
		statusBgIconRotating = true,
	})
	for col = 1, menu.flowchartNumCols, 1 do
		if col % 2 == (menu.startwithproduction and 1 or 0) then
			menu.flowchart:setColBackgroundColor(col, Color["row_background_blue"])
			menu.flowchart:setColumnCaption(col, ReadText(1001, 1600))
		else
			menu.flowchart:setColumnCaption(col, ReadText(1001, 1400))
		end
	end
	--menu.flowchart:setDefaultTextProperties({ fontsize = 8 })

	local containerSlotColor = Color["lso_slot_container"]
	local liquidSlotColor = Color["lso_slot_liquid"]
	local solidSlotColor = Color["lso_slot_solid"]
	local condensateSlotColor = Color["lso_slot_condensate"]
	local containerProp = { sourceSlotColor = containerSlotColor, sourceSlotRank = 1, destSlotColor = containerSlotColor, destSlotRank = 1 }
	local liquidProp = { sourceSlotColor = liquidSlotColor, sourceSlotRank = 2, destSlotColor = liquidSlotColor, destSlotRank = 2 }
	local solidProp = { sourceSlotColor = solidSlotColor, sourceSlotRank = 3, destSlotColor = solidSlotColor, destSlotRank = 3 }
	local condensateProp = { sourceSlotColor = condensateSlotColor, sourceSlotRank = 1, destSlotColor = condensateSlotColor, destSlotRank = 1 }

	menu.productionnodes = { }
	menu.processingnodes = { }
	menu.researchnodes = { }
	menu.buildnodes = { }
	menu.storagenodes = { }
	menu.supplyresourcenodes = { }
	menu.terraformingnodes = { }
	menu.accountnodes = { }

	-- Production nodes
	for _, nodedata in ipairs(menu.flowchartNodes) do
		local nummodules = #nodedata
		for moduleidx, moduledata in ipairs(nodedata) do
			local row = nodedata.row + (moduleidx == nummodules and math.floor((math.max(1, nummodules - 1) - 1) / 2) or moduleidx - 1)
			local col = nodedata.col + (moduleidx > 1 and moduleidx == nummodules and 1 or 0)
			local node = menu.flowchart:addNode(row, col, { nodedata = nodedata, moduledata = moduledata }, moduledata.properties):setText(nodedata.text)
			if moduledata.color then
				node.properties.outlineColor = moduledata.color
				node.properties.text.color = moduledata.color
				node.properties.statusColor = moduledata.color
			end
			if moduledata.textcolor then
				node.properties.text.color = moduledata.textcolor
			end
			if moduledata.statuscolor then
				node.properties.statusColor = moduledata.statuscolor
			end
			if moduledata.statusText then
				node:setStatusText(moduledata.statusText)
			elseif moduledata.statusIcon then
				node:setStatusIcon(moduledata.statusIcon)
			end
			if moduledata.expandedFrameNumTables then
				node.properties.expandedFrameNumTables = moduledata.expandedFrameNumTables
			end
			if moduledata.expandedTableNumColumns then
				node.properties.expandedTableNumColumns = moduledata.expandedTableNumColumns
			end
			if moduledata.productionmodules then
				if moduledata.productionmodules.isprocessingmodule then
					table.insert(menu.processingnodes, node)
				else
					table.insert(menu.productionnodes, node)
				end
			end
			if moduledata.researchmodule then
				table.insert(menu.researchnodes, node)
			end
			if moduledata.buildmodule then
				table.insert(menu.buildnodes, node)
				if menu.restoreNodeBuildModule and menu.restoreNodeBuildModule == moduledata.buildmodule then
					menu.restoreNode = node
					menu.restoreNodeBuildModule = nil
				end
			end
			if moduledata.terraformingproject then
				table.insert(menu.terraformingnodes, node)
			end
			if moduledata.isstorage then
				table.insert(menu.storagenodes, node)
				if menu.restoreNodeWare and menu.restoreNodeWare == nodedata.ware then
					menu.restoreNode = node
					menu.restoreNodeWare = nil
				end
			end
			if moduledata.issupplyresource then
				table.insert(menu.supplyresourcenodes, node)
				if menu.restoreNodeSupplyWare and menu.restoreNodeSupplyWare == nodedata.ware then
					menu.restoreNode = node
					menu.restoreNodeSupplyWare = nil
				end
			end
			if nodedata.account then
				table.insert(menu.accountnodes, node)
			end
			if menu.restoreNodeSupply then
				if nodedata.drones and (menu.restoreNodeSupply == "drones") then
					menu.restoreNode = node
					menu.restoreNodeSupply = nil
				elseif nodedata.missiles and (menu.restoreNodeSupply == "missiles") then
					menu.restoreNode = node
					menu.restoreNodeSupply = nil
				end
			end
			node.handlers.onExpanded = menu.onFlowchartNodeExpanded
			node.handlers.onCollapsed = menu.onFlowchartNodeCollapsed
			if moduledata.sliderHandler then
				node.handlers.onSliderChanged = function (_, slideridx, value) return moduledata.sliderHandler(node, nodedata, slideridx, value) end
			end
			moduledata.node = node
		end
		if nummodules > 1 then
			local storagenode = nodedata[nummodules].node
			for moduleidx = 1, nummodules - 1 do
				local productionnode = nodedata[moduleidx].node
				local edgecolor = nodedata[moduleidx].color
				local edge = productionnode:addEdgeTo(storagenode, nodedata.type == "solid" and solidProp or (nodedata.type == "liquid" and liquidProp or containerProp))
				if edgecolor then
					edge.properties.color = edgecolor
				end
			end
		end
	end
	for _, junctiondata in ipairs(menu.flowchartJunctions) do
		junctiondata.junction = menu.flowchart:addJunction(junctiondata.row, junctiondata.col)
	end
	-- Production edges
	for _, nodedata in ipairs(menu.flowchartNodes) do
		if nodedata.predecessors then
			for predecessor, slot in pairs(nodedata.predecessors) do
				local predecessorcell = predecessor.junction or predecessor[#predecessor].node
				if nodedata.junction then
					predecessorcell:addEdgeTo(nodedata.junction, slot == 3 and solidProp or (slot == 2 and liquidProp or containerProp))
				else
					local nummodules = math.max(1, #nodedata - 1)
					for moduleidx = 1, nummodules do
						local destnode = nodedata[moduleidx].node
						local edgevalid = true
						if nodedata[moduleidx].resources then
							-- only link from predecessorcell to destnode if predecessorcell is a required resource
							local realpredecessor = predecessor
							while realpredecessor.junction do
								realpredecessor = next(realpredecessor.predecessors)
							end
							if not nodedata[moduleidx].resources[realpredecessor.ware] then
								edgevalid = false
							end
						end
						if edgevalid then
							local edgecolor = nodedata[moduleidx].color
							local edgeProperties = slot == 3 and solidProp or (slot == 2 and liquidProp or containerProp)
							if nodedata.condensateshield then
								edgeProperties = condensateProp
							end
							local edge = predecessorcell:addEdgeTo(destnode, edgeProperties)
							if edgecolor then
								edge.properties.color = edgecolor
							end
						end
					end
				end
			end
		end
	end
	for _, junctiondata in ipairs(menu.flowchartJunctions) do
		if junctiondata.predecessors then
			for predecessor, slot in pairs(junctiondata.predecessors) do
				local predecessorcell = predecessor.junction or predecessor[#predecessor].node
				predecessorcell:addEdgeTo(junctiondata.junction, slot == 3 and solidProp or (slot == 2 and liquidProp or containerProp))
			end
		end
	end

	-- Economy statistics
	-- title table
	titletable = menu.frame:addTable(5, { tabOrder = 5, width = usablewidth, x = Helper.frameBorder, y = 0, reserveScrollBar = false, skipTabChange = true })
	local title = string.format(ReadText(1001, 6500), GetComponentData(menu.containerid, "name"))
	local titlewidth = C.GetTextWidth(title, Helper.headerRow1Font, Helper.scaleFont(Helper.headerRow1Font, Helper.headerRow1FontSize)) + 2 * (Helper.headerRow1Offsetx + Helper.borderSize)
	local checkboxwidth = Helper.scaleY(Helper.headerRow1Height) - Helper.borderSize
	titletable:setColWidth(2, checkboxwidth, false)
	titletable:setColWidth(3, titlewidth, false)
	titletable:setColWidth(4, checkboxwidth, false)

	row = titletable:addRow(false, { fixed = true })
	row[1]:setColSpan(5):createText("")
	-- title
	row = titletable:addRow(true, { fixed = true, borderBelow = false })
	row[2]:setBackgroundColSpan(2):createCheckBox(menu.showGraph, { height = checkboxwidth, scaling = false })
	row[2].handlers.onClick = menu.buttonShowGraph
	row[3]:createButton({ bgColor = Color["button_background_hidden"], height = Helper.headerRow1Height }):setText(title, { font = Helper.headerRow1Font, fontsize = Helper.headerRow1FontSize, x = Helper.headerRow1Offsetx, y = Helper.headerRow1Offsety, halign = "center" })
	row[3].handlers.onClick = menu.buttonShowGraph
	if menu.showGraph then
		row = titletable:addRow(false, { fixed = true, bgColor = Color["row_background_blue"] })
		row[1]:setColSpan(5):createText(" ", { fontsize = 1, height = 2 })
	end

	-- flowchart size
	if menu.showGraph then
		menu.flowchart.properties.maxVisibleHeight = math.floor((menu.frame:getAvailableHeight() - menu.flowchart.properties.y) / 2) - Helper.borderSize
	else
		menu.flowchart.properties.maxVisibleHeight = math.floor(menu.frame:getAvailableHeight() - menu.flowchart.properties.y) - Helper.borderSize - titletable:getFullHeight() - Helper.frameBorder
	end
	titletable.properties.y = menu.flowchart.properties.y + menu.flowchart.properties.maxVisibleHeight + Helper.borderSize

	if menu.showGraph then
		-- graph table
		local graphWidth = 4 * (usablewidth) / 5
		ftable = menu.frame:addTable(10, { tabOrder = 2, width = graphWidth, x = Helper.frameBorder, y = titletable.properties.y + titletable:getVisibleHeight() + Helper.borderSize, reserveScrollBar = false })
		for i = 2, 9 do
			ftable:setColWidthPercent(i, 7)
		end

		local storageinfo_amounts =		C.IsInfoUnlockedForPlayer(menu.container, "storage_amounts")
		local isplayerowned =			GetComponentData(menu.containerid, "isplayerowned")
		if not storageinfo_amounts then
			menu.graphmode = nil
		end
		if (menu.graphmode == "npcaccounts") and (not isplayerowned) then
			menu.graphmode = nil
		end

		-- mode buttons
		row = ftable:addRow(true, { fixed = true })
		row[2]:setColSpan(2):createButton({ active = storageinfo_amounts, bgColor = (menu.graphmode == "tradeofferprices") and Color["row_background_selected"] or Color["row_title_background"] }):setText(ReadText(1001, 6504), { halign = "center" })
		row[2].handlers.onClick = function () return menu.buttonGraphMode("tradeofferprices") end
		row[4]:setColSpan(2):createButton({ active = storageinfo_amounts, bgColor = (menu.graphmode == "tradeofferamounts") and Color["row_background_selected"] or Color["row_title_background"] }):setText(ReadText(1001, 6508), { halign = "center" })
		row[4].handlers.onClick = function () return menu.buttonGraphMode("tradeofferamounts") end
		row[6]:setColSpan(2):createButton({ active = storageinfo_amounts, bgColor = (menu.graphmode == "cargolevels") and Color["row_background_selected"] or Color["row_title_background"] }):setText(ReadText(1001, 6505), { halign = "center" })
		row[6].handlers.onClick = function () return menu.buttonGraphMode("cargolevels") end
		row[8]:setColSpan(2):createButton({ active = isplayerowned, bgColor = (menu.graphmode == "npcaccounts") and Color["row_background_selected"] or Color["row_title_background"] }):setText(ReadText(1001, 6506), { halign = "center" })
		row[8].handlers.onClick = function () return menu.buttonGraphMode("npcaccounts") end
		local buttonHeight = row:getHeight()
		-- graph cell
		row = ftable:addRow(false, { fixed = true })

		-- graph
		local graph = row[1]:setColSpan(10):createGraph({ height = menu.frame.properties.height - menu.frame:getUsedHeight() - 2 * buttonHeight - 3 * Helper.borderSize, scaling = false })

		local minY, maxY = 0, 1
		local hashighlight = false
		for i, entry in pairs(menu.showndata) do
			if menu.selectedrowdata == entry then
				hashighlight = true
				break
			end
		end
		for i, entry in pairs(menu.showndata) do
			if menu.graphmode == "cargolevels" then
				local highlight = menu.selectedrowdata == entry
				local color = config.graph.datarecordcolors[i].buy
				if hashighlight and (not highlight) then
					color.a = 50
				end
				local datarecord = graph:addDataRecord({
					markertype = config.graph.point.type,
					markersize = highlight and config.graph.point.highlightSize or config.graph.point.size,
					markercolor = color,
					linetype = config.graph.line.type,
					linewidth = highlight and config.graph.line.highlightSize or config.graph.line.size,
					linecolor = color,
					mouseOverText = menu.graphdata[entry].text,
				})

				for i, point in pairs(menu.graphdata[entry].data) do
					minY = math.min(minY, point.y)
					maxY = math.max(maxY, point.y)
					datarecord:addData((point.t - menu.xEnd) / menu.xScale, point.y, nil, nil)
				end
			elseif (menu.graphmode == "tradeofferprices") or (menu.graphmode == "tradeofferamounts") then
				if next(menu.graphdata[entry].selldata) then
					local highlight = menu.selectedrowdata == entry
					local color = config.graph.datarecordcolors[i].sell
					if hashighlight and (not highlight) then
						color.a = 50
					end
					local datarecord = graph:addDataRecord({
						markertype = config.graph.point.type,
						markersize = highlight and config.graph.point.highlightSize or config.graph.point.size,
						markercolor = color,
						linetype = config.graph.line.type,
						linewidth = highlight and config.graph.line.highlightSize or config.graph.line.size,
						linecolor = color,
						mouseOverText = ReadText(1001, 2917) .. ReadText(1001, 120) .. " " .. menu.graphdata[entry].text,
					})

					for i, point in pairs(menu.graphdata[entry].selldata) do
						minY = math.min(minY, point.y)
						maxY = math.max(maxY, point.y)
						datarecord:addData((point.t - menu.xEnd) / menu.xScale, point.y, nil, nil)
					end
				end

				if next(menu.graphdata[entry].buydata) then
					local highlight = menu.selectedrowdata == entry
					local color = config.graph.datarecordcolors[i].buy
					if hashighlight and (not highlight) then
						color.a = 50
					end
					local datarecord = graph:addDataRecord({
						markertype = config.graph.point.type,
						markersize = highlight and config.graph.point.highlightSize or config.graph.point.size,
						markercolor = color,
						linetype = config.graph.line.type,
						linewidth = highlight and config.graph.line.highlightSize or config.graph.line.size,
						linecolor = color,
						mouseOverText = ReadText(1001, 2916) .. ReadText(1001, 120) .. " " .. menu.graphdata[entry].text,
					})

					for i, point in pairs(menu.graphdata[entry].buydata) do
						minY = math.min(minY, point.y)
						maxY = math.max(maxY, point.y)
						datarecord:addData((point.t - menu.xEnd) / menu.xScale, point.y, nil, nil)
					end
				end
			elseif menu.graphmode == "npcaccounts" then
				local highlight = menu.selectedrowdata == entry
				local color = config.graph.datarecordcolors[i].buy
				if hashighlight and (not highlight) then
					color.a = 50
				end
				local datarecord = graph:addDataRecord({
					markertype = config.graph.point.type,
					markersize = highlight and config.graph.point.highlightSize or config.graph.point.size,
					markercolor = color,
					linetype = config.graph.line.type,
					linewidth = highlight and config.graph.line.highlightSize or config.graph.line.size,
					linecolor = color,
					mouseOverText = menu.graphdata[entry].text,
				})

				for i, point in pairs(menu.graphdata[entry].data) do
					minY = math.min(minY, point.y)
					maxY = math.max(maxY, point.y)
					datarecord:addData((point.t - menu.xEnd) / menu.xScale, point.y, nil, nil)
				end
			end
		end

		local mingranularity = maxY / 12
		local maxgranularity = maxY / 8
		local granularity = 0.1
		for _, factor in ipairs(config.graph.factors) do
			local testgranularity = math.ceil(mingranularity / factor) * factor
			if testgranularity >= maxgranularity then
				break;
			end
			granularity = testgranularity
		end
		maxY = (math.ceil(maxY / granularity) + 0.5) * granularity

		local xRange = (menu.xEnd - menu.xStart) / menu.xScale
		local xGranularity = Helper.round(menu.xGranularity / menu.xScale, 3)
		local xOffset = xRange % xGranularity

		graph:setXAxis({ startvalue = -xRange, endvalue = 0, granularity = xGranularity, offset = xOffset, gridcolor = Color["graph_grid"] })
		graph:setXAxisLabel(menu.xTitle, { fontsize = 9 })
		graph:setYAxis({ startvalue = 0, endvalue = maxY, granularity = granularity, offset = 0, gridcolor = Color["graph_grid"] })
		graph:setYAxisLabel(menu.yTitle, { fontsize = 9 })

		-- time interval buttons
		row = ftable:addRow(true, { fixed = true })
		row[3]:setColSpan(2):createButton({ bgColor = (menu.timeframe == "hour") and Color["row_background_selected"] or Color["row_title_background"] }):setText(ReadText(1001, 6501), { halign = "center" })
		row[3].handlers.onClick = function () return menu.buttonTimeFrame("hour") end
		row[5]:setColSpan(2):createButton({ bgColor = (menu.timeframe == "day") and Color["row_background_selected"] or Color["row_title_background"] }):setText(ReadText(1001, 6502), { halign = "center" })
		row[5].handlers.onClick = function () return menu.buttonTimeFrame("day") end
		row[7]:setColSpan(2):createButton({ bgColor = (menu.timeframe == "week") and Color["row_background_selected"] or Color["row_title_background"] }):setText(ReadText(1001, 6503), { halign = "center" })
		row[7].handlers.onClick = function () return menu.buttonTimeFrame("week") end

		-- key table
		menu.keyTable = menu.frame:addTable(5, { tabOrder = 3, width = usablewidth - graphWidth - Helper.borderSize, x = Helper.frameBorder + graphWidth + Helper.borderSize, y = titletable.properties.y + titletable:getVisibleHeight() + Helper.borderSize })
		menu.keyTable:setColWidth(1, Helper.standardTextHeight)
		menu.keyTable:setColWidthPercent(3, 30)
		menu.keyTable:setColWidth(4, 1.5 * Helper.standardTextHeight)
		menu.keyTable:setColWidth(5, Helper.standardTextHeight)
		-- keys
		row = menu.keyTable:addRow(false, {  })
		row[1]:setColSpan(5):createText(ReadText(1001, 6523), Helper.subHeaderTextProperties)
		row[1].properties.halign = "center"
		for i = 1, config.graph.maxshowndata do
			local entry = menu.showndata[i]
			local color1 = config.graph.datarecordcolors[i].sell
			local color2 = config.graph.datarecordcolors[i].buy
			local data = menu.graphdata[entry]
			if entry then
				if (menu.graphmode == "cargolevels") or (menu.graphmode == "npcaccounts") then
					row = menu.keyTable:addRow(entry, {  })
					row[1]:setColSpan(3):createText(data.text, { minRowHeight = 2 * Helper.standardTextHeight + Helper.borderSize })
					row[4]:createText(Helper.convertColorToText(config.graph.datarecordcolors[i].buy) .. "\27[solid]", { y = Helper.borderSize / 2 })
					row[5]:createButton({ height = 2 * Helper.standardTextHeight + Helper.borderSize }):setText("X", { halign = "center" })
					row[5].handlers.onClick = function () return menu.checkboxSelected(entry, row.index, 0) end
				elseif (menu.graphmode == "tradeofferprices") or (menu.graphmode == "tradeofferamounts") then
					row = menu.keyTable:addRow(entry, {  })
					row[1]:setColSpan(2):createText(data.text, { minRowHeight = 2 * Helper.standardTextHeight + Helper.borderSize })
					row[3]:createText(ReadText(1001, 8309) .. ReadText(1001, 120) .. "\n" .. ReadText(1001, 8308) .. ReadText(1001, 120))
					row[4]:createText(Helper.convertColorToText(config.graph.datarecordcolors[i].buy) .. "\27[solid]\n" .. Helper.convertColorToText(config.graph.datarecordcolors[i].sell) .. "\27[solid]", { y = Helper.borderSize })
					row[5]:createButton({ height = 2 * Helper.standardTextHeight + Helper.borderSize }):setText("X", { halign = "center" })
					row[5].handlers.onClick = function () return menu.checkboxSelected(entry, row.index, 0) end
				end
			else
				row = menu.keyTable:addRow(false, {  })
				row[1]:setColSpan(5):createText("---", { minRowHeight = 2 * Helper.standardTextHeight + Helper.borderSize })
			end
		end
		-- data
		local row = menu.keyTable:addRow(false, {  })
		row[1]:setColSpan(5):createText(ReadText(1001, 6507), Helper.subHeaderTextProperties)
		row[1].properties.halign = "center"
		if storageinfo_amounts and ((menu.graphmode ~= "npcaccounts") or isplayerowned) then
			if menu.graphmode then
				if #menu.graphdata > 0 then
					--[[ No ware groups in X4 for now
					if menu.graphmode ~= "npcaccounts" then
						for i, group in ipairs(menu.groupedgraphdata) do
							local isextended = menu.isGroupExpanded(group.id)
							row = menu.keyTable:addRow(true, {  })
							row[1]:createButton({  }):setText(isextended and "-" or "+", { halign = "center" })
							row[1].handlers.onClick = function () return menu.buttonExtend(group.id, row.index) end
							row[2]:setColSpan(4):createText(group.name)
							if isextended then
								for j, dataIdx in ipairs(group) do
									local data = menu.graphdata[dataIdx]
									local row = menu.keyTable:addRow(true, {  })
									row[1]:createCheckBox(data.shown, { height = Helper.standardTextHeight, active = data.shown or (menu.numshowndata < config.graph.maxshowndata), mouseOverText = (data.shown or (menu.numshowndata < config.graph.maxshowndata)) and "" or ReadText(1026, 6500) })
									row[1].handlers.onClick = function () return menu.checkboxSelected(dataIdx, row.index, 1) end
									row[2]:setColSpan(4):createText(data.text)
								end
							end
						end
					else--]]
						for dataIdx, data in ipairs(menu.graphdata) do
							local row = menu.keyTable:addRow(dataIdx, {  })
							row[1]:createCheckBox(data.shown, { height = Helper.standardTextHeight, active = data.shown or (menu.numshowndata < config.graph.maxshowndata), mouseOverText = (data.shown or (menu.numshowndata < config.graph.maxshowndata)) and "" or ReadText(1026, 6500) })
							row[1].handlers.onClick = function () return menu.checkboxSelected(dataIdx, row.index, 1) end
							row[2]:setColSpan(4):createText(data.text)
						end
					--end
				else
					local row = menu.keyTable:addRow(dataIdx, {  })
					row[1]:setColSpan(5):createText(ReadText(1001, 6524))
				end
			else
				local row = menu.keyTable:addRow(dataIdx, {  })
				row[1]:setColSpan(5):createText(ReadText(1001, 6525))
			end
		else
			local row = menu.keyTable:addRow(dataIdx, {  })
			row[1]:setColSpan(5):createText(ReadText(1001, 6526))
		end
		
		menu.restoreTableState("keyTable", menu.keyTable)
	end

	menu.restoreFlowchartState("flowchart", menu.flowchart)

	Helper.createRightSideBar(menu.frame, menu.container, true, "logical", menu.buttonRightBar)

	-- display view/frame
	menu.frame:display()
end

function menu.isOptionSelectionChanged()
	for ware in pairs(menu.contextMenuData.selectedOptions) do
		if not menu.contextMenuData.origSelectedOptions[ware] then
			return true
		end
	end
	for ware in pairs(menu.contextMenuData.origSelectedOptions) do
		if not menu.contextMenuData.selectedOptions[ware] then
			return true
		end
	end
	return false
end

function menu.onFlowchartNodeExpanded(node, frame, ftable, ftable2)
	node.flowchart:collapseAllNodes()
	local data = node.customdata
	local expandHandler = data.moduledata.expandHandler
	if expandHandler then
		menu.expandedNode = node
		menu.expandedMenuFrame = frame
		menu.expandedMenuTable = ftable
		expandHandler(frame, ftable, ftable2, data.nodedata, data.moduledata.productionmodules or data.moduledata.buildmodule or data.moduledata.researchmodule or data.moduledata.terraformingproject)
	end
end

function menu.onExpandTradeWares(frame, ftable, ftable2, nodedata)
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
			if (not callbacks ["onExpandTradeWares_insert_ware_to_allwares"]) or (not #callbacks ["onExpandTradeWares_insert_ware_to_allwares"]) then
				table.insert(allwares, { ware = ware, name = GetWareData(ware, "name") })
			elseif callbacks ["onExpandTradeWares_insert_ware_to_allwares"] then
				for _, callback in ipairs (callbacks ["onExpandTradeWares_insert_ware_to_allwares"]) do
					callback (allwares, ware)
				end
			end
			-- kuertee end: callback

		end
	end
	table.sort(allwares, Helper.sortName)

	for _, entry in ipairs(allwares) do
		local row = ftable:addRow(true, {  })
		row[1]:setBackgroundColSpan(3):createCheckBox(menu.selectedWares[entry.ware], { width = Helper.standardButtonHeight, height = Helper.standardButtonHeight, helpOverlayID = "station_overview_tradeware_option_" .. entry.ware, helpOverlayText = " ", helpOverlayHighlightOnly = true, helpOverlayUseBackgroundSpan = true, uiTriggerID = "tradeware_" .. entry.ware })
		row[1].handlers.onClick = function (_, checked) if checked then menu.selectedWares[entry.ware] = true else menu.selectedWares[entry.ware] = nil end end
		row[2]:setColSpan(2):createText(entry.name)
	end
	local row = ftable2:addRow(true, {  })
	row[1]:setColSpan(2):createButton({ active = function () return not menu.compareTradeWareSelection() end, uiTriggerID = "tradewares_confirm" }):setText(ReadText(1001, 2821), { halign = "center" })
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

function menu.onExpandSupplyResource(_, ftable, _, nodedata)
	local storageinfo_capacity =	C.IsInfoUnlockedForPlayer(menu.container, "storage_capacity")
	local storageinfo_amounts =		C.IsInfoUnlockedForPlayer(menu.container, "storage_amounts")
	
	local reservations = {}
	local n = C.GetNumContainerWareReservations2(menu.container, false, false, true)
	local buf = ffi.new("WareReservationInfo2[?]", n)
	n = C.GetContainerWareReservations2(buf, n, menu.container, false, false, true)
	for i = 0, n - 1 do
		local issupply = buf[i].issupply
		if issupply then
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
	-- storage
	row = ftable:addRow(nil, {  })
	row[1]:createText(ReadText(1001, 2415) .. ReadText(1001, 120))
	row[2]:setColSpan(2):createText(ReadText(1001, 11018), { halign = "right" })
	if C.IsComponentClass(menu.container, "container") then
		-- amount
		row = ftable:addRow(nil, {  })
		row[1]:createText(ReadText(1001, 6521) .. ReadText(1001, 120))
		row[2]:setColSpan(2):createText(
			function()
				local amount = menu.getSupplyResourceValue(nodedata.ware)
				local limit = menu.getSupplyResourceMax(nodedata.ware, true)
				return string.format("%s / %s", Helper.unlockInfo(storageinfo_amounts, ConvertIntegerString(amount, true, 3, true, true)), Helper.unlockInfo(storageinfo_capacity, ConvertIntegerString(limit, true, 3, true, true)))
			end,
			{ halign = "right" }
		)
		if GetComponentData(menu.containerid, "isplayerowned") then
			-- buy offer
			-- title
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(3):createText(ReadText(1001, 8309), Helper.subHeaderTextProperties)
			row[1].properties.halign = "center"
			-- automatic pricing
			local row = ftable:addRow("autobuypricecheckbox", {  })
			row[1]:createText(ReadText(1001, 8402) .. ReadText(1001, 120), { wordwrap = true })
			local avgprice, maxprice = GetWareData(nodedata.ware, "avgprice", "maxprice")
			row[2]:setColSpan(2):createText(RoundTotalTradePrice((avgprice + maxprice) / 2) .. " " .. ReadText(1001, 101), { halign = "right" })

			-- trade rule
			local hasownlist = C.HasContainerOwnTradeRule(menu.container, "supply", nodedata.ware)
			local traderuleid = C.GetContainerTradeRuleID(menu.container, "supply", nodedata.ware)
			local row = ftable:addRow(nil, {  })
			row[1]:setColSpan(3):createText(ReadText(1001, 11013) .. ReadText(1001, 120), textproperties)
			-- global
			local row = ftable:addRow("supplytraderule_global", {  })
			row[1]:setColSpan(2):createText(ReadText(1001, 11025) .. ReadText(1001, 120), textproperties)
			row[3]:createCheckBox(not hasownlist, { height = Helper.standardButtonHeight })
			row[3].handlers.onClick = function(_, checked) return menu.checkboxSetTradeRuleOverride(menu.container, "supply", nodedata.ware, checked) end
			-- current
			local row = ftable:addRow("supplytraderule_current", {  })
			row[1]:setColSpan(2):createDropDown(Helper.traderuleOptions, { startOption = (traderuleid ~= 0) and traderuleid or -1, active = hasownlist }):setTextProperties({ fontsize = config.mapFontSize })
			row[1].handlers.onDropDownConfirmed = function (_, id) return menu.dropdownTradeRule(menu.container, "supply", nodedata.ware, id) end
			row[3]:createButton({ mouseOverText = ReadText(1026, 8407) }):setIcon("menu_edit")
			row[3].handlers.onClick = menu.buttonEditTradeRule
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
					row[1]:createText(function () return Helper.getETAString(name, reservation.eta) end, { font = Helper.standardFontMono })
					row[2]:createText(ConvertIntegerString(reservation.amount, true, 3, false), { halign = "right" })
					row[3]:createButton({ active = function () return Helper.buttonCancelTradeActive(menu, menu.container, reservation.tradedeal) end, mouseOverText = ReadText(1026, 7924) }):setText("X", { halign = "center" })
					row[3].handlers.onClick = function () return Helper.buttonCancelTrade(menu, menu.container, reservation.tradedeal) end
				end
			end
		end
	end

	if menu.selectedRowData["nodeTable"] then
		menu.selectedCols["nodeTable"] = nil
	end
	menu.restoreTableState("nodeTable", ftable)
end

function menu.compareTradeWareSelection()
	local tradewares = Helper.tableCopy(menu.origSelectedWares)
	for ware in pairs(menu.selectedWares) do
		if not tradewares[ware] then
			return false
		else
			tradewares[ware] = nil
		end
	end
	return next(tradewares) == nil
end

function menu.setTradeWares()	
	local tradewares = Helper.tableCopy(menu.origSelectedWares)
	for ware in pairs(menu.selectedWares) do
		if not tradewares[ware] then
			-- add
			C.AddTradeWare(menu.container, ware)
		else
			-- nothing to do
			tradewares[ware] = nil
		end
	end
	for ware in pairs(tradewares) do
		-- remove
		C.ClearContainerBuyLimitOverride(menu.container, ware)
		C.SetContainerWareIsBuyable(menu.container, ware, false)
		ClearContainerWarePriceOverride(menu.containerid, ware, true)

		C.ClearContainerSellLimitOverride(menu.container, ware)
		C.SetContainerWareIsSellable(menu.container, ware, false)
		ClearContainerWarePriceOverride(menu.containerid, ware, false)

		ClearContainerStockLimitOverride(menu.containerid, ware)
		C.RemoveTradeWare(menu.container, ware)
	end

	menu.setupFlowchartData()
	menu.refresh = true
	menu.expandedNode:collapse()
end

function menu.onExpandProduction(_, ftable, _, nodedata, productionmodules)
	local productioninfo_products, productioninfo_rate, productioninfo_resources
	local isplayerowned = GetComponentData(menu.containerid, "isplayerowned")
	if isplayerowned then
		productioninfo_products, productioninfo_rate, productioninfo_resources = true, true, true
	end

	local nostorage, noresources, hacked, nonfunctional, destroyed, plannedremoval, planned, producing, paused, realpaused, queued = 0, 0, 0, 0, #productionmodules.destroyedcomponents, 0, productionmodules.numplanned, 0, 0, 0, 0
	local sunlight, workforce, hullefficiency
	for _, module in ipairs(productionmodules.components) do
		if not IsComponentConstruction(module) then
			productioninfo_products		= productioninfo_products	or C.IsInfoUnlockedForPlayer(module, "production_products")
			productioninfo_rate			= productioninfo_rate		or C.IsInfoUnlockedForPlayer(module, "production_rate")
			productioninfo_resources	= productioninfo_resources	or C.IsInfoUnlockedForPlayer(module, "production_resources")

			local proddata = GetProductionModuleData(module)
			if proddata.state ~= "empty" then
				hullefficiency = hullefficiency or proddata.efficiency.efficiency
				sunlight = sunlight or proddata.efficiency.sunlight
				workforce = workforce or proddata.efficiency.work
			end
			local ishacked, isfunctional, ispausedmanually = GetComponentData(module, "ishacked", "isfunctional", "ispausedmanually")

			local isqueued = true
			if proddata.state ~= "empty" then
				for _, product in ipairs(proddata.products) do
					if product.ware == nodedata.ware then
						isqueued = false
						break
					end
				end
			end

			if menu.removedModules[tostring(module)] then
				plannedremoval = plannedremoval + 1
				if ispausedmanually then
					realpaused = realpaused + 1
				end
			elseif ishacked then
				hacked = hacked + 1
				if ispausedmanually then
					realpaused = realpaused + 1
				end
			elseif ispausedmanually then
				paused = paused + 1
				realpaused = realpaused + 1
			elseif not isfunctional then
				nonfunctional = nonfunctional + 1
			elseif (proddata.state == "choosingitem") or (proddata.state == "waitingforstorage") then
				nostorage = nostorage + 1
			elseif proddata.state == "waitingforresources" then
				noresources = noresources + 1
			elseif isqueued then
				queued = queued + 1
			else
				producing = producing + 1
			end
		else
			plannedremoval = plannedremoval + 1
		end
	end

	ftable:setColWidthPercent(2, 30)
	ftable:setColWidthPercent(3, 10)
	local row
	if productioninfo_rate then
		-- status
		local shown = false
		if destroyed > 0 then
			shown = true
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(2):createText(ReadText(1001, 8428) .. ReadText(1001, 120), { wordwrap = true, color = Color["text_error"] })
			row[3]:createText(destroyed, { halign = "right", color = Color["text_error"] })
		end
		if nonfunctional > 0 then
			shown = true
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(2):createText(ReadText(1001, 8429) .. ReadText(1001, 120), { wordwrap = true, color = Color["text_error"] })
			row[3]:createText(nonfunctional, { halign = "right", color = Color["text_error"] })
		end
		if hacked > 0 then
			shown = true
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(2):createText(ReadText(1001, 8430) .. ReadText(1001, 120), { wordwrap = true, color = Color["text_error"] })
			row[3]:createText(hacked, { halign = "right", color = Color["text_error"] })
		end
		if paused > 0 then
			shown = true
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(2):createText(ReadText(1001, 8448) .. ReadText(1001, 120), { wordwrap = true, color = Color["text_warning"] })
			row[3]:createText(paused, { halign = "right", color = Color["text_warning"] })
		end
		if queued > 0 then
			shown = true
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(2):createText(ReadText(1001, 8469) .. ReadText(1001, 120), { wordwrap = true, color = Color["text_warning"] })
			row[3]:createText(queued, { halign = "right", color = Color["text_warning"] })
		end
		if noresources > 0 then
			shown = true
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(2):createText(ReadText(1001, 8431) .. ReadText(1001, 120), { wordwrap = true, color = Color["text_error"] })
			row[3]:createText(noresources, { halign = "right", color = Color["text_error"] })
		end
		if nostorage > 0 then
			shown = true
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(2):createText(ReadText(1001, 8432) .. ReadText(1001, 120), { wordwrap = true, color = Color["text_warning"] })
			row[3]:createText(nostorage, { halign = "right", color = Color["text_warning"] })
		end
		if planned > 0 then
			shown = true
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(2):createText(ReadText(1001, 8433) .. ReadText(1001, 120), { wordwrap = true })
			row[3]:createText(planned, { halign = "right" })
		end
		if plannedremoval > 0 then
			shown = true
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(2):createText(ReadText(1001, 8434) .. ReadText(1001, 120), { wordwrap = true })
			row[3]:createText(plannedremoval, { halign = "right" })
		end
		if shown then
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(3):createText("")
		end
	end

	-- Pause
	if isplayerowned and (#productionmodules.components > 0) then
		row = ftable:addRow(true, {  })
		local allpaused = #productionmodules.components == realpaused
		row[1]:setColSpan(3):createButton({  }):setText(allpaused and ReadText(1001, 8450) or ReadText(1001, 8449), { halign = "center" })
		row[1].handlers.onClick = function () return menu.buttonPauseProductionModules(productionmodules.components, not allpaused) end
		row = ftable:addRow(nil, {  })
		row[1]:setColSpan(3):createText("")
	end

	-- efficiency
	row = ftable:addRow(nil, {  })
	row[1]:createText(ReadText(1001, 1602) .. ReadText(1001, 120), { wordwrap = true })
	row[2]:setColSpan(2):createText(function() return menu.getProductionEfficiency(productionmodules.components) end, { halign = "right" })
	-- workforce
	if workforce then
		row = ftable:addRow(nil, {  })
		row[1]:createText("   " .. ReadText(1001, 9415) .. ReadText(1001, 120), { wordwrap = true })
		row[2]:setColSpan(2):createText(function() return menu.getProductionWorkforceEfficiency(productionmodules.components) end, { halign = "right" })
	end
	-- hull damage
	if hullefficiency then
		row = ftable:addRow(nil, {  })
		row[1]:createText("   " .. ReadText(1001, 8468) .. ReadText(1001, 120), { wordwrap = true })
		row[2]:setColSpan(2):createText(function() return menu.getProductionHullEfficiency(productionmodules.components) end, { halign = "right" })
	end
	-- sunlight
	if sunlight then
		row = ftable:addRow(nil, {  })
		row[1]:createText("   " .. ReadText(1001, 2412) .. ReadText(1001, 120), { wordwrap = true })
		row[2]:setColSpan(2):createText(sunlight.sunlight * 100 .. " %", { halign = "right" })
	end
	-- bonus products
	row = ftable:addRow(nil, {  })
	row[1]:createText(ReadText(1001, 8461) .. " / " .. ReadText(1001, 102) .. ReadText(1001, 120), { wordwrap = true })
	row[2]:setColSpan(2):createText(function() return menu.getProductionEfficiencyProducts(nodedata.ware, productionmodules.macro, producing) end, { halign = "right" })
	-- remaining cycle time
	row = ftable:addRow(nil, {  })
	row[1]:setColSpan(3):createText(ReadText(1001, 8435) .. ReadText(1001, 120), { wordwrap = true })
	row = ftable:addRow(nil, {  })
	row[1]:setColSpan(3):createText(function() return menu.getProductionCycleTime(productionmodules.components) end, { halign = "right" })
	-- resource remaining time
	row = ftable:addRow(nil, {  })
	row[1]:setColSpan(3):createText(ReadText(1001, 8409) .. ReadText(1001, 120), { wordwrap = true })
	row = ftable:addRow(nil, {  })
	row[1]:setColSpan(3):createText(function() return menu.getProductionRemainingTime(nodedata.ware, productionmodules.components, productionmodules.macro) end, { halign = "right" })
	row = ftable:addRow(nil, {  })
	row[1]:setColSpan(3):createText("")

	local macrodata = GetLibraryEntry(GetMacroData(productionmodules.macro, "infolibrary"), productionmodules.macro)
	local queueduration = 0
	local proddata
	for _, entry in ipairs(macrodata.products) do
		if entry.ware == nodedata.ware then
			proddata = entry
		end
		queueduration = queueduration + entry.cycle
	end

	if proddata then
		local product = proddata.ware
		local baseamount = (queueduration > 0) and Helper.round(proddata.amount * 3600 / queueduration) or 0
		local currentamount = C.GetContainerWareProduction(menu.container, product, false)
		-- factor
		local factor = menu.showSingleProduction[productionmodules.macro] and 1 or producing
		row = ftable:addRow(true, {  })
		row[1]:setColSpan(2):createText(ReadText(1001, 8462) .. ReadText(1001, 120))
		row[3]:createCheckBox(menu.showSingleProduction[productionmodules.macro], { width = Helper.standardButtonHeight, height = Helper.standardButtonHeight, active = (producing ~= 1) or (baseamount ~= currentamount) })
		row[3].handlers.onClick = function (_, checked) return menu.checkboxProductionSingle(productionmodules.macro, checked) end
		-- product
		row = ftable:addRow(nil, {  })
		row[1]:setColSpan(3):createText(ReadText(1001, 1624) .. " / " .. ReadText(1001, 102) .. ReadText(1001, 120))
		row = ftable:addRow(nil, {  })
		row[1]:createText("   " .. Helper.unlockInfo(productioninfo_products, GetWareData(product, "name")))
		local amount = menu.showSingleProduction[productionmodules.macro] and baseamount or currentamount
		row[2]:setColSpan(2):createText(Helper.unlockInfo(productioninfo_rate, ConvertIntegerString(amount, true, 0, true, false)), { halign = "right" })
		-- resources
		if #proddata.resources > 0 then
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(3):createText(ReadText(1001, 7403) .. " / " .. ReadText(1001, 102) .. ReadText(1001, 120))
			for _, resourcedata in ipairs(proddata.resources) do
				row = ftable:addRow(nil, {  })
				local amount = menu.showSingleProduction[productionmodules.macro] and ((queueduration > 0) and Helper.round(factor * resourcedata.amount * 3600 / queueduration) or 0) or C.GetContainerWareConsumptionPerProduct(menu.container, resourcedata.ware, product, false)
				row[1]:createText("   " .. Helper.unlockInfo(productioninfo_resources, GetWareData(resourcedata.ware, "name")))
				row[2]:setColSpan(2):createText(Helper.unlockInfo(productioninfo_rate, ConvertIntegerString(amount, true, 0, true, false)), { halign = "right" })
			end
		else
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(3):createText(ReadText(1001, 7403) .. " / " .. ReadText(1001, 102) .. ReadText(1001, 120))
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(3):createText("   ---")
		end
	end

	menu.restoreTableState("nodeTable", ftable)
end

function menu.onExpandProcessing(_, ftable, _, nodedata, processingmodules)
	local productioninfo_products, productioninfo_rate, productioninfo_resources
	local isplayerowned = GetComponentData(menu.containerid, "isplayerowned")
	if isplayerowned then
		productioninfo_products, productioninfo_rate, productioninfo_resources = true, true, true
	end

	local macrodata = GetLibraryEntry(GetMacroData(processingmodules.macro, "infolibrary"), processingmodules.macro)
	local proddata
	for _, entry in ipairs(macrodata.products) do
		if entry.ware == nodedata.ware then
			proddata = entry
		end
	end

	local wares = ffi.new("UIWareAmount[?]", 1)
	wares[0].wareid = Helper.ffiNewString(nodedata.ware)
	wares[0].amount = proddata and proddata.amount or 1
	local isstoragefull = not C.AreWaresWithinContainerProductionLimits(menu.container, wares, 1)

	local rawproducts, rawresources = {}, {}
	local nostorage, noresources, hacked, nonfunctional, destroyed, plannedremoval, planned, producing, realpaused = 0, 0, 0, 0, #processingmodules.destroyedcomponents, 0, processingmodules.numplanned, 0, 0
	for _, module in ipairs(processingmodules.components) do
		local data = GetProcessingModuleData(module)
		if not IsComponentConstruction(module) then
			productioninfo_products		= productioninfo_products	or C.IsInfoUnlockedForPlayer(module, "production_products")
			productioninfo_rate			= productioninfo_rate		or C.IsInfoUnlockedForPlayer(module, "production_rate")
			productioninfo_resources	= productioninfo_resources	or C.IsInfoUnlockedForPlayer(module, "production_resources")

			local ishacked, isfunctional, ispausedmanually = GetComponentData(module, "ishacked", "isfunctional", "ispausedmanually")

			if menu.removedModules[tostring(module)] then
				plannedremoval = plannedremoval + 1
				if ispausedmanually then
					realpaused = realpaused + 1
				end
			elseif ishacked then
				hacked = hacked + 1
				if ispausedmanually then
					realpaused = realpaused + 1
				end
			elseif ispausedmanually then
				realpaused = realpaused + 1
			elseif not isfunctional then
				nonfunctional = nonfunctional + 1
			elseif data.state == "waitingforstorage" then
				nostorage = nostorage + 1
			elseif data.state == "waitingforresources" then
				noresources = noresources + 1
			else
				producing = producing + 1

				for _, entry in ipairs(data.products) do
					rawproducts[entry.ware] = (rawproducts[entry.ware] or 0) + entry.amountperhour
				end
				for _, entry in ipairs(data.resources) do
					rawresources[entry.ware] = (rawresources[entry.ware] or 0) + entry.amountperhour
				end
			end
		else
			plannedremoval = plannedremoval + 1
		end
	end
	local products, resources = {}, {}
	for ware, amount in pairs(rawproducts) do
		table.insert(products, { ware = ware, amount = amount, name = GetWareData(ware, "name") })
	end
	table.sort(products, Helper.sortName)
	for ware, amount in pairs(rawresources) do
		table.insert(resources, { ware = ware, amount = amount, name = GetWareData(ware, "name") })
	end
	table.sort(resources, Helper.sortName)

	ftable:setColWidthPercent(2, 30)
	ftable:setColWidthPercent(3, 10)
	local row
	if productioninfo_rate then
		-- status
		local shown = false
		if destroyed > 0 then
			shown = true
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(2):createText(ReadText(1001, 8428) .. ReadText(1001, 120), { wordwrap = true, color = Color["text_error"] })
			row[3]:createText(destroyed, { halign = "right", color = Color["text_error"] })
		end
		if nonfunctional > 0 then
			shown = true
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(2):createText(ReadText(1001, 8429) .. ReadText(1001, 120), { wordwrap = true, color = Color["text_error"] })
			row[3]:createText(nonfunctional, { halign = "right", color = Color["text_error"] })
		end
		if hacked > 0 then
			shown = true
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(2):createText(ReadText(1001, 8430) .. ReadText(1001, 120), { wordwrap = true, color = Color["text_error"] })
			row[3]:createText(hacked, { halign = "right", color = Color["text_error"] })
		end
		if noresources > 0 then
			shown = true
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(2):createText(ReadText(1001, 8431) .. ReadText(1001, 120), { wordwrap = true, color = Color["text_error"] })
			row[3]:createText(noresources, { halign = "right", color = Color["text_error"] })
		end
		if nostorage > 0 then
			shown = true
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(2):createText(ReadText(1001, 8432) .. ReadText(1001, 120), { wordwrap = true, color = Color["text_warning"] })
			row[3]:createText(nostorage, { halign = "right", color = Color["text_warning"] })
		end
		if planned > 0 then
			shown = true
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(2):createText(ReadText(1001, 8433) .. ReadText(1001, 120), { wordwrap = true })
			row[3]:createText(planned, { halign = "right" })
		end
		if plannedremoval > 0 then
			shown = true
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(2):createText(ReadText(1001, 8434) .. ReadText(1001, 120), { wordwrap = true })
			row[3]:createText(plannedremoval, { halign = "right" })
		end
		if shown then
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(3):createText("")
		end
	end

	-- Pause
	if isplayerowned and (#processingmodules.components > 0) then
		row = ftable:addRow(true, {  })
		local allpaused = #processingmodules.components == realpaused
		row[1]:setColSpan(3):createButton({  }):setText(allpaused and ReadText(1001, 8450) or ReadText(1001, 8449), { halign = "center" })
		row[1].handlers.onClick = function () return menu.buttonPauseProcessingModules(processingmodules.components, not allpaused) end
		row = ftable:addRow(nil, {  })
		row[1]:setColSpan(3):createText("")
	end

	-- remaining cycle time
	row = ftable:addRow(nil, {  })
	row[1]:setColSpan(3):createText(ReadText(1001, 8435) .. ReadText(1001, 120), { wordwrap = true })
	row = ftable:addRow(nil, {  })
	row[1]:setColSpan(3):createText(function() return menu.getProcessingCycleTime(processingmodules.components) end, { halign = "right" })

	if next(products) then
		-- product
		row = ftable:addRow(nil, {  })
		row[1]:setColSpan(3):createText(ReadText(1001, 1624) .. " / " .. ReadText(1001, 102) .. ReadText(1001, 120))
		for _, entry in ipairs(products) do
			row = ftable:addRow(nil, {  })
			row[1]:createText("   " .. Helper.unlockInfo(productioninfo_products, GetWareData(entry.ware, "name")))
			row[2]:setColSpan(2):createText(Helper.unlockInfo(productioninfo_rate, ConvertIntegerString(entry.amount, true, 0, true, false)), { halign = "right" })
		end
		-- resources
		if #resources > 0 then
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(3):createText(ReadText(1001, 7403) .. " / " .. ReadText(1001, 102) .. ReadText(1001, 120))
			for _, entry in ipairs(resources) do
				row = ftable:addRow(nil, {  })
				row[1]:createText("   " .. Helper.unlockInfo(productioninfo_resources, GetWareData(entry.ware, "name")))
				row[2]:setColSpan(2):createText(Helper.unlockInfo(productioninfo_rate, ConvertIntegerString(entry.amount, true, 0, true, false)), { halign = "right" })
			end
		else
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(3):createText(ReadText(1001, 7403) .. " / " .. ReadText(1001, 102) .. ReadText(1001, 120))
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(3):createText("   ---")
		end
	elseif proddata then
		-- product
		row = ftable:addRow(nil, {  })
		row[1]:setColSpan(3):createText(ReadText(1001, 1624) .. ReadText(1001, 120))
		row = ftable:addRow(nil, {  })
		row[1]:createText("   " .. Helper.unlockInfo(productioninfo_products, GetWareData(proddata.ware, "name")))
		row[2]:setColSpan(2):createText(Helper.unlockInfo(productioninfo_rate, ConvertIntegerString(proddata.amount, true, 0, true, false)), { halign = "right" })
		-- resources
		if #proddata.resources > 0 then
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(3):createText(ReadText(1001, 7403) .. ReadText(1001, 120))
			for _, resourcedata in ipairs(proddata.resources) do
				row = ftable:addRow(nil, {  })
				row[1]:createText("   " .. Helper.unlockInfo(productioninfo_resources, GetWareData(resourcedata.ware, "name")))
				row[2]:setColSpan(2):createText(Helper.unlockInfo(productioninfo_rate, ConvertIntegerString(resourcedata.amount, true, 0, true, false)), { halign = "right" })
			end
		else
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(3):createText(ReadText(1001, 7403) .. ReadText(1001, 120))
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(3):createText("   ---")
		end
	end

	menu.restoreTableState("nodeTable", ftable)
end

function menu.getProductionEfficiency(modules)
	local efficiency, numproducing = 0, 0
	for _, module in ipairs(modules) do
		-- components that are already being recycled are in state construction
		if not IsComponentConstruction(module) then
			local proddata = GetProductionModuleData(module)
			local ishacked, isfunctional = GetComponentData(module, "ishacked", "isfunctional")
			if (not ishacked) and isfunctional and (proddata.state == "producing") then
				numproducing = numproducing + 1
				if C.IsInfoUnlockedForPlayer(module, "production_rate") then
					efficiency = efficiency + proddata.products.efficiency
				end
			end
		end
	end
	if numproducing > 0 then
		if efficiency > 0 then
			return Helper.round(efficiency / numproducing, 2) * 100 .. " %"
		else
			return ReadText(1001, 3210)
		end
	end
	return "- %"
end

function menu.getProductionEfficiencyProducts(ware, macro, producing)
	if producing > 0 then
		local macrodata = GetLibraryEntry(GetMacroData(macro, "infolibrary"), macro)
		local proddata
		local queueduration = 0
		for _, entry in ipairs(macrodata.products) do
			if entry.ware == ware then
				proddata = entry
			end
			queueduration = queueduration + entry.cycle
		end

		if proddata then
			local product = proddata.ware
			local currentproduction = C.GetContainerWareProduction(menu.container, product, false)
			local baseproduction = (queueduration > 0) and (Helper.round(proddata.amount * 3600 / queueduration) * producing) or 0
			local diff = currentproduction - baseproduction
			return string.format("%s%d", (diff > 0) and (ColorText["text_positive"] .. "+") or ((diff < 0) and ColorText["text_negative"] or ""), diff)
		else
			return "-"
		end
	else
		return "-"
	end
end

function menu.getProductionWorkforceEfficiency(modules)
	local efficiency, numproducing, unlocked = 0, 0, false
	for _, module in ipairs(modules) do
		-- components that are already being recycled are in state construction
		if not IsComponentConstruction(module) then
			local proddata = GetProductionModuleData(module)
			local ishacked, isfunctional = GetComponentData(module, "ishacked", "isfunctional")
			if (not ishacked) and isfunctional and (proddata.state == "producing") then
				numproducing = numproducing + 1
				if C.IsInfoUnlockedForPlayer(module, "production_rate") then
					unlocked = true
					efficiency = efficiency + proddata.efficiency.work.workforce * proddata.efficiency.work.product
				end
			end
		end
	end
	if numproducing > 0 then
		if not unlocked then
			return ReadText(1001, 3210)
		elseif efficiency > 0 then
			return Helper.round(1 + (efficiency / numproducing), 2) * 100 .. " %"
		end
	end
	return "- %"
end

function menu.getProductionHullEfficiency(modules)
	local efficiency, numproducing, unlocked = 0, 0, false
	for _, module in ipairs(modules) do
		-- components that are already being recycled are in state construction
		if not IsComponentConstruction(module) then
			local proddata = GetProductionModuleData(module)
			local ishacked, isfunctional = GetComponentData(module, "ishacked", "isfunctional")
			if (not ishacked) and isfunctional and (proddata.state == "producing") then
				numproducing = numproducing + 1
				if C.IsInfoUnlockedForPlayer(module, "production_rate") then
					unlocked = true
					efficiency = efficiency + proddata.efficiency.efficiency.product
				end
			end
		end
	end
	if numproducing > 0 then
		if not unlocked then
			return ReadText(1001, 3210)
		elseif efficiency > 0 then
			return math.floor((efficiency / numproducing) * 100) .. " %"
		end
	end
	return "- %"
end

function menu.getProductionCycleTime(modules)
	local cycle, numproducing = nil, 0
	for _, module in ipairs(modules) do
		-- components that are already being recycled are in state construction
		if not IsComponentConstruction(module) then
			local proddata = GetProductionModuleData(module)
			local ishacked, isfunctional = GetComponentData(module, "ishacked", "isfunctional")
			if (not ishacked) and isfunctional and (proddata.state == "producing") then
				numproducing = numproducing + 1
				if C.IsInfoUnlockedForPlayer(module, "production_time") then
					if cycle then
						cycle = math.min(cycle, proddata.remainingcycletime)
					else
						cycle = proddata.remainingcycletime
					end
				end
			end
		end
	end
	if numproducing > 0 then
		if cycle then
			return ConvertTimeString(cycle)
		else
			return ReadText(1001, 3210)
		end
	end
	return "-"
end

function menu.getProductionRemainingTime(ware, modules, macro)
	local storageinfo_amounts = C.IsInfoUnlockedForPlayer(menu.container, "storage_amounts")
	local remainingtime, numproducing = nil, 0
	for _, module in ipairs(modules) do
		-- components that are already being recycled are in state construction
		if not IsComponentConstruction(module) then
			local proddata = GetProductionModuleData(module)
			if proddata.state ~= "empty" then
				local ishacked, isfunctional = GetComponentData(module, "ishacked", "isfunctional")
				local isqueued = true
				for _, product in ipairs(proddata.products) do
					if product.ware == ware then
						isqueued = false
						break
					end
				end
				if (not ishacked) and isfunctional and (proddata.state == "producing") and (not isqueued) then
					numproducing = numproducing + 1
					if storageinfo_amounts then
						if remainingtime then
							remainingtime = math.max(remainingtime, proddata.remainingtime)
						else
							remainingtime = proddata.remainingtime
						end
					end
				end
			end
		end
	end
	if numproducing > 0 then
		if remainingtime then
			if remainingtime == 0 then
				return utf8.char(8734)
			else
				local macrodata = GetLibraryEntry(GetMacroData(macro, "infolibrary"), macro)
				local proddata
				for _, entry in ipairs(macrodata.products) do
					if entry.ware == ware then
						proddata = entry
						break
					end
				end
				if remainingtime < 2 * proddata.cycle then
					-- if we only have enough resources for one more production cycle, we don't need to consider the number of production modules
					return ConvertTimeString(remainingtime)
				else
					return ConvertTimeString(remainingtime / numproducing)
				end
			end
		else
			return ReadText(1001, 3210)
		end
	end
	return "-"
end

function menu.getProcessingCycleTime(modules)
	local cycle, numprocessing = nil, 0
	for _, module in ipairs(modules) do
		-- components that are already being recycled are in state construction
		if not IsComponentConstruction(module) then
			local proddata = GetProcessingModuleData(module)
			local ishacked, isfunctional = GetComponentData(module, "ishacked", "isfunctional")
			if (not ishacked) and isfunctional and (proddata.state == "processing") then
				numprocessing = numprocessing + 1
				if C.IsInfoUnlockedForPlayer(module, "production_time") then
					if cycle then
						cycle = math.min(cycle, proddata.remainingcycletime)
					else
						cycle = proddata.remainingcycletime
					end
				end
			end
		end
	end
	if numprocessing > 0 then
		if cycle then
			return ConvertTimeString(cycle)
		else
			return ReadText(1001, 3210)
		end
	end
	return "-"
end

function menu.onExpandResearch(_, ftable, _, nodedata, researchmodule)
	local proddata = GetProductionModuleData(researchmodule)
	local researchtime, resources, precursors = 0, {}, {}
	if proddata.state ~= "empty" then
		researchtime, resources, precursors = GetWareData(proddata.blueprintware, "researchtime", "resources", "researchprecursors")
	end
	-- remaining time
	local row = ftable:addRow(nil, { fixed = true })
	row[1]:setColSpan(2):createText(function () return menu.researchStateText(researchmodule) end)
	local row = ftable:addRow(nil, { fixed = true })
	row[1]:setColSpan(2):createText(function () return menu.researchTimeText(researchmodule, researchtime) end, { halign = "right" })
	if proddata.state == "waitingforresources" then
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
				local locamount = C.GetAmountOfWareAvailable(resourcedata.ware, researchmodule)
				local color
				if locamount and (locamount < resourcedata.amount) then
					color = Color["text_warning"]
				end
				local row = ftable:addRow(nil, { fixed = true })
				local name = GetWareData(resourcedata.ware, "name")
				local resourcename = "  " .. name
				row[1]:createText(resourcename, { color = color })
				row[2]:createText((locamount and (locamount .. " / ") or "") .. resourcedata.amount, { halign = "right", color = color })
			end
		end
	end
end

function menu.researchStateText(researchmodule)
	local proddata = GetProductionModuleData(researchmodule)
	if proddata.state == "empty" then
		return ReadText(1001, 7408)
	elseif proddata.state == "waitingforresources" then
		return ReadText(1001, 4231) .. ReadText(1001, 120)
	end
	return ReadText(1001, 7409) .. ReadText(1001, 120)
end

function menu.researchTimeText(researchmodule, researchtime)
	local proddata = GetProductionModuleData(researchmodule)
	return (proddata.state == "waitingforresources") and ConvertTimeString(researchtime) or ConvertTimeString(researchmodule and (proddata.remainingcycletime or 0) or 0)
end

function menu.onExpandTerraforming(_, ftable, _, nodedata, project)
	ftable:setColWidthPercent(1, 66)
	ftable.properties.highlightMode = "grey"

	local shiptrader = GetComponentData(menu.containerid, "shiptrader")
	menu.updateDroneInfo(project.cluster, project.project)
	if (not project.project.isongoing) and ((shiptrader == nil) or ((menu.droneinfo.numbuildsinprogress + menu.droneinfo.numcurrentdeliveries) == 0)) then
		local row = ftable:addRow(nil, {  })
		row[1]:setColSpan(2):createText(function () return menu.terraformingErrorText(project) end, { wordwrap = true, color = Color["text_error"] })

		ftable:addEmptyRow(Helper.standardTextHeight / 2)
	end

	-- queue
	local row = ftable:addRow(nil, {  })
	row[1]:setColSpan(2):createText(ReadText(1001, 3804) .. ReadText(1001, 120))
	local row = ftable:addRow(nil, {  })
	row[1]:setColSpan(2):createText(function () menu.updateDroneInfo(project.cluster, project.project); return ConvertIntegerString(tonumber(menu.droneinfo.numbuildsinqueue), true, 0, true) end, { halign = "right" })
	-- progress
	local row = ftable:addRow(nil, {  })
	row[1]:setColSpan(2):createText(ReadText(1001, 3803) .. ReadText(1001, 120))
	local row = ftable:addRow(nil, {  })
	row[1]:setColSpan(2):createText(function () menu.updateDroneInfo(project.cluster, project.project); return ConvertIntegerString(tonumber(menu.droneinfo.numbuildsinprogress), true, 0, true) end, { halign = "right" })
	-- in-flight
	local row = ftable:addRow(nil, {  })
	row[1]:setColSpan(2):createText(ReadText(1001, 3805) .. ReadText(1001, 120))
	local row = ftable:addRow(nil, {  })
	row[1]:setColSpan(2):createText(function () menu.updateDroneInfo(project.cluster, project.project); return ConvertIntegerString(tonumber(menu.droneinfo.numcurrentdeliveries), true, 0, true) end, { halign = "right" })

	-- resources
	if #project.project.resources > 0 then
		ftable:addEmptyRow(Helper.standardTextHeight / 2)
		local row = ftable:addRow(nil, {  })
		row[1]:setColSpan(2):createText(ReadText(1001, 3802) .. ReadText(1001, 120))
		for _, entry in ipairs(project.project.resources) do
			local row = ftable:addRow(true, {  })
			row[1]:createText("· " .. GetWareData(entry.ware, "name"))
			menu.updateDeliveredWares(project.cluster, project.project)
			row[2]:createText(function () menu.updateDeliveredWares(project.cluster, project.project); return ConvertIntegerString(menu.deliveredwares[entry.ware] or 0, true, 1, true) .. " / " .. ConvertIntegerString(entry.amount, true, 1, true) end, { halign = "right", mouseOverText = ConvertIntegerString(menu.deliveredwares[entry.ware] or 0, true, 0, true) .. " / " .. ConvertIntegerString(entry.amount, true, 0, true) })
		end
	end

	-- duration
	if project.project.duration > 0 then
		if not hasspacing then
			ftable:addEmptyRow(Helper.standardTextHeight / 2)
			hasspacing = true
		end
		local row = ftable:addRow(nil, {  })
		row[1]:createText(ReadText(1001, 3813) .. ReadText(1001, 120), { mouseOverText = ReadText(1026, 3800) })
		if project.project.isongoing then
			row[2]:createText(function () return ConvertTimeString(C.GetTerraformingProjectCompletionTime(project.cluster, project.project.id) - C.GetCurrentGameTime(), "%h:%M:%S") end, { halign = "right", mouseOverText = ReadText(1026, 3800) })
		else
			row[2]:createText(ConvertTimeString(project.project.duration, "%h:%M:%S"), { halign = "right", mouseOverText = ReadText(1026, 3800) })
		end
	end
end

function menu.terraformingErrorText(project)
	local name, shiptrader = GetComponentData(menu.containerid, "name", "shiptrader")
	if shiptrader then
		menu.updateDroneInfo(project.cluster, project.project)
		return ((menu.droneinfo.numbuildsinprogress + menu.droneinfo.numcurrentdeliveries) == 0) and ReadText(1001, 3845) or ""
	else
		return string.format(ReadText(1001, 11264), name)
	end
end

function menu.updateDroneInfo(cluster, project)
	local curtime = getElapsedTime()
	if (not menu.lastDroneInfoUpdateTime) or (curtime > menu.lastDroneInfoUpdateTime) then
		menu.lastDroneInfoUpdateTime = curtime
		menu.droneinfo = C.GetTerraformingProjectDroneStatus(cluster, project.id)
	end
end

function menu.onExpandDestroyedModule(_, ftable, _, nodedata, module)
	if GetComponentData(menu.containerid, "isplayerowned") then
		row = ftable:addRow(nil, {  })
		row[1]:setColSpan(2):createText(ReadText(1001, 8427), { color = Color["text_error"] })
	end
end

function menu.onExpandBuildModule(_, ftable, _, nodedata, buildmodule)
	local productioninfo_products =	C.IsInfoUnlockedForPlayer(buildmodule, "production_products")
	local productioninfo_time =		C.IsInfoUnlockedForPlayer(buildmodule, "production_time")

	local constructions = {}
	local n = C.GetNumBuildTasks(menu.container, buildmodule, true, true)
	local buf = ffi.new("BuildTaskInfo[?]", n)
	n = C.GetBuildTasks(buf, n, menu.container, buildmodule, true, true)
	for i = 0, n - 1 do
		table.insert(constructions, { id = buf[i].id, buildingcontainer = buf[i].buildingcontainer, component = buf[i].component, macro = ffi.string(buf[i].macro), factionid = ffi.string(buf[i].factionid), buildercomponent = buf[i].buildercomponent, price = buf[i].price, ismissingresources = buf[i].ismissingresources, queueposition = buf[i].queueposition, inprogress = true })
	end

	ftable:setColWidthPercent(1, 50)
	ftable:setColWidth(3, Helper.scaleY(Helper.standardButtonHeight), false)
	ftable:setColWidth(4, Helper.scaleY(Helper.standardButtonHeight), false)

	local ishacked = GetComponentData(ConvertStringTo64Bit(tostring(buildmodule)), "ishacked")
	if ishacked then
		local row = ftable:addRow(nil, {  })
		row[1]:setColSpan(4):createText(ReadText(1001, 8426), { color = Color["text_error"], wordwrap = true })
	end

	if #constructions > 0 then
		for _, construction in ipairs(constructions) do
			local name = ReadText(20109, 5101)
			if construction.component ~= 0 then
				name = GetComponentName(ConvertStringTo64Bit(tostring(construction.component)), Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), config.nodewidth, nil, true)
			elseif construction.macro ~= "" then
				name = GetMacroData(construction.macro, "name")
			end
			local color = (productioninfo_products and (construction.factionid == "player")) and Color["text_player"] or Color["text_normal"]

			if construction.inprogress then
				local row = ftable:addRow(nil, {  })
				row[1]:setColSpan(4):createText(Helper.unlockInfo(productioninfo_products, name .. " (" .. ffi.string(C.GetObjectIDCode(construction.component)) .. ")"), { color = color, mouseOverText = construction.ismissingresources and ReadText(1026, 3223) or "" })
				local row = ftable:addRow(nil, {  })
				row[1]:createText(Helper.unlockInfo(productioninfo_time, function () return menu.getShipBuildProgress(construction.component, "") end), { color = color, mouseOverText = construction.ismissingresources and ReadText(1026, 3223) or "" }) 
				row[2]:setColSpan(3):createText(Helper.unlockInfo(productioninfo_time, function () return (construction.ismissingresources and (ColorText["text_warning"] .. "\27[warning] ") or "") .. ConvertTimeString(C.GetBuildProcessorEstimatedTimeLeft(construction.buildercomponent), "%h:%M:%S") end), { halign = "right", color = color, mouseOverText = construction.ismissingresources and ReadText(1026, 3223) or "" })
			end
		end
	else
		local row = ftable:addRow(nil, {  })
		row[1]:setColSpan(4):createText(Helper.unlockInfo(productioninfo_products, ReadText(1001, 8419)))
	end

	ftable:addEmptyRow()

	if GetComponentData(menu.containerid, "isplayerowned") then
		-- trade rule
		local hasownlist = C.HasContainerOwnTradeRule(menu.container, "build", "")
		local traderuleid = C.GetContainerTradeRuleID(menu.container, "build", "")
		local row = ftable:addRow(nil, {  })
		row[1]:setColSpan(4):createText(ReadText(1001, 11013) .. ReadText(1001, 120), textproperties)
		-- global
		local row = ftable:addRow("buildtraderule_global", {  })
		row[1]:setColSpan(3):createText(ReadText(1001, 8367) .. ReadText(1001, 120), textproperties)
		row[4]:createCheckBox(not hasownlist, { height = Helper.standardButtonHeight })
		row[4].handlers.onClick = function(_, checked) return menu.checkboxSetTradeRuleOverride(menu.container, "build", "", checked) end
		-- current
		local row = ftable:addRow("buildtraderule_current", {  })
		row[1]:setColSpan(3):createDropDown(Helper.traderuleOptions, { startOption = (traderuleid ~= 0) and traderuleid or -1, active = hasownlist }):setTextProperties({ fontsize = config.mapFontSize })
		row[1].handlers.onDropDownConfirmed = function (_, id) return menu.dropdownTradeRule(menu.container, "build", "", id) end
		row[4]:createButton({ mouseOverText = ReadText(1026, 8407) }):setIcon("menu_edit")
		row[4].handlers.onClick = menu.buttonEditTradeRule

		local row = ftable:addRow(false, {  })
		row[1]:setColSpan(4):createText("")

		-- price factor
		row = ftable:addRow(false, {  })
		row[1]:setColSpan(4):createText(ReadText(1001, 8425) .. ReadText(1001, 120), { wordwrap = true })
		row = ftable:addRow(true, {  })
		row[1]:setColSpan(4):createSliderCell({
			height = Helper.standardTextHeight,
			min = 50,
			max = 150,
			start = math.floor(C.GetContainerBuildPriceFactor(menu.container) * 100 + 0.5),
			hideMaxValue = true,
			suffix = "%",
		})
		row[1].handlers.onSliderCellChanged = function(_, value) return menu.slidercellBuildPriceFactor(menu.container, value) end
	end
end

function menu.onExpandPlannedBuildModule(_, ftable, _, nodedata, buildmodule)
	if GetComponentData(menu.containerid, "isplayerowned") then
		local data = GetLibraryEntry("moduletypes_build", buildmodule[2])

		local row
		-- build
		row = ftable:addRow(nil, {  })
		row[1]:createText(ReadText(1001, 8417) .. ReadText(1001, 120))
		row = ftable:addRow(nil, {  })
		row[1]:setColSpan(2):createText(function () return menu.getBuildProgress(menu.containerid, buildmodule[1]) end, { halign = "right" })
		if IsComponentConstruction(ConvertStringTo64Bit(tostring(buildmodule[1]))) then
			row = ftable:addRow(nil, {  })
			local buildingprocessor = GetComponentData(menu.container, "buildingprocessor")
			local ismissingresources = GetComponentData(buildingprocessor, "ismissingresources")
			row[1]:setColSpan(2):createText(function () return menu.getBuildTime(buildmodule[1]) end, { halign = "right", mouseOverText = ismissingresources and ReadText(1026, 3223) or "" })
		end
	end
end

function menu.onExpandWorkforce(_, ftable, _, nodedata)
	ftable:setColWidth(1, Helper.scaleY(Helper.standardButtonHeight), false)
	ftable:setColWidthPercent(3, 30)
	ftable:setColWidth(4, Helper.scaleY(Helper.standardTextHeight), false)
	ftable.properties.highlightMode = "grey"

	local workforceinfo_all =	C.IsInfoUnlockedForPlayer(menu.container, "operator_name")

	local resourceinfos = {}
	if C.IsComponentClass(menu.container, "container") then
		resourceinfos = GetWorkForceRaceResources(menu.containerid)
	end

	local races = {}
	local n = C.GetNumAllRaces()
	local buf = ffi.new("RaceInfo[?]", n)
	n = C.GetAllRaces(buf, n)
	for i = 0, n - 1 do
		local entry = {}
		entry.id = ffi.string(buf[i].id)
		entry.name = ffi.string(buf[i].name)

		table.insert(races, entry)
	end
	table.sort(races, Helper.sortName)

	local row
	-- global
	row = ftable:addRow(nil, {  })
	row[1]:setColSpan(2):createText(ReadText(1001, 8412) .. ReadText(1001, 120), { wordwrap = true })
	row[3]:setColSpan(2):createText(function() return Helper.unlockInfo(workforceinfo_all, ConvertIntegerString(C.GetWorkForceInfo(menu.container, "").current, true, 0, true, false)) end, { halign = "right" })
	row = ftable:addRow(nil, {  })
	row[1]:setColSpan(2):createText(ReadText(1001, 9611) .. ReadText(1001, 120), { wordwrap = true })
	row[3]:setColSpan(2):createText(function() return Helper.unlockInfo(workforceinfo_all, ConvertIntegerString(C.GetWorkForceInfo(menu.container, "").capacity, true, 0, true, false)) end, { halign = "right" })
	-- optimal
	if (#GetProductionModules(menu.containerid) > 0) or GetComponentData(menu.containerid, "canequipships") then
		row = ftable:addRow(nil, {  })
		row[1]:setColSpan(4):createText(ReadText(1001, 8413) .. ReadText(1001, 120), { wordwrap = true })
		row = ftable:addRow(nil, {  })
		row[1]:setColSpan(4):createText(function() return Helper.unlockInfo(workforceinfo_all, ConvertIntegerString(C.GetWorkForceInfo(menu.container, "").optimal, true, 0, true, false)) end, { halign = "right" })
	end
	local shouldfill = C.ShouldContainerFillWorkforceCapacity(menu.container)
	if C.GetWorkForceInfo(menu.container, "").capacity > 0 then
		if GetComponentData(menu.containerid, "isplayerowned") then
			ftable:addEmptyRow(Helper.standardTextHeight / 2)
			-- target
			row = ftable:addRow(true, {  })
			row[1]:createCheckBox(shouldfill, { height = Helper.standardButtonHeight })
			row[1].handlers.onClick = function(_, checked) return menu.checkboxSetWorkforceFill(menu.container) end
			row[2]:setColSpan(3):createText(ReadText(1001, 8453), { mouseOverText = ReadText(1026, 8406) })
			if shouldfill then
				-- employment target
				row = ftable:addRow(true, {  })
				row[1]:setColSpan(2):createText(ReadText(1001, 8455) .. ReadText(1001, 120), { wordwrap = true })
				row[3]:setColSpan(2):createText(function() local workforceinfo = C.GetWorkForceInfo(menu.container, ""); return Helper.unlockInfo(workforceinfo_all, ConvertIntegerString(workforceinfo.capacity, true, 0, true, false)) end, { halign = "right" })
			end
			ftable:addEmptyRow(Helper.standardTextHeight / 2)
		end
		-- efficiency
		row = ftable:addRow(true, {  })
		row[1]:setColSpan(2):createText(ReadText(1001, 8464) .. ReadText(1001, 120), { wordwrap = true })
		row[3]:setColSpan(2):createText(function() return Helper.unlockInfo(workforceinfo_all, math.floor((GetComponentData(menu.containerid, "workforcebonus") or 0) * 100) .. " %") end, { halign = "right" })
		if GetComponentData(menu.containerid, "isplayerowned") then
			-- next update
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(4):createText(ReadText(1001, 8463), { wordwrap = true })
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(4):createText(ReadText(1001, 8414) .. ReadText(1001, 120), { wordwrap = true })
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(4):createText(function() return Helper.unlockInfo(workforceinfo_all, ConvertTimeString(C.GetWorkForceInfo(menu.container, "").timeuntilnextupdate - C.GetCurrentGameTime())) end, { halign = "right" })
		end
	end
	for _, race in ipairs(races) do
		local workforceinfo = C.GetWorkForceInfo(menu.container, race.id)
		if workforceinfo.capacity > 0 then
			local workforceinfluencecounts = C.GetNumContainerWorkforceInfluence(menu.container, race.id, menu.forceNextWorkforceInfluenceUpdate or false)
			menu.forceNextWorkforceInfluenceUpdate = nil
			local buf = ffi.new("WorkforceInfluenceInfo")
			buf.capacityinfluences = Helper.ffiNewHelper("UIWorkforceInfluence[?]", workforceinfluencecounts.numcapacityinfluences)
			buf.numcapacityinfluences = workforceinfluencecounts.numcapacityinfluences
			buf.growthinfluences = Helper.ffiNewHelper("UIWorkforceInfluence[?]", workforceinfluencecounts.numgrowthinfluences)
			buf.numgrowthinfluences = workforceinfluencecounts.numgrowthinfluences
			C.GetContainerWorkforceInfluence(buf, menu.container, race.id)

			local workforceinfluences = {}
			workforceinfluences.capacityinfluences = {}
			for i = 0, buf.numcapacityinfluences - 1 do
				table.insert(workforceinfluences.capacityinfluences, {
					type = ffi.string(buf.capacityinfluences[i].type),
					name = ffi.string(buf.capacityinfluences[i].name),
					value = buf.capacityinfluences[i].value,
					active = buf.capacityinfluences[i].active,
				})
			end
			workforceinfluences.growthinfluences = {}
			for i = 0, buf.numgrowthinfluences - 1 do
				table.insert(workforceinfluences.growthinfluences, {
					type = ffi.string(buf.growthinfluences[i].type),
					name = ffi.string(buf.growthinfluences[i].name),
					value = buf.growthinfluences[i].value,
					active = buf.growthinfluences[i].active,
				})
			end
			workforceinfluences.basegrowth = buf.basegrowth
			workforceinfluences.capacity = buf.capacity
			workforceinfluences.current = buf.current
			workforceinfluences.sustainable = buf.sustainable
			workforceinfluences.target = buf.target
			workforceinfluences.change = buf.change

			-- title
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(4):createText(Helper.unlockInfo(workforceinfo_all, race.name), Helper.subHeaderTextProperties)
			row[1].properties.halign = "center"
			-- current
			row = ftable:addRow(true, {  })
			row[1]:setColSpan(2):createText(ReadText(1001, 8412) .. ReadText(1001, 120), { wordwrap = true })
			row[3]:createText(function() return Helper.unlockInfo(workforceinfo_all, ConvertIntegerString(C.GetWorkForceInfo(menu.container, race.id).current, true, 0, true, false)) end, { halign = "right", x = 0 })
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(2):createText(ReadText(1001, 9611) .. ReadText(1001, 120), { wordwrap = true })
			row[3]:createText(function() return Helper.unlockInfo(workforceinfo_all, ConvertIntegerString(C.GetWorkForceInfo(menu.container, race.id).capacity, true, 0, true, false)) end, { halign = "right", x = 0 })
			-- sustainable
			row = ftable:addRow(true, {  })
			local mouseovertext = ""
			if workforceinfo_all then
				mouseovertext = ReadText(1026, 8405)
				local first = true
				for i, entry in ipairs(workforceinfluences.capacityinfluences) do
					if entry.active then
						if first then
							mouseovertext = ""
						else
							mouseovertext = mouseovertext .. "\n"
						end
						first = false
						mouseovertext = mouseovertext .. "· " .. entry.name .. ReadText(1001, 120) .. "  " .. Helper.convertColorToText((entry.value > 0) and Color["text_positive"] or ((entry.value < 0) and Color["text_negative"] or Color["text_normal"])) .. string.format("%+.0f%%", entry.value * 100) .. "\27X"
					end
				end
			end
			local icon = "widget_circle_01"
			local color = Color["icon_inactive"]
			if workforceinfluences.sustainable > workforceinfluences.capacity then
				icon = "widget_arrow_up_01"
				color = Color["text_positive"]
			elseif workforceinfluences.sustainable < workforceinfluences.capacity then
				icon = "widget_arrow_down_01"
				color = Color["text_negative"]
			end
			row[1]:setBackgroundColSpan(4):setColSpan(2):createText(ReadText(1001, 8454) .. ReadText(1001, 120), { mouseOverText = mouseovertext })
			row[3]:createText(Helper.unlockInfo(workforceinfo_all, ConvertIntegerString(workforceinfluences.sustainable, true, 0, true, false)), { halign = "right", mouseOverText = mouseovertext, x = 0 })
			row[4]:createIcon(icon, { color = color, width = Helper.standardTextHeight, height = Helper.standardTextHeight, mouseOverText = mouseovertext })
			-- target
			row = ftable:addRow(true, {  })
			row[1]:setColSpan(2):createText(ReadText(1001, 8455) .. ReadText(1001, 120))
			row[3]:createText(Helper.unlockInfo(workforceinfo_all, ConvertIntegerString(shouldfill and workforceinfluences.capacity or workforceinfluences.target, true, 0, true, false)), { halign = "right", x = 0 })
			-- change
			row = ftable:addRow(true, {  })
			local mouseovertext = ""
			if workforceinfo_all then
				mouseovertext = ReadText(20230, 1001) .. ReadText(1001, 120) .. "  " .. ColorText["text_positive"] .. string.format("%+.0f", workforceinfluences.basegrowth) .. "\27X"
				for i, entry in ipairs(workforceinfluences.growthinfluences) do
					if entry.active then
						mouseovertext = mouseovertext .. "\n· " .. entry.name .. ReadText(1001, 120) .. "  " .. Helper.convertColorToText((entry.value > 0) and Color["text_positive"] or ((entry.value < 0) and Color["text_negative"] or Color["text_normal"])) .. string.format("%+.0f%%", entry.value * 100) .. "\27X"
					end
				end
			end
			local icon = "widget_circle_01"
			local color = nil
			if workforceinfluences.change > 0 then
				icon = "widget_arrow_up_01"
				color = Color["text_positive"]
			elseif workforceinfluences.change < 0 then
				icon = "widget_arrow_down_01"
				color = Color["text_negative"]
			end
			row[1]:setBackgroundColSpan(4):setColSpan(2):createText(ReadText(1001, 8456) .. ReadText(1001, 120), { mouseOverText = mouseovertext })
			row[3]:createText(Helper.unlockInfo(workforceinfo_all, string.format("%+s", ConvertIntegerString(workforceinfluences.change, true, 0, true, false))), { halign = "right", color = color, mouseOverText = mouseovertext, x = 0 })
			row[4]:createIcon(icon, { color = color, width = Helper.standardTextHeight, height = Helper.standardTextHeight, mouseOverText = mouseovertext })

			-- resources
			if workforceinfo_all then
				local resourcedata
				for _, resourceinfo in ipairs(resourceinfos) do
					if resourceinfo.race == race.id then
						resourcedata = resourceinfo
					end
				end
			
				row = ftable:addRow(nil, {  })
				row[1]:setColSpan(4):createText(ReadText(1001, 8451) .. " / " .. ReadText(1001, 102) .. ReadText(1001, 120))
				for i, resource in ipairs(resourcedata.resources) do
					row = ftable:addRow(nil, {  })
					local amount = Helper.round(resource.cycle * 3600 / resource.cycleduration * workforceinfo.current / resourcedata.productamount)
					row[1]:setColSpan(2):createText("   " .. resource.name)
					row[3]:createText(ConvertIntegerString(amount, true, 0, true, false), { halign = "right", x = 0 })
				end
			end
		end
	end

	menu.restoreTableState("nodeTable", ftable)
end

function menu.onExpandCondensateShield(_, ftable, _, nodedata)
	local row = ftable:addRow(nil, {  })
	row[1]:setColSpan(2):createText(ReadText(20104, 92502), { wordwrap = true })

	ftable:addEmptyRow()

	local row = ftable:addRow(nil, {  })
	row[1]:createText(ReadText(30251, 1) .. ReadText(1001, 120))
	row[2]:createText("1" .. ReadText(1001, 42) .. " " .. GetWareData(nodedata.condensateshield, "name"), { halign = "right" })

	menu.restoreTableState("nodeTable", ftable)
end

function menu.onExpandSupply(_, ftable, _, nodedata)
	if nodedata.drones then
		AddUITriggeredEvent(menu.name, "expand_supply", "drones")
	end

	if not menu.supplyUpdateRegistered then
		RegisterEvent("supplyUpdate", menu.supplyUpdate)
		menu.supplyUpdateRegistered = true
	end

	local info_high =		nodedata.drones and C.IsInfoUnlockedForPlayer(menu.container, "units_amount") or C.IsInfoUnlockedForPlayer(menu.container, "defence_status")
	local info_low =		nodedata.drones and C.IsInfoUnlockedForPlayer(menu.container, "units_details") or C.IsInfoUnlockedForPlayer(menu.container, "defence_level")

	ftable:setColWidthPercent(2, 20)
	ftable:setColWidth(3, Helper.scaleY(Helper.standardButtonHeight), false)
	local row

	local supply_auto = {}
	menu.supplyoverride = {}
	menu.supplydefaults = {}
	local canequipships, isplayerowned = GetComponentData(menu.containerid, "canequipships", "isplayerowned")
	if isplayerowned then
		supply_auto["transport"]	= not C.IsSupplyManual(menu.container, "units_trade")
		supply_auto["defence"]		= not C.IsSupplyManual(menu.container, "units_defence")
		supply_auto["build"]		= not C.IsSupplyManual(menu.container, "units_build")
		supply_auto["repair"]		= not C.IsSupplyManual(menu.container, "units_repair")
		supply_auto["missile"]		= not C.IsSupplyManual(menu.container, "missiles")

		local n = C.GetNumSupplyOrders(menu.container, false)
		local buf = ffi.new("SupplyOverride[?]", n)
		n = C.GetSupplyOrders(buf, n, menu.container, false)
		for i = 0, n - 1 do
			local macro = ffi.string(buf[i].macro)
			menu.supplyoverride[macro] = buf[i].amount
		end

		local n = C.GetNumSupplyOrders(menu.container, true)
		local buf = ffi.new("SupplyOverride[?]", n)
		n = C.GetSupplyOrders(buf, n, menu.container, true)
		for i = 0, n - 1 do
			local macro = ffi.string(buf[i].macro)
			menu.supplydefaults[macro] = buf[i].amount
		end
	end

	menu.types = nodedata.drones and config.dronetypes or config.missilestypes
	local currentOrders = 0
	menu.supplies = {}
	for _, supplytypeentry in ipairs(menu.types) do
		menu.supplies[supplytypeentry.type] = {}
		if supplytypeentry.type == "missile" then
			local knownmacros = {}
			local n = C.GetNumBlueprints("", "missiletypes", "")
			local buf = ffi.new("UIBlueprint[?]", n)
			n = C.GetBlueprints(buf, n, "", "missiletypes", "")
			for i = 0, n - 1 do
				macro = ffi.string(buf[i].macro)

				if C.IsContainerAmmoMacroCompatible(menu.container, macro) then
					currentOrders = currentOrders + (menu.supplyoverride[macro] or menu.supplydefaults[macro] or 0)
					table.insert(menu.supplies[supplytypeentry.type], { name = GetMacroData(macro, "name"), macro = macro, stored = 0, compatible = true })
					knownmacros[macro] = #menu.supplies[supplytypeentry.type]
				end
			end

			local n = C.GetNumAllMissiles(menu.container)
			local buf = ffi.new("AmmoData[?]", n)
			n = C.GetAllMissiles(buf, n, menu.container)
			for j = 0, n - 1 do
				local macro = ffi.string(buf[j].macro)
				local amount = buf[j].amount

				if knownmacros[macro] then
					if not supply_auto[supplytypeentry.type] then
						currentOrders = currentOrders + amount
					end
					menu.supplies[supplytypeentry.type][knownmacros[macro]].stored = amount
				else
					if supply_auto[supplytypeentry.type] then
						currentOrders = currentOrders + (menu.supplyoverride[macro] or menu.supplydefaults[macro] or 0)
					else
						currentOrders = currentOrders + amount + (menu.supplyoverride[macro] or menu.supplydefaults[macro] or 0)
					end
					table.insert(menu.supplies[supplytypeentry.type], { name = GetMacroData(macro, "name"), macro = macro, stored = amount, compatible = false })
				end
			end
			menu.supplies[supplytypeentry.type].capacity = GetComponentData(menu.containerid, "missilecapacity")

			table.sort(menu.supplies[supplytypeentry.type], Helper.sortName)
		else
			local units = GetUnitStorageData(menu.containerid, supplytypeentry.type)
			for _, entry in ipairs(units) do
				if supply_auto[supplytypeentry.type] then
					currentOrders = currentOrders + (menu.supplyoverride[entry.macro] or menu.supplydefaults[entry.macro] or 0)
				else
					currentOrders = currentOrders + entry.amount + (menu.supplyoverride[entry.macro] or menu.supplydefaults[entry.macro] or 0)
				end
				table.insert(menu.supplies[supplytypeentry.type], { name = entry.name, macro = entry.macro, stored = entry.amount })
			end
			menu.supplies[supplytypeentry.type].capacity = units.capacity

			table.sort(menu.supplies[supplytypeentry.type], Helper.sortName)
		end
	end

	for _, supplytypeentry in ipairs(menu.types) do
		if (supplytypeentry.type ~= "build") or canequipships then
			if menu.supplies[supplytypeentry.type].capacity > 0 then
				-- title
				row = ftable:addRow(nil, {  })
				row[1]:setColSpan(3):createText(Helper.unlockInfo(info_low, supplytypeentry.name), Helper.subHeaderTextProperties)
				row[1].properties.halign = "center"
				-- auto setting
				local auto
				if isplayerowned then
					auto = supply_auto[supplytypeentry.type]
					row = ftable:addRow(true, {  })
					row[1]:setColSpan(2):createText(supplytypeentry.autoname)
					row[3]:createCheckBox(auto, { height = Helper.standardButtonHeight })
					row[3].handlers.onClick = function (_, checked) return menu.checkboxSupplyAuto(menu.container, supplytypeentry.type, checked) end
				end
				-- available macros
				if #menu.supplies[supplytypeentry.type] > 0 then
					for i, entry in ipairs(menu.supplies[supplytypeentry.type]) do
						
						local limit = 0
						if auto then
							if menu.supplyoverride[entry.macro] then
								limit = menu.supplyoverride[entry.macro]
							else
								limit = menu.supplydefaults[entry.macro] or 0
							end
						end
						-- name
						row = ftable:addRow(true, {  })
						row[1]:createText(Helper.unlockInfo(info_low, entry.name))
						row[2]:setColSpan(2):createText(isplayerowned and function () return menu.supplies[supplytypeentry.type][i].stored .. menu.getManualOrder(entry.macro, auto) .. (auto and (" / " .. (menu.supplyoverride[entry.macro] or menu.supplydefaults[entry.macro] or 0)) or "") end or "", { halign = "right", color = (entry.compatible == false) and Color["text_inactive"] or Color["text_normal"] })
						-- amount
						local start = info_high and (auto and limit or (entry.stored + (menu.supplyoverride[entry.macro] or 0))) or 0
						local max = math.max(0, menu.supplies[supplytypeentry.type].capacity - currentOrders + start)
						local maxSelect = math.min(max, (entry.compatible == false) and entry.stored or max)
						start = math.min(maxSelect, math.max(0, start))
						row = ftable:addRow(true, {  })
						local slidercell = row[1]:setColSpan(3):createSliderCell({
							height = Helper.standardTextHeight,
							valueColor = Color["slider_value"],
							min = 0,
							maxSelect = maxSelect,
							max = max,
							start = start,
							hideMaxValue = true,
							readOnly = not isplayerowned,
						}):setText(ReadText(1001, 8415) .. ReadText(1001, 120), { color = (entry.compatible == false) and Color["text_inactive"] or Color["text_normal"] })
						row[1].handlers.onSliderCellChanged = function (_, value) menu.supplyoverride[entry.macro] = value - (auto and 0 or menu.supplies[supplytypeentry.type][i].stored) end
						row[1].handlers.onSliderCellConfirm = function (id, value) return menu.slidercellSupplyAmount(menu.container, entry.macro, auto, supplytypeentry.type, i, value) end
						row[1].handlers.onSliderCellActivated = function () return menu.slidercellSupplyAmountActivated(entry.macro) end
						row[1].handlers.onSliderCellDeactivated = function (id) menu.noupdate = false end

						if entry.macro == menu.restoreSliderCellInput then
							menu.restoreSliderCellInput = slidercell
						end
					end
				else
					row = ftable:addRow(false, {  })
					row[1]:setColSpan(3):createText(ReadText(1001, 4235))
				end
			end
		end
	end
	
	if isplayerowned then
		-- trade rule
		local hasownlist = C.HasContainerOwnTradeRule(menu.container, "supply", "")
		local traderuleid = C.GetContainerTradeRuleID(menu.container, "supply", "")
		row = ftable:addRow(false, {  })
		row[1]:setColSpan(3):createText("")

		row = ftable:addRow(nil, {  })
		row[1]:setColSpan(3):createText(ReadText(1001, 11030), Helper.subHeaderTextProperties)
		row[1].properties.halign = "center"
		-- global
		local row = ftable:addRow("supplytraderule_global", {  })
		row[1]:setColSpan(2):createText(ReadText(1001, 8367) .. ReadText(1001, 120), textproperties)
		row[3]:createCheckBox(not hasownlist, { height = Helper.standardButtonHeight })
		row[3].handlers.onClick = function(_, checked) return menu.checkboxSetTradeRuleOverride(menu.container, "supply", "", checked) end
		-- current
		local row = ftable:addRow("supplytraderule_current", {  })
		row[1]:setColSpan(2):createDropDown(Helper.traderuleOptions, { startOption = (traderuleid ~= 0) and traderuleid or -1, active = hasownlist }):setTextProperties({ fontsize = config.mapFontSize })
		row[1].handlers.onDropDownConfirmed = function (_, id) return menu.dropdownTradeRule(menu.container, "supply", "", id) end
		row[3]:createButton({ mouseOverText = ReadText(1026, 8407) }):setIcon("menu_edit")
		row[3].handlers.onClick = menu.buttonEditTradeRule
	end

	menu.restoreTableState("nodeTable", ftable)
end

function menu.getManualOrder(macro, auto)
	local manualorder = ""
	if (not auto) and menu.supplyoverride[macro] then
		if menu.supplyoverride[macro] > 0 then
			manualorder = " " .. ColorText["text_positive"] .. "(+" .. menu.supplyoverride[macro] .. ")\27X"
		elseif menu.supplyoverride[macro] < 0 then
			manualorder = " " .. ColorText["text_negative"] .. "(" .. menu.supplyoverride[macro] .. ")\27X"
		end
	end

	return manualorder
end

function menu.slidercellSupplyAmountActivated(macro)
	if menu.refreshnode then
		-- We started slidercell input, but a menu update is pending. Let it update and re-activate input
		menu.restoreSliderCellInput = macro
	else
		menu.noupdate = true
	end
end

function menu.onExpandAccount(_, ftable, _, nodedata)
	local money, productionmoney = GetComponentData(menu.containerid, "money", "productionmoney")
	local supplymoney = tonumber(C.GetSupplyBudget(menu.container)) / 100
	local trademoney = tonumber(C.GetTradeWareBudget(menu.container)) / 100
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
	local numproductionmodules = #GetProductionModules(menu.containerid)
	local numbuildmodules = C.GetNumBuildModules(menu.container)
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
	if row.index == menu.selectedRows.nodeTable then
		menu.selectedRows.nodeTable = menu.selectedRows.nodeTable + 1
	end
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
	row[1]:createButton({ active = function () return (menu.newAccountValue ~= nil) and GetComponentData(menu.containerid, "isplayerowned") end }):setText(ReadText(1001, 2821), { halign = "center" })
	row[1].handlers.onClick = menu.buttonAccountConfirm
	row[2]:createButton({ active = function () local money, estimate, isplayerowned = GetComponentData(menu.containerid, "money", "productionmoney", "isplayerowned"); estimate = estimate + tonumber(C.GetSupplyBudget(menu.container)) / 100; estimate = estimate + tonumber(C.GetTradeWareBudget(menu.container)) / 100; return isplayerowned and ((money + GetPlayerMoney()) > estimate) end }):setText(ReadText(1001, 7965), { halign = "center" })
	row[2].handlers.onClick = menu.buttonAccountToEstimate

	menu.restoreTableState("nodeTable", ftable)
end

function menu.getAccountWarningText()
	local money, productionmoney = GetComponentData(menu.containerid, "money", "productionmoney")
	local supplymoney = tonumber(C.GetSupplyBudget(menu.container)) / 100
	local trademoney = tonumber(C.GetTradeWareBudget(menu.container)) / 100
	local budget = math.floor(productionmoney + supplymoney + trademoney)

	if money < budget then
		if money == 0 then
			return ReadText(1001, 8465)
		else
			return ReadText(1001, 8466)
		end
	end
	return ""
end

function menu.getAccountWarningColor()
	local money, productionmoney = GetComponentData(menu.containerid, "money", "productionmoney")
	local supplymoney = tonumber(C.GetSupplyBudget(menu.container)) / 100
	local trademoney = tonumber(C.GetTradeWareBudget(menu.container)) / 100
	local budget = math.floor(productionmoney + supplymoney + trademoney)

	if money < budget then
		if money == 0 then
			return Color["text_error"]
		else
			return Color["text_warning"]
		end
	end
	return Color["text_normal"]
end

function menu.onExpandDummy(_, ftable, _, nodedata)
	local node = menu.expandedNode
	local maxcaptionlen = 100
	local maxstatuslen = 100

	-- caption and status
	menu.expandedDummyNodeText = node.properties.text.text
	local row = ftable:addRow(true)
	row[1]:createText("Caption length")
	row[2]:createSliderCell({ height = Helper.standardTextHeight, min = 0, max = maxcaptionlen, hideMaxValue = true, start = 10 })
	row[2].handlers.onSliderCellChanged = function(_, value)
		local str = ""
		for i = 1, value do
			str = str .. "-";
		end
		node:updateText(str)
	end

	local row = ftable:addRow(true)
	row[1]:createText("Status length")
	row[2]:createSliderCell({ height = Helper.standardTextHeight, min = 0, max = maxstatuslen, hideMaxValue = true, start = 10 })
	row[2].handlers.onSliderCellChanged = function(_, value)
		if value == maxstatuslen then
			node:updateStatus(nil, "lso_pie_09", "lso_progress")
		else
			local str = ""
			for i = 1, value do
				str = str .. "|";
			end
			node:updateStatus(str)
		end
	end

	if node.properties.max > 0 then
		-- separator
		local row = ftable:addRow(false)
		row[1]:setColSpan(2):createText("", { height = 1 })

		-- bar and sliders
		local row = ftable:addRow(true)
		row[1]:createText("Value")
		row[2]:createSliderCell({ height = Helper.standardTextHeight, min = 0, max = node.properties.max, start = node.properties.value })
		row[2].handlers.onSliderCellChanged = function(_, value) node:updateValue(math.min(value, node.properties.max)) end

		local row = ftable:addRow(true)
		row[1]:createText("Max")
		row[2]:createSliderCell({ height = Helper.standardTextHeight, min = 0, max = node.properties.max, start = node.properties.max, exceedMaxValue = true })
		row[2].handlers.onSliderCellChanged = function(_, value)
			if node.properties.value > value then node:updateValue(value) end
			if node.properties.slider1 > value then node:updateSlider1(value) end
			if node.properties.slider2 > value then node:updateSlider2(value) end
			node:updateMaxValue(value)
		end

		if node.properties.step > 0 then
			-- separator
			local row = ftable:addRow(false)
			row[1]:setColSpan(2):createText("", { height = 1 })

			local row = ftable:addRow(true)
			local sliderenabled = node.properties.slider1 >= 0
			local slidervalue = sliderenabled and node.properties.slider1 or 0
			row[1]:createText("Buy enabled")
			local checkbox = row[2]:createCheckBox(sliderenabled, { width = Helper.standardTextHeight })
			checkbox.handlers.onClick = function(_, checked) sliderenabled = checked; node:updateSlider1(sliderenabled and math.min(slidervalue, node.properties.max) or -1) end
			local row = ftable:addRow(true)
			row[1]:createText("Buy slider")
			row[2]:createSliderCell({ height = Helper.standardTextHeight, min = 0, max = node.properties.max, start = slidervalue })
			row[2].handlers.onSliderCellChanged = function(_, value) slidervalue = value; node:updateSlider1(sliderenabled and math.min(slidervalue, node.properties.max) or -1) end

			local row = ftable:addRow(true)
			local sliderenabled = node.properties.slider2 >= 0
			local slidervalue = sliderenabled and node.properties.slider2 or 0
			row[1]:createText("Sell enabled")
			local checkbox = row[2]:createCheckBox(sliderenabled, { width = Helper.standardTextHeight })
			checkbox.handlers.onClick = function(_, checked) sliderenabled = checked; node:updateSlider2(sliderenabled and math.min(slidervalue, node.properties.max) or -1) end
			local row = ftable:addRow(true)
			row[1]:createText("Sell slider")
			row[2]:createSliderCell({ height = Helper.standardTextHeight, min = 0, max = node.properties.max, start = slidervalue })
			row[2].handlers.onSliderCellChanged = function(_, value) slidervalue = value; node:updateSlider2(sliderenabled and math.min(slidervalue, node.properties.max) or -1) end
		end
	end

	-- separator
	local row = ftable:addRow(false)
	row[1]:setColSpan(2):createText("", { height = 1 })

	-- colors
	menu.expandedDummyNodeColor = node.properties.statusColor or node.properties.outlineColor
	local colorupdatefunc = function(value, colorprop)
		-- important: don't change elements of an existing color table, it may be referenced in several other places already, so always make a new copy first
		local color = { r = menu.expandedDummyNodeColor.r, g = menu.expandedDummyNodeColor.g, b = menu.expandedDummyNodeColor.b, a = menu.expandedDummyNodeColor.a }
		color[colorprop] = value
		menu.expandedDummyNodeColor = color
		node:updateOutlineColor(color)
		for _, edge in ipairs(node.incomingEdges) do
			menu.updateEdgeColorRecursively(edge, color)
		end
	end

	local color = menu.expandedDummyNodeColor
	local row = ftable:addRow(true)
	row[1]:createText("Red")
	row[2]:createSliderCell({ height = Helper.standardTextHeight, min = 0, max = 255, hideMaxValue = true, start = color.r })
	row[2].handlers.onSliderCellChanged = function(_, value) colorupdatefunc(value, "r") end
	local row = ftable:addRow(true)
	row[1]:createText("Green")
	row[2]:createSliderCell({ height = Helper.standardTextHeight, min = 0, max = 255, hideMaxValue = true, start = color.g })
	row[2].handlers.onSliderCellChanged = function(_, value) colorupdatefunc(value, "g") end
	local row = ftable:addRow(true)
	row[1]:createText("Blue")
	row[2]:createSliderCell({ height = Helper.standardTextHeight, min = 0, max = 255, hideMaxValue = true, start = color.b })
	row[2].handlers.onSliderCellChanged = function(_, value) colorupdatefunc(value, "b") end
end

function menu.onCollapseDummy(nodedata)
	menu.expandedNode:updateText(menu.expandedDummyNodeText)
	menu.expandedDummyNodeText = nil
end

function menu.onFlowchartNodeCollapsed(node, frame)
	if menu.expandedNode == node and menu.expandedMenuFrame == frame then
		local data = node.customdata
		local collapseHandler = data.moduledata.collapseHandler
		if collapseHandler then
			collapseHandler(data.nodedata)
		end
		Helper.clearFrame(menu, config.expandedMenuFrameLayer)
		menu.expandedMenuTable = nil
		menu.expandedMenuFrame = nil
		menu.expandedNode = nil
	end
end

function menu.onCollapseSupply(nodedata)
	if nodedata.drones then
		AddUITriggeredEvent(menu.name, "collapse_supply", "drones")
	end

	UnregisterEvent("supplyUpdate", menu.supplyUpdate)
	menu.supplyUpdateRegistered = nil

	menu.types = {}
end

function menu.buttonAccountConfirm()
	if menu.newAccountValue then
		local stationmoney, productionmoney = GetComponentData(menu.containerid, "money", "productionmoney")
		local supplymoney = tonumber(C.GetSupplyBudget(menu.container)) / 100
		local tradewaremoney = tonumber(C.GetTradeWareBudget(menu.container)) / 100
		local estimate = productionmoney + supplymoney + tradewaremoney
		local amount = menu.newAccountValue - stationmoney

		SetMaxBudget(menu.containerid, (menu.newAccountValue * 3) / 2)
		SetMinBudget(menu.containerid, menu.newAccountValue)
		
		if amount > 0 then
			TransferPlayerMoneyTo(amount, menu.containerid)
		else
			TransferMoneyToPlayer(-amount, menu.containerid)
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

function menu.buttonAccountToEstimate()
	local stationmoney, productionmoney = GetComponentData(menu.containerid, "money", "productionmoney")
	local supplymoney = tonumber(C.GetSupplyBudget(menu.container)) / 100
	local tradewaremoney = tonumber(C.GetTradeWareBudget(menu.container)) / 100
	local estimate = productionmoney + supplymoney + tradewaremoney
	local amount = estimate - stationmoney

	SetMaxBudget(menu.containerid, (estimate * 3) / 2)
	SetMinBudget(menu.containerid, estimate)

	if amount > 0 then
		TransferPlayerMoneyTo(amount, menu.containerid)
	else
		TransferMoneyToPlayer(-amount, menu.containerid)
	end

	menu.expandedNode:updateValue(estimate)
	menu.expandedNode:updateMaxValue(estimate)
	menu.newAccountValue = nil
	menu.refreshnode = getElapsedTime() + 0.1
end

function menu.buttonExtend(groupID, row)
	if menu.extendedGroups[groupID] then
		menu.extendedGroups[groupID] = nil
	else
		menu.extendedGroups[groupID] = true
	end

	menu.saveFlowchartState("flowchart", menu.flowchart)
	menu.saveTableState("keyTable", menu.keyTable)
	if menu.expandedNode then
		menu.expandedNode:collapse()
	end
	menu.display()
end

function menu.buttonTimeFrame(type)
	menu.timeframe = type
	if type == "hour" then
		menu.xStart = math.max(0, menu.xEnd - 3600)
		menu.xGranularity = 300
		menu.xScale = 60
		menu.xTitle = ReadText(1001, 6519) .. " [" .. ReadText(1001, 103) .. "]"
	elseif type == "day" then
		menu.xStart = math.max(0, menu.xEnd - (24 * 3600))
		menu.xGranularity = 7200
		menu.xScale = 3600
		menu.xTitle = ReadText(1001, 6519) .. " [" .. ReadText(1001, 102) .. "]"
	elseif type == "week" then
		menu.xStart = math.max(0, menu.xEnd - (7 * 24 * 3600))
		menu.xGranularity = 12 * 3600
		menu.xScale = 24 * 3600
		menu.xTitle = ReadText(1001, 6519) .. " [" .. ReadText(1001, 104) .. "]"
	end
	if menu.xEnd > menu.xStart then
		while ((menu.xEnd - menu.xStart) < menu.xGranularity) and (menu.xGranularity >= (0.001 * menu.xScale)) do
			menu.xGranularity = menu.xGranularity / 2
		end
	end
	
	menu.getData(config.graph.numdatapoints)
	menu.saveFlowchartState("flowchart", menu.flowchart)
	menu.saveTableState("keyTable", menu.keyTable)
	if menu.expandedNode then
		menu.expandedNode:collapse()
	end
	menu.display()
end

function menu.buttonGraphMode(mode)
	menu.graphmode = mode

	if mode == "tradeofferprices" then
		menu.yTitle = ReadText(1001, 6520) .. " [" .. ReadText(1001, 101) .. "]"
	elseif (mode == "tradeofferamounts") or (mode == "cargolevels") then
		menu.yTitle = ReadText(1001, 6521)
	elseif mode == "npcaccounts" then
		menu.yTitle = ReadText(1001, 6522) .. " [" .. ReadText(1001, 101) .. "]"
	end
	menu.getData(config.graph.numdatapoints)
	menu.saveFlowchartState("flowchart", menu.flowchart)
	if menu.expandedNode then
		menu.expandedNode:collapse()
	end
	menu.display()
end

function menu.buttonRightBar(newmenu, params)
	Helper.closeMenuAndOpenNewMenu(menu, newmenu, params, true)
	menu.cleanup()
end

function menu.buttonShowGraph()
	menu.showGraph = not menu.showGraph
	menu.refresh = true
end

function menu.buttonPauseProductionModules(productionmodules, pause)
	for _, module in ipairs(productionmodules) do
		C.PauseProductionModule(module, pause)
	end

	menu.refreshnode = getElapsedTime() + 0.1
end

function menu.buttonPauseProcessingModules(processingmodules, pause)
	for _, module in ipairs(processingmodules) do
		C.PauseProcessingModule(module, pause)
	end

	menu.refreshnode = getElapsedTime() + 0.1
end


function menu.buttonEditTradeRule()
	Helper.closeMenuAndOpenNewMenu(menu, "PlayerInfoMenu", { 0, 0, "globalorders" })
	menu.cleanup()
end

function menu.checkboxSelected(idx, row, col)
	if menu.graphdata[idx].shown or (menu.numshowndata < config.graph.maxshowndata) then
		menu.graphdata[idx].shown = not menu.graphdata[idx].shown
		menu.displayedgraphwares[menu.graphdata[idx].ware] = menu.graphdata[idx].shown or nil
		C.SetStationOverviewGraphWare(menu.container, menu.graphdata[idx].ware, menu.graphdata[idx].shown)
		if menu.graphdata[idx].shown then
			for i = 1, config.graph.maxshowndata do
				if not menu.showndata[i] then
					menu.showndata[i] = idx
					menu.numshowndata = menu.numshowndata + 1
					break
				end
			end
		else
			for i, entry in pairs(menu.showndata) do
				if entry == idx then
					menu.showndata[i] = nil
					menu.numshowndata = menu.numshowndata - 1
					break
				end
			end
		end
		
		menu.saveFlowchartState("flowchart", menu.flowchart)
		menu.saveTableState("keyTable", menu.keyTable, row, col)
		if menu.expandedNode then
			menu.expandedNode:collapse()
		end
		menu.display()
	end
end

function menu.checkboxSupplyAuto(container64, type, checked)
	if type == "transport" then
		C.SetSupplyManual(container64, "units_trade", not checked)
	elseif type == "defence" then
		C.SetSupplyManual(container64, "units_defence", not checked)
	elseif type == "build" then
		C.SetSupplyManual(container64, "units_build", not checked)
	elseif type == "repair" then
		C.SetSupplyManual(container64, "units_repair", not checked)
	elseif type == "missile" then
		C.SetSupplyManual(container64, "missiles", not checked)
	end

	for _, entry in ipairs(menu.supplies[type]) do
		if not checked then
			if menu.supplyoverride[entry.macro] then
				menu.supplyoverride[entry.macro] = menu.supplyoverride[entry.macro] - entry.stored
			end
		else
			if menu.supplyoverride[entry.macro] then
				menu.supplyoverride[entry.macro] = menu.supplyoverride[entry.macro] + entry.stored
			elseif entry.stored ~= 0 then
				menu.supplyoverride[entry.macro] = entry.stored
			end
		end
	end

	menu.updateOverride(container64)
	C.UpdateProductionTradeOffers(container64)

	if menu.numSupplyResources ~= C.GetNumSupplyOrderResources(menu.container) then
		menu.setupFlowchartData()
		menu.restoreNodeSupply = (type == "missile") and "missiles" or "drones"
		menu.refresh = true
	else
		menu.refreshnode = getElapsedTime() + 0.1
	end
end

function menu.checkboxProductionSingle(macro, checked)
	menu.showSingleProduction[macro] = checked or nil

	menu.updateExpandedNode()
end

function menu.checkboxMultiSelect(option, checked)
	menu.contextMenuData.selectedOptions[option] = checked or nil
end

function menu.checkboxToggleMultiSelect(checked)
	for _, entry in ipairs(menu.contextMenuData.options) do
		menu.contextMenuData.selectedOptions[entry.id] = checked or nil
	end
end
	 
function menu.checkboxSetTradeRuleOverride(container, type, ware, checked)
	if checked then 
		C.SetContainerTradeRule(container, -1, type, ware, false)
	else
		local currentid = C.GetContainerTradeRuleID(container, type, ware or "")
		C.SetContainerTradeRule(container, (currentid ~= 0) and currentid or -1, type, ware, true)
	end

	if (type == "buy") or (type == "sell") then
		menu.expandedNode:updateStatus(nil, Helper.isTradeRestricted(menu.container, ware) and "lso_error" or nil, nil, Color["icon_warning"])
	end
	menu.updateExpandedNode()
end

function menu.checkboxSetWorkforceFill(container)
	C.SetContainerWorkforceFillCapacity(container, not C.ShouldContainerFillWorkforceCapacity(container))
	menu.forceNextWorkforceInfluenceUpdate = true
	menu.refreshnode = getElapsedTime()
end

function  menu.dropdownTradeRule(container, type, ware, id)
	C.SetContainerTradeRule(container, tonumber(id), type, ware, true)
	
	if (type == "buy") or (type == "sell") then
		menu.expandedNode:updateStatus(nil, Helper.isTradeRestricted(menu.container, ware) and "lso_error" or nil, nil, Color["icon_warning"])
	end
end

function menu.slidercellAccount(_, value)
	if value then
		menu.newAccountValue = value
	end
end

function menu.slidercellSupplyAmount(container64, macro, auto, type, idx, value)
	if value then
		menu.supplyoverride[macro] = value - (auto and 0 or menu.supplies[type][idx].stored)

		menu.updateOverride(container64)
		C.UpdateProductionTradeOffers(container64)

		if menu.numSupplyResources ~= C.GetNumSupplyOrderResources(menu.container) then
			menu.setupFlowchartData()
			menu.restoreNodeSupply = (type == "missile") and "missiles" or "drones"
			menu.refresh = true
		else
			menu.refreshnode = getElapsedTime() + 0.1
		end
	end
end

function menu.slidercellBuildPriceFactor(container64, value)
	if value then
		C.SetContainerBuildPriceFactor(container64, value / 100)
	end
end

function menu.updateOverride(container64)
	local numoverrides = 0
	for _, _ in pairs(menu.supplyoverride) do
		numoverrides = numoverrides + 1
	end
	local overrides = ffi.new("SupplyOverride[?]", numoverrides)

	local idx = 0
	for macro, amount in pairs(menu.supplyoverride) do
		overrides[idx].macro = Helper.ffiNewString(macro)
		overrides[idx].amount = amount
		idx = idx + 1
	end

	C.UpdateSupplyOverrides(container64, overrides, numoverrides)

	Helper.ffiClearNewHelper()
end

function menu.updateExpandedNode(row, col)
	if menu.expandedNode then
		-- kuertee start: callback
		if callbacks ["updateExpandedNode_at_start"] then
			for _, callback in ipairs (callbacks ["updateExpandedNode_at_start"]) do
				callback(row, col)
			end
		end
		-- kuertee end: callback

		menu.saveTableState("nodeTable", menu.expandedMenuTable, row, col)

		local node = menu.expandedNode
		node:collapse()
		node:expand()

		-- kuertee start: callback
		if callbacks ["updateExpandedNode_at_end"] then
			for _, callback in ipairs (callbacks ["updateExpandedNode_at_end"]) do
				callback(row, col)
			end
		end
		-- kuertee end: callback
	end
end

function menu.getPrimaryJunctionEdgeColor(edges)
	-- Determine incoming edge color based on color of all outgoing edges
	local colorprecedence = {
		Color["text_normal"],
		Color["text_warning"],
		Color["text_error"],
	}
	-- We choose the first color in colorprecedence table that appears on any outgoing edge (ignoring alpha)
	local colorindex = #colorprecedence + 1		-- special index denoting fallback color
	local color = Color["lso_node_inactive"]	-- remember last edge color as fallback color
	for _, edge in ipairs(edges) do
		color = edge.properties.color
		if type(color) == "function" then
			color = color(edge)
		end
		-- Try to set colorindex to a lower index
		for i = 1, colorindex - 1 do
			if color.r == colorprecedence[i].r and color.g == colorprecedence[i].g and color.b == colorprecedence[i].b then
				colorindex = i
				break
			end
		end
		if colorindex == 1 then break end
	end
	return (colorindex <= #colorprecedence) and colorprecedence[colorindex] or color
end

function menu.updateEdgeColorRecursively(edge, color)
	edge:updateColor(color)
	-- If edge source cell is a junction, update the junction's incoming edges as well, based on its outgoing edges
	local cell = edge.sourcecell
	if cell.type == "flowchartjunction" then
		local incomingcolor = menu.getPrimaryJunctionEdgeColor(cell.outgoingEdges)
		for _, incomingedge in ipairs(cell.incomingEdges) do
			menu.updateEdgeColorRecursively(incomingedge, incomingcolor)
		end
	end
end

function menu.getData(numdatapoints)
	menu.numshowndata = 0
	menu.showndata = {}

	local ffiHelper = {}

	menu.graphdata = {}
	if menu.graphmode == "cargolevels" then
		local numstats = 0
		if C.IsComponentClass(menu.container, "container") then
			numstats = C.GetNumCargoStatistics(menu.container, menu.xStart, menu.xEnd, numdatapoints)
		end
		if numstats > 0 then
			local result = ffi.new("UICargoStat[?]", numstats)
			for i = 0, numstats - 1 do
				table.insert(ffiHelper, 1, ffi.new("UICargoStatData[?]", numdatapoints))
				result[i].data = ffiHelper[1]
			end
			numstats = C.GetCargoStatistics(result, numstats, numdatapoints)
			for i = 0, numstats - 1 do
				local ware = ffi.string(result[i].wareid)
				local text = GetWareData(ware, "name")
				menu.graphdata[i + 1] = { shown = false, text = text, ware = ware, data = {} }
				for j = 0, result[i].numdata - 1 do
					menu.graphdata[i + 1].data[j + 1] = { t = tonumber(result[i].data[j].time), y = tonumber(result[i].data[j].amount) }
				end
			end
		end
	elseif (menu.graphmode == "tradeofferprices") or (menu.graphmode == "tradeofferamounts") then
		local numstats = 0
		if C.IsComponentClass(menu.container, "container") then
			numstats = C.GetNumTradeOfferStatistics(menu.container, menu.xStart, menu.xEnd, numdatapoints)
		end
		if numstats > 0 then
			local result = ffi.new("UITradeOfferStat[?]", numstats)
			for i = 0, numstats - 1 do
				table.insert(ffiHelper, 1, ffi.new("UITradeOfferStatData[?]", numdatapoints))
				result[i].data = ffiHelper[1]
			end
			numstats = C.GetTradeOfferStatistics(result, numstats, numdatapoints)
			for i = 0, numstats - 1 do
				local ware = ffi.string(result[i].wareid)
				local text = GetWareData(ware, "name")
				local dataIdx = menu.getDataIdxByWare(ware)
				if not dataIdx then
					table.insert(menu.graphdata, { shown = false, text = text, ware = ware, selldata = {}, buydata = {} })
					dataIdx = #menu.graphdata
				end
				for j = 0, result[i].numdata - 1 do
					local y = 0
					if menu.graphmode == "tradeofferprices" then
						y = tonumber(result[i].data[j].price) / 100
					elseif menu.graphmode == "tradeofferamounts" then
						y = tonumber(result[i].data[j].amount)
					end
					if result[i].isSellOffer then
						menu.graphdata[dataIdx].selldata[j + 1] = { t = tonumber(result[i].data[j].time), y = y }
					else
						menu.graphdata[dataIdx].buydata[j + 1] = { t = tonumber(result[i].data[j].time), y = y }
					end
				end
			end
		end
	elseif menu.graphmode == "npcaccounts" then
		local npcs = Helper.getSuitableControlEntities(menu.containerid, false)
		for i = #npcs, 1, -1 do
			if not C.HasEntityMoneyLogEntries(ConvertIDTo64Bit(npcs[i])) then
				table.remove(npcs, i)
			end
		end
		for i, npc in ipairs(npcs) do
			local result = ffi.new("UIAccountStatData[?]", numdatapoints)
			local numdata = C.GetNPCAccountStatistics(result, numdatapoints, ConvertIDTo64Bit(npc), menu.xStart, menu.xEnd)
			local name, postname, post = GetComponentData(npc, "name", "postname", "poststring")
			local text = postname .. " " .. name
			menu.graphdata[i] = { shown = false, text = text, npc = npc, post = poststring, data = {} }
			-- select the 4 first data sets as default
			if #menu.graphdata <= 4 then
				menu.showndata[i] = npc
			end
			for j = 0, numdata - 1 do
				menu.graphdata[i].data[j + 1] = { t = tonumber(result[j].time), y = tonumber(result[j].money) / 100 }
			end
		end
	end

	table.sort(menu.graphdata, function (a, b) return a.text < b.text end)


	if menu.graphmode ~= "npcaccounts" then
		for ware in pairs(menu.displayedgraphwares) do
			local dataIdx = menu.getDataIdxByWare(ware)
			if not dataIdx then
				menu.displayedgraphwares[ware] = nil
				C.SetStationOverviewGraphWare(menu.container, ware, false)
			end
		end

		for i, entry in ipairs(menu.graphdata) do
			if not menu.graphwaresinit and not menu.isdummy then
				if #menu.showndata < 4 then
					-- default select the 4 first data sets
					table.insert(menu.showndata, entry.ware)
					menu.displayedgraphwares[entry.ware] = true
					C.SetStationOverviewGraphWare(menu.container, entry.ware, true)
				end
			elseif menu.displayedgraphwares[entry.ware] then
				if #menu.showndata < 4 then
					table.insert(menu.showndata, entry.ware)
				else
					menu.displayedgraphwares[entry.ware] = nil
					C.SetStationOverviewGraphWare(menu.container, entry.ware, false)
				end
			end
		end
		menu.graphwaresinit = true
	end

	for i = 1, config.graph.maxshowndata do
		local newdataidx
		if menu.showndata[i] then
			if menu.graphmode ~= "npcaccounts" then
				newdataidx = menu.getDataIdxByWare(menu.showndata[i])
			else
				newdataidx = menu.getDataIdxByNPC(menu.showndata[i])
			end
		end
		if newdataidx then
			menu.showndata[i] = newdataidx
			menu.graphdata[newdataidx].shown = true
			menu.numshowndata = menu.numshowndata + 1
		else
			menu.showndata[i] = nil
		end
	end

	local numgroupeddata = 0
	menu.groupedgraphdata = { }
	if menu.graphmode ~= "npcaccounts" then
		for i, data in ipairs(menu.graphdata) do
			local groupID, groupName = GetWareData(data.ware, "groupID", "groupName")
			local groupIdx = menu.getGroupIdxByID(groupID)
			if groupIdx then
				table.insert(menu.groupedgraphdata[groupIdx], i)
			else
				table.insert(menu.groupedgraphdata, { id = groupID, name = groupName, [1] = i })
			end
		end
	end

	table.sort(menu.groupedgraphdata, Helper.sortName)
end

function menu.getDataIdxByWare(ware)
	for i, data in ipairs(menu.graphdata) do
		if data.ware == ware then
			return i
		end
	end

	return nil
end

function menu.getDataIdxByNPC(npc)
	for i, data in ipairs(menu.graphdata) do
		if IsSameComponent(data.npc, npc) then
			return i
		end
	end

	return nil
end

function menu.getGroupIdxByID(id)
	for i, group in ipairs(menu.groupedgraphdata) do
		if group.id == id then
			return i
		end
	end

	return nil
end

function menu.isGroupExpanded(groupID)
	return menu.extendedGroups[groupID]
end

function menu.newWareReservationCallback(_, data)
	local containerid, ware, reserverid = string.match(data, "(.+);(.+);(.+)")
	if menu.container == ConvertStringTo64Bit(containerid) then
		if menu.expandedNode.customdata.nodedata.ware == ware then
			if not menu.refreshnode then
				menu.refreshnode = getElapsedTime()
			end
		end
	end
end

function menu.getBuildProgress(station, component)
	local buildprogress = 100
	if IsComponentConstruction(ConvertStringTo64Bit(tostring(component))) then
		buildprogress = math.floor(C.GetCurrentBuildProgress(ConvertIDTo64Bit(station)))
	elseif component == 0 then
		buildprogress = "-"
	end

	if (buildprogress == 100) or (buildprogress == -1) then
		return ReadText(1001, 8418)
	else
		return buildprogress .. " %"
	end
end

function menu.getBuildTime(component)
	if IsComponentConstruction(ConvertStringTo64Bit(tostring(component))) then
		local buildingprocessor = GetComponentData(menu.containerid, "buildingprocessor")
		local ismissingresources = GetComponentData(buildingprocessor, "ismissingresources")
		return (ismissingresources and (ColorText["text_warning"] .. "\27[warning] (") or "(") .. ConvertTimeString(C.GetBuildProcessorEstimatedTimeLeft(ConvertIDTo64Bit(buildingprocessor)), "%h:%M:%S") .. ")"
	else
		return ""
	end
end

function menu.getShipBuildProgress(ship, name)
	local buildprogress = math.floor(C.GetCurrentBuildProgress(ship))
	if buildprogress == -1 then
		if not menu.refreshnode then
			menu.refreshnode = getElapsedTime()
		end
	end

	if (buildprogress == 100) or (buildprogress == -1) then
		return name
	else
		return name .. " (" .. buildprogress .. " %)"
	end
end

function menu.supplyUpdate(_, container)
	if menu.container == ConvertStringTo64Bit(tostring(container)) then
		if not menu.refreshnode then
			if not menu.noupdate then
				menu.refreshnode = getElapsedTime() + 0.1
			else
				for _, supplytypeentry in ipairs(menu.types) do
					if supplytypeentry.type == "missile" then
						local n = C.GetNumAllMissiles(menu.container)
						local buf = ffi.new("AmmoData[?]", n)
						n = C.GetAllMissiles(buf, n, menu.container)
						for j = 0, n - 1 do
							local macro = ffi.string(buf[j].macro)
							local amount = buf[j].amount

							local idx = menu.getSupplyIdx(menu.supplies[supplytypeentry.type], macro)
							if idx then
								menu.supplies[supplytypeentry.type][idx].stored = amount
							end
						end
					else
						local units = GetUnitStorageData(menu.containerid, supplytypeentry.type)
						for _, entry in ipairs(units) do
							local idx = menu.getSupplyIdx(menu.supplies[supplytypeentry.type], entry.macro)
							if idx then
								menu.supplies[supplytypeentry.type][idx].stored = entry.amount
							end
						end
					end
				end
			end
		end
	end
end

function menu.getSupplyIdx(array, macro)
	for i, entry in ipairs(array) do
		if entry.macro == macro then
			return i
		end
	end
	return nil
end

function menu.updateProductionNode(node, productionmodules)
	local text = node.customdata.nodedata.text
	local ware = node.customdata.nodedata.ware
	local textcolor = Color["text_normal"]
	local statusicon
	local statusiconmouseovertext = ""
	local statusbgicon
	local statuscolor = Color["flowchart_node_default"]
	local outlinecolor = Color["flowchart_node_default"]

	local progress = 0

	local macrodata = GetLibraryEntry(GetMacroData(productionmodules.macro, "infolibrary"), productionmodules.macro)
	local makerrace = GetMacroData(productionmodules.macro, "makerrace")
	for i, racestring in ipairs(makerrace) do
		text = text .. " (" .. racestring .. ")"
	end

	local total = #productionmodules.destroyedcomponents + productionmodules.numplanned
	if #productionmodules.destroyedcomponents > 0 then
		statusicon = "lso_warning"
		statuscolor = Color["icon_error"]
		statusiconmouseovertext = ColorText["text_error"] .. ReadText(1001, 8428)
		textcolor = Color["text_error"]
		outlinecolor = Color["lso_node_inactive"]
	elseif (#productionmodules.components == 0) and (productionmodules.numplanned > 0) then
		statusicon = "lso_build"
		statuscolor = Color["icon_normal"]
		statusiconmouseovertext = ReadText(1001, 8433)
		textcolor = Color["text_inactive"]
		outlinecolor = Color["lso_node_inactive"]
	end
	local producing, queued = 0, 0
	local isknown = false
	for _, module in ipairs(productionmodules.components) do
		-- components that are already being recycled are in state construction
		if not IsComponentConstruction(module) then
			local proddata = GetProductionModuleData(module)
			if proddata.state ~= "empty" then
				local ishacked, isfunctional, ispausedmanually = GetComponentData(module, "ishacked", "isfunctional", "ispausedmanually")
				local isqueued = true
				for _, product in ipairs(proddata.products) do
					if product.ware == ware then
						isqueued = false
						break
					end
				end
				if ishacked then
					if not statusicon then
						statusicon = "lso_warning"
						statuscolor = Color["icon_error"]
						statusiconmouseovertext = ColorText["text_error"] .. ReadText(1001, 8430)
						textcolor = Color["text_error"]
						outlinecolor = Color["lso_node_error"]
					end
				elseif ispausedmanually then
					if not statusicon then
						statusicon = "lso_pause"
						statuscolor = Color["icon_warning"]
						statusiconmouseovertext = ColorText["text_warning"] .. ReadText(1001, 8448)
						textcolor = Color["text_warning"]
						outlinecolor = Color["lso_node_warning"]
					end
				elseif not isfunctional then
					if not statusicon then
						statusicon = "lso_warning"
						statuscolor = Color["icon_error"]
						statusiconmouseovertext = ColorText["text_error"] .. ReadText(1001, 8429)
						textcolor = Color["text_error"]
						outlinecolor = Color["lso_node_error"]
					end
				elseif (proddata.state == "choosingitem") or (proddata.state == "waitingforstorage") then
					if not statusicon then
						statusicon = "lso_warning"
						statuscolor = Color["icon_error"]
						statusiconmouseovertext = ColorText["text_error"] .. ReadText(1001, 8432)
					end

					for _, entry in ipairs(proddata.products) do
						menu.storagemissing[entry.ware] = true
					end
				elseif proddata.state == "waitingforresources" then
					if not statusicon then
						statusicon = "lso_warning"
						statuscolor = Color["icon_error"]
						statusiconmouseovertext = ColorText["text_error"] .. ReadText(1001, 8431)
						textcolor = Color["text_error"]
					end
				elseif isqueued then
					queued = queued + 1
				else
					producing = producing + 1
					progress = math.max(progress, math.floor((proddata.cycleprogress * 12 / 100) + 0.5))
				end
				if (not isknown) and C.IsInfoUnlockedForPlayer(module, "production_rate") then
					isknown = true
				end
			end
		end
		if not menu.removedModules[tostring(module)] then
			total = total + 1
		end
	end
	if queued == total then
		if not statusicon then
			statusicon = "lso_pause"
			statuscolor = Color["icon_warning"]
			statusiconmouseovertext = ColorText["text_warning"] .. ReadText(1001, 8469)
			textcolor = Color["text_warning"]
		end
	end
	if producing == total then
		text = "(" .. total .. ") " .. text
	else
		text = "(" .. producing .. "/" .. total .. ") " .. text
	end
	
	if not statusicon then
		if producing > 0 then
			statusicon = string.format("lso_pie_%02d", progress)
			statusiconmouseovertext = ReadText(1001, 1607)
			statusbgicon = "lso_progress"
		end
	end

	if not isknown then
		statusicon = nil
		statusbgicon = nil
	end

	node:updateText(text, textcolor)
	node:updateStatus(nil, statusicon, statusbgicon, statuscolor, statusiconmouseovertext)
	node:updateOutlineColor(outlinecolor)

	local cargo = GetComponentData(menu.containerid, "cargo")

	local proddata
	for _, entry in ipairs(macrodata.products) do
		if entry.ware == ware then
			proddata = entry
			break
		end
	end

	if #proddata.resources > 0 then
		for _, resourcedata in ipairs(proddata.resources) do
			if resourcedata.amount > (cargo[resourcedata.ware] or 0) then
				menu.resourcesmissing[resourcedata.ware] = true
			end
		end

		for _, edge in ipairs(node.incomingEdges) do
			local storagenode = menu.findStorageNode(edge)
			local edgecolor = Color["flowchart_edge_default"]
			if menu.resourcesmissing[storagenode.customdata.nodedata.ware] then
				edgecolor = Color["lso_node_error"]
			end
			menu.updateEdgeColorRecursively(edge, edgecolor)
		end
	end
end

function menu.updateProcessingNode(node, processingmodules)
	local text = node.customdata.nodedata.text
	local ware = node.customdata.nodedata.ware
	local textcolor = Color["text_normal"]
	local statusicon
	local statusiconmouseovertext = ""
	local statusbgicon
	local statuscolor = Color["flowchart_node_default"]
	local outlinecolor = Color["flowchart_node_default"]

	local progress = 0

	local macrodata = GetLibraryEntry(GetMacroData(processingmodules.macro, "infolibrary"), processingmodules.macro)
	local makerrace = GetMacroData(processingmodules.macro, "makerrace")
	for i, racestring in ipairs(makerrace) do
		text = text .. " (" .. racestring .. ")"
	end
	local proddata
	for _, entry in ipairs(macrodata.products) do
		if entry.ware == ware then
			proddata = entry
			break
		end
	end

	local total = #processingmodules.destroyedcomponents + processingmodules.numplanned
	if #processingmodules.destroyedcomponents > 0 then
		statusicon = "lso_warning"
		statuscolor = Color["icon_error"]
		statusiconmouseovertext = ColorText["text_error"] .. ReadText(1001, 8428)
		textcolor = Color["text_error"]
		outlinecolor = Color["lso_node_inactive"]
	elseif (#processingmodules.components == 0) and (processingmodules.numplanned > 0) then
		statusicon = "lso_build"
		statuscolor = Color["icon_normal"]
		statusiconmouseovertext = ReadText(1001, 8433)
		textcolor = Color["text_inactive"]
		outlinecolor = Color["lso_node_inactive"]
	end

	local wares = ffi.new("UIWareAmount[?]", 1)
	wares[0].wareid = Helper.ffiNewString(ware)
	wares[0].amount = proddata and proddata.amount or 1
	local isstoragefull = not C.AreWaresWithinContainerProductionLimits(menu.container, wares, 1)

	local producing = 0
	local isknown = false
	for _, module in ipairs(processingmodules.components) do
		-- components that are already being recycled are in state construction
		if not IsComponentConstruction(module) then
			local data = GetProcessingModuleData(module)
			local ishacked, isfunctional, ispausedmanually = GetComponentData(module, "ishacked", "isfunctional", "ispausedmanually")
			if ishacked then
				if not statusicon then
					statusicon = "lso_warning"
					statuscolor = Color["icon_error"]
					statusiconmouseovertext = ColorText["text_error"] .. ReadText(1001, 8430)
					textcolor = Color["text_error"]
					outlinecolor = Color["lso_node_error"]
				end
			elseif ispausedmanually then
				if not statusicon then
					statusicon = "lso_pause"
					statuscolor = Color["icon_warning"]
					statusiconmouseovertext = ColorText["text_warning"] .. ReadText(1001, 8448)
					textcolor = Color["text_warning"]
					outlinecolor = Color["lso_node_warning"]
				end
			elseif not isfunctional then
				if not statusicon then
					statusicon = "lso_warning"
					statuscolor = Color["icon_error"]
					statusiconmouseovertext = ColorText["text_error"] .. ReadText(1001, 8429)
					textcolor = Color["text_error"]
					outlinecolor = Color["lso_node_error"]
				end
			elseif data.state == "waitingforstorage" then
				if not statusicon then
					statusicon = "lso_warning"
					statuscolor = Color["icon_error"]
					statusiconmouseovertext = ColorText["text_error"] .. ReadText(1001, 8432)
				end

				menu.storagemissing[ware] = true
			elseif data.state == "waitingforresources" then
				if not statusicon then
					statusicon = "lso_warning"
					statuscolor = Color["icon_error"]
					statusiconmouseovertext = ColorText["text_error"] .. ReadText(1001, 8431)
					textcolor = Color["text_error"]
				end
			else
				producing = producing + 1
				progress = math.max(progress, math.floor((data.cycleprogress * 12 / 100) + 0.5))
			end
			if (not isknown) and C.IsInfoUnlockedForPlayer(module, "production_rate") then
				isknown = true
			end
		end
		if not menu.removedModules[tostring(module)] then
			total = total + 1
		end
	end
	if producing == total then
		text = "(" .. total .. ") " .. text
	else
		text = "(" .. producing .. "/" .. total .. ") " .. text
	end
	
	if not statusicon then
		if producing > 0 then
			statusicon = string.format("lso_pie_%02d", progress)
			statusiconmouseovertext = ReadText(1001, 7605)
			statusbgicon = "lso_progress"
		else
			statusicon = "mapob_recyclable"
		end
	end

	if not isknown then
		statusicon = nil
		statusbgicon = nil
	end

	node:updateText(text, textcolor)
	node:updateStatus(nil, statusicon, statusbgicon, statuscolor, statusiconmouseovertext)
	node:updateOutlineColor(outlinecolor)

	local cargo = GetComponentData(menu.containerid, "cargo")
	if #proddata.resources > 0 then
		for _, resourcedata in ipairs(proddata.resources) do
			local isprocessed = GetWareData(resourcedata.ware, "isprocessed")
			if (not isprocessed) and (resourcedata.amount > (cargo[resourcedata.ware] or 0)) then
				menu.resourcesmissing[resourcedata.ware] = true
			end
		end

		for _, edge in ipairs(node.incomingEdges) do
			local storagenode = menu.findStorageNode(edge)
			local edgecolor = Color["flowchart_edge_default"]
			if menu.resourcesmissing[storagenode.customdata.nodedata.ware] then
				edgecolor = Color["lso_node_error"]
			end
			menu.updateEdgeColorRecursively(edge, edgecolor)
		end
	end
end

function menu.updateResearchNode(node, researchmodule)
	local text = node.customdata.nodedata.text
	local textcolor = Color["text_normal"]
	local statusicon
	local statusiconmouseovertext = ""
	local statusbgicon
	local statuscolor = Color["flowchart_node_default"]
	local outlinecolor = Color["flowchart_node_default"]

	local proddata = GetProductionModuleData(researchmodule)
	if (proddata.state == "producing") or (proddata.state == "waitingforresources") then
		local progress = math.floor((proddata.cycleprogress * 12 / 100) + 0.5)
	
		if proddata.state == "waitingforresources" then
			statusicon = "lso_warning"
			statuscolor = Color["icon_warning"]
			statusiconmouseovertext = ColorText["text_warning"] .. ReadText(1026, 8412)
		else
			statusicon = string.format("lso_pie_%02d", progress)
			statusbgicon = "lso_progress"
			statusiconmouseovertext = ReadText(1026, 8411)
		end

		node:updateText(text, textcolor)
		node:updateStatus(nil, statusicon, statusbgicon, statuscolor, statusiconmouseovertext)
		node:updateOutlineColor(outlinecolor)

		if proddata.state == "waitingforresources" then
			local cargo = GetComponentData(menu.containerid, "cargo")
			local resources = GetWareData(proddata.blueprintware, "resources")
			for _, resourcedata in ipairs(resources) do
				if resourcedata.amount > (cargo[resourcedata.ware] or 0) then
					menu.resourcesmissing[resourcedata.ware] = true
				end
			end

			for _, edge in ipairs(node.incomingEdges) do
				local storagenode = menu.findStorageNode(edge)
				local edgecolor = Color["flowchart_edge_default"]
				if menu.resourcesmissing[storagenode.customdata.nodedata.ware] then
					edgecolor = Color["lso_node_error"]
				end
				menu.updateEdgeColorRecursively(edge, edgecolor)
			end
		end
	end
end

function menu.updateBuildNode(node, buildmodule)
	local ishacked = GetComponentData(ConvertStringTo64Bit(tostring(buildmodule)), "ishacked")
	if ishacked then
		node:updateStatus(nil, "lso_warning", nil, Color["icon_error"], ColorText["text_error"] .. ReadText(1001, 8426))
	else
		node:updateStatus(nil, nil, nil, nil, "")
	end
end

function menu.updateTerraformingNode(node, project)
	project.project.isongoing = C.IsTerraformingProjectOngoing(project.cluster, project.project.id)
	menu.updateDroneInfo(project.cluster, project.project)
	if project.project.isongoing or ((menu.droneinfo.numbuildsinprogress + menu.droneinfo.numcurrentdeliveries) > 0) then
		node:updateStatus(nil, "lso_pie_00", "lso_progress", Color["flowchart_node_default"], ReadText(1001, 3800))
	else
		node:updateStatus(nil, "lso_warning", nil, Color["icon_error"], ColorText["text_error"] .. menu.terraformingErrorText(project))
	end
end

function menu.updateSupplyResourceNode(node, ware)
	local value = menu.getSupplyResourceValue(ware)
	local max = menu.getSupplyResourceMax(ware)
	if max < node.properties.value then
		node:updateValue(value)
	end
	node:updateMaxValue(max)
	node:updateValue(value)

	local hasrestrictions = C.GetContainerTradeRuleID(menu.container, "supply", ware) > 0
	local statusicon = hasrestrictions and "lso_error" or nil
	local statuscolor = hasrestrictions and Color["icon_warning"] or nil
	local statusiconmouseovertext = hasrestrictions and (ColorText["text_warning"] .. ReadText(1026, 8404)) or ""
	node:updateStatus(nil, statusicon, nil, statuscolor, statusiconmouseovertext)
end

function menu.updateAccountNode(node)
	local money, productionmoney = GetComponentData(menu.containerid, "money", "productionmoney")
	local supplymoney = tonumber(C.GetSupplyBudget(menu.container)) / 100
	local tradewaremoney = tonumber(C.GetTradeWareBudget(menu.container)) / 100
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

function menu.findStorageNode(edge)
	if edge.sourcecell.customdata then
		return edge.sourcecell
	else
		for _, edge in ipairs(edge.sourcecell.incomingEdges) do
			local node = menu.findStorageNode(edge)
			if node then
				return node
			end
		end
	end
end

menu.updateInterval = 0.1

-- hook to update the menu while it is being displayed
function menu.onUpdate()
	if menu.restoreSliderCellInput then
		if type(menu.restoreSliderCellInput) == "table" then
			ActivateSliderCellInput(menu.restoreSliderCellInput.id)
			menu.restoreSliderCellInput = nil
		end
	end

	menu.frame:update()
	if menu.expandedMenuFrame then
		menu.expandedMenuFrame:update()
	end
	if menu.contextFrame then
		menu.contextFrame:update()
	end

	if not menu.noupdate then
		menu.resourcesmissing = {}
		menu.storagemissing = {}
		for _, node in pairs(menu.productionnodes) do
			menu.updateProductionNode(node, node.customdata.moduledata.productionmodules)
		end
		for _, node in pairs(menu.processingnodes) do
			menu.updateProcessingNode(node, node.customdata.moduledata.productionmodules)
		end
		for _, node in pairs(menu.researchnodes) do
			menu.updateResearchNode(node, node.customdata.moduledata.researchmodule)
		end
		for _, node in pairs(menu.buildnodes) do
			if type(node.customdata.moduledata.buildmodule) ~= "table" then
				menu.updateBuildNode(node, node.customdata.moduledata.buildmodule)
			end
		end
		for _, node in pairs(menu.terraformingnodes) do
			menu.updateTerraformingNode(node, node.customdata.moduledata.terraformingproject)
		end
		for _, node in pairs(menu.storagenodes) do
			Helper.updateLSOStorageNode(menu, node, menu.container, node.customdata.nodedata.ware)
		end
		for _, node in pairs(menu.supplyresourcenodes) do
			menu.updateSupplyResourceNode(node, node.customdata.nodedata.ware)
		end
		for _, node in pairs(menu.accountnodes) do
			menu.updateAccountNode(node)
		end

		if menu.refresh then
			menu.refresh = nil

			menu.saveFlowchartState("flowchart", menu.flowchart)
			if menu.keyTable then
				menu.saveTableState("keyTable", menu.keyTable)
			end
			if menu.expandedNode then
				if menu.restoreNodeWare or menu.restoreNodeSupply or menu.restoreNodeSupplyWare or menu.restoreNodeBuildModule then
					menu.saveTableState("nodeTable", menu.expandedMenuTable)
				end
				menu.expandedNode:collapse()
			end
			menu.display()
			return
		end

		if menu.restoreNode and menu.restoreNode.id then
			menu.restoreNode:expand()
			menu.restoreNode = nil
		end

		local curtime = getElapsedTime()
		if menu.refreshnode and (menu.refreshnode < curtime) then
			menu.refreshnode = nil
			menu.updateExpandedNode()
		end
	end
end

function menu.onRowChanged(row, rowdata, uitable)
	if menu.keyTable and (uitable == menu.keyTable.id) then
		if menu.selectedrowdata ~= rowdata then
			menu.selectedrowdata = rowdata
			menu.refresh = true
		end
	end
end

-- hook if the highlighted row is selected
function menu.onSelectElement(table, modified)
end

function menu.closeContextMenu()
	menu.contextTable = nil
	menu.contextFrame = nil
	Helper.clearFrame(menu, config.contextFrameLayer)
	menu.contextMenuData = {}
	menu.contextMenu = nil
end

-- hook if the menu is being closed
function menu.onCloseElement(dueToClose, layer)
	if menu.contextMenu then
		if layer == config.contextFrameLayer then
			menu.closeContextMenu()
		end
		return
	end
	if menu.expandedNode and (dueToClose == "back") then
		menu.expandedNode:collapse()
		return
	end
	if layer == config.expandedMenuFrameLayer then
		menu.expandedNode:collapse()
		return
	end

	if dueToClose == "back" then
		if Helper.checkDiscardStationEditorChanges(menu) then
			return
		end
	end

	if menu.param[3] then
		Helper.closeMenu(menu, dueToClose)
	else
		-- flowchart test through MD conversation
		Helper.closeMenuAndReturn(menu)
	end
	menu.cleanup()
end

-- kuertee start:
function menu.registerCallback (callbackName, callbackFunction)
	-- note 1: format is generally [function name]_[action]. e.g.: in kuertee_menu_transporter, "display_on_set_room_active" overrides the room's active property with the return of the callback.
	-- note 2: events have the word "_on_" followed by a PRESET TENSE verb. e.g.: in kuertee_menu_transporter, "display_on_set_buttontable" is called after all of the rows of buttontable are set.
	-- note 3: new callbacks can be added or existing callbacks can be edited. but commit your additions/changes to the mod's GIT repository.
	-- note 4: search for the callback names to see where they are executed.
	-- note 5: if a callback requires a return value, return it in an object var. e.g. "display_on_set_room_active" requires a return of {active = true | false}.

	-- to find callbacks available for this menu,
	-- reg-ex search for callbacks.*\[\".*\]

	if callbacks [callbackName] == nil then
		callbacks [callbackName] = {}
	end
	table.insert (callbacks [callbackName], callbackFunction)
end

function menu.deregisterCallback(callbackName, callbackFunction)
	-- for i, callback in ipairs(callbacks[callbackName]) do
	if callbacks[callbackName] and #callbacks[callbackName] > 0 then
		for i = #callbacks[callbackName], 1, -1 do
			if callbacks[callbackName][i] == callbackFunction then
				table.remove(callbacks[callbackName], i)
			end
		end
	end
end

function menu.loadModLuas()
	if Helper then
		Helper.loadModLuas(menu.name, "menu_station_overview_uix")
	end
end
-- kuertee end

init()
