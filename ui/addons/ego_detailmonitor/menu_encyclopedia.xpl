-- param == { 0, 0, mode, library, id, object }
-- modes are: "Galaxy", "Factions", "Stations", "Ships", "Weapons", "Equipment", "Licences", and "Wares"
-- see menu.data initialization for libaries

-- ffi setup
local ffi = require("ffi")
local C = ffi.C
ffi.cdef[[
	typedef uint64_t UniverseID;
	typedef struct {
		const char* id;
		const char* name;
		double productiontime;
		double productionamount;
	} ProductionMethodInfo2;
	typedef struct {
		const char* macro;
		const char* ware;
		const char* productionmethodid;
	} UIBlueprint;
	typedef struct {
		const char* name;
		const char* typeclass;
		const char* geology;
		const char* atmosphere;
		const char* population;
		const char* settlements;
		uint32_t nummoons;
		bool hasterraforming;
	} UICelestialBodyInfo2;
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
		const char* environment;
	} UISpaceInfo;
	typedef struct {
		const char* name;
		const char* typeclass;
	} UISunInfo;
	typedef struct {
		uint32_t numsuns;
		uint32_t numplanets;
	} UISystemInfoCounts;
	typedef struct {
		UISpaceInfo space;
		uint32_t numsuns;
		UISunInfo* suns;
		uint32_t numplanets;
		UICelestialBodyInfo2* planets;
	} UISystemInfo2;
	typedef struct {
		const char* wareid;
		uint32_t amount;
	} UIWareAmount;
	typedef struct {
		const char* path;
		const char* group;
	} UpgradeGroup;
	typedef struct {
		const char* sourcetype;
		const char* sourcelocation;
	} WareSource;
	typedef struct {
		const char* transport;
		const char* name;
		int value;
	} WareTransportInfo;
	typedef struct {
		const char* ware;
		int32_t current;
		int32_t max;
	} WareYield;
	typedef struct {
		uint32_t current;
		uint32_t capacity;
		uint32_t optimal;
		uint32_t available;
		uint32_t maxavailable;
		double timeuntilnextupdate;
	} WorkForceInfo;
	const char* GenerateFactionRelationText(const char* factionid);
	uint32_t GetBlueprints(UIBlueprint* result, uint32_t resultlen, const char* set, const char* category, const char* macroname);
	UniverseID GetContextByClass(UniverseID componentid, const char* classname, bool includeself);
	uint32_t GetDefaultMissileStorageCapacity(const char* macroname);
	uint32_t GetDiscoveredSectorResources(WareYield* result, uint32_t resultlen, UniverseID sectorid);
	UniverseID GetFactionRepresentative(const char* factionid);
	uint32_t GetFixedStations(UniverseID* result, uint32_t resultlen, UniverseID spaceid);
	uint32_t GetHQs(UniverseID* result, uint32_t resultlen, const char* factionid);
	UniverseID GetLastPlayerControlledShipID(void);
	uint32_t GetLibraryEntryAliases(const char** result, uint32_t resultlen, const char* librarytypeid, const char* id);
	const char* GetMacroClass(const char* macroname);
	uint32_t GetMoonInfo2(UICelestialBodyInfo2* result, uint32_t resultlen, UniverseID clusterid, uint32_t planetidx);
	uint32_t GetNumBlueprints(const char* set, const char* category, const char* macroname);
	uint32_t GetNumContainedKnownSpaces(UniverseID spaceid);
	uint32_t GetNumContainedKnownUnreadSpaces(UniverseID spaceid);
	uint32_t GetNumDiscoveredSectorResources(UniverseID sectorid);
	uint32_t GetNumFixedStations(UniverseID spaceid);
	uint32_t GetNumHQs(const char* factionid);
	uint32_t GetNumLibraryEntryAliases(const char* librarytypeid, const char* id);
	uint32_t GetNumProductionMethodResources(const char* wareid, const char* productionmethod);
	uint32_t GetNumSectorsByOwner(const char* factionid);
	uint32_t GetNumTerraformingProjects(UniverseID clusterid, bool useevents);
	uint32_t GetNumTradeOfferStatistics(UniverseID containerorspaceid, double starttime, double endtime, size_t numdatapoints);
	UISystemInfoCounts GetNumUISystemInfo(UniverseID clusterid);
	uint32_t GetNumUnreadLibraryEntries(const char* libraryid);
	size_t GetNumUpgradeSlots(UniverseID destructibleid, const char* macroname, const char* upgradetypename);
	size_t GetNumVirtualUpgradeSlots(UniverseID objectid, const char* macroname, const char* upgradetypename);
	uint32_t GetNumWares(const char* tags, bool research, const char* licenceownerid, const char* exclusiontags);
	uint32_t GetNumWareSources(const char* wareid);
	uint32_t GetNumWareTransportTypes(void);
	uint32_t GetPeopleCapacity(UniverseID controllableid, const char* macroname, bool includecrew);
	UniverseID GetPlayerZoneID(void);
	ProductionMethodInfo2 GetProductionMethodInfo(const char* wareid, const char* productionmethod);
	uint32_t GetProductionMethodResources(UIWareAmount* result, uint32_t resultlen, const char* wareid, const char* productionmethod);
	uint32_t GetSectorsByOwner(UniverseID* result, uint32_t resultlen, const char* factionid);
	uint32_t GetTradeOfferStatistics(UITradeOfferStat* result, uint32_t resultlen, size_t numdatapoints);
	bool GetUISystemInfo2(UISystemInfo2* result, UniverseID clusterid);
	uint32_t GetUpgradeGroups(UpgradeGroup* result, uint32_t resultlen, UniverseID destructibleid, const char* macroname);
	UpgradeGroup GetUpgradeSlotGroup(UniverseID destructibleid, const char* macroname, const char* upgradetypename, size_t slot);
	const char* GetUpgradeSlotCurrentMacro(UniverseID defensibleid, UniverseID moduleid, const char* upgradetypename, size_t slot);
	uint32_t GetWares(const char** result, uint32_t resultlen, const char* tags, bool research, const char* licenceownerid, const char* exclusiontags);
	uint32_t GetWareSources(WareSource* result, uint32_t resultlen, const char* wareid);
	uint32_t GetWareTransportTypes(WareTransportInfo* result, uint32_t resultlen);
	bool HasDefaultLoadout2(const char* macroname, bool allowloadoutoverride);
	bool InstallPaintMod(UniverseID objectid, const char* wareid, bool useinventory);
	bool IsFactionAllyToFaction(const char* factionid, const char* otherfactionid);
	bool IsFactionEnemyToFaction(const char* factionid, const char* otherfactionid);
	bool IsFactionHostileToFaction(const char* factionid, const char* otherfactionid);
	bool IsKnownItemRead(const char* libraryid, const char* itemid);
	bool IsKnownRead(UniverseID componentid);
	bool IsKnownToPlayer(UniverseID componentid);
	bool IsUpgradeMacroCompatible(UniverseID defensibleid, UniverseID moduleid, const char* macroname, bool ismodule, const char* upgradetypename, size_t slot, const char* upgrademacroname);
	bool IsVirtualUpgradeMacroCompatible(UniverseID defensibleid, const char* macroname, const char* upgradetypename, size_t slot, const char* upgrademacroname);
	void ReadAllKnownItems(void);
	void ReadAllKnownSpaces(UniverseID spaceid);
	void ReadKnownItem(const char* libraryid, const char* itemid, bool read);
	void SetCheckBoxChecked2(const int checkboxid, bool checked, bool update);
	void SetKnownRead(UniverseID componentid, bool read);
]]

local utf8 = require("utf8")

-- menu variable - used by Helper and used for dynamic variables (e.g. inventory content, etc.)
local menu = {
	name = "EncyclopediaMenu",
	encyclopediaMode = "encyclopedia",
	productionmethod = "default",
}

