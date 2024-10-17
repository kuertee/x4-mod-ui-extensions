-- Custom gamestart editor
-- param == { 0, 0, gamestartid, ismultiplayer, iscreative, ispaused }

-- ffi setup
local ffi = require("ffi")
local C = ffi.C
ffi.cdef[[
	typedef struct {
		const char* id;
		uint32_t textid;
		uint32_t descriptionid;
		uint32_t value;
		uint32_t relevance;
		const char* ware;
	} SkillInfo;
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
	} CustomGameStartBlueprint;
	typedef struct {
		const char* state;
		uint32_t numvalues;
		uint32_t numdefaultvalues;
	} CustomGameStartBlueprintPropertyState;
	typedef struct {
		const char* state;
		bool defaultvalue;
	} CustomGameStartBoolPropertyState;
	typedef struct {
		const char* id;
		int64_t value;
	} CustomGameStartBudgetDetail;
	typedef struct {
		const char* id;
		int64_t value;
		int64_t limit;
		uint32_t numdetails;
	} CustomGameStartBudgetInfo;
	typedef struct {
		const char* id;
		const char* name;
		const char* description;
		bool isresearch;
	} CustomGameStartBudgetGroupInfo;
	typedef struct {
		uint32_t nummacros;
		uint32_t numblueprints;
		uint32_t numconstructionplans;
		bool hasincompatibleloadout;
	} CustomGameStartContentCounts;
	typedef struct {
		UIMacroCount* macros;
		uint32_t nummacros;
		const char** blueprints;
		uint32_t numblueprints;
		const char** constructionplanids;
		uint32_t numconstructionplans;
	} CustomGameStartContentData2;
	typedef struct {
		const char* library;
		const char* item;
	} CustomGameStartEncyclopediaEntry;
	typedef struct {
		const char* state;
	} CustomGameStartEncyclopediaPropertyState;
	typedef struct {
		const char* id;
		const char* name;
		const char* filename;
	} CustomGameStartInfo;
	typedef struct {
		const char* ware;
		int32_t amount;
	} CustomGameStartInventory;
	typedef struct {
		const char* state;
		uint32_t numvalues;
		uint32_t numdefaultvalues;
	} CustomGameStartInventoryPropertyState;
	typedef struct {
		const char* type;
		const char* item;
		const char* classid;
		int64_t budgetvalue;
		bool unlocked;
		bool hidden;
	} CustomGameStartKnownEntry2;
	typedef struct {
		const char* state;
		uint32_t numvalues;
		uint32_t numdefaultvalues;
	} CustomGameStartKnownPropertyState;
	typedef struct {
		const char* state;
		int64_t defaultvalue;
		int64_t minvalue;
		int64_t maxvalue;
	} CustomGameStartMoneyPropertyState;
	typedef struct {
		const char* race;
		const char* tags;
		uint32_t numskills;
		SkillInfo* skills;
	} CustomGameStartPersonEntry;
	typedef struct {
		uint32_t numcargo;
	} CustomGameStartPlayerPropertyCounts;
	typedef struct {
		const char* state;
		uint32_t numvalues;
	} CustomGameStartPlayerPropertyPropertyState;
	typedef struct {
		const char* state;
		UIPosRot defaultvalue;
	} CustomGameStartPosRotPropertyState;
	typedef struct {
		const char* factionid;
		const char* otherfactionid;
		int32_t relation;
	} CustomGameStartRelationInfo;
	typedef struct {
		const char* state;
	} CustomGameStartRelationsPropertyState;
	typedef struct {
		const char* state;
	} CustomGameStartResearchPropertyState;
	typedef struct {
		const char* id;
		const char* name;
		const char* description;
		const char* groupid;
		const char* wareid;
		int32_t index;
		int64_t budgetvalue;
		uint32_t numdependencylists;
	} CustomGameStartStoryInfo;
	typedef struct {
		const char* state;
		uint32_t numvalues;
		uint32_t numdefaultvalues;
	} CustomGameStartStoryState;
	typedef struct {
		const char* state;
		const char* defaultvalue;
		const char* options;
	} CustomGameStartStringPropertyState;
	typedef struct {
		const char* id;
		const char* name;
		int32_t state;
		const char* requiredversion;
		const char* installedversion;
	} InvalidPatchInfo;
	typedef struct {
		const char* id;
		const char* name;
	} ProductionMethodInfo;
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
		const char* macro;
		uint32_t amount;
	} UIMacroCount;
	typedef struct {
		const char* ID;
		const char* Name;
		const char* RawName;
		const char* Icon;
	} UIPaintTheme;
	typedef struct {
		const char* ware;
		const char* macro;
		int amount;
	} UIWareInfo;
	
	typedef struct {
		const char* type;
		const char* id;
		const char* sector;
		UIPosRot offset;
		const char* dockedatid;
		const char* commanderid;
		const char* macroname;
		const char* name;
		const char* constructionplanid;
		const char* paintmod;
		const char* peopledefid;
		float peoplefillpercentage;
		uint32_t numcargo;
		UIWareInfo* cargo;
		uint32_t count;
	} CustomGameStartPlayerProperty3;
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
	bool AreConstructionPlanLoadoutsCompatible(const char* constructionplanid);
	bool CanPlayerUseRace(const char* raceid, const char* postid);
	void ExportCustomGameStart(const char* filename, const char* id, const char* name);
	const char* GenerateFactionRelationTextFromRelation(int32_t uirelation);
	uint32_t GetAllFactions(const char** result, uint32_t resultlen, bool includehidden);
	uint32_t GetAllRaces(RaceInfo* result, uint32_t resultlen);
	uint32_t GetAvailableCustomGameStarts(CustomGameStartInfo* result, uint32_t resultlen, const char* id);
	size_t GetConstructionPlanInfo(UIConstructionPlanEntry* result, size_t resultlen, const char* constructionplanid);
	uint32_t GetConstructionPlanInvalidPatches(InvalidPatchInfo* result, uint32_t resultlen, const char* constructionplanid);
	uint32_t GetConstructionPlans(UIConstructionPlan* result, uint32_t resultlen);
	uint32_t GetCustomGameStartBlueprintDefaultProperty(CustomGameStartBlueprint* result, uint32_t resultlen, const char* id, const char* propertyid);
	uint32_t GetCustomGameStartBlueprintProperty(CustomGameStartBlueprint* result, uint32_t resultlen, const char* id, const char* propertyid);
	CustomGameStartBlueprintPropertyState GetCustomGameStartBlueprintPropertyState(const char* id, const char* propertyid);
	bool GetCustomGameStartBoolProperty(const char* id, const char* propertyid, CustomGameStartBoolPropertyState* state);
	CustomGameStartBudgetInfo GetCustomGameStartBudget(const char* id, const char* budgetid);
	uint32_t GetCustomGameStartBudgetDetails(CustomGameStartBudgetDetail* result, uint32_t resultlen, const char* id, const char* budgetid);
	CustomGameStartBudgetGroupInfo GetCustomGameStartBudgetGroupInfo(const char* id, const char* budgetgroupid);
	uint32_t GetCustomGameStartBudgetGroups(const char** result, uint32_t resultlen, const char* id);
	uint32_t GetCustomGameStartEncyclopediaProperty(CustomGameStartEncyclopediaEntry* result, uint32_t resultlen, const char* id, const char* propertyid);
	uint32_t GetCustomGameStartEncyclopediaPropertyCounts(const char* id, const char* propertyid);
	CustomGameStartEncyclopediaPropertyState GetCustomGameStartEncyclopediaPropertyState(const char* id, const char* propertyid);
	uint32_t GetCustomGameStartInventoryDefaultProperty(CustomGameStartInventory* result, uint32_t resultlen, const char* id, const char* propertyid);
	uint32_t GetCustomGameStartInventoryProperty(CustomGameStartInventory* result, uint32_t resultlen, const char* id, const char* propertyid);
	CustomGameStartInventoryPropertyState GetCustomGameStartInventoryPropertyState(const char* id, const char* propertyid);
	uint32_t GetCustomGameStartKnownDefaultProperty2(CustomGameStartKnownEntry2* result, uint32_t resultlen, const char* id, const char* propertyid);
	uint32_t GetCustomGameStartKnownProperty2(CustomGameStartKnownEntry2* result, uint32_t resultlen, const char* id, const char* propertyid);
	bool GetCustomGameStartKnownPropertyBudgetValue2(const char* id, const char* propertyid, CustomGameStartKnownEntry2* uivalue);
	uint32_t GetCustomGameStartKnownPropertyNumStateDependencies(uint32_t* result, uint32_t resultlen, const char* id, const char* propertyid, CustomGameStartKnownEntry2 uivalue);
	uint32_t GetCustomGameStartKnownPropertyNumStateDependencyLists(const char* id, const char* propertyid, CustomGameStartKnownEntry2 uivalue);
	CustomGameStartKnownPropertyState GetCustomGameStartKnownPropertyState(const char* id, const char* propertyid);
	uint32_t GetCustomGameStartKnownPropertyStateDependencies(const char** result, uint32_t resultlen, const char* id, const char* propertyid, CustomGameStartKnownEntry2 uivalue);
	CustomGameStartContentCounts GetCustomGameStartContentCounts2(const char* id, const char* filename, const char* gamestartid);
	void GetCustomGameStartContent2(CustomGameStartContentData2* result, const char* id, const char* filename, const char* gamestartid);
	int64_t GetCustomGameStartMoneyProperty(const char* id, const char* propertyid, CustomGameStartMoneyPropertyState* state);
	uint32_t GetCustomGameStartPaintThemes(UIPaintTheme* result, uint32_t resultlen, const char* id);
	uint32_t GetCustomGameStartPlayerPropertyCounts(CustomGameStartPlayerPropertyCounts* result, uint32_t resultlen, const char* id, const char* propertyid);
	int64_t GetCustomGameStartPlayerPropertyPeopleValue(const char* id, const char* propertyid, const char* entryid);
	bool GetCustomGameStartPlayerPropertyPerson(CustomGameStartPersonEntry* result, const char* id, const char* propertyid, const char* entryid);
	uint32_t GetCustomGameStartPlayerPropertyProperty3(CustomGameStartPlayerProperty3* result, uint32_t resultlen, const char* id, const char* propertyid);
	CustomGameStartPlayerPropertyPropertyState GetCustomGameStartPlayerPropertyPropertyState(const char* id, const char* propertyid);
	const char* GetCustomGameStartPlayerPropertySector(const char* id, const char* propertyid, const char* entryid);
	int64_t GetCustomGameStartPlayerPropertyValue(const char* id, const char* propertyid, const char* entryid);
	UIPosRot GetCustomGameStartPosRotProperty(const char* id, const char* propertyid, CustomGameStartPosRotPropertyState* state);
	uint32_t GetCustomGameStartRelationsProperty(CustomGameStartRelationInfo* result, uint32_t resultlen, const char* id, const char* propertyid);
	int64_t GetCustomGameStartRelationsPropertyBudgetValue(const char* id, const char* propertyid, CustomGameStartRelationInfo uivalue);
	uint32_t GetCustomGameStartRelationsPropertyCounts(const char* id, const char* propertyid);
	CustomGameStartRelationsPropertyState GetCustomGameStartRelationsPropertyState(const char* id, const char* propertyid);
	uint32_t GetCustomGameStartResearchProperty(const char** result, uint32_t resultlen, const char* id, const char* propertyid);
	uint32_t GetCustomGameStartResearchPropertyCounts(const char* id, const char* propertyid);
	CustomGameStartResearchPropertyState GetCustomGameStartResearchPropertyState(const char* id, const char* propertyid);
	int64_t GetCustomGameStartShipPersonValue(const char* id, CustomGameStartPersonEntry uivalue);
	uint32_t GetCustomGameStartStoryBudgets(CustomGameStartStoryInfo* result, uint32_t resultlen, const char* id);
	uint32_t GetNumCustomGameStartStoryBudgetDependencyLists(uint32_t* result, uint32_t resultlen, const char* id, const char* storyid);
	uint32_t GetCustomGameStartStoryBudgetDependencies(const char** result, uint32_t resultlen, const char* id, const char* storyid);
	uint32_t GetCustomGameStartStoryDefaultProperty(const char** result, uint32_t resultlen, const char* id, const char* propertyid);
	uint32_t GetCustomGameStartStoryProperty(const char** result, uint32_t resultlen, const char* id, const char* propertyid);
	CustomGameStartStoryState GetCustomGameStartStoryPropertyState(const char* id, const char* propertyid);
	const char* GetCustomGameStartStringProperty(const char* id, const char* propertyid, CustomGameStartStringPropertyState* state);
	const char* GetMacroMapPositionOnEcliptic(UniverseID holomapid, UIPosRot* position);
	uint32_t GetNumAllFactions(bool includehidden);
	uint32_t GetNumAllRaces(void);
	uint32_t GetNumAvailableCustomGameStarts(const char* id);
	size_t GetNumConstructionPlanInfo(const char* constructionplanid);
	uint32_t GetNumConstructionPlans(void);
	uint32_t GetNumCustomGameStartBudgetGroups(const char* id);
	uint32_t GetNumCustomGameStartPaintThemes(const char* id);
	uint32_t GetNumCustomGameStartStoryBudgets(const char* id);
	uint32_t GetNumPlannedLimitedModules(const char* constructionplanid);
	uint32_t GetNumPlayerBuildMethods(void);
	uint32_t GetNumWares(const char* tags, bool research, const char* licenceownerid, const char* exclusiontags);
	uint32_t GetPlannedLimitedModules(UIMacroCount* result, uint32_t resultlen, const char* constructionplanid);
	uint32_t GetPlayerBuildMethods(ProductionMethodInfo* result, uint32_t resultlen);
	int64_t GetStationValue(const char* macroname, const char* constructionplanid);
	int32_t GetUIDefaultBaseRelation(const char* fromfactionid, const char* tofactionid);
	uint32_t GetWares(const char** result, uint32_t resultlen, const char* tags, bool research, const char* licenceownerid, const char* exclusiontags);
	bool HasCustomGameStartBudget(const char* id, const char* budgetid);
	void ImportCustomGameStart(const char* id, const char* filename, const char* gamestartid);
	bool IsConstructionPlanAvailableInCustomGameStart(const char* constructionplanid);
	bool IsConstructionPlanValid(const char* constructionplanid, uint32_t* numinvalidpatches);
	bool IsCustomGameStartPropertyChanged(const char* id, const char* propertyid);
	bool IsGameStartModified(const char* id);
	void NewMultiplayerGame(const char* modulename, const char* difficulty);
	void RemoveCustomGameStartPlayerProperty(const char* id, const char* propertyid, const char* entryid);
	void RemoveHoloMap(void);
	void ResetCustomGameStart(const char* id);
	void ResetCustomGameStartProperty(const char* id, const char* propertyid);
	void SetCustomGameStartBlueprintProperty(const char* id, const char* propertyid, CustomGameStartBlueprint* uivalue, uint32_t uivaluecount);
	void SetCustomGameStartBoolProperty(const char* id, const char* propertyid, bool uivalue);
	void SetCustomGameStartEncyclopediaProperty(const char* id, const char* propertyid, CustomGameStartEncyclopediaEntry* uivalue, uint32_t uivaluecount);
	void SetCustomGameStartInventoryProperty(const char* id, const char* propertyid, CustomGameStartInventory* uivalue, uint32_t uivaluecount);
	void SetCustomGameStartKnownProperty2(const char* id, const char* propertyid, CustomGameStartKnownEntry2* uivalue, uint32_t uivaluecount);
	void SetCustomGameStartMoneyProperty(const char* id, const char* propertyid, int64_t uivalue);
	void SetCustomGameStartPlayerPropertyCount(const char* id, const char* propertyid, const char* entryid, uint32_t count);
	const char* SetCustomGameStartPlayerPropertyObjectMacro(const char* id, const char* propertyid, const char* entryid, const char* macroname);
	const char* SetCustomGameStartPlayerPropertyMacroAndConstructionPlan2(const char* id, const char* propertyid, const char* entryid, const char* macroname, const char* constructionplanid);
	void SetCustomGameStartPlayerPropertyName(const char* id, const char* propertyid, const char* entryid, const char* name);
	void SetCustomGameStartPlayerPropertyPeople(const char* id, const char* propertyid, const char* entryid, const char* peopledefid);
	void SetCustomGameStartPlayerPropertyPeopleFillPercentage2(const char* id, const char* propertyid, const char* entryid, float fillpercentage);
	void SetCustomGameStartPlayerPropertyPerson(const char* id, const char* propertyid, const char* entryid, CustomGameStartPersonEntry uivalue);
	void SetCustomGameStartPlayerPropertySectorAndOffset(const char* id, const char* propertyid, const char* entryid, const char* sectormacroname, UIPosRot uivalue);
	void SetCustomGameStartPosRotProperty(const char* id, const char* propertyid, UIPosRot uivalue);
	void SetCustomGameStartRelationsProperty(const char* id, const char* propertyid, CustomGameStartRelationInfo* uivalue, uint32_t uivaluecount);
	void SetCustomGameStartResearchProperty(const char* id, const char* propertyid, const char** uivalue, uint32_t uivaluecount);
	void SetCustomGameStartShipAndEmptyLoadout(const char* id, const char* shippropertyid, const char* loadoutpropertyid, const char* macroname);
	void SetCustomGameStartStringProperty(const char* id, const char* propertyid, const char* uivalue);
	void SetCustomGameStartStory(const char* id, const char* propertyid, const char** uivalue, uint32_t uivaluecount);
	void SetMacroMapLocalLinearHighways(UniverseID holomapid, bool value);
	void SetMacroMapLocalRingHighways(UniverseID holomapid, bool value);
	void SetMacroMapSelection(UniverseID holomapid, bool selectplayer, const char* propertyentryid);
	void SetMapRelativeMousePosition(UniverseID holomapid, bool valid, float x, float y);
	void ShowUniverseMacroMap2(UniverseID holomapid, const char* macroname, const char* startsectormacroname, UIPosRot sectoroffset, bool setoffset, bool showzone, const char* gamestartid);
	void StartPanMap(UniverseID holomapid);
	bool StopPanMap(UniverseID holomapid);
	void ZoomMap(UniverseID holomapid, float zoomstep);
]]

local utf8 = require("utf8")

local menu = {
	name = "CustomGameMenu",
	category = {},
	curDropDownOption = {},
	techtree = {},
	researchstoriesbyid = {},
	factions = {},
	encyclopedia = {},
	knowndata = {},
	excludedvalues = {},
	expandedProperty = {},
	hidestoryspoilers = true,
	stories = {},
	storiesbyid = {},
	researchstories = {},
	satellites = {},
	playerMacros = {},
	storygroups = {},
	cpwarescache = {},
}

-- kuertee start:
local callbacks = {}
-- kuertee end

local function init()
	-- register callbacks
	local contract = getElement("Scene.UIContract")
	registerForEvent("cutsceneReady", contract, menu.onCutsceneReady)
	registerForEvent("cutsceneStopped", contract, menu.onCutsceneStopped)

	-- init variables
	menu.isStartmenu = C.IsStartmenu()

	-- register menu
	Menus = Menus or {}
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

local config = {
	mainFrameLayer = 4,
	expandedMenuFrameLayer = 2,
	contextFrameLayer = 2,

	backarrow = "table_arrow_inv_left",
	backarrowOffsetX = 3,

	font = "Zekton outlined",
	fontBold = "Zekton bold outlined",

	headerFontSize = 13,
	infoFontSize = 9,
	standardFontSize = 10,

	headerTextHeight = 34,
	subHeaderTextHeight = 22,
	standardTextHeight = 19,
	infoTextHeight = 16,

	headerTextOffsetX = 5,
	standardTextOffsetX = 5,
	infoTextOffsetX = 5,

	standardTextOffsetY = 2,

	nodeoffsetx = 30,
	nodewidth = 270,

	budgetwidth = 130,
	budgetheight = 270,

	mapContextWidth = 260,

	satellites = {
		macro = "eq_arg_satellite_02_macro",
		coverageradius = 300 * 1000, -- 300km
	},

	table = {
		y = 45,
		x = 45,
		arrowColumnWidth = 20,
	},

	stateKeys = {
		{ "shownPropertyHint" },
		{ "addingFleet", "bool" },
		{ "usespacesuit", "bool" },
	},

	excludedmodules = {
		"landmarks_player_hq_01_research_macro"
	},

	blueprintcategories = {
		{ name = ReadText(1001, 2421),	classes = { ["production"] = true } },
		{ name = ReadText(1001, 2439),	classes = { ["buildmodule"] = true } },
		{ name = ReadText(1001, 2422),	classes = { ["storage"] = true } },
		{ name = ReadText(1001, 2451),	classes = { ["habitation"] = true } },
		{ name = ReadText(1001, 9620),	classes = { ["welfaremodule"] = true } },
		{ name = ReadText(1001, 2424),	classes = { ["defencemodule"] = true } },
		{ name = ReadText(1001, 2452),	classes = { ["pier"] = true, ["dockarea"] = true } },
		{ name = ReadText(1001, 9621),	classes = { ["processingmodule"] = true } },
		{ name = ReadText(1001, 2453),	classes = { ["connectionmodule"] = true } },

		{ name = ReadText(1001, 11003),	classes = { ["ship_xl"] = true } },
		{ name = ReadText(1001, 11002),	classes = { ["ship_l"] = true } },
		{ name = ReadText(1001, 11001),	classes = { ["ship_m"] = true } },
		{ name = ReadText(1001, 11000),	classes = { ["ship_s"] = true } },

		{ name = ReadText(1001, 1301),	classes = { ["weapon"] = true, ["missilelauncher"] = true } },
		{ name = ReadText(1001, 1319),	classes = { ["turret"] = true, ["missileturret"] = true } },
		{ name = ReadText(1001, 1317),	classes = { ["shieldgenerator"] = true } },
		{ name = ReadText(1001, 1103),	classes = { ["engine"] = true } },
		{ name = ReadText(1001, 8001),	classes = { ["thruster"] = true } },
		{ name = ReadText(1001, 1304),	classes = { ["missile"] = true } },
		{ name = ReadText(1001, 8),		classes = { ["drone"] = true } },
		{ name = ReadText(1001, 8003),	classes = { ["lasertower"] = true, ["satellite"] = true, ["mine"] = true, ["navbeacon"] = true, ["resourceprobe"] = true } },
		{ name = ReadText(1001, 8063),	classes = { ["countermeasure"] = true } },
	},

	maxBudgetDetails = 9,

	fallbackShipMacro = "ship_arg_s_heavyfighter_02_a_macro",

	factionrelationsallowedbystory = {
		["buccaneers"] = { ["story_paranid_esc_1"] = true, ["story_paranid_esc_2"] = true, ["story_paranid_esc_3"] = true },
	},
}

config.headerTextProperties = {
	font = config.fontBold,
	fontsize = config.headerFontSize,
	x = config.headerTextOffsetX,
	y = 6,
	minRowHeight = config.headerTextHeight,
	titleColor = Color["row_title"],
}

config.subHeaderTextProperties = {
	font = config.font,
	fontsize = config.standardFontSize,
	x = config.standardTextOffsetX,
	y = 2,
	minRowHeight = config.subHeaderTextHeight,
	halign = "center",
	titleColor = Color["row_title"],
}

config.standardTextProperties = {
	font = config.font,
	fontsize = config.standardFontSize,
	x = config.standardTextOffsetX,
	y = config.standardTextOffsetY,
}

config.categories = {
	{ id = "player",	name = ReadText(1021, 10002),	type = "list",	rendertarget = true,	budget = "money",	displayOnRenderTarget = { "npc", "player" },	properties = {
		[1] = {
			id = "playername",
			name = ReadText(1021, 11003),
			type = "editbox",
			propertyType = "String",
			get = C.GetCustomGameStartStringProperty,
			set = C.SetCustomGameStartStringProperty,
		},
		[2] = {
			id = "player",
			name = ReadText(1021, 11007),
			type = "dropdown",
			propertyType = "String",
			get = C.GetCustomGameStartStringProperty,
			set = function (customgamestart, propertyid, option) return menu.setPlayerMacro(customgamestart, propertyid, option) end,
			formatValue = function (value, customoptions) return menu.playerMacro(value, customoptions) end,
		},
		[3] = {
			id = "playermoney",
			budget = "money",
			name = ReadText(1021, 11002),
			mouseOverText = ReadText(1026, 9908),
			type = "number",
			propertyType = "Money",
			get = C.GetCustomGameStartMoneyProperty,
			set = C.SetCustomGameStartMoneyProperty,
			formatValue = function (value) return menu.playerMoney(value) end,
		},
		[4] = {
			id = "playerinventory",
			budget = "money",
			name = ReadText(1021, 11009),
			type = "multiselectslider",
			propertyType = "Inventory",
			getState = C.GetCustomGameStartInventoryPropertyState,
			get = C.GetCustomGameStartInventoryProperty,
			getDefault = C.GetCustomGameStartInventoryDefaultProperty,
			set = C.SetCustomGameStartInventoryProperty,
			formatValue = function (numValues) return (numValues == 0) and ReadText(1001, 9915) or ReadText(1001, 8378) end,
			selectionText = ReadText(1001, 8376),
		},
		[5] = {
			id = "playerblueprints",
			budget = "money",
			name = ReadText(1021, 11010),
			mouseOverText = ReadText(1026, 9909),
			type = "multiselect",
			propertyType = "Blueprint",
			getState = C.GetCustomGameStartBlueprintPropertyState,
			get = C.GetCustomGameStartBlueprintProperty,
			getDefault = C.GetCustomGameStartBlueprintDefaultProperty,
			set = C.SetCustomGameStartBlueprintProperty,
			formatValue = function (numValues) return (numValues == 0) and ReadText(1001, 9916) or ReadText(1001, 9914) end,
			selectionText = ReadText(1001, 9913),
			excludetags = { "paintmod" },
		},
		[6] = {
			id = "playerbuildmethod",
			name = ReadText(1001, 11298),
			mouseOverText = ReadText(1026, 9910),
			type = "dropdown",
			propertyType = "String",
			get = C.GetCustomGameStartStringProperty,
			set = C.SetCustomGameStartStringProperty,
			formatValue = function (value, customoptions) return menu.playerBuildMethod(value, customoptions) end,
			replaceempty = "auto",
		},
		[7] = {
			id = "playerpainttheme",
			name = ReadText(1001, 9104),
			mouseOverText = ReadText(1026, 9911),
			type = "dropdown",
			propertyType = "String",
			get = C.GetCustomGameStartStringProperty,
			set = function (customgamestart, propertyid, option) return menu.setPlayerPaintTheme(customgamestart, propertyid, option) end,
			formatValue = function (value, customoptions) return menu.playerPaintThemes(value, customoptions) end,
			displayOnRenderTarget = "painttheme",
		},
	}},
	{ id = "ship",	name = ReadText(1021, 10003),	type = "list",	rendertarget = true,	budget = { "money", "people" },		displayOnRenderTarget = { "macro", "ship" },	properties = {
		[1] = {
			id = "shipname",
			name = ReadText(1021, 11003),
			type = "editbox",
			propertyType = "String",
			get = C.GetCustomGameStartStringProperty,
			set = C.SetCustomGameStartStringProperty,
			active = function () return menu.usespacesuit ~= true end,
		},
		[2] = {
			id = "ship",
			budget = { "money", "people" },
			modifyingids = { "shiploadout" },
			name = ReadText(1021, 11008),
			type = "button",
			propertyType = "String",
			get = C.GetCustomGameStartStringProperty,
			set = function () return menu.openShipConfig() end,
			formatValue = function (value) return menu.shipValue(value) end,
			active = function () return menu.usespacesuit ~= true end,
		},
		[3] = {
			id = "spacesuit",
			name = ReadText(1021, 11014),
			mouseOverText = ReadText(1026, 9912),
			type = "bool",
			propertyType = "Internal",
			get = function () return menu.usespacesuit end,
			set = function (_, _, checked) menu.usespacesuit = checked; menu.refreshMenu() end,
		},
	}},
	{ id = "playerproperty",	name = ReadText(1021, 5),		type = "property",	rendertarget = true,	budget = { "money", "people" } },
	{ id = "universe",			name = ReadText(1021, 10001),	type = "list",		rendertarget = true,	budget = { "money", "known" },	displayOnRenderTarget = { "map", "sector" },	properties = {
		[1] = {
			id = "seed",
			name = ReadText(1021, 11006),
			mouseOverText = ReadText(1026, 9901),
			type = "editbox",
			propertyType = "String",
			get = C.GetCustomGameStartStringProperty,
			set = C.SetCustomGameStartStringProperty,
		},
		[2] = {
			id = "sector",
			modifyingids = { "offset" },
			name = ReadText(1021, 11001),
			mouseOverText = ReadText(1026, 9913),
			type = "dropdown",
			propertyType = "String",
			get = C.GetCustomGameStartStringProperty,
			set = function (...) return menu.setPlayerSector(...) end,
			formatValue = function (value) return menu.universeSector(value) end,
		},
		[3] = {
			id = "offset",
			propertyType = "PosRot",
			get = C.GetCustomGameStartPosRotProperty,
			set = C.SetCustomGameStartPosRotProperty,
		},
		[4] = {
			id = "universeringhighways",
			name = ReadText(1021, 11004),
			type = "bool",
			propertyType = "Bool",
			get = C.GetCustomGameStartBoolProperty,
			set = C.SetCustomGameStartBoolProperty,
		},
		[5] = {
			id = "universelinearhighways",
			name = ReadText(1021, 11005),
			type = "bool",
			propertyType = "Bool",
			get = C.GetCustomGameStartBoolProperty,
			set = C.SetCustomGameStartBoolProperty,
		},
		[6] = {
			id = "playerknownspace",
			budget = { "known", "money" },
			name = ReadText(1021, 11012),
			mouseOverText = ReadText(1026, 9914),
			type = "multiselect",
			propertyType = "KnownEntry2",
			getState = C.GetCustomGameStartKnownPropertyState,
			get = C.GetCustomGameStartKnownProperty2,
			getDefault = C.GetCustomGameStartKnownDefaultProperty2,
			set = C.SetCustomGameStartKnownProperty2,
			formatValue = function (numValues) return (numValues == 0) and ReadText(1001, 9926) or ReadText(1001, 9925) end,
			selectionText = ReadText(1001, 9927),
		},
	}},
	{ id = "universefactionrelations",	name = ReadText(1021, 10005),	type = "flowchart",	budget = { "relations", "known" } },
	{ id = "universestorystates",		name = ReadText(1021, 10006),	type = "story", budget = "story" },
	{ id = "playerresearch",			name = ReadText(1021, 10004),	type = "flowchart", budget = "research", active = function () return menu.playerresearchActive() end, mouseovertext = function () return menu.playerresearchMouseOver() end },
	{ id = "playerknownfactions",		name = ReadText(1021, 11011),	type = "dummy" },
	{ id = "playerknownobjects",		name = ReadText(1021, 11013),	type = "dummy" },
}

