
-- param == { 0, 0, mode }

-- ffi setup
local ffi = require("ffi")
local C = ffi.C
ffi.cdef[[
	typedef uint64_t OperationID;

	typedef struct {
		const char* id;
		const char* category;
		const char* paramtype;
		const char* name;
		const char* desc;
		const char* shortdesc;
		const char* iconid;
		const char* imageid;
		const char* rewardtext;
		const char* successtext;
		const char* failuretext;
		const char* agenttype;
		const char* agentexpname;
		const char* agentrisk;
		const char* giftwaretags;
		double duration;
		double cooldown;
		int32_t agentexp;
		int32_t successchance;
		int64_t price;
		int32_t influencerequirement;
		uint32_t exclusivefactionparamidx;
		uint32_t warecostscaleparamidx;
		uint32_t numwarerequirements;
		bool unique;
		bool hidden;
		bool eventtrigger;
	} DiplomacyActionInfo;
	typedef struct {
		OperationID id;
		const char* actionid;
		UniverseID agentid;
		const char* agentname;
		const char* agentimageid;
		const char* agentresultstate;
		int32_t agentexp_negotiation;
		int32_t agentexp_espionage;
		const char* giftwareid;
		double starttime;
		double endtime;
		bool read;
		bool successful;
	} DiplomacyActionOperation;
	typedef struct {
		const char* rankname;
		const char* rankiconid;
		const char* exp_negotiation_name;
		const char* exp_espionage_name;
	} DiplomacyAgentAttributeData;
	typedef struct {
		const char* id;
		const char* name;
		const char* desc;
		const char* shortdesc;
		const char* iconid;
		const char* imageid;
		double duration;
		uint32_t numoptions;
	} DiplomacyEventInfo;
	typedef struct {
		OperationID id;
		OperationID sourceactionoperationid;
		const char* eventid;
		UniverseID agentid;
		const char* agentname;
		const char* agentimageid;
		const char* agentresultstate;
		int32_t agentexp_negotiation;
		int32_t agentexp_espionage;
		const char* faction;
		const char* otherfaction;
		const char* option;
		const char* outcome;
		double starttime;
		bool read;
		int32_t startrelation;
	} DiplomacyEventOperation;
	typedef struct {
		const char* id;
		const char* name;
		const char* desc;
		const char* result;
		const char* conclusion;
		const char* agentrisk;
		int32_t successchance;
		float relationchange;
		int64_t price;
		int32_t influencerequirement;
		int32_t menuposition;
		uint32_t numwarerequirements;
	} DiplomacyEventOptionInfo;
	typedef struct {
		bool excluded;
		uint32_t numexclusionreasons;
	} FactionDiplomacyExclusionInfo;
	typedef struct {
		const char* text;
		const char* textcondition;
		int32_t relationcondition;
		bool positive;
	} RelationImplication;
	typedef struct {
		const char* name;
		const char* colorid;
	} RelationRangeInfo;
	typedef struct {
		const char* file;
		const char* icon;
		bool ispersonal;
	} UILogo;
	typedef struct {
		const char* wareid;
		uint32_t amount;
	} UIWareAmount;
	void AbortActiveDiplomacyActionOperation(UniverseID entityid);
	bool CanStartDiplomacyAction(const char* actionid, const char* targetfactionid);
	uint32_t GenerateFactionRelationImplications(RelationImplication* result, uint32_t resultlen, const char* factionid);
	UniverseID GetAgentDiplomacyShip(UniverseID npcid);
	uint32_t GetAgentMaxSlotCount();
	const char* GetAgentSlotResearchWare(size_t slotnumber);
	double GetCurrentGameTime(void);
	UILogo GetCurrentPlayerLogo(void);
	uint32_t GetDiplomacyActionOperations(DiplomacyActionOperation* result, uint32_t resultlen, bool active);
	uint32_t GetDiplomacyEventOperations(DiplomacyEventOperation* result, uint32_t resultlen, bool active);
	double GetDiplomacyActionCooldownEndTime(const char* actionid, const char* targetfactionid, bool checkalltargetfactions);
	int64_t GetDiplomacyActionMoneyCost(const char* actionid, const char* wareid);
	uint32_t GetDiplomacyActions(DiplomacyActionInfo* result, uint32_t resultlen);
	uint32_t GetDiplomacyActionWares(UIWareAmount* result, uint32_t resultlen, const char* actionid);
	DiplomacyAgentAttributeData GetDiplomacyAgentAttributeData(int32_t exp_negotiation, int32_t exp_espionage);
	uint32_t GetDiplomacyAgents(UniverseID* result, uint32_t resultlen);
	int32_t GetDiplomacyEventOptionChance(OperationID eventoperationid, const char* optionid, const char* selectedoptionid);
	uint32_t GetDiplomacyEventOptions(DiplomacyEventOptionInfo* result, uint32_t resultlen, const char* eventid);
	uint32_t GetDiplomacyEventOptionWares(UIWareAmount* result, uint32_t resultlen, const char* eventid, const char* optionid);
	uint32_t GetDiplomacyEvents(DiplomacyEventInfo* result, uint32_t resultlen);
	uint32_t GetDiplomacyExcludedReasons(const char** result, uint32_t resultlen, const char* factionid, const char* otherfactionid);
	uint32_t GetDockedShips(UniverseID* result, uint32_t resultlen, UniverseID dockingbayorcontainerid, const char* factionid);
	const char* GetInfluenceLevelName(int32_t influencelevel);
	uint32_t GetNumDiplomacyActionOperations(bool active);
	uint32_t GetNumDiplomacyActions();
	uint32_t GetNumDiplomacyAgents();
	uint32_t GetNumDiplomacyEventOperations(bool active);
	uint32_t GetNumDiplomacyEvents();
	uint32_t GetNumDockedShips(UniverseID dockingbayorcontainerid, const char* factionid);
	uint32_t GetNumFactionRelationImplications(const char* factionid);
	uint32_t GetNumWares2(const char* tags, bool research, const char* licenceownerid, const char* exclusiontags, bool matchalltags, bool matchallexclusiontags);
	int32_t GetPlayerInfluence();
	UniverseID GetPlayerRepresentative(const char* factionid);
	RelationRangeInfo GetRelationRangeInfo(int32_t uirelation);
	float GetTextHeight(const char*const text, const char*const fontname, const float fontsize, const float wordwrapwidth);
	RelationRangeInfo GetUIRelationName(const char* fromfactionid, const char* tofactionid);
	uint32_t GetWares2(const char** result, uint32_t resultlen, const char* tags, bool research, const char* licenceownerid, const char* exclusiontags, bool matchalltags, bool matchallexclusiontags);
	bool HasResearched(const char* wareid);
	bool IsContestedSector(UniverseID sectorid);
	FactionDiplomacyExclusionInfo IsDiplomacyExcluded(const char* factionid, const char* otherfactionid);
	bool IsFactionHostileToFaction(const char* factionid, const char* otherfactionid);
	bool IsFactionInRelationRangeToFaction(const char* factionid, const char* otherfactionid, const char* range);
	bool IsKnownToPlayer(UniverseID componentid);
	bool IsMouseEmulationActive(void);
	void SetAgentDiplomacyShip(UniverseID npcid, UniverseID shipid);
	void SetArchivedDiplomacyActionOperationRead(OperationID operationid);
	void SetArchivedDiplomacyEventOperationRead(OperationID operationid);
	void SetDiplomacyEventOperationAgent(OperationID eventoperationid, UniverseID newentityid);
	void SetDiplomacyEventOperationOption(UniverseID entityid, const char* optionid);
	void SetFactionRelationToPlayerFaction(const char* factionid, const char* reasonid, float boostvalue);
]]

local menu = {
	name = "DiplomacyMenu",
	factionData = {
		curEntry = {},
		sorter = "default",
		curTab = "licence",
	},
	agentData = {},
	expanded = {},
	state = {},
}

local config = {
	mode = "factions",
	mainLayer = 5,
	infoLayer = 4,
	contextLayer = 2,
	leftBar = {
		{ name = ReadText(1001, 7703),		icon = "mapst_factionrelation",		mode = "factions",	active = true, helpOverlayID = "diplomacy_sidebar_factions",	helpOverlayText = ReadText(1028, 7715) },
		{ name = ReadText(1001, 12817),		icon = "mapst_agent",				mode = "agents",	active = true, helpOverlayID = "diplomacy_embassy_agents",		helpOverlayText = ReadText(1028, 12801),																		condition = function () return C.IsStoryFeatureUnlocked("x4ep1_diplomacy_agent") end },
		{ name = ReadText(1001, 12816),		icon = "mapst_embassyaction",		mode = "embassy",	active = true, helpOverlayID = "diplomacy_sidebar_embassy",		helpOverlayText = ReadText(1028, 12801),	iconcolor = function () return menu.agentActionIconColor() end,		condition = function () return C.IsStoryFeatureUnlocked("x4ep1_diplomacy_agent") end },
		{ name = ReadText(1001, 12836),		icon = "mapst_events",				mode = "event",		active = true, helpOverlayID = "diplomacy_sidebar_events",		helpOverlayText = ReadText(1028, 12802),	iconcolor = function () return menu.eventIconColor() end,			condition = function () return C.IsStoryFeatureUnlocked("x4ep1_diplomacy_interference") end },
	},
	rightAlignTextProperties = {
		halign = "right"
	},
	rightAlignBoldTextProperties = {
		font = Helper.standardFontBold,
		halign = "right"
	},
	mouseOutRange = 100,
	factionListFontSize = Helper.headerRow1FontSize,
	factionIconHeight = 40,

	factions = {
		bannerAspectRatio = 15 / 2,
		relationCategories = {
			"hostile",
			"enemy",
			"ally",
			"member",
			"friend",
			"neutral",
		},
		relationDisplayOrder = {
			{ range = "ally",		name = ReadText(1001, 9603),	color = Color["text_ally"],				mouseovertext = ReadText(1026, 2403) },
			{ range = "friend",		name = ReadText(1001, 12876),	color = Color["text_friend"] },
			{ range = "neutral",	name = ReadText(1001, 12877),	color = Color["text_relation_neutral"] },
			{ range = "enemy",		name = ReadText(1001, 9604),	color = Color["text_enemy"],			mouseovertext = ReadText(1026, 2402) },
			{ range = "hostile",	name = ReadText(1001, 9632),	color = Color["text_hostile"],			mouseovertext = ReadText(1026, 2401) },
		},
		stations = {
			{ id = "shipyards",			name = ReadText(1001, 12879),	singlename = ReadText(1001, 12878) },
			{ id = "wharfs",			name = ReadText(1001, 12881),	singlename = ReadText(1001, 12880) },
			{ id = "equipmentdocks",	name = ReadText(1001, 12883),	singlename = ReadText(1001, 12882) },
			{ id = "tradestations",		name = ReadText(1001, 12885),	singlename = ReadText(1001, 12884) },
			{ id = "defencestations",	name = ReadText(1001, 12887),	singlename = ReadText(1001, 12886) },
			{ id = "factories",			name = ReadText(1001, 12889),	singlename = ReadText(1001, 12888) },
		},
		numDescLines = 7,
	},

	actions = {
		bannerAspectRatio = 15 / 2,
		numDescLines = 5,
		sectionBorder = math.ceil(Helper.scaleY(Helper.standardTextHeight) / 2),
		categories = {
			[1] = "negotiation",
			[2] = "espionage",
			[3] = "interference",
		},
	}
}

-- kuertee start:
menu.uix_callbacks = {}
-- kuertee end

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

function menu.agentActionIconColor()
	local curgametime = C.GetCurrentGameTime()
	for _, actioncategory in ipairs(config.actions.categories) do
		for _, action in ipairs(menu.actions[actioncategory]) do
			if menu.actionoperations[action.id] then
				for i, operation in ipairs(menu.actionoperations[action.id]) do
					if operation.isarchive then
						return Color["icon_mission"]
					end
				end
			end
		end
	end
	return Color["icon_normal"]
end

function menu.eventIconColor()
	local curgametime = C.GetCurrentGameTime()
	for _, eventoperation in ipairs(menu.eventoperations) do
		if eventoperation.isarchive and (not eventoperation.read) then
			return Color["icon_mission"]
		end
	end
	return Color["icon_normal"]
end

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

	menu.settoprow = nil
	menu.setselectedrow = nil
	menu.setselectedrow2 = nil
	menu.setselectedcol2 = nil
	menu.noupdate = nil

	menu.topRows = {}
	menu.selectedRows = {}
	menu.selectedCols = {}

	menu.factionData.curEntry = {}

	C.SetUICoverOverride(false)
end

-- Menu member functions

function menu.refreshInfoFrame(toprow, selectedrow, mode, selectedrow2)
	menu.settoprow = toprow or GetTopRow(menu.infoTable)
	menu.setselectedrow = selectedrow or Helper.currentTableRow[menu.infoTable]

	if menu.actiontable then
		menu.topRows.actiontable = GetTopRow(menu.actiontable.id)
		menu.selectedRows.actiontable = Helper.currentTableRow[menu.actiontable.id]
		menu.selectedCols.actiontable = Helper.currentTableCol[menu.actiontable.id]
	end
	if menu.agenttable then
		menu.topRows.agenttable = GetTopRow(menu.agenttable.id)
		menu.selectedRows.agenttable = Helper.currentTableRow[menu.agenttable.id]
		menu.selectedCols.agenttable = Helper.currentTableCol[menu.agenttable.id]
	end
	if menu.eventtable then
		menu.topRows.eventtable = GetTopRow(menu.eventtable.id)
		menu.selectedRows.eventtable = Helper.currentTableRow[menu.eventtable.id]
		menu.selectedCols.eventtable = Helper.currentTableCol[menu.eventtable.id]
	end

	menu.createInfoFrame()
end

function menu.buttonTogglePlayerInfo(mode)
	-- kuertee start: callback
	if menu.uix_callbacks ["buttonTogglePlayerInfo_on_start"] then
		for uix_id, uix_callback in pairs (menu.uix_callbacks ["buttonTogglePlayerInfo_on_start"]) do
			uix_callback (mode, config)
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

	if menu.mode == "factions" then
		Helper.clearTableConnectionColumn(menu, 3)
	end
	menu.closeContextMenu()

	AddUITriggeredEvent(menu.name, mode, menu.mode == mode and "off" or "on")
	if mode == menu.mode then
		PlaySound("ui_negative_back")
		menu.mode = nil
		if oldidx then
			SelectRow(menu.mainTable, oldidx + 2)
		end
	else
		menu.setdefaulttable = true
		PlaySound("ui_positive_select")
		menu.mode = mode
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

	if menu.mode == "factions" then
		Helper.clearTableConnectionColumn(menu, 3)
	end
	menu.closeContextMenu()

	PlaySound("ui_negative_back")
	menu.mode = nil
	if oldidx then
		SelectRow(menu.mainTable, oldidx + 2)
	end

	menu.refreshInfoFrame(1, 1)
end

function menu.buttonSelectObject(actionid, paramidx, paramdata)
	menu.state.actiontoprow = GetTopRow(menu.actiontable.id)
	Helper.closeMenuAndOpenNewMenu(menu, "MapMenu", { 0, 0, false, nil, nil, "diplomaticactionparam_object", { actionid, paramidx - 1, paramdata } })
	menu.cleanup()
end

function menu.buttonStartAction()
	local agent = menu.agents[menu.contextMenuData.selectedagentid]
	local agentid = ConvertStringToLuaID(tostring(agent.id))
	local parameters = {}
	local targets = GetDiplomaticActionTargetParameters(menu.contextMenuData.id)
	for i, target in ipairs(targets) do
		if target.type == "object" then
			parameters[target.name] = ConvertStringToLuaID(tostring(menu.contextMenuData.targets[i]))
		else
			parameters[target.name] = menu.contextMenuData.targets[i]
		end
	end
	local giftware = ""
	if menu.contextMenuData.giftware and (menu.contextMenuData.giftware ~= "none") then
		giftware = menu.contextMenuData.giftware
	end

	if agent.isbusy and (agent.isbusy.eventoperation and (not agent.isbusy.optionselected)) then
		C.SetDiplomacyEventOperationAgent(agent.isbusy.eventoperation, 0)
	end

	local actionid = menu.contextMenuData.id
	menu.laststartedactionoperation = StartDiplomacyActionOperation(actionid, agentid, parameters, giftware)
	menu.closeContextMenu(true)
	menu.getData()

	if menu.laststartedactionoperation then
		if menu.actionoperations[actionid] then
			for i, operation in ipairs(menu.actionoperations[actionid]) do
				if operation.id == menu.laststartedactionoperation then
					menu.contextMenuMode = "actionconfig"
					menu.contextMenuData.id = actionid
					menu.contextMenuData.operationindex = i
					menu.contextMenuData.targets = {}

					local y = math.max(Helper.playerInfoConfig.offsetY + Helper.playerInfoConfig.height + Helper.borderSize, menu.topLevelHeight)
					menu.createContextFrame(Helper.playerInfoConfig.offsetX + menu.sideBarWidth + Helper.borderSize + menu.narrowtablewidth + Helper.borderSize, y, menu.actionConfig.width, true)
				end
			end
		end
	end
	menu.refreshInfoFrame()
end

function menu.buttonAbortAction(agentid, confirmed, unique, exclusivefactionidx, cooldown)
	if confirmed then
		C.AbortActiveDiplomacyActionOperation(agentid)
		menu.getData()
		menu.closeContextMenu()
		menu.refreshInfoFrame()
	else
		menu.contextMenuMode = "userquestion"
		menu.contextMenuData = { mode = "abortaction", agentid = agentid, unique = unique, exclusivefactionidx = exclusivefactionidx, cooldown = cooldown }
		menu.createContextFrame(0, 0, Helper.viewWidth, true)
	end
end

function menu.buttonShowEncyclopedia(mode, library, id, objectid)
	Helper.closeMenuAndOpenNewMenu(menu, "EncyclopediaMenu", { 0, 0, mode, library, id, objectid })
	menu.cleanup()
end

function menu.buttonShowObjectOnMap(object, showzone)
	if showzone == nil then
		showzone = true
	end
	Helper.closeMenuAndOpenNewMenu(menu, "MapMenu", { 0, 0, showzone, object })
	menu.cleanup()
end

function menu.buttonSelectFaction(factionid)
	menu.factionData.curEntry = menu.relationsByID[factionid]
	menu.contextMenuMode = "factiondetails"
	menu.contextMenuData = {}
	local y = math.max(Helper.playerInfoConfig.offsetY + Helper.playerInfoConfig.height + Helper.borderSize, menu.topLevelHeight)
	menu.createContextFrame(Helper.playerInfoConfig.offsetX + menu.sideBarWidth + Helper.borderSize + menu.narrowtablewidth + Helper.borderSize, y, menu.factionConfig.width, true)
	menu.refresh = getElapsedTime()
end

function menu.buttonExpand(id)
	if menu.expanded[id] then
		menu.expanded[id] = nil
	else
		menu.expanded[id] = true
	end
	menu.refreshContextFrame()
end

function menu.dropdownSelectFaction(actionid, i, factionid)
	menu.contextMenuData.targets[i] = factionid
	if i == 1 then
		for j, entry in ipairs(menu.contextMenuData.targets) do
			if j ~= 1 then
				menu.contextMenuData.targets[j] = nil
			end
		end
	end
	menu.refreshContextFrame()
end

function menu.dropdownSelectWare(actionid, i, wareid)
	menu.contextMenuData.targets[i] = wareid
	menu.refreshContextFrame()
end

function menu.dropdownAssignEventAgent(eventoperationid, agentid)
	local agent = menu.agents[tonumber(agentid)]

	if agent.isbusy and (agent.isbusy.eventoperation and (not agent.isbusy.optionselected)) then
		C.SetDiplomacyEventOperationAgent(agent.isbusy.eventoperation, 0)
	end

	C.SetDiplomacyEventOperationAgent(eventoperationid, agent.id);
	menu.getData()
	menu.refreshContextFrame()
end

function menu.hotkey(action)
	if action == "INPUT_ACTION_ADDON_DETAILMONITOR_CLOSE_DIPLOMACY" then
		menu.closeMenu("close")
	end
end

function menu.onShowMenu(state)
	menu.param = menu.param or {}

	-- reset settings
	C.SetUICoverOverride(false)
	menu.noupdate = nil
	menu.topRows = {}
	menu.selectedRows = {}
	menu.selectedCols = {}

	-- Register bindings
	Helper.setKeyBinding(menu, menu.hotkey)
	RegisterAddonBindings("ego_detailmonitor", "diplomacy")

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

	menu.narrowtablewidth = Helper.playerInfoConfig.width - menu.sideBarWidth - Helper.borderSize
	menu.factionConfig = {
		width = menu.playerInfoFullWidth - menu.sideBarWidth - Helper.borderSize - 2 * (menu.narrowtablewidth + Helper.borderSize),
		height = 0.78 * Helper.viewHeight,
	}
	menu.actionConfig = {
		width = Helper.round(1.5 * (Helper.playerInfoConfig.width - menu.sideBarWidth - Helper.borderSize)),
	}
	menu.eventConfig = {
		width = Helper.round(1.5 * (Helper.playerInfoConfig.width - menu.sideBarWidth - Helper.borderSize)),
	}

	menu.getData()

	menu.mode = menu.param[3] or menu.mode or config.mode
	-- cleanup parameter, so we are not returned automatically to the original mode when opening another menu/conversation from this menu (but a different mode)
	menu.param[3] = nil

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

	if type(menu.param[4]) == "table" then
		if (menu.mode == "agents") and menu.param[4][1] then
			local agentid64 = C.ConvertStringTo64Bit(tostring(menu.param[4][1]))
			local agentindex
			for i, agent in ipairs(menu.agents) do
				if agent.id == agentid64 then
					agentindex = i
					break
				end
			end

			if agentindex then
				menu.contextMenuMode = "agentdetails"
				menu.contextMenuData = { id = agentindex }
				local y = math.max(Helper.playerInfoConfig.offsetY + Helper.playerInfoConfig.height + Helper.borderSize, menu.topLevelHeight)
				menu.createContextFrame(Helper.playerInfoConfig.offsetX + menu.sideBarWidth + Helper.borderSize + menu.narrowtablewidth + Helper.borderSize, y, menu.narrowtablewidth, true)
				menu.refreshInfoFrame()
			end
		end
	elseif menu.param[4] then
		menu.contextMenuMode = "actionconfig"
		menu.contextMenuData.id = menu.param[4]
		menu.contextMenuData.operationindex = nil
		menu.contextMenuData.targets[menu.param[5] + 1] = C.ConvertStringTo64Bit(tostring(menu.param[6]))

		local y = math.max(Helper.playerInfoConfig.offsetY + Helper.playerInfoConfig.height + Helper.borderSize, menu.topLevelHeight)
		menu.createContextFrame(Helper.playerInfoConfig.offsetX + menu.sideBarWidth + Helper.borderSize + menu.narrowtablewidth + Helper.borderSize, y, menu.actionConfig.width, true)
		menu.selectedRows.actiontable = menu.state.actiontoprow
		menu.refreshInfoFrame()
	end

	-- check for new events
	for _, actioncategory in ipairs(config.actions.categories) do
		for _, action in ipairs(menu.actions[actioncategory]) do
			if action.eventtrigger then
				if menu.actionoperations[action.id] then
					for i, operation in ipairs(menu.actionoperations[action.id]) do
						if operation.isarchive and (not operation.read) then
							menu.contextMenuMode = "newevent"
							menu.contextMenuData = { actionoperationid = operation.id }
							menu.createContextFrame(0, 0, Helper.viewWidth, true)
							return
						end
					end
				end
			end
		end
	end

	for _, eventoperation in ipairs(menu.eventoperations) do
		if eventoperation.isarchive and (not eventoperation.read) then
			menu.contextMenuMode = "eventcompleted"
			menu.contextMenuData = { eventoperationid = eventoperation.id }
			menu.createContextFrame(0, 0, Helper.viewWidth, true)
			return
		end
	end
