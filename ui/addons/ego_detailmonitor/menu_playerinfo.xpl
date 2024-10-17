
-- param == { 0, 0, mode }

-- ffi setup
local ffi = require("ffi")
local C = ffi.C
ffi.cdef[[
	typedef int32_t BlacklistID;
	typedef int32_t FightRuleID;
	typedef uint64_t MessageID;
	typedef uint64_t TickerCacheID;
	typedef int32_t TradeRuleID;
	typedef uint64_t UniverseID;

	typedef struct {
		const char* id;
		uint32_t textid;
		uint32_t descriptionid;
		uint32_t value;
		uint32_t relevance;
		const char* ware;
	} SkillInfo;
	typedef struct {
		const char* factionid;
		const char* civiliansetting;
		const char* militarysetting;
	} UIFightRuleSetting;

	typedef struct {
		uint32_t id;
		const char* type;
		const char* name;
		bool usemacrowhitelist;
		uint32_t nummacros;
		const char** macros;
		bool usefactionwhitelist;
		uint32_t numfactions;
		const char** factions;
		const char* relation;
		bool hazardous;
	} BlacklistInfo2;
	typedef struct {
		FightRuleID id;
		const char* name;
		uint32_t numfactions;
		UIFightRuleSetting* factions;
	} FightRuleInfo;
	typedef struct {
		MessageID id;
		double time;
		const char* category;
		const char* title;
		const char* text;
		const char* source;
		UniverseID sourcecomponent;
		const char* interaction;
		UniverseID interactioncomponent;
		const char* interactiontext;
		const char* interactionshorttext;
		const char* cutscenekey;
		const char* entityname;
		const char* factionname;
		int64_t money;
		int64_t bonus;
		bool highlighted;
		bool isread;
	} MessageInfo;
	typedef struct {
		const char* id;
		const char* name;
		const char* desc;
		uint32_t amount;
		uint32_t numtiers;
		bool canhire;
	} PeopleInfo;
	typedef struct {
		uint32_t numspaces;
	} PlayerAlertCounts;
	typedef struct {
		size_t index;
		double interval;
		bool repeats;
		bool muted;
		uint32_t numspaces;
		UniverseID* spaceids;
		const char* objectclass;
		const char* objectpurpose;
		const char* objectidcode;
		const char* objectowner;
		const char* name;
		const char* message;
		const char* soundid;
	} PlayerAlertInfo2;
	typedef struct {
		const char* id;
		const char* name;
	} ProductionMethodInfo;
	typedef struct {
		const char* name;
		int32_t skilllevel;
		uint32_t amount;
	} RoleTierData;
	typedef struct {
		uint32_t textid;
		uint32_t descriptionid;
		uint32_t value;
		uint32_t relevance;
	} Skill2;
	typedef struct {
		const char* id;
		const char* name;
	} SoundInfo;
	typedef struct {
		TickerCacheID id;
		double time;
		const char* category;
		const char* title;
		const char* text;
	} TickerCacheEntry;
	typedef struct {
		uint32_t numfactions;
	} TradeRuleCounts;
	typedef struct {
		uint32_t id;
		const char* name;
		uint32_t numfactions;
		const char** factions;
		bool iswhitelist;
	} TradeRuleInfo;
	typedef struct {
		const char* ID;
		const char* Name;
		const char* RawName;
	} UIClothingTheme;
	typedef struct {
		const char* Name;
		const char* RawName;
		const char* Ware;
		uint32_t Quality;
	} UIEquipmentMod;
	typedef struct {
		const char* file;
		const char* icon;
		bool ispersonal;
	} UILogo;
	typedef struct {
		const char* macro;
		uint32_t amount;
	} UIMacroCount;
	typedef struct {
		const char* id;
		const char* name;
		const char* desc;
		const char* category;
		bool enabled;
		bool enabledByDefault;
	} UINotificationType2;
	typedef struct {
		const char* ID;
		const char* Name;
		const char* RawName;
		const char* Icon;
	} UIPaintTheme;
	typedef struct {
		float x;
		float y;
		float z;
		float yaw;
		float pitch;
		float roll;
	} UIPosRot;
	typedef struct {
		const char* wareid;
		uint32_t amount;
	} UIWareAmount;
	void AddPlayerAlert2(PlayerAlertInfo2 alert);
	bool AreVenturesCompatible(void);
	BlacklistID CreateBlacklist2(BlacklistInfo2 info);
	FightRuleID CreateFightRule(FightRuleInfo info);
	UniverseID CreateNPCFromPerson(NPCSeed person, UniverseID controllableid);
	TradeRuleID CreateTradeRule(TradeRuleInfo info);
	bool DropInventory(UniverseID entityid, const char* lockboxid, UIWareAmount* wares, uint32_t numwares);
	const char* GenerateFactionRelationText(const char* factionid);
	uint32_t GetAllFactionShips(UniverseID* result, uint32_t resultlen, const char* factionid);
	uint32_t GetAllFactionStations(UniverseID* result, uint32_t resultlen, const char* factionid);
	uint32_t GetAllTradeRules(TradeRuleID* result, uint32_t resultlen);
	uint32_t GetAvailableClothingThemes(UIClothingTheme* result, uint32_t resultlen);
	uint32_t GetAvailableEquipmentMods(UIEquipmentMod* result, uint32_t resultlen);
	uint32_t GetAvailableLockboxes(const char** result, uint32_t resultlen, UniverseID entityid);
	uint32_t GetAvailablePaintThemes(UIPaintTheme* result, uint32_t resultlen);
	float GetAveragePlayerNPCSkill(void);
	const char* GetComponentName(UniverseID componentid);
	UniverseID GetContextByClass(UniverseID componentid, const char* classname, bool includeself);
	double GetCurrentGameTime(void);
	UILogo GetCurrentPlayerLogo(void);
	const char* GetDefaultResponseToSignalForFaction2(const char* signalid, const char* factionid, const char* purposeid);
	const char* GetDefaultPlayerBuildMethod(void);
	int32_t GetEntityCombinedSkill(UniverseID entityid, const char* role, const char* postid);
	uint32_t GetEntitySkillsForAssignment(Skill2* result, UniverseID entityid, const char* role, const char* postid);
	const char* GetFactionDefaultWeaponMode(const char* factionid);
	UniverseID GetLastPlayerControlledShipID(void);
	UIPosRot GetMessageInteractPosition(MessageID messageid);
	uint32_t GetMessages(MessageInfo* result, uint32_t resultlen, size_t start, size_t count, const char* categoryname);
	uint32_t GetNotificationTypes2(UINotificationType2* result, uint32_t resultlen);
	uint32_t GetNumAllFactionShips(const char* factionid);
	uint32_t GetNumAllFactionStations(const char* factionid);
	uint32_t GetNumAllRoles(void);
	uint32_t GetNumAllTradeRules(void);
	uint32_t GetNumAvailableClothingThemes();
	uint32_t GetNumAvailableEquipmentMods();
	uint32_t GetNumAvailableLockboxes(UniverseID entityid);
	uint32_t GetNumAvailablePaintThemes();
	uint32_t GetNumMessages(const char* categoryname, bool );
	uint32_t GetNumNotificationTypes(void);
	uint32_t GetNumPlayerAlerts(void);
	uint32_t GetNumPlayerAlertSounds2(const char* tags);
	uint32_t GetNumPlayerBuildMethods(void);
	uint32_t GetNumPlayerLogos(bool includestandard, bool includecustom);
	uint32_t GetNumSkills(void);
	uint32_t GetNumStationModules(UniverseID stationid, bool includeconstructions, bool includewrecks);
	uint32_t GetNumTickerCache(const char* categoryname);
	uint32_t GetNumTransactionLog(UniverseID componentid, double starttime, double endtime);
	int32_t GetPersonCombinedSkill(UniverseID controllableid, NPCSeed person, const char* role, const char* postid);
	const char* GetPersonName(NPCSeed person, UniverseID controllableid);
	const char* GetPersonRoleName(NPCSeed person, UniverseID controllableid);
	uint32_t GetPersonSkills3(SkillInfo* result, uint32_t resultlen, NPCSeed person, UniverseID controllableid);
	uint32_t GetPeople2(PeopleInfo* result, uint32_t resultlen, UniverseID controllableid, bool includearriving);
	uint32_t GetPlayerAlertCounts(PlayerAlertCounts* result, uint32_t resultlen);
	uint32_t GetPlayerAlerts2(PlayerAlertInfo2* result, uint32_t resultlen);
	uint32_t GetPlayerAlertSounds2(SoundInfo* result, uint32_t resultlen, const char* tags);
	const char* GetPlayerBuildMethod(void);
	uint32_t GetPlayerBuildMethods(ProductionMethodInfo* result, uint32_t resultlen);
	const char* GetPlayerClothingTheme(void);
	const char* GetPlayerFactionName(bool userawname);
	float GetPlayerGlobalLoadoutLevel(void);
	UniverseID GetPlayerID(void);
	uint32_t GetPlayerLogos(UILogo* result, uint32_t resultlen, bool includestandard, bool includecustom);
	const char* GetPlayerPaintTheme(void);
	const char* GetPlayerName(void);
	UniverseID GetPlayerOccupiedShipID(void);
	bool GetPlayerGlobalTradeLoopCargoReservationSetting(void);
	UniverseID GetPlayerZoneID(void);
	const char* GetPurposeName(const char* purposeid);
	int32_t GetRelationRangeUIMaxValue(const char* relationrangeid);
	uint32_t GetRoleTiers(RoleTierData* result, uint32_t resultlen, UniverseID controllableid, const char* role);
	int64_t GetSupplyBudget(UniverseID containerid);
	uint32_t GetStationModules(UniverseID* result, uint32_t resultlen, UniverseID stationid, bool includeconstructions, bool includewrecks);
	float GetTextHeight(const char*const text, const char*const fontname, const float fontsize, const float wordwrapwidth);
	uint32_t GetTickerCache(TickerCacheEntry* result, uint32_t resultlen, size_t start, size_t count, const char* categoryname);
	bool GetTradeRuleInfo(TradeRuleInfo* info, TradeRuleID id);
	TradeRuleCounts GetTradeRuleInfoCounts(TradeRuleID id);
	int64_t GetTradeWareBudget(UniverseID containerid);
	bool HasPersonArrived(UniverseID controllableid, NPCSeed person);
	bool HasDefaultResponseToSignalForFaction(const char* signalid, const char* factionid, const char* purposeid);
	bool IsComponentClass(UniverseID componentid, const char* classname);
	bool IsComponentOperational(UniverseID componentid);
	bool IsMouseEmulationActive(void);
	bool IsPersonTransferScheduled(UniverseID controllableid, NPCSeed person);
	bool IsPlayerTradeRuleDefault(TradeRuleID id, const char* ruletype);
	bool IsShipAtExternalDock(UniverseID shipid);
	bool IsUnit(UniverseID controllableid);
	void MutePlayerAlert(size_t index);
	void ReadAllInventoryWares(void);
	void ReadInventoryWare(const char* wareid);
	void ReleasePersonFromCrewTransfer(UniverseID controllableid, NPCSeed person);
	void RemoveBlacklist(BlacklistID id);
	void RemoveFightRule(FightRuleID id);
	void RemovePerson(UniverseID controllableid, NPCSeed person);
	void RemovePlayerAlert(size_t index);
	void RemoveTradeRule(TradeRuleID id);
	void ResetDefaultResponseToSignalForFaction(const char* signalid, const char* factionid, const char* purposeid);
	bool SetDefaultResponseToSignalForFaction2(const char* newresponse, bool ask, const char* signalid, const char* factionid, const char* purposeid);
	void SetEditBoxText(const int editboxid, const char* text);
	void SetFactionBuildMethod(const char* factionid, const char* buildmethodid);
	void SetFactionRelationToPlayerFaction(const char* factionid, const char* reasonid, float boostvalue);
	void SetFactionDefaultWeaponMode(const char* factionid, const char* weaponmode);
	void SetGuidance(UniverseID componentid, UIPosRot offset);
	void SetMessageRead(MessageID messageid, const char* categoryname);
	void SetNotificationTypeEnabled(const char* id, bool value);
	void SetPlayerBlacklistDefault(BlacklistID id, const char* listtype, const char* defaultgroup, bool value);
	void SetPlayerClothingTheme(const char* theme);
	void SetPlayerFactionName(const char* name);
	void SetPlayerFightRuleDefault(FightRuleID id, const char* listtype, bool value);
	void SetPlayerGlobalLoadoutLevel(float value);
	void SetPlayerIllegalWare(const char* wareid, bool illegal);
	void SetPlayerLogo(UILogo logo);
	void SetPlayerPaintTheme(const char* theme);
	void SetPlayerShipsWaitForPlayer(bool value);
	void SetPlayerTaxiWaitsForPlayer(bool value);
	void SetPlayerTradeLoopCargoReservationSetting(bool value);
	void SetPlayerTradeRuleDefault(TradeRuleID id, const char* ruletype, bool value);
	bool ShouldPlayerShipsWaitForPlayer(void);
	bool ShouldPlayerTaxiWaitForPlayer(void);
	void SignalObjectWithNPCSeed(UniverseID objecttosignalid, const char* param, NPCSeed person, UniverseID controllableid);
	void UnmutePlayerAlert(size_t index, bool silent);
	void UpdateBlacklist2(BlacklistInfo2 info);
	void UpdateFightRule(FightRuleInfo info);
	void UpdatePlayerAlert2(PlayerAlertInfo2 uialert);
	void UpdateTradeRule(TradeRuleInfo info);
]]

local utf8 = require("utf8")

local menu = {
	name = "PlayerInfoMenu",
	inventoryData = {
		craftingHistory = {},
		selectedWares = {},
		curEntry = {},
		mode = "normal",
	},
	logbookData = {
		name = ReadText(1001, 2963),
		category = "all",
		curPage = 1,
		searchtext = "",
	},
	messageData = {
		name = ReadText(1001, 7741),
		category = "highprio",
		searchtext = "",
		curEntry = {},
	},
	equipmentModsData = {
		expandedProperties = {}
	},
	accountData = {
		transactions = {}
	},
	empireData = {
	},
	personnelData = {
		sort = "name",
		role = "current",
		curPage = 1,
		searchtext = "",
		expandedEntities = {},
		curEntry = {},
	},
	editedBlacklist = {},
	factionData = {
		curEntry = {},
	},
	editedFightRule = {},
}

local config = {
	mode = "empire",
	mainLayer = 5,
	infoLayer = 4,
	contextLayer = 2,
	rowHeight = 17,
	leftBar = {
		{ name = ReadText(1001, 7717),		icon = "pi_empire",					mode = "empire",			active = true, helpOverlayID = "playerinfo_sidebar_empire",			helpOverlayText = ReadText(1028, 7701) },
		{ name = ReadText(1001, 7703),		icon = "pi_diplomacy",				mode = "factions",			active = true, helpOverlayID = "playerinfo_sidebar_factions",		helpOverlayText = ReadText(1028, 7715) },
		{ name = ReadText(1001, 2500),		icon = "pi_statistics",				mode = "stats",				active = true, helpOverlayID = "playerinfo_sidebar_stats",			helpOverlayText = ReadText(1028, 7717) },
		{ spacing = true },
		{ name = ReadText(1001, 2202),		icon = "pi_inventory",				mode = "inventory",			active = true, helpOverlayID = "playerinfo_sidebar_inventory",		helpOverlayText = ReadText(1028, 7703) },
		--{ name = ReadText(1001, 7701),		icon = "pi_crafting",				mode = "crafting",			active = true },
		{ name = ReadText(1001, 8031),		icon = "pi_equipmentmods",			mode = "equipmentmods",		active = true, helpOverlayID = "playerinfo_sidebar_equipmentmods",	helpOverlayText = ReadText(1028, 7705) },
		{ name = ReadText(1001, 7716),		icon = "pi_spacesuit",				mode = "spacesuit",			active = true, helpOverlayID = "playerinfo_sidebar_spacesuit",		helpOverlayText = ReadText(1028, 7707) },
		{ spacing = true },
		{ name = ReadText(1001, 9171),		icon = "mapst_ao_default_global",	mode = "globalorders",		active = true, helpOverlayID = "playerinfo_sidebar_globalorders",	helpOverlayText = ReadText(1028, 7709) },
		{ name = ReadText(1001, 7708),		icon = "pi_accountmanagement",		mode = "accounts",			active = true, helpOverlayID = "playerinfo_sidebar_accounts",		helpOverlayText = ReadText(1028, 7713) },
		{ name = ReadText(1001, 11034),		icon = "pi_personnelmanagement",	mode = "personnel",			active = true, helpOverlayID = "playerinfo_sidebar_personnel",		helpOverlayText = ReadText(1028, 7718) },
		{ spacing = true },
		{ name = ReadText(1001, 7730),		icon = function () return menu.messageSidebarIcon() end,		mode = "messages",			active = true, helpOverlayID = "playerinfo_sidebar_messages",		helpOverlayText = ReadText(1028, 7712),		iconcolor = function () return menu.messageSidebarIconColor() end },
		{ name = ReadText(1001, 7702),		icon = "pi_transactionlog",			mode = "transactionlog",	active = true, helpOverlayID = "playerinfo_sidebar_transactions",	helpOverlayText = ReadText(1028, 7719) },
		{ name = ReadText(1001, 5700),		icon = "pi_logbook",				mode = "logbook",			active = true, helpOverlayID = "playerinfo_sidebar_logbook",		helpOverlayText = ReadText(1028, 7711) },
		{ spacing = true,	condition = function () return OnlineHasSession() end },
		{ name = ReadText(1001, 11386),		icon = "vt_contactlist",			mode = "venturecontacts",	active = true, helpOverlayID = "playerinfo_sidebar_contacts",		helpOverlayText = ReadText(1028, 3275),	condition = function () return OnlineHasSession() end },
	},
	rightAlignTextProperties = {
		halign = "right"
	},
	rightAlignBoldTextProperties = {
		font = Helper.standardFontBold,
		halign = "right"
	},
	logbookCategories = {
		{ name = ReadText(1001, 2963),	icon = "pi_logbook",			mode = "all" },
		{ empty = true },
		{ name = ReadText(1001, 5701),	icon = "logbook_general",		mode = "general" },
		{ name = ReadText(1001, 5702),	icon = "logbook_missions",		mode = "missions" },
		{ name = ReadText(1001, 5721),	icon = "logbook_news",			mode = "news" },
		{ name = ReadText(1001, 5714),	icon = "logbook_alerts",		mode = "alerts" },
		{ name = ReadText(1001, 5704),	icon = "logbook_upkeep",		mode = "upkeep" },
		{ name = ReadText(1001, 5708),	icon = "logbook_tips",			mode = "tips" },
		{ name = ReadText(1001, 5727),	icon = "logbook_notifications",	mode = "ticker" },
	},
	logbookPage = 100,
	logbookQueryLimit = 1000,
	messageCategories = {
		{ name = ReadText(1001, 7741),	icon = "pi_message_read_high",	icon_unread = "pi_message_unread_high",	mode = "highprio" },
		{ name = ReadText(1001, 7742),	icon = "pi_message_read_low",	icon_unread = "pi_message_unread_low",	mode = "lowprio" },
	},
	messageCutscenes = {
		["OrbitIndefinitely"] = true,
		["terraforming_scaleplate_green"] = true,
		["terraforming_black_hole_sun"] = true,
		["terraforming_getsu_fune"] = true,
		["terraforming_frontier_edge"] = true,
		["terraforming_atiyas_misfortune"] = true,
		["terraforming_18billion"] = true,
		["terraforming_memory_of_profit"] = true,
		["terraforming_tharkas_cascade"] = true,
		["terraforming_ocean_of_fantasy"] = true
	},
	mouseOutRange = 100,
	modCountColumnWidth = 60,
	equipmentModClasses = {
		{ name = ReadText(1001, 8008), modclass = "ship" },
		{ name = ReadText(1001, 1301), modclass = "weapon" },
		{ name = ReadText(1001, 1317), modclass = "shield" },
		{ name = ReadText(1001, 1103), modclass = "engine" },
	},
	inventoryCategories = {
		{ id = "crafting",		name = ReadText(1001, 2827) },
		{ id = "upgrade",		name = ReadText(1001, 7716) },
		{ id = "paintmod",		name = ReadText(1001, 8510) },
		{ id = "useful",		name = ReadText(1001, 2828) },
		{ id = "tradeonly",		name = ReadText(1001, 2829) },
	},
	inventoryTabs = {
		{ category = "normal",	name = ReadText(1001, 2202),	icon = "pi_inventory",			helpOverlayID = "playerinfo_inventory_normal",		helpOverlayText = ReadText(1028, 7703) },
	},
	blacklistTypes = {
		[1] = { id = "sectortravel",	text = ReadText(1001, 9165), icon = "", displayremoveoption = false, mouseovertext = ReadText(1026, 9101), shorttext = ReadText(1001, 9162) },
		[2] = { id = "sectoractivity",	text = ReadText(1001, 9166), icon = "", displayremoveoption = false, mouseovertext = ReadText(1026, 9102), shorttext = ReadText(1001, 9163) },
		[3] = { id = "objectactivity",	text = ReadText(1001, 9167), icon = "", displayremoveoption = false, mouseovertext = ReadText(1026, 9103), shorttext = ReadText(1001, 9164) },
	},
	classDefinitions = {
		["object"]	= ReadText(1001, 9198),
		["station"]	= ReadText(1001, 3),
		["ship_xl"]	= ReadText(1001, 11003),
		["ship_l"]	= ReadText(1001, 11002),
		["ship_m"]	= ReadText(1001, 11001),
		["ship_s"]	= ReadText(1001, 11000),
	},
	personnelPage = 100,
}

if C.AreVenturesCompatible() then
	table.insert(config.inventoryTabs, { category = "online",	name = ReadText(1001, 7720),	icon = "vt_inventory_player",	helpOverlayID = "playerinfo_inventory_online",		helpOverlayText = ReadText(1028, 3269) })

	table.insert(config.logbookCategories, { empty = true,		online = true })
	table.insert(config.logbookCategories, { name = ReadText(1001, 11319),	icon = "vt_logbook",		mode = "online",	online = true })
end

-- kuertee start:
local callbacks = {}
-- kuertee end

local function init()
	Menus = Menus or { }
	table.insert(Menus, menu)
	if Helper then
		Helper.registerMenu(menu)
	end
	menu.infoTablePersistentData = {
		left = {
			venturecontacts = { curPage = 1, searchtext = "", forumsearch = "" },
		},
	}


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

function menu.cleanup()
	unregisterForEvent("inputModeChanged", getElement("Scene.UIContract"), menu.onInputModeChanged)

	UnregisterAddonBindings("ego_detailmonitor")

	menu.mainFrame = nil
	menu.infoFrame = nil
	menu.contextFrame = nil

	menu.mainTable = nil
	menu.topLevelTable = nil
	menu.infoTable = nil
	menu.buttonTable = nil

	menu.contextMenuMode = nil
	menu.mouseOutBox = nil

	menu.expandedTransactionEntry = nil
	menu.transactionSearchString = nil

	menu.inventoryData.selectedWares = {}
	menu.accountData.transactions = {}
	menu.personnelData.curEntry = {}
	menu.messageData.showFullscreen = nil

	menu.blacklists = {}
	menu.blacklist = {}
	menu.editedBlacklist = {}

	menu.fightrules = {}
	menu.fightrule = {}
	menu.editedFightRule = {}

	menu.settoprow = nil
	menu.setselectedrow = nil
	menu.setselectedrow2 = nil
	menu.setselectedcol2 = nil
	menu.logbookPageEditBox = nil
	menu.personnelPageEditBox = nil
	menu.transactionLogEditBox = nil
	menu.noupdate = nil

	menu.topRows = {}
	menu.selectedRows = {}
	menu.selectedCols = {}

	menu.cleanupCutsceneRenderTarget()

	if (menu.mode == "inventory") or (menu.mode == "spacesuit") or (menu.empireData.mode and (menu.empireData.mode[1] == "empire_call") and (menu.empireData.mode[2] == "inventory")) then
		C.ReadAllInventoryWares()
	end
	menu.empireData = {}

	if Helper.hasExtension("multiverse") then
		Helper.callExtensionFunction("multiverse", "unregisterOnlineEvents", menu)
	end
	Helper.unregisterVentureContactCallbacks()
	menu.ventureContactCallbacksRegistered = nil

	C.SetUICoverOverride(false)

	-- kuertee start: callback
	if callbacks ["cleanup"] then
		for _, callback in ipairs (callbacks ["cleanup"]) do
			callback ()
		end
	end
	-- kuertee end: callback
end

-- Menu member functions

function menu.refreshInfoFrame(toprow, selectedrow, mode, selectedrow2)
	menu.settoprow = toprow or GetTopRow(menu.infoTable)
	menu.setselectedrow = selectedrow or Helper.currentTableRow[menu.infoTable]
	if mode == "accounts" then
		menu.setselectedrow2 = selectedrow2 or Helper.currentTableRow[menu.infoTable]
	end
	menu.logbookPageEditBox = nil
	menu.personnelPageEditBox = nil
	menu.transactionLogEditBox = nil
	if menu.inventoryHeaderTable and menu.lastactivetable == menu.inventoryHeaderTable.id then
		menu.selectedRows.inventoryHeaderTable = menu.selectedRows.inventoryHeaderTable or Helper.currentTableRow[menu.inventoryHeaderTable.id] or 1
		menu.selectedCols.inventoryHeaderTable = menu.selectedCols.inventoryHeaderTable or Helper.currentTableCol[menu.inventoryHeaderTable.id]
	end
	menu.createInfoFrame()
end

function menu.buttonSetPlayerLogo(logo, row, col)
	C.SetPlayerLogo(logo)
	menu.empireData.currentlogo = logo

	menu.setselectedrow2 = row
	menu.setselectedcol2 = col
	menu.over = true
	--print("row: " .. tostring(row) .. ", col: " .. tostring(col))
end

function menu.buttonSetDefaultTheme(mode, themeid, row, col)
	--print("mode: " .. tostring(mode) .. ". applying theme: " .. tostring(themeid))
	if mode == "painttheme" then
		C.SetPlayerPaintTheme(themeid)
	elseif mode == "uniform" then
		C.SetPlayerClothingTheme(themeid)
	end

	menu.setselectedrow2 = row
	menu.setselectedcol2 = col
	menu.over = true
	--print("row: " .. tostring(row) .. ", col: " .. tostring(col))
end

function menu.buttonTogglePlayerInfo(mode)
	-- kuertee start: callback
	if callbacks ["buttonTogglePlayerInfo_on_start"] then
		for _, callback in ipairs (callbacks ["buttonTogglePlayerInfo_on_start"]) do
			callback (mode, config)
		end
	end
	-- kuertee end: callback

	local oldidx, newidx
	for i, entry in ipairs(config.leftBar) do
		if entry.mode then
			if entry.mode == menu.mode then
				oldidx = i
			end
			if entry.mode == mode then
				newidx = i
			end
		end
		if oldidx and newidx then
			break
		end
	end
	if newidx then
		Helper.updateButtonColor(menu.mainTable, newidx + 2, 1, Color["row_background_selected"])
	end
	if oldidx then
		Helper.updateButtonColor(menu.mainTable, oldidx + 2, 1, Color["button_background_default"])
	end

	-- Mark items as read when hiding them
	if (menu.mode == "inventory") or (menu.mode == "spacesuit") or (menu.empireData.mode and (menu.empireData.mode[1] == "empire_call") and (menu.empireData.mode[2] == "inventory")) then
		menu.inventoryData.selectedWares = {}
		C.ReadAllInventoryWares()
		if menu.inventoryData.mode == "online" then
			if Helper.hasExtension("multiverse") then
				Helper.callExtensionFunction("multiverse", "unregisterOnlineEvents", menu)
				Helper.callExtensionFunction("multiverse", "onCloseMenuTab", menu, "ventureinventory", mode)
			end
		end
	elseif menu.mode == "messages" then
		if next(menu.messageData.curEntry) then
			C.SetMessageRead(menu.messageData.curEntry.id, menu.messageData.curEntry.category)
			AddUITriggeredEvent(menu.name, "message_read", ConvertStringTo64Bit(tostring(menu.messageData.curEntry.id)))
		end
		menu.messageData.curEntry = {}
		menu.messageData.showFullscreen = nil
		menu.cleanupCutsceneRenderTarget()
	elseif menu.mode == "venturecontacts" then
		Helper.unregisterVentureContactCallbacks()
		menu.ventureContactCallbacksRegistered = nil
	end

	AddUITriggeredEvent(menu.name, mode, menu.mode == mode and "off" or "on")
	if mode == menu.mode then
		PlaySound("ui_negative_back")
		menu.mode = nil
		menu.personnelData.curEntry = {}
		if oldidx then
			SelectRow(menu.mainTable, oldidx + 2)
		end
	else
		menu.setdefaulttable = true
		PlaySound("ui_positive_select")
		menu.mode = mode
		if mode == "personnel" then
			menu.empireData.init = true
		end
		if newidx then
			SelectRow(menu.mainTable, newidx + 2)
		end
	end

	menu.refreshInfoFrame(1, 1)
end

function menu.deactivatePlayerInfo()
	local oldidx
	for i, entry in ipairs(config.leftBar) do
		if entry.mode then
			if entry.mode == menu.mode then
				oldidx = i
			end
		end
		if oldidx then
			break
		end
	end

	if oldidx then
		Helper.updateButtonColor(menu.mainTable, oldidx + 2, 1, Color["button_background_default"])
	end

	-- Mark items as read when hiding them
	if (menu.mode == "inventory") or (menu.mode == "spacesuit") or (menu.empireData.mode and (menu.empireData.mode[1] == "empire_call") and (menu.empireData.mode[2] == "inventory")) then
		menu.inventoryData.selectedWares = {}
		C.ReadAllInventoryWares()
		if menu.inventoryData.mode == "online" then
			if Helper.hasExtension("multiverse") then
				Helper.callExtensionFunction("multiverse", "unregisterOnlineEvents", menu)
				Helper.callExtensionFunction("multiverse", "onCloseMenuTab", menu, "ventureinventory", "ventureinventory")
			end
		end
	elseif menu.mode == "messages" then
		if next(menu.messageData.curEntry) then
			C.SetMessageRead(menu.messageData.curEntry.id, menu.messageData.curEntry.category)
			AddUITriggeredEvent(menu.name, "message_read", ConvertStringTo64Bit(tostring(menu.messageData.curEntry.id)))
		end
		menu.messageData.curEntry = {}
		menu.messageData.showFullscreen = nil
		menu.cleanupCutsceneRenderTarget()
	elseif menu.mode == "venturecontacts" then
		Helper.unregisterVentureContactCallbacks()
		menu.ventureContactCallbacksRegistered = nil
	end
	menu.personnelData.curEntry = {}

	PlaySound("ui_negative_back")
	menu.mode = nil
	if oldidx then
		SelectRow(menu.mainTable, oldidx + 2)
	end

	menu.refreshInfoFrame(1, 1)
end

function menu.buttonInventoryDrop()
	if menu.inventoryData.mode == "drop" then
		local wares = ffi.new("UIWareAmount[?]", #menu.inventoryData.dropWares)

		for i, entry in ipairs(menu.inventoryData.dropWares) do
			wares[i - 1].wareid = Helper.ffiNewString(entry.ware)
			wares[i - 1].amount = entry.amount
		end

		local lockbox = menu.inventoryData.dropLockbox
		if lockbox == "none" then
			lockbox = nil
		end
		C.DropInventory(C.GetPlayerID(), lockbox, wares, #menu.inventoryData.dropWares)

		menu.inventoryData.mode = "normal"
		menu.inventoryData.dropWares = {}
	else
		local rowdata = Helper.getCurrentRowData(menu, menu.infoTable)
		if type(rowdata) == "table" then
			menu.inventoryData.mode = "drop"

			menu.inventoryData.dropWares = {}
			for ware in pairs(menu.inventoryData.selectedWares) do
				if GetWareData(ware, "allowdrop") and (not menu.onlineitems[ware]) then
					if menu.inventory[ware] and menu.inventory[ware].amount > 0 then
						table.insert(menu.inventoryData.dropWares, { ware = ware, amount = menu.inventory[ware].amount })
					end
				end
			end
		end
	end
	menu.refreshInfoFrame()
end

function menu.buttonInventoryCraft()
	if menu.inventoryData.mode == "craft" then
		if menu.inventoryData.craftAmount and menu.inventoryData.craftAmount > 0 then
			for _, entry in ipairs(menu.craftable) do
				if entry.ware == menu.inventoryData.craftWare[1] then
					if HasAllResourcesToCraft(nil, menu.inventoryData.craftWare[1], menu.inventoryData.craftAmount) then
						local isunbundleammo, component = GetWareData(menu.inventoryData.craftWare[1], "isunbundleammo", "component")
						if isunbundleammo then
							local playership = C.GetPlayerOccupiedShipID()
							if playership ~= 0 then
								if AddAmmo(ConvertStringToLuaID(tostring(playership)), component, menu.inventoryData.craftAmount, true) ~= menu.inventoryData.craftAmount then
									-- We're out of ammo space abort
									break
								end
							end
						end
						for _, resource in ipairs(entry.resources) do
							RemoveInventory(nil, resource.ware, menu.inventoryData.craftAmount * resource.data.needed)
						end
						AddInventory(nil, menu.inventoryData.craftWare[1], menu.inventoryData.craftAmount, true)
						table.insert(menu.inventoryData.craftingHistory, 1, { ware = menu.inventoryData.craftWare, amount = menu.inventoryData.craftAmount, time = C.GetCurrentGameTime() })
						PlaySound("ui_crafting_success")
					end
					break
				end
			end
		end
		menu.inventoryData.mode = nil
		menu.inventoryData.craftWare = nil
		menu.inventoryData.craftAmount = nil
	else
		local rowdata = Helper.getCurrentRowData(menu, menu.defaulttable)
		if type(rowdata) == "table" then
			menu.inventoryData.mode = "craft"
			menu.inventoryData.craftWare = Helper.getCurrentRowData(menu, menu.defaulttable)
			menu.inventoryData.craftAmount = 1
		end
	end
	menu.refreshInfoFrame()
end

function menu.buttonInventoryCancel()
	menu.inventoryData.mode = "normal"
	menu.inventoryData.dropWares = {}
	menu.inventoryData.craftWare = nil
	menu.inventoryData.craftAmount = nil
	menu.refreshInfoFrame()
end

function menu.buttonInventoryEncyclopedia(ware)
	local ispaintmod = GetWareData(ware, "ispaintmod")
	if ispaintmod then
		Helper.closeMenuAndOpenNewMenu(menu, "EncyclopediaMenu", { 0, 0, "Wares", "paintmods", ware })
	else
		Helper.closeMenuAndOpenNewMenu(menu, "EncyclopediaMenu", { 0, 0, "Wares", "inventory_wares", ware })
	end
	menu.cleanup()
end

function menu.buttonInventoryDropAll(illegalonly)
	local count = 0
	for ware in pairs(illegalonly and menu.inventory or menu.inventoryData.selectedWares) do
		if GetWareData(ware, "allowdrop") and (not menu.onlineitems[ware]) then
			if (not illegalonly) or (menu.inventoryData.policefaction and IsWareIllegalTo(ware, "player", menu.inventoryData.policefaction)) then
				if menu.inventory[ware] and menu.inventory[ware].amount > 0 then
					count = count + 1
				end
			end
		end
	end

	local wares = ffi.new("UIWareAmount[?]", count)
	local i = 0
	for ware in pairs(illegalonly and menu.inventory or menu.inventoryData.selectedWares) do
		if GetWareData(ware, "allowdrop") and (not menu.onlineitems[ware]) then
			if (not illegalonly) or (menu.inventoryData.policefaction and IsWareIllegalTo(ware, "player", menu.inventoryData.policefaction)) then
				if menu.inventory[ware] and menu.inventory[ware].amount > 0 then
					wares[i].wareid = Helper.ffiNewString(ware)
					wares[i].amount = menu.inventory[ware].amount
					i = i + 1
				end
			end
		end
	end

	C.DropInventory(C.GetPlayerID(), menu.inventoryData.defaultLockbox, wares, count)
	menu.closeContextMenu()
	menu.refreshInfoFrame()
end

function menu.buttonInventorySubMode(mode, col)
	if mode ~= menu.inventoryData.mode then
		menu.inventoryData.mode = mode
		if menu.inventoryData.mode ~= "online" then
			if Helper.hasExtension("multiverse") then
				Helper.callExtensionFunction("multiverse", "unregisterOnlineEvents", menu)
			end
		end
		menu.refreshInfoFrame()
	end
end

function menu.buttonLogbookCategory(name, category, col)
	menu.logbookData.name = name
	menu.logbookData.category = category
	menu.logbookData.curPage = 1
	menu.setselectedcol = col
	menu.refreshInfoFrame()
end

function menu.buttonLogbookClearQuestion()
	menu.closeContextMenu()

	menu.contextMenuMode = "userquestion"
	menu.contextMenuData = { mode = "clearlogbook", category = menu.logbookData.category, width = Helper.scaleX(400), xoffset = (Helper.viewWidth - Helper.scaleX(400)) / 2, yoffset = Helper.viewHeight / 2 }

	menu.createUserQuestionFrame()
end

function menu.buttonLogbookClear(category)
	ClearLogbook(0, category)
	menu.closeContextMenu()
	menu.refreshInfoFrame()
end

function menu.buttonLogbookInteraction(entry)
	if IsValidComponent(entry.interactioncomponent) then
		if entry.interaction == "showonmap" then
			Helper.closeMenuAndOpenNewMenu(menu, "MapMenu", { 0, 0, true, entry.interactioncomponent })
			menu.cleanup()
		elseif entry.interaction == "showlocationonmap" then
			Helper.closeMenuAndOpenNewMenu(menu, "MapMenu", { 0, 0, true, entry.interactioncomponent, nil, nil, nil, nil, entry.interactionposition })
			menu.cleanup()
		elseif entry.interaction == "guidance" then
			local convertedInteractionComponent = ConvertIDTo64Bit(entry.interactioncomponent)
			if convertedInteractionComponent ~= C.GetPlayerControlledShipID() then
				local offset = ffi.new("UIPosRot", 0)
				C.SetGuidance(convertedInteractionComponent, offset)
			end
		end
	else
		menu.refreshInfoFrame()
	end
end

function menu.editboxLogbookPage(_, text, textchanged)
	menu.noupdate = nil
	local newpage = tonumber(text)
	if newpage and (newpage ~= menu.logbookData.curPage) then
		menu.logbookData.curPage = math.max(1, math.min(newpage, menu.logbookData.numPages))
		menu.refreshInfoFrame()
	else
		C.SetEditBoxText(menu.logbookPageEditBox.id, menu.logbookData.curPage .. " / " .. menu.logbookData.numPages)
	end
end

function menu.editboxPersonnelPage(_, text, textchanged)
	menu.noupdate = nil
	local newpage = tonumber(text)
	if newpage and (newpage ~= menu.personnelData.curPage) then
		menu.personnelData.curPage = math.max(1, math.min(newpage, menu.personnelData.numPages))
		menu.personnelData.curEntry = {}
		menu.refreshInfoFrame(1, 1)
	else
		C.SetEditBoxText(menu.personnelPageEditBox.id, menu.personnelData.curPage .. " / " .. menu.personnelData.numPages)
	end
end

function menu.buttonMessageCategory(name, category, col)
	menu.messageData.name = name
	menu.messageData.category = category
	if next(menu.messageData.curEntry) then
		C.SetMessageRead(menu.messageData.curEntry.id, menu.messageData.curEntry.category)
		AddUITriggeredEvent(menu.name, "message_read", ConvertStringTo64Bit(tostring(menu.messageData.curEntry.id)))
	end
	menu.messageData.curEntry = {}
	menu.messageData.showFullscreen = nil
	menu.cleanupCutsceneRenderTarget()
	menu.setselectedcol = col
	menu.refreshInfoFrame()
end

function menu.buttonMessagesRead()
	for _, entry in ipairs(menu.messages) do
		C.SetMessageRead(entry.id, entry.category)
		AddUITriggeredEvent(menu.name, "message_read", ConvertStringTo64Bit(tostring(entry.id)))
	end
	menu.refreshInfoFrame()
end

function menu.buttonMessagesInteraction(entry)
	if (entry.interactioncomponent > 0) and C.IsComponentOperational(entry.interactioncomponent) then
		if entry.interaction == "showonmap" then
			Helper.closeMenuAndOpenNewMenu(menu, "MapMenu", { 0, 0, true, ConvertStringToLuaID(tostring(entry.interactioncomponent)) })
			menu.cleanup()
		elseif entry.interaction == "showlocationonmap" then
			Helper.closeMenuAndOpenNewMenu(menu, "MapMenu", { 0, 0, true, ConvertStringToLuaID(tostring(entry.interactioncomponent)), nil, nil, nil, nil, entry.interactionposition })
			menu.cleanup()
		elseif entry.interaction == "guidance" then
			if entry.interactioncomponent ~= C.GetPlayerControlledShipID() then
				local offset = ffi.new("UIPosRot", 0)
				C.SetGuidance(entry.interactioncomponent, offset)
			end
		end
	else
		menu.refreshInfoFrame()
	end
end

function menu.buttonMessagesToggleCutsceneFullscreen()
	menu.messageData.showFullscreen = not menu.messageData.showFullscreen
	menu.refreshInfoFrame()
end

function menu.buttonAccountCancel()
	menu.accountData.transactions = {}
	menu.refreshInfoFrame()
end

function menu.buttonAccountConfirm()
	for _, transaction in ipairs(menu.accountData.transactions) do
		if transaction.amount > 0 then
			local isplayerowned = GetComponentData(transaction.station, "isplayerowned")
			if isplayerowned then
				local newstationcash = (GetAccountData(transaction.station, "money") or 0) - transaction.amount
				SetMaxBudget(transaction.station, (newstationcash * 3) / 2)
				SetMinBudget(transaction.station, newstationcash)
				TransferMoneyToPlayer(transaction.amount, transaction.station)
			end
		end
	end
	for _, transaction in ipairs(menu.accountData.transactions) do
		if transaction.amount < 0 then
			local isplayerowned = GetComponentData(transaction.station, "isplayerowned")
			if isplayerowned then
				-- NB: transaction.amount is always with respect to the player's account! so transaction.amount in this case is negative since money is taken away from the player's account.
				local newstationcash = (GetAccountData(transaction.station, "money") or 0) - transaction.amount
				SetMaxBudget(transaction.station, (newstationcash * 3) / 2)
				SetMinBudget(transaction.station, newstationcash)
				TransferPlayerMoneyTo(-transaction.amount, transaction.station)
			end
		end
	end
	menu.accountData.transactions = {}
	menu.refreshInfoFrame()
end

function menu.accountSetEstimate(container, isbuildstorage)
	local container64 = ConvertIDTo64Bit(container)
	local containernmoney, productionmoney, wantedmoney, isplayerowned = GetComponentData(container, "money", "productionmoney", "wantedmoney", "isplayerowned")
	if isplayerowned then
		local estimate = 0
		if isbuildstorage then
			estimate = wantedmoney
		else
			local supplymoney = tonumber(C.GetSupplyBudget(container64)) / 100
			local tradewaremoney = tonumber(C.GetTradeWareBudget(container64)) / 100
			estimate = productionmoney + supplymoney + tradewaremoney
		end
		local amount = -estimate + containernmoney

		local _, index = menu.findAccountTransaction(container)
		if amount ~= 0 then
			if index then
				if menu.accountData.transactions[index].amount ~= amount then
					menu.accountData.transactions[index].amount = amount
				end
			else
				table.insert(menu.accountData.transactions, { station = container, amount = amount })
			end
		else
			if index then
				table.remove(menu.accountData.transactions, index)
			end
		end
	end
end

function menu.buttonAccountToEstimate(container, isbuildstorage)
	menu.accountSetEstimate(container, isbuildstorage)

	menu.refreshInfoFrame()
end

function menu.buttonAccountAllEstimates()
	for i, station in ipairs(menu.accountData.stations) do
		menu.accountSetEstimate(station)
		local buildstorage = GetComponentData(station, "buildstorage")
		menu.accountSetEstimate(buildstorage, true)
	end

	menu.refreshInfoFrame()
end

function menu.editboxChangePlayerName(_, text, textchanged)
	menu.noupdate = nil
	if textchanged and (text ~= "") then
		local player = ConvertStringTo64Bit(tostring(C.GetPlayerID()))
		SetComponentName(player, text)
		menu.empireData.name = text
	end

	menu.refreshInfoFrame()
end

function menu.editboxChangePlayerFactionName(_, text, textchanged)
	menu.noupdate = nil
	if textchanged then
		C.SetPlayerFactionName(text)
		menu.empireData.factionname = text
	end

	menu.refreshInfoFrame()
end

function menu.editboxUpdateTransactionSearchString(_, text, textchanged)
	if textchanged then
		menu.transactionSearchString = text
	end

	menu.refreshInfoFrame()
end

function menu.dropdownInventoryLockbox(_, id)
	menu.inventoryData.dropLockbox = id
end

function menu.slidercellInventoryDrop(ware, value)
	for _, entry in ipairs(menu.inventoryData.dropWares) do
		if entry.ware == ware then
			entry.amount = value
		end
	end
end

function menu.slidercellInventoryCraft(_, value)
	menu.inventoryData.craftAmount = value
end

function menu.slidercellAccountChanged(station, row, value, functable)
	if not functable then
		functable = menu.infoTable
	end

	local changed = false
	if value ~= 0 then
		local _, index = menu.findAccountTransaction(station)
		if index then
			if menu.accountData.transactions[index].amount ~= value then
				menu.accountData.transactions[index].amount = value
				changed = true
			end
		else
			table.insert(menu.accountData.transactions, { station = station, amount = value })
		end
	else
		local _, index = menu.findAccountTransaction(station)
		if index then
			table.remove(menu.accountData.transactions, index)
			changed = true
		end
	end

	if changed then
		local playermoney = ConvertMoneyString(menu.getAccountPlayerMoney(), false, true, nil, true) .. " " .. ReadText(1001, 101)
		for i in ipairs(menu.accountData.stations) do
			Helper.updateCellText(functable, i * 7 - 3, 5, playermoney)
			Helper.updateCellText(functable, i * 7, 5, playermoney)
			if (i * 7 - 3) == row then
				Helper.updateCellText(functable, i * 7 - 3, 2, ConvertMoneyString(GetComponentData(station, "money") - value, false, true, nil, true) .. " " .. ReadText(1001, 101))
			elseif (i * 7) == row then
				Helper.updateCellText(functable, i * 7, 2, ConvertMoneyString(GetComponentData(station, "money") - value, false, true, nil, true) .. " " .. ReadText(1001, 101))
			end
		end
	end
end

function menu.onSliderCellActivated()
	menu.refresh = nil
	menu.refreshdata = nil
end

-- mode: "factionresponses", "controllableresponses"
function menu.checkboxOrdersSetAsk(factionorcontrollable, signalid, mode, row)
	if mode ~= "factionresponses" and mode ~= "controllableresponses" then
		DebugError("menu.checkboxOrdersSetAsk called with invalid mode set. only 'factionresponses' and 'controllableresponses' are supported at this time. mode: " .. tostring(mode))
		return
	elseif not factionorcontrollable then
		DebugError("menu.checkboxOrdersSetAsk called with invalid faction or controllable set. factionorcontrollable: " .. tostring(factionorcontrollable))
		return
	elseif not signalid then
		DebugError("menu.checkboxOrdersSetAsk called with invalid signal id set. signalid: " .. tostring(signalid))
		return
	end

	local ask
	local response
	if mode == "controllableresponses" then
		ask = not C.GetAskToSignalForControllable(signalid, factionorcontrollable)
		response = C.GetDefaultResponseToSignalForControllable(signalid, factionorcontrollable)
		C.SetDefaultResponseToSignalForControllable(response, ask, signalid, factionorcontrollable)
	else
		ask = not C.GetAskToSignalForFaction(signalid, factionorcontrollable)
		response = C.GetDefaultResponseToSignalForFaction2(signalid, factionorcontrollable, "")
		C.SetDefaultResponseToSignalForFaction2(response, ask, signalid, factionorcontrollable, "")
	end
	menu.setselectedrow2 = row
	menu.refreshInfoFrame()
end

function menu.toggleAllNotificationSettings(notificationgroupdata, checked)
	for _, type in ipairs(notificationgroupdata.types) do
		menu.checkboxNotification(notificationgroupdata, type.id, checked)
	end
end

function menu.checkboxNotification(notificationgroupdata, id, checked)
	C.SetNotificationTypeEnabled(id, checked)
	notificationgroupdata.checkedcounts = 0
	for _, type in ipairs(notificationgroupdata.types) do
		if type.id == id then
			type.enabled = checked
		end
		if type.enabled then
			notificationgroupdata.checkedcounts = notificationgroupdata.checkedcounts + 1
		end
	end
end

-- mode: "factionresponses", "controllableresponses"
function menu.dropdownOrdersSetResponse(newresponseid, factionorcontrollable, signalid, mode, purposetype)
	if mode ~= "factionresponses" and mode ~= "controllableresponses" then
		DebugError("menu.dropdownOrdersSetResponse called with invalid mode set. only 'factionresponses' and 'controllableresponses' are supported at this time. mode: " .. tostring(mode))
		return
	elseif not factionorcontrollable then
		DebugError("menu.dropdownOrdersSetResponse called with invalid faction or controllable set. factionorcontrollable: " .. tostring(factionorcontrollable))
		return
	elseif not signalid then
		DebugError("menu.dropdownOrdersSetResponse called with invalid signal id set. signalid: " .. tostring(signalid))
		return
	end

	if newresponseid == "reset" then
		if mode == "controllableresponses" then
			if not C.ResetResponseToSignalForControllable(signalid, factionorcontrollable) then
				DebugError("Failed resetting response to signal " .. tostring(signalid) .. " for controllable " .. ffi.string(C.GetComponentName(factionorcontrollable)) .. " " .. tostring(factionorcontrollable))
			end
		else
			local factionobjects = GetContainedObjectsByOwner(factionorcontrollable)
			for _, object in ipairs(factionobjects) do
				local object64 = ConvertIDTo64Bit(object)
				if C.IsComponentClass(object64, "controllable") then
					if not C.ResetResponseToSignalForControllable(signalid, object64) then
						DebugError("Failed resetting response to signal " .. tostring(signalid) .. " for controllable " .. ffi.string(C.GetComponentName(object64)) .. " " .. tostring(object64))
					end
				end
			end
		end
	elseif newresponseid == "default" then
		if mode == "factionresponses" then
			if purposetype == "military" then
				C.ResetDefaultResponseToSignalForFaction(signalid, factionorcontrollable, "fight")
				C.ResetDefaultResponseToSignalForFaction(signalid, factionorcontrollable, "auxiliary")
			else
				C.ResetDefaultResponseToSignalForFaction(signalid, factionorcontrollable, "")
			end
		end
	else
		local ask
		if mode == "controllableresponses" then
			ask = C.GetAskToSignalForControllable(signalid, factionorcontrollable)
			C.SetDefaultResponseToSignalForControllable(newresponseid, ask, signalid, factionorcontrollable)
		else
			ask = C.GetAskToSignalForFaction(signalid, factionorcontrollable)
			if purposetype == "military" then
				C.SetDefaultResponseToSignalForFaction2(newresponseid, ask, signalid, factionorcontrollable, "fight")
				C.SetDefaultResponseToSignalForFaction2(newresponseid, ask, signalid, factionorcontrollable, "auxiliary")
			else
				C.SetDefaultResponseToSignalForFaction2(newresponseid, ask, signalid, factionorcontrollable, "")
			end
		end
	end
end

function menu.dropdownOrdersResupply(_, id)
	C.SetPlayerGlobalLoadoutLevel(tonumber(id))
end

function menu.dropdownOrdersCargoReservations(_, id)
	C.SetPlayerTradeLoopCargoReservationSetting(id == "on")
end

function menu.dropdownOrdersBuildRule(_, id)
	C.SetFactionBuildMethod("player", id)
end

function menu.hotkey(action)
	if action == "INPUT_ACTION_ADDON_DETAILMONITOR_CLOSE_PLAYERINFO" then
		menu.closeMenu("close")
	end
end

function menu.onShowMenu(state)
	-- reset settings
	C.SetUICoverOverride(false)
	menu.noupdate = nil
	menu.topRows = {}
	menu.selectedRows = {}
	menu.selectedCols = {}
	menu.messageData.curEntry = {}

	-- Register bindings
	Helper.setKeyBinding(menu, menu.hotkey)
	RegisterAddonBindings("ego_detailmonitor", "playerinfo")

	-- Init
	menu.playerInfoFullWidth = Helper.viewWidth - (Helper.playerInfoConfig.offsetX + Helper.frameBorder + Helper.borderSize)

	menu.sideBarWidth = Helper.scaleX(Helper.sidebarWidth)
	local availableLeftBarHeight = Helper.viewHeight - (Helper.playerInfoConfig.offsetY + Helper.playerInfoConfig.height + Helper.borderSize + menu.sideBarWidth + Helper.scaleY(Helper.titleTextProperties.height) + 3 * Helper.borderSize)
	local count, bordercount = 0, 0
	for _, entry in ipairs(config.leftBar) do
		if not entry.condition or entry.condition() then
			if entry.spacing then
				count = count + 0.25
				bordercount = bordercount + 1
			else
				count = count + 1
				bordercount = bordercount + 1
			end
		end
	end
	if (count * menu.sideBarWidth + bordercount * Helper.borderSize) > availableLeftBarHeight then
		menu.sideBarWidth = math.floor((availableLeftBarHeight - bordercount * Helper.borderSize) / count)
	end

	menu.contextMenuWidth = Helper.scaleX(200)

	menu.mode = menu.param[3] or menu.mode or config.mode
	-- cleanup parameter, so we are not returned automatically to the original mode when opening another menu/conversation from this menu (but a different mode)
	menu.param[3] = nil

	menu.expandedTransactionEntry = {}
	menu.transactionSearchString = ""

	menu.initEmpireData()

	Helper.setTabScrollCallback(menu, menu.onTabScroll)
	registerForEvent("inputModeChanged", getElement("Scene.UIContract"), menu.onInputModeChanged)

	if state then
		menu.onRestoreState(state)
	end

	menu.holomapcolor = Helper.getHoloMapColors()

	-- display main frame
	menu.createMainFrame()

	AddUITriggeredEvent(menu.name, menu.mode)

	-- display info
	menu.createInfoFrame()
end

function menu.onSaveState()
	local state = {}

	state.settoprow = GetTopRow(menu.infoTable)
	state.setselectedrow = Helper.currentTableRow[menu.infoTable]

	return state
end

function menu.onRestoreState(state)
	menu.settoprow = state.settoprow
	menu.setselectedrow = state.setselectedrow
end

function menu.createMainFrame()
	local frameProperties = {
		standardButtons = { back = true, close = true },
		standardButtonX = Helper.playerInfoConfig.offsetX,
		standardButtonY = Helper.playerInfoConfig.offsetY,
		width = Helper.viewWidth,
		height = Helper.viewHeight,
		x = 0,
		y = 0,
		layer = config.mainLayer,
		standardButtons = { back = true, close = true, help = true  },
	}

	menu.mainFrame = Helper.createFrameHandle(menu, frameProperties)
	menu.mainFrame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	menu.createPlayerInfo(menu.mainFrame, Helper.playerInfoConfig.width, Helper.playerInfoConfig.height, Helper.playerInfoConfig.offsetX, Helper.playerInfoConfig.offsetY)

	menu.mainFrame:display()
end

function menu.createPlayerInfo(frame, width, height, offsetx, offsety)
	-- kuertee start: callback
	if callbacks ["createPlayerInfo_on_start"] then
		for _, callback in ipairs (callbacks ["createPlayerInfo_on_start"]) do
			callback (config)
		end
	end
	-- kuertee end: callback

	local ftable = frame:addTable(2, { tabOrder = 3, scaling = false, borderEnabled = false, x = offsetx, y = offsety, reserveScrollBar = false })
	ftable:setColWidth(1, menu.sideBarWidth, false)
	ftable:setColWidth(2, width - menu.sideBarWidth - Helper.borderSize, false)

	local row = ftable:addRow(false, { fixed = true, bgColor = Color["player_info_background"] })
	local icon = row[1]:setColSpan(2):createIcon(function () local logo = C.GetCurrentPlayerLogo(); return ffi.string(logo.icon) end, { width = height, height = height, color = Helper.getPlayerLogoColor })

	local textheight = math.ceil(C.GetTextHeight(Helper.playerInfoConfigTextLeft(), Helper.standardFont, Helper.playerInfoConfig.fontsize, width - height - Helper.borderSize))
	icon:setText(Helper.playerInfoConfigTextLeft,		{ fontsize = Helper.playerInfoConfig.fontsize, halign = "left",  x = height + Helper.borderSize, y = (height - textheight) / 2 })
	icon:setText2(Helper.playerInfoConfigTextRight,		{ fontsize = Helper.playerInfoConfig.fontsize, halign = "right", x = Helper.borderSize,          y = (height - textheight) / 2 })

	local spacingHeight = menu.sideBarWidth / 4
	row = ftable:addRow(false, { fixed = true, bgColor = Color["row_background_blue"] })
	row[1]:createText(" ", { minRowHeight = menu.sideBarWidth + Helper.scaleY(Helper.titleTextProperties.height) + 2 * Helper.borderSize })
	for _, entry in ipairs(config.leftBar) do
		if not entry.condition or entry.condition() then
			if entry.spacing then
				row = ftable:addRow(false, { fixed = true, bgColor = Color["row_background_blue"] })
				row[1]:createIcon("mapst_seperator_line", { width = menu.sideBarWidth, height = spacingHeight })
			else
				row = ftable:addRow(true, { fixed = true, bgColor = Color["row_background_blue"] })
				row[1]:createButton({ active = entry.active, height = menu.sideBarWidth, bgColor = (menu.mode == entry.mode) and Color["row_background_selected"] or Color["row_title_background"], mouseOverText = entry.name, helpOverlayID = entry.helpOverlayID, helpOverlayText = entry.helpOverlayText }):setIcon(entry.icon, { color = entry.iconcolor })
				row[1].handlers.onClick = function () return menu.buttonTogglePlayerInfo(entry.mode) end
			end
		end
	end

	ftable:addConnection(1, 1, true)
end

function menu.createTopLevel(frame)
	menu.topLevelHeight = Helper.createTopLevelTab(menu, "playerinfo", frame, "", nil, true)
end

function menu.onTabScroll(direction)
	if direction == "right" then
		Helper.scrollTopLevel(menu, "playerinfo", 1)
	elseif direction == "left" then
		Helper.scrollTopLevel(menu, "playerinfo", -1)
	end
end

function menu.onInputModeChanged(_, mode)
	if not menu.noupdate then
		menu.refreshInfoFrame()
	else
		menu.inputModeHasChanged = true
	end
end

function menu.createInfoFrame()
	-- kuertee start: callback
	if callbacks ["createInfoFrame_on_start"] then
		for _, callback in ipairs (callbacks ["createInfoFrame_on_start"]) do
			callback (menu.infoFrame, tableProperties)
		end
	end
	-- kuertee end: callback

	-- remove old data
	Helper.clearDataForRefresh(menu, config.infoLayer)

	local width = Helper.playerInfoConfig.width
	if (menu.mode == "empire") or (menu.mode == "globalorders") or (menu.mode == "messages") or (menu.mode == "factions") then
		width = menu.playerInfoFullWidth
	end

	local frameProperties = {
		standardButtons = {},
		width = Helper.viewWidth,
		height = Helper.viewHeight,
		x = 0,
		y = 0,
		layer = config.infoLayer,
	}

	menu.infoFrame = Helper.createFrameHandle(menu, frameProperties)

	if not menu.messageData.showFullscreen then
		menu.createTopLevel(menu.infoFrame)
	end

	local tableProperties = {
		width = width - menu.sideBarWidth - Helper.borderSize,
		x = Helper.playerInfoConfig.offsetX + menu.sideBarWidth + Helper.borderSize,
		y = math.max(Helper.playerInfoConfig.offsetY + Helper.playerInfoConfig.height + Helper.borderSize, menu.topLevelHeight),
	}
	tableProperties.height = Helper.viewHeight - tableProperties.y

	Helper.clearTableConnectionColumn(menu, 2)
	Helper.clearTableConnectionColumn(menu, 3)

	if menu.mode == "inventory" then
		menu.createInventory(menu.infoFrame, tableProperties)
	elseif menu.mode == "crafting" then
		menu.createCrafting(menu.infoFrame, tableProperties)
	elseif menu.mode == "equipmentmods" then
		menu.createEquipmentMods(menu.infoFrame, tableProperties)
	elseif menu.mode == "spacesuit" then
		menu.createInventory(menu.infoFrame, tableProperties, "personalupgrade")
	elseif menu.mode == "globalorders" then
		menu.createEmpire(menu.infoFrame, tableProperties)
	elseif menu.mode == "factions" then
		menu.createFactions(menu.infoFrame, tableProperties)
	elseif menu.mode == "transactionlog" then
		tableProperties.width = tableProperties.width * 5 / 4
		tableProperties.x2 = Helper.frameBorder
		Helper.createTransactionLog(menu.infoFrame, C.GetPlayerID(), tableProperties, menu.refreshInfoFrame, { toprow = menu.settoprow, selectedrow = menu.setselectedrow })
		menu.lastTransactionLogRefreshTime = getElapsedTime()
	elseif menu.mode == "empire" then
		menu.createEmpire(menu.infoFrame, tableProperties)
	elseif menu.mode == "accounts" then
		tableProperties.width = tableProperties.width * 3 / 2
		menu.createAccounts(menu.infoFrame, tableProperties)
	elseif menu.mode == "stats" then
		menu.createStats(menu.infoFrame, tableProperties)
	elseif menu.mode == "logbook" then
		tableProperties.width = tableProperties.width * 5 / 4
		menu.createLogbook(menu.infoFrame, tableProperties)
	elseif menu.mode == "messages" then
		menu.createMessages(menu.infoFrame, tableProperties)
	elseif menu.mode == "personnel" then
		menu.createPersonnelInfo(menu.infoFrame, tableProperties)
	elseif menu.mode == "venturecontacts" then
		if not menu.ventureContactCallbacksRegistered then
			menu.ventureContactCallbacksRegistered = true
			Helper.registerVentureContactCallbacks(menu)
		end
		Helper.createVentureContacts(menu, menu.infoFrame, "left", tableProperties.width, tableProperties.x, tableProperties.y, tableProperties.x, tableProperties.y)
	end

	-- kuertee start: callback
	if callbacks ["createInfoFrame_on_info_frame_mode"] then
		for _, callback in ipairs (callbacks ["createInfoFrame_on_info_frame_mode"]) do
			callback (menu.infoFrame, tableProperties)
		end
	end
	-- kuertee end: callback

	menu.infoFrame:display()
end

function menu.createInventory(frame, tableProperties, mode, tabOrderOffset)
	local narrowtablewidth = Helper.playerInfoConfig.width - menu.sideBarWidth - Helper.borderSize

	if not tabOrderOffset then
		tabOrderOffset = 0
	end
	menu.skipread = true

	local isonline = Helper.isOnlineGame()
	-- show venture inventory partially if we have permanent online items
	local onlineitems = OnlineGetUserItems()
	for ware, waredata in pairs(onlineitems) do
		local isoperationvolatile, isseasonvolatile = GetWareData(ware, "isoperationvolatile", "isseasonvolatile")
		if (not isoperationvolatile) and (not isseasonvolatile) then
			isonline = true
			break
		end
	end

	if menu.inventoryData.mode == "online" then
		if not isonline then
			menu.inventoryData.mode = "normal"
		end
	end

	if (menu.inventoryData.mode == "normal") or (menu.inventoryData.mode == "drop") or (mode == "personalupgrade") then
		local infotable = frame:addTable(4, { tabOrder = 1 + tabOrderOffset, borderEnabled = true, width = tableProperties.width, maxVisibleHeight = tableProperties.height, multiSelect = true, x = tableProperties.x, y = tableProperties.y })
		menu.inventoryInfoTable = infotable
		if menu.setdefaulttable then
			infotable.properties.defaultInteractiveObject = true
			menu.setdefaulttable = nil
		end
		infotable:setColWidth(2, tableProperties.width / 8, false)
		infotable:setColWidth(3, tableProperties.width / 5, false)
		infotable:setColWidth(4, tableProperties.width / 5, false)
		infotable:setDefaultBackgroundColSpan(1, 4)

		-- title
		local row = infotable:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
		row[1]:setColSpan(4):createText((mode == "personalupgrade") and ReadText(1001, 7716) or ReadText(1001, 2202), Helper.titleTextProperties)

		local wareCategories = {}
		local wareCategoryIdx = {}
		for i, entry in ipairs(config.inventoryCategories) do
			wareCategoryIdx[entry.id] = i
			table.insert(wareCategories, { id = entry.id, name = entry.name, data = {} })
		end

		menu.inventory = GetPlayerInventory()
		menu.onlineitems = OnlineGetUserItems()
		for ware, waredata in Helper.orderedPairs(menu.inventory) do
			local iscraftingresource, ismodpart, isprimarymodpart, ispersonalupgrade, tradeonly, ispaintmod, isbraneitem = GetWareData(ware, "iscraftingresource", "ismodpart", "isprimarymodpart", "ispersonalupgrade", "tradeonly", "ispaintmod", "isbraneitem")
			if iscraftingresource or ismodpart or isprimarymodpart then
				table.insert(wareCategories[wareCategoryIdx["crafting"]].data, ware)
			elseif ispersonalupgrade then
				table.insert(wareCategories[wareCategoryIdx["upgrade"]].data, ware)
			elseif tradeonly then
				table.insert(wareCategories[wareCategoryIdx["tradeonly"]].data, ware)
			elseif ispaintmod then
				table.insert(wareCategories[wareCategoryIdx["paintmod"]].data, ware)
			elseif (not menu.onlineitems[ware]) and (not isbraneitem) then
				table.insert(wareCategories[wareCategoryIdx["useful"]].data, ware)
			end
		end
		for i, entry in ipairs(config.inventoryCategories) do
			table.sort(wareCategories[i].data, Helper.sortWareName)
		end

		menu.inventoryData.policefaction = GetComponentData(ConvertStringToLuaID(tostring(C.GetPlayerZoneID())), "policefaction")

		menu.inventoryData.lockboxes = {}
		local player = C.GetPlayerID()
		local n = C.GetNumAvailableLockboxes(player)
		local buf = ffi.new("const char*[?]", n)
		n = C.GetAvailableLockboxes(buf, n, player)
		for i = 0, n - 1 do
			table.insert(menu.inventoryData.lockboxes, GetWareData(ffi.string(buf[i]), "component"))
		end

		local totalprice = 0
		local totalonlineprice = 0
		local found = false
		if next(menu.inventory) then
			-- header
			row = infotable:addRow(ware, { fixed = true, bgColor = Color["row_background_unselectable"] })
			row[1]:setBackgroundColSpan(4):createText(ReadText(1001, 95), { font = Helper.standardFontBold })
			row[2]:createText(ReadText(1001, 1202), config.rightAlignBoldTextProperties)
			row[3]:createText(ReadText(1001, 2413), config.rightAlignBoldTextProperties)
			row[4]:createText(ReadText(1001, 2927), config.rightAlignBoldTextProperties)

			row = infotable:addRow(false, { fixed = true, bgColor = Color["row_separator"] })
			row[1]:setColSpan(4):createText("", {height = 1})

			-- entries
			for _, entry in ipairs(wareCategories) do
				if #entry.data > 0 then
					if (mode == "personalupgrade") == (entry.id == "upgrade") then
						found = true
						if mode ~= "personalupgrade" then
							row = infotable:addRow(nil, {  })
							row[1]:setColSpan(4):createText(entry.name, Helper.subHeaderTextProperties)
							row[1].properties.halign = "center"

							row[1].properties.helpOverlayID = "playerinfo_inventory_" .. entry.id
							row[1].properties.helpOverlayText = " "
							row[1].properties.helpOverlayHeight = row:getHeight()
							row[1].properties.helpOverlayHighlightOnly = true
							row[1].properties.helpOverlayScaling = false
						end
						for _, ware in ipairs(entry.data) do
							local waredata = menu.inventory[ware]
							local isequipment, avgprice = GetWareData(ware, "isequipment", "avgprice")
							if not next(menu.inventoryData.selectedWares) then
								menu.inventoryData.selectedWares[ware] = true
							end
							menu.addInventoryWareEntry(infotable, ware, waredata, nil, nil, isequipment, entry.id == "online")
							totalprice = totalprice + avgprice * waredata.amount
							row[1].properties.helpOverlayHeight = row[1].properties.helpOverlayHeight + row:getHeight() + Helper.borderSize
						end
					end
				end
			end

		end
		if not found then
			row = infotable:addRow(true, { interactive = false })
			row[1]:setColSpan(4):createText("-- " .. ReadText(1001, 32) .. " --", { halign = "center" })
		end

		infotable:setTopRow(menu.settoprow)
		if not menu.setselectedrow2 then
			infotable:setSelectedRow(menu.setselectedrow)
		else
			infotable:setSelectedRow(menu.setselectedrow2)
		end
		menu.settoprow = nil
		menu.setselectedrow = nil
		menu.setselectedrow2 = nil

		-- buttons
		local buttontable = frame:addTable(3, { tabOrder = 2 + tabOrderOffset, borderEnabled = true, width = tableProperties.width, x = tableProperties.x, y = tableProperties.y })
		menu.inventoryButtonTable = buttontable

		local row = buttontable:addRow(false, { fixed = true })
		row[1]:setColSpan(3):createText("")

		if mode ~= "personalupgrade" then
			local row = buttontable:addRow(false, { fixed = true })
			row[1]:setColSpan(3):createText(" ", { titleColor = Color["row_title"] })
			local row = buttontable:addRow(false, { fixed = true, bgColor = Color["row_background_unselectable"] })
			row[1]:setBackgroundColSpan(3):setColSpan(2):createText(ReadText(1001, 2442), {  })
			row[3]:createText(ConvertMoneyString(totalprice, false, true, 0, true) .. " " .. ReadText(1001, 101), config.rightAlignTextProperties)

			buttontable:addEmptyRow(Helper.standardTextHeight / 2)
		end

		local row = buttontable:addRow(nil, { fixed = true })
		row[1]:setColSpan(3):createText(ReadText(1001, 7735), Helper.subHeaderTextProperties)
		row[1].properties.halign = "center"

		local curOption = menu.inventoryData.dropLockbox or "none"
		local options = {
			{ id = "none", text = ReadText(1001, 7731), icon = "", displayremoveoption = false }
		}
		for _, box in ipairs(menu.inventoryData.lockboxes) do
			if (menu.inventoryData.dropLockbox == nil) and (curOption == "none") then
				menu.inventoryData.dropLockbox = box
				menu.inventoryData.defaultLockbox = box
				curOption = box
			end
			table.insert(options, { id = box, text = GetMacroData(box, "name"), icon = "", displayremoveoption = false })
		end

		local row
		if menu.inventoryData.mode == "drop" then
			for _, entry in ipairs(menu.inventoryData.dropWares) do
				local slidermax = entry.amount
				row = buttontable:addRow(true, { fixed = true })
				row[1]:setColSpan(3):createSliderCell({ height = Helper.standardButtonHeight, valueColor = Color["slider_value"], min = 0, minSelect = 1, max = slidermax, start = slidermax }):setText(GetWareData(entry.ware, "name"))
				row[1].handlers.onSliderCellChanged = function (_, value) return menu.slidercellInventoryDrop(entry.ware, value) end
			end

			row = buttontable:addRow(false, { fixed = true })
			row[1]:setColSpan(3):createText("")

			row = buttontable:addRow(true, { fixed = true })
			row[1]:createText(ReadText(1001, 7732))
			row[2]:setColSpan(2):createDropDown(options, { startOption = curOption })
			row[2].handlers.onDropDownConfirmed = menu.dropdownInventoryLockbox

			row = buttontable:addRow(true, { fixed = true })
			-- cancel button
			row[3]:createButton():setText(ReadText(1001, 64), { halign = "center" })
			row[3].handlers.onClick = menu.buttonInventoryCancel
		else
			row = buttontable:addRow(true, { fixed = true })
		end
		-- drop item button
		row[1]:createButton({ active = menu.inventoryData.mode == "drop", helpOverlayID = "playerinfo_inventory_drop", helpOverlayText = " ", helpOverlayHighlightOnly = true }):setText((menu.inventoryData.dropWares and (#menu.inventoryData.dropWares > 1)) and ReadText(1001, 7733) or ReadText(1001, 7705), { halign = "center" })
		row[1].handlers.onClick = menu.buttonInventoryDrop

		if menu.inventoryData.mode ~= "drop" then
			local hasillegalwares = false
			for ware in pairs(menu.inventory) do
				if menu.inventoryData.policefaction and IsWareIllegalTo(ware, "player", menu.inventoryData.policefaction) then
					hasillegalwares = true
					break
				end
			end

			row = buttontable:addRow(true, { fixed = true })
			row[1]:createButton({ active = hasillegalwares, helpOverlayID = "playerinfo_inventory_dropallillegal", helpOverlayText = " ", helpOverlayHighlightOnly = true }):setText(ReadText(1001, 7734), { halign = "center" })
			row[1].handlers.onClick = function () return menu.buttonInventoryDropAll(true) end
		end

		if isonline and (mode ~= "personalupgrade") then
			local headertable = menu.createInventoryHeader(frame, tableProperties)

			local maxVisibleHeight = infotable.properties.maxVisibleHeight - buttontable:getFullHeight() - headertable:getFullHeight() - Helper.borderSize - Helper.frameBorder
			infotable.properties.y = headertable.properties.y + headertable:getFullHeight() + Helper.borderSize
			buttontable.properties.y = infotable.properties.y + math.min(maxVisibleHeight, infotable:getFullHeight())
			infotable.properties.maxVisibleHeight = buttontable.properties.y - infotable.properties.y

			headertable:addConnection(1, 2, true)
			infotable:addConnection(2, 2)
			buttontable:addConnection(3, 2)
		else
			local maxVisibleHeight = infotable.properties.maxVisibleHeight - buttontable:getFullHeight() - Helper.frameBorder
			buttontable.properties.y = infotable.properties.y + math.min(maxVisibleHeight, infotable:getFullHeight())
			infotable.properties.maxVisibleHeight = buttontable.properties.y - infotable.properties.y

			infotable:addConnection(1, 2, true)
			buttontable:addConnection(2, 2)
		end

		-- media & description
		if menu.inventoryData.curEntry and next(menu.inventoryData.curEntry) then
			local width = narrowtablewidth
			local height = width
			if height > Helper.viewHeight / 2 then
				height = Helper.viewHeight / 2
				width = height
			end
			local mediaProperties = { width = width, x = Helper.viewWidth - width - Helper.frameBorder, height = height, y = tableProperties.y }

			menu.rendertarget = frame:addRenderTarget(mediaProperties)
			menu.inventoryData.activatecutscene = true

			local descriptiontable = frame:addTable(1, { tabOrder = 0, width = width, x = Helper.viewWidth - width - Helper.frameBorder, y = tableProperties.y + height + Helper.borderSize })
			local row = descriptiontable:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
			row[1]:createText(ReadText(1001, 2404), Helper.titleTextProperties)

			local row = descriptiontable:addRow(nil, { fixed = true })
			row[1]:createText(GetWareData(menu.inventoryData.curEntry[1], "description"), { wordwrap = true })
		end
	elseif menu.inventoryData.mode == "online" then
		if Helper.hasExtension("multiverse") then
			Helper.callExtensionFunction("multiverse", "registerOnlineEvents", menu)
			Helper.callExtensionFunction("multiverse", "createVenturePlayerInventory", menu, menu.infoFrame, "left", "playerinfo", tableProperties)
		end
	end
end

function menu.createInventoryHeader(frame, tableProperties)
	local categories = config.inventoryTabs

	menu.inventoryHeaderTable = frame:addTable(#categories + 1, { tabOrder = 1, x = tableProperties.x, y = tableProperties.y, width = tableProperties.width })
	local ftable = menu.inventoryHeaderTable

	local count = 1
	for i, entry in ipairs(categories) do
		if entry.showtab ~= false then
			if entry.empty then
				ftable:setColWidth(count, menu.sideBarWidth / 2, false)
			else
				ftable:setColWidth(count, menu.sideBarWidth, false)
			end
			count = count + 1
		end
	end

	local row = ftable:addRow("tabs", { fixed = true })
	local count = 1
	for _, entry in ipairs(categories) do
		if not entry.empty then
			local bgcolor = Color["row_title_background"]
			local color = Color["text_normal"]
			if entry.category == menu.inventoryData.mode then
				bgcolor = Color["row_background_selected"]
			end

			local loccount = count
			row[loccount]:createButton({ height = menu.sideBarWidth, bgColor = bgcolor, mouseOverText = entry.name, scaling = false, helpOverlayID = entry.helpOverlayID, helpOverlayText = entry.helpOverlayText }):setIcon(entry.icon, { color = color})
			row[loccount].handlers.onClick = function () return menu.buttonInventorySubMode(entry.category, loccount) end
			count = count + 1
		end
	end

	if menu.selectedRows["inventoryHeaderTable"] then
		ftable.properties.defaultInteractiveObject = true
		ftable:setSelectedRow(menu.selectedRows["inventoryHeaderTable"])
		ftable:setSelectedCol(menu.selectedCols["inventoryHeaderTable"] or 0)
		menu.selectedRows["inventoryHeaderTable"] = nil
		menu.selectedCols["inventoryHeaderTable"] = nil
	end

	return ftable
end

function menu.createCrafting(frame, tableProperties)
	local infotable = frame:addTable(4, { tabOrder = 1, borderEnabled = true, width = tableProperties.width, x = tableProperties.x, y = tableProperties.y, maxVisibleHeight = tableProperties.height })
	if menu.setdefaulttable then
		infotable.properties.defaultInteractiveObject = true
		menu.setdefaulttable = nil
	end
	infotable:setColWidth(2, tableProperties.width / 8, false)
	infotable:setColWidth(3, tableProperties.width / 5, false)
	infotable:setColWidth(4, tableProperties.width / 5, false)
	infotable:setDefaultBackgroundColSpan(1, 4)

	-- title
	local row = infotable:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
	row[1]:setColSpan(4):createText(ReadText(1001, 7701), Helper.titleTextProperties)

	menu.inventory = GetPlayerInventory()
	menu.inventoryData.policefaction = GetComponentData(ConvertStringToLuaID(tostring(C.GetPlayerZoneID())), "policefaction")

	menu.craftable = {}
	if next(menu.inventory) then
		for ware, waredata in pairs(menu.inventory) do
			local ismodpart, isequipment = GetWareData(ware, "ismodpart", "isequipment")
			if (not ismodpart) and (not isequipment) then
				local hasproduction, products, issinglecraft, iscrafting = GetWareData(ware, "hasproductionmethod", "products", "issinglecraft", "iscrafting")
				if (not issinglecraft) or (waredata.amount < 1) then
					if iscrafting and hasproduction then
						menu.createCraftableEntry(ware)
					elseif next(products) then
						for _, product in ipairs(products) do
							menu.createCraftableEntry(product)
						end
					end
				end
			end
		end

		table.sort(menu.craftable, function (a, b) return a.data.name < b.data.name end)
	end

	if next(menu.craftable) then
		-- header
		row = infotable:addRow(ware, {  })
		row[1]:createText(ReadText(1001, 45))
		row[2]:createText(ReadText(1001, 1202), config.rightAlignTextProperties)
		row[3]:createText(ReadText(1001, 2413), config.rightAlignTextProperties)
		row[4]:createText(ReadText(1001, 2927), config.rightAlignTextProperties)

		-- entries
		for i, product in ipairs(menu.craftable) do
			AddKnownItem("productionmethods", GetWareData(product.ware, "productionmethod"))
			if product.resources.count > 0 then
				menu.addInventoryWareEntry(infotable, product.ware, product.data, true)
				for _, resource in ipairs(product.resources) do
					menu.addInventoryWareEntry(infotable, resource.ware, resource.data, true, true)
				end
			end
		end
	else
		row = infotable:addRow(true, {  })
		row[1]:setColSpan(4):createText("-- " .. ReadText(1001, 32) .. " --", { halign = "center" })
	end

	infotable:setTopRow(menu.settoprow)
	infotable:setSelectedRow(menu.setselectedrow)
	menu.settoprow = nil
	menu.setselectedrow = nil

	-- history & buttons
	local buttontable = frame:addTable(3, { tabOrder = 2, borderEnabled = true, width = tableProperties.width, x = tableProperties.x, y = tableProperties.y })
	local row
	if menu.inventoryData.craftingHistory[1] then
		row = buttontable:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
		row[1]:setColSpan(3):createText(ReadText(1001, 7707), Helper.titleTextProperties)

		for i = 1, math.min(3, #menu.inventoryData.craftingHistory) do
			local entry = menu.inventoryData.craftingHistory[i]

			row = buttontable:addRow(nil, { fixed = true })
			row[1]:setColSpan(2):createText(entry.amount .. ReadText(1001, 42) .. " " .. entry.ware[2].name)
			row[3]:createText(Helper.convertGameTimeToXTimeString(entry.time), config.rightAlignTextProperties)
		end

		row = buttontable:addRow(nil, { fixed = true })
		row[1]:setColSpan(3):createText("")
	end
	if menu.inventoryData.mode == "craft" then
		row = buttontable:addRow(true, { fixed = true })

		local slidermax = menu.inventoryData.craftWare[2].craftable
		row[1]:setColSpan(3):createSliderCell({ height = Helper.standardButtonHeight, valueColor = Color["slider_value"], min = 0, minSelect = 1, max = slidermax, start = 1 }):setText(menu.inventoryData.craftWare[2].name)
		row[1].handlers.onSliderCellChanged = menu.slidercellInventoryCraft

		row = buttontable:addRow(true, { fixed = true })
		-- cancel button
		row[3]:createButton():setText(ReadText(1001, 64), { halign = "center" })
		row[3].handlers.onClick = menu.buttonInventoryCancel
	else
		row = buttontable:addRow(true, { fixed = true })
	end
	-- craft item button
	row[1]:createButton({ active = true }):setText(ReadText(1001, 7706), { halign = "center" })
	row[1].handlers.onClick = menu.buttonInventoryCraft

	infotable.properties.maxVisibleHeight = infotable.properties.maxVisibleHeight - buttontable:getFullHeight() - Helper.frameBorder
	buttontable.properties.y = buttontable.properties.y + infotable:getMaxVisibleHeight()

	infotable:addConnection(1, 2, true)
	buttontable:addConnection(2, 2)
end

function menu.createEquipmentMods(frame, tableProperties)
	-- STATUS
	local statustable = frame:addTable(1, { tabOrder = 0, width = tableProperties.width, x = tableProperties.x, y = 0 })

	local row = statustable:addRow(false, { fixed = true, bgColor = Color["row_title_background"] })
	row[1]:createText(ReadText(1001, 2427), Helper.titleTextProperties)

	local row = statustable:addRow(false, { fixed = true })
	row[1]:createText(ReadText(1001, 7715), { wordwrap = true })

	statustable.properties.maxVisibleHeight = statustable:getFullHeight()
	statustable.properties.y = tableProperties.y + tableProperties.height - statustable:getVisibleHeight() - Helper.frameBorder

	-- MOD LIST
	local infotable = frame:addTable(6, { tabOrder = 1, borderEnabled = true, width = tableProperties.width, x = tableProperties.x, y = tableProperties.y, maxVisibleHeight = statustable.properties.y - tableProperties.y - Helper.borderSize })
	if menu.setdefaulttable then
		infotable.properties.defaultInteractiveObject = true
		menu.setdefaulttable = nil
	end
	infotable:setColWidth(1, config.rowHeight, true)
	infotable:setColWidth(2, config.rowHeight, true)
	infotable:setColWidth(4, config.modCountColumnWidth)
	infotable:setColWidth(5, config.modCountColumnWidth)
	infotable:setColWidth(6, config.modCountColumnWidth)
	infotable:setDefaultBackgroundColSpan(2, 5)

	-- title
	local row = infotable:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
	row[1]:setColSpan(6):createText(ReadText(1001, 8031), Helper.titleTextProperties)

	menu.inventory = GetPlayerInventory()
	menu.modwares = {}
	local n = C.GetNumAvailableEquipmentMods()
	local buf = ffi.new("UIEquipmentMod[?]", n)
	n = C.GetAvailableEquipmentMods(buf, n)
	for i = 0, n - 1 do
		local entry = {}
		entry.ware = ffi.string(buf[i].Ware)

		local modclass, modquality, rawresources = GetWareData(entry.ware, "modclass", "modquality", "resources")
		entry.quality = modquality

		entry.resources = {}
		for _, resource in ipairs(rawresources or {}) do
			local resourcedata = menu.inventory[resource.ware]
			if resourcedata then
				local isprimarymodpart = GetWareData(resource.ware, "isprimarymodpart")
				local maxcraftable = math.floor(resourcedata.amount / resource.amount)
				entry.craftableamount = entry.craftableamount and math.min(maxcraftable, entry.craftableamount) or maxcraftable
				table.insert(entry.resources, isprimarymodpart and 1 or (#entry.resources + 1), { ware = resource.ware, data = { name = resourcedata.name, amount = resourcedata.amount, price = resourcedata.price, needed = resource.amount } })
			else
				local resourcename, resourcebuyprice, isprimarymodpart = GetWareData(resource.ware, "name", "buyprice", "isprimarymodpart")
				entry.craftableamount = 0
				table.insert(entry.resources, isprimarymodpart and 1 or (#entry.resources + 1), { ware = resource.ware, data = { name = resourcename, amount = 0, price = resourcebuyprice, needed = resource.amount } })
			end
		end

		if menu.modwares[modclass] then
			table.insert(menu.modwares[modclass], entry)
		else
			menu.modwares[modclass] = { entry }
		end
	end

	for _, entry in ipairs(config.equipmentModClasses) do
		local isclassexpanded = menu.isEquipmentModExpanded(entry.modclass, "")

		local qualitycounts = {
			[0] = 0, -- default value in ModDB, handle but don't use
			[1] = 0,
			[2] = 0,
			[3] = 0,
		}
		for _, modware in ipairs(menu.modwares[entry.modclass] or {}) do
			if modware.craftableamount > 0 then
				expandable = true
				qualitycounts[modware.quality] = qualitycounts[modware.quality] + 1
			end
		end

		local row = infotable:addRow(true, { bgColor = Color["row_background_blue"] })
		row[1]:createButton({ height = Helper.standardTextHeight }):setText(isclassexpanded and "-" or "+", { halign = "center" })
		row[1].handlers.onClick = function () return menu.expandWeaponMod(entry.modclass, "", row.index) end
		row[2]:setColSpan(2):createText(entry.name)
		for quality, entry2 in ipairs(Helper.modQualities) do
			row[quality + 3]:createText(qualitycounts[quality] .. " \27[" .. entry2.icon2 .. "]", config.rightAlignTextProperties)
		end

		if isclassexpanded then
			for _, property in ipairs(Helper.modProperties[entry.modclass]) do
				menu.createEquipmentPropertyEntry(infotable, entry.modclass, property)
			end
		end
	end

	infotable:setTopRow(menu.settoprow)
	infotable:setSelectedRow(menu.setselectedrow)
	menu.settoprow = nil
	menu.setselectedrow = nil

	infotable:addConnection(1, 2, true)
end

function menu.createEquipmentPropertyEntry(ftable, modclass, property)
	local isexpanded = menu.isEquipmentModExpanded(modclass, property.key)

	local expandable = false
	local modwares = {
		[0] = {}, -- default value in ModDB, handle but don't use
		[1] = {},
		[2] = {},
		[3] = {},
	}
	for _, modware in ipairs(menu.modwares[modclass] or {}) do
		local moddef = C.GetEquipmentModInfo(modware.ware)
		local propertytype = ffi.string(moddef.PropertyType)
		if propertytype == property.key then
			expandable = true
			table.insert(modwares[modware.quality], modware)
			if modware.craftableamount > 0 then
				modwares[modware.quality].iscraftable = true
			end
		end
	end
	table.sort(modwares[1], function (a, b) return GetWareData(a.ware, "name") < GetWareData(b.ware, "name") end)
	table.sort(modwares[2], function (a, b) return GetWareData(a.ware, "name") < GetWareData(b.ware, "name") end)
	table.sort(modwares[3], function (a, b) return GetWareData(a.ware, "name") < GetWareData(b.ware, "name") end)
	local color = Color["text_normal"]
	if not expandable then
		color = Color["text_inactive"]
	end

	local row = ftable:addRow(true, { bgColor = Color["row_background_blue"] })
	row[1].properties.cellBGColor = Color["row_background"]
	row[2]:setBackgroundColSpan(1):createButton({ active = expandable, height = Helper.standardTextHeight }):setText(isexpanded and "-" or "+", { halign = "center" })
	row[2].handlers.onClick = function () return menu.expandWeaponMod(modclass, property.key, row.index) end
	row[3]:setBackgroundColSpan(4):createText(property.text, { color = color })
	local minusedcol = 7
	for quality, entry2 in ipairs(Helper.modQualities) do
		if modwares[quality].iscraftable then
			minusedcol = math.min(minusedcol, quality + 3)
			row[quality + 3]:createText("\27[" .. entry2.icon2 .. "]", { halign = "right", color = color })
		end
	end
	row[3]:setColSpan(minusedcol - 3)

	if isexpanded then
		local first = true
		for quality, entry2 in ipairs(Helper.modQualities) do
			if not first then
				ftable:addEmptyRow(config.rowHeight / 2)
			end
			first = false
			for i, modware in ipairs(modwares[quality]) do
				if i ~= 1 then
					ftable:addEmptyRow(config.rowHeight / 2)
				end
				menu.createEquipmentModEntry(ftable, modclass, modware)
			end
		end
	end
end

function menu.createEquipmentModEntry(ftable, modclass, moddata)
	-- mod name
	local row = ftable:addRow(true, { bgColor = Color["row_title_background"], interactive = false })
	row[1].properties.cellBGColor = Color["row_background"]
	row[2].properties.cellBGColor = Color["row_background"]
	row[3]:setColSpan(4):createText("    " .. "\27[" .. Helper.modQualities[moddata.quality].icon2 .. "]" .. GetWareData(moddata.ware, "shortname"), { color = Helper.modQualities[moddata.quality].color })
	-- Resources
	for _, resource in ipairs(moddata.resources) do
		local row = ftable:addRow(true, { interactive = false })
		local color = (resource.data.amount < resource.data.needed) and Color["text_inactive"] or Color["text_normal"]
		-- name
		row[3]:setColSpan(2):createText("       " .. resource.data.name, { color = color })
		-- amount
		row[5]:setColSpan(2):createText(resource.data.amount .. " / " .. resource.data.needed, { halign = "right", color = color })
	end
	-- Effects
	local row = ftable:addRow(true, { interactive = false })
	row[3]:setColSpan(4):createText("     " .. ReadText(1001, 8034) .. ReadText(1001, 120))
	-- Property
	local moddef = C.GetEquipmentModInfo(moddata.ware)
	local propertytype = ffi.string(moddef.PropertyType)
	for i, property in ipairs(Helper.modProperties[modclass]) do
		if property.key == propertytype then
			local minvalue = moddef["MinValue" .. property.type]
			local mineffectcolor = Color["text_normal"]
			if minvalue > property.basevalue then
				mineffectcolor = property.pos_effect and Color["text_positive"] or Color["text_negative"]
			elseif minvalue < property.basevalue then
				mineffectcolor = property.pos_effect and Color["text_negative"] or Color["text_positive"]
			end

			local maxvalue = moddef["MaxValue" .. property.type]
			local maxeffectcolor = Color["text_normal"]
			if maxvalue > property.basevalue then
				maxeffectcolor = property.pos_effect and Color["text_positive"] or Color["text_negative"]
			elseif maxvalue < property.basevalue then
				maxeffectcolor = property.pos_effect and Color["text_negative"] or Color["text_positive"]
			end

			local row = ftable:addRow(true, { interactive = false })
			row[3]:createText("       " .. property.text, { font = Helper.standardFontBold })
			if property.pos_effect and (minvalue < maxvalue) or (minvalue > maxvalue) then
				row[5]:setColSpan(2):createText(property.eval2(minvalue, mineffectcolor, maxvalue, maxeffectcolor), { font = Helper.standardFontBold, halign = "right" })
			else
				row[5]:setColSpan(2):createText(property.eval2(maxvalue, maxeffectcolor, minvalue, mineffectcolor), { font = Helper.standardFontBold, halign = "right" })
			end
			break
		end
	end
	-- Bonus properties
	if moddef.BonusMax > 0 then
		local mouseovertext = ReadText(1026, 8005) .. ReadText(1001, 120)
		for n = 1, moddef.BonusMax do
			-- n < n_max:
			-- p_n = p^n * (1-p)
			-- n == n_max:
			-- p_n_max = p^n_max
			local probability = ((moddef.BonusChance ^ n) * ((n ~= moddef.BonusMax) and (1 - moddef.BonusChance) or 1))
			mouseovertext = mouseovertext .. "\n" .. string.format("%+d %s%s %4.1f%%", n, ReadText(1001, 6602), ReadText(1001, 120), probability * 100)
		end

		local row = ftable:addRow(true, { interactive = false })
		row[3]:setColSpan(2):createText("       " .. ((moddef.BonusMax == 1) and ReadText(1001, 8039) or string.format(ReadText(1001, 8040), moddef.BonusMax)), { mouseOverText = mouseovertext })
		row[5]:setColSpan(2):createText("???", { halign = "right" })
	end
end

function menu.isEquipmentModExpanded(class, property)
	return menu.equipmentModsData.expandedProperties[class .. property]
end

function menu.expandWeaponMod(class, property, row)
	if menu.equipmentModsData.expandedProperties[class .. property] then
		menu.equipmentModsData.expandedProperties[class .. property] = nil
	else
		menu.equipmentModsData.expandedProperties[class .. property] = true
	end

	menu.refreshInfoFrame(nil, row)
end

function menu.isPersonnelExpanded(id)
	return menu.equipmentModsData.expandedProperties[tostring(id)]
end

function menu.expandPersonnel(id, row)
	if menu.equipmentModsData.expandedProperties[tostring(id)] then
		menu.equipmentModsData.expandedProperties[tostring(id)] = nil
	else
		menu.equipmentModsData.expandedProperties[tostring(id)] = true
	end

	if tostring(menu.personnelData.curEntry.id) ~= tostring(id) then
		menu.personnelData.curEntry = {}
	end
	menu.refreshInfoFrame(nil, row)
end

function menu.createFactions(frame, tableProperties)
	local narrowtablewidth = Helper.playerInfoConfig.width - menu.sideBarWidth - Helper.borderSize
	local iconheight = math.ceil(config.rowHeight * 1.5)
	local iconoffset = 2

	local infotable = frame:addTable(3, { tabOrder = 1, borderEnabled = true, width = narrowtablewidth, x = tableProperties.x, y = tableProperties.y })

	-- kuertee start: callback
	infotable:setDefaultCellProperties("text", {minRowHeight = config.rowHeight, fontsize = Helper.standardFontSize})
	infotable:setDefaultCellProperties("button", {height = config.rowHeight})
	-- kuertee end: callback

	if menu.setdefaulttable then
		infotable.properties.defaultInteractiveObject = true
		menu.setdefaulttable = nil
	end
	infotable:setColWidth(1, Helper.scaleX(iconheight) + 2 * iconoffset, false)
	infotable:setColWidthPercent(3, 33)
	infotable:setDefaultBackgroundColSpan(1, 3)

	-- title
	local row = infotable:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
	row[1]:setColSpan(3):createText(ReadText(1001, 7703), Helper.titleTextProperties)
	row[1].properties.height = row[1].properties.height + Helper.borderSize

	-- cover override
	if Helper.isPlayerCovered() then
		local row = infotable:addRow(true, { fixed = true })
		row[1]:createCheckBox(C.IsUICoverOverridden(), { width = Helper.standardTextHeight, height = Helper.standardTextHeight, mouseOverText = ReadText(1026, 7713) })
		row[1].handlers.onClick = function(_, checked) C.SetUICoverOverride(checked); menu.refreshInfoFrame() end
		row[2]:setColSpan(2):createText(ReadText(1001, 11604), { mouseOverText = ReadText(1026, 7713) })
	end

	menu.relations = GetLibrary("factions")
	for i, relation in ipairs(menu.relations) do
		if relation.id == "player" then
			table.remove(menu.relations, i)
			break
		end
	end
	table.sort(menu.relations, Helper.sortName)
	menu.licences = {}
	for i, relation in ipairs(menu.relations) do
		menu.licences[relation.id] = GetOwnLicences(relation.id)
		table.sort(menu.licences[relation.id], menu.sortLicences)
	end

	if #menu.relations == 0 then
		row = infotable:addRow(true, {  })
		row[1]:setColSpan(3):createText("--- " .. ReadText(1001, 38) .. " ---", { halign = "center" })
	else
		for i, relation in ipairs(menu.relations) do
			local shortname = GetFactionData(relation.id, "shortname")
			row = infotable:addRow({ "faction", relation }, {  })
			row[1]:setBackgroundColSpan(3):createIcon((relation.icon ~= "") and relation.icon or "solid", {
				height = iconheight,
				x = iconoffset,
				color = function () return menu.relationColor(relation.id) end,
				mouseOverText = function () local prioritizedrelationrangename = GetFactionData(relation.id, "prioritizedrelationrangename"); return prioritizedrelationrangename end,
				helpOverlayID = "playerinfo_faction_" .. relation.id,
				helpOverlayText = " ",
				helpOverlayHighlightOnly = true,
				helpOverlayUseBackgroundSpan = true,
			})
			row[2]:createText("[" .. shortname .. "] " .. relation.name, { fontsize = 14, color = function () return menu.relationColor(relation.id) end, y = 2 * iconoffset, minRowHeight = iconheight + 2 * iconoffset, mouseOverText = function () local prioritizedrelationrangename = GetFactionData(relation.id, "prioritizedrelationrangename"); return prioritizedrelationrangename end })
			row[3]:createText(
				function () return string.format("%+d", GetUIRelation(relation.id)) end,
				{ font = Helper.standardFontMono, color = function () return menu.relationColor(relation.id) end, fontsize = 14, halign = "right", y = 2 * iconoffset, mouseOverText = function () local prioritizedrelationrangename = GetFactionData(relation.id, "prioritizedrelationrangename"); return prioritizedrelationrangename end })
		end
	end
	infotable:setTopRow(menu.settoprow)
	infotable:setSelectedRow(menu.setselectedrow)
	menu.settoprow = nil
	menu.setselectedrow = nil

	-- faction details
	local detailtable = frame:addTable(3, { tabOrder = 2, width = tableProperties.width - 2 * (narrowtablewidth + Helper.borderSize), x = tableProperties.x + infotable.properties.width + Helper.borderSize, y = infotable.properties.y, highlightMode = "grey" })
	detailtable:setColWidth(1, 2 * Helper.titleHeight)

	local relation = menu.factionData.curEntry

	AddUITriggeredEvent(menu.name, menu.mode, menu.factionData.curEntry.id)

	local row = detailtable:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
	row[1]:setBackgroundColSpan(3):createText(next(relation) and ("\27[" .. relation.icon .. "]") or "", Helper.titleTextProperties)
	local name
	if next(relation) then
		local shortname = GetFactionData(relation.id, "shortname")
		name = "[" .. shortname .. "] " .. relation.name
	end
	row[2]:setColSpan(2):createText(name, Helper.titleTextProperties)
	row[2].properties.height = row[2].properties.height + Helper.borderSize

	if next(relation) then
		local isrelationlocked, relationlockreason, willclaimspace = GetFactionData(relation.id, "isrelationlocked", "relationlockreason", "willclaimspace")
		-- sector ownership
		if not willclaimspace then
			local row = detailtable:addRow(nil, {  })
			row[1]:setColSpan(3):createText(ReadText(1001, 7784))

			detailtable:addEmptyRow(Helper.standardTextHeight / 2)
		end

		-- kuertee start: callback
		if callbacks ["createFactions_on_before_render_licences"] then
			for _, callback in ipairs (callbacks ["createFactions_on_before_render_licences"]) do
				callback (frame, tableProperties, relation.id, detailtable)
			end
		end
		-- kuertee end: callback

		-- licences
		if menu.licences[relation.id] and #menu.licences[relation.id] > 0 then
			local row = detailtable:addRow(nil, {  })
			row[1]:setBackgroundColSpan(3):setColSpan(2):createText(ReadText(1001, 62), Helper.subHeaderTextProperties)
			row[3]:createText(ReadText(1001, 7748), Helper.subHeaderTextProperties)
			row[3].properties.halign = "right"

			for i, licence in ipairs(menu.licences[relation.id]) do
				local row = detailtable:addRow({ "licence", licence.id }, {  })
				local color = Color["text_inactive"]
				if HasLicence("player", licence.type, relation.id) then
					color = Color["text_normal"]
				end
				local name = licence.name
				if licence.precursor then
					name = "    " .. name
				end
				local info
				if licence.price > 0 then
					info = ConvertMoneyString(licence.price, false, true, 0, true) .. " " .. ReadText(1001, 101)
				elseif not licence.precursor then
					info = string.format("%+d", licence.minrelation)
				end
				row[2]:setBackgroundColSpan(2):createText(name, {
					color = color,
					mouseOverText = licence.desc,
					helpOverlayID = "playerinfo_factionlicense_" .. licence.id,
					helpOverlayText = " ",
					helpOverlayHighlightOnly = true,
					helpOverlayUseBackgroundSpan = true,
				})
				row[3]:createText(info, { halign = "right", color = color })
				AddKnownItem("licences", licence.id)
			end

			detailtable:addEmptyRow(Helper.standardTextHeight / 2)
		end
		-- relation
		local row = detailtable:addRow(nil, {  })
		row[1]:setColSpan(3):createText(ReadText(1001, 7749), Helper.subHeaderTextProperties)

		local row = detailtable:addRow(true, {  })
		row[2]:setColSpan(2):createText(ffi.string(C.GenerateFactionRelationText(relation.id)), {
			helpOverlayID = "playerinfo_faction_relation",
			helpOverlayText = " ",
			helpOverlayHighlightOnly = true,
		})

		detailtable:addEmptyRow(Helper.standardTextHeight / 2)
		-- war declaration
		local row = detailtable:addRow(true, {  })
		local active = true
		local mouseovertext
		if GetUIRelation(relation.id) <= -25 then
			active = false
			mouseovertext = ReadText(1026, 7702)
		elseif isrelationlocked then
			active = false
			mouseovertext = (relationlockreason ~= "") and relationlockreason or ReadText(20229, 100)
		end
		row[3]:createButton({ active = active, mouseOverText = mouseovertext }):setText(ReadText(1001, 7750), { halign = "center" })
		row[3].handlers.onClick = function () return menu.buttonWarDeclarationConfirm(relation.id) end

		-- kuertee start: callback
		if callbacks ["createFactions_on_after_declare_war_button"] then
			for _, callback in ipairs (callbacks ["createFactions_on_after_declare_war_button"]) do
				callback (frame, tableProperties, relation.id, detailtable)
			end
		end
		-- kuertee end: callback
	end

	infotable:addConnection(1, 2, true)
	detailtable:addConnection(1, 3, true)
end

function menu.sortLicences(a, b)
	if a.minrelation == b.minrelation then
		if a.precursor == b.precursor then
			if a.price == b.price then
				return a.name < b.name
			end
			return a.price < b.price
		end
		return (not a.precursor) and b.precursor
	end
	return a.minrelation < b.minrelation
end

function menu.relationColor(faction)
	if GetFactionData(faction, "ishostile") then
		return Color["text_hostile"]
	elseif GetFactionData(faction, "isenemy") then
		return Color["text_enemy"]
	else
		return Color["text_normal"]
	end
end

function menu.createStats(frame, tableProperties)
	local infotable = frame:addTable(2, { tabOrder = 1, borderEnabled = true, width = tableProperties.width, x = tableProperties.x, y = tableProperties.y, highlightMode = "grey" })
	if menu.setdefaulttable then
		infotable.properties.defaultInteractiveObject = true
		menu.setdefaulttable = nil
	end
	infotable:setColWidth(1, 2 * tableProperties.width / 3, false)

	-- title
	local row = infotable:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
	row[1]:setColSpan(2):createText(ReadText(1001, 2500), Helper.titleTextProperties)

	local stats = GetAllStatIDs()
	for i = 1, #stats do
		local hidden, displayname = GetStatData(stats[i], "hidden", "displayname")
		if not hidden then
			row = infotable:addRow(stats[i], {})
			row[1]:createText(displayname)
			row[2]:createText(function () return GetStatData(stats[i], "displayvalue") end, { halign = "right", font = Helper.standardFontMono })
		end
	end
	infotable:setTopRow(menu.settoprow)
	infotable:setSelectedRow(menu.setselectedrow)
	menu.settoprow = nil
	menu.setselectedrow = nil

	infotable:addConnection(1, 2, true)
end

function menu.findAccountTransaction(station)
	for i, transaction in ipairs(menu.accountData.transactions) do
		if IsSameComponent(transaction.station, station) then
			return transaction.amount, i
		end
	end

	return 0
end

function menu.getAccountPlayerMoney()
	local playermoney = GetPlayerMoney()
	for _, transaction in ipairs(menu.accountData.transactions) do
		playermoney = playermoney + transaction.amount
	end
	return playermoney
end

function menu.createAccounts(frame, tableProperties, tabOrderOffset)
	if not tabOrderOffset then
		tabOrderOffset = 0
	end
	local infotable = frame:addTable(5, { tabOrder = 1 + tabOrderOffset, borderEnabled = true, width = tableProperties.width, x = tableProperties.x, y = tableProperties.y, maxVisibleHeight = tableProperties.height })
	if menu.setdefaulttable then
		infotable.properties.defaultInteractiveObject = true
		menu.setdefaulttable = nil
	end
	infotable:setColWidthPercent(1, 25)

	-- title
	local row = infotable:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
	row[1]:setColSpan(5):createText(ReadText(1001, 7708), Helper.titleTextProperties)

	row = infotable:addRow(nil, { fixed = true, bgColor = Color["row_background_unselectable"] })
	row[1]:setBackgroundColSpan(5)
	row[2]:createText(ReadText(1001, 7773), { font = Helper.standardFontBold })
	row[5]:createText(ReadText(1001, 6509), { font = Helper.standardFontBold })

	local playermoney = menu.getAccountPlayerMoney()

	menu.accountData.stations = GetContainedStationsByOwner("player")
	table.sort(menu.accountData.stations, Helper.sortComponentName)
	if #menu.accountData.stations > 0 then
		for i, station in ipairs(menu.accountData.stations) do
			local name, sector, stationmoney, productionmoney, buildstorage = GetComponentData(station, "name", "sector", "money", "productionmoney", "buildstorage")
			local station64 = ConvertIDTo64Bit(station)
			-- station name
			local mouseovertext = ReadText(20001, 201) .. ReadText(1001, 120) .. " " .. sector
			local row = infotable:addRow(false, { bgColor = Color["row_background_blue"] })
			row[1]:setColSpan(5):createText(name .. " (" .. ffi.string(C.GetObjectIDCode(station64)) .. ")", Helper.subHeaderTextProperties)
			row[1].properties.color = menu.holomapcolor.playercolor
			row[1].properties.mouseOverText = mouseovertext

			-- station account
			local transaction = menu.findAccountTransaction(station)
			local row = infotable:addRow(true, {  })
			row[1]:createText(ReadText(1001, 7710) .. ReadText(1001, 120), { x = Helper.standardTextHeight })
			row[2]:createText(ConvertMoneyString(stationmoney - transaction, false, true, nil, true) .. " " .. ReadText(1001, 101), { halign = "right" })
			row[3]:setColSpan(2):createSliderCell({ min = math.min((-playermoney + transaction), transaction), max = math.max(stationmoney, transaction), start = transaction, fromCenter = true, suffix = ReadText(1001, 101), height = config.rowHeight })
			row[3].handlers.onSliderCellChanged = function (_, value) return menu.slidercellAccountChanged(station, row.index, value, infotable.id) end
			row[3].handlers.onSliderCellConfirm = function () menu.refreshdata = { nil, nil, "accounts", row.index } menu.refresh = getElapsedTime() + 0.1 end
			row[5]:createText(ConvertMoneyString(playermoney, false, true, nil, true) .. " " .. ReadText(1001, 101), { halign = "left" })

			-- station estimated budget
			local supplymoney = tonumber(C.GetSupplyBudget(station64)) / 100
			local tradewaremoney = tonumber(C.GetTradeWareBudget(station64)) / 100
			local row = infotable:addRow(true, {  })
			row[1]:createText(ReadText(1001, 9434) .. ReadText(1001, 120), { x = Helper.standardTextHeight })
			local mouseovertext =	ReadText(1001, 8420) .. ReadText(1001, 120) .. " " .. ConvertMoneyString(productionmoney, false, true, 0, true)	.. " " .. ReadText(1001, 101) .. "\n" ..
									ReadText(1001, 8423) .. ReadText(1001, 120) .. " " .. ConvertMoneyString(supplymoney, false, true, 0, true)		.. " " .. ReadText(1001, 101) .. "\n" ..
									ReadText(1001, 8447) .. ReadText(1001, 120) .. " " .. ConvertMoneyString(tradewaremoney, false, true, 0, true)	.. " " .. ReadText(1001, 101)
			row[2]:createText(ConvertMoneyString(productionmoney + supplymoney + tradewaremoney, false, true, 0, true) .. " " .. ReadText(1001, 101), { halign = "right", mouseOverText = mouseovertext })
			row[5]:createButton({ active = function () local money, estimate = GetComponentData(station64, "money", "productionmoney"); estimate = estimate + tonumber(C.GetSupplyBudget(station64)) / 100 + tonumber(C.GetTradeWareBudget(station64)) / 100; return (money + GetPlayerMoney()) > estimate end }):setText(ReadText(1001, 7965), { halign = "center", fontsize = config.mapFontSize })
			row[5].handlers.onClick = function () return menu.buttonAccountToEstimate(station) end

			infotable:addEmptyRow(Helper.standardTextHeight / 2)

			-- buildstorage account
			if buildstorage then
				local buildstorage64 = ConvertIDTo64Bit(buildstorage)
				local buildstoragemoney, wantedmoney = GetComponentData(buildstorage64, "money", "wantedmoney")

				local transaction = menu.findAccountTransaction(buildstorage)
				local row = infotable:addRow(true, {  })
				row[1]:createText(ReadText(1001, 9429) .. ReadText(1001, 120), { x = Helper.standardTextHeight })
				row[2]:createText(ConvertMoneyString(buildstoragemoney - transaction, false, true, nil, true) .. " " .. ReadText(1001, 101), { halign = "right" })
				row[3]:setColSpan(2):createSliderCell({ min = math.min((-playermoney + transaction), transaction), max = math.max(buildstoragemoney, transaction), start = transaction, fromCenter = true, suffix = ReadText(1001, 101), height = config.rowHeight })
				row[3].handlers.onSliderCellChanged = function (_, value) return menu.slidercellAccountChanged(buildstorage, row.index, value, infotable.id) end
				row[3].handlers.onSliderCellConfirm = function () menu.refreshdata = { nil, nil, "accounts", row.index } menu.refresh = getElapsedTime() + 0.1 end
				row[5]:createText(ConvertMoneyString(playermoney, false, true, nil, true) .. " " .. ReadText(1001, 101), { halign = "left" })

				-- buildstorage estimated budget
				local row = infotable:addRow(true, {  })
				row[1]:createText(ReadText(1001, 9436) .. ReadText(1001, 120), { x = Helper.standardTextHeight })
				row[2]:createText(ConvertMoneyString(wantedmoney, false, true, 0, true) .. " " .. ReadText(1001, 101), { halign = "right" })
				row[5]:createButton({ active = function () local money, estimate = GetComponentData(buildstorage64, "money", "wantedmoney"); return (money + GetPlayerMoney()) > estimate end }):setText(ReadText(1001, 7965), { halign = "center", fontsize = config.mapFontSize })
				row[5].handlers.onClick = function () return menu.buttonAccountToEstimate(buildstorage, true) end
			end

			if i ~= #menu.accountData.stations then
				infotable:addEmptyRow()
			end
		end
	else
		local row = infotable:addRow(true, {  })
		row[1]:setColSpan(5):createText("--- " .. ReadText(1001, 33) .. " ---", { halign = "center" })
	end

	infotable:setTopRow(menu.settoprow)
	if not menu.setselectedrow2 then
		infotable:setSelectedRow(menu.setselectedrow)
	else
		infotable:setSelectedRow(menu.setselectedrow2)
	end
	menu.settoprow = nil
	menu.setselectedrow = nil
	menu.setselectedrow2 = nil

	local buttontable = frame:addTable(3, { tabOrder = 2 + tabOrderOffset, borderEnabled = false, width = tableProperties.width, x = tableProperties.x, y = tableProperties.y })

	local row = buttontable:addRow(false, { fixed = true })
	row[1]:setColSpan(3):createText("")

	local row = buttontable:addRow(true, { fixed = true, bgColor = Color["row_background_blue"] })
	row[1]:createButton({ active = #menu.accountData.transactions > 0 }):setText(ReadText(1001, 2821), { halign = "center" })
	row[1].handlers.onClick = menu.buttonAccountConfirm
	row[2]:createButton():setText(ReadText(1001, 3318), { halign = "center" })
	row[2].handlers.onClick = menu.buttonAccountCancel
	row[3]:createButton():setText(ReadText(1001, 7779), { halign = "center" })
	row[3].handlers.onClick = menu.buttonAccountAllEstimates

	local maxVisibleHeight = infotable.properties.maxVisibleHeight - buttontable:getFullHeight() - Helper.frameBorder
	buttontable.properties.y = buttontable.properties.y + math.min(maxVisibleHeight, infotable:getFullHeight())
	infotable.properties.maxVisibleHeight = buttontable.properties.y - infotable.properties.y

	infotable:addConnection(1, 2, true)
	buttontable:addConnection(2, 2)

	return infotable, buttontable
end

function menu.logbookSearchHelper(entry, text)
	text = utf8.lower(text)

	if string.find(utf8.lower(entry.title), text, 1, true) then
		return true
	end
	if string.find(utf8.lower(entry.text), text, 1, true) then
		return true
	end
	if string.find(utf8.lower(entry.entityname), text, 1, true) then
		return true
	end
	if string.find(utf8.lower(entry.factionname), text, 1, true) then
		return true
	end

	return false
end

function menu.createLogbookHeader(frame, tableProperties)
	local isonline = C.AreVenturesCompatible()

	local count = 0
	for i, entry in ipairs(config.logbookCategories) do
		if (entry.online == nil) or (entry.online == isonline) then
			count = count + 1
		end
	end

	local numcols = count + 1
	local titletable = frame:addTable(numcols, { tabOrder = 2, width = tableProperties.width, x = tableProperties.x, y = tableProperties.y })
	for i, entry in ipairs(config.logbookCategories) do
		if (entry.online == nil) or (entry.online == isonline) then
			if entry.empty then
				titletable:setColWidth(i, menu.sideBarWidth / 2, false)
			else
				titletable:setColWidth(i, menu.sideBarWidth, false)
			end
		end
	end

	-- title
	local row = titletable:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
	row[1]:setColSpan(numcols):createText(ReadText(1001, 5700), Helper.titleTextProperties)
	-- categories
	local row = titletable:addRow(true, { fixed = true })
	for i, entry in ipairs(config.logbookCategories) do
		if (entry.online == nil) or (entry.online == isonline) then
			if not entry.empty then
				local bgcolor = Color["row_title_background"]
				local color = Color["text_normal"]
				if entry.mode == menu.logbookData.category then
					bgcolor = Color["row_background_selected"]
				end

				row[i]:createButton({ height = menu.sideBarWidth, bgColor = bgcolor, mouseOverText = entry.name, scaling = false }):setIcon(entry.icon, { color = color})
				row[i].handlers.onClick = function () return menu.buttonLogbookCategory(entry.name, entry.mode, i) end
			end
		end
	end

	if menu.setselectedcol then
		titletable:setSelectedCol(menu.setselectedcol)
		menu.setselectedcol = nil
	end

	return titletable
end

function menu.createLogbook(frame, tableProperties)
	local isonline = Helper.isOnlineGame()
	if not isonline then
		if menu.logbookData.category == "online" then
			menu.logbookData.hasExtension = "all"
		end
	end

	if menu.logbookData.category == "online" then
		if Helper.hasExtension("multiverse") then
			Helper.callExtensionFunction("multiverse", "createVentureLogbook", menu, menu.infoFrame, "left", "playerinfo", tableProperties)
		end
	else
		local titletable = menu.createLogbookHeader(frame, tableProperties)

		-- entries
		local buttonsize = Helper.scaleY(config.rowHeight)
		local infotable = frame:addTable(10, { tabOrder = 1, width = tableProperties.width, x = tableProperties.x, y = titletable.properties.y + titletable:getFullHeight() + 2 * Helper.borderSize, maxVisibleHeight = tableProperties.height - titletable:getFullHeight() - Helper.borderSize })
		if menu.setdefaulttable then
			infotable.properties.defaultInteractiveObject = true
			menu.setdefaulttable = nil
		end
		infotable:setColWidth(1, tableProperties.width / 3, false)
		infotable:setColWidth(4, config.rowHeight)
		infotable:setColWidth(5, config.rowHeight)
		infotable:setColWidth(6, config.rowHeight)
		infotable:setColWidth(7, config.rowHeight)
		infotable:setColWidth(8, tableProperties.width / 3 - 4 * (buttonsize + Helper.borderSize), false)
		infotable:setColWidth(9, config.rowHeight)
		infotable:setColWidth(10, config.rowHeight)

		-- entries
		menu.logbookData.numEntries = 0
		if menu.logbookData.category == "ticker" then
			menu.logbookData.numEntries = C.GetNumTickerCache("")
		else
			menu.logbookData.numEntries = GetNumLogbook(menu.logbookData.category)
		end
		if menu.logbookData.searchtext ~= "" then
			menu.logbook = {}
			for i = 1, math.ceil(menu.logbookData.numEntries / config.logbookQueryLimit) do
				local numQuery = math.min(config.logbookQueryLimit, menu.logbookData.numEntries - (i - 1) * config.logbookQueryLimit)
				if menu.logbookData.category == "ticker" then
					local buf = ffi.new("TickerCacheEntry[?]", numQuery)
					local n = C.GetTickerCache(buf, numQuery, (i - 1) * config.logbookQueryLimit + 1, numQuery, "");
					for j = 0, n - 1 do
						local entry = {
							time = buf[j].time,
							category = ffi.string(buf[j].category),
							title = ffi.string(buf[j].title),
							text = ffi.string(buf[j].text),
							factionname = "",
							entityname = "",
							money = 0,
							bonus = 0,
						}

						if menu.logbookSearchHelper(entry, menu.logbookData.searchtext) then
							table.insert(menu.logbook, entry)
						end
					end
				else
					local logbook = GetLogbook((i - 1) * config.logbookQueryLimit + 1, numQuery, menu.logbookData.category) or {}
					if #logbook > 0 then
						for _, entry in ipairs(logbook) do
							if menu.logbookSearchHelper(entry, menu.logbookData.searchtext) then
								table.insert(menu.logbook, entry)
							end
						end
					end
				end
			end

			menu.logbookData.numEntries = #menu.logbook
			if menu.logbookData.numEntries <= config.logbookPage then
				menu.logbookData.curPage = 1
			else
				local startIndex = menu.logbookData.numEntries - config.logbookPage * menu.logbookData.curPage + 1
				local endIndex = config.logbookPage + startIndex - 1
				if startIndex < 1 then
					startIndex = 1
				end
				menu.logbook = { table.unpack(menu.logbook, startIndex, endIndex) }
			end
		else
			local startIndex = 1
			local numQuery = math.min(config.logbookPage, menu.logbookData.numEntries)
			if menu.logbookData.numEntries <= config.logbookPage then
				menu.logbookData.curPage = 1
			else
				startIndex = menu.logbookData.numEntries - config.logbookPage * menu.logbookData.curPage + 1
				if startIndex < 1 then
					numQuery = config.logbookPage + startIndex - 1
					startIndex = 1
				end
			end
			if menu.logbookData.category == "ticker" then
				menu.logbook = {}
				local buf = ffi.new("TickerCacheEntry[?]", numQuery)
				local n = C.GetTickerCache(buf, numQuery, startIndex, numQuery, "");
				for j = 0, n - 1 do
					local entry = {
						time = buf[j].time,
						category = ffi.string(buf[j].category),
						title = ffi.string(buf[j].title),
						text = ffi.string(buf[j].text),
						factionname = "",
						entityname = "",
						money = 0,
						bonus = 0,
					}

					table.insert(menu.logbook, entry)
				end
			else
				menu.logbook = GetLogbook(startIndex, numQuery, menu.logbookData.category) or {}
			end
		end
		menu.logbookData.numPages = math.max(1, math.ceil(menu.logbookData.numEntries / config.logbookPage))

		-- category title / pages
		local row = infotable:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
		row[1]:setColSpan(10):createText(menu.logbookData.name, {
			scaling = false,
			font = Helper.titleFont,
			fontsize = Helper.scaleFont(Helper.titleFont, Helper.standardFontSize),
			height = Helper.scaleY(Helper.subHeaderHeight),
			cellBGColor = Color["row_background"],
			titleColor = Color["row_title"],
		})
		row[1].properties.x = (tableProperties.width - math.ceil(C.GetTextWidth(menu.logbookData.name, Helper.titleFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize)))) / 2
		row = infotable:addRow(true, { fixed = true })
		row[1]:setColSpan(3):createEditBox({ description = ReadText(1001, 7740), defaultText = ReadText(1001, 3250) }):setText(menu.logbookData.searchtext, { halign = "left", x = Helper.standardTextOffsetx }):setHotkey("INPUT_STATE_DETAILMONITOR_0", { displayIcon = true })
		row[1].handlers.onEditBoxDeactivated = function (_, text) if text ~= menu.logbookData.searchtext then menu.logbookData.searchtext = text; menu.noupdate = nil; menu.refreshInfoFrame() end end

		local buttonheight = math.max(Helper.editboxMinHeight, Helper.scaleY(Helper.subHeaderHeight))
		row[4]:createButton({ scaling = false, width = buttonsize, height = buttonheight, cellBGColor = Color["row_background"] }):setText("X", { halign = "center", font = Helper.standardFontBold })
		row[4].handlers.onClick = function () menu.logbookData.searchtext = ""; menu.refreshInfoFrame() end

		row[5]:createButton({ scaling = false, active = menu.logbookData.curPage > 1, width = buttonsize, height = buttonheight, cellBGColor = Color["row_background"] }):setIcon("widget_arrow_skip_left_01", { width = buttonsize, height = buttonsize, y = (row:getHeight() - buttonsize) / 2 })
		row[5].handlers.onClick = function () menu.logbookData.curPage = 1; menu.refreshInfoFrame() end
		row[6]:createButton({ scaling = false, active = menu.logbookData.curPage > 1, width = buttonsize, height = buttonheight, cellBGColor = Color["row_background"] }):setIcon("widget_arrow_left_01", { width = buttonsize, height = buttonsize, y = (row:getHeight() - buttonsize) / 2 })
		row[6].handlers.onClick = function () menu.logbookData.curPage = menu.logbookData.curPage - 1; menu.refreshInfoFrame() end
		menu.logbookPageEditBox = row[7]:setColSpan(2):createEditBox({ description = ReadText(1001, 7739) }):setText(menu.logbookData.curPage .. " / " .. menu.logbookData.numPages, { halign = "center" })
		row[7].handlers.onEditBoxDeactivated = menu.editboxLogbookPage
		row[9]:createButton({ scaling = false, active = menu.logbookData.curPage < menu.logbookData.numPages, width = buttonsize, height = buttonheight, cellBGColor = Color["row_background"] }):setIcon("widget_arrow_right_01", { width = buttonsize, height = buttonsize, y = (row:getHeight() - buttonsize) / 2 })
		row[9].handlers.onClick = function () menu.logbookData.curPage = menu.logbookData.curPage + 1; menu.refreshInfoFrame() end
		row[10]:createButton({ scaling = false, active = menu.logbookData.curPage < menu.logbookData.numPages, width = buttonsize, height = buttonheight, cellBGColor = Color["row_background"] }):setIcon("widget_arrow_skip_right_01", { width = buttonsize, height = buttonsize, y = (row:getHeight() - buttonsize) / 2 })
		row[10].handlers.onClick = function () menu.logbookData.curPage = menu.logbookData.numPages; menu.refreshInfoFrame() end

		infotable:addEmptyRow(Helper.standardTextHeight / 2)

		if #menu.logbook > 0 then
			for i = #menu.logbook, 1, -1 do
				local entry = menu.logbook[i]
				local textcolor = entry.highlighted and Color["text_logbook_highlight"] or Color["text_normal"]
				row = infotable:addRow(true, { borderBelow = false })
				if entry.interaction and IsValidComponent(entry.interactioncomponent) then
					local mouseoverobject = entry.interactioncomponent
					if IsComponentClass(mouseoverobject, "zone") and not IsComponentClass(mouseoverobject, "highway") then
						mouseoverobject = GetContextByClass(mouseoverobject, "sector")
					end
					row[1]:setColSpan(9):createText(entry.title, { font = Helper.standardFontBold, color = textcolor, wordwrap = true })
					row[10]:createButton({ scaling = false, bgColor = Color["button_background_hidden"], mouseOverText = string.format(entry.interactiontext, GetComponentData(mouseoverobject, "name")), height = buttonsize }):setIcon("widget_arrow_right_01", { width = buttonsize, height = buttonsize })
					row[10].handlers.onClick = function () return menu.buttonLogbookInteraction(entry) end
				else
					row[1]:setColSpan(10):createText(entry.title, { font = Helper.standardFontBold, color = textcolor, wordwrap = true })
				end

				if (entry.entityname ~= "") or (entry.factionname ~= "") then
					row = infotable:addRow(false, { borderBelow = false })
					if entry.entityname ~= "" then
						row[1]:setColSpan(2):createText(ReadText(1001, 5711) .. " " .. entry.entityname, { x = config.rowHeight })
					end
					row[3]:setColSpan(8):createText(entry.factionname, config.rightAlignTextProperties)
				end

				if entry.text ~= "" then
					row = infotable:addRow(false, { borderBelow = false })
					row[1]:setColSpan(10):createText(entry.text, { x = config.rowHeight, color = textcolor, wordwrap = true })
				end

				row = infotable:addRow(false, {  })
				row[1]:setColSpan(2):createText(Helper.getPassedTime(entry.time), { mouseOverText = Helper.convertGameTimeToXTimeString(entry.time), x = config.rowHeight })
				local moneystring = ""
				if entry.money ~= 0 then
					local moneycolor = (entry.money >= 0) and Color["text_positive"] or Color["text_negative"]
					moneystring = moneystring .. Helper.convertColorToText(moneycolor) .. ((entry.bonus >= 0) and "+" or "-") .. ConvertMoneyString(entry.money, false, true, nil, true) .. " " .. ReadText(1001, 101)
				end
				if entry.bonus ~= 0 then
					local bonuscolor = (entry.bonus >= 0) and Color["text_positive"] or Color["text_negative"]
					moneystring = moneystring .. " " .. Helper.convertColorToText(bonuscolor) .. "(" .. ((entry.bonus >= 0) and "+" or "-") .. " " .. ReadText(1001, 5712) .. " " .. ConvertMoneyString(entry.bonus, false, true, nil, true) .. " " .. ReadText(1001, 101) .. ")"
				end
				row[3]:setColSpan(8):createText(moneystring, config.rightAlignTextProperties)

				if i ~= 1 then
					row = infotable:addRow(false, { bgColor = Color["row_title"] })
					row[1]:setColSpan(10):createText("", { fontsize = 1, minRowHeight = 1 })
				end
			end
		else
			row = infotable:addRow(false, {  })
			row[1]:setColSpan(10):createText("--- " .. ReadText(1001, 5705) .. " ---", { halign = "center" })
		end

		infotable:setTopRow(menu.settoprow)
		infotable:setSelectedRow(menu.setselectedrow)
		menu.settoprow = nil
		menu.setselectedrow = nil

		local buttontable = frame:addTable(3, { tabOrder = 2, borderEnabled = false, width = tableProperties.width, x = tableProperties.x, y = infotable.properties.y })

		local row = buttontable:addRow(false, { fixed = true })
		row[1]:setColSpan(3):createText("")

		local row = buttontable:addRow(true, { fixed = true, bgColor = Color["row_background_blue"] })
		row[1]:createButton():setText(ReadText(1001, 5722), { halign = "center" })
		row[1].handlers.onClick = menu.buttonLogbookClearQuestion

		local maxVisibleHeight = infotable.properties.maxVisibleHeight - buttontable:getFullHeight() - Helper.frameBorder
		buttontable.properties.y = buttontable.properties.y + math.min(maxVisibleHeight, infotable:getFullHeight())
		infotable.properties.maxVisibleHeight = buttontable.properties.y - infotable.properties.y

		titletable:addConnection(1, 2, true)
		infotable:addConnection(2, 2)
		buttontable:addConnection(3, 2)

		local width = Helper.playerInfoConfig.width - menu.sideBarWidth - Helper.borderSize
		local descriptiontable = frame:addTable(1, { tabOrder = 0, width = width, x = Helper.viewWidth - width - Helper.frameBorder, y = Helper.viewHeight * 4 / 5 })
		local row = descriptiontable:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
		row[1]:createText(ReadText(1001, 2427), Helper.titleTextProperties)

		local row = descriptiontable:addRow(nil, { fixed = true })
		row[1]:createText(ReadText(1001, 5726), { wordwrap = true })
	end
end

function menu.messageHelper(numQuery, startIdx, category)
	local buf = ffi.new("MessageInfo[?]", numQuery)
	numQuery = C.GetMessages(buf, numQuery, startIdx, numQuery, category)
	returnvalue = {}
	for i = 0, numQuery - 1 do
		local entry = {}

		entry.id					= buf[i].id
		entry.time					= buf[i].time
		entry.category				= ffi.string(buf[i].category)
		entry.title					= ffi.string(buf[i].title)
		entry.text					= ffi.string(buf[i].text)
		entry.source				= ffi.string(buf[i].source)
		entry.sourcecomponent		= buf[i].sourcecomponent
		entry.interaction			= ffi.string(buf[i].interaction)
		entry.interactioncomponent	= buf[i].interactioncomponent
		entry.interactiontext		= ffi.string(buf[i].interactiontext)
		entry.interactionshorttext	= ffi.string(buf[i].interactionshorttext)
		local posrot = C.GetMessageInteractPosition(entry.id)
		entry.interactionposition	= { x = posrot.x, y = posrot.y, z = posrot.z }
		entry.cutscenekey			= ffi.string(buf[i].cutscenekey)
		entry.entityname			= ffi.string(buf[i].entityname)
		entry.factionname			= ffi.string(buf[i].factionname)
		entry.money					= buf[i].money
		entry.bonus					= buf[i].bonus
		entry.highlighted			= buf[i].highlighted
		entry.isread				= buf[i].isread

		table.insert(returnvalue, entry)
	end

	return returnvalue
end

function menu.messageCategoryIcon(entry)
	local numentries = C.GetNumMessages(entry.mode, true)
	return (numentries > 0) and entry.icon_unread or entry.icon
end

function menu.messageSidebarIcon()
	for i, entry in ipairs(config.messageCategories) do
		local numentries = C.GetNumMessages(entry.mode, true)
		if numentries > 0 then
			return entry.icon_unread
		end
	end
	-- if there are no unread messages, use the normal icon of the last category
	return config.messageCategories[#config.messageCategories].icon
end

function menu.messageSidebarIconColor()
	for i, entry in ipairs(config.messageCategories) do
		local numentries = C.GetNumMessages(entry.mode, true)
		if numentries > 0 then
			local period = 10
			local effectduration = 2
			local effectrepeat = 2

			-- number between 0 and period
			local x = getElapsedTime() % period

			if x <= effectduration then
				-- number between 0 and 1
				x = (x * effectrepeat / effectduration) % 1

				normalcolor = Color["text_normal"]
				overridecolor = Color["text_mission"]
				local color = {
					r = (1 - x) * overridecolor.r + x * normalcolor.r,
					g = (1 - x) * overridecolor.g + x * normalcolor.g,
					b = (1 - x) * overridecolor.b + x * normalcolor.b,
					a = (1 - x) * overridecolor.a + x * normalcolor.a,
				}
				return color
			end
		end
	end
	-- if there are no unread messages, use the normal icon color
	return Color["text_normal"]
end

function menu.createMessages(frame, tableProperties)
	local narrowtablewidth = Helper.playerInfoConfig.width - menu.sideBarWidth - Helper.borderSize

	local infotable, buttontable, titletable, detailtable, interacttable
	if not menu.messageData.showFullscreen then
		-- entries
		local buttonsize = Helper.scaleY(config.rowHeight)
		infotable = frame:addTable(10, { tabOrder = 1, width = narrowtablewidth, x = tableProperties.x, y = 0, maxVisibleHeight = tableProperties.height })
		if menu.setdefaulttable then
			infotable.properties.defaultInteractiveObject = true
			menu.setdefaulttable = nil
		end
		infotable:setColWidth(1, narrowtablewidth / 3, false)
		infotable:setColWidth(4, config.rowHeight)
		infotable:setColWidth(5, config.rowHeight)
		infotable:setColWidth(6, config.rowHeight)
		infotable:setColWidth(7, config.rowHeight)
		infotable:setColWidth(8, narrowtablewidth / 3 - 4 * (buttonsize + Helper.borderSize), false)
		infotable:setColWidth(9, config.rowHeight)
		infotable:setColWidth(10, config.rowHeight)

		-- entries
		menu.messageData.numEntries = C.GetNumMessages(menu.messageData.category, false)
		if menu.messageData.searchtext ~= "" then
			menu.messages = {}
			for i = 1, math.ceil(menu.messageData.numEntries / config.logbookQueryLimit) do
				local numQuery = math.min(config.logbookQueryLimit, menu.messageData.numEntries - (i - 1) * config.logbookQueryLimit)
				local startIdx = (i - 1) * config.logbookQueryLimit + 1
				local messages = menu.messageHelper(numQuery, startIdx, menu.messageData.category)

				if #messages > 0 then
					for _, entry in ipairs(messages) do
						if menu.logbookSearchHelper(entry, menu.messageData.searchtext) then
							table.insert(menu.messages, entry)
						end
					end
				end
			end

			menu.messageData.numEntries = #menu.messages
		else
			local numQuery = math.min(config.logbookQueryLimit, menu.messageData.numEntries)
			local startIdx = menu.messageData.numEntries - numQuery + 1
			menu.messages = menu.messageHelper(numQuery, startIdx, menu.messageData.category)
		end

		-- category title / pages
		local row = infotable:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
		row[1]:setColSpan(10):createText(menu.messageData.name, {
			font = Helper.titleFont,
			fontsize = Helper.standardFontSize,
			height = Helper.subHeaderHeight,
			cellBGColor = Color["row_background"],
			titleColor = Color["row_title"],
			halign = "center",
		})

		local row = infotable:addRow(true, { fixed = true })
		row[1]:setColSpan(9):createEditBox({ description = ReadText(1001, 7740), defaultText = ReadText(1001, 3250) }):setText(menu.messageData.searchtext, { halign = "left", x = Helper.standardTextOffsetx }):setHotkey("INPUT_STATE_DETAILMONITOR_0", { displayIcon = true })
		row[1].handlers.onEditBoxDeactivated = function (_, text) if text ~= menu.messageData.searchtext then menu.messageData.searchtext = text; menu.noupdate = nil; menu.refreshInfoFrame() end end
		local buttonheight = math.max(Helper.editboxMinHeight, Helper.scaleY(Helper.subHeaderHeight))
		row[10]:createButton({ scaling = false, width = buttonsize, height = buttonheight, cellBGColor = Color["row_background"] }):setText("X", { halign = "center", font = Helper.standardFontBold })
		row[10].handlers.onClick = function () menu.messageData.searchtext = ""; menu.refreshInfoFrame() end

		infotable:addEmptyRow(Helper.standardTextHeight / 2)

		local numunread = 0
		if #menu.messages > 0 then
			for i = #menu.messages, 1, -1 do
				local entry = menu.messages[i]
				if not entry.isread then
					numunread = numunread + 1
				end
				local font = entry.isread and Helper.standardFont or Helper.standardFontBold
				local textcolor = entry.highlighted and Color["text_logbook_highlight"] or Color["text_normal"]
				row = infotable:addRow(entry, { borderBelow = false })
				if entry.id == menu.messageData.curEntry.id then
					infotable:setSelectedRow(row.index)
				end

				row[1]:setColSpan(6):createText(entry.title, { font = font, color = textcolor, wordwrap = true })
				row[7]:setColSpan(4):createText(Helper.getPassedTime(entry.time), { font = font, mouseOverText = Helper.convertGameTimeToXTimeString(entry.time), x = config.rowHeight, halign = "right" })
			end
		else
			row = infotable:addRow(false, {  })
			row[1]:setColSpan(10):createText("--- " .. ReadText(1001, 5705) .. " ---", { halign = "center" })
		end

		infotable:setTopRow(menu.settoprow)
		menu.settoprow = nil

		-- buttons
		buttontable = frame:addTable(3, { tabOrder = 2, borderEnabled = false, width = narrowtablewidth, x = tableProperties.x, y = infotable.properties.y })

		local row = buttontable:addRow(false, { fixed = true })
		row[1]:setColSpan(3):createText("")

		local row = buttontable:addRow(true, { fixed = true, bgColor = Color["row_background_blue"] })
		row[3]:createButton({ active = numunread > 0 }):setText(ReadText(1001, 7744), { halign = "center" })
		row[3].handlers.onClick = menu.buttonMessagesRead

		local numcols = #config.messageCategories + 1
		titletable = frame:addTable(numcols, { tabOrder = 2, width = narrowtablewidth, x = tableProperties.x, y = tableProperties.y })
		for i, entry in ipairs(config.messageCategories) do
			if entry.empty then
				titletable:setColWidth(i, menu.sideBarWidth / 2, false)
			else
				titletable:setColWidth(i, menu.sideBarWidth, false)
			end
		end

		-- title
		local row = titletable:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
		row[1]:setColSpan(numcols):createText(ReadText(1001, 7730), Helper.titleTextProperties)
		-- categories
		local row = titletable:addRow(true, { fixed = true })
		for i, entry in ipairs(config.messageCategories) do
			if not entry.empty then
				local bgcolor = Color["row_title_background"]
				local color = Color["icon_normal"]
				if entry.mode == menu.messageData.category then
					bgcolor = Color["row_background_selected"]
				end

				row[i]:createButton({ height = menu.sideBarWidth, bgColor = bgcolor, mouseOverText = entry.name, scaling = false }):setIcon(function () return menu.messageCategoryIcon(entry) end, { color = color})
				row[i].handlers.onClick = function () return menu.buttonMessageCategory(entry.name, entry.mode, i) end
			end
		end

		if menu.setselectedcol then
			titletable:setSelectedCol(menu.setselectedcol)
			menu.setselectedcol = nil
		end

		infotable.properties.y = titletable.properties.y + titletable:getFullHeight() + 2 * Helper.borderSize

		local maxVisibleHeight = Helper.viewHeight - infotable.properties.y - buttontable:getFullHeight() - Helper.frameBorder
		buttontable.properties.y = infotable.properties.y + math.min(maxVisibleHeight, infotable:getFullHeight())
		infotable.properties.maxVisibleHeight = buttontable.properties.y - infotable.properties.y

		titletable:addConnection(1, 2, true)
		infotable:addConnection(2, 2)
		buttontable:addConnection(3, 2)

		-- message details
		detailtable = frame:addTable(3, { tabOrder = 3, width = tableProperties.width - 2 * (narrowtablewidth + Helper.borderSize), x = tableProperties.x + infotable.properties.width + Helper.borderSize, y = titletable.properties.y, highlightMode = "off" })
		local row = detailtable:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
		row[1]:setColSpan(3):createText(menu.messageData.curEntry.title, Helper.titleTextProperties)

		if next(menu.messageData.curEntry) then
			local row = detailtable:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
			row[1]:setColSpan(2):setBackgroundColSpan(3):createText(ReadText(1001, 7745) .. ReadText(1001, 120) .. " " .. menu.messageData.curEntry.source, {
				font = Helper.titleFont,
				fontsize = Helper.standardFontSize,
				height = Helper.subHeaderHeight,
				cellBGColor = Color["row_background"],
				titleColor = Color["row_title"],
			})
			row[3]:createText(ReadText(1001, 2691) .. ReadText(1001, 120) .. " " .. Helper.convertGameTimeToXTimeString(menu.messageData.curEntry.time), {
				font = Helper.titleFont,
				fontsize = Helper.standardFontSize,
				height = Helper.subHeaderHeight,
				cellBGColor = Color["row_background"],
				titleColor = Color["row_title"],
				halign = "right",
			})

			local interacttableheight = 0
			if (menu.messageData.curEntry.interaction ~= "") and (menu.messageData.curEntry.interactioncomponent > 0) and C.IsComponentOperational(menu.messageData.curEntry.interactioncomponent) then
				interacttable = frame:addTable(3, { tabOrder = 4, width = tableProperties.width - 2 * (narrowtablewidth + Helper.borderSize), x = tableProperties.x + infotable.properties.width + Helper.borderSize, y = titletable.properties.y })
				interacttable:addEmptyRow(config.rowHeight)

				local interactioncomponent = menu.messageData.curEntry.interactioncomponent
				if C.IsComponentClass(interactioncomponent, "zone") and (not C.IsComponentClass(interactioncomponent, "highway")) then
					interactioncomponent = GetContextByClass(interactioncomponent, "sector")
				end
				local name = ffi.string(C.GetComponentName(interactioncomponent))

				local row = interacttable:addRow(nil, { fixed = true })
				row[1]:setColSpan(3):createText(name)
				local row = interacttable:addRow(true, { fixed = true })
				row[3]:createButton({ mouseOverText = string.format(menu.messageData.curEntry.interactiontext, name) }):setText(menu.messageData.curEntry.interactionshorttext, { halign = "center" })
				row[3].handlers.onClick = function () return menu.buttonMessagesInteraction(menu.messageData.curEntry) end

				interacttableheight = interacttable:getFullHeight() + Helper.frameBorder + Helper.borderSize
			end

			local maxnumlines = math.floor((Helper.viewHeight - interacttableheight - detailtable.properties.y) / (Helper.scaleY(Helper.standardTextHeight) + Helper.borderSize))
			local lines = GetTextLines(menu.messageData.curEntry.text, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), detailtable.properties.width - 2 * Helper.scaleX(Helper.standardTextOffsetx))
			if #lines > maxnumlines then
				-- scrollbar case
				lines = GetTextLines(menu.messageData.curEntry.text, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), detailtable.properties.width - 2 * Helper.scaleX(Helper.standardTextOffsetx) - Helper.scrollbarWidth)
			end
			for linenum, line in ipairs(lines) do
				local row = detailtable:addRow(true, {  })
				row[1]:setColSpan(3):createText(line)
			end

			if interacttable then
				if #lines > maxnumlines then
					interacttable.properties.y = Helper.viewHeight - interacttable:getFullHeight() - Helper.frameBorder
					detailtable.properties.maxVisibleHeight = interacttable.properties.y - detailtable.properties.y
				else
					interacttable.properties.y = detailtable.properties.y + detailtable:getFullHeight() + Helper.borderSize
				end

				detailtable:addConnection(1, 3, true)
				interacttable:addConnection(2, 3)
			end
		end
	end

	-- media
	if next(menu.messageData.curEntry) and (menu.messageData.curEntry.cutscenekey ~= "") then
		if config.messageCutscenes[menu.messageData.curEntry.cutscenekey] then
			local mediaProperties
			if menu.messageData.showFullscreen then
				local width = Helper.viewWidth
				local height = Helper.round(width * 9 / 16)
				if height > Helper.viewHeight then
					height = Helper.viewHeight
					width = Helper.round(height * 16 / 9)
				end
				mediaProperties = { width = width, x = (Helper.viewWidth - width) / 2, height = height, y = (Helper.viewHeight - height) / 2 }
			else
				local width = narrowtablewidth
				local height = Helper.round(width * 9 / 16)
				if height > tableProperties.height then
					height = tableProperties.height
					width = Helper.round(height * 16 / 9)
				end
				mediaProperties = { width = width, x = tableProperties.x + infotable.properties.width + detailtable.properties.width + (2 * Helper.borderSize), height = height, y = tableProperties.y }
			end

			menu.rendertarget = frame:addRenderTarget(mediaProperties)
			menu.messageData.activatecutscene = true

			local buttonsize = 2 * config.rowHeight
			local rendertargetbuttontable = frame:addTable(2, { tabOrder = 4, width = mediaProperties.width, x = mediaProperties.x, y = mediaProperties.y + mediaProperties.height - Helper.scaleX(buttonsize) })
			rendertargetbuttontable:setColWidth(2, buttonsize)
			local row = rendertargetbuttontable:addRow(true, { fixed = true })
			row[2]:createButton({ height = buttonsize, bgColor = Color["button_background_hidden"] }):setIcon(menu.messageData.showFullscreen and "menu_minimize_video" or "menu_maximize_video")
			row[2].handlers.onClick = menu.buttonMessagesToggleCutsceneFullscreen
		else
			print("Unsupported message cutscene key: '" .. menu.messageData.curEntry.cutscenekey .. "'")
		end
	end
end

function menu.createPersonnelInfo(frame, tableProperties)
	if not menu.empireData.initialized or menu.empireData.init then
		menu.initEmpireData()
		menu.empireData.init = nil
	else
		menu.getEmployeeList()
	end

	local infotablewidth = 2 * (Helper.playerInfoConfig.width - menu.sideBarWidth - Helper.borderSize)
	local numCols = 11
	local buttonsize = Helper.scaleY(config.rowHeight)

	local infotable = frame:addTable(numCols, { tabOrder = 1, width = infotablewidth, x = tableProperties.x, y = tableProperties.y, maxVisibleHeight = tableProperties.height })
	if menu.setdefaulttable then
		infotable.properties.defaultInteractiveObject = true
		menu.setdefaulttable = nil
	end
	infotable:setColWidth(1, config.rowHeight)
	infotable:setColWidth(3, config.rowHeight)
	infotable:setColWidth(7, config.rowHeight)
	infotable:setColWidth(8, config.rowHeight)
	infotable:setColWidth(9, 6 * config.rowHeight)
	infotable:setColWidth(10, config.rowHeight)
	infotable:setColWidth(11, config.rowHeight)

	infotable:setDefaultBackgroundColSpan(1, numCols)
	infotable:setDefaultColSpan(2, 2)
	infotable:setDefaultColSpan(4, 2)
	infotable:setDefaultColSpan(6, 3)
	infotable:setDefaultColSpan(9, 3)

	local row = infotable:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
	row[1]:setColSpan(numCols):createText(ReadText(1001, 11034), Helper.titleTextProperties)

	-- overview
	local row = infotable:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
	row[1]:setColSpan(numCols):createText(ReadText(1001, 11035), Helper.headerRowCenteredProperties)

	local row = infotable:addRow(nil, { fixed = true, bgColor = Color["row_background_unselectable"] })
	row[1]:setColSpan(5):createText(ReadText(1001, 9113))	-- Number of hired personnel
	row[6]:setColSpan(6):createText((ConvertIntegerString(menu.empireData.numhiredpersonnel, true)), { halign = "right" })

	local row = infotable:addRow(nil, { fixed = true, bgColor = Color["row_background_unselectable"] })
	row[1]:setColSpan(5):createText(ReadText(1001, 9114))	-- Average personnel skill
	row[6]:setColSpan(6):createText(Helper.displaySkill(menu.empireData.averagepersonnelskill), { color = Color["text_skills"], halign = "right" })

	local row = infotable:addRow(nil, { fixed = true })
	row[1]:createText("")

	-- list
	local employees = menu.empireData.filteredemployees
	if menu.personnelData.sort == "name" then
		table.sort(employees, function (a, b) return Helper.sortName(a, b, false) end)
	elseif menu.personnelData.sort == "name_inv" then
		table.sort(employees, function (a, b) return Helper.sortName(a, b, true) end)
	elseif menu.personnelData.sort == "skill" then
		table.sort(employees, function (a, b) return menu.skillSorter(a, b, false) end)
	elseif menu.personnelData.sort == "skill_inv" then
		table.sort(employees, function (a, b) return menu.skillSorter(a, b, true) end)
	elseif menu.personnelData.sort == "role" then
		table.sort(employees, function (a, b) return menu.roleSorter(a, b, false) end)
	elseif menu.personnelData.sort == "role_inv" then
		table.sort(employees, function (a, b) return menu.roleSorter(a, b, true) end)
	elseif menu.personnelData.sort == "workplace" then
		table.sort(employees, function (a, b) return menu.workplaceSorter(a, b, false) end)
	elseif menu.personnelData.sort == "workplace_inv" then
		table.sort(employees, function (a, b) return menu.workplaceSorter(a, b, true) end)
	end

	menu.personnelData.numPages = math.ceil(#employees / config.personnelPage)
	if #employees <= config.personnelPage then
		menu.personnelData.curPage = 1
	else
		local startIndex = config.personnelPage * (menu.personnelData.curPage - 1) + 1
		local endIndex = config.personnelPage + startIndex - 1
		if startIndex < 1 then
			startIndex = 1
		end
		employees = { table.unpack(employees, startIndex, endIndex) }
	end

	local row = infotable:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
	row[1]:setColSpan(numCols):createText(ReadText(1001, 11036), Helper.headerRowCenteredProperties)

	-- search & pages
	local roleOptions = {
		{ id = "post:aipilot",		text = ReadText(20208, 30101), icon = "", displayremoveoption = false },
		{ id = "post:manager",		text = ReadText(20208, 30301), icon = "", displayremoveoption = false },
		{ id = "post:shiptrader",	text = ReadText(20208, 30501), icon = "", displayremoveoption = false },
		{ id = "role:service",		text = ReadText(20208, 20103), icon = "", displayremoveoption = false },
		{ id = "role:marine",		text = ReadText(20208, 20203), icon = "", displayremoveoption = false },
	}
	table.sort(roleOptions, function (a, b) return a.text < b.text end)
	table.insert(roleOptions, 1, { id = "current", text = ReadText(1001, 8373), icon = "", displayremoveoption = false })
	local row = infotable:addRow(true, { fixed = true })
	row[1]:setColSpan(2):createEditBox({ description = ReadText(1001, 11038), defaultText = ReadText(1001, 3250), height = config.rowHeight }):setText(menu.personnelData.searchtext, { halign = "left", x = Helper.standardTextOffsetx }):setHotkey("INPUT_STATE_DETAILMONITOR_0", { displayIcon = true })
	row[1].handlers.onEditBoxDeactivated = function (_, text) if text ~= menu.personnelData.searchtext then menu.personnelData.searchtext = text; menu.personnelData.curPage = 1; menu.noupdate = nil; menu.personnelData.curEntry = {}; menu.refreshInfoFrame() end end

	local buttonheight = math.max(Helper.editboxMinHeight, Helper.scaleY(Helper.subHeaderHeight))
	row[3]:createButton({ scaling = false, width = buttonsize, height = buttonheight, cellBGColor = Color["row_background"] }):setText("X", { halign = "center", font = Helper.standardFontBold })
	row[3].handlers.onClick = function () if menu.personnelData.searchtext ~= "" then menu.personnelData.searchtext = ""; menu.personnelData.curPage = 1; menu.refreshInfoFrame() end end
	row[4]:setColSpan(1):createText(ReadText(1001, 8399) .. ReadText(1001, 120), { halign = "right" })
	row[5]:createDropDown(roleOptions, { height = config.rowHeight, startOption = menu.personnelData.role })
	row[5].handlers.onDropDownConfirmed = function (_, newrole) if menu.personnelData.role ~= newrole then menu.personnelData.role = newrole; menu.personnelData.curPage = 1; menu.refreshInfoFrame() end end
	row[6]:setColSpan(1)
	row[7]:createButton({ scaling = false, active = menu.personnelData.curPage > 1, width = buttonsize, height = buttonheight, cellBGColor = Color["row_background"] }):setIcon("widget_arrow_skip_left_01", { width = buttonsize, height = buttonsize, y = (row:getHeight() - buttonsize) / 2 })
	row[7].handlers.onClick = function () menu.personnelData.curPage = 1; menu.personnelData.curEntry = {}; menu.refreshInfoFrame(1, 1) end
	row[8]:createButton({ scaling = false, active = menu.personnelData.curPage > 1, width = buttonsize, height = buttonheight, cellBGColor = Color["row_background"] }):setIcon("widget_arrow_left_01", { width = buttonsize, height = buttonsize, y = (row:getHeight() - buttonsize) / 2 })
	row[8].handlers.onClick = function () menu.personnelData.curPage = menu.personnelData.curPage - 1; menu.personnelData.curEntry = {}; menu.refreshInfoFrame(1, 1) end
	menu.personnelPageEditBox = row[9]:setColSpan(1):createEditBox({ description = ReadText(1001, 7739) }):setText(menu.personnelData.curPage .. " / " .. menu.personnelData.numPages, { halign = "center" })
	row[9].handlers.onEditBoxDeactivated = menu.editboxPersonnelPage
	row[10]:createButton({ scaling = false, active = menu.personnelData.curPage < menu.personnelData.numPages, width = buttonsize, height = buttonheight, cellBGColor = Color["row_background"] }):setIcon("widget_arrow_right_01", { width = buttonsize, height = buttonsize, y = (row:getHeight() - buttonsize) / 2 })
	row[10].handlers.onClick = function () menu.personnelData.curPage = menu.personnelData.curPage + 1; menu.personnelData.curEntry = {}; menu.refreshInfoFrame(1, 1) end
	row[11]:createButton({ scaling = false, active = menu.personnelData.curPage < menu.personnelData.numPages, width = buttonsize, height = buttonheight, cellBGColor = Color["row_background"] }):setIcon("widget_arrow_skip_right_01", { width = buttonsize, height = buttonsize, y = (row:getHeight() - buttonsize) / 2 })
	row[11].handlers.onClick = function () menu.personnelData.curPage = menu.personnelData.numPages; menu.personnelData.curEntry = {}; menu.refreshInfoFrame(1, 1) end

	-- sort
	local arrowWidth = Helper.scaleY(config.rowHeight)
	local row = infotable:addRow(true, { fixed = true })
	row[1]:setColSpan(3):createButton({ height = config.mapRowHeight }):setText(ReadText(1001, 2809), { x = Helper.standardTextOffsetx }):setIcon((menu.personnelData.sort == "name_inv") and "table_arrow_inv_up" or "table_arrow_inv_down", { scaling = false, width = arrowWidth, height = arrowWidth, x = row[1]:getColSpanWidth() - arrowWidth, color = ((menu.personnelData.sort == "name") or (menu.personnelData.sort == "name_inv")) and Color["icon_normal"] or Color["icon_hidden"] })
	row[1].handlers.onClick = function () menu.personnelData.sort = (menu.personnelData.sort == "name") and "name_inv" or "name"; menu.personnelData.curPage = 1; menu.personnelData.curEntry = {}; menu.refreshInfoFrame(1, 1) end
	row[4]:createButton({ height = config.mapRowHeight }):setText(ReadText(1001, 11037), { x = Helper.standardTextOffsetx }):setIcon((menu.personnelData.sort == "workplace_inv") and "table_arrow_inv_up" or "table_arrow_inv_down", { scaling = false, width = arrowWidth, height = arrowWidth, x = row[4]:getColSpanWidth() - arrowWidth, color = ((menu.personnelData.sort == "workplace") or (menu.personnelData.sort == "workplace_inv")) and Color["icon_normal"] or Color["icon_hidden"] })
	row[4].handlers.onClick = function () menu.personnelData.sort = (menu.personnelData.sort == "workplace") and "workplace_inv" or "workplace"; menu.personnelData.curPage = 1; menu.personnelData.curEntry = {}; menu.refreshInfoFrame(1, 1) end
	row[6]:createButton({ height = config.mapRowHeight }):setText(ReadText(1001, 11200), { x = Helper.standardTextOffsetx }):setIcon((menu.personnelData.sort == "role_inv") and "table_arrow_inv_up" or "table_arrow_inv_down", { scaling = false, width = arrowWidth, height = arrowWidth, x = row[6]:getColSpanWidth() - arrowWidth, color = ((menu.personnelData.sort == "role") or (menu.personnelData.sort == "role_inv")) and Color["icon_normal"] or Color["icon_hidden"] })
	row[6].handlers.onClick = function () menu.personnelData.sort = (menu.personnelData.sort == "role") and "role_inv" or "role"; menu.personnelData.curPage = 1; menu.personnelData.curEntry = {}; menu.refreshInfoFrame(1, 1) end
	row[9]:createButton({ height = config.mapRowHeight }):setText(ReadText(1001, 9124), { x = Helper.standardTextOffsetx }):setIcon((menu.personnelData.sort == "skill_inv") and "table_arrow_inv_up" or "table_arrow_inv_down", { scaling = false, width = arrowWidth, height = arrowWidth, x = row[9]:getColSpanWidth() - arrowWidth, color = ((menu.personnelData.sort == "skill") or (menu.personnelData.sort == "skill_inv")) and Color["icon_normal"] or Color["icon_hidden"] })
	row[9].handlers.onClick = function () menu.personnelData.sort = (menu.personnelData.sort == "skill") and "skill_inv" or "skill"; menu.personnelData.curPage = 1; menu.personnelData.curEntry = {}; menu.refreshInfoFrame(1, 1) end

	local found = false
	for i, employeedata in ipairs(employees) do
		if menu.personnelData.curEntry and next(menu.personnelData.curEntry) then
			if tostring(employeedata.id) == tostring(menu.personnelData.curEntry.id) then
				found = true
			end
		else
			menu.personnelData.curEntry = employeedata
			found = true
		end

		local name = employeedata.name
		local namemouseovertext = ""
		local namecolor
		if GetComponentData(employeedata.container, "isonlineobject") then
			namecolor = Color["text_inactive"]
			namemouseovertext = ReadText(1026, 9118)
		end
		if employeedata.type == "person" then
			if C.IsPersonTransferScheduled(C.ConvertStringTo64Bit(tostring(employeedata.container)), C.ConvertStringTo64Bit(tostring(employeedata.id))) then
				name = ColorText["crew_transfer"] .. "\027[warning]" .. name
				namemouseovertext = ReadText(1026, 3228)
			elseif not C.HasPersonArrived(C.ConvertStringTo64Bit(tostring(employeedata.container)), C.ConvertStringTo64Bit(tostring(employeedata.id))) then
				namecolor = Color["text_inactive"]
				namemouseovertext = ReadText(1026, 3247)
			end
		end
		local adjustedskill = math.floor(employeedata.skill * 15 / 100)
		local workplace = employeedata.containername
		local assignment = employeedata.rolename

		local role, post, rolename
		if menu.personnelData.role ~= "current" then
			local type, id = string.match(menu.personnelData.role, "(.+):(.+)")
			if type == "post" then
				post = id
			elseif type == "role" then
				role = id
			end
			for _, option in ipairs(roleOptions) do
				if option.id == menu.personnelData.role then
					rolename = option.text
					break
				end
			end
		end

		local roleColor, mouseovertext
		if (menu.personnelData.role ~= "current") and (role ~= employeedata.roleid) and (post ~= employeedata.roleid) then
			roleColor = Color["text_inactive"]
			mouseovertext = string.format(ReadText(1026, 3231), assignment)
		end

		local isexpanded = menu.isPersonnelExpanded(employeedata.id)
		local row = infotable:addRow({"personnel_employee", employeedata}, {  })
		row[1]:createButton({ height = config.mapRowHeight }):setText(function() return isexpanded and "-" or "+" end, { halign = "center" })
		row[1].handlers.onClick = function() return menu.expandPersonnel(employeedata.id, row.index) end
		row[2]:createText(name, { mouseOverText = namemouseovertext, color = namecolor })
		row[4]:createText(workplace)
		row[6]:createText(assignment, { color = roleColor, mouseOverText = mouseovertext })
		row[9]:createText(Helper.displaySkill(adjustedskill), { color = Color["text_skills"], halign = "right", mouseOverText = ReadText(1026, 2) })
		if isexpanded then
			local numskills = C.GetNumSkills()
			local skilltable = ffi.new("Skill2[?]", numskills + 1)
			if employeedata.type == "person" then
				numskills = C.GetPersonSkillsForAssignment(skilltable, C.ConvertStringTo64Bit(tostring(employeedata.id)), C.ConvertStringTo64Bit(tostring(employeedata.container)), role, post)
			else
				numskills = C.GetEntitySkillsForAssignment(skilltable, C.ConvertStringTo64Bit(tostring(employeedata.id)), role, post)
			end
			local sortedskilltable = {}
			for i = 1, numskills do
				table.insert(sortedskilltable, skilltable[i])
			end
			table.sort(sortedskilltable, function(a, b) return a.relevance > b.relevance end)
			for i, skill in ipairs(sortedskilltable) do
				local skillname = ReadText(1013, skill.textid)
				local printedskill = Helper.displaySkill(skill.value, skill.relevance > 0)
				local mouseovertext = ReadText(1013, skill.descriptionid)
				local row = infotable:addRow(nil, {  })
				row[2]:createText(skillname, { font = (skill.relevance > 0) and Helper.standardFontBold or nil, color = (skill.relevance > 0) and Color["text_normal"] or Color["text_inactive"], mouseOverText = mouseovertext })
				row[4]:createText(printedskill, { halign = "left", color = (skill.relevance > 0) and Color["text_skills"] or Color["text_skills_irrelevant"], mouseOverText = mouseovertext })
			end
		end
	end

	if not found then
		menu.personnelData.curEntry = {}
	end

	infotable:setTopRow(menu.settoprow)
	infotable:setSelectedRow(menu.setselectedrow)
	menu.settoprow = nil
	menu.setselectedrow = nil

	-- media & description
	if menu.personnelData.curEntry and next(menu.personnelData.curEntry) then
		local width = math.floor(infotablewidth / 2)
		local height = width
		if height > Helper.viewHeight / 2 then
			height = math.floor(Helper.viewHeight / 2)
			width = height
		end
		local x = tableProperties.x + infotablewidth + Helper.borderSize
		local mediaProperties = { width = width, x = x, height = height, y = tableProperties.y }

		if menu.personnelData.curEntry.type == "entity" then
			menu.rendertarget = frame:addRenderTarget(mediaProperties)
			if tostring(menu.personnelData.curEntry.id) ~= tostring(menu.personnelData.renderobject) then
				menu.personnelData.activatecutscene = true
			end
		end

		local descriptiontable = frame:addTable(2, { tabOrder = 0, width = width, x = x, y = tableProperties.y + height + Helper.borderSize })
		descriptiontable:setColWidthPercent(1, 33)
		-- no video icon
		if menu.personnelData.curEntry.type ~= "entity" then
			descriptiontable.properties.y = tableProperties.y
			local row = descriptiontable:addRow(nil, { fixed = true })
			row[1]:setColSpan(2):createIcon("briefing_no_video", { width = width, height = height, scaling = false })
		end
		-- details
		local row = descriptiontable:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
		row[1]:setColSpan(2):createText(ReadText(1001, 2961), Helper.titleTextProperties)
		-- name
		local row = descriptiontable:addRow(nil, { fixed = true })
		row[1]:createText(ReadText(1001, 2809) .. ReadText(1001, 120))
		row[2]:createText(menu.personnelData.curEntry.name, { halign = "right" })
		-- skills
		local numskills = C.GetNumSkills()
		local skilltable = ffi.new("Skill2[?]", numskills + 1)
		if menu.personnelData.curEntry.type == "person" then
			numskills = C.GetPersonSkillsForAssignment(skilltable, C.ConvertStringTo64Bit(tostring(menu.personnelData.curEntry.id)), C.ConvertStringTo64Bit(tostring(menu.personnelData.curEntry.container)), role, post)
		else
			numskills = C.GetEntitySkillsForAssignment(skilltable, C.ConvertStringTo64Bit(tostring(menu.personnelData.curEntry.id)), role, post)
		end
		local sortedskilltable = {}
		for i = 1, numskills do
			table.insert(sortedskilltable, skilltable[i])
		end
		table.sort(sortedskilltable, function(a, b) return a.relevance > b.relevance end)
		for i, skill in ipairs(sortedskilltable) do
			local skillname = ReadText(1013, skill.textid)
			local printedskill = Helper.displaySkill(skill.value, skill.relevance > 0)
			local mouseovertext = ReadText(1013, skill.descriptionid)
			local row = descriptiontable:addRow(nil, {  })
			row[1]:createText("   " .. skillname, { font = (skill.relevance > 0) and Helper.standardFontBold or nil, color = (skill.relevance > 0) and Color["text_normal"] or Color["text_inactive"], mouseOverText = mouseovertext })
			row[2]:createText(printedskill, { halign = "right", color = (skill.relevance > 0) and Color["text_skills"] or Color["text_skills_irrelevant"], mouseOverText = mouseovertext })
		end
		-- workplace
		local row = descriptiontable:addRow(nil, { fixed = true })
		row[1]:createText(ReadText(1001, 11037) .. ReadText(1001, 120))
		row[2]:createText(menu.personnelData.curEntry.containername, { halign = "right" })
		-- location
		local row = descriptiontable:addRow(nil, { fixed = true })
		row[1]:createText(ReadText(1001, 11039) .. ReadText(1001, 120))
		row[2]:createText(function () return GetComponentData(menu.personnelData.curEntry.container, "sector") end, { halign = "right" })
		-- role
		local row = descriptiontable:addRow(nil, { fixed = true })
		row[1]:createText(ReadText(1001, 11200) .. ReadText(1001, 120))
		row[2]:createText(menu.personnelData.curEntry.rolename, { halign = "right" })
		-- current command
		if (menu.personnelData.curEntry.type == "entity") and (menu.personnelData.curEntry.roleid == "aipilot") then
			local aicommandstack, aicommand, aicommandparam, aicommandaction, aicommandactionparam = GetComponentData(menu.personnelData.curEntry.id, "aicommandstack", "aicommand", "aicommandparam", "aicommandaction", "aicommandactionparam")
			local row = descriptiontable:addRow(nil, { fixed = true })
			row[1]:createText(ReadText(1001, 78) .. ReadText(1001, 120))
			if #aicommandstack > 0 then
				aicommand = aicommandstack[1].command
				aicommandparam = aicommandstack[1].param
			end
			row[2]:createText(string.format(aicommand, IsComponentClass(aicommandparam, "component") and GetComponentData(aicommandparam, "name") or nil), { halign = "right" })
			local row = descriptiontable:addRow(nil, { fixed = true })
			local numaicommands = #aicommandstack
			if numaicommands > 1 then
				aicommandaction = aicommandstack[numaicommands].command
				aicommandactionparam = aicommandstack[numaicommands].param
			end
			row[2]:createText(string.format(aicommandaction, IsComponentClass(aicommandactionparam, "component") and GetComponentData(aicommandactionparam, "name") or nil), { halign = "right" })
		end
	end

	infotable:addConnection(1, 2, true)
end

function menu.roleSorter(a, b, invert)
	if a.rolename == b.rolename then
		if a.skill == b.skill then
			return a.name < b.name
		end
		return a.combinedskill > b.combinedskill
	end
	if invert then
		return a.rolename > b.rolename
	else
		return a.rolename < b.rolename
	end
end

function menu.skillSorter(a, b, invert)
	if a.skill == b.skill then
		return a.name < b.name
	end
	if invert then
		return a.skill < b.skill
	else
		return a.skill > b.skill
	end
end

function menu.workplaceSorter(a, b, invert)
	if a.containername == b.containername then
		return a.name < b.name
	end
	if invert then
		return a.containername > b.containername
	else
		return a.containername < b.containername
	end
end

function menu.getEmployeeList()
	local role, post
	if menu.crewRole ~= "current" then
		local type, id = string.match(menu.personnelData.role, "(.+):(.+)")
		if type == "post" then
			post = id
		elseif type == "role" then
			role = id
		end
	end

	local numroles = C.GetNumAllRoles()
	local peopletable = ffi.new("PeopleInfo[?]", numroles)

	-- give the empire employee list an update to avoid referencing destroyed objects
	local numhiredpersonnel = 0
	local empireemployees = {}

	local numownedships = C.GetNumAllFactionShips("player")
	local allownedships = ffi.new("UniverseID[?]", numownedships)
	numownedships = C.GetAllFactionShips(allownedships, numownedships, "player")
	for i = 0, numownedships - 1 do
		local locship = ConvertStringTo64Bit(tostring(allownedships[i]))
		local shipmacro, isdeployable = GetComponentData(locship, "macro", "isdeployable")
		local islasertower, locshipware = GetMacroData(shipmacro, "islasertower", "ware")
		local isunit = C.IsUnit(locship)
		if locshipware and (not isunit) and (not islasertower) and (not isdeployable) then
			local shipname, pilot, isdeployable = GetComponentData(locship, "name", "assignedaipilot", "isdeployable")
			shipname = shipname .. " (" .. ffi.string(C.GetObjectIDCode(locship)) .. ")"
			if pilot and IsValidComponent(pilot) then
				local name, combinedskill, poststring, postname = GetComponentData(pilot, "name", "combinedskill", "poststring", "postname")
				table.insert(empireemployees, { id = ConvertIDTo64Bit(pilot), type = "entity", name = name, combinedskill = combinedskill, roleid = poststring, rolename = postname, container = locship, containername = shipname })
				numhiredpersonnel = numhiredpersonnel + 1
			end
			local locnumroles = C.GetPeople2(peopletable, numroles, locship, true)
			for i = 0, locnumroles - 1 do
				numhiredpersonnel = numhiredpersonnel + peopletable[i].amount
				local roleid = ffi.string(peopletable[i].id)
				local rolename = ffi.string(peopletable[i].name)
				local numtiers = peopletable[i].numtiers
				--print("role: " .. tostring(roleid) .. ", rolename: " .. tostring(rolename) .. ", numtiers: " .. tostring(numtiers))
				if numtiers > 0 then
					local tiertable = ffi.new("RoleTierData[?]", numtiers)
					numtiers = C.GetRoleTiers(tiertable, numtiers, locship, peopletable[i].id)
					for j = 0, numtiers - 1 do
						local numpersons = tiertable[j].amount
						if numpersons > 0 then
							local persontable = GetRoleTierNPCs(locship, roleid, tiertable[j].skilllevel)
							for k, person in ipairs(persontable) do
								table.insert(empireemployees, { id = person.seed, type = "person", name = person.name, combinedskill = person.combinedskill, roleid = roleid, rolename = rolename, container = locship, containername = shipname })
							end
						end
					end
				elseif roleid == "unassigned" then
					local persontable = GetRoleTierNPCs(locship, roleid, 0)
					--print("numpersons: " .. tostring(#persontable))
					for k, person in ipairs(persontable) do
						--print(k .. ": " .. person.name)
						table.insert(empireemployees, { id = person.seed, type = "person", name = person.name, combinedskill = person.combinedskill, roleid = roleid, rolename = rolename, container = locship, containername = shipname })
					end
				end
			end
		end
	end

	local numownedstations = C.GetNumAllFactionStations("player")
	local allownedstations = ffi.new("UniverseID[?]", numownedstations)
	numownedstations = C.GetAllFactionStations(allownedstations, numownedstations, "player")
	for i = 0, numownedstations - 1 do
		local locstation = ConvertStringTo64Bit(tostring(allownedstations[i]))
		local stationname, manager, shiptrader = GetComponentData(locstation, "name", "tradenpc", "shiptrader")
		stationname = stationname .. " (" .. ffi.string(C.GetObjectIDCode(locstation)) .. ")"
		if manager then
			local name, combinedskill, poststring, postname = GetComponentData(manager, "name", "combinedskill", "poststring", "postname")
			table.insert(empireemployees, { id = ConvertIDTo64Bit(manager), type = "entity", name = name, combinedskill = combinedskill, roleid = poststring, rolename = postname, container = locstation, containername = stationname })
			numhiredpersonnel = numhiredpersonnel + 1
		end
		if shiptrader then
			local name, combinedskill, poststring, postname = GetComponentData(shiptrader, "name", "combinedskill", "poststring", "postname")
			table.insert(empireemployees, { id = ConvertIDTo64Bit(shiptrader), type = "entity", name = name, combinedskill = combinedskill, roleid = poststring, rolename = postname, container = locstation, containername = stationname })
			numhiredpersonnel = numhiredpersonnel + 1
		end
	end
	menu.empireData.employees = empireemployees
	menu.empireData.numhiredpersonnel = numhiredpersonnel

	local filteredemployees = {}
	for _, employeedata in ipairs(menu.empireData.employees) do
		if (menu.personnelData.searchtext == "") or menu.employeeSearchHelper(employeedata, menu.personnelData.searchtext) then
			if menu.personnelData.role == "current" then
				employeedata.skill = employeedata.combinedskill
			else
				if employeedata.type == "person" then
					employeedata.skill = C.GetPersonCombinedSkill(C.ConvertStringTo64Bit(tostring(employeedata.container)), C.ConvertStringTo64Bit(tostring(employeedata.id)), role, post)
				else
					employeedata.skill = C.GetEntityCombinedSkill(C.ConvertStringTo64Bit(tostring(employeedata.id)), role, post)
				end
			end
			table.insert(filteredemployees, employeedata)
		end
	end
	menu.empireData.filteredemployees = filteredemployees
end

function menu.employeeSearchHelper(entry, text)
	text = utf8.lower(text)

	if string.find(utf8.lower(entry.name), text, 1, true) then
		return true
	end
	if string.find(utf8.lower(entry.containername), text, 1, true) then
		return true
	end
	if string.find(utf8.lower(entry.rolename), text, 1, true) then
		return true
	end

	return false
end

function menu.initEmpireData()
	menu.empireData.name = ffi.string(C.GetPlayerName())
	menu.empireData.factionname = ffi.string(C.GetPlayerFactionName(true))

	local shipworth = 0
	local stationworth = 0
	local inventoryworth = 0
	local cash = GetPlayerMoney()
	local onlineworth = 0
	local numonlineships = 0

	local ships = {}
	local stations = {}

	local numownedships = C.GetNumAllFactionShips("player")
	local allownedships = ffi.new("UniverseID[?]", numownedships)
	numownedships = C.GetAllFactionShips(allownedships, numownedships, "player")
	--print("num owned ships: " .. numownedships .. ", all owned ships:")
	for i = 0, numownedships - 1 do
		--print(ffi.string(C.GetComponentName(allownedships[i])))
		local locship = ConvertStringTo64Bit(tostring(allownedships[i]))
		local shipmacro, isdeployable = GetComponentData(locship, "macro", "isdeployable")
		local islasertower, locshipware = GetMacroData(shipmacro, "islasertower", "ware")
		local isunit = C.IsUnit(locship)
		if locshipware and (not isunit) and (not islasertower) and (not isdeployable) then
			local shipname, isonlineobject, shipsize = GetComponentData(locship, "name", "isonlineobject", "size")
			shipname = shipname .. " (" .. ffi.string(C.GetObjectIDCode(locship)) .. ")"
				local locshipworth = GetWareData(locshipware, "avgprice")
				shipworth = shipworth + locshipworth
			table.insert(ships, { ship = locship, size = shipsize })

				if isonlineobject then
					numonlineships = numonlineships + 1
				end
						end
					end
	table.sort(ships, function (a, b) return a.size > b.size end)

	local numownedstations = C.GetNumAllFactionStations("player")
	local allownedstations = ffi.new("UniverseID[?]", numownedstations)
	numownedstations = C.GetAllFactionStations(allownedstations, numownedstations, "player")
	local totalstationaccountcash = 0
	for i = 0, numownedstations - 1 do
		local locstation = ConvertStringTo64Bit(tostring(allownedstations[i]))
		local stationname, buildstorage, manager, shiptrader = GetComponentData(locstation, "name", "buildstorage", "tradenpc", "shiptrader")
		stationname = stationname .. " (" .. ffi.string(C.GetObjectIDCode(locstation)) .. ")"
		if C.IsComponentClass(locstation, "container") then
			totalstationaccountcash = totalstationaccountcash + (GetAccountData(locstation, "money") or 0)
		end
		table.insert(stations, { station = locstation, name = stationname })

		if buildstorage then
			totalstationaccountcash = totalstationaccountcash + (GetAccountData(buildstorage, "money") or 0)
		end

		local numstationmodules = C.GetNumStationModules(allownedstations[i], false, false)
		local allstationmodules = ffi.new("UniverseID[?]", numstationmodules)
		numstationmodules = C.GetStationModules(allstationmodules, numstationmodules, allownedstations[i], false, false)
		for j = 0, numstationmodules-1 do
			local macro = GetComponentData(ConvertStringTo64Bit(tostring(allstationmodules[j])), "macro")
			local ware = GetMacroData(macro, "ware")
			if ware then
				stationworth = stationworth + GetWareData(ware, "avgprice")
			end
		end
				end
	table.sort(stations, function (a, b) return a.name < b.name end)

	menu.getEmployeeList()

	local onlineitems = OnlineGetUserItems()

	local numinventoryitems = 0
	-- { [ware1] = { name = "", amount = 0, price = 0 }, [ware2] = {} }
	local playerinventory = GetPlayerInventory()
	for item, itemdata in pairs(playerinventory) do
		local isequipment = GetWareData(item, "isequipment")
		if (not isequipment) and (not onlineitems[item]) then
			numinventoryitems = numinventoryitems + 1
			inventoryworth = inventoryworth + itemdata.amount * itemdata.price
		end
	end

	local numplayerpolicesectors = 0
	local clusters = GetClusters(true)
	for _, cluster in ipairs(clusters) do
		local sectors = GetSectors(cluster)
		for _, sector in ipairs(sectors) do
			if GetComponentData(sector, "isplayerowned") then
				numplayerpolicesectors = numplayerpolicesectors + 1
			end
		end
	end

	menu.empireData.networth = shipworth + stationworth + totalstationaccountcash + inventoryworth + cash

	menu.empireData.shipworth = shipworth
	menu.empireData.stationworth = stationworth
	menu.empireData.totalstationaccountcash = totalstationaccountcash
	menu.empireData.inventoryworth = inventoryworth
	menu.empireData.cash = cash

	menu.empireData.numownedships = numownedships
	menu.empireData.numownedstations = numownedstations

	menu.empireData.ships = ships
	menu.empireData.stations = stations

	menu.empireData.numonlineships = numonlineships

	menu.empireData.averagepersonnelskill = C.GetAveragePlayerNPCSkill() * 15 / 100

	menu.empireData.numinventoryitems = numinventoryitems

	menu.empireData.numplayerpolicesectors = numplayerpolicesectors

	menu.empireData.initialized = true
end

function menu.createEmpire(frame, tableProperties)
	--print("menu.createEmpire")
	if not menu.empireData.initialized or menu.empireData.init then
		menu.initEmpireData()
		menu.empireData.init = nil
	end

	if not menu.empireData.mode then
		menu.empireData.mode = {"empire", "name"}
	end

	local narrowtablewidth = Helper.playerInfoConfig.width - menu.sideBarWidth - Helper.borderSize

	-- 4 tables: left, center, topright, bottomright
	-- left: static numrows. selecting rows changes content of center.
	local numCols = (menu.mode == "empire") and 3 or 4
	local table_left = frame:addTable(numCols, { tabOrder = 1, borderEnabled = true, width = narrowtablewidth, x = tableProperties.x, y = tableProperties.y })
	table_left:setColWidth(numCols, Helper.scaleY(config.rowHeight), false)
	table_left:setDefaultBackgroundColSpan(1, numCols)

	local tabOrderOffset = 1
	local properties_table_center = { tabOrder = 2, borderEnabled = true, width = tableProperties.width - (table_left.properties.width * 2) - (Helper.borderSize * 2), x = tableProperties.x + table_left.properties.width + Helper.borderSize, y = tableProperties.y }
	local table_center, table_topright, table_bottomright
	if menu.empireData.mode[1] ~= "empire_call" then
		-- center: content depends on left selection.
		table_center = frame:addTable(5, properties_table_center)
		tabOrderOffset = tabOrderOffset + 1
	end

	-- topright: rendertarget, depends on selection in center.
	local properties_table_topright = { width = narrowtablewidth, x = tableProperties.x + table_left.properties.width + properties_table_center.width + (2 * Helper.borderSize), height = tableProperties.height / 2, y = tableProperties.y }

	-- bottomright: description, depends on selection in center.
	table_bottomright = frame:addTable(1, { tabOrder = 0, borderEnabled = true, width = narrowtablewidth, x = tableProperties.x + table_left.properties.width + properties_table_center.width + (2 * Helper.borderSize), height = tableProperties.height / 2, y = tableProperties.y + properties_table_topright.height })

	--print("widths. left: " .. table_left.properties.width .. ", center: " .. properties_table_center.width .. ", right: " .. properties_table_topright.width)

	if menu.setdefaulttable then
		table_left.properties.defaultInteractiveObject = true
		menu.setdefaulttable = nil
	end

	if menu.mode == "empire" then
		-- Empire Overview
		local row = table_left:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
		row[1]:setColSpan(3):createText(ReadText(1001, 9100), Helper.titleTextProperties)	-- Empire Overview

		-- global properties
		row = table_left:addRow(nil, { bgColor = Color["row_title_background"] })
		row[1]:setColSpan(3):createText(ReadText(1001, 9101), Helper.headerRowCenteredProperties)	-- Global Properties

		row = table_left:addRow({"empire", "name"}, {  })
		row[1]:createText(ReadText(1001, 9102))	-- Player Name
		row[2]:setColSpan(2):createEditBox({ description = ReadText(1001, 9102) }):setText(menu.empireData.name)
		row[2].handlers.onEditBoxDeactivated = menu.editboxChangePlayerName

		row = table_left:addRow({"empire", "name"}, {  })
		row[1]:createText(ReadText(1001, 11006))	-- Player Name
		row[2]:setColSpan(2):createEditBox({ description = ReadText(1001, 11006) }):setText(menu.empireData.factionname)
		row[2].handlers.onEditBoxDeactivated = menu.editboxChangePlayerFactionName

		row = table_left:addRow({"empire_grid", "logo"}, {  })
		row[1]:setColSpan(2):createText(ReadText(1001, 9103))	-- Player Logo
		row[3]:createIcon("widget_arrow_right_01", { height = config.rowHeight, width = config.rowHeight })

		if #menu.empireData.ships > 0 then
			row = table_left:addRow({"empire_grid", "painttheme"}, {  })
		else
			row = table_left:addRow(nil, { bgColor = Color["row_background_unselectable"] })
		end
		row[1]:setColSpan(2):createText(ReadText(1001, 9104))	-- Default Ship Skin
		row[3]:createIcon("widget_arrow_right_01", { height = config.rowHeight, width = config.rowHeight })

		-- TODO: reenable when we get clothing themes
		--[[
		if (C.GetNumAvailableClothingThemes() > 0) then
			if #menu.empireData.employees > 0 then
				row = table_left:addRow({"empire_grid", "uniform"}, {  })
			else
				row = table_left:addRow(nil, { bgColor = Color["row_background_unselectable"] })
			end
			row[1]:setColSpan(2):createText(ReadText(1001, 9105))	-- Default Uniform
			row[3]:createIcon("menu_edit", { height = config.rowHeight, width = config.rowHeight })
		end
		]]

		-- player wealth
		row = table_left:addRow(nil, { bgColor = Color["row_title_background"] })
		row[1]:setColSpan(3):createText(ReadText(1001, 9106), Helper.headerRowCenteredProperties)	-- Player Wealth

		row = table_left:addRow(nil, { bgColor = Color["row_background_unselectable"] })
		--row = table_left:addRow({"empire_call", "networth"}, {  })
		row[1]:createText(ReadText(1001, 9107))	-- Player net worth
		-- string = ConvertMoneyString(money [, showcents [, separators [, accuracy [, notrailingspaces [, colorprefix]]]]])
		row[2]:setColSpan(2):createText((ConvertMoneyString(menu.empireData.networth, false, true) .. ReadText(1001, 101)), { halign = "right" })	-- Cr

		row = table_left:addRow(nil, { bgColor = Color["row_background_unselectable"] })
		row[1]:createText(ReadText(1001, 9108), { x = Helper.standardIndentStep })	-- Total value of ships
		row[2]:setColSpan(2):createText((ConvertMoneyString(menu.empireData.shipworth, false, true) .. ReadText(1001, 101)), { halign = "right" })	-- Cr

		row = table_left:addRow(nil, { bgColor = Color["row_background_unselectable"] })
		row[1]:createText(ReadText(1001, 9109), { x = Helper.standardIndentStep })	-- Total value of stations
		row[2]:setColSpan(2):createText((ConvertMoneyString(menu.empireData.stationworth, false, true) .. ReadText(1001, 101)), { halign = "right" })	-- Cr

		row = table_left:addRow(nil, { bgColor = Color["row_background_unselectable"] })
		row[1]:createText(ReadText(1001, 2202), { x = Helper.standardIndentStep })	-- Inventory
		row[2]:setColSpan(2):createText((ConvertMoneyString(menu.empireData.inventoryworth, false, true) .. ReadText(1001, 101)), { halign = "right" })	-- Cr

		row = table_left:addRow(nil, { bgColor = Color["row_background_unselectable"] })
		--row = table_left:addRow({"empire_call", "cash"}, {  })
		row[1]:createText(ReadText(1001, 9110), { x = Helper.standardIndentStep })	-- Available cash
		row[2]:setColSpan(2):createText((ConvertMoneyString(menu.empireData.cash, false, true) .. ReadText(1001, 101)), { halign = "right" })	-- Cr

		row = table_left:addRow(nil, { bgColor = Color["row_background_unselectable"] })
		row[1]:createText(ReadText(1001, 9111), { x = Helper.standardIndentStep })	-- Total cash in station accounts
		row[2]:setColSpan(2):createText((ConvertMoneyString(menu.empireData.totalstationaccountcash, false, true) .. ReadText(1001, 101)), { halign = "right" })	-- Cr

		-- personnel
		row = table_left:addRow(nil, { bgColor = Color["row_title_background"] })
		row[1]:setColSpan(3):createText(ReadText(1001, 9400), Helper.headerRowCenteredProperties)	-- Personnel

		row = table_left:addRow(nil, { bgColor = Color["row_background_unselectable"] })
		row[1]:createText(ReadText(1001, 9113))	-- Number of hired personnel
		row[2]:setColSpan(2):createText((ConvertIntegerString(menu.empireData.numhiredpersonnel, true)), { halign = "right" })

		row = table_left:addRow(nil, { bgColor = Color["row_background_unselectable"] })
		row[1]:createText(ReadText(1001, 9114))	-- Average personnel skill
		row[2]:setColSpan(2):createText(Helper.displaySkill(menu.empireData.averagepersonnelskill), { color = Color["text_skills"], halign = "right" })

		-- online items
		--[[
		row = table_left:addRow(nil, { bgColor = Color["row_title_background"] })
		row[1]:setColSpan(3):createText(ReadText(1041, 10141), Helper.headerRowCenteredProperties)	-- Online items

		row = table_left:addRow({"empire_list", "onlineitems"}, {  })
		row[1]:createText(ReadText(1001, 9122))	-- Venture Ships
		row[2]:createText((ConvertIntegerString(menu.empireData.numonlineships, true)), { halign = "right" })
		row[3]:createIcon("widget_arrow_right_01", { height = config.rowHeight, width = config.rowHeight }) --]]

		-- sector ownership
		row = table_left:addRow(nil, { bgColor = Color["row_title_background"] })
		row[1]:setColSpan(3):createText(ReadText(1001, 9180), Helper.headerRowCenteredProperties)	-- Government

		row = table_left:addRow({"empire_list", "sectorownership"}, {  })
		row[1]:createText(ReadText(1001, 9601))	-- Police Authority
		row[2]:createText((ConvertIntegerString(menu.empireData.numplayerpolicesectors, true)), { halign = "right" })
		row[3]:createIcon("widget_arrow_right_01", { height = config.rowHeight, width = config.rowHeight })
	else
		local row = table_left:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
		row[1]:setColSpan(4):createText(ReadText(1001, 9171), Helper.titleTextProperties)

		row = table_left:addRow({ "empire_list", "standingorders" }, {  })
		row[1]:setColSpan(4):createText(ReadText(1001, 9301))	-- Global standing orders

		-- trade rules
		row = table_left:addRow(nil, { bgColor = Color["row_title_background"] })
		row[1]:setColSpan(4):createText(ReadText(1001, 11010), Helper.headerRowCenteredProperties)	-- Trade Rules

		menu.traderules = {}
		Helper.ffiVLA(menu.traderules, "TradeRuleID", C.GetNumAllTradeRules, C.GetAllTradeRules)
		for i = #menu.traderules, 1, -1 do
			local id = menu.traderules[i]

			local counts = C.GetTradeRuleInfoCounts(id)
			local buf = ffi.new("TradeRuleInfo")
			buf.numfactions = counts.numfactions
			buf.factions = Helper.ffiNewHelper("const char*[?]", counts.numfactions)
			if C.GetTradeRuleInfo(buf, id) then
				local factions = {}
				for j = 0, buf.numfactions - 1 do
					table.insert(factions, ffi.string(buf.factions[j]))
				end

				local defaults = {
					["trade"] = C.IsPlayerTradeRuleDefault(id, "buy") and C.IsPlayerTradeRuleDefault(id, "sell"),
					["supply"] = C.IsPlayerTradeRuleDefault(id, "supply"),
					["build"] = C.IsPlayerTradeRuleDefault(id, "build"),
				}

				menu.traderules[i] = { id = id, name = ffi.string(buf.name), factions = factions, iswhitelist = buf.iswhitelist, defaults = defaults }
			else
				table.remove(menu.traderules, i)
			end
		end
		table.sort(menu.traderules, Helper.sortID)

		for _, entry in ipairs(menu.traderules) do
			row = table_left:addRow({ "empire_list", "traderule", entry }, {  })
			row[1]:createText(entry.name)
			local defaulttext = ""
			--print(entry.defaults.trade .. ", " .. entry.defaults.supply .. ", " .. entry.defaults.build)
			if entry.defaults.trade and entry.defaults.supply and entry.defaults.build then
				defaulttext = "[" .. ReadText(1001, 9172) .. ReadText(1001, 120) .. " " .. ReadText(1001, 11023) .. "]"
			else
				if entry.defaults.trade then
					if defaulttext == "" then
						defaulttext = "[" .. ReadText(1001, 9172) .. ReadText(1001, 120) .. " "
					else
						defaulttext = defaulttext .. ", "
					end
					defaulttext = defaulttext .. ReadText(1001, 11017)
				end
				if entry.defaults.supply then
					if defaulttext == "" then
						defaulttext = "[" .. ReadText(1001, 9172) .. ReadText(1001, 120) .. " "
					else
						defaulttext = defaulttext .. ", "
					end
					defaulttext = defaulttext .. ReadText(1001, 11018)
				end
				if entry.defaults.build then
					if defaulttext == "" then
						defaulttext = "[" .. ReadText(1001, 9172) .. ReadText(1001, 120) .. " "
					else
						defaulttext = defaulttext .. ", "
					end
					defaulttext = defaulttext .. ReadText(1001, 11019)
				end
				if defaulttext ~= "" then
					defaulttext = defaulttext .. "]"
				end
			end
			row[2]:setColSpan(2):createText(defaulttext, { halign = "right" })
			row[4]:createIcon("menu_edit", { height = config.rowHeight, width = config.rowHeight })
		end

		row = table_left:addRow({ "empire_list", "traderule", {} }, {  })
		row[1]:setColSpan(3):createText(ReadText(1001, 11011))
		row[4]:createIcon("menu_edit", { height = config.rowHeight, width = config.rowHeight })

		-- blacklists
		row = table_left:addRow(nil, { bgColor = Color["row_title_background"] })
		row[1]:setColSpan(4):createText(ReadText(1001, 9143), Helper.headerRowCenteredProperties)	-- Blacklist

		menu.blacklists = Helper.getBlackLists()

		for _, entry in ipairs(menu.blacklists) do
			row = table_left:addRow({ "empire_list", "blacklist", entry }, {  })
			row[1]:createText(entry.name)
			local text = ""
			for _, option in ipairs(config.blacklistTypes) do
				if option.id == entry.type then
					text = option.shorttext
					break
				end
			end
			row[2]:createText(text)
			local defaulttext = ""
			if entry.defaults.civilian and entry.defaults.military then
				defaulttext = "[" .. ReadText(1001, 9172) .. ReadText(1001, 120) .. " " .. ReadText(1001, 9175) .. "]"
			elseif entry.defaults.civilian then
				defaulttext = "[" .. ReadText(1001, 9172) .. ReadText(1001, 120) .. " " .. ReadText(1001, 9173) .. "]"
			elseif entry.defaults.military then
				defaulttext = "[" .. ReadText(1001, 9172) .. ReadText(1001, 120) .. " " .. ReadText(1001, 9174) .. "]"
			end
			row[3]:createText(defaulttext, { halign = "right" })
			row[4]:createIcon("menu_edit", { height = config.rowHeight, width = config.rowHeight })
		end
		row = table_left:addRow({ "empire_list", "blacklist", {} }, {  })
		row[1]:setColSpan(3):createText(ReadText(1001, 9144))
		row[4]:createIcon("menu_edit", { height = config.rowHeight, width = config.rowHeight })

		-- Fire authorization
		row = table_left:addRow(nil, { bgColor = Color["row_title_background"] })
		row[1]:setColSpan(4):createText(ReadText(1001, 7753), Helper.headerRowCenteredProperties)

		menu.fightrules = Helper.getFightRules()

		for _, entry in ipairs(menu.fightrules) do
			row = table_left:addRow({ "empire_list", "fightrule", entry }, {  })
			row[1]:setColSpan(2):createText(entry.name)
			local defaulttext = ""
			if entry.defaults.attack then
				defaulttext = "[" .. ReadText(1001, 9172) .. "]"
			end
			row[3]:createText(defaulttext, { halign = "right" })
			row[4]:createIcon("menu_edit", { height = config.rowHeight, width = config.rowHeight })
		end
		row = table_left:addRow({ "empire_list", "fightrule", {} }, {  })
		row[1]:setColSpan(3):createText(ReadText(1001, 7754))
		row[4]:createIcon("menu_edit", { height = config.rowHeight, width = config.rowHeight })

		-- player alerts
		row = table_left:addRow(nil, { bgColor = Color["row_title_background"] })
		row[1]:setColSpan(4):createText(ReadText(1001, 9183), Helper.headerRowCenteredProperties)	-- Alerts

		menu.playeralerts = {}
		local n = C.GetNumPlayerAlerts()
		local counts = ffi.new("PlayerAlertCounts[?]", n)
		n = C.GetPlayerAlertCounts(counts, n)
		local buf = ffi.new("PlayerAlertInfo2[?]", n)
		for i = 0, n - 1 do
			buf[i].numspaces = counts[i].numspaces
			buf[i].spaceids = Helper.ffiNewHelper("UniverseID[?]", counts[i].numspaces)
		end
		n = C.GetPlayerAlerts2(buf, n)
		for i = 0, n - 1 do
			local entry = {}

			entry.index				= buf[i].index
			entry.interval			= buf[i].interval
			entry.repeats			= buf[i].repeats
			entry.muted				= buf[i].muted
			entry.spaces = {}
			for j = 0, buf[i].numspaces - 1 do
				table.insert(entry.spaces, ConvertStringTo64Bit(tostring(buf[i].spaceids[j])))
			end
			entry.objectclasses		= {}
			for class in string.gmatch(ffi.string(buf[i].objectclass), "[%a_]+") do
				table.insert(entry.objectclasses, class)
			end
			table.sort(entry.objectclasses, menu.sortClasses)
			entry.objectpurpose		= ffi.string(buf[i].objectpurpose)
			entry.objectidcode		= ffi.string(buf[i].objectidcode)
			entry.objectowners		= {}
			for faction in string.gmatch(ffi.string(buf[i].objectowner), "[%a_]+") do
				table.insert(entry.objectowners, faction)
			end
			table.sort(entry.objectowners, Helper.sortFactionName)
			entry.name				= ffi.string(buf[i].name)
			entry.message			= ffi.string(buf[i].message)
			entry.soundid			= ffi.string(buf[i].soundid)

			table.insert(menu.playeralerts, entry)
		end
		Helper.ffiClearNewHelper()

		for _, entry in ipairs(menu.playeralerts) do
			row = table_left:addRow({ "empire_list", "playeralert", entry }, {  })
			row[1]:createText(entry.name)
			local height = Helper.scaleY(config.rowHeight)
			row[3]:createButton({ height = height, width = height, x = row[3]:getWidth() - height, scaling = false }):setIcon(entry.muted and "menu_sound_off" or "menu_sound_on")
			row[3].handlers.onClick = function () if entry.muted then C.UnmutePlayerAlert(entry.index, false) else C.MutePlayerAlert(entry.index) end menu.refreshInfoFrame() end
			row[4]:createIcon("menu_edit", { height = config.rowHeight, width = config.rowHeight })
		end
		row = table_left:addRow({ "empire_list", "playeralert", {} }, {  })
		row[1]:setColSpan(3):createText(ReadText(1001, 9184))
		row[4]:createIcon("menu_edit", { height = config.rowHeight, width = config.rowHeight })
	end

	if menu.setselectedrow then
		table_left:setSelectedRow(menu.setselectedrow)
		menu.setselectedrow = nil
		if menu.settoprow then
			table_left:setTopRow(menu.settoprow)
			menu.settoprow = nil
		end
	end

	local table_called, table_called2 = menu.setupEmpireRows(menu.empireData.mode, properties_table_center, tabOrderOffset, table_center)

	if table_center then
		-- table_center is nil if menu.empireData.mode[1] == "empire_call"
		table_center:setTopRow(menu.setcentertoprow or GetTopRow(menu.buttonTable))
		menu.setcentertoprow = nil
		if menu.setselectedrow2 then
			--print("numvisiblerows: " .. tostring(numvisiblerows) .. ", total height: " .. tostring(tableProperties.height) .. ", row height: " .. tostring(table_center.properties.width / 5 + Helper.borderSize))
			--print("set row: " .. tostring(menu.setselectedrow2))
			table_center:setSelectedRow(menu.setselectedrow2)
			if (menu.empireData.mode[2] == "logo") then
				local numvisiblerows = math.floor(tableProperties.height / (table_center.properties.width / 5 + Helper.borderSize) - 1)
				if menu.setselectedrow2 > numvisiblerows then
					--print("setting top row to: " .. tostring(menu.setselectedrow2 - numvisiblerows + 2))
					table_center:setTopRow(menu.setselectedrow2 - numvisiblerows + 2)
				end
			end
			menu.setselectedrow2 = nil
			if menu.setselectedcol2 then
				--print("set col: " .. tostring(menu.setselectedcol2))
				table_center:setSelectedCol(menu.setselectedcol2)
				menu.setselectedcol2 = nil
			end
		end

		table_left:addConnection(1, 2, true)
		table_center:addConnection(1, 3, true)
	elseif table_called then
		table_left:addConnection(1, 2, true)
		table_called:addConnection(1, 3, true)
		if table_called2 then
			table_called:addConnection(2, 3)
		end
	end

	if menu.empireData.selectedobject then
		-- menu.setupEmpireRenderTarget called from menu.onUpdate
		--print("menu.setupEmpireRenderTarget. object: " .. ffi.string(C.GetComponentName(menu.empireData.selectedobject)))
		menu.activatecutscene = true
		menu.rendertarget = frame:addRenderTarget(properties_table_topright)
	end

	menu.setupEmpireDescription(table_bottomright)
end

function menu.setupEmpireDescription(table_bottomright)
	--print("menu.setupEmpireDescription. object: " .. tostring(menu.empireData.selectedobject))

	-- Description
	local row = table_bottomright:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
	row[1]:createText(ReadText(1001, 2404), Helper.titleTextProperties)	-- Description

	if menu.empireData.mode then
		local descrtext = ""

		if (menu.empireData.mode[2] == "logo") then
			descrtext = ReadText(1001, 9140)		-- Select a logo to be applied to all of your ships.\n\nTo add your own logo, insert an image file to your logos folder. Files in any of the following formats are supported: .bmp, .dds, .gif, .jpg, .png, .tga
		elseif (menu.empireData.mode[2] == "painttheme") then
			descrtext = ReadText(1001, 9141)		-- Select a ship skin to be applied to all of your ships.
		elseif (menu.empireData.mode[2] == "uniform") then
			descrtext = ReadText(1001, 9142)		-- Select a uniform to be used by all of your employees.
		elseif menu.empireData.selectedobject and menu.rendertarget then
			if (menu.empireData.objecttype ~= "ware") then
				descrtext = GetComponentData(menu.empireData.selectedobject, "description")
			else
				descrtext = GetWareData(menu.empireData.selectedobject, "description")
			end
			--print("menu.setupEmpireDescription. object: " .. ffi.string(C.GetComponentName(menu.empireData.selectedobject)))
		elseif menu.empireData.mode[2] == "traderule" then
			descrtext = ReadText(1001, 11012)
		elseif menu.empireData.mode[2] == "blacklist" then
			descrtext = ReadText(1001, 9158)
		elseif menu.empireData.mode[2] == "fightrule" then
			descrtext = ReadText(1001, 7755)
		elseif menu.empireData.mode[2] == "playeralert" then
			descrtext = ReadText(1001, 9185)
		elseif menu.empireData.mode[2] == "sectorownership" then
			descrtext = ReadText(1001, 9182)
		end

		row = table_bottomright:addRow(nil, {  })
		row[1]:createText(tostring(descrtext), { wordwrap = true })
	end
end

function menu.cleanupCutsceneRenderTarget()
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
	menu.personnelData.renderobject = nil
	menu.cutscenedesc = nil
	menu.cutsceneid = nil
	menu.currentrenderobject = nil
end

function menu.setupEmpireRenderTarget()
	--print("menu.setupEmpireRenderTarget. object: " .. tostring(menu.empireData.selectedobject))
	local renderobject = "encyclopedia_dummy_macro"
	local mode = nil
	if menu.empireData.selectedobject then
		if (menu.empireData.objecttype ~= "ware") and menu.empireCanShowObject(menu.empireData.selectedobject) then
			renderobject = menu.empireData.selectedobject
			mode = "object"
			if C.IsComponentClass(renderobject, "npc") then
				mode = "npc"
			end
		elseif (menu.empireData.objecttype == "ware") then
			local video = GetWareData(menu.empireData.selectedobject, "video")
			if video and (video ~= "") then
				renderobject = video
			end
			mode = "ware"
		end
	end
	--print("mode: " .. tostring(mode) .. ", renderobject: " .. tostring(renderobject))

	if not menu.currentrenderobject or not renderobject or (menu.currentrenderobject ~= renderobject) then
		if menu.cutsceneid then
			--print("calling menu.cleanupCutsceneRenderTarget")
			menu.cleanupCutsceneRenderTarget()
			return false
		end

		local rendertargetTexture = GetRenderTargetTexture(menu.rendertarget.id)
		--print("rendertarget id: " .. tostring(menu.rendertarget.id) .. ", rendertarget texture: " .. tostring(rendertargetTexture))
		if rendertargetTexture then
			menu.currentrenderobject = renderobject
			if (mode == "object") then
				menu.cutscenedesc = CreateCutsceneDescriptor("OrbitIndefinitelySlow", {targetobject = renderobject})
			elseif (mode == "npc") then
				menu.cutscenedesc = CreateCutsceneDescriptor("ShowCharacter", {npcref = renderobject})
			elseif not mode or (mode == "ware") then
				menu.precluster, menu.preobject = CreateObjectInPresentationCluster(renderobject, "cluster_black_wlight_bg_macro")
				if menu.preobject then
					menu.cutscenedesc = CreateCutsceneDescriptor("OrbitIndefinitely", {targetobject = menu.preobject})
				end
			end

			if menu.cutscenedesc then
				menu.cutsceneid = StartCutscene(menu.cutscenedesc, rendertargetTexture)
				--print("started cutscene")
			end
		end
	end
	return true
end

function menu.setupMessageRenderTarget()
	if menu.cutsceneid then
		menu.cleanupCutsceneRenderTarget()
		return false
	end
	local rendertargetTexture = GetRenderTargetTexture(menu.rendertarget.id)
	if rendertargetTexture then
		local cutscenekey = menu.messageData.curEntry.cutscenekey
		local cutsceneparameter = GetMessageCutsceneParameter(ConvertStringTo64Bit(tostring(menu.messageData.curEntry.id)), menu.messageData.curEntry.category)

		local refobjects
		if cutscenekey == "OrbitIndefinitely" then
			refobjects = { targetobject = cutsceneparameter }
		end

		menu.cutscenedesc = CreateCutsceneDescriptor(cutscenekey, refobjects)
		if menu.cutscenedesc then
			menu.cutsceneid = StartCutscene(menu.cutscenedesc, rendertargetTexture)
		end
	end
	return true
end

function menu.setupInventoryRenderTarget()
	if menu.cutsceneid then
		menu.cleanupCutsceneRenderTarget()
		return false
	end
	local rendertargetTexture = GetRenderTargetTexture(menu.rendertarget.id)
	if rendertargetTexture then
		local renderobject = "encyclopedia_dummy_macro"
		local video = GetWareData(menu.inventoryData.curEntry[1], "video")
		if video and (video ~= "") then
			renderobject = video
		end
		menu.precluster, menu.preobject = CreateObjectInPresentationCluster(renderobject, "cluster_black_wlight_bg_macro")
		if menu.preobject then
			menu.cutscenedesc = CreateCutsceneDescriptor("OrbitIndefinitely", { targetobject = menu.preobject })
			if menu.cutscenedesc then
				menu.cutsceneid = StartCutscene(menu.cutscenedesc, rendertargetTexture)
			end
		end
	end
	return true
end

function menu.setupPersonnelRenderTarget()
	if menu.cutsceneid then
		menu.cleanupCutsceneRenderTarget()
		return false
	end
	if menu.personnelData.curEntry.type == "entity" then
		local rendertargetTexture = GetRenderTargetTexture(menu.rendertarget.id)
		if rendertargetTexture then
			menu.personnelData.renderobject = menu.personnelData.curEntry.id
			menu.cutscenedesc = CreateCutsceneDescriptor("ShowCharacter", { npcref = menu.personnelData.renderobject })
			if menu.cutscenedesc then
				menu.cutsceneid = StartCutscene(menu.cutscenedesc, rendertargetTexture)
			end
		end
	end
	return true
end

function menu.setupEmpireRows(mode, properties_table_center, tabOrderOffset, table_center)
	local locmode = nil
	if type(mode) == "table" then
		locmode = mode[2]
	else
		DebugError("menu.setupEmpireRows called with invalid mode: " .. tostring(mode))
		return
	end

	if mode[1] == "empire_grid" then
		local buttonheight = table_center.properties.width / 5
		local rowcounter = 0
		local headertext = ""
		local nonetext = ""
		table_center.properties.highlightMode = "column"

		if locmode == "logo" then
			local logooptiondata = { {{}, ReadText(1001, 9126)}, {{}, ReadText(1001, 9127)} }	-- Standard Logos, Custom Logos
			headertext = ReadText(1001, 9125)		-- Logo Selection
			local buf = C.GetCurrentPlayerLogo()
			menu.empireData.currentlogo = { file = ffi.string(buf.file), icon = ffi.string(buf.icon), ispersonal = buf.ispersonal }

			local numlogos = C.GetNumPlayerLogos(true, false)
			local logos = ffi.new("UILogo[?]", numlogos)
			numlogos = C.GetPlayerLogos(logos, numlogos, true, false)
			for i = 0, numlogos-1 do
				--print("inserting logo: " .. ffi.string(logos[i].file))
				table.insert(logooptiondata[1][1], { file = ffi.string(logos[i].file), icon = ffi.string(logos[i].icon), ispersonal = logos[i].ispersonal })
			end
			--print("num standard logos: " .. tostring(numlogos))

			numlogos = C.GetNumPlayerLogos(false, true)
			logos = ffi.new("UILogo[?]", numlogos)
			numlogos = C.GetPlayerLogos(logos, numlogos, false, true)
			for i = 0, numlogos-1 do
				--print("inserting logo: " .. ffi.string(logos[i].file))
				table.insert(logooptiondata[2][1], { file = ffi.string(logos[i].file), icon = ffi.string(logos[i].icon), ispersonal = logos[i].ispersonal })
			end

			local row = table_center:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
			row[1]:setColSpan(5):createText(headertext, Helper.titleTextProperties)

			for _, logodata in ipairs(logooptiondata) do
				row = table_center:addRow(nil, { bgColor = Color["player_info_background"] })
				row[1]:setColSpan(5):createText(logodata[2], Helper.headerRowCenteredProperties)

				local rowbuttoncounter = 6
				if #logodata[1] > 0 then
					for i, logo in ipairs(logodata[1]) do
						if rowbuttoncounter == 6 then
							rowbuttoncounter = 1
							rowcounter = rowcounter + 1
							row = table_center:addRow(("empire_standardlogoselect_" .. rowcounter), {  })
						end

						-- NB: icon more reliable than file name for comparison because file extensions vary.
						if logo.icon == menu.empireData.currentlogo.icon and logo.ispersonal == menu.empireData.currentlogo.ispersonal then
							--print("current logo found: " .. tostring(logo) .. ". row: " .. tostring(rowcounter) .. ", column: " .. tostring(rowbuttoncounter))
							menu.setselectedrow2 = row.index
							menu.setselectedcol2 = rowbuttoncounter
						end

						--print("adding button " .. tostring(rowbuttoncounter) .. " in row " .. tostring(rowcounter) .. " with icon: " .. tostring(logo.icon))
						local locrow = row.index
						local loccol = rowbuttoncounter
						row[rowbuttoncounter]:createButton({ height = buttonheight, scaling = false }):setIcon(logo.icon):setIcon2(function() return menu.logoButtonIcon2(logo) end, { color = function() return menu.logoButtonIcon2Color(logo) end })
						row[rowbuttoncounter].handlers.onClick = function() return menu.buttonSetPlayerLogo(logo, locrow, loccol) end

						rowbuttoncounter = rowbuttoncounter + 1
					end
				else
					row = table_center:addRow("empire_standardlogoselect_none", {  })
					row[1]:setColSpan(5):createText("--- " .. ReadText(1001, 9132) .. " ---")
				end
			end
		else
			local currentthemeid = ""
			local themeoptions = {}

			if locmode == "painttheme" then
				headertext = ReadText(1001, 9119)	-- Ship Skin Selection
				nonetext = ReadText(1001, 9130)		-- (Paint Theme)None
				currentthemeid = ffi.string(C.GetPlayerPaintTheme())
				--print("current theme: " .. tostring(currentthemeid))

				local numpaintthemes = C.GetNumAvailablePaintThemes()
				local paintthemes = ffi.new("UIPaintTheme[?]", numpaintthemes)
				numpaintthemes = C.GetAvailablePaintThemes(paintthemes, numpaintthemes)
				for i = 0, numpaintthemes - 1 do
					local icon = ffi.string(paintthemes[i].Icon)
					table.insert(themeoptions, { id = ffi.string(paintthemes[i].ID), text = ffi.string(paintthemes[i].Name), icon = ffi.string(paintthemes[i].Icon) })
					--print("id: " .. tostring(ffi.string(paintthemes[i].ID)) .. ", name: " .. tostring(ffi.string(paintthemes[i].Name)) .. ", icon: " .. tostring(ffi.string(paintthemes[i].Icon)))
				end
				--print("num paint options: " .. tostring(#themeoptions))
			elseif locmode == "uniform" then
				headertext = ReadText(1001, 9120)	-- Uniform Selection
				nonetext = ReadText(1001, 9131)		-- (Uniform)None
				currentthemeid = ffi.string(C.GetPlayerClothingTheme())
				--print("current theme: " .. tostring(currentthemeid))

				local numuniforms = C.GetNumAvailableClothingThemes()
				local uniforms = ffi.new("UIClothingTheme[?]", numuniforms)
				numuniforms = C.GetAvailableClothingThemes(uniforms, numuniforms)
				for i = 0, numuniforms - 1 do
					table.insert(themeoptions, { id = ffi.string(uniforms[i].ID), text = ffi.string(uniforms[i].Name), icon = "" })
					--print("id: " .. tostring(ffi.string(uniforms[i].ID)) .. ", name: " .. tostring(ffi.string(uniforms[i].Name)) .. ", icon: " .. tostring(ffi.string(uniforms[i].Icon)))
				end
				--print("num paint options: " .. tostring(#themeoptions))
			end

			table.sort(themeoptions, function (a, b) return a.text < b.text end)
			if locmode == "uniform" then
				table.insert(themeoptions, { id = "", text = nonetext, icon = "" })
			end

			local row = table_center:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
			row[1]:setColSpan(5):createText(headertext, Helper.titleTextProperties)

			local rowbuttoncounter = 6
			for i, theme in ipairs(themeoptions) do

				if rowbuttoncounter == 6 then
					rowbuttoncounter = 1
					rowcounter = rowcounter + 1
					row = table_center:addRow(("empire_themeselect_" .. rowcounter), {  })
				end

				local icon2
				if theme.id == currentthemeid then
					--print("current theme found: " .. tostring(theme.id) .. ". row: " .. tostring(rowcounter) .. ", column: " .. tostring(rowbuttoncounter))
					table_center:setSelectedRow(row.index)
					table_center:setSelectedCol(rowbuttoncounter)
					icon2 = "be_upgrade_installed"
				end

				--print("adding button " .. tostring(rowbuttoncounter) .. " in row " .. tostring(rowcounter))
				local locrow = row.index
				local loccol = rowbuttoncounter
				local button = row[rowbuttoncounter]:createButton({ height = buttonheight, scaling = false, mouseOverText = theme.text })
				if theme.icon ~= "" then
					button:setIcon(theme.icon)
				end
				if icon2 then
					button:setIcon2(icon2)
				end
				row[rowbuttoncounter].handlers.onClick = function() return menu.buttonSetDefaultTheme(locmode, theme.id, locrow, loccol) end

				rowbuttoncounter = rowbuttoncounter + 1
			end
		end
	elseif mode[1] == "empire_list" then
		if (locmode == "painttheme") or (locmode == "uniform") then
			local currentthemeid = ""
			local headertext = ""
			local nonetext = ""
			local themeoptions = {}

			if (locmode == "painttheme") then
				headertext = ReadText(1001, 9119)	-- Ship Skin Selection
				nonetext = ReadText(1001, 9130)		-- (Paint Theme)None
				currentthemeid = ffi.string(C.GetPlayerPaintTheme())
				--print("current theme: " .. tostring(currentthemeid))

				local numpaintthemes = C.GetNumAvailablePaintThemes()
				local paintthemes = ffi.new("UIPaintTheme[?]", numpaintthemes)
				numpaintthemes = C.GetAvailablePaintThemes(paintthemes, numpaintthemes)
				for i = 0, numpaintthemes-1 do
					--table.insert(themeoptions, { id = ffi.string(paintthemes[i].ID), text = ffi.string(paintthemes[i].Name), icon = ffi.string(paintthemes[i].Icon) })
					table.insert(themeoptions, { id = ffi.string(paintthemes[i].ID), text = ffi.string(paintthemes[i].Name), icon = "" })
					--print("id: " .. tostring(ffi.string(paintthemes[i].ID)) .. ", name: " .. tostring(ffi.string(paintthemes[i].Name)) .. ", icon: " .. tostring(ffi.string(paintthemes[i].Icon)))
				end
				--print("num paint options: " .. tostring(#themeoptions))
			elseif (locmode == "uniform") then
				headertext = ReadText(1001, 9120)	-- Uniform Selection
				nonetext = ReadText(1001, 9131)		-- (Uniform)None
				currentthemeid = ffi.string(C.GetPlayerClothingTheme())
				--print("current theme: " .. tostring(currentthemeid))

				local numuniforms = C.GetNumAvailableClothingThemes()
				local uniforms = ffi.new("UIClothingTheme[?]", numuniforms)
				numuniforms = C.GetAvailableClothingThemes(uniforms, numuniforms)
				for i = 0, numuniforms-1 do
					--table.insert(themeoptions, { id = ffi.string(uniforms[i].ID), text = ffi.string(uniforms[i].Name), icon = ffi.string(uniforms[i].Icon) })
					table.insert(themeoptions, { id = ffi.string(uniforms[i].ID), text = ffi.string(uniforms[i].Name), icon = "" })
					--print("id: " .. tostring(ffi.string(uniforms[i].ID)) .. ", name: " .. tostring(ffi.string(uniforms[i].Name)) .. ", icon: " .. tostring(ffi.string(uniforms[i].Icon)))
				end
				--print("num paint options: " .. tostring(#themeoptions))
			end

			table.sort(themeoptions, function (a, b) return a.text < b.text end)
			table.insert(themeoptions, { id = "", text = nonetext, icon = "" })

			local row = table_center:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
			row[1]:setColSpan(5):createText(headertext, Helper.titleTextProperties)

			for i, theme in ipairs(themeoptions) do
				--print("adding " .. tostring(locmode) .. " theme: " .. tostring(theme.id))
				row = table_center:addRow({locmode, theme.id}, {  })
				row[1]:setColSpan(5):createText(theme.text)

				--print("current theme: " .. tostring(currentthemeid) .. ", this theme: " .. tostring(theme.id))
				if theme.id == currentthemeid then
					menu.setselectedrow2 = row.index
				end
			end
		elseif locmode == "ships" then
			local row = table_center:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
			row[1]:setColSpan(5):createText(ReadText(1001, 6), Helper.titleTextProperties)	-- Ships

			row = table_center:addRow(nil, { fixed = true })
			row[1]:setColSpan(3):createText(ReadText(1001, 2809))	-- Name
			row[4]:createText(ReadText(1001, 9051))	-- Ship Type
			row[5]:createText(ReadText(1001, 2943))	-- Location
			for i, ship in ipairs(menu.empireData.ships) do
				local name, shiptype, location, isonlineobject = GetComponentData(ship.ship, "name", "shiptypename", "sector", "isonlineobject")
				if isonlineobject then
					location = ReadText(1001, 9121)	-- On venture
				end
				row = table_center:addRow({ "empire_ship", ship.ship }, {  })
				row[1]:setColSpan(3):createText(name)
				row[4]:createText(shiptype)
				row[5]:createText(location)
			end
		elseif locmode == "stations" then
			local row = table_center:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
			row[1]:setColSpan(5):createText(ReadText(1001, 4), Helper.titleTextProperties)	-- Stations

			row = table_center:addRow(nil, { fixed = true })
			row[1]:setColSpan(4):createText(ReadText(1001, 2809))	-- Name
			row[5]:createText(ReadText(1001, 2943))	-- Location

			for i, station in ipairs(menu.empireData.stations) do
				local name, sector = GetComponentData(station.station, "name", "sector")
				row = table_center:addRow({"empire_station", station.station}, {  })
				row[1]:setColSpan(4):createText(name)
				row[5]:createText(sector)
			end
		elseif locmode == "standingorders" then
			table_center:setColWidth(1, Helper.standardTextHeight)
			table_center:setColWidthPercent(2, 45)
			table_center:setColWidthPercent(4, 20)
			table_center:setColWidthPercent(5, 20)

			local row = table_center:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
			row[1]:setColSpan(5):createText(ReadText(1001, 9301), Helper.titleTextProperties)	-- Global Standing Orders

			local faction = "player"
			menu.signals = {}
			local numsignals = C.GetNumAllSignals()
			local allsignals = ffi.new("SignalInfo[?]", numsignals)
			numsignals = C.GetAllSignals(allsignals, numsignals)
			for i = 0, numsignals - 1 do
				local signalid = ffi.string(allsignals[i].id)
				table.insert( menu.signals, {id = signalid, name = ffi.string(allsignals[i].name), description = ffi.string(allsignals[i].description), defaultresponse = ffi.string(allsignals[i].defaultresponse), ask = allsignals[i].ask, responses = {} })

				local numresponses = C.GetNumAllResponsesToSignal(signalid)
				local allresponses = ffi.new("ResponseInfo[?]", numresponses)
				numresponses = C.GetAllResponsesToSignal(allresponses, numresponses, signalid)
				for j = 0, numresponses - 1 do
					table.insert(menu.signals[#menu.signals].responses, { id = ffi.string(allresponses[j].id), name = ffi.string(allresponses[j].name), description = ffi.string(allresponses[j].description) })
				end
			end

			for _, signalentry in ipairs(menu.signals) do
				local signalid = signalentry.id
				local defask = C.GetAskToSignalForFaction(signalid, faction)
				local defresponse = ffi.string(C.GetDefaultResponseToSignalForFaction2(signalid, faction, ""))
				local defresponse_military = ffi.string(C.GetDefaultResponseToSignalForFaction2(signalid, faction, "fight"))
				if not C.HasDefaultResponseToSignalForFaction(signalid, faction, "fight") then
					defresponse_military = "default"
				end
				local locresponses = {}
				local locresponses_military = {
					{ id = "default", text = ReadText(1001, 7789), icon = "", displayremoveoption = false },
				}
				for _, responseentry in ipairs(signalentry.responses) do
					table.insert(locresponses, { id = responseentry.id, text = responseentry.name, icon = "", displayremoveoption = false })
					table.insert(locresponses_military, { id = responseentry.id, text = responseentry.name, icon = "", displayremoveoption = false })
				end

				local row = table_center:addRow("orders_" .. tostring(signalid) .. "_response")
				row[1]:setColSpan(2):createText(ReadText(1001, 9320) .. " " .. tostring(signalentry.name) .. ReadText(1001, 120), textproperties)	-- Default global response to, :
				row[3]:setColSpan(3):createDropDown(locresponses, { height = Helper.standardTextHeight, startOption = defresponse }):setTextProperties({ fontsize = config.mapFontSize })
				row[3].handlers.onDropDownConfirmed = function(_, newresponseid) return menu.dropdownOrdersSetResponse(newresponseid, faction, signalid, "factionresponses", "all") end

				local row = table_center:addRow("orders_" .. tostring(signalid) .. "_response_military")
				row[2]:createText(ReadText(1001, 9150) .. ReadText(1001, 120))
				row[3]:setColSpan(3):createDropDown(locresponses_military, { height = Helper.standardTextHeight, startOption = defresponse_military, active = hasmilitaryoverride }):setTextProperties({ fontsize = config.mapFontSize })
				row[3].handlers.onDropDownConfirmed = function(_, newresponseid) return menu.dropdownOrdersSetResponse(newresponseid, faction, signalid, "factionresponses", "military") end

				local row = table_center:addRow("orders_" .. tostring(signalid) .. "_ask")
				row[1]:createCheckBox(defask, { width = Helper.standardTextHeight, height = Helper.standardTextHeight })
				row[1].handlers.onClick = function() return menu.checkboxOrdersSetAsk(faction, signalid, "factionresponses", row.index) end
				row[2]:setColSpan(2):createText(ReadText(1001, 9330), textproperties)	-- Notify me if incident occurs
				row[4]:setColSpan(2):createButton({ height = Helper.standardTextHeight, mouseOverText = ReadText(1026, 7714) }):setText(ReadText(1001, 7788), { halign = "center" })
				row[4].handlers.onClick = function () return menu.dropdownOrdersSetResponse("reset", faction, signalid, "factionresponses") end

				table_center:addEmptyRow()
			end

			-- preferred build method
			local row = table_center:addRow(false, { bgColor = Color["row_background_unselectable"] })
			row[1]:setColSpan(5):createText(ReadText(1001, 7775) .. ReadText(1001, 120), textproperties)

			local cursetting = ffi.string(C.GetPlayerBuildMethod())
			local foundcursetting = false
			local locresponses = {}
			local n = C.GetNumPlayerBuildMethods()
			if n > 0 then
				local buf = ffi.new("ProductionMethodInfo[?]", n)
				n = C.GetPlayerBuildMethods(buf, n)
				for i = 0, n - 1 do
					local id = ffi.string(buf[i].id)
					-- check if the cursetting (which can be the method of the player's race) is in the list of options
					if id == cursetting then
						foundcursetting = true
					end
					table.insert(locresponses, { id = id, text = ffi.string(buf[i].name), icon = "", displayremoveoption = false })
				end
			end
			-- if the setting is not in the list, default to default (if the race method is not in the list, there is no ware that has this method and it will always use default)
			if not foundcursetting then
				cursetting = "default"
			end

			local row = table_center:addRow("orders_buildmethod", {  })
			row[1]:setColSpan(5):createDropDown(locresponses, { height = Helper.standardTextHeight, startOption = cursetting }):setTextProperties({ fontsize = config.mapFontSize })
			row[1].handlers.onDropDownConfirmed = menu.dropdownOrdersBuildRule

			table_center:addEmptyRow()

			-- resupply
			local row = table_center:addRow(false, { bgColor = Color["row_background_unselectable"] })
			row[1]:setColSpan(5):createText(ReadText(1001, 7721) .. ReadText(1001, 120), textproperties)

			local locresponses = {
				{ id = 0,   text = ReadText(1001, 7726), icon = "", displayremoveoption = false },
				{ id = 0.1, text = ReadText(1001, 7736), icon = "", displayremoveoption = false },
				{ id = 0.5, text = ReadText(1001, 7737), icon = "", displayremoveoption = false },
				{ id = 1.0, text = ReadText(1001, 7738), icon = "", displayremoveoption = false },
			}
			local row = table_center:addRow("orders_resupply", {})
			row[1]:setColSpan(5):createDropDown(locresponses, { height = Helper.standardTextHeight, startOption = Helper.round(C.GetPlayerGlobalLoadoutLevel(), 1) }):setTextProperties({ fontsize = config.mapFontSize })
			row[1].handlers.onDropDownConfirmed = menu.dropdownOrdersResupply

			table_center:addEmptyRow()

			-- trade loop
			local row = table_center:addRow(false, { bgColor = Color["row_background_unselectable"] })
			row[1]:setColSpan(5):createText(ReadText(1001, 7785) .. ReadText(1001, 120), textproperties)

			local locresponses = {
				{ id = "off",   text = ReadText(1001, 7726),  icon = "", displayremoveoption = false, mouseovertext = ReadText(1026, 3276) },
				{ id = "on",    text = ReadText(1001, 11643), icon = "", displayremoveoption = false },
			}
			local row = table_center:addRow("orders_cargoreservations", {  })
			row[1]:setColSpan(5):createDropDown(locresponses, { height = Helper.standardTextHeight, startOption = C.GetPlayerGlobalTradeLoopCargoReservationSetting() and "on" or "off" }):setTextProperties({ fontsize = config.mapFontSize })
			row[1].handlers.onDropDownConfirmed = menu.dropdownOrdersCargoReservations

			table_center:addEmptyRow()

			-- default weapon mode
			local row = table_center:addRow(false, { bgColor = Color["row_background_unselectable"] })
			row[1]:setColSpan(5):createText(ReadText(1001, 7774) .. ReadText(1001, 120), textproperties)

			local weaponmodes = {
				[1] = { id = "defend",			text = ReadText(1001, 8613),	icon = "",	displayremoveoption = false },
				[2] = { id = "attackenemies",	text = ReadText(1001, 8614),	icon = "",	displayremoveoption = false },
				[3] = { id = "attackcapital",	text = ReadText(1001, 8634),	icon = "",	displayremoveoption = false },
				[4] = { id = "prefercapital",	text = ReadText(1001, 8637),	icon = "",	displayremoveoption = false },
				[5] = { id = "attackfighters",	text = ReadText(1001, 8635),	icon = "",	displayremoveoption = false },
				[6] = { id = "preferfighters",	text = ReadText(1001, 8638),	icon = "",	displayremoveoption = false },
				[7] = { id = "missiledefence",	text = ReadText(1001, 8636),	icon = "",	displayremoveoption = false },
				[8] = { id = "prefermissiles",	text = ReadText(1001, 8639),	icon = "",	displayremoveoption = false },
			}
			local row = table_center:addRow("orders_weaponmode", {})
			row[1]:setColSpan(5):createDropDown(weaponmodes, { height = Helper.standardTextHeight, startOption = ffi.string(C.GetFactionDefaultWeaponMode("player")) }):setTextProperties({ fontsize = config.mapFontSize })
			row[1].handlers.onDropDownConfirmed = function (_, id) return C.SetFactionDefaultWeaponMode("player", id) end

			table_center:addEmptyRow()

			-- wait for undock/signal
			local row = table_center:addRow(false, { bgColor = Color["row_background_unselectable"] })
			row[1]:setColSpan(5):createText(ReadText(1001, 9331) .. ReadText(1001, 120), textproperties)

			local row = table_center:addRow("playershipswait", {})
			local waiting = C.ShouldPlayerShipsWaitForPlayer()
			row[1]:createCheckBox(waiting, { width = Helper.standardTextHeight, height = Helper.standardTextHeight })
			row[1].handlers.onClick = function(_, checked) C.SetPlayerShipsWaitForPlayer(checked) end
			row[1].properties.uiTriggerID = "playershipswait"
			row[2]:setColSpan(4):createText(ReadText(1001, 9332), textproperties)

			local row = table_center:addRow("playertaxiwait", {})
			local waiting = C.ShouldPlayerTaxiWaitForPlayer()
			row[1]:createCheckBox(waiting, { width = Helper.standardTextHeight, height = Helper.standardTextHeight })
			row[1].handlers.onClick = function(_, checked) C.SetPlayerTaxiWaitsForPlayer(checked) end
			row[1].properties.uiTriggerID = "playertaxiwait"
			row[2]:setColSpan(4):createText(ReadText(1001, 9333), textproperties)

			local row = table_center:addRow("global_standing_orders_reset", {  })
			row[4]:setColSpan(2):createButton({  }):setText(ReadText(1001, 7786), { halign = "center" })
			row[4].handlers.onClick = menu.buttonResetGlobalStandingOrders

			table_center:addEmptyRow()

			-- notifications
			local row = table_center:addRow(nil, { bgColor = Color["row_title_background"] })
			row[1]:setColSpan(5):createText(ReadText(1001, 7727), Helper.titleTextProperties)	-- Notification Settings

			menu.typecategories = {
				[1] = { category = "npc_interactive",	name = ReadText(1001, 7728),	types = {} },
				[2] = { category = "npc_info",			name = ReadText(1001, 7729),	types = {} },
				[3] = { category = "ticker",			name = ReadText(1001, 7743),	types = {} },
			}
			local n = C.GetNumNotificationTypes()
			local buf = ffi.new("UINotificationType2[?]", n)
			n = C.GetNotificationTypes2(buf, n)
			for i = 0, n - 1 do
				local category = ffi.string(buf[i].category)
				for _, entry in ipairs(menu.typecategories) do
					if entry.category == category then
						table.insert(entry.types, { id = ffi.string(buf[i].id), name = ffi.string(buf[i].name), desc = ffi.string(buf[i].desc), enabled = buf[i].enabled, enabledByDefault = buf[i].enabledByDefault })
						if entry.checkedcounts == nil then
							entry.checkedcounts = 0
						end
						if buf[i].enabled then
							entry.checkedcounts = entry.checkedcounts + 1
						end
						break
					end
				end
			end

			local hasrows = false
			for i, entry in ipairs(menu.typecategories) do
				if #entry.types ~= 0 then
					if hasrows then
						table_center:addEmptyRow()
					end

					local row = table_center:addRow(true, { bgColor = Color["row_background_unselectable"] })
					row[1]:createCheckBox(function () return entry.checkedcounts == #entry.types end, { width = Helper.standardTextHeight, height = Helper.standardTextHeight })
					row[1].handlers.onClick = function (_, checked) return menu.toggleAllNotificationSettings(entry, checked) end
					row[2]:setColSpan(4):createText(entry.name, Helper.subHeaderTextProperties)
					row[2].properties.font = Helper.standardFontBold
					hasrows = true

					for _, type in ipairs(entry.types) do
						local row = table_center:addRow(true, {  })
						row[1]:createCheckBox(function () return type.enabled end, { width = Helper.standardTextHeight, height = Helper.standardTextHeight })
						row[1].handlers.onClick = function (_, checked) return menu.checkboxNotification(entry, type.id, checked) end
						row[2]:setColSpan(4):createText(type.name, textproperties)
						row[2].properties.mouseOverText = type.desc
					end
				end
			end

			local row = table_center:addRow("notification_settings_reset", {  })
			row[4]:setColSpan(2):createButton({  }):setText(ReadText(1001, 7787), { halign = "center" })
			row[4].handlers.onClick = menu.buttonResetNotificationSettings
		elseif locmode == "onlineitems" then
			local row = table_center:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
			row[1]:setColSpan(5):createText(ReadText(1001, 9122), Helper.titleTextProperties)	-- Venture Ships

			row = table_center:addRow(nil, { fixed = true, bgColor = Color["row_background_unselectable"] })
			row[1]:setColSpan(4):createText(ReadText(1001, 2809), { font = Helper.standardFontBold })	-- Name
			row[5]:createText(ReadText(1001, 9051), { font = Helper.standardFontBold })	-- Ship Type

			for i, ship in ipairs(menu.empireData.ships) do
				local name, shiptype, isonlineobject = GetComponentData(ship.ship, "name", "shiptypename", "isonlineobject")
				if isonlineobject then
					row = table_center:addRow({ "empire_onlineship", ship.ship }, { interative = false })
					row[1]:setColSpan(4):createText(name)
					row[5]:createText(shiptype)
				end
			end
		elseif locmode == "traderule" then
			table_center:setColWidthPercent(1, 25)
			table_center:setColWidthPercent(2, 25)
			table_center:setColWidth(4, table_center.properties.width / 4 - Helper.standardTextHeight, false)
			table_center:setColWidth(5, Helper.standardTextHeight)

			if next(mode[3]) then
				menu.traderule = Helper.tableCopy(mode[3])
			else
				menu.traderule = {
					name = ReadText(1001, 11013) .. " #" .. (#menu.traderules + 1),
					iswhitelist = false,
					factions = {},
					defaults = { trade = false, supply = false, build = false },
				}
			end
			menu.editedTradeRule = mode[4] or Helper.tableCopy(menu.traderule)
			-- title
			local row = table_center:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
			row[1]:setColSpan(5):createText(ReadText(1001, 11010), Helper.titleTextProperties)
			-- name
			row = table_center:addRow(nil, { fixed = true })
			row[1]:createText(ReadText(1001, 2809) .. ReadText(1001, 120))
			row[2]:setColSpan(4):createEditBox({ description = ReadText(1001, 2809) }):setText(menu.editedTradeRule.name)
			row[2].handlers.onTextChanged = menu.editboxTradeRuleNameChanged

			if menu.traderule.id then
				-- confirm, cancel
				row = table_center:addRow(true, { fixed = true })
				row[2]:createButton({ active = menu.buttonTradeRuleCheckChanges, mouseOverText = ReadText(1026, 9116) }):setText(ReadText(1001, 9146), { halign = "center" })
				row[2].handlers.onClick = menu.buttonTradeRuleConfirm
				row[4]:setColSpan(2):createButton({ active = menu.buttonTradeRuleCheckChanges, mouseOverText = ReadText(1026, 9117) }):setText(ReadText(1001, 9147), { halign = "center" })
				row[4].handlers.onClick = menu.buttonTradeRuleReset
				-- delete
				row = table_center:addRow(true, { fixed = true })
				row[2]:createButton({ mouseOverText = ReadText(1026, 9115) }):setText(ReadText(1001, 11014), { halign = "center" })
				row[2].handlers.onClick = menu.buttonTradeRuleRemove
			else
				-- save
				row = table_center:addRow(true, { fixed = true })
				row[4]:setColSpan(2):createButton({  }):setText(ReadText(1001, 11015), { halign = "center" })
				row[4].handlers.onClick = menu.buttonTradeRuleConfirm

				row = table_center:addRow(false, { fixed = true })
				row[2]:createText("")
			end

			-- defaults
			row = table_center:addRow(false, {  })
			row[2]:createText("")
			-- trade
			row = table_center:addRow(true, {  })
			row[1]:createText(ReadText(1001, 11016) .. ReadText(1001, 120))
			row[2]:setColSpan(3):createText(ReadText(1001, 11017))
			row[5]:createCheckBox(menu.editedTradeRule.defaults.trade, {  })
			row[5].handlers.onClick = function (_, checked) return menu.checkboxTradeRuleDefault("trade", checked) end
			-- supply
			row = table_center:addRow(true, {  })
			row[2]:setColSpan(3):createText(ReadText(1001, 11018))
			row[5]:createCheckBox(menu.editedTradeRule.defaults.supply, {  })
			row[5].handlers.onClick = function (_, checked) return menu.checkboxTradeRuleDefault("supply", checked) end
			-- build
			row = table_center:addRow(true, {  })
			row[2]:setColSpan(3):createText(ReadText(1001, 11019))
			row[5]:createCheckBox(menu.editedTradeRule.defaults.build, {  })
			row[5].handlers.onClick = function (_, checked) return menu.checkboxTradeRuleDefault("build", checked) end

			-- data
			row = table_center:addRow(false, {  })
			row[2]:createText("")
			-- use whitelist
			row = table_center:addRow(true, {  })
			row[2]:setColSpan(3):createText(ReadText(1001, 11020))
			row[5]:createCheckBox(menu.editedTradeRule.iswhitelist, {  })
			row[5].handlers.onClick = menu.checkboxTradeRuleUseWhitelist
			row = table_center:addRow(false, {  })
			row[2]:createText("")
			-- factions
			row = table_center:addRow(false, { bgColor = Color["row_background_unselectable"] })
			row[1].properties.cellBGColor = Color["row_background"]
			row[2]:setColSpan(4):createText((menu.editedTradeRule.iswhitelist and ReadText(1001, 11022) or ReadText(1001, 11021)) .. ReadText(1001, 120))
			for _, faction in ipairs(menu.editedTradeRule.factions) do
				row = table_center:addRow(true, {  })
				row[2]:setColSpan(3):createText("    " .. GetFactionData(faction, "name"), { color = (faction == "player") and Color["text_player"] or nil })
				row[5]:createButton({  }):setText("x", { halign = "center" })
				row[5].handlers.onClick = function () return menu.buttonTradeRuleRemoveFaction(faction) end
			end
			row = table_center:addRow(true, {  })
			row[2]:setColSpan(4):createButton({  }):setText(ReadText(1001, 9156), { halign = "center" })
			row[2].handlers.onClick = function () return menu.buttonTradeRuleAddFaction(table_center.properties.x + table_center.properties.width + Helper.borderSize, table_center.properties.y) end

		elseif locmode == "blacklist" then
			table_center:setColWidthPercent(1, 25)
			table_center:setColWidthPercent(2, 25)
			table_center:setColWidth(4, table_center.properties.width / 4 - Helper.standardTextHeight, false)
			table_center:setColWidth(5, Helper.standardTextHeight)

			if next(mode[3]) then
				menu.blacklist = Helper.tableCopy(mode[3])
			else
				menu.blacklist = {
					name = ReadText(1001, 9159) .. " #" .. (#menu.blacklists + 1),
					spaces = {},
					factions = {},
					defaults = { civilian = false, military = false },
				}
			end
			menu.editedBlacklist = mode[4] or Helper.tableCopy(menu.blacklist)
			-- title
			local row = table_center:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
			row[1]:setColSpan(5):createText(ReadText(1001, 9143), Helper.titleTextProperties)
			-- name
			row = table_center:addRow(nil, { fixed = true })
			row[1]:createText(ReadText(1001, 2809) .. ReadText(1001, 120))
			row[2]:setColSpan(4):createEditBox({ description = ReadText(1001, 2809) }):setText(menu.editedBlacklist.name)
			row[2].handlers.onTextChanged = menu.editboxBlacklistNameChanged

			if menu.blacklist.id then
				-- confirm, cancel
				row = table_center:addRow(true, { fixed = true })
				row[2]:createButton({ active = menu.buttonBlacklistCheckChanges, mouseOverText = ReadText(1026, 9107) }):setText(ReadText(1001, 9146), { halign = "center" })
				row[2].handlers.onClick = menu.buttonBlacklistConfirm
				row[4]:setColSpan(2):createButton({ active = menu.buttonBlacklistCheckChanges, mouseOverText = ReadText(1026, 9108) }):setText(ReadText(1001, 9147), { halign = "center" })
				row[4].handlers.onClick = menu.buttonBlacklistReset
				-- delete
				row = table_center:addRow(true, { fixed = true })
				row[2]:createButton({ mouseOverText = ReadText(1026, 9106) }):setText(ReadText(1001, 9148), { halign = "center" })
				row[2].handlers.onClick = menu.buttonBlacklistRemove
				-- type
				row = table_center:addRow(false, {  })
				row[1]:createText(ReadText(1001, 9161) .. ReadText(1001, 120))
				local text, mouseovertext = "", ""
				for _, option in ipairs(config.blacklistTypes) do
					if option.id == menu.editedBlacklist.type then
						text = option.text
						mouseovertext = option.mouseovertext .. "\n\n" .. ReadText(1026, 9104)
						break
					end
				end
				row[2]:setColSpan(4):createText(text, { mouseOverText = mouseovertext })
			else
				-- save
				row = table_center:addRow(true, { fixed = true })
				row[4]:setColSpan(2):createButton({ active = menu.editedBlacklist.type ~= nil, mouseOverText = (menu.editedBlacklist.type == nil) and ReadText(1026, 9109) or ReadText(1026, 9105) }):setText(ReadText(1001, 9160), { halign = "center" })
				row[4].handlers.onClick = menu.buttonBlacklistConfirm

				row = table_center:addRow(false, { fixed = true })
				row[2]:createText("")
				-- type
				row = table_center:addRow(true, {  })
				row[1]:createText(ReadText(1001, 9161) .. ReadText(1001, 120))
				row[2]:setColSpan(4):createDropDown(config.blacklistTypes, { height = Helper.standardTextHeight, startOption = menu.editedBlacklist.type })
				row[2].handlers.onDropDownConfirmed = menu.dropdownBlacklistType
			end

			if menu.editedBlacklist.type ~= nil then
				row = table_center:addRow(false, {  })
				row[2]:createText("")
				-- military
				row = table_center:addRow(true, {  })
				row[1]:createText(ReadText(1001, 9149) .. ReadText(1001, 120))
				row[2]:setColSpan(3):createText(ReadText(1001, 9150))
				row[5]:createCheckBox(menu.editedBlacklist.defaults.military, {  })
				row[5].handlers.onClick = function (_, checked) return menu.checkboxBlacklistDefault("military", checked) end
				-- civilian
				row = table_center:addRow(true, {  })
				row[2]:setColSpan(3):createText(ReadText(1001, 9151))
				row[5]:createCheckBox(menu.editedBlacklist.defaults.civilian, {  })
				row[5].handlers.onClick = function (_, checked) return menu.checkboxBlacklistDefault("civilian", checked) end
			end

			row = table_center:addRow(false, {  })
			row[2]:createText("")

			if menu.editedBlacklist.type == "sectortravel" then
				-- hazardous
				row = table_center:addRow(true, {  })
				row[1]:createText(ReadText(1001, 9168) .. ReadText(1001, 120))
				row[2]:setColSpan(3):createText(ReadText(1001, 9152))
				row[5]:createCheckBox(menu.editedBlacklist.hazardous, {  })
				row[5].handlers.onClick = menu.checkboxBlacklistHazard
			end
			if (menu.editedBlacklist.type == "sectortravel") or (menu.editedBlacklist.type == "sectoractivity") then
				-- relation
				row = table_center:addRow(true, {  })
				row[2]:setColSpan(3):createText(ReadText(1001, 9153))
				row[5]:createCheckBox(menu.editedBlacklist.relation == "enemy", {  })
				row[5].handlers.onClick = menu.checkboxBlacklistRelation
			end
			if menu.editedBlacklist.type ~= nil then
				table_center:addEmptyRow()
				-- factions
				row = table_center:addRow(true, {  })
				row[2]:setColSpan(3):createText(ReadText(1001, 11020))
				row[5]:createCheckBox(menu.editedBlacklist.usefactionwhitelist, {  })
				row[5].handlers.onClick = menu.checkboxBlacklistUseFactionWhitelist
				row = table_center:addRow(false, { bgColor = Color["row_background_unselectable"] })
				row[1].properties.cellBGColor = Color["row_background"]
				row[2]:setColSpan(4):createText(((menu.editedBlacklist.type == "objectactivity") and (menu.editedBlacklist.usefactionwhitelist and ReadText(1001, 11041) or ReadText(1001, 9179)) or (menu.editedBlacklist.usefactionwhitelist and ReadText(1001, 11040) or ReadText(1001, 9154))) .. ReadText(1001, 120))
				for _, faction in ipairs(menu.editedBlacklist.factions) do
					row = table_center:addRow(true, {  })
					row[2]:setColSpan(3):createText("    " .. GetFactionData(faction, "name"), { color = (faction == "player") and Color["text_player"] or nil })
					row[5]:createButton({  }):setText("x", { halign = "center" })
					row[5].handlers.onClick = function () return menu.buttonBlacklistRemoveFaction(faction) end
				end
				row = table_center:addRow(true, {  })
				row[2]:setColSpan(4):createButton({  }):setText(ReadText(1001, 9156), { halign = "center" })
				row[2].handlers.onClick = function () return menu.buttonBlacklistAddFaction(table_center.properties.x + table_center.properties.width + Helper.borderSize, table_center.properties.y) end
			end
			if (menu.editedBlacklist.type == "sectortravel") or (menu.editedBlacklist.type == "sectoractivity") then
				table_center:addEmptyRow()
				-- macros
				row = table_center:addRow(true, {  })
				row[2]:setColSpan(3):createText(ReadText(1001, 11043))
				row[5]:createCheckBox(menu.editedBlacklist.usemacrowhitelist, {  })
				row[5].handlers.onClick = menu.checkboxBlacklistUseMacroWhitelist
				row = table_center:addRow(false, { bgColor = Color["row_background_unselectable"] })
				row[1].properties.cellBGColor = Color["row_background"]
				row[2]:setColSpan(4):createText((menu.editedBlacklist.usemacrowhitelist and ReadText(1001, 11042) or ReadText(1001, 9155)) .. ReadText(1001, 120))
				for _, spaceid in ipairs(menu.editedBlacklist.spaces) do
					row = table_center:addRow(true, {  })
					row[2]:setColSpan(3):createText("    " .. ffi.string(C.GetComponentName(spaceid)))
					row[5]:createButton({  }):setText("x", { halign = "center" })
					row[5].handlers.onClick = function () return menu.buttonBlacklistRemoveMacro(spaceid) end
				end
				row = table_center:addRow(true, {  })
				row[2]:setColSpan(4):createButton({  }):setText(ReadText(1001, 9157), { halign = "center" })
				row[2].handlers.onClick = function () return menu.buttonBlacklistAddMacro(table_center.properties.x + table_center.properties.width + Helper.borderSize, table_center.properties.y) end
			end

		elseif locmode == "fightrule" then
			table_center:setColWidthPercent(1, 25)
			table_center:setColWidthPercent(3, 10)
			table_center:setColWidth(4, table_center.properties.width / 4 - Helper.standardTextHeight, false)
			table_center:setColWidth(5, Helper.standardTextHeight)

			if next(mode[3]) then
				menu.fightrule = Helper.tableCopy(mode[3], 3)
			else
				menu.fightrule = {
					name = ReadText(1001, 7756) .. " #" .. (#menu.fightrules + 1),
					settings = {},
					defaults = { attack = false },
				}
			end
			menu.editedFightRule = mode[4] or Helper.tableCopy(menu.fightrule, 3)
			-- title
			local row = table_center:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
			row[1]:setColSpan(5):createText(ReadText(1001, 7753), Helper.titleTextProperties)
			-- name
			row = table_center:addRow(nil, { fixed = true })
			row[1]:createText(ReadText(1001, 2809) .. ReadText(1001, 120))
			row[2]:setColSpan(4):createEditBox({ description = ReadText(1001, 2809) }):setText(menu.editedFightRule.name)
			row[2].handlers.onTextChanged = menu.editboxFightRuleNameChanged

			if menu.fightrule.id then
				-- confirm, cancel
				row = table_center:addRow(true, { fixed = true })
				row[2]:createButton({ active = menu.buttonFightRuleCheckChanges, mouseOverText = ReadText(1026, 7703) }):setText(ReadText(1001, 9146), { halign = "center" })
				row[2].handlers.onClick = menu.buttonFightRuleConfirm
				row[4]:setColSpan(2):createButton({ active = menu.buttonFightRuleCheckChanges, mouseOverText = ReadText(1026, 7704) }):setText(ReadText(1001, 9147), { halign = "center" })
				row[4].handlers.onClick = menu.buttonFightRuleReset
				-- delete
				row = table_center:addRow(true, { fixed = true })
				row[2]:createButton({ mouseOverText = ReadText(1026, 7705) }):setText(ReadText(1001, 7757), { halign = "center" })
				row[2].handlers.onClick = menu.buttonFightRuleRemove
			else
				-- save
				row = table_center:addRow(true, { fixed = true })
				row[4]:setColSpan(2):createButton({  }):setText(ReadText(1001, 7758), { halign = "center" })
				row[4].handlers.onClick = menu.buttonFightRuleConfirm

				row = table_center:addRow(false, { fixed = true })
				row[2]:createText("")
			end

			row = table_center:addRow(false, {  })
			row[2]:createText("")
			-- default
			row = table_center:addRow(true, {  })
			row[1]:setColSpan(4):createText(ReadText(1001, 7766) .. ReadText(1001, 120))
			row[5]:createCheckBox(menu.editedFightRule.defaults.attack, {  })
			row[5].handlers.onClick = function (_, checked) return menu.checkboxFightRuleDefault("attack", checked) end

			row = table_center:addRow(false, {  })
			row[2]:createText("")

			row = table_center:addRow(false, { bgColor = Color["row_background_unselectable"] })
			row[1]:setBackgroundColSpan(5):createText(ReadText(1001, 44), { font = Helper.standardFontBold })
			row[2]:createText(ReadText(1001, 2809), { font = Helper.standardFontBold })
			row[3]:createText(ReadText(1001, 7749), { font = Helper.standardFontBold, halign = "center" })
			row[4]:setColSpan(2):createText(ReadText(1001, 7767), { font = Helper.standardFontBold, halign = "center" })

			local factions = {}
			local relations = GetLibrary("factions")
			for i, relation in ipairs(relations) do
				if relation.id ~= "player" then
					table.insert(factions, relation.id)
				end
			end
			table.sort(factions, Helper.sortFactionName)

			local overrideoptions = {
				{ id ="engage/default",		text = ReadText(1001, 7759), icon = "", displayremoveoption = false, mouseovertext = ReadText(1026, 7706) },
				{ id ="default/engage",		text = ReadText(1001, 7760), icon = "", displayremoveoption = false, mouseovertext = string.format(ReadText(1026, 7707), C.GetRelationRangeUIMaxValue("kill")) },
				{ id ="hold/engage",		text = ReadText(1001, 7761), icon = "", displayremoveoption = false, mouseovertext = ReadText(1026, 7708) },
				{ id ="default/default",	text = ReadText(1001, 7762), icon = "", displayremoveoption = false, mouseovertext = string.format(ReadText(1026, 7709), C.GetRelationRangeUIMaxValue("killmilitary"), C.GetRelationRangeUIMaxValue("kill")) },
				{ id ="hold/default",		text = ReadText(1001, 7763), icon = "", displayremoveoption = false, mouseovertext = string.format(ReadText(1026, 7710), C.GetRelationRangeUIMaxValue("killmilitary")) },
				{ id ="default/hold",		text = ReadText(1001, 7764), icon = "", displayremoveoption = false, mouseovertext = string.format(ReadText(1026, 7711), C.GetRelationRangeUIMaxValue("kill")) },
				{ id ="hold/hold",			text = ReadText(1001, 7765), icon = "", displayremoveoption = false, mouseovertext = ReadText(1026, 7712) },
			}

			for i, faction in ipairs(factions) do
				local name, shortname = GetFactionData(faction, "name", "shortname")
				local startoption = "default/default"
				if menu.editedFightRule.settings[faction] then
					startoption = menu.editedFightRule.settings[faction].civilian .. "/" .. menu.editedFightRule.settings[faction].military
				end

				local row = table_center:addRow(true, {  })
				row[2]:setColSpan(1):createText("[" .. shortname .. "] " .. name)
				row[3]:createText(function () return string.format("%+d", GetUIRelation(faction)) end, { halign = "right", font = Helper.standardFontMono, color = function () return menu.relationColor(faction) end })
				row[4]:setColSpan(2):createDropDown(overrideoptions, { height = Helper.standardTextHeight, startOption = startoption }):setTextProperties({ halign = "center" })
				row[4].handlers.onDropDownConfirmed = function (_, id) return menu.dropdownFightRuleFactionSetting(faction, id) end
			end

		elseif locmode == "playeralert" then
			table_center:setColWidthPercent(1, 25)
			table_center:setColWidthPercent(2, 25)
			table_center:setColWidth(4, table_center.properties.width / 4 - Helper.standardTextHeight, false)
			table_center:setColWidth(5, Helper.standardTextHeight)

			if next(mode[3]) then
				menu.playeralert = Helper.tableCopy(mode[3])
			else
				menu.playeralert = {
					name = ReadText(1001, 9186) .. " #" .. (#menu.playeralerts + 1),
					interval = 300,
					objectclasses = { "object" },
					objectpurpose = "",
					objectidcode = "",
					objectowners = {},
					spaces = {},
					message = "",
					soundid = "",
				}
			end
			menu.editedPlayerAlert = mode[4] or Helper.tableCopy(menu.playeralert)
			-- title
			local row = table_center:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
			row[1]:setColSpan(5):createText(ReadText(1001, 9183), Helper.titleTextProperties)
			-- name
			row = table_center:addRow(true, { fixed = true })
			row[1]:createText(ReadText(1001, 2809) .. ReadText(1001, 120))
			row[2]:setColSpan(4):createEditBox({ description = ReadText(1001, 2809) }):setText(menu.editedPlayerAlert.name)
			row[2].handlers.onTextChanged = menu.editboxPlayerAlertNameChanged

			if menu.playeralert.index then
				-- confirm, cancel
				row = table_center:addRow(true, { fixed = true })
				row[2]:createButton({ active = menu.buttonPlayerAlertCheckChanges, mouseOverText = ReadText(1026, 9111) }):setText(ReadText(1001, 9146), { halign = "center" })
				row[2].handlers.onClick = menu.buttonPlayerAlertConfirm
				row[4]:setColSpan(2):createButton({ active = menu.buttonPlayerAlertCheckChanges, mouseOverText = ReadText(1026, 9112) }):setText(ReadText(1001, 9147), { halign = "center" })
				row[4].handlers.onClick = menu.buttonPlayerAlertReset
				-- delete
				row = table_center:addRow(true, { fixed = true })
				row[2]:createButton({ mouseOverText = ReadText(1026, 9110) }):setText(ReadText(1001, 9187), { halign = "center" })
				row[2].handlers.onClick = menu.buttonPlayerAlertRemove
			else
				-- save
				row = table_center:addRow(true, { fixed = true })
				row[4]:setColSpan(2):createButton({  }):setText(ReadText(1001, 9188), { halign = "center" })
				row[4].handlers.onClick = menu.buttonPlayerAlertConfirm

				row = table_center:addRow(false, { fixed = true })
				row[2]:createText("")
			end

			row = table_center:addRow(false, {  })
			row[2]:createText("")

			-- notification text
			row = table_center:addRow(true, { fixed = true })
			row[1]:createText(ReadText(1001, 11009) .. ReadText(1001, 120))
			row[2]:setColSpan(4):createEditBox({ description = ReadText(1001, 11009) }):setText(menu.editedPlayerAlert.message)
			row[2].handlers.onTextChanged = menu.editboxPlayerAlertMessageChanged
			-- sound
			local n = C.GetNumPlayerAlertSounds2("general subtle hostile")
			local buf = ffi.new("SoundInfo[?]", n)
			n = C.GetPlayerAlertSounds2(buf, n, "general subtle hostile")
			local options = {}
			for i = 0, n - 1 do
				table.insert(options, { id = ffi.string(buf[i].id), text = ffi.string(buf[i].name), icon = "", displayremoveoption = false })
			end
			table.sort(options, function (a, b) return a.text < b.text end)

			if (menu.editedPlayerAlert.soundid == "") and options[1] then
				menu.editedPlayerAlert.soundid = options[1].id
			end
			row = table_center:addRow(true, {  })
			row[1]:createText(ReadText(1001, 9192) .. ReadText(1001, 120))
			row[2]:setColSpan(3):createDropDown(options, { height = Helper.standardTextHeight, startOption = menu.editedPlayerAlert.soundid })
			row[2].handlers.onDropDownConfirmed = menu.dropdownPlayerAlertSound
			row[5]:createButton({ height = Helper.standardTextHeight }):setIcon("menu_sound_on")
			row[5].handlers.onClick = menu.buttonPlayerAlertSoundTest

			row = table_center:addRow(false, {  })
			row[2]:createText("")

			-- interval
			row = table_center:addRow(true, {  })
			row[1]:createText(ReadText(1001, 9193) .. ReadText(1001, 120), { mouseOverText = ReadText(1026, 9113) })
			row[2]:setColSpan(4):createSliderCell({ min = 1, max = 60, start = menu.editedPlayerAlert.interval / 60, suffix = ReadText(1001, 103), hideMaxValue = true, exceedMaxValue = true, height = Helper.standardTextHeight })
			row[2].handlers.onSliderCellChanged = menu.slidercellPlayerAlertInterval
			-- repeats
			row = table_center:addRow(true, {  })
			row[1]:createText(ReadText(1001, 9194) .. ReadText(1001, 120), { mouseOverText = ReadText(1026, 9114) })
			row[2]:setColSpan(4):createCheckBox(menu.editedPlayerAlert.repeats, { width = Helper.standardTextHeight, height = Helper.standardTextHeight })
			row[2].handlers.onClick = menu.checkboxPlayerAlertRepeat

			row = table_center:addRow(false, {  })
			row[2]:createText("")

			-- spaces
			if #menu.editedPlayerAlert.spaces > 0 then
				for i, spaceid in ipairs(menu.editedPlayerAlert.spaces) do
					row = table_center:addRow(true, {  })
						if i == 1 then
							row[1]:createText(ReadText(1001, 9190).. ReadText(1001, 120))
						end
					row[2]:setColSpan(3):createText("    " .. ffi.string(C.GetComponentName(spaceid)))
					row[5]:createButton({  }):setText("x", { halign = "center" })
					row[5].handlers.onClick = function () return menu.buttonPlayerAlertRemoveSpace(spaceid) end
				end
				row = table_center:addRow(true, {  })
			else
				row = table_center:addRow(true, {  })
				row[1]:createText(ReadText(1001, 9190).. ReadText(1001, 120))
				row[2]:createText("    " .. ReadText(1001, 9191))
			end
			row = table_center:addRow(true, {  })
			row[2]:setColSpan(4):createButton({  }):setText(ReadText(1001, 9157), { halign = "center" })
			row[2].handlers.onClick = function () return menu.buttonPlayerAlertAddSpace(table_center.properties.x + table_center.properties.width + Helper.borderSize, table_center.properties.y) end

			-- owner
			if #menu.editedPlayerAlert.objectowners > 0 then
				for i, faction in ipairs(menu.editedPlayerAlert.objectowners) do
					row = table_center:addRow(true, {  })
					if i == 1 then
						row[1]:createText(ReadText(1001, 9195).. ReadText(1001, 120))
					end
					row[2]:setColSpan(3):createText("    " .. GetFactionData(faction, "name"))
					row[5]:createButton({  }):setText("x", { halign = "center" })
					row[5].handlers.onClick = function () return menu.buttonPlayerAlertRemoveFaction(faction) end
				end
				row = table_center:addRow(true, {  })
			else
				row = table_center:addRow(true, {  })
				row[1]:createText(ReadText(1001, 9195).. ReadText(1001, 120))
			end
			row[2]:setColSpan(4):createButton({  }):setText(ReadText(1001, 9156), { halign = "center" })
			row[2].handlers.onClick = function () return menu.buttonPlayerAlertAddFaction(table_center.properties.x + table_center.properties.width + Helper.borderSize, table_center.properties.y) end
			-- class
			if #menu.editedPlayerAlert.objectclasses > 0 then
				for i, class in ipairs(menu.editedPlayerAlert.objectclasses) do
					row = table_center:addRow(true, {  })
					if i == 1 then
						row[1]:createText(ReadText(1001, 9197).. ReadText(1001, 120))
					end
					row[2]:setColSpan(3):createText("    " .. config.classDefinitions[class])
					row[5]:createButton({  }):setText("x", { halign = "center" })
					row[5].handlers.onClick = function () return menu.buttonPlayerAlertRemoveClass(class) end
				end
				row = table_center:addRow(true, {  })
			else
				row = table_center:addRow(true, {  })
				row[1]:createText(ReadText(1001, 9197).. ReadText(1001, 120))
			end
			row[2]:setColSpan(4):createButton({  }):setText(ReadText(1001, 11008), { halign = "center" })
			row[2].handlers.onClick = function () return menu.buttonPlayerAlertAddClass(table_center.properties.x + table_center.properties.width + Helper.borderSize, table_center.properties.y) end
			-- purpose
			local purposes = { "trade", "fight", "build", "mine", "auxiliary" }
			local options = {
				{ id = "default", text = ReadText(1001, 11004), icon = "", displayremoveoption = false }
			}
			for _, purpose in ipairs(purposes) do
				table.insert(options, { id = purpose, text = ffi.string(C.GetPurposeName(purpose)), icon = "", displayremoveoption = false })
			end
			row = table_center:addRow(true, {  })
			row[1]:createText(ReadText(1001, 9199) .. ReadText(1001, 120))
			row[2]:setColSpan(4):createDropDown(options, { height = Helper.standardTextHeight, startOption = (menu.editedPlayerAlert.objectpurpose ~= "") and menu.editedPlayerAlert.objectpurpose or "default" })
			row[2].handlers.onDropDownConfirmed = menu.dropdownPlayerAlertPurpose
			-- idcode
			row = table_center:addRow(true, {  })
			row[1]:createText(ReadText(1001, 11005) .. ReadText(1001, 120))
			row[2]:setColSpan(4):createEditBox({ description = ReadText(1001, 11005) }):setText(menu.editedPlayerAlert.objectidcode)
			row[2].handlers.onTextChanged = menu.editboxPlayerAlertIDCodeChanged
		elseif locmode == "sectorownership" then
			-- title
			local row = table_center:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
			row[1]:setColSpan(5):createText(ReadText(1001, 9601), Helper.titleTextProperties)
			-- owned sectors
			local row = table_center:addRow(true, { interactive = false })
			row[1]:setBackgroundColSpan(5):createText(ReadText(1001, 9181))

			local skiprow = true
			local clusters = GetClusters(true)
			for _, cluster in ipairs(clusters) do
				local sectors = GetSectors(cluster)
				for _, sector in ipairs(sectors) do
					if GetComponentData(sector, "isplayerowned") then
						if not skiprow then
							row = table_center:addRow(true, { interactive = false })
							row[1]:setBackgroundColSpan(5)
						end
						skiprow = false
						row[2]:setColSpan(4):createText(ffi.string(C.GetComponentName(ConvertIDTo64Bit(sector))), { halign = "right" })
					end
				end
			end

			local row = table_center:addRow(nil, { bgColor = Color["player_info_background"] })
			row[1]:setColSpan(5):createText(ReadText(1001, 2435), Helper.headerRowCenteredProperties)
			-- illegal wares
			local illegalWares = {}
			local n = C.GetNumWares("economy", false, "", "")
			local buf = ffi.new("const char*[?]", n)
			n = C.GetWares(buf, n, "economy", false, "", "")
			for i = 0, n - 1 do
				local ware = ffi.string(buf[i])
				local name, playerillegal = GetWareData(ware, "name", "playerillegal")
				if playerillegal then
					table.insert(illegalWares, { ware = ware, name = name })
				end
			end
			table.sort(illegalWares, Helper.sortName)

			if #illegalWares > 0 then
				for _, entry in ipairs(illegalWares) do
					local row = table_center:addRow(true, { interactive = false })
					row[1]:createText(entry.name)
				end
			else
				local row = table_center:addRow(true, { interactive = false })
				row[1]:createText("--- " .. ReadText(1001, 32) .. " ---")
			end
			-- button
			local row = table_center:addRow(true, {  })
			row[1]:setColSpan(2):createButton({}):setText(ReadText(1001, 8378), { halign = "center" })
			row[1].handlers.onClick = function () return menu.buttonIllegalWares(table_center.properties.x + table_center.properties.width + Helper.borderSize, table_center.properties.y) end
		end
	elseif mode[1] == "empire_call" then

		local tableProperties = properties_table_center
		tableProperties.height = Helper.viewHeight - tableProperties.y

		if locmode == "stationcash" then
			return menu.createAccounts(menu.infoFrame, tableProperties, tabOrderOffset)
		elseif locmode == "inventory" then
			return menu.createInventory(menu.infoFrame, tableProperties, nil, tabOrderOffset)
		end
	end
end

function menu.logoButtonIcon2(logo)
	if (logo.icon == menu.empireData.currentlogo.icon) and (logo.ispersonal == menu.empireData.currentlogo.ispersonal) then
		return "be_upgrade_installed"
	end
	return "solid"
end

function menu.logoButtonIcon2Color(logo)
	if (logo.icon == menu.empireData.currentlogo.icon) and (logo.ispersonal == menu.empireData.currentlogo.ispersonal) then
		return Color["text_positive"]
	end
	return Color["icon_hidden"]
end

function menu.buttonTradeRuleConfirm()
	local traderule = ffi.new("TradeRuleInfo")
	traderule.name = Helper.ffiNewString(menu.editedTradeRule.name)

	traderule.iswhitelist = menu.editedTradeRule.iswhitelist
	traderule.numfactions = #menu.editedTradeRule.factions
	traderule.factions = Helper.ffiNewHelper("const char*[?]", traderule.numfactions)
	for i, faction in ipairs(menu.editedTradeRule.factions) do
		traderule.factions[i - 1] = Helper.ffiNewString(faction)
	end

	if menu.editedTradeRule.id then
		traderule.id = menu.editedTradeRule.id
		C.UpdateTradeRule(traderule)
	else
		menu.editedTradeRule.id = C.CreateTradeRule(traderule)
	end

	if menu.editedTradeRule.id ~= 0 then
		if menu.editedTradeRule.defaults.trade or menu.traderule.defaults.trade then
			C.SetPlayerTradeRuleDefault(menu.editedTradeRule.id, "buy", menu.editedTradeRule.defaults.trade)
			C.SetPlayerTradeRuleDefault(menu.editedTradeRule.id, "sell", menu.editedTradeRule.defaults.trade)
		end
		if menu.editedTradeRule.defaults.supply or menu.traderule.defaults.supply then
			C.SetPlayerTradeRuleDefault(menu.editedTradeRule.id, "supply", menu.editedTradeRule.defaults.supply)
		end
		if menu.editedTradeRule.defaults.build or menu.traderule.defaults.build then
			C.SetPlayerTradeRuleDefault(menu.editedTradeRule.id, "build", menu.editedTradeRule.defaults.build)
		end
	end

	menu.empireData.mode[3] = menu.editedTradeRule
	menu.empireData.mode[4] = nil
	menu.refreshInfoFrame()
end

function menu.buttonTradeRuleReset()
	menu.empireData.mode[4] = nil
	menu.refreshInfoFrame()
end

function menu.buttonTradeRuleRemove()
	C.RemoveTradeRule(menu.editedTradeRule.id)
	menu.editedTradeRule = {}
	menu.empireData.mode[4] = nil
	menu.refreshInfoFrame()
end

function menu.buttonTradeRuleCheckChanges()
	for k, v in pairs(menu.traderule) do
		if type(v) == "table" then
			if #menu.editedTradeRule[k] ~= #v then
				return true
			end
			for k2, v2 in pairs(v) do
				if menu.editedTradeRule[k][k2] ~= v2 then
					return true
				end
			end
		else
			if menu.editedTradeRule[k] ~= v then
				return true
			end
		end
	end
	return false
end

function menu.buttonTradeRuleAddFaction(x, y)
	menu.contextMenuMode = "traderulefaction"
	menu.createContext(x, y)
end

function menu.buttonBlacklistConfirm()
	local blacklist = ffi.new("BlacklistInfo2")
	blacklist.type = Helper.ffiNewString(menu.editedBlacklist.type)
	blacklist.name = Helper.ffiNewString(menu.editedBlacklist.name)
	blacklist.relation = Helper.ffiNewString(menu.editedBlacklist.relation or "")
	blacklist.hazardous = menu.editedBlacklist.hazardous or false

	blacklist.nummacros = #menu.editedBlacklist.spaces
	blacklist.macros = Helper.ffiNewHelper("const char*[?]", blacklist.nummacros)
	for i, spaceid in ipairs(menu.editedBlacklist.spaces) do
		blacklist.macros[i - 1] = Helper.ffiNewString(GetComponentData(spaceid, "macro"))
	end
	blacklist.usemacrowhitelist = menu.editedBlacklist.usemacrowhitelist or false

	blacklist.numfactions = #menu.editedBlacklist.factions
	blacklist.factions = Helper.ffiNewHelper("const char*[?]", blacklist.numfactions)
	for i, faction in ipairs(menu.editedBlacklist.factions) do
		blacklist.factions[i - 1] = Helper.ffiNewString(faction)
	end
	blacklist.usefactionwhitelist = menu.editedBlacklist.usefactionwhitelist or false

	if menu.editedBlacklist.id then
		blacklist.id = menu.editedBlacklist.id
		C.UpdateBlacklist2(blacklist)
	else
		menu.editedBlacklist.id = C.CreateBlacklist2(blacklist)
	end

	if menu.editedBlacklist.id ~= 0 then
		if menu.editedBlacklist.defaults.civilian or menu.blacklist.defaults.civilian then
			C.SetPlayerBlacklistDefault(menu.editedBlacklist.id, menu.editedBlacklist.type, "civilian", menu.editedBlacklist.defaults.civilian)
		end
		if menu.editedBlacklist.defaults.military or menu.blacklist.defaults.military then
			C.SetPlayerBlacklistDefault(menu.editedBlacklist.id, menu.editedBlacklist.type, "military", menu.editedBlacklist.defaults.military)
		end
	end

	menu.empireData.mode[3] = menu.editedBlacklist
	menu.empireData.mode[4] = nil
	menu.refreshInfoFrame()
end

function menu.buttonBlacklistReset()
	--menu.editedBlacklist = Helper.tableCopy(menu.blacklist)
	menu.empireData.mode[4] = nil
	menu.refreshInfoFrame()
end

function menu.buttonBlacklistRemove()
	C.RemoveBlacklist(menu.editedBlacklist.id)
	menu.editedBlacklist = {}
	menu.empireData.mode[4] = nil
	menu.refreshInfoFrame()
end

function menu.buttonBlacklistCheckChanges()
	for k, v in pairs(menu.blacklist) do
		if type(v) == "table" then
			if #menu.editedBlacklist[k] ~= #v then
				return true
			end
			for k2, v2 in pairs(v) do
				if menu.editedBlacklist[k][k2] ~= v2 then
					return true
				end
			end
		else
			if menu.editedBlacklist[k] ~= v then
				return true
			end
		end
	end
	return false
end

function menu.buttonBlacklistAddFaction(x, y)
	menu.contextMenuMode = "blacklistfaction"
	menu.createContext(x, y)
end

function menu.buttonBlacklistAddMacro(x, y)
	menu.contextMenuMode = "blacklistsector"
	menu.createContext(x, y)
end

function menu.buttonIllegalWares(x, y)
	menu.contextMenuMode = "illegalwares"
	menu.createContext(x, y)
end

function menu.buttonSelectContextSetList(data)
	if menu.contextMenuMode == "blacklistfaction" then
		menu.editedBlacklist.factions = {}
		local hasplayer = false
		for faction in pairs(data) do
			if faction == "player" then
				hasplayer = true
			else
				table.insert(menu.editedBlacklist.factions, faction)
			end
		end
		table.sort(menu.editedBlacklist.factions, Helper.sortFactionName)
		if hasplayer then
			table.insert(menu.editedBlacklist.factions, 1, "player")
		end
		menu.empireData.mode[4] = menu.editedBlacklist
	elseif menu.contextMenuMode == "blacklistsector" then
		menu.editedBlacklist.spaces = {}
		for spaceid in pairs(data) do
			table.insert(menu.editedBlacklist.spaces, spaceid)
		end
		table.sort(menu.editedBlacklist.spaces, Helper.sortUniverseIDName)
		menu.empireData.mode[4] = menu.editedBlacklist
	elseif menu.contextMenuMode == "illegalwares" then
		for _, entry in ipairs(menu.contextMenuData.data) do
			C.SetPlayerIllegalWare(entry, data[entry] or false)
		end
	elseif menu.contextMenuMode == "playeralertclass" then
		menu.editedPlayerAlert.objectclasses = {}
		for class in pairs(data) do
			table.insert(menu.editedPlayerAlert.objectclasses, class)
		end
		table.sort(menu.editedPlayerAlert.objectclasses, menu.sortClasses)
		menu.empireData.mode[4] = menu.editedPlayerAlert
	elseif menu.contextMenuMode == "playeralertfaction" then
		menu.editedPlayerAlert.objectowners = {}
		for faction in pairs(data) do
			table.insert(menu.editedPlayerAlert.objectowners, faction)
		end
		table.sort(menu.editedPlayerAlert.objectowners, Helper.sortFactionName)
		menu.empireData.mode[4] = menu.editedPlayerAlert
	elseif menu.contextMenuMode == "playeralertsector" then
		menu.editedPlayerAlert.spaces = {}
		for spaceid in pairs(data) do
			table.insert(menu.editedPlayerAlert.spaces, spaceid)
		end
		table.sort(menu.editedPlayerAlert.spaces, Helper.sortUniverseIDName)
		menu.empireData.mode[4] = menu.editedPlayerAlert
	elseif menu.contextMenuMode == "traderulefaction" then
		menu.editedTradeRule.factions = {}
		local hasplayer = false
		for faction in pairs(data) do
			if faction == "player" then
				hasplayer = true
			else
				table.insert(menu.editedTradeRule.factions, faction)
			end
		end
		table.sort(menu.editedTradeRule.factions, Helper.sortFactionName)
		if hasplayer then
			table.insert(menu.editedTradeRule.factions, 1, "player")
		end
		menu.empireData.mode[4] = menu.editedTradeRule
	end

	menu.closeContextMenu()
	menu.refreshInfoFrame()
end

function menu.sortClasses(a, b)
	local aname = config.classDefinitions[a] or ""
	local bname = config.classDefinitions[b] or ""

	return aname > bname
end

function menu.editboxTradeRuleNameChanged(_, text)
	menu.noupdate = nil
	menu.editedTradeRule.name = text
end

function menu.checkboxTradeRuleDefault(group, checked)
	menu.editedTradeRule.defaults[group] = checked
end

function menu.checkboxTradeRuleUseWhitelist(_, checked)
	menu.editedTradeRule.iswhitelist = checked
	if checked then
		menu.editedTradeRule.factions = { "player" }
	else
		menu.editedTradeRule.factions = {}
	end

	menu.empireData.mode[4] = menu.editedTradeRule
	menu.refreshInfoFrame()
end

function menu.buttonTradeRuleRemoveFaction(faction)
	for i, entry in ipairs(menu.editedTradeRule.factions) do
		if entry == faction then
			table.remove(menu.editedTradeRule.factions, i)
			break
		end
	end

	menu.empireData.mode[4] = menu.editedTradeRule
	menu.refreshInfoFrame()
end

function menu.buttonBlacklistRemoveFaction(faction)
	for i, entry in ipairs(menu.editedBlacklist.factions) do
		if entry == faction then
			table.remove(menu.editedBlacklist.factions, i)
			break
		end
	end

	menu.empireData.mode[4] = menu.editedBlacklist
	menu.refreshInfoFrame()
end

function menu.buttonBlacklistRemoveMacro(spaceid)
	for i, entry in ipairs(menu.editedBlacklist.spaces) do
		if entry == spaceid then
			table.remove(menu.editedBlacklist.spaces, i)
			break
		end
	end

	menu.empireData.mode[4] = menu.editedBlacklist
	menu.refreshInfoFrame()
end

function menu.checkboxBlacklistDefault(group, checked)
	menu.editedBlacklist.defaults[group] = checked
end

function menu.checkboxSelectContextSetList(entry, checked)
	menu.contextMenuData.selectedData[entry] = checked or nil
end

function menu.checkboxSelectContextToggleList(checked)
	for _, entry in ipairs(menu.contextMenuData.data) do
		menu.contextMenuData.selectedData[entry] = checked or nil
	end
end

function menu.checkboxBlacklistHazard(_, checked)
	menu.editedBlacklist.hazardous = checked
end

function menu.checkboxBlacklistRelation(_, checked)
	menu.editedBlacklist.relation = checked and "enemy" or ""
end

function menu.checkboxBlacklistUseFactionWhitelist(_, checked)
	menu.editedBlacklist.usefactionwhitelist = checked
	if checked then
		menu.editedBlacklist.factions = { "player" }
	else
		menu.editedBlacklist.factions = {}
	end

	menu.empireData.mode[4] = menu.editedBlacklist
	menu.refreshInfoFrame()
end

function menu.checkboxBlacklistUseMacroWhitelist(_, checked)
	menu.editedBlacklist.usemacrowhitelist = checked
	menu.editedBlacklist.spaces = {}

	menu.empireData.mode[4] = menu.editedBlacklist
	menu.refreshInfoFrame()
end

function menu.dropdownBlacklistType(_, newtype)
	menu.editedBlacklist.type = newtype
	menu.empireData.mode[4] = menu.editedBlacklist
	menu.refreshInfoFrame()
end

function menu.editboxBlacklistNameChanged(_, text)
	menu.noupdate = nil
	menu.editedBlacklist.name = text
end

function menu.buttonFightRuleConfirm()
	local fightrule = ffi.new("FightRuleInfo")
	fightrule.name = Helper.ffiNewString(menu.editedFightRule.name)

	fightrule.numfactions = 0
	for faction, entry in pairs(menu.editedFightRule.settings) do
		fightrule.numfactions = fightrule.numfactions + 1
	end
	fightrule.factions = Helper.ffiNewHelper("UIFightRuleSetting[?]", fightrule.numfactions)
	local i = 0
	for faction, entry in pairs(menu.editedFightRule.settings) do
		fightrule.factions[i].factionid = Helper.ffiNewString(faction)
		if entry.civilian == "default" then
			fightrule.factions[i].civiliansetting = Helper.ffiNewString("")
		else
			fightrule.factions[i].civiliansetting = Helper.ffiNewString(entry.civilian)
		end
		if entry.military == "default" then
			fightrule.factions[i].militarysetting = Helper.ffiNewString("")
		else
			fightrule.factions[i].militarysetting = Helper.ffiNewString(entry.military)
		end
		i = i + 1
	end

	if menu.editedFightRule.id then
		fightrule.id = menu.editedFightRule.id
		C.UpdateFightRule(fightrule)
	else
		menu.editedFightRule.id = C.CreateFightRule(fightrule)
	end

	if menu.editedFightRule.id ~= 0 then
		if menu.editedFightRule.defaults.attack then
			C.SetPlayerFightRuleDefault(menu.editedFightRule.id, "attack", menu.editedFightRule.defaults.attack)
		end
	end

	menu.empireData.mode[3] = menu.editedFightRule
	menu.empireData.mode[4] = nil
	menu.refreshInfoFrame()
end

function menu.buttonFightRuleReset()
	menu.empireData.mode[4] = nil
	menu.refreshInfoFrame()
end

function menu.buttonFightRuleRemove()
	C.RemoveFightRule(menu.editedFightRule.id)
	menu.editedFightRule = {}
	menu.empireData.mode[4] = nil
	menu.refreshInfoFrame()
end

function menu.buttonFightRuleCheckChanges()
	for k, v in pairs(menu.fightrule) do
		if type(v) == "table" then
			if Helper.tableLength(menu.editedFightRule[k]) ~= Helper.tableLength(v) then
				return true
			end
			for k2, v2 in pairs(v) do
				if type(v2) == "table" then
					if Helper.tableLength(menu.editedFightRule[k][k2]) ~= Helper.tableLength(v2) then
						return true
					end
					for k3, v3 in pairs(v2) do
						if menu.editedFightRule[k][k2][k3] ~= v3 then
							return true
						end
					end
				else
					if menu.editedFightRule[k][k2] ~= v2 then
						return true
					end
				end
			end
		else
			if menu.editedFightRule[k] ~= v then
				return true
			end
		end
	end
	return false
end

function menu.editboxFightRuleNameChanged(_, text)
	menu.noupdate = nil
	menu.editedFightRule.name = text
end

function menu.checkboxFightRuleDefault(group, checked)
	menu.editedFightRule.defaults[group] = checked
end

function menu.dropdownFightRuleFactionSetting(faction, id)
	if id then
		local civilian, military = string.match(id, "(.+)/(.+)")
		if menu.editedFightRule.settings[faction] then
			if (civilian == "default") and (military == "default") then
				menu.editedFightRule.settings[faction] = nil
			else
				menu.editedFightRule.settings[faction].civilian = civilian
				menu.editedFightRule.settings[faction].military = military
			end
		elseif (civilian ~= "default") or (military ~= "default") then
			menu.editedFightRule.settings[faction] = { civilian = civilian, military = military }
		end
	end
end

function menu.buttonPlayerAlertConfirm()
	local playeralert = ffi.new("PlayerAlertInfo2")
	playeralert.interval = menu.editedPlayerAlert.interval
	playeralert.repeats = menu.editedPlayerAlert.repeats or false
	playeralert.muted = menu.editedPlayerAlert.muted or false

	playeralert.numspaces = #menu.editedPlayerAlert.spaces
	playeralert.spaceids = Helper.ffiNewHelper("UniverseID[?]", playeralert.numspaces)
	for i, space in ipairs(menu.editedPlayerAlert.spaces) do
		playeralert.spaceids[i - 1] = space
	end

	local objectclass = ""
	for i, class in ipairs(menu.editedPlayerAlert.objectclasses) do
		objectclass = objectclass .. ((i > 1) and " " or "") .. class
	end
	playeralert.objectclass = Helper.ffiNewString(objectclass)

	local objectowner = ""
	for i, faction in ipairs(menu.editedPlayerAlert.objectowners) do
		objectowner = objectowner .. ((i > 1) and " " or "") .. faction
	end
	playeralert.objectowner = Helper.ffiNewString(objectowner)

	playeralert.objectpurpose = Helper.ffiNewString(menu.editedPlayerAlert.objectpurpose or "")
	playeralert.objectidcode = Helper.ffiNewString(menu.editedPlayerAlert.objectidcode or "")
	playeralert.name = Helper.ffiNewString(menu.editedPlayerAlert.name or "")
	playeralert.message = Helper.ffiNewString(menu.editedPlayerAlert.message or "")
	playeralert.soundid = Helper.ffiNewString(menu.editedPlayerAlert.soundid or "")

	if menu.editedPlayerAlert.index then
		playeralert.index = menu.editedPlayerAlert.index
		C.UpdatePlayerAlert2(playeralert)
	else
		C.AddPlayerAlert2(playeralert)
		menu.editedPlayerAlert.index = #menu.playeralerts + 1
	end

	menu.empireData.mode[3] = menu.editedPlayerAlert
	menu.empireData.mode[4] = nil
	menu.refreshInfoFrame()
end

function menu.buttonPlayerAlertReset()
	menu.empireData.mode[4] = nil
	menu.refreshInfoFrame()
end

function menu.buttonPlayerAlertRemove()
	C.RemovePlayerAlert(menu.editedPlayerAlert.index)
	menu.editedPlayerAlert = {}
	menu.empireData.mode[4] = nil
	menu.refreshInfoFrame()
end

function menu.buttonPlayerAlertCheckChanges()
	for k, v in pairs(menu.playeralert) do
		if type(v) == "table" then
			if #menu.editedPlayerAlert[k] ~= #v then
				return true
			end
			for k2, v2 in pairs(v) do
				if menu.editedPlayerAlert[k][k2] ~= v2 then
					return true
				end
			end
		elseif menu.editedPlayerAlert[k] ~= v then
			return true
		end
	end
	return false
end

function menu.buttonPlayerAlertSoundTest()
	if menu.editedPlayerAlert.soundid ~= "" then
		PlaySound(menu.editedPlayerAlert.soundid)
	end
end

function menu.buttonPlayerAlertRemoveClass(class)
	for i, entry in ipairs(menu.editedPlayerAlert.objectclasses) do
		if entry == class then
			table.remove(menu.editedPlayerAlert.objectclasses, i)
			break
		end
	end

	menu.empireData.mode[4] = menu.editedPlayerAlert
	menu.refreshInfoFrame()
end

function menu.buttonPlayerAlertRemoveFaction(faction)
	for i, entry in ipairs(menu.editedPlayerAlert.objectowners) do
		if entry == faction then
			table.remove(menu.editedPlayerAlert.objectowners, i)
			break
		end
	end

	menu.empireData.mode[4] = menu.editedPlayerAlert
	menu.refreshInfoFrame()
end

function menu.buttonPlayerAlertRemoveSpace(spaceid)
	for i, entry in ipairs(menu.editedPlayerAlert.spaces) do
		if entry == spaceid then
			table.remove(menu.editedPlayerAlert.spaces, i)
			break
		end
	end

	menu.empireData.mode[4] = menu.editedPlayerAlert
	menu.refreshInfoFrame()
end

function menu.buttonPlayerAlertAddClass(x, y)
	menu.contextMenuMode = "playeralertclass"
	menu.createContext(x, y)
end

function menu.buttonPlayerAlertAddFaction(x, y)
	menu.contextMenuMode = "playeralertfaction"
	menu.createContext(x, y)
end

function menu.buttonPlayerAlertAddSpace(x, y)
	menu.contextMenuMode = "playeralertsector"
	menu.createContext(x, y)
end

function menu.buttonResetGlobalStandingOrders()
	for _, signalentry in ipairs(menu.signals) do
		C.SetDefaultResponseToSignalForFaction2(signalentry.defaultresponse, signalentry.ask, signalentry.id, "player", "")
		C.SetDefaultResponseToSignalForFaction2(signalentry.defaultresponse, signalentry.ask, signalentry.id, "player", "fight")
		C.SetDefaultResponseToSignalForFaction2(signalentry.defaultresponse, signalentry.ask, signalentry.id, "player", "auxiliary")
		menu.dropdownOrdersSetResponse("reset", "player", signalentry.id, "factionresponses")
	end

	C.SetFactionBuildMethod("player", C.GetDefaultPlayerBuildMethod())
	C.SetPlayerGlobalLoadoutLevel(0)
	C.SetPlayerTradeLoopCargoReservationSetting(true)
	C.SetFactionDefaultWeaponMode("player", "defend")
	C.SetPlayerShipsWaitForPlayer(true)
	C.SetPlayerTaxiWaitsForPlayer(true)

	menu.refreshInfoFrame()
end

function menu.buttonResetNotificationSettings()
	for i, entry in ipairs(menu.typecategories) do
		for _, type in ipairs(entry.types) do
			C.SetNotificationTypeEnabled(type.id, type.enabledByDefault)
		end
	end
	menu.refreshInfoFrame()
end

function menu.dropdownPlayerAlertSpace(_, newspace)
	menu.editedPlayerAlert.spaceid = ConvertStringTo64Bit(newspace)
end

function menu.dropdownPlayerAlertSound(_, newsound)
	menu.editedPlayerAlert.soundid = newsound
end

function menu.dropdownPlayerAlertPurpose(_, newpurpose)
	menu.editedPlayerAlert.objectpurpose = (newpurpose ~= "default") and newpurpose or ""
end

function menu.editboxPlayerAlertNameChanged(_, text)
	menu.noupdate = nil
	menu.editedPlayerAlert.name = text
end

function menu.editboxPlayerAlertMessageChanged(_, text)
	menu.noupdate = nil
	menu.editedPlayerAlert.message = text
end

function menu.editboxPlayerAlertIDCodeChanged(_, text)
	menu.noupdate = nil
	menu.editedPlayerAlert.objectidcode = text
end

function menu.slidercellPlayerAlertInterval(_, value)
	menu.editedPlayerAlert.interval = value * 60
end

function menu.checkboxPlayerAlertRepeat(_, checked)
	menu.editedPlayerAlert.repeats = checked
end

function menu.createContext(x, y)
	Helper.removeAllWidgetScripts(menu, config.contextLayer)
	PlaySound("ui_positive_click")

	menu.contextFrame = Helper.createFrameHandle(menu, {
		layer = config.contextLayer,
		standardButtons = { close = true },
		width = 1.5 * menu.contextMenuWidth,
		x = x,
		y = y,
		autoFrameHeight = true,
	})
	menu.contextFrame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	menu.contextMenuData = { data = {} , selectedData = {}, origSelectedData = {}}
	if menu.contextMenuMode == "blacklistfaction" then
		local relations = GetLibrary("factions")
		for i, relation in ipairs(relations) do
			if relation.id ~= "player" then
				table.insert(menu.contextMenuData.data, relation.id)
			end
		end
		table.sort(menu.contextMenuData.data, Helper.sortFactionName)
		table.insert(menu.contextMenuData.data, 1, "player")

		for _, faction in ipairs(menu.editedBlacklist.factions) do
			menu.contextMenuData.selectedData[faction] = true
			menu.contextMenuData.origSelectedData[faction] = true
		end
	elseif menu.contextMenuMode == "blacklistsector" then
		local clusters = GetClusters(true)
		for _, cluster in ipairs(clusters) do
			local sectors = GetSectors(cluster)
			for _, sector in ipairs(sectors) do
				table.insert(menu.contextMenuData.data, ConvertIDTo64Bit(sector))
			end
		end
		table.sort(menu.contextMenuData.data, Helper.sortUniverseIDName)

		for _, spaceid in ipairs(menu.editedBlacklist.spaces) do
			menu.contextMenuData.selectedData[spaceid] = true
			menu.contextMenuData.origSelectedData[spaceid] = true
		end
	elseif menu.contextMenuMode == "illegalwares" then
		local n = C.GetNumWares("economy", false, "", "")
		local buf = ffi.new("const char*[?]", n)
		n = C.GetWares(buf, n, "economy", false, "", "")
		for i = 0, n - 1 do
			local ware = ffi.string(buf[i])
			table.insert(menu.contextMenuData.data, ware)
			if GetWareData(ware, "playerillegal") then
				menu.contextMenuData.selectedData[ware] = true
				menu.contextMenuData.origSelectedData[ware] = true
			end
		end
		table.sort(menu.contextMenuData.data, Helper.sortWareName)
	elseif menu.contextMenuMode == "playeralertclass" then
		menu.contextMenuData.data = { "object", "station", "ship_s", "ship_m", "ship_l", "ship_xl" }

		for _, class in ipairs(menu.editedPlayerAlert.objectclasses) do
			menu.contextMenuData.selectedData[class] = true
			menu.contextMenuData.origSelectedData[class] = true
		end
	elseif menu.contextMenuMode == "playeralertfaction" then
		local relations = GetLibrary("factions")
		for i, relation in ipairs(relations) do
			if relation.id ~= "player" then
				table.insert(menu.contextMenuData.data, relation.id)
			end
		end
		table.sort(menu.contextMenuData.data, Helper.sortFactionName)

		for _, faction in ipairs(menu.editedPlayerAlert.objectowners) do
			menu.contextMenuData.selectedData[faction] = true
			menu.contextMenuData.origSelectedData[faction] = true
		end
	elseif menu.contextMenuMode == "playeralertsector" then
		local clusters = GetClusters(true)
		for _, cluster in ipairs(clusters) do
			local sectors = GetSectors(cluster)
			for _, sector in ipairs(sectors) do
				table.insert(menu.contextMenuData.data, ConvertIDTo64Bit(sector))
			end
		end
		table.sort(menu.contextMenuData.data, Helper.sortUniverseIDName)

		for _, spaceid in ipairs(menu.editedPlayerAlert.spaces) do
			menu.contextMenuData.selectedData[spaceid] = true
			menu.contextMenuData.origSelectedData[spaceid] = true
		end
	elseif menu.contextMenuMode == "traderulefaction" then
		local relations = GetLibrary("factions")
		for i, relation in ipairs(relations) do
			if relation.id ~= "player" then
				table.insert(menu.contextMenuData.data, relation.id)
			end
		end
		table.sort(menu.contextMenuData.data, Helper.sortFactionName)
		table.insert(menu.contextMenuData.data, 1, "player")

		for _, faction in ipairs(menu.editedTradeRule.factions) do
			menu.contextMenuData.selectedData[faction] = true
			menu.contextMenuData.origSelectedData[faction] = true
		end
	end

	local ftable = menu.contextFrame:addTable(3, { tabOrder = 4 })
	ftable:setColWidth(1, Helper.standardTextHeight)
	ftable:setColWidthPercent(3, 50)

	local row = ftable:addRow(true, { fixed = true })
	row[1]:createCheckBox(function () local count = 0; for _ in pairs(menu.contextMenuData.selectedData) do count = count + 1 end; return #menu.contextMenuData.data == count end, { height = Helper.standardTextHeight })
	row[1].handlers.onClick = function (_, checked) return menu.checkboxSelectContextToggleList(checked) end
	local text = ""
	if menu.contextMenuMode == "blacklistfaction" then
		text = ReadText(1001, 9176)
	elseif menu.contextMenuMode == "blacklistsector" then
		text = ReadText(1001, 9177)
	elseif menu.contextMenuMode == "illegalwares" then
		text = ReadText(1001, 8376)
	elseif menu.contextMenuMode == "playeralertclass" then
		text = ReadText(1001, 11007)
	elseif menu.contextMenuMode == "playeralertfaction" then
		text = ReadText(1001, 9176)
	elseif menu.contextMenuMode == "playeralertsector" then
		text = ReadText(1001, 9177)
	elseif menu.contextMenuMode == "traderulefaction" then
		text = ReadText(1001, 9176)
	end
	row[2]:setColSpan(2):createText(text, Helper.headerRowCenteredProperties)

	if #menu.contextMenuData.data > 0 then
		for _, entry in ipairs(menu.contextMenuData.data) do
			local row = ftable:addRow(true, {  })
			row[1]:createCheckBox(function () return menu.contextMenuData.selectedData[entry] or false end, {  })
			row[1].handlers.onClick = function (_, checked) return menu.checkboxSelectContextSetList(entry, checked) end
			local text, color = ""
			if menu.contextMenuMode == "blacklistfaction" then
				text = GetFactionData(entry, "name")
				if entry == "player" then
					color = Color["text_player"]
				end
			elseif menu.contextMenuMode == "blacklistsector" then
				text = ffi.string(C.GetComponentName(entry))
			elseif menu.contextMenuMode == "illegalwares" then
				text = GetWareData(entry, "name")
			elseif menu.contextMenuMode == "playeralertclass" then
				text = config.classDefinitions[entry]
			elseif menu.contextMenuMode == "playeralertfaction" then
				text = GetFactionData(entry, "name")
			elseif menu.contextMenuMode == "playeralertsector" then
				text = ffi.string(C.GetComponentName(entry))
			elseif menu.contextMenuMode == "traderulefaction" then
				text = GetFactionData(entry, "name")
				if entry == "player" then
					color = Color["text_player"]
				end
			end
			row[2]:setColSpan(2):createText(text, { color = color })
		end

		local buttontable = menu.contextFrame:addTable(2, { tabOrder = 5 })

		local row = buttontable:addRow(true, { fixed = true })
		row[1]:createButton({ active = menu.isDataSelectionChanged }):setText(ReadText(1001, 14), { halign = "center" })
		row[1].handlers.onClick = function () return menu.buttonSelectContextSetList(menu.contextMenuData.selectedData) end
		row[2]:createButton({  }):setText(ReadText(1001, 64), { halign = "center" })
		row[2].handlers.onClick = function () return menu.onCloseElement("back") end

		local dataheight = ftable:getFullHeight()
		local buttonheight = buttontable:getFullHeight()
		if menu.contextFrame.properties.y + ftable.properties.y + dataheight + buttonheight + Helper.frameBorder > Helper.viewHeight then
			buttontable.properties.y = Helper.viewHeight - menu.contextFrame.properties.y - Helper.frameBorder - buttonheight
			ftable.properties.maxVisibleHeight = buttontable.properties.y - Helper.borderSize - ftable.properties.y
	else
			buttontable.properties.y = ftable.properties.y + dataheight + Helper.borderSize
		end

		ftable:addConnection(1, 4, true)
		buttontable:addConnection(2, 4)
	else
		local row = ftable:addRow(false, {  })
		row[1]:setColSpan(3):createText("--- " .. ReadText(1001, 32) .. " ---", { halign = "center" })
	end

	menu.contextFrame:display()
end

function menu.isDataSelectionChanged()
	for ware in pairs(menu.contextMenuData.selectedData) do
		if not menu.contextMenuData.origSelectedData[ware] then
			return true
		end
	end
	for ware in pairs(menu.contextMenuData.origSelectedData) do
		if not menu.contextMenuData.selectedData[ware] then
			return true
		end
	end
	return false
end

function menu.empireCanShowObject(object)
	if menu.empireData.mode and (menu.empireData.mode[2] == "inventory") then
		return false
	elseif not C.IsComponentClass(object, "object") and not C.IsComponentClass(object, "npc") then
		return false
	elseif C.IsComponentClass(object, "ship") and GetComponentData(object, "isdocked") and not C.IsShipAtExternalDock(object) then
		return false
	end

	return true
end

function menu.createContextFrame(data, x, y, width, nomouseout)
	Helper.removeAllWidgetScripts(menu, config.contextLayer)
	PlaySound("ui_positive_click")

	local contextmenuwidth = width or menu.contextMenuWidth

	menu.contextFrame = Helper.createFrameHandle(menu, {
		layer = config.contextLayer,
		standardButtons = { close = true },
		width = contextmenuwidth,
		x = x,
		y = 0,
		autoFrameHeight = true,
	})
	menu.contextFrame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	local ftable = menu.contextFrame:addTable(1, { tabOrder = 4, highlightMode = "off" })

	if menu.contextMenuMode == "inventory" then
		local counter = 0
		local allowencyclopedia = true
		local allowdrop = 0
		local dropmouseovertext = ReadText(1001, 7714)
		for ware in pairs(menu.inventoryData.selectedWares) do
			counter = counter + 1
			if counter > 1 then
				allowencyclopedia = false
			end
			if GetWareData(ware, "allowdrop") and (not menu.onlineitems[ware]) then
				allowdrop = allowdrop + 1
			else
				dropmouseovertext = dropmouseovertext .. "\n" .. GetWareData(ware, "name")
			end
		end

		local title = data[2].name
		if counter > 1 then
			title = string.format(ReadText(1001, 7713), counter)
		end

		local row = ftable:addRow(false, { fixed = true, bgColor = Color["row_background_blue"] })
		row[1]:createText(title, Helper.titleTextProperties)

		row = ftable:addRow(true, { fixed = true })
		row[1]:createButton({ active = allowencyclopedia, bgColor = allowencyclopedia and Color["button_background_hidden"] or Color["button_background_inactive"] }):setText(ReadText(1001, 2400), { color = allowencyclopedia and Color["text_normal"] or Color["text_inactive"] })
		row[1].handlers.onClick = function () return menu.buttonInventoryEncyclopedia(data[1]) end

		row = ftable:addRow(true, { fixed = true })
		row[1]:createButton({ active = allowdrop > 0, bgColor = allowdrop > 0 and Color["button_background_hidden"] or Color["button_background_inactive"], mouseOverText = (allowdrop == counter) and "" or dropmouseovertext }):setText((allowdrop == counter) and ReadText(1001, 7711) or string.format(ReadText(1001, 7712), allowdrop, counter), { color = allowdrop > 0 and Color["text_normal"] or Color["text_inactive"] })
		row[1].handlers.onClick = function () return menu.buttonInventoryDropAll(false) end
	elseif menu.contextMenuMode == "personnel" then
		local row = ftable:addRow(false, { fixed = true, bgColor = Color["row_background_blue"] })
		row[1]:createText(menu.personnelData.curEntry.name, Helper.titleTextProperties)

		local controllable = C.ConvertStringTo64Bit(tostring(menu.personnelData.curEntry.container))
		local entity, person
		if menu.personnelData.curEntry.type == "person" then
			person = C.ConvertStringTo64Bit(tostring(menu.personnelData.curEntry.id))
		else
			entity = menu.personnelData.curEntry.id
		end

		local transferscheduled = false
		local hasarrived = true
		local personrole = ""
		if person then
			-- get real NPC if instantiated
			local instance = C.GetInstantiatedPerson(person, controllable)
			entity = (instance ~= 0 and instance or nil)
			transferscheduled = C.IsPersonTransferScheduled(controllable, person)
			hasarrived = C.HasPersonArrived(controllable, person)
			personrole = ffi.string(C.GetPersonRole(person, controllable))
		end

		local oldpilot, isonlineobject = GetComponentData(menu.personnelData.curEntry.container, "assignedaipilot", "isonlineobject")
		if oldpilot then
			oldpilot = ConvertStringTo64Bit(tostring(oldpilot))
		end

		if isonlineobject then
			local row = ftable:addRow(false, { fixed = true })
			row[1]:createButton({ bgColor = Color["button_background_hidden"], active = false, height = Helper.standardTextHeight }):setText(ReadText(1026, 9118))
		else
			local row = ftable:addRow("info_person_containerinfo", { fixed = true })
			row[1]:createButton({ bgColor = Color["button_background_hidden"], height = Helper.standardTextHeight }):setText(C.IsComponentClass(controllable, "station") and ReadText(1001, 8350) or ReadText(1001, 8602))
			row[1].handlers.onClick = function () return menu.buttonContainerInfo(controllable) end

			if person then
				if transferscheduled then
					local row = ftable:addRow("info_person_cancel_transfer", { fixed = true })
					row[1]:createButton({ bgColor = Color["button_background_hidden"], height = Helper.standardTextHeight }):setText(ReadText(1001, 9435))	-- Cancel all scheduled transfers
					row[1].handlers.onClick = function () return menu.buttonPersonnelCancelTransfer(controllable, person) end
				elseif hasarrived and ((personrole == "service") or (personrole == "marine") or (personrole == "unassigned")) then
					local printedtitle = C.IsComponentClass(controllable, "ship_s") and ReadText(1001, 4847) or ReadText(1001, 4848)	-- Pilot, Captain
					-- promote
					local row = ftable:addRow("info_person_promote", { fixed = true })
					row[1]:createButton({ bgColor = Color["button_background_hidden"], height = Helper.standardTextHeight }):setText(ReadText(1001, 9433) .. " " .. printedtitle)	-- Promote to(followed by "captain" or "pilot")
					row[1].handlers.onClick = function () return menu.buttonPersonnelReplacePilot(controllable, oldpilot, person) end
				end
			end
			if menu.personnelData.curEntry.roleid ~= "shiptrader" then
				if hasarrived then
					-- work somewhere else
					local row = ftable:addRow("info_person_worksomewhere", { fixed = true })
					row[1]:createButton({ bgColor = Color["button_background_hidden"], height = Helper.standardTextHeight }):setText(ReadText(1002, 3008))
					if entity then
						row[1].handlers.onClick = function () Helper.closeMenuAndOpenNewMenu(menu, "MapMenu", { 0, 0, true, controllable, nil, "hire", { "signal", entity, 0 } }); menu.cleanup() end
					else
						row[1].handlers.onClick = function () Helper.closeMenuAndOpenNewMenu(menu, "MapMenu", { 0, 0, true, controllable, nil, "hire", { "signal", controllable, 0, person} }); menu.cleanup() end
					end
				end
				-- fire
				local row = ftable:addRow("info_person_fire", { fixed = true })
				row[1]:createButton({ bgColor = Color["button_background_hidden"], height = Helper.standardTextHeight }):setText(ReadText(1002, 15800))
				row[1].handlers.onClick = function () return menu.buttonPersonnelFireNPCConfirm(controllable, entity, person, menu.personnelData.curEntry.name) end
			end

			local conversationactor = ConvertStringTo64Bit(tostring(entity))
			local player = C.GetPlayerID()
			if person and ((not entity) or (C.GetContextByClass(entity, "container", false) ~= C.GetContextByClass(player, "container", false))) then
				-- Talking to person - either not instantiated as a real entity, or the instance is far away.
				-- Note: Only start comms with instantiated NPCs if they are on the player container, otherwise they are likely to get despawned during the conversation.
				conversationactor = { context = ConvertStringToLuaID(tostring(controllable)), person = ConvertStringToLuaID(tostring(person)) }
			end
			if (not transferscheduled) and hasarrived then
				row = ftable:addRow("info_actor_comm", { fixed = true })
				row[1]:createButton({ bgColor = Color["button_background_hidden"], height = Helper.standardTextHeight, active = (person ~= nil) or (entity and GetComponentData(entity, "caninitiatecomm")) }):setText(ReadText(1001, 3216))	-- (initiate comm)Comm
				row[1].handlers.onClick = function () menu.buttonPersonnelCommWithActor(conversationactor) end
			end
		end
	elseif menu.contextMenuMode == "dropwares" then
		Helper.createDropWaresContext(menu, menu.contextFrame, "left")
	elseif menu.contextMenuMode == "transactionlog" then
		local entryIdx = Helper.transactionLogData.transactionsByIDUnfiltered[data]
		if entryIdx == nil then
			return
		end
		local entry = Helper.transactionLogData.accountLogUnfiltered[entryIdx]
		local active = (entry.partner ~= 0) and C.IsComponentOperational(entry.partner)

		local row = ftable:addRow(false, { fixed = true })
		local text = TruncateText(entry.partnername, Helper.standardFontBold, Helper.scaleFont(Helper.standardFontBold, Helper.headerRow1FontSize), contextmenuwidth - 2 * Helper.scaleX(Helper.standardButtonWidth))
		row[1]:createText(text, Helper.headerRowCenteredProperties)
		row[1].properties.mouseOverText = entry.partnername

		row = ftable:addRow(true, { fixed = true })
		row[1]:createButton({ active = active, bgColor = active and Color["button_background_default"] or Color["button_background_inactive"] }):setText(ReadText(1001, 2427), { color = active and Color["text_normal"] or Color["text_inactive"] })
		row[1].handlers.onClick = function () return menu.buttonContainerInfo(entry.partner) end

		if active and GetComponentData(ConvertStringTo64Bit(tostring(entry.partner)), "isplayerowned") then
			row = ftable:addRow(true, { fixed = true })
			row[1]:createButton({ active = active, bgColor = active and Color["button_background_default"] or Color["button_background_inactive"] }):setText(ReadText(1001, 7702), { color = active and Color["text_normal"] or Color["text_inactive"] })
			row[1].handlers.onClick = function () return menu.buttonTransactionLog(entry.partner) end
		end
	elseif menu.contextMenuMode == "venturecontactcontext" then
		Helper.createVentureContactContext(menu, menu.contextFrame)
	elseif menu.contextMenuMode == "venturefriendlist" then
		Helper.showVentureFriendListContext(menu, menu.contextFrame)
	elseif menu.contextMenuMode == "venturereport" then
		print(nomouseout)
		Helper.createUserQuestionContext(menu, menu.contextFrame)
	end

	if menu.contextFrame.properties.x + contextmenuwidth > Helper.viewWidth then
		menu.contextFrame.properties.x = Helper.viewWidth - contextmenuwidth - Helper.frameBorder
	end
	local height = menu.contextFrame:getUsedHeight()
	if y + height > Helper.viewHeight then
		menu.contextFrame.properties.y = Helper.viewHeight - height - Helper.frameBorder
	else
		menu.contextFrame.properties.y = y
	end

	menu.contextFrame:display()

	if not nomouseout then
		menu.mouseOutBox = {
			x1 =   menu.contextFrame.properties.x -  Helper.viewWidth / 2                    - config.mouseOutRange,
			x2 =   menu.contextFrame.properties.x -  Helper.viewWidth / 2 + contextmenuwidth + config.mouseOutRange,
			y1 = - menu.contextFrame.properties.y + Helper.viewHeight / 2                    + config.mouseOutRange,
			y2 = - menu.contextFrame.properties.y + Helper.viewHeight / 2 - height           - config.mouseOutRange
		}
	else
		menu.mouseOutBox = nil
	end
end

function menu.refreshContextFrame(setrow, setcol)
	Helper.removeAllWidgetScripts(menu, config.contextLayer)

	local y = menu.contextFrame.properties.y
	menu.contextFrame = Helper.createFrameHandle(menu, {
		layer = config.contextLayer,
		standardButtons = { close = true },
		width = menu.contextFrame.properties.width,
		x = menu.contextFrame.properties.x,
		y = 0,
		autoFrameHeight = true,
	})
	menu.contextFrame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	if menu.contextMenuMode == "dropwares" then
		Helper.createDropWaresContext(menu, menu.contextFrame, "left")
	end

	if menu.contextFrame.properties.x + menu.contextMenuWidth > Helper.viewWidth then
		menu.contextFrame.properties.x = Helper.viewWidth - menu.contextMenuWidth - Helper.frameBorder
	end
	local height = menu.contextFrame:getUsedHeight()
	if y + height > Helper.viewHeight then
		menu.contextFrame.properties.y = Helper.viewHeight - height - Helper.frameBorder
	else
		menu.contextFrame.properties.y = y
	end

	menu.contextFrame:display()
end

function menu.buttonPersonnelCommWithActor(actor)
	menu.closeContextMenu()
	if menu.conversationMenu then
		Helper.closeMenuForSubConversation(menu, "default", actor)
	else
		Helper.closeMenuForNewConversation(menu, "default", actor)
	end
	menu.cleanup()
end

function menu.buttonPersonnelReplacePilot(ship, oldpilot, newpilot)
	local oldpilotluaid = oldpilot and ConvertStringToLuaID(tostring(oldpilot))
	local post = (oldpilot and IsValidComponent(oldpilot)) and GetComponentData(oldpilotluaid, "poststring") or "aipilot"

	if not C.CanControllableHaveControlEntity(ship, post) then
		return false
	end

	if oldpilot then
		-- MD handles assignment of new pilot in this case.
		C.SignalObjectWithNPCSeed(oldpilot, "npc__control_dismissed", newpilot, ship)
	else
		newpilot = C.CreateNPCFromPerson(newpilot, ship)
		if C.SetEntityToPost(ship, newpilot, post) then
			SignalObject(ConvertStringTo64Bit(tostring(newpilot)), "npc_state_reinit")
		else
			DebugError("menu.infoSubmenuReplacePilot(): failed setting new pilot.")
		end
	end
	menu.empireData.init = true

	menu.closeContextMenu()
	menu.refresh = getElapsedTime() + 2
	menu.refreshdata = "reinitempire"
end

function menu.buttonPersonnelCancelTransfer(controllable, person)
	C.ReleasePersonFromCrewTransfer(controllable, person)

	menu.closeContextMenu()
	menu.refreshInfoFrame()
end

function menu.buttonPersonnelFireNPCConfirm(controllable, entity, person, name)
	menu.closeContextMenu()

	menu.contextMenuMode = "userquestion"
	menu.contextMenuData = { mode = "fire", controllable = controllable, entity = entity, person = person, name = name, width = Helper.scaleX(400), xoffset = (Helper.viewWidth - Helper.scaleX(400)) / 2, yoffset = Helper.viewHeight / 2 }

	menu.createUserQuestionFrame()
end

function menu.buttonPersonnelFireNPC(controllable, entity, person)
	if entity then
		SignalObject(ConvertStringTo64Bit(tostring(entity)), "npc__control_dismissed")
	else
		C.RemovePerson(controllable, person)
	end
	menu.empireData.init = true

	menu.closeContextMenu()
	menu.refresh = getElapsedTime()
	menu.refreshdata = "reinitempire"
end

function menu.buttonWarDeclarationConfirm(faction)
	menu.closeContextMenu()

	menu.contextMenuMode = "userquestion"
	menu.contextMenuData = { mode = "wardeclaration", faction = faction, width = Helper.scaleX(400), xoffset = (Helper.viewWidth - Helper.scaleX(400)) / 2, yoffset = Helper.viewHeight / 2 }

	menu.createUserQuestionFrame()
end

function menu.butttonWarDeclaration(faction)
	C.SetFactionRelationToPlayerFaction(faction, "wardeclaration", -0.32)
	menu.closeContextMenu()
	menu.refresh = getElapsedTime()
end

function menu.buttonUserQuestionConfirm()
	if menu.contextMenuData.mode == "fire" then
		menu.buttonPersonnelFireNPC(menu.contextMenuData.controllable, menu.contextMenuData.entity, menu.contextMenuData.person)
	elseif menu.contextMenuData.mode == "wardeclaration" then
		menu.butttonWarDeclaration(menu.contextMenuData.faction)
	elseif menu.contextMenuData.mode == "clearlogbook" then
		menu.buttonLogbookClear(menu.contextMenuData.category)
	end
end

function menu.buttonContainerInfo(controllable)
	Helper.closeMenuAndOpenNewMenu(menu, "MapMenu", { 0, 0, true, nil, nil, "infomode", { "info", controllable } })
	menu.cleanup()
end

function menu.buttonTransactionLog(controllable)
	Helper.closeMenuAndOpenNewMenu(menu, "TransactionLogMenu", { 0, 0, controllable });
	menu.cleanup()
end

function menu.createUserQuestionFrame()
	Helper.removeAllWidgetScripts(menu, config.contextLayer)

	menu.contextFrame = Helper.createFrameHandle(menu, {
		x = menu.contextMenuData.xoffset - 2 * Helper.borderSize,
		y = menu.contextMenuData.yoffset,
		width = menu.contextMenuData.width + 2 * Helper.borderSize,
		layer = config.contextLayer,
		standardButtons = { close = true },
	})
	menu.contextFrame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	local ftable = menu.contextFrame:addTable(5, { tabOrder = 5, reserveScrollBar = false, highlightMode = "off" })

	if menu.contextMenuData.mode == "fire" then
		local row = ftable:addRow(false, { fixed = true })
		row[1]:setColSpan(5):createText(string.format(ReadText(1001, 11202), menu.contextMenuData.name), Helper.headerRowCenteredProperties)

		local row = ftable:addRow(false, { fixed = true })
		row[1]:setColSpan(5):createText(ReadText(1001, 11201), { wordwrap = true })
	elseif menu.contextMenuData.mode == "wardeclaration" then
		local row = ftable:addRow(false, { fixed = true })
		row[1]:setColSpan(5):createText(string.format(ReadText(1001, 7751), menu.contextMenuData.name), Helper.headerRowCenteredProperties)

		local row = ftable:addRow(false, { fixed = true })
		row[1]:setColSpan(5):createText(ReadText(1001, 7752), { wordwrap = true })
	elseif menu.contextMenuData.mode == "clearlogbook" then
		local row = ftable:addRow(false, { fixed = true })
		row[1]:setColSpan(5):createText(string.format(ReadText(1001, 5722), menu.contextMenuData.name), Helper.headerRowCenteredProperties)

		local row = ftable:addRow(false, { fixed = true })
		row[1]:setColSpan(5):createText((menu.contextMenuData.category == "all") and ReadText(1001, 5723) or ReadText(1001, 5724), { wordwrap = true })
	end

	ftable:addEmptyRow(Helper.standardTextHeight)

	local row = ftable:addRow(true, { fixed = true })
	row[2]:createButton():setText(ReadText(1001, 2617), { halign = "center" })
	row[2].handlers.onClick = menu.buttonUserQuestionConfirm
	row[4]:createButton():setText(ReadText(1001, 2618), { halign = "center" })
	row[4].handlers.onClick = menu.closeContextMenu
	ftable:setSelectedCol(4)

	-- only add one border as the table y offset already is part of frame:getUsedHeight()
	menu.contextFrame.properties.height = math.min(Helper.viewHeight - menu.contextFrame.properties.y, menu.contextFrame:getUsedHeight() + Helper.borderSize)
	menu.contextFrame:display()
end

function menu.closeContextMenu()
	Helper.clearTableConnectionColumn(menu, 4)
	Helper.clearFrame(menu, config.contextLayer)
	menu.contextMenuMode = nil
	menu.mouseOutBox = nil
end

function menu.viewCreated(layer, ...)
	if layer == config.mainLayer then
		menu.mainTable = ...
	elseif layer == config.infoLayer then
		if menu.mode == "logbook" then
			menu.topLevelTable, menu.titleTable, menu.infoTable, menu.buttonTable = ...
		else
			menu.topLevelTable, menu.infoTable, menu.buttonTable = ...
		end
	end
end

function menu.onInteractiveElementChanged(element)
	menu.lastactivetable = element
end

-- update
menu.updateInterval = 0.1

function menu.onUpdate()
	if menu.activatecutscene then
		if menu.setupEmpireRenderTarget() then
			menu.activatecutscene = nil
		end
	end
	if menu.messageData.activatecutscene then
		if menu.setupMessageRenderTarget() then
			menu.messageData.activatecutscene = nil
		end
	end
	if menu.inventoryData.activatecutscene then
		if menu.setupInventoryRenderTarget() then
			menu.inventoryData.activatecutscene = nil
		end
	end
	if menu.personnelData.activatecutscene then
		if menu.setupPersonnelRenderTarget() then
			menu.personnelData.activatecutscene = nil
		end
	end

	if Helper.hasExtension("multiverse") then
		if Helper.callExtensionFunction("multiverse", "updateVentures", menu) then
			menu.refreshInfoFrame()
		end
	end

	menu.mainFrame:update()
	menu.infoFrame:update()
	if (menu.contextMenuMode == "blacklistfaction") or
	   (menu.contextMenuMode == "blacklistsector") or
	   (menu.contextMenuMode == "illegalwares") or
	   (menu.contextMenuMode == "playeralertclass") or
	   (menu.contextMenuMode == "playeralertfaction") or
	   (menu.contextMenuMode == "playeralertsector") or
	   (menu.contextMenuMode == "traderulefaction")  or
	   (menu.contextMenuMode == "venturefriendlist") then
		menu.contextFrame:update()
	end

	if menu.mouseOutBox then
		if (GetControllerInfo() ~= "gamepad") or (C.IsMouseEmulationActive()) then
			local curpos = table.pack(GetLocalMousePosition())
			if curpos[1] and ((curpos[1] < menu.mouseOutBox.x1) or (curpos[1] > menu.mouseOutBox.x2)) then
				menu.closeContextMenu()
			elseif curpos[2] and ((curpos[2] > menu.mouseOutBox.y1) or (curpos[2] < menu.mouseOutBox.y2)) then
				menu.closeContextMenu()
			end
		end
	end

	if menu.mode == "transactionlog" then
		Helper.onTransactionLogUpdate()
		if not Helper.transactionLogData.noupdate then
			local curtime = getElapsedTime()
			if curtime > menu.lastTransactionLogRefreshTime + 10 then
				menu.refreshInfoFrame()
			end
		end
	end

	local curtime = getElapsedTime()
	if menu.over then
		menu.over = nil
		menu.refresh = curtime - 1
	end

	if menu.inputModeHasChanged then
		if not menu.noupdate then
			menu.refresh = curtime - 1
			menu.inputModeHasChanged = nil
		end
	end

	if menu.refresh and (menu.refresh < curtime) then
		if menu.refreshdata then
			if menu.refreshdata == "reinitempire" then
				menu.empireData.init = true
				menu.personnelData.curEntry = {}
				menu.refreshInfoFrame()
			else
				menu.refreshInfoFrame(table.unpack(menu.refreshdata))
			end
		else
			menu.refreshInfoFrame()
		end
		menu.refreshdata = nil
		menu.refresh = nil
	end
end

function menu.updateSelectedRows()
	menu.inventoryData.selectedWares = {}
	local rows, highlightedborderrow = GetSelectedRows(menu.inventoryInfoTable.id)
	for _, row in ipairs(rows) do
		local rowdata = menu.rowDataMap[menu.inventoryInfoTable.id][row]
		if type(rowdata) == "table" then
			menu.inventoryData.selectedWares[rowdata[1]] = true
		end
	end
end

function menu.onRowChanged(row, rowdata, uitable, modified, input)
	if uitable == menu.infoTable then
		if (menu.mode == "inventory") or (menu.mode == "spacesuit") then
			menu.onInventoryRowChange(row, rowdata, input, menu.mode)
		elseif menu.mode == "crafting" then
			if type(rowdata) == "table" then
				if menu.inventoryData.mode ~= "craft" then
					local isunbundleammo, component = GetWareData(rowdata[1], "isunbundleammo", "component")
					local ammospace = false
					if isunbundleammo then
						local playership = C.GetPlayerOccupiedShipID()
						if playership ~= 0 then
							ammospace = AddAmmo(ConvertStringToLuaID(tostring(playership)), component, 1, true) == 1
						end
					end

					local row = 1
					if menu.inventoryData.craftingHistory[1] then
						row = row + math.min(3, #menu.inventoryData.craftingHistory) + 2
					end

					if menu.findInventoryWare(menu.craftable, rowdata[1]) then
						local mot_craft = ""
						local active = false
						if rowdata[2].craftable > 0 then
							if (not isunbundleammo) or ammospace then
								mot_craft = ReadText(1026, 3900)
								active = true
							else
								mot_craft = ReadText(1026, 3903)
							end
						else
							mot_craft = ReadText(1026, 3901)
						end

						local desc = Helper.createButton(Helper.createTextInfo(ReadText(1001, 7706), "center", Helper.standardFont, Helper.standardFontSize, 255, 255, 255, 100), nil, false, active, 0, 0, 0, Helper.standardButtonHeight, nil, nil, nil, mot_craft)
						Helper.setCellContent(menu, menu.buttonTable, desc, row, 1, nil, "button", nil, menu.buttonInventoryCraft)
					else
						Helper.setCellContent(menu, menu.buttonTable, Helper.getEmptyCellDescriptor(), row, 1, true, "button")
					end
				end
			end
		elseif menu.mode == "factions" then
			if type(rowdata) == "table" then
				if rowdata[2].id ~= menu.factionData.curEntry.id then
					menu.factionData.curEntry = rowdata[2]
					menu.refresh = getElapsedTime()
				end
			end
		elseif menu.mode == "messages" then
			if type(rowdata) == "table" then
				if rowdata.id ~= menu.messageData.curEntry.id then
					if next(menu.messageData.curEntry) then
						C.SetMessageRead(menu.messageData.curEntry.id, menu.messageData.curEntry.category)
						AddUITriggeredEvent(menu.name, "message_read", ConvertStringTo64Bit(tostring(menu.messageData.curEntry.id)))
					end
					menu.messageData.curEntry = rowdata
					menu.messageData.showFullscreen = nil
					menu.cleanupCutsceneRenderTarget()
					menu.refresh = getElapsedTime()
				end
			end
		elseif menu.mode == "personnel" then
			if type(rowdata) == "table" then
				if tostring(rowdata[2].id) ~= tostring(menu.personnelData.curEntry.id) then
					menu.personnelData.curEntry = rowdata[2]
					menu.refresh = getElapsedTime()
				end
			end
		elseif menu.mode == "transactionlog" then
			Helper.onTransactionLogRowChanged(rowdata)
		elseif (menu.mode == "empire") or (menu.mode == "globalorders") then
			if (type(rowdata) == "table") and ((menu.empireData.mode[2] ~= rowdata[2]) or ((type(rowdata[3]) == "table") and ((menu.empireData.mode[3].id ~= rowdata[3].id) or (menu.empireData.mode[3].index ~= rowdata[3].index)))) then
				--print("onRowChanged. row: " .. tostring(row) .. ". rowdata 1: " .. tostring(rowdata[1]) .. ", rowdata 2: " .. tostring(rowdata[2]) .. ". oldmode 1: " .. tostring(menu.empireData.mode[1]) .. ", oldmode 2: " .. tostring(menu.empireData.mode[2]))
				--menu.empireData.oldmode = menu.empireData.mode
				if ((menu.empireData.mode[1] == "empire_call") and (menu.empireData.mode[2] == "inventory")) then
					menu.inventoryData.selectedWares = {}
					C.ReadAllInventoryWares()
				end
				menu.empireData.mode = rowdata
				menu.setcentertoprow = 0

				-- always clear the selected object when changing modes. selectedobject will be populated right after as appropriate.
				menu.empireData.selectedobject = nil
				menu.empireData.objecttype = nil

				menu.over = true
			end
		end
	elseif ((menu.mode == "empire") or (menu.mode == "globalorders")) and menu.empireData.mode and (type(menu.empireData.mode) == "table") then
		--print("mode 1: " .. tostring(menu.empireData.mode[1]) .. ", mode 2: " .. tostring(menu.empireData.mode[2]))
		if (menu.empireData.mode[1] == "empire_grid") then
			local changed = nil

			if (menu.empireData.mode[2] == "logo") or (menu.empireData.mode[2] == "painttheme") then
				local locship = ConvertStringTo64Bit(tostring(C.GetLastPlayerControlledShipID()))
				if locship and (locship ~= 0) and (locship ~= menu.empireData.selectedobject) and menu.empireCanShowObject(locship) and (not C.IsComponentClass(locship, "spacesuit")) and (not GetComponentData(locship, "paintmodlocked")) then
					--print("changing object from: " .. tostring(menu.empireData.selectedobject) .. " to: " .. tostring(locship))
					menu.empireData.selectedobject = locship
					menu.empireData.objecttype = "object"
					changed = true
				end

				if (not menu.empireData.selectedobject) and (#menu.empireData.ships > 0) then
					for _, ship in ipairs(menu.empireData.ships) do
						if menu.empireCanShowObject(ship.ship) and (not GetComponentData(ship.ship, "paintmodlocked")) then
							menu.empireData.selectedobject = ship.ship
							menu.empireData.objecttype = "object"
							changed = true
							break
						end
					end
				end
				--print("grid. selected object: " .. tostring(menu.empireData.selectedobject))
			elseif (menu.empireData.mode[2] == "uniform") then
				if not menu.empireData.selectedobject or (menu.empireData.objecttype ~= "npc") then
					for _, employeedata in ipairs(menu.empireData.employees) do
						if (employeedata.type == "entity") and menu.empireCanShowObject(employeedata.id) then
							if (menu.empireData.selectedobject ~= employeedata.id) then
								--print("switching selectedobject from: " .. tostring(menu.empireData.selectedobject) .. " to: " .. tostring(employeedata.id))
								menu.empireData.selectedobject = employeedata.id
								menu.empireData.objecttype = "npc"
								changed = true
							end
							break
						end
					end
				end
			end

			if changed then
				menu.over = true
			end
		elseif (menu.empireData.mode[1] == "empire_list") then
			--print("rowdata type: " .. tostring(type(rowdata)) .. ", rowdata: " .. tostring(rowdata))
			if (type(rowdata) == "table") then
				local changed = nil

				if (rowdata[1] == "painttheme") then
					local locship = ConvertStringTo64Bit(tostring(C.GetLastPlayerControlledShipID()))
					if locship and (locship ~= 0) and (locship ~= menu.empireData.selectedobject) and menu.empireCanShowObject(locship) and not C.IsComponentClass(locship, "spacesuit") then
						--print("changing object from: " .. tostring(menu.empireData.selectedobject) .. " to: " .. tostring(locship))
						menu.empireData.selectedobject = locship
						menu.empireData.objecttype = "object"
						changed = true
					end

					if not menu.empireData.selectedobject and #menu.empireData.ships > 0 then
						for _, ship in ipairs(menu.empireData.ships) do
							if menu.empireCanShowObject(ship.ship) then
								menu.empireData.selectedobject = ship.ship
								menu.empireData.objecttype = "object"
								changed = true
								break
							end
						end
					end

					--print("current theme: " .. ffi.string(C.GetPlayerPaintTheme()) .. ", new theme: " .. tostring(rowdata[2]))
					if (ffi.string(C.GetPlayerPaintTheme()) ~= rowdata[2]) then
						C.SetPlayerPaintTheme(rowdata[2])
						--print("new paint theme set: " .. ffi.string(C.GetPlayerPaintTheme()))
					end
				elseif (rowdata[1] == "uniform") then
					if not menu.empireData.selectedobject or (menu.empireData.objecttype ~= "npc") then
						for _, employeedata in ipairs(menu.empireData.employees) do
							if (employeedata.type == "entity") and menu.empireCanShowObject(employeedata.id) then
								if (menu.empireData.selectedobject ~= employeedata.id) then
									--print("switching selectedobject from: " .. tostring(menu.empireData.selectedobject) .. " to: " .. tostring(employeedata.id))
									menu.empireData.selectedobject = employeedata.id
									menu.empireData.objecttype = "npc"
									changed = true
								end
								break
							end
						end
					end

					--print("current uniform: " .. ffi.string(C.GetPlayerClothingTheme()) .. ", new uniform: " .. tostring(rowdata[2]))
					if (ffi.string(C.GetPlayerClothingTheme()) ~= rowdata[2]) then
						C.SetPlayerClothingTheme(rowdata[2])
						--print("new uniform set: " .. ffi.string(C.GetPlayerClothingTheme()))
					end
				elseif (rowdata[1] == "empire_ship") or (rowdata[1] == "empire_station") or (rowdata[1] == "empire_onlineship") then
					if rowdata[2] and menu.empireCanShowObject(rowdata[2]) then
						if (menu.empireData.selectedobject ~= rowdata[2]) then
							menu.empireData.selectedobject = rowdata[2]
							menu.empireData.objecttype = "object"
							changed = true
							--print("selected object: " .. ffi.string(C.GetComponentName(rowdata[2])))
						end
					end
				elseif (rowdata[1] == "empire_employee") then
					if (rowdata[2].type == "entity") then
						if menu.empireCanShowObject(rowdata[2].id) and (menu.empireData.selectedobject ~= rowdata[2].id) then
							--print("switching selectedobject from: " .. tostring(menu.empireData.selectedobject) .. " to: " .. tostring(rowdata[2].id))
							menu.empireData.selectedobject = rowdata[2].id
							menu.empireData.objecttype = "npc"
							changed = true
							--print("selected entity: " .. rowdata[2].name .. " " .. tostring(rowdata[2].id))
						end
					elseif (rowdata[2].type == "person") then
						local instantiatedperson = ConvertStringTo64Bit(tostring(C.GetInstantiatedPerson(rowdata[2].id, C.ConvertStringTo64Bit(tostring(rowdata[2].container)))))
						if (instantiatedperson ~= 0) and menu.empireCanShowObject(instantiatedperson) and (menu.empireData.selectedobject ~= instantiatedperson) then
							menu.empireData.selectedobject = instantiatedperson
							menu.empireData.objecttype = "npc"
							changed = true
							--print("selected person: " .. rowdata[2].name .. " " .. tostring(rowdata[2].id))
						end
					else
						DebugError("Empire Menu: unsupported employee type: " .. tostring(rowdata[2].type))
					end
				end

				if changed then
					menu.setselectedrow2 = row
					menu.over = true
				end
			end
		elseif (menu.empireData.mode[1] == "empire_call") then
			local changed = nil

			if (menu.empireData.mode[2] == "inventory") then
				if (type(rowdata) == "table") and (not menu.empireData.selectedobject or menu.empireData.selectedobject ~= rowdata[1]) then
					--print("ware: " .. tostring(rowdata[1]))
					menu.empireData.selectedobject = rowdata[1]
					menu.empireData.objecttype = "ware"
					changed = true
				end
				menu.onInventoryRowChange(row, rowdata, input, menu.empireData.mode[2])
			end

			if changed then
				menu.setselectedrow2 = row
				menu.over = true
			end
		end
	end

	-- kuertee start: callback
	if callbacks ["onRowChanged"] then
		for _, callback in ipairs (callbacks ["onRowChanged"]) do
			callback (row, rowdata, uitable, modified, input)
		end
	end
	-- kuertee end: callback
end

function menu.onInventoryRowChange(row, rowdata, input, mode)
	if type(rowdata) == "table" then
		menu.closeContextMenu()
		menu.updateSelectedRows()

		if not menu.skipread then
			C.ReadInventoryWare(rowdata[1])
			local name = menu.getInventoryName(rowdata[1], rowdata[2], true)
			Helper.updateCellText(menu.inventoryInfoTable.id, row, 1, name)
			if (input ~= "mouse") and (row > 1) then
				local prevrowdata = menu.rowDataMap[menu.inventoryInfoTable.id][row - 1]
				if type(prevrowdata) == "table" then
					C.ReadInventoryWare(prevrowdata[1])
					local name = menu.getInventoryName(prevrowdata[1], prevrowdata[2], true)
					Helper.updateCellText(menu.inventoryInfoTable.id, row - 1, 1, name)
				end
			end
		end
		menu.skipread = nil

		if menu.inventoryData.mode ~= "drop" then
			local buttonrow = (mode == "inventory") and 6 or 3
			local count = 0
			local allowdrop = false
			for ware in pairs(menu.inventoryData.selectedWares) do
				if GetWareData(ware, "allowdrop") and (not menu.onlineitems[ware]) then
					count = count + 1
					allowdrop = true
				end
			end
			local active = GetWareData(rowdata[1], "allowdrop") and (not menu.onlineitems[rowdata[1]])
			local desc = Helper.createButton(Helper.createTextInfo((count > 1) and ReadText(1001, 7733) or ReadText(1001, 7705), "center", Helper.standardFont, Helper.standardFontSize, 255, 255, 255, 100), nil, false, active, 0, 0, 0, Helper.standardButtonHeight, nil, nil, nil, nil, "playerinfo_inventory_drop")
			Helper.setCellContent(menu, menu.inventoryButtonTable.id, desc, buttonrow, 1, nil, "button", nil, menu.buttonInventoryDrop)

			if rowdata[1] ~= menu.inventoryData.curEntry[1] then
				menu.inventoryData.curEntry = rowdata
				menu.refresh = getElapsedTime()
			end
		end
	end
end

function menu.onSelectElement(uitable, modified, row)
	--print("menu.onSelectElement")
	local rowdata = Helper.getCurrentRowData(menu, uitable)
	if uitable == menu.infoTable then
		if (menu.mode == "inventory") or (menu.mode == "spacesuit") then
			if type(rowdata) == "table" then
				menu.closeContextMenu()
			end
		end
	end
end

function menu.onEditBoxActivated(widget)
	menu.noupdate = true
	if menu.logbookPageEditBox and (widget == menu.logbookPageEditBox.id) then
		C.SetEditBoxText(menu.logbookPageEditBox.id, tostring(menu.logbookData.curPage))
	elseif menu.personnelPageEditBox and (widget == menu.personnelPageEditBox.id) then
		C.SetEditBoxText(menu.personnelPageEditBox.id, tostring(menu.personnelData.curPage))
	elseif menu.mode == "transactionlog" then
		Helper.onTransactionLogEditBoxActivated(widget)
	end
end

function menu.onTableRightMouseClick(uitable, row, posx, posy)
	if (menu.mode == "inventory") or (menu.mode == "spacesuit") then
		if uitable == menu.infoTable then
			local rowdata = menu.rowDataMap[uitable] and menu.rowDataMap[uitable][row]
			if type(rowdata) == "table" then
				menu.inventoryData.selectedWares[rowdata[1]] = true

				local rows = {}
				for row2, rowdata2 in pairs(menu.rowDataMap[uitable]) do
					if type(rowdata2) == "table" then
						if menu.inventoryData.selectedWares[rowdata2[1]] then
							table.insert(rows, row2)
						end
					end
				end
				SetSelectedRows(menu.infoTable, rows, row)

				local x, y = GetLocalMousePosition()
				if x == nil then
					-- gamepad case
					x = posx
					y = -posy
				end
				menu.contextMenuMode = "inventory"
				menu.createContextFrame(rowdata, x + Helper.viewWidth / 2, Helper.viewHeight / 2 - y)
			end
		end
	elseif menu.mode == "personnel" then
		if uitable == menu.infoTable then
			local rowdata = menu.rowDataMap[uitable] and menu.rowDataMap[uitable][row]
			if type(rowdata) == "table" then
				local x, y = GetLocalMousePosition()
				if x == nil then
					-- gamepad case
					x = posx
					y = -posy
				end
				menu.contextMenuMode = "personnel"
				menu.createContextFrame(rowdata, x + Helper.viewWidth / 2, Helper.viewHeight / 2 - y)
			end
		end
	elseif menu.mode == "transactionlog" then
		if uitable == menu.infoTable then
			local rowdata = menu.rowDataMap[uitable] and menu.rowDataMap[uitable][row]

			local entryIdx = Helper.transactionLogData.transactionsByIDUnfiltered[rowdata]
			if entryIdx == nil then
				return
			end
			local entry = Helper.transactionLogData.accountLogUnfiltered[entryIdx]
			if entry.partnername ~= "" then
				local x, y = GetLocalMousePosition()
				if x == nil then
					-- gamepad case
					x = posx
					y = -posy
				end
				menu.contextMenuMode = "transactionlog"
				menu.createContextFrame(rowdata, x + Helper.viewWidth / 2, Helper.viewHeight / 2 - y, Helper.scaleX(260))
			end
		end
	elseif menu.mode == "venturecontacts" then
		if uitable == menu.infoTable then
			local rowdata = menu.rowDataMap[uitable] and menu.rowDataMap[uitable][row]
			if type(rowdata) == "table" then
				if not rowdata.isplayer then
					menu.closeContextMenu()

					local x, y = GetLocalMousePosition()
					if x == nil then
						-- gamepad case
						x = posx
						y = -posy
					end
					menu.contextMenuMode = "venturecontactcontext"
					menu.contextMenuData = { contact = rowdata, xoffset = x + Helper.viewWidth / 2, yoffset = Helper.viewHeight / 2 - y }
					menu.createContextFrame(nil, menu.contextMenuData.xoffset, menu.contextMenuData.yoffset, Helper.scaleX(260))
				end
			end
		end
	end
end

function menu.closeMenu(dueToClose)
	if next(menu.messageData.curEntry) then
		C.SetMessageRead(menu.messageData.curEntry.id, menu.messageData.curEntry.category)
		AddUITriggeredEvent(menu.name, "message_read", ConvertStringTo64Bit(tostring(menu.messageData.curEntry.id)))
		menu.messageData.curEntry = {}
		menu.messageData.showFullscreen = nil
	end
	Helper.closeMenu(menu, dueToClose)
	menu.cleanup()
end

function menu.onCloseElement(dueToClose)
	if menu.contextMenuMode then
		menu.closeContextMenu()
	elseif menu.messageData.showFullscreen and (dueToClose == "back") then
		menu.messageData.showFullscreen = nil
		menu.refreshInfoFrame()
	elseif menu.mode and (dueToClose == "back") then
		menu.deactivatePlayerInfo()
	else
		menu.closeMenu(dueToClose)
	end
end

-- menu helpers

function menu.getInventoryName(ware, waredata, showunread)
	local volatile, gift, unread = GetWareData(ware, "volatile", "gift", "isunreadinventory")

	local name = waredata.name .. (volatile and " [" .. ReadText(1001, 3902) .. "]" or "") .. (gift and " [" .. ReadText(1001, 3903) .. "]" or "")
	local color = Color["text_normal"]
	if menu.inventoryData.policefaction and IsWareIllegalTo(ware, "player", menu.inventoryData.policefaction) then
		color = Color["text_illegal"]
	end
	if showunread and unread then
		name = ColorText["text_warning"] .. "\027[workshop_error]\027X " .. name
	end

	return name, color
end

function menu.addInventoryWareEntry(ftable, ware, waredata, iscrafting, isresource, hideprice, isonline)
	local bgColor
	if iscrafting and (not isresource) then
		bgColor = Color["row_title_background"]
	end
	local row = ftable:addRow({ware, waredata}, { bgColor = bgColor, multiSelected = menu.inventoryData.selectedWares[ware] })

	-- name
	local rawname, color = menu.getInventoryName(ware, waredata, not iscrafting)
	local name = rawname
	if isresource then
		name = "    " .. name
	end
	row[1]:setColSpan(hideprice and 4 or 1)
	row[1]:createText(name, { color = color })
	if not hideprice then
		-- amount
		if isresource then
			row[2]:createText(waredata.amount .. " / " .. waredata.needed, config.rightAlignTextProperties)
		else
			row[2]:createText(waredata.amount, config.rightAlignTextProperties)
		end
		-- base price
		local avgprice = GetWareData(ware, "avgprice")
		row[3]:createText(ConvertMoneyString(avgprice, false, true, 0, true) .. " " .. ReadText(1001, 101), config.rightAlignTextProperties)
		-- total price
		row[4]:createText(ConvertMoneyString(avgprice * waredata.amount, false, true, 0, true) .. " " .. ReadText(1001, 101), config.rightAlignTextProperties)
	end

	local ispaintmod = GetWareData(ware, "ispaintmod")
	if ispaintmod then
		AddKnownItem("paintmods", ware)
	else
		AddKnownItem("inventory_wares", ware)
	end
end

function menu.findInventoryWare(array, ware)
	for _, entry in ipairs(array) do
		if entry.ware == ware then
			return true
		end
	end
	return false
end

function menu.createCraftableEntry(ware)
	if not menu.findInventoryWare(menu.craftable, ware) then
		local waredata
		if menu.inventory[ware] then
			waredata = menu.inventory[ware]
		else
			local name, buyprice = GetWareData(ware, "name", "buyprice")
			waredata = { name = name, amount = 0, price = buyprice }
		end

		local resources = {}
		local rawresources = GetWareData(ware, "resources")
		local resourcecount = 0
		local craftableamount
		if #rawresources > 0 then
			for _, resource in ipairs(rawresources) do
				local resourcedata = menu.inventory[resource.ware]
				if resourcedata then
					resourcecount = resourcecount + resourcedata.amount
					local maxcraftable = math.floor(resourcedata.amount / resource.amount)
					craftableamount = craftableamount and math.min(maxcraftable, craftableamount) or maxcraftable
					table.insert(resources, { ware = resource.ware, data = { name = resourcedata.name, amount = resourcedata.amount, price = resourcedata.price, needed = resource.amount } })
				else
					local resourcename, resourcebuyprice = GetWareData(resource.ware, "name", "buyprice")
					craftableamount = 0
					table.insert(resources, { ware = resource.ware, data = { name = resourcename, amount = 0, price = resourcebuyprice, needed = resource.amount } })
				end
			end
		else
			craftableamount = 0
		end
		resources.count = resourcecount

		local isunbundleammo, component = GetWareData(ware, "isunbundleammo", "component")
		if isunbundleammo then
			local playership = C.GetPlayerOccupiedShipID()
			if playership ~= 0 then
				craftableamount = AddAmmo(ConvertStringToLuaID(tostring(playership)), component, craftableamount, true)
			end
		end
		waredata.craftable = craftableamount

		table.insert(menu.craftable, { ware = ware, data = waredata, resources = resources })
	end
end

-- kuertee start:
function menu.registerCallback (callbackName, callbackFunction)
	-- note 1: format is generally [function name]_[action]. e.g.: in kuertee_menu_transporter, "display_on_set_room_active" overrides the room's active property with the return of the callback.
	-- note 2: events have the word "_on_" followed by a PRESENT TENSE verb. e.g.: in kuertee_menu_transporter, "display_on_set_buttontable" is called after all of the rows of buttontable are set.
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
		Helper.loadModLuas(menu.name, "menu_playerinfo_uix")
	end
end
-- kuertee end

init()
