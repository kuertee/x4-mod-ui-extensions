-- ffi setup
local ffi = require("ffi")
local C = ffi.C
ffi.cdef[[
	typedef uint64_t BuildTaskID;
	typedef uint64_t UniverseID;
	typedef struct {
		const char* wareid;
		uint32_t amount;
	} UIWareAmount;

	typedef struct {
		const char* macro;
		const char* ware;
		uint32_t amount;
		uint32_t capacity;
	} AmmoData;
	typedef struct {
		int x;
		int y;
	} Coord2D;
	typedef struct {
		float x;
		float y;
		float z;
	} Coord3D;
	typedef struct {
		float dps;
		uint32_t quadranttextid;
	} DPSData;
	typedef struct {
		UniverseID attacker;
		double time;
		const char* method;
	} LastAttackerInfo;
	typedef struct {
		UniverseID target;
		UIWareAmount* wares;
		uint32_t numwares;
	} MissionWareDeliveryInfo;
	// @since X4 4.10 - added
	typedef struct {
		UniverseID target;
		uint32_t numwares;
		MissionID missionid;
	} MissionWareDeliveryCounts;
	typedef struct {
		float x;
		float y;
		float width;
		float height;
	} MonitorExtents;
	typedef struct {
		size_t queueidx;
		const char* state;
		const char* statename;
		const char* orderdef;
		size_t actualparams;
		bool enabled;
		bool isinfinite;
		bool issyncpointreached;
		bool istemporder;
	} Order;
	typedef struct {
		const char* id;
		const char* name;
		const char* icon;
		const char* description;
		const char* category;
		const char* categoryname;
		bool infinite;
		uint32_t requiredSkill;
	} OrderDefinition;
	typedef struct {
		const char* id;
		const char* name;
		const char* desc;
		uint32_t amount;
		uint32_t numtiers;
		bool canhire;
	} PeopleInfo;
	typedef struct {
		float x;
		float y;
	} Position2D;
	typedef struct {
		float x;
		float y;
		float z;
		float yaw;
		float pitch;
		float roll;
	} PosRot;
	typedef struct {
		uint32_t id;
		const char* text;
		const char* type;
		bool ispossible;
		bool istobedisplayed;
	} UIAction;
	typedef struct {
		UniverseID component;
		const char* connection;
	} UIComponentSlot;
	typedef struct {
		const char* shape;
		const char* name;
		uint32_t requiredSkill;
		float radius;
		bool rollMembers;
		bool rollFormation;
		size_t maxShipsPerLine;
	} UIFormationInfo;
	typedef struct {
		float x;
		float y;
		float z;
		float yaw;
		float pitch;
		float roll;
	} UIPosRot;
	typedef struct {
		UniverseID contextid;
		const char* path;
		const char* group;
	} UpgradeGroup2;
	typedef struct {
		const char* wareid;
		int32_t amount;
	} YieldInfo;
	void ActivateObject(UniverseID objectid, bool active);
	bool AdjustOrder(UniverseID controllableid, size_t idx, size_t newidx, bool enabled, bool forcestates, bool checkonly);
	bool CanAcceptSubordinate(UniverseID commanderid, UniverseID potentialsubordinateid);
	bool CanBeDismantled(UniverseID componentid);
	bool CanBeTowed(UniverseID componentid);
	bool CancelConstruction(UniverseID containerid, BuildTaskID id);
	bool CanCancelConstruction(UniverseID containerid, BuildTaskID id);
	bool CanContainerBuildShip(UniverseID containerid, UniverseID shipid);
	bool CanContainerEquipShip(UniverseID containerid, UniverseID shipid);
	bool CanContainerSupplyShip(UniverseID containerid, UniverseID shipid);
	bool CanDockAtDockingBay(UniverseID shipid, UniverseID dockingbayid);
	bool CanPutShipIntoStorage(UniverseID containerid, UniverseID shipid);
	bool CanSetPlayerCameraCinematicView(void);
	bool CanStartTravelMode(UniverseID objectid);
	const char* CanTeleportPlayerTo(UniverseID controllableid, bool allowcontrolling, bool force);
	bool ClaimShip(UniverseID shipid, UniverseID shiptobeclaimedid);
	uint32_t CreateDeployToStationOrder(UniverseID controllableid);
	uint32_t CreateOrder(UniverseID controllableid, const char* orderid, bool defaultorder);
	uint32_t CreateOrder3(UniverseID controllableid, const char* orderid, bool defaultorder, bool isoverride, bool istemp);
	bool DoesConstructionSequenceRequireBuilder(UniverseID containerid);
	uint32_t GetAllLaserTowers(AmmoData* result, uint32_t resultlen, UniverseID defensibleid);
	uint32_t GetAllMines(AmmoData* result, uint32_t resultlen, UniverseID defensibleid);
	uint32_t GetAllNavBeacons(AmmoData* result, uint32_t resultlen, UniverseID defensibleid);
	uint32_t GetAllResourceProbes(AmmoData* result, uint32_t resultlen, UniverseID defensibleid);
	uint32_t GetAllSatellites(AmmoData* result, uint32_t resultlen, UniverseID defensibleid);
	uint32_t GetCompSlotPlayerActions(UIAction* result, uint32_t resultlen, UIComponentSlot compslot);
	Coord2D GetCompSlotScreenPos(UIComponentSlot compslot);
	UniverseID GetContextByClass(UniverseID componentid, const char* classname, bool includeself);
	uint32_t GetDefensibleDPS(DPSData* result, UniverseID defensibleid, bool primary, bool secondary, bool lasers, bool missiles, bool turrets, bool includeheat, bool includeinactive);
	float GetDistanceBetween(UniverseID component1id, UniverseID component2id);
	uint32_t GetDockedShips(UniverseID* result, uint32_t resultlen, UniverseID dockingbayorcontainerid, const char* factionid);
	uint32_t GetFormationShapes(UIFormationInfo* result, uint32_t resultlen);
	uint32_t GetHQs(UniverseID* result, uint32_t resultlen, const char* factionid);
	LastAttackerInfo GetLastAttackInfo(UniverseID destructibleid);
	uint32_t GetMineablesAtSectorPos(YieldInfo* result, uint32_t resultlen, UniverseID sectorid, Coord3D position);
	void GetMissionDeliveryWares(MissionWareDeliveryInfo* result, MissionID missionid);
	uint32_t GetMissionThreadSubMissions(MissionID* result, uint32_t resultlen, MissionID missionid);
	MonitorExtents GetMonitorExtents(const char* monitorid);
	uint32_t GetNumAllLaserTowers(UniverseID defensibleid);
	uint32_t GetNumAllMines(UniverseID defensibleid);
	uint32_t GetNumAllRoles(void);
	uint32_t GetNumAllNavBeacons(UniverseID defensibleid);
	uint32_t GetNumAllResourceProbes(UniverseID defensibleid);
	uint32_t GetNumAllSatellites(UniverseID defensibleid);
	uint32_t GetNumCompSlotPlayerActions(UIComponentSlot compslot);
	uint32_t GetNumDockedShips(UniverseID dockingbayorcontainerid, const char* factionid);
	uint32_t GetNumFormationShapes(void);
	uint32_t GetNumHQs(const char* factionid);
	uint32_t GetNumMineablesAtSectorPos(UniverseID sectorid, Coord3D position);
	uint32_t GetNumMissionThreadSubMissions(MissionID missionid);
	uint32_t GetNumObjectsWithSyncPoint(uint32_t syncid, bool onlyreached);
	uint32_t GetNumObjectsWithSyncPointFromOrder(UniverseID controllableid, size_t idx, bool onlyreached);
	uint32_t GetNumOrderDefinitions(void);
	uint32_t GetNumRequestedMissionNPCs(UniverseID containerid);
	uint32_t GetNumRequestedMissionWares(UniverseID containerid);
	uint32_t GetNumStoredUnits(UniverseID defensibleid, const char* cat, bool virtualammo);
	uint32_t GetNumSubordinatesOfGroup(UniverseID commanderid, int group);
	uint32_t GetNumUpgradeGroups(UniverseID destructibleid, const char* macroname);
	size_t GetNumUpgradeSlots(UniverseID destructibleid, const char* macroname, const char* upgradetypename);
	uint32_t GetNumVenturePlatformDocks(UniverseID ventureplatformid);
	uint32_t GetNumVenturePlatforms(UniverseID defensibleid);
	uint32_t GetNumWares(const char* tags, bool research, const char* licenceownerid, const char* exclusiontags);
	UIPosRot GetObjectPositionInSector(UniverseID objectid);
	uint32_t GetOrderDefinitions(OrderDefinition* result, uint32_t resultlen);
	UniverseID GetPlayerContainerID(void);
	UniverseID GetPlayerID(void);
	UniverseID GetPlayerOccupiedShipID(void);
	uint32_t GetRequestedMissionWares(MissionWareDeliveryCounts* result, uint32_t resultlen, UniverseID containerid);
	const char* GetSubordinateGroupAssignment(UniverseID controllableid, int group);
	uint32_t GetSubordinatesOfGroup(UniverseID* result, uint32_t resultlen, UniverseID commanderid, int group);
	bool GetSyncPointAutoRelease(uint32_t syncid, bool checkall);
	bool GetSyncPointAutoReleaseFromOrder(UniverseID controllableid, size_t orderidx, bool checkall);
	Position2D GetUIAnchorScreenPosition(const char* presentationid, uint32_t index, PosRot additionaloffset);
	uint32_t GetUpgradeGroups2(UpgradeGroup2* result, uint32_t resultlen, UniverseID destructibleid, const char* macroname);
	UniverseID GetUpgradeSlotCurrentComponent(UniverseID destructibleid, const char* upgradetypename, size_t slot);
	UpgradeGroup GetUpgradeSlotGroup(UniverseID destructibleid, const char* macroname, const char* upgradetypename, size_t slot);
	float GetTextWidth(const char*const text, const char*const fontname, const float fontsize);
	UniverseID GetTopLevelContainer(UniverseID componentid);
	UniverseID GetTowedObject(UniverseID shipid);
	uint32_t GetVenturePlatformDocks(UniverseID* result, uint32_t resultlen, UniverseID ventureplatformid);
	uint32_t GetVenturePlatforms(UniverseID* result, uint32_t resultlen, UniverseID defensibleid);
	uint32_t GetWares(const char** result, uint32_t resultlen, const char* tags, bool research, const char* licenceownerid, const char* exclusiontags);
	bool HasContainerFreeInternalShipStorage(UniverseID containerid, UniverseID shipid);
	bool HasContainerProcessingModule(UniverseID containerid);
	bool HasSubordinateAssignment(UniverseID controllableid, const char* assignment);
	bool HasVenturerDock(UniverseID containerid, UniverseID shipid, UniverseID ventureplatformid);
	bool IsBuilderBusy(UniverseID shipid);
	bool IsComponentWrecked(const UniverseID componentid);
	bool IsDefensibleBeingBoardedBy(UniverseID defensibleid, const char* factionid);
	bool IsExternalViewDisabled();
	bool IsMissionLimitReached(bool includeupkeep, bool includeguidance, bool includeplot);
	bool IsMouseEmulationActive(void);
	bool IsObjectKnown(const UniverseID componentid);
	bool IsOrderLoopable(const char* orderdefid);
	bool IsPlayerCameraTargetViewPossible(UniverseID targetid, bool force);
	bool IsShipAtExternalDock(UniverseID shipid);
	bool IsSurfaceElement(const UniverseID componentid);
	bool IsUnit(UniverseID controllableid);
	void LaunchLaserTower(UniverseID defensibleid, const char* lasertowermacroname);
	void LaunchMine(UniverseID defensibleid, const char* minemacroname);
	void LaunchNavBeacon(UniverseID defensibleid, const char* navbeaconmacroname);
	void LaunchResourceProbe(UniverseID defensibleid, const char* resourceprobemacroname);
	void LaunchSatellite(UniverseID defensibleid, const char* satellitemacroname);
	void MakePlayerOwnerOf(UniverseID objectid);
	void MovePlayerToSectorPos(UniverseID sectorid, UIPosRot position);
	void NotifyInteractMenuHidden(const uint32_t id, const bool allclosed);
	void NotifyInteractMenuShown(const uint32_t id);
	bool PerformCompSlotPlayerAction(UIComponentSlot compslot, uint32_t actionid);
	void PutShipIntoStorage(UniverseID containerid, UniverseID shipid);
	void ReleaseOrderSyncPoint(uint32_t syncid);
	void ReleaseOrderSyncPointFromOrder(UniverseID controllableid, size_t idx);
	bool RemoveCommander2(UniverseID controllableid);
	bool RemoveOrder(UniverseID controllableid, size_t idx, bool playercancelled, bool checkonly);
	bool RequestDockAt(UniverseID containerid, bool checkonly);
	const char* RequestDockAtReason(UniverseID containerid, bool checkonly);
	bool RequestShipFromInternalStorage2(UniverseID shipid, bool highpriority, UniverseID refcomponentid);
	void ResetOrderLoop(UniverseID controllableid);
	void SelfDestructComponent(UniverseID componentid);
	void SetAllDronesArmed(UniverseID defensibleid, bool arm);
	void SetDockingBayReservation(UniverseID dockingbayid, double duration);
	UIFormationInfo SetFormationShape(UniverseID objectid, const char* formationshape);
	void SetGroupAndAssignment(UniverseID controllableid, int group, const char* assignment);
	void SetGuidance(UniverseID componentid, UIPosRot offset);
	void SetPlayerCameraCinematicView(UniverseID componentid);
	void SetRelationBoostToFaction(UniverseID componentid, const char* factionid, const char* reasonid, float boostvalue, float decayrate, double decaydelay);
	bool SetSofttarget(UniverseID componentid, const char*const connectionname);
	void SetSubordinateGroupAttackOnSight(UniverseID controllableid, int group, bool value);
	void SetSubordinateGroupProtectedLocation(UniverseID controllableid, int group, UniverseID sectorid, UIPosRot offset);
	void SetSubordinateGroupReinforceFleet(UniverseID controllableid, int group, bool value);
	void SetSubordinateGroupResupplyAtFleet(UniverseID controllableid, int group, bool value);
	void SetSyncPointAutoRelease(uint32_t syncid, bool all, bool any);
	void SetSyncPointAutoReleaseFromOrder(UniverseID controllableid, size_t orderidx, bool all, bool any);
	void SetTrackedMenuFullscreen(const char* menu, bool fullscreen);
	bool ShouldSubordinateGroupAttackOnSight(UniverseID controllableid, int group);
	bool ShouldSubordinateGroupReinforceFleet(UniverseID controllableid, int group);
	bool ShouldSubordinateGroupResupplyAtFleet(UniverseID controllableid, int group);
	void SpawnObjectAtPos(const char* macroname, UniverseID sectorid, UIPosRot offset);
	void StartPlayerActivity(const char* activityid);
	void StopPlayerActivity(const char* activityid);
	bool TakeShipFromInternalStorage(UniverseID shipid, bool highpriority, bool checkonly);
	bool TeleportPlayerTo(UniverseID controllableid, bool allowcontrolling, bool instant, bool force);
]]

local utf8 = require("utf8")

local menu = {
	name = "InteractMenu",
	selectedRows = {},
	topRows = {},
	selectedplayerships = {},
}

local config = {
	layer = 2,
	width = 260,
	rowHeight = 16,
	entryFontSize = Helper.standardFontSize,
	entryX = 3,
	mouseOutRange = 100,
	border = Helper.frameBorder,
	subsectionDelay = 0.5,

	sections = {
		{ id = "main",					text = "",						isorder = false },
		{ id = "interaction",			text = ReadText(1001, 7865),	isorder = false },
		{ id = "hiringbuilderoption",	text = "",						isorder = false,	subsections = {
			{ id = "hiringbuilder",		text = ReadText(1001, 7873) },
			{ id = "assigningbuilder",	text = ReadText(1001, 11141) },
		}},
		{ id = "trade",					text = ReadText(1001, 7104),	isorder = false },

		-- mycu start: add custom actions group
		{ id = "custom_actions",	text = ReadText(101475, 100),		isorder = false,	subsections = {}},
		-- mycu end: add custom actions group

		{ id = "playersquad_orders",	text = ReadText(1001, 1002),	isorder = false },	-- Broadcast
		{ id = "overrideorderoption",	text = ReadText(1001, 11118),	isorder = false,	subsections = {
			{ id = "overrideorder",		text = ReadText(1001, 11248) },
		}},
		{ id = "main_orders",			text = ReadText(1001, 7802),	isorder = false },
		{ id = "formationshapeoption",	text = "",						isorder = false,	subsections = {
			{ id = "formationshape",	text = ReadText(1001, 7862) },
		}},
		{ id = "main_assignments",		text = ReadText(1001, 7803),	isorder = false },
		{ id = "main_assignments_subsections",	text = ReadText(1001, 7805),	isorder = false,	subsections = {
			{ id = "main_assignments_defence",				text = ReadText(20208, 40304),	helpOverlayID = "interactmenu_change_assign_defence",				helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "main_assignments_positiondefence",		text = ReadText(20208, 41504),	helpOverlayID = "interactmenu_change_assign_positiondefence",		helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "main_assignments_attack",				text = ReadText(20208, 40904),	helpOverlayID = "interactmenu_change_assign_attack",				helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "main_assignments_interception",			text = ReadText(20208, 41004),	helpOverlayID = "interactmenu_change_assign_interception",			helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "main_assignments_bombardment",			text = ReadText(20208, 41604),	helpOverlayID = "interactmenu_change_assign_bombardment",			helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "main_assignments_follow",				text = ReadText(20208, 41304),	helpOverlayID = "interactmenu_change_assign_follow",				helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "main_assignments_supplyfleet",			text = ReadText(20208, 40704),	helpOverlayID = "interactmenu_change_assign_supplyfleet",			helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "main_assignments_mining",				text = ReadText(20208, 40204),	helpOverlayID = "interactmenu_change_assign_mining",				helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "main_assignments_trade",				text = ReadText(20208, 40104),	helpOverlayID = "interactmenu_change_assign_trade",					helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "main_assignments_tradeforbuildstorage",	text = ReadText(20208, 40804),	helpOverlayID = "interactmenu_change_assign_tradeforbuildstorage",	helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "main_assignments_assist",				text = ReadText(20208, 41204),	helpOverlayID = "interactmenu_change_assign_assist",				helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "main_assignments_salvage",				text = ReadText(20208, 41404),	helpOverlayID = "interactmenu_change_assign_salvage",				helpOverlayText = " ",	helpOverlayHighlightOnly = true },
		}},
		{ id = "order",					text = "",						isorder = nil },
		{ id = "syncpoint",				text = "",						isorder = nil },
		{ id = "intersectordefencegroup",	text = "",					isorder = nil },
		{ id = "guidance",				text = "",						isorder = nil,		isplayerinteraction = true },
		{ id = "player_interaction",	text = ReadText(1001, 7843),	isorder = false,	isplayerinteraction = true },
		{ id = "consumables",			text = ReadText(1001, 7846),	isorder = false,	subsections = {
			{ id = "consumables_civilian",	text = ReadText(1001, 7847) },
			{ id = "consumables_military",	text = ReadText(1001, 7848) },
		}},
		{ id = "venturereport",			text = ReadText(1001, 12110),	isorder = false },
		{ id = "cheats",				text = "Cheats",				isorder = false }, -- (cheat only)
		{ id = "selected_orders_all",	text = ReadText(1001, 7804),	isorder = true,		showloop = true },
		{ id = "selected_orders",		text = ReadText(1001, 7804),	isorder = true,		showloop = true },
		{ id = "mining_orders",			text = "",						isorder = true,		showloop = true,		subsections = {
			{ id = "mining",			text = "\27[order_miningplayer] " .. ReadText(1041, 351), helpOverlayID = "interactmenu_mining", helpOverlayText = " ", helpOverlayHighlightOnly = true },
		}},
		{ id = "venturedockoption",		text = "",						isorder = true,		showloop = true,		subsections = {
			{ id = "venturedock",	text = "\27[order_dockandwait] " .. ReadText(1001, 7844) },
		}},
		{ id = "selected_disable",	text = "",	isorder = true,		subsections = {
			{ id = "selected_disable_attack",		text = ReadText(1001, 11128),	orderid = "Attack" },
		}},
		{ id = "trade_orders",			text = ReadText(1001, 7861),	isorder = true,		showloop = true },

		-- mycu start: add custom orders group
		{ id = "custom_orders",	text = ReadText(101475, 101),		isorder = true,	showloop = true, subsections = {}},
		-- mycu end: add custom orders group

		{ id = "selected_assignments_all", text = ReadText(1001, 7886),	isorder = true },
		{ id = "selected_change_assignments",	text = ReadText(1001, 11119),	isorder = true,		subsections = {
			{ id = "selected_change_assignments_defence",				text = ReadText(20208, 40304),	helpOverlayID = "interactmenu_change_assign_defence",				helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "selected_change_assignments_positiondefence",		text = ReadText(20208, 41504),	helpOverlayID = "interactmenu_change_assign_positiondefence",		helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "selected_change_assignments_attack",				text = ReadText(20208, 40904),	helpOverlayID = "interactmenu_change_assign_attack",				helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "selected_change_assignments_interception",			text = ReadText(20208, 41004),	helpOverlayID = "interactmenu_change_assign_interception",			helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "selected_change_assignments_bombardment",			text = ReadText(20208, 41604),	helpOverlayID = "interactmenu_change_assign_bombardment",			helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "selected_change_assignments_follow",				text = ReadText(20208, 41304),	helpOverlayID = "interactmenu_change_assign_follow",				helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "selected_change_assignments_supplyfleet",			text = ReadText(20208, 40704),	helpOverlayID = "interactmenu_change_assign_supplyfleet",			helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "selected_change_assignments_mining",				text = ReadText(20208, 40204),	helpOverlayID = "interactmenu_change_assign_mining",				helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "selected_change_assignments_trade",					text = ReadText(20208, 40104),	helpOverlayID = "interactmenu_change_assign_trade",					helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "selected_change_assignments_tradeforbuildstorage",	text = ReadText(20208, 40804),	helpOverlayID = "interactmenu_change_assign_tradeforbuildstorage",	helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "selected_change_assignments_assist",				text = ReadText(20208, 41204),	helpOverlayID = "interactmenu_change_assign_assist",				helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "selected_change_assignments_salvage",				text = ReadText(20208, 41404),	helpOverlayID = "interactmenu_change_assign_salvage",				helpOverlayText = " ",	helpOverlayHighlightOnly = true },
		}},
		{ id = "selected_assignments",	text = ReadText(1001, 7805),	isorder = true,		subsections = {
			{ id = "selected_assignments_defence",				text = ReadText(20208, 40304),	helpOverlayID = "interactmenu_assign_defence",				helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "selected_assignments_positiondefence",		text = ReadText(20208, 41504),	helpOverlayID = "interactmenu_assign_positiondefence",		helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "selected_assignments_attack",				text = ReadText(20208, 40904),	helpOverlayID = "interactmenu_assign_attack",				helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "selected_assignments_interception",			text = ReadText(20208, 41004),	helpOverlayID = "interactmenu_assign_interception",			helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "selected_assignments_bombardment",			text = ReadText(20208, 41604),	helpOverlayID = "interactmenu_assign_bombardment",			helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "selected_assignments_follow",				text = ReadText(20208, 41304),	helpOverlayID = "interactmenu_assign_follow",				helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "selected_assignments_supplyfleet",			text = ReadText(20208, 40704),	helpOverlayID = "interactmenu_assign_supplyfleet",			helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "selected_assignments_mining",				text = ReadText(20208, 40204),	helpOverlayID = "interactmenu_assign_mining",				helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "selected_assignments_trade",				text = ReadText(20208, 40104),	helpOverlayID = "interactmenu_assign_trade",				helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "selected_assignments_tradeforbuildstorage",	text = ReadText(20208, 40804),	helpOverlayID = "interactmenu_assign_tradeforbuildstorage",	helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "selected_assignments_assist",				text = ReadText(20208, 41204),	helpOverlayID = "interactmenu_assign_assist",				helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "selected_assignments_salvage",				text = ReadText(20208, 41404),	helpOverlayID = "interactmenu_assign_salvage",				helpOverlayText = " ",	helpOverlayHighlightOnly = true },
		}},
		{ id = "selected_consumables",	text = ReadText(1001, 7849),	isorder = true,		subsections = {
			{ id = "selected_consumables_civilian",	text = "\27[order_deployobjectatposition] " .. ReadText(1001, 7847) },
			{ id = "selected_consumables_military",	text = "\27[order_deployobjectatposition] " .. ReadText(1001, 7848) },
		}},
		{ id = "shipconsole",			text = "",						isorder = false },
	},

	assignments = {
		["defence"]					= { name = ReadText(20208, 40304) },
		["positiondefence"]			= { name = ReadText(20208, 41504) },
		["attack"]					= { name = ReadText(20208, 40904) },
		["interception"]			= { name = ReadText(20208, 41004) },
		["bombardment"]				= { name = ReadText(20208, 41604) },
		["follow"]					= { name = ReadText(20208, 41304) },
		["supplyfleet"]				= { name = ReadText(20208, 40704) },
		["mining"]					= { name = ReadText(20208, 40204) },
		["trade"]					= { name = ReadText(20208, 40104) },
		["tradeforbuildstorage"]	= { name = ReadText(20208, 40804) },
		["assist"]					= { name = ReadText(20208, 41204) },
		["salvage"]					= { name = ReadText(20208, 41401) },
	},
}

-- kuertee start:
local callbacks = {}
-- kuertee end

local function init()
	Menus = Menus or { }
	table.insert(Menus, menu)
	if Helper then
		Helper.registerMenu(menu)
	end

	RegisterEvent("hideInteractMenu", function () menu.onCloseElement("auto") end)

	-- kuertee start:
	menu.init_kuertee()
	-- kuertee end
end

-- kuertee start:
function menu.init_kuertee ()
	RegisterEvent ("Interact_Menu_API.Add_Custom_Actions_Group_Id", menu.Add_Custom_Actions_Group_Id)
	RegisterEvent ("Interact_Menu_API.Add_Custom_Actions_Group_Text", menu.Add_Custom_Actions_Group_Text)
	if Helper.modLuas[menu.name] then
		if not next(Helper.modLuas[menu.name].failedByExtension) then
			-- DebugError("uix init success: " .. tostring(debug.getinfo(1).source))
		else
			for extension, modLua in pairs(Helper.modLuas[menu.name].failedByExtension) do
				DebugError("uix init failed: " .. tostring(debug.getinfo(modLua.init).source):gsub("@.\\", ""))
			end
		end
	else
		-- DebugError("uix init success: " .. tostring(debug.getinfo(1).source))
	end
end
-- kuertee end

function menu.cleanup()
	menu.mode = nil
	menu.interactMenuID = nil
	menu.componentSlot = nil
	menu.connection = nil
	menu.componentOrder = nil
	menu.syncpoint = nil
	menu.syncpointorder = nil
	menu.intersectordefencegroup = nil
	menu.mission = nil
	menu.componentMissions = nil
	menu.missionoffer = nil
	menu.construction = nil
	menu.subordinategroup = nil
	menu.selectedplayerships = {}
	menu.selectedotherobjects = {}
	menu.selectedplayerdeployables = {}
	menu.playerSquad = {}
	menu.removedOccupiedPlayerShip = nil
	menu.showPlayerInteractions = nil
	menu.offsetcomponent = nil
	menu.offset = nil
	menu.mouseX = nil
	menu.mouseY = nil
	menu.dockingbayReserveTime = nil
	menu.isdockedship = nil
	menu.shipswithcurrentcommander = {}
	menu.groupShips = {}

	menu.subsection = nil
	menu.pendingSubSection = nil
	menu.possibleorders = {}
	menu.numdockingpossible = nil
	menu.numremovableorders = nil
	menu.numwaitingforsignal = nil
	menu.numdockingatplayerpossible = nil
	menu.numshipswithcommander = nil
	menu.actions = {}
	menu.holomapcolor = {}
	menu.texts = {}
	menu.colors = {}

	menu.contentTable = nil
	menu.currentOverTable = nil
	menu.selectedRows = {}
	menu.topRows = {}
	menu.mouseOutBox = {}
	menu.wasMonitorAdjusted = {}
	menu.forceSubSectionToLeft = nil

	Helper.ffiClearNewHelper()

	-- kurtee start: multi-rename
	menu.uix_multiRename_removedActionTarget = nil
	-- kurtee end: multi-rename
end

-- perform helpers

function menu.orderAssignCommander(component, commander, assignment, group)
	if (not C.IsOrderSelectableFor("AssignCommander", component)) or (not GetComponentData(component, "assignedpilot")) then
		return
	end

	local orderindex = C.CreateOrder(component, "AssignCommander", false)
	if orderindex > 0 then
		-- commander
		SetOrderParam(component, orderindex, 1, nil, ConvertStringToLuaID(tostring(commander)))
		-- assignment
		SetOrderParam(component, orderindex, 2, nil, assignment)
		-- subordinategroup
		SetOrderParam(component, orderindex, 3, nil, group)
		-- setgroupassignment
		SetOrderParam(component, orderindex, 4, nil, true)
		-- cancelorders
		SetOrderParam(component, orderindex, 5, nil, true)
		-- response
		SetOrderParam(component, orderindex, 6, nil, true)

		C.EnableOrder(component, orderindex)
		if orderindex ~= 1 then
			C.AdjustOrder(component, orderindex, 1, true, false, false)
		end
	end
end

function menu.orderAttack(component, target, clear, immediate)
	if (not C.IsOrderSelectableFor("Attack", component)) or (not GetComponentData(component, "assignedpilot")) then
		return
	end

	if clear then
		C.RemoveAllOrders(component)
	end
	local orderidx = C.CreateOrder3(component, "Attack", false, immediate, immediate)
	if orderidx > 0 then
		SetOrderParam(component, orderidx, 1, nil, ConvertStringToLuaID(tostring(target)))
		C.EnableOrder(component, orderidx)
		if immediate then
			menu.setOrderImmediate(component, orderidx)
		end
	end

	return orderidx
end

function menu.orderAttackInRange(component, sector, offset, clear)
	if (not C.IsOrderSelectableFor("AttackInRange", component)) or (not GetComponentData(component, "assignedpilot")) then
		return
	end

	if clear then
		C.RemoveAllOrders(component)
	end
	local orderidx = C.CreateOrder(component, "AttackInRange", false)
	if orderidx > 0 then
		SetOrderParam(component, orderidx, 1, nil, { ConvertStringToLuaID(tostring(sector)), {offset.x, offset.y, offset.z} } )
		C.EnableOrder(component, orderidx)
	end

	return orderidx
end

function menu.orderAttackSurfaceElements(component, target, targetclasses, clear)
	if (not C.IsOrderSelectableFor("Attack", component)) or (not GetComponentData(component, "assignedpilot")) then
		return
	end

	if clear then
		C.RemoveAllOrders(component)
	end

	local orderidx = C.CreateOrder(component, "Attack", false)
	if orderidx > 0 then
		-- primarytarget
		SetOrderParam(component, orderidx, 1, nil, ConvertStringToLuaID(tostring(target)))
		-- disable
		SetOrderParam(component, orderidx, 8, nil, true)
		-- disablehullpercentagethreshold
		SetOrderParam(component, orderidx, 9, nil, 100)
		-- behaviortargetclasses
		SetOrderParam(component, orderidx, 16, nil, targetclasses)
		-- debugchance
		--SetOrderParam(component, orderidx, 25, nil, 100)
		C.EnableOrder(component, orderidx)
		if immediate then
			menu.setOrderImmediate(component, orderidx)
		end
	end

	return orderidx
end

function menu.orderCollect(component, drop, sector, offset, clear)
	if (not C.IsOrderSelectableFor("Collect", component)) or (not GetComponentData(component, "assignedpilot")) then
		return
	end

	if clear then
		C.RemoveAllOrders(component)
	end
	local orderidx = C.CreateOrder(component, "Collect", false)
	if orderidx > 0 then
		SetOrderParam(component, orderidx, 1, 0, ConvertStringToLuaID(tostring(drop)) )
		C.EnableOrder(component, orderidx)
	end

	return orderidx
end

function menu.orderCollectDeployable(component, deployable, sector, offset, clear)
	if (not C.IsOrderSelectableFor("CollectDeployables", component)) or (not GetComponentData(component, "assignedpilot")) then
		return
	end

	if clear then
		C.RemoveAllOrders(component)
	end
	local orderidx = C.CreateOrder(component, "CollectDeployables", false)
	if orderidx > 0 then
		SetOrderParam(component, orderidx, 1, nil, ConvertStringToLuaID(tostring(deployable)))
		C.EnableOrder(component, orderidx)
	end

	return orderidx
end

function menu.orderCollectLockbox(component, lockbox, clear)
	if (not C.IsOrderSelectableFor("CollectLockbox", component)) or (not GetComponentData(component, "assignedpilot")) then
		return
	end

	if clear then
		C.RemoveAllOrders(component)
	end
	local orderidx = C.CreateOrder(component, "CollectLockbox", false)
	if orderidx > 0 then
		SetOrderParam(component, orderidx, 1, 0, ConvertStringToLuaID(tostring(lockbox)) )
		C.EnableOrder(component, orderidx)
	end

	return orderidx
end

function menu.orderCollectRadius(component, sector, offset, clear)
	if (not C.IsOrderSelectableFor("CollectDropsInRadius", component)) or (not GetComponentData(component, "assignedpilot")) then
		return
	end

	if clear then
		C.RemoveAllOrders(component)
	end
	local orderidx = C.CreateOrder(component, "CollectDropsInRadius", false)
	if orderidx > 0 then
		SetOrderParam(component, orderidx, 1, nil, { ConvertStringToLuaID(tostring(sector)), {offset.x, offset.y, offset.z} } )
		C.EnableOrder(component, orderidx)
	end

	return orderidx
end

function menu.orderDeployAtPosition(component, sector, offset, macro, amount, clear)
	if (not C.IsOrderSelectableFor("DeployObjectAtPosition", component)) or (not GetComponentData(component, "assignedpilot")) then
		return
	end

	if clear then
		C.RemoveAllOrders(component)
	end
	local orderidx = C.CreateOrder(component, "DeployObjectAtPosition", false)
	if orderidx > 0 then
		SetOrderParam(component, orderidx, 1, nil, { ConvertStringToLuaID(tostring(sector)), {offset.x, offset.y, offset.z} } )
		SetOrderParam(component, orderidx, 2, 0, macro )
		SetOrderParam(component, orderidx, 3, 0, amount )

		C.EnableOrder(component, orderidx)
	end

	return orderidx
end

function menu.orderDeployToStation(component, station, clear)
	if (not C.IsOrderSelectableFor("DeployToStation", component)) or (not GetComponentData(component, "assignedpilot")) then
		return
	end

	if clear then
		C.RemoveAllOrders(component)
	end
	local orderidx = C.CreateDeployToStationOrder(component)
	if orderidx > 0 then
		SetOrderParam(component, orderidx, 1, nil, ConvertStringToLuaID(tostring(station)))
		C.EnableOrder(component, orderidx)
	end
end

function menu.orderDepositInventoryAtHQ(component, clear)
	if (not C.IsOrderSelectableFor("DepositInventory", component)) or (not GetComponentData(ConvertStringTo64Bit(tostring(component)), "assignedpilot")) then
		return
	end

	if clear then
		C.RemoveAllOrders(component)
	end
	local orderidx = C.CreateOrder(component, "DepositInventory", false)
	if orderidx > 0 then
		-- we can optionally set a destination here, but we only support transferring inventory items to/from the player HQ at the moment using this method. order defaults to deposit at the player HQ, if it exists.
		C.EnableOrder(component, orderidx)
	end

	return orderidx
end

function menu.orderDock(component, target, clear, ventureplatform)
	if (not C.IsOrderSelectableFor("DockAndWait", component)) or (not GetComponentData(component, "assignedpilot")) then
		return
	end

	if clear then
		C.RemoveAllOrders(component)
	end
	local orderidx = C.CreateOrder(component, "DockAndWait", false)
	if orderidx > 0 then
		SetOrderParam(component, orderidx, 1, nil, ConvertStringToLuaID(tostring(target)))
		if ventureplatform then
			SetOrderParam(component, orderidx, 5, nil, ConvertStringToLuaID(tostring(ventureplatform)))
		end
		C.EnableOrder(component, orderidx)
	end

	return orderidx
end

function menu.orderExplore(component, sectororgate, sector, offset, clear)
	if (not C.IsOrderSelectableFor("Explore", component)) or (not GetComponentData(component, "assignedpilot")) then
		return
	end

	if clear then
		C.RemoveAllOrders(component)
	end
	local orderidx = C.CreateOrder(component, "Explore", false)
	if orderidx > 0 then
		SetOrderParam(component, orderidx, 1, nil, ConvertStringToLuaID(tostring(sectororgate)) )
		if C.IsComponentClass(sectororgate, "sector") or (C.IsComponentClass(sectororgate, "gate") and (not GetComponentData(ConvertStringTo64Bit(tostring(menu.componentSlot.component)), "isactive"))) then
			SetOrderParam(component, orderidx, 2, nil, { ConvertStringToLuaID(tostring(sector)), {offset.x, offset.y, offset.z} } )
		end
		C.EnableOrder(component, orderidx)
	end

	return orderidx
end

function menu.orderExploreUpdate(component, sectororgate, sector, offset, clear)
	if (not C.IsOrderSelectableFor("ExploreUpdate", component)) or (not GetComponentData(component, "assignedpilot")) then
		return
	end

	if clear then
		C.RemoveAllOrders(component)
	end
	local orderidx = C.CreateOrder(component, "ExploreUpdate", false)
	if orderidx > 0 then
		SetOrderParam(component, orderidx, 1, nil, ConvertStringToLuaID(tostring(sectororgate)) )
		if C.IsComponentClass(sectororgate, "sector") or (C.IsComponentClass(sectororgate, "gate") and (not GetComponentData(ConvertStringTo64Bit(tostring(menu.componentSlot.component)), "isactive"))) then
			SetOrderParam(component, orderidx, 2, nil, { ConvertStringToLuaID(tostring(sector)), {offset.x, offset.y, offset.z} } )
		end
		C.EnableOrder(component, orderidx)
	end

	return orderidx
end

function menu.orderFollow(component, targetobject, clear)
	if (not C.IsOrderSelectableFor("Follow", component)) or (not GetComponentData(component, "assignedpilot")) then
		return
	end

	if clear then
		C.RemoveAllOrders(component)
	end
	local orderidx = C.CreateOrder(component, "Follow", false)
	if orderidx > 0 then
		SetOrderParam(component, orderidx, 1, nil, ConvertStringToLuaID(tostring(targetobject)))
		C.EnableOrder(component, orderidx)
	end

	return orderidx
end

function menu.orderGetSupplies(component, clear)
	if (not C.IsOrderSelectableFor("GetSupplies", component)) or (not GetComponentData(ConvertStringTo64Bit(tostring(component)), "assignedpilot")) then
		return
	end

	if clear then
		C.RemoveAllOrders(component)
	end
	local orderidx = C.CreateOrder(component, "GetSupplies", false)
	if orderidx > 0 then
		C.EnableOrder(component, orderidx)
	end

	return orderidx
end

function menu.orderMining(component, ware, sector, offset, clear)
	if (not C.IsOrderSelectableFor("MiningPlayer", component)) or (not GetComponentData(component, "assignedpilot")) then
		return
	end

	if clear then
		C.RemoveAllOrders(component)
	end
	local orderidx
	if GetWareCapacity(component, ware, true) > 0 then
		orderidx = C.CreateOrder(component, "MiningPlayer", false)
		if orderidx > 0 then
			SetOrderParam(component, orderidx, 1, nil, { ConvertStringToLuaID(tostring(sector)), {offset.x, offset.y,offset.z} })
			SetOrderParam(component, orderidx, 3, nil, ware)
			C.EnableOrder(component, orderidx)
		end
	end

	return orderidx
end

function menu.orderMoveWait(component, sector, offset, targetobject, playerprecise, clear)
	if (not C.IsOrderSelectableFor("MoveWait", component)) or (not GetComponentData(component, "assignedpilot")) then
		return
	end

	if clear then
		C.RemoveAllOrders(component)
	end
	local orderidx
	if not C.IsComponentClass(targetobject, "sector") then
		orderidx = C.CreateOrder(component, "MoveToObject", false)
		if orderidx > 0 then
			SetOrderParam(component, orderidx, 1, nil, ConvertStringToLuaID(tostring(targetobject)))
		end
	else
		orderidx = C.CreateOrder(component, "MoveWait", false)
		if orderidx > 0 then
			SetOrderParam(component, orderidx, 1, nil, { ConvertStringToLuaID(tostring(sector)), {offset.x, offset.y,offset.z} })
			if playerprecise then
				SetOrderParam(component, orderidx, 5, nil, true)
			end
		end
	end
	if orderidx > 0 then
		C.EnableOrder(component, orderidx)
	end

	return orderidx
end

function menu.orderPlayerDockToTrade(component, target, clear)
	if (not C.IsOrderSelectableFor("Player_DockToTrade", component)) or (not GetComponentData(component, "assignedpilot")) then
		return
	end

	if clear then
		C.RemoveAllOrders(component)
	end
	local orderidx = C.CreateOrder(component, "Player_DockToTrade", false)
	if orderidx > 0 then
		SetOrderParam(component, orderidx, 1, nil, ConvertStringToLuaID(tostring(target)))
		C.EnableOrder(component, orderidx)
	end

	return orderidx
end

function menu.orderProtect(component, target, clear)
	if (not C.IsOrderSelectableFor("ProtectStation", component)) or (not GetComponentData(component, "assignedpilot")) then
		return
	end

	if clear then
		C.RemoveAllOrders(component)
	end
	local orderidx = C.CreateOrder(component, "ProtectStation", false)
	if orderidx > 0 then
		SetOrderParam(component, orderidx, 1, nil, ConvertStringToLuaID(tostring(target)))
		C.EnableOrder(component, orderidx)
	end

	return orderidx
end

function menu.orderRemove(ship, removedefaultorder, removeassignment, removedockorder)
	local numorders = C.GetNumOrders(ship)
	local currentorders = ffi.new("Order[?]", numorders)
	numorders = C.GetOrders(currentorders, numorders, ship)
	local assigncommanderfound = false
	for i = numorders, 1, -1 do
		local isdocked, isdocking = GetComponentData(ConvertStringTo64Bit(tostring(ship)), "isdocked", "isdocking")
		local orderdef = ffi.string(currentorders[i - 1].orderdef)
		if (i == 1) and ((orderdef == "DockAndWait") and (isdocked or isdocking)) and (not removedockorder) then
			-- do nothing - removing the dock order would create an undock order ... rather have the ship stay put [Nick]
		elseif (not removeassignment) and (not assigncommanderfound) and (orderdef == "AssignCommander") then
			-- keep the last assign commander order unless we are removing assignments
			assigncommanderfound = true
		else
			C.RemoveOrder(ship, i, false, false)
		end
	end
	if removedefaultorder then
		C.ResetOrderLoop(ship)
		local currentdefaultorder = ffi.new("Order")
		if C.GetDefaultOrder(currentdefaultorder, ship) then
			if (ffi.string(currentdefaultorder.orderdef) ~= "Wait") and (ffi.string(currentdefaultorder.orderdef) ~= "DockAndWait") then
				C.CreateOrder(ship, "Wait", true)
				C.EnablePlannedDefaultOrder(ship, false)
			end
		end
	end
	if removeassignment then
		C.RemoveCommander2(ship)
		C.CreateOrder(ship, "Wait", true)
		C.EnablePlannedDefaultOrder(ship, false)
	end
end

function menu.orderRescueInRange(component, sector, offset, clear)
	if (not C.IsOrderSelectableFor("RescueInRange", component)) or (not GetComponentData(component, "assignedpilot")) then
		return
	end

	if clear then
		C.RemoveAllOrders(component)
	end
	local orderidx = C.CreateOrder(component, "RescueInRange", false)
	if orderidx > 0 then
		SetOrderParam(component, orderidx, 1, nil, { ConvertStringToLuaID(tostring(sector)), {offset.x, offset.y, offset.z} } )
		C.EnableOrder(component, orderidx)
	end

	return orderidx
end

function menu.orderRescueShip(component, targetobject, clear)
	if (not C.IsOrderSelectableFor("RescueShip", component)) or (not GetComponentData(component, "assignedpilot")) then
		return
	end

	if clear then
		C.RemoveAllOrders(component)
	end
	local orderidx = C.CreateOrder(component, "RescueShip", false)
	if orderidx > 0 then
		SetOrderParam(component, orderidx, 1, nil, ConvertStringToLuaID(tostring(targetobject)))
		C.EnableOrder(component, orderidx)
	end

	return orderidx
end

function menu.orderSalvageCollect(component, target, clear)
	if (not C.IsOrderSelectableFor("SalvageCollect", component)) or (not GetComponentData(component, "assignedpilot")) then
		return
	end

	if clear then
		C.RemoveAllOrders(component)
	end
	local orderidx = C.CreateOrder(component, "SalvageCollect", false)
	if orderidx > 0 then
		SetOrderParam(component, orderidx, 1, nil, ConvertStringToLuaID(tostring(target)))
		C.EnableOrder(component, orderidx)
	end

	return orderidx
end

function menu.orderSalvageCrush(component, target, clear)
	if (not C.IsOrderSelectableFor("SalvageCrush", component)) or (not GetComponentData(component, "assignedpilot")) then
		return
	end

	if clear then
		C.RemoveAllOrders(component)
	end
	local orderidx = C.CreateOrder(component, "SalvageCrush", false)
	if orderidx > 0 then
		SetOrderParam(component, orderidx, 1, nil, ConvertStringToLuaID(tostring(target)))
		C.EnableOrder(component, orderidx)
	end

	return orderidx
end

function menu.orderSalvageDeliver(component, target, tradeoffer, amount, clear)
	if (not C.IsOrderSelectableFor("SalvageDeliver", component)) or (not GetComponentData(component, "assignedpilot")) then
		return
	end

	if clear then
		C.RemoveAllOrders(component)
	end
	AddTradeToShipQueue(tradeoffer, ConvertStringTo64Bit(tostring(component)), amount, false, true)
end

function menu.orderSalvageDeliver_NoTrade(component, target, clear)
	if (not C.IsOrderSelectableFor("SalvageDeliver_NoTrade", component)) or (not GetComponentData(component, "assignedpilot")) then
		return
	end

	if clear then
		C.RemoveAllOrders(component)
	end
	local orderidx = C.CreateOrder(component, "SalvageDeliver_NoTrade", false)
	if orderidx > 0 then
		SetOrderParam(component, orderidx, 1, nil, ConvertStringToLuaID(tostring(target)))
		C.EnableOrder(component, orderidx)
	end

	return orderidx
end

function menu.orderSalvageInRadius(component, sector, offset, clear)
	if (not C.IsOrderSelectableFor("SalvageInRadius", component)) or (not GetComponentData(component, "assignedpilot")) then
		return
	end

	if clear then
		C.RemoveAllOrders(component)
	end
	local orderidx = C.CreateOrder(component, "SalvageInRadius", false)
	if orderidx > 0 then
		SetOrderParam(component, orderidx, 1, nil, { ConvertStringToLuaID(tostring(sector)), {offset.x, offset.y, offset.z} } )
		C.EnableOrder(component, orderidx)
	end

	return orderidx
end

function menu.orderStopAndHoldFire(component, clear, immediate)
	if (not C.IsOrderSelectableFor("Wait", component)) or (not GetComponentData(component, "assignedpilot")) then
		return
	end

	if clear then
		C.RemoveAllOrders(component)
	end

	-- ship will stop and hold fire.
	-- params: 1: timeout, 2: allowdocked, 3: holdfire, 4: debugchance
	local orderidx = C.CreateOrder3(component, "Wait", false, immediate, immediate)
	if orderidx > 0 then
		SetOrderParam(component, orderidx, 1, nil, clear and 0 or 3600)
		SetOrderParam(component, orderidx, 3, nil, true)
		C.EnableOrder(component, orderidx)
		if immediate then
			menu.setOrderImmediate(component, orderidx)
		end
	end

	return orderidx
end

function menu.orderTacticalAttack(component, target, clear, immediate)
	if (not C.IsOrderSelectableFor("TacticalOrder", component)) or (not GetComponentData(component, "assignedpilot")) then
		return
	end

	if clear then
		C.RemoveAllOrders(component)
	end
	local orderidx = C.CreateOrder3(component, "TacticalOrder", false, immediate, immediate)
	if orderidx > 0 then
		SetOrderParam(component, orderidx, 1, nil, ConvertStringToLuaID(tostring(target)))
		C.EnableOrder(component, orderidx)
		if immediate then
			menu.setOrderImmediate(component, orderidx)
		end
	end

	return orderidx
end

function menu.orderWithdrawAndHold(component, clear, immediate)
	if (not C.IsOrderSelectableFor("MoveWait", component)) or (not GetComponentData(component, "assignedpilot")) then
		return
	end

	if clear then
		C.RemoveAllOrders(component)
	end

	local pos = ffi.new("UIPosRot")
	pos = C.GetObjectPositionInSector(component)
	local sectorid = GetComponentData(component, "sectorid")
	if sectorid then
		sectorid = ConvertIDTo64Bit(sectorid)
	end

	-- ship will hold fire and withdraw from combat, then hold position.
	-- params: 1: destination, 2: timeout, 3: withdraw, 4: debugchance
	local orderidx = C.CreateOrder3(component, "MoveWait", false, immediate, immediate)
	if orderidx > 0 then
		-- HACK: MoveWait requires a destination but does not use it when $withdraw is true
		SetOrderParam(component, orderidx, 1, nil, { ConvertStringToLuaID(tostring(sectorid)), {pos.x, pos.y, pos.z} })
		SetOrderParam(component, orderidx, 2, nil, clear and 0 or 3600)
		SetOrderParam(component, orderidx, 3, nil, true)
		C.EnableOrder(component, orderidx)
		if immediate then
			menu.setOrderImmediate(component, orderidx)
		end
	end

	return orderidx
end

function menu.orderWithdrawFromCombat(component, clear, immediate, attacker)
	local convertedComponent = ConvertStringTo64Bit(tostring(component))
	if (not C.IsOrderSelectableFor("Flee", convertedComponent)) or (not GetComponentData(convertedComponent, "assignedpilot")) then
		return
	end

	if clear then
		C.RemoveAllOrders(convertedComponent)
	end

	-- ship will hold fire and withdraw from combat.
	-- params: 1: method ('boost','maneuver','highway','dock'), 2: return, 3: donotdrop, 4: deploydistraction, 5: holdfire, 6: attacker, 7: maxboostdistance, 8: maxboostduration, 9: log, 10: debugchance
	local orderidx = C.CreateOrder3(convertedComponent, "Flee", false, immediate, immediate)
	if orderidx > 0 then
		SetOrderParam(convertedComponent, orderidx, 1, nil, 'boost')
		SetOrderParam(convertedComponent, orderidx, 3, nil, true)
		SetOrderParam(convertedComponent, orderidx, 4, nil, true)
		if attacker then
			SetOrderParam(convertedComponent, orderidx, 6, nil, ConvertStringToLuaID(tostring(attacker)))
		end
		C.EnableOrder(convertedComponent, orderidx)
		if immediate then
			menu.setOrderImmediate(convertedComponent, orderidx)
		end
	end

	return orderidx
end

-- other helpers

function menu.plotCourse(object, offset)
	local convertedObject = ConvertStringToLuaID(tostring(object))
	if (object == C.GetPlayerControlledShipID()) then
		return -- no plot course to playership or when menu.mode is set
	end

	if IsSameComponent(GetActiveGuidanceMissionComponent(), convertedObject) then
		C.EndGuidance()
	else
		if offset == nil then
			offset = ffi.new("UIPosRot", 0)
		elseif C.IsComponentClass(object, "sector") then
			object = C.GetZoneAt(object, offset)
		end
		C.SetGuidance(object, offset)
	end
end

function menu.canCollectCrates(haspilot)
	local iscapship = false
	local hascollector = false
	if haspilot then
		for _, ship in ipairs(menu.selectedplayerships) do
			iscapship = C.IsComponentClass(ship, "ship_l") or C.IsComponentClass(ship, "ship_xl")
			if iscapship then
				hascollector = (C.GetNumStoredUnits(ship, "transport", false) > 0)
			end

			if not iscapship or hascollector then
				break
			end
		end
	end

	local active = haspilot and (not iscapship or hascollector)
	local reason = ""
	if iscapship and not hascollector then
		reason = ReadText(1026, 20014)
	elseif not haspilot then
		reason = ReadText(1026, 7830)
	end
	--print("menu.canCollectCrates. active: " .. tostring(active) .. ", mouseovertext: " .. tostring(reason))
	return active, reason
end

function menu.canSalvage(haspilot)
	local istug = false
	local hasbuilder = false
	if haspilot then
		for _, ship in ipairs(menu.selectedplayerships) do
			istug = (GetComponentData(ship, "shiptype") == "tug")
			if not istug then
				hasbuilder = (C.GetNumStoredUnits(ship, "build", false) > 0)
			end

			if istug or hasbuilder then
				break
			end
		end
	end

	local active = haspilot and (istug or hasbuilder)
	local reason = ""
	if not istug and not hasbuilder then
		reason = ReadText(1026, 20029)
	elseif not haspilot then
		reason = ReadText(1026, 7830)
	end
	--print("menu.canSalvage. active: " .. tostring(active) .. ", mouseovertext: " .. tostring(reason))
	return active, reason
end

function menu.getCanCancelConstructionCount()
	local count = 0
	for _, id in ipairs(menu.construction.ids) do
		if C.CanCancelConstruction(menu.componentSlot.component, id) then
			count = count + 1
		end
	end
	return count
end

-- widget scripts

function menu.buttonActivateDeployables(isactive)
	for _, deployable in ipairs(menu.selectedplayerdeployables) do
		if GetComponentData(deployable, "isactive") == isactive then
			C.ActivateObject(deployable, not isactive)
		end
	end
	menu.onCloseElement("close")
end

function menu.buttonSelfDestructDeployables(selecteddeployable)
	if selecteddeployable then
		C.SelfDestructComponent(selecteddeployable)
	else
		for _, deployable in ipairs(menu.selectedplayerdeployables) do
			C.SelfDestructComponent(deployable)
		end
	end
	menu.onCloseElement("close")
end

function menu.buttonArmTurrets(armed)
	local convertedComponent = ConvertStringTo64Bit(tostring(menu.componentSlot.component))
	local isplayerownedtarget = GetComponentData(convertedComponent, "isplayerowned")

	if isplayerownedtarget and C.IsComponentClass(menu.componentSlot.component, "ship") and (not GetComponentData(ConvertStringTo64Bit(tostring(menu.componentSlot.component)), "isdeployable")) then
		C.SetAllTurretsArmed(menu.componentSlot.component, armed)
	end
	for _, ship in ipairs(menu.selectedplayerships) do
		C.SetAllTurretsArmed(ship, armed)
	end

	menu.onCloseElement("close")
end

function menu.buttonAssignCommander(assignment, group)
	local convertedComponent = ConvertStringTo64Bit(tostring(menu.componentSlot.component))
	local isplayerownedtarget = GetComponentData(convertedComponent, "isplayerowned")

	if menu.showPlayerInteractions or ((#menu.selectedplayerships == 0) and (not menu.shown)) then
		local playeroccupiedship = C.GetPlayerOccupiedShipID()
		local oldassignment = ffi.string(C.GetSubordinateGroupAssignment(playeroccupiedship, group))
		if assignment == "positiondefence" and oldassignment ~= "positiondefence" then
			Helper.setIntersectorDefence(ConvertStringTo64Bit(tostring(playeroccupiedship)), group)
		end

		C.ResetOrderLoop(menu.componentSlot.component)
		menu.orderAssignCommander(convertedComponent, playeroccupiedship, assignment, group)
	else
		if C.IsComponentClass(menu.componentSlot.component, "controllable") then
			local oldassignment = ffi.string(C.GetSubordinateGroupAssignment(menu.componentSlot.component, group))
			if assignment == "positiondefence" and oldassignment ~= "positiondefence" then
				Helper.setIntersectorDefence(convertedComponent, group)
			end

			for _, ship in ipairs(menu.selectedplayerships) do
				if (convertedComponent ~= ship) and isplayerownedtarget then
					local skip = false
					if not GetComponentData(ship, "assignedpilot") then
						skip = true
					elseif GetComponentData(ship, "primarypurpose") == "mine" then
						if assignment == "tradeforbuildstorage" then
							skip = true
						end
					else
						if assignment == "mining" then
							skip = true
						end
					end
					if not skip then
						C.ResetOrderLoop(ship)
						menu.orderAssignCommander(ship, menu.componentSlot.component, assignment, group)
					end
				end
			end
		end
	end

	if menu.shown then
		menu.onCloseElement("close")
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "refresh")
		menu.cleanup()
	end
end

function menu.buttonAttack(clear)
	for _, ship in ipairs(menu.selectedplayerships) do
		menu.orderAttack(ship, menu.componentSlot.component, clear, false)
	end

	menu.onCloseElement("close")
end

function menu.buttonAttackInRange()
	for _, ship in ipairs(menu.selectedplayerships) do
		menu.orderAttackInRange(ship, menu.offsetcomponent, menu.offset, clear)
	end

	menu.onCloseElement("close")
end

function menu.buttonAttackMultiple(clear)
	if not menu.shown then
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "attackmultiple", { ConvertStringTo64Bit(tostring(menu.componentSlot.component)), clear })
		menu.cleanup()
	end
end

function menu.buttonAttackSurfaceElements(target, targetclass, clear)
	local targetclasses = {}
	if targetclass == "all" then
		if C.IsComponentClass(menu.componentSlot.component, "station") then
			targetclasses = {"turret", "shieldgenerator"}
		else
			targetclasses = {"engine", "turret", "shieldgenerator"}
		end
	else
		targetclasses = {targetclass}
	end

	for _, ship in ipairs(menu.selectedplayerships) do
		menu.orderAttackSurfaceElements(ship, target, targetclasses, clear)
	end

	if menu.shown then
		menu.onCloseElement("close")
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "refresh")
		menu.cleanup()
	end
end

function menu.buttonBoard()
	local selectedplayerships = {table.unpack(menu.selectedplayerships)}
	if menu.removedOccupiedPlayerShip then
		table.insert(selectedplayerships, menu.removedOccupiedPlayerShip)
	end

	if menu.shown then
		if menu.interactMenuID then
			C.NotifyInteractMenuHidden(menu.interactMenuID, true)
		end
		Helper.closeMenuAndOpenNewMenu(menu, "MapMenu", { 0, 0, true, nil, nil, "boardingcontext", {ConvertStringTo64Bit(tostring(menu.componentSlot.component)), selectedplayerships} }, true)
		menu.cleanup()
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.interactMenuCallbacks.returnToMenu("boardingcontext", { ConvertStringTo64Bit(tostring(menu.componentSlot.component)), selectedplayerships } )
		Helper.resetInteractMenuCallbacks()
		menu.cleanup()
	end
end

function menu.buttonCancelConstruction()
	C.CancelConstruction(menu.componentSlot.component, menu.construction.id)
	if menu.shown then
		menu.onCloseElement("close")
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "refresh")
		menu.cleanup()
	end
end

function menu.buttonCancelAllConstruction()
	for _, id in ipairs(menu.construction.ids) do
		if C.CanCancelConstruction(menu.componentSlot.component, id) then
			C.CancelConstruction(menu.componentSlot.component, id)
		end
	end
	if menu.shown then
		menu.onCloseElement("close")
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "refresh")
		menu.cleanup()
	end
end

function menu.buttonChangeAssignment(assignment, group)
	if assignment == "positiondefence" then
		Helper.setIntersectorDefence(ConvertStringTo64Bit(tostring(menu.componentSlot.component)), group)
	end

	if menu.shipswithcurrentcommander and #menu.shipswithcurrentcommander > 0 then
		for _, ship in ipairs(menu.shipswithcurrentcommander) do
			menu.orderAssignCommander(ship, menu.componentSlot.component, assignment, group)
		end
	elseif menu.groupShips and #menu.groupShips > 0 then
		for _, shipentry in ipairs(menu.groupShips) do
			menu.orderAssignCommander(ConvertIDTo64Bit(shipentry.component), menu.componentSlot.component, assignment, group)
		end
	else
		local convertedComponent = ConvertStringTo64Bit(tostring(menu.componentSlot.component))
		menu.orderAssignCommander(convertedComponent, GetCommander(convertedComponent), assignment, group)
	end
	if menu.shown then
		menu.onCloseElement("close")
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "refresh")
		menu.cleanup()
	end
end

function menu.buttonChangeLogo()
	if menu.shown then
		if menu.interactMenuID then
			C.NotifyInteractMenuHidden(menu.interactMenuID, true)
		end
		Helper.closeMenuAndOpenNewMenu(menu, "MapMenu", { 0, 0, true, nil, nil, 'changelogocontext', { ConvertStringTo64Bit(tostring(menu.componentSlot.component)) } }, true)
		menu.cleanup()
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "changelogocontext", { ConvertStringTo64Bit(tostring(menu.componentSlot.component)) } )
		menu.cleanup()
	end
end

function menu.buttonChangeOverrideOrder(idstring, attacker)
	local convertedComponent = ConvertStringTo64Bit(tostring(menu.componentSlot.component))

	-- remove all override orders
	local numorders = C.GetNumOrders(menu.componentSlot.component)
	local currentorders = ffi.new("Order2[?]", numorders)
	numorders = C.GetOrders2(currentorders, numorders, menu.componentSlot.component)
	for i = numorders, 1, -1 do
		if currentorders[i - 1].isoverride then
			C.RemoveOrder(menu.componentSlot.component, i, false, false)
		end
	end

	local orderidx
	if idstring == "Flee" then
		orderidx = C.CreateOrder3(menu.componentSlot.component, "Flee", false, true, true)
		if orderidx > 0 then
			SetOrderParam(convertedComponent, orderidx, 1, nil, 'boost')
			SetOrderParam(convertedComponent, orderidx, 3, nil, true)
			SetOrderParam(convertedComponent, orderidx, 4, nil, true)
			if attacker then
				SetOrderParam(convertedComponent, orderidx, 6, nil, ConvertStringToLuaID(tostring(attacker)))
			end
		end
	elseif idstring == "Attack" then
		orderidx = C.CreateOrder3(menu.componentSlot.component, "Attack", false, true, true)
		if orderidx > 0 then
			if attacker then
				SetOrderParam(convertedComponent, orderidx, 1, nil, ConvertStringToLuaID(tostring(attacker)))
			end
		end
	elseif idstring == "Wait" then
		orderidx = C.CreateOrder3(menu.componentSlot.component, "Wait", false, true, true)
		if orderidx > 0 then
			SetOrderParam(convertedComponent, orderidx, 4, nil, true)
			if attacker then
				SetOrderParam(convertedComponent, orderidx, 5, nil, ConvertStringToLuaID(tostring(attacker)))
			end
		end
	end

	if orderidx > 0 then
		C.EnableOrder(menu.componentSlot.component, orderidx)
		local newidx = 1
		if not C.AdjustOrder(menu.componentSlot.component, orderidx, newidx, true, false, true) then
			newidx = 2
		end
		C.AdjustOrder(menu.componentSlot.component, orderidx, newidx, true, false, false)
	end

	if menu.shown then
		menu.onCloseElement("close")
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "refresh")
		menu.cleanup()
	end
end

function menu.buttonClaim(selectedship)
	C.ClaimShip(selectedship, menu.componentSlot.component)
	if menu.shown then
		menu.onCloseElement("close")
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "refreshcrew")
		menu.cleanup()
	end
end

function menu.buttonCollect()
	for _, ship in ipairs(menu.selectedplayerships) do
		menu.orderCollect(ship, menu.componentSlot.component, menu.offsetcomponent, menu.offset, clear)
	end

	menu.onCloseElement("close")
end

function menu.buttonCollectDeployable(clear)
	for _, ship in ipairs(menu.selectedplayerships) do
		menu.orderCollectDeployable(ship, menu.componentSlot.component, menu.offsetcomponent, menu.offset, clear)
	end

	menu.onCloseElement("close")
end

function menu.buttonCollectDeployables(clear)
	if not menu.shown then
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "collectdeployables", { ConvertStringTo64Bit(tostring(menu.componentSlot.component)), clear })
		menu.cleanup()
	end
end

function menu.buttonCollectLockbox()
	for _, ship in ipairs(menu.selectedplayerships) do
		menu.orderCollectLockbox(ship, menu.componentSlot.component, clear)
	end

	menu.onCloseElement("close")
end

function menu.buttonCollectRadius()
	for _, ship in ipairs(menu.selectedplayerships) do
		menu.orderCollectRadius(ship, menu.offsetcomponent, menu.offset, clear)
	end

	menu.onCloseElement("close")
end

function menu.buttonComm()
	if menu.shown then
		if menu.interactMenuID then
			C.NotifyInteractMenuHidden(menu.interactMenuID, true)
		end
		local convertedComponent = ConvertStringTo64Bit(tostring(menu.componentSlot.component))
		local entities = Helper.getSuitableControlEntities(convertedComponent, true)
		Helper.closeMenuForNewConversation(menu, "default", entities[1], convertedComponent, true)
		menu.cleanup()
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "comm", ConvertStringTo64Bit(tostring(menu.componentSlot.component)))
		menu.cleanup()
	end
end

function menu.buttonCrewTransfer(othership)
	local ship = ConvertStringTo64Bit(tostring(menu.componentSlot.component))

	if menu.shown then
		if menu.interactMenuID then
			C.NotifyInteractMenuHidden(menu.interactMenuID, true)
		end
		Helper.closeMenuAndOpenNewMenu(menu, "MapMenu", { 0, 0, true, nil, nil, "crewtransfercontext", { othership, ship } }, true)
		menu.cleanup()
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "crewtransfercontext", { othership, ship } )
		menu.cleanup()
	end
end

function menu.buttonDeliverWares(missionid)
	SignalObject(ConvertStringTo64Bit(tostring(menu.componentSlot.component)), "ware_mission_delivery", ConvertStringToLuaID(tostring(missionid)))
	menu.onCloseElement("close")
end

function menu.buttonDeploy(type, macro, amount)
	if type == "mine" then
		for i = 1, amount do
			C.LaunchMine(menu.componentSlot.component, macro)
		end
	elseif type == "navbeacon" then
		for i = 1, amount do
			C.LaunchNavBeacon(menu.componentSlot.component, macro)
		end
	elseif type == "satellite" then
		for i = 1, amount do
			C.LaunchSatellite(menu.componentSlot.component, macro)
		end
	elseif type == "lasertower" then
		for i = 1, amount do
			C.LaunchLaserTower(menu.componentSlot.component, macro)
		end
	elseif type == "resourceprobe" then
		for i = 1, amount do
			C.LaunchResourceProbe(menu.componentSlot.component, macro)
		end
	end

	menu.onCloseElement("close")
end

function menu.buttonDeployAtPosition(type, macro, amount)
	for _, ship in ipairs(menu.selectedplayerships) do
		menu.orderDeployAtPosition(ship, menu.offsetcomponent, menu.offset, macro, amount)
	end

	menu.onCloseElement("close")
end

function menu.buttonDeployToStation(selectedbuilder, clear, target)
	if not C.IsBuilderBusy(selectedbuilder) then
		local convertedBuilder = ConvertStringTo64Bit(tostring(selectedbuilder))
		if not GetComponentData(convertedBuilder, "isplayerowned") then
			local playermoney = GetPlayerMoney()
			local fee = tonumber(C.GetBuilderHiringFee())
			if playermoney >= fee then
				TransferPlayerMoneyTo(fee, convertedBuilder)
			else
				return
			end
		end

		local station = target or menu.componentSlot.component
		if C.IsComponentClass(menu.componentSlot.component, "buildstorage") then
			station = ConvertIDTo64Bit(GetComponentData(ConvertStringTo64Bit(tostring(menu.componentSlot.component)), "basestation")) or 0
		end
		menu.orderDeployToStation(convertedBuilder, station, clear)
	end

	menu.onCloseElement("close")
end

function menu.buttonDepositInventoryAtHQ()
	local convertedComponent = ConvertStringToLuaID(tostring(menu.componentSlot.component))
	local isdeployable, pilot = GetComponentData(convertedComponent, "isdeployable", "pilot")
	if (not C.IsUnit(menu.componentSlot.component)) and (not isdeployable) then
		if pilot and (pilot ~= 0) then
			if next(GetInventory(pilot)) ~= nil then
				menu.orderDepositInventoryAtHQ(menu.componentSlot.component, clear)
			end
		end
	end

	for _, ship in ipairs(menu.selectedplayerships) do
		local isdeployable, pilot = GetComponentData(ship, "isdeployable", "pilot")
		if (not C.IsUnit(ship)) and (not isdeployable) then
			if pilot and (pilot ~= 0) then
				if next(GetInventory(pilot)) ~= nil then
					menu.orderDepositInventoryAtHQ(ship, clear)
				end
			end
		end
	end

	menu.onCloseElement("close")
end

function menu.buttonDock(clear, ventureplatform)
	local convertedComponent = ConvertStringTo64Bit(tostring(menu.componentSlot.component))
	local convertedVenturePlatform = ventureplatform and ConvertStringTo64Bit(tostring(ventureplatform))
	for _, ship in ipairs(menu.selectedplayerships) do
		if IsDockingPossible(ship, convertedComponent, convertedVenturePlatform) then
			menu.orderDock(ship, menu.componentSlot.component, clear, ventureplatform)
		end
	end

	menu.onCloseElement("close")
end

function menu.buttonDockAtPlayer(clear)
	local playercontainer = C.GetPlayerContainerID()
	local convertedComponent = ConvertStringTo64Bit(tostring(playercontainer))
	for _, ship in ipairs(menu.selectedplayerships) do
		if IsDockingPossible(ship, convertedComponent) then
			if C.GetContextByClass(ship, "container", false) == playercontainer then
				if (not C.IsShipAtExternalDock(ship)) and (not C.IsShipBeingRetrieved(ship)) then
					C.RequestShipFromInternalStorage2(ship, false, C.GetPlayerID())
				end
			else
				menu.orderDock(ship, playercontainer, clear)
			end
		end
	end
	if C.GetContextByClass(menu.componentSlot.component, "container", false) == playercontainer then
		if (not C.IsShipAtExternalDock(menu.componentSlot.component)) and (not C.IsShipBeingRetrieved(menu.componentSlot.component)) then
			C.RequestShipFromInternalStorage2(menu.componentSlot.component, false, C.GetPlayerID())
		end
	else
		menu.orderDock(ConvertStringTo64Bit(tostring(menu.componentSlot.component)), playercontainer, clear)
	end

	menu.onCloseElement("close")
end

function menu.buttonDockRequest()
	local dockcontainer = menu.componentSlot.component
	if C.IsComponentClass(menu.componentSlot.component, "dockingbay") then
		dockcontainer = C.GetContextByClass(dockcontainer, "container", false)
	end

	C.RequestDockAt(dockcontainer, false)

	menu.onCloseElement("close")
end

function menu.buttonDropInventory(pilot)
	if menu.shown then
		if menu.interactMenuID then
			C.NotifyInteractMenuHidden(menu.interactMenuID, true)
		end
		Helper.closeMenuAndOpenNewMenu(menu, "MapMenu", { 0, 0, true, nil, nil, "dropwarescontext", { "inventory", ConvertStringToLuaID(tostring(pilot)) } }, true)
		menu.cleanup()
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "dropwarescontext", { "inventory", pilot } )
		menu.cleanup()
	end
end

function menu.buttonEndGuidance()
	C.EndGuidance()
	if menu.shown then
		menu.onCloseElement("close")
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "refresh" )
		menu.cleanup()
	end
end

function menu.buttonExplore(clear)
	for _, ship in ipairs(menu.selectedplayerships) do
		menu.orderExplore(ship, menu.componentSlot.component, menu.offsetcomponent, menu.offset, clear)
	end

	menu.onCloseElement("close")
end

function menu.buttonExploreUpdate(clear)
	for _, ship in ipairs(menu.selectedplayerships) do
		menu.orderExploreUpdate(ship, menu.componentSlot.component, menu.offsetcomponent, menu.offset, clear)
	end

	menu.onCloseElement("close")
end

function menu.buttonExternal()
	local convertedComponent = ConvertStringTo64Bit(tostring(menu.componentSlot.component))
	local playersector = C.GetContextByClass(C.GetPlayerID(), "sector", false)
	local target = 0
	if C.IsComponentClass(menu.componentSlot.component, "highway") then
		local issuperhighway, entrygate = GetComponentData(convertedComponent, "issuperhighway", "entrygate")
		if issuperhighway then
			target = ConvertIDTo64Bit(entrygate)
		else
			target = menu.componentSlot.component
		end
	else
		target = menu.componentSlot.component
	end
	local targetsector = C.GetContextByClass(target, "sector", false)
	if (target ~= C.GetPlayerControlledShipID()) and (playersector == targetsector) then
		local success = C.SetSofttarget(menu.componentSlot.component, "")
		if success then
			PlaySound("ui_target_set")
			C.SetPlayerCameraTargetView(target, true)
		else
			PlaySound("ui_target_set_fail")
		end
	else
		PlaySound("ui_target_set_fail")
	end

	menu.onCloseElement("close")
end

function menu.buttonFlee(attacker, clear)
	menu.orderWithdrawFromCombat(menu.componentSlot.component, clear, true, attacker)
	for _, ship in ipairs(menu.selectedplayerships) do
		menu.orderWithdrawFromCombat(ship, clear, true, attacker)
	end

	menu.onCloseElement("close")
end

function menu.buttonFollow(clear)
	for _, ship in ipairs(menu.selectedplayerships) do
		menu.orderFollow(ship, menu.componentSlot.component, clear)
	end

	menu.onCloseElement("close")
end

function menu.buttonFormationShape(shape, subordinates)
	local info = C.SetFormationShape(menu.componentSlot.component, shape)
	shape = ffi.string(info.shape)

	if (shape ~= "") then
		for i = #subordinates, 1, -1 do
			local subordinate = ConvertIDTo64Bit(subordinates[i])

			local numorders = C.GetNumOrders(subordinate)
			local currentorders = ffi.new("Order[?]", numorders)
			numorders = C.GetOrders(currentorders, numorders, subordinate)
			local paramoffset = 0
			for j = 1, numorders do
				if (ffi.string(currentorders[0].orderdef) == "Escort") then
					paramoffset = 0
				elseif (ffi.string(currentorders[0].orderdef) == "SupplyFleet") then
					paramoffset = 1
				end
				if (ffi.string(currentorders[0].orderdef) == "Escort") or (ffi.string(currentorders[0].orderdef) == "SupplyFleet") then
					SetOrderParam(subordinate, j, paramoffset + 2, nil, shape) -- shape
					SetOrderParam(subordinate, j, paramoffset + 3, nil, info.radius) -- radius
					SetOrderParam(subordinate, j, paramoffset + 4, nil, info.rollMembers) -- rollmembers
					SetOrderParam(subordinate, j, paramoffset + 5, nil, info.rollFormation) -- rollformation
					SetOrderParam(subordinate, j, paramoffset + 6, nil, tonumber(info.maxShipsPerLine)) -- maxshipsperline
				end
			end

			local currentdefaultorder = ffi.new("Order")
			if C.GetDefaultOrder(currentdefaultorder, subordinate) then
				if (ffi.string(currentdefaultorder.orderdef) == "Escort") then
					paramoffset = 0
				elseif (ffi.string(currentdefaultorder.orderdef) == "SupplyFleet") then
					paramoffset = 1
				end
				if (ffi.string(currentdefaultorder.orderdef) == "Escort") or (ffi.string(currentdefaultorder.orderdef) == "SupplyFleet") then
					SetOrderParam(subordinate, "default", paramoffset + 2, nil, shape) -- shape
					SetOrderParam(subordinate, "default", paramoffset + 3, nil, info.radius) -- radius
					SetOrderParam(subordinate, "default", paramoffset + 4, nil, info.rollMembers) -- rollmembers
					SetOrderParam(subordinate, "default", paramoffset + 5, nil, info.rollFormation) -- rollformation
					SetOrderParam(subordinate, "default", paramoffset + 6, nil, tonumber(info.maxShipsPerLine)) -- maxshipsperline
				end
			end
		end
	end

	menu.onCloseElement("close")
end

function menu.buttonGetSupplies()
	menu.orderGetSupplies(menu.componentSlot.component, clear)

	menu.onCloseElement("close")
end

function menu.buttonGuidance(useoffset)
	if useoffset then
		menu.plotCourse(menu.offsetcomponent, menu.offset)
	else
		menu.plotCourse(menu.componentSlot.component, nil)
	end

	menu.onCloseElement("close")
end

function menu.buttonInfo()
	if menu.shown then
		if menu.interactMenuID then
			C.NotifyInteractMenuHidden(menu.interactMenuID, true)
		end
		Helper.closeMenuAndOpenNewMenu(menu, "MapMenu", { 0, 0, true, nil, nil, "infomode", { "info", ConvertStringTo64Bit(tostring(menu.componentSlot.component)) } }, true)
		menu.cleanup()
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "info", { ConvertStringTo64Bit(tostring(menu.componentSlot.component)) })
		menu.cleanup()
	end
end

function menu.buttonLiveStream()
	C.SetPlayerCameraCinematicView(menu.componentSlot.component)
	if menu.shown then
		menu.onCloseElement("close")
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "close")
		menu.cleanup()
	end
end

function menu.buttonSetInterSectorDefence(groups, reset)
	local sectorid = GetComponentData(ConvertStringTo64Bit(tostring(menu.componentSlot.component)), "sectorid")
	local pos = C.GetObjectPositionInSector(menu.componentSlot.component)

	for i = 1, 10 do
		if reset or groups[i] then
			Helper.setIntersectorDefence(ConvertStringTo64Bit(tostring(menu.componentSlot.component)), i, reset, sectorid, pos)
		end
	end

	menu.onCloseElement("close")
end

function menu.buttonSubordinateGroupInterSectorDefence(group, reset)
	Helper.setIntersectorDefence(ConvertStringTo64Bit(tostring(menu.componentSlot.component)), group, reset)
	menu.onCloseElement("close")
end

function menu.buttonEncyclopedia()
	local convertedComponent = ConvertStringTo64Bit(tostring(menu.componentSlot.component))
	local macro, ismodule = GetComponentData(convertedComponent, "macro", "ismodule")

	local mode, library, id, object
	if C.IsComponentClass(menu.componentSlot.component, "sector") then
		mode = "Galaxy"
		library = ""
		object = ConvertStringToLuaID(tostring(menu.componentSlot.component))
	else
		mode = ismodule and "Stations" or "Ships"
		library = GetMacroData(macro, "infolibrary")
		id = macro
	end

	if menu.shown then
		if menu.interactMenuID then
			C.NotifyInteractMenuHidden(menu.interactMenuID, true)
		end
		Helper.closeMenuAndOpenNewMenu(menu, "EncyclopediaMenu", { 0, 0, mode, library, id, object }, true)
		menu.cleanup()
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "newmenu", { "EncyclopediaMenu", { 0, 0, mode, library, id, object } })
		menu.cleanup()
	end
end

function menu.buttonMarkAsHostile()
	if menu.shown then
		if menu.interactMenuID then
			C.NotifyInteractMenuHidden(menu.interactMenuID, true)
		end
		Helper.closeMenuAndOpenNewMenu(menu, "UserQuestionMenu", { 0, 0, "markashostile", { menu.componentSlot.component } }, true)
		menu.cleanup()
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "markashostile", { ConvertStringTo64Bit(tostring(menu.componentSlot.component)) })
		menu.cleanup()
	end
end

function menu.buttonMining(ware, clear)
	for _, ship in ipairs(menu.selectedplayerships) do
		menu.orderMining(ship, ware, menu.offsetcomponent, menu.offset, clear)
	end

	menu.onCloseElement("close")
end

function menu.buttonMissionSetInactive()
	C.SetActiveMission(0)

	if not menu.shown then
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "refresh")
		menu.cleanup()
	else
		menu.onCloseElement("close")
	end
end

function menu.buttonMissionSetActive(missionid)
	C.SetActiveMission(missionid)
	PlaySound("ui_mission_set_active")

	if not menu.shown then
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "refresh")
		menu.cleanup()
	else
		menu.onCloseElement("close")
	end
end

function menu.buttonMissionAbort(missionid)
	C.AbortMission(missionid)

	if not menu.shown then
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "refresh")
		menu.cleanup()
	else
		menu.onCloseElement("close")
	end
end

function menu.buttonMissionShow(missionid)
	local missiondetails = C.GetMissionIDDetails(missionid)
	local entry = {
		["missionGroup"] = {},
		["maintype"] = ffi.string(missiondetails.mainType),
	}
	if missiondetails.threadMissionID ~= 0 then
		local missionGroup = C.GetMissionGroupDetails(missiondetails.threadMissionID)
		entry.missionGroup.id = ffi.string(missionGroup.id)
		entry.missionGroup.name = ffi.string(missionGroup.name)
	else
		local missionGroup = C.GetMissionGroupDetails(missionid)
		entry.missionGroup.id = ffi.string(missionGroup.id)
		entry.missionGroup.name = ffi.string(missionGroup.name)
	end

	local mode
	if entry.maintype == "upkeep" then
		mode = "upkeep"
	else
		if entry.maintype == "guidance" then
			DebugError("menu.buttonMissionShow(): Trying to show guidance mission. [Florian]")
		else
			mode = "plot"
		end
	end

	if menu.shown then
		if menu.interactMenuID then
			C.NotifyInteractMenuHidden(menu.interactMenuID, true)
		end
		Helper.closeMenuAndOpenNewMenu(menu, "MapMenu", { 0, 0, true, nil, nil, "infomode", { "mission", mode, ConvertStringTo64Bit(tostring(missionid)) } }, true)
		menu.cleanup()
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "mission", { mode, ConvertStringTo64Bit(tostring(missionid)) })
		menu.cleanup()
	end
end

function menu.buttonShowUpkeepMissions()
	if menu.shown then
		if menu.interactMenuID then
			C.NotifyInteractMenuHidden(menu.interactMenuID, true)
		end
		Helper.closeMenuAndOpenNewMenu(menu, "MapMenu", { 0, 0, true, nil, nil, "infomode", { "mission", "upkeep", tostring(menu.componentSlot.component), true } }, true)
		menu.cleanup()
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "mission", { "upkeep", tostring(menu.componentSlot.component), true })
		menu.cleanup()
	end
end

function menu.buttonMissionBriefing(missionid, isoffer)
	if menu.shown then
		if menu.interactMenuID then
			C.NotifyInteractMenuHidden(menu.interactMenuID, true)
		end
		Helper.closeMenuAndOpenNewMenu(menu, "MissionBriefingMenu", { 0, 0, ConvertStringToLuaID(tostring(missionid)), isoffer }, true)
		menu.cleanup()
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "newmenu", { "MissionBriefingMenu", { 0, 0, ConvertStringToLuaID(tostring(missionid)), isoffer } })
		menu.cleanup()
	end
end

function menu.buttonMissionAccept(offerid)
	local name, description, difficulty, threadtype, maintype, subtype, subtypename, faction, rewardmoney, rewardtext, briefingobjectives, activebriefingstep, briefingmissions, oppfaction, licence, missiontime, duration, abortable, guidancedisabled, associatedcomponent, alertLevel, offeractor, offercomponent = GetMissionOfferDetails(ConvertStringToLuaID(menu.missionoffer))

	SignalObject(offeractor, "accept", ConvertStringToLuaID(tostring(offerid)))

	if not menu.shown then
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "missionaccepted", { offerid })
		menu.cleanup()
	else
		menu.onCloseElement("close")
	end
end

function menu.buttonMoveWait(clear)
	local convertedComponent = ConvertStringTo64Bit(tostring(menu.componentSlot.component))
	local target = 0
	local playerprecise = (#menu.selectedplayerships == 1)
	if C.IsComponentClass(menu.componentSlot.component, "highway") then
		local issuperhighway, entrygate = GetComponentData(convertedComponent, "issuperhighway", "entrygate")
		if issuperhighway then
			target = ConvertIDTo64Bit(entrygate)
		else
			target = menu.componentSlot.component
		end
	else
		target = menu.componentSlot.component
	end
	for _, ship in ipairs(menu.selectedplayerships) do
		menu.orderMoveWait(ship, menu.offsetcomponent, menu.offset, target, playerprecise, clear)
	end

	menu.onCloseElement("close")
end

function menu.buttonPlayerSquadAttackPlayerTarget(clear)
	local playertarget = ConvertIDTo64Bit(GetPlayerTarget())
	if (playertarget ~= 0) then
		for ship in pairs(menu.playerSquad) do
			local hasloop = ffi.new("bool[1]", 0)
			C.GetOrderQueueFirstLoopIdx(ship, hasloop)
			if not hasloop[0] then
				menu.orderAttack(ship, playertarget, clear, true)
				--print("ordering " .. ffi.string(C.GetComponentName(ship)) .. " " .. tostring(ship) .. " to attack " .. ffi.string(C.GetComponentName(playertarget)) .. " " .. tostring(playertarget))
			end
		end
	end

	menu.onCloseElement("close")
end

function menu.buttonPlayerSquadStopAndHoldFire(clear)
	for ship in pairs(menu.playerSquad) do
		local hasloop = ffi.new("bool[1]", 0)
		C.GetOrderQueueFirstLoopIdx(ship, hasloop)
		if not hasloop[0] then
			menu.orderStopAndHoldFire(ship, clear, true)
			--print("ordering " .. ffi.string(C.GetComponentName(ship)) .. " " .. tostring(ship) .. " to halt and stop firing.")
		end
	end

	menu.onCloseElement("close")
end

function menu.buttonPlayerSquadWithdrawAndHold(clear)
	for ship in pairs(menu.playerSquad) do
		local hasloop = ffi.new("bool[1]", 0)
		C.GetOrderQueueFirstLoopIdx(ship, hasloop)
		if not hasloop[0] then
			menu.orderWithdrawAndHold(ship, clear, true)
			--print("ordering " .. ffi.string(C.GetComponentName(ship)) .. " " .. tostring(ship) .. " to withdraw from combat and hold position.")
		end
	end

	menu.onCloseElement("close")
end

function menu.buttonPlayerSquadWithdrawFromCombat(clear)
	for ship in pairs(menu.playerSquad) do
		local hasloop = ffi.new("bool[1]", 0)
		C.GetOrderQueueFirstLoopIdx(ship, hasloop)
		if not hasloop[0] then
			menu.orderWithdrawFromCombat(ship, clear, true)
			--print("ordering " .. ffi.string(C.GetComponentName(ship)) .. " " .. tostring(ship) .. " to withdraw from combat.")
		end
	end

	menu.onCloseElement("close")
end

function menu.buttonPerformPlayerAction(id, type)
	C.PerformCompSlotPlayerAction(menu.componentSlot, id)
	AddUITriggeredEvent(menu.name, "perform", type)
	menu.onCloseElement("close", nil, false)
end

function menu.buttonPlayerDockToTrade(clear)
	local convertedComponent = ConvertStringTo64Bit(tostring(menu.componentSlot.component))
	for _, ship in ipairs(menu.selectedplayerships) do
		if IsDockingPossible(ship, convertedComponent, nil, true) then
			menu.orderPlayerDockToTrade(ship, menu.componentSlot.component, clear)
		end
	end

	menu.onCloseElement("close")
end

function menu.buttonProceedWithOrders()
	SignalObject(ConvertStringTo64Bit(tostring(menu.componentSlot.component)), "playerownedship_proceed")
	for _, ship in ipairs(menu.selectedplayerships) do
		SignalObject(ship, "playerownedship_proceed")
	end
	menu.onCloseElement("close")
end

function menu.buttonProtect(clear)
	for _, ship in ipairs(menu.selectedplayerships) do
		menu.orderProtect(ship, menu.componentSlot.component, clear)
	end

	menu.onCloseElement("close")
end

function menu.buttonPutIntoStorage(container, ship)
	if C.IsShipAtExternalDock(ship) then
		C.PutShipIntoStorage(container, ship)
	else
		C.RequestShipFromInternalStorage2(ship, false, C.GetPlayerID())
	end

	menu.onCloseElement("close")
end

function menu.buttonRecallSubordinates(component, subordinates, level)
	if not level then
		level = 1
	end

	if not component then
		DebugError("menu.buttonRecallSubordinates(): " .. tostring(component) .. " is not a valid component.")
	elseif not subordinates or #subordinates < 1 then
		DebugError("menu.buttonRecallSubordinates(): tried to recall subordinates on " .. tostring(component) .. " that has no subordinates.")
	else
		C.SetAllDronesArmed(component, false)
		for i = #subordinates, 1, -1 do
			local subordinate = ConvertIDTo64Bit(subordinates[i])
			local numorders = C.GetNumOrders(subordinate)
			for j = numorders, 1, -1 do
				C.RemoveOrder(subordinate, j, false, false)
			end

			local subsubordinates = GetSubordinates(subordinates[i])
			if #subsubordinates > 0 then
				menu.buttonRecallSubordinates(subordinate, subsubordinates, level + 1)
			end
		end
	end

	if level == 1 then
		menu.onCloseElement("close")
	end
end

function menu.buttonRemoveAllOrders(removedefaultorder, removeassignment, removedockorder)
	menu.orderRemove(menu.componentSlot.component, removedefaultorder, removeassignment, removedockorder)
	for _, ship in ipairs(menu.selectedplayerships) do
		menu.orderRemove(ship, removedefaultorder, removeassignment, removedockorder)
	end
	if menu.shown then
		menu.onCloseElement("close")
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "refresh")
		menu.cleanup()
	end
end

function menu.buttonRemoveAssignment(removeall)
	C.RemoveCommander2(menu.componentSlot.component)
	C.CreateOrder(menu.componentSlot.component, "Wait", true)
	C.EnablePlannedDefaultOrder(menu.componentSlot.component, false)
	if removeall then
		for _, ship in ipairs(menu.selectedplayerships) do
			C.RemoveCommander2(ship)
			C.CreateOrder(ship, "Wait", true)
			C.EnablePlannedDefaultOrder(ship, false)
		end
	end
	if menu.shown then
		menu.onCloseElement("close")
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "refresh")
		menu.cleanup()
	end
end

function menu.buttonRemoveOrder()
	if menu.componentOrder then
		C.RemoveOrder(menu.componentSlot.component, menu.componentOrder.queueidx, false, false)
	elseif menu.syncpointorder then
		C.RemoveOrder(menu.componentSlot.component, menu.syncpointorder.queueidx, false, false)
	end
	menu.onCloseElement("close")
end

-- kuertee start: multi-rename
menu.uix_multiRename_removedActionTarget = nil
function menu.uix_multiRename_getObjects()
	-- Helper.debugText_forced("")
	-- Helper.debugText_forced("")
	-- Helper.debugText_forced("")
	-- Helper.debugText_forced("uix_multiRename_getObjects")
	-- Helper.debugText_forced("menu.componentSlot.component", tostring(ConvertStringTo64Bit(tostring(menu.componentSlot.component))))
	local actionTarget = ConvertStringTo64Bit(tostring(menu.componentSlot.component))
	-- local name = GetComponentData(actionTarget, "name")
	-- local idcode = ""
	-- if C.IsComponentClass(actionTarget, "object") then
	-- 	idcode = ffi.string(C.GetObjectIDCode(actionTarget))
	-- end
	-- Helper.debugText_forced("actionTarget " .. tostring(actionTarget), name .. " " .. tostring(idcode))
	local isActionTargetInList
	uix_multiRename_objects = {}
	if menu.selectedplayerships and #menu.selectedplayerships > 0 then
		for _, object in ipairs(menu.selectedplayerships) do
			if IsValidComponent(object) then
				-- local name = GetComponentData(object, "name")
				-- local idcode = ""
				-- if C.IsComponentClass(object, "object") then
				-- 	idcode = ffi.string(C.GetObjectIDCode(object))
				-- end
				-- Helper.debugText_forced("selectedplayerships " .. tostring(object), name .. " " .. tostring(idcode))
				table.insert(uix_multiRename_objects, object)
				isActionTargetInList = isActionTargetInList or IsSameComponent(object, actionTarget)
			end
		end
	end
	if menu.selectedotherobjects and #menu.selectedotherobjects > 0 then
		for _, object in ipairs(menu.selectedotherobjects) do
			if IsValidComponent(object) then
				local isplayerowned = GetComponentData(ConvertStringTo64Bit(tostring(object)), "isplayerowned")
				if isplayerowned then
					-- local name = GetComponentData(object, "name")
					-- local idcode = ""
					-- if C.IsComponentClass(object, "object") then
					-- 	idcode = ffi.string(C.GetObjectIDCode(object))
					-- end
					-- Helper.debugText_forced("selectedotherobjects " .. tostring(object), name .. " " .. tostring(idcode))
					-- Helper.debugText_forced("selectedotherobjects isplayerowned", isplayerowned)
					table.insert(uix_multiRename_objects, object)
					isActionTargetInList = isActionTargetInList or IsSameComponent(object, actionTarget)
				end
			end
		end
	end
	if menu.selectedplayerdeployables and #menu.selectedplayerdeployables > 0 then
		for _, object in ipairs(menu.selectedplayerdeployables) do
			if IsValidComponent(object) then
				-- local name = GetComponentData(object, "name")
				-- local idcode = ""
				-- if C.IsComponentClass(object, "object") then
				-- 	idcode = ffi.string(C.GetObjectIDCode(object))
				-- end
				-- Helper.debugText_forced("selectedplayerdeployables " .. tostring(object), name .. " " .. tostring(idcode))
				table.insert(uix_multiRename_objects, object)
				isActionTargetInList = isActionTargetInList or IsSameComponent(object, actionTarget)
			end
		end
	end
	if menu.removedOccupiedPlayerShip then
		-- local name = GetComponentData(menu.removedOccupiedPlayerShip, "name")
		-- local idcode = ""
		-- if C.IsComponentClass(menu.removedOccupiedPlayerShip, "object") then
		-- 	idcode = ffi.string(C.GetObjectIDCode(menu.removedOccupiedPlayerShip))
		-- end
		-- Helper.debugText_forced("menu.removedOccupiedPlayerShip " .. tostring(menu.removedOccupiedPlayerShip), name .. " " .. tostring(idcode))
		table.insert(uix_multiRename_objects, menu.removedOccupiedPlayerShip)
		isActionTargetInList = isActionTargetInList or IsSameComponent(menu.removedOccupiedPlayerShip, actionTarget)
	end
	if menu.uix_multiRename_removedActionTarget then
		-- local name = GetComponentData(menu.uix_multiRename_removedActionTarget, "name")
		-- local idcode = ""
		-- if C.IsComponentClass(menu.uix_multiRename_removedActionTarget, "object") then
		-- 	idcode = ffi.string(C.GetObjectIDCode(menu.uix_multiRename_removedActionTarget))
		-- end
		-- Helper.debugText_forced("menu.uix_multiRename_removedActionTarget " .. tostring(menu.uix_multiRename_removedActionTarget), name .. " " .. tostring(idcode))
		table.insert(uix_multiRename_objects, menu.uix_multiRename_removedActionTarget)
	end
	if menu.uix_multiRename_removedActionTarget or isActionTargetInList then
		-- if uix_multiRename_removedActionTarget, then right-click target was removed from one of the lists, and so multi-rename is valid.
		-- if isActionTargetinList, then right-click target was already in one of the lists, and so multi-rename is valid.
		-- i.e. right-clicking on a deployable will not remove it from one of the lists.
		-- for _, object in ipairs(uix_multiRename_objects) do
		-- 	local name = GetComponentData(object, "name")
		-- 	local idcode = ""
		-- 	if C.IsComponentClass(object, "object") then
		-- 		idcode = ffi.string(C.GetObjectIDCode(object))
		-- 	end
		-- 	Helper.debugText_forced(object, name .. " " .. tostring(idcode))
		-- end
		return uix_multiRename_objects
	else
		return {}
	end
end
-- kuertee end: multi-rename

-- kuertee start: multi-rename
-- function menu.buttonRename(isfleet)
function menu.buttonRename(isfleet, isMultiRename)
-- kuertee end: multi-rename
	if menu.shown then
		if menu.interactMenuID then
			C.NotifyInteractMenuHidden(menu.interactMenuID, true)
		end

		-- kuertee start: multi-rename
		if isMultiRename and uix_multiRename_objects and #uix_multiRename_objects > 0 then
			Helper.closeMenuAndOpenNewMenu(menu, "MapMenu", { 0, 0, true, nil, nil, 'renamecontext', { ConvertStringTo64Bit(tostring(menu.componentSlot.component)), isfleet, uix_multiRename_objects } }, true)
			uix_multiRename_objects = nil
		else
			Helper.closeMenuAndOpenNewMenu(menu, "MapMenu", { 0, 0, true, nil, nil, 'renamecontext', { ConvertStringTo64Bit(tostring(menu.componentSlot.component)), isfleet } }, true)
		end
		-- kuertee end: multi-rename

		menu.cleanup()
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)

		-- kuertee start: multi-rename
		if isMultiRename and uix_multiRename_objects and #uix_multiRename_objects > 0 then
			Helper.returnFromInteractMenu(menu.currentOverTable, "renamecontext", { ConvertStringTo64Bit(tostring(menu.componentSlot.component)), isfleet, uix_multiRename_objects } )
			uix_multiRename_objects = nil
		else
			Helper.returnFromInteractMenu(menu.currentOverTable, "renamecontext", { ConvertStringTo64Bit(tostring(menu.componentSlot.component)), isfleet } )
		end
		-- kuertee end: multi-rename

		menu.cleanup()
	end
end

function menu.buttonRequestShip()
	if menu.shown then
		if menu.interactMenuID then
			C.NotifyInteractMenuHidden(menu.interactMenuID, true)
		end
		Helper.closeMenuAndOpenNewMenu(menu, "PlatformUndockMenu", { 0, 0, C.GetContextByClass(menu.componentSlot.component, "container", false), "requestship", { menu.isdockedship and C.GetContextByClass(menu.componentSlot.component, "dockingbay", false) or menu.componentSlot.component } }, true)
		menu.cleanup()
	end
end

function menu.buttonRescueInRange(clear)
	for _, ship in ipairs(menu.selectedplayerships) do
		menu.orderRescueInRange(ship, menu.offsetcomponent, menu.offset, clear)
	end

	menu.onCloseElement("close")
end

function menu.buttonRescueShip(clear)
	for _, ship in ipairs(menu.selectedplayerships) do
		menu.orderRescueShip(ship, menu.componentSlot.component, clear)
	end

	menu.onCloseElement("close")
end

function menu.buttonSalvageCollect(clear)
	for _, ship in ipairs(menu.selectedplayerships) do
		if GetComponentData(ship, "shiptype") == "tug" then
			menu.orderSalvageCollect(ship, menu.componentSlot.component, clear)
		end
	end

	menu.onCloseElement("close")
end

function menu.buttonSalvageCrush(clear)
	for _, ship in ipairs(menu.selectedplayerships) do
		if GetComponentData(ship, "shiptype") == "compactor" then
			menu.orderSalvageCrush(ship, menu.componentSlot.component, clear)
		end
	end

	menu.onCloseElement("close")
end

function menu.buttonSalvageDeliver(clear, ware, tradeoffer)
	for _, ship in ipairs(menu.selectedplayerships) do
		local towedobject = C.GetTowedObject(ship)
		if towedobject ~= 0 then
			local recyclingwares = GetComponentData(ConvertStringTo64Bit(tostring(towedobject)), "recyclingwares")
			if #recyclingwares > 0 then
				if ware == recyclingwares[1].ware then
					menu.orderSalvageDeliver(ship, menu.componentSlot.component, tradeoffer, recyclingwares[1].amount, clear)
				end
			end
		end
	end

	menu.onCloseElement("close")
end

function menu.buttonSalvageDeliver_NoTrade()
	for _, ship in ipairs(menu.selectedplayerships) do
		menu.orderSalvageDeliver_NoTrade(ship, menu.componentSlot.component, clear)
	end

	menu.onCloseElement("close")
end

function menu.buttonSalvageInRadius()
	for _, ship in ipairs(menu.selectedplayerships) do
		menu.orderSalvageInRadius(ship, menu.offsetcomponent, menu.offset, clear)
	end

	menu.onCloseElement("close")
end

function menu.buttonSyncPointAutoRelease()
	if menu.syncpointorder then
		C.SetSyncPointAutoReleaseFromOrder(menu.componentSlot.component, menu.syncpointorder.queueidx, not C.GetSyncPointAutoReleaseFromOrder(menu.componentSlot.component, menu.syncpointorder.queueidx, true), false)
	elseif menu.syncpoint then
		C.SetSyncPointAutoRelease(menu.syncpoint, not C.GetSyncPointAutoRelease(menu.syncpoint, true), false)
	end
end

function menu.buttonTacticalAttack(ships, clear)
	for _, ship in ipairs(ships) do
		menu.orderTacticalAttack(ship, menu.componentSlot.component, clear, false)
	end

	menu.onCloseElement("close")
end

function menu.buttonTriggerSyncPoint()
	if menu.syncpointorder then
		C.ReleaseOrderSyncPointFromOrder(menu.componentSlot.component, menu.syncpointorder.queueidx)
	elseif menu.syncpoint then
		C.ReleaseOrderSyncPoint(menu.syncpoint)
	end
	menu.onCloseElement("close")
end

function menu.buttonUpgrade(clear)
	local shiptrader = GetComponentData(ConvertStringTo64Bit(tostring(menu.componentSlot.component)), "shiptrader")
	if shiptrader then
		if menu.shown then
			if menu.interactMenuID then
				C.NotifyInteractMenuHidden(menu.interactMenuID, true)
			end
			Helper.closeMenuAndOpenNewMenu(menu, "ShipConfigurationMenu", { 0, 0, ConvertStringToLuaID(tostring(menu.componentSlot.component)), "upgrade", menu.selectedplayerships }, true)
			menu.cleanup()
		else
			Helper.resetUpdateHandler()
			Helper.clearFrame(menu, config.layer)
			Helper.returnFromInteractMenu(menu.currentOverTable, "newmenu", { "ShipConfigurationMenu", { 0, 0, ConvertStringToLuaID(tostring(menu.componentSlot.component)), "upgrade", menu.selectedplayerships } })
			menu.cleanup()
		end
	else
		DebugError("menu.buttonUpgrade(): unable to retrieve ship trader of " .. ffi.string(C.GetComponentName(menu.componentSlot.component)) .. ".")
	end
end

function menu.buttonPaintMod()
	local found = false
	local ships = {}
	if menu.shown then
		table.insert(ships, menu.componentSlot.component)
	else
		for _, ship in ipairs(menu.selectedplayerships) do
			table.insert(ships, ship)
			if ship == menu.componentSlot.component then
				found = true
			end
		end
		if not found then
			table.insert(ships, menu.componentSlot.component)
		end
	end

	if menu.shown then
		if menu.interactMenuID then
			C.NotifyInteractMenuHidden(menu.interactMenuID, true)
		end
		Helper.closeMenuAndOpenNewMenu(menu, "ShipConfigurationMenu", { 0, 0, nil, "modify", { true, ships } }, true)
		menu.cleanup()
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "newmenu", { "ShipConfigurationMenu", { 0, 0, nil, "modify", { true, ships } } })
		menu.cleanup()
	end
end

function menu.buttonSelectSubordinateGroup()
	if not menu.shown then
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "selectsubordinates", { ConvertStringTo64Bit(tostring(menu.componentSlot.component)), menu.subordinategroup })
		menu.cleanup()
	else
		menu.onCloseElement("close")
	end
end

function menu.buttonSellShips()
	local isshipyard, iswharf = GetComponentData(ConvertStringTo64Bit(tostring(menu.componentSlot.component)), "isshipyard", "iswharf")
	local sellableships = {}
	for _, ship in ipairs(menu.selectedplayerships) do
		if C.CanContainerBuildShip(menu.componentSlot.component, ship) and GetComponentData(ship, "issellable") then
			table.insert(sellableships, ship)
		end
	end

	if menu.shown then
		if menu.interactMenuID then
			C.NotifyInteractMenuHidden(menu.interactMenuID, true)
		end
		Helper.closeMenuAndOpenNewMenu(menu, "MapMenu", { 0, 0, true, nil, nil, "sellships", { ConvertStringToLuaID(tostring(menu.componentSlot.component)), sellableships, menu.frameX, menu.frameY } }, true)
		menu.cleanup()
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "sellships", { ConvertStringTo64Bit(tostring(menu.componentSlot.component)), sellableships, menu.frameX, menu.frameY })
		menu.cleanup()
	end
end

function menu.buttonShipConfig(mode)
	local shiptrader = GetComponentData(ConvertStringTo64Bit(tostring(menu.componentSlot.component)), "shiptrader")
	if shiptrader then
		if menu.shown then
			if menu.interactMenuID then
				C.NotifyInteractMenuHidden(menu.interactMenuID, true)
			end
			Helper.closeMenuAndOpenNewMenu(menu, "ShipConfigurationMenu", { 0, 0, menu.componentSlot.component, mode }, true)
			menu.cleanup()
		else
			Helper.resetUpdateHandler()
			Helper.clearFrame(menu, config.layer)
			Helper.returnFromInteractMenu(menu.currentOverTable, "newmenu", { "ShipConfigurationMenu", { 0, 0, menu.componentSlot.component, mode } })
			menu.cleanup()
		end
	else
		DebugError("menu.buttonShipConfig(): unable to retrieve ship trader of " .. ffi.string(C.GetComponentName(menu.componentSlot.component)) .. ".")
	end
end

function menu.buttonStationConfig()
	local station = menu.componentSlot.component
	if C.IsComponentClass(menu.componentSlot.component, "buildstorage") then
		station = ConvertIDTo64Bit(GetComponentData(ConvertStringTo64Bit(tostring(menu.componentSlot.component)), "basestation")) or 0
	end

	if menu.shown then
		if menu.interactMenuID then
			C.NotifyInteractMenuHidden(menu.interactMenuID, true)
		end
		Helper.closeMenuAndOpenNewMenu(menu, "StationConfigurationMenu", { 0, 0, station }, true)
		menu.cleanup()
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "newmenu", { "StationConfigurationMenu", { 0, 0, station } })
		menu.cleanup()
	end
end

function menu.buttonStationOverview()
	local station = menu.componentSlot.component
	if C.IsComponentClass(menu.componentSlot.component, "buildstorage") then
		station = ConvertIDTo64Bit(GetComponentData(ConvertStringTo64Bit(tostring(menu.componentSlot.component)), "basestation")) or 0
	end

	if menu.shown then
		if menu.interactMenuID then
			C.NotifyInteractMenuHidden(menu.interactMenuID, true)
		end
		Helper.closeMenuAndOpenNewMenu(menu, "StationOverviewMenu", { 0, 0, station }, true)
		menu.cleanup()
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "newmenu", { "StationOverviewMenu", { 0, 0, station } })
		menu.cleanup()
	end
end

function menu.buttonTeleport()
	local isplayerownedtarget = GetComponentData(ConvertStringTo64Bit(tostring(menu.componentSlot.component)), "isplayerowned")

	C.TeleportPlayerTo(menu.componentSlot.component, false, menu.mode == "shipconsole", (menu.mode == "shipconsole") and isplayerownedtarget)
	menu.onCloseElement("close")
end

function menu.buttonTrade(wareexchange, tradepartner, loop)
	tradepartner = tradepartner or ConvertStringTo64Bit(tostring(menu.componentSlot.component))
	trader = (#menu.selectedplayerships == 1) and ConvertStringTo64Bit(tostring(menu.selectedplayerships[1])) or nil

	if menu.shown then
		if menu.interactMenuID then
			C.NotifyInteractMenuHidden(menu.interactMenuID, true)
		end
		Helper.closeMenuAndOpenNewMenu(menu, "MapMenu", { 0, 0, true, nil, nil, 'tradecontext', { tradepartner, nil, wareexchange, nil, loop, trader } }, true)
		menu.cleanup()
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "tradecontext", { tradepartner, nil, wareexchange, loop, trader } )
		menu.cleanup()
	end
end

function menu.buttonTravelMode(activate)
	if activate then
		C.StartPlayerActivity("travel")
	else
		local currentactivity = GetPlayerActivity()
		C.StopPlayerActivity(currentactivity)
	end
	menu.onCloseElement("close")
end

function menu.buttonVenturePatron()
	if menu.shown then
		if menu.interactMenuID then
			C.NotifyInteractMenuHidden(menu.interactMenuID, true)
		end
		Helper.closeMenuAndOpenNewMenu(menu, "MapMenu", { 0, 0, true, nil, nil, 'venturepatroninfo', { ConvertStringTo64Bit(tostring(menu.componentSlot.component)) } }, true)
		menu.cleanup()
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "venturepatroninfo", { ConvertStringTo64Bit(tostring(menu.componentSlot.component)) } )
		menu.cleanup()
	end
end

function menu.buttonVentureReportShip()
	local convertedcomponent = ConvertStringTo64Bit(tostring(menu.componentSlot.component))
	local venturetransactionid = GetComponentData(convertedcomponent, "venturetransactionid")
	if menu.shown then
		if menu.interactMenuID then
			C.NotifyInteractMenuHidden(menu.interactMenuID, true)
		end
		Helper.closeMenuAndOpenNewMenu(menu, "MapMenu", { 0, 0, true, nil, nil, 'venturereport', { "ship", "Offensive ship name", nil, nil, venturetransactionid } }, true) -- hardcoded text only visible in venture server moderator interface
		menu.cleanup()
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "venturereport", { "ship", "Offensive ship name", nil, nil, venturetransactionid } )
		menu.cleanup()
	end
end

function menu.buttonVentureReportUser()
	local convertedcomponent = ConvertStringTo64Bit(tostring(menu.componentSlot.component))
	local userid = GetComponentData(convertedcomponent, "ventureuserid")
	if menu.shown then
		if menu.interactMenuID then
			C.NotifyInteractMenuHidden(menu.interactMenuID, true)
		end
		Helper.closeMenuAndOpenNewMenu(menu, "MapMenu", { 0, 0, true, nil, nil, 'venturereport', { "user", "Offensive ship name", nil, nil, nil, userid } }, true) -- hardcoded text only visible in venture server moderator interface
		menu.cleanup()
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "venturereport", { "user", "Offensive ship name", nil, nil, nil, userid } )
		menu.cleanup()
	end
end

-- cheats

function menu.buttonOwnerCheat()
	C.MakePlayerOwnerOf(menu.componentSlot.component)
	if C.IsComponentClass(menu.componentSlot.component, "ship") and (not GetComponentData(ConvertStringTo64Bit(tostring(menu.componentSlot.component)), "isdeployable")) then
		C.CreateOrder(menu.componentSlot.component, "Wait", true)
		C.EnablePlannedDefaultOrder(menu.componentSlot.component, false)
	end

	if menu.shown then
		menu.onCloseElement("close")
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		Helper.returnFromInteractMenu(menu.currentOverTable, "refresh")
		menu.cleanup()
	end
end

function menu.buttonSatelliteCheat()
	local macro = GetWareData("satellite_mk2", "component")
	C.SpawnObjectAtPos(macro, menu.offsetcomponent, menu.offset)
	menu.onCloseElement("close")
end

function menu.buttonNavBeaconCheat()
	local macro = GetWareData("waypointmarker_01", "component")
	C.SpawnObjectAtPos(macro, menu.offsetcomponent, menu.offset)
	menu.onCloseElement("close")
end

function menu.buttonResourceProbeCheat()
	local macro = GetWareData("resourceprobe_01", "component")
	C.SpawnObjectAtPos(macro, menu.offsetcomponent, menu.offset)
	menu.onCloseElement("close")
end

function menu.buttonWarpCheat()
	C.MovePlayerToSectorPos(menu.offsetcomponent, menu.offset)
	menu.onCloseElement("close")
end

function menu.checkboxSubordinateGroupAttackOnSight(group, checked)
	C.SetSubordinateGroupAttackOnSight(menu.componentSlot.component, group, checked)
end

function menu.checkboxSubordinateGroupResupplyAtFleet(group, checked)
	C.SetSubordinateGroupResupplyAtFleet(menu.componentSlot.component, group, checked)
end

function menu.checkboxSubordinateGroupReinforceFleet(group, checked)
	C.SetSubordinateGroupReinforceFleet(menu.componentSlot.component, group, checked)
end

-- interact menu hooks

function menu.showInteractMenu(param)
	AddUITriggeredEvent(menu.name, "")
	menu.componentSlot = ffi.new("UIComponentSlot")
	menu.componentSlot.component = ConvertStringTo64Bit(tostring(param.component))
	AddUITriggeredEvent(menu.name, "id", ConvertStringTo64Bit(tostring(menu.componentSlot.component)))
	local connection = "connectionui"
	menu.connection = Helper.ffiNewString(connection)	-- store string here to keep it alive during lifetime of menu.componentSlot
	menu.componentSlot.connection = menu.connection
	menu.componentOrder = param.order
	menu.syncpoint = param.syncpoint
	menu.syncpointorder = param.syncpointorder
	menu.intersectordefencegroup = param.intersectordefencegroup
	menu.mission = param.mission
	menu.componentMissions = param.componentmissions
	menu.missionoffer = param.missionoffer
	menu.construction = param.construction
	menu.subordinategroup = param.subordinategroup
	menu.selectedplayerships = param.playerships
	menu.selectedotherobjects = param.otherobjects
	menu.selectedplayerdeployables = param.playerdeployables
	menu.playerSquad = menu.getPlayerSquad()
	menu.offsetcomponent = param.offsetcomponent
	menu.offset = param.offset
	menu.mouseX = param.mouseX
	menu.mouseY = param.mouseY

	menu.processSelectedPlayerShips()

	menu.display()
end

function menu.onShowMenu(_, _, serializedArg)
	C.SetTrackedMenuFullscreen(menu.name, false)
	if menu.param and (menu.param[3] == "shipconsole") then
		menu.mode = "shipconsole"
		menu.interactMenuID = nil
		menu.componentSlot = ffi.new("UIComponentSlot")
		menu.componentSlot.component = ConvertIDTo64Bit(menu.param[4])
		local connection = "connectionui"
		menu.connection = Helper.ffiNewString(connection)	-- store string here to keep it alive during lifetime of menu.componentSlot
		menu.componentSlot.connection = menu.connection
		menu.isdockedship = menu.param[5] == 1
	else
		menu.interactMenuID = tonumber(string.match(serializedArg, "%d+"))
		serializedArg = string.sub(serializedArg, string.find(serializedArg, ";") + 1)
		menu.componentSlot = ffi.new("UIComponentSlot")
		menu.componentSlot.component = ConvertStringTo64Bit(string.match(serializedArg, "%d+"))
		if C.IsSurfaceElement(menu.componentSlot.component) then
			menu.componentSlot.component = C.GetContextByClass(menu.componentSlot.component, "container", false)
		end
		local connection = string.sub(serializedArg, string.find(serializedArg, ";") + 1)
		menu.connection = Helper.ffiNewString(connection)	-- store string here to keep it alive during lifetime of menu.componentSlot
		menu.componentSlot.connection = menu.connection
		-- Handle mission offers
		local _, _, _, _, _, _, _, _, _, _, missionOfferID = GetMissionOfferAtConnection(ConvertStringTo64Bit(tostring(menu.componentSlot.component)), connection)
		if missionOfferID ~= nil then
			menu.missionoffer = tostring(missionOfferID)
		end
	end
	AddUITriggeredEvent(menu.name, "id", ConvertStringTo64Bit(tostring(menu.componentSlot.component)))

	local occupiedPlayerShip = C.GetPlayerOccupiedShipID()
	local toplevelcontainer = C.GetTopLevelContainer(C.GetPlayerID())
	if occupiedPlayerShip ~= 0 then
		menu.selectedplayerships = { ConvertStringTo64Bit(tostring(occupiedPlayerShip)) }
	elseif (menu.mode ~= "shipconsole") and (toplevelcontainer ~= 0) and C.IsComponentClass(toplevelcontainer, "ship") and GetComponentData(ConvertStringTo64Bit(tostring(toplevelcontainer)), "isplayerowned") then
		menu.selectedplayerships = { ConvertStringTo64Bit(tostring(toplevelcontainer)) }
	else
		menu.selectedplayerships = {}
	end
	menu.selectedotherobjects = {}
	menu.selectedplayerdeployables = {}
	menu.processSelectedPlayerShips()
	menu.playerSquad = menu.getPlayerSquad()

	if menu.interactMenuID then
		C.NotifyInteractMenuShown(menu.interactMenuID)
	end

	menu.display()
end

function menu.onShowMenuSound()
	-- no sound
end

-- displaying the menu

function menu.display()
	menu.width = Helper.scaleX(config.width)

	local posX, posY = GetLocalMousePosition()
	if menu.mode == "shipconsole" then
		posX, posY = -menu.width / 2, 0
	end
	if posX == nil then
		-- gamepad case
		if menu.mouseX ~= nil then
			posX = menu.mouseX + Helper.viewWidth / 2
			posY = menu.mouseY + Helper.viewHeight / 2
		else
			local pos = C.GetCompSlotScreenPos(menu.componentSlot)
			posX = pos.x + Helper.viewWidth / 2
			posY = pos.y + Helper.viewHeight / 2
		end
	else
		posX = posX + Helper.viewWidth / 2
		posY = Helper.viewHeight / 2 - posY
	end
	menu.posX = posX
	menu.posY = posY

	menu.holomapcolor = Helper.getHoloMapColors()
	menu.prepareTexts()
	if not menu.prepareActions() then
		-- no actions found
		menu.onCloseElement("close")
		return
	end

	menu.draw()
end

function menu.draw()
	local width = menu.width
	if menu.subsection then
		width = 2 * width + Helper.borderSize
	end

	menu.frameX = menu.wasMonitorAdjusted and menu.wasMonitorAdjusted.x or math.max(0, menu.posX)
	menu.frameY = menu.wasMonitorAdjusted and menu.wasMonitorAdjusted.y or math.max(0, menu.posY)
	menu.frame = Helper.createFrameHandle(menu, {
		x = menu.frameX,
		y = 0,
		width = width + Helper.scrollbarWidth,
		layer = config.layer,
		standardButtons = { close = true },
		standardButtonX = Helper.scrollbarWidth,
		autoFrameHeight = true,
		closeOnUnhandledClick = true,
		playerControls = true,
		startAnimation = false,
	})
	local frame = menu.frame

	local content_position = "left"
	local subsection_position = "right"
	if menu.subsection then
		if menu.forceSubSectionToLeft then
			-- content table is at the right border of a monitor -> subsection table goes to the left
			menu.frameX = menu.frameX - menu.width - Helper.borderSize
			content_position = "right"
			subsection_position = "left"
		elseif frame.properties.x + menu.width > Helper.viewWidth then
			-- content table is at the right border -> subsection table goes to the left
			menu.frameX = Helper.viewWidth - width - config.border
			content_position = "right"
			subsection_position = "left"
		elseif frame.properties.x + width > Helper.viewWidth then
			-- not enough space for the subsection table -> subsection table goes to the left
			menu.frameX = frame.properties.x - menu.width - Helper.borderSize
			content_position = "right"
			subsection_position = "left"
		else
			frame.properties.standardButtonX = frame.properties.standardButtonX + menu.width + Helper.borderSize
		end
	else
		if frame.properties.x + menu.width > Helper.viewWidth then
			menu.frameX = Helper.viewWidth - menu.width - config.border
		end
	end
	frame.properties.x = menu.frameX

	Helper.removeAllWidgetScripts(menu, config.layer)
	local contentTable = menu.createContentTable(frame, content_position)
	local subsectionTable
	if menu.subsection then
		subsectionTable = menu.createSubSectionTable(frame, subsection_position)
	end

	local height = contentTable:getFullHeight()
	local subsectionHeight = 0
	if menu.frameY + height > Helper.viewHeight then
		menu.frameY = math.max(0, Helper.viewHeight - height - config.border)
	else
		if menu.mode == "shipconsole" then
			menu.frameY = Helper.viewHeight / 2 - height / 2
		end
	end
	frame.properties.y = menu.frameY
	if menu.subsection then
		subsectionHeight = subsectionTable:getFullHeight()
		subsectionTable.properties.y = menu.subsection.y - subsectionHeight + Helper.scaleY(config.rowHeight)
		if subsectionTable.properties.y < 0 then
			local diff = -subsectionTable.properties.y
			menu.frameY = frame.properties.y - diff
			frame.properties.y = menu.frameY
			frame.properties.standardButtonY = diff
			contentTable.properties.y = diff
			subsectionTable.properties.y = 0
		end
	end

	local frameheight = frame:getUsedHeight()

	local mouseOutBoxExtension = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	}

	-- in HUD prevent overlap with monitors (but do not update if we are showing a subsection, we do not want the interact menu to jump around)
	if menu.shown and (not menu.subsection) then
		--[[ comment this line to enable debug visualisation
		local visframe = Helper.createFrameHandle(menu, {
			x = 0,
			y = 0,
			width = Helper.viewWidth,
			height = Helper.viewHeight,
			layer = config.layer + 1,
			standardButtons = {  },
			playerControls = true,
			startAnimation = false,
		})--]]

		local monitors = {
			{ offsetid = "targetmonitor",	uianchorindex = 0 },
			{ offsetid = "radar",			uianchorindex = 2,		noright = true },
			{ offsetid = "messageticker",	uianchorindex = 3,		noright = true },
		}

		-- keep original frame position for comparision with new position to judge convenience
		local origFrameX, origFrameY = menu.frameX, menu.frameY
		for _, monitor in ipairs(monitors) do
			-- get the monitor extents (in worldspace coordinates)
			local monitoroffset = C.GetMonitorExtents(monitor.offsetid)
			if (monitoroffset.width ~= 0) and (monitoroffset.height ~= 0) then
				-- get monitor extents in screen position coordinates
				local minX, maxX, minY, maxY = menu.getMonitorExtents(monitoroffset, monitor.uianchorindex, visframe)
				local monitorexclusionzone = {
					x = math.floor(minX),
					y = math.floor(minY),
					width = math.ceil(maxX - minX),
				}

				if visframe then
					-- debug visualization
					local vistable = visframe:addTable(1, { tabOrder = 100, x = monitorexclusionzone.x, y = monitorexclusionzone.y, width = math.min(monitorexclusionzone.width, Helper.viewWidth - monitorexclusionzone.x), backgroundID = "solid", backgroundColor = Color["text_error"], highlightMode = "off" })
					local visrow = vistable:addRow(false, {})
					visrow[1]:createText(" ", { minRowHeight = Helper.viewHeight - monitorexclusionzone.y, scaling = false, x = 0 })
				end

				-- move interact menu out of exclusion zone
				menu.excludeMonitorZone(frame, monitorexclusionzone, width, frameheight, origFrameX, origFrameY, mouseOutBoxExtension, monitor.noright)
			end
		end

		if visframe then
			visframe:display()
		end
	end

	menu.mouseOutBox = {
		x1 =   frame.properties.x -  Helper.viewWidth / 2                                      - config.mouseOutRange - mouseOutBoxExtension.left,
		x2 =   frame.properties.x -  Helper.viewWidth / 2 + width                              + config.mouseOutRange + mouseOutBoxExtension.right,
		y1 = - frame.properties.y + Helper.viewHeight / 2                                      + config.mouseOutRange + mouseOutBoxExtension.top,
		y2 = - frame.properties.y + Helper.viewHeight / 2 - frameheight                        - config.mouseOutRange - mouseOutBoxExtension.bottom,
	}

	frame:display()
end

function menu.getMonitorExtents(monitoroffset, uianchorindex, visframe)
	local minX, maxX, minY, maxY
	for i = 1, 4 do
		local offset = ffi.new("PosRot")
		if i == 1 then
			-- upper left corner
			offset.x = monitoroffset.x - monitoroffset.width / 2
			offset.y = monitoroffset.y + monitoroffset.height / 2
		elseif i == 2 then
			-- upper right corner
			offset.x = monitoroffset.x + monitoroffset.width / 2
			offset.y = monitoroffset.y + monitoroffset.height / 2
		elseif i == 3 then
			-- lower right corner
			offset.x = monitoroffset.x + monitoroffset.width / 2
			offset.y = monitoroffset.y - monitoroffset.height / 2
		elseif i == 4 then
			-- lower left corner
			offset.x = monitoroffset.x - monitoroffset.width / 2
			offset.y = monitoroffset.y - monitoroffset.height / 2
		end
		local anchoroffset = C.GetUIAnchorScreenPosition("monitors", uianchorindex, offset)
		minX = minX and math.min(anchoroffset.x, minX) or anchoroffset.x
		maxX = maxX and math.max(anchoroffset.x, maxX) or anchoroffset.x
		minY = minY and math.min(anchoroffset.y, minY) or anchoroffset.y
		maxY = maxY and math.max(anchoroffset.y, maxY) or anchoroffset.y

		if visframe then
			-- debug visualization
			local vistable = visframe:addTable(1, { tabOrder = 100 + i, x = anchoroffset.x, y = math.min(anchoroffset.y, Helper.viewHeight - 5), width = 5, backgroundID = "solid", backgroundColor = Color["text_warning"], highlightMode = "off", reserveScrollBar = false })
			local visrow = vistable:addRow(false, {})
			visrow[1]:createText(" ", { fontsize = 1, minRowHeight = 5, scaling = false, x = 0 })
		end
	end
	return minX, maxX, minY, maxY
end

function menu.excludeMonitorZone(frame, monitorexclusionzone, framewidth, frameheight, origFrameX, origFrameY, mouseOutBoxExtension, noright)
	local needschange = true
	-- check y coord first
	if menu.frameY + frameheight > monitorexclusionzone.y then
		if needschange and (menu.frameX < monitorexclusionzone.x) then
			-- clicked left of the monitor, check if overlapping
			if menu.frameX + framewidth > monitorexclusionzone.x + monitorexclusionzone.width then
				-- interact menu extends beyond the monitor on both sides, move it up
				local newY = monitorexclusionzone.y - frameheight
				mouseOutBoxExtension.bottom = origFrameY - newY
				menu.frameY = math.max(0, newY)
				needschange = false
			elseif (not menu.forceSubSectionToLeft) and (menu.frameX + framewidth > monitorexclusionzone.x) then
				-- overlapping with the monitor, flip to left from cursor
				local newX = menu.frameX - framewidth
				-- make sure we have enough space left for a subsection on the left
				if newX > menu.width + Helper.borderSize then
					menu.frameX = newX
					needschange = false
					menu.forceSubSectionToLeft = true
				end
			elseif menu.frameX + 2 * menu.width + Helper.borderSize > monitorexclusionzone.x then
				-- ok, but no space for subsection -> force to left
				needschange = false
				menu.forceSubSectionToLeft = true
			else
				needschange = false
			end
		end
		if needschange and (menu.frameX < monitorexclusionzone.x + monitorexclusionzone.width) then
			-- clicked inside the monitor or left to the monitor but no space on the left
			-- check whether to move left, up or right
			local newX1 = monitorexclusionzone.x - framewidth
			if newX1 < menu.width + Helper.borderSize then
				-- doesn't fit a potential subsection, make impossible
				newX1 = -1000000000
			end
			local newX2 = monitorexclusionzone.x + monitorexclusionzone.width
			if noright or (newX2 + framewidth > Helper.viewWidth) then
				-- doesn't fit, make impossible
				newX2 = 1000000000
			end
			local newY = monitorexclusionzone.y - frameheight

			local diffX1 = origFrameX - newX1
			local diffX2 = newX2 - origFrameX
			local diffY = origFrameY - newY

			if (diffX1 < diffX2) and (diffX1 < diffY) then
				-- moving left
				mouseOutBoxExtension.right = diffX1
				menu.frameX = newX1
				needschange = false
				menu.forceSubSectionToLeft = true
			elseif (not diffX1) or (diffX2 < diffX1) and (diffX2 < diffY) then
				-- moving right
				mouseOutBoxExtension.left = diffX2
				needschange = false
				menu.frameX = newX2
			elseif (diffY < diffX1) and (diffY < diffX2) then
				-- moving up
				mouseOutBoxExtension.bottom = diffY
				menu.frameY = math.max(0, newY)
				needschange = false
			end
		end
	end

	if not needschange then
		menu.wasMonitorAdjusted = { x = menu.frameX, y = menu.frameY }
		frame.properties.x = menu.frameX
		frame.properties.y = menu.frameY
	end

end

function menu.addSectionTitle(ftable, section, first)
	if first and (#menu.selectedplayerships > 0) then
		return 0
	end

	local convertedComponent = ConvertStringTo64Bit(tostring(menu.componentSlot.component))
	local commander
	if (convertedComponent ~= 0) and C.IsComponentClass(menu.componentSlot.component, "controllable") then
		commander = ConvertIDTo64Bit(GetCommander(convertedComponent))
	end

	local height = 0
	if section.text ~= "" then
		local addspacing = not first
		if section.id == "main_assignments_subsections" then
			addspacing = false
			if menu.subordinategroup then
				addspacing = true
			elseif menu.showPlayerInteractions or ((#menu.selectedplayerships == 0) and (not menu.shown)) then
				if (not commander) or (commander == 0) then
					addspacing = true
				end
			end
		end
		if addspacing then
			local row = ftable:addEmptyRow(config.rowHeight / 2)
			height = height + row:getHeight() + Helper.borderSize
		end
		local text = section.text
		if section.showloop and (menu.numorderloops > 0) then
			text = utf8.char(8734) .. " " .. text
		end

		local row = ftable:addRow(false, {  })
		if section.id == "main_assignments" then
			row[1]:createText(string.format(text, menu.texts.commanderShortName), { font = Helper.standardFontBold, mouseOverText = menu.texts.commanderName, titleColor = Color["row_title"] })
			row[4]:createText("[" .. GetComponentData(convertedComponent, "assignmentname") .. "]", { font = Helper.standardFontBold, halign = "right", height = Helper.subHeaderHeight, titleColor = Color["row_title"] })
		elseif section.id == "main_assignments_subsections" then
			if menu.subordinategroup then
				local selectiontext = menu.texts.selectedName
				local fullselectiontext = menu.texts.selectedFullNames
				if menu.groupShips and (#menu.groupShips > 0) then
					selectiontext = GetComponentData(menu.groupShips[1].component, "name")
					if #menu.groupShips > 1 then
						selectiontext = string.format(ReadText(1001, 7801), #menu.groupShips)
					end
					local color = menu.holomapcolor.playercolor
					local first = true
					fullselectiontext = ""
					for _, shipentry in ipairs(menu.groupShips) do
						fullselectiontext = fullselectiontext .. (first and "" or "\n") .. Helper.convertColorToText(color) .. shipentry.name .. " (" .. shipentry.objectid .. ")"
						first = false
					end
				end
				row[1]:createText(text, { font = Helper.standardFontBold, mouseOverText = fullselectiontext, titleColor = Color["row_title"] })
				row[4]:createText(selectiontext, { font = Helper.standardFontBold, halign = "right", color = menu.holomapcolor.playercolor, mouseOverText = fullselectiontext, height = Helper.subHeaderHeight, titleColor = Color["row_title"] })
			elseif menu.showPlayerInteractions or ((#menu.selectedplayerships == 0) and (not menu.shown)) then
				if (not commander) or (commander == 0) then
					row[1]:setColSpan(5):createText(ReadText(1010, 1), { font = Helper.standardFontBold, mouseOverText = fullselectiontext, titleColor = Color["row_title"] })
				end
			end
		elseif section.id == "player_interaction" then
			if not first then
				row[1]:createText(text, { font = Helper.standardFontBold, mouseOverText = text .. " " .. menu.texts.targetName, titleColor = Color["row_title"] })
				row[4]:createText(menu.texts.targetBaseName or menu.texts.targetShortName, { font = Helper.standardFontBold, halign = "right", color = menu.colors.target, mouseOverText = text .. " " .. menu.texts.targetName, height = Helper.subHeaderHeight, titleColor = Color["row_title"] })
			end
		elseif (section.id == "selected_orders_all") or (section.id == "selected_assignments_all") then
			row[1]:createText(text, { font = Helper.standardFontBold, mouseOverText = menu.texts.selectedFullNamesAll, titleColor = Color["row_title"] })
			row[4]:createText(menu.texts.selectedNameAll, { font = Helper.standardFontBold, halign = "right", color = menu.colors.selected, mouseOverText = menu.texts.selectedFullNamesAll, height = Helper.subHeaderHeight, titleColor = Color["row_title"] })
		elseif (section.id == "selected_orders") or (section.id == "trade_orders") then
			row[1]:createText(text, { font = Helper.standardFontBold, mouseOverText = menu.texts.selectedFullNames, titleColor = Color["row_title"] })
			row[4]:createText(menu.texts.selectedName, { font = Helper.standardFontBold, halign = "right", color = menu.colors.selected, mouseOverText = menu.texts.selectedFullNames, height = Helper.subHeaderHeight, titleColor = Color["row_title"] })
		elseif (section.id == "selected_assignments") or (section.id == "selected_change_assignments") then
			local selectiontext = menu.texts.selectedName
			local fullselectiontext = menu.texts.selectedFullNames

			if section.id == "selected_change_assignments" then
				if menu.shipswithcurrentcommander and (#menu.shipswithcurrentcommander > 0) then
					selectiontext = GetComponentData(menu.shipswithcurrentcommander[1], "name")
					if #menu.shipswithcurrentcommander > 1 then
						selectiontext = string.format(ReadText(1001, 7801), #menu.shipswithcurrentcommander)
					end
					local color = menu.holomapcolor.playercolor
					local first = true
					fullselectiontext = ""
					for _, ship in ipairs(menu.shipswithcurrentcommander) do
						fullselectiontext = fullselectiontext .. (first and "" or "\n") .. Helper.convertColorToText(color) .. GetComponentData(ship, "name") .. " (" .. ffi.string(C.GetObjectIDCode(ship)) .. ")"
						first = false
					end
				end
			end

			row[1]:createText(text, { font = Helper.standardFontBold, mouseOverText = fullselectiontext, titleColor = Color["row_title"] })
			row[4]:createText(selectiontext, { font = Helper.standardFontBold, halign = "right", color = menu.colors.selected, mouseOverText = fullselectiontext, height = Helper.subHeaderHeight, titleColor = Color["row_title"] })
		elseif section.id == "overrideorderoption" then
			row[1]:createText(ColorText["text_error"] .. text, { font = Helper.standardFontBold, mouseOverText = menu.texts.selectedFullNames, titleColor = Color["row_title"] })
			row[4]:createText(menu.texts.overrideordername, { font = Helper.standardFontBold, halign = "right", color = menu.colors.selected, mouseOverText = menu.texts.selectedFullNames, height = Helper.subHeaderHeight, titleColor = Color["row_title"] })
		else
			row[1]:setColSpan(5):createText(text, { font = Helper.standardFontBold, height = Helper.subHeaderHeight, titleColor = Color["row_title"] })
		end
		height = height + row:getHeight() + Helper.borderSize
	elseif section.id == "shipconsole" then
		if not first then
			local row = ftable:addEmptyRow(config.rowHeight / 2)
			height = height + row:getHeight() + Helper.borderSize
			local row = ftable:addRow(false, {  })
			row[1]:setColSpan(5):createText(ffi.string(C.GetComponentName(menu.isdockedship and C.GetContextByClass(menu.componentSlot.component, "dockingbay", false) or menu.componentSlot.component)), Helper.headerRowCenteredProperties)
			height = height + row:getHeight() + Helper.borderSize
		end
	end
	return height
end

function menu.createContentTable(frame, position)
	local x = 0
	if position == "right" then
		x = menu.width + Helper.borderSize
	end

	-- kuertee start: forceShowMenus: show main, interaction, custom_actions menu when no actions to show
	-- local uix_forceShowSections = {"main", "interaction", "custom_actions"}
	-- local uix_forceShowSections = {"interaction", "custom_actions"}
	local uix_forceShowSections = {"custom_actions"}
	local uix_forceShowSections_isStationActions
	if #menu.selectedplayerships == 0 and #menu.selectedotherobjects > 0 then
		uix_forceShowSections_isStationActions = C.IsRealComponentClass(menu.selectedotherobjects[1], "station")
	end
	-- kuertee end: forceShowMenus: show main, interaction, custom_actions menu when no actions to show

	local ftable = frame:addTable(5, { tabOrder = menu.subsection and 2 or 1, x = x, width = menu.width, backgroundID = "solid", backgroundColor = Color["frame_background_semitransparent"], highlightMode = "off" })
	ftable:setDefaultCellProperties("text",   { minRowHeight = config.rowHeight, fontsize = config.entryFontSize, x = config.entryX })
	ftable:setDefaultCellProperties("button", { height = config.rowHeight })
	ftable:setDefaultCellProperties("checkbox", { height = config.rowHeight, width = config.rowHeight })
	ftable:setDefaultComplexCellProperties("button", "text", { fontsize = config.entryFontSize, x = config.entryX })
	ftable:setDefaultComplexCellProperties("button", "text2", { fontsize = config.entryFontSize, x = config.entryX })

	local text = menu.texts.targetShortName
	local color = menu.colors.target
	if menu.construction then
		text = menu.texts.constructionName
	end

	local modetext = ReadText(1001, 7804)
	if (not menu.syncpoint) and (not menu.syncpointorder) and (not menu.intersectordefencegroup) and (not menu.mission) and (not menu.missionoffer) then
		if (not menu.showPlayerInteractions) and (#menu.selectedplayerships > 0) then
			if #menu.actions["selected_orders_all"] > 0 then
				modetext = ReadText(1001, 7804)
				text = menu.texts.selectedNameAll
			elseif #menu.actions["selected_orders"] > 0 then
				modetext = ReadText(1001, 7804)
				text = menu.texts.selectedName
			elseif #menu.actions["trade_orders"] > 0 then
				modetext = ReadText(1001, 7861)
				text = menu.texts.selectedName
			elseif #menu.actions["selected_assignments_all"] > 0 then
				modetext = ReadText(1001, 7886)
				text = menu.texts.selectedNameAll
			else
				-- fallback if no section is used (aka no interaction possible)
				text = menu.texts.selectedName
			end
			if menu.numorderloops > 0 then
				modetext = utf8.char(8734) .. " " .. modetext
			end
			color = menu.colors.selected
		elseif (#menu.selectedplayerships == 0) and (#menu.selectedotherobjects > 0) then
			modetext = ReadText(1001, 7804)

			-- kuertee start: forceShowMenus: show main, interaction, custom_actions menu when no actions to show
			if not uix_forceShowSections_isStationActions then
				text = menu.texts.otherName
			else
				text = GetComponentData(menu.selectedotherobjects[1], "name")
			end
			-- kuertee end: forceShowMenus: show main, interaction, custom_actions menu when no actions to show

			color = menu.colors.selected
		elseif (#menu.ventureships > 0) and (#menu.selectedplayerships == 0) then
			text = menu.texts.ventureName
			color = menu.colors.venture
		end
	end
	if text == nil then
		DebugError("Interact title text is nil [Florian]" ..
			"\n   targetShortName: " ..tostring(menu.texts.targetShortName) ..
			"\n   construction: " .. tostring(menu.construction) ..
			"\n   constructionName: " .. tostring(menu.texts.constructionName) ..
			"\n   selectedNameAll: " .. tostring(menu.texts.selectedNameAll) ..
			"\n   selectedName: " .. tostring(menu.texts.selectedName) ..
			"\n   otherName: " .. tostring(menu.texts.otherName) ..
			"\n   ventureName: " .. tostring(menu.texts.ventureName) ..
			"\n   #menu.selectedplayerships: " .. tostring(#menu.selectedplayerships) ..
			"\n   #menu.selectedotherobjects: " .. tostring(#menu.selectedotherobjects) ..
			"\n   #menu.ventureships: " .. tostring(#menu.ventureships) ..
			"\n   showPlayerInteractions: " .. tostring(menu.showPlayerInteractions) ..
			"\n   syncpoint: " .. tostring(menu.syncpoint) ..
			"\n   syncpointorder: " .. tostring(menu.syncpointorder) ..
			"\n   intersectordefencegroup: " .. tostring(menu.intersectordefencegroup) ..
			"\n   mission: " .. tostring(menu.mission) ..
			"\n   missionoffer: " .. tostring(menu.missionoffer) ..
			"\n   #menu.actions['selected_orders_all']: " .. tostring(#menu.actions["selected_orders_all"]) ..
			"\n   #menu.actions['selected_orders']: " .. tostring(#menu.actions["selected_orders"]) ..
			"\n   #menu.actions['trade_orders']: " .. tostring(#menu.actions["trade_orders"]) ..
			"\n   #menu.actions['selected_assignments_all']: " .. tostring(#menu.actions["selected_assignments_all"])
		)
		text = ""
	end

	-- need a min width here, otherwise column 3 gets a negative width if the mode text would fit into column 2
	local modetextwidth = math.ceil(math.max(0.2 * menu.width + 2 * Helper.borderSize, C.GetTextWidth(" " .. modetext .. " ", Helper.standardFontBold, Helper.scaleFont(Helper.standardFont, Helper.headerRow1FontSize, true))))
	local bordericonsize = Helper.scaleX(Helper.headerRow1Height)
	local borderwidth = math.ceil(math.max(bordericonsize, (menu.width - modetextwidth - 2 * Helper.borderSize) / 2))
	borderwidth = math.max(borderwidth, Helper.scaleX(config.rowHeight) + Helper.borderSize + 1)

	ftable:setColWidth(1, config.rowHeight)
	ftable:setColWidth(2, borderwidth - Helper.scaleX(config.rowHeight) - Helper.borderSize, false)
	ftable:setColWidth(4, math.ceil(0.4 * menu.width - borderwidth - Helper.borderSize), false)
	ftable:setColWidth(5, borderwidth, false)
	ftable:setDefaultBackgroundColSpan(1, 4)
	ftable:setDefaultColSpan(1, 3)
	ftable:setDefaultColSpan(4, 2)

	local height = 0

	-- kuertee start: forceShowMenus: show main, interaction, custom_actions menu when no actions to show
	if (((not menu.showPlayerInteractions) and (#menu.selectedplayerships > 0)) or ((#menu.selectedplayerships == 0) and (#menu.selectedotherobjects > 0))) and (not menu.syncpoint) and (not menu.syncpointorder) and (not menu.intersectordefencegroup) and (not menu.mission) and (not menu.missionoffer) then
	-- if (not uix_forceShowSections_isStationActions) and (((not menu.showPlayerInteractions) and (#menu.selectedplayerships > 0)) or ((#menu.selectedplayerships == 0) and (#menu.selectedotherobjects > 0))) and (not menu.syncpoint) and (not menu.syncpointorder) and (not menu.intersectordefencegroup) and (not menu.mission) and (not menu.missionoffer) then
	-- kuertee end: forceShowMenus: show main, interaction, custom_actions menu when no actions to show

		-- modemarker
		local row = ftable:addRow(false, {  })
		row[1]:setBackgroundColSpan(5):setColSpan(2):createIcon("be_diagonal_01", { width = bordericonsize, height = bordericonsize, x = borderwidth - bordericonsize + Helper.borderSize, scaling = false, color = Color["row_background_blue_opaque"] })
		row[4]:setColSpan(1)
		row[3]:setColSpan(2)
		local width = row[3]:getColSpanWidth() + Helper.scrollbarWidth + Helper.borderSize
		row[3]:createIcon("solid", { height = bordericonsize, width = width, scaling = false, color = Color["row_background_blue_opaque"] }):setText(modetext, { font = Helper.headerRow1Font, fontsize = Helper.scaleFont(Helper.headerRow1Font, Helper.headerRow1FontSize, true), halign = "center", x = math.ceil((width - Helper.borderSize) / 2) })
		row[5]:setColSpan(1):createIcon("be_diagonal_02", { width = bordericonsize, height = bordericonsize, scaling = false, color = Color["row_background_blue_opaque"] })
		height = height + row:getHeight() + Helper.borderSize
	end
	-- title
	local row = ftable:addRow(false, {  })
	text = TruncateText(text, Helper.standardFontBold, Helper.scaleFont(Helper.standardFontBold, Helper.headerRow1FontSize), menu.width - Helper.scaleX(Helper.standardButtonWidth) - 2 * config.entryX)
	row[1]:setColSpan(5):createText(text, Helper.headerRowCenteredProperties)
	row[1].properties.color = color
	height = height + row:getHeight() + Helper.borderSize
	if (menu.subordinategroup or menu.intersectordefencegroup) and (#menu.selectedplayerships == 0) then
		row[1].properties.titleColor = nil
		local row = ftable:addRow(nil, {  })
		row[1]:setColSpan(5):createText(string.format(ReadText(1001, 8398), ReadText(20401, menu.subordinategroup or menu.intersectordefencegroup)), Helper.headerRowCenteredProperties)
		row[1].properties.color = color
	end

	-- kuertee start: distance tool
	if Helper.distanceTool_distance then
		local kuertee_dist = Helper.distanceTool_distance / 1000.0
		kuertee_dist = math.floor (kuertee_dist * 100 + 0.5) / 100
		row = ftable:addRow (false, {bgColor = Helper.color.transparent})
		local kuertee_text = ReadText (1001, 2957) .. ReadText (1001, 120) .. " " .. tostring (kuertee_dist) .. " " .. ReadText (1001, 108) -- Distance colon space X space km
		row [1]:setColSpan (5):createText (kuertee_text, {halign = "center"})
	end
	-- kuertee end

	-- kuertee start: multi-rename
	local hasPlayerOwnedSelectedOtherObjects
	if menu.selectedotherobjects and #menu.selectedotherobjects > 0 then
		for _, object in ipairs(menu.selectedotherobjects) do
			if IsValidComponent(object) then
				local isplayerowned = GetComponentData(ConvertStringTo64Bit(tostring(object)), "isplayerowned")
				if isplayerowned then
					hasPlayerOwnedSelectedOtherObjects = true
					break
				end
			end
		end
	end
	if #menu.selectedplayerships > 0 or hasPlayerOwnedSelectedOtherObjects or #menu.selectedplayerdeployables > 0 then
		height = height + menu.uix_multiRename_addButton(ftable)
	end
	-- kuertee end: multi-rename

	-- entries
	local convertedComponent = ConvertStringTo64Bit(tostring(menu.componentSlot.component))
	local isonlinetarget, isplayerownedtarget
	if convertedComponent ~= 0 then
		isonlinetarget, isplayerownedtarget = GetComponentData(convertedComponent, "isonlineobject", "isplayerowned")
	end

	local skipped = false
	if (not menu.syncpoint) and (not menu.syncpointorder) and (not menu.intersectordefencegroup) and (not menu.mission) and (not menu.missionoffer) then
		if (#menu.selectedplayerships == 0) and (#menu.selectedotherobjects > 0) then
			-- show the player that they cannot do anything with their selection
			menu.noopreason = {}
			for _, selectedcomponent in ipairs(menu.selectedotherobjects) do
				if C.IsRealComponentClass(selectedcomponent, "ship") then
					local selected64 = ConvertStringTo64Bit(tostring(selectedcomponent))
					if GetComponentData(selected64, "isplayerowned") then
						if IsComponentConstruction(selected64) then
							-- player ship in construction
							menu.noopreason[1] = ReadText(1001, 11106)
						end
					else
						-- npc ship
						menu.noopreason[2] = ReadText(1001, 7852)
					end
				else
					-- station case
					menu.noopreason[3] = ReadText(1001, 11104)
				end
			end
			local reason = ""
			if menu.noopreason[1] then
				reason = menu.noopreason[1]
			end
			if menu.noopreason[2] then
				if reason ~= "" then
					reason = reason .. "\n"
				end
				reason = reason .. menu.noopreason[2]
			elseif menu.noopreason[3] then
				if reason ~= "" then
					reason = reason .. "\n"
				end
				reason = reason .. menu.noopreason[3]
			end

			local row = ftable:addRow(true, { bgColor = Color["row_background_unselectable"] })
			row[1]:setColSpan(5):createText(reason, { wordwrap = true, color = Color["text_inactive"] })
			skipped = true
		elseif isonlinetarget and isplayerownedtarget then
			local row = ftable:addRow(true, { fixed = true, bgColor = Color["row_background_unselectable"] })
			row[1]:setColSpan(5):createText(ReadText(1001, 7868), { wordwrap = true, color = Color["text_inactive"] })
			skipped = true
		elseif (#menu.ventureships > 0) and (#menu.selectedplayerships == 0) then
			local row = ftable:addRow(true, { fixed = true, bgColor = Color["row_background_unselectable"] })
			row[1]:setColSpan(5):createText(ReadText(1001, 7868), { wordwrap = true, color = Color["text_inactive"] })
			skipped = true
		elseif (menu.numorderloops > 0) and (#menu.selectedplayerships ~= menu.numorderloops) then
			local row = ftable:addRow(true, { fixed = true, bgColor = Color["row_background_unselectable"] })
			row[1]:setColSpan(5):createText(ReadText(1001, 11108), { wordwrap = true, color = Color["text_inactive"] })
			skipped = true
		elseif (menu.numorderloops > 1) then
			local row = ftable:addRow(true, { fixed = true, bgColor = Color["row_background_unselectable"] })
			row[1]:setColSpan(5):createText(ReadText(1001, 11109), { wordwrap = true, color = Color["text_inactive"] })
			skipped = true
		end
	end

	-- kuertee start: forceShowMenus: show main, interaction, custom_actions menu when no actions to show
	local uix_forceShowSections_skipped_orig = skipped
	skipped = false
	-- kuertee end: forceShowMenus: show main, interaction, custom_actions menu when no actions to show

	if not skipped then
		local first = true

		for _, section in ipairs(config.sections) do
			-- kuertee start: callback
			local kUIX_isSectionValid = true
			if callbacks ["createContentTable_getIsSectionValid"] then
				for _, callback in ipairs (callbacks ["createContentTable_getIsSectionValid"]) do
					kUIX_isSectionValid = callback (section)
					if kUIX_isSectionValid ~= true then
						break
					end
				end
			end
			if kUIX_isSectionValid ~= true then
				goto createContentTable_skipSection
			end
			-- kuertee end: callback

			local pass = false
			if menu.showPlayerInteractions then
				if section.isplayerinteraction or (menu.shown and (not section.isorder)) then
					pass = true
				end
			elseif (section.isorder == nil) or (section.isorder == (#menu.selectedplayerships > 0)) then
				-- kuertee start: forceShowMenus: show main, interaction, custom_actions menu when no actions to show
				if not uix_forceShowSections_skipped_orig then
					pass = true
				end
				-- kuertee end: forceShowMenus: show main, interaction, custom_actions menu when no actions to show
			end

			-- kuertee start: forceShowMenus: show main, interaction, custom_actions menu when no actions to show
			if uix_forceShowSections_skipped_orig then
				if not pass then
					for _, uix_forceShowSection in ipairs(uix_forceShowSections) do
						if section.id == uix_forceShowSection then
							pass = true
							break
						end
					end
				end
			end
			-- kuertee end: forceShowMenus: show main, interaction, custom_actions menu when no actions to show

			-- kuertee start: don't show custom actions in position defense options
			if pass and section.id == "custom_actions" and menu.intersectordefencegroup then
				pass = false
			end
			-- kuertee end: don't show custom actions in position defense options

			if pass then
				if section.subsections then
					local hastitle = false
					for _, subsection in ipairs(section.subsections) do
						-- kuertee start: callback
						local kUIX_isSubsectionValid = true
						if callbacks ["createContentTable_getIsSubsectionValid"] then
							for _, callback in ipairs (callbacks ["createContentTable_getIsSubsectionValid"]) do
								kUIX_isSubsectionValid = callback (subsection)
								if kUIX_isSubsectionValid ~= true then
									break
								end
							end
						end
						if kUIX_isSubsectionValid ~= true then
							goto createContentTable_skipSubsection
						end
						-- kuertee end: callback

						if (#menu.actions[subsection.id] > 0) or menu.forceSubSection[subsection.id] then
							if not hastitle then
								height = height + menu.addSectionTitle(ftable, section, first)
								first = false
								hastitle = true
							end
							local data = { id = subsection.id, y = height }
							local row = ftable:addRow(data, {  })
							local iconHeight = Helper.scaleY(config.rowHeight)
							local button = row[1]:setColSpan(5):createButton({
								bgColor = #menu.actions[subsection.id] > 0 and Color["button_background_hidden"] or Color["button_background_inactive"],
								highlightColor = #menu.actions[subsection.id] > 0 and Color["button_highlight_default"] or Color["button_highlight_inactive"],
								mouseOverText = (#menu.actions[subsection.id] > 0) and "" or menu.forceSubSection[subsection.id],
								helpOverlayID = subsection.helpOverlayID,
								helpOverlayText = subsection.helpOverlayText,
								helpOverlayHighlightOnly = subsection.helpOverlayHighlightOnly,
							}):setText((subsection.orderid and menu.orderIconText(subsection.orderid) or "") .. subsection.text):setIcon("table_arrow_inv_right", { scaling = false, width = iconHeight, height = iconHeight, x = menu.width - iconHeight })
							row[1].handlers.onClick = function () return menu.handleSubSectionOption(data, true) end
							height = height + row:getHeight() + Helper.borderSize
						end

						-- kuertee start: callback
						:: createContentTable_skipSubsection ::
						-- kuertee end: callback
					end
				elseif #menu.actions[section.id] > 0 then
					height = height + menu.addSectionTitle(ftable, section, first)
					first = false
					local availabletextwidth
					if (section.id == "main") or (section.id == "selected_orders") or (section.id == "trade_orders") or (section.id == "selected_assignments") or (section.id == "player_interaction") or (section.id == "trade") then
						local maxtextwidth = 0
						for _, entry in ipairs(menu.actions[section.id]) do
							if not entry.hidetarget then
								maxtextwidth = math.max(maxtextwidth, C.GetTextWidth(entry.text .. " ", Helper.standardFont, Helper.scaleFont(Helper.standardFont, config.entryFontSize, true)))
							end
						end
						availabletextwidth = menu.width - maxtextwidth - 2 * Helper.scaleX(config.entryX) - Helper.borderSize
					end

					for _, entry in ipairs(menu.actions[section.id]) do

						-- kuertee start: callback
						local kUIX_isActionValid = true
						if callbacks ["createContentTable_getIsActionValid"] then
							for _, callback in ipairs (callbacks ["createContentTable_getIsActionValid"]) do
								kUIX_isActionValid = callback (entry)
								if kUIX_isActionValid ~= true then
									break
								end
							end
						end
						if kUIX_isActionValid ~= true then
							goto createContentTable_skipAction
						end
						-- kuertee end: callback

						if entry.active == nil then
							entry.active = true
						end
						local row = ftable:addRow(true, {  })
						if entry.checkbox ~= nil then
							row[1]:setColSpan(1):createCheckBox(entry.checkbox, { active = entry.active, mouseOverText = entry.mouseOverText })
							row[1].properties.uiTriggerID = entry.type
							row[2]:setColSpan(4):createText(entry.text, {
								color = entry.active and Color["text_normal"] or Color["text_inactive"],
								mouseOverText = entry.mouseOverText,
								helpOverlayID = entry.helpOverlayID,
								helpOverlayText = entry.helpOverlayText,
								helpOverlayHighlightOnly = entry.helpOverlayHighlightOnly,
							})
						else
							local button = row[1]:setColSpan(5):createButton({
								bgColor = entry.active and Color["button_background_hidden"] or Color["button_background_inactive"],
								highlightColor = entry.active and Color["button_highlight_default"] or Color["button_highlight_inactive"],
								mouseOverText = entry.mouseOverText,
								helpOverlayID = entry.helpOverlayID,
								helpOverlayText = entry.helpOverlayText,
								helpOverlayHighlightOnly = entry.helpOverlayHighlightOnly,
							}):setText(entry.text, { color = entry.active and Color["text_normal"] or Color["text_inactive"] })
							button.properties.uiTriggerID = entry.type
							if (section.id == "selected_orders") or (section.id == "trade_orders") or (section.id == "selected_assignments") or (section.id == "player_interaction") or (section.id == "trade") then
								if not entry.hidetarget then
									local text2 = ""
									if entry.text2 then
										text2 = entry.text2
									else
										if ((section.id == "trade_orders") or (section.id == "trade") or (section.id == "player_interaction")) and entry.buildstorage then
											text2 = menu.texts.buildstorageName
										else
											text2 = menu.texts.targetBaseName or menu.texts.targetShortName
										end
									end
									text2 = TruncateText(text2, button.properties.text.font, Helper.scaleFont(button.properties.text.font, button.properties.text.fontsize, button.properties.scaling), availabletextwidth)
									button:setText2(text2, { halign = "right", color = menu.colors.target })
									if (entry.mouseOverText == nil) or (entry.mouseOverText == "") then
										button.properties.mouseOverText = entry.text .. " " .. (entry.buildstorage and menu.texts.buildstorageFullName or menu.texts.targetName)
									end
								end
							elseif (section.id == "main") then
								if entry.text2 then
									local text2 = entry.text2
									text2 = TruncateText(text2, button.properties.text.font, Helper.scaleFont(button.properties.text.font, button.properties.text.fontsize, button.properties.scaling), availabletextwidth)
									button:setText2(text2, { halign = "right", color = menu.colors.target })
								end
							end
						end
						if entry.active then
							row[1].handlers.onClick = entry.script
						end
						height = height + row:getHeight() + Helper.borderSize

						-- kuertee start: callback
						:: createContentTable_skipAction ::
						-- kuertee end: callback
					end
				end
			end


			-- kuertee start: callback
			:: createContentTable_skipSection ::
			-- kuertee end: callback
		end
		if first then
			local row = ftable:addRow(true, {  })
			local button = row[1]:setColSpan(5):createButton({ active = false, bgColor = Color["button_background_inactive"] }):setText("---", { halign = "center", color = Color["text_error"] })
		end
	end

	ftable:setSelectedRow(menu.selectedRows.contentTable)
	ftable:setTopRow(menu.topRows.contentTable)
	menu.selectedRows.contentTable = nil
	menu.topRows.contentTable = nil

	return ftable
end

-- kuertee start: multi-rename
local uix_multiRename_objects
function menu.uix_multiRename_addButton(ftable)
	uix_multiRename_objects = menu.uix_multiRename_getObjects()
	local height = 0
	if #uix_multiRename_objects > 1 then
		local row = ftable:addRow(true, {  })
		local button = row[1]:setColSpan(5):createButton({
			active = true,
			bgColor = Color["button_background_inactive"],
			highlightColor = Color["button_highlight_default"],
		}):setText((ReadText(1001, 1114)))
		local text2 = string.format(ReadText(1001, 11105), #uix_multiRename_objects)
		button:setText2(text2, { halign = "right", color = menu.colors.target })
		row[1].handlers.onClick = function () return menu.buttonRename(nil, true) end
		height = height + row:getHeight() + Helper.borderSize
	end
	return height
end
-- kuertee end: multi-rename

function menu.createSubSectionTable(frame, position)
	local x = 0
	if position == "right" then
		x = menu.width + Helper.borderSize
	end

	local ftable = frame:addTable(2, { tabOrder = 1, x = x, width = menu.width, backgroundID = "solid", backgroundColor = Color["frame_background_semitransparent"], highlightMode = "off" })
	ftable:setDefaultCellProperties("text",   { minRowHeight = config.rowHeight, fontsize = config.entryFontSize, x = config.entryX })
	ftable:setDefaultCellProperties("button", { height = config.rowHeight })
	ftable:setDefaultComplexCellProperties("button", "text", { fontsize = config.entryFontSize, x = config.entryX })
	ftable:setDefaultComplexCellProperties("button", "text2", { fontsize = config.entryFontSize, x = config.entryX })
	ftable:setColWidthPercent(2, 40)
	ftable:setDefaultBackgroundColSpan(1, 2)

	for _, entry in ipairs(menu.actions[menu.subsection.id]) do
		if entry.active == nil then
			entry.active = true
		end
		row = ftable:addRow(true, {  })
		local maxtextwidth = 0
		if entry.text2 then
			maxtextwidth = C.GetTextWidth(entry.text2 .. " ", entry.text2font or Helper.standardFont, Helper.scaleFont(Helper.standardFont, config.entryFontSize, true))
		end
		local availabletextwidth = menu.width - maxtextwidth - 2 * Helper.scaleX(config.entryX) - Helper.borderSize

		local button = row[1]:setColSpan(2):createButton({
			active = entry.active,
			bgColor = entry.active and Color["button_background_hidden"] or Color["button_background_inactive"],
			helpOverlayID = entry.helpOverlayID,
			helpOverlayText = entry.helpOverlayText,
			helpOverlayHighlightOnly = entry.helpOverlayHighlightOnly,
		})
		button.properties.uiTriggerID = entry.type
		local text = TruncateText(entry.text, button.properties.text.font, Helper.scaleFont(button.properties.text.font, button.properties.text.fontsize, button.properties.scaling), availabletextwidth)
		if entry.mouseOverText then
			button.properties.mouseOverText = entry.mouseOverText
		elseif text ~= entry.text then
			button.properties.mouseOverText = entry.text
		end
		button:setText(text, { color = entry.active and Color["text_normal"] or Color["text_inactive"] })
		row[1].handlers.onClick = entry.script
		if entry.text2 then
			button:setText2(entry.text2, { halign = "right", color = entry.active and Color["text_normal"] or Color["text_inactive"], font = entry.text2font or Helper.standardFont })
		end
	end

	return ftable
end

-- helpers

function menu.getPlayerSquad()
	local playerSquad = {}

	local playerOccupiedShip = C.GetPlayerOccupiedShipID()
	if (playerOccupiedShip ~= 0) then
		local locplayersubordinates = GetSubordinates(ConvertStringTo64Bit(tostring(playerOccupiedShip)), nil, true)
		for _, subordinate in ipairs(locplayersubordinates) do
			playerSquad[ConvertIDTo64Bit(subordinate)] = true
			--print("inserting: " .. ConvertIDTo64Bit(subordinate))
		end
	end

	return playerSquad
end

function menu.getSubordinatesInGroups(commander, isstation)
	local groups = {}
	for group = 1, isstation and 5 or 10 do
		local locassignment = ffi.string(C.GetSubordinateGroupAssignment(commander, group))
		if locassignment ~= "" then
			--groups[group] = { assignment = locassignment, subordinates = {} }

			local numsubordinates = C.GetNumSubordinatesOfGroup(commander, group)
			if numsubordinates > 0 then
				local subordinates = ffi.new("UniverseID[?]", numsubordinates)
				numsubordinates = C.GetSubordinatesOfGroup(subordinates, numsubordinates, commander, group)
				if numsubordinates > 0 then
					groups[group] = { assignment = locassignment, subordinates = {} }
					for i = 0, numsubordinates - 1 do
						--print(tostring(ConvertStringToLuaID(tostring(subordinates[i]))))
						local component = ConvertStringToLuaID(tostring(subordinates[i]))
						table.insert(groups[group].subordinates, { component = component, name = GetComponentData(component, "name"), objectid = ffi.string(C.GetObjectIDCode(subordinates[i])) })
					end
					table.sort(groups[group].subordinates, Helper.sortNameAndObjectID)
				end
			end
		end
	end
	return groups
end

function menu.setOrderImmediate(component, orderidx)
	local newidx = 1
	if not C.AdjustOrder(component, orderidx, newidx, true, false, true) then
		newidx = 2
	end
	C.AdjustOrder(component, orderidx, newidx, true, false, false)
end

function menu.handleSubSectionOption(data, skipdelay)
	if type(data) == "table" then
		if ((not menu.pendingSubSection) and ((not menu.subsection) or (menu.subsection.id ~= data.id))) or (menu.pendingSubSection and ((type(menu.pendingSubSection) ~= "table") or (menu.pendingSubSection.id ~= data.id))) then
			if #menu.actions[data.id] > 0 then
				if skipdelay then
					menu.subsection = data
				else
					if (not menu.subsection) or (menu.subsection.id ~= data.id) then
						menu.pendingSubSection = data
					else
						menu.pendingSubSection = nil
					end
				end
			else
				if skipdelay then
					menu.subsection = nil
				else
					menu.pendingSubSection = -1
				end
			end
			if skipdelay then
				menu.pendingSubSection = nil
				menu.refresh = true
			else
				menu.lastSubSectionTime = getElapsedTime()
			end
		end
	else
		if type(menu.subsection) == "table" then
			if skipdelay then
				menu.subsection = nil
				menu.pendingSubSection = nil
				menu.refresh = true
			else
				menu.pendingSubSection = -1
				menu.lastSubSectionTime = getElapsedTime()
			end
		end
	end
end

function menu.processSelectedPlayerShips()
	local convertedComponent = ConvertStringTo64Bit(tostring(menu.componentSlot.component))
	local isplayerownedtarget, istargetatdockrelation, istargetdockingenabled = false, false, false
	if convertedComponent ~= 0 then
		isplayerownedtarget, istargetatdockrelation, istargetdockingenabled = GetComponentData(convertedComponent, "isplayerowned", "isdock", "isdockingenabled")
	end
	local playercontainer = C.GetPlayerContainerID()
	local convertedPlayerContainer
	if playercontainer ~= 0 then
		convertedPlayerContainer = ConvertStringTo64Bit(tostring(playercontainer))
	end
	local occupiedPlayerShip = ConvertStringTo64Bit(tostring(C.GetPlayerOccupiedShipID()))

	menu.possibleorders = {
		["Attack"] = false,
		["AttackInRange"] = false,
		["Board"] = false,
		["Collect"] = false,
		["CollectDeployables"] = false,
		["CollectDropsInRadius"] = false,
		["CollectLockbox"] = false,
		["DeployObjectAtPosition"] = false,
		["DockAndWait"] = false,
		["Explore"] = false,
		["ExploreUpdate"] = false,
		["Flee"] = false,
		["Follow"] = false,
		["MiningPlayer"] = false,
		["MoveWait"] = false,
		["Player_DockToTrade"] = false,
		["ProtectStation"] = false,
		["Repair"] = false,
		["RescueInRange"] = false,
		["RescueShip"] = false,
		["SalvageCrush"] = false,
		["SalvageCollect"] = false,
		["SalvageDeliver"] = false,
		["SalvageDeliver_NoTrade"] = false,
		["SalvageInRadius"] = false,
		["TacticalOrder"] = false,
	}
	menu.orderdefs = {}
	menu.loopableorders = {}
	local n = C.GetNumOrderDefinitions()
	local buf = ffi.new("OrderDefinition[?]", n)
	n = C.GetOrderDefinitions(buf, n)
	for i = 0, n - 1 do
		local id = ffi.string(buf[i].id)
		menu.orderdefs[id] = { icon = ffi.string(buf[i].icon), description = ffi.string(buf[i].description) }
		menu.loopableorders[id] = C.IsOrderLoopable(id)
	end

	menu.numdockingpossible = 0
	menu.numassignableships = 0
	menu.numassignableminingships = 0
	menu.numassignableresupplyships = 0
	menu.numassignabletugs = 0
	menu.numremovableorders = 0
	menu.numremovabledefaultorders = 0
	menu.numwaitingforsignal = 0
	menu.numdockingatplayerpossible = 0
	menu.numshipswithcommander = 0
	menu.numhaveturret = 0
	menu.numshipsexcludingspacesuits = 0
	menu.ventureships = {}
	menu.numorderloops = 0
	menu.dockingerrors = {}
	menu.shipswithcurrentcommander = {}

	for i = #menu.selectedplayerships, 1, -1 do
		local ship = menu.selectedplayerships[i]

		local isdocked, isdocking, hasturret, isonlineobject = GetComponentData(ship, "isdocked", "isdocking", "hasturret", "isonlineobject")
		if (not C.IsUnit(ship)) and (not isonlineobject) then
			local commander = ConvertIDTo64Bit(GetCommander(ship))
			-- check commander
			if commander then
				menu.numshipswithcommander = menu.numshipswithcommander + 1
				if commander == convertedComponent then
					table.insert(menu.shipswithcurrentcommander, ship)
				end
			end
			-- check turrets
			if hasturret then
				menu.numhaveturret = menu.numhaveturret + 1
			end
			-- check order removal
			local numorders = C.GetNumOrders(ship)
			local currentorders = ffi.new("Order[?]", numorders)
			numorders = C.GetOrders(currentorders, numorders, ship)
			for i = numorders, 1, -1 do
				if (i == 1) and ((ffi.string(currentorders[0].orderdef) == "DockAndWait") and (isdocked or isdocking)) then
					-- do nothing - removing the dock order would create an undock order ... rather have the ship stay put [Nick]
				else
					if C.RemoveOrder(ship, i, false, true) then
						menu.numremovableorders = menu.numremovableorders + 1
						break
					end
					local currentdefaultorder = ffi.new("Order")
					if C.GetDefaultOrder(currentdefaultorder, ship) then
						if (ffi.string(currentdefaultorder.orderdef) ~= "Wait") and (ffi.string(currentdefaultorder.orderdef) ~= "DockAndWait") then
							menu.numremovabledefaultorders = menu.numremovabledefaultorders + 1
							break
						end
					end
					if commander and (commander ~= 0) and (commander ~= occupiedPlayerShip) then
						menu.numremovabledefaultorders = menu.numremovabledefaultorders + 1
						break
					end
				end
			end
		end

		if ship == menu.componentSlot.component then
			table.remove(menu.selectedplayerships, i)

			-- kuertee start: multi-rename
			menu.uix_multiRename_removedActionTarget = ship
			-- kuertee end: multi-rename

		elseif C.IsUnit(ship) then
			table.remove(menu.selectedplayerships, i)
		elseif isonlineobject then
			table.insert(menu.ventureships, ship)
			table.remove(menu.selectedplayerships, i)
		else
			-- Check orders
			for orderid, value in pairs(menu.possibleorders) do
				if not value then
					if C.IsOrderSelectableFor(orderid, ship) then
						menu.possibleorders[orderid] = true
					end
				end
			end

			local hasloop = ffi.new("bool[1]", 0)
			C.GetOrderQueueFirstLoopIdx(ship, hasloop)
			if hasloop[0] then
				menu.numorderloops = menu.numorderloops + 1
			end

			-- Check space suit
			local isspacesuit = C.IsComponentClass(ship, "spacesuit")
			if not isspacesuit then
				menu.numshipsexcludingspacesuits = menu.numshipsexcludingspacesuits + 1
			end

			-- Check assignments
			if isplayerownedtarget and C.IsComponentClass(menu.componentSlot.component, "controllable") and GetComponentData(ship, "assignedpilot") and (not isspacesuit) then
				if commander ~= convertedComponent and C.CanAcceptSubordinate(menu.componentSlot.component, ship) then
					menu.numassignableships = menu.numassignableships + 1
					if GetComponentData(ship, "primarypurpose") == "mine" then
						menu.numassignableminingships = menu.numassignableminingships + 1
					elseif GetComponentData(ship, "shiptype") == "resupplier" then
						menu.numassignableresupplyships = menu.numassignableresupplyships + 1
					elseif GetComponentData(ship, "shiptype") == "tug" then
						menu.numassignabletugs = menu.numassignabletugs + 1
					end
				end
			end

			-- Check docking
			if (convertedComponent ~= 0) and C.IsComponentClass(menu.componentSlot.component, "container") then
				if IsDockingPossible(ship, convertedComponent) then
					menu.numdockingpossible = menu.numdockingpossible + 1
				elseif not istargetatdockrelation then
					menu.dockingerrors[1] = ReadText(1026, 7825)
				elseif not istargetdockingenabled then
					menu.dockingerrors[2] = ReadText(1026, 7843)
				else
					menu.dockingerrors[3] = ReadText(1026, 7824)
				end
			end
			if (playercontainer ~= 0) and IsDockingPossible(ship, convertedPlayerContainer) and (GetComponentData(ship, "assignedpilot") ~= nil) then
				menu.numdockingatplayerpossible = menu.numdockingatplayerpossible + 1
			end

			-- check for waiting for signal
			local numorders = C.GetNumOrders(ship)
			if numorders > 0 then
				local orderparams = GetOrderParams(ship, 1)
				local iswaitingforsignal = false
				for i, param in ipairs(orderparams) do
					if param.name == "releasesignal" and type(param.value) == "table" and param.value[1] == "playerownedship_proceed" then
						menu.numwaitingforsignal = menu.numwaitingforsignal + 1
						break
					end
				end
			end
		end
	end
	menu.hasPlayerShipPilot = false
	if (#menu.selectedplayerships == 1) and (menu.selectedplayerships[1] == occupiedPlayerShip) then
		menu.showPlayerInteractions = true
	else
		for i, ship in ipairs(menu.selectedplayerships) do
			if ship == occupiedPlayerShip then
				menu.removedOccupiedPlayerShip = occupiedPlayerShip
				table.remove(menu.selectedplayerships, i)
			end
			if GetComponentData(ship, "assignedpilot") then
				menu.hasPlayerShipPilot = true
			end
		end
	end

	if isplayerownedtarget and C.IsComponentClass(menu.componentSlot.component, "ship") then
		if (playercontainer ~= 0) and (convertedComponent ~= 0) and IsDockingPossible(convertedComponent, convertedPlayerContainer) and (GetComponentData(convertedComponent, "assignedpilot") ~= nil) then
			menu.numdockingatplayerpossible = menu.numdockingatplayerpossible + 1
		end
	end

	for i = #menu.selectedotherobjects, 1, -1 do
		local ship = menu.selectedotherobjects[i]
		if ship == menu.componentSlot.component then
			table.remove(menu.selectedotherobjects, i)

			-- kuertee start: multi-rename
			menu.uix_multiRename_removedActionTarget = ship
			-- kuertee end: multi-rename

			break
		end
	end
end

function menu.prepareSections()
	menu.actions = {}
	for _, section in ipairs(config.sections) do
		if section.subsections then

			-- kuertee start: add section initializer
			menu.actions[section.id] = {}
			-- kuertee end: add section initializer

			for _, subsection in ipairs(section.subsections) do
				menu.actions[subsection.id] = {}
			end
		else
			menu.actions[section.id] = {}
		end
	end
end

function menu.insertInteractionContent(section, entry)
	if menu.actions[section] then

		if entry.orderid then
			if menu.numorderloops > 0 then
				if not menu.loopableorders[entry.orderid] then
					entry.active = false
					entry.mouseOverText = ReadText(1026, 7851)
				end
			end
			if entry.active ~= false then
				if not menu.hasPlayerShipPilot then
					entry.active = false
					entry.mouseOverText = ReadText(1026, 7830)
				end
			end

			entry.mouseOverText = menu.orderdefs[entry.orderid].description .. (((entry.mouseOverText ~= nil) and (entry.mouseOverText ~= "")) and ("\n\n" .. entry.mouseOverText) or "")
		end

		table.insert(menu.actions[section], entry)
	else
		DebugError("The requested context section is not defined: '" .. section .. "' [Florian]")
	end
end

config.consumables = {
	{ id = "satellite",		type = "civilian",	getnum = C.GetNumAllSatellites,		getdata = C.GetAllSatellites },
	{ id = "navbeacon",		type = "civilian",	getnum = C.GetNumAllNavBeacons,		getdata = C.GetAllNavBeacons },
	{ id = "resourceprobe",	type = "civilian",	getnum = C.GetNumAllResourceProbes,	getdata = C.GetAllResourceProbes },
	{ id = "lasertower",	type = "military",	getnum = C.GetNumAllLaserTowers,	getdata = C.GetAllLaserTowers },
	{ id = "mine",			type = "military",	getnum = C.GetNumAllMines,			getdata = C.GetAllMines },
}

function menu.addConsumableEntry(basesection, consumabledata, object, callback)
	local numconsumable = consumabledata.getnum(object)
	if numconsumable > 0 then
		local consumables = ffi.new("AmmoData[?]", numconsumable)
		numconsumable = consumabledata.getdata(consumables, numconsumable, object)
		for j = 0, numconsumable - 1 do
			if consumables[j].amount > 0 then
				local macro = ffi.string(consumables[j].macro)
				menu.insertInteractionContent(basesection .. "_" .. consumabledata.type, { type = consumabledata.type, text = GetMacroData(macro, "name"), text2 = "(" .. consumables[j].amount .. ")", script = function () return callback(consumabledata.id, macro, 1) end })
			end
		end
	end
end

function menu.insertAssignSubActions(section, assignment, callback, groups, isstation, unique, currentgroup, mouseovertextadd)
	local groupexists = false
	if unique then
		for i = 1, isstation and 5 or 10 do
			if groups[i] and (groups[i].assignment == assignment) then
				-- found a matching group
				groupexists = true
				break
			end
		end
	end
	for i = 1, isstation and 5 or 10 do
		if groups[i] then
			local active = (groups[i].assignment == assignment) or ((i == menu.subordinategroup) and ((not unique) or (not groupexists)))
			local mouseovertext = ""
			if active then
				for i, subordinateentry in ipairs(groups[i].subordinates) do
					mouseovertext = mouseovertext .. ((i > 1) and "\n" or "") .. Helper.convertColorToText(menu.holomapcolor.playercolor) .. subordinateentry.name .. " (" .. subordinateentry.objectid .. ")"
				end
				if mouseovertextadd and (mouseovertextadd ~= "") then
					mouseovertext = mouseovertextadd .. ((mouseovertext ~= "") and "\n\n" or "") .. mouseovertext
				end
			else
				mouseovertext = ReadText(1026, 7839) .. "\n" .. (config.assignments[groups[i].assignment] and config.assignments[groups[i].assignment].name or "")
			end

			local currenttext = ""
			if i == currentgroup then
				currenttext = " [" .. ReadText(1001, 7899) .. "]"
			end

			menu.insertInteractionContent(section, { type = "assign", text = ReadText(20401, i) .. currenttext, text2 = ((#groups[i].subordinates > 0) and Helper.convertColorToText(menu.holomapcolor.playercolor) or "") .. ((#groups[i].subordinates > 1) and string.format(ReadText(1001, 7898), #groups[i].subordinates) or (#groups[i].subordinates == 1) and ReadText(1001, 7897) or ReadText(1001, 7896)), script = function () callback(assignment, i) end, active = active, mouseOverText = mouseovertext })
		else
			local active = ((not unique) or (not groupexists)) and (assignment ~= "positiondefence")
			local mouseovertext = ""
			if not active then
				if assignment == "positiondefence" then
					mouseovertext = ReadText(1026, 7863)
				else
					mouseovertext = ReadText(1026, 7840)
				end
			end
			if active then
				if mouseovertextadd and (mouseovertextadd ~= "") then
					mouseovertext = mouseovertextadd .. ((mouseovertext ~= "") and "\n\n" or "") .. mouseovertext
				end
			end
			menu.insertInteractionContent(section, { type = "assign", text = ReadText(20401, i), text2 = ReadText(1001, 7896), script = function () callback(assignment, i) end, active = active, mouseOverText = mouseovertext })
		end
	end
end

function menu.insertLuaAction(actiontype, istobedisplayed)
	local convertedComponent = menu.data.convertedComponent
	local isplayerownedtarget = menu.data.isplayerownedtarget
	local istargetinplayersquad = menu.data.istargetinplayersquad
	local istargetplayeroccupiedship = menu.data.istargetplayeroccupiedship
	local hastargetpilot = menu.data.hastargetpilot

	if actiontype == "armturrets" then
		if istobedisplayed and (menu.numhaveturret > 0) then
			local allarmed = true
			local hasturret = GetComponentData(convertedComponent, "hasturret")
			if hasturret then
				allarmed = menu.areTurretsArmed(menu.componentSlot.component)
			end
			if allarmed then
				for _, ship in ipairs(menu.selectedplayerships) do
					local hasturret = GetComponentData(ship, "hasturret")
					if hasturret and (not menu.areTurretsArmed(ship)) then
						allarmed = false
						break
					end
				end
			end

			menu.insertInteractionContent(((not menu.showPlayerInteractions) and (#menu.selectedplayerships > 0)) and "selected_orders_all" or "interaction", { type = actiontype, text = allarmed and ReadText(1001, 11102) or ReadText(1001, 11101), script = function () return menu.buttonArmTurrets(not allarmed) end })
		end
	elseif actiontype == "assign" then
		if (menu.showPlayerInteractions or ((#menu.selectedplayerships == 0) and (not menu.shown))) and C.IsComponentClass(menu.componentSlot.component, "controllable") then
			local isplayerowned = GetComponentData(convertedComponent, "isplayerowned")
			local commander = ConvertIDTo64Bit(GetCommander(convertedComponent))
			if isplayerowned and (not commander) or (commander == 0) then
				local occupiedplayership = ConvertStringTo64Bit(tostring(C.GetPlayerOccupiedShipID()))
				if occupiedplayership and (occupiedplayership ~= 0) and (occupiedplayership ~= menu.componentSlot.component) and C.CanAcceptSubordinate(occupiedplayership, menu.componentSlot.component) then
					local subordinates = GetSubordinates(occupiedplayership)
					local groups = menu.getSubordinatesInGroups(occupiedplayership, false)

					-- defence
					menu.insertAssignSubActions("main_assignments_defence", "defence", menu.buttonAssignCommander, groups, false, false)
					-- position defence
					local commandershiptype = GetComponentData(occupiedplayership, "shiptype")
					local parentcommander = ConvertIDTo64Bit(GetCommander(occupiedplayership))
					local isfleetcommander = (not parentcommander) and (#subordinates > 0)
					if (commandershiptype == "carrier") and isfleetcommander then
						menu.insertAssignSubActions("main_assignments_positiondefence", "positiondefence", menu.buttonAssignCommander, groups, false, false)
					end
					-- supplyfleet
					if GetComponentData(convertedComponent, "shiptype") == "resupplier" then
						menu.insertAssignSubActions("main_assignments_supplyfleet", "supplyfleet", menu.buttonAssignCommander, groups, false, true)
					end
					menu.insertAssignSubActions("main_assignments_attack", "attack", menu.buttonAssignCommander, groups, false)
					menu.insertAssignSubActions("main_assignments_interception", "interception", menu.buttonAssignCommander, groups, false)
					menu.insertAssignSubActions("main_assignments_bombardment", "bombardment", menu.buttonAssignCommander, groups, false)
					menu.insertAssignSubActions("main_assignments_follow", "follow", menu.buttonAssignCommander, groups, false, true)
					local buf = ffi.new("Order")
					if C.GetDefaultOrder(buf, occupiedplayership) then
						menu.insertAssignSubActions("main_assignments_assist", "assist", menu.buttonAssignCommander, groups, false, true)
					end
				end
			end
		elseif menu.numassignableships > 0 then
			local subordinates = GetSubordinates(convertedComponent)

			local isstation = C.IsComponentClass(menu.componentSlot.component, "station")
			local isship = C.IsComponentClass(menu.componentSlot.component, "ship")
			local groups = menu.getSubordinatesInGroups(menu.componentSlot.component, isstation)
			-- defence
			menu.insertAssignSubActions("selected_assignments_defence", "defence", menu.buttonAssignCommander, groups, isstation, isstation)
			-- supplyfleet
			if menu.numassignableresupplyships > 0 then
				menu.insertAssignSubActions("selected_assignments_supplyfleet", "supplyfleet", menu.buttonAssignCommander, groups, isstation, true)
			end
			if isstation then
				-- trading
				menu.insertAssignSubActions("selected_assignments_trade", "trade", menu.buttonAssignCommander, groups, isstation, true, nil, (menu.numassignableminingships > 0) and (ColorText["text_warning"] .. ReadText(1026, 8609)) or "")
				-- mining
				if menu.numassignableminingships > 0 then
					menu.insertAssignSubActions("selected_assignments_mining", "mining", menu.buttonAssignCommander, groups, isstation, true)
				end
				-- trading for buildstorage
				local numnonminingships = menu.numassignableships - menu.numassignableminingships
				if numnonminingships > 0 then
					menu.insertAssignSubActions("selected_assignments_tradeforbuildstorage", "tradeforbuildstorage", menu.buttonAssignCommander, groups, isstation, true)
				end
				if menu.numassignabletugs > 0 then
					menu.insertAssignSubActions("selected_assignments_salvage", "salvage", menu.buttonAssignCommander, groups, isstation, true)
				end
			elseif isship then
				-- position defence
				local shiptype = GetComponentData(convertedComponent, "shiptype")
				local commander = ConvertIDTo64Bit(GetCommander(convertedComponent))
				local isfleetcommander = (not commander) and (#subordinates > 0)
				if (shiptype == "carrier") and isfleetcommander then
					menu.insertAssignSubActions("selected_assignments_positiondefence", "positiondefence", menu.buttonAssignCommander, groups, isstation)
				end
				menu.insertAssignSubActions("selected_assignments_attack", "attack", menu.buttonAssignCommander, groups, isstation)
				menu.insertAssignSubActions("selected_assignments_interception", "interception", menu.buttonAssignCommander, groups, isstation)
				menu.insertAssignSubActions("selected_assignments_bombardment", "bombardment", menu.buttonAssignCommander, groups, isstation)
				menu.insertAssignSubActions("selected_assignments_follow", "follow", menu.buttonAssignCommander, groups, isstation, true)
				local buf = ffi.new("Order")
				if C.GetDefaultOrder(buf, menu.componentSlot.component) then
					menu.insertAssignSubActions("selected_assignments_assist", "assist", menu.buttonAssignCommander, groups, isstation, true)
				end

				-- start: aegs call-back
				if callbacks ["map_rightMenu_shipassignments_insert_01"] then
					local state,main_o,assignment_o
					for _, callback in ipairs (callbacks ["map_rightMenu_shipassignments_insert_01"]) do
						state,main_o,assignment_o = callback (GetComponentData(convertedComponent, "macro"),menu.numassignableminingships,menu.numassignabletugs)
						if state then
							menu.insertAssignSubActions(main_o, assignment_o, menu.buttonAssignCommander, groups, isstation, true)
						end
					end
				end
				-- end: aegs call-back

				if shiptype == "resupplier" then
					menu.insertAssignSubActions("selected_assignments_trade", "trade", menu.buttonAssignCommander, groups, isstation, true)
				end
			end
		end
	elseif actiontype == "attack" then
		if (#menu.selectedplayerships > 0) and menu.possibleorders["Attack"] and (not isplayerownedtarget) and C.IsComponentClass(menu.componentSlot.component, "destructible") then
			menu.insertInteractionContent("selected_orders", { type = actiontype, text = menu.orderIconText("Attack") .. ReadText(1001, 7815), helpOverlayID = "interactmenu_attack", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonAttack(false) end, orderid = "Attack" })
		end

		-- start: aegs call-back
		if callbacks ["map_rightMenu_shipOverview_insert"] then
			local category_o,text_o
			for _, callback in ipairs (callbacks ["map_rightMenu_shipOverview_insert"]) do
				category_o,text_o = callback (GetComponentData(convertedComponent, "macro"))
				if category_o then
					menu.insertInteractionContent("main", { type = "logicalstationoverview", text = text_o, helpOverlayID = "interactmenu_logicalstationoverview", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = menu.buttonStationOverview })
				end
			end
		end
		-- end: aegs call-back
	elseif actiontype == "attackinrange" then
		if menu.offsetcomponent and (menu.offsetcomponent ~= 0) then
			if #menu.selectedplayerships > 0 and menu.possibleorders["AttackInRange"] then
				menu.insertInteractionContent("selected_orders", { type = actiontype, text = menu.orderIconText("AttackInRange") .. ReadText(1041, 631), helpOverlayID = "interactmenu_attackinrange", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonAttackInRange(false) end, hidetarget = true, orderid = "AttackInRange" } )
			end
		end
	elseif actiontype == "attackmultiple" then
		if (#menu.selectedplayerships > 0) and menu.possibleorders["Attack"] and (not isplayerownedtarget) and C.IsComponentClass(menu.componentSlot.component, "destructible") then
			menu.insertInteractionContent("selected_orders", { type = actiontype, text = menu.orderIconText("Attack") .. ReadText(1001, 7816), helpOverlayID = "interactmenu_attackmultiple", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonAttackMultiple(false) end, hidetarget = true, orderid = "Attack" })
		end
	elseif actiontype == "attackplayertarget" then
		if (istargetinplayersquad or istargetplayeroccupiedship) and GetPlayerTarget() then
			--print("player target: " .. tostring(GetPlayerTarget()))
			menu.insertInteractionContent("playersquad_orders", { type = actiontype, text = ReadText(1001, 7869), helpOverlayID = "interactmenu_attackplayertarget", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonPlayerSquadAttackPlayerTarget(false) end, hidetarget = true })	-- Fleet: Attack my target
		end
	elseif actiontype == "disable" then
		if (#menu.selectedplayerships > 0) and menu.possibleorders["Attack"] and (not isplayerownedtarget) and C.IsComponentClass(menu.componentSlot.component, "defensible") and (C.IsComponentClass(menu.componentSlot.component, "ship_l") or C.IsComponentClass(menu.componentSlot.component, "ship_xl") or C.IsComponentClass(menu.componentSlot.component, "station")) then
			menu.insertInteractionContent("selected_disable_attack", { type = "disable", text = ReadText(1001, 11129), script = function() menu.buttonAttackSurfaceElements(menu.componentSlot.component, "all", false) end, active = true, orderid = "Attack" })
			menu.insertInteractionContent("selected_disable_attack", { type = "disable", text = ReadText(1001, 11132), script = function() menu.buttonAttackSurfaceElements(menu.componentSlot.component, "turret", false) end, active = true, orderid = "Attack" })
			menu.insertInteractionContent("selected_disable_attack", { type = "disable", text = ReadText(1001, 11131), script = function() menu.buttonAttackSurfaceElements(menu.componentSlot.component, "shieldgenerator", false) end, active = true, orderid = "Attack" })
			if C.IsComponentClass(menu.componentSlot.component, "ship") then
				menu.insertInteractionContent("selected_disable_attack", { type = "disable", text = ReadText(1001, 11130), script = function() menu.buttonAttackSurfaceElements(menu.componentSlot.component, "engine", false) end, active = true, orderid = "Attack" })
			end
		end
	elseif actiontype == "board" then
		if (#menu.selectedplayerships > 0) and menu.possibleorders["Board"] and (not isplayerownedtarget) and (C.IsComponentClass(menu.componentSlot.component, "ship_l") or C.IsComponentClass(menu.componentSlot.component, "ship_xl")) and (GetComponentData(convertedComponent, "owner") ~= "ownerless") then
			menu.insertInteractionContent(menu.showPlayerInteractions and "player_interaction" or "selected_orders", { type = actiontype, text = menu.orderIconText("Board") .. ReadText(1001, 7842), helpOverlayID = "interactmenu_board", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function() return menu.buttonBoard() end, orderid = (not menu.showPlayerInteractions) and "Board" or nil })
		end
	elseif actiontype == "build" then
		if (#menu.selectedplayerships == 1) and isplayerownedtarget and (GetComponentData(menu.selectedplayerships[1], "primarypurpose") == "build") and (menu.numorderloops == 0) then
			local buildstorage
			if C.IsRealComponentClass(menu.componentSlot.component, "station") then
				buildstorage = ConvertIDTo64Bit(GetComponentData(convertedComponent, "buildstorage")) or 0
			else
				buildstorage = convertedComponent
			end
			local constructionvessels = {}
			Helper.ffiVLA(constructionvessels, "UniverseID", C.GetNumAssignedConstructionVessels, C.GetAssignedConstructionVessels, buildstorage)
			local mouseovertext
			if #constructionvessels > 0 then
				mouseovertext = ReadText(1026, 7821)
			elseif C.IsBuilderBusy(menu.selectedplayerships[1]) then
				mouseovertext = ReadText(1026, 7820)
			elseif not menu.hasPlayerShipPilot then
				mouseovertext = ReadText(1026, 7830)
			end
			menu.insertInteractionContent("selected_orders", { type = actiontype, text = ReadText(1001, 7833), helpOverlayID = "interactmenu_build", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonDeployToStation(menu.selectedplayerships[1], true) end, active = (#constructionvessels == 0) and (not C.IsBuilderBusy(menu.selectedplayerships[1])) and menu.hasPlayerShipPilot, mouseOverText = mouseovertext })
		end
	elseif actiontype == "buildships" then
		local canbuildships, shiptrader, isdock, owner = GetComponentData(convertedComponent, "canbuildships", "shiptrader", "isdock", "owner")
		local doessellshipstoplayer = GetFactionData(owner, "doessellshipstoplayer")
		if canbuildships then
			-- don't show option for npcs if they are missing the shiptrader, but do for player objects
			if shiptrader or isplayerownedtarget then
				local active = true
				local mouseovertext = ""
				if not doessellshipstoplayer then
					active = false
					mouseovertext = ReadText(1026, 7865)
				elseif not isdock then
					active = false
					mouseovertext = ReadText(1026, 8014)
				elseif shiptrader == nil then
					active = false
					mouseovertext = ReadText(1026, 7827)
				end
				menu.insertInteractionContent("main", { type = actiontype, text = isplayerownedtarget and ReadText(1001, 7875) or ReadText(1001, 7838), helpOverlayID = "interactmenu_buildship", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonShipConfig("purchase") end, active = active, mouseOverText = mouseovertext })
			end
		end
	elseif actiontype == "changeformation" then
		if istobedisplayed and IsComponentOperational(convertedComponent) then
			local subordinates = GetSubordinates(convertedComponent)
			if #subordinates > 0 then
				local n = C.GetNumFormationShapes()
				local buf = ffi.new("UIFormationInfo[?]", n)
				n = C.GetFormationShapes(buf, n)
				local formationshapes = {}
				for i = 0, n - 1 do
					table.insert(formationshapes, { name = ffi.string(buf[i].name), shape = ffi.string(buf[i].shape), requiredSkill = buf[i].requiredSkill * 3 })
				end
				table.sort(formationshapes, Helper.sortName)
				local pilot = ConvertIDTo64Bit(GetComponentData(convertedComponent, "assignedpilot"))
				local isplayer = pilot == C.GetPlayerID()
				local adjustedskill = (pilot and (pilot ~= 0)) and math.floor(C.GetEntityCombinedSkill(pilot, nil, isplayer and "playerpilot" or "aipilot") * 15 / 100) or 0
				for _, data in ipairs(formationshapes) do
					menu.insertInteractionContent("formationshape", { type = actiontype, text = data.name, text2 = ((data.requiredSkill <= adjustedskill) and ColorText["text_skills"] or ColorText["text_inactive"]) .. Helper.displaySkill(data.requiredSkill), helpOverlayID = "interactmenu_changeformation", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonFormationShape(data.shape, subordinates) end, active = data.requiredSkill <= adjustedskill })
				end
			end
		end
	elseif (actiontype == "claim") then
		if istobedisplayed and (#menu.selectedplayerships == 1) and C.IsComponentClass(menu.componentSlot.component, "ship") then
			local canbeclaimed, isdefendingfromboardingoperation = GetComponentData(convertedComponent, "canbeclaimed", "isdefendingfromboardingoperation")
			if canbeclaimed and (not isdefendingfromboardingoperation) then
				local isdocked, hasavailablemarines, maxradarrange = GetComponentData(menu.selectedplayerships[1], "isdocked", "hasavailablemarines", "maxradarrange")
				local active, mouseovertext = true, ""
				if not hasavailablemarines then
					active = false
					mouseovertext = ReadText(1026, 7822)
				elseif C.GetDistanceBetween(menu.componentSlot.component, menu.selectedplayerships[1]) > maxradarrange then
					active = false
					mouseovertext = ReadText(1026, 7802)
				elseif isdocked then
					active = false
					mouseovertext = ReadText(1026, 7817)
				end
				menu.insertInteractionContent((not menu.showPlayerInteractions) and "selected_orders" or "interaction", { type = actiontype, text = ReadText(1010, 5), helpOverlayID = "interactmenu_claim", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonClaim(menu.selectedplayerships[1]) end, active = active, mouseOverText = mouseovertext })
			end
		end
	elseif actiontype == "configurestation" then
		if istobedisplayed then
			menu.insertInteractionContent("main", { type = actiontype, text = ReadText(1001, 7809), helpOverlayID = "interactmenu_configurestation", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = menu.buttonStationConfig })
		end
	elseif actiontype == "collect" then
		if #menu.selectedplayerships > 0 and menu.possibleorders["Collect"] and menu.componentSlot.component and C.IsComponentClass(menu.componentSlot.component, "drop") then
			local active, mouseovertext = menu.canCollectCrates(menu.hasPlayerShipPilot)
			menu.insertInteractionContent("selected_orders", { type = actiontype, text = menu.orderIconText("Collect") .. ReadText(1001, 7867), helpOverlayID = "interactmenu_collect", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonCollect(false) end, hidetarget = true, active = active, mouseOverText = mouseovertext, orderid = "Collect" } )
		end
	elseif actiontype == "collectdeployable" then
		if (#menu.selectedplayerships > 0) and isplayerownedtarget and menu.possibleorders["CollectDeployables"] and menu.componentSlot.component and GetComponentData(convertedComponent, "isdeployable") then
			local active, mouseovertext = menu.canCollectCrates(menu.hasPlayerShipPilot)
			menu.insertInteractionContent("selected_orders", { type = actiontype, text = menu.orderIconText("CollectDeployables") .. ReadText(1001, 11103), helpOverlayID = "interactmenu_collect_deployable", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonCollectDeployable(false) end, hidetarget = true, active = active, mouseOverText = mouseovertext, orderid = "CollectDeployables" } )
		end
	elseif actiontype == "collectdeployables" then
		if istobedisplayed and isplayerownedtarget and (not istargetplayeroccupiedship) and IsComponentOperational(convertedComponent) and (not GetComponentData(convertedComponent, "isdeployable")) and (not C.IsUnit(convertedComponent)) then
			if menu.mode ~= "shipconsole" then
				local active, mouseovertext = menu.canCollectCrates(hastargetpilot)
				if menu.data.hastargetorderloop and (not menu.loopableorders["CollectDeployables"]) then
					active = false
					mouseovertext = ReadText(1026, 7851)
				end
				mouseovertext = ReadText(1041, 692) .. (((mouseOverText ~= nil) and (mouseOverText ~= "")) and ("\n\n" .. mouseOverText) or "")
				menu.insertInteractionContent("main_orders", { type = actiontype, text = menu.orderIconText("CollectDeployables") .. ReadText(1001, 7885), helpOverlayID = "interactmenu_collectdeployables", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonCollectDeployables(false) end, hidetarget = true, active = active, mouseOverText = mouseovertext } )
			end
		end
	elseif actiontype == "collectlockbox" then
		if #menu.selectedplayerships > 0 and menu.possibleorders["CollectLockbox"] and menu.componentSlot.component and C.IsComponentClass(menu.componentSlot.component, "lockbox") then
			-- these variables are used to determine if the button should be active and must be initialized to false because the button activates if nil.
			local isnotcapship = false
			local hasactiveguns = false
			local hasinactiveguns = false
			for _, ship in ipairs(menu.selectedplayerships) do
				-- we need to make sure that at least one ship in the selection has all of the requirements. selection will be further filtered down when the orders on the individual ships start.
				isnotcapship = not C.IsComponentClass(ship, "ship_l") and not C.IsComponentClass(ship, "ship_xl")

				--uint32_t GetDefensibleDPS(DPSData* result, UniverseID defensibleid, bool primary, bool secondary, bool lasers, bool missiles, bool turrets, bool includeheat, bool includeinactive);
				local activedpstable = ffi.new("DPSData[?]", 6)
				local numtotalquadrants = C.GetDefensibleDPS(activedpstable, ship, true, true, true, false, false, false, false)
				hasactiveguns = activedpstable[0].dps > 0

				local inactivedpstable = ffi.new("DPSData[?]", 6)
				local numtotalquadrants = C.GetDefensibleDPS(inactivedpstable, ship, true, true, true, false, false, false, true)
				hasinactiveguns = inactivedpstable[0].dps > 0

				if isnotcapship and hasactiveguns then
					break
				end
			end

			local active = isnotcapship and hasactiveguns and menu.hasPlayerShipPilot
			local mouseovertext
			if not isnotcapship then
				mouseovertext = ReadText(1026, 20039)
			elseif not menu.hasPlayerShipPilot then
				mouseovertext = ReadText(1026, 7801)
			elseif not hasactiveguns then
				if hasinactiveguns then
					mouseovertext = ReadText(1026, 7847)
				else
					mouseovertext = ReadText(1026, 20040)
				end
			end

			menu.insertInteractionContent("selected_orders", { type = actiontype, text = menu.orderIconText("CollectLockbox") .. ReadText(1041, 661), helpOverlayID = "interactmenu_collectlockbox", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonCollectLockbox(false) end, active = active, hidetarget = true, mouseOverText = mouseovertext, orderid = "CollectLockbox" } )
		end
	elseif actiontype == "collectspace" then
		if menu.offsetcomponent and (menu.offsetcomponent ~= 0) then
			if #menu.selectedplayerships > 0 and menu.possibleorders["CollectDropsInRadius"] then
				local active, mouseovertext = menu.canCollectCrates(menu.hasPlayerShipPilot)
				menu.insertInteractionContent("selected_orders", { type = actiontype, text = menu.orderIconText("CollectDropsInRadius") .. ReadText(1001, 7866), helpOverlayID = "interactmenu_collectspace", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonCollectRadius(false) end, hidetarget = true, active = active, mouseOverText = mouseovertext, orderid = "CollectDropsInRadius" } )
			end
		end
	elseif actiontype == "salvagespace" then
		if menu.offsetcomponent and (menu.offsetcomponent ~= 0) then
			if #menu.selectedplayerships > 0 and menu.possibleorders["SalvageInRadius"] then
				local active, mouseovertext = menu.canSalvage(menu.hasPlayerShipPilot)
				menu.insertInteractionContent("selected_orders", { type = actiontype, text = menu.orderIconText("SalvageInRadius") .. ReadText(1041, 871), helpOverlayID = "interactmenu_salvagespace", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonSalvageInRadius(false) end, hidetarget = true, active = active, mouseOverText = mouseovertext, orderid = "SalvageInRadius" } )
			end
		end
	elseif actiontype == "crewtransfer" then
		if (#menu.selectedplayerships == 1) and GetComponentData(convertedComponent, "isdock") and (not GetComponentData(convertedComponent, "isdeployable")) and (not C.IsUnit(convertedComponent)) and (not C.IsComponentClass(convertedComponent, "ship_xs")) and (C.GetPeopleCapacity(convertedComponent, "", true) > 0) then
			if (not GetComponentData(menu.selectedplayerships[1], "isdeployable")) and (not C.IsComponentClass(menu.selectedplayerships[1], "spacesuit")) then
				if C.IsComponentClass(menu.componentSlot.component, "container") then
					if C.IsComponentClass(menu.componentSlot.component, "station") or isplayerownedtarget then
						local active = true
						local mouseovertext = ""
						if C.IsComponentClass(menu.componentSlot.component, "station") then
							if isplayerownedtarget then
								local tradenpc, shiptrader, isshipyard, iswharf, isequipmentdock = GetComponentData(convertedComponent, "tradenpc", "shiptrader", "isshipyard", "iswharf", "isequipmentdock")
								local canhavetrainees = C.CanControllableHaveAnyTrainees(menu.componentSlot.component)
								if (tradenpc ~= nil) and ((not (isshipyard or iswharf or isequipmentdock)) or (shiptrader ~= nil)) and (not canhavetrainees) then
									active = false
									mouseovertext = ReadText(1026, 3249)
								end
							else
								local nummissionnpcrequests = C.GetNumRequestedMissionNPCs(menu.componentSlot.component)
								active = nummissionnpcrequests > 0
								mouseovertext = active and "" or ReadText(1026, 3248)
							end
						end
						menu.insertInteractionContent(menu.showPlayerInteractions and "player_interaction" or "selected_orders", { type = actiontype, text = menu.orderIconText("CrewExchange") .. ReadText(1001, 7880), helpOverlayID = "interactmenu_crewtransfer", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonCrewTransfer(menu.selectedplayerships[1]) end, active = active, mouseOverText = mouseovertext })
					end
				end
			end
		end
	elseif actiontype == "deliverwares" then
		if istobedisplayed and IsComponentOperational(convertedComponent) then
			local nummissionwarerequests = C.GetNumRequestedMissionWares(menu.componentSlot.component)
			local requestbuf = ffi.new("MissionWareDeliveryCounts[?]", nummissionwarerequests)
			nummissionwarerequests = C.GetRequestedMissionWares(requestbuf, nummissionwarerequests, menu.componentSlot.component)
			if nummissionwarerequests == 1 then
				local request = requestbuf[0]

				local buf = ffi.new("MissionWareDeliveryInfo[1]")
				buf[0].numwares = request.numwares
				buf[0].wares = Helper.ffiNewHelper("UIWareAmount[?]", request.numwares)
				C.GetMissionDeliveryWares(buf, request.missionid)

				local wares = {}
				for i = 0, buf[0].numwares - 1 do
					table.insert(wares, { ware = ffi.string(buf[0].wares[i].wareid), amount = buf[0].wares[i].amount })
				end

				local missiondetails = C.GetMissionIDDetails(request.missionid)

				local active = true
				local mouseovertext = ffi.string(missiondetails.missionName)
				local cargo = GetComponentData(convertedComponent, "cargo") or {}
				for _, entry in ipairs(wares) do
					if (cargo[entry.ware] or 0) == 0 then
						active = false
						mouseovertext = mouseovertext .. "\n" .. ColorText["text_error"] .. ReadText(1026, 3406)
						break
					end
				end
				local missionid = request.missionid
				menu.insertInteractionContent((menu.showPlayerInteractions and (not menu.shown)) and "player_interaction" or "interaction", { type = actiontype, text = ReadText(1001, 3423), helpOverlayID = "interactmenu_deliverwares", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonDeliverWares(missionid) end, active = active, mouseOverText = mouseovertext })
			end
		end
	elseif actiontype == "deployhere" then
		if istobedisplayed and (not GetComponentData(convertedComponent, "isdeployable")) and (not C.IsUnit(convertedComponent)) and (not menu.data.hastargetorderloop) then
			if menu.mode ~= "shipconsole" then
				-- force sub section and assume we have no deployables
				menu.forceSubSection["consumables_civilian"] = ReadText(1026, 7818)
				menu.forceSubSection["consumables_military"] = ReadText(1026, 7819)
				-- check if we have deploables
				for _, entry in ipairs(config.consumables) do
					local numconsumable = entry.getnum(menu.componentSlot.component)
					if numconsumable > 0 then
						local consumables = ffi.new("AmmoData[?]", numconsumable)
						numconsumable = entry.getdata(consumables, numconsumable, menu.componentSlot.component)
						for j = 0, numconsumable - 1 do
							if consumables[j].amount > 0 then
								-- clear force if we do have deployables, enabling the isdocked check to set it's own force reason
								menu.forceSubSection["consumables_" .. entry.type] = nil
								break
							end
						end
					end
				end

				local isdocked = GetComponentData(convertedComponent, "isdocked")
				local isinhighway = C.GetContextByClass(menu.componentSlot.component, "highway", false) ~= 0
				if (not isdocked) and (not isinhighway) and (hastargetpilot or istargetplayeroccupiedship) then
					for _, entry in ipairs(config.consumables) do
						menu.addConsumableEntry("consumables", entry, menu.componentSlot.component, menu.buttonDeploy)
					end
				else
					-- only force if not previously forced (i.e. no deployables is a more important reason than being docked)
					if not menu.forceSubSection["consumables_civilian"] then
						if (not hastargetpilot) and (not istargetplayeroccupiedship) then
							menu.forceSubSection["consumables_civilian"] = ReadText(1026, 7801)
						elseif isinhighway then
							menu.forceSubSection["consumables_civilian"] = ReadText(1026, 7845)
						else
							menu.forceSubSection["consumables_civilian"] = ReadText(1026, 7817)
						end
					end
					if not menu.forceSubSection["consumables_military"] then
						if (not hastargetpilot) and (not istargetplayeroccupiedship) then
							menu.forceSubSection["consumables_military"] = ReadText(1026, 7801)
						elseif isinhighway then
							menu.forceSubSection["consumables_military"] = ReadText(1026, 7845)
						else
							menu.forceSubSection["consumables_military"] = ReadText(1026, 7817)
						end
					end
				end
			end
		end
	elseif actiontype == "deployat" then
		if menu.offsetcomponent and (menu.offsetcomponent ~= 0) then
			if (#menu.selectedplayerships == 1) and menu.possibleorders["DeployObjectAtPosition"] and (menu.numorderloops == 0) then
				-- force sub section and assume we have no deployables
				menu.forceSubSection["selected_consumables_civilian"] = ReadText(1026, 7818)
				menu.forceSubSection["selected_consumables_military"] = ReadText(1026, 7819)
				-- check if we have deploables
				for _, entry in ipairs(config.consumables) do
					local numconsumable = entry.getnum(menu.selectedplayerships[1])
					if numconsumable > 0 then
						local consumables = ffi.new("AmmoData[?]", numconsumable)
						numconsumable = entry.getdata(consumables, numconsumable, menu.selectedplayerships[1])
						for j = 0, numconsumable - 1 do
							if consumables[j].amount > 0 then
								-- clear force if we do have deployables, enabling the isdocked check to set it's own force reason
								menu.forceSubSection["selected_consumables_" .. entry.type] = nil
								break
							end
						end
					end
				end
				if menu.hasPlayerShipPilot then
					for _, entry in ipairs(config.consumables) do
						menu.addConsumableEntry("selected_consumables", entry, menu.selectedplayerships[1], menu.buttonDeployAtPosition)
					end
				else
					-- only force if not previously forced (i.e. no deployables is a more important reason than no pilot)
					if not menu.forceSubSection["selected_consumables_civilian"] then
						menu.forceSubSection["selected_consumables_civilian"] = ReadText(1026, 7830)
					end
					if not menu.forceSubSection["selected_consumables_military"] then
						menu.forceSubSection["selected_consumables_military"] = ReadText(1026, 7830)
					end
				end
			end
		end
	elseif actiontype == "depositinventory" then
		local stationhqlist = {}
		Helper.ffiVLA(stationhqlist, "UniverseID", C.GetNumHQs, C.GetHQs, "player")
		-- show the button once the player gets the HQ since that's a bigger state change.
		-- NB: button requires that ship have a pilot, that that pilot have stuff in his or her pockets, and that the player has an HQ. Otherwise, show the button but keep it inactive.
		if #stationhqlist > 0 then
			if istobedisplayed then
				local hasinventory, haspilot = false, false

				local isdeployable, pilot = GetComponentData(convertedComponent, "isdeployable", "pilot")
				if (not C.IsUnit(menu.componentSlot.component)) and (not isdeployable) then
					if pilot and (pilot ~= 0) then
						haspilot = true
						if next(GetInventory(pilot)) ~= nil then
							hasinventory = true
						end
					end
				end

				if not hasinventory then
					for _, ship in ipairs(menu.selectedplayerships) do
						local isdeployable, pilot = GetComponentData(ship, "isdeployable", "pilot")
						if (not C.IsUnit(ship)) and (not isdeployable) then
							if pilot and (pilot ~= 0) then
								haspilot = true
								if next(GetInventory(pilot)) ~= nil then
									hasinventory = true
									break
								end
							end
						end
					end
				end

				menu.insertInteractionContent(((not menu.showPlayerInteractions) and (#menu.selectedplayerships > 0)) and "selected_orders_all" or "main_orders", { type = actiontype, text = menu.orderIconText("DepositInventory") .. ReadText(1041, 651), helpOverlayID = "interactmenu_depositinventory", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonDepositInventoryAtHQ() end, active = hasinventory, mouseOverText = (not haspilot) and ReadText(1026, 7801) or ReadText(1026, 7829) })
			end
		end
	elseif actiontype == "dockat" then
		if menu.possibleorders["DockAndWait"] then
			local isalreadydocked = true
			for _, ship in ipairs(menu.selectedplayerships) do
				local parentcontainer = C.GetContextByClass(ship, "container", false)
				if parentcontainer ~= 0 then
					if parentcontainer == menu.componentSlot.component then
						-- check if the ship is at a venture dock
						local parentdockingbay = C.GetContextByClass(ship, "dockarea", false)
						local ventureplatforms = {}
						Helper.ffiVLA(ventureplatforms, "UniverseID", C.GetNumVenturePlatforms, C.GetVenturePlatforms, menu.componentSlot.component)
						for _, platform in ipairs(ventureplatforms) do
							local docks = {}
							Helper.ffiVLA(docks, "UniverseID", C.GetNumVenturePlatformDocks, C.GetVenturePlatformDocks, platform)
							for _, dock in ipairs(docks) do
								if dock == parentdockingbay then
									isalreadydocked = false
									break
								end
							end
							if not isalreadydocked then
								break
							end
						end
						if isalreadydocked then
							-- if there is another order on the queue allow adding the new dock order
							local numorders = C.GetNumOrders(ship)
							if numorders > 0 then
								local currentorders = ffi.new("Order[?]", numorders)
								numorders = C.GetOrders(currentorders, numorders, ship)
								for i = 0, numorders - 1 do
									local orderdef = ffi.string(currentorders[i].orderdef)
									local params = GetOrderParams(ConvertStringTo64Bit(tostring(ship)), i + 1)
									if ((orderdef ~= "DockAndWait") and (orderdef ~= "DockAt")) or (ConvertIDTo64Bit(params[1].value) ~= convertedComponent) then
										isalreadydocked = false
										break
									end
								end
							end
						end
					else
						isalreadydocked = false
						break
					end
				else
					isalreadydocked = false
					break
				end
			end
			local active = (not isalreadydocked) and (menu.numdockingpossible > 0)
			local mouseovertext = ""
			if menu.numdockingpossible == 0 then
				local orderedKeys = Helper.orderedKeys(menu.dockingerrors)
				if orderedKeys[1] then
					mouseovertext = menu.dockingerrors[orderedKeys[1]]
				end
			elseif isalreadydocked then
				mouseovertext = ReadText(1026, 7846)
			end

			menu.insertInteractionContent("selected_orders", { type = actiontype, text = menu.orderIconText("DockAndWait") .. ReadText(1041, 451), helpOverlayID = "interactmenu_dockat", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonDock(false) end, active = active, mouseOverText = mouseovertext, orderid = "DockAndWait" })
		end
	elseif actiontype == "dockatplayer" then
		if istobedisplayed and (not istargetplayeroccupiedship) and IsComponentOperational(convertedComponent) and (not GetComponentData(convertedComponent, "isdeployable")) and (not C.IsUnit(convertedComponent)) and (menu.numorderloops == 0) and (not menu.data.hastargetorderloop) then
			if menu.mode ~= "shipconsole" then
				local playercontainer = C.GetPlayerContainerID()
				if playercontainer ~= 0 then
					local convertedPlayerContainer = ConvertStringTo64Bit(tostring(playercontainer))
					if isplayerownedtarget then
						local allinstorage = true
						local allexternallydocked = true
						if C.GetContextByClass(menu.componentSlot.component, "container", false) ~= playercontainer then
							allexternallydocked = false
							allinstorage = false
						elseif (not C.IsShipAtExternalDock(menu.componentSlot.component)) and (not C.IsShipBeingRetrieved(menu.componentSlot.component)) then
							allexternallydocked = false
						end
						if allinstorage or allexternallydocked then
							for _, ship in ipairs(menu.selectedplayerships) do
								if C.GetContextByClass(ship, "container", false) ~= playercontainer then
									allexternallydocked = false
									allinstorage = false
									break
								elseif (not C.IsShipAtExternalDock(ship)) and (not C.IsShipBeingRetrieved(ship)) then
									allexternallydocked = false
								end
							end
						end

						local active = true
						local mouseovertext = ReadText(1026, 20043)
						local isdock, hasshipdockingbays = GetComponentData(convertedPlayerContainer, "isdock", "hasshipdockingbays")
						if allexternallydocked then
							active = false
							mouseovertext = mouseovertext .. "\n\n" .. ReadText(1026, 7838)
						elseif not hasshipdockingbays then
							active = false
							mouseovertext = mouseovertext .. "\n\n" .. ReadText(1026, 7837)
						elseif not hastargetpilot then
							active = false
							mouseovertext = mouseovertext .. "\n\n" .. ReadText(1026, 7801)
						elseif menu.numdockingatplayerpossible == 0 then
							active = false
							mouseovertext = mouseovertext .. "\n\n" .. ReadText(1026, 7836)
						elseif not isdock then
							active = false
							mouseovertext = mouseovertext .. "\n\n" .. ReadText(1026, 7825)
						end

						menu.insertInteractionContent(((not menu.showPlayerInteractions) and (#menu.selectedplayerships > 0)) and "selected_orders_all" or "main_orders", { type = actiontype, text = menu.orderIconText("DockAndWait") .. (allinstorage and ReadText(1001, 7890) or ReadText(1001, 7837)), helpOverlayID = "interactmenu_dockatplayer", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonDockAtPlayer(false) end, hidetarget = true, active = active, mouseOverText = mouseovertext })
					end
				end
			end
		end
	elseif actiontype == "dockrequest" then
		local isshiporstation = C.IsComponentClass(menu.componentSlot.component, "ship") or C.IsComponentClass(menu.componentSlot.component, "station")
		local isdockingbay = C.IsComponentClass(menu.componentSlot.component, "dockingbay")
		if menu.showPlayerInteractions and (isshiporstation or isdockingbay) and (not GetComponentData(convertedComponent, "isdeployable")) and (isdockingbay or (not C.IsUnit(convertedComponent))) then
			local dockcontainer = convertedComponent
			if isdockingbay then
				dockcontainer = ConvertStringTo64Bit(tostring(C.GetContextByClass(dockcontainer, "container", false)))
			end
			local mouseovertext = Helper.getInputMouseOverText("INPUT_ACTION_DOCK_ACTION")
			if IsDockingPossible(ConvertStringTo64Bit(tostring(C.GetPlayerOccupiedShipID())), dockcontainer) then
				local dockrequestreason = ffi.string(C.RequestDockAtReason(dockcontainer, true))
				-- "granted" -> OK
				-- "queued" -> OK
				-- "impossible" -> Should be handled by IsDockingPossible() or the container is wrong or the player does not exist or the playercontrolled object does not exist
				if dockrequestreason == "denied" then -- DOCKINGREQUEST_DENIED
					local isdockingenabled = GetComponentData(dockcontainer, "isdockingenabled")
					if isdockingenabled then
						mouseovertext = ReadText(1026, 7825)
					else
						mouseovertext = ReadText(1026, 7843)
					end
				elseif dockrequestreason == "toofar" then -- DOCKINGREQUEST_TOOFAR
					mouseovertext = ReadText(1026, 7809)
				elseif dockrequestreason == "alreadydocked" then
					mouseovertext = ReadText(1026, 7857)
				end
			else
				mouseovertext = ReadText(1026, 7824)
			end
			menu.insertInteractionContent((menu.showPlayerInteractions and (not menu.shown)) and "player_interaction" or "interaction", { type = actiontype, text = (menu.showPlayerInteractions and (not menu.shown)) and ReadText(1001, 7845) or ReadText(1001, 7888), helpOverlayID = "interactmenu_dockrequest", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = menu.buttonDockRequest, active = C.RequestDockAt(dockcontainer, true), mouseOverText = mouseovertext })
		end
	elseif actiontype == "dropinventory" then
		if istobedisplayed then
			local pilot = ConvertIDTo64Bit(GetComponentData(convertedComponent, "pilot"))
			if pilot and (pilot ~= 0) then
				local inventory = GetInventory(pilot)
				if next(inventory) then
					local onlineitems = OnlineGetUserItems()

					local sortedWares = {}
					for ware, entry in pairs(inventory) do
						local ispersonalupgrade = GetWareData(ware, "ispersonalupgrade")
						if (not ispersonalupgrade) and (not onlineitems[ware]) then
							table.insert(sortedWares, { ware = ware, name = entry.name, amount = entry.amount })
						end
					end
					if #sortedWares > 0 then
						menu.insertInteractionContent("main_orders", { type = actiontype, text = ReadText(1001, 7878), helpOverlayID = "interactmenu_dropinventory", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonDropInventory(pilot) end })
					end
				end
			end
		end
	elseif actiontype == "encyclopedia" then
		menu.insertInteractionContent("main", { type = actiontype, text = ReadText(1001, 2416), helpOverlayID = "interactmenu_encyclopedia", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = menu.buttonEncyclopedia })
	elseif actiontype == "explore" then
		if #menu.selectedplayerships > 0 and menu.possibleorders["Explore"] and menu.componentSlot.component and (C.IsComponentClass(menu.componentSlot.component, "sector") or C.IsComponentClass(menu.componentSlot.component, "highwayentrygate") or C.IsComponentClass(menu.componentSlot.component, "highway") or (C.IsComponentClass(menu.componentSlot.component, "gate") and GetComponentData(ConvertStringTo64Bit(tostring(menu.componentSlot.component)), "isactive"))) then
			menu.insertInteractionContent("selected_orders", { type = actiontype, text = menu.orderIconText("Explore") .. ReadText(1001, 7828), helpOverlayID = "interactmenu_explore", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonExplore(false) end, orderid = "Explore" })
		end
	elseif actiontype == "exploreupdate" then
		if #menu.selectedplayerships > 0 and menu.possibleorders["ExploreUpdate"] and menu.componentSlot.component and (C.IsComponentClass(menu.componentSlot.component, "sector") or C.IsComponentClass(menu.componentSlot.component, "highwayentrygate") or C.IsComponentClass(menu.componentSlot.component, "highway") or (C.IsComponentClass(menu.componentSlot.component, "gate") and GetComponentData(ConvertStringTo64Bit(tostring(menu.componentSlot.component)), "isactive"))) then
			menu.insertInteractionContent("selected_orders", { type = actiontype, text = menu.orderIconText("ExploreUpdate") .. ReadText(1001, 7829), helpOverlayID = "interactmenu_exploreupdate", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonExploreUpdate(false) end, orderid = "ExploreUpdate" })
		end
	elseif actiontype == "flee" then
		if istobedisplayed and (not istargetplayeroccupiedship) and IsComponentOperational(convertedComponent) and (not GetComponentData(convertedComponent, "isdeployable")) and (not C.IsUnit(convertedComponent)) and C.IsComponentClass(menu.componentSlot.component, "destructible") then
			local firstorder
			local n = C.GetNumOrders(menu.componentSlot.component)
			local buf = ffi.new("Order2[?]", n)
			n = C.GetOrders2(buf, n, menu.componentSlot.component)
			if n > 0 then
				firstorder = {}
				firstorder.state = ffi.string(buf[0].state)
				firstorder.statename = ffi.string(buf[0].statename)
				firstorder.orderdef = ffi.string(buf[0].orderdef)
				firstorder.actualparams = tonumber(buf[0].actualparams)
				firstorder.enabled = buf[0].enabled
				firstorder.isinfinite = buf[0].isinfinite
				firstorder.issyncpointreached = buf[0].issyncpointreached
				firstorder.istemporder = buf[0].istemporder
				firstorder.isoverride = buf[0].isoverride

				local orderdefinition = ffi.new("OrderDefinition")
				if firstorder.orderdef ~= nil and C.GetOrderDefinition(orderdefinition, firstorder.orderdef) then
					firstorder.orderdef = {}
					firstorder.orderdef.id = ffi.string(orderdefinition.id)
					firstorder.orderdef.icon = ffi.string(orderdefinition.icon)
					firstorder.orderdef.name = ffi.string(orderdefinition.name)
				else
					firstorder.orderdef = { id = "", icon = "", name = "" }
				end
			end

			if (menu.showPlayerInteractions or (#menu.selectedplayerships == 0)) and firstorder and firstorder.isoverride then
				firstorder.params = GetOrderParams(convertedComponent, 1)

				menu.texts.overrideordername = firstorder.orderdef.name
				local attacker
				if firstorder.orderdef.id == "Flee" then
					if firstorder.params[6] and firstorder.params[6].value then
						local value = ConvertIDTo64Bit(firstorder.params[6].value)
						if value ~= 0 then
							attacker = value
						end
					end
				elseif firstorder.orderdef.id == "Attack" then
					if firstorder.params[1] and firstorder.params[1].value and (firstorder.params[1].type == "object") and (firstorder.params[1].value ~= 0) then
						attacker = firstorder.params[1].value
					end
				elseif firstorder.orderdef.id == "Wait" then
					if firstorder.params[5] and firstorder.params[5].value then
						local value = ConvertIDTo64Bit(firstorder.params[5].value)
						if value ~= 0 then
							attacker = value
						end
					end
				end

				local overrideOrderOptions = {}
					menu.insertInteractionContent("overrideorder", { type = "overrideorder", text = (firstorder.orderdef.id == "Attack") and firstorder.orderdef.name or ReadText(1001, 11228), script = function () return menu.buttonChangeOverrideOrder("Attack", attacker) end, active = (attacker ~= nil) and (firstorder.orderdef.id ~= "Attack"), mouseOverText = ReadText(1026, 3234) })
					menu.insertInteractionContent("overrideorder", { type = "overrideorder", text = (firstorder.orderdef.id == "Flee")   and firstorder.orderdef.name or ReadText(1001, 11220), script = function () return menu.buttonChangeOverrideOrder("Flee", attacker) end,   active = (attacker ~= nil) and (firstorder.orderdef.id ~= "Flee"),   mouseOverText = ReadText(1026, 3232) })
					menu.insertInteractionContent("overrideorder", { type = "overrideorder", text = (firstorder.orderdef.id == "Wait")   and firstorder.orderdef.name or ReadText(1001, 11247), script = function () return menu.buttonChangeOverrideOrder("Wait", attacker) end,   active = (attacker ~= nil) and (firstorder.orderdef.id ~= "Wait"),   mouseOverText = ReadText(1026, 3245) })
			else
				local curtime = GetCurTime()

				local hasbeenattacked = false
				local attacker

				local attackinfo = C.GetLastAttackInfo(menu.componentSlot.component)
				if attackinfo.time + 120 >= curtime then
					hasbeenattacked = true
					attacker = attackinfo.attacker
				end
				for _, ship in ipairs(menu.selectedplayerships) do
					local attackinfo = C.GetLastAttackInfo(ship)
					if attackinfo.time + 120 >= curtime then
						hasbeenattacked = true
						if not attacker then
							attacker = attackinfo.attacker
						end
					end
				end

				local active = true
				local mouseovertext = ""
				if (not hastargetpilot) and (not menu.hasPlayerShipPilot) then
					active = false
					mouseovertext = ReadText(1026, 7830)
				elseif not hasbeenattacked then
					active = false
					mouseovertext = ReadText(1026, 7842)
				end
				menu.insertInteractionContent(((not menu.showPlayerInteractions) and (#menu.selectedplayerships > 0)) and "selected_orders_all" or "main_orders", { type = actiontype, text = menu.orderIconText("Flee") .. ReadText(1041, 551), helpOverlayID = "interactmenu_flee", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonFlee(attacker, false) end, active = active, mouseOverText = mouseovertext })
			end
		end
	elseif actiontype == "fleetlogo" then
		if istobedisplayed then
			menu.insertInteractionContent("interaction", { type = actiontype, text = ReadText(1001, 11133), script = menu.buttonChangeLogo })
		end
	elseif actiontype == "fleetrename" then
		if istobedisplayed then
			menu.insertInteractionContent("interaction", { type = actiontype, text = ReadText(1001, 7895), script = function () return menu.buttonRename(true) end })
		end
	elseif actiontype == "flyto" then
		if #menu.selectedplayerships > 0 and menu.possibleorders["MoveWait"] then
			menu.insertInteractionContent("selected_orders", { type = actiontype, text = menu.orderIconText("MoveWait") .. ReadText(1041, 251), helpOverlayID = "interactmenu_flyto", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonMoveWait(false) end, orderid = "MoveWait" })
		end
	elseif actiontype == "follow" then
		if #menu.selectedplayerships > 0 and menu.possibleorders["Follow"] then
			menu.insertInteractionContent("selected_orders", { type = actiontype, text = menu.orderIconText("Follow") .. ReadText(1001, 7988), helpOverlayID = "interactmenu_follow", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonFollow(false) end, orderid = "Follow" })
		end
	elseif actiontype == "getsupplies" then
		if istobedisplayed and isplayerownedtarget and GetComponentData(convertedComponent, "issupplyship") then
			local active = true
			local mouseovertext = ReadText(1041, 622)
			if menu.hastargetorderloop and (not menu.loopableorders["GetSupplies"]) then
				active = false
				mouseovertext = mouseovertext .. "\n\n" .. ReadText(1026, 7851)
			elseif not hastargetpilot then
				active = false
				mouseovertext = mouseovertext .. "\n\n" .. ReadText(1026, 7801)
			end
			menu.insertInteractionContent("main_orders", { type = actiontype, text = menu.orderIconText("GetSupplies") .. ReadText(1041, 621), script = function () return menu.buttonGetSupplies() end, active = active, mouseOverText = mouseovertext, helpOverlayID = "interact_getsupplies", helpOverlayText = " ", helpOverlayHighlightOnly = true })
		end
	elseif actiontype == "guidance" then
		if (not istargetplayeroccupiedship) and (menu.mode ~= "shipconsole") then
			local text = ReadText(1001, 3256)
			local useoffset = false
			if C.IsComponentClass(menu.componentSlot.component, "sector") then
				text = ReadText(1001, 3242)
				useoffset = true
			end
			menu.insertInteractionContent((menu.showPlayerInteractions and (not menu.shown)) and "player_interaction" or "interaction", { type = actiontype, text = IsSameComponent(GetActiveGuidanceMissionComponent(), convertedComponent) and ReadText(1001, 3243) or text, helpOverlayID = "interactmenu_guidance", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonGuidance(useoffset) end, mouseOverText = Helper.getInputMouseOverText("INPUT_ACTION_TOGGLE_GUIDANCE") })
		end
	elseif actiontype == "hire" then
		if GetComponentData(convertedComponent, "primarypurpose") == "build" then
			local stations = GetContainedStationsByOwner("player", nil, true)
			for i = #stations, 1, -1 do
				local buildstorage = GetComponentData(stations[i], "buildstorage")
				if not C.DoesConstructionSequenceRequireBuilder(ConvertIDTo64Bit(stations[i])) then
					table.remove(stations, i)
				elseif C.GetNumAssignedConstructionVessels(ConvertIDTo64Bit(buildstorage)) > 0 then
					table.remove(stations, i)
				end
			end
			if #stations > 0 then
				local section = isplayerownedtarget and "assigningbuilder" or "hiringbuilder"
				local playermoney = GetPlayerMoney()
				local fee = tonumber(C.GetBuilderHiringFee())
				if (not isplayerownedtarget) and (playermoney < fee) then
					menu.forceSubSection[section] = ReadText(1001, 2966)
				elseif GetComponentData(convertedComponent, "isenemy")  then
					menu.forceSubSection[section] = ReadText(1026, 8014)
				elseif C.IsBuilderBusy(menu.componentSlot.component) then
					menu.forceSubSection[section] = ReadText(1026, 7820)
				else
					local mouseover = (not isplayerownedtarget) and (((fee > playermoney) and ColorText["text_error"] or ColorText["text_success"]) .. ReadText(1001, 7940) .. ReadText(1001, 120) .. " " .. ConvertMoneyString(fee, false, true, nil, true) .. " " .. ReadText(1001, 101) .. "\027X") or ""
					for i, station in ipairs(stations) do
						local station64 = ConvertIDTo64Bit(station)
						menu.insertInteractionContent(section, { type = actiontype, text = Helper.convertColorToText(menu.holomapcolor.playercolor) .. ffi.string(C.GetComponentName(station64)) .. " (" .. ffi.string(C.GetObjectIDCode(station64)) .. ")", helpOverlayID = "interactmenu_hire", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonDeployToStation(menu.componentSlot.component, false, station64) end, mouseOverText = mouseover })
					end
				end
			end
		end
	elseif actiontype == "intersectordefence" then
		local shiptype = GetComponentData(convertedComponent, "shiptype")
		local commander = ConvertIDTo64Bit(GetCommander(convertedComponent))
		local subordinates = GetSubordinates(convertedComponent)
		local isfleetcommander = (not commander) and (#subordinates > 0)
		local hasintersectorgroup = C.HasSubordinateAssignment(convertedComponent, "positiondefence")
		if (#menu.selectedplayerships == 0) and istobedisplayed and (shiptype == "carrier") and (isfleetcommander or hasintersectorgroup) then
			--local subordinates = GetSubordinates(convertedComponent)
			local groups = menu.getSubordinatesInGroups(convertedComponent, C.IsComponentClass(convertedComponent, "station"))

			menu.insertInteractionContent("interaction", { type = actiontype, text = hasintersectorgroup and ReadText(1001, 11135) or ReadText(1001, 11134), script = function () return menu.buttonSetInterSectorDefence(groups, hasintersectorgroup) end })
		end
	elseif actiontype == "livestream" then
		if (menu.mode ~= "shipconsole") then
			local active = true
			local mouseovertext = Helper.getInputMouseOverText("INPUT_ACTION_CINEMATIC_CAMERA")
			local isinternallystored, isinnormalspace, isinliveview, isfriend, isally = GetComponentData(convertedComponent, "isinternallystored", "isinnormalspace", "isinliveview", "isfriend", "isally")
			if isinternallystored then
				active = false
				mouseovertext = ReadText(1026, 7811)
			elseif not isinnormalspace then
				active = false
				mouseovertext = ReadText(1026, 7809)
			elseif not isinliveview then
				local ismilitary = false
				if C.IsComponentClass(convertedComponent, "station") then
					local iswharf, isshipyard, isdefencestation, istradestation = GetComponentData(convertedComponent, "iswharf", "isshipyard", "isdefencestation", "istradestation")
					--print("iswharf: " .. tostring(iswharf) .. ", isshipyard: " .. tostring(isshipyard) .. ", isdefencestation: " .. tostring(isdefencestation))
					ismilitary = (iswharf or isshipyard or isdefencestation) and not istradestation
				elseif C.IsComponentClass(convertedComponent, "ship") then
					local purpose = GetComponentData(convertedComponent, "primarypurpose")
					ismilitary = (purpose == "fight" or purpose == "auxiliary")
				end
				if not isally and ismilitary then
					active = false
					mouseovertext = ReadText(20218, 17)
				elseif not isfriend then
					active = false
					mouseovertext = ReadText(20218, 15)
				end
			elseif not C.CanSetPlayerCameraCinematicView() then
				active = false
				mouseovertext = ReadText(1001, 9408)
			end
			menu.insertInteractionContent("interaction", { type = actiontype, text = ReadText(1001, 12217), script = menu.buttonLiveStream, active = active, mouseOverText = mouseovertext })
		end
	elseif actiontype == "logicalstationoverview" then
		menu.insertInteractionContent("main", { type = actiontype, text = ReadText(1001,8401), helpOverlayID = "interactmenu_logicalstationoverview", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = menu.buttonStationOverview })
	elseif actiontype == "manageassignments" then
		if istobedisplayed and IsComponentOperational(convertedComponent) and not C.IsUnit(convertedComponent) then
			local commander = ConvertIDTo64Bit(GetCommander(convertedComponent))
			if commander and commander ~= 0 then
				menu.insertInteractionContent("main_assignments", { type = actiontype, text = ReadText(1001, 7810), script = function () menu.buttonRemoveAssignment() end })
				local currentgroup, purpose, shiptype = GetComponentData(convertedComponent, "subordinategroup", "primarypurpose", "shiptype")
				local subordinates = GetSubordinates(commander)

				local isstation = C.IsComponentClass(commander, "station")
				local isship = C.IsComponentClass(commander, "ship")
				local groups = menu.getSubordinatesInGroups(commander, isstation)
				-- defence
				menu.insertAssignSubActions("main_assignments_defence", "defence", menu.buttonChangeAssignment, groups, isstation, isstation, currentgroup)
				-- supplyfleet
				if shiptype == "resupplier" then
					menu.insertAssignSubActions("main_assignments_supplyfleet", "supplyfleet", menu.buttonChangeAssignment, groups, isstation, true, currentgroup)
				end
				if isstation then
					-- trading
					menu.insertAssignSubActions("main_assignments_trade", "trade", menu.buttonChangeAssignment, groups, isstation, true, currentgroup, (purpose == "mine") and (ColorText["text_warning"] .. ReadText(1026, 8608)) or "")
					if purpose == "mine" then
						-- mining
						menu.insertAssignSubActions("main_assignments_mining", "mining", menu.buttonChangeAssignment, groups, isstation, true, currentgroup)
					else
						-- tarding for buildstorage
						menu.insertAssignSubActions("main_assignments_tradeforbuildstorage", "tradeforbuildstorage", menu.buttonChangeAssignment, groups, isstation, true, currentgroup)
					end
					if purpose == "salvage" then
						menu.insertAssignSubActions("main_assignments_salvage", "salvage", menu.buttonChangeAssignment, groups, isstation, true, currentgroup)
					end
				elseif isship then
					-- position defence
					local shiptype = GetComponentData(commander, "shiptype")
					local parentcommander = ConvertIDTo64Bit(GetCommander(commander))
					local isfleetcommander = (not parentcommander) and (#subordinates > 0)
					if (shiptype == "carrier") and isfleetcommander then
						menu.insertAssignSubActions("main_assignments_positiondefence", "positiondefence", menu.buttonChangeAssignment, groups, isstation, nil, currentgroup)
					end
					menu.insertAssignSubActions("main_assignments_attack", "attack", menu.buttonChangeAssignment, groups, isstation, nil, currentgroup)
					menu.insertAssignSubActions("main_assignments_interception", "interception", menu.buttonChangeAssignment, groups, isstation, nil, currentgroup)
					menu.insertAssignSubActions("main_assignments_bombardment", "bombardment", menu.buttonChangeAssignment, groups, isstation, nil, currentgroup)
					menu.insertAssignSubActions("main_assignments_follow", "follow", menu.buttonChangeAssignment, groups, isstation, true, currentgroup)
					local buf = ffi.new("Order")
					if C.GetDefaultOrder(buf, commander) then
						menu.insertAssignSubActions("main_assignments_assist", "assist", menu.buttonChangeAssignment, groups, isstation, true, currentgroup)
					end

					-- start: aegs call-back
					if callbacks ["map_rightMenu_shipassignments_insert_02"] then
						local state,main_o,assignment_o,purpose_o
						for _, callback in ipairs (callbacks ["map_rightMenu_shipassignments_insert_02"]) do
							state,main_o,assignment_o,purpose_o = callback (GetComponentData(commander, "macro"))
							if state and purpose == purpose_o then
								menu.insertAssignSubActions(main_o, assignment_o, menu.buttonChangeAssignment, groups, isstation, true, currentgroup)
							end
						end
					end
					-- end: aegs call-back

					if shiptype == "resupplier" then
						menu.insertAssignSubActions("main_assignments_trade", "trade", menu.buttonChangeAssignment, groups, isstation, true, currentgroup)
					end
				end
			end
			if menu.numshipswithcommander > 1 then
				menu.insertInteractionContent("selected_assignments_all", { type = actiontype, text = ReadText(1001, 7887), script = function () menu.buttonRemoveAssignment(true) end })
			end
			-- manage multiple selected ships with the interacted object as commander
			if (menu.numassignableships == 0) and (#menu.shipswithcurrentcommander > 0) then
				local subordinates = GetSubordinates(convertedComponent)

				local allresupplier = true
				local allmining = true
				local allnomining = true
				local alltugs = true
				for _, ship in ipairs(menu.shipswithcurrentcommander) do
					local purpose, shiptype = GetComponentData(ship, "primarypurpose", "shiptype")
					if shiptype ~= "resupplier" then
						allresupplier = false
					end
					if purpose == "mine" then
						allnomining = false
					end
					if purpose ~= "mine" then
						allmining = false
					end
					if shiptype ~= "tug" then
						alltugs = false
					end
				end

				local isstation = C.IsComponentClass(menu.componentSlot.component, "station")
				local isship = C.IsComponentClass(menu.componentSlot.component, "ship")
				local groups = menu.getSubordinatesInGroups(menu.componentSlot.component, isstation)
				-- defence
				menu.insertAssignSubActions("selected_change_assignments_defence", "defence", menu.buttonChangeAssignment, groups, isstation, isstation)
				-- supplyfleet
				if allresupplier then
					menu.insertAssignSubActions("selected_change_assignments_supplyfleet", "supplyfleet", menu.buttonChangeAssignment, groups, isstation, true)
				end
				if isstation then
					-- trading
					menu.insertAssignSubActions("selected_change_assignments_trade", "trade", menu.buttonChangeAssignment, groups, isstation, true, nil, (not allnomining) and (ColorText["text_warning"] .. ReadText(1026, 8609)) or "")
					if allmining then
						-- mining
						menu.insertAssignSubActions("selected_change_assignments_mining", "mining", menu.buttonChangeAssignment, groups, isstation, true)
					elseif allnomining then
						-- trading for buildstorage
						menu.insertAssignSubActions("selected_change_assignments_tradeforbuildstorage", "tradeforbuildstorage", menu.buttonChangeAssignment, groups, isstation, true)
					end
					if alltugs then
						menu.insertAssignSubActions("selected_change_assignments_salvage", "salvage", menu.buttonChangeAssignment, groups, isstation, true)
					end
				elseif isship then
					-- position defence
					local shiptype = GetComponentData(convertedComponent, "shiptype")
					local parentcommander = ConvertIDTo64Bit(GetCommander(convertedComponent))
					local isfleetcommander = (not parentcommander) and (#subordinates > 0)
					if (shiptype == "carrier") and isfleetcommander then
						menu.insertAssignSubActions("selected_change_assignments_positiondefence", "positiondefence", menu.buttonChangeAssignment, groups, isstation, nil)
					end
					menu.insertAssignSubActions("selected_change_assignments_attack", "attack", menu.buttonChangeAssignment, groups, isstation, nil)
					menu.insertAssignSubActions("selected_change_assignments_interception", "interception", menu.buttonChangeAssignment, groups, isstation, nil)
					menu.insertAssignSubActions("selected_change_assignments_bombardment", "bombardment", menu.buttonChangeAssignment, groups, isstation, nil)
					menu.insertAssignSubActions("selected_change_assignments_follow", "follow", menu.buttonChangeAssignment, groups, isstation, true)
					local buf = ffi.new("Order")
					if C.GetDefaultOrder(buf, menu.componentSlot.component) then
						menu.insertAssignSubActions("selected_change_assignments_assist", "assist", menu.buttonChangeAssignment, groups, isstation, true)
					end
					-- start: aegs call-back
					if callbacks ["map_rightMenu_shipassignments_insert_03"] then
						local state,main_o,assignment_o
						for _, callback in ipairs (callbacks ["map_rightMenu_shipassignments_insert_03"]) do
							state,main_o,assignment_o = callback (GetComponentData(convertedComponent, "macro"),allmining,alltugs)
							if state then
								menu.insertAssignSubActions(main_o, assignment_o, menu.buttonChangeAssignment, groups, isstation, true)
							end
						end
					end
					-- end: aegs call-back
					if shiptype == "resupplier" then
						menu.insertAssignSubActions("selected_change_assignments_trade", "trade", menu.buttonChangeAssignment, groups, isstation, true)
					end
				end
			end
		end
	elseif actiontype == "markashostile" then
		if (menu.mode ~= "shipconsole") and (not GetComponentData(convertedComponent, "isreallyplayerowned")) then
			local active = true
			local mouseovertext = ""
			if GetComponentData(convertedComponent, "ishostile") then
				active = false
				mouseovertext = ReadText(1026, 7853)
			end
			menu.insertInteractionContent((menu.showPlayerInteractions and (not menu.shown)) and "player_interaction" or "interaction", { type = actiontype, text = ReadText(1001, 11114), helpOverlayID = "interactmenu_markashostile", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = menu.buttonMarkAsHostile, active = active, mouseOverText = mouseovertext })
		end
	elseif actiontype == "mining" then
		if #menu.selectedplayerships > 0 and menu.possibleorders["MiningPlayer"] then
			if menu.offsetcomponent and (menu.offsetcomponent ~= 0) and C.IsComponentClass(menu.offsetcomponent, "sector") then
				local pos = ffi.new("Coord3D", { x = menu.offset.x, y = menu.offset.y, z = menu.offset.z })
				local nummineables = C.GetNumMineablesAtSectorPos(menu.offsetcomponent, pos)
				local mineables = ffi.new("YieldInfo[?]", nummineables)
				nummineables = C.GetMineablesAtSectorPos(mineables, nummineables, menu.offsetcomponent, pos)
				local miningwares = {}
				for i = 0, nummineables - 1 do
					if mineables[i].amount > 10 then
						local ware = ffi.string(mineables[i].wareid)
						table.insert(miningwares, { ware = ware, name = GetWareData(ware, "name"), amount = 0 })
						local entry = miningwares[#miningwares]
						for _, ship in ipairs(menu.selectedplayerships) do
							if GetWareCapacity(ship, ware, true) > 0 then
								entry.amount = entry.amount + 1
							end
						end
					end
				end
				table.sort(miningwares, Helper.sortName)
				local found = false
				for _, entry in ipairs(miningwares) do
					if entry.amount > 0 then
						found = true
						menu.insertInteractionContent("mining", { type = actiontype, text = entry.name, text2 = Helper.convertColorToText(menu.holomapcolor.playercolor) .. ((entry.amount == 1) and ReadText(1001, 7851) or string.format(ReadText(1001, 7801), entry.amount)), script = function () return menu.buttonMining(entry.ware, false) end, orderid = "MiningPlayer" })
					end
				end
				if not found then
					menu.forceSubSection["mining"] = ReadText(1026, 7823)
				end
			end
		end
	elseif actiontype == "paintmod" then
		if istobedisplayed then
			menu.insertInteractionContent(((not menu.showPlayerInteractions) and (#menu.selectedplayerships > 0)) and "selected_orders_all" or "interaction", { type = actiontype, text = ReadText(1001, 7859), helpOverlayID = "interactmenu_paintmod", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = menu.buttonPaintMod })
		end
	elseif actiontype == "player_docktotrade" then
		local tradeoffers = GetTradeList(convertedComponent)
		if not isplayerownedtarget and menu.possibleorders["Player_DockToTrade"] and (#tradeoffers == 0) and GetComponentData(convertedComponent, "isdock") and (menu.numdockingpossible > 0) then
			menu.insertInteractionContent("selected_orders", { type = actiontype, text = menu.orderIconText("Player_DockToTrade") .. ReadText(1001, 7858), helpOverlayID = "interactmenu_docktotrade", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonPlayerDockToTrade(false) end, orderid = "Player_DockToTrade" })	-- Dock to trade
		end
	elseif actiontype == "proceedwithorders" then
		if istobedisplayed and isplayerownedtarget then
			local iswaitingforsignal = false
			local numorders = C.GetNumOrders(menu.componentSlot.component)
			if numorders > 0 then
				local orderparams = GetOrderParams(ConvertStringTo64Bit(tostring(menu.componentSlot.component)), 1)
				for i, param in ipairs(orderparams) do
					if param.name == "releasesignal" and type(param.value) == "table" and param.value[1] == "playerownedship_proceed" then
						iswaitingforsignal = true
						break
					end
				end
			end

			local infotext = ""
			if iswaitingforsignal then
				if menu.numwaitingforsignal == 0 then
					-- only the currently targeted ship is affected, show nothing
					infotext = ""
				else
					-- target ship and selected ships
					infotext = " " .. ColorText["text_negative"] .. "(" .. menu.texts.targetShortName .. " + " .. ((menu.numwaitingforsignal == 1) and ReadText(1001, 7851) or string.format(ReadText(1001, 7801), menu.numwaitingforsignal)) .. ")"
				end
			elseif menu.numwaitingforsignal > 0 then
				infotext = " " .. ColorText["text_positive"] .. "(" .. ((menu.numwaitingforsignal == 1) and ReadText(1001, 7851) or string.format(ReadText(1001, 7801), menu.numwaitingforsignal)) .. ")"
			end
			if iswaitingforsignal or (menu.numwaitingforsignal > 0) then
				menu.insertInteractionContent(((not menu.showPlayerInteractions) and (#menu.selectedplayerships > 0) and (menu.numremovableorders > 0)) and "selected_orders" or "main_orders", { type = actiontype, text = ReadText(1002, 2033) .. infotext, helpOverlayID = "interactmenu_proceedwithorders", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = menu.buttonProceedWithOrders, hidetarget = true })
			end
		end
	elseif actiontype == "protectstation" then
		if #menu.selectedplayerships > 0 and isplayerownedtarget and menu.possibleorders["ProtectStation"] then
			menu.insertInteractionContent("selected_orders", { type = actiontype, text = menu.orderIconText("ProtectStation") .. ReadText(1001, 7989), helpOverlayID = "interactmenu_protectstation", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonProtect(false) end, orderid = "ProtectStation" })
		end
	elseif actiontype == "putintostorage" then
		local isdocked = GetComponentData(convertedComponent, "isdocked")
		if istobedisplayed and isdocked then
			local container = C.GetContextByClass(menu.componentSlot.component, "container", false)
			if container ~= 0 then
				-- check if the ship is at a venture dock
				local isatventuredock = false
				local parentdockingbay = C.GetContextByClass(menu.componentSlot.component, "dockarea", false)
				local ventureplatforms = {}
				Helper.ffiVLA(ventureplatforms, "UniverseID", C.GetNumVenturePlatforms, C.GetVenturePlatforms, container)
				for _, platform in ipairs(ventureplatforms) do
					local docks = {}
					Helper.ffiVLA(docks, "UniverseID", C.GetNumVenturePlatformDocks, C.GetVenturePlatformDocks, platform)
					for _, dock in ipairs(docks) do
						if dock == parentdockingbay then
							isatventuredock = true
							break
						end
					end
					if isatventuredock then
						break
					end
				end
				if not isatventuredock then
					local text = ReadText(1001, 11107)
					local active = true
					local mouseovertext = ""
					if not C.IsShipAtExternalDock(menu.componentSlot.component) then
						text = ReadText(1001, 7890)
						if C.IsShipBeingRetrieved(menu.componentSlot.component) then
							active = false
							mouseovertext = ReadText(1026, 7858)
						end
					elseif not C.HasContainerFreeInternalShipStorage(container, menu.componentSlot.component) then
						active = false
						mouseovertext = ReadText(1026, 7849)
					elseif not C.CanPutShipIntoStorage(container, menu.componentSlot.component) then
						active = false
						mouseovertext = ReadText(1026, 7850)
					end

					menu.insertInteractionContent("interaction", { type = actiontype, text = text, script = function () return menu.buttonPutIntoStorage(container, menu.componentSlot.component) end, active = active, mouseOverText = mouseovertext })
				end
			end
		end
	elseif actiontype == "recallsubs" then
		if istobedisplayed and C.IsComponentClass(menu.componentSlot.component, "controllable") then
			local subordinates = GetSubordinates(convertedComponent)
			if #subordinates > 0 then
				menu.insertInteractionContent("main_orders", { type = actiontype, text = ReadText(1001, 7830), helpOverlayID = "interactmenu_recallsubs", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonRecallSubordinates(menu.componentSlot.component, subordinates) end })
			end
		end
	elseif actiontype == "removeallorders" then
		if istobedisplayed and (not GetComponentData(convertedComponent, "isdeployable")) and not C.IsUnit(convertedComponent) then
			local hasremoveableorders = false
			local hasdockandwaitorder = false
			local numorders = C.GetNumOrders(menu.componentSlot.component)
			local currentorders = ffi.new("Order[?]", numorders)
			numorders = C.GetOrders(currentorders, numorders, menu.componentSlot.component)
			for i = numorders, 1, -1 do
				local isdocked, isdocking = GetComponentData(convertedComponent, "isdocked", "isdocking")
				if (i == 1) and ((ffi.string(currentorders[0].orderdef) == "DockAndWait") and (isdocked or isdocking)) then
					-- do nothing - removing the dock order would create an undock order ... rather have the ship stay put [Nick]
					hasdockandwaitorder = true
				else
					if C.RemoveOrder(menu.componentSlot.component, i, false, true) then
						hasremoveableorders = true
						break
					end
				end
			end

			local buf = ffi.new("Order")
			if C.GetDefaultOrder(buf, menu.componentSlot.component) and (numorders == 1) and hasdockandwaitorder then
				local mouseovertext = ReadText(1026, 7841)
				menu.insertInteractionContent(((not menu.showPlayerInteractions) and (#menu.selectedplayerships > 0)) and "selected_orders_all" or "main_orders", { type = actiontype, text = ReadText(1001, 11117), helpOverlayID = "interactmenu_resumeduties", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonRemoveAllOrders(false, false, true) end, active = active, mouseOverText = mouseovertext, hidetarget = true })
			else
				local active = hasremoveableorders or (menu.numremovableorders > 0)
				local mouseovertext = active and ReadText(1026, 7841) or ReadText(1026, 7833)
				menu.insertInteractionContent(((not menu.showPlayerInteractions) and (#menu.selectedplayerships > 0)) and "selected_orders_all" or "main_orders", { type = actiontype, text = ReadText(1001, 7832), helpOverlayID = "interactmenu_removeallorders", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonRemoveAllOrders(false, false) end, active = active, mouseOverText = mouseovertext, hidetarget = true })
			end
		end
	elseif actiontype == "removeallordersandwait" then
		if istobedisplayed and IsComponentOperational(convertedComponent) and (not GetComponentData(convertedComponent, "isdeployable")) and not C.IsUnit(convertedComponent) then
			local hasremoveableorders = false
			local numorders = C.GetNumOrders(menu.componentSlot.component)
			local currentorders = ffi.new("Order[?]", numorders)
			numorders = C.GetOrders(currentorders, numorders, menu.componentSlot.component)
			for i = numorders, 1, -1 do
				local isdocked, isdocking = GetComponentData(convertedComponent, "isdocked", "isdocking")
				if (i == 1) and ((ffi.string(currentorders[0].orderdef) == "DockAndWait") and (isdocked or isdocking)) then
					-- do nothing - removing the dock order would create an undock order ... rather have the ship stay put [Nick]
				else
					if C.RemoveOrder(menu.componentSlot.component, i, false, true) then
						hasremoveableorders = true
						break
					end
				end
			end
			local currentdefaultorder = ffi.new("Order")
			if C.GetDefaultOrder(currentdefaultorder, menu.componentSlot.component) then
				if (ffi.string(currentdefaultorder.orderdef) ~= "Wait") and (ffi.string(currentdefaultorder.orderdef) ~= "DockAndWait") then
					hasremoveableorders = true
				end
			end
			local hasloop = ffi.new("bool[1]", 0)
			C.GetOrderQueueFirstLoopIdx(menu.componentSlot.component, hasloop)
			if hasloop[0] then
				hasremoveableorders = true
			end

			local commander = ConvertIDTo64Bit(GetCommander(convertedComponent))
			if commander and (commander ~= 0) and (commander ~= ConvertStringTo64Bit(tostring(C.GetPlayerOccupiedShipID()))) then
				hasremoveableorders = true
			end

			local numremovableorders = math.max(menu.numremovableorders, menu.numremovabledefaultorders)
			local active = hasremoveableorders or (numremovableorders > 0)
			local mouseovertext = active and ReadText(1026, 7834) or ReadText(1026, 7835)
			menu.insertInteractionContent(((not menu.showPlayerInteractions) and (#menu.selectedplayerships > 0)) and "selected_orders_all" or "main_orders", { type = actiontype, text = ReadText(1001, 7889), helpOverlayID = "interactmenu_removeallordersandwait", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonRemoveAllOrders(true, true) end, active = active, hidetarget = true, mouseOverText = mouseovertext })
		end
	elseif actiontype == "rename" then
		if istobedisplayed then
			menu.insertInteractionContent("interaction", { type = actiontype, text = ReadText(1001, 1114), script = function () return menu.buttonRename(false) end })
		end
	elseif actiontype == "rescueinrange" then
		if menu.offsetcomponent and (menu.offsetcomponent ~= 0) then
			if #menu.selectedplayerships > 0 and menu.possibleorders["RescueInRange"] then
				local active = (C.GetFreePeopleCapacity(menu.selectedplayerships[1]) > 0)
				local mouseovertext = active and "" or ReadText(1026, 7864)
				menu.insertInteractionContent("selected_orders", { type = actiontype, text = menu.orderIconText("RescueInRange") .. ReadText(1041, 901), helpOverlayID = "interactmenu_rescueinrange", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonRescueInRange(false) end, hidetarget = true, orderid = "RescueInRange", active = active, mouseOverText = mouseovertext } )
			end
		end
	elseif actiontype == "rescueship" then
		if #menu.selectedplayerships > 0 and menu.possibleorders["RescueShip"] and GetComponentData(convertedComponent, "isreallyplayerowned") then
			local active = (C.GetFreePeopleCapacity(menu.selectedplayerships[1]) > 0)
			local mouseovertext = active and "" or ReadText(1026, 7864)
			menu.insertInteractionContent("selected_orders", { type = actiontype, text = menu.orderIconText("RescueShip") .. ReadText(1041, 891), helpOverlayID = "interactmenu_rescueship", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonRescueShip(false) end, orderid = "RescueShip", active = active, mouseOverText = mouseovertext })
		end
	elseif actiontype == "salvagecollect" then
		if (#menu.selectedplayerships > 0) and menu.possibleorders["SalvageCollect"] and C.CanBeTowed(menu.componentSlot.component) then
			menu.insertInteractionContent("selected_orders", { type = actiontype, text = menu.orderIconText("SalvageCollect") .. ReadText(1041, 801), helpOverlayID = "interactmenu_salvagecollect", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonSalvageCollect(false) end, orderid = "SalvageCollect" })
		end
	elseif actiontype == "salvagecrush" then
		if (#menu.selectedplayerships > 0) and menu.possibleorders["SalvageCrush"] and C.CanBeDismantled(menu.componentSlot.component) then
			menu.insertInteractionContent("selected_orders", { type = actiontype, text = menu.orderIconText("SalvageCrush") .. ReadText(1041, 831), helpOverlayID = "interactmenu_salvagecrush", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonSalvageCrush(false) end, orderid = "SalvageCrush" })
		end
	elseif actiontype == "salvagedeliver" then
		if (menu.possibleorders["SalvageDeliver"] or menu.possibleorders["SalvageDeliver_NoTrade"]) and C.HasContainerProcessingModule(menu.componentSlot.component) and (not GetComponentData(convertedComponent, "isenemy")) then
			local hastowingship = false
			local ware
			local hasloop = ffi.new("bool[1]", 0)
			for _, ship in ipairs(menu.selectedplayerships) do
				if (GetComponentData(ship, "shiptype") == "tug") then
					C.GetOrderQueueFirstLoopIdx(ship, hasloop)
					if hasloop[0] then
						break
					end
				end
				local towedobject = C.GetTowedObject(ship)
				if towedobject ~= 0 then
					local recyclingwares = GetComponentData(ConvertStringTo64Bit(tostring(towedobject)), "recyclingwares")
					if #recyclingwares > 0 then
						hastowingship = true
						ware = recyclingwares[1].ware
						break
					end
				end
			end

			if hastowingship or hasloop[0] then
				local active = true
				if hasloop[0] then
					menu.insertInteractionContent("selected_orders", { type = actiontype, text = menu.orderIconText("SalvageDeliver_NoTrade") .. ReadText(1041, 811), helpOverlayID = "interactmenu_salvagedeliver", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonSalvageDeliver_NoTrade(false) end, active = active, orderid = "SalvageDeliver_NoTrade" })
				else
					local tradeoffers = GetTradesForWare(convertedComponent, ware, true)
					if #tradeoffers == 0 then
						active = false
						mouseovertext = ReadText(1001, 2973)
					end
					menu.insertInteractionContent("selected_orders", { type = actiontype, text = menu.orderIconText("SalvageDeliver") .. ReadText(1041, 811), helpOverlayID = "interactmenu_salvagedeliver", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonSalvageDeliver(false, ware, tradeoffers[1]) end, orderid = "SalvageDeliver", active = active, mouseOverText = mouseovertext })
				end
			end
		end
	elseif (actiontype == "selfdestruct") then
		if GetComponentData(convertedComponent, "isdeployable") then
			local selecteddeployable = convertedComponent
			if #menu.selectedplayerdeployables > 0 then
				selecteddeployable = nil
			end
			menu.insertInteractionContent("main", { type = actiontype, text = ReadText(1001, 11127), script = function () return menu.buttonSelfDestructDeployables(selecteddeployable) end })
		end
	elseif actiontype == "sellships" then
		if #menu.selectedplayerships > 0 then
			if not isplayerownedtarget then
				local shiptrader, isdock, iswharf, isshipyard, owner = GetComponentData(convertedComponent, "shiptrader", "isdock", "iswharf", "isshipyard", "owner")
				local doesbuyshipsfromplayer = GetFactionData(owner, "doesbuyshipsfromplayer")
				if shiptrader and isdock and (iswharf or isshipyard) and doesbuyshipsfromplayer then
					local cansell = false
					for _, ship in ipairs(menu.selectedplayerships) do
						if C.CanContainerBuildShip(menu.componentSlot.component, ship) and GetComponentData(ship, "issellable") then
							cansell = true
							break
						end
					end
					if cansell then
						menu.insertInteractionContent("selected_orders", { type = actiontype, text = (#menu.selectedplayerships == 1) and ReadText(1001, 7855) or ReadText(1001, 7856), helpOverlayID = "interactmenu_sellships", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = menu.buttonSellShips })
					end
				end
			end
		end
	elseif actiontype == "showupkeep" then
		if istobedisplayed then
			local found = false
			local numMissions = GetNumMissions()
			for i = 1, numMissions do
				local missionID, name, description, difficulty, threadtype, maintype, subtype, subtypename, faction, reward, rewardtext, _, _, _, _, _, missiontime, _, abortable, disableguidance, associatedcomponent, alertLevel = GetMissionDetails(i)

				if maintype == "upkeep" then
					if associatedcomponent then
						local rawcontainer = C.GetContextByRealClass(ConvertIDTo64Bit(associatedcomponent), "container", true)
						if rawcontainer ~= 0 then
							local container = ConvertStringTo64Bit(tostring(rawcontainer))
							if container == menu.componentSlot.component then
								found = true
								break
							end
						end
					end
				end
			end

			if found then
				menu.insertInteractionContent("main", { type = actiontype, text = ReadText(1001, 11123), script = menu.buttonShowUpkeepMissions })
			end
		end
	elseif actiontype == "singletrade" then
		if (#menu.selectedplayerships > 0) and (menu.numorderloops > 0) then
			local owner = GetComponentData(convertedComponent, "owner")
			local hastradeoffers = GetFactionData(owner, "hastradeoffers")

			local active = true
			local mouseOverText = ""
			if not hastradeoffers then
				active = false
				mouseOverText = ReadText(1026, 7866)
			elseif not menu.hasPlayerShipPilot then
				active = false
				mouseOverText = ReadText(1026, 7830)
			end

			local hasbuy, hassell
			local tradeoffers = GetTradeList(convertedComponent, menu.selectedplayerships[1], false)
			for _, tradedata in pairs(tradeoffers) do
				if tradedata.isselloffer then
					hassell = true
				end
				if tradedata.isbuyoffer then
					hasbuy = true
				end
				if hassell and hasbuy then
					break
				end
			end
			if hassell then
				menu.insertInteractionContent("trade_orders", { text = menu.orderIconText("SingleBuy")  .. ReadText(1001, 11112), script = function () return menu.buttonTrade(false, nil, "SingleBuy") end,  active = active, mouseOverText = mouseovertext })
			end
			if hasbuy then
				menu.insertInteractionContent("trade_orders", { text = menu.orderIconText("SingleSell") .. ReadText(1001, 11113), script = function () return menu.buttonTrade(false, nil, "SingleSell") end, active = active, mouseOverText = mouseovertext })
			end
		end
	elseif actiontype == "stopandholdfire" then
		if istargetinplayersquad or istargetplayeroccupiedship then
			menu.insertInteractionContent("playersquad_orders", { type = actiontype, text = ReadText(1001, 7870), helpOverlayID = "interactmenu_stopandholdfire", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonPlayerSquadStopAndHoldFire(true) end, hidetarget = true })	-- Fleet: Stop and hold fire
		end
	elseif actiontype == "tacticalattack" then
		if (#menu.selectedplayerships > 0) and menu.possibleorders["TacticalOrder"] and (not isplayerownedtarget) and C.IsComponentClass(menu.componentSlot.component, "destructible") then
			local fleetcommanders = {}
			for _, ship in ipairs(menu.selectedplayerships) do
				local commander = ConvertIDTo64Bit(GetCommander(ship))
				local subordinates = GetSubordinates(ship)
				if (not commander) and (#subordinates > 0) then
					table.insert(fleetcommanders, ship)
				end
			end
			if #fleetcommanders > 0 then
				menu.insertInteractionContent("selected_orders", { type = actiontype, text = menu.orderIconText("TacticalOrder") .. ReadText(1041, 731), helpOverlayID = "interactmenu_tacticalattack", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonTacticalAttack(fleetcommanders, false) end, orderid = "TacticalOrder" })
			end
		end
	elseif actiontype == "targetview" then
		if menu.mode ~= "shipconsole" then
			local playersector = C.GetContextByClass(C.GetPlayerID(), "sector", false)
			local target = 0
			if C.IsComponentClass(menu.componentSlot.component, "highway") then
				local issuperhighway, entrygate = GetComponentData(convertedComponent, "issuperhighway", "entrygate")
				if issuperhighway then
					target = ConvertIDTo64Bit(entrygate)
				else
					target = menu.componentSlot.component
				end
			else
				target = menu.componentSlot.component
			end
			local targetsector = C.GetContextByClass(target, "sector", false)
			local active = true
			local mouseovertext = Helper.getInputMouseOverText("INPUT_ACTION_TARGET_VIEW")
			if GetComponentData(convertedComponent, "isdockedinternally") then
				active = false
				mouseovertext = ReadText(1026, 7811)
			elseif C.IsExternalViewDisabled() then
				active = false
				mouseovertext = ReadText(1026, 7812)
			elseif (not C.IsPlayerCameraTargetViewPossible(target, true)) or (playersector ~= targetsector) then
				active = false
				mouseovertext = ReadText(1026, 7809)
			elseif target == C.GetPlayerControlledShipID() then
				active = false
				mouseovertext = ReadText(1026, 7810)
			end
			menu.insertInteractionContent("interaction", { type = actiontype, text = ReadText(1001, 7807), script = menu.buttonExternal, active = active, mouseOverText = mouseovertext })
		end
	elseif actiontype == "teleport" then
		local isally, isdeployable = GetComponentData(convertedComponent, "isally", "isdeployable")
		if (isplayerownedtarget or (C.IsComponentClass(menu.componentSlot.component, "station") and isally)) and (not isdeployable) and (not C.IsUnit(menu.componentSlot.component)) then
			if menu.componentSlot.component ~= ConvertStringTo64Bit(tostring(C.GetPlayerOccupiedShipID())) then
				local active = false
				local mouseovertext = Helper.getInputMouseOverText("INPUT_ACTION_TELEPORT_ACTION")
				local teleportrequest = ffi.string(C.CanTeleportPlayerTo(menu.componentSlot.component, false, (menu.mode == "shipconsole") and isplayerownedtarget))
				if teleportrequest == "granted" then
					active = true
				elseif teleportrequest == "instorage" then
					mouseovertext = ReadText(1026, 7811)
				elseif teleportrequest == "malfunction" then
					mouseovertext = ReadText(1026, 7812)
				elseif teleportrequest == "research" then
					mouseovertext = ReadText(1026, 7813)
				elseif teleportrequest == "range" then
					mouseovertext = ReadText(1026, 7814)
				elseif teleportrequest == "size" then
					mouseovertext = ReadText(1026, 7815)
				elseif teleportrequest == "slot" then
					mouseovertext = ReadText(1026, 7816)
				end
				menu.insertInteractionContent("interaction", { type = actiontype, text = (menu.mode == "shipconsole") and ReadText(1001, 7854) or ReadText(1001, 7808), helpOverlayID = "interactmenu_teleport", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = menu.buttonTeleport, active = active, mouseOverText = mouseovertext })
			end
		end
	elseif actiontype == "travelmode" then
		if istobedisplayed then
			local active = true
			local mouseovertext = ""
			if not C.CanStartTravelMode(menu.componentSlot.component) then
				active = false
				mouseovertext = ReadText(1026, 7855)
			end
			local currentactivity = GetPlayerActivity()

			menu.insertInteractionContent("interaction", { type = actiontype, text = (currentactivity == "travel") and ReadText(1001, 11116) or ReadText(1001, 11115), script = function () return menu.buttonTravelMode(currentactivity ~= "travel") end })
		end
	elseif actiontype == "upgrade" then
		local shiptrader, isdock, issupplyship, owner = GetComponentData(convertedComponent, "shiptrader", "isdock", "issupplyship", "owner")
		local doessellshipstoplayer = GetFactionData(owner, "doessellshipstoplayer")
		if (#menu.selectedplayerships > 0) and menu.possibleorders["Repair"] and isdock and (C.IsComponentClass(menu.componentSlot.component, "station") or issupplyship) and (menu.numorderloops == 0) then
			local active = false
			local haspilot = false
			for _, ship in ipairs(menu.selectedplayerships) do
				local pilot = GetComponentData(ship, "assignedpilot")
				if pilot then
					haspilot = true
					if C.CanContainerEquipShip(menu.componentSlot.component, ship) or (isplayerownedtarget and C.CanContainerSupplyShip(menu.componentSlot.component, ship)) then
						active = true
						break
					end
				end
			end
			-- don't show option for npcs if they are missing the shiptrader, but do for player objects
			if (C.IsComponentClass(menu.componentSlot.component, "station") and shiptrader) or isplayerownedtarget then
				local mouseovertext
				if not doessellshipstoplayer then
					active = false
					mouseovertext = ReadText(1026, 7865)
				elseif not shiptrader then
					active = false
					mouseovertext = ReadText(1026, 7827)
				elseif not haspilot then
					-- no one has a pilot, show that
					mouseovertext = ReadText(1026, 7830)
				elseif (not active) and (#menu.selectedplayerships > 0) then
					-- if the option is inactive, all ships are either capships or not, so only check the first one
					if C.IsComponentClass(menu.selectedplayerships[1], "ship_l") or C.IsComponentClass(menu.selectedplayerships[1], "ship_xl") then
						mouseovertext = issupplyship and ReadText(1026, 7828) or ReadText(1026, 7805)
					else
						mouseovertext = ReadText(1026, 7804)
					end
				end
				menu.insertInteractionContent("selected_orders", { type = actiontype, text = menu.orderIconText("Repair") .. (issupplyship and ReadText(1001, 7876) or ReadText(1001, 7826)), helpOverlayID = "interactmenu_upgrade", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonUpgrade(true) end, active = active, mouseOverText = mouseovertext, orderid = "Repair" })
			end
		end
	elseif actiontype == "upgradeships" then
		local shiptrader, isdock, issupplyship, owner = GetComponentData(convertedComponent, "shiptrader", "isdock", "issupplyship", "owner")
		local doessellshipstoplayer = GetFactionData(owner, "doessellshipstoplayer")
		local dockedships = {}
		if C.IsComponentClass(menu.componentSlot.component, "container") then
			Helper.ffiVLA(dockedships, "UniverseID", C.GetNumDockedShips, C.GetDockedShips, menu.componentSlot.component, "player")
		end

		-- start: aegs call-back
		if callbacks ["map_rightMenu_shipBuilding_insert"] then
			local state,activate_o,text_o,mouseovertext_o
			for _, callback in ipairs (callbacks ["map_rightMenu_shipBuilding_insert"]) do
				state,activate_o,text_o,mouseovertext_o = callback (shiptrader,isdock,GetComponentData(convertedComponent, "macro"),doessellshipstoplayer,isplayerownedtarget)
				if state then
					menu.insertInteractionContent("main", { type = actiontype, text = text_o, helpOverlayID = "interactmenu_buildship", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonShipConfig("purchase") end, active = activate_o, mouseOverText = mouseovertext_o })
				end
			end
		end
		-- end: aegs call-back

		if isdock and (C.IsComponentClass(menu.componentSlot.component, "station") or issupplyship) then
			local active = false
			for _, ship in ipairs(dockedships) do
				if C.CanContainerEquipShip(menu.componentSlot.component, ship) or (isplayerownedtarget and C.CanContainerSupplyShip(menu.componentSlot.component, ship)) then
					active = true
					break
				end
			end
			-- don't show option for npcs if they are missing the shiptrader, but do for player objects
			if (C.IsComponentClass(menu.componentSlot.component, "station") and shiptrader) or isplayerownedtarget then
				local mouseovertext
				if not doessellshipstoplayer then
					active = false
					mouseovertext = ReadText(1026, 7865)
				elseif not shiptrader then
					active = false
					mouseovertext = ReadText(1026, 7827)
				elseif not active then
					if #dockedships > 0 then
						-- if the option is inactive, all ships are either capships or not, so only check the first one
						if C.IsComponentClass(dockedships[1], "ship_l") or C.IsComponentClass(dockedships[1], "ship_xl") then
							mouseovertext = ReadText(1026, 7807)
						else
							mouseovertext = ReadText(1026, 7806)
						end
					else
						mouseovertext = ReadText(1026, 7808)
					end
				end
				menu.insertInteractionContent("main", { type = actiontype, text = issupplyship and ReadText(1001, 7877) or ReadText(1001, 7841), helpOverlayID = "interactmenu_upgradeships", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonShipConfig("upgrade") end, active = active, mouseOverText = mouseovertext })
			end
		end
	elseif actiontype == "venturedockat" then
		if menu.possibleorders["DockAndWait"] and GetComponentData(convertedComponent, "isdock") then
			local ventureplatforms = {}
			Helper.ffiVLA(ventureplatforms, "UniverseID", C.GetNumVenturePlatforms, C.GetVenturePlatforms, menu.componentSlot.component)
			for _, platform in ipairs(ventureplatforms) do
				local currentdockareas = {}
				local hasdock = false
				local notdocked = false
				for i = #menu.selectedplayerships, 1, -1 do
					local ship = menu.selectedplayerships[i]
					if C.IsComponentClass(menu.componentSlot.component, "container") then
						local parentdockingbay = C.GetContextByClass(ship, "dockarea", false)
						if parentdockingbay ~= 0 then
							table.insert(currentdockareas, parentdockingbay)
						else
							notdocked = true
						end
						if C.HasVenturerDock(menu.componentSlot.component, ship, platform) then
							hasdock = true
						end
					end
				end
				if hasdock then
					local docks = {}
					local dockindex = {}
					Helper.ffiVLA(docks, "UniverseID", C.GetNumVenturePlatformDocks, C.GetVenturePlatformDocks, platform)
					local counts = {
						["XL_L"] = 0,
						["M_S"] = 0,
					}
					for _, dock in ipairs(docks) do
						dockindex[tostring(dock)] = true
						local docksizes = GetComponentData(ConvertStringTo64Bit(tostring(dock)), "docksizes")
						-- docksizes always return the biggest possible size of a dockingbay contained in the dockarea
						counts["XL_L"] = counts["XL_L"] + (docksizes.docks_xl or 0) + (docksizes.docks_l or 0)
						counts["M_S"]  = counts["M_S"]  + (docksizes.docks_m or 0)  + (docksizes.docks_s or 0)
					end
					local dockstring = ""
					if counts["XL_L"] > 0 then
						if dockstring ~= "" then
							dockstring = dockstring .. " "
						end
						dockstring = dockstring .. "[" .. counts["XL_L"] .. ReadText(1001, 42) .. " " .. ReadText(1001, 7863) .. "]"
					end
					if counts["M_S"] > 0 then
						if dockstring ~= "" then
							dockstring = dockstring .. " "
						end
						dockstring = dockstring .. "[" .. counts["M_S"] .. ReadText(1001, 42) .. " " .. ReadText(1001, 7864) .. "]"
					end

					local isalreadydocked = true
					if notdocked then
						-- some ship is not docked at all
						isalreadydocked = false
					else
						for _, dockarea in ipairs(currentdockareas) do
							if not dockindex[tostring(dockarea)] then
								-- some ship is not docked at this platform
								isalreadydocked = false
								break
							end
						end
					end
					local active = not isalreadydocked
					local mouseovertext = ""
					if isalreadydocked then
						mouseovertext = ReadText(1026, 7846)
					end

					menu.insertInteractionContent("venturedock", { type = actiontype, text = ffi.string(C.GetComponentName(platform)), text2 = dockstring, helpOverlayID = "interactmenu_ventureatdock", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonDock(false, platform) end, active = active, mouseOverText = mouseovertext, orderid = "DockAndWait" })
				end
			end
		end
	elseif actiontype == "venturepatron" then
		menu.insertInteractionContent("main", { type = actiontype, text = ReadText(1001, 11802), script = menu.buttonVenturePatron })
	elseif actiontype == "venturereportname" then
		menu.insertInteractionContent("venturereport", { type = actiontype, text = ReadText(1001, 12114), script = menu.buttonVentureReportShip })
	elseif actiontype == "venturereportusername" then
		menu.insertInteractionContent("venturereport", { type = actiontype, text = ReadText(1001, 12111), script = menu.buttonVentureReportUser })
	elseif actiontype == "wareexchange" then
		if (#menu.selectedplayerships > 0) and isplayerownedtarget and (not GetComponentData(convertedComponent, "isdeployable")) and (not C.IsUnit(convertedComponent)) and (menu.numorderloops == 0) then
			local hasrealship = false
			for _, ship in ipairs(menu.selectedplayerships) do
				if (not GetComponentData(ship, "isdeployable")) and (not C.IsComponentClass(ship, "spacesuit")) then
					hasrealship = true
					break
				end
			end
			if hasrealship then
				local active = menu.showPlayerInteractions or menu.hasPlayerShipPilot
				local mouseovertext = (not active) and ReadText(1026, 7830) or ""
				if menu.showPlayerInteractions then
					local occupiedship = C.GetPlayerOccupiedShipID()
					if C.GetCommonContext(occupiedship, menu.componentSlot.component, true, true, C.GetContextByClass(occupiedship, "zone", false), false) == 0 then
						active = false
						mouseovertext = ReadText(1026, 7856)
					elseif not GetComponentData(convertedComponent, "assignedaipilot") then
						active = false
						mouseovertext = ReadText(1026, 7830)
					end
				end

				if C.IsComponentClass(menu.componentSlot.component, "container") then
					menu.insertInteractionContent(menu.showPlayerInteractions and "player_interaction" or "trade_orders", { type = actiontype, text = menu.orderIconText("TradeExchange") .. ReadText(1001, 7820), script = function () return menu.buttonTrade(true) end, active = active, mouseOverText = mouseovertext })
				end
				if menu.buildstorage then
					menu.insertInteractionContent(menu.showPlayerInteractions and "player_interaction" or "trade_orders", { type = actiontype, text = menu.orderIconText("TradeExchange") .. ReadText(1001, 7820), script = function () return menu.buttonTrade(true, menu.buildstorage) end, buildstorage = true, active = active, mouseOverText = mouseovertext })
				end
			end
		end
	elseif actiontype == "withdrawandhold" then
		if istargetinplayersquad or istargetplayeroccupiedship then
			menu.insertInteractionContent("playersquad_orders", { type = actiontype, text = ReadText(1001, 7871), script = function () return menu.buttonPlayerSquadWithdrawAndHold(true) end, hidetarget = true })	-- Fleet: Withdraw and hold
		end
	elseif actiontype == "withdrawfromcombat" then
		if istargetinplayersquad or istargetplayeroccupiedship then
			menu.insertInteractionContent("playersquad_orders", { type = actiontype, text = ReadText(1001, 7872), script = function () return menu.buttonPlayerSquadWithdrawFromCombat(true) end, hidetarget = true })	-- Fleet: Withdraw from combat
		end
	elseif actiontype == "cheat_satellite" then
		if menu.offsetcomponent and (menu.offsetcomponent ~= 0) then
			menu.insertInteractionContent("cheats", { type = actiontype, text = "Place satellite", script = menu.buttonSatelliteCheat }) -- (cheat only)
		end
	elseif actiontype == "cheat_navbeacon" then
		if menu.offsetcomponent and (menu.offsetcomponent ~= 0) then
			menu.insertInteractionContent("cheats", { type = actiontype, text = "Place nav beacon", script = menu.buttonNavBeaconCheat }) -- (cheat only)
		end
	elseif actiontype == "cheat_resourceprobe" then
		if menu.offsetcomponent and (menu.offsetcomponent ~= 0) then
			menu.insertInteractionContent("cheats", { type = actiontype, text = "Place resource probe", script = menu.buttonResourceProbeCheat }) -- (cheat only)
		end
	elseif actiontype == "cheat_takeownership" then
		if not isplayerownedtarget then
			menu.insertInteractionContent("cheats", { type = actiontype, text = "Take ownership", script = menu.buttonOwnerCheat }) -- (cheat only)
		end
	elseif actiontype == "cheat_warp" then
		if menu.offsetcomponent and (menu.offsetcomponent ~= 0) then
			menu.insertInteractionContent("cheats", { type = actiontype, text = "Warp here", script = menu.buttonWarpCheat }) -- (cheat only)
		end
	else
		DebugError("Unknown LuaAction type '" .. actiontype .. "'! [Florian]")
	end
end

function menu.prepareData()
	menu.data = {}
	menu.data.convertedComponent = ConvertStringTo64Bit(tostring(menu.componentSlot.component))
	menu.data.istargetinplayersquad = false
	menu.data.istargetplayeroccupiedship = false
	menu.data.hastargetpilot = false
	if (menu.data.convertedComponent ~= 0) then
		menu.data.isplayerownedtarget = GetComponentData(menu.data.convertedComponent, "isplayerowned")
		menu.data.istargetinplayersquad = menu.playerSquad[menu.data.convertedComponent]
		--print("istargetinplayersquad: " .. tostring(menu.data.istargetinplayersquad) .. ", commander: " .. tostring(GetCommander(menu.data.convertedComponent)) .. ", occupiedship: " .. ConvertStringTo64Bit(tostring(C.GetPlayerOccupiedShipID())))

		menu.data.istargetplayeroccupiedship = (ConvertStringTo64Bit(tostring(C.GetPlayerOccupiedShipID())) == menu.data.convertedComponent)
		--print("istargetplayeroccupiedship: " .. tostring(menu.data.istargetplayeroccupiedship) .. ", occupiedship: " .. ConvertStringTo64Bit(tostring(C.GetPlayerOccupiedShipID())) .. ", convertedComponent: " .. tostring(menu.data.convertedComponent))

		menu.data.hastargetpilot = GetComponentData(menu.data.convertedComponent, "assignedpilot") ~= nil

		if C.IsComponentClass(menu.componentSlot.component, "controllable") then
			local hasloop = ffi.new("bool[1]", 0)
			C.GetOrderQueueFirstLoopIdx(menu.componentSlot.component, hasloop)
			menu.data.hastargetorderloop = hasloop[0]
		end
	end
end

function menu.prepareActions()
	menu.checkPlayerActivity = nil
	menu.forceSubSection = {}
	menu.prepareSections()

	menu.prepareData()
	local convertedComponent = menu.data.convertedComponent

	local hasanydisplayed = false
	-- player actions
	if (not menu.componentOrder) and (not menu.syncpoint) and (not menu.syncpointorder) and (not menu.intersectordefencegroup) and (not menu.construction) and (not menu.mission) and (not menu.missionoffer) and (not menu.subordinategroup) and (menu.mode ~= "shipconsole" or (menu.isdockedship)) then
		local isknown = C.IsObjectKnown(menu.componentSlot.component)
		local n = C.GetNumCompSlotPlayerActions(menu.componentSlot)
		if n == 0 then
			return false
		end
		local buf = ffi.new("UIAction[?]", n)
		n = C.GetCompSlotPlayerActions(buf, n, menu.componentSlot)
		for i = 0, n - 1 do
			local entry = {}
			entry.id = buf[i].id
			entry.text = ffi.string(buf[i].text)
			entry.active = buf[i].ispossible
			local actiontype = ffi.string(buf[i].type)
			if (not menu.shown) and (actiontype == "containertrade") then
				entry.script = function () return menu.buttonTrade(false) end
			elseif (not menu.shown) and (actiontype == "info") then
				entry.script = menu.buttonInfo
				entry.helpOverlayID = "interactmenu_info"
				entry.helpOverlayText = " "
				entry.helpOverlayHighlightOnly = true
			elseif (not menu.shown) and (actiontype == "comm") then
				entry.script = menu.buttonComm
			else
				entry.script = function () return menu.buttonPerformPlayerAction(entry.id, actiontype) end
			end

			local istobedisplayed = buf[i].istobedisplayed
			hasanydisplayed = hasanydisplayed or istobedisplayed

			local basetype, luatype = string.match(actiontype, "(.+);(.+)")
			if isknown or (actiontype == "info") or (luatype == "guidance") then
				if basetype == "lua" then
					menu.insertLuaAction(luatype, istobedisplayed)
				elseif istobedisplayed then
					if actiontype == "containertrade" then
						local owner = GetComponentData(convertedComponent, "owner")
						local hastradeoffers = GetFactionData(owner, "hastradeoffers")
						if not hastradeoffers then
							entry.active = false
							entry.mouseOverText = ReadText(1026, 7866)
						end
						if (not menu.showPlayerInteractions) and (#menu.selectedplayerships > 0) then
							if menu.numshipsexcludingspacesuits > 0 then
								if C.IsComponentClass(menu.componentSlot.component, "container") then
									entry.active = entry.active and menu.hasPlayerShipPilot
									entry.mouseOverText = (not menu.hasPlayerShipPilot) and ReadText(1026, 7830) or ""
									if menu.numorderloops == 0 then
										entry.text = menu.orderIconText("TradePerform") .. entry.text
										entry.helpOverlayID = "interactmenu_trade"
										entry.helpOverlayText = " "
										entry.helpOverlayHighlightOnly = true
										menu.insertInteractionContent("trade_orders", entry)
									else
										local hasbuy, hassell
										local tradeoffers = GetTradeList(convertedComponent, menu.selectedplayerships[1], false)
										for _, tradedata in pairs(tradeoffers) do
											if tradedata.isselloffer then
												hassell = true
											end
											if tradedata.isbuyoffer then
												hasbuy = true
											end
											if hassell and hasbuy then
												break
											end
										end
										if hassell then
											menu.insertInteractionContent("trade_orders", { text = menu.orderIconText("SingleBuy")  .. ReadText(1001, 11110), script = function () return menu.buttonTrade(false, nil, "SingleBuy") end,  active = entry.active, mouseOverText = entry.mouseOverText })
										end
										if hasbuy then
											menu.insertInteractionContent("trade_orders", { text = menu.orderIconText("SingleSell") .. ReadText(1001, 11111), script = function () return menu.buttonTrade(false, nil, "SingleSell") end, active = entry.active, mouseOverText = entry.mouseOverText })
										end
									end
								end
								if menu.buildstorage then
									if menu.numorderloops == 0 then
										menu.insertInteractionContent("trade_orders", { text = menu.orderIconText("TradePerform") .. ReadText(1001, 7819), script = function () return menu.buttonTrade(false, menu.buildstorage) end, buildstorage = true, active = entry.active and menu.hasPlayerShipPilot, mouseOverText = (entry.mouseOverText ~= "") and entry.mouseOverText or ((not menu.hasPlayerShipPilot) and ReadText(1026, 7830) or "") })
									else
										menu.insertInteractionContent("trade_orders", { text = menu.orderIconText("SingleSell") .. ReadText(1001, 11111), script = function () return menu.buttonTrade(false, menu.buildstorage, "SingleSell") end, buildstorage = true, active = entry.active, mouseOverText = entry.mouseOverText })
									end
								end
							end
						else
							entry.text = ReadText(1001, 1113)
							if C.IsComponentClass(menu.componentSlot.component, "container") then
								entry.text = menu.orderIconText("TradePerform") .. entry.text
								menu.insertInteractionContent("trade", entry)
							end
							if menu.buildstorage then
								menu.insertInteractionContent("trade", { text = menu.orderIconText("TradePerform") .. ReadText(1001, 1113), script = function () return menu.buttonTrade(false, menu.buildstorage) end, buildstorage = true, active = entry.active, mouseOverText = entry.mouseOverText })
							end
						end
					elseif actiontype == "hack" then
						if menu.showPlayerInteractions then
							menu.insertInteractionContent("player_interaction", entry)
						end
					elseif actiontype == "scan" then
						if menu.showPlayerInteractions then
							if not entry.active then
								if GetPlayerActivity() ~= "scan" then
									entry.mouseOverText = ReadText(1026, 7803)
								else
									entry.mouseOverText = ReadText(1026, 7809)
								end
							else
								entry.mouseOverText = Helper.getInputMouseOverText("INPUT_ACTION_SCAN_ACTION")
							end
							entry.helpOverlayID = "interactmenu_scan"
							entry.helpOverlayText = " "
							entry.helpOverlayHighlightOnly = true
							menu.checkPlayerActivity = true
							menu.insertInteractionContent("player_interaction", entry)
						end
					elseif (actiontype == "comm") then
						if not entry.active then
							if C.IsComponentClass(menu.componentSlot.component, "controllable") and GetControlEntity(convertedComponent) then
								entry.mouseOverText = ReadText(1026, 7802)
							else
								entry.mouseOverText = ReadText(1026, 7801)
							end
						else
							entry.mouseOverText = Helper.getInputMouseOverText("INPUT_ACTION_COMM_ACTION")
						end
						menu.insertInteractionContent("interaction", entry)
					elseif (actiontype == "detach") then
						if GetComponentData(convertedComponent, "isdeployable") and (#menu.selectedplayerdeployables > 1) then
							local isactive = GetComponentData(convertedComponent, "isactive")
							menu.insertInteractionContent("main", { text = isactive and ReadText(1001, 7883) or ReadText(1001, 7882), text2 = string.format(ReadText(1001, 7884), #menu.selectedplayerdeployables), helpOverlayID = "interactmenu_detach", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonActivateDeployables(isactive) end,  })
						else
							entry.helpOverlayID = "interactmenu_deactivatesatellite"
							entry.helpOverlayText = " "
							entry.helpOverlayHighlightOnly = true
							menu.checkPlayerActivity = true
							menu.insertInteractionContent("main", entry)
						end
					elseif (actiontype == "info") then
						entry.mouseOverText = Helper.getInputMouseOverText("INPUT_ACTION_INFO_ACTION")
						menu.insertInteractionContent("main", entry)
					elseif (actiontype == "matchspeed") then
						if not entry.active then
							entry.mouseOverText = ReadText(1026, 7802)
						else
							entry.mouseOverText = Helper.getInputMouseOverText("INPUT_STATE_MATCH_SPEED")
						end
						menu.insertInteractionContent("main", entry)
					elseif actiontype == "tow" then
						if not entry.active then
							if not C.CanBeTowed(menu.componentSlot.component) then
								entry.mouseOverText = ReadText(1026, 7859)
							else
								entry.mouseOverText = ReadText(1026, 7814)
							end
						end
						menu.insertInteractionContent("main", entry)
					elseif (actiontype == "ejectrecyclable") then
						local scrapbuffer = GetComponentData(convertedComponent, "scrapbuffer")
						entry.mouseOverText = ReadText(20201, 6801) .. ReadText(1001, 120) .. " " .. ConvertIntegerString(scrapbuffer, true, 0, true)
						menu.insertInteractionContent("main_orders", entry)
					else
						menu.insertInteractionContent("main", entry)
					end
				end
			end
		end

		for _, entries in pairs(menu.actions) do
			if #entries > 0 then
				hasanydisplayed = true
			end
		end

		if menu.componentMissions and (type(menu.componentMissions) == "table") then
			for _, missionid in ipairs(menu.componentMissions) do
				local missiondetails = C.GetMissionIDDetails(missionid)
				if ffi.string(missiondetails.mainType) ~= "guidance" then
					menu.insertInteractionContent("main", { text = ReadText(1001, 7850) .. " (" .. ffi.string(missiondetails.missionName) .. ")", script = function () return menu.buttonMissionShow(missionid) end, active = true })
				end
			end
		end
	end

	if menu.componentOrder then
		hasanydisplayed = true
		-- orders (not action based at all)
		menu.insertInteractionContent("order", { type = "removethisorder", text = ReadText(1001, 7831), helpOverlayID = "interactmenu_removethisorder", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = menu.buttonRemoveOrder, active = (menu.componentOrder.queueidx > 0) and C.RemoveOrder(menu.componentSlot.component, menu.componentOrder.queueidx, false, true), mouseOverText = (menu.componentOrder.queueidx == 0) and ReadText(1026, 7844) or "" })
		-- Remove all orders
		local hasremoveableorders = false
		local numorders = C.GetNumOrders(menu.componentSlot.component)
		local currentorders = ffi.new("Order[?]", numorders)
		numorders = C.GetOrders(currentorders, numorders, menu.componentSlot.component)
		for i = numorders, 1, -1 do
			local isdocked, isdocking = GetComponentData(convertedComponent, "isdocked", "isdocking")
			if (i == 1) and ((ffi.string(currentorders[0].orderdef) == "DockAndWait") and (isdocked or isdocking)) then
				-- do nothing - removing the dock order would create an undock order ... rather have the ship stay put [Nick]
			else
				if C.RemoveOrder(menu.componentSlot.component, i, false, true) then
					hasremoveableorders = true
					break
				end
			end
		end
		local mouseovertext = hasremoveableorders and ReadText(1026, 7841) or ReadText(1026, 7833)
		menu.insertInteractionContent("order", { type = "removeallorders", text = ReadText(1001, 7832), helpOverlayID = "interactmenu_removeallorders", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = function () return menu.buttonRemoveAllOrders(false, false) end, active = hasremoveableorders, mouseOverText = mouseovertext })

		local currentdefaultorder = ffi.new("Order")
		if C.GetDefaultOrder(currentdefaultorder, menu.componentSlot.component) then
			if (ffi.string(currentdefaultorder.orderdef) ~= "Wait") and (ffi.string(currentdefaultorder.orderdef) ~= "DockAndWait") then
				hasremoveableorders = true
			end
		end
		local hasloop = ffi.new("bool[1]", 0)
		C.GetOrderQueueFirstLoopIdx(menu.componentSlot.component, hasloop)
		if hasloop[0] then
			hasremoveableorders = true
		end

		local commander = ConvertIDTo64Bit(GetCommander(convertedComponent))
		if commander and (commander ~= 0) and (commander ~= ConvertStringTo64Bit(tostring(C.GetPlayerOccupiedShipID()))) then
			hasremoveableorders = true
		end
		mouseovertext = hasremoveableorders and ReadText(1026, 7834) or ReadText(1026, 7835)
		menu.insertInteractionContent("order", { type = "removeallordersandwait", text = ReadText(1001, 7874), script = function () return menu.buttonRemoveAllOrders(true, true) end, active = hasremoveableorders, mouseOverText = mouseovertext })
	elseif menu.syncpoint then
		hasanydisplayed = true
		menu.insertInteractionContent("syncpoint", { type = "triggersyncpoint", text = ReadText(1001, 3232), script = function () return menu.buttonTriggerSyncPoint() end, active = C.GetNumObjectsWithSyncPoint(menu.syncpoint, true) > 0 })
		menu.insertInteractionContent("syncpoint", { type = "syncpointrelease", text = function () return ReadText(1001, 11297) .. ReadText(1001, 120) .. " " .. (C.GetSyncPointAutoRelease(menu.syncpoint, true) and ReadText(1001, 2617) or ReadText(1001, 2618)) end, script = function () return menu.buttonSyncPointAutoRelease() end })
	elseif menu.syncpointorder then
		hasanydisplayed = true
		menu.insertInteractionContent("order", { type = "removethisorder", text = ReadText(1001, 7831), helpOverlayID = "interactmenu_removethisorder", helpOverlayText = " ", helpOverlayHighlightOnly = true, script = menu.buttonRemoveOrder, active = (menu.syncpointorder.queueidx > 0) and C.RemoveOrder(menu.componentSlot.component, menu.syncpointorder.queueidx, false, true), mouseOverText = (menu.syncpointorder.queueidx == 0) and ReadText(1026, 7844) or "" })
		menu.insertInteractionContent("syncpoint", { type = "triggersyncpoint", text = ReadText(1001, 3232), script = function () return menu.buttonTriggerSyncPoint() end, active = C.GetNumObjectsWithSyncPointFromOrder(menu.componentSlot.component, menu.syncpointorder.queueidx, true) > 0 })
		menu.insertInteractionContent("syncpoint", { type = "syncpointrelease", text = function () return ReadText(1001, 11297) .. ReadText(1001, 120) .. " " .. (C.GetSyncPointAutoReleaseFromOrder(menu.componentSlot.component, menu.syncpointorder.queueidx, true) and ReadText(1001, 2617) or ReadText(1001, 2618)) end, script = function () return menu.buttonSyncPointAutoRelease() end })
	elseif menu.intersectordefencegroup then
		hasanydisplayed = true
		menu.insertInteractionContent("intersectordefencegroup", { text = ReadText(1001, 11137), script = function () return menu.buttonSubordinateGroupInterSectorDefence(menu.intersectordefencegroup, true) end })
		menu.insertInteractionContent("intersectordefencegroup", { text = ReadText(1001, 11138), checkbox = C.ShouldSubordinateGroupAttackOnSight(menu.componentSlot.component, menu.intersectordefencegroup), script = function (_, checked) return menu.checkboxSubordinateGroupAttackOnSight(menu.intersectordefencegroup, checked) end, mouseOverText = ReadText(1026, 7860) })
		menu.insertInteractionContent("intersectordefencegroup", { text = ReadText(1001, 11139), checkbox = C.ShouldSubordinateGroupResupplyAtFleet(menu.componentSlot.component, menu.intersectordefencegroup), script = function (_, checked) return menu.checkboxSubordinateGroupResupplyAtFleet(menu.intersectordefencegroup, checked) end, mouseOverText = ReadText(1026, 7861) })
		menu.insertInteractionContent("intersectordefencegroup", { text = ReadText(1001, 11140), checkbox = C.ShouldSubordinateGroupReinforceFleet(menu.componentSlot.component, menu.intersectordefencegroup), script = function (_, checked) return menu.checkboxSubordinateGroupReinforceFleet(menu.intersectordefencegroup, checked) end, mouseOverText = ReadText(1026, 7862) })
	elseif menu.mission then
		hasanydisplayed = true
		local missiondetails = C.GetMissionIDDetails(menu.mission)
		if ffi.string(missiondetails.mainType) == "guidance" then
			menu.insertInteractionContent("guidance", { text = ReadText(1001, 3243), script = menu.buttonEndGuidance, active = true })
		else
			local active = menu.mission == C.GetActiveMissionID()
			local buf = {}
			Helper.ffiVLA(buf, "MissionID", C.GetNumMissionThreadSubMissions, C.GetMissionThreadSubMissions, menu.mission)
			for _, submission in ipairs(buf) do
				if submission == C.GetActiveMissionID() then
					active = true
				end
			end

			menu.insertInteractionContent("guidance", { text = active and ReadText(1001, 3413) or ReadText(1001, 3406), script = active and menu.buttonMissionSetInactive or (function () return menu.buttonMissionSetActive(menu.mission) end), active = true })

			local active = missiondetails.abortable
			if missiondetails.threadMissionID ~= 0 then
				local details = C.GetMissionIDDetails(missiondetails.threadMissionID)
				active = active and (ffi.string(details.threadType) ~= "sequential")
			end

			menu.insertInteractionContent("guidance", { text = ReadText(1001, 3407), script = function () return menu.buttonMissionAbort(menu.mission) end, active = active })
			--menu.insertInteractionContent("guidance", { text = ReadText(1001, 7850), script = function () return menu.buttonMissionShow(menu.mission) end, active = true })
			local missionid = menu.mission
			if missiondetails.threadMissionID ~= 0 then
				missionid = ConvertStringTo64Bit(tostring(missiondetails.threadMissionID))
			end
			menu.insertInteractionContent("guidance", { text = ReadText(1001, 3326), script = function () return menu.buttonMissionBriefing(missionid, false) end, active = true })
		end
	elseif menu.missionoffer then
		hasanydisplayed = true
		local active = true
		local mouseovertext
		if C.IsMissionLimitReached(false, false, false) then
			active = false
			mouseovertext = ReadText(1026, 3242)
		end
		menu.insertInteractionContent("guidance", { text = ReadText(1001, 57), script = function () return menu.buttonMissionAccept(menu.missionoffer) end, active = active, mouseOverText = mouseovertext })
		menu.insertInteractionContent("guidance", { text = ReadText(1001, 3326), script = function () return menu.buttonMissionBriefing(menu.missionoffer, true) end, active = true })
	elseif menu.construction then
		hasanydisplayed = true
		-- construction (not action based at all)
		menu.insertInteractionContent("main", { text = ReadText(1001, 7853), script = menu.buttonCancelConstruction, active = C.CanCancelConstruction(menu.componentSlot.component, menu.construction.id) and ((menu.construction.factionid == "player") or GetComponentData(convertedComponent, "isplayerowned")) })
		if menu.construction.amount and (menu.construction.amount > 1) then
			local cancelcount = menu.getCanCancelConstructionCount()
			menu.insertInteractionContent("main", { text = ReadText(1041, 10022), text2 = (cancelcount > 0) and (cancelcount .. ReadText(1001, 42) .. " " .. GetMacroData(menu.construction.macro, "name")) or "", script = menu.buttonCancelAllConstruction, active = (cancelcount > 1) and ((menu.construction.factionid == "player") or GetComponentData(convertedComponent, "isplayerowned")) })
		end
	elseif menu.subordinategroup then
		hasanydisplayed = true
		-- subordinate group (not action based at all)
		local isplayerowned = GetComponentData(convertedComponent, "isplayerowned")
		local groups = menu.getSubordinatesInGroups(menu.componentSlot.component, C.IsComponentClass(menu.componentSlot.component, "station"))
		menu.groupShips = {}
		if groups[menu.subordinategroup] and #groups[menu.subordinategroup].subordinates then
			menu.groupShips = groups[menu.subordinategroup].subordinates
		end

		local allresupplier = true
		local allmining = true
		local allnomining = true
		local alltugs = true
		for _, shipentry in ipairs(menu.groupShips) do
			local purpose, shiptype = GetComponentData(shipentry.component, "primarypurpose", "shiptype")
			if shiptype ~= "resupplier" then
				allresupplier = false
			end
			if purpose == "mine" then
				allnomining = false
			end
			if purpose ~= "mine" then
				allmining = false
			end
			if shiptype ~= "tug" then
				alltugs = false
			end
		end

		if isplayerowned then
			-- select
			menu.insertInteractionContent("main", { text = ReadText(1001, 11100), script = menu.buttonSelectSubordinateGroup })
			-- inter-sector defense
			local shiptype = GetComponentData(convertedComponent, "shiptype")
			local commander = ConvertIDTo64Bit(GetCommander(convertedComponent))
			local subordinates = GetSubordinates(convertedComponent)
			local isfleetcommander = (not commander) and (#subordinates > 0)
			if (#menu.selectedplayerships == 0) and (shiptype == "carrier") and isfleetcommander then
				local isintersectorgroup = ffi.string(C.GetSubordinateGroupAssignment(menu.componentSlot.component, menu.subordinategroup)) == "positiondefence"
				menu.insertInteractionContent("main", { text = isintersectorgroup and ReadText(1001, 11137) or ReadText(1001, 11136), script = function () return menu.buttonSubordinateGroupInterSectorDefence(menu.subordinategroup, isintersectorgroup) end })
			end
			-- manage assignments
			local isstation = C.IsComponentClass(menu.componentSlot.component, "station")
			local isship = C.IsComponentClass(menu.componentSlot.component, "ship")
			-- defence
			menu.insertAssignSubActions("main_assignments_defence", "defence", menu.buttonChangeAssignment, groups, isstation, isstation)
			-- supplyfleet
			if allresupplier then
				menu.insertAssignSubActions("main_assignments_supplyfleet", "supplyfleet", menu.buttonChangeAssignment, groups, isstation, true)
			end
			if isstation then
				-- trading
				menu.insertAssignSubActions("main_assignments_trade", "trade", menu.buttonChangeAssignment, groups, isstation, true, nil, (not allnomining) and (ColorText["text_warning"] .. ReadText(1026, 8607)) or "")
				if allmining then
					-- mining
					menu.insertAssignSubActions("main_assignments_mining", "mining", menu.buttonChangeAssignment, groups, isstation, true)
				elseif allnomining then
					-- trading for buildstorage
					menu.insertAssignSubActions("main_assignments_tradeforbuildstorage", "tradeforbuildstorage", menu.buttonChangeAssignment, groups, isstation, true)
				end
				if alltugs then
					menu.insertAssignSubActions("main_assignments_salvage", "salvage", menu.buttonChangeAssignment, groups, isstation, true)
				end
			elseif isship then
				menu.insertAssignSubActions("main_assignments_attack", "attack", menu.buttonChangeAssignment, groups, isstation, nil)
				menu.insertAssignSubActions("main_assignments_interception", "interception", menu.buttonChangeAssignment, groups, isstation, nil)
				menu.insertAssignSubActions("main_assignments_bombardment", "bombardment", menu.buttonChangeAssignment, groups, isstation, nil)
				menu.insertAssignSubActions("main_assignments_follow", "follow", menu.buttonChangeAssignment, groups, isstation, true)
				local buf = ffi.new("Order")
				if C.GetDefaultOrder(buf, menu.componentSlot.component) then
					menu.insertAssignSubActions("main_assignments_assist", "assist", menu.buttonChangeAssignment, groups, isstation, true)
				end

				if GetComponentData(convertedComponent, "shiptype") == "resupplier" then
					menu.insertAssignSubActions("main_assignments_trade", "trade", menu.buttonChangeAssignment, groups, isstation, true)
				end
			end

			local assignment = ffi.string(C.GetSubordinateGroupAssignment(menu.componentSlot.component, menu.subordinategroup))
			menu.insertInteractionContent("selected_orders", { text = ReadText(1001, 11122), text2 = string.format(ReadText(1001, 8398), ReadText(20401, menu.subordinategroup)), script = function () return menu.buttonAssignCommander(assignment, menu.subordinategroup) end })
		else
			menu.insertInteractionContent("main", { text = ReadText(1001, 7852), active = false })
		end
	end
	if menu.mode == "shipconsole" then
		hasanydisplayed = true
		-- ship console at dockingbay (not action based at all)
		local shipconsoleparent = menu.isdockedship and C.GetContextByClass(menu.componentSlot.component, "dockingbay", false) or menu.componentSlot.component
		local hasdockingbayref = C.IsComponentClass(shipconsoleparent, "dockingbay")
		local iscontainer = C.IsComponentClass(shipconsoleparent, "container")
		local container = iscontainer and shipconsoleparent or C.GetContextByClass(shipconsoleparent, "container", false)
		local dockedships = {}
		Helper.ffiVLA(dockedships, "UniverseID", C.GetNumDockedShips, C.GetDockedShips, container, "player")
		local hasinternalstorage = false
		for _, dockedship in ipairs(dockedships) do
			if not C.IsShipAtExternalDock(dockedship) then
				if hasdockingbayref then
					hasinternalstorage = C.CanDockAtDockingBay(dockedship, shipconsoleparent)
				else
					hasinternalstorage = C.TakeShipFromInternalStorage(dockedship, false, true)
				end
				if hasinternalstorage then
					break
				end
			end
		end
		menu.insertInteractionContent("shipconsole", { text = ReadText(1001, 7879), script = menu.buttonRequestShip, active = hasinternalstorage and (not iscontainer), mouseOverText = (not hasinternalstorage) and ReadText(1026, 7831) or (iscontainer and ReadText(1026, 7832) or "") })
	end
	return hasanydisplayed
end

function menu.prepareTexts()
	menu.texts = {}
	menu.colors = {}

	if menu.componentSlot.component ~= 0 then
		local convertedComponent = ConvertStringTo64Bit(tostring(menu.componentSlot.component))
		menu.buildstorage = ConvertIDTo64Bit(GetComponentData(convertedComponent, "buildstorage"))
		local playerObject = C.GetPlayerObjectID()

		local idcode = ""
		if C.IsComponentClass(menu.componentSlot.component, "object") then
			idcode = " (" .. ffi.string(C.GetObjectIDCode(menu.componentSlot.component)) .. ")"
		end
		local sectorprefix = ""
		if C.IsComponentClass(menu.componentSlot.component, "sector") then
			sectorprefix = ReadText(20001, 201) .. ReadText(1001, 120) .. " "
		end
		local gatedestination = ""
		if C.IsComponentClass(menu.componentSlot.component, "gate") then
			local gatedestinationid = GetComponentData(convertedComponent, "destination")
			if gatedestinationid then
				gatedestinationid = ConvertStringTo64Bit(tostring(GetComponentData(gatedestinationid, "sectorid")))
				gatedestination = ReadText(1001, 120) .. " " .. Helper.unlockInfo(GetComponentData(convertedComponent, "isactive") and C.IsInfoUnlockedForPlayer(gatedestinationid, "name"), ffi.string(C.GetComponentName(gatedestinationid)))
			end
			idcode = ""
		end
		local iswreck = C.IsComponentWrecked(menu.componentSlot.component)
		local name_unlocked = IsInfoUnlockedForPlayer(convertedComponent, "name")
		menu.texts.targetShortName = iswreck and ReadText(1001, 27) or Helper.unlockInfo(name_unlocked, ffi.string(C.GetComponentName(menu.componentSlot.component)))
		menu.texts.targetName = sectorprefix .. Helper.unlockInfo(name_unlocked, ffi.string(C.GetComponentName(menu.componentSlot.component)) .. gatedestination .. idcode)
		local isplayerowned, isenemy, ishostile = GetComponentData(convertedComponent, "isplayerowned", "isenemy", "ishostile")
		menu.colors.target = Color["text_normal"]
		if iswreck then
			menu.colors.target = Color["text_inactive"]
		elseif isplayerowned then
			menu.colors.target = (menu.componentSlot.component == playerObject) and menu.holomapcolor.currentplayershipcolor or menu.holomapcolor.playercolor
		elseif ishostile then
			menu.colors.target = menu.holomapcolor.hostilecolor
		elseif isenemy then
			menu.colors.target = menu.holomapcolor.enemycolor
		end
		menu.texts.targetName = Helper.convertColorToText(menu.colors.target) .. menu.texts.targetName
		if C.IsComponentClass(menu.componentSlot.component, "ship") then
			menu.texts.targetBaseName = Helper.unlockInfo(name_unlocked, GetComponentData(convertedComponent, "basename"))
		end

		if menu.construction then
			if menu.construction.component ~= 0 then
				menu.texts.constructionName = ffi.string(C.GetComponentName(menu.construction.component))
			elseif menu.construction.macro ~= "" then
				menu.texts.constructionName = GetMacroData(menu.construction.macro, "name")
			end
		end

		if C.IsComponentClass(menu.componentSlot.component, "controllable") then
			local commander = ConvertIDTo64Bit(GetCommander(convertedComponent))
			if commander and commander ~= 0 then
				menu.texts.commanderShortName = Helper.unlockInfo(IsInfoUnlockedForPlayer(commander, "name"), ffi.string(C.GetComponentName(commander)))
				local idcode = ""
				if C.IsComponentClass(commander, "object") then
					idcode = " (" .. ffi.string(C.GetObjectIDCode(commander)) .. ")"
				end
				menu.texts.commanderName = sectorprefix .. Helper.unlockInfo(IsInfoUnlockedForPlayer(commander, "name"), ffi.string(C.GetComponentName(commander)) .. idcode)
				menu.colors.commander = GetComponentData(commander, "isplayerowned") and ((commander == playerObject) and menu.holomapcolor.currentplayershipcolor or menu.holomapcolor.playercolor) or Color["text_normal"]
				menu.texts.commanderShortName = Helper.convertColorToText(menu.colors.commander) .. menu.texts.commanderShortName
				menu.texts.commanderName = Helper.convertColorToText(menu.colors.commander) .. menu.texts.commanderName
			end
		end

		menu.texts.selectedFullNames = ""
		if #menu.selectedplayerships > 0 then
			menu.texts.selectedName = GetComponentData(menu.selectedplayerships[1], "name")
			if #menu.selectedplayerships > 1 then
				menu.texts.selectedName = string.format(ReadText(1001, 7801), #menu.selectedplayerships)
			end
			menu.colors.selected = (menu.selectedplayerships[1] == playerObject) and menu.holomapcolor.currentplayershipcolor or menu.holomapcolor.playercolor
			local first = true
			for _, selectedcomponent in ipairs(menu.selectedplayerships) do
				local isCurrentPlayerObject = (selectedcomponent == playerObject)
				local color = isCurrentPlayerObject and menu.holomapcolor.currentplayershipcolor or menu.holomapcolor.playercolor
				menu.texts.selectedFullNames = menu.texts.selectedFullNames .. (first and "" or "\n") .. Helper.convertColorToText(color) .. GetComponentData(selectedcomponent, "name") .. " (" .. ffi.string(C.GetObjectIDCode(selectedcomponent)) .. ")" .. (isCurrentPlayerObject and (" (" .. ReadText(1001, 7836) .. ")") or "")
				first = false
			end
		end
		-- count the interacted object here too
		if isplayerowned and C.IsRealComponentClass(menu.componentSlot.component, "ship") then
			menu.texts.selectedNameAll = string.format(ReadText(1001, 7801), #menu.selectedplayerships + 1)
			local isCurrentPlayerObject = (convertedComponent == playerObject)
			local color = isCurrentPlayerObject and menu.holomapcolor.currentplayershipcolor or menu.holomapcolor.playercolor
			menu.texts.selectedFullNamesAll = menu.texts.selectedFullNames .. "\n" .. Helper.convertColorToText(color) .. GetComponentData(convertedComponent, "name") .. " (" .. ffi.string(C.GetObjectIDCode(convertedComponent)) .. ")" .. ((isCurrentPlayerObject) and (" (" .. ReadText(1001, 7836) .. ")") or "")
		end

		if #menu.selectedotherobjects > 0 then
			menu.texts.otherName = GetComponentData(menu.selectedotherobjects[1], "name")
			if #menu.selectedotherobjects > 1 then
				menu.texts.otherName = string.format(ReadText(1001, 11105), #menu.selectedotherobjects)
			end
			menu.texts.otherFullNames = ""
			local first = true
			for _, selectedcomponent in ipairs(menu.selectedotherobjects) do
				local color = Color["text_normal"]
				menu.texts.otherFullNames = menu.texts.otherFullNames .. (first and "" or "\n") .. Helper.convertColorToText(color) .. GetComponentData(selectedcomponent, "name") .. " (" .. ffi.string(C.GetObjectIDCode(selectedcomponent)) .. ")"
				first = false
			end
		end

		if menu.buildstorage then
			local name_unlocked = IsInfoUnlockedForPlayer(menu.buildstorage, "name")
			menu.texts.buildstorageName = Helper.unlockInfo(name_unlocked, ffi.string(C.GetComponentName(menu.buildstorage)))
			menu.texts.buildstorageFullName = Helper.convertColorToText(menu.colors.target) .. menu.texts.buildstorageName .. " (" .. ffi.string(C.GetObjectIDCode(menu.buildstorage)) .. ")"
		end

		menu.texts.ventureName = ""
		menu.colors.venture = Color["text_player"]
		if #menu.ventureships > 0 then
			menu.texts.ventureName = GetComponentData(menu.ventureships[1], "name")
			if #menu.ventureships > 1 then
				menu.texts.ventureName = string.format(ReadText(1001, 7801), #menu.ventureships)
			end
		end
	elseif menu.syncpoint then
		menu.texts.targetShortName = ReadText(1001, 3237) .. ReadText(1001, 120) .. " " .. Helper.getSyncPointName(menu.syncpoint)
	elseif menu.mission then
		local missiondetails = C.GetMissionIDDetails(menu.mission)
		menu.texts.targetShortName = ffi.string(missiondetails.missionName)
	elseif menu.missionoffer then
		menu.texts.targetShortName = GetMissionOfferDetails(ConvertStringToLuaID(menu.missionoffer))
	end
end

function menu.areTurretsArmed(defensible)
	local turrets = {}
	local numslots = tonumber(C.GetNumUpgradeSlots(defensible, "", "turret"))
	for j = 1, numslots do
		local groupinfo = C.GetUpgradeSlotGroup(defensible, "", "turret", j)
		if (ffi.string(groupinfo.path) == "..") and (ffi.string(groupinfo.group) == "") then
			local current = C.GetUpgradeSlotCurrentComponent(defensible, "turret", j)
			if current ~= 0 then
				table.insert(turrets, current)
			end
		end
	end

	local turretgroups = {}
	local n = C.GetNumUpgradeGroups(defensible, "")
	local buf = ffi.new("UpgradeGroup2[?]", n)
	n = C.GetUpgradeGroups2(buf, n, defensible, "")
	for i = 0, n - 1 do
		if (ffi.string(buf[i].path) ~= "..") or (ffi.string(buf[i].group) ~= "") then
			local group = { context = buf[i].contextid, path = ffi.string(buf[i].path), group = ffi.string(buf[i].group) }
			local groupinfo = C.GetUpgradeGroupInfo2(defensible, "", group.context, group.path, group.group, "turret")
			if (groupinfo.count > 0) then
				group.operational = groupinfo.operational
				group.currentmacro = ffi.string(groupinfo.currentmacro)
				group.slotsize = ffi.string(groupinfo.slotsize)
				table.insert(turretgroups, group)
			end
		end
	end

	local alldisarmed = true
	for i, turret in ipairs(turrets) do
		if C.IsWeaponArmed(turret) then
			alldisarmed = false
			break
		end
	end
	for i, group in ipairs(turretgroups) do
		if group.operational > 0 then
			if C.IsTurretGroupArmed(defensible, group.context, group.path, group.group) then
				alldisarmed = false
				break
			end
		end
	end
	return not alldisarmed
end

function menu.orderIconText(orderid)
	if menu.orderdefs[orderid] and (menu.orderdefs[orderid].icon ~= "") then
		return "\27[" .. menu.orderdefs[orderid].icon .. "] "
	end
	return ""
end

-- update
menu.updateInterval = 0.1

function menu.onUpdate()
	local curTime = getElapsedTime()
	if menu.mode ~= "shipconsole" then
		if (GetControllerInfo() ~= "gamepad") or C.IsMouseEmulationActive() then
			local curpos = table.pack(GetLocalMousePosition())
			if curpos[1] and ((curpos[1] < menu.mouseOutBox.x1) or (curpos[1] > menu.mouseOutBox.x2)) then
				menu.onCloseElement("close")
				return
			elseif curpos[2] and ((curpos[2] > menu.mouseOutBox.y1) or (curpos[2] < menu.mouseOutBox.y2)) then
				menu.onCloseElement("close")
				return
			end
		end
	elseif C.IsComponentClass(menu.componentSlot.component, "dockingbay") then
		if (not menu.dockingbayReserveTime) or (menu.dockingbayReserveTime < curTime) then
			C.SetDockingBayReservation(menu.componentSlot.component, 5.0)
			menu.dockingbayReserveTime = curTime + 4.0
		end
	end

	if menu.checkPlayerActivity then
		local playerActivity = GetPlayerActivity()
		if playerActivity ~= menu.currentActivity then
			if (playerActivity == "scan") or (menu.currentActivity == "scan") then
				if not menu.prepareActions() then
					-- no actions found
					menu.onCloseElement("close")
					return
				end
				menu.refresh = true
			end
			menu.currentActivity = playerActivity
		end
	end

	if menu.pendingSubSection and (menu.lastSubSectionTime + config.subsectionDelay < curTime) then
		if menu.pendingSubSection == -1 then
			menu.subsection = nil
		else
			menu.subsection = menu.pendingSubSection
		end
		menu.pendingSubSection = nil
		menu.refresh = true
	end

	if menu.refresh then
		menu.refresh = nil
		menu.lock = curTime
		menu.selectedRows.contentTable = Helper.currentTableRow[menu.contentTable]
		menu.topRows.contentTable = GetTopRow(menu.contentTable)
		menu.draw()
		return
	end
	if menu.lock and (menu.lock + 0.1 < curTime) then
		menu.lock = nil
	end

	menu.frame:update()
end


-- helper hooks

function menu.onButtonOver(uitable, row, col, button)
	if uitable == menu.contentTable then
		local data = menu.rowDataMap[uitable][row]
		if (not menu.lock) or (menu.subsection and (type(data) == "table") and (menu.subsection.id ~= data.id)) then
			menu.handleSubSectionOption(data, false)
		else
			menu.lock = nil
		end
	end
end

function menu.onCloseElement(dueToClose, layer, allowAutoMenu)
	if dueToClose == "back" then
		if menu.subsection then
			menu.subsection = nil
			menu.refresh = true
			return
		end
	end

	if menu.interactMenuID then
		C.NotifyInteractMenuHidden(menu.interactMenuID, true)
	end
	if menu.shown then
		Helper.closeMenu(menu, dueToClose, allowAutoMenu, false)
	else
		Helper.resetUpdateHandler()
		Helper.clearFrame(menu, config.layer)
		if Helper.interactMenuCallbacks.onTableMouseOut then
			Helper.interactMenuCallbacks.onTableMouseOut(menu.currentOverTable)
		end
		Helper.resetInteractMenuCallbacks()
	end
	menu.cleanup()
end

function menu.onRowChanged()
	menu.lock = getElapsedTime()
end

function menu.onTableMouseOut(uitable, row)
	menu.pendingSubSection = nil
	if not menu.shown then
		if Helper.interactMenuCallbacks.onTableMouseOut then
			Helper.interactMenuCallbacks.onTableMouseOut(uitable, row)
		end
	end
end

function menu.onTableMouseOver(uitable, row)
	if not menu.shown then
		menu.currentOverTable = uitable
		if Helper.interactMenuCallbacks.onTableMouseOver then
			Helper.interactMenuCallbacks.onTableMouseOver(uitable, row)
		end
	end
end

function menu.viewCreated(layer, ...)
	menu.contentTable = ...
end

-- kuetee start:
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

local newCustomGroupId
local newCustomGroupText
function menu.Add_Custom_Actions_Group_Id(_, id)
	newCustomGroupId = id
	if newCustomGroupId and newCustomGroupText then
		menu.Add_Custom_Actions_Group(newCustomGroupId, newCustomGroupText)
		newCustomGroupId = nil
		newCustomGroupText = nil
	end
end

function menu.Add_Custom_Actions_Group_Text(_, text)
	newCustomGroupText = text
	if newCustomGroupId and newCustomGroupText then
		menu.Add_Custom_Actions_Group(newCustomGroupId, newCustomGroupText)
		newCustomGroupId = nil
		newCustomGroupText = nil
	end
end

function menu.Add_Custom_Actions_Group(id, text)
	local customActionsSection
	local customActionsSection_isFound = false
	local customActionsSection_isAddTo = string.find(id, "actions_")
	local customOrdersSection
	local customOrdersSection_isFound = false
	local customOrdersSection_isAddTo = string.find(id, "orders_")
	if (not customActionsSection_isAddTo) and (not customOrdersSection_isAddTo) then
		customActionsSection_isAddTo = true
		customOrdersSection_isAddTo = true
	end
	Helper.debugText("Add_Custom_Actions_Group id: " .. tostring(id) .. " text: " .. tostring(text))
	for _, section in ipairs(config.sections) do
		if section.id == "custom_actions" or section.id == "custom_orders" then
			Helper.debugText("Add_Custom_Actions_Group    section.id: ", section.id)
			if section.id == "custom_actions" then
				customActionsSection = section
			else
				customOrdersSection = section
			end
			for _, subsection in ipairs(section.subsections) do
				Helper.debugText("Add_Custom_Actions_Group        subsection.id: ", subsection.id)
				if subsection.id == id then
					if section.id == "custom_actions" then
						customActionsSection_isFound = true
					else
						customOrdersSection_isFound = true
					end
					Helper.debugText("Add_Custom_Actions_Group customActionsSection.subsections", customActionsSection.subsections)
				end
			end
		end
	end
	Helper.debugText("Add_Custom_Actions_GroupcustomActionsSection_isFound: ", customActionsSection_isFound)
	Helper.debugText("Add_Custom_Actions_GroupcustomOrdersSection_isFound: ", customOrdersSection_isFound)
	if customActionsSection and customActionsSection_isAddTo and (not customActionsSection_isFound) then
		table.insert (customActionsSection.subsections, {id = id, text = text})
		Helper.debugText("Add_Custom_Actions_Group customActionsSection.subsections", customActionsSection.subsections)
	end
	if customOrdersSection and customOrdersSection_isAddTo and (not customOrdersSection_isFound) then
		table.insert (customOrdersSection.subsections, {id = id, text = text})
		Helper.debugText("Add_Custom_Actions_Group customOrdersSection.subsections", customOrdersSection.subsections)
	end
end

function menu.loadModLuas()
	if Helper then
		Helper.loadModLuas(menu.name, "menu_interactmenu_uix")
	end
end

-- kuertee end

init()