end

function menu.getData()
	-- influence
	menu.playerinfluence = C.GetPlayerInfluence()

	-- agents
	menu.agents = {}
	local n = C.GetNumDiplomacyAgents()
	if n > 0 then
		local buf = ffi.new("UniverseID[?]", n)
		n = C.GetDiplomacyAgents(buf, n)
		for i = 0, n - 1 do
			local id = buf[i]
			local luaid = ConvertStringToLuaID(tostring(id))
			local entry = {
				id = id,
				name = ffi.string(C.GetComponentName(id)),
				icon = GetComponentData(luaid, "agenticon"),
				rank = "",
				rankicon = "",
				exp_negotiation = GetNPCBlackboard(luaid, "$diplomacy_exp_negotiation") or 0,
				exp_espionage = GetNPCBlackboard(luaid, "$diplomacy_exp_espionage") or 0,
				injuryendtime = GetNPCBlackboard(luaid, "$diplomacy_injury_endtime") or -1,
			}
			local attributes = C.GetDiplomacyAgentAttributeData(entry.exp_negotiation, entry.exp_espionage)
			entry.exp_negotiation_name = ffi.string(attributes.exp_negotiation_name)
			entry.exp_espionage_name = ffi.string(attributes.exp_espionage_name)
			entry.rank = entry.exp_negotiation + entry.exp_espionage
			entry.rankname = ffi.string(attributes.rankname)
			entry.rankicon = ffi.string(attributes.rankiconid)
			entry.ship = C.GetAgentDiplomacyShip(id)
			table.insert(menu.agents, entry)
		end
	end

	-- actions
	menu.actions = {
		negotiation		= { text = ReadText(1001, 12820) },
		espionage		= { text = ReadText(1001, 12821) },
		interference	= { text = ReadText(1001, 12844) },
	}
	local n = C.GetNumDiplomacyActions()
	if n > 0 then
		local buf = ffi.new("DiplomacyActionInfo[?]", n)
		n = C.GetDiplomacyActions(buf, n)
		for i = 0, n - 1 do
			local entry = {
				id = ffi.string(buf[i].id),
				category = ffi.string(buf[i].category),
				paramtype = ffi.string(buf[i].paramtype),
				name = ffi.string(buf[i].name),
				desc = ffi.string(buf[i].desc),
				shortdesc = ffi.string(buf[i].shortdesc),
				iconid = ffi.string(buf[i].iconid),
				imageid = ffi.string(buf[i].imageid),
				rewardtext = ffi.string(buf[i].rewardtext),
				successtext = ffi.string(buf[i].successtext),
				failuretext = ffi.string(buf[i].failuretext),
				successchance = buf[i].successchance,
				agenttype = ffi.string(buf[i].agenttype),
				agentexp = buf[i].agentexp,
				agentexpname = ffi.string(buf[i].agentexpname),
				agentrisk = ffi.string(buf[i].agentrisk),
				giftwaretags = ffi.string(buf[i].giftwaretags),
				duration = buf[i].duration,
				cooldown = buf[i].cooldown,
				price = tonumber(buf[i].price),
				influencerequirement = buf[i].influencerequirement,
				exclusivefactionparamidx = buf[i].exclusivefactionparamidx,
				warecostscaleparamidx = buf[i].warecostscaleparamidx,
				numwarerequirements = buf[i].numwarerequirements,
				unique = buf[i].unique,
				hidden = buf[i].hidden,
				eventtrigger = buf[i].eventtrigger,
				warerequirements = {},
			}
			table.insert(menu.actions[entry.category], entry)
		end
	end
	menu.actionsByID = {}
	for _, actiongroup in pairs(menu.actions) do
		for _, action in ipairs(actiongroup) do
			if action.numwarerequirements > 0 then
				local buf_wares = ffi.new("UIWareAmount[?]", action.numwarerequirements)
				local numwares = C.GetDiplomacyActionWares(buf_wares, action.numwarerequirements, action.id)
				for i = 0, numwares - 1 do
					table.insert(action.warerequirements, { ware = ffi.string(buf_wares[i].wareid), amount = buf_wares[i].amount })
				end
			end
			menu.actionsByID[action.id] = action
		end
	end
	local operationtypes = { "active", "archive" }
	menu.actionoperations = {}
	menu.actionoperationsByID = {}
	for _, operationtype in ipairs(operationtypes) do
		local n = C.GetNumDiplomacyActionOperations(operationtype == "active")
		if n > 0 then
			local buf = ffi.new("DiplomacyActionOperation[?]", n)
			n = C.GetDiplomacyActionOperations(buf, n, operationtype == "active")
			for i = 0, n - 1 do
				local id = buf[i].id
				local agentid = buf[i].agentid
				local agentindex
				for j, agent in ipairs(menu.agents) do
					if agent.id == agentid then
						agentindex = j
						if operationtype == "active" then
							menu.agents[j].isbusy = { actionoperation = id }
						end
						break
					end
				end
				if (operationtype == "archive") or agentindex then
					local actionid = ffi.string(buf[i].actionid)
					local entry = {
						id = id,
						actionid = actionid,
						agentid = agentid,
						agentindex = agentindex,
						agentname = (agentid ~= 0) and ffi.string(C.GetComponentName(agentid)) or ffi.string(buf[i].agentname),
						agentimageid = ffi.string(buf[i].agentimageid),
						agentresultstate = ffi.string(buf[i].agentresultstate),
						agentexp_negotiation = buf[i].agentexp_negotiation,
						agentexp_espionage = buf[i].agentexp_espionage,
						giftwareid = ffi.string(buf[i].giftwareid),
						starttime = buf[i].starttime,
						endtime = buf[i].endtime,
						read = buf[i].read,
						successful = buf[i].successful,
						isarchive = operationtype == "archive",
					}
					local attributes = C.GetDiplomacyAgentAttributeData(entry.agentexp_negotiation, entry.agentexp_espionage)
					entry.agentexp_negotiation_name = ffi.string(attributes.exp_negotiation_name)
					entry.agentexp_espionage_name = ffi.string(attributes.exp_espionage_name)
					entry.agentrank = entry.agentexp_negotiation + entry.agentexp_espionage
					entry.agentrankname = ffi.string(attributes.rankname)
					entry.agentrankicon = ffi.string(attributes.rankiconid)

					if not entry.read then
						if menu.actionoperations[actionid] then
							table.insert(menu.actionoperations[actionid], entry)
						else
							menu.actionoperations[actionid] = { entry }
						end
						menu.actionoperationsByID[tostring(id)] = entry
					end
				end
			end
		end
	end

	-- events
	menu.eventsByID = {}
	local n = C.GetNumDiplomacyEvents()
	if n > 0 then
		local buf = ffi.new("DiplomacyEventInfo[?]", n)
		n = C.GetDiplomacyEvents(buf, n)
		for i = 0, n - 1 do
			local id = ffi.string(buf[i].id)
			menu.eventsByID[id] = {
				id = id,
				name = ffi.string(buf[i].name),
				desc = ffi.string(buf[i].desc),
				shortdesc = ffi.string(buf[i].shortdesc),
				iconid = ffi.string(buf[i].iconid),
				imageid = ffi.string(buf[i].imageid),
				duration = buf[i].duration,
				numoptions = buf[i].numoptions,
				options = {},
			}
		end
	end
	for _, event in pairs(menu.eventsByID) do
		if event.numoptions > 0 then
			local buf_options = ffi.new("DiplomacyEventOptionInfo[?]", event.numoptions)
			local numoptions = C.GetDiplomacyEventOptions(buf_options, event.numoptions, event.id)
			for i = 0, numoptions - 1 do
				table.insert(event.options, {
					id = ffi.string(buf_options[i].id),
					name = ffi.string(buf_options[i].name),
					desc = ffi.string(buf_options[i].desc),
					result = ffi.string(buf_options[i].result),
					conclusion = ffi.string(buf_options[i].conclusion),
					agentrisk = ffi.string(buf_options[i].agentrisk),
					successchance = buf_options[i].successchance,
					relationchange = buf_options[i].relationchange,
					price = tonumber(buf_options[i].price),
					influencerequirement = buf_options[i].influencerequirement,
					numwarerequirements = buf_options[i].numwarerequirements,
					menuposition = buf_options[i].menuposition,
					warerequirements = {},
				})
			end

			for _, option in ipairs(event.options) do
				if option.numwarerequirements > 0 then
					local buf_wares = ffi.new("UIWareAmount[?]", option.numwarerequirements)
					local numwares = C.GetDiplomacyEventOptionWares(buf_wares, option.numwarerequirements, event.id, option.id)
					for i = 0, numwares - 1 do
						table.insert(option.warerequirements, { ware = ffi.string(buf_wares[i].wareid), amount = buf_wares[i].amount })
					end
				end
			end
		end
	end
	menu.eventoperations = {}
	menu.eventoperationsByID = {}
	menu.eventoperationsBySourceID = {}
	for _, operationtype in ipairs(operationtypes) do
		local n = C.GetNumDiplomacyEventOperations(operationtype == "active")
		if n > 0 then
			local buf = ffi.new("DiplomacyEventOperation[?]", n)
			n = C.GetDiplomacyEventOperations(buf, n, operationtype == "active")
			for i = 0, n - 1 do
				local eventid = ffi.string(buf[i].eventid)
				if menu.eventsByID[eventid] then
					local id = buf[i].id
					local agentid = buf[i].agentid
					local option = ffi.string(buf[i].option)
					local agentindex
					for j, agent in ipairs(menu.agents) do
						if agent.id == agentid then
							agentindex = j
							if operationtype == "active" then
								menu.agents[j].isbusy = { eventoperation = id, optionselected = option ~= "" }
							end
							break
						end
					end

					local entry = {
						id = id,
						sourceid = buf[i].sourceactionoperationid,
						eventid = eventid,
						agentid = agentid,
						agentindex = agentindex,
						agentname = (agentid ~= 0) and ffi.string(C.GetComponentName(agentid)) or ffi.string(buf[i].agentname),
						agentimageid = ffi.string(buf[i].agentimageid),
						agentresultstate = ffi.string(buf[i].agentresultstate),
						agentexp_negotiation = buf[i].agentexp_negotiation,
						agentexp_espionage = buf[i].agentexp_espionage,
						faction = ffi.string(buf[i].faction),
						otherfaction = ffi.string(buf[i].otherfaction),
						option = option,
						outcome = ffi.string(buf[i].outcome),
						starttime = buf[i].starttime,
						read = buf[i].read,
						startrelation = buf[i].startrelation,
						isarchive = operationtype == "archive",
					}
					local attributes = C.GetDiplomacyAgentAttributeData(entry.agentexp_negotiation, entry.agentexp_espionage)
					entry.agentexp_negotiation_name = ffi.string(attributes.exp_negotiation_name)
					entry.agentexp_espionage_name = ffi.string(attributes.exp_espionage_name)
					entry.agentrank = entry.agentexp_negotiation + entry.agentexp_espionage
					entry.agentrankname = ffi.string(attributes.rankname)
					entry.agentrankicon = ffi.string(attributes.rankiconid)
					entry.endtime = entry.starttime + menu.eventsByID[eventid].duration
					table.insert(menu.eventoperations, entry)
					menu.eventoperationsByID[tostring(entry.id)] = entry
					menu.eventoperationsBySourceID[tostring(entry.sourceid)] = entry
				end
			end
		end
	end
	table.sort(menu.eventoperations, function (a, b) return a.endtime > b.endtime end)
end

function menu.onSaveState()
	local state = {}

	state.settoprow = GetTopRow(menu.infoTable)
	state.setselectedrow = Helper.currentTableRow[menu.infoTable]
	state.contextmenumode = menu.contextMenuMode

	return state
end

function menu.onRestoreState(state)
	menu.settoprow = state.settoprow
	menu.setselectedrow = state.setselectedrow

	if state.contextmenumode == "actionconfig" then
		menu.contextMenuMode = state.contextmenumode
		if state.targetindex then
			menu.contextMenuData.targets[state.targetindex + 1] = C.ConvertStringTo64Bit(tostring(state.target))
		end
		local y = math.max(Helper.playerInfoConfig.offsetY + Helper.playerInfoConfig.height + Helper.borderSize, menu.topLevelHeight)
		menu.createContextFrame(Helper.playerInfoConfig.offsetX + menu.sideBarWidth + Helper.borderSize + menu.narrowtablewidth + Helper.borderSize, y, menu.actionConfig.width, true)
	end
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
	if menu.uix_callbacks ["createPlayerInfo_on_start"] then
		for uix_id, uix_callback in pairs (menu.uix_callbacks ["createPlayerInfo_on_start"]) do
			uix_callback (config)
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
	menu.topLevelHeight = Helper.createTopLevelTab(menu, "diplomacy", frame, "", nil, true)
end

function menu.onTabScroll(direction)
	if direction == "right" then
		Helper.scrollTopLevel(menu, "diplomacy", 1)
	elseif direction == "left" then
		Helper.scrollTopLevel(menu, "diplomacy", -1)
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
	if menu.uix_callbacks ["createInfoFrame_on_start"] then
		for uix_id, uix_callback in pairs (menu.uix_callbacks ["createInfoFrame_on_start"]) do
			uix_callback (menu.infoFrame, tableProperties, config)
		end
	end
	-- kuertee end: callback

	-- remove old data
	Helper.clearDataForRefresh(menu, config.infoLayer)

	local width = Helper.playerInfoConfig.width
	if (menu.mode == "factions") then
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

	menu.createTopLevel(menu.infoFrame)

	local tableProperties = {
		width = width - menu.sideBarWidth - Helper.borderSize,
		x = Helper.playerInfoConfig.offsetX + menu.sideBarWidth + Helper.borderSize,
		y = math.max(Helper.playerInfoConfig.offsetY + Helper.playerInfoConfig.height + Helper.borderSize, menu.topLevelHeight),
	}
	tableProperties.height = Helper.viewHeight - tableProperties.y

	Helper.clearTableConnectionColumn(menu, 2)

	if menu.mode == "factions" then
		Helper.clearTableConnectionColumn(menu, 3)
		menu.createFactions(menu.infoFrame, tableProperties)
	elseif menu.mode == "embassy" then
		menu.createEmbassy(menu.infoFrame, tableProperties)
	elseif menu.mode == "agents" then
		menu.createAgents(menu.infoFrame, tableProperties)
	elseif menu.mode == "event" then
		menu.createEvents(menu.infoFrame, tableProperties)
	end

	-- kuertee start: callback
	if menu.uix_callbacks ["createInfoFrame_on_info_frame_mode"] then
		for uix_id, uix_callback in pairs (menu.uix_callbacks ["createInfoFrame_on_info_frame_mode"]) do
			uix_callback (menu.infoFrame, tableProperties)
		end
	end
	-- kuertee end: callback

	menu.infoFrame:display()
end

function menu.createFactions(frame, tableProperties)
	local iconheight = config.factionIconHeight
	local iconoffset = 2

	local infotable = frame:addTable(4, { tabOrder = 1, width = menu.narrowtablewidth, x = tableProperties.x, y = tableProperties.y })
	if menu.setdefaulttable then
		infotable.properties.defaultInteractiveObject = true
		menu.setdefaulttable = nil
	end
	infotable:setColWidth(1, Helper.scaleX(iconheight) + 2 * iconoffset, false)
	infotable:setColWidth(2, C.GetTextWidth("[WWW]", Helper.standardFont, Helper.scaleFont(Helper.standardFont, config.factionListFontSize)), false)
	infotable:setColWidthPercent(4, 25)
	infotable:setDefaultBackgroundColSpan(1, 4)

	local titletable = frame:addTable(6, { tabOrder = 2, width = menu.narrowtablewidth, x = tableProperties.x, y = tableProperties.y })
	titletable:setColWidth(1, Helper.scaleX(iconheight) + 2 * iconoffset, false)
	titletable:setColWidthPercent(3, 20)
	titletable:setColWidthPercent(4, 20)
	titletable:setColWidthPercent(5, 20)
	titletable:setColWidthPercent(6, 20)

	-- title
	local row = titletable:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
	row[1]:setColSpan(6):createText(ReadText(1001, 7703), Helper.titleTextProperties)
	row[1].properties.height = row[1].properties.height + Helper.borderSize

	-- cover override
	if Helper.isPlayerCovered() then
		local row = titletable:addRow(true, { fixed = true })
		row[1]:createCheckBox(C.IsUICoverOverridden(), { width = Helper.standardTextHeight, height = Helper.standardTextHeight, mouseOverText = ReadText(1026, 7713) })
		row[1].handlers.onClick = function(_, checked) C.SetUICoverOverride(checked); menu.refreshInfoFrame() end
		row[2]:setColSpan(5):createText(ReadText(1001, 11604), { mouseOverText = ReadText(1026, 7713) })
	end

	local row = titletable:addRow(nil, { fixed = true })
	row[1]:setColSpan(4):createText(ReadText(1001, 2906) .. ReadText(1001, 120))

	local arrowWidth = Helper.scaleY(Helper.standardButtonHeight)
	local row = titletable:addRow(true, { fixed = true })
	row[1]:setColSpan(2):createButton({ bgColor = (menu.factionData.sorter == "default") and Color["row_background_selected"] or Color["row_title_background"] }):setText(ReadText(1001, 12870), { halign = "center" })
	row[1].handlers.onClick = function () menu.factionData.sorter = "default"; menu.refreshInfoFrame() end
	row[3]:createButton({  }):setText(ReadText(1001, 12871), { halign = "center" })
	if (menu.factionData.sorter == "name") or (menu.factionData.sorter == "name_inv") then
		row[3].properties.bgColor = Color["row_background_selected"]
		row[3]:setIcon((menu.factionData.sorter == "name_inv") and "table_arrow_inv_up" or "table_arrow_inv_down", { scaling = false, width = arrowWidth, height = arrowWidth, x = row[3]:getColSpanWidth() - arrowWidth })
	end
	row[3].handlers.onClick = function () menu.factionData.sorter = (menu.factionData.sorter == "name") and "name_inv" or "name"; menu.refreshInfoFrame() end
	row[4]:createButton({  }):setText(ReadText(1001, 12872), { halign = "center" })
	if (menu.factionData.sorter == "relation") or (menu.factionData.sorter == "relation_inv") then
		row[4].properties.bgColor = Color["row_background_selected"]
		row[4]:setIcon((menu.factionData.sorter == "relation_inv") and "table_arrow_inv_up" or "table_arrow_inv_down", { scaling = false, width = arrowWidth, height = arrowWidth, x = row[4]:getColSpanWidth() - arrowWidth })
	end
	row[4].handlers.onClick = function () menu.factionData.sorter = (menu.factionData.sorter == "relation") and "relation_inv" or "relation"; menu.refreshInfoFrame() end

	infotable.properties.y = titletable.properties.y + titletable:getFullHeight() + 2 * Helper.scaleY(Helper.standardContainerOffset)

	menu.relations = GetLibrary("factions")
	menu.relationsByID = {}
	for i, relation in ipairs(menu.relations) do
		if relation.id == "player" then
			table.remove(menu.relations, i)
			break
		end
	end
	menu.licences = {}
	for i, relation in ipairs(menu.relations) do
		relation.shortname, relation.isdiplomacyactive, relation.isatdockrelation, relation.isrelationlocked, relation.relationlockshortreason = GetFactionData(relation.id, "shortname", "isdiplomacyactive", "isatdockrelation", "isrelationlocked", "relationlockshortreason")
		menu.relationsByID[relation.id] = relation
		menu.licences[relation.id] = GetOwnLicences(relation.id)
		table.sort(menu.licences[relation.id], menu.sortLicences)
	end
	table.sort(menu.relations, menu.relationSorter)

	if #menu.relations == 0 then
		row = infotable:addRow(true, {  })
		row[1]:setColSpan(4):createText("--- " .. ReadText(1001, 38) .. " ---", { halign = "center" })
	else
		local diplomacyinactiveshown = false
		for i, relation in ipairs(menu.relations) do
			if menu.factionData.sorter == "default" then
				if (not relation.isdiplomacyactive) and (not diplomacyinactiveshown) then
					diplomacyinactiveshown = true
					local row = infotable:addRow(nil)
					row[1]:setColSpan(4):createText(ReadText(1001, 12873), Helper.subHeaderTextProperties)
				end
			end

			row = infotable:addRow({ "faction", relation }, { bgColor = (relation.id == menu.factionData.curEntry.id) and Color["row_background_selected"] or Color["row_background_blue"] })
			row[1]:setBackgroundColSpan(4):createIcon((relation.icon ~= "") and relation.icon or "solid", {
				height = iconheight,
				x = iconoffset,
				color = function () return menu.relationColor(relation.id) end,
				mouseOverText = function () local prioritizedrelationrangename = GetFactionData(relation.id, "prioritizedrelationrangename"); return prioritizedrelationrangename end,
				helpOverlayID = "diplomacy_faction_" .. relation.id,
				helpOverlayText = " ",
				helpOverlayHighlightOnly = true,
				helpOverlayUseBackgroundSpan = true,
			})
			if relation.id == menu.factionData.curEntry.id then
				menu.setselectedrow = row.index
			end

			local mouseovertext
			local diplomatcolor
			local diplomatname = ReadText(1001, 12812)
			if relation.isdiplomacyactive then
				if not relation.isatdockrelation then
					diplomatname = ReadText(1001, 12813)
					diplomatcolor = Color["text_inactive"]
					mouseovertext = ReadText(1026, 12801)
				else
					local diplomat = C.GetPlayerRepresentative(relation.id)
					if diplomat ~= 0 then
						diplomatname = ffi.string(C.GetComponentName(diplomat))
					end
				end
			end
			row[2]:createIcon("solid", {
				color = Color["icon_hidden"],
				mouseOverText = function () local prioritizedrelationrangename = GetFactionData(relation.id, "prioritizedrelationrangename"); return prioritizedrelationrangename .. (mouseovertext and ("\n" .. mouseovertext) or "") end,
			}):setText("[" .. relation.shortname .. "] - " .. relation.name, {
				font = Helper.standardFontBold,
				fontsize = config.factionListFontSize,
				color = function () return menu.relationColor(relation.id) end,
				y = -iconheight / 2 + 2 * iconoffset,
			})
			if relation.isdiplomacyactive then
				row[2]:setText2(ReadText(1001, 12803) .. ReadText(1001, 120) .. " " .. diplomatname, {
					y = 2 * iconoffset,
					color = diplomatcolor,
				})
			end
			local relationtext = function () return ffi.string(C.GetUIRelationName("player", relation.id).name) .. " (" .. string.format("%+d", GetUIRelation(relation.id)) .. ")" end
			if relation.isrelationlocked then
				if GetUIRelation(relation.id) <= -25 then
					relationtext = ReadText(20229, 201)
				else
					relationtext = (relation.relationlockshortreason ~= "") and relation.relationlockshortreason or ReadText(20229, 101)
				end
			end
			row[4]:createIcon("solid", {
				color = Color["icon_hidden"],
				mouseOverText = function () local prioritizedrelationrangename = GetFactionData(relation.id, "prioritizedrelationrangename"); return prioritizedrelationrangename end
			}):setText(relationtext, {
				font = Helper.standardFontBoldMono,
				fontsize = config.factionListFontSize,
				color = function () return menu.relationColor(relation.id) end,
				halign = "right",
				x = Helper.standardTextOffsetx,
				y = -iconheight / 2 + 2 * iconoffset,
			})
		end
	end
	infotable:setTopRow(menu.settoprow)
	infotable:setSelectedRow(menu.setselectedrow)
	menu.settoprow = nil
	menu.setselectedrow = nil

	titletable:addConnection(1, 2, true)
	infotable:addConnection(2, 2)