menu.budgets = {
	{ id = "money",		name = ReadText(1001, 9923),	desc = ReadText(1026, 9917),	icon = "gamestart_custom_credits",		color = Color["customgamestart_budget_money"],		suffix = " " .. ReadText(1001, 101),	details = {} },
	{ id = "people",	name = ReadText(1001, 9929),	desc = ReadText(1026, 9918),	icon = "gamestart_custom_people",		color = Color["customgamestart_budget_people"],		suffix = "",							details = {} },
	{ id = "known",		name = ReadText(1001, 9924),	desc = ReadText(1026, 9919),	icon = "gamestart_custom_knowledge",	color = Color["customgamestart_budget_known"],		suffix = "",							details = {} },
	{ id = "relations",	name = ReadText(1001, 9928),	desc = ReadText(1026, 9920),	icon = "gamestart_custom_relations",	color = Color["customgamestart_budget_relations"],	suffix = "",							details = {} },
	{ id = "story",		name = ReadText(1021, 10006),	desc = ReadText(1026, 9921),	icon = "gamestart_custom_story",		color = Color["customgamestart_budget_story"],		suffix = "",							details = {},	type = "story",		property = "universestorystates" },
	{ id = "research",	name = ReadText(1021, 10004),	desc = ReadText(1026, 9922),	icon = "gamestart_custom_research",		color = Color["customgamestart_budget_research"],	suffix = "",							details = {},	type = "research",	property = "universestorystates" },
}
menu.propertybudgets = {}

function menu.onCutsceneReady(_, cutsceneid)
	if menu.cutsceneid and (menu.cutsceneid == cutsceneid) then
		SetRenderTargetNoise(menu.rendertarget.id, false)
	end
end

function menu.onCutsceneStopped(_, cutsceneid)
	if menu.cutsceneid and (menu.cutsceneid == cutsceneid) then
		if menu.cutscenedesc then
			ReleaseCutsceneDescriptor(menu.cutscenedesc)
		end
		menu.cutscenedesc = nil
		menu.cutsceneid = nil
		DestroyPresentationCluster(menu.precluster)
	end
end

function menu.setCategory(category)
	menu.closeContextMenu(true)
	if menu.cutsceneid then
		StopCutscene(menu.cutsceneid)
		menu.cutsceneid = nil
		DestroyPresentationCluster(menu.precluster)
		menu.rendertargetLock = getElapsedTime() + 0.1
	end
	if menu.holomap ~= 0 then
		C.RemoveHoloMap()
		menu.holomap = 0
	end
	if menu.flowchart then
		menu.flowchart:collapseAllNodes()
		menu.flowchart = nil
	end
	menu.category = category or {}
end

function menu.cleanup()
	if not menu.isStartmenu then
		if menu.paused then
			Unpause()
			menu.paused = nil
		end
	end

	menu.customgamestart = nil
	menu.multiplayer = nil
	menu.creative = nil
	menu.category = {}
	if menu.cutsceneid then
		StopCutscene(menu.cutsceneid)
		menu.cutsceneid = nil
		DestroyPresentationCluster(menu.precluster)
	end
	if menu.holomap ~= 0 then
		C.RemoveHoloMap()
		menu.holomap = 0
	end

	menu.techtree = {}
	menu.researchstoriesbyid = {}
	menu.factions = {}
	menu.encyclopedia = {}
	menu.knowndata = {}
	menu.hidestoryspoilers = true
	menu.stories = {}
	menu.storiesbyid = {}
	menu.researchstories = {}
	menu.propertybudgets = {}
	menu.satellites = {}
	menu.playerMacros = {}
	menu.storygroups = {}
	menu.cpwarescache = {}

	menu.flowchartRows = nil
	menu.flowchartCols = nil
	menu.expandedNode = nil
	menu.expandedMenuFrame = nil
	menu.expandedMenuTable = nil
	menu.restoreNode = nil
	menu.restoreNodeTech = nil
	menu.restoreNodeFaction = nil

	menu.width = nil
	menu.topRows = {}
	menu.firstCols = {}
	menu.selectedRows = {}
	menu.selectedCols = {}
	menu.curDropDownOption = {}
	menu.shownPropertyHint = nil
	menu.addingFleet = nil
	menu.usespacesuit = nil
	menu.rendertargetLock = nil
	menu.rightdown = nil

	-- kuertee start: callback
	if callbacks ["cleanup"] then
		for _, callback in ipairs (callbacks ["cleanup"]) do
			callback(menu.customgamestart)
		end
	end
	-- kuertee end: callback
end

function menu.buttonNewGame()
	menu.closeContextMenu()
	if menu.multiplayer then
		C.NewMultiplayerGame(menu.customgamestart)
	else

		-- kuertee start: callback
		if callbacks ["buttonNewGame_preNewGame"] then
			for _, callback in ipairs (callbacks ["buttonNewGame_preNewGame"]) do
				callback(menu.customgamestart)
			end
		end
		-- kuertee end: callback

		NewGame(menu.customgamestart)
	end
	menu.displayInit()
end

function menu.buttonReset()
	menu.closeContextMenu()
	C.ResetCustomGameStart(menu.customgamestart)
	menu.satellites = {}
	menu.usespacesuit = nil
	if next(menu.category) then
		if menu.category.id == "universe" then
			if menu.holomap ~= 0 then
				C.RemoveHoloMap()
				menu.holomap = 0
			end
		elseif menu.category.id == "ship" then
			if menu.cutsceneid then
				StopCutscene(menu.cutsceneid)
				menu.cutsceneid = nil
				DestroyPresentationCluster(menu.precluster)
			end
		elseif (menu.category.id == "playerresearch") or (menu.category.id == "universefactionrelations") then
			if menu.flowchart then
				menu.flowchart:collapseAllNodes()
				menu.flowchart = nil
			end
		end
	end

	menu.initEncyclopediaValue()
	menu.initKnownValue()
	menu.initStoryValue()
	menu.initSatellites()
	if menu.category.id == "playerresearch" then
		if not menu.playerresearchActive() then
			menu.setCategory(nil)
		end
	end
	menu.refresh = getElapsedTime()

	-- kuertee start: callback
	if callbacks ["buttonReset_on_end"] then
		for _, callback in ipairs (callbacks ["buttonReset_on_end"]) do
			callback ()
		end
	end
	-- kuertee end: callback
end

function menu.buttonBoolProperty(property)
	property.value = not property.value
	if property.id == "universeringhighways" then
		C.SetMacroMapLocalRingHighways(menu.holomap, property.value)
	elseif property.id == "universelinearhighways" then
		C.SetMacroMapLocalLinearHighways(menu.holomap, property.value)
	elseif property.id == "spacesuit" then
		if property.value then
			local buf = ffi.new("CustomGameStartStringPropertyState[1]")
			local playermacro = ffi.string(C.GetCustomGameStartStringProperty(menu.customgamestart, "player", buf))
			local spacesuitmacro = GetMacroData(playermacro, "spacesuitmacro")
			C.SetCustomGameStartShipAndEmptyLoadout(menu.customgamestart, "ship", "shiploadout", spacesuitmacro)
			C.ResetCustomGameStartProperty(menu.customgamestart, "shipname")
		else
			C.ResetCustomGameStartProperty(menu.customgamestart, "ship")
			C.ResetCustomGameStartProperty(menu.customgamestart, "shiploadout")
		end
		if menu.cutsceneid then
			StopCutscene(menu.cutsceneid)
			menu.cutsceneid = nil
			DestroyPresentationCluster(menu.precluster)
			menu.rendertargetLock = getElapsedTime() + 0.1
		end
	end
	property.set(menu.customgamestart, property.id, property.value)
end

function menu.buttonMultiSelectConfirm(property)
	for i = #property.value, 1, -1 do
		if not menu.contextMenuData.selectedOptions[property.value[i].id] then
			if property.id == "playerknownspace" then
				menu.setKnownValue("playerknownobjects", property.value[i].id, false)
				menu.saveKnownValue("playerknownobjects")

				if menu.satellites[property.value[i].id] then
					for _, id in ipairs(menu.satellites[property.value[i].id]) do
						C.RemoveCustomGameStartPlayerProperty(menu.customgamestart, "playerproperty", id)
					end
					menu.satellites[property.value[i].id] = nil
				end
				menu.setKnownValue(property.id, property.value[i].id, false)
			end
			table.remove(property.value, i)
		else
			menu.contextMenuData.selectedOptions[property.value[i].id] = nil
		end
	end
	for id in pairs(menu.contextMenuData.selectedOptions) do
		if property.propertyType == "Inventory" then
			table.insert(property.value, { id = id, name = GetWareData(id, "name"), amount = 1, defaultamount = 0 })
		elseif property.propertyType == "Blueprint" then
			table.insert(property.value, { id = id, name = GetWareData(id, "name"), default = false })
		elseif property.propertyType == "KnownEntry2" then
			table.insert(property.value, { id = id, name = GetMacroData(id, "name"), default = false })
			menu.setKnownValue(property.id, id, true)
		end
	end

	menu.saveMultiSelect(property)

	menu.closeContextMenu()
	menu.refresh = getElapsedTime()
end

function menu.buttonSelectResearch(techdata, mainIdx, col)
	techdata.completed = not techdata.completed
	menu.category.value[techdata.tech] = techdata.completed or nil
	if menu.researchstoriesbyid[techdata.tech] then
		menu.researchstories[menu.researchstoriesbyid[techdata.tech].id] = techdata.completed or nil
	end
	if techdata.completed then
		if col > 1 then
			for prevCol = col - 1, 1, -1 do
				for _, techentry in ipairs(menu.techtree[mainIdx][prevCol]) do
					techentry.completed = true
					menu.category.value[techentry.tech] = true
					if menu.researchstoriesbyid[techentry.tech] then
						menu.researchstories[menu.researchstoriesbyid[techentry.tech].id] = true
					end
				end
			end
		end
	else
		if col < #menu.techtree[mainIdx] then
			for nextCol = col + 1, #menu.techtree[mainIdx] do
				for _, techentry in ipairs(menu.techtree[mainIdx][nextCol]) do
					techentry.completed = false
					menu.category.value[techentry.tech] = nil
					if menu.researchstoriesbyid[techentry.tech] then
						menu.researchstories[menu.researchstoriesbyid[techentry.tech].id] = nil
					end
				end
			end
		end
	end

	local numresearchwares = 0
	for _ in pairs(menu.category.value) do
		numresearchwares = numresearchwares + 1
	end
	local researchwares = ffi.new("const char*[?]", numresearchwares)
	local idx = 0
	for ware in pairs(menu.category.value) do
		researchwares[idx] = Helper.ffiNewString(ware)
		idx = idx + 1
	end

	C.SetCustomGameStartResearchProperty(menu.customgamestart, menu.category.id, researchwares, numresearchwares)
	menu.saveStoryValue("universestorystates")

	Helper.ffiClearNewHelper()

	menu.restoreNodeTech = techdata.tech
	menu.refresh = getElapsedTime()
end

function menu.buttonExpandProperty(id)
	RemoveHighlightOverlay("property_expand")
	if menu.expandedProperty[id] then
		menu.expandedProperty[id] = nil
	else
		menu.expandedProperty[id] = true
	end
	menu.refresh = getElapsedTime()
end

function menu.buttonRemovePlayerProperty(id)
	C.RemoveCustomGameStartPlayerProperty(menu.customgamestart, menu.category.id, id)
	menu.refresh = getElapsedTime()
end

function menu.buttonMapContextSelectSector(macro, remove)
	local knownspaceproperty = menu.findProperty("playerknownspace")
	if knownspaceproperty then
		menu.initPropertyValue(knownspaceproperty)

		local found
		for j, entry in ipairs(knownspaceproperty.value) do
			if entry.id == macro then
				found = j
				break
			end
		end
		if found and remove then
			table.remove(knownspaceproperty.value, found)
		end
		if (not found) and (not remove) then
			table.insert(knownspaceproperty.value, { id = macro, name = GetMacroData(macro, "name"), default = false })
		end
		menu.saveMultiSelect(knownspaceproperty)
	end

	menu.closeContextMenu()
end

function menu.buttonMapContextKnownStations(macro, checked)
	menu.checkboxKnownStations(macro, checked)
	menu.closeContextMenu()
end

function menu.buttonMapContextSatelliteCoverage(macro, checked)
	menu.checkboxSatelliteCoverage(macro, checked)
	menu.closeContextMenu()
end

function menu.buttonExport(checked)
	if not checked then
		menu.displayExportContext()
	else
		local filename = utf8.gsub(menu.gamestartName, "[^%w_%-%() ]", "_")
		C.ExportCustomGameStart(filename, menu.customgamestart, menu.gamestartName or "")
		menu.closeContextMenu()
		menu.refreshMenu()
	end
end

function menu.buttonConstructionCommunity()
	if C.CanOpenWebBrowser() then
		C.OpenWebBrowser(ReadText(1001, 7976))
	end
end

function menu.buttonResetBudget(budgetid)
	if budgetid == "story" then
		C.ResetCustomGameStartProperty(menu.customgamestart, "universestorystates")
		C.ResetCustomGameStartProperty(menu.customgamestart, "playerresearch")
		menu.initStoryValue()
		menu.removeHQ()
		if menu.category.id == "playerresearch" then
			if not menu.playerresearchActive() then
				menu.setCategory(nil)
			end
		end
	elseif budgetid == "research" then
		C.ResetCustomGameStartProperty(menu.customgamestart, "playerresearch")
		menu.initResearch()
		if menu.category.id == "playerresearch" then
			if not menu.playerresearchActive() then
				menu.setCategory(nil)
			end
		end
	elseif budgetid == "known" then
		C.ResetCustomGameStartProperty(menu.customgamestart, "playerknownfactions")
		C.ResetCustomGameStartProperty(menu.customgamestart, "playerknownobjects")
		C.ResetCustomGameStartProperty(menu.customgamestart, "playerknownspace")
		menu.initKnownValue()

		-- restore sectors that are locked for player property
		local lockedsectors = {}
		local buf = ffi.new("CustomGameStartStringPropertyState[1]")
		local playersectormacro = ffi.string(C.GetCustomGameStartStringProperty(menu.customgamestart, "sector", buf))
		table.insert(lockedsectors, playersectormacro)
		local state = C.GetCustomGameStartPlayerPropertyPropertyState(menu.customgamestart, "playerproperty")
		if state.numvalues > 0 then
			local counts = ffi.new("CustomGameStartPlayerPropertyCounts[?]", state.numvalues)
			local n = C.GetCustomGameStartPlayerPropertyCounts(counts, state.numvalues, menu.customgamestart, "playerproperty")
			if n > 0 then
				local buf = ffi.new("CustomGameStartPlayerProperty3[?]", n)
				for i = 0, n - 1 do
					buf[i].numcargo = counts[i].numcargo
					buf[i].cargo = Helper.ffiNewHelper("UIWareInfo[?]", counts[i].numcargo)
				end
				n = C.GetCustomGameStartPlayerPropertyProperty3(buf, n, menu.customgamestart, "playerproperty")
				for i = 0, n - 1 do
					local sector = ffi.string(C.GetCustomGameStartPlayerPropertySector(menu.customgamestart, "playerproperty", ffi.string(buf[i].id)))
					if sector ~= "" then
						table.insert(lockedsectors, sector)
					end
				end
			end
		end
		for _, sector in ipairs(lockedsectors) do
			menu.setKnownValue("playerknownspace", sector, true)
		end
		menu.saveKnownValue("playerknownspace")
	elseif budgetid == "people" then
		C.ResetCustomGameStartProperty(menu.customgamestart, "shippeople")
		C.ResetCustomGameStartProperty(menu.customgamestart, "shippeoplefillpercent")

		local buf = ffi.new("CustomGameStartStringPropertyState[1]")
		local state = C.GetCustomGameStartPlayerPropertyPropertyState(menu.customgamestart, "playerproperty")
		if state.numvalues > 0 then
			local counts = ffi.new("CustomGameStartPlayerPropertyCounts[?]", state.numvalues)
			local n = C.GetCustomGameStartPlayerPropertyCounts(counts, state.numvalues, menu.customgamestart, "playerproperty")
			if n > 0 then
				local buf = ffi.new("CustomGameStartPlayerProperty3[?]", n)
				for i = 0, n - 1 do
					buf[i].numcargo = counts[i].numcargo
					buf[i].cargo = Helper.ffiNewHelper("UIWareInfo[?]", counts[i].numcargo)
				end
				n = C.GetCustomGameStartPlayerPropertyProperty3(buf, n, menu.customgamestart, "playerproperty")
				for i = 0, n - 1 do
					local entryid = ffi.string(buf[i].id)
					C.SetCustomGameStartPlayerPropertyPeople(menu.customgamestart, "playerproperty", entryid, "")
					C.SetCustomGameStartPlayerPropertyPeopleFillPercentage2(menu.customgamestart, "playerproperty", entryid, 0)
					menu.initManagerSkills("playerproperty", entryid)
				end
			end
		end
	else
		for i, budget in ipairs(menu.budgets) do
			if (not budget.inactive) and (budget.id == budgetid) then
				for j, detail in ipairs(budget.details) do
					C.ResetCustomGameStartProperty(menu.customgamestart, detail.property)
					if detail.property == "ship" then
						C.ResetCustomGameStartProperty(menu.customgamestart, "shiploadout")
						menu.usespacesuit = nil
						if menu.category.id == "ship" then
							if menu.cutsceneid then
								StopCutscene(menu.cutsceneid)
								menu.cutsceneid = nil
								DestroyPresentationCluster(menu.precluster)
							end
						end
					elseif detail.property == "playerproperty" then
						menu.satellites = {}
						menu.initSatellites()
					end
				end
			end
		end
	end
	menu.refreshMenu()
end

function menu.checkboxMultiSelect(option, checked)
	menu.contextMenuData.selectedOptions[option] = checked or nil
end

function menu.checkboxToggleMultiSelect(checked)
	for _, data in ipairs(menu.contextMenuData.options) do
		for _, entry in ipairs(data.wares) do
			if not menu.contextMenuData.propertyLockedWares[entry.id] then
				menu.contextMenuData.selectedOptions[entry.id] = checked or nil
			end
		end
	end
end

function menu.checkboxKnownFaction(faction, checked)
	menu.setKnownValue("playerknownfactions", faction, checked)
	menu.saveKnownValue("playerknownfactions")
end

function menu.checkboxKnownStations(sector, checked)
	menu.setKnownValue("playerknownobjects", sector, checked)
	menu.saveKnownValue("playerknownobjects")
	menu.refreshMenu()
end

function menu.addSatellite(sector, id, x, z)
	local entryid = ffi.string(C.SetCustomGameStartPlayerPropertyObjectMacro(menu.customgamestart, "playerproperty", id, config.satellites.macro))
	if entryid ~= "" then
		local sectorpos = ffi.new("UIPosRot", {
			x = x, 
			y = 0, 
			z = z, 
			yaw = 0, 
			pitch = 0, 
			roll = 0
		})
		C.SetCustomGameStartPlayerPropertySectorAndOffset(menu.customgamestart, "playerproperty", entryid, sector, sectorpos)

		menu.satellites[sector] = menu.satellites[sector] or { totalvalue = 0 }
		table.insert(menu.satellites[sector], entryid)
		menu.satellites[sector].totalvalue = menu.satellites[sector].totalvalue + tonumber(C.GetCustomGameStartPlayerPropertyValue(menu.customgamestart, "playerproperty", entryid))
	end
end

function menu.checkboxSatelliteCoverage(sector, checked)
	if checked then
		local radarrange = GetMacroData(config.satellites.macro, "maxradarrange")
		-- maximum distance between 2 circles to cover a plane completely! in circles
		local effectiverange = radarrange * math.cos(math.pi / 6)
		local y_offset = radarrange * (1 + math.sin(math.pi / 6))

		local x_num = math.ceil(config.satellites.coverageradius / effectiverange)
		local overcoverage = x_num * effectiverange - config.satellites.coverageradius

		for x_ind = 1, x_num do
			local x = -config.satellites.coverageradius + (2 * x_ind - 1) * effectiverange - overcoverage
			menu.addSatellite(sector, sector .. "_satellite_" .. x_ind .. "_0", x, 0)
		end
		for y_ind = 1, math.floor(x_num / 2) do
			local x_max = x_num - y_ind
			for x_ind = 1, x_max do
				local x = (2 * x_ind - x_max - 1) * effectiverange
				local y = y_ind * y_offset
				menu.addSatellite(sector, sector .. "_satellite_" .. x_ind .. "_" .. y_ind, x, y)
				menu.addSatellite(sector, sector .. "_satellite_" .. x_ind .. "_" .. -y_ind, x, -y)
			end
		end
	else
		local ids = menu.satellites[sector] or {}
		for _, id in ipairs(ids) do
			C.RemoveCustomGameStartPlayerProperty(menu.customgamestart, "playerproperty", id)
		end
		menu.satellites[sector] = nil
	end
	menu.refreshMenu()
end

function menu.dropdownCurrentFaction(_, option)
	if option ~= menu.currentfaction.id then
		for _, factiondata in ipairs(menu.factions) do
			if factiondata.id == option then
				menu.currentfaction = factiondata

				menu.restoreNodeFaction = "current"
				menu.refresh = getElapsedTime()
				break
			end
		end
	end
end

function menu.dropdownProperty(property, row, option)
	-- kuertee start: callback
	if callbacks ["dropdownProperty_on_start"] then
		for _, callback in ipairs (callbacks ["dropdownProperty_on_start"]) do
			callback (property, row, option)
		end
	end
	-- kuertee end: callback

	if option ~= menu.curDropDownOption[property.id] then
		menu.curDropDownOption[property.id] = option
		property.value = option
		if property.id == "sector" then
			local buf = ffi.new("CustomGameStartPosRotPropertyState[1]")
			local sectoroffset = C.GetCustomGameStartPosRotProperty(menu.customgamestart, "offset", buf)
			menu.setKnownValue("playerknownspace", option, true)
			menu.saveKnownValue("playerknownspace")
			menu.refresh = getElapsedTime()
		end
		if property.replaceempty and (property.replaceempty == option) then
			option = ""
		end
		property.set(menu.customgamestart, property.id, option)
	end
end

function menu.addHQ()
	local entrybaseid = "player_HQ"
	local cpid = "x4ep1_playerheadquarters_with_dock"

	local found = false
	local buf = ffi.new("CustomGameStartStringPropertyState[1]")
	local state = C.GetCustomGameStartPlayerPropertyPropertyState(menu.customgamestart, "playerproperty")
	if state.numvalues > 0 then
		local counts = ffi.new("CustomGameStartPlayerPropertyCounts[?]", state.numvalues)
		local n = C.GetCustomGameStartPlayerPropertyCounts(counts, state.numvalues, menu.customgamestart, "playerproperty")
		if n > 0 then
			local buf = ffi.new("CustomGameStartPlayerProperty3[?]", n)
			for i = 0, n - 1 do
				buf[i].numcargo = counts[i].numcargo
				buf[i].cargo = Helper.ffiNewHelper("UIWareInfo[?]", counts[i].numcargo)
			end
			n = C.GetCustomGameStartPlayerPropertyProperty3(buf, n, menu.customgamestart, "playerproperty")
			for i = 0, n - 1 do
				if string.find(ffi.string(buf[i].id), entrybaseid, 1, true) then
					found = true
					break
				end
			end
		end
	end

	if not found then
		local entryid = ffi.string(C.SetCustomGameStartPlayerPropertyMacroAndConstructionPlan2(menu.customgamestart, "playerproperty", entrybaseid, "station_pla_headquarters_base_01_macro", cpid))
		if entryid ~= "" then
			local blueprintproperty = menu.findProperty("playerblueprints")
			if blueprintproperty then
				menu.initPropertyValue(blueprintproperty)

				for ware in pairs(menu.getCPWares(cpid)) do
					local found = false
					for j, entry in ipairs(blueprintproperty.value) do
						if entry.id == ware then
							found = true
							break
						end
					end
					if not found then
						table.insert(blueprintproperty.value, { id = ware, name = GetWareData(ware, "name"), default = false })
					end
				end
				menu.saveMultiSelect(blueprintproperty)
			end

			local sector = "cluster_01_sector001_macro"
			local sectorpos = ffi.new("UIPosRot", {
				x = 128000, 
				y = 0, 
				z = 198000, 
				yaw = 0, 
				pitch = 0, 
				roll = 0
			})
			C.SetCustomGameStartPlayerPropertySectorAndOffset(menu.customgamestart, "playerproperty", entryid, sector, sectorpos)

			menu.initManagerSkills("playerproperty", entryid)

			menu.setKnownValue("playerknownspace", sector, true)
			menu.saveKnownValue("playerknownspace")
		end
	end
end

function menu.initManagerSkills(property, entryid)
	local numskills = C.GetNumSkills()
	local buf = ffi.new("CustomGameStartPersonEntry")
	buf.race = ""
	buf.tags = ""
	local skillbuf = ffi.new("SkillInfo[?]", numskills)
	numskills = C.GetSkills(skillbuf, numskills)
	buf.numskills = numskills
	buf.skills = Helper.ffiNewHelper("SkillInfo[?]", buf.numskills)
	for i = 0, numskills - 1 do
		buf.skills[i].id = skillbuf[i].id
		buf.skills[i].value = 0
	end
	C.SetCustomGameStartPlayerPropertyPerson(menu.customgamestart, property, entryid, buf)
end

function menu.removeHQ()
	local entrybaseid = "player_HQ"

	local buf = ffi.new("CustomGameStartStringPropertyState[1]")
	local state = C.GetCustomGameStartPlayerPropertyPropertyState(menu.customgamestart, "playerproperty")
	if state.numvalues > 0 then
		local counts = ffi.new("CustomGameStartPlayerPropertyCounts[?]", state.numvalues)
		local n = C.GetCustomGameStartPlayerPropertyCounts(counts, state.numvalues, menu.customgamestart, "playerproperty")
		if n > 0 then
			local buf = ffi.new("CustomGameStartPlayerProperty3[?]", n)
			for i = 0, n - 1 do
				buf[i].numcargo = counts[i].numcargo
				buf[i].cargo = Helper.ffiNewHelper("UIWareInfo[?]", counts[i].numcargo)
			end
			n = C.GetCustomGameStartPlayerPropertyProperty3(buf, n, menu.customgamestart, "playerproperty")
			for i = 0, n - 1 do
				local id = ffi.string(buf[i].id)
				if string.find(id, entrybaseid, 1, true) then
					C.RemoveCustomGameStartPlayerProperty(menu.customgamestart, "playerproperty", id)
					break
				end
			end
		end
	end
end

function menu.dropdownPlayerPropertyAddStation(entryid, cpid, isHQentry, isNewStation)
	local entryid = ffi.string(C.SetCustomGameStartPlayerPropertyMacroAndConstructionPlan2(menu.customgamestart, menu.category.id, entryid, isHQentry and "station_pla_headquarters_base_01_macro" or "station_gen_factory_base_01_macro", cpid))

	if entryid ~= "" then
		local blueprintproperty = menu.findProperty("playerblueprints")
		if blueprintproperty then
			menu.initPropertyValue(blueprintproperty)

			for ware in pairs(menu.getCPWares(cpid)) do
				local found = false
				for j, entry in ipairs(blueprintproperty.value) do
					if entry.id == ware then
						found = true
						break
					end
				end
				if not found then
					table.insert(blueprintproperty.value, { id = ware, name = GetWareData(ware, "name"), default = false })
				end
			end
			menu.saveMultiSelect(blueprintproperty)
		end

		if isNewStation then
			menu.initManagerSkills(menu.category.id, entryid)
		end

		local sector = ffi.string(C.GetCustomGameStartPlayerPropertySector(menu.customgamestart, menu.category.id, entryid))
		if sector ~= "" then
			menu.setKnownValue("playerknownspace", sector, true)
		end
		menu.saveKnownValue("playerknownspace")
	end

	menu.selectedCols.propertyTable = 2
	menu.refresh = getElapsedTime()

	if (entryid ~= "") and (not menu.shownPropertyHint) then
		menu.shownPropertyHint = getElapsedTime()
		menu.displayHint(ReadText(1001, 9935))
		menu.showHighlightOverlay = "property_expand"
	end
