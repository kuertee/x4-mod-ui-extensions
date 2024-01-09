-- Ingame Options Main Menu

-- ffi setup
local ffi = require("ffi")
local C = ffi.C
ffi.cdef[[
	typedef struct {
		uint32_t mintime;
		uint32_t maxtime;
		float factor;
	} AutosaveIntervalInfo;
	typedef struct {
		int32_t id;
		const char* name;
	} GameStartGroupInfo;
	typedef struct {
		int32_t id;
		const char* name;
		const char* warning;
		const char* font;
		bool voice;
	} LanguageInfo;
	typedef struct {
		int x;
		int y;
	} ResolutionInfo;
	typedef struct {
		const char* cutsceneid;
		uint32_t extensionidx;
		bool isdefault;
	} StartmenuBackgroundInfo;
	typedef struct {
		const char* filename;
		const char* name;
		const char* description;
		const char* version;
		uint32_t rawversion;
		const char* time;
		int64_t rawtime;
		double playtime;
		const char* playername;
		const char* location;
		int64_t money;
		bool error;
		bool invalidgameid;
		bool invalidversion;
		uint32_t numinvalidpatches;
	} UISaveInfo;
	bool AllowPersonalizedData(void);
	bool AreGfxSettingsTooHigh(void);
	bool AreVenturesEnabled(void);
	bool CanOpenWebBrowser(void);
	void ConnectToMultiplayerGame(const char* serverip);
	const char* ConvertInputString(const char* text, const char* defaultvalue);
	bool DeleteSavegame(const char* filename);
	void DisableAutoMouseEmulation(void);
	void EnableAutoMouseEmulation(void);
	void FadeScreen(float fadeouttime, float fadeintime);
	const char* GetAAOption(bool useconfig);
	float GetAdaptiveSamplingOption(void);
	AutosaveIntervalInfo GetAutosaveIntervalOption(void);
	const char* GetBuildVersionSuffix(void);
	float GetCockpitCameraScaleOption(void);
	bool GetChromaticAberrationOption(void);
	int32_t GetCurrentLanguage(void);
	const char* GetCurrentSoundDevice(void);
	bool GetEmergencyEjectOption(void);
	const char* GetEnemyWarningAttackSound(void);
	const char* GetEnemyWarningNearbySound(void);
	const char* GetEnvMapProbeOption(void);
	float GetEnvMapProbeInsideGlassFadeOption(void);
	const char* GetExtensionName(uint32_t extensionidx);
	const char* GetExtensionVersion(const char* extensionid, bool personal);
	bool GetForceShootingAtCursorOption(void);
	uint32_t GetGameStartGroups(GameStartGroupInfo* result, uint32_t resultlen);
	float GetGlobalLightScale(void);
	const char* GetGPUNiceName(uint32_t idx);
	bool GetHUDSeparateRadar(void);
	uint32_t GetLanguages(LanguageInfo* result, uint32_t resultlen);
	UISaveInfo GetLastSaveInfo(void);
	const char* GetLocalizedInputName(uint32_t sourceid, uint32_t codeid);
	const char* GetLocalizedRawMouseButtonName(uint32_t keycodeid);
	bool GetLongRangeScanIndicatorOption(void);
	uint32_t GetLUTMode(void);
	bool GetMouseOverTextOption(void);
	uint32_t GetMouseHUDModeOption(void);
	bool GetMouseSteeringInvertedOption(const char* paramname);
	uint32_t GetNumGameStartGroups(void);
	uint32_t GetNumGPUs(void);
	uint32_t GetNumLanguages(void);
	uint32_t GetNumPlayerAlertSounds2(const char* tags);
	uint32_t GetNumSoundDevices(void);
	uint32_t GetNumStartmenuBackgrounds(void);
	uint32_t GetPlayerAlertSounds2(SoundInfo* result, uint32_t resultlen, const char* tags);
	const char* GetPOMOption(void);
	const char* GetPresentModeOption(void);
	ResolutionInfo GetRenderResolutionOption(void);
	uint32_t GetRequestedGPU(void);
	int32_t GetRequestedLanguage(void);
	const char* GetSaveFolderPath(void);
	const char* GetSaveInquiryText();
	const char* GetSaveLocationName(void);
	bool GetScreenDisplayOption(void);
	bool GetSignalLeakIndicatorOption(void);
	uint32_t GetSoundDevices(const char** result, uint32_t resultlen);
	bool GetSpeakTargetNameOption(void);
	const char* GetSSROption2(void);
	const char* GetStartmenuBackgroundOption(void);
	uint32_t GetStartmenuBackgrounds(StartmenuBackgroundInfo* result, uint32_t resultlen);
	const char* GetSteamID(void);
	const char* GetTextureQualityOption(void);
	const char* GetTobiiMode(void);
	float GetTobiiAngleFactor(void);
	float GetTobiiDeadzoneAngle(void);
	float GetTobiiDeadzonePosition(void);
	float GetTobiiGazeAngleFactor(void);
	float GetTobiiGazeDeadzone(void);
	size_t GetTobiiGazeFilterStrength(void);
	size_t GetTobiiHeadFilterStrength(void);
	float GetTobiiHeadPositionFactor(void);
	const char* GetUpscalingOption(bool useconfig);
	uint32_t GetVentureDLCStatus(void);
	bool GetVisitorNamesShownOption(void);
	int GetVRVivePointerHand(void);
	const char* GetTrackerNameOption(void);
	const char* GetTrackerSDKOption(void);
	float GetUIScaleFactor();
	int32_t GetVolumetricFogOption(void);
	bool HasExtension(const char* extensionid, bool personal);
	bool HasSavegame(void);
	void HidePromo(void);
	bool IsAAOptionSupported(const char* mode);
	bool IsAppStoreVersion(void);
	bool IsClientModified(void);
	bool IsCurrentGPUDiscrete(void);
	bool IsDemoVersion(void);
	bool IsExtensionEnabled(const char* extensionid, bool personal);
	bool IsFSROnWithoutAA(void);
	bool IsGameModified(void);
	bool IsGameOver(void);
	bool IsGOGVersion(void);
	bool IsGPUAutomaticallySelected(void);
	bool IsGPUCompatible(uint32_t idx);
	bool IsHUDRadarActive(void);
	bool IsJoystickSteeringAdapative(void);
	bool IsMouseSteeringAdapative(void);
	bool IsMouseSteeringLineEnabled(void);
	bool IsMouseSteeringPersistent(void);
	bool IsLanguageSettingEnabled(void);
	bool IsLanguageValid(void);
	bool IsNetworkEngineEnabled(void);
	bool IsOnlineEnabled(void);
	bool IsPresentModeOptionSupported(const char* mode);
	bool IsRequestedGPUCurrent(void);
	bool IsRunningOnSteamDeck(void);
	bool IsSaveValid(const char* filename);
	bool IsStartmenu();
	bool IsTobiiAvailable(void);
	bool IsTradeShowVersion(void);
	bool IsUpscalingOptionSupported(const char* mode);
	bool IsVentureExtensionSupported(void);
	bool IsVentureSeasonSupported(void);
	bool IsVROculusTouchActive(void);
	bool IsVRViveControllerActive(void);
	bool IsVRMode(void);
	bool IsVRVersion(void);
	bool IsSaveListLoadingComplete(void);
	bool IsThrottleBidirectional(void);
	void NewMultiplayerGame(const char* modulename, const char* difficulty);
	void OpenWebBrowser(const char* url);
	bool QueryGameServers(void);
	void ReloadSaveList(void);
	void RequestGPU(uint32_t idx);
	void RequestGPUAutomaticallySelected(void);
	void RequestLanguageChange(int32_t id);
	void RequestSoundDeviceSwitch(const char* device);
	void ResetEncryptedDirectInputData(void);
	void RestoreAccessibilityOptions(void);
	void RestoreMiscOptions(void);
	void SaveAAOption(void);
	void SaveUIUserData(void);
	void SaveUpscalingOption(void);
	void SetAAOption(const char* fxaa);
	void SetAdaptiveSamplingOption(float value);
	void SetAutosaveIntervalOption(float factor);
	void SetChromaticAberrationOption(bool value);
	void SetCockpitCameraScaleOption(float value);
	void SetEditBoxText(const int editboxid, const char* text);
	void SetEmergencyEjectOption(bool setting);
	void SetEnemyWarningAttackSound(const char* soundid);
	void SetEnemyWarningNearbySound(const char* soundid);
	void SetEnvMapProbeOption(const char* quality);
	void SetEnvMapProbeInsideGlassFadeOption(float value);
	void SetLongRangeScanIndicatorOption(bool shown);
	void SetMouseOverTextOption(bool value);
	void SetForceShootingAtCursorOption(bool value);
	void SetGlobalLightScale(float value);
	void SetHUDRadarActive(bool setting);
	void SetHUDRadarSeparate(bool setting);
	void SetJoystickSteeringAdapative(bool value);
	void SetLUTMode(uint32_t mode);
	void SetMouseHUDModeOption(uint32_t value);
	void SetMouseSteeringAdapative(bool value);
	void SetMouseSteeringLine(bool value);
	void SetMouseSteeringPersistent(bool value);
	void SetMouseSteeringInvertedOption(const char* paramname, bool value);
	void SetPOMOption(const char* quality);
	void SetPresentModeOption(const char* mode);
	void SetSceneCameraActive(bool active);
	void SetSignalLeakIndicatorOption(bool shown);
	void SetSpeakTargetNameOption(bool value);
	void SetSSROption2(const char* value);
	void SetStartmenuBackgroundOption(const char* value);
	void SetTextureQualityOption(const char* mode);
	void SetThrottleBidirectional(bool newsetting);
	void SetTobiiMode(const char* mode);
	void SetTobiiAngleFactor(float value);
	void SetTobiiDeadzoneAngle(float value);
	void SetTobiiDeadzonePosition(float value);
	void SetTobiiGazeAngleFactor(float value);
	void SetTobiiGazeDeadzone(float value);
	void SetTobiiGazeFilterStrength(size_t value);
	void SetTobiiHeadFilterStrength(size_t value);
	void SetTobiiHeadPositionFactor(float value);
	void SetVisitorNamesShownOption(bool setting);
	void SetVRVivePointerHand(int hand);
	void SetVolumetricFogOption(int32_t setting);
	void SetUIScaleFactor(const float scale);
	void SetUpscalingOption(const char* mode);
	void ShowPromo(void);
	void SkipNextStartAnimation(void);
	void StartIntroAnimation(const char* triggername);
	void StartStartMenuBGMusic(void);
	void StartVoiceSequence2(const char* sequenceid, UniverseID entityid, const char* gamestartid);
	void StopStartMenuBGMusic(void);
	void StopVoiceSequence(void);
	void ToggleScreenDisplayOption(void);
	bool WasSessionOnline(void);
]]

local utf8 = require("utf8")

local menu = {
	name = "OptionsMenu",
	languagedata = {},
	history = {},
	curDropDownOption = {},
	saveSort = "slot",
	lastSaveUpdateTime = 0,
	searchtext = "",
}

-- kuertee start:
local callbacks = {}
GameIdManager = {}
-- kuertee end:

local function init()
	-- register callbacks
	RegisterEvent("gfx_ok", menu.onGfxDone)
	RegisterEvent("loadSave", menu.loadSaveCallback)
	RegisterEvent("serverDiscovered", menu.serverDiscoveredCallback)
	RegisterEvent("extensionSettingChanged", menu.onExtensionSettingChanged)
	RegisterEvent("versionIncompatible", menu.onVersionIncompatible)
	RegisterEvent("onlineLogin", menu.onOnlineLogin)
	RegisterEvent("clientStarted", menu.onClientStarted)
	RegisterEvent("openOptionsMenuSubMenu", menu.onOpenSubMenu)
	registerForEvent("cutsceneStopped", getElement("Scene.UIContract"), menu.onCutsceneStopped)

	-- init variables
	menu.isStartmenu = C.IsStartmenu()
	__CORE_GAMEOPTIONS_RESTORE = __CORE_GAMEOPTIONS_RESTORE or nil
	__CORE_GAMEOPTIONS_RESTOREINFO = __CORE_GAMEOPTIONS_RESTOREINFO or {}
	__CORE_GAMEOPTIONS_RESTOREINFO.returnhistory = nil
	__CORE_GAMEOPTIONS_VENTURECONFIG = __CORE_GAMEOPTIONS_VENTURECONFIG or {}

	-- register menu
	Menus = Menus or {}
	table.insert(Menus, menu)
	if Helper then
		Helper.registerMenu(menu)
	end

	-- restore handling
	if __CORE_GAMEOPTIONS_RESTORE or menu.isStartmenu then
		OpenMenu("OptionsMenu", nil, nil, true)
	end
	if menu.isStartmenu then
		if (__CORE_GAMEOPTIONS_RESTORE == nil) and C.IsGameModified() then
			menu.contextMenuMode = "modified"
			menu.contextMenuData = { width = Helper.scaleX(400), y = Helper.viewHeight / 2 }
		elseif C.IsVentureSeasonSupported() and OnlineHasSession() and (not OnlineGetVentureConfig("allow_validation")) and (not OnlineGetVentureConfig("disable_popup")) then
			menu.contextMenuMode = "ventureextension"
			menu.contextMenuData = { width = Helper.scaleX(400), y = Helper.viewHeight / 2 }
		end
	end

	-- kuertee start:
	menu.init_kuertee()
	-- kuertee end
end

-- kuertee start:
function menu.init_kuertee ()
	menu.loadModLuas()
	GameIdManager.init()
	DebugError("uix init success: " .. tostring(debug.getinfo(init).source))
end
-- kuertee end

--- config ---

local config = {
	contextLayer = 2,
	optionsLayer = 4,
	topLevelLayer = 5,

	backarrow = "table_arrow_inv_left",
	backarrowOffsetX = 3,

	sliderCellValueColor = { r = 71, g = 136, b = 184, a = 100 },
	greySliderCellValueColor = { r = 55, g = 55, b = 55, a = 100 },

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

	idleTime = 10,

	saveReloadInterval = 60,
}

config.frame = {
	x = C.IsVRMode() and 100 or 0,
	y = 0,
	width = 800,
	widthExtraWide = 1220,
	height = 1080,
	bgTexture = "optionsmenu_bg",
	fgTexture = "", --C.IsVRMode() and "" or "optionsMenu_fg",
}

config.table = {
	x = 45,
	y = 45,
	width = 710,
	widthExtraWide = 1130,
	widthWithExtraInfo = 370,
	height = 980,
	arrowColumnWidth = 20,
	infoColumnWidth = 330,
}

config.headerTextProperties = {
	font = config.fontBold,
	fontsize = config.headerFontSize,
	x = config.headerTextOffsetX,
	y = 6,
	minRowHeight = config.headerTextHeight,
	titleColor = Helper.defaultSimpleBackgroundColor,
}

config.subHeaderTextProperties = {
	font = config.fontBold,
	fontsize = config.standardFontSize,
	x = config.standardTextOffsetX,
	y = 2,
	minRowHeight = config.subHeaderTextHeight,
	halign = "center",
	titleColor = Helper.defaultSimpleBackgroundColor,
}

config.infoTextProperties = {
	font = config.font,
	fontsize = config.infoFontSize,
	x = config.infoTextOffsetX,
	y = 2,
	wordwrap = true,
	minRowHeight = config.infoTextHeight,
	titleColor = Helper.defaultSimpleBackgroundColor,
}

config.warningTextProperties = {
	font = config.font,
	fontsize = config.infoFontSize,
	x = config.infoTextOffsetX,
	y = 2,
	wordwrap = true,
	minRowHeight = config.infoTextHeight,
}

config.standardTextProperties = {
	font = config.font,
	fontsize = config.standardFontSize,
	x = config.standardTextOffsetX,
	y = 2,
}

config.standardRightTextProperties = {
	font = config.font,
	fontsize = config.standardFontSize,
	halign = "right",
	x = config.standardTextOffsetX,
	y = 2,
}

config.disabledTextProperties = {
	font = config.font,
	fontsize = config.standardFontSize,
	x = config.standardTextOffsetX,
	y = 2,
	color = Helper.color.grey,
}

config.input = {
	controltextpage = {
		["actions"] = 1005,
		["states"]  = 1006,
		["ranges"]  = 1007,
	},
	forbiddenKeys = {
		[1]   = true, -- Escape
		[211] = true, -- Delete
		[466] = true, -- Shift+Insert
		[467] = true, -- Shift+Delete
		[1069] = true, -- Ctrl+X
		[1070] = true, -- Ctrl+C
		[1071] = true, -- Ctrl+V
		[1234] = true, -- Ctrl+Insert
	},
	forbiddenMouseButtons = {
		[1]  = true, -- LMB
		[2]  = true, -- LMB doubleclick
		[4]  = true, -- RMB doubleclick
		[6]  = true, -- MMB doubleclick
		[8]  = true, -- Side1 MB doubleclick
		[10] = true, -- Side2 MB doubleclick
	},
	cheatControls = {
		["actions"]   = { [120] = true, [121] = true },
		["states"]    = {},
		["ranges"]    = {},
		["functions"] = {},
	},
}
	-- Define input functions here (serveral actions, states or ranges which can only be changed at the same time)
	-- entry: [keycode] = { ["actions"] = { action1, action2, ... }, ["states"] = {}, ["name"] = name for display }
config.input.controlFunctions = { 
	[1] = { 
		["name"] = ReadText(1005, 16),	-- "Menu back"
		--["name"] = ReadText(1001, 2669),	-- "Back"
		["definingcontrol"] = {"actions", 16}, 
		["actions"] = { 2, 15, 16, 103, 326 }, 
		["states"] = {}, 
		["ranges"] = {},
		["contexts"]= { 1, 2, 3, 4, 5 }
	},  

	[2] = { 
		["name"] = ReadText(1001, 2670),	-- "Close"
		["definingcontrol"] = {"actions", 19}, 
		["actions"] = { 2, 15, 19, 104, 326 }, 
		["states"] = {}, 
		["ranges"] = {},
		["contexts"]= { 1, 2, 3, 4, 5 }
	},
	[3] = { 
		["name"] = ReadText(1001, 2671), 
		["definingcontrol"] = {"states", 22}, 
		["actions"] = { 124 }, 
		["states"] = { 1, 22, 23 }, 
		["ranges"] = {} 
	},
	[4] = { 
		["name"] = ReadText(1006, 12), 
		["definingcontrol"] = {"states", 12}, 
		["actions"] = { 133 }, 
		["states"] = { 12 }, 
		["ranges"] = {},
		["contexts"]= { 2 }
	},
	[5] = { 
		["name"] = ReadText(1005, 128), 
		["definingcontrol"] = {"actions", 128}, 
		["actions"] = { 128, 163 }, 
		["states"] = {}, 
		["ranges"] = {},
		["contexts"]= { 1, 2 }
	},
	[6] = { 
		["name"] = ReadText(1005, 129), 
		["definingcontrol"] = {"actions", 129}, 
		["actions"] = { 129, 164 }, 
		["states"] = {}, 
		["ranges"] = {},
		["contexts"]= { 1, 2 } 
	},
	[7] = { 
		["name"] = ReadText(1006, 10), 
		["definingcontrol"] = {"states", 10}, 
		["actions"] = { 187, 218 }, 
		["states"] = { 10 }, 
		["ranges"] = {},
		["contexts"]= { 2 }
	},
	[8] = { 
		["name"] = ReadText(1006, 11), 
		["definingcontrol"] = {"states", 11}, 
		["actions"] = { 186, 217 }, 
		["states"] = { 11 }, 
		["ranges"] = {},
		["contexts"]= { 2 }
	},
	[9] = { 
		["name"] = ReadText(1005, 179), 
		["definingcontrol"] = {"actions", 179}, 
		["actions"] = { 179, 208 }, 
		["states"] = {}, 
		["ranges"] = {},
		["contexts"]= { 1, 2 } 
	},
	[10] = { 
		["name"] = ReadText(1005, 175), 
		["definingcontrol"] = {"actions", 175}, 
		["actions"] = { 175, 211 }, 
		["states"] = {}, 
		["ranges"] = {} 
	},
	[11] = {
		["name"] = ReadText(1005, 180),
		["definingcontrol"] = {"actions", 180},
		["actions"] = { 180, 231 },
		["states"] = {},
		["ranges"] = {}
	},
	[12] = {
		["name"] = ReadText(1005, 182),
		["definingcontrol"] = {"actions", 182},
		["actions"] = { 182, 232 },
		["states"] = {},
		["ranges"] = {}
	},
	[13] = {
		["name"] = ReadText(1005, 113),
		["definingcontrol"] = {"actions", 113},
		["actions"] = { 113, 312 },
		["states"] = {},
		["ranges"] = {},
		["contexts"]= { 1, 2 },
	},
	[14] = {
		["name"] = ReadText(1005, 314),
		["definingcontrol"] = {"actions", 314},
		["actions"] = { 314, 315 },
		["states"] = {},
		["ranges"] = {},
		["contexts"]= { 1, 2 },
	},
	[15] = { 
		["name"] = ReadText(1005, 319), 
		["definingcontrol"] = {"actions", 319}, 
		["actions"] = { 319, 222 }, 
		["states"] = {}, 
		["ranges"] = {},
		["contexts"]= { 1, 2 } 
	},
	[16] = { 
		["name"] = ReadText(1005, 303), 
		["definingcontrol"] = {"actions", 303}, 
		["actions"] = { 303, 322 }, 
		["states"] = {}, 
		["ranges"] = {},
		["contexts"]= { 1, 2 } 
	},
	[17] = { 
		["name"] = ReadText(1005, 225), 
		["definingcontrol"] = {"actions", 225}, 
		["actions"] = { 225, 323 }, 
		["states"] = {}, 
		["ranges"] = {},
		["contexts"]= { 1, 2 } 
	},
	[18] = {
		["name"] = ReadText(1005, 363),
		["definingcontrol"] = {"actions", 363},
		["actions"] = { 332, 363 },
		["states"] = {},
		["ranges"] = {},
		["contexts"]= { 1, 2 },
	},
	[19] = {
		["name"] = ReadText(1005, 364),
		["definingcontrol"] = {"actions", 364},
		["actions"] = { 364, 365 },
		["states"] = {},
		["ranges"] = {},
		["contexts"]= { 1, 2 },
	},
}

config.input.controlsorder = {
	["space"] = {
		[1] = {
			["title"] = ReadText(1001, 4865),	-- "Steering: Analog"
			["mapable"] = true,
			{ "ranges", 21, nil, ReadText(1026, 2629) },
			{ "ranges", 22, nil, ReadText(1026, 2630) },
			{ "ranges", 2 },
			{ "ranges", 5 },
			{ "ranges", 6 },
			{ "ranges", 4 },
			{ "states", 90 },
			{ "ranges", 32, 2, ReadText(1026, 2629), true },
			{ "ranges", 33, 2, ReadText(1026, 2630), true },
			{ "ranges", 30, 2, nil, true },
		},
		[2] = {
			["title"] = ReadText(1001, 4866),	-- "Steering: Digital"
			["mapable"] = true,
			{ "states", 4 },
			{ "states", 5 },
			{ "states", 2 },
			{ "states", 3 },
			{ "states", 112 },
			{ "states", 113 },
			{ "states", 114 },
			{ "states", 115 },
			{ "states", 8 },
			{ "states", 9 },
			{ "states", 6 },
			{ "states", 7 },
			{ "states", 116 },
			{ "states", 117 },
			{ "states", 118 },
			{ "states", 119 },
			{ "states", 13 },
			{ "states", 14 },
			{ "states", 15 },
			{ "states", 16 },
			{ "states", 91 },
			{ "actions", 123 },
			{ "states", 17 },
			{ "states", 18 },
			{ "states", 19 },
			{ "actions", 7, nil, ReadText(1026, 2600) },
			{ "actions", 221, nil, ReadText(1026, 2601) },
			{ "actions", 261 },
			{ "actions", 324 },
			{ "actions", 330 },
		},
		[3] = {
			["title"] = ReadText(1001, 2663),	-- "Weapons"
			["mapable"] = true,
			{ "states", 24 },
			{ "states", 48 },
			{ "states", 25 },
			{ "actions", 8 },
			{ "actions", 9 },	-- "Previous weapon"
			{ "actions", 10 },
			{ "actions", 11 },	-- "Previous missile"
			{ "actions", 331 },
			{ "actions", 321 },	-- "Next ammo"
			{ "actions", 307 },
			{ "actions", 139 },
			{ "actions", 140 },
			{ "actions", 141 },
			{ "actions", 142 },
			{ "actions", 149 },
			{ "actions", 150 },
			{ "actions", 151 },
			{ "actions", 152 },
		},
		[4] = {
			["title"] = ReadText(1002, 1001),	-- "Modes"
			["mapable"] = true,
			{ "states", 84, display = function () return C.IsVROculusTouchActive() or C.IsVRViveControllerActive() end },
			{ "functions", 16 },
			{ "actions", 304 },
			{ "actions", 305 },
			{ "functions", 17, nil, ReadText(1026, 2610) },
		},
		[5] = { 
			["title"] = ReadText(1001, 7245),	-- "Menu Access"
			["mapable"] = true,
			{ "actions", 317 },
			{ "functions", 13 },
			{ "functions", 14 },
			{ "actions", 209 },
			{ "functions", 18 },
			{ "actions", 210 },
			{ "actions", 316 },
			{ "actions", 320 },
			{ "functions", 3 },
			{ "functions", 5, nil, ReadText(1026, 2602) },
			{ "functions", 6, nil, ReadText(1026, 2603) },
			{ "actions", 327, nil, ReadText(1026, 2651) },
			{ "functions", 19, nil, ReadText(1026, 2667) },
			{ "actions", 216, 2 },
		},
		[6] = { 
			["title"] = ReadText(1001, 2600),	-- "Options Menu"
			["mapable"] = true,
			{ "actions", 132 },
			{ "actions", 160 },
			{ "actions", 161 },
			{ "actions", 162 },
			{ "actions", 130 },
			{ "actions", 131 },
			{ "actions", 260, display = C.IsVRVersion },
		},
		[7] = { 
			["title"] = ReadText(1001, 4860),	-- "Camera"
			["mapable"] = true,
			{ "states", 81 },
			{ "functions", 11, nil, ReadText(1026, 2605) },
			{ "actions", 181, nil, ReadText(1026, 2606) },
			{ "functions", 12, nil, ReadText(1026, 2607) },
			{ "actions", 262 },
			{ "actions", 353 },
			{ "states", 70 },
			{ "states", 71 },
			{ "states", 72 },
			{ "states", 73 },
			{ "states", 74 },
			{ "states", 75 },
			{ "states", 76 },
			{ "states", 77 },
			{ "states", 78 },
			{ "states", 79 },
			{ "actions", 183 },
			{ "actions", 184 },
			{ "actions", 318 },
		},
		[8] = {
			["title"] = ReadText(1001, 7282),	--"Target Management"
			["mapable"] = true,
			{ "actions", 167 },
			{ "actions", 168, nil, ReadText(1026, 2604) },	-- "Target Object" (near crosshair)
			{ "actions", 289 },
			{ "actions", 169 },
			{ "actions", 170 },
			{ "actions", 213 },
			{ "actions", 214 },
			{ "actions", 275 },
		},
		[9] = {
			["title"] = ReadText(1001, 2664),	--"Misc"
			["mapable"] = true,
			{ "functions", 10 },
			{ "actions", 277 },
			{ "actions", 178, nil, ReadText(1026, 2609) },
			{ "functions", 9 },
			{ "functions", 15 },
			{ "actions", 117 },
			{ "actions", 120 },
			{ "actions", 219 },
			{ "states", 80, nil, ReadText(1026, 2612) },
			{ "actions", 260 },
			{ "actions", 325 },
			{ "actions", 328 },
			{ "actions", 329 },
			{ "actions", 343 },
			{ "actions", 344 },
			{ "actions", 345 },
			{ "actions", 346 },
			{ "actions", 347 },
			{ "actions", 348 },
			{ "actions", 349 },
			{ "actions", 350 },
			{ "actions", 351 },
			{ "actions", 352 },
		},
		[10] = {
			["title"] = ReadText(1001, 4815),	-- "Expert Settings - Use with Caution!"
			["mapable"] = true,
			{ "actions", 310 },
			{ "states", 96 },
			{ "actions", 137 },
			{ "actions", 121 },
			{ "actions", 166 },
			{ "actions", 224 },
			{ "actions", 306 },
			{ "actions", 223, nil, ReadText(1026, 2611) },
		},
	},
	["menus"] = {
		[1] = {
			["title"] = ReadText(1001, 7296),	-- "Menus - Analog"
			["mapable"] = true,
			{ "ranges", 23, { 2, 6 } },
			{ "ranges", 24, { 2, 6 } },
			{ "ranges", 25, 2 },
			{ "ranges", 26, 2 },
			{ "ranges", 27, 2 },
			{ "ranges", 28, 2 },
		},
		[2] = {
			["title"] = ReadText(1001, 2665),	-- "Menus - Digital"
			["mapable"] = false,
			{ "actions", 21, 2 },
			{ "actions", 20, 2 },
			{ "functions", 7 },
			{ "functions", 8 },
			{ "functions", 4 },
			{ "states", 97, 2 },
			{ "actions", 18, 2 },
			{ "actions", 17, 2 },
			{ "actions", 22, 2 },
			{ "actions", 308, 2 },
			{ "actions", 309, 2 },
			{ "functions", 1 },
			{ "functions", 2 },
			{ "states", 92, 6 },
			{ "states", 93, 6 },
			{ "states", 94, 6 },
			{ "states", 99, { 2, 6 } },
			{ "states", 100, { 2, 6 } },
			{ "states", 101, { 2, 6 } },
			{ "states", 102, { 2, 6 } },
			{ "states", 103, { 2, 6 } },
			{ "states", 104, { 2, 6 } },
			{ "states", 105, { 2, 6 } },
			{ "states", 106, { 2, 6 } },
			{ "states", 39, 2 },
			{ "states", 40, 2 },
			{ "states", 41, 2 },
			{ "states", 42, 2 },
			{ "states", 43, 2 },
			{ "states", 44, 2 },
			{ "states", 45, 2 },
			{ "states", 46, 2 },
			{ "states", 37, 2 },
			{ "states", 38, 2 },
		},
		[3] = {
			["title"] = ReadText(1001, 2666),
			["mapable"] = false,
			{ "states", 1, 3 },
			{ "actions", 294, 3 },
			{ "actions", 97, 3 },
			{ "actions", 98, 3 },
			{ "actions", 99, 3 },
			{ "actions", 100, 3 },
			{ "actions", 101, 3 },
			{ "actions", 102, 3 },
			{ "actions", 198, 3 },
			{ "actions", 199, 3 },
			{ "actions", 200, 3 },
			{ "actions", 201, 3 },
			{ "actions", 202, 3 },
			{ "actions", 203, 3 },
			{ "actions", 299, 3 },
			{ "actions", 300, 3 },
			{ "actions", 301, 3 },
			{ "actions", 302, 3 },
		},
		[4] = {
			["title"] = ReadText(1001, 3245),	-- "Map"
			["mapable"] = true,
			{ "actions", 216, 2 },	-- "Target Object" (in map)
			{ "actions", 264, 2 },
			{ "actions", 265, 2 },
			{ "actions", 222, 2 },
			{ "actions", 263, 2 },
		},
		[5] = {
			["title"] = ReadText(1001, 2664),
			["mapable"] = false,
			{ "ranges", 11, { 3, 4, 5 } },
			{ "ranges", 12, { 3, 4, 5 } },
			{ "actions", 336, 7 },
			{ "actions", 337, 7 },
		},
		[6] = {
			["title"] = "Menu Hotkeys",
			["mapable"] = true,
			{ "states", 98, 2 },
			{ "states", 121, 2 },
			{ "states", 122, 2 },
			{ "states", 123, 2 },
		},
	},
	["firstperson"] = {
		[1] = {
			["title"] = ReadText(1001, 4877),
			["mapable"] = true,
			{ "ranges", 15 },
			{ "ranges", 16 },
			{ "ranges", 13 },
			{ "ranges", 14 },
		},
		[2] = {
			["title"] = ReadText(1001, 4878),
			["mapable"] = true,
			{ "states", 26 },
			{ "states", 27 },
			{ "states", 32 },
			{ "states", 33 },
			{ "states", 87 },
			{ "states", 30 },
			{ "states", 31 },
			{ "states", 28 },
			{ "states", 29 },
			{ "states", 34 },
			{ "states", 35 },
			{ "states", 36 },
			{ "actions", 220 },
		},
	},
}

config.input.directInputHookDefinitions = {
	{"keyboardInput", 1, 0},
	{"mouseaxesInputPosSgn", 18, 1},
	{"mouseaxesInputNegSgn", 18, -1},
	{"mousebuttonsInput", 19, 0},
	{"oculustouchaxesInputPosSgn", 20, 1},
	{"oculustouchaxesInputNegSgn", 20, -1},
	{"oculusremoteaxesInputPosSgn", 21, 1},
	{"oculusremoteaxesInputNegSgn", 21, -1},
	{"viverightaxesInputPosSgn", 22, 1},
	{"viverightaxesInputNegSgn", 22, -1},
	{"viveleftaxesInputPosSgn", 23, 1},
	{"viveleftaxesInputNegSgn", 23, -1},
	{"oculustouchbuttonsInput", 24, 0},
	{"oculusremotebuttonsInput", 25, 0},
	{"viverightbuttonsInput", 26, 0},
	{"viveleftbuttonsInput", 27, 0},
}
for i = 1, 8 do
	table.insert(config.input.directInputHookDefinitions, {"joyaxesInputPosSgn" .. i, i + 1, 1})
	table.insert(config.input.directInputHookDefinitions, {"joyaxesInputNegSgn" .. i, i + 1, -1})
	table.insert(config.input.directInputHookDefinitions, {"joybuttonsInput" .. i, i + 9, 0})
end

config.input.directInputHooks = {}
for i, entry in ipairs(config.input.directInputHookDefinitions) do
	table.insert(config.input.directInputHooks, function (_, keycode) menu.remapInput(entry[2], keycode, entry[3]) end)
end

config.ventureDLCStates = {
	[0] = "valid",
	[1] = "userdisabled",
	[2] = "userskipped",
	[3] = "notpossible",
	[4] = "updatedisabled",
	[5] = "updateskipped",
	[6] = "updatenotpossible",
	[7] = "usercanceled",
	[8] = "unknownerror",
}

config.optionDefinitions = {
	["main"] = {
		name = function () return menu.isStartmenu and ReadText(1001, 2681) or ReadText(1001, 2600) end,
		info = function () return ReadText(1001, 2655) .. ReadText(1001, 120) .. " " .. GetVersionString() .. "\n" .. ffi.string(C.GetBuildVersionSuffix()) .. (C.IsGameModified() and (Helper.convertColorToText(Helper.color.warningorange) .. "(" .. ReadText(1001, 8901) .. ")") or "") end,
		[1] = {
			id = "onlineseason",
			name = function () return menu.nameOnlineSeason() end,
			callback = function () return menu.callbackOnlineSeason() end,
			selectable = function () return menu.selectableOnlineSeason() end,
			wordwrap = true,
			display = function () return C.IsVentureSeasonSupported() end,
		},
		[2] = {
			id = "continue",
			name = function () return menu.nameContinue() end,
			callback = function () return menu.callbackContinue() end,
			selectable = function () return menu.selectableContinue() end,
			wordwrap = true,
		},
		[3] = {
			id = "new",
			name = ReadText(1001, 2603),
			submenu = "new",
		},
		[4] = {
			id = "load",
			name = function () return (menu.autoReloadSave or C.IsSaveListLoadingComplete()) and ReadText(1001, 2604) or ReadText(1001, 7203) end,
			submenu = "load",
			selectable = function () return C.IsSaveListLoadingComplete() and C.HasSavegame() end,
		},
		[5] = {
			id = "save",
			name = ReadText(1001, 2605),
			submenu = "save",
			selectable = IsSavingPossible,
			display = function () return not menu.isStartmenu end,
			mouseOverText = function () return IsSavingPossible(false) and "" or ffi.string(C.GetSaveInquiryText()) end
		},
		[6] = {
			id = "multiplayer",
			name = ReadText(1001,7283),
			submenu = "multiplayer",
			display = C.IsNetworkEngineEnabled,
		},
		[7] = {
			id = "online",
			name = function () return menu.nameOnline() end,
			submenu = "online",
			selectable = C.IsOnlineEnabled,
			mouseOverText = function () return C.IsOnlineEnabled() and "" or ReadText(1001, 11592) end,
		},
		[8] = {
			id = "extensions",
			name = function () return menu.nameExtension() end,
			submenu = "extensions",
			display = function () return not C.IsDemoVersion() end,
		},
		[9] = {
			id = "bonus",
			name = ReadText(1001, 4800),
			submenu = "bonus",
			display = function () return false end, -- hidden, not needed in X4
		},
		[10] = {
			id = "settings",
			name = function () return menu.nameSettings() end,
			submenu = "settings",
		},
		[11] = {
			id = "credits",
			name = ReadText(1001, 4811),
			submenu = "credits",
			display = function () return menu.isStartmenu end,
		},
		[12] = {
			id = "exit",
			name = ReadText(1001, 2616),
			submenu = "exit",
			display = function () return not menu.isStartmenu end,
		},
		[13] = {
			id = "quit",
			name = ReadText(1001, 4876),
			submenu = "quit",
		},
	},
	["load"] = {
		name = ReadText(1001, 2604)
	},
	["save"] = {
		name = ReadText(1001, 2605)
	},
	["saveoffline"] = {
		name = ReadText(1001, 11712)
	},
	["multiplayer"] = {
		name = ReadText(1001,7283),
		[1] = {
			id = "multiplayer_server",
			name = ReadText(1001,7284),
			submenu = "multiplayer_server",
		},
		[2] = {
			id = "lobby",
			name = ReadText(1001,7285),
			submenu = "lobby",
		},
	},
	["online"] = {
		[1] = {
			id = "language",
			name = ReadText(1001, 11765),
			info = ReadText(1001, 11766),
			valuetype = "dropdown",
			value = function () return menu.valueOnlinePreferredLanguage() end,
			callback = function (id, option) return menu.callbackOnlinePreferredLanguage(id, option) end,
		},
		[2] = {
			id = "visitornames",
			name = ReadText(1001, 7298),
			info = ReadText(1001, 7297),
			valuetype = "button",
			value = function () return C.GetVisitorNamesShownOption() and ReadText(1001, 2617) or ReadText(1001, 2618) end,
			callback = function () return menu.callbackOnlineVisitorNames() end,
			display = function () return C.AreVenturesEnabled() end,
		},
		[3] = {
			id = "acceptinvitations",
			name = ReadText(1001, 11763),
			info = ReadText(1001, 11764),
			valuetype = "button",
			value = function () return menu.valueOnlineAllowInvites() end,
			callback = function () return menu.callbackOnlineAllowInvites() end,
			display = function () return C.IsVentureSeasonSupported() and OnlineHasSession() end,
		},
		[4] = {
			id = "acceptprivatemessages",
			name = ReadText(1001, 11772),
			info = ReadText(1001, 11773),
			valuetype = "button",
			value = function () return menu.valueOnlineAllowPrivateMessages() end,
			callback = function () return menu.callbackOnlineAllowPrivateMessages() end,
			display = function () return C.IsVentureSeasonSupported() and OnlineHasSession() end,
		},
		[5] = {
			id = "seasonupdates",
			name = ReadText(1001, 11309),
			valuetype = "dropdown",
			value = function () return menu.valueOnlineSeasonUpdates() end,
			callback = function (id, option) return menu.callbackOnlineSeasonUpdates(id, option) end,
			display = function () return false end,
		},
		[6] = {
			id = "operationupdates",
			name = ReadText(1001, 11310),
			valuetype = "dropdown",
			value = function () return menu.valueOnlineOperationUpdates() end,
			callback = function (id, option) return menu.callbackOnlineOperationUpdates(id, option) end,
			display = function () return false end,
		},
		[7] = {
			id = "promotion",
			name = ReadText(1001, 11311),
			valuetype = "dropdown",
			value = function () return menu.valueOnlinePromotion() end,
			callback = function (id, option) return menu.callbackOnlinePromotion(id, option) end,
			display = function () return false end,
		},
		[8] = {
			id = "seasonsummary",
			name = ReadText(1001, 11312),
			valuetype = "dropdown",
			value = function () return menu.valueOnlineSeasonSummary() end,
			callback = function (id, option) return menu.callbackOnlineSeasonSummary(id, option) end,
			display = function () return false end,
		},
	},
	["extensionsettings"] = {
		name = function () return menu.nameExtensionSettings() end,
		warning = function () return menu.warningExtensionSettings() end,
		[1] = {
			id = "enable",
			name = function () return menu.nameExtensionSettingEnabled() end,
			value = function () return menu.valueExtensionSettingEnabled() end,
			callback = function () return menu.callbackExtensionSettingEnabled() end,
		},
		[2] = {
			id = "sync",
			name = ReadText(1001, 4824),
			value = function () return menu.valueExtensionSettingSync() end,
			callback = function () return menu.callbackExtensionSettingSync() end,
			display = function () return menu.selectedExtension.isworkshop end,
		},
		[3] = {
			id = "workshop",
			name = ReadText(1001, 4828),
			callback = function () return menu.callbackExtensionSettingWorkshop() end,
			display = function () return menu.selectedExtension.isworkshop end,
		},
	},
	["settings"] = {
		name = ReadText(1001, 2679),
		warning = function () return menu.warningSettings() end,
		[1] = {
			id = "gfx",
			name = function () return menu.nameGfx() end,
			submenu = "gfx",
		},
		[2] = {
			id = "sfx",
			name = ReadText(1001, 2611),
			submenu = "sfx",
		},
		[3] = {
			id = "game",
			name = ReadText(1001, 2613),
			submenu = "game",
		},
		[4] = {
			id = "accessibility",
			name = ReadText(1001, 8994),
			submenu = "accessibility",
		},
		[5] = {
			id = "input",
			name = function () return menu.nameInput() end,
			submenu = "input",
		},
		[6] = {
			id = "privacy",
			name = ReadText(1001, 4870),
			submenu = "privacy",
		},
		[7] = {
			id = "language",
			name = function () return menu.nameLanguage() end,
			submenu = "language",
			display = function () return menu.isStartmenu and C.IsLanguageSettingEnabled() end
		},
		[8] = {
			id = "line",
		},
		[9] = {
			id = "defaults",
			name = ReadText(1001, 8981),
			submenu = "defaults",
		},
	},
	["gfx"] = {
		name = ReadText(1001, 2606),
		warning = function () return menu.warningGfx() end,
		[1] = {
			id = "hmd_resolution",
			name = ReadText(1001, 2619),
			value = function () return menu.valueGfxHMDResolution() end,
			display = C.IsVRVersion,
		},
		[2] = {
			-- non-VR case
			id = "resolution",
			name = ReadText(1001, 2619),
			valuetype = "dropdown",
			value = function () return menu.valueGfxResolution() end,
			callback = function (id, option) return menu.callbackGfxResolution(id, option) end,
			display = function () return not C.IsVRVersion() end,
			selectable = function () return menu.selectableGfxResolution() end,
		},
		[3] = {
			id = "antialias",
			name = ReadText(1001, 2620),
			valuetype = "dropdown",
			value = function () return menu.valueGfxAA() end,
			callback = function (id, option) return menu.callbackGfxAA(id, option) end,
		},
		[4] = {
			id = "upscaling",
			name = ReadText(1001, 11726),
			mouseOverText = function () return menu.selectableGfxUpscaling() and "" or ("\27R" ..  ReadText(1026, 2657)) end,
			valuetype = "dropdown",
			value = function () return menu.valueGfxUpscaling() end,
			callback = function (id, option) return menu.callbackGfxUpscaling(id, option) end,
			selectable = function () return menu.selectableGfxUpscaling() end,
		},
		[5] = {
			id = "adaptivesampling",
			name = ReadText(1001, 7221),
			valuetype = "dropdown",
			value = function () return menu.valueGfxAdaptiveSampling() end,
			callback = function (id, option) return menu.callbackGfxAdaptiveSampling(id, option) end,
			display = C.IsVRVersion,
		},
		[6] = {
			id = "hmd_fullscreen",
			name = ReadText(1001, 4817),
			value = function () return ReadText(1001, 2622), Helper.color.white end,
			display = C.IsVRVersion,
		},
		[7] = {
			id = "hmd_sdk",
			name = ReadText(1001, 7214),
			value = function () return ffi.string(C.GetTrackerSDKOption()), Helper.color.white end,
			display = C.IsVRVersion,
		},
		[8] = {
			id = "line",
			display = C.IsVRVersion,
		},
		[9] = {
			id = "hmd_adapter",
			name = ReadText(1001, 2623),
			value = function () return ffi.string(C.GetTrackerNameOption()), Helper.color.white end,
			display = C.IsVRVersion,
		},
		[10] = {
			id = "screendisplay",
			name = ReadText(1001, 7210),
			valuetype = "button",
			value = function () return C.GetScreenDisplayOption() and ReadText(1001, 2649) or ReadText(1001, 2648) end,
			callback = function () return menu.callbackGfxScreenDisplay() end,
			display = C.IsVRVersion,
		},
		[11] = {
			-- VR case
			id = "resolution",
			name = ReadText(1001, 7211),
			valuetype = "dropdown",
			value = function () return menu.valueGfxResolution() end,
			callback = function (id, option) return menu.callbackGfxResolution(id, option) end,
			display = C.IsVRVersion,
			selectable = function () return menu.selectableGfxResolution() end,
		},
		[12] = {
			id = "fullscreen",
			name = function () return C.IsVRVersion() and ReadText(1001, 7213) or ReadText(1001, 4817) end,
			valuetype = "dropdown",
			value = function () return menu.valueGfxFullscreen() end,
			callback = function (id, option) return menu.callbackGfxFullscreen(id, option) end,
			selectable = function () return menu.selectableGfxFullscreen() end,
		},
		[13] = {
			id = "autogpu",
			name = ReadText(1001, 11709),
			valuetype = "button",
			value = function () return C.IsGPUAutomaticallySelected() and ReadText(1001, 2648) or ReadText(1001, 2649) end,
			callback = function () return menu.callbackGfxAutoGPU() end,
		},
		[14] = {
			id = "gpu",
			name = ReadText(1001, 8920),
			valuetype = "dropdown",
			value = function () return menu.valueGfxGPU() end,
			callback = function (id, option) return menu.callbackGfxGPU(id, option) end,
			selectable = function () return menu.selectableGfxGPU() end,
		},
		[15] = {
			id = "adapter",
			name = ReadText(1001, 8921),
			valuetype = "dropdown",
			value = function () return menu.valueGfxAdapter() end,
			callback = function (id, option) return menu.callbackGfxAdapter(id, option) end,
			selectable = function () return menu.selectableGfxAdapter() end,
		},
		[16] = {
			id = "presentmode",
			name = ReadText(1001, 7265),
			valuetype = "dropdown",
			value = function () return menu.valueGfxPresentMode() end,
			callback = function (id, option) return menu.callbackGfxPresentMode(id, option) end,
		},
		[17] = {
			id = "lut",
			name = ReadText(1001, 7238),
			valuetype = "dropdown",
			value = function () return menu.valueGfxLUT(false) end,
			callback = function (id, option) return menu.callbackGfxLUT(id, option) end,
		},
		[18] = {
			id = "gamma",
			name = ReadText(1001, 2629),
			valuetype = "slidercell",
			value = function () return menu.valueGfxGamma() end,
			callback = function (value) return menu.callbackGfxGamma(value) end,
		},
		[19] = {
			id = "line",
		},
		[20] = {
			id = "gfx_preset",
			name = ReadText(1001, 4840),
			valuetype = "dropdown",
			value = function () return menu.valueGfxPreset() end,
			callback = function (id, option) return menu.callbackGfxPreset(id, option) end,
		},
		[21] = {
			id = "texturequality",
			name = ReadText(1001, 8900),
			valuetype = "dropdown",
			value = function () return menu.valueGfxTexture() end,
			callback = function (id, option) return menu.callbackGfxTexture(id, option) end,
			selectable = function () return menu.selectableGfxPreset() end,
		},
		[22] = {
			id = "shadows",
			name = ReadText(1001, 2625),
			valuetype = "dropdown",
			value = function () return menu.valueGfxShadows() end,
			callback = function (id, option) return menu.callbackGfxShadows(id, option) end,
			selectable = function () return menu.selectableGfxPreset() end,
		},
		[23] = {
			id = "softshadows",
			name = ReadText(1001, 4841),
			valuetype = "button",
			value = function () return GetSoftShadowsOption() and ReadText(1001, 2648) or ReadText(1001, 2649) end,
			callback = function () return menu.callbackGfxSoftShadows() end,
			selectable = function () return menu.selectableGfxPreset() end,
		},
		[24] = {
			id = "ssao",
			name = ReadText(1001, 2626),
			valuetype = "dropdown",
			value = function () return menu.valueGfxSSAO() end,
			callback = function (id, option) return menu.callbackGfxSSAO(id, option) end,
			selectable = function () return menu.selectableGfxPreset() end,
		},
		[25] = {
			id = "glow",
			name = ReadText(1001, 11752),
			valuetype = "dropdown",
			value = function () return menu.valueGfxGlow() end,
			callback = function (id, option) return menu.callbackGfxGlow(id, option) end,
			selectable = function () return menu.selectableGfxPreset() end,
		},
		[26] = {
			id = "chromaticaberration",
			name = ReadText(1001, 8987),
			valuetype = "button",
			value = function () return C.GetChromaticAberrationOption() and ReadText(1001, 2648) or ReadText(1001, 2649) end,
			callback = function () return menu.callbackGfxChromaticAberration() end,
			selectable = function () return menu.selectableGfxPreset() end,
		},
		[27] = {
			id = "distortion",
			name = ReadText(1001, 4822),
			valuetype = "button",
			value = function () return GetDistortionOption() and ReadText(1001, 2648) or ReadText(1001, 2649) end,
			callback = function () return menu.callbackGfxDistortion() end,
			selectable = function () return menu.selectableGfxPreset() end,
		},
		[28] = {
			id = "pom",
			name = ReadText(1001, 11731),
			valuetype = "dropdown",
			value = function () return menu.valueGfxPOM() end,
			callback = function (id, option) return menu.callbackGfxPOM(id, option) end,
			selectable = function () return menu.selectableGfxPreset() end,
		},
		[29] = {
			id = "lod",
			name = ReadText(1001, 2628),
			valuetype = "slidercell",
			value = function () return menu.valueGfxLOD() end,
			callback = function (value) return menu.callbackGfxLOD(value) end,
			selectable = function () return menu.selectableGfxPreset() end,
		},
		[30] = {
			id = "effectdist",
			name = ReadText(1001, 2699),
			valuetype = "slidercell",
			value = function () return menu.valueGfxEffectDistance() end,
			callback = function (value) return menu.callbackGfxEffectDistance(value) end,
			selectable = function () return menu.selectableGfxPreset() end,
		},
		[31] = {
			id = "shaderquality",
			name = ReadText(1001, 2680),
			valuetype = "dropdown",
			value = function () return menu.valueGfxShaderQuality() end,
			callback = function (id, option) return menu.callbackGfxShaderQuality(id, option) end,
			selectable = function () return menu.selectableGfxPreset() end,
			display = function () return false end, -- TEMP hidden until we get shaders with different quality
		},
		[32] = {
			id = "radar",
			name = ReadText(1001, 1706),
			valuetype = "dropdown",
			value = function () return menu.valueGfxRadar() end,
			callback = function (id, option) return menu.callbackGfxRadar(id, option) end,
			selectable = function () return menu.selectableGfxPreset() end,
		},
		[33] = {
			id = "ssr",
			name = ReadText(1001, 7288),
			valuetype = "dropdown",
			value = function () return menu.valueGfxSSR() end,
			callback = function (id, option) return menu.callbackGfxSSR(id, option) end,
			selectable = function () return menu.selectableGfxPreset() end,
		},
		[34] = {
			id = "envmapprobes",
			name = ReadText(1001, 11733),
			valuetype = "dropdown",
			value = function () return menu.valueGfxEnvMapProbes() end,
			callback = function (id, option) return menu.callbackGfxEnvMapProbes(id, option) end,
			selectable = function () return menu.selectableGfxPreset() end,
		},
		[35] = {
			id = "volumetric",
			name = ReadText(1001, 8990),
			valuetype = "dropdown",
			value = function () return menu.valueGfxVolumetric() end,
			callback = function (id, option) return menu.callbackGfxVolumetric(id, option) end,
			selectable = function () return menu.selectableGfxPreset() end,
		},
		[36] = {
			id = "line",
		},
		[37] = {
			id = "envmapprobesinsideglassfade",
			name = ReadText(1001, 11754),
			valuetype = "slidercell",
			value = function () return menu.valueGfxEnvMapProbesInsideGlassFade() end,
			callback = function (value) return menu.callbackGfxEnvMapProbesInsideGlassFade(value) end,
		},
		[38] = {
			id = "capturehq",
			name = ReadText(1001, 4816),
			valuetype = "button",
			value = function () return GetCaptureHQOption() and ReadText(1001, 2648) or ReadText(1001, 2649) end,
			callback = function () return menu.callbackGfxCaptureHQ() end,
		},
		[39] = {
			id = "line",
		},
		[40] = {
			id = "gfx_defaults",
			name = ReadText(1001, 8982),
			submenu = "gfx_defaults",
		},
	},
	["sfx"] = {
		name = ReadText(1001, 2611),
		[1] = {
			id = "sounddevice",
			name = ReadText(1001, 8960),
			valuetype = "dropdown",
			value = function () return menu.valueSfxDevice() end,
			callback = function (id, option) return menu.callbackSfxDevice(id, option) end,
		},
		[2] = {
			id = "sound",
			name = ReadText(1001, 2630),
			valuetype = "button",
			value = function () return GetSoundOption() and ReadText(1001, 2648) or ReadText(1001, 2649) end,
			callback = function () return menu.callbackSfxSound() end,
		},
		[3] = {
			id = "master",
			name = ReadText(1001, 2631),
			valuetype = "slidercell",
			value = function () return menu.valueSfxSetting("master") end,
			callback = function (value) return menu.callbackSfxSetting("master", value) end,
		},
		[4] = {
			id = "music",
			name = ReadText(1001, 2632),
			valuetype = "slidercell",
			value = function () return menu.valueSfxSetting("music") end,
			callback = function (value) return menu.callbackSfxSetting("music", value) end,
		},
		[5] = {
			id = "voice",
			name = ReadText(1001, 2633),
			valuetype = "slidercell",
			value = function () return menu.valueSfxSetting("voice") end,
			callback = function (value) return menu.callbackSfxSetting("voice", value) end,
		},
		[6] = {
			id = "ambient",
			name = ReadText(1001, 2634),
			valuetype = "slidercell",
			value = function () return menu.valueSfxSetting("ambient") end,
			callback = function (value) return menu.callbackSfxSetting("ambient", value) end,
		},
		[7] = {
			id = "ui",
			name = ReadText(1001, 2635),
			valuetype = "slidercell",
			value = function () return menu.valueSfxSetting("ui") end,
			callback = function (value) return menu.callbackSfxSetting("ui", value) end,
		},
		[8] = {
			id = "effect",
			name = ReadText(1001, 2636),
			valuetype = "slidercell",
			value = function () return menu.valueSfxSetting("effect") end,
			callback = function (value) return menu.callbackSfxSetting("effect", value) end,
		},
		[9] = {
			id = "line",
		},
		[10] = {
			id = "sfx_defaults",
			name = ReadText(1001, 8983),
			submenu = "sfx_defaults",
		},
	},
	["game"] = {
		name = ReadText(1001, 2613),
		[1] = {
			id = "header",
			name = ReadText(1001, 8974),
		},
		[2] = {
			id = "autosave",
			name = ReadText(1001, 407),
			valuetype = "button",
			value = function () return GetAutosaveOption() and ReadText(1001, 2648) or ReadText(1001, 2649) end,
			callback = function () return menu.callbackGameAutosave() end,
		},
		[3] = {
			id = "autosaveinterval",
			name = ReadText(1001, 8930),
			mouseOverText = ReadText(1026, 2641),
			valuetype = "dropdown",
			value = function () return menu.valueGameAutosaveInterval() end,
			callback = function (id, option) return menu.callbackGameAutosaveInterval(id, option) end,
			selectable = GetAutosaveOption,
		},
		[4] = {
			id = "header",
			name = ReadText(1001, 11706),
		},
		[5] = {
			id = "emergencyeject",
			name = ReadText(1001, 11705),
			mouseOverText = ReadText(1026, 3267),
			valuetype = "button",
			value = function () return C.GetEmergencyEjectOption() and ReadText(1001, 2648) or ReadText(1001, 2649) end,
			callback = function () return menu.callbackGameEmergencyEject() end,
		},
		[6] = {
			id = "header",
			name = ReadText(1001, 8973),
		},
		[7] = {
			id = "autoroll",
			name = ReadText(1001, 2644),
			valuetype = "button",
			value = function () return GetAutorollOption() and ReadText(1001, 2648) or ReadText(1001, 2649) end,
			callback = function () return menu.callbackGameAutoroll() end,
		},
		[8] = {
			id = "collision",
			name = ReadText(1001, 2698),
			valuetype = "button",
			value = function () return GetCollisionAvoidanceAssistOption() and ReadText(1001, 2648) or ReadText(1001, 2649) end,
			callback = function () return menu.callbackGameCollision() end,
		},
		[9] = {
			id = "boost",
			name = ReadText(1001, 2646),
			valuetype = "button",
			value = function () return GetBoostToggleOption() and ReadText(1001, 2648) or ReadText(1001, 2649) end,
			callback = function () return menu.callbackGameBoost() end,
		},
		[10] = {
			id = "aimassist",
			name = ReadText(1001, 2696),
			valuetype = "dropdown",
			value = function () return menu.valueGameAimAssist() end,
			callback = function (id, option) return menu.callbackGameAimAssist(id, option) end,
		},
		[11] = {
			id = "stopshipinmenu",
			name = ReadText(1001, 4884),
			valuetype = "button",
			value = function () return GetStopShipInMenuOption() and ReadText(1001, 2649) or ReadText(1001, 2648) end,
			callback = function () return menu.callbackGameStopInMenu() end,
		},
		[12] = {
			id = "header",
			name = ReadText(1001, 8972),
		},
		[13] = {
			id = "subtitles",
			name = ReadText(1001, 2643),
			valuetype = "dropdown",
			value = function () return menu.valueGameSubtitles() end,
			callback = function (id, option) return menu.callbackGameSubtitles(id, option) end,
		},
		[14] = {
			id = "speaktargetname",
			name = ReadText(1001, 8924),
			valuetype = "button",
			value = function () return C.GetSpeakTargetNameOption() and ReadText(1001, 2648) or ReadText(1001, 2649) end,
			callback = function () return menu.callbackGameSpeakTargetName() end,
		},
		[15] = {
			id = "mouselook",
			name = ReadText(1001, 4895),
			valuetype = "button",
			value = function () return GetMouseLookToggleOption() and ReadText(1001, 2648) or ReadText(1001, 2649) end,
			callback = function () return menu.callbackGameMouselook() end,
		},
		[16] = {
			id = "rumble",
			name = ReadText(1001, 2678),
			valuetype = "slidercell",
			value = function () return menu.valueGameRumble() end,
			callback = function (value) return menu.callbackGameRumble(value) end,
		},
		[17] = {
			id = "forceshoottocursor",
			name = ReadText(1001, 7218),
			valuetype = "button",
			value = function () return C.GetForceShootingAtCursorOption() and ReadText(1001, 2648) or ReadText(1001, 2649) end,
			callback = function () return menu.callbackGameShootAtCursor() end,
			display = C.IsVRVersion,
		},
		[18] = {
			id = "mouseover",
			name = ReadText(1001, 4882),
			valuetype = "button",
			value = function () return C.GetMouseOverTextOption() and ReadText(1001, 2648) or ReadText(1001, 2649) end,
			callback = function () return menu.callbackGameMouseOver() end,
		},
		[19] = {
			id = "radardisplay",
			name = ReadText(1001, 7258),
			valuetype = "dropdown",
			value = function () return menu.valueGameRadar() end,
			callback = function (id, option) return menu.callbackGameRadar(id, option) end,
		},
		[20] = {
			id = "uiscale",
			name = ReadText(1001, 7209),
			mouseOverText = ReadText(1026, 2626),
			valuetype = "slidercell",
			value = function () return menu.valueGameUIScale() end,
			callback = function (value) return menu.callbackGameUIScale(value) end,
			confirmline = {
				positive = function () return menu.callbackGameUIScaleConfirm() end,
				pos_name = ReadText(1001, 2821),
				pos_selectable = function () return menu.selectableGameUIScaleConfirm() end,
				negative = function () return menu.callbackGameUIScaleReset() end,
				neg_name = ReadText(1001, 3318),
				neg_selectable = function () return menu.selectableGameUIScaleConfirm() end,
			},
		},
		[21] = {
			id = "controlmodemessages",
			name = ReadText(1001, 4861),
			valuetype = "button",
			value = function () return GetSteeringNoteOption() and ReadText(1001, 2648) or ReadText(1001, 2649) end,
			callback = function () return menu.callbackGameControlModeMessages() end,
		},
		[22] = {
			id = "resetuserquestions",
			name = ReadText(1001, 8985),
			mouseOverText = ReadText(1026, 2652),
			valuetype = "confirmation",
			value = ReadText(1001, 8986),
			callback = function () return menu.callbackGameResetUserQuestions() end,
			selectable = function () return menu.selectableGameResetUserQuestions() end,
			inactive_text = ReadText(1026, 2653),
		},
		[23] = {
			id = "enemywarning_nearby",
			name = ReadText(1001, 11729),
			valuetype = "sounddropdown",
			value = function () return menu.valueGameEnemyNearby() end,
			callback = function (id, option) return menu.callbackGameEnemyNearby(id, option) end,
		},
		[24] = {
			id = "enemywarning_attack",
			name = ReadText(1001, 11730),
			valuetype = "sounddropdown",
			value = function () return menu.valueGameEnemyAttack() end,
			callback = function (id, option) return menu.callbackGameEnemyAttack(id, option) end,
		},
		[25] = {
			id = "startmenu_background",
			name = ReadText(1001, 11761),
			valuetype = "dropdown",
			value = function () return menu.valueGameStartmenuBackground() end,
			callback = function (id, option) return menu.callbackGameStartmenuBackground(id, option) end,
			display = function () return menu.isStartmenu end,
			confirmline = {
				positive = function () return menu.callbackGameStartmenuBackgroundConfirm() end,
				pos_name = ReadText(1001, 11778),
				pos_selectable = function () return menu.selectableGameStartmenuBackgroundConfirm() end,
			},
		},
		[26] = {
			id = "header",
			name = ReadText(1001, 4860),
		},
		[27] = {
			id = "cockpitcamera",
			name = ReadText(1001, 7289),
			valuetype = "slidercell",
			value = function () return menu.valueGameCockpitCamera() end,
			callback = function (value) return menu.callbackGameCockpitCamera(value) end,
		},
		[28] = {
			id = "header",
			name = ReadText(1001, 2661),
		},
		[29] = {
			id = "game_defaults",
			name = ReadText(1001, 8984),
			submenu = "game_defaults",
		},
	},
	["accessibility"] = {
		name = ReadText(1001, 8994),
		[1] = {
			id = "signalleakindicator",
			name = ReadText(1001, 8995),
			valuetype = "button",
			value = function () return C.GetSignalLeakIndicatorOption() and ReadText(1001, 2648) or ReadText(1001, 2649) end,
			callback = function () return menu.callbackAccessibilitySignalLeak() end,
		},
		[2] = {
			id = "longrangescanindicator",
			name = ReadText(1001, 8996),
			valuetype = "button",
			value = function () return C.GetLongRangeScanIndicatorOption() and ReadText(1001, 2648) or ReadText(1001, 2649) end,
			callback = function () return menu.callbackAccessibilityLongRangeScan() end,
		},
		[3] = {
			id = "globallightscale",
			name = ReadText(1001, 11755),
			valuetype = "slidercell",
			value = function () return menu.valueAccessibilityGlobalLightScale() end,
			callback = function (value) return menu.callbackAccessibilityGlobalLightScale(value) end,
		},
		[4] = {
			id = "lut",
			name = ReadText(1001, 7238),
			valuetype = "dropdown",
			value = function () return menu.valueGfxLUT(true) end,
			callback = function (id, option) return menu.callbackGfxLUT(id, option) end,
			display = function () return false end, -- TODO Florian
		},
		[5] = {
			id = "line",
		},
		[6] = {
			id = "accessibility_defaults",
			name = ReadText(1001, 8998),
			submenu = "accessibility_defaults",
		},
	},
	["input"] = {
		name = ReadText(1001, 2656),
		warning = function () return menu.warningInput() end,
		[1] = {
			id = "header",
			name = ReadText(1001, 7227),
			display = C.IsVROculusTouchActive,
		},
		[2] = {
			id = "vrtouch_space",
			name = ReadText(1001, 2658),
			submenu = "vrtouch_space",
			display = C.IsVROculusTouchActive,
		},
		[3] = {
			id = "vrtouch_firstperson",
			name = ReadText(1001, 2659),
			submenu = "vrtouch_firstperson",
			display = C.IsVROculusTouchActive,
		},
		[4] = {
			id = "vrtouch_menus",
			name = ReadText(1001, 2660),
			submenu = "vrtouch_menus",
			display = C.IsVROculusTouchActive,
		},
		[5] = {
			id = "header",
			name = ReadText(1001, 7228),
			display = C.IsVRViveControllerActive,
		},
		[6] = {
			id = "vrvive_space",
			name = ReadText(1001, 2658),
			submenu = "vrvive_space",
			display = C.IsVRViveControllerActive,
		},
		[7] = {
			id = "vrvive_firstperson",
			name = ReadText(1001, 2659),
			submenu = "vrvive_firstperson",
			display = C.IsVRViveControllerActive,
		},
		[8] = {
			id = "vrvive_menus",
			name = ReadText(1001, 2660),
			submenu = "vrvive_menus",
			display = C.IsVRViveControllerActive,
		},
		[9] = {
			id = "vrvive_pointingdevice",
			name = ReadText(1001, 7224),
			valuetype = "dropdown",
			value = function () return menu.valueInputVivePointingDevice() end,
			callback = function (id, option) return menu.callbackInputVivePointingDevice(id, option) end,
			display = C.IsVRViveControllerActive,
		},
		[10] = {
			id = "header",
			name = function () return (C.IsVROculusTouchActive() or C.IsVRViveControllerActive()) and ReadText(1001, 7229) or ReadText(1001, 2656) end,
		},
		[11] = {
			id = "keyboard_space",
			name = ReadText(1001, 2658),
			submenu = "keyboard_space",
		},
		[12] = {
			id = "keyboard_firstperson",
			name = ReadText(1001, 2659),
			submenu = "keyboard_firstperson",
		},
		[13] = {
			id = "keyboard_menus",
			name = ReadText(1001, 2660),
			submenu = "keyboard_menus",
		},
		[14] = {
			id = "header",
			name = ReadText(1001, 2674),
		},
		[15] = {
			id = "joysticks",
			name = ReadText(1001, 4856),
			submenu = "joysticks",
		},
		[16] = {
			id = "joystick_invert",
			name = ReadText(1001, 2675),
			submenu = "joystick_invert",
		},
		[17] = {
			id = "joystick_sensitivity",
			name = ReadText(1001, 2684),
			submenu = "joystick_sensitivity",
		},
		[18] = {
			id = "joystick_deadzone",
			name = ReadText(1001, 4835),
			valuetype = "slidercell",
			value = function () return menu.valueInputJoystickDeadzone() end,
			callback = function(value) return menu.callbackInputJoystickDeadzone(value) end,
		},
		[19] = {
			id = "joystick_bidirectional_throttle",
			name = ReadText(1001, 7261),
			valuetype = "button",
			value = function () return C.IsThrottleBidirectional() and ReadText(1001, 2648) or ReadText(1001, 2649) end,
			callback = function () return menu.callbackInputJoystickBidirectionalThrottle() end,
		},
		[20] = {
			id = "gamepadmode",
			name = ReadText(1001, 4867),
			valuetype = "dropdown",
			value = function () return menu.valueInputGamepadMode() end,
			callback = function (id, option) return menu.callbackInputGamepadMode(id, option) end,
		},
		[21] = {
			id = "joystick_steering_adaptive",
			name = ReadText(1001, 7264),
			valuetype = "button",
			value = function () return C.IsJoystickSteeringAdapative() and ReadText(1001, 2648) or ReadText(1001, 2649) end,
			callback = function () return menu.callbackInputJoystickSteeringAdaptive() end,
		},
		[22] = {
			id = "header",
			name = ReadText(1001, 2683),
		},
		[23] = {
			id = "mouse_invert",
			name = ReadText(1001, 2675),
			submenu = "mouse_invert",
		},
		[24] = {
			id = "mouse_sensitivity",
			name = ReadText(1001, 2684),
			submenu = "mouse_sensitivity",
		},
		[25] = {
			id = "mouse_capture",
			name = ReadText(1001, 4820),
			valuetype = "button",
			value = function () return GetConfineMouseOption() and ReadText(1001, 2648) or ReadText(1001, 2649) end,
			callback = function () return menu.callbackInputMouseCapture() end,
		},
		[26] = {
			id = "mouse_steering_adaptive",
			name = ReadText(1001, 7264),
			valuetype = "button",
			value = function () return C.IsMouseSteeringAdapative() and ReadText(1001, 2648) or ReadText(1001, 2649) end,
			callback = function () return menu.callbackInputMouseSteeringAdaptive() end,
		},
		[27] = {
			id = "mouse_steering_persistent",
			name = ReadText(1001, 11768),
			valuetype = "button",
			value = function () return C.IsMouseSteeringPersistent() and ReadText(1001, 2648) or ReadText(1001, 2649) end,
			callback = function () return menu.callbackInputMouseSteeringPersistent() end,
		},
		[28] = {
			id = "mouse_steering_line",
			name = ReadText(1001, 11769),
			valuetype = "button",
			value = function () return C.IsMouseSteeringLineEnabled() and ReadText(1001, 2648) or ReadText(1001, 2649) end,
			callback = function () return menu.callbackInputMouseSteeringLine() end,
		},
		[29] = {
			id = "mouse_hud_mode",
			name = ReadText(1001, 8937),
			valuetype = "dropdown",
			value = function () return menu.valueInputMouseHUDMode() end,
			callback = function (id, option) return menu.callbackInputMouseHUDMode(id, option) end,
		},
		[30] = {
			id = "header",
			name = ReadText(1001, 8940),
			display = C.IsTobiiAvailable,
		},
		[31] = {
			id = "tobii_mode",
			name = ReadText(1001, 8941),
			valuetype = "dropdown",
			value = function () return menu.valueInputTobiiMode() end,
			callback = function (id, option) return menu.callbackInputTobiiMode(id, option) end,
			display = C.IsTobiiAvailable,
		},
		[32] = {
			id = "tobii_headfilterstrength",
			name = ReadText(1001, 8954),
			mouseOverText = ReadText(1026, 2647),
			valuetype = "slidercell",
			value = function () return menu.valueInputTobiiHeadFilterStrength() end,
			callback = function(value) return menu.callbackInputTobiiHeadFilterStrength(value) end,
			display = function () return menu.displayTobiiHeadTracking() end,
		},
		[33] = {
			id = "tobii_anglefactor",
			name = ReadText(1001, 8950),
			mouseOverText = ReadText(1026, 2644),
			valuetype = "slidercell",
			value = function () return menu.valueInputTobiiAngleFactor() end,
			callback = function(value) return menu.callbackInputTobiiAngleFactor(value) end,
			display = function () return menu.displayTobiiHeadTracking() end,
		},
		[34] = {
			id = "tobii_deadzoneangle",
			name = ReadText(1001, 8952),
			mouseOverText = ReadText(1026, 2645),
			valuetype = "slidercell",
			value = function () return menu.valueInputTobiiDeadzoneAngle() end,
			callback = function(value) return menu.callbackInputTobiiDeadzoneAngle(value) end,
			display = function () return menu.displayTobiiHeadTracking() end,
		},
		[35] = {
			id = "tobii_positionfactor",
			name = ReadText(1001, 8958),
			mouseOverText = ReadText(1026, 2650),
			valuetype = "slidercell",
			value = function () return menu.valueInputTobiiPositionFactor() end,
			callback = function(value) return menu.callbackInputTobiiPositionFactor(value) end,
			display = function () return menu.displayTobiiHeadTracking() end,
		},
		[36] = {
			id = "tobii_deadzoneposition",
			name = ReadText(1001, 8953),
			mouseOverText = ReadText(1026, 2646),
			valuetype = "slidercell",
			value = function () return menu.valueInputTobiiDeadzonePosition() end,
			callback = function(value) return menu.callbackInputTobiiDeadzonePosition(value) end,
			display = function () return menu.displayTobiiHeadTracking() end,
		},
		[37] = {
			id = "tobii_gazefilterstrength",
			name = ReadText(1001, 8955),
			mouseOverText = ReadText(1026, 2648),
			valuetype = "slidercell",
			value = function () return menu.valueInputTobiiGazeFilterStrength() end,
			callback = function(value) return menu.callbackInputTobiiGazeFilterStrength(value) end,
			display = function () return menu.displayTobiiGazeContinous() end,
		},
		[38] = {
			id = "tobii_gazeanglefactor",
			name = ReadText(1001, 8951),
			mouseOverText = ReadText(1026, 2644),
			valuetype = "slidercell",
			value = function () return menu.valueInputTobiiGazeAngleFactor() end,
			callback = function(value) return menu.callbackInputTobiiGazeAngleFactor(value) end,
			display = function () return menu.displayTobiiGazeContinous() end,
		},
		[39] = {
			id = "tobii_gazedeadzone",
			name = ReadText(1001, 8949),
			mouseOverText = ReadText(1026, 2649),
			valuetype = "slidercell",
			value = function () return menu.valueInputTobiiGazeDeadzone() end,
			callback = function(value) return menu.callbackInputTobiiGazeDeadzone(value) end,
			display = function () return menu.displayTobiiGazeContinous() end,
		},
		[40] = {
			id = "header",
			name = ReadText(1001, 4857),
		},
		[41] = {
			id = "profile_load",
			name = ReadText(1001, 4859),
			submenu = "profile_load",
		},
		[42] = {
			id = "profile_save",
			name = ReadText(1001, 4858),
			submenu = "profile_save",
		},
	},
	["joystick_invert"] = {
		name = ReadText(1001, 2674) .. ReadText(1001, 120) .. " " .. ReadText(1001, 2675),
		[1] = {
			id = "invert_steering_yaw",
			name = ReadText(config.input.controltextpage.ranges, 1),
			valuetype = "button",
			value = function () return menu.valueInputInvert(1) end,
			callback = function () return menu.callbackInputInvert(1, "invert_steering_yaw") end,
		},
		[2] = {
			id = "invert_steering_pitch",
			name = ReadText(config.input.controltextpage.ranges, 2),
			valuetype = "button",
			value = function () return menu.valueInputInvert(2) end,
			callback = function () return menu.callbackInputInvert(2, "invert_steering_pitch") end,
		},
		[3] = {
			id = "invert_steering_roll",
			name = ReadText(config.input.controltextpage.ranges, 3),
			valuetype = "button",
			value = function () return menu.valueInputInvert(3) end,
			callback = function () return menu.callbackInputInvert(3, "invert_steering_roll") end,
		},
		[4] = {
			id = "invert_throttle",
			name = ReadText(config.input.controltextpage.ranges, 4),
			valuetype = "button",
			value = function () return menu.valueInputInvert(4) end,
			callback = function () return menu.callbackInputInvert(4, "invert_throttle") end,
		},
		[5] = {
			id = "invert_strafe_left_right",
			name = ReadText(config.input.controltextpage.ranges, 5),
			valuetype = "button",
			value = function () return menu.valueInputInvert(5) end,
			callback = function () return menu.callbackInputInvert(5, "invert_strafe_left_right") end,
		},
		[6] = {
			id = "invert_strafe_up_down",
			name = ReadText(config.input.controltextpage.ranges, 6),
			valuetype = "button",
			value = function () return menu.valueInputInvert(6) end,
			callback = function () return menu.callbackInputInvert(6, "invert_strafe_up_down") end,
		},
		[7] = {
			id = "invert_fp_yaw",
			name = ReadText(config.input.controltextpage.ranges, 13),
			valuetype = "button",
			value = function () return menu.valueInputInvert(13) end,
			callback = function () return menu.callbackInputInvert(13, "invert_fp_yaw") end,
		},
		[8] = {
			id = "invert_fp_pitch",
			name = ReadText(config.input.controltextpage.ranges, 14),
			valuetype = "button",
			value = function () return menu.valueInputInvert(14) end,
			callback = function () return menu.callbackInputInvert(14, "invert_fp_pitch") end,
		},
		[9] = {
			id = "invert_fp_walk",
			name = ReadText(config.input.controltextpage.ranges, 15),
			valuetype = "button",
			value = function () return menu.valueInputInvert(15) end,
			callback = function () return menu.callbackInputInvert(15, "invert_fp_walk") end,
		},
		[10] = {
			id = "invert_fp_strafe",
			name = ReadText(config.input.controltextpage.ranges, 16),
			valuetype = "button",
			value = function () return menu.valueInputInvert(16) end,
			callback = function () return menu.callbackInputInvert(16, "invert_fp_strafe") end,
		},
		[11] = {
			id = "invert_controllermouse_x",
			name = ReadText(config.input.controltextpage.ranges, 23),
			valuetype = "button",
			value = function () return menu.valueInputInvert(23) end,
			callback = function () return menu.callbackInputInvert(23, "invert_direct_mouse_steering_roll") end,
		},
		[12] = {
			id = "invert_controllermouse_y",
			name = ReadText(config.input.controltextpage.ranges, 24),
			valuetype = "button",
			value = function () return menu.valueInputInvert(24) end,
			callback = function () return menu.callbackInputInvert(24, "invert_direct_mouse_steering_roll") end,
		},
	},
	["joystick_sensitivity"] = {
		name = ReadText(1001, 2674) .. ReadText(1001, 120) .. " " .. ReadText(1001, 2684),
		[1] = {
			id = "sensitivity_fp_yaw",
			name = ReadText(config.input.controltextpage.ranges, 13),
			valuetype = "slidercell",
			value = function () return menu.valueInputSensitivity(13) end,
			callback = function (value) return menu.callbackInputSensitivity(13, "sensitivity_fp_yaw", value) end,
		},
		[2] = {
			id = "sensitivity_fp_pitch",
			name = ReadText(config.input.controltextpage.ranges, 14),
			valuetype = "slidercell",
			value = function () return menu.valueInputSensitivity(14) end,
			callback = function (value) return menu.callbackInputSensitivity(14, "sensitivity_fp_pitch", value) end,
		},
	},
	["mouse_invert"] = {
		name = ReadText(1001, 2683) .. ReadText(1001, 120) .. " " .. ReadText(1001, 2675),
		[1] = {
			id = "invert_mouse_pitch",
			name = ReadText(1001, 8975),
			valuetype = "button",
			value = function () return menu.valueInputMouseSteeringInvert("invert_mouse_pitch") end,
			callback = function () return menu.callbackInputMouseSteeringInvert("invert_mouse_pitch") end,
		},
		[2] = {
			id = "invert_mouse_yaw",
			name = ReadText(1001, 8976),
			valuetype = "button",
			value = function () return menu.valueInputMouseSteeringInvert("invert_mouse_yaw") end,
			callback = function () return menu.callbackInputMouseSteeringInvert("invert_mouse_yaw") end,
		},
		[3] = {
			id = "invert_mouse_roll",
			name = ReadText(1001, 8977),
			valuetype = "button",
			value = function () return menu.valueInputMouseSteeringInvert("invert_mouse_roll") end,
			callback = function () return menu.callbackInputMouseSteeringInvert("invert_mouse_roll") end,
		},
		[4] = {
			id = "invert_fp_mouse_yaw",
			name = ReadText(config.input.controltextpage.ranges, 7),
			valuetype = "button",
			value = function () return menu.valueInputInvert(7) end,
			callback = function () return menu.callbackInputInvert(7, "invert_fp_mouse_yaw") end,
		},
		[5] = {
			id = "invert_fp_mouse_pitch",
			name = ReadText(config.input.controltextpage.ranges, 8),
			valuetype = "button",
			value = function () return menu.valueInputInvert(8) end,
			callback = function () return menu.callbackInputInvert(8, "invert_fp_mouse_pitch") end,
		},
		[6] = {
			id = "invert_direct_mouse_steering_yaw",
			name = ReadText(config.input.controltextpage.ranges, 29),
			valuetype = "button",
			value = function () return menu.valueInputInvert(29) end,
			callback = function () return menu.callbackInputInvert(29, "invert_direct_mouse_steering_yaw") end,
		},
		[7] = {
			id = "invert_direct_mouse_steering_pitch",
			name = ReadText(config.input.controltextpage.ranges, 30),
			valuetype = "button",
			value = function () return menu.valueInputInvert(30) end,
			callback = function () return menu.callbackInputInvert(30, "invert_direct_mouse_steering_pitch") end,
		},
		[8] = {
			id = "invert_direct_mouse_steering_roll",
			name = ReadText(config.input.controltextpage.ranges, 31),
			valuetype = "button",
			value = function () return menu.valueInputInvert(31) end,
			callback = function () return menu.callbackInputInvert(31, "invert_direct_mouse_steering_roll") end,
		},
	},
	["mouse_sensitivity"] = {
		name = ReadText(1001, 2683) .. ReadText(1001, 120) .. " " .. ReadText(1001, 2684),
		[1] = {
			id = "sensitivity_fp_mouse_yaw",
			name = ReadText(config.input.controltextpage.ranges, 7),
			valuetype = "slidercell",
			value = function () return menu.valueInputSensitivity(7) end,
			callback = function (value) return menu.callbackInputSensitivity(7, "sensitivity_fp_mouse_yaw", value) end,
		},
		[2] = {
			id = "sensitivity_fp_mouse_pitch",
			name = ReadText(config.input.controltextpage.ranges, 8),
			valuetype = "slidercell",
			value = function () return menu.valueInputSensitivity(8) end,
			callback = function (value) return menu.callbackInputSensitivity(8, "sensitivity_fp_mouse_pitch", value) end,
		},
		[3] = {
			id = "sensitivity_direct_mouse_steering_yaw",
			name = ReadText(config.input.controltextpage.ranges, 29),
			valuetype = "slidercell",
			value = function () return menu.valueInputSensitivity(29) end,
			callback = function (value) return menu.callbackInputSensitivity(29, "sensitivity_direct_mouse_steering_yaw", value) end,
		},
		[4] = {
			id = "sensitivity_direct_mouse_steering_pitch",
			name = ReadText(config.input.controltextpage.ranges, 30),
			valuetype = "slidercell",
			value = function () return menu.valueInputSensitivity(30) end,
			callback = function (value) return menu.callbackInputSensitivity(30, "sensitivity_direct_mouse_steering_pitch", value) end,
		},
		[5] = {
			id = "sensitivity_direct_mouse_steering_roll",
			name = ReadText(config.input.controltextpage.ranges, 31),
			valuetype = "slidercell",
			value = function () return menu.valueInputSensitivity(31) end,
			callback = function (value) return menu.callbackInputSensitivity(31, "sensitivity_direct_mouse_steering_roll", value) end,
		},
	},
	["privacy"] = {
		name = ReadText(1001, 4870),
		[1] = {
			id = "crashreport",
			name = ReadText(1001, 4871),
			info = ReadText(1001, 4874),
			valuetype = "button",
			value = function () return GetCrashReportOption() and ReadText(1001, 2617) or ReadText(1001, 2618) end,
			callback = function () return menu.callbackPrivacyCrash() end,
		},
		[2] = {
			id = "senduserid",
			name = ReadText(1001, 4873),
			info = ReadText(1001, 4875),
			valuetype = "button",
			value = function () return GetPersonalizedCrashReportsOption() and ReadText(1001, 2617) or ReadText(1001, 2618) end,
			callback = function () return menu.callbackPrivacyUserID() end,
			display = C.AllowPersonalizedData
		},
		[3] = {
			id = "policy",
			name = ReadText(1001, 7292),
			info = ReadText(1001, 7293),
			valuetype = "button",
			value = "\27[mm_externallink]",
			callback = function () return menu.buttonPrivacyPolicy() end,
			selectable = C.CanOpenWebBrowser,
		},
	},
}


--- widget hooks ---

function menu.onClientStarted()
	__CORE_GAMEOPTIONS_VENTURECONFIG = {
		allow_validation = OnlineGetVentureConfig("allow_validation"),
		allow_update = OnlineGetVentureConfig("allow_update"),
		allow_update_once = OnlineGetVentureConfig("allow_update_once"),
	}
end

function menu.onOpenSubMenu(_, submenu)
	menu.openSubmenu(submenu, menu.selectedOption.id)
end

function menu.onGfxDone()
	if menu.userQuestion and menu.userQuestion.timer then
		menu.userQuestion.timer = getElapsedTime() + 15.9 -- to avoid the counter jumping to 14 immediately, but avoiding 16 -> see onUpdate()
		menu.userQuestion.gfxDone = true
	end
end

function menu.loadSaveCallback(_, filename)
	if (type(filename) ~= "string") or (not C.IsSaveValid(filename)) then
		DebugError("Lua Event 'loadSave' got an invalid filename '" .. tostring(filename) .. "'.")
		return
	end

	C.SkipNextStartAnimation()
	menu.delayedLoadGame = filename
	menu.displayInit()
	SetScript("onUpdate", function () if menu.delayedLoadGame then LoadGame(menu.delayedLoadGame); menu.delayedLoadGame = nil end end)
end

function menu.serverDiscoveredCallback(_, server)
	menu.lobby = menu.lobby or {}
	local separatorpos = string.find(server, ":")
	local roomname = string.sub(server, 1, separatorpos)
	local address = string.sub(server, separatorpos + 1)
	table.insert(menu.lobby, { name = roomname, address = address })

	menu.updateServers = true
end

function menu.onExtensionSettingChanged()
	menu.extensionSettingsChanged = nil
	menu.extensionSettings = GetAllExtensionSettings()
end

function menu.onCutsceneStopped()
	if menu.cutsceneid then
		if menu.currentOption == "idle" then
			menu.cutsceneid = StartCutscene(menu.cutscenedesc, GetRenderTargetTexture(menu.rendertarget))
		else
			if menu.cutscenedesc then
				ReleaseCutsceneDescriptor(menu.cutscenedesc)
			end
			menu.cutscenedesc = nil
			menu.cutsceneid = nil
	
			menu.preselectOption = "credits"
			menu.submenuHandler("main")
			if menu.isStartmenu then
				C.SetSceneCameraActive(true)
				C.StartStartMenuBGMusic()
			end
		end
	elseif menu.playNewGameCutscene and menu.playNewGameCutscene.cutsceneid then
		if menu.playNewGameCutscene.cutscenedesc then
			ReleaseCutsceneDescriptor(menu.playNewGameCutscene.cutscenedesc)
		end
		-- keep id to prevent new playthrough
		menu.playNewGameCutscene.cutsceneid = nil
		menu.playNewGameCutscene.cutscenedesc = nil
		menu.playNewGameCutscene.movie = nil
		menu.playNewGameCutscene.movievoice = nil
		menu.refresh()
		if menu.isStartmenu then
			C.StartStartMenuBGMusic()
		end
	end
end

function menu.onOnlineLogin(_, serializedArg)
	if menu.onlineData and menu.onlineData.loginAttempt then
		local hasRegisteredGame, error = string.match(serializedArg, "(.*);(.*)")
		hasRegisteredGame = tonumber(hasRegisteredGame)

		if error ~= "" then
			menu.onlineData.loginError = error
		else
			menu.onlineData.username = OnlineGetUserName()
		end
		menu.onlineData.loginAttempt = false
		menu.onlineData.hasRegisteredGame = hasRegisteredGame == 1

		C.ResetEncryptedDirectInputData()
		menu.onlineData.password = ""

		if C.IsVentureSeasonSupported() and (error == "") and (not OnlineGetVentureConfig("allow_validation")) and (not OnlineGetVentureConfig("disable_popup")) then
			menu.contextMenuMode = "ventureextension"
			menu.contextMenuData = { width = Helper.scaleX(400), y = Helper.viewHeight / 2, refreshOnClose = true }
			menu.createContextMenu()
		end

		menu.onlineRefresh = true
	elseif menu.currentOption == "main" then
		menu.refresh()
	end
end

function menu.onVersionIncompatible()
	if menu.currentOption == "main" then
		menu.refresh()
	end
end

function menu.buttonControl(row, data)
	if data and not menu.remapControl then
		-- set update to blink "_" and pass variables on to menu.remapInput
		menu.remapControl = { row = row, col = data[6], controltype = data[1], controlcode = data[2], controlcontext = data[8] or 1, oldinputtype = data[3], oldinputcode = data[4], oldinputsgn = data[5], nokeyboard = data[7], allowmouseaxis = data[9] }

		-- call function listening to input and get result
		menu.registerDirectInput()
	end
end

function menu.buttonInputProfileSave(profile)
	table.insert(menu.history, 1, { optionParameter = menu.currentOption, topRow = GetTopRow(menu.optionTable), selectedOption = profile.id })
	menu.displayUserQuestion(ReadText(1001, 4858) .. " - \"" .. profile.name .. "\"", function () return menu.callbackInputProfileSave(profile) end)
end

function menu.buttonReloadLobby()
	menu.lobby = {}
	C.QueryGameServers()
	menu.drawLobby()
end

function menu.buttonReloadSaveGames()
	menu.savegames = nil
	menu.onlinesave = nil
	C.ReloadSaveList()
	menu.displaySavegameOptions(menu.currentOption)
end

function menu.buttonOverwriteSave()
	if menu.selectedOption and next(menu.selectedOption) and (menu.selectedOption.titlerow == nil) and (menu.selectedOption.submenu == nil) then
		if menu.currentOption == "saveoffline" then
			table.insert(menu.history, 1, { optionParameter = menu.currentOption, topRow = GetTopRow(menu.optionTable), selectedOption = filename })
			local savegame = Helper.tableCopy(menu.selectedOption)
			menu.displayUserQuestion(ReadText(1001, 11714), function () return menu.callbackSave(savegame, menu.savegameName) end, nil, nil, nil, nil, nil, ReadText(1001, 11715))
		elseif menu.selectedOption.empty then
			menu.callbackSave(menu.selectedOption, menu.savegameName)
		else
			local filename = menu.selectedOption.filename
			table.insert(menu.history, 1, { optionParameter = menu.currentOption, topRow = GetTopRow(menu.optionTable), selectedOption = filename })
			local savegame = Helper.tableCopy(menu.selectedOption)
			if savegame.name == nil then
				DebugError("Florian needs this!")
				print("menu.selectedOption:")
				for k, v in pairs(menu.selectedOption) do
					print("   " .. k .. ": " .. tostring(v))
				end
				print("savegame:")
				for k, v in pairs(savegame) do
					print("   " .. k .. ": " .. tostring(v))
				end
			end
			menu.displayUserQuestion(menu.selectedOption.isonline and ReadText(1001, 11708) or ReadText(1001, 8971), function () return menu.callbackSave(savegame, menu.savegameName) end)
		end
	end
end

function menu.buttonDeleteSave()
	if menu.selectedOption and next(menu.selectedOption) and (menu.selectedOption.titlerow == nil) and (menu.selectedOption.submenu == nil) then
		if not menu.selectedOption.empty then
			local filename = menu.selectedOption.filename
			table.insert(menu.history, 1, { optionParameter = menu.currentOption, topRow = GetTopRow(menu.optionTable), selectedOption = filename })
			menu.displayUserQuestion(ReadText(1001, 8933), function () return menu.callbackDeleteSave(filename) end)
		end
	end
end

function menu.buttonOnlineLogin()
	menu.onlineData.loginError = false
	menu.onlineData.loginAttempt = true
	if not OnlineLogIn(menu.onlineData.username, menu.onlineData.remember) then
		menu.onlineData.loginAttempt = false
		menu.onlineData.loginError = true
	end

	menu.onlineRefresh = true
end

function menu.buttonOnlineRegister()
	if C.CanOpenWebBrowser() then
		local apiinfo
		if menu.onlineData.hasRegisteredGame == false then
			apiinfo = "?"
		else
			apiinfo = "&"
		end
		if C.IsGOGVersion() then
			apiinfo = apiinfo .. "api=gog"
		else
			apiinfo = apiinfo .. "api=steam"
		end
		local steamid = ffi.string(C.GetSteamID())
		if steamid ~= "" then
			apiinfo = string.format("%s&steamid=%s", apiinfo, steamid)
		end
		C.OpenWebBrowser(((menu.onlineData.hasRegisteredGame == false) and ReadText(1001, 8918) or ReadText(1001, 7294)) .. apiinfo)
		menu.buttonOnlineLogout()
	end
end

function menu.buttonPrivacyPolicy()
	if C.CanOpenWebBrowser() then
		C.OpenWebBrowser(ReadText(1001, 7295))
	end
end

function menu.buttonOnlineHelp()
	if C.CanOpenWebBrowser() then
		C.OpenWebBrowser(ReadText(1001, 11767))
	end
end

function menu.buttonOnlineLogout()
	local isonline = Helper.isOnlineGame()
	if not isonline then
		__CORE_GAMEOPTIONS_PRIVACYPOLICY = false
		OnlineLogOut()
		menu.onlineData.hasRegisteredGame = nil
		menu.onlineRefresh = true
	end
end

function menu.buttonUserQuestionPositive()
	menu.userQuestion.callback(menu.userQuestion.hasEditBox and menu.userQuestion.editboxText or nil)
	menu.userQuestion = nil
end

function menu.buttonUserQuestionNegative()
	if menu.userQuestion.negCallback then
		menu.userQuestion.negCallback()
	else
		menu.onCloseElement("back")
	end
end

function menu.buttonExtensionGlobalSync()
	local globalsync
	if menu.extensionSettings[0] ~= nil and menu.extensionSettings[0].sync ~= nil then
		globalsync = menu.extensionSettings[0].sync
	else
		globalsync = GetGlobalSyncSetting()
	end
	SetExtensionSettings("", false, "sync", not globalsync)
	menu.extensionSettingsChanged = nil
	menu.extensionSettings = GetAllExtensionSettings()
end

function menu.buttonSoundTest(optionid)
	if menu.curDropDownOption[optionid] ~= "" then
		PlaySound(menu.curDropDownOption[optionid])
	end
end

function menu.checkboxOnlineRemember(_, value)
	menu.onlineData.remember = value
end

function menu.checkboxOnlinePrivacyPolicy(_, value)
	__CORE_GAMEOPTIONS_PRIVACYPOLICY = value
end

function menu.checkboxScheduleVentureExtensionDownload(_, value)
	OnlineSetVentureConfig("allow_update_once", value)
end

function menu.editboxInputProfileSave(profile, text)
	SaveInputProfile(profile.filename, profile.id, text, true)
	profile.name = (text == "") and ReadText(1023, profile.id) or text
	profile.customname = text
end

function menu.editboxOnlineUsername(widgetid, text)
	menu.onlineData.username = text
end

function menu.editboxOnlineUsernameDeactivated(_, text, textchanged, isconfirmed, wastableclick)
	if isconfirmed and (not wastableclick) and (text ~= "") then
		menu.activatePasswordEditBox = true
	end
	menu.onlineData.usernameEditBoxActive = nil
end

function menu.editboxOnlinePassword(widgetid, text)
	menu.onlineData.password = text
end

function menu.editboxOnlinePasswordDeactivated(_, text, textchanged, isconfirmed)
	if isconfirmed and (not wastableclick) and (text ~= "") then
		if (menu.onlineData.username ~= "") and (__CORE_GAMEOPTIONS_PRIVACYPOLICY == true) then
			menu.preselectOption = 4
			menu.buttonOnlineLogin()
		end
	end
end

function menu.buttonOpenStore(extensionsource)
	if IsSteamworksEnabled() then
		OpenSteamOverlayStorePage(extensionsource)
	elseif C.IsGOGVersion() then
		if C.CanOpenWebBrowser() then
			C.OpenWebBrowser(extensionsource)
		end
	end
end

function menu.editboxUserQuestionTextChanged(_, text)
	menu.userQuestion.editboxText = text
end

function menu.editboxSaveName(_, text)
	menu.savegameName = text
end

function menu.dropdownVentureExtensionDownload(_, id)
	if id == "never" then
		OnlineSetVentureConfig("allow_validation", false)
		OnlineSetVentureConfig("allow_update", false)
		OnlineSetVentureConfig("allow_update_once", false)
	elseif id == "always" then
		OnlineSetVentureConfig("allow_validation", true)
		OnlineSetVentureConfig("allow_update", true)
		OnlineSetVentureConfig("allow_update_once", false)
	elseif id == "manual" then
		OnlineSetVentureConfig("allow_validation", true)
		OnlineSetVentureConfig("allow_update", false)
		OnlineSetVentureConfig("allow_update_once", OnlineGetVentureConfig("allow_update_once"))
	end
	menu.refresh()
end

--- helper functions ---

function menu.addSavegameRow(ftable, savegame, name, slot)
	-- kuertee start: callback
	local isSaveFileOk = true
	if callbacks ["addSavegameRow_isListSaveGame"] then
		for _, callback in ipairs (callbacks ["addSavegameRow_isListSaveGame"]) do
			isSaveFileOk = callback(ftable, savegame, name, slot)
			if not isSaveFileOk then
				break
			end
		end
	end
	if not isSaveFileOk then
		return 0
	end
	-- kuertee end: callback

	-- kuertee start: callback
	if callbacks ["addSavegameRow_changeSaveGameDisplayName"] then
		for _, callback in ipairs (callbacks ["addSavegameRow_changeSaveGameDisplayName"]) do
			name = callback(ftable, savegame, name, slot, name)
		end
	end
	-- kuertee end: callback

	local invalid = false
	if menu.currentOption == "load" then
		invalid = savegame.error or savegame.invalidgameid or savegame.invalidversion or savegame.invalidpatches
	end

	local row = ftable:addRow(savegame, { bgColor = Helper.color.transparent })
	if menu.preselectOption == nil then
		menu.preselectOption = savegame.filename
	end
	if savegame.filename == menu.preselectOption then
		ftable:setSelectedRow(row.index)
		menu.selectedOption = savegame
	end

	if slot then
		row[2]:createText(slot, (not invalid) and config.standardTextProperties or config.disabledTextProperties)
		row[2].properties.halign = "right"
	end
	local nametruncated = TruncateText(name, config.fontBold, Helper.scaleFont(config.font, config.standardFontSize), row[3]:getWidth() - Helper.scaleX(config.standardTextOffsetX))

	local mouseovertext = ""
	if nametruncated ~= name then
		mouseovertext = name
	end

	local isonlinesaveinofflineslot = IsCheatVersion() and savegame.isonline and not savegame.isonlinesavefilename

	local height = Helper.scaleY(config.standardTextHeight) + Helper.borderSize
	if invalid or savegame.modified or isonlinesaveinofflineslot then
		height = 2 * Helper.scaleY(config.standardTextHeight) + Helper.borderSize
	end

	local warningicon = ""
	if savegame.isonline then
		if C.IsClientModified() or (not OnlineHasSession()) or (C.GetVentureDLCStatus() ~= 0) then
			warningicon = Helper.convertColorToText(Helper.color.warningorange) .. "\27[workshop_error]\27X"
		end
	end

	icon = row[3]:createIcon("solid", { width = row[3]:getWidth(), height = height, color = { r = 0, g = 0, b = 0, a = 1 }, scaling = false, mouseOverText = mouseovertext }):setText(warningicon .. nametruncated, (not invalid) and config.standardTextProperties or config.disabledTextProperties)

	row[3].properties.text.font = config.fontBold
	row[3].properties.text.scaling = true
	if invalid then
		icon:setText2(function () return menu.errorSavegame(savegame) end, (not invalid) and config.standardTextProperties or config.disabledTextProperties)
		row[3].properties.text2.y = config.standardTextHeight
		row[3].properties.text2.scaling = true
	elseif savegame.modified then
		icon:setText2(Helper.convertColorToText(Helper.color.warningorange) .. ReadText(1001, 8901) .. "\27X", (not invalid) and config.standardTextProperties or config.disabledTextProperties)
		row[3].properties.text2.y = config.standardTextHeight
		row[3].properties.text2.scaling = true
	elseif isonlinesaveinofflineslot then
		icon:setText2(Helper.convertColorToText(Helper.color.brightyellow) .. ReadText(1001, 11570) .. "\27X", (not invalid) and config.standardTextProperties or config.disabledTextProperties)
		row[3].properties.text2.y = config.standardTextHeight
		row[3].properties.text2.scaling = true
	end
	row[4]:setColSpan(2):createText(savegame.error and "" or savegame.time, (not invalid) and config.standardTextProperties or config.disabledTextProperties)
	row[4].properties.halign = "right"

	return row:getHeight()
end

function menu.checkInputSource(sourceid)
	if (menu.currentOption == "keyboard_space") or (menu.currentOption == "keyboard_firstperson") or (menu.currentOption == "keyboard_menus") then
		return sourceid < 20
	elseif (menu.currentOption == "vrtouch_space") or (menu.currentOption == "vrtouch_firstperson") or (menu.currentOption == "vrtouch_menus") then
		return (sourceid == 20) or (sourceid == 24)
	elseif (menu.currentOption == "vrvive_space") or (menu.currentOption == "vrvive_firstperson") or (menu.currentOption == "vrvive_menus") then
		return (sourceid == 22) or (sourceid == 23) or (sourceid == 26) or (sourceid == 27)
	end
end

function menu.cleanup()
	if not menu.isStartmenu then
		if menu.paused then
			Unpause()
			menu.paused = nil
		end
		if menu.hasInputModeChangedRegistered then
			unregisterForEvent("inputModeChanged", getElement("Scene.UIContract"), menu.onInputModeChanged)
			menu.hasInputModeChangedRegistered = nil
		end
	end

	C.ResetEncryptedDirectInputData()
	if menu.onlineData then
		menu.onlineData.password = ""
	end

	menu.currentOption = nil
	menu.selectedOption = nil
	menu.preselectOption = nil
	menu.preselectTopRow = nil
	menu.preselectCol = nil
	menu.animationDelay = nil

	menu.history = {}
	menu.savegames = nil
	menu.onlinesave = nil
	menu.languagedata = {}
	menu.remapControl = nil
	menu.lobby = {}
	menu.updateServers = nil
	menu.selectedExtension = {}
	menu.curDropDownOption = {}
	menu.idleTimer = nil

	menu.controls = {}

	menu.contextFrame = nil

	menu.titleTable = nil
	menu.optionTable = nil
	menu.infoTable = nil
	menu.rendertarget = nil

	menu.width = nil
	menu.widthExtraWide = nil
	menu.height = nil
	menu.frameOffsetX = nil
	menu.frameOffsetXExtraWide = nil
	menu.frameOffsetY = nil

	menu.table = {}

	-- kuertee start: callback
	if callbacks ["cleanup"] then
		for _, callback in ipairs (callbacks ["cleanup"]) do
			callback()
		end
	end
	-- kuertee end: callback
end

function menu.createOptionsFrame(extrawide)
	menu.optionsFrame = Helper.createFrameHandle(menu, {
		layer = config.optionsLayer,
		x = extrawide and menu.frameOffsetXExtraWide or menu.frameOffsetX,
		y = menu.frameOffsetY,
		width = extrawide and menu.widthExtraWide or menu.width,
		height = menu.height,
		backgroundID = menu.isStartmenu and config.frame.bgTexture or nil,
		overlayID = config.frame.fgTexture,
		standardButtons = {},
	})

	return menu.optionsFrame
end

function menu.createTopLevel()
	Helper.clearDataForRefresh(menu, config.topLevelLayer)

	local frame = Helper.createFrameHandle(menu, {
		x = 0,
		y = 0,
		width = Helper.viewWidth,
		height = Helper.viewHeight,
		layer = config.topLevelLayer,
		standardButtons = {},
		backgroundID = (not menu.isStartmenu) and "solid" or nil,
		backgroundColor = Helper.color.semitransparent,
	})

	local height = Helper.createTopLevelTab(menu, "options", frame, "", nil, true)
	local optionsheight = Helper.viewHeight - config.frame.y - height
	frame.properties.height = optionsheight + menu.frameOffsetY + height

	frame:display()

	return height
end

function menu.createContextMenu()
	Helper.clearDataForRefresh(menu, config.contextLayer)

	local sizeextension = 2 * Helper.borderSize
	local xoffset = menu.frameOffsetX + (menu.width - menu.contextMenuData.width) / 2
	if (menu.contextMenuMode == "modified") or (menu.contextMenuMode == "ventureextension") then
		sizeextension = 6 * Helper.borderSize
		xoffset = (Helper.viewWidth - menu.contextMenuData.width) / 2
	end

	menu.contextFrame = Helper.createFrameHandle(menu, {
		width = menu.contextMenuData.width + sizeextension,
		x = xoffset,
		y = menu.contextMenuData.y,
		layer = config.contextLayer,
		standardButtons = { close = true },
		backgroundID = "solid",
		backgroundColor = Helper.color.black,
	})

	local height = 0
	if menu.contextMenuMode == "remap" then
		height = menu.createContextMenuRemap(menu.contextFrame)
	elseif menu.contextMenuMode == "modified" then
		height = menu.createContextMenuModified(menu.contextFrame)
	elseif menu.contextMenuMode == "ventureextension" then
		height = menu.createContextMenuVentureExtension(menu.contextFrame)
	end

	menu.contextFrame.properties.height = height + sizeextension
	if (menu.contextMenuMode == "modified") or (menu.contextMenuMode == "ventureextension") then
		menu.contextFrame.properties.y = menu.contextFrame.properties.y - menu.contextFrame.properties.height / 2
	end
	menu.contextFrame:display()
end

function menu.createContextMenuRemap(frame)
	local ftable = frame:addTable(5, { tabOrder = 1, x = Helper.borderSize, y = Helper.borderSize, width = menu.contextMenuData.width, highlightMode = "off" })

	local row = ftable:addRow(nil, { fixed = true, bgColor = Helper.color.transparent })
	row[1]:setColSpan(5):createText(ReadText(1001, 8978), config.subHeaderTextProperties)

	local row = ftable:addRow(nil, { fixed = true, bgColor = Helper.color.transparent })
	row[1]:setColSpan(5):createText(ReadText(1001, 8979), { wordwrap = true })

	local active = true
	local mouseovertext = ""
	for _, conflict in ipairs(menu.contextMenuData.conflicts) do
		local row = ftable:addRow(nil, { fixed = true, bgColor = Helper.color.transparent })

		local name
		if conflict.control[1] == "functions" then
			name = menu.controls[conflict.control[1]][conflict.control[2]].name
		else
			name = ReadText(config.input.controltextpage[conflict.control[1]], conflict.control[2])
		end
		row[1]:setColSpan(5):createText("· " .. name, { color = (not conflict.mapable) and Helper.color.red or nil })
		if not conflict.mapable then
			active = false
			mouseovertext = ReadText(1026, 2662)
		end
	end

	local row = ftable:addRow(nil, { fixed = true, bgColor = Helper.color.transparent })
	row[1]:setColSpan(5):createText(" ")

	local row = ftable:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
	row[2]:createButton({ active = active, mouseOverText = mouseovertext }):setText(ReadText(1001, 2821), { halign = "center" })
	row[2].handlers.onClick = function () menu.remapInputInternal(menu.contextMenuData.newinput[1], menu.contextMenuData.newinput[2], menu.contextMenuData.newinput[3]); menu.closeContextMenu() end

	row[4]:createButton({  }):setText(ReadText(1001, 64), {halign = "center" })
	row[4].handlers.onClick = menu.closeContextMenu

	return ftable:getVisibleHeight()
end

function menu.createContextMenuModified(frame)
	local ftable = frame:addTable(6, { tabOrder = 1, width = menu.contextMenuData.width, x = 3 * Helper.borderSize, y = 3 * Helper.borderSize, defaultInteractiveObject = true })
	ftable:setColWidth(1, Helper.scaleY(Helper.standardButtonHeight), false)
	ftable:setColWidthPercent(5, 25, false)
	ftable:setColWidthPercent(6, 25, false)

	local row = ftable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
	row[1]:setColSpan(6):createText(menu.contextMenuData.thirdparty and ReadText(1001, 9713) or ReadText(1001, 9716), Helper.headerRowCenteredProperties)

	local row = ftable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
	row[1]:setColSpan(6):createText(ReadText(1001, 9717) .. ((not menu.contextMenuData.thirdparty) and ("\n\n" .. ReadText(1001, 9718)) or ""), { wordwrap = true })

	ftable:addEmptyRow()

	local row = ftable:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
	row[1]:createCheckBox(function () return menu.contextMenuData.saveOption == true end, { height = Helper.standardButtonHeight })
	row[1].handlers.onClick = function () menu.contextMenuData.saveOption = not menu.contextMenuData.saveOption end
	row[2]:setColSpan(3):createButton({ bgColor = Helper.color.transparent }):setText(ReadText(1001, 9711))
	row[2].handlers.onClick = function () menu.contextMenuData.saveOption = not menu.contextMenuData.saveOption end
	row[6]:createButton({ helpOverlayID = "modified_client_confirm", helpOverlayText = " ", helpOverlayHighlightOnly = true }):setText(ReadText(1001, 14), { halign = "center" })
	row[6].handlers.onClick = function() __CORE_DETAILMONITOR_USERQUESTION[menu.contextMenuMode] = menu.contextMenuData.saveOption; menu.closeContextMenu() end
	ftable:setSelectedCol(6)

	return ftable:getVisibleHeight()
end

function menu.createContextMenuVentureExtension(frame)
	local ftable = frame:addTable(6, { tabOrder = 1, width = menu.contextMenuData.width, x = 3 * Helper.borderSize, y = 3 * Helper.borderSize, defaultInteractiveObject = true })
	ftable:setColWidth(1, Helper.scaleY(Helper.standardButtonHeight), false)
	ftable:setColWidthPercent(5, 25, false)
	ftable:setColWidthPercent(6, 25, false)

	local row = ftable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
	row[1]:setColSpan(6):createText(ReadText(1001, 11359), Helper.headerRowCenteredProperties)

	local row = ftable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
	row[1]:setColSpan(6):createText(ReadText(1001, 11360), { wordwrap = true })

	ftable:addEmptyRow()

	local row = ftable:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
	row[1]:createCheckBox(function () return menu.contextMenuData.saveOption == true end, { height = Helper.standardButtonHeight })
	row[1].handlers.onClick = function () menu.contextMenuData.saveOption = not menu.contextMenuData.saveOption end
	row[2]:setColSpan(3):createButton({ bgColor = Helper.color.transparent }):setText(ReadText(1001, 9711))
	row[2].handlers.onClick = function () menu.contextMenuData.saveOption = not menu.contextMenuData.saveOption end
	row[5]:createButton({ helpOverlayID = "venture_extension_download_confirm", helpOverlayText = " ", helpOverlayHighlightOnly = true }):setText(ReadText(1001, 2617), { halign = "center" })
	row[5].handlers.onClick = function()
			if menu.contextMenuData.saveOption then OnlineSetVentureConfig("disable_popup", true) end
			OnlineSetVentureConfig("allow_validation", true)
			OnlineSetVentureConfig("allow_update", true)
			if menu.contextMenuData.refreshOnClose then
				menu.displayOnlineLogin()
			end
			menu.closeContextMenu()
		end
	row[6]:createButton({ helpOverlayID = "venture_extension_download_cancel", helpOverlayText = " ", helpOverlayHighlightOnly = true }):setText(ReadText(1001, 2618), { halign = "center" })
	row[6].handlers.onClick = function() 
			if menu.contextMenuData.saveOption then OnlineSetVentureConfig("disable_popup", true) end
			menu.closeContextMenu()
		end
	ftable:setSelectedCol(6)

	return ftable:getVisibleHeight()
end

function menu.onTabScroll(direction)
	if direction == "right" then
		Helper.scrollTopLevel(menu, "options", 1)
	elseif direction == "left" then
		Helper.scrollTopLevel(menu, "options", -1)
	end
end

function menu.onInputModeChanged(_, mode)
	menu.createTopLevel()
end

function menu.displayControlRow(ftable, controlsgroup, controltype, code, context, mouseovertext, mapable, isdoubleclickmode, allowmouseaxis)
	local buttons = {}
	local name = ""
	local context = context
	if controltype == "functions" then
		name = menu.controls[controltype][code].name
		context = menu.controls[controltype][code].contexts

		local definingcontrol = menu.controls[controltype][code].definingcontrol
		local inputs = menu.controls[definingcontrol[1]][definingcontrol[2]]

		if type(inputs) == "table" then
			local displayed = 0
			for _, input in ipairs(inputs) do
				if type(input[1]) == "number" and menu.checkInputSource(input[1]) then
					local keyname, keyicon = menu.getInputName(input[1], input[2], input[3])
					if keyname ~= "" then
						displayed = displayed + 1
						if (not mapable) and (input[1] == 1) then
							if displayed == 1 then
								buttons[displayed] = { keyname = keyname, keyicon = keyicon, input1 = input[1], input2 = input[2], input3 = input[3], notmapable = true }
							else
								buttons[displayed] = buttons[1]
								buttons[1] = { keyname = keyname, keyicon = keyicon, input1 = input[1], input2 = input[2], input3 = input[3], notmapable = true }
							end
							mapable = true
						else
							buttons[displayed] = { keyname = keyname, keyicon = keyicon, input1 = input[1], input2 = input[2], input3 = input[3], inactive = (not isdoubleclickmode) and (input[1] == 19) and (input[2] == 3) }
						end
					end
				end
			end
		end
	else
		name = ReadText(config.input.controltextpage[controltype], code)
		if type(menu.controls[controltype][code]) == "table" then
			local displayed = 0
			for _, input in ipairs(menu.controls[controltype][code]) do
				if type(input[1]) == "number" and menu.checkInputSource(input[1]) then
					local keyname, keyicon = menu.getInputName(input[1], input[2], input[3])
					if keyname ~= "" then
						displayed = displayed + 1
						if (not mapable) and (input[1] == 1) then
							if displayed == 1 then
								buttons[displayed] = { keyname = keyname, keyicon = keyicon, input1 = input[1], input2 = input[2], input3 = input[3], notmapable = true }
							else
								buttons[displayed] = buttons[1]
								buttons[1] = { keyname = keyname, keyicon = keyicon, input1 = input[1], input2 = input[2], input3 = input[3], notmapable = true }
							end
							mapable = true
						else
							buttons[displayed] = {keyname = keyname, keyicon = keyicon, input1 = input[1], input2 = input[2], input3 = input[3], inactive = (not isdoubleclickmode) and (input[1] == 19) and (input[2] == 3) }
						end
					end
				end
			end
		end
	end
			
	for i = 1, (next(buttons) and #buttons or 1), 2 do
		local row = ftable:addRow(true, { bgColor = Helper.color.transparent })
		if row.index == menu.preselectOption then
			ftable:setSelectedRow(row.index)
			if menu.preselectCol == 3 then
				if buttons[i] and (buttons[i].notmapable == nil) then
					ftable:setSelectedCol(3)
				end
			elseif menu.preselectCol == 4 then
				if buttons[i+1] and (buttons[i+1].notmapable == nil) then
					ftable:setSelectedCol(4)
				end
			end
		end
		row[2]:createText(name, config.standardTextProperties)
		if mouseovertext then
			row[2].properties.mouseOverText = mouseovertext
		end
		if buttons[i] and (buttons[i].notmapable ~= nil) then
			local text = buttons[i].keyname
			if buttons[i].keyicon then
				local iconwidth = C.GetTextWidth(" " .. buttons[i].keyicon, config.font, Helper.scaleFont(config.font, config.standardFontSize))
				text = TruncateText(text, config.font, Helper.scaleFont(config.font, config.standardFontSize), row[3]:getWidth() - 2 * Helper.scaleX(config.standardTextOffsetX) - iconwidth)
			end
			local button = row[3]:createButton({ bgColor = Helper.color.transparent, highlightColor = Helper.color.grey, mouseOverText = buttons[i].inactive and ReadText(1026, 2634) or "" }):setText(function () return menu.nameControl(text, row.index, 3) end, { color = buttons[i].inactive and Helper.color.red or Helper.color.white })
			if buttons[i].keyicon then
				button:setText2(buttons[i].keyicon, { halign = "right" })
			end
		else
			local text = buttons[i] and buttons[i].keyname or " "
			if buttons[i] and buttons[i].keyicon then
				local iconwidth = C.GetTextWidth(" " .. buttons[i].keyicon, config.font, Helper.scaleFont(config.font, config.standardFontSize))
				text = TruncateText(text, config.font, Helper.scaleFont(config.font, config.standardFontSize), row[3]:getWidth() - 2 * Helper.scaleX(config.standardTextOffsetX) - iconwidth)
			end
			local button = row[3]:createButton({ mouseOverText = (buttons[i] and buttons[i].inactive) and ReadText(1026, 2634) or "" }):setText(function () return menu.nameControl(text, row.index, 3) end, { color = buttons[i] and (buttons[i].inactive and Helper.color.red or Helper.color.white) or Helper.color.red })
			if buttons[i] and buttons[i].keyicon then
				button:setText2(buttons[i].keyicon, { halign = "right" })
			end
			if buttons[i] then
				row[3].handlers.onClick = function () return menu.buttonControl(row.index, {controltype, code, buttons[i].input1, buttons[i].input2, buttons[i].input3, 3, not mapable, context, allowmouseaxis}) end
				row[3].properties.uiTriggerID = "remapcontrol1a" 
			else
				row[3].handlers.onClick = function () return menu.buttonControl(row.index, {controltype, code, -1, -1, 0, 3, not mapable, context, allowmouseaxis}) end
				row[3].properties.uiTriggerID = "remapcontrol1b" 
			end
		end
		if mouseovertext then
			row[3].properties.mouseOverText = mouseovertext
		end
		if buttons[i+1] and (buttons[i+1].notmapable ~= nil) then
			local text = buttons[i+1].keyname
			if buttons[i+1].keyicon then
				local iconwidth = C.GetTextWidth(" " .. buttons[i+1].keyicon, config.font, Helper.scaleFont(config.font, config.standardFontSize))
				text = TruncateText(text, config.font, Helper.scaleFont(config.font, config.standardFontSize), row[4]:getWidth() - 2 * Helper.scaleX(config.standardTextOffsetX) - iconwidth)
			end
			local button = row[4]:createButton({ bgColor = Helper.color.transparent, highlightColor = Helper.color.grey, mouseOverText = buttons[i+1].inactive and ReadText(1026, 2634) or "" }):setText(function () return menu.nameControl(text, row.index, 3) end, { color = buttons[i+1].inactive and Helper.color.red or Helper.color.white })
			if buttons[i+1].keyicon then
				button:setText2(buttons[i+1].keyicon, { halign = "right" })
			end
		else
			local text = buttons[i+1] and buttons[i+1].keyname or " "
			if buttons[i+1] and buttons[i+1].keyicon then
				local iconwidth = C.GetTextWidth(" " .. buttons[i+1].keyicon, config.font, Helper.scaleFont(config.font, config.standardFontSize))
				text = TruncateText(text, config.font, Helper.scaleFont(config.font, config.standardFontSize), row[4]:getWidth() - 2 * Helper.scaleX(config.standardTextOffsetX) - iconwidth)
			end
			local button = row[4]:createButton({ mouseOverText = (buttons[i+1] and buttons[i+1].inactive) and ReadText(1026, 2634) or "" }):setText(function () return menu.nameControl(text, row.index, 4) end, { color = buttons[i+1] and (buttons[i+1].inactive and Helper.color.red or Helper.color.white) or Helper.color.red })
			if buttons[i+1] and buttons[i+1].keyicon then
				button:setText2(buttons[i+1].keyicon, { halign = "right" })
			end
			if buttons[i+1] then
				row[4].handlers.onClick = function () return menu.buttonControl(row.index, {controltype, code, buttons[i+1].input1, buttons[i+1].input2, buttons[i+1].input3, 4, not mapable, context, allowmouseaxis}) end
				row[4].properties.uiTriggerID = "remapcontrol2a" 
			else
				row[4].handlers.onClick = function () return menu.buttonControl(row.index, {controltype, code, -1, -1, 0, 4, not mapable, context, allowmouseaxis}) end
				row[4].properties.uiTriggerID = "remapcontrol2b" 
			end
		end
		if mouseovertext then
			row[4].properties.mouseOverText = mouseovertext
		end
	end
end

function menu.nameControl(name, row, col)
	if menu.remapControl then
		if (row == menu.remapControl.row) and (col == menu.remapControl.col) then
			local _, secondfraction = math.modf(getElapsedTime())
			if secondfraction < 0.5 then
				menu.remapControl.shown = false
				return ""
			else
				menu.remapControl.shown = true
				return "_"
			end
		end
	end
	return name
end

function menu.displayOption(ftable, option, numCols)
	if numCols == nil then
		numCols = 5
	end

	local row, row2
	if (option.display == nil) or option.display() then
		if option.id == "line" then
			row = ftable:addRow(false, { bgColor = Helper.color.transparent })
			row[2]:setColSpan(numCols - 1):createText(" ", { fontsize = 1, height = Helper.borderSize, cellBGColor = Helper.color.transparent60 })
		elseif option.id == "header" then
			row = ftable:addRow(false, { bgColor = Helper.color.transparent })
			row[2]:setColSpan(numCols - 1):createText(option.name, config.subHeaderTextProperties)
		else
			local isselectable = (not option.selectable) or option.selectable()
			row = ftable:addRow(isselectable and option or {}, { bgColor = Helper.color.transparent })
			if isselectable and (option.id == menu.preselectOption) then
				ftable:setSelectedRow(row.index)
			end

			if option.value then
				row[2]:setColSpan(numCols - 4):createText(option.name, isselectable and config.standardTextProperties or config.disabledTextProperties)
				if option.wordwrap then
					row[2].properties.wordwrap = option.wordwrap
				end
				local nextCol = numCols - 2
				if option.valuetype == "button" then
					row[nextCol]:createButton({ active = isselectable }):setText(option.value)
					row[nextCol].handlers.onClick = option.callback
				elseif option.valuetype == "confirmation" then
					row[nextCol]:createButton({ active = isselectable, mouseOverText = isselectable and "" or option.inactive_text }):setText(option.value, { halign = "center" })
					row[nextCol].handlers.onClick = option.callback
				elseif option.valuetype == "dropdown" then
					local options, currentOption, textOverride, textalign = option.value()
					menu.curDropDownOption[option.id] = tostring(currentOption)
					row[nextCol]:createDropDown(options, { active = isselectable, startOption = currentOption, textOverride = textOverride or "" }):setTextProperties({ halign = textalign or "left" })
					row[nextCol].handlers.onDropDownConfirmed = function(_, id) return option.callback(option.id, id) end
				elseif option.valuetype == "sounddropdown" then
					local options, currentOption, textOverride, textalign = option.value()
					menu.curDropDownOption[option.id] = tostring(currentOption)
					row[nextCol]:setColSpan(numCols - 3):createDropDown(options, { active = isselectable, startOption = currentOption, textOverride = textOverride or "" }):setTextProperties({ halign = textalign or "left" })
					row[nextCol].handlers.onDropDownConfirmed = function(_, id) return option.callback(option.id, id) end
					row[numCols]:setColSpan(numCols - 4):createButton({  }):setIcon("menu_sound_on")
					row[numCols].handlers.onClick = function () return menu.buttonSoundTest(option.id) end
				elseif option.valuetype == "slidercell" then
					local scale = option.value()
					row[nextCol]:createSliderCell({ valueColor = isselectable and config.sliderCellValueColor or config.greySliderCellValueColor, min = scale.min, minSelect = scale.minSelect, max = scale.max, maxSelect = scale.maxSelect, start = scale.start, step = scale.step, suffix = scale.suffix, exceedMaxValue = scale.exceedMaxValue, hideMaxValue = scale.hideMaxValue, readOnly = scale.readOnly }):setText(text, { color = isselectable and Helper.color.white or Helper.color.grey })
					row[nextCol].handlers.onSliderCellChanged = function(_, value) return option.callback(value) end
				else
					row[nextCol]:createText(function () local text = option.value() return text end, isselectable and config.standardTextProperties or config.disabledTextProperties)
					if isselectable then
						row[nextCol].properties.color = function () local _, color = option.value() return color end
					end
				end
				if option.confirmline then
					if (option.confirmline.display == nil) or option.confirmline.display() then
						row2 = ftable:addRow(isselectable and option or {}, { bgColor = Helper.color.transparent })
						row2[nextCol]:setColSpan(numCols - 4):createButton({ active = option.confirmline.pos_selectable }):setText(option.confirmline.pos_name, { halign = "center" })
						row2[nextCol].handlers.onClick = option.confirmline.positive
						if option.confirmline.negative then
							row2[numCols - 1]:setColSpan(numCols - 3):createButton({ active = option.confirmline.neg_selectable }):setText(option.confirmline.neg_name, { halign = "center" })
							row2[numCols - 1].handlers.onClick = option.confirmline.negative
						end
					end
				end
			else
				row[2]:setColSpan(numCols - 1):createText(option.name, isselectable and config.standardTextProperties or config.disabledTextProperties)
				if option.wordwrap then
					row[2].properties.wordwrap = option.wordwrap
				end
			end

			if option.mouseOverText then
				local mouseovertext = option.mouseOverText
				if type(mouseovertext) == "function" then
					mouseovertext = mouseovertext()
				end
				row[2].properties.mouseOverText = mouseovertext
			end
		end
	end

	return row, row2
end

function menu.getControlsData()
	menu.controls = { ["actions"] = GetInputActionMap(), ["states"] = GetInputStateMap(), ["ranges"] = GetInputRangeMap(), ["functions"] = config.input.controlFunctions }
end

function menu.getInputDeviceIcon(device)
	if device == "controller" and C.IsRunningOnSteamDeck() then
		device = "steamdeck"
	end
	return string.format("\27[input_device_%s]", device)
end

function menu.getInputName(source, code, signum)
	local signumstr = ""
	if signum == 1 then
		signumstr = " (+)"
	elseif signum == -1 then
		signumstr = " (-)"
	end
	if source == 1 then
		-- keyboard
		local name = GetLocalizedRawKeyName(code)
		local icon = Helper.convertColorToText(Helper.color.blue) .. menu.getInputDeviceIcon("keyboard")
		return name, icon
	elseif source >= 2 and source <= 9 then
		if menu.mappedjoysticks[source - 1].xinput then
			-- xinput axis
			local name = ffi.string(C.GetLocalizedInputName(source, code)) .. ((code ~= 3 and code ~= 6) and signumstr or "")
			local icon = Helper.convertColorToText(Helper.color.orange) .. menu.getInputDeviceIcon("controller") .. ((source > 2) and menu.getInputDeviceIcon("number_" .. (source - 1)) or "")
			return name, icon
		else
			-- dircetinput axis
			local name = ReadText(1017, code) .. signumstr
			local icon = Helper.convertColorToText(Helper.color.brightyellow) .. menu.getInputDeviceIcon("joystick") .. ((source > 2) and menu.getInputDeviceIcon("number_" .. (source - 1)) or "")
			return name, icon
		end
	elseif source >= 10 and source <= 17 then
		if menu.mappedjoysticks[source - 9].xinput then
			-- xinput buttons
			local name = ffi.string(C.GetLocalizedInputName(source, code)) --string.format(ReadText(1001, 2673), ReadText(1009, code))
			local icon = Helper.convertColorToText(Helper.color.orange) .. menu.getInputDeviceIcon("controller") .. ((source > 10) and menu.getInputDeviceIcon("number_" .. (source - 9)) or "")
			return name, icon
		else
			-- directinput buttons
			local name = ffi.string(C.GetLocalizedInputName(source, code)) --ReadText(1022, code)
			local icon = Helper.convertColorToText(Helper.color.brightyellow) .. menu.getInputDeviceIcon("joystick") .. ((source > 10) and menu.getInputDeviceIcon("number_" .. (source - 9)) or "")
			return name, icon
		end
	elseif source == 18 then
		-- mouse axis
		local name = ReadText(1018, code) .. signumstr
		local icon = Helper.convertColorToText(Helper.color.green) .. menu.getInputDeviceIcon("mouse")
		return name, icon
	elseif source == 19 then
		-- mouse buttons
		local name = ffi.string(C.GetLocalizedRawMouseButtonName(code))
		local icon = Helper.convertColorToText(Helper.color.green) .. menu.getInputDeviceIcon("mouse")
		return name, icon
	elseif source == 20 then
		-- oculus touch Axes
		return ReadText(1008, code)
	elseif source == 21 then
		-- oculus remote axes - unsupported
		return ""
	elseif source == 22 then
		-- vive right Axes
		return ReadText(1008, code)
	elseif source == 23 then
		-- vive left Axes
		return ReadText(1008, code)
	elseif source == 24 then
		-- oculus touch buttons
		return ReadText(1009, code)
	elseif source == 25 then
		-- oculus remote buttons - unsupported
		return ""
	elseif source == 26 then
		-- vive right buttons
		return ReadText(1009, code)
	elseif source == 27 then
		-- vive left buttons
		return ReadText(1009, code)
	else
		DebugError("unknown input source '".. source .. "' - this should never happen [Florian]")
		return ""
	end
end

function menu.getLanguageData()
	if not next(menu.languagedata) then
		menu.languagedata = {}
		local n = C.GetNumLanguages()
		local buf = ffi.new("LanguageInfo[?]", n)
		n = C.GetLanguages(buf, n)
		for i = 0, n - 1 do
			local item = {}

			item.id = buf[i].id
			item.name = ffi.string(buf[i].name)
			item.warning = ffi.string(buf[i].warning)
			item.font = ffi.string(buf[i].font)
			item.voice = buf[i].voice

			table.insert(menu.languagedata, item)
		end

		menu.languagedata.curID = C.GetCurrentLanguage()
	end
	menu.languagedata.requestedID = C.GetRequestedLanguage()
	menu.languagedata.haswarning = menu.languagedata.curID ~= menu.languagedata.requestedID
end

function menu.requestLanguageID(id)
	C.RequestLanguageChange(id)
	menu.getLanguageData()
end

function menu.infoHandler()
	if menu.selectedOption and (type(menu.selectedOption) == "table") then
		return menu.selectedOption.info or ""
	end
	return ""
end

function menu.refresh()
	menu.preselectTopRow = GetTopRow(menu.optionTable)
	local rowdata = Helper.getCurrentRowData(menu, menu.optionTable)
	menu.preselectOption = (type(rowdata) == "table") and rowdata.id or nil
	if (menu.currentOption == "save") or (menu.currentOption == "load") or (menu.currentOption == "saveoffline") then
		if type(rowdata) == "table" then
			if rowdata.titlerow then
				menu.preselectOption = rowdata.titlerow
			elseif rowdata.submenu then
				menu.preselectOption = rowdata.submenu
			elseif rowdata.empty then
				menu.preselectOption = "save_" .. rowdata.empty
			else
				menu.preselectOption = rowdata.filename
			end
		end
	end
	if menu.currentOption then
		menu.submenuHandler(menu.currentOption)
	end
end

function menu.sortActiveEntries(a, b)
	if a.active == b.active then
		return a.id < b.id
	end
	return a.active and (not b.active)
end

function menu.submenuHandler(optionParameter)
	menu.userQuestion = nil

	if optionParameter == nil then
		DebugError("Invalid call to menu.submenuHandler(): ")
		DebugError(TraceBack())
		return
	end

	AddUITriggeredEvent(menu.name, "menu_" .. optionParameter)

	if optionParameter ~= "main" then
		C.HidePromo()
	end

	-- kuertee start: callback
	if callbacks ["submenuHandler_preDisplayOptions"] then
		for _, callback in ipairs (callbacks ["submenuHandler_preDisplayOptions"]) do
			callback(optionParameter)
		end
	end
	-- kuertee end: callback

	if optionParameter == "main" then
		if menu.isStartmenu then
			C.ShowPromo()
		end
		menu.displayOptions(optionParameter)
	elseif optionParameter == "new" then
		menu.displayNewGame(false)
	elseif optionParameter == "load" then
		menu.displaySavegameOptions(optionParameter)
	elseif optionParameter == "save" then
		menu.displaySavegameOptions(optionParameter)
	elseif optionParameter == "saveoffline" then
		menu.displaySavegameOptions(optionParameter)
	elseif optionParameter == "multiplayer_server" then
		menu.displayNewGame(true)
	elseif optionParameter == "lobby" then
		menu.displayLobby()
	elseif optionParameter == "online" then
		__CORE_GAMEOPTIONS_PRIVACYPOLICY = false
		menu.displayOnlineLogin()
	elseif optionParameter == "extensions" then
		menu.displayExtensions()
	elseif optionParameter == "bonus" then
		menu.displayBonusContent()
	elseif optionParameter == "defaults" then
		menu.displayUserQuestion(ReadText(1001, 2653), function () return menu.callbackDefaults() end)
	elseif optionParameter == "gfx_defaults" then
		menu.displayUserQuestion(ReadText(1001, 2653), function () return menu.callbackGfxDefaults() end)
	elseif optionParameter == "sfx_defaults" then
		menu.displayUserQuestion(ReadText(1001, 2653), function () return menu.callbackSfxDefaults() end)
	elseif optionParameter == "game_defaults" then
		menu.displayUserQuestion(ReadText(1001, 2653), function () return menu.callbackGameDefaults() end)
	elseif optionParameter == "accessibility_defaults" then
		menu.displayUserQuestion(ReadText(1001, 2653), function () return menu.callbackAccessibilityDefaults() end)
	elseif	(optionParameter == "vrtouch_space") or
			(optionParameter == "vrtouch_firstperson") or
			(optionParameter == "vrtouch_menus") or
			(optionParameter == "vrvive_space") or
			(optionParameter == "vrvive_firstperson") or
			(optionParameter == "vrvive_menus") or
			(optionParameter == "keyboard_space") or
			(optionParameter == "keyboard_firstperson") or
			(optionParameter == "keyboard_menus")
	then
		menu.displayControls(optionParameter)
	elseif optionParameter == "joysticks" then
		menu.displayJoysticks()
	elseif optionParameter == "profile_load" then
		menu.displayInputProfiles(optionParameter)
	elseif optionParameter == "profile_save" then
		menu.displayInputProfiles(optionParameter)
	elseif optionParameter == "language" then
		menu.displayLanguageOptions()
	elseif optionParameter == "onlineseason" then
		menu.displayOnlineSeason(optionParameter)
	elseif optionParameter == "credits" then
		menu.displayCredits(optionParameter)
	elseif optionParameter == "idle" then
		menu.displayCredits(optionParameter)
	elseif optionParameter == "exit" then
		menu.displayUserQuestion(ReadText(1001, 2645), function () return menu.callbackExit(false) end, nil, nil, nil, nil, nil, Helper.isOnlineGame() and ReadText(1001, 11710) or nil)
	elseif optionParameter == "quit" then
		menu.displayUserQuestion(ReadText(1001, 4876), function () return menu.callbackExit(true) end)
	elseif optionParameter == "privacy" then
		menu.displayOptionsInfo(optionParameter)
	elseif config.optionDefinitions[optionParameter] then
		menu.displayOptions(optionParameter)
	end
end

function menu.openSubmenu(optionParameter, selectedOption)
	table.insert(menu.history, 1, { optionParameter = menu.currentOption, topRow = GetTopRow(menu.optionTable), selectedOption = selectedOption })
	menu.submenuHandler(optionParameter)
end

function menu.removeInput()
	if menu.remapControl then
		if menu.remapControl.controltype == "functions" then
			for _, functionaction in ipairs(menu.controls[menu.remapControl.controltype][menu.remapControl.controlcode].actions) do
				local inputs = menu.controls.actions[functionaction]
				if type(inputs) == "table" then
					for i, input in ipairs(inputs) do
						if input[1] == menu.remapControl.oldinputtype and input[2] == menu.remapControl.oldinputcode then
							table.remove(inputs, i)
						end
					end
				end
			end
			for _, functionstate in ipairs(menu.controls[menu.remapControl.controltype][menu.remapControl.controlcode].states) do
				local inputs = menu.controls.states[functionstate]
				if type(inputs) == "table" then
					for i, input in ipairs(inputs) do
						if input[1] == menu.remapControl.oldinputtype and input[2] == menu.remapControl.oldinputcode then
							table.remove(inputs, i)
						end
					end
				end
			end
			for _, functionrange in ipairs(menu.controls[menu.remapControl.controltype][menu.remapControl.controlcode].ranges) do
				local inputs = menu.controls.ranges[functionrange]
				if type(inputs) == "table" then
					for i, input in ipairs(inputs) do
						if input[1] == menu.remapControl.oldinputtype and input[2] == menu.remapControl.oldinputcode then
							table.remove(inputs, i)
						end
					end
				end
			end
		else
			if type(menu.controls[menu.remapControl.controltype][menu.remapControl.controlcode]) == "table" then
				for i, input in ipairs(menu.controls[menu.remapControl.controltype][menu.remapControl.controlcode]) do
					if input[1] == menu.remapControl.oldinputtype and input[2] == menu.remapControl.oldinputcode then
						table.remove(menu.controls[menu.remapControl.controltype][menu.remapControl.controlcode], i)
					end
				end
			end
		end
		SaveInputSettings(menu.controls.actions, menu.controls.states, menu.controls.ranges)
	end
end

function menu.registerDirectInput()
	C.DisableAutoMouseEmulation()
	for i, entry in ipairs(config.input.directInputHookDefinitions) do
		RegisterEvent(entry[1], config.input.directInputHooks[i])
	end

	ListenForInput(true)
end

function menu.unregisterDirectInput()
	ListenForInput(false)

	for i, entry in ipairs(config.input.directInputHookDefinitions) do
		UnregisterEvent(entry[1], config.input.directInputHooks[i])
	end
	C.EnableAutoMouseEmulation()
end

function menu.remapInput(newinputtype, newinputcode, newinputsgn)
	menu.unregisterDirectInput()

	-- Delete -> Remove mapping
	if (newinputtype == 1 and newinputcode == 211) and menu.remapControl.oldinputcode ~= -1 then
		menu.removeInput()

		menu.preselectTopRow = GetTopRow(menu.optionTable)
		menu.preselectOption = menu.remapControl.row
		menu.preselectCol = menu.remapControl.col
		menu.remapControl = nil
		menu.submenuHandler(menu.currentOption)
		AddUITriggeredEvent(menu.name, "remap_removed")
		return
	end

	-- Forbidden input -> Do nothing
	if (newinputtype == 1 and (config.input.forbiddenKeys[newinputcode] or menu.remapControl.nokeyboard)) then
		menu.preselectTopRow = GetTopRow(menu.optionTable)
		menu.preselectOption = menu.remapControl.row
		menu.preselectCol = menu.remapControl.col
		menu.remapControl = nil
		menu.submenuHandler(menu.currentOption)
		AddUITriggeredEvent(menu.name, "remap_forbidden")
		return
	end

	-- Same mapping -> Check for broken function mappings, otherwise do nothing
	if (newinputtype == menu.remapControl.oldinputtype and newinputcode == menu.remapControl.oldinputcode) then
		if menu.remapControl.controltype == "functions" then
			menu.checkFunctionMapping(newinputtype, newinputcode, newinputsgn)
		end

		menu.preselectTopRow = GetTopRow(menu.optionTable)
		menu.preselectOption = menu.remapControl.row
		menu.preselectCol = menu.remapControl.col
		menu.remapControl = nil
		menu.submenuHandler(menu.currentOption)
		AddUITriggeredEvent(menu.name, "remap_samemapping")
		return
	end

	-- We want to map a range but didn't get an axis - OR - got forbidden mouseinput -> Keep listening
	if ((menu.remapControl.controltype == "ranges") and not ((newinputtype >= 2 and newinputtype <= 9) or ((newinputtype == 18) and menu.remapControl.allowmouseaxis) or (newinputtype >= 20 and newinputtype <= 23))) or (newinputtype == 19 and config.input.forbiddenMouseButtons[newinputcode]) then
		menu.registerDirectInput()
		return
	end

	if not menu.checkInputSource(newinputtype) then
		menu.registerDirectInput()
		return
	end
	AddUITriggeredEvent(menu.name, "remap")

	if menu.remapControl.controltype == "ranges" then
		newinputsgn = 0
	end
	local conflicts = menu.checkForConflicts(newinputtype, newinputcode, newinputsgn)
	if #conflicts == 0 then
		menu.remapInputInternal(newinputtype, newinputcode, newinputsgn)
	else
		menu.contextMenuMode = "remap"
		menu.contextMenuData = { width = Helper.scaleX(400), height = Helper.scaleY(200), y = Helper.scaleY(300), conflicts = conflicts, newinput = { newinputtype, newinputcode, newinputsgn } }

		menu.createContextMenu()
	end
end

function menu.checkFunctionMapping(newinputtype, newinputcode, newinputsgn)
	local newinput = { newinputtype, newinputcode, newinputsgn }

	local function insertInput(controltype, controlcode)
		if not menu.controls[controltype][controlcode] then
			menu.controls[controltype][controlcode] = { newinput }
		else
			table.insert(menu.controls[controltype][controlcode], newinput)
		end
	end

	local function fixFunctionInput(controltype, controlcode)
		local inputs = menu.controls[controltype][controlcode]
		if inputs then
			local found = false
			for i, input in ipairs(inputs) do
				found = found or menu.checkInput(inputs, i, input, newinput, true)
			end
			if not found then
				insertInput(controltype, controlcode)
			end
		else
			insertInput(controltype, controlcode)
		end
	end

	if menu.remapControl.controltype == "functions" then
		for _, functionaction in ipairs(menu.controls[menu.remapControl.controltype][menu.remapControl.controlcode].actions) do
			fixFunctionInput("actions", functionaction)
		end
		for _, functionstate in ipairs(menu.controls[menu.remapControl.controltype][menu.remapControl.controlcode].states) do
			fixFunctionInput("states", functionstate)
		end
		for _, functionrange in ipairs(menu.controls[menu.remapControl.controltype][menu.remapControl.controlcode].ranges) do
			fixFunctionInput("ranges", functionrange)
		end
	end

	SaveInputSettings(menu.controls.actions, menu.controls.states, menu.controls.ranges)
end

function menu.hasContextSimple(context)
	if type(menu.remapControl.controlcontext) == "table" then
		for _, remapcontext in ipairs(menu.remapControl.controlcontext) do
			if context == remapcontext then
				return true
			end
		end
	else
		return context == menu.remapControl.controlcontext
	end
end

function menu.hasContext(contexts)
	if type(contexts) == "table" then
		for _, context in ipairs(contexts) do
			if menu.hasContextSimple(context) then
				return true
			end
		end
	else
		return menu.hasContextSimple(contexts)
	end
end

function menu.checkInput(inputtable, entry, input, newinput, checkonly)
	if input[1] == newinput[1] and input[2] == newinput[2] and ((input[3] == 0) or (newinput[3] == 0) or (input[3] == newinput[3])) then
		if checkonly then
			return true
		end
		table.remove(inputtable, entry)
	elseif input[1] == menu.remapControl.oldinputtype and input[2] == menu.remapControl.oldinputcode and (input[3] == 0 or input[3] == menu.remapControl.oldinputsgn) then
		if not checkonly then
			input[1] = 0
			input[2] = 0
		end
	end
end

function menu.checkForConflicts(newinputtype, newinputcode, newinputsgn)
	local newinput = { newinputtype, newinputcode, newinputsgn }

	local returnvalue = {}

	for _, controlgroup in ipairs(menu.controlsorder) do
		for _, control in ipairs(controlgroup) do
			if control[1] == "functions" then
				if menu.hasContext(menu.controls[control[1]][control[2]].contexts or 1) then
					for _, functionaction in ipairs(menu.controls[control[1]][control[2]].actions) do
						local inputs = menu.controls.actions[functionaction]
						if type(inputs) == "table" then
							for i, input in ipairs(inputs) do
								if menu.checkInput(inputs, i, input, newinput, true) then
									table.insert(returnvalue, { control = control, mapable = controlgroup.mapable or newinputtype ~= 1 })
								end
							end
						end
					end
					for _, functionstate in ipairs(menu.controls[control[1]][control[2]].states) do
						local inputs = menu.controls.states[functionstate]
						if type(inputs) == "table" then
							for i, input in ipairs(inputs) do
								if menu.checkInput(inputs, i, input, newinput, true) then
									table.insert(returnvalue, { control = control, mapable = controlgroup.mapable or newinputtype ~= 1 })
								end
							end
						end
					end
					for _, functionrange in ipairs(menu.controls[control[1]][control[2]].ranges) do
						local inputs = menu.controls.ranges[functionrange]
						if type(inputs) == "table" then
							for i, input in ipairs(inputs) do
								if menu.checkInput(inputs, i, input, newinput, true) then
									table.insert(returnvalue, { control = control, mapable = controlgroup.mapable or newinputtype ~= 1 })
								end
							end
						end
					end
				end
			else
				if menu.hasContext(control[3] or 1) then
					if type(menu.controls[control[1]][control[2]]) == "table" then
						for i, input in ipairs(menu.controls[control[1]][control[2]]) do
							if menu.checkInput(menu.controls[control[1]][control[2]], i, input, newinput, true) then
								table.insert(returnvalue, { control = control, mapable = controlgroup.mapable or newinputtype ~= 1 })
							end
						end
					end
				end
			end
		end
	end

	return returnvalue
end

function menu.remapInputInternal(newinputtype, newinputcode, newinputsgn)
	-- check for resulting conflicts and change control map appropriatly
	local newinput = { newinputtype, newinputcode, newinputsgn }
	for _, controlgroup in ipairs(menu.controlsorder) do
		if controlgroup.mapable or (newinputtype ~= 1) then
			for _, control in ipairs(controlgroup) do
				if control[1] == "functions" then
					if menu.hasContext(menu.controls[control[1]][control[2]].contexts or 1) then
						for _, functionaction in ipairs(menu.controls[control[1]][control[2]].actions) do
							local inputs = menu.controls.actions[functionaction]
							if type(inputs) == "table" then
								for i, input in ipairs(inputs) do
									menu.checkInput(inputs, i, input, newinput)
								end
							end
						end
						for _, functionstate in ipairs(menu.controls[control[1]][control[2]].states) do
							local inputs = menu.controls.states[functionstate]
							if type(inputs) == "table" then
								for i, input in ipairs(inputs) do
									menu.checkInput(inputs, i, input, newinput)
								end
							end
						end
						for _, functionrange in ipairs(menu.controls[control[1]][control[2]].ranges) do
							local inputs = menu.controls.ranges[functionrange]
							if type(inputs) == "table" then
								for i, input in ipairs(inputs) do
									menu.checkInput(inputs, i, input, newinput)
								end
							end
						end
					end
				else
					if menu.hasContext(control[3] or 1) then
						if type(menu.controls[control[1]][control[2]]) == "table" then
							for i, input in ipairs(menu.controls[control[1]][control[2]]) do
								menu.checkInput(menu.controls[control[1]][control[2]], i, input, newinput)
							end
						end
					end
				end
			end
		end
	end

	local function insertInput(controltype, controlcode)
		if not menu.controls[controltype][controlcode] then
			menu.controls[controltype][controlcode] = { newinput }
		else
			-- copy input toggle flag from other inputs for now until we make this configureable by the user
			for _, input in ipairs(menu.controls[controltype][controlcode]) do
				if input[4] then
					newinput[4] = true
					break
				end
			end

			table.insert(menu.controls[controltype][controlcode], newinput)
		end
	end

	local function resolveInput(input)
		if input[1] == 0 and input[2] == 0 then
			input[1] = newinputtype
			input[2] = newinputcode
			input[3] = newinputsgn
			return true
		end
		return false
	end

	local function resolveOrFixFunctionInput(controltype, controlcode, functioncontrol)
		local inputs = menu.controls[controltype][controlcode]
		if inputs then
			local found = false
			for i, input in ipairs(inputs) do
				found = found or resolveInput(input)
			end
			if not found then
				if (functioncontrol[1] == menu.remapControl.controltype) and (functioncontrol[2] == menu.remapControl.controlcode) then
					insertInput(controltype, controlcode)
				end
			end
		else
			if (functioncontrol[1] == menu.remapControl.controltype) and (functioncontrol[2] == menu.remapControl.controlcode) then
				insertInput(controltype, controlcode)
			end
		end
	end

	if menu.remapControl.oldinputcode == -1 then
		if menu.remapControl.controltype == "functions" then
			for _, functionaction in ipairs(menu.controls[menu.remapControl.controltype][menu.remapControl.controlcode].actions) do
				insertInput("actions", functionaction)
			end
			for _, functionstate in ipairs(menu.controls[menu.remapControl.controltype][menu.remapControl.controlcode].states) do
				insertInput("states", functionstate)
			end
			for _, functionrange in ipairs(menu.controls[menu.remapControl.controltype][menu.remapControl.controlcode].ranges) do
				insertInput("ranges", functionrange)
			end
		else
			insertInput(menu.remapControl.controltype, menu.remapControl.controlcode)
		end
	else
		for _, controlgroup in ipairs(menu.controlsorder) do
			for _, control in ipairs(controlgroup) do
				if control[1] == "functions" then
					for _, functionaction in ipairs(menu.controls[control[1]][control[2]].actions) do
						resolveOrFixFunctionInput("actions", functionaction, control)
					end
					for _, functionstate in ipairs(menu.controls[control[1]][control[2]].states) do
						resolveOrFixFunctionInput("states", functionstate, control)
					end
					for _, functionrange in ipairs(menu.controls[control[1]][control[2]].ranges) do
						resolveOrFixFunctionInput("ranges", functionrange, control)
					end
				else
					if type(menu.controls[control[1]][control[2]]) == "table" then
						for i, input in ipairs(menu.controls[control[1]][control[2]]) do
							resolveInput(input)
						end
					end
				end
			end
		end
	end

	-- save new controls
	SaveInputSettings(menu.controls.actions, menu.controls.states, menu.controls.ranges)

	-- reload controls menu
	menu.preselectTopRow = GetTopRow(menu.optionTable)
	menu.preselectOption = menu.remapControl.row
	menu.preselectCol = menu.remapControl.col
	menu.remapControl = nil
	menu.submenuHandler(menu.currentOption)
end

function menu.displayTobiiHeadTracking()
	if not C.IsTobiiAvailable() then
		return false
	end
	local mode = ffi.string(C.GetTobiiMode())
	return (mode == "head_tracking") or (mode == "combined")
end

function menu.displayTobiiGazeContinous()
	if not C.IsTobiiAvailable() then
		return false
	end
	local mode = ffi.string(C.GetTobiiMode())
	return (mode == "gaze_continous") or (mode == "combined")
end

function menu.isVentureExtensionRestartRequired()
	if OnlineGetVentureConfig("allow_update") and (not __CORE_GAMEOPTIONS_VENTURECONFIG.allow_update) then
		return true
	end
	if OnlineGetVentureConfig("allow_update_once") and (not __CORE_GAMEOPTIONS_VENTURECONFIG.allow_update_once) then
		return true
	end
	return false
end


--- options ---

function menu.nameConnection()
	local _, secondfraction = math.modf(getElapsedTime())
	local dots = "."
	if secondfraction > 0.6666 then
		dots = "..."
	elseif secondfraction > 0.3333 then
		dots = ".."
	end
	return ReadText(1001, 7251) .. dots
end

function menu.nameContinue()
	if menu.isStartmenu then
		if menu.savegames then
			if next(menu.savegames) then
				local entry
				for _, save in ipairs(menu.savegames) do
					if not save.isonline then
						entry = save
						break
					end
				end
				if entry then
					if entry.invalidpatches or entry.invalidversion or entry.invalidgameid then
						return ReadText(1001, 2614) .. "\n   (" .. ReadText(1001, 2694) .. ")"
					else
						local isquicksave = (entry.filename == "quicksave")
						local isautosave = (string.find(entry.filename, "autosave_", 1, true) == 1)
						local money = ConvertMoneyString(entry.money, false, true, 0, true, false) .. " " .. ReadText(1001, 101)
						local timestamp = ConvertTimeString(entry.playtime, "%d" .. ReadText(1001, 104) .. " %H" .. ReadText(1001, 102) .. " %M" .. ReadText(1001, 103))

						local savename = entry.location
						if (not isquicksave) and (not isautosave) then
							savename = menu.getExplicitSavegameName(entry) or savename
						end

						local name = ReadText(1001, 2614) .. ReadText(1001, 120) .. " " .. savename
						if isquicksave then
							name = name .. " (" .. ReadText(1001, 400) .. ")"
						elseif isautosave then
							name = name .. " (" .. ReadText(1001, 406) .. ")"
						end
						return name .. " - " .. entry.time .. (entry.modified and (Helper.convertColorToText(Helper.color.warningorange) .. " (" .. ReadText(1001, 8901) .. ")\27X") or "") .. "\n(" .. entry.playername .. " - " .. money .. " - " .. timestamp .. " - " .. ReadText(1001, 2655) .. ReadText(1001, 120) .. " " .. entry.version .. ")"
					end
				else
					return ReadText(1001, 2614)
				end
			else
				return ReadText(1001, 2614)
			end
		elseif menu.autoReloadSave then
			return menu.autoReloadSave
		else
			return ReadText(1001, 7203)
		end
	else
		-- Continue Game [Esc] / [B]
		local text = ReadText(1001, 2614)
		local buttontext = ffi.string(C.ConvertInputString("$INPUT_ACTION_WIDGET_BACK$", ""))
		if buttontext ~= "" then
			text = text .. " " .. buttontext
		end
		return text
	end
end

function menu.nameExtension()
	local extensions = GetExtensionList()
	local iconcolor = Helper.color.brightyellow
	local haserror = false
	if menu.extensionSettingsChanged == nil then
		menu.extensionSettingsChanged = HaveExtensionSettingsChanged()
	end
	local haswarning = menu.extensionSettingsChanged or (GetExtensionUpdateWarningText("", false) ~= nil)

	for _, extension in ipairs(extensions) do
		if extension.error and extension.enabled then
			haserror = true
			iconcolor = Helper.color.red
			break
		end
		if extension.warning then
			haswarning = true
		end
	end
	local icon = ""
	if haserror or haswarning then
		icon = Helper.convertColorToText(iconcolor) .. "\027[workshop_error]\027X"
	end

	return icon .. ReadText(1001, 2697)
end

function menu.nameExtensionSettings()
	return ReadText(1001, 2697) .. " - " .. menu.selectedExtension.name
end

function menu.nameExtensionSettingEnabled()
	return (menu.selectedExtension.isworkshop and menu.selectedExtension.sync) and ReadText(1001, 4832) or ReadText(1001, 4825)
end

function menu.nameInput()
	local icon = ""
	local iconcolor = Helper.color.brightyellow
	if CheckInputProfileRegression() then
		icon = Helper.convertColorToText(iconcolor) .. "\027[workshop_error]\027X"
	end
	return icon .. ReadText(1001, 2656)
end

function menu.nameGfx()
	local icon = ""
	local iconcolor = Helper.color.red
	if ((not C.IsCurrentGPUDiscrete()) and (not C.IsRunningOnSteamDeck())) or C.AreGfxSettingsTooHigh() then
		icon = Helper.convertColorToText(iconcolor) .. "\027[workshop_error]\027X"
	end
	return icon .. ReadText(1001, 2606)
end

function menu.nameLanguage()
	local icon = ""
	local iconcolor = Helper.color.brightyellow

	local languageWarning = false
	if menu.isStartmenu and C.IsLanguageSettingEnabled() then
		menu.getLanguageData()

		for _, language in ipairs(menu.languagedata) do
			if language.id == menu.languagedata.requestedID then
				if menu.languagedata.haswarning then
					languageWarning = true
				end
				break
			end
		end
	end

	if languageWarning then
		icon = Helper.convertColorToText(iconcolor) .. "\027[workshop_error]\027X"
	end

	return icon .. ReadText(1001, 7236)
end

function menu.nameLogin()
	local _, secondfraction = math.modf(getElapsedTime())
	local dots = "."
	if secondfraction > 0.6666 then
		dots = "..."
	elseif secondfraction > 0.3333 then
		dots = ".."
	end
	return ReadText(1001, 7254) .. dots
end

function menu.nameOnlineSeason()
	if not menu.savegames then
		return ReadText(1001, 7203)
	elseif menu.onlinesave then
		if (not C.AreVenturesEnabled()) or (not OnlineHasSession()) then
			return ReadText(1001, 11753)
		end
		local state = OnlineGetVersionIncompatibilityState()
		local entry = menu.getLatestOnlineSave()
		if state ~= 0 then
			local basename = entry and (menu.isStartmenu and ReadText(1001, 11717) or ReadText(1001, 11572)) or ReadText(1001, 11300)
			if state == 1 then
				return basename .. "\n   " .. Helper.convertColorToText(Helper.color.red) .. ReadText(1001, 11351)
			elseif state == 2 then
				return basename .. "\n   " .. Helper.convertColorToText(Helper.color.red) .. ReadText(1001, 11353)
			end
		else
			local basename = menu.isStartmenu and ReadText(1001, 11717) or ReadText(1001, 11572)

			if entry.invalidpatches or entry.invalidversion or entry.invalidgameid then
				return basename .. "\n   (" .. ReadText(1001, 2694) .. ")"
			else
				local money = ConvertMoneyString(entry.money, false, true, 0, true, false) .. " " .. ReadText(1001, 101)
				local timestamp = ConvertTimeString(entry.playtime, "%d" .. ReadText(1001, 104) .. " %H" .. ReadText(1001, 102) .. " %M" .. ReadText(1001, 103))

				local savename = menu.getExplicitSavegameName(entry) or entry.location
				local name = basename --.. ReadText(1001, 120) .. " " .. savename
				return name .. " - " .. entry.time .. (entry.modified and (Helper.convertColorToText(Helper.color.warningorange) .. " (" .. ReadText(1001, 8901) .. ")\27X") or "") .. "\n(" .. entry.playername .. " - " .. money .. " - " .. timestamp .. " - " .. ReadText(1001, 2655) .. ReadText(1001, 120) .. " " .. entry.version .. ")"
			end
		end
	else
		return ReadText(1001, 11300)
	end
end

function menu.errorSavegame(savegame)
	local error = ""
	if savegame.error then
		error = ReadText(1001, 4888)
	elseif savegame.invalidgameid then
		error = ReadText(1001, 4894)		-- Savegame is incompatible with game.
	elseif savegame.invalidversion then
		error = ReadText(1001, 4885) .. ReadText(1001, 120) .. " " .. savegame.version		-- Unknown game version required:
	elseif savegame.invalidpatches then
		error = ReadText(1001, 2685)			-- Missing, old or disabled extensions
	elseif savegame.isonline then
		error = ReadText(1001, 11716)
	end

	return error
end

function menu.savegameInfoVersion()
	local result = ""
	if (menu.selectedOption ~= nil) and (next(menu.selectedOption) ~= nil) and menu.selectedOption.playername then
		result = menu.selectedOption.version
		if menu.selectedOption.modified then
			result = result .. Helper.convertColorToText(Helper.color.warningorange) .. " (" .. ReadText(1001, 8901) .. ")\27X"
		elseif IsCheatVersion() and menu.selectedOption.isonline and not menu.selectedOption.isonlinesavefilename then
			result = result .. Helper.convertColorToText(Helper.color.brightyellow) .. " (" .. ReadText(1001, 11570) .. ")\27X"
		end
	end
	return result
end

function menu.errorSavegameInfo()
	local error = "\n"
	if (menu.selectedOption ~= nil) and (next(menu.selectedOption) ~= nil) then
		if menu.currentOption == "load" then
			if menu.selectedOption.error then
				error = error .. ReadText(1001, 4888)
			elseif menu.selectedOption.invalidgameid then
				error = error .. ReadText(1001, 4894)		-- Savegame is incompatible with game.
			elseif menu.selectedOption.invalidversion then
				error = error .. ReadText(1001, 4885) .. ReadText(1001, 120) .. " " .. menu.selectedOption.version		-- Unknown game version required:
			elseif menu.selectedOption.invalidpatches then
				error = ReadText(1001, 2685) .. ReadText(1001, 120)			-- Missing, old or disabled extensions:
				for i, patch in ipairs(menu.selectedOption.invalidpatches) do
					if i > 4 then
						error = error .. "\n- ..."
						break
					end
					error = error .. "\n- " .. patch.name .. " (" .. patch.id .. " - " .. patch.requiredversion .. ")"
					if patch.state == 2 then
						error = error .. " " .. ReadText(1001, 2686)
					elseif patch.state == 3 then
						error = error .. " " .. ReadText(1001, 2687)
					elseif patch.state == 4 then
						error = error .. " " .. string.format(ReadText(1001, 2688), patch.installedversion)
					end
				end
			elseif menu.selectedOption.isonline and C.IsClientModified() then
				error = error .. "\n" .. Helper.convertColorToText(Helper.color.warningorange) .. ReadText(1001, 11734) .. "\27X"
			elseif menu.selectedOption.isonline and (not OnlineHasSession()) then
				error = error .. "\n" .. Helper.convertColorToText(Helper.color.warningorange) .. ReadText(1001, 11735) .. "\27X"
			elseif menu.selectedOption.isonline and (C.GetVentureDLCStatus() ~= 0) then
				error = error .. "\n" .. Helper.convertColorToText(Helper.color.warningorange) .. ReadText(1001, 11751) .. "\27X"
			end
		else
			if not menu.selectedOption.empty then
				error = error .. string.format(ReadText(1001, 8959), menu.selectedOption.displayedname)
			end
			if Helper.isOnlineGame() and (not menu.selectedOption.isonline) then
				error = error .. "\n" .. ReadText(1001, 11703)
			end
		end
	end
	return error
end

function menu.nameSettings()
	local icon = ""
	local iconcolor = Helper.color.brightyellow

	if ((not C.IsCurrentGPUDiscrete()) and (not C.IsRunningOnSteamDeck())) or C.AreGfxSettingsTooHigh() then
		iconcolor = Helper.color.red
		icon = Helper.convertColorToText(iconcolor) .. "\027[workshop_error]\027X"
	elseif CheckInputProfileRegression() then
		icon = Helper.convertColorToText(iconcolor) .. "\027[workshop_error]\027X"
	elseif menu.isStartmenu and C.IsLanguageSettingEnabled() then
		menu.getLanguageData()
		if menu.languagedata.haswarning then
			icon = Helper.convertColorToText(iconcolor) .. "\027[workshop_error]\027X"
		end
	end

	return icon .. ReadText(1001, 2679)
end

function menu.nameOnline()
	local icon = ""
	local iconcolor = Helper.color.warningorange

	local state = OnlineGetVersionIncompatibilityState()
	local dlcstate = config.ventureDLCStates[C.GetVentureDLCStatus()] or "unknownerror"
	if state ~= 0 then
		iconcolor = Helper.color.red
		icon = Helper.convertColorToText(iconcolor) .. "\027[workshop_error]\027X"
	elseif menu.isVentureExtensionRestartRequired() then
		icon = Helper.convertColorToText(iconcolor) .. "\027[workshop_error]\027X"
	elseif (dlcstate == "notpossible") or (dlcstate == "updatenotpossible") or (dlcstate == "unknownerror") then
		iconcolor = Helper.color.red
		icon = Helper.convertColorToText(iconcolor) .. "\027[workshop_error]\027X"
	elseif dlcstate == "updatedisabled" then
		icon = Helper.convertColorToText(iconcolor) .. "\027[workshop_error]\027X"
	end

	return icon .. ReadText(1001, 7252)
end

function menu.nameUserQuestion()
	if menu.userQuestion then
		if menu.userQuestion.timer and menu.userQuestion.gfxDone then
			return menu.userQuestion.question .. " (" .. math.floor(menu.userQuestion.timer - getElapsedTime()) .. ReadText(1001, 100) .. ")"
		end
		return menu.userQuestion.question
	end
	return ""
end

function menu.iconNewGame()
	if menu.selectedOption then
		return (menu.selectedOption.image == "") and "gamestart_default" or menu.selectedOption.image
	end
	return "gamestart_default"
end

function menu.descriptionBonusContent()
	if menu.selectedOption and (type(menu.selectedOption) == "table") then
		local info = menu.selectedOption.description
		if menu.selectedOption.installed then
			if menu.selectedOption.path ~= "" then
				info = info .. "\n \n" .. ReadText(1001, 4801) .. ReadText(1001, 120) .. "\n" .. menu.selectedOption.path
			end
		elseif menu.selectedOption.owned and menu.selectedOption.optional and not menu.selectedOption.changed then
			info = info .. "\n \n" .. ReadText(1001, 4807)
		end
		return info
	end
	return ""
end

function menu.descriptionExtension()
	if menu.selectedOption and (type(menu.selectedOption) == "table") then
		local info = ""
		if menu.selectedOption.warning then
			info = info .. menu.selectedOption.warningtext .. "\n \n"
		end
		if menu.selectedOption.error then
			info = info .. "\027R" .. menu.selectedOption.errortext .. "\027X\n \n"
		end
		info = info .. ReadText(1001, 2404) .. ReadText(1001, 120) .. " " .. AdjustMultilineString(menu.selectedOption.desc)
		info = info .. "\n" .. ReadText(1001, 2690) .. ReadText(1001, 120) .. " " .. menu.selectedOption.author
		info = info .. "\n" .. ReadText(1001, 2691) .. ReadText(1001, 120) .. " " .. menu.selectedOption.date
		if menu.selectedOption.isworkshop then
			info = info .. "\n" .. ReadText(1001, 4824) .. ReadText(1001, 120) .. " " .. (menu.selectedOption.sync and ReadText(1001, 2617) or ReadText(1001, 2618))
		end
		info = info .. "\n" .. ReadText(1001, 2943) .. ReadText(1001, 120) .. " " .. menu.selectedOption.location
		info = info .. "\n" .. ReadText(1001, 4823) .. ReadText(1001, 120) .. " " .. menu.selectedOption.id
		info = info .. "\n" .. ReadText(1001, 2655) .. ReadText(1001, 120) .. " " .. menu.selectedOption.version
		if #menu.selectedOption.dependencies > 0 then
			info = info .. "\n" .. ReadText(1001, 2692) .. ReadText(1001, 120)
			for i, dependency in ipairs(menu.selectedOption.dependencies) do
				info = info .. "\n- " .. dependency.name .. " (" .. dependency.id .. ")"
			end
		end
		return info
	end
	return ""
end

function menu.warningExtensions()
	local basetext = ReadText(1001, 11719) .. "\n\n" .. string.format(ReadText(1001, 11720), ffi.string(C.GetSaveFolderPath()))
	if menu.extensionSettingsChanged == nil then
		menu.extensionSettingsChanged = HaveExtensionSettingsChanged()
	end
	if menu.extensionSettingsChanged then
		return basetext .. "\n\n\27R" .. ReadText(1001, 2689)
	else
		local warning = GetExtensionUpdateWarningText("", false)
		return basetext .. (warning and ("\n\n\27Y" .. warning) or "\n\n ")
	end
end

function menu.warningExtensionSettings()
	if menu.selectedExtension.error then
		return "\27R" .. menu.selectedExtension.errortext
	elseif menu.selectedExtension.warningtext then
		return "\27Y" .. menu.selectedExtension.warningtext
	else
		if menu.extensionSettingsChanged == nil then
			menu.extensionSettingsChanged = HaveExtensionSettingsChanged()
		end
		return menu.extensionSettingsChanged and ("\27R" .. ReadText(1001, 2689)) or ""
	end
end

function menu.warningGfx()
	local warning = ""
	if (not C.IsCurrentGPUDiscrete()) and (not C.IsRunningOnSteamDeck()) then
		warning = "\27R" .. ReadText(1001, 8980)
	elseif C.AreGfxSettingsTooHigh() then
		warning = "\27R" .. ReadText(1001, 8919)
	end

	if C.GetVolumetricFogOption() > 0 then
		local aaoption = ffi.string(C.GetAAOption(false))
		if (aaoption == "msaa_4x") or (aaoption == "msaa_8x") or (aaoption == "ssaa_4x") then
			if warning ~= "" then
				warning = warning .. "\n"
			end
			warning = warning .. Helper.convertColorToText(Helper.color.warningorange) .. ReadText(1001, 11704)
		end
	end

	if C.IsFSROnWithoutAA() then
		if warning ~= "" then
			warning = warning .. "\n"
		end
		warning = warning .. Helper.convertColorToText(Helper.color.warningorange) .. ReadText(1001, 11727)
	end

	if not C.IsRequestedGPUCurrent() then
		if warning ~= "" then
			warning = warning .. "\n"
		end
		warning = warning .. "\27R" .. ReadText(1001, 2689)
	end
	return warning
end

function menu.warningInput()
	if CheckInputProfileRegression() then
		return "\27Y" .. ReadText(1001, 4879)
	end
	return ""
end

function menu.warningOnline()
	local warningtext = ""

	local state = OnlineGetVersionIncompatibilityState()
	if state ~= 0 then
		if state == 1 then
			warningtext = Helper.convertColorToText(Helper.color.red) .. ReadText(1001, 11351) .. "\27X"
		elseif state == 2 then
			warningtext = Helper.convertColorToText(Helper.color.red) .. ReadText(1001, 11353) .. "\27X"
		end
	end

	if menu.isVentureExtensionRestartRequired() then
		warningtext = Helper.convertColorToText(Helper.color.warningorange) .. ReadText(1001, 2689) .. "\27X"
	end

	return warningtext
end

function menu.warningSettings()
	local languageWarning = ""
	local languageFont = config.font
	if menu.isStartmenu and C.IsLanguageSettingEnabled() then
		menu.getLanguageData()

		for _, language in ipairs(menu.languagedata) do
			if language.id == menu.languagedata.requestedID then
				if menu.languagedata.haswarning then
					languageWarning = "\27Y" .. language.warning
					menu.selectedrow = 3
					if language.font ~= "" then
						languageFont = language.font
					end
				end
				break
			end
		end
	end

	return languageWarning, languageFont
end

function menu.valueAccessibilityGlobalLightScale()
	local enginevalue = C.GetGlobalLightScale() -- 0.5 - 1.0
	local uivalue = (enginevalue - 0.5) / 0.5 * 0.9 + 0.1 -- 0.1 - 1.0
	local start = math.floor(uivalue * 100)

	local scale = {
		min            = 0,
		minSelect      = 10,
		max            = 100,
		start          = start,
		step           = 1,
		suffix         = "",
		exceedMaxValue = false,
		hideMaxValue   = true,
	}

	return scale
end

function menu.valueExtensionGlobalSync()
	local globalsync
	local globalsynccolor = Helper.color.white
	if menu.extensionSettings[0] ~= nil and menu.extensionSettings[0].sync ~= nil then
		globalsync = menu.extensionSettings[0].sync
		if globalsync ~= GetGlobalSyncSetting() then
			globalsynccolor = Helper.color.red
		end
	else
		globalsync = GetGlobalSyncSetting()
	end
	return globalsync and ReadText(1001, 2617) or ReadText(1001, 2618), globalsynccolor
end

function menu.valueExtensionStatus(extension)
	local statuscolor = Helper.color.white
	local enabled
	if menu.extensionSettings[extension.index] ~= nil and menu.extensionSettings[extension.index].enabled ~= nil then
		enabled = menu.extensionSettings[extension.index].enabled
	else
		enabled = extension.enabledbydefault
	end
	if enabled ~= extension.enabled then
		statuscolor = Helper.color.red
	end
	return enabled and ReadText(1001, 2648) or ReadText(1001, 2649), statuscolor
end

function menu.valueExtensionSettingEnabled()
	local status
	local statuscolor = Helper.color.white
	local enabled
	if menu.extensionSettings[menu.selectedExtension.index] ~= nil and menu.extensionSettings[menu.selectedExtension.index].enabled ~= nil then
		enabled = menu.extensionSettings[menu.selectedExtension.index].enabled
	else
		enabled = menu.selectedExtension.enabledbydefault
	end
	if enabled ~= menu.selectedExtension.enabled then
		statuscolor = Helper.color.red
	end
	status = enabled and ReadText(1001, 2617) or ReadText(1001, 2618)
	return status, statuscolor
end

function menu.valueExtensionSettingSync()
	local status
	local statuscolor = Helper.color.white
	local sync
	if menu.extensionSettings[menu.selectedExtension.index] ~= nil and menu.extensionSettings[menu.selectedExtension.index].sync ~= nil then
		sync = menu.extensionSettings[menu.selectedExtension.index].sync
	else
		sync = menu.selectedExtension.syncbydefault
	end
	if sync ~= menu.selectedExtension.sync then
		statuscolor = Helper.color.red
	end
	status = sync and ReadText(1001, 2617) or ReadText(1001, 2618)
	return status, statuscolor
end

function menu.valueGameAimAssist()
	local options = {}
	local currentOption = GetAimAssistOption() + 1

	local settings = {
		[1] = ReadText(1001, 2649),
		[2] = ReadText(1001, 2648),
		[3] = ReadText(1001, 2695),
	}
	for i, entry in ipairs(settings) do
		table.insert(options, { id = i, text = entry, icon = "", displayremoveoption = false })
	end

	return options, currentOption
end

function menu.valueGameAutosaveInterval()
	local options = {}
	local currentOption = ""

	local intervalinfo = C.GetAutosaveIntervalOption()
	currentOption = tostring(Helper.round(intervalinfo.factor, 2))

	local settings = {
		[1] = 0.25,
		[2] = 0.5,
		[3] = 1,
		[4] = 2,
	}
	for i, entry in ipairs(settings) do
		table.insert(options, { id = entry, text = string.format("%d - %d %s", intervalinfo.mintime * entry / 60, intervalinfo.maxtime * entry / 60, ReadText(1001, 103)), icon = "", displayremoveoption = false })
	end

	return options, currentOption, nil, "right"
end

function menu.valueGameCockpitCamera()
	local start = math.floor(C.GetCockpitCameraScaleOption() * 100)

	local scale = {
		min            = 0,
		max            = 100,
		start          = start,
		step           = 1,
		suffix         = "",
		exceedMaxValue = false,
		hideMaxValue   = true,
	}

	return scale
end

function menu.valueGameEnemyAttack()
	local currentOption = ffi.string(C.GetEnemyWarningAttackSound())

	local n = C.GetNumPlayerAlertSounds2("hostile")
	local buf = ffi.new("SoundInfo[?]", n)
	n = C.GetPlayerAlertSounds2(buf, n, "hostile")
	local options = {}
	for i = 0, n - 1 do
		table.insert(options, { id = ffi.string(buf[i].id), text = ffi.string(buf[i].name), icon = "", displayremoveoption = false })
	end
	table.sort(options, function (a, b) return a.text < b.text end)

	local n = C.GetNumPlayerAlertSounds2("disabled")
	local buf = ffi.new("SoundInfo[?]", n)
	n = C.GetPlayerAlertSounds2(buf, n, "disabled")
	for i = 0, n - 1 do
		table.insert(options, 1, { id = ffi.string(buf[i].id), text = ffi.string(buf[i].name), icon = "", displayremoveoption = false })
	end

	return options, currentOption
end

function menu.valueGameEnemyNearby()
	local currentOption = ffi.string(C.GetEnemyWarningNearbySound())

	local n = C.GetNumPlayerAlertSounds2("hostile")
	local buf = ffi.new("SoundInfo[?]", n)
	n = C.GetPlayerAlertSounds2(buf, n, "hostile")
	local options = {}
	for i = 0, n - 1 do
		table.insert(options, { id = ffi.string(buf[i].id), text = ffi.string(buf[i].name), icon = "", displayremoveoption = false })
	end
	table.sort(options, function (a, b) return a.text < b.text end)

	local n = C.GetNumPlayerAlertSounds2("disabled")
	local buf = ffi.new("SoundInfo[?]", n)
	n = C.GetPlayerAlertSounds2(buf, n, "disabled")
	for i = 0, n - 1 do
		table.insert(options, 1, { id = ffi.string(buf[i].id), text = ffi.string(buf[i].name), icon = "", displayremoveoption = false })
	end

	return options, currentOption
end

function menu.valueGameRadar()
	local options = {}
	local currentOption = ""

	if not C.IsHUDRadarActive() then
		currentOption = 1
	else
		if C.GetHUDSeparateRadar() then
			currentOption = 2
		else
			currentOption = 3
		end
	end

	local settings = {
		[1] = ReadText(1001, 2649),
		[2] = ReadText(1001, 7259),
		[3] = ReadText(1001, 7260),
	}
	for i, entry in ipairs(settings) do
		table.insert(options, { id = i, text = entry, icon = "", displayremoveoption = false })
	end

	return options, currentOption
end

function menu.valueGameRumble()
	local start = math.floor(GetRumbleOption() * 100)

	local scale = {
		min            = 0,
		max            = 100,
		start          = start,
		step           = 1,
		suffix         = "",
		exceedMaxValue = false,
		hideMaxValue   = true,
	}

	return scale
end

function menu.valueGameStartmenuBackground()
	local options = {}
	local currentOption = ffi.string(C.GetStartmenuBackgroundOption())

	local n = C.GetNumStartmenuBackgrounds()
	local buf = ffi.new("StartmenuBackgroundInfo[?]", n)
	n = C.GetStartmenuBackgrounds(buf, n)
	local extensioncounts = {}
	local scenes = {}
	for i = 0, n - 1 do
		local id = ffi.string(buf[i].cutsceneid)
		if not buf[i].isdefault then
			extensioncounts[buf[i].extensionidx] = (extensioncounts[buf[i].extensionidx] or 0) + 1
		end
		local extensionname = (buf[i].extensionidx == 0) and ReadText(1021, 65) or ffi.string(C.GetExtensionName(buf[i].extensionidx))

		table.insert(scenes, { id = id, text = extensionname, counter = extensioncounts[buf[i].extensionidx], extensionidx = buf[i].extensionidx, isdefault = buf[i].isdefault })
	end
	table.sort(scenes, menu.sortGameStartmenuBackground)

	table.insert(options, { id = "random", text = ReadText(1001, 11762), icon = "", displayremoveoption = false })
	for _, scene in ipairs(scenes) do
		if scene.isdefault then
			menu.startmenuBackgroundDefaultValue = scene.id
			if currentOption == "" then
				currentOption = scene.id
			end
			table.insert(options, 1, { id = scene.id, text = ReadText(1001, 3231), icon = "", displayremoveoption = false })
		else
			local text = scene.text .. ((extensioncounts[scene.extensionidx] > 1) and (" " .. ReadText(20402, scene.counter)) or "")
			table.insert(options, { id = scene.id, text = text, icon = "", displayremoveoption = false })
		end
	end

	menu.startmenuBackgroundCurValue = menu.startmenuBackgroundCurValue or currentOption
	return options, currentOption
end

function menu.sortGameStartmenuBackground(a, b)
	if a.text == b.text then
		return a.id < b.id
	end
	return a.text < b.text
end

function menu.valueGameSubtitles()
	local options = {}
	local currentOption = GetSubtitleOption()

	local settings = {
		[1] = { id = "auto", name = ReadText(1001, 4806) },
		[2] = { id = "true", name = ReadText(1001, 2648) },
		[3] = { id = "false", name = ReadText(1001, 2649) },
	}
	for _, entry in ipairs(settings) do
		table.insert(options, { id = entry.id, text = entry.name, icon = "", displayremoveoption = false })
	end

	return options, currentOption
end

function menu.valueGameUIScale()
	local maxUIScale = (Helper.viewWidth <= 1280) and 1.4 or 1.5
	local max = 1.5
	if C.IsRunningOnSteamDeck() then
		maxUIScale = 1.6
		max = 1.6
	end
	menu.newUIScale = math.max(0.5, math.min(maxUIScale, Helper.round(C.GetUIScaleFactor(), 1)))

	local scale = {
		min            = 0.5,
		max            = max,
		maxSelect      = maxUIScale,
		start          = menu.newUIScale,
		step           = 0.1,
		suffix         = "",
		exceedMaxValue = false,
		hideMaxValue   = true,
	}

	return scale
end

function menu.valueGfxAA()
	local options = {}
	local currentOption = ffi.string(C.GetAAOption(false))

	local settings = {
		{"none"			, ReadText(1001, 7275)}, -- None
		{"fxaa_low"		, ReadText(1001, 7270)}, -- FXAA low
		{"fxaa_medium"	, ReadText(1001, 7271)}, -- FXAA medium
		{"fxaa_high"	, ReadText(1001, 7272)}, -- FXAA high
		{"msaa_2x"		, ReadText(1001, 7278)}, -- MSAA 2x
		{"msaa_4x"		, ReadText(1001, 7279)}, -- MSAA 4x
		{"msaa_8x"		, ReadText(1001, 7280)}, -- MSAA 8x
		{"msaa_16x"		, ReadText(1001, 7281)}, -- MSAA 16x
		{"ssaa_2x"		, ReadText(1001, 7273)}, -- SSAA 2x
		{"ssaa_4x"		, ReadText(1001, 7274)}, -- SSAA 4x
		--{"ssaa_6x"		, ReadText(1001, 7276)}, -- SSAA 6x
		--{"ssaa_9x"		, ReadText(1001, 7277)}, -- SSAA 9x
	}

	local currentUpscalingOption = ffi.string(C.GetUpscalingOption(false))
	for i, entry in ipairs(settings) do
		entry.id = i
		entry.active = C.IsAAOptionSupported(entry[1])
		if not entry.active then
			entry.mouseovertext = "\27R" .. ReadText(1026, 2627)
		end
		if (entry[1] == "ssaa_2x") or (entry[1] == "ssaa_4x") or (entry[1] == "ssaa_6x") or (entry[1] == "ssaa_9x") then
			local oldactive = entry.active
			entry.active = entry.active and (currentUpscalingOption == "none")
			if oldactive and (not entry.active) then
				entry.mouseovertext = "\27R" .. ReadText(1026, 2656)
			end
		end
	end
	table.sort(settings, menu.sortActiveEntries)

	for i, entry in ipairs(settings) do
		table.insert(options, { id = entry[1], text = entry[2], icon = "", displayremoveoption = false, active = entry.active, mouseovertext = entry.mouseovertext })
	end

	return options, currentOption
end

function menu.valueGfxAdaptiveSampling()
	local options = {}
	local currentOption = C.GetAdaptiveSamplingOption()

	local settings = {
		{ 0.73 },
		{ 0.81 },
		{ 0.90 },
		{ 1.00, ReadText(1001, 7222) },
		{ 1.10 },
		{ 1.20 },
		{ 1.30 },
		{ 1.40 },
		{ 0.00, ReadText(1001, 7223) }
	}
	for _, entry in ipairs(settings) do
		table.insert(options, { id = entry[1], text = entry[2] or Helper.roundStr(entry[1], 2), icon = "", displayremoveoption = false })
	end

	return options, currentOption
end

function menu.valueGfxAdapter()
	local options = {}
	local currentOption = ""

	local current = GetAdapterOption()
	local adapters = GetPossibleAdapters()
	for i, adapter in ipairs(adapters) do
		table.insert(options, { id = adapter.ordinal, text = adapter.name, icon = "", displayremoveoption = false })
		if adapter.name == current then
			currentOption = adapter.ordinal
		end
	end

	return options, currentOption
end

function menu.valueGfxEffectDistance()
	local start = Helper.round(GetEffectDistanceOption() * 100)

	local scale = {
		min            = 0,
		max            = 100,
		start          = start,
		step           = 1,
		suffix         = "",
		exceedMaxValue = false,
		hideMaxValue   = true,
		readOnly       = not menu.selectableGfxPreset(),
	}

	return scale
end

function menu.valueGfxEnvMapProbes()
	local options = {}
	local currentOption = ffi.string(C.GetEnvMapProbeOption())

	local settings = {
		{"none"			, ReadText(1001, 2649)},
		{"low"			, ReadText(1001, 2650)},
		{"medium"		, ReadText(1001, 4838)},
		{"high"			, ReadText(1001, 2651)},
	}
	for i, entry in ipairs(settings) do
		table.insert(options, { id = entry[1], text = entry[2], icon = "", displayremoveoption = false })
	end

	return options, currentOption
end

function menu.valueGfxEnvMapProbesInsideGlassFade()
	local value = C.GetEnvMapProbeInsideGlassFadeOption()
	local start = math.floor(value * 100)

	local scale = {
		min            = 0,
		max            = 100,
		start          = start,
		step           = 1,
		suffix         = "",
		exceedMaxValue = false,
		hideMaxValue   = true,
	}

	return scale
end

function menu.valueGfxFullscreen()
	local options = {}
	local currentOption = ""

	local fullscreen, borderless = GetFullscreenOption()
	if fullscreen then
		currentOption = 1
	else
		if borderless then
			currentOption = 3
		else
			currentOption = 2
		end
	end
	local settings = {
		[1] = ReadText(1001, 2622), -- Fullscreen
		[2] = ReadText(1001, 4818), -- Windowed
		[3] = ReadText(1001, 4819), -- Borderless
	}
	for i, entry in ipairs(settings) do
		table.insert(options, { id = i, text = entry, icon = "", displayremoveoption = false })
	end

	return options, currentOption
end

function menu.valueGfxGamma()
	local gamma = math.floor(GetGammaOption() * 100)
	local start = nil
	if gamma < 50 then
		start = 50
	elseif gamma >= 200 then
		start = 200
	else
		start = gamma
	end

	local scale = {
		min            = 50,
		max            = 200,
		start          = start,
		step           = 1,
		suffix         = "",
		exceedMaxValue = false,
		hideMaxValue   = true,
	}

	return scale
end

function menu.valueGfxGlow()
	local options = {}
	local currentOption = GetGlowOption() + 1

	local settings = {
		[1] = ReadText(1001, 2649),
		[2] = ReadText(1001, 2650),
		[3] = ReadText(1001, 2652),
		[4] = ReadText(1001, 2651),
	}
	for i, entry in ipairs(settings) do
		table.insert(options, { id = i, text = entry, icon = "", displayremoveoption = false })
	end

	return options, currentOption
end

function menu.valueGfxGPU()
	local options = {}
	local currentOption = C.GetRequestedGPU()
	local numgpus = C.GetNumGPUs()
	for i = 1, numgpus do
		table.insert(options, { id = i, text = ffi.string(C.GetGPUNiceName(i)), icon = "", displayremoveoption = false, active = C.IsGPUCompatible(i) })
	end

	return options, currentOption
end

function menu.valueGfxHMDResolution()
	local renderresolution = C.GetRenderResolutionOption()
	return renderresolution.x .. ReadText(1001, 42) .. renderresolution.y, Helper.color.white
end

function menu.valueGfxLOD()
	local start = Helper.round(GetLODOption() * 100)

	local scale = {
		min            = 0,
		max            = 100,
		start          = start,
		step           = 1,
		suffix         = "",
		exceedMaxValue = false,
		hideMaxValue   = true,
		readOnly       = not menu.selectableGfxPreset(),
	}

	return scale
end

function menu.valueGfxLUT(accessibility)
	local options = {}
	local currentOption = C.GetLUTMode()

	local settings = {
		[1] = { text = ReadText(1001, 7239) }, 
		[2] = { text = ReadText(1001, 7240), accessibility = false },
		[3] = { text = ReadText(1001, 7241), accessibility = false },
		[4] = { text = ReadText(1001, 7242), accessibility = false },
		[5] = { text = ReadText(1001, 7243), accessibility = false },
		--[6] = { text = ReadText(1001, 11756), accessibility = true },
		--[7] = { text = ReadText(1001, 11757), accessibility = true },
	}

	for i, entry in ipairs(settings) do
		table.insert(options, { id = i - 1, text = entry.text, icon = "", displayremoveoption = false, active = (entry.accessibility == nil) or (entry.accessibility == accessibility) })
	end

	return options, currentOption
end

function menu.valueGfxPOM()
	local options = {}
	local currentOption = ffi.string(C.GetPOMOption())

	local settings = {
		{"none"			, ReadText(1001, 2649)},
		{"low"			, ReadText(1001, 2650)},
		{"medium"		, ReadText(1001, 4838)},
		{"high"			, ReadText(1001, 2651)},
	}
	for i, entry in ipairs(settings) do
		table.insert(options, { id = entry[1], text = entry[2], icon = "", displayremoveoption = false })
	end

	return options, currentOption
end

function menu.valueGfxPreset()
	local options = {}
	local currentOption = GetGfxQualityOption() + 1

	local settings = {
		[1] = ReadText(1001, 4839),
		[2] = ReadText(1001, 2650),
		[3] = ReadText(1001, 4838),
		[4] = ReadText(1001, 2651),
		[5] = ReadText(1001, 4837),
	}
	for i, entry in ipairs(settings) do
		table.insert(options, { id = i, text = entry, icon = "", displayremoveoption = false })
	end

	return options, currentOption
end

function menu.valueGfxRadar()
	local options = {}
	local currentOption = GetRadarOption() + 1

	local settings = {
		[1] = ReadText(1001, 2649),
		[2] = ReadText(1001, 2650),
		[3] = ReadText(1001, 2651),
	}
	for i, entry in ipairs(settings) do
		table.insert(options, { id = i, text = entry, icon = "", displayremoveoption = false })
	end

	return options, currentOption
end

function menu.valueGfxResolution()
	local options = {}
	local currentOption = ""
	
	local oldresolution = GetResolutionOption()
	local resolutions = GetPossibleResolutions()
	function resolutionsort (a, b)
		local result = false
		if a.width < b.width then 
			result = true 
		elseif a.width == b.width then 
			result = a.height < b. height
		end
		return result
	end
	table.sort(resolutions, resolutionsort)

	currentOption = oldresolution.width .. ":" .. oldresolution.height
	local textOverride = oldresolution.width .. ReadText(1001, 42) .. oldresolution.height
	if #resolutions == 0 then
		table.insert(options, { id = currentOption, text = textOverride, icon = "", displayremoveoption = false })
	end
	for i, resolution in ipairs(resolutions) do
		table.insert(options, { id = resolution.width .. ":" .. resolution.height, text = resolution.width .. ReadText(1001, 42) .. resolution.height, icon = "", displayremoveoption = false })
	end

	return options, currentOption, textOverride
end

function menu.valueGfxShaderQuality()
	local options = {}
	local currentOption = GetShaderQualityOption() + 1

	local settings = {
		[1] = ReadText(1001, 2650),
		[2] = ReadText(1001, 2652),
		[3] = ReadText(1001, 2651),
	}
	for i, entry in ipairs(settings) do
		-- TEMP disable unsupported settings
		table.insert(options, { id = i, text = entry, icon = "", displayremoveoption = false, active = i == 3 })
	end

	return options, currentOption
end

function menu.valueGfxShadows()
	local options = {}
	local currentOption = GetShadowOption()

	local settings = {
		[0] = ReadText(1001, 2649),
		[2] = ReadText(1001, 2651),
		[3] = ReadText(1001, 4837),
	}
	for i, entry in Helper.orderedPairs(settings) do
		table.insert(options, { id = i, text = entry, icon = "", displayremoveoption = false })
	end

	return options, currentOption
end

function menu.valueGfxSSAO()
	local options = {}
	local currentOption = GetSSAOOption() + 1

	local settings = {
		[1] = ReadText(1001, 2649),
		[2] = ReadText(1001, 2650),
		[3] = ReadText(1001, 2652),
		[4] = ReadText(1001, 2651),
	}
	for i, entry in ipairs(settings) do
		table.insert(options, { id = i, text = entry, icon = "", displayremoveoption = false })
	end

	return options, currentOption
end

function menu.valueGfxSSR()
	local options = {}
	local currentOption = ffi.string(C.GetSSROption2())

	local settings = {
		{"off"			, ReadText(1001, 2649)},
		{"low"			, ReadText(1001, 2650)},
		{"medium"		, ReadText(1001, 4838)},
	}
	for i, entry in ipairs(settings) do
		table.insert(options, { id = entry[1], text = entry[2], icon = "", displayremoveoption = false })
	end

	return options, currentOption
end

function menu.valueGfxPresentMode()
	local options = {}
	local currentOption = ffi.string(C.GetPresentModeOption())

	local settings = {
		{"mailbox"		, ReadText(1001, 7266)}, -- Triple buffering VSync
		{"fifo_relaxed"	, ReadText(1001, 7267)}, -- Adaptive VSync
		{"fifo"			, ReadText(1001, 7268)}, -- VSync
		{"immediate"	, ReadText(1001, 7269)}, -- No VSync
	}
	for i, entry in ipairs(settings) do
		entry.id = i
		entry.active = C.IsPresentModeOptionSupported(entry[1])
	end
	table.sort(settings, menu.sortActiveEntries)

	for i, entry in ipairs(settings) do
		table.insert(options, { id = entry[1], text = entry[2], icon = "", displayremoveoption = false, active = entry.active, mouseovertext = entry.active and "" or ("\27R" .. ReadText(1026, 2627)) })
	end

	return options, currentOption
end

function menu.valueGfxTexture()
	local options = {}
	local currentOption = ffi.string(C.GetTextureQualityOption())

	local settings = {
		{"low"			, ReadText(1001, 2650)},
		{"medium"		, ReadText(1001, 4838)},
		{"high"			, ReadText(1001, 2651)},
	}

	for i, entry in ipairs(settings) do
		table.insert(options, { id = entry[1], text = entry[2], icon = "", displayremoveoption = false })
	end

	return options, currentOption
end

function menu.valueGfxUpscaling()
	local options = {}
	local currentOption = ffi.string(C.GetUpscalingOption(false))

	local settings = {
		{"none",				ReadText(1001, 11725)},
		{"fsr_performance",		ReadText(1001, 11724),	ReadText(1026, 2661)},
		{"fsr_balanced",		ReadText(1001, 11723),	ReadText(1026, 2660)},
		{"fsr_quality",			ReadText(1001, 11722),	ReadText(1026, 2659)},
		{"fsr_ultra_quality",	ReadText(1001, 11721),	ReadText(1026, 2658)},
	}
	for i, entry in ipairs(settings) do
		entry.id = i
		entry.active = C.IsUpscalingOptionSupported(entry[1])
	end
	table.sort(settings, menu.sortActiveEntries)

	for i, entry in ipairs(settings) do
		table.insert(options, { id = entry[1], text = entry[2], icon = "", displayremoveoption = false, active = entry.active, mouseovertext = entry.active and (entry[3] or "") or ("\27R" .. ReadText(1026, 2627)) })
	end

	return options, currentOption
end

function menu.valueGfxVolumetric()
	local options = {}
	local currentOption = C.GetVolumetricFogOption() + 1

	local settings = {
		[1] = ReadText(1001, 2649),
		[2] = ReadText(1001, 2650),
		[3] = ReadText(1001, 4838),
		[4] = ReadText(1001, 2651),
	}
	for i, entry in ipairs(settings) do
		table.insert(options, { id = i, text = entry, icon = "", displayremoveoption = false })
	end

	return options, currentOption
end

function menu.valueInputGamepadMode()
	local options = {}
	local currentOption = GetGamepadModeOption() + 1

	local settings = {
		[1] = ReadText(1001, 2649),
		[2] = ReadText(1001, 4868),
		[3] = ReadText(1001, 4869),
	}
	for i, entry in ipairs(settings) do
		table.insert(options, { id = i, text = entry, icon = "", displayremoveoption = false })
	end

	return options, currentOption
end

function menu.valueInputInvert(rangeid)
	return GetInversionSetting(rangeid) and ReadText(1001, 2676) or ReadText(1001, 2677)
end

function menu.valueInputJoystickDeadzone()
	local start = GetDeadzoneOption()

	local scale = {
		min            = 0,
		max            = 100,
		start          = start,
		step           = 1,
		suffix         = " %",
		exceedMaxValue = false,
		hideMaxValue   = true,
	}

	return scale
end

function menu.valueInputMouseHUDMode()
	local options = {}
	local currentOption = C.GetMouseHUDModeOption()

	local settings = {
		[1] = { name = ReadText(1001, 8938), mouseover = ReadText(1026, 2632) },
		[2] = { name = ReadText(1001, 8939), mouseover = ReadText(1026, 2633) },
	}
	for i, entry in ipairs(settings) do
		table.insert(options, { id = i, text = entry.name, icon = "", displayremoveoption = false, mouseovertext = entry.mouseover })
	end

	return options, currentOption
end

function menu.valueInputMouseSteeringInvert(configname)
	return C.GetMouseSteeringInvertedOption(configname) and ReadText(1001, 2676) or ReadText(1001, 2677)
end

function menu.valueInputSensitivity(rangeid)
	local start = math.max(1, math.min(100, Helper.round(GetSensitivitySetting(rangeid) * 100)))

	local scale = {
		min            = 0,
		minSelect      = 1,
		max            = 100,
		start          = start,
		step           = 1,
		suffix         = "",
		exceedMaxValue = false,
		hideMaxValue   = true,
	}

	return scale
end

function menu.valueInputTobiiAngleFactor()
	local start = math.max(50, math.min(200, C.GetTobiiAngleFactor() * 100))

	local scale = {
		min            = 0,
		minSelect      = 50,
		max            = 200,
		start          = start,
		step           = 1,
		suffix         = " %",
		exceedMaxValue = false,
		hideMaxValue   = true,
	}

	return scale
end

function menu.valueInputTobiiGazeAngleFactor()
	local start = math.max(10, math.min(200, C.GetTobiiGazeAngleFactor() * 100))

	local scale = {
		min            = 0,
		minSelect      = 10,
		max            = 200,
		start          = start,
		step           = 1,
		suffix         = " %",
		exceedMaxValue = false,
		hideMaxValue   = true,
	}

	return scale
end

function menu.valueInputTobiiGazeFilterStrength()
	local start = math.max(5, math.min(50, tonumber(C.GetTobiiGazeFilterStrength())))

	local scale = {
		min            = 0,
		minSelect      = 5,
		max            = 50,
		start          = start,
		step           = 1,
		exceedMaxValue = false,
		hideMaxValue   = true,
	}

	return scale
end

function menu.valueInputTobiiHeadFilterStrength()
	local start = math.max(5, math.min(25, tonumber(C.GetTobiiHeadFilterStrength())))

	local scale = {
		min            = 0,
		minSelect      = 5,
		max            = 25,
		start          = start,
		step           = 1,
		exceedMaxValue = false,
		hideMaxValue   = true,
	}

	return scale
end

function menu.valueInputTobiiDeadzoneAngle()
	local start = math.max(0, math.min(10, C.GetTobiiDeadzoneAngle()))

	local scale = {
		min            = 0,
		max            = 10,
		start          = start,
		step           = 1,
		exceedMaxValue = false,
		hideMaxValue   = true,
	}

	return scale
end

function menu.valueInputTobiiGazeDeadzone()
	local start = math.max(0, math.min(20, C.GetTobiiGazeDeadzone() * 100))

	local scale = {
		min            = 0,
		max            = 20,
		start          = start,
		step           = 1,
		suffix         = " %",
		exceedMaxValue = false,
		hideMaxValue   = true,
	}

	return scale
end

function menu.valueInputTobiiDeadzonePosition()
	local start = math.max(0, math.min(150, C.GetTobiiDeadzonePosition()))

	local scale = {
		min            = 0,
		max            = 150,
		start          = start,
		step           = 10,
		exceedMaxValue = false,
		hideMaxValue   = true,
	}

	return scale
end

function menu.valueInputTobiiMode()
	local options = {}
	local currentOption = ffi.string(C.GetTobiiMode())

	local settings = {
		{ "disabled"		, ReadText(1001, 8942) },
		{ "head_tracking"	, ReadText(1001, 8945), ReadText(1026, 2637) },
		{ "gaze_continous"	, ReadText(1001, 8957), ReadText(1026, 2643) },
		{ "combined"		, ReadText(1001, 8956), ReadText(1026, 2642) },
	}
	for i, entry in ipairs(settings) do
		table.insert(options, { id = entry[1], text = entry[2], icon = "", displayremoveoption = false, mouseovertext = entry[3] })
	end

	return options, currentOption
end

function menu.valueInputTobiiPositionFactor()
	local start = math.max(25, math.min(150, C.GetTobiiHeadPositionFactor() * 100))

	local scale = {
		min            = 0,
		minSelect      = 25,
		max            = 150,
		start          = start,
		step           = 1,
		suffix         = " %",
		exceedMaxValue = false,
		hideMaxValue   = true,
	}

	return scale
end

function menu.valueInputVivePointingDevice()
	local options = {}
	local currentOption = C.GetVRVivePointerHand() + 1

	local settings = {
		[1] = ReadText(1001, 7226),
		[2] = ReadText(1001, 7225),
	}
	for i, entry in ipairs(settings) do
		table.insert(options, { id = i, text = entry, icon = "", displayremoveoption = false })
	end

	return options, currentOption
end

function menu.valueOnlineAllowInvites()
	local _, _, areinvitationsallowed = OnlineGetUserName()
	return areinvitationsallowed and ReadText(1001, 2617) or ReadText(1001, 2618)
end

function menu.valueOnlineAllowPrivateMessages()
	return OnlineUserArePrivateMessagesAllowed() and ReadText(1001, 2617) or ReadText(1001, 2618)
end

function menu.valueOnlineOperationUpdates()
	local options = {}
	local currentOption = "email" --ffi.string(C.GetTobiiMode()) -- TODO onlineUI

	local settings = {
		{ "email"		, ReadText(1001, 11316) },
		{ "message"		, ReadText(1001, 11317) },
	}
	for i, entry in ipairs(settings) do
		table.insert(options, { id = entry[1], text = entry[2], icon = "", displayremoveoption = false, mouseovertext = entry[3] })
	end

	return options, currentOption
end

function menu.valueOnlinePreferredLanguage()
	local options = {}
	local currentOption = OnlineGetCurrentUserLanguage()

	menu.getLanguageData()
	for _, language in ipairs(menu.languagedata) do
		table.insert(options, { id = language.id, text = language.name, icon = "", displayremoveoption = false, font = language.font })
	end

	return options, currentOption
end

function menu.valueOnlinePromotion()
	local options = {}
	local currentOption = "email" --ffi.string(C.GetTobiiMode()) -- TODO onlineUI

	local settings = {
		{ "email"		, ReadText(1001, 11316) },
		{ "message"		, ReadText(1001, 11317) },
	}
	for i, entry in ipairs(settings) do
		table.insert(options, { id = entry[1], text = entry[2], icon = "", displayremoveoption = false, mouseovertext = entry[3] })
	end

	return options, currentOption
end

function menu.valueOnlineSeasonSummary()
	local options = {}
	local currentOption = "email" --ffi.string(C.GetTobiiMode()) -- TODO onlineUI

	local settings = {
		{ "email"		, ReadText(1001, 11316) },
		{ "message"		, ReadText(1001, 11317) },
	}
	for i, entry in ipairs(settings) do
		table.insert(options, { id = entry[1], text = entry[2], icon = "", displayremoveoption = false, mouseovertext = entry[3] })
	end

	return options, currentOption
end

function menu.valueOnlineSeasonUpdates()
	local options = {}
	local currentOption = "email" --ffi.string(C.GetTobiiMode()) -- TODO onlineUI

	local settings = {
		{ "email"		, ReadText(1001, 11316) },
		{ "message"		, ReadText(1001, 11317) },
	}
	for i, entry in ipairs(settings) do
		table.insert(options, { id = entry[1], text = entry[2], icon = "", displayremoveoption = false, mouseovertext = entry[3] })
	end

	return options, currentOption
end

function menu.valueSfxDevice()
	local options = {
		{ id = "default", text = ReadText(1001, 8961), icon = "", displayremoveoption = false }
	}
	local currentOption = ffi.string(C.GetCurrentSoundDevice())
	if currentOption == "" then
		currentOption = "default"
	end

	local n = C.GetNumSoundDevices()
	local buf = ffi.new("const char*[?]", n)
	n = C.GetSoundDevices(buf, n)
	for i = 0, n - 1 do
		local name = ffi.string(buf[i])
		local text = name
		if string.find(text, "OpenAL Soft on ") then
			text = string.sub(text, 16)
		end
		local mouseovertext = text

		local length = C.GetTextWidth(text, config.font, Helper.scaleFont(config.font, config.standardFontSize))
		local availablewidth = menu.table.infoColumnWidth - Helper.scaleX(config.standardTextHeight) - Helper.scaleX(config.standardTextOffsetX)
		if length > availablewidth then
			local suffix = utf8.sub(text, -6) -- the last 6 characters
			local suffixlength = C.GetTextWidth(suffix, config.font, Helper.scaleFont(config.font, config.standardFontSize))
			text = TruncateText(utf8.sub(text, 1, -7), config.font, Helper.scaleFont(config.font, config.standardFontSize), availablewidth - suffixlength) .. suffix
		end

		table.insert(options, { id = name, text = text, icon = "", displayremoveoption = false, mouseovertext = mouseovertext })
	end

	return options, currentOption
end

function menu.valueSfxSetting(sfxtype)
	local start = Helper.round(GetVolumeOption(sfxtype) * 100)

	local scale = {
		min            = 0,
		max            = 100,
		start          = start,
		step           = 1,
		suffix         = "",
		exceedMaxValue = false,
		hideMaxValue   = true,
	}

	return scale
end

function menu.selectableContinue()
	if menu.isStartmenu then
		if menu.savegames then
			if next(menu.savegames) then
				local entry
				for _, save in ipairs(menu.savegames) do
					if not save.isonline then
						entry = save
						break
					end
				end
				if entry then
					return not (entry.invalidpatches or entry.invalidversion or entry.invalidgameid)
				end
			end
		end
		return false
	end
	return true
end

function menu.selectableGameResetUserQuestions()
	for questiontype in pairs(__CORE_DETAILMONITOR_USERQUESTION) do
		if questiontype ~= "version" then
			return true
		end
	end
	return false
end

function menu.selectableGameStartmenuBackgroundConfirm()
	local currentOption = ffi.string(C.GetStartmenuBackgroundOption())
	if currentOption == "" then
		currentOption = menu.startmenuBackgroundDefaultValue
	end
	return menu.startmenuBackgroundCurValue ~= currentOption
end

function menu.selectableGameUIScaleConfirm()
	return menu.newUIScale ~= Helper.round(C.GetUIScaleFactor(), 1)
end

function menu.selectableGfxAdapter()
	local screendisplay = C.GetScreenDisplayOption()
	return ((not screendisplay) or (not C.IsVRVersion()))
end

function menu.selectableGfxFullscreen()
	local screendisplay = C.GetScreenDisplayOption()
	return ((not screendisplay) or (not C.IsVRVersion()))
end

function menu.selectableGfxGPU()
	return not C.IsGPUAutomaticallySelected()
end

function menu.selectableGfxPreset()
	return GetGfxQualityOption() == 0
end

function menu.selectableGfxResolution()
	local screendisplay = C.GetScreenDisplayOption()
	local fullscreen, borderless = GetFullscreenOption()
	return ((not screendisplay) or (not C.IsVRVersion())) and (not borderless)
end

function menu.selectableGfxUpscaling()
	local currentAAOption = ffi.string(C.GetAAOption(false))

	if (currentAAOption == "ssaa_2x") or (currentAAOption == "ssaa_4x") or (currentAAOption == "ssaa_6x") or (currentAAOption == "ssaa_9x") then
		return false
	end
	return true
end

function menu.selectableOnlineSeason()
	local entry = menu.getLatestOnlineSave()
	if entry then
		if (not C.AreVenturesEnabled()) or (not OnlineHasSession()) then
			return false
		end
		local state = OnlineGetVersionIncompatibilityState()
		if state == 0 then
			return OnlineHasSession() and (not (entry.invalidpatches or entry.invalidversion or entry.invalidgameid))
		end
	end
	return true
end

function menu.callbackAccessibilityDefaults()
	C.RestoreAccessibilityOptions()
	menu.onCloseElement("back")
	menu.delayedRefresh = getElapsedTime() + 0.1
end

function menu.callbackAccessibilityGlobalLightScale(value)
	if value then
		local enginevalue = (value / 100 - 0.1) / 0.9 * 0.5 + 0.5
		C.SetGlobalLightScale(enginevalue)
	end
end

function menu.callbackAccessibilityLongRangeScan()
	C.SetLongRangeScanIndicatorOption(not C.GetLongRangeScanIndicatorOption())
end

function menu.callbackAccessibilitySignalLeak()
	C.SetSignalLeakIndicatorOption(not C.GetSignalLeakIndicatorOption())
end

function menu.loadGameCallback(filename, checked)
	local playerinventory = GetPlayerInventory()
	local onlineitems = OnlineGetUserItems()

	local hasnotuploadeditems = false
	for ware, waredata in Helper.orderedPairs(playerinventory) do
		local isbraneitem, isoperationvolatile, isseasonvolatile, isventureuploadallowed = GetWareData(ware, "isbraneitem", "isoperationvolatile", "isseasonvolatile", "isventureuploadallowed")
		if isbraneitem then
			local serveramount = 0
			if onlineitems[ware] then
				serveramount = onlineitems[ware].amount
			end
			if isventureuploadallowed and (waredata.amount > serveramount) then
				hasnotuploadeditems = true
				break
			end
		end
	end

	if (not checked) and (not menu.isStartmenu) and Helper.isOnlineGame() and hasnotuploadeditems then
		table.insert(menu.history, 1, { optionParameter = menu.currentOption, topRow = GetTopRow(menu.optionTable), selectedOption = filename })
		menu.displayUserQuestion(ReadText(1001, 2604) .. " - " .. ReadText(1001, 7720), function () return menu.loadGameCallback(filename, true) end, nil, nil, nil, nil, nil, ReadText(1001, 11707))
	else

		-- kuertee start: callback
		if callbacks ["loadGameCallback_preLoadGame"] then
			for _, callback in ipairs (callbacks ["loadGameCallback_preLoadGame"]) do
				callback(filename)
			end
		end
		-- kuertee end: callback

		LoadGame(filename)
		menu.displayInit()
	end
end

function menu.callbackContinue()
	if menu.isStartmenu then
		-- no need to set menu.savegames again - it's already populated, otherwise we could not have selected the row
		local entry
		for _, save in ipairs(menu.savegames) do
			if not save.isonline then
				entry = save
				break
			end
		end
		if entry then
			menu.loadGameCallback(entry.filename, false)
		end
	else
		menu.onCloseElement()
	end
end

function menu.callbackOnlineSeason()
	local entry = menu.getLatestOnlineSave()
	if entry then
		-- no need to set menu.savegames again - it's already populated, otherwise we could not have selected the row
		menu.loadGameCallback(entry.filename, false)
	else
		menu.openSubmenu("onlineseason", "onlineseason")
	end
end

function menu.callbackDeleteSave(filename)
	C.DeleteSavegame(filename)

	menu.savegames = nil
	menu.onlinesave = nil
	C.ReloadSaveList()
	menu.onCloseElement("back")

	-- kuertee start: callback
	if callbacks ["callbackDeleteSave_onDeleteSave"] then
		for _, callback in ipairs (callbacks ["callbackDeleteSave_onDeleteSave"]) do
			callback(filename)
		end
	end
	-- kuertee end: callback
end

function menu.callbackExit(quit)
	if quit then
		QuitGame()
	else
		QuitModule()
	end
	menu.closeMenu("close")
end

function menu.callbackExtensionDefaults()
	ResetAllExtensionSettings()
	menu.extensionSettingsChanged = nil
	menu.onCloseElement("back")
end

function menu.callbackExtensionSettingEnabled(overrideextension)
	local extension = overrideextension or menu.selectedExtension

	local enabled
	if menu.extensionSettings[extension.index] ~= nil and menu.extensionSettings[extension.index].enabled ~= nil then
		enabled = not menu.extensionSettings[extension.index].enabled
	else
		enabled = not extension.enabledbydefault
	end
	SetExtensionSettings(extension.id, extension.personal, "enable", enabled)
	menu.extensionSettingsChanged = nil
	menu.extensionSettings = GetAllExtensionSettings()

	if not __CORE_DETAILMONITOR_USERQUESTION["modified"] then
		if enabled and (not extension.egosoftextension) then
			local hasEnabledThirdPartyExtension = false

			local extensions = GetExtensionList()
			for _, extension in ipairs(extensions) do
				if extension.index ~= extension.index then
					local enabled
					if menu.extensionSettings[extension.index] ~= nil and menu.extensionSettings[extension.index].enabled ~= nil then
						enabled = menu.extensionSettings[extension.index].enabled
					else
						enabled = extension.enabledbydefault
					end
					if enabled and (not extension.egosoftextension) then
						hasEnabledThirdPartyExtension = true
						break
					end
				end
			end

			if not hasEnabledThirdPartyExtension then
				menu.contextMenuMode = "modified"
				menu.contextMenuData = { width = Helper.scaleX(400), y = Helper.viewHeight / 2, thirdparty = true }
				menu.createContextMenu()
			end
		end
	end
end

function menu.callbackExtensionSettingSync()
	local sync
	if menu.extensionSettings[menu.selectedExtension.index] ~= nil and menu.extensionSettings[menu.selectedExtension.index].sync ~= nil then
		sync = not menu.extensionSettings[menu.selectedExtension.index].sync
	else
		sync = not menu.selectedExtension.syncbydefault
	end
	SetExtensionSettings(menu.selectedExtension.id, menu.selectedExtension.personal, "sync", sync)
	menu.extensionSettingsChanged = nil
	menu.extensionSettings = GetAllExtensionSettings()
end

function menu.callbackExtensionSettingWorkshop()
	OpenWorkshop(menu.selectedExtension.id, menu.selectedExtension.personal)
end

function menu.callbackGameAimAssist(id, option)
	if option ~= menu.curDropDownOption[id] then
		menu.curDropDownOption[id] = option
		SetAimAssistOption(tonumber(option) - 1)
	end
end

function menu.callbackGameAutoroll()
	SetAutorollOption()
end

function menu.callbackGameAutosave()
	SetAutosaveOption()
	menu.refresh()
end

function menu.callbackGameAutosaveInterval(id, option)
	if option ~= menu.curDropDownOption[id] then
		C.SetAutosaveIntervalOption(tonumber(option))
	end
end

function menu.callbackGameBoost()
	SetBoostToggleOption()
end

function menu.callbackGameCockpitCamera(value)
	if value then
		C.SetCockpitCameraScaleOption(value / 100)
	end
end

function menu.callbackGameCollision()
	SetCollisionAvoidanceAssistOption()
end

function menu.callbackGameControlModeMessages()
	SetSteeringNoteOption()
end

function menu.callbackGameDefaults()
	__CORE_GAMEOPTIONS_RESTORE = true
	__CORE_GAMEOPTIONS_RESTOREINFO.optionParameter = nil
	__CORE_GAMEOPTIONS_RESTOREINFO.history = menu.history
	RestoreGameOptions()
	menu.displayInit(ReadText(1001, 409))
end

function menu.callbackGameEmergencyEject()
	C.SetEmergencyEjectOption(not C.GetEmergencyEjectOption())
end

function menu.callbackGameMouselook()
	SetMouseLookToggleOption()
end

function menu.callbackGameMouseOver()
	C.SetMouseOverTextOption(not C.GetMouseOverTextOption())
end

function menu.callbackGameRadar(id, option)
	if option ~= menu.curDropDownOption[id] then
		menu.curDropDownOption[id] = option
		option = tonumber(option)
		if option == 1 then
			C.SetHUDRadarActive(false)
		elseif option == 2 then
			C.SetHUDRadarActive(true)
			C.SetHUDRadarSeparate(true)
		elseif option == 3 then
			C.SetHUDRadarActive(true)
			C.SetHUDRadarSeparate(false)
		end
	end
end

function menu.callbackGameEnemyAttack(id, option)
	if option ~= menu.curDropDownOption[id] then
		menu.curDropDownOption[id] = option
		C.SetEnemyWarningAttackSound(option)
	end
end

function menu.callbackGameEnemyNearby(id, option)
	if option ~= menu.curDropDownOption[id] then
		menu.curDropDownOption[id] = option
		C.SetEnemyWarningNearbySound(option)
	end
end

function menu.callbackGameResetUserQuestions()
	__CORE_DETAILMONITOR_USERQUESTION = {
		version = __CORE_DETAILMONITOR_USERQUESTION.version,
	}
	menu.refresh()
end

function menu.callbackGameRumble(value)
	if value then
		SetRumbleOption(value / 100)
	end
end

function menu.callbackGameShootAtCursor()
	C.SetForceShootingAtCursorOption(not C.GetForceShootingAtCursorOption())
end

function menu.callbackGameSpeakTargetName()
	C.SetSpeakTargetNameOption(not C.GetSpeakTargetNameOption())
end

function menu.callbackGameStartmenuBackground(id, option)
	if option ~= menu.curDropDownOption[id] then
		menu.curDropDownOption[id] = option
		C.SetStartmenuBackgroundOption(option)
	end
end

function menu.callbackGameStopInMenu()
	SetStopShipInMenuOption()
end

function menu.callbackGameSubtitles(id, option)
	if option ~= menu.curDropDownOption[id] then
		menu.curDropDownOption[id] = option
		SetSubtitleOption(option)
	end
end

function menu.callbackGameUIScale(value)
	if value then
		menu.newUIScale = Helper.round(value, 1)
	end
end

function menu.callbackGameStartmenuBackgroundConfirm()
	table.insert(menu.history, 1, { optionParameter = menu.currentOption, topRow = GetTopRow(menu.optionTable), selectedOption = "startmenu_background" })
	__CORE_GAMEOPTIONS_RESTORE = true
	__CORE_GAMEOPTIONS_RESTOREINFO.optionParameter = nil
	__CORE_GAMEOPTIONS_RESTOREINFO.history = menu.history
	NewGame("startmenu")
end

function menu.callbackGameUIScaleConfirm()
	if menu.newUIScale ~= Helper.round(C.GetUIScaleFactor(), 1) then
		table.insert(menu.history, 1, { optionParameter = menu.currentOption, topRow = GetTopRow(menu.optionTable), selectedOption = "uiscale" })
		__CORE_GAMEOPTIONS_RESTORE = true
		__CORE_GAMEOPTIONS_RESTOREINFO.optionParameter = nil
		__CORE_GAMEOPTIONS_RESTOREINFO.history = menu.history
		C.SetUIScaleFactor(menu.newUIScale)
		menu.displayInit(ReadText(1001, 409))
	end
end

function menu.callbackGameUIScaleReset()
	local maxUIScale = (Helper.viewWidth <= 1280) and 1.4 or 1.5
	if C.IsRunningOnSteamDeck() then
		maxUIScale = 1.6
	end
	menu.newUIScale = math.max(0.5, math.min(maxUIScale, Helper.round(C.GetUIScaleFactor(), 1)))
	menu.refresh()
end

function menu.callbackDefaults()
	RestoreGraphicOptions()
	RestoreSoundOptions()
	RestoreGameOptions()
	C.RestoreAccessibilityOptions()
	C.RestoreMiscOptions()
	LoadInputProfile("inputmap", false)
	__CORE_GAMEOPTIONS_RESTORE = true
	__CORE_GAMEOPTIONS_RESTOREINFO.optionParameter = nil
	__CORE_GAMEOPTIONS_RESTOREINFO.history = menu.history
end

function menu.callbackGamestartPlayerMacro(customgamestart, propertyid, option)
	C.SetCustomGameStartStringProperty(customgamestart, propertyid, option)
	local name, isfemale = GetMacroData(option, "name", "entityfemale")
	C.SetCustomGameStartStringProperty(customgamestart, "playername", name)
	C.SetCustomGameStartBoolProperty(customgamestart, "playerfemale", isfemale)

	if menu.playNewGameCutscene and menu.playNewGameCutscene.cutsceneid then
		StopCutscene(menu.playNewGameCutscene.cutsceneid)
		C.StopVoiceSequence()
		menu.playNewGameCutscene.cutsceneid = nil
		if menu.playNewGameCutscene.cutscenedesc then
			ReleaseCutsceneDescriptor(menu.playNewGameCutscene.cutscenedesc)
		end
		-- Cutscene will now restart with the right gender variation, see onUpdate()
	end
end

function menu.callbackGfxAA(id, option)
	if option ~= menu.curDropDownOption[id] then
		menu.curDropDownOption[id] = option
		C.SetAAOption(option)

		table.insert(menu.history, 1, { optionParameter = menu.currentOption, topRow = GetTopRow(menu.optionTable), selectedOption = "antialias" })
		__CORE_GAMEOPTIONS_RESTORE = true
		__CORE_GAMEOPTIONS_RESTOREINFO.history = menu.history
		__CORE_GAMEOPTIONS_RESTOREINFO.questionParameter = {
			question = ReadText(1001, 2602),
			callback = "callbackGfxAAConfirm",
			negCallback = "callbackGfxAACancel",
			timer = 15.9,
			waitforgfx = true,
			
		}
		__CORE_GAMEOPTIONS_RESTOREINFO.optionParameter = "question"
	end
end

function menu.callbackGfxAAConfirm()
	C.SaveAAOption()
	menu.userQuestion = nil
	menu.onCloseElement("back")
end

function menu.callbackGfxAACancel()
	C.SetAAOption(ffi.string(C.GetAAOption(true)))
	__CORE_GAMEOPTIONS_RESTORE = true
	__CORE_GAMEOPTIONS_RESTOREINFO.optionParameter = nil
	__CORE_GAMEOPTIONS_RESTOREINFO.history = menu.history
end

function menu.callbackGfxAdaptiveSampling(id, option)
	if option ~= menu.curDropDownOption[id] then
		menu.curDropDownOption[id] = option
		C.SetAdaptiveSamplingOption(tonumber(option))
	end
end

function menu.callbackGfxAdapter(id, option)
	if option ~= menu.curDropDownOption[id] then
		menu.curDropDownOption[id] = option
		SetAdapterOption(option)

		table.insert(menu.history, 1, { optionParameter = menu.currentOption, topRow = GetTopRow(menu.optionTable), selectedOption = "adapter" })
		__CORE_GAMEOPTIONS_RESTORE = true
		__CORE_GAMEOPTIONS_RESTOREINFO.optionParameter = nil
		__CORE_GAMEOPTIONS_RESTOREINFO.history = menu.history
	end
end

function menu.callbackGfxAutoGPU()
	if C.IsGPUAutomaticallySelected() then
		C.RequestGPU(C.GetRequestedGPU())
	else
		C.RequestGPUAutomaticallySelected()
	end
	menu.refresh()
end

function menu.callbackGfxCaptureHQ()
	SetCaptureHQOption()
end

function menu.callbackGfxChromaticAberration()
	C.SetChromaticAberrationOption(not C.GetChromaticAberrationOption())
end

function menu.callbackGfxDefaults()
	RestoreGraphicOptions()
	__CORE_GAMEOPTIONS_RESTORE = true
	__CORE_GAMEOPTIONS_RESTOREINFO.optionParameter = nil
	__CORE_GAMEOPTIONS_RESTOREINFO.history = menu.history
	menu.onCloseElement("back")
end

function menu.callbackGfxDistortion()
	SetDistortionOption()
end

function menu.callbackGfxEffectDistance(value)
	if value then
		SetEffectDistanceOption(Helper.round(value / 100, 2))
	end
end

function menu.callbackGfxEnvMapProbes(id, option)
	if option ~= menu.curDropDownOption[id] then
		menu.curDropDownOption[id] = option
		C.SetEnvMapProbeOption(option)
	end
end

function menu.callbackGfxEnvMapProbesInsideGlassFade(value)
	if value then
		C.SetEnvMapProbeInsideGlassFadeOption(value / 100)
	end
end

function menu.callbackGfxFullscreen(id, option)
	if option ~= menu.curDropDownOption[id] then
		local fullscreen, borderless = GetFullscreenOption()
		__CORE_GAMEOPTIONS_RESTOREINFO.oldfullscreen = fullscreen
		__CORE_GAMEOPTIONS_RESTOREINFO.oldborderless = borderless

		SetFullscreenOption(tonumber(option))

		table.insert(menu.history, 1, { optionParameter = menu.currentOption, topRow = GetTopRow(menu.optionTable), selectedOption = "fullscreen" })
		if C.IsVRMode() then
			menu.displayUserQuestion(ReadText(1001, 2602), menu.callbackGfxFullscreenConfirm, menu.callbackGfxFullscreenCancel, 15.9, true)
		else
			__CORE_GAMEOPTIONS_RESTORE = true
			__CORE_GAMEOPTIONS_RESTOREINFO.history = menu.history
			__CORE_GAMEOPTIONS_RESTOREINFO.questionParameter = {
				question = ReadText(1001, 2602),
				callback = "callbackGfxFullscreenConfirm",
				negCallback = "callbackGfxFullscreenCancel",
				timer = 15.9,
				waitforgfx = true,
			}
			__CORE_GAMEOPTIONS_RESTOREINFO.optionParameter = "question"
		end
	end
end

function menu.callbackGfxFullscreenConfirm()
	SaveFullscreenOption()
	menu.userQuestion = nil
	menu.onCloseElement("back")
end

function menu.callbackGfxFullscreenCancel()
	local setting
	if __CORE_GAMEOPTIONS_RESTOREINFO.oldfullscreen then
		setting = 1
	else
		if __CORE_GAMEOPTIONS_RESTOREINFO.oldborderless then
			setting = 3
		else
			setting = 2
		end
	end
	SetFullscreenOption(setting)
	__CORE_GAMEOPTIONS_RESTORE = true
	__CORE_GAMEOPTIONS_RESTOREINFO.optionParameter = nil
	__CORE_GAMEOPTIONS_RESTOREINFO.history = menu.history
end

function menu.callbackGfxGamma(value)
	if value then
		SetGammaOption(value / 100)
	end
end

function menu.callbackGfxGlow(id, option)
	if option ~= menu.curDropDownOption[id] then
		menu.curDropDownOption[id] = option
		SetGlowOption(tonumber(option) - 1)
	end
end

function menu.callbackGfxGPU(id, option)
	if option ~= menu.curDropDownOption[id] then
		menu.curDropDownOption[id] = option
		C.RequestGPU(tonumber(option))
		menu.refresh()
	end
end

function menu.callbackGfxLOD(value)
	if value then
		SetLODOption(Helper.round(value / 100, 2))
	end
end

function menu.callbackGfxLUT(id, option)
	if option ~= menu.curDropDownOption[id] then
		menu.curDropDownOption[id] = option
		C.SetLUTMode(tonumber(option))
	end
end

function menu.callbackGfxPOM(id, option)
	if option ~= menu.curDropDownOption[id] then
		menu.curDropDownOption[id] = option
		C.SetPOMOption(option)
	end
end

function menu.callbackGfxPreset(id, option)
	if option ~= menu.curDropDownOption[id] then
		SetGfxQualityOption(tonumber(option) - 1)
		menu.delayedRefresh = getElapsedTime() + 0.1
	end
end

function menu.callbackGfxRadar(id, option)
	if option ~= menu.curDropDownOption[id] then
		menu.curDropDownOption[id] = option
		SetRadarOption(tonumber(option) - 1)
	end
end

function menu.callbackGfxResolution(id, option)
	if option ~= menu.curDropDownOption[id] then
		local width, height = string.match(option, "(%d*):(%d*)")
		SetResolutionOption(tonumber(width), tonumber(height))

		table.insert(menu.history, 1, { optionParameter = menu.currentOption, topRow = GetTopRow(menu.optionTable), selectedOption = "resolution" })
		if C.IsVRMode() then
			menu.displayUserQuestion(ReadText(1001, 2602), menu.callbackGfxResolutionConfirm, menu.callbackGfxResolutionCancel, 15.9, true)
		else
			__CORE_GAMEOPTIONS_RESTORE = true
			__CORE_GAMEOPTIONS_RESTOREINFO.history = menu.history
			__CORE_GAMEOPTIONS_RESTOREINFO.questionParameter = {
				question = ReadText(1001, 2602),
				callback = "callbackGfxResolutionConfirm",
				negCallback = "callbackGfxResolutionCancel",
				timer = 15.9,
				waitforgfx = true,
			}
			__CORE_GAMEOPTIONS_RESTOREINFO.optionParameter = "question"
		end
	end
end

function menu.callbackGfxResolutionConfirm()
	SaveResolutionOption()
	menu.userQuestion = nil
	menu.onCloseElement("back")
end

function menu.callbackGfxResolutionCancel()
	local oldresolution = GetResolutionOption(true)
	SetResolutionOption(oldresolution.width, oldresolution.height)
	__CORE_GAMEOPTIONS_RESTORE = true
	__CORE_GAMEOPTIONS_RESTOREINFO.optionParameter = nil
	__CORE_GAMEOPTIONS_RESTOREINFO.history = menu.history
end

function menu.callbackGfxScreenDisplay()
	C.ToggleScreenDisplayOption()
end

function menu.callbackGfxShaderQuality(id, option)
	if option ~= menu.curDropDownOption[id] then
		menu.curDropDownOption[id] = option
		SetShaderQualityOption(tonumber(option) - 1)
	end
end

function menu.callbackGfxShadows(id, option)
	if option ~= menu.curDropDownOption[id] then
		menu.curDropDownOption[id] = option
		SetShadowOption(tonumber(option))
	end
end

function menu.callbackGfxSoftShadows()
	SetSoftShadowsOption()
end

function menu.callbackGfxSSAO(id, option)
	if option ~= menu.curDropDownOption[id] then
		menu.curDropDownOption[id] = option
		SetSSAOOption(tonumber(option) - 1)
	end
end

function menu.callbackGfxSSR(id, option)
	if option ~= menu.curDropDownOption[id] then
		menu.curDropDownOption[id] = option
		C.SetSSROption2(option)
	end
end

function menu.callbackGfxPresentMode(id, option)
	if option ~= menu.curDropDownOption[id] then
		menu.curDropDownOption[id] = option
		C.SetPresentModeOption(option)
	end
end

function menu.callbackGfxTexture(id, option)
	if option ~= menu.curDropDownOption[id] then
		menu.curDropDownOption[id] = option
		C.SetTextureQualityOption(option)
	end
end

function menu.callbackGfxUpscaling(id, option)
	if option ~= menu.curDropDownOption[id] then
		menu.curDropDownOption[id] = option
		C.SetUpscalingOption(option)

		table.insert(menu.history, 1, { optionParameter = menu.currentOption, topRow = GetTopRow(menu.optionTable), selectedOption = "upscaling" })
		__CORE_GAMEOPTIONS_RESTORE = true
		__CORE_GAMEOPTIONS_RESTOREINFO.history = menu.history
		__CORE_GAMEOPTIONS_RESTOREINFO.questionParameter = {
			question = ReadText(1001, 2602),
			callback = "callbackGfxUpscalingConfirm",
			negCallback = "callbackGfxUpscalingCancel",
			timer = 15.9,
			waitforgfx = true,
			
		}
		__CORE_GAMEOPTIONS_RESTOREINFO.optionParameter = "question"
	end
end

function menu.callbackGfxUpscalingConfirm()
	C.SaveUpscalingOption()
	menu.userQuestion = nil
	menu.onCloseElement("back")
end

function menu.callbackGfxUpscalingCancel()
	local upmode = ffi.string(C.GetUpscalingOption(true))
	if upmode == "" then
		upmode = "none"
	end
	C.SetUpscalingOption(upmode)
	__CORE_GAMEOPTIONS_RESTORE = true
	__CORE_GAMEOPTIONS_RESTOREINFO.optionParameter = nil
	__CORE_GAMEOPTIONS_RESTOREINFO.history = menu.history
end

function menu.callbackGfxVolumetric(id, option)
	if option ~= menu.curDropDownOption[id] then
		menu.curDropDownOption[id] = option
		C.SetVolumetricFogOption(tonumber(option) - 1)
	end
end

function menu.callbackInputGamepadMode(id, option)
	if option ~= menu.curDropDownOption[id] then
		menu.curDropDownOption[id] = option
		SetGamepadModeOption(tonumber(option) - 1)
	end
end

function menu.callbackInputInvert(rangeid, configname)
	SetInversionSetting(rangeid, configname)
end

function menu.callbackInputJoystickBidirectionalThrottle()
	C.SetThrottleBidirectional(not C.IsThrottleBidirectional())
end

function menu.callbackInputJoystickDeadzone(value)
	if value then
		SetDeadzoneOption(value)
	end
end

function menu.callbackInputJoystickSteeringAdaptive()
	C.SetJoystickSteeringAdapative(not C.IsJoystickSteeringAdapative())
end

function menu.callbackInputMouseCapture()
	SetConfineMouseOption()
end

function menu.callbackInputMouseHUDMode(id, option)
	if option ~= menu.curDropDownOption[id] then
		menu.curDropDownOption[id] = option
		C.SetMouseHUDModeOption(tonumber(option))
	end
end

function menu.callbackInputMouseSteeringAdaptive()
	C.SetMouseSteeringAdapative(not C.IsMouseSteeringAdapative())
end

function menu.callbackInputMouseSteeringPersistent()
	C.SetMouseSteeringPersistent(not C.IsMouseSteeringPersistent())
end

function menu.callbackInputMouseSteeringLine()
	C.SetMouseSteeringLine(not C.IsMouseSteeringLineEnabled())
end

function menu.callbackInputMouseSteeringInvert(configname)
	C.SetMouseSteeringInvertedOption(configname, not C.GetMouseSteeringInvertedOption(configname))
end

function menu.callbackInputProfileLoad(profile)
	LoadInputProfile(profile.filename, profile.personal)
	menu.userQuestion = nil
	menu.onCloseElement("back")
end

function menu.callbackInputProfileSave(profile)
	SaveInputProfile(profile.filename, profile.id, profile.customname)
	menu.userQuestion = nil
	menu.onCloseElement("back")
end

function menu.callbackInputSensitivity(rangeid, configname, value)
	if value then
		SetSensitivitySetting(rangeid, configname, Helper.round(value / 100, 2))
	end
end

function menu.callbackInputTobiiAngleFactor(value)
	if value then
		C.SetTobiiAngleFactor(value / 100)
	end
end

function menu.callbackInputTobiiGazeAngleFactor(value)
	if value then
		C.SetTobiiGazeAngleFactor(value / 100)
	end
end

function menu.callbackInputTobiiGazeFilterStrength(value)
	if value then
		C.SetTobiiGazeFilterStrength(value)
	end
end

function menu.callbackInputTobiiHeadFilterStrength(value)
	if value then
		C.SetTobiiHeadFilterStrength(value)
	end
end

function menu.callbackInputTobiiDeadzoneAngle(value)
	if value then
		C.SetTobiiDeadzoneAngle(value)
	end
end

function menu.callbackInputTobiiGazeDeadzone(value)
	if value then
		C.SetTobiiGazeDeadzone(value / 100)
	end
end

function menu.callbackInputTobiiDeadzonePosition(value)
	if value then
		C.SetTobiiDeadzonePosition(value)
	end
end

function menu.callbackInputTobiiMode(id, option)
	if option ~= menu.curDropDownOption[id] then
		menu.curDropDownOption[id] = option
		C.SetTobiiMode(option)
		menu.refresh()
	end
end

function menu.callbackInputTobiiPositionFactor(value)
	if value then
		C.SetTobiiHeadPositionFactor(value / 100)
	end
end

function menu.callbackInputVivePointingDevice(id, option)
	if option ~= menu.curDropDownOption[id] then
		menu.curDropDownOption[id] = option
		C.SetVRVivePointerHand(tonumber(option) - 1)
	end
end

function menu.callbackJoystick(slot, guid)
	SetJoysticksOption(slot, guid)
	menu.refresh()
end

function menu.callbackOnlineAllowInvites()
	local _, _, areinvitationsallowed = OnlineGetUserName()
	OnlineUserAllowInvites(not areinvitationsallowed)
end

function menu.callbackOnlineAllowPrivateMessages()
	OnlineUserAllowPrivateMessages(not OnlineUserArePrivateMessagesAllowed())
end

function menu.callbackOnlineOperationUpdates(id, option)
	if option ~= menu.curDropDownOption[id] then
		menu.curDropDownOption[id] = option
		--C.SetVRVivePointerHand(option) -- TODO onlineUI
	end
end

function menu.callbackOnlinePreferredLanguage(id, option)
	if option ~= menu.curDropDownOption[id] then
		menu.curDropDownOption[id] = option
		OnlineSetUserLanguage(tonumber(option))
	end
end

function menu.callbackOnlinePromotion(id, option)
	if option ~= menu.curDropDownOption[id] then
		menu.curDropDownOption[id] = option
		--C.SetVRVivePointerHand(option) -- TODO onlineUI
	end
end

function menu.callbackOnlineSeasonUpdates(id, option)
	if option ~= menu.curDropDownOption[id] then
		menu.curDropDownOption[id] = option
		--C.SetVRVivePointerHand(option) -- TODO onlineUI
	end
end

function menu.callbackOnlineSeasonSummary(id, option)
	if option ~= menu.curDropDownOption[id] then
		menu.curDropDownOption[id] = option
		--C.SetVRVivePointerHand(option) -- TODO onlineUI
	end
end

function menu.callbackOnlineVisitorNames()
	C.SetVisitorNamesShownOption(not C.GetVisitorNamesShownOption())
end

function menu.callbackPrivacyCrash()
	SetCrashReportOption()
end

function menu.callbackPrivacyUserID()
	SetPersonalizedCrashReportsOption()
end

function menu.callbackSave(savegame, name)
	if savegame.empty then
		--  don't save the default name, so on next save to this slot it gets updated
		if name == menu.getNewSavegameName(savegame) then
			name = "#" .. savegame.empty
		end
		SaveGame("save_" .. savegame.empty, name)

		-- kuertee start: callback
		if callbacks ["callbackSave_onSaveGame"] then
			for _, callback in ipairs (callbacks ["callbackSave_onSaveGame"]) do
				callback(savegame, name)
			end
		end
		-- kuertee end: callback

	else
		--  don't save the default name, so on next save to this slot it gets updated
		if type(savegame.name) == "string" then
			local find_start, find_end = string.find(savegame.name, "#[0-9][0-9][0-9]")
			if (find_start == 1) and (find_end == #savegame.name) and (name == menu.getNewSavegameName(savegame)) then
				name = savegame.name
			end
		else
			DebugError("Savegame name was not a string! See earlier output. [Florian]")
		end
		if savegame.isonline then
			SaveOnlineGame()
		else
			SaveGame(savegame.filename, name)

			-- kuertee start: callback
			if callbacks ["callbackSave_onSaveGame"] then
				for _, callback in ipairs (callbacks ["callbackSave_onSaveGame"]) do
					callback(savegame, name)
				end
			end
			-- kuertee end: callback

		end
	end
	menu.closeMenu("close")
end

function menu.callbackSfxDefaults()
	RestoreSoundOptions()
	menu.onCloseElement("back")
	menu.delayedRefresh = getElapsedTime() + 0.1
end

function menu.callbackSfxDevice(id, option)
	menu.curDropDownOption[id] = option
	if option == "default" then
		option = ""
	end
	C.RequestSoundDeviceSwitch(option)
	menu.delayedRefresh = getElapsedTime() + 0.1
end

function menu.callbackSfxSetting(sfxtype, value)
	if value then
		SetVolumeOption(sfxtype, Helper.round(value / 100, 2))
	end
end

function menu.callbackSfxSound()
	SetSoundOption()
	menu.refresh()
end


--- menus ---

function menu.displayOptions(optionParameter)
	-- remove old data
	Helper.clearDataForRefresh(menu, config.optionsLayer)
	menu.selectedOption = nil

	menu.currentOption = optionParameter
	local options = config.optionDefinitions[optionParameter]

	local frame = menu.createOptionsFrame()

	local ftable = frame:addTable(5, { tabOrder = 1, x = menu.table.x, y = menu.table.y, width = menu.table.width, maxVisibleHeight = menu.table.height })
	ftable:setColWidth(1, menu.table.arrowColumnWidth, false)
	ftable:setColWidth(3, menu.table.infoColumnWidth / 2, false)
	ftable:setColWidth(4, menu.table.infoColumnWidth / 2 - Helper.scaleY(config.infoTextHeight) - Helper.borderSize, false)
	ftable:setColWidth(5, Helper.scaleY(config.infoTextHeight), false)
	ftable:setDefaultColSpan(3, 3)
	ftable:setDefaultCellProperties("button", { height = config.standardTextHeight })
	ftable:setDefaultComplexCellProperties("button", "text", { x = config.standardTextOffsetX, fontsize = config.standardFontSize })
	ftable:setDefaultCellProperties("dropdown", { height = config.standardTextHeight })
	ftable:setDefaultComplexCellProperties("dropdown", "text", { x = config.standardTextOffsetX, fontsize = config.standardFontSize })
	ftable:setDefaultCellProperties("slidercell", { height = config.standardTextHeight })
	ftable:setDefaultComplexCellProperties("slidercell", "text", { x = config.standardTextOffsetX, fontsize = config.standardFontSize })

	-- title
	local row = ftable:addRow(menu.currentOption ~= "main", { fixed = true, bgColor = Helper.color.transparent })
	row[1]:setBackgroundColSpan(5)
	local colOffset = 1
	if menu.currentOption ~= "main" then
		row[1]:createButton({ height = config.headerTextHeight }):setIcon(config.backarrow, { x = config.backarrowOffsetX })
		row[1].handlers.onClick = function () return menu.onCloseElement("back") end
		colOffset = 0
	end
	if options.info then
		row[2 - colOffset]:setColSpan(2 + colOffset):createText(options.name, config.headerTextProperties)
		row[4]:setColSpan(2):createText(options.info, config.infoTextProperties)
	else
		row[2 - colOffset]:setColSpan(4 + colOffset):createText(options.name, config.headerTextProperties)
	end

	-- warning
	if options.warning then
		local warning, warningFont = options.warning()
		local row = ftable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
		row[1]:setColSpan(5):createText(function () local text = options.warning() return text end, config.warningTextProperties)
		if warningFont then
			row[1].properties.font = warningFont
		end
	end

	-- options
	for optionIdx, option in ipairs(options) do
		menu.displayOption(ftable, option)
	end

	ftable:setTopRow(menu.preselectTopRow)
	menu.preselectTopRow = nil
	menu.preselectOption = nil

	frame:display()
end

function menu.displayOptionsInfo(optionParameter)
	-- remove old data
	Helper.clearDataForRefresh(menu, config.optionsLayer)
	menu.selectedOption = nil

	menu.currentOption = optionParameter
	local options = config.optionDefinitions[optionParameter]

	local frame = menu.createOptionsFrame()

	local titletable = frame:addTable(4, { tabOrder = 2, x = menu.table.x, y = menu.table.y, width = menu.table.width, skipTabChange = true })
	titletable:setColWidth(1, menu.table.arrowColumnWidth, false)
	titletable:setColWidth(3, menu.table.infoColumnWidth / 2, false)
	titletable:setColWidth(4, menu.table.infoColumnWidth / 2, false)
	titletable:setDefaultColSpan(3, 2)

	-- title
	local row = titletable:addRow({}, { fixed = true, bgColor = Helper.color.transparent })
	row[1]:setBackgroundColSpan(4)
	row[1]:createButton({ height = config.headerTextHeight }):setIcon(config.backarrow, { x = config.backarrowOffsetX })
	row[1].handlers.onClick = function () return menu.onCloseElement("back") end

	if options.info then
		row[2]:setColSpan(2):createText(options.name, config.headerTextProperties)
		row[4]:createText(options.info, config.infoTextProperties)
	else
		row[2]:setColSpan(3):createText(options.name, config.headerTextProperties)
	end

	-- warning
	if options.warning then
		local warning, warningFont = options.warning()
		local row = titletable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
		row[1]:setColSpan(3):createText(function () local text = options.warning() return text end, config.warningTextProperties)
		if warningFont then
			row[1].properties.font = warningFont
		end
	end

	local offsety = titletable.properties.y + titletable:getVisibleHeight() + Helper.borderSize
	local height = menu.table.height - (titletable:getVisibleHeight() + Helper.borderSize)

	local optiontable = frame:addTable(5, { tabOrder = 1, x = menu.table.x, y = offsety, width = menu.table.widthWithExtraInfo, maxVisibleHeight = height })
	optiontable:setColWidth(1, menu.table.arrowColumnWidth, false)
	optiontable:setColWidthPercent(3, 10)
	optiontable:setColWidth(4, 0.1 * menu.table.widthWithExtraInfo - Helper.scaleY(config.infoTextHeight) - Helper.borderSize, false)
	optiontable:setColWidth(5, Helper.scaleY(config.infoTextHeight), false)
	optiontable:setDefaultColSpan(3, 3)
	optiontable:setDefaultCellProperties("button", { height = config.standardTextHeight })
	optiontable:setDefaultComplexCellProperties("button", "text", { x = config.standardTextOffsetX, fontsize = config.standardFontSize })
	optiontable:setDefaultCellProperties("dropdown", { height = config.standardTextHeight })
	optiontable:setDefaultComplexCellProperties("dropdown", "text", { x = config.standardTextOffsetX, fontsize = config.standardFontSize })
	optiontable:setDefaultCellProperties("slidercell", { height = config.standardTextHeight })
	optiontable:setDefaultComplexCellProperties("slidercell", "text", { x = config.standardTextOffsetX, fontsize = config.standardFontSize })

	-- options
	for _, option in ipairs(options) do
		menu.displayOption(optiontable, option)
	end

	optiontable:setTopRow(menu.preselectTopRow)
	menu.preselectTopRow = nil
	menu.preselectOption = nil

	local width = menu.table.width - menu.table.widthWithExtraInfo - Helper.borderSize
	local offsetx = menu.table.x + menu.table.widthWithExtraInfo + Helper.borderSize
	local infotable = frame:addTable(1, { tabOrder = 0, x = offsetx, y = offsety, width = width, maxVisibleHeight = height })

	local row = infotable:addRow(false, { bgColor = Helper.color.transparent60 })
	row[1]:createText(menu.infoHandler, { scaling = false, width = width, height = height, wordwrap = true, fontsize = Helper.scaleFont(config.font, config.infoFontSize) })

	titletable.properties.nextTable = optiontable.index
	optiontable.properties.prevTable = titletable.index

	frame:display()
end

function menu.displayNewGame(createAsServer)
	-- remove old data
	Helper.clearDataForRefresh(menu, config.optionsLayer)
	menu.selectedOption = nil

	menu.currentOption = createAsServer and "multiplayer_server" or "new"
	local gamemodules = GetRegisteredModules()
	local groups = {}
	for _, module in ipairs(gamemodules) do
		if (not module.unlockhidden) or module.unlocked then
			if not menu.selectedOption then
				menu.selectedOption = module
			end
			if module.id == menu.preselectOption then
				menu.selectedOption = module
			end
			local index
			for i, group in ipairs(groups) do
				if group.group == module.group then
					index = i
					break
				end
			end

			if index then
				table.insert(groups[index], module)
			else
				table.insert(groups, { group = module.group, [1] = module })
			end
		end
	end

	local gamestartgroups = {}
	local n = C.GetNumGameStartGroups()
	local buf = ffi.new("GameStartGroupInfo[?]", n)
	n = C.GetGameStartGroups(buf, n)
	for i = 0, n - 1 do
		gamestartgroups[buf[i].id] = ffi.string(buf[i].name)
	end

	local frame = menu.createOptionsFrame()

	local titletable = frame:addTable(2, { tabOrder = 2, x = menu.table.x, y = menu.table.y, width = menu.table.width, skipTabChange = true })
	titletable:setColWidth(1, menu.table.arrowColumnWidth, false)

	-- title
	local row = titletable:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
	row[1]:setBackgroundColSpan(2)
	row[1]:createButton({ height = config.headerTextHeight }):setIcon(config.backarrow, { x = config.backarrowOffsetX })
	row[1].handlers.onClick = function () return menu.onCloseElement("back") end
	row[2]:createText(ReadText(1001, 2603), config.headerTextProperties)

	local row = titletable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
	row[2]:createText(ReadText(1001, 11718), config.warningTextProperties)

	local offsety = titletable.properties.y + titletable:getVisibleHeight() + Helper.borderSize
	local height = math.min(Helper.viewHeight - offsety - Helper.frameBorder, menu.table.height - offsety)

	local optiontable = frame:addTable(2, { tabOrder = 1, x = menu.table.x, y = offsety, width = menu.table.widthWithExtraInfo, maxVisibleHeight = height })
	optiontable:setColWidth(1, menu.table.arrowColumnWidth, false)

	local showunavailable = not (C.IsDemoVersion() and C.IsAppStoreVersion())
	for i, group in ipairs(groups) do
		if gamestartgroups[group.group] then
			optiontable:addEmptyRow(config.subHeaderTextHeight / 4)
			local row = optiontable:addRow(false, { bgColor = Helper.color.transparent })
			row[2]:createText(gamestartgroups[group.group], config.subHeaderTextProperties)
		elseif i ~= 1 then
			local row = optiontable:addRow(false, { bgColor = Helper.color.transparent })
			row[2]:createText(" ", { fontsize = 1, height = Helper.borderSize, cellBGColor = Helper.color.transparent60 })
		end
		for _, module in ipairs(group) do
			if module.available or showunavailable then
				local row = optiontable:addRow(module, { bgColor = Helper.color.transparent })
				if module.id == menu.preselectOption then
					optiontable:setSelectedRow(row.index)
				end

				local name = module.name
				if (module.extensionid ~= "") and (not C.HasExtension(module.extensionid, module.isextensionpersonal)) then
					name = name .. " \27[mm_externallink]"
				end
				local available = module.available or (module.extensionid ~= "")
				local mouseovertext
				if C.IsGameModified() then
					if module.budget then
						available = false
						mouseovertext = ReadText(1026, 9916)
					end
				end
				if C.IsGameOver() and module.customeditor then
					available = false
					mouseovertext = ReadText(1026, 2666)
				end
				row[2]:createText(name, available and module.unlocked and config.standardTextProperties or config.disabledTextProperties)
				if mouseovertext then
					row[2].properties.mouseOverText = mouseovertext
				end
			end
		end
	end

	optiontable:setTopRow(menu.preselectTopRow)
	menu.preselectTopRow = nil
	menu.preselectOption = nil

	local width = menu.table.width - menu.table.widthWithExtraInfo - Helper.borderSize
	local offsetx = menu.table.x + menu.table.widthWithExtraInfo + Helper.borderSize
	local iconheight = math.floor(width * 9 / 16)
	local infoheight = height

	local showCutscene = menu.playNewGameCutscene and menu.playNewGameCutscene.movie
	if showCutscene then
		if not menu.cutsceneStoppedNotification then
			menu.cutsceneStoppedNotification = true
			NotifyOnCutsceneStopped(getElement("Scene.UIContract"))
		end

		local rendertarget = frame:addRenderTarget({ width = width, height = iconheight, x = offsetx, y = offsety, alpha = 100 })
		offsety = offsety + iconheight + Helper.borderSize
		infoheight = infoheight - iconheight - Helper.borderSize
	end

	local numlines = 7
	local baseMaxVisibleHeight = Helper.scaleY(Helper.standardButtonHeight) + Helper.borderSize
	if not showCutscene then
		baseMaxVisibleHeight = baseMaxVisibleHeight + iconheight + Helper.borderSize
	end
	local maxVisibleHeight = baseMaxVisibleHeight + numlines * Helper.scaleY(config.infoTextHeight)

	local infotable = frame:addTable(1, { tabOrder = 3, x = offsetx, y = offsety, width = width, maxVisibleHeight = maxVisibleHeight, highlightMode = "off" })

	if not showCutscene then
		local row = infotable:addRow(false, { bgColor = Helper.color.black, fixed = true })
		row[1]:createIcon(menu.iconNewGame, { scaling = false, width = width, height = iconheight })
	end

	local hasdescription = false
	if menu.selectedOption then
		local row = infotable:addRow(true, { bgColor = Helper.color.transparent60, fixed = true })
		if menu.selectedOption.requirement ~= "" then
			local canopenstore = (menu.selectedOption.extensionid ~= "") and (not C.HasExtension(menu.selectedOption.extensionid, menu.selectedOption.isextensionpersonal)) and (IsSteamworksEnabled() or (C.IsGOGVersion() and C.CanOpenWebBrowser()))
			if canopenstore then
				local iconsize = Helper.scaleY(Helper.standardButtonHeight)
				row[1]:createButton({ bgColor = Helper.color.red, highlightColor = canopenstore and Helper.defaultButtonHighlightColor or Helper.color.transparent }):setText(menu.selectedOption.requirement, { x = config.infoTextOffsetX, font = config.fontBold }):setIcon("mm_externallink", { scaling = false, x = width - iconsize, height = iconsize, width = iconsize })
				local storeicon = ""
				if IsSteamworksEnabled() then
					storeicon = "optionsmenu_steam"
				elseif C.IsGOGVersion() then
					storeicon = "optionsmenu_gog"
				end
				if storeicon ~= "" then
					row[1]:setIcon2(storeicon, { scaling = false, x = width - 2 * iconsize - Helper.borderSize, height = iconsize, width = iconsize })
				end
				row[1].handlers.onClick = function () return menu.buttonOpenStore(menu.selectedOption.extensionsource) end
			else
				row[1]:createText(menu.selectedOption.requirement, { x = config.infoTextOffsetX, y = (Helper.standardButtonHeight - Helper.standardTextHeight) / 2, font = config.fontBold, cellBGColor = Helper.color.red, minRowHeight = Helper.standardButtonHeight })
			end
		else
			row[1]:createText(ReadText(1001, 11732) .. ReadText(1001, 120) .. " " .. menu.selectedOption.typename, { mouseOverText = menu.selectedOption.typedescription, x = config.infoTextOffsetX, y = (Helper.standardButtonHeight - Helper.standardTextHeight) / 2, font = config.fontBold, cellBGColor = Helper.color.black, minRowHeight = Helper.standardButtonHeight })
		end

		local text = menu.selectedOption.description
		local descriptiontext = GetTextLines(text, config.font, Helper.scaleFont(config.font, config.infoFontSize), width - 2 * Helper.scaleX(config.infoTextOffsetX))
		if #descriptiontext > numlines then
			-- scrollbar case
			descriptiontext = GetTextLines(text, config.font, Helper.scaleFont(config.font, config.infoFontSize), width - 2 * Helper.scaleX(config.infoTextOffsetX) - Helper.scrollbarWidth)
		end

		-- now that we know the actual text height, update the maxVisibleHeight so that numlines lines will fit
		if #descriptiontext > 0 then
			local descriptiontextheight = math.ceil(C.GetTextHeight(descriptiontext[1], config.font, config.infoFontSize, 0))
			infotable.properties.maxVisibleHeight = baseMaxVisibleHeight + numlines * descriptiontextheight
			for linenum, descline in ipairs(descriptiontext) do
				local row = infotable:addRow(true, { bgColor = Helper.color.transparent60, borderBelow = false })
				row[1]:createText(descline)

				hasdescription = true
			end
		end
	end
	local fullheight = infotable:getFullHeight() + (hasdescription and 0 or Helper.borderSize) -- if there is no description, the border between icon row and the new empty row has to be accounted for
	if fullheight < infotable.properties.maxVisibleHeight then
		local row = infotable:addRow(nil, { bgColor = Helper.color.transparent60, borderBelow = false })
		row[1]:createText("", { scaling = false, minRowHeight = infotable.properties.maxVisibleHeight - fullheight, fontsize = 1 })
	end

	local infotable2 = frame:addTable(3, { tabOrder = 4, x = offsetx, y = infotable.properties.y + infotable.properties.maxVisibleHeight + Helper.borderSize, width = width, maxVisibleHeight = infoheight - infotable.properties.maxVisibleHeight - Helper.borderSize })
	infotable2:setColWidthPercent(2, 15)
	infotable2:setColWidthPercent(3, 50)
	infotable2:setDefaultColSpan(2, 2)
	infotable2:setDefaultBackgroundColSpan(1, 3)

	if menu.selectedOption then
		local row = infotable2:addRow(nil, { bgColor = Helper.color.transparent })
		row[1]:setColSpan(3):createText(" ", { fontsize = 1, height = Helper.borderSize, cellBGColor = Helper.defaultSimpleBackgroundColor })

		if IsCheatVersion() then
			local row = infotable2:addRow(nil, { bgColor = Helper.color.transparent60, borderBelow = false })
			row[1]:createText("Gamestart ID:") -- (cheat only)
			row[2]:createText("\027A" .. menu.selectedOption.id, { halign = "right" })
		end

		local playermacro = ""
		local playermacrooptions = {}
		if menu.selectedOption.custom then
			local buf = ffi.new("CustomGameStartStringPropertyState[1]")
			playermacro = ffi.string(C.GetCustomGameStartStringProperty(menu.selectedOption.id, "player", buf))
			if ffi.string(buf[0].state) == "standard" then
				local macros = {}
				for macro in string.gmatch(ffi.string(buf[0].options), "[%w_]+") do
					local race, racename, female = GetMacroData(macro, "entityrace", "entityracename", "entityfemale", "basemacro")
					table.insert(macros, { macro = macro, race = race, racename = racename, gender = female and "female" or "male" })
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
							playermacrooptions[#playermacrooptions].text = playermacrooptions[#playermacrooptions].text .. " " .. ReadText(20402, 1)
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
					table.insert(playermacrooptions, { id = entry.macro, text = name, icon = "", displayremoveoption = false })
				end
			end
		end

		for i, entry in ipairs(menu.selectedOption.info) do
			local row
			if entry.info == "@name" then
				row = infotable2:addRow(nil, { bgColor = Helper.color.transparent60, borderBelow = false })
				row[1]:createText(ReadText(1021, 8) .. ReadText(1001, 120))
				row[2]:createText(function () local buf = ffi.new("CustomGameStartStringPropertyState[1]"); return "\027A" .. ffi.string(C.GetCustomGameStartStringProperty(menu.selectedOption.id, "playername", buf)) end, { halign = "right" })
			elseif entry.info == "@player" then
				row = infotable2:addRow(true, { bgColor = Helper.color.transparent60, borderBelow = false })
				if #playermacrooptions > 0 then
					row[1]:createText(ReadText(1021, 11007) .. ReadText(1001, 120))
					row[2]:createDropDown(playermacrooptions, { startOption = playermacro, height = Helper.standardTextHeight }):setTextProperties({ halign = "right", x = Helper.standardTextOffsetx })
					row[2].handlers.onDropDownConfirmed = function(_, id) return menu.callbackGamestartPlayerMacro(menu.selectedOption.id, "player", id) end
				else
					row[1]:createText("")
				end
			elseif entry.info == "@unlock" then
				if not menu.selectedOption.unlocked then
					row = infotable2:addRow(nil, { bgColor = Helper.color.transparent60, borderBelow = false })
					row[1]:createText(ReadText(1004, 45) .. ReadText(1001, 120))
					row[2]:createText("\027A" .. entry.description, { halign = "right" })
				end
			elseif entry.info ~= "" then
				row = infotable2:addRow(nil, { bgColor = Helper.color.transparent60, borderBelow = false })
				row[1]:createText(entry.info .. ReadText(1001, 120))
				row[2]:createText("\027A" .. entry.description, { halign = "right" })
			elseif menu.selectedOption.info[i + 1].info ~= "@unlock" or (not menu.selectedOption.unlocked) then
				-- do not show the empty line before @unlock if @unlock is not shown
				row = infotable2:addRow(nil, { bgColor = Helper.color.transparent60, borderBelow = false })
				row[1]:createText("")
			end
		end
	end

	local row = infotable2:addRow(nil, { bgColor = Helper.color.transparent60, borderBelow = false })
	row[1]:createText(" ", { fontsize = 1, minRowHeight = config.standardTextHeight / 2 })
	local row = infotable2:addRow(true, { bgColor = Helper.color.transparent60, fixed = true })
	row[1]:setColSpan(3):createButton({ active = menu.buttonStartGameActive(), height = config.standardTextHeight }):setText(ReadText(1001, 9902), { halign = "center" })
	row[1].handlers.onClick = function () return menu.buttonStartGame(menu.selectedOption) end

	titletable:addConnection(1, 1, true)
	optiontable:addConnection(2, 1)

	infotable:addConnection(1, 2, true)
	infotable2:addConnection(2, 2)

	frame:display()
end

function menu.buttonStartGameActive()
	if menu.selectedOption then
		local available = menu.selectedOption.available or (menu.selectedOption.extensionid ~= "")
		if C.IsGameModified() then
			if menu.selectedOption.budget then
				available = false
			end
		end
		if available and menu.selectedOption.unlocked then
			if (menu.selectedOption.extensionid ~= "") and (not C.HasExtension(menu.selectedOption.extensionid, menu.selectedOption.isextensionpersonal)) then
				return false
			elseif menu.selectedOption.requirement == "" then
				if (not C.IsGameOver()) or (not menu.selectedOption.customeditor) then
					return true
				end
			end
		end
	end
	return false
end

function menu.buttonStartGame(option)
	local available = option.available or (option.extensionid ~= "")
	if C.IsGameModified() then
		if option.budget then
			available = false
		end
	end
	if available and option.unlocked then
		if (option.extensionid ~= "") and (not C.HasExtension(option.extensionid, option.isextensionpersonal)) then
			if IsSteamworksEnabled() then
				OpenSteamOverlayStorePage(option.extensionsource)
			elseif C.IsGOGVersion() then
				if C.CanOpenWebBrowser() then
					C.OpenWebBrowser(option.extensionsource)
				end
			end
		elseif option.requirement == "" then
			if (not C.IsGameOver()) or (not option.customeditor) then
				menu.newGameCallback(option)
			end
		end
	end
end

function menu.displayExtensions()
	-- remove old data
	Helper.clearDataForRefresh(menu, config.optionsLayer)
	menu.selectedOption = nil

	menu.currentOption = "extensions"

	local frame = menu.createOptionsFrame(true)

	local infowidth = menu.table.width - menu.table.widthWithExtraInfo - Helper.borderSize

	local titletable = frame:addTable(2, { tabOrder = 2, x = menu.table.x, y = menu.table.y, width = menu.table.widthExtraWide, skipTabChange = true })
	titletable:setColWidth(1, menu.table.arrowColumnWidth, false)

	-- title
	local row = titletable:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
	row[1]:setBackgroundColSpan(2)
	row[1]:createButton({ height = config.headerTextHeight }):setIcon(config.backarrow, { x = config.backarrowOffsetX })
	row[1].handlers.onClick = function () return menu.onCloseElement("back") end
	row[2]:createText(ReadText(1001, 2697), config.headerTextProperties)

	-- warning
	local row = titletable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
	row[2]:createText(menu.warningExtensions, config.warningTextProperties)

	local offsety = titletable.properties.y + titletable:getVisibleHeight() + Helper.borderSize
	local height = menu.table.height - offsety

	local optiontable = frame:addTable(7, { tabOrder = 1, x = menu.table.x, y = offsety, width = menu.table.widthExtraWide - infowidth - Helper.borderSize, maxVisibleHeight = height })
	optiontable:setColWidth(1, menu.table.arrowColumnWidth, false)
	optiontable:setColWidthPercent(2, 40)
	optiontable:setColWidthPercent(4, 13)
	optiontable:setColWidthPercent(6, 10)
	optiontable:setColWidth(7, menu.table.arrowColumnWidth, false)

	local extensions = GetExtensionList()
	menu.extensionSettings = GetAllExtensionSettings()

	local addline = false
	if IsSteamworksEnabled() then
		addline = true

		local row = optiontable:addRow("globalsync", { bgColor = Helper.color.transparent })
		row[2]:createText(ReadText(1001, 4830), config.standardTextProperties)
		row[6]:createButton({  }):setText(function () local text = menu.valueExtensionGlobalSync() return text end, { fontsize = config.standardFontSize, halign = "center", color = function () local _, color = menu.valueExtensionGlobalSync() return color end })
		row[6].handlers.onClick = menu.buttonExtensionGlobalSync
		
		local row = optiontable:addRow("workshop", { bgColor = Helper.color.transparent })
		row[2]:setColSpan(5):createText(ReadText(1001, 4831), config.standardTextProperties)
	end

	if #extensions > 0 then
		addline = true
		
		local row = optiontable:addRow( "defaults", { bgColor = Helper.color.transparent })
		row[2]:setColSpan(6):createText(ReadText(1001, 2647), config.standardTextProperties)
		if menu.preselectOption == "defaults" then
			optiontable:setSelectedRow(row.index)
		end
	end

	if addline then
		local row = optiontable:addRow(false, { bgColor = Helper.color.transparent })
		row[2]:setColSpan(6):createText(" ", { fontsize = 1, height = Helper.borderSize, cellBGColor = Helper.color.transparent60 })
	end

	row = optiontable:addRow(false, { bgColor = Helper.color.transparent })
	row[2]:createText(ReadText(1001, 8999), config.subHeaderTextProperties)
	row[2].properties.halign = "left"
	row[3]:createText(ReadText(1001, 4823), config.subHeaderTextProperties)
	row[4]:createText(ReadText(1001, 2655), config.subHeaderTextProperties)
	row[5]:createText(ReadText(1001, 2691), config.subHeaderTextProperties)
	if #extensions > 0 then
		table.sort(extensions, Helper.sortName)

		for _, extension in ipairs(extensions) do
			if extension.egosoftextension then
				menu.displayExtensionRow(optiontable, extension, menu.extensionSettings[extension.index])
			end
		end
		row = optiontable:addRow(false, { bgColor = Helper.color.transparent })
		row[2]:setColSpan(6):createText(" ", { fontsize = 1, height = Helper.borderSize, cellBGColor = Helper.color.transparent60 })
		for _, extension in ipairs(extensions) do
			if not extension.egosoftextension then
				menu.displayExtensionRow(optiontable, extension, menu.extensionSettings[extension.index])
			end
		end
	else
		local row = optiontable:addRow(false, { bgColor = Helper.color.transparent })
		row[2]:setColSpan(2):createText(ReadText(1001, 2693), config.disabledTextProperties)
	end

	optiontable:setTopRow(menu.preselectTopRow)
	menu.preselectTopRow = nil
	menu.preselectOption = nil

	local offsetx = menu.table.x + menu.table.widthExtraWide - infowidth
	local infotable = frame:addTable(1, { tabOrder = 0, x = offsetx, y = offsety, width = infowidth, maxVisibleHeight = height })

	local row = infotable:addRow(false, { bgColor = Helper.color.transparent60 })
	row[1]:createText(menu.descriptionExtension, { scaling = false, width = infowidth, height = height, wordwrap = true, fontsize = Helper.scaleFont(config.font, config.infoFontSize) })

	titletable.properties.nextTable = optiontable.index
	optiontable.properties.prevTable = titletable.index

	frame:display()
end

function menu.displayExtensionRow(ftable, extension, extensionSetting)
	local row = ftable:addRow(extension, { bgColor = Helper.color.transparent })
	if extension.id == menu.preselectOption then
		ftable:setSelectedRow(row.index)
	end

	local textcolor = Helper.color.white
	if extension.error and extension.enabled then
		textcolor = Helper.color.red
	elseif extension.warning then
		textcolor = Helper.color.brightyellow

	-- kuertee start: gray disabled extensions
	elseif not extension.enabled then
		textcolor = Helper.color.grey
	-- kuertee end

	end

	row[2]:createText(extension.name, config.standardTextProperties)
	row[2].properties.color = textcolor
	row[3]:createText(extension.id, config.standardTextProperties)
	row[4]:createText(extension.version, config.standardTextProperties)
	row[4].properties.halign = "right"
	row[5]:createText(extension.date, config.standardTextProperties)
	row[5].properties.halign = "right"
	row[6]:createButton({ }):setText(function() return menu.valueExtensionStatus(extension) end, { fontsize = config.standardFontSize, halign = "center", color = function () local _, color = menu.valueExtensionStatus(extension); return color end })
	row[6].handlers.onClick = function () return menu.callbackExtensionSettingEnabled(extension) end
	row[7]:createButton({ }):setText("...", { fontsize = config.standardFontSize, halign = "center" })
	row[7].handlers.onClick = function () menu.selectedExtension = extension; menu.openSubmenu("extensionsettings", extension.id) end
end

function menu.displayBonusContent()
	local owned = false
	local bonuscontent = {}
	if IsSteamworksEnabled() then
		bonuscontent = GetBonusContentData()
		for _, bonus in ipairs(bonuscontent) do
			if bonus.owned then
				owned = true
				break
			end
		end
	end
	if owned then
		-- remove old data
		Helper.clearDataForRefresh(menu, config.optionsLayer)
		menu.selectedOption = nil

		menu.currentOption = "bonus"

		local frame = menu.createOptionsFrame()

		local titletable = frame:addTable(2, { tabOrder = 2, x = menu.table.x, y = menu.table.y, width = menu.table.width, skipTabChange = true })
		titletable:setColWidth(1, menu.table.arrowColumnWidth, false)

		-- title
		local row = titletable:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
		row[1]:setBackgroundColSpan(2)
		row[1]:createButton({ height = config.headerTextHeight }):setIcon(config.backarrow, { x = config.backarrowOffsetX })
		row[1].handlers.onClick = function () return menu.onCloseElement("back") end
		row[2]:createText(ReadText(1001, 4800), config.headerTextProperties)

		local offsety = titletable.properties.y + titletable:getVisibleHeight() + Helper.borderSize
		local height = menu.table.height - (titletable:getVisibleHeight() + Helper.borderSize)

		local optiontable = frame:addTable(3, { tabOrder = 1, x = menu.table.x, y = offsety, width = menu.table.widthWithExtraInfo, maxVisibleHeight = height })
		optiontable:setColWidth(1, menu.table.arrowColumnWidth, false)
		optiontable:setColWidthPercent(3, 20)

		if #bonuscontent > 0 then
			for i, bonus in ipairs(bonuscontent) do
				local row = optiontable:addRow(bonus, { bgColor = Helper.color.transparent })
				if bonus.appid == menu.preselectOption then
					optiontable:setSelectedRow(row.index)
				end

				local status
				if bonus.owned then
					if bonus.installed then
						status = ReadText(1001, 4805)			-- Installed
					else
						status = ReadText(1001, 4808)			-- Not installed
					end
					if bonus.optional and not bonus.changed then
						if bonus.installed then
							status = status .. " - " .. ReadText(1001, 4804)		-- Uninstall
						else
							status = status .. " - " .. ReadText(1001, 4803)		-- Install
						end
					end
				else
					status = ReadText(1001, 4802)				-- View in Store
				end

				row[2]:createText(bonus.name, config.standardTextProperties)
				row[3]:createText(status, config.standardTextProperties)
			end
		else
			local row = ftable:addRow(false, { bgColor = Helper.color.transparent })
			row[2]:setColSpan(2):createText(ReadText(1001, 2693), config.disabledTextProperties)
		end

		optiontable:setTopRow(menu.preselectTopRow)
		menu.preselectTopRow = nil
		menu.preselectOption = nil

		local width = menu.table.width - menu.table.widthWithExtraInfo - Helper.borderSize
		local offsetx = menu.table.x + menu.table.widthWithExtraInfo + Helper.borderSize
		local infotable = frame:addTable(1, { tabOrder = 0, x = offsetx, y = offsety, width = width, maxVisibleHeight = height })

		local row = infotable:addRow(false, { bgColor = Helper.color.transparent60 })
		row[1]:createText(menu.descriptionBonusContent, { scaling = false, width = width, height = height, wordwrap = true, fontsize = Helper.scaleFont(config.font, config.infoFontSize) })

		titletable.properties.nextTable = optiontable.index
		optiontable.properties.prevTable = titletable.index

		frame:display()
	else
		OpenSteamOverlayStorePage()
	end
end

function menu.displaySavegameOptions(optionParameter)
	-- remove old data
	Helper.clearDataForRefresh(menu, config.optionsLayer)
	menu.selectedOption = nil

	menu.currentOption = optionParameter
	local options = config.optionDefinitions[optionParameter]

	while not C.IsSaveListLoadingComplete() do
		-- wait until loading the savegame list is complete
	end
	menu.savegames = GetSaveList(Helper.validSaveFilenames)

	-- kuertee start: callback
	if callbacks ["displaySavegameOptions_onGetSaveGames"] then
		for _, callback in ipairs (callbacks ["displaySavegameOptions_onGetSaveGames"]) do
			callback(optionParameter)
		end
	end
	-- kuertee end: callback

	menu.onlinesave = nil
	for _, save in ipairs(menu.savegames) do
		if save.isonline and (save.filename == "online_save") then
			menu.onlinesave = save
			break
		end
	end
	if next(menu.savegames) then
		table.sort(menu.savegames, function (a, b) return a.rawtime > b.rawtime end)
	end

	local usedsavegamenames = {}
	local autosaves = {}
	local customsaves = {}
	local sortablesaves = {}
	local quicksavegame
	for i, savegame in ipairs(menu.savegames) do
		savegame.displayedname = menu.getExplicitSavegameName(savegame) or savegame.location
		if savegame.filename == "quicksave" then
			savegame.displayedname = ((savegame.description ~= "") and savegame.description or savegame.location) .. " (" .. ReadText(1001, 400) .. ")"
			quicksavegame = i
			if menu.currentOption == "load" then
				table.insert(sortablesaves, savegame)
			end
		elseif string.find(savegame.filename, "autosave_", 1, true) == 1 then
			savegame.displayedname = string.format("%s (%s)", (savegame.description ~= "") and savegame.description or savegame.location, ReadText(1001, 406))
			table.insert(autosaves, savegame)
			if menu.currentOption == "load" then
				table.insert(sortablesaves, savegame)
			end
		elseif savegame.isonlinesavefilename then
			if savegame.isonline then
				if savegame ~= menu.onlinesave then
					-- TODO: Online autosave support
				end
			end
			-- TODO: handle offline savegame on online slot?
		elseif IsCheatVersion() and string.find(savegame.filename, "customsave[_-]", 1) == 1 then
			-- allow loading savegames with custom file names
			table.insert(customsaves, savegame)
		else
			usedsavegamenames[savegame.filename] = i
			table.insert(sortablesaves, savegame)
		end
	end

	local frame = menu.createOptionsFrame(true)

	-- list
	local ftable = frame:addTable(5, { tabOrder = 1, x = menu.table.x, y = 0, width = menu.table.widthExtraWide / 2, maxVisibleHeight = menu.table.height })
	ftable:setColWidth(1, menu.table.arrowColumnWidth, false)
	ftable:setColWidth(2, 2 * Helper.scaleY(config.infoTextHeight), false)
	ftable:setColWidthPercent(4, 25)
	ftable:setColWidth(5, Helper.scaleY(config.infoTextHeight), false)

	local maxRowHeight = 0

	local isonline = Helper.isOnlineGame()
	local showonlinesave = C.IsVentureExtensionSupported() and menu.onlinesave and ((menu.currentOption == "load") or isonline) and (menu.currentOption ~= "saveoffline")

	if showonlinesave then
		local row = ftable:addRow({ titlerow = "reload2" }, { fixed = true, bgColor = Helper.color.transparent })
		if menu.preselectOption == "reload2" then
			ftable:setSelectedRow(row.index)
		end
		row[2]:setColSpan(3):createText(ReadText(1001, 11570), config.subHeaderTextProperties)
		row[5]:createButton({ height = config.infoTextHeight, width = config.infoTextHeight }):setIcon("menu_reload", {  })
		row[5].handlers.onClick = menu.buttonReloadSaveGames

		maxRowHeight = math.max(maxRowHeight, menu.addSavegameRow(ftable, menu.onlinesave, menu.onlinesave.displayedname))

		local row = ftable:addRow(nil, { bgColor = Helper.color.transparent })
		row[2]:setColSpan(3):setBackgroundColSpan(4):createText(ReadText(1001, 11711), config.subHeaderTextProperties)
		row[5]:createText(" ", config.subHeaderTextProperties)
	end

	local nameSortButton
	if isonline and (menu.currentOption == "save") and (not menu.showofflinesaves) then
		local row = ftable:addRow({ submenu = "saveoffline" }, { bgColor = Helper.color.transparent })
		if menu.preselectOption == "saveoffline" then
			ftable:setSelectedRow(row.index)
		end
		row[2]:setColSpan(4):createText(ReadText(1001, 11713), config.standardTextProperties)
	else
		-- reload
		local arrowWidth = Helper.scaleY(config.infoTextHeight)
		local row = ftable:addRow({ titlerow = "reload" }, { fixed = not showonlinesave, bgColor = Helper.color.transparent })
		if menu.preselectOption == "reload" then
			ftable:setSelectedRow(row.index)
		end
		row[2]:createButton({ height = config.infoTextHeight }):setIcon((menu.saveSort == "slot_inv") and "table_arrow_inv_up" or "table_arrow_inv_down", { scaling = false, width = arrowWidth, height = arrowWidth, x = (row[2]:getColSpanWidth() - arrowWidth) / 2, color = ((menu.saveSort == "slot") or (menu.saveSort == "slot_inv")) and Helper.color.white or Helper.color.transparent })
		row[2].handlers.onClick = function () menu.saveSort = (menu.saveSort == "slot") and "slot_inv" or "slot"; menu.refresh() end
		nameSortButton = row[3]:createButton({ height = config.infoTextHeight }):setText(ReadText(1001, 2809)):setIcon((menu.saveSort == "name_inv") and "table_arrow_inv_up" or "table_arrow_inv_down", { scaling = false, width = arrowWidth, height = arrowWidth, x = row[3]:getColSpanWidth() + Helper.scrollbarWidth - arrowWidth, color = ((menu.saveSort == "name") or (menu.saveSort == "name_inv")) and Helper.color.white or Helper.color.transparent })
		row[3].handlers.onClick = function () menu.saveSort = (menu.saveSort == "name") and "name_inv" or "name"; menu.refresh() end
		row[4]:setColSpan(showonlinesave and 2 or 1):createButton({ height = config.infoTextHeight }):setText(ReadText(1001, 2691)):setIcon((menu.saveSort == "date_inv") and "table_arrow_inv_up" or "table_arrow_inv_down", { scaling = false, width = arrowWidth, height = arrowWidth, x = row[4]:getColSpanWidth() - arrowWidth, color = ((menu.saveSort == "date") or (menu.saveSort == "date_inv")) and Helper.color.white or Helper.color.transparent })
		row[4].handlers.onClick = function () menu.saveSort = (menu.saveSort == "date") and "date_inv" or "date"; menu.refresh() end
		if not showonlinesave then
			row[5]:createButton({ height = config.infoTextHeight, width = config.infoTextHeight }):setIcon("menu_reload", {  })
			row[5].handlers.onClick = menu.buttonReloadSaveGames
		end
		maxRowHeight = math.max(maxRowHeight, row:getHeight())

		if (menu.saveSort == "slot") or (menu.saveSort == "slot_inv") then
			if menu.currentOption == "load" then
				if quicksavegame then
					local savegame = menu.savegames[quicksavegame]
					maxRowHeight = math.max(maxRowHeight, menu.addSavegameRow(ftable, savegame, savegame.displayedname))
				end
				if #autosaves > 0 then
					table.sort(autosaves, function (a, b) return a.rawtime > b.rawtime end)
					for i, savegame in ipairs(autosaves) do
						if i <= 3 then
							maxRowHeight = math.max(maxRowHeight, menu.addSavegameRow(ftable, savegame, savegame.displayedname))
						end
					end
				end
			end

			-- kuertee start: more save games
			-- local startIdx = (menu.saveSort == "slot_inv") and 10 or 1
			-- local endIdx = (menu.saveSort == "slot_inv") and 1 or 10
			-- local direction = (menu.saveSort == "slot_inv") and -1 or 1
			local startIdx = (menu.saveSort == "slot_inv") and Helper.maxSaveFiles or 1
			local endIdx = (menu.saveSort == "slot_inv") and 1 or Helper.maxSaveFiles
			local direction = (menu.saveSort == "slot_inv") and -1 or 1
			-- kuertee end: more save games

			for i = startIdx, endIdx, direction do
				local savegamestring = string.format("%03d", i)
				if usedsavegamenames["save_" .. savegamestring] then
					local savegame = menu.savegames[usedsavegamenames["save_" .. savegamestring]]
					maxRowHeight = math.max(maxRowHeight, menu.addSavegameRow(ftable, savegame, savegame.displayedname, i))
				else

					-- kuertee start: callback
					local isShowUnusedSaveFile = true
					if callbacks ["displaySavegameOptions_isShowUnusedSaveGame"] then
						for _, callback in ipairs (callbacks ["displaySavegameOptions_isShowUnusedSaveGame"]) do
							isShowUnusedSaveFile = callback(i)
							if not isShowUnusedSaveFile then
								goto continue
							end
						end
					end
					-- kuertee end: callback

					local row = ftable:addRow({ empty = savegamestring }, { bgColor = Helper.color.transparent })
					if string.format("save_%03d", i) == menu.preselectOption then
						ftable:setSelectedRow(row.index)
						menu.selectedOption = { empty = savegamestring }
					end
					row[2]:createText(i, ((menu.currentOption == "save") or (menu.currentOption == "saveoffline")) and config.standardTextProperties or config.disabledTextProperties)
					row[2].properties.halign = "right"
					row[3]:setColSpan(3):createText(ReadText(1001, 4812), { scaling = false, font = config.font, fontsize = Helper.scaleFont(config.font, config.standardFontSize), x = Helper.scaleX(config.standardTextOffsetX), y = Helper.scaleY(2), color = (menu.currentOption == "load") and Helper.color.grey or nil, minRowHeight = Helper.scaleY(config.standardTextHeight) + Helper.borderSize })
					maxRowHeight = math.max(maxRowHeight, row:getHeight())
				end

				-- kuertee start: callback
				::continue::
				-- kuertee end: callback
			end
		else
			if menu.saveSort == "date" then
				table.sort(sortablesaves, function (a, b) return a.rawtime > b.rawtime end)
			elseif menu.saveSort == "date_inv" then
				table.sort(sortablesaves, function (a, b) return a.rawtime < b.rawtime end)
			elseif menu.saveSort == "name" then
				table.sort(sortablesaves, function (a, b) return a.displayedname < b.displayedname end)
			elseif menu.saveSort == "name_inv" then
				table.sort(sortablesaves, function (a, b) return a.displayedname > b.displayedname end)
			end
			for i, savegame in ipairs(sortablesaves) do
				local idx = tonumber(string.match(savegame.filename, "^save_(%d+)"))
				maxRowHeight = math.max(maxRowHeight, menu.addSavegameRow(ftable, savegame, savegame.displayedname, idx))
			end

			-- kuertee start: more save games
			-- for i = 1, 10 do
			for i = 1, Helper.maxSaveFiles do
			-- kuertee end: more save games

				local savegamestring = string.format("%03d", i)
				if not usedsavegamenames["save_" .. savegamestring] then

					-- kuertee start: callback
					local isShowUnusedSaveFile = true
					if callbacks ["displaySavegameOptions_isShowUnusedSaveGame"] then
						for _, callback in ipairs (callbacks ["displaySavegameOptions_isShowUnusedSaveGame"]) do
							isShowUnusedSaveFile = callback(i)
							if not isShowUnusedSaveFile then
								goto continue
							end
						end
					end
					-- kuertee end: callback

					local row = ftable:addRow({ empty = savegamestring }, { bgColor = Helper.color.transparent })
					if string.format("save_%03d", i) == menu.preselectOption then
						ftable:setSelectedRow(row.index)
						menu.selectedOption = { empty = savegamestring }
					end
					row[2]:createText(i, ((menu.currentOption == "save") or (menu.currentOption == "saveoffline")) and config.standardTextProperties or config.disabledTextProperties)
					row[2].properties.halign = "right"
					row[3]:setColSpan(3):createText(ReadText(1001, 4812), { scaling = false, font = config.font, fontsize = Helper.scaleFont(config.font, config.standardFontSize), x = Helper.scaleX(config.standardTextOffsetX), y = Helper.scaleY(2), color = (menu.currentOption == "load") and Helper.color.grey or nil, minRowHeight = Helper.scaleY(config.standardTextHeight) + Helper.borderSize })
					maxRowHeight = math.max(maxRowHeight, row:getHeight())

					-- kuertee start: callback
					::continue::
					-- kuertee end: callback
				end
			end
		end
	end

	local customsavetitlerow
	if (menu.currentOption == "load") and (#customsaves > 0) and IsCheatVersion() then
		customsavetitlerow = ftable:addRow(nil, { bgColor = Helper.color.transparent })
		customsavetitlerow[2]:setColSpan(4):createText("Custom Saves", config.subHeaderTextProperties) -- (cheat only)
		-- sort by name, but don't care whether customsave prefix is followed by _ or -
		local prefixlen = string.len("customsave_")
		table.sort(customsaves, function (a, b) return string.lower(string.sub(a.filename, prefixlen + 1)) < string.lower(string.sub(b.filename, prefixlen + 1)) end)
		for i, savegame in ipairs(customsaves) do
			local entry = string.format("%s - %s", string.sub(savegame.filename, prefixlen + 1), savegame.displayedname)
			savegame.displayedname = entry
			maxRowHeight = math.max(maxRowHeight, menu.addSavegameRow(ftable, savegame, entry))
		end
	end

	local titletable = frame:addTable(4, { tabOrder = 3, x = menu.table.x, y = menu.table.y, width = menu.table.widthExtraWide, maxVisibleHeight = menu.table.height, skipTabChange = true })
	titletable:setColWidth(1, menu.table.arrowColumnWidth, false)
	titletable:setColWidth(2, ftable.properties.width - menu.table.arrowColumnWidth - Helper.scaleY(config.infoTextHeight) - 2 * Helper.borderSize, false)
	titletable:setColWidth(3, Helper.scaleY(config.infoTextHeight), false)

	-- title
	local row = titletable:addRow({ titlerow = "title" }, { fixed = true, bgColor = Helper.color.transparent })
	if menu.preselectOption == "title" then
		titletable:setSelectedRow(row.index)
	end
	row[1]:setBackgroundColSpan(4):createButton({ height = config.headerTextHeight }):setIcon(config.backarrow, { x = config.backarrowOffsetX })
	row[1].handlers.onClick = function () return menu.onCloseElement("back") end
	row[2]:setColSpan(3):createText(options.name, config.headerTextProperties)

	local offsety = titletable.properties.y + titletable:getFullHeight() + Helper.borderSize
	ftable.properties.y = offsety
	ftable.properties.maxVisibleHeight = math.max(menu.table.height - offsety, maxRowHeight + Helper.borderSize + (customsavetitlerow and (customsavetitlerow:getHeight() + Helper.borderSize) or 0))
	if ftable:hasScrollBar() then
		if (not isonline) or (menu.currentOption ~= "save") then
			nameSortButton.properties.icon.x = nameSortButton.properties.icon.x - Helper.scrollbarWidth
		end
	end

	ftable:setTopRow(menu.preselectTopRow)
	menu.preselectTopRow = nil
	menu.preselectOption = nil

	titletable.properties.nextTable = ftable.index
	ftable.properties.prevTable = titletable.index

	-- infos
	local buttontable = frame:addTable(4, { tabOrder = 2, x = menu.table.x + ftable.properties.width + Helper.borderSize, y = offsety, width = ftable.properties.width - Helper.borderSize, maxVisibleHeight = menu.table.height - offsety, highlightMode = "off" })
	buttontable:setColWidthPercent(2, 16)
	buttontable:setColWidthPercent(3, 16)
	local row = buttontable:addRow(nil, { bgColor = Helper.color.transparent })
	row[1]:setColSpan(4):createText(" ")
	-- save name
	local row = buttontable:addRow((menu.currentOption == "save") or (menu.currentOption == "saveoffline"), { bgColor = Helper.color.transparent })
	row[1]:setColSpan(2):createText(ReadText(1001, 8970) .. ReadText(1001, 120))
	if (menu.currentOption == "save") or (menu.currentOption == "saveoffline") then
		menu.saveNameEditBox = row[3]:setColSpan(2):createEditBox({ height = config.standardTextHeight, description = ReadText(1001, 8970), active = function () return (menu.selectedOption ~= nil) and (next(menu.selectedOption) ~= nil) and (not menu.selectedOption.isonline) end }):setText(menu.savegameName, { fontsize = config.standardFontSize, halign = "right" }):setHotkey("INPUT_STATE_DETAILMONITOR_Y", { displayIcon = true, x = 0 })
		row[3].handlers.onTextChanged = menu.editboxSaveName
	else
		row[3]:setColSpan(2):createText(function () return ((menu.selectedOption ~= nil) and (next(menu.selectedOption) ~= nil)) and menu.selectedOption.displayedname or "" end, config.standardRightTextProperties)
	end
	local inforows = {}
	-- player name
	local row = buttontable:addRow(nil, { bgColor = Helper.color.transparent })
	table.insert(inforows, row)
	row[1]:setColSpan(2):createText(ReadText(1001, 2809) .. ReadText(1001, 120))
	row[3]:setColSpan(2):createText(function () return ((menu.selectedOption ~= nil) and (next(menu.selectedOption) ~= nil)) and menu.selectedOption.playername or "" end, config.standardRightTextProperties)
	-- money
	local row = buttontable:addRow(nil, { bgColor = Helper.color.transparent })
	table.insert(inforows, row)
	row[1]:setColSpan(2):createText(ReadText(1001, 2003) .. ReadText(1001, 120))
	row[3]:setColSpan(2):createText(function () return ((menu.selectedOption ~= nil) and (next(menu.selectedOption) ~= nil) and menu.selectedOption.playername) and (ConvertMoneyString(menu.selectedOption.money, false, true, 0, true, false).. " " .. ReadText(1001, 101)) or "" end, config.standardRightTextProperties)
	-- location
	local row = buttontable:addRow(nil, { bgColor = Helper.color.transparent })
	table.insert(inforows, row)
	row[1]:setColSpan(2):createText(ReadText(1001, 2943) .. ReadText(1001, 120))
	row[3]:setColSpan(2):createText(function () return ((menu.selectedOption ~= nil) and (next(menu.selectedOption) ~= nil) and menu.selectedOption.playername) and menu.selectedOption.location or "" end, config.standardRightTextProperties)
	-- game time
	local row = buttontable:addRow(nil, { bgColor = Helper.color.transparent })
	table.insert(inforows, row)
	row[1]:setColSpan(2):createText(ReadText(1001, 8969) .. ReadText(1001, 120))
	row[3]:setColSpan(2):createText(function () return ((menu.selectedOption ~= nil) and (next(menu.selectedOption) ~= nil) and menu.selectedOption.playername) and ConvertTimeString(menu.selectedOption.playtime, "%d" .. ReadText(1001, 104) .. " %H" .. ReadText(1001, 102) .. " %M" .. ReadText(1001, 103)) or "" end, config.standardRightTextProperties)
	-- version
	local row = buttontable:addRow(nil, { bgColor = Helper.color.transparent })
	table.insert(inforows, row)
	row[1]:setColSpan(2):createText(ReadText(1001, 2655) .. ReadText(1001, 120))
	row[3]:setColSpan(2):createText(menu.savegameInfoVersion, config.standardRightTextProperties)
	-- gamestart
	local row = buttontable:addRow(nil, { bgColor = Helper.color.transparent })
	table.insert(inforows, row)
	row[1]:setColSpan(2):createText(ReadText(1001, 8988) .. ReadText(1001, 120))
	row[3]:setColSpan(2):createText(function () return ((menu.selectedOption ~= nil) and (next(menu.selectedOption) ~= nil) and menu.selectedOption.gamestart) and menu.selectedOption.gamestart or "" end, config.standardRightTextProperties)
	-- errors
	local row = buttontable:addRow(nil, { bgColor = Helper.color.transparent })
	table.insert(inforows, row)
	row[1]:setColSpan(4):createText(menu.errorSavegameInfo(), { color = (menu.currentOption == "load") and Helper.color.red or Helper.color.warningorange, wordwrap = true })
	-- buttons
	local row = buttontable:addRow(true, { bgColor = Helper.color.transparent })
	if menu.currentOption == "load" then
		row[1]:createButton({ bgColor = function () return menu.isValidSaveSelected() and Helper.defaultButtonBackgroundColor or Helper.defaultUnselectableButtonBackgroundColor end, highlightColor = function () return menu.isValidSaveSelected() and Helper.defaultButtonHighlightColor or Helper.defaultUnselectableButtonHighlightColor end }):setText(ReadText(1001, 8966), { halign = "center", color = function () return menu.isValidSaveSelected() and Helper.color.white or Helper.color.grey end })
		row[1].handlers.onClick = function () if menu.isValidSaveSelected() then menu.loadGameCallback(menu.selectedOption.filename, false) end end
	else
		row[1]:createButton({ active = function () return (menu.selectedOption ~= nil) and (next(menu.selectedOption) ~= nil) and (menu.selectedOption.titlerow == nil) and (menu.selectedOption.submenu == nil) end }):setText(function () local isempty = menu.selectedOption and menu.selectedOption.empty; local isonlinesave = menu.selectedOption and menu.selectedOption.isonline; return (Helper.isOnlineGame() and (not isonlinesave)) and (isempty and ReadText(1001, 11701) or ReadText(1001, 11702)) or (isempty and ReadText(1001, 8967) or ReadText(1001, 8968)) end, { halign = "center" })
		row[1].handlers.onClick = menu.buttonOverwriteSave
	end
	row[4]:createButton({ active = function () return (menu.selectedOption ~= nil) and (next(menu.selectedOption) ~= nil) and (menu.selectedOption.titlerow == nil) and (menu.selectedOption.submenu == nil) and (not menu.selectedOption.empty) end }):setText(ReadText(1001, 8931), { halign = "center" }):setHotkey("INPUT_STATE_DETAILMONITOR_X", { displayIcon = true })
	row[4].handlers.onClick = menu.buttonDeleteSave

	if buttontable:hasScrollBar() then
		buttontable.properties.highlightMode = "grey"
		for _, row in ipairs(inforows) do
			row.rowdata = true
		end
	end

	ftable.properties.nextHorizontalTable = buttontable.index
	buttontable.properties.prevHorizontalTable = ftable.index

	frame:display()
end

function menu.isValidSaveSelected()
	return (menu.selectedOption ~= nil) and (next(menu.selectedOption) ~= nil) and menu.selectedOption.filename and ((not menu.selectedOption.error and not menu.selectedOption.invalidpatches and not menu.selectedOption.invalidversion and not menu.selectedOption.invalidgameid) or IsCheatVersion())
end

function menu.displayLobby()
	menu.selectedOption = nil
	menu.currentOption = "lobby"

	menu.lobby = menu.lobby or {}
	C.QueryGameServers()

	menu.drawLobby()
end

function menu.drawLobby()
	-- remove old data
	Helper.clearDataForRefresh(menu, config.optionsLayer)

	local frame = menu.createOptionsFrame()

	local ftable = frame:addTable(3, { tabOrder = 1, x = menu.table.x, y = menu.table.y, width = menu.table.width, maxVisibleHeight = menu.table.height })
	ftable:setColWidth(1, menu.table.arrowColumnWidth, false)
	ftable:setColWidth(3, Helper.scaleY(config.infoTextHeight), false)

	-- title
	local row = ftable:addRow({}, { fixed = true, bgColor = Helper.color.transparent })
	row[1]:setBackgroundColSpan(2)
	row[1]:createButton({ height = config.headerTextHeight }):setIcon(config.backarrow, { x = config.backarrowOffsetX })
	row[1].handlers.onClick = function () return menu.onCloseElement("back") end
	row[2]:setColSpan(2):createText(ReadText(1001,7286), config.headerTextProperties)

	-- info
	local row = ftable:addRow({}, { fixed = true, bgColor = Helper.color.transparent })
	row[3]:createButton({ height = config.infoTextHeight }):setIcon("menu_reload", {  })
	row[3].handlers.onClick = menu.buttonReloadLobby

	if #menu.lobby > 0 then
		-- #networkHigh - should display roomname instead of ip-address (maybe "[roomname] ([IP])")
		for _, entry in ipairs(menu.lobby) do
			local row = ftable:addRow(entry, { bgColor = Helper.color.transparent })
			row[2]:setColSpan(2):createText(entry.address, config.standardTextProperties)
		end
	else
		local row = ftable:addRow(false, { bgColor = Helper.color.transparent })
		row[2]:setColSpan(2):createText(ReadText(1001,7287), config.disabledTextProperties)
	end

	frame:display()
end

function menu.displayOnlineLogin()
	-- remove old data
	Helper.clearDataForRefresh(menu, config.optionsLayer)
	menu.selectedOption = nil

	menu.currentOption = "online"
	local options = config.optionDefinitions[menu.currentOption]

	local hasRegisteredGame
	if OnlineHasSession() then
		hasRegisteredGame = OnlineIsGameRegistered()
	end
	if not menu.onlineData then
		C.ResetEncryptedDirectInputData()
		menu.onlineData = {
			username = OnlineGetUserName(),
			password = "",
			remember = OnlineHasPreviousSessionToken(),
			hasRegisteredGame = hasRegisteredGame,
			usernameHidden = false,
		}
	end

	local frame = menu.createOptionsFrame()

	local secondMainColumnWidth = menu.table.infoColumnWidth - Helper.scrollbarWidth - config.standardTextHeight - Helper.borderSize
	local ftable = frame:addTable(11, { tabOrder = 1, x = menu.table.x, y = menu.table.y, width = menu.table.width, maxVisibleHeight = menu.table.height, highlightMode = "backgroundcolumn", reserveScrollBar = false })
	ftable:setColWidth(1, menu.table.arrowColumnWidth, false)
	ftable:setColWidth(2, config.standardTextHeight)
	ftable:setColWidth(3, 0.8 * menu.table.widthWithExtraInfo - Helper.scaleX(config.standardTextHeight) - menu.table.arrowColumnWidth - 4 * Helper.borderSize, false)
	ftable:setColWidth(4, 0.1 * menu.table.widthWithExtraInfo, false)
	ftable:setColWidth(5, 0.1 * menu.table.widthWithExtraInfo, false)
	ftable:setColWidth(7, config.standardTextHeight)
	ftable:setColWidth(8, secondMainColumnWidth / 3 - Helper.borderSize, false)
	ftable:setColWidth(9, 2 * secondMainColumnWidth / 9 - Helper.borderSize, false)
	ftable:setColWidth(10, 4 * secondMainColumnWidth / 9 - Helper.scaleX(config.standardTextHeight) - Helper.borderSize, false)
	ftable:setColWidth(11, config.standardTextHeight)
	ftable:setDefaultColSpan(4, 2)
	ftable:setDefaultBackgroundColSpan(1, 11)
	ftable:setDefaultCellProperties("button", { height = config.standardTextHeight })
	ftable:setDefaultComplexCellProperties("button", "text", { x = config.standardTextOffsetX, fontsize = config.standardFontSize })
	ftable:setDefaultCellProperties("dropdown", { height = config.standardTextHeight })
	ftable:setDefaultComplexCellProperties("dropdown", "text", { x = config.standardTextOffsetX, fontsize = config.standardFontSize })
	ftable:setDefaultCellProperties("slidercell", { height = config.standardTextHeight })
	ftable:setDefaultComplexCellProperties("slidercell", "text", { x = config.standardTextOffsetX, fontsize = config.standardFontSize })

	-- title
	local row = ftable:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
	row[1]:setBackgroundColSpan(2)
	row[1]:createButton({ height = config.headerTextHeight }):setIcon(config.backarrow, { x = config.backarrowOffsetX })
	row[1].handlers.onClick = function () return menu.onCloseElement("back") end
	row[2]:setColSpan(10):createText(ReadText(1001, 7252), config.headerTextProperties)

	-- warning
	local row = ftable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
	row[2]:setColSpan(10):createText(menu.warningOnline, config.warningTextProperties)

	local state = OnlineGetVersionIncompatibilityState()
	local hassession = OnlineHasSession()
	local active = (not hassession) and (not menu.onlineData.loginAttempt) and (state ~= 1)

	-- sub title
	local row = ftable:addRow(false, { bgColor = Helper.color.transparent })
	row[2]:setColSpan(10):createText(hassession and string.format(ReadText(1001, 8993), menu.onlineData.username) or ReadText(1001, 8962), config.standardTextProperties)
	if hassession then
		row[2].properties.font = Helper.standardFontBold
	end
	-- username
	local row = ftable:addRow(true, { bgColor = Helper.color.transparent })
	row[2]:setColSpan(5):createText(ReadText(1001, 7246), config.standardTextProperties)
	row[7]:setColSpan(4):createEditBox({ description = ReadText(1001, 7246), active = active, textHidden = function () return menu.onlineData.usernameHidden end }):setText(menu.onlineData.username, { fontsize = config.standardFontSize })
	if active then
		row[7].handlers.onEditBoxActivated = function () menu.onlineData.usernameEditBoxActive = true end
		row[7].handlers.onTextChanged = menu.editboxOnlineUsername
		row[7].handlers.onEditBoxDeactivated = menu.editboxOnlineUsernameDeactivated
	end
	row[11]:createButton({ active = function () return not menu.onlineData.usernameEditBoxActive end }):setIcon("menu_hidden")
	row[11].handlers.onClick = function () menu.onlineData.usernameHidden = not menu.onlineData.usernameHidden end
	-- password
	local row = ftable:addRow(true, { bgColor = Helper.color.transparent })
	row[2]:setColSpan(5):createText(ReadText(1001, 7247), config.standardTextProperties)
	row[7]:setColSpan(5):createEditBox({ textHidden = true, encrypted = true, description = ReadText(1001, 7247), active = active }):setText(active and menu.onlineData.password or "      ", { fontsize = config.standardFontSize })
	if active then
		row[7].handlers.onTextChanged = menu.editboxOnlinePassword
		row[7].handlers.onEditBoxDeactivated = menu.editboxOnlinePasswordDeactivated
	end
	-- remember me
	local row = ftable:addRow(true, { bgColor = Helper.color.transparent })
	row[7]:createCheckBox(menu.onlineData.remember, { active = active })
	row[7].handlers.onClick = menu.checkboxOnlineRemember
	row[8]:setColSpan(4):createText(ReadText(1001, 7248), config.standardTextProperties)
	if not active then
		row[8].properties.color = Helper.color.grey
	end
	-- privacy policy
	local row = ftable:addRow(true, { bgColor = Helper.color.transparent })
	row[2]:createCheckBox(__CORE_GAMEOPTIONS_PRIVACYPOLICY or (not active), { active = active })
	row[2].handlers.onClick = menu.checkboxOnlinePrivacyPolicy
	row[3]:setColSpan(8):createText(ReadText(1001, 7308), config.standardTextProperties)
	if not active then
		row[3].properties.color = Helper.color.grey
	end
	-- login button
	local row = ftable:addRow(true, { bgColor = Helper.color.transparent })
	if OnlineHasSession() then
		local isonline = Helper.isOnlineGame()
		row[2]:setColSpan(5):createButton({ height = config.standardTextHeight, active = not isonline, mouseOverText = isonline and ReadText(1026, 2654) or "" }):setText(ReadText(1001, 7250), { fontsize = config.standardFontSize, halign = "center" })
		row[2].handlers.onClick = menu.buttonOnlineLogout
	else
		row[2]:setColSpan(5):createButton({ height = config.standardTextHeight, active = function () return active and (menu.onlineData.username ~= "") and (menu.onlineData.password ~= "") and (__CORE_GAMEOPTIONS_PRIVACYPOLICY == true) end }):setText(ReadText(1001, 7249), { fontsize = config.standardFontSize, halign = "center" })
		row[2].handlers.onClick = menu.buttonOnlineLogin
	end
	-- errors
	if menu.onlineData.loginAttempt then
		-- connecting
		row[7]:setColSpan(5):createText(menu.nameLogin, config.standardTextProperties)
	elseif menu.onlineData.loginError then
		local errorcode = menu.onlineData.loginError
		local errortext = ""
		local errormouseovertext = ""
		local showhelpbutton = false
		if errorcode == "ERR_CREDENTIALS_INVALID" then
			errortext = ReadText(1001, 8925)
			showhelpbutton = C.CanOpenWebBrowser()
		elseif errorcode == "ERR_INTERNAL" then
			errortext = ReadText(1001, 8926)
		elseif errorcode == "ERR_INTERNAL_DB" then
			errortext = ReadText(1001, 8927)
		elseif errorcode == "ERR_USERNAME_LENGTH" then
			errortext = ReadText(1001, 8928)
		elseif errorcode == "ERR_PASSWORD_LENGTH" then
			errortext = ReadText(1001, 8929)
		elseif errorcode == "ERR_CONNECT_FAILED" then
			errortext = ReadText(1001, 8911)
			errormouseovertext = "\27R" .. ReadText(1001, 8912)
		elseif errorcode == "ERR_ACCESS_DENIED" then
			errortext = ReadText(1001, 8914)
			errormouseovertext = "\27R" .. ReadText(1001, 8915)
		elseif errorcode == "ERR_SERVICE_UNAVAILABLE" then
			errortext = ReadText(1001, 8913)
		elseif errorcode == "INCOMPATIBLE_CLIENT_VERSION" then
			errortext = ReadText(1001, 11352)
		elseif errorcode == "INCOMPATIBLE_ONLINE_EXTENSION_VERSION" then
			errortext = ReadText(1001, 11354)
		elseif menu.onlineData.loginError then
			errortext = ReadText(1001, 7256)
		end
		row[7]:setColSpan(showhelpbutton and 3 or 5):createText(errortext, config.standardTextProperties)
		row[7].properties.wordwrap = true
		row[7].properties.color = Helper.color.red
		row[7].properties.mouseOverText = errormouseovertext
		if showhelpbutton then
			row[10]:setColSpan(2):createButton({ height = config.standardTextHeight, active = C.CanOpenWebBrowser() }):setText(ReadText(1001, 8992) .. " \27[mm_externallink]", { fontsize = config.standardFontSize, halign = "center" })
			row[10].handlers.onClick = menu.buttonOnlineHelp
		end
	end
	
	if (not OnlineHasSession()) or (menu.onlineData.hasRegisteredGame == false) then
		ftable:addEmptyRow()
		-- create account
		local row = ftable:addRow(false, { bgColor = Helper.color.transparent })
		row[1]:setColSpan(11):createText((menu.onlineData.hasRegisteredGame == false) and ReadText(1001, 8965) or ReadText(1001, 8963), config.subHeaderTextProperties)
		-- no account text / not registered
		local row = ftable:addRow(false, { bgColor = Helper.color.transparent })
		row[2]:setColSpan(10):createText((menu.onlineData.hasRegisteredGame == false) and ReadText(1001, 8907) or ReadText(1001, 7291))
	end

	if (not OnlineHasSession()) or (menu.onlineData.hasRegisteredGame == false) then
		row = ftable:addRow(true, { bgColor = Helper.color.transparent })
		-- register
		row[2]:setColSpan(5):createButton({ height = config.standardTextHeight, active = C.CanOpenWebBrowser() }):setText(ReadText(1001, 7290) .. " \27[mm_externallink]", { fontsize = config.standardFontSize, halign = "center" })
		row[2].handlers.onClick = menu.buttonOnlineRegister
	end
	-- privacy policy
	row[7]:setColSpan(5):createButton({ height = config.standardTextHeight, active = C.CanOpenWebBrowser() }):setText(ReadText(1001, 7292) .. " \27[mm_externallink]", { fontsize = config.standardFontSize, halign = "center" })
	row[7].handlers.onClick = menu.buttonPrivacyPolicy

	if not OnlineHasSession() then
		local row = ftable:addRow(false, { bgColor = Helper.color.transparent })
		row[2]:setColSpan(10):createText(ReadText(1001, 8964) .. "\n" .. ReadText(1001, 8923), { wordwrap = true })
	elseif menu.onlineData.hasRegisteredGame == false then
		local row = ftable:addRow(false, { bgColor = Helper.color.transparent })
		row[2]:setColSpan(10):createText(ReadText(1001, 8923), { wordwrap = true })
	end

	-- venture extension
	if C.IsVentureExtensionSupported() then
		local ventureextensionid = "ego_dlc_ventures"
		local isinstalled = C.IsExtensionEnabled(ventureextensionid, false)
		local dlcstate = config.ventureDLCStates[C.GetVentureDLCStatus()] or "unknownerror"

		local row = ftable:addRow(false, { bgColor = Helper.color.transparent })
		row[1]:createText("", config.standardTextProperties)
		-- header
		local row = ftable:addRow(false, { bgColor = Helper.color.transparent })
		row[1]:setColSpan(11):createText(ReadText(1001, 11736), config.subHeaderTextProperties)
		-- info
		if (dlcstate ~= "valid") and (not C.WasSessionOnline()) then
			local row = ftable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
			row[2]:setColSpan(10):createText(ReadText(1001, 11774), config.warningTextProperties)
		end
		-- installed
		local row = ftable:addRow(false, { bgColor = Helper.color.transparent })
		row[2]:setColSpan(5):createText(ReadText(1001, 4805), config.standardTextProperties)
		row[7]:setColSpan(5):createText(isinstalled and ReadText(1001, 2617) or ReadText(1001, 2618), config.standardTextProperties)
		-- version
		local row = ftable:addRow(false, { bgColor = Helper.color.transparent })
		row[2]:setColSpan(5):createText(ReadText(1001, 2655), config.standardTextProperties)
		row[7]:setColSpan(5):createText(isinstalled and ffi.string(C.GetExtensionVersion(ventureextensionid, false)) or "---", config.standardTextProperties)
		-- status
		local row = ftable:addRow(false, { bgColor = Helper.color.transparent })
		row[2]:setColSpan(5):createText(ReadText(1001, 11737), config.standardTextProperties)

		local statusstring = "---"
		if dlcstate == "valid" then
			statusstring = ReadText(1001, 11738)
		elseif dlcstate == "userdisabled" then
			statusstring = Helper.convertColorToText(Helper.color.warningorange) .. ReadText(1001, 11739) .. "\27X"
		elseif dlcstate == "userskipped" then
			statusstring = Helper.convertColorToText(Helper.color.warningorange) .. ReadText(1001, 11740) .. "\27X"
		elseif dlcstate == "notpossible" then
			statusstring = Helper.convertColorToText(Helper.color.red) .. ReadText(1001, 11741) .. "\27X"
		elseif dlcstate == "updatedisabled" then
			statusstring = Helper.convertColorToText(Helper.color.warningorange) .. ReadText(1001, 11742) .. "\27X"
		elseif dlcstate == "updateskipped" then
			statusstring = Helper.convertColorToText(Helper.color.warningorange) .. ReadText(1001, 11743) .. "\27X"
		elseif dlcstate == "updatenotpossible" then
			statusstring = Helper.convertColorToText(Helper.color.red) .. ReadText(1001, 11744) .. "\27X"
		else
			statusstring = Helper.convertColorToText(Helper.color.red) .. ReadText(1001, 11745) .. "\27X"
		end

		row[7]:setColSpan(5):createText(isinstalled and statusstring or "---", config.standardTextProperties)
		row[7].properties.wordwrap = true
		-- line
		local row = ftable:addRow(nil, { bgColor = Helper.color.transparent })
		row[2]:setColSpan(10):createText(" ", { fontsize = 1, height = Helper.borderSize, cellBGColor = Helper.color.transparent60 })
		-- download settings
		local row = ftable:addRow(true, { bgColor = Helper.color.transparent })
		row[2]:setColSpan(5):createText(ReadText(1001, 11746), config.standardTextProperties)

		local options = {
			{ id = "never",  text = ReadText(1001, 11747), icon = "", displayremoveoption = false, mouseovertext = ReadText(1026, 2663) },
			{ id = "always", text = ReadText(1001, 11748), icon = "", displayremoveoption = false, mouseovertext = ReadText(1026, 2664) },
			{ id = "manual", text = ReadText(1001, 11749), icon = "", displayremoveoption = false, mouseovertext = ReadText(1026, 2665) },
		}

		local curoption = "never"
		if OnlineGetVentureConfig("allow_validation") then
			if OnlineGetVentureConfig("allow_update") then
				curoption = "always"
			else
				curoption = "manual"
			end
		end

		row[7]:setColSpan(5):createDropDown(options, { startOption = curoption })
		row[7].handlers.onDropDownConfirmed = menu.dropdownVentureExtensionDownload
		if (curoption == "manual") and ((dlcstate ~= "valid") or (state ~= 0)) then
			-- download once
			local row = ftable:addRow(true, { bgColor = Helper.color.transparent })
			row[7]:createCheckBox(OnlineGetVentureConfig("allow_update_once"), {  })
			row[7].handlers.onClick = menu.checkboxScheduleVentureExtensionDownload
			row[8]:setColSpan(4):createText(ReadText(1001, 11750), config.standardTextProperties)
		end
	end

	-- options
	if C.IsVentureExtensionSupported() then
		local row = ftable:addRow(false, { bgColor = Helper.color.transparent })
		row[1]:createText("", config.standardTextProperties)

		local row = ftable:addRow(false, { bgColor = Helper.color.transparent })
		row[1]:setColSpan(11):createText(ReadText(1001, 7299), config.subHeaderTextProperties)

		local offsety = ftable.properties.y + ftable:getVisibleHeight() + Helper.borderSize
		local height = menu.table.height - (ftable:getVisibleHeight() + Helper.borderSize)

		local optionwidth = 0
		for _, option in ipairs(options) do
			local row, row2 = menu.displayOption(ftable, option, 7)
			if row then
				row[1]:setBackgroundColSpan(8)
				row[5]:setColSpan(4)
				row[9]:setColSpan(3)
				if optionwidth == 0 then
					optionwidth = row[9]:getColSpanWidth()
				end
			end
		end

		local width = menu.table.width - menu.table.widthWithExtraInfo - Helper.borderSize
		local offsetx = menu.table.x + menu.table.widthWithExtraInfo + Helper.borderSize
		if optionwidth > 0 then
			width = optionwidth
			offsetx = menu.table.x + menu.table.width - optionwidth
		end
		local infotable = frame:addTable(1, { tabOrder = 0, x = offsetx, y = offsety, width = width, maxVisibleHeight = height })

		local row = infotable:addRow(false, { bgColor = Helper.color.transparent60 })
		row[1]:createText(menu.infoHandler, { scaling = false, width = width, height = height, wordwrap = true, fontsize = Helper.scaleFont(config.font, config.infoFontSize) })
	end

	ftable:setTopRow(menu.preselectTopRow)
	ftable:setSelectedRow(menu.preselectOption)
	menu.preselectTopRow = nil
	menu.preselectOption = nil

	frame:display()
end

function menu.displayControls(optionParameter)
	-- remove old data
	Helper.clearDataForRefresh(menu, config.optionsLayer)
	menu.selectedOption = nil

	menu.currentOption = optionParameter

	menu.getControlsData()

	local frame = menu.createOptionsFrame()

	local ftable = frame:addTable(4, { tabOrder = 1, x = menu.table.x, y = menu.table.y, width = menu.table.width, maxVisibleHeight = menu.table.height - menu.table.y })
	ftable:setColWidth(1, menu.table.arrowColumnWidth, false)
	ftable:setColWidthPercent(3, 30)
	ftable:setColWidthPercent(4, 30)
	ftable:setDefaultCellProperties("button", { height = config.standardTextHeight })
	ftable:setDefaultComplexCellProperties("button", "text", { x = config.standardTextOffsetX, fontsize = config.standardFontSize })

	-- title
	local firstpart = ""
	if (optionParameter == "keyboard_space") or (optionParameter == "keyboard_menus") or (optionParameter == "keyboard_firstperson") then
		firstpart = ReadText(1001, 2656)
	elseif (optionParameter == "vrtouch_space") or (optionParameter == "vrtouch_menus") or (optionParameter == "vrtouch_firstperson") then
		firstpart = ReadText(1001, 7262)
	elseif (optionParameter == "vrvive_space") or (optionParameter == "vrvive_menus") or (optionParameter == "vrvive_firstperson") then
		firstpart = ReadText(1001, 7263)
	end
	local secondpart = ""
	if (optionParameter == "keyboard_space") or (optionParameter == "vrtouch_space") or (optionParameter == "vrvive_space") then
		secondpart = ReadText(1001, 2658)
	elseif (optionParameter == "keyboard_menus") or (optionParameter == "vrtouch_menus") or (optionParameter == "vrvive_menus") then
		secondpart = ReadText(1001, 2660)
	elseif (optionParameter == "keyboard_firstperson") or (optionParameter == "vrtouch_firstperson") or (optionParameter == "vrvive_firstperson") then
		secondpart = ReadText(1001, 2659)
	end

	local row = ftable:addRow({}, { fixed = true, bgColor = Helper.color.transparent })
	row[1]:setBackgroundColSpan(2)
	row[1]:createButton({ height = config.headerTextHeight }):setIcon(config.backarrow, { x = config.backarrowOffsetX })
	row[1].handlers.onClick = function () return menu.onCloseElement("back") end
	row[2]:setColSpan(3):createText(firstpart .. ReadText(1001, 120) .. " " .. secondpart, config.headerTextProperties)

	menu.controlsorder = {}
	if (optionParameter == "keyboard_space") or (optionParameter == "vrtouch_space") or (optionParameter == "vrvive_space") then
		menu.controlsorder = config.input.controlsorder.space
	elseif (optionParameter == "keyboard_menus") or (optionParameter == "vrtouch_menus") or (optionParameter == "vrvive_menus") then
		menu.controlsorder = config.input.controlsorder.menus
	elseif (optionParameter == "keyboard_firstperson") or (optionParameter == "vrtouch_firstperson") or (optionParameter == "vrvive_firstperson") then
		menu.controlsorder = config.input.controlsorder.firstperson
	end

	local joysticks = GetJoysticksOption()
	menu.mappedjoysticks = GetMappedJoysticks()
	for i, joystick in ipairs(menu.mappedjoysticks) do
		if joystick <= 8 then
			menu.mappedjoysticks[i] = joysticks[joystick] or {}
		else
			menu.mappedjoysticks[i] = {}
		end
	end

	local row = ftable:addRow(true, { bgColor = Helper.color.transparent, fixed = true })
	row[2]:setColSpan(3):createEditBox({ defaultText = ReadText(1001, 3250) }):setText(menu.searchtext, { x = Helper.standardTextOffsetx }):setHotkey("INPUT_STATE_DETAILMONITOR_0", { displayIcon = true })
	row[2].handlers.onEditBoxDeactivated = menu.editboxControlsSearchUpdateText
	local searchrowindex = row.index
	local found = false
	local isdoubleclickmode = C.GetMouseHUDModeOption() == 2
	for i, controls in ipairs(menu.controlsorder) do
		local first = true
		for _, control in ipairs(controls) do
			if menu.filterControl(control[1], control[2], menu.searchtext) then
				found = true
				if first then
					first = false

					local row = ftable:addRow(false, { bgColor = Helper.color.transparent })
					row[2]:setColSpan(3):createText(controls.title, config.subHeaderTextProperties)
				end
				if (not control.display) or control.display() then
					if IsCheatVersion() or (not config.input.cheatControls[control[1]][control[2]]) then
						menu.displayControlRow(ftable, i, control[1], control[2], control[3], control[4], controls.mapable, isdoubleclickmode, control[5])
					end
				end
			end
		end
	end

	ftable:setTopRow(menu.preselectTopRow)
	if not found then
		ftable:setSelectedRow(searchrowindex)
	end
	menu.preselectTopRow = nil
	menu.preselectOption = nil

	frame:display()
end

function menu.filterControl(controltype, code, text)
	local name
	if controltype == "functions" then
		name = menu.controls[controltype][code].name
	else
		name = ReadText(config.input.controltextpage[controltype], code)
	end

	text = utf8.lower(text)

	if string.find(utf8.lower(name), text, 1, true) then
		return true
	end
	return false
end

function menu.editboxControlsSearchUpdateText(widget, text, textchanged)
	if textchanged then
		menu.searchtext = text
	end

	menu.refresh()
end

function menu.displayJoysticks()
	-- remove old data
	Helper.clearDataForRefresh(menu, config.optionsLayer)
	menu.selectedOption = nil

	menu.currentOption = "joysticks"

	local frame = menu.createOptionsFrame()

	local ftable = frame:addTable(2, { tabOrder = 1, x = menu.table.x, y = menu.table.y, width = menu.table.width, maxVisibleHeight = menu.table.height })
	ftable:setColWidth(1, menu.table.arrowColumnWidth, false)
	ftable:setDefaultCellProperties("dropdown", { height = config.standardTextHeight })
	ftable:setDefaultComplexCellProperties("dropdown", "text", { x = config.standardTextOffsetX, fontsize = config.standardFontSize })

	-- title
	local row = ftable:addRow({}, { fixed = true, bgColor = Helper.color.transparent })
	row[1]:setBackgroundColSpan(2)
	row[1]:createButton({ height = config.headerTextHeight }):setIcon(config.backarrow, { x = config.backarrowOffsetX })
	row[1].handlers.onClick = function () return menu.onCloseElement("back") end
	row[2]:createText(ReadText(1001, 2674), config.headerTextProperties)

	local joysticks = GetJoysticksOption()
	local mappedjoysticks = GetMappedJoysticks()

	local options = { [1] = { id = "none", text = ReadText(1001, 4812), icon = "", displayremoveoption = false } }
	for i, joystick in pairs(joysticks) do
		if joystick.guid ~= "" then
			local icon = ""
			for source, joystickindex in ipairs(mappedjoysticks) do
				if (joystickindex <= 8) and (joystickindex == i) then
					icon = (joystick.xinput and (Helper.convertColorToText(Helper.color.orange) .. menu.getInputDeviceIcon("controller")) or (Helper.convertColorToText(Helper.color.brightyellow) .. menu.getInputDeviceIcon("joystick"))) .. ((source > 1) and menu.getInputDeviceIcon("number_" .. source) or "")
				end
			end
			table.insert(options, { id = joystick.guid, text = joystick.name, text2 = icon, icon = "", displayremoveoption = false })
		end
	end

	for i, joystick in ipairs(mappedjoysticks) do
		local currentOption = "none"
		if joystick <= 8 then
			local joystickdata = joysticks[joystick]
			if joystickdata then
				currentOption = joystickdata.guid
			end
		end
		
		local row = ftable:addRow({ id = i }, { bgColor = Helper.color.transparent })
		row[2]:createDropDown(options, { active = isselectable, startOption = currentOption }):setTextProperties():setText2Properties({ halign = "right" })
		row[2].handlers.onDropDownConfirmed = function(_, id) return menu.callbackJoystick(i, id) end
	end

	frame:display()
end

function menu.displayInputProfiles(optionParameter)
	-- remove old data
	Helper.clearDataForRefresh(menu, config.optionsLayer)
	menu.selectedOption = nil

	menu.currentOption = optionParameter

	local frame = menu.createOptionsFrame()

	local ftable = frame:addTable(3, { tabOrder = 1, x = menu.table.x, y = menu.table.y, width = menu.table.width, maxVisibleHeight = menu.table.height })
	ftable:setColWidth(1, menu.table.arrowColumnWidth, false)
	ftable:setColWidth(3, config.standardTextHeight)

	-- title
	local row = ftable:addRow({}, { fixed = true, bgColor = Helper.color.transparent })
	row[1]:setBackgroundColSpan(2)
	row[1]:createButton({ height = config.headerTextHeight }):setIcon(config.backarrow, { x = config.backarrowOffsetX })
	row[1].handlers.onClick = function () return menu.onCloseElement("back") end
	row[2]:setColSpan(2):createText((menu.currentOption == "profile_load") and ReadText(1001, 4859) or ReadText(1001, 4858), config.headerTextProperties)

	local userprofiles = {}
	local inputprofiles = GetInputProfiles()

	for i, profile in ipairs(inputprofiles) do
		if not profile.personal then
			if menu.currentOption == "profile_load" then
				local row = ftable:addRow(profile, { bgColor = Helper.color.transparent })
				row[2]:setColSpan(2):createText(profile.name, config.standardTextProperties)
				if profile.id == menu.preselectOption then
					ftable:setSelectedRow(row.index)
				end
			end
		else 
			userprofiles[profile.filename] = i
		end
	end

	if menu.currentOption == "profile_load" then
		local row = ftable:addRow(false, { bgColor = Helper.color.transparent })
		row[2]:setColSpan(2):createText(" ", { fontsize = 1, height = Helper.borderSize, cellBGColor = Helper.color.transparent60 })
	end

	for i = 1, 5 do
		local filename = "inputmap_" .. i
		if userprofiles[filename] then
			local profile = inputprofiles[userprofiles[filename]]
			local row = ftable:addRow(profile, { bgColor = Helper.color.transparent })
			if profile.id == menu.preselectOption then
				ftable:setSelectedRow(row.index)
			end
			if menu.currentOption == "profile_load" then
				row[2]:setColSpan(2):createText(profile.name, config.standardTextProperties)
			else
				row[2]:createEditBox({ description = ReadText(1001, 4858) }):setText(profile.name, { fontsize = config.standardFontSize })
				row[2].handlers.onTextChanged = function (_, text) return menu.editboxInputProfileSave(profile, text) end
				row[3]:createButton({ height = config.standardTextHeight }):setIcon("menu_save")
				row[3].handlers.onClick = function () return menu.buttonInputProfileSave(profile) end
			end
		else
			local row = ftable:addRow({ id = 100 + i, empty = true }, { bgColor = Helper.color.transparent })
			if (100 + i) == menu.preselectOption then
				ftable:setSelectedRow(row.index)
			end
			if menu.currentOption == "profile_load" then
				row[2]:setColSpan(2):createText(ReadText(1001, 4812), config.disabledTextProperties)
			else
				row[2]:createText(ReadText(1001, 4812), config.disabledTextProperties)
				row[3]:createButton({ height = config.standardTextHeight }):setIcon("menu_save")
				row[3].handlers.onClick = function () return menu.buttonInputProfileSave({ filename = filename, id = 100 + i, name = ReadText(1023, 100 + i), customname = "" }) end
			end
		end
	end

	ftable:setTopRow(menu.preselectTopRow)
	menu.preselectTopRow = nil
	menu.preselectOption = nil

	frame:display()
end

function menu.displayLanguageOptions()
	-- remove old data
	Helper.clearDataForRefresh(menu, config.optionsLayer)
	menu.selectedOption = nil

	menu.currentOption = "language"

	local frame = menu.createOptionsFrame()

	local ftable = frame:addTable(3, { tabOrder = 1, x = menu.table.x, y = menu.table.y, width = menu.table.width, maxVisibleHeight = menu.table.height })
	ftable:setColWidth(1, menu.table.arrowColumnWidth, false)
	ftable:setColWidth(3, config.standardTextHeight)

	-- title
	local row = ftable:addRow(not menu.firstlanguageselection, { fixed = true, bgColor = Helper.color.transparent })
	row[1]:setBackgroundColSpan(2)
	if menu.firstlanguageselection then
		row[1]:setColSpan(3):createText(ReadText(1001, 7236), config.headerTextProperties)
	else
		row[1]:createButton({ height = config.headerTextHeight }):setIcon(config.backarrow, { x = config.backarrowOffsetX })
		row[1].handlers.onClick = function () return menu.onCloseElement("back") end
		row[2]:setColSpan(2):createText(ReadText(1001, 7236), config.headerTextProperties)
	end

	-- info
	local row = ftable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
	row[1]:setColSpan(3):createText(menu.warningLanguage, config.warningTextProperties)

	menu.getLanguageData()

	for i, language in ipairs(menu.languagedata) do
		local row = ftable:addRow(language, { bgColor = Helper.color.transparent })
		if language.id == menu.languagedata.requestedID then
			ftable:setSelectedRow(row.index)
		end

		row[2]:setColSpan(2):createText(language.name, config.standardTextProperties)
		if language.font ~= "" then
			row[2].properties.font = language.font
		end
	end

	ftable:setTopRow(menu.preselectTopRow)
	menu.preselectTopRow = nil
	menu.preselectOption = nil

	frame:display()
end

function menu.displayUserQuestion(question, callback, negCallback, timer, waitforgfx, editboxHook, editboxNote, infotext)
	-- remove old data
	Helper.clearDataForRefresh(menu, config.optionsLayer)
	menu.selectedOption = nil

	menu.currentOption = "question"
	menu.userQuestion = {
		question = question,
		timer = timer and getElapsedTime() + (waitforgfx and 150.0 or timer),
		gfxDone = not waitforgfx,
		callback = callback,
		negCallback = negCallback,
		hasEditBox = editboxHook ~= nil,
	}

	local frame = menu.createOptionsFrame()

	local ftable = frame:addTable(4, { tabOrder = 1, x = menu.table.x, y = menu.table.y, width = menu.table.width, maxVisibleHeight = menu.table.height })
	ftable:setColWidth(1, menu.table.arrowColumnWidth, false)
	ftable:setColWidthPercent(2, 20)
	ftable:setColWidth(3, 0.3 * menu.table.width - 0.5 * menu.table.arrowColumnWidth - 1.5 * Helper.borderSize, false)

	-- title
	local row = ftable:addRow({}, { fixed = true, bgColor = Helper.color.transparent })
	row[1]:setBackgroundColSpan(2)
	row[1]:createButton({ height = config.headerTextHeight }):setIcon(config.backarrow, { x = config.backarrowOffsetX })
	row[1].handlers.onClick = function () return menu.onCloseElement("back") end
	row[2]:setColSpan(3):createText(menu.nameUserQuestion, config.headerTextProperties)

	if infotext then
		local row = ftable:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
		row[2]:setColSpan(3):createText(infotext, config.warningTextProperties)
		row[2].properties.color = Helper.color.warningorange

		ftable:addEmptyRow()
	end

	if editboxHook then
		local row = ftable:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
		row[2]:createText(ReadText(1001, 8936) .. ReadText(1001, 120))
		menu.userQuestion.editboxText = editboxHook()
		menu.questionEditBox = row[3]:setColSpan(2):createEditBox({ height = config.standardTextHeight, description = ReadText(1001, 8936) }):setText(menu.userQuestion.editboxText, { fontsize = config.standardFontSize })
		row[3].handlers.onTextChanged = menu.editboxUserQuestionTextChanged
		-- preselect buttons
		ftable:setSelectedRow(row.index)

		if editboxNote then
			local row = ftable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
			row[2]:setColSpan(3):createText(editboxNote, { color = Helper.color.warningorange })
		end

		local row = ftable:addRow({ positive = false }, { fixed = true, bgColor = Helper.color.transparent })
		row[2]:setColSpan(2):createButton({  }):setText(ReadText(1001, 2821), { halign = "center" })
		row[2].handlers.onClick = menu.buttonUserQuestionPositive
		row[4]:createButton({  }):setText(ReadText(1001, 64), { halign = "center" })
		row[4].handlers.onClick = menu.buttonUserQuestionNegative
	else
		local row = ftable:addRow({ positive = false }, { bgColor = Helper.color.transparent })
		row[2]:setColSpan(3):createText(ReadText(1001, 2618), config.standardTextProperties)

		local row = ftable:addRow({ positive = true }, { bgColor = Helper.color.transparent })
		row[2]:setColSpan(3):createText(ReadText(1001, 2617), config.standardTextProperties)
	end

	frame:display()
end

function menu.displayOnlineSeason(option)
	Helper.clearDataForRefresh(menu, config.optionsLayer)
	menu.selectedOption = nil

	menu.currentOption = option

	local frame = menu.createOptionsFrame()

	local ftable = frame:addTable(3, { tabOrder = 1, x = menu.table.x, y = menu.table.y, width = menu.table.width, maxVisibleHeight = menu.table.height })
	ftable:setColWidth(1, menu.table.arrowColumnWidth, false)
	ftable:setColWidth(3, config.standardTextHeight)

	-- title
	local row = ftable:addRow(not menu.firstlanguageselection, { fixed = true, bgColor = Helper.color.transparent })
	row[1]:setBackgroundColSpan(2):createButton({ height = config.headerTextHeight }):setIcon(config.backarrow, { x = config.backarrowOffsetX })
	row[1].handlers.onClick = function () return menu.onCloseElement("back") end
	row[2]:setColSpan(2):createText(ReadText(1001, 11300), config.headerTextProperties)

	-- steps
	local row = ftable:addRow(nil, { bgColor = Helper.color.transparent })
	row[2]:setColSpan(2):createText(ReadText(1001, 11306) .. ReadText(1001, 120), config.standardTextProperties)

	local counter = 1

	local completed = OnlineHasSession()
	local row = ftable:addRow(nil, { bgColor = Helper.color.transparent })
	row[2]:setColSpan(2):createText((completed and "\27G" or "") .. counter .. ". " .. ReadText(1001, 11301) .. (completed and " \27[widget_tick_01]" or ""), config.standardTextProperties)
	row[2].properties.x = 3 * config.standardTextOffsetX
	counter = counter + 1

	completed = C.GetVentureDLCStatus() == 0
	local row = ftable:addRow(nil, { bgColor = Helper.color.transparent })
	row[2]:setColSpan(2):createText((completed and "\27G" or "") .. counter .. ". " .. ReadText(1001, 11358) .. (completed and " \27[widget_tick_01]" or ""), config.standardTextProperties)
	row[2].properties.x = 3 * config.standardTextOffsetX
	counter = counter + 1

	completed = not menu.isStartmenu
	local row = ftable:addRow(nil, { bgColor = Helper.color.transparent })
	row[2]:setColSpan(2):createText((completed and "\27G" or "") .. counter .. ". " .. ReadText(1001, 11302) .. (completed and " \27[widget_tick_01]" or ""), config.standardTextProperties)
	row[2].properties.x = 3 * config.standardTextOffsetX
	counter = counter + 1

	local hasdocks = false
	if not menu.isStartmenu then
		Helper.updateVenturePlatforms()
		for _, entry in ipairs(Helper.ventureplatforms) do
			if #entry.docks > 0 then
				hasdocks = true
			end
		end
	end

	completed = hasdocks
	local row = ftable:addRow(nil, { bgColor = Helper.color.transparent })
	row[2]:setColSpan(2):createText((completed and "\27G" or "") .. counter .. ". " .. ReadText(1001, 11573) .. (completed and " \27[widget_tick_01]" or ""), config.standardTextProperties)
	row[2].properties.x = 3 * config.standardTextOffsetX
	counter = counter + 1

	completed = false
	local row = ftable:addRow(nil, { bgColor = Helper.color.transparent })
	row[2]:setColSpan(2):createText((completed and "\27G" or "") .. counter .. ". " .. ReadText(1001, 11575) .. (completed and " \27[widget_tick_01]" or ""), config.standardTextProperties)
	row[2].properties.x = 3 * config.standardTextOffsetX
	counter = counter + 1

	ftable:setTopRow(menu.preselectTopRow)
	menu.preselectTopRow = nil
	menu.preselectOption = nil

	frame:display()
end

function menu.displayCredits(option)
	-- remove old data
	Helper.clearDataForRefresh(menu, config.optionsLayer)
	menu.selectedOption = nil

	menu.currentOption = option

	if not menu.cutsceneStoppedNotification then
		menu.cutsceneStoppedNotification = true
		NotifyOnCutsceneStopped(getElement("Scene.UIContract"))
	end

	menu.optionsFrame = Helper.createFrameHandle(menu, {
		layer = config.optionsLayer,
		x = 0,
		y = 0,
		width = Helper.viewWidth,
		height = Helper.viewHeight,
		standardButtons = {},
	})

	menu.optionsFrame:addTable(1, { tabOrder = 1 })
	
	menu.optionsFrame:addRenderTarget({ width = Helper.viewWidth, height = Helper.viewHeight, x = 0, y = 0, alpha = 100 })

	menu.optionsFrame:display()
end

function menu.displayInit(text)
	-- close toplevel frame
	Helper.clearFrame(menu, config.topLevelLayer)

	-- remove old data
	Helper.clearDataForRefresh(menu, config.optionsLayer)
	menu.selectedOption = nil

	menu.optionsFrame = Helper.createFrameHandle(menu, {
		x = 0,
		y = 0,
		width = Helper.viewWidth,
		height = Helper.viewHeight,
		layer = config.optionsLayer,
		standardButtons = {},
		playerControls = false,
	})

	local ftable = menu.optionsFrame:addTable(1, { tabOrder = 0, width = math.floor(Helper.viewWidth / 2), x = math.floor(Helper.viewWidth / 4), y = math.floor(Helper.viewHeight / 2) })

	local row = ftable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
	row[1]:createText(text or ReadText(1001, 7230), { halign = "center", font = config.fontBold, fontsize = config.headerFontSize, x = 0, y = 0 })

	ftable.properties.y = math.floor((Helper.viewHeight - ftable:getVisibleHeight()) / 2)

	menu.optionsFrame:display()

	menu.cleanup()
end

function menu.displayEmptyMenu(cleanup)
	-- close toplevel frame
	Helper.clearFrame(menu, config.topLevelLayer)

	-- remove old data
	Helper.clearDataForRefresh(menu, config.optionsLayer)
	menu.selectedOption = nil

	menu.optionsFrame = Helper.createFrameHandle(menu, {
		x = 0,
		y = 0,
		width = Helper.viewWidth,
		height = Helper.viewHeight,
		layer = config.optionsLayer,
		standardButtons = {},
		playerControls = false,
	})

	local ftable = menu.optionsFrame:addTable(1, { tabOrder = 1, width = math.floor(Helper.viewWidth / 2), x = math.floor(Helper.viewWidth / 4), y = math.floor(Helper.viewHeight / 2) })

	local row = ftable:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
	row[1]:createText("", { halign = "center", font = config.fontBold, fontsize = config.headerFontSize, x = 0, y = 0 })

	ftable.properties.y = math.floor((Helper.viewHeight - ftable:getVisibleHeight()) / 2)

	menu.optionsFrame:display()

	if cleanup then
		menu.cleanup()
	end
end


--- Helper hooks ---

function menu.onShowMenu()
	if not menu.isStartmenu then
		if menu.param ~= "toplevel" then
			menu.paused = true
			Pause()
		end
	end

	if menu.param == "toplevel" then
		menu.param = nil
	end
	
	-- put options menu in center position
	menu.width = math.min(Helper.viewWidth, Helper.scaleX(config.frame.width))
	menu.widthExtraWide = math.min(Helper.viewWidth, Helper.scaleX(config.frame.widthExtraWide))
	if menu.isStartmenu then
		menu.width = menu.widthExtraWide
	end
	menu.frameOffsetX = 0
	menu.frameOffsetXExtraWide = 0
	menu.frameOffsetY = 0

	local tableOffsetX = Helper.scaleX(config.table.x)
	menu.table = {
		x =						tableOffsetX,
		y =						Helper.scaleY(config.table.y),
		width =					math.min(Helper.viewWidth - tableOffsetX, Helper.scaleX(config.table.width)),
		widthExtraWide =		math.min(Helper.viewWidth - tableOffsetX, Helper.scaleX(config.table.widthExtraWide)),
		widthWithExtraInfo =	Helper.scaleX(config.table.widthWithExtraInfo),
		arrowColumnWidth =		Helper.scaleY(config.table.arrowColumnWidth), -- sic - so that the arrow button proportions stay correct
		infoColumnWidth =		math.min((Helper.viewWidth - tableOffsetX) / 3, Helper.scaleX(config.table.infoColumnWidth)),
	}

	if not menu.isStartmenu then
		-- top level
		Helper.setTabScrollCallback(menu, menu.onTabScroll)
		registerForEvent("inputModeChanged", getElement("Scene.UIContract"), menu.onInputModeChanged)
		menu.hasInputModeChangedRegistered = true
		menu.frameOffsetX = (Helper.viewWidth - menu.width) / 2
		menu.frameOffsetXExtraWide = (Helper.viewWidth - menu.widthExtraWide) / 2
		menu.frameOffsetY = config.frame.y + menu.createTopLevel()
	end
	menu.height = Helper.viewHeight - menu.frameOffsetY
	menu.table.height = math.min(menu.height - menu.table.y, Helper.scaleY(config.table.height)) - Helper.frameBorder

	C.ReloadSaveList()

	-- restore handling
	if __CORE_GAMEOPTIONS_RESTORE then
		menu.history = __CORE_GAMEOPTIONS_RESTOREINFO.history
		if __CORE_GAMEOPTIONS_RESTOREINFO.optionParameter == "question" then
			local data = __CORE_GAMEOPTIONS_RESTOREINFO.questionParameter
			menu.displayUserQuestion(data.question, menu[data.callback], menu[data.negCallback], data.timer, data.waitforgfx)
		else
			if menu.history[1] then
				local lastOption = menu.history[1]
				table.remove(menu.history, 1)
				menu.preselectTopRow = lastOption.topRow
				menu.preselectOption = lastOption.selectedOption
				menu.submenuHandler(lastOption.optionParameter)
			end
		end
		__CORE_GAMEOPTIONS_RESTORE = nil
		C.SaveUIUserData()
		return
	elseif __CORE_GAMEOPTIONS_RESTOREINFO.returnhistory then
		menu.history = __CORE_GAMEOPTIONS_RESTOREINFO.returnhistory
		__CORE_GAMEOPTIONS_RESTOREINFO.returnhistory = nil
		if menu.history[1] then
			local lastOption = menu.history[1]
			table.remove(menu.history, 1)
			menu.preselectTopRow = lastOption.topRow
			menu.preselectOption = lastOption.selectedOption
			menu.submenuHandler(lastOption.optionParameter)
		end
		return
	end

	if menu.isStartmenu and C.IsLanguageSettingEnabled() and not C.IsLanguageValid() then
		menu.firstlanguageselection = true
		menu.displayLanguageOptions()
	elseif type(menu.param) == "string" then
		menu.submenuHandler(menu.param)
	else
		if not menu.isStartmenu then
			menu.preselectOption = "exit"
		end
		menu.submenuHandler("main")
	end

	if menu.contextMenuMode then
		if not __CORE_DETAILMONITOR_USERQUESTION[menu.contextMenuMode] then
			menu.createContextMenu()
		end
	end
end

function menu.viewCreated(layer, ...)
	if layer == config.optionsLayer then
		if (menu.currentOption == "new") or (menu.currentOption == "multiplayer_server") then
			if menu.playNewGameCutscene then
				menu.titleTable, menu.optionTable, menu.rendertarget, menu.infoTable = ...
			else
				menu.titleTable, menu.optionTable, menu.infoTable = ...
			end
		elseif (menu.currentOption == "extensions") or (menu.currentOption == "bonus") or (menu.currentOption == "privacy") then
			menu.titleTable, menu.optionTable, menu.infoTable = ...
		elseif (menu.currentOption == "credits") or (menu.currentOption == "idle") then
			menu.optionTable, menu.rendertarget = ...
		elseif (menu.currentOption == "save") or (menu.currentOption == "load") or (menu.currentOption == "saveoffline") then
			menu.optionTable, menu.titleTable, menu.infoTable = ...
		else
			menu.optionTable = ...
		end
	elseif layer == config.topLevelLayer then

	end
end

menu.updateInterval = 0.1
function menu.onUpdate()
	local curtime = getElapsedTime()

	-- kuertee start: callback
	local isSaveFileOk = true
	if callbacks ["onUpdate_start"] then
		for _, callback in ipairs (callbacks ["onUpdate_start"]) do
			callback(curtime)
		end
	end
	-- kuertee end: callback

	if menu.animationDelay ~= nil then
		if (not menu.animationDelay[3]) and (curtime > menu.animationDelay[1] - menu.animationDelay[4]) then
			menu.animationDelay[3] = true
			C.FadeScreen(menu.animationDelay[4], 0)
			C.StopVoiceSequence()
			if menu.isStartmenu then
				C.StartStartMenuBGMusic()
			end
		end
		if curtime > menu.animationDelay[1] then
			if menu.currentOption == "multiplayer_server" then
				C.NewMultiplayerGame(menu.animationDelay[2].id)
			else
				NewGame(menu.animationDelay[2].id)
			end
			menu.closeMenu("close")
		end
	elseif C.IsTradeShowVersion() and (menu.currentOption ~= "idle") and (menu.idleTimer + config.idleTime < curtime) then
		if menu.isStartmenu then
			menu.openSubmenu("idle", menu.selectedOption.id)
		end
	else
		if menu.delayedRefresh and (menu.delayedRefresh < curtime) then
			menu.delayedRefresh = nil
			if menu.currentOption ~= "question" then
				menu.refresh()
				return
			end
		end

		if menu.lastSaveUpdateTime + config.saveReloadInterval < curtime then
			menu.autoReloadSave = menu.nameContinue()
			menu.lastSaveUpdateTime = curtime
			menu.savegames = nil
			menu.onlinesave = nil
			C.ReloadSaveList()
			if (menu.currentOption == "save") or (menu.currentOption == "load") or (menu.currentOption == "saveoffline") then
				menu.delayedRefresh = curtime
				return
			end
		end

		local saveloadingcompleted = false
		if menu.savegames == nil then
			if C.IsSaveListLoadingComplete() then
				menu.savegames = GetSaveList(Helper.validSaveFilenames)
				menu.onlinesave = nil
				for _, save in ipairs(menu.savegames) do
					if save.isonline and (save.filename == "online_save") then
						menu.onlinesave = save
						break
					end
				end
				if next(menu.savegames) then
					table.sort(menu.savegames, function (a, b) return a.rawtime > b.rawtime end)
				end
				saveloadingcompleted = true
				menu.autoReloadSave = nil
			end
		end

		if menu.currentOption == "main" then
			if saveloadingcompleted then
				-- rebuild the menu (since the current rows are simple (aka: fontstring/unselectable) rows and we cannot just reset them to selectable ones
				-- TODO: #Florian - add support to change whether a row is selectable or not and then replace rebuilding the menu here with simply adjusting the two relevant rows
				menu.preselectOption = Helper.getCurrentRowData(menu, menu.optionTable).id
				menu.submenuHandler("main")
				return
			end
		elseif (menu.currentOption == "new") or (menu.currentOption == "multiplayer_server") then
			if menu.playNewGameCutscene and menu.playNewGameCutscene.movie then
				if not menu.playNewGameCutscene.cutsceneid then
					menu.playNewGameCutscene.cutscenedesc = CreateCutsceneDescriptor(menu.playNewGameCutscene.movie, {})
					menu.playNewGameCutscene.cutsceneid = StartCutscene(menu.playNewGameCutscene.cutscenedesc, GetRenderTargetTexture(menu.rendertarget))
					if menu.playNewGameCutscene.movievoice ~= "" then
						C.StartVoiceSequence2(menu.playNewGameCutscene.movievoice, 0, menu.selectedOption.id)
					end
				end
			end
			if menu.newGameCutsceneTimer and (menu.newGameCutsceneTimer + 1 < curtime) then
				menu.newGameCutsceneTimer = nil
				if menu.selectedOption and (menu.selectedOption.cutscene ~= "") then
					menu.playNewGameCutscene = { id = menu.selectedOption.id, movie = menu.selectedOption.cutscene, movievoice = menu.selectedOption.cutscenevoice }
					menu.refresh()
				end
			end
		elseif menu.currentOption == "lobby" then
			if menu.updateServers then
				menu.drawLobby()
				menu.updateServers = false
			end
		elseif menu.currentOption == "online" then
			if menu.onlineRefresh then
				menu.onlineRefresh = nil
				menu.preselectTopRow = GetTopRow(menu.optionTable)
				menu.preselectOption = menu.preselectOption or Helper.currentTableRow[menu.optionTable]
				menu.displayOnlineLogin()
			end
			if menu.activatePasswordEditBox then
				SelectRow(menu.optionTable, 5)
				Helper.activateEditBox(menu.optionTable, 5, 7)
				menu.activatePasswordEditBox = nil
			end
		elseif menu.currentOption == "credits" then
			if not menu.cutsceneid then
				menu.cutscenedesc = CreateCutsceneDescriptor("credits_movie", {})
				menu.cutsceneid = StartCutscene(menu.cutscenedesc, GetRenderTargetTexture(menu.rendertarget))
				if menu.isStartmenu then
					C.SetSceneCameraActive(false)
					C.StopStartMenuBGMusic()
				end
			end
		elseif menu.currentOption == "idle" then
			if not menu.cutsceneid then
				menu.cutscenedesc = CreateCutsceneDescriptor("idle_movie", {})
				menu.cutsceneid = StartCutscene(menu.cutscenedesc, GetRenderTargetTexture(menu.rendertarget))
				C.StopStartMenuBGMusic()
			end
		elseif menu.currentOption == "question" then
			if menu.questionEditBox then
				ActivateEditBox(menu.questionEditBox.id)
				menu.questionEditBox = nil
			end
		end
		if menu.userQuestion and menu.userQuestion.timer then
			if curtime >= menu.userQuestion.timer then
				if menu.userQuestion.negCallback then
					menu.userQuestion.negCallback()
				else
					menu.onCloseElement("back")
				end
			end
		end

		menu.optionsFrame:update()
		if menu.contextFrame then
			menu.contextFrame:update()
		end
	end
end

function menu.onRowChanged(row, rowdata, uitable, modified, input, source)
	local curtime = getElapsedTime()
	menu.idleTimer = curtime
	if uitable == menu.optionTable then
		menu.selectedOption = rowdata
		if (menu.currentOption == "new") or (menu.currentOption == "multiplayer_server") then
			if menu.playNewGameCutscene and menu.playNewGameCutscene.cutsceneid then
				-- cutscene was playing and we changed row, kill cutscene
				StopCutscene(menu.playNewGameCutscene.cutsceneid)
				C.StopVoiceSequence()
				if menu.isStartmenu then
					C.StartStartMenuBGMusic()
				end
			end
			if menu.isStartmenu then
				if (not menu.playNewGameCutscene) or (menu.playNewGameCutscene.id ~= menu.selectedOption.id) then
					-- init timer to display next cutscene
					menu.newGameCutsceneTimer = curtime
					if menu.selectedOption and (menu.selectedOption.cutscene ~= "") then
						-- disabled due to gamestart videos not having their own music
						--C.StopStartMenuBGMusic()
					else
						C.StartStartMenuBGMusic()
					end
					-- reset id so swapping back to that id resets the timer correctly
					if menu.playNewGameCutscene and menu.playNewGameCutscene.movie then
						menu.playNewGameCutscene = nil
						menu.delayedRefresh = curtime
					end
				end
			end
			if source ~= "auto" then
				menu.delayedRefresh = curtime
			end
		elseif menu.currentOption == "language" then
			if menu.selectedOption then
				local languageWarning = ""
				local languageFont = config.font
				if menu.selectedOption.id ~= menu.languagedata.curID then
					for _, language in ipairs(menu.languagedata) do
						if language.id == menu.selectedOption.id then
							languageWarning = language.warning
							if language.font ~= "" then
								languageFont = language.font
							end
						end
					end
				end
				SetCellContent(menu.optionTable, Helper.createFontString(languageWarning, true, "left", 255, 0, 0, 100, languageFont, config.infoFontSize, false, config.infoTextOffsetX, 0, config.infoTextHeight), 2, 1)
			end
		elseif (menu.currentOption == "save") or (menu.currentOption == "load") or (menu.currentOption == "saveoffline") then
			if menu.selectedOption and next(menu.selectedOption) and (menu.selectedOption.titlerow == nil) and (menu.selectedOption.submenu == nil) then
				if (menu.currentOption == "save") or (menu.currentOption == "saveoffline") then
					menu.savegameName = menu.getNewSavegameName(menu.selectedOption)
					C.SetEditBoxText(menu.saveNameEditBox.id, menu.savegameName)
				end
			else
				if (menu.currentOption == "save") or (menu.currentOption == "saveoffline") then
					menu.savegameName = ""
					C.SetEditBoxText(menu.saveNameEditBox.id, menu.savegameName)
				end
			end
			if source ~= "auto" then
				menu.delayedRefresh = curtime
			end
		end
	end
end

function menu.newGameCallback(option, checked)
	if menu.playNewGameCutscene and menu.playNewGameCutscene.cutsceneid then
		StopCutscene(menu.playNewGameCutscene.cutsceneid)
		C.StopVoiceSequence()
		if menu.playNewGameCutscene.cutscenedesc then
			ReleaseCutsceneDescriptor(menu.playNewGameCutscene.cutscenedesc)
		end
		menu.playNewGameCutscene = {}
	end
	if menu.isStartmenu and (option.intro ~= "") then
		menu.animationDelay = { getElapsedTime() + option.introlength + option.introfadeoutlength, option, false, option.introfadeoutlength }
		menu.displayEmptyMenu()
		C.StartIntroAnimation(option.intro)
		if option.introvoice ~= "" then
			C.StartVoiceSequence2(option.introvoice, 0, option.id)
		end
	else
		if option.customeditor then
			table.insert(menu.history, 1, { optionParameter = menu.currentOption, topRow = GetTopRow(menu.optionTable), selectedOption = option.id })
			__CORE_GAMEOPTIONS_RESTOREINFO.returnhistory = menu.history
			Helper.closeMenuAndOpenNewMenu(menu, "CustomGameMenu", { 0, 0, option.id, menu.currentOption == "multiplayer_server", option.id == "custom_creative", menu.paused ~= nil })
			menu.cleanup()
		else
			local playerinventory = GetPlayerInventory()
			local onlineitems = OnlineGetUserItems()

			local hasnotuploadeditems = false
			for ware, waredata in Helper.orderedPairs(playerinventory) do
				local isbraneitem, isoperationvolatile, isseasonvolatile, isventureuploadallowed = GetWareData(ware, "isbraneitem", "isoperationvolatile", "isseasonvolatile", "isventureuploadallowed")
				if isbraneitem then
					local serveramount = 0
					if onlineitems[ware] then
						serveramount = onlineitems[ware].amount
					end
					if isventureuploadallowed and (waredata.amount > serveramount) then
						hasnotuploadeditems = true
						break
					end
				end
			end

			if (not checked) and (not menu.isStartmenu) and Helper.isOnlineGame() and hasnotuploadeditems then
				table.insert(menu.history, 1, { optionParameter = menu.currentOption, topRow = GetTopRow(menu.optionTable), selectedOption = option.id })
				menu.displayUserQuestion(ReadText(1001, 2603) .. " - " .. ReadText(1001, 7720), function () return menu.newGameCallback(option, true) end, nil, nil, nil, nil, nil, ReadText(1001, 11707))
			else
				if menu.currentOption == "multiplayer_server" then
					C.NewMultiplayerGame(option.id)
				else

				-- kuertee start: callback
				if callbacks ["newGameCallback_preNewGame"] then
					for _, callback in ipairs (callbacks ["newGameCallback_preNewGame"]) do
						callback(option.id)
					end
				end
				-- kuertee end: callback

					NewGame(option.id)
				end
				menu.displayInit()
			end
		end
	end
end

function menu.onSelectElement(uitable, modified, row)
	row = row or Helper.currentTableRow[uitable]
	if uitable == menu.optionTable then
		local option = menu.rowDataMap[uitable][row]
		if (menu.currentOption == "new") or (menu.currentOption == "multiplayer_server") then
			menu.buttonStartGame(option)
		elseif menu.currentOption == "load" then
			if option and next(option) and option.filename and ((not option.error and not option.invalidpatches and not option.invalidversion and not option.invalidgameid) or IsCheatVersion()) then
				menu.loadGameCallback(option.filename, false)
			end
		elseif (menu.currentOption == "save") or (menu.currentOption == "saveoffline") then
			if option and next(option) then
				if option.submenu then
					if option.submenu == "saveoffline" then
						menu.openSubmenu("saveoffline", option.submenu)
					end
				else
					menu.buttonOverwriteSave()
				end
			end
		elseif menu.currentOption == "lobby" then
			if option and next(option) then
				C.ConnectToMultiplayerGame(option.address)
				menu.closeMenu("close")
			end
		elseif menu.currentOption == "extensions" then
			if option == "defaults" then
				table.insert(menu.history, 1, { optionParameter = menu.currentOption, topRow = GetTopRow(menu.optionTable), selectedOption = option })
				menu.displayUserQuestion(ReadText(1001, 2653), menu.callbackExtensionDefaults)
			elseif option == "workshop" then
				OpenWorkshop("", false)
			elseif option and next(option) then
				menu.selectedExtension = option
				menu.openSubmenu("extensionsettings", option.id)
			end
		elseif menu.currentOption == "bonus" then
			if option and next(option) then
				if option.owned then
					if option.optional and not option.changed then
						if option.installed then
							UninstallSteamDLC(option.appid)
						else
							InstallSteamDLC(option.appid)
						end
						menu.preselectOption = option.appid
						menu.displayBonusContent()
					end
				else
					OpenSteamOverlayStorePage()
				end
			end
		elseif menu.currentOption == "profile_load" then
			if option and next(option) and (not option.empty) then
				table.insert(menu.history, 1, { optionParameter = menu.currentOption, topRow = GetTopRow(menu.optionTable), selectedOption = option.id })
				menu.displayUserQuestion(ReadText(1001, 4859) .. " - \"" .. option.name .. "\"", function () return menu.callbackInputProfileLoad(option) end)
			end
		elseif menu.currentOption == "language" then
			if option and next(option) then
				menu.requestLanguageID(option.id)
				if menu.firstlanguageselection then
					menu.submenuHandler("main")
				else
					menu.onCloseElement("back")
				end
			end
		elseif menu.currentOption == "question" then
			if option and next(option) then
				if option.positive then
					menu.userQuestion.callback(menu.userQuestion.hasEditBox and menu.userQuestion.editboxText or nil)
					menu.userQuestion = nil
				else
					if menu.userQuestion.negCallback then
						menu.userQuestion.negCallback()
					else
						menu.onCloseElement("back")
					end
				end
			end
		elseif type(option) == "table" then
			if option.callback then
				option.callback()
				return
			elseif option.submenu then
				menu.openSubmenu(option.submenu, option.id)
			end
		end
	end
end

function menu.onEditBoxActivated()
	if menu.currentOption == "question" then
		menu.userQuestion.oldEditboxText = menu.userQuestion.editboxText
	end
end

function menu.onEditboxUpdateText(editbox, text, textchanged, wasconfirmed)
	if menu.currentOption == "question" then
		if wasconfirmed then
			menu.userQuestion.callback(menu.userQuestion.hasEditBox and menu.userQuestion.editboxText or nil)
			menu.userQuestion = nil
		else
			menu.userQuestion.editboxText = menu.userQuestion.oldEditboxText
			Helper.updateEditBoxText(menu.optionTable, 2, 3, menu.userQuestion.editboxText)
		end
	end
end

function menu.getExplicitSavegameName(savegame, checklastsave)
	if not savegame.empty then
		if savegame.description and (savegame.description ~= "") then
			return savegame.description
		elseif savegame.name ~= "" then
			local find_start, find_end = string.find(savegame.name, "#[0-9][0-9][0-9]")
			if (find_start ~= 1) or (find_end ~= #savegame.name) then
				local lastsaveinfo = C.GetLastSaveInfo()
				if (not checklastsave) or (ffi.string(lastsaveinfo.name) == savegame.name) then
					return savegame.name
				end
			end
		end
	end
	return nil
end

function menu.getNewSavegameName(savegame)
	return menu.getExplicitSavegameName(savegame, true) or ffi.string(C.GetSaveLocationName())
end

function menu.getLatestOnlineSave()
	local entry = nil
	-- Currently, for consistency, only consider online autosaves if *the* online save exists
	if menu.onlinesave then
		-- consider any online save in correct online save slot (which includes menu.onlinesave)
		for _, savegame in ipairs(menu.savegames) do
			if savegame.isonline and savegame.isonlinesavefilename then
				-- remember the latest one
				if (entry == nil) or (savegame.rawtime > entry.rawtime) then
					entry = savegame
				end
			end
		end
	end
	return entry
end

function menu.closeMenu(dueToClose)
	Helper.closeMenu(menu, dueToClose)
	menu.cleanup()
end

function menu.closeContextMenu()
	if menu.contextMenuMode then
		menu.contextFrame = nil
		Helper.clearFrame(menu, config.contextLayer)

		if menu.contextMenuMode == "remap" then
			if menu.remapControl then
				-- reload controls menu
				menu.preselectTopRow = GetTopRow(menu.optionTable)
				menu.preselectOption = menu.remapControl.row
				menu.preselectCol = menu.remapControl.col
				menu.remapControl = nil
				menu.submenuHandler(menu.currentOption)
			end
		elseif menu.contextMenuMode == "ventureextension" then
			if menu.contextMenuData.saveOption then
				OnlineSetVentureConfig("disable_popup", true)
			end
		end

		menu.contextMenuData = {}
		menu.contextMenuMode = nil
	end
end

function menu.onCloseElement(dueToClose)
	if menu.animationDelay ~= nil then
		local curtime = getElapsedTime()
		if (not menu.animationDelay[3]) and (curtime < menu.animationDelay[1] - menu.animationDelay[4]) then
			menu.animationDelay[1] = curtime + menu.animationDelay[4]
		end
		return
	end

	if menu.contextMenuMode then
		menu.closeContextMenu()
		if not Helper.closeOptionsMenu then
			return
		end
	end

	if menu.cutsceneid then
		StopCutscene(menu.cutsceneid)
		menu.cutsceneid = nil
		if menu.isStartmenu then
			C.SetSceneCameraActive(true)
			C.StartStartMenuBGMusic()
		end
	end
	if menu.playNewGameCutscene and menu.playNewGameCutscene.cutsceneid then
		StopCutscene(menu.playNewGameCutscene.cutsceneid)
		C.StopVoiceSequence()
		menu.playNewGameCutscene.id = nil
	end
	if (menu.currentOption == "new") or (menu.currentOption == "multiplayer_server") then
		if menu.isStartmenu then
			C.StartStartMenuBGMusic()
		end
	end

	if dueToClose == "close" then
		if menu.userQuestion and menu.userQuestion.negCallback then
			menu.userQuestion.negCallback()
		end
		if menu.remapControl then
			menu.unregisterDirectInput()
			if menu.remapControl.oldinputcode ~= -1 then
				menu.removeInput()
			end
			menu.remapControl = nil
		else
			if menu.isStartmenu and (not Helper.closeOptionsMenu) then
				menu.submenuHandler("main")
			else
				menu.closeMenu("close")
			end
		end
	elseif dueToClose == "auto" then
		if menu.userQuestion and menu.userQuestion.negCallback then
			menu.userQuestion.negCallback()
		end
		if menu.remapControl then
			menu.unregisterDirectInput()
			menu.remapControl = nil
		end
		menu.closeMenu("close")
	else
		if menu.remapControl then
			menu.unregisterDirectInput()
			menu.remapControl = nil
		end
		if menu.currentOption == "main" then
			if menu.isStartmenu then
				menu.openSubmenu("quit", "quit")
			else
				menu.closeMenu(dueToClose)
			end
		else
			if menu.userQuestion and menu.userQuestion.negCallback then
				menu.userQuestion.negCallback()
			else
				local lastOption = menu.history[1]
				if lastOption then
					table.remove(menu.history, 1)
					menu.preselectTopRow = lastOption.topRow
					menu.preselectOption = lastOption.selectedOption
					menu.submenuHandler(lastOption.optionParameter)
				else
					menu.closeMenu(dueToClose)
				end
			end
		end
	end
end

-- kuertee start:
function menu.registerCallback(callbackName, callbackFunction)
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
			if callbacks[callbackName][1] == callbackFunction then
				table.remove(callbacks[callbackName], i)
			end
		end
	end
end

function menu.loadModLuas()
	if Helper then
		Helper.loadModLuas(menu.name, "gameoptions_uix")
	end
end
-- kuertee end

-- kuertee start: create gameIds and tag save games with it
-- used for alternative to death's ironman mode: load and save with one save file
-- requires SN MSAPIs
GameIdManager.ffi = require("ffi")
GameIdManager.C = GameIdManager.ffi.C

GameIdManager.ffi.cdef[[
    typedef uint64_t UniverseID;
    UniverseID GetPlayerID(void);
]]

function GameIdManager.init()
	local optionsMenu = Helper.getMenu("OptionsMenu")
	optionsMenu.registerCallback("newGameCallback_preNewGame", GameIdManager.setPendingGameStart)
	optionsMenu.registerCallback("submenuHandler_preDisplayOptions", GameIdManager.unsetPendingGameStart)
	optionsMenu.registerCallback("submenuHandler_preDisplayOptions", GameIdManager.unsetPendingLoadGame)
	optionsMenu.registerCallback("addSavegameRow_changeSaveGameDisplayName", GameIdManager.changeSaveGameName)
	optionsMenu.registerCallback("loadGameCallback_preLoadGame", GameIdManager.setPendingLoadGame)
	optionsMenu.registerCallback("callbackDeleteSave_onDeleteSave", GameIdManager.onDeleteSave)
	Helper.registerCallback("onUpdate", GameIdManager.onUpdate_detectGameStart)

	-- optionsMenu.registerCallback("callbackSave_onSaveGame", GameIdManager.onSaveGame)
	-- callbackSave() is only for normal saves.
	-- there is no trigger for autosaves and quicksaves.
	-- MD.Notifications.kUIX_OnSaveGame raises the kUIX.OnSaveGame event so that the last game saved (autosave, quicksave, or normal save) is tagged with a game id.
	RegisterEvent ("kUIX.OnSaveGame", GameIdManager.onSaveGame_FromMD)
end

function GameIdManager.setPendingGameStart(gamestart)
	Helper.debugText("setPendingGameStart", gamestart)
	GameIdManager.writeToUIXModData("pendingGameStart", gamestart)
end

function GameIdManager.unsetPendingGameStart()
	GameIdManager.writeToUIXModData("pendingGameStart", nil)
end

function GameIdManager.setPendingLoadGame(filename)
	Helper.debugText("setPendingLoadGame", filename)
	GameIdManager.writeToUIXModData("pendingLoadGame", filename)
end

function GameIdManager.unsetPendingLoadGame()
	GameIdManager.writeToUIXModData("pendingLoadGame", nil)
end

function GameIdManager.onUpdate_detectGameStart()
	-- when playerId is populated, then a game has started
	-- local savedPlayerId = GameIdManager.readFromUIXModData("playerId")
	local playerId = ConvertStringTo64Bit(tostring (GameIdManager.C.GetPlayerID()))
	-- if savedPlayerId ~= playerId then
		GameIdManager.writeToUIXModData("playerId", playerId)
		Helper.debugText("playerId", playerId)
		if playerId and playerId > 0 then
			local pendingGameStart = GameIdManager.readFromUIXModData("pendingGameStart")
			local pendingLoadGame = GameIdManager.readFromUIXModData("pendingLoadGame")
			Helper.debugText("pendingGameStart", pendingGameStart)
			Helper.debugText("pendingLoadGame", pendingLoadGame)
			GameIdManager.unsetPendingGameStart()
			GameIdManager.unsetPendingLoadGame()
			if pendingGameStart then
				-- a game start was highlighted JUST before the game started
				-- assume a new game started
				GameIdManager.onNewGame()
			elseif pendingLoadGame then
				-- a filename was highlighted JUST before the game started
				-- assume a game was loaded
				GameIdManager.onLoadGame(pendingLoadGame)
			end
		else
			GameIdManager.onMainMenu()
		end
		Helper.deregisterCallback("onUpdate", GameIdManager.onUpdate_detectGameStart)
	-- end
end

function GameIdManager.onDeleteSave(filename)
	GameIdManager.tagSaveGameWithGameId(filename, nil)
end

function GameIdManager.writeToUIXModData(key, value)
	local owner = "kuertee_uix"
	__MOD_USERDATA = __MOD_USERDATA or {}
	if __MOD_USERDATA[owner] == nil then
		__MOD_USERDATA[owner] = {}
	end
	if type(__MOD_USERDATA[owner][key]) == "table" then
		__MOD_USERDATA[owner][key] = 0
	else
		__MOD_USERDATA[owner][key] = nil
	end
	-- Helper.debugText("delete previous owner: " .. tostring(owner) .. " key: " .. tostring(key) .. " value:", __MOD_USERDATA[owner][key])
	__MOD_USERDATA[owner][key] = value
	-- Helper.debugText("save new owner: " .. tostring(owner) .. " key: " .. tostring(key) .. " value:", __MOD_USERDATA[owner][key])
end

function GameIdManager.readFromUIXModData(key)
	local owner = "kuertee_uix"
	local value
	local isSuccess, errorMsg = pcall(function () value = __MOD_USERDATA[owner][key] end)
	if isSuccess then
		-- Helper.debugText("owner: " .. tostring(owner) .. " key: " .. tostring(key) .. " value:", value)
		return value
	else
		if key ~= "playerId" or (not string.find(errorMsg, "attempt to index a nil value")) then
			Helper.debugText("errorMsg: " .. tostring(errorMsg))
			Helper.debugText("    owner: " .. tostring(owner) .. " key: " .. tostring(key) .. " value:", value)
		end
		return nil
	end
end

function GameIdManager.getNewGameId()
	local gameIdsBySaveGame = GameIdManager.readFromUIXModData("gameIdsBySaveGame")
	if type(gameIdsBySaveGame) ~= "table" then
		gameIdsBySaveGame = {}
	end
	local filenamesByGameId = {}
	for filename, gameId in pairs(gameIdsBySaveGame) do
		filenamesByGameId[gameId] = filename
	end
	Helper.debugText("filenamesByGameId", filenamesByGameId)
	local i = 1
	Helper.debugText("filenamesByGameId[UIXGameId_1]", filenamesByGameId["UIXGameId_" .. tostring(i)])
	while (filenamesByGameId["UIXGameId_" .. tostring(i)] ~= nil) do
		i = i + 1
	end
	local gameId = "UIXGameId_" .. tostring(i)
	return gameId
end

function GameIdManager.saveCurrentGameId(gameId)
	Helper.debugText("gameId", gameId)
	GameIdManager.writeToUIXModData("gameId", gameId)
end

function GameIdManager.getCurrentGameId()
	local gameId
	-- local playerId = ConvertStringTo64Bit(tostring (GameIdManager.C.GetPlayerID()))
	-- if playerId and playerId > 0 then
		gameId = GameIdManager.readFromUIXModData("gameId")
	-- end
	return gameId
end

function GameIdManager.getGameIdFromSaveGame(filename)
	local gameIdsBySaveGame = GameIdManager.readFromUIXModData("gameIdsBySaveGame")
	if type(gameIdsBySaveGame) ~= "table" then
		gameIdsBySaveGame = {}
	end
	local gameId = gameIdsBySaveGame[filename]
	Helper.debugText("gameId", gameId)
	return gameId
end

function GameIdManager.tagSaveGameWithGameId(filename, gameId, isCurrentSaveGame)
	Helper.debugText_forced("filename", filename)
	Helper.debugText_forced("gameId", gameId)
	GameIdManager.saveCurrentGameId(gameId)
	local gameIdsBySaveGame = GameIdManager.readFromUIXModData("gameIdsBySaveGame")
	if type(gameIdsBySaveGame) ~= "table" then
		gameIdsBySaveGame = {}
	end
	gameIdsBySaveGame[filename] = gameId
	GameIdManager.writeToUIXModData("gameIdsBySaveGame", gameIdsBySaveGame)
	GameIdManager.saveGamesForGameId = GameIdManager.getSaveGamesForGameId(gameId)
	if isCurrentSaveGame == true then
		GameIdManager.writeToUIXModData("currentSaveGame", filename)
	end
end

function GameIdManager.getSaveGamesForGameId(gameId)
	local saveGamesForGameId = {}
	local savegames = GetSaveList(Helper.validSaveFilenames)
	Helper.debugText("#savegames", #savegames)
	if savegames and #savegames then
		table.sort(savegames, function (a, b) return a.rawtime > b.rawtime end)
		for i, savegame in ipairs(savegames) do
			local gameId_fromSaveGame = GameIdManager.getGameIdFromSaveGame(savegame.filename)
			if gameId == gameId_fromSaveGame then
				table.insert(saveGamesForGameId, savegame)
			end
		end
	end
	return saveGamesForGameId
end

function GameIdManager.onMainMenu()
	-- main menu, get game id from most recent saved game
	local savegames = GetSaveList(Helper.validSaveFilenames)
	-- Helper.debugText_forced("#savegames", #savegames)
	if savegames and #savegames > 0 then
		table.sort(savegames, function (a, b) return a.rawtime > b.rawtime end)
		local gameId = GameIdManager.getGameIdFromSaveGame(savegames[1].filename)
		Helper.debugText_forced("gameId (from most recent save game)", gameId)
		GameIdManager.writeToUIXModData("gameId", gameId)
	end
	GameIdManager.writeToUIXModData("currentSaveGame", nil)
end

function GameIdManager.onNewGame()
	-- new game, generate new game id
	local gameId = GameIdManager.getNewGameId()
	Helper.debugText_forced("gameId (new game)", gameId)
	GameIdManager.writeToUIXModData("gameId", gameId)
end

function GameIdManager.onLoadGame(filename)
	-- loaded game, get game id from loaded game
	local gameId = GameIdManager.getGameIdFromSaveGame(filename)
	Helper.debugText_forced("gameId (loaded game)", gameId)
	if not gameId then
		gameId = GameIdManager.getNewGameId()
		Helper.debugText_forced("gameId (untagged, get new)", gameId)
		GameIdManager.writeToUIXModData("gameId", gameId)
	end
	local isCurrentSaveGame = true
	GameIdManager.tagSaveGameWithGameId(filename, gameId, isCurrentSaveGame)
end

-- function GameIdManager.onSaveGame(savegame, name)
-- 	-- callbackSave() is only for normal saves.
-- 	-- there is no trigger for autosaves and quicksaves.
-- 	-- MD.Notifications.kUIX_OnSaveGame raises the kUIX.OnSaveGame event so that the last game saved (autosave, quicksave, or normal save) is tagged with a game id.
-- 	local gameId = GameIdManager.getCurrentGameId()
-- 	if gameId then
-- 		Helper.debugText_forced("savegame.filename", savegame.filename)
-- 		Helper.debugText_forced("gameId", gameId)
-- 		if gameId then
-- 			GameIdManager.tagSaveGameWithGameId(savegame.filename, gameId)
-- 		end
-- 	end
-- end

function GameIdManager.onSaveGame_FromMD()
	-- callbackSave() is only for normal saves.
	-- there is no trigger for autosaves and quicksaves.
	-- MD.Notifications.kUIX_OnSaveGame raises the kUIX.OnSaveGame event so that the last game saved (autosave, quicksave, or normal save) is tagged with a game id.
	local gameId = GameIdManager.getCurrentGameId()
	-- Helper.debugText_forced("gameId", gameId)
	if gameId then
		local savegames = GetSaveList(Helper.validSaveFilenames)
		-- Helper.debugText_forced("#savegames", #savegames)
		if savegames and #savegames then
			table.sort(savegames, function(a, b) return a.rawtime > b.rawtime end)
			-- Helper.debugText_forced("savegames[1].filename", savegames[1].filename)
			local isCurrentSaveGame = true
			GameIdManager.tagSaveGameWithGameId(savegames[1].filename, gameId, isCurrentSaveGame)
		end
	end
end

function GameIdManager.changeSaveGameName(ftable, savegame, name, slot, name)
	local optionsMenu = Helper.getMenu("OptionsMenu")
	if optionsMenu.currentOption == "load" or optionsMenu.currentOption == "save" then
		local gameId = GameIdManager.getCurrentGameId()
		Helper.debugText_forced("gameId", gameId)
		if gameId then
			if gameId then
				local gameIdInSaveGame = GameIdManager.getGameIdFromSaveGame(savegame.filename)
				Helper.debugText("gameIdInSaveGame", gameIdInSaveGame)
				if gameId == gameIdInSaveGame then
					-- <t id="3401">current</t>
					local currentSaveGame = GameIdManager.readFromUIXModData("currentSaveGame")
					if savegame.filename == currentSaveGame then
						name = "* " .. name
					end
					name = Helper.convertColorToText(Helper.color.green) .. name .. "\27X"
				-- elseif gameIdInSaveGame then
				-- 	name = Helper.convertColorToText(Helper.color.blue) .. name .. "\27X"
				end
			end
		end
	end
	return name
end
-- kuertee end: create gameIds and tag save games with it

init()