end

function menu.createEmbassy(frame, tableProperties)
	local actioniconheight = config.factionIconHeight
	local actioniconoffset = 2

	menu.actiontable = frame:addTable(6, { tabOrder = 1, width = menu.narrowtablewidth, x = tableProperties.x, y = tableProperties.y })
	if menu.setdefaulttable then
		menu.actiontable.properties.defaultInteractiveObject = true
		menu.setdefaulttable = nil
	end
	menu.actiontable:setColWidth(1, actioniconheight, true)
	menu.actiontable:setColWidthPercent(3, 20)
	menu.actiontable:setColWidthPercent(4, 30)
	menu.actiontable:setColWidthPercent(5, 25)
	menu.actiontable:setColWidth(6, Helper.standardTextHeight)

	-- title
	local row = menu.actiontable:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
	row[1]:setColSpan(6):createText(ReadText(1001, 12816), Helper.titleTextProperties)
	row[1].properties.height = row[1].properties.height + Helper.borderSize

	-- influence
	local row = menu.actiontable:addRow(nil, { fixed = true })
	row[1]:setColSpan(4):createText(ReadText(1001, 12847), { font = Helper.standardFontBold, fontsize = Helper.headerRow1FontSize })
	row[5]:setColSpan(2):createText("\27[diplomacy_influence] " .. ffi.string(C.GetInfluenceLevelName(menu.playerinfluence)), { halign = "right", fontsize = Helper.headerRow1FontSize })

	menu.actiontable:addEmptyRow(Helper.standardTextHeight / 2)

	local row = menu.actiontable:addRow(nil, { fixed = true })
	row[1]:setColSpan(6):createText(ReadText(1001, 12845), { wordwrap = true })

	local row = menu.actiontable:addRow(nil, { fixed = true, bgColor = Color["row_separator"] })
	row[1]:setColSpan(6):createText(" ", { scaling = false, fontsize = 1, height = Helper.borderSize })

	local curgametime = C.GetCurrentGameTime()
	for _, actioncategory in ipairs(config.actions.categories) do
		local actiongroup = menu.actions[actioncategory]

		if #actiongroup > 0 then
			local first = true
			for _, action in ipairs(actiongroup) do
				if (not action.hidden) or menu.actionoperations[action.id] then
					if first then
						first = false

						local row = menu.actiontable:addRow(nil, {  })
						row[1]:setColSpan(6):createText(actiongroup.text, Helper.subHeaderTextProperties)
					end

					local isselected = false
					if (menu.contextMenuMode == "actionconfig") and (action.id == menu.contextMenuData.id) and (menu.contextMenuData.operationindex == nil) then
						isselected = true
					end

					local desctextlines = GetTextLines(action.shortdesc, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), menu.narrowtablewidth - Helper.scrollbarWidth - Helper.scaleX(actioniconheight) - 2 * Helper.standardTextOffsetx)
					local desctext = ""
					for i, line in ipairs(desctextlines) do
						if i > 1 then
							desctext = desctext .. "\n"
						end
						desctext = desctext .. line
					end
					local extraheight = math.max(0, #desctextlines - 1) * Helper.standardTextHeight

					local row = menu.actiontable:addRow({ type = "action", id = action.id }, { bgColor = isselected and Color["row_background_selected"] or Color["row_background_blue"] })
					local icon = action.iconid
					local cooldowntext = ""
					if action.hidden then
						cooldowntext = "[" .. ReadText(1001, 12840) .. "] "
					elseif C.GetDiplomacyActionCooldownEndTime(action.id, "", true) >= 0 then
						icon = icon .. "_cooldown"
						if C.GetDiplomacyActionCooldownEndTime(action.id, "", false) >= 0 then
							cooldowntext = "[" .. ReadText(1001, 12924) .. "] "
						end
					end
					row[1]:setColSpan(4):setBackgroundColSpan(6):createIcon(icon, {
						width = actioniconheight,
						height = actioniconheight,
					}):setText(cooldowntext .. action.name, {
						font = Helper.standardFontBold,
						fontsize = Helper.headerRow1FontSize,
						x = actioniconheight + Helper.standardTextOffsetx,
						y = actioniconoffset - extraheight / 2,
					}):setText2(desctext, {
						x = actioniconheight + Helper.standardTextOffsetx,
						y = actioniconheight / 2 + actioniconoffset - extraheight / 2,
					})
					row[5]:setColSpan(2):createText("\27[diplomacy_influence] " .. ffi.string(C.GetInfluenceLevelName(action.influencerequirement)), { halign = "right", y = actioniconoffset, font = Helper.standardFontBold, fontsize = Helper.headerRow1FontSize, minRowHeight = actioniconheight + extraheight })

					-- current operations
					if menu.actionoperations[action.id] then
						for i, operation in ipairs(menu.actionoperations[action.id]) do
							local ispastoperation = operation.endtime <= curgametime
							local color
							if ispastoperation then
								color = Color["text_mission"]
							end

							local isselected = false
							if (menu.contextMenuMode == "actionconfig") and (action.id == menu.contextMenuData.id) and (menu.contextMenuData.operationindex == i) then
								isselected = true
							end

							local row = menu.actiontable:addRow({ type = "action", id = action.id, operationindex = i }, { bgColor = isselected and Color["row_background_selected"] or nil })
							if operation.id == menu.laststartedactionoperation then
								menu.selectedRows.actiontable = row.index
								menu.laststartedactionoperation = nil
							end

							row[1]:setBackgroundColSpan(6):setColSpan(3):createText(operation.agentname, { x = Helper.standardIndentStep, color = color })
							row[4]:createText(function () return menu.getAgentStatus(operation.agentindex) end, { halign = "right", color = color })
							row[5]:createText(ispastoperation and ReadText(1001, 12840) or function () return menu.actionOperationTime(operation.endtime) end, { halign = "right", color = color })
							row[6]:createIcon("widget_arrow_right_01", { height = Helper.standardTextHeight, color = color })
						end
					end
				end
			end
		end
	end

	if menu.topRows.actiontable then
		menu.actiontable:setTopRow(menu.topRows.actiontable)
	end
	if menu.selectedRows.actiontable then
		menu.actiontable:setSelectedRow(menu.selectedRows.actiontable)
	end
	if menu.selectedCols.actiontable then
		menu.actiontable:setSelectedCol(menu.selectedCols.actiontable)
	end

	menu.actiontable:addConnection(2, 2)
end

function menu.createAgents(frame, tableProperties)
	local actioniconheight = config.factionIconHeight
	local actioniconoffset = 2

	-- agents
	menu.agenttable = frame:addTable(2, { tabOrder = 1, width = menu.narrowtablewidth, x = tableProperties.x, y = tableProperties.y })

	local numagentslots = C.GetAgentMaxSlotCount()

	-- title
	local row = menu.agenttable:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
	row[1]:setColSpan(2):createText(ReadText(1001, 12817), Helper.titleTextProperties)
	row[1].properties.height = row[1].properties.height + Helper.borderSize

	for i = 1, numagentslots do
		if menu.agents[i] then
			local agent = menu.agents[i]

			local isselected = false
			if (menu.contextMenuMode == "agentdetails") and (i == menu.contextMenuData.id) then
				isselected = true
			end

			local row = menu.agenttable:addRow({ type = "agent", id = i }, { bgColor = isselected and Color["row_background_selected"] or Color["row_background_blue"] })
			row[1]:setBackgroundColSpan(2):createIcon(agent.icon, {
				width = actioniconheight,
				height = actioniconheight,
			}):setText("\27[" .. agent.rankicon .. "] " .. agent.name, {
				font = Helper.standardFontBold,
				fontsize = Helper.headerRow1FontSize,
				x = actioniconheight + Helper.standardTextOffsetx,
				y = actioniconoffset,
			}):setText2(function () return menu.getAgentShip(i) end, {
				x = actioniconheight + Helper.standardTextOffsetx,
				y = actioniconheight / 2 + actioniconoffset,
			})
			row[2]:createText(function () return menu.getAgentStatus(i) end, { halign = "right", y = actioniconoffset, font = Helper.standardFontBold, fontsize = Helper.headerRow1FontSize })
		else
			local researchware = ffi.string(C.GetAgentSlotResearchWare(i))
			local hasresearch = (researchware == "") or C.HasResearched(researchware)

			local row = menu.agenttable:addRow(true, { bgColor = Color["row_background_blue"] })
			row[1]:setBackgroundColSpan(2):createIcon(hasresearch and "diplomacy_agent_vacant_portrait" or "diplomacy_agent_locked_portrait", {
				width = actioniconheight,
				height = actioniconheight,
			}):setText(hasresearch and ("\27[diplomacy_agent_vacant] " .. ReadText(1001, 12812)) or ("\27[diplomacy_agent_locked] " .. ReadText(1001, 12911)), {
				font = Helper.standardFontBold,
				fontsize = Helper.headerRow1FontSize,
				x = actioniconheight + Helper.standardTextOffsetx,
				y = actioniconheight / 4,
			})
		end
	end

	if menu.topRows.agenttable then
		menu.agenttable:setTopRow(menu.topRows.agenttable)
	end
	if menu.selectedRows.agenttable then
		menu.agenttable:setSelectedRow(menu.selectedRows.agenttable)
	end
	if menu.selectedCols.agenttable then
		menu.agenttable:setSelectedCol(menu.selectedCols.agenttable)
	end

	menu.agenttable:addConnection(2, 2)
end

function menu.getAgentStatus(agentindex, notimer)
	local agent = menu.agents[agentindex]
	if agent then
		local curgametime = C.GetCurrentGameTime()
		if agent.isbusy then
			if agent.isbusy.actionoperation then
				local actionoperation = menu.actionoperationsByID[tostring(agent.isbusy.actionoperation)]
				if not actionoperation.isarchive then
					return ReadText(1001, 12909)
				end
			elseif agent.isbusy.eventoperation and agent.isbusy.optionselected then
				local eventoperation = menu.eventoperationsByID[tostring(agent.isbusy.eventoperation)]
				if (not eventoperation.isarchive) then
					return ReadText(1001, 12910)
				end
			end
		elseif (agent.injuryendtime > 0) and (agent.injuryendtime >= curgametime) then
			local timeleft = agent.injuryendtime - C.GetCurrentGameTime()
			return ReadText(1001, 12916) .. ((not notimer) and (" (" .. ConvertTimeString(timeleft, (timeleft < 3600) and ReadText(1001, 209) or ReadText(1001, 207))  .. ")") or "")
		elseif agent.ship == 0 then
			return ColorText["text_error"] .. ReadText(1001, 12917) .. "\27X"
		end
	end
	return ReadText(1001, 12908)
end

function menu.getAgentShip(agentindex)
	local agent = menu.agents[agentindex]
	if agent then
		local shiptext = ReadText(1001, 12919)
		if agent.ship ~= 0 then
			shiptext = "\27[" .. GetComponentData(ConvertStringToLuaID(tostring(agent.ship)), "icon") .. "] " .. ffi.string(C.GetComponentName(agent.ship)) .. " (" .. ffi.string(C.GetObjectIDCode(agent.ship)) .. ")"
		end
		return shiptext
	end
	return ""
end

function menu.actionOperationTime(endtime)
	local remainingtime = endtime - C.GetCurrentGameTime()
	if remainingtime <= 0 then
		menu.getData()
		menu.refresh = menu.refresh or getElapsedTime()
		if menu.contextMenuMode == "actionconfig" then
			menu.refreshContextFrame()
		end
		return ReadText(1001, 12840)
	else
		return ConvertTimeString(remainingtime, (remainingtime < 3600) and ReadText(1001, 209) or ReadText(1001, 207))
	end
end

function menu.createFactionDetailsContext(frame)
	Helper.clearTableConnectionColumn(menu, 3)

	local relation = menu.factionData.curEntry

	if next(relation) then
		AddUITriggeredEvent(menu.name, menu.mode, relation.id)

		local relationlockreason, willclaimspace, policefaction, factioncolor = GetFactionData(relation.id, "relationlockreason", "willclaimspace", "policefaction", "color")
		local infoentry = GetLibraryEntry("factions", relation.id)

		local height = math.ceil(menu.factionConfig.width / config.factions.bannerAspectRatio)
		local bannertable = frame:addTable(4, { tabOrder = 3, width = menu.factionConfig.width, y = 0, backgroundID = infoentry.banner, backgroundPadding = 0 })
		bannertable:setColWidth(1, Helper.standardContainerOffset)
		bannertable:setColWidth(2, height, false)
		bannertable:setColWidthPercent(4, 5)

		local firstemptyrow = bannertable:addEmptyRow(1, false)

		local factioniconheight = 0.9 * height
		local iconoffsetx = 0.05 * height

		local row = bannertable:addRow(true, { fixed = true, bgColor = Color["frame_background_semitransparent"] })
		row[1]:setBackgroundColSpan(4):createIcon("solid", { scaling = false, height = height, color = factioncolor, affectRowHeight = false })
		row[2]:createIcon(relation.icon, { scaling = false, width = factioniconheight, height = factioniconheight, x = iconoffsetx, affectRowHeight = false })
		row[3]:createText("[" .. relation.shortname .. "] - " .. relation.name, { font = Helper.standardFontBold, fontsize = Helper.largeIconFontSize })
		local textheight = row[3]:getHeight()
		local buttoniconsize = Helper.scaleY(Helper.largeRowHeight)
		row[4]:createButton({ scaling = false, height = height, y = -height / 2 + textheight / 2, affectRowHeight = false, bgColor = Color["button_background_solid"], mouseOverText = ReadText(1026, 12802) }):setIcon("menu_encyclopedia", { scaling = false, width = buttoniconsize, height = buttoniconsize, x = 0.025 * menu.factionConfig.width - buttoniconsize / 2, y = height / 2 - buttoniconsize / 2 })
		row[4].handlers.onClick = function () return menu.buttonShowEncyclopedia("Factions", "factions", relation.id) end

		firstemptyrow[1].properties.minRowHeight = height / 2 - textheight / 2 - Helper.borderSize
		bannertable:addEmptyRow(height - bannertable:getFullHeight() - Helper.borderSize, false)

		local yoffset = bannertable.properties.y + bannertable:getFullHeight() + Helper.borderSize + 2 * Helper.standardContainerOffset
		local descwidth = menu.factionConfig.width / 2 - 3 * Helper.standardContainerOffset
		local desctable = frame:addTable(1, { tabOrder = 4, width = descwidth, x = 2 * Helper.standardContainerOffset, y = yoffset, highlightMode = "off" })
		local datatable = frame:addTable(3, { tabOrder = 5, width = descwidth, x = menu.factionConfig.width / 2 + Helper.standardContainerOffset, y = yoffset, defaultInteractiveObject = active })
		datatable:setDefaultBackgroundColSpan(1, 3)
		datatable:setColWidth(3, Helper.scaleY(Helper.standardTextHeight) + Helper.standardContainerOffset, false)

		-- desc
		desctable:addEmptyRow(2 * Helper.standardContainerOffset, false, Color["row_background_container"], false)
		local hasdescscrollbar = false
		local row = desctable:addRow(nil, { fixed = true, bgColor = Color["row_background_container"], borderBelow = false })
		row[1]:createText(ReadText(1001, 2404), Helper.subHeaderTextProperties)
		row[1].properties.cellBGColor = Color["row_background_container"]

		local row = desctable:addRow(nil, { fixed = true, bgColor = Color["row_background_container"], borderBelow = false })
		row[1]:createText(" ", { scaling = false, fontsize = 1, height = Helper.standardContainerOffset })

		local descwidth = descwidth - 2 * Helper.scaleX(Helper.standardTextOffsetx)
		local description = GetTextLines(infoentry.description, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), descwidth)
		if #description > config.factions.numDescLines then
			-- scrollbar case
			description = GetTextLines(infoentry.description, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), descwidth - Helper.scrollbarWidth)
			hasdescscrollbar = true
		end

		local descriptionheight
		for linenum, descline in ipairs(description) do
			local row = desctable:addRow(true, { bgColor = Color["row_background_container"], borderBelow = false })
			row[1]:createText(descline)
			if linenum == config.factions.numDescLines then
				descriptionheight = desctable:getFullHeight()
			end
		end
		desctable.properties.maxVisibleHeight = descriptionheight

		-- details
		datatable:addEmptyRow(2 * Helper.standardContainerOffset, false, Color["row_background_container"], false)
		local row = datatable:addRow(nil, { bgColor = Color["row_background_container"], borderBelow = false })
		row[1]:setColSpan(3):createText(ReadText(1001, 2961), Helper.subHeaderTextProperties)
		row[1].properties.cellBGColor = Color["row_background_container"]
		datatable:addEmptyRow(Helper.standardContainerOffset, false, Color["row_background_container"], false)

		-- hq location
		local hqlist = {}
		Helper.ffiVLA(hqlist, "UniverseID", C.GetNumHQs, C.GetHQs, relation.id)
		-- each faction is only supposed to have one HQ, the player included. if a faction is modded to have more, only print the first one.
		local printedhqlocation = ReadText(1001, 9002)		-- Unknown
		local hq
		if #hqlist > 0 then
			hq = ConvertStringToLuaID(tostring(hqlist[1]))
			printedhqlocation = ffi.string(C.GetComponentName(ConvertIDTo64Bit(GetComponentData(hq, "sectorid" ))))
		end
		local row = datatable:addRow(true, { fixed = true, bgColor = Color["row_background_container"], borderBelow = false })
		row[1]:createText(ReadText(1001, 9600))
		row[2]:createText(printedhqlocation, { halign = "right" })
		local hqbuttonactive = (hq ~= nil) and C.IsKnownToPlayer(hqlist[1]) and C.IsStoryFeatureUnlocked("x4ep1_map")
		row[3]:createButton({ width = Helper.standardTextHeight, height = Helper.standardTextHeight, active = hqbuttonactive, mouseOverText = ReadText(1001, 3408) }):setIcon("mapob_poi")
		row[3].handlers.onClick = function () return menu.buttonShowObjectOnMap(hq) end
		-- representative
		local factionrep = ConvertStringTo64Bit(tostring(C.GetFactionRepresentative(relation.id)))
		local printedtitle = ((factionrep ~= 0) and GetComponentData(factionrep, "isfemale") and ReadText(20208, 10602)) or ReadText(20208, 10601)	-- Faction Representative(female), Faction Representative(male)
		local printedname = ReadText(1001, 9002)		-- Unknown
		if factionrep ~= 0 then
			printedname = ffi.string(C.GetComponentName(factionrep))
		end
		local row = datatable:addRow(nil, { bgColor = Color["row_background_container"], borderBelow = false })
		row[1]:createText(printedtitle)
		row[2]:setColSpan(2):createText(printedname, { halign = "right" })
		-- diplomat
		if relation.isdiplomacyactive then
			local diplomatname = ReadText(1001, 12812)
			local mouseovertext
			if not relation.isatdockrelation then
				diplomatname = ReadText(1001, 12813)
				mouseovertext = ReadText(1026, 12801)
			else
				local diplomat = C.GetPlayerRepresentative(relation.id)
				if diplomat ~= 0 then
					diplomatname = ffi.string(C.GetComponentName(diplomat))
				end
			end
			local row = datatable:addRow(nil, { bgColor = Color["row_background_container"], borderBelow = false })
			row[1]:createText(ReadText(1001, 12874))
			row[2]:setColSpan(2):createText(diplomatname, { halign = "right", mouseOverText = mouseovertext })
		end
		-- police authority
		local printedpolicename = ReadText(1001, 9002)		-- Unknown
		if policefaction then
			printedpolicename = GetFactionData(policefaction, "name")
		end
		local row = datatable:addRow(nil, { bgColor = Color["row_background_container"], borderBelow = false })
		row[1]:createText(ReadText(1001, 9601))
		row[2]:setColSpan(2):createText(printedpolicename, { halign = "right" })
		-- relation
		local relationtext = function () local relationinfo = C.GetUIRelationName("player", relation.id); return ColorText[ffi.string(relationinfo.colorid)] .. ffi.string(relationinfo.name) .. " (" .. string.format("%+d", GetUIRelation(relation.id)) .. ")" end
		if relation.isrelationlocked then
			if GetUIRelation(relation.id) <= -25 then
				relationtext = ReadText(20229, 201)
			else
				relationtext = (relation.relationlockshortreason ~= "") and relation.relationlockshortreason or ReadText(20229, 101)
			end
		end
		local row = datatable:addRow(nil, { bgColor = Color["row_background_container"], borderBelow = false })
		row[1]:createText(ReadText(1001, 7749))
		row[2]:setColSpan(2):createText(relationtext, { halign = "right" })
		-- sector ownership
		datatable:addEmptyRow(Helper.borderSize, false, Color["row_background_container"], false)
		local row = datatable:addRow(nil, { bgColor = Color["row_background_container"], borderBelow = false })
		row[1]:setColSpan(3):createText(willclaimspace and ReadText(1001, 12806) or ReadText(1001, 12807), { wordwrap = true })
		local dataheight = datatable:getFullHeight()
		local descheight = desctable:getVisibleHeight()
		datatable:addEmptyRow(math.max(1, descheight - dataheight), false, Color["row_background_container"], false)

		local heightafterfirstsection = math.max(descheight, datatable:getFullHeight())

		local detailtable = frame:addTable(7, { tabOrder = 6, width = menu.factionConfig.width - 4 * Helper.standardContainerOffset, x = 2 * Helper.standardContainerOffset, y = datatable.properties.y + heightafterfirstsection + 2 * Helper.standardContainerOffset })
		detailtable:setColWidth(1, Helper.largeRowHeight)
		detailtable:setColWidth(2, 0.25 * menu.factionConfig.width - Helper.scaleY(Helper.standardTextHeight), false)
		detailtable:setColWidthPercent(3, 25)
		detailtable:setColWidthPercent(4, 25)
		detailtable:setColWidth(6, Helper.largeRowHeight)
		detailtable:setColWidth(7, Helper.largeRowHeight)

		local bottomtable = frame:addTable(3, { tabOrder = 7, width = menu.factionConfig.width - 4 * Helper.standardContainerOffset, x = 2 * Helper.standardContainerOffset, y = detailtable.properties.y })
		bottomtable:setColWidthPercent(2, 40)
		bottomtable:setColWidthPercent(3, 40)

		-- button
		local row = bottomtable:addRow(true, { fixed = true })
		row[3]:createButton({  }):setText(ReadText(1001, 2670), { halign = "center" })
		row[3].handlers.onClick = menu.closeContextMenu

		local bottomtableheight = bottomtable:getFullHeight()
		bottomtable.properties.y = menu.factionConfig.height - bottomtableheight - Helper.standardContainerOffset
		local maxalloweddetailheight = bottomtable.properties.y - detailtable.properties.y - 2 * Helper.standardContainerOffset

		-- tabs
		local row = detailtable:addRow(true, { fixed = true, borderBelow = false })
		row[1]:setColSpan(2):createButton({ bgColor = (menu.factionData.curTab == "licence") and Color["row_background_selected"] or Color["row_background_blue"] }):setText(ReadText(1001, 62), { halign = "center" })
		row[1].handlers.onClick = function () menu.factionData.curTab = "licence"; menu.refreshContextFrame() end
		row[3]:createButton({ bgColor = (menu.factionData.curTab == "relations") and Color["row_background_selected"] or Color["row_background_blue"] }):setText(ReadText(1001, 9928), { halign = "center" })
		row[3].handlers.onClick = function () menu.factionData.curTab = "relations"; menu.refreshContextFrame() end
		row[4]:createButton({ bgColor = (menu.factionData.curTab == "known") and Color["row_background_selected"] or Color["row_background_blue"] }):setText(ReadText(1001, 2459), { halign = "center" })
		row[4].handlers.onClick = function () menu.factionData.curTab = "known"; menu.refreshContextFrame() end
		row[5]:setColSpan(3):createButton({ bgColor = (menu.factionData.curTab == "implications") and Color["row_background_selected"] or Color["row_background_blue"] }):setText(ReadText(1001, 12890), { halign = "center" })
		row[5].handlers.onClick = function () menu.factionData.curTab = "implications"; menu.refreshContextFrame() end

		local row = detailtable:addRow(nil, { fixed = true, bgColor = Color["row_background_selected"] })
		row[1]:setColSpan(7):createText(" ", { scaling = false, fontsize = 1, height = Helper.borderSize })

		local row = detailtable:addRow(nil, { fixed = true, borderBelow = false })
		row[1]:setColSpan(7):createText(" ", { scaling = false, fontsize = 1, height = Helper.standardContainerOffset })

		if menu.factionData.curTab == "licence" then
			-- licences
			if menu.licences[relation.id] and #menu.licences[relation.id] > 0 then
				local prevminrelation
				local firstbasic = true
				for i, licence in ipairs(menu.licences[relation.id]) do
					if prevminrelation and (not licence.precursor) and (licence.minrelation > prevminrelation) then
						detailtable:addEmptyRow(Helper.standardContainerOffset - Helper.borderSize, false, nil, false)
						prevminrelation = licence.minrelation
					end
					if prevminrelation == nil then
						prevminrelation = licence.minrelation
					end

					local info
					if licence.price > 0 then
						info = ConvertMoneyString(licence.price, false, true, 0, true) .. " " .. ReadText(1001, 101)
					elseif not licence.precursor then
						local relationinfo = C.GetRelationRangeInfo(licence.minrelation)
						info = ffi.string(relationinfo.name) .. " (" .. string.format("%+d", licence.minrelation) .. ")"
					end

					local color = Color["text_inactive"]
					local prefixicon = ColorText["text_negative"] .. "\27[diplomacy_license_negative]\27X "
					if HasLicence("player", licence.type, relation.id) then
						color = Color["text_normal"]
						prefixicon = ColorText["text_positive"] .. "\27[diplomacy_license_positive]\27X "
					end

					if licence.isbasic then
						if firstbasic then
							firstbasic = false
							local row = detailtable:addRow(true, { bgColor = Color["row_background_container2"] })
							row[1]:setBackgroundColSpan(7):setColSpan(3):createText(prefixicon .. ReadText(1001, 12808), {
								font = Helper.standardFontBold,
								fontsize = Helper.headerRow1FontSize,
								y = Helper.largeRowOffsety,
								minRowHeight = Helper.largeRowHeight,
								helpOverlayID = "diplomacy_factionlicense_basic",
								helpOverlayText = " ",
								helpOverlayHighlightOnly = true,
								helpOverlayUseBackgroundSpan = true,
							})
							row[4]:setColSpan(3):createText(info, {
								halign = "right",
								font = Helper.standardFontBold,
								fontsize = Helper.headerRow1FontSize,
								y = Helper.largeRowOffsety,
								color = color,
							})
						end
					else
						firstbasic = true
					end

					local sublicence = licence.precursor or licence.isbasic
					local row = detailtable:addRow({ "licence", licence.id }, { bgColor = sublicence and Color["row_background_container"] or Color["row_background_container2"] })
					local name = licence.name
					if sublicence then
						name = "    " .. name
					end
					row[1]:setBackgroundColSpan(7):setColSpan(3):createText((sublicence and "" or prefixicon) .. name, {
						font = sublicence and Helper.standardFont or Helper.standardFontBold,
						fontsize = Helper.headerRow1FontSize,
						y = Helper.largeRowOffsety,
						minRowHeight = Helper.largeRowHeight,
						color = (not sublicence) and Color["text_normal"] or color,
						mouseOverText = licence.desc,
						helpOverlayID = "diplomacy_factionlicense_" .. licence.id,
						helpOverlayText = " ",
						helpOverlayHighlightOnly = true,
						helpOverlayUseBackgroundSpan = true,
					})
					if (not sublicence) or (licence.price > 0) then
						row[4]:setColSpan(3):createText(info, {
							halign = "right",
							font = sublicence and Helper.standardFont or Helper.standardFontBold,
							fontsize = Helper.headerRow1FontSize,
							y = Helper.largeRowOffsety,
							color = color,
						})
					end
					row[7]:createButton({ height = Helper.largeRowHeight, mouseOverText = ReadText(1026, 12802) }):setIcon("menu_encyclopedia")
					row[7].handlers.onClick = function () return menu.buttonShowEncyclopedia("Licences", "licences", licence.id, relation.id) end
					AddKnownItem("licences", licence.id)
				end
			else
				detailtable:addEmptyRow((maxalloweddetailheight - detailtable:getFullHeight() - Helper.scaleY(Helper.largeRowHeight)) / 2, false)
				local row = detailtable:addRow(nil, { fixed = true, borderBelow = false })
				row[1]:setColSpan(7):createText(ReadText(1001, 12905), { halign = "center", fontsize = Helper.headerRow1FontSize, y = Helper.largeRowOffsety, minRowHeight = Helper.largeRowHeight })
			end
		elseif menu.factionData.curTab == "relations" then
			-- relations
			local relations = {}
			for _, range in ipairs(config.factions.relationCategories) do
				relations[range] = {}
			end

			for _, otherrelation in ipairs(menu.relations) do
				if relation.id ~= otherrelation.id then
					for _, range in ipairs(config.factions.relationCategories) do
						if range == "hostile" then
							if C.IsFactionHostileToFaction(relation.id, otherrelation.id) then
								table.insert(relations[range], { id = otherrelation.id, name = GetFactionData(otherrelation.id, "name") })
								break
							end
						elseif C.IsFactionInRelationRangeToFaction(relation.id, otherrelation.id, range) then
							if range == "member" then
								table.insert(relations["ally"], { id = otherrelation.id, name = GetFactionData(otherrelation.id, "name") })
							else
								table.insert(relations[range], { id = otherrelation.id, name = GetFactionData(otherrelation.id, "name") })
							end
							break
						end
					end
				end
			end
			for _, range in ipairs(config.factions.relationCategories) do
				table.sort(relations[range], Helper.sortName)
			end

			for j, displayentry in ipairs(config.factions.relationDisplayOrder) do
				if j > 1 then
					detailtable:addEmptyRow(Helper.standardContainerOffset - Helper.borderSize, false, nil, false)
				end
				local row = detailtable:addRow(true, { bgColor = Color["row_background_container2"] })
				row[1]:setColSpan(7):createText(displayentry.name, { font = Helper.standardFontBold, fontsize = Helper.headerRow1FontSize, y = Helper.largeRowOffsety, minRowHeight = Helper.largeRowHeight, mouseOverText = displayentry.mouseovertext, color = displayentry.color })
				if #relations[displayentry.range] > 0 then
					for i, entry in ipairs(relations[displayentry.range]) do
						local icon, shortname = GetFactionData(entry.id, "icon", "shortname")
						local row = detailtable:addRow(true, { bgColor = Color["row_background_container"] })
						row[1]:setColSpan(6):createText("    \27[" .. icon .. "] [" .. shortname .. "] - " .. entry.name, { fontsize = Helper.headerRow1FontSize, y = Helper.largeRowOffsety, minRowHeight = Helper.largeRowHeight })
						row[7]:createButton({ height = Helper.largeRowHeight, mouseOverText = ReadText(1026, 12803) }):setIcon("diplomacy_faction")
						row[7].handlers.onClick = function () return menu.buttonSelectFaction(entry.id) end
					end
				else
					local row = detailtable:addRow(true, { bgColor = Color["row_background_container"] })
					row[1]:setColSpan(7):createText("    " .. ReadText(1001, 38), { fontsize = Helper.headerRow1FontSize, y = Helper.largeRowOffsety, minRowHeight = Helper.largeRowHeight, color = Color["text_inactive"] })
				end
			end
		elseif menu.factionData.curTab == "known" then
			local iconheight = config.factionIconHeight
			local iconoffset = 2

			local canopenmap = C.IsStoryFeatureUnlocked("x4ep1_map")

			local sectors = {}
			Helper.ffiVLA(sectors, "UniverseID", C.GetNumSectorsByOwner, C.GetSectorsByOwner, relation.id)
			for i = #sectors, 1, -1 do
				if not C.IsKnownToPlayer(sectors[i]) then
					table.remove(sectors, i)
				else
					local stations = GetContainedStationsByOwner(relation.id, ConvertStringToLuaID(tostring(sectors[i])))
					sectors[i] = { id = sectors[i], name = ffi.string(C.GetComponentName(sectors[i])), stations = stations }
				end
			end
			table.sort(sectors, Helper.sortName)
			if #sectors > 0 then
				for i, sector in ipairs(sectors) do
					if i > 1 then
						detailtable:addEmptyRow(Helper.standardContainerOffset - Helper.borderSize, false, nil, false)
					end
					local row = detailtable:addRow(true, { bgColor = Color["row_background_container2"] })
					local stations = {
						shipyards = {},
						wharfs = {},
						equipmentdocks = {},
						tradestations = {},
						defencestations = {},
						factories = {},
					}
					for _, station in ipairs(sector.stations) do
						if C.IsKnownToPlayer(C.ConvertStringTo64Bit(tostring(station))) then
							local isshipyard, iswharf, isequipmentdock, istradestation, isdefencestation = GetComponentData(station, "isshipyard", "iswharf", "isequipmentdock", "istradestation", "isdefencestation")
							if isshipyard then
								table.insert(stations.shipyards, station)
							elseif iswharf then
								table.insert(stations.wharfs, station)
							elseif isequipmentdock then
								table.insert(stations.equipmentdocks, station)
							elseif istradestation then
								table.insert(stations.tradestations, station)
							elseif isdefencestation then
								table.insert(stations.defencestations, station)
							else
								table.insert(stations.factories, station)
							end
						end
					end
					local stationstring = ""
					local first = true
					for _, entry in ipairs(config.factions.stations) do
						if #stations[entry.id] > 0 then
							if first then
								first = false
							else
								stationstring = stationstring .. ", "
							end
							if #stations[entry.id] == 1 then
								stationstring = stationstring .. "1 " .. entry.singlename
							else
								stationstring = stationstring .. #stations[entry.id] .. " " .. entry.name
							end
						end
					end
					local expandID = tostring(sector.id)
					local isexpanded = menu.expanded[expandID]
					row[1]:setBackgroundColSpan(7):createButton({ height = iconheight }):setText(isexpanded and "-" or "+", { halign = "center" })
					row[1].handlers.onClick = function () return menu.buttonExpand(expandID) end
					local sectorname = sector.name
					if C.IsContestedSector(sector.id) then
						sectorname = sectorname .. " " .. ReadText(1001, 3247)
					end
					row[2]:setColSpan(4):createIcon("solid", {
						color = Color["icon_hidden"],
						height = iconheight,
					}):setText(sectorname, {
						font = Helper.standardFontBold,
						fontsize = Helper.headerRow1FontSize,
						x = Helper.standardTextOffsetx,
						y = iconoffset,
					}):setText2(stationstring, {
						x = Helper.standardTextOffsetx,
						y = iconheight / 2 + iconoffset,
					})
					row[6]:createButton({ height = iconheight, mouseOverText = ReadText(1026, 12802) }):setIcon("menu_encyclopedia", { width = Helper.largeRowHeight, height = Helper.largeRowHeight, y = (iconheight - Helper.largeRowHeight) / 2 })
					row[6].handlers.onClick = function () return menu.buttonShowEncyclopedia("Galaxy", "", nil, ConvertStringToLuaID(tostring(sector.id))) end
					row[7]:createButton({ height = iconheight, mouseOverText = ReadText(1001, 3408), active = canopenmap }):setIcon("mapob_poi", { width = Helper.standardTextHeight, height = Helper.standardTextHeight, x = (Helper.largeRowHeight - Helper.standardTextHeight) / 2, y = (iconheight - Helper.standardTextHeight) / 2 })
					row[7].handlers.onClick = function () return menu.buttonShowObjectOnMap(ConvertStringToLuaID(tostring(sector.id)), false) end

					if isexpanded then
						for _, entry in ipairs(config.factions.stations) do
							if #stations[entry.id] > 0 then
								local indent = ""
								local isexpanded = true
								if entry.id == "factories" then
									indent = "    "
									isexpanded = menu.expanded[expandID .. "-factories"]
									local row = detailtable:addRow(true, { bgColor = Color["row_background_container"] })
									row[1]:setBackgroundColSpan(6):createButton({ height = Helper.largeRowHeight }):setText(isexpanded and "-" or "+", { halign = "center" })
									row[1].handlers.onClick = function () return menu.buttonExpand(expandID .. "-factories") end
									row[2]:setColSpan(6):createText(indent .. ReadText(1001, 12889) .. " [" .. #stations[entry.id] .. "]", { fontsize = Helper.headerRow1FontSize, y = Helper.largeRowOffsety, minRowHeight = Helper.largeRowHeight })
								end
								if isexpanded then
									for _, station in ipairs(stations[entry.id]) do
										local row = detailtable:addRow(true, { bgColor = Color["row_background_container"] })
										row[1]:setBackgroundColSpan(6)
										local name, icon = GetComponentData(station, "name", "icon")
										local factioncolortext = Helper.convertColorToText(factioncolor)
										row[2]:setColSpan(5):createText(indent .. factioncolortext .. "\27[" .. icon .. "]\27X " .. name .. " (" .. ffi.string(C.GetObjectIDCode(C.ConvertStringTo64Bit(tostring(station)))) .. ")", { fontsize = Helper.headerRow1FontSize, y = Helper.largeRowOffsety, minRowHeight = Helper.largeRowHeight })
										row[7]:createButton({ height = Helper.largeRowHeight, mouseOverText = ReadText(1001, 3408), active = canopenmap }):setIcon("mapob_poi", { width = Helper.standardTextHeight, height = Helper.standardTextHeight, x = (Helper.largeRowHeight - Helper.standardTextHeight) / 2, y = (Helper.largeRowHeight - Helper.standardTextHeight) / 2 })
										row[7].handlers.onClick = function () return menu.buttonShowObjectOnMap(station) end
									end
								end
							end
						end
					end
				end
			else
				detailtable:addEmptyRow((maxalloweddetailheight - detailtable:getFullHeight() - Helper.scaleY(Helper.largeRowHeight)) / 2, false)
				local row = detailtable:addRow(nil, { fixed = true, borderBelow = false })
				row[1]:setColSpan(7):createText(ReadText(1001, 12906), { halign = "center", fontsize = Helper.headerRow1FontSize, y = Helper.largeRowOffsety, minRowHeight = Helper.largeRowHeight })
			end
		elseif menu.factionData.curTab == "implications" then
			local n = C.GetNumFactionRelationImplications(relation.id)
			if n > 0 then
				local implications = {}
				local buf = ffi.new("RelationImplication[?]", n)
				n = C.GenerateFactionRelationImplications(buf, n, relation.id)
				for i = 0, n - 1 do
					table.insert(implications, { text = ffi.string(buf[i].text), relationcondition = buf[i].relationcondition, positive = buf[i].positive })
				end

				local firstrowtext
				for i, entry in ipairs(implications) do
					local row = detailtable:addRow(true, { bgColor = Color["row_background_container"] })
					row[2]:setColSpan(3):createText(entry.text, {
						fontsize = Helper.headerRow1FontSize,
						y = Helper.largeRowOffsety,
						minRowHeight = Helper.largeRowHeight,
						wordwrap = true
					})
					local iconsize = Helper.scaleY(Helper.largeRowHeight)
					row[1]:setBackgroundColSpan(7):createIcon(entry.positive and "widget_tick_01" or "widget_cross_01", { scaling = false, width = iconsize, height = iconsize, y = 0, color = entry.positive and Color["icon_positive"] or Color["icon_negative"] })
					local relationinfo = C.GetRelationRangeInfo(entry.relationcondition)
					row[5]:setColSpan(3):createText(ffi.string(relationinfo.name) .. " (" .. string.format("%+d", entry.relationcondition) .. ")", { halign = "right", fontsize = Helper.headerRow1FontSize, y = Helper.largeRowOffsety, minRowHeight = Helper.largeRowHeight, color = entry.positive and Color["text_normal"] or Color["text_inactive"] })
					if i == 1 then
						firstrowtext = row[2]
						firstrowtext.properties.helpOverlayID = "diplomacy_faction_relation"
						firstrowtext.properties.helpOverlayText = " "
						firstrowtext.properties.helpOverlayHighlightOnly = true
						firstrowtext.properties.helpOverlayHeight = row:getHeight()
						firstrowtext.properties.helpOverlayScaling = false
					else
						firstrowtext.properties.helpOverlayHeight = firstrowtext.properties.helpOverlayHeight + row:getHeight() + Helper.borderSize
					end
				end
			end
		end

		detailtable.properties.maxVisibleHeight = math.min(detailtable:getFullHeight(), maxalloweddetailheight)

		desctable:addConnection(1, 3, true)
		bannertable:addConnection(1, 4, true)
		if hqbuttonactive then
			datatable:addConnection(2, 4)
		end
		detailtable:addConnection(3, 4)
		bottomtable:addConnection(4, 4)
	end
end

function menu.createAgentDetailsContext(frame)
	Helper.clearTableConnectionColumn(menu, 3)
	Helper.clearTableConnectionColumn(menu, 4)

	local iconheight = Helper.scaleY(5.5 * Helper.standardTextHeight) + 5 * Helper.borderSize

	local agentdetailstable = frame:addTable(4, { tabOrder = 10, width = menu.narrowtablewidth, x = 0, y = 0 })
	agentdetailstable:setColWidth(1, iconheight, false)
	agentdetailstable:setColWidth(4, Helper.standardButtonHeight)

	local row = agentdetailstable:addRow(nil, {  })
	row[1]:setColSpan(4):createText(ReadText(1001, 12818), Helper.headerRowCenteredProperties)

	local agent = menu.agents[menu.contextMenuData.id]

	local row = agentdetailstable:addRow(nil, {  })
	row[1]:createIcon(agent.icon, { scaling = false, height = iconheight, y = (iconheight - Helper.scaleY(Helper.standardTextHeight)) / 2, affectRowHeight = false })
	row[2]:createText(ReadText(1001, 2809))
	row[3]:setColSpan(2):createText(agent.name, { halign = "right" })

	local row = agentdetailstable:addRow(nil, {  })
	row[2]:createText(ReadText(1001, 12819))
	row[3]:setColSpan(2):createText("\27[" .. agent.rankicon .. "] " .. agent.rankname, { halign = "right" })

	local row = agentdetailstable:addRow(nil, {  })
	row[2]:createText(ReadText(1001, 12822))
	row[3]:setColSpan(2):createText(function () return menu.getAgentStatus(menu.contextMenuData.id) end, { halign = "right" })

	agentdetailstable:addEmptyRow(Helper.standardTextHeight / 2)

	local row = agentdetailstable:addRow(nil, {  })
	row[2]:createText(ReadText(1001, 12820), {  })
	row[3]:setColSpan(2):createText(agent.exp_negotiation_name, { halign = "right" })

	local row = agentdetailstable:addRow(nil, {  })
	row[2]:createText(ReadText(1001, 12821), {  })
	row[3]:setColSpan(2):createText(agent.exp_espionage_name, { halign = "right" })
	
	agentdetailstable:addEmptyRow(Helper.standardTextHeight / 2)
	
	local row = agentdetailstable:addRow(nil, {  })
	row[1]:setColSpan(4):createText(ReadText(1001, 12918), Helper.headerRow1Properties)
	
	local row = agentdetailstable:addRow(nil, {  })
	row[1]:setColSpan(4):createText(ReadText(1001, 12922), { wordwrap = true })

	local playeroccupiedship = C.GetPlayerOccupiedShipID()
	local stationhqlist = {}
	Helper.ffiVLA(stationhqlist, "UniverseID", C.GetNumHQs, C.GetHQs, "player")
	local hq = stationhqlist[1] or 0
	local dockedships = {}
	Helper.ffiVLA(dockedships, "UniverseID", C.GetNumDockedShips, C.GetDockedShips, hq, "player")
	local shiplist = {}
	for _, dockedship in ipairs(dockedships) do
		if (dockedship ~= playeroccupiedship) and (C.IsComponentClass(dockedship, "ship_m") or C.IsComponentClass(dockedship, "ship_s")) then
			local name, icon, idcode, prestigename = GetComponentData(ConvertStringToLuaID(tostring(dockedship)), "name", "icon", "idcode", "prestigename")
			table.insert(shiplist, {
				id = dockedship,
				name = name .. " (" .. idcode .. ")",
				icon = icon,
				prestige = prestigename,
			})
		end
	end
	table.sort(shiplist, Helper.sortName)

	local shipoptions = {}
	for _, entry in ipairs(shiplist) do
		local travelspeedtext = ConvertIntegerString(Helper.round(C.GetDefensibleSpeeds(entry.id).travelspeed), true, 0, true) .. " " .. ReadText(1001, 113)
		local dpstext = "0" .. " " .. ReadText(1001, 119)
		local sustainedfwddps = ffi.new("DPSData[?]", 1)
		C.GetDefensibleDPS(sustainedfwddps, entry.id, true, true, true, true, false, true, false)
		if sustainedfwddps[0].dps > 0 then
			dpstext = ConvertIntegerString(sustainedfwddps[0].dps, true, 0, true) .. " " .. ReadText(1001, 119)
		end
		table.insert(shipoptions, {
			id = tostring(entry.id),
			text = ColorText["text_player"] .. "\27[" .. entry.icon .. "] " .. entry.name .. "\27X\n" .. ReadText(1001, 12920) .. "\n" .. ReadText(1001, 8053) .. "\n" .. ReadText(1001, 9093),
			text2 = "\n" .. entry.prestige .. "\n" .. travelspeedtext .. "\n" .. dpstext,
			icon = "",
			displayremoveoption = false,
		})
	end
	if agent.ship ~= 0 then
		table.insert(shipoptions, 1, {
			id = "none",
			text = "\n" .. ReadText(1001, 12923),
			icon = "",
			displayremoveoption = false,
		})

		local name, icon, idcode, prestigename = GetComponentData(ConvertStringToLuaID(tostring(agent.ship)), "name", "icon", "idcode", "prestigename")
		local travelspeedtext = ConvertIntegerString(Helper.round(C.GetDefensibleSpeeds(agent.ship).travelspeed), true, 0, true) .. " " .. ReadText(1001, 113)
		local dpstext = "0" .. " " .. ReadText(1001, 119)
		local sustainedfwddps = ffi.new("DPSData[?]", 1)
		C.GetDefensibleDPS(sustainedfwddps, agent.ship, true, true, true, true, false, true, false)
		if sustainedfwddps[0].dps > 0 then
			dpstext = ConvertIntegerString(sustainedfwddps[0].dps, true, 0, true) .. " " .. ReadText(1001, 119)
		end
		table.insert(shipoptions, 2, {
			id = tostring(agent.ship),
			text = "\27[" .. icon .. "] " .. name .. " (" .. idcode .. ")" .. "\n" .. ReadText(1001, 12920) .. "\n" .. ReadText(1001, 8053) .. "\n" .. ReadText(1001, 9093),
			text2 = "\n" .. prestigename .. "\n" .. travelspeedtext .. "\n" .. dpstext,
			icon = "",
			displayremoveoption = false,
		})
	end
	
	local row = agentdetailstable:addRow(true, { fixed = true })
	row[1]:setColSpan(4):createDropDown(shipoptions, {
		startOption = tostring(agent.ship) or "",
		height = 4 * Helper.standardTextHeight,
		textOverride = (agent.ship == 0) and ("\n" .. ReadText(1001, 2302)) or "",
		helpOverlayID = "diplomacy_agent_ship",
		helpOverlayText = " ",
		helpOverlayHighlightOnly = true,
		active = (not agent.isbusy) or (agent.isbusy.optionselected == false),
		highlightColor = Color["dropdown_highlight_big"],
	}):setTextProperties({
		y = 1.5 * Helper.standardTextHeight,
	}):setText2Properties({
		x = Helper.standardTextOffsetx,
		y = 1.5 * Helper.standardTextHeight,
		halign = "right",
	})
	row[1].handlers.onDropDownConfirmed = function (_, id) local id64 = C.ConvertStringTo64Bit(id); C.SetAgentDiplomacyShip(agent.id, id64); menu.agents[menu.contextMenuData.id].ship = id64; menu.refreshContextFrame() end
end

function menu.createActionConfigContext(frame)
	local curgametime = C.GetCurrentGameTime()

	local action = menu.actionsByID[menu.contextMenuData.id]
	local active = menu.contextMenuData.operationindex == nil
	local uniqueandlocked = action.hidden
	local operation, operationparameters, ispastoperation
	if menu.contextMenuData.operationindex then
		operation = menu.actionoperations[menu.contextMenuData.id][menu.contextMenuData.operationindex]
		operationparameters = GetDiplomaticActionOperationParamValues(tonumber(operation.id))
		ispastoperation = operation.endtime <= curgametime
	else
		uniqueandlocked = action.unique and (not C.CanStartDiplomacyAction(action.id, ""))
	end

	local titletable = frame:addTable(1, { tabOrder = 0, width = menu.actionConfig.width, x = 0, y = 0 })

	-- title
	local row = titletable:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
	row[1]:createText(ReadText(1001, 12823), Helper.titleTextProperties)
	row[1].properties.height = row[1].properties.height + Helper.borderSize

	-- banner
	titletable:addEmptyRow(2 * Helper.standardContainerOffset)

	local row = titletable:addRow(nil, { fixed = true })
	row[1]:createIcon(action.imageid, { scaling = false, height = menu.actionConfig.width / config.actions.bannerAspectRatio })

	titletable:addEmptyRow(2 * Helper.standardContainerOffset)

	local agentdropdownheight = 3 * math.max(tonumber(C.GetTextHeight("M", Helper.standardFont, Helper.standardFontSize, 0)) + 2, Helper.standardTextHeight)

	local yoffset = titletable:getFullHeight() + Helper.borderSize
	local descwidth = menu.actionConfig.width / 2 - 3 * Helper.standardContainerOffset
	local desctable = frame:addTable(1, { tabOrder = 12, width = descwidth, x = 2 * Helper.standardContainerOffset, y = yoffset, highlightMode = "off" })
	local infotable = frame:addTable(2, { tabOrder = 0, width = descwidth, x = 2 * Helper.standardContainerOffset, y = yoffset })
	infotable:setColWidthPercent(1, 70)
	local infotable2 = frame:addTable(3, { tabOrder = 10, width = descwidth, x = menu.actionConfig.width / 2 + Helper.standardContainerOffset, y = yoffset, defaultInteractiveObject = active })
	infotable2:setColWidth(1, 2 * agentdropdownheight)
	infotable2:setColWidthPercent(3, 50)

	-- desc
	local row = desctable:addRow(nil, { fixed = true })
	row[1]:createText(action.name, Helper.subHeaderTextProperties)

	local description = GetTextLines(action.desc, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), descwidth - 2 * Helper.scaleX(Helper.standardTextOffsetx))
	if #description > config.actions.numDescLines then
		-- scrollbar case
		description = GetTextLines(action.desc, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), descwidth - 2 * Helper.scaleX(Helper.standardTextOffsetx) - Helper.scrollbarWidth)
	end

	local descriptionheight
	for linenum, descline in ipairs(description) do
		local row = desctable:addRow(true)
		row[1]:createText(descline)
		if linenum == config.actions.numDescLines then
			descriptionheight = desctable:getFullHeight()
		end
	end
	for i = 1, config.actions.numDescLines - #description do
		local row = desctable:addRow(nil)
		row[1]:createText(" ")
	end
	desctable.properties.maxVisibleHeight = descriptionheight

	-- agent selection
	local row = infotable2:addRow(nil)
	row[1]:setColSpan(3):createText(ReadText(1001, 12824), Helper.subHeaderTextProperties)

	local row = infotable2:addRow(active and (not uniqueandlocked))
	if operation and operation.isarchive then
		row.properties.borderBelow = false
		local iconsize = Helper.scaleY(agentdropdownheight) - 4
		local icon = operation.agentimageid
		if operation.agentresultstate == "killed" then
			icon = icon .. "_bw"
		end
		row[1]:createIcon(icon, { scaling = false, width = iconsize, height = iconsize, x = Helper.scaleY(agentdropdownheight), y = iconsize / 2 - 10, affectRowHeight = false })
		row[2]:setColSpan((operation.agentresultstate == "killed") and 1 or 2):createText("\27[" .. operation.agentrankicon .. "] " .. operation.agentname, { color = Color["text_inactive"], x = 0, y = 2 })
		if operation.agentresultstate == "killed" then
			row[3]:createText(ReadText(1001, 12947), { color = Color["text_negative"], y = 2, halign = "right" })
		end

		local row = infotable2:addRow(active)
		row[2]:createText(ReadText(1001, 12820) .. "\n" .. ReadText(1001, 12821), { color = Color["text_lowlight"], x = 0, y = 0 })
		row[3]:createText(operation.agentexp_negotiation_name .. "\n" .. operation.agentexp_espionage_name, { halign = "right", color = Color["text_lowlight"], y = 0 })
	else
		local totaltextwidth = descwidth - 2 * Helper.scaleY(agentdropdownheight) - Helper.scaleX(Helper.standardTextOffsetx)
		local agentoptions = {}
		for i, agent in ipairs(menu.agents) do
			local statustext = menu.getAgentStatus(i, true)
			local statustextwidth = C.GetTextWidth(" " .. statustext, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize))
			local agenttext = TruncateText("\27[" .. agent.rankicon .. "] " .. agent.name, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), totaltextwidth - statustextwidth)
			table.insert(agentoptions, {
				id = i,
				text = agenttext .. "\n" .. ColorText["text_lowlight"] .. ReadText(1001, 12820) .. "\n" .. ReadText(1001, 12821),
				text2 = statustext .. "\n" .. ColorText["text_lowlight"] .. agent.exp_negotiation_name .. "\n" .. agent.exp_espionage_name,
				icon = agent.icon or "",
				displayremoveoption = false,
				active = ((not agent.isbusy) or (agent.isbusy.optionselected == false)) and ((agent.injuryendtime < 0) or (agent.injuryendtime < C.GetCurrentGameTime())) and (agent.ship ~= 0),
			})
		end
		row[1]:setColSpan(3):createDropDown(agentoptions, {
			startOption = (operation and operation.agentindex) or menu.contextMenuData.selectedagentid or "",
			height = agentdropdownheight,
			active = active and (not uniqueandlocked),
			textOverride = ((not active) or menu.contextMenuData.selectedagentid) and "" or ("\n" .. ReadText(1001, 12846)),
			text2Override = ((not active) or menu.contextMenuData.selectedagentid) and "" or " ",
			optionColor = Color["dropdown_background_inactive"],
			highlightColor = Color["dropdown_highlight_big"],
		}):setIconProperties({
			width = agentdropdownheight,
			height = agentdropdownheight,
			color = Color["icon_inactive"],
		}):setTextProperties({
			x = agentdropdownheight,
			y = agentdropdownheight / 4 + 2,
		}):setText2Properties({
			x = Helper.standardTextOffsetx,
			y = agentdropdownheight / 4 + 2,
			halign = "right",
		})
		row[1].handlers.onDropDownConfirmed = function (_, id) menu.contextMenuData.selectedagentid = tonumber(id); menu.refreshContextFrame() end
	end

	local infotable2height = infotable2:getFullHeight()
	local heightafterfirstsection = math.max(desctable:getVisibleHeight(), infotable2height) + config.actions.sectionBorder
	infotable.properties.y = desctable.properties.y + heightafterfirstsection
	if heightafterfirstsection > infotable2height + Helper.borderSize then
		local row = infotable2:addRow(nil, { borderBelow = false })
		row[1]:createText(" ", { scaling = false, fontsize = 1, y = 0, minRowHeight = heightafterfirstsection - infotable2height - Helper.borderSize })
	end

	-- details
	local row = infotable:addRow(nil)
	row[1]:setColSpan(2):createText(ReadText(1001, 2961), Helper.subHeaderTextProperties)

	local row = infotable:addRow(nil)
	row[1]:createText(ReadText(1001, 12826))
	row[2]:createText(menu.getSuccessText(action.successchance), { halign = "right" })

	local row = infotable:addRow(nil)
	row[1]:createText(ReadText(1001, 12827))
	row[2]:createText(action.agentrisk, { halign = "right" })

	local row = infotable:addRow(nil)
	row[1]:createText((action.agenttype == "negotiation") and ReadText(1001, 12914) or ReadText(1001, 12915))
	row[2]:createText(action.agentexpname, { halign = "right" })

	-- target
	local row = infotable2:addRow(nil)
	row[1]:setColSpan(3):createText(ReadText(1001, 12825), Helper.subHeaderTextProperties)

	local targets = GetDiplomaticActionTargetParameters(action.id)
	for i, target in ipairs(targets) do
		local selectedtarget = operationparameters and operationparameters[target.name] or menu.contextMenuData.targets[i]

		local row = infotable2:addRow(active and (not uniqueandlocked))
		row[1]:setColSpan(2):createText(target.text)

		if ispastoperation then
			row[3]:createText(selectedtarget)
		else
			if action.paramtype == "factionpair" then
				local factions = GetLibrary("factions")
				for j = #factions, 1, -1 do
					local faction = factions[j]
					local arediplomacyeventsallowed = GetFactionData(faction.id, "arediplomacyeventsallowed")
					if (not arediplomacyeventsallowed) or (faction.id == "player") then
						table.remove(factions, j)
					end
				end
				table.sort(factions, Helper.sortName)

				local dropdownactive = active and (not uniqueandlocked)
				if i > 1 then
					dropdownactive = dropdownactive and (menu.contextMenuData.targets[1] ~= nil)
				end

				local factionoptions = {}
				for _, faction in ipairs(factions) do
					local factionactive = true
					local mouseovertext = ""
					if dropdownactive then
						if i > 1 then
							local exclusioninfo = C.IsDiplomacyExcluded(faction.id, menu.contextMenuData.targets[1])
							factionactive = menu.contextMenuData.targets[1] and (not exclusioninfo.excluded) and (faction.id ~= menu.contextMenuData.targets[1])

							if exclusioninfo.numexclusionreasons > 0 then
								local buf = ffi.new("const char*[?]", exclusioninfo.numexclusionreasons)
								local n = C.GetDiplomacyExcludedReasons(buf, exclusioninfo.numexclusionreasons, faction.id, menu.contextMenuData.targets[1])
								for k = 0, n - 1 do
									if k >= 1 then
										mouseovertext = mouseovertext .. "\n"
									end
									mouseovertext = mouseovertext .. "· " .. ffi.string(buf[k])
								end
							end
						end
					end
					if dropdownactive or (faction.id == selectedtarget) then
						table.insert(factionoptions, { id = faction.id, text = faction.name, icon = "", displayremoveoption = false, active = factionactive, mouseovertext = mouseovertext })
					end
				end
				if (not menu.contextMenuData.targets[i]) or (menu.contextMenuData.targets[i] == "none") then
					table.insert(factionoptions, 1, { id = "none", text = ReadText(1001, 3102) .. "...", icon = "", displayremoveoption = false })
				end

				row[3]:createDropDown(factionoptions, { startOption = selectedtarget or "none", height = Helper.standardButtonHeight, active = dropdownactive })
				row[3].handlers.onDropDownConfirmed = function (_, factionid) return menu.dropdownSelectFaction(action.id, i, factionid) end
			else
				if target.type == "object" then
					row[3]:createButton({ active = active and (not uniqueandlocked) and C.IsStoryFeatureUnlocked("x4ep1_map") }):setText(selectedtarget and ffi.string(C.GetComponentName(C.ConvertStringTo64Bit(tostring(selectedtarget)))) or (ReadText(1001, 3102) .. "..."))
					row[3].handlers.onClick = function () return menu.buttonSelectObject(action.id, i, target) end
				elseif target.type == "ware" then
					local wares = Helper.getOrderParameterWares(target.inputparams)

					local wareoptions = {}
					for _, ware in ipairs(wares) do
						table.insert(wareoptions, { id = ware, text = GetWareData(ware, "name"), icon = "", displayremoveoption = false })
					end
					if (not menu.contextMenuData.targets[i]) or (menu.contextMenuData.targets[i] == "none") then
						table.insert(wareoptions, 1, { id = "none", text = ReadText(1001, 3102) .. "...", icon = "", displayremoveoption = false })
					end

					row[3]:createDropDown(wareoptions, { startOption = selectedtarget or "none", height = Helper.standardButtonHeight, active = active and (not uniqueandlocked) })
					row[3].handlers.onDropDownConfirmed = function (_, wareid) return menu.dropdownSelectWare(action.id, i, wareid) end
				end
			end
		end
	end
	if #targets < 3 then
		for i = 1, 3 - #targets do
			local row = infotable2:addRow(nil)
			row[1]:setColSpan(2):createText(" ")
		end
	end

	local infotableheight = heightafterfirstsection + infotable:getFullHeight()
	local infotable2height = infotable2:getFullHeight()
	local heightaftersecondsection = math.max(infotableheight, infotable2height) + config.actions.sectionBorder
	if heightaftersecondsection > infotableheight + Helper.borderSize then
		local row = infotable:addRow(nil, { borderBelow = false })
		row[1]:createText(" ", { scaling = false, fontsize = 1, y = 0, minRowHeight = heightaftersecondsection - infotableheight - Helper.borderSize })
	end
	if heightaftersecondsection > infotable2height + Helper.borderSize then
		local row = infotable2:addRow(nil, { borderBelow = false })
		row[1]:createText(" ", { scaling = false, fontsize = 1, y = 0, minRowHeight = heightaftersecondsection - infotable2height - Helper.borderSize })
	end

	-- rewards
	local row = infotable:addRow(nil)
	row[1]:setColSpan(2):createText(ReadText(1001, 8807), Helper.subHeaderTextProperties)

	local row = infotable:addRow(nil)
	row[1]:setColSpan(2):createText(action.rewardtext, { wordwrap = true })

	-- requirements
	local row = infotable2:addRow(nil)
	row[1]:setColSpan(3):createText(ReadText(1001, 12828), Helper.subHeaderTextProperties)

	local hasmissingrequirement = false
	local row = infotable2:addRow(nil)
	row[1]:setColSpan(2):createText(ReadText(1001, 12815))
	local requirement = menu.playerinfluence >= action.influencerequirement
	if not requirement then
		hasmissingrequirement = true
	end
	row[3]:createText(ffi.string(C.GetInfluenceLevelName(action.influencerequirement)) .. (requirement and (ColorText["text_positive"] .. " \27[widget_tick_01]\27X") or (ColorText["text_negative"] .. " \27[widget_cross_01]\27X")), { halign = "right" })
	if (action.warecostscaleparamidx > 0) and menu.contextMenuData.targets[action.warecostscaleparamidx] and (menu.contextMenuData.targets[action.warecostscaleparamidx] ~= "none") then
		local target = targets[action.warecostscaleparamidx]
		if target.type == "ware" then
			action.price = tonumber(C.GetDiplomacyActionMoneyCost(action.id, menu.contextMenuData.targets[action.warecostscaleparamidx]))
		end
	end
	local row = infotable2:addRow(nil)
	row[1]:setColSpan(2):createText(ReadText(1001, 2808))
	local requirement = GetPlayerMoney() >= action.price
	if not requirement then
		hasmissingrequirement = true
	end
	row[3]:createText(ConvertMoneyString(action.price, false, true, 0, true) .. " " .. ReadText(1001, 101) .. (requirement and (ColorText["text_positive"] .. " \27[widget_tick_01]\27X") or (ColorText["text_negative"] .. " \27[widget_cross_01]\27X")), { halign = "right" })
	local inventory = GetPlayerInventory()
	for i, ware in ipairs(action.warerequirements) do
		local row = infotable2:addRow(nil)
		if i == 1 then
			row[1]:setColSpan(2):createText(ReadText(1001, 2811))
		end
		
		local requirement = (inventory[ware.ware] and inventory[ware.ware].amount or 0) >= ware.amount
		if not requirement then
			hasmissingrequirement = true
		end
		row[3]:createText(ConvertIntegerString(ware.amount, true, 0, true) .. ReadText(1001, 42) .. " " .. GetWareData(ware.ware, "name") .. (requirement and (ColorText["text_positive"] .. " \27[widget_tick_01]\27X") or (ColorText["text_negative"] .. " \27[widget_cross_01]\27X")), { halign = "right" })
	end

	infotable2:addEmptyRow()
	if (action.successchance < 100) and (action.giftwaretags ~= "") then
		local row = infotable2:addRow(active)
		row[1]:setColSpan(2):createText(ReadText(1001, 12829))

		local giftwareoptions = {}

		local playerinventory = GetPlayerInventory()
		local num_wares = C.GetNumWares2(action.giftwaretags, false, "", "", true, false)
		if num_wares > 0 then
			local buf_wares = ffi.new("const char*[?]", num_wares)
			num_wares = C.GetWares2(buf_wares, num_wares, action.giftwaretags, false, "", "", true, false)
			for i = 0, num_wares - 1 do
				local wareid = ffi.string(buf_wares[i])
				table.insert(giftwareoptions, { id = wareid, text = GetWareData(wareid, "name"), icon = "", displayremoveoption = false, active = (playerinventory[wareid] and (playerinventory[wareid].amount > 0)) and true or false })
			end
		end
		table.sort(giftwareoptions, function (a, b) return a.text < b.text end)
		table.insert(giftwareoptions, 1, { id = "none", text = ReadText(1001, 12852), icon = "", displayremoveoption = false })

		local startoption = menu.contextMenuData.giftware or "none"
		if operation and (operation.giftwareid ~= "") then
			startoption = operation.giftwareid
		end
		row[3]:createDropDown(giftwareoptions, { startOption = startoption, height = Helper.standardButtonHeight, active = active })
		row[3].handlers.onDropDownConfirmed = function (_, id) menu.contextMenuData.giftware = id end
	else
		local row = infotable2:addRow(nil)
		row[1]:setColSpan(2):createText(" ")
	end

	local infotableheight = heightafterfirstsection + infotable:getFullHeight()
	local infotable2height = infotable2:getFullHeight()
	local heightafterthirdsection = math.max(infotableheight, infotable2height) + Helper.borderSize

	local bottomtable = frame:addTable(3, { tabOrder = 11, width = menu.actionConfig.width - 4 * Helper.standardContainerOffset, x = 2 * Helper.standardContainerOffset, y = infotable2.properties.y + heightafterthirdsection, defaultInteractiveObject = not active })
	bottomtable:setColWidthPercent(2, 40)
	bottomtable:setColWidthPercent(3, 40)

	if ispastoperation then
		local row = bottomtable:addRow(nil, { fixed = true, bgColor = Color["row_background_container"], borderBelow = false })
		row[1]:setColSpan(3):createText((operation.agentresultstate == "killed") and (ColorText["text_negative"] .. ReadText(1001, 12945)) or ReadText(1001, 12892), { fontsize = Helper.headerRow1FontSize, halign = "center", y = Helper.standardContainerOffset })
		local row = bottomtable:addRow(nil, { fixed = true, bgColor = Color["row_background_container"], borderBelow = false })
		row[1]:setColSpan(3):createText(operation.successful and action.successtext or action.failuretext, { fontsize = Helper.largeIconFontSize, halign = "center", y = Helper.standardContainerOffset, wordwrap = true })
		local row = bottomtable:addRow(nil, { fixed = true, bgColor = Color["row_background_container"] })
		row[1]:setColSpan(3):createText(" ", { fontsize = 1, minRowHeight = 2 * Helper.standardContainerOffset })
	else
		-- duration
		local row = bottomtable:addRow(nil, { fixed = true, bgColor = Color["row_background_container"], borderBelow = false })
		row[1]:setColSpan(3):createText(active and ReadText(1001, 12830) or ReadText(1001, 12853), { fontsize = Helper.headerRow1FontSize, halign = "center", y = Helper.standardContainerOffset })
		local row = bottomtable:addRow(nil, { fixed = true, bgColor = Color["row_background_container"], borderBelow = false })
		row[1]:setColSpan(3):createText(active and ConvertTimeString(action.duration, (action.duration < 3600) and ReadText(1001, 209) or ReadText(1001, 207)) or function () local timeleft = operation.endtime - C.GetCurrentGameTime(); return ConvertTimeString(timeleft, (timeleft < 3600) and ReadText(1001, 209) or ReadText(1001, 207)) end, { fontsize = Helper.largeIconFontSize, halign = "center", y = Helper.standardContainerOffset })
		local row = bottomtable:addRow(nil, { fixed = true, bgColor = Color["row_background_container"] })
		row[1]:setColSpan(3):createText(" ", { fontsize = 1, minRowHeight = 2 * Helper.standardContainerOffset })
	end

	-- error
	local errorcount = 0
	if active then
		local targetfaction = ""
		if action.exclusivefactionparamidx > 0 then
			local target = targets[action.exclusivefactionparamidx]
			if (target.type == "object") and menu.contextMenuData.targets[action.exclusivefactionparamidx] then
				targetfaction = GetComponentData(ConvertStringToLuaID(tostring(menu.contextMenuData.targets[action.exclusivefactionparamidx])), "owner")
			end
		end
		local cooldownendtime = C.GetDiplomacyActionCooldownEndTime(action.id, targetfaction, false)

		if action.hidden then
			errorcount = errorcount + 1
			local row = bottomtable:addRow(nil, { fixed = true })
			row[1]:setColSpan(3):createText(ReadText(1001, 12943), { halign = "right", color = Color["text_warning"] })
		elseif cooldownendtime >= 0 then
			errorcount = errorcount + 1
			local row = bottomtable:addRow(nil, { fixed = true })
			row[1]:setColSpan(3):createText(function () local timeleft = cooldownendtime - C.GetCurrentGameTime(); return ReadText(1001, 12925) .. " (" .. ConvertTimeString(timeleft, (timeleft < 3600) and ReadText(1001, 209) or ReadText(1001, 207)) .. ")" end, { halign = "right", color = Color["text_error"] })
		elseif uniqueandlocked then
			errorcount = errorcount + 1
			local row = bottomtable:addRow(nil, { fixed = true })
			row[1]:setColSpan(3):createText(ReadText(1001, 12912), { halign = "right", color = Color["text_error"] })
		elseif hasmissingrequirement then
			errorcount = errorcount + 1
			local row = bottomtable:addRow(nil, { fixed = true })
			row[1]:setColSpan(3):createText(ReadText(1001, 12849), { halign = "right", color = Color["text_error"] })
		else
			if not menu.contextMenuData.selectedagentid then
				errorcount = errorcount + 1
				local row = bottomtable:addRow(nil, { fixed = true })
				row[1]:setColSpan(3):createText(ReadText(1001, 12848), { halign = "right", color = Color["text_error"] })
			end
			if #menu.contextMenuData.targets ~= #targets then
				errorcount = errorcount + 1
				local row = bottomtable:addRow(nil, { fixed = true })
				row[1]:setColSpan(3):createText((#targets == 1) and ReadText(1001, 12850) or ReadText(1001, 12851), { halign = "right", color = Color["text_error"] })
			else
				if not C.CanStartDiplomacyAction(action.id, targetfaction) then
					errorcount = errorcount + 1
					local row = bottomtable:addRow(nil, { fixed = true })
					row[1]:setColSpan(3):createText(action.unique and ReadText(1001, 12912) or ReadText(1001, 12913), { halign = "right", color = Color["text_error"] })
				end
			end
		end
	end
	if errorcount < 2 then
		for i = 1, 2 - errorcount do
			local row = bottomtable:addRow(nil)
			row[1]:setColSpan(2):createText(" ")
		end
	end

	-- button
	local row = bottomtable:addRow(true, { fixed = true })
	if ispastoperation then
		row[3]:createButton({  }):setText(ReadText(1001, 12891), { halign = "center" })
		row[3].handlers.onClick = function () C.SetArchivedDiplomacyActionOperationRead(operation.id); menu.getData(); return menu.closeContextMenu() end
	else
		row[2]:createButton({ active = errorcount == 0 }):setText(active and ReadText(1001, 12831) or ReadText(1001, 12832), { halign = "center" })
		row[2].handlers.onClick = active and menu.buttonStartAction or function () return menu.buttonAbortAction(operation.agentid, false, action.unique, action.exclusivefactionparamidx, action.cooldown) end
		row[3]:createButton({  }):setText(ReadText(1001, 2670), { halign = "center" })
		row[3].handlers.onClick = menu.closeContextMenu
	end

	bottomtable:addEmptyRow(2 * Helper.standardContainerOffset - Helper.borderSize, false)

	desctable:addConnection(1, 3, true)
	infotable2:addConnection(1, 4, true)
	bottomtable:addConnection(2, 4)
end

function menu.createEvents(frame, tableProperties)
	local eventiconheight = config.factionIconHeight
	local eventiconoffset = 2

	menu.eventtable = frame:addTable(2, { tabOrder = 1, width = menu.narrowtablewidth, x = tableProperties.x, y = tableProperties.y })
	if menu.setdefaulttable then
		menu.eventtable.properties.defaultInteractiveObject = true
		menu.setdefaulttable = nil
	end

	-- title
	local row = menu.eventtable:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
	row[1]:setColSpan(2):createText(ReadText(1001, 12836), Helper.titleTextProperties)
	row[1].properties.height = row[1].properties.height + Helper.borderSize

	-- influence
	local row = menu.eventtable:addRow(nil, { fixed = true })
	row[1]:createText(ReadText(1001, 12847), { font = Helper.standardFontBold, fontsize = Helper.headerRow1FontSize })
	row[2]:createText("\27[diplomacy_influence] " .. ffi.string(C.GetInfluenceLevelName(menu.playerinfluence)), { halign = "right", fontsize = Helper.headerRow1FontSize })

	menu.eventtable:addEmptyRow(Helper.standardTextHeight / 2)

	local row = menu.eventtable:addRow(nil, { fixed = true })
	row[1]:setColSpan(2):createText(ReadText(1001, 12856), { wordwrap = true })

	local row = menu.eventtable:addRow(nil, { fixed = true, bgColor = Color["row_separator"] })
	row[1]:setColSpan(2):createText(" ", { scaling = false, fontsize = 1, height = Helper.borderSize })

	local row = menu.eventtable:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
	row[1]:setColSpan(2):createText(ReadText(1001, 12837), Helper.subHeaderTextProperties)

	local curgametime = C.GetCurrentGameTime()
	local hadpastevent = false
	for _, eventoperation in ipairs(menu.eventoperations) do
		local event = menu.eventsByID[eventoperation.eventid]

		local ispastevent = eventoperation.endtime <= curgametime
		if (not hadpastevent) and ispastevent then
			hadpastevent = true

			local row = menu.eventtable:addRow(nil, { bgColor = Color["row_title_background"] })
			row[1]:setColSpan(2):createText(ReadText(1001, 12838), Helper.titleTextProperties)
			row[1].properties.height = row[1].properties.height + Helper.borderSize
		end

		local isselected = false
		if (menu.contextMenuMode == "event") and (eventoperation.id == menu.contextMenuData.id) then
			isselected = true
		end
		local row = menu.eventtable:addRow({ type = "event", id = eventoperation.id }, { bgColor = isselected and Color["row_background_selected"] or Color["row_background_blue"] })
		if eventoperation.id == menu.selectedOperation then
			menu.selectedRows.eventtable = row.index
		end

		local faction1shortname = GetFactionData(eventoperation.faction, "shortname")
		local faction2shortname = GetFactionData(eventoperation.otherfaction, "shortname")
		local name = "[" .. faction1shortname .. "][" .. faction2shortname .. "] - " .. event.name
		local color
		if ispastevent and (not eventoperation.read) then
			color = Color["text_mission"]
		end

		row[1]:setBackgroundColSpan(2):createIcon("solid", {
			color = Color["icon_hidden"],
			height = eventiconheight,
		}):setText(name, {
			font = Helper.standardFontBold,
			fontsize = Helper.headerRow1FontSize,
			x = Helper.standardTextOffsetx,
			y = 2 * eventiconoffset,
			color = color,
		}):setText2(event.shortdesc, {
			x = Helper.standardTextOffsetx,
			y = Helper.titleHeight + Helper.borderSize / 2,
			color = color,
		})
		row[2]:createIcon("solid", {
			color = Color["icon_hidden"],
		}):setText(Helper.convertGameTimeToXTimeString(eventoperation.endtime, true), {
			font = Helper.standardFontBold,
			fontsize = Helper.headerRow1FontSize,
			x = Helper.standardTextOffsetx,
			y = -eventiconheight / 2 + 2 * eventiconoffset,
			halign = "right",
			color = color,
		}):setText2(ispastevent and ReadText(1001, 12840) or function () return menu.eventOperationTime(eventoperation.endtime) end, {
			x = Helper.standardTextOffsetx,
			y = Helper.borderSize / 2,
			halign = "right",
			color = color,
		})
	end

	if menu.topRows.eventtable then
		menu.eventtable:setTopRow(menu.topRows.eventtable)
	end
	if menu.selectedRows.eventtable then
		menu.eventtable:setSelectedRow(menu.selectedRows.eventtable)
	end
	if menu.selectedCols.eventtable then
		menu.eventtable:setSelectedCol(menu.selectedCols.eventtable)
	end

	menu.eventtable:addConnection(1, 2, true)
end

function menu.eventOperationTime(endtime)
	local remainingtime = endtime - C.GetCurrentGameTime()
	if remainingtime <= 0 then
		menu.getData()
		menu.refresh = menu.refresh or getElapsedTime()
		return ReadText(1001, 12840)
	else
		return ReadText(1001, 12839) .. " (" .. Helper.formatTimeLeft(remainingtime) .. ")"
	end
end

function menu.getTruncatedOptionText(text, indicatortext, width)
	local indicatorWidth = math.floor(C.GetTextWidth(indicatortext, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize)))
	local truncatedtext = TruncateText(text, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), width - Helper.scaleX(Helper.standardTextOffsetx) - indicatorWidth)
	local mouseovertext = ""
	if truncatedtext ~= text then
		mouseovertext = text .. indicatortext
	end
	return truncatedtext .. indicatortext, mouseovertext