end

function menu.dropdownImport(filename)
	menu.closeContextMenu()
	C.ResetCustomGameStart(menu.customgamestart)
	menu.satellites = {}
	menu.usespacesuit = nil
	if next(menu.category) then
		if menu.category.id == "universe" then
			if menu.holomap ~= 0 then
				C.RemoveHoloMap()
				menu.holomap = 0
			end
		elseif menu.category.id == "ship" then
			if menu.cutsceneid then
				StopCutscene(menu.cutsceneid)
				menu.cutsceneid = nil
				DestroyPresentationCluster(menu.precluster)
			end
		elseif (menu.category.id == "playerresearch") or (menu.category.id == "universefactionrelations") then
			if menu.flowchart then
				menu.flowchart:collapseAllNodes()
				menu.flowchart = nil
			end
		end
	end

	C.ImportCustomGameStart(menu.customgamestart, filename, menu.customgamestart)
	
	menu.initEncyclopediaValue()
	menu.initKnownValue()
	menu.initStoryValue()
	menu.initSatellites()

	if menu.category.id == "playerresearch" then
		if not menu.playerresearchActive() then
			menu.setCategory(nil)
		end
	end
	menu.refreshMenu()
end

function menu.editboxNameUpdateText(_, text)
	menu.gamestartName = text
end

function menu.getCPWares(cpid)
	if not menu.cpwarescache[cpid] then
		menu.cpwarescache[cpid] = {}
		local n = C.GetNumConstructionPlanInfo(cpid)
		local buf = ffi.new("UIConstructionPlanEntry[?]", n)
		n = tonumber(C.GetConstructionPlanInfo(buf, n, cpid))
		for i = 0, n - 1 do
			local macro = ffi.string(buf[i].macroid)
			local ware = GetMacroData(macro, "ware")
			if ware then
				local hasblueprint, isdeprecated, isplayerblueprintallowed, nocustomgamestart, blueprintsowners, ismissiononly = GetWareData(ware, "hasblueprint", "isdeprecated", "isplayerblueprintallowed", "nocustomgamestart", "blueprintsowners", "ismissiononly")
				if menu.creative then
					nocustomgamestart = false
				end
				local isventure = false
				for i, owner in ipairs(blueprintsowners) do
					if owner == "visitor" then
						isventure = true
						break
					end
				end
				if hasblueprint and (not isdeprecated) and isplayerblueprintallowed and (not nocustomgamestart) and (not isventure) and (not ismissiononly) then
					menu.cpwarescache[cpid][ware] = true
				end
			end
		end
	end
	return menu.cpwarescache[cpid]
end

function menu.initPropertyValue(property)
	local bufstate = property.getState(menu.customgamestart, property.id)
	property.state = ffi.string(bufstate.state)

	local defaultvalues = {}
	local n = bufstate.numdefaultvalues
	local buf = ffi.new("CustomGameStart" .. property.propertyType .. "[?]", n)
	n = property.getDefault(buf, n, menu.customgamestart, property.id)
	for i = 0, n - 1 do
		if property.propertyType == "Inventory" then
			defaultvalues[ffi.string(buf[i].ware)] = buf[i].amount
		elseif property.propertyType == "Blueprint" then
			defaultvalues[ffi.string(buf[i].ware)] = true
		elseif property.propertyType == "KnownEntry2" then
			defaultvalues[ffi.string(buf[i].item)] = true
		end
	end

	local excludedvalues = {}
	property.value = {}
	local n = bufstate.numvalues
	local buf = ffi.new("CustomGameStart" .. property.propertyType .. "[?]", n)
	n = property.get(buf, n, menu.customgamestart, property.id)
	for i = 0, n - 1 do
		local entry = {}
		if property.propertyType == "Inventory" then
			local ware = ffi.string(buf[i].ware)
			entry.id = ware
			entry.name = GetWareData(ware, "name")
			entry.amount = buf[i].amount
			entry.defaultamount = defaultvalues[ware] or 0
		elseif property.propertyType == "Blueprint" then
			local ware = ffi.string(buf[i].ware)
			entry.id = ware
			entry.name = GetWareData(ware, "name")
			entry.default = defaultvalues[ware] or false
		elseif property.propertyType == "KnownEntry2" then
			local item = ffi.string(buf[i].item)
			entry.id = item
			entry.name = GetMacroData(item, "name")
			entry.budgetvalue = tonumber(buf[i].budgetvalue)
			entry.default = defaultvalues[item] or false
		end
		local skip = false
		if property.excludetags then
			local tags = GetWareData(entry.id, "tags") or {}
			for _, excludedtag in ipairs(property.excludetags) do
				if tags[excludedtag] then
					skip = true
					break
				end
			end
		end
		if not skip then
			table.insert(property.value, entry)
		else
			table.insert(excludedvalues, entry)
		end
	end
	if not menu.excludedvalues[property.id] then
		menu.excludedvalues[property.id] = {}
		for _, entry in ipairs(excludedvalues) do
			table.insert(menu.excludedvalues[property.id], entry.id)
		end
	end
	table.sort(property.value, Helper.sortName)
end

function menu.dropdownPlayerPropertySetSector(entryid, sector, offset)
	C.SetCustomGameStartPlayerPropertySectorAndOffset(menu.customgamestart, menu.category.id, entryid, sector, offset)
	menu.setKnownValue("playerknownspace", sector, true)
	menu.saveKnownValue("playerknownspace")
	menu.refresh = getElapsedTime()
end

function menu.cleanupFactionRelationsAllowedByStory(oldstoryid, newstoryid)
	for faction, stories in pairs(config.factionrelationsallowedbystory) do
		if stories[oldstoryid] and (not stories[newstoryid]) then
			menu.removeFactionRelationHelper(faction)
		end
	end
end

function menu.cleanupKnownSectorsAllowedByStory(oldstoryid, newstoryid)
	local knownspaceproperty = menu.findProperty("playerknownspace")
	if knownspaceproperty then
		menu.initPropertyValue(knownspaceproperty)

		for i = #knownspaceproperty.value, 1, -1 do
			local entry = knownspaceproperty.value[i]
			local knownitem = ffi.new("CustomGameStartKnownEntry2")
			knownitem.type = Helper.ffiNewString("sector")
			knownitem.item = Helper.ffiNewString(entry.id)
			local sectordependencies = menu.getStoryDependencies("playerknownspace", knownitem)
			local needstoberemoved = false
			for _, dependencylist in ipairs(sectordependencies) do
				local hasold, hasnew
				for _, dependency in ipairs(dependencylist) do
					if dependency == oldstoryid then
						hasold = true
					elseif dependency == newstoryid then
						hasnew = true
					end
				end
				if hasold and (not hasnew) then
					needstoberemoved = true
					break
				end
			end

			if needstoberemoved then
				menu.setKnownValue("playerknownspace", knownspaceproperty.value[i].id, false)
				table.remove(knownspaceproperty.value, i)
			end
		end
		menu.saveMultiSelect(knownspaceproperty)
	end
end

function menu.toggleStoryHQ(storyid)
	if storyid == "default" then
		C.ResetCustomGameStartProperty(menu.customgamestart, "playerresearch")
		menu.initResearch()
		menu.removeHQ()
	else
		menu.addHQ()
	end
end

function menu.dropdownStoryState(groupid, storyid)
	local id = (storyid == "default") and "" or storyid
	local oldid = (menu.stories[groupid].currentstory == "") and "default" or menu.stories[groupid].currentstory
	menu.stories[groupid].currentstory = id

	-- cleanup faction relations
	menu.cleanupFactionRelationsAllowedByStory(oldid, storyid)

	-- cleanup HQ
	if groupid == "hq_and_staff" then
		menu.toggleStoryHQ(storyid)
	end

	-- cleanup dependencies
	for groupid2, storyentry in pairs(menu.stories) do
		local story = menu.storiesbyid[storyentry.currentstory]
		if story and next(story.dependencies) then
			for _, dependencylist in ipairs(story.dependencies) do
				local found = false
				for _, dependency in ipairs(dependencylist) do
					for _, entry in pairs(menu.stories) do
						if entry.currentstory == dependency then
							found = true
							break
						end
					end
				end
				if not found then
					local olddependentid = storyentry.currentstory
					menu.stories[groupid2].currentstory = ""

					menu.cleanupKnownSectorsAllowedByStory(olddependentid, "")
					menu.cleanupFactionRelationsAllowedByStory(olddependentid, "default")

					if groupid2 == "hq_and_staff" then
						menu.toggleStoryHQ(storyid)
					end
				end
			end
		end
	end

	-- cleanup sectors with story dependencies
	menu.cleanupKnownSectorsAllowedByStory(oldid, id)

	menu.saveStoryValue(menu.category.id)
	menu.refreshMenu()
end

function menu.dropdownPlayerPropertySetCount(entryid, count, macro, oldcount)
	C.SetCustomGameStartPlayerPropertyCount(menu.customgamestart, menu.category.id, entryid, count)
	menu.usedlimitedships[macro] = menu.usedlimitedships[macro] - oldcount + count
	menu.refresh = getElapsedTime()
end

function menu.editboxProperty(property, text)
	property.value = text
	property.set(menu.customgamestart, property.id, text)

	-- kuertee start: callback
	if callbacks ["editboxProperty_on_end"] then
		for _, callback in ipairs (callbacks ["editboxProperty_on_end"]) do
			callback (property, text)
		end
	end
	-- kuertee end: callback
end

function menu.editboxPlayerPropertyName(id, text)
	C.SetCustomGameStartPlayerPropertyName(menu.customgamestart, menu.category.id, id, text)
end

