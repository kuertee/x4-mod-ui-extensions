-- ffi setup
local ffi = require("ffi")
local C = ffi.C
ffi.cdef[[
	typedef int32_t BlacklistID;
	typedef int32_t FightRuleID;
	typedef uint64_t MissionID;
	typedef uint64_t NPCSeed;
	typedef uint64_t TradeID;
	typedef int32_t TradeRuleID;
	typedef uint64_t UniverseID;
	
	typedef struct {
		uint32_t nummacros;
		uint32_t numfactions;
	} BlacklistCounts;
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
		uint32_t red;
		uint32_t green;
		uint32_t blue;
		uint32_t alpha;
	} Color;
	typedef struct {
		const char* newroleid;
		NPCSeed seed;
		uint32_t amount;
		int64_t price;
	} CrewTransferContainer2;
	typedef struct {
		CrewTransferContainer2* removed;
		uint32_t numremoved;
		CrewTransferContainer2* added;
		uint32_t numadded;
		CrewTransferContainer2* transferred;
		uint32_t numtransferred;
	} CrewTransferInfo2;
	typedef struct {
		const char* id;
		const char* name;
		const char* description;
		const char* propdatatype;
		float basevalue;
		bool poseffect;
	} EquipmentModPropertyInfo;
	typedef struct {
		uint32_t numfactions;
	} FightRuleCounts;
	typedef struct {
		int32_t year;
		uint32_t month;
		uint32_t day;
		bool isvalid;
	} GameStartDateInfo;
	typedef struct {
		double time;
		int64_t money;
		int64_t entryid;
	} MoneyLogEntry;
	typedef struct {
		const char* name;
		const char* transport;
		uint32_t spaceused;
		uint32_t capacity;
	} StorageInfo;
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
		double time;
		int64_t money;
		int64_t entryid;
		const char* eventtype;
		const char* eventtypename;
		UniverseID partnerid;
		const char* partnername;
		const char* partneridcode;
		int64_t tradeentryid;
		const char* tradeeventtype;
		const char* tradeeventtypename;
		UniverseID buyerid;
		UniverseID sellerid;
		const char* ware;
		uint32_t amount;
		int64_t price;
		bool complete;
	} TransactionLogEntry;
	typedef struct {
		const char* Name;
		const char* RawName;
		const char* Ware;
		uint32_t Quality;
		const char* PropertyType;
		float ForwardThrustFactor;
		float StrafeThrustFactor;
		float RotationThrustFactor;
		float BoostThrustFactor;
		float BoostDurationFactor;
		float BoostAttackTimeFactor;
		float BoostReleaseTimeFactor;
		float BoostChargeTimeFactor;
		float BoostRechargeTimeFactor;
		float TravelThrustFactor;
		float TravelStartThrustFactor;
		float TravelAttackTimeFactor;
		float TravelReleaseTimeFactor;
		float TravelChargeTimeFactor;
	} UIEngineMod;
	typedef struct {
		const char* factionid;
		const char* civiliansetting;
		const char* militarysetting;
	} UIFightRuleSetting;
	typedef struct {
		float x;
		float y;
		float z;
		float yaw;
		float pitch;
		float roll;
	} UIPosRot;
	typedef struct {
		const char* Name;
		const char* RawName;
		const char* Ware;
		uint32_t Quality;
		const char* PropertyType;
		float CapacityFactor;
		float RechargeDelayFactor;
		float RechargeRateFactor;
	} UIShieldMod;
	typedef struct {
		const char* Name;
		const char* RawName;
		const char* Ware;
		uint32_t Quality;
		const char* PropertyType;
		float MassFactor;
		float DragFactor;
		float MaxHullFactor;
		float RadarRangeFactor;
		uint32_t AddedUnitCapacity;
		uint32_t AddedMissileCapacity;
		uint32_t AddedCountermeasureCapacity;
		uint32_t AddedDeployableCapacity;
		float RadarCloakFactor;
		float RegionDamageProtection;
		float HideCargoChance;
	} UIShipMod2;
	typedef struct {
		const char* stat;
		uint32_t min;
		uint32_t max;
		uint64_t minvalue;
		uint64_t maxvalue;
		bool issatisfied;
	} UITerraformingProjectCondition;
	typedef struct {
		const char* text;
		const char* stat;
		int32_t change;
		uint64_t value;
		uint64_t minvalue;
		uint64_t maxvalue;
		bool onfail;
		bool issideeffect;
		uint32_t chance;
		uint32_t setbackpercent;
		bool isbeneficial;
	} UITerraformingProjectEffect;
	typedef struct {
		const char* id;
		const char* name;
	} UITerraformingProjectGroup;
	typedef struct {
		const char* id;
		bool anyproject;
	} UITerraformingProjectPredecessorGroup;
	typedef struct {
		const char* ware;
		const char* waregroupname;
		uint32_t value;
	} UITerraformingProjectRebate;
	typedef struct {
		const char* name;
		const char* rawname;
		const char* icon;
		const char* rewardicon;
		int64_t remainingtime;
		uint32_t numships;
	} UIVentureInfo;
	typedef struct {
		const char* wareid;
		uint32_t amount;
	} UIWareAmount;
	typedef struct {
		const char* ware;
		const char* macro;
		int amount;
	} UIWareInfo;
	typedef struct {
		const char* Name;
		const char* RawName;
		const char* Ware;
		uint32_t Quality;
		const char* PropertyType;
		float DamageFactor;
		float CoolingFactor;
		float ReloadFactor;
		float SpeedFactor;
		float LifeTimeFactor;
		float MiningFactor;
		float StickTimeFactor;
		float ChargeTimeFactor;
		float BeamLengthFactor;
		uint32_t AddedAmount;
		float RotationSpeedFactor;
		float SurfaceElementFactor;
	} UIWeaponMod;
	typedef struct {
		const char* path;
		const char* group;
	} UpgradeGroup;
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
		uint32_t current;
		uint32_t capacity;
		uint32_t optimal;
		uint32_t available;
		uint32_t maxavailable;
		double timeuntilnextupdate;
	} WorkForceInfo;

	typedef struct {
		FightRuleID id;
		const char* name;
		uint32_t numfactions;
		UIFightRuleSetting* factions;
	} FightRuleInfo;
	void AddTradeWare(UniverseID containerid, const char* wareid);
	bool AreVenturesCompatible(void);
	bool AreVenturesEnabled(void);
	bool CancelPlayerInvolvedTradeDeal(UniverseID containerid, TradeID tradeid, bool checkonly);
	bool CanResearch(void);
	void ClearContainerBuyLimitOverride(UniverseID containerid, const char* wareid);
	void ClearContainerSellLimitOverride(UniverseID containerid, const char* wareid);
	void ClearTrackedMenus(void);
	void DisableAutoMouseEmulation(void);
	void EnableAutoMouseEmulation(void);
	uint32_t GetAllBlacklists(BlacklistID* result, uint32_t resultlen);
	uint32_t GetAllEquipmentModProperties(EquipmentModPropertyInfo* result, uint32_t resultlen, const char* equipmentmodclass);
	uint32_t GetAllFightRules(FightRuleID* result, uint32_t resultlen);
	uint32_t GetAllTradeRules(TradeRuleID* result, uint32_t resultlen);
	BlacklistCounts GetBlacklistInfoCounts(BlacklistID id);
	bool GetBlacklistInfo2(BlacklistInfo2* info, BlacklistID id);
	uint32_t GetCargoTransportTypes(StorageInfo* result, uint32_t resultlen, UniverseID containerid, bool merge, bool aftertradeorders);
	const char* GetComponentName(UniverseID componentid);
	int32_t GetContainerBuyLimit(UniverseID containerid, const char* wareid);
	int32_t GetContainerSellLimit(UniverseID containerid, const char* wareid);
	uint32_t GetContainerStockLimitOverrides(UIWareInfo* result, uint32_t resultlen, UniverseID containerid);
	TradeRuleID GetContainerTradeRuleID(UniverseID containerid, const char* ruletype, const char* wareid);
	double GetContainerWareConsumption(UniverseID containerid, const char* wareid, bool ignorestate);
	bool GetContainerWareIsBuyable(UniverseID containerid, const char* wareid);
	bool GetContainerWareIsSellable(UniverseID containerid, const char* wareid);
	int32_t GetContainerWareMaxProductionStorageForTime(UniverseID containerid, const char* wareid, double duration, bool ignoreoverrides);
	double GetContainerWareProduction(UniverseID containerid, const char* wareid, bool ignorestate);
	uint32_t GetContainerWareReservations2(WareReservationInfo2* result, uint32_t resultlen, UniverseID containerid, bool includevirtual, bool includemission, bool includesupply);
	UniverseID GetContextByClass(UniverseID componentid, const char* classname, bool includeself);
	int64_t GetCreditsDueFromPlayerBuilds(void);
	int64_t GetCreditsDueFromPlayerTrades(void);
	double GetCurrentGameTime(void);
	int64_t GetCurrentUTCDataTime(void);
	UIVentureInfo GetCurrentVentureInfo(UniverseID ventureplatformid);
	uint32_t GetCurrentVentureShips(UniverseID* result, uint32_t resultlen, UniverseID ventureplatformid);
	uint32_t GetDockedShips(UniverseID* result, uint32_t resultlen, UniverseID dockingbayorcontainerid, const char* factionid);
	bool GetFightRuleInfo(FightRuleInfo* info, FightRuleID id);
	FightRuleCounts GetFightRuleInfoCounts(FightRuleID id);
	GameStartDateInfo GetGameStartDate();
	const char* GetGameStartName();
	bool GetInstalledEngineMod(UniverseID objectid, UIEngineMod* enginemod);
	bool GetInstalledGroupedWeaponMod(UniverseID defensibleid, UniverseID contextid, const char* group, UIWeaponMod* weaponmod);
	bool GetInstalledShieldMod(UniverseID defensibleid, UniverseID contextid, const char* group, UIShieldMod* shieldmod);
	bool GetInstalledShipMod2(UniverseID shipid, UIShipMod2* shipmod);
	bool GetInstalledWeaponMod(UniverseID weaponid, UIWeaponMod* weaponmod);
	const char* GetMappedInputName(const char* functionkey);
	uint32_t GetMoneyLog(MoneyLogEntry* result, size_t resultlen, UniverseID componentid, double starttime, double endtime);
	uint32_t GetNumAllBlacklists(void);
	uint32_t GetNumAllEquipmentModProperties(const char* equipmentmodclass);
	uint32_t GetNumAllFightRules(void);
	uint32_t GetNumAllTradeRules(void);
	uint32_t GetNumCargoTransportTypes(UniverseID containerid, bool merge);
	uint32_t GetNumContainerStockLimitOverrides(UniverseID containerid);
	uint32_t GetNumContainerWareReservations2(UniverseID containerid, bool includevirtual, bool includemission, bool includesupply);
	uint32_t GetNumDockedShips(UniverseID dockingbayorcontainerid, const char* factionid);
	uint32_t GetNumTerraformingProjects(UniverseID clusterid, bool useevents);
	uint32_t GetNumTransactionLog(UniverseID componentid, double starttime, double endtime);
	uint32_t GetNumVenturePlatformDocks(UniverseID ventureplatformid);
	uint32_t GetNumVenturePlatforms(UniverseID defensibleid);
	const char* GetObjectIDCode(UniverseID objectid);
	UIPosRot GetObjectPositionInSector(UniverseID objectid);
	const char* GetPlayerCoverFaction(void);
	const char* GetPlayerCurrentControlGroup(void);
	UniverseID GetPlayerID(void);
	const char* GetPlayerName(void);
	UniverseID GetPlayerOccupiedShipID(void);
	uint32_t GetTerraformingProjectBlockingProjects(const char** result, uint32_t resultlen, UniverseID clusterid, const char* projectid);
	uint32_t GetTerraformingProjectConditions(UITerraformingProjectCondition* result, uint32_t resultlen, UniverseID clusterid, const char* projectid);
	uint32_t GetTerraformingProjectEffects(UITerraformingProjectEffect* result, uint32_t resultlen, UniverseID clusterid, const char* projectid);
	uint32_t GetTerraformingProjectPredecessorGroups(UITerraformingProjectPredecessorGroup* result, uint32_t resultlen, UniverseID clusterid, const char* projectid);
	uint32_t GetTerraformingProjectPredecessors(const char** result, uint32_t resultlen, UniverseID clusterid, const char* projectid);
	uint32_t GetTerraformingProjectRebatedResources(UIWareInfo* result, uint32_t resultlen, UniverseID clusterid, const char* projectid);
	uint32_t GetTerraformingProjectRebates(UITerraformingProjectRebate* result, uint32_t resultlen, UniverseID clusterid, const char* projectid);
	uint32_t GetTerraformingProjectRemovedProjects(const char** result, uint32_t resultlen, UniverseID clusterid, const char* projectid);
	float GetTextHeight(const char*const text, const char*const fontname, const float fontsize, const float wordwrapwidth);
	float GetTextWidth(const char*const text, const char*const fontname, const float fontsize);
	uint32_t GetTransactionLog(TransactionLogEntry* result, uint32_t resultlen, UniverseID componentid, double starttime, double endtime);
	UniverseID GetTopLevelContainer(UniverseID componentid);
	bool GetTradeRuleInfo(TradeRuleInfo* info, TradeRuleID id);
	TradeRuleCounts GetTradeRuleInfoCounts(TradeRuleID id);
	float GetUIScale(const bool scalewithresolution);
	UpgradeGroup GetUpgradeSlotGroup(UniverseID destructibleid, const char* macroname, const char* upgradetypename, size_t slot);
	const char* GetUserDataSigned(const char* name);
	uint32_t GetVenturePlatformDocks(UniverseID* result, uint32_t resultlen, UniverseID ventureplatformid);
	uint32_t GetVenturePlatforms(UniverseID* result, uint32_t resultlen, UniverseID defensibleid);
	WorkForceInfo GetWorkForceInfo(UniverseID containerid, const char* raceid);
	bool HasContainerBuyLimitOverride(UniverseID containerid, const char* wareid);
	bool HasContainerOwnTradeRule(UniverseID containerid, const char* ruletype, const char* wareid);
	bool HasContainerSellLimitOverride(UniverseID containerid, const char* wareid);
	bool IsComponentClass(UniverseID componentid, const char* classname);
	bool IsComponentOperational(UniverseID componentid);
	bool IsConversationActive(void);
	bool IsConversationCancelling(void);
	bool IsDemoVersion(void);
	bool IsInfoUnlockedForPlayer(UniverseID componentid, const char* infostring);
	bool IsGameOver(void);
	bool IsNextStartAnimationSkipped(bool reset);
	bool IsOnlineEnabled(void);
	bool IsPlayerBlacklistDefault(BlacklistID id, const char* listtype, const char* defaultgroup);
	bool IsPlayerFightRuleDefault(FightRuleID id, const char* listtype);
	bool IsSetaActive();
	bool IsStartmenu();
	bool IsTerraformingProjectOngoing(UniverseID clusterid, const char* projectid);
	bool IsTimelinesScenario(void);
	bool IsValidTrade(TradeID tradeid);
	bool IsVentureSeasonSupported(void);
	bool IsVRMode(void);
	bool IsWeaponModeCompatible(UniverseID weaponid, const char* macroname, const char* weaponmodeid);
	bool QuickMenuAccess(const char* menu);
	void ReleaseConstructionMapState(void);
	void ReleaseDetachedSubordinateGroup(UniverseID controllableid, int group);
	void RemoveTrackedMenu(const char* menu);
	void SetBoxText(const int boxtextid, const char* text);
	void SetBoxTextBoxColor(const int boxtextid, Color color);
	void SetBoxTextColor(const int boxtextid, Color color);
	void SetBoxTextGlowFactor(const int boxtextid, float factor);
	void SetButtonActive(const int buttonid, bool active);
	void SetButtonGlowFactor(const int buttonid, float factor);
	void SetButtonHighlightColor(const int buttonid, Color color);
	void SetButtonHighlightGlowFactor(const int buttonid, float factor);
	void SetButtonIconColor(const int buttonid, Color color);
	void SetButtonIcon2Color(const int buttonid, Color color);
	void SetButtonIconGlowFactor(const int buttonid, float factor);
	void SetButtonIcon2GlowFactor(const int buttonid, float factor);
	void SetButtonIconID(const int buttonid, const char* iconid);
	void SetButtonIcon2ID(const int buttonid, const char* iconid);
	void SetButtonTextColor(const int buttonid, Color color);
	void SetButtonTextGlowFactor(const int buttonid, float factor);
	void SetButtonText2(const int buttonid, const char* text);
	void SetButtonText2Color(const int buttonid, Color color);
	void SetButtonText2GlowFactor(const int buttonid, float factor);
	void SetCheckBoxChecked2(const int checkboxid, bool checked, bool update);
	void SetCheckBoxColor(const int checkboxid, Color color);
	void SetCheckBoxSymbolGlowFactor(const int checkboxid, float factor);
	void SetContainerBuyLimitOverride(UniverseID containerid, const char* wareid, int32_t amount);
	void SetContainerSellLimitOverride(UniverseID containerid, const char* wareid, int32_t amount);
	void SetContainerTradeRule(UniverseID containerid, TradeRuleID id, const char* ruletype, const char* wareid, bool value);
	void SetContainerWareIsBuyable(UniverseID containerid, const char* wareid, bool allowed);
	void SetContainerWareIsSellable(UniverseID containerid, const char* wareid, bool allowed);
	void SetDropDownCurOption(const int dropdownid, const char* id);
	void SetDropDownOptionTexts(const int dropdownid, const char** texts, uint32_t numtexts);
	void SetDropDownOptionTexts2(const int dropdownid, const char** texts, uint32_t numtexts);
	void SetEditBoxActive(const int editboxid, bool active);
	void SetEditBoxText(const int editboxid, const char* text);
	void SetEditBoxTextHidden(const int editboxid, bool hidden);
	void SetFlowChartEdgeColor(const int flowchartedgeid, Color color);
	void SetFlowChartNodeCaptionText(const int flowchartnodeid, const char* text);
	void SetFlowChartNodeCaptionTextColor(const int flowchartnodeid, Color color);
	void SetFlowChartNodeCaptionTextGlowFactor(const int flowchartnodeid, float factor);
	void SetFlowChartNodeCurValue(const int flowchartnodeid, double value);
	void SetFlowchartNodeExpanded(const int flowchartnodeid, const int frameid, bool expandedabove);
	void SetFlowChartNodeMaxValue(const int flowchartnodeid, double value);
	void SetFlowChartNodeOutlineColor(const int flowchartnodeid, Color color);
	void SetFlowChartNodeSlider1Value(const int flowchartnodeid, double value);
	void SetFlowChartNodeSlider2Value(const int flowchartnodeid, double value);
	void SetFlowChartNodeSliderStep(const int flowchartnodeid, double step);
	void SetFlowChartNodeStatusBgIcon(const int flowchartnodeid, const char* iconid);
	void SetFlowChartNodeStatusIcon(const int flowchartnodeid, const char* iconid);
	void SetFlowChartNodeStatusIconMouseOverText(const int flowchartnodeid, const char* mouseovertext);
	void SetFlowChartNodeStatusText(const int flowchartnodeid, const char* text);
	void SetFlowChartNodeStatusColor(const int flowchartnodeid, Color color);
	void SetFlowChartNodeStatusGlowFactor(const int flowchartnodeid, float factor);
	void SetFontStringGlowFactor(const int fontstringid, float factor);
	void SetIcon(const int widgeticonid, const char* iconid);
	void SetIconColor(const int widgeticonid, Color color);
	void SetIconGlowFactor(const int widgeticonid, float factor);
	void SetIconText(const int widgeticonid, const char* text);
	void SetIconText2(const int widgeticonid, const char* text);
	void SetIconTextColor(const int widgeticonid, Color color);
	void SetIconText2Color(const int widgeticonid, Color color);
	void SetIconTextGlowFactor(const int widgeticonid, float factor);
	void SetIconText2GlowFactor(const int widgeticonid, float factor);
	void SetMouseInputBlockedByAnarkElement(int32_t mousebuttonid, const char* modifiers, bool blocked);
	void SetMouseOverText(int widgetid, const char* text);
	void SetShieldHullBarGlowFactor(const int shieldhullbarid, float factor);
	void SetShieldHullBarHullPercent(const int shieldhullbarid, float hullpercent);
	void SetShieldHullBarShieldPercent(const int shieldhullbarid, float shieldpercent);
	void SetSliderCellMaxSelectValue(const int slidercellid, double value);
	void SetSliderCellMaxValue(const int slidercellid, double value);
	void SetSliderCellMinSelectValue(const int slidercellid, double value);
	void SetSliderCellMinValue(const int slidercellid, double value);
	void SetSubordinateGroupAssignment(UniverseID controllableid, int group, const char* assignment);
	void SetSubordinateGroupProtectedLocation(UniverseID controllableid, int group, UniverseID sectorid, UIPosRot offset);
	void SetStatusBarCurrentValue(const int statusbarid, float value);
	void SetStatusBarMaxValue(const int statusbarid, float value);
	void SetStatusBarStartValue(const int statusbarid, float value);
	void SetTableNextConnectedTable(const int tableid, const int nexttableid);
	void SetTablePreviousConnectedTable(const int tableid, const int prevtableid);
	void SetTableNextHorizontalConnectedTable(const int tableid, const int nexttableid);
	void SetTablePreviousHorizontalConnectedTable(const int tableid, const int prevtableid);
	void SetWidgetViewScheduled(bool scheduled);
	void SkipNextStartAnimation(void);
	void TrackMenu(const char* menu, bool fullscreen);
	bool WasSessionOnline(void);
]]

local utf8 = require("utf8")

---------------------------------------------------------------------------------
-- Global helper table
---------------------------------------------------------------------------------

Helper = {
	standardHalignment = "left",
	standardFontBold = "Zekton bold",
	standardFontMono = "Zekton fixed",
	standardFontBoldMono = "Zekton bold fixed",
	standardFontOutlined = "Zekton outlined",
	standardFontBoldOutlined = "Zekton bold outlined",
	standardButtonWidth = 16,
	standardButtonHeight = 20,
	standardFlowchartNodeHeight = 30,
	standardFlowchartConnectorSize = 10,
	standardHotkeyIconSizex = 19,
	standardHotkeyIconSizey = 19,
	-- normal text properties
	standardFont = "Zekton",
	standardFontSize = 9,
	standardTextOffsetx = 5,
	standardTextOffsety = 0,
	standardTextHeight = 16,
	standardTextWidth = 0,
	-- title text properties
	titleFont = "Zekton bold",
	titleFontSize = 12,
	titleOffsetX = 3,
	titleOffsetY = 2,
	titleHeight = 20,
	-- header properties
	headerRow1Font = "Zekton bold",
	headerRow1FontSize = 10,
	headerRow1Offsetx = 3,
	headerRow1Offsety = 2,
	headerRow1Height = 20,
	headerRow1Width = 0,
	-- subheader properties
	subHeaderHeight = 18,
	-- large icon text properties
	largeIconFontSize = 16,
	largeIconTextHeight = 32,
	-- rows, cols and rowdata
	currentTableRow = {},
	currentTableCol = {},
	-- misc
	configButtonBorderSize = 2,
	scrollbarWidth = 19,
	borderSize = 3,
	buttonMinHeight = 23,
	slidercellMinHeight = 16,
	editboxMinHeight = 23,
	standardButtons_CloseBack = { close = true, back = true, minimize = false },
	standardButtons_Close = { close = true, back = false, minimize = false },
	standardIndentStep = 15,
	sidebarWidth = 40,
	frameBorder = 25,
	standardButtons_Size = 18,
	maxTableCols = 13,
	maxTextIcons = 15,
	fallbackFont = "Terrakana",
	fallbackFontBold = "Terrakana Bold",

	-- kuertee start: colour backward compatibility
	standardColor = { r = 255, g = 255, b = 255, a = 100 },
	defaultHeaderBackgroundColor = { r = 0, g = 0, b = 0, a = 60 },
	defaultSimpleBackgroundColor = { r = 66, g = 92, b = 111, a = 60 },
	defaultTitleBackgroundColor = { r = 49, g = 69, b = 83, a = 60 },
	defaultArrowRowBackgroundColor = { r = 83, g = 116, b = 139, a = 60 },
	defaultUnselectableBackgroundColor = { r = 35, g = 53, b = 71, a = 60 },
	defaultUnselectableFontColor = { r = 163, g = 193, b = 227, a = 100 },
	defaultButtonBackgroundColor = { r = 49, g = 69, b = 83, a = 60 },
	defaultUnselectableButtonBackgroundColor = { r = 31, g = 31, b = 31, a = 100 },
	defaultButtonHighlightColor = { r = 71, g = 136, b = 184, a = 100 },
	defaultUnselectableButtonHighlightColor = { r = 80, g = 80, b = 80, a = 100 },
	defaultCheckBoxBackgroundColor = { r = 66, g = 92, b = 111, a = 100 },
	defaultEditBoxBackgroundColor = { r = 49, g = 69, b = 83, a = 60 },
	defaultSliderCellBackgroundColor = { r = 22, g = 34, b = 41, a = 60 },
	defaultSliderCellInactiveBackgroundColor = { r = 40, g = 40, b = 40, a = 60 },
	defaultSliderCellValueColor = { r = 99, g = 138, b = 166, a = 100 },
	defaultSliderCellPositiveValueColor = { r = 29, g = 216, b = 35, a = 30 },
	defaultSliderCellNegativeValueColor = { r = 216, g = 68, b = 29, a = 30 },
	defaultStatusBarValueColor = { r = 71, g = 136, b = 184, a = 100 },
	defaultStatusBarPosChangeColor = { r = 20, g = 222, b = 20, a = 30 },
	defaultStatusBarNegChangeColor = { r = 236, g = 53, b = 0, a = 30 },
	defaultStatusBarMarkerColor = { r = 151, g = 192, b = 223, a = 100 },
	defaultBoxTextBoxColor = { r = 49, g = 69, b = 83, a = 60 },
	defaultFlowchartOutlineColor = { r = 90, g = 146, b = 186, a = 100 },			-- light cyan
	defaultFlowchartBackgroundColor = { r = 25, g = 25, b = 25, a = 100 },			-- dark grey
	defaultFlowchartValueColor = { r = 0, g = 116, b = 153, a = 100 },				-- cyan
	defaultFlowchartSlider1Color = { r = 225, g = 149, b = 0, a = 100 },			-- orange
	defaultFlowchartDiff1Color = { r = 89, g = 52, b = 0, a = 100 },				-- brown
	defaultFlowchartSlider2Color = { r = 66, g = 171, b = 61, a = 100 },			-- green
	defaultFlowchartDiff2Color = { r = 4, g = 89, b = 0, a = 100 },					-- dark green
	defaultFlowchartConnector1Color = { r = 255, g = 220, b = 0, a = 100 },			-- yellow
	defaultFlowchartConnector2Color = { r = 0, g = 154, b = 204, a = 100 },			-- light cyan
	defaultFlowchartConnector3Color = { r = 224, g = 79, b = 0, a = 100 },			-- dark orange
	defaultFlowchartConnector4Color = { r = 255, g = 153, b = 255, a = 100 },		-- pink
	defaultTitleTrapezoidBackgroundColor = { r = 66, g = 92, b = 111, a = 100 },
	statusRed = {r = 255, g = 0, b = 0, a = 100},
	statusOrange = {r = 255, g = 64, b = 0, a = 100},
	statusYellow = {r = 255, g = 255, b = 0, a = 100},
	statusGreen = {r = 0, g = 255, b = 0, a = 100},
	-- kuertee end: colour backward compatibility

}

Helper.titleTextProperties = {
	font = Helper.titleFont,
	fontsize = Helper.titleFontSize,
	x = Helper.titleOffsetX,
	y = Helper.titleOffsetY,
	height = Helper.titleHeight,
	halign = "center",
	cellBGColor = Color["row_background"],
	titleColor = Color["row_title"],
}
Helper.headerRow1Properties = {
	font = Helper.headerRow1Font,
	fontsize = Helper.headerRow1FontSize,
	x = Helper.headerRow1Offsetx,
	y = Helper.headerRow1Offsety,
	height = Helper.headerRow1Height - Helper.headerRow1Offsety,
	cellBGColor = Color["row_background"],
	titleColor = Color["row_title"],
}
Helper.headerRowCenteredProperties = {
	font = Helper.headerRow1Font,
	fontsize = Helper.headerRow1FontSize,
	x = Helper.headerRow1Offsetx,
	y = Helper.headerRow1Offsety,
	height = Helper.headerRow1Height - Helper.headerRow1Offsety,
	halign = "center",
	cellBGColor = Color["row_background"],
	titleColor = Color["row_title"],
}
Helper.subHeaderTextProperties = {
	font = Helper.titleFont,
	fontsize = Helper.standardFontSize,
	height = Helper.subHeaderHeight,
	cellBGColor = Color["row_background"],
	titleColor = Color["row_title"],
}

-- kuertee start: colour backward compatibility
Helper.color = {
	black = { r = 0, g = 0, b = 0, a = 100 },
	slidervalue = { r = 71, g = 136, b = 184, a = 100 },
	green = { r = 0, g = 255, b = 0, a = 100 },
	playergreen = { r = 170, g = 255, b = 139, a = 100 },
	grey = { r = 128, g = 128, b = 128, a = 100 },
	lightgreen = { r = 100, g = 225, b = 0, a = 100 },
	lightgrey = { r = 192, g = 192, b = 192, a = 100 },
	orange = { r = 255, g = 192, b = 0, a = 100 },
	darkorange = { r = 128, g = 95, b = 0, a = 100 },
	red = { r = 255, g = 0, b = 0, a = 100 },
	semitransparent = { r = 0, g = 0, b = 0, a = 95 },
	transparent60 = { r = 0, g = 0, b = 0, a = 60 },
	transparent = { r = 0, g = 0, b = 0, a = 0 },
	white = { r = 255, g = 255, b = 255, a = 100 },
	yellow = { r = 144, g = 144, b = 0, a = 100 },
	brightyellow = { r = 255, g = 255, b = 0, a = 100 },
	warning = { r = 192, g = 192, b = 0, a = 100 },
	done = { r = 38, g = 61, b = 78, a = 100 },
	available = { r = 7, g = 29, b = 46, a = 100 },
	darkgrey = { r = 32, g = 32, b = 32, a = 100 },
	mission = { r = 255, g = 190, b = 0, a = 100 },
	warningorange = { r = 255, g = 138, b = 0, a = 100 },
	blue = { r = 90, g = 146, b = 186, a = 100 },
	changedvalue = { r = 255, g = 236, b = 81, a = 100 },
	cyan = { r = 46, g = 209, b = 255, a = 100 },
	checkboxgroup = { r = 0, g = 102, b = 238, a = 60 },
	unselectable = { r = 32, g = 32, b = 32, a = 100 },
	cover = { r = 231, g = 244, b = 70, a = 100 },
	textred = { r = 255, g = 80, b = 80, a = 100 },
	grey64 = { r = 64, g = 64, b = 64, a = 100 },
	illegal = { r = 255, g = 64, b = 0, a = 100 },
	illegaldark = { r = 128, g = 32, b = 0, a = 100 },
}
-- kuertee end: colour backward compatibility

Helper.intersectorDefenceFactor = 3000

Helper.excludeFromMouseEmulation = {
	["OptionsMenu"] = function () return C.IsStartmenu() end,
	["TopLevelMenu"] = true,
}

Helper.classOrder = {
	["station"]		= 1,
	["ship_xl"]		= 2,
	["ship_l"]		= 3,
	["ship_m"]		= 4,
	["ship_s"]		= 5,
	["ship_xs"]		= 6,
	["spacesuit"]	= 7,
}
Helper.purposeOrder = {
	["fight"]		= 1,
	["auxiliary"]	= 2,
	["build"]		= 3,
	["mine"]		= 4,
	["dismantling"] = 5,
	["salvage"]		= 6,
	["trade"]		= 7,
}
Helper.raceSorting = {
	["argon"] = 1,
	["teladi"] = 2,
	["paranid"] = 3,
	["split"] = 4,
	["terran"] = 5,
}
Helper.genderSorting = {
	["female"] = 1,
	["male"] = 2,
}

Helper.slotSizeOrder = {
	["extralarge"]	= 1,
	["large"]		= 2,
	["medium"]		= 3,
	["small"]		= 4,
}

Helper.slotTypeOrder = {
	["shields"]		= 1,
	["engines"]		= 2,
	["turrets"]		= 3
}

-- forward declarations of local functions
local onUpdate								-- global function calling the callbacks below

local onUpdateHandler = nil					-- a callback function to be called once per frame in onUpdate() when assigned to this variable
local onChatUpdateHandler = nil				-- a callback function to be called once per frame in onUpdate() when assigned to this variable
local onUpdateOneTimeCallbacks = {}			-- list of callbacks to be called a single time on the next onUpdate()

local getSectionBaseParam

local closeMenu

-- kuertee start:
local callbacks = {}
-- kuertee end

local function init()
	SetScript("onUpdate", onUpdate)
	
	RegisterEvent("playerUndock", function () Helper.isPlayerUndocking = true end)
	RegisterEvent("playerUndocked", function () Helper.isPlayerUndocking = nil end)
	RegisterEvent("textdbreload", function () Helper.texts = {} end)

	C.ClearTrackedMenus()

	if Menus then
		-- Register menus that have been initialized before Helper
		-- (menus that are initialized after Helper have to call Helper.registerMenu() themselves)
		for _, menu in ipairs(Menus) do
			Helper.registerMenu(menu)
		end
	end

	Helper.viewWidth, Helper.viewHeight = GetWidgetSystemSize()
	Helper.uiScale = C.GetUIScale(C.IsVRMode())

	Helper.createTopLevelConfig()
	Helper.createPlayerInfoConfig()

	-- kuertee start:
	Helper.init_kuertee()
	-- kuertee end
end

-- kuertee start:
Helper.time_kuerteeInited = nil
function Helper.init_kuertee ()
	Helper.time_kuerteeInited = GetCurRealTime()
	Helper.loadModLuas("Helper", "helper_uix")
	Helper.SWIUI_Init()
	-- DebugError("uix load success: " .. tostring(debug.getinfo(1).source))
end
-- kuertee end

---------------------------------------------------------------------------------
-- Wrapper
---------------------------------------------------------------------------------

Helper.texts  = {}
local origreadtext = ReadText
ReadText = function(page, line) 
	-- kuertee start:
	if page and line then
		local refstr = page .. "-" .. line
		local text = Helper.texts[refstr]
		if not text then
			text = origreadtext(page, line)
			Helper.texts[refstr] = text
		end
		return text
	else
		return ""
	end
	-- kuertee end
end

---------------------------------------------------------------------------------
-- Scaling
---------------------------------------------------------------------------------

function Helper.round(x, digits)
	local mult = 1
	if digits and digits > 0 then
		mult = 10^digits
	end
	if x == nil then
		DebugError("Invalid number provided to Helper.round().")
		DebugError(TraceBack())
	else
		return math.floor(x * mult + 0.5) / mult
	end
end

function Helper.scaleX(x, enabled)
	if enabled ~= false then
		return Helper.round(x * Helper.uiScale)
	end
	return Helper.round(x)
end

function Helper.scaleY(y, enabled)
	if enabled ~= false then
		return Helper.round(y * Helper.uiScale)
	end
	return Helper.round(y)
end

function Helper.scaleFont(fontname, fontsize, enabled)
	-- the enable argument was added for consistency with the other scale-functions
	-- TODO: review whether that is reasonable - i.e. should there ever be a scaleFont() call with enabled being set to false?
	if enabled ~= false then
		-- note: this is inconsistent with the usual fontsize scale behavior (which is to use the floating point fontsize rather than applying a rounding logic in the caller)
		--       it was left unchanged however, since it might result in issues throughout menus and hence should be reviewed by someone at some point --- it's suggested to simply
		--       return fontsize * Helper.uiScale
		--       This will make a difference of 1pt for fontsizes at most (i.e. a fontsize of 15.4 becomes 16 by the current logic; when passing in 15.4 as the fontsize this would become
		--       15 however)
		-- TODO: review eventually
		return math.ceil(fontsize * Helper.uiScale)
	end
	return fontsize
end

function Helper.getRelativeRenderTargetSize(menu, layer, rendertarget)
	local renderX0, renderX1, renderY0, renderY1

	local rendertargetWidth, rendertargetHeight = GetSize(rendertarget)
	local rendertargetOffsetX, rendertargetOffsetY = GetOffset(rendertarget)
	rendertargetOffsetX = rendertargetOffsetX + menu.frameData[layer].x
	rendertargetOffsetY = rendertargetOffsetY + menu.frameData[layer].y

	renderX0 = 2 * (rendertargetOffsetX / Helper.viewWidth) - 1
	renderX1 = 2 * (rendertargetWidth + rendertargetOffsetX) / Helper.viewWidth - 1
	renderY0 = 1 - 2 * (rendertargetHeight + rendertargetOffsetY) / Helper.viewHeight
	renderY1 = 1 - 2 * (rendertargetOffsetY / Helper.viewHeight)

	return renderX0, renderX1, renderY0, renderY1
end

---------------------------------------------------------------------------------
-- Supported savegame filenames
---------------------------------------------------------------------------------

Helper.validSaveFilenames = {}
Helper.validSaveFilenames["online_save"] = true
Helper.validSaveFilenames["quicksave"] = true
for i = 1, 3 do
	Helper.validSaveFilenames[string.format("autosave_%02d", i)] = true
end

-- kuertee start: more save games
-- for i = 1, 10 do
Helper.maxSaveFiles = 20
for i = 1, Helper.maxSaveFiles do
-- kuertee end: more save games
	Helper.validSaveFilenames[string.format("save_%03d", i)] = true
end

---------------------------------------------------------------------------------
-- empty cell descriptors
---------------------------------------------------------------------------------

local emptyText = {
	text = "",
	alignment = Helper.standardHalignment,
	color = Color["text_normal"],
	fontname = Helper.standardFont,
	fontsize = Helper.standardFontSize,
	wordwrap = false,
	offset = { x = Helper.standardTextOffsetx, y = Helper.standardTextOffsety },
	size = { width = 0, height = 0 },
}
Helper.emptyCellDescriptor = CreateFontString(emptyText)

function Helper.getEmptyCellDescriptor()
	return Helper.emptyCellDescriptor
end

---------------------------------------------------------------------------------
-- current table selection
---------------------------------------------------------------------------------

Helper.currentTableRow = {}
Helper.currentTableCol = {}

---------------------------------------------------------------------------------
-- Menu registration and function hook management
---------------------------------------------------------------------------------

function onUpdate()
	-- call registered onUpdate callbacks
	if #onUpdateOneTimeCallbacks > 0 then
		-- clear list of one-time callbacks before calling them
		local currentcallbacks = onUpdateOneTimeCallbacks
		onUpdateOneTimeCallbacks = {}
		for _, callback in ipairs(currentcallbacks) do
			callback()
		end
	end
	if onUpdateHandler then
		onUpdateHandler()
	end
	if onChatUpdateHandler then
		onChatUpdateHandler()
	end

	-- kuertee start: init mod luas after loading the last one
	local curRealTime = GetCurRealTime()
	if Helper.time_initModLuasNow and curRealTime > Helper.time_initModLuasNow then
		Helper.time_initModLuasNow = nil
		-- for menuName_inList, menuData in pairs(Helper.modLuas) do
		-- 	Helper.debugText_forced(menuName_inList)
		-- end
		Helper.initModLuas2()
	elseif Helper.time_kuerteeInited and curRealTime > Helper.time_kuerteeInited + 2 then
		Helper.time_kuerteeInited = nil
		Helper.initModLuas2()
	end
	-- kuertee end: init mod luas after loading the last one

	-- kuertee start: callback
	if callbacks ["onUpdate"] then
		for _, callback in ipairs (callbacks ["onUpdate"]) do
			name = callback ()
		end
	end
	-- kuertee end: callback
end

local function createCustomHooks(menu)
	menu.rowChanged = function(uitable, row, modified, input, source)
							Helper.currentTableRow[uitable] = row
							-- row data is data provided in addRow(), or nil otherwise
							local rowdata = menu.rowDataMap[uitable] and menu.rowDataMap[uitable][row]
							local layer = Helper.findFrameLayer(menu, uitable)
							if menu.onRowChangedSound then
								menu.onRowChangedSound(row, rowdata, uitable, layer, modified, input, source)
							elseif (menu.frames[layer] == GetActiveFrame()) and (uitable == GetInteractiveObject(menu.frames[layer])) then
								PlaySound("ui_positive_hover_normal")
							end
							menu.sound_rowChanged[uitable] = getElapsedTime()
							if menu.onRowChanged then
								menu.onRowChanged(row, rowdata, uitable, modified, input, source)
							end
						end
	menu.colChanged = function(uitable, col)
							local layer = Helper.findFrameLayer(menu, uitable)
							if menu.onColChangedSound then
								menu.onColChangedSound(Helper.currentTableRow[uitable], col, uitable)
							elseif (menu.frames[layer] == GetActiveFrame()) and (uitable == GetInteractiveObject(menu.frames[layer])) then
								if (not menu.sound_rowChanged[uitable]) or (menu.sound_rowChanged[uitable] < getElapsedTime()) then
									PlaySound("ui_positive_hover_normal")
								end
							end
							Helper.currentTableCol[uitable] = col
							if menu.onColChanged then
								menu.onColChanged(Helper.currentTableRow[uitable], col, uitable)
							end
						end
	menu.selectElement = function(uitable, modified, row, isdblclick, input)
							if menu.onSelectElementSound then
								menu.onSelectElementSound()
							else
								--PlaySound("ui_table_row_select")
							end
							if menu.onSelectElement then
								menu.onSelectElement(uitable, modified, row, isdblclick, input)
							end
						end
	menu.interactiveElementChanged = function(_, element)
							if menu.onInteractiveElementChanged then
								menu.onInteractiveElementChanged(element)
							end
						end
	menu.renderTargetSelect = function(rendertarget, modified)
							if menu.onRenderTargetSelect then
								menu.onRenderTargetSelect(modified)
							end
						end
	menu.renderTargetDoubleClick = function(rendertarget, modified)
							if menu.onRenderTargetDoubleClick then
								menu.onRenderTargetDoubleClick(modified)
							end
						end
	menu.renderTargetMouseDown = function(rendertarget, modified)
							if menu.onRenderTargetMouseDown then
								menu.onRenderTargetMouseDown(modified)
							end
						end
	menu.renderTargetMouseUp = function(rendertarget, modified)
							if menu.onRenderTargetMouseUp then
								menu.onRenderTargetMouseUp(modified)
							end
						end
	menu.renderTargetMiddleMouseDown = function(rendertarget, modified)
							if menu.onRenderTargetMiddleMouseDown then
								menu.onRenderTargetMiddleMouseDown(modified)
								-- block MMB handling in input system (MMB input does not get blocked by default, unlike LMB and RMB)
								C.SetMouseInputBlockedByAnarkElement(5, modified, true)	-- 5 == MMB
							elseif menu.onRenderTargetMiddleMouseUp then
								C.SetMouseInputBlockedByAnarkElement(5, modified, true)	-- 5 == MMB
							end
						end
	menu.renderTargetMiddleMouseUp = function(rendertarget, modified)
							if menu.onRenderTargetMiddleMouseUp then
								menu.onRenderTargetMiddleMouseUp(modified)
							end
						end
	menu.renderTargetRightMouseClick = function(rendertarget, modified)
							if menu.onRenderTargetRightMouseClick then
								menu.onRenderTargetRightMouseClick(modified)
							end
						end
	menu.renderTargetRightMouseDown = function(rendertarget, modified)
							if menu.onRenderTargetRightMouseDown then
								menu.onRenderTargetRightMouseDown(modified)
							end
						end
	menu.renderTargetRightMouseUp = function(rendertarget, modified)
							if menu.onRenderTargetRightMouseUp then
								menu.onRenderTargetRightMouseUp(modified)
							end
						end
	menu.renderTargetCombinedScrollDown = function(rendertarget, step)
							if menu.onRenderTargetCombinedScrollDown then
								menu.onRenderTargetCombinedScrollDown(step)
							end
						end
	menu.renderTargetCombinedScrollUp = function(rendertarget, step)
							if menu.onRenderTargetCombinedScrollUp then
								menu.onRenderTargetCombinedScrollUp(step)
							end
						end
	menu.renderTargetScrollDown = function(rendertarget)
							if menu.onRenderTargetScrollDown then
								menu.onRenderTargetScrollDown()
							end
						end
	menu.renderTargetScrollUp = function(rendertarget)
							if menu.onRenderTargetScrollUp then
								menu.onRenderTargetScrollUp()
							end
						end
	menu.closeElement = function(widget, dueToClose)
							if menu.onCloseElementSound then
								menu.onCloseElementSound()
							else
								PlaySound("ui_menu_close")
							end
							local layer = Helper.findFrameLayer(menu, widget)
							if layer then
								if dueToClose == "auto" then
									if menu.cleanup then
										menu.cleanup()
									end
									Helper.clearMenu(menu)
								else
									menu.onCloseElement(dueToClose, layer)
								end
							end
						end
	menu.editBoxActivated = function(widget, oldtext)
							if menu.onEditBoxActivated then
								menu.onEditBoxActivated(widget, oldtext)
							end
						end
	menu.editBoxCursorChanged = function(widget)
							if menu.onEditBoxCursorChanged then
								menu.onEditBoxCursorChanged(widget)
							end
						end
	menu.editboxRightMouseClick = function(widget)
							if menu.onEditboxRightMouseClick then
								menu.onEditboxRightMouseClick(widget)
							end
						end
	menu.tableScrollBarOver = function()
							if menu.onTableScrollBarOver then
								menu.onTableScrollBarOver()
							else
								PlaySound("ui_sbar_table_over")
							end
						end
	menu.tableScrollBarDown = function()
							if menu.onTableScrollBarDown then
								menu.onTableScrollBarDown()
							else
								PlaySound("ui_sbar_table_down")
							end
						end
	menu.tableScrollBarUp = function()
							if menu.onTableScrollBarUp then
								menu.onTableScrollBarUp()
							end
						end
	menu.sliderScrollBarOver = function()
							if menu.onSliderScrollBarOver then
								menu.onSliderScrollBarOver()
							else
								PlaySound("ui_sbar_slider_over")
							end
						end
	menu.sliderScrollBarDown = function()
							if menu.onSliderScrollBarDown then
								menu.onSliderScrollBarDown()
							else
								PlaySound("ui_sbar_slider_down")
							end
						end
	menu.tableRightMouseClick = function(uitable, row, posx, posy)
							if menu.onTableRightMouseClick then
								menu.onTableRightMouseClick(uitable, row, posx, posy)
							end
						end
	menu.tableMouseOver = function(uitable, row)
							if menu.onTableMouseOver then
								menu.onTableMouseOver(uitable, row)
							end
						end
	menu.tableMouseOut = function(uitable, row)
							if menu.onTableMouseOut then
								menu.onTableMouseOut(uitable, row)
							end
						end
	menu.buttonRightMouseClick = function(button, row, col, posx, posy)
							if menu.onButtonRightMouseClick then
								menu.onButtonRightMouseClick(button, row, col, posx, posy)
							end
						end
	menu.buttonDblMouseClick = function(button)
							if menu.onButtonDblMouseClick then
								menu.onButtonDblMouseClick(button)
							end
						end
	menu.buttonOver = function(input, button)
							local uitable, row, col
							for i = 1, #menu.buttonScriptMap do
								local scriptdata = menu.buttonScriptMap[i]
								if scriptdata.button == button then
									uitable = scriptdata.tableobj
									row = scriptdata.row
									col = scriptdata.col
									break
								end
							end
							if menu.onButtonOverSound then
								menu.onButtonOverSound(uitable, row, col, button, input)
							else
								if not menu.sound_selectedelement or button ~= menu.sound_selectedelement then
									if input == "mouse" then
										if (not menu.sound_buttonOverLock) then
											PlaySound("ui_positive_hover_normal")
											menu.sound_buttonOverLock = true
										end
									end
								end
								menu.sound_selectedelement = button
							end
							if menu.onButtonOver then
								menu.onButtonOver(uitable, row, col, button, input)
							end
						end
	menu.buttonOut = function(input, button)
							menu.sound_buttonOverLock = nil
						end
	menu.buttonDown = function()
							if menu.onButtonDown then
								menu.onButtonDown()
							else
								PlaySound("ui_positive_click")
							end
						end
	menu.buttonUp = function()
							if menu.onButtonUp then
								menu.onButtonUp()
							end
						end
	-- triggers when your mouse moves away from a standard button
	menu.standardButtonOut = function()
						end
	-- triggers when your mouse moves to a position over a standard button
	menu.standardButtonOver = function()
							PlaySound("ui_btn_standard_over")
						end
	menu.checkboxOver = function()
							--PlaySound("ui_positive_hover_normal")
						end
	menu.editboxUpdateText = function(editbox, text, textchanged, wasconfirmed)
							if menu.onEditboxUpdateText then
								menu.onEditboxUpdateText(editbox, text, textchanged, wasconfirmed)
							end
						end
	menu.editboxTextChanged = function(editbox, text)
							if menu.onEditboxTextChanged then
								menu.onEditboxTextChanged(editbox, text)
							end
						end
	menu.dropdownActivated = function(dropdown)
							PlaySound("ui_positive_click")
							if menu.onDropDownActivated then
								menu.onDropDownActivated(dropdown)
							end
						end
	menu.dropdownConfirmed = function(dropdown, value)
							PlaySound("ui_positive_click")
							if menu.onDropDownConfirmed then
								menu.onDropDownConfirmed(dropdown, value)
							end
						end
	menu.dropdownRemoved = function(dropdown, value)
							if menu.onDropDownRemoved then
								menu.onDropDownRemoved(dropdown, value)
							end
						end
	menu.slidercellChanged = function(slidercell, newvalue)
						end
	menu.slidercellActivated = function(slidercell)
							if menu.onSliderCellActivated then
								menu.onSliderCellActivated(slidercell)
							end
						end
	menu.slidercellDeactivated = function(slidercell, newvalue, valuechanged)
						end
	menu.slidercellRightMouseClick = function(slidercell, row, col, posx, posy)
							if menu.onSliderCellRightMouseClick then
								menu.onSliderCellRightMouseClick(slidercell, row, col, posx, posy)
							end
						end
	menu.slidercellConfirm = function(slidercell, newvalue, valuechanged)
							if menu.onSliderCellConfirm then
								menu.onSliderCellConfirm(newvalue, valuechanged)
							end
						end
	menu.slidercellDown = function()
							if menu.onSliderCellDown then
								menu.onSliderCellDown()
							else
								PlaySound("ui_sbar_slider_down")
							end
						end
	menu.slidercellRightOver = function()
							if menu.onSliderCellRightOver then
								menu.onSliderCellRightOver()
							else
								PlaySound("ui_sbar_btn_right_over")
							end
						end
	menu.slidercellRightDown = function()
							if menu.onSliderCellRightDown then
								menu.onSliderCellRightDown()
							else
								PlaySound("ui_sbar_btn_right_down")
							end
						end
	menu.slidercellLeftOver = function()
							if menu.onSliderCellLeftOver then
								menu.onSliderCellLeftOver()
							else
								PlaySound("ui_sbar_btn_left_over")
							end
						end
	menu.slidercellLeftDown = function()
							if menu.onSliderCellLeftDown then
								menu.onSliderCellLeftDown()
							else
								PlaySound("ui_sbar_btn_left_down")
							end
						end
	menu.onConversationCancelled = function()
										if menu.onCloseElement then
											menu.onCloseElement("close", nil, true)
										end
										Helper.clearMenu(menu)
								end
	menu.onDialogOptionSelected = function()
								end
end

function Helper.registerMenu(menu)
	menu.rowDataMap = {}
	menu.frameData = {}
	menu.sound_rowChanged = {}

	createCustomHooks(menu)

	-- Create and register a closure that will be called when the menu should be started
	menu.showMenuCallback = function(...)
		if C.IsGameOver() and (menu.name ~= "OptionsMenu") and (menu.name ~= "ScenarioDebriefingMenu") then
			return
		end
		if not menu.shown then
			-- Set up menu parameters
			local name, param, param2 = GetMenuParameters2()
			if name ~= menu.name then
				-- menu parameters do not match the menu name, do not show the menu (this can happen if menus are opened in the same frame, e.g. click transporter room button and press esc)
				return
			end
			menu.param = param
			menu.param2 = param2
			if menu.name == "DockedMenu" then
				-- if there is a minimized menu, restore it instead
				if Helper.minimizedMenu then
					Helper.restoreMenu(Helper.minimizedMenu)
					return
				end
				-- if the top level tab is open, open the docked menu anyway
				if (not Helper.topLevelMenu) and View.hasMenu({ Helper = true }) then
					return
				end
				if Helper.topLevelMenu then
					local topLevelMenu = Helper.topLevelMenu
					Helper.closeMenu(topLevelMenu, "close")
					topLevelMenu.cleanup()
				end
				Helper.topLevelMenu = nil
				Helper.dockedMenu = menu
			elseif menu.name == "TopLevelMenu" then
				-- if the docked menu is open, open the top level tab anyway
				if (not Helper.dockedMenu) and View.hasMenu({ Helper = true }) then
					return
				end
				if Helper.dockedMenu then
					local dockedMenu = Helper.dockedMenu
					Helper.closeMenu(dockedMenu, "close")
					dockedMenu.cleanup()
				end
				Helper.dockedMenu = nil
				Helper.topLevelMenu = menu
				C.SkipNextStartAnimation()
			else
				if Helper.dockedMenu then
					local dockedMenu = Helper.dockedMenu
					Helper.closeMenu(dockedMenu, "close")
					dockedMenu.cleanup()
				end
				if Helper.topLevelMenu then
					local topLevelMenu = Helper.topLevelMenu
					Helper.closeMenu(topLevelMenu, "close")
					topLevelMenu.cleanup()
				end
			end

			menu.shown = true
			menu.minimized = false
			if menu.name == "OptionsMenu" then
				-- the options menu is never a conversation menu, but is allowed during inescapable conversations
				-- force flag to false so the unrelated conversations do not get returned when closing the menu
				menu.conversationMenu = false
			else
				menu.conversationMenu = C.IsConversationActive() and (not C.IsConversationCancelling())
			end
			View.clearMenus({ Helper = true })

			if menu.onUpdate then
				local nextUpdateTime = 0
				onUpdateHandler = function()
									if GetCurRealTime() >= nextUpdateTime then
										menu.onUpdate()
										nextUpdateTime = GetCurRealTime() + (menu.updateInterval or 0)
									end
								end
			end

			RegisterEvent("conversationCancelled", menu.onConversationCancelled)
			RegisterEvent("dialogOptionSelected", menu.onDialogOptionSelected)
			local state = nil
			if menu.param2 and menu.param2[1] == "restore" then
				state = menu.param2[2]
				menu.param2 = menu.param2[3]
			end
			C.TrackMenu(menu.name, true)
			AddUITriggeredEvent(menu.name, "", menu.param)
			if menu.onShowMenuSound then
				menu.onShowMenuSound()
			else
				if not C.IsNextStartAnimationSkipped(false) then
					PlaySound("ui_map_open")
				else
					PlaySound("ui_menu_changed")
				end
			end
			Helper.enableAutoMouseEmulation(menu)
			-- The actual callback
			menu.onShowMenu(state, ...)
		elseif menu.minimized then
			if onRestoreMenuSound then
				onRestoreMenuSound()
			else
				PlaySound("ui_map_open")
			end
			Helper.enableAutoMouseEmulation(menu)
			Helper.restoreMenu(menu)
		else
			if menu.name == "InteractMenu" then
				menu.onCloseElement("close")
			end
			C.SetWidgetViewScheduled(false)
		end
	end
	RegisterEvent("show"..menu.name, menu.showMenuCallback)
	if menu.name == "InteractMenu" then
		Helper.interactMenuCallbacks = {
			show = menu.showInteractMenu,
			update = menu.onUpdate,
			close = menu.onCloseElement,
		}
	elseif menu.name == "ChatWindow" then
		Helper.chatWindowCallbacks = {
			callback = menu.callback,
		}
	end
end

function Helper.enableAutoMouseEmulation(menu)
	local excludeEmulation = Helper.excludeFromMouseEmulation[menu.name]
	if type(excludeEmulation) == "function" then
		excludeEmulation = excludeEmulation()
	end
	if not excludeEmulation then
		C.EnableAutoMouseEmulation()
	end
end

function Helper.disableAutoMouseEmulation(menu)
	C.DisableAutoMouseEmulation()
end

function Helper.setChatUpdateHandler(menu)
	if menu.onUpdate then
		local nextUpdateTime = 0
		onChatUpdateHandler = function()
							if GetCurRealTime() >= nextUpdateTime then
								menu.onUpdate()
								nextUpdateTime = GetCurRealTime() + (menu.updateInterval or 0)
							end
						end
	end
end

function Helper.clearChatUpdateHandler()
	onChatUpdateHandler = nil
end

function Helper.closeMinimizedMenus()
	if Helper.minimizedMenu then
		for layer, frame in pairs(Helper.minimizedMenu.frames) do
			Helper.minimizedMenu.onCloseElement("auto", layer)
		end
		Helper.minimizedMenu = nil
	end
end

function Helper.minimizeMenu(menu, text)
	if (not menu.conversationMenu) and (not menu.minimized) then
		menu.minimized = true
		Helper.minimizedMenu = menu
		-- disable mouse emulation mode
		Helper.disableAutoMouseEmulation(menu)
		-- if a menu was minimized once forget the history of the menu so the previous will not pop-up after hours of on-off use of this menu
		menu.param2 = nil
		-- clean up scripts
		Helper.removeAllWidgetScripts(menu)
		Helper.removeAllKeyBindings(menu)
		Helper.removeAllTabScrollCallbacks(menu)
		Helper.removeAllMenuScripts(menu)
		-- unregister callbacks
		UnregisterEvent("conversationCancelled", menu.onConversationCancelled)
		UnregisterEvent("dialogOptionSelected", menu.onDialogOptionSelected)
		for layer, frame in pairs(menu.frames) do
			if IsValidWidgetElement(frame) then
				View.minimizeMenu("Helper" .. layer, text)
			end
		end
		table.insert(onUpdateOneTimeCallbacks, function ()
				for layer, frame in pairs(menu.frames) do
					if IsValidWidgetElement(frame) then
						-- rehook the onHide event to allow closing and restoring the menu
						Helper.setMenuScript(menu, layer, frame, "onHide", menu.closeElement)
					end
				end
			end
		)

		C.RemoveTrackedMenu(menu.name)

		if menu.onMinimizeMenu then
			menu.onMinimizeMenu()
		end
	end
end

function Helper.restoreMenu(menu)
	if (not menu.conversationMenu) and (menu.minimized) then
		Helper.removeAllMenuScripts(menu)
		menu.minimized = nil
		Helper.minimizedMenu = nil
		RegisterEvent("conversationCancelled", menu.onConversationCancelled)
		RegisterEvent("dialogOptionSelected", menu.onDialogOptionSelected)
		for layer, frame in pairs(menu.frames) do
			if IsValidWidgetElement(frame) then
				View.restoreMenu("Helper" .. layer)
			end
		end
		if menu.onUpdate then
			local nextUpdateTime = 0
			onUpdateHandler = function()
								if GetCurRealTime() >= nextUpdateTime then
									menu.onUpdate()
									nextUpdateTime = GetCurRealTime() + (menu.updateInterval or 0)
								end
							end
		end

		C.TrackMenu(menu.name, true)

		if menu.onRestoreMenu then
			menu.onRestoreMenu()
		end
	end
end

function Helper.clearFrame(menu, layer)
	Helper.removeAllWidgetScripts(menu, layer)
	Helper.removeAllMenuScripts(menu, layer)
	View.unregisterMenu("Helper" .. layer)
	menu.frames[layer] = nil
end

function Helper.clearMenu(menu)
	-- stop mouse emulation
	Helper.disableAutoMouseEmulation(menu)
	-- cleanup
	if menu.name == "DockedMenu" then
		Helper.dockedMenu = nil
	elseif menu.name == "TopLevelMenu" then
		Helper.topLevelMenu = nil
	end
	-- clean up scripts
	Helper.removeAllWidgetScripts(menu)
	Helper.removeAllKeyBindings(menu)
	Helper.removeAllTabScrollCallbacks(menu)
	Helper.removeAllMenuScripts(menu)
	-- unregister callbacks
	if menu.shown and (not menu.minimized) then
		UnregisterEvent("conversationCancelled", menu.onConversationCancelled)
		UnregisterEvent("dialogOptionSelected", menu.onDialogOptionSelected)
	end
	-- necessary API calls for cleanup
	for layer, frame in pairs(menu.frames) do
		if IsValidWidgetElement(frame) then
			View.unregisterMenu("Helper" .. layer)
		end
	end
	HideAllShapes()
	-- clean up table data
	menu.currentTableRow = {}
	menu.currentTableCol = {}
	menu.rowDataMap = {}
	-- clean up parameters
	menu.param = nil
	menu.param2 = nil
	menu.frames = {}
	menu.tableConnections = {}
	menu.shown = nil
	menu.defaulttable = nil
	-- reset menu update callback
	onUpdateHandler = nil
end

function Helper.findFrameLayer(menu, widget)
	for layer, frame in pairs(menu.frames) do
		if widget == frame then
			return layer
		end
		local children = table.pack(GetChildren(frame))
		for _, child in ipairs(children) do
			if child == widget then
				return layer
			end
		end
	end
end

function Helper.setMenuScript(menu, layer, obj, handleType, script)
	SetScript(obj, handleType, script)
	menu.scripts = menu.scripts or { }
	table.insert(menu.scripts, { layer = layer, obj = obj, handleType = handleType, script = script })
end

function Helper.removeMenuScript(obj, handleType, script)
	RemoveScript(obj, handleType, script)
end

function Helper.removeAllMenuScripts(menu, layer)
	menu.scripts = menu.scripts or {}
	menu.frames = menu.frames or {}
	if next(menu.frames) then
		for i = #menu.scripts, 1, -1 do
			local scriptdata = menu.scripts[i]
			if (not layer) or (layer == scriptdata.layer) then
				if menu.frames[scriptdata.layer] and IsValidWidgetElement(menu.frames[scriptdata.layer]) then
					Helper.removeMenuScript(scriptdata.obj, scriptdata.handleType, scriptdata.script)
				end
				table.remove(menu.scripts, i)
			end
		end
	end
end

function Helper.openInteractMenu(menu, param)
	Helper.closeInteractMenu()
	PlaySound("ui_positive_click")

	Helper.interactMenuCallbacks.returnToMenu = menu.onInteractMenuCallback
	Helper.interactMenuCallbacks.onTableMouseOut = menu.onTableMouseOut
	Helper.interactMenuCallbacks.onTableMouseOver = menu.onTableMouseOver

	Helper.interactMenuActive = true
	Helper.updateHandlerBackup = onUpdateHandler
	local nextUpdateTime = 0
	onUpdateHandler = function()
			if GetCurRealTime() >= nextUpdateTime then
				Helper.interactMenuCallbacks.update()
				menu.onUpdate()
				nextUpdateTime = GetCurRealTime() + (menu.updateInterval or 0)
			end
		end

	Helper.interactMenuCallbacks.show(param)
end

function Helper.returnFromInteractMenu(uitable, ...)
	if Helper.interactMenuCallbacks.onTableMouseOut then
		Helper.interactMenuCallbacks.onTableMouseOut(uitable)
	end
	if Helper.interactMenuCallbacks.returnToMenu then
		Helper.interactMenuCallbacks.returnToMenu(...)
	end
	Helper.resetInteractMenuCallbacks()
end

function Helper.closeInteractMenu()
	if Helper.interactMenuActive then
		Helper.resetUpdateHandler()
		Helper.interactMenuCallbacks.close()
		Helper.resetInteractMenuCallbacks()
		return true
	end
	return false
end

function Helper.resetUpdateHandler()
	onUpdateHandler = Helper.updateHandlerBackup
	Helper.interactMenuActive = false
end

function Helper.resetInteractMenuCallbacks()
	Helper.interactMenuCallbacks.returnToMenu = nil
	Helper.interactMenuCallbacks.onTableMouseOut = nil
	Helper.interactMenuCallbacks.onTableMouseOver = nil
end

function Helper.sendChatWindowCallback(param)
	Helper.chatWindowCallbacks.callback(param)
end

-- This or another Helper.closeMenu*() function must be called from menu.onCloseElement()
function Helper.closeMenu(menu, dueToClose, allowAutoMenu, sound)
	local resultfunc
	if allowAutoMenu == nil then
		allowAutoMenu = true
	end
	if (dueToClose == "back") then
		if menu.conversationMenu then
			resultfunc = ReturnFromMenu
			allowAutoMenu = false
		else
			if menu.param2 and (#menu.param2 > 0) then
				C.SkipNextStartAnimation()
				OpenMenu(menu.param2[1], menu.param2[2], menu.param2[3])
				allowAutoMenu = false
			elseif sound ~= false then
				PlaySound("ui_map_close")
			end
		end
	elseif (dueToClose == "close") then
		if Helper.checkDiscardStationEditorChanges(menu) then
			return
		end

		if sound ~= false then
			PlaySound("ui_map_close")
		end
		if menu.conversationMenu then
			resultfunc = CancelConversation
		end
	end
	closeMenu(menu, resultfunc, allowAutoMenu)
end

function Helper.closeMenuAndOpenNewMenu(menu, newname, param, noreturn, quickaccess)
	if menu.name ~= "TopLevelMenu" then
		C.SkipNextStartAnimation()
	end
	if not quickaccess then
		if noreturn then
			OpenMenu(newname, Helper.convertComponentIDs(param), menu.param2)
		else
			OpenMenu(newname, Helper.convertComponentIDs(param), { menu.name, menu.param, { "restore", Helper.convertComponentIDs(menu.onSaveState and menu.onSaveState() or false), menu.param2 } })
		end
	end
	closeMenu(menu, nil, false)
	if quickaccess then
		C.QuickMenuAccess(newname)
	end
end

function Helper.closeMenuAndReturn(menu, returnparam)
	closeMenu(menu, function() ReturnFromMenu(Helper.convertComponentIDs(returnparam)) end, false)
end

function Helper.closeMenuForSection(menu, nextsection, choiceparam)
	closeMenu(menu, function() ProceedFromMenu(nextsection, Helper.convertComponentIDs(choiceparam)) end, false)
end

function Helper.closeMenuForSubSection(menu, nextsection, choiceparam)
	-- Keep a copy of baseparam as upvalue because menu.param may change
	local baseparam = getSectionBaseParam(menu)
	closeMenu(menu, function() ProceedFromMenu(nextsection, Helper.convertComponentIDs(choiceparam), Helper.convertComponentIDs(baseparam)) end, false)
end

function Helper.closeMenuAndCancel(menu)
	closeMenu(menu, CancelConversation, true)
end

function Helper.closeMenuForSubConversation(menu, nextconversation, nextactor, convparam)
	-- Keep a copy of baseparam as upvalue because menu.param may change
	local baseparam = getSectionBaseParam(menu)
	closeMenu(menu, function() StartSubConversationFromMenu(nextconversation, nextactor, Helper.convertComponentIDs(convparam), Helper.convertComponentIDs(baseparam)) end, false)
end

function Helper.closeMenuForNewConversation(menu, conversation, actor, convparam, disablereturn)
	local resultfunc
	if menu.conversationMenu then
		-- TEMP Florian: Remove once menus do not open other menus via the conversation manager
		local baseparam = getSectionBaseParam(menu)
		resultfunc = function() ProceedFromMenu(conversation, Helper.convertComponentIDs(convparam), Helper.convertComponentIDs(baseparam)) end
	else
		if not disablereturn then
			Helper.addConversationReturnHandler(menu)
		end
		resultfunc = function() StartConversationFromMenu(conversation, actor, Helper.convertComponentIDs(convparam)) end
	end
	closeMenu(menu, resultfunc, false)
end

function Helper.onConversationReturned(eventname, sectionname)
	Helper.savedState = Helper.savedState or {}
	local state = Helper.savedState[1]
	if state then
		if sectionname ~= "g_cancel" then
			OpenMenu(state[1], state[2], state[3])
		end
		table.remove(Helper.savedState, 1)
	end
	UnregisterEvent("conversationCancelled", Helper.onConversationReturned)
	UnregisterEvent("conversationFinished", Helper.onConversationReturned)
	Helper.hasConversationReturnHandler = nil
end

function Helper.addConversationReturnHandler(menu)
	Helper.savedState = Helper.savedState or {}
	table.insert(Helper.savedState, 1, { menu.name, menu.param, { "restore", Helper.convertComponentIDs(menu.onSaveState and menu.onSaveState() or false), menu.param2 } })
	Helper.hasConversationReturnHandler = true
	RegisterEvent("conversationCancelled", Helper.onConversationReturned)
	RegisterEvent("conversationFinished", Helper.onConversationReturned)
end

-- Internal helper function for Helper.closeMenuForSubSection() and Helper.closeMenuForSubConversation()
function getSectionBaseParam(menu)
	-- Store menu display state (top row and select row) in baseparam
	if menu.defaulttable then
		if menu.param == nil then
			return {
				GetTopRow(menu.defaulttable),
				Helper.currentTableRow[menu.defaulttable]
			}
		end
		if type(menu.param) == "table" and type(menu.param[1]) == "number" and type(menu.param[2]) == "number" then
			menu.param[1] = GetTopRow(menu.defaulttable)
			menu.param[2] = Helper.currentTableRow[menu.defaulttable]
		end
	end
	return menu.param
end

function Helper.convertComponentIDs(input)
	local universeIDType = ffi.typeof("UniverseID")

	if ffi.istype(universeIDType, input) then
		input = ConvertStringToLuaID(tostring(input))
	elseif type(input) == "table" then
		for key, value in pairs(input) do
			input[key] = Helper.convertComponentIDs(value)
		end
	end

	return input
end

-- Internal helper function for Helper.closeMenu*()
function closeMenu(menu, resultfunc, allowAutoMenu)
	if not menu.minimized then
		C.RemoveTrackedMenu(menu.name)
	end
	AddUITriggeredEvent(menu.name, "menu_close")
	if menu.name == "DockedMenu" then
		Helper.dockedMenu = nil
		if allowAutoMenu then
			local occupiedship = ConvertStringTo64Bit(tostring(C.GetPlayerOccupiedShipID()))
			if (occupiedship ~= 0) and (not GetComponentData(occupiedship, "isdocked")) then
				OpenMenu("TopLevelMenu", { 0, 0 }, nil)
			end
		end
	elseif menu.name == "TopLevelMenu" then
		Helper.topLevelMenu = nil
	elseif allowAutoMenu and (not Helper.isPlayerUndocking) then
		local iscontrollingdockedship = false
		local occupiedship = ConvertStringTo64Bit(tostring(C.GetPlayerOccupiedShipID()))
		if (occupiedship ~= 0) then
			iscontrollingdockedship = GetComponentData(occupiedship, "isdocked")
		end
		local controlpost = ffi.string(C.GetPlayerCurrentControlGroup())
		if iscontrollingdockedship or ((controlpost ~= "") and (controlpost ~= "pilotcontrol")) then
			C.SkipNextStartAnimation()
			OpenMenu("DockedMenu", { 0, 0 }, nil)
		elseif (occupiedship ~= 0) then
			OpenMenu("TopLevelMenu", { 0, 0 }, nil)
		end
	end
	-- Wake up conversation and send menu result (even if nil or false) but only on next frame!
	-- This gives the current menu a chance to clean things up, in case the conversation decides to open another menu right away
	if resultfunc then
		table.insert(onUpdateOneTimeCallbacks, function()
							UnsuspendConversation()
							-- NOTE: This must happen AFTER UnsuspendConversation()
							resultfunc()
						end
		)
	end
	Helper.clearMenu(menu)
end

---------------------------------------------------------------------------------
-- Object descriptor creation wrappers
---------------------------------------------------------------------------------

--    [icon] = {                   -- icon and text are mutually exclusive
--        [iconID]     = string,   -- the iconID
--        [swapIconID] = string,   -- the iconID used when the button has been clicked on (optional - defaults to nil)
--        [color] = {              -- icon color (optional - defaults to no icon color)
--            [r] = number,        -- red color value 0-255
--            [g] = number,        -- green color value 0-255
--            [b] = number         -- blue color value 0-255
--            [a] = number         -- alpha value 0-100
--        },
--		  [x]		= number,	   -- x offset
--		  [y]		= number,	   -- y offset
--		  [width]	= number,	   -- width
--		  [height]	= number	   -- height
--    }
--    [icon2] = {                   -- icon and text are mutually exclusive
--        [iconID]     = string,   -- the iconID
--        [swapIconID] = string,   -- the iconID used when the button has been clicked on (optional - defaults to nil)
--        [color] = {              -- icon color (optional - defaults to no icon color)
--            [r] = number,        -- red color value 0-255
--            [g] = number,        -- green color value 0-255
--            [b] = number         -- blue color value 0-255
--            [a] = number         -- alpha value 0-100
--        },
--		  [x]		= number,	   -- x offset
--		  [y]		= number,	   -- y offset
--		  [width]	= number,	   -- width
--		  [height]	= number	   -- height
--    }
--    [text] = {                   -- text and icon are mutually exclusive
--        [text]      = string,    -- the text to be displayed
--        [alignment] = string,    -- the horizontal text alignment (optional - defaults to center)
--        [fontsize]  = number,    -- the font size
--        [fontname]    = string,  -- the font name
--        [color]        = {       -- text color
--            [r] = number,        -- red color value 0-255
--            [g] = number,        -- green color value 0-255
--            [b] = number,        -- blue color value 0-255
--            [a] = number         -- alpha value 0-100
--        },
--		  [x]		= number,	   -- x offset
--		  [y]		= number	   -- y offset
--    } 
function Helper.createButton(text, icon, noscaling, active, offsetx, offsety, width, height, color, hotkey, icon2, mouseovertext, helpoverlayid)
	local buttonDescriptor = {}
	buttonDescriptor.text = text
	buttonDescriptor.icon = icon
	buttonDescriptor.icon2 = icon2
	buttonDescriptor.mouseovertext = mouseovertext
	if helpoverlayid then
		buttonDescriptor.helpoverlay = { text = " ", id = helpoverlayid, size = { width = 0, height = 0 }, offset = { x = 0, y = 0 }, highlightOnly = true, useBackgroundSpan = false }
	end

	buttonDescriptor.color = color or Color["button_background_default"]
	buttonDescriptor.hotkey = hotkey
	if hotkey then
		if not buttonDescriptor.hotkey.x then
			buttonDescriptor.hotkey.x = math.max(0, noscaling and width or Helper.scaleX(width))
		end
		if not buttonDescriptor.hotkey.y then
			buttonDescriptor.hotkey.y = 0
		end
	end

	if not noscaling then
		if text then
			buttonDescriptor.text.fontsize = buttonDescriptor.text.fontsize and Helper.scaleFont(buttonDescriptor.text.fontname, buttonDescriptor.text.fontsize) or buttonDescriptor.text.fontsize
		end

		offsetx		= offsetx	and Helper.scaleX(offsetx)		or offsetx
		offsety		= offsety	and Helper.scaleY(offsety)		or offsety
		height		= height	and Helper.scaleY(height)		or height
		width		= width		and Helper.scaleX(width)		or width

		if icon2 then
			buttonDescriptor.icon2.width = buttonDescriptor.icon2.width and Helper.scaleX(buttonDescriptor.icon2.width) or buttonDescriptor.icon2.width
			buttonDescriptor.icon2.height = buttonDescriptor.icon2.height and Helper.scaleX(buttonDescriptor.icon2.height) or buttonDescriptor.icon2.height
			buttonDescriptor.icon2.x = buttonDescriptor.icon2.x and Helper.scaleX(buttonDescriptor.icon2.x - Helper.configButtonBorderSize) + Helper.configButtonBorderSize or buttonDescriptor.icon2.x
			buttonDescriptor.icon2.y = buttonDescriptor.icon2.y and Helper.scaleX(buttonDescriptor.icon2.y - Helper.configButtonBorderSize) + Helper.configButtonBorderSize or buttonDescriptor.icon2.y
		end
	end

	if hotkey and (height < Helper.buttonMinHeight) then
		height = Helper.buttonMinHeight
	end

	if text and width and width ~= 0 then
		buttonDescriptor.text.text = TruncateText(buttonDescriptor.text.text, buttonDescriptor.text.fontname, buttonDescriptor.text.fontsize, width - (buttonDescriptor.text.x and (2 * buttonDescriptor.text.x) or 0))
	end
	
	buttonDescriptor.active = active
	buttonDescriptor.offset = {x = offsetx, y = offsety}
	buttonDescriptor.size = {width = width , height = height}

	return CreateButton(buttonDescriptor)
end

--    [offset] = {                    -- the checkbox offset (optional - defaults to 0/0)
--        [x] = number,               -- dropdown x-offset in px - relative to the parent's upper left corner (optional - defaults to 0)
--        [y] = number                -- dropdown y-offset in px - relative to the parent's upper left corner  (optional - defaults to 0)
--    },
--    [size] = {                      -- the checkbox's dimensions (optional - defaults to parent width/height)
--        [width] =  number,          -- dropdown width (optional - defaults to parent width)
--        [height] = number,          -- dropdown height (optional - defaults to parent height)
--    },
--    [mouseovertext] = string,       -- mouse over text (optional - defaults to "")
--    [color] = {                     -- the dropdown color
--        [r] = number,               -- red color value 0-255
--        [g] = number,               -- green color value 0-255
--        [b] = number,               -- blue color value 0-255
--        [a] = number                -- alpha color value 0-100
--    },
--    [active] = boolean,             -- indicates whether the checkbox is active (optional - defaults to true),
--    [hotkey] = {                    -- information about the assigned hotkey (optional - defaults to nil)
--        [action]      = string,     -- the associated hotkey action (must correspond to a valid INPUT_STATE - for instance "INPUT_STATE_FOO")
--        [displayIcon] = boolean,    -- indicates whether the button displays the associated icon as a hotkey (defaults to false)
--        [x]           = number,     -- x offset for the hotkey icon (only used, if displayIcon is set to true)
--        [y]           = number,     -- y offset for the hotkey icon (only used, if displayIcon is set to true)
--    },
--    [icon] = {                      -- icon and text are mutually exclusive
--        [color] = {                 -- icon color
--            [r] = number,           -- red color value 0-255
--            [g] = number,           -- green color value 0-255
--            [b] = number,           -- blue color value 0-255
--            [a] = number            -- alpha color value 0-100
--        },
--        [width]  = number,          -- width for the icon element (scaled to button size if nil)
--        [height] = number,          -- height for the icon element (scaled to button size if nil)
--        [x]      = number,          -- x offset for the icon element
--        [y]      = number,          -- y offset for the icon element
--    },
--    [text] = {                      -- text and icon are mutually exclusive
--        [alignment] = string,       -- the horizontal text alignment (optional - defaults to center)
--        [fontsize]  = number,       -- the font size
--        [fontname]  = string,       -- the font name
--        [color] = {                 -- text color
--            [r] = number,           -- red color value 0-255
--            [g] = number,           -- green color value 0-255
--            [b] = number,           -- blue color value 0-255
--            [a] = number            -- alpha color value 0-100
--        },
--        [x] = number,               -- x offset for the text element
--        [y] = number,               -- y offset for the text element
--    },
--    [textoverride] = string,        -- override text
--    [text2] = {                     -- text and icon are mutually exclusive
--        [alignment] = string,       -- the horizontal text alignment (optional - defaults to center)
--        [fontsize]  = number,       -- the font size
--        [fontname]	= string,     -- the font name
--        [color]		= {           -- text color
--            [r] = number,           -- red color value 0-255
--            [g] = number,           -- green color value 0-255
--            [b] = number,           -- blue color value 0-255
--            [a] = number            -- alpha color value 0-100
--        },
--        [x] = number,               -- x offset for the text element
--        [y] = number,               -- y offset for the text element
--    },
--    [text2override] = string,        -- override text2
--    [options] = {                   -- the dropdown's options
--        [1] = {
--            [id]   = string,        -- option id
--            [icon] = string,        -- icon id
--            [text] = string         -- option text
--        },
--        ...
--    },
--    [startoption] = number          -- the preselected option id (optional)
function Helper.createDropDown(options, startoption, text, icon, noscaling, active, offsetx, offsety, width, height, color, hotkey, mouseovertext, optionwidth, allowmouseoverinteraction, optionheight)
	local dropdownDescriptor = {}
	dropdownDescriptor.options = options
	dropdownDescriptor.startoption = startoption or ""
	dropdownDescriptor.textoverride = ""
	dropdownDescriptor.text2override = ""
	if text then
		text.text = text.text or ""
		dropdownDescriptor.textoverride = text.override
	end
	dropdownDescriptor.text = text
	dropdownDescriptor.text2 = text
	if icon then
		icon.iconID = "solid"
	end
	dropdownDescriptor.icon = icon
	dropdownDescriptor.mouseovertext = mouseovertext

	dropdownDescriptor.color = color or Color["dropdown_background_default"]
	dropdownDescriptor.optioncolor = Color["dropdown_background_options"]
	dropdownDescriptor.hotkey = hotkey
	if hotkey then
		if not dropdownDescriptor.hotkey.x then
			dropdownDescriptor.hotkey.x = math.max(0, (noscaling and width or Helper.scaleX(width)) - Helper.standardHotkeyIconSizex - 4)
		end
		if not dropdownDescriptor.hotkey.y then
			dropdownDescriptor.hotkey.y = math.max(0, (noscaling and height or Helper.scaleY(height)) - Helper.standardHotkeyIconSizey - 4)
		end
	end

	if not noscaling then
		if text then
			dropdownDescriptor.text.fontsize = dropdownDescriptor.text.fontsize and Helper.scaleFont(dropdownDescriptor.text.fontname, dropdownDescriptor.text.fontsize) or dropdownDescriptor.text.fontsize
		end

		offsetx		= offsetx	and Helper.scaleX(offsetx)		or offsetx
		offsety		= offsety	and Helper.scaleY(offsety)		or offsety
		height		= height	and Helper.scaleY(height)		or height
		width		= width		and Helper.scaleX(width)		or width
	end

	if text and width and width ~= 0 then
		--dropdownDescriptor.text.text = TruncateText(dropdownDescriptor.text.text, dropdownDescriptor.text.fontname, dropdownDescriptor.text.fontsize, width - (dropdownDescriptor.text.x and (2 * dropdownDescriptor.text.x) or 0)) TODO
	end
	
	dropdownDescriptor.active = active
	if allowmouseoverinteraction == nil then
		allowmouseoverinteraction = false
	end
	dropdownDescriptor.allowmouseoverinteraction = allowmouseoverinteraction

	dropdownDescriptor.offset = {x = offsetx, y = offsety}
	dropdownDescriptor.size = {width = width , height = height}
	dropdownDescriptor.optionwidth = optionwidth or 0
	dropdownDescriptor.optionheight = optionheight or 0

	return CreateDropDown(dropdownDescriptor)
end

--    [text] = {                   -- text and icon are mutually exclusive
--        [text]      = string,    -- the text to be displayed
--        [alignment] = string,    -- the horizontal text alignment (optional - defaults to center)
--        [fontsize]  = number,    -- the font size
--        [fontname]    = string,  -- the font name
--        [color]        = {       -- text color
--            [r] = number,        -- red color value 0-255
--            [g] = number,        -- green color value 0-255
--            [b] = number         -- blue color value 0-255
--            [a] = number         -- alpha value 0-100
--        }
--    } 
function Helper.createEditBox(text, noscaling, offsetx, offsety, width, height, color, hotkey, closemenuonback, mouseovertext, defaulttext, texthidden)
	local editboxDescriptor = {}
	editboxDescriptor.text = text
	editboxDescriptor.defaulttext = defaulttext
	editboxDescriptor.mouseovertext = mouseovertext
	editboxDescriptor.color = color or Color["editbox_background_default"]
	editboxDescriptor.hotkey = hotkey
	if hotkey then
		if not editboxDescriptor.hotkey.x then
			editboxDescriptor.hotkey.x = math.max(0, noscaling and width or Helper.scaleX(width))
		end
	end

	if not noscaling then
		if text then
			editboxDescriptor.text.fontsize = editboxDescriptor.text.fontsize and Helper.scaleFont(editboxDescriptor.text.fontname, editboxDescriptor.text.fontsize) or editboxDescriptor.text.fontsize
		end

		offsetx		= offsetx	and Helper.scaleX(offsetx)		or offsetx
		offsety		= offsety	and Helper.scaleY(offsety)		or offsety
		height		= height	and Helper.scaleY(height)		or height
		width		= width		and Helper.scaleX(width)		or width
	end
	
	editboxDescriptor.offset = {x = offsetx, y = offsety}
	editboxDescriptor.size = {width = width , height = height}
	editboxDescriptor.closemenu = closemenuonback
	editboxDescriptor.texthidden = texthidden

	return CreateEditBox(editboxDescriptor)
end

function Helper.createTextInfo(text, alignment, fontname, fontsize, red, green, blue, alpha, offsetx, offsety)
	return {text = text, alignment = alignment, fontname = fontname, fontsize = fontsize, color = {r = red, g = green, b = blue, a = alpha}, x = offsetx, y = offsety}
end

function Helper.createButtonIcon(icon, swapicon, red, green, blue, alpha, width, height, offsetx, offsety)
	if width and height then
		width = width - 2 * Helper.configButtonBorderSize
		height = height - 2 * Helper.configButtonBorderSize
		if offsetx then
			offsetx = offsetx + Helper.configButtonBorderSize
		end
		if offsety then
			offsety = offsety + Helper.configButtonBorderSize
		end
	end
	return {iconID = icon, swapIconID = swapicon, color = {r = red, g = green, b = blue, a = alpha}, width = width, height = height, x = offsetx, y = offsety}
end

-- slidercellDescription = {
--		[offset] = {				-- the slider offset (optional - defaults to 0/0)
--			[x] = number,			-- slider x-offset in px - relative to the parent's upper left corner (optional - defaults to 0)
--			[y] = number			-- slider y-offset in px - relative to the parent's upper left corner  (optional - defaults to 0)
--		},
--		[size] = {					-- the slider's dimensions (optional - defaults to parent width/height)
--			[width] = number,		-- slider width (optional - defaults to parent width)
--			[height] = number,		-- slider height (optional - defaults to parent height)
--		},
--		[bgcolor] = {				-- the background color
--			[r] = number,			-- red color value 0-255
--			[g] = number,			-- green color value 0-255
--			[b] = number,			-- blue color value 0-255
--			[a] = number			-- alpha color value 0-100
--		},
--		[valuecolor] = {			-- the value color
--			[r] = number,			-- red color value 0-255
--			[g] = number,			-- green color value 0-255
--			[b] = number,			-- blue color value 0-255
--			[a] = number			-- alpha color value 0-100
--		},
--		[negativevaluecolor] = {	-- the value color for negative values (optional - defaults to valuecolor)
--			[r] = number,			-- red color value 0-255
--			[g] = number,			-- green color value 0-255
--			[b] = number,			-- blue color value 0-255
--			[a] = number			-- alpha color value 0-100
--		},
--		[text] = {					-- the slider text 
--			[text]      = string,	-- the text to be displayed
--			[fontsize]  = number,	-- the font size
--			[fontname]	= string,	-- the font name
--			[color]		= {			-- text color
--				[r] = number,		-- red color value 0-255
--				[g] = number,		-- green color value 0-255
--				[b] = number,		-- blue color value 0-255
--				[a] = number		-- alpha color value 0-100
--			}
--		},
--		[scale] = {					-- scale setup
--			[min]	= number,		-- minimum value
--			[minselect] = number,	-- min selectable value (optional, defaults to min)
--			[max]	= number,		-- maximum value
--			[maxselect] = number,	-- max selectable value (optional, defaults to max - do not use with exceedmax)
--			[start]	= number,		-- start value
--			[step]	= number,		-- step size
--			[suffix] = string,		-- suffix to be displayed
--			[exceedmax] = bool		-- allow player to exceed the max value (requires min >= 0)
--			[hidemaxvalue] = bool	-- Hide the max value in the number display
--			[righttoleft] = bool	-- Right-to-left (mirrored) scale
--			[fromcenter] = bool		-- Slider bar extends from zero in the center
--			[readonly] = bool		-- Slider is read-only (non-interactive), only used as output
--		}
-- }
function Helper.createSliderCell(text, noscaling, offsetx, offsety, width, height, bgcolor, valuecolor, scale, mouseovertext)
	local slidercellDescriptor = {}
	slidercellDescriptor.text = text
	slidercellDescriptor.mouseovertext = mouseovertext
	slidercellDescriptor.bgcolor = bgcolor or Color["slider_background_default"]
	slidercellDescriptor.inactivebgcolor = Color["slider_background_inactive"]
	if not valuecolor and scale.fromcenter then
		slidercellDescriptor.valuecolor = Color["slider_diff_pos"]
		slidercellDescriptor.negativevaluecolor = Color["slider_diff_neg"]
	else
		slidercellDescriptor.valuecolor = valuecolor or Color["slider_value"]
	end

	if not noscaling then
		if text then
			slidercellDescriptor.text.fontsize = slidercellDescriptor.text.fontsize and Helper.scaleFont(slidercellDescriptor.text.fontname, slidercellDescriptor.text.fontsize) or slidercellDescriptor.text.fontsize
		end

		offsetx		= offsetx	and Helper.scaleX(offsetx)		or offsetx
		offsety		= offsety	and Helper.scaleY(offsety)		or offsety
		height		= height	and Helper.scaleY(height)		or height
		width		= width		and Helper.scaleX(width)		or width
	end
	
	if height < Helper.slidercellMinHeight then
		height = Helper.slidercellMinHeight
	end

	slidercellDescriptor.offset = {x = offsetx, y = offsety}
	slidercellDescriptor.size = {width = width , height = height}

	slidercellDescriptor.scale = scale

	return CreateSliderCell(slidercellDescriptor)
end

---------------------------------------------------------------------------------
-- View descriptor creation wrappers
---------------------------------------------------------------------------------

function Helper.setScripts(menu, layer, frame, children)
	if frame then
		Helper.setMenuScript(menu, layer, frame, "onHide", menu.closeElement)
		Helper.setMenuScript(menu, layer, frame, "onInteractiveElementChanged", menu.interactiveElementChanged)
		Helper.setMenuScript(menu, layer, frame, "onStandardButtonMouseOut", menu.standardButtonOut)
		Helper.setMenuScript(menu, layer, frame, "onStandardButtonMouseOver", menu.standardButtonOver)
	end

	for _, child in ipairs(children) do
		if IsType(child, "table") then
			Helper.setMenuScript(menu, layer, child, "onClick", menu.selectElement)
			Helper.setMenuScript(menu, layer, child, "onRightClick", menu.tableRightMouseClick)
			Helper.setMenuScript(menu, layer, child, "onRowChanged", menu.rowChanged)
			Helper.setMenuScript(menu, layer, child, "onColumnChanged", menu.colChanged)
			Helper.setMenuScript(menu, layer, child, "onScrollBarOver", menu.tableScrollBarOver)
			Helper.setMenuScript(menu, layer, child, "onScrollBarDown", menu.tableScrollBarDown)
			Helper.setMenuScript(menu, layer, child, "onScrollBarUp", menu.tableScrollBarUp)
			Helper.setMenuScript(menu, layer, child, "onTableMouseOver", menu.tableMouseOver)
			Helper.setMenuScript(menu, layer, child, "onTableMouseOut", menu.tableMouseOut)
		elseif IsType(child, "rendertarget") then
			Helper.setMenuScript(menu, layer, child, "onClick", menu.renderTargetSelect)
			Helper.setMenuScript(menu, layer, child, "onDoubleClick", menu.renderTargetDoubleClick)
			Helper.setMenuScript(menu, layer, child, "onMouseDown", menu.renderTargetMouseDown)
			Helper.setMenuScript(menu, layer, child, "onMouseUp", menu.renderTargetMouseUp)
			Helper.setMenuScript(menu, layer, child, "onMiddleMouseDown", menu.renderTargetMiddleMouseDown)
			Helper.setMenuScript(menu, layer, child, "onMiddleMouseUp", menu.renderTargetMiddleMouseUp)
			Helper.setMenuScript(menu, layer, child, "onRightClick", menu.renderTargetRightMouseClick)
			Helper.setMenuScript(menu, layer, child, "onRightMouseDown", menu.renderTargetRightMouseDown)
			Helper.setMenuScript(menu, layer, child, "onRightMouseUp", menu.renderTargetRightMouseUp)
			Helper.setMenuScript(menu, layer, child, "onCombinedScrollDown", menu.renderTargetCombinedScrollDown)
			Helper.setMenuScript(menu, layer, child, "onCombinedScrollUp", menu.renderTargetCombinedScrollUp)
			-- TODO #Florian - kept for mod compatibility, remove in next project
			Helper.setMenuScript(menu, layer, child, "onScrollDown", menu.renderTargetScrollDown)
			Helper.setMenuScript(menu, layer, child, "onScrollUp", menu.renderTargetScrollUp)
		end
	end
end

function Helper.addTableDescRowDataMap(menu, desc, rowdatamap)
	menu.rowDataMapPerTableDesc = menu.rowDataMapPerTableDesc or {}
	menu.rowDataMapPerTableDesc[desc] = rowdatamap
end

function Helper.addTableIndexRowDataMap(menu, tableidx, rowdatamap)
	menu.rowDataMapPerTableIndex = menu.rowDataMapPerTableIndex or {}
	menu.rowDataMapPerTableIndex[tableidx] = rowdatamap
end

function Helper.handleTableDesc(menu, descriptors)
	local found = false
	for i, desc in ipairs(descriptors) do
		if menu.defaulttable and (desc == menu.defaulttable) then
			found = true
			menu.defaulttable = i
		end
		if menu.rowDataMapPerTableDesc[desc] then
			Helper.addTableIndexRowDataMap(menu, i, menu.rowDataMapPerTableDesc[desc])
			menu.rowDataMapPerTableDesc[desc] = nil
		end
	end

	if not found then
		menu.defaulttable = nil
	end
end

function Helper.handleCreatedTables(menu, tables)
	if menu.defaulttable then
		menu.defaulttable = tables[menu.defaulttable]
	end
	for tableidx, rowdatamap in pairs(menu.rowDataMapPerTableIndex) do
		menu.rowDataMap[tables[tableidx]] = rowdatamap
	end
	menu.rowDataMapPerTableIndex = {}
end

function Helper.clearDataForRefresh(menu, layer)
	Helper.removeAllWidgetScripts(menu, layer)
	if layer then
		if menu.frames[layer] then
			local children = table.pack(GetChildren(menu.frames[layer]))
			for _, childrenID in ipairs(children) do
				Helper.currentTableRow[childrenID] = nil
				menu.rowDataMap[childrenID] = nil
			end
		end
	else
		Helper.currentTableRow = {}
		menu.rowDataMap = {}
	end
end

function Helper.getCurrentRowData(menu, uitable)
	local row = Helper.currentTableRow[uitable]
	return menu.rowDataMap[uitable] and menu.rowDataMap[uitable][row]
end

---------------------------------------------------------------------------------
-- Draw geometry
---------------------------------------------------------------------------------

function Helper.drawLine(startpos, endpos, thickness, z, color, noscaling)
	if not thickness then
		thickness = 2
	end
	if not z then
		z = 0
	end
	if not color then
		color = Color["shape_default"]
	end

	if not noscaling then
		startpos.x = Helper.scaleX(startpos.x)
		startpos.y = Helper.scaleY(startpos.y)
		endpos.x = Helper.scaleX(endpos.x)
		endpos.y = Helper.scaleY(endpos.y)
		thickness = Helper.scaleY(thickness)
	end

	local width = math.sqrt((endpos.x - startpos.x)^2 + (endpos.y - startpos.y)^2)
	-- we have to flip start and endpos here, as we later flip the y-Axis in the coordinate transformation
	local angle = math.asin(2 * (startpos.y - endpos.y) / 2 / width)
	local height = thickness
	local offsetx = (startpos.x + endpos.x) / 2 - Helper.viewWidth / 2 - width / 2
	local offsety = Helper.viewHeight / 2 - (startpos.y + endpos.y) / 2 + height / 2

	return DrawRect(width, height, offsetx, offsety, angle, z, color)
end

function Helper.drawRectangle(width, height, offsetx, offsety, angle, z, color, noscaling)
	if not width then
		width = 1
	end
	if not height then
		height = 1
	end
	if not offsetx then
		offsetx = 0
	end
	if not offsety then
		offsety = 0
	end
	if not angle then
		angle = 0
	end
	if not z then
		z = 0
	end
	if not color then
		color = Color["shape_default"]
	end

	if not noscaling then
		width = Helper.scaleX(width)
		height = Helper.scaleY(height)
		offsetx = Helper.scaleX(offsetx)
		offsety = Helper.scaleY(offsety)
	end

	offsetx = offsetx - Helper.viewWidth / 2
	offsety = Helper.viewHeight / 2 - offsety

	return DrawRect(width, height, offsetx, offsety, math.rad(angle), z, color)
end

function Helper.drawCircle(radius, centerx, centery, z, color, noscaling)
	if not radius then
		radius = 1
	end
	if not centerx then
		centerx = 0
	end
	if not centery then
		centery = 0
	end
	if not z then
		z = 0
	end
	if not color then
		color = Color["shape_default"]
	end

	if not noscaling then
		radius = Helper.scaleY(radius)
		centerx = Helper.scaleX(centerx)
		centery = Helper.scaleY(centery)
	end

	centerx = centerx - Helper.viewWidth / 2
	centery = Helper.viewHeight / 2 - centery

	return DrawCircle(radius, radius, centerx, centery, z, color)
end

function Helper.drawEllipse(radiusx, radiusy, centerx, centery, z, color, noscaling)
	if not radiusx then
		radiusx = 1
	end
	if not radiusy then
		radiusy = 1
	end
	if not centerx then
		centerx = 0
	end
	if not centery then
		centery = 0
	end
	if not z then
		z = 0
	end
	if not color then
		color = Color["shape_default"]
	end

	if not noscaling then
		radiusx = Helper.scaleX(radiusx)
		radiusy = Helper.scaleY(radiusy)
		centerx = Helper.scaleX(centerx)
		centery = Helper.scaleY(centery)
	end

	centerx = centerx - Helper.viewWidth / 2
	centery = Helper.viewHeight / 2 - centery

	return DrawCircle(radiusx, radiusy, centerx, centery, z, color)
end

function Helper.drawTriangle(width, height, offsetx, offsety, angle, z, color, noscaling)
	if not width then
		width = 1
	end
	if not height then
		height = 1
	end
	if not offsetx then
		offsetx = 0
	end
	if not offsety then
		offsety = 0
	end
	if not angle then
		angle = 0
	end
	if not z then
		z = 0
	end
	if not color then
		color = Color["shape_default"]
	end

	if not noscaling then
		width = Helper.scaleX(width)
		height = Helper.scaleY(height)
		offsetx = Helper.scaleX(offsetx)
		offsety = Helper.scaleY(offsety)
	end

	offsetx = offsetx - Helper.viewWidth / 2
	offsety = Helper.viewHeight / 2 - offsety

	return DrawTriangle(width, height, offsetx, offsety, math.rad(angle), z, color)
end

---------------------------------------------------------------------------------
-- Table updates
---------------------------------------------------------------------------------

function Helper.setCellContent(menu, tableID, descriptor, row, column, norelease, type, id, ...)
	if menu and type then
		if type == "button" then
			Helper.removeButtonScripts(menu, tableID, row, column)
		elseif type == "editbox" then
			Helper.removeEditBoxScripts(menu, tableID, row, column)
		elseif type == "dropdown" then
			Helper.removeDropDownScripts(menu, tableID, row, column)
		elseif type == "slidercell" then
			Helper.removeSliderCellScripts(menu, tableID, row, column)
		end
	end

	local success = SetCellContent(tableID, descriptor, row, column)
	if not norelease then
		ReleaseDescriptor(descriptor)
	end

	if menu and type and (select('#', ...) > 0) then
		if type == "button" then
			Helper.setButtonScript(menu, id, tableID, row, column, ...)
		elseif type == "editbox" then
			Helper.setEditBoxScript(menu, id, tableID, row, column, ...)
		elseif type == "dropdown" then
			Helper.setDropDownScript(menu, id, tableID, row, column, ...)
		elseif type == "slidercell" then
			Helper.setSliderCellScript(menu, id, tableID, row, column, ...)
		end
	end

	return success
end

function Helper.updateCellText(tableobj, row, col, newtext, newcolor)
	local cell = GetCellText(tableobj, row, col)
	if not cell then
		print("updateCellText Error: ", tableobj, row, col, newtext, newcolor)
	else
		SetText(cell, newtext)
		if newcolor then
			SetTextColor(cell, newcolor.r, newcolor.g, newcolor.b, newcolor.a)
		end
	end
end

function Helper.updateButtonColor(tableobj, row, col, newcolor)
	local cell = GetCellContent(tableobj, row, col)
	SetButtonColor(cell, newcolor.r, newcolor.g, newcolor.b, newcolor.a)
end

function Helper.updateEditBoxText(tableobj, row, col, newtext)
	local cell = GetCellContent(tableobj, row, col)
	C.SetEditBoxText(cell, newtext)
end

function Helper.setButtonScript(menu, id, tableobj, row, col, script, onRightClickScript, onDblClickScript)
	menu.buttonScriptMap = menu.buttonScriptMap or { }
	local layer = Helper.findFrameLayer(menu, tableobj)

	local overSoundMouse = function (...) return menu.buttonOver("mouse", ...) end
	local overSoundKeyboard = function (...) return menu.buttonOver("keyboard", ...) end
	local outSoundMouse = function (...) return menu.buttonOut("mouse", ...) end
	local downSound = menu.buttonDown
	local upSound = menu.buttonUp
	if onRightClickScript == nil then
		onRightClickScript = menu.buttonRightMouseClick
	end
	if onDblClickScript == nil then
		onDblClickScript = menu.buttonDblMouseClick
	end

	local scriptWrapper = function (...)
		if id then
			AddUITriggeredEvent(menu.name, id)
		end
		if script then
			return script(...)
		end
	end

	local cell = GetCellContent(tableobj, row, col)

	table.insert(menu.buttonScriptMap, { layer = layer, tableobj = tableobj, button = cell, row = row, col = col, type = "onClick", script = scriptWrapper })
	table.insert(menu.buttonScriptMap, { layer = layer, tableobj = tableobj, button = cell, row = row, col = col, type = "onDoubleClick", script = onDblClickScript })
	table.insert(menu.buttonScriptMap, { layer = layer, tableobj = tableobj, button = cell, row = row, col = col, type = "onRightClick", script = onRightClickScript })
	table.insert(menu.buttonScriptMap, { layer = layer, tableobj = tableobj, button = cell, row = row, col = col, type = "onButtonMouseOver", script = overSoundMouse })
	table.insert(menu.buttonScriptMap, { layer = layer, tableobj = tableobj, button = cell, row = row, col = col, type = "onButtonMouseOut", script = outSoundMouse })
	table.insert(menu.buttonScriptMap, { layer = layer, tableobj = tableobj, button = cell, row = row, col = col, type = "onButtonSelect", script = overSoundKeyboard })
	table.insert(menu.buttonScriptMap, { layer = layer, tableobj = tableobj, button = cell, row = row, col = col, type = "onButtonDown", script = downSound })
	table.insert(menu.buttonScriptMap, { layer = layer, tableobj = tableobj, button = cell, row = row, col = col, type = "onButtonUp", script = upSound })

	SetScript(cell, "onClick", scriptWrapper)
	SetScript(cell, "onDoubleClick", onDblClickScript)
	SetScript(cell, "onRightClick", onRightClickScript)
	SetScript(cell, "onButtonMouseOver", overSoundMouse)
	SetScript(cell, "onButtonMouseOut", outSoundMouse)
	SetScript(cell, "onButtonSelect", overSoundKeyboard)
	SetScript(cell, "onButtonDown", downSound)
	SetScript(cell, "onButtonUp", upSound)
end

function Helper.setCheckBoxScript(menu, id, tableobj, row, col, script)
	menu.checkboxScriptMap = menu.checkboxScriptMap or {}
	local layer = Helper.findFrameLayer(menu, tableobj)

	local scriptWrapper = function (widgetid, checked, ...)
		if id then
			AddUITriggeredEvent(menu.name, id, checked)
		end
		PlaySound("ui_positive_click")
		return script(widgetid, checked, ...)
	end

	table.insert(menu.checkboxScriptMap, { layer = layer, tableobj = tableobj, row = row, col = col, type = "onClick", script = scriptWrapper })
	table.insert(menu.checkboxScriptMap, { layer = layer, tableobj = tableobj, row = row, col = col, type = "onCheckBoxMouseOver", script = menu.checkboxOver })
	table.insert(menu.checkboxScriptMap, { layer = layer, tableobj = tableobj, row = row, col = col, type = "onCheckBoxSelect", script = menu.checkboxOver })

	local cell = GetCellContent(tableobj, row, col)
	SetScript(cell, "onClick", scriptWrapper)
	SetScript(cell, "onCheckBoxMouseOver", menu.checkboxOver)
	SetScript(cell, "onCheckBoxSelect", menu.checkboxOver)
end

function Helper.setDropDownScript(menu, id, tableobj, row, col, activateScript, confirmScript, removedScript)
	menu.dropdownScriptMap = menu.dropdownScriptMap or {}
	local layer = Helper.findFrameLayer(menu, tableobj)

	if not activateScript then
		activateScript = menu.dropdownActivated
	end
	if not confirmScript then
		confirmScript = menu.dropdownConfirmed
	end
	if not removedScript then
		removedScript = menu.dropdownRemoved
	end

	local activateWrapper = function (widgetid, ...)
		if id then
			AddUITriggeredEvent(menu.name, id, "activated")
		end
		if activateScript then
			return activateScript(widgetid, value, ...)
		end
	end

	local scriptWrapper = function (widgetid, value, ...)
		if id then
			AddUITriggeredEvent(menu.name, id, value)
		end
		if confirmScript then
			return confirmScript(widgetid, value, ...)
		end
	end

	table.insert(menu.dropdownScriptMap, { layer = layer, tableobj = tableobj, row = row, col = col, type = "onDropDownActivated", script = activateWrapper })
	table.insert(menu.dropdownScriptMap, { layer = layer, tableobj = tableobj, row = row, col = col, type = "onDropDownConfirmed", script = scriptWrapper })
	table.insert(menu.dropdownScriptMap, { layer = layer, tableobj = tableobj, row = row, col = col, type = "onDropDownRemoved", script = removedScript })

	local cell = GetCellContent(tableobj, row, col)
	SetScript(cell, "onDropDownActivated", activateWrapper)
	SetScript(cell, "onDropDownConfirmed", scriptWrapper)
	SetScript(cell, "onDropDownRemoved", removedScript)
end

function Helper.setEditBoxScript(menu, id, tableobj, row, col, script, textchangedscript, activatedscript, cursorchangedscript)
	menu.editboxScriptMap = menu.editboxScriptMap or { }
	local layer = Helper.findFrameLayer(menu, tableobj)

	if not script then
		script = menu.editboxUpdateText
	end
	if not textchangedscript then
		textchangedscript = menu.editboxTextChanged
	end
	if not activatedscript then
		activatedscript = menu.editBoxActivated
	end
	if not cursorchangedscript then
		cursorchangedscript = menu.editBoxCursorChanged
	end
	local onRightClickScript = menu.buttonRightMouseClick

	local scriptWrapper = function (...)
		if id then
			AddUITriggeredEvent(menu.name, id)
		end
		return script(...)
	end

	table.insert(menu.editboxScriptMap, { layer = layer, tableobj = tableobj, row = row, col = col, type = "onEditBoxDeactivated", script = scriptWrapper })
	table.insert(menu.editboxScriptMap, { layer = layer, tableobj = tableobj, row = row, col = col, type = "onTextChanged", script = textchangedscript })
	table.insert(menu.editboxScriptMap, { layer = layer, tableobj = tableobj, row = row, col = col, type = "onCursorChanged", script = cursorchangedscript })
	table.insert(menu.editboxScriptMap, { layer = layer, tableobj = tableobj, row = row, col = col, type = "onEditBoxActivated", script = activatedscript })
	table.insert(menu.editboxScriptMap, { layer = layer, tableobj = tableobj, row = row, col = col, type = "onRightClick", script = onRightClickScript })
		
	local cell = GetCellContent(tableobj, row, col)
	SetScript(cell, "onEditBoxDeactivated", scriptWrapper)
	SetScript(cell, "onTextChanged", textchangedscript)
	SetScript(cell, "onCursorChanged", cursorchangedscript)
	SetScript(cell, "onEditBoxActivated", activatedscript)
	SetScript(cell, "onRightClick", onRightClickScript)
end

function Helper.confirmEditBoxInput(tableobj, row, col)
	local cell = GetCellContent(tableobj, row, col)
	ConfirmEditBoxInput(cell)
end

function Helper.cancelEditBoxInput(tableobj, row, col)
	local cell = GetCellContent(tableobj, row, col)
	CancelEditBoxInput(cell)
end

function Helper.activateEditBox(tableobj, row, col, cursorpos, shiftstartpos)
	local cell = GetCellContent(tableobj, row, col)
	ActivateEditBox(cell, cursorpos, shiftstartpos)
end

function Helper.setGraphScript(menu, id, tableobj, row, col, script)
	menu.graphScriptMap = menu.graphScriptMap or {}
	local layer = Helper.findFrameLayer(menu, tableobj)

	local scriptWrapper = function (...)
		if id then
			AddUITriggeredEvent(menu.name, id)
		end
		PlaySound("ui_positive_click")
		if script then
			return script(...)
		end
	end

	table.insert(menu.graphScriptMap, { layer = layer, tableobj = tableobj, row = row, col = col, type = "onClick", script = scriptWrapper })

	local cell = GetCellContent(tableobj, row, col)
	SetScript(cell, "onClick", scriptWrapper)
end

function Helper.closeDropDownOptions(tableobj, row, col)
	local cell = GetCellContent(tableobj, row, col)
	CloseDropDownOptions(cell)
end

function Helper.setSliderCellScript(menu, id, tableobj, row, col, changedScript, activateScript, deactivateScript, onRightClickScript, confirmScript)
	menu.slidercellScriptMap = menu.slidercellScriptMap or {}
	local layer = Helper.findFrameLayer(menu, tableobj)
	
	if not changedScript then
		changedScript = menu.slidercellChanged
	end
	if not activateScript then
		activateScript = menu.slidercellActivated
	end
	if not deactivateScript then
		deactivateScript = menu.slidercellDeactivated
	end
	if not onRightClickScript then
		onRightClickScript = menu.slidercellRightMouseClick
	end
	if not confirmScript then
		confirmScript = menu.slidercellConfirm
	end
	
	table.insert(menu.slidercellScriptMap, { layer = layer, tableobj = tableobj, row = row, col = col, type = "onSliderCellChanged", script = changedScript })
	table.insert(menu.slidercellScriptMap, { layer = layer, tableobj = tableobj, row = row, col = col, type = "onSliderCellActivated", script = activateScript })
	table.insert(menu.slidercellScriptMap, { layer = layer, tableobj = tableobj, row = row, col = col, type = "onSliderCellDeactivated", script = deactivateScript })
	table.insert(menu.slidercellScriptMap, { layer = layer, tableobj = tableobj, row = row, col = col, type = "onRightClick", script = onRightClickScript })
	table.insert(menu.slidercellScriptMap, { layer = layer, tableobj = tableobj, row = row, col = col, type = "onSliderCellConfirm", script = confirmScript })

	local cell = GetCellContent(tableobj, row, col)
	SetScript(cell, "onSliderCellChanged", changedScript)
	SetScript(cell, "onSliderCellActivated", activateScript)
	SetScript(cell, "onSliderCellDeactivated", deactivateScript)
	SetScript(cell, "onRightClick", onRightClickScript)
	SetScript(cell, "onSliderCellConfirm", confirmScript)

	SetScript(cell, "onSliderCellDown", menu.slidercellDown)
	SetScript(cell, "onSliderCellRightOver", menu.slidercellRightOver)
	SetScript(cell, "onSliderCellRightDown", menu.slidercellRightDown)
	SetScript(cell, "onSliderCellLeftOver", menu.slidercellLeftOver)
	SetScript(cell, "onSliderCellLeftDown", menu.slidercellLeftDown)
end

function Helper.setSliderCellValue(tableobj, row, col, value, newmaxselect)
	local cell = GetCellContent(tableobj, row, col)
	if cell then
		SetSliderCellValue(cell, value, newmaxselect)
	end
end

function Helper.activateSliderCellInput(tableobj, row, col)
	local cell = GetCellContent(tableobj, row, col)
	ActivateSliderCellInput(cell)
end

function Helper.removeTableScript(tableobj, row, col, type, script)
	local cell = GetCellContent(tableobj, row, col)
	if cell then
		RemoveScript(cell, type, script)
	end
end

function Helper.removeFlowchartScript(flowchartid, row, col, type, script)
	local cell = GetFlowchartNodeID(flowchartid, row, col)
	if cell then
		RemoveScript(cell, type, script)
	end
end

function Helper.removeScripts(scriptMap, menu, widget, row, col)
	for i = #scriptMap, 1, -1 do
		local scriptdata = scriptMap[i]
		if (scriptdata.tableobj or scriptdata.flowchartid) == widget and scriptdata.row == row and scriptdata.col == col then
			if scriptdata.tableobj then
				Helper.removeTableScript(scriptdata.tableobj, scriptdata.row, scriptdata.col, scriptdata.type, scriptdata.script)
			else
				Helper.removeFlowchartScript(scriptdata.flowchartid, scriptdata.row, scriptdata.col, scriptdata.type, scriptdata.script)
			end
			table.remove(scriptMap, i)
		end
	end
end

function Helper.removeButtonScripts(menu, tableobj, row, col)
	Helper.removeScripts(menu.buttonScriptMap or {}, menu, tableobj, row, col)
end

function Helper.removeCheckBoxScripts(menu, tableobj, row, col)
	Helper.removeScripts(menu.checkboxScriptMap or {}, menu, tableobj, row, col)
end

function Helper.removeDropDownScripts(menu, tableobj, row, col)
	Helper.removeScripts(menu.dropdownScriptMap or {}, menu, tableobj, row, col)
end

function Helper.removeEditBoxScripts(menu, tableobj, row, col)
	Helper.removeScripts(menu.editboxScriptMap or {}, menu, tableobj, row, col)
end

function Helper.removeGraphScripts(menu, tableobj, row, col)
	Helper.removeScripts(menu.graphScriptMap or {}, menu, tableobj, row, col)
end

function Helper.removeSliderCellScripts(menu, tableobj, row, col)
	Helper.removeScripts(menu.slidercellScriptMap or {}, menu, tableobj, row, col)
end

function Helper.removeFlowchartNodeScripts(menu, flowchartid, row, col)
	Helper.removeScripts(menu.flowchartNodeScriptMap or {}, menu, flowchartid, row, col)
end

function Helper.removeAllScripts(scriptMap, menu, layer)
	menu.frames = menu.frames or {}
	if next(menu.frames) then
		for i = #scriptMap, 1, -1 do
			local scriptdata = scriptMap[i]
			if (not layer) or (scriptdata.layer == layer) then
				if menu.frames[scriptdata.layer] and IsValidWidgetElement(menu.frames[scriptdata.layer]) then
					if scriptdata.tableobj then
						Helper.removeTableScript(scriptdata.tableobj, scriptdata.row, scriptdata.col, scriptdata.type, scriptdata.script)
					else
						Helper.removeFlowchartScript(scriptdata.flowchartid, scriptdata.row, scriptdata.col, scriptdata.type, scriptdata.script)
					end
					table.remove(scriptMap, i)
				end
			end
		end
	end
end

function Helper.removeAllButtonScripts(menu, layer)
	Helper.removeAllScripts(menu.buttonScriptMap or {}, menu, layer)
end

function Helper.removeAllCheckBoxScripts(menu, layer)
	Helper.removeAllScripts(menu.checkboxScriptMap or {}, menu, layer)
end

function Helper.removeAllDropDownScripts(menu, layer)
	Helper.removeAllScripts(menu.dropdownScriptMap or {}, menu, layer)
end

function Helper.removeAllEditBoxScripts(menu, layer)
	Helper.removeAllScripts(menu.editboxScriptMap or {}, menu, layer)
end

function Helper.removeAllGraphScripts(menu, layer)
	Helper.removeAllScripts(menu.graphScriptMap or {}, menu, layer)
end

function Helper.removeAllSliderCellScripts(menu, layer)
	Helper.removeAllScripts(menu.slidercellScriptMap or {}, menu, layer)
end

function Helper.removeAllFlowchartNodeScripts(menu, layer)
	Helper.removeAllScripts(menu.flowchartNodeScriptMap or {}, menu, layer)
end

function Helper.removeAllWidgetScripts(menu, layer)
	Helper.removeAllButtonScripts(menu, layer)
	Helper.removeAllCheckBoxScripts(menu, layer)
	Helper.removeAllDropDownScripts(menu, layer)
	Helper.removeAllEditBoxScripts(menu, layer)
	Helper.removeAllGraphScripts(menu, layer)
	Helper.removeAllSliderCellScripts(menu, layer)
	Helper.removeAllFlowchartNodeScripts(menu, layer)
end

function Helper.setKeyBinding(menu, script)
	menu.keyBindingMap = menu.keyBindingMap or { }
	table.insert(menu.keyBindingMap, { script = script })
	
	SetScript("onHotkey", script)
end

function Helper.removeKeyBinding(script)
	RemoveScript("onHotkey", script)
end

function Helper.removeAllKeyBindings(menu)
	menu.keyBindingMap = menu.keyBindingMap or {}
	for _, scriptdata in ipairs(menu.keyBindingMap) do
		Helper.removeKeyBinding(scriptdata.script)
	end
	menu.keyBindingMap = {}
end

function Helper.setTabScrollCallback(menu, script)
	menu.tabScrollMap = menu.tabScrollMap or { }
	table.insert(menu.tabScrollMap, { script = script })
	
	SetScript("onTabScroll", script)

	AddUITriggeredEvent("MenuTabScroll", menu.name, "enabled")
end

function Helper.removeTabScrollCallback(menu, script)
	RemoveScript("onTabScroll", script)

	AddUITriggeredEvent("MenuTabScroll", menu.name, "disabled")
end

function Helper.removeAllTabScrollCallbacks(menu)
	menu.tabScrollMap = menu.tabScrollMap or {}
	for _, scriptdata in ipairs(menu.tabScrollMap) do
		Helper.removeTabScrollCallback(menu, scriptdata.script)
	end
	menu.tabScrollMap = {}
end

---------------------------------------------------------------------------------
-- Widget setup helper
---------------------------------------------------------------------------------

-- Widget setup interface is exposed via Helper.createFrameHandle()

local createTextPropertyInfo
local createIconPropertyInfo
local createHotkeyPropertyInfo
local initTableCell
local setTableColumnWidthData
local finalizeTableColumnWidths
local finalizeFlowchartCellSlots
local onFrameHandleViewCreated

-- for optional non-boolean properties
local propertyDefaultValue = false
local propertyBooleanDefaultValue = 0

-- Prototypes of widget handle member functions
local widgetPrototypes = { }
-- Metatables of widget handles, e.g. for providing member functions
local widgetMetatables = { }
-- Metatables of widget properties, for providing default properties
local widgetPropertyMetatables = { }
-- Type-specific widget handle helper functions (not member functions)
local widgetHelpers = { }

-- Definitions of available *simple* widget properties and their default values. Table members are either real widget types (and derive
-- from the "widget" member via "_basetype"), or definitions of complex properties of other widgets. Widgets can have complex
-- properties, defined separately below. For example, while "text" is a widget with properties "color" and "font", "button" is a widget
-- with a complex property "text", which in turn has simple properties defined by "textproperty", such as "color" and "font".
--
-- NOTE: All simple properties must have non-nil default values, nil values do not count.
local defaultWidgetProperties = {
	["widget"] = {
		-- base type, used for all widgets (default values can be overwritten by derived types)
		scaling = true,											-- apply scaling to coordinates, widths and heights (ignored on frame widgets, but propagated to table rows and cells)
		width = 0,												-- widget width
		height = 0,												-- widget height
		x = 0,													-- X offset
		y = 0,													-- Y offset
		mouseOverText = "",										-- mouse-over text string
		helpOverlayText = "",
		helpOverlayID = "",
		helpOverlayX = 0,
		helpOverlayY = 0,
		helpOverlayWidth = 0,
		helpOverlayHeight = 0,
		helpOverlayHighlightOnly = false,
		helpOverlayScaling = propertyBooleanDefaultValue,
		helpOverlayUseBackgroundSpan = false,
	},
	["frame"] = {
		layer = 4,												-- frame layer index
		exclusiveInteractions = false,							-- whether interactions (i.e. any input) will be exclusive to the view
		standardButtons = Helper.standardButtons_CloseBack,		-- which standard buttons should be displayed (close / back / minimize)
		standardButtonX = 0,									-- x offset for the standardbuttons
		standardButtonY = 0,									-- y offset for the standardbuttons
		standardButtonHelpOverlays = {},						-- add a highlightmode only helpoverlay to any specified standard button
		showBrackets = false,									-- whether to display frame brackets
		autoFrameHeight = false,								-- whether to use automatically calculated height of all content instead of height property
		closeOnUnhandledClick = false,							-- whether the the onHide event should be fired if the user clicks outside the view
		playerControls = false,									-- whether player controls are allowed
		startAnimation = true,									-- whether the start animation is played
		enableDefaultInteractions = true,						-- whether default input handling (f.e. ESC/DEL) is enabled
		useMiniWidgetSystem = false,							-- whether the frame should use the mini widgetsystem
		keepHUDVisible = false,									-- whether the HUD should be visible
		keepCrosshairVisible = false,							-- whether the crosshair should be visible (only works if the HUD is visible)
		showTickerPermanently = false,							-- whether the ticker should be permanently visible when the HUD is hidden
		viewHelperType = "Helper",
		_basetype = "widget"
	},
	["rendertarget"] = {
		alpha = 100,											-- render target alpha
		clear = true,											-- clear rendertarget on init
		startnoise = false,										-- whether the rendertarget starts with noise or not
		_basetype = "widget"
	},
	["table"] = {
		header = "",											-- header text
		tabOrder = 0,											-- tab order of the table (0 means non-interactive, 1 means default interactive table)
		skipTabChange = false,									-- skips the table when tabbing if true
		defaultInteractiveObject = false,						-- Set this object as the interactive object of the frame on creation if true
		borderEnabled = true,									-- whether table cells have a background color
		maxVisibleHeight = 0,									-- maximum height of table (enables scrollbar if required height for all rows exceeds max height, 0 = no maximum)
		reserveScrollBar = true,								-- whether the table width should include the required space for a potential scrollbar (otherwise the last column may be shortened)
		wraparound = false,										-- whether the table selection should wrap around when moving beyond the first/last row
		highlightMode = "on",									-- how to highlight the table selection ("on", "column", "off", "grey", "backgroundcolumn")
		multiSelect = false,									-- whether the the table allows multiselection
		backgroundID = "",										-- the background texture (using an icon ID) to be used (empty = no background)
		backgroundColor = Color["table_background_default"],	-- color of the background texture
		prevTable = 0,											-- point to the index of the previous connected table (aka pressing UP on the first row jumps the input to the last row of the prevTable)
		nextTable = 0,											-- point to the index of the next connected table (aka pressing DOWN on the last row jumps the input to the first row of the nextTable)
		prevHorizontalTable = 0,								-- point to the index of the previous horizontal connected table (aka pressing LEFT on the first selectable column jumps the input to the prevHorizontalTable)
		nextHorizontalTable = 0,								-- point to the index of the next horizontal connected table (aka pressing RIGHT on the last selectable column jumps the input to the nextHorizontalTable)
		_basetype = "widget"
	},
	["row"] = {
		scaling = true,											-- default value for cell scaling, applied to cell coordinates, widths and heights (note that column widths are not affected)
		fixed = false,											-- row is fixed, not scrollable (requires all previous rows to be fixed as well)
		borderBelow = true,										-- show border between this and the following row (ignored on the last row)
		interactive = true,										-- non-interactive, but selectable rows (rowdata ~= nil or false) (used for grey highlight border)
		bgColor = Color["row_background"],						-- row background color
		multiSelected = false									-- row is part of preselection in a multiselect table
	},
	-- table cells
	["cell"] = {
		cellBGColor = Color["row_background"],					-- background color
		uiTriggerID = propertyDefaultValue,						-- ID for UITriggered events
		_basetype = "widget"
	},
	["text"] = {
		text = "",												-- text string
		halign = Helper.standardHalignment,						-- horizontal text alignment ("left", "center", "right")
		color = Color["text_normal"],							-- text color
		glowfactor = Color["text_normal"].glow,					-- text glow
		titleColor = propertyDefaultValue,						-- title line color, also enables the title mode of the fontstring widget
		font = Helper.standardFont,								-- font
		fontsize = Helper.standardFontSize,						-- font size
		wordwrap = false,										-- word wrap
		x = Helper.standardTextOffsetx,							-- text X offset (overrides basetype X offset)
		y = Helper.standardTextOffsety,							-- text Y offset (overrides basetype Y offset)
		minRowHeight = Helper.standardTextHeight,				-- minimal row height (including Y offset)
		_basetype = "cell"
	},
	["icon"] = {
		icon = "",												-- icon ID
		color = Color["icon_normal"],							-- icon color
		glowfactor = Color["icon_normal"].glow,					-- icon glow
		affectRowHeight = true,									-- whether the icon height is allowed to affect the rowHeight
		_basetype = "cell"
	},
	["button"] = {
		active = true,											-- whether the button is active
		bgColor = Color["button_background_default"],			-- button background color
		highlightColor = Color["button_highlight_default"],		-- button highlight color
		height = Helper.standardButtonHeight,					-- button height (overrides basetype height)
		_basetype = "cell"
	},
	["editbox"] = {
		bgColor = Color["editbox_background_default"],			-- editbox background color
		closeMenuOnBack = false,								-- whether the menu should be closed on back while the editbox is active
		defaultText = "",										-- the text to be displayed if text is empty
		description = "",										-- description shown in input overlay when using Steam Big Picture
		textHidden = false,										-- whether the text is shown in the clear or hidden (aka password-style)
		encrypted = false,										-- whether the input is encrypted (aka password-style)
		selectTextOnActivation = true,							-- whether the text is pre-selected when activating the editbox
		active = true,											-- whether the editbox is active
		restoreInteractiveObject = false,						-- whether the input focus is restored to the previous object after the editbox is deactivated
		maxChars = 50,											-- max characters that can be entered
		_basetype = "cell"
	},
	["shieldhullbar"] = {
		shield = 0,
		hull = 0,
		glowfactor = Color["icon_normal"].glow,
		_basetype = "cell"
	},
	["graph"] = {
		graphtype = "line",
		bgColor = Color["graph_background"],
		_basetype = "cell"
	},
	["graphdatarecord"] = {
		markertype = propertyDefaultValue,
		markersize = 1,
		markercolor = Color["icon_normal"],
		linetype = propertyDefaultValue,
		linewidth = 1,
		linecolor = Color["icon_normal"],
		highlighted = false,
		mouseOverText = "",
	},
	["slidercell"] = {
		bgColor = Color["slider_background_default"],						-- slidercell background color
		inactiveBGColor = Color["slider_background_inactive"],				-- slidercell background color for inactive directions if fromCenter is set
		valueColor = Color["slider_value"],									-- slidercell value color
		posValueColor = Color["slider_diff_pos"],							-- slidercell positive value color if fromCenter is set
		negValueColor = Color["slider_diff_neg"],							-- slidercell negative value color if fromCenter is set
		min = 0,															-- minimum value
		minSelect = propertyDefaultValue,									-- min selectable value (optional, defaults to min)
		max = 0,															-- maximum value
		maxSelect = propertyDefaultValue,									-- max selectable value (optional, defaults to max - do not use with exceedmax)
		start = 0,															-- start value
		step = 1,															-- step size
		accuracyOverride = propertyDefaultValue,							-- override the accuracy calculated from the step with this (optional, defaults to -1 -> no override)
		infiniteValue = 0,													-- Value at which the slider shows infinity
		suffix = "",														-- suffix to be displayed
		exceedMaxValue = false,												-- allow player to exceed the max value (requires min >= 0)
		hideMaxValue = false,												-- Hide the max value in the number display
		rightToLeft = false,												-- Right-to-left (mirrored) scale
		fromCenter = false,													-- Slider bar extends from zero in the center
		readOnly = false,													-- Slider is read-only (non-interactive), only used as output
		forceArrows = false,												-- force arrows displayed (for readOnly case)
		useInfiniteValue = false,											-- Slider shows infinity symbol if value == InfiniteValue
		useTimeFormat = false,												-- Slider uses time format
		_basetype = "cell"
	},
	["dropdown"] = {
		options = {},
		startOption = "",
		active = true,
		bgColor = Color["dropdown_background_default"],
		highlightColor = Color["dropdown_highlight_default"],
		optionColor = Color["dropdown_background_options"],
		optionWidth = 0,
		optionHeight = 0,
		allowMouseOverInteraction = false,
		textOverride = "",
		text2Override = "",
		_basetype = "cell"
	},
	["checkbox"] = {
		checked = false,
		bgColor = Color["checkbox_background_default"],
		active = true,
		symbol = "circle",													-- The symbol the checkbox uses. Valid values: "circle", "arrow" (optional - default to "circle")
		glowfactor = Color["icon_normal"].glow,
		_basetype = "cell"
	},
	["statusbar"] = {
		current = 0,
		start = 0,
		max = 0,
		valueColor = Color["statusbar_value_default"],
		posChangeColor = Color["statusbar_diff_pos_default"],
		negChangeColor = Color["statusbar_diff_neg_default"],
		markerColor = Color["statusbar_marker_default"],
		titleColor = propertyDefaultValue,
		_basetype = "cell"
	},
	["boxtext"] = {
		text = "",												-- text string
		halign = Helper.standardHalignment,						-- horizontal text alignment ("left", "center", "right")
		color = Color["text_normal"],							-- text color
		boxColor = Color["boxtext_box_default"],				-- title line color, also enables the title mode of the fontstring widget
		font = Helper.standardFont,								-- font
		fontsize = Helper.standardFontSize,						-- font size
		wordwrap = false,										-- word wrap
		textX = Helper.standardTextOffsetx,						-- text X offset
		textY = Helper.standardTextOffsety,						-- text Y offset
		minRowHeight = Helper.standardTextHeight,				-- minimal row height (including Y offset)
		glowfactor = Color["text_normal"].glow,					-- glow factor
		_basetype = "cell"
	},
	-- flowchart widgets
	["flowchart"] = {
		tabOrder = 0,											-- tab order of the flowchart (0 means non-interactive, 1 means default interactive table)
		skipTabChange = false,									-- skips the flowchart when tabbing if true
		defaultInteractiveObject = false,						-- Set this object as the interactive object of the frame on creation if true
		borderHeight = 0,										-- height of flowchart border at top and bottom (default 0 = no border)
		borderColor = Color["flowchart_border_default"],		-- flowchart border color
		maxVisibleHeight = 0,									-- maximum visible height of flowchart (enables scrollbar if required height for all rows exceeds max height, 0 = use available height in frame)
		minRowHeight = 0,										-- minimal row height
		minColWidth = 0,										-- minimal column width (can be overridden with flowchart:setColWidthMin())
		edgeWidth = 1,											-- edge width
		firstVisibleRow = 1,									-- first visible row
		firstVisibleCol = 1,									-- first visible column
		selectedRow = 1,										-- selected row
		selectedCol = 1,										-- selected column
		_basetype = "widget"
	},
	["flowchartcell"] = {
		_basetype = "widget"
	},
	["flowchartnode"] = {
		-- x = 0,												-- flowchartnode-specific: minimal left and right spacing in cell (node is centered)
		-- y = 0,												-- flowchartnode-specific: minimal top and bottom spacing in cell (node is centered)
		-- width = 0,											-- flowchartnode-specific: width of node outline - value required, must be greater than height
		height = Helper.standardFlowchartNodeHeight,			-- flowchartnode-specific: height of node outline (default overrides basetype default), must be at least 10
		shape = "rectangle",									-- shape ("rectangle", "stadium", "hexagon")
		expandedFrameLayer = 0,									-- layer for created menu frame when node is expanded (required for expansion)
		expandedFrameNumTables = 1,								-- number of tables in created menu frame when node is expanded (1 or 2)
		expandedTableNumColumns = 0,							-- number of columns in created menu frame table when node is expanded (required for expansion)
		value = 0,												-- current value
		max = 0,												-- maximum value
		slider1 = -1,											-- slider 1 value (position of top slider handle, diff-range highlighted if greater than current value, negative = disabled)
		slider2 = -1,											-- slider 2 value (position of bottom slider handle, diff-range highlighted if less than current value, negative = disabled)
		step = 0,												-- step size for sliders (0 = sliders are fixed and non-interactive, no handles are shown)
		connectorSize = Helper.standardFlowchartConnectorSize,	-- size of input/output connectors
		statusColor = propertyDefaultValue,						-- override color for statustext or statusicon
		statusBgIconID = "",									-- optional ID of background icon behind statusicon, with same size, position and color as statusicon
		statusBgIconRotating = false,							-- whether status background icon is rotating, if statusBgIconID provided
		bgColor = Color["flowchart_node_background"],			-- color of node background
		outlineColor = Color["flowchart_node_default"],			-- color of node outline
		valueColor = Color["flowchart_value_default"],			-- color of value bar
		slider1Color = Color["flowchart_slider_value1"],		-- color of interactive top slider handle
		slider2Color = Color["flowchart_slider_value2"],		-- color of interactive bottom slider handle
		diff1Color = Color["flowchart_slider_diff1"],			-- color of diff-range between current value and top slider handle (if greater than current value)
		diff2Color = Color["flowchart_slider_diff2"],			-- color of diff-range between current value and bottom slider handle (if less than current value)
		slider1MouseOverText = "",								-- mouse-over text string for the top slider handle
		slider2MouseOverText = "",								-- mouse-over text string for the bottom slider handle
		statusIconMouseOverText = "",							-- mouse-over text string for the status icon
		uiTriggerID = propertyDefaultValue,						-- ID for UITriggered events
		_basetype = "flowchartcell"
	},
	["flowchartjunction"] = {
		-- x = 0,												-- flowchartjunction-specific: minimal left and right spacing in cell (X distance from center to border is junctionXOff + x)
		-- y = 0,												-- flowchartjunction-specific: minimal top and bottom spacing in cell (junction is vertically centered)
		junctionXOff = -1,										-- X offset from center of column (negative value means that the offset is calculated automatically, taking the rightmost position of any node in the column)
		junctionSize = Helper.standardFlowchartConnectorSize,	-- junction size
		_basetype = "flowchartcell"
	},
	["flowchartedge"] = {
		color = Color["flowchart_edge_default"],				-- edge color
		sourceSlotColor = propertyDefaultValue,					-- color of output slot of source node/junction (if provided, the same color must be used by all outgoing edges from that slot)
		sourceSlotRank = 1,										-- rank value from 1 to 3, used for assignment of an output slot at the source node, in case there are multiple outgoing edges (edges of same rank connect to the same slot)
		destSlotColor = propertyDefaultValue,					-- color of input slot of destination node/junction (if provided, the same color must be used by all incoming edges to that slot)
		destSlotRank = 1,										-- rank value from 1 to 3, used for assignment of an input slot at the destination node, in case there are multiple incoming edges (edges of same rank connect to the same slot)
		_basetype = "widget"
	},
	-- complex properties
	["textproperty"] = {
		text = "",												-- text string
		x = 0,													-- X offset
		y = 0,													-- Y offset
		halign = Helper.standardHalignment,						-- horizontal text alignment ("left", "center", "right")
		color = Color["text_normal"],							-- text color
		glowfactor = Color["text_normal"].glow,					-- text glowfactor
		font = Helper.standardFont,								-- font
		fontsize = Helper.standardFontSize,						-- font size
		scaling = true,											-- scaling
	},
	["iconproperty"] = {
		icon = "",												-- icon ID
		swapicon = "",											-- swap icon ID
		width = 0,												-- widget width
		height = 0,												-- widget height
		x = 0,													-- X offset
		y = 0,													-- Y offset
		color = Color["icon_normal"],							-- icon color
		glowfactor = Color["icon_normal"].glow,					-- icon glowfactor
		scaling = true,											-- scaling
	},
	["hotkeyproperty"] = {
		hotkey = "",											-- the associated hotkey action (must correspond to a valid INPUT_STATE - for instance "INPUT_STATE_FOO")
		displayIcon = false,									-- whether the widget using the hotkey displays the associated icon as a hotkey
		x = 0,													-- X offset for the hotkey icon (only used if displayIcon is set to true)
		y = 0													-- Y offset for the hotkey icon (only used if displayIcon is set to true)
	},
	["frametextureproperty"] = {
		icon = "",												-- the texture (using an icon ID) to be used (empty = no background)
		color = Color["frame_background_default"],				-- color of the texture
		width = 0,												-- override texture width (0 -> use frame width)
		height = 0,												-- override texture height (0 -> use frame width)
		rotationRate = 0,										-- rate of rotation in deg/s
		rotationStart = 0,										-- start of the rotation in deg
		rotationDuration = 0,									-- duration of rotation (0 -> never stop)
		rotationInterval = 0,									-- time until rotation repeats (0 -> never repeat)
		initialScaleFactor = 1,									-- scale change relative to end scale
		scaleDuration = 0,										-- duration of the scale change
		glowfactor = Color["frame_background_default"].glow,	-- glowfactor of the texture
	},
	["axisproperty"] = {
		startvalue = 0,
		endvalue = 1,
		granularity = 1,
		offset = 0,
		grid = true,
		color = Color["text_normal"],
		gridcolor = Color["text_normal"],
		glowfactor = Color["text_normal"].glow,
	},
}

-- Definition of complex widget properties. Table value references a type defined above in defaultWidgetProperties.
local complexCellProperties = {
	["frame"] = {
		background =	"frametextureproperty",
		background2 =	"frametextureproperty",
		overlay =		"frametextureproperty",
	},
	["icon"] = {
		text =			"textproperty",
		text2 =			"textproperty"
	},
	["button"] = {
		text =			"textproperty",
		text2 =			"textproperty",
		icon =			"iconproperty",
		icon2 =			"iconproperty",
		hotkey =		"hotkeyproperty"
	},
	["editbox"] = {
		text =			"textproperty",
		hotkey =		"hotkeyproperty"
	},
	["slidercell"] = {
		text =			"textproperty"
	},
	["dropdown"] = {
		text =			"textproperty",
		text2 =			"textproperty",
		icon =			"iconproperty",
		hotkey =		"hotkeyproperty"
	},
	["flowchartnode"] = {
		text =			"textproperty",
		statustext =	"textproperty",
		statusicon =	"iconproperty",
	},
	["graph"] = {
		title =			"textproperty",
		xAxis =			"axisproperty",
		xAxisLabel =	"textproperty",
		yAxis =			"axisproperty",
		yAxisLabel =	"textproperty",
	},
}

-- create widget metatables and prototype tables (to be filled with member functions below), and tables for helper functions
for widgettype, properties in pairs(defaultWidgetProperties) do
	widgetPrototypes[widgettype] = { }
	widgetMetatables[widgettype] = {
		__index = widgetPrototypes[widgettype]
	}
	-- TODO: Allow property adjustments after frame creation (e.g. using SetCellContent())
	widgetPropertyMetatables[widgettype] = {
		__index = function(proptable, prop)
			if prop == "apply" then
				-- allow properties:apply({ prop = value })
				return function (self, input)
					if input then
						for prop, value in pairs(input) do
							self[prop] = value
						end
					end 
				end
			end
			local v = properties[prop]
			if v == nil then
				DebugError(string.format("Widget setup error: Tried to access non-existing property '%s' on widget of type '%s'\n\n%s", tostring(prop), tostring(widgettype), TraceBack()))
			end
			return v
		end,
		__newindex = function(proptable, prop, propvalue)
			if properties[prop] ~= nil then
				rawset(proptable, prop, propvalue)
			else
				DebugError(string.format("Widget setup error: Tried to set non-existing property '%s' on widget of type '%s'\n\n%s", tostring(prop), tostring(widgettype), TraceBack()))
			end
		end
	}
	widgetHelpers[widgettype] = { }
end

-- set up inheritance via metatables: widget types that derive from "cell" should inherit the default properties and member functions
for widgettype, properties in pairs(defaultWidgetProperties) do
	local basetype = properties._basetype
	if basetype then
		-- remove basetype entry
		properties._basetype = nil
		-- inherit prototypes from basetype
		setmetatable(widgetPrototypes[widgettype], widgetMetatables[basetype])
		-- inherit default properties from basetype
		setmetatable(properties, { __index = defaultWidgetProperties[basetype] })
	end
end

function createTextPropertyInfo(cell, textproperty)
	local text = textproperty.text
	if not text then
		return nil
	end
	if type(text) == "function" then
		text = text(cell)
	end
	local color = textproperty.color
	if type(color) == "function" then
		color = color(cell)
	end
	local glowfactor = rawget(textproperty, "glowfactor")
	if not glowfactor then
		glowfactor = color.glow or textproperty.glowfactor
	end
	if type(glowfactor) == "function" then
		glowfactor = glowfactor(cell)
	end
	local halign = textproperty.halign
	local font = textproperty.font
	local fontsize = Helper.scaleFont(font, textproperty.fontsize, textproperty.scaling)
	local offsetx = Helper.scaleX(textproperty.x, textproperty.scaling)
	local offsety = Helper.scaleY(textproperty.y, textproperty.scaling)
	return { text = text, alignment = halign, fontname = font, fontsize = fontsize, color = color, x = offsetx, y = offsety, glowfactor = glowfactor }
end

function isTextPropertyFunctionCell(cell, textproperty)
	local text = textproperty.text
	if not text then
		return nil
	end
	if type(text) == "function" then
		return true
	end
	local color = textproperty.color
	if type(color) == "function" then
		return true
	end
	local glowfactor = rawget(textproperty, "glowfactor")
	if not glowfactor then
		glowfactor = color.glow or textproperty.glowfactor
	end
	if type(glowfactor) == "function" then
		return true
	end
end

function createIconPropertyInfo(cell, iconproperty)
	local icon = iconproperty.icon
	if icon == "" then
		return nil
	end
	if type(icon) == "function" then
		icon = icon(cell)
	end
	local color = iconproperty.color
	if type(color) == "function" then
		color = color(cell)
	end
	local glowfactor = rawget(iconproperty, "glowfactor")
	if not glowfactor then
		glowfactor = color.glow or iconproperty.glowfactor
	end
	if type(glowfactor) == "function" then
		glowfactor = glowfactor(cell)
	end
	local swapicon = iconproperty.swapicon
	local width = Helper.scaleX(iconproperty.width, iconproperty.scaling)
	local height = Helper.scaleY(iconproperty.height, iconproperty.scaling)
	local offsetx = Helper.scaleX(iconproperty.x, iconproperty.scaling)
	local offsety = Helper.scaleY(iconproperty.y, iconproperty.scaling)
	if height ~= 0 then
		width = width - 2 * Helper.configButtonBorderSize
		height = height - 2 * Helper.configButtonBorderSize
		offsetx = offsetx + Helper.configButtonBorderSize
		offsety = offsety + Helper.configButtonBorderSize
	end
	return { iconID = icon, swapIconID = swapicon, color = color, width = width, height = height, x = offsetx, y = offsety, glowfactor = glowfactor }
end

function isIconPropertyFunctionCell(cell, iconproperty)
	local icon = iconproperty.icon
	if icon == "" then
		return nil
	end
	if type(icon) == "function" then
		return true
	end
	local color = iconproperty.color
	if type(color) == "function" then
		return true
	end
	local glowfactor = rawget(iconproperty, "glowfactor")
	if not glowfactor then
		glowfactor = color.glow or iconproperty.glowfactor
	end
	if type(glowfactor) == "function" then
		return true
	end
end

function createHotkeyPropertyInfo(cell, hotkeyproperty, width, height, scaling)
	local state = hotkeyproperty.hotkey
	if state == "" then
		return nil
	end
	local displayicon = hotkeyproperty.displayIcon
	local offsetx = rawget(hotkeyproperty, "x")
	local offsety = hotkeyproperty.y

	if not offsetx then
		offsetx = math.max(0, width)
	elseif scaling then
		offsetx = Helper.scaleX(offsetx)
	end
	if scaling then
		offsety = Helper.scaleY(offsety)
	end
	return { action = state, displayIcon = displayicon, x = offsetx, y = offsety }
end

function createOverlayPropertyInfo(widget)
	local text = widget.properties.helpOverlayText
	if not text then
		return nil
	end
	if type(text) == "function" then
		text = text(widget)
	end

	local scaling = widget.properties.helpOverlayScaling
	if scaling == propertyBooleanDefaultValue then
		scaling = widget.properties.scaling
	end

	local width = Helper.scaleX(widget.properties.helpOverlayWidth, scaling)
	local height = Helper.scaleX(widget.properties.helpOverlayHeight, scaling)
	local offsetx = Helper.scaleX(widget.properties.helpOverlayX, scaling)
	local offsety = Helper.scaleY(widget.properties.helpOverlayY, scaling)
	return { text = text, id = widget.properties.helpOverlayID, size = { width = width, height = height }, offset = { x = offsetx, y = offsety }, highlightOnly = widget.properties.helpOverlayHighlightOnly, useBackgroundSpan = widget.properties.helpOverlayUseBackgroundSpan }
end

function createFrameTexturePropertyInfo(textureproperty)
	local glowfactor = rawget(textureproperty, "glowfactor")
	if not glowfactor then
		glowfactor = textureproperty.color.glow or textureproperty.glowfactor
	end

	return {
		icon = textureproperty.icon,
		color = textureproperty.color,
		glowfactor = glowfactor,
		size = {
			width = textureproperty.width,
			height = textureproperty.height,
		},
		rotation = {
			rate = textureproperty.rotationRate,
			start = textureproperty.rotationStart,
			duration = textureproperty.rotationDuration,
			interval = textureproperty.rotationInterval,
		},
		initScale = {
			factor = textureproperty.initialScaleFactor,
			duration = textureproperty.scaleDuration,
		},
	}
end

function createAxisPropertyInfo(axisproperty)
	local glowfactor = rawget(axisproperty, "glowfactor")
	if not glowfactor then
		glowfactor = axisproperty.color.glow or axisproperty.glowfactor
	end

	return {
		startvalue = axisproperty.startvalue,
		endvalue = axisproperty.endvalue,
		granularity = axisproperty.granularity,
		offset = axisproperty.offset,
		grid = axisproperty.grid,
		color = axisproperty.color,
		gridcolor = axisproperty.gridcolor,
		glowfactor = glowfactor,
	}
end

---------- Create frame handle ----------

-- Example usage:
--   local frame = Helper.createFrameHandle()
--   local frame = Helper.createFrameHandle(nil, { layer = 4, standardButtons = Helper.standardButtons_Close })
function Helper.createFrameHandle(menu, properties)
	local frame = {
		menu = menu,
		type = "frame",						-- widget type
		descriptor = nil,					-- descriptor (used temporarily)
		id = nil,							-- frame ID, valid while displayed
		properties = { },					-- frame properties
		content = { },
		functionCells = { },				-- contained table cells with text functions
		expandedFlowchartNodeData = nil		-- data associating frame with flowchartnode if frame was created by expanding the node
	}
	-- set metatables to enable member functions and default properties
	setmetatable(frame, widgetMetatables.frame)
	setmetatable(frame.properties, widgetPropertyMetatables.frame)
	
	-- create complex frame properties
	local complexprops = complexCellProperties.frame
	if complexprops then
		for complexprop, simpleprop in pairs(complexprops) do
			local complexproptable = { }
			setmetatable(complexproptable, widgetPropertyMetatables[simpleprop])
			rawset(frame.properties, complexprop, complexproptable)
		end
	end

	-- Default size
	frame.properties.width = Helper.viewWidth
	frame.properties.height = Helper.viewHeight
	frame.properties.x = 0
	frame.properties.y = 0

	-- apply custom properties if provided
	frame.properties:apply(properties)

	return frame
end

---------- Frame member functions ----------

-- Example usage:
--   local rendertarget = frame:addRenderTarget({ width = 427, height = 320, alpha = 90 })
function widgetPrototypes.frame:addRenderTarget(properties)
	local rendertarget = {
		frame = self,
		index = nil,						-- index in frame content (set below)
		type = "rendertarget",				-- widget type
		descriptor = nil,					-- descriptor (used temporarily)
		id = nil,							-- widget ID, valid while displayed
		properties = { }					-- rendertarget properties
	}
	table.insert(self.content, rendertarget)
	rendertarget.index = #self.content

	-- set metatables to enable member functions and default properties
	setmetatable(rendertarget, widgetMetatables.rendertarget)
	setmetatable(rendertarget.properties, widgetPropertyMetatables.rendertarget)

	-- apply properties if provided
	rendertarget.properties:apply(properties)
	return rendertarget
end

--   local flowchart = frame:addFlowchart(5, { borderHeight = 4, borderColor = Color["foo"] })
function widgetPrototypes.frame:addFlowchart(numrows, numcolumns, properties)
	local flowchart = {
		frame = self,
		index = nil,						-- index in frame content (set below)
		type = "flowchart",					-- widget type
		descriptor = nil,					-- descriptor (used temporarily)
		id = nil,							-- widget ID, valid while displayed
		numrows = numrows,					-- number of rows
		numcolumns = numcolumns,			-- number of columns
		columndata = { },					-- column widths and other metadata
		rows = { },							-- row table
		edges = { },						-- edge widgets
		expandedNodes = { },				-- expanded flowchartnodes (mapping node -> expanded frame handle)
		defaultNodeProperties = nil,		-- default values for properties of contained nodes (applied when created)
		defaultEdgeProperties = nil,		-- default values for properties of flowchart edges (applied when created)
		defaultTextProperties = nil,		-- default values for properties of contained node texts (applied when set)
		defaultIconProperties = nil,		-- default values for properties of contained node status icons (applied when set)
		properties = { },					-- flowchart properties
	}
	table.insert(self.content, flowchart)
	flowchart.index = #self.content

	-- set metatables to enable member functions and default properties
	setmetatable(flowchart, widgetMetatables.flowchart)
	setmetatable(flowchart.properties, widgetPropertyMetatables.flowchart)

	-- propagate scaling from frame to flowchart
	if not self.properties.scaling then
		flowchart.properties.scaling = false
	end

	-- apply properties if provided
	flowchart.properties:apply(properties)

	-- set up columndata
	for i = 1, flowchart.numcolumns do
		flowchart.columndata[i] = { bgcolor = nil, minwidth = -1, weight = 1, scaling = nil, junctionxoff = 0 }
	end

	-- prepare rows
	if numrows < 1 or numcolumns < 1 then
		flowchart.numrows = 0
		flowchart.numcolumns = 0
	end
	for i = 1, flowchart.numrows do
		local row = { }
		for j = 1, flowchart.numcolumns do
			row[j] = false
		end
		flowchart.rows[i] = row
	end

	return flowchart
end

-- Example usage:
--   local ftable = frame:addTable(5, { tabOrder = 1 })
function widgetPrototypes.frame:addTable(numcolumns, properties)
	local ftable = {
		frame = self,
		index = nil,						-- index in frame content (set below)
		type = "table",						-- widget type
		descriptor = nil,					-- descriptor (used temporarily)
		id = nil,							-- widget ID, valid while displayed
		numcolumns = numcolumns,			-- number of columns
		columndata = { final = false },		-- column widths and other metadata
		rows = { },							-- row objects
		numfixedrows = nil,					-- number of fixed rows, will be determined on display
		toprow = nil,						-- first visible row
		selectedrow = nil,					-- selected row
		selectedcol = 0,					-- selected column
		properties = { },					-- table properties
		defaultCellProperties = nil,		-- default values for properties of contained cells (applied when created)
		defaultComplexCellProperties = nil,	-- default values for complex properties of contained cells (applied when created)
		createdWithScrollBar = nil,			-- return value of hasScrollBar() at descriptor creation
	}
	table.insert(self.content, ftable)
	ftable.index = #self.content

	-- set metatables to enable member functions and default properties
	setmetatable(ftable, widgetMetatables.table)
	setmetatable(ftable.properties, widgetPropertyMetatables.table)

	-- propagate scaling from frame to table
	if not self.properties.scaling then
		ftable.properties.scaling = false
	end

	-- apply properties if provided
	ftable.properties:apply(properties)

	-- set up columndata
	for i = 1, numcolumns do
		ftable.columndata[i] = { width = 0, percent = false, min = true, weight = 1, colspan = 1, bgcolspan = 1, scaling = nil }
	end

	return ftable
end

function widgetPrototypes.frame:setBackground(icon, properties)
	self.properties.background.icon = icon
	self.properties.background:apply(properties)
	return self
end

function widgetPrototypes.frame:setBackground2(icon, properties)
	self.properties.background2.icon = icon
	self.properties.background2:apply(properties)
	return self
end

function widgetPrototypes.frame:setOverlay(icon, properties)
	self.properties.overlay.icon = icon
	self.properties.overlay:apply(properties)
	return self
end

function widgetPrototypes.frame:getAvailableHeight()
	if self.properties.autoFrameHeight then
		return Helper.viewHeight - self.properties.y
	end
	return self.properties.height
end

function widgetPrototypes.frame:getUsedHeight()
	local height = 0
	-- minimal height required for standard buttons
	local standardbuttons = self.properties.standardButtons
	if standardbuttons and (standardbuttons.back or standardbuttons.close or standardbuttons.minimize or standardbuttons.help) then
		height = Helper.standardButtons_Size
	end
	-- minimal height required for each top-level widget
	for _, widget in ipairs(self.content) do
		if widget.type == "table" or widget.type == "flowchart" then
			height = math.max(height, widget.properties.y + widget:getVisibleHeight())
		elseif widget.type == "rendertarget" then
			height = math.max(height, widget.properties.y + widget.properties.height)
		end
	end
	return height
end

function widgetPrototypes.frame:display()
	local framewidgetdescriptors = { }
	self.hastable = false
	for widgetidx, widget in ipairs(self.content) do
		if widget.type == "table" then
			self.hastable = true
		end
		local desc = widgetHelpers[widget.type].createDescriptor(widget)
		if desc == nil then
			DebugError("Frame content of type '" .. widget.type .. "' was not created successfully! Aborting display of frame!")
			return
		end
		if widget.descriptor then
			ReleaseDescriptor(widget.descriptor)
		end
		widget.descriptor = desc
		framewidgetdescriptors[widgetidx] = desc
	end

	local menu = self.menu
	local layer = self.properties.layer
	local exclusiveInteractions = self.properties.exclusiveInteractions
	local closeOnUnhandledClick = self.properties.closeOnUnhandledClick
	local playerControls = self.properties.playerControls
	local startAnimation = self.properties.startAnimation
	local keepHUDVisible = self.properties.keepHUDVisible
	local keepCrosshairVisible = self.properties.keepCrosshairVisible
	local showTickerPermanently = self.properties.showTickerPermanently
	local enableDefaultInteractions = self.properties.enableDefaultInteractions
	local helpoverlay = createOverlayPropertyInfo(self)
	local standardButtonHelpOverlays = {}
	for button, helpoverlayID in pairs(self.properties.standardButtonHelpOverlays) do
		standardButtonHelpOverlays[button] = { text = " ", id = helpoverlayID, size = { width = 0, height = 0 }, offset = { x = 0, y = 0 }, highlightOnly = true }
	end

	menu.frameData[layer] = {
		width = self.properties.width,
		height = self.properties.autoFrameHeight and self:getUsedHeight() or self.properties.height,
		x = self.properties.x,
		y = self.properties.y,
	}

	local frameDescriptor = {
		offset = {
			x = menu.frameData[layer].x,
			y = menu.frameData[layer].y,
		},
		size = {
			width = menu.frameData[layer].width,
			height = menu.frameData[layer].height,
		},
		contentdescriptors = framewidgetdescriptors,
		layer = layer,
		background = createFrameTexturePropertyInfo(self.properties.background),
		background2 = createFrameTexturePropertyInfo(self.properties.background2),
		overlay = createFrameTexturePropertyInfo(self.properties.overlay),
		standardButtons = self.properties.standardButtons,
		standardButtonOffset = {
			x = self.properties.standardButtonX,
			y = self.properties.standardButtonY
		},
		standardButtonHelpOverlays = standardButtonHelpOverlays,
		showBrackets = self.properties.showBrackets,
		enableDefaultInteractions = enableDefaultInteractions,
		closeOnUnhandledClick = closeOnUnhandledClick,
		helpoverlay = helpoverlay,
	}

	local framedesc = CreateFrame2(frameDescriptor)

	if self.descriptor then
		ReleaseDescriptor(self.descriptor)
	end
	self.descriptor = framedesc
	-- TODO
	if self.hastable then
		Helper.handleTableDesc(menu, framewidgetdescriptors)
	end

	Helper.closeMinimizedMenus()
	-- TODO: Adjust callbacks
	View.registerMenu("Helper" .. layer, self.properties.viewHelperType, function (frames) return onFrameHandleViewCreated(self, frames) end, function () return menu.onCloseElement("close", nil, true) end, {[layer] = framedesc}, exclusiveInteractions, closeOnUnhandledClick, nil, playerControls, self.properties.useMiniWidgetSystem, startAnimation, keepHUDVisible, keepCrosshairVisible, showTickerPermanently)
end

function onFrameHandleViewCreated(framehandle, frames)
	local frameid = frames[1]
	local menu = framehandle.menu
	if frameid then
		local layer = framehandle.properties.layer
		menu.frames = menu.frames or {}
		menu.frames[layer] = frameid
		local children = table.pack(GetChildren(frameid))
		Helper.setScripts(menu, layer, frameid, children)
		if framehandle.hastable then
			Helper.handleCreatedTables(menu, children)
		end

		-- store IDs in widget handles, release descriptors and set up event handlers
		framehandle.id = frameid
		for i, widgetid in ipairs(children) do
			local widget = framehandle.content[i]
			ReleaseDescriptor(widget.descriptor)
			widget.descriptor = nil
			widget.id = widgetid
			if widget.type == "table" then
				for rowidx, row in ipairs(widget.rows) do
					do
						local expectedheight = row:getHeight()
						local actualheight = GetTableRowHeight(widgetid, rowidx)
						if expectedheight ~= actualheight then
							DebugError(string.format("Table row height mismatch in row %d: expected height = %s, actualheight = %s [Klaus]", rowidx, expectedheight, actualheight))
						end
					end
					for cellidx, cell in ipairs(row) do
						if cell.colspan ~= 0 then
							ReleaseDescriptor(cell.descriptor)
							cell.descriptor = nil
							cell.id = GetCellContent(widgetid, rowidx, cellidx)
							local triggerid = cell.properties.uiTriggerID or nil
							if cell.type == "checkbox" then
								Helper.setCheckBoxScript(menu, triggerid, widgetid, rowidx, cellidx, cell.handlers.onClick)
							elseif cell.type == "button" then
								Helper.setButtonScript(menu, triggerid, widgetid, rowidx, cellidx, cell.handlers.onClick, cell.handlers.onRightClick, cell.handlers.onDoubleClick)
							elseif cell.type == "editbox" then
								Helper.setEditBoxScript(menu, triggerid, widgetid, rowidx, cellidx, cell.handlers.onEditBoxDeactivated, cell.handlers.onTextChanged, cell.handlers.onEditBoxActivated, cell.handlers.onCursorChanged)
							elseif cell.type == "slidercell" then
								Helper.setSliderCellScript(menu, triggerid, widgetid, rowidx, cellidx, cell.handlers.onSliderCellChanged, cell.handlers.onSliderCellActivated, cell.handlers.onSliderCellDeactivated, cell.handlers.onRightClick, cell.handlers.onSliderCellConfirm)
							elseif cell.type == "dropdown" then
								Helper.setDropDownScript(menu, triggerid, widgetid, rowidx, cellidx, cell.handlers.onDropDownActivated, cell.handlers.onDropDownConfirmed, cell.handlers.onDropDownRemoved)
							elseif cell.type == "graph" then
								Helper.setGraphScript(menu, triggerid, widgetid, rowidx, cellidx, cell.handlers.onClick)
							end
						end
					end
				end
				if widget.properties.prevTable ~= 0 then
					C.SetTablePreviousConnectedTable(widgetid, children[widget.properties.prevTable])
				end
				if widget.properties.nextTable ~= 0 then
					C.SetTableNextConnectedTable(widgetid, children[widget.properties.nextTable])
				end
				if widget.properties.prevHorizontalTable ~= 0 then
					C.SetTablePreviousHorizontalConnectedTable(widgetid, children[widget.properties.prevHorizontalTable])
				end
				if widget.properties.nextHorizontalTable ~= 0 then
					C.SetTableNextHorizontalConnectedTable(widgetid, children[widget.properties.nextHorizontalTable])
				end
			elseif widget.type == "flowchart" then
				local flowchartData = GetFlowchartData(widgetid)
				for rowidx, row in ipairs(widget.rows) do
					do
						local expectedheight = widget:getRowHeight(rowidx)
						local actualheight = flowchartData.rowHeights[rowidx]
						if expectedheight ~= actualheight then
							DebugError(string.format("Flowchart row height mismatch in row %d: expected height = %s, actualheight = %s [Klaus]", rowidx, expectedheight, actualheight))
						end
					end
					for cellidx, cell in ipairs(row) do
						if cell then
							ReleaseDescriptor(cell.descriptor)
							cell.descriptor = nil
							cell.id = GetFlowchartNodeID(widgetid, rowidx, cellidx)
							if cell.type == "flowchartnode" then
								widgetHelpers.flowchartnode.setScripts(cell)
							end
						end
					end
				end
				for edgeidx, edge in ipairs(widget.edges) do
					ReleaseDescriptor(edge.descriptor)
					edge.descriptor = nil
					edge.id = GetFlowchartEdgeID(widgetid, edgeidx)
				end
			end
		end

		if framehandle.expandedFlowchartNodeData then
			-- this frame was created by expanding a flowchartnode in another frame
			local node = framehandle.expandedFlowchartNodeData.node
			if node.flowchart.expandedNodes[node] == framehandle then
				C.SetFlowchartNodeExpanded(node.id, frameid, framehandle.expandedFlowchartNodeData.expandedAbove)
			else
				-- this should not happen (flowchartnode being collapsed immediately before view is created)
				DebugError("onFrameHandleViewCreated(): Expanded menu frame was created for flowchartnode that is not expanded")
			end
		end

		if menu.tableConnections and menu.tableConnections.refresh then
			menu.tableConnections.refresh = nil

			local connections = {}
			for _, tables in Helper.orderedPairs(menu.tableConnections) do
				local compacted_tables = {}
				for _, ftable in Helper.orderedPairs(tables) do
					table.insert(compacted_tables, ftable)
				end
				table.insert(connections, compacted_tables)
			end

			for i, tables in ipairs(connections) do
				for j, table in ipairs(tables) do
					if table.id then
						if j ~= 1 then
							if tables[j - 1].id then
								C.SetTablePreviousConnectedTable(table.id, tables[j - 1].id)
							end
						end
						if j ~= #tables then
							if tables[j + 1].id then
								C.SetTableNextConnectedTable(table.id, tables[j + 1].id)
							end
						end
						if i ~= 1 then
							if connections[i - 1][1] and connections[i - 1][1].id then
								C.SetTablePreviousHorizontalConnectedTable(table.id, connections[i - 1][1].id)
							end
						end
						if i ~= #connections then
							if connections[i + 1][1] and connections[i + 1][1].id then
								C.SetTableNextHorizontalConnectedTable(table.id, connections[i + 1][1].id)
							end
						end
					end
				end
			end
		end

		if menu.viewCreated then
			menu.viewCreated(layer, table.unpack(children))
		end
	else
		DebugError(TraceBack())
		ScheduleReloadUI()
		error("Failed to create view for menu " .. menu.name .. ". Reloading UI ...")
	end
end

function widgetPrototypes.frame:update()
	if self.id then
		for _, cell in ipairs(self.functionCells) do
			if cell.id then
				local mouseovertext = cell.properties.mouseOverText
				if type(mouseovertext) == "function" then
					C.SetMouseOverText(cell.id, mouseovertext(cell))
				end
				if (cell.type ~= "flowchartnode") and (cell.type ~= "flowchartedge") then
					local cellbgcolor = cell.properties.cellBGColor
					if type(cellbgcolor) == "function" then
						cellbgcolor = cellbgcolor(cell)
						SetTableCellColor(cell.row.table.id, cell.row.index, cell.index, cellbgcolor.r, cellbgcolor.g, cellbgcolor.b, cellbgcolor.a)
					end
				end

				if cell.type == "text" then
					local text = cell.properties.text
					if type(text) == "function" then
						SetText(cell.id, text(cell))
					end
					local color = cell.properties.color
					if type(color) == "function" then
						color = color(cell)
						SetTextColor(cell.id, color.r, color.g, color.b, color.a)
						if (not rawget(cell.properties, "glowfactor")) and color.glow then
							C.SetFontStringGlowFactor(cell.id, color.glow)
						end
					end
					local glowfactor = cell.properties.glowfactor
					if type(glowfactor) == "function" then
						C.SetFontStringGlowFactor(cell.id, glowfactor(cell))
					end
				elseif cell.type == "boxtext" then
					local text = cell.properties.text
					if type(text) == "function" then
						C.SetBoxText(cell.id, text(cell))
					end
					local color = cell.properties.color
					if type(color) == "function" then
						color = color(cell)
						C.SetBoxTextColor(cell.id, Helper.ffiColor(color))
						if (not rawget(cell.properties, "glowfactor")) and color.glow then
							C.SetBoxTextGlowFactor(cell.id, color.glow)
						end
					end
					local glowfactor = cell.properties.glowfactor
					if type(glowfactor) == "function" then
						C.SetBoxTextGlowFactor(cell.id, glowfactor(cell))
					end
					local boxcolor = cell.properties.boxColor
					if type(boxcolor) == "function" then
						boxcolor = boxcolor(cell)
						C.SetBoxTextBoxColor(cell.id, Helper.ffiColor(boxcolor))
					end
				elseif cell.type == "button" then
					local textproperty = cell.properties.text
					local text = textproperty.text
					if type(text) == "function" then
						text = text(cell)
						local scaling = textproperty.scaling
						local font = textproperty.font
						local fontsize = Helper.scaleFont(font, textproperty.fontsize, scaling)
						local width = cell:getWidth()
						local offsetx = Helper.scaleX(cell.properties.x, scaling)
						SetButtonText(cell.id, TruncateText(text, font, fontsize, width - 2 * offsetx))
					end
					local color = textproperty.color
					if type(color) == "function" then
						color = color(cell)
						C.SetButtonTextColor(cell.id, Helper.ffiColor(color))
						if (not rawget(textproperty, "glowfactor")) and color.glow then
							C.SetButtonTextGlowFactor(cell.id, color.glow)
						end
					end
					local glowfactor = textproperty.glowfactor
					if type(glowfactor) == "function" then
						C.SetButtonTextGlowFactor(cell.id, glowfactor(cell))
					end
					local text2property = cell.properties.text2
					local text2 = text2property.text
					if type(text2) == "function" then
						text2 = text2(cell)
						local scaling = text2property.scaling
						local font = text2property.font
						local fontsize = Helper.scaleFont(font, text2property.fontsize, scaling)
						local width = cell:getWidth()
						local offsetx = Helper.scaleX(cell.properties.x, scaling)
						C.SetButtonText2(cell.id, TruncateText(text2, font, fontsize, width - 2 * offsetx))
					end
					local color2 = text2property.color
					if type(color2) == "function" then
						color2 = color2(cell)
						C.SetButtonTextColor(cell.id, Helper.ffiColor(color2))
						if (not rawget(text2property, "glowfactor")) and color2.glow then
							C.SetButtonText2GlowFactor(cell.id, color2.glow)
						end
					end
					local glowfactor = text2property.glowfactor
					if type(glowfactor) == "function" then
						C.SetButtonText2GlowFactor(cell.id, glowfactor(cell))
					end
					local iconproperty = cell.properties.icon
					local iconid = iconproperty.icon
					if type(iconid) == "function" then
						iconid = iconid(cell)
						C.SetButtonIconID(cell.id, iconid)
					end
					local iconcolor = iconproperty.color
					if type(iconcolor) == "function" then
						iconcolor = iconcolor(cell)
						C.SetButtonIconColor(cell.id, Helper.ffiColor(iconcolor))
						if (not rawget(iconproperty, "glowfactor")) and iconcolor.glow then
							C.SetButtonIconGlowFactor(cell.id, iconcolor.glow)
						end
					end
					local glowfactor = iconproperty.glowfactor
					if type(glowfactor) == "function" then
						C.SetButtonIconGlowFactor(cell.id, glowfactor(cell))
					end
					local icon2property = cell.properties.icon2
					local icon2id = icon2property.icon
					if type(icon2id) == "function" then
						icon2id = icon2id(cell)
						C.SetButtonIcon2ID(cell.id, icon2id)
					end
					local icon2color = icon2property.color
					if type(icon2color) == "function" then
						icon2color = icon2color(cell)
						C.SetButtonIcon2Color(cell.id, Helper.ffiColor(icon2color))
						if (not rawget(icon2property, "glowfactor")) and icon2color.glow then
							C.SetButtonIcon2GlowFactor(cell.id, icon2color.glow)
						end
					end
					local glowfactor = icon2property.glowfactor
					if type(glowfactor) == "function" then
						C.SetButtonIcon2GlowFactor(cell.id, glowfactor(cell))
					end
					local active = cell.properties.active
					if type(active) == "function" then
						C.SetButtonActive(cell.id, active(cell) and true or false)
					end
					local bgColor = cell.properties.bgColor
					if type(bgColor) == "function" then
						bgColor = bgColor(cell)
						SetButtonColor(cell.id, bgColor.r, bgColor.g, bgColor.b, bgColor.a)
						C.SetButtonGlowFactor(cell.id, bgColor.glow)
					end
					local highlightColor = cell.properties.highlightColor
					if type(highlightColor) == "function" then
						highlightColor = highlightColor(cell)
						C.SetButtonHighlightColor(cell.id, Helper.ffiColor(highlightColor))
						C.SetButtonHighlightGlowFactor(cell.id, highlightColor.glow)
					end
				elseif cell.type == "editbox" then
					local active = cell.properties.active
					if type(active) == "function" then
						C.SetEditBoxActive(cell.id, active(cell))
					end
					local textHidden = cell.properties.textHidden
					if type(textHidden) == "function" then
						C.SetEditBoxTextHidden(cell.id, textHidden(cell))
					end
				elseif cell.type == "shieldhullbar" then
					local shield = cell.properties.shield
					if type(shield) == "function" then
						C.SetShieldHullBarShieldPercent(cell.id, shield(cell))
					end
					local hull = cell.properties.hull
					if type(hull) == "function" then
						C.SetShieldHullBarHullPercent(cell.id, hull(cell))
					end
					local glowfactor = cell.properties.glowfactor
					if type(glowfactor) == "function" then
						C.SetShieldHullBarGlowFactor(cell.id, glowfactor(cell))
					end
				elseif cell.type == "statusbar" then
					local current = cell.properties.current
					if type(current) == "function" then
						C.SetStatusBarCurrentValue(cell.id, current(cell))
					end
					local start = cell.properties.start
					if type(start) == "function" then
						C.SetStatusBarStartValue(cell.id, start(cell))
					end
					local max = cell.properties.max
					if type(max) == "function" then
						C.SetStatusBarMaxValue(cell.id, max(cell))
					end
				elseif cell.type == "icon" then
					local textproperty = cell.properties.text
					local text = textproperty.text
					if type(text) == "function" then
						C.SetIconText(cell.id, text(cell))
					end
					local color = textproperty.color
					if type(color) == "function" then
						color = color(cell)
						C.SetIconTextColor(cell.id, Helper.ffiColor(color))
						if (not rawget(textproperty, "glowfactor")) and color.glow then
							C.SetIconTextGlowFactor(cell.id, color.glow)
						end
					end
					local glowfactor = textproperty.glowfactor
					if type(glowfactor) == "function" then
						C.SetIconTextGlowFactor(cell.id, glowfactor(cell))
					end
					local text2property = cell.properties.text2
					local text2 = text2property.text
					if type(text2) == "function" then
						C.SetIconText2(cell.id, text2(cell))
					end
					local color = text2property.color
					if type(color) == "function" then
						color = color(cell)
						C.SetIconText2Color(cell.id, Helper.ffiColor(color))
						if (not rawget(text2property, "glowfactor")) and color.glow then
							C.SetIconText2GlowFactor(cell.id, color.glow)
						end
					end
					local glowfactor = text2property.glowfactor
					if type(glowfactor) == "function" then
						C.SetIconText2GlowFactor(cell.id, glowfactor(cell))
					end
					local color = cell.properties.color
					if type(color) == "function" then
						color = color(cell)
						C.SetIconColor(cell.id, Helper.ffiColor(color))
						if (not rawget(cell.properties, "glowfactor")) and color.glow then
							C.SetIconGlowFactor(cell.id, color.glow)
						end
					end
					local glowfactor = cell.properties.glowfactor
					if type(glowfactor) == "function" then
						C.SetIconGlowFactor(cell.id, glowfactor(cell))
					end
					local icon = cell.properties.icon
					if type(icon) == "function" then
						C.SetIcon(cell.id, icon(cell))
					end
				elseif cell.type == "dropdown" then
					local curOption = cell.properties.startOption
					if type(curOption) == "function" then
						C.SetDropDownCurOption(cell.id, curOption(cell))
					end
					local hasfunctiontexts = false
					local numtexts = #cell.properties.options
					local optiontexts = ffi.new("const char*[?]", numtexts)
					for i, option in ipairs(cell.properties.options) do
						if type(option.text) == "function" then
							optiontexts[i - 1] = Helper.ffiNewString(option.text(self))
							hasfunctiontexts = true
						else
							optiontexts[i - 1] = Helper.ffiNewString(option.text or "")
						end
					end
					if hasfunctiontexts then
						C.SetDropDownOptionTexts(cell.id, optiontexts, numtexts)
					end
					hasfunctiontexts = false
					local optiontexts2 = ffi.new("const char*[?]", numtexts)
					for i, option in ipairs(cell.properties.options) do
						if type(option.text2) == "function" then
							optiontexts2[i - 1] = Helper.ffiNewString(option.text2(self))
							hasfunctiontexts = true
						else
							optiontexts2[i - 1] = Helper.ffiNewString(option.text2 or "")
						end
					end
					if hasfunctiontexts then
						C.SetDropDownOptionTexts2(cell.id, optiontexts2, numtexts)
					end
				elseif cell.type == "flowchartnode" then
					local color = cell.properties.outlineColor
					if type(color) == "function" then
						color = color(cell)
						C.SetFlowChartNodeOutlineColor(cell.id, Helper.ffiColor(color))
					end
					local text = cell.properties.text.text
					if type(text) == "function" then
						C.SetFlowChartNodeCaptionText(cell.id, tostring(text(cell)))
					end
					local color = cell.properties.text.color
					if type(color) == "function" then
						color = color(cell)
						C.SetFlowChartNodeCaptionTextColor(cell.id, Helper.ffiColor(color))
						if (not rawget(cell.properties.text, "glowfactor")) and color.glow then
							C.SetFlowChartNodeCaptionTextGlowFactor(cell.id, color.glow)
						end
					end
					local glowfactor = cell.properties.text.glowfactor
					if type(glowfactor) == "function" then
						C.SetFlowChartNodeCaptionTextGlowFactor(cell.id, glowfactor(cell))
					end
					-- status
					local statuscolor = cell.properties.statusColor
					local statusglowfactor, rawstatusglowfactor
					local text = cell.properties.statustext.text
					if type(text) == "function" then
						text = text(cell)
						C.SetFlowChartNodeStatusText(cell.id, tostring(text))
					end
					if text ~= "" then
						if not statuscolor then
							statuscolor = cell.properties.statustext.color
						end
						if not statusglowfactor then
							rawstatusglowfactor = rawget(cell.properties.statustext, "glowfactor")
							statusglowfactor = cell.properties.statustext.glowfactor
						end
					end
					local icon = cell.properties.statusicon.icon
					if type(icon) == "function" then
						icon = icon(cell)
						C.SetFlowChartNodeStatusIcon(cell.id, icon)
					end
					if icon ~= "" then
						if not statuscolor then
							statuscolor = cell.properties.statusicon.color
						end
						if not statusglowfactor then
							rawstatusglowfactor = rawget(cell.properties.statusicon, "glowfactor")
							statusglowfactor = cell.properties.statusicon.glowfactor
						end
					end
					local bgicon = cell.properties.statusBgIconID
					if type(bgicon) == "function" then
						C.SetFlowChartNodeStatusBgIcon(cell.id, bgicon(cell))
					end
					if type(statuscolor) == "function" then
						statuscolor = statuscolor(cell)
						C.SetFlowChartNodeStatusColor(cell.id, Helper.ffiColor(statuscolor))
						if (not rawstatusglowfactor) and statuscolor.glow then
							C.SetFlowChartNodeStatusGlowFactor(cell.id, statuscolor.glow)
						end
					end
					if type(statusglowfactor) == "function" then
						C.SetFlowChartNodeStatusGlowFactor(cell.id, statusglowfactor(cell))
					end
					-- value
					local value = cell.properties.value
					if type(value) == "function" then
						C.SetFlowChartNodeCurValue(cell.id, value(cell))
					end
				elseif cell.type == "flowchartedge" then
					local color = cell.properties.color
					if type(color) == "function" then
						color = color(cell)
						C.SetFlowChartEdgeColor(cell.id, Helper.ffiColor(color))
					end
				elseif cell.type == "checkbox" then
					local checked = cell.properties.checked
					if type(checked) == "function" then
						C.SetCheckBoxChecked2(cell.id, checked(cell), true)
					end
					local bgcolor = cell.properties.bgColor
					if type(bgcolor) == "function" then
						C.SetCheckBoxColor(cell.id, Helper.ffiColor(bgcolor(cell)))
					end
					local glowfactor = cell.properties.glowfactor
					if type(glowfactor) == "function" then
						C.SetCheckBoxSymbolGlowFactor(cell.id, glowfactor(cell))
					end
				end
			end
		end
	end
end

---------- RenderTarget member functions ----------

function widgetHelpers.rendertarget:createDescriptor()
	local helpoverlay = createOverlayPropertyInfo(self)

	return CreateRenderTarget(
		self.properties.width,
		self.properties.height,
		self.properties.x,
		self.properties.y,
		self.properties.alpha,
		self.properties.mouseOverText,
		helpoverlay,
		self.properties.clear,
		self.properties.startnoise)
end

---------- Table member functions ----------

function widgetPrototypes.table:setDefaultCellProperties(widgettype, properties)
	if not defaultWidgetProperties[widgettype] then
		DebugError(string.format("ftable:setDefaultCellProperties(): Invalid widget type '%s'", widgettype))
		return self
	end
	self.defaultCellProperties = self.defaultCellProperties or { }
	local defaultproperties = self.defaultCellProperties[widgettype]
	if not defaultproperties then
		defaultproperties = { }
		setmetatable(defaultproperties, widgetPropertyMetatables[widgettype])
		self.defaultCellProperties[widgettype] = defaultproperties
	end
	defaultproperties:apply(properties)
	return self
end

function widgetPrototypes.table:setDefaultComplexCellProperties(widgettype, complexproperty, properties)
	if not complexCellProperties[widgettype] or not complexCellProperties[widgettype][complexproperty] then
		DebugError(string.format("ftable:setDefaultComplexCellProperties(): Invalid widget type '%s' or widget type has no complex property '%s'", widgettype, complexproperty))
		return self
	end
	self.defaultComplexCellProperties = self.defaultComplexCellProperties or { }
	self.defaultComplexCellProperties[widgettype] = self.defaultComplexCellProperties[widgettype] or { }
	local defaultproperties = self.defaultComplexCellProperties[widgettype][complexproperty]
	if not defaultproperties then
		defaultproperties = { }
		setmetatable(defaultproperties, widgetPropertyMetatables[complexCellProperties[widgettype][complexproperty]])
		self.defaultComplexCellProperties[widgettype][complexproperty] = defaultproperties
	end
	defaultproperties:apply(properties)
	return self
end

-- private column width helper
function setTableColumnWidthData(ftable, col, width, percent, min, weight, scaling)
	local coldata = ftable.columndata[col]
	if ftable.columndata.final then
		DebugError("ftable:setColWidth*(): Columns are already final and cannot be changed any more")
	elseif not coldata then
		DebugError(string.format("ftable:setColWidth*(): Column %s does not exist", col))
	else
		coldata.width = width
		coldata.percent = percent
		coldata.min = min
		coldata.weight = weight or 1
		coldata.scaling = scaling
	end
	return ftable
end

-- human-readable interface functions
function widgetPrototypes.table:setColWidth(col, width, scaling)						return setTableColumnWidthData(self, col, width, false, false, nil, scaling) end
function widgetPrototypes.table:setColWidthMin(col, width, weight, scaling)				return setTableColumnWidthData(self, col, width, false, true, weight, scaling) end
function widgetPrototypes.table:setColWidthPercent(col, width)							return setTableColumnWidthData(self, col, width, true, false) end
function widgetPrototypes.table:setColWidthMinPercent(col, width, weight)				return setTableColumnWidthData(self, col, width, true, true, weight) end

-- default colspan can be undone with cell:setColSpan(1)
function widgetPrototypes.table:setDefaultColSpan(col, colspan)
	self.columndata[col].colspan = colspan
	return self
end

-- default bgcolspan can be undone with cell:setBackgroundColSpan(1)
function widgetPrototypes.table:setDefaultBackgroundColSpan(col, bgcolspan)
	self.columndata[col].bgcolspan = bgcolspan
	return self
end

function finalizeTableColumnWidths(ftable)
	-- calculate exact column widths
	if not ftable.columndata.final then
		local scaling = ftable.properties.scaling
		local usablewidth = math.floor(ftable.properties.width)
		if usablewidth == 0 then
			usablewidth = math.floor(ftable.frame.properties.width) - math.ceil(ftable.properties.x)
		end
		-- determine total usable width of all columns, without borders
		local totalborderwidth = 0
		for i = 1, ftable.numcolumns - 1 do
			totalborderwidth = totalborderwidth + Helper.borderSize
		end
		usablewidth = math.max(0, usablewidth - totalborderwidth)
		-- convert provided "min" and "percent" values, apply scaling
		local usedwidth = 0
		local varcolumnweight = 0
		for i = 1, ftable.numcolumns do
			local coldata = ftable.columndata[i]
			if coldata.percent then
				coldata.width = coldata.width * usablewidth / 100
				coldata.percent = false
			elseif coldata.scaling or (scaling and coldata.scaling == nil) then		-- coldata.scaling takes precedence if non-nil
				coldata.width = Helper.scaleX(coldata.width)
			end
			coldata.width = math.floor(coldata.width)
			usedwidth = usedwidth + coldata.width
			if coldata.min and coldata.weight > 0 then
				varcolumnweight = varcolumnweight + coldata.weight
			else
				coldata.min = false
				coldata.weight = 0
			end
		end
		if ftable.properties.reserveScrollBar then
			if varcolumnweight == 0 then
				DebugError("table column finalization with reserveScrollBar: No column with variable width defined, cannot reserve additional space")
				ftable.properties.reserveScrollBar = false
			elseif usedwidth + Helper.scrollbarWidth > usablewidth then
				DebugError(string.format("table column finalization with reserveScrollBar: Cannot reserve enough space for scroll bar, width available=%d, required=%d", usablewidth, usedwidth + Helper.scrollbarWidth))
				ftable.properties.reserveScrollBar = false
			else
				usedwidth = usedwidth + Helper.scrollbarWidth
			end
		end
		if usedwidth < usablewidth and varcolumnweight > 0 then
			for i = 1, ftable.numcolumns do
				local coldata = ftable.columndata[i]
				if coldata.min and coldata.weight > 0 then
					local addedwidth = math.ceil((usablewidth - usedwidth) * coldata.weight / varcolumnweight)
					coldata.width = coldata.width + addedwidth
					usedwidth = usedwidth + addedwidth
					varcolumnweight = varcolumnweight - coldata.weight
					if varcolumnweight <= 0 then break end
				end
			end
		end
		-- make sure that there are no 0 columns if the table width is defined
		if ftable.properties.width ~= 0 then
			for i = 1, ftable.numcolumns do
				local coldata = ftable.columndata[i]
				if coldata.width == 0 then
					local addedwidth = 1
					coldata.width = addedwidth
					usedwidth = usedwidth + addedwidth
				end
			end
		end
		ftable.properties.width = usedwidth + totalborderwidth
		ftable.columndata.final = true
	end
end

function widgetPrototypes.table:getFullHeight()
	local fullheight = 0
	local numrows = #self.rows
	for rowindex, row in ipairs(self.rows) do
		fullheight = fullheight + row:getHeight()
		if rowindex < numrows and row.properties.borderBelow then
			fullheight = fullheight + Helper.borderSize
		end
	end
	return fullheight
end

function widgetPrototypes.table:getMaxVisibleHeight()
	local maxheight = self.properties.maxVisibleHeight
	local availableheight = self.frame:getAvailableHeight() - self.properties.y
	if maxheight > 0 and maxheight < availableheight then
		return maxheight
	end
	return availableheight
end

function widgetPrototypes.table:getVisibleHeight()
	local height = self:getFullHeight()
	local maxheight = self:getMaxVisibleHeight()
	if maxheight > 0 and height > maxheight then
		-- Not all rows will be visible, we'll get a scrollbar
		-- TODO: Check spacing below the last visible row and whether it can be removed safely
		return maxheight
	end
	return height
end

function widgetPrototypes.table:hasScrollBar()
	local height = self:getFullHeight()
	local maxheight = self:getMaxVisibleHeight()
	return maxheight > 0 and height > maxheight
end

-- Example usage:
--   local row = ftable:addRow("foo", { fixed = true, bgColor = Color["foo"] })
-- (rowdata == nil or false: Not selectable. For selectable row without specific rowdata, use e.g. true)
function widgetPrototypes.table:addRow(rowdata, properties)
	finalizeTableColumnWidths(self)
	local row = {
		table = self,
		index = nil,						-- row index in table (set below)
		rowdata = rowdata,					-- data associated with row, passed to callbacks
		properties = { }					-- row properties
	}
	table.insert(self.rows, row)
	row.index = #self.rows

	-- set metatables to enable member functions and default properties
	setmetatable(row, widgetMetatables.row)
	setmetatable(row.properties, widgetPropertyMetatables.row)

	-- propagate scaling from table to row
	if not self.properties.scaling then
		row.properties.scaling = false
	end
	-- apply properties if provided
	row.properties:apply(properties)

	-- create "pluripotent" cell representation for each column (each cell can be specialized for specific widget type)
	for i = 1, self.numcolumns do
		local cell = {
			row = row,
			index = i,						-- column index in row
			descriptor = nil,				-- descriptor (used temporarily)
			id = nil,						-- widget ID, valid while displayed
			type = "cell",					-- widget type (set on initialization)
			colspan = 1,					-- column span
			bgcolspan = 1,					-- background column span
			properties = { },				-- cell properties
			handlers = { }					-- event handlers
		}
		row[i] = cell

		-- set metatables to enable member functions and default properties
		setmetatable(cell, widgetMetatables.cell)
		setmetatable(cell.properties, widgetPropertyMetatables.cell)

		-- propagate scaling from row to cell
		if not row.properties.scaling then
			cell.properties.scaling = false
		end

		-- propagate bgColor from row to cell
		cell.properties.cellBGColor = row.properties.bgColor
	end
	-- apply default colspans in reverse order to deal safely with bad input
	for i = self.numcolumns, 1, -1 do
		local cell = row[i]
		local colspan = self.columndata[i].colspan
		if colspan > 1 then
			cell:setColSpan(colspan)
		end
		local bgcolspan = self.columndata[i].bgcolspan
		if bgcolspan > 1 then
			cell:setBackgroundColSpan(bgcolspan)
		end
	end

	return row
end

function widgetPrototypes.table:addEmptyRow(height)
	local row = self:addRow(nil, {  })
	row[1]:createText(" ", { fontsize = 1, minRowHeight = height })
	return row
end

function widgetPrototypes.table:setTopRow(row)
	self.toprow = row
	return self
end
function widgetPrototypes.table:setSelectedRow(row)
	self.selectedrow = row
	return self
end
function widgetPrototypes.table:setSelectedCol(col)
	self.selectedcol = col
	return self
end
function widgetPrototypes.table:setShiftStartEnd(startrow, endrow)
	self.shiftstart = startrow
	self.shiftend   = endrow
	return self
end

function widgetPrototypes.table:addConnection(row, col, clearCol)
	local menu = self.frame.menu
	menu.tableConnections = menu.tableConnections or {}
	if menu.tableConnections[col] then
		if clearCol then
			menu.tableConnections[col] = {}
		end
		menu.tableConnections[col][row] = self
	else
		menu.tableConnections[col] = { [row] = self }
	end
	menu.tableConnections.refresh = true
end

function Helper.clearTableConnectionColumn(menu, col)
	menu.tableConnections = menu.tableConnections or {}
	menu.tableConnections[col] = nil
end

function widgetHelpers.table:createDescriptor()
	local header = self.properties.header
	local taborder = self.properties.tabOrder
	local skiptabchange = self.properties.skipTabChange
	local defaultinteractiveobject = self.properties.defaultInteractiveObject
	local borderenabled = self.properties.borderEnabled
	local numfixedrows = 0
	local offsetx = self.properties.x
	local offsety = self.properties.y
	local maxheight = self:getMaxVisibleHeight()
	local selectedcol = math.min(self.selectedcol, self.numcolumns)
	local wraparound = self.properties.wraparound
	local highlightmode = self.properties.highlightMode
	local multiselect = self.properties.multiSelect
	local backgroundid = self.properties.backgroundID
	local backgroundcolor = self.properties.backgroundColor
	local helpoverlay = createOverlayPropertyInfo(self)

	-- init toprow / selectedrow
	local menu = self.frame.menu
	local toprow = self.toprow
	local selectedrow = self.selectedrow
	if taborder == 1 and menu.param then
		toprow = toprow or menu.param[1]
		selectedrow = selectedrow or menu.param[2]
	end
	toprow = math.min(toprow or 0, #self.rows)
	selectedrow = math.min(selectedrow or 0, #self.rows)

	local columnwidths = self.numcolumns > 0 and { } or { 0 }
	local columnwidthpercent = false
	for colidx, coldata in ipairs(self.columndata) do
		columnwidths[colidx] = coldata.width
	end
	if self.numcolumns > 0 then
		self.createdWithScrollBar = self:hasScrollBar()
		if self.createdWithScrollBar then
			if not self.properties.reserveScrollBar then
				-- Reduce width of rightmost column to make room for the scrollbar
				if columnwidths[self.numcolumns] >= Helper.scrollbarWidth then
					columnwidths[self.numcolumns] = columnwidths[self.numcolumns] - Helper.scrollbarWidth
				else
					DebugError(string.format("ftable:createDescriptor(): Table requires scrollbar but rightmost column [%d] is not wide enough. width=%d, required=%d", self.numcolumns, columnwidths[self.numcolumns], Helper.scrollbarWidth))
					columnwidths[self.numcolumns] = 0
				end
			end
		else
			if self.properties.reserveScrollBar then
				-- Scrollbar was reserved but not needed, make columns wider
				local varcolumnweight = 0
				for i, coldata in ipairs(self.columndata) do
					if coldata.min then
						varcolumnweight = varcolumnweight + coldata.weight
					end
				end
				if varcolumnweight > 0 then
					local totaladdedwidth = 0
					for i, coldata in ipairs(self.columndata) do
						if coldata.min then
							local addedwidth = math.ceil((Helper.scrollbarWidth - totaladdedwidth) * coldata.weight / varcolumnweight)
							coldata.width = coldata.width + addedwidth
							totaladdedwidth = totaladdedwidth + addedwidth
							columnwidths[i] = coldata.width
							varcolumnweight = varcolumnweight - coldata.weight
							if varcolumnweight <= 0 then break end
						end
					end
				end
			end
		end
	end

	local tablecontent = { }
	local bestselectablerow = 0
	local multiselectedrows = {}	-- determine selected rows in multi-select case
	local rowDataMap = {}
	for rowidx, row in ipairs(self.rows) do
		if row.properties.fixed then
			numfixedrows = rowidx
		end
		local contentcells = { }
		for cellidx, cell in ipairs(row) do
			local desc = nil
			if cell.colspan ~= 0 then
				desc = widgetHelpers[cell.type].createDescriptor(cell)
			end
			if cell.descriptor then
				ReleaseDescriptor(cell.descriptor)
			end
			cell.descriptor = desc

			local isfunctioncell = false
			local cellbgcolor = cell.properties.cellBGColor
			if type(cellbgcolor) == "function" then
				cellbgcolor = cellbgcolor(self)
				isfunctioncell = true
			end
			if isfunctioncell then
				table.insert(self.frame.functionCells, cell)
			end

			contentcells[cellidx] = { colspan = cell.colspan, bgcolspan = cell.bgcolspan, cellbgcolor = cellbgcolor, content = desc }
		end
		tablecontent[rowidx] = {
			color = row.properties.bgColor,
			selectable = not not row.rowdata,
			borderbelow = row.properties.borderBelow,
			interactive = row.properties.interactive,
			cols = contentcells
		}
		if row.rowdata then
			if rowidx <= selectedrow then
				bestselectablerow = rowidx
			end
			rowDataMap[rowidx] = row.rowdata
		end
		-- check if multi-selected
		if row.properties.multiSelected then
			table.insert(multiselectedrows, rowidx)
		end
	end
	self.numfixedrows = numfixedrows
	selectedrow = bestselectablerow
	if selectedrow > 0 and toprow > selectedrow then
		-- TODO Klaus: check - this kept scroling the table up if you didn't change the selection, what was it's purpose?
		--toprow = selectedrow
	end 
	if toprow <= numfixedrows then
		toprow = 0
	end
	if selectedcol > 0 then
		if selectedrow > 0 then
			local cell = self.rows[selectedrow][selectedcol]
			if (cell.type ~= "button") and (cell.type ~= "checkbox") and (cell.type ~= "dropdown") and (cell.type ~= "editbox") and (cell.type ~= "slidercell") then
				DebugError("table:createDescriptor(): Initial selected cell '" .. selectedrow .. " / " .. selectedcol .. "' specified, but is not interactive. Skipping selection. (widget type = '" .. cell.type .. "')")
				selectedcol = 0
			end
		end 
	end

	local initialSelection = {
		toprow				= toprow,
		selectedrow			= selectedrow,
		selectedcol			= selectedcol,
		multiselectedrows	= multiselectedrows,
		shiftstart			= self.shiftstart,
		shiftend			= self.shiftend
	}
	local desc = CreateTable(header, tablecontent, columnwidths, columnwidthpercent, borderenabled, taborder, skiptabchange, defaultinteractiveobject, numfixedrows, offsetx, offsety, maxheight, initialSelection, wraparound, highlightmode, multiselect, backgroundid, backgroundcolor, helpoverlay)
	if desc == nil then
		DebugError(TraceBack())
		return
	end
	
	if taborder == 1 then
		-- TODO
		self.frame.menu.defaulttable = desc
	end
	Helper.addTableDescRowDataMap(menu, desc, rowDataMap)
	return desc
end

---------- Row member functions ----------

function widgetPrototypes.row:getHeight()
	local height = 0
	for _, cell in ipairs(self) do
		if cell.colspan ~= 0 then
			local celloffsety = Helper.scaleY(cell.properties.y, cell.properties.scaling)		-- 0 for uninitialised cells
			if (cell.type == "icon") and (cell.properties.affectRowHeight == false) then
				celloffsety = 0
			end
			local cellheight = cell:getHeight()
			height = math.max(height, celloffsety + cellheight)
		end
	end
	return height
end

---------- Generic cell member functions ----------

-- NOTE: All set*() functions of cells return self to allow chaining

function widgetPrototypes.cell:setColSpan(colspan)
	if colspan < 1 then
		DebugError(string.format("cell:setColSpan(%d) Invalid colspan", colspan))
	elseif self.colspan == 0 then
		DebugError(string.format("cell:setColSpan(%d) Invalid, existing colspan on cell [%d][%d]", colspan, self.row.index, self.index))
	else
		local prevcolspan = self.colspan			-- In case setColSpan() was called before on this or a following cell, track how many cols are affected
		self.colspan = math.min(math.floor(colspan), self.row.table.numcolumns - self.index + 1)
		if self.colspan < colspan then
			DebugError(string.format("cell:setColSpan(%d) colspan too high", colspan))
		end
		for i = 1, self.colspan - 1 do
			local cell = self.row[self.index + i]
			if cell.type ~= "cell" then
				DebugError(string.format("cell:setColSpan(%d) on [%d][%d] hides already created cell [%d][%d]", colspan, self.row.index, self.index, cell.row.index, cell.index))
			end
			prevcolspan = prevcolspan + cell.colspan
			cell.colspan = 0
		end
		-- In case the following columns were included in a previous colspan that we overwrote, repair them
		-- (particularly, calling setColSpan(1) on an existing colspan cell should undo the colspan)
		for i = self.colspan, prevcolspan - 1 do
			self.row[self.index + i].colspan = 1
		end
	end
	return self
end

function widgetPrototypes.cell:setBackgroundColSpan(bgcolspan)
	if bgcolspan < 1 then
		DebugError(string.format("cell:setBackgroundColSpan(%d) Invalid background colspan", bgcolspan))
	elseif self.bgcolspan == 0 then
		DebugError(string.format("cell:setBackgroundColSpan(%d) Invalid, existing background colspan on cell [%d][%d]", bgcolspan, self.row.index, self.index))
	else
		local prevbgcolspan = self.bgcolspan		-- In case setBackgroundColSpan() was called before on this or a following cell, track how many cols are affected
		self.bgcolspan = math.min(math.floor(bgcolspan), self.row.table.numcolumns - self.index + 1)
		if self.bgcolspan < bgcolspan then
			DebugError(string.format("cell:setBackgroundColSpan(%d) background colspan too high", bgcolspan))
		end
		for i = 1, self.bgcolspan - 1 do
			local cell = self.row[self.index + i]
			prevbgcolspan = prevbgcolspan + cell.bgcolspan
			cell.bgcolspan = 0
		end
		-- In case the following columns were included in a previous bgcolspan that we overwrote, repair them
		-- (particularly, calling setBackgroundColSpan(1) on an existing bgcolspan cell should undo the bgcolspan)
		for i = self.bgcolspan, prevbgcolspan - 1 do
			self.row[self.index + i].bgcolspan = 1
		end
	end
	return self
end

function widgetPrototypes.cell:getColSpanWidth()
	if self.colspan < 1 then
		return 0
	end
	local columndata = self.row.table.columndata
	local colspanwidth = columndata[self.index].width
	for i = 1, self.colspan - 1 do
		local cell = self.row[self.index + i]
		colspanwidth = colspanwidth + columndata[cell.index].width + Helper.borderSize
	end
	-- add reserved scrollbar width if fixed row and last column included (NOTE: Only do this when we know that there will be a scrollbar)
	if self.row.table.createdWithScrollBar then
		if self.row.properties.fixed then
			if self.row.table.properties.reserveScrollBar then
				if self.index + self.colspan - 1 == self.row.table.numcolumns then
					colspanwidth = colspanwidth + Helper.scrollbarWidth
				end
			end
		end
	end
	return colspanwidth
end

function widgetPrototypes.cell:getOffsetX()
	local columndata = self.row.table.columndata
	local offset = 0
	for i = 1, self.index - 1 do
		local cell = self.row[i]
		offset = offset + columndata[cell.index].width + Helper.borderSize
	end
	return offset
end

function widgetPrototypes.cell:getWidth()
	if self.properties.width ~= 0 then
		return Helper.scaleX(self.properties.width, self.properties.scaling)
	end
	return self:getColSpanWidth() - Helper.scaleX(self.properties.x, self.properties.scaling)
end

function widgetPrototypes.cell:getHeight()
	local scaling = self.properties.scaling
	local height = Helper.scaleY(self.properties.height, scaling)	-- 0 for uninitialised cells
	if height == 0 then
		if (self.type == "text") or (self.type == "boxtext") then
			return self:getMinTextHeight(scaling)
		elseif self.type == "cell" then
			return 1
		end
	end
	return height
end

function widgetHelpers.cell:createDescriptor()
	-- create empty cell descriptor
	local color = Color["text_normal"]
	local font = Helper.standardFont
	local fontsize = Helper.scaleFont(font, Helper.standardFontSize, self.properties.scaling)
	-- force cell size to minimum 1x1

	local emptyText = {
		text = "",
		alignment = Helper.standardHalignment,
		color = color,
		fontname = font,
		fontsize = fontsize,
		wordwrap = false,
		offset = { x = 0, y = 0 },
		size = { width = 1, height = 1 },
	}
	return CreateFontString(emptyText)
end

function initTableCell(cell, widgettype, properties)
	if cell.colspan == 0 then
		DebugError(string.format("initTableCell: Cannot create cell [%d][%d] due to colspan", cell.row.index, cell.index))
		return false
	end
	if cell.type ~= "cell" then
		-- TODO: Support this, including use of SetCellContent() with existing table cell
		DebugError(string.format("initTableCell: Trying to overwrite existing cell [%d][%d], not supported yet", cell.row.index, cell.index))
		return false
	end
	cell.type = widgettype

	-- update metatables for type-specific member functions and default properties
	setmetatable(cell, widgetMetatables[widgettype])
	setmetatable(cell.properties, widgetPropertyMetatables[widgettype])

	-- create complex cell properties
	local complexprops = complexCellProperties[widgettype]
	if complexprops then
		for complexprop, simpleprop in pairs(complexprops) do
			local complexproptable = { }
			setmetatable(complexproptable, widgetPropertyMetatables[simpleprop])
			rawset(cell.properties, complexprop, complexproptable)
		end
	end
	-- apply default cell properties
	local ftable = cell.row.table
	if ftable.defaultCellProperties and ftable.defaultCellProperties[widgettype] then
		cell.properties:apply(ftable.defaultCellProperties[widgettype])
	end
	if ftable.defaultComplexCellProperties and ftable.defaultComplexCellProperties[widgettype] then
		for complexprop, simpleprops in pairs(ftable.defaultComplexCellProperties[widgettype]) do
			cell.properties[complexprop]:apply(simpleprops)
		end
	end
	-- apply custom properties
	cell.properties:apply(properties)
	return true
end

---------- Specialized cell member functions and specialization functions ----------

-- text
function widgetPrototypes.cell:createText(text, properties)
	if initTableCell(self, "text", properties) then
		self.properties.text = text
	end
	return self
end

function widgetPrototypes.text:getTextHeight(scaling)
	local text = self.properties.text
	if type(text) == "function" then
		text = text(self)
	end
	local font = self.properties.font
	if scaling == nil then
		scaling = self.properties.scaling
	end
	local fontsize = Helper.scaleFont(font, self.properties.fontsize, scaling)
	return math.ceil(C.GetTextHeight(tostring(text), font, math.floor(fontsize), self.properties.wordwrap and math.floor(self:getWidth()) or 0))
end

function widgetPrototypes.text:getMinTextHeight(scaling)
	local mintextheight = Helper.scaleY(self.properties.minRowHeight, scaling) - Helper.scaleY(self.properties.y, scaling)
	return math.max(self:getTextHeight(scaling), mintextheight)
end

function widgetHelpers.text:createDescriptor()
	local text = self.properties.text
	local isfunctioncell = false
	if type(text) == "function" then
		text = text(self)
		isfunctioncell = true
	end
	local color = self.properties.color
	if type(color) == "function" then
		color = color(self)
		isfunctioncell = true
	end
	local glowfactor = rawget(self.properties, "glowfactor")
	if not glowfactor then
		glowfactor = color.glow or self.properties.glowfactor
	end
	if type(glowfactor) == "function" then
		glowfactor = glowfactor(self)
		isfunctioncell = true
	end
	local mouseovertext = self.properties.mouseOverText
	if type(mouseovertext) == "function" then
		mouseovertext = mouseovertext(self)
		isfunctioncell = true
	end
	if isfunctioncell then
		table.insert(self.row.table.frame.functionCells, self)
	end
	local titlecolor = self.properties.titleColor
	if titlecolor == propertyDefaultValue then
		titlecolor = nil
	end
	local titleglowfactor = titlecolor and titlecolor.glow or 0
	local scaling = self.properties.scaling
	local offsetx = Helper.scaleX(self.properties.x, scaling)
	local offsety = Helper.scaleY(self.properties.y, scaling)
	local width = self:getWidth()
	local height = self:getHeight()
	local helpoverlay = createOverlayPropertyInfo(self)

	local fontStringDescriptor = {}
	fontStringDescriptor.text = text
	fontStringDescriptor.alignment = self.properties.halign
	fontStringDescriptor.fontname = self.properties.font
	fontStringDescriptor.fontsize = Helper.scaleFont(font, self.properties.fontsize, scaling)
	fontStringDescriptor.color = color
	fontStringDescriptor.glowfactor = glowfactor
	fontStringDescriptor.titleglowfactor = titleglowfactor
	fontStringDescriptor.wordwrap = self.properties.wordwrap
	fontStringDescriptor.titlecolor = titlecolor
	fontStringDescriptor.mouseovertext = mouseovertext
	fontStringDescriptor.offset = { x = offsetx, y = offsety }
	fontStringDescriptor.size = { width = width, height = height }
	fontStringDescriptor.helpoverlay = helpoverlay

	return CreateFontString(fontStringDescriptor)
end

-- boxtext
function widgetPrototypes.cell:createBoxText(text, properties)
	if initTableCell(self, "boxtext", properties) then
		self.properties.text = text
	end
	return self
end

function widgetPrototypes.boxtext:getTextHeight(scaling)
	local text = self.properties.text
	if type(text) == "function" then
		text = text(self)
	end
	local font = self.properties.font
	if scaling == nil then
		scaling = self.properties.scaling
	end
	local fontsize = Helper.scaleFont(font, self.properties.fontsize, scaling)
	return math.ceil(C.GetTextHeight(tostring(text), font, math.floor(fontsize), self.properties.wordwrap and math.floor(self:getWidth()) or 0)) + 2 * Helper.borderSize
end

function widgetPrototypes.boxtext:getMinTextHeight(scaling)
	local mintextheight = Helper.scaleY(self.properties.minRowHeight, scaling) - Helper.scaleY(self.properties.textY, scaling)
	return math.max(self:getTextHeight(scaling), mintextheight)
end

function widgetHelpers.boxtext:createDescriptor()
	local text = self.properties.text
	local isfunctioncell = false
	if type(text) == "function" then
		text = text(self)
		isfunctioncell = true
	end
	local color = self.properties.color
	if type(color) == "function" then
		color = color(self)
		isfunctioncell = true
	end
	local glowfactor = rawget(self.properties, "glowfactor")
	if not glowfactor then
		glowfactor = color.glow or self.properties.glowfactor
	end
	if type(glowfactor) == "function" then
		glowfactor = glowfactor(self)
		isfunctioncell = true
	end
	local boxcolor = self.properties.boxColor
	if type(boxcolor) == "function" then
		boxcolor = boxcolor(self)
		isfunctioncell = true
	end
	local mouseovertext = self.properties.mouseOverText
	if type(mouseovertext) == "function" then
		mouseovertext = mouseovertext(self)
		isfunctioncell = true
	end
	if isfunctioncell then
		table.insert(self.row.table.frame.functionCells, self)
	end
	local scaling = self.properties.scaling
	local halign = self.properties.halign
	local font = self.properties.font
	local fontsize = Helper.scaleFont(font, self.properties.fontsize, scaling)
	local wordwrap = self.properties.wordwrap
	local textoffsetx = Helper.scaleX(self.properties.textX, scaling)
	local textoffsety = Helper.scaleY(self.properties.textY, scaling)
	local offsetx = Helper.scaleX(self.properties.x, scaling)
	local offsety = Helper.scaleY(self.properties.y, scaling)
	local width = self:getWidth()
	local height = self:getHeight()

	local boxTextDescriptor = {}
	boxTextDescriptor.text = {
		text = text,
		alignment = halign,
		fontname = font,
		fontsize = fontsize,
		color = color,
		x = textoffsetx,
		y = textoffsety,
		glowfactor = glowfactor,
	}
	boxTextDescriptor.wordwrap = wordwrap
	boxTextDescriptor.boxcolor = boxcolor
	boxTextDescriptor.mouseovertext = mouseovertext
	boxTextDescriptor.offset = { x = offsetx, y = offsety }
	boxTextDescriptor.size = { width = width, height = height }

	return CreateBoxText(boxTextDescriptor)
end

-- icon
function widgetPrototypes.cell:createIcon(icon, properties)
	if (icon == nil) or (icon == "") then
		DebugError("widget createIcon(): Texture name is empty! Using solid icon.")
		DebugError(TraceBack())
		icon = "solid"
	end
	-- Complex properties: text, text2
	if initTableCell(self, "icon", properties) then
		self.properties.icon = icon
	end
	return self
end

function widgetPrototypes.icon:setText(text, properties)
	self.properties.text.text = text
	self.properties.text.scaling = self.properties.scaling
	self.properties.text:apply(properties)
	return self
end

function widgetPrototypes.icon:setText2(text, properties)
	self.properties.text2.text = text
	self.properties.text2.scaling = self.properties.scaling
	self.properties.text2:apply(properties)
	return self
end

function widgetPrototypes.icon:getHeight(raw)
	-- super call
	local height = widgetPrototypes.cell.getHeight(self)
	if raw or self.properties.affectRowHeight then
		return height
	end
	return 1
end

function widgetHelpers.icon:createDescriptor()
	local scaling = self.properties.scaling
	local icon = self.properties.icon
	local color = self.properties.color
	local glowfactor = rawget(self.properties, "glowfactor")
	local offsetx = Helper.scaleX(self.properties.x, scaling)
	local offsety = Helper.scaleY(self.properties.y, scaling)
	local width = self:getWidth()
	local height = self:getHeight(true)
	local mouseovertext = self.properties.mouseOverText
	local affectrowheight = self.properties.affectRowHeight
	local helpoverlay = createOverlayPropertyInfo(self)

	local isfunctioncell = false
	isfunctioncell = isfunctioncell or isTextPropertyFunctionCell(self, self.properties.text)
	isfunctioncell = isfunctioncell or isTextPropertyFunctionCell(self, self.properties.text2)

	if (icon == nil) or (icon == "") then
		DebugError("widget icon:createDescriptor(): Texture name is empty! Falling back to solid icon.")
		icon = "solid"
	elseif type(icon) == "function" then
		icon = icon(self)
		isfunctioncell = true
	end
	if type(color) == "function" then
		color = color(self)
		isfunctioncell = true
	end
	if not glowfactor then
		glowfactor = color.glow or self.properties.glowfactor
	end
	if type(glowfactor) == "function" then
		glowfactor = glowfactor(self)
		isfunctioncell = true
	end
	if type(mouseovertext) == "function" then
		mouseovertext = mouseovertext(self)
		isfunctioncell = true
	end
	if isfunctioncell then
		table.insert(self.row.table.frame.functionCells, self)
	end

	local iconDescriptor = {}
	iconDescriptor.text = createTextPropertyInfo(self, self.properties.text)
	iconDescriptor.text2 = createTextPropertyInfo(self, self.properties.text2)
	iconDescriptor.icon = icon
	iconDescriptor.color = color
	iconDescriptor.mouseovertext = mouseovertext
	iconDescriptor.offset = { x = offsetx, y = offsety }
	iconDescriptor.size = { width = width, height = height }
	iconDescriptor.affectrowheight = affectrowheight
	iconDescriptor.glowfactor = glowfactor
	iconDescriptor.helpoverlay = helpoverlay

	return CreateIcon(iconDescriptor)
end

-- button
-- LEGACY NOTE: new default height = Helper.standardButtonHeight
-- LEGACY NOTE: new default width = cell width
function widgetPrototypes.cell:createButton(properties)
	-- Complex properties: text, icon, icon2, hotkey
	initTableCell(self, "button", properties)
	return self
end

function widgetPrototypes.button:setText(text, properties)
	self.properties.text.text = text
	self.properties.text.scaling = self.properties.scaling
	self.properties.text:apply(properties)
	return self
end

function widgetPrototypes.button:setText2(text, properties)
	self.properties.text2.text = text
	self.properties.text2.scaling = self.properties.scaling
	self.properties.text2:apply(properties)
	return self
end

function widgetPrototypes.button:setIcon(icon, properties)
	self.properties.icon.icon = icon
	self.properties.icon.scaling = self.properties.scaling
	self.properties.icon:apply(properties)
	return self
end

function widgetPrototypes.button:setIcon2(icon, properties)
	self.properties.icon2.icon = icon
	self.properties.icon2.scaling = self.properties.scaling
	self.properties.icon2:apply(properties)
	return self
end

function widgetPrototypes.button:setHotkey(hotkey, properties)
	self.properties.hotkey.hotkey = hotkey
	self.properties.hotkey:apply(properties)
	return self
end

function widgetPrototypes.button:getHeight()
	-- super call
	local height = widgetPrototypes.cell.getHeight(self)
	-- enforce min height if the button contains a hotkey icon
	local hotkeyproperty = self.properties.hotkey
	if hotkeyproperty.hotkey ~= "" and hotkeyproperty.displayIcon and height < Helper.buttonMinHeight then
		return Helper.buttonMinHeight
	end
	return height
end

function widgetHelpers.button:createDescriptor()
	local active = self.properties.active
	local bgColor = self.properties.bgColor
	local highlightColor = self.properties.highlightColor
	local scaling = self.properties.scaling
	local offsetx = Helper.scaleX(self.properties.x, scaling)
	local offsety = Helper.scaleY(self.properties.y, scaling)
	local width = self:getWidth()
	local height = self:getHeight()
	local mouseovertext = self.properties.mouseOverText
	local helpoverlay = createOverlayPropertyInfo(self)

	local isfunctioncell = false
	isfunctioncell = isfunctioncell or isTextPropertyFunctionCell(self, self.properties.text)
	isfunctioncell = isfunctioncell or isTextPropertyFunctionCell(self, self.properties.text2)
	isfunctioncell = isfunctioncell or isIconPropertyFunctionCell(self, self.properties.icon)
	isfunctioncell = isfunctioncell or isIconPropertyFunctionCell(self, self.properties.icon2)
	if type(active) == "function" then
		active = active(self)
		isfunctioncell = true
	end
	if type(bgColor) == "function" then
		bgColor = bgColor(self)
		isfunctioncell = true
	end
	if type(highlightColor) == "function" then
		highlightColor = highlightColor(self)
		isfunctioncell = true
	end
	if type(mouseovertext) == "function" then
		mouseovertext = mouseovertext(self)
		isfunctioncell = true
	end
	if isfunctioncell then
		table.insert(self.row.table.frame.functionCells, self)
	end

	local buttonDescriptor = {}
	buttonDescriptor.text = createTextPropertyInfo(self, self.properties.text)
	buttonDescriptor.text2 = createTextPropertyInfo(self, self.properties.text2)
	buttonDescriptor.icon = createIconPropertyInfo(self, self.properties.icon)
	buttonDescriptor.icon2 = createIconPropertyInfo(self, self.properties.icon2)
	buttonDescriptor.hotkey = createHotkeyPropertyInfo(self, self.properties.hotkey, width, height, scaling)
	buttonDescriptor.mouseovertext = mouseovertext
	buttonDescriptor.color = bgColor
	buttonDescriptor.colorglowfactor = bgColor.glow
	buttonDescriptor.highlightcolor = highlightColor
	buttonDescriptor.highlightcolorglowfactor = highlightColor.glow
	buttonDescriptor.helpoverlay = helpoverlay

	if buttonDescriptor.text.text ~= "" then
		buttonDescriptor.text.text = TruncateText(buttonDescriptor.text.text, buttonDescriptor.text.fontname, buttonDescriptor.text.fontsize, width - 2 * buttonDescriptor.text.x)
	end
	if buttonDescriptor.text2.text ~= "" then
		buttonDescriptor.text2.text = TruncateText(buttonDescriptor.text2.text, buttonDescriptor.text2.fontname, buttonDescriptor.text2.fontsize, width - 2 * buttonDescriptor.text2.x)
	end

	buttonDescriptor.active = active
	buttonDescriptor.offset = { x = offsetx, y = offsety }
	buttonDescriptor.size = { width = width, height = height }
	return CreateButton(buttonDescriptor)
end

-- shieldhullbar
function widgetPrototypes.cell:createShieldHullBar(shield, hull, properties)
	if initTableCell(self, "shieldhullbar", properties) then
		self.properties.shield = shield
		self.properties.hull = hull
	end
	return self
end

function widgetPrototypes.cell:createObjectShieldHullBar(object, properties)
	local object64 = ConvertStringTo64Bit(tostring(object))
	local shield = function() return IsComponentOperational(object64) and GetComponentData(object64, "shieldpercent") or 0 end
	local hull = function() return IsComponentOperational(object64) and GetComponentData(object64, "hullpercent") or 0 end
	local mouseovertext = function (cell, basetext)
			if type(basetext) == "function" then
				basetext = basetext(cell)
			end
			local shieldvalue = shield()
			return (basetext and (basetext .. "\n") or "") .. ((shieldvalue > 0) and (ReadText(1001, 2) .. ReadText(1001, 120) .. " " .. shieldvalue .. "%\n") or "") .. ReadText(1001, 1) .. ReadText(1001, 120) .. " " .. hull() .. "%"
		end
	if properties then
		if properties.mouseOverText then
			properties.mouseOverText = function (cell) return mouseovertext(cell, properties.mouseOverText) end
		else
			properties.mouseOverText = mouseovertext
		end
	else
		properties = { mouseOverText = mouseovertext }
	end
	return self:createShieldHullBar(shield, hull, properties)
end

function widgetHelpers.shieldhullbar:createDescriptor()
	local shield = self.properties.shield
	local hull = self.properties.hull
	local glowfactor = self.properties.glowfactor
	local mouseovertext = self.properties.mouseOverText

	local isfunctioncell = false
	if type(shield) == "function" then
		shield = shield()
		isfunctioncell = true
	end
	if type(hull) == "function" then
		hull = hull()
		isfunctioncell = true
	end
	if type(glowfactor) == "function" then
		glowfactor = glowfactor(self)
		isfunctioncell = true
	end
	if type(mouseovertext) == "function" then
		mouseovertext = mouseovertext(self)
		isfunctioncell = true
	end
	if isfunctioncell then
		table.insert(self.row.table.frame.functionCells, self)
	end

	local scaling = self.properties.scaling
	local offsetx = Helper.scaleX(self.properties.x, scaling)
	local offsety = rawget(self.properties, "y")
	if not offsety then
		offsety = self.row:getHeight() / 2
	else
		offsety = Helper.scaleY(self.properties.y, scaling)
	end

	local width = self:getWidth()
	local height = self:getHeight()

	local shieldHullBarDescriptor = {}
	shieldHullBarDescriptor.shield = shield
	shieldHullBarDescriptor.hull = hull
	shieldHullBarDescriptor.glowfactor = glowfactor
	shieldHullBarDescriptor.mouseovertext = mouseovertext
	shieldHullBarDescriptor.offset = { x = offsetx, y = offsety }
	shieldHullBarDescriptor.size = { width = width, height = height }
	return CreateShieldHullBar(shieldHullBarDescriptor)
end

-- editbox
function widgetPrototypes.cell:createEditBox(properties)
	-- Complex properties: text, hotkey
	initTableCell(self, "editbox", properties)
	return self
end

function widgetPrototypes.editbox:setText(text, properties)
	self.properties.text.text = text
	self.properties.text.scaling = self.properties.scaling
	self.properties.text:apply(properties)
	return self
end

function widgetPrototypes.editbox:setHotkey(hotkey, properties)
	self.properties.hotkey.hotkey = hotkey
	self.properties.hotkey:apply(properties)
	return self
end

function widgetPrototypes.editbox:getHeight()
	-- super call
	local height = widgetPrototypes.cell.getHeight(self)
	-- enforce min height if the editbox contains a hotkey icon
	local hotkeyproperty = self.properties.hotkey
	if hotkeyproperty.hotkey ~= "" and hotkeyproperty.displayIcon and height < Helper.editboxMinHeight then
		return Helper.editboxMinHeight
	end
	return height
end

function widgetHelpers.editbox:createDescriptor()
	local bgColor = self.properties.bgColor
	local scaling = self.properties.scaling
	local offsetx = Helper.scaleX(self.properties.x, scaling)
	local offsety = Helper.scaleY(self.properties.y, scaling)
	local width = self:getWidth()
	local height = self:getHeight()
	local mouseovertext = self.properties.mouseOverText
	local closeMenuOnBack = self.properties.closeMenuOnBack
	local defaultText = self.properties.defaultText
	local description = self.properties.description
	local textHidden = self.properties.textHidden
	local encrypted = self.properties.encrypted
	local helpoverlay = createOverlayPropertyInfo(self)
	local selectTextOnActivation = self.properties.selectTextOnActivation
	local active = self.properties.active
	local restoreInteractiveObject = self.properties.restoreInteractiveObject
	local maxchars = self.properties.maxChars

	local isfunctioncell = false
	if type(active) == "function" then
		active = active()
		isfunctioncell = true
	end
	if type(textHidden) == "function" then
		textHidden = textHidden()
		isfunctioncell = true
	end
	if type(mouseovertext) == "function" then
		mouseovertext = mouseovertext(self)
		isfunctioncell = true
	end
	if isfunctioncell then
		table.insert(self.row.table.frame.functionCells, self)
	end
	
	local editboxDescriptor = {}
	editboxDescriptor.text = createTextPropertyInfo(self, self.properties.text)
	editboxDescriptor.defaulttext = defaultText
	editboxDescriptor.description = description
	editboxDescriptor.hotkey = createHotkeyPropertyInfo(self, self.properties.hotkey, width, height, scaling)
	editboxDescriptor.mouseovertext = mouseovertext
	editboxDescriptor.color = bgColor
	editboxDescriptor.glowfactor = bgColor.glow
	
	editboxDescriptor.closemenu = closeMenuOnBack
	editboxDescriptor.texthidden = textHidden
	editboxDescriptor.encrypted = encrypted
	editboxDescriptor.selectonactivation = selectTextOnActivation
	editboxDescriptor.active = active
	editboxDescriptor.restoreInteractiveObject = restoreInteractiveObject
	editboxDescriptor.offset = { x = offsetx, y = offsety }
	editboxDescriptor.size = { width = width, height = height }
	editboxDescriptor.helpoverlay = helpoverlay
	editboxDescriptor.maxchars = maxchars
	return CreateEditBox(editboxDescriptor)
end

-- slidercell
function widgetPrototypes.cell:createSliderCell(properties)
	initTableCell(self, "slidercell", properties)
	return self
end

function widgetPrototypes.slidercell:setText(text, properties)
	self.properties.text.text = text
	self.properties.text.scaling = self.properties.scaling
	self.properties.text:apply(properties)
	return self
end

function widgetPrototypes.slidercell:updateMaxSelectValue(value)
	if self.id then
		self.properties.max = value
		C.SetSliderCellMaxSelectValue(self.id, value)
	end
end

function widgetPrototypes.slidercell:updateMaxValue(value)
	if self.id then
		self.properties.max = value
		C.SetSliderCellMaxValue(self.id, value)
	end
end

function widgetPrototypes.slidercell:updateMinSelectValue(value)
	if self.id then
		self.properties.min = value
		C.SetSliderCellMinSelectValue(self.id, value)
	end
end

function widgetPrototypes.slidercell:updateMinValue(value)
	if self.id then
		self.properties.min = value
		C.SetSliderCellMinValue(self.id, value)
	end
end

function widgetPrototypes.slidercell:getHeight()
	-- super call
	local height = widgetPrototypes.cell.getHeight(self)
	if height < Helper.slidercellMinHeight then
		return Helper.slidercellMinHeight
	end
	return height
end

function widgetHelpers.slidercell:createDescriptor()
	local scaling = self.properties.scaling
	local bgColor = self.properties.bgColor
	local inactiveBGColor = self.properties.inactiveBGColor
	local valueColor = self.properties.valueColor
	local posValueColor = self.properties.posValueColor
	local negValueColor = self.properties.negValueColor
	local offsetx = Helper.scaleX(self.properties.x, scaling)
	local offsety = Helper.scaleY(self.properties.y, scaling)
	local width = self:getWidth()
	local height = self:getHeight()
	local helpoverlay = createOverlayPropertyInfo(self)

	local isfunctioncell = false
	local mouseovertext = self.properties.mouseOverText
	if type(mouseovertext) == "function" then
		mouseovertext = mouseovertext(self)
		isfunctioncell = true
	end
	if isfunctioncell then
		table.insert(self.row.table.frame.functionCells, self)
	end

	local slidercellDescriptor = {}
	slidercellDescriptor.text = createTextPropertyInfo(self, self.properties.text)
	slidercellDescriptor.scale = {
		min = self.properties.min,
		minselect = self.properties.minSelect,
		max = self.properties.max,
		maxselect = self.properties.maxSelect,
		start = self.properties.start,
		step = self.properties.step,
		accuracyoverride = self.properties.accuracyOverride,
		suffix = self.properties.suffix,
		exceedmax = self.properties.exceedMaxValue,
		hidemaxvalue = self.properties.hideMaxValue,
		righttoleft = self.properties.rightToLeft,
		fromcenter = self.properties.fromCenter,
		readonly = self.properties.readOnly,
		forcearrows = self.properties.forceArrows,
		useinfinitevalue = self.properties.useInfiniteValue,
		infinitevalue = self.properties.infiniteValue,
		usetimeformat = self.properties.useTimeFormat,
	}
	if slidercellDescriptor.scale.minselect == propertyDefaultValue then
		slidercellDescriptor.scale.minselect = slidercellDescriptor.scale.min
	end
	if slidercellDescriptor.scale.maxselect == propertyDefaultValue then
		slidercellDescriptor.scale.maxselect = slidercellDescriptor.scale.max
	end
	if slidercellDescriptor.scale.accuracyoverride == propertyDefaultValue then
		slidercellDescriptor.scale.accuracyoverride = nil
	end

	slidercellDescriptor.mouseovertext = mouseovertext
	slidercellDescriptor.bgcolor = bgColor
	slidercellDescriptor.inactivebgcolor = inactiveBGColor
	if slidercellDescriptor.scale.fromcenter then
		slidercellDescriptor.valuecolor = posValueColor
		slidercellDescriptor.valueglowfactor = posValueColor.glow
		slidercellDescriptor.negativevaluecolor = negValueColor
		slidercellDescriptor.negativevalueglowfactor = negValueColor.glow
	else
		slidercellDescriptor.valuecolor = valueColor
		slidercellDescriptor.valueglowfactor = valueColor.glow
	end

	slidercellDescriptor.offset = {x = offsetx, y = offsety}
	slidercellDescriptor.size = {width = width , height = height}
	slidercellDescriptor.helpoverlay = helpoverlay
	return CreateSliderCell(slidercellDescriptor)
end

-- dropdown
function widgetPrototypes.cell:createDropDown(options, properties)
	if initTableCell(self, "dropdown", properties) then
		self.properties.options = options
	end
	return self
end

function widgetPrototypes.dropdown:setTextProperties(properties)
	self.properties.text.scaling = self.properties.scaling
	self.properties.text:apply(properties)
	return self
end

function widgetPrototypes.dropdown:setText2Properties(properties)
	self.properties.text2.scaling = self.properties.scaling
	self.properties.text2:apply(properties)
	return self
end

function widgetPrototypes.dropdown:setIconProperties(properties)
	self.properties.icon.scaling = self.properties.scaling
	-- dropdown icons are defined per option, set a dummy icon for the global properties
	self.properties.icon.icon = "solid"
	self.properties.icon:apply(properties)
	return self
end

function widgetPrototypes.dropdown:setHotkey(hotkey, properties)
	self.properties.hotkey.hotkey = hotkey
	self.properties.hotkey:apply(properties)
	return self
end

function widgetHelpers.dropdown:createDescriptor()
	local scaling = self.properties.scaling
	local bgColor = self.properties.bgColor
	local highlightColor = self.properties.highlightColor
	local optionColor = self.properties.optionColor
	local offsetx = Helper.scaleX(self.properties.x, scaling)
	local offsety = Helper.scaleY(self.properties.y, scaling)
	local width = self:getWidth()
	local height = self:getHeight()
	local mouseovertext = self.properties.mouseOverText
	local startOption = self.properties.startOption
	local helpoverlay = createOverlayPropertyInfo(self)
	local options = Helper.tableCopy(self.properties.options, 1)
	for _, option in ipairs(options) do
		if option.helpOverlayID then
			option.helpoverlay =  {
				text = option.helpOverlayText,
				id = option.helpOverlayID,
				size = { width = option.helpOverlayWidth, height = option.helpOverlayHeight },
				offset = { x = option.helpOverlayX, y = option.helpOverlayY },
				highlightOnly = optionhelpOverlayHighlightOnly
			}
		end
	end

	local isfunctioncell = false
	if type(startOption) == "function" then
		startOption = startOption()
		isfunctioncell = true
	end
	if type(mouseovertext) == "function" then
		mouseovertext = mouseovertext(self)
		isfunctioncell = true
	end
	if not isfunctioncell then
		for _, option in ipairs(options) do
			if type(option.text) == "function" then
				option.text = option.text(self)
				isfunctioncell = true
			end
			if type(option.text2) == "function" then
				option.text2 = option.text2(self)
				isfunctioncell = true
			end
		end
	end
	if isfunctioncell then
		table.insert(self.row.table.frame.functionCells, self)
	end

	local dropdownDescriptor = {}
	dropdownDescriptor.options = options
	dropdownDescriptor.startoption = startOption
	dropdownDescriptor.text = createTextPropertyInfo(self, self.properties.text)
	dropdownDescriptor.textoverride = self.properties.textOverride
	dropdownDescriptor.text2 = createTextPropertyInfo(self, self.properties.text2)
	dropdownDescriptor.text2override = self.properties.text2Override
	dropdownDescriptor.icon = createIconPropertyInfo(self, self.properties.icon)
	dropdownDescriptor.hotkey = createHotkeyPropertyInfo(self, self.properties.hotkey, width, height, scaling)

	dropdownDescriptor.mouseovertext = mouseovertext
	dropdownDescriptor.color = bgColor
	dropdownDescriptor.glowfactor = bgColor.glow
	dropdownDescriptor.highlightcolor = highlightColor
	dropdownDescriptor.highlightglowfactor = highlightColor.glow
	dropdownDescriptor.optioncolor = optionColor
	dropdownDescriptor.optionglowfactor = optionColor.glow
	dropdownDescriptor.active = self.properties.active
	dropdownDescriptor.allowmouseoverinteraction = self.properties.allowMouseOverInteraction
	dropdownDescriptor.helpoverlay = helpoverlay

	dropdownDescriptor.offset = {x = offsetx, y = offsety}
	dropdownDescriptor.size = {width = width , height = height}
	dropdownDescriptor.optionwidth = self.properties.optionWidth
	dropdownDescriptor.optionheight = self.properties.optionHeight

	return CreateDropDown(dropdownDescriptor)
end

-- checkbox
function widgetPrototypes.cell:createCheckBox(checked, properties)
	if initTableCell(self, "checkbox", properties) then
		self.properties.checked = checked
	end
	return self
end

function widgetHelpers.checkbox:createDescriptor()
	local scaling = self.properties.scaling
	local bgColor = self.properties.bgColor
	local offsetx = Helper.scaleX(self.properties.x, scaling)
	local offsety = Helper.scaleY(self.properties.y, scaling)
	local width = self:getWidth()
	local height = self:getHeight()
	local mouseovertext = self.properties.mouseOverText
	local checked = self.properties.checked
	local glowfactor = self.properties.glowfactor
	local helpoverlay = createOverlayPropertyInfo(self)

	local isfunctioncell = false
	if type(checked) == "function" then
		checked = checked()
		isfunctioncell = true
	end
	if type(bgColor) == "function" then
		bgColor = bgColor()
		isfunctioncell = true
	end
	if type(mouseovertext) == "function" then
		mouseovertext = mouseovertext(self)
		isfunctioncell = true
	end
	if type(glowfactor) == "function" then
		glowfactor = glowfactor(self)
		isfunctioncell = true
	end
	if isfunctioncell then
		table.insert(self.row.table.frame.functionCells, self)
	end

	local checkboxDescriptor = {}
	checkboxDescriptor.mouseovertext = mouseovertext
	checkboxDescriptor.color = bgColor
	checkboxDescriptor.active = self.properties.active
	checkboxDescriptor.checked = checked
	checkboxDescriptor.symbol = self.properties.symbol
	checkboxDescriptor.glowfactor = bgColor.glow
	checkboxDescriptor.symbolglowfactor = glowfactor
	checkboxDescriptor.helpoverlay = helpoverlay

	checkboxDescriptor.offset = { x = offsetx, y = offsety }
	checkboxDescriptor.size = { width = width , height = height }

	return CreateCheckBox(checkboxDescriptor)
end

-- statusbar
function widgetPrototypes.cell:createStatusBar(properties)
	initTableCell(self, "statusbar", properties)
	return self
end

function widgetHelpers.statusbar:createDescriptor()
	local current = self.properties.current
	local start = self.properties.start
	local max = self.properties.max
	local valueColor = self.properties.valueColor
	local posChangeColor = self.properties.posChangeColor
	local negChangeColor = self.properties.negChangeColor
	local markerColor = self.properties.markerColor
	local mouseovertext = self.properties.mouseOverText

	local titleColor = self.properties.titleColor
	if titleColor == propertyDefaultValue then
		titleColor = nil
	end

	local isfunctioncell = false
	if type(current) == "function" then
		current = current()
		isfunctioncell = true
	end
	if type(start) == "function" then
		start = start()
		isfunctioncell = true
	end
	if type(max) == "function" then
		max = max()
		isfunctioncell = true
	end
	if type(mouseovertext) == "function" then
		mouseovertext = mouseovertext(self)
		isfunctioncell = true
	end
	if isfunctioncell then
		table.insert(self.row.table.frame.functionCells, self)
	end

	local scaling = self.properties.scaling
	local offsetx = Helper.scaleX(self.properties.x, scaling)
	local offsety = Helper.scaleY(self.properties.y, scaling)
	local width = self:getWidth()
	local height = self:getHeight()

	local statusBarDescriptor = {}
	if current < 0 then
		print("statusbar:createDescriptor(): Statusbar in row " .. self.row.index .. ", col " .. self.index .. " has a negative current value. Check what is causing this.")
	end
	statusBarDescriptor.current = math.max(0, current)
	if start < 0 then
		print("statusbar:createDescriptor(): Statusbar in row " .. self.row.index .. ", col " .. self.index .. " has a negative start value. Check what is causing this.")
	end
	statusBarDescriptor.start = math.max(0, start)
	if max < 0 then
		print("statusbar:createDescriptor(): Statusbar in row " .. self.row.index .. ", col " .. self.index .. " has a negative max value. Check what is causing this.")
	end
	statusBarDescriptor.max = math.max(0, max)
	statusBarDescriptor.valueColor = valueColor
	statusBarDescriptor.valueGlowFactor = valueColor.glow
	statusBarDescriptor.posChangeColor = posChangeColor
	statusBarDescriptor.posChangeGlowFactor = posChangeColor.glow
	statusBarDescriptor.negChangeColor = negChangeColor
	statusBarDescriptor.negChangeGlowFactor = negChangeColor.glow
	statusBarDescriptor.markerColor = markerColor
	statusBarDescriptor.markerGlowFactor = markerColor.glow
	statusBarDescriptor.titleColor = titleColor
	statusBarDescriptor.titleGlowFactor = titleColor and titleColor.glow or 0
	statusBarDescriptor.mouseovertext = mouseovertext
	statusBarDescriptor.offset = { x = offsetx, y = offsety }
	statusBarDescriptor.size = { width = width , height = height }
	return CreateStatusBar(statusBarDescriptor)
end

-- graph
function widgetPrototypes.cell:createGraph(properties)
	initTableCell(self, "graph", properties)
	self.selected = {}
	self.datarecords = {}
	self.defaultDataRecordProperties = {}
	return self
end

function widgetPrototypes.graph:setDefaultDataRecordProperties(properties)
	if not self.defaultDataRecordProperties then
		self.defaultDataRecordProperties = { }
		setmetatable(self.defaultDataRecordProperties, widgetPropertyMetatables.graphdatarecord)
	end
	self.defaultDataRecordProperties:apply(properties)
	return self
end

function widgetPrototypes.graph:setTitle(title, properties)
	self.properties.title.text = title
	self.properties.title.scaling = self.properties.scaling
	self.properties.title:apply(properties)
	return self
end

function widgetPrototypes.graph:setXAxis(properties)
	self.properties.xAxis:apply(properties)
	return self
end

function widgetPrototypes.graph:setXAxisLabel(label, properties)
	self.properties.xAxisLabel.text = label
	self.properties.xAxisLabel.scaling = self.properties.scaling
	self.properties.xAxisLabel:apply(properties)
	return self
end

function widgetPrototypes.graph:setYAxis(properties)
	self.properties.yAxis:apply(properties)
	return self
end

function widgetPrototypes.graph:setYAxisLabel(label, properties)
	self.properties.yAxisLabel.text = label
	self.properties.yAxisLabel.scaling = self.properties.scaling
	self.properties.yAxisLabel:apply(properties)
	return self
end

function widgetPrototypes.graph:addDataRecord(properties)
	local datarecord = {
		graph = self,
		data = {},
		properties = {},					-- datarecord properties
	}
	table.insert(self.datarecords, datarecord)

	-- set metatables to enable member functions and default properties
	setmetatable(datarecord, widgetMetatables.graphdatarecord)
	setmetatable(datarecord.properties, widgetPropertyMetatables.graphdatarecord)

	-- apply default node properties
	if self.defaultDataRecordProperties then
		datarecord.properties:apply(self.defaultDataRecordProperties)
	end
	-- apply custom properties
	datarecord.properties:apply(properties)
	return datarecord
end

function widgetPrototypes.graphdatarecord:addData(x, y, icon, mouseovertext, inactive)
	table.insert(self.data, { x = x, y = y, icon = icon, mouseovertext = mouseovertext, inactive = inactive })
	return self
end

function widgetHelpers.graph:createDescriptor()
	local graphDescriptor = {}
	graphDescriptor.type = self.properties.graphtype
	graphDescriptor.bgcolor = self.properties.bgColor
	graphDescriptor.title = createTextPropertyInfo(self, self.properties.title)
	graphDescriptor.xAxis = createAxisPropertyInfo(self.properties.xAxis)
	graphDescriptor.xAxisLabel = createTextPropertyInfo(self, self.properties.xAxisLabel)
	graphDescriptor.yAxis = createAxisPropertyInfo(self.properties.yAxis)
	graphDescriptor.yAxisLabel = createTextPropertyInfo(self, self.properties.yAxisLabel)
	graphDescriptor.offset = { x = self.properties.x or 0, y = self.properties.y or 0 }
	graphDescriptor.size = { width = self.properties.width or 0, height = self.properties.height or 0 }
	graphDescriptor.mouseovertext = self.properties.mouseOverText
	graphDescriptor.helpoverlay = createOverlayPropertyInfo(self)

	graphDescriptor.datarecords = {}
	graphDescriptor.icons = {}
	for datarecordidx, datarecord in ipairs(self.datarecords) do
		local marker
		if datarecord.properties.markertype then
			marker = { type = datarecord.properties.markertype, size = datarecord.properties.markersize, color = datarecord.properties.markercolor, glowfactor = datarecord.properties.markercolor.glow }
		end

		local line
		if datarecord.properties.linetype then
			line = { type = datarecord.properties.linetype, width = datarecord.properties.linewidth, color = datarecord.properties.linecolor, glowfactor = datarecord.properties.linecolor.glow }
		end

		local desc_record = {
			marker = marker,
			line = line,
			data = {},
			highlighted = datarecord.properties.highlighted,
			mouseovertext = datarecord.properties.mouseOverText
		}

		for dataidx, datapoint in ipairs(datarecord.data) do
			table.insert(desc_record.data, datapoint)
			if datapoint.icon then
				table.insert(graphDescriptor.icons, { datarecord = datarecordidx, data = dataidx, icon = datapoint.icon, mouseovertext = datapoint.mouseovertext })
				desc_record.data[dataidx].icon = nil
				desc_record.data[dataidx].mouseovertext = nil
			end
		end
		table.insert(graphDescriptor.datarecords, desc_record)
	end

	if self.properties.scaling then
		graphDescriptor.offset.x		= Helper.scaleX(graphDescriptor.offset.x)
		graphDescriptor.offset.y		= Helper.scaleY(graphDescriptor.offset.y)
		graphDescriptor.size.width		= Helper.scaleX(graphDescriptor.size.width)
		graphDescriptor.size.height		= Helper.scaleY(graphDescriptor.size.height)

		for _, datarecord in ipairs(graphDescriptor.datarecords) do
			if datarecord.marker then
				datarecord.marker.size = Helper.scaleX(datarecord.marker.size)
			end
			if datarecord.line then
				datarecord.line.width = math.floor(Helper.scaleY(datarecord.line.width) / 2) * 2
			end
		end
	end

	return CreateGraph(graphDescriptor)
end

function widgetPrototypes.graph:selectDataPoint(recordIdx, dataIdx, selected)
	if self.id then
		if (recordIdx ~= self.selected.recordIdx) or (dataIdx ~= self.selected.dataIdx) then
			self.selected = { recordIdx = recordIdx, dataIdx = dataIdx }
			SelectGraphDataPoint(self.id, recordIdx, dataIdx, selected)
		end
	end
end

---------- Flowchart member functions ----------

function widgetPrototypes.flowchart:setDefaultNodeProperties(properties)
	if not self.defaultNodeProperties then
		self.defaultNodeProperties = { }
		setmetatable(self.defaultNodeProperties, widgetPropertyMetatables.flowchartnode)
	end
	self.defaultNodeProperties:apply(properties)
	return self
end

function widgetPrototypes.flowchart:setDefaultEdgeProperties(properties)
	if not self.defaultEdgeProperties then
		self.defaultEdgeProperties = { }
		setmetatable(self.defaultEdgeProperties, widgetPropertyMetatables.flowchartedge)
	end
	self.defaultEdgeProperties:apply(properties)
	return self
end

function widgetPrototypes.flowchart:setDefaultTextProperties(properties)
	if not self.defaultTextProperties then
		self.defaultTextProperties = { }
		setmetatable(self.defaultTextProperties, widgetPropertyMetatables.textproperty)
	end
	self.defaultTextProperties:apply(properties)
	return self
end

function widgetPrototypes.flowchart:setDefaultIconProperties(properties)
	if not self.defaultIconProperties then
		self.defaultIconProperties = { }
		setmetatable(defaultIconProperties, widgetPropertyMetatables.iconproperty)
	end
	self.defaultIconProperties:apply(properties)
	return self
end

function widgetPrototypes.flowchart:setColWidthMin(col, minwidth, extensionweight, scaling)
	-- In contrast to tables, we don't have to finalize column widths in the flowchart before content is added.
	-- Eventually the column width will be determined by the widest node in the column, and possibly by the visible flowchart width.
	-- Since we can scroll horizontally, there are less restrictions than in a table widget.
	local coldata = self.columndata[col]
	if not coldata then
		DebugError(string.format("flowchart:setColWidthMin(): Column %s does not exist", col))
	else
		coldata.minwidth = minwidth
		coldata.weight = extensionweight or 1
		coldata.scaling = scaling
	end
	return self
end

function widgetPrototypes.flowchart:setColBackgroundColor(col, bgcolor)
	local coldata = self.columndata[col]
	if not coldata then
		DebugError(string.format("flowchart:setColBackgroundColor(): Column %s does not exist", col))
	else
		coldata.bgcolor = bgcolor
	end
	return self
end

-- height functions
function widgetPrototypes.flowchart:getRowHeight(row)
	local rowcells = self.rows[row]
	if not rowcells then
		DebugError(string.format("flowchart:getRowHeight(): Row %s does not exist", row))
		return 0
	end
	local height = Helper.scaleY(self.properties.minRowHeight, self.properties.scaling)
	for _, cell in ipairs(rowcells) do
		if cell then
			height = math.max(height, cell:getCellMinHeight())
		end
	end
	return height
end

function widgetPrototypes.flowchart:getCaptionHeight(col)
	local coldata = self.columndata[col]
	if not coldata then
		DebugError(string.format("flowchart:getCaptionHeight(): Column %s does not exist", col))
		return 0
	end
	if coldata.caption then
		local fontsize = Helper.scaleFont(coldata.caption.fontname, coldata.caption.fontsize, self.properties.scaling)
		return math.ceil(C.GetTextHeight(tostring(coldata.caption.text), coldata.caption.fontname, math.floor(fontsize), 0))
	end
	return 0
end

function widgetPrototypes.flowchart:getFullHeight()
	local fullwidth, fullheight, hasverticalscrollbar, hashorizontalscrollbar = widgetHelpers.flowchart.getFullSizeAndScrollBarData(self)
	return fullheight
end

function widgetPrototypes.flowchart:getMaxVisibleHeight()
	local maxheight = self.properties.maxVisibleHeight
	local availableheight = self.frame:getAvailableHeight() - self.properties.y
	if maxheight > 0 and maxheight < availableheight then
		return maxheight
	end
	return availableheight
end

function widgetPrototypes.flowchart:getVisibleHeight()
	local height = self:getFullHeight()
	local maxheight = self:getMaxVisibleHeight()
	if maxheight > 0 and height > maxheight then
		-- Not all rows will be visible, we'll get a scrollbar
		return maxheight
	end
	return height
end

function widgetPrototypes.flowchart:hasScrollBar()
	local fullwidth, fullheight, hasverticalscrollbar, hashorizontalscrollbar = widgetHelpers.flowchart.getFullSizeAndScrollBarData(self)
	return hasverticalscrollbar
end

-- width functions
function widgetPrototypes.flowchart:getColMinWidth(col)
	local coldata = self.columndata[col]
	if not coldata then
		DebugError(string.format("flowchart:getColMinWidth(): Column %s does not exist", col))
		return 0
	end
	local scaling = coldata.scaling or (self.properties.scaling and coldata.scaling == nil)	-- coldata.scaling takes precedence if non-nil
	local minwidth = Helper.scaleX(coldata.minwidth >= 0 and coldata.minwidth or self.properties.minColWidth, scaling)
	for row = 1, self.numrows do
		local cell = self.rows[row][col]
		if cell then
			minwidth = math.max(minwidth, cell:getCellMinWidth())
		end
	end
	-- note: actual width can be larger because columns can be stretched, in case minFullWidth is lower than visible width
	return math.ceil(minwidth)
end

function widgetPrototypes.flowchart:getMinFullWidth()
	local fullwidth, fullheight, hasverticalscrollbar, hashorizontalscrollbar = widgetHelpers.flowchart.getFullSizeAndScrollBarData(self)
	return fullwidth
end

function widgetPrototypes.flowchart:getVisibleWidth()
	local visiblewidth = math.floor(self.properties.width)
	local availablewidth = math.floor(self.frame.properties.width) - math.ceil(self.properties.x)
	if visiblewidth > 0 and visiblewidth < availablewidth then
		return visiblewidth
	end
	return availablewidth
end

function widgetPrototypes.flowchart:hasHorizontalScrollBar()
	local fullwidth, fullheight, hasverticalscrollbar, hashorizontalscrollbar = widgetHelpers.flowchart.getFullSizeAndScrollBarData(self)
	return hashorizontalscrollbar
end

function widgetHelpers.flowchart:getFullSizeAndScrollBarData()
	-- determine full (minimal) width and height and whether scrollbars exist, also include scrollbar size in width/height
	local fullheight = 2 * (Helper.scaleY(self.properties.borderHeight, self.properties.scaling) + Helper.borderSize)
	local maxCaptionHeight = 0
	for col = 1, self.numcolumns do
		maxCaptionHeight = math.max(maxCaptionHeight, self:getCaptionHeight(col))
	end
	fullheight = fullheight + maxCaptionHeight
	for row = 1, self.numrows do
		fullheight = fullheight + self:getRowHeight(row)
	end
	local fullwidth = 0
	for col, coldata in ipairs(self.columndata) do
		fullwidth = fullwidth + self:getColMinWidth(col)
	end
	local maxvisibleheight = self:getMaxVisibleHeight()
	local maxvisiblewidth = self:getVisibleWidth()
	local hashorizontalscrollbar = false
	local hasverticalscrollbar = false
	-- use same scrollbar logic as in flowchart widget implementation
	if fullheight > maxvisibleheight then
		-- take width of vertical scrollbar into account - this could make a horizontal scrollbar required
		hasverticalscrollbar = true
		fullwidth = fullwidth + Helper.scrollbarWidth
	end
	if fullwidth > maxvisiblewidth then
		-- take height of horizontal scrollbar into account - this could make a vertical scrollbar required, if not required already
		hashorizontalscrollbar = true
		fullheight = fullheight + Helper.scrollbarWidth
		if (not hasverticalscrollbar) and fullheight > maxvisibleheight then
			-- horizontal scrollbar increases full height beyond visible height, so that we need a vertical scrollbar as well
			hasverticalscrollbar = true
			fullwidth = fullwidth + Helper.scrollbarWidth
		end
	end
	-- min flowchart height
	fullheight = math.max(fullheight, Helper.scaleY(self.properties.minRowHeight, self.properties.scaling) + 2 * Helper.scaleY(self.properties.borderHeight, self.properties.scaling))
	return fullwidth, fullheight, hasverticalscrollbar, hashorizontalscrollbar
end

-- content handling (celltype = "flowchartnode" or "flowchartjunction" or nil)
function widgetPrototypes.flowchart:getCell(row, col, celltype)
	local rowcells = self.rows[row]
	if rowcells and rowcells[col] and (not celltype or rowcells[col].type == celltype) then
		return rowcells[col]
	end
	return nil
end

function finalizeFlowchartCellSlots(cell, slottype, edges, colorprop, rankprop, slotfield)
	-- assign slots to connected edges, and slot colors to the used slots.
	-- for input slots: slottype = "input", colorprop = "destSlotColor", rankprop = "destSlotRank", slotfield = "destslot"
	-- for output slots: slottype = "output", colorprop = "sourceSlotColor", rankprop = "sourceSlotRank", slotfield = "sourceslot"
	local rankcolors = { }
	local flowchartCellError = false
	if #edges == 0 then
		return 0
	end
	-- table for identifying duplicate edges, only used with slottype "output" (look for edges with identical destcell/sourceSlotRank/destSlotRank)
	local connectedcellsbyslotranks = { }
	for _, edge in ipairs(edges) do
		-- determine unique color per slot rank and identify collisions (multiple edges with same rank, but different colors)
		local color = edge.properties[colorprop]
		local rank = edge.properties[rankprop]
		local prevcolor = rankcolors[rank]
		if not flowchartCellError and color and prevcolor then
			if color.r ~= prevcolor.r or color.g ~= prevcolor.g or color.b ~= prevcolor.b or color.a ~= prevcolor.a then
				DebugError(string.format("flowchart slot finalization (row %d, column %d): There are multiple connected %s edges using the same slot rank %d with different colors",
					cell.row, cell.col, (slottype == "input" and "incoming" or "outgoing"), rank))
				flowchartCellError = true
			end
		end
		-- set color or false, but not nil
		rankcolors[rank] = prevcolor or color or false
		-- identify and mark duplicates
		if slottype == "output" then
			local rankcombination = edge.properties.sourceSlotRank * 10 + edge.properties.destSlotRank
			local connectedcells = connectedcellsbyslotranks[rankcombination]
			if not connectedcells then
				connectedcells = { }
				connectedcellsbyslotranks[rankcombination] = connectedcells
			end
			if connectedcells[edge.destcell] then
				edge.duplicate = true
			else
				connectedcells[edge.destcell] = edge
			end
		end
	end
	local usedranks = { }						-- sequence of used ranks
	local rankslotassignment = { }				-- rankslotassignment[rank] = slot
	for rank = 1, 3 do
		if rankcolors[rank] ~= nil then
			table.insert(usedranks, rank)
		end
	end
	if #usedranks == 0 then
		-- This would mean that rank was not a number from 1 to 3
		DebugError(string.format("flowchart slot finalization (row %d, column %d): Connected edges have invalid slot ranks", cell.row, cell.col))
	elseif cell.type == "flowchartjunction" then
		-- junction
		if #usedranks > 1 then
			DebugError(string.format("flowchart slot finalization (row %d, column %d): There are edges connected to multiple slots on a junction, only one slot is supported", cell.row, cell.col))
		end
		-- Use slot 2
		rankslotassignment[usedranks[1]] = 2
		-- validate and set junction color
		local color = rankcolors[usedranks[1]] or Color["flowchart_junction_default"]
		local prevcolor = cell.junctionColor
		if color and prevcolor then
			if color.r ~= prevcolor.r or color.g ~= prevcolor.g or color.b ~= prevcolor.b or color.a ~= prevcolor.a then
				DebugError(string.format("flowchart slot finalization (row %d, column %d): Junction has different input and output colors", cell.row, cell.col))
			end
		end
		cell.junctionColor = prevcolor or color
	else
		if #usedranks == 1 then
			-- node with one slot: Use slot 2
			rankslotassignment[usedranks[1]] = 2
		elseif #usedranks == 2 then
			-- node with two slots: Use slots 1 and 3
			rankslotassignment[usedranks[1]] = 1
			rankslotassignment[usedranks[2]] = 3
		elseif #usedranks == 3 then
			-- node with three slots: Use all slots
			rankslotassignment[usedranks[1]] = 1
			rankslotassignment[usedranks[2]] = 2
			rankslotassignment[usedranks[3]] = 3
		end
		for rank, slot in pairs(rankslotassignment) do
			cell.slotcolors[slottype][slot] = rankcolors[rank] or Color["flowchart_slot_default"]
		end
	end
	-- Store assigned slot also in edges
	for _, edge in ipairs(edges) do
		local rank = edge.properties[rankprop]
		edge[slotfield] = rankslotassignment[rank]
	end
end

-- Example usage:
--   local node = flowchart:addNode(1, 1, { custom = "foo", bar = "baz" }, { shape = "stadium", bgColor = Color["foo"] })
function widgetPrototypes.flowchart:addNode(row, col, customdata, properties)
	local rowcells = self.rows[row]
	if not rowcells then
		DebugError(string.format("flowchart:addNode(): Row %s does not exist", row))
		return nil
	end
	if rowcells[col] ~= false then
		if rowcells[col] then
			DebugError(string.format("flowchart:addNode(): Node or junction already exists in row %d, column %d", row, col))
		else
			DebugError(string.format("flowchart:addNode(): Column %s does not exist", col))
		end
		return nil
	end
	local node = {
		flowchart = self,
		row = row,							-- row index in flowchart
		col = col,							-- column index in flowchart
		customdata = customdata,			-- user-provided data
		type = "flowchartnode",				-- widget type
		descriptor = nil,					-- descriptor (used temporarily)
		id = nil,							-- widget ID, valid while displayed
		slotcolors = {						-- color tables of input/output slots (false if slot is not used)
			input = { false, false, false },	-- set in finalizeFlowchartCellSlots()
			output = { false, false, false }	-- set in finalizeFlowchartCellSlots()
		},
		incomingEdges = { },				-- flowchart edges whose destination is this cell
		outgoingEdges = { },				-- flowchart edges whose source is this cell
		properties = { },					-- node properties
		handlers = { }						-- event handlers
	}
	rowcells[col] = node

	-- set metatables to enable member functions and default properties
	setmetatable(node, widgetMetatables.flowchartnode)
	setmetatable(node.properties, widgetPropertyMetatables.flowchartnode)

	-- propagate scaling from flowchart to node
	if not self.properties.scaling then
		node.properties.scaling = false
	end
	-- create complex properties
	for complexprop, simpleprop in pairs(complexCellProperties.flowchartnode) do
		local complexproptable = { }
		setmetatable(complexproptable, widgetPropertyMetatables[simpleprop])
		rawset(node.properties, complexprop, complexproptable)
	end
	-- apply default node properties
	if self.defaultNodeProperties then
		node.properties:apply(self.defaultNodeProperties)
	end
	-- apply custom properties
	node.properties:apply(properties)
	return node
end

-- Example usage:
--   local node = flowchart:addJunction(1, 1)
function widgetPrototypes.flowchart:addJunction(row, col, properties)
	local rowcells = self.rows[row]
	if not rowcells then
		DebugError(string.format("flowchart:addJunction(): Row %s does not exist", row))
		return nil
	end
	if rowcells[col] ~= false then
		if rowcells[col] then
			DebugError(string.format("flowchart:addJunction(): Node or junction already exists in row %d, column %d", row, col))
		else
			DebugError(string.format("flowchart:addJunction(): Column %s does not exist", col))
		end
		return nil
	end
	local junction = {
		flowchart = self,
		row = row,							-- row index in flowchart
		col = col,							-- column index in flowchart
		type = "flowchartjunction",			-- widget type
		descriptor = nil,					-- descriptor (used temporarily)
		id = nil,							-- widget ID, valid while displayed
		incomingEdges = { },				-- flowchart edges whose destination is this cell
		outgoingEdges = { },				-- flowchart edges widgets whose source is this cell
		junctionColor = nil,				-- set in finalizeFlowchartCellSlots()
		properties = { }					-- junction properties
	}
	rowcells[col] = junction

	-- set metatables to enable member functions and default properties
	setmetatable(junction, widgetMetatables.flowchartjunction)
	setmetatable(junction.properties, widgetPropertyMetatables.flowchartjunction)

	-- propagate scaling from flowchart to junction
	if not self.properties.scaling then
		junction.properties.scaling = false
	end
	-- apply custom properties
	junction.properties:apply(properties)
	return junction
end

function widgetPrototypes.flowchart:setColumnCaption(col, text, properties)
	if (col <= 0) or (col > self.numcolumns) then
		DebugError(string.format("flowchart:setColumnCaption(): Col %s does not exist", col))
		return
	end

	if type(properties) ~= "table" then
		if properties ~= nil then
			DebugError(string.format("flowchart:setColumnCaption(): Invalid properties format", col))
		end
		properties = {}
	end

	self.columndata[col].caption = {
		text = text,
		fontname = properties.font or Helper.standardFont,
		fontsize = properties.fontsize or Helper.headerRow1FontSize,
		color = properties.color or Color["flowchart_column_caption_default"],
	}
end

function widgetHelpers.flowchart:createDescriptor()
	-- note: scaling is not applied to offset and size of the flowchart itself
	local offsetx = self.properties.x
	local offsety = self.properties.y
	local width = self:getVisibleWidth()
	local height = self:getVisibleHeight()
	local scaling = self.properties.scaling
	local taborder = self.properties.tabOrder
	local skiptabchange = self.properties.skipTabChange
	local defaultinteractiveobject = self.properties.defaultInteractiveObject
	local helpoverlay = createOverlayPropertyInfo(self)

	-- finalize junction offsets and node/junction slots
	for col, coldata in ipairs(self.columndata) do
		-- determine best x offset for junctions in each column
		local bestxoff = 0
		for row, cols in ipairs(self.rows) do
			local cell = cols[col]
			if cell then
				finalizeFlowchartCellSlots(cell, "input", cell.incomingEdges, "destSlotColor", "destSlotRank", "destslot")
				finalizeFlowchartCellSlots(cell, "output", cell.outgoingEdges, "sourceSlotColor", "sourceSlotRank", "sourceslot")
				if cell.type == "flowchartnode" then
					bestxoff = math.max(bestxoff, Helper.scaleX(cell.properties.width, cell.properties.scaling) / 2)
				elseif cell.properties.junctionXOff >= 0 then
					bestxoff = math.max(bestxoff, Helper.scaleX(cell.properties.junctionXOff, cell.properties.scaling))
				end
			end
		end
		coldata.junctionxoff = bestxoff
	end

	local flowchartDescriptor = { }
	flowchartDescriptor.taborder = taborder
	flowchartDescriptor.skiptabchange = skiptabchange
	flowchartDescriptor.offset = { x = offsetx, y = offsety }
	flowchartDescriptor.size = { width = width, height = height }
	flowchartDescriptor.border = { height = Helper.scaleY(self.properties.borderHeight, scaling), color = self.properties.borderColor }
	flowchartDescriptor.minrowheight = Helper.scaleY(self.properties.minRowHeight, scaling)
	flowchartDescriptor.edgewidth = math.max(1, Helper.scaleY(self.properties.edgeWidth))
	flowchartDescriptor.firstvisiblerow = self.properties.firstVisibleRow
	flowchartDescriptor.firstvisiblecol = self.properties.firstVisibleCol
	flowchartDescriptor.selectedrow = self.properties.selectedRow
	flowchartDescriptor.selectedcol = self.properties.selectedCol
	flowchartDescriptor.helpoverlay = helpoverlay
	-- columns
	flowchartDescriptor.columns = { }
	local totalwidth = 0
	local varcolumnweight = 0
	for col, coldata in ipairs(self.columndata) do
		local colminwidth = self:getColMinWidth(col)
		if coldata.caption then
			coldata.caption.fontsize = Helper.scaleFont(coldata.caption.fontname, coldata.caption.fontsize, scaling)
		end
		flowchartDescriptor.columns[col] = { minwidth = colminwidth, bgcolor = coldata.bgcolor, caption = coldata.caption }
		totalwidth = totalwidth + colminwidth
		varcolumnweight = varcolumnweight + coldata.weight
	end
	if totalwidth < width then
		-- Stretch columns to fit width
		--[[
		if varcolumnweight > 0 then
			for col, coldata in ipairs(self.columndata) do
				if coldata.weight > 0 then
					local desccoldata = flowchartDescriptor.columns[col]
					local addedwidth = math.ceil((width - totalwidth) * coldata.weight / varcolumnweight)
					desccoldata.minwidth = desccoldata.minwidth + addedwidth
					totalwidth = totalwidth + addedwidth
					varcolumnweight = varcolumnweight - coldata.weight
					if varcolumnweight <= 0 then break end
				end
			end
		else
			DebugError(string.format("flowchart:createDescriptor(): Total width %s of flowchart columns is less than flowchart width %s, but stretching columns is not allowed", totalwidth, width))
		end
		]]
	end
	-- content
	flowchartDescriptor.content = { }
	for row, cols in ipairs(self.rows) do
		local descriptorrow = { }
		for col, cell in ipairs(cols) do
			local desc = nil
			if cell then
				desc = widgetHelpers[cell.type].createDescriptor(cell)
				if cell.descriptor then
					ReleaseDescriptor(cell.descriptor)
				end
				cell.descriptor = desc
			end
			descriptorrow[col] = desc or false
		end
		flowchartDescriptor.content[row] = descriptorrow
	end
	-- edges
	flowchartDescriptor.edges = { }
	local lastduplicateidx = nil
	for edgeidx, edge in ipairs(self.edges) do
		local edgedesc
		-- if it's a duplicate, don't create descriptor, instead create linked list of duplicates for removal
		if edge.duplicate then
			DebugError(string.format("flowchart:createDescriptor(): Removing duplicate edge between (%d,%d) and (%d,%d)", edge.sourcecell.row, edge.sourcecell.col, edge.destcell.row, edge.destcell.col))
			edge.lastduplicateidx = lastduplicateidx
			lastduplicateidx = edgeidx
		else
			edgedesc = widgetHelpers.flowchartedge.createDescriptor(edge)
		end
		if edge.descriptor then
			ReleaseDescriptor(edge.descriptor)
		end
		edge.descriptor = edgedesc
		if edgedesc then
			table.insert(flowchartDescriptor.edges, edgedesc)
		end
	end
	-- clean up duplicates
	while lastduplicateidx do
		local duplicateidx = lastduplicateidx
		lastduplicateidx = self.edges[duplicateidx].lastduplicateidx
		table.remove(self.edges, duplicateidx)
	end
	return CreateFlowchart(flowchartDescriptor)
end

function widgetPrototypes.flowchart:collapseAllNodes()
	while next(self.expandedNodes) do
		next(self.expandedNodes):collapse()
	end
end

---------- Generic flowchart cell member functions ----------

-- Example usage:
--   local edge = flowchartcell:addEdgeTo(destcell, { color = Color["foo"] })
function widgetPrototypes.flowchartcell:addEdgeTo(destcell, properties)
	if not (destcell and destcell.flowchart and destcell.flowchart == self.flowchart and destcell.row and destcell.col) then
		DebugError(string.format("flowchartcell:addEdgeTo(): Invalid destination cell %s (source row %d, column %d)", tostring(destcell), self.row, self.col))
		return nil
	end
	if destcell == self then
		DebugError(string.format("flowchartcell:addEdgeTo(): Source and destination are identical (row %d, column %d)", self.row, self.col))
		return nil
	end
	local edge = {
		flowchart = self.flowchart,
		type = "flowchartedge",				-- widget type
		descriptor = nil,					-- descriptor (used temporarily)
		id = nil,							-- widget ID, valid while displayed
		sourcecell = self,					-- source cell
		destcell = destcell,				-- destination cell
		sourceslot = nil,					-- determined and set by finalizeFlowchartCellSlots()
		destslot = nil,						-- determined and set by finalizeFlowchartCellSlots()
		duplicate = nil,					-- determined and set by finalizeFlowchartCellSlots()
		properties = { }					-- edge properties
	}
	table.insert(self.flowchart.edges, edge)

	-- set metatables to enable member functions and default properties
	setmetatable(edge, widgetMetatables.flowchartedge)
	setmetatable(edge.properties, widgetPropertyMetatables.flowchartedge)

	-- propagate scaling from flowchart to edge
	if not self.flowchart.properties.scaling then
		edge.properties.scaling = false
	end
	-- apply default edge properties
	if self.flowchart.defaultEdgeProperties then
		edge.properties:apply(self.flowchart.defaultEdgeProperties)
	end
	-- apply custom properties
	edge.properties:apply(properties)
	-- link edge to source/dest nodes
	table.insert(self.outgoingEdges, edge)
	table.insert(destcell.incomingEdges, edge)
	return edge
end

---------- Specialized flowchart cell member functions and specialization functions ----------

-- getCellMinWidth() for either cell type
function widgetPrototypes.flowchartnode:getCellMinWidth()
	local offsetx = Helper.scaleX(self.properties.x, self.properties.scaling)
	local nodewidth = Helper.scaleX(self.properties.width, self.properties.scaling)
	return offsetx * 2 + nodewidth
end

function widgetPrototypes.flowchartjunction:getCellMinWidth()
	local offsetx = Helper.scaleX(self.properties.x, self.properties.scaling)
	local junctionxoff = Helper.scaleX(math.max(0, self.properties.junctionXOff), self.properties.scaling)
	return offsetx * 2 + junctionxoff * 2
end

-- getCellMinHeight() for either cell type
function widgetPrototypes.flowchartnode:getCellMinHeight()
	local offsety = Helper.scaleY(self.properties.y, self.properties.scaling)
	local nodeheight = Helper.scaleY(self.properties.height, self.properties.scaling)
	return offsety * 2 + nodeheight
end

function widgetPrototypes.flowchartjunction:getCellMinHeight()
	local offsety = Helper.scaleY(self.properties.y, self.properties.scaling)
	return offsety * 2
end

-- flowchartnode
function widgetPrototypes.flowchartnode:setText(text, properties)
	self.properties.text.scaling = self.properties.scaling
	-- apply default text properties
	if self.flowchart.defaultTextProperties then
		self.properties.text:apply(self.flowchart.defaultTextProperties)
	end
	-- apply custom properties
	self.properties.text.text = text
	self.properties.text:apply(properties)
	return self
end

function widgetPrototypes.flowchartnode:setStatusText(text, properties)
	-- apply default text properties
	if self.flowchart.defaultTextProperties then
		self.properties.statustext:apply(self.flowchart.defaultTextProperties)
	end
	-- apply custom properties
	self.properties.statustext.text = text
	self.properties.statustext:apply(properties)
	return self
end

function widgetPrototypes.flowchartnode:setStatusIcon(icon, properties)
	-- apply default icon properties
	if self.flowchart.defaultIconProperties then
		self.properties.statusicon:apply(self.flowchart.defaultIconProperties)
	end
	-- apply custom properties
	self.properties.statusicon.icon = icon
	self.properties.statusicon:apply(properties)
	return self
end

function widgetHelpers.flowchartnode:createDescriptor()
	local scaling = self.properties.scaling
	local offsetx = Helper.scaleX(self.properties.x, scaling)
	local offsety = Helper.scaleY(self.properties.y, scaling)
	local width = Helper.scaleX(self.properties.width, scaling)
	local height = Helper.scaleY(self.properties.height, scaling)
	local mouseovertext = self.properties.mouseOverText
	local connectorsize = Helper.scaleY(self.properties.connectorSize, scaling)
	local outlineColor = self.properties.outlineColor
	local value = self.properties.value
	local helpoverlay = createOverlayPropertyInfo(self)

	local isfunctioncell = false
	isfunctioncell = isfunctioncell or isTextPropertyFunctionCell(self, self.properties.text)
	isfunctioncell = isfunctioncell or isTextPropertyFunctionCell(self, self.properties.statustext)
	isfunctioncell = isfunctioncell or isIconPropertyFunctionCell(self, self.properties.statusicon)

	if type(self.properties.statusColor) == "function" then
		isfunctioncell = true
	end
	if type(value) == "function" then
		isfunctioncell = true
		value = value(self)
	end
	if type(outlineColor) == "function" then
		isfunctioncell = true
		outlineColor = outlineColor(self)
	end
	if type(mouseovertext) == "function" then
		mouseovertext = mouseovertext(self)
		isfunctioncell = true
	end
	if isfunctioncell then
		table.insert(self.flowchart.frame.functionCells, self)
	end

	local flowchartNodeDescriptor = { }
	flowchartNodeDescriptor.offset = { x = offsetx, y = offsety }
	flowchartNodeDescriptor.size = { width = width, height = height }
	flowchartNodeDescriptor.helpoverlay = helpoverlay
	flowchartNodeDescriptor.connectorsize = connectorsize
	flowchartNodeDescriptor.mouseovertext = mouseovertext
	flowchartNodeDescriptor.expandable = (self.properties.expandedFrameLayer >= 1 and self.properties.expandedTableNumColumns >= 1)
	flowchartNodeDescriptor.caption = createTextPropertyInfo(self, self.properties.text)
	flowchartNodeDescriptor.statustext = createTextPropertyInfo(self, self.properties.statustext)
	flowchartNodeDescriptor.statusicon = createIconPropertyInfo(self, self.properties.statusicon)
	flowchartNodeDescriptor.statusbgiconid = self.properties.statusBgIconID
	flowchartNodeDescriptor.statusbgiconrotating = self.properties.statusBgIconRotating
	flowchartNodeDescriptor.statusiconmouseovertext = self.properties.statusIconMouseOverText
	if self.properties.statusColor then
		if flowchartNodeDescriptor.statustext then
			flowchartNodeDescriptor.statustext.color = self.properties.statusColor
		end
		if flowchartNodeDescriptor.statusicon then
			flowchartNodeDescriptor.statusicon.color = self.properties.statusColor
		end
	end
	-- shape
	local shape = self.properties.shape
	if shape == "rectangle" then
		flowchartNodeDescriptor.shape = 1
	elseif shape == "stadium" then
		flowchartNodeDescriptor.shape = 2
	elseif shape == "hexagon" then
		flowchartNodeDescriptor.shape = 3
	else
		DebugError(string.format("flowchartnode:createDescriptor(): Unknown shape '%s', using fallback 'rectangle'", shape))
		flowchartNodeDescriptor.shape = 1
	end
	-- slot colors
	flowchartNodeDescriptor.input = self.slotcolors.input
	flowchartNodeDescriptor.output = self.slotcolors.output
	-- scale
	flowchartNodeDescriptor.scale = {
		value = value,
		max = self.properties.max,
		slider1 = self.properties.slider1,
		slider2 = self.properties.slider2,
		slider1mouseovertext = self.properties.slider1MouseOverText,
		slider2mouseovertext = self.properties.slider2MouseOverText,
		step = self.properties.step,
	}
	-- colors
	flowchartNodeDescriptor.colors = {
		background = self.properties.bgColor,
		outline = outlineColor,
		value = self.properties.valueColor,
		slider1 = self.properties.slider1Color,
		slider2 = self.properties.slider2Color,
		diff1 = self.properties.diff1Color,
		diff2 = self.properties.diff2Color,
	}
	return CreateFlowchartNode(flowchartNodeDescriptor)
end

function widgetHelpers.flowchartnode:setScripts()
	if not self.id then
		DebugError("flowchartnode:setScripts(): Widget ID not available yet")
		return
	end
	local menu = self.flowchart.frame.menu
	local layer = GetFrameLayer(self.flowchart.frame.id)
	menu.flowchartNodeScriptMap = menu.flowchartNodeScriptMap or {}
	local scriptmap = {
		["onFlowchartNodeExpanded"] = function() self:expand() end,
		["onFlowchartNodeCollapsed"] = function() self:collapse() end,
		["onFlowchartNodeSliderActivated"] = self.handlers.onSliderActivated,
		["onFlowchartNodeSliderChanged"] = function(_, slideridx, slidervalue) widgetHelpers.flowchartnode.onSliderChanged(self, slideridx, slidervalue) end,
		["onFlowchartNodeSliderDeactivated"] = self.handlers.onSliderDeactivated,
	}
	for scriptHandle, script in pairs(scriptmap) do
		table.insert(menu.flowchartNodeScriptMap, { layer = layer, flowchartid = self.flowchart.id, row = self.row, col = self.col, type = scriptHandle, script = script })
		SetScript(self.id, scriptHandle, script)
	end
end

function widgetHelpers.flowchartnode:onSliderChanged(slideridx, slidervalue)
	if slideridx == 1 then
		self.properties.slider1 = slidervalue
	else
		self.properties.slider2 = slidervalue
	end
	if self.handlers.onSliderChanged then
		self.handlers.onSliderChanged(self.id, slideridx, slidervalue)
	end
end

function widgetPrototypes.flowchartnode:expand()
	if not self.id then
		DebugError("flowchartnode:expand(): Widget ID not available yet")
		return
	end
	if self.flowchart.expandedNodes[self] then
		DebugError("flowchartnode:expand(): Flowchart node was already expanded")
		return
	end
	if not self.handlers.onExpanded or self.properties.expandedFrameLayer < 1 or self.properties.expandedTableNumColumns < 1 then
		-- no handler, nothing to do
		return
	end

	-- create expanded menu frame
	local nodex, nodey, framepaddingx, framepaddingy = GetFlowchartNodeExpandedFrameData(self.id)
	if nodex == nil then
		return
	end
	local nodewidth, nodeheight = GetSize(self.id)
	local framewidth = nodewidth - 2 * framepaddingx
	-- determine max height: maxframeheight + 2 * framepaddingy == length of either [0, nodetop] or [nodebottom, viewheight]
	local maxframeheight = math.max(nodey - nodeheight / 2, Helper.viewHeight - (nodey + nodeheight / 2)) - 2 * framepaddingy

	local frame = Helper.createFrameHandle(self.flowchart.frame.menu, {
		layer = self.properties.expandedFrameLayer,
		x = nodex - framewidth / 2,
		y = 0,						-- determined later
		width = framewidth,
		height = maxframeheight,	-- adjusted later
		standardButtons = { },		-- no standard buttons
		closeOnUnhandledClick = true,
	})
	local numTables = self.properties.expandedFrameNumTables
	if (numTables <= 0) or (numTables > 2) then
		DebugError("flowchartnode:expand(): Flowchart node property expandedFrameNumTables is out of range [1, 2]. Defaulting to 1")
		numTables = 1
	end
	local ftable = frame:addTable(self.properties.expandedTableNumColumns, { tabOrder = 1, borderEnabled = true, wraparound = true })
	local ftable2
	if numTables == 2 then
		ftable2 = frame:addTable(self.properties.expandedTableNumColumns, { tabOrder = 2, borderEnabled = true, wraparound = true })
	end
	-- frame will be shown if handler adds at least one row to ftable
	if self.properties.uiTriggerID then
		AddUITriggeredEvent(self.flowchart.frame.menu.name, self.properties.uiTriggerID, "expanded")
	end
	self.handlers.onExpanded(self, frame, ftable, ftable2)
	if #ftable.rows > 0 then
		-- Shrink frame height
		frame.properties.height = frame:getUsedHeight()

		-- Determine Y offset of frame (expand below node if possible, otherwise above node)
		local expandedAbove = false
		if nodey + nodeheight / 2 + frame.properties.height > Helper.viewHeight then
			expandedAbove = true
			frame.properties.y = nodey - nodeheight / 2 - framepaddingy - frame.properties.height
		else
			frame.properties.y = nodey + nodeheight / 2 + framepaddingy
		end

		-- link node and frame, register node as (being) expanded, and draw frame
		frame.expandedFlowchartNodeData = { node = self, expandedAbove = expandedAbove }
		self.flowchart.expandedNodes[self] = frame
		-- the frame will trigger the node expansion and drawing of the popup background on the same layer as the frame
		frame:display()

		-- TODO #flowchart: onUpdate handler for function widgets
	else
		-- expansion failed, allow menu to clean up
		if self.handlers.onCollapsed then
			self.handlers.onCollapsed(self, frame)
		end
	end
end

function widgetPrototypes.flowchartnode:collapse()
	local frame = self.flowchart.expandedNodes[self]
	if self.id then
		C.SetFlowchartNodeExpanded(self.id, 0, false)
	end
	if frame then
		if not frame.id then
			DebugError("flowchartnode:collapse(): Collapsing flowchartnode before expanded menu frame is created")
		end
		self.flowchart.expandedNodes[self] = nil
		if self.handlers.onCollapsed then
			if self.properties.uiTriggerID then
				AddUITriggeredEvent(self.flowchart.frame.menu.name, self.properties.uiTriggerID, "collapsed")
			end
			self.handlers.onCollapsed(self, frame)
		end
	end
end

function widgetPrototypes.flowchartnode:getExpandedFrame()
	if self.id then
		return self.flowchart.expandedNodes[self]
	end
	return nil
end

function widgetPrototypes.flowchartnode:updateOutlineColor(color)
	if self.id then
		self.properties.outlineColor = color
		C.SetFlowChartNodeOutlineColor(self.id, Helper.ffiColor(color))
	end
end

function widgetPrototypes.flowchartnode:updateText(text, color)
	if self.id then
		if text then
			self.properties.text.text = text
			C.SetFlowChartNodeCaptionText(self.id, tostring(text))
		end
		if color then
			self.properties.text.color = color
			C.SetFlowChartNodeCaptionTextColor(self.id, Helper.ffiColor(color))
		end
	end
end

function widgetPrototypes.flowchartnode:updateStatus(text, icon, bgicon, color, mouseovertext)
	if self.id then
		text = text or ""
		icon = icon or ""
		bgicon = bgicon or ""
		self.properties.statustext.text = text
		self.properties.statusicon.icon = icon
		self.properties.statusBgIconID = bgicon
		C.SetFlowChartNodeStatusText(self.id, tostring(text))
		C.SetFlowChartNodeStatusIcon(self.id, icon)
		C.SetFlowChartNodeStatusBgIcon(self.id, bgicon)
		if color then
			self.properties.statusColor = color
			C.SetFlowChartNodeStatusColor(self.id, Helper.ffiColor(color))
		end
		if mouseovertext then
			if icon ~= "" then
				self.properties.statusIconMouseOverText = mouseovertext
				C.SetFlowChartNodeStatusIconMouseOverText(self.id, mouseovertext)
			end
		end
	end
end

function widgetPrototypes.flowchartnode:updateValue(value)
	if self.id then
		self.properties.value = value
		C.SetFlowChartNodeCurValue(self.id, value)
	end
end

function widgetPrototypes.flowchartnode:updateMaxValue(value)
	if self.id then
		self.properties.max = value
		C.SetFlowChartNodeMaxValue(self.id, value)
	end
end

function widgetPrototypes.flowchartnode:updateSlider1(value)
	if self.id then
		value = value or -1		-- allow passing nil value to disable slider
		self.properties.slider1 = value
		C.SetFlowChartNodeSlider1Value(self.id, value)
	end
end

function widgetPrototypes.flowchartnode:updateSlider2(value)
	if self.id then
		value = value or -1		-- allow passing nil value to disable slider
		self.properties.slider2 = value
		C.SetFlowChartNodeSlider2Value(self.id, value)
	end
end

function widgetPrototypes.flowchartnode:updateSliderStep(step)
	if self.id then
		self.properties.step = step
		C.SetFlowChartNodeSliderStep(self.id, step)
	end
end

-- flowchartjunction
function widgetHelpers.flowchartjunction:createDescriptor()
	local scaling = self.properties.scaling
	local offsetx = Helper.scaleX(self.properties.x, scaling)
	local offsety = Helper.scaleY(self.properties.y, scaling)
	local mouseovertext = self.properties.mouseOverText

	local junctionsize = Helper.scaleY(self.properties.junctionSize, scaling)
	local junctionxoff = self.properties.junctionXOff
	if junctionxoff < 0 then
		-- use the column's junctionxoff
		junctionxoff = self.flowchart.columndata[self.col].junctionxoff
	else
		junctionxoff = Helper.scaleX(junctionxoff, scaling)
	end

	local isfunctioncell = false
	if type(mouseovertext) == "function" then
		mouseovertext = mouseovertext(self)
		isfunctioncell = true
	end
	if isfunctioncell then
		table.insert(self.flowchart.frame.functionCells, self)
	end

	local flowchartJunctionDescriptor = { }
	flowchartJunctionDescriptor.shape = 0
	flowchartJunctionDescriptor.offset = { x = offsetx, y = offsety }
	flowchartJunctionDescriptor.size = { width = 2 * math.ceil(junctionxoff), height = 0 }
	flowchartJunctionDescriptor.mouseovertext = mouseovertext
	flowchartJunctionDescriptor.junctionsize = junctionsize
	flowchartJunctionDescriptor.junctioncolor = self.junctionColor

	-- A flowchart junction is actually just a FlowchartNode widget with shape == 0
	return CreateFlowchartNode(flowchartJunctionDescriptor)
end

-- flowchartedge
function widgetHelpers.flowchartedge:createDescriptor()
	-- Position and size shouldn't be relevant, but keep it consistent
	local scaling = self.properties.scaling
	local offsetx = Helper.scaleX(self.properties.x, scaling)
	local offsety = Helper.scaleY(self.properties.y, scaling)
	local width = Helper.scaleX(self.properties.width, scaling)
	local height = Helper.scaleY(self.properties.height, scaling)
	local color = self.properties.color

	local isfunctioncell = false		-- technically not a cell, but let's keep it consistent
	if type(color) == "function" then
		isfunctioncell = true
		color = color(self)
	end
	if isfunctioncell then
		table.insert(self.flowchart.frame.functionCells, self)
	end

	local flowchartEdgeDescriptor = { }
	flowchartEdgeDescriptor.offset = { x = offsetx, y = offsety }
	flowchartEdgeDescriptor.size = { width = width, height = height }

	flowchartEdgeDescriptor.source = { row = self.sourcecell.row, col = self.sourcecell.col, slot = self.sourceslot }
	flowchartEdgeDescriptor.dest   = { row = self.destcell.row,   col = self.destcell.col,   slot = self.destslot }
	flowchartEdgeDescriptor.color = color
	return CreateFlowchartEdge(flowchartEdgeDescriptor)
end

function widgetPrototypes.flowchartedge:updateColor(color)
	if self.id then
		self.properties.color = color
		C.SetFlowChartEdgeColor(self.id, Helper.ffiColor(color))
	end
end

---------------------------------------------------------------------------------
-- Flowchart setup
---------------------------------------------------------------------------------

local setupDAGLayoutHelper = { }

-- Input:
-- Array of nodes, connected as a directed acyclic graph (DAG). Each node is a table containing custom data and an optional table
-- called predecessors. The predecessors table maps other nodes in the table to an input slot number, e.g. 1.
-- If a node has different slots for incoming edges, a higher number indicates a higher slot offset (towards the bottom of the node).
-- This is necessary because it puts constraints on the row indices of predecessors to avoid edge crossings.
-- Nodes can have the following additional keys:
-- - numrows: Number of rows this node occupies (default is 1), used for abstract nodes that contain several other nodes themselves.
-- - numcols: Number of columns this node occupies (default is 1).
-- - halign: Horizontal alignment within a tier, which can span multiple columns ("left" or "right", default is "right")
-- Note: If numrows > 1 then the row offset of outgoing edges is assumed to be math.floor((numrows - 1) / 2), see slotrowoffset
-- Example:
--	local nodes = { }
--	nodes.foo = { foo = 1 },
--	nodes.bar = { foo = 2, predecessors = { nodes.foo = 1 } },
--	nodes.baz = { foo = 3, predecessors = { nodes.foo = 2 } },
--	nodes.foobar = { foo = 4, predecessors = { nodes.bar = 1, nodes.baz = 1 } }
--	nodes.foobaz = { foo = 5, predecessors = { nodes.foo = 1, nodes.baz = 2 } }
-- Result:
-- The function calculates a graph layout and assigns row/col coordinates to the DAG nodes so that
-- all flowchart edges point from left to right. It can also add junction nodes for aesthetic reasons.
-- Predecessors change on insertion of junctions, but the junctions are returned in a separate table.
-- Example:
--	local numrows, numcols, junctions = Helper.setupDAGLayout(nodes)
--	print(nodes.foo.row, nodes.foo.col)
--   |    1        2          3     |
-- 1 | [foo]-+--->[*]-+             |
--   |      \ \        \            |
-- 2 |       \ \>[baz]--+->[foobaz] |
--   |        \       \             |
-- 3 |         \>[bar]-+-->[foobar] |
function Helper.setupDAGLayout(nodes)
	local setup = { }
	setmetatable(setup, { __index = setupDAGLayoutHelper })
	return setup:process(nodes)
end

function setupDAGLayoutHelper:process(nodes)
	self:init(nodes)
	self:buildTiers()
	self:reduceEdgeCrossings()
	self:assignPositions()
	self:buildJunctions()
	return self.numrows, self.numcols, self.junctions
end

-- init members
function setupDAGLayoutHelper:init(nodes)
	self.originalnodes = nodes
	-- map the original nodes to our own node structs
	self.nodes = { }
	for originalidx, originalnode in ipairs(nodes) do
		self.nodes[originalnode] = {
			originalnode = originalnode,
			predecessors = { },
			numpredecessors = 0,
			successors = { },
			numsuccessors = 0,
			numrows = originalnode.numrows or 1,
			numcols = originalnode.numcols or 1,
			slotrowoffset = math.floor(((originalnode.numrows or 1) - 1) / 2),
			halign = originalnode.halign or "right",
			slotweight = 1,
			-- the following values are set later
			realnode = nil,					-- ancestor node that is not virtual (valid for virtual nodes)
			virtualdescendants = nil,		-- table of all virtual descendents, mapped by tier (valid for ancestor node of virtual nodes)
			tieridx = nil,					-- index of tier
			tiernodeidx = nil,				-- index of node in tier
			rowweight = nil,				-- row weight, temporarily used in reduceEdgeCrossings()
			minrow = nil,					-- minimal row number, temporarily used in improveRowAssignments()
			favrow = nil,					-- favourite row number, temporarily used in improveRowAssignments()
			row = nil,
			col = nil,
		}
	end
	self.virtualnodes = { }
	self.numrows = 0
	self.numcols = 0
	-- register predecessors and successors
	for _, node in pairs(self.nodes) do
		if node.originalnode.predecessors then
			for originalpredecessor, slot in pairs(node.originalnode.predecessors) do
				local predecessor = self.nodes[originalpredecessor]
				if predecessor then
					node.predecessors[predecessor] = slot
					node.numpredecessors = node.numpredecessors + 1
					predecessor.successors[node] = slot
					predecessor.numsuccessors = predecessor.numsuccessors + 1
				else
					DebugError(string.format("setupDAGLayoutHelper: Found a node with an invalid predecessor, ignoring"))
				end
			end
		end
	end
	-- determine slot weights (average input slot value of all predecessors)
	-- note: a higher input slot value indicates an edge from below, so to reduce edge crossings, the node should be placed
	-- further down compared to nodes with lower slot values.
	for _, node in pairs(self.nodes) do
		local totalslots = node.numpredecessors + node.numsuccessors
		local slotsum = 0
		for predecessor, slot in pairs(node.predecessors) do
			slotsum = slotsum + slot
		end
		for successor, slot in pairs(node.successors) do
			slotsum = slotsum + slot
		end
		if totalslots > 0 then
			node.slotweight = slotsum / totalslots
		end
	end
end

-- build tier table and assign corresponding tier values to nodes
function setupDAGLayoutHelper:buildTiers()
	local remainingnodes = { }
	for _, node in pairs(self.nodes) do
		remainingnodes[node] = true
	end
	local showerror = true
	while not self:attemptBuildTiers(remainingnodes) do
		-- a cycle was detected (in the simplest case: edge to self), attempt recovery by breaking the cycle
		if showerror then
			DebugError(string.format("setupDAGLayoutHelper: Cyclic dependencies detected. Removing dependencies to create a DAG."))
			showerror = false
		end
		if not self:removeCyclicEdge(remainingnodes) then
			-- recovery failed (this should not happen, but best prevent an accidental infinite loop)
			break
		end
		-- start over with one removed predecessor edge
		for _, node in pairs(self.nodes) do
			remainingnodes[node] = true
		end
	end
end

-- helper for buildTiers(): separate DAG into tiers
function setupDAGLayoutHelper:attemptBuildTiers(remainingnodes)
	-- - tier 1 contains all nodes without predecessors (leftmost column)
	-- - tier n+1 contains all nodes that are not in tiers 1 to n, but have all their predecessors in tiers 1 to n
	self.tiers = { }
	-- loop until there are no more remaining nodes
	while next(remainingnodes) do
		local tier = self:getNextTier(remainingnodes)
		-- the new tier must be non-empty if the graph is really a DAG
		if #tier == 0 then
			return false
		end
		table.insert(self.tiers, tier)
		for nodeidx, node in ipairs(tier) do
			remainingnodes[node] = nil
			node.tieridx = #self.tiers
			node.tiernodeidx = nodeidx
		end
	end
	return true
end

-- helper for attemptBuildTiers(): return array of nodes that have no predecessors in remainingnodes
function setupDAGLayoutHelper:getNextTier(remainingnodes)
	local tier = { }
	-- note: iterating over remainingnodes would be more efficient but would produce random results
	for _, originalnode in pairs(self.originalnodes) do
		local node = self.nodes[originalnode]
		if remainingnodes[node] then
			local ok = true
			for predecessor, _ in pairs(node.predecessors) do
				if remainingnodes[predecessor] then
					ok = false
					break
				end
			end
			if ok then
				table.insert(tier, node)
			end
		end
	end
	return tier
end

-- helper function for buildTiers(): remove a predecessor of node that is in remainingnodes, indicating a cycle
function setupDAGLayoutHelper:removeCyclicEdge(remainingnodes)
	local node = next(remainingnodes)
	for predecessor, _ in pairs(node.predecessors) do
		if remainingnodes[predecessor] then
			node.predecessors[predecessor] = nil
			node.numpredecessors = node.numpredecessors - 1
			predecessor.successors[node] = nil
			predecessor.numsuccessors = predecessor.numsuccessors - 1
			return true
		end
	end
	return false
end

-- partially based on dot's algorithm (1993): http://www.graphviz.org/Documentation/TSE93.pdf
function setupDAGLayoutHelper:reduceEdgeCrossings()
	-- first, go through the tiers from left to right and arrange nodes in each tier, minimising edge crossings to tiers on the left side
	-- (note: for the Logical Station Overview case, this step is not strictly needed, since there are usually fewer nodes on the right side than on the left side)
	for tieridx = 1, #self.tiers do
		local tier = self.tiers[tieridx]
		--print(string.format("reduceEdgeCrossings() left-to-right, tier %d", tieridx))
		for nodeidx, node in ipairs(tier) do
			-- determine rowweight that we can use for sorting (higher value = higher row number)
			local indexmedian = self:getTierNodeIndexMedian(node.predecessors, tieridx - 1) or 1000
			-- sort by indexmedian first; in case of equal median use the slotweight; and if in doubt, keep the original node order
			node.rowweight = (indexmedian * 100) + node.slotweight + (nodeidx / 100)
			--print(string.format("  node '%s' median=%s, slotweight=%s, rowweight=%s", node.originalnode.text, indexmedian, node.slotweight, node.rowweight))
		end
		-- arrange tier nodes according to rowweights
		table.sort(tier, function (a, b) return a.rowweight < b.rowweight end)
	end

	local fixedordernodes = { }
	-- second, go through the tiers from right to left and arrange nodes in each tier, minimising edge crossings to tiers on the right side
	-- (in this step, virtual nodes can be created and have to be taken into account)
	for tieridx = #self.tiers, 1, -1 do
		local tier = self.tiers[tieridx]
		--print(string.format("reduceEdgeCrossings() right-to-left, tier %d", tieridx))
		-- collect predecessors of virtual nodes in this tier (because their relative ordering is determined by the ordering of the virtual nodes)
		for nodeidx, node in ipairs(tier) do
			-- prepare for the next tier iteration: if necessary, add virtual node to the tier on the left
			do
				-- do this in a reproducible manner - using node.predecessors directly results in random orders and random outcomes
				local virtualnodedata = { }
				for predecessor, _ in pairs(node.predecessors) do
					if predecessor.tieridx < node.tieridx - 1 then
						table.insert(virtualnodedata, predecessor)
					end
				end
				table.sort(virtualnodedata, function (a, b) return a.tieridx * 1000 + a.tiernodeidx < b.tieridx * 1000 + b.tiernodeidx end)
				for _, predecessor in ipairs(virtualnodedata) do
					self:insertVirtualNode(node.tieridx - 1, predecessor, node)
				end
			end
			-- determine rowweight that we can use for sorting (higher value = higher row number)
			local indexmedian = self:getTierNodeIndexMedian(node.successors, tieridx + 1) or 1000
			-- sort by indexmedian first; in case of equal median use the slotweight; and if in doubt, keep the original node order
			node.rowweight = (indexmedian * 100) + node.slotweight + (nodeidx / 100)
			--print(string.format("  node '%s' median=%s, slotweight=%s, rowweight=%s", node.originalnode.text, indexmedian, node.slotweight, node.rowweight))
		end
		if #fixedordernodes >= 2 then
			-- the relative ordering of nodes in fixedordernodes is fixed, so adjust the rowweights accordingly
			-- (current simple implementation, ignoring node relevance: keep first node unchanged and adjust ordering of following nodes)
			local lastrowweight = nil
			for _, node in ipairs(fixedordernodes) do
				if lastrowweight then
					if node.rowweight <= lastrowweight then
						node.rowweight = lastrowweight + 0.001
					end
				end
				lastrowweight = node.rowweight
			end
		end
		-- arrange tier nodes according to rowweights
		table.sort(tier, function (a, b) return a.rowweight < b.rowweight end)
		-- some cleanup and preparation for next tier iteration
		fixedordernodes = { }
		for nodeidx, node in ipairs(tier) do
			-- restore node indices in tier array
			node.tiernodeidx = nodeidx
			node.rowweight = nil	-- not needed any more
			-- if node is virtual, add its (only) predecessor to fixedordernodes
			if node.realnode then
				table.insert(fixedordernodes, (next(node.predecessors)))
			end
		end
	end
end

-- helper function for reduceEdgeCrossings(): add virtual node to the specified tier for an edge that goes through it
function setupDAGLayoutHelper:insertVirtualNode(tieridx, predecessor, successor)
	local slot = predecessor.successors[successor]
	if not slot then
		DebugError("setupDAGLayoutHelper:insertVirtualNode() Internal error: Function called with invalid predecessor/successor")
		return
	end
	-- first remove original edge (but don't decrement the successor's number of predecessors, later we'll add the virtual node as predecessor anyway)
	successor.predecessors[predecessor] = nil
	successor.originalnode.predecessors[predecessor.originalnode] = nil
	predecessor.successors[successor] = nil
	predecessor.numsuccessors = predecessor.numsuccessors - 1
	-- find the "real" predecessor
	local realnode = predecessor.realnode or predecessor
	-- virtualdescendants are all virtual nodes between realnode and its "real" successors
	-- but each tier can have only one virtual successor of the predecessor
	-- (the predecessor and all virtual successors will end up in the same row)
	-- note: table key is the tier index, so the table is not necessarily a valid sequence
	realnode.virtualdescendants = realnode.virtualdescendants or { }
	-- is there already a virtual successor of predecessor in this tier?
	local virtualnode = realnode.virtualdescendants[tieridx]
	if not virtualnode then
		-- create new virtual node in the tier and connect it to predecessor
		virtualnode = {
			originalnode = { predecessors = { [predecessor.originalnode] = slot } },
			realnode = predecessor.realnode or predecessor,
			predecessors = { [predecessor] = slot },
			numpredecessors = 1,
			successors = { },
			numsuccessors = 0,
			numrows = 1,
			numcols = 1,
			slotrowoffset = 0,
			slotweight = predecessor.slotweight,
			tieridx = tieridx,
			tiernodeidx = #self.tiers[tieridx],
		}
		predecessor.successors[virtualnode] = slot
		predecessor.numsuccessors = predecessor.numsuccessors + 1
		realnode.virtualdescendants[tieridx] = virtualnode
		table.insert(self.tiers[tieridx], virtualnode)
		self.virtualnodes[virtualnode] = true
	end
	-- connect virtual node to successor
	successor.predecessors[virtualnode] = slot
	successor.originalnode.predecessors[virtualnode.originalnode] = slot
	virtualnode.successors[successor] = slot
	virtualnode.numsuccessors = virtualnode.numsuccessors + 1
end

-- helper for reduceEdgeCrossings(): return median of index median of nodes in the specified tier, or nil if there are no nodes
function setupDAGLayoutHelper:getTierNodeIndexMedian(nodes, tieridx)
	-- look at successor indices in next tier and determine median
	local indices = { }
	for successor, _ in pairs(nodes) do
		if successor.tieridx == tieridx then
			table.insert(indices, successor.tiernodeidx)
		end
	end
	if #indices == 0 then
		return nil
	end
	table.sort(indices)
	if #indices % 2 == 1 then
		return indices[(#indices + 1) / 2]
	end
	local medianidx = #indices / 2
	return (indices[medianidx] + indices[medianidx + 1]) / 2
end

function setupDAGLayoutHelper:assignPositions()
	-- initial assignment of rows and columns
	-- taking into account that a sequence of virtual nodes must be on the same row
	for tieridx, tier in ipairs(self.tiers) do
		-- determine tier colspan
		local colspan = 1
		for _, node in ipairs(tier) do
			colspan = math.max(colspan, node.numcols)
		end
		local row = 1
		local col = self.numcols + 1
		for _, node in ipairs(tier) do
			node.row = row
			node.col = col + (node.halign == "left" and 0 or (colspan - node.numcols))
			if node.realnode then
				local outrow = node.realnode.row + node.realnode.slotrowoffset
				-- this is a virtual node, it must be on the same row as the original node
				if node.row > outrow then
					-- we have to shift the predecessors in the previous tiers down to match the higher row number
					local rowdiff = node.row - outrow
					self:insertEmptyRowsAboveVirtualNodes(node.realnode, tieridx - 1, rowdiff)
				elseif node.row < outrow then
					-- shift current node down
					node.row = outrow
				end
			end
			row = node.row + node.numrows
		end
		self.numrows = math.max(self.numrows, row - 1)
		self.numcols = col + colspan - 1
	end

	-- improve row assignment
	local firstusedrow = self.numrows
	for tieridx, tier in ipairs(self.tiers) do
		-- virtual nodes and their ancestors are now fixed, all other nodes can still be shifted up or down
		-- determine boundaries for shifting
		local topnodeidx = 1
		local toprow = 1
		local numusedrows = 0
		for nodeidx, node in ipairs(tier) do
			if node.virtualdescendants or node.realnode then
				-- found a fixed node, improve positions of nodes above
				self:improveRowAssignments(tieridx, topnodeidx, toprow, nodeidx - 1, node.row - 1, numusedrows)
				topnodeidx = nodeidx + 1
				toprow = node.row + node.numrows
				numusedrows = 0
			else
				numusedrows = numusedrows + node.numrows
			end
		end
		local bottomnode = tier[#tier]
		if bottomnode then
			local bottomrow = bottomnode.row + bottomnode.numrows - 1
			-- allow incrementing number of rows by half num rows of the last node, because it could make sense to move the slot for incoming/outgoing edges down
			self:improveRowAssignments(tieridx, topnodeidx, toprow, #tier, math.max(self.numrows, bottomrow + math.floor(bottomnode.numrows / 2)), numusedrows)
			self.numrows = math.max(self.numrows, bottomnode.row + bottomnode.numrows - 1)
			firstusedrow = math.min(firstusedrow, tier[1].row)
		end
	end

	-- write rows and columns to original nodes
	for _, tier in ipairs(self.tiers) do
		for _, node in ipairs(tier) do
			-- remove possible empty rows at the top (can occur as rare side-effect of increasing number of allowed rows above)
			if firstusedrow and firstusedrow > 1 then
				node.row = node.row - firstusedrow + 1
			end
			node.originalnode.row = node.row
			node.originalnode.col = node.col
		end
	end
end

-- helper for assignPositions(): shift row numbers of a virtual node sequence down, covering all tiers from righttieridx until realnode (from right to left)
function setupDAGLayoutHelper:insertEmptyRowsAboveVirtualNodes(realnode, righttieridx, numemptyrows)
	for prevtieridx = righttieridx, realnode.tieridx + 1, -1 do
		local descendant = realnode.virtualdescendants[prevtieridx]
		if descendant then
			self:insertEmptyTierRows(descendant, numemptyrows)
		end
	end
	self:insertEmptyTierRows(realnode, numemptyrows)
	-- by changing row numbers, we may have broken another virtual node sequence below realnode
	local tier = self.tiers[realnode.tieridx]
	for nodeidx = realnode.tiernodeidx + 1, #tier do
		local node = tier[nodeidx]
		if node.realnode then
			-- continue recursively, fixing previous tiers
			self:insertEmptyRowsAboveVirtualNodes(node.realnode, realnode.tieridx - 1, numemptyrows)
			break
		end
	end
end

-- helper for assignPositions(): shift row numbers in a tier down, starting at abovenode, and returns new number of rows
function setupDAGLayoutHelper:insertEmptyTierRows(abovenode, numemptyrows)
	if numemptyrows < 0 then
		DebugError("setupDAGLayoutHelper:insertEmptyTierRows() Internal error: Invalid call")
		return
	end
	local tier = self.tiers[abovenode.tieridx]
	for nodeidx = abovenode.tiernodeidx, #tier do
		tier[nodeidx].row = tier[nodeidx].row + numemptyrows
	end
	-- update number of rows
	local lastnode = tier[#tier]
	self.numrows = math.max(self.numrows, lastnode.row + lastnode.numrows - 1)
end

-- helper for assignPositions(): try shifting nodes in a tier up or down to keep edges short and ideally horizontal
function setupDAGLayoutHelper:improveRowAssignments(tieridx, topnodeidx, toprow, bottomnodeidx, bottomrow, numusedrows)
	local maxshift = (bottomrow - toprow + 1) - numusedrows
	if maxshift <= 0 then
		return
	end
	local tier = self.tiers[tieridx]
	for nodeidx = topnodeidx, bottomnodeidx do
		local node = tier[nodeidx]
		node.minrow = node.row
		node.favrow = self:getBestRowAssignment(node, next(node.predecessors) and node.predecessors or node.successors, node.minrow, node.minrow + maxshift)
		-- the favrow assignment may overlap a previous node - re-visit previous nodes, group adjacent nodes together and assign rows to the whole group until there's no overlap
		local sumfavrows = node.favrow
		-- current node is first element in the group of adjacent nodes
		local groupsize = 1
		local groupnumrows = node.numrows
		local groupstartfavrow = node.favrow
		-- check for previous nodes to be added to the group
		for groupstartnodeidx = nodeidx - 1, topnodeidx, -1 do
			local groupstartnode = tier[groupstartnodeidx]
			if groupstartfavrow >= groupstartnode.row + groupstartnode.numrows then
				-- this node is actually not part of the group, we've found the best group size and row assignment
				break
			end
			-- include this node in the group
			groupsize = groupsize + 1
			groupnumrows = groupnumrows + groupstartnode.numrows
			sumfavrows = sumfavrows + groupstartnode.favrow
			groupstartfavrow = (sumfavrows / groupsize) - ((groupnumrows - 1) / 2)
			groupstartfavrow = math.min(math.max(math.ceil(groupstartfavrow - 0.5), groupstartnode.minrow), groupstartnode.minrow + maxshift)
		end
		local favrow = groupstartfavrow
		local groupstartnodeidx = nodeidx - groupsize + 1
		for groupnodeidx = groupstartnodeidx, nodeidx do
			local groupnode = tier[groupnodeidx]
			groupnode.row = favrow
			favrow = favrow + groupnode.numrows
		end
	end
end

-- helper for improveRowAssignments(): determine most preferred row assignment, based on connections to adjacent tier
function setupDAGLayoutHelper:getBestRowAssignment(node, connections, minrow, maxrow)
	local bestrow
	if next(connections) then
		local bestlengths
		for row = minrow, maxrow do
			local slotrow = row + node.slotrowoffset
			local edgelengths = 0
			for adjacentnode, _ in pairs(connections) do
				local adjacentslotrow = adjacentnode.row + adjacentnode.slotrowoffset
				local edgelength = math.sqrt((adjacentslotrow - slotrow) ^ 2 + 1)
				edgelengths = edgelengths + edgelength
			end
			if not bestlengths or edgelengths < bestlengths then
				bestlengths = edgelengths
				bestrow = row
			end
		end
	end
	return bestrow or math.floor((minrow + maxrow) / 2)
end

function setupDAGLayoutHelper:buildJunctions()
	self.junctions = { }
	for vnode, _ in pairs(self.virtualnodes) do
		if vnode.numsuccessors == 1 and next(vnode.successors).row == vnode.row then
			-- virtual node just connects left and right column in the same row, we can skip it
			local successor, succslot = next(vnode.successors)
			local predecessor, predslot = next(vnode.predecessors)
			-- detach vnode from graph
			predecessor.successors[vnode] = nil
			successor.predecessors[vnode] = nil
			successor.originalnode.predecessors[vnode.originalnode] = nil
			vnode.successors[successor] = nil
			vnode.predecessors[predecessor] = nil
			vnode.originalnode.predecessors[predecessor.originalnode] = nil
			vnode.numpredecessors = 0
			vnode.numsuccessors = 0
			-- connect predecessor and successor directly
			predecessor.successors[successor] = succslot
			successor.predecessors[predecessor] = predslot
			successor.originalnode.predecessors[predecessor.originalnode] = predslot
		else
			-- keep this virtual node as a junction
			table.insert(self.junctions, vnode.originalnode)
		end
	end
end

---------------------------------------------------------------------------------
-- Cell Formatting
---------------------------------------------------------------------------------

-- Don't use the result in calculations! If ReadText(1001, 105) is not ".", lua will not be able to interpret this as a number!
function Helper.roundStr(x, digits)
	-- round with optional number of decimal digits
	if digits and digits > 0 then
		local mult = 10^digits
		local strdecimalpoint = ReadText(1001, 105)
		if (x < 0) then
			x = math.floor((-x) * mult + 0.5)
			local i = math.floor(x / mult)
			x = x - i * mult
			return string.format("%s%d%s%0"..digits.."d", "-", i, strdecimalpoint, x)
		else
			x = math.floor(x * mult + 0.5)
			local i = math.floor(x / mult)
			x = x - i * mult
			return string.format("%d%s%0"..digits.."d", i, strdecimalpoint, x)
		end
	else
		return math.floor(x + 0.5)
	end
end
	
function Helper.percent(x, digits)
	-- Convert from decimal fraction to percent number 
	-- and round with optional number of decimal digits
	return Helper.round(x * 100, digits)
end

function Helper.diffpercent(x, isbuyoffer)
	-- Convert from decimal fraction to percent number
	-- and round with optional number of decimal digits
	-- and prefix with + or -
	local val
	if isbuyoffer then
		val = math.floor(x)
	else
		val = math.ceil(x)
	end
	if x > 0 then
		val = "+" .. val
	end
	return val
end

function Helper.interpolatePriceColor(ware, price, isselloffer, darkbasecolor)
	-- In case both selloffer and buyoffer exist, we can show both offer amounts, but everything else can be shown only for one offer.
	-- In that case prefer selloffer data (for buying - change to buyoffer when player attempts to sell)
	local avgprice, minprice, maxprice = GetWareData(ware, "avgprice", "minprice", "maxprice")
	-- Get interpolated price color
	local avgcolor = Color["text_price_average"]
	local mincolor = isselloffer and Color["text_price_good"] or Color["text_price_bad"]
	local maxcolor = isselloffer and Color["text_price_bad"] or Color["text_price_good"]
	local color = avgcolor
	local lerpfactor = 0
	if avgprice ~= 0 and minprice < avgprice and maxprice > avgprice and price ~= avgprice then
		price = math.min(maxprice, math.max(minprice, price))
		if price > avgprice then
			color = maxcolor
			lerpfactor = (price - avgprice) / (maxprice - avgprice)
		else
			color = mincolor
			lerpfactor = (price - avgprice) / (minprice - avgprice)
		end
		--print(ware .. " min=" .. minprice .. " avg=" .. avgprice .. " max=" .. maxprice .. " (price=" .. price .. " => lerpfactor " .. lerpfactor .. ")")
	end
	-- Make price color darker if requested
	darkbasecolor = darkbasecolor or Color["text_normal"]
	local refcolor = Color["text_normal"]
	return {
		r = (avgcolor.r - lerpfactor * (avgcolor.r - color.r)) * darkbasecolor.r / refcolor.r,
		g = (avgcolor.g - lerpfactor * (avgcolor.g - color.g)) * darkbasecolor.g / refcolor.g,
		b = (avgcolor.b - lerpfactor * (avgcolor.b - color.b)) * darkbasecolor.b / refcolor.b,
		a = (avgcolor.a - lerpfactor * (avgcolor.a - color.a)) * darkbasecolor.a / refcolor.a
	}
end

function Helper.timeDuration(x)
	-- Convert from XTIME to days, hours, minutes or seconds
	x = Helper.round(x)
	if x > 119 then
		x = Helper.round(x / 60)
		if x > 119 then
			x = Helper.round(x / 60)
			if x > 47 then
				x = Helper.round(x / 24)
				return x .. " " .. ReadText(1001, 104) -- days
			else
				return x .. " " .. ReadText(1001, 102) -- hours
			end
		else
			return x .. " " .. ReadText(1001, 103) -- minutes
		end
	else
		return x .. " " .. ReadText(1001, 100) -- seconds
	end
end

function Helper.unlockInfo(unlocked, cellcontent)
	if unlocked then
		return cellcontent
	else
		return ReadText(1001, 3210)
	end
end

function Helper.estimateString(estimated)
	if estimated then
		return ReadText(1001, 70) .. " "
	else
		return ""
	end
end

function Helper.sortName(a, b, invert)
	if invert then
		return a.name > b.name
	else
		return a.name < b.name
	end
end

function Helper.sortHullAndName(a, b, invert)
	if a.hull == b.hull then
		return Helper.sortName(a, b)
	end
	if invert then
		return a.hull > b.hull
	else
		return a.hull < b.hull
	end
end

function Helper.sortRelationAndName(a, b, invert)
	if a.relation == b.relation then
		return Helper.sortName(a, b)
	end
	if invert then
		return a.relation > b.relation
	else
		return a.relation < b.relation
	end
end

function Helper.sortNameSectorAndObjectID(a, b, invert)
	local sector_a_name = a.sector or ""
	local sector_b_name = b.sector or ""
	if sector_a_name == sector_b_name then
		return Helper.sortNameAndObjectID(a, b, invert)
	else
		if invert then
			return sector_a_name > sector_b_name
		else
			return sector_a_name < sector_b_name
		end
	end
end

function Helper.sortNameAndObjectID(a, b, invert)
	if (a.fleetname or b.fleetname) and (a.fleetname ~= b.fleetname) then
		if a.fleetname and b.fleetname then
			if invert then
				return a.fleetname > b.fleetname
			else
				return a.fleetname < b.fleetname
			end
		end
		return a.fleetname ~= nil
	end
	if a.name == b.name then
		if invert then
			return a.objectid > b.objectid
		else
			return a.objectid < b.objectid
		end
	end
	if invert then
		return a.name > b.name
	else
		return a.name < b.name
	end
end

function Helper.sortShipsByClassAndPurpose(a, b, invert)
	local aclass = Helper.classOrder[a.class] or 0
	local bclass = Helper.classOrder[b.class] or 0
	if aclass == bclass then
		local apurpose = (a.purpose ~= "") and Helper.purposeOrder[a.purpose] or 0
		local bpurpose = (b.purpose ~= "") and Helper.purposeOrder[b.purpose] or 0
		if apurpose == bpurpose then
			if invert then
				return a.name .. a.objectid > b.name .. b.objectid
			else
				return a.name .. a.objectid < b.name .. b.objectid
			end
		end
		if invert then
			return apurpose > bpurpose
		else
			return apurpose < bpurpose
		end
	else
		if invert then
			return aclass > bclass
		else
			return aclass < bclass
		end
	end
end

function Helper.sortClass(a, b, invert)
	local aclass = Helper.classOrder[a.class] or 0
	local bclass = Helper.classOrder[b.class] or 0
	if invert then
		return aclass > bclass
	else
		return aclass < bclass
	end
end

function Helper.sortID(a, b)
	return a.id < b.id
end

function Helper.sortWareName(a, b)
	local aname = GetWareData(a, "name")
	local bname = GetWareData(b, "name")

	return aname < bname
end

function Helper.sortWareSortOrder(a, b)
	local asortorder, aname = GetWareData(a, "sortorder", "name")
	local bsortorder, bname = GetWareData(b, "sortorder", "name")

	if asortorder == bsortorder then
		return aname < bname
	end
	return asortorder > bsortorder
end

function Helper.sortComponentName(a, b)
	local aname = GetComponentData(a, "name")
	local bname = GetComponentData(b, "name")

	return aname < bname
end

function Helper.sortMacroName(a, b)
	local aname = GetMacroData(a, "name")
	local bname = GetMacroData(b, "name")

	return aname < bname
end

function Helper.sortMacroRaceAndShortname(a, b)
	local ashortname, amakerrace, amk = GetMacroData(a, "shortname", "makerrace", "mk")
	local aracestring = ""
	for i, racestring in ipairs(amakerrace) do
		aracestring = aracestring .. ((i == 1) and "\n" or " - ") .. racestring
	end
	local bshortname, bmakerrace, bmk = GetMacroData(b, "shortname", "makerrace", "mk")
	local bracestring = ""
	for i, racestring in ipairs(bmakerrace) do
		bracestring = bracestring .. ((i == 1) and "\n" or " - ") .. racestring
	end

	if aracestring == bracestring then
		if ashortname == bshortname then
			return amk < bmk
		end
		return ashortname < bshortname
	end
	return aracestring < bracestring
end

function Helper.sortFactionName(a, b)
	local aname = GetFactionData(a, "name")
	local bname = GetFactionData(b, "name")

	return aname < bname
end

function Helper.sortUniverseIDName(a, b)
	local aname = ffi.string(C.GetComponentName(a))
	local bname = ffi.string(C.GetComponentName(b))

	if aname == bname then
		if C.IsComponentClass(a, "object") and C.IsComponentClass(b, "object") then
			return ffi.string(C.GetObjectIDCode(a)) < ffi.string(C.GetObjectIDCode(b))
		end
	end

	return aname < bname
end

function Helper.sortEntityTypeAndName(a, b)
	local a_entitytype, a_name = GetComponentData(a, "typename", "name")
	local b_entitytype, b_name = GetComponentData(b, "typename", "name")
	if a_entitytype == b_entitytype then
		return a_name < b_name
	else
		return a_entitytype < b_entitytype
	end
end

function Helper.sortETA(a, b)
	if (a.eta < 0) then
		return false
	elseif (b.eta < 0) then
		return true
	end
	return a.eta < b.eta
end

function Helper.sortPlayerMacro(a, b)
	if a.race == b.race then
		if a.gender == b.gender then
			return a.macro > b.macro
		else
			local agender = Helper.genderSorting[a.gender] or 0
			local bgender = Helper.genderSorting[b.gender] or 0
			return agender < bgender
		end
	else
		local arace = Helper.raceSorting[a.race] or 0
		local brace = Helper.raceSorting[b.race] or 0
		return arace < brace
	end
end

-- compare slots by their upgradetype first, slotsize in descending order second and by sizecount in ascending order third
function Helper.sortSlots(a, b)
	local atype = 0
	local btype = 0
	-- upgradetype is only added in the ship modification menu
	if a.upgradetype then
		atype = Helper.slotTypeOrder[a.upgradetype] or 0
	end
	if b.upgradetype then
		btype = Helper.slotTypeOrder[b.upgradetype] or 0
	end

	local asize = Helper.slotSizeOrder[a.slotsize] or 0
	local bsize = Helper.slotSizeOrder[b.slotsize] or 0
	if atype == btype then
		if asize == bsize then
			return a.sizecount < b.sizecount
		end
		return asize < bsize
	end
	return atype < btype
end

function Helper.orderedKeys(t, sorter)
	local orderedKey = {}
	for key in pairs(t) do
		table.insert(orderedKey, key)
	end
	table.sort(orderedKey, sorter)
	return orderedKey
end

function Helper.orderedNext(t, state)
	if state == nil then
		t.orderedKeys = Helper.orderedKeys(t)
		key = t.orderedKeys[1]
		if key then
			return key, t[key]
		end
		t.orderedKeys = nil
		return
	end
	key = nil
	for i = 1,table.getn(t.orderedKeys) do
		if t.orderedKeys[i] == state then
			key = t.orderedKeys[i + 1]
		end
	end
	if key then
		return key, t[key]
	end
	t.orderedKeys = nil
	return
end

function Helper.orderedPairs(t)
	return Helper.orderedNext, t, nil
end

function Helper.revOrderedNext(t, state)
	if state == nil then
		t.orderedKeys = Helper.orderedKeys(t)
		key = t.orderedKeys[table.getn(t.orderedKeys)]
		return key, t[key]
	end
	key = nil
	for i = table.getn(t.orderedKeys), 1, -1 do
		if t.orderedKeys[i] == state then
			key = t.orderedKeys[i-1]
		end
	end
	if key then
		return key, t[key]
	end
	t.orderedKeys = nil
	return
end

function Helper.revOrderedPairs(t)
	return Helper.revOrderedNext, t, nil
end

function Helper.orderedNextByWareName(t, state)
	if state == nil then
		t.orderedKeys = Helper.orderedKeys(t, sortWareName)
		key = t.orderedKeys[1]
		if key then
			return key, t[key]
		end
		t.orderedKeys = nil
		return
	end
	key = nil
	for i = 1,table.getn(t.orderedKeys) do
		if t.orderedKeys[i] == state then
			key = t.orderedKeys[i + 1]
		end
	end
	if key then
		return key, t[key]
	end
	t.orderedKeys = nil
	return
end

function Helper.orderedPairsByWareName(t)
	return Helper.orderedNextByWareName, t, nil
end

function Helper.convertGameTimeToXTimeString(time)
	if not Helper.xTimeOffset then
		local date = C.GetGameStartDate()
		if date.isvalid then
			Helper.xTimeOffset = (date.year - 2170) * 31104000 + date.month * 2592000 + date.day * 86400 + 11 * 3600
		else
			-- offset to 825-02-08 11:00
			Helper.xTimeOffset = 825 * 31104000 + 2 * 2592000 + 8 * 86400 + 11 * 3600
		end
	end

	time = time + Helper.xTimeOffset

	local timestring = math.floor(time / 31104000) .. "-"
	time = time % 31104000
	timestring = timestring .. string.format("%02d", math.floor(time / 2592000)) .. "-"
	time = time % 2592000
	timestring = timestring .. string.format("%02d", math.floor(time / 86400)) .. " "
	time = time % 86400
	timestring = timestring .. string.format("%02d", math.floor(time / 3600)) .. ":"
	time = time % 3600
	timestring = timestring .. string.format("%02d", math.floor(time / 60))

	return timestring
end

function Helper.getPassedTime(time)
	local passedtime = C.GetCurrentGameTime() - time
	if passedtime < 0 then
		print("Helper.getPassedTime(): given time is in the future. Returning empty result")
		return ""
	end

	-- kuertee start:
	if passedtime < 60 * 60 then
		local timeformat = ReadText(1001, 209)
		return ConvertTimeString(passedtime, timeformat)
	end
	-- kuertee end

	local timeformat = ReadText(1001, 211)
	if passedtime < 3600 then
		timeformat = ReadText(1001, 213)
	elseif passedtime < 3600 * 24 then
		timeformat = ReadText(1001, 212)
	end

	return ConvertTimeString(passedtime, timeformat)
end

function Helper.getPassedUTCTime(time)
	local passedtime = tonumber(C.GetCurrentUTCDataTime() - time)
	if passedtime < 0 then
		print("Helper.getPassedUTCTime(): given time is in the future. Returning empty result")
		return ""
	end

	local timeformat = ReadText(1001, 216)
	if passedtime < 3600 then
		timeformat = ReadText(1001, 213)
	elseif passedtime < 3600 * 24 then
		timeformat = ReadText(1001, 212)
	end

	return ConvertTimeString(passedtime, timeformat)
end

function Helper.getUTCTime(time)
	local passedtime = tonumber(time - C.GetCurrentUTCDataTime())
	if passedtime < 0 then
		print("Helper.getUTCTime(): given time is in the past. Returning empty result")
		return ""
	end

	local timeformat = ReadText(1001, 206)
	if passedtime < 3600 then
		timeformat = ReadText(1001, 207)
	elseif passedtime < 3600 * 24 then
		timeformat = ReadText(1001, 210)
	end

	return ConvertTimeString(passedtime, timeformat)
end

function Helper.getSuitableControlEntities(object, getshiptrader, onlynpcs)
	local entities = {}

	local pilot, tradenpc, shiptrader = GetComponentData(object, "pilot", "tradenpc", "shiptrader")
	if (not onlynpcs) or IsComponentClass(pilot, "npc") then
		table.insert(entities, pilot)
	end
	if (not onlynpcs) or IsComponentClass(tradenpc, "npc") then
		table.insert(entities, tradenpc)
	end
	if getshiptrader and ((not onlynpcs) or IsComponentClass(shiptrader, "npc")) then
		table.insert(entities, shiptrader)
	end

	return entities
end

function Helper.parseAICommand(entity)
	local poststring, aicommand, aicommandparam = GetComponentData(entity, "poststring", "aicommand", "aicommandparam")
	local container = GetContextByClass(entity, "container")
	if poststring == "manager" then
		aicommand = string.format(ReadText(1001, 4204), GetComponentData(container, "name"))
	elseif poststring == "defence" then
		local blackboard_attackenemies = GetNPCBlackboard(entity, "$config_attackenemies")
		blackboard_attackenemies = blackboard_attackenemies and blackboard_attackenemies ~= 0
		if blackboard_attackenemies then
			aicommand = ReadText(1001, 4214)
		else
			aicommand = ReadText(1001, 4213)
		end
	else
		aicommand = string.format(aicommand, IsComponentClass(aicommandparam, "component") and GetComponentData(aicommandparam, "name") or nil)
	end

	return aicommand
end

function Helper.comparePositions(pos1, pos2, deviation)
	local diff = { x = pos1[1] - pos2[1], y = pos1[2] - pos2[2] }
	local lengthsq = diff.x * diff.x + diff.y * diff.y

	return lengthsq > (deviation * deviation)
end

function Helper.convertColorToText(color)
	return string.format("\027#%02x%02x%02x%02x#", math.floor(color.a * 255 / 100 + 0.5), color.r, color.g, color.b)
end

function Helper.formatOptionalShortcut(format, inputtype, inputid, fallback)
	local inputname = GetLocalizedKeyName(inputtype, inputid)
	if inputname ~= "" then
		return string.format(format, inputname)
	end
	-- input is not mapped, return fallback or empty string
	return fallback or ""
end

-- skill: 0-15
function Helper.displaySkill(skill, usebold, noemptystars)
	local result = ""

	local bold = ""
	if usebold then
		bold = "_bold"
	end

	local int, frac = math.modf(skill / 3)

	-- full stars
	result = result .. string.rep("\27[menu_star_04" .. bold .. "]", int)
	if frac > 0.66 then
		-- 2/3 star
		result = result .. "\27[menu_star_03" .. bold .. "]"
	elseif frac > 0.33 then
		-- 1/3 star
		result = result .. "\27[menu_star_02" .. bold .. "]"
	elseif 5 - int > 0 then
		-- empty star
		if not noemptystars then
			result = result .. "\27[menu_star_01" .. bold .. "]"
		end
	end
	-- empty stars
	if not noemptystars then
		if 5 - int - 1 > 0 then
			result = result .. string.rep("\27[menu_star_01" .. bold .. "]", 5 - int - 1)
		end
	end

	return result
end

function Helper.displayStars(progress, total, usebold, noemptystars)
	local result = ""

	local bold = ""
	if usebold then
		bold = "_bold"
	end

	-- full stars
	result = result .. string.rep("\27[menu_star_04" .. bold .. "]", progress)
	-- empty stars
	if not noemptystars then
		if total - progress > 0 then
			result = result .. string.rep("\27[menu_star_01" .. bold .. "]", total - progress)
		end
	end

	return result
end

-- keeping it simple, no metatables, using __pairs method
function Helper.tableCopy(orig, levels)
	if levels == nil then
		levels = 2
	end

	local result
	if (levels > 0) and (type(orig) == "table") then
		result = {}
		for k, v in pairs(orig) do
			result[k] = Helper.tableCopy(orig[k], levels - 1)
		end
	else
		result = orig
	end
	return result
end

function Helper.tableLength(value)
	local count = 0
	for _ in pairs(value) do
		count = count + 1
	end
	return count
end

-- DO NOT USE with string datatypes
function Helper.ffiVLA(result, vlaType, vlaSizeFunction, vlaFunction, ...)
	local n = vlaSizeFunction(...)
	if n > 0 then
		local buf = ffi.new(vlaType .. "[?]", n)
		n = vlaFunction(buf, n, ...)

		for i = 0, n - 1 do
			table.insert(result, buf[i])
		end
	end
end

Helper.ffiTempStorage = { }

-- Keep a lua reference for every variable created by ffi.new() - otherwise it may be gc'd too early
function Helper.ffiNewHelper(...)
	local result = ffi.new(...)
	table.insert(Helper.ffiTempStorage, result)
	return result
end

function Helper.ffiNewString(string)
	return Helper.ffiNewHelper("const char[?]", #string + 1, string)
end

function Helper.ffiClearNewHelper()
	Helper.ffiTempStorage = {}
end

function Helper.textArrayHelper(texts, func, keyword)
	local textArray
	if #texts > 0 then
		textArray = ffi.new("const char*[?]", #texts)
		for i, entry in ipairs(texts) do
			local text = entry
			if keyword then
				text = entry[keyword]
			end
			textArray[i - 1] = Helper.ffiNewString(text)
		end
	end

	local result = func(#texts, textArray)
	Helper.ffiClearNewHelper()
	return result
end

-- Result can be used as Color argument in FFI function calls
function Helper.ffiColor(color)
	return { red = color.r, green = color.g, blue = color.b, alpha = color.a }
end

---------------------------------------------------------------------------------
-- Loadouts
---------------------------------------------------------------------------------

Helper.upgradetypes = { 
	{ supertype = "macro",			type = "engine",			category = "engines",			mergeslots = true,	allowempty = false,	emode = "Equipment",								pseudogroup = true, 
		text =			{ small = ReadText(1001, 8087),	medium = ReadText(1001, 8088),	large = ReadText(1001, 8089),	extralarge = ReadText(1001, 8090) },
		shorttext =		{ small = ReadText(1001, 51),	medium = ReadText(1001, 50),	large = ReadText(1001, 49),		extralarge = ReadText(1001, 48) },
	},
	{ supertype = "group",			type = "enginegroup",		category = "engines",			mergeslots = true,	allowempty = false,	emode = "Equipment",	grouptype = "engine",		pseudogroup = true, 
		text =			{ default = ReadText(1001, 8071),	small = ReadText(1001, 8504),	medium = ReadText(1001, 8505),	large = ReadText(1001, 8506),	extralarge = ReadText(1001, 8507) },
		shorttext =		{ default = "",						small = ReadText(1001, 51),		medium = ReadText(1001, 50),	large = ReadText(1001, 49),		extralarge = ReadText(1001, 48) },
		headertext =	{ default = ReadText(1001, 1103),	small = ReadText(1001, 8087),	medium = ReadText(1001, 8088),	large = ReadText(1001, 8089),	extralarge = ReadText(1001, 8090) },
		nonetext =		{ default = ReadText(1001, 8565) },
	},
	{ supertype = "virtualmacro",	type = "thruster",			category = "thrusters",			mergeslots = true,	allowempty = false,	emode = "Equipment", 
		text =			{ small = ReadText(1001, 8091),	medium = ReadText(1001, 8092),	large = ReadText(1001, 8093),	extralarge = ReadText(1001, 8094) },
		shorttext =		{ small = ReadText(1001, 51),	medium = ReadText(1001, 50),	large = ReadText(1001, 49),		extralarge = ReadText(1001, 48) },
	},
	{ supertype = "macro",			type = "shield",			category = "shields",			mergeslots = false,	allowempty = true,	emode = "Equipment", 
		text =			{ default = ReadText(1001, 1317),	small = ReadText(1001, 8083),	medium = ReadText(1001, 8084),	large = ReadText(1001, 8085),	extralarge = ReadText(1001, 8086) },
		shorttext =		{ default = "",						small = ReadText(1001, 51),		medium = ReadText(1001, 50),	large = ReadText(1001, 49),		extralarge = ReadText(1001, 48) },
	},
	{ supertype = "macro",			type = "weapon",			category = "weapons",			mergeslots = false,	allowempty = true,	emode = "Weapons", 
		text =			{ small = ReadText(1001, 8075),	medium = ReadText(1001, 8076),	large = ReadText(1001, 8077),	extralarge = ReadText(1001, 8078) },
		shorttext =		{ small = ReadText(1001, 51),	medium = ReadText(1001, 50),	large = ReadText(1001, 49),		extralarge = ReadText(1001, 48) },
	}, 
	{ supertype = "macro",			type = "turret",			category = "turrets",			mergeslots = false,	allowempty = true,	emode = "Weapons", 
		text =			{ small = ReadText(1001, 8079),	medium = ReadText(1001, 8080),	large = ReadText(1001, 8081),	extralarge = ReadText(1001, 8082) },
		shorttext =		{ small = ReadText(1001, 51),	medium = ReadText(1001, 50),	large = ReadText(1001, 49),		extralarge = ReadText(1001, 48) },
	}, 
	{ supertype = "group",			type = "turretgroup",		category = "turretgroups",		mergeslots = false,	allowempty = true,	emode = "Weapons",		grouptype = "turret",		pseudogroup = false, 
		text =			{ default = ReadText(1001, 8070),	small = ReadText(1001, 8095),	medium = ReadText(1001, 8096),	large = ReadText(1001, 8097),	extralarge = ReadText(1001, 8098) },
		shorttext =		{ default = "", 					small = ReadText(1001, 51),		medium = ReadText(1001, 50),	large = ReadText(1001, 49),		extralarge = ReadText(1001, 48) },
		headertext =	{ default = ReadText(1001, 1319),	small = ReadText(1001, 8079),	medium = ReadText(1001, 8080),	large = ReadText(1001, 8081),	extralarge = ReadText(1001, 8082) },
		nonetext =		{ default = ReadText(1001, 8564) },
	},
	{ supertype = "group",			type = "shieldgroup",		category = "shieldgroups",		mergeslots = false,	allowempty = true,	emode = "Equipment",	grouptype = "shield",		pseudogroup = false, 
		text =			{ default = ReadText(1001, 8072),	small = ReadText(1001, 8099),	medium = ReadText(1001, 8501),	large = ReadText(1001, 8502),	extralarge = ReadText(1001, 8503) },
		shorttext =		{ default = "",						small = ReadText(1001, 51),		medium = ReadText(1001, 50),	large = ReadText(1001, 49),		extralarge = ReadText(1001, 48) },
		headertext =	{ default = ReadText(1001, 1317),	small = ReadText(1001, 8083),	medium = ReadText(1001, 8084),	large = ReadText(1001, 8085),	extralarge = ReadText(1001, 8086) },
		nonetext =		{ default = ReadText(1001, 8566) },
	},
	{ supertype = "ammo",			type = "missile",			category = "missiles",			mergeslots = false,	allowempty = true,	emode = "Weapons",		exclude = {} },
	{ supertype = "ammo",			type = "drone",				category = "drones",			mergeslots = false,	allowempty = true,	emode = "Ships",		exclude = { "marine", "police" } },
	{ supertype = "ammo",			type = "deployable",		category = "deployables",		mergeslots = false,	allowempty = true,	emode = "Equipment",	exclude = {} },
	{ supertype = "ammo",			type = "countermeasure",	category = "countermeasures",	mergeslots = false,	allowempty = true,	exclude = {} },
	{ supertype = "software",		type = "software",			category = "software",			mergeslots = false,	allowempty = true,	emode = "Equipment" },
	{ supertype = "crew",			type = "crew",				category = "crew",				mergeslots = false,	allowempty = true },
}

function Helper.findUpgradeType(type)
	for _, upgradetype in ipairs(Helper.upgradetypes) do
		if upgradetype.type == type then
			return upgradetype
		end
	end
end

function Helper.findUpgradeTypeByGroupType(grouptype)
	for _, upgradetype in ipairs(Helper.upgradetypes) do
		if upgradetype.grouptype == grouptype then
			return upgradetype
		end
	end
end

function Helper.getSlotSizeText(slotsize)
	if slotsize == "extralarge" then
		return ReadText(1001, 48)
	elseif slotsize == "large" then
		return ReadText(1001, 49)
	elseif slotsize == "medium" then
		return ReadText(1001, 50)
	elseif slotsize == "small" then
		return ReadText(1001, 51)
	end

	return ""
end

function Helper.getClassText(class)
	if class == "ship_xl" then
		return ReadText(1001, 48)
	elseif class == "ship_l" then
		return ReadText(1001, 49)
	elseif class == "ship_m" then
		return ReadText(1001, 50)
	elseif class == "ship_s" then
		return ReadText(1001, 51)
	elseif class == "ship_xs" then
		return ReadText(1001, 52)
	end

	return ""
end

function Helper.getLoadoutHelper(getLoadout, getLoadoutCounts, ...)
	return Helper.getLoadoutHelper2(getLoadout, getLoadoutCounts, nil, ...)
end

function Helper.getLoadoutHelper2(getLoadout, getLoadoutCounts, loadoutType, ...)
	if loadoutType == nil then
		loadoutType = "UILoadout"
	end
	local countsType = "UILoadoutCounts"
	local macroDataType = "UILoadoutMacroData"
	local groupDataType = "UILoadoutGroupData"
	if loadoutType == "UILoadout2" then
		countsType = "UILoadoutCounts2"
		macroDataType = "UILoadoutMacroData2"
		groupDataType = "UILoadoutGroupData2"
	end

	local loadout = ffi.new(loadoutType)
	local counts = ffi.new(countsType)
	local n = getLoadoutCounts(counts, ...)
	for _, upgradetype in ipairs(Helper.upgradetypes) do
		if upgradetype.supertype == "macro" then
			local cat = upgradetype.category
			loadout["num" .. cat] = counts["num" .. cat]
			loadout[cat] = Helper.ffiNewHelper(macroDataType .. "[?]", counts["num" .. cat])
		elseif upgradetype.supertype == "group" then
			if not upgradetype.pseudogroup then
				local cat = upgradetype.category
				loadout["num" .. cat] = counts["num" .. cat]
				loadout[cat] = Helper.ffiNewHelper(groupDataType .. "[?]", counts["num" .. cat])
			end
		elseif upgradetype.supertype == "ammo" then
			if upgradetype.type == "missile" or upgradetype.type == "deployable" or upgradetype.type == "countermeasure" then
				loadout.numammo = counts.numammo
				loadout.ammo = Helper.ffiNewHelper("UILoadoutAmmoData[?]", counts.numammo)
			elseif upgradetype.type == "drone" then
				loadout.numunits = counts.numunits
				loadout.units = Helper.ffiNewHelper("UILoadoutAmmoData[?]", counts.numunits)
			end
		elseif upgradetype.supertype == "software" then
			local cat = upgradetype.category
			loadout["num" .. cat] = counts["num" .. cat]
			loadout[cat] = Helper.ffiNewHelper("UILoadoutSoftwareData[?]", counts["num" .. cat])
		elseif upgradetype.supertype == "virtualmacro" then
			if upgradetype.type == "thruster" then
				loadout.thruster = Helper.ffiNewHelper("UILoadoutVirtualMacroData")
				loadout.thruster.macro = ""
			end
		elseif upgradetype.supertype == "crew" then
			if loadoutType == "UILoadout2" then
				local cat = upgradetype.category
				loadout["num" .. cat] = counts["num" .. cat]
				loadout[cat] = Helper.ffiNewHelper("UILoadoutCrewData[?]", counts["num" .. cat])
			end
		end
	end
	getLoadout(loadout, ...)

	return loadout
end

function Helper.convertLoadout(object, macro, loadout, softwaredata, loadoutType)
	if loadoutType == nil then
		loadoutType = "UILoadout"
	end

	local upgradeplan = {}

	local groups = {}
	local groupdata = {}
	for _, upgradetype in ipairs(Helper.upgradetypes) do
		upgradeplan[upgradetype.type] = {}
		if upgradetype.supertype == "macro" then
			local cat = upgradetype.category
			for i = 0, loadout["num" .. cat] - 1 do
				local slot = tonumber(loadout[cat][i].slot) + 1
				local macro = ffi.string(loadout[cat][i].macro)
				if loadoutType == "UILoadout2" then
					local ammomacro = ffi.string(loadout[cat][i].weaponsetting.ammomacroname)
					local weaponmode = ffi.string(loadout[cat][i].weaponsetting.weaponmode)
					upgradeplan[upgradetype.type][slot] = { macro = macro, ammomacro = ammomacro, weaponmode = weaponmode }
				else
					upgradeplan[upgradetype.type][slot] = macro
				end
			end
		elseif upgradetype.supertype == "group" then
			-- just generate group data here and put it in the plan later
			if not upgradetype.pseudogroup then
				local cat = upgradetype.category
				groupdata[upgradetype.type] = {}
				for i = 0, loadout["num" .. cat] - 1 do
					groups[ffi.string(loadout[cat][i].group)] = { path = ffi.string(loadout[cat][i].path), group = ffi.string(loadout[cat][i].group) }
					local ammomacro, weaponmode
					if loadoutType == "UILoadout2" then
						ammomacro = ffi.string(loadout[cat][i].weaponsetting.ammomacroname)
						weaponmode = ffi.string(loadout[cat][i].weaponsetting.weaponmode)
					end
					table.insert(groupdata[upgradetype.type], { macro = ffi.string(loadout[cat][i].macro), count = loadout[cat][i].count, path = ffi.string(loadout[cat][i].path), group = ffi.string(loadout[cat][i].group), ammomacro = ammomacro, weaponmode = weaponmode })
				end
			end
		elseif upgradetype.supertype == "ammo" then
			if upgradetype.type == "missile" or upgradetype.type == "deployable" or upgradetype.type == "countermeasure" then
				for i = 0, loadout.numammo - 1 do
					local macro = ffi.string(loadout.ammo[i].macro)
					local amount = tonumber(loadout.ammo[i].amount)
					upgradeplan[upgradetype.type][macro] = amount
				end
			elseif upgradetype.type == "drone" then
				for i = 0, loadout.numunits - 1 do
					local macro = ffi.string(loadout.units[i].macro)
					local amount = tonumber(loadout.units[i].amount)
					upgradeplan[upgradetype.type][macro] = amount
				end
			end
		elseif upgradetype.supertype == "software" then
			local cat = upgradetype.category
			if (loadout["num" .. cat] > 0) and (softwaredata ~= nil) then
				for i = 0, loadout["num" .. cat] - 1 do
					local ware = ffi.string(loadout[cat][i].ware)
					local maxware = ffi.string(C.GetSoftwareMaxCompatibleVersion(object, macro, ware))
					for i, entry in ipairs(softwaredata[upgradetype.type]) do
						if entry.maxsoftware == maxware then
							upgradeplan[upgradetype.type][i] = ware
							break
						end
					end
				end
			elseif (loadout["num" .. cat] > 0) then
				DebugError("Converting a loadout containing software information with invalid software data in the menu. [Florian]")
			end
		elseif upgradetype.supertype == "virtualmacro" then
			if upgradetype.type == "thruster" then
				if loadoutType == "UILoadout2" then
					upgradeplan[upgradetype.type][1] = { macro = ffi.string(loadout.thruster.macro) }
				else
					upgradeplan[upgradetype.type][1] = ffi.string(loadout.thruster.macro)
				end
			end
		elseif upgradetype.supertype == "crew" then
			if loadoutType == "UILoadout2" then
				local cat = upgradetype.category
				if loadout["num" .. cat] > 0 then
					for i = 0, loadout["num" .. cat] - 1 do
						local role = ffi.string(loadout[cat][i].roleid)
						local count = loadout[cat][i].count
						upgradeplan[upgradetype.type][role] = count
					end
				end
			end
		end
	end

	-- crew experience
	if loadoutType == "UILoadout2" then
		upgradeplan.hascrewexperience = loadout.hascrewexperience
	end

	-- put group data into the plan
	local i = 1
	for group, groupinfo in pairs(groups) do
		for _, upgradetype in ipairs(Helper.upgradetypes) do
			if (upgradetype.supertype == "group") and (not upgradetype.pseudogroup) then
				local found = false
				for _, data in ipairs(groupdata[upgradetype.type]) do
					if data.group == group then
						upgradeplan[upgradetype.type][i] = data
						found = true
						break
					end
				end
				if not found then
					upgradeplan[upgradetype.type][i] = { macro = "", count = 0, path = groupinfo.path, group = groupinfo.group }
				end
			end
		end
		i = i + 1
	end

	-- handle pseudogroups
	for _, upgradetype in ipairs(Helper.upgradetypes) do
		if (upgradetype.supertype == "group") and upgradetype.pseudogroup then
			local i = 1
			for slot, slotdata in pairs(upgradeplan[upgradetype.grouptype]) do
				local slotmacro = slotdata
				if loadoutType == "UILoadout2" then
					slotmacro = slotdata.macro
				end
				local groupinfo = C.GetUpgradeSlotGroup(object, macro, upgradetype.grouptype, slot)
				local path = ffi.string(groupinfo.path)
				local group = ffi.string(groupinfo.group)
				if (path ~= "..") or (group ~= "") then
					if upgradetype.mergeslots then
						upgradeplan[upgradetype.type][i] = { macro = slotmacro, count = #upgradeplan[upgradetype.grouptype], path = path, group = group }
						break
					else
						local found = false
						for j, groupdata in ipairs(upgradeplan[upgradetype.type]) do
							if (groupdata.path == path) and (groupdata.group == group) then
								found = true
								upgradeplan[upgradetype.type][j].count = upgradeplan[upgradetype.type][j].count + 1
								break
							end
						end
						if not found then
							upgradeplan[upgradetype.type][i] = { macro = slotmacro, count = 1, path = path, group = group }
							i = i + 1
						end
					end
				end
			end
		end
	end

	return upgradeplan
end

function Helper.callLoadoutFunction(upgradeplan, crewplan, func, clear, loadoutType)
	if loadoutType == nil then
		loadoutType = "UILoadout"
	end
	local macroDataType = "UILoadoutMacroData"
	local groupDataType = "UILoadoutGroupData"
	if loadoutType == "UILoadout2" then
		macroDataType = "UILoadoutMacroData2"
		groupDataType = "UILoadoutGroupData2"
	end

	local loadout = ffi.new(loadoutType)

	local ammocount = 0
	local unitcount = 0

	for plantype, slots in pairs(upgradeplan) do
		local upgradetype = Helper.findUpgradeType(plantype)
		if upgradetype then
			if upgradetype.supertype == "macro" then
				local cat = upgradetype.category

				local count = 0
				if next(slots) then
					if type(slots[next(slots)]) == "table" then
						for slot, data in pairs(slots) do
							if data.macro ~= "" then
								count = count + 1
							end
						end
					else
						for slot, macro in pairs(slots) do
							if macro ~= "" then
								count = count + 1
							end
						end
					end
				end

				loadout["num" .. cat] = count
				loadout[cat] = Helper.ffiNewHelper(macroDataType .. "[?]", count)

				if next(slots) then
					local i = 0
					if type(slots[next(slots)]) == "table" then
						for slot, data in pairs(slots) do
							if data.macro ~= "" then
								loadout[cat][i].macro = Helper.ffiNewString(data.macro)
								loadout[cat][i].upgradetypename = Helper.ffiNewString(plantype)
								loadout[cat][i].slot = slot - 1
								loadout[cat][i].optional = false
								if loadoutType == "UILoadout2" then
									loadout[cat][i].weaponsetting.ammomacroname = Helper.ffiNewString(data.ammomacro)
									loadout[cat][i].weaponsetting.weaponmode = Helper.ffiNewString(data.weaponmode)
								end
								i = i + 1
							end
						end
					else
						for slot, macro in pairs(slots) do
							if macro ~= "" then
								loadout[cat][i].macro = Helper.ffiNewString(macro)
								loadout[cat][i].upgradetypename = Helper.ffiNewString(plantype)
								loadout[cat][i].slot = slot - 1
								loadout[cat][i].optional = false
								i = i + 1
							end
						end
					end
				end
			elseif upgradetype.supertype == "group" then
				if not upgradetype.pseudogroup then
					local cat = upgradetype.category

					local count = 0
					for slot, data in pairs(slots) do
						if data.macro ~= "" then
							count = count + 1
						end
					end

					loadout["num" .. cat] = count
					loadout[cat] = Helper.ffiNewHelper(groupDataType .. "[?]", count)

					if next(slots) then
						local i = 0
						for slot, data in pairs(slots) do
							if data.macro ~= "" then
								loadout[cat][i].macro = Helper.ffiNewString(data.macro)
								loadout[cat][i].path = Helper.ffiNewString(data.path)
								loadout[cat][i].group = Helper.ffiNewString(data.group)
								loadout[cat][i].count = data.count
								loadout[cat][i].optional = false
								if loadoutType == "UILoadout2" then
									loadout[cat][i].weaponsetting.ammomacroname = Helper.ffiNewString(data.ammomacro)
									loadout[cat][i].weaponsetting.weaponmode = Helper.ffiNewString(data.weaponmode)
								end
								i = i + 1
							end
						end
					end
				end
			elseif upgradetype.supertype == "ammo" then
				if upgradetype.type == "missile" or upgradetype.type == "deployable" or upgradetype.type == "countermeasure" then
					for macro, amount in pairs(slots) do
						if amount > 0 then
							ammocount = ammocount + 1
						end
					end
				elseif upgradetype.type == "drone" then
					for macro, amount in pairs(slots) do
						if amount > 0 then
							unitcount = unitcount + 1
						end
					end
				end
			elseif upgradetype.supertype == "software" then
				local cat = upgradetype.category

				local count = 0
				for slot, ware in pairs(slots) do
					if ware ~= "" then
						count = count + 1
					end
				end

				loadout["num" .. cat] = count
				loadout[cat] = Helper.ffiNewHelper("UILoadoutSoftwareData[?]", count)

				if next(slots) then
					local i = 0
					for slot, ware in pairs(slots) do
						if ware ~= "" then
							loadout[cat][i].ware = Helper.ffiNewString(ware)
							i = i + 1
						end
					end
				end
			elseif upgradetype.supertype == "virtualmacro" then
				if upgradetype.type == "thruster" then
					if slots[1] then
						if type(slots[1]) == "table" then
							loadout.thruster = Helper.ffiNewHelper("UILoadoutVirtualMacroData")
							loadout.thruster.macro = Helper.ffiNewString(slots[1].macro)
							loadout.thruster.optional = false
						else
							loadout.thruster = Helper.ffiNewHelper("UILoadoutVirtualMacroData")
							loadout.thruster.macro = Helper.ffiNewString(slots[1])
							loadout.thruster.optional = false
						end
					end
				end
			elseif upgradetype.supertype == "crew" then
				if loadoutType == "UILoadout2" then
					local cat = upgradetype.category

					local count = 0
					for slot, ware in pairs(slots) do
						if ware ~= "" then
							count = count + 1
						end
					end

					loadout["num" .. cat] = count
					loadout[cat] = Helper.ffiNewHelper("UILoadoutCrewData[?]", count)

					if next(slots) then
						local i = 0
						for role, count in pairs(slots) do
							if role ~= "" then
								loadout[cat][i].roleid = Helper.ffiNewString(role)
								loadout[cat][i].count = count
								loadout[cat][i].optional = false
								i = i + 1
							end
						end
					end
				end
			end
		end
	end

	loadout.numammo = ammocount
	loadout.ammo = Helper.ffiNewHelper("UILoadoutAmmoData[?]", ammocount)

	local i = 0
	for plantype, slots in pairs(upgradeplan) do
		local upgradetype = Helper.findUpgradeType(plantype)
		if upgradetype and upgradetype.supertype == "ammo" then
			if upgradetype.type == "missile" or upgradetype.type == "deployable" or upgradetype.type == "countermeasure" then
				for macro, amount in pairs(slots) do
					if amount > 0 then
						loadout.ammo[i].macro = Helper.ffiNewString(macro)
						loadout.ammo[i].amount = amount
						loadout.ammo[i].optional = false
						i = i + 1
					end
				end
			end
		end
	end

	loadout.numunits = unitcount
	loadout.units = Helper.ffiNewHelper("UILoadoutAmmoData[?]", unitcount)

	local i = 0
	for plantype, slots in pairs(upgradeplan) do
		local upgradetype = Helper.findUpgradeType(plantype)
		if upgradetype and upgradetype.supertype == "ammo" then
			if upgradetype.type == "drone" then
				for macro, amount in pairs(slots) do
					if amount > 0 then
						loadout.units[i].macro = Helper.ffiNewString(macro)
						loadout.units[i].amount = amount
						loadout.units[i].optional = false
						i = i + 1
					end
				end
			end
		end
	end

	-- crew experience
	if loadoutType == "UILoadout2" then
		loadout.hascrewexperience = upgradeplan.hascrewexperience == true
	end

	local crewtransfer = ffi.new("CrewTransferInfo2")
	if crewplan then
		-- added
		crewtransfer.numadded = #crewplan.hireddetails
		crewtransfer.added = Helper.ffiNewHelper("CrewTransferContainer2[?]", #crewplan.hireddetails)
		for i, entry in pairs(crewplan.hireddetails) do
			crewtransfer.added[i - 1].newroleid = Helper.ffiNewString(entry.newrole)
			crewtransfer.added[i - 1].amount = entry.amount
			crewtransfer.added[i - 1].price = entry.price
		end
		-- removed
		crewtransfer.numremoved = #crewplan.fired
		crewtransfer.removed = Helper.ffiNewHelper("CrewTransferContainer2[?]", #crewplan.fired)
		for i, entry in pairs(crewplan.fired) do
			crewtransfer.removed[i - 1].seed = entry.npc
			crewtransfer.removed[i - 1].price = entry.price
		end
		-- transferred
		crewtransfer.numtransferred = #crewplan.transferdetails
		crewtransfer.transferred = Helper.ffiNewHelper("CrewTransferContainer2[?]", #crewplan.transferdetails)
		for i, entry in pairs(crewplan.transferdetails) do
			crewtransfer.transferred[i - 1].newroleid = Helper.ffiNewString(entry.newrole)
			crewtransfer.transferred[i - 1].seed = entry.npc
			crewtransfer.transferred[i - 1].price = entry.price
		end
	end

	local result = func(loadout, crewtransfer)
	if clear ~= false then
		Helper.ffiClearNewHelper()
	end
	return result
end

function Helper.convertLoadoutStats(stats)
	local result = {}
	result.HullValue = stats.HullValue
	result.ShieldValue = stats.ShieldValue
	result.ShieldRate = stats.ShieldRate
	result.ShieldDelay = stats.ShieldDelay
	result.GroupedShieldValue = stats.GroupedShieldValue
	result.GroupedShieldRate = stats.GroupedShieldRate
	result.GroupedShieldDelay = stats.GroupedShieldDelay
	result.BurstDPS = stats.BurstDPS
	result.SustainedDPS = stats.SustainedDPS
	result.TurretBurstDPS = stats.TurretBurstDPS
	result.TurretSustainedDPS = stats.TurretSustainedDPS
	result.GroupedTurretBurstDPS = stats.GroupedTurretBurstDPS
	result.GroupedTurretSustainedDPS = stats.GroupedTurretSustainedDPS
	result.ForwardSpeed = stats.ForwardSpeed
	result.BoostSpeed = stats.BoostSpeed
	result.TravelSpeed = stats.TravelSpeed
	result.YawSpeed = stats.YawSpeed * 180 / math.pi				-- rad -> deg conversion
	result.PitchSpeed = stats.PitchSpeed * 180 / math.pi			-- rad -> deg conversion
	result.RollSpeed = stats.RollSpeed * 180 / math.pi				-- rad -> deg conversion
	result.HorizontalStrafeSpeed = stats.HorizontalStrafeSpeed
	result.VerticalStrafeSpeed = stats.VerticalStrafeSpeed
	result.ForwardAcceleration = stats.ForwardAcceleration
	result.HorizontalStrafeAcceleration = stats.HorizontalStrafeAcceleration
	result.VerticalStrafeAcceleration = stats.VerticalStrafeAcceleration
	result.NumDocksShipMedium = stats.NumDocksShipMedium
	result.NumDocksShipSmall = stats.NumDocksShipSmall
	result.ShipCapacityMedium = stats.ShipCapacityMedium
	result.ShipCapacitySmall = stats.ShipCapacitySmall
	result.CrewCapacity = stats.CrewCapacity
	result.ContainerCapacity = stats.ContainerCapacity
	result.SolidCapacity = stats.SolidCapacity
	result.LiquidCapacity = stats.LiquidCapacity
	result.CondensateCapacity = stats.CondensateCapacity
	result.UnitCapacity = stats.UnitCapacity
	result.MissileCapacity = stats.MissileCapacity
	result.CountermeasureCapacity = stats.CountermeasureCapacity
	result.DeployableCapacity = stats.DeployableCapacity
	result.RadarRange = stats.RadarRange / 1000						-- m -> km conversíon

	return result
end

function Helper.modPropertyEvalFloat(basevalue, value)
	return string.format("%+.2f%%", (value - basevalue) * 100)
end

function Helper.modPropertyEvalUINT(basevalue, value)
	return string.format("%+d", value - basevalue)
end

function Helper.modPropertyEval2Float(basevalue, value, color, value2, color2)
	local colorstring  = Helper.convertColorToText(color)
	local colorstring2 = Helper.convertColorToText(color2)
	return string.format(ReadText(1001, 8041), colorstring, (value - basevalue) * 100, colorstring2, (value2 - basevalue) * 100)
end

function Helper.modPropertyEval2UINT(basevalue, value, color, value2, color2)
	local colorstring  = Helper.convertColorToText(color)
	local colorstring2 = Helper.convertColorToText(color2)
	return string.format(ReadText(1001, 8042), colorstring, value - basevalue, colorstring2, value2 - basevalue)
end

Helper.modProperties = {
	["engine"] = {},
	["shield"] = {},
	["ship"]   = {},
	["weapon"] = {},
}

for class, entries in pairs(Helper.modProperties) do
	local n = C.GetNumAllEquipmentModProperties(class)
	local buf = ffi.new("EquipmentModPropertyInfo[?]", n)
	n = C.GetAllEquipmentModProperties(buf, n, class)
	for i = 0, n - 1 do
		local entry = {
			key = ffi.string(buf[i].id),
			text = ffi.string(buf[i].name),
			pos_effect = buf[i].poseffect,
			basevalue = buf[i].basevalue,
			type = ffi.string(buf[i].propdatatype),
		}
		if entry.type == "Float" then
			entry.eval  = function (...) return Helper.modPropertyEvalFloat(entry.basevalue, ...) end
			entry.eval2 = function (...) return Helper.modPropertyEval2Float(entry.basevalue, ...) end
		elseif entry.type == "UINT" then
			entry.eval  = function (...) return Helper.modPropertyEvalUINT(entry.basevalue, ...) end
			entry.eval2 = function (...) return Helper.modPropertyEval2UINT(entry.basevalue, ...) end
		end
		table.insert(entries, entry)
	end
end

Helper.modQualities = {
	[1] = { name = ReadText(20110, 1001), nonetext = ReadText(1001, 8576), paintname = ReadText(1001, 8580), paintnonetext = ReadText(1001, 8511), icon = "mods_grade_circle_01", icon2 = "mods_grade_01", category = "basic",		color = Color["equipmentmod_quality_basic"], price =  50000 },
	[2] = { name = ReadText(20110, 1101), nonetext = ReadText(1001, 8577), paintname = ReadText(1001, 8581), paintnonetext = ReadText(1001, 8512), icon = "mods_grade_circle_02", icon2 = "mods_grade_02", category = "advanced",		color = Color["equipmentmod_quality_advanced"], price = 100000 },
	[3] = { name = ReadText(20110, 1201), nonetext = ReadText(1001, 8578), paintname = ReadText(1001, 8582), paintnonetext = ReadText(1001, 8513), icon = "mods_grade_circle_03", icon2 = "mods_grade_03", category = "exceptional",	color = Color["equipmentmod_quality_exceptional"], price = 250000 },
}

function Helper.getInstalledModInfo(type, component, context, group, isgroup)
	local installedmod = {}
	local hasinstalledmod = false
	local buf
	local modtype
	if type == "engine" then
		buf = ffi.new("UIEngineMod")
		hasinstalledmod = C.GetInstalledEngineMod(component, buf)
	elseif type == "shield" then
		buf = ffi.new("UIShieldMod")
		hasinstalledmod = C.GetInstalledShieldMod(component, context, group, buf)
	elseif (type == "turret") and isgroup then
		buf = ffi.new("UIWeaponMod")
		hasinstalledmod = C.GetInstalledGroupedWeaponMod(component, context, group, buf)
		modtype = "weapon"
	elseif type == "ship" then
		buf = ffi.new("UIShipMod2")
		hasinstalledmod = C.GetInstalledShipMod2(component, buf)
	elseif (type == "weapon") or (type == "turret") then
		buf = ffi.new("UIWeaponMod")
		hasinstalledmod = C.GetInstalledWeaponMod(component, buf)
		modtype = "weapon"
	else
		DebugError("Unknown equipment mod type '" .. type .. "'.")
		return
	end

	if hasinstalledmod then
		installedmod.Name = ffi.string(buf.Name)
		installedmod.RawName = ffi.string(buf.RawName)
		installedmod.Ware = ffi.string(buf.Ware)
		installedmod.PropertyType = ffi.string(buf.PropertyType)

		installedmod.Quality = buf.Quality
		for _, entry in ipairs(Helper.modProperties[modtype or type]) do
			installedmod[entry.key] = buf[entry.key]
		end
	end

	return hasinstalledmod, installedmod
end

Helper.topLevelMenus = {
	{ id = "options",		name = ReadText(1001, 8105),	icon = "tlt_optionsmenu",		shortcut = "INPUT_ACTION_OPTIONSMENU",					menu = "OptionsMenu",		helpOverlayID = "toplevel_options",			helpOverlayText = ReadText(1028, 8101), param = "toplevel", },
	{ id = "terraforming",	name = ReadText(1001, 3800),	icon = "tlt_terraforming",		shortcut = "",											menu = "TerraformingMenu",	helpOverlayID = "toplevel_terraforming",	helpOverlayText = ReadText(1028, 8109), param = {0, 0, "$hqcluster$" },						canterraform = true },
	{ id = "research",		name = ReadText(1001, 8103),	icon = "tlt_research",			shortcut = "",											menu = "ResearchMenu",		helpOverlayID = "toplevel_research",		helpOverlayText = ReadText(1028, 8102), param = {0, 0},										canresearch = true },
	{ id = "playerinfo",	name = ReadText(1001, 8102),	icon = "tlt_playerinfo",		shortcut = "INPUT_ACTION_OPEN_PLAYER_INVENTORY_MENU",	menu = "PlayerInfoMenu",	helpOverlayID = "toplevel_playerinfo",		helpOverlayText = ReadText(1028, 8103), param = {0, 0} },
	{ id = "docked",		name = ReadText(1001, 8106),	icon = "tlt_docked",			shortcut = "INPUT_ACTION_OPEN_COCKPIT_MENU",			menu = "DockedMenu",		helpOverlayID = "toplevel_docked",			helpOverlayText = ReadText(1028, 8104), param = {0, 0},										needsdock = true },
	{ id = "cockpit",		name = ReadText(1001, 8601),	icon = "tlt_shipinteractions",	shortcut = "INPUT_ACTION_OPEN_COCKPIT_MENU",			menu = "DockedMenu",		helpOverlayID = "toplevel_cockpit",			helpOverlayText = ReadText(1028, 8105), param = {0, 0},										needsdock = false },
	{ id = "map",			name = ReadText(1001, 8101),	icon = "tlt_map",				shortcut = "INPUT_ACTION_OPEN_MAP",						menu = "MapMenu",			helpOverlayID = "toplevel_map",				helpOverlayText = ReadText(1028, 8106), param = {0, 0, true} },
	{ id = "multiversemap",	name = ReadText(1001, 11623),	icon = "vt_season",				shortcut = "INPUT_ACTION_OPEN_MULTIVERSE",				menu = "MapMenu",			helpOverlayID = "toplevel_multiversemap",	helpOverlayText = ReadText(1028, 8110), param = {0, 0, true, nil, nil, nil, nil, true},		isonline = true,		istimelinescenario = false },
	{ id = "encyclopedia",	name = ReadText(1001, 8104),	icon = "tlt_encyclopedia",		shortcut = "",											menu = "EncyclopediaMenu",	helpOverlayID = "toplevel_encyclopedia",	helpOverlayText = ReadText(1028, 8107), param = {0, 0} },
	{ id = "help",			name = ReadText(1001, 8701),	icon = "tlt_help",				shortcut = "INPUT_ACTION_HELP",							menu = "HelpMenu",			helpOverlayID = "toplevel_help",			helpOverlayText = ReadText(1028, 8108), param = {0, 0},										demo = false },
}

function Helper.createTopLevelConfig()
	Helper.topLevelConfig = {
		numDisplayedIcons = 5,
		iconSize = Helper.scaleX(Helper.sidebarWidth),
		arrowWidth = Helper.scaleX(10),
		inputSize = Helper.scaleX(100),
		y = Helper.borderSize,
		font = Helper.standardFontOutlined,
		bgColor = Color["toplevel_background_default"],
		scrolling = false,
	}
	Helper.topLevelConfig.numColumns = Helper.topLevelConfig.numDisplayedIcons + 4

	local width = Helper.topLevelConfig.numDisplayedIcons * Helper.topLevelConfig.iconSize + 2 * Helper.topLevelConfig.arrowWidth + 2 * Helper.topLevelConfig.inputSize + (Helper.topLevelConfig.numDisplayedIcons + 3) * Helper.borderSize
	Helper.topLevelConfig.x = Helper.viewWidth / 2 - width / 2
end

function Helper.checkTopLevelConditions(entry)
	local isdocked = false
	local currentplayership = ConvertStringTo64Bit(tostring(C.GetPlayerOccupiedShipID()))
	if currentplayership ~= 0 then
		if GetComponentData(currentplayership, "isdocked") then
			isdocked = true
		end
	else
		local currentcontainer = ConvertStringTo64Bit(tostring(C.GetContextByClass(C.GetPlayerID(), "container", false)))
		if (not C.IsComponentClass(currentcontainer, "ship")) or GetComponentData(currentcontainer, "isdocked") then
			isdocked = true
		end
	end

	if (entry.needsdock ~= nil) and (entry.needsdock ~= isdocked) then
		return false
	end
	if (entry.demo ~= nil) and (entry.demo ~= C.IsDemoVersion()) then
		return false
	end
	if (entry.canresearch ~= nil) and (entry.canresearch ~= C.CanResearch()) then
		return false
	end
	if (entry.canterraform ~= nil) then
		local stationhqlist = {}
		Helper.ffiVLA(stationhqlist, "UniverseID", C.GetNumHQs, C.GetHQs, "player")
		local hq = stationhqlist[1] or 0

		if hq == 0 then
			return not entry.canterraform
		end

		local hqcluster = C.GetContextByClass(hq, "cluster", false)
		return GetComponentData(ConvertStringTo64Bit(tostring(hqcluster)), "hasterraforming") and (C.GetNumTerraformingProjects(hqcluster, false) > 0)
	end
	if (entry.isonline ~= nil) and (entry.isonline ~= (C.AreVenturesCompatible() and (C.IsVentureSeasonSupported() or C.WasSessionOnline()))) then
		return false
	end
	if (entry.istimelinescenario ~= nil) and (entry.istimelinescenario ~= (C.IsTimelinesScenario() or (ffi.string(C.GetGameStartName()) == "x4ep1_gamestart_hub"))) then
		return false
	end

	-- kuertee start: callback
	if callbacks ["checkTopLevelConditions_get_is_entry_available"] then
		local isAvailable = true
		for _, callback in ipairs (callbacks ["checkTopLevelConditions_get_is_entry_available"]) do
			isAvailable = callback (entry)
			if isAvailable ~= true then
				return false
			end
		end
	end
	-- kuertee end: callback

	return true
end

function Helper.getTopLevelMenuIndex(index, offset)
	local iteration = 0
	local newindex = index
	repeat
		if offset > 0 then
			if newindex + 1 > #Helper.topLevelMenus then
				newindex = 1
			else
				newindex = newindex + 1
			end
		elseif offset < 0 then
			if newindex - 1 < 1 then
				newindex = #Helper.topLevelMenus
			else
				newindex = newindex - 1
			end
		end

		local entry = Helper.topLevelMenus[newindex]
		if Helper.checkTopLevelConditions(entry) then
			iteration = iteration + 1
		end

		if iteration >= math.abs(offset) then
			return newindex
		end
	until newindex == index
end

function Helper.addDisplayedMenu(array, index, offset)
	if offset then
		local newindex = Helper.getTopLevelMenuIndex(index, offset)
		if newindex then
			array[3 + offset] = { index = newindex, data = Helper.topLevelMenus[newindex] }
		end
	else
		local entry = Helper.topLevelMenus[index]
		if Helper.checkTopLevelConditions(entry) then
			table.insert(array, { index = index, data = entry })
		end
	end
end

function Helper.createTopLevelTab(menu, id, frame, overrideText, locked, noreturn)
	if C.IsGameOver() then
		return 0, 0
	end
	local currentIndex = 0
	local displayedMenus = {}
	for i, menuEntry in ipairs(Helper.topLevelMenus) do
		if menuEntry.id == id then
			currentIndex = i
			if Helper.topLevelConfig.scrolling then
				Helper.addDisplayedMenu(displayedMenus, i, -2)
				Helper.addDisplayedMenu(displayedMenus, i, -1)
				Helper.addDisplayedMenu(displayedMenus, i,  0)
				Helper.addDisplayedMenu(displayedMenus, i,  1)
				Helper.addDisplayedMenu(displayedMenus, i,  2)
				break
			end
		end
		if not Helper.topLevelConfig.scrolling then
			Helper.addDisplayedMenu(displayedMenus, i)
		end
	end
	if (id ~= "") and (currentIndex == 0) then
		DebugError("Unknown top level menu id '" .. id .. "'.")
		return
	end

	AddUITriggeredEvent("TopLevelTabs", id, "displayed")

	local numDisplayedIcons = Helper.topLevelConfig.numDisplayedIcons
	local numColumns = Helper.topLevelConfig.numColumns
	local countoffset = 2
	local x = Helper.topLevelConfig.x
	local width = 0
	if not Helper.topLevelConfig.scrolling then
		numDisplayedIcons = #displayedMenus
		numColumns = numDisplayedIcons + 2
		countoffset = 1
		width = numDisplayedIcons * Helper.topLevelConfig.iconSize + 2 * Helper.topLevelConfig.inputSize + (numDisplayedIcons + 1) * Helper.borderSize
		x = Helper.viewWidth / 2 - width / 2
	end

	local ftable = frame:addTable(numColumns, { tabOrder = 20, x = x, y = Helper.topLevelConfig.y, scaling = false, reserveScrollBar = false, skipTabChange = true })
	ftable:setColWidth(1, Helper.topLevelConfig.inputSize)
	for i = 1, numDisplayedIcons do
		ftable:setColWidth(i + countoffset, Helper.topLevelConfig.iconSize)
	end
	ftable:setColWidth(numColumns, Helper.topLevelConfig.inputSize)
	ftable:setDefaultBackgroundColSpan(1, numColumns)
	if Helper.topLevelConfig.scrolling then
		ftable:setColWidth(2, Helper.topLevelConfig.arrowWidth)
		ftable:setColWidth(numColumns - 1, Helper.topLevelConfig.arrowWidth)
	end

	-- close button
	local row = ftable:addRow(true, { fixed = true, borderBelow = false, bgColor = Helper.topLevelConfig.bgColor })
	if numColumns % 2 == 0 then
		local col = numColumns / 2
		local colwidth = row[col]:getWidth()
		row[col]:setColSpan(2):createButton({ width = Helper.topLevelConfig.iconSize, height = Helper.topLevelConfig.iconSize - Helper.scaleX(10), bgColor = Color["button_background_hidden"], highlightColor = Color["button_highlight_hidden"], x = colwidth - Helper.topLevelConfig.iconSize / 2 }):setText("\27[tlt_arrow_inv]", { color = Color["toplevel_arrow"], halign = "center", fontsize = Helper.scaleFont(Helper.standardFont, 18), x = 0, y = 2 })
		row[col].handlers.onClick = function () return menu.onCloseElement("close") end
	else
		local col = math.ceil(numColumns / 2)
		row[col]:createButton({ width = Helper.topLevelConfig.iconSize, height = Helper.topLevelConfig.iconSize - Helper.scaleX(10), bgColor = Color["button_background_hidden"], highlightColor = Color["button_highlight_hidden"] }):setText("\27[tlt_arrow_inv]", { color = Color["toplevel_arrow"], halign = "center", fontsize = Helper.scaleFont(Helper.standardFont, 18), x = 0, y = 2 })
		row[col].handlers.onClick = function () return menu.onCloseElement("close") end
	end

	-- icons
	local row = ftable:addRow(true, { fixed = true, borderBelow = false, bgColor = Helper.topLevelConfig.bgColor })
	local name = ffi.string(C.GetMappedInputName("INPUT_ACTION_WIDGET_TABSCROLL_LEFT"))
	if GetControllerInfo() ~= "mouseCursor" then
		row[1]:createText(name, { scaling = true, fontsize = Helper.titleFontSize, y = (Helper.sidebarWidth - Helper.titleHeight) / 2, halign = "right" })
	end
	for i, menuEntry in ipairs(displayedMenus) do
		local color = Color["icon_inactive"]
		if Helper.topLevelConfig.scrolling then
			if i == 3 then
				color = Color["icon_normal"]
			end
		else
			if menuEntry.index == currentIndex then
				color = Color["icon_normal"]
			end
		end
		local shortcut = ffi.string(C.GetMappedInputName(menuEntry.data.shortcut))
		row[i + countoffset]:createButton({ active = not locked, height = Helper.topLevelConfig.iconSize, bgColor = Color["toplevel_button_background"], mouseOverText = menuEntry.data.name .. ((shortcut ~= "") and (" - " .. shortcut) or ""), helpOverlayID = menuEntry.data.helpOverlayID, helpOverlayText = menuEntry.data.helpOverlayText }):setIcon(menuEntry.data.icon, { color = color })
		if Helper.topLevelConfig.scrolling then
			if i ~= 3 then
				row[i + countoffset].handlers.onClick = function() return Helper.scrollTopLevelInternal(menu, currentIndex, i - 3, noreturn) end
			else
				row[i + countoffset].properties.active = true
			end
		else
			if menuEntry.index ~= currentIndex then
				row[i + countoffset].handlers.onClick = function() return Helper.scrollTopLevelInternal(menu, menuEntry.index, nil, noreturn) end
			else
				row[i + countoffset].properties.active = true
			end
		end
	end
	local name = ffi.string(C.GetMappedInputName("INPUT_ACTION_WIDGET_TABSCROLL_RIGHT"))
	if GetControllerInfo() ~= "mouseCursor" then
		row[numColumns]:createText(name, { scaling = true, fontsize = Helper.titleFontSize, y = (Helper.sidebarWidth - Helper.titleHeight) / 2 })
	end
	if Helper.topLevelConfig.scrolling then
		row[2]:createButton({ height = Helper.topLevelConfig.iconSize, bgColor = Color["toplevel_button_background"] }):setIcon("table_arrow_inv_left")
		row[2].handlers.onClick = function() return Helper.scrollTopLevelInternal(menu, currentIndex, -1) end
		row[numColumns - 1]:createButton({ height = Helper.topLevelConfig.iconSize, bgColor = Color["toplevel_button_background"] }):setIcon("table_arrow_inv_right")
		row[numColumns - 1].handlers.onClick = function() return Helper.scrollTopLevelInternal(menu, currentIndex, 1) end
	end

	-- menu name
	local row = ftable:addRow(false, { fixed = true, borderBelow = false, bgColor = Helper.topLevelConfig.bgColor, scaling = true })
	local name = (currentIndex ~= 0) and Helper.topLevelMenus[currentIndex].name or ""
	if overrideText ~= "" then
		name = overrideText
	end
	row[1]:setColSpan(numColumns):createText(name, { halign = "center", x = 0, font = Helper.topLevelConfig.font })

	return ftable:getFullHeight() + ftable.properties.y, width
end

function Helper.scrollTopLevel(menu, id, offset)
	for i, menuEntry in ipairs(Helper.topLevelMenus) do
		if menuEntry.id == id then
			Helper.scrollTopLevelInternal(menu, i, offset, true)
			break
		end
	end
end

function Helper.evaluateTopLevelParamHelper(param)
	if param == "$hqcluster$" then
		local stationhqlist = {}
		Helper.ffiVLA(stationhqlist, "UniverseID", C.GetNumHQs, C.GetHQs, "player")
		local hq = stationhqlist[1] or 0
		if hq ~= 0 then
			param = C.GetContextByClass(hq, "cluster", false)
		end
	end
	return param
end

function Helper.evaluateTopLevelParam(params)
	local locparams
	if type(params) == "table" then
		locparams = {}
		for i, param in pairs(params) do
			locparams[i] = Helper.evaluateTopLevelParamHelper(param)
		end
	else
		locparams = Helper.evaluateTopLevelParamHelper(params)
	end
	return locparams
end

function Helper.scrollTopLevelInternal(menu, index, offset, noreturn)
	if offset then
		local newindex = Helper.getTopLevelMenuIndex(index, offset)
		if newindex then
			local param = Helper.evaluateTopLevelParam(Helper.topLevelMenus[newindex].param)
			Helper.closeMenuAndOpenNewMenu(menu, Helper.topLevelMenus[newindex].menu, param, noreturn)
			menu.cleanup()
		end
	else
		local param = Helper.evaluateTopLevelParam(Helper.topLevelMenus[index].param)
		Helper.closeMenuAndOpenNewMenu(menu, Helper.topLevelMenus[index].menu, param, noreturn)
		menu.cleanup()
	end
end

function Helper.createPlayerInfoConfig()
	Helper.playerInfoConfig = {
		width = math.min(0.3 * Helper.viewWidth, Helper.scaleX(960)),
		height = 3 * (Helper.scaleY(Helper.standardTextHeight) + Helper.borderSize),
		offsetX = Helper.frameBorder,
		offsetY = Helper.frameBorder,
		fontname = Helper.standardFont,
		fontsize = Helper.scaleFont(Helper.standardFont, Helper.standardFontSize),
	}
end

function Helper.playerInfoConfigTextLeft(_, width, ismultiverse)
	local playername = ffi.string(C.GetPlayerName())
	if Helper.isPlayerCovered() then
		playername = ColorText["player_cover"] .. GetFactionData(ffi.string(C.GetPlayerCoverFaction()), "name") .. " (" .. ReadText(1001, 11603) .. ")\27X"
	end

	local connectionStatus = ""
	if C.IsOnlineEnabled() then
		connectionStatus = (Helper.isOnlineGame() and OnlineHasSession()) and (ReadText(1001, 11624) .. " \27[vt_connected]") or (ReadText(1001, 11625) .. " \27[vt_disconnected]")
	end
	local connectedtextwidth = C.GetTextWidth(connectionStatus .. " ", Helper.playerInfoConfig.fontname, Helper.playerInfoConfig.fontsize)
	playername = TruncateText(playername, Helper.playerInfoConfig.fontname, Helper.playerInfoConfig.fontsize, width or Helper.playerInfoConfig.width - Helper.playerInfoConfig.height - 2 * Helper.borderSize - connectedtextwidth)

	if ismultiverse then
		return playername .. "\n" .. ReadText(1001, 11340) .. ReadText(1001, 120) .. "\n" .. ReadText(1001, 11325) .. ReadText(1001, 120)
	else
		local playermoney = ConvertMoneyString(GetPlayerMoney(), false, true, nil, true) .. " " .. ReadText(1001, 101)
		local gametime = Helper.convertGameTimeToXTimeString(C.GetCurrentGameTime()) .. (C.IsSetaActive() and " " .. ColorText["text_positive"] .. "(" .. ReadText(1001, 3255) .. ")\27X" or "")

		return playername .. "\n" .. gametime .. "\n" .. playermoney
	end
end

function Helper.playerInfoConfigTextRight(_, ismultiverse)
	local connectionStatus = ""
	if C.AreVenturesEnabled() then
		if OnlineIsCurrentTeamValid() then
			connectionStatus = (Helper.isOnlineGame() and OnlineHasSession()) and "\27[vt_connected]" or (ColorText["text_warning"] .. "\27[vt_disconnected]\27X")
		else
			connectionStatus = (Helper.isOnlineGame() and OnlineHasSession()) and (ReadText(1001, 11624) .. " \27[vt_connected]") or (ColorText["text_warning"] .. ReadText(1001, 11625) .. " \27[vt_disconnected]\27X")
		end
	end

	if ismultiverse then
		return connectionStatus .. "\n" .. Helper.ventureSeasonTimeLeftText() .. "\n" .. Helper.ventureOperationTimeLeftText()
	else
		local curtime = getElapsedTime()
		local playersector = C.GetContextByClass(C.GetPlayerID(), "sector", false)
		local playerhighway = C.GetContextByClass(C.GetPlayerID(), "highway", false)
		if (playersector == 0) and (playerhighway ~= 0) then
			-- super-highway case, show destination sector
			playersector = ConvertIDTo64Bit(GetComponentData(ConvertStringTo64Bit(tostring(playerhighway)), "destinationsector"))
		end
		-- expensive, only check every 5 seconds
		if (not Helper.playerInfoConfigTimer) or (Helper.playerInfoConfigTimer < curtime) then
			Helper.playerInfoConfigTimer = curtime + 5
			local trademoneydue = tonumber(C.GetCreditsDueFromPlayerTrades())
			local buildmoneydue = tonumber(C.GetCreditsDueFromPlayerBuilds())

			if (trademoneydue > 0) and (buildmoneydue > 0) then
				Helper.playermoneyduetext = ReadText(1001, 7747)
			elseif trademoneydue > 0 then
				Helper.playermoneyduetext = ReadText(1001, 7704)
			elseif buildmoneydue > 0 then
				Helper.playermoneyduetext = ReadText(1001, 7746)
			else
				Helper.playermoneyduetext = nil
			end
			Helper.rawplayermoneydue = trademoneydue + buildmoneydue
		end
		local playermoneyduetext = ""
		if Helper.rawplayermoneydue > 0 then
			local playermoneydue = ConvertMoneyString(Helper.rawplayermoneydue, false, true, nil, true) .. " " .. ReadText(1001, 101)

			local playermoney = ConvertMoneyString(GetPlayerMoney(), false, true, nil, true) .. " " .. ReadText(1001, 101)
			local playermoneywidth = C.GetTextWidth(playermoney .. " ", Helper.playerInfoConfig.fontname, Helper.playerInfoConfig.fontsize)
			playermoneyduetext = TruncateText("(" .. string.format(Helper.playermoneyduetext, playermoneydue) .. ")", Helper.playerInfoConfig.fontname, Helper.playerInfoConfig.fontsize, Helper.playerInfoConfig.width - Helper.playerInfoConfig.height - 2 * Helper.borderSize - playermoneywidth)
		end

		return connectionStatus .. "\n" .. ffi.string(C.GetComponentName(playersector)) .. "\n" .. playermoneyduetext
	end
end

function Helper.getPlayerLogoColor()
	local color = Color["icon_normal"]
	if Helper.isPlayerCovered() then
		color = Color["player_cover"]
	end
	return color
end

Helper.shipComparisonData = {}

function Helper.clearShipComparisonData()
	Helper.shipComparisonData = {}
end

function Helper.getShipComparisonMacro(id)
	return Helper.shipComparisonData[id] and Helper.shipComparisonData[id].macro
end

function Helper.getShipComparisonUpgradeplan(id)
	return Helper.shipComparisonData[id] and Helper.shipComparisonData[id].upgradeplan
end

function Helper.addShipComparison(id, macro, upgradeplan)
	Helper.shipComparisonData[id] = { macro = macro, upgradeplan = upgradeplan }
end

function Helper.removeShipComparison(id)
	table.remove(Helper.shipComparisonData, id)
end

function Helper.createScriptValueWrapper(type, value)
	return { __egoScriptValueWrapper = true, type = type, value = value }
end

Helper.equipmentCompatibilities = {
	[1] = { tag = "standard",		color = Color["equipment_comp_standard"] },
	[2] = { tag = "missile",		color = Color["equipment_comp_missile"] },
	[3] = { tag = "mining",			color = Color["equipment_comp_mining"] },
	[4] = { tag = "highpower",		color = Color["equipment_comp_highpower"] },
	[5] = { tag = "venture",		color = { r = 196, g = 147, b = 84,  a = 100 } },
	[6] = { tag = "boron",			color = { r = 84,  g = 196, b = 188, a = 100 } },
}

Helper.transactionLogConfig = {
	numdatapoints = 100,
	factors = { 0.2, 0.5, 1, 2, 5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000, 50000, 100000, 200000, 500000, 1000000, 2000000, 5000000, 10000000, 20000000, 50000000, 100000000 },
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
	zoomSteps = {
		{ zoom = 1,			granularity = 5 },
		{ zoom = 2,			granularity = 10 },
		{ zoom = 5,			granularity = 30 },
		{ zoom = 10,		granularity = 60 },
		{ zoom = 30,		granularity = 180 },
		{ zoom = 60,		granularity = 300 },
		{ zoom = 180,		granularity = 1200 },
		{ zoom = 360,		granularity = 1800 },
		{ zoom = 720,		granularity = 3600 },
		{ zoom = 1440,		granularity = 7200 },
		{ zoom = 2880,		granularity = 21600 },
		{ zoom = 5040,		granularity = 43200 },
		{ zoom = 10080,		granularity = 86400 },
	},
	transactionLogPage = 100,
}

function Helper.buttonExpandTransactionEntry(buttondata, row, refreshCallback)
	if Helper.transactionLogData.expandedEntries[buttondata] then
		Helper.transactionLogData.expandedEntries[buttondata] = nil
	else
		Helper.transactionLogData.expandedEntries[buttondata] = true
	end
	Helper.transactionLogData.curEntry = buttondata
	refreshCallback()
end

function Helper.buttonTransactionLogZoom(direction, refreshCallback)
	Helper.transactionLogData.xZoom = math.max(0, math.min(#Helper.transactionLogConfig.zoomSteps, Helper.transactionLogData.xZoom + direction))
	local zoom = Helper.transactionLogConfig.zoomSteps[Helper.transactionLogData.xZoom].zoom
	Helper.transactionLogData.xGranularity = Helper.transactionLogConfig.zoomSteps[Helper.transactionLogData.xZoom].granularity
	if Helper.transactionLogData.xZoom <= 2 then
		Helper.transactionLogData.xScale = 1
		Helper.transactionLogData.xTitle = ReadText(1001, 6519) .. " [" .. ReadText(1001, 100) .. "]"
	elseif Helper.transactionLogData.xZoom <= 7 then
		Helper.transactionLogData.xScale = 60
		Helper.transactionLogData.xTitle = ReadText(1001, 6519) .. " [" .. ReadText(1001, 103) .. "]"
	elseif Helper.transactionLogData.xZoom <= 11 then
		Helper.transactionLogData.xScale = 3600
		Helper.transactionLogData.xTitle = ReadText(1001, 6519) .. " [" .. ReadText(1001, 102) .. "]"
	else
		Helper.transactionLogData.xScale = 24 * 3600
		Helper.transactionLogData.xTitle = ReadText(1001, 6519) .. " [" .. ReadText(1001, 104) .. "]"
	end

	refreshCallback()
end

function Helper.editboxTransactionLogPage(text, textchanged, refreshCallback)
	local newpage = tonumber(text)
	if newpage and (newpage ~= Helper.transactionLogData.curPage) then
		Helper.transactionLogData.curEntry = nil
		Helper.transactionLogData.curPage = math.max(1, math.min(newpage, Helper.transactionLogData.numPages))
		refreshCallback()
	else
		C.SetEditBoxText(Helper.transactionLogData.pageEditBox.id, Helper.transactionLogData.curPage .. " / " .. Helper.transactionLogData.numPages)
	end
end

function Helper.transactionLogSearchHelper(entry, text)
	text = utf8.lower(text)

	if string.find(utf8.lower(entry.eventtypename), text, 1, true) then
		return true
	end
	if string.find(utf8.lower(entry.description), text, 1, true) then
		return true
	end
	if string.find(utf8.lower(entry.partnername), text, 1, true) then
		return true
	end

	return false
end

function Helper.graphDataSelection(data, refreshCallback)
	local entryid = Helper.transactionLogData.graphdata[data[4]].entryid
	local preventryid
	if data[4] > 1 then
		preventryid = Helper.transactionLogData.graphdata[data[4] - 1].entryid
	end
	local transactionIndex = Helper.transactionLogData.transactionsByIDUnfiltered[entryid]
	if not transactionIndex and entryid < 0 and #Helper.transactionLogData.accountLogUnfiltered > 0 then
		-- no transaction found for condensed entry - use first non-condensed entry
		transactionIndex = 1
	end
	local prevTransactionIndex = 1
	if preventryid then
		prevTransactionIndex = Helper.transactionLogData.transactionsByIDUnfiltered[preventryid]
	end
	if not prevTransactionIndex and preventryid < 0 and #Helper.transactionLogData.accountLogUnfiltered > 0 then
		-- no transaction found for condensed entry - use first non-condensed entry
		prevTransactionIndex = 1
	end

	local mostSignificantEntry
	if transactionIndex and prevTransactionIndex then
		if prevTransactionIndex < transactionIndex then
			-- if the previous transactionlog index is smaller than the current, skip this index, as it is part of the previous data point not the current
			--  prevTimeInterval  |  curTimeInterval
			-- [ ..., prevEntry ] | [ ..., curEntry ]
			prevTransactionIndex = prevTransactionIndex + 1
		end
		for i = prevTransactionIndex, transactionIndex do
			local entry = Helper.transactionLogData.accountLogUnfiltered[i]
			if (Helper.transactionLogData.searchtext == "") or Helper.transactionLogData.transactionsByID[entry.entryid] then
				if (mostSignificantEntry == nil) or (mostSignificantEntry.value < math.abs(entry.money)) then
					mostSignificantEntry = { entry = entry.entryid, value = math.abs(entry.money) }
				end
			end
		end
	end

	Helper.transactionLogData.curEntry = mostSignificantEntry and mostSignificantEntry.entry or entryid
	refreshCallback()
end

function Helper.onTransactionLogUpdate()
	if Helper.transactionLogData.curEntry then
		local dataIdx
		for i, point in pairs(Helper.transactionLogData.graphdata) do
			dataIdx = i
			if point.entryid > 0 and point.entryid >= Helper.transactionLogData.curEntry then
				break
			elseif Helper.transactionLogData.curEntry < 0 and point.entryid <= Helper.transactionLogData.curEntry then
				break
			end
		end
		if dataIdx then
			Helper.transactionLogData.graph:selectDataPoint(1, dataIdx, true)
		end
	end
end

function Helper.onTransactionLogRowChanged(rowdata)
	if rowdata and (type(rowdata) ~= "string") then
		Helper.transactionLogData.curEntry = rowdata
	end
end

function Helper.onTransactionLogEditBoxActivated(widget)
	Helper.transactionLogData.noupdate = true
	if Helper.transactionLogData.pageEditBox and (widget == Helper.transactionLogData.pageEditBox.id) then
		C.SetEditBoxText(Helper.transactionLogData.pageEditBox.id, tostring(Helper.transactionLogData.curPage))
	end
end

function Helper.createTransactionLog(frame, container, tableProperties, refreshCallback, selectionData)
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

		-- mycu start: callback
		if callbacks ["createTransactionLog_on_before_adding_entry"] then
			for _, callback in ipairs (callbacks ["createTransactionLog_on_before_adding_entry"]) do
				entry = callback (entry)
			end
		end
		-- mycu end: callback

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

	local row = table_data:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
	row[1]:setColSpan(9):createText(ReadText(1001, 7702), Helper.titleTextProperties)

	local row = table_data:addRow("search", { fixed = true, bgColor = Color["row_background_blue"] })
	-- searchbar
	row[1]:setColSpan(2):createEditBox({ description = ReadText(1001, 7740), defaultText = ReadText(1001, 3250), height = Helper.subHeaderHeight }):setText(Helper.transactionLogData.searchtext, { halign = "left", x = Helper.standardTextOffsetx }):setHotkey("INPUT_STATE_DETAILMONITOR_0", { displayIcon = true })
	row[1].handlers.onEditBoxDeactivated = function (_, text) if text ~= Helper.transactionLogData.searchtext then Helper.transactionLogData.searchtext = text; Helper.transactionLogData.noupdate = nil; refreshCallback() end end
	-- clear search
	local buttonheight = math.max(Helper.editboxMinHeight, Helper.scaleY(Helper.subHeaderHeight))
	row[3]:createButton({ scaling = false, width = buttonsize, height = buttonheight, cellBGColor = Color["row_background"] }):setText("X", { halign = "center", font = Helper.standardFontBold })
	row[3].handlers.onClick = function () Helper.transactionLogData.searchtext = ""; refreshCallback() end
	-- pages
	row[4]:createButton({ scaling = false, active = Helper.transactionLogData.curPage > 1, width = buttonsize, height = buttonheight, cellBGColor = Color["row_background"] }):setIcon("widget_arrow_skip_left_01", { width = buttonsize, height = buttonsize, y = (row:getHeight() - buttonsize) / 2 })
	row[4].handlers.onClick = function () Helper.transactionLogData.curEntry = nil; Helper.transactionLogData.curPage = 1; refreshCallback() end
	row[5]:createButton({ scaling = false, active = Helper.transactionLogData.curPage > 1, width = buttonsize, height = buttonheight, cellBGColor = Color["row_background"] }):setIcon("widget_arrow_left_01", { width = buttonsize, height = buttonsize, y = (row:getHeight() - buttonsize) / 2 })
	row[5].handlers.onClick = function () Helper.transactionLogData.curEntry = nil; Helper.transactionLogData.curPage = Helper.transactionLogData.curPage - 1; refreshCallback() end
	Helper.transactionLogData.pageEditBox = row[6]:setColSpan(2):createEditBox({ description = ReadText(1001, 7739) }):setText(Helper.transactionLogData.curPage .. " / " .. Helper.transactionLogData.numPages, { halign = "center" })
	row[6].handlers.onEditBoxDeactivated = function (_, text, textchanged) Helper.transactionLogData.noupdate = nil; return Helper.editboxTransactionLogPage(text, textchanged, refreshCallback) end
	row[8]:createButton({ scaling = false, active = Helper.transactionLogData.curPage < Helper.transactionLogData.numPages, width = buttonsize, height = buttonheight, cellBGColor = Color["row_background"] }):setIcon("widget_arrow_right_01", { width = buttonsize, height = buttonsize, y = (row:getHeight() - buttonsize) / 2 })
	row[8].handlers.onClick = function () Helper.transactionLogData.curEntry = nil; Helper.transactionLogData.curPage = Helper.transactionLogData.curPage + 1; refreshCallback() end
	row[9]:createButton({ scaling = false, active = Helper.transactionLogData.curPage < Helper.transactionLogData.numPages, width = buttonsize, height = buttonheight, cellBGColor = Color["row_background"] }):setIcon("widget_arrow_skip_right_01", { width = buttonsize, height = buttonsize, y = (row:getHeight() - buttonsize) / 2 })
	row[9].handlers.onClick = function () Helper.transactionLogData.curEntry = nil; Helper.transactionLogData.curPage = Helper.transactionLogData.numPages; refreshCallback() end

	local headerHeight = table_data:getFullHeight()

	if #Helper.transactionLogData.accountLog > 0 then
		local total = 0
		for i = startIndex, endIndex, -1 do
			local entry = Helper.transactionLogData.accountLog[i]
			local row = table_data:addRow(entry.entryid, {  })
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
			row[2]:createText(((entry.partnername ~= "") and (entry.partnername .. " - ") or "") .. entry.eventtypename, { color = entry.destroyedpartner and Color["text_inactive"] or nil, mouseOverText = entry.destroyedpartner and ReadText(1026, 5701) or "" })
			row[3]:setColSpan(4):createText(Helper.getPassedTime(entry.time), { halign = "right" })
			row[7]:setColSpan(3):createText(((entry.money > 0) and "+" or "") .. ConvertMoneyString(entry.money, false, true, 0, true) .. " " .. ReadText(1001, 101), { halign = "right", color = (entry.money > 0) and Color["text_positive"] or Color["text_negative"] })
			total = total + entry.money
			if Helper.transactionLogData.expandedEntries[entry.entryid] then
				local row = table_data:addRow(nil, { bgColor = Color["row_background_unselectable"] })
				row[1].properties.cellBGColor = Color["row_background"]
				row[2]:setColSpan(8):createText(entry.description, { x = Helper.standardTextHeight, wordwrap = true, color = entry.destroyedpartner and Color["text_inactive"] or nil })
			end
		end

		if Helper.transactionLogData.xZoom < #Helper.transactionLogConfig.zoomSteps then
			local row = table_data:addRow("showmore", {  })
			row[1]:setColSpan(9):createButton({ bgColor = Color["button_background_hidden"] }):setText(ReadText(1001, 7778), { halign = "center" })
			if endIndex == 1 then
				row[1].handlers.onClick = function () return Helper.buttonTransactionLogZoom(1, refreshCallback) end
			else
				row[1].handlers.onClick = function () Helper.transactionLogData.curEntry = nil; Helper.transactionLogData.curPage = Helper.transactionLogData.curPage + 1; refreshCallback(_, 1) end
			end
		end

		local table_total = frame:addTable(2, { tabOrder = 0, width = tableProperties.width, x = tableProperties.x, y = tableProperties.y })
		table_total:setColWidthPercent(1, 75)

		table_total:addEmptyRow()

		local row = table_total:addRow(nil, { bgColor = Color["row_separator"] })
		row[1]:setColSpan(2):createText("", { fontsize = 1, minRowHeight = 2 })

		local row = table_total:addRow(nil, {  })
		row[1]:createText(ReadText(1001, 7776) .. ReadText(1001, 120))
		row[2]:createText(((total > 0) and "+" or "") .. ConvertMoneyString(total, false, true, 0, true) .. " " .. ReadText(1001, 101), { halign = "right", color = (total > 0) and Color["text_positive"] or Color["text_negative"] })

		local maxVisibleHeight = table_data.properties.maxVisibleHeight - table_total:getFullHeight() - Helper.frameBorder
		table_total.properties.y = table_total.properties.y + math.min(maxVisibleHeight, table_data:getFullHeight())
		table_data.properties.maxVisibleHeight = table_total.properties.y - table_data.properties.y

		table_data:addConnection(1, 2, true)
		table_total:addConnection(2, 2)
	else
		local row = table_data:addRow("none", {  })
		row[1]:setColSpan(9):createText("--- " .. ReadText(1001, 5705) .. " ---", { halign = "center" })

		if Helper.transactionLogData.xZoom < #Helper.transactionLogConfig.zoomSteps then
			local row = table_data:addRow("showmore", {  })
			row[1]:setColSpan(9):createButton({ bgColor = Color["button_background_hidden"] }):setText(ReadText(1001, 7778), { halign = "center" })
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
	local height = math.min(Helper.viewHeight - tableProperties.y - Helper.frameBorder - Helper.scaleY(Helper.standardTextHeight) - Helper.borderSize, math.floor(width * 9 / 16))
	local table_graph = frame:addTable(4, { tabOrder = 3, width = width, x = xoffset, y = tableProperties.y })
	table_graph:setColWidthPercent(2, 15)
	table_graph:setColWidthPercent(3, 15)

	-- graph cell
	local row = table_graph:addRow(false, { fixed = true })

	-- graph
	local title = ffi.string(C.GetComponentName(container))
	if container ~= C.GetPlayerID() then
		title = title .. " (" .. ffi.string(C.GetObjectIDCode(container)) .. ")"
	end
	Helper.transactionLogData.graph = row[1]:setColSpan(4):createGraph({ height = height, scaling = false }):setTitle(title, { font = Helper.titleFont, fontsize = Helper.scaleFont(Helper.titleFont, Helper.titleFontSize) })
	row[1].handlers.onClick = function (_, data) return Helper.graphDataSelection(data, refreshCallback) end

	local minY, maxY = 0, 1

	local datarecord = Helper.transactionLogData.graph:addDataRecord({
		markertype = Helper.transactionLogConfig.point.type,
		markersize = Helper.transactionLogConfig.point.size,
		markercolor = Color["transactionlog_graph_data"],
		linetype = Helper.transactionLogConfig.line.type,
		linewidth = Helper.transactionLogConfig.line.size,
		linecolor = Color["transactionlog_graph_data"],
	})

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
		datarecord:addData((point.t - endtime) / Helper.transactionLogData.xScale, point.y, nil, inactive)
	end

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

	Helper.transactionLogData.graph:setXAxis({ startvalue = -xRange, endvalue = 0, granularity = xGranularity, offset = xOffset, gridcolor = Color["graph_grid"] })
	Helper.transactionLogData.graph:setXAxisLabel(Helper.transactionLogData.xTitle, { fontsize = 9 })
	Helper.transactionLogData.graph:setYAxis({ startvalue = minY, endvalue = maxY, granularity = granularity, offset = yOffset, gridcolor = Color["graph_grid"] })
	Helper.transactionLogData.graph:setYAxisLabel(ReadText(1001, 7773) .. " [" .. ReadText(1001, 101) .. "]", { fontsize = 9 })

	-- zoom
	local row = table_graph:addRow(true, { fixed = true })
	row[2]:createButton({ active = Helper.transactionLogData.xZoom > 1 }):setText(ReadText(1001, 7777), { halign = "center" })
	row[2].handlers.onClick = function () return Helper.buttonTransactionLogZoom(-1, refreshCallback) end
	row[3]:createButton({ active = Helper.transactionLogData.xZoom < #Helper.transactionLogConfig.zoomSteps }):setText(ReadText(1001, 7778), { halign = "center" })
	row[3].handlers.onClick = function () return Helper.buttonTransactionLogZoom(1, refreshCallback) end

	table_graph:addConnection(1, 3, true)
end

function Helper.getSyncPointName(id)
	if (id > 0) and (id <= 24) then
		return ReadText(20401, id)
	else
		return ReadText(1001, 3237) .. " " .. id
	end
end

function Helper.updateVenturePlatforms()
	Helper.ventureplatforms = {}
	Helper.dockedventureships = {}
	local playerstations = GetContainedStationsByOwner("player")
	for _, station in ipairs(playerstations) do
		local station64 = ConvertIDTo64Bit(station)
		local ventureplatforms = {}
		Helper.ffiVLA(ventureplatforms, "UniverseID", C.GetNumVenturePlatforms, C.GetVenturePlatforms, station64)
		for i, platform in ipairs(ventureplatforms) do
			local docks = {}
			Helper.ffiVLA(docks, "UniverseID", C.GetNumVenturePlatformDocks, C.GetVenturePlatformDocks, platform)
		
			local isbusy = GetComponentData(ConvertStringTo64Bit(tostring(platform)), "isbusy")
			local ships = {}
			local missioninfo
			if isbusy then
				local info = C.GetCurrentVentureInfo(platform)
				missioninfo = { name = ffi.string(info.name), remainingtime = tonumber(info.remainingtime), rawname = ffi.string(info.rawname) }
				local n = info.numships
				local buf = ffi.new("UniverseID[?]", n)
				n = C.GetCurrentVentureShips(buf, n, platform)
				for i = 0, n - 1 do
					table.insert(ships, buf[i])
				end
			else
				for _, dock in ipairs(docks) do
					if C.IsComponentOperational(dock) then
						local dockedships = {}
						Helper.ffiVLA(dockedships, "UniverseID", C.GetNumDockedShips, C.GetDockedShips, dock, "player")
						Helper.dockedventureships[tostring(dock)] = dockedships

						for _, dockedship in ipairs(dockedships) do
							table.insert(ships, dockedship)
						end
					end
				end
			end

			local stationname = ffi.string(C.GetComponentName(station64)) .. " (" .. ffi.string(C.GetObjectIDCode(station64)) .. ")"
			local platformname = ffi.string(C.GetComponentName(platform))

			table.insert(Helper.ventureplatforms, { id = platform, stationid = station64, stationname = stationname, platformname = platformname, docks = docks, ships = ships, errors = {}, isbusy = isbusy, missioninfo = missioninfo })
		end
		table.sort(Helper.ventureplatforms, function (a, b) return (a.stationname .. a.platformname) < (b.stationname .. b.platformname) end)
	end
end

function Helper.isOnlineGame()
	return OnlineIsOnlineModeActive()
end

function Helper.hasVentureRewards()
   return OnlineHasVentureLogbookReward()
end

function Helper.getProjectEntry(cluster, buffer, isevent)
	local id = ffi.string(buffer.id)

	local predecessors = {}
	local buf_predecessors = ffi.new("const char*[?]", buffer.numpredecessors)
	local num_predecessors = C.GetTerraformingProjectPredecessors(buf_predecessors, buffer.numpredecessors, cluster, id)
	for j = 0, num_predecessors - 1 do
		table.insert(predecessors, ffi.string(buf_predecessors[j]))
	end

	local predecessorgroups = {}
	local buf_predecessorgroups = ffi.new("UITerraformingProjectPredecessorGroup[?]", buffer.numpredecessorgroups)
	local num_predecessorgroups = C.GetTerraformingProjectPredecessorGroups(buf_predecessorgroups, buffer.numpredecessorgroups, cluster, id)
	for j = 0, num_predecessorgroups - 1 do
		table.insert(predecessorgroups, {
			id = ffi.string(buf_predecessorgroups[j].id),
			anyproject = buf_predecessorgroups[j].anyproject,
		})
	end

	local blockingprojects = {}
	local buf_blockingprojects = ffi.new("const char*[?]", buffer.numblockingprojects)
	local num_blockingprojects = C.GetTerraformingProjectBlockingProjects(buf_blockingprojects, buffer.numblockingprojects, cluster, id)
	for j = 0, num_blockingprojects - 1 do
		table.insert(blockingprojects, ffi.string(buf_blockingprojects[j]))
	end

	local conditions = {}
	local buf_conditions = ffi.new("UITerraformingProjectCondition[?]", buffer.numconditions)
	local num_conditions = C.GetTerraformingProjectConditions(buf_conditions, buffer.numconditions, cluster, id)
	for j = 0, num_conditions - 1 do
		table.insert(conditions, {
			stat = ffi.string(buf_conditions[j].stat),
			min = buf_conditions[j].min,
			max = buf_conditions[j].max,
			minvalue = buf_conditions[j].minvalue,
			maxvalue = buf_conditions[j].maxvalue,
			issatisfied = buf_conditions[j].issatisfied,
		})
	end

	local primaryeffects, sideeffects = {}, {}
	local buf_effects = ffi.new("UITerraformingProjectEffect[?]", buffer.numprimaryeffects + buffer.numsideeffects)
	local num_effects = C.GetTerraformingProjectEffects(buf_effects, buffer.numprimaryeffects + buffer.numsideeffects, cluster, id)
	for j = 0, num_effects - 1 do
		table.insert(buf_effects[j].issideeffect and sideeffects or primaryeffects, {
			text = ffi.string(buf_effects[j].text),
			stat = ffi.string(buf_effects[j].stat),
			change = buf_effects[j].change,
			value = buf_effects[j].value,
			minvalue = buf_effects[j].minvalue,
			maxvalue = buf_effects[j].maxvalue,
			onfail = buf_effects[j].onfail,
			chance = buf_effects[j].chance,
			setbackpercent = buf_effects[j].setbackpercent,
			isbeneficial = buf_effects[j].isbeneficial,
		})
	end

	local rebates = {}
	local buf_rebates = ffi.new("UITerraformingProjectRebate[?]", buffer.numrebates)
	local num_rebates = C.GetTerraformingProjectRebates(buf_rebates,  buffer.numrebates, cluster, id)
	for j = 0, num_rebates - 1 do
		table.insert(rebates, {
			ware = ffi.string(buf_rebates[j].ware),
			waregroupname = ffi.string(buf_rebates[j].waregroupname),
			value = buf_rebates[j].value,
		})
	end

	local resources = {}
	if not isevent then
		local buf_resources = ffi.new("UIWareInfo[?]", buffer.numresources)
		local num_resources = C.GetTerraformingProjectRebatedResources(buf_resources, buffer.numresources, cluster, id)
		for j = 0, num_resources - 1 do
			local ware = ffi.string(buf_resources[j].ware)
			table.insert(resources, {
				ware = ware,
				name = GetWareData(ware, "name"),
				amount = buf_resources[j].amount,
			})
		end
		table.sort(resources, Helper.sortName)
	end

	local removedprojects = {}
	local buf_removedprojects = ffi.new("const char*[?]", buffer.numremovedprojects)
	local num_removedprojects = C.GetTerraformingProjectRemovedProjects(buf_removedprojects, buffer.numremovedprojects, cluster, id)
	for j = 0, num_removedprojects - 1 do
		table.insert(removedprojects, ffi.string(buf_removedprojects[j]))
	end

	local entry = {
		id = id,
		group = ffi.string(buffer.group),
		isevent = isevent,
		name = ffi.string(buffer.name),
		description = ffi.string(buffer.description),
		duration = buffer.duration,
		repeatcooldown = buffer.repeatcooldown,
		timescompleted = buffer.timescompleted,
		successchance = buffer.successchance,
		resilient = buffer.resilient,
		showalways = buffer.showalways,
		price = buffer.price,
		payoutfactor = buffer.payoutfactor,
		requiredresearch = ffi.string(buffer.requiredresearchid),
		pricescale = ffi.string(buffer.pricescale);
		pricescaletext = ffi.string(buffer.pricescaletext);
		anypredecessor = buffer.anypredecessor,
		predecessors = predecessors,
		predecessorgroups = predecessorgroups,
		blockingprojects = blockingprojects,
		conditions = conditions,
		primaryeffects = primaryeffects,
		sideeffects = sideeffects,
		rebates = rebates,
		resources = resources,
		isongoing = C.IsTerraformingProjectOngoing(cluster, id),
		removedprojects = removedprojects,
	}

	return entry
end

function Helper.ventureTimeLeft(timeleft)
	local timeformat = ReadText(1001, 205)
	if timeleft < 3600 then
		timeformat = ReadText(1001, 210)
	elseif timeleft < 3600 * 24 then
		timeformat = ReadText(1001, 207)
	end

	return ConvertTimeString(math.max(60, timeleft), timeformat)
end

function Helper.ventureOperationTimeLeftText()
	local operation = OnlineGetCurrentOperation()
	local operationtimestring = "---"
	if operation.isvalid then
		local timeleft = operation.remainingtime
		operationtimestring = Helper.ventureTimeLeft((timeleft > 0) and timeleft or 0)
	end
	return operationtimestring
end

function Helper.ventureSeasonTimeLeftText()
	local curtime = C.GetCurrentUTCDataTime()
	local season = OnlineGetCurrentSeason()
	local seasontimestring = ReadText(1001, 11581)
	if next(season) then
		if season.isrunning then
			local timeleft = tonumber(season.endtime - curtime)
			seasontimestring = Helper.ventureTimeLeft((timeleft > 0) and timeleft or 0)
		elseif season.endtime > curtime then
			seasontimestring = ReadText(1001, 11579)
		end
	end
	return seasontimestring
end

function Helper.ventureEndTimeLeftText(endtime)
	local curtime = C.GetCurrentUTCDataTime()
	local timeleft = tonumber(endtime - curtime)
	return Helper.ventureTimeLeft((timeleft > 0) and timeleft or 0)
end

Helper.rightSideBar = {
	{ name = ReadText(1001, 7902), icon = "mapst_plotmanagement",			mode = "construction", 				helpOverlayID = "mapst_plotmanagement",			helpOverlayText = ReadText(1028, 3261) },
	{ name = ReadText(1001, 7903), icon = "stationbuildst_lsov",			mode = "logical",					helpOverlayID = "stationbuildst_lsov",			helpOverlayText = ReadText(1028, 3260) },
	{ name = ReadText(1001, 7702), icon = "pi_transactionlog",				mode = "transactions",				helpOverlayID = "pi_transactionlog",			helpOverlayText = ReadText(1028, 3262) },
	{ name = ReadText(1001, 7400), icon = "tlt_research",					mode = "research",					helpOverlayID = "tlt_research",					helpOverlayText = ReadText(1028, 8102),		canresearch = true },
	{ name = ReadText(1001, 3800), icon = "tlt_terraforming",				mode = "terraforming",				helpOverlayID = "tlt_terraforming",				helpOverlayText = ReadText(1028, 8109),		canterraform = true },
}

function Helper.createRightSideBar(frame, container, condition, currentmode, callback, selfcallback)
	local sidebarWidth = Helper.scaleX(Helper.sidebarWidth)
	local ftable = frame:addTable(1, { tabOrder = 4, width = sidebarWidth, height = 0, x = Helper.viewWidth - sidebarWidth - Helper.frameBorder, y = Helper.frameBorder + 20, scaling = false, borderEnabled = false, reserveScrollBar = false })

	local isplayerowned = GetComponentData(container, "isplayerowned")

	for _, entry in ipairs(Helper.rightSideBar) do
		local display = true
		if (entry.canresearch ~= nil) then
			if isplayerowned then
				if not C.IsHQ(container) then
					display = not entry.canresearch
				else
					display = C.CanResearch()
				end
			else
				display = false
			end
		end
		if (entry.canterraform ~= nil) then
			if isplayerowned then
				if not C.IsHQ(container) then
					display = not entry.canterraform
				else
					local cluster = C.GetContextByClass(container, "cluster", false)
					display = GetComponentData(ConvertStringTo64Bit(tostring(cluster)), "hasterraforming") and (C.GetNumTerraformingProjects(cluster, false) > 0)
				end
			else
				display = false
			end
		end

		if display then
			local row = ftable:addRow(true, { fixed = true, bgColor = Color["row_background_blue"] })

			local active = (entry.active == nil) or entry.active
			if (entry.mode == "construction") or (entry.mode == "transactions") then
				active = active and isplayerowned and condition
			end

			local bgcolor = Color["row_title_background"]
			if entry.mode == currentmode then
				bgcolor = Color["row_background_selected"]
			end
			row[1]:createButton({ active = active, height = sidebarWidth, mouseOverText = entry.name, bgColor = bgcolor, helpOverlayID = entry.helpOverlayID, helpOverlayText = entry.helpOverlayText }):setIcon(entry.icon)
			row[1].handlers.onClick = function () return Helper.buttonRightBar(container, currentmode, callback, selfcallback, entry.mode, row.index) end
		end
	end

	return ftable
end

function Helper.buttonRightBar(container, currentmode, callback, selfcallback, mode, row)
	local newmenu, params
	if mode ~= currentmode then
		if mode == "construction" then
			newmenu = "StationConfigurationMenu"
			params = { 0, 0, container }
		elseif mode == "transactions" then
			newmenu = "TransactionLogMenu"
			params = { 0, 0, container }
		elseif mode == "logical" then
			newmenu = "StationOverviewMenu"
			params = { 0, 0, container }
		elseif mode == "research" then
			newmenu = "ResearchMenu"
			params = { 0, 0 }
		elseif mode == "terraforming" then
			newmenu = "TerraformingMenu"
			local cluster = C.GetContextByClass(container, "cluster", false)
			params = { 0, 0, ConvertStringTo64Bit(tostring(cluster)) }
		end
	elseif selfcallback then
		selfcallback()
	end

	if newmenu then
		callback(newmenu, params)
	end
end

function Helper.isPlayerCovered()
	local player = ConvertStringTo64Bit(tostring(C.GetPlayerID()))
	if player and (player ~= 0) then
		return GetComponentData(player, "iscovered")
	end
	return false
end

function Helper.formatTimeLeft(timeleft)
	local timeformat = ReadText(1001, 214)
	if timeleft < 60 then
		timeformat = ReadText(1001, 215)
	elseif timeleft < 3600 then
		timeformat = ReadText(1001, 209)
	end

	return ConvertTimeString(timeleft, timeformat)
end

Helper.extensions = {}

function Helper.registerExtension(extensionid, hook)
	Helper.extensions[extensionid] = hook
end

function Helper.callExtensionFunction(extensionid, functionname, ...)
	if Helper.extensions[extensionid] then
		local extensionfunc = Helper.extensions[extensionid][functionname]
		if extensionfunc then
			if type(extensionfunc) == "function" then
				return extensionfunc(...)
			end
		end
		DebugError("Helper.callExtensionFunction(): Function '".. tostring(functionname) .. "' not found in extension: " .. tostring(extensionid))
		print(TraceBack())
	else
		DebugError("Helper.callExtensionFunction(): Invalid extensionid: " .. tostring(extensionid) .. ", calling: " .. tostring(functionname))
		print(TraceBack())
	end
end

function Helper.hasExtension(extensionid)
	return Helper.extensions[extensionid] ~= nil
end

function Helper.updateTradeRules()
	local traderules = {}
	Helper.ffiVLA(traderules, "TradeRuleID", C.GetNumAllTradeRules, C.GetAllTradeRules)
	for i = #traderules, 1, -1 do
		local id = traderules[i]

		local counts = C.GetTradeRuleInfoCounts(id)
		local buf = ffi.new("TradeRuleInfo")
		buf.numfactions = counts.numfactions
		buf.factions = Helper.ffiNewHelper("const char*[?]", counts.numfactions)
		if C.GetTradeRuleInfo(buf, id) then
			local factions = {}
			local hasplayer = false
			for j = 0, buf.numfactions - 1 do
				local faction = ffi.string(buf.factions[j])
				if faction == "player" then
					hasplayer = true
				else
					table.insert(factions, faction)
				end
			end
			table.sort(factions, Helper.sortFactionName)
			if hasplayer then
				table.insert(factions, 1, "player")
			end

			traderules[i] = { id = id, name = ffi.string(buf.name), factions = factions, iswhitelist = buf.iswhitelist }
		else
			table.remove(traderules, i)
		end
	end
	table.sort(traderules, Helper.sortID)
	Helper.traderuleOptions = {
		{ id = -1, text = ReadText(1001, 11024), icon = "", displayremoveoption = false },
	}
	for _, traderule in ipairs(traderules) do
		local mouseovertext = (traderule.iswhitelist and ReadText(1001, 11027) or ReadText(1001, 11026)) .. ReadText(1001, 120)
		for _, faction in ipairs(traderule.factions) do
			mouseovertext = mouseovertext .. "\n· " .. ((faction == "player") and ColorText["text_player"] or "") .. GetFactionData(faction, "name") .. "\27X"
		end
		table.insert(Helper.traderuleOptions, { id = traderule.id, text = traderule.name, icon = "", displayremoveoption = false, mouseovertext = mouseovertext })
	end
end

function Helper.getETAString(name, eta)
	local curtime = GetCurTime()
	if (eta > 0) then
		if (eta - curtime > 0) then
			return ConvertTimeString(eta - curtime, ReadText(1001, 204)) .. " - " .. name
		else
			return ConvertTimeString(0, ReadText(1001, 204)) .. " - " .. name
		end
	else
		return "- - : - -  - " .. name
	end
end

function Helper.createLSOStorageNode(menu, container, ware, planned, hasstorage, iscargo)
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
				helpOverlayID = "station_overview_storage_" .. ware,
				helpOverlayText = " ",
				helpOverlayHighlightOnly = true,
				uiTriggerID = "storage_" .. ware,
			},
			isstorage = true,
			expandedTableNumColumns = 3,
			expandHandler = function (...) return Helper.onExpandLSOStorageNode(menu, container, ...) end,
			collapseHandler = function (...) return Helper.onCollapseLSOStorageNode(menu, ...) end,
			sliderHandler = function (...) return Helper.onSliderChangedLSOStorageNode(container, ...) end,
			color = (not hasstorage) and Color["lso_node_inactive"] or nil,
			statuscolor = (not iscargo) and ((not hasstorage) and Color["icon_error"] or (hasrestrictions and Color["icon_warning"] or nil) or nil),
			statusIcon = (not iscargo) and ((not hasstorage) and "lso_warning" or (hasrestrictions and "lso_error" or nil) or nil),
		}
	}
	return warenode
end

function Helper.updateLSOStorageNode(menu, node, container, ware)
	local hasrestrictions = Helper.isTradeRestricted(container, ware)
	local hasstorage = node.customdata.nodedata.hasstorage
	local edgecolor = Color["flowchart_edge_default"]
	
	local statusicon = hasrestrictions and "lso_error" or nil
	local statusiconmouseovertext = hasrestrictions and (ColorText["text_warning"] .. ReadText(1026, 8404)) or ""
	local statuscolor = hasrestrictions and Color["icon_warning"] or nil

	if not hasstorage then
		statusicon = "lso_warning"
		statuscolor = Color["icon_error"]
		statusiconmouseovertext = ColorText["text_error"] .. ReadText(1001, 8416)
	elseif menu.resourcesmissing[ware] then
		statusicon = "lso_warning"
		statuscolor = Color["icon_error"]
		statusiconmouseovertext = ColorText["text_error"] .. ReadText(1001, 8437)
	elseif menu.storagemissing[ware] then
		statusicon = "lso_warning"
		statuscolor = Color["icon_error"]
		statusiconmouseovertext = ColorText["text_error"] .. ReadText(1001, 8438)
	end

	if not statusicon then
		if C.IsComponentClass(container, "container") then
			if HasContainerStockLimitOverride(container, ware) then
				statusicon = "lso_override"
				statuscolor = Color["flowchart_node_default"]
				statusiconmouseovertext = ReadText(1026, 8410)

				local currentlimit = GetWareProductionLimit(container, ware)
				local defaultlimit = C.GetContainerWareMaxProductionStorageForTime(container, ware, 7200, true)
				local waretype = Helper.getContainerWareType(container, ware)
				if (waretype ~= "trade") and (currentlimit < defaultlimit) then
					statuscolor = Color["icon_warning"]
					statusiconmouseovertext = ColorText["text_warning"] .. ReadText(1001, 8467)
				end
			end
		end
	end

	if not C.IsInfoUnlockedForPlayer(container, "storage_amounts") then
		statusicon = nil
		statusbgicon = nil
	end

	if menu.storagemissing[ware] then
		edgecolor = Color["lso_node_error"]
	end

	local storageinfo_amounts = C.IsInfoUnlockedForPlayer(container, "storage_amounts")
	local amount = 0
	if storageinfo_amounts then
		amount = GetComponentData(container, "cargo")[ware] or 0
	end
	local max = 0
	if C.IsComponentClass(container, "controllable") then
		max = math.max(amount, GetWareProductionLimit(container, ware))
	end
	if max < node.properties.value then
		node:updateValue(amount)
	end
	if max > node.properties.max then
		node:updateMaxValue(max)
	end
	if node.properties.slider1 >= 0 then
		local slider1 = math.max(0, math.min(max, C.GetContainerBuyLimit(container, ware)))
		node:updateSlider1(slider1)
	end
	if node.properties.slider2 >= 0 then
		local slider2 = math.max(0, math.min(max, C.GetContainerSellLimit(container, ware)))
		node:updateSlider2(slider2)
	end
	if max < node.properties.max then
		node:updateMaxValue(max)
	end
	node:updateValue(amount)

	-- kuertee start: callback
	if callbacks ["updateLSOStorageNode_pre_update_expanded_node"] then
		-- function widgetPrototypes.flowchartnode:updateStatus(text, icon, bgicon, color, mouseovertext)
		local status_text = nil
		local status_icon = statusicon
		local status_bgicon = nil
		local status_color = statuscolor
		local status_mouseovertext = statusiconmouseovertext
		for _, callback in ipairs (callbacks ["updateLSOStorageNode_pre_update_expanded_node"]) do
			status_text, status_icon, status_bgicon, status_color, status_mouseovertext = callback(menu, node, container, ware, status_text, status_icon, status_bgicon, status_color, status_mouseovertext)
		end
		node:updateStatus(status_text, status_icon, status_bgicon, status_color, status_mouseovertext)
	else

		node:updateStatus(nil, statusicon, nil, statuscolor, statusiconmouseovertext)
	end
	-- kuertee end: callback

	for _, edge in ipairs(node.incomingEdges) do
		menu.updateEdgeColorRecursively(edge, edgecolor)
	end
end

Helper.wareTypeBuffer = {}
function Helper.getContainerWareType(container, ware)
	local curtime = getElapsedTime()
	if (not next(Helper.wareTypeBuffer)) or (container ~= Helper.wareTypeBuffer.container) or (Helper.wareTypeBuffer.lastUpdateTime + 5 < curtime) then
		local products, pureresources, intermediatewares = GetComponentData(container, "availableproducts", "pureresources", "intermediatewares")
		Helper.wareTypeBuffer.container = container
		Helper.wareTypeBuffer.lastUpdateTime = curtime

		Helper.wareTypeBuffer = {
			products = {},
			pureresources = {},
			intermediatewares = {},
		}

		for _, productware in ipairs(products) do
			Helper.wareTypeBuffer.products[productware] = true
		end
		for _, resourceware in ipairs(pureresources) do
			Helper.wareTypeBuffer.pureresources[resourceware] = true
		end
		for _, intermediateware in ipairs(intermediatewares) do
			Helper.wareTypeBuffer.intermediatewares[intermediateware] = true
		end
	end

	local waretype = "trade"
	if Helper.wareTypeBuffer.products[ware] then
		waretype = "product"
	elseif Helper.wareTypeBuffer.intermediatewares[ware] then
		waretype = "intermediate"
	elseif Helper.wareTypeBuffer.pureresources[ware] then
		waretype = "resource"
	end
	return waretype
end

function Helper.isTradeRestricted(container, ware)
	local waretype = Helper.getContainerWareType(container, ware)

	local buyrestricted, sellrestricted = false, false
	if (waretype == "resource") or (waretype == "intermediate") or (waretype == "product") or (waretype == "trade") then
		local istradewarebought = C.GetContainerWareIsBuyable(container, ware)
		local istradewaresold = C.GetContainerWareIsSellable(container, ware)
		local hasbuylimitoverride = C.HasContainerBuyLimitOverride(container, ware)
		local hasselllimitoverride = C.HasContainerSellLimitOverride(container, ware)
		if (waretype == "resource") or (waretype == "intermediate") or istradewarebought or hasbuylimitoverride then
			buyrestricted = C.GetContainerTradeRuleID(container, "buy", ware) > 0
		end
		if (waretype == "product") or (waretype == "intermediate") or istradewaresold or hasselllimitoverride then
			sellrestricted = C.GetContainerTradeRuleID(container, "sell", ware) > 0
		end
	end
	return buyrestricted or sellrestricted
end

Helper.dirtyreservations = {}

function Helper.onExpandLSOStorageNode(menu, container, _, ftable, _, nodedata)
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
		local issupply = buf[i].issupply
		if not issupply then
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
	if storageinfo_amounts then
		if nodedata.hasstorage and (not nodedata.planned) then
			local shown = false
			if menu.resourcesmissing[nodedata.ware] then
				shown = true
				row = ftable:addRow(nil, {  })
				row[1]:setColSpan(3):createText(ReadText(1001, 8437), { color = Color["text_error"] })
			end
			if menu.storagemissing[nodedata.ware] then
				shown = true
				row = ftable:addRow(nil, {  })
				row[1]:setColSpan(3):createText(ReadText(1001, 8438), { color = Color["text_error"] })
			end
			if shown then
				row = ftable:addRow(nil, {  })
				row[1]:setColSpan(3):createText("")
			end
		end
	end

	local limitslider
	if isprocessed then
		-- resource buffer
		row = ftable:addRow(nil, {  })
		row[1]:createText(ReadText(1001, 2415) .. ReadText(1001, 120))
		row[2]:setColSpan(2):createText(ReadText(20206, 1301), { halign = "right" })
		-- amount
		row = ftable:addRow(nil, {  })
		row[1]:createText(ReadText(1001, 6521) .. ReadText(1001, 120))
		row[2]:setColSpan(2):createText(function () return Helper.getResourceBufferAmount(container, nodedata.ware, storageinfo_amounts) end, { halign = "right" })
	else
		-- storage
		row = ftable:addRow(nil, {  })
		row[1]:createText(ReadText(1001, 2415) .. ReadText(1001, 120))
		row[2]:setColSpan(2):createText(storagename, { halign = "right" })
		-- missing storage type
		if not nodedata.hasstorage then
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(3):createText(ReadText(1001, 8416), { color = Color["text_error"], wordwrap = true })
		end
		if C.IsComponentClass(container, "container") then
			if not isprocessed then
				-- amount
				row = ftable:addRow(nil, {  })
				row[1]:createText(ReadText(1001, 6521) .. ReadText(1001, 120))
				row[2]:setColSpan(2):createText(function () return Helper.getStorageAmount(container, nodedata, storageinfo_amounts, storageinfo_capacity) end, { halign = "right", mouseOverText = function () return Helper.getStorageAmount(container, nodedata, storageinfo_amounts, storageinfo_capacity, 0, true) end })

				ftable:addEmptyRow(Helper.standardTextHeight / 2)

				row = ftable:addRow(nil, {  })
				row[1]:createText(ReadText(1001, 1600) .. " / " .. ReadText(1001, 102) .. ReadText(1001, 120))
				row[2]:setColSpan(2):createText(function () local production = C.GetContainerWareProduction(container, nodedata.ware, false); return Helper.unlockInfo(storageinfo_amounts, (production > 0) and ConvertIntegerString(production, true, 3, true, true) or "-") end, { halign = "right" })
				row = ftable:addRow(nil, {  })
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

						row = ftable:addRow(nil, {  })
						row[1]:setColSpan(3):createText(ReadText(1001, 8444) .. ReadText(1001, 120), { mouseOverText = ReadText(1026, 8403) })
						row = ftable:addRow(nil, {  })
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
								local color = Color["text_normal"]
								if available == 0 then
									color = Color["text_error"]
								elseif available < 0.1 * capacity then
									color = Color["text_warning"]
								end
								return Helper.unlockInfo(storageinfo_amounts, Helper.convertColorToText(color) .. ConvertIntegerString(available, true, 3, true, true) .. " " .. ReadText(1001, 110))
							end,
							{ halign = "right" }
						)
					end
					-- automatic storage level
					local row = ftable:addRow("autostoragecheckbox", {  })
					if menu.selectedRowData["nodeTable"] == "autostoragecheckbox" then
						menu.selectedRows["nodeTable"] = row.index
						menu.selectedRowData["nodeTable"] = nil
					end
					row[1]:setColSpan(2):createText(ReadText(1001, 8439) .. ReadText(1001, 120))
					row[3]:createCheckBox(not haslimitoverride, { height = Helper.standardButtonHeight })
					row[3].handlers.onClick = function (_, checked) return Helper.checkboxStorageLevelOverride(menu, container, nodedata.ware, row.index, currentlimit, checked) end
					if haslimitoverride then
						-- price
						local row = ftable:addRow("autostorageslider", {  })
						if menu.selectedRowData["nodeTable"] == "autostorageslider" then
							menu.selectedRows["nodeTable"] = row.index
							menu.selectedRowData["nodeTable"] = nil
						end
						local max = GetWareCapacity(container, nodedata.ware)
						limitslider = row[1]:setColSpan(3):createSliderCell({
							height = Helper.standardTextHeight,
							bgColor = haslimitoverride and Color["slider_background_default"] or Color["slider_background_inactive"],
							valueColor = haslimitoverride and Color["slider_value"] or Color["slider_value_inactive"],
							min = 0,
							minSelect = 1,
							max = max,
							start = math.max(1, math.min(max, currentlimit)),
							hideMaxValue = true,
							readOnly = not haslimitoverride,
							forceArrows = true,
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
			-- kuertee start: callback
			if callbacks ["onExpandLSOStorageNode_pre_buy_offer_title"] then
				for _, callback in ipairs (callbacks ["onExpandLSOStorageNode_pre_buy_offer_title"]) do
					callback(menu, container, ftable, nodedata)
				end
			end
			-- kuertee end: callback

			local currentprice = math.max(minprice, math.min(maxprice, RoundTotalTradePrice(GetContainerWarePrice(container, nodedata.ware, true))))
			local haspriceoverride = HasContainerWarePriceOverride(container, nodedata.ware, true)
			local istradewarebought = C.GetContainerWareIsBuyable(container, nodedata.ware)
			local currentlimit = C.GetContainerBuyLimit(container, nodedata.ware)
			local haslimitoverride = C.HasContainerBuyLimitOverride(container, nodedata.ware)
			-- title
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(3):createText(ReadText(1001, 8309), Helper.subHeaderTextProperties)
			row[1].properties.halign = "center"
			if (waretype == "resource") or (waretype == "intermediate") or istradewarebought or haslimitoverride then
				-- automatic buy limit
				local row = ftable:addRow("autobuylimitcheckbox", {  })
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
				-- buy limit
				local row = ftable:addRow("autobuylimitslider", {  })
				if menu.selectedRowData["nodeTable"] == "autobuylimitslider" then
					menu.selectedRows["nodeTable"] = row.index
					menu.selectedRowData["nodeTable"] = nil
				end
				local max = GetWareProductionLimit(container, nodedata.ware)
				Helper.LSOStorageNodeBuySlider = { ware = nodedata.ware, widget = row[1]:setColSpan(3):createSliderCell({
					height = Helper.standardTextHeight,
					bgColor = haslimitoverride and Color["slider_background_default"] or Color["slider_background_inactive"],
					valueColor = haslimitoverride and Color["slider_value"] or Color["slider_value_inactive"],
					min = 0,
					minSelect = max == 0 and 0 or 1,
					max = max,
					start = math.min(max, currentlimit),
					hideMaxValue = true,
					readOnly = not haslimitoverride,
					forceArrows = true,
				})}
				-- automatic pricing
				local row = ftable:addRow("autobuypricecheckbox", {  })
				if menu.selectedRowData["nodeTable"] == "autobuypricecheckbox" then
					menu.selectedRows["nodeTable"] = row.index
					menu.selectedRowData["nodeTable"] = nil
				end
				if haspriceoverride then
					row[1]:setColSpan(2):createText(ReadText(1001, 8402) .. ReadText(1001, 120), { wordwrap = true })
				else
					row[1]:createText(ReadText(1001, 8402) .. ReadText(1001, 120), { wordwrap = true })
					row[2]:createText(function () return ConvertMoneyString(math.max(minprice, math.min(maxprice, GetContainerWarePrice(container, nodedata.ware, true))), true, true, 2, true) .. " " .. ReadText(1001, 101) end, { halign = "right" })
				end
				row[3]:createCheckBox(not haspriceoverride, { height = Helper.standardButtonHeight })
				row[3].handlers.onClick = function (_, checked) return Helper.checkboxStorageWarePriceOverride(menu, container, nodedata.ware, row.index, true, currentprice, checked) end
				if haspriceoverride then
					-- price
					local row = ftable:addRow("autobuypriceslider", {  })
					if menu.selectedRowData["nodeTable"] == "autobuypriceslider" then
						menu.selectedRows["nodeTable"] = row.index
						menu.selectedRowData["nodeTable"] = nil
					end
					row[1]:setColSpan(3):createSliderCell({
						height = Helper.standardTextHeight,
						bgColor = haslimitoverride and Color["slider_background_default"] or Color["slider_background_inactive"],
						valueColor = haspriceoverride and Color["slider_value"] or Color["slider_value_inactive"],
						min = minprice,
						max = maxprice,
						start = currentprice,
						hideMaxValue = true,
						suffix = ReadText(1001, 101),
						readOnly = not haspriceoverride,
						forceArrows = true,
					})
					row[1].handlers.onSliderCellChanged = function(_, value) return Helper.slidercellStorageWarePriceOverride(container, nodedata.ware, true, value) end
					row[1].handlers.onSliderCellActivated = function (id) menu.noupdate = true end
					row[1].handlers.onSliderCellDeactivated = function (id) menu.noupdate = false end
				end
				-- trade rule
				local hasownlist = C.HasContainerOwnTradeRule(container, "buy", nodedata.ware)
				local traderuleid = C.GetContainerTradeRuleID(container, "buy", nodedata.ware)
				local row = ftable:addRow(nil, {  })
				row[1]:setColSpan(3):createText(ReadText(1001, 11013) .. ReadText(1001, 120), textproperties)
				-- global
				local row = ftable:addRow("buytraderule_global", {  })
				row[1]:setColSpan(2):createText(ReadText(1001, 11025) .. ReadText(1001, 120), textproperties)
				row[3]:createCheckBox(not hasownlist, { height = Helper.standardButtonHeight })
				row[3].handlers.onClick = function(_, checked) return Helper.checkboxSetTradeRuleOverride(menu, container, "buy", nodedata.ware, checked) end
				-- current
				local row = ftable:addRow("buytraderule_current", {  })
				row[1]:setColSpan(2):createDropDown(Helper.traderuleOptions, { startOption = (traderuleid ~= 0) and traderuleid or -1, active = hasownlist }):setTextProperties({ fontsize = config.mapFontSize })
				row[1].handlers.onDropDownConfirmed = function (_, id) return Helper.dropdownTradeRule(menu, container, "buy", nodedata.ware, id) end
				row[1].handlers.onDropDownActivated = function () menu.noupdate = true end
				row[3]:createButton({ mouseOverText = ReadText(1026, 8407) }):setIcon("menu_edit")
				row[3].handlers.onClick = function () return Helper.buttonEditTradeRule(menu) end
			end
			-- create / remove offer
			if (waretype == "trade") or (waretype == "product") then
				row = ftable:addRow("tradebuy", {  })
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
					row[3]:createButton({ active = function () return Helper.buttonCancelTradeActive(menu, container, reservation.tradedeal) end, mouseOverText = ReadText(1026, 7924) }):setText("X", { halign = "center" })
					row[3].handlers.onClick = function () return Helper.buttonCancelTrade(menu, container, reservation.tradedeal) end
				end
			end
		end

		-- sell offer
		if (not isprocessed) and ((waretype == "resource") or (waretype == "product") or (waretype == "intermediate") or (waretype == "trade")) then
			-- kuertee start: callback
			if callbacks ["onExpandLSOStorageNode_pre_sell_offer_title"] then
				for _, callback in ipairs (callbacks ["onExpandLSOStorageNode_pre_sell_offer_title"]) do
					callback(menu, container, ftable, nodedata)
				end
			end
			-- kuertee end: callback

			local currentprice = math.max(minprice, math.min(maxprice, RoundTotalTradePrice(GetContainerWarePrice(container, nodedata.ware, false))))
			local haspriceoverride = HasContainerWarePriceOverride(container, nodedata.ware, false)
			local istradewaresold = C.GetContainerWareIsSellable(container, nodedata.ware)
			local currentlimit = C.GetContainerSellLimit(container, nodedata.ware)
			local haslimitoverride = C.HasContainerSellLimitOverride(container, nodedata.ware)
			-- title
			row = ftable:addRow(nil, {  })
			row[1]:setColSpan(3):createText(ReadText(1001, 8308), Helper.subHeaderTextProperties)
			row[1].properties.halign = "center"
			if (waretype == "product") or (waretype == "intermediate") or istradewaresold or haslimitoverride then
				-- automatic sell limit
				local row = ftable:addRow("autoselllimitcheckbox", {  })
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
				-- sell limit
				local row = ftable:addRow("autoselllimitslider", {  })
				if menu.selectedRowData["nodeTable"] == "autoselllimitslider" then
					menu.selectedRows["nodeTable"] = row.index
					menu.selectedRowData["nodeTable"] = nil
				end
				local max = GetWareProductionLimit(container, nodedata.ware)
				Helper.LSOStorageNodeSellSlider = { ware = nodedata.ware, widget = row[1]:setColSpan(3):createSliderCell({
					height = Helper.standardTextHeight,
					bgColor = haslimitoverride and Color["slider_background_default"] or Color["slider_background_inactive"],
					valueColor = haslimitoverride and Color["slider_value"] or Color["slider_value_inactive"],
					min = 0,
					minSelect = max == 0 and 0 or 1,
					max = max,
					start = math.min(max, currentlimit),
					hideMaxValue = true,
					readOnly = not haslimitoverride,
					forceArrows = true,
				})}
				-- automatic pricing
				local row = ftable:addRow("autosellpricecheckbox", {  })
				if menu.selectedRowData["nodeTable"] == "autosellpricecheckbox" then
					menu.selectedRows["nodeTable"] = row.index
					menu.selectedRowData["nodeTable"] = nil
				end
				if haspriceoverride then
					row[1]:createText(ReadText(1001, 8402) .. ReadText(1001, 120), { wordwrap = true })
				else
					row[1]:createText(ReadText(1001, 8402) .. ReadText(1001, 120), { wordwrap = true })
					row[2]:createText(function () return ConvertMoneyString(math.max(minprice, math.min(maxprice, GetContainerWarePrice(container, nodedata.ware, false))), true, true, 2, true) .. " " .. ReadText(1001, 101) end, { halign = "right" })
				end
				row[3]:createCheckBox(not haspriceoverride, { height = Helper.standardButtonHeight })
				row[3].handlers.onClick = function (_, checked) return Helper.checkboxStorageWarePriceOverride(menu, container, nodedata.ware, row.index, false, currentprice, checked) end
				if haspriceoverride then
					-- price
					local row = ftable:addRow("autosellpriceslider", {  })
					if menu.selectedRowData["nodeTable"] == "autosellpriceslider" then
						menu.selectedRows["nodeTable"] = row.index
						menu.selectedRowData["nodeTable"] = nil
					end
					row[1]:setColSpan(3):createSliderCell({
						height = Helper.standardTextHeight,
						bgColor = haslimitoverride and Color["slider_background_default"] or Color["slider_background_inactive"],
						valueColor = haspriceoverride and Color["slider_value"] or Color["slider_value_inactive"],
						min = minprice,
						max = maxprice,
						start = currentprice,
						hideMaxValue = true,
						suffix = ReadText(1001, 101),
						readOnly = not haspriceoverride,
						forceArrows = true,
					})
					row[1].handlers.onSliderCellChanged = function(_, value) return Helper.slidercellStorageWarePriceOverride(container, nodedata.ware, false, value) end
					row[1].handlers.onSliderCellActivated = function (id) menu.noupdate = true end
					row[1].handlers.onSliderCellDeactivated = function (id) menu.noupdate = false end
				end
				-- trade rule
				local hasownlist = C.HasContainerOwnTradeRule(container, "sell", nodedata.ware)
				local traderuleid = C.GetContainerTradeRuleID(container, "sell", nodedata.ware)
				local row = ftable:addRow(nil, {  })
				row[1]:setColSpan(3):createText(ReadText(1001, 11013) .. ReadText(1001, 120), textproperties)
				-- global
				local row = ftable:addRow("selltraderule_global", {  })
				row[1]:setColSpan(2):createText(ReadText(1001, 11025) .. ReadText(1001, 120), textproperties)
				row[3]:createCheckBox(not hasownlist, { height = Helper.standardButtonHeight })
				row[3].handlers.onClick = function(_, checked) return Helper.checkboxSetTradeRuleOverride(menu, container, "sell", nodedata.ware, checked) end
				-- current
				local row = ftable:addRow("selltraderule_current", {  })
				row[1]:setColSpan(2):createDropDown(Helper.traderuleOptions, { startOption = (traderuleid ~= 0) and traderuleid or -1, active = hasownlist }):setTextProperties({ fontsize = config.mapFontSize })
				row[1].handlers.onDropDownConfirmed = function (_, id) return Helper.dropdownTradeRule(menu, container, "sell", nodedata.ware, id) end
				row[1].handlers.onDropDownActivated = function () menu.noupdate = true end
				row[3]:createButton({ mouseOverText = ReadText(1026, 8407) }):setIcon("menu_edit")
				row[3].handlers.onClick = function () return Helper.buttonEditTradeRule(menu) end
			end
			-- create / remove offer
			if (waretype == "trade") or (waretype == "resource") then
				row = ftable:addRow("tradesell", {  })
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
				row = ftable:addRow(nil, {  })
				row[1]:setColSpan(3):createText(string.format(ReadText(1001, 7993), GetWareData(nodedata.ware, "name")) .. ReadText(1001, 120), { wordwrap = true })
				for i, reservation in ipairs(reservations[nodedata.ware].selloffer) do
					row = ftable:addRow("sellreservation" .. i, {  })
					if menu.selectedRowData["nodeTable"] == "sellreservation" then
						menu.selectedRows["nodeTable"] = row.index
						menu.selectedRowData["nodeTable"] = nil
					end
					local isplayerowned = GetComponentData(ConvertStringTo64Bit(tostring(reservation.reserver)), "isplayerowned")
					local name = (isplayerowned and ColorText["text_player"] or "") .. ffi.string(C.GetComponentName(reservation.reserver)) .. " (" .. ffi.string(C.GetObjectIDCode(reservation.reserver)) .. ")\27X"

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
					row[3]:createButton({ active = function () return Helper.buttonCancelTradeActive(menu, container, reservation.tradedeal) end, mouseOverText = ReadText(1026, 7924) }):setText("X", { halign = "center" })
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
			Helper.LSOStorageNodeBuySlider.widget.handlers.onSliderCellChanged = function(_, value) return Helper.slidercellBuyLimitOverride(menu, container, nodedata.ware, value, Helper.LSOStorageNodeSellSlider) end
			Helper.LSOStorageNodeBuySlider.widget.handlers.onSliderCellActivated = function (id) menu.noupdate = true end
			Helper.LSOStorageNodeBuySlider.widget.handlers.onSliderCellDeactivated = function (id) menu.noupdate = false end
		end
		if Helper.LSOStorageNodeSellSlider then 
			Helper.LSOStorageNodeSellSlider.widget.handlers.onSliderCellChanged = function(_, value) return Helper.slidercellSellLimitOverride(menu, container, nodedata.ware, value, Helper.LSOStorageNodeBuySlider) end
			Helper.LSOStorageNodeSellSlider.widget.handlers.onSliderCellActivated = function (id) menu.noupdate = true end
			Helper.LSOStorageNodeSellSlider.widget.handlers.onSliderCellDeactivated = function (id) menu.noupdate = false end
		end
	end

	if menu.selectedRowData["nodeTable"] then
		menu.selectedCols["nodeTable"] = nil
	end
	menu.restoreTableState("nodeTable", ftable)

	-- kuertee start: callback
	if callbacks ["onExpandLSOStorageNode"] then
		for _, callback in ipairs (callbacks ["onExpandLSOStorageNode"]) do
			callback(menu, container, ftable, nodedata)
		end
	end
	-- kuertee end: callback
end

function Helper.getStorageAmount(container, nodedata, storageinfo_amounts, storageinfo_capacity, accuracy, showvolume)
	local amount = GetComponentData(container, "cargo")[nodedata.ware] or 0
	local limit = GetWareProductionLimit(container, nodedata.ware)
	local defaultlimit = C.GetContainerWareMaxProductionStorageForTime(container, nodedata.ware, 7200, true)
	local volume = GetWareData(nodedata.ware, "volume")
	if nodedata.cargo and (limit == 0) then
		-- non-production, non-trade ware, don't show maximum
		return Helper.unlockInfo(storageinfo_amounts, ConvertIntegerString(amount, true, accuracy or 6, true, true) .. (showvolume and ("\n" .. ConvertIntegerString(volume * amount, true, accuracy or 6, true, true) .. " " .. ReadText(1001, 110)) or ""))
	else
		local waretype = Helper.getContainerWareType(container, nodedata.ware)
		local hasstoragewarning = (waretype ~= "trade") and (limit < defaultlimit)
		if showvolume then
			local extratext = ""
			if hasstoragewarning then
				extratext = "\n\n" .. ReadText(1001, 8467)
			end
			return string.format("%s%s / %s\n%s / %s%s", ((amount > limit) or hasstoragewarning) and ColorText["text_warning"] or "", Helper.unlockInfo(storageinfo_amounts, ConvertIntegerString(amount, true, accuracy or 3, true, true)), Helper.unlockInfo(storageinfo_capacity, ConvertIntegerString(limit, true, accuracy or 3, true, true)), Helper.unlockInfo(storageinfo_amounts, ConvertIntegerString(volume * amount, true, accuracy or 3, true, true)), Helper.unlockInfo(storageinfo_capacity, ConvertIntegerString(volume * limit, true, accuracy or 3, true, true)) .. " " .. ReadText(1001, 110), extratext)
		else
			return string.format("%s%s / %s", ((amount > limit) or hasstoragewarning) and ColorText["text_warning"] or "", Helper.unlockInfo(storageinfo_amounts, ConvertIntegerString(amount, true, accuracy or 3, true, true)), Helper.unlockInfo(storageinfo_capacity, ConvertIntegerString(limit, true, accuracy or 3, true, true)))
		end
	end
end

function Helper.getResourceBufferAmount(container, ware, storageinfo_amounts, accuracy)
	local amount = GetComponentData(container, "resourcebuffer")[ware] or 0
	return Helper.unlockInfo(storageinfo_amounts, ConvertIntegerString(amount, true, accuracy or 6, true, true))
end

function Helper.getWorkforceConsumption(container, ware)
	local resourceinfos = {}
	if C.IsComponentClass(container, "container") then
		resourceinfos = GetWorkForceRaceResources(container)
	end
	local amount = 0
	for _, resourceinfo in ipairs(resourceinfos) do
		local workforceinfo = C.GetWorkForceInfo(container, resourceinfo.race)
		for i, resource in ipairs(resourceinfo.resources) do
			if resource.ware == ware then
				amount = amount + Helper.round(resource.cycle * 3600 / resource.cycleduration * workforceinfo.current / resourceinfo.productamount)
			end
		end
	end
	return amount
end

function Helper.updateStorageLevel(menu, container, ware, value, buyslider, sellslider)
	if C.HasContainerBuyLimitOverride(container, ware) and (value < C.GetContainerBuyLimit(container, ware)) then
		Helper.setBuyLimit(menu, container, ware, value)
		if buyslider and (buyslider.ware == ware) then
			SetSliderCellValue(buyslider.widget.id, value)
		end
	else
		if buyslider and (buyslider.ware == ware) then
			SetSliderCellValue(buyslider.widget.id, C.GetContainerBuyLimit(container, ware))
		end
	end
	if C.HasContainerSellLimitOverride(container, ware) and (value < C.GetContainerSellLimit(container, ware)) then
		Helper.setSellLimit(menu, container, ware, value)
		if sellslider and (sellslider.ware == ware) then
			SetSliderCellValue(sellslider.widget.id, value)
		end
	else
		if sellslider and (sellslider.ware == ware) then
			SetSliderCellValue(sellslider.widget.id, C.GetContainerSellLimit(container, ware))
		end
	end
	if buyslider and (buyslider.ware == ware) then
		buyslider.widget:updateMaxSelectValue(value)
		buyslider.widget:updateMaxValue(value)
	end
	if sellslider and (sellslider.ware == ware) then
		sellslider.widget:updateMaxSelectValue(value)
		sellslider.widget:updateMaxValue(value)
	end
	menu.expandedNode:updateMaxValue(math.max(value, GetComponentData(container, "cargo")[ware] or 0))
end

function Helper.setBuyLimit(menu, container64, ware, limit)
	C.SetContainerBuyLimitOverride(container64, ware, limit)
	C.SetContainerWareIsBuyable(container64, ware, true)
	if menu.expandedNode and (menu.expandedNode.customdata.nodedata.ware == ware) then
		menu.expandedNode:updateSlider1(math.max(0, math.min(menu.expandedNode.properties.max, C.GetContainerBuyLimit(container64, ware))))
	end
end

function Helper.setSellLimit(menu, container64, ware, limit)
	C.SetContainerSellLimitOverride(container64, ware, limit)
	C.SetContainerWareIsSellable(container64, ware, true)
	if menu.expandedNode and (menu.expandedNode.customdata.nodedata.ware == ware) then
		menu.expandedNode:updateSlider2(math.max(0, math.min(menu.expandedNode.properties.max, C.GetContainerSellLimit(container64, ware))))
	end
end

function Helper.clearBuyLimit(menu, container64, ware)
	C.ClearContainerBuyLimitOverride(container64, ware)
	if menu.expandedNode and (menu.expandedNode.customdata.nodedata.ware == ware) then
		menu.expandedNode:updateSlider1(nil)
	end
end

function Helper.clearSellLimit(menu, container64, ware)
	C.ClearContainerSellLimitOverride(container64, ware)
	if menu.expandedNode and (menu.expandedNode.customdata.nodedata.ware == ware) then
		menu.expandedNode:updateSlider2(nil)
	end
end

function Helper.buttonCancelTradeActive(menu, container, tradeid)
	if not C.IsValidTrade(tradeid) then
		menu.refreshnode = getElapsedTime()
		return
	end
	return C.CancelPlayerInvolvedTradeDeal(container, tradeid, true)
end

function Helper.buttonCancelTrade(menu, container, tradeid)
	if C.CancelPlayerInvolvedTradeDeal(container, tradeid, false) then
		-- The ware reservation is only implicitly removed after the trade was purged which only happens with a delay in gametime. To avoid no change in the menu after pressing the button, we hide the reservation now.
		Helper.dirtyreservations[tostring(tradeid)] = true
	end
	menu.updateExpandedNode()
end

function Helper.buttonStorageBuyProductWare(menu, container64, ware, haslimitoverride, currentlimit)
	if haslimitoverride then
		Helper.clearBuyLimit(menu, container64, ware)
		C.SetContainerWareIsBuyable(container64, ware, false)
	else
		Helper.setBuyLimit(menu, container64, ware, math.max(1, currentlimit))
	end

	menu.updateExpandedNode()
end

function Helper.buttonStorageBuyTradeWare(menu, container64, ware, istradewarebought)
	local istradewaresold = C.GetContainerWareIsSellable(container64, ware)

	if not istradewaresold then
		if not istradewarebought then
			C.AddTradeWare(container64, ware)
		else
			ClearContainerStockLimitOverride(container64, ware)
		end
	end

	if istradewarebought then
		Helper.clearBuyLimit(menu, container64, ware)
	end
	C.SetContainerWareIsBuyable(container64, ware, not istradewarebought)

	menu.updateExpandedNode()
end

function Helper.buttonStorageSellResourceWare(menu, container64, ware, haslimitoverride, currentlimit)
	if haslimitoverride then
		Helper.clearSellLimit(menu, container64, ware)
		C.SetContainerWareIsSellable(container64, ware, false)
	else
		Helper.setSellLimit(menu, container64, ware, currentlimit)
	end

	menu.updateExpandedNode()
end

function Helper.buttonStorageSellTradeWare(menu, container64, ware, istradewaresold)
	local istradewarebought = C.GetContainerWareIsBuyable(container64, ware)

	if not istradewarebought then
		if not istradewaresold then
			C.AddTradeWare(container64, ware)
		else
			ClearContainerStockLimitOverride(container64, ware)
		end
	end

	if istradewaresold then
		Helper.clearSellLimit(menu, container64, ware)
	end
	C.SetContainerWareIsSellable(container64, ware, not istradewaresold)

	menu.updateExpandedNode()
end

function Helper.buttonEditTradeRule(menu)
	Helper.closeMenuAndOpenNewMenu(menu, "PlayerInfoMenu", { 0, 0, "globalorders" })
	menu.cleanup()
end

function Helper.checkboxStorageLevelOverride(menu, container, ware, row, currentlimit, checked)
	if checked then
		ClearContainerStockLimitOverride(container, ware)
		local value = GetWareProductionLimit(container, ware)
		Helper.updateStorageLevel(menu, container, ware, value)
		menu.updateExpandedNode(row, 3)
	else
		SetContainerStockLimitOverride(container, ware, math.max(1, currentlimit))
		menu.updateExpandedNode(row, 3)
	end
end

function Helper.checkboxBuyLimitOverride(menu, container, ware, row, currentlimit, checked)
	if checked then
		Helper.clearBuyLimit(menu, container, ware)
		if Helper.LSOStorageNodeBuySlider and (Helper.LSOStorageNodeBuySlider.ware == ware) then
			SetSliderCellValue(Helper.LSOStorageNodeBuySlider.widget.id, C.GetContainerBuyLimit(container, ware))
		end
	else
		currentlimit = math.min(currentlimit, C.GetContainerSellLimit(container, ware))
		if currentlimit == 0 then
			-- trade ware case. For tradewares a non-override buylimit of 0 means it buys until the "production" limit. So init with that value to keep functionality consistent.
			currentlimit = GetWareProductionLimit(container, ware)
		end
		Helper.setBuyLimit(menu, container, ware, currentlimit)
	end
	menu.updateExpandedNode(row, 3)
end

function Helper.checkboxSellLimitOverride(menu, container, ware, row, currentlimit, checked)
	if checked then
		Helper.clearSellLimit(menu, container, ware)
	else
		currentlimit = math.max(1, math.max(currentlimit, C.GetContainerBuyLimit(container, ware)))
		Helper.setSellLimit(menu, container, ware, currentlimit)
	end
	menu.updateExpandedNode(row, 3)
end

function Helper.checkboxStorageWarePriceOverride(menu, container, ware, row, buysellswitch, price, checked)
	if checked then
		ClearContainerWarePriceOverride(container, ware, buysellswitch)
	else
		SetContainerWarePriceOverride(container, ware, buysellswitch, price)
	end

	menu.updateExpandedNode(row, 3)
end
	 
function Helper.checkboxSetTradeRuleOverride(menu, container, type, ware, checked)
	if checked then 
		C.SetContainerTradeRule(container, -1, type, ware, false)
	else
		local currentid = C.GetContainerTradeRuleID(container, type, ware or "")
		C.SetContainerTradeRule(container, (currentid ~= 0) and currentid or -1, type, ware, true)
	end

	if (type == "buy") or (type == "sell") then

		-- kuertee start: callback
		if callbacks ["checkboxSetTradeRuleOverride_pre_update_expanded_node"] then
			-- function widgetPrototypes.flowchartnode:updateStatus(text, icon, bgicon, color, mouseovertext)
			local status_text = nil
			local status_icon = Helper.isTradeRestricted(container, ware) and "lso_error" or nil
			local status_bgicon = nil
			local status_color = Color["icon_warning"]
			local status_mouseovertext
			for _, callback in ipairs (callbacks ["checkboxSetTradeRuleOverride_pre_update_expanded_node"]) do
				status_text, status_icon, status_bgicon, status_color, status_mouseovertext = callback(menu, container, type, ware, checked, status_text, status_icon, status_bgicon, status_color, status_mouseovertext)
			end
			menu.expandedNode:updateStatus(status_text, status_icon, status_bgicon, status_color, status_mouseovertext)
		else

			menu.expandedNode:updateStatus(nil, Helper.isTradeRestricted(container, ware) and "lso_error" or nil, nil, Color["icon_warning"])
		end
		-- kuertee end: callback

	end
	menu.updateExpandedNode()
end

function Helper.dropdownAssignment(_, ship, subordinategroupid, commander, newassignment)
	if (not ship and (not subordinategroupid or not commander)) then
		DebugError("Helper.dropdownAssignment called with neither ship nor valid subordinategroup specified. If working with subordinategroup, commander must also be specified.")
		return
	end

	local currentassignment
	if ship then
		currentassignment = GetComponentData(ship, "assignment")
	else
		currentassignment = ffi.string(C.GetSubordinateGroupAssignment(ConvertIDTo64Bit(commander), subordinategroupid))
	end

	--print("Helper.dropdownAssignment. changing assignment from " .. tostring(currentassignment) .. " to " .. tostring(newassignment))

	if newassignment ~= currentassignment then
		if ship then
			local commander = GetCommander(ship)
			local orderindex = C.CreateOrder(ship, "AssignCommander", false)
		
			if orderindex > 0 then
				-- commander
				SetOrderParam(ship, orderindex, 1, nil, ConvertStringToLuaID(tostring(commander)))
				-- assignment
				SetOrderParam(ship, orderindex, 2, nil, newassignment)

				C.EnableOrder(ship, orderindex)
				if orderindex ~= 1 then
					C.AdjustOrder(ship, orderindex, 1, true, false, false)
				end
			end
		else
			if newassignment == "positiondefence" then
				Helper.setIntersectorDefence(ConvertIDTo64Bit(commander), subordinategroupid)
			end

			local numsubordinates = C.GetNumSubordinatesOfGroup(commander, subordinategroupid)
			local subordinates = ffi.new("UniverseID[?]", numsubordinates)
			numsubordinates = C.GetSubordinatesOfGroup(subordinates, numsubordinates, commander, subordinategroupid)
			--print("got " .. tostring(numsubordinates) .. " subordinates in group " .. tostring(subordinategroupid))

			for i = 0, numsubordinates - 1 do
				local subordinate = ConvertStringTo64Bit(tostring(subordinates[i]))
				local orderindex = C.CreateOrder(subordinate, "AssignCommander", false)

				if orderindex > 0 then
					-- commander
					SetOrderParam(subordinate, orderindex, 1, nil, ConvertStringToLuaID(tostring(commander)))
					-- assignment
					SetOrderParam(subordinate, orderindex, 2, nil, newassignment)
					-- subordinategroupid
					SetOrderParam(subordinate, orderindex, 3, nil, subordinategroupid)

					C.EnableOrder(subordinate, orderindex)
					if orderindex ~= 1 then
						C.AdjustOrder(subordinate, orderindex, 1, true, false, false)
					end
				end
			end

			C.SetSubordinateGroupAssignment(commander, subordinategroupid, newassignment)
		end
	end
end

function  Helper.dropdownTradeRule(menu, container, type, ware, id)
	C.SetContainerTradeRule(container, tonumber(id), type, ware, true)
	
	if (type == "buy") or (type == "sell") then

		-- kuertee start: callback
		if callbacks ["dropdownTradeRule_pre_update_expanded_node"] then
			-- function widgetPrototypes.flowchartnode:updateStatus(text, icon, bgicon, color, mouseovertext)
			local status_text = nil
			local status_icon = Helper.isTradeRestricted(container, ware) and "lso_error" or nil
			local status_bgicon = nil
			local status_color = Color["icon_warning"]
			local status_mouseovertext = nil
			for _, callback in ipairs (callbacks ["dropdownTradeRule_pre_update_expanded_node"]) do
				status_text, status_icon, status_bgicon, status_color, status_mouseovertext = callback(menu, container, type, ware, id, status_text, status_icon, status_bgicon, status_color, status_mouseovertext)
			end
			menu.expandedNode:updateStatus(status_text, status_icon, status_bgicon, status_color, mouseOverText)
		else

			menu.expandedNode:updateStatus(nil, Helper.isTradeRestricted(container, ware) and "lso_error" or nil, nil, Color["icon_warning"])
		end
		-- kuertee end: callback

	end
	menu.noupdate = false
end

function Helper.slidercellBuyLimitOverride(menu, container, ware, value, sellslider)
	if value then
		Helper.setBuyLimit(menu, container, ware, value)
		if sellslider and (sellslider.ware == ware) then
			SetSliderCellValue(sellslider.widget.id, C.GetContainerSellLimit(container, ware))
		end
	end
end

function Helper.slidercellSellLimitOverride(menu, container, ware, value, buyslider)
	if value then
		Helper.setSellLimit(menu, container, ware, value)
		if buyslider and (buyslider.ware == ware) then
			SetSliderCellValue(buyslider.widget.id, C.GetContainerBuyLimit(container, ware))
		end
	end
end

function Helper.slidercellStorageLevelOverride(menu, container, ware, value, buyslider, sellslider)
	if value then
		SetContainerStockLimitOverride(container, ware, value)
		Helper.updateStorageLevel(menu, container, ware, value, buyslider, sellslider)
	end
end

function Helper.slidercellStorageWarePriceOverride(container, ware, buysellswitch, value)
	if value then
		SetContainerWarePriceOverride(container, ware, buysellswitch, value)
	end
end

function Helper.onCollapseLSOStorageNode(menu, nodedata)
	UnregisterEvent("newWareReservation", menu.newWareReservationCallback)
	menu.wareReservationRegistered = nil
	Helper.LSOStorageNodeBuySlider = nil
	Helper.LSOStorageNodeSellSlider = nil

	-- kuertee start: callback
	if callbacks ["onCollapseLSOStorageNode"] then
		for _, callback in ipairs (callbacks ["onCollapseLSOStorageNode"]) do
			callback (menu, nodedata)
		end
	end
	-- kuertee end: callback
end

function Helper.onSliderChangedLSOStorageNode(container, node, nodedata, slideridx, value)
	if value then
		if value == 0 then
			value = 1
			if slideridx == 1 then
				node:updateSlider1(value)
			else
				node:updateSlider2(value)
			end
		end

		local ware = nodedata.ware
		local productionlimit = GetWareProductionLimit(container, ware)
		if value > productionlimit then
			value = productionlimit
			if slideridx == 1 then
				node:updateSlider1(value)
			else
				node:updateSlider2(value)
			end
		end
		if slideridx == 1 then
			C.SetContainerBuyLimitOverride(container, ware, value)
			if Helper.LSOStorageNodeBuySlider and (Helper.LSOStorageNodeBuySlider.ware == ware) then
				SetSliderCellValue(Helper.LSOStorageNodeBuySlider.widget.id, value)
			end
		else
			C.SetContainerSellLimitOverride(container, ware, value)
			if Helper.LSOStorageNodeSellSlider and (Helper.LSOStorageNodeSellSlider.ware == ware) then
				SetSliderCellValue(Helper.LSOStorageNodeSellSlider.widget.id, value)
			end
			if Helper.LSOStorageNodeBuySlider and (Helper.LSOStorageNodeBuySlider.ware == ware) then
				SetSliderCellValue(Helper.LSOStorageNodeBuySlider.widget.id, C.GetContainerBuyLimit(container, ware))
			end
		end
	end
end

Helper.turretModes = {
	[1] = { id = "defend",			text = ReadText(1001, 8613),	icon = "",	displayremoveoption = false,	forall = true },
	[2] = { id = "attackenemies",	text = ReadText(1001, 8614),	icon = "",	displayremoveoption = false,	forall = true },
	[3] = { id = "attackcapital",	text = ReadText(1001, 8634),	icon = "",	displayremoveoption = false,	forall = true },
	[4] = { id = "prefercapital",	text = ReadText(1001, 8637),	icon = "",	displayremoveoption = false,	forall = true },
	[5] = { id = "attackfighters",	text = ReadText(1001, 8635),	icon = "",	displayremoveoption = false,	forall = true },
	[6] = { id = "preferfighters",	text = ReadText(1001, 8638),	icon = "",	displayremoveoption = false,	forall = true },
	[7] = { id = "missiledefence",	text = ReadText(1001, 8636),	icon = "",	displayremoveoption = false,	forall = true },
	[8] = { id = "prefermissiles",	text = ReadText(1001, 8639),	icon = "",	displayremoveoption = false,	forall = true },
	[9] = { id = "autoassist",		text = ReadText(1001, 8617),	icon = "",	displayremoveoption = false,	forall = true },
	[10] = { id = "mining",			text = ReadText(1001, 8616),	icon = "",	displayremoveoption = false,	forall = true },
	[11] = { id = "towing",			text = ReadText(1001, 8633),	icon = "",	displayremoveoption = false,	forall = false },
}

function Helper.getTurretModes(turret, forall, helpoverlayprefix, counter)
	local options = {}
	for _, entry in ipairs(Helper.turretModes) do
		if (not forall) or (forall == entry.forall) then
			if (turret == nil) or C.IsWeaponModeCompatible(turret, "", entry.id) then
				table.insert(options, Helper.tableCopy(entry))
				if helpoverlayprefix then
					options[#options].helpOverlayID = helpoverlayprefix .. entry.id .. (counter or "")
					options[#options].helpOverlayText = " "
					options[#options].helpOverlayHighlightOnly = true
				end
			end
		end
	end
	return options
end

function Helper.getMacroTurretModes(turret, forall)
	local options = {}
	for _, entry in ipairs(Helper.turretModes) do
		if (not forall) or (forall == entry.forall) then
			if (turret == "") or C.IsWeaponModeCompatible(0, turret, entry.id) then
				table.insert(options, entry)
			end
		end
	end
	return options
end

function Helper.createDropWaresContext(menu, frame, instance)
	local lockboxes = {}
	local player = C.GetPlayerID()
	local n = C.GetNumAvailableLockboxes(player)
	local buf = ffi.new("const char*[?]", n)
	n = C.GetAvailableLockboxes(buf, n, player)
	for i = 0, n - 1 do
		table.insert(lockboxes, GetWareData(ffi.string(buf[i]), "component"))
	end

	local curOption = menu.contextMenuData.dropLockbox or "none"
	local options = {
		{ id = "none", text = ReadText(1001, 7731), icon = "", displayremoveoption = false }
	}
	for _, box in ipairs(lockboxes) do
		if (menu.contextMenuData.dropLockbox == nil) and (curOption == "none") then
			menu.contextMenuData.dropLockbox = box
			curOption = box
		end
		table.insert(options, { id = box, text = GetMacroData(box, "name"), icon = "", displayremoveoption = false })
	end

	local ftable = frame:addTable(3, { tabOrder = 3, x = Helper.borderSize, y = Helper.borderSize, width = menu.contextMenuData.width })
	if menu.contextMenuData.mode == "ventureconvert" then
		ftable:setColWidthPercent(1, 40)
		ftable:setColWidthPercent(3, 40)
	end

	local row = ftable:addRow(false, { fixed = true, bgColor = Color["row_background_blue"] })
	if menu.contextMenuData.mode == "venturedonate" then
		row[1]:setColSpan(3):createText(ReadText(1001, 11530), Helper.headerRowCenteredProperties)
	elseif menu.contextMenuData.mode == "ventureconvert" then
		row[1]:setColSpan(3):createText(ReadText(1001, 11381), Helper.headerRowCenteredProperties)
	else
		row[1]:setColSpan(3):createText(ReadText(1001, 7733), Helper.headerRowCenteredProperties)
	end

	for _, entry in ipairs(menu.contextMenuData.wares) do
		local conversionrate = entry.conversionrate or 1
		local slidermax = entry.amount * conversionrate

		local text = entry.name
		if menu.contextMenuData.mode == "ventureconvert" then
			text = string.format(ReadText(1001, 11385), entry.convertedname)
		end

		row = ftable:addRow(true, { fixed = true })
		row[1]:setColSpan(3):createSliderCell({ height = Helper.standardTextHeight, min = 0, max = slidermax, start = slidermax, step = conversionrate }):setText(text)
		row[1].handlers.onSliderCellChanged = function (_, value) return Helper.slidercellDropWares(menu, entry.ware, value / conversionrate) end
	end

	if menu.contextMenuData.mode == "ventureconvert" then
		local waredata = menu.contextMenuData.wares[1]
		if waredata then
			local row = ftable:addRow(nil, {  })
			row[1]:setColSpan(3):createText("1" .. ReadText(1001, 42) .. " " .. waredata.name .. " = " .. waredata.conversionrate .. ReadText(1001, 42) .. " " .. waredata.convertedname, { halign = "right" })

			ftable:addEmptyRow()

			row = ftable:addRow(true, { fixed = true })
			row[1]:setColSpan(3):createText(string.format(ReadText(1001, 11559), waredata.name, waredata.convertedname) .. "\n" .. string.format(ReadText(1001, 11562), waredata.convertedname), { wordwrap = true })
		end
	elseif menu.contextMenuData.mode ~= "venturedonate" then
		ftable:addEmptyRow()

		row = ftable:addRow(true, { fixed = true })
		row[1]:createText(ReadText(1001, 7732))
		row[2]:setColSpan(2):createDropDown(options, { startOption = curOption })
		row[2].handlers.onDropDownConfirmed = function (_, id) return Helper.dropdownDropWaresLockbox(menu, id) end
	end

	row = ftable:addRow(true, { fixed = true })
	if menu.contextMenuData.mode == "venturedonate" then
		row[1]:createButton({  }):setText(ReadText(1001, 11530), { halign = "center" })
		row[1].handlers.onClick = function () return Helper.callExtensionFunction("multiverse", "donateVentureItem", menu) end
	elseif menu.contextMenuData.mode == "ventureconvert" then
		local name = ReadText(1001, 11381)
		if menu.contextMenuData.success ~= nil then
			name = menu.contextMenuData.success and ReadText(1001, 11383) or ReadText(1001, 11382)
		elseif menu.contextMenuData.converting ~= nil then
			name = ReadText(1001, 11384)
		end
		row[1]:createButton({ active = (menu.contextMenuData.success == nil) and (menu.contextMenuData.converting == nil) }):setText(((menu.contextMenuData.success ~= nil) and Helper.convertColorToText((menu.contextMenuData.success == -1) and Color["text_success"] or Color["text_failure"]) or "") .. name, { halign = "center" })
		row[1].handlers.onClick = function () return Helper.callExtensionFunction("multiverse", "convertVentureItem", menu) end
	else
		row[1]:createButton({  }):setText((#menu.contextMenuData.wares > 1) and ReadText(1001, 7733) or ReadText(1001, 7705), { halign = "center" })
		row[1].handlers.onClick = function () return Helper.buttonDropWares(menu) end
	end
	row[3]:createButton({ active = (menu.contextMenuData.mode ~= "ventureconvert") or (not menu.contextMenuData.success) }):setText(ReadText(1001, 64), { halign = "center" })
	row[3].handlers.onClick = function () return menu.onCloseElement("back") end
end

function Helper.slidercellDropWares(menu, ware, value)
	for _, entry in ipairs(menu.contextMenuData.wares) do
		if entry.ware == ware then
			entry.amount = value
		end
	end
end

function Helper.dropdownDropWaresLockbox(menu, id)
	menu.contextMenuData.dropLockbox = id
end

function Helper.buttonDropWares(menu)
	local wares = ffi.new("UIWareAmount[?]", #menu.contextMenuData.wares)

	for i, entry in ipairs(menu.contextMenuData.wares) do
		wares[i - 1].wareid = Helper.ffiNewString(entry.ware)
		wares[i - 1].amount = entry.amount
	end

	local lockbox = menu.contextMenuData.dropLockbox
	if lockbox == "none" then
		lockbox = nil
	end
	if menu.contextMenuData.mode == "inventory" then
		C.DropInventory(menu.contextMenuData.entity, lockbox, wares, #menu.contextMenuData.wares)
	end

	menu.closeContextMenu()
end

-- indents given text with given char sequence
-- takes necessary linebreaks into account according to textboxwidth, font and fontsize
function Helper.indentText(text, indentstring, textboxwidth, font, fontsize)
	local width = textboxwidth - C.GetTextWidth(indentstring .. "\n", font, fontsize)
	local textTable = GetTextLines(text, font, fontsize, width)

	indentedText = ""
	for i, line in ipairs(textTable) do
		indentedText = indentedText .. indentstring .. line
		if i < #textTable then
			indentedText = indentedText .. "\n"
		end
	end

	return indentedText
end

function Helper.registerStationEditorChanges()
	Helper.confirmDiscardStationEditorChanges = true
end

function Helper.unregisterStationEditorChanges()
	Helper.confirmDiscardStationEditorChanges = nil
end

function Helper.checkDiscardStationEditorChanges(menu, dueToClose)
	if Helper.confirmDiscardStationEditorChanges then
		Helper.closeMenuAndOpenNewMenu(menu, "UserQuestionMenu", { 0, 0, "discardstationeditor" })
		if menu.cleanup then
			menu.cleanup()
		end
		return true
	end
	Helper.clearStationEditorState()
	return false
end

function Helper.registerStationEditorState(menu)
	Helper.stationEditorState = menu
end

function Helper.clearStationEditorState()
	if Helper.stationEditorState then
		C.ReleaseConstructionMapState()
		Helper.stationEditorState.state = nil
		Helper.stationEditorState = nil
	end
end

function Helper.getBlackLists()
	local blacklists = {}
	Helper.ffiVLA(blacklists, "BlacklistID", C.GetNumAllBlacklists, C.GetAllBlacklists)
	for i = #blacklists, 1, -1 do
		local id = blacklists[i]

		local counts = C.GetBlacklistInfoCounts(id)
		local buf = ffi.new("BlacklistInfo2")
		buf.nummacros = counts.nummacros
		buf.macros = Helper.ffiNewHelper("const char*[?]", counts.nummacros)
		buf.numfactions = counts.numfactions
		buf.factions = Helper.ffiNewHelper("const char*[?]", counts.numfactions)
		if C.GetBlacklistInfo2(buf, id) then
			local type = ffi.string(buf.type)

			local spaces = {}
			for j = 0, buf.nummacros - 1 do
				table.insert(spaces, ConvertIDTo64Bit(GetMacroData(ffi.string(buf.macros[j]), "sectorcomponent")))
			end

			local factions = {}
			for j = 0, buf.numfactions - 1 do
				table.insert(factions, ffi.string(buf.factions[j]))
			end

			local defaults = {
				["civilian"] = C.IsPlayerBlacklistDefault(id, type, "civilian"),
				["military"] = C.IsPlayerBlacklistDefault(id, type, "military"),
			}

			blacklists[i] = { id = id, type = type, name = ffi.string(buf.name), spaces = spaces, factions = factions, relation = ffi.string(buf.relation), hazardous = buf.hazardous, defaults = defaults, usemacrowhitelist = buf.usemacrowhitelist, usefactionwhitelist = buf.usefactionwhitelist }
		else
			table.remove(blacklists, i)
		end
	end
	table.sort(blacklists, Helper.sortID)

	return blacklists
end

function Helper.getFightRules()
	local fightrules = {}
	Helper.ffiVLA(fightrules, "FightRuleID", C.GetNumAllFightRules, C.GetAllFightRules)
	for i = #fightrules, 1, -1 do
		local id = fightrules[i]

		local counts = C.GetFightRuleInfoCounts(id)
		local buf = ffi.new("FightRuleInfo")
		buf.numfactions = counts.numfactions
		buf.factions = Helper.ffiNewHelper("UIFightRuleSetting[?]", counts.numfactions)
		if C.GetFightRuleInfo(buf, id) then
			local settings = {}
			for j = 0, buf.numfactions - 1 do
				local faction = ffi.string(buf.factions[j].factionid)
				local civilian = ffi.string(buf.factions[j].civiliansetting)
				if civilian == "" then
					civilian = "default"
				end
				local military = ffi.string(buf.factions[j].militarysetting)
				if military == "" then
					military = "default"
				end
				settings[faction] = { civilian = civilian, military = military }
			end

			local defaults = {
				["attack"] = C.IsPlayerFightRuleDefault(id, "attack"),
			}

			fightrules[i] = { id = id, name = ffi.string(buf.name), settings = settings, defaults = defaults }
		else
			table.remove(fightrules, i)
		end
	end
	table.sort(fightrules, Helper.sortID)

	return fightrules
end

function Helper.setIntersectorDefence(controllable, group, reset, sectorid, pos_in)
	local locsectorid = sectorid or GetComponentData(controllable, "sectorid")
	local pos = pos_in or C.GetObjectPositionInSector(controllable)

	local int, frac = math.modf(group / 2)
	local zoffset = int * ((frac > 0) and 1 or -1)
	local locpos = ffi.new("UIPosRot", { x = pos.x + Helper.intersectorDefenceFactor, y = pos.y, z = pos.z + zoffset * Helper.intersectorDefenceFactor })
	C.SetSubordinateGroupProtectedLocation(controllable, group, reset and 0 or ConvertIDTo64Bit(locsectorid), locpos)
	if reset then
		C.ReleaseDetachedSubordinateGroup(controllable, group)
	else
		C.SetSubordinateGroupAssignment(controllable, group, "positiondefence")
	end
end

function Helper.getDisplayableGateDestinationSpace(gate)
	-- If jump gate leads to a different star system, only show system (cluster) name
	-- Note: See identical logic in MissionManager, Gate::GetSpokenName() and MD (Notifications.xml, cue "ChangedSpace")
	local destgate = GetComponentData(gate, "destination")
	if destgate then
		local origcluster = GetContextByClass(gate, "cluster")
		local destcluster = GetContextByClass(destgate, "cluster")
		if origcluster and destcluster then
			local origsystemid = GetComponentData(origcluster, "systemid")
			local destsystemid = GetComponentData(destcluster, "systemid")
			if origcluster == destcluster or (destsystemid ~= 0 and origsystemid == destsystemid) or (not IsInfoUnlockedForPlayer(destcluster, "name")) then
				-- Gate leads to same cluster or same system: Show sector name instead
				-- Gate leads to unknown cluster: Show sector name (which defaults to Unknown sector)
				-- Note: All clusters within a system are supposed to have the same name (the system name)
				return GetContextByClass(destgate, "sector")
			else
				return destcluster
			end
		end
	end
	return nil
end

function Helper.getHoloMapColors()
	local productioncolor, buildcolor, storagecolor, radarcolor, dronedockcolor, efficiencycolor, defencecolor, playercolor, friendcolor, enemycolor, missioncolor, currentplayershipcolor, visitorcolor, lowalertcolor, mediumalertcolor, highalertcolor, gatecolor, highwaygatecolor, missilecolor, superhighwaycolor, highwaycolor, hostilecolor = GetHoloMapColors()
	return { productioncolor = productioncolor, buildcolor = buildcolor, storagecolor = storagecolor, radarcolor = radarcolor, dronedockcolor = dronedockcolor, efficiencycolor = efficiencycolor, defencecolor = defencecolor, playercolor = playercolor, friendcolor = friendcolor, enemycolor = enemycolor, missioncolor = missioncolor, currentplayershipcolor = currentplayershipcolor, visitorcolor = visitorcolor, lowalertcolor = lowalertcolor, mediumalertcolor = mediumalertcolor, highalertcolor = highalertcolor, gatecolor = gatecolor, highwaygatecolor = highwaygatecolor, missilecolor = missilecolor, superhighwaycolor = superhighwaycolor, highwaycolor = highwaycolor, hostilecolor = hostilecolor }
end

Helper.chatParams = {}

function Helper.getInputMouseOverText(input)
	local inputstring = ffi.string(C.GetMappedInputName(input))
	if inputstring ~= "" then
		return ReadText(1001, 508) .. ReadText(1001, 120) .. " " .. inputstring
	end
	return ""
end

Helper.ventureContactsMode = { left = "friends", right = "friends" }
Helper.ventureContactsConfig = {
	pageSize = 30,
	contextBorder = 5,
}
Helper.ventureContactsCategories = {
	{ category = "friends",					name = ReadText(1001, 11386),	icon = "vt_friendlist",				helpOverlayID = "mapst_ven_contacts_friend",	helpOverlayText = ReadText(1028, 7720) },
}

if C.IsVentureSeasonSupported() then
	table.insert(Helper.ventureContactsCategories, { category = "blocked",					name = ReadText(1001, 11366),	icon = "vt_blockedlist",			helpOverlayID = "mapst_ven_contacts_blocked",	helpOverlayText = ReadText(1028, 7721) })
end

function Helper.createVentureContacts(menu, frame, instance, width, x, y, globalx, globaly)
	if Helper.ventureContactsMode.left == "friends" then
		Helper.createVentureContactsTab(menu, frame, instance, "friends", width, x, y, globalx, globaly)
	elseif Helper.ventureContactsMode.left == "blocked" then
		Helper.createVentureContactsTab(menu, frame, instance, "blocked", width, x, y, globalx, globaly)
	end
end

function Helper.createVentureContactsTab(menu, frame, instance, mode, width, x, y, globalx, globaly)
	if (not C.IsVentureSeasonSupported()) and (mode == "blocked") then
		-- make sure we cannot be in "blocked" mode, if blocked mode is not supported
		mode = "friends"
	end
	local infoTablePersistentData = menu.infoTablePersistentData[instance].venturecontacts
	Helper.ventureContactsMode.width = width
	Helper.ventureContactsMode.x = globalx
	Helper.ventureContactsMode.y = globaly

	local numCols = 10
	local buttonsize = Helper.scaleY(Helper.standardTextHeight)
	local infotable = frame:addTable(numCols, { tabOrder = 1, maxVisibleHeight = menu.infoFrame.properties.height, width = width, x = x, y = y })
	if menu.setdefaulttable then
		infotable.properties.defaultInteractiveObject = true
		menu.setdefaulttable = nil
	end
	infotable:setColWidth(1, width / 3, false)
	infotable:setColWidth(4, Helper.standardTextHeight)
	infotable:setColWidth(5, Helper.standardTextHeight)
	infotable:setColWidth(6, Helper.standardTextHeight)
	infotable:setColWidth(7, Helper.standardTextHeight)
	infotable:setColWidth(8, width / 3 - 4 * (buttonsize + Helper.borderSize), false)
	infotable:setColWidth(9, Helper.standardTextHeight)
	infotable:setColWidth(10, Helper.standardTextHeight)

	-- title
	local row = infotable:addRow(nil, { fixed = true, bgColor = Color["row_title_background"] })
	row[1]:setColSpan(numCols):createText((mode == "friends") and ReadText(1001, 11386) or ReadText(1001, 11366), Helper.titleTextProperties)

	infoTablePersistentData.numEntries = OnlineGetNumContacts(mode == "blocked")
	Helper.ventureContacts = {}
	if infoTablePersistentData.searchtext ~= "" then
		local contacts = OnlineGetContacts(0, 0, mode == "blocked")
		for _, entry in ipairs(contacts) do
			if Helper.contactSearchHelper(entry, infoTablePersistentData.searchtext) then
				table.insert(Helper.ventureContacts, entry)
			end
		end

		infoTablePersistentData.numEntries = #Helper.ventureContacts
		if infoTablePersistentData.numEntries <= Helper.ventureContactsConfig.pageSize then
			infoTablePersistentData.curPage = 1
		else
			local startIndex = infoTablePersistentData.numEntries - Helper.ventureContactsConfig.pageSize * infoTablePersistentData.curPage + 1
			local endIndex = Helper.ventureContactsConfig.pageSize + startIndex - 1
			if startIndex < 1 then
				startIndex = 1
			end
			Helper.ventureContacts = { table.unpack(Helper.ventureContacts, startIndex, endIndex) }
		end
	else
		local startIndex = 1
		if infoTablePersistentData.numEntries <= Helper.ventureContactsConfig.pageSize then
			infoTablePersistentData.curPage = 1
		else
			startIndex = Helper.ventureContactsConfig.pageSize * (infoTablePersistentData.curPage - 1) + 1
			if startIndex < 1 then
				startIndex = 1
			end
		end
		Helper.ventureContacts = OnlineGetContacts(Helper.ventureContactsConfig.pageSize, startIndex, mode == "blocked")
	end
	infoTablePersistentData.numPages = math.max(1, math.ceil(infoTablePersistentData.numEntries / Helper.ventureContactsConfig.pageSize))

	-- pages
	local row = infotable:addRow(true, { fixed = true })
	row[1]:setColSpan(3):createEditBox({ description = ReadText(1001, 11390), defaultText = ReadText(1001, 3250) }):setText(infoTablePersistentData.searchtext, { halign = "left", x = Helper.standardTextOffsetx }):setHotkey("INPUT_STATE_DETAILMONITOR_0", { displayIcon = true })
	row[1].handlers.onEditBoxDeactivated = function (_, text) if text ~= infoTablePersistentData.searchtext then infoTablePersistentData.searchtext = text; menu.noupdate = false; menu.refreshInfoFrame() end end

	local buttonheight = math.max(Helper.editboxMinHeight, Helper.scaleY(Helper.subHeaderHeight))
	row[4]:createButton({ scaling = false, width = buttonsize, height = buttonheight, cellBGColor = Color["row_background"] }):setText("X", { halign = "center", font = Helper.standardFontBold })
	row[4].handlers.onClick = function () infoTablePersistentData.searchtext = ""; menu.refreshInfoFrame() end

	row[5]:createButton({ scaling = false, active = infoTablePersistentData.curPage > 1, width = buttonsize, height = buttonheight, cellBGColor = Color["row_background"] }):setIcon("widget_arrow_skip_left_01", { width = buttonsize, height = buttonsize, y = (row:getHeight() - buttonsize) / 2 })
	row[5].handlers.onClick = function () infoTablePersistentData.curPage = 1; menu.refreshInfoFrame() end
	row[6]:createButton({ scaling = false, active = infoTablePersistentData.curPage > 1, width = buttonsize, height = buttonheight, cellBGColor = Color["row_background"] }):setIcon("widget_arrow_left_01", { width = buttonsize, height = buttonsize, y = (row:getHeight() - buttonsize) / 2 })
	row[6].handlers.onClick = function () infoTablePersistentData.curPage = infoTablePersistentData.curPage - 1; menu.refreshInfoFrame() end
	Helper.contactsPageEditBox = row[7]:setColSpan(2):createEditBox({ description = ReadText(1001, 7739) }):setText(infoTablePersistentData.curPage .. " / " .. infoTablePersistentData.numPages, { halign = "center" })
	row[7].handlers.onEditBoxActivated = function (widget) return Helper.editboxVentureContactsPageActivated(menu, widget, instance) end
	row[7].handlers.onEditBoxDeactivated = function (_, text, textchanged) return Helper.editboxVentureContactsPage(menu, instance, text, textchanged) end
	row[9]:createButton({ scaling = false, active = infoTablePersistentData.curPage < infoTablePersistentData.numPages, width = buttonsize, height = buttonheight, cellBGColor = Color["row_background"] }):setIcon("widget_arrow_right_01", { width = buttonsize, height = buttonsize, y = (row:getHeight() - buttonsize) / 2 })
	row[9].handlers.onClick = function () infoTablePersistentData.curPage = infoTablePersistentData.curPage + 1; menu.refreshInfoFrame() end
	row[10]:createButton({ scaling = false, active = infoTablePersistentData.curPage < infoTablePersistentData.numPages, width = buttonsize, height = buttonheight, cellBGColor = Color["row_background"] }):setIcon("widget_arrow_skip_right_01", { width = buttonsize, height = buttonsize, y = (row:getHeight() - buttonsize) / 2 })
	row[10].handlers.onClick = function () infoTablePersistentData.curPage = infoTablePersistentData.numPages; menu.refreshInfoFrame() end

	infotable:addEmptyRow(Helper.standardTextHeight / 2)

	if #Helper.ventureContacts > 0 then
		local startIndex = math.max(1, #Helper.ventureContacts - (infoTablePersistentData.curPage - 1) * Helper.ventureContactsConfig.pageSize)
		local pageSize = math.min(#Helper.ventureContacts, Helper.ventureContactsConfig.pageSize)
		local endIndex = math.max(1, startIndex - pageSize + 1)
		for i = startIndex, endIndex, -1 do
			local entry = Helper.ventureContacts[i]

			local row = infotable:addRow(entry, {  })
			local platforminfo = ""
			if entry.isplatformsteam then
				platforminfo = " (\27[optionsmenu_steam] " .. (entry.platformname and (" " .. entry.platformname) or "") .. ")"
			end
			row[1]:setColSpan(numCols):createText(entry.name .. (entry.ismuted and " \27[menu_sound_off]" or "") .. platforminfo)
		end
	else
		row = infotable:addRow(true, {  })
		row[1]:setColSpan(numCols):createText(ReadText(1001, 11367))
	end

	if mode == "friends" then
		infotable:addEmptyRow()

		local row = infotable:addRow(nil, { bgColor = Color["row_title_background"] })
		row[1]:setColSpan(numCols):createText(ReadText(1001, 11370), Helper.subHeaderTextProperties)
		row[1].properties.halign = "center"

		local row = infotable:addRow(nil, {  })
		row[1]:setColSpan(numCols):createText(ReadText(1001, 11371), { wordwrap = true })

		local row = infotable:addRow(true, {  })
		row[1]:setColSpan(numCols):createEditBox({ description = ReadText(1001, 11391), defaultText = ReadText(1001, 3250), height = Helper.standardTextHeight }):setText("", { halign = "left", x = Helper.standardTextOffsetx })
		row[1].handlers.onEditBoxDeactivated = function (_, text, textchanged) return Helper.editboxVentureFindForumUser(menu, instance, text, textchanged) end

		if infoTablePersistentData.forumerror then
			local errortext = string.format(ReadText(1001, 11377), infoTablePersistentData.forumsearch)
			if infoTablePersistentData.forumerror == "alreadyexists" then
				errortext = string.format(ReadText(1001, 11378), infoTablePersistentData.forumsearch)
			elseif infoTablePersistentData.forumerror == "blocked" then
				errortext = string.format(ReadText(1001, 11379), infoTablePersistentData.forumsearch)
			end
			local row = infotable:addRow(true, {  })
			row[1]:setColSpan(numCols):createText(errortext, { color = Color["text_warning"], wordwrap = true })
		elseif infoTablePersistentData.forumuserid then
			local row = infotable:addRow(true, {  })
			row[1]:setColSpan(3):createText(infoTablePersistentData.forumsearch)
			row[4]:setColSpan(numCols - 3):createButton({  }):setText(ReadText(1001, 11372), { halign = "center" })
			row[4].handlers.onClick = function () return Helper.buttonAddForumUser(menu, instance, infoTablePersistentData.forumuserid, false) end
		end

		if IsSteamworksEnabled() then
			infotable:addEmptyRow()

			local row = infotable:addRow(nil, { bgColor = Color["row_title_background"] })
			row[1]:setColSpan(numCols):createText(ReadText(1001, 11373), Helper.subHeaderTextProperties)
			row[1].properties.halign = "center"

			local row = infotable:addRow(nil, {  })
			row[1]:setColSpan(numCols):createText(ReadText(1001, 11374), { wordwrap = true })

			local row = infotable:addRow(nil, {  })
			row[1]:setColSpan(numCols):createText(ReadText(1001, 11375), { wordwrap = true })

			infotable:addEmptyRow(Helper.standardTextHeight / 2)

			local row = infotable:addRow(true, {  })
			row[4]:setColSpan(numCols - 3):createButton({  }):setText(ReadText(1001, 11376), { halign = "center" })
			row[4].handlers.onClick = function () return Helper.buttonCreateFriendListContext(menu) end
		end
	end

	if menu.selectedRows["infotable" .. instance] then
		infotable:setSelectedRow(menu.selectedRows["infotable" .. instance])
		menu.selectedRows["infotable" .. instance] = nil
		if menu.topRows["infotable" .. instance] then
			infotable:setTopRow(menu.topRows["infotable" .. instance])
			menu.topRows["infotable" .. instance] = nil
		end
		if menu.selectedCols["infotable" .. instance] then
			infotable:setSelectedCol(menu.selectedCols["infotable" .. instance])
			menu.selectedCols["infotable" .. instance] = nil
		end
	end
	menu.setrow = nil
	menu.settoprow = nil
	menu.setcol = nil

	local table_header = Helper.createVentureContactsHeader(menu, frame, instance, x, y)

	infotable.properties.y = table_header.properties.y + table_header:getFullHeight() + Helper.borderSize

	table_header:addConnection(1, (instance == "left") and 2 or 3, true)
	infotable:addConnection(2, (instance == "left") and 2 or 3)
end

function Helper.createVentureContactsHeader(menu, frame, instance, x, y)
	local ftable
	if instance == "left" then
		menu.ventureContactsHeaderTableLeft = frame:addTable(#Helper.ventureContactsCategories + 1, { tabOrder = 1, x = x, y = y })
		ftable = menu.ventureContactsHeaderTableLeft
	elseif instance == "right" then
		menu.ventureContactsHeaderTableRight = frame:addTable(#Helper.ventureContactsCategories + 1, { tabOrder = 1, x = x, y = y })
		ftable = menu.ventureContactsHeaderTableRight
	end

	local sidebarwidth = Helper.scaleX(Helper.sidebarWidth)
	for i, entry in ipairs(Helper.ventureContactsCategories) do
		if entry.empty then
			ftable:setColWidth(i, sidebarwidth / 2, false)
		else
			ftable:setColWidth(i, sidebarwidth, false)
		end
	end

	local row = ftable:addRow("orders_tabs", { fixed = true })
	local count = 1
	for _, entry in ipairs(Helper.ventureContactsCategories) do
		if not entry.empty then
			local bgcolor = Color["row_title_background"]
			local color = Color["icon_normal"]
			if entry.category == Helper.ventureContactsMode[instance] then
				bgcolor = Color["row_background_blue"]
			end

			local hassession = OnlineHasSession()
			local loccount = count
			row[loccount]:createButton({ active = hassession, height = sidebarwidth, bgColor = bgcolor, mouseOverText = entry.name, scaling = false, helpOverlayID = entry.helpOverlayID, helpOverlayText = entry.helpOverlayText }):setIcon(entry.icon, { color = color})
			row[loccount].handlers.onClick = function () return Helper.buttonVentureContactsSubMode(menu, entry.category, loccount, instance) end
			count = count + 1
		else
			count = count + 1
		end
	end

	if menu.selectedRows["ventureContactsHeaderTable" .. instance] then
		ftable.properties.defaultInteractiveObject = true
		ftable:setSelectedRow(menu.selectedRows["ventureContactsHeaderTable" .. instance])
		ftable:setSelectedCol(menu.selectedCols["ventureContactsHeaderTable" .. instance] or 0)
		menu.selectedRows["ventureContactsHeaderTable" .. instance] = nil
		menu.selectedCols["ventureContactsHeaderTable" .. instance] = nil
	end

	return ftable
end

function Helper.buttonVentureContactsSubMode(menu, mode, col, instance)
	if mode ~= Helper.ventureContactsMode[instance] then
		Helper.ventureContactsMode[instance] = mode

		AddUITriggeredEvent(menu.name, Helper.ventureContactsMode[instance])

		menu.selectedRows["ventureContactsHeaderTable" .. instance] = 1
		menu.selectedCols["ventureContactsHeaderTable" .. instance] = col
		menu.settoprow = 1
		if instance == "left" then
			menu.refreshInfoFrame(1, 0)
		elseif instance == "right" then
			menu.refreshInfoFrame2(1, 0)
		end
	end
end

function Helper.contactSearchHelper(entry, text)
	text = utf8.lower(text)

	if string.find(utf8.lower(entry.name), text, 1, true) then
		return true
	end

	return false
end

function Helper.editboxVentureContactsPageActivated(menu, widget, instance)
	menu.noupdate = true
	if Helper.contactsPageEditBox and (widget == Helper.contactsPageEditBox.id) then
		C.SetEditBoxText(Helper.contactsPageEditBox.id, tostring(menu.infoTablePersistentData[instance].venturecontacts.curPage))
	end
end

function Helper.editboxVentureContactsPage(menu, instance, text, textchanged)
	local infoTablePersistentData = menu.infoTablePersistentData[instance].venturecontacts
	local newpage = tonumber(text)
	if newpage and (newpage ~= infoTablePersistentData.curPage) then
		infoTablePersistentData.curPage = math.max(1, math.min(newpage, infoTablePersistentData.numPages))
		menu.refreshInfoFrame()
	else
		C.SetEditBoxText(Helper.contactsPageEditBox.id, infoTablePersistentData.curPage .. " / " .. infoTablePersistentData.numPages)
	end
	menu.noupdate = false
end

function Helper.editboxVentureFindForumUser(menu, instance, text, textchanged)
	local infoTablePersistentData = menu.infoTablePersistentData[instance].venturecontacts
	if textchanged then
		infoTablePersistentData.forumerror = nil
		infoTablePersistentData.forumuserid = nil
		infoTablePersistentData.forumsearch = text
		Helper.usernameRequest = instance
		OnlineCheckUsername(text)
	end
end

function Helper.buttonAddForumUser(menu, instance, userid, block)
	local infoTablePersistentData = menu.infoTablePersistentData[instance].venturecontacts
	infoTablePersistentData.forumuserid = nil
	OnlineAddContact(userid, block)
	menu.refreshInfoFrame()
end

function Helper.buttonCreateFriendListContext(menu)
	OnlineRequestPlatformFriendList()
end

function Helper.onCheckUsername(menu, result)
	local data
	if (menu.ventureMode == "venturecontacts") or (menu.mode == "venturecontacts") then
		data = menu.infoTablePersistentData[Helper.usernameRequest].venturecontacts
	elseif menu.contextMenuMode == "venturecreateparty" then
		data = menu.contextMenuData
	else
		DebugError("Helper.onCheckUsername() called from unhandled sub menu.")
		return
	end

	local success, userid, name = utf8.match(result, "([01]);([0-9]+);(.*)")
	if success == "1" then
		local contact = OnlineFindContact(userid)
		if contact == nil then
			data.forumsearch = name
			data.forumuserid = tonumber(userid)
		else
			data.forumsearch = name
			data.forumerror = contact.isblocked and "blocked" or "alreadyexists"
		end
	else
		data.forumerror = "notfound"
	end
	Helper.usernameRequest = nil
	if (menu.ventureMode == "venturecontacts") or (menu.mode == "venturecontacts") then
		menu.refreshInfoFrame()
	elseif menu.contextMenuMode == "venturecreateparty" then
		menu.refreshContextFrame()
	end
end

function Helper.onPlatformFriendsLookedUp(menu)
	local friendlist = OnlineGetPlatformFriendList()

	menu.contextMenuMode = "venturefriendlist"
	local offsetx = Helper.ventureContactsMode.x + Helper.ventureContactsMode.width + Helper.borderSize + Helper.ventureContactsConfig.contextBorder
	local offsety = Helper.ventureContactsMode.y
	menu.contextMenuData = { xoffset = offsetx, yoffset = offsety, friendlist = friendlist }
	if menu.ventureMode == "venturecontacts" then
		menu.createContextFrame(Helper.scaleX(400))
	elseif menu.mode == "venturecontacts" then
		menu.createContextFrame(nil, offsetx, offsety, Helper.scaleX(400), true)
	end
end

function Helper.createVentureContactContext(menu, frame)
	local contact = menu.contextMenuData.contact

	local infotable = frame:addTable(2, { tabOrder = 2, x = Helper.borderSize, y = Helper.borderSize, width = menu.contextMenuData.width, highlightMode = "off" })

	-- title
	local row = infotable:addRow(nil, { fixed = true })
	row[1]:setColSpan(2):createText(contact.name, Helper.headerRowCenteredProperties)

	if C.IsVentureSeasonSupported() then
		local _, userid = OnlineGetUserName()
		if contact.id ~= userid then
			local row = infotable:addRow(true, { fixed = true })
			row[1]:setColSpan(2):createButton({  }):setText(ReadText(1001, 12115))
			row[1].handlers.onClick = function () return Helper.buttonContactMessage(menu, contact.id, contact.name) end
		end

		if not contact.isblocked then
			local row = infotable:addRow(true, { fixed = true })
			row[1]:setColSpan(2):createButton({  }):setText(contact.ismuted and ReadText(1001, 11369) or ReadText(1001, 11368))
			row[1].handlers.onClick = function () return Helper.buttonMuteContact(menu, contact.id, not contact.ismuted) end
		end

		local row = infotable:addRow(true, { fixed = true })
		row[1]:setColSpan(2):createButton({  }):setText(contact.isblocked and ReadText(1001, 11389) or ReadText(1001, 11388))
		row[1].handlers.onClick = function () return Helper.buttonAddContact(menu, contact.id, not contact.isblocked) end
	end 

	local row = infotable:addRow(true, { fixed = true })
	row[1]:setColSpan(2):createButton({  }):setText(ReadText(1001, 11392))
	row[1].handlers.onClick = function () return Helper.buttonRemoveContact(menu, contact.id) end

	if C.IsVentureSeasonSupported() then
		local row = infotable:addRow(nil, { fixed = true })
		row[1]:setColSpan(2):createText(ReadText(1001, 12110), Helper.subHeaderTextProperties)

		local row = infotable:addRow(true, { fixed = true })
		row[1]:setColSpan(2):createButton({  }):setText(ReadText(1001, 12111))
		row[1].handlers.onClick = function () return Helper.buttonReportContact(menu, contact.id, "Offensive user name") end -- hardcoded text only visible in venture server moderator interface
	end

	-- adjust frame position
	local neededheight = infotable.properties.y + infotable:getVisibleHeight()
	if frame.properties.y + neededheight + Helper.frameBorder > Helper.viewHeight then
		menu.contextMenuData.yoffset = Helper.viewHeight - neededheight - Helper.frameBorder
		frame.properties.y = menu.contextMenuData.yoffset
	end
end

function Helper.showVentureFriendListContext(menu, frame)
	local contact = menu.contextMenuData.contact

	local infotable = frame:addTable(3, { tabOrder = 2, x = Helper.borderSize, y = Helper.borderSize, width = menu.contextMenuData.width })
	infotable:setColWidth(1, Helper.standardTextHeight)
	infotable:setColWidthPercent(3, 50)

	-- title
	local row = infotable:addRow(nil, { fixed = true })
	row[1]:setColSpan(3):createText(ReadText(1001, 11373), Helper.headerRowCenteredProperties)

	local platformicon
	if IsSteamworksEnabled() then
		platformicon = "\27[optionsmenu_steam]"
	end

	if #menu.contextMenuData.friendlist > 0 then
		for i, friend in ipairs(menu.contextMenuData.friendlist) do
			local row = infotable:addRow(true, {  })
			row[1]:createCheckBox(friend.isselected, {  })
			row[1].handlers.onClick = function (_, checked) menu.contextMenuData.friendlist[i].isselected = checked end
			row[2]:setColSpan(2):createText(friend.username .. " (" .. (platformicon or "") .. (friend.platformname and (" " .. friend.platformname) or "") .. ")")
		end
	else
		local row = infotable:addRow(nil, {  })
		row[1]:setColSpan(3):createText(ReadText(1001, 11393), { wordwrap = true })
	end

	local buttontable = frame:addTable(2, { tabOrder = 3, x = Helper.borderSize, y = Helper.borderSize, width = menu.contextMenuData.width })
	local row = buttontable:addRow(true, {  })
	row[1]:createButton({ active = function () return Helper.buttonImportFriendListActive(menu) end }):setText(ReadText(1001, 11387), { halign = "center" })
	row[1].handlers.onClick = function () return Helper.buttonImportFriendList(menu) end
	row[2]:createButton({  }):setText(ReadText(1001, 64), { halign = "center" })
	row[2].handlers.onClick = function () return menu.closeContextMenu() end

	local infoheight = infotable:getFullHeight()
	local buttonheight = buttontable:getFullHeight()
	if frame.properties.y + infotable.properties.y + infoheight + buttonheight + Helper.frameBorder > Helper.viewHeight then
		buttontable.properties.y = Helper.viewHeight - frame.properties.y - Helper.frameBorder - buttonheight
		infotable.properties.maxVisibleHeight = buttontable.properties.y - Helper.borderSize - infotable.properties.y
	else
		buttontable.properties.y = infotable.properties.y + infoheight + Helper.borderSize
	end

	infotable:addConnection(1, 3, true)
	buttontable:addConnection(2, 3)
end

function Helper.buttonReportContact(menu, userid, reason)
	local mousepos = C.GetCenteredMousePos()
	menu.contextMenuMode = "venturereport"
	menu.contextMenuData = { mode = "venturereport", submode = "user", reason = reason, userid = userid, xoffset = mousepos.x + Helper.viewWidth / 2, yoffset = mousepos.y + Helper.viewHeight / 2 }

	local width = Helper.scaleX(400)
	if menu.contextMenuData.xoffset + width > Helper.viewWidth then
		menu.contextMenuData.xoffset = Helper.viewWidth - width - Helper.frameBorder
	end
	
	if menu.ventureMode == "venturecontacts" then
		menu.createContextFrame(width, nil, menu.contextMenuData.xoffset, menu.contextMenuData.yoffset)
	elseif menu.mode == "venturecontacts" then
		menu.createContextFrame(nil, menu.contextMenuData.xoffset, menu.contextMenuData.yoffset, width, true)
	end
end

function Helper.createUserQuestionContext(menu, frame)
	local numCols = 5
	local ftable = frame:addTable(numCols, { tabOrder = 5, reserveScrollBar = false, highlightMode = "off" })

	if menu.contextMenuData.mode == "venturereport" then
		if menu.contextMenuData.submode == "user" then
			local row = ftable:addRow(false, { fixed = true })
			row[1]:setColSpan(numCols):createText(ReadText(1001, 11364), Helper.headerRowCenteredProperties)

			local row = ftable:addRow(false, { fixed = true })
			row[1]:setColSpan(numCols):createText(string.format(ReadText(1001, 11365), menu.contextMenuData.author), { wordwrap = true })
		end
	end


	local row = ftable:addRow(false, { fixed = true })
	row[1]:setColSpan(numCols):createText("")

	local row = ftable:addRow(true, { fixed = true })
	row[2]:createButton():setText(ReadText(1001, 2617), { halign = "center" })
	if menu.contextMenuData.mode == "venturereport" then
		if menu.contextMenuData.submode == "user" then
			row[2].handlers.onClick = function () return menuExtension.reportUser(menu, menu.contextMenuData.userid, menu.contextMenuData.reason) end
		end
	end
	row[4]:createButton():setText(ReadText(1001, 2618), { halign = "center" })
	row[4].handlers.onClick = menu.closeContextMenu
	ftable:setSelectedCol(4)

	-- adjust frame position
	local neededheight = ftable.properties.y + ftable:getVisibleHeight()
	if frame.properties.y + neededheight > Helper.viewHeight then
		menu.contextMenuData.yoffset = Helper.viewHeight - neededheight - Helper.frameBorder
		frame.properties.y = menu.contextMenuData.yoffset
	end
end

function Helper.buttonContactMessage(menu, id, name)
	Helper.chatParams = { id = id, name = name }
	C.QuickMenuAccess("chat")
	menu.closeContextMenu()
end

function Helper.buttonMuteContact(menu, userid, mute)
	OnlineMuteContact(userid, mute)
	menu.closeContextMenu()
end

function Helper.buttonRemoveContact(menu, userid)
	OnlineRemoveContact(userid)
	menu.closeContextMenu()
end

function Helper.buttonAddContact(menu, userid, block)
	OnlineAddContact(userid, block)
	menu.closeContextMenu()
end

function Helper.buttonImportFriendListActive(menu)
	for _, friend in ipairs(menu.contextMenuData.friendlist) do
		if friend.isselected then
			return true
		end
	end
	return false
end

function Helper.buttonImportFriendList(menu)
	local friends = ""
	for _, friend in ipairs(menu.contextMenuData.friendlist) do
		if friend.isselected then
			if friends == "" then
				friends = friend.platformid
			else
				friends = friends .. "," .. friend.platformid
			end
		end
	end
	OnlineImportPlatformFriends(friends)
	menu.closeContextMenu()
end

function Helper.onReceiveContacts(menu)
	if menu.contextMenuMode == "venturecreateparty" then
		menu.refreshContextFrame()
	end
	if (menu.ventureMode == "venturecontacts") or (menu.mode == "venturecontacts") then
		menu.refreshInfoFrame()
	end
end

function Helper.registerVentureContactCallbacks(menu)
	Helper.registeredVentureContactFunctions = {
		onCheckUsername = function (_, result) return Helper.onCheckUsername(menu, result) end,
		onPlatformFriendsLookedUp = function () return Helper.onPlatformFriendsLookedUp(menu) end,
		onReceiveContacts = function () return Helper.onReceiveContacts(menu) end,
	}
	RegisterEvent("onCheckUsername", Helper.registeredVentureContactFunctions.onCheckUsername)
	RegisterEvent("onPlatformFriendsLookedUp", Helper.registeredVentureContactFunctions.onPlatformFriendsLookedUp)
	RegisterEvent("onReceiveContacts", Helper.registeredVentureContactFunctions.onReceiveContacts)
end

function Helper.unregisterVentureContactCallbacks()
	if Helper.registeredVentureContactFunctions and next(Helper.registeredVentureContactFunctions) then
		UnregisterEvent("onCheckUsername", Helper.registeredVentureContactFunctions.onCheckUsername)
		UnregisterEvent("onPlatformFriendsLookedUp", Helper.registeredVentureContactFunctions.onPlatformFriendsLookedUp)
		UnregisterEvent("onReceiveContacts", Helper.registeredVentureContactFunctions.onReceiveContacts)
		Helper.registeredVentureContactFunctions = {}
	end
end

function Helper.getLimitedWareAmount(ware)
	if C.IsGameModified() then
		return tonumber(ffi.string(C.GetUserData("limited_blueprint_" .. ware))) or 0
	end
	return tonumber(ffi.string(C.GetUserDataSigned("limited_blueprint_" .. ware))) or 0
end

-- kuertee start: SWI load lua
function Helper.SWIUI_LoadLua(_, file)
	-- 24 feb 2024: no longer required.
	-- local extensions = GetExtensionList()
	-- for _, extension in ipairs(extensions) do
	-- 	if extension.id == "SW Interworlds" then
	-- 		-- Helper.debugText_forced("SWIUI_LoadLua extension", extension)
	-- 		if extension.enabled then
	-- 			Helper.debugText("file" .. tostring(file))
	-- 		    local isSuccess, errorMsg = require(file)
	-- 		    if isSuccess ~= true then
	-- 		    	DebugError("uix load failed: " .. tostring(errorMsg))
	-- 		    end
	-- 		    AddUITriggeredEvent("SWIUI_OnLoad", file)
	-- 		end
	-- 	end
	-- end
end

function Helper.SWIUI_Init()
	-- 24 feb 2024: no longer required.
	-- Helper.debugText("")
	-- RegisterEvent("SWIUI_LoadLua", Helper.SWIUI_LoadLua)
	-- AddUITriggeredEvent("SWIUI_OnInit", "Init")
end
-- kuertee end: SWI load lua

-- kuertee start:
function Helper.getMenu(menuName)
	if Menus then
		for _, menu in ipairs(Menus) do
			if menu.name == menuName then
				return menu
			end
		end
	end
	return nil
end

function Helper.registerCallback (callbackName, callbackFunction)
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

function Helper.deregisterCallback(callbackName, callbackFunction)
	-- for i, callback in ipairs(callbacks[callbackName]) do
	-- Helper.debugText_forced("#callbacks[" .. tostring(callbackName) .. "] (pre deregisterCallback)", #callbacks[callbackName])
	if callbacks[callbackName] and #callbacks[callbackName] > 0 then
		for i = #callbacks[callbackName], 1, -1 do
			if callbacks[callbackName][i] == callbackFunction then
				table.remove(callbacks[callbackName], i)
			end
		end
	end
	-- Helper.debugText_forced("#callbacks[" .. tostring(callbackName) .. "] (post deregisterCallback)", #callbacks[callbackName])
end

function Helper.debugText (data1, data2, indent, isForced, getinfodata)
	local isDebug = false
	if isDebug == true or isForced == true then
		if indent == nil then
			indent = ""
		end
		if data1 == "" then
			data1 = "(empty string)"
		elseif not data1 then
			data1 = "(nil)"
		end
		if data2 == "" then
			data2 = "(empty string)"
		elseif not data2 then
			data2 = "(nil)"
		end
		if not getinfodata then
			getinfodata = debug.getinfo(3)
		end
		local noteFuncName = ""
		local noteLocation = ""
		if (not noteFuncName) or tostring(getinfodata.name) == "callback" or tostring(getinfodata.name) == "nil" then
			noteFuncName = " (approx)"
			noteLocation = " (location of approx funcName)"
		end
		-- DebugError ("uix funcName" .. tostring(noteFuncName) .. ": " .. tostring(getinfodata.name) .. " data1: " .. indent .. tostring (data1) .. " (" .. tostring(type(data1)) .. ") data2: " .. tostring(data2) .. " (" .. tostring(type(data2)) .. ") at" .. tostring(noteLocation) .. ": line: " .. tostring(getinfodata.linedefined) .. " of: " .. tostring(getinfodata.short_src))
		DebugError ("uix funcName" .. tostring(noteFuncName) .. ": " .. tostring(getinfodata.name) .. ": " .. indent .. tostring (data1) .. " = " .. tostring(data2) .. " at" .. tostring(noteLocation) .. ": line: " .. tostring(getinfodata.linedefined) .. " of: " .. tostring(getinfodata.short_src))
		indent = indent .. "  "
		if type(data1) == "table" then
			for key, value in pairs(data1) do
				Helper.debugText(key, value, indent, isForced, getinfodata)
			end
		end
		if type(data2) == "table" then
			Helper.debugText(data2, nil, indent, isForced, getinfodata)
		end
	end
end

function Helper.debugText_forced (data1, data2, indent)
	local getinfodata = debug.getinfo(2)
	-- DebugError("func: " .. tostring(debug.getinfo(getinfodata.func).name) .. ", " .. tostring(debug.getinfo(getinfodata.func).linedefined) .. ", " .. tostring(debug.getinfo(getinfodata.func).short_src))
	return Helper.debugText(data1, data2, indent, true, getinfodata)
end

Helper.modLuas = {}
Helper.time_initModLuasNow = nil
Helper.isDebugModLuas = false
function Helper.loadModLuas(menuName, modLuaName)
	if not Helper.modLuas[menuName] then
		Helper.modLuas[menuName] = {
			menu = nil,
			isInitedFirstTime = nil,
			isTriggerUIEventNow = nil,
			byExtension = {},
			failedByExtension = {}
		}
	end
	local extensions = GetExtensionList()
	local isModLuaLoaded
	if #extensions then
		for _, extension in ipairs(extensions) do
			if (not extension.error) and extension.enabled then
				local file = "extensions." .. extension.location:gsub("%\\", "") .. ".ui." .. modLuaName
				if Helper.isDebugModLuas then
					Helper.debugText_forced("file: " .. tostring(file))
				end
				-- Helper.modLuas[menuName].byExtension[extension.location] = require(file)
				local isSuccess, errorMsg = pcall(function() Helper.modLuas[menuName].byExtension[extension.location] = require(file) end)
				if Helper.isDebugModLuas then
					Helper.debugText_forced("file: " .. tostring(file) .. " modLua: " .. tostring(Helper.modLuas[menuName].byExtension[extension.location]))
				end
				if isSuccess then
					isModLuaLoaded = true
					if Helper.isDebugModLuas then
						DebugError("uix load success: " .. tostring(debug.getinfo(Helper.modLuas[menuName].byExtension[extension.location].init).source:gsub("@.\\", "")))
					end
					Helper.time_initModLuasNow = GetCurRealTime() + 1
				else
					local isFileMissing = string.find(errorMsg, "not found")
					if not isFileMissing then
						DebugError("uix load failed: " .. tostring(errorMsg))
					end
				end
			end
		end
	end
	if Helper.isDebugModLuas then
		Helper.debugText_forced(tostring(menuName) .. " " .. tostring(modLuaName) .. " #extensions: " .. tostring(#extensions) .. " isModLuaLoaded: " .. tostring(isModLuaLoaded))
	end
	if isModLuaLoaded then
		AddUITriggeredEvent("uix_mod_lua", "load", menuName)
	end
end

Helper.isModLuaInited_general = nil
function Helper.initModLuas()
	-- make previous initModLuas() obsolete.
	-- new initModLuas2() is triggered automatically one second after the last successful loadModLuas().
	-- initialisation of custom luas do not depend on the menu being opened/triggered anymore like in the previous version of uix.
	-- search for: time_initModLuasNow.
end
function Helper.initModLuas2()
	-- brute force: init all loaded mod luas regardless of menuName
	-- better because this ensures that mod luas of menuName can access other menuNames
	local initedMenuDatasByMenuName = {}
	for menuName_inList, menuData in pairs(Helper.modLuas) do
		if not menuData.isInitedFirstTime then
			menuData.isInitedFirstTime = true
			for extension, modLua in pairs(menuData.byExtension) do
				local isSuccess, errorMsg = pcall(function () modLua.init() end)
				if isSuccess then
					menuData.isTriggerUIEventNow = true
					if Helper.isDebugModLuas then
						DebugError("uix init success: " .. tostring(debug.getinfo(modLua.init).source):gsub("@.\\", ""))
					end
					initedMenuDatasByMenuName[menuName_inList] = menuData
				else
					DebugError("uix init failed: " .. tostring(errorMsg))
					menuData.failedByExtension[extension] = modLua
				end
			end
		end
	end
	-- try those that failed in the last init, e.g. some luas may be trying to access menus that need to be open
	for menuName_inList, menuData in pairs(Helper.modLuas) do
		if Helper.isDebugModLuas then
			DebugError(menuName_inList .. " failedByExtension: " .. tostring(next(menuData.failedByExtension)))
		end
		for extension, modLua in pairs(menuData.failedByExtension) do
			DebugError("uix retrying init " .. tostring(debug.getinfo(modLua.init).source):gsub("@.\\", ""))
			local isSuccess, errorMsg = pcall(function () modLua.init() end)
			if isSuccess then
				menuData.isTriggerUIEventNow = true
				if Helper.isDebugModLuas then
					DebugError("    uix init success at next try/tries: " .. tostring(debug.getinfo(modLua.init).source):gsub("@.\\", ""))
				end
				-- table.remove(menuData.failedByExtension, extension)
				menuData.failedByExtension[extension] = nil
				initedMenuDatasByMenuName[menuName_inList] = menuData
			else
				DebugError("    uix init failed at next try/tries: " .. tostring(errorMsg))
			end
		end
	end
	-- trigger ui events of any menu name that was inited successfully
	local isAllInited = true
	for menuName_inList, menuData in pairs(initedMenuDatasByMenuName) do
		if not next(menuData.failedByExtension) then
			if menuData.isTriggerUIEventNow then
				menuData.isTriggerUIEventNow = nil
				AddUITriggeredEvent("uix_mod_lua", "init", menuName_inList)
				if Helper.isDebugModLuas then
					DebugError("AddUITriggeredEvent uix_mod_lua init: " .. tostring(menuName_inList))
				end
			end
		else
			isAllInited = nil
		end
	end
	if isAllInited then
		if not Helper.isModLuaInited_general then
			Helper.isModLuaInited_general = true
			AddUITriggeredEvent("uix_mod_lua", "init")
			if Helper.isDebugModLuas then
				DebugError("AddUITriggeredEvent uix_mod_lua init")
			end
		end
	end
end
-- kuertee end

---------------------------------------------------------------------------------
-- Init
---------------------------------------------------------------------------------

init()