end

function menu.createEventContext(frame)
	Helper.clearTableConnectionColumn(menu, 3)
	Helper.clearTableConnectionColumn(menu, 4)

	local eventoperation = menu.eventoperationsByID[tostring(menu.contextMenuData.id)]
	local event = menu.eventsByID[eventoperation.eventid]
	local active = eventoperation.option == ""

	if eventoperation.isarchive and (not eventoperation.read) then
		C.SetArchivedDiplomacyEventOperationRead(eventoperation.id)
		menu.getData()
	end

	local titletable = frame:addTable(1, { tabOrder = 0, width = menu.eventConfig.width, x = 0, y = 0 })

	-- title
	local row = titletable:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
	row[1]:createText(ReadText(1001, 12841), Helper.titleTextProperties)
	row[1].properties.height = row[1].properties.height + Helper.borderSize

	local bannertable = frame:addTable(5, { tabOrder = 0, width = menu.eventConfig.width, x = 0, y = titletable:getFullHeight() + Helper.borderSize + 2 * Helper.standardContainerOffset, backgroundID = event.imageid, backgroundPadding = 0 })
	bannertable:setColWidthPercent(1, 10)
	bannertable:setColWidthPercent(3, 25)
	bannertable:setColWidthPercent(5, 10)

	bannertable:addEmptyRow(2 * Helper.titleHeight)

	local factioniconheight = Helper.scaleY(2 * Helper.titleHeight)
	local iconoffset = Helper.scaleX(12)
	local iconoffsetx = 0.1 * (menu.eventConfig.width - 4 * Helper.borderSize) - factioniconheight - iconoffset

	local row = bannertable:addRow(nil, { fixed = true, bgColor = Color["frame_background_semitransparent"], borderBelow = false })
	row[1]:setBackgroundColSpan(5):createText(" ", { scaling = false, fontsize = 1, y = 0, minRowHeight = Helper.standardContainerOffset })

	local row = bannertable:addRow(nil, { fixed = true, bgColor = Color["frame_background_semitransparent"], borderBelow = false })
	local factionicon, factionname, factionshortname = GetFactionData(eventoperation.faction, "icon", "name", "shortname")
	row[1]:setBackgroundColSpan(5):createIcon(factionicon, { scaling = false, width = factioniconheight, height = factioniconheight, x = iconoffsetx, y = (factioniconheight - Helper.scaleY(Helper.titleHeight)) / 2, affectRowHeight = false })
	row[2]:createText(factionname, { font = Helper.standardFontBold, fontsize = Helper.titleFontSize })
	row[3]:createText(ReadText(1001, 12842), { halign = "center", cellBGColor = Color["frame_background_black"] })
	local otherfactionicon, otherfactionname, otherfactionshortname = GetFactionData(eventoperation.otherfaction, "icon", "name", "shortname")
	row[4]:createText(otherfactionname, { font = Helper.standardFontBold, fontsize = Helper.titleFontSize, halign = "right" })
	row[5]:createIcon(otherfactionicon, { scaling = false, width = factioniconheight, height = factioniconheight, x = iconoffset, y = (factioniconheight - Helper.scaleY(Helper.titleHeight)) / 2, affectRowHeight = false })

	local row = bannertable:addRow(nil, { fixed = true, bgColor = Color["frame_background_semitransparent"], borderBelow = false })
	row[1]:setBackgroundColSpan(5)
	row[2]:createText("[" .. factionshortname .. "]", { fontsize = Helper.titleFontSize })
	local relationinfo = C.GetUIRelationName(eventoperation.faction, eventoperation.otherfaction)
	row[3]:createText(ffi.string(relationinfo.name), { fontsize = Helper.titleFontSize, halign = "center", cellBGColor = Color["frame_background_black"], color = Color[ffi.string(relationinfo.colorid)] })
	row[4]:createText("[" .. otherfactionshortname .. "]", { fontsize = Helper.titleFontSize, halign = "right" })

	local row = bannertable:addRow(nil, { fixed = true, bgColor = Color["frame_background_semitransparent"] })
	row[1]:setBackgroundColSpan(5):createText(" ", { scaling = false, fontsize = 1, y = 0, minRowHeight = Helper.standardContainerOffset })

	bannertable:addEmptyRow(Helper.standardContainerOffset)
	
	local agentdropdownheight = 3 * math.max(tonumber(C.GetTextHeight("M", Helper.standardFont, Helper.standardFontSize, 0)) + 2, Helper.standardTextHeight)

	local yoffset = bannertable.properties.y + bannertable:getFullHeight() + Helper.borderSize + 2 * Helper.standardContainerOffset
	local descwidth =  menu.actionConfig.width / 2 - 3 * Helper.standardContainerOffset
	local desctable = frame:addTable(1, { tabOrder = 12, width = descwidth, x = 2 * Helper.standardContainerOffset, y = yoffset, highlightMode = "off" })
	local infotable = frame:addTable(3, { tabOrder = 10, width = descwidth, x = menu.actionConfig.width / 2 + Helper.standardContainerOffset, y = yoffset, defaultInteractiveObject = active })
	infotable:setColWidth(1, 2 * agentdropdownheight)
	infotable:setColWidthPercent(3, 50)

	-- desc
	local hasdescscrollbar = false
	local row = desctable:addRow(nil, { fixed = true })
	row[1]:createText(event.name, Helper.subHeaderTextProperties)

	local description = GetTextLines(event.desc, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), descwidth - 2 * Helper.scaleX(Helper.standardTextOffsetx))
	if #description > config.actions.numDescLines then
		-- scrollbar case
		description = GetTextLines(event.desc, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), descwidth - 2 * Helper.scaleX(Helper.standardTextOffsetx) - Helper.scrollbarWidth)
		hasdescscrollbar = true
	end

	local descriptionheight
	for linenum, descline in ipairs(description) do
		local row = desctable:addRow(true)
		row[1]:createText(descline)
		if linenum == config.actions.numDescLines then
			descriptionheight = desctable:getFullHeight()
		end
	end
	for i = 1, config.actions.numDescLines - #description do
		local row = desctable:addRow(nil)
		row[1]:createText(" ")
	end
	desctable.properties.maxVisibleHeight = descriptionheight

	-- agent selection
	local row = infotable:addRow(nil)
	row[1]:setColSpan(3):createText(ReadText(1001, 12824), Helper.subHeaderTextProperties)

	local row = infotable:addRow(active)
	if eventoperation.isarchive then
		local iconsize = Helper.scaleY(agentdropdownheight) - 4
		if eventoperation.agentname ~= "" then
			local icon = eventoperation.agentimageid
			local agentstatus = ""
			if eventoperation.agentresultstate == "killed" then
				icon = icon .. "_bw"
				agentstatus = ColorText["text_negative"] .. ReadText(1001, 12947) .. "\27X"
			end
			row[1]:createIcon(icon, { scaling = false, width = iconsize, height = iconsize, x = Helper.scaleY(agentdropdownheight) + 2 })
			row[2]:createText( "\27[" .. eventoperation.agentrankicon .. "] " .. eventoperation.agentname .. "\n" .. ColorText["text_lowlight"] .. ReadText(1001, 12820) .. "\n" .. ReadText(1001, 12821), { color = Color["text_inactive"], x = 0, y = 2, minRowHeight = agentdropdownheight })
			row[3]:createText( agentstatus .. "\n" .. ColorText["text_lowlight"] .. eventoperation.agentexp_negotiation_name .. "\n" .. eventoperation.agentexp_espionage_name, { halign = "right", color = Color["text_inactive"], y = 2, minRowHeight = agentdropdownheight })
		else
			row[1]:createIcon("solid", { scaling = false, width = iconsize, height = iconsize, x = Helper.scaleY(agentdropdownheight) + 2, color = Color["icon_hidden"] })
			row[2]:setColSpan(2):createText( ReadText(1001, 12931) .. "\n  \n  ", { color = Color["text_inactive"], x = 0, y = 2, minRowHeight = agentdropdownheight })
		end
	else
		local totaltextwidth = descwidth - 2 * Helper.scaleY(agentdropdownheight) - Helper.scaleX(Helper.standardTextOffsetx)
		local agentoptions = {}
		for i, agent in ipairs(menu.agents) do
			local statustext = menu.getAgentStatus(i, true)
			local statustextwidth = C.GetTextWidth(" " .. statustext, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize))
			local agenttext = TruncateText("\27[" .. agent.rankicon .. "] " .. agent.name, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), totaltextwidth - statustextwidth)
			table.insert(agentoptions, {
				id = i,
				text = agenttext .. "\n" .. ColorText["text_lowlight"] .. ReadText(1001, 12820) .. "\n" .. ReadText(1001, 12821),
				text2 = statustext .. "\n" .. ColorText["text_lowlight"] .. agent.exp_negotiation_name .. "\n" .. agent.exp_espionage_name,
				icon = agent.icon or "",
				displayremoveoption = false,
				active = ((not agent.isbusy) or (agent.isbusy.optionselected == false)) and ((agent.injuryendtime < 0) or (agent.injuryendtime < C.GetCurrentGameTime())) and (agent.ship ~= 0),
			})
		end
		row[1]:setColSpan(3):createDropDown(agentoptions, {
			startOption = eventoperation.agentindex or "",
			height = agentdropdownheight,
			active = active,
			textOverride = ((not active) or eventoperation.agentindex) and "" or ("\n" .. ReadText(1001, 12846)),
			text2Override = ((not active) or eventoperation.agentindex) and "" or " ",
			optionColor = Color["dropdown_background_inactive"],
			highlightColor = Color["dropdown_highlight_big"],
		}):setIconProperties({
			width = agentdropdownheight,
			height = agentdropdownheight,
		}):setTextProperties({
			x = agentdropdownheight,
			y = agentdropdownheight / 4 + 2,
		}):setText2Properties({
			x = Helper.standardTextOffsetx,
			y = agentdropdownheight / 4 + 2,
			halign = "right",
		})
		row[1].handlers.onDropDownConfirmed = function (_, id) return menu.dropdownAssignEventAgent(eventoperation.id, id) end
	end

	local heightafterfirstsection = math.max(desctable:getVisibleHeight(), infotable:getFullHeight()) + config.actions.sectionBorder

	local numcols = 8
	local middletable = frame:addTable(numcols, { tabOrder = 11, width = menu.actionConfig.width - 4 * Helper.standardContainerOffset, x = 2 * Helper.standardContainerOffset, y = infotable.properties.y + heightafterfirstsection, defaultInteractiveObject = not active })
	middletable:setColWidth(3, 2 * Helper.standardContainerOffset)
	middletable:setColWidth(6, 2 * Helper.standardContainerOffset)

	local optiontextwidth = math.floor((menu.actionConfig.width - 8 * Helper.standardContainerOffset - (numcols - 1) * Helper.borderSize) / (numcols - 2))

	-- duration
	if not eventoperation.isarchive then
		local row = middletable:addRow(nil, { fixed = true, bgColor = Color["row_background_container"], borderBelow = false })
		row[1]:setColSpan(numcols):createText(ReadText(1001, 12854), { fontsize = Helper.headerRow1FontSize, halign = "center", y = Helper.standardContainerOffset })
		local row = middletable:addRow(nil, { fixed = true, bgColor = Color["row_background_container"], borderBelow = false })
		row[1]:setColSpan(numcols):createText(function () return Helper.formatTimeLeft(eventoperation.endtime - C.GetCurrentGameTime()) end, { fontsize = Helper.largeIconFontSize, halign = "center", y = Helper.standardContainerOffset })
		local row = middletable:addRow(nil, { fixed = true, bgColor = Color["row_background_container"] })
		row[1]:setColSpan(numcols):createText(" ", { fontsize = 1, minRowHeight = 2 * Helper.standardContainerOffset })
	else
		local text = ReadText(1001, 12857)
		if eventoperation.agentresultstate == "killed" then
			text = ColorText["text_negative"] .. ReadText(1001, 12945)
		elseif eventoperation.option then
			if eventoperation.option == eventoperation.outcome then
				text = ReadText(1001, 12902)
			else
				text = ReadText(1001, 12903)
			end
		end
		local row = middletable:addRow(nil, { fixed = true, bgColor = Color["row_background_container"], borderBelow = false })
		row[1]:setColSpan(numcols):createText(text, { fontsize = Helper.headerRow1FontSize, halign = "center", y = Helper.standardContainerOffset, color = (eventoperation.option == eventoperation.outcome) and Color["text_positive"] or Color["text_negative"] })
		local outcome
		for i, option in ipairs(event.options) do
			if option.id == eventoperation.outcome then
				outcome = option
				break
			end
		end
		local row = middletable:addRow(nil, { fixed = true, bgColor = Color["row_background_container"], borderBelow = false })
		row[1]:setColSpan(numcols):createText(ReadText(1001, 12904) .. ReadText(1001, 120) .. " " .. (outcome and outcome.name or ""), { fontsize = Helper.largeIconFontSize, halign = "center", y = Helper.standardContainerOffset })
		local row = middletable:addRow(nil, { fixed = true, bgColor = Color["row_background_container"] })
		row[1]:setColSpan(numcols):createText(" ", { fontsize = 1, minRowHeight = 2 * Helper.standardContainerOffset })
	end

	-- agent focus
	middletable:addEmptyRow(2 * Helper.standardContainerOffset)

	local row = middletable:addRow(nil, { fixed = true })
	row[1]:setColSpan(numcols):createText(ReadText(1001, 12855), { halign = "center", font = Helper.standardFontBold, fontsize = Helper.headerRow1FontSize })

	middletable:addEmptyRow(2 * Helper.standardContainerOffset)

	local buttonheight = 3 * Helper.headerRow1Height
	local iconwidth = 2 * Helper.headerRow1Height

	local buttonrow = middletable:addRow(true, { fixed = true, borderBelow = false })
	local emptyrow = middletable:addRow(true, { fixed = true, borderBelow = false })
	local influencerow = middletable:addRow(nil, { fixed = true, borderBelow = false })
	local moneyrow = middletable:addRow(nil, { fixed = true, borderBelow = false })
	local warerows = {}

	local maxnumwares = 0
	for i, option in ipairs(event.options) do
		maxnumwares = math.max(maxnumwares, #option.warerequirements)
	end

	local inventory = GetPlayerInventory()
	local playermoney = GetPlayerMoney()
	local selectedoption
	for i, option in ipairs(event.options) do
		local col = 3 * math.max(1, math.min(3, option.menuposition + 2)) - 2

		if (option.id == eventoperation.option) or (option.id == menu.contextMenuData.selectedOption) then
			selectedoption = option
		end

		local hasmissingrequirement
		if menu.playerinfluence < option.influencerequirement then
			hasmissingrequirement = true
		end
		if playermoney < option.price then
			hasmissingrequirement = true
		end
		for i, ware in ipairs(option.warerequirements) do
			if (inventory[ware.ware] and inventory[ware.ware].amount or 0) < ware.amount then
				hasmissingrequirement = true
			end
		end

		-- button
		buttonrow[col]:setColSpan(2):createButton({
			height = buttonheight,
			active = active and (not hasmissingrequirement),
		}):setIcon(((option.id == eventoperation.option) or (option.id == menu.contextMenuData.selectedOption)) and "menu_radio_button_on" or "menu_radio_button_off", {
			width = iconwidth,
			height = iconwidth,
			y = (buttonheight - iconwidth) / 2,
		}):setText(option.name, {
			x = iconwidth,
			y = Helper.headerRow1Height / 2 - Helper.headerRow1Offsety,
			font = Helper.standardFontBold,
			fontsize = Helper.headerRow1FontSize,
		}):setText2(option.result, {
			x = iconwidth,
			y = -Helper.headerRow1Height / 2 + Helper.headerRow1Offsety,
		})
		buttonrow[col].handlers.onClick = function () menu.contextMenuData.selectedOption = (option.id ~= menu.contextMenuData.selectedOption) and option.id or nil; menu.refreshContextFrame() end
		emptyrow[col]:setColSpan(2):createText(" ", { scaling = false, fontsize = 1, minRowHeight = 2 * Helper.standardContainerOffset, cellBGColor = Color["row_background_container"] })
		-- influence
		influencerow[col]:setBackgroundColSpan(2):createText(ReadText(1001, 12815), { cellBGColor = Color["row_background_container"] })
		local influencetext = ffi.string(C.GetInfluenceLevelName(option.influencerequirement))
		local indicator = (menu.playerinfluence >= option.influencerequirement) and (ColorText["text_positive"] .. " \27[widget_tick_01]\27X") or (ColorText["text_negative"] .. " \27[widget_cross_01]\27X")
		local text, mouseovertext = menu.getTruncatedOptionText(influencetext, indicator, optiontextwidth)
		influencerow[col + 1]:createText(text, { halign = "right", cellBGColor = Color["row_background_container"], mouseOverText = mouseovertext })
		-- money
		moneyrow[col]:setBackgroundColSpan(2):createText(ReadText(1001, 2808), { cellBGColor = Color["row_background_container"] })
		local moneytext = ConvertMoneyString(option.price, false, true, 0, true) .. " " .. ReadText(1001, 101)
		local indicator = (GetPlayerMoney() >= option.price) and (ColorText["text_positive"] .. " \27[widget_tick_01]\27X") or (ColorText["text_negative"] .. " \27[widget_cross_01]\27X")
		local text, mouseovertext = menu.getTruncatedOptionText(moneytext, indicator, optiontextwidth)
		moneyrow[col + 1]:createText(text, { halign = "right", cellBGColor = Color["row_background_container"], mouseOverText = mouseovertext })
		-- wares
		local inventory = GetPlayerInventory()
		for j, ware in ipairs(option.warerequirements) do
			if not warerows[j] then
				warerows[j] = middletable:addRow(nil, { fixed = true, borderBelow = false })
			end
			warerows[j][col]:setBackgroundColSpan(2):createText((j == 1) and ReadText(1001, 2811) or " ", { cellBGColor = Color["row_background_container"] })
			local waretext = ConvertIntegerString(ware.amount, true, 0, true) .. ReadText(1001, 42) .. " " .. GetWareData(ware.ware, "name")
			local indicator = ((inventory[ware.ware] and inventory[ware.ware].amount or 0) >= ware.amount) and (ColorText["text_positive"] .. " \27[widget_tick_01]\27X") or (ColorText["text_negative"] .. " \27[widget_cross_01]\27X")
			local text, mouseovertext = menu.getTruncatedOptionText(waretext, indicator, optiontextwidth)
			warerows[j][col + 1]:createText(text, { halign = "right", cellBGColor = Color["row_background_container"], mouseOverText = mouseovertext })
		end
		for j = #option.warerequirements + 1, maxnumwares do
			if not warerows[j] then
				warerows[j] = middletable:addRow(nil, { fixed = true, borderBelow = false })
			end
			warerows[j][col]:setColSpan(2):createText(" ", { cellBGColor = Color["row_background_container"] })
		end

		if not warerows[maxnumwares + 1] then
			warerows[maxnumwares + 1] = middletable:addRow(nil, { fixed = true, borderBelow = false })
		end
		warerows[maxnumwares + 1][col]:setColSpan(2):createText(" ", { scaling = false, fontsize = 1, minRowHeight = Helper.standardContainerOffset, cellBGColor = Color["row_background_container"] })
	end

	middletable:addEmptyRow(2 * Helper.standardContainerOffset)

	local yoffset2 = middletable.properties.y + middletable:getFullHeight() + Helper.borderSize + 2 * Helper.standardContainerOffset
	local texttable = frame:addTable(2, { tabOrder = 13, width = descwidth, x = 2 * Helper.standardContainerOffset, y = yoffset2, highlightMode = "off" })
	local infotable2 = frame:addTable(2, { tabOrder = 14, width = descwidth, x = menu.actionConfig.width / 2 + Helper.standardContainerOffset, y = yoffset2 })

	-- possible outcomes
	local textoffsety = Helper.standardTextHeight - Helper.headerRow1Height / 2 + Helper.headerRow1Offsety

	local headerrow = texttable:addRow(nil, { fixed = true })
	local headerrow1 = infotable2:addRow(nil, { fixed = true })
	if selectedoption then
		headerrow[1]:setColSpan(2):createText(ReadText(1001, 12861), { halign = "center", font = Helper.standardFontBold, fontsize = Helper.headerRow1FontSize, color = Color["text_success"], cellBGColor = Color["row_background_container2"], minRowHeight = 2 * Helper.standardTextHeight, y = textoffsety })
		headerrow1[1]:setColSpan(2):createText(ReadText(1001, 12862), { halign = "center", font = Helper.standardFontBold, fontsize = Helper.headerRow1FontSize, color = Color["text_failure"], cellBGColor = Color["row_background_container2"], minRowHeight = 2 * Helper.standardTextHeight, y = textoffsety })
	else
		headerrow[1]:setColSpan(2):createText(ReadText(1001, 12857), { halign = "center", font = Helper.standardFontBold, fontsize = Helper.headerRow1FontSize, cellBGColor = Color["row_background_container2"], minRowHeight = 2 * Helper.standardTextHeight, y = textoffsety })
		headerrow1[1]:setColSpan(2):createText(ReadText(1001, 12860), { halign = "center", font = Helper.standardFontBold, fontsize = Helper.headerRow1FontSize, cellBGColor = Color["row_background_container2"], minRowHeight = 2 * Helper.standardTextHeight, y = textoffsety })
	end

	local successrows = {}
	local inforow = texttable:addRow(nil, { fixed = true })
	if selectedoption then
		inforow[1]:setBackgroundColSpan(2):createText(selectedoption.name, { font = Helper.standardFontBold, fontsize = Helper.headerRow1FontSize, cellBGColor = Color["row_background_container"], minRowHeight = 2 * Helper.standardTextHeight, y = textoffsety })
		local chance = C.GetDiplomacyEventOptionChance(eventoperation.id, selectedoption.id, selectedoption.id)
		local origchance = C.GetDiplomacyEventOptionChance(eventoperation.id, selectedoption.id, "-")
		inforow[2]:createText(menu.getSuccessText(chance) .. " " .. menu.getChevrons(origchance, chance), { halign = "right", font = Helper.standardFontBold, fontsize = Helper.headerRow1FontSize, cellBGColor = Color["row_background_container"], minRowHeight = 2 * Helper.standardTextHeight, y = textoffsety })
	else
		inforow[1]:setColSpan(2):createText(eventoperation.isarchive and ReadText(1001, 12907) or ReadText(1001, 12858), { halign = "center", fontsize = Helper.headerRow1FontSize, cellBGColor = Color["row_background_container"], minRowHeight = 2 * Helper.standardTextHeight, y = textoffsety })
	end

	-- focus text
	if not eventoperation.isarchive then
		local hasfocustextscrollbar = false
		local textwidth = descwidth - 2 * Helper.scaleX(Helper.standardTextOffsetx)
		local text = selectedoption and selectedoption.desc or ReadText(1001, 12859)
		local textlines = GetTextLines(text, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), textwidth)
		if #textlines > 4 then
			-- scrollbar case
			textlines = GetTextLines(text, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), textwidth - Helper.scrollbarWidth)
			hasfocustextscrollbar = true
		end

		local texttableheight
		for linenum, textline in ipairs(textlines) do
			local row = texttable:addRow(true, { bgColor = Color["row_background_container"], borderBelow = false })
			row[1]:setColSpan(2):createText(textline)
			if linenum == 4 then
				texttableheight = texttable:getFullHeight()
			end
		end
		for i = 1, 4 - #textlines do
			local row = texttable:addRow(nil, { bgColor = Color["row_background_container"], borderBelow = false })
			row[1]:setColSpan(2):createText(" ")
		end
		texttable.properties.maxVisibleHeight = texttableheight
	end

	local optionidx = 1
	for _, option in ipairs(event.options) do
		if (not selectedoption) or (selectedoption.id ~= option.id) then
			if not successrows[optionidx] then
				successrows[optionidx] = infotable2:addRow(nil, { fixed = true })
			end
			successrows[optionidx][1]:setBackgroundColSpan(2):createText(option.name, { font = Helper.standardFontBold, fontsize = Helper.headerRow1FontSize, cellBGColor = Color["row_background_container"], minRowHeight = 2 * Helper.standardTextHeight, y = textoffsety })
			local chance = C.GetDiplomacyEventOptionChance(eventoperation.id, option.id, selectedoption and selectedoption.id or "")
			local origchance = C.GetDiplomacyEventOptionChance(eventoperation.id, option.id, "-")
			successrows[optionidx][2]:createText(menu.getSuccessText(chance) .. (selectedoption and (" " .. menu.getChevrons(origchance, chance)) or ""), { halign = "right", font = Helper.standardFontBold, fontsize = Helper.headerRow1FontSize, cellBGColor = Color["row_background_container"], minRowHeight = 2 * Helper.standardTextHeight, y = textoffsety })
			optionidx = optionidx + 1
		end
	end
	if selectedoption then
		if not successrows[optionidx] then
			successrows[optionidx] = infotable2:addRow(nil, { fixed = true })
		end
		successrows[optionidx][1]:setBackgroundColSpan(2):createText("\27[menu_warning] " .. ReadText(1001, 12863), { font = Helper.standardFontBold, fontsize = Helper.headerRow1FontSize, cellBGColor = Color["row_background_container"], minRowHeight = 2 * Helper.standardTextHeight, y = textoffsety })
		successrows[optionidx][2]:createText(selectedoption.agentrisk, { halign = "right", font = Helper.standardFontBold, fontsize = Helper.headerRow1FontSize, cellBGColor = Color["row_background_container"], minRowHeight = 2 * Helper.standardTextHeight, y = textoffsety })
	end
	if #event.options < 3 then
		for i = 1, 3 - #event.options do
			local row = infotable2:addRow(nil)
			row[1]:createText(" ", { minRowHeight = 2 * Helper.standardTextHeight, y = textoffsety })
		end
	end

	local heightaftersecondsection = math.max(texttable:getVisibleHeight(), infotable2:getFullHeight()) + config.actions.sectionBorder

	local bottomtable = frame:addTable(numcols, { tabOrder = 15, width = menu.actionConfig.width - 4 * Helper.standardContainerOffset, x = 2 * Helper.standardContainerOffset, y = infotable2.properties.y + heightaftersecondsection })
	bottomtable:setColWidth(3, 2 * Helper.standardContainerOffset)
	bottomtable:setColWidth(6, 2 * Helper.standardContainerOffset)

	bottomtable:addEmptyRow(2 * Helper.standardContainerOffset)

	-- button
	local row = bottomtable:addRow(true, { fixed = true })
	if active and (not eventoperation.isarchive) then
		row[4]:setColSpan(3):createButton({ active = (eventoperation.agentid ~= 0) and (menu.contextMenuData.selectedOption ~= nil), mouseOverText = (eventoperation.agentid == 0) and (ColorText["text_error"] .. ReadText(1001, 12848)) or "" }):setText(ReadText(1001, 12864), { halign = "center" })
		row[4].handlers.onClick = function () C.SetDiplomacyEventOperationOption(eventoperation.agentid, menu.contextMenuData.selectedOption); menu.getData(); menu.refreshContextFrame() end
	end
	row[7]:setColSpan(2):createButton({  }):setText(ReadText(1001, 2670), { halign = "center" })
	row[7].handlers.onClick = menu.closeContextMenu

	bottomtable:addEmptyRow(2 * Helper.standardContainerOffset - Helper.borderSize, false)

	local coloffset = 0
	if hasdescscrollbar then
		coloffset = 1
		desctable:addConnection(1, 3, true)
	end
	if hasfocustextscrollbar then
		coloffset = 1
		texttable:addConnection(hasdescscrollbar and 2 or 1, 3, not hasdescscrollbar)
	end
	infotable:addConnection(1, 3 + coloffset, true)
	middletable:addConnection(2, 3 + coloffset)
	bottomtable:addConnection(3, 3 + coloffset)