function menu.slidercellFaction(faction, value)
	if faction.relation == value then
		menu.removeFactionRelation(menu.category.value, menu.currentfaction.id, faction.id)
	else
		menu.setFactionRelation(menu.category.value, menu.currentfaction.id, faction.id, value)
	end

	local relationinfo = {}
	local relationpairs = {}
	for relationfaction, entry in pairs(menu.category.value) do
		for otherfaction, relation in pairs(entry) do
			if not relationpairs[relationfaction .. "+" .. otherfaction] then
				relationpairs[relationfaction .. "+" .. otherfaction] = true
				relationpairs[otherfaction .. "+" .. relationfaction] = true
				table.insert(relationinfo, { faction = relationfaction, otherfaction = otherfaction, relation = relation })
			end
		end
	end

	local relations = ffi.new("CustomGameStartRelationInfo[?]", #relationinfo)
	for i, entry in ipairs(relationinfo) do
		relations[i - 1].factionid = Helper.ffiNewString(entry.faction)
		relations[i - 1].otherfactionid = Helper.ffiNewString(entry.otherfaction)
		relations[i - 1].relation = entry.relation
	end

	C.SetCustomGameStartRelationsProperty(menu.customgamestart, menu.category.id, relations, #relationinfo)
	Helper.ffiClearNewHelper()

	-- kuertee start: callback
	if callbacks ["slidercellFaction_on_end"] then
		for _, callback in ipairs (callbacks ["slidercellFaction_on_end"]) do
			callback (faction, value)
		end
	end
	-- kuertee end: callback
end

function menu.removeFactionRelationHelper(faction)
	for _, entry in ipairs(menu.factions) do
		menu.removeFactionRelation(entry.relations, entry.id, faction)
	end

	local factionrelations = {}
	local n = C.GetCustomGameStartRelationsPropertyCounts(menu.customgamestart, menu.category.id)
	local buf = ffi.new("CustomGameStartRelationInfo[?]", n)
	n = C.GetCustomGameStartRelationsProperty(buf, n, menu.customgamestart, menu.category.id)
	for i = 0, n - 1 do
		menu.setFactionRelation(factionrelations, ffi.string(buf[i].factionid), ffi.string(buf[i].otherfactionid), buf[i].relation)
	end

	local relationinfo = {}
	local relationpairs = {}
	for relationfaction, entry in pairs(factionrelations) do
		for otherfaction, relation in pairs(entry) do
			if not relationpairs[relationfaction .. "+" .. otherfaction] then
				print(relationfaction .. ", " .. otherfaction)
				relationpairs[relationfaction .. "+" .. otherfaction] = true
				relationpairs[otherfaction .. "+" .. relationfaction] = true
				table.insert(relationinfo, { faction = relationfaction, otherfaction = otherfaction, relation = relation })
			end
		end
	end

	local relations = ffi.new("CustomGameStartRelationInfo[?]", #relationinfo)
	for i, entry in ipairs(relationinfo) do
		relations[i - 1].factionid = Helper.ffiNewString(entry.faction)
		relations[i - 1].otherfactionid = Helper.ffiNewString(entry.otherfaction)
		relations[i - 1].relation = entry.relation
	end

	C.SetCustomGameStartRelationsProperty(menu.customgamestart, "universefactionrelations", relations, #relationinfo)
	Helper.ffiClearNewHelper()

	-- kuertee start: callback
	if callbacks ["removeFactionRelationHelper_on_end"] then
		for _, callback in ipairs (callbacks ["removeFactionRelationHelper_on_end"]) do
			callback (faction)
		end
	end
	-- kuertee end: callback
end

function menu.saveMultiSelect(property)
	local numdata = #property.value + #menu.excludedvalues[property.id]
	local data = ffi.new("CustomGameStart" .. property.propertyType .. "[?]", numdata)
	local i = 0
	if property.propertyType == "Inventory" then
		for _, entry in ipairs(property.value) do
			data[i].ware = Helper.ffiNewString(entry.id)
			data[i].amount = entry.amount
			i = i + 1
		end
		for _, id in ipairs(menu.excludedvalues[property.id]) do
			local found = false
			for _, entry in ipairs(property.value) do
				if entry.id == id then
					found = true
					break
				end
			end
			if not found then
				data[i].ware = Helper.ffiNewString(entry.id)
				data[i].amount = entry.amount
				i = i + 1
			end
		end
	elseif property.propertyType == "Blueprint" then
		for _, entry in ipairs(property.value) do
			data[i].ware = Helper.ffiNewString(entry.id)
			i = i + 1
		end
		for _, id in ipairs(menu.excludedvalues[property.id]) do
			local found = false
			for _, entry in ipairs(property.value) do
				if entry.id == id then
					found = true
					break
				end
			end
			if not found then
				data[i].ware = Helper.ffiNewString(id)
				i = i + 1
			end
		end
	elseif property.propertyType == "KnownEntry2" then
		for _, entry in ipairs(property.value) do
				data[i].type = "sector"
				data[i].item = Helper.ffiNewString(entry.id)
				i = i + 1
		end
		for _, id in ipairs(menu.excludedvalues[property.id]) do
			local found = false
			for _, entry in ipairs(property.value) do
				if entry.id == id then
					found = true
					break
				end
			end
			if not found then
				data[i].type = "sector"
				data[i].item = Helper.ffiNewString(entry.id)
				i = i + 1
			end
		end
	end
	property.set(menu.customgamestart, property.id, data, i)
	Helper.ffiClearNewHelper()
end

function menu.slidercellMultiSelect(property, entryid, row, value)
	if property.propertyType == "Inventory" then
		for i, entry in ipairs(property.value) do
			if entry.id == entryid then
				entry.amount = value
				break
			end
		end
	end
	menu.saveMultiSelect(property)
end

function menu.slidercellNumberProperty(property, row, value)
	property.value = value
	property.set(menu.customgamestart, property.id, value)
end

function menu.playerMoney(start)
	local scale = {
		min            = 0,
		max            = 10000000,
		start          = start,
		step           = 1000,
		suffix         = ReadText(1001, 101),
		exceedMaxValue = true,
		hideMaxValue   = true,
	}

	return scale
end

function menu.playerMacro(current, customoptions)
	local options = {}
	local currentOption = current

	local macros = {}
	menu.playerMacros = {}
	for macro in string.gmatch(customoptions, "[%w_]+") do
		local race, racename, female, basemacro = GetMacroData(macro, "entityrace", "entityracename", "entityfemale", "basemacro")
		table.insert(macros, { macro = macro, basemacro = basemacro, race = race, racename = racename, gender = female and "female" or "male" })
		menu.playerMacros[basemacro] = macro
	end
	table.sort(macros, Helper.sortPlayerMacro)

	local lastrace, lastgender
	local doublingcount = 0
	for _, entry in ipairs(macros) do
		local name = entry.racename or ""
		if (entry.race ~= "teladi") and (entry.race ~= "paranid") then
			if entry.gender == "female" then
				name = name .. " " .. ReadText(1001, 9906)
			elseif entry.gender == "male" then
				name = name .. " " .. ReadText(1001, 9907)
			end
		end
		if (lastrace == entry.race) and (lastgender == entry.gender) then
			if doublingcount == 0 then
				options[#options].text = options[#options].text .. " " .. ReadText(20402, 1)
				doublingcount = 2
			else
				doublingcount = doublingcount + 1
			end
			name = name .. " " .. ReadText(20402, doublingcount)
		else
			lastrace = entry.race
			lastgender = entry.gender
			doublingcount = 0
		end

		table.insert(options, { id = entry.basemacro, text = name, icon = "", displayremoveoption = false })
	end

	-- kuertee start: callback
	if callbacks ["playerMacro_on_end"] then
		for _, callback in ipairs (callbacks ["playerMacro_on_end"]) do
			callback (current, customoptions, options, currentOption)
		end
	end
	-- kuertee end: callback

	return options, currentOption
end

function menu.playerBuildMethod(current, customoptions)
	local options = {
		{ id = "auto", text = ReadText(1001, 9917), icon = "", displayremoveoption = false }
	}
	local currentOption = (current ~= "") and current or "auto"

	local n = C.GetNumPlayerBuildMethods()
	if n > 0 then
		local buf = ffi.new("ProductionMethodInfo[?]", n)
		n = C.GetPlayerBuildMethods(buf, n)
		for i = 0, n - 1 do
			table.insert(options, { id = ffi.string(buf[i].id), text = ffi.string(buf[i].name), icon = "", displayremoveoption = false })
		end
	end

	return options, currentOption
end

function menu.playerPaintThemes(current, customoptions)
	local options = {}
	local currentOption = current

	local n = C.GetNumCustomGameStartPaintThemes(menu.customgamestart)
	if n > 0 then
		local buf = ffi.new("UIPaintTheme[?]", n)
		n = C.GetCustomGameStartPaintThemes(buf, n, menu.customgamestart)
		for i = 0, n - 1 do
			table.insert(options, { id = ffi.string(buf[i].ID), text = ffi.string(buf[i].Name), icon = "", displayremoveoption = false })
		end
	end
	table.sort(options, function (a, b) return a.text < b.text end)

	return options, currentOption
end

function menu.playerresearchActive()
	for _, entry in pairs(menu.stories) do
		if (entry.currentstory == "story_hq_boso") or (entry.currentstory == "story_hq_dal") then
			return true
		end
	end
	return false
end

function menu.playerresearchMouseOver()
	local found = false
	local missingdependencies = ""
	for _, entry in pairs(menu.stories) do
		if (entry.currentstory == "story_hq_boso") or (entry.currentstory == "story_hq_dal") then
			return ""
		end
	end
	missingdependencies = "\n- " .. (menu.storiesbyid["story_hq_boso"] and menu.storiesbyid["story_hq_boso"].name or "story_hq_boso") .. "\n- " .. (menu.storiesbyid["story_hq_dal"] and menu.storiesbyid["story_hq_dal"].name or "story_hq_dal")
	return ReadText(1001, 9938) .. ReadText(1001, 120) .. ColorText["text_error"] .. missingdependencies .. "\27X"
end

function menu.universeSector(current)
	local options = {}
	local currentOption = current

	local buf = ffi.new("CustomGameStartStringPropertyState[1]")
	local galaxymacro = ffi.string(C.GetCustomGameStartStringProperty(menu.customgamestart, "galaxy", buf))
	local sectormacros = GetMacroData(galaxymacro, "sectors") or {}
	table.sort(sectormacros, Helper.sortMacroName)
	for _, sector in ipairs(sectormacros) do
		local unlocked = true
		local hidden = false
		local knownitem = ffi.new("CustomGameStartKnownEntry2")
		knownitem.type = Helper.ffiNewString("sector")
		knownitem.item = Helper.ffiNewString(sector)
		if C.GetCustomGameStartKnownPropertyBudgetValue2(menu.customgamestart, "playerknownspace", knownitem) then
			unlocked = knownitem.unlocked
			hidden = knownitem.hidden
		end
		if not hidden then
			local mouseovertext = ""
			local active = true
			
			if not unlocked then
				active = false
				mouseovertext = ReadText(1026, 9928)
			else
				local dependencies = menu.getStoryDependencies("playerknownspace", knownitem)
				for _, dependencylist in ipairs(dependencies) do
					local found = false
					local missingdependencies = ""
					for _, dependency in ipairs(dependencylist) do
						for _, entry in pairs(menu.stories) do
							if entry.currentstory == dependency then
								found = true
								break
							end
						end
						missingdependencies = missingdependencies .. "\n- " .. (menu.storiesbyid[dependency] and menu.storiesbyid[dependency].name or dependency)
					end
					if not found then
						mouseovertext = ((mouseovertext ~= "") and (mouseovertext .. "\n\n") or "") .. ReadText(1001, 9951) .. ReadText(1001, 120) .. ColorText["text_error"] .. missingdependencies .. "\27X"
						active = false
					end
				end
			end

			table.insert(options, { id = sector, text = GetMacroData(sector, "name"), icon = "", displayremoveoption = false, active = active, mouseovertext = mouseovertext })
		end
	end

	-- kuertee start: callback
	if callbacks ["universeSector_on_end"] then
		for _, callback in ipairs (callbacks ["universeSector_on_end"]) do
			callback (current, options, currentOption)
		end
	end
	-- kuertee end: callback

	return options, currentOption
end

function menu.getStoryDependencies(property, knownitem)
	local dependencies = {}
	local numdependencylists = C.GetCustomGameStartKnownPropertyNumStateDependencyLists(menu.customgamestart, property, knownitem)
	local dependencylist_lenghts = {}
	local numdependencies = 0
	local dependencylists_buf = ffi.new("uint32_t[?]", numdependencylists)
	numdependencylists = C.GetCustomGameStartKnownPropertyNumStateDependencies(dependencylists_buf, numdependencylists, menu.customgamestart, property, knownitem);
	for j = 0, numdependencylists - 1 do
		local count = dependencylists_buf[j]
		numdependencies = numdependencies + count
		table.insert(dependencylist_lenghts, count)
	end
	local dependencies_buf = ffi.new("const char*[?]", numdependencies)
	numdependencies = C.GetCustomGameStartKnownPropertyStateDependencies(dependencies_buf, numdependencies, menu.customgamestart, property, knownitem)
	local idx = 1
	for j = 0, numdependencies - 1 do
		while dependencylist_lenghts[1] and (dependencylist_lenghts[1] <= 0) do
			idx = idx + 1
			table.remove(dependencylist_lenghts, 1)
		end
		if #dependencylist_lenghts == 0 then
			DebugError("Dependency list counts and number of dependencies do not match - aborting.")
			break
		end

		if dependencies[idx] then
			table.insert(dependencies[idx], ffi.string(dependencies_buf[j]))
		else
			dependencies[idx] = { ffi.string(dependencies_buf[j]) }
		end
		dependencylist_lenghts[1] = dependencylist_lenghts[1] - 1
	end

	return dependencies
end

function menu.shipValue(current)
	menu.updateBudgets()

	local budget1 = ""
	if menu.propertybudgets["money" .. "ship"] then
		budget1 = " (" .. ConvertIntegerString(menu.propertybudgets["money" .. "ship"], true, 3, true) .. menu.getBudgetSuffix("money") .. ")"
	end

	local budget2 = ""
	if menu.propertybudgets["people" .. "ship"] then
		budget2 = " (" .. ConvertIntegerString(menu.propertybudgets["people" .. "ship"], true, 3, true) .. menu.getBudgetSuffix("people") .. ")"
	end

	if IsMacroClass(current, "spacesuit") then
		menu.usespacesuit = true
	end
	return GetMacroData(current, "name") .. budget1 .. budget2
end

function menu.openShipConfig()
	-- kuertee start: callback
	if callbacks ["openShipConfig_on_start"] then
		for _, callback in ipairs (callbacks ["openShipConfig_on_start"]) do
			callback ()
		end
	end
	-- kuertee end: callback

	menu.usespacesuit = nil
	Helper.closeMenuAndOpenNewMenu(menu, "ShipConfigurationMenu", { 0, 0, nil, "customgamestart", { menu.customgamestart, menu.creative, "ship", "shiploadout", "shippeople", "shippeoplefillpercent", nil, "playerpainttheme" } })
	menu.cleanup()

	-- kuertee start: callback
	if callbacks ["openShipConfig_on_end"] then
		for _, callback in ipairs (callbacks ["openShipConfig_on_end"]) do
			callback ()
		end
	end
	-- kuertee end: callback
end

function menu.openPlayerPropertyShipConfig(row, entryid, macro, commanderid, peopledef, peoplefillpercentage, count)
	menu.addingFleet = true
	menu.selectedRows.propertyTable = row
	menu.selectedCols.propertyTable = 2
	Helper.closeMenuAndOpenNewMenu(menu, "ShipConfigurationMenu", { 0, 0, nil, "customgamestart", { menu.customgamestart, menu.creative, "playerproperty", nil, nil, nil, nil, "playerpainttheme", entryid, macro, commanderid, peopledef, peoplefillpercentage, count } })
	menu.cleanup()

	-- kuertee start: callback
	if callbacks ["openPlayerPropertyShipConfig_on_end"] then
		for _, callback in ipairs (callbacks ["openPlayerPropertyShipConfig_on_end"]) do
			callback (row, entryid, macro, commanderid, peopledef, peoplefillpercentage, count)
		end
	end
	-- kuertee end: callback
end

function menu.setPlayerMacro(customgamestart, propertyid, option)
	C.SetCustomGameStartStringProperty(customgamestart, propertyid, option)
	local isfemale = GetMacroData(option, "entityfemale")
	C.SetCustomGameStartBoolProperty(customgamestart, "playerfemale", isfemale)
	if menu.usespacesuit then
		local spacesuitmacro = GetMacroData(option, "spacesuitmacro")
		C.SetCustomGameStartShipAndEmptyLoadout(menu.customgamestart, "ship", "shiploadout", spacesuitmacro)
	end
	if menu.cutsceneid then
		StopCutscene(menu.cutsceneid)
		menu.cutsceneid = nil
		DestroyPresentationCluster(menu.precluster)
		SetRenderTargetNoise(menu.rendertarget.id, true)
		menu.rendertargetLock = getElapsedTime() + 0.1
	end

	-- kuertee start: callback
	if callbacks ["setPlayerMacro_on_end"] then
		for _, callback in ipairs (callbacks ["setPlayerMacro_on_end"]) do
			callback (customgamestart, propertyid, option)
		end
	end
	-- kuertee end: callback
end

function menu.setPlayerPaintTheme(customgamestart, propertyid, option)
	C.SetCustomGameStartStringProperty(customgamestart, propertyid, option)
	if menu.preobject then
		local paintmod = ffi.new("UIPaintMod")
		if C.GetPaintThemeMod(option, "player", paintmod) then
			C.InstallPaintMod(ConvertIDTo64Bit(menu.preobject), ffi.string(paintmod.Ware), false)
		end
	end
end

function menu.setPlayerSector(gamestartid, propertyid, sector, noreset)
	if (not noreset) and (menu.holomap ~= 0) then
		C.RemoveHoloMap()
		menu.holomap = 0
	end
	C.SetCustomGameStartStringProperty(gamestartid, propertyid, sector)

	-- kuertee start: callback
	if callbacks ["setPlayerSector_on_end"] then
		for _, callback in ipairs (callbacks ["setPlayerSector_on_end"]) do
			callback (gamestartid, propertyid, sector, noreset)
		end
	end
	-- kuertee end: callback
end

function menu.displayMultiSelection(property)
	menu.contextMenu = "multiselect"
	menu.contextMenuData = { options = {}, selectedOptions = {}, origSelectedOptions = {}, propertyLockedWares = {} }

	if property.propertyType == "Inventory" then
		local craftingwares, upgradewares, tradeonlywares, paintmodwares, usefulwares = {}, {}, {}, {}, {}

		local tags = "inventory"
		local excludetags = "paintmod clothingmod missiononly braneitem deprecated seminar equipmentmodpart nocustomgamestart"
		local n = C.GetNumWares(tags, false, "", excludetags)
		local buf = ffi.new("const char*[?]", n)
		n = C.GetWares(buf, n, tags, false, "", excludetags)
		menu.contextMenuData.optionCount = n
		for i = 0, n - 1 do
			local ware = ffi.string(buf[i])
			local name, iscraftingresource, ismodpart, isprimarymodpart, ispersonalupgrade, tradeonly, ispaintmod = GetWareData(ware, "name", "iscraftingresource", "ismodpart", "isprimarymodpart", "ispersonalupgrade", "tradeonly", "ispaintmod")
			if iscraftingresource or ismodpart or isprimarymodpart then
				table.insert(craftingwares, { id = ware, name = name })
			elseif ispersonalupgrade then
				table.insert(upgradewares, { id = ware, name = name })
			elseif tradeonly then
				table.insert(tradeonlywares, { id = ware, name = name })
			elseif ispaintmod then
				table.insert(paintmodwares, { id = ware, name = name })
			else
				table.insert(usefulwares, { id = ware, name = name })
			end

			for _, entry in ipairs(property.value) do
				if entry.id == ware then
					menu.contextMenuData.selectedOptions[ware] = true
					menu.contextMenuData.origSelectedOptions[ware] = true
					break
				end
			end
		end

		if #craftingwares > 0 then
			table.insert(menu.contextMenuData.options, { name = ReadText(1001, 2827), wares = craftingwares })	-- Crafting Wares
		end
		if #upgradewares > 0 then
			table.insert(menu.contextMenuData.options, { name = ReadText(1001, 7716), wares = upgradewares })	-- Spacesuit Upgrades
		end
		if #paintmodwares > 0 then
			table.insert(menu.contextMenuData.options, { name = ReadText(1001, 8510), wares = paintmodwares})	-- Trade Wares
		end
		if #usefulwares > 0 then
			table.insert(menu.contextMenuData.options, { name = ReadText(1001, 2828), wares = usefulwares })	-- General Wares
		end
		if #tradeonlywares > 0 then
			table.insert(menu.contextMenuData.options, { name = ReadText(1001, 2829), wares = tradeonlywares})	-- Trade Wares
		end
	elseif property.propertyType == "Blueprint" then
		local waresbyclass = {}

		local tags = "module ship weapon turret shield engine thruster missile drone consumables countermeasure lasertower satellite mine navbeacon resourceprobe"
		local excludetags = "noplayerblueprint noblueprint noplayerbuild deprecated missiononly"
		if not menu.creative then
			excludetags = excludetags .. " nocustomgamestart"
		end
		local n = C.GetNumWares(tags, false, "", excludetags)
		local buf = ffi.new("const char*[?]", n)
		n = C.GetWares(buf, n, tags, false, "", excludetags)
		menu.contextMenuData.optionCount = 0
		for i = 0, n - 1 do
			local ware = ffi.string(buf[i])
			local name, macro, blueprintsowners = GetWareData(ware, "name", "component", "blueprintsowners")
			local isventure = false
			for i, owner in ipairs(blueprintsowners) do
				if owner == "visitor" then
					isventure = true
					break
				end
			end
			if not isventure then
				local isunit, isvirtual, islasertower, hasinfoalias = GetMacroData(macro, "isunit", "isvirtual", "islasertower", "hasinfoalias")
				if not hasinfoalias then
					local class = isunit and "drone" or ffi.string(C.GetMacroClass(macro))
					if (class == "engine") and isvirtual then
						class = "thruster"
					elseif islasertower then
						class = "lasertower"
					end

					if waresbyclass[class] then
						table.insert(waresbyclass[class], { id = ware, name = name })
					else
						waresbyclass[class] = { { id = ware, name = name } }
					end

					for _, entry in ipairs(property.value) do
						if entry.id == ware then
							menu.contextMenuData.selectedOptions[ware] = true
							menu.contextMenuData.origSelectedOptions[ware] = true
							break
						end
					end
				end
			end
		end

		local state = C.GetCustomGameStartPlayerPropertyPropertyState(menu.customgamestart, "playerproperty")
		if state.numvalues > 0 then
			local counts = ffi.new("CustomGameStartPlayerPropertyCounts[?]", state.numvalues)
			local n = C.GetCustomGameStartPlayerPropertyCounts(counts, state.numvalues, menu.customgamestart, "playerproperty")
			if n > 0 then
				local buf = ffi.new("CustomGameStartPlayerProperty3[?]", n)
				for i = 0, n - 1 do
					buf[i].numcargo = counts[i].numcargo
					buf[i].cargo = Helper.ffiNewHelper("UIWareInfo[?]", counts[i].numcargo)
				end
				n = C.GetCustomGameStartPlayerPropertyProperty3(buf, n, menu.customgamestart, "playerproperty")
				for i = 0, n - 1 do
					for ware in pairs(menu.getCPWares(ffi.string(buf[i].constructionplanid))) do
						menu.contextMenuData.propertyLockedWares[ware] = true
					end
				end
			end
		end

		for _, entry in ipairs(config.blueprintcategories) do
			local data = {}
			for class in pairs(entry.classes) do
				if waresbyclass[class] then
					if #data == 0 then
						data = waresbyclass[class]
						menu.contextMenuData.optionCount = menu.contextMenuData.optionCount + #waresbyclass[class]
					else
						for _, wareentry in ipairs(waresbyclass[class]) do
							table.insert(data, wareentry)
							menu.contextMenuData.optionCount = menu.contextMenuData.optionCount + 1
						end
					end
				end
			end
			if #data > 0 then
				table.insert(menu.contextMenuData.options, { name = entry.name, wares = data})
			end
		end
	elseif property.propertyType == "KnownEntry2" then
		local sectors = {}
		local buf = ffi.new("CustomGameStartStringPropertyState[1]")
		local galaxymacro = ffi.string(C.GetCustomGameStartStringProperty(menu.customgamestart, "galaxy", buf))
		local sectormacros = GetMacroData(galaxymacro, "sectors") or {}
		menu.contextMenuData.optionCount = #sectormacros
		for _, sector in ipairs(sectormacros) do
			table.insert(sectors, { id = sector, name = GetMacroData(sector, "name") })

			for _, entry in ipairs(property.value) do
				if entry.id == sector then
					menu.contextMenuData.selectedOptions[sector] = true
					menu.contextMenuData.origSelectedOptions[sector] = true
					break
				end
			end
		end

		local buf = ffi.new("CustomGameStartStringPropertyState[1]")
		local playersectormacro = ffi.string(C.GetCustomGameStartStringProperty(menu.customgamestart, "sector", buf))
		menu.contextMenuData.propertyLockedWares[playersectormacro] = true
		local state = C.GetCustomGameStartPlayerPropertyPropertyState(menu.customgamestart, "playerproperty")
		if state.numvalues > 0 then
			local counts = ffi.new("CustomGameStartPlayerPropertyCounts[?]", state.numvalues)
			local n = C.GetCustomGameStartPlayerPropertyCounts(counts, state.numvalues, menu.customgamestart, "playerproperty")
			if n > 0 then
				local buf = ffi.new("CustomGameStartPlayerProperty3[?]", n)
				for i = 0, n - 1 do
					buf[i].numcargo = counts[i].numcargo
					buf[i].cargo = Helper.ffiNewHelper("UIWareInfo[?]", counts[i].numcargo)
				end
				n = C.GetCustomGameStartPlayerPropertyProperty3(buf, n, menu.customgamestart, "playerproperty")
				for i = 0, n - 1 do
					local sector = ffi.string(C.GetCustomGameStartPlayerPropertySector(menu.customgamestart, "playerproperty", ffi.string(buf[i].id)))
					if sector ~= "" then
						menu.contextMenuData.propertyLockedWares[sector] = true
					end
				end
			end
		end

		table.insert(menu.contextMenuData.options, { name = "", wares = sectors})
	end
	for _, data in ipairs(menu.contextMenuData.options) do
		table.sort(data.wares, Helper.sortName)
	end

	Helper.removeAllWidgetScripts(menu, config.contextFrameLayer)
	menu.contextFrame = Helper.createFrameHandle(menu, {
		x = menu.propertyTable.properties.x + menu.propertyTable.properties.width + 2 * Helper.borderSize,
		y = menu.propertyTable.properties.y,
		width = menu.width / 4,
		layer = config.contextFrameLayer,
		standardButtons = { close = true },
	})

	menu.contextTable = menu.contextFrame:addTable(3, { tabOrder = 3 })
	menu.contextTable:setColWidth(1, config.standardTextHeight)
	menu.contextTable:setColWidthPercent(3, 33)

	local row = menu.contextTable:addRow(true, { fixed = true })
	row[1]:createCheckBox(function () local count = 0; for _ in pairs(menu.contextMenuData.selectedOptions) do count = count + 1 end; return menu.contextMenuData.optionCount == count end, { height = Helper.standardTextHeight })
	row[1].handlers.onClick = function (_, checked) return menu.checkboxToggleMultiSelect(checked) end
	row[2]:setColSpan(2):createText(property.selectionText, Helper.headerRowCenteredProperties)

	for i, data in ipairs(menu.contextMenuData.options) do
		if i ~= 1 then
			menu.contextTable:addEmptyRow(config.standardTextHeight / 2)
		end
		if data.name ~= "" then
			local row = menu.contextTable:addRow(nil, {  })
			row[1]:setColSpan(3):createText(data.name, { titleColor = Color["row_title"] })
		end
		for _, entry in ipairs(data.wares) do
			local unlocked = true
			local hidden = false
			local budgetvalue = 0
			local knownitem = ffi.new("CustomGameStartKnownEntry2")
			if property.propertyType == "KnownEntry2" then
				if property.id == "playerknownspace" then
					knownitem.type = Helper.ffiNewString("sector")
					knownitem.item = Helper.ffiNewString(entry.id)
				end
				if C.GetCustomGameStartKnownPropertyBudgetValue2(menu.customgamestart, property.id, knownitem) then
					budgetvalue = tonumber(knownitem.budgetvalue)
					unlocked = knownitem.unlocked
					hidden = knownitem.hidden
					if hidden then
						menu.contextMenuData.propertyLockedWares[entry.id] = true
						menu.contextMenuData.optionCount = menu.contextMenuData.optionCount - 1
					end
				end
			end

			if not hidden then
				local row = menu.contextTable:addRow(entry.id, {  })
				local active = true
				local mouseovertext = ""
				if not unlocked then
					active = false
					mouseovertext = ReadText(1026, 9928)
				elseif property.propertyType == "KnownEntry2" then
					local dependencies = menu.getStoryDependencies("playerknownspace", knownitem)
					for _, dependencylist in ipairs(dependencies) do
						local found = false
						local missingdependencies = ""
						for _, dependency in ipairs(dependencylist) do
							for _, entry in pairs(menu.stories) do
								if entry.currentstory == dependency then
									found = true
									break
								end
							end
							missingdependencies = missingdependencies .. "\n- " .. (menu.storiesbyid[dependency] and menu.storiesbyid[dependency].name or dependency)
						end
						if not found then
							mouseovertext = ((mouseovertext ~= "") and (mouseovertext .. "\n\n") or "") .. ReadText(1001, 9951) .. ReadText(1001, 120) .. ColorText["text_error"] .. missingdependencies .. "\27X"
							active = false
							menu.contextMenuData.propertyLockedWares[entry.id] = true
							menu.contextMenuData.optionCount = menu.contextMenuData.optionCount - 1
						end
					end
				end
				
				if active then
					if menu.contextMenuData.propertyLockedWares[entry.id] then
						active = false
						if property.propertyType == "Blueprint" then
							mouseovertext = ReadText(1026, 9906)
						elseif property.propertyType == "KnownEntry2" then
							if property.id == "playerknownspace" then
								mouseovertext = ReadText(1026, 9915)
							end
						end
					end
				end
				row[1]:createCheckBox(function () return menu.contextMenuData.selectedOptions[entry.id] or false end, { height = Helper.standardTextHeight, active = active, mouseOverText = mouseovertext })
				row[1].handlers.onClick = function (_, checked) return menu.checkboxMultiSelect(entry.id, checked) end
				row[2]:createText(entry.name)
				if not menu.creative then
					if (property.propertyType == "Inventory") or (property.propertyType == "Blueprint") then
						row[3]:createText(ConvertIntegerString(GetWareData(entry.id, "avgprice"), true, 0, true) .. " " .. ReadText(1001, 101), { halign = "right" })
					elseif property.propertyType == "KnownEntry2" then
						local budgetsuffix = menu.getBudgetSuffix("known")
						row[3]:createText(ConvertIntegerString(budgetvalue, true, 3, true) .. budgetsuffix, { halign = "right" })
					end
				end
			end
		end
	end

	menu.contextTable2 = menu.contextFrame:addTable(2, { tabOrder = 4, y = Helper.borderSize })
	local row = menu.contextTable2:addRow(true, { fixed = true })
	row[1]:createButton({ active = menu.isOptionSelectionChanged }):setText(ReadText(1001, 14), { halign = "center" })
	row[1].handlers.onClick = function () return menu.buttonMultiSelectConfirm(property) end
	row[2]:createButton({  }):setText(ReadText(1001, 64), { halign = "center" })
	row[2].handlers.onClick = function () return menu.onCloseElement("back", config.contextFrameLayer) end

	local maxVisibleHeight = menu.propertyTable.properties.maxVisibleHeight - menu.contextTable2:getFullHeight() - Helper.frameBorder
	menu.contextTable2.properties.y = menu.contextTable2.properties.y + math.min(maxVisibleHeight, menu.contextTable:getFullHeight())
	menu.contextTable.properties.maxVisibleHeight = menu.contextTable2.properties.y - menu.contextTable.properties.y

	menu.contextTable.properties.nextTable = menu.contextTable2.index
	menu.contextTable2.properties.prevTable = menu.contextTable.index

	menu.contextFrame.properties.height = math.min(Helper.viewHeight - menu.contextFrame.properties.y, menu.contextFrame:getUsedHeight())
	menu.contextFrame:display()
	menu.refresh = getElapsedTime()
end

function menu.displayMapContext(offset, sectormacro, sectorpos)
	menu.contextMenu = "mapcontext"

	local offsetx = offset[1] + Helper.viewWidth / 2
	local offsety = Helper.viewHeight / 2 - offset[2]

	Helper.removeAllWidgetScripts(menu, config.contextFrameLayer)
	menu.contextFrame = Helper.createFrameHandle(menu, {
		x = offsetx,
		y = offsety,
		width = Helper.scaleX(config.mapContextWidth),
		layer = config.contextFrameLayer,
		standardButtons = { close = true },
	})

	menu.contextTable = menu.contextFrame:addTable(1, { tabOrder = 3, backgroundID = "solid", backgroundColor = Color["frame_background_semitransparent"] })

	local row = menu.contextTable:addRow(nil, { fixed = true })
	row[1]:createText(GetMacroData(sectormacro, "name"), Helper.headerRowCenteredProperties)

	if menu.category.id == "universe" then
		local knownspaceproperty = menu.findProperty("playerknownspace")
		if knownspaceproperty then
			menu.initPropertyValue(knownspaceproperty)

			local found
			for j, entry in ipairs(knownspaceproperty.value) do
				if entry.id == sectormacro then
					found = j
					break
				end
			end

			-- known sector
			local locked = false
			local buf = ffi.new("CustomGameStartStringPropertyState[1]")
			local playersectormacro = ffi.string(C.GetCustomGameStartStringProperty(menu.customgamestart, "sector", buf))
			if playersectormacro == sectormacro then
				locked = true
			end
			if not locked then
				local state = C.GetCustomGameStartPlayerPropertyPropertyState(menu.customgamestart, "playerproperty")
				if state.numvalues > 0 then
					local counts = ffi.new("CustomGameStartPlayerPropertyCounts[?]", state.numvalues)
					local n = C.GetCustomGameStartPlayerPropertyCounts(counts, state.numvalues, menu.customgamestart, "playerproperty")
					if n > 0 then
						local buf = ffi.new("CustomGameStartPlayerProperty3[?]", n)
						for i = 0, n - 1 do
							buf[i].numcargo = counts[i].numcargo
							buf[i].cargo = Helper.ffiNewHelper("UIWareInfo[?]", counts[i].numcargo)
						end
						n = C.GetCustomGameStartPlayerPropertyProperty3(buf, n, menu.customgamestart, "playerproperty")
						for i = 0, n - 1 do
							local sector = ffi.string(C.GetCustomGameStartPlayerPropertySector(menu.customgamestart, "playerproperty", ffi.string(buf[i].id)))
							if sector == sectormacro then
								locked = true
								break
							end
						end
					end
				end
			end

			local row = menu.contextTable:addRow({  })
			row[1]:createButton({ height = Helper.standardTextHeight, active = not locked, mouseOverText = locked and ReadText(1026, 9915) or "" }):setText(found and ReadText(1001, 9940) or ReadText(1001, 9939))
			row[1].handlers.onClick = function () return menu.buttonMapContextSelectSector(sectormacro, found) end

			if found then
				-- known stations
				local checked = menu.getKnownValue("playerknownobjects", sectormacro)
				local row = menu.contextTable:addRow({  })
				row[1]:createButton({ height = Helper.standardTextHeight }):setText(checked and ReadText(1001, 9941) or ReadText(1001, 9944))
				row[1].handlers.onClick = function () return menu.buttonMapContextKnownStations(sectormacro, not checked) end

				-- satelitte coverage
				local row = menu.contextTable:addRow({  })
				row[1]:createButton({ height = Helper.standardTextHeight }):setText(menu.satellites[sectormacro] and ReadText(1001, 9943) or ReadText(1001, 9942))
				row[1].handlers.onClick = function () return menu.buttonMapContextSatelliteCoverage(sectormacro, not menu.satellites[sectormacro]) end
			end
		end
	end

	menu.contextFrame.properties.height = math.min(Helper.viewHeight - menu.contextFrame.properties.y, menu.contextFrame:getUsedHeight())
	menu.contextFrame:display()
end

function menu.displayExportContext()
	menu.contextMenu = "export"
	local width = menu.categoryTable.properties.width * 3 / 2

	Helper.removeAllWidgetScripts(menu, config.contextFrameLayer)
	menu.contextFrame = Helper.createFrameHandle(menu, {
		x = menu.exportButtonPos.x,
		y = menu.exportButtonPos.y,
		width = width + 2 * Helper.borderSize,
		layer = config.contextFrameLayer,
		standardButtons = { close = true },
	})
	menu.contextFrame:setBackground("solid", { color = Color["frame_background_black"] })

	menu.contextTable = menu.contextFrame:addTable(3, { tabOrder = 6, reserveScrollBar = false, x = Helper.borderSize, y = Helper.borderSize, width = width })
	menu.contextTable:setDefaultCellProperties("button", { height = Helper.standardTextHeight })
	menu.contextTable:setDefaultComplexCellProperties("button", "text", { fontsize = Helper.standardFontSize, halign = "center" })

	local row = menu.contextTable:addRow(nil, { fixed = true })
	row[1]:setColSpan(3):createText(ReadText(1001, 9946), Helper.headerRowCenteredProperties)

	local row = menu.contextTable:addRow(true, { fixed = true })
	row[1]:setColSpan(3):createEditBox({ height = Helper.headerRow1Height, defaultText = ReadText(1001, 9947) }):setText(menu.gamestartName or "", { fontsize = Helper.headerRow1FontSize, x = Helper.standardTextOffsetx })
	row[1].handlers.onTextChanged = menu.editboxNameUpdateText

	local row = menu.contextTable:addRow(nil, { fixed = true })
	row[1]:setColSpan(3):createText(ReadText(1001, 9948), { wordwrap = true })

	--[[
	local row = menu.contextTable:addRow(true, { fixed = true })
	row[1]:setColSpan(3):createButton({ active = C.CanOpenWebBrowser(), mouseOverText = ReadText(1026, 7918) }):setText(ReadText(1001, 7974)):setText2("\27[mm_externallink]", { halign = "right" })
	row[1].handlers.onClick = menu.buttonConstructionCommunity--]]

	local row = menu.contextTable:addRow(true, { fixed = true })
	row[1]:createButton({ active = function () return menu.checkExportActive(true) end }):setText(ReadText(1001, 9949), {  })
	row[1].handlers.onClick = function () return menu.buttonExport(true) end
	row[2]:createButton({ active = function () return menu.checkExportActive(false) end }):setText(ReadText(1001, 7909), {  })
	row[2].handlers.onClick = function () return menu.buttonExport(true) end
	row[3]:createButton({  }):setText(ReadText(1001, 64))
	row[3].handlers.onClick = menu.closeContextMenu

	menu.contextFrame.properties.height = math.min(Helper.viewHeight - menu.contextFrame.properties.y, menu.contextFrame:getUsedHeight() + Helper.borderSize)
	menu.contextFrame:display()
end

function menu.checkExportActive(overwrite)
	if menu.gamestartName and (menu.gamestartName ~= "") then
		for _, entry in ipairs(menu.availablecustomgamestarts) do
			if entry.text == menu.gamestartName then
				return overwrite
			end
		end
		return not overwrite
	end
	return false
end

function menu.displayHint(text)
	menu.contextMenu = "propertyadded"

	local width = Helper.scaleX(230)
	local textheight = math.ceil(C.GetTextHeight(text, config.font, Helper.scaleFont(config.font, config.standardFontSize), width - 2 * Helper.scaleX(config.standardTextOffsetX)))
	local height = textheight + Helper.standardButtons_Size
	local borderwidth = 2

	Helper.removeAllWidgetScripts(menu, config.contextFrameLayer)
	menu.contextFrame = Helper.createFrameHandle(menu, {
		x = (Helper.viewWidth - width - 2 * borderwidth) / 2,
		y = (Helper.viewHeight - height - 2 * borderwidth) / 2,
		width = width + 2 * borderwidth,
		height = height + 2 * borderwidth,
		layer = config.contextFrameLayer,
		standardButtons = { close = true },
	})
	menu.contextFrame:setBackground("tut_gradient_hint_01", {
		color = Color["hint_background_orange"],
		rotationRate = 360,
		rotationStart = 135,
		rotationDuration = 1,
		rotationInterval = 10,
		initialScaleFactor = 3,
		scaleDuration = 0.5,
	})
	menu.contextFrame:setBackground2("solid", {
		color = Color["hint_background2_black"],
		width = width,
		height = height,
		initialScaleFactor = 3,
		scaleDuration = 0.5,
	})

	menu.contextTable = menu.contextFrame:addTable(1, { tabOrder = 3, x = borderwidth, y = borderwidth, width = width, reserveScrollBar = false })
	local row = menu.contextTable:addRow(nil, { fixed = true })
	row[1]:createText(text, { scaling = false, fontsize = Helper.scaleFont(config.font, config.standardFontSize), x = Helper.scaleX(config.standardTextOffsetX), y = Helper.standardButtons_Size, wordwrap = true })

	menu.contextFrame:display()
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

function menu.onShowMenu(state)
	if not menu.isStartmenu then
		if menu.param[6] ~= 0 then
			menu.paused = true
			Pause()
		end
	end

	menu.customgamestart = menu.param[3]
	menu.multiplayer = menu.param[4] ~= 0
	menu.creative = menu.param[5] ~= 0

	menu.width = Helper.viewWidth - 2 * config.table.x
	menu.topRows = {}
	menu.firstCols = {}
	menu.selectedRows = {}
	menu.selectedCols = {}

	if state then
		menu.onRestoreState(state)

		if menu.addingFleet then
			if not menu.shownPropertyHint then
				local state = C.GetCustomGameStartPlayerPropertyPropertyState(menu.customgamestart, "playerproperty")
				if state.numvalues > 0 then
					menu.shownPropertyHint = getElapsedTime()
					menu.displayHint(ReadText(1001, 9935))
					menu.showHighlightOverlay = "property_expand"
				end
			end
			menu.addingFleet = nil
		end
	else
		-- reset if the editor is opened
		C.ResetCustomGameStart(menu.customgamestart)
	end

	menu.initEncyclopediaValue()
	menu.initKnownValue()
	menu.initStoryValue()
	menu.initSatellites()
	menu.initFactions()

	menu.usedlimitedships = {}
	local buf = ffi.new("CustomGameStartStringPropertyState[1]")
	local playershipmacro = ffi.string(C.GetCustomGameStartStringProperty(menu.customgamestart, "ship", buf))
	local ware = GetMacroData(playershipmacro, "ware")
	local islimited = GetWareData(ware, "islimited")
	if islimited then
		menu.usedlimitedships[playershipmacro] = (menu.usedlimitedships[playershipmacro] or 0) + 1
	end

	local state = C.GetCustomGameStartPlayerPropertyPropertyState(menu.customgamestart, "playerproperty")
	if state.numvalues > 0 then
		local counts = ffi.new("CustomGameStartPlayerPropertyCounts[?]", state.numvalues)
		local n = C.GetCustomGameStartPlayerPropertyCounts(counts, state.numvalues, menu.customgamestart, "playerproperty")
		if n > 0 then
			local buf = ffi.new("CustomGameStartPlayerProperty3[?]", n)
			for i = 0, n - 1 do
				buf[i].numcargo = counts[i].numcargo
				buf[i].cargo = Helper.ffiNewHelper("UIWareInfo[?]", counts[i].numcargo)
			end
			n = C.GetCustomGameStartPlayerPropertyProperty3(buf, n, menu.customgamestart, "playerproperty")
			for i = 0, n - 1 do
				local sector = ffi.string(C.GetCustomGameStartPlayerPropertySector(menu.customgamestart, "playerproperty", ffi.string(buf[i].id)))
				if sector ~= "" then
					menu.setKnownValue("playerknownspace", sector, true)
				end
				local type = ffi.string(buf[i].type)
				if type == "ship" then
					local macro = ffi.string(buf[i].macroname)
					local ware = GetMacroData(macro, "ware")
					local islimited = GetWareData(ware, "islimited")
					if islimited then
						menu.usedlimitedships[macro] = (menu.usedlimitedships[macro] or 0) + buf[i].count
					end
				end
			end
		end
	end
	menu.saveKnownValue("playerknownspace")

	menu.display()
end


function menu.onSaveState()
	local state = {}

	state.topRows = {}
	state.selectedRows = {}
	state.selectedCols = {}
	state.topRows.categoryTable = GetTopRow(menu.categoryTable.id)
	state.selectedRows.categoryTable = Helper.currentTableRow[menu.categoryTable.id]
	if menu.propertyTable then
		state.topRows.propertyTable = GetTopRow(menu.propertyTable.id)
		state.selectedRows.propertyTable = menu.selectedRows.propertyTable or Helper.currentTableRow[menu.propertyTable.id]
		state.selectedCols.propertyTable = menu.selectedCols.propertyTable
	end

	state.category = menu.category.id

	for _, key in ipairs(config.stateKeys) do
		state[key[1]] = menu[key[1]]
	end
	return state
end

function menu.onRestoreState(state)
	menu.topRows.categoryTable = state.topRows.categoryTable
	menu.selectedRows.categoryTable = state.selectedRows.categoryTable
	menu.topRows.propertyTable = state.topRows.propertyTable
	menu.selectedRows.propertyTable = state.selectedRows.propertyTable
	menu.selectedCols.propertyTable = state.selectedCols.propertyTable

	for _, category in ipairs(config.categories) do
		if category.id == state.category then
			menu.setCategory(category)
		end
	end

	for _, key in ipairs(config.stateKeys) do
		if key[2] == "bool" then
			if type(state[key[1]]) == "number" then
				menu[key[1]] = state[key[1]] ~= 0
			else
				menu[key[1]] = state[key[1]]
			end
		else
			menu[key[1]] = state[key[1]]
		end
	end
end

function menu.display()
	-- kuertee start: callback
	if callbacks ["display_on_start"] then
		for _, callback in ipairs (callbacks ["display_on_start"]) do
			callback (config)
		end
	end
	-- kuertee end: callback

	-- remove old data
	Helper.clearDataForRefresh(menu, config.mainFrameLayer)

	menu.mainFrame = Helper.createFrameHandle(menu, {
		width = Helper.viewWidth,
		height = Helper.viewHeight,
		standardButtons = {},
		layer = config.mainFrameLayer,
	})
	menu.mainFrame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	local width = math.min(0.25 * Helper.viewWidth, Helper.scaleX(800))

	menu.categoryTable = menu.mainFrame:addTable(4, { tabOrder = 2, x = Helper.scaleX(config.table.x), y = Helper.scaleY(config.table.y), width = width, reserveScrollBar = false })
	menu.categoryTable:setColWidth(1, Helper.scaleY(config.table.arrowColumnWidth), false)
	menu.categoryTable:setColWidth(3, (menu.categoryTable.properties.width - Helper.scaleY(config.table.arrowColumnWidth)) / 2 - Helper.scaleX(4 *config.standardTextHeight) - Helper.borderSize, false)
	menu.categoryTable:setColWidth(4, 4 * config.standardTextHeight)
	menu.categoryTable:setDefaultCellProperties("button", { height = config.standardTextHeight })
	menu.categoryTable:setDefaultComplexCellProperties("button", "text", { x = config.standardTextOffsetX, fontsize = config.standardFontSize })
	menu.categoryTable:setDefaultCellProperties("dropdown", { height = config.standardTextHeight })
	menu.categoryTable:setDefaultComplexCellProperties("dropdown", "text", { x = config.standardTextOffsetX, fontsize = config.standardFontSize })
	menu.categoryTable:setDefaultCellProperties("slidercell", { height = config.standardTextHeight })
	menu.categoryTable:setDefaultComplexCellProperties("slidercell", "text", { x = config.standardTextOffsetX, fontsize = config.standardFontSize })

	local row = menu.categoryTable:addRow({}, { fixed = true })
	row[1]:createButton({ height = config.headerTextHeight }):setIcon(config.backarrow, { x = config.backarrowOffsetX })
	row[1].handlers.onClick = function () return menu.closeMenu("back") end
	row[2]:setColSpan(3):createText(ReadText(1001, 9901), config.headerTextProperties)

	for _, category in ipairs(config.categories) do
		local shown = false
		if category.type == "list" then
			shown = true
		elseif category.type == "flowchart" then
			if category.id == "playerresearch" then
				local state = C.GetCustomGameStartResearchPropertyState(menu.customgamestart, category.id)
				category.state = ffi.string(state.state)
			elseif category.id == "universefactionrelations" then
				-- faction relations
				local state = C.GetCustomGameStartRelationsPropertyState(menu.customgamestart, category.id)
				category.state = ffi.string(state.state)
			end
			if category.state ~= "" then
				shown = true
			end
		elseif category.type == "property" then
			if category.id == "playerproperty" then
				local state = C.GetCustomGameStartPlayerPropertyPropertyState(menu.customgamestart, category.id)
				category.state = {
					state = ffi.string(state.state),
					numvalues = state.numvalues,
				}
			end
			if category.state.state ~= "" then
				shown = true
			end
		elseif category.type == "story" then
			if category.id == "universestorystates" then
				local state = C.GetCustomGameStartStoryPropertyState(menu.customgamestart, category.id)
				category.state = {
					state = ffi.string(state.state),
					numvalues = state.numvalues,
					numdefaultvalues = state.numdefaultvalues,
				}
			end
			if category.state.state ~= "" then
				shown = true
			end
		end
		if shown then
			local row = menu.categoryTable:addRow(category, {  })
			row[2]:setColSpan(category.budget and 2 or 3):createText(category.name, config.standardTextProperties)
			row[2].properties.color = function () return menu.getCategoryColor(category) end
			if category.mouseovertext then
				row[2].properties.mouseOverText = category.mouseovertext
			end
			if category.budget then
				local text, mouseovertext = "", ""
				for _, budget in ipairs(menu.budgets) do
					if type(category.budget) == "table" then
						for _, categorybudget in ipairs(category.budget) do
							if budget.id == categorybudget then
								if (not menu.creative) and C.HasCustomGameStartBudget(menu.customgamestart, categorybudget) then
									text = text .. Helper.convertColorToText(budget.color) .. "\27[" .. budget.icon .. "]"
									if mouseovertext ~= "" then
										mouseovertext = mouseovertext .. "\n"
									end
									mouseovertext = mouseovertext .. budget.name
								end
							end
						end
					else
						if budget.id == category.budget then
							if (not menu.creative) and C.HasCustomGameStartBudget(menu.customgamestart, category.budget) then
								row[4]:createText("\27[" .. budget.icon .. "]", { halign = "right", color = budget.color, mouseOverText = budget.name })
							end
							break
						end
					end
				end
				if text ~= "" then
					row[4]:createText(text, { halign = "right", mouseOverText = mouseovertext })
				end
			end
		end
	end

	local row = menu.categoryTable:addRow(nil, {  })
	row[2]:setColSpan(2):createText("")

	menu.availablecustomgamestarts = {}
	local n = C.GetNumAvailableCustomGameStarts(menu.customgamestart)
	local buf = ffi.new("CustomGameStartInfo[?]", n)
	n = C.GetAvailableCustomGameStarts(buf, n, menu.customgamestart)
	for i = 0, n - 1 do
		if ffi.string(buf[i].id) == menu.customgamestart then
			local filename = ffi.string(buf[i].filename)
			local name = ffi.string(buf[i].name)
			local active = true
			local mouseovertext = ""

			local content = C.GetCustomGameStartContentCounts2(menu.customgamestart, filename, menu.customgamestart)
			if not content.hasincompatibleloadout then
				local buf_content = ffi.new("CustomGameStartContentData2")
				buf_content.nummacros = content.nummacros
				buf_content.macros = Helper.ffiNewHelper("UIMacroCount[?]", content.nummacros)
				buf_content.numblueprints = content.numblueprints
				buf_content.blueprints = Helper.ffiNewHelper("const char*[?]", content.numblueprints)
				buf_content.numconstructionplans = content.numconstructionplans
				buf_content.constructionplanids = Helper.ffiNewHelper("const char*[?]", content.numconstructionplans)
				C.GetCustomGameStartContent2(buf_content, menu.customgamestart, filename, menu.customgamestart)
				-- need to cache the constructionplanids due to menu.checkConstructionPlan() in the constructionplan loop calling other ffi functions, causing the last entry in the array to break for an unknown (FFI library internal) reason
				local constructionplanids = {}
				for j = 0, buf_content.numconstructionplans - 1 do
					constructionplanids[j] = ffi.string(buf_content.constructionplanids[j])
				end
				-- macros
				local usedlimitedwares = {}
				for j = 0, buf_content.nummacros - 1 do
					local ware = GetMacroData(ffi.string(buf_content.macros[j].macro), "ware")
					if ware then
						local hasblueprint, isdeprecated, isplayerblueprintallowed, nocustomgamestart, islimited = GetWareData(ware, "hasblueprint", "isdeprecated", "isplayerblueprintallowed", "nocustomgamestart", "islimited")
						if menu.creative then
							nocustomgamestart = false
							islimited = false
						end
						if (not hasblueprint) or isdeprecated or (not isplayerblueprintallowed) or nocustomgamestart then
							active = false
							mouseovertext = ReadText(1026, 9925)
							break
						end
						if islimited then
							usedlimitedwares[ware] = (usedlimitedwares[ware] or 0) + buf_content.macros[j].amount
						end
					end
				end
				if active then
					for ware, amount in pairs(usedlimitedwares) do
						local limitamount = Helper.getLimitedWareAmount(ware)
						if amount > limitamount then
							active = false
							mouseovertext = ReadText(1026, 9930)
							break
						end
					end
				end
				-- blueprints
				if active then
					for j = 0, buf_content.numblueprints - 1 do
						local ware = ffi.string(buf_content.blueprints[j])
						local hasblueprint, isdeprecated, isplayerblueprintallowed, nocustomgamestart, blueprintsowners, ismissiononly = GetWareData(ware, "hasblueprint", "isdeprecated", "isplayerblueprintallowed", "nocustomgamestart", "blueprintsowners", "ismissiononly")
						if menu.creative then
							nocustomgamestart = false
						end
						local isventure = false
						for i, owner in ipairs(blueprintsowners or {}) do
							if owner == "visitor" then
								isventure = true
								break
							end
						end
						if (not hasblueprint) or isdeprecated or (not isplayerblueprintallowed) or nocustomgamestart or isventure or ismissiononly then
							active = false
							mouseovertext = ReadText(1026, 9926)
							break
						end
					end
				end
				-- cps
				if active then
					local onlineitems = OnlineGetUserItems()
					local limitedmodulesused = {}
					for j = 0, buf_content.numconstructionplans - 1 do
						local source, constructionplanid, isHQ = string.match(constructionplanids[j], "(.*):(.*):(%d)")
						if not menu.checkConstructionPlan(source, constructionplanid, limitedmodulesused, onlineitems, tonumber(isHQ) == 1) then
							active = false
							mouseovertext = ReadText(1026, 9927)
							break
						end
					end
				end
			else
				active = false
				mouseovertext = ReadText(1026, 9924)
			end

			table.insert(menu.availablecustomgamestarts, { id = filename, text = name, icon = "", displayremoveoption = false, active = active, mouseovertext = mouseovertext })
		end
	end

	local row = menu.categoryTable:addRow(true, {  })
	row[2]:createDropDown(menu.availablecustomgamestarts, { textOverride = ReadText(1001, 9945), optionWidth = width - Helper.scaleY(config.table.arrowColumnWidth) - Helper.borderSize, scaling = false, height = Helper.scaleY(config.standardTextHeight), active = #menu.availablecustomgamestarts > 0 }):setTextProperties({ halign = "center", scaling = true })
	row[2].handlers.onDropDownConfirmed = function(_, id) return menu.dropdownImport(id) end
	row[3]:setColSpan(2):createButton({  }):setText(ReadText(1001, 9946), { halign = "center" })
	row[3].handlers.onClick = function () return menu.buttonExport(false) end

	menu.exportButtonPos = { x = menu.categoryTable.properties.x + row[1]:getWidth() + row[2]:getWidth() + 2 * Helper.borderSize, y = menu.categoryTable.properties.y + menu.categoryTable:getFullHeight() }

	local row = menu.categoryTable:addRow(true, {  })
	row[2]:createButton({ active = function () return menu.creative or (not C.IsGameStartModified(menu.customgamestart)) end, mouseOverText = function () return C.IsGameStartModified(menu.customgamestart) and (menu.creative and ReadText(1026, 9904) or ReadText(1026, 9905)) or "" end }):setText(function () return (menu.creative and C.IsGameStartModified(menu.customgamestart)) and ReadText(1001, 9905) or ReadText(1001, 9902) end, { halign = "center", color = function () return C.IsGameStartModified(menu.customgamestart) and Color["text_warning"] or Color["text_normal"] end })
	row[2].handlers.onClick = menu.buttonNewGame
	row[3]:setColSpan(2):createButton({  }):setText(ReadText(1001, 9904), { halign = "center" })
	row[3].handlers.onClick = menu.buttonReset

	-- kuertee start: callback
	if callbacks ["display_on_after_main_options"] then
		for _, callback in ipairs (callbacks ["display_on_after_main_options"]) do
			callback ()
		end
	end
	-- kuertee end: callback

	menu.categoryTable:setTopRow(menu.topRows.categoryTable)
	menu.categoryTable:setSelectedRow(menu.selectedRows.categoryTable)
	menu.topRows.categoryTable = nil
	menu.selectedRows.categoryTable = nil

	local maxdetails, hasanybudget = menu.updateBudgets()
	maxdetails = math.min(config.maxBudgetDetails, maxdetails)

	local budgetTableHeight = Helper.scaleY(config.budgetheight)
	local budgetTableWidth = math.min(Helper.viewWidth, 2 * #menu.budgets * (Helper.scaleX(config.budgetwidth) + Helper.borderSize) - Helper.borderSize)
	local yoffset = Helper.viewHeight - Helper.frameBorder
	if hasanybudget then
		yoffset = yoffset - budgetTableHeight
	end
	menu.budgetTable = menu.mainFrame:addTable(2 * #menu.budgets, { tabOrder = 20, x = (Helper.viewWidth - budgetTableWidth) / 2, y = yoffset, width = budgetTableWidth })
	menu.budgetTable:setDefaultCellProperties("button", { height = config.standardTextHeight })
	menu.budgetTable:setDefaultComplexCellProperties("button", "text", { x = config.standardTextOffsetX, fontsize = config.standardFontSize })

	if hasanybudget then
		local row = menu.budgetTable:addRow(nil, { fixed = true })
		row[1]:setColSpan(2 * #menu.budgets):createText(ReadText(1001, 9922), config.headerTextProperties)
		row[1].properties.halign = "center"

		local rows = {}
		for i = 1, maxdetails + 2 do
			rows[i] = menu.budgetTable:addRow(true, { fixed = true })
		end
		for i, budget in ipairs(menu.budgets) do
			if not budget.inactive then
				if budget.type then
					rows[1][2 * i - 1]:setColSpan(2):createText(function () return menu.budgetHeaderName(budget.id) end, config.subHeaderTextProperties)
					rows[1][2 * i - 1].properties.halign = "left"
					rows[1][2 * i - 1].properties.mouseOverText = budget.desc
				else
					rows[1][2 * i - 1]:setBackgroundColSpan(2):createText(function () return menu.budgetHeaderName(budget.id) end, config.subHeaderTextProperties)
					rows[1][2 * i - 1].properties.halign = "left"
					rows[1][2 * i - 1].properties.mouseOverText = budget.desc
					rows[1][2 * i]:createText(function () return menu.budgetHeaderText(budget.id) end, config.subHeaderTextProperties)
					rows[1][2 * i].properties.halign = "right"
					rows[1][2 * i].properties.mouseOverText = budget.desc
				end

				for j, detail in ipairs(budget.details) do
					if (j <= maxdetails - 1) or (j == #budget.details) then
						if budget.type then
							rows[j + 1][2 * i - 1]:setColSpan(2):createText(menu.storiesbyid[detail.property] and menu.storiesbyid[detail.property].name or detail.property)
						else
							rows[j + 1][2 * i - 1]:createText(menu.findPropertyName(detail.property))
							rows[j + 1][2 * i]:createText(function () menu.updateBudgets(); return ConvertIntegerString(menu.propertybudgets[budget.id .. detail.property], true, 3, true) .. budget.suffix end, { halign = "right" })
						end
					else
						rows[j + 1][2 * i - 1]:setColSpan(2):createText("[...]")
						break
					end
				end

				rows[#rows][2 * i]:createButton({  }):setText(ReadText(1001, 9950), { halign = "center" })
				rows[#rows][2 * i].handlers.onClick = function () return menu.buttonResetBudget(budget.id) end
			end
		end
	end

	local offsetx = menu.categoryTable.properties.x + menu.categoryTable.properties.width + 2 * Helper.borderSize
	local width = menu.width / 2 - 4 * Helper.borderSize
	if menu.category.type == "flowchart" then
		width = width + menu.width / 4
	end
	width = math.min(width, Helper.scaleX(1600))
	if hasanybudget then
		local budgetTableRightBorder = menu.budgetTable.properties.x + menu.budgetTable.properties.width
		if budgetTableRightBorder < 0.75 * Helper.viewWidth then
			width = budgetTableRightBorder - offsetx
		end
	end

	menu.propertyTable = {}
	if next(menu.category) then
		local offsety = Helper.scaleY(config.table.y)
		local numCols = ((menu.category.type == "property") or (menu.category.type == "story")) and 4 or 5
		menu.propertyTable = menu.mainFrame:addTable(numCols, { tabOrder = 1, x = offsetx, y = offsety, width = width, maxVisibleHeight = menu.budgetTable.properties.y - Helper.borderSize - offsety, defaultInteractiveObject = true, highlightMode = "column" })
		if menu.category.type == "property" then
			menu.propertyTable:setColWidth(1, config.standardTextHeight)
			menu.propertyTable:setColWidthPercent(2, 45)
			menu.propertyTable:setColWidth(4, config.standardTextHeight)
		elseif menu.category.type == "story" then
			menu.propertyTable:setColWidth(1, config.standardTextHeight)
			menu.propertyTable:setColWidthPercent(2, 35)
			menu.propertyTable:setColWidth(4, config.standardTextHeight)
		else
			menu.propertyTable:setColWidthPercent(1, 30)
			menu.propertyTable:setColWidth(2, 4 * config.standardTextHeight)
			menu.propertyTable:setColWidth(3, config.standardTextHeight)
			menu.propertyTable:setColWidth(5, config.standardTextHeight)

			menu.propertyTable:setDefaultColSpan(3, 3)
		end
		menu.propertyTable:setDefaultCellProperties("text", { minRowHeight = config.standardTextHeight, fontsize = config.standardFontSize })
		menu.propertyTable:setDefaultCellProperties("button", { height = config.standardTextHeight })
		menu.propertyTable:setDefaultComplexCellProperties("button", "text", { x = config.standardTextOffsetX, fontsize = config.standardFontSize })
		menu.propertyTable:setDefaultComplexCellProperties("button", "text2", { x = config.standardTextOffsetX, fontsize = config.standardFontSize, halign = "right" })
		menu.propertyTable:setDefaultCellProperties("dropdown", { height = config.standardTextHeight })
		menu.propertyTable:setDefaultComplexCellProperties("dropdown", "text", { x = config.standardTextOffsetX, fontsize = config.standardFontSize })
		menu.propertyTable:setDefaultComplexCellProperties("dropdown", "text2", { x = config.standardTextOffsetX, fontsize = config.standardFontSize, halign = "right" })
		menu.propertyTable:setDefaultCellProperties("slidercell", { height = config.standardTextHeight })
		menu.propertyTable:setDefaultComplexCellProperties("slidercell", "text", { x = config.standardTextOffsetX, fontsize = config.standardFontSize })

		local row = menu.propertyTable:addRow(nil, { fixed = true })
		row[1]:setColSpan(numCols):createText(menu.category.name, config.headerTextProperties)

		-- kuertee start: callback
		if callbacks ["display_on_after_category_name"] then
			for _, callback in ipairs (callbacks ["display_on_after_category_name"]) do
				callback (numCols)
			end
		end
		-- kuertee end: callback

		if menu.category.type == "list" then
			for _, property in ipairs(menu.category.properties) do
				local minvalue, maxvalue, options
				if property.getState then
					menu.initPropertyValue(property)
				elseif property.propertyType == "Internal" then
					property.value = property.get()
				elseif property.get then
					local buf = ffi.new("CustomGameStart" .. property.propertyType .. "PropertyState[1]")
					property.value = property.get(menu.customgamestart, property.id, buf)
					property.state = ffi.string(buf[0].state)
					property.defaultvalue = buf[0].defaultvalue
					if property.propertyType == "String" then
						property.value = ffi.string(property.value)
						property.defaultvalue = ffi.string(property.defaultvalue)
						options = ffi.string(buf[0].options)
					elseif property.propertyType == "Money" then
						property.value = tonumber(property.value)
						property.defaultvalue = tonumber(property.defaultvalue)
						minvalue = buf[0].minvalue
						maxvalue = buf[0].maxvalue
					end
				end

				if property.name and (property.state ~= "") then
					local row = menu.propertyTable:addRow(property, {  })
					local propertyname = property.name .. (((not menu.creative) and (property.state == "modified")) and (" [" .. ReadText(1001, 9903) .. "]") or "")
					row[1]:setColSpan(property.budget and 1 or 2):createText(propertyname .. ReadText(1001, 120), config.standardTextProperties)
					row[1].properties.mouseOverText = property.mouseOverText
					row[1].properties.color = function () return menu.propertyColor(property) end

					-- kuertee start: callback
					if callbacks ["display_on_after_property_name"] then
						for _, callback in ipairs (callbacks ["display_on_after_property_name"]) do
							callback (numCols, property)
						end
					end
					-- kuertee end: callback

					if property.budget then
						local text, mouseovertext = "", ""
						for _, budget in ipairs(menu.budgets) do
							if type(property.budget) == "table" then
								for _, propertybudget in ipairs(property.budget) do
									if budget.id == propertybudget then
										if (not menu.creative) and C.HasCustomGameStartBudget(menu.customgamestart, propertybudget) then
											text = text .. Helper.convertColorToText(budget.color) .. "\27[" .. budget.icon .. "]"
											if mouseovertext ~= "" then
												mouseovertext = mouseovertext .. "\n"
											end
											mouseovertext = mouseovertext .. budget.name
										end
									end
								end
							else
								if budget.id == property.budget then
									if (not menu.creative) and C.HasCustomGameStartBudget(menu.customgamestart, property.budget) then
										row[2]:createText("\27[" .. budget.icon .. "]", { halign = "right", color = budget.color, mouseOverText = budget.name })
									end
									break
								end
							end
						end
						if text ~= "" then
							row[2]:createText(text, { halign = "right", mouseOverText = mouseovertext })
						end
					end
					if property.type == "number" then
						local scale = property.formatValue(property.value, minvalue, maxvalue)
						row[3]:createSliderCell({ min = scale.min, minSelect = scale.minSelect, max = scale.max, maxSelect = scale.maxSelect, start = scale.start, step = scale.step, suffix = scale.suffix, exceedMaxValue = scale.exceedMaxValue, hideMaxValue = scale.hideMaxValue, readOnly = scale.readOnly, accuracyOverride = 0 })
						row[3].handlers.onSliderCellChanged = function (_, value) return menu.slidercellNumberProperty(property, row.index, value) end
					elseif property.type == "dropdown" then
						local options, currentOption = property.formatValue(property.value, options)
						menu.curDropDownOption[property.id] = tostring(currentOption)
						row[3]:createDropDown(options, { startOption = currentOption })
						row[3].handlers.onDropDownConfirmed = function(_, id) return menu.dropdownProperty(property, row.index, id) end
						row[3].handlers.onDropDownActivated = function(_, id) return menu.onPropertyDropDownActivated(property, row.index, id) end
					elseif property.type == "editbox" then
						row[3]:createEditBox({ description = propertyname, active = property.active }):setText(property.value, { fontsize = config.standardFontSize })
						row[3].handlers.onTextChanged = function(_, text) return menu.editboxProperty(property, text) end
					elseif property.type == "bool" then
						row[3]:createButton({ active = property.active }):setText(function () return property.value and ReadText(1001, 2617) or ReadText(1001, 2618) end)
						row[3].handlers.onClick = function() return menu.buttonBoolProperty(property) end
					elseif property.type == "button" then
						local text = property.formatValue(property.value)
						row[3]:createButton({ active = property.active }):setText(text, { halign = "center" })
						row[3].handlers.onClick = property.set
					elseif property.type == "multiselectslider" then
						for i, entry in ipairs(property.value) do
							if i ~= 1 then
								row = menu.propertyTable:addRow(property, {  })
							end
							local name = entry.name

							local budgetsuffix = menu.getBudgetSuffix(property.budget)
							if property.propertyType == "Inventory" then
								name = name .. (budgetsuffix and (" (" .. ConvertIntegerString(GetWareData(entry.id, "avgprice"), true, 3, true) .. budgetsuffix .. ")") or "")
							end

							row[3]:createSliderCell({ min = 0, max = 10000, start = entry.amount, step = 1, hideMaxValue = true }):setText(name, { color = (entry.amount ~= entry.defaultamount) and Color["customgamestart_property_changed"] or Color["text_normal"] })
							row[3].handlers.onSliderCellChanged = function (_, value) return menu.slidercellMultiSelect(property, entry.id, row.index, value) end
							row[3].handlers.onSliderCellConfirm = function () menu.refresh = getElapsedTime() end
						end
						if #property.value > 0 then
							row = menu.propertyTable:addRow(property, {  })
						end
						local text = property.formatValue(#property.value)
						row[3]:createButton({  }):setText(text, { halign = "center" })
						row[3].handlers.onClick = function () return menu.displayMultiSelection(property) end
					elseif property.type == "multiselect" then
						for i, entry in ipairs(property.value) do
							if i ~= 1 then
								row = menu.propertyTable:addRow(property, {  })
							end
							
							if property.id == "playerknownspace" then
								row[3]:setColSpan(1):createButton({ helpOverlayID = "knownsector_expand", helpOverlayText = " ", helpOverlayHighlightOnly = true }):setText(menu.expandedProperty["knownsector_" .. entry.id] and "-" or "+", { halign = "center", x = 0 })
								row[3].handlers.onClick = function () return menu.buttonExpandProperty("knownsector_" .. entry.id) end
								row[4]:setColSpan(2):createText(function () return menu.getMultiSelectEntryName(property, entry) end, { color = (not entry.default) and Color["customgamestart_property_changed"] or Color["text_normal"] })
								if menu.expandedProperty["knownsector_" .. entry.id] then
									local budgetsuffix = menu.getBudgetSuffix("known")
									local checked, budgetvalue = menu.getKnownValue("playerknownobjects", entry.id)
									local row = menu.propertyTable:addRow(property, {  })
									row[3]:setColSpan(1)
									row[4]:setColSpan(1):createText(ReadText(1001, 9937) .. (budgetsuffix and (" (" .. ConvertIntegerString(checked and budgetvalue or 0, true, 3, true) .. budgetsuffix .. ")") or "") .. ReadText(1001, 120), { x = config.standardTextHeight })
									row[5]:createCheckBox(checked, { mouseOverText = ReadText(1026, 9903) })
									row[5].handlers.onClick = function (_, checked) return menu.checkboxKnownStations(entry.id, checked) end

									local budgetsuffix = menu.getBudgetSuffix("money")
									local row = menu.propertyTable:addRow(property, {  })
									row[3]:setColSpan(1)
									row[4]:setColSpan(1):createText(ReadText(1001, 9936) .. (budgetsuffix and (" (" .. ConvertIntegerString(menu.satellites[entry.id] and menu.satellites[entry.id].totalvalue or 0, true, 3, true) .. budgetsuffix .. ")") or "") .. ReadText(1001, 120), { x = config.standardTextHeight })
									row[5]:createCheckBox(menu.satellites[entry.id] ~= nil)
									row[5].handlers.onClick = function (_, checked) return menu.checkboxSatelliteCoverage(entry.id, checked) end
								end
							else
								row[3]:createText(function () return menu.getMultiSelectEntryName(property, entry) end, { color = (not entry.default) and Color["customgamestart_property_changed"] or Color["text_normal"] })
							end
						end
						if #property.value > 0 then
							row = menu.propertyTable:addRow(property, {  })
						end
						local text = property.formatValue(#property.value)
						row[3]:createButton({  }):setText(text, { halign = "center" })
						row[3].handlers.onClick = function () return menu.displayMultiSelection(property) end
					end
				end
			end

			menu.propertyTable:setTopRow(menu.topRows.propertyTable)
			menu.propertyTable:setSelectedRow(menu.selectedRows.propertyTable)
		elseif menu.category.type == "flowchart" then
			if menu.category.id == "playerresearch" then
				menu.category.value = {}
				local n = C.GetCustomGameStartResearchPropertyCounts(menu.customgamestart, menu.category.id)
				local buf = ffi.new("const char*[?]", n)
				n = C.GetCustomGameStartResearchProperty(buf, n, menu.customgamestart, menu.category.id)
				for i = 0, n - 1 do
					menu.category.value[ffi.string(buf[i])] = true
				end
			elseif menu.category.id == "universefactionrelations" then
				menu.category.value = {}
				local n = C.GetCustomGameStartRelationsPropertyCounts(menu.customgamestart, menu.category.id)
				local buf = ffi.new("CustomGameStartRelationInfo[?]", n)
				n = C.GetCustomGameStartRelationsProperty(buf, n, menu.customgamestart, menu.category.id)
				for i = 0, n - 1 do
					menu.setFactionRelation(menu.category.value, ffi.string(buf[i].factionid), ffi.string(buf[i].otherfactionid), buf[i].relation)
				end
			end

			Helper.clearDataForRefresh(menu, config.expandedMenuFrameLayer)

			menu.flowchartRows = 0
			menu.flowchartCols = 0
			if menu.category.id == "playerresearch" then
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
			elseif menu.category.id == "universefactionrelations" then
				local count = 0
				for _, entry in ipairs(menu.factions) do
					local allowedbystory = false
					if config.factionrelationsallowedbystory[entry.id] then
						for groupid, storyentry in pairs(menu.stories) do
							if config.factionrelationsallowedbystory[entry.id][storyentry.currentstory] then
								allowedbystory = true
								break
							end
						end
					end

					if menu.creative or ((not entry.isrelationlocked) or allowedbystory) then
						count = count + 1
					end
				end

				menu.flowchartRows = math.max(1, count - 1)
				menu.flowchartCols = 3
			end

			local xoffset = menu.categoryTable.properties.x + menu.categoryTable.properties.width + 2 * Helper.borderSize
			local yoffset = menu.propertyTable.properties.y + menu.propertyTable:getFullHeight() + 2 * Helper.borderSize
			local width = 3 * menu.width / 4 - 4 * Helper.borderSize
			local height = menu.budgetTable.properties.y - Helper.borderSize - yoffset
			menu.flowchart = menu.mainFrame:addFlowchart(menu.flowchartRows, menu.flowchartCols, { minRowHeight = 45, minColWidth = config.nodewidth, x = xoffset, y = yoffset, width = width, maxVisibleHeight = height, edgeWidth = 1 })
			menu.flowchart:setDefaultNodeProperties({
				expandedFrameLayer = config.expandedMenuFrameLayer,
				expandedTableNumColumns = 2,
				x = config.nodeoffsetx,
				width = config.nodewidth,
			})
			if menu.category.id == "playerresearch" then
				for col = 2, menu.flowchartCols, 2 do
					menu.flowchart:setColBackgroundColor(col, Color["row_title"])
				end
			end

			if menu.category.id == "playerresearch" then
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
							if techentry.completed then
								value = 100
							end
							local color
							if not techentry.completed then
								color = Color["lso_node_inactive"]
							end
							techentry.node = menu.flowchart:addNode(rowCounter + j - 1, col, { data = { mainIdx = i, col = col, techdata = techentry }, expandHandler = menu.expandNodeResearch }, { shape = "stadium", value = value, max = max }):setText(GetWareData(techentry.tech, "name"))
							techentry.node.properties.outlineColor = color
							techentry.node.properties.text.color = (techentry.completed == techentry.origCompleted) and color or Color["customgamestart_property_changed"]

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
										edge.properties.sourceSlotColor = Color["lso_node_inactive"]
										edge.properties.color = Color["lso_node_inactive"]
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
			elseif menu.category.id == "universefactionrelations" then
				local name = menu.currentfaction.name
				if menu.currentfaction.id == "player" then
					local buf = ffi.new("CustomGameStartStringPropertyState[1]")
					name = ffi.string(C.GetCustomGameStartStringProperty(menu.customgamestart, "playername", buf))
				end
				-- Disabled npc / npc relation changes for now
				local factionnode = menu.flowchart:addNode(1, 1, { data = {}, --[[expandHandler = menu.expandNodeCurrentFaction]] }, { shape = "stadium", value = 1, max = 1, expandedFrameLayer = 0 }):setText(name)
				factionnode.properties.text.color = (menu.currentfaction.id == "player") and Color["text_player"] or nil

				-- factionnode.handlers.onExpanded = menu.onFlowchartNodeExpanded
				-- factionnode.handlers.onCollapsed = menu.onFlowchartNodeCollapsed

				if menu.restoreNodeFaction and menu.restoreNodeFaction == "current" then
					menu.restoreNode = factionnode
					menu.restoreNodeFaction = nil
				end

				local row = 0
				for _, entry in ipairs(menu.currentfaction.relations) do
					local allowedbystory = false
					if config.factionrelationsallowedbystory[entry.id] then
						for groupid, storyentry in pairs(menu.stories) do
							if config.factionrelationsallowedbystory[entry.id][storyentry.currentstory] then
								allowedbystory = true
								break
							end
						end
					end

					if (entry.id ~= menu.currentfaction.id) and (menu.creative or ((not entry.isrelationlocked) or allowedbystory)) then
						row = row + 1

						local name = entry.name
						if entry.id == "player" then
							local buf = ffi.new("CustomGameStartStringPropertyState[1]")
							name = ffi.string(C.GetCustomGameStartStringProperty(menu.customgamestart, "playername", buf))
						end
						local relation = menu.category.value[menu.currentfaction.id] and menu.category.value[menu.currentfaction.id][entry.id] or entry.relation
						local relationFunction = function () return (menu.category.value and menu.category.value[menu.currentfaction.id]) and menu.category.value[menu.currentfaction.id][entry.id] or entry.relation end

						local node = menu.flowchart:addNode(row, 3, { data = { faction = entry, relation = relation, relationFunction = relationFunction, origRelation = entry.origRelation }, expandHandler = menu.expandNodeFaction }, { shape = "stadium", value = function () return relationFunction() + 30 end, max = 60 }):setText(name):setStatusText(relationFunction)
						node.properties.valueColor = (relation <= -10) and Color["text_enemy"] or nil
						node.properties.outlineColor = (relation <= -10) and Color["text_enemy"] or nil
						node.properties.text.color = (entry.id == "player") and Color["text_player"] or nil
						node.properties.statustext.color = (relation ~= entry.origRelation) and Color["customgamestart_property_changed"] or nil

						node.handlers.onExpanded = menu.onFlowchartNodeExpanded
						node.handlers.onCollapsed = menu.onFlowchartNodeCollapsed

						if menu.restoreNodeFaction and menu.restoreNodeFaction == entry.id then
							menu.restoreNode = node
							menu.restoreNodeFaction = nil
						end

						local edge = factionnode:addEdgeTo(node)
						if relation <= -10 then
							edge.properties.destSlotColor = Color["text_enemy"]
							edge.properties.color = Color["text_enemy"]
						end
					end
				end
			end

			menu.restoreFlowchartState("flowchart", menu.flowchart)
		elseif menu.category.type == "property" then
			if menu.category.id == "playerproperty" then
				local limitedmodulesused = {}

				local stationdata = {}
				local fleetdata = {}
				menu.subordinates = {}
				if menu.category.state.numvalues > 0 then
					local counts = ffi.new("CustomGameStartPlayerPropertyCounts[?]", menu.category.state.numvalues)
					local n = C.GetCustomGameStartPlayerPropertyCounts(counts, menu.category.state.numvalues, menu.customgamestart, menu.category.id)
					if n > 0 then
						local buf = ffi.new("CustomGameStartPlayerProperty3[?]", n)
						for i = 0, n - 1 do
							buf[i].numcargo = counts[i].numcargo
							buf[i].cargo = Helper.ffiNewHelper("UIWareInfo[?]", counts[i].numcargo)
						end
						n = C.GetCustomGameStartPlayerPropertyProperty3(buf, n, menu.customgamestart, menu.category.id)
						for i = 0, n - 1 do
							local id = ffi.string(buf[i].id)
							local entry = {
								type = ffi.string(buf[i].type),
								id = id,
								macro = ffi.string(buf[i].macroname),
								name = ffi.string(buf[i].name),
								commanderid = ffi.string(buf[i].commanderid),
								constructionplanid = ffi.string(buf[i].constructionplanid),
								peopledef = ffi.string(buf[i].peopledefid),
								peoplefillpercentage = buf[i].peoplefillpercentage,
								sector = ffi.string(buf[i].sector),
								offset = { x = buf[i].offset.x, y = buf[i].offset.y, z = buf[i].offset.z, yaw = buf[i].offset.yaw, pitch = buf[i].offset.pitch, roll = buf[i].offset.roll },
								count = buf[i].count,
								budgetvalue = {
									money = tonumber(C.GetCustomGameStartPlayerPropertyValue(menu.customgamestart, "playerproperty", id)),
									people = tonumber(C.GetCustomGameStartPlayerPropertyPeopleValue(menu.customgamestart, "playerproperty", id)),
								},
							}

							if entry.commanderid ~= "" then
								if menu.subordinates[entry.commanderid] then
									table.insert(menu.subordinates[entry.commanderid], entry)
								else
									menu.subordinates[entry.commanderid] = { entry }
								end
							else
								if entry.type == "station" then
									local num_modules = C.GetNumPlannedLimitedModules(entry.constructionplanid)
									local buf_modules = ffi.new("UIMacroCount[?]", num_modules)
									num_modules = C.GetPlannedLimitedModules(buf_modules, num_modules, entry.constructionplanid)
									for j = 0, num_modules - 1 do
										local macro = ffi.string(buf_modules[j].macro)
										limitedmodulesused[macro] = (limitedmodulesused[macro] or 0) + buf_modules[j].amount
									end

									table.insert(stationdata, entry)
								elseif entry.type == "ship" then
									table.insert(fleetdata, entry)
								end
							end
						end
					end
				end

				local onlineitems = OnlineGetUserItems()

				-- stations
				menu.constructionplans = {}
				menu.hqconstructionplans = {}
				local n = C.GetNumConstructionPlans()
				local buf = ffi.new("UIConstructionPlan[?]", n)
				n = C.GetConstructionPlans(buf, n)
				local ischeatversion = IsCheatVersion()
				for i = 0, n - 1 do
					local id = ffi.string(buf[i].id)
					local source = ffi.string(buf[i].source)
					if (source == "local") or C.IsConstructionPlanAvailableInCustomGameStart(id) or ischeatversion then
						local isvalid, exceedslimitedmodules, hasexcludedmacros = true, false, false
						local mouseovertext
						local numinvalidpatches = ffi.new("uint32_t[?]", 1)
						if not C.IsConstructionPlanValid(id, numinvalidpatches) then
							isvalid = false
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
							isvalid = false
							mouseovertext = ReadText(1026, 7929)
						end

						local limitedmodulestext = ""
						local num_modules = C.GetNumPlannedLimitedModules(id)
						local buf_modules = ffi.new("UIMacroCount[?]", num_modules)
						num_modules = C.GetPlannedLimitedModules(buf_modules, num_modules, id)
						for j = 0, num_modules - 1 do
							local macro = ffi.string(buf_modules[j].macro)
							local ware = GetMacroData(macro, "ware")
							if (limitedmodulesused[macro] or 0) + buf_modules[j].amount > (onlineitems[ware] and onlineitems[ware].amount or 0) then
								exceedslimitedmodules = true
								limitedmodulestext = limitedmodulestext .. "\n- " .. GetMacroData(macro, "name")
							end
						end
						if limitedmodulestext ~= "" then
							if mouseovertext then
								mouseovertext = mouseovertext .. "\n"
							else
								mouseovertext = ""
							end
							mouseovertext = mouseovertext .. ReadText(1026, 7915) .. limitedmodulestext
						end

						local excludedmacrosmouseovertext = ""
						local foundmacros = {}
						for _, macro in ipairs(config.excludedmodules) do
							local hasmacro = Helper.textArrayHelper({ macro }, function (numtexts, texts) return C.CheckConstructionPlanForMacros(id, texts, numtexts) end)
							if hasmacro then
								table.insert(foundmacros, macro)
							end
						end
						if #foundmacros > 0 then
							hasexcludedmacros = true
							if mouseovertext then
								excludedmacrosmouseovertext = "\n"
							end
							excludedmacrosmouseovertext = excludedmacrosmouseovertext .. ReadText(1026, 9902) .. ReadText(1001, 120)
							for j, macro in ipairs(foundmacros) do
								if j > 3 then
									excludedmacrosmouseovertext = excludedmacrosmouseovertext .. "\n- ..."
									break
								end
								excludedmacrosmouseovertext = excludedmacrosmouseovertext .. "\n- " .. GetMacroData(macro, "name")
							end
						end

						local blueprintcost = 0
						local blueprintproperty = menu.findProperty("playerblueprints")
						if blueprintproperty then
							menu.initPropertyValue(blueprintproperty)
							for ware in pairs(menu.getCPWares(id)) do
								local found = false
								for j, entry in ipairs(blueprintproperty.value) do
									if entry.id == ware then
										found = true
										break
									end
								end
								if not found then
									blueprintcost = blueprintcost + GetWareData(ware, "avgprice")
								end
							end
						end

						table.insert(menu.constructionplans, { id = id, text = ffi.string(buf[i].name), text2 = ConvertMoneyString(tonumber(C.GetStationValue("station_gen_factory_base_01_macro", id)) + blueprintcost, false, true, 0, true, false) .. " " .. ReadText(1001, 101), icon = "", displayremoveoption = false, active = isvalid and (not exceedslimitedmodules) and (not hasexcludedmacros), mouseovertext = (mouseovertext or "") .. excludedmacrosmouseovertext })
						if hasexcludedmacros then
							table.insert(menu.hqconstructionplans, { id = id, text = ffi.string(buf[i].name), text2 = ConvertMoneyString(tonumber(C.GetStationValue("station_pla_headquarters_base_01_macro", id)) + blueprintcost, false, true, 0, true, false) .. " " .. ReadText(1001, 101), icon = "", displayremoveoption = false, active = isvalid and (not exceedslimitedmodules), mouseovertext = mouseovertext })
						end
					end
				end
				table.sort(menu.constructionplans, function (a, b) return a.text < b.text end)
				table.sort(menu.hqconstructionplans, function (a, b) return a.text < b.text end)

				local row = menu.propertyTable:addRow(nil, {  })
				row[1]:setColSpan(4):createText(ReadText(1001, 4), config.subHeaderTextProperties)

				for _, entry in ipairs(stationdata) do
					menu.displayPlayerPropertyEntry(menu.propertyTable, entry, 0)
				end

				local row = menu.propertyTable:addRow(true, {  })
				row[1]:setColSpan(4):createDropDown(menu.constructionplans, { textOverride = ReadText(1001, 9921), text2Override = " " })
				row[1].handlers.onDropDownConfirmed = function(_, id) return menu.dropdownPlayerPropertyAddStation("station" .. #stationdata, id, nil, true) end
				if row.index == menu.selectedRows.propertyTable then
					menu.selectedCols.propertyTable = nil
				end

				menu.propertyTable:addEmptyRow(config.standardTextHeight / 2)

				local row = menu.propertyTable:addRow(nil, { bgColor = Color["row_background_unselectable"] })
				row[1]:setColSpan(4):createText("", { fontsize = 1, minRowHeight = 3 })

				menu.propertyTable:addEmptyRow(config.standardTextHeight / 2)

				--fleets
				local row = menu.propertyTable:addRow(nil, {  })
				row[1]:setColSpan(4):createText(ReadText(1001, 8326), config.subHeaderTextProperties)

				for _, entry in ipairs(fleetdata) do
					menu.displayPlayerPropertyEntry(menu.propertyTable, entry, 0)
				end

				local row = menu.propertyTable:addRow(true, {  })
				row[1]:setColSpan(4):createButton({  }):setText(ReadText(1001, 9918))
				row[1].handlers.onClick = function () return menu.openPlayerPropertyShipConfig(row.index, "fleet" .. #fleetdata) end
				if row.index == menu.selectedRows.propertyTable then
					menu.selectedCols.propertyTable = nil
				end

				menu.propertyTable:setTopRow(menu.topRows.propertyTable)
				menu.propertyTable:setSelectedRow(menu.selectedRows.propertyTable)
				if menu.selectedCols.propertyTable then
					menu.propertyTable:setSelectedCol(menu.selectedCols.propertyTable)
				end
			end
		elseif menu.category.type == "story" then
			if menu.category.id == "universestorystates" then
				local currentstories = {}
				local buf = ffi.new("const char*[?]", menu.category.state.numvalues)
				local n = C.GetCustomGameStartStoryProperty(buf, menu.category.state.numvalues, menu.customgamestart, menu.category.id)
				for i = 0, n - 1 do
					local storyid = ffi.string(buf[i])
					currentstories[storyid] = true
				end

				local defaultstories = {}
				local buf = ffi.new("const char*[?]", menu.category.state.numdefaultvalues)
				local n = C.GetCustomGameStartStoryDefaultProperty(buf, menu.category.state.numdefaultvalues, menu.customgamestart, menu.category.id)
				for i = 0, n - 1 do
					local storyid = ffi.string(buf[i])
					defaultstories[storyid] = true
				end

				for groupid, storyentry in pairs(menu.stories) do
					if groupid ~= "research" then
						for _, story in ipairs(storyentry.entries) do
							if currentstories[story.id] then
								menu.stories[groupid].currentstory = story.id
							end
							if defaultstories[story.id] then
								menu.stories[groupid].defaultstory = story.id
							end
						end
					end
				end

				local lockedStories = menu.getLockedStories()

				local row = menu.propertyTable:addRow(true, {  })
				row[1]:createCheckBox(menu.hidestoryspoilers)
				row[1].handlers.onClick = function (_, checked) menu.hidestoryspoilers = checked; menu.refreshMenu() end
				row[2]:setColSpan(3):createText(ReadText(1001, 9933), config.standardTextProperties)

				menu.propertyTable:addEmptyRow(config.standardTextHeight / 2)

				for _, groupid in ipairs(menu.storygroups) do
					local groupinfo = C.GetCustomGameStartBudgetGroupInfo(menu.customgamestart, groupid)
					if (not groupinfo.isresearch) and menu.stories[groupid] then
						local entry = menu.stories[groupid]
						local row = menu.propertyTable:addRow(true, {  })
						row[1]:setColSpan(2):createText(ffi.string(groupinfo.name), config.standardTextProperties)
						row[1].properties.mouseOverText = ffi.string(groupinfo.description)
						row[1].properties.color = (entry.currentstory ~= entry.defaultstory) and Color["customgamestart_property_changed"] or nil

						local startoption = entry.currentstory

						local islocked = false
						if lockedStories[startoption] then
							-- The current option is locked. Flag this dropdown to be locked and make all options inactive which are not locked
							islocked = true
						end

						local storyoptions = {}
						table.sort(entry.entries, function (a, b) return a.index < b.index end)
						for _, story in ipairs(entry.entries) do
							local ismodifying = (story.budgetvalue == 0) or menu.creative
							local hidden = (story.budgetvalue == 0) and menu.hidestoryspoilers
							local active = true
							local mouseovertext = story.description
							if not hidden then
								if next(story.dependencies) then
									for _, dependencylist in ipairs(story.dependencies) do
										local found = false
										local missingdependencies = ""
										for _, dependency in ipairs(dependencylist) do
											for _, entry in pairs(menu.stories) do
												if entry.currentstory == dependency then
													found = true
													break
												end
											end
											missingdependencies = missingdependencies .. "\n- " .. (menu.storiesbyid[dependency] and menu.storiesbyid[dependency].name or dependency)
										end
										if not found then
											mouseovertext = mouseovertext .. "\n\n" .. ReadText(1001, 9932) .. ReadText(1001, 120) .. ColorText["text_error"] .. missingdependencies .. "\27X"
											active = false
										end
									end
								end

								if active then
									-- Lock all options which are not required by the current sector selection
									if islocked and (not lockedStories[story.id]) then
										active = false
										mouseovertext = ReadText(1026, 9929)
									end
								end
							else
								active = false
								mouseovertext = ReadText(1026, 9907)
							end
							table.insert(storyoptions, { id = story.id, text = hidden and ReadText(1001, 3210) or story.name, text2 = ismodifying and ("[" .. ReadText(1001, 9903) .. "]") or "", icon = "", displayremoveoption = false, active = active, mouseovertext = mouseovertext })
						end
						table.insert(storyoptions, 1, { id = "default", text = ReadText(1001, 3231), icon = "", displayremoveoption = false, active = not islocked, mouseovertext = islocked and  ReadText(1026, 9929) or "" })

						row[3]:setColSpan(2):createDropDown(storyoptions, { startOption = (startoption and (startoption ~= "")) and startoption or "default", height = config.standardTextHeight })
						row[3].handlers.onDropDownConfirmed = function (_, storyid) return menu.dropdownStoryState(groupid, storyid) end
					end
				end

				menu.propertyTable:setTopRow(menu.topRows.propertyTable)
				menu.propertyTable:setSelectedRow(menu.selectedRows.propertyTable)
			end
		end

		-- kuertee start: callback
		if callbacks ["display_on_after_category_options"] then
			for _, callback in ipairs (callbacks ["display_on_after_category_options"]) do
				callback (numCols)
			end
		end
		-- kuertee end: callback

		if menu.category.rendertarget and (menu.contextMenu ~= "multiselect") then
			local offsetx = menu.propertyTable.properties.x + menu.propertyTable.properties.width + 2 * Helper.borderSize
			local offsety = Helper.scaleY(config.table.y)
			menu.renderTargetWidth = Helper.viewWidth - offsetx - Helper.frameBorder
			menu.renderTargetHeight = math.min(Helper.viewHeight - offsety - Helper.frameBorder, menu.width / 4)
			if hasanybudget then
				local budgetTableRightBorder = menu.budgetTable.properties.x + menu.budgetTable.properties.width
				if (offsetx < budgetTableRightBorder) and (offsety + menu.renderTargetHeight + Helper.borderSize > menu.budgetTable.properties.y) then
					menu.renderTargetHeight = Helper.viewHeight - menu.budgetTable.properties.y
				end
			end

			menu.rendertarget = menu.mainFrame:addRenderTarget({ width = menu.renderTargetWidth, height = menu.renderTargetHeight, x = offsetx, y = offsety, alpha = 100, clear = (menu.category.id ~= "universe") and (menu.category.id ~= "playerproperty"), startnoise = (menu.category.id == "player") and (not menu.cutsceneid) })
			menu.rendertargetLock = getElapsedTime() + 0.1
		end
	end
	menu.topRows.propertyTable = nil
	menu.selectedRows.propertyTable = nil
	menu.selectedCols.propertyTable = nil

	menu.mainFrame:display()
end

function menu.getLockedStories()
	local lockedStories = {}

	local buf = ffi.new("CustomGameStartStringPropertyState[1]")
	local playersectormacro = ffi.string(C.GetCustomGameStartStringProperty(menu.customgamestart, "sector", buf))
	menu.setStoriesLocked(lockedStories, playersectormacro)
	local state = C.GetCustomGameStartPlayerPropertyPropertyState(menu.customgamestart, "playerproperty")
	if state.numvalues > 0 then
		local counts = ffi.new("CustomGameStartPlayerPropertyCounts[?]", state.numvalues)
		local n = C.GetCustomGameStartPlayerPropertyCounts(counts, state.numvalues, menu.customgamestart, "playerproperty")
		if n > 0 then
			local buf = ffi.new("CustomGameStartPlayerProperty3[?]", n)
			for i = 0, n - 1 do
				buf[i].numcargo = counts[i].numcargo
				buf[i].cargo = Helper.ffiNewHelper("UIWareInfo[?]", counts[i].numcargo)
			end
			n = C.GetCustomGameStartPlayerPropertyProperty3(buf, n, menu.customgamestart, "playerproperty")
			for i = 0, n - 1 do
				local sector = ffi.string(C.GetCustomGameStartPlayerPropertySector(menu.customgamestart, "playerproperty", ffi.string(buf[i].id)))
				if sector ~= "" then
					menu.setStoriesLocked(lockedStories, sector)
				end
			end
		end
	end

	return lockedStories
end

function menu.setStoriesLocked(lookuptable, sector)
	local knownitem = ffi.new("CustomGameStartKnownEntry2")
	knownitem.type = Helper.ffiNewString("sector")
	knownitem.item = Helper.ffiNewString(sector)
	local sectordependencies = menu.getStoryDependencies("playerknownspace", knownitem)
	for _, dependencylist in ipairs(sectordependencies) do
		for _, dependency in ipairs(dependencylist) do
			lookuptable[dependency] = true

			-- set story dependencies of the dependency also locked
			local story = menu.storiesbyid[dependency]
			if story and next(story.dependencies) then
				for _, storydependencylist in ipairs(story.dependencies) do
					for _, storydependency in ipairs(storydependencylist) do
						lookuptable[storydependency] = true
					end
				end
			end
		end
	end
end

function menu.getBudgetSuffix(budget)
	for _, budgetentry in ipairs(menu.budgets) do
		if budgetentry.id == budget then
			if (not menu.creative) and C.HasCustomGameStartBudget(menu.customgamestart, budget) then
				return (budgetentry.suffix ~= "") and budgetentry.suffix or (" " .. Helper.convertColorToText(budgetentry.color) .. "\27[" .. budgetentry.icon .. "]\27X")
			end
		end
	end
end

function menu.getMultiSelectEntryName(property, entry)
	local name = entry.name

	local budget = property.budget
	if type(budget) == "table" then
		for _, budgetid in ipairs(property.budget) do
			if property.propertyType == "Blueprint" then
				if budgetid == "money" then
					budget = budgetid
				end
			elseif property.propertyType == "KnownEntry2" then
				if budgetid == "known" then
					budget = budgetid
				end
			end
		end
	end

	local budgetsuffix = menu.getBudgetSuffix(budget)
	if property.propertyType == "Blueprint" then
		name = name .. (budgetsuffix and (" (" .. ConvertIntegerString(GetWareData(entry.id, "avgprice"), true, 3, true) .. budgetsuffix .. ")") or "")
	elseif property.propertyType == "KnownEntry2" then
		name = name .. (budgetsuffix and (" (" .. ConvertIntegerString(entry.budgetvalue, true, 3, true) .. budgetsuffix .. ")") or "")
	end

	return name
end

function menu.findPropertyName(propertyid)
	local name = ""
	for _, category in ipairs(config.categories) do
		if category.id == propertyid then
			name = category.name
			break
		end
		if category.properties then
			for _, property in ipairs(category.properties) do
				if property.id == propertyid then
					name = property.name
					break
				end
			end
		end
	end
	return name
end

function menu.findProperty(propertyid)
	for _, category in ipairs(config.categories) do
		if category.properties then
			for _, property in ipairs(category.properties) do
				if property.id == propertyid then
					return property
				end
			end
		end
	end
end

function menu.updateBudgets()
	local curtime = getElapsedTime()
	if curtime ~= menu.lastBudgetUpdateTime then
		menu.lastBudgetUpdateTime = curtime

		menu.maxdetails = 0
		menu.hasanybudget = false
		for i, budget in ipairs(menu.budgets) do
			if C.HasCustomGameStartBudget(menu.customgamestart, budget.id) then
				menu.hasanybudget = not menu.creative
				budget.inactive = false
				if budget.type then
					budget.details = {}
					if budget.type == "story" then
						for _, groupid in ipairs(menu.storygroups) do
						local groupinfo = C.GetCustomGameStartBudgetGroupInfo(menu.customgamestart, groupid)
						if (not groupinfo.isresearch) and menu.stories[groupid] then
							local entry = menu.stories[groupid]
							if entry.currentstory ~= "" then
									table.insert(budget.details, { property = entry.currentstory })
									menu.propertybudgets[budget.id .. entry.currentstory] = true
								end
							end
						end
					elseif budget.type == "research" then
						local sortedstories = {}
						for story in pairs(menu.researchstories) do
							table.insert(sortedstories, { id = story, name = menu.storiesbyid[story] and menu.storiesbyid[story].name or story })
						end
						table.sort(sortedstories, Helper.sortName)
						for _, story in ipairs(sortedstories) do
							table.insert(budget.details, { property = story.id })
							menu.propertybudgets[budget.id .. story.id] = true
						end
					end
					menu.maxdetails = math.max(menu.maxdetails, #budget.details)
				else
					local info = C.GetCustomGameStartBudget(menu.customgamestart, budget.id)
					budget.value = tonumber(info.value)
					budget.limit = tonumber(info.limit)
					local buf = ffi.new("CustomGameStartBudgetDetail[?]", info.numdetails)
					local n = C.GetCustomGameStartBudgetDetails(buf, info.numdetails, menu.customgamestart, budget.id)
					menu.maxdetails = math.max(menu.maxdetails, n)
					budget.details = {}
					for j = 0, n - 1 do
						local property = ffi.string(buf[j].id)
						local value = tonumber(buf[j].value)
						table.insert(budget.details, { property = property, value = value })
						menu.propertybudgets[budget.id .. property] = value
					end
				end
			else
				budget.inactive = true
			end
		end
	end
	return menu.maxdetails, menu.hasanybudget
end

function menu.budgetHeaderName(budgetid)
	menu.updateBudgets()
	for i, budget in ipairs(menu.budgets) do
		if budget.id == budgetid then
			return Helper.convertColorToText(budget.color) .. "\27[" .. budget.icon .. "]\27X " .. (menu.isBudgetOverBudget(budget) and ColorText["text_warning"] or "") .. budget.name
		end
	end
	return ""
end

function menu.budgetHeaderText(budgetid)
	menu.updateBudgets()
	for i, budget in ipairs(menu.budgets) do
		if budget.id == budgetid then
			if not budget.type then
				return (menu.isBudgetOverBudget(budget) and ColorText["text_warning"] or "") .. ConvertIntegerString(budget.value, true, 3, true) .. "\27X / " .. ConvertIntegerString(budget.limit, true, 3, true) .. budget.suffix
			end
		end
	end
	return ""
end

function menu.isBudgetIDOverBudget(budgetid)
	menu.updateBudgets()
	for i, budget in ipairs(menu.budgets) do
		if budget.id == budgetid then
			return menu.isBudgetOverBudget(budget)
		end
	end
end

function menu.isBudgetOverBudget(budget)
	if (not menu.creative) and C.HasCustomGameStartBudget(menu.customgamestart, budget.id) then
		if budget.type then
			if budget.type == "story" then
				for groupid, entry in pairs(menu.stories) do
					if entry.currentstory ~= "" then
						local groupinfo = C.GetCustomGameStartBudgetGroupInfo(menu.customgamestart, groupid)
						if groupinfo.isresearch == (budget.type == "research") then
							local storyentry = menu.storiesbyid[entry.currentstory]
							if (storyentry and (storyentry.budgetvalue == 0)) or menu.creative then
								return true
							end
						end
					end
				end
			elseif budget.type == "research" then
				for story in pairs(menu.researchstories) do
					local storyentry = menu.storiesbyid[story]
					if (storyentry and (storyentry.budgetvalue == 0)) or menu.creative then
						return true
					end
				end
			end
			return false
		else
			return budget.value > budget.limit
		end
	end
end

function menu.getCategoryColor(category)
	local color = Color["text_normal"]
	if category.budget then
		if type(category.budget) == "table" then
			for _, categorybudget in ipairs(category.budget) do
				if menu.isBudgetIDOverBudget(categorybudget) then
					color = Color["text_warning"]
					break
				end
			end
		else
			if menu.isBudgetIDOverBudget(category.budget) then
				color = Color["text_warning"]
			end
		end
	end
	return ((not category.active) or category.active()) and color or Color["text_inactive"]
end

function menu.setStationManager(property, entryid, manager)
	local skills = {}
	for skill, value in pairs(manager.skills or {}) do
		table.insert(skills, { id = skill, value = value })
	end
	local buf = ffi.new("CustomGameStartPersonEntry")
	buf.race = Helper.ffiNewString(manager.race or "")
	buf.tags = Helper.ffiNewString(manager.tags or "")
	buf.numskills = #skills
	buf.skills = Helper.ffiNewHelper("SkillInfo[?]", buf.numskills)
	for i, entry in ipairs(skills) do
		buf.skills[i - 1].id = Helper.ffiNewString(entry.id)
		buf.skills[i - 1].value = entry.value
	end
	C.SetCustomGameStartPlayerPropertyPerson(menu.customgamestart, property, entryid, buf)
end

function menu.displayPlayerPropertyEntry(ftable, entry, iteration)
	local row = ftable:addRow(entry.id, {  })
	row[1]:createButton({ helpOverlayID = "property_expand", helpOverlayText = " ", helpOverlayHighlightOnly = true }):setText(menu.expandedProperty[entry.id] and "-" or "+", { halign = "center", x = 0 })
	row[1].handlers.onClick = function () return menu.buttonExpandProperty(entry.id) end
	local isHQentry = string.find(entry.id, "player_HQ_%d+", 1)

	local count, moneybudget, peoplebudget = menu.countPlayerProperty(entry.id, 0, entry.budgetvalue["money"], entry.budgetvalue["people"])
	local showmoney = (not menu.creative) and C.HasCustomGameStartBudget(menu.customgamestart, "money")
	local showpeople = (not menu.creative) and C.HasCustomGameStartBudget(menu.customgamestart, "people")
	local text2 = ""
	if showmoney then
		text2 = text2 .. ConvertMoneyString(moneybudget, false, true, 0, true, false) .. " " .. ReadText(1001, 101)
	end
	if showpeople then
		text2 = text2 .. ((text2 ~= "") and " - " or "") .. ConvertIntegerString(peoplebudget, true, 0, true) .. menu.getBudgetSuffix("people")
	end
	local name, ware = GetMacroData(entry.macro, "name", "ware")
	if entry.type == "ship" then
		row[2]:setColSpan(2):createButton({ x = iteration * config.standardTextHeight }):setText(name):setText2(text2)
		row[2].handlers.onClick = function () return menu.openPlayerPropertyShipConfig(row.index, entry.id, entry.macro, nil, entry.peopledef, entry.peoplefillpercentage, entry.count) end
	elseif entry.type == "station" then
		row[2]:setColSpan(2):createDropDown(isHQentry and menu.hqconstructionplans or menu.constructionplans, { startOption = entry.constructionplanid, text2Override = text2 })
		row[2].handlers.onDropDownConfirmed = function(_, id) return menu.dropdownPlayerPropertyAddStation(entry.id, id, isHQentry) end
	end

	row[4]:createButton({ active = not isHQentry }):setText("X", { halign = "center", x = 0 })
	row[4].handlers.onClick = function () return menu.buttonRemovePlayerProperty(entry.id)  end
	if menu.expandedProperty[entry.id] then
		-- name
		local row = ftable:addRow(entry.id, {  })
		row[2]:createText(ReadText(1021, 11003) .. ReadText(1001, 120), config.standardTextProperties)
		row[2].properties.x = row[2].properties.x + (iteration + 1) * config.standardTextHeight
		row[3]:setColSpan(2):createEditBox({ description = ReadText(1021, 11003) }):setText(entry.name, { fontsize = config.standardFontSize })
		row[3].handlers.onTextChanged = function(_, text) return menu.editboxPlayerPropertyName(entry.id, text) end
		row[3].handlers.onEditBoxDeactivated = function () menu.refresh = getElapsedTime() end
		-- sector
		local row = ftable:addRow(entry.id, {  })
		row[2]:createText(ReadText(1001, 11284) .. ReadText(1001, 120), config.standardTextProperties)
		row[2].properties.x = row[2].properties.x + (iteration + 1) * config.standardTextHeight
		local buf = ffi.new("CustomGameStartStringPropertyState[1]")
		local playersectormacro = ffi.string(C.GetCustomGameStartStringProperty(menu.customgamestart, "sector", buf))
		local options, currentOption = menu.universeSector((entry.sector ~= "") and entry.sector or playersectormacro)
		row[3]:setColSpan(2):createDropDown(options, { startOption = currentOption })
		row[3].handlers.onDropDownConfirmed = function(_, id) return menu.dropdownPlayerPropertySetSector(entry.id, id, entry.offset) end
		-- count
		if entry.type == "ship" then
			local row = ftable:addRow(entry.id, {  })
			row[2]:createText(ReadText(1001, 1202) .. ReadText(1001, 120), config.standardTextProperties)
			row[2].properties.x = row[2].properties.x + (iteration + 1) * config.standardTextHeight
			local options = {}
			for i = 1, 20 do
				local active = true
				local mouseovertext = ""
				local icon = ""
				if not menu.creative then
					local islimited = GetWareData(ware, "islimited")
					if islimited then
						local limitamount = Helper.getLimitedWareAmount(ware)
						if menu.usedlimitedships[entry.macro] - entry.count + i > limitamount then
							active = false
							mouseovertext = ReadText(1026, 8028)
							icon = "menu_locked"
						end
					end
				end
				table.insert(options, { id = i, text = i, icon = icon, displayremoveoption = false, active = active, mouseovertext = mouseovertext, overridecolor = (not active) and Color["text_error"] or nil })
			end
			for i = 30, 100, 10 do
				local active = true
				local mouseovertext = ""
				local icon = ""
				if not menu.creative then
					local islimited = GetWareData(ware, "islimited")
					if islimited then
						local limitamount = Helper.getLimitedWareAmount(ware)
						if menu.usedlimitedships[entry.macro] - entry.count + i > limitamount then
							active = false
							mouseovertext = ReadText(1026, 8028)
							icon = "menu_locked"
						end
					end
				end
				table.insert(options, { id = i, text = i, icon = icon, displayremoveoption = false, active = active, mouseovertext = mouseovertext, overridecolor = (not active) and Color["text_error"] or nil })
			end
			local dropdownheight = Helper.scaleY(config.standardTextHeight)
			row[3]:setColSpan(2):createDropDown(options, { startOption = entry.count }):setIconProperties({
				width = dropdownheight,
				height = dropdownheight,
				x = row[3]:getColSpanWidth() - 1.5 * dropdownheight,
				y = 0,
				scaling = false,
			})
			row[3].handlers.onDropDownConfirmed = function (_, amountstring) return menu.dropdownPlayerPropertySetCount(entry.id, tonumber(amountstring), entry.macro, entry.count) end
		end
		-- price
		if showmoney then
			local row = ftable:addRow(entry.id, {  })
			row[2]:createText(ReadText(1001, 2808) .. ReadText(1001, 120), config.standardTextProperties)
			row[2].properties.x = row[2].properties.x + (iteration + 1) * config.standardTextHeight
			row[3]:setColSpan(2):createText(ConvertMoneyString(entry.budgetvalue["money"], false, true, 0, true, false) .. " " .. ReadText(1001, 101), config.standardTextProperties)
		end
		-- crew
		if (entry.type == "ship") and showpeople then
			local row = ftable:addRow(entry.id, {  })
			row[2]:createText(ReadText(1001, 80) .. ReadText(1001, 120), config.standardTextProperties)
			row[2].properties.x = row[2].properties.x + (iteration + 1) * config.standardTextHeight
			row[3]:setColSpan(2):createText(ConvertIntegerString(entry.budgetvalue["people"], true, 0, true) .. menu.getBudgetSuffix("people"), config.standardTextProperties)
		end
		-- manager
		if entry.type == "station" then
			local manager = {}
			local value = 0
			local buf = ffi.new("CustomGameStartPersonEntry[1]")
			buf[0].numskills = C.GetNumSkills()
			buf[0].skills = Helper.ffiNewHelper("SkillInfo[?]", buf[0].numskills)
			if C.GetCustomGameStartPlayerPropertyPerson(buf, menu.customgamestart, "playerproperty", entry.id) then
				manager.race = ffi.string(buf[0].race)
				manager.tags = ffi.string(buf[0].tags)
				manager.skills = {}
				for i = 0, buf[0].numskills - 1 do
					local skill = ffi.string(buf[0].skills[i].id)
					manager.skills[skill] = buf[0].skills[i].value
				end

				value = tonumber(C.GetCustomGameStartShipPersonValue(menu.customgamestart, buf[0]))
			end

			local budgetsuffix = menu.getBudgetSuffix("people")
			local row = ftable:addRow(nil, {  })
			row[2]:createText(ReadText(20208, 30301) .. ReadText(1001, 120), config.standardTextProperties)
			row[2].properties.x = row[2].properties.x + (iteration + 1) * config.standardTextHeight
			row[3]:setColSpan(2):createText(budgetsuffix and (ConvertIntegerString(value, true, 0, true)  .. budgetsuffix) or "", config.standardTextProperties)

			local raceoptions = {}
			local n = C.GetNumAllRaces()
			local buf = ffi.new("RaceInfo[?]", n)
			n = C.GetAllRaces(buf, n)
			for i = 0, n - 1 do
				local id = ffi.string(buf[i].id)
				local name = ffi.string(buf[i].name)
				if C.CanPlayerUseRace(id, "aipilot") then
					table.insert(raceoptions, { id = id, text = name, icon = "", displayremoveoption = false })
				end
			end
			table.sort(raceoptions, function (a, b) return a.text < b.text end)
			table.insert(raceoptions, 1, { id = "any", text = ReadText(1001, 9930), icon = "", displayremoveoption = false })

			local row = ftable:addRow(entry.id, {  })
			row[2]:createText(ReadText(1001, 2428) .. ReadText(1001, 120), config.standardTextProperties)
			row[2].properties.x = row[2].properties.x + (iteration + 2) * config.standardTextHeight
			row[3]:setColSpan(2):createDropDown(raceoptions, { startOption = (manager.race and (manager.race ~= "")) and manager.race or "any", height = config.standardTextHeight })
			row[3].handlers.onDropDownConfirmed = function(_, raceid) if raceid == "any" then manager.race = "" else manager.race = raceid end; menu.setStationManager("playerproperty", entry.id, manager); menu.refreshMenu() end

			local numskills = C.GetNumSkills()
			local buf = ffi.new("SkillInfo[?]", numskills)
			numskills = C.GetSkills(buf, numskills)
			for i = 0, numskills - 1 do
				local id = ffi.string(buf[i].id)

				local row = ftable:addRow(entry.id, {  })
				if i == 0 then
					row[2]:createText(ReadText(1001, 1918) .. ReadText(1001, 120), config.standardTextProperties)
					row[2].properties.x = row[2].properties.x + (iteration + 2) * config.standardTextHeight
				end
				row[3]:setColSpan(2):createSliderCell({ height = config.standardTextHeight, valueColor = Color["slider_value"], min = 0, max = 15, start = manager.skills and manager.skills[id] or 0, step = 1 }):setText(ReadText(1013, buf[i].textid))
				row[3].handlers.onSliderCellChanged = function(_, newamount) if manager.skills then manager.skills[id] = newamount else manager.skills = { [id] = newamount } end; menu.setStationManager("playerproperty", entry.id, manager) end
				row[3].handlers.onSliderCellConfirm = menu.refreshMenu
			end
		end
		-- subordinates
		local row = ftable:addRow(nil, {  })
		row[2]:createText(ReadText(1001, 1503) .. ReadText(1001, 120), config.standardTextProperties)
		row[2].properties.x = row[2].properties.x + (iteration + 1) * config.standardTextHeight
		row[3]:setColSpan(2):createText((count == 1) and ReadText(1001, 7897) or string.format(ReadText(1001, 7898), count), config.standardTextProperties)

		local subcount = 0
		if menu.subordinates[entry.id] then
			subcount = #menu.subordinates[entry.id]
			for _, subentry in ipairs(menu.subordinates[entry.id]) do
				menu.displayPlayerPropertyEntry(ftable, subentry, iteration + 2)
			end
		end

		local row = ftable:addRow(true, {  })
		row[2]:setColSpan(3):createButton({ x = (iteration + 1) * config.standardTextHeight }):setText(ReadText(1001, 9920))
		row[2].handlers.onClick = function () return menu.openPlayerPropertyShipConfig(row.index, string.match(entry.id, "(.*)_%d+") .. "_sub" .. subcount, nil, entry.id) end

		ftable:addEmptyRow(config.standardTextHeight / 2)
	end
end

function menu.countPlayerProperty(id, count, moneybudget, peoplebudget, totalcount)
	totalcount = totalcount or 1
	if menu.subordinates[id] then
		for _, subentry in ipairs(menu.subordinates[id]) do
			count = count + totalcount * subentry.count
			moneybudget = moneybudget + subentry.budgetvalue["money"]
			peoplebudget = peoplebudget + subentry.budgetvalue["people"]
			count, moneybudget, peoplebudget = menu.countPlayerProperty(subentry.id, count, moneybudget, peoplebudget, totalcount * subentry.count)
		end
	end
	return count, moneybudget, peoplebudget
end

function menu.propertyColor(property)
	local modified
	if property.modifyingids then
		for _, modproperty in ipairs(property.modifyingids) do
			if C.IsCustomGameStartPropertyChanged(menu.customgamestart, modproperty) then
				modified = true
				break
			end
		end
	end

	if not modified then
		if property.propertyType ~= "Internal" then
			modified = C.IsCustomGameStartPropertyChanged(menu.customgamestart, property.id)
		else
			if property.id == "spacesuit" then
				modified = menu.usespacesuit == true
			end
		end
	end
	return modified and Color["customgamestart_property_changed"] or (((property.active == nil) or property.active()) and Color["text_normal"] or Color["text_inactive"])
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
	if col > 1 then
		for _, techentry in ipairs(menu.techtree[mainIdx][col - 1]) do
			if not techentry.completed then
				return false
			end
		end
	end
	return true
end

function menu.sortTechName(a, b)
	local aname = GetWareData(a.tech, "name")
	local bname = GetWareData(b.tech, "name")

	return aname < bname
end

function menu.expandNodeResearch(_, ftable, _, data)
	local description, researchtime = GetWareData(data.techdata.tech, "description", "researchtime")
	-- description
	local row = ftable:addRow(nil, { fixed = true })
	row[1]:setColSpan(2):createText(description .. "\n ", { wordwrap = true })
	-- select button
	local row = ftable:addRow(true, { fixed = true })

	local storyentry = menu.researchstoriesbyid[data.techdata.tech]
	row[1]:setColSpan(2):createButton({ mouseOverText = mouseovertext }):setText(data.techdata.completed and ReadText(1001, 9909) or ReadText(1001, 9908)):setText2(((storyentry and (storyentry.budgetvalue == 0)) or menu.creative) and ("[" .. ReadText(1001, 9903) .. "]") or "", { halign = "right" })
	row[1].handlers.onClick = function () menu.saveFlowchartState("flowchart", menu.flowchart); return menu.buttonSelectResearch(data.techdata, data.mainIdx, data.col) end
end

function menu.expandNodeCurrentFaction(_, ftable, _, data)
	-- ui range
	local row = ftable:addRow(true, { fixed = true })
	row[1]:setColSpan(2):createText(ReadText(1001, 9911) .. ReadText(1001, 120))
	-- faction selection
	local row = ftable:addRow(true, { fixed = true })

	local options = {}
	local currentOption = menu.currentfaction.id

	for _, factiondata in ipairs(menu.factions) do
		local allowedbystory = false
		if config.factionrelationsallowedbystory[factiondata.id] then
			for groupid, storyentry in pairs(menu.stories) do
				if config.factionrelationsallowedbystory[factiondata.id][storyentry.currentstory] then
					allowedbystory = true
					break
				end
			end
		end

		if menu.creative or ((not factiondata.isrelationlocked) or allowedbystory) then
			local name = factiondata.name
			if factiondata.id == "player" then
				local buf = ffi.new("CustomGameStartStringPropertyState[1]")
				name = ffi.string(C.GetCustomGameStartStringProperty(menu.customgamestart, "playername", buf))
			end
			table.insert(options, { id = factiondata.id, text = name, icon = "", displayremoveoption = false })
		end
	end

	row[1]:setColSpan(2):createDropDown(options, { startOption = currentOption, height = config.standardTextHeight })
	row[1].handlers.onDropDownConfirmed = menu.dropdownCurrentFaction
end

function menu.expandNodeFaction(_, ftable, _, data)
	ftable:setColWidth(1, config.standardTextHeight)

	-- ui range
	local row = ftable:addRow(true, { fixed = true })
	row[1]:setColSpan(2):createText(ReadText(1001, 9910) .. ReadText(1001, 120))
	-- slider
	local row = ftable:addRow(true, { fixed = true })
	row[1]:setColSpan(2):createSliderCell({ min = -30, max = 30, start = data.relation, step = 1, suffix = "", hideMaxValue = true, height = config.standardTextHeight })
	row[1].handlers.onSliderCellChanged = function (_, value) return menu.slidercellFaction(data.faction, value) end
	row[1].handlers.onSliderCellConfirm = function () menu.saveFlowchartState("flowchart", menu.flowchart); menu.restoreNodeFaction = data.faction.id; menu.refresh = getElapsedTime() end
	-- relation description
	local row = ftable:addRow(true, { fixed = true })
	row[1]:setColSpan(2):createText(function () return menu.relationText(data.relationFunction(), ftable.properties.width) end, { wordwrap = true })
	-- budget
	local budgetsuffix = menu.getBudgetSuffix("relations")
	if budgetsuffix then
		local relation = ffi.new("CustomGameStartRelationInfo")
		relation.factionid = Helper.ffiNewString(menu.currentfaction.id)
		relation.otherfactionid = Helper.ffiNewString(data.faction.id)
		relation.relation = data.relation

		local row = ftable:addRow(nil, { fixed = true })
		row[1]:setColSpan(2):createText(((data.relation ~= data.origRelation) and ConvertIntegerString(tonumber(C.GetCustomGameStartRelationsPropertyBudgetValue(menu.customgamestart, menu.category.id, relation)), true, 3, true) or 0) .. budgetsuffix)
	end
	-- known faction
	local knownentry
	for _, entry in ipairs(menu.knowndata) do
		if entry.id == "playerknownfactions" then
			knownentry = entry
		end
	end
	if (menu.currentfaction.id == "player") and knownentry and (knownentry.state ~= "") then
		local row = ftable:addRow(true, { fixed = true })
		local checked = menu.getKnownValue("playerknownfactions", data.faction.id)
		row[1]:createCheckBox(checked)
		row[1].handlers.onClick = function (_, checked) return menu.checkboxKnownFaction(data.faction.id, checked) end

		local budgetinfo = ""
		for _, budget in ipairs(menu.budgets) do
			if budget.id == "known" then
				if (not menu.creative) and C.HasCustomGameStartBudget(menu.customgamestart, "known") then
					budgetinfo = " " .. Helper.convertColorToText(budget.color) .. "\27[" .. budget.icon .. "]"
				end
				break
			end
		end

		row[2]:createText(ReadText(1001, 9912) .. budgetinfo, { color = function () return menu.isKnownValueItemChanged("playerknownfactions", data.faction.id) and Color["customgamestart_property_changed"] or Color["text_normal"] end })
	end
end

function menu.setFactionRelation(relations, faction, otherfaction, relation)
	if relations[faction] then
		relations[faction][otherfaction] = relation
	else
		relations[faction] = { [otherfaction] = relation }
	end
	if relations[otherfaction] then
		relations[otherfaction][faction] = relation
	else
		relations[otherfaction] = { [faction] = relation }
	end
end

function menu.removeFactionRelation(relations, faction, otherfaction)
	if relations[faction] then
		relations[faction][otherfaction] = nil
		relations[otherfaction][faction] = nil
	end
end

function menu.relationText(relation, width)
	local text = ffi.string(C.GenerateFactionRelationTextFromRelation(relation))
	local lines = GetTextLines(text, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), width)
	local maxlines = GetTextLines(ReadText(20218, 705) .. "\n" .. ReadText(20218, 805) .. "\n" .. ReadText(20218, 1005), Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), width)
	for i = 1, #maxlines - #lines do
		if i == 1 then
			-- we need to add one extra line break, iff we need to add line breaks at all
			text = text .. "\n"
		end
		text = text .. "\n"
	end
	return text
end

function menu.initEncyclopediaValue()
	menu.encyclopedia = { id = "playerencyclopedia", entries = {} }
	local state = C.GetCustomGameStartEncyclopediaPropertyState(menu.customgamestart, menu.encyclopedia.id)
	menu.encyclopedia.state = ffi.string(state.state)

	local n = C.GetCustomGameStartEncyclopediaPropertyCounts(menu.customgamestart, menu.encyclopedia.id)
	local buf = ffi.new("CustomGameStartEncyclopediaEntry[?]", n)
	n = C.GetCustomGameStartEncyclopediaProperty(buf, n, menu.customgamestart, menu.encyclopedia.id)
	for i = 0, n - 1 do
		local library = ffi.string(buf[i].library)
		local item = ffi.string(buf[i].item)
		if menu.encyclopedia.entries[library] then
			menu.encyclopedia.entries[library][item] = { value = true, origValue = true }
		else
			menu.encyclopedia.entries[library] = { [item] = { value = true, origValue = true } }
		end
	end
end

function menu.getEncyclopediaValue(library, item)
	if menu.encyclopedia.entries[library] then
		if menu.encyclopedia.entries[library][item] then
			return menu.encyclopedia.entries[library][item].value
		end
	end
	return false
end

function menu.setEncyclopediaValue(library, item, value)
	if menu.encyclopedia.entries[library] then
		if menu.encyclopedia.entries[library][item] then
			menu.encyclopedia.entries[library][item].value = value
		else
			menu.encyclopedia.entries[library][item] = { value = value, origValue = false }
		end
	else
		menu.encyclopedia.entries[library] = { [item] = { value = value, origValue = false } }
	end
end

function menu.isEncyclopediaValueItemChanged(checklibrary, checkitem)
	for library, data in pairs(menu.encyclopedia.entries) do
		if library == checklibrary then
			for item, entry in pairs(data) do
				if item == checkitem then
					if entry.value ~= entry.origValue then
						return true
					end
				end
			end
		end
	end
	return false
end

function menu.saveEncyclopediaValue()
	local encyclopedialist = {}
	for library, data in pairs(menu.encyclopedia.entries) do
		for item, entry in pairs(data) do
			if entry.value then
				table.insert(encyclopedialist, { library = library, item = item })
			end
		end
	end

	local encyclopedia = ffi.new("CustomGameStartEncyclopediaEntry[?]", #encyclopedialist)
	for i, entry in ipairs(encyclopedialist) do
		encyclopedia[i - 1].library = Helper.ffiNewString(entry.library)
		encyclopedia[i - 1].item = Helper.ffiNewString(entry.item)
	end

	C.SetCustomGameStartEncyclopediaProperty(menu.customgamestart, menu.encyclopedia.id, encyclopedia, #encyclopedialist)
	Helper.ffiClearNewHelper()
end

function menu.initKnownValue()
	menu.knowndata = {
		[1] = { id = "playerknownfactions", entries = {} },
		[2] = { id = "playerknownobjects", entries = {} },
		[3] = { id = "playerknownspace", entries = {} },
	}
	for _, entry in ipairs(menu.knowndata) do
		local state = C.GetCustomGameStartKnownPropertyState(menu.customgamestart, entry.id)
		entry.state = ffi.string(state.state)

		local n = state.numvalues
		local buf = ffi.new("CustomGameStartKnownEntry2[?]", n)
		n = C.GetCustomGameStartKnownProperty2(buf, n, menu.customgamestart, entry.id)
		for i = 0, n - 1 do
			local item = ffi.string(buf[i].item)
			entry.entries[item] = { value = true, origValue = true, budgetvalue = tonumber(buf[i].budgetvalue) }
		end
	end
end

function menu.getKnownValue(property, item)
	local found = false
	for _, entry in ipairs(menu.knowndata) do
		if entry.id == property then
			found = true
			if entry.entries[item] then
				return entry.entries[item].value, entry.entries[item].budgetvalue
			end
		end
	end
	if not found then
		DebugError("menu.getKnownValue(): Trying to access unknown known property '" .. property .. "'.")
	end
	return false, 0
end

function menu.setKnownValue(property, item, value)
	local found = false
	for _, entry in ipairs(menu.knowndata) do
		if entry.id == property then
			found = true
			if entry.entries[item] then
				entry.entries[item].value = value
			else
				local knownitem = ffi.new("CustomGameStartKnownEntry2")
				if entry.id == "playerknownfactions" then
					knownitem.type = Helper.ffiNewString("faction")
					knownitem.item = Helper.ffiNewString(item)
				elseif entry.id == "playerknownobjects" then
					knownitem.type = Helper.ffiNewString("sector")
					knownitem.item = Helper.ffiNewString(item)
					knownitem.classid = "station"
				elseif entry.id == "playerknownspace" then
					knownitem.type = Helper.ffiNewString("sector")
					knownitem.item = Helper.ffiNewString(item)
				end
				local valid = C.GetCustomGameStartKnownPropertyBudgetValue2(menu.customgamestart, entry.id, knownitem)
				entry.entries[item] = { value = value, origValue = false, budgetvalue = valid and tonumber(knownitem.budgetvalue) or 0 }
			end
		end
	end
	if not found then
		DebugError("menu.setKnownValue(): Trying to access unknown known property '" .. property .. "'.")
	end
end

function menu.isKnownValueItemChanged(property, checkitem)
	local found = false
	for _, knownentry in ipairs(menu.knowndata) do
		if knownentry.id == property then
			found = true
			for item, entry in pairs(knownentry.entries) do
				if item == checkitem then
					if entry.value ~= entry.origValue then
						return true
					end
				end
			end
		end
	end
	if not found then
		DebugError("menu.isKnownValueItemChanged(): Trying to access unknown known property '" .. property .. "'.")
	end
	return false
end

function menu.saveKnownValue(property)
	local found = false
	local knownlist = {}
	for _, knownentry in ipairs(menu.knowndata) do
		if knownentry.id == property then
			found = true
			for item, entry in pairs(knownentry.entries) do
				if entry.value then
					table.insert(knownlist, { item = item })
				end
			end
		end
	end
	if not found then
		DebugError("menu.saveKnownValue(): Trying to access unknown known property '" .. property .. "'.")
		return
	end

	local knownitems = ffi.new("CustomGameStartKnownEntry2[?]", #knownlist)
	for i, entry in ipairs(knownlist) do
		if property == "playerknownfactions" then
			knownitems[i - 1].type = Helper.ffiNewString("faction")
			knownitems[i - 1].item = Helper.ffiNewString(entry.item)
		elseif property == "playerknownobjects" then
			knownitems[i - 1].type = Helper.ffiNewString("sector")
			knownitems[i - 1].item = Helper.ffiNewString(entry.item)
			knownitems[i - 1].classid = "station"
		elseif property == "playerknownspace" then
			knownitems[i - 1].type = Helper.ffiNewString("sector")
			knownitems[i - 1].item = Helper.ffiNewString(entry.item)
		end
	end

	C.SetCustomGameStartKnownProperty2(menu.customgamestart, property, knownitems, #knownlist)
	Helper.ffiClearNewHelper()
end

function menu.initStoryValue()
	menu.storiesbyid = {}
	menu.stories = {}
	local n = C.GetNumCustomGameStartStoryBudgets(menu.customgamestart)
	local buf = ffi.new("CustomGameStartStoryInfo[?]", n)
	n = C.GetCustomGameStartStoryBudgets(buf, n, menu.customgamestart)
	for i = 0, n - 1 do
		local groupid = ffi.string(buf[i].groupid)
		local storyid = ffi.string(buf[i].id)

		local dependencies = {}
		local dependencylist_lenghts = {}
		local numdependencies = 0
		local dependencylists_buf = ffi.new("uint32_t[?]", buf[i].numdependencylists)
		local numdependencylists = C.GetNumCustomGameStartStoryBudgetDependencyLists(dependencylists_buf, buf[i].numdependencylists, menu.customgamestart, storyid);
		for j = 0, numdependencylists - 1 do
			local count = dependencylists_buf[j]
			numdependencies = numdependencies + count
			table.insert(dependencylist_lenghts, count)
		end
		local dependencies_buf = ffi.new("const char*[?]", numdependencies)
		numdependencies = C.GetCustomGameStartStoryBudgetDependencies(dependencies_buf, numdependencies, menu.customgamestart, storyid)
		local idx = 1
		for j = 0, numdependencies - 1 do
			while dependencylist_lenghts[1] and (dependencylist_lenghts[1] <= 0) do
				idx = idx + 1
				table.remove(dependencylist_lenghts, 1)
			end
			if #dependencylist_lenghts == 0 then
				DebugError("Dependency list counts and number of dependencies do not match - aborting.")
				break
			end

			if dependencies[idx] then
				table.insert(dependencies[idx], ffi.string(dependencies_buf[j]))
			else
				dependencies[idx] = { ffi.string(dependencies_buf[j]) }
			end
			dependencylist_lenghts[1] = dependencylist_lenghts[1] - 1
		end

		local entry = {
			id = storyid,
			name = ffi.string(buf[i].name),
			description = ffi.string(buf[i].description),
			index = buf[i].index,
			budgetvalue = buf[i].budgetvalue,
			dependencies = dependencies,
		}
		menu.storiesbyid[storyid] = entry

		local groupinfo = C.GetCustomGameStartBudgetGroupInfo(menu.customgamestart, groupid)
		if groupinfo.isresearch then
			local wareid = ffi.string(buf[i].wareid)
			menu.researchstoriesbyid[wareid] = entry
		end

		if menu.stories[groupid] then
			table.insert(menu.stories[groupid].entries, entry)
		else
			menu.stories[groupid] = {
				currentstory = "",
				defaultstory = "",
				entries = { entry },
			}
		end
	end

	menu.storygroups = {}
	local n = C.GetNumCustomGameStartBudgetGroups(menu.customgamestart)
	local buf = ffi.new("const char*[?]", n)
	n = C.GetCustomGameStartBudgetGroups(buf, n, menu.customgamestart)
	for i = 0, n - 1 do
		local groupid = ffi.string(buf[i])
		table.insert(menu.storygroups, groupid)
	end

	local storyproperties = { "universestorystates" }
	for _, id in ipairs(storyproperties) do
		local state = C.GetCustomGameStartStoryPropertyState(menu.customgamestart, id)
		local currentstories = {}
		local buf = ffi.new("const char*[?]", state.numvalues)
		local n = C.GetCustomGameStartStoryProperty(buf, state.numvalues, menu.customgamestart, id)
		for i = 0, n - 1 do
			local storyid = ffi.string(buf[i])
			currentstories[storyid] = true
		end

		local defaultstories = {}
		local buf = ffi.new("const char*[?]", state.numdefaultvalues)
		local n = C.GetCustomGameStartStoryDefaultProperty(buf, state.numdefaultvalues, menu.customgamestart, id)
		for i = 0, n - 1 do
			local storyid = ffi.string(buf[i])
			defaultstories[storyid] = true
		end

		for groupid, storyentry in pairs(menu.stories) do
			if groupid ~= "research" then
				for _, story in ipairs(storyentry.entries) do
					if currentstories[story.id] then
						menu.stories[groupid].currentstory = story.id
					end
					if defaultstories[story.id] then
						menu.stories[groupid].defaultstory = story.id
					end
				end
			end
		end
	end

	menu.initResearch()
end

function menu.initResearch()
	local research = {}
	local n = C.GetCustomGameStartResearchPropertyCounts(menu.customgamestart, "playerresearch")
	local buf = ffi.new("const char*[?]", n)
	n = C.GetCustomGameStartResearchProperty(buf, n, menu.customgamestart, "playerresearch")
	for i = 0, n - 1 do
		research[ffi.string(buf[i])] = true
	end

	menu.techtree = {}
	-- Get all research wares from the WareDB.
	local numtechs = C.GetNumWares("", true, "", "hidden nocustomgamestart")
	local rawtechlist = ffi.new("const char*[?]", numtechs)
	local temptechlist = {}
	numtechs = C.GetWares(rawtechlist, numtechs, "", true, "", "hidden nocustomgamestart")
	for i = 0, numtechs - 1 do
		table.insert(temptechlist, ffi.string(rawtechlist[i]))
	end
	-- NB: don't really need to sort at this point, but will help the entries in the menu stay consistent.
	table.sort(temptechlist, Helper.sortWareSortOrder)

	--print("searching for wares without precursor")
	for i = #temptechlist, 1, -1 do
		local techprecursors, sortorder = GetWareData(temptechlist[i], "researchprecursors", "sortorder")
		if #techprecursors == 0 then
			if not GetWareData(temptechlist[i], "ismissiononly") then
				--print("found " .. temptechlist[i])
				local completed = research[temptechlist[i]] or false
				table.insert(menu.techtree, { [1] = { [1] = { tech = temptechlist[i], sortorder = sortorder, completed = completed, origCompleted = completed } } })
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
				local completed = research[temptechlist[i]] or false
				table.insert(menu.techtree, { [1] = { [1] = { tech = temptechlist[i], sortorder = sortorder, completed = completed, origCompleted = completed } } })
				table.remove(temptechlist, i)
			end
		end
	end

	--print("\ngoing through remaining wares")
	local loopcounter = 0
	local idx = 1
	while #temptechlist > 0 do
		--print("looking at: " .. temptechlist[idx])
		local techprecursors, sortorder = GetWareData(temptechlist[idx], "researchprecursors", "sortorder")
		--print("    #precusors: " .. #techprecursors)
		local precursordata = {}
		local smallestMainIdx, foundPrecusorCol
		-- try to find all precusors in existing data
		for i, precursor in ipairs(techprecursors) do
			local mainIdx, precursorCol = menu.findTech(menu.techtree, precursor)
			--print("    precusor " .. precursor .. ": " .. tostring(mainIdx) .. ", " .. tostring(precursorCol))
			if mainIdx and ((not smallestMainIdx) or (smallestMainIdx > mainIdx)) then
				smallestMainIdx = mainIdx
				foundPrecusorCol = precursorCol
			end
			precursordata[i] = { mainIdx = mainIdx, precursorCol = precursorCol }
		end
		-- sort so that highest index comes first - important for deletion order and keeping smallestMainIdx valid
		table.sort(precursordata, menu.precursorSorter)

		if smallestMainIdx then
			--print("    smallestMainIdx: " .. smallestMainIdx .. ", foundPrecusorCol: " .. foundPrecusorCol)
			-- fix wares without precursors that there wrongly placed in different main entries
			for i, entry in ipairs(precursordata) do
				if entry.mainIdx and (entry.mainIdx ~= smallestMainIdx) then
					--print("    precusor " .. techprecursors[i] .. " @ " .. entry.mainIdx .. " ... merging")
					for col, columndata in ipairs(menu.techtree[entry.mainIdx]) do
						for techidx, techentry in ipairs(columndata) do
							--print("    adding menu.techtree[" .. entry.mainIdx .. "][" .. col .. "][" .. techidx .. "] to menu.techtree[" .. smallestMainIdx .. "][" .. col .. "]")
							table.insert(menu.techtree[smallestMainIdx][col], techentry)
						end
					end
					--print("    removing mainIdx " .. entry.mainIdx)
					table.remove(menu.techtree, entry.mainIdx)
				end
			end

			-- add this tech to the tree and remove it from the list
			local completed = research[temptechlist[idx]] or false
			if menu.techtree[smallestMainIdx][foundPrecusorCol + 1] then
				--print("    adding")
				table.insert(menu.techtree[smallestMainIdx][foundPrecusorCol + 1], { tech = temptechlist[idx], sortorder = sortorder, completed = completed, origCompleted = completed })
			else
				--print("    new entry")
				menu.techtree[smallestMainIdx][foundPrecusorCol + 1] = { [1] = { tech = temptechlist[idx], sortorder = sortorder, completed = completed, origCompleted = completed } }
			end
			--print("    removed")
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

	menu.researchstories = {}
	for i, mainentry in ipairs(menu.techtree) do
		for col, columnentry in ipairs(mainentry) do
			for j, techentry in ipairs(columnentry) do
				techentry.completed = techentry.origCompleted
				if menu.researchstoriesbyid[techentry.tech] then
					menu.researchstories[menu.researchstoriesbyid[techentry.tech].id] = techentry.completed or nil
				end
			end
		end
	end
end

function menu.saveStoryValue(property)
	local storylist = {}
	for _, data in pairs(menu.stories) do
		if data.currentstory ~= "" then
			table.insert(storylist, data.currentstory)
		end
	end
	for story in pairs(menu.researchstories) do
		table.insert(storylist, story)
	end

	local stories = ffi.new("const char*[?]", #storylist)
	for i, story in ipairs(storylist) do
		stories[i - 1] = Helper.ffiNewString(story)
	end

	C.SetCustomGameStartStory(menu.customgamestart, property, stories, #storylist)
	Helper.ffiClearNewHelper()
end

function menu.initSatellites()
	local state = C.GetCustomGameStartPlayerPropertyPropertyState(menu.customgamestart, "playerproperty")
	if state.numvalues > 0 then
		local counts = ffi.new("CustomGameStartPlayerPropertyCounts[?]", state.numvalues)
		local n = C.GetCustomGameStartPlayerPropertyCounts(counts, state.numvalues, menu.customgamestart, "playerproperty")
		if n > 0 then
			local buf = ffi.new("CustomGameStartPlayerProperty3[?]", n)
			for i = 0, n - 1 do
				buf[i].numcargo = counts[i].numcargo
				buf[i].cargo = Helper.ffiNewHelper("UIWareInfo[?]", counts[i].numcargo)
			end
			n = C.GetCustomGameStartPlayerPropertyProperty3(buf, n, menu.customgamestart, "playerproperty")
			for i = 0, n - 1 do
				if (ffi.string(buf[i].type) == "object") and (ffi.string(buf[i].macroname) == config.satellites.macro) then
					local id = ffi.string(buf[i].id)
					local sector = ffi.string(buf[i].sector)

					menu.satellites[sector] = menu.satellites[sector] or { totalvalue = 0 }
					table.insert(menu.satellites[sector], id)
					menu.satellites[sector].totalvalue = menu.satellites[sector].totalvalue + tonumber(C.GetCustomGameStartPlayerPropertyValue(menu.customgamestart, "playerproperty", id))
				end
			end
		end
	end
end

function menu.initFactions()
	if #menu.factions == 0 then
		local value = {}
		local n = C.GetCustomGameStartRelationsPropertyCounts(menu.customgamestart, "universefactionrelations")
		local buf = ffi.new("CustomGameStartRelationInfo[?]", n)
		n = C.GetCustomGameStartRelationsProperty(buf, n, menu.customgamestart, "universefactionrelations")
		for i = 0, n - 1 do
			menu.setFactionRelation(value, ffi.string(buf[i].factionid), ffi.string(buf[i].otherfactionid), buf[i].relation)
		end

		-- all factions
		local tempfactionlist = {}
		local n = C.GetNumAllFactions(false)
		local buf = ffi.new("const char*[?]", n)
		n = C.GetAllFactions(buf, n, false)
		for i = 0, n - 1 do
			local id = ffi.string(buf[i])
			local isrelationlocked = GetFactionData(id, "isrelationlocked")
			if (id ~= "player") and (menu.creative or ((not isrelationlocked) or config.factionrelationsallowedbystory[id])) then
				table.insert(tempfactionlist, { id = id, name = GetFactionData(id, "name"), isrelationlocked = isrelationlocked })
			end
		end
		table.sort(tempfactionlist, Helper.sortName)
		-- player faction in front
		local buf = ffi.new("CustomGameStartStringPropertyState[1]")
		local name = ffi.string(C.GetCustomGameStartStringProperty(menu.customgamestart, "playername", buf))
		table.insert(tempfactionlist, 1, { id = "player", name = name })
		-- create relation structure
		for _, entry in ipairs(tempfactionlist) do
			local relations = {}
			for _, entry2 in ipairs(tempfactionlist) do
				local relation = C.GetUIDefaultBaseRelation(entry.id, entry2.id)
				local origRelation = relation
				if value[entry.id] and value[entry.id][entry2.id] then
					origRelation = value[entry.id][entry2.id]
				end
				table.insert(relations, { id = entry2.id, name = entry2.name, isrelationlocked = entry2.isrelationlocked, relation = relation, origRelation = origRelation })
			end
			table.insert(menu.factions, { id = entry.id, name = entry.name, isrelationlocked = entry.isrelationlocked, relations = relations })
			if #menu.factions == 1 then
				menu.currentfaction = menu.factions[1]
			end
		end
	end
end

function menu.displayInit()
	if menu.flowchart then
		menu.flowchart:collapseAllNodes()
		menu.flowchart = nil
	end
	-- remove old data
	Helper.clearDataForRefresh(menu)
	menu.selectedOption = nil

	menu.mainFrame = Helper.createFrameHandle(menu, {
		x = 0,
		y = 0,
		width = Helper.viewWidth,
		height = Helper.viewHeight,
		standardButtons = {},
		playerControls = false,
		layer = config.mainFrameLayer,
	})

	local ftable = menu.mainFrame:addTable(1, { tabOrder = 0, width = math.floor(Helper.viewWidth / 2), x = math.floor(Helper.viewWidth / 4), y = math.floor(Helper.viewHeight / 2) })

	local row = ftable:addRow(false, { fixed = true })
	row[1]:createText(ReadText(1001, 7230), { halign = "center", font = config.fontBold, fontsize = config.headerFontSize, x = 0, y = 0 })

	ftable.properties.y = math.floor((Helper.viewHeight - ftable:getVisibleHeight()) / 2)

	menu.mainFrame:display()

	menu.cleanup()
end

function menu.refreshMenu()
	menu.topRows.categoryTable = GetTopRow(menu.categoryTable.id)
	menu.selectedRows.categoryTable = Helper.currentTableRow[menu.categoryTable.id]
	if menu.propertyTable then
		menu.topRows.propertyTable = GetTopRow(menu.propertyTable.id)
		menu.selectedRows.propertyTable = Helper.currentTableRow[menu.propertyTable.id]
	end
	menu.display()
end

function menu.onRowChanged(row, rowdata, uitable, modified, input, source)
	row = row or Helper.currentTableRow[uitable]
	if uitable == menu.categoryTable.id then
		if input == "mouse" then
			local category = menu.rowDataMap[uitable][row]
			if category ~= menu.category then
				if (not category.active) or category.active() then
					menu.setCategory(category)
					menu.refresh = getElapsedTime()
				end
			end
		end
	elseif uitable == menu.propertyTable.id then
		if menu.category.type == "property" then
			if type(rowdata) == "string" then
				menu.category.selectedEntry = rowdata
				if menu.holomap ~= 0 then
					C.SetMacroMapSelection(menu.holomap, false, menu.category.selectedEntry)
				end
			else
				menu.category.selectedEntry = nil
				if menu.holomap ~= 0 then
					C.SetMacroMapSelection(menu.holomap, false, "")
				end
			end
		elseif menu.category.type == "list" then
			local newproperty = menu.rowDataMap[uitable][row]
			if newproperty.displayOnRenderTarget or (menu.category.selectedProperty and menu.category.selectedProperty.displayOnRenderTarget) then
				if menu.cutsceneid then
					StopCutscene(menu.cutsceneid)
					menu.cutsceneid = nil
					DestroyPresentationCluster(menu.precluster)
				end
				if menu.holomap ~= 0 then
					C.RemoveHoloMap()
					menu.holomap = 0
				end
				menu.rendertargetLock = getElapsedTime() + 0.1
			end
			menu.category.selectedProperty = newproperty
		end
	end
end

function menu.onSelectElement(uitable, modified, row)
	row = row or Helper.currentTableRow[uitable]
	if uitable == menu.categoryTable.id then
		local category = menu.rowDataMap[uitable][row]
		if category ~= menu.category then
			if (not category.active) or category.active() then
				menu.setCategory(category)
				menu.refresh = getElapsedTime()
			end
		end
	end
end

menu.updateInterval = 0.01
function menu.onUpdate()
	local curtime = getElapsedTime()
	if menu.refresh and (menu.refresh < curtime) then
		menu.refreshMenu()
		menu.refresh = nil
		return
	end

	if menu.shownPropertyHint and (menu.shownPropertyHint > 0) and (menu.shownPropertyHint + 10 < curtime) then
		menu.shownPropertyHint = -1
		menu.closeContextMenu()
	end

	if menu.showHighlightOverlay then
		ShowHighlightOverlay(menu.showHighlightOverlay)
		menu.showHighlightOverlay = nil
	end

	if menu.rendertarget and menu.holomap ~= 0 then
		local x, y = GetRenderTargetMousePosition(menu.rendertarget.id)
		C.SetMapRelativeMousePosition(menu.holomap, (x and y) ~= nil, x or 0, y or 0)
	end

	if menu.category.rendertarget then
		if menu.rendertarget then
			local rendertargetTexture = GetRenderTargetTexture(menu.rendertarget.id)
			if rendertargetTexture then
				if (not menu.cutsceneid) and (menu.holomap == 0) and ((not menu.rendertargetLock) or (menu.rendertargetLock < getElapsedTime())) then
					menu.rendertargetLock = nil
					if menu.category.type == "property" then
						if menu.holomap == 0 then
							local renderX0, renderX1, renderY0, renderY1 = Helper.getRelativeRenderTargetSize(menu, config.mainFrameLayer, menu.rendertarget.id)
							local buf = ffi.new("CustomGameStartStringPropertyState[1]")
							local galaxymacro = ffi.string(C.GetCustomGameStartStringProperty(menu.customgamestart, "galaxy", buf))
							local sectormacro = ffi.string(C.GetCustomGameStartStringProperty(menu.customgamestart, "sector", buf))
							local buf2 = ffi.new("CustomGameStartPosRotPropertyState[1]")
							local sectoroffset = C.GetCustomGameStartPosRotProperty(menu.customgamestart, "offset", buf2)
							-- pass relative screenspace of the holomap rendertarget to the holomap (value range = -1 .. 1)
							menu.holomap = C.AddHoloMap(rendertargetTexture, renderX0, renderX1, renderY0, renderY1, menu.renderTargetWidth / menu.renderTargetHeight, 1)

							C.ShowUniverseMacroMap2(menu.holomap, galaxymacro, sectormacro, sectoroffset, true, false, menu.customgamestart)
							C.SetMacroMapSelection(menu.holomap, false, menu.category.selectedEntry or "")
						end
					else
						local currentproperty = menu.category.selectedProperty or {}
						local mode = menu.category.displayOnRenderTarget[1]
						local modeproperty
						for _, property in ipairs(menu.category.properties) do
							if property.displayOnRenderTarget and (property.id == currentproperty.id) then
								mode = property.displayOnRenderTarget
								modeproperty = property
								break
							elseif property.id == menu.category.displayOnRenderTarget[2] then
								modeproperty = property
							end
						end

						if mode == "macro" then
							if not menu.cutsceneid then
								local buf = ffi.new("CustomGameStart" .. modeproperty.propertyType .. "PropertyState[1]")
								local renderobject = ffi.string(modeproperty.get(menu.customgamestart, modeproperty.id, buf))
								if renderobject then
									menu.precluster, menu.preobject = CreateObjectInPresentationCluster(renderobject, "cluster_black_wlight_bg_macro")
									if menu.preobject then
										if IsComponentClass(menu.preobject, "object") then
											local buf = ffi.new("CustomGameStartStringPropertyState[1]")
											local painttheme = ffi.string(C.GetCustomGameStartStringProperty(menu.customgamestart, "playerpainttheme", buf))
											local paintmod = ffi.new("UIPaintMod")
											if C.GetPaintThemeMod(painttheme, "player", paintmod) then
												C.InstallPaintMod(ConvertIDTo64Bit(menu.preobject), ffi.string(paintmod.Ware), false)
											end
										end

										menu.cutscenedesc = CreateCutsceneDescriptor("OrbitIndefinitelySlow", { targetobject = menu.preobject })
										menu.cutsceneid = StartCutscene(menu.cutscenedesc, rendertargetTexture)

										if not menu.cutsceneNotification then
											NotifyOnCutsceneReady(getElement("Scene.UIContract"))
											NotifyOnCutsceneStopped(getElement("Scene.UIContract"))
										end
									end
								end
							end
						elseif mode == "npc" then
							if not menu.cutsceneid then
								local buf = ffi.new("CustomGameStart" .. modeproperty.propertyType .. "PropertyState[1]")
								local playermacro = ffi.string(modeproperty.get(menu.customgamestart, modeproperty.id, buf))
								local renderobject = menu.playerMacros[playermacro]
								if renderobject and (renderobject ~= "") then
									menu.precluster, menu.prenpc = CreateObjectInPresentationCluster(renderobject, "cluster_black_wlight_bg_macro")
									if menu.prenpc then
										local cutscenekey = GetComponentData(menu.prenpc, "npcfacecutscenekey")
										if cutscenekey then
											menu.cutscenedesc = CreateCutsceneDescriptor(cutscenekey, { npcref = menu.prenpc })
											menu.cutsceneid = StartCutscene(menu.cutscenedesc, rendertargetTexture)
											
											if not menu.cutsceneNotification then
												NotifyOnCutsceneReady(getElement("Scene.UIContract"))
												NotifyOnCutsceneStopped(getElement("Scene.UIContract"))
											end
										end
									end
								end
							end
						elseif mode == "map" then
							if menu.holomap == 0 then
								local renderX0, renderX1, renderY0, renderY1 = Helper.getRelativeRenderTargetSize(menu, config.mainFrameLayer, menu.rendertarget.id)
								local buf = ffi.new("CustomGameStartStringPropertyState[1]")
								local galaxymacro = ffi.string(C.GetCustomGameStartStringProperty(menu.customgamestart, "galaxy", buf))
								local sectormacro = ffi.string(C.GetCustomGameStartStringProperty(menu.customgamestart, "sector", buf))
								local buf2 = ffi.new("CustomGameStartPosRotPropertyState[1]")
								local sectoroffset = C.GetCustomGameStartPosRotProperty(menu.customgamestart, "offset", buf2)
								-- pass relative screenspace of the holomap rendertarget to the holomap (value range = -1 .. 1)
								menu.holomap = C.AddHoloMap(rendertargetTexture, renderX0, renderX1, renderY0, renderY1, menu.renderTargetWidth / menu.renderTargetHeight, 1)
								C.ShowUniverseMacroMap2(menu.holomap, galaxymacro, sectormacro, sectoroffset, true, false, menu.customgamestart)
								C.SetMacroMapSelection(menu.holomap, true, "")
							end
						elseif mode == "painttheme" then
							local renderobject
							if not menu.usespacesuit then
								local buf = ffi.new("CustomGameStartStringPropertyState[1]")
								renderobject = ffi.string(modeproperty.get(menu.customgamestart, "ship", buf))
							else
								renderobject = config.fallbackShipMacro
							end

							if renderobject then
								menu.precluster, menu.preobject = CreateObjectInPresentationCluster(renderobject, "cluster_black_wlight_bg_macro")
								if menu.preobject then
									if IsComponentClass(menu.preobject, "object") then
										local buf = ffi.new("CustomGameStartStringPropertyState[1]")
										local painttheme = ffi.string(C.GetCustomGameStartStringProperty(menu.customgamestart, "playerpainttheme", buf))
										local paintmod = ffi.new("UIPaintMod")
										if C.GetPaintThemeMod(painttheme, "player", paintmod) then
											C.InstallPaintMod(ConvertIDTo64Bit(menu.preobject), ffi.string(paintmod.Ware), false)
										end
									end

									menu.cutscenedesc = CreateCutsceneDescriptor("OrbitIndefinitelySlow", { targetobject = menu.preobject })
									menu.cutsceneid = StartCutscene(menu.cutscenedesc, rendertargetTexture)

									if not menu.cutsceneNotification then
										NotifyOnCutsceneReady(getElement("Scene.UIContract"))
										NotifyOnCutsceneStopped(getElement("Scene.UIContract"))
									end
								end
							end
						end
					end
				end
			end
		end
	end

	if menu.rightdown then
		if not menu.rightdown.wasmoved then
			local offset = table.pack(GetLocalMousePosition())
			if Helper.comparePositions(menu.rightdown.position, offset, 5) then
				menu.rightdown.wasmoved = true
			end
		end
	end

	if menu.restoreNode and menu.restoreNode.id then
		menu.restoreNode:expand()
		menu.restoreNode = nil
	end

	menu.mainFrame:update()
	if menu.expandedMenuFrame then
		menu.expandedMenuFrame:update()
	end
	if menu.contextFrame then
		menu.contextFrame:update()
	end
end

function menu.onRenderTargetSelect(modified)
	menu.closeContextMenu()

	local offset = table.pack(GetLocalMousePosition())
	-- Check if the mouse button was down less than 0.5 seconds and the mouse was moved more than a distance of 5px
	if (not menu.leftdown) or ((menu.leftdown.time + 0.5 > getElapsedTime()) and not Helper.comparePositions(menu.leftdown.position, offset, 5)) then
		if menu.holomap ~= 0 then
			local sectorpos = ffi.new("UIPosRot")
			local sectormacro = ffi.string(C.GetMacroMapPositionOnEcliptic(menu.holomap, sectorpos))
			if sectormacro ~= "" then
				if menu.category.id == "universe" then
					for _, property in ipairs(menu.category.properties) do
						if property.id == "sector" then
							property.value = sectormacro
							property.set(menu.customgamestart, property.id, property.value, true)
							menu.setKnownValue("playerknownspace", sectormacro, true)
							menu.saveKnownValue("playerknownspace")
						elseif property.id == "offset" then
							property.value = sectorpos
							property.set(menu.customgamestart, property.id, property.value)
						end
					end
				elseif menu.category.id == "playerproperty" then
					if menu.category.selectedEntry then
						C.SetCustomGameStartPlayerPropertySectorAndOffset(menu.customgamestart, menu.category.id, menu.category.selectedEntry, sectormacro, sectorpos)
						menu.setKnownValue("playerknownspace", sectormacro, true)
						menu.saveKnownValue("playerknownspace")
					end
				end
				menu.refreshMenu()
			end
		end
	end
	menu.leftdown = nil
end

-- rendertarget mouse input helper
function menu.onRenderTargetMouseDown(modified)
	menu.leftdown = { time = getElapsedTime(), position = table.pack(GetLocalMousePosition()), dynpos = table.pack(GetLocalMousePosition()) }
	
	if menu.holomap ~= 0 then
		C.StartPanMap(menu.holomap)
		menu.panningmap = { isclick = true }
	end
end

function menu.onRenderTargetMouseUp(modified)
	if menu.panningmap then
		if menu.holomap ~= 0 then
			C.StopPanMap(menu.holomap)
		end
		menu.panningmap = nil
	end
end

function menu.onRenderTargetCombinedScrollDown(step)
	if menu.holomap ~= 0 then
		C.ZoomMap(menu.holomap, step)
	end
end

function menu.onRenderTargetCombinedScrollUp(step)
	if menu.holomap ~= 0 then
		C.ZoomMap(menu.holomap, -step)
	end
end

function menu.onRenderTargetRightMouseDown()
	menu.closeContextMenu()
	menu.rightdown = { time = getElapsedTime(), position = table.pack(GetLocalMousePosition()), dynpos = table.pack(GetLocalMousePosition()) }
end

function menu.onRenderTargetRightMouseUp(modified)
	local offset = table.pack(GetLocalMousePosition())

	-- Check if the mouse was moved more than a distance of 5px
	if menu.rightdown and (not Helper.comparePositions(menu.rightdown.position, offset, 5)) and (not menu.rightdown.wasmoved) then
		if menu.holomap ~= 0 then
			local sectorpos = ffi.new("UIPosRot")
			local sectormacro = ffi.string(C.GetMacroMapPositionOnEcliptic(menu.holomap, sectorpos))
		
			if menu.category.id == "universe" then
				menu.displayMapContext(offset, sectormacro, sectorpos)
			end
		end
	end
	menu.rightdown = nil
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

function menu.onPropertyDropDownActivated(property, row, dropdown)
	SelectRow(menu.propertyTable.id, row)
end

function menu.closeContextMenu(skiprefresh)
	if menu.contextMenu then
		menu.contextTable = nil
		menu.contextFrame = nil
		Helper.clearFrame(menu, config.contextFrameLayer)
		menu.contextMenuData = {}
		menu.contextMenu = nil
		if (not skiprefresh) and menu.category.rendertarget then
			menu.refreshMenu()
		end
	end
end

function menu.closeMenu(dueToClose)
	menu.closeContextMenu()
	Helper.closeMenu(menu, dueToClose)
	menu.cleanup()
end

function menu.onCloseElement(dueToClose, layer)
	if menu.contextMenu then
		menu.closeContextMenu()
		return
	end
	if layer == config.expandedMenuFrameLayer then
		menu.expandedNode:collapse()
		return
	end
	if dueToClose == "close" then
		__CORE_GAMEOPTIONS_RESTOREINFO.returnhistory = nil
		if menu.isStartmenu then
			menu.closeMenu("back")
		else
			menu.closeMenu("close")
		end
	else
		if next(menu.category) and (dueToClose == "back") then
			menu.setCategory(nil)
			menu.refreshMenu()
			return
		end
		if (not menu.isStartmenu) and (dueToClose == "back") and (not menu.paused) then
			menu.param2[2] = "toplevel"
		end
		menu.closeMenu(dueToClose)
	end
end

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

function menu.checkConstructionPlan(source, id, limitedmodulesused, onlineitems, isHQ)
	if (source == "local") or C.IsConstructionPlanAvailableInCustomGameStart(id) or IsCheatVersion() then
		local numinvalidpatches = ffi.new("uint32_t[?]", 1)
		if not C.IsConstructionPlanValid(id, numinvalidpatches) then
			return false
		end

		local limitedmodulestext = ""
		local num_modules = C.GetNumPlannedLimitedModules(id)
		local buf_modules = ffi.new("UIMacroCount[?]", num_modules)
		num_modules = C.GetPlannedLimitedModules(buf_modules, num_modules, id)
		for j = 0, num_modules - 1 do
			local macro = ffi.string(buf_modules[j].macro)
			local ware = GetMacroData(macro, "ware")
			local usedamount = limitedmodulesused[macro] or 0
			if usedamount + buf_modules[j].amount > (onlineitems[ware] and onlineitems[ware].amount or 0) then
				limitedmodulestext = limitedmodulestext .. "\n- " .. GetMacroData(macro, "name")
			end
			limitedmodulesused[macro] = usedamount + buf_modules[j].amount
		end
		if limitedmodulestext ~= "" then
			return false
		end

		if not isHQ then
			local foundmacros = {}
			for _, macro in ipairs(config.excludedmodules) do
				local hasmacro = Helper.textArrayHelper({ macro }, function (numtexts, texts) return C.CheckConstructionPlanForMacros(id, texts, numtexts) end)
				if hasmacro then
					table.insert(foundmacros, macro)
				end
			end
			if #foundmacros > 0 then
				return false
			end
		end
		return true
	end
	return false
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
		Helper.loadModLuas(menu.name, "customgame_uix")
	end
end
-- kuertee end

init()
