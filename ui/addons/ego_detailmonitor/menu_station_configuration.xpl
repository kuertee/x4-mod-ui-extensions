-- section == cArch_configureStation
-- param == { 0, 0, container }

-- ffi setup
local ffi = require("ffi")
local C = ffi.C
ffi.cdef[[
	typedef uint64_t TradeID;
	typedef int32_t TradeRuleID;
	typedef uint64_t UniverseID;

	typedef struct {
		const char* tag;
		const char* name;
	} EquipmentCompatibilityInfo;
	typedef struct {
		const char* id;
		const char* name;
		int32_t state;
		const char* requiredversion;
		const char* installedversion;
	} InvalidPatchInfo;
	typedef struct {
		const char* macro;
		const char* ware;
		const char* productionmethodid;
	} UIBlueprint;
	typedef struct {
		const char* name;
		const char* id;
		const char* source;
		bool deleteable;
	} UIConstructionPlan;
	typedef struct {
		const char* filename;
		const char* name;
		const char* id;
	} UIConstructionPlanInfo;
	typedef struct {
		const char* macro;
		uint32_t amount;
		bool optional;
	} UILoadoutAmmoData;
	typedef struct {
		const char* macro;
		const char* path;
		const char* group;
		uint32_t count;
		bool optional;
	} UILoadoutGroupData;
	typedef struct {
		const char* macro;
		const char* upgradetypename;
		size_t slot;
		bool optional;
	} UILoadoutMacroData;
	typedef struct {
		const char* ware;
	} UILoadoutSoftwareData;
	typedef struct {
		const char* macro;
		bool optional;
	} UILoadoutVirtualMacroData;
	typedef struct {
		uint32_t numweapons;
		uint32_t numturrets;
		uint32_t numshields;
		uint32_t numengines;
		uint32_t numturretgroups;
		uint32_t numshieldgroups;
		uint32_t numammo;
		uint32_t numunits;
		uint32_t numsoftware;
	} UILoadoutCounts;
	typedef struct {
		UILoadoutMacroData* weapons;
		uint32_t numweapons;
		UILoadoutMacroData* turrets;
		uint32_t numturrets;
		UILoadoutMacroData* shields;
		uint32_t numshields;
		UILoadoutMacroData* engines;
		uint32_t numengines;
		UILoadoutGroupData* turretgroups;
		uint32_t numturretgroups;
		UILoadoutGroupData* shieldgroups;
		uint32_t numshieldgroups;
		UILoadoutAmmoData* ammo;
		uint32_t numammo;
		UILoadoutAmmoData* units;
		uint32_t numunits;
		UILoadoutSoftwareData* software;
		uint32_t numsoftware;
		UILoadoutVirtualMacroData thruster;
	} UILoadout;
	typedef struct {
		const char* id;
		const char* name;
		const char* iconid;
		bool deleteable;
	} UILoadoutInfo;
	typedef struct {
		const char* upgradetype;
		size_t slot;
	} UILoadoutSlot;
	typedef struct {
		const char* macro;
		uint32_t amount;
	} UIMacroCount;
	typedef struct {
		float x;
		float y;
		float z;
		float yaw;
		float pitch;
		float roll;
	} UIPosRot;
	typedef struct {
		const char* ware;
		const char* macro;
		int amount;
	} UIWareInfo;
	typedef struct {
		const char* path;
		const char* group;
	} UpgradeGroup;
	typedef struct {
		UniverseID currentcomponent;
		const char* currentmacro;
		const char* slotsize;
		uint32_t count;
		uint32_t operational;
		uint32_t total;
	} UpgradeGroupInfo;
	typedef struct {
		UniverseID reserverid;
		const char* ware;
		uint32_t amount;
		bool isbuyreservation;
		double eta;
		TradeID tradedealid;
		MissionID missionid;
		bool isvirtual;
		bool issupply;
	} WareReservationInfo2;

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
	void AddFloatingSequenceToConstructionPlan(UniverseID holomapid);
	void AddCopyToConstructionMap(UniverseID holomapid, size_t cp_idx, bool copysequence);
	void AddMacroToConstructionMap(UniverseID holomapid, const char* macroname, bool startdragging);
	bool AreConstructionPlanLoadoutsCompatible(const char* constructionplanid);
	bool CanBuildLoadout(UniverseID containerid, UniverseID defensibleid, const char* macroname, const char* loadoutid);
	bool CancelPlayerInvolvedTradeDeal(UniverseID containerid, TradeID tradeid, bool checkonly);
	bool CanOpenWebBrowser(void);
	bool CheckConstructionPlanForMacros(const char* constructionplanid, const char** macroids, uint32_t nummacroids);
	void ClearBuildMapSelection(UniverseID holomapid);
	bool CompareMapConstructionSequenceWithPlanned(UniverseID holomapid, UniverseID defensibleid, bool usestoredplan);
	const char* ConvertInputString(const char* text, const char* defaultvalue);
	void DeselectMacroForConstructionMap(UniverseID holomapid);
	bool DoesConstructionSequenceRequireBuilder(UniverseID containerid);
	void ExportMapConstructionPlan(UniverseID holomapid, const char* filename, const char* id, bool overwrite, const char* name, const char* desc);
	void ForceBuildCompletion(UniverseID containerid);
	void GenerateModuleLoadout(UILoadout* result, UniverseID holomapid, size_t cp_idx, UniverseID defensibleid, float level);
	void GenerateModuleLoadoutCounts(UILoadoutCounts* result, UniverseID holomapid, size_t cp_idx, UniverseID defensibleid, float level);
	uint32_t GetAssignedConstructionVessels(UniverseID* result, uint32_t resultlen, UniverseID containerid);
	uint32_t GetBlueprints(UIBlueprint* result, uint32_t resultlen, const char* set, const char* category, const char* macroname);
	size_t GetBuildMapConstructionPlan(UniverseID holomapid, UniverseID defensibleid, bool usestoredplan, UIConstructionPlanEntry* result, uint32_t resultlen);
	double GetBuildProcessorEstimatedTimeLeft(UniverseID buildprocessorid);
	uint32_t GetCargo(UIWareInfo* result, uint32_t resultlen, UniverseID containerid, const char* tags);
	uint32_t GetConstructionPlanInvalidPatches(InvalidPatchInfo* result, uint32_t resultlen, const char* constructionplanid);
	uint32_t GetConstructionPlans(UIConstructionPlan* result, uint32_t resultlen);
	void GetConstructionMapItemLoadout2(UILoadout* result, UniverseID holomapid, size_t itemidx, UniverseID defensibleid, UniverseID moduleid);
	void GetConstructionMapItemLoadoutCounts2(UILoadoutCounts* result, UniverseID holomapid, size_t itemidx, UniverseID defensibleid, UniverseID moduleid);
	size_t GetConstructionMapVenturePlatform(UniverseID holomapid, size_t venturedockidx);
	float GetContainerGlobalPriceFactor(UniverseID containerid);
	TradeRuleID GetContainerTradeRuleID(UniverseID containerid, const char* ruletype, const char* wareid);
	uint32_t GetContainerWareReservations2(WareReservationInfo2* result, uint32_t resultlen, UniverseID containerid, bool includevirtual, bool includemission, bool includesupply);
	UniverseID GetContextByClass(UniverseID componentid, const char* classname, bool includeself);
	float GetCurrentBuildProgress(UniverseID containerid);
	void GetCurrentLoadout(UILoadout* result, UniverseID defensibleid, UniverseID moduleid);
	void GetCurrentLoadoutCounts(UILoadoutCounts* result, UniverseID defensibleid, UniverseID moduleid);
	float GetDefensibleLoadoutLevel(UniverseID defensibleid);
	const char* GetGameStartName();
	uint32_t GetImportableConstructionPlans(UIConstructionPlanInfo* result, uint32_t resultlen);
	void GetLoadout(UILoadout* result, UniverseID defensibleid, const char* macroname, const char* loadoutid);
	uint32_t GetLoadoutCounts(UILoadoutCounts* result, UniverseID defensibleid, const char* macroname, const char* loadoutid);
	uint32_t GetLoadoutInvalidPatches(InvalidPatchInfo* result, uint32_t resultlen, UniverseID defensibleid, const char* macroname, const char* loadoutid);
	uint32_t GetLoadoutsInfo(UILoadoutInfo* result, uint32_t resultlen, UniverseID componentid, const char* macroname);
	const char* GetMissingConstructionPlanBlueprints3(UniverseID containerid, UniverseID holomapid, const char* constructionplanid, bool useplanned);
	uint32_t GetNumAssignedConstructionVessels(UniverseID containerid);
	uint32_t GetNumBlueprints(const char* set, const char* category, const char* macroname);
	size_t GetNumBuildMapConstructionPlan(UniverseID holomapid, bool usestoredplan);
	uint32_t GetNumCargo(UniverseID containerid, const char* tags);
	uint32_t GetNumConstructionMapVenturePlatformDocks(UniverseID holomapid, size_t ventureplatformidx);
	uint32_t GetNumConstructionPlans(void);
	uint32_t GetNumContainerWareReservations2(UniverseID containerid, bool includevirtual, bool includemission, bool includesupply);
	uint32_t GetNumImportableConstructionPlans();
	uint32_t GetNumLoadoutsInfo(UniverseID componentid, const char* macroname);
	uint32_t GetNumPlannedLimitedModules(const char* constructionplanid);
	uint32_t GetNumRemovedConstructionPlanModules2(UniverseID holomapid, UniverseID defensibleid, uint32_t* newIndex, bool usestoredplan, uint32_t* numChangedIndices, bool checkupgrades);
	uint32_t GetNumUpgradeGroupCompatibilities(UniverseID destructibleid, const char* macroname, UniverseID contextid, const char* path, const char* group, const char* upgradetypename);
	uint32_t GetNumUpgradeGroups(UniverseID destructibleid, const char* macroname);
	size_t GetNumUpgradeSlots(UniverseID destructibleid, const char* macroname, const char* upgradetypename);
	uint32_t GetNumUsedLimitedModules(UniverseID excludedstationid);
	uint32_t GetNumUsedLimitedModulesFromSubsequence(UniverseID holomapid, size_t cp_idx);
	uint32_t GetNumWares(const char* tags, bool research, const char* licenceownerid, const char* exclusiontags);
	const char* GetObjectIDCode(UniverseID objectid);
	bool GetPickedBuildMapEntry2(UniverseID holomapid, UniverseID defensibleid, UIConstructionPlanEntry* result, bool requirecomponentid);
	void SelectPickedBuildMapEntry(UniverseID holomapid);
	bool GetPickedMapMacroSlot(UniverseID holomapid, UniverseID defensibleid, UniverseID moduleid, const char* macroname, bool ismodule, UILoadoutSlot* result);
	uint32_t GetPlannedLimitedModules(UIMacroCount* result, uint32_t resultlen, const char* constructionplanid);
	uint32_t GetRemovedConstructionPlanModules2(UniverseID* result, uint32_t resultlen, uint32_t* changedIndices, uint32_t* numChangedIndices);
	size_t GetSelectedBuildMapEntry(UniverseID holomapid);
	uint32_t GetUpgradeGroupCompatibilities(EquipmentCompatibilityInfo* result, uint32_t resultlen, UniverseID destructibleid, const char* macroname, UniverseID contextid, const char* path, const char* group, const char* upgradetypename);
	UpgradeGroupInfo GetUpgradeGroupInfo(UniverseID destructibleid, const char* macroname, const char* path, const char* group, const char* upgradetypename);
	uint32_t GetUpgradeGroups(UpgradeGroup* result, uint32_t resultlen, UniverseID destructibleid, const char* macroname);
	const char* GetUpgradeSlotCurrentMacro(UniverseID objectid, UniverseID moduleid, const char* upgradetypename, size_t slot);
	UpgradeGroup GetUpgradeSlotGroup(UniverseID destructibleid, const char* macroname, const char* upgradetypename, size_t slot);
	uint32_t GetUsedLimitedModules(UIMacroCount* result, uint32_t resultlen, UniverseID excludedstationid);
	uint32_t GetUsedLimitedModulesFromSubsequence(UIMacroCount* result, uint32_t resultlen, UniverseID holomapid, size_t cp_idx);
	uint32_t GetWares(const char** result, uint32_t resultlen, const char* tags, bool research, const char* licenceownerid, const char* exclusiontags);
	WorkForceInfo GetWorkForceInfo(UniverseID containerid, const char* raceid);
	bool HasContainerOwnTradeRule(UniverseID containerid, const char* ruletype, const char* wareid);
	void ImportMapConstructionPlan(const char* filename, const char* id);
	bool IsBuildWaitingForSecondaryComponentResources(UniverseID containerid);
	bool IsConstructionPlanValid(const char* constructionplanid, uint32_t* numinvalidpatches);
	bool IsLoadoutCompatible(const char* macroname, const char* loadoutid);
	bool IsLoadoutValid(UniverseID defensibleid, const char* macroname, const char* loadoutid, uint32_t* numinvalidpatches);
	bool IsIconValid(const char* iconid);
	bool IsMasterVersion(void);
	bool IsNextStartAnimationSkipped(bool reset);
	bool IsPlayerTradeRuleDefault(TradeRuleID id, const char* ruletype);
	bool IsUpgradeGroupMacroCompatible(UniverseID destructibleid, const char* macroname, const char* path, const char* group, const char* upgradetypename, const char* upgrademacroname);
	bool IsUpgradeMacroCompatible(UniverseID objectid, UniverseID moduleid, const char* macroname, bool ismodule, const char* upgradetypename, size_t slot, const char* upgrademacroname);
	bool IsValidTrade(TradeID tradeid);
	bool IsVentureExtensionSupported(void);
	bool IsVentureSeasonSupported(void);
	void OpenWebBrowser(const char* url);
	void ReleaseConstructionMapState(void);
	bool RemoveConstructionPlan(const char* source, const char* id);
	void RemoveFloatingSequenceFromConstructionPlan(UniverseID holomapid);
	void RemoveItemFromConstructionMap2(UniverseID holomapid, size_t itemidx, bool removesequence);
	bool RemoveOrder2(UniverseID controllableid, size_t idx, bool playercancelled, bool checkonly, bool onlyimmediate);
	void ResetConstructionMapModuleRotation(UniverseID holomapid, size_t cp_idx);
	void ResetMapPlayerRotation(UniverseID holomapid);
	void SaveLoadout(const char* macroname, UILoadout uiloadout, const char* source, const char* id, bool overwrite, const char* name, const char* desc);
	void SaveMapConstructionPlan(UniverseID holomapid, const char* source, const char* id, bool overwrite, const char* name, const char* desc);
	void SelectBuildMapEntry(UniverseID holomapid, size_t cp_idx);
	void SetConstructionMapBuildAngleStep(UniverseID holomapid, float angle);
	void SetConstructionMapCollisionDetection(UniverseID holomapid, bool value);
	void SetConstructionMapRenderSectorBackground(UniverseID holomapid, bool value);
	void SetConstructionMapRenderTransformGizmo(UniverseID holomapid, bool value);
	void SetConstructionSequenceFromConstructionMap(UniverseID containerid, UniverseID holomapid);
	void SetContainerGlobalPriceFactor(UniverseID containerid, float value);
	void SetContainerTradeRule(UniverseID containerid, TradeRuleID id, const char* ruletype, const char* wareid, bool value);
	void SetFocusMapConstructionPlanEntry(UniverseID holomapid, size_t cp_idx, bool resetplayerpan);
	void SetMapPicking(UniverseID holomapid, bool enable);
	void SetSelectedMapGroup(UniverseID holomapid, UniverseID destructibleid, const char* macroname, const char* path, const char* group);
	void SetSelectedMapMacroSlot(UniverseID holomapid, UniverseID defensibleid, UniverseID moduleid, const char* macroname, bool ismodule, const char* upgradetypename, size_t slot);
	void SetupConstructionSequenceModulesCache(UniverseID holomapid, UniverseID defensibleid, bool enable);
	void ShowConstructionMap(UniverseID holomapid, UniverseID stationid, const char* constructionplanid, bool restore);
	void ShowObjectConfigurationMap2(UniverseID holomapid, UniverseID defensibleid, UniverseID moduleid, const char* macroname, bool ismodule, UILoadout uiloadout, size_t cp_idx);
	bool ShuffleMapConstructionPlan2(UniverseID holomapid, bool checkonly, const char* raceid);
	void StartPanMap(UniverseID holomapid);
	void StartRotateMap(UniverseID holomapid);
	bool StopPanMap(UniverseID holomapid);
	bool StopRotateMap(UniverseID holomapid);
	void StoreConstructionMapState(UniverseID holomapid);
	void UpdateConstructionMapItemLoadout(UniverseID holomapid, size_t itemidx, UniverseID defensibleid, UILoadout uiloadout);
	void UpdateObjectConfigurationMap(UniverseID holomapid, UniverseID defensibleid, UniverseID moduleid, const char* macroname, bool ismodule, UILoadout uiloadout);
	void ZoomMap(UniverseID holomapid, float zoomstep);
	bool CanUndoConstructionMapChange(UniverseID holomapid);
	void UndoConstructionMapChange(UniverseID holomapid);
	bool CanRedoConstructionMapChange(UniverseID holomapid);
	void RedoConstructionMapChange(UniverseID holomapid);

	uint32_t PrepareBuildSequenceResources2(UniverseID holomapid, UniverseID stationid, bool useplanned);
	uint32_t GetBuildSequenceResources(UIWareInfo* result, uint32_t resultlen);
	uint32_t GetNumModuleRecycledResources(UniverseID moduleid);
	uint32_t GetModuleRecycledResources(UIWareInfo* result, uint32_t resultlen, UniverseID moduleid);
	uint32_t GetNumModuleNeededResources(UniverseID holomapid, size_t cp_idx);
	uint32_t GetModuleNeededResources(UIWareInfo* result, uint32_t resultlen, UniverseID holomapid, size_t cp_idx);
	void SetContainerBuildMethod(UniverseID containerid, const char* buildmethodid);
]]

local utf8 = require("utf8")

local menu = {
	name = "StationConfigurationMenu",
	newWareReservationWares = {},
	externalUsedLimitedModules = {},
	usedLimitedModules = {},
	currentConstructions = {},
	dirtyreservations = {},
	shuffleconnectionrace = "all",
}

local config = {
	mainLayer = 5,
	infoLayer = 4,
	contextLayer = 2,
	leftBar = {
		{ name = ReadText(1001, 2421),	icon = "stationbuildst_production",		mode = "moduletypes_production",	helpOverlayID = "stationbuildst_production",	helpOverlayText = ReadText(1028, 3250)  },
		{ name = ReadText(1001, 2439),	icon = "stationbuildst_buildmodule",	mode = "moduletypes_build",			helpOverlayID = "stationbuildst_buildmodule",	helpOverlayText = ReadText(1028, 3251)  },
		{ name = ReadText(1001, 2422),	icon = "stationbuildst_storage",		mode = "moduletypes_storage",		helpOverlayID = "stationbuildst_storage",		helpOverlayText = ReadText(1028, 3252)  },
		{ name = ReadText(1001, 2451),	icon = "stationbuildst_habitation",		mode = "moduletypes_habitation",	helpOverlayID = "stationbuildst_habitation",	helpOverlayText = ReadText(1028, 3253)  },
		{ name = ReadText(1001, 9620),	icon = "stationbuildst_welfare",		mode = "moduletypes_welfare",		helpOverlayID = "stationbuildst_welfare",		helpOverlayText = ReadText(1028, 3258)  },
		{ name = ReadText(1001, 2452),	icon = "stationbuildst_dock",			mode = "moduletypes_dock",			helpOverlayID = "stationbuildst_dock",			helpOverlayText = ReadText(1028, 3254)  },
		{ name = ReadText(1001, 2424),	icon = "stationbuildst_defense",		mode = "moduletypes_defence",		helpOverlayID = "stationbuildst_defense",		helpOverlayText = ReadText(1028, 3255)  },
		{ name = ReadText(1001, 9621),	icon = "stationbuildst_processing",		mode = "moduletypes_processing",	helpOverlayID = "stationbuildst_processing",	helpOverlayText = ReadText(1028, 3259)  },
		{ name = ReadText(1001, 2453),	icon = "stationbuildst_other",			mode = "moduletypes_other",			helpOverlayID = "stationbuildst_other",			helpOverlayText = ReadText(1028, 3256)  },
		{ name = ReadText(1001, 2454),	icon = "stationbuildst_venture",		mode = "moduletypes_venture",		helpOverlayID = "stationbuildst_venture",		helpOverlayText = ReadText(1028, 3257),		condition = C.IsVentureSeasonSupported },
	},
	leftBarLoadout = {
		{ name = ReadText(1001, 7901),	icon = "shipbuildst_turretgroups",		mode = "turretgroup" },
	},
	equipmentBlueprintGroups = {
		{ type = "turret", library = "weapons_turrets" },
		{ type = "turret", library = "weapons_missileturrets" },
		{ type = "shield", library = "shieldgentypes" },
	},
	dropDownTextProperties = {
		halign = "center",
		font = Helper.standardFont,
		fontsize = Helper.scaleFont(Helper.standardFont, Helper.standardFontSize),
		color = Color["text_normal"],
		x = 0,
		y = 0
	},
	scaleSize = 2,
	stateKeys = {
		{ "container", "UniverseID" },
		{ "buildstorage", "UniverseID" },
		{ "loadoutModuleIdx" },
		{ "modulesMode", },
		-- { "upgradeplan" }, -- reserved for loadoutModuleIdx information
		{ "origDefaultLoadout", "bool" },
	},
	sizeSorting = {
		["small"] = 1,
		["medium"] = 2,
		["large"] = 3,
		["extralarge"] = 4,
	},
	maxSidePanelWidth = 800,
	maxCenterPanelWidth = 1600,
	fileExtension = ".xml",
	slotSizeOrder = {
		["extralarge"]	= 1,
		["large"]		= 2,
		["medium"]		= 3,
		["small"]		= 4,
	},
	compatibilityFontSize = 5,
	mapfilterversion = 2,
	discreteAngleSlider = {
		min = 5,
		max = 180,
		step = 5,
	},
	moduleFilterWidth = 300,
}

__CORE_DETAILMONITOR_STATIONBUILD = __CORE_DETAILMONITOR_STATIONBUILD or {
	version = config.mapfilterversion,
	["discreteanglestep"] = 15.,
	["moduleoverlap"] = false,
	["environment"] = true,
	["gizmo"] = true,
}

-- kuertee start:
local callbacks = {}
-- kuertee end

local function init()
	Menus = Menus or {}
	table.insert(Menus, menu)
	if Helper then
		Helper.registerMenu(menu)
	end
	menu.extendedentries = {}
	menu.extendedresourceentries = {}

	if __CORE_DETAILMONITOR_STATIONBUILD.version < config.mapfilterversion then
		menu.upgradeSettingsVersion()
	end

	RegisterEvent("openmenu", function (_, menuname) return menu.openOtherMenu(menuname) end)

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

function menu.openOtherMenu(menuname)
	if menu.shown then
		if menu.haschanges then
			menu.contextData = { othermenu = menuname }
			menu.displayContextFrame("userquestion", Helper.scaleX(400), (Helper.viewWidth - Helper.scaleX(400)) / 2, Helper.viewHeight / 2)
		else
			Helper.closeMenuAndOpenNewMenu(menu, menuname, nil, true, true)
			menu.cleanup()
		end
	end
end

function menu.cleanup()
	UnregisterEvent("newWareReservation", menu.newWareReservationCallback)

	menu.container = nil
	menu.buildstorage = nil
	menu.modules = {}
	menu.modulesMode = nil
	menu.planMode = nil
	menu.searchtext = ""
	menu.modulesearchtext = {}
	menu.loadoutName = ""
	menu.loadout = nil
	menu.activatemap = nil
	menu.constructionplan = {}
	menu.constructionplans = {}
	menu.groupedmodules = {}
	menu.groupedupgrades = {}
	menu.groupedslots = {}
	menu.loadoutMode = nil
	menu.loadoutPlanMode = nil
	menu.loadoutModule = {}
	menu.upgradetypeMode = nil
	menu.currentSlot = nil
	menu.slots = {}
	menu.groups = {}
	menu.newAccountValue = nil
	menu.newWareReservation = nil
	menu.newWareReservationWares = {}
	menu.selectedModule = nil
	menu.newSelectedModule = nil
	menu.externalUsedLimitedModules = {}
	menu.usedLimitedModules = {}
	menu.haschanges = nil
	menu.hasconstructionchanges = nil
	menu.currentConstructions = {}
	menu.defaultLoadout = nil
	menu.origDefaultLoadout = nil

	menu.picking = true
	menu.cancelRequested = nil
	menu.noupdate = nil
	menu.allowpanning = nil
	menu.allowrotating = nil

	SetMouseOverOverride(menu.map, nil)

	if menu.holomap ~= 0 then
		C.RemoveHoloMap()
		menu.holomap = 0
	end

	menu.frameworkData = {}
	menu.modulesData = {}
	menu.planData = {}
	menu.titleData = {}
	menu.mapData = {}

	menu.leftbartable = nil
	menu.rightbartable = nil
	menu.titlebartable = nil
	menu.map = nil
	menu.moduletable = nil
	menu.plantable = nil
	menu.contextFrame = nil
	menu.contextMode = nil

	menu.currentCPID = nil
	menu.currentCPName = nil
	menu.canundo = nil
	menu.canredo = nil

	menu.topRows = {}
	menu.selectedRows = {}
	menu.selectedCols = {}

	UnregisterAddonBindings("ego_detailmonitor", "undo")

	-- kuertee start: callback
	if callbacks ["cleanup"] then
		for _, callback in ipairs (callbacks ["cleanup"]) do
			callback ()
		end
	end
	-- kuertee end: callback
end

-- button scripts

function menu.buttonLeftBar(mode, row)
	menu.prevModulesMode = menu.modulesMode
	AddUITriggeredEvent(menu.name, mode, menu.modulesMode == mode and "off" or "on")
	if menu.modulesMode == mode then
		PlaySound("ui_negative_back")
		menu.modulesMode = nil
	else
		menu.setdefaulttable = true
		PlaySound("ui_positive_select")
		menu.modulesMode = mode
	end

	menu.storePlanTableState()
	menu.displayMenu()
end

function menu.buttonLeftBarLoadout(mode, row)
	menu.prevUpgradetypeMode = menu.upgradetypeMode
	AddUITriggeredEvent(menu.name, mode, menu.upgradetypeMode == mode and "off" or "on")
	if menu.upgradetypeMode == mode then
		PlaySound("ui_negative_back")
		menu.upgradetypeMode = nil
	else
		menu.setdefaulttable = true
		PlaySound("ui_positive_select")
		menu.upgradetypeMode = mode
	end
	menu.determineInitialSlot()

	if menu.upgradetypeMode == "turretgroup" then
		local group = menu.groups[menu.currentSlot]
		C.SetSelectedMapGroup(menu.holomap, menu.loadoutModule.component, menu.loadoutModule.macro, group.path, group.group)
	else
		C.ClearSelectedMapMacroSlots(menu.holomap)
	end

	menu.storePlanTableState()
	menu.displayMenu()
end