end

function menu.getSuccessText(successchance)
	if successchance == 0 then
		return ReadText(1001, 12865)
	elseif successchance <= 33 then
		return ReadText(1001, 12866)
	elseif successchance <= 66 then
		return ReadText(1001, 12867)
	elseif successchance <= 99 then
		return ReadText(1001, 12868)
	else
		return ReadText(1001, 12869)
	end
end

function menu.getChevrons(origchance, chance)
	local change = chance - origchance
	if change < -66 then
		return "\27[menu_chevron_down_03]"
	elseif change < -33 then
		return "\27[menu_chevron_down_02]"
	elseif change < 0 then
		return "\27[menu_chevron_down_01]"
	elseif change == 0 then
		return "\27[menu_chevron_null]"
	elseif change <= 33 then
		return "\27[menu_chevron_up_01]"
	elseif change <= 66 then
		return "\27[menu_chevron_up_02]"
	elseif change <= 100 then
		return "\27[menu_chevron_up_03]"
	end
end

function menu.createNewEventContext(frame)
	local popUpWidth = Helper.scaleX(600)

	local ftable = frame:addTable(5, { tabOrder = 1, reserveScrollBar = false, highlightMode = "off", x = (Helper.viewWidth - popUpWidth) / 2, y = Helper.viewHeight / 2 - frame.properties.y, width = popUpWidth - Helper.borderSize, backgroundID = "solid", backgroundColor = Color["frame_background_notification"] })
	ftable:setDefaultColSpan(1, 5)
	ftable:setColWidthPercent(2, 37)
	ftable:setColWidth(3, Helper.scaleX(2 * Helper.standardContainerOffset) - 2 * Helper.borderSize, false)
	ftable:setColWidthPercent(4, 37)

	local row = ftable:addRow(nil, {  })
	row[1]:createText(ReadText(1001, 12893), Helper.titleTextProperties)

	ftable:addEmptyRow(2 * Helper.standardTextHeight)

	local row = ftable:addRow(nil, {  })
	row[1]:createText(ReadText(1001, 12894), { font = Helper.standardFontBold, fontsize = Helper.titleFontSize, halign = "center" })

	ftable:addEmptyRow(2 * Helper.standardContainerOffset)

	local row = ftable:addRow(nil, {  })
	row[1]:createText(ReadText(1001, 12895), { fontsize = Helper.headerRow1FontSize, halign = "center", wordwrap = true })

	ftable:addEmptyRow(2 * Helper.standardTextHeight)

	local eventoperation = menu.eventoperationsBySourceID[tostring(menu.contextMenuData.actionoperationid)]
	local row = ftable:addRow(true, {  })
	row[1]:setColSpan(1)
	row[2]:createButton({ active = eventoperation ~= nil }):setText(ReadText(1001, 12896), { halign = "center" })
	row[2].handlers.onClick = function () menu.buttonShowEvent(menu.contextMenuData.actionoperationid, eventoperation.id) end
	row[4]:createButton({  }):setText(ReadText(1001, 2670), { halign = "center" })
	row[4].handlers.onClick = function () C.SetArchivedDiplomacyActionOperationRead(menu.contextMenuData.actionoperationid); menu.closeContextMenu() end

	ftable.properties.y = ftable.properties.y - ftable:getFullHeight() / 2

	frame:setBackground("gradient_alpha_02", {  })
	frame:setBackground2("tut_gradient_hint_01", { color = Color["frame_background2_notification"], width = popUpWidth + 3 * Helper.borderSize, height = ftable:getFullHeight() + 4 * Helper.borderSize, rotationStart = 135 })
	frame.properties.standardButtons = {}
	frame.properties.height = Helper.viewHeight