local config = {
	leftBar = {
		[1] = { name = ReadText(1001, 2400),	icon = "tlt_encyclopedia",			mode = "encyclopedia",		helpOverlayID = "encyclopedia_sidebar_encyclopedia",		helpOverlayText = ReadText(1028, 2401) },
		[2] = { name = ReadText(1001, 8201),	icon = "ency_timeline_01",			mode = "timeline",			helpOverlayID = "encyclopedia_sidebar_timeline_01",			helpOverlayText = ReadText(1028, 2402) },
		[3] = { name = ReadText(1001, 3700),	icon = "ency_ship_comparison_01",	mode = "shipcomparison",	helpOverlayID = "encyclopedia_sidebar_ship_comparison_01",	helpOverlayText = ReadText(1028, 2403)},
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
	librarynames = {
		["moduletypes_production"]		= ReadText(1001, 2421),
		["moduletypes_build"]			= ReadText(1001, 2439),
		["moduletypes_storage"]			= ReadText(1001, 2422),
		["moduletypes_habitation"]		= ReadText(1001, 2451),
		["moduletypes_welfare"]			= ReadText(1001, 9620),
		["moduletypes_defence"]			= ReadText(1001, 2424),
		["moduletypes_dock"]			= ReadText(1001, 2452),
		["moduletypes_processing"]		= ReadText(1001, 9621),
		["moduletypes_other"]			= ReadText(1001, 2453),
		["moduletypes_venture"]			= ReadText(1001, 2454),
		["weapons_lasers"]				= ReadText(1001, 1301),	-- Weapons
		["weapons_missilelaunchers"]	= ReadText(1001, 9030),	-- Missile Launchers
		["weapons_turrets"]				= ReadText(1001, 1319),	-- Turrets
		["weapons_missileturrets"]		= ReadText(1001, 9031),	-- Missile Turrets
		["missiletypes"]				= ReadText(1001, 1304),	-- Missiles
		["mines"]						= ReadText(1001, 1326),	-- Mines
		["bombs"]						= ReadText(1001, 1330),	-- Bombs
		["enginetypes"]					= ReadText(1001, 1103),	-- Engines
		["thrustertypes"]				= ReadText(1001, 8001),	-- Thrusters
		["shieldgentypes"]				= ReadText(1001, 1317),	-- Shield generators
		["satellites"]					= ReadText(1001, 1327),	-- Satellites
		["navbeacons"]					= ReadText(1001, 1328),	-- Navigation Beacons
		["resourceprobes"]				= ReadText(1001, 1329),	-- Resource Probes
		["lasertowers"]					= ReadText(1001, 1333),	-- Laser Towers
		["software"]					= ReadText(1001,   87),	-- Software
		["paintmods"]					= ReadText(1001, 8510),	-- Paint Modifications
		["countermeasures"]				= ReadText(1001, 8063),	-- Countermeasures
	},
	equipmenttags = { "weapon", "turret", "shield", "engine", "thruster", "missile", "drone", "consumables", "countermeasure" },
	consumabletags = { "lasertower", "satellite", "mine", "navbeacon", "resourceprobe" },
	stateKeys = {
		{"mode"},
		{"library"},
		{"id"},
		{"object"},
		{ "searchtext" },
	},
}

-- kuertee start:
local callbacks = {}
-- kuertee end

-- init menu and register with Helper
local function init()
	--print("Initializing Encyclopedia")
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
	unregisterForEvent("inputModeChanged", getElement("Scene.UIContract"), menu.onInputModeChanged)
	menu.topLevelOffsetY = nil

	UnregisterAddonBindings("ego_detailmonitor")

	HideAllShapes()

	menu.title = nil
	menu.mode = nil
	menu.data = {}
	menu.library = nil
	menu.id = nil
	menu.expanded = {}
	menu.details = {}
	menu.object = nil
	menu.selectedrow = nil
	menu.toprow = nil
	menu.activatecutscene = nil
	menu.sortedpurposelist = {}
	menu.printedshipdata = {}
	menu.printedshipsizes = {}

	-- start: alexandretk call-back
	if callbacks ["cleanup"] then		
			for _, callback in ipairs (callbacks ["cleanup"]) do
			callback ()
	    end		
	end
	-- end: alexandretk call-back

	menu.rendertargetmode = nil
	menu.refresh = nil
	menu.delayrendertarget = nil
	menu.delayedrenderobject = {}
	menu.numDetailRows = nil
	menu.encyclopediaMode = "encyclopedia"
	menu.oldobject = nil
	menu.oldlibrary = nil
	menu.oldid = nil
	menu.searchtext = nil
	menu.noupdate = nil

	menu.table_toplevel = nil
	menu.table_sidebar = nil
	menu.table_index = nil
	menu.table_description = nil
	menu.table_detail = nil

	menu.cleanupRenderTarget()

	menu.frame = nil

	-- kuertee start: callback
	if callbacks ["cleanup"] then
		for _, callback in ipairs (callbacks ["cleanup"]) do
			callback ()
		end
	end
	-- kuertee end: callback
end

-- Menu member functions

-- assemble initial data
function menu.onShowMenu(state)
	Helper.setTabScrollCallback(menu, menu.onTabScroll)
	registerForEvent("inputModeChanged", getElement("Scene.UIContract"), menu.onInputModeChanged)

	menu.noupdate = nil

	menu.transporttypes = {}
	local n = C.GetNumWareTransportTypes()
	local buf = ffi.new("WareTransportInfo[?]", n)
	n = C.GetWareTransportTypes(buf, n)
	for i = 0, n - 1 do
		menu.transporttypes[buf[i].value] = { transport = ffi.string(buf[i].transport), name = ffi.string(buf[i].name) }
	end

	menu.holomapcolor = Helper.getHoloMapColors()

	menu.data = {
					["Galaxy"] = {},
					["Races"] = { ["races"] = {} },
					["Factions"] = { ["factions"] = {} },
					["FixedStations"] = {},
					["Stations"] = {
						["moduletypes_production"] = {},
						["moduletypes_build"] = {},
						["moduletypes_storage"] = {},
						["moduletypes_habitation"] = {},
						["moduletypes_welfare"] = {},
						["moduletypes_defence"] = {},
						["moduletypes_dock"] = {},
						["moduletypes_processing"] = {},
						["moduletypes_other"] = {},
						["moduletypes_venture"] = {},
					},
					["Ships"] = {
						["shiptypes_xl"] = {},
						["shiptypes_l"] = {},
						["shiptypes_m"] = {},
						["shiptypes_s"] = {},
						["shiptypes_xs"] = {}
					},
					["Weapons"] = {
						["weapons_lasers"] = {},
						["weapons_missilelaunchers"] = {},
						["weapons_turrets"] = {},
						["weapons_missileturrets"] = {},
						["missiletypes"] = {},
						["mines"] = {},
						["bombs"] = {}
					},
					["Equipment"] = {
						["enginetypes"] = {},
						["thrustertypes"] = {},
						["shieldgentypes"] = {},
						["satellites"] = {},
						["navbeacons"] = {},
						["resourceprobes"] = {},
						["lasertowers"] = {},
						["software"] = {},
						["paintmods"] = {}
					},
					["Licences"] = { ["licences"] = {} },
					["Wares"] = {
						["wares"] = {},
						["inventory_wares"] = {}
					},
					["Blueprints"] = {
						["modules"]		= {},
						["ships"]		= {},
						["equipment"]	= {},
					},
				}

	menu.sortedpurposelist = { "fight", "trade", "mine", "build", "misc" }

	-- start: alexandretk call-back
	if callbacks ["onShowMenu_override_menu_printed_variables"] then		
		local printedshipdata_override = {}
		local printedshipsizes_override = {}
		local printedmilxlcapshiptype_override = {}
		local printedmillcapshiptypes_override = {}
		for _, callback in ipairs (callbacks ["onShowMenu_override_menu_printed_variables"]) do
			printedshipsizes_override,printedshipdata_override,printedmilxlcapshiptype_override,printedmillcapshiptypes_override = callback()
			menu.printedshipdata = printedshipdata_override
			menu.printedshipsizes = printedshipsizes_override
			menu.printedmilitaryxlcapitalshiptypes =  printedmilxlcapshiptype_override
			menu.printedmilitarylcapitalshiptypes =  printedmillcapshiptypes_override
		end
		-- end: alexandretk call-back
	else

		menu.printedshipsizes = { "capital", "noncapital" }
		menu.printedshipdata = { 
		trade = {
			text = ReadText(1001, 9010),									-- "Trading Ships"
			capital = {text = ReadText(1001, 9022), ships = {}},			-- "Heavy Freighters"
			noncapital = {text = ReadText(1001, 9023), ships = {}}},		-- "Light Freighters"
		fight = {
			text = ReadText(1001, 9011),									-- "Combat Ships"
			capital = {text = ReadText(1001, 9024), ships = {}},			-- "Carriers and Destroyers"
			noncapital = {text = ReadText(1001, 9025), ships = {}}},		-- "Fighters and Support Ships"
		build = {
			text = ReadText(1001, 9012),									-- "Construction Ships"
			capital = {text = ReadText(1001, 9026), ships = {}},			-- "Heavy Construction Ships"
			noncapital = {text = ReadText(1001, 9027), ships = {}}},		-- "Light Construction Ships"
		mine = {
			text = ReadText(1001, 9013),									-- "Mining Ships"
			capital = {text = ReadText(1001, 9028), ships = {}},			-- "Heavy Mining Ships"
			noncapital = {text = ReadText(1001, 9029), ships = {}}},		-- "Light Mining Ships"
		misc = {
			text = ReadText(1001, 9014),									-- "Other Ships"
			capital = {text = ReadText(1001, 9020), ships = {}},			-- "Heavy"
			noncapital = {text = ReadText(1001, 9021), ships = {}}}			-- "Light"
		}

	end

	menu.index = {
		["Stations"] = {
			name = ReadText(1001, 9610),
			{ key = "moduletypes_production" },
			{ key = "moduletypes_build" },
			{ key = "moduletypes_storage" },
			{ key = "moduletypes_habitation" },
			{ key = "moduletypes_welfare" },
			{ key = "moduletypes_defence" },
			{ key = "moduletypes_dock" },
			{ key = "moduletypes_processing" },
			{ key = "moduletypes_other" },
			{ key = "moduletypes_venture" },
		},
		["Weapons"] = {
			name = ReadText(1001, 2417),
			{ key = "weapons_lasers" },
			{ key = "weapons_missilelaunchers" },
			{ key = "weapons_turrets" },
			{ key = "weapons_missileturrets" },
			{ key = "missiletypes" },
			{ key = "mines" },
			{ key = "bombs" },
		},
		["Equipment"] = {
			name = ReadText(1001, 7935),
			{ key = "enginetypes" },
			{ key = "thrustertypes" },
			{ key = "shieldgentypes" },
			{ key = "satellites" },
			{ key = "navbeacons" },
			{ key = "resourceprobes" },
			{ key = "lasertowers" },
			{ key = "software" },
			{ key = "paintmods" },
		},
		["Blueprints"] = {
			name = ReadText(1001, 98),
			[1] = { key = "modules",	name = ReadText(1001, 7924),	description = ReadText(1001, 9095), subcategories = {
				{ key = "moduletypes_production" },
				{ key = "moduletypes_build" },
				{ key = "moduletypes_storage" },
				{ key = "moduletypes_habitation" },
				{ key = "moduletypes_welfare" },
				{ key = "moduletypes_defence" },
				{ key = "moduletypes_dock" },
				{ key = "moduletypes_processing" },
				{ key = "moduletypes_other" },
				{ key = "moduletypes_venture" },
			}},
			[2] = { key = "ships",		name = ReadText(1001, 6),		description = ReadText(1001, 9096), subcategories = {
				{ key = "ship_xl" },
				{ key = "ship_l" },
				{ key = "ship_m" },
				{ key = "ship_s" },
			}},
			[3] = { key = "equipment",	name = ReadText(1001, 7935),	description = ReadText(1001, 9097), subcategories = {
				{ key = "weapons_lasers" },
				{ key = "weapons_missilelaunchers" },
				{ key = "weapons_turrets" },
				{ key = "weapons_missileturrets" },
				{ key = "missiletypes" },
				{ key = "mines" },
				{ key = "bombs" },
				{ key = "enginetypes" },
				{ key = "thrustertypes" },
				{ key = "shieldgentypes" },
				{ key = "satellites" },
				{ key = "navbeacons" },
				{ key = "resourceprobes" },
				{ key = "lasertowers" },
				{ key = "countermeasures" },
				{ key = "software" },
				{ key = "paintmods" },
			}},
		},
	}

	-- Galaxy
	local clusters = GetClusters(true)
	local sectors = {}
	for _, cluster in ipairs(clusters) do
		local name, description, systemid = GetComponentData(cluster, "name", "description", "systemid")
		sectors = GetSectors(cluster)
		for i, sector in ipairs(sectors) do
			sectors[i] = { sector = sector, name = GetComponentData(sector, "name") }
		end
		--print("INIT cluster: " .. tostring(cluster))
		if systemid ~= 0 then
			local idx
			for i, entry in ipairs(menu.data["Galaxy"]) do
				if entry.systemid == systemid then
					idx = i
					break
				end
			end
			if idx then
				table.insert(menu.data["Galaxy"][idx].clusters, cluster)
				for _, sector in ipairs(sectors) do
					table.insert(menu.data["Galaxy"][idx].sectors, sector)
				end
			else
				table.insert(menu.data["Galaxy"], { name = name, description = description, systemid = systemid, clusters = { cluster }, sectors = sectors, systeminfo = menu.getSystemInfo(ConvertStringTo64Bit(tostring(cluster))) })
			end
		else
			table.insert(menu.data["Galaxy"], { name = name, description = description, systemid = systemid, clusters = { cluster }, sectors = sectors, systeminfo = menu.getSystemInfo(ConvertStringTo64Bit(tostring(cluster))) })
		end
		--print("numclusters: " .. #menu.data["Galaxy"] .. " cluster: " .. tostring(cluster) .. " numsectors: " .. #sectors)
		--print("registered " .. #menu.data["Galaxy"][cluster] .. " sectors in " .. GetComponentData(cluster, "name") .. ".")
	end
	table.sort(menu.data["Galaxy"], Helper.sortName)
	for _, entry in ipairs(menu.data["Galaxy"]) do
		table.sort(entry.sectors, Helper.sortName)
	end

	-- licences of known factions are known as well (see playerinfo menu)
	local factionlibrary = GetLibrary("factions")
	for i, faction in ipairs(factionlibrary) do
		if faction.id ~= "player" then
			local licences = GetOwnLicences(faction.id)
			for i, licence in ipairs(licences) do
				AddKnownItem("licences", licence.id)
			end
		end
	end

	-- Fixed stations
	local stationlibrary = GetLibrary("stationtypes")
	for _, stationentry in ipairs(stationlibrary) do
		if GetMacroData(stationentry.id, "isfixedstation") then
			table.insert(menu.data["FixedStations"], { macro = stationentry.id, name = stationentry.name })
		end
	end
	local n = C.GetNumFixedStations(0)
	if n > 0 then
		local buf = ffi.new("UniverseID[?]", n)
		n = C.GetFixedStations(buf, n, 0)
		for i = 0, n - 1 do
			if C.IsKnownToPlayer(buf[i]) then
				table.insert(menu.data["FixedStations"], { component = buf[i], name = ffi.string(C.GetComponentName(buf[i])) })
			end
		end
	end
	table.sort(menu.data["FixedStations"], Helper.sortName)
	for i = #menu.data["FixedStations"] - 1, 1, -1 do
		if menu.data["FixedStations"][i].name == menu.data["FixedStations"][i + 1].name then
			table.remove(menu.data["FixedStations"], i)
		end
	end

	local numblueprints = C.GetNumBlueprints("", "", "")
	local blueprints = ffi.new("UIBlueprint[?]", numblueprints)
	numblueprints = C.GetBlueprints(blueprints, numblueprints, "", "", "")
	local playerblueprints = {}
	for i = 0, numblueprints - 1 do
		local ware = ffi.string(blueprints[i].ware)
		playerblueprints[ware] = true
		--[[
		local isship, isequipment, ismodule, macro, name = GetWareData(ware, "isship", "isequipment", "ismodule", "component", "name")
		if macro ~= "" then
			local macroclass = ffi.string(C.GetMacroClass(macro))
			local librarytype = GetMacroData(macro, "infolibrary")
			if isship then
				if menu.data["Blueprints"]["ships"][macroclass] then
					table.insert(menu.data["Blueprints"]["ships"][macroclass], { ware = ware, name = name, owned = true, unlocked = true })
				else
					local sizename
					if macroclass == "ship_xl" then
						sizename = ReadText(1001, 11003)
					elseif macroclass == "ship_l" then
						sizename = ReadText(1001, 11002)
					elseif macroclass == "ship_m" then
						sizename = ReadText(1001, 11001)
					elseif macroclass == "ship_s" then
						sizename = ReadText(1001, 11000)
					end
					if sizename then
						menu.data["Blueprints"]["ships"][macroclass] = { name = sizename, { ware = ware, name = name, owned = true, unlocked = true } }
					end
				end
			elseif isequipment then
				if menu.data["Blueprints"]["equipment"][librarytype] then
					table.insert(menu.data["Blueprints"]["equipment"][librarytype], { ware = ware, name = name, owned = true, unlocked = true })
				else
					menu.data["Blueprints"]["equipment"][librarytype] = { name = config.librarynames[librarytype], { ware = ware, name = name, owned = true, unlocked = true } }
				end
			elseif ismodule then
				if menu.data["Blueprints"]["modules"][librarytype] then
					table.insert(menu.data["Blueprints"]["modules"][librarytype], { ware = ware, name = name, owned = true, unlocked = true })
				else
					menu.data["Blueprints"]["modules"][librarytype] = { name = config.librarynames[librarytype], { ware = ware, name = name, owned = true, unlocked = true } }
				end
			end
		end--]]
	end

	-- equipment
	for i, equipmenttag in ipairs(config.equipmenttags) do
		local concattag = equipmenttag
		if equipmenttag == "consumables" then
			concattag = ""
			for _, tag in ipairs(config.consumabletags) do
				concattag = concattag .. " " .. tag
			end
		end
		local numwares = C.GetNumWares(concattag, false, nil, "noplayerblueprint")
		local wares = ffi.new("const char*[?]", numwares)
		numwares = C.GetWares(wares, numwares, concattag, false, nil, "noplayerblueprint")
		for j = 0, numwares - 1 do
			local locware = ffi.string(wares[j])
			local macro, name, ismissiononly = GetWareData(locware, "component", "name", "ismissiononly")
			local hasinfoalias, librarytype
			if macro ~= "" then
				hasinfoalias, librarytype = GetMacroData(macro, "hasinfoalias", "infolibrary")
			end
			if equipmenttag == "countermeasure" then
				librarytype = "countermeasures"
			end
			if not hasinfoalias and librarytype then
				local owned = playerblueprints[locware]
				if menu.data["Blueprints"]["equipment"][librarytype] then
					table.insert(menu.data["Blueprints"]["equipment"][librarytype], { ware = locware, name = name, owned = owned, unlocked = IsKnownItem(librarytype, macro), hidden = ismissiononly and (not owned) })
				else
					menu.data["Blueprints"]["equipment"][librarytype] = { name = config.librarynames[librarytype], { ware = locware, name = name, owned = owned, unlocked = IsKnownItem(librarytype, macro), hidden = ismissiononly and (not owned) } }
				end
			end
		end
	end
	-- modules, ships
	local blueprinttags = { "module", "ship" }
	for _, tag in ipairs(blueprinttags) do
		local numwares = C.GetNumWares(tag, false, nil, "noplayerblueprint")
		local wares = ffi.new("const char*[?]", numwares)
		numwares = C.GetWares(wares, numwares, tag, false, nil, "noplayerblueprint")
		for i = 0, numwares-1 do
			local locware = ffi.string(wares[i])
			local hasblueprint, macro, name, ismissiononly = GetWareData(locware, "hasblueprint", "component", "name", "ismissiononly")
			local macroclass, librarytype, macroicon
			if macro ~= "" then
				macroclass = ffi.string(C.GetMacroClass(macro)) or ""
				librarytype, macroicon = GetMacroData(macro, "infolibrary", "icon")
			end
			if hasblueprint then
				local owned = playerblueprints[locware]
				if tag == "ship" then
					if macroicon then
						name = "\27[" .. macroicon .. "] " .. name
					end
					if menu.data["Blueprints"]["ships"][macroclass] then
						table.insert(menu.data["Blueprints"]["ships"][macroclass], { ware = locware, name = name, owned = owned, unlocked = IsKnownItem(librarytype, macro), hidden = ismissiononly and (not owned) })
					else
						local sizename
						if macroclass == "ship_xl" then
							sizename = ReadText(1001, 11003)
						elseif macroclass == "ship_l" then
							sizename = ReadText(1001, 11002)
						elseif macroclass == "ship_m" then
							sizename = ReadText(1001, 11001)
						elseif macroclass == "ship_s" then
							sizename = ReadText(1001, 11000)
						end
						if sizename then
							menu.data["Blueprints"]["ships"][macroclass] = { name = sizename, { ware = locware, name = name, owned = owned, unlocked = IsKnownItem(librarytype, macro), hidden = ismissiononly and (not owned) } }
						end
					end
				else
					if menu.data["Blueprints"]["modules"][librarytype] then
						table.insert(menu.data["Blueprints"]["modules"][librarytype], { ware = locware, name = name, owned = owned, unlocked = IsKnownItem(librarytype, macro), hidden = ismissiononly and (not owned) })
					else
						menu.data["Blueprints"]["modules"][librarytype] = { name = config.librarynames[librarytype], { ware = locware, name = name, owned = owned, unlocked = IsKnownItem(librarytype, macro), hidden = ismissiononly and (not owned) } }
					end
				end
			end
		end
	end

	for _, entry in pairs(menu.data["Blueprints"]) do
		for _, data in pairs(entry) do
			table.sort(data, Helper.sortName)
		end
	end

	for category in pairs(menu.data) do
		if (category ~= "Factions") and (category ~= "Galaxy") and (category ~= "Blueprints") and (category ~= "FixedStations") then
			for subcategory in pairs(menu.data[category]) do
				--print("category: " .. tostring(category) .. ", subcategory: " .. tostring(subcategory))
				menu.data[category][subcategory] = GetLibrary(subcategory)
				table.sort(menu.data[category][subcategory], Helper.sortName)
			end
		end
	end

	-- Factions
	for i, faction in ipairs(factionlibrary) do
		if faction.id == "player" then
			C.ReadKnownItem("factions", faction.id, true)
		else
			local factionlicences = {}
			for _, licence in pairs(menu.data.Licences.licences) do
				if licence.parent == faction.id and type(licence) == "table" then
					table.insert(factionlicences, licence)
				end
			end
			factionlibrary[i].numlicences = #factionlicences
			factionlibrary[i].licences = factionlicences
			local allies = {}
			local enemies = {}
			local hostiles = {}
			for j, faction2 in ipairs(factionlibrary) do
				if faction.id ~= faction2.id then
					if C.IsFactionHostileToFaction(faction.id, faction2.id) then
						table.insert(hostiles, { id = faction2.id, name = GetFactionData(faction2.id, "name") })
						--print(tostring(faction.id) .. " enemies with " .. tostring(faction2.id))
					elseif C.IsFactionEnemyToFaction(faction.id, faction2.id) then
						table.insert(enemies, { id = faction2.id, name = GetFactionData(faction2.id, "name") })
						--print(tostring(faction.id) .. " enemies with " .. tostring(faction2.id))
					elseif C.IsFactionAllyToFaction(faction.id, faction2.id) then
						table.insert(allies, { id = faction2.id, name = GetFactionData(faction2.id, "name") })
						--print(tostring(faction.id) .. " allied with " .. tostring(faction2.id))
					end
				end
			end
			table.sort(hostiles, Helper.sortName)
			table.sort(enemies, Helper.sortName)
			table.sort(allies, Helper.sortName)
			factionlibrary[i].allies = allies
			factionlibrary[i].enemies = enemies
			factionlibrary[i].hostiles = hostiles
			local sectors = {}
			Helper.ffiVLA(sectors, "UniverseID", C.GetNumSectorsByOwner, C.GetSectorsByOwner, faction.id)
			for i = #sectors, 1, -1 do
				if not C.IsKnownToPlayer(ConvertStringTo64Bit(tostring(sectors[i]))) then
					table.remove(sectors, i)
				end
			end
			factionlibrary[i].numsectors = #sectors
			factionlibrary[i].sectors = sectors
			table.insert(menu.data.Factions.factions, factionlibrary[i])
		end
	end
	table.sort(menu.data.Factions.factions, function (a, b) return a.name < b.name end)
	--print("registered " .. #menu.data["Factions"] .. " factions.")

	local sortedsizelist = { "shiptypes_xl", "shiptypes_l", "shiptypes_m", "shiptypes_s", "shiptypes_xs" }
	for _, size in ipairs(sortedsizelist) do
		for _, shipdata in ipairs(menu.data.Ships[size]) do

			-- start: alexandretk call-back
			if callbacks ["onShowMenu_override_sizecategory"] then
				local purpose, shiptypename, shipicon = GetMacroData(shipdata.id, "primarypurpose", "shiptypename", "icon")
				local sizecategory = "noncapital"
				for _, callback in ipairs (callbacks ["onShowMenu_override_sizecategory"]) do
					callback(menu,shipdata,size,purpose,typecategory,sizecategory,shiptypename,shipicon)
				end
			else
			-- end: alexandretk call-back

				local purpose = GetMacroData(shipdata.id, "primarypurpose")
				local sizecategory = "noncapital"
				if size == "shiptypes_xl" or size == "shiptypes_l" then
					sizecategory = "capital"
				end
				if purpose == "auxiliary" then
					-- sic! We want auxiliary ships to show up in the "support" category under combat
					purpose = "fight"
					sizecategory = "noncapital"
				elseif not menu.printedshipdata[purpose] then
					purpose = "misc"
				end
				shipdata.librarycategory = size
				table.insert(menu.printedshipdata[purpose][sizecategory].ships, shipdata)
			end
		end

	end

	menu.title = ReadText(1001, 2400)	-- Encyclopedia
	menu.mode = menu.param[3]
	menu.library = menu.param[4]
	menu.id = menu.param[5]
	if menu.mode == "Galaxy" then
		menu.object = menu.param[6]
	end
	menu.expanded = {}
	menu.details = {}

	if state then
		menu.onRestoreState(state)
	end

	if menu.mode == "Galaxy" then
		menu.expanded["Galaxy"] = true
		for i, entry in ipairs(menu.data["Galaxy"]) do
			if type(menu.object) == "number" then
				if i == menu.object then
					menu.details = entry
					break
				end
			else
				for _, cluster in ipairs(entry.clusters) do
					if IsSameComponent(cluster, menu.object) then
						menu.object = i
						menu.details = entry
						break
					end
				end
				if next(menu.details) then
					break
				end
				for _, sector in ipairs(entry.sectors) do
					if IsSameComponent(sector.sector, menu.object) then
						menu.expanded[i] = true
						menu.details = entry
						break
					end
				end
				if next(menu.details) then
					break
				end
			end
		end
		--print("menu.object: " .. tostring(menu.object))
		if (type(menu.object) ~= "number") and IsComponentClass(menu.object, "sector") then
			local cluster = GetComponentData(menu.object, "clusterid")
			menu.expanded[cluster] = true
			--print("INPUT cluster: " .. tostring(cluster) .. ", expanded? " .. tostring(menu.expanded[cluster]))
		end
	elseif menu.mode == "Blueprints" then
		for object, entry in pairs(menu.index["Blueprints"]) do
			if entry.key == menu.library then
				menu.library = nil
				menu.object = object
				menu.details = menu.data["Blueprints"][entry.key]
				menu.expanded["Blueprints"] = true
				break
			end
		end
	elseif menu.library and menu.id then
		if menu.mode == nil then
			for mode, data in pairs(menu.data) do
				for library in pairs(data) do
					if library == menu.library then
						menu.mode = mode
						break
					end
				end
				if menu.mode then
					break
				end
			end
		end
		if menu.mode then
			menu.expanded[menu.mode] = true
			menu.object = GetLibraryEntry(menu.library, menu.id)
			menu.details.id = menu.param[5]
			if (menu.mode ~= "Factions") and (menu.mode ~= "Licences") and (menu.mode ~= "Races") then
				local locware = menu.id
				if (menu.library ~= "inventory_wares") and (menu.library ~= "wares") and (menu.library ~= "software") and (menu.library ~= "paintmods") then
					locware = GetMacroData(locware, "ware")
				end

				if locware then
					menu.initWareData(locware)
				end

				if (menu.mode == "Stations") and (menu.library ~= "stationtypes") then
					menu.details.turrettotal = 0
					menu.details.shieldtotal = 0

					local n = C.GetNumUpgradeGroups(0, menu.id)
					local buf = ffi.new("UpgradeGroup[?]", n)
					n = C.GetUpgradeGroups(buf, n, 0, menu.id)
					for i = 0, n - 1 do
						if (ffi.string(buf[i].path) ~= "..") or (ffi.string(buf[i].group) ~= "") then
							local group = { path = ffi.string(buf[i].path), group = ffi.string(buf[i].group) }

							local groupinfo = C.GetUpgradeGroupInfo(0, menu.id, group.path, group.group, "turret")
							menu.details.turrettotal = menu.details.turrettotal + groupinfo.total

							groupinfo = C.GetUpgradeGroupInfo(0, menu.id, group.path, group.group, "shield")
							menu.details.shieldtotal = menu.details.shieldtotal + groupinfo.total
						end
					end
				end

				if menu.mode == "Ships" then
					local purpose = GetMacroData(menu.id, "primarypurpose")
					local sizecategory = "noncapital"
					if IsMacroClass(menu.id, "ship_xl") or IsMacroClass(menu.id, "ship_l") then
						sizecategory = "capital"
					end

					-- start: alexandretk call-backs
					if sizecategory == "capital" and callbacks ["onShowMenu_override_capitalsizecategory"] then
						local purpose, shiptypename, shipicon = GetMacroData(shipdata.id, "primarypurpose", "shiptypename", "icon")
						local sizecategory = "noncapital"
						for _, callback in ipairs (callbacks ["onShowMenu_override_capitalsizecategory"]) do
							callback(menu,size,purpose,typecategory,sizecategory,shiptypename,shipicon)
						end
					else
					-- end: alexandretk call-backs

						if purpose == "auxiliary" then
							-- sic! We want auxiliary ships to show up in the "support" category under combat
							purpose = "fight"
							sizecategory = "noncapital"
						elseif not menu.printedshipdata[purpose] then
							purpose = "misc"
						end
						menu.expanded[purpose] = true
						menu.expanded[purpose .. sizecategory] = true

					end
				else
					menu.expanded[menu.library] = true
				end
			elseif menu.mode == "Factions" then
				for _, entry in ipairs(menu.data["Factions"][menu.library]) do
					if entry.id == menu.id then
						menu.details = entry
					end
				end
			end
		else
			print("menu_encyclopedia.lua, menu.onShowMenu(): No matching mode for given encyclopedia entry found! Probably an unsupported infolibrary type. (" .. menu.library .. ", " .. menu.id .. ")")
			menu.library = nil
			menu.id = nil
			menu.object = nil
		end
	else
		menu.object = nil
	end
	menu.toprow = nil
	menu.delayrendertarget = true

	--print("registered " .. #menu.data["Stations"]["stationtypes"] .. " station types, " .. #menu.data["Stations"]["moduletypes_production"] .. " production modules, " .. #menu.data["Stations"]["moduletypes_build"] .. " build modules, " .. #menu.data["Stations"]["moduletypes_storage"] .. " storage modules, " .. #menu.data["Stations"]["moduletypes_habitation"] .. " habitation modules, " .. #menu.data["Stations"]["moduletypes_welfare"] .. " welfare modules, " .. #menu.data["Stations"]["moduletypes_defence"] .. " defence modules, " .. #menu.data["Stations"]["moduletypes_dock"] .. " dock modules, " .. #menu.data["Stations"]["moduletypes_processing"] .. " processing modules, and " .. #menu.data["Stations"]["moduletypes_other"] .. " miscellaneous modules.")
	--print("registered " .. #menu.data["Ships"]["shiptypes_xl"] .. " XL ship types, " .. #menu.data["Ships"]["shiptypes_l"] .. " L ship types, " .. #menu.data["Ships"]["shiptypes_m"] .. " M ship types, " .. #menu.data["Ships"]["shiptypes_s"] .. " S ship types, and " .. #menu.data["Ships"]["shiptypes_xs"] .. " XS ship types.")
	--print("registered " .. #menu.data["Weapons"]["weapons_lasers"] .. " primary weapons, " .. #menu.data["Weapons"]["weapons_turrets"] .. " turrets, " .. #menu.data["Weapons"]["weapons_missileturrets"] .. " missile turrets, and " .. #menu.data["Weapons"]["missiletypes"] .. " missiles.")
	--print("registered " .. #menu.data["Equipment"]["enginetypes"] .. " engines, " .. #menu.data.Equipment.thrustertypes .. " thrusters, " .. #menu.data["Equipment"]["shieldgentypes"] .. " shield generators, and " .. #menu.data["Equipment"]["software"] .. " software.")
	--print("registered " .. #menu.data["Wares"]["wares"] .. " economy wares and " .. #menu.data["Wares"]["inventory_wares"] .. " inventory wares.")

	--print("The player knows of " .. tostring(numclusters) .. " clusters, " .. tostring(numfactions) .. " factions, " .. tostring(numstations) .. " station types, " .. tostring(numships) .. " ship types, " .. tostring(numweapons) .. " weapon types, and " .. tostring(numwares) .. " ware types.")

	AddUITriggeredEvent(menu.name, menu.encyclopediaMode)

	local curtime = C.GetCurrentGameTime()
	menu.timeframe = "day"
	menu.xStart = math.max(0, curtime - 86400)
	menu.xEnd = curtime
	menu.xGranularity = 7200
	if menu.xEnd > menu.xStart then
		while (menu.xEnd - menu.xStart) < menu.xGranularity do
			menu.xGranularity = menu.xGranularity / 2
		end
	end
	menu.xScale = 3600
	menu.xTitle = ReadText(1001, 6519) .. " [" .. ReadText(1001, 102) .. "]"
	menu.yTitle = ReadText(1001, 6521)
	menu.hiddenData = { buy = {}, sell = {} }

	menu.display()
end

function menu.getSystemInfo(cluster)
	local counts = C.GetNumUISystemInfo(cluster)
	local info = ffi.new("UISystemInfo2")
	info.space = Helper.ffiNewHelper("UISpaceInfo")
	info.numsuns = counts.numsuns
	info.suns = Helper.ffiNewHelper("UISunInfo[?]", info.numsuns)
	info.numplanets = counts.numplanets
	info.planets = Helper.ffiNewHelper("UICelestialBodyInfo2[?]", info.numplanets)

	local result = {}
	if C.GetUISystemInfo2(info, cluster) then
		local numterraformingprojects = false
		if GetComponentData(ConvertStringTo64Bit(tostring(cluster)), "hasterraforming") then
			numterraformingprojects = C.GetNumTerraformingProjects(cluster, false) > 0
		end

		result.space = { environment = ffi.string(info.space.environment) }
		result.suns = {}
		for i = 0, info.numsuns - 1 do
			table.insert(result.suns, { name = ffi.string(info.suns[i].name), class = ffi.string(info.suns[i].typeclass) })
		end
		result.planets = {}
		for i = 0, info.numplanets - 1 do
			local moons = {}
			if info.planets[i].nummoons > 0 then
				local buf = ffi.new("UICelestialBodyInfo2[?]", info.planets[i].nummoons)
				info.planets[i].nummoons = C.GetMoonInfo2(buf, info.planets[i].nummoons, cluster, i + 1)
				for j = 0, info.planets[i].nummoons - 1 do
					table.insert(moons, { name = ffi.string(buf[j].name), class = ffi.string(buf[j].typeclass), geology = ffi.string(buf[j].geology), atmosphere = ffi.string(buf[j].atmosphere), population = ffi.string(buf[j].population), settlements = ffi.string(buf[j].settlements), hasterraforming = numterraformingprojects and buf[j].hasterraforming })
				end
			end
			table.insert(result.planets, { name = ffi.string(info.planets[i].name), class = ffi.string(info.planets[i].typeclass), geology = ffi.string(info.planets[i].geology), atmosphere = ffi.string(info.planets[i].atmosphere), population = ffi.string(info.planets[i].population), settlements = ffi.string(info.planets[i].settlements), moons = moons, hasterraforming = numterraformingprojects and info.planets[i].hasterraforming })
		end
	end
	return result
end

function menu.onSaveState()
	local state = {}

	for _, key in ipairs(config.stateKeys) do
		state[key[1]] = menu[key[1]]
	end

	return state
end

function menu.onRestoreState(state)
	for _, key in ipairs(config.stateKeys) do
		if key[2] == "UniverseID" then
			menu[key[1]] = ConvertIDTo64Bit(state[key[1]])
		else
			menu[key[1]] = state[key[1]]
		end
	end
end

function menu.addIndexEntry(array, item, name, rowdata, indent, numentries, expanded)
	local numunread = 0
	local isunread = false

	if numentries then
		if (rowdata == "Galaxy") or (rowdata[1] == "Galaxy") then
			if type(rowdata) == "table" then
				if rowdata[2] == "system" then
					for _, cluster in ipairs(rowdata[#rowdata].clusters) do
						isunread = isunread or (not C.IsKnownRead(ConvertIDTo64Bit(cluster)))
						numunread = numunread + C.GetNumContainedKnownUnreadSpaces(ConvertIDTo64Bit(cluster))
					end
				else
					numunread = C.GetNumContainedKnownUnreadSpaces(ConvertIDTo64Bit(rowdata[3]))
				end
			else
				for i, entry in pairs(menu.data["Galaxy"]) do
					for _, cluster in ipairs(entry.clusters) do
						if not C.IsKnownRead(ConvertIDTo64Bit(cluster)) and C.GetNumContainedKnownSpaces(ConvertIDTo64Bit(cluster)) > 1 then
							numunread = numunread + 1
						end
						numunread = numunread + C.GetNumContainedKnownUnreadSpaces(ConvertIDTo64Bit(cluster))
					end
				end
			end
		elseif (type(rowdata) == "table") and (rowdata[1] == "Ships") then
			if type(rowdata[2]) == "table" and not menu.printedshipdata[rowdata[2]] then

				-- start: alexandretk call-back
				if callbacks ["onShowMenu_addingTypeIndexEntries"] then
					local addthis
					for _, callback in ipairs (callbacks["onShowMenu_addingTypeIndexEntries"]) do
						addthis = callback(menu,rowdata, numunread,C)
						numunread = numunread + addthis
					end
				else
				-- end: alexandretk call-back

					for sizeclass, sizeclassdata in pairs(menu.printedshipdata[rowdata[2][1]]) do
						if sizeclass == rowdata[2][2] then
							for _, shipentry in ipairs(sizeclassdata.ships) do
								if not C.IsKnownItemRead(shipentry.librarycategory, shipentry.id) then
									numunread = numunread + 1
								end
							end
							break
						end
					end

				end
			else

				-- start: alexandretk call-back
				if callbacks ["onShowMenu_addingIndexEntries"] then
					local addthis
					for _, callback in ipairs (callbacks["onShowMenu_addingIndexEntries"]) do
						addthis = callback(menu, numunread,rowdata,C)
						numunread = numunread + addthis
					end
				else
				-- end: alexandretk call-back

					for sizeclass, sizeclassdata in pairs(menu.printedshipdata[rowdata[2]]) do
						if sizeclass ~= "text" then
							for _, shipentry in ipairs(sizeclassdata.ships) do
								if not C.IsKnownItemRead(shipentry.librarycategory, shipentry.id) then
									numunread = numunread + 1
								end
							end
						end
					end

				end

			end
		elseif rowdata == "Factions" then
			_, numunread = menu.getNumEntries(rowdata)
		elseif rowdata[1] == "Factions" then
			if not C.IsKnownItemRead(rowdata[2], rowdata[3].id) then
				isunread = true
			end
			for _, licence in ipairs(rowdata[3].licences) do
				if not C.IsKnownItemRead("licences", licence.id) then
					numunread = numunread + 1
				end
			end
		elseif (rowdata == "Blueprints") or (rowdata[1] == "Blueprints") then
			
		elseif rowdata == "FixedStations" then
			for _, entry in ipairs(menu.data["FixedStations"]) do
				if entry.macro then
					if not C.IsKnownItemRead("stationtypes", entry.macro) then
						numunread = numunread + 1
					end
				else
					if not C.IsKnownRead(entry.component) then
						numunread = numunread + 1
					end
				end
			end
		else
			if type(rowdata) == "table" then
				numunread = C.GetNumUnreadLibraryEntries(rowdata[2])
			else
				_, numunread = menu.getNumEntries(rowdata)
			end
		end
	elseif item then
		if rowdata == "Galaxy" or rowdata[1] == "Galaxy" then
			isunread = not C.IsKnownRead(ConvertIDTo64Bit(item))
		elseif rowdata[1] == "FixedStations" then
			if rowdata[3].macro then
				isunread = not C.IsKnownItemRead("stationtypes", rowdata[3].macro)
			else
				isunread = not C.IsKnownRead(rowdata[3].component)
			end
		else
			isunread = not C.IsKnownItemRead(rowdata[2], item)
		end
	end

	table.insert(array, { item = item, name = name, rowdata = rowdata, indent = indent, numentries = numentries, numunread = numunread, isunread = isunread, expanded = expanded })
	return array[#array]
end

function menu.createIndex()
	local index = {}
	local numentries = 0

	-- Galaxy
	for i, entry in pairs(menu.data["Galaxy"]) do
		numentries = numentries + #entry.sectors + ((#entry.sectors > 1) and 1 or 0)
	end
	local gal_index = menu.addIndexEntry(index, nil, ReadText(20002, 1), "Galaxy", 0, numentries, menu.expanded["Galaxy"])
	for i, entry in ipairs(menu.data["Galaxy"]) do
		local numsectors = #entry.sectors
		if numsectors > 1 then
			local system_index = menu.addIndexEntry(gal_index, nil, entry.name, { "Galaxy", "system", i, entry }, 1, numsectors, menu.expanded[i])
			for _, sector in ipairs(entry.sectors) do
				menu.addIndexEntry(system_index, sector.sector, sector.name, { "Galaxy", "space", sector.sector, entry }, 2)
			end
		else
			menu.addIndexEntry(gal_index, entry.sectors[1].sector, entry.sectors[1].name, { "Galaxy", "space", entry.sectors[1].sector, entry }, 1)
		end
	end

	-- Races
	numentries = menu.getNumEntries("Races")
	local race_index = menu.addIndexEntry(index, nil, ReadText(1001, 99), "Races", 0, numentries, menu.expanded["Races"])
	for subcategory, _ in pairs(menu.data["Races"]) do
		for _, race in ipairs(menu.data["Races"][subcategory]) do
			menu.addIndexEntry(race_index, race.id, race.name, { "Races", subcategory, race }, 1)
		end
	end

	-- Factions
	numentries = menu.getNumEntries("Factions")
	local fac_index = menu.addIndexEntry(index, nil, ReadText(1001, 44), "Factions", 0, numentries, menu.expanded["Factions"])
	for subcategory, _ in pairs(menu.data["Factions"]) do
		for _, faction in ipairs(menu.data["Factions"][subcategory]) do
			local lic_index = menu.addIndexEntry(fac_index, nil, faction.name, { "Factions", subcategory, faction }, 1, faction.numlicences, menu.expanded[faction.id])
			-- Licences
			for _, licence in ipairs(faction.licences) do
				menu.addIndexEntry(lic_index, licence.id, licence.name, { "Licences", "licences", licence, faction.id }, 2)
			end
		end
	end

	-- FixedStations
	numentries = #menu.data["FixedStations"]
	local sta_index = menu.addIndexEntry(index, nil, ReadText(1001, 4), "FixedStations", 0, numentries, menu.expanded["FixedStations"])
	for _, entry in ipairs(menu.data["FixedStations"]) do
		menu.addIndexEntry(sta_index, entry.macro or entry.component, entry.name, { "FixedStations", entry.macro and "stationtypes" or "stationcomponent", entry }, 1)
	end

	-- Stations
	numentries = menu.getNumEntries("Stations")
	local sta_index = menu.addIndexEntry(index, nil, menu.index["Stations"].name, "Stations", 0, numentries, menu.expanded["Stations"])
	for _, entry in ipairs(menu.index["Stations"]) do
		local stationcategory = entry.key
		if stationcategory then
			numentries = #menu.data["Stations"][stationcategory]
			local mod_index = menu.addIndexEntry(sta_index, nil, config.librarynames[stationcategory], { "Stations", stationcategory }, 1, numentries, menu.expanded[stationcategory])
			for _, entry in ipairs(menu.data["Stations"][stationcategory]) do
				menu.addIndexEntry(mod_index, entry.id, entry.name, { "Stations", stationcategory, entry }, 2)
			end
		end
	end

	-- Ships
	numentries = menu.getNumEntries("Ships")
	local ship_index = menu.addIndexEntry(index, nil, ReadText(1001, 6), "Ships", 0, numentries, menu.expanded["Ships"])
	for _, purpose in ipairs(menu.sortedpurposelist) do
		numentries = 0

		-- start: alexandretk call-back
		if callbacks ["onShowMenu_addingIndexNumEntries"] then
			for _, callback in ipairs (callbacks ["onShowMenu_addingIndexNumEntries"]) do
				callback(C,ship_index,purpose, menu)
			end
		else
		-- end: alexandretk call-back

			for _, sizeclass in ipairs(menu.printedshipsizes) do
				numentries = numentries + #menu.printedshipdata[purpose][sizeclass].ships
			end
			if numentries > 0 then
				local ship_purpose_index = menu.addIndexEntry(ship_index, nil, menu.printedshipdata[purpose].text, { "Ships", purpose }, 1, numentries, menu.expanded[purpose])
				for _, sizeclass in ipairs(menu.printedshipsizes) do
					numentries = #menu.printedshipdata[purpose][sizeclass].ships
					if numentries > 0 then
						local ship_size_index = menu.addIndexEntry(ship_purpose_index, nil, menu.printedshipdata[purpose][sizeclass].text, { "Ships", { purpose, sizeclass } }, 2, numentries, menu.expanded[purpose .. sizeclass])
						for _, entry in ipairs(menu.printedshipdata[purpose][sizeclass].ships) do
							-- rowdata[2] here has to be the librarycategory for looking up information about that entry, tying into other tables.
							local icon = GetMacroData(entry.id, "icon")
							menu.addIndexEntry(ship_size_index, entry.id, "\27[" .. (C.IsIconValid(icon) and icon or "solid") .. "]" .. entry.name, { "Ships", entry.librarycategory, entry }, 3)
						end
					end
				end
			end

		end
	end

	-- Weapons
	numentries = menu.getNumEntries("Weapons")
	local wea_index = menu.addIndexEntry(index, nil, menu.index["Weapons"].name, "Weapons", 0, numentries, menu.expanded["Weapons"])
	for _, entry in ipairs(menu.index["Weapons"]) do
		local weaponcategory = entry.key
		numentries = #menu.data["Weapons"][weaponcategory]
		local wea_cat_index = menu.addIndexEntry(wea_index, nil, config.librarynames[weaponcategory], { "Weapons", weaponcategory }, 1, numentries, menu.expanded[weaponcategory])
		for _, entry in ipairs(menu.data["Weapons"][weaponcategory]) do
			menu.addIndexEntry(wea_cat_index, entry.id, entry.name, { "Weapons", weaponcategory, entry }, 2)
		end
	end

	-- Equipment
	numentries = menu.getNumEntries("Equipment")
	local equ_index = menu.addIndexEntry(index, nil, menu.index["Equipment"].name, "Equipment", 0, numentries, menu.expanded["Equipment"])
	for _, entry in ipairs(menu.index["Equipment"]) do
		local equipmentcategory = entry.key
		numentries = #menu.data["Equipment"][equipmentcategory]
		local equ_cat_index = menu.addIndexEntry(equ_index, nil, config.librarynames[equipmentcategory], { "Equipment", equipmentcategory }, 1, numentries, menu.expanded[equipmentcategory])
		for _, entry in ipairs(menu.data["Equipment"][equipmentcategory]) do
			menu.addIndexEntry(equ_cat_index, entry.id, entry.name, { "Equipment", equipmentcategory, entry }, 2)
		end
	end

	-- Wares
	numentries = menu.getNumEntries("Wares")
	local ware_index = menu.addIndexEntry(index, nil, ReadText(1001, 46), "Wares", 0, numentries, menu.expanded["Wares"])
	for i = 1, 2 do
		local warecategory = nil
		local loctext = nil
		if i == 1 then
			warecategory = "wares"
			loctext = ReadText(1001, 46)
		elseif i == 2 then
			warecategory = "inventory_wares"
			loctext = ReadText(1001, 2434)
		end
		numentries = #menu.data["Wares"][warecategory]
		local ware_cat_index = menu.addIndexEntry(ware_index, nil, loctext, { "Wares", warecategory }, 1, numentries, menu.expanded[warecategory])
		for _, entry in ipairs(menu.data["Wares"][warecategory]) do
			menu.addIndexEntry(ware_cat_index, entry.id, entry.name, { "Wares", warecategory, entry }, 2)
		end
	end

	-- Blueprints
	local bp_index = menu.addIndexEntry(index, nil, menu.index["Blueprints"].name, "Blueprints", 0, 3, menu.expanded["Blueprints"])
	for i, entry in ipairs(menu.index["Blueprints"]) do
		local numentries = 0
		for _, data in pairs(menu.data["Blueprints"][entry.key]) do
			numentries = numentries + #data
		end
		menu.addIndexEntry(bp_index, i, entry.name, { "Blueprints", i, menu.data["Blueprints"][entry.key] }, 1, numentries)
	end

	return index
end

function menu.filterIndexCategory(text, entry, first)
	if text == nil then
		return true
	end

	text = utf8.lower(text)
	local show = false
	local count, unreadcount = 0, 0

	if string.find(utf8.lower(entry.name), text, 1, true) then
		show = true
		if not first then
			count = count + 1
			if entry.isunread then
				unreadcount = unreadcount + 1
			end
		end
	end

	for _, entry2 in ipairs(entry) do
		local locshow, loccount, locunreadcount = menu.filterIndexCategory(text, entry2)
		show = show or locshow
		count = count + loccount
		unreadcount = unreadcount + locunreadcount
	end

	return show, count, unreadcount
end

function menu.displayIndexRow(inputtable, entry)
	local show, searchcount, searchunread = menu.filterIndexCategory(menu.searchtext, entry, true)
	if show then
		local locrow = inputtable:addRow(entry.rowdata, {  })
	
		local arrow
		if (type(entry.rowdata) == "table") and (#entry.rowdata >= 3) then
			arrow = "widget_arrow_right_01"
		end
		local coloffset = math.min(2, entry.indent)
		if entry.numentries then
			local numentries = searchcount or entry.numentries
			local numentriestext = " (" .. numentries .. (numentries == 1 and " " .. ReadText(1001, 2401) .. ")" or " " .. ReadText(1001, 2402) .. ")")
			if menu.searchtext then
				numentriestext = (numentries > 0) and string.format(ReadText(1001, 9619), numentries) or ""
			end
			local numunread = searchunread or entry.numunread
			local numunreadtext = ((numunread ~= 0) and (" " .. ColorText["text_positive"] .. "(" .. numunread .. " " .. ReadText(1001, 9001) .. ")") or "")
			locrow[5]:createText(numentriestext .. numunreadtext, { halign = "right" })
			locrow[2 + coloffset]:setColSpan(3 - coloffset):setBackgroundColSpan(4 - coloffset)

			local expandentry = entry.rowdata
			if type(entry.rowdata) == "table" then
				if entry.rowdata[1] == "Galaxy" then
					expandentry = entry.rowdata[3]
				elseif entry.rowdata[1] == "Factions" then
					expandentry = entry.rowdata[#entry.rowdata].id
				elseif entry.rowdata[1] == "Blueprints" then
					numentries = 0
				else
					expandentry = entry.rowdata[#entry.rowdata]
					if type(expandentry) == "table" then
						expandentry = ""
						for _, val in ipairs(entry.rowdata[#entry.rowdata]) do
							expandentry = (expandentry .. val)
						end
					end
				end
			end
			if numentries > 0 then
				locrow[1 + coloffset]:createButton({ height = Helper.standardTextHeight }):setText(entry.expanded and "-" or "+", { halign = "center" })
				locrow[1 + coloffset].handlers.onClick = function() return menu.buttonExpand(expandentry, locrow.index) end
			end
		elseif entry.item then
			if entry.isunread then
				locrow[5]:createText(ColorText["text_positive"] .. "(" .. ReadText(1001, 9001) .. ")", { halign = "right" })
				locrow[2 + coloffset]:setColSpan(3 - coloffset):setBackgroundColSpan(4 - coloffset)
			else
				locrow[2 + coloffset]:setColSpan(4 - coloffset)
			end
		else
			locrow[2 + coloffset]:setColSpan(4 - coloffset)
		end
		local offsetx = Helper.standardTextOffsetx
		if entry.indent > 2 then
			offsetx = offsetx + (entry.indent - 2) * Helper.standardTextHeight
		end
		locrow[2 + coloffset]:createText(entry.name, { x = offsetx })
		if arrow then
			locrow[6]:createIcon(arrow, { height = Helper.standardTextHeight })
		end
	 
		if not menu.selectedrow and type(entry.rowdata) == "table" then
			if ((menu.mode ~= "Galaxy") and menu.id and (menu.id == entry.rowdata[#entry.rowdata].id)) or (menu.object and (menu.object == entry.rowdata[3])) then
				menu.selectedrow = locrow.index
				menu.toprow = GetTopRow(menu.table_index)
			elseif (menu.mode ~= "Galaxy") and menu.id and entry.rowdata[#entry.rowdata].id then
				-- check all aliases due to collision / no-collision compatibilities
				local n = C.GetNumLibraryEntryAliases(entry.rowdata[2], entry.rowdata[#entry.rowdata].id)
				local buf = ffi.new("const char*[?]", n)
				n = C.GetLibraryEntryAliases(buf, n, entry.rowdata[2], entry.rowdata[#entry.rowdata].id)
				for j = 0, n - 1 do
					local aliasid = ffi.string(buf[j])
					if menu.id == aliasid then
						menu.selectedrow = locrow.index
						menu.toprow = GetTopRow(menu.table_index)
						break
					end
				end
			elseif (menu.mode == "Galaxy") and IsSameComponent(menu.object, entry.rowdata[3]) then
				menu.selectedrow = locrow.index
				menu.toprow = GetTopRow(menu.table_index)
			end
		end

		if entry.expanded then
			for _, entry2 in ipairs(entry) do
				menu.displayIndexRow(inputtable, entry2)
			end
		end
	end
end

-- assemble the menu
function menu.display()
	-- kuertee start: callback
	if callbacks ["display_on_start"] then
		for _, callback in ipairs (callbacks ["display_on_start"]) do
			callback (menu.infoFrame, tableProperties)
		end
	end
	-- kuertee end: callback

	--print("Displaying Menu")
	menu.displayRunning = true

	-- remove old data
	Helper.clearDataForRefresh(menu)
	HideAllShapes()

	-- Organize Visual Menu
	local framewidth = Helper.viewWidth
	local frameheight = Helper.viewHeight
	local xoffset = 0
	local yoffset = 0

	menu.frame = Helper.createFrameHandle(menu, { height = frameheight, width = framewidth, x = xoffset, y = yoffset, standardButtons = { back = true, close = true, help = true  } })
	menu.frame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	menu.sidebarWidth = Helper.scaleX(Helper.sidebarWidth)

	menu.createTopLevel(menu.frame)

	-- sideBar
	menu.createSideBar(menu.frame)

	if menu.encyclopediaMode == "encyclopedia" then
		local table_index, table_detail, table_description, row
		local tablewidth = (framewidth - 2 * Helper.frameBorder - menu.sidebarWidth - Helper.borderSize) / 7
		local topborder = menu.topLevelOffsetY + Helper.borderSize
		--print("framewidth: " .. framewidth .. ", tablewidth: " .. tablewidth)

		-- set up a new table
		table_index = menu.frame:addTable( 6, { width = tablewidth * 2 - Helper.borderSize, height = frameheight - topborder, x = Helper.frameBorder + menu.sidebarWidth + Helper.borderSize, y = yoffset + topborder, tabOrder = 1, maxVisibleHeight = frameheight - yoffset - topborder } )
		if menu.setdefaulttable then
			table_index.properties.defaultInteractiveObject = true
			menu.setdefaulttable = nil
		end
		table_index:setColWidth(1, Helper.standardTextHeight)
		table_index:setColWidth(2, Helper.standardTextHeight)
		table_index:setColWidth(3, Helper.standardTextHeight)
		table_index:setColWidthPercent(5, 33)
		table_index:setColWidth(6, Helper.standardTextHeight)

		row = table_index:addRow(false, { fixed = true, bgColor = Color["row_title_background"] })
		row[1]:setColSpan(6):createText(ReadText(1001, 9000), Helper.headerRow1Properties)	-- "Encyclopedia Index"

		local row = table_index:addRow(true, { fixed = true, bgColor = Color["row_background_blue"] })
		row[1]:setColSpan(5):createEditBox({ height = Helper.standardTextHeight }):setText(menu.searchtext or "", {  }):setHotkey("INPUT_STATE_DETAILMONITOR_0", { displayIcon = true })
		row[1].handlers.onEditBoxActivated = function () menu.noupdate = true end
		row[1].handlers.onEditBoxDeactivated = menu.editboxSearchUpdateText
		row[6]:createButton({ scaling = false, height = row[1]:getHeight() }):setText("X", { scaling = true, halign = "center", font = Helper.standardFontBold })
		row[6].handlers.onClick = function () return menu.buttonClearEditbox(row.index) end

		table_index:addEmptyRow(Helper.standardTextHeight / 2)

		local index = menu.createIndex()
		for _, entry in ipairs(index) do
			if entry.numentries > 0 then
				menu.displayIndexRow(table_index, entry)
			end
		end

		local descriptiontablewidth = 2 * tablewidth - Helper.borderSize
		table_description = menu.frame:addTable( 1, { tabOrder = 5, width = descriptiontablewidth, x = framewidth - descriptiontablewidth - Helper.frameBorder, highlightMode = "off" } )
		
		local rendertargetproperties = { width = table_description.properties.width, height = table_description.properties.width, x = table_description.properties.x, y = topborder }
		if table_description.properties.width > (0.8 * Helper.viewHeight - topborder) then
			-- secure some space for the description table
			rendertargetproperties.width = 0.8 * Helper.viewHeight - topborder
			rendertargetproperties.height = 0.8 * Helper.viewHeight - topborder
			if (menu.mode == "Galaxy") and menu.object then
				-- re-check for 16:10 format
				if rendertargetproperties.height * 1.6 > table_description.properties.width then
					rendertargetproperties.width = table_description.properties.width
				else
					rendertargetproperties.width = rendertargetproperties.height * 1.6
				end
			end
		end

		if (menu.mode == "Galaxy") and menu.object then
			rendertargetproperties.height = rendertargetproperties.width * 10 / 16
		end
		-- position in the center of the right side
		rendertargetproperties.x = table_description.properties.x + (table_description.properties.width - rendertargetproperties.width) / 2

		table_description.properties.y = rendertargetproperties.y + rendertargetproperties.height

		row = table_description:addRow(false, { fixed = true, bgColor = Color["row_title_background"] })
		row[1]:createText(ReadText(1001, 2404), Helper.headerRow1Properties)
		table_description.properties.maxVisibleHeight = Helper.viewHeight - Helper.frameBorder - table_description.properties.y

		local numdescrows = math.floor((table_description.properties.maxVisibleHeight - row:getHeight()) / (Helper.scaleY(Helper.standardTextHeight) + Helper.borderSize))
		local descriptiontext = menu.getDescriptionText()
		local description = GetTextLines(descriptiontext, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), descriptiontablewidth - 2 * Helper.scaleX(Helper.standardTextOffsetx))
		if #description > numdescrows then
			-- scrollbar case
			description = GetTextLines(descriptiontext, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), descriptiontablewidth - 2 * Helper.scaleX(Helper.standardTextOffsetx) - Helper.scrollbarWidth)
		end
		for linenum, descline in ipairs(description) do
			local row = table_description:addRow(true, {  })
			row[1]:createText(descline)
		end

		table_detail = menu.frame:addTable( 4, { maxVisibleHeight = frameheight - topborder, y = yoffset + topborder, tabOrder = 2 } )
		table_detail.properties.x = table_index.properties.x + table_index.properties.width + Helper.borderSize * 2.5
		table_detail.properties.width = tablewidth * 3 - Helper.borderSize * 2.5

		if (menu.mode == "Galaxy") and menu.object and (type(menu.object) ~= "number") then
			table_detail.properties.maxVisibleHeight = frameheight / 2 - topborder - Helper.borderSize / 2
		end
		table_detail:setColWidth(1, Helper.headerRow1Height)
		table_detail:setColWidthMin(2, 0, 60)
		table_detail:setColWidthMin(3, 0, 20)
		table_detail:setColWidthMin(4, 0, 20)

		row = table_detail:addRow(false, {  })
		row[1]:createIcon(function () return menu.detailIcon(false) end, { width = Helper.headerRow1Height, height = Helper.headerRow1Height, color = function () return menu.detailIconColor(false) end })
		row[2]:setColSpan(3):createText(menu.detailText, Helper.headerRow1Properties)

		menu.numDetailRows = 0
		menu.addDetailRows(table_detail)

		-- graph
		if (menu.mode == "Galaxy") and menu.object and (type(menu.object) ~= "number") then
			menu.createGraph(tablewidth * 3 - Helper.borderSize * 2.5, math.floor((frameheight - topborder) / 2 - Helper.borderSize / 2), table_index.properties.x + table_index.properties.width + Helper.borderSize * 2.5, frameheight / 2 + Helper.borderSize / 2)
		end

		local gapcenter = Helper.borderSize * 1.25
		Helper.drawLine( {x = table_detail.properties.x - gapcenter, y = topborder}, {x = table_detail.properties.x - gapcenter, y = frameheight}, nil, nil, Color["row_separator_encyclopedia"], true )
		Helper.drawLine( {x = table_description.properties.x - gapcenter, y = topborder}, {x = table_description.properties.x - gapcenter, y = frameheight}, nil, nil, Color["row_separator_encyclopedia"], true )

		local createrendertarget = true
		if menu.rendertargetmode then
			if menu.rendertargetmode == "icon" then
				local factor = 0.7
				if (menu.mode == "Galaxy") and menu.object then
					factor = 1
				end

				local table_rendertarget = menu.frame:addTable(1, rendertargetproperties)
				row = table_rendertarget:addRow(false, {  })
				row[1]:createIcon(function () return menu.detailIcon(true) end, { width = table_rendertarget.properties.width * factor, height = table_rendertarget.properties.height * factor, x = (table_rendertarget.properties.width * (1 - factor)) / 2, y = table_rendertarget.properties.height * (1 - factor) / 4, scaling = false, color = function () return menu.detailIconColor(true) end })
				createrendertarget = false
			end
		else
			menu.activatecutscene = true
		end

		if createrendertarget then
			rendertargetproperties.alpha = 90
			menu.rendertarget = menu.frame:addRenderTarget(rendertargetproperties)
		end

		if menu.selectedrow then
			table_index:setSelectedRow(menu.selectedrow)
			if menu.toprow then
				table_index:setTopRow(menu.toprow)
				menu.toprow = nil
			end
		end

		local table_button = menu.frame:addTable(2, { width = tablewidth * 2 - Helper.borderSize, x = Helper.frameBorder + menu.sidebarWidth + Helper.borderSize, y = yoffset + topborder, tabOrder = 1 } )

		local row = table_button:addRow(nil, { fixed = true })
		row[1]:setColSpan(2):createText("")
		local row = table_button:addRow(true, { fixed = true })
		row[2]:createButton({ active = menu.hasUnreadEntries }):setText(ReadText(1001, 7744), { halign = "center" })
		row[2].handlers.onClick = menu.buttonReadAll

		local maxVisibleHeight = table_index.properties.maxVisibleHeight - table_button:getFullHeight() - Helper.frameBorder
		table_button.properties.y = table_button.properties.y + math.min(maxVisibleHeight, table_index:getFullHeight())
		table_index.properties.maxVisibleHeight = table_button.properties.y - table_index.properties.y
	end

	-- display view/frame
	menu.frame:display()
end

function menu.hasUnreadEntries()
	for i, entry in pairs(menu.data["Galaxy"]) do
		for _, cluster in ipairs(entry.clusters) do
			if not C.IsKnownRead(ConvertIDTo64Bit(cluster)) and C.GetNumContainedKnownSpaces(ConvertIDTo64Bit(cluster)) > 1 then
				return true
			end
			if C.GetNumContainedKnownUnreadSpaces(ConvertIDTo64Bit(cluster)) > 0 then
				return true
			end
		end
	end

	if C.GetNumUnreadLibraryEntries("stationtypes") > 0 then
		return true
	end
	for i, entry in pairs(menu.data["FixedStations"]) do
		if entry.component then
			if not C.IsKnownRead(entry.component) then
				return true
			end
		end
	end

	for category, entry in pairs(menu.data) do
		if (category ~= "Galaxy") and (category ~= "FixedStations") then
			for subcategory in pairs(entry) do
				if C.GetNumUnreadLibraryEntries(subcategory) > 0 then
					return true
				end
			end
		end
	end
	return false
end

-- Suppress icons for licences for now, they are used for the ship config menu and if they should have any, we need to change the setup there first
function menu.detailIcon(isrendertargeticon)
	local icon = "solid"
	if (menu.mode == "Galaxy") and menu.object then
		local object = menu.object
		if type(menu.object) == "number" then
			object = menu.data["Galaxy"][menu.object].clusters[1]
		end
		local image, ownericon = GetComponentData(object, "image", "ownericon")
		if isrendertargeticon then
			icon = image
			if not C.IsIconValid(icon) then
				icon = ownericon or "solid"
			end
		else
			icon = ownericon or "solid"
		end
	elseif menu.library then
		if (menu.library ~= "licences") and (menu.object.icon ~= "") then
			icon = menu.object.icon
		elseif isrendertargeticon then
			if menu.library == "licences" then
				icon = "ency_license_01"
			elseif (menu.library == "weapons_lasers") or (menu.library == "weapons_missilelaunchers") then
				icon = "ency_weapon_01"
			else
				icon = "ency_unknown_01"
			end
		end
	end
	return (icon and (icon ~= "")) and icon or "solid"
end

-- Suppress icons for licences for now, they are used for the ship config menu and if they should have any, we need to change the setup there first
function menu.detailIconColor(isrendertargeticon)
	local color = Color["icon_inactive"]
	if (menu.mode == "Galaxy") and menu.object then
		if isrendertargeticon then
			color = Color["icon_normal"]
		end
	elseif menu.library then
		if (menu.library ~= "licences") and (menu.object.icon ~= "") then
			color = Color["icon_normal"]
		elseif isrendertargeticon then
			if menu.library == "licences" then
				color = Color["icon_normal"]
			elseif (menu.library == "weapons_lasers") or (menu.library == "weapons_missilelaunchers") then
				color = Color["icon_normal"]
			elseif isrendertargeticon then
				color = Color["icon_normal"]
			end
		end
	end
	return color
end

function menu.detailText()
	local text = ""
	if (menu.mode == "Galaxy") and menu.object then
		text = (type(menu.object) == "number") and menu.data["Galaxy"][menu.object].name or GetComponentData(menu.object, "name")
	elseif menu.mode == "FixedStations" and menu.object then
		text = menu.object.name
	elseif menu.library then
		text = menu.object.name
	end
	return text
end

function menu.getDescriptionText()
	if (menu.mode == "Blueprints") and menu.object then
		return menu.index["Blueprints"][menu.object].description
	elseif (menu.mode == "Galaxy") and menu.object then
		return (type(menu.object) == "number") and menu.data["Galaxy"][menu.object].description or GetComponentData(menu.object, "description")
	elseif (menu.mode == "FixedStations") and (menu.object) and (menu.id == nil) then
		return GetComponentData(ConvertStringTo64Bit(tostring(menu.object.component)), "description")
	elseif menu.library and menu.object and menu.object.description then
		return menu.object.description
	end
	return ""
end

function menu.createTopLevel(frame)
	menu.topLevelOffsetY = Helper.createTopLevelTab(menu, "encyclopedia", frame, "", nil, true)
end

function menu.onTabScroll(direction)
	if direction == "right" then
		Helper.scrollTopLevel(menu, "encyclopedia", 1)
	elseif direction == "left" then
		Helper.scrollTopLevel(menu, "encyclopedia", -1)
	end
end

function menu.onInputModeChanged(_, mode)
	if not menu.noupdate then
		menu.display()
	else
		menu.inputModeHasChanged = true
	end
end

function menu.createSideBar(frame)
	local ftable = frame:addTable(1, { tabOrder = 3, width = menu.sidebarWidth, x = Helper.frameBorder, y = menu.topLevelOffsetY + Helper.borderSize, scaling = false, borderEnabled = false, reserveScrollBar = false })

	for _, entry in ipairs(config.leftBar) do
		local mode = entry.mode
		local row = ftable:addRow(true, { fixed = true, bgColor = Color["row_background_blue"] })
		local active = true
		local bgcolor = Color["row_title_background"]
		if entry.mode == "encyclopedia" then
			bgcolor = Color["row_background_selected"]
		end
		local color = Color["icon_normal"]
		row[1]:createButton({ active = active, height = menu.sidebarWidth, bgColor = bgcolor, mouseOverText = entry.name, helpOverlayID = entry.helpOverlayID, helpOverlayText = entry.helpOverlayText }):setIcon(entry.icon, { color = color })
		row[1].handlers.onClick = function () return menu.buttonToggleEncyclopediaMode(mode) end
	end
end

function menu.viewCreated(layer, ...)
	menu.table_toplevel, menu.table_sidebar, menu.table_index, menu.table_description, menu.table_detail = ...
	menu.displayRunning = getElapsedTime()
end

menu.updateInterval = 0.1

-- hook to update the menu while it is being displayed
function menu.onUpdate()
	if menu.activatecutscene then
		local locparam1, locparam2, locparam3
		if menu.delayedrenderobject then
			locparam1 = menu.delayedrenderobject[1]
			locparam2 = menu.delayedrenderobject[2]
			locparam3 = menu.delayedrenderobject[3]
			locparam4 = menu.delayedrenderobject[4]
			menu.delayedrenderobject = {}
		end
		if menu.setupRenderTarget(locparam1, locparam2, locparam3, locparam4) then
			menu.activatecutscene = nil
		end
	end

	if menu.inputModeHasChanged then
		if not menu.noupdate then
			menu.refresh = true
			menu.inputModeHasChanged = nil
		end
	end

	if menu.refresh then
		menu.display()
		menu.refresh = nil
	end
	if type(menu.displayRunning) == "number" then
		if menu.displayRunning + 0.3 < getElapsedTime() then
			menu.displayRunning = nil
		end
	end
end

function menu.onRowChanged(row, rowdata, uitable)
	--print("onRowChanged row: " .. tostring(row) .. " rowdata: " .. tostring(rowdata) .. " uitable: " .. tostring(uitable) .. " table_index: " .. tostring(menu.table_index))
	if (row ~= 1) and (uitable == menu.table_index) then
		menu.setObject(rowdata)

		menu.selectedrow = row
		menu.toprow = GetTopRow(uitable)

		if menu.mode == "Galaxy" and menu.object then
			--print("SetKnownRead. object: " .. tostring(menu.object))
			if type(menu.object) == "number" then
				for _, cluster in ipairs(menu.data["Galaxy"][menu.object].clusters) do
					C.SetKnownRead(ConvertIDTo64Bit(cluster), true)
				end
			else
				C.SetKnownRead(ConvertIDTo64Bit(menu.object), true)
			end
		elseif menu.mode == "FixedStations" then
			if menu.library and menu.id then
				C.ReadKnownItem(menu.library, menu.id, true)
			elseif menu.object then
				C.SetKnownRead(menu.object.component, true)
			end
		elseif menu.library and menu.id then
			--print("ReadKnownItem. library: " .. menu.library .. ", id: " .. menu.id)
			C.ReadKnownItem(menu.library, menu.id, true)
		end

		if (menu.mode == "Galaxy") and (menu.object ~= menu.oldobject) then
			menu.oldobject = menu.object
			menu.hiddenData = { buy = {}, sell = {} }
			menu.refresh = true
		elseif (menu.mode == "Blueprints") and (menu.object ~= menu.oldobject) then
			menu.oldobject = menu.object
			menu.refresh = true
		elseif (menu.mode == "FixedStations") and (menu.id == nil) and (menu.object ~= menu.oldobject) then
			menu.oldobject = menu.object
			menu.refresh = true
		elseif (menu.library ~= menu.oldlibrary) or (menu.id ~= menu.oldid) then
			menu.oldlibrary = menu.library
			menu.oldid = menu.id
			menu.refresh = true
		end
	end
end

-- hook if the highlighted row is selected
function menu.onSelectElement(table, modified)
end

-- hook if the menu is being closed
function menu.onCloseElement(dueToClose)
	if menu.encyclopediaMode and (dueToClose == "back") then
		menu.deactivateEncyclopediaMode()
		return
	end

	Helper.closeMenu(menu, dueToClose)
	menu.cleanup()
end

-- helper functions
function menu.initWareData(funcware)
	menu.details.resources = {}
	menu.details.products = {}
	menu.details.prodresources = {}
	menu.details.waresources = {}
	menu.details.haswaresourcelocation = nil
	menu.details.blueprintowners = {}

	if funcware then
		if (menu.library == "inventory_wares") or (menu.library == "paintmods") then
			local numsources = C.GetNumWareSources(funcware)
			local sources = ffi.new("WareSource[?]", numsources)
			numsources = C.GetWareSources(sources, numsources, funcware)
			for i = 0, numsources-1 do
				table.insert(menu.details.waresources, { type = ffi.string(sources[i].sourcetype), location = ffi.string(sources[i].sourcelocation) })
				--print("location: " .. menu.details.waresources[#menu.details.waresources].location .. ". is empty string: " .. tostring(menu.details.waresources[#menu.details.waresources].location == ""))
				if menu.details.waresources[#menu.details.waresources].location ~= "" then
					menu.details.haswaresourcelocation = true
				end
			end
			table.sort(menu.details.waresources, function(a, b) return a.type < b.type end)
			--[[
			for i, source in ipairs(menu.details.waresources) do
				print(i .. ": source type: " .. source.type .. ", source location: " .. source.location)
			end
			--]]
		end

		if (menu.library ~= "inventory_wares") or GetWareData(funcware, "iscraftable") then
			menu.details.resources, menu.details.productiontime, menu.details.productionamount = menu.getResources(funcware)

			menu.details.productionmethods = {}
			local productionmethods = GetWareData(funcware, "productionmethods")
			for _, productionmethod in ipairs(productionmethods) do
				local n = C.GetNumProductionMethodResources(funcware, productionmethod)
				if n > 0 then
					local info = C.GetProductionMethodInfo(funcware, productionmethod)
					table.insert(menu.details.productionmethods, { method = productionmethod, name = ffi.string(info.name), productiontime = info.productiontime, productionamount = info.productionamount, resources = {} })
					local methodentry = menu.details.productionmethods[#menu.details.productionmethods]
					local buf = ffi.new("UIWareAmount[?]", n)
					n = C.GetProductionMethodResources(buf, n, funcware, productionmethod)
					for i = 0, n - 1 do
						local ware = ffi.string(buf[i].wareid)
						table.insert(methodentry.resources, { ware = ware, name = GetWareData(ware, "name"), amount = buf[i].amount })
					end
				end
			end
			table.sort(menu.details.productionmethods, Helper.sortName)
			for i, entry in ipairs(menu.details.productionmethods) do
				if entry.method == "default" then
					table.insert(menu.details.productionmethods, 1, entry)
					table.remove(menu.details.productionmethods, i + 1)
					break
				end
			end
		end

		local n = C.GetNumWareBlueprintOwners(funcware)
		local buf = ffi.new("const char*[?]", n)
		n = C.GetWareBlueprintOwners(buf, n, funcware)
		for i = 0, n - 1 do
			local faction = ffi.string(buf[i])
			if IsKnownItem("factions", faction) then
				table.insert(menu.details.blueprintowners, faction)
			end
		end

		if (menu.library == "wares") or ((menu.library == "inventory_wares") and GetWareData(funcware, "iscraftingresource")) or ((menu.mode == "Stations") and (menu.library ~= "stationtypes")) then
			menu.details.products = menu.getProducts(funcware)
		end
	end
end

function menu.setObject(rowdata)
	local renderobject
	local isicon = nil
	local paintmod
	local iscomponent
	menu.library = nil
	menu.id = nil
	menu.object = nil

	-- rowdata is either a lua id or a table.
	if type(rowdata) == "table" then
		menu.mode = rowdata[1]
		if #rowdata >= 3 then
			if menu.mode == "Galaxy" then
				menu.library = nil
				menu.id = nil
				menu.object = rowdata[3]
				menu.details = rowdata[4]
				isicon = true
			elseif menu.mode == "Blueprints" then
				menu.object = rowdata[2]
				menu.details = rowdata[3]
			elseif menu.mode == "FixedStations" then
				if rowdata[2] == "stationtypes" then
					menu.library = rowdata[2]
					menu.id = rowdata[3].macro
					menu.object = GetLibraryEntry(menu.library, menu.id)
					renderobject = rowdata[3].macro
				else
					menu.library = nil
					menu.id = nil
					menu.object = rowdata[3]
					renderobject = rowdata[3].component
					iscomponent = true
				end
			else
				menu.library = rowdata[2]
				menu.id = rowdata[3].id
				menu.object = GetLibraryEntry(menu.library, menu.id)
				menu.details = rowdata[3]

				if (menu.mode ~= "Factions") and (menu.mode ~= "Licences") and (menu.mode ~= "Races") then
					local locware = menu.details.id
					if (menu.library ~= "inventory_wares") and (menu.library ~= "wares") and (menu.library ~= "software") and (menu.library ~= "paintmods") then
						locware = GetMacroData(locware, "ware")
					end

					if locware then
						menu.initWareData(locware)
					end

					if (menu.mode == "Stations") and (menu.library ~= "stationtypes") then
						menu.details.turrettotal = 0
						menu.details.shieldtotal = 0

						local n = C.GetNumUpgradeGroups(0, menu.id)
						local buf = ffi.new("UpgradeGroup[?]", n)
						n = C.GetUpgradeGroups(buf, n, 0, menu.id)
						for i = 0, n - 1 do
							if (ffi.string(buf[i].path) ~= "..") or (ffi.string(buf[i].group) ~= "") then
								local group = { path = ffi.string(buf[i].path), group = ffi.string(buf[i].group) }

								local groupinfo = C.GetUpgradeGroupInfo(0, menu.id, group.path, group.group, "turret")
								menu.details.turrettotal = menu.details.turrettotal + groupinfo.total

								groupinfo = C.GetUpgradeGroupInfo(0, menu.id, group.path, group.group, "shield")
								menu.details.shieldtotal = menu.details.shieldtotal + groupinfo.total
							end
						end
					end
					--print("mode: " .. tostring(mode) .. ", library: " .. tostring(menu.library) .. ", id: " .. tostring(menu.id) .. ", locware: " .. tostring(locware))
					--print("id: " .. tostring(menu.details.id) .. "\n iscrafting: " .. tostring(GetWareData(menu.details.id, "iscrafting")) .. "\n iscraftable: " .. tostring(GetWareData(menu.details.id, "iscraftable")) .. "\n iscraftingresource: " .. tostring(GetWareData(menu.details.id, "iscraftingresource")))
				end

				if (menu.library == "factions") or (menu.library == "licences") or (menu.library == "races") then
					isicon = true
					if menu.library == "licences" then
						menu.object.factionid = rowdata[4]
					end
				elseif (menu.library == "wares") or (menu.library == "inventory_wares") or (menu.library == "software") then
					if menu.object.video ~= "" then
						renderobject = menu.object.video
					else
						-- leave blank. will be set to dummy in menu.setupRenderTarget().
					end
				elseif (menu.library == "weapons_lasers") or (menu.library == "weapons_missilelaunchers") or (menu.library == "enginetypes") then
					local makerrace, ware = GetMacroData(menu.id, "makerraceid", "ware")
					local video = ware and GetWareData(ware, "video") or ""
					if (video ~= "") and (video ~= "ware_noicon_macro") then
						renderobject = video
					else
						local isxenon, iskhaak = false, false
						for _, race in ipairs(makerrace) do
							if race == "xenon" then
								isxenon = true
							end
							if race == "khaak" then
								iskhaak = true
							end
							if isxenon and iskhaak then -- sic! no guarantee that the macro does not define both as makerrace. Also better example if more cases are added.
								break
							end
						end
						if isxenon or iskhaak or (not ware) then
							isicon = true
						else
							renderobject = menu.id
						end
					end
				elseif (menu.library == "shieldgentypes") then
					local makerrace, ware = GetMacroData(menu.id, "makerraceid", "ware")
					local video = ware and GetWareData(ware, "video") or ""
					if (video ~= "") and (video ~= "ware_noicon_macro") then
						renderobject = video
					else
						local iskhaak = false
						for _, race in ipairs(makerrace) do
							if race == "khaak" then
								iskhaak = true
								break
							end
						end
						if iskhaak or (not ware) then
							isicon = true
						else
							renderobject = menu.id
						end
					end
				elseif (menu.library == "paintmods") then
					if GetWareData(menu.id, "ispaintmod") then
						local lastplayership = ConvertStringTo64Bit(tostring(C.GetLastPlayerControlledShipID()))
						if lastplayership and (lastplayership ~= 0) and (not C.IsComponentClass(lastplayership, "spacesuit")) then
							renderobject = GetComponentData(lastplayership, "macro")
						end

						if renderobject == nil then
							local playerobjects = GetContainedObjectsByOwner("player")
							for _, object in ipairs(playerobjects) do
								if IsComponentClass(object, "ship") and (not IsComponentClass(object, "spacesuit")) then
									renderobject = GetComponentData(object, "macro")
									break
								end
							end
						end
						paintmod = menu.id
					end
				else
					renderobject = menu.id
				end
				--print("library: " .. tostring(menu.library) .. ", id: " .. tostring(menu.id))
			end
		end
	else
		menu.mode = rowdata
	end

	--print("menu.mode: " .. tostring(menu.mode))
	if not menu.delayrendertarget then
		if not menu.setupRenderTarget(renderobject, isicon, paintmod, iscomponent) then
			menu.activatecutscene = true
			menu.delayedrenderobject = { renderobject, isicon, paintmod, iscomponent }
		end
	else
		menu.activatecutscene = true
		menu.delayedrenderobject = { renderobject, isicon, paintmod, iscomponent }
		menu.delayrendertarget = nil
	end
end

function menu.getResources(funcware)
	local result = {}
	if not funcware then
		DebugError("menu.getResources called with no ware set.")
		return result
	end

	local locres, productiontime, productionamount = GetWareData(funcware, "resources", "productiontime", "productionamount")
	if locres and #locres > 0 then
		for _, resource in pairs(locres) do
			if type(resource) == "table" then
				resource.name = GetWareData(resource.ware, "name")
				table.insert(result, resource)
				--print(tostring(resource.ware) .. " used to produce " .. tostring(funcware))
			else
				DebugError("menu.getResources. unhandled else case. resource is not a table. resource: " .. tostring(resource))
			end
		end
	end
	return result, productiontime, productionamount
end

function menu.getProducts(funcware)
	local result = {}
	if not funcware then
		DebugError("menu.getProducts called with no ware set.")
		return result
	end

	local locprod = GetWareData(funcware, "products")
	if locprod and #locprod > 0 then
		for _, product in pairs(locprod) do
			local productentry = {ware = product, amount = 1, name = GetWareData(product, "name")}
			table.insert(result, productentry)
			--print(tostring(productentry.ware) .. " produced by " .. tostring(funcware))
		end
	end
	return result
end

function menu.cleanupRenderTarget()
	if menu.cutsceneid then
		--print("stopping cutscene " .. tostring(menu.cutsceneid))
		StopCutscene(menu.cutsceneid)
	end
	if menu.cutscenedesc then
		--print("releasing cutscene descriptor " .. tostring(menu.cutscenedesc))
		ReleaseCutsceneDescriptor(menu.cutscenedesc)
	end
	if menu.precluster then
		--print("destroying cluster " .. tostring(menu.precluster))
		DestroyPresentationCluster(menu.precluster)
	end
	menu.precluster = nil
	menu.preobject = nil
	menu.cutscenedesc = nil
	menu.cutsceneid = nil
	menu.currentrenderobject = nil
end

function menu.setupRenderTarget(renderobject, isicon, paintmod, iscomponent)
	local oldrendertargetmode = menu.rendertargetmode
	--print("menu.setupRenderTarget. oldrendertargetmode: " .. tostring(oldrendertargetmode) .. ", renderobject: " .. tostring(renderobject) .. ", isicon: " .. tostring(isicon) .. ", cutsceneid: " .. tostring(menu.cutsceneid) .. ", menu.delayrendertarget: " .. tostring(menu.delayrendertarget))

	if menu.cutsceneid then
		if not menu.currentrenderobject or not renderobject or (menu.currentrenderobject ~= renderobject) then
			menu.cleanupRenderTarget()
			return false
		end
	end

	if not renderobject then
		if menu.library and menu.id and (not isicon) then
			print("Encyclopedia: ERROR: no usable video found for " .. tostring(menu.library) .. " library entry " .. tostring(menu.id))
		end
		renderobject = "encyclopedia_dummy_macro"
	end

	if isicon then
		menu.rendertargetmode = "icon"
	else
		menu.rendertargetmode = "cutscene"
	end

	if oldrendertargetmode and menu.rendertargetmode and oldrendertargetmode ~= menu.rendertargetmode then
		menu.refresh = true
		menu.delayrendertarget = true
	end

	if not menu.delayrendertarget then
		if not isicon then
			local rendertargetTexture = GetRenderTargetTexture(menu.rendertarget.id)
			--print("rendertarget id: " .. tostring(menu.rendertarget.id) .. ", rendertarget texture: " .. tostring(rendertargetTexture))
			if rendertargetTexture then
				if iscomponent then
					menu.currentrenderobject = ConvertStringTo64Bit(tostring(renderobject))
					menu.cutscenedesc = CreateCutsceneDescriptor("OrbitIndefinitelySlow", { targetobject = menu.currentrenderobject })
					menu.cutsceneid = StartCutscene(menu.cutscenedesc, rendertargetTexture)
				else
					menu.precluster, menu.preobject = CreateObjectInPresentationCluster(renderobject, "cluster_black_wlight_bg_macro")
					menu.currentrenderobject = renderobject
					if menu.preobject then
						if paintmod and IsComponentClass(menu.preobject, "object") then
							C.InstallPaintMod(ConvertIDTo64Bit(menu.preobject), paintmod, false)
						end

						menu.cutscenedesc = CreateCutsceneDescriptor("OrbitIndefinitelySlow", { targetobject = menu.preobject })
						menu.cutsceneid = StartCutscene(menu.cutscenedesc, rendertargetTexture)
						--print("started cutscene")
					end
				end
			end
		elseif oldrendertargetmode and menu.rendertargetmode and oldrendertargetmode ~= menu.rendertargetmode then
			menu.rendertarget = nil
			menu.refresh = true
		end
	end
	return true
end

function menu.buttonExpand(category, rowindex)
	if menu.expanded[category] then
		menu.expanded[category] = nil
	else
		menu.expanded[category] = true
	end

	menu.selectedrow = rowindex
	menu.toprow = GetTopRow(menu.table_index)

	menu.delayrendertarget = true
	menu.display()
end

function menu.buttonToggleEncyclopediaMode(mode)
	if mode == "encyclopedia" then
		AddUITriggeredEvent(menu.name, mode, menu.encyclopediaMode == mode and "off" or "on")
		if menu.encyclopediaMode then
			PlaySound("ui_negative_back")
			menu.encyclopediaMode = nil
		else
			menu.setdefaulttable = true
			PlaySound("ui_positive_select")
			menu.encyclopediaMode = mode
		end
		menu.refresh = true
	elseif mode == "timeline" then
		Helper.closeMenuAndOpenNewMenu(menu, "TimelineMenu", { 0, 0 }, true)
		menu.cleanup()
	elseif mode == "shipcomparison" then
		Helper.closeMenuAndOpenNewMenu(menu, "ShipComparisonMenu", { 0, 0 }, true)
		menu.cleanup()
	end
end

function menu.buttonReadAll()
	C.ReadAllKnownSpaces(0)
	C.ReadAllKnownItems()
	local n = C.GetNumFixedStations(0)
	if n > 0 then
		local buf = ffi.new("UniverseID[?]", n)
		n = C.GetFixedStations(buf, n, 0)
		for i = 0, n - 1 do
			if C.IsKnownToPlayer(buf[i]) then
				C.SetKnownRead(buf[i], true)
			end
		end
	end
	menu.refresh = true
end

function menu.buttonTerraforming(cluster, name)
	Helper.closeMenuAndOpenNewMenu(menu, "TerraformingMenu", { 0, 0, cluster, name })
	menu.cleanup()
end

function menu.buttonClearEditbox(row)
	Helper.cancelEditBoxInput(menu.slottable, row, 1)
	menu.searchtext = nil

	menu.display()
end

function menu.editboxSearchUpdateText(_, text, textchanged)
	menu.noupdate = nil

	if textchanged then
		menu.searchtext = text
	end

	menu.display()
end

function menu.dropdownProductionMethod(_, id)
	if id ~= menu.productionmethod then
		menu.productionmethod = id
		menu.display()
	end
end

function menu.deactivateEncyclopediaMode()
	PlaySound("ui_negative_back")
	menu.encyclopediaMode = nil
	menu.refresh = true
end

function menu.getNumEntries(category)
	local numentries = 0
	local numunread = 0
	for subcategory in pairs(menu.data[category]) do
		if category ~= "Factions" then
			numentries = numentries + GetLibrarySize(subcategory)
		else
			local factionlibrary = GetLibrary("factions")
			for i, faction in ipairs(factionlibrary) do
				if faction.id == "player" then
					C.ReadKnownItem("factions", faction.id, true)
					table.remove(factionlibrary, i)
					break
				end
			end
			numentries = #factionlibrary
			for subcategory, _ in pairs(menu.data["Factions"]) do
				for _, faction in ipairs(menu.data["Factions"][subcategory]) do
					numentries = numentries + faction.numlicences
					for _, licence in ipairs(faction.licences) do
						if not C.IsKnownItemRead("licences", licence.id) then
							numunread = numunread + 1
						end
					end
				end
			end
		end
		numunread = numunread + C.GetNumUnreadLibraryEntries(subcategory)
	end

	return numentries, numunread
end

function menu.addDetailRow(ftable, col1, col2, col3, offsetx, iswordwrap, properties1, properties2, properties3)
	menu.numDetailRows = menu.numDetailRows + 1

	properties1 = properties1 or {}
	properties1.halign = "left"
	properties1.x = offsetx
	properties1.wordwrap = iswordwrap
	properties2 = properties2 or {}
	properties2.halign = "right"
	properties2.wordwrap = iswordwrap
	properties3 = properties3 or {}
	properties3.halign = "right"
	properties3.wordwrap = iswordwrap

	local row = ftable:addRow(("detailrow_" .. menu.numDetailRows), { interactive = false })
	if col3 then
		row[2]:createText(col1, properties1)
		row[3]:createText(col2, properties2)
		row[4]:createText(col3, properties3)
	elseif col2 then
		row[2]:createText(col1, properties1)
		row[3]:setColSpan(2):createText(col2, properties2)
	else
		row[2]:setColSpan(3):createText(col1, properties1)
	end
end

function menu.addEngineDetailRow(ftable, name, thruster, hasdefaultloadout)
	menu.addDetailRow(ftable, name .. ((not hasdefaultloadout) and " (" .. thruster.name .. ")" or ""), ConvertIntegerString(thruster.value, true, 0, true) .. " " .. thruster.unit)
end

function menu.addProductionMethodDetails(ftable, resourcestring, methodstring, showtime, showamount)
	-- title
	local row = ftable:addRow(false, {  })
	row[2]:setColSpan(3):createText(resourcestring, Helper.subHeaderTextProperties)
	row[2].properties.halign = "center"

	menu.numDetailRows = menu.numDetailRows + 1
	local row = ftable:addRow(("detailrow_" .. menu.numDetailRows), { interactive = false })
	row[2]:createText(methodstring .. ReadText(1001, 120))
	local productionmethodoptions = {}
	local currentMethodIdx = 0
	for i, entry in ipairs(menu.details.productionmethods) do
		table.insert(productionmethodoptions, { id = entry.method, text = entry.name, icon = "", displayremoveoption = false })
		if entry.method == menu.productionmethod then
			currentMethodIdx = i
		end
	end
	if currentMethodIdx == 0 then
		currentMethodIdx = 1
		menu.productionmethod = menu.details.productionmethods[1].method
	end
	row[3]:setColSpan(2):createDropDown(productionmethodoptions, { startOption = menu.productionmethod }):setTextProperties({ halign = "right", x = Helper.standardTextOffsetx })
	row[3].handlers.onDropDownConfirmed = menu.dropdownProductionMethod
	for i, entry in ipairs(menu.details.productionmethods[currentMethodIdx].resources) do
		menu.addDetailRow(ftable, "", ConvertIntegerString(entry.amount, true, 0, true) .. ReadText(1001, 42) .. " " .. entry.name)
	end
	if showamount then
		-- empty line
		menu.addDetailRow(ftable, "")
		-- Production Amount
		menu.addDetailRow(ftable, showamount, ConvertIntegerString(menu.details.productionmethods[currentMethodIdx].productionamount, true, 0, true) .. ReadText(1001, 42) .. " " .. menu.object.name)
	end
	if showtime then
		if not showamount then
			-- empty line
			menu.addDetailRow(ftable, "")
		end
		-- buildtime
		menu.addDetailRow(ftable, showtime .. ReadText(1001, 120), ConvertTimeString(menu.details.productionmethods[currentMethodIdx].productiontime, ReadText(1001, 209)))
	end
end

function menu.addDetailRows(ftable)
	if menu.object then
		if menu.mode == "Galaxy" then
			if type(menu.object) == "number" then
				local clusters = menu.data["Galaxy"][menu.object].clusters
				-- space for sector case
				menu.addDetailRow(ftable, "")
				-- workforce
				local stationtable = {}
				for _, cluster in ipairs(clusters) do
					local stations = GetContainedStations(cluster, true)
					for _, station in ipairs(stations) do
						table.insert(stationtable, station)
					end
				end
				local spacepopulation = 0
				for _, station in ipairs(stationtable) do
					local workforceinfo = C.GetWorkForceInfo(ConvertStringTo64Bit(tostring(station)), "")
					spacepopulation = spacepopulation + workforceinfo.current
				end
				menu.addDetailRow(ftable, ReadText(1001, 2456), ConvertIntegerString(spacepopulation, true, 0, true))
				-- space for sector case
				menu.addDetailRow(ftable, "")
				-- spacing
				menu.addDetailRow(ftable, "")
				-- stations
				local numstations = 0
				for _, cluster in ipairs(clusters) do
					local stations = GetContainedStations(cluster, true)
					numstations = numstations + #stations
				end
				menu.addDetailRow(ftable, ReadText(1001, 9042), ConvertIntegerString(numstations, true, 0, true))
				-- products
				local stationtable = {}
				for _, cluster in ipairs(clusters) do
					local stations = GetContainedStations(cluster, true)
					for _, station in ipairs(stations) do
						table.insert(stationtable, station)
					end
				end
				local productiontable = {}
				local products = {}
				local sortedProducts = {}
				for _, station in ipairs(stationtable) do
					local productionmodules = GetProductionModules(station)
					for _, module in ipairs(productionmodules) do
						table.insert(productiontable, GetComponentData(module, "products"))
					end
				end
				for _, entry in ipairs(productiontable) do
					for _, product in ipairs(entry) do
						local notincremented = true
						for compproduct, count in pairs(products) do
							if compproduct == product then
								products[product] = count + 1
								notincremented = false
								break
							end
						end
						if notincremented then
							products[product] = 1
						end
					end
				end
				local maxproductgrp = ReadText(1001, 9002)	-- "Unknown"
				local maxcount = 0
				for product, count in pairs(products) do
					local name, groupName = GetWareData(product, "name", "groupName")
					if not maxproductgrp or (count > maxcount) then
						maxproductgrp = groupName
						maxcount = count
					end
					table.insert(sortedProducts, { name = name, count = count })
				end
				menu.addDetailRow(ftable, ReadText(1001, 9050), maxproductgrp)
				table.sort(sortedProducts, Helper.sortName)
				for i, entry in pairs(sortedProducts) do
					menu.addDetailRow(ftable, (i == 1) and ReadText(1001, 9094) or "", entry.count .. ReadText(1001, 42) .. " " .. entry.name)
				end

				-- start: kuertee call-back
				if callbacks ["addDetailRow_known_cluster_production_module_entries"] then		
						for _, callback in ipairs (callbacks ["addDetailRow_known_cluster_production_module_entries"]) do
						callback(ftable, clusters)
				    end		
				end
				-- end: kuertee call-back

			else
				-- owner
				if IsComponentClass(menu.object, "sector") then
					local owner = GetComponentData(menu.object, "ownername")
					if C.IsContestedSector(ConvertIDTo64Bit(menu.object)) then
						owner = owner .. " " .. ReadText(1001, 3247)
					end
					menu.addDetailRow(ftable, ReadText(1001, 2455), owner)
				end
				-- workforce
				local stationtable = GetContainedStations(menu.object, true)
				local spacepopulation = 0
				for _, station in ipairs(stationtable) do
					local workforceinfo = C.GetWorkForceInfo(ConvertStringTo64Bit(tostring(station)), "")
					spacepopulation = spacepopulation + workforceinfo.current
				end
				menu.addDetailRow(ftable, ReadText(1001, 2456), ConvertIntegerString(spacepopulation, true, 0, true))
				-- spacing
				menu.addDetailRow(ftable, "")
				-- resources
				menu.addDetailRow(ftable, ReadText(1001, 9423) .. ReadText(1001, 120))
				-- sunlight
				local sunlight = GetComponentData(menu.object, "sunlight") * 100 .. "%"
				menu.addDetailRow(ftable, ReadText(1001, 2412), sunlight, nil, 25)
				-- regions
				local resources = {}
				local n = C.GetNumDiscoveredSectorResources(ConvertIDTo64Bit(menu.object))
				local buf = ffi.new("WareYield[?]", n)
				n = C.GetDiscoveredSectorResources(buf, n, ConvertIDTo64Bit(menu.object))
				for i = 0, n - 1 do
					table.insert(resources, { name = GetWareData(ffi.string(buf[i].ware), "name"), current = buf[i].current, max = buf[i].max })
				end
				table.sort(resources, Helper.sortName)

				for _, entry in ipairs(resources) do
					menu.addDetailRow(ftable, entry.name, ConvertIntegerString(entry.current, true, 3, true), nil, 25)
				end
				-- spacing
				menu.addDetailRow(ftable, "")
				-- stations
				local stationtable = GetContainedStations(menu.object, true)
				local numstations = #stationtable
				menu.addDetailRow(ftable, ReadText(1001, 9042), ConvertIntegerString(numstations, true, 0, true))
				-- products
				local stationtable = GetContainedStations(menu.object, true)
				local productiontable = {}
				local products = {}
				local sortedProducts = {}
				for _, station in ipairs(stationtable) do
					local productionmodules = GetProductionModules(station)
					for _, module in ipairs(productionmodules) do
						table.insert(productiontable, GetComponentData(module, "products"))
					end
				end
				for _, entry in ipairs(productiontable) do
					for _, product in ipairs(entry) do
						local notincremented = true
						for compproduct, count in pairs(products) do
							if compproduct == product then
								products[product] = count + 1
								notincremented = false
								break
							end
						end
						if notincremented then
							products[product] = 1
						end
					end
				end
				local maxproductgrp = ReadText(1001, 9002)	-- "Unknown"
				local maxcount = 0
				for product, count in pairs(products) do
					local name, groupName = GetWareData(product, "name", "groupName")
					if not maxproductgrp or (count > maxcount) then
						maxproductgrp = groupName
						maxcount = count
					end
					table.insert(sortedProducts, { name = name, count = count })
				end
				menu.addDetailRow(ftable, ReadText(1001, 9050), maxproductgrp)
				table.sort(sortedProducts, Helper.sortName)
				for i, entry in pairs(sortedProducts) do
					menu.addDetailRow(ftable, (i == 1) and ReadText(1001, 9094) or "", entry.count .. ReadText(1001, 42) .. " " .. entry.name)
				end

				-- start: kuertee call-back
				if callbacks ["addDetailRow_known_sector_production_module_entries"] then		
						for _, callback in ipairs (callbacks ["addDetailRow_known_sector_production_module_entries"]) do
						callback(ftable, menu.object)
				    end		
				end
				-- end: kuertee call-back

			end
			if (type(menu.object) == "number") or (#menu.details.sectors == 1) then
				local data = menu.details.systeminfo

				-- empty line
				menu.addDetailRow(ftable, "")
				-- header
				local row = ftable:addRow(false, {  })
				row[2]:setColSpan(3):createText(ReadText(1001, 2491), Helper.headerRow1Properties)
				if data.space then
					-- space environment
					menu.addDetailRow(ftable, ReadText(1001, 2471), data.space.environment)
				end
				if data.suns and (#data.suns > 0) then
					-- suns
					for _, sun in ipairs(data.suns) do
						menu.addDetailRow(ftable, "\27[ency_sun_01]" .. sun.name, sun.class)
					end
				end
				if data.planets and (#data.planets > 0) then
					-- planets
					for i, planet in ipairs(data.planets) do
						if i > 1 then
							-- empty line
							menu.addDetailRow(ftable, "")
						end
						local row = ftable:addRow(true, {  })
						row[2]:createText("\27[ency_planet_01]" .. planet.name, { x = 25 })
						if planet.hasterraforming then
							row[3]:setColSpan(2):createButton({  }):setText(ReadText(1001, 9099), { halign = "center" })
							row[3].handlers.onClick = function () return menu.buttonTerraforming(menu.details.clusters[1], "\27[ency_planet_01]" .. planet.name) end
						end
						if planet.class ~= "" then
							menu.addDetailRow(ftable, ReadText(1001, 9616), planet.class, nil, 50)
						end
						menu.addDetailRow(ftable, ReadText(1001, 2466), planet.population, nil, 50)
						menu.addDetailRow(ftable, ReadText(1001, 2492), planet.settlements, nil, 50)
						menu.addDetailRow(ftable, ReadText(1001, 2469), planet.atmosphere, nil, 50)
						menu.addDetailRow(ftable, ReadText(1001, 2470), planet.geology, nil, 50)
						if planet.moons and (#planet.moons > 0) then
							-- moons
							for _, moon in ipairs(planet.moons) do
								local row = ftable:addRow(true, {  })
								row[2]:createText("\27[ency_moon_01]" .. moon.name, { x = 50 })
								if moon.hasterraforming then
									row[3]:setColSpan(2):createButton({  }):setText(ReadText(1001, 9099), { halign = "center" })
									row[3].handlers.onClick = function () return menu.buttonTerraforming(menu.details.clusters[1], "\27[ency_moon_01]" .. moon.name) end
								end
								if moon.class ~= "" then
									menu.addDetailRow(ftable, ReadText(1001, 9617), moon.class, nil, 75)
								end
								menu.addDetailRow(ftable, ReadText(1001, 2466), moon.population, nil, 75)
								menu.addDetailRow(ftable, ReadText(1001, 2492), moon.settlements, nil, 75)
								menu.addDetailRow(ftable, ReadText(1001, 2469), moon.atmosphere, nil, 75)
								menu.addDetailRow(ftable, ReadText(1001, 2470), moon.geology, nil, 75)
							end
						end
					end
				end
			end

		elseif menu.mode == "Races" then
			-- primary factions
			if #menu.object.primaryfactions > 0 then
				table.sort(menu.object.primaryfactions, Helper.sortFactionName)
				menu.addDetailRow(ftable, ReadText(1001, 2499) .. ReadText(1001, 120))
				for _, faction in ipairs(menu.object.primaryfactions) do
					if faction ~= "player" then
						menu.addDetailRow(ftable, "", GetFactionData(faction, "name"))
					end
				end
			end
			-- food
			if #menu.object.resources > 0 then
				table.sort(menu.object.resources, Helper.sortName)
				menu.addDetailRow(ftable, ReadText(1001, 9098) .. ReadText(1001, 120))
				for _, resourceentry in ipairs(menu.object.resources) do
					menu.addDetailRow(ftable, "", resourceentry.name)
				end
			end

		elseif menu.mode == "Factions" then
			-- representative
			local factionrep = ConvertStringTo64Bit(tostring(C.GetFactionRepresentative(menu.id)))
			local printedtitle = ((factionrep ~= 0) and GetComponentData(factionrep, "isfemale") and ReadText(20208, 10602)) or ReadText(20208, 10601)	-- Faction Representative(female), Faction Representative(male)
			local printedname = ReadText(1001, 9002)		-- Unknown
			if factionrep ~= 0 then
				printedname = ffi.string(C.GetComponentName(factionrep))
			end
			menu.addDetailRow(ftable, printedtitle, printedname)
			-- HQ
			local hqlist = {}
			Helper.ffiVLA(hqlist, "UniverseID", C.GetNumHQs, C.GetHQs, menu.id)
			-- each faction is only supposed to have one HQ, the player included. if a faction is modded to have more, only print the first one.
			local data = ReadText(1001, 9002)		-- Unknown
			if #hqlist > 0 then
				data = ffi.string(C.GetComponentName(ConvertIDTo64Bit(GetComponentData( ConvertStringTo64Bit(tostring(hqlist[1])), "sectorid" ))))
			end
			menu.addDetailRow(ftable, ReadText(1001, 9600), data)
			-- police
			local data = ReadText(1001, 9002)		-- Unknown
			local policefaction = GetFactionData(menu.id, "policefaction")
			if policefaction then
				data = GetFactionData(policefaction, "name")
			end
			menu.addDetailRow(ftable, ReadText(1001, 9601), data)
			-- illegal wares
			if menu.id == policefaction then
				if #menu.object.illegalwares > 0 then
					table.sort(menu.object.illegalwares, Helper.sortName)
					menu.addDetailRow(ftable, ReadText(1001, 2435) .. ReadText(1001, 120))
					for _, wareentry in ipairs(menu.object.illegalwares) do
						menu.addDetailRow(ftable, "", wareentry.name)
					end
				end
			end
			-- Allies
			menu.addDetailRow(ftable, ReadText(1001, 9603) .. ReadText(1001, 120), nil, nil, nil, nil, { mouseOverText = ReadText(1026, 2403) })
			for i, entry in ipairs(menu.details.allies) do
				menu.addDetailRow(ftable, "", entry.name, nil, nil, nil, nil, { font = (entry.id == "player") and Helper.standardFontBold or nil })
			end
			-- Enemies
			menu.addDetailRow(ftable, ReadText(1001, 9604) .. ReadText(1001, 120), nil, nil, nil, nil, { mouseOverText = ReadText(1026, 2402) })
			for i, entry in ipairs(menu.details.enemies) do
				menu.addDetailRow(ftable, "", entry.name, nil, nil, nil, nil, { font = (entry.id == "player") and Helper.standardFontBold or nil, color = menu.holomapcolor.enemycolor })
			end
			-- Hostiles
			menu.addDetailRow(ftable, ReadText(1001, 9632) .. ReadText(1001, 120), nil, nil, nil, nil, { mouseOverText = ReadText(1026, 2401) })
			for i, entry in ipairs(menu.details.hostiles) do
				menu.addDetailRow(ftable, "", entry.name, nil, nil, nil, nil, { font = (entry.id == "player") and Helper.standardFontBold or nil, color = menu.holomapcolor.hostilecolor })
			end
			-- Your Relation
			menu.addDetailRow(ftable, ReadText(1001, 9636) .. ReadText(1001, 120))
			menu.addDetailRow(ftable, ffi.string(C.GenerateFactionRelationText(menu.id)), nil, nil, 25)
			-- empty line
			menu.addDetailRow(ftable, "")
			-- Sectors
			menu.addDetailRow(ftable, ReadText(1001, 2459) .. ReadText(1001, 120))
			for i, entry in ipairs(menu.details.sectors) do
				menu.addDetailRow(ftable, "", ffi.string(C.GetComponentName(entry)))
			end

		elseif menu.mode == "Stations" then
			if menu.library ~= "stationtypes" then
				-- hull
				menu.addDetailRow(ftable, ReadText(1001, 9083), ConvertIntegerString(menu.object.hull, true, 0, true) .. " " .. ReadText(1001, 118))
				-- canclaim
				if menu.object.canclaim then
					menu.addDetailRow(ftable, ReadText(1001, 9637), ReadText(1001, 2617))
				end
				-- storage
				if menu.object.storagecapacity and menu.object.storagecapacity > 0 then
					-- storage capacity
					menu.addDetailRow(ftable, ReadText(1001, 9063), ConvertIntegerString(menu.object.storagecapacity, true, 0, true))
					-- storage types
					menu.addDetailRow(ftable, ReadText(1001, 9064), menu.object.storagenames)
				end
				-- workforce
				if menu.object.workforcecapacity and menu.object.workforcecapacity > 0 then
					menu.addDetailRow(ftable, ReadText(1001, 9611), menu.object.workforcecapacity)
				end
				-- workforcemax
				if menu.object.maxworkforce and menu.object.maxworkforce > 0 then
					menu.addDetailRow(ftable, ReadText(1001, 7992), menu.object.maxworkforce)
				end
				-- ship storage
				if menu.object.shipstoragecapacity > 0 then
					menu.addDetailRow(ftable, ReadText(1001, 9612), menu.object.shipstoragecapacity)
				end
				-- upgrades
				if menu.details.turrettotal > 0 or menu.details.shieldtotal > 0 then
					-- turrets
					menu.addDetailRow(ftable, ReadText(1001, 1319), menu.details.turrettotal)
					-- shields
					menu.addDetailRow(ftable, ReadText(1001, 1317), menu.details.shieldtotal)
				end
				-- units
				if menu.object.unitcapacity > 0 then
					menu.addDetailRow(ftable, ReadText(1001, 9062), menu.object.unitcapacity)
				end
				-- missiles
				if menu.object.missilecapacity > 0 then
					menu.addDetailRow(ftable, ReadText(1001, 9061), menu.object.missilecapacity)
				end

				-- products
				if menu.object.products and #menu.object.products > 0 then
					menu.addDetailRow(ftable, "")
					local queueduration = 0
					for i, proddata in ipairs(menu.object.products) do
						queueduration = queueduration + proddata.cycle
					end
					for i, proddata in ipairs(menu.object.products) do
						local row = ftable:addRow(false, {  })
						row[2]:setColSpan(3):createText(proddata.name, Helper.subHeaderTextProperties)
						row[2].properties.halign = "center"

						menu.addDetailRow(ftable, ReadText(1001, 9609) .. ReadText(1001, 120), ConvertIntegerString(proddata.amount, true, 0, true) .. ReadText(1001, 42) .. " " .. proddata.name)
						for j, resourcedata in ipairs(proddata.resources) do
							resourcedata.name = GetWareData(resourcedata.ware, "name")
							menu.addDetailRow(ftable, (j == 1) and (ReadText(1001, 9614) .. ReadText(1001, 120)) or "", ConvertIntegerString(resourcedata.amount, true, 0, true) .. ReadText(1001, 42) .. " " .. resourcedata.name)
						end
						if not IsMacroClass(menu.id, "processingmodule") then
							menu.addDetailRow(ftable, ReadText(1001, 2411) .. ReadText(1001, 120), ConvertTimeString(proddata.cycle, ReadText(1001, 209)))
							menu.addDetailRow(ftable, "")
							menu.addDetailRow(ftable, ReadText(1001, 9624) .. " / " .. ReadText(1001, 102) .. ReadText(1001, 120), Helper.round(3600 / queueduration, 2))
							menu.addDetailRow(ftable, ReadText(1001, 1624) .. " / " .. ReadText(1001, 102) .. ReadText(1001, 120), ConvertIntegerString((queueduration > 0) and Helper.round(proddata.amount * 3600 / queueduration) or 0, true, 0, true) .. ReadText(1001, 42) .. " " .. proddata.name)
							for j, resourcedata in ipairs(proddata.resources) do
								resourcedata.name = GetWareData(resourcedata.ware, "name")
								menu.addDetailRow(ftable, (j == 1) and (ReadText(1001, 7403) .. " / " .. ReadText(1001, 102) .. ReadText(1001, 120)) or "", ConvertIntegerString((queueduration > 0) and Helper.round(resourcedata.amount * 3600 / queueduration) or 0, true, 0, true) .. ReadText(1001, 42) .. " " .. resourcedata.name)
							end
						end
						if i < #menu.object.products then
							menu.addDetailRow(ftable, "")
						end
					end
				end

				-- build resources
				if menu.details.productionmethods and (#menu.details.productionmethods > 0) then
					-- empty line
					menu.addDetailRow(ftable, "")
					menu.addProductionMethodDetails(ftable, ReadText(1001, 9613), ReadText(1001, 9652), ReadText(1001, 8508))
				end
			end

		elseif menu.mode == "Ships" then
			local hasdefaultloadout = C.HasDefaultLoadout2(menu.id, true)
			local shipmakerraces = GetMacroData(menu.id, "makerraceid")
			-- hull
			menu.addDetailRow(ftable, ReadText(1001, 9083), ConvertIntegerString(menu.object.hull, true, 0, true) .. " " .. ReadText(1001, 118))
			-- ship type

			-- start: alexandretk call-back
			if callbacks ["onShowMenu_addOtherShipTypes"] then
				for _, callback in ipairs (callbacks ["onShowMenu_addOtherShipTypes"]) do
					callback(menu, ftable)
				end
			else
			-- end: alexandretk call-back

				menu.addDetailRow(ftable, ReadText(1001, 9051), menu.object.shiptypename)

			end


			-- ship size
			local sizename = Helper.getClassText(ffi.string(C.GetMacroClass(menu.id)))
			if sizename ~= "" then
				menu.addDetailRow(ftable, ReadText(1001, 9648), sizename)
			end
			-- mass
			menu.addDetailRow(ftable, ReadText(1001, 9052), ConvertIntegerString(menu.object.mass, true, 0, true) .. " " .. ReadText(1001, 116))
			-- empty line
			menu.addDetailRow(ftable, "")
			-- engine
			local bestengines = {
				["thrust_forward"]			= { name = ReadText(1001, 9003),	value = 0,	dragproperty = "drag_forward",	unit = ReadText(1001, 113) },
				["boost_thrustfactor"]		= { name = ReadText(1001, 9003),	value = 0,	dragproperty = "drag_forward",	unit = ReadText(1001, 113),		multiply_thrust = true },
				["travel_thrustfactor"]		= { name = ReadText(1001, 9003),	value = 0,	dragproperty = "drag_forward",	unit = ReadText(1001, 113),		multiply_thrust = true },
			}

			local numslots = tonumber(C.GetNumUpgradeSlots(0, menu.id, "engine"))
			if hasdefaultloadout and menu.preobject then
				local enginemacro = ffi.string(C.GetUpgradeSlotCurrentMacro(ConvertIDTo64Bit(menu.preobject), 0, "engine", 1))
				if enginemacro ~= "" then
					local bestengine = GetLibraryEntry("enginetypes", enginemacro)
					if next(bestengine) then
						for _, entry in pairs(bestengines) do
							entry.engine = bestengine
						end
					end
				end
			else
				for i = 1, numslots do
					for _, engine in pairs(menu.data.Equipment.enginetypes) do
						local makerrace, ware = GetMacroData(engine.id, "makerraceid", "ware")
						local allowed = menu.isMakerRaceAllowed(makerrace, shipmakerraces)
						if allowed and (not ware or GetWareData(ware, "volatile")) then
							allowed = false
						end
						if allowed then
							if C.IsUpgradeMacroCompatible(0, 0, menu.id, false, "engine", i, engine.id) then
								local evalengine = GetLibraryEntry("enginetypes", engine.id)
								for property, entry in pairs(bestengines) do
									if (not entry.engine) or evalengine[property] * (entry.multiply_thrust and evalengine.thrust_forward or 1) > entry.engine[property] * (entry.multiply_thrust and entry.engine.thrust_forward or 1) then
										entry.engine = evalengine
									end
								end
							end
						end
					end
				end
			end
			local maxaccel = 0
			for property, entry in pairs(bestengines) do
				if type(entry.engine) == "table" then
					entry.value = entry.engine[property] * numslots / menu.object[entry.dragproperty]
					if entry.multiply_thrust then
						entry.value = entry.value * entry.engine.thrust_forward
					end
					entry.name = entry.engine.name

					if property == "thrust_forward" then
						maxaccel = entry.engine[property] * numslots / menu.object.mass
					end
				end
			end

			-- max speed
			menu.addEngineDetailRow(ftable, ReadText(1001, 9054), bestengines["thrust_forward"], hasdefaultloadout)
			-- boost speed
			menu.addEngineDetailRow(ftable, ReadText(1001, 8052), bestengines["boost_thrustfactor"], hasdefaultloadout)
			-- travel speed
			menu.addEngineDetailRow(ftable, ReadText(1001, 8053), bestengines["travel_thrustfactor"], hasdefaultloadout)
			-- max acceleration
			menu.addDetailRow(ftable, ReadText(1001, 9053) .. ((not hasdefaultloadout) and " (" .. bestengines["thrust_forward"].name .. ")" or ""), ConvertIntegerString(maxaccel, true, 0, true) .. " " .. ReadText(1001, 111))
			-- empty line
			menu.addDetailRow(ftable, "")
			-- thruster
			local bestthrusters = {
				["thrust_yaw"]			= { name = ReadText(1001, 9003),	value = 0,	dragproperty = "drag_yaw",			unit = ReadText(1001, 117),		rotational = true },
				["thrust_pitch"]		= { name = ReadText(1001, 9003),	value = 0,	dragproperty = "drag_pitch",		unit = ReadText(1001, 117),		rotational = true },
				["thrust_vertical"]		= { name = ReadText(1001, 9003),	value = 0,	dragproperty = "drag_vertical",		unit = ReadText(1001, 113) },
				["thrust_horizontal"]	= { name = ReadText(1001, 9003),	value = 0,	dragproperty = "drag_horizontal",	unit = ReadText(1001, 113) },
			}

			if hasdefaultloadout and menu.preobject then
				local bestthruster
				if IsComponentClass(menu.preobject, "ship_xs") then
					bestthruster = GetLibraryEntry( "enginetypes", ffi.string(C.GetUpgradeSlotCurrentMacro(ConvertIDTo64Bit(menu.preobject), 0, "engine", 1)) )
				else
					bestthruster = GetLibraryEntry( "enginetypes", ffi.string(C.GetUpgradeSlotCurrentMacro(ConvertIDTo64Bit(menu.preobject), 0, "thruster", 1)) )
				end
				for _, entry in pairs(bestthrusters) do
					entry.thruster = bestthruster
				end
			else
				local numslots = tonumber(C.GetNumVirtualUpgradeSlots(0, menu.id, "thruster"))
				for i = 1, numslots do
					for _, thruster in pairs(menu.data.Equipment.thrustertypes) do
						local makerrace, ware = GetMacroData(thruster.id, "makerraceid", "ware")
						local allowed = menu.isMakerRaceAllowed(makerrace, shipmakerraces)
						if allowed and (not ware or GetWareData(ware, "volatile")) then
							allowed = false
						end
						if allowed then
							if C.IsVirtualUpgradeMacroCompatible(0, menu.id, "thruster", i, thruster.id) then
								local evalthruster = GetLibraryEntry("enginetypes", thruster.id)
								for property, entry in pairs(bestthrusters) do
									if (not entry.thruster) or evalthruster[property] > entry.thruster[property] then
										entry.thruster = evalthruster
									end
								end
							end
						end
					end
				end
			end
			local responsiveness = menu.object.drag_yaw / menu.object.inertia_yaw
			for property, entry in pairs(bestthrusters) do
				if type(entry.thruster) == "table" then
					entry.value = entry.thruster[property] / menu.object[entry.dragproperty]
					if entry.rotational then
						entry.value = entry.value * 180 / math.pi
					end
					entry.name = entry.thruster.name
				end
			end

			-- turning rate
			menu.addEngineDetailRow(ftable, ReadText(1001, 9055), bestthrusters["thrust_yaw"], hasdefaultloadout)
			-- pitch rate
			menu.addEngineDetailRow(ftable, ReadText(1001, 9056), bestthrusters["thrust_pitch"], hasdefaultloadout)
			-- responsiveness
			menu.addDetailRow(ftable, ReadText(1001, 9057), Helper.round(responsiveness, 3))
			-- empty line
			menu.addDetailRow(ftable, "")
			-- vertical strafe
			menu.addEngineDetailRow(ftable, ReadText(1001, 9058), bestthrusters["thrust_vertical"], hasdefaultloadout)
			-- horizontal strafe
			menu.addEngineDetailRow(ftable, ReadText(1001, 9059), bestthrusters["thrust_horizontal"], hasdefaultloadout)
			-- empty line
			menu.addDetailRow(ftable, "")
			-- shields
			local numslots = tonumber(C.GetNumUpgradeSlots(0, menu.id, "shield"))
			menu.addDetailRow(ftable, ReadText(1001, 2490), ConvertIntegerString(numslots, true, 0, true))
			-- shield capacity
			-- all known shield generators are in menu.data["Equipment"]["shieldgentypes"]
			local bestshield
			local bestname = ReadText(1001, 9003)	-- "No Known Component"
			local numslots = tonumber(C.GetNumUpgradeSlots(0, menu.id, "shield"))
			for i = numslots, 1, -1 do
				local locgroup = C.GetUpgradeSlotGroup(0, menu.id, "shield", i)
				if (ffi.string(locgroup.path) == "..") and (ffi.string(locgroup.group) == "") then
					for _, shieldgen in pairs(menu.data.Equipment.shieldgentypes) do
						-- check all aliases due to collision / no-collision compatibilities
						local n = C.GetNumLibraryEntryAliases("shieldgentypes", shieldgen.id)
						local buf = ffi.new("const char*[?]", n)
						n = C.GetLibraryEntryAliases(buf, n, "shieldgentypes", shieldgen.id)
						for j = 0, n - 1 do
							local aliasid = ffi.string(buf[j])
							local makerrace = GetMacroData(aliasid, "makerraceid")
							local allowed = menu.isMakerRaceAllowed(makerrace, shipmakerraces)
							if allowed then
								if C.IsUpgradeMacroCompatible(0, 0, menu.id, false, "shield", i, aliasid) then
									local evalshieldgen = GetLibraryEntry("shieldgentypes", aliasid)
									if not bestshield or evalshieldgen.shield > bestshield.shield then
										bestshield = evalshieldgen
									end
								end
							end
						end
					end
				else
					numslots = numslots - 1
				end
			end
			local totalshieldcapacity = 0
			if type(bestshield) == "table" and bestshield.shield then
				totalshieldcapacity = bestshield.shield * numslots
				bestname = bestshield.name
			end
			menu.addDetailRow(ftable, ReadText(1001, 9060) .. ((not hasdefaultloadout) and " (" .. (bestshield and (numslots .. ReadText(1001, 42) .. " ") or "") .. bestname .. ")" or ""), ConvertIntegerString(totalshieldcapacity, true, 0, true) .. " " .. ReadText(1001, 118))
			-- empty line
			menu.addDetailRow(ftable, "")
			-- weapons
			local numslots = tonumber(C.GetNumUpgradeSlots(0, menu.id, "weapon"))
			menu.addDetailRow(ftable, ReadText(1001, 1301), ConvertIntegerString(numslots, true, 0, true))
			-- turrets
			local numslots = tonumber(C.GetNumUpgradeSlots(0, menu.id, "turret"))
			local slotsizes = {
				[1] = { id = "large", text = ReadText(1001, 8081) },
				[2] = { id = "medium", text = ReadText(1001, 8080) },
			}
			local slotspersize = {
				["medium"] = 0,
				["large"] = 0,
			}
			for i = 1, numslots do
				local slotsize = ffi.string(C.GetSlotSize(0, 0, menu.id, false, "turret", i))
				if slotspersize[slotsize] then
					slotspersize[slotsize] = slotspersize[slotsize] + 1
				end
			end
			for _, entry in ipairs(slotsizes) do
				if slotspersize[entry.id] > 0 then
					menu.addDetailRow(ftable, entry.text, ConvertIntegerString(slotspersize[entry.id], true, 0, true))
				end
			end
			-- missile storage
			menu.addDetailRow(ftable, ReadText(1001, 9061), ConvertIntegerString(C.GetDefaultMissileStorageCapacity(menu.id), true, 0, true))

			-- start: kuertee call-back
			if callbacks ["addDetailRow_post_missile_entry"] then		
					for _, callback in ipairs (callbacks ["addDetailRow_post_missile_entry"]) do
					callback(ftable, col1, col2, col3, offsetx, iswordwrap, properties1, properties2, properties3, entry)
			    end		
			end
			-- end: kuertee call-back

			-- empty line
			menu.addDetailRow(ftable, "")
			-- crew capacity
			menu.addDetailRow(ftable, ReadText(1001, 9078), ConvertIntegerString(C.GetPeopleCapacity(0, menu.id, true), true, 0, true))
			-- empty line
			menu.addDetailRow(ftable, "")
			-- storage capacity
			menu.addDetailRow(ftable, ReadText(1001, 9063), ConvertIntegerString(menu.object.storagecapacity, true, 0, true))
			-- storage types
			menu.addDetailRow(ftable, ReadText(1001, 9064), menu.object.storagenames)
			-- empty line
			menu.addDetailRow(ftable, "")
			-- m docks
			menu.addDetailRow(ftable, ReadText(1001, 7952), ConvertIntegerString(menu.object.docks_m, true, 0, true))
			-- s docks
			menu.addDetailRow(ftable, ReadText(1001, 7953), ConvertIntegerString(menu.object.docks_s, true, 0, true))
			-- ship storage
			menu.addDetailRow(ftable, ReadText(1001, 9612), ConvertIntegerString(menu.object.shipstoragecapacity, true, 0, true))
			-- units
			menu.addDetailRow(ftable, ReadText(1001, 9062), ConvertIntegerString(menu.object.unitcapacity, true, 0, true))
			-- build resources
			if menu.details.productionmethods and (#menu.details.productionmethods > 0) then
				-- empty line
				menu.addDetailRow(ftable, "")
				if #menu.details.blueprintowners > 0 then
					-- produced by
					menu.addDetailRow(ftable, ReadText(1001, 8391) .. ReadText(1001, 120))
					for i, entry in ipairs(menu.details.blueprintowners) do
						menu.addDetailRow(ftable, "", GetFactionData(entry, "name"))
					end
				end
				-- resources
				menu.addDetailRow(ftable, "")
				menu.addProductionMethodDetails(ftable, ReadText(1001, 9613), ReadText(1001, 9652))
			end

		elseif menu.mode == "Weapons" then
			-- overridden for component types that have to be constructed in situ or those that have to be crafted with inventory wares
			local prodmethodstring = ReadText(1001, 9607)	-- Resources needed for manufacture, :
			local methodtypestring = ReadText(1001, 2408)
			if menu.library == "weapons_lasers" then
				prodmethodstring = ReadText(1001, 9613)	-- Resources needed for construction, :
				methodtypestring = ReadText(1001, 9652)
				-- burst damage
				menu.addDetailRow(ftable, ReadText(1001, 9092), ConvertIntegerString(menu.object.dps, true, 0, true) .. " " .. ReadText(1001, 119))
				-- sustained damage
				menu.addDetailRow(ftable, ReadText(1001, 9093), ConvertIntegerString(menu.object.sustaineddps, true, 0, true) .. " " .. ReadText(1001, 119))
				-- empty line
				menu.addDetailRow(ftable, "")
				-- shielded target
				menu.addDetailRow(ftable, ReadText(1001, 9642))
				menu.addDetailRow(ftable, ReadText(1001, 2460))
				local miningmultiplier, surfaceelementmultiplier = 0, 0
				if menu.object.isrepairweapon == 0 then
					if menu.object.miningmultiplier and menu.object.miningmultiplier > 1 then
						miningmultiplier = menu.object.miningmultiplier
					end
					if menu.object.surfaceelementmultiplier and menu.object.surfaceelementmultiplier > 1 then
						surfaceelementmultiplier = menu.object.surfaceelementmultiplier
					end
				end
				if menu.object.isrepairweapon == 0 then
					local areadpshot_shield, areadpshot_hull = 0, 0
					if menu.object.hullshieldareadpshot and menu.object.hullshieldareadpshot > 0 then
						areadpshot_shield = areadpshot_shield + menu.object.hullshieldareadpshot
					end
					if menu.object.shieldonlyareadpshot and menu.object.shieldonlyareadpshot > 0 then
						areadpshot_shield = areadpshot_shield + menu.object.shieldonlyareadpshot
					end
					if menu.object.hullonlyareadpshot and menu.object.hullonlyareadpshot > 0 then
						areadpshot_hull = areadpshot_hull + menu.object.hullonlyareadpshot
					end
					if areadpshot_shield > 0 or areadpshot_hull > 0 then
						menu.addDetailRow(ftable, "        " .. ReadText(1001, 2462) .. " (" .. ReadText(1001, 9643) .. ")", ConvertIntegerString(menu.object.hullshielddpshot + menu.object.shieldonlydpshot, true, 0, true) .. " " .. ReadText(1001, 118))
						menu.addDetailRow(ftable, "        " .. ReadText(1001, 2463) .. " (" .. ReadText(1001, 9643) .. ")", ConvertIntegerString(menu.object.hullonlydpshot, true, 0, true) .. " " .. ReadText(1001, 118))
						menu.addDetailRow(ftable, "        " .. ReadText(1001, 9645) .. " (" .. ReadText(1001, 9640) .. ")", ConvertIntegerString(menu.object.hullshieldareadpshot + menu.object.shieldonlyareadpshot, true, 0, true) .. " " .. ReadText(1001, 118))
						menu.addDetailRow(ftable, "        " .. ReadText(1001, 9644) .. " (" .. ReadText(1001, 9640) .. ")", ConvertIntegerString(menu.object.hullonlyareadpshot, true, 0, true) .. " " .. ReadText(1001, 118))
						if surfaceelementmultiplier and surfaceelementmultiplier > 1 then
							menu.addDetailRow(ftable, "        " .. ReadText(1001, 9646), ConvertIntegerString((menu.object.hullshielddpshot + menu.object.shieldonlydpshot + menu.object.hullshieldareadpshot + menu.object.shieldonlyareadpshot) * surfaceelementmultiplier, true, 0, true) .. " " .. ReadText(1001, 118))
						end
						if miningmultiplier and miningmultiplier > 1 then
							menu.addDetailRow(ftable, "        " .. ReadText(1001, 9647), ConvertIntegerString((menu.object.hullonlydpshot + menu.object.shieldonlydamage + menu.object.hullshieldareadpshot + menu.object.shieldonlyareadpshot) * miningmultiplier, true, 0, true) .. " " .. ReadText(1001, 118))
						end
					else
						menu.addDetailRow(ftable, "        " .. ReadText(1001, 2462), ConvertIntegerString(menu.object.hullshielddpshot + menu.object.shieldonlydpshot, true, 0, true) .. " " .. ReadText(1001, 118))
						menu.addDetailRow(ftable, "        " .. ReadText(1001, 2463), ConvertIntegerString(menu.object.hullonlydpshot, true, 0, true) .. " " .. ReadText(1001, 118))
						if surfaceelementmultiplier and surfaceelementmultiplier > 1 then
							menu.addDetailRow(ftable, "        " .. ReadText(1001, 9646), ConvertIntegerString((menu.object.hullshielddpshot + menu.object.shieldonlydpshot) * surfaceelementmultiplier, true, 0, true) .. " " .. ReadText(1001, 118))
						end
						if miningmultiplier and miningmultiplier > 1 then
							menu.addDetailRow(ftable, "        " .. ReadText(1001, 9647), ConvertIntegerString((menu.object.hullshielddpshot + menu.object.shieldonlydpshot) * miningmultiplier, true, 0, true) .. " " .. ReadText(1001, 118))
						end
					end
				else
					menu.addDetailRow(ftable, "    " .. ReadText(1001, 2464), ConvertIntegerString(menu.object.hullonlydps, true, 0, true) .. " " .. ReadText(1001, 119))
				end
				-- unshielded target
				menu.addDetailRow(ftable, ReadText(1001, 2461))
				if menu.object.isrepairweapon == 0 then
					local areadpshot_hull = 0
					if menu.object.hullshieldareadpshot and menu.object.hullshieldareadpshot > 0 then
						areadpshot_hull = areadpshot_hull + menu.object.hullshieldareadpshot
					end
					if menu.object.hullonlyareadpshot and menu.object.hullonlyareadpshot > 0 then
						areadpshot_hull = areadpshot_hull + menu.object.hullonlyareadpshot
					end
					if menu.object.hullnoshieldareadpshot and menu.object.hullnoshieldareadpshot > 0 then
						areadpshot_hull = areadpshot_hull + menu.object.hullnoshieldareadpshot
					end
					if areadpshot_hull > 0 then
						menu.addDetailRow(ftable, "        " .. ReadText(1001, 2463) .. " (" .. ReadText(1001, 9643) .. ")", ConvertIntegerString(menu.object.hullshielddpshot + menu.object.hullonlydpshot + menu.object.hullnoshielddpshot, true, 0, true) .. " " .. ReadText(1001, 118))
						menu.addDetailRow(ftable, "        " .. ReadText(1001, 9644) .. " (" .. ReadText(1001, 9640) .. ")", ConvertIntegerString(menu.object.hullshieldareadpshot + menu.object.hullonlyareadpshot + menu.object.hullnoshieldareadpshot, true, 0, true) .. " " .. ReadText(1001, 118))
						if surfaceelementmultiplier and surfaceelementmultiplier > 0 then
							menu.addDetailRow(ftable, "        " .. ReadText(1001, 9646), ConvertIntegerString((menu.object.hullshielddpshot + menu.object.hullonlydpshot + menu.object.hullnoshielddpshot + menu.object.hullshieldareadamage + menu.object.hullonlyareadamage + menu.object.hullnoshieldareadamage) * surfaceelementmultiplier, true, 0, true) .. " " .. ReadText(1001, 118))
						end
						if miningmultiplier and miningmultiplier > 1 then
							menu.addDetailRow(ftable, "        " .. ReadText(1001, 9647), ConvertIntegerString((menu.object.hullshielddpshot + menu.object.hullonlydpshot + menu.object.hullnoshielddpshot + menu.object.hullshieldareadamage + menu.object.hullonlyareadamage + menu.object.hullnoshieldareadamage) * miningmultiplier, true, 0, true) .. " " .. ReadText(1001, 118))
						end
					else
						menu.addDetailRow(ftable, "        " .. ReadText(1001, 2463), ConvertIntegerString(menu.object.hullshielddpshot + menu.object.hullonlydpshot + menu.object.hullnoshielddpshot, true, 0, true) .. " " .. ReadText(1001, 118))
						if surfaceelementmultiplier and surfaceelementmultiplier > 0 then
							menu.addDetailRow(ftable, "        " .. ReadText(1001, 9646), ConvertIntegerString((menu.object.hullshielddpshot + menu.object.hullonlydpshot + menu.object.hullnoshielddpshot) * surfaceelementmultiplier, true, 0, true) .. " " .. ReadText(1001, 118))
						end
						if miningmultiplier and miningmultiplier > 1 then
							menu.addDetailRow(ftable, "        " .. ReadText(1001, 9647), ConvertIntegerString((menu.object.hullshielddpshot + menu.object.hullonlydpshot + menu.object.hullnoshielddpshot) * miningmultiplier, true, 0, true) .. " " .. ReadText(1001, 118))
						end
					end
				else
					menu.addDetailRow(ftable, "    " .. ReadText(1001, 2464), ConvertIntegerString(menu.object.hullshielddps + menu.object.hullonlydps + menu.object.hullnoshielddps, true, 0, true) .. " " .. ReadText(1001, 119))
				end
				-- empty line
				menu.addDetailRow(ftable, "")
				-- rate
				if menu.object.isbeamweapon == 0 then
					menu.addDetailRow(ftable, ReadText(1001, 9084), Helper.round(menu.object.reloadrate, 2) .. " " .. ReadText(1001, 121))
				end
				-- initial heat
				if menu.object.initialheat > 0 then
					menu.addDetailRow(ftable, ReadText(1001, 2465), ConvertIntegerString(menu.object.initialheat, true, 0, true) .. " " .. ReadText(1001, 118))
				end
				-- heat buildup
				menu.addDetailRow(ftable, ReadText(1001, 9085), ConvertIntegerString(menu.object.maxheatrate, true, 0, true) .. " " .. ReadText(1001, 119))
				-- cooling rate
				if menu.object.coolingrate and menu.object.coolingrate > -1 then
					menu.addDetailRow(ftable, ReadText(1001, 9626), Helper.round(menu.object.coolingrate, 2) .. " " .. ReadText(1001, 119))
				end
				-- charge time
				if menu.object.chargetime and menu.object.chargetime > -1 then
					menu.addDetailRow(ftable, ReadText(1001, 9627), Helper.round(menu.object.chargetime, 2) .. " " .. ReadText(1001, 100))
				end
				-- empty line
				menu.addDetailRow(ftable, "")
				-- projectile speed
				if menu.object.isbeamweapon == 0 then
					menu.addDetailRow(ftable, ReadText(1001, 9086), ConvertIntegerString(menu.object.bulletspeed, true, 0, true) .. " " .. ReadText(1001, 113))
				end
				-- range
				menu.addDetailRow(ftable, ReadText(1001, 9087), menu.formatRange(menu.object.range) .. " " .. ReadText(1001, 108))
				-- influence
				if menu.object.influencename then
					menu.addDetailRow(ftable, "")
					menu.addDetailRow(ftable, ReadText(1001, 9628), tostring(menu.object.influencename))
					menu.addDetailRow(ftable, "", tostring(menu.object.influencedescription), null, null, true)
				end

			elseif menu.library == "weapons_missilelaunchers" then
				prodmethodstring = ReadText(1001, 9613)	-- Resources needed for construction, :
				methodtypestring = ReadText(1001, 9652)
				-- storage capacity
				menu.addDetailRow(ftable, ReadText(1001, 9063), "+" .. ConvertIntegerString(menu.object.storagecapacity, true, 0, true))

			elseif menu.library == "weapons_turrets" then
				prodmethodstring = ReadText(1001, 9613)	-- Resources needed for construction, :
				methodtypestring = ReadText(1001, 9652)
				-- hull
				menu.addDetailRow(ftable, ReadText(1001, 9083), ConvertIntegerString(menu.object.hull, true, 0, true) .. " " .. ReadText(1001, 118))
				-- empty line
				menu.addDetailRow(ftable, "")
				-- dps
				menu.addDetailRow(ftable, ReadText(1001, 9077), ConvertIntegerString(menu.object.dps, true, 0, true) .. " " .. ReadText(1001, 119))
				-- empty line
				menu.addDetailRow(ftable, "")
				-- shielded target
				menu.addDetailRow(ftable, ReadText(1001, 9642))
				menu.addDetailRow(ftable, ReadText(1001, 2460))
				local miningmultiplier, surfaceelementmultiplier = 0, 0
				if menu.object.miningmultiplier and menu.object.miningmultiplier > 1 then
					miningmultiplier = menu.object.miningmultiplier
				end
				if menu.object.surfaceelementmultiplier and menu.object.surfaceelementmultiplier > 1 then
					surfaceelementmultiplier = menu.object.surfaceelementmultiplier
				end
				local areadpshot_shield, areadpshot_hull = 0, 0
				if menu.object.hullshieldareadpshot and menu.object.hullshieldareadpshot > 0 then
					areadpshot_shield = areadpshot_shield + menu.object.hullshieldareadpshot
				end
				if menu.object.shieldonlyareadpshot and menu.object.shieldonlyareadpshot > 0 then
					areadpshot_shield = areadpshot_shield + menu.object.shieldonlyareadpshot
				end
				if menu.object.hullonlyareadpshot and menu.object.hullonlyareadpshot > 0 then
					areadpshot_hull = areadpshot_hull + menu.object.hullonlyareadpshot
				end
				if areadpshot_shield > 0 or areadpshot_hull > 0 then
					menu.addDetailRow(ftable, "        " .. ReadText(1001, 2462) .. " (" .. ReadText(1001, 9643) .. ")", ConvertIntegerString(menu.object.hullshielddpshot + menu.object.shieldonlydpshot, true, 0, true) .. " " .. ReadText(1001, 118))
					menu.addDetailRow(ftable, "        " .. ReadText(1001, 2463) .. " (" .. ReadText(1001, 9643) .. ")", ConvertIntegerString(menu.object.hullonlydpshot, true, 0, true) .. " " .. ReadText(1001, 118))
					menu.addDetailRow(ftable, "        " .. ReadText(1001, 9645) .. " (" .. ReadText(1001, 9640) .. ")", ConvertIntegerString(menu.object.hullshieldareadpshot + menu.object.shieldonlyareadpshot, true, 0, true) .. " " .. ReadText(1001, 118))
					menu.addDetailRow(ftable, "        " .. ReadText(1001, 9644) .. " (" .. ReadText(1001, 9640) .. ")", ConvertIntegerString(menu.object.hullonlyareadpshot, true, 0, true) .. " " .. ReadText(1001, 118))
					if surfaceelementmultiplier and surfaceelementmultiplier > 0 then
						menu.addDetailRow(ftable, "        " .. ReadText(1001, 9646), ConvertIntegerString((menu.object.hullshielddpshot + menu.object.shieldonlydpshot + menu.object.hullshieldareadpshot + menu.object.shieldonlyareadpshot) * surfaceelementmultiplier, true, 0, true) .. " " .. ReadText(1001, 118))
					end
					if miningmultiplier and miningmultiplier > 1 then
						menu.addDetailRow(ftable, "        " .. ReadText(1001, 9647), ConvertIntegerString((menu.object.hullshielddpshot + menu.object.shieldonlydpshot + menu.object.hullshieldareadpshot + menu.object.shieldonlyareadpshot) * miningmultiplier, true, 0, true) .. " " .. ReadText(1001, 118))
					end
				else
					menu.addDetailRow(ftable, "        " .. ReadText(1001, 2462), ConvertIntegerString(menu.object.hullshielddpshot + menu.object.shieldonlydpshot, true, 0, true) .. " " .. ReadText(1001, 118))
					menu.addDetailRow(ftable, "        " .. ReadText(1001, 2463), ConvertIntegerString(menu.object.hullonlydpshot, true, 0, true) .. " " .. ReadText(1001, 118))
					if surfaceelementmultiplier and surfaceelementmultiplier > 1 then
						menu.addDetailRow(ftable, "        " .. ReadText(1001, 9646), ConvertIntegerString((menu.object.hullshielddpshot + menu.object.shieldonlydpshot) * surfaceelementmultiplier, true, 0, true) .. " " .. ReadText(1001, 118))
					end
					if miningmultiplier and miningmultiplier > 1 then
						menu.addDetailRow(ftable, "        " .. ReadText(1001, 9647), ConvertIntegerString((menu.object.hullshielddpshot + menu.object.shieldonlydpshot) * miningmultiplier, true, 0, true) .. " " .. ReadText(1001, 118))
					end
				end
				-- unshielded target
				menu.addDetailRow(ftable, ReadText(1001, 2461))
				local areadpshot_hull = 0
				if menu.object.hullshieldareadpshot and menu.object.hullshieldareadpshot > 0 then
					areadpshot_hull = areadpshot_hull + menu.object.hullshieldareadpshot
				end
				if menu.object.hullonlyareadpshot and menu.object.hullonlyareadpshot > 0 then
					areadpshot_hull = areadpshot_hull + menu.object.hullonlyareadpshot
				end
				if menu.object.hullnoshieldareadpshot and menu.object.hullnoshieldareadpshot > 0 then
					areadpshot_hull = areadpshot_hull + menu.object.hullnoshieldareadpshot
				end
				if areadpshot_hull > 0 then
					menu.addDetailRow(ftable, "        " .. ReadText(1001, 2463) .. " (" .. ReadText(1001, 9643) .. ")", ConvertIntegerString(menu.object.hullshielddpshot + menu.object.hullonlydpshot + menu.object.hullnoshielddpshot, true, 0, true) .. " " .. ReadText(1001, 118))
					menu.addDetailRow(ftable, "        " .. ReadText(1001, 9644) .. " (" .. ReadText(1001, 9640) .. ")", ConvertIntegerString(menu.object.hullshieldareadpshot + menu.object.hullonlyareadpshot + menu.object.hullnoshieldareadpshot, true, 0, true) .. " " .. ReadText(1001, 118))
					if surfaceelementmultiplier and surfaceelementmultiplier > 0 then
						menu.addDetailRow(ftable, "        " .. ReadText(1001, 9646), ConvertIntegerString((menu.object.hullshielddpshot + menu.object.hullonlydpshot + menu.object.hullnoshielddpshot + menu.object.hullshieldareadpshot + menu.object.hullonlyareadpshot + menu.object.hullnoshieldareadpshot) * surfaceelementmultiplier, true, 0, true) .. " " .. ReadText(1001, 118))
					end
					if miningmultiplier and miningmultiplier > 1 then
						menu.addDetailRow(ftable, "        " .. ReadText(1001, 9647), ConvertIntegerString((menu.object.hullshielddpshot + menu.object.hullonlydpshot + menu.object.hullnoshielddpshot + menu.object.hullshieldareadpshot + menu.object.hullonlyareadpshot + menu.object.hullnoshieldareadpshot) * miningmultiplier, true, 0, true) .. " " .. ReadText(1001, 118))
					end
				else
					menu.addDetailRow(ftable, "        " .. ReadText(1001, 2463), ConvertIntegerString(menu.object.hullshielddpshot + menu.object.hullonlydpshot + menu.object.hullnoshielddpshot, true, 0, true) .. " " .. ReadText(1001, 118))
					if surfaceelementmultiplier and surfaceelementmultiplier > 0 then
						menu.addDetailRow(ftable, "        " .. ReadText(1001, 9646), ConvertIntegerString((menu.object.hullshielddpshot + menu.object.hullonlydpshot + menu.object.hullnoshielddpshot) * surfaceelementmultiplier, true, 0, true) .. " " .. ReadText(1001, 118))
					end
					if miningmultiplier and miningmultiplier > 1 then
						menu.addDetailRow(ftable, "        " .. ReadText(1001, 9647), ConvertIntegerString((menu.object.hullshielddpshot + menu.object.hullonlydpshot + menu.object.hullnoshielddpshot) * miningmultiplier, true, 0, true) .. " " .. ReadText(1001, 118))
					end
				end
				-- empty line
				menu.addDetailRow(ftable, "")
				if menu.object.isbeamweapon == 0 then
					-- rate
					menu.addDetailRow(ftable, ReadText(1001, 9084), Helper.round(menu.object.reloadrate, 2) .. " " .. ReadText(1001, 121))
				end
				-- charge time
				if menu.object.chargetime and menu.object.chargetime > -1 then
					menu.addDetailRow(ftable, ReadText(1001, 9627), Helper.round(menu.object.chargetime, 2) .. " " .. ReadText(1001, 100))
				end
				if menu.object.isbeamweapon == 0 then
					-- empty line
					menu.addDetailRow(ftable, "")
					-- projectile speed
					menu.addDetailRow(ftable, ReadText(1001, 9086), ConvertIntegerString(menu.object.bulletspeed, true, 0, true) .. " " .. ReadText(1001, 113))
				end
				-- range
				menu.addDetailRow(ftable, ReadText(1001, 9087), menu.formatRange(menu.object.range) .. " " .. ReadText(1001, 108))
				-- rotation speed
				local printedrot = (menu.object.rotation > 1 and ConvertIntegerString(menu.object.rotation, true, 0, true)) or (menu.object.rotation > 0.1 and Helper.round(menu.object.rotation, 1)) or Helper.round(menu.object.rotation, 2)
				menu.addDetailRow(ftable, ReadText(1001, 2419), printedrot .. " " .. ReadText(1001, 117))
				-- influence
				if menu.object.influencename then
					menu.addDetailRow(ftable, "")
					menu.addDetailRow(ftable, ReadText(1001, 9628), tostring(menu.object.influencename))
					menu.addDetailRow(ftable, "", tostring(menu.object.influencedescription), null, null, true)
				end

			elseif menu.library == "weapons_missileturrets" then
				prodmethodstring = ReadText(1001, 9613)	-- Resources needed for construction, :
				methodtypestring = ReadText(1001, 9652)
				-- hull
				menu.addDetailRow(ftable, ReadText(1001, 9083), ConvertIntegerString(menu.object.hull, true, 0, true) .. " " .. ReadText(1001, 118))
				-- empty line
				menu.addDetailRow(ftable, "")
				-- storage capacity
				menu.addDetailRow(ftable, ReadText(1001, 9063), "+" .. ConvertIntegerString(menu.object.storagecapacity, true, 0, true))
				-- empty line
				menu.addDetailRow(ftable, "")
				-- rotation speed
				local printedrot = (menu.object.rotation > 1 and ConvertIntegerString(menu.object.rotation, true, 0, true)) or (menu.object.rotation > 0.1 and Helper.round(menu.object.rotation, 1)) or Helper.round(menu.object.rotation, 2)
				menu.addDetailRow(ftable, ReadText(1001, 2419), printedrot .. " " .. ReadText(1001, 117))

			elseif menu.library == "missiletypes" then
				-- hull
				menu.addDetailRow(ftable, ReadText(1001, 9083), ConvertIntegerString(menu.object.hull, true, 0, true) .. " " .. ReadText(1001, 118))
				-- empty line
				menu.addDetailRow(ftable, "")
				-- explosion
				if menu.object.explosiondamage > 0 or (menu.object.hullexplosiondamage < 1 and menu.object.shieldexplosiondamage < 1) then
					menu.addDetailRow(ftable, ReadText(1001, 9088), ConvertIntegerString(menu.object.explosiondamage, true, 0, true) .. " " .. ReadText(1001, 118))
				end
				-- hull explosion
				if menu.object.hullexplosiondamage > 0 then
					menu.addDetailRow(ftable, ReadText(1001, 9088) .. " (" .. ReadText(1001, 1) .. ")", ConvertIntegerString(menu.object.hullexplosiondamage, true, 0, true) .. " " .. ReadText(1001, 118))
				end
				-- shield explosion
				if menu.object.shieldexplosiondamage > 0 then
					menu.addDetailRow(ftable, ReadText(1001, 9088) .. " (" .. ReadText(1001, 2) .. ")", ConvertIntegerString(menu.object.shieldexplosiondamage, true, 0, true) .. " " .. ReadText(1001, 118))
				end
				-- range
				menu.addDetailRow(ftable, ReadText(1001, 9087), menu.formatRange(menu.object.range) .. " " .. ReadText(1001, 108))
				if menu.object.locktime > 0 then
					-- lock range
					menu.addDetailRow(ftable, ReadText(1001, 9649), menu.formatRange(menu.object.maxlockrange) .. " " .. ReadText(1001, 108))
					-- lock time
					menu.addDetailRow(ftable, ReadText(1001, 9650), ConvertIntegerString(menu.object.locktime, true, 0, true) .. " " .. ReadText(1001, 100))
				end
				-- empty line
				menu.addDetailRow(ftable, "")
				-- speed
				menu.addDetailRow(ftable, ReadText(1001, 9054), ConvertIntegerString(menu.object.speed, true, 0, true) .. " " .. ReadText(1001, 113))
				-- turning rate
				local printedyaw = (menu.object.yawspeed > 1 and ConvertIntegerString(menu.object.yawspeed, true, 0, true)) or (menu.object.yawspeed > 0.1 and Helper.round(menu.object.yawspeed, 1)) or Helper.round(menu.object.yawspeed, 2)
				menu.addDetailRow(ftable, ReadText(1001, 9055), printedyaw .. " " .. ReadText(1001, 117))
				-- pitch rate
				local printedpitch = (menu.object.pitchspeed > 1 and ConvertIntegerString(menu.object.pitchspeed, true, 0, true)) or (menu.object.pitchspeed > 0.1 and Helper.round(menu.object.pitchspeed, 1)) or Helper.round(menu.object.pitchspeed, 2)
				menu.addDetailRow(ftable, ReadText(1001, 9056), printedpitch .. " " .. ReadText(1001, 117))
				-- empty line
				menu.addDetailRow(ftable, "")
				-- vertical strafe
				menu.addDetailRow(ftable, ReadText(1001, 9058), ConvertIntegerString(menu.object.verticalstrafespeed, true, 0, true) .. " " .. ReadText(1001, 113))
				-- horizontal strafe
				menu.addDetailRow(ftable, ReadText(1001, 9059), ConvertIntegerString(menu.object.horizontalstrafespeed, true, 0, true) .. " " .. ReadText(1001, 113))
				-- influence
				if menu.object.influencename then
					menu.addDetailRow(ftable, "")
					menu.addDetailRow(ftable, ReadText(1001, 9628), tostring(menu.object.influencename))
					menu.addDetailRow(ftable, "", tostring(menu.object.influencedescription), null, null, true)
				end
				-- counter measure resilience
				if menu.object.guided then
					menu.addDetailRow(ftable, "")
					menu.addDetailRow(ftable, ReadText(1001, 9651), ConvertIntegerString(menu.object.countermeasureresilience * 100, true, 0, true) .. "%")
				end

			elseif menu.library == "mines" then
				-- hull
				menu.addDetailRow(ftable, ReadText(1001, 9083), ConvertIntegerString(menu.object.hull, true, 0, true) .. " " .. ReadText(1001, 118))
				-- empty line
				menu.addDetailRow(ftable, "")
				-- explosion
				if menu.object.explosiondamage > 0 or (menu.object.hullexplosiondamage < 1 and menu.object.shieldexplosiondamage < 1) then
					menu.addDetailRow(ftable, ReadText(1001, 9088), ConvertIntegerString(menu.object.explosiondamage, true, 0, true) .. " " .. ReadText(1001, 118))
				end
				-- hull explosion
				if menu.object.hullexplosiondamage > 0 then
					menu.addDetailRow(ftable, ReadText(1001, 9088) .. " (" .. ReadText(1001, 1) .. ")", ConvertIntegerString(menu.object.hullexplosiondamage, true, 0, true) .. " " .. ReadText(1001, 118))
				end
				-- shield explosion
				if menu.object.shieldexplosiondamage > 0 then
					menu.addDetailRow(ftable, ReadText(1001, 9088) .. " (" .. ReadText(1001, 2) .. ")", ConvertIntegerString(menu.object.shieldexplosiondamage, true, 0, true) .. " " .. ReadText(1001, 118))
				end
				-- empty line
				menu.addDetailRow(ftable, "")
				-- tracking
				menu.addDetailRow(ftable, ReadText(1001, 9089), menu.object.istracking and ReadText(1001, 2617) or ReadText(1001, 2618))
				-- friend/foe
				menu.addDetailRow(ftable, ReadText(1001, 9090), menu.object.isfriendfoe and ReadText(1001, 2617) or ReadText(1001, 2618))
				-- proximity
				menu.addDetailRow(ftable, ReadText(1001, 9091), (menu.object.proximityrange > 0) and (Helper.round(menu.object.proximityrange) .. " " .. ReadText(1001, 107)) or ReadText(1001, 2618))

			elseif menu.library == "bombs" then
				prodmethodstring = ReadText(1001, 9605)	-- Resources needed to craft, :
				-- explosion
				if menu.object.explosiondamage > 0 or (menu.object.hullexplosiondamage < 1 and menu.object.shieldexplosiondamage < 1) then
					menu.addDetailRow(ftable, ReadText(1001, 9088), ConvertIntegerString(menu.object.explosiondamage, true, 0, true) .. " " .. ReadText(1001, 118))
				end
				-- hull explosion
				if menu.object.hullexplosiondamage > 0 then
					menu.addDetailRow(ftable, ReadText(1001, 9088) .. " (" .. ReadText(1001, 1) .. ")", ConvertIntegerString(menu.object.hullexplosiondamage, true, 0, true) .. " " .. ReadText(1001, 118))
				end
				-- shield explosion
				if menu.object.shieldexplosiondamage > 0 then
					menu.addDetailRow(ftable, ReadText(1001, 9088) .. " (" .. ReadText(1001, 2) .. ")", ConvertIntegerString(menu.object.shieldexplosiondamage, true, 0, true) .. " " .. ReadText(1001, 118))
				end

			end
			-- build resources
			if menu.details.productionmethods and (#menu.details.productionmethods > 0) then
				-- empty line
				menu.addDetailRow(ftable, "")
				menu.addProductionMethodDetails(ftable, prodmethodstring, methodtypestring)
			end

		elseif menu.mode == "Equipment" then
			-- TODO #nick: add equipment mods?
			-- overridden for component types that have to be constructed in situ
			local prodmethodstring = ReadText(1001, 9607)	-- Resources needed for manufacture, :
			local methodtypestring = ReadText(1001, 2408)
			if menu.library == "enginetypes" or menu.library == "thrustertypes" then
				prodmethodstring = ReadText(1001, 9613)	-- Resources needed for construction, :
				methodtypestring = ReadText(1001, 9652)
				local isvirtual = GetMacroData(menu.details.id, "isvirtual")
				if not isvirtual then
					-- hull
					menu.addDetailRow(ftable, ReadText(1001, 9083), ConvertIntegerString(menu.object.hull, true, 0, true) .. " " .. ReadText(1001, 118))
					-- empty line
					menu.addDetailRow(ftable, "")
				end
				if menu.object.thrust_forward > 0 then
					-- forward
					menu.addDetailRow(ftable, ReadText(1001, 9065), ConvertIntegerString(menu.object.thrust_forward, true, 0, true) .. " " .. ReadText(1001, 115))
					-- reverse
					if menu.object.thrust_reverse > 0 then
						menu.addDetailRow(ftable, ReadText(1001, 9066), ConvertIntegerString(menu.object.thrust_reverse, true, 0, true) .. " " .. ReadText(1001, 115))
					end
					-- empty line
					menu.addDetailRow(ftable, "")
					-- boost
					if menu.object.boost_thrustfactor > 0 then
						menu.addDetailRow(ftable, ReadText(1001, 9067), ConvertIntegerString(menu.object.thrust_forward * menu.object.boost_thrustfactor, true, 0, true) .. " " .. ReadText(1001, 115))
					end
					-- boost duration
					if menu.object.boost_maxduration > 0 then
						menu.addDetailRow(ftable, ReadText(1001, 9068), ConvertIntegerString(menu.object.boost_maxduration, true, 0, true) .. " " .. ReadText(1001, 100))
					end
					if menu.object.boost_chargetime > 0 or menu.object.boost_rechargetime > 1 then
						-- boost charge
						if menu.object.boost_chargetime > 0 then
							menu.addDetailRow(ftable, ReadText(1001, 9070), ConvertIntegerString(menu.object.boost_chargetime, true, 0, true) .. " " .. ReadText(1001, 100))
						elseif menu.object.boost_rechargetime > 1 then
							menu.addDetailRow(ftable, ReadText(1001, 9070), ConvertIntegerString(menu.object.boost_rechargetime, true, 0, true) .. " " .. ReadText(1001, 100))
						end
						-- immediate boost
						menu.addDetailRow(ftable, ReadText(1001, 9071), (menu.object.boost_chargetime == 0 and menu.object.boost_rechargetime > 1) and ReadText(1001, 2617) or ReadText(1001, 2618))
					end
					if menu.object.travel_thrustfactor and menu.object.travel_thrustfactor > 0 then
						menu.addDetailRow(ftable, "")
						-- travel mode: max thrust
						menu.addDetailRow(ftable, ReadText(1001, 9629), ConvertIntegerString(menu.object.thrust_forward * menu.object.travel_thrustfactor, true, 0, true) .. " " .. ReadText(1001, 115))
						-- travel mode: charge time
						menu.addDetailRow(ftable, ReadText(1001, 9630), ConvertIntegerString(menu.object.travel_chargetime, true, 0, true) .. " " .. ReadText(1001, 100))
						-- travel mode: attack time
						menu.addDetailRow(ftable, ReadText(1001, 9631), ConvertIntegerString(menu.object.travel_attacktime, true, 0, true) .. " " .. ReadText(1001, 100))
					end
					-- empty line
					menu.addDetailRow(ftable, "")
				end
				if menu.object.thrust_yaw > 0 then
					-- turning thrust
					if menu.object.thrust_yaw > 0 then
						menu.addDetailRow(ftable, ReadText(1001, 9072), Helper.round(menu.object.thrust_yaw * 180 / math.pi) .. " " .. ReadText(1001, 115))
					end
					-- pitch thrust
					if menu.object.thrust_pitch > 0 then
						menu.addDetailRow(ftable, ReadText(1001, 9073), Helper.round(menu.object.thrust_pitch * 180 / math.pi) .. " " .. ReadText(1001, 115))
					end
					-- empty line
					menu.addDetailRow(ftable, "")
					-- horizontal strafe
					if menu.object.thrust_horizontal > 0 then
						menu.addDetailRow(ftable, ReadText(1001, 9074), ConvertIntegerString(menu.object.thrust_horizontal, true, 0, true) .. " " .. ReadText(1001, 115))
					end
					-- vertical strafe
					if menu.object.thrust_vertical > 0 then
						menu.addDetailRow(ftable, ReadText(1001, 9075), ConvertIntegerString(menu.object.thrust_horizontal, true, 0, true) .. " " .. ReadText(1001, 115))
					end
				end

			elseif menu.library == "shieldgentypes" then
				prodmethodstring = ReadText(1001, 9613)	-- Resources needed for construction, :
				methodtypestring = ReadText(1001, 9652)
				if not GetMacroData(menu.details.id, "isintegrated") then
					-- hull
					menu.addDetailRow(ftable, ReadText(1001, 9083), ConvertIntegerString(menu.object.hull, true, 0, true) .. " " .. ReadText(1001, 118))
					-- empty line
					menu.addDetailRow(ftable, "")
				end
				-- shield capacity
				menu.addDetailRow(ftable, ReadText(1001, 9060), ConvertIntegerString(menu.object.shield, true, 0, true) .. " " .. ReadText(1001, 118))
				-- shield recharge
				menu.addDetailRow(ftable, ReadText(1001, 9079), ConvertIntegerString(menu.object.recharge, true, 0, true) .. " " .. ReadText(1001, 119))
				-- shield recharge delay
				menu.addDetailRow(ftable, ReadText(1001, 9618), menu.object.rechargedelay .. " " .. ReadText(1001, 100))

			elseif menu.library == "satellites" then
				-- hull
				menu.addDetailRow(ftable, ReadText(1001, 9083), ConvertIntegerString(menu.object.hull, true, 0, true) .. " " .. ReadText(1001, 118))
				-- empty line
				menu.addDetailRow(ftable, "")
				-- radar range
				menu.addDetailRow(ftable, ReadText(1001, 2426), ConvertIntegerString(menu.object.radarrange / 1000, true, 0, true) .. " " .. ReadText(1001, 108))

			elseif menu.library == "navbeacons" then
				-- hull
				menu.addDetailRow(ftable, ReadText(1001, 9083), ConvertIntegerString(menu.object.hull, true, 0, true) .. " " .. ReadText(1001, 118))

			elseif menu.library == "resourceprobes" then
				-- hull
				menu.addDetailRow(ftable, ReadText(1001, 9083), ConvertIntegerString(menu.object.hull, true, 0, true) .. " " .. ReadText(1001, 118))
				-- empty line
				menu.addDetailRow(ftable, "")
				-- detection range
				menu.addDetailRow(ftable, ReadText(1001, 9082), ConvertIntegerString(GetMacroData(menu.details.id, "resourcedetectionrange") / 1000, true, 0, true) .. " " .. ReadText(1001, 108))

			elseif menu.library == "lasertowers" then
				-- hull
				menu.addDetailRow(ftable, ReadText(1001, 9083), ConvertIntegerString(menu.object.hull, true, 0, true) .. " " .. ReadText(1001, 118))

			elseif menu.library == "software" then
				if menu.object.isscanner then
					prodmethodstring = ReadText(1001, 9613)	-- Resources needed for construction, :
					methodtypestring = ReadText(1001, 9652)
					-- scan resolution
					menu.addDetailRow(ftable, ReadText(1001, 9080), menu.object.scanlevel)
					-- long range
					menu.addDetailRow(ftable, ReadText(1001, 9081), menu.object.islongrange and ReadText(1001, 2617) or ReadText(1001, 2618))

					if menu.object.islongrange then
						-- empty line
						menu.addDetailRow(ftable, "")
						menu.addDetailRow(ftable, ReadText(1001, 9633), ConvertIntegerString(menu.object.maxrange / 1000, true, 0, true) .. " " .. ReadText(1001, 108))
						menu.addDetailRow(ftable, ReadText(1001, 9634), Helper.round(2 * menu.object.maxyawangle) .. ReadText(1001, 109))
						menu.addDetailRow(ftable, ReadText(1001, 9635), Helper.round(2 * menu.object.maxpitchangle) .. ReadText(1001, 109))
					end
				end

			elseif menu.library == "paintmods" then
				local locware = menu.object
				local first = true
				-- ware source
				if #menu.details.waresources > 0 then
					if not first then
						-- empty line
						menu.addDetailRow(ftable, "")
					end
					first = false
					-- title
					menu.addDetailRow(ftable, ReadText(1001, 9615) .. ReadText(1001, 120))
					for i, entry in ipairs(menu.details.waresources) do
						if menu.details.haswaresourcelocation then
							menu.addDetailRow(ftable, "", entry.type, entry.location)
						else
							menu.addDetailRow(ftable, "", entry.type)
						end
					end
				end
				if not first then
					-- empty line
					menu.addDetailRow(ftable, "")
				end
				first = false
				-- average price
				menu.addDetailRow(ftable, ReadText(1001, 2980), ConvertMoneyString(locware.avgprice, false, true, 0, true) .. " " .. ReadText(1001, 101))

			end
			-- build resources
			if menu.details.productionmethods and (#menu.details.productionmethods > 0) then
				-- empty line
				menu.addDetailRow(ftable, "")
				menu.addProductionMethodDetails(ftable, prodmethodstring, methodtypestring)
			end

		elseif menu.mode == "Licences" then
			-- min relation
			menu.addDetailRow(ftable, ReadText(1001, 2458), menu.object.minrelation)
			-- issellable
			if menu.object.issellable then
				if menu.object.precursor ~= "" then
					local licenceinfo = ffi.new("LicenceInfo")
					C.GetLicenceInfo(licenceinfo, menu.object.factionid, menu.object.precursor)
					local precursorname = ffi.string(licenceinfo.name)

					menu.addDetailRow(ftable, ReadText(1001, 2493), string.format(ReadText(1001, 2495), precursorname))
				end
				menu.addDetailRow(ftable, ReadText(1001, 2457), ReadText(20208, 10601))
			elseif menu.object.precursor ~= "" then
				local licenceinfo = ffi.new("LicenceInfo")
				C.GetLicenceInfo(licenceinfo, menu.object.factionid, menu.object.precursor)
				local precursorname = ffi.string(licenceinfo.name)

				menu.addDetailRow(ftable, ReadText(1001, 2494), string.format(ReadText(1001, 2495), precursorname))
			elseif menu.object.minrelation < 0 then
				menu.addDetailRow(ftable, ReadText(1001, 2497), ReadText(1001, 2498))
			else
				menu.addDetailRow(ftable, ReadText(1001, 2494), ReadText(1001, 2496))
			end

		elseif menu.mode == "Wares" then
			local locware = menu.object
			if menu.library == "wares" then
				-- volume
				menu.addDetailRow(ftable, ReadText(1001, 1407), locware.volume .. " " .. ReadText(1001, 110))
				-- storage
				menu.addDetailRow(ftable, ReadText(1001, 2415), menu.transporttypes[locware.transporttype].name)
				-- resources
				if menu.details.productionmethods and (#menu.details.productionmethods > 0) then
					-- empty line
					menu.addDetailRow(ftable, "")
					menu.addProductionMethodDetails(ftable, ReadText(1001, 9421), ReadText(1001, 2408), ReadText(1001, 2411), ReadText(1001, 9418))
				end
				-- products
				if menu.details.products and (#menu.details.products > 0) then
					-- empty line
					menu.addDetailRow(ftable, "")
					-- title
					menu.addDetailRow(ftable, ReadText(1001, 9608) .. ReadText(1001, 120))
					for i, entry in ipairs(menu.details.products) do
						menu.addDetailRow(ftable, "", entry.name)
					end
				end
				-- illegal
				local first = true
				for i, entry in ipairs(menu.object.illegalto) do
					if entry.known then
						if first then
							-- empty line
							menu.addDetailRow(ftable, "")
							-- title
							menu.addDetailRow(ftable, ReadText(1001, 2437) .. ReadText(1001, 120))
							first = false
						end
						menu.addDetailRow(ftable, "", entry.name)
					end
				end
				-- empty line
				menu.addDetailRow(ftable, "")
				-- average price
				menu.addDetailRow(ftable, ReadText(1001, 2980), ConvertMoneyString(locware.avgprice, false, true, 0, true) .. " " .. ReadText(1001, 101))

			elseif menu.library == "inventory_wares" then
				local first = true
				-- build resources
				if menu.details.resources and (#menu.details.resources > 0) then
					if not first then
						-- empty line
						menu.addDetailRow(ftable, "")
					end
					first = false
					-- title
					menu.addDetailRow(ftable, ReadText(1001, 9605) .. ReadText(1001, 120))
					for i, entry in ipairs(menu.details.resources) do
						menu.addDetailRow(ftable, "", entry.amount .. ReadText(1001, 42) .. " " .. entry.name)
					end
				end
				-- products
				if menu.details.products and (#menu.details.products > 0) then
					if not first then
						-- empty line
						menu.addDetailRow(ftable, "")
					end
					first = false
					-- title
					menu.addDetailRow(ftable, ReadText(1001, 9606) .. ReadText(1001, 120))
					for i, entry in ipairs(menu.details.products) do
						menu.addDetailRow(ftable, "", entry.name)
					end
				end
				-- illegal
				local firstillegal = true
				for _, entry in ipairs(menu.object.illegalto) do
					if entry.known then
						if firstillegal then
							if not first then
								-- empty line
								menu.addDetailRow(ftable, "")
							end
							first = false
							-- title
							menu.addDetailRow(ftable, ReadText(1001, 2437) .. ReadText(1001, 120))
							firstillegal = false
						end
						menu.addDetailRow(ftable, "", entry.name)
					end
				end
				-- ware source
				if #menu.details.waresources > 0 then
					if not first then
						-- empty line
						menu.addDetailRow(ftable, "")
					end
					first = false
					-- title
					menu.addDetailRow(ftable, ReadText(1001, 9615) .. ReadText(1001, 120))
					for i, entry in ipairs(menu.details.waresources) do
						if menu.details.haswaresourcelocation then
							menu.addDetailRow(ftable, "", entry.type, entry.location)
						else
							menu.addDetailRow(ftable, "", entry.type)
						end
					end
				end
				if not first then
					-- empty line
					menu.addDetailRow(ftable, "")
				end
				first = false
				-- average price
				menu.addDetailRow(ftable, ReadText(1001, 2980), ConvertMoneyString(locware.avgprice, false, true, 0, true) .. " " .. ReadText(1001, 101))

			else
				DebugError("Unhandled. Ware is neither an economy ware nor an inventory ware.")
			end
		elseif menu.mode == "Blueprints" then
			for i, subcategory in ipairs(menu.index["Blueprints"][menu.object].subcategories) do
				local data = menu.details[subcategory.key]
				if data then
					if i > 1 then
						-- empty line
						menu.addDetailRow(ftable, "")
					end
					-- header
					local row = ftable:addRow(false, {  })
					row[2]:setColSpan(2):setBackgroundColSpan(3):createText(data.name, Helper.headerRow1Properties)
					local unlocked, count, owned = 0, 0, 0
					for i, entry in ipairs(data) do
						if entry.unlocked then
							unlocked = unlocked + 1
						end
						if not entry.hidden then
							count = count + 1
						end
						if entry.owned then
							owned = owned + 1
						end
					end
					row[4]:createText(owned .. " / " .. count, Helper.headerRow1Properties)
					row[4].properties.halign = "right"

					for i, entry in ipairs(data) do
						if entry.unlocked then
							menu.numDetailRows = menu.numDetailRows + 1
							local row = ftable:addRow(("detailrow_" .. menu.numDetailRows), { interactive = false })
							row[2]:createText(entry.name, { color = entry.owned and Color["text_normal"] or Color["text_inactive"], mouseOverText = entry.owned and "" or ReadText(1001, 9622) })
							row[3]:setColSpan(2):createText(entry.owned and (ColorText["text_player"] .. ReadText(1001, 84)) or "", { halign = "right" })
						end
					end
					if unlocked < count then
						menu.addDetailRow(ftable, string.format(ReadText(1001, 9623), count - unlocked))
					end
				end
			end
		end
	end
end

function menu.createGraph(width, height, x, y)
	-- data
	menu.graphdata = {}
	local buyDataWeights = {}
	local sellDataWeights = {}
	local ffiHelper = {}
	local numstats = C.GetNumTradeOfferStatistics(ConvertIDTo64Bit(menu.object), menu.xStart, menu.xEnd, config.graph.numdatapoints)
	if numstats > 0 then
		local result = ffi.new("UITradeOfferStat[?]", numstats)
		for i = 0, numstats - 1 do
			table.insert(ffiHelper, 1, ffi.new("UITradeOfferStatData[?]", config.graph.numdatapoints))
			result[i].data = ffiHelper[1]
		end
		numstats = C.GetTradeOfferStatistics(result, numstats, config.graph.numdatapoints)
		for i = 0, numstats - 1 do
			local ware = ffi.string(result[i].wareid)
			local text = GetWareData(ware, "name")
			local dataIdx = menu.getDataIdxByWare(ware)
			if not dataIdx then
				table.insert(menu.graphdata, { shown = false, text = text, ware = ware, selldata = {}, buydata = {} })
				dataIdx = #menu.graphdata
			end
			buyDataWeights[dataIdx]  = buyDataWeights[dataIdx]  or { ware = ware, dataIdx = dataIdx, count = 0, amount = 0 }
			sellDataWeights[dataIdx] = sellDataWeights[dataIdx] or { ware = ware, dataIdx = dataIdx, count = 0, amount = 0 }
			for j = 0, result[i].numdata - 1 do
				local y = tonumber(result[i].data[j].amount)
				if result[i].isSellOffer then
					menu.graphdata[dataIdx].selldata[j + 1] = { t = tonumber(result[i].data[j].time), y = y }
					sellDataWeights[dataIdx].count = sellDataWeights[dataIdx].count + 1
					sellDataWeights[dataIdx].amount = sellDataWeights[dataIdx].amount + y
				else
					menu.graphdata[dataIdx].buydata[j + 1] = { t = tonumber(result[i].data[j].time), y = y }
					buyDataWeights[dataIdx].count = buyDataWeights[dataIdx].count + 1
					buyDataWeights[dataIdx].amount = buyDataWeights[dataIdx].amount + y
				end
			end
		end
	end

	for _, data in ipairs(buyDataWeights) do
		if data.count > 0 then
			data.amount = data.amount / data.count
		end
	end
	table.sort(buyDataWeights, function (a, b) return a.amount > b.amount end)
	for _, data in ipairs(sellDataWeights) do
		if data.count > 0 then
			data.amount = data.amount / data.count
		end
	end
	table.sort(sellDataWeights, function (a, b) return a.amount > b.amount end)

	-- table
	local table_graph = menu.frame:addTable(9, { y = y, tabOrder = 4, width = width, x = x })
	for i = 1, 4 do
		table_graph:setColWidth(2 * i, Helper.standardTextHeight)
	end

	local row = table_graph:addRow(false, { fixed = true })
	row[1]:setColSpan(9):createText(ReadText(1001, 2489), Helper.headerRow1Properties)

	local graphrow = table_graph:addRow(false, { fixed = true })

	local row = table_graph:addRow(true, { fixed = true })
	row[1]:createText(ReadText(1001, 2954) .. ReadText(1001, 120))
	for i = 1, 4 do
		if buyDataWeights[i] and (buyDataWeights[i].amount > 0) then
			row[2 * i]:createCheckBox(not menu.hiddenData.buy[i])
			row[2 * i].handlers.onClick = function (id) return menu.checkboxGraphData(id, "buy", i) end
			row[2 * i + 1]:createText(GetWareData(buyDataWeights[i].ware, "name"), { color = config.graph.datarecordcolors[i].buy })
		end
	end

	local row = table_graph:addRow(true, { fixed = true })
	row[1]:createText(ReadText(1001, 2955) .. ReadText(1001, 120))
	for i = 1, 4 do
		if sellDataWeights[i] and (sellDataWeights[i].amount > 0) then
			row[2 * i]:createCheckBox(not menu.hiddenData.sell[i])
			row[2 * i].handlers.onClick = function (id) return menu.checkboxGraphData(id, "sell", i) end
			row[2 * i + 1]:createText(GetWareData(sellDataWeights[i].ware, "name"), { color = config.graph.datarecordcolors[i].sell })
		end
	end

	local graph = graphrow[1]:setColSpan(9):createGraph({ height = height - table_graph:getFullHeight(), scaling = false })

	-- graph setup
	local minY, maxY = 0, 1
	for i = 1, 4 do
		if buyDataWeights[i] and (buyDataWeights[i].amount > 0) and (not menu.hiddenData.buy[i]) then
			if next(menu.graphdata[buyDataWeights[i].dataIdx].buydata) then
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
					mouseOverText = ReadText(1001, 2916) .. ReadText(1001, 120) .. " " .. menu.graphdata[buyDataWeights[i].dataIdx].text,
				})

				for i, point in pairs(menu.graphdata[buyDataWeights[i].dataIdx].buydata) do
					minY = math.min(minY, point.y)
					maxY = math.max(maxY, point.y)
					datarecord:addData((point.t - menu.xEnd) / menu.xScale, point.y, nil, nil)
				end
			end
		end
		
		if sellDataWeights[i] and (sellDataWeights[i].amount > 0) and (not menu.hiddenData.sell[i]) then
			if next(menu.graphdata[sellDataWeights[i].dataIdx].selldata) then
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
					mouseOverText = ReadText(1001, 2917) .. ReadText(1001, 120) .. " " .. menu.graphdata[sellDataWeights[i].dataIdx].text,
				})

				for i, point in pairs(menu.graphdata[sellDataWeights[i].dataIdx].selldata) do
					minY = math.min(minY, point.y)
					maxY = math.max(maxY, point.y)
					datarecord:addData((point.t - menu.xEnd) / menu.xScale, point.y, nil, nil)
				end
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
end

function menu.getDataIdxByWare(ware)
	for i, data in ipairs(menu.graphdata) do
		if data.ware == ware then
			return i
		end
	end

	return nil
end

function menu.checkboxGraphData(id, type, i)
	if (not menu.displayRunning) then
		menu.hiddenData[type][i] = not menu.hiddenData[type][i]
		menu.refresh = true
	else
		C.SetCheckBoxChecked(id, not menu.hiddenData[type][i], true)
	end
end

function menu.isMakerRaceAllowed(makerraces, objectmakerraces)
	local allowed = true
	for _, race in ipairs(makerraces) do
		if objectmakerraces then
			local raceallowed = false		
			for _, objectrace in ipairs(objectmakerraces) do
				if objectrace == race then
					raceallowed = true
					break
				end
			end
			if raceallowed then
				-- always allow the equipment if the maker race matches the maker race of the object it is for
				allowed = true
				break
			end
		end
		if (race == "xenon") or (race == "khaak") then
			allowed = false
			break
		end
	end
	return (next(makerraces) == nil) or allowed
end

-- input in m
function menu.formatRange(range)
	return (range > 10000) and ConvertIntegerString(range / 1000, true, 0, true) or Helper.round(range / 1000, (range > 1000) and 1 or 3)
end

-- kuertee start:
function menu.registerCallback (callbackName, callbackFunction)
	-- note 1: format is generally [function name]_[action]. e.g.: in kuertee_menu_transporter, "display_on_set_room_active" overrides the room's active property with the return of the callback.
	-- note 2: events have the word "_on_" followed by a PRESENT TENSE verb. e.g.: in kuertee_menu_transporter, "display_on_set_buttontable" is called after all of the rows of buttontable are set.
	-- note 3: new callbacks can be added or existing callbacks can be edited. but commit your additions/changes to the mod's GIT repository.
	-- note 4: search for the callback names to see where they are executed.
	-- note 5: if a callback requires a return value, return it in an object var. e.g. "display_on_set_room_active" requires a return of {active = true | false}.
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
		Helper.loadModLuas(menu.name, "menu_encyclopedia_uix")
	end
end
-- kuertee end

init()