function menu.buttonLeftBarColor(mode)
	if menu.loadoutMode then
		return Color["icon_normal"]
	else
		local modules = menu.modules[mode] or {}
		for i, module in ipairs(modules) do
			if (#menu.modulesearchtext == 0) or menu.filterModuleByText(module, menu.modulesearchtext) then
				return Color["icon_normal"]
			end
		end
	end
	return Color["icon_inactive"]
end

function menu.deactivateModulesMode()
	menu.prevModulesMode = menu.modulesMode
	PlaySound("ui_negative_back")
	menu.modulesMode = nil
	menu.storePlanTableState()
	menu.displayMenu()
end

function menu.deactivateUpgradetypeMode()
	menu.prevUpgradetypeMode = menu.upgradetypeMode
	PlaySound("ui_negative_back")
	menu.upgradetypeMode = nil
	menu.determineInitialSlot()
	C.ClearSelectedMapMacroSlots(menu.holomap)
	menu.storePlanTableState()
	menu.displayMenu()
end

function menu.buttonRightBar(newmenu, params)
	menu.state = menu.onSaveState()
	Helper.registerStationEditorState(menu)

	Helper.closeMenuAndOpenNewMenu(menu, newmenu, params, true)
	menu.cleanup()
end

function menu.buttonRightBarSelf()
	if not menu.loadoutMode then
		if menu.planMode then
			menu.planMode = nil
		else
			menu.planMode = "construction"
		end
	else
		if menu.loadoutPlanMode then
			menu.loadoutPlanMode = nil
		else
			menu.loadoutPlanMode = "normal"
		end
	end
	menu.displayMenu()
end

function menu.buttonSelectSlot(slot, row, col)
	if menu.currentSlot ~= slot then
		menu.currentSlot = slot
	end

	if menu.upgradetypeMode == "turretgroup" then
		local group = menu.groups[menu.currentSlot]
		C.SetSelectedMapGroup(menu.holomap, menu.loadoutModule.component, menu.loadoutModule.macro, group.path, group.group)
	end

	menu.topRows.modules = GetTopRow(menu.moduletable)
	menu.selectedRows.modules = row
	menu.selectedCols.modules = col
	menu.storePlanTableState()
	menu.displayMenu()
end

function menu.buttonSelectGroupUpgrade(type, group, macro, row, col, keepcontext)
	local oldcontextmode = Helper.tableCopy(menu.contextMode)
	if not keepcontext then
		menu.closeContextMenu()
	end

	local upgradetype = Helper.findUpgradeType(type)

	if (upgradetype.supertype == "group") then
		if macro ~= menu.constructionplan[menu.loadoutMode].upgradeplan[type][group].macro then
			menu.constructionplan[menu.loadoutMode].upgradeplan[type][group].macro = macro
			if (macro ~= "") and (menu.constructionplan[menu.loadoutMode].upgradeplan[type][group].count == 0) then
				menu.constructionplan[menu.loadoutMode].upgradeplan[type][group].count = 1
			elseif (macro == "") and (menu.constructionplan[menu.loadoutMode].upgradeplan[type][group].count ~= 0) then
				menu.constructionplan[menu.loadoutMode].upgradeplan[type][group].count = 0
			end

			menu.topRows.modules = GetTopRow(menu.moduletable)
			menu.selectedRows.modules = row
			menu.selectedCols.modules = col
			menu.storePlanTableState()
			menu.refreshPlan()
			menu.displayMenu()
		end
	end

	if menu.holomap and (menu.holomap ~= 0) then
		Helper.callLoadoutFunction(menu.constructionplan[menu.loadoutMode].upgradeplan, nil, function (loadout, _) return C.UpdateObjectConfigurationMap(menu.holomap, menu.container, menu.loadoutModule.component, menu.loadoutModule.macro, true, loadout) end)
	end

	if keepcontext then
		menu.topRows.context = GetTopRow(menu.contexttable)
		menu.selectedRows.context = keepcontext
		menu.displayContextFrame("slot", oldcontextmode.width, oldcontextmode.x, oldcontextmode.y)
	end
end

function menu.buttonClearEditbox(row)
	Helper.cancelEditBoxInput(menu.moduletable, row, 1)
	menu.searchtext = ""

	menu.displayMenu()
end

function menu.buttonExtendEntry(index, row)
	menu.extendEntry(menu.container, index)

	menu.topRows.modules = GetTopRow(menu.moduletable)
	menu.selectedRows.modules = Helper.currentTableRow[menu.moduletable]
	menu.selectedCols.modules = Helper.currentTableCol[menu.moduletable]
	menu.storePlanTableState()
	menu.selectedRows.plan = row
	menu.displayMenu()
end

function menu.buttonExtendResourceEntry(index, row)
	menu.extendResourceEntry(index)

	menu.topRows.modules = GetTopRow(menu.moduletable)
	menu.selectedRows.modules = Helper.currentTableRow[menu.moduletable]
	menu.selectedCols.modules = Helper.currentTableCol[menu.moduletable]
	menu.storePlanTableState()
	menu.selectedRows.planresources = row
	menu.displayMenu()
end

function menu.buttonAddModule(macro, row, col)
	C.AddMacroToConstructionMap(menu.holomap, macro, true)
	menu.floatingNewModule = macro
	SetMouseCursorOverride("crossarrows")
	SelectRow(menu.moduletable, row)
	SelectColumn(menu.moduletable, col)
	AddUITriggeredEvent(menu.name, "moduleadded", macro)
	Helper.closeDropDownOptions(menu.titlebartable, 1, 2)
end

function menu.buttonRemoveModule(module, removesequence)
	C.RemoveItemFromConstructionMap2(menu.holomap, module.idx, removesequence)
	menu.closeContextMenu()

	menu.topRows.modules = GetTopRow(menu.moduletable)
	menu.selectedRows.modules = Helper.currentTableRow[menu.moduletable]
	menu.selectedCols.modules = Helper.currentTableCol[menu.moduletable]
	menu.storePlanTableState()
	menu.refreshPlan()
	menu.displayMenu()
end

function menu.buttonCopyModule(module, copysequence)
	C.AddCopyToConstructionMap(menu.holomap, module.idx, copysequence)
	menu.floatingCopyModule = module.macro
	menu.closeContextMenu()
end

function menu.buttonResetModuleRotation(module)
	C.ResetConstructionMapModuleRotation(menu.holomap, module.idx)
	menu.closeContextMenu()
end

function menu.determineInitialSlot()
	menu.currentSlot = 1
	if menu.upgradetypeMode == "turretgroup" then
		local curslotsizepriority
		for i, group in ipairs(menu.groups) do
			if group.slotsize and (group.slotsize ~= "") then
				local sizeorder = config.slotSizeOrder[group.slotsize] or 0
				if (not curslotsizepriority) or (sizeorder < curslotsizepriority) then
					curslotsizepriority = sizeorder
					menu.currentSlot = i
				end
			end
		end
	end
end

function menu.buttonEditLoadout(module)
	local found
	for i, entry in ipairs(menu.constructionplan) do
		if entry.idx == module.idx then
			found = i
		end
	end

	if found then
		if not menu.loadoutMode then
			menu.hasconstructionchanges = menu.haschanges
			C.StoreConstructionMapState(menu.holomap)
			menu.mapstate = ffi.new("HoloMapState")
			C.GetMapState(menu.holomap, menu.mapstate)
		end
		menu.loadoutMode = found
		menu.loadoutModule = module
		menu.extendEntry(menu.container, tonumber(module.idx) + 1, true)

		Helper.callLoadoutFunction(module.upgradeplan, nil, function (loadout, _) return C.ShowObjectConfigurationMap2(menu.holomap, menu.container, menu.loadoutModule.component, menu.loadoutModule.macro, true, loadout, module.idx) end)

		menu.getUpgradeData(module.upgradeplan)
		menu.upgradetypeMode = "turretgroup"

		menu.determineInitialSlot()

		if menu.groups[menu.currentSlot] then
			local group = menu.groups[menu.currentSlot]
			C.SetSelectedMapGroup(menu.holomap, menu.loadoutModule.component, menu.loadoutModule.macro, group.path, group.group)
		end

		menu.closeContextMenu()

		menu.displayMainFrame()
		menu.displayMenu()
	end
end

function menu.buttonConfirmMoney()
	if menu.newAccountValue then
		local convertedComponent = ConvertStringTo64Bit(tostring(menu.buildstorage))
		local buildstoragemoney = GetComponentData(convertedComponent, "money")
		local amount = menu.newAccountValue - buildstoragemoney
		if amount > 0 then
			TransferPlayerMoneyTo(amount, convertedComponent)
		else
			TransferMoneyToPlayer(-amount, convertedComponent)
		end
		menu.newAccountValue = nil

		menu.storePlanTableState()
		menu.displayMenu()
	end
end

function menu.buttonSetMoneyToEstimate()
	local convertedComponent = ConvertStringTo64Bit(tostring(menu.buildstorage))
	local buildstoragemoney = GetComponentData(convertedComponent, "money")
	local amount = menu.totalprice - buildstoragemoney
	if amount > 0 then
		TransferPlayerMoneyTo(amount, convertedComponent)
	else
		TransferMoneyToPlayer(-amount, convertedComponent)
	end
	menu.newAccountValue = nil

	menu.storePlanTableState()
	menu.displayMenu()
end

function menu.buttonConfirm()
	C.SetConstructionSequenceFromConstructionMap(menu.container, menu.holomap)
	menu.updatePlan = getElapsedTime() + 0.1
end

function menu.buttonCancel()
	if menu.haschanges then
		menu.cancelRequested = true
		menu.storePlanTableState()
		menu.displayMenu()
	else
		if not menu.loadoutMode then
			-- nothing to do
		else
			 menu.buttonCancelLoadout()
		end
	end
end

function menu.buttonForceBuild()
	C.ForceBuildCompletion(menu.container)
	menu.updatePlan = getElapsedTime() + 0.1
end

function menu.resetDefaultLoadout()
	if menu.origDefaultLoadout ~= menu.defaultLoadout then
		C.SetDefensibleLoadoutLevel(menu.container, menu.origDefaultLoadout)
		menu.defaultLoadout = menu.origDefaultLoadout
	end
end

function menu.buttonCancelConfirm()
	menu.resetDefaultLoadout()
	C.ShowConstructionMap(menu.holomap, menu.container, "", false)
	menu.applySettings()
	menu.refreshPlan()
	menu.cancelRequested = nil
	menu.storePlanTableState()
	menu.displayMenu()
end

function menu.buttonCancelCancel()
	menu.cancelRequested = nil
	menu.storePlanTableState()
	menu.displayMenu()
end

function menu.showConstructionMap()
	C.ShowConstructionMap(menu.holomap, menu.container, "", true)
	menu.applySettings()
	if menu.mapstate then
		C.SetMapState(menu.holomap, menu.mapstate)
		menu.mapstate = nil
	end
end

function menu.buttonConfirmLoadout()
	menu.showConstructionMap()

	Helper.callLoadoutFunction(menu.constructionplan[menu.loadoutMode].upgradeplan, nil, function (loadout, _) return C.UpdateConstructionMapItemLoadout(menu.holomap, menu.loadoutModule.idx, menu.container, loadout) end)
	menu.defaultLoadout = -1

	menu.loadoutMode = nil
	menu.loadoutModule = {}
	menu.loadout = nil
	menu.hasconstructionchanges = nil

	menu.closeContextMenu()

	menu.displayMainFrame()
	menu.refreshPlan()
	menu.displayMenu()
end

function menu.buttonCancelLoadout()
	menu.cancelRequested = nil

	menu.showConstructionMap()

	menu.loadoutMode = nil
	menu.loadoutModule = {}
	menu.loadout = nil
	menu.hasconstructionchanges = nil

	menu.closeContextMenu()

	menu.displayMainFrame()
	menu.refreshPlan()
	menu.displayMenu()
end

function menu.buttonContextEncyclopedia(selectedUpgrade)
	if selectedUpgrade.type == "module" then
		local library = GetMacroData(selectedUpgrade.macro, "infolibrary")
		Helper.closeMenuAndOpenNewMenu(menu, "EncyclopediaMenu", { 0, 0, "Stations", library, selectedUpgrade.macro })
		menu.cleanup()
	else
		local upgradetype = Helper.findUpgradeType(selectedUpgrade.type)

		if (upgradetype.supertype == "macro") or (upgradetype.supertype == "virtualmacro") or (upgradetype.supertype == "group") then
			local library = GetMacroData(selectedUpgrade.macro, "infolibrary")
			Helper.closeMenuAndOpenNewMenu(menu, "EncyclopediaMenu", { 0, 0, upgradetype.emode, library, selectedUpgrade.macro })
			menu.cleanup()
		elseif upgradetype.supertype == "software" then
			-- selectedUpgrade.software
		elseif upgradetype.supertype == "ammo" then
			local library = GetMacroData(selectedUpgrade.macro, "infolibrary")
			if upgradetype.emode then
				Helper.closeMenuAndOpenNewMenu(menu, "EncyclopediaMenu", { 0, 0, upgradetype.emode, library, selectedUpgrade.macro })
				menu.cleanup()
			end
		end
	end
end

function menu.buttonInteract(selectedData, button, row, col, posx, posy)
	menu.selectedUpgrade = selectedData
	local x, y = GetLocalMousePosition()
	if x == nil then
		-- gamepad case
		x = posx
		y = -posy
	end
	menu.displayContextFrame("equipment", Helper.scaleX(200), x + Helper.viewWidth / 2, Helper.viewHeight / 2 - y)
end

function menu.buttonConstructionCommunity()
	if C.CanOpenWebBrowser() then
		C.OpenWebBrowser(ReadText(1001, 7976))
	end
end

function menu.buttonEditTradeRule()
	Helper.closeMenuAndOpenNewMenu(menu, "PlayerInfoMenu", { 0, 0, "globalorders" })
	menu.cleanup()
end

function menu.buttonCancelTradeActive(tradeid)
	if not C.IsValidTrade(tradeid) then
		menu.refresh = getElapsedTime()
		return
	end
	return C.CancelPlayerInvolvedTradeDeal(menu.container, tradeid, true)
end

function menu.buttonCancelTrade(tradeid)
	if C.CancelPlayerInvolvedTradeDeal(menu.container, tradeid, false) then
		-- The ware reservation is only implicitly removed after the trade was purged which only happens with a delay in gametime. To avoid no change in the menu after pressing the button, we hide the reservation now.
		menu.dirtyreservations[tostring(tradeid)] = true
	end
	menu.displayMenu()
end

function menu.onDropDownActivated()
	menu.closeContextMenu()
end

function menu.dropdownLoad(_, id)
	if id ~= nil then
		C.ShowConstructionMap(menu.holomap, menu.container, id, false)
		menu.applySettings()
		menu.currentCPID = id
		menu.closeContextMenu()

		menu.topRows.modules = GetTopRow(menu.moduletable)
		menu.selectedRows.modules = Helper.currentTableRow[menu.moduletable]
		menu.selectedCols.modules = Helper.currentTableCol[menu.moduletable]
		menu.storePlanTableState()
		menu.topRows.plan = 1
		menu.selectedRows.plan = nil
		menu.refreshPlan()
		menu.displayMenu()
	end
end

function menu.dropdownRemovedCP(_, id)
	if __CORE_DETAILMONITOR_USERQUESTION["deleteconstructionplan"] then
		C.RemoveConstructionPlan("local", id)
		if id == menu.currentCPID then
			menu.currentCPID = nil
			menu.currentCPName = nil
		end
		for i, plan in ipairs(menu.constructionplans) do
			if plan.id == id then
				table.remove(menu.constructionplans, i)
				break
			end
		end
	else
		Helper.closeDropDownOptions(menu.titlebartable, 1, 2)
		menu.contextData = { id = "deleteconstructionplan", cpid = id }
		menu.displayContextFrame("removeCP", Helper.scaleX(400), (Helper.viewWidth - Helper.scaleX(400)) / 2, Helper.viewHeight / 2)
	end
end

function menu.dropdownLoadout(_, loadoutid)
	if loadoutid ~= nil then
		if menu.loadout ~= loadoutid then
			menu.loadout = loadoutid
			local preset
			for _, loadout in ipairs(menu.loadouts) do
				if loadout.id == menu.loadout then
					menu.loadoutName = loadout.name
					if loadout.preset then
						preset = loadout.preset
						menu.loadout = nil
						menu.loadoutName = ""
					end
					break
				end
			end
			local loadout
			if preset then
				loadout = Helper.getLoadoutHelper(C.GenerateModuleLoadout, C.GenerateModuleLoadoutCounts, menu.holomap, menu.loadoutModule.idx, menu.container, preset)
			else
				loadout = Helper.getLoadoutHelper(C.GetLoadout, C.GetLoadoutCounts, 0, menu.loadoutModule.macro, loadoutid)
			end
			local upgradeplan = Helper.convertLoadout(menu.loadoutModule.component, menu.loadoutModule.macro, loadout, nil)
			menu.getUpgradeData(upgradeplan)

			if menu.holomap and (menu.holomap ~= 0) then
				Helper.callLoadoutFunction(menu.constructionplan[menu.loadoutMode].upgradeplan, nil, function (loadout, _) return C.UpdateObjectConfigurationMap(menu.holomap, menu.container, menu.loadoutModule.component, menu.loadoutModule.macro, true, loadout) end)
			end

			menu.displayMenu()
		end
	end
end

function  menu.dropdownRemovedLoadout(_, loadoutid)
	local macro = (menu.loadoutModule.macro ~= "") and menu.loadoutModule.macro or GetComponentData(ConvertStringToLuaID(tostring(menu.loadoutModule.component)), "macro")
	C.RemoveLoadout("local", macro, loadoutid)
	if loadoutid == menu.loadout then
		menu.loadout = nil
		menu.loadoutName = nil
	end
	for i, loadout in ipairs(menu.loadouts) do
		if loadout.id == loadoutid then
			table.remove(menu.loadouts, i)
			break
		end
	end
end

function menu.dropdownDefaultLoadout(_, level)
	menu.defaultLoadout = tonumber(level)
	C.SetDefensibleLoadoutLevel(menu.container, menu.defaultLoadout)

	if menu.defaultLoadout ~= -1 then
		C.SetupConstructionSequenceModulesCache(menu.holomap, menu.container, true)
		for i, entry in ipairs(menu.constructionplan) do
			local active = false
			for i, upgradetype in ipairs(Helper.upgradetypes) do
				if upgradetype.supertype == "macro" then
					if C.GetNumUpgradeSlots(entry.component, entry.macro, upgradetype.type) > 0 then
						active = true
						break
					end
				end
			end
			if active then
				local loadout = Helper.getLoadoutHelper(C.GenerateModuleLoadout, C.GenerateModuleLoadoutCounts, menu.holomap, entry.idx, menu.container, menu.defaultLoadout)
				local upgradeplan = Helper.convertLoadout(entry.component, entry.macro, loadout, nil)
				Helper.callLoadoutFunction(upgradeplan, nil, function (loadout, _) return C.UpdateConstructionMapItemLoadout(menu.holomap, entry.idx, menu.container, loadout) end)
			end
		end
		C.SetupConstructionSequenceModulesCache(menu.holomap, menu.container, false)
		menu.refreshPlan()
		menu.displayMenu()
	end
end

function  menu.dropdownTradeRule(container, type, id, ware, refresh)
	if type == "trade" then
		C.SetContainerTradeRule(container, tonumber(id), "buy",  ware or "", true)
		C.SetContainerTradeRule(container, tonumber(id), "sell", ware or "", true)
	else
		C.SetContainerTradeRule(container, tonumber(id), type, ware or "", true)
	end

	if refresh then
		menu.storePlanTableState()
		menu.displayMenu()
	end
end

function menu.buttonTitleSave()
	if menu.contextMode and (menu.contextMode.mode == "saveCP") then
		menu.closeContextMenu()
	else
		Helper.closeDropDownOptions(menu.titlebartable, 1, 2)
		menu.displayContextFrame("saveCP", menu.titleData.dropdownWidth + 7 * (menu.titleData.height + Helper.borderSize), menu.titleData.offsetX + menu.titleData.nameWidth + Helper.borderSize, menu.titleData.offsetY + menu.titleData.height + Helper.borderSize)
	end
end

function menu.buttonTitleImport()
	if menu.contextMode and (menu.contextMode.mode == "importCP") then
		menu.closeContextMenu()
	else
		Helper.closeDropDownOptions(menu.titlebartable, 1, 2)
		menu.contextData = {}
		menu.displayContextFrame("importCP", menu.titleData.dropdownWidth + 7 * (menu.titleData.height + Helper.borderSize), menu.titleData.offsetX + menu.titleData.nameWidth + Helper.borderSize, menu.titleData.offsetY + menu.titleData.height + Helper.borderSize)
	end
end

function menu.buttonTitleExport()
	if menu.contextMode and (menu.contextMode.mode == "exportCP") then
		menu.closeContextMenu()
	else
		Helper.closeDropDownOptions(menu.titlebartable, 1, 2)
		menu.displayContextFrame("exportCP", menu.titleData.dropdownWidth + 7 * (menu.titleData.height + Helper.borderSize), menu.titleData.offsetX + menu.titleData.nameWidth + Helper.borderSize, menu.titleData.offsetY + menu.titleData.height + Helper.borderSize)
	end
end

function menu.buttonTitleSaveLoadout()
	if menu.contextMode and (menu.contextMode.mode == "saveLoadout") then
		menu.closeContextMenu()
	else
		Helper.closeDropDownOptions(menu.titlebartable, 1, 2)
		menu.displayContextFrame("saveLoadout", menu.titleData.dropdownWidth + 7 * (menu.titleData.height + Helper.borderSize), menu.titleData.offsetX + menu.titleData.nameWidth + Helper.borderSize, menu.titleData.offsetY + menu.titleData.height + Helper.borderSize)
	end
end

function menu.buttonTitleSettings()
	if menu.contextMode and (menu.contextMode.mode == "settings") then
		menu.closeContextMenu()
	else
		Helper.closeDropDownOptions(menu.titlebartable, 1, 2)
		menu.displayContextFrame("settings", menu.titleData.dropdownWidth + 7 * (menu.titleData.height + Helper.borderSize), menu.titleData.offsetX + menu.titleData.nameWidth + Helper.borderSize, menu.titleData.offsetY + menu.titleData.height + Helper.borderSize)
	end
end

function menu.buttonModuleFilter(offsety)
	if menu.contextMode and (menu.contextMode.mode == "modulefilter") then
		menu.closeContextMenu()
	else
		Helper.closeDropDownOptions(menu.titlebartable, 1, 2)
		menu.displayContextFrame("modulefilter", Helper.scaleX(config.moduleFilterWidth), menu.modulesData.offsetX + menu.modulesData.width + Helper.borderSize, offsety)
	end
end

function menu.buttonSave(overwrite)
	local source, id
	if overwrite then
		_, _, source = menu.checkCPNameID()
		id = menu.currentCPID
	end

	Helper.closeDropDownOptions(menu.titlebartable, 1, 2)
	C.SaveMapConstructionPlan(menu.holomap, source or "local", id or "player", id ~= nil, menu.currentCPName, "")
	menu.closeContextMenu()
	menu.refreshTitleBar()
end

function menu.buttonExport(checked)
	local canoverwrite, cansaveasnew, source = menu.checkCPNameID()
	if canoverwrite and (not checked) then
		menu.contextData = menu.contextData or {}
		menu.contextData.mode = "export"
		menu.displayContextFrame("overwritequestion", Helper.scaleX(400), (Helper.viewWidth - Helper.scaleX(400)) / 2, Helper.viewHeight / 2)
	else
		local id = menu.currentCPID
		local filename = utf8.gsub(menu.currentCPName, "[^%w_%-%() ]", "_")
		C.ExportMapConstructionPlan(menu.holomap, filename, id or "", id ~= nil, menu.currentCPName, "")
		menu.closeContextMenu()
		menu.refreshTitleBar()
	end
end

function menu.buttonImport(checked)
	local id = menu.contextData.selectedEntry.id
	if menu.constructionplansbyID[id] and (not checked) then
		menu.contextData = menu.contextData or {}
		menu.contextData.mode = "import"
		menu.displayContextFrame("overwritequestion", Helper.scaleX(400), (Helper.viewWidth - Helper.scaleX(400)) / 2, Helper.viewHeight / 2)
	else
		if menu.constructionplansbyID[id] then
			C.RemoveConstructionPlan("local", id)
		end
		local filename = utf8.gsub(menu.contextData.selectedEntry.filename, "[^%w_%-%() ]", "_")
		C.ImportMapConstructionPlan(filename, id)
		menu.refreshTitleBar()
		menu.displayContextFrame("importCP", menu.titleData.dropdownWidth + 7 * (menu.titleData.height + Helper.borderSize), menu.titleData.offsetX + menu.titleData.nameWidth + Helper.borderSize, menu.titleData.offsetY + menu.titleData.height + Helper.borderSize)
	end
end

function menu.buttonReloadImportable()
	menu.getImportablePlans()
	menu.refreshTitleBar()
	menu.contextData = {}
	menu.displayContextFrame("importCP", menu.titleData.dropdownWidth + 7 * (menu.titleData.height + Helper.borderSize), menu.titleData.offsetX + menu.titleData.nameWidth + Helper.borderSize, menu.titleData.offsetY + menu.titleData.height + Helper.borderSize)
end

function menu.buttonSaveLoadout(overwrite)
	local loadoutid
	if overwrite then
		loadoutid = menu.loadout
	end

	Helper.closeDropDownOptions(menu.titlebartable, 1, 2)
	local macro = (menu.loadoutModule.macro ~= "") and menu.loadoutModule.macro or GetComponentData(ConvertStringToLuaID(tostring(menu.loadoutModule.component)), "macro")
	if macro ~= "" then
		Helper.callLoadoutFunction(menu.constructionplan[menu.loadoutMode].upgradeplan, nil, function (loadout, _) return C.SaveLoadout(macro, loadout, "local", loadoutid or "player", loadoutid ~= nil, menu.loadoutName, "") end)
		menu.getPresetLoadouts()
	end
	menu.closeContextMenu()
	menu.refreshTitleBar()
end

function menu.buttonAssignConstructionVessel()
	Helper.closeMenuAndOpenNewMenu(menu, "MapMenu", { 0, 0, true, nil, nil, "selectCV", { ConvertStringToLuaID(tostring(menu.container)) } })
	menu.cleanup()
end

function menu.buttonFireConstructionVessel(builder, orderidx)
	C.RemoveOrder2(builder, orderidx, true, false, true)
	menu.displayMenu()
	menu.refresh = getElapsedTime() + 1.0
end

function menu.buttonRemoveSearchEntry(index)
	Helper.cancelEditBoxInput(menu.moduletable, 2, 1)

	if menu.modulesearchtext[index].race then
		for i, race in ipairs(menu.races) do
			if race.id == menu.modulesearchtext[index].race then
				menu.races[i].selected = nil
				break
			end
		end
	end
	table.remove(menu.modulesearchtext, index)

	menu.displayMenu()
end

-- editbox scripts
function menu.onEditBoxActivated(_, oldtext)
	menu.oldEditBoxContent = oldtext
end

function menu.editboxSearchUpdateText(_, text, textchanged)
	if textchanged then
		menu.searchtext = text
	end

	menu.displayMenu()
end

function menu.editboxModuleSearchUpdateText(widget, text, textchanged)
	if textchanged then
		table.insert(menu.modulesearchtext, { text = text })
	end

	C.SetEditBoxText(widget, "")
	menu.displayMenu()
end

function menu.editboxNameUpdateText(_, text, textchanged)
	if textchanged then
		local name = text
		if name == "" then
			name = menu.oldEditBoxContent
		end
		SetComponentName(ConvertStringToLuaID(tostring(menu.container)), name)
	end
	if text == "" then
		local desc = Helper.createEditBox(Helper.createTextInfo(ffi.string(C.GetComponentName(menu.container)), "center", Helper.headerRow1Font, Helper.scaleFont(Helper.headerRow1Font, Helper.headerRow1FontSize), 255, 255, 255, 100), true, 0, 0, 0, 0, nil, nil, false)
		Helper.setCellContent(menu, menu.titlebartable, desc, 1, 1, nil, "editbox", nil, menu.editboxNameUpdateText)
	end
end

function menu.editboxCPNameUpdateText(_, text)
	menu.currentCPName = text
	menu.currentCPID = nil
end

function menu.editboxLoadoutNameUpdateText(_, text)
	menu.loadoutName = text
	menu.loadout = nil
end

function menu.slidercellSelectAmount(type, group, row, keepcontext, value)
	local oldcontextmode = Helper.tableCopy(menu.contextMode)
	if not keepcontext then
		menu.closeContextMenu()
	end

	local upgradetype = Helper.findUpgradeType(type)

	if (upgradetype.supertype == "group") then
		if value ~= menu.constructionplan[menu.loadoutMode].upgradeplan[type][group].count then
			menu.constructionplan[menu.loadoutMode].upgradeplan[type][group].count = value

			menu.selectedRows.modules = row
		end
	end

	if menu.holomap and (menu.holomap ~= 0) then
		Helper.callLoadoutFunction(menu.constructionplan[menu.loadoutMode].upgradeplan, nil, function (loadout, _) return C.UpdateObjectConfigurationMap(menu.holomap, menu.container, menu.loadoutModule.component, menu.loadoutModule.macro, true, loadout) end)
	end

	if keepcontext then
		menu.topRows.context = GetTopRow(menu.contexttable)
		menu.selectedRows.context = keepcontext
		menu.displayContextFrame("slot", oldcontextmode.width, oldcontextmode.x, oldcontextmode.y)
	end
end

function menu.slidercellMoney(_, value)
	menu.newAccountValue = value
end

function menu.slidercellWarePriceOverride(ware, row, value)
	SetContainerWarePriceOverride(menu.buildstorage, ware, true, value)
	C.SetContainerGlobalPriceFactor(menu.buildstorage, -1)
	menu.storePlanTableState()
	menu.selectedRows.plan = row
end

function menu.slidercellGlobalWarePriceFactor(row, value)
	local modifier = Helper.round(value / 100, 2)
	C.SetContainerGlobalPriceFactor(menu.buildstorage, modifier)
	for _, ware in ipairs(menu.tradewares) do
		local newprice = ware.minprice + (ware.maxprice - ware.minprice) * modifier
		SetContainerWarePriceOverride(menu.buildstorage, ware.ware, true, newprice)
		if ware.row then
			Helper.setSliderCellValue(menu.plantable, ware.row, 3, newprice)
		end
	end
	menu.storePlanTableState()
	menu.selectedRows.plan = row
end

function menu.onSliderCellConfirm()
	if not menu.selectedRows.plan then
		menu.storePlanTableState()
	end
	menu.refreshPlan()
	menu.storePlanTableState()
	menu.displayMenu()
end

function menu.checkboxToggleGlobalWarePriceModifier()
	C.SetContainerGlobalPriceFactor(menu.buildstorage, (menu.globalpricefactor >= 0) and -1 or 1)
	if menu.globalpricefactor < 0 then
		for _, ware in ipairs(menu.tradewares) do
			SetContainerWarePriceOverride(menu.buildstorage, ware.ware, true, ware.maxprice)
		end
	end

	menu.storePlanTableState()
	menu.displayMenu()
end

function menu.checkboxSetTradeRuleOverride(container, type, checked, ware)
	if type == "trade" then
		if checked then
			C.SetContainerTradeRule(container, -1, "buy",  ware or "", false)
			C.SetContainerTradeRule(container, -1, "sell", ware or "", false)
		else
			local currentid = C.GetContainerTradeRuleID(container, "buy", ware or "")
			C.SetContainerTradeRule(container, (currentid ~= 0) and currentid or -1, "buy",  ware or "", true)
			C.SetContainerTradeRule(container, (currentid ~= 0) and currentid or -1, "sell", ware or "", true)
		end
	else
		if checked then
			C.SetContainerTradeRule(container, -1, type, ware or "", false)
		else
			local currentid = C.GetContainerTradeRuleID(container, type, ware or "")
			C.SetContainerTradeRule(container, (currentid ~= 0) and currentid or -1, type, ware or "", true)
		end
	end

	menu.storePlanTableState()
	menu.displayMenu()
end

-- Menu member functions

function menu.hotkey(action)
	if action == "INPUT_ACTION_ADDON_DETAILMONITOR_UNDO" then
		menu.undoHelper(true)
	elseif action == "INPUT_ACTION_ADDON_DETAILMONITOR_REDO" then
		menu.undoHelper(false)
	end
end

function menu.undoHelper(undo)
	if undo then
		C.UndoConstructionMapChange(menu.holomap)
	else
		C.RedoConstructionMapChange(menu.holomap)
	end
	menu.refreshPlan()
	menu.displayMenu()
end

function menu.sorterModules(type, a, b)
	local aname, amakerrace, atier, asize, awaregroup = GetMacroData(a, "shortname", "makerrace", "tier", "size", "waregroup")
	local bname, bmakerrace, btier, bsize, bwaregroup = GetMacroData(b, "shortname", "makerrace", "tier", "size", "waregroup")
	atier = atier or 0
	btier = btier or 0
	if #amakerrace > 0 then
		amakerrace = amakerrace[1]
	else
		amakerrace = ""
	end
	if #bmakerrace > 0 then
		bmakerrace = bmakerrace[1]
	else
		bmakerrace = ""
	end

	if atier == btier then
		if type == "moduletypes_production" then
			if awaregroup == bwaregroup then
				if aname == bname then
					return amakerrace < bmakerrace
				end
				return aname < bname
			end
			return awaregroup < bwaregroup
		else
			if amakerrace == bmakerrace then
				local asizesort = config.sizeSorting[asize] or 0
				local bsizesort = config.sizeSorting[bsize] or 0
				if asizesort == bsizesort then
					return aname < bname
				end
				return asizesort < bsizesort
			end
			return amakerrace < bmakerrace
		end
	end
	return atier < btier
end

function menu.newWareReservationCallback(_, data)
	local containerid, ware, reserverid = string.match(data, "(.+);(.+);(.+)")
	if menu.buildstorage == ConvertStringTo64Bit(containerid) then
		PlaySound("notification_achievement")
		menu.newWareReservation = (menu.newWareReservation or 0) + 1
		if menu.newWareReservationWares[ware] then
			menu.newWareReservationWares[ware][reserverid] = true
		else
			menu.newWareReservationWares[ware] = { [reserverid] = true }
		end
		menu.storePlanTableState()
		menu.displayMenu()
	end
end

function menu.onShowMenu(state)
	-- layout
	menu.scaleSize = Helper.scaleX(config.scaleSize)
	menu.frameworkData = {
		sidebarWidth = Helper.scaleX(Helper.sidebarWidth),
		offsetX = Helper.frameBorder,
		offsetY = Helper.frameBorder + 20,
	}
	local reservedSidePanelWidth = math.floor(0.25 * Helper.viewWidth)
	local actualSidePanelWidth = math.min(reservedSidePanelWidth, Helper.scaleX(config.maxSidePanelWidth))
	reservedSidePanelWidth = reservedSidePanelWidth - menu.frameworkData.sidebarWidth - menu.frameworkData.offsetX - 2 * Helper.borderSize
	menu.modulesData = {
		width = actualSidePanelWidth - menu.frameworkData.sidebarWidth - menu.frameworkData.offsetX - 2 * Helper.borderSize,
		offsetX = menu.frameworkData.sidebarWidth + menu.frameworkData.offsetX + 2 * Helper.borderSize,
		offsetY = Helper.frameBorder + Helper.borderSize,
	}
	menu.planData = {
		width = actualSidePanelWidth - menu.frameworkData.sidebarWidth - menu.frameworkData.offsetX - 2 * Helper.borderSize,
		offsetY = Helper.frameBorder + Helper.borderSize,
	}

	local reserverdCenterPanelWidth = Helper.viewWidth - 2 * menu.modulesData.offsetX - 2 * reservedSidePanelWidth - 4 * Helper.borderSize
	local actualCenterPanelWidth = math.min(reserverdCenterPanelWidth, Helper.scaleX(config.maxCenterPanelWidth))
	menu.statsData = {
		width = actualCenterPanelWidth / 2,
		offsetX = menu.modulesData.offsetX + reservedSidePanelWidth + 3 * Helper.borderSize + (reserverdCenterPanelWidth - actualCenterPanelWidth / 2) / 2,
		offsetY = Helper.frameBorder,
	}
	menu.titleData = {
		width = actualCenterPanelWidth,
		height = Helper.scaleY(40),
		dropdownWidth = 6 * menu.frameworkData.sidebarWidth,
		offsetX = menu.modulesData.offsetX + reservedSidePanelWidth + 3 * Helper.borderSize + (reserverdCenterPanelWidth - actualCenterPanelWidth) / 2,
		offsetY = Helper.frameBorder,
	}
	menu.titleData.nameWidth = menu.titleData.width - 7 * (menu.titleData.height + Helper.borderSize) - menu.titleData.dropdownWidth - Helper.borderSize
	if menu.titleData.nameWidth < 200 then
		menu.titleData.height = math.floor(menu.titleData.height * 2 / 3)
		menu.titleData.dropdownWidth = 5 * menu.titleData.height
		menu.titleData.nameWidth = math.max(20, menu.titleData.width - 7 * (menu.titleData.height + Helper.borderSize) - menu.titleData.dropdownWidth - Helper.borderSize)
	end
	menu.planData.offsetX = Helper.viewWidth - actualSidePanelWidth + Helper.borderSize
	menu.mapData = {
		width = Helper.viewWidth,
		height = Helper.viewHeight,
		offsetX = 0,
		offsetY = 0
	}
	menu.subHeaderRowHeight = Helper.scaleY(26)

	menu.headerTextProperties = {
		font = Helper.headerRow1Font,
		fontsize = Helper.scaleFont(Helper.headerRow1Font, Helper.headerRow1FontSize),
		x = Helper.scaleX(Helper.headerRow1Offsetx),
		y = math.floor((menu.titleData.height - Helper.scaleY(Helper.headerRow1Height)) / 2 + Helper.scaleY(Helper.headerRow1Offsety)),
		minRowHeight = menu.titleData.height,
		scaling = false,
		cellBGColor = Color["row_background"],
		titleColor = Color["row_title"],
	}

	menu.headerCenteredTextProperties = {
		font = Helper.headerRow1Font,
		fontsize = Helper.scaleFont(Helper.headerRow1Font, Helper.headerRow1FontSize),
		x = Helper.scaleX(Helper.headerRow1Offsetx),
		y = math.floor((menu.titleData.height - Helper.scaleY(Helper.headerRow1Height)) / 2 + Helper.scaleY(Helper.headerRow1Offsety)),
		minRowHeight = menu.titleData.height,
		scaling = false,
		halign = "center",
		cellBGColor = Color["row_background"],
		titleColor = Color["row_title"],
	}

	menu.slidercellTextProperties = {
		font = Helper.headerRow1Font,
		fontsize = Helper.scaleFont(Helper.headerRow1Font, Helper.headerRow1FontSize),
		x = Helper.scaleX(Helper.headerRow1Offsetx),
	}

	menu.extraFontSize = Helper.scaleFont(Helper.standardFont, Helper.standardFontSize)

	-- parameters
	menu.container = ConvertIDTo64Bit(menu.param[3])
	menu.buildstorage = ConvertIDTo64Bit(GetComponentData(menu.container, "buildstorage")) or 0

	menu.defaultLoadout = Helper.round(C.GetDefensibleLoadoutLevel(menu.container), 1)
	menu.origDefaultLoadout = menu.defaultLoadout

	RegisterEvent("newWareReservation", menu.newWareReservationCallback)

	menu.initExtendedEntry(menu.container)

	local sets = GetComponentData(menu.container, "modulesets")
	menu.set = sets[1] or ""

	-- prepare modules
	menu.modules = {}
	local races = {}
	local connectionmoduleraces = {}
	for _, entry in ipairs(config.leftBar) do
		menu.modules[entry.mode] = {}
		local n = C.GetNumBlueprints(menu.set, entry.mode, "")
		local buf = ffi.new("UIBlueprint[?]", n)
		n = C.GetBlueprints(buf, n, menu.set, entry.mode, "")
		for i = 0, n - 1 do
			local macro = ffi.string(buf[i].macro)
			local makerrace, makerracename = GetMacroData(macro, "makerraceid", "makerracename")
			for i, race in ipairs(makerrace) do
				races[race] = makerracename[i]
				if IsMacroClass(macro, "connectionmodule") then
					connectionmoduleraces[race] = makerracename[i]
				end
			end
			table.insert(menu.modules[entry.mode], macro)
		end
		table.sort(menu.modules[entry.mode], function (a, b) return menu.sorterModules(entry.mode, a, b) end)
		entry.active = n > 0
	end

	menu.races = {}
	for race, name in pairs(races) do
		table.insert(menu.races, { id = race, name = name })
	end
	table.sort(menu.races, Helper.sortName)
	table.insert(menu.races, 1, { id = "generic", name = ReadText(1001, 11916) })

	menu.connectionmoduleraces = {}
	for race, name in pairs(connectionmoduleraces) do
		table.insert(menu.connectionmoduleraces, { id = race, text = name, icon = "", displayremoveoption = false })
	end
	table.sort(menu.connectionmoduleraces, function (a, b) return a.text < b.text end)
	table.insert(menu.connectionmoduleraces, 1, { id = "all", text = ReadText(1001, 11922), icon = "", displayremoveoption = false })

	-- assemble possible upgrades (wares, macros)
	menu.upgradewares = {}
	for _, blueprintGroup in ipairs(config.equipmentBlueprintGroups) do
		local n = C.GetNumBlueprints(menu.set, blueprintGroup.library, "")
		local buf = ffi.new("UIBlueprint[?]", n)
		n = C.GetBlueprints(buf, n, menu.set, blueprintGroup.library, "")
		for i = 0, n - 1 do
			local entry = {}
			entry.macro = ffi.string(buf[i].macro)
			entry.ware = ffi.string(buf[i].ware)
			if menu.upgradewares[blueprintGroup.type] then
				table.insert(menu.upgradewares[blueprintGroup.type], entry)
			else
				menu.upgradewares[blueprintGroup.type] = { entry }
			end
		end
	end

	-- check for limited modules
	menu.externalUsedLimitedModules = {}
	local n = C.GetNumUsedLimitedModules(menu.container)
	if n > 0 then
		local buf = ffi.new("UIMacroCount[?]", n)
		n = C.GetUsedLimitedModules(buf, n, menu.container)
		for i = 0, n - 1 do
			local macro = ffi.string(buf[i].macro)
			menu.externalUsedLimitedModules[macro] = buf[i].amount
		end
	end

	-- trade rules
	Helper.updateTradeRules()

	menu.searchtext = ""
	menu.modulesearchtext = {}
	menu.loadoutName = ""
	menu.modulesMode = "moduletypes_production"
	menu.upgradetypeMode = "turretgroup"
	menu.planMode = "construction"
	menu.loadoutPlanMode = "normal"

	menu.topRows = {}
	menu.selectedRows = {}
	menu.selectedCols = {}

	if state then
		menu.state = state
	end

	-- we are (again) in the station config menu, menu keeps track of changes itself
	Helper.unregisterStationEditorChanges()

	menu.displayMainFrame()

	RegisterAddonBindings("ego_detailmonitor", "undo")
	Helper.setKeyBinding(menu, menu.hotkey)
end

function menu.onShowMenuSound()
	if not C.IsNextStartAnimationSkipped(false) then
		PlaySound("ui_config_station_open")
	else
		PlaySound("ui_menu_changed")
	end
end

function menu.displayLeftBar(frame)
	local maxSlotWidth = math.floor((menu.modulesData.width - 8 * Helper.borderSize) / 9)

	local leftBar = config.leftBar
	local offsety = menu.frameworkData.offsetY
	if menu.loadoutMode then
		leftBar = config.leftBarLoadout
		offsety = menu.modulesData.offsetY + menu.titleData.height + 2 * Helper.borderSize + maxSlotWidth
	end

	local ftable = frame:addTable(1, { tabOrder = 2, width = menu.frameworkData.sidebarWidth, height = 0, x = menu.frameworkData.offsetX, y = offsety, scaling = false, borderEnabled = false, reserveScrollBar = false })

	local found = true
	for _, entry in ipairs(leftBar) do
		local active = true
		local selected = false
		local prevSelected = false
		local mouseovertext = entry.name
		if menu.loadoutMode then
			selected = entry.mode == menu.upgradetypeMode
			prevSelected = entry.mode == menu.prevUpgradetypeMode
			if entry.mode == "turretgroup" then
				active = active and (#menu.groups > 0)
			end
		else
			active = entry.active and ((not entry.condition) or entry.condition())
			if entry.mode == "moduletypes_venture" then
				if entry.condition and (not entry.condition()) then
					mouseovertext = mouseovertext .. "\n" .. ColorText["text_error"] .. ReadText(1026, 7930)
				end
			end
			selected = entry.mode == menu.modulesMode
			prevSelected = entry.mode == menu.prevModulesMode
		end
		local row = ftable:addRow(active, { fixed = true, bgColor = Color["row_background_blue"] })

		-- if nothing selected yet, select this one if active
		if (not found) and active then
			found = true
			menu.modulesMode = entry.mode
		end

		-- if selected, but not active, select next active entry
		if selected and (not active) then
			found = false
			selected = false
		end

		if selected then
			menu.selectedRows.left = row.index
		elseif prevSelected then
			menu.selectedRows.left = row.index
		end
		row[1]:createButton({ helpOverlayID = entry.helpOverlayID, helpOverlayText = entry.helpOverlayText,  active = active, height = menu.frameworkData.sidebarWidth, mouseOverText = mouseovertext, bgColor = selected and Color["row_background_selected"] or Color["button_background_default"] }):setIcon(entry.icon, { color = function () return menu.buttonLeftBarColor(entry.mode) end })
		if not menu.loadoutMode then
			row[1].handlers.onClick = function () return menu.buttonLeftBar(entry.mode, row.index) end
		else
			row[1].handlers.onClick = function () return menu.buttonLeftBarLoadout(entry.mode, row.index) end
		end
	end
	ftable:setTopRow(menu.topRows.left)
	ftable:setSelectedRow(menu.selectedRows.left)
	menu.topRows.left = nil
	menu.selectedRows.left = nil
end

function menu.updateConstructionPlans()
	menu.constructionplans = {}
	menu.constructionplansbyID = {}
	local n = C.GetNumConstructionPlans()
	local buf = ffi.new("UIConstructionPlan[?]", n)
	n = C.GetConstructionPlans(buf, n)
	local ischeatversion = IsCheatVersion()
	for i = 0, n - 1 do
		local source = ffi.string(buf[i].source)
		if (source == "local") or ischeatversion then
			local id = ffi.string(buf[i].id)
			local active = false
			local mouseovertext
			local numinvalidpatches = ffi.new("uint32_t[?]", 1)
			if not C.IsConstructionPlanValid(id, numinvalidpatches) then
				local numpatches = numinvalidpatches[0]
				local patchbuf = ffi.new("InvalidPatchInfo[?]", numpatches)
				numpatches = C.GetConstructionPlanInvalidPatches(patchbuf, numpatches, id)
				mouseovertext = ReadText(1001, 2685) .. ReadText(1001, 120)			-- Missing, old or disabled extensions:
				for j = 0, numpatches - 1 do
					if j > 3 then
						mouseovertext = mouseovertext .. "\n- ..."
						break
					end
					mouseovertext = mouseovertext .. "\n- " .. ffi.string(patchbuf[j].name) .. " (" .. ffi.string(patchbuf[j].id) .. " - " .. ffi.string(patchbuf[j].requiredversion) .. ")"
					if patchbuf[j].state == 2 then
						mouseovertext = mouseovertext .. " " .. ReadText(1001, 2686)
					elseif patchbuf[j].state == 3 then
						mouseovertext = mouseovertext .. " " .. ReadText(1001, 2687)
					elseif patchbuf[j].state == 4 then
						mouseovertext = mouseovertext .. " " .. string.format(ReadText(1001, 2688), ffi.string(patchbuf[j].installedversion))
					end
				end
			elseif not C.AreConstructionPlanLoadoutsCompatible(id) then
				mouseovertext = ReadText(1026, 7929)
			else
				local result = ffi.string(C.GetMissingConstructionPlanBlueprints3(menu.container, 0, id, false))
				active = result == ""
				if menu.set == "headquarters_player" then
					local macros = { "landmarks_player_hq_01_research_macro" }
					local hasmacros = Helper.textArrayHelper(macros, function (numtexts, texts) return C.CheckConstructionPlanForMacros(id, texts, numtexts) end)
					active = active and hasmacros
					if not hasmacros then
						mouseovertext = ReadText(1026, 7919)
					end
				end
				local missingmacros = {}
				if (not active) and (string.find(result, "error") ~= 1) then
					for macro in string.gmatch(result, "([^;]+);") do
						missingmacros[macro] = true
					end
				end
				local missingmacronames = {}
				for macro, v in pairs(missingmacros) do
					table.insert(missingmacronames, GetMacroData(macro, "name"))
				end
				table.sort(missingmacronames)
				local blueprinttext = ""
				for _, name in ipairs(missingmacronames) do
					blueprinttext = blueprinttext .. "\n· " .. name
				end

				local hasmissinglimitedmodules = false
				local limitedmoduletext = ""
				local n = C.GetNumPlannedLimitedModules(id)
				local macrocounts = ffi.new("UIMacroCount[?]", n)
				n = C.GetPlannedLimitedModules(macrocounts, n, id)
				for j = 0, n - 1 do
					local macro = ffi.string(macrocounts[j].macro)
					local ware = GetMacroData(macro, "ware")
					if macrocounts[j].amount > OnlineGetUserItemAmount(ware) - (menu.externalUsedLimitedModules[macro] or 0) then
						active = false
						hasmissinglimitedmodules = true
						limitedmoduletext = limitedmoduletext .. "\n· " .. GetMacroData(macro, "name")
					end
				end

				if (not active) and (mouseovertext == nil) then
					mouseovertext = ReadText(1026, 7912) .. blueprinttext .. (hasmissinglimitedmodules and ("\n" .. ReadText(1026, 7915) .. limitedmoduletext) or "")
				end
			end

			table.insert(menu.constructionplans, { id = id, name = ffi.string(buf[i].name), source = source, deleteable = buf[i].deleteable, active = active, mouseovertext = mouseovertext })
			menu.constructionplansbyID[id] = { name = ffi.string(buf[i].name), source = source }
		end
	end
end

function menu.getImportablePlans()
	menu.importableplans = {}
	menu.importableplansbyfile = {}
	local n = C.GetNumImportableConstructionPlans()
	local buf = ffi.new("UIConstructionPlanInfo[?]", n)
	n = C.GetImportableConstructionPlans(buf, n)
	for i = 0, n - 1 do
		local filename = ffi.string(buf[i].filename)
		local id = ffi.string(buf[i].id)
		local name = ffi.string(buf[i].name)

		table.insert(menu.importableplans, { id = id, name = name, filename = filename, imported = menu.constructionplansbyID[id] ~= nil })
		menu.importableplansbyfile[filename] = { id = id, name = name }
	end
	table.sort(menu.importableplans, Helper.sortName)
end

function menu.createTitleBar(frame)
	menu.updateConstructionPlans()
	menu.getImportablePlans()

	local ftable = frame:addTable(9, { tabOrder = 5, height = 0, x = menu.titleData.offsetX, y = menu.titleData.offsetY, scaling = false, reserveScrollBar = false })
	ftable:setColWidth(1, menu.titleData.nameWidth)
	ftable:setColWidth(2, menu.titleData.dropdownWidth)
	ftable:setColWidth(3, menu.titleData.height)
	ftable:setColWidth(4, menu.titleData.height)
	ftable:setColWidth(5, menu.titleData.height)
	ftable:setColWidth(6, menu.titleData.height)
	ftable:setColWidth(7, menu.titleData.height)
	ftable:setColWidth(8, menu.titleData.height)
	ftable:setColWidth(9, menu.titleData.height)

	local row = ftable:addRow(true, { fixed = true, bgColor = Color["row_background_blue"] })
	if not menu.loadoutMode then
		-- name
		row[1]:createEditBox({ scaling = true }):setText(ffi.string(C.GetComponentName(menu.container)), { halign = "center", font = Helper.headerRow1Font, fontsize = Helper.headerRow1FontSize })
		row[1].handlers.onEditBoxDeactivated = menu.editboxNameUpdateText
		-- load
		local loadOptions = {}
		for _, plan in ipairs(menu.constructionplans) do
			table.insert(loadOptions, { id = plan.id, text = plan.name, icon = "", displayremoveoption = plan.deleteable, active = plan.active, mouseovertext = plan.mouseovertext })
		end
		table.sort(loadOptions, function (a, b) return a.text < b.text end)
		row[2]:createDropDown(loadOptions, { textOverride = ReadText(1001, 7904), optionWidth = menu.titleData.dropdownWidth + menu.titleData.height + Helper.borderSize }):setTextProperties(config.dropDownTextProperties)
		row[2].handlers.onDropDownConfirmed = menu.dropdownLoad
		row[2].handlers.onDropDownRemoved = menu.dropdownRemovedCP
		-- save
		row[3]:createButton({ helpOverlayID = "save_constructionplan", helpOverlayText = " ", helpOverlayHighlightOnly = true, active = true, height = menu.titleData.height, mouseOverText = ReadText(1026, 7901) }):setIcon("menu_save")
		row[3].handlers.onClick = menu.buttonTitleSave
		-- Import
		row[4]:createButton({ helpOverlayID = "import_constructionplan", helpOverlayText = " ", helpOverlayHighlightOnly = true, active = true, height = menu.titleData.height, mouseOverText = ReadText(1026, 7916) }):setIcon("menu_import")
		row[4].handlers.onClick = menu.buttonTitleImport
		-- Export
		row[5]:createButton({ helpOverlayID = "export_constructionplan", helpOverlayText = " ", helpOverlayHighlightOnly = true, active = true, height = menu.titleData.height, mouseOverText = ReadText(1026, 7917) }):setIcon("menu_export")
		row[5].handlers.onClick = menu.buttonTitleExport
		-- reset camera
		row[6]:createButton({ helpOverlayID = "reset_topview", helpOverlayText = " ", helpOverlayHighlightOnly = true, active = true, height = menu.titleData.height, mouseOverText = ffi.string(C.ConvertInputString(ReadText(1026, 7911), ReadText(1026, 7902))) }):setIcon("menu_reset_view"):setHotkey("INPUT_STATE_DETAILMONITOR_RESET_VIEW", { displayIcon = false })
		row[6].handlers.onClick = function () return C.ResetMapPlayerRotation(menu.holomap) end
		-- undo
		menu.canundo = false
		if menu.holomap and (menu.holomap ~= 0) then
			menu.canundo = C.CanUndoConstructionMapChange(menu.holomap)
		end
		row[7]:createButton({ helpOverlayID = "undo_constructionplan", helpOverlayText = " ", helpOverlayHighlightOnly = true, active = menu.canundo, height = menu.titleData.height, mouseOverText = ReadText(1026, 7903) .. Helper.formatOptionalShortcut(" (%s)", "action", 278) }):setIcon("menu_undo")
		row[7].handlers.onClick = function () return menu.undoHelper(true) end
		-- redo
		menu.canredo = false
		if menu.holomap and (menu.holomap ~= 0) then
			menu.canredo = C.CanRedoConstructionMapChange(menu.holomap)
		end
		row[8]:createButton({ helpOverlayID = "redo_constructionplan", helpOverlayText = " ", helpOverlayHighlightOnly = true, active = menu.canredo, height = menu.titleData.height, mouseOverText = ReadText(1026, 7904) .. Helper.formatOptionalShortcut(" (%s)", "action", 279) }):setIcon("menu_redo")
		row[8].handlers.onClick = function () return menu.undoHelper(false) end
		-- settings
		row[9]:createButton({ helpOverlayID = "settings", helpOverlayText = " ", helpOverlayHighlightOnly = true, active = true, height = menu.titleData.height }):setIcon("menu_options")
		row[9].handlers.onClick = menu.buttonTitleSettings
	else
		-- name
		row[1]:createEditBox({ scaling = true }):setText(ffi.string(C.GetComponentName(menu.container)), { halign = "center", font = Helper.headerRow1Font, fontsize = Helper.headerRow1FontSize })
		row[1].handlers.onEditBoxDeactivated = menu.editboxNameUpdateText
		-- load
		local loadoutOptions = {}
		if next(menu.loadouts) then
			for _, loadout in ipairs(menu.loadouts) do
				table.insert(loadoutOptions, { id = loadout.id, text = loadout.name, icon = "", displayremoveoption = loadout.deleteable, active = loadout.active, mouseovertext = loadout.mouseovertext })
			end
		end
		row[2]:setColSpan(6):createDropDown(loadoutOptions, { textOverride = ReadText(1001, 7905), optionWidth = menu.titleData.dropdownWidth + 6 * (menu.titleData.height + Helper.borderSize) }):setTextProperties(config.dropDownTextProperties)
		row[2].handlers.onDropDownConfirmed = menu.dropdownLoadout
		row[2].handlers.onDropDownRemoved = menu.dropdownRemovedLoadout
		-- save
		row[8]:createButton({ helpOverlayID = "save_loadout", helpOverlayText = " ", helpOverlayHighlightOnly = true, active = true, height = menu.titleData.height, mouseOverText = ReadText(1026, 7905) }):setIcon("menu_save")
		row[8].handlers.onClick = menu.buttonTitleSaveLoadout
		-- reset camera
		row[9]:createButton({ helpOverlayID = "reset_topview", helpOverlayText = " ", helpOverlayHighlightOnly = true, active = true, height = menu.titleData.height, mouseOverText = ffi.string(C.ConvertInputString(ReadText(1026, 7911), ReadText(1026, 7902))) }):setIcon("menu_reset_view"):setHotkey("INPUT_STATE_DETAILMONITOR_RESET_VIEW", { displayIcon = false })
		row[9].handlers.onClick = function () return C.ResetMapPlayerRotation(menu.holomap) end
	end
end

function menu.refreshTitleBar()
	local text = {
		alignment = "center",
		fontname = Helper.standardFont,
		fontsize = Helper.scaleFont(Helper.standardFont, Helper.standardFontSize),
		color = Color["text_normal"],
		x = 0,
		y = 0
	}

	menu.updateConstructionPlans()
	menu.getImportablePlans()

	if not menu.loadoutMode then
		text.override = ReadText(1001, 7904)
		local loadOptions = {}
		for _, plan in ipairs(menu.constructionplans) do
			table.insert(loadOptions, { id = plan.id, text = plan.name, icon = "", displayremoveoption = plan.deleteable, active = plan.active, mouseovertext = plan.mouseovertext })
		end
		table.sort(loadOptions, function (a, b) return a.text < b.text end)

		-- editbox
		local desc = Helper.createEditBox(Helper.createTextInfo(ffi.string(C.GetComponentName(menu.container)), "center", Helper.headerRow1Font, Helper.scaleFont(Helper.headerRow1Font, Helper.headerRow1FontSize), 255, 255, 255, 100), true, 0, 0, 0, 0, nil, nil, false)
		Helper.setCellContent(menu, menu.titlebartable, desc, 1, 1, nil, "editbox", nil, menu.editboxNameUpdateText)
		-- dropdown
		local desc = Helper.createDropDown(loadOptions, "", text, nil, true, true, 0, 0, 0, 0, nil, nil, "", menu.titleData.dropdownWidth + menu.titleData.height + Helper.borderSize)
		Helper.setCellContent(menu, menu.titlebartable, desc, 1, 2, nil, "dropdown", nil, nil, menu.dropdownLoad, menu.dropdownRemovedCP)
		-- save
		local desc = Helper.createButton(nil, Helper.createButtonIcon("menu_save", nil, 255, 255, 255, 100), true, true, 0, 0, 0, menu.titleData.height, nil, nil, nil, ReadText(1026, 7901))
		Helper.setCellContent(menu, menu.titlebartable, desc, 1, 3, nil, "button", nil, menu.buttonTitleSave)
	else
		text.override = ReadText(1001, 7905)
		local loadoutOptions = {}
		if next(menu.loadouts) then
			for _, loadout in ipairs(menu.loadouts) do
				table.insert(loadoutOptions, { id = loadout.id, text = loadout.name, icon = "", displayremoveoption = loadout.deleteable, active = loadout.active, mouseovertext = loadout.mouseovertext })
			end
		end

		-- editbox
		local desc = Helper.createEditBox(Helper.createTextInfo(ffi.string(C.GetComponentName(menu.container)), "center", Helper.headerRow1Font, Helper.scaleFont(Helper.headerRow1Font, Helper.headerRow1FontSize), 255, 255, 255, 100), true, 0, 0, 0, 0, nil, nil, false)
		Helper.setCellContent(menu, menu.titlebartable, desc, 1, 1, nil, "editbox", nil, menu.editboxNameUpdateText)
		-- dropdown
		local desc = Helper.createDropDown(loadoutOptions, "", text, nil, true, next(menu.loadouts) ~= nil, 0, 0, 0, 0, nil, nil, "", menu.titleData.dropdownWidth + 4 * (menu.titleData.height + Helper.borderSize))
		Helper.setCellContent(menu, menu.titlebartable, desc, 1, 2, nil, "dropdown", nil, nil, menu.dropdownLoadout, menu.dropdownRemovedLoadout)
		-- save
		local desc = Helper.createButton(nil, Helper.createButtonIcon("menu_save", nil, 255, 255, 255, 100), true, true, 0, 0, 0, menu.titleData.height, nil, nil, nil, ReadText(1026, 7905))
		Helper.setCellContent(menu, menu.titlebartable, desc, 1, 8, nil, "button", nil, menu.buttonTitleSaveLoadout)
	end
end

function menu.getPresetLoadouts()
	-- presets
	menu.loadouts = {}

	local currentmacro = (menu.loadoutModule.macro ~= "") and menu.loadoutModule.macro or GetComponentData(ConvertStringTo64Bit(tostring(menu.loadoutModule.component)), "macro")
	local n = C.GetNumLoadoutsInfo(menu.loadoutModule.component, menu.loadoutModule.macro)
	local buf = ffi.new("UILoadoutInfo[?]", n)
	n = C.GetLoadoutsInfo(buf, n, menu.loadoutModule.component, menu.loadoutModule.macro)
	for i = 0, n - 1 do
		local id = ffi.string(buf[i].id)
		local active = false
		local mouseovertext = ""
		local numinvalidpatches = ffi.new("uint32_t[?]", 1)
		if not C.IsLoadoutValid(0, menu.loadoutModule.macro, id, numinvalidpatches) then
			local numpatches = numinvalidpatches[0]
			local patchbuf = ffi.new("InvalidPatchInfo[?]", numpatches)
			numpatches = C.GetLoadoutInvalidPatches(patchbuf, numpatches, 0, menu.loadoutModule.macro, id)
			mouseovertext = ReadText(1001, 2685) .. ReadText(1001, 120)			-- Missing, old or disabled extensions:
			for j = 0, numpatches - 1 do
				if j > 3 then
					mouseovertext = mouseovertext .. "\n- ..."
					break
				end
				mouseovertext = mouseovertext .. "\n- " .. ffi.string(patchbuf[j].name) .. " (" .. ffi.string(patchbuf[j].id) .. " - " .. ffi.string(patchbuf[j].requiredversion) .. ")"
				if patchbuf[j].state == 2 then
					mouseovertext = mouseovertext .. " " .. ReadText(1001, 2686)
				elseif patchbuf[j].state == 3 then
					mouseovertext = mouseovertext .. " " .. ReadText(1001, 2687)
				elseif patchbuf[j].state == 4 then
					mouseovertext = mouseovertext .. " " .. string.format(ReadText(1001, 2688), ffi.string(patchbuf[j].installedversion))
				end
			end
		elseif not C.IsLoadoutCompatible(currentmacro, id) then
			mouseovertext = ReadText(1026, 8024)
		else
			active = C.CanBuildLoadout(menu.buildstorage, 0, menu.loadoutModule.macro, id)
			if not active then
				mouseovertext = ReadText(1026, 8011)
			end
		end

		table.insert(menu.loadouts, { id = id, name = ffi.string(buf[i].name), icon = ffi.string(buf[i].iconid), deleteable = buf[i].deleteable, active = active, mouseovertext = mouseovertext })
	end
	table.sort(menu.loadouts, function (a, b) return a.name < b.name end)
	table.insert(menu.loadouts, 1, { id = "empty", name = ReadText(1001, 7990), icon = "", deleteable = false, preset = 0 })
	table.insert(menu.loadouts, 2, { id = "low", name = ReadText(1001, 7910), icon = "", deleteable = false, preset = 0.1 })
	table.insert(menu.loadouts, 3, { id = "medium", name = ReadText(1001, 7911), icon = "", deleteable = false, preset = 0.5 })
	table.insert(menu.loadouts, 4, { id = "high", name = ReadText(1001, 7912), icon = "", deleteable = false, preset = 1.0 })
end

function menu.getUpgradeData(upgradeplan)
	-- get preset loadouts
	menu.getPresetLoadouts()

	-- init upgradeplan
	menu.constructionplan[menu.loadoutMode].upgradeplan = {}
	for _, upgradetype in ipairs(Helper.upgradetypes) do
		menu.constructionplan[menu.loadoutMode].upgradeplan[upgradetype.type] = {}
	end

	-- assemble available slots/ammo/software
	menu.slots = {}
	if menu.loadoutModule.component ~= 0 then
		for i, upgradetype in ipairs(Helper.upgradetypes) do
			if upgradetype.supertype == "macro" then
				menu.slots[upgradetype.type] = {}
				for j = 1, tonumber(C.GetNumUpgradeSlots(menu.loadoutModule.component, "", upgradetype.type)) do
					-- convert index from lua to C-style
					menu.slots[upgradetype.type][j] = { currentmacro = ffi.string(C.GetUpgradeSlotCurrentMacro(menu.container, menu.loadoutModule.component, upgradetype.type, j)), possiblemacros = {} }
					menu.constructionplan[menu.loadoutMode].upgradeplan[upgradetype.type][j] = menu.slots[upgradetype.type][j].currentmacro
				end
			end
		end
	else
		for i, upgradetype in ipairs(Helper.upgradetypes) do
			if upgradetype.supertype == "macro" then
				menu.slots[upgradetype.type] = {}
				for j = 1, tonumber(C.GetNumUpgradeSlots(0, menu.loadoutModule.macro, upgradetype.type)) do
					-- convert index from lua to C-style
					menu.slots[upgradetype.type][j] = { currentmacro = "", possiblemacros = {} }
					menu.constructionplan[menu.loadoutMode].upgradeplan[upgradetype.type][j] = ""
				end
			end
		end
	end

	menu.groups = {}
	local n = C.GetNumUpgradeGroups(menu.loadoutModule.component, menu.loadoutModule.macro)
	local buf = ffi.new("UpgradeGroup[?]", n)
	n = C.GetUpgradeGroups(buf, n, menu.loadoutModule.component, menu.loadoutModule.macro)
	for i = 0, n - 1 do
		table.insert(menu.groups, { path = ffi.string(buf[i].path), group = ffi.string(buf[i].group) })
		local group = menu.groups[#menu.groups]
		for j, upgradetype in ipairs(Helper.upgradetypes) do
			if upgradetype.supertype == "group" then
				local groupinfo = C.GetUpgradeGroupInfo(menu.loadoutModule.component, menu.loadoutModule.macro, group.path, group.group, upgradetype.grouptype)
				local slotsize = ffi.string(groupinfo.slotsize)

				local compatibilities
				local n_comp = C.GetNumUpgradeGroupCompatibilities(menu.loadoutModule.component, menu.loadoutModule.macro, 0, group.path, group.group, upgradetype.grouptype)
				if n_comp > 0 then
					compatibilities = {}
					local buf_comp = ffi.new("EquipmentCompatibilityInfo[?]", n)
					n_comp = C.GetUpgradeGroupCompatibilities(buf_comp, n_comp, menu.loadoutModule.component, menu.loadoutModule.macro, 0, group.path, group.group, upgradetype.grouptype)
					for k = 0, n_comp - 1 do
						compatibilities[ffi.string(buf_comp[k].tag)] = ffi.string(buf_comp[k].name)
					end
				end

				menu.groups[#menu.groups][upgradetype.grouptype] = { count = groupinfo.count, total = groupinfo.total, slotsize = slotsize, compatibilities = compatibilities, currentmacro = ffi.string(groupinfo.currentmacro), possiblemacros = {} }
				if upgradetype.grouptype ~= "shield" then
					menu.groups[#menu.groups].slotsize = slotsize
					menu.groups[#menu.groups].compatibilities = compatibilities
				end
				menu.constructionplan[menu.loadoutMode].upgradeplan[upgradetype.type][#menu.groups] = { macro = ffi.string(groupinfo.currentmacro), count = groupinfo.count, path = group.path, group = group.group }
			end
		end
	end

	-- assemble possible upgrades per slot
	for type, slots in pairs(menu.slots) do
		for i, slot in ipairs(slots) do
			local wares = menu.upgradewares[type] or {}
			for _, upgradeware in ipairs(wares) do
				if upgradeware.macro ~= "" then
					if C.IsUpgradeMacroCompatible(menu.container, menu.loadoutModule.component, menu.loadoutModule.macro, true, type, i, upgradeware.macro) then
						table.insert(slot.possiblemacros, upgradeware.macro)
					end
				end
			end
			table.sort(slot.possiblemacros, Helper.sortMacroRaceAndShortname)
		end
	end

	for i, group in ipairs(menu.groups) do
		for j, upgradetype in ipairs(Helper.upgradetypes) do
			if upgradetype.supertype == "group" then
				local wares = menu.upgradewares[upgradetype.grouptype] or {}
				for _, upgradeware in ipairs(wares) do
					if upgradeware.macro ~= "" then
						if C.IsUpgradeGroupMacroCompatible(menu.loadoutModule.component, menu.loadoutModule.macro, group.path, group.group, upgradetype.grouptype, upgradeware.macro) then
							table.insert(menu.groups[i][upgradetype.grouptype].possiblemacros, upgradeware.macro)
						end
					end
				end
				table.sort(menu.groups[i][upgradetype.grouptype].possiblemacros, Helper.sortMacroRaceAndShortname)
			end
		end
	end

	if upgradeplan then
		for type, upgradelist in pairs(menu.constructionplan[menu.loadoutMode].upgradeplan) do
			local upgradetype = Helper.findUpgradeType(type)
			for key, upgrade in pairs(upgradelist) do
				if upgradetype.supertype == "group" then
					local found = false
					for key2, upgrade2 in pairs(upgradeplan[type]) do
						if (upgrade2.path == upgrade.path) and (upgrade2.group == upgrade.group) then
							found = true
							menu.constructionplan[menu.loadoutMode].upgradeplan[type][key].macro = upgrade2.macro or ""
							menu.constructionplan[menu.loadoutMode].upgradeplan[type][key].count = upgrade2.count or 0
							break
						end
					end
					if not found then
						menu.constructionplan[menu.loadoutMode].upgradeplan[type][key].macro = ""
						menu.constructionplan[menu.loadoutMode].upgradeplan[type][key].count = 0
					end
				else
					menu.constructionplan[menu.loadoutMode].upgradeplan[type][key] = upgradeplan[type][key] or ""
				end
			end
		end
	end
end

function menu.ventureModuleUnavailableMouseOverText()
	local mouseovertext = ColorText["text_error"] .. ReadText(1026, 7913)
	if not C.IsVentureExtensionSupported() then
		mouseovertext = ColorText["text_error"] .. ReadText(1026, 7930)
	elseif not OnlineHasSession() then
		mouseovertext = mouseovertext .. "\n\n" .. ReadText(1026, 7921)
	end
	return mouseovertext
end

function menu.sortSlots(a, b)
	local asize = config.slotSizeOrder[a[4]] or 0
	local bsize = config.slotSizeOrder[b[4]] or 0
	if asize == bsize then
		return a[1] < b[1]
	end
	return asize < bsize
end

function menu.displayModules(frame, firsttime)
	if firsttime then
		AddUITriggeredEvent(menu.name, menu.modulesMode, "on")
	end

	local count, rowcount, slidercount = 1, 0, 0
	local hasventureplatform = false
	if not menu.loadoutMode then
		local modules = menu.modules[menu.modulesMode] or {}
		menu.groupedmodules = {}
		local ventureplatformmacros = {}
		for i, module in ipairs(modules) do
			if menu.modulesMode == "moduletypes_venture" then
				if IsMacroClass(module, "ventureplatform") then
					table.insert(ventureplatformmacros, module)
				end
			end

			if (#menu.modulesearchtext == 0) or menu.filterModuleByText(module, menu.modulesearchtext) then
				local group = math.ceil(count / 3)
				menu.groupedmodules[group] = menu.groupedmodules[group] or {}
				table.insert(menu.groupedmodules[group], module)
				count = count + 1
			end
		end

		for _, macro in ipairs(ventureplatformmacros) do
			if (menu.usedLimitedModules[macro] or 0) > 0 then
				hasventureplatform = true
				break
			end
		end
	else
		if menu.upgradetypeMode == "turretgroup" then
			local upgradegroup = menu.groups[menu.currentSlot]

			menu.groupedupgrades = {}
			for i, upgradetype in ipairs(Helper.upgradetypes) do
				local upgradegroupcount = 1
				if upgradetype.supertype == "group" then
					menu.groupedupgrades[upgradetype.grouptype] = {}
					if upgradegroup then
						for i, macro in ipairs(upgradegroup[upgradetype.grouptype].possiblemacros) do
							if (menu.searchtext == "") or menu.filterUpgradeByText(macro, menu.searchtext) then
								local group = math.ceil(upgradegroupcount / 3)
								menu.groupedupgrades[upgradetype.grouptype][group] = menu.groupedupgrades[upgradetype.grouptype][group] or {}
								table.insert(menu.groupedupgrades[upgradetype.grouptype][group], { macro = macro, icon = (C.IsIconValid("upgrade_" .. macro) and ("upgrade_" .. macro) or "upgrade_notfound"), name = GetMacroData(macro, "name") })
								upgradegroupcount = upgradegroupcount + 1
							end
						end
					end

					if upgradetype.allowempty then
						local group = math.ceil(upgradegroupcount / 3)
						menu.groupedupgrades[upgradetype.grouptype][group] = menu.groupedupgrades[upgradetype.grouptype][group] or {}
						table.insert(menu.groupedupgrades[upgradetype.grouptype][group], { macro = "", icon = "upgrade_empty", name = ReadText(1001, 7906), helpOverlayID = "upgrade_empty", helpOverlayText = " ", helpOverlayHighlightOnly = true })
						upgradegroupcount = upgradegroupcount + 1
					end
				end
				count = count + upgradegroupcount - 1
				if upgradegroupcount > 1 then
					slidercount = slidercount + 1
				end
				rowcount = rowcount + math.ceil((upgradegroupcount - 1) / 3)
			end
			count = count + 1
		end
	end
	count = count - 1

	local editboxheight = math.max(23, Helper.scaleY(Helper.standardTextHeight))

	if not menu.loadoutMode then
		if menu.modulesMode then
			local maxColumnWidth = math.floor((menu.modulesData.width - 2 * Helper.borderSize) / 3)
			local columnWidth = maxColumnWidth - math.floor(((count / 3 > 6) and Helper.scrollbarWidth or 0) / 3)

			local ftable = frame:addTable(5, { tabOrder = 1, width = menu.modulesData.width, height = 0, x = menu.modulesData.offsetX, y = menu.modulesData.offsetY, scaling = false, reserveScrollBar = false, highlightMode = "column", backgroundID = "solid", backgroundColor = Color["table_background_3d_editor"] })
			if menu.setdefaulttable then
				ftable.properties.defaultInteractiveObject = true
				menu.setdefaulttable = nil
			end
			ftable:setColWidth(1, columnWidth)
			ftable:setColWidth(2, columnWidth)
			ftable:setColWidth(4, editboxheight)
			ftable:setColWidth(5, editboxheight)
			ftable:setDefaultColSpan(3, 3)

			local name = menu.getLeftBarEntry(menu.modulesMode).name or ""
			local row = ftable:addRow(false, { fixed = true, bgColor = Color["row_title_background"] })
			row[1]:setColSpan(5):createText(name, menu.headerTextProperties)

			local rowy = ftable:getFullHeight()
			local row = ftable:addRow(true, { fixed = true, bgColor = Color["row_background_blue"] })
			row[1]:setColSpan(4):createEditBox({ defaultText = ReadText(1001, 3250), scaling = true }):setText("", { x = Helper.standardTextOffsetx }):setHotkey("INPUT_STATE_DETAILMONITOR_0", { displayIcon = true })
			row[1].handlers.onEditBoxDeactivated = menu.editboxModuleSearchUpdateText
			row[5]:createButton({ height = editboxheight }):setIcon("menu_filter")
			row[5].handlers.onClick = function () return menu.buttonModuleFilter(menu.modulesData.offsetY + rowy + Helper.borderSize) end

			local row = ftable:addRow((#menu.modulesearchtext > 0), { fixed = true })
			local searchindex = 0
			for i = 1, math.min(3, #menu.modulesearchtext) do
				local col = i
				searchindex = searchindex + 1
				local truncatedString = TruncateText(menu.modulesearchtext[i].text, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), row[col]:getWidth() - 2 * Helper.scaleX(10))
				row[col]:setColSpan(1):createButton({ scaling = true, height = Helper.standardTextHeight, mouseOverText = (truncatedString ~= menu.modulesearchtext[i].text) and menu.modulesearchtext[i].text or "" }):setText(truncatedString, { halign = "center" }):setText2("X", { halign = "right" })
				if menu.modulesearchtext[i].race then
					row[col]:setIcon("menu_filter", { width = Helper.standardTextHeight, height = Helper.standardTextHeight })
				end
				row[col].handlers.onClick = function () return menu.buttonRemoveSearchEntry(i) end
			end
			if #menu.modulesearchtext > 3 then
				row[4]:setColSpan(2):createText(string.format("%+d", #menu.modulesearchtext - 3), { scaling = true })
			end

			local row = ftable:addEmptyRow(editboxheight / 2)
			row.properties.fixed = true

			if next(menu.groupedmodules) then
				local storagecounter_solid, dockareacounter, storagecounter_container, counter_shipyard, counter_wharf, counter_pier, counter_struct = 0, 0, 0, 0, 0, 0, 0
				for _, group in ipairs(menu.groupedmodules) do
					local row = ftable:addRow(true, { borderBelow = false })
					local row2 = ftable:addRow(false, {  })
					for i = 1, 3 do
						if group[i] then
							local name, shortname, makericon, infolibrary, canclaimownership = GetMacroData(group[i], "name", "shortname", "makericon", "infolibrary", "canclaimownership")
							AddKnownItem(infolibrary, group[i])
							local icon = C.IsIconValid("module_" .. group[i]) and ("module_" .. group[i]) or "module_notfound"
							local active = true
							row[i]:createButton({ width = columnWidth, height = columnWidth, active = active, highlightColor = Color["button_highlight_bigbutton"], mouseOverText = name, helpOverlayID = "stationbuildst_" .. group[i], helpOverlayText = " ", helpOverlayHighlightOnly = true }):setIcon(icon)

							-- Tutorial solar panels (shared)
							if group[i] == "prod_gen_energycells_macro" then
								row[i].properties.helpOverlayID = "stationbuildst_production_energycells"
								row[i].properties.helpOverlayText = " "
								row[i].properties.helpOverlayHighlightOnly = true
							end

							-- Tutorial solid storage (any race)
							if	(group[i] == "storage_arg_s_solid_01_macro") or (group[i] == "storage_arg_m_solid_01_macro") or (group[i] == "storage_arg_l_solid_01_macro") or
								(group[i] == "storage_par_s_solid_01_macro") or (group[i] == "storage_par_m_solid_01_macro") or (group[i] == "storage_par_l_solid_01_macro") or
								(group[i] == "storage_spl_s_solid_01_macro") or (group[i] == "storage_spl_m_solid_01_macro") or (group[i] == "storage_spl_l_solid_01_macro") or
								(group[i] == "storage_tel_s_solid_01_macro") or (group[i] == "storage_tel_m_solid_01_macro") or (group[i] == "storage_tel_l_solid_01_macro") or
								(group[i] == "storage_ter_s_solid_01_macro") or (group[i] == "storage_ter_m_solid_01_macro") or (group[i] == "storage_ter_l_solid_01_macro")
							then
								storagecounter_solid = storagecounter_solid + 1
								row[i].properties.helpOverlayID = "stationbuildst_storage_solid" .. storagecounter_solid
								row[i].properties.helpOverlayText = " "
								row[i].properties.helpOverlayHighlightOnly = true
							end

							-- Tutorial container storage (any race)
							if	(group[i] == "storage_arg_s_container_01_macro") or (group[i] == "storage_arg_m_container_01_macro") or (group[i] == "storage_arg_l_container_01_macro") or
								(group[i] == "storage_par_s_container_01_macro") or (group[i] == "storage_par_m_container_01_macro") or (group[i] == "storage_par_l_container_01_macro") or
								(group[i] == "storage_spl_s_container_01_macro") or (group[i] == "storage_spl_m_container_01_macro") or (group[i] == "storage_spl_l_container_01_macro") or
								(group[i] == "storage_tel_s_container_01_macro") or (group[i] == "storage_tel_m_container_01_macro") or (group[i] == "storage_tel_l_container_01_macro") or
								(group[i] == "storage_ter_s_container_01_macro") or (group[i] == "storage_ter_m_container_01_macro") or (group[i] == "storage_ter_l_container_01_macro")
							then
								storagecounter_container = storagecounter_container + 1
								row[i].properties.helpOverlayID = "stationbuildst_storage_container" .. storagecounter_container
								row[i].properties.helpOverlayText = " "
								row[i].properties.helpOverlayHighlightOnly = true
							end

							-- Tutorial shipyard buildmodules
							if	(group[i] == "buildmodule_gen_ships_l_macro") or (group[i] == "buildmodule_gen_ships_xl_macro") or (group[i] == "buildmodule_ter_ships_l_macro") or (group[i] == "buildmodule_ter_ships_xl_macro")
							then
								counter_shipyard = counter_shipyard + 1
								row[i].properties.helpOverlayID = "stationbuildst_build_shipyard" .. counter_shipyard
								row[i].properties.helpOverlayText = " "
								row[i].properties.helpOverlayHighlightOnly = true
							end

							-- Tutorial wharf buildmodules
							if	(group[i] == "buildmodule_gen_ships_m_dockarea_01_macro") or (group[i] == "buildmodule_ter_ships_m_dockarea_01_macro")
							then
								counter_wharf = counter_wharf + 1
								row[i].properties.helpOverlayID = "stationbuildst_build_wharf" .. counter_wharf
								row[i].properties.helpOverlayText = " "
								row[i].properties.helpOverlayHighlightOnly = true
							end

							-- Tutorial Dockarea (any race)
							if	(group[i] == "dockarea_arg_m_station_01_hightech_macro") or (group[i] == "dockarea_arg_m_station_01_lowtech_macro") or (group[i] == "dockarea_arg_m_station_01_macro") or
								(group[i] == "dockarea_arg_m_station_02_hightech_macro") or (group[i] == "dockarea_arg_m_station_02_lowtech_macro") or (group[i] == "dockarea_arg_m_station_02_macro") or
								(group[i] == "dockarea_int_m_station_01_macro") or (group[i] == "dockarea_par_m_station_01_macro") or (group[i] == "dockarea_tel_m_station_01_macro") or (group[i] == "dockarea_ter_m_station_01_hightech_macro")
							then
								dockareacounter = dockareacounter + 1
								row[i].properties.helpOverlayID = "stationbuildst_dock_dockarea" .. dockareacounter
								row[i].properties.helpOverlayText = " "
								row[i].properties.helpOverlayHighlightOnly = true
							end

							-- Tutorial Pier (any race)
							if	(group[i] == "pier_arg_harbor_01_macro") or (group[i] == "pier_arg_harbor_02_macro") or (group[i] == "pier_arg_harbor_03_macro") or
								(group[i] == "pier_par_harbor_01_macro") or (group[i] == "pier_par_harbor_02_macro") or (group[i] == "pier_par_harbor_03_macro") or
								(group[i] == "pier_spl_harbor_01_macro") or (group[i] == "pier_spl_harbor_02_macro") or (group[i] == "pier_spl_harbor_03_macro") or
								(group[i] == "pier_tel_harbor_01_macro") or (group[i] == "pier_tel_harbor_02_macro") or (group[i] == "pier_tel_harbor_03_macro") or
								(group[i] == "pier_ter_harbor_01_macro") or (group[i] == "pier_ter_harbor_02_macro") or (group[i] == "pier_ter_harbor_03_macro") or (group[i] == "pier_ter_harbor_04_macro")
							then
								counter_pier = counter_pier + 1
								row[i].properties.helpOverlayID = "stationbuildst_dock_pier" .. counter_pier
								row[i].properties.helpOverlayText = " "
								row[i].properties.helpOverlayHighlightOnly = true
							end

							-- Tutorial Connections (any race)
							if	(group[i] == "struct_arg_base_01_macro")		or (group[i] == "struct_arg_base_02_macro")		or (group[i] == "struct_arg_base_03_macro")		or
								(group[i] == "struct_arg_cross_01_macro")		or (group[i] == "struct_arg_vertical_01_macro") or (group[i] == "struct_arg_vertical_02_macro") or
								(group[i] == "struct_par_base_01_macro")		or (group[i] == "struct_par_base_02_macro")		or (group[i] == "struct_par_base_03_macro")		or
								(group[i] == "struct_par_cross_01_macro")		or (group[i] == "struct_par_cross_02_macro")	or (group[i] == "struct_par_cross_03_macro")	or
								(group[i] == "struct_par_vertical_01_macro")	or (group[i] == "struct_spl_base_01_macro")		or (group[i] == "struct_spl_base_02_macro")		or
								(group[i] == "struct_spl_base_03_macro")		or (group[i] == "struct_spl_cross_01_macro")	or (group[i] == "struct_spl_vertical_01_macro") or
								(group[i] == "struct_spl_vertical_02_macro")	or (group[i] == "struct_tel_base_01_macro")		or (group[i] == "struct_tel_base_02_macro")		or
								(group[i] == "struct_tel_base_03_macro")		or (group[i] == "struct_tel_cross_01_macro")	or (group[i] == "struct_tel_vertical_01_macro") or
								(group[i] == "struct_tel_vertical_02_macro")	or (group[i] == "struct_ter_base_01_macro")		or (group[i] == "struct_ter_base_02_macro")		or
								(group[i] == "struct_ter_base_03_macro")		or (group[i] == "struct_ter_cross_01_macro")	or (group[i] == "struct_ter_vertical_01_macro") or
								(group[i] == "struct_ter_vertical_02_macro")
							then
								counter_struct = counter_struct + 1
								row[i].properties.helpOverlayID = "stationbuildst_other_struct" .. counter_struct
								row[i].properties.helpOverlayText = " "
								row[i].properties.helpOverlayHighlightOnly = true
							end

							if menu.modulesMode == "moduletypes_production" then
								local icon = GetMacroData(group[i], "waregroupicon")
								if icon ~= "" then
									row[i]:setIcon2(icon, { color = Color["slider_value"] })
								end
							elseif (menu.modulesMode == "moduletypes_storage") or (menu.modulesMode == "moduletypes_habitation") then
								local icon = "be_upgrade_size_" .. GetMacroData(group[i], "size")
								row[i]:setIcon2(icon, { color = Color["slider_value"] })
							elseif canclaimownership then
								row[i]:setIcon2("be_upgrade_claiming", { color = Color["slider_value"] })
							end
							if #makericon > 0 then
								local makertext = ""
								for i, icon in ipairs(makericon) do
									makertext = makertext .. ((i == 1) and "" or "\n") .. "\27[" .. icon .. "]"
								end
								local fontsize = Helper.scaleFont(Helper.standardFont, Helper.largeIconFontSize)
								local y = columnWidth / 2 - Helper.scaleY(Helper.largeIconTextHeight) / 2 - Helper.configButtonBorderSize
								row[i]:setText(makertext, { y = y, halign = "right", color = Color["slider_value"], fontsize = fontsize })
							end
							if menu.modulesMode == "moduletypes_venture" then
								local amount
								local isventureplatform = IsMacroClass(group[i], "ventureplatform")
								if isventureplatform or IsMacroClass(group[i], "dockarea") then
									local ware = GetMacroData(group[i], "ware")
									amount = math.max(0, OnlineGetUserItemAmount(ware) - (menu.externalUsedLimitedModules[group[i]] or 0) - (menu.usedLimitedModules[group[i]] or 0))
								end
								row[i]:setText2(amount and (ReadText(1001, 42) .. " " .. amount) or "", { x = Helper.scaleX(Helper.configButtonBorderSize), y = - maxColumnWidth / 2 + Helper.standardTextHeight / 2 + Helper.configButtonBorderSize, halign = "right", fontsize = Helper.scaleFont(Helper.standardFont, Helper.headerRow1FontSize) })
								active = ((not amount) or (amount > 0)) and (isventureplatform or hasventureplatform)
								row[i].properties.active = active
								if not active then
									if (not isventureplatform) and (not hasventureplatform) then
										row[i].properties.mouseOverText = name .. "\n\n" .. ReadText(1026, 7931)
									else
										row[i].properties.mouseOverText = name .. "\n\n" .. menu.ventureModuleUnavailableMouseOverText()
									end
								else
									if not isventureplatform then
										row[i].properties.mouseOverText = name .. "\n\n" .. ReadText(1026, 7922)
									end
								end
							end
							row[i].handlers.onClick = function () return menu.buttonAddModule(group[i], row.index, i) end
							if group[i] ~= "" then
								row[i].handlers.onRightClick = function (...) return menu.buttonInteract({ type = "module", name = GetMacroData(group[i], "name"), macro = group[i] }, ...) end
							end
							local extraText = TruncateText(shortname, Helper.standardFont, menu.extraFontSize, columnWidth - 2 * Helper.borderSize)
							row2[i]:createBoxText(extraText, { width = columnWidth, fontsize = menu.extraFontSize, boxColor = active and Color["button_background_default"] or Color["button_background_inactive"], mouseOverText = name })
						end
					end
				end
			end

			ftable:setTopRow(menu.topRows.modules)
			ftable:setSelectedRow(menu.selectedRows.modules)
			ftable:setSelectedCol(menu.selectedCols.modules or 0)
		end
		menu.topRows.modules = nil
		menu.selectedRows.modules = nil
		menu.selectedCols.modules = nil
	else
		if menu.upgradetypeMode then
			local upgradetype = Helper.findUpgradeType(menu.upgradetypeMode)
			local currentSlotInfo = {}

			if menu.upgradetypeMode == "turretgroup" then
				local groupcount = 1
				local sizecounts = {}
				local groupedslots = {}
				for i, upgradegroup in ipairs(menu.groups) do
					local groupname = groupcount
					local slotsize = upgradegroup[upgradetype.grouptype].slotsize
					if slotsize ~= "" then
						if sizecounts[slotsize] then
							sizecounts[slotsize] = sizecounts[slotsize] + 1
						else
							sizecounts[slotsize] = 1
						end
						groupname = upgradetype.shorttext[slotsize] .. sizecounts[slotsize]
					end

					local compatibilities = upgradegroup[upgradetype.grouptype].compatibilities

					if i == menu.currentSlot then
						currentSlotInfo.slotsize = slotsize
						currentSlotInfo.compatibilities = compatibilities
					end

					table.insert(groupedslots, { i, upgradegroup, groupname, slotsize, compatibilities = compatibilities })
					groupcount = groupcount + 1
				end
				table.sort(groupedslots, menu.sortSlots)
				menu.groupedslots = {}
				for i, entry in ipairs(groupedslots) do
					local group = math.ceil(i / 9)
					menu.groupedslots[group] = menu.groupedslots[group] or {}
					table.insert(menu.groupedslots[group], entry)
				end
			end
			
			menu.rowHeight = math.max(23, Helper.scaleY(Helper.standardTextHeight))
			menu.extraFontSize = Helper.scaleFont(Helper.standardFont, Helper.standardFontSize)
			local maxSlotWidth = math.floor((menu.modulesData.width - 8 * Helper.borderSize) / 9)

			local hasScrollbar = false
			local headerHeight = menu.titleData.height + #menu.groupedslots * (maxSlotWidth + Helper.borderSize) + menu.rowHeight + 2 * Helper.borderSize
			local boxTextHeight = math.ceil(C.GetTextHeight(" \n ", Helper.standardFont, menu.extraFontSize, 0)) + 2 * Helper.borderSize
			--[[ Keep for simpler debugging
				print((Helper.viewHeight - 2 * menu.slotData.offsetY) .. " vs " .. (headerHeight + rowcount * (3 * (maxSlotWidth + Helper.borderSize) + boxTextHeight) + slidercount * (menu.subHeaderRowHeight + Helper.borderSize)))
				print(headerHeight)
				print(boxTextHeight)
				print(rowcount .. " * " .. 3 * (maxSlotWidth + Helper.borderSize))
				print(slidercount .. " * " .. menu.subHeaderRowHeight + Helper.borderSize) --]]
			if (Helper.viewHeight - 2 * menu.modulesData.offsetY) < (headerHeight + rowcount * (3 * (maxSlotWidth + Helper.borderSize) + boxTextHeight) + slidercount * (menu.subHeaderRowHeight + Helper.borderSize)) then
				hasScrollbar = true
			end

			local slotWidth = maxSlotWidth - math.floor((hasScrollbar and Helper.scrollbarWidth or 0) / 9)
			local extraPixels = (menu.modulesData.width - 8 * Helper.borderSize) % 9
			local slotWidths = { slotWidth, slotWidth, slotWidth, slotWidth, slotWidth, slotWidth, slotWidth, slotWidth, slotWidth }
			if extraPixels > 0 then
				for i = 1, extraPixels do
					slotWidths[i] = slotWidths[i] + 1
				end
			end
			local columnWidths = {}
			local maxColumnWidth = 0
			for i = 1, 3 do
				columnWidths[i] = slotWidths[(i - 1) * 3 + 1] + slotWidths[(i - 1) * 3 + 2] + slotWidths[(i - 1) * 3 + 3] + 2 * Helper.borderSize
				maxColumnWidth = math.max(maxColumnWidth, columnWidths[i])
			end
			local slidercellWidth = menu.modulesData.width - math.floor(hasScrollbar and Helper.scrollbarWidth or 0)

			local ftable = frame:addTable(10, { tabOrder = 1, width = menu.modulesData.width, height = 0, x = menu.modulesData.offsetX, y = menu.modulesData.offsetY, scaling = false, reserveScrollBar = false, highlightMode = "column", backgroundID = "solid", backgroundColor = Color["table_background_3d_editor"] })
			if menu.setdefaulttable then
				ftable.properties.defaultInteractiveObject = true
				menu.setdefaulttable = nil
			end
			for i = 1, 8 do
				ftable:setColWidth(i, slotWidths[i])
			end
			ftable:setColWidth(10, editboxheight)
			ftable:setDefaultColSpan(1, 3)
			ftable:setDefaultColSpan(4, 3)
			ftable:setDefaultColSpan(7, 4)

			local name = menu.getLeftBarLoadoutEntry(menu.upgradetypeMode).name or ""
			local row = ftable:addRow(false, { fixed = true, bgColor = Color["row_title_background"] })
			row[1]:setColSpan(10):createText(name, menu.headerTextProperties)

			for _, group in ipairs(menu.groupedslots) do
				local row = ftable:addRow(true, {  })
				for i = 1, 9 do
					if group[i] then
						local colspan = (i == 9) and 2 or 1

						local bgcolor = Color["row_title_background"]
						if group[i][1] == menu.currentSlot then
							bgcolor = Color["row_background_selected"]
						end

						local count, total = 0, 0
						if menu.upgradetypeMode == "turretgroup" then
							for _, upgradetype2 in ipairs(Helper.upgradetypes) do
								if upgradetype2.supertype == "group" then
									if menu.groups[group[i][1]][upgradetype2.grouptype].total > 0 then
										if upgradetype2.mergeslots then
											count = count + ((menu.constructionplan[menu.loadoutMode].upgradeplan[upgradetype2.type][group[i][1]].count > 0) and 1 or 0)
											total = total + 1
										else
											count = count + menu.constructionplan[menu.loadoutMode].upgradeplan[upgradetype2.type][group[i][1]].count
											total = total + menu.groups[group[i][1]][upgradetype2.grouptype].total
										end
									end
								end
							end
						end

						local mouseovertext = ""
						if upgradetype then
							mouseovertext = ReadText(1001, 66) .. " " .. group[i][1]
						else
							mouseovertext = ReadText(1001, 8023) .. " " .. group[i][1]
						end

						row[i]:setColSpan(colspan):createButton({ height = slotWidths[i], bgColor = bgcolor, mouseOverText = mouseovertext, width = slotWidths[i] }):setText(group[i][3], { halign = "center", fontsize = Helper.scaleFont(Helper.standardFont, Helper.standardFontSize) })
						if total > 0 then
							local width = math.max(1, math.floor(count * (slotWidths[i] - 2 * menu.scaleSize) / total))
							row[i]:setIcon("solid", { width = width + 2 * Helper.configButtonBorderSize, height = menu.scaleSize + 2 * Helper.configButtonBorderSize, x = menu.scaleSize - Helper.configButtonBorderSize, y = slotWidths[i] - 2 * menu.scaleSize - Helper.configButtonBorderSize })
						end
						if group[i].compatibilities then
							local compatibilitytext = ""
							local j = 0
							for _, entry in ipairs(Helper.equipmentCompatibilities) do
								if group[i].compatibilities[entry.tag] then
									compatibilitytext = compatibilitytext .. " " .. Helper.convertColorToText(entry.color) .. "\27[menu_weaponslot]"
									j = j + 1
								end
								if (j > 0) and (j % 4 == 0) then
									compatibilitytext = compatibilitytext .. "\n"
								end
							end
							-- slotwidth is based on Helper.viewWidth but limited, so we need to reflect that here
							local fontsize = math.floor(config.compatibilityFontSize * Helper.viewWidth / 1920)
							local reservedSidePanelWidth = math.floor(0.25 * Helper.viewWidth)
							local actualSidePanelWidth = math.min(reservedSidePanelWidth, Helper.scaleX(config.maxSidePanelWidth))
							fontsize = fontsize * actualSidePanelWidth / reservedSidePanelWidth

							local compatibilityTextHeight = math.ceil(C.GetTextHeight(compatibilitytext, Helper.standardFont, fontsize, 0)) + 2 * Helper.borderSize
							row[i]:setText2(compatibilitytext, { halign = "center", fontsize = fontsize, y = (slotWidths[i] - compatibilityTextHeight) / 2 })
						end
						row[i].handlers.onClick = function () return menu.buttonSelectSlot(group[i][1], row.index, i) end
					end
				end
			end

			if currentSlotInfo.compatibilities then
				local row = ftable:addRow(nil, { fixed = true, scaling = true })
				row[1]:setBackgroundColSpan(10):setColSpan(5):createText(ReadText(1001, 8548) .. ReadText(1001, 120))
				local compatibilitytext = ""
				for _, entry in ipairs(Helper.equipmentCompatibilities) do
					if currentSlotInfo.compatibilities[entry.tag] then
						compatibilitytext = compatibilitytext .. " " .. Helper.convertColorToText(entry.color) .. currentSlotInfo.compatibilities[entry.tag]
					end
				end
				row[6]:setColSpan(5):createText(compatibilitytext, { halign = "right" })
			end

			if next(menu.groupedupgrades) then
				if menu.upgradetypeMode == "turretgroup" then
					for i, upgradetype in ipairs(Helper.upgradetypes) do
						if upgradetype.supertype == "group" then
							if menu.groups[menu.currentSlot] and (menu.groups[menu.currentSlot][upgradetype.grouptype].total > 0) then
								local plandata = menu.constructionplan[menu.loadoutMode].upgradeplan[upgradetype.type][menu.currentSlot]
								local slotsize = menu.groups[menu.currentSlot][upgradetype.grouptype].slotsize

								local name = upgradetype.headertext.default
								if slotsize ~= "" then
									name = upgradetype.headertext[slotsize]
								end

								local row = ftable:addRow(nil, { fixed = true, scaling = true })
								row[1]:setBackgroundColSpan(10):setColSpan(5):createText(name .. ReadText(1001, 120))
								row[6]:setColSpan(5):createText(plandata.count .. " / " .. menu.groups[menu.currentSlot][upgradetype.grouptype].total, { halign = "right" })
							end
						end
					end
				end
			end

			ftable:addEmptyRow(Helper.standardTextHeight / 2)

			local row = ftable:addRow(true, { fixed = true, bgColor = Color["row_background_blue"] })
			row[1]:setColSpan(9):createEditBox({ defaultText = ReadText(1001, 3250), scaling = true }):setText(menu.searchtext, { x = Helper.standardTextOffsetx }):setHotkey("INPUT_STATE_DETAILMONITOR_0", { displayIcon = true })
			row[1].handlers.onEditBoxDeactivated = menu.editboxSearchUpdateText
			row[10]:createButton({ height = editboxheight }):setText("X", { halign = "center", font = Helper.standardFontBold })
			row[10].handlers.onClick = function () return menu.buttonClearEditbox(row.index) end

			if next(menu.groupedupgrades) then
				if menu.upgradetypeMode == "turretgroup" then
					for i, upgradetype in ipairs(Helper.upgradetypes) do
						if upgradetype.supertype == "group" then
							if menu.groups[menu.currentSlot] and (menu.groups[menu.currentSlot][upgradetype.grouptype].total > 0) then
								local plandata = menu.constructionplan[menu.loadoutMode].upgradeplan[upgradetype.type][menu.currentSlot]
								local scale = {
									min       = 0,
									minSelect = (plandata.macro == "") and 0 or 1,
									max       = menu.groups[menu.currentSlot][upgradetype.grouptype].total,
								}
								scale.maxSelect = (plandata.macro == "") and 0 or scale.max
								scale.start = math.max(scale.minSelect, math.min(scale.maxSelect, plandata.count))

								local slotsize = menu.groups[menu.currentSlot][upgradetype.grouptype].slotsize

								local row = ftable:addRow(true, { bgColor = Color["row_background_blue"] })
								local name = upgradetype.text.default
								if plandata.macro == "" then
									if slotsize ~= "" then
										name = upgradetype.text[slotsize]
									end
								else
									name = GetMacroData(plandata.macro, "name")
								end

								local sizeicon
								if slotsize ~= "" then
									sizeicon = "be_upgrade_size_" .. slotsize
								end

								row[1]:setColSpan(10):createSliderCell({ width = slidercellWidth, height = Helper.headerRow1Height, valueColor = Color["slider_value"], min = scale.min, minSelect = scale.minSelect, max = scale.max, maxSelect = scale.maxSelect, start = scale.start }):setText(name, menu.slidercellTextProperties)
								row[1].handlers.onSliderCellChanged = function (_, ...) return menu.slidercellSelectAmount(upgradetype.type, menu.currentSlot, row.index, false, ...) end
								row[1].handlers.onSliderCellActivated = function() menu.noupdate = true end
								row[1].handlers.onSliderCellDeactivated = function() menu.noupdate = false end

								for _, group in ipairs(menu.groupedupgrades[upgradetype.grouptype]) do
									local row = ftable:addRow(true, { borderBelow = false })
									local row2 = ftable:addRow(false, {  })
									for i = 1, 3 do
										if group[i] then
											local installicon, installcolor = (group[i].macro ~= "") and (sizeicon or "") or ""
											if (group[i].macro ~= "") then
												if (group[i].macro == menu.groups[menu.currentSlot][upgradetype.grouptype].currentmacro) and (group[i].macro ~= plandata.macro) then
													installicon = "be_upgrade_uninstalled"
													installcolor = Color["text_negative"]
												elseif (group[i].macro == plandata.macro) then
													installicon = "be_upgrade_installed"
													installcolor = Color["text_positive"]
												end
											end

											local weaponicon, compatibility = GetMacroData(group[i].macro, "ammoicon", "compatibility")
											if weaponicon and (weaponicon ~= "") and C.IsIconValid(weaponicon) then
												weaponicon = "\27[" .. weaponicon .. "]"
											else
												weaponicon = ""
											end
											if compatibility then
												local color = Color["text_normal"]
												for _, entry in ipairs(Helper.equipmentCompatibilities) do
													if entry.tag == compatibility then
														color = entry.color
														break
													end
												end
												weaponicon = Helper.convertColorToText(color) .. "\27[menu_weaponmount]\27X" .. weaponicon
											end

											local extraText = ""
											local untruncatedExtraText = ""
											if group[i].macro ~= "" then
												local name, shortname, makerrace, infolibrary = GetMacroData(group[i].macro, "name", "shortname", "makerrace", "infolibrary")
												extraText = TruncateText(shortname, Helper.standardFont, menu.extraFontSize, columnWidths[i] - 2 * Helper.borderSize)
												untruncatedExtraText = name
												for i, racestring in ipairs(makerrace) do
													extraText = extraText .. ((i == 1) and "\n" or " - ") .. racestring
													if #makerrace > 1 then
														untruncatedExtraText = untruncatedExtraText .. ((i == 1) and "\n" or " - ") .. racestring
													end
												end
												AddKnownItem(infolibrary, group[i].macro)
											else
												local truncatedtext = TruncateText(group[i].name, Helper.standardFont, menu.extraFontSize, columnWidths[i] - 2 * Helper.borderSize)
												extraText = truncatedtext .. "\n"
												untruncatedExtraText = group[i].name
											end

											-- start: mycu callback
											if callbacks ["displayModules_on_before_create_button_mouseovertext"] then
												for _, callback in ipairs (callbacks ["displayModules_on_before_create_button_mouseovertext"]) do
													result = callback (group[i].macro, plandata.macro, untruncatedExtraText)
													if result then
														untruncatedExtraText = result.mouseovertext
													end
												end
											end
											-- end: mycu callback

											local column = i * 3 - 2
											row[column]:createButton({ width = columnWidths[i], height = maxColumnWidth, mouseOverText = untruncatedExtraText, helpOverlayID = "groupedslot_" .. group[i].macro, helpOverlayText = " ", helpOverlayHighlightOnly = true, uiTriggerID = "groupedslot_" .. group[i].macro }):setIcon(group[i].icon):setIcon2(installicon, { color = installcolor }):setText2(weaponicon, { x = 3, y = -maxColumnWidth / 2 + Helper.scaleY(Helper.standardTextHeight) / 2 + Helper.configButtonBorderSize, fontsize = Helper.scaleFont(Helper.standardFont, Helper.standardFontSize) })
											row[column].handlers.onClick = function () return menu.buttonSelectGroupUpgrade(upgradetype.type, menu.currentSlot, group[i].macro, row.index, column) end
											if group[i].macro ~= "" then
												row[column].handlers.onRightClick = function (...) return menu.buttonInteract({ type = upgradetype.type, name = group[i].name, macro = group[i].macro }, ...) end
											end
											row2[column]:createBoxText(extraText, { width = columnWidths[i], fontsize = menu.extraFontSize, mouseOverText = untruncatedExtraText })
										end
									end
								end
							end
						end
					end
				end
			end

			ftable:setTopRow(menu.topRows.modules)
			ftable:setSelectedRow(menu.selectedRows.modules)
			ftable:setSelectedCol(menu.selectedCols.modules or 0)
		end
		menu.topRows.modules = nil
		menu.selectedRows.modules = nil
		menu.selectedCols.modules = nil
	end
end

function menu.refreshPlan()
	-- do not refresh the plan while we are in loadout edit mode -> no construction map to get data from
	if not menu.loadoutMode then
		menu.neededresources = {}
		local numTotalResources = C.PrepareBuildSequenceResources2(menu.holomap, menu.container, true)
		if numTotalResources > 0 then
			local buf = ffi.new("UIWareInfo[?]", numTotalResources)
			numTotalResources = C.GetBuildSequenceResources(buf, numTotalResources)
			for i = 0, numTotalResources - 1 do
				table.insert(menu.neededresources, { ware = ffi.string(buf[i].ware), amount = buf[i].amount })
			end
		end
		table.sort(menu.neededresources, menu.wareNameSorter)

		menu.buildstorageresources = {}
		local n = C.GetNumCargo(menu.buildstorage, "stationbuilding")
		local buf = ffi.new("UIWareInfo[?]", n)
		n = C.GetCargo(buf, n, menu.buildstorage, "stationbuilding")
		for i = 0, n - 1 do
			table.insert(menu.buildstorageresources, { ware = ffi.string(buf[i].ware), amount = buf[i].amount })
		end

		C.PrepareBuildSequenceResources2(menu.holomap, menu.container, false)
		menu.constructionplan = {}
		menu.removedModules = {}
		if menu.holomap ~= 0 then
			local n = C.GetNumBuildMapConstructionPlan(menu.holomap, false)
			local buf = ffi.new("UIConstructionPlanEntry[?]", n)
			n = tonumber(C.GetBuildMapConstructionPlan(menu.holomap, menu.container, false, buf, n))
			for i = 0, n - 1 do
				local entry = {}
				entry.idx                   = buf[i].idx
				entry.macro                 = ffi.string(buf[i].macroid)
				entry.component             = buf[i].componentid
				entry.offset                = buf[i].offset
				entry.connection            = ffi.string(buf[i].connectionid)
				entry.predecessoridx        = buf[i].predecessoridx
				entry.predecessorconnection = ffi.string(buf[i].predecessorconnectionid)
				entry.isfixed               = buf[i].isfixed

				local loadout = Helper.getLoadoutHelper(C.GetConstructionMapItemLoadout2, C.GetConstructionMapItemLoadoutCounts2, menu.holomap, entry.idx, menu.container, entry.component)
				entry.upgradeplan           = Helper.convertLoadout(entry.component, entry.macro, loadout, nil)

				entry.resources = {}
				local numModuleResources = C. GetNumModuleNeededResources(menu.holomap, buf[i].idx)
				if numModuleResources > 0 then
					local resourceBuffer = ffi.new("UIWareInfo[?]", numModuleResources)
					numModuleResources = C.GetModuleNeededResources(resourceBuffer, numModuleResources, menu.holomap, buf[i].idx)
					for j = 0, numModuleResources - 1 do
						table.insert(entry.resources, { ware = ffi.string(resourceBuffer[j].ware), amount = resourceBuffer[j].amount })
					end
					table.sort(entry.resources, menu.wareNameSorter)
				end

				table.insert(menu.constructionplan, entry)
			end
			local newIndex = ffi.new("uint32_t[1]", 0)
			local numChangedIndices = ffi.new("uint32_t[1]", 0)
			local n = C.GetNumRemovedConstructionPlanModules2(menu.holomap, menu.container, newIndex, false, numChangedIndices, true)
			menu.newModulesIndex = tonumber(newIndex[0]) + 1
			menu.changedModulesIndices = {}
			local buf = ffi.new("UniverseID[?]", n)
			local changedIndicesBuf = ffi.new("uint32_t[?]", numChangedIndices[0])
			n = tonumber(C.GetRemovedConstructionPlanModules2(buf, n, changedIndicesBuf, numChangedIndices))
			if n > 0 then
				for i = 0, n - 1 do
					local compID = ConvertStringToLuaID(tostring(buf[i]))
					local loadout = Helper.getLoadoutHelper(C.GetCurrentLoadout, C.GetCurrentLoadoutCounts, menu.container, buf[i])

					local resources = {}
					local numModuleResources = C.GetNumModuleRecycledResources(buf[i])
					if numModuleResources > 0 then
						local resourceBuffer = ffi.new("UIWareInfo[?]", numModuleResources)
						numModuleResources = C.GetModuleRecycledResources(resourceBuffer, numModuleResources, buf[i])
						for j = 0, numModuleResources - 1 do
							table.insert(resources, { ware = ffi.string(resourceBuffer[j].ware), amount = -resourceBuffer[j].amount })
						end
						table.sort(resources, menu.wareNameSorter)
					end

					table.insert(menu.removedModules, { macro = GetComponentData(compID, "macro"), component = buf[i], upgradeplan = Helper.convertLoadout(buf[i], "", loadout, nil), resources = resources })
				end
			end
			if numChangedIndices[0] > 0 then
				for i = 0, numChangedIndices[0] - 1 do
					menu.changedModulesIndices[changedIndicesBuf[i]] = true
				end
			end

			-- limited module check
			menu.usedLimitedModules = {}
			for _, entry in ipairs(menu.constructionplan) do
				if IsMacroClass(entry.macro, "ventureplatform") or (IsMacroClass(entry.macro, "dockarea") and GetMacroData(entry.macro, "isventuremodule")) then
					if menu.usedLimitedModules[entry.macro] then
						menu.usedLimitedModules[entry.macro] = menu.usedLimitedModules[entry.macro] + 1
					else
						menu.usedLimitedModules[entry.macro] = 1
					end
				end

				if menu.selectedModule and (entry.idx == menu.selectedModule.idx) then
					menu.selectedModule = entry
				end
			end

			-- errors & warnings
			menu.criticalmoduleerrors = {}
			menu.moduleerrors = {}
			menu.modulewarnings = {}
			menu.criticalerrors = {}
			menu.errors = {}
			menu.warnings = {}
			menu.haschanges = not C.CompareMapConstructionSequenceWithPlanned(menu.holomap, menu.container, false)

			if not GetComponentData(ConvertStringTo64Bit(tostring(menu.buildstorage)), "isplayerowned") then
				menu.moduleerrors[2] = ReadText(1001, 7962)
			end

			if (menu.newModulesIndex > 0) and (menu.newModulesIndex <= #menu.constructionplan) then
				local immediateresources = {}
				for i, resource in ipairs(menu.constructionplan[menu.newModulesIndex].resources) do
					immediateresources[i] = { ware = resource.ware, amount = resource.amount }
				end
				for i = #immediateresources, 1, -1 do
					local entry = immediateresources[i]
					local idx = menu.findWareIdx(menu.buildstorageresources, entry.ware)
					if idx then
						entry.amount = entry.amount - menu.buildstorageresources[idx].amount
						if entry.amount <= 0 then
							table.remove(immediateresources, i)
						end
					end
				end
				if #immediateresources > 0 then
					for i = #immediateresources, 1, -1 do
						local entry = immediateresources[i]
						for _, removedModule in ipairs(menu.removedModules) do
							local idx = menu.findWareIdx(removedModule.resources, entry.ware)
							if idx then
								entry.amount = entry.amount + removedModule.resources[idx].amount
								if entry.amount <= 0 then
									table.remove(immediateresources, i)
									break
								end
							end
						end
					end
					if #immediateresources > 0 then
						menu.warnings[1] = ReadText(1001, 7913)
					end
				end
			end

			menu.constructionvessels = {}
			Helper.ffiVLA(menu.constructionvessels, "UniverseID", C.GetNumAssignedConstructionVessels, C.GetAssignedConstructionVessels, menu.buildstorage)
			if #menu.constructionvessels == 0 then
				if C.DoesConstructionSequenceRequireBuilder(menu.container) then
					menu.errors[1] = ReadText(1001, 7914)
				end
			end

			local haspier, hasdock, ismissingventureplatform, ismissingventuredocks, haswaveprotection = false, false, false, false, false
			for idx, entry in ipairs(menu.constructionplan) do
				local data = GetLibraryEntry(GetMacroData(entry.macro, "infolibrary"), entry.macro)
				if IsMacroClass(entry.macro, "pier") then
					haspier = true
				elseif IsMacroClass(entry.macro, "dockarea") then
					hasdock = true
					if GetMacroData(entry.macro, "isventuremodule") then
						ismissingventureplatform = ismissingventureplatform or (C.GetConstructionMapVenturePlatform(menu.holomap, idx) == 0)
					end
				elseif IsMacroClass(entry.macro, "ventureplatform") then
					ismissingventuredocks = ismissingventuredocks or (C.GetNumConstructionMapVenturePlatformDocks(menu.holomap, idx) == 0)
				elseif IsMacroClass(entry.macro, "buildmodule") then
					if (data.docks_m > 0) or (data.docks_s > 0) then
						hasdock = true
					end
				end
				haswaveprotection = haswaveprotection or GetMacroData(entry.macro, "haswaveprotection")
			end

			local mapresult = ffi.string(C.GetMissingConstructionPlanBlueprints3(menu.container, menu.holomap, nil, false))
			local plannedresult = ffi.string(C.GetMissingConstructionPlanBlueprints3(menu.container, 0, nil, true))

			local missingmapblueprints = {}
			for macro in string.gmatch(mapresult, "([%w_]*);") do
				missingmapblueprints[macro] = (missingmapblueprints[macro] or 0) + 1
			end
			local missingplannedblueprints = {}
			for macro in string.gmatch(plannedresult, "([%w_]*);") do
				missingplannedblueprints[macro] = (missingplannedblueprints[macro] or 0) + 1
			end

			local missingblueprintmodulemismatch = ""
			for k, v in pairs(missingmapblueprints) do
				if v < (missingplannedblueprints[k] or 0) then
					missingblueprintmodulemismatch = missingblueprintmodulemismatch .. "\n· " .. GetMacroData(k, "name")
				end
			end

			if (not haspier) and (not hasdock) then
				menu.moduleerrors[1] = ReadText(1001, 7958)
			elseif not hasdock then
				menu.modulewarnings[2] = ReadText(1001, 7916)
			elseif not haspier then
				menu.modulewarnings[3] = ReadText(1001, 7917)
			end
			if ismissingventureplatform then
				menu.modulewarnings[4] = ReadText(1001, 7960)
			end
			if ismissingventuredocks then
				menu.modulewarnings[5] = ReadText(1001, 7959)
			end
			if not haswaveprotection then
				local sector = GetComponentData(menu.container, "sectorid")
				if GetComponentData(sector, "containsthewave") then
					menu.modulewarnings[6] = ReadText(1001, 11917)
				end
			end
			if missingblueprintmodulemismatch ~= "" then
				menu.modulewarnings[7] = ReadText(1001, 11921) .. missingblueprintmodulemismatch
			end
		end
	end
end

function menu.etaSorter(a, b)
	if (a.eta < 0) then
		return false
	elseif (b.eta < 0) then
		return true
	end
	return a.eta < b.eta
end

function menu.moduleSorter(a, b)
	local aname = GetMacroData(a.macro, "name")
	local bname = GetMacroData(b.macro, "name")
	return aname < bname
end

function menu.moduleHeightHelper(ftable, prevfullheight)
	if prevfullheight < ftable.properties.maxVisibleHeight then
		local fullheight = ftable:getFullHeight()
		if fullheight > ftable.properties.maxVisibleHeight then
			ftable.properties.maxVisibleHeight = prevfullheight
		end
		return fullheight
	end
	return prevfullheight
end

function menu.displayPlan(frame)
	if not menu.loadoutMode then
		local ftable, modulestatustable, resourcetable
		local statusBars = {}
		if menu.planMode == "construction" then
			-- MODULE CHANGES
			ftable = frame:addTable(5, { tabOrder = 3, width = menu.planData.width, maxVisibleHeight = 0.4 * Helper.viewHeight, x = menu.planData.offsetX, y = menu.planData.offsetY, reserveScrollBar = true, backgroundID = "solid", backgroundColor = Color["table_background_3d_editor"] })
			ftable:setColWidth(1, Helper.scaleY(Helper.standardTextHeight), false)
			ftable:setColWidth(2, Helper.scaleY(Helper.standardTextHeight), false)
			ftable:setColWidth(4, 0.25 * menu.planData.width, false)
			ftable:setColWidth(5, Helper.scaleY(Helper.standardTextHeight), false)

			local prevfullheight = 0
			-- modules
			local row = ftable:addRow(false, { bgColor = Color["row_title_background"], fixed = true, bgColor = Color["row_background_blue"] })
			row[1]:setColSpan(5):createText(ReadText(1001, 7924), menu.headerTextProperties)
			-- unchanged modules
			local sortedModules = {}
			local changedCount = 0
			local habitationadded = 0
			local workforceneedadded = 0
			for i = 1, #menu.constructionplan do
				local infolibrary = GetMacroData(menu.constructionplan[i].macro, "infolibrary")
				if not menu.changedModulesIndices[i] then
					if sortedModules[infolibrary] then
						table.insert(sortedModules[infolibrary], menu.constructionplan[i])
					else
						sortedModules[infolibrary] = { menu.constructionplan[i] }
					end
				else
					changedCount = changedCount + 1
					if infolibrary == "moduletypes_habitation" then
						habitationadded = habitationadded + GetMacroData(menu.constructionplan[i].macro, "workforcecapacity")
					elseif infolibrary == "moduletypes_production" then
						workforceneedadded = workforceneedadded + GetMacroData(menu.constructionplan[i].macro, "maxworkforce")
					end
				end
			end
			for _, entry in ipairs(config.leftBar) do
				if sortedModules[entry.mode] then
					local isextended = menu.isEntryExtended(menu.container, entry.mode)

					local row = ftable:addRow(true, { bgColor = Color["row_title_background"] })
					row[1]:createButton({  }):setText(isextended and "-" or "+", { halign = "center" })
					row[1].handlers.onClick = function () return menu.buttonExtendEntry(entry.mode, row.index) end
					row[2]:setColSpan(2):setBackgroundColSpan(4):createText(entry.name, Helper.subHeaderTextProperties)
					row[4]:setColSpan(2):createText(#sortedModules[entry.mode], Helper.subHeaderTextProperties)
					row[4].properties.halign = "right"
					prevfullheight = menu.moduleHeightHelper(ftable, prevfullheight)

					if isextended then
						table.sort(sortedModules[entry.mode], menu.moduleSorter)
						for i = 1, #sortedModules[entry.mode] do
							local row = menu.displayModuleRow(ftable, i .. "entry.mode", sortedModules[entry.mode][i], false, false)
							prevfullheight = menu.moduleHeightHelper(ftable, prevfullheight)
						end

						if entry.mode == "moduletypes_habitation" then
							local workforceinfo = C.GetWorkForceInfo(menu.container, "");

							ftable:addEmptyRow()
							local row = ftable:addRow(true, {  })
							row[2]:setColSpan(2):createText("   " .. ReadText(1001, 9611))
							row[4]:createText(ConvertIntegerString(workforceinfo.capacity, true, 0, true, false) .. ((habitationadded > 0) and (" (" .. ConvertIntegerString(workforceinfo.capacity + habitationadded, true, 0, true, false) .. ")") or ""), { halign = "right" })
							local row = ftable:addRow(true, {  })
							row[2]:setColSpan(2):createText("   " .. ReadText(1001, 8412))
							row[4]:createText(ConvertIntegerString(workforceinfo.current, true, 0, true, false), { halign = "right" })
							local row = ftable:addRow(true, {  })
							row[2]:setColSpan(2):createText("   " .. ReadText(1001, 8413))
							row[4]:createText(ConvertIntegerString(workforceinfo.optimal, true, 0, true, false) .. ((workforceneedadded > 0) and (" (" .. ConvertIntegerString(workforceinfo.optimal + workforceneedadded, true, 0, true, false) .. ")") or ""), { halign = "right" })
						end
					end
				end
			end
			-- removed modules
			if #menu.removedModules > 0 then
				local isextended = menu.isEntryExtended(menu.container, "removed")

				local row = ftable:addRow(true, { bgColor = Color["row_title_background"] })
				row[1]:createButton({  }):setText(isextended and "-" or "+", { halign = "center" })
				row[1].handlers.onClick = function () return menu.buttonExtendEntry("removed", row.index) end
				row[2]:setColSpan(2):setBackgroundColSpan(4):createText(ReadText(1001, 7964), Helper.subHeaderTextProperties)
				row[2].properties.color = Color["text_negative"]
				row[4]:setColSpan(2):createText(#menu.removedModules, Helper.subHeaderTextProperties)
				row[4].properties.halign = "right"
				prevfullheight = menu.moduleHeightHelper(ftable, prevfullheight)
				if isextended then
					for i, entry in ipairs(menu.removedModules) do
						menu.displayModuleRow(ftable, i, entry, false, true)
						prevfullheight = menu.moduleHeightHelper(ftable, prevfullheight)
					end
				end
			end
			-- changed or new modules
			if changedCount > 0 then
				local isextended = menu.isEntryExtended(menu.container, "planned")

				local row = ftable:addRow(true, { bgColor = Color["row_title_background"] })
				row[1]:createButton({  }):setText(isextended and "-" or "+", { halign = "center" })
				row[1].handlers.onClick = function () return menu.buttonExtendEntry("planned", row.index) end
				row[2]:setColSpan(2):setBackgroundColSpan(4):createText(ReadText(1001, 7963), Helper.subHeaderTextProperties)
				row[2].properties.color = Color["text_positive"]
				row[4]:setColSpan(2):createText(changedCount, Helper.subHeaderTextProperties)
				row[4].properties.halign = "right"
				prevfullheight = menu.moduleHeightHelper(ftable, prevfullheight)
				if isextended then
					for i = 1, #menu.constructionplan do
						if menu.changedModulesIndices[i] then
							local row = menu.displayModuleRow(ftable, i, menu.constructionplan[i], true, false)
							if (not menu.selectedRows.plan) then
								menu.selectedRows.plan = row.index
							end
							prevfullheight = menu.moduleHeightHelper(ftable, prevfullheight)
						end
					end
				end
			end
			menu.totalprice = GetComponentData(ConvertStringTo64Bit(tostring(menu.buildstorage)), "wantedmoney")

			if menu.selectedRows.plan == "last" then
				menu.selectedRows.plan = ftable.rows[#ftable.rows].index
			end
			if menu.selectedRows.plan == "first" then
				menu.selectedRows.plan = 2
			else
				local numdisplayedlines = math.floor((ftable:getVisibleHeight() - menu.titleData.height) / (Helper.scaleY(Helper.subHeaderHeight) + Helper.borderSize))
				if menu.topRows.plan and menu.selectedRows.plan then
					if menu.topRows.plan + numdisplayedlines - 1 < menu.selectedRows.plan then
						menu.topRows.plan = menu.selectedRows.plan - numdisplayedlines + 3
					elseif menu.selectedRows.plan < menu.topRows.plan then
						menu.topRows.plan = menu.selectedRows.plan
					end
				elseif menu.selectedRows.plan then
					menu.topRows.plan = menu.selectedRows.plan - numdisplayedlines + 3
				end
			end
			ftable:setTopRow(menu.topRows.plan)
			ftable:setSelectedRow(menu.selectedRows.plan)
			menu.topRows.plan = nil
			menu.selectedRows.plan = nil

			-- MODULE LOADOUTS & STATUS
			local yoffset = ftable.properties.y + ftable:getVisibleHeight() + 2 * Helper.borderSize
			modulestatustable = frame:addTable(6, { tabOrder = 4, width = menu.planData.width, x = menu.planData.offsetX, y = yoffset, reserveScrollBar = true, backgroundID = "solid", backgroundColor = Color["table_background_3d_editor"] })
			local smallColWidth = Helper.scaleY(Helper.standardTextHeight)
			modulestatustable:setColWidth(1, smallColWidth, false)
			modulestatustable:setColWidth(2, smallColWidth, false)
			modulestatustable:setColWidth(3, 0.5 * menu.planData.width - 2 * smallColWidth, false)
			modulestatustable:setColWidth(5, 0.3 * menu.planData.width, false)
			modulestatustable:setColWidth(6, smallColWidth, false)

			-- station-wide loadout
			local row = modulestatustable:addRow(false, { bgColor = Color["row_title_background"] })
			row[1]:setColSpan(6):createText(ReadText(1001, 7966), menu.headerTextProperties)
			-- selection
			local row = modulestatustable:addRow(true, {  })
			row[1]:setColSpan(4):createText(ReadText(1001, 7967) .. ReadText(1001, 120))
			local loadoutOptions = {
				{ id = 0,	text = ReadText(1001, 7990), icon = "", displayremoveoption = false },
				{ id = 0.1,	text = ReadText(1001, 7910), icon = "", displayremoveoption = false },
				{ id = 0.5,	text = ReadText(1001, 7911), icon = "", displayremoveoption = false },
				{ id = 1.0,	text = ReadText(1001, 7912), icon = "", displayremoveoption = false },
				{ id = -1,	text = ReadText(1001, 7968), icon = "", displayremoveoption = false },
			}
			row[5]:setColSpan(2):createDropDown(loadoutOptions, { startOption = function () return tostring(menu.defaultLoadout) end }):setTextProperties({ halign = "center" })
			row[5].handlers.onDropDownConfirmed = menu.dropdownDefaultLoadout

			-- preferred build method
			local row = modulestatustable:addRow(false, { bgColor = Color["row_title_background"] })
			row[1]:setColSpan(6):createText(ReadText(1001, 11298), menu.headerTextProperties)

			local cursetting = ffi.string(C.GetContainerBuildMethod(menu.buildstorage))
			local curglobalsetting = ffi.string(C.GetPlayerBuildMethod())
			local foundcursetting = false
			local locresponses = {}
			local n = C.GetNumPlayerBuildMethods()
			if n > 0 then
				local buf = ffi.new("ProductionMethodInfo[?]", n)
				n = C.GetPlayerBuildMethods(buf, n)
				for i = 0, n - 1 do
					local id = ffi.string(buf[i].id)
					-- check if the curglobalsetting (which can be the method of the player's race) is in the list of options
					if id == curglobalsetting then
						foundcursetting = true
					end
					table.insert(locresponses, { id = id, text = ffi.string(buf[i].name), icon = "", displayremoveoption = false })
				end
			end
			-- if the setting is not in the list, default to default (if the race method is not in the list, there is no ware that has this method and it will always use default)
			if not foundcursetting then
				curglobalsetting = "default"
			end
			local hasownsetting = cursetting ~= ""

			local rowdata = "info_buildrule_global"
			local row = modulestatustable:addRow({ rowdata }, {  })
			row[1]:setColSpan(5):createText(ReadText(1001, 8367))
			row[6]:createCheckBox(not hasownsetting, { width = config.mapRowHeight, height = config.mapRowHeight })
			row[6].handlers.onClick = function(_, checked) return menu.checkboxSetBuildRuleOverride(menu.buildstorage, checked, curglobalsetting) end

			local row = modulestatustable:addRow("info_buildrule", {  })
			row[1]:setColSpan(6):createDropDown(locresponses, { height = Helper.standardTextHeight, startOption = hasownsetting and cursetting or curglobalsetting, active = hasownsetting }):setTextProperties({ fontsize = config.mapFontSize })
			row[1].handlers.onDropDownConfirmed = function (_, id) return menu.dropdownBuildRule(menu.buildstorage, id) end
			row[1].handlers.onDropDownActivated = function () menu.noupdate = true end

			-- module status here
			local row = modulestatustable:addRow(false, { fixed = true, bgColor = Color["row_title_background"] })
			row[1]:setColSpan(6):createText(ReadText(1001, 7991), menu.headerTextProperties)

			local infoCount = 0
			local visibleHeight
			for _, errorentry in Helper.orderedPairs(menu.criticalmoduleerrors) do
				row = modulestatustable:addRow(true, {  })
				row[1]:setColSpan(6):createText(errorentry, { color = Color["text_criticalerror"], wordwrap = true })
			end
			for _, errorentry in Helper.orderedPairs(menu.moduleerrors) do
				row = modulestatustable:addRow(true, {  })
				row[1]:setColSpan(6):createText(errorentry, { color = Color["text_error"], wordwrap = true })
			end
			for _, warningentry in Helper.orderedPairs(menu.modulewarnings) do
				row = modulestatustable:addRow(true, {  })
				row[1]:setColSpan(6):createText(warningentry, { color = Color["text_warning"], wordwrap = true })
			end
			if (not next(menu.criticalmoduleerrors)) and (not next(menu.moduleerrors)) and (not next(menu.modulewarnings)) then
				row = modulestatustable:addRow(true, {  })
				row[1]:setColSpan(6):createText(ReadText(1001, 7923), { color = Color["text_success"] })
			end

			-- BUTTONS
			if menu.cancelRequested then
				local row = modulestatustable:addRow(false, { fixed = true, bgColor = Color["row_title_background"] })
				row[1]:setColSpan(6):createText(ReadText(1001, 9705), menu.headerTextProperties)

				local row = modulestatustable:addRow(true, { fixed = true, bgColor = Color["row_title_background"] })
				row[1]:setColSpan(3):createButton({  }):setText(ReadText(1001, 2617), { halign = "center" })
				row[1].handlers.onClick = menu.buttonCancelConfirm
				row[4]:setColSpan(3):createButton({  }):setText(ReadText(1001, 2618), { halign = "center" })
				row[4].handlers.onClick = menu.buttonCancelCancel
			else
				local row = modulestatustable:addRow(true, { fixed = true, bgColor = Color["row_title_background"] })
				if (ffi.string(C.GetGameStartName()) == "x4ep1_gamestart_workshop") and (not menu.confirmModuleChangesActive()) and ((C.GetCurrentBuildProgress(menu.container) >= 0) or C.IsBuildWaitingForSecondaryComponentResources(menu.container)) then
					row[1]:setColSpan(3):createButton({ helpOverlayID = "force_modulechanges", helpOverlayText = " ",  helpOverlayHighlightOnly = true, active = true }):setText(ReadText(1001, 11919), { halign = "center" })
					row[1].handlers.onClick = menu.buttonForceBuild
				else
					row[1]:setColSpan(3):createButton({ helpOverlayID = "confirm_modulechanges", helpOverlayText = " ",  helpOverlayHighlightOnly = true, active = menu.confirmModuleChangesActive }):setText(ReadText(1001, 7919), { halign = "center" })
					row[1].handlers.onClick = menu.buttonConfirm
					row[1].properties.uiTriggerID = "confirmmodulechanges"
				end
				row[4]:setColSpan(3):createButton({ helpOverlayID = "cancel_modulechanges", helpOverlayText = " ",  helpOverlayHighlightOnly = true, active = menu.haschanges }):setText(ReadText(1001, 7918), { halign = "center" })
				row[4].handlers.onClick = menu.buttonCancel
				row[4].properties.uiTriggerID = "cancelmodulechanges"
			end

			-- BUILD RESOURCES
			local yoffset = modulestatustable.properties.y + modulestatustable:getVisibleHeight() + 2 * Helper.borderSize
			resourcetable = frame:addTable(6, { tabOrder = 5, width = menu.planData.width, x = menu.planData.offsetX, y = yoffset, reserveScrollBar = true, backgroundID = "solid", backgroundColor = Color["table_background_3d_editor"] })
			resourcetable:setColWidth(1, smallColWidth, false)
			resourcetable:setColWidth(2, smallColWidth, false)
			resourcetable:setColWidth(3, 0.5 * menu.planData.width - 2 * smallColWidth, false)
			resourcetable:setColWidth(5, 0.3 * menu.planData.width, false)
			resourcetable:setColWidth(6, smallColWidth, false)

			menu.tradewares = {}
			local n = C.GetNumWares("stationbuilding", false, "", "")
			local buf = ffi.new("const char*[?]", n)
			n = C.GetWares(buf, n, "stationbuilding", false, "", "")
			for i = 0, n - 1 do
				table.insert(menu.tradewares, { ware = ffi.string(buf[i]) })
			end

			-- resources
			local row = resourcetable:addRow(false, { bgColor = Color["row_title_background"] })
			row[1]:setColSpan(6):createText(ReadText(1001, 7925), menu.headerTextProperties)
			-- have
			local row = resourcetable:addRow(true, { bgColor = Color["row_title_background"] })
			if not menu.selectedRows.planresources then
				menu.selectedRows.planresources = row.index
			end
			local isextended = menu.isResourceEntryExtended("buildstorage")
			row[1]:createButton({ helpOverlayID = "plot_resources_available", helpOverlayText = " ",  helpOverlayHighlightOnly = true, uiTriggerID = "extendavailableresourcesentry" }):setText(isextended and "-" or "+", { halign = "center" })
			row[1].handlers.onClick = function () return menu.buttonExtendResourceEntry("buildstorage", row.index) end
			row[2]:setColSpan(5):createText(ReadText(1001, 7927) .. (menu.newWareReservation and " " .. ColorText["text_positive"] .. "[+" .. menu.newWareReservation .. "]" or ""), Helper.subHeaderTextProperties)

			if isextended then
				-- reservations
				local reservations = {}
				local n = C.GetNumContainerWareReservations2(menu.buildstorage, false, false, true)
				local buf = ffi.new("WareReservationInfo2[?]", n)
				n = C.GetContainerWareReservations2(buf, n, menu.buildstorage, false, false, true)
				for i = 0, n - 1 do
					local ware = ffi.string(buf[i].ware)
					local tradedeal = buf[i].tradedealid
					if not menu.dirtyreservations[tostring(tradedeal)] then
						if reservations[ware] then
							table.insert(reservations[ware], { reserver = buf[i].reserverid, amount = buf[i].amount, eta = buf[i].eta, tradedeal = tradedeal })
						else
							reservations[ware] = { { reserver = buf[i].reserverid, amount = buf[i].amount, eta = buf[i].eta, tradedeal = tradedeal } }
						end
					end
				end
				for _, data in pairs(reservations) do
					table.sort(data, menu.etaSorter)
				end

				local resources = {}
				for _, resource in ipairs(menu.neededresources) do
					if resource.amount > 0 then
						local current = 0
						local idx = menu.findWareIdx(menu.buildstorageresources, resource.ware)
						if idx then
							current =  menu.buildstorageresources[idx].amount
						end

						local reserved = 0
						if reservations[resource.ware] then
							for _, reservation in ipairs(reservations[resource.ware]) do
								reserved = reserved + reservation.amount
							end
						end

						table.insert(resources, { ware = resource.ware, name = GetWareData(resource.ware, "name"), needed = resource.amount, current = current, reserved = reserved })
					end
				end
				for _, resource in ipairs(menu.buildstorageresources) do
					local idx = menu.findWareIdx(resources, resource.ware)
					if not idx then
						local needed = 0
						local idx = menu.findWareIdx(menu.neededresources, resource.ware)
						if idx then
							needed =  menu.neededresources[idx].amount
						end

						local reserved = 0
						if reservations[resource.ware] then
							for _, reservation in ipairs(reservations[resource.ware]) do
								reserved = reserved + reservation.amount
							end
						end

						table.insert(resources, { ware = resource.ware, name = GetWareData(resource.ware, "name"), needed = needed, current = resource.amount, reserved = reserved })
					end
				end
				for ware, reservationentry in pairs(reservations) do
					local idx = menu.findWareIdx(resources, ware)
					if not idx then
						local current = 0
						local idx = menu.findWareIdx(menu.buildstorageresources, ware)
						if idx then
							current =  menu.buildstorageresources[idx].amount
						end

						local needed = 0
						local idx = menu.findWareIdx(menu.neededresources, ware)
						if idx then
							needed =  menu.neededresources[idx].amount
						end

						local reserved = 0
						if reservationentry then
							for _, reservation in ipairs(reservations[ware]) do
								reserved = reserved + reservation.amount
							end
						end

						table.insert(resources, { ware = ware, name = GetWareData(ware, "name"), needed = needed, current = current, reserved = reserved })
					end
				end
				table.sort(resources, Helper.sortName)

				for i, resource in ipairs(resources) do
					local row = resourcetable:addRow(true, {  })
					local xoffset = row[1]:getWidth() + row[2]:getWidth() + row[3]:getWidth() + 3 * Helper.borderSize
					statusBars[i] = row[1]:createStatusBar({ current = resource.current + resource.reserved, start = resource.current, max = resource.needed, cellBGColor = Color["row_background"], valueColor = Color["slider_value"], posChangeColor = Color["statusbar_diff_pos"], width = menu.planData.width - xoffset, x = xoffset, scaling = false })
					row[2]:setColSpan(2):createText(GetWareData(resource.ware, "name"))
					row[4]:setColSpan(3):createText(((resource.current < resource.needed) and ColorText["text_negative"] or "") .. ConvertIntegerString(resource.current, true, 0, true) .. "\27X" .. ((resource.reserved > 0) and (" (" .. ColorText["text_positive"] .. "+" .. ConvertIntegerString(resource.reserved, true, 0, true) .. "\27X)") or "") .. " / " .. ConvertIntegerString(resource.needed, true, 0, true), { halign = "right", cellBGColor = Color["row_background_unselectable"] })
				end

				menu.newWareReservation = nil
				if next(reservations) then
					local row = resourcetable:addRow(true, {  })
					row[1]:setColSpan(6):createText(ReadText(1001, 7946), Helper.subHeaderTextProperties)
					row[1].properties.halign = "center"
					for _, ware in ipairs(menu.tradewares) do
						if reservations[ware.ware] then
							local isextended = menu.isResourceEntryExtended("reservation" .. ware.ware, true)
							local titlerow = resourcetable:addRow(true, {  })
							titlerow[1]:createButton({  }):setText(isextended and "-" or "+", { halign = "center" })
							titlerow[1].handlers.onClick = function () return menu.buttonExtendResourceEntry("reservation" .. ware.ware, titlerow.index) end
							local color = Color["text_normal"]
							if menu.newWareReservationWares[ware.ware] then
								color = Color["text_positive"]
							end
							titlerow[2]:setColSpan(3):createText(GetWareData(ware.ware, "name"), { color = color })
							local total = 0
							for _, reservation in ipairs(reservations[ware.ware]) do
								total = total + reservation.amount
								if isextended then
									local row = resourcetable:addRow(true, {  })
									local reserverid = ConvertStringTo64Bit(tostring(reservation.reserver))
									local name = ffi.string(C.GetComponentName(reservation.reserver)) .. " (" .. ffi.string(C.GetObjectIDCode(reservation.reserver)) .. ")"
									local colorprefix = GetComponentData(reserverid, "isplayerowned") and ColorText["text_player"] or ""

									-- kuertee start: callback
									-- row[2]:setColSpan(3):createText(function () return Helper.getETAString(colorprefix .. name, reservation.eta) end, { font = Helper.standardFontMono })
									if callbacks ["displayPlan_render_incoming_ware"] then
										for _, callback in ipairs (callbacks ["displayPlan_render_incoming_ware"]) do
											isbreak = callback (row, colorprefix, name, reservation)
											if isbreak then
												break
											end
										end
									else
										row[2]:setColSpan(3):createText(function () return Helper.getETAString(colorprefix .. name, reservation.eta) end, { font = Helper.standardFontMono })
									end
									-- kuertee end: callback

									local color = Color["text_normal"]
									if menu.newWareReservationWares[ware.ware] and menu.newWareReservationWares[ware.ware][tostring(reserverid)] then
										color = Color["text_positive"]
									end
									row[5]:createText(ConvertIntegerString(reservation.amount, true, 0, false), { halign = "right", color = color })
									row[6]:createButton({ active = function () return menu.buttonCancelTradeActive(reservation.tradedeal) end, mouseOverText = ReadText(1026, 7924) }):setText("X", { halign = "center" })
									row[6].handlers.onClick = function () return menu.buttonCancelTrade(reservation.tradedeal) end
								end
							end
							titlerow[5]:setColSpan(2):createText(ConvertIntegerString(total, true, 0, false), { halign = "right" })
						end
					end
				end
				resourcetable:addEmptyRow(Helper.standardTextHeight / 2)
				menu.newWareReservationWares = {}
			end

			-- config
			local row = resourcetable:addRow(true, { bgColor = Color["row_title_background"] })
			local isextended = menu.isResourceEntryExtended("resourceconfig")
			row[1]:createButton({ helpOverlayID = "plot_resources_buyoffers", helpOverlayText = " ",  helpOverlayHighlightOnly = true }):setText(isextended and "-" or "+", { halign = "center" })
			row[1].handlers.onClick = function () return menu.buttonExtendResourceEntry("resourceconfig", row.index) end
			row[1].properties.uiTriggerID = "extendresourceentry"
			row[2]:setColSpan(5):createText(ReadText(1001, 7928), Helper.subHeaderTextProperties)
			if isextended then
				local row = resourcetable:addRow(false, {  })
				row[2]:setColSpan(5):createText(ReadText(1001, 7944), Helper.subHeaderTextProperties)
				row[2].properties.halign = "center"

				-- trade rule
				local hasownlist = C.HasContainerOwnTradeRule(menu.buildstorage, "buy", "") or C.HasContainerOwnTradeRule(menu.buildstorage, "sell", "")
				local traderuleid = C.GetContainerTradeRuleID(menu.buildstorage, "buy", "")
				if traderuleid ~= C.GetContainerTradeRuleID(menu.buildstorage, "sell", "") then
					DebugError("Mismatch between buy and sell trade rule on supply ship: " .. tostring(traderuleid) .. " vs " .. tostring(C.GetContainerTradeRuleID(menu.buildstorage, "sell", "")))
				end
				local row = resourcetable:addRow(nil, { bgColor = Color["row_background_unselectable"] })
				row[1].properties.cellBGColor = Color["row_background"]
				row[2]:setColSpan(5):createText(ReadText(1001, 11013) .. ReadText(1001, 120), textproperties)
				-- global
				local row = resourcetable:addRow("order_wares_global", {  })
				row[2]:setColSpan(4):createText(ReadText(1001, 8367) .. ReadText(1001, 120), textproperties)
				row[6]:createCheckBox(not hasownlist, { height = config.mapRowHeight })
				row[6].handlers.onClick = function(_, checked) return menu.checkboxSetTradeRuleOverride(menu.buildstorage, "trade", checked) end
				-- current
				local row = resourcetable:addRow("order_wares_current", {  })
				row[2]:setColSpan(4):createDropDown(Helper.traderuleOptions, { startOption = (traderuleid ~= 0) and traderuleid or -1, active = hasownlist }):setTextProperties({ fontsize = config.mapFontSize })
				row[2].handlers.onDropDownConfirmed = function (_, id) return menu.dropdownTradeRule(menu.buildstorage, "trade", id, "", true) end
				row[2].handlers.onSliderCellActivated = function() menu.noupdate = true end
				row[2].handlers.onSliderCellDeactivated = function() menu.noupdate = false end
				row[6]:createButton({ mouseOverText = ReadText(1026, 8407) }):setIcon("menu_edit")
				row[6].handlers.onClick = menu.buttonEditTradeRule

				resourcetable:addEmptyRow()

				-- global price modifier
				local row = resourcetable:addRow(true, {  })
				menu.globalpricefactor = C.GetContainerGlobalPriceFactor(menu.buildstorage)
				local hasvalidmodifier = menu.globalpricefactor >= 0
				row[2]:createCheckBox(hasvalidmodifier, { })
				row[2].handlers.onClick = menu.checkboxToggleGlobalWarePriceModifier
				row[3]:setColSpan(4):createText(ReadText(1001, 7945))
				local row = resourcetable:addRow(true, {  })
				local currentfactor = menu.globalpricefactor * 100
				row[2]:setColSpan(5):createSliderCell({ height = Helper.standardTextHeight, valueColor = hasvalidmodifier and Color["slider_value"] or Color["slider_value_inactive"], min = 0, max = 100, start = hasvalidmodifier and currentfactor or 100, suffix = "%", readOnly = not hasvalidmodifier, hideMaxValue = true }):setText(ReadText(1001, 2808))
				row[2].handlers.onSliderCellChanged = function (_, ...) return menu.slidercellGlobalWarePriceFactor(row.index, ...) end
				row[2].handlers.onSliderCellActivated = function() menu.noupdate = true end
				row[2].handlers.onSliderCellDeactivated = function() menu.noupdate = false end
				-- trade restrictions
				local row = resourcetable:addRow(false, {  })
				row[2]:setColSpan(5):createText(ReadText(1001, 7931), Helper.subHeaderTextProperties)
				row[2].properties.halign = "center"

				for i, ware in ipairs(menu.tradewares) do
					local isextended = menu.isResourceEntryExtended("resourceconfig" .. ware.ware)
					local row = resourcetable:addRow(true, {  })
					row[2]:createButton({ helpOverlayID = "plot_resources_resourceconfig" .. ware.ware, helpOverlayText = " ",  helpOverlayHighlightOnly = true }):setText(isextended and "-" or "+", { halign = "center" })
					row[2].handlers.onClick = function () return menu.buttonExtendResourceEntry("resourceconfig" .. ware.ware, row.index) end
					row[2].properties.uiTriggerID = "extendresourceentry" .. ware.ware
					
					-- kuertee start: callback
					-- row[3]:setColSpan(2):createText(GetWareData(ware.ware, "name"))
					if callbacks ["displayPlan_getWareName"] then
						local name
						for _, callback in ipairs (callbacks ["displayPlan_getWareName"]) do
							name = callback (ware.ware, name)
						end
						if name then
							row[3]:setColSpan(2):createText(name)
						else
							row[3]:setColSpan(2):createText(GetWareData(ware.ware, "name"))
						end
					else
						row[3]:setColSpan(2):createText(GetWareData(ware.ware, "name"))
					end
					-- kuertee end: callback

					if C.GetContainerTradeRuleID(menu.buildstorage, "buy", ware.ware) > 0 then
						row[5]:setColSpan(2):createText("\27[lso_error]", { halign = "right", color = Color["text_warning"], mouseOverText = ReadText(1026, 8404) })
					end

					ware.minprice, ware.maxprice = GetWareData(ware.ware, "minprice", "maxprice")
					if isextended then
						-- trade rule
						local hasownlist = C.HasContainerOwnTradeRule(menu.buildstorage, "buy", ware.ware) or C.HasContainerOwnTradeRule(menu.buildstorage, "sell", ware.ware)
						local traderuleid = C.GetContainerTradeRuleID(menu.buildstorage, "buy", ware.ware)
						if traderuleid ~= C.GetContainerTradeRuleID(menu.buildstorage, "sell", ware.ware) then
							DebugError("Mismatch between buy and sell trade rule on supply ship: " .. tostring(traderuleid) .. " vs " .. tostring(C.GetContainerTradeRuleID(menu.buildstorage, "sell", ware.ware)))
						end
						local row = resourcetable:addRow(nil, { bgColor = Color["row_background_unselectable"] })
						row[1].properties.cellBGColor = Color["row_background"]
						row[2].properties.cellBGColor = Color["row_background"]
						row[3]:setColSpan(4):createText(ReadText(1001, 11013) .. ReadText(1001, 120), textproperties)
						-- global
						local row = resourcetable:addRow("order_wares_global", {  })
						row[3]:setColSpan(3):createText(ReadText(1001, 11033) .. ReadText(1001, 120), textproperties)
						row[6]:createCheckBox(not hasownlist, { height = config.mapRowHeight })
						row[6].handlers.onClick = function(_, checked) return menu.checkboxSetTradeRuleOverride(menu.buildstorage, "trade", checked, ware.ware) end
						-- current
						local row = resourcetable:addRow("order_wares_current", {  })
						row[3]:setColSpan(3):createDropDown(Helper.traderuleOptions, { startOption = (traderuleid ~= 0) and traderuleid or -1, active = hasownlist }):setTextProperties({ fontsize = config.mapFontSize })
						row[3].handlers.onDropDownConfirmed = function (_, id) return menu.dropdownTradeRule(menu.buildstorage, "trade", id, ware.ware, true) end
						row[3].handlers.onSliderCellActivated = function() menu.noupdate = true end
						row[3].handlers.onSliderCellDeactivated = function() menu.noupdate = false end
						row[6]:createButton({ mouseOverText = ReadText(1026, 8407) }):setIcon("menu_edit")
						row[6].handlers.onClick = menu.buttonEditTradeRule

						resourcetable:addEmptyRow(Helper.standardTextHeight / 2)

						local row = resourcetable:addRow(true, {  })
						ware.row = row.index
						local currentprice = math.max(ware.minprice, math.min(ware.maxprice, GetContainerWarePrice(menu.buildstorage, ware.ware, true, true)))
						row[3]:setColSpan(4):createSliderCell({ height = Helper.standardTextHeight, valueColor = Color["slider_value"], min = ware.minprice, max = ware.maxprice, start = currentprice, suffix = ReadText(1001, 101), readOnly = restricted, hideMaxValue = true }):setText(ReadText(1001, 2808))
						row[3].handlers.onSliderCellChanged = function (_, ...) return menu.slidercellWarePriceOverride(ware.ware, row.index, ...) end
						row[3].handlers.onSliderCellActivated = function() menu.noupdate = true end
						row[3].handlers.onSliderCellDeactivated = function() menu.noupdate = false end

						if i ~= #menu.tradewares then
							resourcetable:addEmptyRow()
						end
					end
				end
				-- price
				local row = resourcetable:addRow(false, {  })
				row[2]:setColSpan(5):createText(ReadText(1001, 7929), Helper.subHeaderTextProperties)
				row[2].properties.halign = "center"
				local row = resourcetable:addRow(true, {  })
				row[2]:setColSpan(5):createText(ConvertMoneyString(menu.totalprice, false, true, 0, true) .. " " .. ReadText(1001, 101), { halign = "right" })
				-- account
				local row = resourcetable:addRow(false, {  })
				row[2]:setColSpan(5):createText(ReadText(1001, 7930), Helper.subHeaderTextProperties)
				row[2].properties.halign = "center"
				row[2].properties.helpOverlayID = "construction_available_funds"
				row[2].properties.helpOverlayText = " "
				row[2].properties.helpOverlayHighlightOnly = true
				local row = resourcetable:addRow(true, {  })
				local buildstoragemoney = GetComponentData(ConvertStringTo64Bit(tostring(menu.buildstorage)), "money")
				local playermoney = GetPlayerMoney()
				local min = 0
				local max = buildstoragemoney + playermoney
				local start = math.max(min, math.min(max, menu.newAccountValue or buildstoragemoney))
				row[2]:setColSpan(5):createSliderCell({ height = Helper.standardTextHeight, valueColor = Color["slider_value"], min = min, max = max, start = start, suffix = ReadText(1001, 101), hideMaxValue = true })
				row[2].handlers.onSliderCellChanged = menu.slidercellMoney
				row[2].handlers.onSliderCellActivated = function() menu.noupdate = true end
				row[2].handlers.onSliderCellDeactivated = function() menu.noupdate = false end
				local row = resourcetable:addRow(true, {  })
				row[2]:setColSpan(3):createButton({ helpOverlayID = "confirm_credits", helpOverlayText = " ", helpOverlayHighlightOnly = true, active = function () return (menu.newAccountValue ~= nil) and (menu.newAccountValue ~= buildstoragemoney) and GetComponentData(ConvertStringTo64Bit(tostring(menu.buildstorage)), "isplayerowned") end }):setText(ReadText(1001, 2821), { halign = "center" })
				row[2].handlers.onClick = menu.buttonConfirmMoney
				row[2].properties.uiTriggerID = "confirmcredits"
				row[5]:setColSpan(2):createButton({ active = function () local money, isplayerowned = GetComponentData(ConvertStringTo64Bit(tostring(menu.buildstorage)), "money", "isplayerowned"); return ((money + GetPlayerMoney()) > menu.totalprice) and isplayerowned end, helpOverlayID = "acceptestimate", helpOverlayText = " ", helpOverlayHighlightOnly = true, uiTriggerID = "acceptestimate" }):setText(ReadText(1001, 7965), { halign = "center" })
				row[5].handlers.onClick = menu.buttonSetMoneyToEstimate
			end

			-- CVs
			local row = resourcetable:addRow(false, { bgColor = Color["row_title_background"] })
			row[1]:setColSpan(6):createText(ReadText(1001, 7932), menu.headerTextProperties)
			row[1].properties.halign = "center"
			row[1].properties.helpOverlayID = "construction_builders_header"
			row[1].properties.helpOverlayText = " "
			row[1].properties.helpOverlayHighlightOnly = true

			if #menu.constructionvessels > 0 then
				for _, component in ipairs(menu.constructionvessels) do
					row = resourcetable:addRow(true, {  })
					row[1]:setColSpan(6):createText(ffi.string(C.GetComponentName(component)) .. " (" .. ffi.string(C.GetObjectIDCode(component)) .. ")")
				end
			else
				row = resourcetable:addRow(true, {  })
				row[1]:setColSpan(6):createText(ReadText(1001, 7933))
			end
			row = resourcetable:addRow(true, {  })
			if #menu.constructionvessels == 0 then
				local active = C.DoesConstructionSequenceRequireBuilder(menu.container)
				row[1]:setColSpan(6):createButton({ active = active, helpOverlayID = "assign_hire_builder", helpOverlayText = " ",  helpOverlayHighlightOnly = true, mouseOverText = active and "" or ReadText(1026, 7923) }):setText(ReadText(1001, 7934), { halign = "center" })
				row[1].handlers.onClick = menu.buttonAssignConstructionVessel
				row[1].properties.uiTriggerID = "assignhirebuilder"
			else
				local deployorderidx
				local numorders = C.GetNumOrders(menu.constructionvessels[1])
				local currentorders = ffi.new("Order[?]", numorders)
				numorders = C.GetOrders(currentorders, numorders, menu.constructionvessels[1])
				for i = 1, numorders do
					if ffi.string(currentorders[i - 1].orderdef) == "DeployToStation" then
						deployorderidx = i
						break
					end
				end

				row[1]:setColSpan(5):createButton({ active = (deployorderidx ~= nil) and C.RemoveOrder2(menu.constructionvessels[1], deployorderidx, true, true, true) }):setText(ReadText(1001, 7961), { halign = "center" })
				row[1].handlers.onClick = function () return menu.buttonFireConstructionVessel(menu.constructionvessels[1], deployorderidx) end
				row[1].properties.uiTriggerID = "firebuilder"
			end

			resourcetable:setTopRow(menu.topRows.planresources)
			resourcetable:setSelectedRow(menu.selectedRows.planresources)
			menu.topRows.planresources = nil
			menu.selectedRows.planresources = nil
		end

		-- STATUS
		local statustable = frame:addTable(2, { tabOrder = 6, width = menu.planData.width, x = menu.planData.offsetX, y = 0, reserveScrollBar = false, highlightMode = "off", skipTabChange = true, backgroundID = "solid", backgroundColor = Color["table_background_3d_editor"] })
		statustable:setDefaultColSpan(1, 2)

		local row = statustable:addRow(false, { fixed = true, bgColor = Color["row_title_background"] })
		row[1]:createText(ReadText(1001, 7922), menu.headerTextProperties)

		for _, errorentry in Helper.orderedPairs(menu.criticalerrors) do
			row = statustable:addRow(true, {  })
			row[1]:createText(errorentry, { color = Color["text_criticalerror"], wordwrap = true })
		end
		for _, errorentry in Helper.orderedPairs(menu.errors) do
			row = statustable:addRow(true, {  })
			row[1]:createText(errorentry, { color = Color["text_error"], wordwrap = true })
		end
		for _, warningentry in Helper.orderedPairs(menu.warnings) do
			row = statustable:addRow(true, {  })
			row[1]:createText(warningentry, { color = Color["text_warning"], wordwrap = true })
		end
		if (not next(menu.criticalerrors)) and (not next(menu.errors)) and (not next(menu.warnings)) then
			row = statustable:addRow(true, {  })
			row[1]:createText(ReadText(1001, 7923), { color = Color["text_success"] })
		end

		local row = statustable:addRow(true, {  })
		row[1]:setColSpan(1)
		row[2]:createButton({ helpOverlayID = "stationconfig_closemenu", helpOverlayText = " ",  helpOverlayHighlightOnly = true }):setText(ReadText(1001, 8035), { halign = "center" })
		row[2].handlers.onClick = function () menu.modulesMode = nil; return menu.onCloseElement("back") end

		statustable.properties.y = Helper.viewHeight - statustable:getFullHeight() - Helper.frameBorder
		if menu.planMode == "construction" then
			resourcetable.properties.maxVisibleHeight = statustable.properties.y - resourcetable.properties.y - 2 * Helper.borderSize
			if resourcetable.properties.maxVisibleHeight < resourcetable:getFullHeight() then
				for _, statusbar in ipairs(statusBars) do
					statusbar.properties.width = statusbar.properties.width - Helper.scrollbarWidth
				end
			end

			ftable:addConnection(1, 4, true)
			modulestatustable:addConnection(2, 4)
			resourcetable:addConnection(3, 4)
			statustable:addConnection(4, 4)
		else
			statustable:addConnection(1, 4, true)
		end

		-- guarantee 20% of height for resourcetable
		if menu.planMode == "construction" then
			local maxmoduletableheight = statustable.properties.y - ftable.properties.y - modulestatustable:getFullHeight() - 2 * Helper.borderSize - 0.2 * Helper.viewHeight
			if maxmoduletableheight < ftable.properties.maxVisibleHeight then
				ftable.properties.maxVisibleHeight = maxmoduletableheight
				modulestatustable.properties.y = ftable.properties.y + ftable:getVisibleHeight() + 2 * Helper.borderSize
				resourcetable.properties.y = modulestatustable.properties.y + modulestatustable:getVisibleHeight() + 2 * Helper.borderSize
				resourcetable.properties.maxVisibleHeight = statustable.properties.y - resourcetable.properties.y - 2 * Helper.borderSize
				if resourcetable.properties.maxVisibleHeight < resourcetable:getFullHeight() then
					for _, statusbar in ipairs(statusBars) do
						statusbar.properties.width = statusbar.properties.width - Helper.scrollbarWidth
					end
				end
			end
		end
	else
		-- BUTTONS
		local buttontable = frame:addTable(2, { tabOrder = 7, width = menu.planData.width, height = Helper.scaleY(Helper.standardButtonHeight), x = menu.planData.offsetX, y = Helper.viewHeight - Helper.scaleY(Helper.standardButtonHeight) - Helper.frameBorder, reserveScrollBar = false, backgroundID = "solid", backgroundColor = Color["table_background_3d_editor"] })
		if menu.cancelRequested then
			local row = buttontable:addRow(false, { fixed = true, bgColor = Color["row_title_background"] })
			row[1]:setColSpan(2):createText(ReadText(1001, 9705), menu.headerTextProperties)

			local row = buttontable:addRow(true, { fixed = true, bgColor = Color["row_title_background"] })
			row[1]:createButton({  }):setText(ReadText(1001, 2617), { halign = "center" })
			row[1].handlers.onClick = menu.buttonCancelLoadout
			row[2]:createButton({  }):setText(ReadText(1001, 2618), { halign = "center" })
			row[2].handlers.onClick = menu.buttonCancelCancel
		else
			local row = buttontable:addRow(true, { fixed = true, bgColor = Color["row_title_background"] })
			row[1]:createButton({ helpOverlayID = "stationconfig_confirmloadout", helpOverlayText = " ", helpOverlayHighlightOnly = true, uiTriggerID = "confirmloadout" }):setText(ReadText(1001, 7921), { halign = "center" })
			row[1].handlers.onClick = menu.buttonConfirmLoadout
			row[2]:createButton({  }):setText(ReadText(1001, 7920), { halign = "center" })
			row[2].handlers.onClick = menu.buttonCancel
		end
		buttontable.properties.y = Helper.viewHeight - buttontable:getFullHeight() - Helper.frameBorder

		if menu.loadoutPlanMode == "normal" then
			-- EQUIPMENT
			local ftable = frame:addTable(5, { tabOrder = 3, width = menu.planData.width, maxVisibleHeight = buttontable.properties.y - menu.planData.offsetY, x = menu.planData.offsetX, y = menu.planData.offsetY, reserveScrollBar = true, skipTabChange = true, highlightMode = "off", backgroundID = "solid", backgroundColor = Color["table_background_3d_editor"] })
			ftable:setColWidth(1, Helper.standardTextHeight)
			ftable:setColWidth(2, Helper.standardTextHeight)
			ftable:setColWidth(4, 0.3 * menu.planData.width)
			ftable:setColWidth(5, Helper.standardTextHeight)

			local row = ftable:addRow(false, { bgColor = Color["row_title_background"] })
			row[1]:setColSpan(5):createText(ReadText(1001, 7935), menu.headerTextProperties)

			local removedEquipment = {}
			local currentEquipment = {}
			local newEquipment = {}
			for i, upgradetype in ipairs(Helper.upgradetypes) do
				local slots = menu.constructionplan[menu.loadoutMode].upgradeplan[upgradetype.type]
				local first = true
				for slot, macro in pairs(slots) do
					if first or (not upgradetype.mergeslots) then
						first = false
						if upgradetype.supertype == "group" then
							local data = macro
							local oldslotdata = menu.groups[slot][upgradetype.grouptype]

							if data.macro ~= "" then
								local i = menu.findUpgradeMacro(upgradetype.grouptype, data.macro)
								if not i then
									break
								end
								local upgradeware = menu.upgradewares[upgradetype.grouptype][i]

								if oldslotdata.currentmacro ~= "" then
									local j = menu.findUpgradeMacro(upgradetype.grouptype, oldslotdata.currentmacro)
									if not j then
										break
									end
									local oldupgradeware = menu.upgradewares[upgradetype.grouptype][j]

									if data.macro == oldslotdata.currentmacro then
										if upgradetype.mergeslots then
											menu.insertWare(currentEquipment, upgradeware.ware, (upgradetype.mergeslots and #slots or data.count))
										else
											if oldslotdata.count < data.count then
												menu.insertWare(currentEquipment, upgradeware.ware, oldslotdata.count)
												menu.insertWare(newEquipment, upgradeware.ware, data.count - oldslotdata.count)
											elseif oldslotdata.count > data.count then
												menu.insertWare(currentEquipment, upgradeware.ware, data.count)
												menu.insertWare(removedEquipment, upgradeware.ware, oldslotdata.count - data.count)
											else
												menu.insertWare(currentEquipment, upgradeware.ware, (upgradetype.mergeslots and #slots or data.count))
											end
										end
									else
										menu.insertWare(removedEquipment, oldupgradeware.ware, (upgradetype.mergeslots and #slots or oldslotdata.count))
										menu.insertWare(newEquipment, upgradeware.ware, (upgradetype.mergeslots and #slots or data.count))
									end
								else
									menu.insertWare(newEquipment, upgradeware.ware, (upgradetype.mergeslots and #slots or data.count))
								end
							elseif oldslotdata.currentmacro ~= "" then
								local j = menu.findUpgradeMacro(upgradetype.grouptype, oldslotdata.currentmacro)
								if not j then
									break
								end
								local oldupgradeware = menu.upgradewares[upgradetype.grouptype][j]

								menu.insertWare(removedEquipment, oldupgradeware.ware, (upgradetype.mergeslots and #slots or oldslotdata.count))
							end
						end
					end
				end
			end

			if (#removedEquipment > 0) or (#newEquipment > 0) then
				menu.haschanges = true
			else
				menu.haschanges = false
			end

			if (#removedEquipment > 0) or (#currentEquipment > 0) or (#newEquipment > 0) then
				for _, entry in ipairs(removedEquipment) do
					row = ftable:addRow(true, {  })
					row[1]:setColSpan(5):createText(entry.amount .. ReadText(1001, 42) .. " " .. GetWareData(entry.ware, "name"), { color = Color["text_negative"] })
				end
				for _, entry in ipairs(currentEquipment) do
					row = ftable:addRow(true, {  })
					row[1]:setColSpan(5):createText(entry.amount .. ReadText(1001, 42) .. " " .. GetWareData(entry.ware, "name"))
				end
				for _, entry in ipairs(newEquipment) do
					row = ftable:addRow(true, {  })
					row[1]:setColSpan(5):createText(entry.amount .. ReadText(1001, 42) .. " " .. GetWareData(entry.ware, "name"), { color = Color["text_positive"] })
				end
			else
				row = ftable:addRow(true, {  })
				row[1]:setColSpan(5):createText("--- " .. ReadText(1001, 7936) .. " ---", { halign = "center" } )
			end

			ftable:addConnection(1, 4, true)
			buttontable:addConnection(2, 4)
		else
			buttontable:addConnection(1, 4, true)
		end
	end
end

function  menu.dropdownBuildRule(container, id)
	C.SetContainerBuildMethod(container, id)
	menu.refreshPlan()
	menu.displayMenu()
end

function menu.checkboxSetBuildRuleOverride(container, checked, curglobal)
	if checked then
		C.SetContainerBuildMethod(container, "")
	else
		C.SetContainerBuildMethod(container, curglobal or "default")
	end
	menu.refreshPlan()
	menu.displayMenu()
end

function menu.confirmModuleChangesActive()
	local mapresult = ffi.string(C.GetMissingConstructionPlanBlueprints3(menu.container, menu.holomap, nil, false))
	local plannedresult = ffi.string(C.GetMissingConstructionPlanBlueprints3(menu.container, 0, nil, true))

	local missingmapblueprints = {}
	for macro in string.gmatch(mapresult, "([%w_]*);") do
		missingmapblueprints[macro] = (missingmapblueprints[macro] or 0) + 1
	end
	local missingplannedblueprints = {}
	for macro in string.gmatch(plannedresult, "([%w_]*);") do
		missingplannedblueprints[macro] = (missingplannedblueprints[macro] or 0) + 1
	end

	local mismatch = false
	for k, v in pairs(missingmapblueprints) do
		if v > (missingplannedblueprints[k] or 0) then
			mismatch = true
			break
		end
	end

	return (not mismatch) and (#menu.criticalerrors == 0) and menu.haschanges and GetComponentData(ConvertStringTo64Bit(tostring(menu.buildstorage)), "isplayerowned")
end

function menu.displayModuleInfo(frame)
	local ftable = frame:addTable(2, { tabOrder = 0, width = menu.statsData.width, x = menu.statsData.offsetX, y = 0, reserveScrollBar = false, backgroundID = "solid", backgroundColor = Color["table_background_3d_editor"] })

	local name, infolibrary = GetMacroData(menu.selectedModule.macro, "name", "infolibrary")

	local row = ftable:addRow(false, {  })
	row[1]:setColSpan(2):createText(name, menu.headerCenteredTextProperties)

	local data = GetLibraryEntry(infolibrary, menu.selectedModule.macro)

	if ((infolibrary == "moduletypes_production") and data.allowproduction) or (infolibrary == "moduletypes_processing") then
		local queueduration = 0
		for i, proddata in ipairs(data.products) do
			queueduration = queueduration + proddata.cycle
		end
		-- products
		for i, proddata in ipairs(data.products) do
			local row = ftable:addRow(false, {  })
			local categoryname = ReadText(1001, 1624)
			if #data.products > 1 then
				categoryname = categoryname .. " " .. ReadText(20402, i)
			end
			row[1]:createText(categoryname)
			local amount = (queueduration > 0) and Helper.round(proddata.amount * 3600 / queueduration) or 0
			row[2]:createText(amount .. ReadText(1001, 42) .. " " .. GetWareData(proddata.ware, "name") .. " / " .. ReadText(1001, 102))
			-- resources
			local resources = proddata.resources
			if #resources > 0 then
				for j, resource in ipairs(resources) do
					local row = ftable:addRow(false, {  })
					if j == 1 then
						row[1]:createText("   " .. ReadText(1001, 7403))
					end
					local amount = (queueduration > 0) and Helper.round(resource.amount * 3600 / queueduration) or 0
					row[2]:createText(amount .. ReadText(1001, 42) .. " " .. GetWareData(resource.ware, "name") .. " / " .. ReadText(1001, 102))
				end
			else
				local row = ftable:addRow(false, {  })
				row[1]:createText("   " .. ReadText(1001, 7403))
				row[2]:createText("---")
			end
			ftable:addEmptyRow(Helper.standardTextHeight / 2)
		end

		if infolibrary == "moduletypes_production" then
			-- workforce
			local row = ftable:addRow(false, {  })
			row[1]:createText(ReadText(1001, 7992))
			row[2]:createText(ConvertIntegerString(data.maxworkforce, true, 0, true))
		end
	elseif infolibrary == "moduletypes_storage" then
		if data.storagecapacity > 0 then
			local row = ftable:addRow(false, {  })
			row[1]:createText(ReadText(1001, 9063))
			row[2]:createText(ConvertIntegerString(data.storagecapacity, true, 0, true) .. " " .. ReadText(1001, 110))
		end
	elseif infolibrary == "moduletypes_habitation" then
		if data.workforcecapacity > 0 then
			local row = ftable:addRow(false, {  })
			row[1]:createText(ReadText(1001, 9611))
			row[2]:createText(ConvertIntegerString(data.workforcecapacity, true, 0, true))
		end
		if #data.workforceresources > 0 then
			for i, resource in ipairs(data.workforceresources) do
				local row = ftable:addRow(false, {  })
				if i == 1 then
					row[1]:createText(string.format(ReadText(1001, 7957), ConvertIntegerString(data.workforcecapacity, true, 0, true, false)))
				end
				local amount = Helper.round(resource.amount * 3600 / resource.cycle * data.workforcecapacity / data.workforceproductamount)
				row[2]:createText(amount .. ReadText(1001, 42) .. " " .. resource.name .. " / " .. ReadText(1001, 102))
			end
		end
	end
	-- docks
	if (data.docks_xl > 0) or (data.docks_l > 0) or (data.docks_m > 0) or (data.docks_s > 0) then
		local first = true
		if data.docks_xl > 0 then
			local row = ftable:addRow(false, {  })
			if first then
				first = false
				row[1]:createText(ReadText(1001, 7949))
			end
			row[2]:createText(data.docks_xl .. ReadText(1001, 42) .. " " .. ReadText(1001, 7950))
		end
		if data.docks_l > 0 then
			local row = ftable:addRow(false, {  })
			if first then
				first = false
				row[1]:createText(ReadText(1001, 7949))
			end
			row[2]:createText(data.docks_l .. ReadText(1001, 42) .. " " .. ReadText(1001, 7951))
		end
		if data.docks_m > 0 then
			local row = ftable:addRow(false, {  })
			if first then
				first = false
				row[1]:createText(ReadText(1001, 7949))
			end
			row[2]:createText(data.docks_m .. ReadText(1001, 42) .. " " .. ReadText(1001, 7952))
		end
		if data.docks_s > 0 then
			local row = ftable:addRow(false, {  })
			if first then
				first = false
				row[1]:createText(ReadText(1001, 7949))
			end
			row[2]:createText(data.docks_s .. ReadText(1001, 42) .. " " .. ReadText(1001, 7953))
		end
	end
	-- launchtubes
	if (data.launchtubes_m > 0) or (data.launchtubes_s > 0) then
		local first = true
		if data.launchtubes_m > 0 then
			local row = ftable:addRow(false, {  })
			if first then
				first = false
				row[1]:createText(ReadText(1001, 7954))
			end
			row[2]:createText(data.launchtubes_m .. ReadText(1001, 42) .. " " .. ReadText(1001, 7955))
		end
		if data.launchtubes_s > 0 then
			local row = ftable:addRow(false, {  })
			if first then
				first = false
				row[1]:createText(ReadText(1001, 7954))
			end
			row[2]:createText(data.launchtubes_s .. ReadText(1001, 42) .. " " .. ReadText(1001, 7956))
		end
	end
	-- ship storage
	if data.shipstoragecapacity > 0 then
		local row = ftable:addRow(false, {  })
		row[1]:createText(ReadText(1001, 9612))
		row[2]:createText(data.shipstoragecapacity)
	end

	local counts = {}
	for _, upgradetype in ipairs(Helper.upgradetypes) do
		if upgradetype.supertype == "group" then
			counts[upgradetype.type] = 0
			if menu.selectedModule.upgradeplan then
				for slot, group in pairs(menu.selectedModule.upgradeplan[upgradetype.type]) do
					if upgradetype.mergeslots then
						counts[upgradetype.type] = counts[upgradetype.type] + ((menu.selectedModule.upgradeplan[upgradetype.type][slot].count > 0) and 1 or 0)
					else
						counts[upgradetype.type] = counts[upgradetype.type] + menu.selectedModule.upgradeplan[upgradetype.type][slot].count
					end
				end
			end
		end
	end

	-- turrets
	local numturrets = C.GetNumUpgradeSlots(menu.selectedModule.component, menu.selectedModule.macro, "turret")
	if numturrets > 0 then
		local row = ftable:addRow(false, {  })
		row[1]:createText(ReadText(1001, 1319))

		row[2]:createText(counts.turretgroup .. " / " .. tonumber(numturrets))
	end

	-- shields
	local numshields = C.GetNumUpgradeSlots(menu.selectedModule.component, menu.selectedModule.macro, "shield")
	if numshields > 0 then
		local row = ftable:addRow(false, {  })
		row[1]:createText(ReadText(1001, 1317))

		row[2]:createText(counts.shieldgroup .. " / " .. tonumber(numshields))
	end

	ftable.properties.y = Helper.viewHeight - ftable:getVisibleHeight() - menu.statsData.offsetY
end

function menu.displayModuleRow(ftable, index, entry, added, removed)
	local isextended = menu.isEntryExtended(menu.container, (removed and "rem" or "") .. index)

	local color = Color["text_normal"]
	if removed then
		color = Color["text_negative"]
	elseif added then
		color = Color["text_positive"]
	end

	local row = ftable:addRow({ ismodule = true, idx = entry.idx, module = entry, removed = removed }, {  })
	if removed or added then
		row[1]:createButton({ height = Helper.standardTextHeight }):setText(isextended and "-" or "+", { halign = "center" })
		row[1].handlers.onClick = function () return menu.buttonExtendEntry((removed and "rem" or "") .. index, row.index) end
	end
	local name = GetMacroData(entry.macro, "name")
	if entry.component ~= 0 then
		name = ffi.string(C.GetComponentName(entry.component))
	end
	row[2]:setColSpan(2):createText("   " .. name, { color = color, mouseOverText = menu.getLoadoutSummary(entry.upgradeplan) })
	local ismissingresources = false
	if IsComponentConstruction(ConvertStringTo64Bit(tostring(entry.component))) then
		local buildingprocessor = GetComponentData(menu.container, "buildingprocessor")
		ismissingresources = GetComponentData(buildingprocessor, "ismissingresources")
	end
	row[4]:createText(function () return menu.getBuildProgress(entry.component, added, removed) end, { halign = "right", color = color, mouseOverText = ismissingresources and ReadText(1026, 3223) or "" })
	local active = false
	for i, upgradetype in ipairs(Helper.upgradetypes) do
		if upgradetype.supertype == "macro" then
			if C.GetNumUpgradeSlots(entry.component, entry.macro, upgradetype.type) > 0 then
				active = true
				break
			end
		end
	end
	if active and (not removed) then
		row[5]:createButton({ height = Helper.standardTextHeight }):setIcon("menu_edit")
		row[5].handlers.onClick = function () return menu.buttonEditLoadout(entry) end
	end
	if (not removed) and (not added) and (not active) then
		row[1]:setBackgroundColSpan(5)
	elseif (not removed) and (not added) then
		row[1]:setBackgroundColSpan(4)
	elseif (not active) or removed then
		row[2]:setBackgroundColSpan(4)
	else
		row[2]:setBackgroundColSpan(3)
	end

	local ware = GetMacroData(entry.macro, "ware")
	if not ware then
		DebugError("No ware defined for module macro '" .. entry.macro .. "'. [Florian]")
	else
		if removed or added then
			if isextended then
				for _, resource in ipairs(entry.resources) do
					local row = ftable:addRow(true, {  })
					row[2]:setColSpan(2):createText("      " .. GetWareData(resource.ware, "name"))
					row[4]:setColSpan(2):createText(resource.amount, { halign = "right" })
				end
			end
		end
	end

	return row
end

function menu.findWareIdx(array, ware)
	for i, v in ipairs(array) do
		if v.ware == ware then
			return i
		end
	end
end

function menu.insertWare(array, ware, count)
	local i = menu.findWareIdx(array, ware)
	if i then
		array[i].amount = array[i].amount + count
	else
		table.insert(array, { ware = ware, amount = count })
	end
end

function menu.getLoadoutSummary(upgradeplan)
	local wareAmounts = {}

	for i, upgradetype in ipairs(Helper.upgradetypes) do
		local slots = upgradeplan[upgradetype.type]
		local first = true
		for slot, macro in pairs(slots) do
			if first or (not upgradetype.mergeslots) then
				first = false
				if upgradetype.supertype == "group" then
					local data = macro
					if data.macro ~= "" then
						local i = menu.findUpgradeMacro(upgradetype.grouptype, data.macro)
						if not i then
							break
						end
						local upgradeware = menu.upgradewares[upgradetype.grouptype][i]
						menu.insertWare(wareAmounts, upgradeware.ware, (upgradetype.mergeslots and #slots or data.count))
					end
				end
			end
		end
	end

	local summary = (#wareAmounts > 0) and (ReadText(1001, 7935) .. ReadText(1001, 120)) or ""
	for _, entry in ipairs(wareAmounts) do
		summary = summary .. "\n" .. entry.amount .. ReadText(1001, 42) .. " " .. GetWareData(entry.ware, "name")
	end
	return summary
end

function menu.getBuildProgress(component, added, removed)
	local buildprogress = (removed or (not added)) and 100 or 0
	if IsComponentConstruction(ConvertStringTo64Bit(tostring(component))) then
		buildprogress = math.floor(C.GetCurrentBuildProgress(menu.container))
		if removed then
			buildprogress = 100 - buildprogress
			menu.refresh = menu.refresh or (getElapsedTime() + 10.0)
		end

		local buildingprocessor = GetComponentData(menu.container, "buildingprocessor")
		local ismissingresources, buildcomponents, recyclingcomponents = GetComponentData(buildingprocessor, "ismissingresources", "buildcomponents", "recyclingcomponents")
		local found = false
		for _, buildcomponent in ipairs(removed and recyclingcomponents or buildcomponents) do
			if ConvertIDTo64Bit(buildcomponent) == component then
				found = true
				break
			end
		end
		if found then
			buildprogress = (ismissingresources and (ColorText["text_warning"] .. "\27[warning](") or "(") .. ConvertTimeString(C.GetBuildProcessorEstimatedTimeLeft(ConvertIDTo64Bit(buildingprocessor)), "%h:%M:%S") .. ")\27X  " .. buildprogress
		else
			buildprogress = "-"
		end
	elseif added then
		if C.IsComponentOperational(component) then
			buildprogress = 100
		else
			buildprogress = "-"
		end
	end

	return buildprogress .. " %"
end

function menu.wareNameSorter(a, b)
	local aname = GetWareData(a.ware, "name")
	local bname = GetWareData(b.ware, "name")

	return aname < bname
end

function menu.displayMainFrame()
	Helper.removeAllWidgetScripts(menu, config.mainLayer)

	menu.mainFrame = Helper.createFrameHandle(menu, {
		layer = config.mainLayer,
		standardButtons = { back = true, close = true, help = true  },
		width = Helper.viewWidth,
		height = Helper.viewHeight,
		x = 0,
		y = 0,
	})

	-- right sidebar
	Helper.createRightSideBar(menu.mainFrame, menu.container, true, "construction", menu.buttonRightBar, menu.buttonRightBarSelf)

	-- title bar
	menu.createTitleBar(menu.mainFrame)

	-- construction map
	menu.mainFrame:addRenderTarget({width = menu.mapData.width, height = menu.mapData.height, x = menu.mapData.offsetX, y = menu.mapData.offsetY, scaling = false, alpha = 100})

	menu.mainFrame:display()
end

function menu.displayContextFrame(mode, width, x, y)
	PlaySound("ui_positive_click")
	menu.contextMode = { mode = mode, width = width, x = x, y = y }
	if mode == "saveCP" then
		menu.createCPSaveContext()
	elseif mode == "removeCP" then
		menu.createCPRemoveContext()
	elseif mode == "importCP" then
		menu.createCPImportContext()
	elseif mode == "exportCP" then
		menu.createCPExportContext()
	elseif mode == "saveLoadout" then
		menu.createLoadoutSaveContext()
	elseif mode == "equipment" then
		menu.createEquipmentContext()
	elseif mode == "module" then
		menu.createModuleContext()
	elseif mode == "userquestion" then
		menu.createUserQuestionContext()
	elseif mode == "overwritequestion" then
		menu.createOverwriteQuestionContext()
	elseif mode == "settings" then
		menu.createSettingsContext()
	elseif mode == "modulefilter" then
		menu.createModuleFilterContext()
	elseif mode == "slot" then
		menu.createSlotContext()
	end
end

function menu.createSlotContext()
	Helper.removeAllWidgetScripts(menu, config.contextLayer)

	menu.contextFrame = Helper.createFrameHandle(menu, {
		layer = config.contextLayer,
		standardButtons = { close = true },
		width = menu.contextMode.width,
		x = menu.contextMode.x,
		y = menu.contextMode.y,
		autoFrameHeight = true,
	})
	menu.contextFrame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	local ftable = menu.contextFrame:addTable(1, { tabOrder = 5, reserveScrollBar = false, highlightMode = "off" })

	local upgradetype = Helper.findUpgradeType(menu.contextData.upgradetype)
	local upgradetype2 = Helper.findUpgradeTypeByGroupType(upgradetype.type)
	local slotdata
	if menu.upgradetypeMode == "turretgroup" then
		slotdata = menu.groups[menu.currentSlot][upgradetype2.grouptype]
	end
	local plandata
	if menu.upgradetypeMode == "turretgroup" then
		plandata = menu.constructionplan[menu.loadoutMode].upgradeplan[upgradetype2.type][menu.currentSlot]
	end
	local prefix = ""
	if upgradetype.mergeslots then
		prefix = #menu.slots[upgradetype.type] .. ReadText(1001, 42) .. " "
	end

	if menu.upgradetypeMode == "turretgroup" then
		local name = upgradetype2.text.default
		if plandata.macro == "" then
			if slotdata.slotsize ~= "" then
				name = upgradetype2.text[slotdata.slotsize]
			end
		else
			name = GetMacroData(plandata.macro, "name")
		end
		if not upgradetype2.mergeslots then
			local minselect = (plandata.macro == "") and 0 or 1
			local maxselect = (plandata.macro == "") and 0 or slotdata.total

			local scale = {
				min       = 0,
				minselect = minselect,
				max       = slotdata.total,
				maxselect = maxselect,
				start     = math.max(minselect, math.min(maxselect, plandata.count)),
				step      = 1,
				suffix    = "",
				exceedmax = false
			}

			local row = ftable:addRow(true)
			row[1]:createSliderCell({ height = Helper.headerRow1Height, valueColor = Color["slider_value"], min = scale.min, minSelect = scale.minselect, max = scale.max, maxSelect = scale.maxselect, start = scale.start, step = scale.step, suffix = scale.suffix, exceedMaxValue = scale.exceedmax }):setText(name, { font = Helper.headerRow1Font, fontsize = Helper.headerRow1FontSize })
			row[1].handlers.onSliderCellChanged = function (_, ...) return menu.slidercellSelectAmount(upgradetype2.type, menu.currentSlot, nil, row.index, ...) end
		else
			local row = ftable:addRow(nil)
			row[1]:createText(name)
		end
	end

	for k, macro in ipairs(slotdata.possiblemacros) do
		local name = prefix .. GetMacroData(macro, "name")

		local color = Color["text_normal"]
		if (macro == slotdata.currentmacro) and (macro ~= plandata.macro) then
			color = Color["text_negative"]
		elseif (macro == plandata.macro) then
			color = Color["text_positive"]
		end

		local row = ftable:addRow(true)
		row[1]:createButton({ height = Helper.standardTextHeight }):setText(name, { color = color })
		if menu.upgradetypeMode == "turretgroup" then
			row[1].handlers.onClick = function () return menu.buttonSelectGroupUpgrade(upgradetype2.type, menu.currentSlot, macro, nil, nil, row.index) end
		end
	end

	if upgradetype.allowempty then
		local name = ReadText(1001, 7906)

		local color = Color["text_normal"]
		if ("" == slotdata.currentmacro) and ("" ~= plandata) then
			color = Color["text_negative"]
		elseif ("" == plandata) then
			color = Color["text_positive"]
		end

		local row = ftable:addRow(true)
		row[1]:createButton({ height = Helper.standardTextHeight, helpOverlayID = "turretgroup_empty", helpOverlayText = " ", helpOverlayHighlightOnly = true }):setText(name, { color = color })
		if menu.upgradetypeMode == "turretgroup" then
			row[1].handlers.onClick = function () return menu.buttonSelectGroupUpgrade(upgradetype2.type, menu.currentSlot, "", nil, nil, row.index) end
		end
	end

	ftable:setTopRow(menu.topRows.context)
	ftable:setSelectedRow(menu.selectedRows.context)
	menu.topRows.context = nil
	menu.selectedRows.context = nil

	menu.contextFrame:display()
end

function menu.createUserQuestionContext()
	Helper.removeAllWidgetScripts(menu, config.contextLayer)

	menu.contextFrame = Helper.createFrameHandle(menu, {
		layer = config.contextLayer,
		standardButtons = {},
		width = menu.contextMode.width,
		x = menu.contextMode.x,
		y = menu.contextMode.y,
		autoFrameHeight = true,
	})
	menu.contextFrame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	local ftable = menu.contextFrame:addTable(5, { tabOrder = 5, reserveScrollBar = false, highlightMode = "off" })

	local row = ftable:addRow(false, { fixed = true })
	row[1]:setColSpan(5):createText(ReadText(1001, 8035), Helper.headerRowCenteredProperties)

	local row = ftable:addRow(false, { fixed = true })
	row[1]:setColSpan(5):createText(ReadText(1001, 9705))

	local row = ftable:addRow(false, { fixed = true })
	row[1]:setColSpan(5):createText("")

	local row = ftable:addRow(true, { fixed = true })
	row[2]:createButton():setText(ReadText(1001, 2617), { halign = "center" })
	row[2].handlers.onClick = menu.resetAndCloseMenu
	row[4]:createButton():setText(ReadText(1001, 2618), { halign = "center" })
	row[4].handlers.onClick = menu.closeContextMenu
	ftable:setSelectedCol(4)

	menu.contextFrame:display()
end

function menu.resetAndCloseMenu()
	menu.resetDefaultLoadout()
	if menu.contextData.dueToClose then
		menu.closeMenu(menu.contextData.dueToClose)
	elseif menu.contextData.othermenu then
		Helper.closeMenuAndOpenNewMenu(menu, menu.contextData.othermenu, nil, true, true)
		menu.cleanup()
	end
end

function menu.createOverwriteQuestionContext()
	Helper.removeAllWidgetScripts(menu, config.contextLayer)

	menu.contextFrame = Helper.createFrameHandle(menu, {
		layer = config.contextLayer,
		standardButtons = {},
		width = menu.contextMode.width,
		x = menu.contextMode.x,
		y = menu.contextMode.y,
		autoFrameHeight = true,
	})
	menu.contextFrame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	local ftable = menu.contextFrame:addTable(5, { tabOrder = 5, reserveScrollBar = false, highlightMode = "off" })

	local row = ftable:addRow(false, { fixed = true })
	row[1]:setColSpan(5):createText((menu.contextData.mode == "export") and ReadText(1001, 7977) or ReadText(1001, 7985), Helper.headerRowCenteredProperties)

	if menu.contextData.mode == "export" then
		local canoverwrite, cansaveasnew, source = menu.checkCPNameID()
		if canoverwrite then
			local row = ftable:addRow(false, { fixed = true })
			row[1]:setColSpan(5):createText(string.format(ReadText(1001, 7978), menu.currentCPName), { wordwrap = true })
		end
		local filename = utf8.gsub(menu.currentCPName, "[^%w_%-%() ]", "_")
		if menu.importableplansbyfile[filename] then
			local row = ftable:addRow(false, { fixed = true })
			row[1]:setColSpan(5):createText(string.format(ReadText(1001, 7984), filename), { wordwrap = true })
		end
	else
		local id = menu.contextData.selectedEntry.id
		if menu.constructionplansbyID[id] then
			local row = ftable:addRow(false, { fixed = true })
			row[1]:setColSpan(5):createText(string.format(ReadText(1001, 7978), menu.constructionplansbyID[id].name), { wordwrap = true })
		end
	end

	local row = ftable:addRow(false, { fixed = true })
	row[1]:setColSpan(5):createText("")

	local row = ftable:addRow(true, { fixed = true })
	row[2]:createButton():setText(ReadText(1001, 14), { halign = "center" })
	row[2].handlers.onClick = (menu.contextData.mode == "export") and function () menu.buttonExport(true) end or function () menu.buttonImport(true) end
	row[4]:createButton():setText(ReadText(1001, 64), { halign = "center" })
	row[4].handlers.onClick = function () return menu.displayContextFrame((menu.contextData.mode == "export") and "exportCP" or "importCP", menu.titleData.dropdownWidth + 7 * (menu.titleData.height + Helper.borderSize), menu.titleData.offsetX + menu.titleData.nameWidth + Helper.borderSize, menu.titleData.offsetY + menu.titleData.height + Helper.borderSize) end
	ftable:setSelectedCol(4)

	menu.contextFrame:display()
end

function menu.createModuleContext()
	Helper.removeAllWidgetScripts(menu, config.contextLayer)

	menu.contextFrame = Helper.createFrameHandle(menu, {
		layer = config.contextLayer,
		standardButtons = { close = true },
		width = menu.contextMode.width,
		x = menu.contextMode.x,
		y = menu.contextMode.y,
		autoFrameHeight = true,
	})
	menu.contextFrame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	local ftable = menu.contextFrame:addTable(1, { tabOrder = 5, reserveScrollBar = false, highlightMode = "off" })

	local row = ftable:addRow(false, { fixed = true })
	row[1]:createText(GetMacroData(ffi.string(menu.contextData.item.macro), "name"), Helper.subHeaderTextProperties)

	local active = false
	for i, upgradetype in ipairs(Helper.upgradetypes) do
		if upgradetype.supertype == "macro" then
			if C.GetNumUpgradeSlots(menu.contextData.item.component, menu.contextData.item.macro, upgradetype.type) > 0 then
				active = true
				break
			end
		end
	end
	if active then
		local row = ftable:addRow(true, { fixed = true })
		row[1]:createButton({ active = true, bgColor = Color["button_background_hidden"], helpOverlayID = "stationconfig_editloadout", helpOverlayText = " ",  helpOverlayHighlightOnly = true, uiTriggerID = "editloadout" }):setText(ReadText(1001, 7938))
		row[1].handlers.onClick = function () return menu.buttonEditLoadout(menu.contextData.item) end
	end

	local row = ftable:addRow(true, { fixed = true })
	row[1]:createButton({ bgColor = Color["button_background_hidden"] }):setText(ReadText(1001, 2400))
	row[1].handlers.onClick = function () return menu.buttonContextEncyclopedia({ type = "module", macro = menu.contextData.item.macro }) end

	local row = ftable:addRow(true, { fixed = true })
	row[1]:createButton({ active = not menu.contextData.item.isfixed, bgColor = Color["button_background_hidden"], helpOverlayID = "stationconfig_resetrotation", helpOverlayText = " ", helpOverlayHighlightOnly = true, uiTriggerID = "resetrotation" }):setText(ReadText(1001, 7999))
	row[1].handlers.onClick = function () return menu.buttonResetModuleRotation(menu.contextData.item) end

	local row = ftable:addRow(true, { fixed = true })
	local macro = menu.contextData.item.macro
	local active = not menu.contextData.item.isfixed
	local mouseovertext = ""
	if active then
		if IsMacroClass(macro, "ventureplatform") or (IsMacroClass(macro, "dockarea") and GetMacroData(macro, "isventuremodule")) then
			local ware = GetMacroData(macro, "ware")
			local availableamount = math.max(0, OnlineGetUserItemAmount(ware) - (menu.externalUsedLimitedModules[macro] or 0) - (menu.usedLimitedModules[macro] or 0))
			if availableamount < 1 then
				active = false
				mouseovertext = menu.ventureModuleUnavailableMouseOverText()
			end
		end
	end
	row[1]:createButton({ active = active, bgColor = Color["button_background_hidden"], mouseOverText = mouseovertext }):setText(ReadText(1001, 7947))
	row[1].handlers.onClick = function () return menu.buttonCopyModule(menu.contextData.item, false) end

	local row = ftable:addRow(true, { fixed = true })
	local active = not menu.contextData.item.isfixed
	local mouseovertext = ""
	if active then
		local usedLimitedModulesInSequence = {}
		local n = C.GetNumUsedLimitedModulesFromSubsequence(menu.holomap, menu.contextData.item.idx)
		if n > 0 then
			local buf = ffi.new("UIMacroCount[?]", n)
			n = C.GetUsedLimitedModulesFromSubsequence(buf, n, menu.holomap, menu.contextData.item.idx)
			for i = 0, n - 1 do
				local macro = ffi.string(buf[i].macro)
				usedLimitedModulesInSequence[macro] = buf[i].amount
			end
		end

		for macro, amount in pairs(usedLimitedModulesInSequence) do
			local ware = GetMacroData(macro, "ware")
			local availableamount = math.max(0, OnlineGetUserItemAmount(ware) - (menu.externalUsedLimitedModules[macro] or 0) - (menu.usedLimitedModules[macro] or 0))
			if amount > availableamount then
				active = false
				mouseovertext = menu.ventureModuleUnavailableMouseOverText()
				break
			end
		end
	end
	row[1]:createButton({ active = active, bgColor = Color["button_background_hidden"], mouseOverText = mouseovertext }):setText(ReadText(1001, 7948))
	row[1].handlers.onClick = function () return menu.buttonCopyModule(menu.contextData.item, true) end

	local row = ftable:addRow(true, { fixed = true })
	row[1]:createButton({ active = not menu.contextData.item.isfixed, bgColor = Color["button_background_hidden"] }):setText(ReadText(1001, 7937))
	row[1].handlers.onClick = function () return menu.buttonRemoveModule(menu.contextData.item, false) end

	local row = ftable:addRow(true, { fixed = true })
	row[1]:createButton({ active = not menu.contextData.item.isfixed, bgColor = Color["button_background_hidden"] }):setText(ReadText(1001, 7995))
	row[1].handlers.onClick = function () return menu.buttonRemoveModule(menu.contextData.item, true) end

	if ftable.properties.y + ftable:getFullHeight() > Helper.viewHeight - menu.contextFrame.properties.y then
		menu.contextFrame.properties.y = Helper.viewHeight - ftable.properties.y - ftable:getFullHeight() - Helper.frameBorder
	end

	menu.contextFrame:display()
end

function menu.createEquipmentContext()
	Helper.removeAllWidgetScripts(menu, config.contextLayer)

	menu.contextFrame = Helper.createFrameHandle(menu, {
		layer = config.contextLayer,
		standardButtons = { close = true },
		width = menu.contextMode.width,
		x = menu.contextMode.x,
		y = menu.contextMode.y,
		autoFrameHeight = true,
	})
	menu.contextFrame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	local ftable = menu.contextFrame:addTable(1, { tabOrder = 5, reserveScrollBar = false, highlightMode = "off" })

	local row = ftable:addRow(false, { fixed = true })
	row[1]:createText(menu.selectedUpgrade.name, Helper.subHeaderTextProperties)

	local row = ftable:addRow(true, { fixed = true })
	row[1]:createButton({ active = true, bgColor = Color["button_background_hidden"] }):setText(ReadText(1001, 2400))
	row[1].handlers.onClick = function () return menu.buttonContextEncyclopedia(menu.selectedUpgrade) end

	menu.contextFrame:display()
end

function menu.checkCPNameID()
	local ismasterversion = C.IsMasterVersion()
	local canoverwrite = false
	local cansaveasnew = false
	local source = ""
	if menu.currentCPID then
		local found = false
		for _, plan in ipairs(menu.constructionplans) do
			if plan.id == menu.currentCPID then
				found = true
				source = plan.source
				if (source == "local") or ((source == "library") and (not ismasterversion)) then
					canoverwrite = true
				end
				menu.currentCPName = plan.name
				break
			end
		end
		if not found then
			menu.currentCPID = nil
		end
	end
	if (not menu.currentCPID) and menu.currentCPName and (menu.currentCPName ~= "") then
		cansaveasnew = true
		for _, plan in ipairs(menu.constructionplans) do
			if plan.name == menu.currentCPName then
				source = plan.source
				if (source == "local") or ((source == "library") and (not ismasterversion)) then
					canoverwrite = true
				end
				cansaveasnew = false
				menu.currentCPID = plan.id
				break
			end
		end
	end

	return canoverwrite, cansaveasnew, source
end

function menu.createCPSaveContext()
	Helper.removeAllWidgetScripts(menu, config.contextLayer)

	menu.contextFrame = Helper.createFrameHandle(menu, {
		layer = config.contextLayer,
		standardButtons = {},
		width = menu.contextMode.width,
		x = menu.contextMode.x,
		y = menu.contextMode.y,
		autoFrameHeight = true,
	})
	menu.contextFrame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	local ftable = menu.contextFrame:addTable(3, { tabOrder = 6, reserveScrollBar = false })
	ftable:setDefaultCellProperties("button", { height = Helper.standardTextHeight })
	ftable:setDefaultComplexCellProperties("button", "text", { fontsize = Helper.standardFontSize, halign = "center" })

	local canoverwrite, cansaveasnew, source = menu.checkCPNameID()

	local row = ftable:addRow(nil, { fixed = true })
	row[1]:setColSpan(3):createText(ReadText(1001, 7969), Helper.headerRowCenteredProperties)

	local row = ftable:addRow(true, { fixed = true })
	menu.contextMode.nameEditBox = row[1]:setColSpan(3):createEditBox({ height = Helper.headerRow1Height, defaultText = ReadText(1001, 7979) }):setText(menu.currentCPName or "", { fontsize = Helper.headerRow1FontSize, x = Helper.standardTextOffsetx })
	row[1].handlers.onTextChanged = menu.editboxCPNameUpdateText

	row = ftable:addRow(true, { fixed = true })
	row[1]:createButton({ active = menu.checkOverwriteActive, mouseOverText = ReadText(1026, 7906) }):setText(ReadText(1001, 7907), {  })
	row[1].handlers.onClick = function () return menu.buttonSave(true) end
	row[2]:createButton({ active = menu.checkSaveNewActive, mouseOverText = ReadText(1026, 7907) }):setText(ReadText(1001, 7909), {  })
	row[2].handlers.onClick = function () return menu.buttonSave(false) end
	row[3]:createButton({  }):setText(ReadText(1001, 64))
	row[3].handlers.onClick = menu.closeContextMenu

	menu.contextFrame:display()
end

function menu.createCPRemoveContext()
	Helper.removeAllWidgetScripts(menu, config.contextLayer)

	menu.contextFrame = Helper.createFrameHandle(menu, {
		layer = config.contextLayer,
		standardButtons = {},
		width = menu.contextMode.width,
		x = menu.contextMode.x,
		y = menu.contextMode.y,
		autoFrameHeight = true,
	})
	menu.contextFrame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	local ftable = menu.contextFrame:addTable(6, { tabOrder = 5, defaultInteractiveObject = true })
	ftable:setColWidth(1, Helper.scaleY(Helper.standardButtonHeight), false)
	ftable:setColWidthPercent(5, 25, false)
	ftable:setColWidthPercent(6, 25, false)

	local row = ftable:addRow(false, { fixed = true })
	row[1]:setColSpan(6):createText(ReadText(1001, 11924), Helper.headerRowCenteredProperties)

	local row = ftable:addRow(false, { fixed = true })
	row[1]:setColSpan(6):createText(ReadText(1001, 11925), { wordwrap = true })

	ftable:addEmptyRow()

	local row = ftable:addRow(true, { fixed = true })
	row[1]:createCheckBox(function () return menu.contextData.saveOption == true end, { height = Helper.standardButtonHeight })
	row[1].handlers.onClick = function () menu.contextData.saveOption = not menu.contextData.saveOption end
	row[2]:setColSpan(3):createButton({ bgColor = Color["button_background_hidden"] }):setText(ReadText(1001, 9711))
	row[2].handlers.onClick = function () menu.contextData.saveOption = not menu.contextData.saveOption end
	row[5]:createButton({  }):setText(ReadText(1001, 2821), { halign = "center" })
	row[5].handlers.onClick = menu.buttonCPRemoveConfirm
	row[6]:createButton({  }):setText(ReadText(1001, 64), { halign = "center" })
	row[6].handlers.onClick = menu.buttonCPRemoveCancel
	ftable:setSelectedCol(6)

	menu.contextFrame:display()
end

function menu.buttonCPRemoveConfirm()
	__CORE_DETAILMONITOR_USERQUESTION[menu.contextData.id] = menu.contextData.saveOption
	C.RemoveConstructionPlan("local", menu.contextData.cpid)
	if menu.contextData.cpid == menu.currentCPID then
		menu.currentCPID = nil
		menu.currentCPName = nil
	end
	for i, plan in ipairs(menu.constructionplans) do
		if plan.id == menu.contextData.cpid then
			table.remove(menu.constructionplans, i)
			break
		end
	end
	menu.refreshTitleBar()
	menu.closeContextMenu()
end

function menu.buttonCPRemoveCancel()
	menu.refreshTitleBar()
	menu.closeContextMenu()
end

function menu.createSettingsContext()
	Helper.removeAllWidgetScripts(menu, config.contextLayer)

	menu.contextFrame = Helper.createFrameHandle(menu, {
		layer = config.contextLayer,
		standardButtons = {},
		width = menu.contextMode.width,
		x = menu.contextMode.x,
		y = menu.contextMode.y,
		autoFrameHeight = true,
	})
	menu.contextFrame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	local ftable = menu.contextFrame:addTable(3, { tabOrder = 6, reserveScrollBar = false })
	ftable:setColWidth(1, Helper.standardTextHeight)
	ftable:setColWidthPercent(3, 50)
	ftable:setDefaultCellProperties("button", { height = Helper.standardTextHeight })

	-- settings
	local row = ftable:addRow(nil, { fixed = true })
	row[1]:setColSpan(3):createText(ReadText(1001, 11904), Helper.headerRowCenteredProperties)
	-- environment
	local row = ftable:addRow(true, { fixed = true })
	row[1]:createCheckBox(__CORE_DETAILMONITOR_STATIONBUILD.environment, { height = Helper.standardTextHeight })
	row[1].handlers.onClick = function(_, checked) __CORE_DETAILMONITOR_STATIONBUILD.environment = checked; menu.applySettings() end
	row[2]:setColSpan(2):createText(ReadText(1001, 11905), { mouseOverText = ReadText(1026, 7927) })
	-- gizmo
	local row = ftable:addRow(true, { fixed = true })
	row[1]:createCheckBox(__CORE_DETAILMONITOR_STATIONBUILD.gizmo, { height = Helper.standardTextHeight })
	row[1].handlers.onClick = function (_, checked) __CORE_DETAILMONITOR_STATIONBUILD.gizmo = checked; menu.applySettings() end
	row[2]:setColSpan(2):createText(ReadText(1001, 11920), { mouseOverText = ReadText(1026, 7932) })
	-- module overlap
	local row = ftable:addRow(true, { fixed = true })
	row[1]:createCheckBox(__CORE_DETAILMONITOR_STATIONBUILD.moduleoverlap, { height = Helper.standardTextHeight })
	row[1].handlers.onClick = function(_, checked) __CORE_DETAILMONITOR_STATIONBUILD.moduleoverlap = checked; menu.applySettings() end
	row[2]:setColSpan(2):createText(ReadText(1001, 11907), { mouseOverText = ReadText(1026, 7928) })
	ftable:addEmptyRow(Helper.standardTextHeight / 2)
	-- rotation angle snap
	local row = ftable:addRow(true, { fixed = true })
	row[1]:setColSpan(3):createSliderCell({ min = 0, minSelect = config.discreteAngleSlider.min, max = config.discreteAngleSlider.max, start = math.max(config.discreteAngleSlider.min, math.min(config.discreteAngleSlider.max, __CORE_DETAILMONITOR_STATIONBUILD.discreteanglestep)), step = config.discreteAngleSlider.step, mouseOverText = ReadText(1026, 7926), height = Helper.standardTextHeight, suffix = ReadText(1001, 109), hideMaxValue = true }):setText(ReadText(1001, 7998))
	row[1].handlers.onSliderCellChanged = function (_, value) __CORE_DETAILMONITOR_STATIONBUILD.discreteanglestep = value; menu.applySettings() end
	row[1].handlers.onSliderCellActivated = function() menu.noupdate = true end
	row[1].handlers.onSliderCellDeactivated = function() menu.noupdate = false end

	ftable:addEmptyRow()

	-- options
	local row = ftable:addRow(nil, { fixed = true })
	row[1]:setColSpan(3):createText(ReadText(1001, 11914), Helper.headerRowCenteredProperties)
	-- shuffle
	local row = ftable:addRow(true, { fixed = true })
	row[1]:setColSpan(2):createText(ReadText(1001, 11923) .. ReadText(1001, 120))
	row[3]:createDropDown(menu.connectionmoduleraces, { startOption = menu.shuffleconnectionrace })
	row[3].handlers.onDropDownActivated = function() menu.noupdate = true end
	row[3].handlers.onDropDownConfirmed = function (_, id) menu.shuffleconnectionrace = id; menu.noupdate = false end
	local row = ftable:addRow(true, { fixed = true })
	row[1]:setColSpan(2):createButton({ helpOverlayID = "shuffle_modules", helpOverlayText = " ", helpOverlayHighlightOnly = true, mouseOverText = ReadText(1026, 7910) }):setText(ReadText(1001, 11911), { halign = "center" })
	row[1].handlers.onClick = function () C.ShuffleMapConstructionPlan2(menu.holomap, false, (menu.shuffleconnectionrace == "all") and "" or menu.shuffleconnectionrace); menu.refreshPlan(); menu.displayMenu() end

	menu.contextFrame:display()
end

function menu.createModuleFilterContext()
	Helper.removeAllWidgetScripts(menu, config.contextLayer)

	menu.contextFrame = Helper.createFrameHandle(menu, {
		layer = config.contextLayer,
		standardButtons = { close = true },
		width = menu.contextMode.width,
		x = menu.contextMode.x,
		y = menu.contextMode.y,
		autoFrameHeight = true,
	})
	menu.contextFrame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	local ftable = menu.contextFrame:addTable(2, { tabOrder = 6, reserveScrollBar = false })
	ftable:setColWidth(1, Helper.standardTextHeight)

	local row = ftable:addRow(true, { fixed = true })
	row[1]:createCheckBox(menu.checkAllRacesSelected, { height = Helper.standardTextHeight })
	row[1].handlers.onClick = menu.checkboxSelectAllRaces
	row[2]:createText(ReadText(1001, 11912), Helper.headerRowCenteredProperties)

	for i, race in ipairs(menu.races) do
		local row = ftable:addRow(true, { fixed = true })
		row[1]:createCheckBox(function () return menu.checkRacesSelected(race) end, { height = Helper.standardTextHeight })
		row[1].handlers.onClick = function(_, checked) menu.checkboxSelectRace(i, race, checked) end
		row[2]:createText(race.name)
	end

	menu.contextFrame:display()
end

function menu.checkRacesSelected(race)
	for i, raceentry in ipairs(menu.races) do
		if raceentry.id == race.id then
			return raceentry.selected == true
		end
	end
	return false
end

function menu.checkAllRacesSelected()
	for i, race in ipairs(menu.races) do
		if not race.selected then
			return false
		end
	end
	return true
end

function menu.checkboxSelectRace(index, race, checked)
	menu.races[index].selected = checked
	local found = false
	for j, text in ipairs(menu.modulesearchtext) do
		if text.race == race.id then
			found = true
			if not checked then
				table.remove(menu.modulesearchtext, j)
			end
			break
		end
	end
	if checked and (not found) then
		table.insert(menu.modulesearchtext, { text = race.name, race = race.id })
	end
	menu.displayMenu()
end

function menu.checkboxSelectAllRaces(_, checked)
	for i, race in ipairs(menu.races) do
		menu.races[i].selected = checked
		local found = false
		for j, text in ipairs(menu.modulesearchtext) do
			if text.race == race.id then
				found = true
				if not checked then
					table.remove(menu.modulesearchtext, j)
				end
				break
			end
		end
		if checked and (not found) then
			table.insert(menu.modulesearchtext, { text = race.name, race = race.id })
		end
	end
	menu.displayMenu()
end

function menu.checkOverwriteActive()
	local canoverwrite, cansaveasnew, source = menu.checkCPNameID()
	return canoverwrite
end

function menu.checkSaveNewActive()
	local canoverwrite, cansaveasnew, source = menu.checkCPNameID()
	return cansaveasnew
end

function menu.checkExportActive()
	local canoverwrite, cansaveasnew, source = menu.checkCPNameID()
	return canoverwrite or cansaveasnew
end

function menu.checkLoadoutNameID()
	local canoverwrite = false
	local cansaveasnew = false
	if menu.loadout then
		local found = false
		for _, loadout in ipairs(menu.loadouts) do
			if loadout.id == menu.loadout then
				menu.loadoutName = loadout.name
				break
			end
		end
		if not found then
			menu.loadout = nil
		end
	end
	if (not menu.loadout) and menu.loadoutName and (menu.loadoutName ~= "") then
		cansaveasnew = true
		for _, loadout in ipairs(menu.loadouts) do
			if loadout.name == menu.loadoutName then
				canoverwrite = true
				cansaveasnew = false
				menu.loadout = loadout.id
				break
			end
		end
	end

	return canoverwrite, cansaveasnew
end

function menu.createCPImportContext()
	Helper.removeAllWidgetScripts(menu, config.contextLayer)

	menu.contextFrame = Helper.createFrameHandle(menu, {
		layer = config.contextLayer,
		standardButtons = {},
		width = menu.contextMode.width,
		x = menu.contextMode.x,
		y = menu.contextMode.y,
		autoFrameHeight = true,
	})
	menu.contextFrame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	local ftable = menu.contextFrame:addTable(4, { tabOrder = 6, reserveScrollBar = false, maxVisibleHeight = Helper.viewHeight / 2 })
	ftable:setDefaultCellProperties("button", { height = Helper.standardTextHeight })
	ftable:setDefaultComplexCellProperties("button", "text", { fontsize = Helper.standardFontSize, halign = "center" })
	ftable:setColWidth(2, 0.25 * (menu.contextMode.width - Helper.borderSize), false)
	ftable:setColWidth(3, 0.25 * (menu.contextMode.width - Helper.borderSize) - Helper.scaleY(Helper.standardTextHeight), false)
	ftable:setColWidth(4, math.max(20, Helper.scaleY(Helper.standardTextHeight)), false)

	local row = ftable:addRow(true, { fixed = true })
	row[1]:setColSpan(3):createText(ReadText(1001, 7971), Helper.headerRowCenteredProperties)
	row[4]:createButton({ width = Helper.standardTextHeight, y = Helper.headerRow1Height - Helper.standardTextHeight }):setIcon("menu_reload")
	row[4].handlers.onClick = menu.buttonReloadImportable

	menu.importableplans = menu.importableplans or {}
	for _, entry in ipairs(menu.importableplans) do
		local row = ftable:addRow(entry, {  })
		if entry.imported then
			row[1]:setColSpan(2):setBackgroundColSpan(4):createText(entry.name, { mouseOverText = entry.filename .. config.fileExtension })
			row[3]:setColSpan(2):createText("[" .. ReadText(1001, 7983) .. "]", { halign = "right", mouseOverText = entry.filename .. config.fileExtension })
		else
			row[1]:setColSpan(4):createText(entry.name, { mouseOverText = entry.filename .. config.fileExtension })
		end
	end

	ftable:setTopRow(menu.topRows.importCP)
	ftable:setSelectedRow(menu.selectedRows.importCP)
	menu.topRows.importCP = GetTopRow(menu.contexttable)
	menu.selectedRows.importCP = Helper.currentTableRow[menu.contexttable]

	local buttontable = menu.contextFrame:addTable(2, { tabOrder = 7, reserveScrollBar = false })
	buttontable:setDefaultCellProperties("button", { height = Helper.standardTextHeight })
	buttontable:setDefaultComplexCellProperties("button", "text", { fontsize = Helper.standardFontSize, halign = "center" })

	local row = buttontable:addRow(nil, { fixed = true })
	row[1]:setColSpan(2):createText(" ")

	local row = buttontable:addRow(nil, { fixed = true })
	row[1]:setColSpan(2):createText(ReadText(1001, 7981), { wordwrap = true })

	if menu.contextData.selectedEntry and menu.contextData.selectedEntry.imported then
		buttontable:addEmptyRow(Helper.standardTextHeight / 2)

		local row = buttontable:addRow(nil, { fixed = true })
		row[1]:setColSpan(2):createText(ReadText(1001, 7982), { wordwrap = true })
	end

	local row = buttontable:addRow(true, { fixed = true })
	row[1]:createButton({ active = function () return menu.contextData.selectedEntry ~= nil end }):setText(ReadText(1001, 7980), {  })
	row[1].handlers.onClick = function () return menu.buttonImport(false) end
	row[2]:createButton({  }):setText(ReadText(1001, 64))
	row[2].handlers.onClick = menu.closeContextMenu

	local maxVisibleHeight = ftable.properties.maxVisibleHeight - buttontable:getFullHeight() - Helper.frameBorder
	buttontable.properties.y = buttontable.properties.y + math.min(maxVisibleHeight, ftable:getFullHeight())
	ftable.properties.maxVisibleHeight = buttontable.properties.y - ftable.properties.y

	ftable.properties.nextTable = buttontable.index
	buttontable.properties.prevTable = ftable.index

	menu.contextFrame:display()
end

function menu.createCPExportContext()
	Helper.removeAllWidgetScripts(menu, config.contextLayer)

	menu.contextFrame = Helper.createFrameHandle(menu, {
		layer = config.contextLayer,
		standardButtons = {},
		width = menu.contextMode.width,
		x = menu.contextMode.x,
		y = menu.contextMode.y,
		autoFrameHeight = true,
	})
	menu.contextFrame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	local ftable = menu.contextFrame:addTable(2, { tabOrder = 6, reserveScrollBar = false })
	ftable:setDefaultCellProperties("button", { height = Helper.standardTextHeight })
	ftable:setDefaultComplexCellProperties("button", "text", { fontsize = Helper.standardFontSize, halign = "center" })

	local row = ftable:addRow(nil, { fixed = true })
	row[1]:setColSpan(2):createText(ReadText(1001, 7972), Helper.headerRowCenteredProperties)

	local row = ftable:addRow(true, { fixed = true })
	menu.contextMode.nameEditBox = row[1]:setColSpan(2):createEditBox({ height = Helper.headerRow1Height, defaultText = ReadText(1001, 7979) }):setText(menu.currentCPName or "", { fontsize = Helper.headerRow1FontSize, x = Helper.standardTextOffsetx })
	row[1].handlers.onTextChanged = menu.editboxCPNameUpdateText

	local row = ftable:addRow(nil, { fixed = true })
	row[1]:setColSpan(2):createText(ReadText(1001, 7973), { wordwrap = true })

	local row = ftable:addRow(true, { fixed = true })
	row[1]:setColSpan(2):createButton({ active = C.CanOpenWebBrowser(), mouseOverText = ReadText(1026, 7918) }):setText(ReadText(1001, 7974)):setText2("\27[mm_externallink]", { halign = "right" })
	row[1].handlers.onClick = menu.buttonConstructionCommunity

	local row = ftable:addRow(true, { fixed = true })
	row[1]:createButton({ active = menu.checkExportActive }):setText(ReadText(1001, 7975), {  })
	row[1].handlers.onClick = function () return menu.buttonExport(false) end
	row[2]:createButton({  }):setText(ReadText(1001, 64))
	row[2].handlers.onClick = menu.closeContextMenu

	menu.contextFrame:display()
end

function menu.createLoadoutSaveContext()
	Helper.removeAllWidgetScripts(menu, config.contextLayer)

	menu.contextFrame = Helper.createFrameHandle(menu, {
		layer = config.contextLayer,
		standardButtons = { close = true },
		width = menu.contextMode.width,
		x = menu.contextMode.x,
		y = menu.contextMode.y,
		autoFrameHeight = true,
	})
	menu.contextFrame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	local ftable = menu.contextFrame:addTable(3, { tabOrder = 6, reserveScrollBar = false })
	ftable:setDefaultCellProperties("button", { height = Helper.standardTextHeight })
	ftable:setDefaultComplexCellProperties("button", "text", { fontsize = Helper.standardFontSize, halign = "center" })

	-- magic
	local canoverwrite, cansaveasnew = menu.checkLoadoutNameID()

	local row = ftable:addRow(nil, { fixed = true })
	row[1]:setColSpan(3):createText(ReadText(1001, 7970), Helper.headerRowCenteredProperties)

	local row = ftable:addRow(true, { fixed = true })
	menu.contextMode.nameEditBox = row[1]:setColSpan(3):createEditBox({ scaling = false, height = menu.titleData.height }):setText(menu.loadoutName or "", { halign = "center", font = Helper.headerRow1Font, fontsize = Helper.scaleFont(Helper.headerRow1Font, Helper.headerRow1FontSize) })
	row[1].handlers.onTextChanged = menu.editboxLoadoutNameUpdateText

	row = ftable:addRow(true, { fixed = true })
	row[1]:createButton({ active = menu.checkLoadoutOverwriteActive, mouseOverText = ReadText(1026, 7908) }):setText(ReadText(1001, 7908), {  })
	row[1].handlers.onClick = function () return menu.buttonSaveLoadout(true) end
	row[2]:createButton({ active = menu.checkLoadoutSaveNewActive, mouseOverText = ReadText(1026, 7909) }):setText(ReadText(1001, 7909), {  })
	row[2].handlers.onClick = function () return menu.buttonSaveLoadout(false) end
	row[3]:createButton({  }):setText(ReadText(1001, 64))
	row[3].handlers.onClick = menu.closeContextMenu

	menu.contextFrame:display()
end

function menu.checkLoadoutOverwriteActive()
	local canoverwrite, cansaveasnew = menu.checkLoadoutNameID()
	return canoverwrite
end

function menu.checkLoadoutSaveNewActive()
	local canoverwrite, cansaveasnew = menu.checkLoadoutNameID()
	return cansaveasnew
end

function menu.displayMenu(firsttime)
	-- Remove possible button scripts from previous view
	Helper.removeAllWidgetScripts(menu, config.infoLayer)
	Helper.currentTableRow = {}
	Helper.closeDropDownOptions(menu.titlebartable, 1, 2)

	menu.infoFrame = Helper.createFrameHandle(menu, {
		layer = config.infoLayer,
		standardButtons = {},
		width = Helper.viewWidth,
		height = Helper.viewHeight,
		x = 0,
		y = 0,
	})

	menu.displayLeftBar(menu.infoFrame)

	menu.displayModules(menu.infoFrame, firsttime)

	menu.displayPlan(menu.infoFrame)

	if menu.selectedModule then
		menu.displayModuleInfo(menu.infoFrame)
	end

	menu.infoFrame:display()
end

function menu.viewCreated(layer, ...)
	if layer == config.mainLayer then
		menu.rightbartable, menu.titlebartable, menu.map = ...

		if menu.activatemap == nil then
			menu.activatemap = true
		end
	elseif layer == config.infoLayer then
		if not menu.loadoutMode then
			if menu.modulesMode then
				menu.leftbartable, menu.moduletable, menu.plantable, menu.planmodulestatus, menu.planresourcestable, menu.planstatus, menu.moduleinfotable = ...
			else
				menu.leftbartable, menu.plantable, menu.planmodulestatus, menu.planresourcestable, menu.planstatus, menu.moduleinfotable = ...
			end
		else
			if menu.upgradetypeMode then
				menu.leftbartable, menu.moduletable, menu.planbutton, menu.plantable, menu.moduleinfotable = ...
			else
				menu.leftbartable, menu.planbutton, menu.plantable, menu.moduleinfotable = ...
			end
		end
	elseif layer == config.contextLayer then
		menu.contexttable = ...
	end
end

menu.updateInterval = 0.01

function menu.onUpdate()
	local curtime = getElapsedTime()

	if menu.updatePlan and (menu.updatePlan < curtime) then
		menu.updatePlan = nil

		C.ShowConstructionMap(menu.holomap, menu.container, "", false)
		menu.applySettings()
		menu.storePlanTableState()
		menu.refreshPlan()
		menu.displayMenu()
	end

	if menu.activatemap then
		-- pass relative screenspace of the holomap rendertarget to the holomap (value range = -1 .. 1)
		local renderX0, renderX1, renderY0, renderY1 = Helper.getRelativeRenderTargetSize(menu, config.mainLayer, menu.map)
		local rendertargetTexture = GetRenderTargetTexture(menu.map)
		if rendertargetTexture then
			menu.holomap = C.AddHoloMap(rendertargetTexture, renderX0, renderX1, renderY0, renderY1, menu.mapData.width / menu.mapData.height, 1)
			if menu.holomap ~= 0 then
				menu.showConstructionMap()
			end

			menu.activatemap = false
			menu.refreshPlan()
			local refresh = true
			if menu.state then
				refresh = not menu.onRestoreState(menu.state)
				menu.state = nil
			end
			if refresh then
				menu.displayMainFrame()
				menu.displayMenu(true)
			end
		end
	end

	if (menu.newSelectedModule and ((menu.selectedModule == nil) or (menu.newSelectedModule.idx ~= menu.selectedModule.idx))) or ((menu.newSelectedModule == "clear") and menu.selectedModule) then
		if menu.newSelectedModule == "clear" then
			menu.selectedModule = nil
		else
			menu.selectedModule = menu.newSelectedModule
		end
		menu.newSelectedModule = nil
		menu.refresh = curtime - 1
	end

	for i, entry in ipairs(menu.removedModules) do
		local component = tostring(entry.component)
		if IsComponentConstruction(ConvertStringTo64Bit(component)) then
			if not menu.currentConstructions[component] then
				-- was not in construction before, update menu
				menu.refresh = curtime - 1
			end
			menu.currentConstructions[component] = curtime
		end
	end
	for i = 1, #menu.constructionplan do
		local component = tostring(menu.constructionplan[i].component)
		if IsComponentConstruction(ConvertStringTo64Bit(component)) then
			if not menu.currentConstructions[component] then
				-- was not in construction before, update menu
				menu.refresh = curtime - 1
			end
			menu.currentConstructions[component] = curtime
		end
	end
	for key, timestamp in pairs(menu.currentConstructions) do
		if timestamp < curtime then
			-- no longer in construction, update menu
			menu.currentConstructions[key] = nil
			menu.refresh = curtime - 1
		end
	end

	if menu.contextData and menu.contextData.newSelectedEntry then
		menu.contextData.selectedEntry = menu.contextData.newSelectedEntry
		menu.topRows.importCP = GetTopRow(menu.contexttable)
		menu.selectedRows.importCP = Helper.currentTableRow[menu.contexttable]
		menu.displayContextFrame("importCP", menu.titleData.dropdownWidth + 7 * (menu.titleData.height + Helper.borderSize), menu.titleData.offsetX + menu.titleData.nameWidth + Helper.borderSize, menu.titleData.offsetY + menu.titleData.height + Helper.borderSize)
		menu.contextData.newSelectedEntry = nil
	end

	if menu.contextMode and (type(menu.contextMode) == "table") and menu.contextMode.nameEditBox then
		ActivateEditBox(menu.contextMode.nameEditBox.id)
		menu.contextMode.nameEditBox = nil
	end

	if menu.refresh and (menu.refresh < curtime) and (not menu.noupdate) then
		menu.topRows.modules = GetTopRow(menu.moduletable)
		menu.selectedRows.modules = Helper.currentTableRow[menu.moduletable]
		menu.selectedCols.modules = Helper.currentTableCol[menu.moduletable]
		menu.storePlanTableState()
		menu.refreshPlan()
		menu.displayMenu()
		menu.refresh = nil
		return
	end

	menu.mainFrame:update()
	menu.infoFrame:update()
	if menu.contextFrame then
		menu.contextFrame:update()
	end

	if menu.holomap ~= 0 then
		if menu.picking ~= menu.pickstate then
			menu.pickstate = menu.picking
			C.SetMapPicking(menu.holomap, menu.pickstate)
		end

		if menu.map then
			local x, y = GetRenderTargetMousePosition(menu.map)
			C.SetMapRelativeMousePosition(menu.holomap, (x and y) ~= nil, x or 0, y or 0)
		end

		local pickedentry = ffi.new("UIConstructionPlanEntry")
		local haspick = false
		if (GetControllerInfo() ~= "gamepad") or C.IsMouseEmulationActive() then
			haspick = C.GetPickedBuildMapEntry2(menu.holomap, menu.container, pickedentry, false)
		end

		if menu.allowpanning and menu.leftdown then
			local offset = table.pack(GetLocalMousePosition())
			if Helper.comparePositions(menu.leftdown.position, offset, 2) then
				C.StartPanMap(menu.holomap)
				if haspick then
					if menu.selectedModule and (pickedentry.idx == menu.selectedModule.idx) then
						menu.keepcursor = true
					end
				end
				menu.allowpanning = nil
			end
		end
		if menu.allowrotating and menu.rightdown then
			local offset = table.pack(GetLocalMousePosition())
			if Helper.comparePositions(menu.rightdown.position, offset, 2) then
				C.StartRotateMap(menu.holomap)
				menu.allowrotating = nil
			end
		end

		if menu.picking then
			if haspick then
				local macro = ffi.string(pickedentry.macroid)
				if macro ~= menu.mouseOverMacro then
					menu.mouseOverMacro = macro
					SetMouseOverOverride(menu.map, GetMacroData(macro, "name"))
					local selectedIdx = C.GetSelectedBuildMapEntry(menu.holomap)
					if ((pickedentry.idx == selectedIdx) or (pickedentry.idx == #menu.constructionplan)) and (not pickedentry.isfixed) then
						SetMouseCursorOverride("crossarrows")
					end
				end
			elseif menu.mouseOverMacro then
				menu.mouseOverMacro = nil
				SetMouseOverOverride(menu.map, nil)
				if not menu.keepcursor then
					SetMouseCursorOverride("default")
				end
			end
		end

		if not menu.loadoutMode then
			local canundo = C.CanUndoConstructionMapChange(menu.holomap)
			if canundo ~= menu.canundo then
				menu.canundo = canundo
				local desc = Helper.createButton(nil, Helper.createButtonIcon("menu_undo", nil, 255, 255, 255, 100, nil, nil, 0, 0), true, canundo, 0, 0, 0, menu.titleData.height, nil, nil, nil, ReadText(1026, 7903) .. Helper.formatOptionalShortcut(" (%s)", "action", 278))
				Helper.setCellContent(menu, menu.titlebartable, desc, 1, 7, nil, "button", nil, function () return menu.undoHelper(true) end)
			end

			local canredo = C.CanRedoConstructionMapChange(menu.holomap)
			if canredo ~= menu.canredo then
				menu.canredo = canredo
				local desc = Helper.createButton(nil, Helper.createButtonIcon("menu_redo", nil, 255, 255, 255, 100, nil, nil, 0, 0), true, canredo, 0, 0, 0, menu.titleData.height, nil, nil, nil, ReadText(1026, 7904) .. Helper.formatOptionalShortcut(" (%s)", "action", 279))
				Helper.setCellContent(menu, menu.titlebartable, desc, 1, 8, nil, "button", nil, function () return menu.undoHelper(false) end)
			end
		end
	end
end

function menu.onRowChanged(row, rowdata, uitable, modified, input, source)
	if not menu.loadoutMode then
		if uitable == menu.plantable then
			if menu.holomap ~= 0 then
				if (source ~= "auto") or (menu.selectedModule == nil) then
					if (type(rowdata) == "table") and rowdata.ismodule and (not rowdata.removed) then
						menu.newSelectedModule = rowdata.module
						C.SelectBuildMapEntry(menu.holomap, rowdata.idx)
					elseif menu.selectedModule ~= nil then
						menu.newSelectedModule = "clear"
						C.ClearBuildMapSelection(menu.holomap)
					end
				end
			end
		elseif uitable == menu.contexttable then
			if (source ~= "auto") or (menu.contextData and (menu.contextData.selectedEntry == nil)) then
				if (type(rowdata) == "table") then
					menu.contextData.newSelectedEntry = rowdata
				end
			end
		end
	end
end

function menu.onSelectElement(uitable, modified, row)
	if uitable == menu.plantable then
		if menu.holomap ~= 0 then
			if (source ~= "auto") or (menu.selectedModule == nil) then
				local rowdata = Helper.getCurrentRowData(menu, uitable)
				if (type(rowdata) == "table") and rowdata.ismodule and (not rowdata.removed) then
					C.SetFocusMapConstructionPlanEntry(menu.holomap, rowdata.idx, true)
				end
			end
		end
	end
end

function menu.closeMenu(dueToClose)
	if dueToClose == "back" then
		if menu.loadoutMode then
			menu.buttonCancelLoadout()
			return
		end
	end
	C.ReleaseConstructionMapState()
	Helper.closeMenu(menu, dueToClose)
	menu.cleanup()
end

function menu.onCloseElement(dueToClose, layer, showinganothermenu)
	if (not showinganothermenu) and menu.contextMode then
		if menu.contextMode.mode == "userquestion" then
			if dueToClose ~= "back" then
				menu.closeContextMenu()
				menu.resetDefaultLoadout()
				menu.closeMenu(dueToClose)
				return
			end
		else
			menu.closeContextMenu()
			if (dueToClose == "back") or (layer == config.contextLayer) then
				return
			end
		end
	end

	if menu.loadoutMode then
		if menu.upgradetypeMode and (dueToClose == "back") then
			menu.deactivateUpgradetypeMode()
			return
		end
	else
		if menu.modulesMode and (dueToClose == "back") then
			menu.deactivateModulesMode()
			return
		end
	end

	if (not showinganothermenu) and menu.haschanges then
		menu.contextData = { dueToClose = dueToClose }
		menu.displayContextFrame("userquestion", Helper.scaleX(400), (Helper.viewWidth - Helper.scaleX(400)) / 2, Helper.viewHeight / 2)
	else
		menu.closeMenu(dueToClose)
	end
end

function menu.closeContextMenu()
	Helper.clearFrame(menu, config.contextLayer)

	-- REMOVE this block once the mouse out/over event order is correct -> This should be unnessecary due to the global tablemouseout event reseting the picking
	if menu.currentMouseOverTable and (
		(menu.currentMouseOverTable == menu.contexttable)
	) then
		menu.picking = true
		menu.currentMouseOverTable = nil
	end
	-- END

	menu.contextFrame = nil
	menu.contextMode = nil
end

-- rendertarget mouse input helper
function menu.onRenderTargetMouseDown()
	menu.leftdown = { time = GetCurRealTime(), position = table.pack(GetLocalMousePosition()) }
	menu.allowpanning = true
end

function menu.onRenderTargetMouseUp()
	local refreshplan = false
	local display = false
	local applyDefaultLoadout

	menu.allowpanning = false
	SetMouseCursorOverride("default")
	menu.keepcursor = false
	if C.StopPanMap(menu.holomap) then
		menu.topRows.modules = GetTopRow(menu.moduletable)
		menu.selectedRows.modules = Helper.currentTableRow[menu.moduletable]
		menu.selectedCols.modules = Helper.currentTableCol[menu.moduletable]
		menu.storePlanTableState()
		refreshplan = true
		display = true
	end

	local offset = table.pack(GetLocalMousePosition())
	-- Check if the mouse button was down less than 0.2 seconds and the mouse was not moved more than a distance of 2px
	if (menu.leftdown and menu.leftdown.time + 0.2 > GetCurRealTime()) and (not Helper.comparePositions(menu.leftdown.position, offset, 2)) then
		menu.closeContextMenu()
		Helper.closeDropDownOptions(menu.titlebartable, 1, 2)

		if not menu.loadoutMode then
			C.SelectPickedBuildMapEntry(menu.holomap)
			C.AddFloatingSequenceToConstructionPlan(menu.holomap)
			local addedNewModule = false
			if menu.floatingNewModule then
				applyDefaultLoadout = menu.floatingNewModule
				menu.floatingNewModule = nil
				addedNewModule = true
			elseif menu.floatingCopyModule then
				menu.floatingCopyModule = nil
				addedNewModule = true
			end
			menu.topRows.modules = GetTopRow(menu.moduletable)
			menu.selectedRows.modules = Helper.currentTableRow[menu.moduletable]
			menu.selectedCols.modules = Helper.currentTableCol[menu.moduletable]

			local newplanrow
			local pickedentry = ffi.new("UIConstructionPlanEntry")
			if C.GetPickedBuildMapEntry2(menu.holomap, menu.container, pickedentry, false) then
				if not pickedentry.isfixed then
					SetMouseCursorOverride("crossarrows")
				end
				local found = false
				for row, rowdata in pairs(menu.rowDataMap[menu.plantable]) do
					if (type(rowdata) == "table") and rowdata.ismodule and (not rowdata.removed) then
						if rowdata.idx == pickedentry.idx then
							menu.selectedModule = rowdata.module
							newplanrow = row
							found = true
							break
						end
					end
				end
				if not found then
					for i, entry in ipairs(menu.constructionplan) do
						if entry.idx == pickedentry.idx then
							menu.selectedModule = entry
							found = true
							break
						end
					end
				end
				if not found then
					menu.selectedModule = { idx = pickedentry.idx, macro = ffi.string(pickedentry.macroid), component = pickedentry.componentid }
				end
				C.SelectBuildMapEntry(menu.holomap, pickedentry.idx)
			else
				menu.selectedModule = nil
				newplanrow = addedNewModule and "last" or "first"
				C.ClearBuildMapSelection(menu.holomap)
			end
			menu.storePlanTableState()
			menu.selectedRows.plan = newplanrow or Helper.currentTableRow[menu.plantable]

			refreshplan = true
			display = true
		else
			local pickedslot = ffi.new("UILoadoutSlot")
			if C.GetPickedMapMacroSlot(menu.holomap, menu.container, menu.loadoutModule.component, menu.loadoutModule.macro, true, pickedslot) then
				local groupinfo = C.GetUpgradeSlotGroup(menu.loadoutModule.component, menu.loadoutModule.macro, pickedslot.upgradetype, pickedslot.slot)
				menu.upgradetypeMode = "turretgroup"
				menu.currentSlot = menu.findGroupIndex(ffi.string(groupinfo.path), ffi.string(groupinfo.group))
				if menu.upgradetypeMode == "turretgroup" then
					local group = menu.groups[menu.currentSlot]
					C.SetSelectedMapGroup(menu.holomap, menu.loadoutModule.component, menu.loadoutModule.macro, group.path, group.group)
				end
				display = true
			end
		end
	end
	menu.leftdown = nil

	if refreshplan then
		menu.refreshPlan()
		if applyDefaultLoadout then
			if menu.defaultLoadout ~= -1 then
				local entry = menu.constructionplan[#menu.constructionplan]
				if entry.macro == applyDefaultLoadout then
					local active = false
					for i, upgradetype in ipairs(Helper.upgradetypes) do
						if upgradetype.supertype == "macro" then
							if C.GetNumUpgradeSlots(entry.component, entry.macro, upgradetype.type) > 0 then
								active = true
								break
							end
						end
					end
					if active then
						local loadout = Helper.getLoadoutHelper(C.GenerateModuleLoadout, C.GenerateModuleLoadoutCounts, menu.holomap, entry.idx, menu.container, menu.defaultLoadout)
						local upgradeplan = Helper.convertLoadout(entry.component, entry.macro, loadout, nil)
						Helper.callLoadoutFunction(upgradeplan, nil, function (loadout, _) return C.UpdateConstructionMapItemLoadout(menu.holomap, entry.idx, menu.container, loadout) end)
					end
					-- again for the new loadout
					menu.refreshPlan()
				end
			end
		end
	end
	if display then
		menu.displayMenu()
	end
end

function menu.onRenderTargetRightMouseDown()
	local pickedentry = ffi.new("UIConstructionPlanEntry")
	local valid = C.GetPickedBuildMapEntry2(menu.holomap, menu.container, pickedentry, false)
	local item = menu.findConstructionPlanEntry(pickedentry.idx)
	if not item then
		item = {}
		valid = false
	end
	menu.rightdown = { time = GetCurRealTime(), position = table.pack(GetLocalMousePosition()), item = item, itemvalid = valid }
	menu.allowrotating = true
end

function menu.onRenderTargetRightMouseUp()
	menu.allowrotating = false
	if C.StopRotateMap(menu.holomap) then
		menu.topRows.modules = GetTopRow(menu.moduletable)
		menu.selectedRows.modules = Helper.currentTableRow[menu.moduletable]
		menu.selectedCols.modules = Helper.currentTableCol[menu.moduletable]
		menu.storePlanTableState()
		menu.refreshPlan()
		menu.displayMenu()
	end

	local offset = table.pack(GetLocalMousePosition())
	-- Check if the mouse button was down less than 0.2 seconds and the mouse was moved more than a distance of 2px
	if (menu.rightdown.time + 0.2 > GetCurRealTime()) and (not Helper.comparePositions(menu.rightdown.position, offset, 2)) then
		menu.closeContextMenu()

		if not menu.loadoutMode then
			if menu.floatingNewModule or menu.floatingCopyModule then
				C.RemoveFloatingSequenceFromConstructionPlan(menu.holomap)
				menu.floatingNewModule = nil
				menu.floatingCopyModule = nil
			elseif menu.rightdown.itemvalid then
				local x, y = GetLocalMousePosition()
				if x == nil then
					-- gamepad case
					x = posx
					y = -posy
				end
				menu.contextData = { item = menu.rightdown.item }
				menu.displayContextFrame("module", Helper.scaleX(200), x + Helper.viewWidth / 2, Helper.viewHeight / 2 - y)
			end
		else
			local pickedslot = ffi.new("UILoadoutSlot")
			if C.GetPickedMapMacroSlot(menu.holomap, menu.container, menu.loadoutModule.component, menu.loadoutModule.macro, true, pickedslot) then
				local groupinfo = C.GetUpgradeSlotGroup(menu.loadoutModule.component, menu.loadoutModule.macro, pickedslot.upgradetype, pickedslot.slot)
				menu.upgradetypeMode = "turretgroup"
				menu.currentSlot = menu.findGroupIndex(ffi.string(groupinfo.path), ffi.string(groupinfo.group))
				if menu.upgradetypeMode == "turretgroup" then
					local group = menu.groups[menu.currentSlot]
					C.SetSelectedMapGroup(menu.holomap, menu.loadoutModule.component, menu.loadoutModule.macro, group.path, group.group)
				end
				menu.displayMenu()

				menu.contextData = { upgradetype = ffi.string(pickedslot.upgradetype), slot = tonumber(pickedslot.slot) }
				menu.displayContextFrame("slot", Helper.scaleX(300), offset[1] + Helper.viewWidth / 2, Helper.viewHeight / 2 - offset[2])
			end
		end
	end
	menu.rightdown = nil
end

function menu.onRenderTargetCombinedScrollDown(step)
	C.ZoomMap(menu.holomap, step)
end

function menu.onRenderTargetCombinedScrollUp(step)
	C.ZoomMap(menu.holomap, -step)
end

function menu.onRenderTargetDoubleClick(modified)
	local pickedentry = ffi.new("UIConstructionPlanEntry")
	local valid = C.GetPickedBuildMapEntry2(menu.holomap, menu.container, pickedentry, false)
	if valid then
		C.SetFocusMapConstructionPlanEntry(menu.holomap, pickedentry.idx, true)
	end
end

function menu.onSaveState()
	local state = {}

	if menu.holomap ~= 0 then
		if menu.haschanges or menu.hasconstructionchanges then
			Helper.registerStationEditorChanges()
		end
		if not menu.loadoutMode then
			C.StoreConstructionMapState(menu.holomap)
		end
		local mapstate = ffi.new("HoloMapState")
		C.GetMapState(menu.holomap, mapstate)
		state.map = { offset = { x = mapstate.offset.x, y = mapstate.offset.y, z = mapstate.offset.z, yaw = mapstate.offset.yaw, pitch = mapstate.offset.pitch, roll = mapstate.offset.roll,}, cameradistance = mapstate.cameradistance }
	end

	for _, key in ipairs(config.stateKeys) do
		if key[1] == "loadoutModuleIdx" then
			if menu.loadoutMode then
				state[key[1]] = tonumber(menu.loadoutModule.idx)
				state.upgradeplan = menu.constructionplan[menu.loadoutMode].upgradeplan
			end
		else
			state[key[1]] = menu[key[1]]
		end
	end
	return state
end

function menu.onRestoreState(state)
	local mapstate
	if state.map then
		local offset = ffi.new("UIPosRot", {
			x = state.map.offset.x,
			y = state.map.offset.y,
			z = state.map.offset.z,
			yaw = state.map.offset.yaw,
			pitch = state.map.offset.pitch,
			roll = state.map.offset.roll
		})
		mapstate = ffi.new("HoloMapState", {
			offset = offset,
			cameradistance = state.map.cameradistance
		})
	end

	local module
	for _, key in ipairs(config.stateKeys) do
		if key[1] == "loadoutModuleIdx" then
			if state[key[1]] then
				local idx = ConvertStringTo64Bit(tostring(state[key[1]]))
				for i, entry in ipairs(menu.constructionplan) do
					if entry.idx == state[key[1]] then
						entry.upgradeplan = state.upgradeplan
						module = entry
						break
					end
				end
			end
		else
			if key[2] == "UniverseID" then
				menu[key[1]] = ConvertIDTo64Bit(state[key[1]])
			elseif key[2] == "bool" then
				menu[key[1]] = state[key[1]] ~= 0
			else
				menu[key[1]] = state[key[1]]
			end
		end
	end

	local returnvalue
	if module then
		menu.buttonEditLoadout(module)
		returnvalue = true
	end

	if mapstate then
		C.SetMapState(menu.holomap, mapstate)
	end

	return returnvalue
end

-- table mouse input helper
function menu.onTableMouseOut(uitable, row)
	if menu.currentMouseOverTable and (uitable == menu.currentMouseOverTable) then
		menu.currentMouseOverTable = nil
		if menu.holomap ~= 0 then
			menu.picking = true
		end
	end
end

function menu.onTableMouseOver(uitable, row)
	menu.currentMouseOverTable = uitable
	if menu.holomap ~= 0 then
		menu.picking = false
	end
end

function menu.onTableRightMouseClick(uitable, row, posx, posy)
	local rowdata = menu.rowDataMap[uitable] and menu.rowDataMap[uitable][row]
	if uitable == menu.plantable then
		if (type(rowdata) == "table") and rowdata.ismodule and (not rowdata.removed) then
			local x, y = GetLocalMousePosition()
			if x == nil then
				-- gamepad case
				x = posx
				y = -posy
			end
			menu.contextData = { item = rowdata.module }
			menu.displayContextFrame("module", Helper.scaleX(200), x + Helper.viewWidth / 2, Helper.viewHeight / 2 - y)
		end
	end
end

function menu.filterModuleByText(module, texts)
	local hasracefilter, racematch = false, false
	for _, textentry in ipairs(texts) do
		if textentry.race then
			hasracefilter = true
			local makerraces = GetMacroData(module, "makerraceid")
			if (textentry.race == "generic") and (#makerraces == 0) then
				racematch = true
			end
			for _, makerrace in ipairs(makerraces) do
				if makerrace == textentry.race then
					racematch = true
					break
				end
			end
			if racematch then
				break
			end
		end
	end

	local hasadditionalfilter, filtermatch = false, false
	for _, textentry in ipairs(texts) do
		if not textentry.race then
			hasadditionalfilter = true
			text = utf8.lower(textentry.text)

			local name, shortname, makerracenames = GetMacroData(module, "name", "shortname", "makerracename")
			if string.find(utf8.lower(name), text, 1, true) then
				filtermatch = true
			end
			if string.find(utf8.lower(shortname), text, 1, true) then
				filtermatch = true
			end
			for _, makerracename in ipairs(makerracenames) do
				if string.find(utf8.lower(makerracename), text, 1, true) then
					filtermatch = true
					break
				end
			end
			if filtermatch then
				break
			end
		end
	end

	return ((not hasracefilter) or racematch) and ((not hasadditionalfilter) or filtermatch)
end

function menu.filterUpgradeByText(upgrade, text)
	text = utf8.lower(text)

	local name, shortname, makerracenames = GetMacroData(upgrade, "name", "shortname", "makerracename")
	if string.find(utf8.lower(name), text, 1, true) then
		return true
	end
	if string.find(utf8.lower(shortname), text, 1, true) then
		return true
	end
	for _, makerracename in ipairs(makerracenames) do
		if string.find(utf8.lower(makerracename), text, 1, true) then
			return true
		end
	end

	return false
end

function menu.isEntryExtended(container, index)
	for i, entry in ipairs(menu.extendedentries) do
		if entry.id == container then
			return entry.plan[index]
		end
	end
	return false
end

function menu.extendEntry(container, index, force, exclusive)
	local found = false
	for i, entry in ipairs(menu.extendedentries) do
		if entry.id == container then
			found = true
			if exclusive then
				entry.plan = {}
			end
			if (not force) and entry.plan[index] then
				entry.plan[index] = nil
			else
				entry.plan[index] = true
			end
			break
		end
	end
	if not found then
		table.insert(menu.extendedentries, {id = container, plan = { [index] = true } })
	end
end

function menu.initExtendedEntry(container)
	for i, entry in ipairs(menu.extendedentries) do
		if entry.id == container then
			-- nothing to do
			return
		end
	end
	table.insert(menu.extendedentries, {id = container, plan = { ["planned"] = true, ["removed"] = true } })
end

function menu.isResourceEntryExtended(id, default)
	if (default ~= nil) and (menu.extendedresourceentries[id] == nil) then
		menu.extendedresourceentries[id] = default
	end
	return menu.extendedresourceentries[id]
end

function menu.extendResourceEntry(id)
	menu.extendedresourceentries[id] = not menu.extendedresourceentries[id]
end

function menu.getLeftBarEntry(mode)
	for i, entry in ipairs(config.leftBar) do
		if entry.mode == mode then
			return entry
		end
	end

	return {}
end

function menu.getLeftBarLoadoutEntry(mode)
	for i, entry in ipairs(config.leftBarLoadout) do
		if entry.mode == mode then
			return entry
		end
	end

	return {}
end

function menu.findUpgradeMacro(type, macro)
	for i, upgradeware in ipairs(menu.upgradewares[type] or {}) do
		if upgradeware.macro == macro then
			return i
		end
	end
	DebugError("The equipment macro '" .. macro .. "' is not in the player's blueprint list. This should never happen. [Florian]")
end

function menu.findGroupIndex(path, group)
	for i, groupinfo in ipairs(menu.groups) do
		if (groupinfo.path == path) and (groupinfo.group == group) then
			return i
		end
	end
end

function menu.findConstructionPlanEntry(idx)
	for _, entry in ipairs(menu.constructionplan) do
		if entry.idx == idx then
			return entry
		end
	end
end

function menu.storePlanTableState()
	menu.topRows.plan = GetTopRow(menu.plantable)
	menu.selectedRows.plan = Helper.currentTableRow[menu.plantable]
	menu.topRows.planresources = GetTopRow(menu.planresourcestable)
	menu.selectedRows.planresources = Helper.currentTableRow[menu.planresourcestable]
end

function menu.upgradeSettingsVersion()
	local oldversion = __CORE_DETAILMONITOR_STATIONBUILD.version

	if oldversion < 2 then
		__CORE_DETAILMONITOR_STATIONBUILD.gizmo = true
	end

	__CORE_DETAILMONITOR_STATIONBUILD.version = config.mapfilterversion
end

function menu.applySettings()
	if menu.holomap and (menu.holomap ~= 0) then
		C.SetConstructionMapBuildAngleStep(menu.holomap, __CORE_DETAILMONITOR_STATIONBUILD.discreteanglestep)
		C.SetConstructionMapCollisionDetection(menu.holomap, not __CORE_DETAILMONITOR_STATIONBUILD.moduleoverlap)
		C.SetConstructionMapRenderSectorBackground(menu.holomap, __CORE_DETAILMONITOR_STATIONBUILD.environment)
		C.SetConstructionMapRenderTransformGizmo(menu.holomap, __CORE_DETAILMONITOR_STATIONBUILD.gizmo)
	end
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
		Helper.loadModLuas(menu.name, "menu_station_configuration_uix")
	end
end
-- kuertee end

init()