end

function menu.buttonShowEvent(actionoperationid, eventoperationid)
	menu.selectedOperation = eventoperationid
	if actionoperationid then
		C.SetArchivedDiplomacyActionOperationRead(actionoperationid)
	else
		C.SetArchivedDiplomacyEventOperationRead(eventoperationid)
	end
	menu.closeContextMenu()

	menu.mode = "event"
	menu.contextMenuMode = "event"
	menu.contextMenuData = { id = eventoperationid }
	local y = math.max(Helper.playerInfoConfig.offsetY + Helper.playerInfoConfig.height + Helper.borderSize, menu.topLevelHeight)
	menu.createContextFrame(Helper.playerInfoConfig.offsetX + menu.sideBarWidth + Helper.borderSize + menu.narrowtablewidth + Helper.borderSize, y, menu.eventConfig.width, true)
	menu.refreshInfoFrame()
end

function menu.createEventCompletedContext(frame)
	local popUpWidth = Helper.scaleX(600)

	local eventoperation = menu.eventoperationsByID[tostring(menu.contextMenuData.eventoperationid)]
	local event = menu.eventsByID[eventoperation.eventid]

	local ftable = frame:addTable(9, { tabOrder = 1, reserveScrollBar = false, highlightMode = "off", x = (Helper.viewWidth - popUpWidth) / 2, y = Helper.viewHeight / 2 - frame.properties.y, width = popUpWidth - Helper.borderSize, backgroundID = "solid", backgroundColor = Color["frame_background_notification"] })
	ftable:setDefaultColSpan(1, 9)
	ftable:setColWidthPercent(1, 10)
	ftable:setColWidthPercent(3, 25)
	ftable:setColWidthPercent(4, 12)
	ftable:setColWidth(5, Helper.scaleX(2 * Helper.standardContainerOffset) - 2 * Helper.borderSize, false)
	ftable:setColWidthPercent(6, 12)
	ftable:setColWidthPercent(7, 25)
	ftable:setColWidthPercent(9, 10)

	local row = ftable:addRow(nil, {  })
	row[1]:createText(ReadText(1001, 12897), Helper.titleTextProperties)

	ftable:addEmptyRow()

	local selectedoption, outcome
	for i, option in ipairs(event.options) do
		if option.id == eventoperation.option then
			selectedoption = option
		elseif option.id == eventoperation.outcome then
			outcome = option
		end
	end
	local row = ftable:addRow(nil, {  })
	row[1]:createText(selectedoption and (ReadText(1001, 12898) .. ReadText(1001, 120) .. " " .. selectedoption.name) or ReadText(1001, 12899), { fontsize = Helper.headerRow1FontSize, halign = "center" })

	ftable:addEmptyRow(2 * Helper.standardContainerOffset)

	local row = ftable:addRow(nil, {  })
	row[1]:createText(ReadText(1001, 12901) .. ReadText(1001, 120) .. " " .. ((eventoperation.agentresultstate == "killed") and (ColorText["text_negative"] .. ReadText(1001, 12944)) or (outcome and outcome.name or "")), { fontsize = Helper.titleFontSize, halign = "center", wordwrap = true })

	ftable:addEmptyRow()

	local row = ftable:addRow(nil, { fixed = true, bgColor = Color["row_background_container"], borderBelow = false })
	row[1]:createText(" ", { fontsize = 1, minRowHeight = 2 * Helper.standardContainerOffset })

	local row = ftable:addRow(nil, { bgColor = Color["row_background_container"], borderBelow = false })
	row[1]:createText(ReadText(1001, 12842), { halign = "center" })
	
	local factioniconheight = Helper.scaleY(2 * Helper.titleHeight)
	local iconoffset = Helper.scaleX(12)
	local iconoffsetx = 0.1 * (popUpWidth - 4 * Helper.borderSize) - factioniconheight - iconoffset

	local row = ftable:addRow(nil, { bgColor = Color["row_background_container"], borderBelow = false })
	local factionicon, factionname, factionshortname = GetFactionData(eventoperation.faction, "icon", "name", "shortname")
	row[1]:setBackgroundColSpan(9):setColSpan(1):createIcon(factionicon, { scaling = false, width = factioniconheight, height = factioniconheight, x = iconoffsetx, y = (factioniconheight - Helper.scaleY(Helper.titleHeight)) / 2, affectRowHeight = false })
	row[2]:setColSpan(2):createText(factionname, { font = Helper.standardFontBold, fontsize = Helper.titleFontSize })
	local relationinfo = C.GetRelationRangeInfo(eventoperation.startrelation)
	row[4]:setColSpan(3):createText(ffi.string(relationinfo.name), { fontsize = Helper.titleFontSize, halign = "center", color = Color["text_inactive"], x = 0 })
	local otherfactionicon, otherfactionname, otherfactionshortname = GetFactionData(eventoperation.otherfaction, "icon", "name", "shortname")
	row[7]:setColSpan(2):createText(otherfactionname, { font = Helper.standardFontBold, fontsize = Helper.titleFontSize, halign = "right" })
	row[9]:createIcon(otherfactionicon, { scaling = false, width = factioniconheight, height = factioniconheight, x = iconoffset, y = (factioniconheight - Helper.scaleY(Helper.titleHeight)) / 2, affectRowHeight = false })

	local row = ftable:addRow(nil, { bgColor = Color["row_background_container"], borderBelow = false })
	row[1]:setBackgroundColSpan(9):setColSpan(1)
	row[2]:setColSpan(2):createText("[" .. factionshortname .. "]", { fontsize = Helper.titleFontSize })
	local iconsize = Helper.scaleX(Helper.titleHeight)
	row[4]:setColSpan(3):createIcon("diplomacy_arrow", { scaling = false, width = iconsize, height = iconsize, x = (row[4]:getWidth() - iconsize) / 2 })
	row[7]:setColSpan(2):createText("[" .. otherfactionshortname .. "]", { fontsize = Helper.titleFontSize, halign = "right" })

	local row = ftable:addRow(nil, { bgColor = Color["row_background_container"], borderBelow = false })
	row[1]:setBackgroundColSpan(9):setColSpan(1)
	local relationinfo = C.GetUIRelationName(eventoperation.faction, eventoperation.otherfaction)
	row[4]:setColSpan(3):createText(ffi.string(relationinfo.name), { fontsize = Helper.titleFontSize, halign = "center", color = Color[ffi.string(relationinfo.colorid)], x = 0 })

	local row = ftable:addRow(nil, { fixed = true, bgColor = Color["row_background_container"] })
	row[1]:createText(" ", { fontsize = 1, minRowHeight = 2 * Helper.standardContainerOffset })

	ftable:addEmptyRow()

	local row = ftable:addRow(nil, {  })
	row[1]:createText(outcome and outcome.conclusion or "", { fontsize = Helper.titleFontSize, halign = "center", wordwrap = true })

	ftable:addEmptyRow()

	local row = ftable:addRow(true, {  })
	row[1]:setColSpan(1)
	row[3]:setColSpan(2):createButton({  }):setText(ReadText(1001, 12896), { halign = "center" })
	row[3].handlers.onClick = function () menu.buttonShowEvent(nil, menu.contextMenuData.eventoperationid) end
	row[6]:setColSpan(2):createButton({  }):setText(ReadText(1001, 2670), { halign = "center" })
	row[6].handlers.onClick = function () C.SetArchivedDiplomacyEventOperationRead(menu.contextMenuData.eventoperationid); menu.closeContextMenu() end

	ftable.properties.y = ftable.properties.y - ftable:getFullHeight() / 2

	frame:setBackground("gradient_alpha_02", {  })
	frame:setBackground2("tut_gradient_hint_01", { color = Color["frame_background2_notification"], width = popUpWidth + 3 * Helper.borderSize, height = ftable:getFullHeight() + 4 * Helper.borderSize, rotationStart = 135 })
	frame.properties.standardButtons = {}
	frame.properties.height = Helper.viewHeight
end

function menu.createUserQuestionContext(frame)
	local popUpWidth = Helper.scaleX(600)

	local ftable = frame:addTable(5, { tabOrder = 1, reserveScrollBar = false, highlightMode = "off", x = (Helper.viewWidth - popUpWidth) / 2, y = Helper.viewHeight / 2 - frame.properties.y, width = popUpWidth - Helper.borderSize, backgroundID = "solid", backgroundColor = Color["frame_background_notification"] })
	ftable:setColWidthPercent(2, 37)
	ftable:setColWidth(3, Helper.scaleX(2 * Helper.standardContainerOffset) - 2 * Helper.borderSize, false)
	ftable:setColWidthPercent(4, 37)

	if menu.contextMenuData.mode == "abortaction" then
		local row = ftable:addRow(false, { fixed = true })
		row[1]:setColSpan(5):createText(ReadText(1001, 12832), Helper.headerRowCenteredProperties)

		local text = ReadText(1001, 12926)
		if menu.contextMenuData.cooldown > 0 then
			if menu.contextMenuData.unique then
				text = text .. " " .. ReadText(1001, 12927)
			elseif menu.contextMenuData.exclusivefactionidx > 0 then
				text = text .. " " .. ReadText(1001, 12928)
			end
		end
		local row = ftable:addRow(false, { fixed = true })
		row[1]:setColSpan(5):createText(text, { wordwrap = true })
	end

	local row = ftable:addRow(false, { fixed = true })
	row[1]:setColSpan(5):createText("")

	local row = ftable:addRow(true, { fixed = true })
	row[2]:createButton():setText(ReadText(1001, 12929), { halign = "center" })
	if menu.contextMenuData.mode == "abortaction" then
		row[2].handlers.onClick = function () return menu.buttonAbortAction(menu.contextMenuData.agentid, true) end
	end
	row[4]:createButton():setText(ReadText(1001, 12930), { halign = "center" })
	row[4].handlers.onClick = menu.closeContextMenu
	ftable:setSelectedCol(4)

	ftable.properties.y = ftable.properties.y - ftable:getFullHeight() / 2

	frame:setBackground("solid", { color = Color["frame_background_semitransparent"] })
	frame.properties.height = Helper.viewHeight
end

function menu.relationSorter(a, b)
	if menu.factionData.sorter == "default" then
		if a.isdiplomacyactive == b.isdiplomacyactive then
			if a.isrelationlocked == b.isrelationlocked then
				return a.name < b.name
			end
			return not a.isrelationlocked
		end
		return a.isdiplomacyactive
	elseif menu.factionData.sorter == "name" then
		return a.name < b.name
	elseif menu.factionData.sorter == "name_inv" then
		return a.name > b.name
	elseif menu.factionData.sorter == "relation" then
		return GetUIRelation(a.id) > GetUIRelation(b.id)
	elseif menu.factionData.sorter == "relation_inv" then
		return GetUIRelation(a.id) < GetUIRelation(b.id)
	end
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

function menu.createContextFrame(x, y, width, nomouseout)
	Helper.removeAllWidgetScripts(menu, config.contextLayer)
	PlaySound("ui_positive_click")

	local contextmenuwidth = width

	local autoFrameHeight = true
	menu.contextFrame = Helper.createFrameHandle(menu, {
		layer = config.contextLayer,
		standardButtons = { close = menu.contextMenuMode ~= "factiondetails" },
		width = contextmenuwidth,
		x = x,
		y = 0,
	})
	menu.contextFrame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	if menu.contextMenuMode == "factiondetails" then
		menu.contextFrame.properties.y = y
		menu.contextFrame.properties.height = menu.factionConfig.height
		menu.createFactionDetailsContext(menu.contextFrame)
		autoFrameHeight = false
	elseif menu.contextMenuMode == "agentdetails" then
		menu.createAgentDetailsContext(menu.contextFrame)
	elseif menu.contextMenuMode == "actionconfig" then
		menu.createActionConfigContext(menu.contextFrame)
	elseif menu.contextMenuMode == "event" then
		menu.createEventContext(menu.contextFrame)
	elseif menu.contextMenuMode == "newevent" then
		menu.createNewEventContext(menu.contextFrame)
		autoFrameHeight = false
	elseif menu.contextMenuMode == "eventcompleted" then
		menu.createEventCompletedContext(menu.contextFrame)
		autoFrameHeight = false
	elseif menu.contextMenuMode == "userquestion" then
		menu.createUserQuestionContext(menu.contextFrame)
		autoFrameHeight = false
	end

	if menu.contextFrame.properties.x + contextmenuwidth > Helper.viewWidth then
		menu.contextFrame.properties.x = Helper.viewWidth - contextmenuwidth - Helper.frameBorder
	end
	local height = menu.contextFrame:getUsedHeight()
	if autoFrameHeight and (y + height > Helper.viewHeight) then
		menu.contextFrame.properties.y = Helper.viewHeight - height - Helper.frameBorder
	else
		menu.contextFrame.properties.y = y
	end
	menu.contextFrame.properties.autoFrameHeight = autoFrameHeight

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

function menu.refreshContextFrame()
	Helper.removeAllWidgetScripts(menu, config.contextLayer)

	local y = menu.contextFrame.properties.y
	local autoFrameHeight = true
	menu.contextFrame = Helper.createFrameHandle(menu, {
		layer = config.contextLayer,
		standardButtons = { close = menu.contextMenuMode ~= "factiondetails" },
		width = menu.contextFrame.properties.width,
		x = menu.contextFrame.properties.x,
		y = 0,
	})
	menu.contextFrame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	if menu.contextMenuMode == "factiondetails" then
		menu.contextFrame.properties.y = y
		menu.contextFrame.properties.height = menu.factionConfig.height
		menu.createFactionDetailsContext(menu.contextFrame)
		autoFrameHeight = false
	elseif menu.contextMenuMode == "agentdetails" then
		menu.createAgentDetailsContext(menu.contextFrame)
	elseif menu.contextMenuMode == "actionconfig" then
		menu.createActionConfigContext(menu.contextFrame)
	elseif menu.contextMenuMode == "event" then
		menu.createEventContext(menu.contextFrame)
	end

	if menu.contextFrame.properties.x + menu.contextFrame.properties.width > Helper.viewWidth then
		menu.contextFrame.properties.x = Helper.viewWidth - menu.contextFrame.properties.width - Helper.frameBorder
	end
	local height = menu.contextFrame:getUsedHeight()
	if autoFrameHeight and (y + height > Helper.viewHeight) then
		menu.contextFrame.properties.y = Helper.viewHeight - height - Helper.frameBorder
	else
		menu.contextFrame.properties.y = y
	end
	menu.contextFrame.properties.autoFrameHeight = autoFrameHeight

	menu.contextFrame:display()
end

function menu.closeContextMenu(norefresh)
	Helper.clearTableConnectionColumn(menu, 4)
	Helper.clearFrame(menu, config.contextLayer)

	menu.contextMenuData = {}
	if menu.contextMenuMode == "factiondetails" then
		Helper.clearTableConnectionColumn(menu, 3)
		menu.factionData.curEntry = {}
		if not norefresh then
			menu.refreshInfoFrame()
		end
	elseif menu.contextMenuMode == "actionconfig" then
		Helper.clearTableConnectionColumn(menu, 3)
		if not norefresh then
			menu.refreshInfoFrame()
		end
	elseif menu.contextMenuMode == "event" then
		Helper.clearTableConnectionColumn(menu, 3)
		if not norefresh then
			menu.refreshInfoFrame()
		end
	end

	menu.contextMenuMode = nil
	menu.mouseOutBox = nil
end

function menu.viewCreated(layer, ...)
	if layer == config.mainLayer then
		menu.mainTable = ...
	elseif layer == config.infoLayer then
		menu.topLevelTable, menu.infoTable, menu.buttonTable = ...
	end
end

function menu.onInteractiveElementChanged(element)
	menu.lastactivetable = element
end

-- update
menu.updateInterval = 0.1

function menu.onUpdate()
	menu.mainFrame:update()
	menu.infoFrame:update()
	if (menu.contextMenuMode == "actionconfig") or (menu.contextMenuMode == "event") or (menu.contextMenuMode == "agentdetails") then
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
			menu.refreshInfoFrame(table.unpack(menu.refreshdata))
		else
			menu.refreshInfoFrame()
		end
		menu.refreshdata = nil
		menu.refresh = nil
	end
end

function menu.onRowChanged(row, rowdata, uitable, modified, input, source)
	if menu.mode == "factions" then
		if input == "mouse" then
			if uitable == menu.infoTable then
				if type(rowdata) == "table" then
					if rowdata[2].id ~= menu.factionData.curEntry.id then
						menu.factionData.curEntry = rowdata[2]
						menu.contextMenuMode = "factiondetails"
						menu.contextMenuData = {}
						local y = math.max(Helper.playerInfoConfig.offsetY + Helper.playerInfoConfig.height + Helper.borderSize, menu.topLevelHeight)
						menu.createContextFrame(Helper.playerInfoConfig.offsetX + menu.sideBarWidth + Helper.borderSize + menu.narrowtablewidth + Helper.borderSize, y, menu.factionConfig.width, true)
						menu.refreshInfoFrame()
					end
				end
			end
		end
	elseif menu.mode == "embassy" then
		if input == "mouse" then
			if menu.actiontable and (uitable == menu.actiontable.id) then
				if menu.lastactivetable == menu.actiontable.id then
					if type(rowdata) == "table" then
						if rowdata.type == "action" then
							if (menu.contextMenuMode ~= "actionconfig") or (rowdata.id ~= menu.contextMenuData.id) or (rowdata.operationindex ~= menu.contextMenuData.operationindex) then
								menu.contextMenuMode = "actionconfig"
								menu.contextMenuData = { id = rowdata.id, operationindex = rowdata.operationindex, targets = {} }
								local y = math.max(Helper.playerInfoConfig.offsetY + Helper.playerInfoConfig.height + Helper.borderSize, menu.topLevelHeight)
								menu.createContextFrame(Helper.playerInfoConfig.offsetX + menu.sideBarWidth + Helper.borderSize + menu.narrowtablewidth + Helper.borderSize, y, menu.actionConfig.width, true)
								menu.refreshInfoFrame()
							end
							return
						end
					end
					if (menu.contextMenuMode == "actionconfig") or (menu.contextMenuMode == "agentdetails") then
						menu.refreshInfoFrame()
						menu.closeContextMenu()
					end
				end
			end
		end
	elseif menu.mode == "agents" then
		if input == "mouse" then
			if menu.agenttable and (uitable == menu.agenttable.id) then
				if menu.lastactivetable == menu.agenttable.id then
					if type(rowdata) == "table" then
						if rowdata.type == "agent" then
							if (menu.contextMenuMode ~= "agentdetails") or (rowdata.id ~= menu.contextMenuData.id) then
								menu.contextMenuMode = "agentdetails"
								menu.contextMenuData = { id = rowdata.id }
								local y = math.max(Helper.playerInfoConfig.offsetY + Helper.playerInfoConfig.height + Helper.borderSize, menu.topLevelHeight)
								menu.createContextFrame(Helper.playerInfoConfig.offsetX + menu.sideBarWidth + Helper.borderSize + menu.narrowtablewidth + Helper.borderSize, y, menu.narrowtablewidth, true)
								menu.refreshInfoFrame()
							end
							return
						end
					end
					if (menu.contextMenuMode == "actionconfig") or (menu.contextMenuMode == "agentdetails") then
						menu.refreshInfoFrame()
						menu.closeContextMenu()
					end
				end
			end
		elseif source ~= "auto" then
			if menu.actiontable and (uitable == menu.actiontable.id) then
				menu.closeContextMenu()
			elseif menu.agenttable and (uitable == menu.agenttable.id) then
				menu.closeContextMenu()
			end
		end
	elseif menu.mode == "event" then
		if input == "mouse" then
			if menu.eventtable and (uitable == menu.eventtable.id) then
				if menu.lastactivetable == menu.eventtable.id then
					if type(rowdata) == "table" then
						if rowdata.type == "event" then
							if (menu.contextMenuMode ~= "event") or (rowdata.id ~= menu.contextMenuData.id) then
								menu.contextMenuMode = "event"
								menu.contextMenuData = { id = rowdata.id }
								local y = math.max(Helper.playerInfoConfig.offsetY + Helper.playerInfoConfig.height + Helper.borderSize, menu.topLevelHeight)
								menu.createContextFrame(Helper.playerInfoConfig.offsetX + menu.sideBarWidth + Helper.borderSize + menu.narrowtablewidth + Helper.borderSize, y, menu.eventConfig.width, true)
								menu.refreshInfoFrame()
							end
							return
						end
					end
					if (menu.contextMenuMode == "event") then
						menu.refreshInfoFrame()
						menu.closeContextMenu()
					end
				end
			end
		elseif source ~= "auto" then
			if menu.eventtable and (uitable == menu.eventtable.id) then
				menu.closeContextMenu()
			end
		end
	end

	-- kuertee start: callback
	if menu.uix_callbacks ["onRowChanged"] then
		for uix_id, uix_callback in pairs (menu.uix_callbacks ["onRowChanged"]) do
			uix_callback (row, rowdata, uitable, modified, input)
		end
	end
	-- kuertee end: callback
end

function menu.onSelectElement(uitable, modified, row)
	local rowdata = Helper.getCurrentRowData(menu, uitable)
	if menu.mode == "factions" then
		if uitable == menu.infoTable then
			if type(rowdata) == "table" then
				if rowdata[2].id ~= menu.factionData.curEntry.id then
					menu.factionData.curEntry = rowdata[2]
					menu.contextMenuMode = "factiondetails"
					menu.contextMenuData = {}
					local y = math.max(Helper.playerInfoConfig.offsetY + Helper.playerInfoConfig.height + Helper.borderSize, menu.topLevelHeight)
					menu.createContextFrame(Helper.playerInfoConfig.offsetX + menu.sideBarWidth + Helper.borderSize + menu.narrowtablewidth + Helper.borderSize, y, menu.factionConfig.width, true)
					menu.refreshInfoFrame()
				end
			end
		end
	elseif menu.mode == "embassy" then
		if menu.actiontable and (uitable == menu.actiontable.id) then
			if menu.lastactivetable == menu.actiontable.id then
				if type(rowdata) == "table" then
					if rowdata.type == "action" then
						if (menu.contextMenuMode ~= "actionconfig") or (rowdata.id ~= menu.contextMenuData.id) or (rowdata.operationindex ~= menu.contextMenuData.operationindex) then
							menu.contextMenuMode = "actionconfig"
							menu.contextMenuData = { id = rowdata.id, operationindex = rowdata.operationindex, targets = {} }
							local y = math.max(Helper.playerInfoConfig.offsetY + Helper.playerInfoConfig.height + Helper.borderSize, menu.topLevelHeight)
							menu.createContextFrame(Helper.playerInfoConfig.offsetX + menu.sideBarWidth + Helper.borderSize + menu.narrowtablewidth + Helper.borderSize, y, menu.actionConfig.width, true)
							menu.refreshInfoFrame()
						end
						return
					end
				end
				if (menu.contextMenuMode == "actionconfig") or (menu.contextMenuMode == "agentdetails") then
					menu.refreshInfoFrame()
					menu.closeContextMenu()
				end
			end
		end
	elseif menu.mode == "agents" then
		if menu.agenttable and (uitable == menu.agenttable.id) then
			if menu.lastactivetable == menu.agenttable.id then
				if type(rowdata) == "table" then
					if rowdata.type == "agent" then
						if (menu.contextMenuMode ~= "agentdetails") or (rowdata.id ~= menu.contextMenuData.id) then
							menu.contextMenuMode = "agentdetails"
							menu.contextMenuData = { id = rowdata.id }
							local y = math.max(Helper.playerInfoConfig.offsetY + Helper.playerInfoConfig.height + Helper.borderSize, menu.topLevelHeight)
							menu.createContextFrame(Helper.playerInfoConfig.offsetX + menu.sideBarWidth + Helper.borderSize + menu.narrowtablewidth + Helper.borderSize, y, menu.narrowtablewidth, true)
							menu.refreshInfoFrame()
						end
						return
					end
				end
				if (menu.contextMenuMode == "actionconfig") or (menu.contextMenuMode == "agentdetails") then
					menu.refreshInfoFrame()
					menu.closeContextMenu()
				end
			end
		end
	elseif menu.mode == "event" then
		if menu.eventtable and (uitable == menu.eventtable.id) then
			if menu.lastactivetable == menu.eventtable.id then
				if type(rowdata) == "table" then
					if rowdata.type == "event" then
						if (menu.contextMenuMode ~= "event") or (rowdata.id ~= menu.contextMenuData.id) then
							menu.contextMenuMode = "event"
							menu.contextMenuData = { id = rowdata.id, operationindex = rowdata.operationindex }
							local y = math.max(Helper.playerInfoConfig.offsetY + Helper.playerInfoConfig.height + Helper.borderSize, menu.topLevelHeight)
							menu.createContextFrame(Helper.playerInfoConfig.offsetX + menu.sideBarWidth + Helper.borderSize + menu.narrowtablewidth + Helper.borderSize, y, menu.eventConfig.width, true)
							menu.refreshInfoFrame()
						end
						return
					end
				end
				if (menu.contextMenuMode == "actionconfig") or (menu.contextMenuMode == "agentdetails") then
					menu.refreshInfoFrame()
					menu.closeContextMenu()
				end
			end
		end
	end
end

function menu.closeMenu(dueToClose)
	Helper.closeMenu(menu, dueToClose)
	menu.cleanup()
end

function menu.onCloseElement(dueToClose)
	if menu.contextMenuMode and (dueToClose == "back") then
		menu.closeContextMenu()
	elseif menu.mode and (dueToClose == "back") then
		menu.deactivatePlayerInfo()
	else
		menu.closeMenu(dueToClose)
	end
end

-- menu helpers

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
