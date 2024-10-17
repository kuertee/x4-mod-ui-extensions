-- param == { 0, 0 }

-- modes:

-- ffi setup
local ffi = require("ffi")
local C = ffi.C
ffi.cdef[[
	typedef uint64_t BuildTaskID;
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
		bool possible;
	} DroneModeInfo;
	typedef struct {
		UniverseID softtargetID;
		const char* softtargetConnectionName;
		uint32_t messageID;
	} SofttargetDetails2;
	typedef struct {
		const char* file;
		const char* icon;
		bool ispersonal;
	} UILogo;
	typedef struct {
		UniverseID contextid;
		const char* path;
		const char* group;
	} UpgradeGroup2;
	typedef struct {
		UniverseID currentcomponent;
		const char* currentmacro;
		const char* slotsize;
		uint32_t count;
		uint32_t operational;
		uint32_t total;
	} UpgradeGroupInfo;
	bool CanActivateSeta(bool checkcontext);
	bool CanCancelConstruction(UniverseID containerid, BuildTaskID id);
	bool CanContainerEquipShip(UniverseID containerid, UniverseID shipid);
	bool CanContainerSupplyShip(UniverseID containerid, UniverseID shipid);
	bool CanPerformLongRangeScan(void);
	bool CanPlayerStandUp(void);
	bool CanStartTravelMode(UniverseID objectid);
	uint32_t GetAllLaserTowers(AmmoData* result, uint32_t resultlen, UniverseID defensibleid);
	uint32_t GetAllMines(AmmoData* result, uint32_t resultlen, UniverseID defensibleid);
	uint32_t GetAllNavBeacons(AmmoData* result, uint32_t resultlen, UniverseID defensibleid);
	uint32_t GetAllResourceProbes(AmmoData* result, uint32_t resultlen, UniverseID defensibleid);
	uint32_t GetAllSatellites(AmmoData* result, uint32_t resultlen, UniverseID defensibleid);
	double GetBuildProcessorEstimatedTimeLeft(UniverseID buildprocessorid);
	uint32_t GetBuildTasks(BuildTaskInfo* result, uint32_t resultlen, UniverseID containerid, UniverseID buildmoduleid, bool isinprogress, bool includeupgrade);
	const char* GetComponentName(UniverseID componentid);
	UniverseID GetContextByClass(UniverseID componentid, const char* classname, bool includeself);
	const char* GetCurrentAmmoOfWeapon(UniverseID weaponid);
	const char* GetCurrentDroneMode(UniverseID defensibleid, const char* dronetype);
	UILogo GetCurrentPlayerLogo(void);
	uint32_t GetDefensibleActiveWeaponGroup(UniverseID defensibleid, bool primary);
	uint32_t GetDockedShips(UniverseID* result, uint32_t resultlen, UniverseID dockingbayorcontainerid, const char* factionid);
	uint32_t GetDroneModes(DroneModeInfo* result, uint32_t resultlen, UniverseID defensibleid, const char* dronetype);
	UniverseID GetEnvironmentObject();
	const char* GetGameStartName();
	uint32_t GetNumAllLaserTowers(UniverseID defensibleid);
	uint32_t GetNumAllMines(UniverseID defensibleid);
	uint32_t GetNumAllNavBeacons(UniverseID defensibleid);
	uint32_t GetNumAllResourceProbes(UniverseID defensibleid);
	uint32_t GetNumAllSatellites(UniverseID defensibleid);
	uint32_t GetNumBuildTasks(UniverseID containerid, UniverseID buildmoduleid, bool isinprogress, bool includeupgrade);
	uint32_t GetNumDockedShips(UniverseID dockingbayorcontainerid, const char* factionid);
	uint32_t GetNumDroneModes(UniverseID defensibleid, const char* dronetype);
	uint32_t GetNumStoredUnits(UniverseID defensibleid, const char* cat, bool virtualammo);
	uint32_t GetNumUnavailableUnits(UniverseID defensibleid, const char* cat);
	uint32_t GetNumUpgradeGroups(UniverseID destructibleid, const char* macroname);
	size_t GetNumUpgradeSlots(UniverseID destructibleid, const char* macroname, const char* upgradetypename);
	const char* GetObjectIDCode(UniverseID objectid);
	const char* GetPlayerCurrentControlGroup(void);
	UniverseID GetPlayerID(void);
	UniverseID GetPlayerObjectID(void);
	UniverseID GetPlayerOccupiedShipID(void);
	SofttargetDetails2 GetSofttarget2(void);
	const char* GetSubordinateGroupAssignment(UniverseID controllableid, int group);
	float GetTextHeight(const char*const text, const char*const fontname, const float fontsize, const float wordwrapwidth);
	UniverseID GetTopLevelContainer(UniverseID componentid);
	const char* GetTurretGroupMode2(UniverseID defensibleid, UniverseID contextid, const char* path, const char* group);
	bool GetUp(void);
	UpgradeGroupInfo GetUpgradeGroupInfo2(UniverseID destructibleid, const char* macroname, UniverseID contextid, const char* path, const char* group, const char* upgradetypename);
	uint32_t GetUpgradeGroups2(UpgradeGroup2* result, uint32_t resultlen, UniverseID destructibleid, const char* macroname);
	UniverseID GetUpgradeSlotCurrentComponent(UniverseID destructibleid, const char* upgradetypename, size_t slot);
	UpgradeGroup GetUpgradeSlotGroup(UniverseID destructibleid, const char* macroname, const char* upgradetypename, size_t slot);
	const char* GetWeaponMode(UniverseID weaponid);
	bool HasShipFlightAssist(UniverseID shipid);
	bool IsComponentClass(UniverseID componentid, const char* classname);
	bool IsDroneTypeArmed(UniverseID defensibleid, const char* dronetype);
	bool IsDroneTypeBlocked(UniverseID defensibleid, const char* dronetype);
	bool IsPlayerControlGroupValid(void);
	bool IsTurretGroupArmed(UniverseID defensibleid, UniverseID contextid, const char* path, const char* group);
	bool IsWeaponArmed(UniverseID weaponid);
	void LaunchLaserTower(UniverseID defensibleid, const char* lasertowermacroname);
	void LaunchMine(UniverseID defensibleid, const char* minemacroname);
	void LaunchNavBeacon(UniverseID defensibleid, const char* navbeaconmacroname);
	void LaunchResourceProbe(UniverseID defensibleid, const char* resourceprobemacroname);
	void LaunchSatellite(UniverseID defensibleid, const char* satellitemacroname);
	bool QuickDock();
	bool RequestDockAt(UniverseID containerid, bool checkonly);
	void SetAllTurretsArmed(UniverseID defensibleid, bool arm);
	void SetAllTurretModes(UniverseID defensibleid, const char* mode);
	void SetDefensibleActiveWeaponGroup(UniverseID defensibleid, bool primary, uint32_t groupidx);
	void SetDroneMode(UniverseID defensibleid, const char* dronetype, const char* mode);
	void SetDroneTypeArmed(UniverseID defensibleid, const char* dronetype, bool arm);
	void SetSubordinateGroupDockAtCommander(UniverseID controllableid, int group, bool value);
	void SetTurretGroupArmed(UniverseID defensibleid, UniverseID contextid, const char* path, const char* group, bool arm);
	void SetTurretGroupMode2(UniverseID defensibleid, UniverseID contextid, const char* path, const char* group, const char* mode);
	void SetWeaponArmed(UniverseID weaponid, bool arm);
	void SetWeaponGroup(UniverseID defensibleid, UniverseID weaponid, bool primary, uint32_t groupidx, bool value);
	void SetWeaponMode(UniverseID weaponid, const char* mode);
	bool ShouldSubordinateGroupDockAtCommander(UniverseID controllableid, int group);
	void StartPlayerActivity(const char* activityid);
	void StopPlayerActivity(const char* activityid);
	bool ToggleAutoPilot(bool checkonly);
	void ToggleFlightAssist();
	const char* UndockPlayerShip(bool checkonly);
]]

-- menu variable - used by Helper and used for dynamic variables (e.g. inventory content, etc.)
local menu = {
	name = "DockedMenu"
}

-- config variable - put all static setup here
local config = {
	modes = {
		[1] = { id = "travel",			name = ReadText(1002, 1158),	stoptext = ReadText(1002, 1159),	action = 303 },
		[2] = { id = "scan",			name = ReadText(1002, 1156),	stoptext = ReadText(1002, 1157),	action = 304 },
		[3] = { id = "scan_longrange",	name = ReadText(1002, 1155),	stoptext = ReadText(1002, 1160),	action = 305 },
		[4] = { id = "seta",			name = ReadText(1001, 1132),	stoptext = ReadText(1001, 8606),	action = 225 },
	},
	consumables = {
		{ id = "satellite",		type = "civilian",	getnum = C.GetNumAllSatellites,		getdata = C.GetAllSatellites,		callback = C.LaunchSatellite },
		{ id = "navbeacon",		type = "civilian",	getnum = C.GetNumAllNavBeacons,		getdata = C.GetAllNavBeacons,		callback = C.LaunchNavBeacon },
		{ id = "resourceprobe",	type = "civilian",	getnum = C.GetNumAllResourceProbes,	getdata = C.GetAllResourceProbes,	callback = C.LaunchResourceProbe },
		{ id = "lasertower",	type = "military",	getnum = C.GetNumAllLaserTowers,	getdata = C.GetAllLaserTowers,		callback = C.LaunchLaserTower },
		{ id = "mine",			type = "military",	getnum = C.GetNumAllMines,			getdata = C.GetAllMines,			callback = C.LaunchMine },
	},
	inactiveButtonProperties = { bgColor = Color["button_background_inactive"], highlightColor = Color["button_highlight_inactive"] },
	activeButtonTextProperties = { halign = "center" },
	inactiveButtonTextProperties = { halign = "center", color = Color["text_inactive"] },
	dronetypes = {
		{ id = "orecollector",	name = ReadText(20214, 500) },
		{ id = "gascollector",	name = ReadText(20214, 400) },
		{ id = "defence",		name = ReadText(20214, 300) },
		{ id = "transport",		name = ReadText(20214, 900) },
	},
}

-- kuertee start:
local callbacks = {}
-- kuertee end

-- init menu and register with Helper
local function init()
	--print("Initializing")
	Menus = Menus or { }
	table.insert(Menus, menu)
	if Helper then
		Helper.registerMenu(menu)
	end

	menu.init = true
	registerForEvent("gameplanchange", getElement("Scene.UIContract"), menu.onGamePlanChange)
	RegisterEvent("conversationCancelled", menu.onConvEnds)
	RegisterEvent("conversationFinished", menu.onConvEnds)

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

function menu.onGamePlanChange(_, mode)
	if menu.init then
		if (mode == "cockpit") or (mode == "external") then
			local controlpost = ffi.string(C.GetPlayerCurrentControlGroup())
			local occupiedship = ConvertStringTo64Bit(tostring(C.GetPlayerOccupiedShipID()))
			if ((occupiedship ~= 0) and GetComponentData(occupiedship, "isdocked")) or ((controlpost ~= "") and (controlpost ~= "pilotcontrol")) then
				OpenMenu("DockedMenu", { 0, 0 }, nil)
			end
			menu.init = nil
		elseif (mode == "firstperson") or (mode == "externalfirstperson") then
			menu.init = nil
		end
	end
end

function menu.onPlayerActivityChanged()
	menu.refresh = getElapsedTime() - 1
end

function menu.onConvEnds()
	if not Helper.hasConversationReturnHandler then
		local controlpost = ffi.string(C.GetPlayerCurrentControlGroup())
		local occupiedship = ConvertStringTo64Bit(tostring(C.GetPlayerOccupiedShipID()))
		if ((occupiedship ~= 0) and GetComponentData(occupiedship, "isdocked")) or ((controlpost ~= "") and (controlpost ~= "pilotcontrol")) then
			OpenMenu("DockedMenu", { 0, 0 }, nil)
		end
	end
end

-- cleanup variables in menu, no need for the menu variable to keep all the data while the menu is not active
function menu.cleanup()
	unregisterForEvent("inputModeChanged", getElement("Scene.UIContract"), menu.onInputModeChanged)
	menu.topLevelOffsetY = nil

	--print("Cleaning Up")
	UnregisterEvent("playerUndock", menu.close)
	UnregisterEvent("playerGetUp", menu.close)
	menu.currentcontainer = nil
	--menu.topcontainer = nil
	menu.currentplayership = nil
	menu.secondarycontrolpost = nil
	menu.mode = nil
	menu.buildInProgress = nil
	menu.buildToCancel = nil
	menu.turrets = {}
	menu.turretgroups = {}

	menu.frame = nil
	menu.table_toplevel = nil
	menu.table_topleft = nil
	menu.table_header = nil

	-- kuertee start: callback
	if callbacks ["cleanup"] then
		for _, callback in ipairs (callbacks ["cleanup"]) do
			callback ()
		end
	end
	-- kuertee end: callback
end

function menu.onShowMenu()
	if not menu.hasPlayerActivityCallback then
		local contract = getElement("Scene.UIContract")
		registerForEvent("playerActivityChanged", contract, menu.onPlayerActivityChanged)
		NotifyOnPlayerActivityChanged(contract)
		menu.hasPlayerActivityCallback = true
	end

	Helper.setTabScrollCallback(menu, menu.onTabScroll)
	registerForEvent("inputModeChanged", getElement("Scene.UIContract"), menu.onInputModeChanged)

	-- close the menu if player either undocks or gets up while the menu is open.
	RegisterEvent("playerUndock", menu.close)
	RegisterEvent("playerGetUp", menu.close)

	--print("Showing Menu")
	menu.currentplayership = ConvertStringTo64Bit(tostring(C.GetPlayerOccupiedShipID()))
	local controlpost = ffi.string(C.GetPlayerCurrentControlGroup())
	if (controlpost ~= "") and (controlpost ~= "pilotcontrol") then
		menu.secondarycontrolpost = true
	end

	if menu.currentplayership ~= 0 then
		if GetComponentData(menu.currentplayership, "isdocked") then
			menu.mode = "docked"
			menu.currentcontainer = ConvertStringTo64Bit(tostring(C.GetContextByClass(menu.currentplayership, "container", false)))
		else
			menu.mode = "cockpit"
			menu.currentcontainer = menu.currentplayership
		end
	else
		menu.currentcontainer = ConvertStringTo64Bit(tostring(C.GetContextByClass(C.GetPlayerID(), "container", false)))
		if C.IsComponentClass(menu.currentcontainer, "ship") and (not GetComponentData(menu.currentcontainer, "isdocked")) then
			menu.mode = "cockpit"
		else
			menu.mode = "docked"
		end
	end
	--menu.topcontainer = ConvertStringTo64Bit(tostring(C.GetTopLevelContainer(menu.currentplayership)))
	--print("current player ship: " .. ffi.string(C.GetComponentName(menu.currentplayership)) .. ", currentcontainer: " .. ffi.string(C.GetComponentName(menu.currentcontainer)) .. ", topcontainer: " .. ffi.string(C.GetComponentName(menu.topcontainer)))

	menu.selectedRows = {}
	menu.selectedCols = {}
	-- init selection
	local curtime = getElapsedTime()
	menu.firsttime = curtime + 0.35

	-- add content
	menu.display()

	-- we might have just started the game, check things again (e.g. shiptrader existing) after a short time
	if curtime < 30 then
		menu.refresh = curtime + 1
	end
end

function menu.display()
	Helper.removeAllWidgetScripts(menu)

	local width = Helper.viewWidth
	local height = Helper.viewHeight
	local xoffset = 0
	local yoffset = 0

	menu.frame = Helper.createFrameHandle(menu, { width = width, x = xoffset, y = yoffset, standardButtons = (((menu.mode == "docked") and (menu.currentplayership ~= 0)) or menu.secondarycontrolpost) and {} or { close = true, back = true }, showTickerPermanently = true })
	menu.frame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	menu.createTopLevel(menu.frame)

	local table_topleft, table_header, table_button, row

	local isdocked = (menu.currentplayership ~= 0) and GetComponentData(menu.currentplayership, "isdocked")
	local ownericon, owner, shiptrader, isdock, canbuildships, isplayerowned, issupplyship, canhavetradeoffers, aipilot = GetComponentData(menu.currentcontainer, "ownericon", "owner", "shiptrader", "isdock", "canbuildships", "isplayerowned", "issupplyship", "canhavetradeoffers", "aipilot")
	local cantrade = canhavetradeoffers and isdock
	local canwareexchange = isplayerowned and ((not C.IsComponentClass(menu.currentcontainer, "ship")) or aipilot)
	--NB: equipment docks currently do not have ship traders
	local dockedplayerships = {}
	Helper.ffiVLA(dockedplayerships, "UniverseID", C.GetNumDockedShips, C.GetDockedShips, menu.currentcontainer, "player")
	local canequip = false
	local cansupply = false
	for _, ship in ipairs(dockedplayerships) do
		if C.CanContainerEquipShip(menu.currentcontainer, ship) then
			canequip = true
		end
		if isplayerowned and C.CanContainerSupplyShip(menu.currentcontainer, ship) then
			cansupply = true
		end
	end
	local canmodifyship = (shiptrader ~= nil) and (canequip or cansupply) and isdock
	local canbuyship = (shiptrader ~= nil) and canbuildships and isdock
	local istimelineshub = ffi.string(C.GetGameStartName()) == "x4ep1_gamestart_hub"
	--print("cantrade: " .. tostring(cantrade) .. ", canbuyship: " .. tostring(canbuyship) .. ", canmodifyship: " .. tostring(canmodifyship))

	width = (width / 3) - Helper.borderSize

	-- set up a new table
	table_topleft = menu.frame:addTable(1, { tabOrder = 0, width = Helper.playerInfoConfig.width, height = Helper.playerInfoConfig.height, x = Helper.playerInfoConfig.offsetX, y = Helper.playerInfoConfig.offsetY, scaling = false })

	row = table_topleft:addRow(false, { fixed = true, bgColor = Color["player_info_background"] })
	local icon = row[1]:createIcon(function () local logo = C.GetCurrentPlayerLogo(); return ffi.string(logo.icon) end, { width = Helper.playerInfoConfig.height, height = Helper.playerInfoConfig.height, color = Helper.getPlayerLogoColor })

	local textheight = math.ceil(C.GetTextHeight(Helper.playerInfoConfigTextLeft(), Helper.standardFont, Helper.playerInfoConfig.fontsize, Helper.playerInfoConfig.width - Helper.playerInfoConfig.height - Helper.borderSize))
	icon:setText(Helper.playerInfoConfigTextLeft,	{ fontsize = Helper.playerInfoConfig.fontsize, halign = "left",  x = Helper.playerInfoConfig.height + Helper.borderSize, y = (Helper.playerInfoConfig.height - textheight) / 2 })
	icon:setText2(Helper.playerInfoConfigTextRight,	{ fontsize = Helper.playerInfoConfig.fontsize, halign = "right", x = Helper.borderSize,          y = (Helper.playerInfoConfig.height - textheight) / 2 })

	local xoffset = (Helper.viewWidth - width) / 2
	local yoffset = 25

	table_header = menu.frame:addTable(11, { tabOrder = 1, width = width, x = xoffset, y = menu.topLevelOffsetY + Helper.borderSize + yoffset })
	table_header:setColWidth(1, math.floor((width - 2 * Helper.borderSize) / 3), false)
	table_header:setColWidth(3, Helper.standardTextHeight)
	table_header:setColWidth(4, Helper.standardTextHeight)
	table_header:setColWidth(5, Helper.standardTextHeight)
	table_header:setColWidth(6, Helper.standardTextHeight)
	table_header:setColWidth(8, Helper.standardTextHeight)
	table_header:setColWidth(9, Helper.standardTextHeight)
	table_header:setColWidth(10, Helper.standardTextHeight)
	table_header:setColWidth(11, Helper.standardTextHeight)
	table_header:setDefaultColSpan(1, 1)
	table_header:setDefaultColSpan(2, 5)
	table_header:setDefaultColSpan(7, 5)
	table_header:setDefaultBackgroundColSpan(1, 11)

	local row = table_header:addRow(false, { fixed = true })
	local color = Color["text_normal"]
	if isplayerowned then
		if menu.currentcontainer == C.GetPlayerObjectID() then
			color = Color["text_player_current"]
		else
			color = Color["text_player"]
		end
	end
	row[1]:setColSpan(11):createText(menu.currentcontainer and ffi.string(C.GetComponentName(menu.currentcontainer)) or "", Helper.headerRowCenteredProperties)
	row[1].properties.color = color

	height = Helper.scaleY(Helper.standardTextHeight)

	local row = table_header:addRow(false, { fixed = true, bgColor = Color["row_background_unselectable"] })
	if menu.mode == "cockpit" then
		row[2]:createText(ffi.string(C.GetObjectIDCode(menu.currentcontainer)), { halign = "center", color = color })
	else
		row[1]:createIcon(ownericon, { width = height, height = height, x = row[1]:getWidth() - height, scaling = false })
		row[2]:createText(function() return GetComponentData(menu.currentcontainer, "ownername") end, { halign = "center" })
		row[7]:createText(function() return "[" .. GetUIRelation(GetComponentData(menu.currentcontainer, "owner")) .. "]" end, { halign = "left" })
	end

	table_header:addEmptyRow(yoffset)

	if menu.mode == "cockpit" then
		local row = table_header:addRow("buttonRow1", { fixed = true })
		row[1]:createButton(config.inactiveButtonProperties):setText("", config.inactiveButtonTextProperties)	-- dummy
		local active = ((menu.currentplayership ~= 0) or menu.secondarycontrolpost) and C.CanPlayerStandUp()
		row[2]:createButton(active and { mouseOverText = GetLocalizedKeyName("action", 277), helpOverlayID = "docked_getup", helpOverlayText = " ", helpOverlayHighlightOnly = true } or config.inactiveButtonProperties):setText(ReadText(1002, 20014), active and config.activeButtonTextProperties or config.inactiveButtonTextProperties)	-- "Get Up"
		if active then
			row[2].handlers.onClick = menu.buttonGetUp
		end
		row[7]:createButton({ mouseOverText = GetLocalizedKeyName("action", 316), helpOverlayID = "docked_shipinformation", helpOverlayText = " ", helpOverlayHighlightOnly = true }):setText(ReadText(1001, 8602), { halign = "center" })	-- "Ship Information"
		row[7].handlers.onClick = menu.buttonShipInfo

		local row = table_header:addRow("buttonRow3", { fixed = true })
		local currentactivity = GetPlayerActivity()
		if currentactivity ~= "none" then
			local text = ""
			for _, entry in ipairs(config.modes) do
				if entry.id == currentactivity then
					text = entry.stoptext
					break
				end
			end
			local active = (menu.currentplayership ~= 0) or C.IsPlayerControlGroupValid()
			row[2]:createButton(active and {helpOverlayID = "docked_stopmode", helpOverlayText = " ", helpOverlayHighlightOnly = true } or config.inactiveButtonProperties):setText(text, active and config.activeButtonTextProperties or config.inactiveButtonTextProperties)	-- "Stop Mode"
			if active then
				row[2].handlers.onClick = menu.buttonStopMode
				row[2].properties.uiTriggerID = "stopmode"
			end
		else
			local active = (menu.currentplayership ~= 0) or C.IsPlayerControlGroupValid()
			local modes = {}
			if active then
				for _, entry in ipairs(config.modes) do
					local entryactive = menu.currentplayership ~= 0
					local visible = true
					if entry.id == "travel" then
						entryactive = entryactive and C.CanStartTravelMode(menu.currentplayership)
					elseif entry.id == "scan_longrange" then
						entryactive = entryactive and C.CanPerformLongRangeScan()
					elseif entry.id == "seta" then
						entryactive = true
						visible = C.CanActivateSeta(false)
					end
					local mouseovertext = GetLocalizedKeyName("action", entry.action)
					if visible then
						table.insert(modes, { id = entry.id, text = entry.name, icon = "", displayremoveoption = false, active = entryactive, mouseovertext = mouseovertext, helpOverlayID = "docked_mode_dropdown_" .. entry.id, helpOverlayText = " ", helpOverlayHighlightOnly = true })
					end
				end
			end
			row[2]:createDropDown(modes, {
				helpOverlayID = "docked_modes",
				helpOverlayText = " ",
				helpOverlayHighlightOnly = true,
				height = Helper.standardButtonHeight,
				startOption = "",
				textOverride = ReadText(1002, 1001),
				bgColor = active and Color["dropdown_background_default"] or Color["dropdown_background_inactive"],
				highlightColor = active and Color["dropdown_highlight_default"] or Color["dropdown_highlight_inactive"]
			}):setTextProperties(active and config.activeButtonTextProperties or config.inactiveButtonTextProperties)	-- Modes
			if active then
				row[2].handlers.onDropDownConfirmed = menu.dropdownMode
				row[2].properties.uiTriggerID = "startmode"
			end
		end
		local civilian, military, isinhighway = {}, {}, false
		if menu.currentplayership ~= 0 then
			for _, consumabledata in ipairs(config.consumables) do
				local numconsumable = consumabledata.getnum(menu.currentplayership)
				if numconsumable > 0 then
					local consumables = ffi.new("AmmoData[?]", numconsumable)
					numconsumable = consumabledata.getdata(consumables, numconsumable, menu.currentplayership)
					for j = 0, numconsumable - 1 do
						if consumables[j].amount > 0 then
							local macro = ffi.string(consumables[j].macro)
							if consumabledata.type == "civilian" then
								table.insert(civilian, { id = consumabledata.id .. ":" .. macro, text = GetMacroData(macro, "name"), text2 = "(" .. consumables[j].amount .. ")", icon = "", displayremoveoption = false, helpOverlayID = "docked_deploy_civ_dropdown_" .. consumabledata.id, helpOverlayText = " ", helpOverlayHighlightOnly = true })
							else
								table.insert(military, { id = consumabledata.id .. ":" .. macro, text = GetMacroData(macro, "name"), text2 = "(" .. consumables[j].amount .. ")", icon = "", displayremoveoption = false, helpOverlayID = "docked_deploy_mil_dropdown_" .. consumabledata.id, helpOverlayText = " ", helpOverlayHighlightOnly = true })
							end
						end
					end
				end
			end
			isinhighway = C.GetContextByClass(menu.currentplayership, "highway", false) ~= 0
		end
		local active = (#civilian > 0) and (not isinhighway)
		local mouseovertext = ""
		if #civilian == 0 then
			mouseovertext = ReadText(1026, 7818)
		elseif isinhighway then
			mouseovertext = ReadText(1026, 7845)
		end
		row[1]:createDropDown(civilian, {
			helpOverlayID = "docked_deploy_civ",
			helpOverlayText = " ",
			helpOverlayHighlightOnly = true,
			height = Helper.standardButtonHeight,
			startOption = "",
			textOverride = ReadText(1001, 8607),
			text2Override = " ",
			bgColor = active and Color["dropdown_background_default"] or Color["dropdown_background_inactive"],
			highlightColor = active and Color["dropdown_highlight_default"] or Color["dropdown_highlight_inactive"],
			mouseOverText = mouseovertext,
		}):setTextProperties(active and config.activeButtonTextProperties or config.inactiveButtonTextProperties):setText2Properties(active and config.activeButtonTextProperties or config.inactiveButtonTextProperties)	-- Deploy Civilian
		row[1].properties.text2.halign = "right"
		row[1].properties.text2.x = Helper.standardTextOffsetx
		if active then
			row[1].handlers.onDropDownConfirmed = menu.dropdownDeploy
		end
		local active = (#military > 0) and (not isinhighway)
		local mouseovertext = ""
		if #military == 0 then
			mouseovertext = ReadText(1026, 7819)
		elseif isinhighway then
			mouseovertext = ReadText(1026, 7845)
		end
		row[7]:createDropDown(military, {
			helpOverlayID = "docked_deploy_mil",
			helpOverlayText = " ",
			helpOverlayHighlightOnly = true,
			height = Helper.standardButtonHeight,
			startOption = "",
			textOverride = ReadText(1001, 8608),
			text2Override = " ",
			bgColor = active and Color["dropdown_background_default"] or Color["dropdown_background_inactive"],
			highlightColor = active and Color["dropdown_highlight_default"] or Color["dropdown_highlight_inactive"],
			mouseOverText = mouseovertext,
		}):setTextProperties(active and config.activeButtonTextProperties or config.inactiveButtonTextProperties):setText2Properties(active and config.activeButtonTextProperties or config.inactiveButtonTextProperties)	-- Deploy Military
		row[7].properties.text2.halign = "right"
		row[7].properties.text2.x = Helper.standardTextOffsetx
		if active then
			row[7].handlers.onDropDownConfirmed = menu.dropdownDeploy
		end

		local row = table_header:addRow("buttonRow2", { fixed = true })
		local active = (menu.currentplayership ~= 0) and C.HasShipFlightAssist(menu.currentplayership)
		row[1]:createButton(active and { mouseOverText = GetLocalizedKeyName("action", 221), helpOverlayID = "docked_flightassist", helpOverlayText = " ", helpOverlayHighlightOnly = true } or config.inactiveButtonProperties):setText(ReadText(1001, 8604), active and config.activeButtonTextProperties or config.inactiveButtonTextProperties)	-- "Flight Assist"
		if active then
			row[1].handlers.onClick = menu.buttonFlightAssist
		end
		row[2]:createButton({ bgColor = menu.dockButtonBGColor, highlightColor = menu.dockButtonHighlightColor, helpOverlayID = "docked_dock", helpOverlayText = " ", helpOverlayHighlightOnly = true }):setText(ReadText(1001, 8605), { halign = "center", color = menu.dockButtonTextColor })	-- "Dock"
		row[2].properties.mouseOverText = GetLocalizedKeyName("action", 175)
		row[2].handlers.onClick = menu.buttonDock
		local active = (menu.currentplayership ~= 0) and C.ToggleAutoPilot(true)
		row[7]:createButton(active and { mouseOverText = GetLocalizedKeyName("action", 179), helpOverlayID = "docked_autopilot", helpOverlayText = " ", helpOverlayHighlightOnly = true } or config.inactiveButtonProperties):setText(ReadText(1001, 8603), active and config.activeButtonTextProperties or config.inactiveButtonTextProperties)	-- "Autopilot"
		if active then
			row[7].handlers.onClick = menu.buttonAutoPilot
		end

		-- start: kuertee call-back
		if callbacks ["display_on_after_main_interactions"] then
  			for _, callback in ipairs (callbacks ["display_on_after_main_interactions"]) do
  				callback (table_header)
  			end
  		end
		-- end: kuertee call-back

		if menu.currentplayership ~= 0 then
			local weapons = {}
			local numslots = tonumber(C.GetNumUpgradeSlots(menu.currentplayership, "", "weapon"))
			for j = 1, numslots do
				local current = C.GetUpgradeSlotCurrentComponent(menu.currentplayership, "weapon", j)
				if current ~= 0 then
					table.insert(weapons, current)
				end
			end
			local pilot = GetComponentData(menu.currentplayership, "assignedpilot")
			menu.currentammo = {}
			if #weapons > 0 then
				table_header:addEmptyRow(yoffset)

				local titlerow = table_header:addRow(false, {  })
				titlerow[1]:setColSpan(11):createText(ReadText(1001, 9409), Helper.headerRowCenteredProperties)
				titlerow[1].properties.helpOverlayID = "docked_weaponconfig"
				titlerow[1].properties.helpOverlayText = " "
				titlerow[1].properties.helpOverlayHeight = titlerow:getHeight()
				titlerow[1].properties.helpOverlayHighlightOnly = true
				titlerow[1].properties.helpOverlayScaling = false

				local row = table_header:addRow(false, { bgColor = Color["row_background_unselectable"] })
				row[2]:createText(ReadText(1001, 9410), { font = Helper.standardFontBold, halign = "center" })
				row[7]:createText(ReadText(1001, 9411), { font = Helper.standardFontBold, halign = "center" })
				titlerow[1].properties.helpOverlayHeight = titlerow[1].properties.helpOverlayHeight + row:getHeight() + Helper.borderSize

				-- active weapon groups
				local row = table_header:addRow("weaponconfig_active", {  })
				row[1]:setColSpan(2):createText(ReadText(1001, 11218))
				row[7]:setColSpan(1)
				for j = 1, 4 do
					row[2 + j]:createCheckBox(function () return C.GetDefensibleActiveWeaponGroup(menu.currentplayership, true) == j end, { width = Helper.standardTextHeight, height = Helper.standardTextHeight, symbol = "arrow", bgColor = function () return menu.checkboxWeaponGroupColor(j, true) end, helpOverlayID = "docked_weaponconfig_primary_" .. j .. "_active", helpOverlayText = " ", helpOverlayHighlightOnly = true })
					row[2 + j].handlers.onClick = function () C.SetDefensibleActiveWeaponGroup(menu.currentplayership, true, j) end
				end
				for j = 1, 4 do
					row[7 + j]:createCheckBox(function () return C.GetDefensibleActiveWeaponGroup(menu.currentplayership, false) == j end, { width = Helper.standardTextHeight, height = Helper.standardTextHeight, symbol = "arrow", bgColor = function () return menu.checkboxWeaponGroupColor(j, false) end, helpOverlayID = "docked_weaponconfig_secondary_" .. j .. "_active", helpOverlayText = " ", helpOverlayHighlightOnly = true })
					row[7 + j].handlers.onClick = function () C.SetDefensibleActiveWeaponGroup(menu.currentplayership, false, j) end
				end
				titlerow[1].properties.helpOverlayHeight = titlerow[1].properties.helpOverlayHeight + row:getHeight() + Helper.borderSize

				local row = table_header:addEmptyRow(Helper.standardTextHeight / 2)
				titlerow[1].properties.helpOverlayHeight = titlerow[1].properties.helpOverlayHeight + row:getHeight() + Helper.borderSize

				for i, weapon in ipairs(weapons) do
					local numweapongroups = C.GetNumWeaponGroupsByWeapon(menu.currentplayership, weapon)
					local rawweapongroups = ffi.new("UIWeaponGroup[?]", numweapongroups)
					numweapongroups = C.GetWeaponGroupsByWeapon(rawweapongroups, numweapongroups, menu.currentplayership, weapon)
					local uiweapongroups = { primary = {}, secondary = {} }
					for j = 0, numweapongroups-1 do
						if rawweapongroups[j].primary then
							uiweapongroups.primary[rawweapongroups[j].idx] = true
						else
							uiweapongroups.secondary[rawweapongroups[j].idx] = true
						end
					end

					local row = table_header:addRow("weaponconfig", {  })
					row[1]:setColSpan(2):createText(ffi.string(C.GetComponentName(weapon)))
					row[7]:setColSpan(1)
					for j = 1, 4 do
						row[2 + j]:createCheckBox(uiweapongroups.primary[j], { width = Helper.standardTextHeight, height = Helper.standardTextHeight, bgColor = function () return menu.checkboxWeaponGroupColor(j, true) end, helpOverlayID = "docked_weaponconfig_primary_" .. j .. "_" .. i, helpOverlayText = " ", helpOverlayHighlightOnly = true })
						row[2 + j].handlers.onClick = function() menu.checkboxWeaponGroup(menu.currentplayership, weapon, true, j, not uiweapongroups.primary[j]) end
					end
					for j = 1, 4 do
						row[7 + j]:createCheckBox(uiweapongroups.secondary[j], { width = Helper.standardTextHeight, height = Helper.standardTextHeight, bgColor = function () return menu.checkboxWeaponGroupColor(j, false) end, helpOverlayID = "docked_weaponconfig_secondary_" .. j .. "_" .. i, helpOverlayText = " ", helpOverlayHighlightOnly = true })
						row[7 + j].handlers.onClick = function() menu.checkboxWeaponGroup(menu.currentplayership, weapon, false, j, not uiweapongroups.secondary[j]) end
					end
					titlerow[1].properties.helpOverlayHeight = titlerow[1].properties.helpOverlayHeight + row:getHeight() + Helper.borderSize

					if C.IsComponentClass(weapon, "missilelauncher") then
						local nummissiletypes = C.GetNumAllMissiles(menu.currentplayership)
						local missilestoragetable = ffi.new("AmmoData[?]", nummissiletypes)
						nummissiletypes = C.GetAllMissiles(missilestoragetable, nummissiletypes, menu.currentplayership)

						local weaponmacro = GetComponentData(ConvertStringTo64Bit(tostring(weapon)), "macro")
						local dropdowndata = {}
						for j = 0, nummissiletypes - 1 do
							local ammomacro = ffi.string(missilestoragetable[j].macro)
							if C.IsAmmoMacroCompatible(weaponmacro, ammomacro) then
								table.insert(dropdowndata, {id = ammomacro, text = GetMacroData(ammomacro, "name") .. " (" .. ConvertIntegerString(missilestoragetable[j].amount, true, 0, true) .. ")", icon = "", displayremoveoption = false})
							end
						end

						-- if the ship has no compatible ammunition in ammo storage, have the dropdown print "Out of ammo" and make it inactive.
						menu.currentammo[tostring(weapon)] = "empty"
						local dropdownactive = true
						if #dropdowndata == 0 then
							dropdownactive = false
							table.insert(dropdowndata, {id = "empty", text = ReadText(1001, 9412), icon = "", displayremoveoption = false})	-- Out of ammo
						else
							-- NB: currentammomacro can be null
							menu.currentammo[tostring(weapon)] = ffi.string(C.GetCurrentAmmoOfWeapon(weapon))
						end

						local row = table_header:addRow("ammo_config", {  })
						row[1]:createText("    " .. ReadText(1001, 2800) .. ReadText(1001, 120))	-- Ammunition, :
						row[2]:setColSpan(10):createDropDown(dropdowndata, { startOption = function () return menu.getDropDownOption(weapon) end, helpOverlayID = "docked_ammo_config", helpOverlayText = " ", helpOverlayHighlightOnly = true, active = dropdownactive })
						row[2].handlers.onDropDownConfirmed = function(_, newammomacro) C.SetAmmoOfWeapon(weapon, newammomacro) end
						titlerow[1].properties.helpOverlayHeight = titlerow[1].properties.helpOverlayHeight + row:getHeight() + Helper.borderSize
					elseif pilot and C.IsComponentClass(weapon, "bomblauncher") then
						local pilot64 = ConvertIDTo64Bit(pilot)
						local numbombtypes = C.GetNumAllInventoryBombs(pilot64)
						local bombstoragetable = ffi.new("AmmoData[?]", numbombtypes)
						numbombtypes = C.GetAllInventoryBombs(bombstoragetable, numbombtypes, pilot64)

						local weaponmacro = GetComponentData(ConvertStringTo64Bit(tostring(weapon)), "macro")
						local dropdowndata = {}
						for j = 0, numbombtypes - 1 do
							local ammomacro = ffi.string(bombstoragetable[j].macro)
							if C.IsAmmoMacroCompatible(weaponmacro, ammomacro) then
								table.insert(dropdowndata, { id = ammomacro, text = GetMacroData(ammomacro, "name") .. " (" .. ConvertIntegerString(bombstoragetable[j].amount, true, 0, true) .. ")", icon = "", displayremoveoption = false })
							end
						end

						-- if the ship has no compatible ammunition in ammo storage, have the dropdown print "Out of ammo" and make it inactive.
						menu.currentammo[tostring(weapon)] = "empty"
						local dropdownactive = true
						if #dropdowndata == 0 then
							dropdownactive = false
							table.insert(dropdowndata, { id = "empty", text = ReadText(1001, 9412), icon = "", displayremoveoption = false })	-- Out of ammo
						else
							-- NB: currentammomacro can be null
							menu.currentammo[tostring(weapon)] = ffi.string(C.GetCurrentAmmoOfWeapon(weapon))
						end

						local row = table_header:addRow("ammo_config", {  })
						row[1]:createText("    " .. ReadText(1001, 2800) .. ReadText(1001, 120))	-- Ammunition, :
						row[2]:setColSpan(10):createDropDown(dropdowndata, { startOption = function () return menu.getDropDownOption(weapon) end, helpOverlayID = "docked_ammo_config", helpOverlayText = " ", helpOverlayHighlightOnly = true, active = dropdownactive })
						row[2].handlers.onDropDownConfirmed = function(_, newammomacro) C.SetAmmoOfWeapon(weapon, newammomacro) end
						titlerow[1].properties.helpOverlayHeight = titlerow[1].properties.helpOverlayHeight + row:getHeight() + Helper.borderSize
					end
				end
			end

			local hasonlytugturrets = true
			menu.turrets = {}
			local numslots = tonumber(C.GetNumUpgradeSlots(menu.currentplayership, "", "turret"))
			for j = 1, numslots do
				local groupinfo = C.GetUpgradeSlotGroup(menu.currentplayership, "", "turret", j)
				if (ffi.string(groupinfo.path) == "..") and (ffi.string(groupinfo.group) == "") then
					local current = C.GetUpgradeSlotCurrentComponent(menu.currentplayership, "turret", j)
					if current ~= 0 then
						table.insert(menu.turrets, current)
						if not GetComponentData(ConvertStringTo64Bit(tostring(current)), "istugweapon") then
							hasonlytugturrets = false
						end
					end
				end
			end

			menu.turretgroups = {}
			local turretsizecounts = {}
			local n = C.GetNumUpgradeGroups(menu.currentplayership, "")
			local buf = ffi.new("UpgradeGroup2[?]", n)
			n = C.GetUpgradeGroups2(buf, n, menu.currentplayership, "")
			for i = 0, n - 1 do
				if (ffi.string(buf[i].path) ~= "..") or (ffi.string(buf[i].group) ~= "") then
					local group = { context = buf[i].contextid, path = ffi.string(buf[i].path), group = ffi.string(buf[i].group) }
					local groupinfo = C.GetUpgradeGroupInfo2(menu.currentplayership, "", group.context, group.path, group.group, "turret")
					if (groupinfo.count > 0) then
						group.operational = groupinfo.operational
						group.currentcomponent = groupinfo.currentcomponent
						group.currentmacro = ffi.string(groupinfo.currentmacro)
						group.slotsize = ffi.string(groupinfo.slotsize)
						group.sizecount = 0

						if group.slotsize ~= "" then
							if turretsizecounts[group.slotsize] then
								turretsizecounts[group.slotsize] = turretsizecounts[group.slotsize] + 1
							else
								turretsizecounts[group.slotsize] = 1
							end
							group.sizecount = turretsizecounts[group.slotsize]
						end

						table.insert(menu.turretgroups, group)

						if not GetComponentData(ConvertStringTo64Bit(tostring(group.currentcomponent)), "istugweapon") then
							hasonlytugturrets = false
						end
					end
				end
			end

			if #menu.turretgroups > 0 then
				table.sort(menu.turretgroups, Helper.sortSlots)
			end

			if (#menu.turrets > 0) or (#menu.turretgroups > 0) then
				table_header:addEmptyRow(yoffset)

				local row = table_header:addRow(false, {  })
				row[1]:setColSpan(11):createText(ReadText(1001, 8612), Helper.headerRowCenteredProperties)

				local row = table_header:addRow(false, { bgColor = Color["row_background_unselectable"] })
				row[2]:createText(ReadText(1001, 8620), { font = Helper.standardFontBold, halign = "center" })
				row[7]:createText(ReadText(1001, 12),   { font = Helper.standardFontBold, halign = "center" })

				local row = table_header:addRow("turret_config", {  })
				row[1]:createText(ReadText(1001, 2963))

				-- Start Subsystem Targeting Orders callback
				local sto_callbackVal
				if callbacks ["sto_addTurretBehavioursDockMenu"] then
				  for _, callback in ipairs (callbacks ["sto_addTurretBehavioursDockMenu"]) do
				    sto_callbackVal = callback (row)
				  end
				end
				if not sto_callbackVal then
					row[2]:setColSpan(5):createDropDown(Helper.getTurretModes(nil, not hasonlytugturrets, "docked_turretconfig_modes_dropdown_"), { startOption = function () return menu.getDropDownTurretModeOption(menu.currentplayership, "all") end, helpOverlayID = "docked_turretconfig_modes", helpOverlayText = " ", helpOverlayHighlightOnly = true, uiTriggerID = "docked_turretconfig_modes"  })
					row[2].properties.helpOverlayID = "docked_turretconfig_modes_dropdown"
					row[2].handlers.onDropDownConfirmed = function(_, newturretmode) C.SetAllTurretModes(menu.currentplayership, newturretmode) end
				end
				-- End Subsystem Targeting Orders callback

				row[7]:setColSpan(5):createButton({ helpOverlayID = "docked_turretconfig_arm", helpOverlayText = " ", helpOverlayHighlightOnly = true  }):setText(function () return menu.areTurretsArmed(menu.currentplayership) and ReadText(1001, 8631) or ReadText(1001, 8632) end, { halign = "center" })
				row[7].handlers.onClick = function () return C.SetAllTurretsArmed(menu.currentplayership, not menu.areTurretsArmed(menu.currentplayership)) end

				local turretscounter = 0
				for i, turret in ipairs(menu.turrets) do
					local row = table_header:addRow("turret_config", {  })
					turretscounter = turretscounter + 1
					local turretname = ffi.string(C.GetComponentName(turret))
					local mouseovertext = ""
					local textwidth = C.GetTextWidth(turretname, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize)) + Helper.scaleX(Helper.standardTextOffsetx)
					if (textwidth > row[1]:getWidth()) then
						mouseovertext = turretname
					end
					row[1]:createText(turretname, { mouseOverText = mouseovertext })
					row[2]:setColSpan(5):createDropDown(Helper.getTurretModes(turret, nil, "docked_turrets_modes_dropdown_", turretscounter), { startOption = function () return menu.getDropDownTurretModeOption(turret) end, helpOverlayID = "docked_turrets_modes".. turretscounter, helpOverlayText = " ", helpOverlayHighlightOnly = true, uiTriggerID = "docked_turrets_modes" .. turretscounter  })
					row[2].properties.helpOverlayID = "docked_turrets_modes_dropdown" .. turretscounter
					row[2].handlers.onDropDownConfirmed = function(_, newturretmode) C.SetWeaponMode(turret, newturretmode) end
					row[7]:setColSpan(5):createButton({helpOverlayID = "docked_turrets_arm" .. turretscounter, helpOverlayText = " ", helpOverlayHighlightOnly = true   }):setText(function () return C.IsWeaponArmed(turret) and ReadText(1001, 8631) or ReadText(1001, 8632) end, { halign = "center" })
					row[7].handlers.onClick = function () return C.SetWeaponArmed(turret, not C.IsWeaponArmed(turret)) end
				end

				local turretgroupscounter = 0
				for i, group in ipairs(menu.turretgroups) do
					local row = table_header:addRow("turret_config", {  })
					turretgroupscounter = turretgroupscounter + 1
					local groupname = ReadText(1001, 8023) .. " " .. Helper.getSlotSizeText(group.slotsize) .. group.sizecount .. ((group.currentmacro ~= "") and (" (" .. Helper.getSlotSizeText(group.slotsize) .. " " .. GetMacroData(group.currentmacro, "shortname") .. ")") or "")
					local mouseovertext = ""
					local textwidth = C.GetTextWidth(groupname, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize)) + Helper.scaleX(Helper.standardTextOffsetx)
					if (textwidth > row[1]:getWidth()) then
						mouseovertext = groupname
					end
					row[1]:createText(groupname, { color = (group.operational > 0) and Color["text_normal"] or Color["text_error"], mouseOverText = mouseovertext })
					row[2]:setColSpan(5):createDropDown(Helper.getTurretModes(group.currentcomponent ~= 0 and group.currentcomponent or nil, nil, "docked_turretgroups_modes_dropdown_", turretgroupscounter), { startOption = function () return menu.getDropDownTurretModeOption(menu.currentplayership, group.context, group.path, group.group) end, active = group.operational > 0, helpOverlayID = "docked_turretgroups_modes".. turretgroupscounter, helpOverlayText = " ", helpOverlayHighlightOnly = true, uiTriggerID = "docked_turretgroups_modes" .. turretgroupscounter  })
					row[2].properties.helpOverlayID = "docked_turretgroups_modes_dropdown" .. turretgroupscounter
					row[2].handlers.onDropDownConfirmed = function(_, newturretmode) C.SetTurretGroupMode2(menu.currentplayership, group.context, group.path, group.group, newturretmode) end
					row[7]:setColSpan(5):createButton({ helpOverlayID = "docked_turretgroups_arm" .. turretgroupscounter, helpOverlayText = " ", helpOverlayHighlightOnly = true  }):setText(function () return C.IsTurretGroupArmed(menu.currentplayership, group.context, group.path, group.group) and ReadText(1001, 8631) or ReadText(1001, 8632) end, { halign = "center" })
					row[7].handlers.onClick = function () return C.SetTurretGroupArmed(menu.currentplayership, group.context, group.path, group.group, not C.IsTurretGroupArmed(menu.currentplayership, group.context, group.path, group.group)) end
				end
			end

			menu.drones = {}
			for _, dronetype in ipairs(config.dronetypes) do
				if C.GetNumStoredUnits(menu.currentplayership, dronetype.id, false) > 0 then
					local entry = {
						type = dronetype.id,
						name = dronetype.name,
						current = ffi.string(C.GetCurrentDroneMode(menu.currentplayership, dronetype.id)),
						modes = {},
					}
					local n = C.GetNumDroneModes(menu.currentplayership, dronetype.id)
					local buf = ffi.new("DroneModeInfo[?]", n)
					n = C.GetDroneModes(buf, n, menu.currentplayership, dronetype.id)
					for i = 0, n - 1 do
						local id = ffi.string(buf[i].id)
						if (id ~= "trade") or (id == entry.current) then
							table.insert(entry.modes, { id = id, text = ffi.string(buf[i].name), icon = "", displayremoveoption = false })
						end
					end
					table.insert(menu.drones, entry)
				end
			end

			if #menu.drones > 0 then
				table_header:addEmptyRow(yoffset)

				local row = table_header:addRow(false, {  })
				row[1]:setColSpan(11):createText(ReadText(1001, 8619), Helper.headerRowCenteredProperties)

				local row = table_header:addRow(false, { bgColor = Color["row_background_unselectable"] })
				row[2]:createText(ReadText(1001, 8620), { font = Helper.standardFontBold, halign = "center" })
				row[7]:createText(ReadText(1001, 12), { font = Helper.standardFontBold, halign = "center" })

				for _, entry in ipairs(menu.drones) do
					local isblocked = C.IsDroneTypeBlocked(menu.currentplayership, entry.type)
					local row = table_header:addRow("drone_config", {  })
					row[1]:createText(function () return entry.name .. " (" .. (C.IsDroneTypeArmed(menu.currentplayership, entry.type) and (C.GetNumUnavailableUnits(menu.currentplayership, entry.type) .. "/") or "") .. C.GetNumStoredUnits(menu.currentplayership, entry.type, false) ..")" end, { color = isblocked and Color["text_warning"] or nil })
					row[2]:setColSpan(5):createDropDown(entry.modes, { startOption = function () return ffi.string(C.GetCurrentDroneMode(menu.currentplayership, entry.type)) end, active = not isblocked })
					row[2].handlers.onDropDownConfirmed = function (_, newdronemode) C.SetDroneMode(menu.currentplayership, entry.type, newdronemode) end
					row[7]:setColSpan(5):createButton({ active = not isblocked }):setText(function () return C.IsDroneTypeArmed(menu.currentplayership, entry.type) and ReadText(1001, 8622) or ReadText(1001, 8623) end, { halign = "center" })
					row[7].handlers.onClick = function () return C.SetDroneTypeArmed(menu.currentplayership, entry.type, not C.IsDroneTypeArmed(menu.currentplayership, entry.type)) end
					row[7].properties.helpOverlayID = "docked_drones_" .. entry.type
					row[7].properties.helpOverlayText = " "
					row[7].properties.helpOverlayHighlightOnly = true
				end
			end
			-- subordinates
			local subordinates = GetSubordinates(menu.currentplayership)
			local groups = {}
			local usedassignments = {}
			for _, subordinate in ipairs(subordinates) do
				local purpose, shiptype = GetComponentData(subordinate, "primarypurpose", "shiptype")
				local group = GetComponentData(subordinate, "subordinategroup")
				if group and group > 0 then
					if groups[group] then
						table.insert(groups[group].subordinates, subordinate)
						if shiptype == "resupplier" then
							groups[group].numassignableresupplyships = groups[group].numassignableresupplyships + 1
						end
						if purpose == "mine" then
							groups[group].numassignableminingships = groups[group].numassignableminingships + 1
						end
						if shiptype == "tug" then
							groups[group].numassignabletugships = groups[group].numassignabletugships + 1
						end
					else
						local assignment = ffi.string(C.GetSubordinateGroupAssignment(menu.currentplayership, group))
						usedassignments[assignment] = i
						groups[group] = { assignment = assignment, subordinates = { subordinate }, numassignableresupplyships = (shiptype == "resupplier") and 1 or 0, numassignableminingships = (purpose == "mine") and 1 or 0, numassignabletugships= (shiptype == "tug") and 1 or 0 }
					end
				end
			end

			if #subordinates > 0 then
				table_header:addEmptyRow(yoffset)

				local row = table_header:addRow(false, {  })
				row[1]:setColSpan(11):createText(ReadText(1001, 8626), Helper.headerRowCenteredProperties)

				local row = table_header:addRow(false, { bgColor = Color["row_background_unselectable"] })
				row[1]:createText(ReadText(1001, 8627), { font = Helper.standardFontBold, halign = "center" })
				row[2]:createText(ReadText(1001, 8373), { font = Helper.standardFontBold, halign = "center" })
				row[7]:createText(ReadText(1001, 8628), { font = Helper.standardFontBold, halign = "center" })

				local subordinatecounter = 0
				for i = 1, 10 do
					if groups[i] then
						subordinatecounter = subordinatecounter + 1
						local supplyactive = (groups[i].numassignableresupplyships == #groups[i].subordinates) and ((not usedassignments["supplyfleet"]) or (usedassignments["supplyfleet"] == i))
						local subordinateassignments = {
							[1] = { id = "defence",			text = ReadText(20208, 40301),	icon = "",	displayremoveoption = false },
							[2] = { id = "supplyfleet",		text = ReadText(20208, 40701),	icon = "",	displayremoveoption = false, active = supplyactive, mouseovertext = supplyactive and "" or ReadText(1026, 8601) },
						}

						local isstation = C.IsComponentClass(menu.currentplayership, "station")
						if isstation then
							local miningactive = (groups[i].numassignableminingships == #groups[i].subordinates) and ((not usedassignments["mining"]) or (usedassignments["mining"] == i))
							table.insert(subordinateassignments, { id = "mining", text = ReadText(20208, 40201), icon = "", displayremoveoption = false, active = miningactive, mouseovertext = miningactive and "" or ReadText(1026, 8602) })
							local tradeactive = (not usedassignments["trade"]) or (usedassignments["trade"] == i)
							table.insert(subordinateassignments, { id = "trade", text = ReadText(20208, 40101), icon = "", displayremoveoption = false, active = tradeactive, mouseovertext = tradeactive and ((groups[i].numassignableminingships > 0) and (ColorText["text_warning"] .. ReadText(1026, 8607)) or "") or ReadText(1026, 7840) })
							local tradeforbuildstorageactive = (groups[i].numassignableminingships == 0) and ((not usedassignments["tradeforbuildstorage"]) or (usedassignments["tradeforbuildstorage"] == i))
							table.insert(subordinateassignments, { id = "tradeforbuildstorage", text = ReadText(20208, 40801), icon = "", displayremoveoption = false, active = tradeforbuildstorageactive, mouseovertext = tradeforbuildstorageactive and "" or ReadText(1026, 8603) })
							local salvageactive = (groups[i].numassignabletugships == #groups[i].subordinates) and ((not usedassignments["salvage"]) or (usedassignments["salvage"] == i))
							table.insert(subordinateassignments, { id = "salvage", text = ReadText(20208, 41401), icon = "", displayremoveoption = false, active = salvageactive, mouseovertext = salvageactive and "" or ReadText(1026, 8610) })
						elseif C.IsComponentClass(menu.currentplayership, "ship") then
							-- position defence
							local shiptype = GetComponentData(menu.currentplayership, "shiptype")
							local parentcommander = ConvertIDTo64Bit(GetCommander(menu.currentplayership))
							local isfleetcommander = (not parentcommander) and (#subordinates > 0)
							if (shiptype == "carrier") and isfleetcommander then
								table.insert(subordinateassignments, { id = "positiondefence", text = ReadText(20208, 41501), icon = "", displayremoveoption = false })
							end
							table.insert(subordinateassignments, { id = "attack", text = ReadText(20208, 40901), icon = "", displayremoveoption = false })
							table.insert(subordinateassignments, { id = "interception", text = ReadText(20208, 41001), icon = "", displayremoveoption = false })
							table.insert(subordinateassignments, { id = "bombardment", text = ReadText(20208, 41601), icon = "", displayremoveoption = false })
							table.insert(subordinateassignments, { id = "follow", text = ReadText(20208, 41301), icon = "", displayremoveoption = false })
							local active = true
							local mouseovertext = ""
							local buf = ffi.new("Order")
							if not C.GetDefaultOrder(buf, menu.currentplayership) then
								active = false
								mouseovertext = ReadText(1026, 8606)
							end
							table.insert(subordinateassignments, { id = "assist", text = ReadText(20208, 41201), icon = "", displayremoveoption = false, active = active, mouseovertext = mouseovertext })
							if shiptype == "resupplier" then
								table.insert(subordinateassignments, { id = "trade", text = ReadText(20208, 40101), icon = "", displayremoveoption = false })
							end
						end

						for _, entry in ipairs(subordinateassignments) do
							entry.helpOverlayID = "docked_subordinate_role_dropdown_" .. entry.id .. subordinatecounter
							entry.helpOverlayText = " "
							entry.helpOverlayHighlightOnly = true
						end

						local isdockingpossible = false
						for _, subordinate in ipairs(groups[i].subordinates) do
							if IsDockingPossible(subordinate, menu.currentplayership) then
								isdockingpossible = true
								break
							end
						end
						local active = function () return menu.buttonActiveSubordinateGroupLaunch(i) end
						local mouseovertext = ""
						if isstation then
							active = false
						elseif not GetComponentData(menu.currentplayership, "hasshipdockingbays") then
							active = false
							mouseovertext = ReadText(1026, 8604)
						elseif not isdockingpossible then
							active = false
							mouseovertext = ReadText(1026, 8605)
						end

						local row = table_header:addRow("subordinate_config", {  })
						row[1]:createText(function () menu.updateSubordinateGroupInfo(); return ReadText(20401, i) .. (menu.subordinategroups[i] and (" (" .. ((not C.ShouldSubordinateGroupDockAtCommander(menu.currentplayership, i)) and ((#menu.subordinategroups[i].subordinates - menu.subordinategroups[i].numdockedatcommander) .. "/") or "") .. #menu.subordinategroups[i].subordinates ..")") or "") end, { color = isblocked and Color["text_warning"] or nil })
						row[2]:setColSpan(5):createDropDown(subordinateassignments, { startOption = function () menu.updateSubordinateGroupInfo(); return menu.subordinategroups[i] and menu.subordinategroups[i].assignment or "" end, uiTriggerID = "subordinate_group_role_" .. i, helpOverlayID = "docked_subordinate_role" .. subordinatecounter, helpOverlayText = " ", helpOverlayHighlightOnly = true })
						row[2].handlers.onDropDownConfirmed = function(_, newassignment) Helper.dropdownAssignment(_, nil, i, menu.currentplayership, newassignment) end
						
						-- Start Reactive Docking callback
						local rd_callbackVal
						if callbacks ["rd_addReactiveDockingDockMenu"] then
				  			for _, callback in ipairs (callbacks ["rd_addReactiveDockingDockMenu"]) do
				    				rd_callbackVal = callback (row, menu.currentplayership, i, active, mouseovertext)
				  			end
						end
						if not rd_callbackVal then
							row[7]:setColSpan(5):createButton({ active = active, mouseOverText = mouseovertext, helpOverlayID = "docked_subordinate_arm" .. subordinatecounter, helpOverlayText = " ", helpOverlayHighlightOnly = true }):setText(function () return C.ShouldSubordinateGroupDockAtCommander(menu.currentplayership, i) and ReadText(1001, 8630) or ReadText(1001, 8629) end, { halign = "center" })
							row[7].handlers.onClick = function () return C.SetSubordinateGroupDockAtCommander(menu.currentplayership, i, not C.ShouldSubordinateGroupDockAtCommander(menu.currentplayership, i)) end
						end
						-- End Reactive Docking callback

					end
				end
			end
		end
	else
		local row = table_header:addRow("buttonRow1", { fixed = true })
		local active = canwareexchange
		local mouseovertext
		if (not active) and isplayerowned then
			if C.IsComponentClass(menu.currentcontainer, "ship") then
				mouseovertext = ReadText(1026, 7830)
			end
		end
		row[1]:createButton(active and { helpOverlayID = "docked_transferwares", helpOverlayText = " ", helpOverlayHighlightOnly = true } or config.inactiveButtonProperties):setText(ReadText(1001, 8618), active and config.activeButtonTextProperties or config.inactiveButtonTextProperties)	-- "Transfer Wares"
		if active then
			row[1].handlers.onClick = function() return menu.buttonTrade(true) end
		else
			row[1].properties.mouseOverText = mouseovertext
		end
		local active = (menu.currentplayership ~= 0) or menu.secondarycontrolpost
		row[2]:createButton(active and { mouseOverText = GetLocalizedKeyName("action", 277), helpOverlayID = "docked_getup", helpOverlayText = " ", helpOverlayHighlightOnly = true } or config.inactiveButtonProperties):setText(ReadText(1002, 20014), active and config.activeButtonTextProperties or config.inactiveButtonTextProperties)	-- "Get Up"
		if active then
			row[2].handlers.onClick = menu.buttonGetUp
		end
		local active = menu.currentplayership ~= 0
		row[7]:createButton(active and { mouseOverText = GetLocalizedKeyName("action", 316), helpOverlayID = "docked_shipinfo", helpOverlayText = " ", helpOverlayHighlightOnly = true } or config.inactiveButtonProperties):setText(ReadText(1001, 8602), active and config.activeButtonTextProperties or config.inactiveButtonTextProperties)	-- "Ship Information"
		if active then
			row[7].handlers.onClick = menu.buttonDockedShipInfo
		end

		local row = table_header:addRow("buttonRow2", { fixed = true })

		local doessellshipstoplayer = GetFactionData(owner, "doessellshipstoplayer")
		local active = canbuyship and doessellshipstoplayer
		local mouseovertext = ""
		if not doessellshipstoplayer then
			mouseovertext = ReadText(1026, 7865)
		end

		row[1]:createButton(active and { helpOverlayID = "docked_buyships", helpOverlayText = " ", helpOverlayHighlightOnly = true } or config.inactiveButtonProperties):setText(ReadText(1002, 8008), active and config.activeButtonTextProperties or config.inactiveButtonTextProperties)	-- "Buy Ships"
		row[1].properties.mouseOverText = mouseovertext
		if active then
			row[1].handlers.onClick = menu.buttonBuyShip
		end

		local hastradeoffers = GetFactionData(owner, "hastradeoffers")
		local active = cantrade and hastradeoffers and (not istimelineshub)
		local mouseovertext = ""
		if not hastradeoffers then
			mouseovertext = ReadText(1026, 7866)
		end

		row[2]:createButton(active and {helpOverlayID = "docked_trade", helpOverlayText = " ", helpOverlayHighlightOnly = true } or config.inactiveButtonProperties):setText(ReadText(1002, 9005), active and config.activeButtonTextProperties or config.inactiveButtonTextProperties)	-- "Trade"
		row[2].properties.mouseOverText = mouseovertext
		if active then
			row[2].handlers.onClick = function() return menu.buttonTrade(false) end
			row[2].properties.uiTriggerID = "docked_trade"
		end
		local active = canmodifyship and doessellshipstoplayer
		row[7]:createButton(active and {helpOverlayID = "docked_upgrade_repair", helpOverlayText = " ", helpOverlayHighlightOnly = true } or config.inactiveButtonProperties):setText(issupplyship and ReadText(1001, 7877) or ReadText(1001, 7841), active and config.activeButtonTextProperties or config.inactiveButtonTextProperties)	-- Upgrade / Repair Ship
		if not doessellshipstoplayer then
			row[7].properties.mouseOverText = ReadText(1026, 7865)
		elseif dockedplayerships[1] and (not canequip) then
			row[7].properties.mouseOverText = (C.IsComponentClass(dockedplayerships[1], "ship_l") or C.IsComponentClass(dockedplayerships[1], "ship_xl")) and ReadText(1026, 7807) or ReadText(1026, 7806)
		elseif not isdock then
			row[7].properties.mouseOverText = ReadText(1026, 8014)
		end
		if active then
			row[7].handlers.onClick = menu.buttonModifyShip
		end

		local row = table_header:addRow("buttonRow3", { fixed = true })
		local currentactivity = GetPlayerActivity()
		if currentactivity ~= "none" then
			local text = ""
			for _, entry in ipairs(config.modes) do
				if entry.id == currentactivity then
					text = entry.stoptext
					break
				end
			end
			local active = (menu.currentplayership ~= 0) or C.IsPlayerControlGroupValid()
			row[1]:createButton(active and {helpOverlayID = "docked_stopmode", helpOverlayText = " ", helpOverlayHighlightOnly = true } or config.inactiveButtonProperties):setText(text, active and config.activeButtonTextProperties or config.inactiveButtonTextProperties)	-- "Stop Mode"
			if active then
				row[1].handlers.onClick = menu.buttonStopMode
				row[1].properties.uiTriggerID = "stopmode"
			end
		else
			local active = (menu.currentplayership ~= 0) or C.IsPlayerControlGroupValid()
			local modes = {}
			if active then
				for _, entry in ipairs(config.modes) do
					local entryactive = menu.currentplayership ~= 0
					local visible = true
					if entry.id == "travel" then
						entryactive = entryactive and C.CanStartTravelMode(menu.currentplayership)
					elseif entry.id == "scan_longrange" then
						entryactive = entryactive and C.CanPerformLongRangeScan()
					elseif entry.id == "seta" then
						entryactive = true
						visible = C.CanActivateSeta(false)
					end
					local mouseovertext = GetLocalizedKeyName("action", entry.action)
					if visible then
						table.insert(modes, { id = entry.id, text = entry.name, icon = "", displayremoveoption = false, active = entryactive, mouseovertext = mouseovertext })
					end
				end
			end
			row[1]:createDropDown(modes, {
				helpOverlayID = "docked_modes",
				helpOverlayText = " ",
				helpOverlayHighlightOnly = true,
				height = Helper.standardButtonHeight,
				startOption = "",
				textOverride = ReadText(1002, 1001),
				bgColor = active and Color["button_background_default"] or Color["button_background_inactive"],
				highlightColor = active and Color["button_highlight_default"] or Color["button_highlight_inactive"],
			}):setTextProperties(active and config.activeButtonTextProperties or config.inactiveButtonTextProperties)	-- Modes
			if active then
				row[1].handlers.onDropDownConfirmed = menu.dropdownMode
				row[1].properties.uiTriggerID = "startmode"
			end
		end
		if not istimelineshub then
			if menu.currentplayership ~= 0 then
				row[2]:createButton({ mouseOverText = GetLocalizedKeyName("action", 175), bgColor = menu.undockButtonBGColor, highlightColor = menu.undockButtonHighlightColor, helpOverlayID = "docked_undock", helpOverlayText = " ", helpOverlayHighlightOnly = true }):setText(ReadText(1002, 20013), { halign = "center", color = menu.undockButtonTextColor })	-- "Undock"
				row[2].handlers.onClick = menu.buttonUndock
			else
				row[2]:createButton({ mouseOverText = GetLocalizedKeyName("action", 175), helpOverlayID = "docked_gotoship", helpOverlayText = " ", helpOverlayHighlightOnly = true }):setText(ReadText(1001, 7305), { halign = "center" })	-- "Go to Ship"
				row[2].handlers.onClick = menu.buttonGoToShip
			end
		else
			row[2]:createButton(config.inactiveButtonProperties):setText(ReadText(1001, 7305), config.inactiveButtonTextProperties)	-- dummy
		end
		row[7]:createButton(config.inactiveButtonProperties):setText("", config.inactiveButtonTextProperties)	-- dummy

		-- start: kuertee call-back
		if callbacks ["display_on_after_main_interactions"] then
  			for _, callback in ipairs (callbacks ["display_on_after_main_interactions"]) do
  				callback (table_header)
  			end
  		end
		-- end: kuertee call-back

		local row = table_header:addRow(false, { fixed = true })
		row[1]:setColSpan(11):createBoxText(menu.infoText, { halign = "center", color = Color["icon_warning"], boxColor = menu.infoBoxColor })
	end


	if menu.table_header then
		table_header:setTopRow(GetTopRow(menu.table_header))
		table_header:setSelectedRow(menu.selectedRows.header or Helper.currentTableRow[menu.table_header])
		table_header:setSelectedCol(menu.selectedCols.header or Helper.currentTableCol[menu.table_header] or 0)
	else
		table_header:setSelectedRow(menu.selectedRows.header)
		table_header:setSelectedCol(menu.selectedCols.header or 0)
	end
	menu.selectedRows.header = nil
	menu.selectedCols.header = nil

	table_header.properties.maxVisibleHeight = Helper.viewHeight - table_header.properties.y - Helper.frameBorder
	menu.frame.properties.height = math.min(Helper.viewHeight, table_header:getVisibleHeight() + table_header.properties.y + Helper.scaleY(Helper.standardButtonHeight))

	-- display view/frame
	menu.frame:display()
end

-- handle created frames
function menu.viewCreated(layer, ...)
	menu.table_toplevel, menu.table_topleft, menu.table_header = ...
end

function menu.isDockButtonActive()
	local docktarget = 0
	local softtarget = C.GetSofttarget2().softtargetID
	local environmenttarget = C.GetEnvironmentObject()
	if softtarget ~= 0 then
		docktarget = C.GetContextByClass(softtarget, "container", true)
	elseif environmenttarget ~= 0 then
		docktarget = C.GetContextByClass(environmenttarget, "container", true)
	end
	return (menu.currentplayership ~= 0) and (GetComponentData(menu.currentplayership, "isdocking") or ((docktarget ~= 0) and C.RequestDockAt(docktarget, true)))
end

function menu.dockButtonBGColor()
	return menu.isDockButtonActive() and Color["button_background_default"] or Color["button_background_inactive"]
end

function menu.dockButtonHighlightColor()
	return menu.isDockButtonActive() and Color["button_highlight_default"] or Color["button_highlight_inactive"]
end

function menu.dockButtonTextColor()
	return menu.isDockButtonActive() and Color["text_normal"] or Color["text_inactive"]
end

function menu.isUndockButtonActive()
	return (menu.currentplayership ~= 0) and GetComponentData(menu.currentplayership, "isdocked") and (ffi.string(C.UndockPlayerShip(true)) == "granted") and ((not menu.buildInProgress) or C.CanCancelConstruction(menu.currentcontainer, menu.buildInProgress))
end

function menu.undockButtonBGColor()
	return menu.isUndockButtonActive() and Color["button_background_default"] or Color["button_background_inactive"]
end

function menu.undockButtonHighlightColor()
	return menu.isUndockButtonActive() and Color["button_highlight_default"] or Color["button_highlight_inactive"]
end

function menu.undockButtonTextColor()
	return menu.isUndockButtonActive() and Color["text_normal"] or Color["text_inactive"]
end

function menu.updateSubordinateGroupInfo()
	local curtime = getElapsedTime()
	if (not menu.lastSubordinateGroupUpdate) or (curtime > menu.lastSubordinateGroupUpdate) then
		menu.lastSubordinateGroupUpdate = curtime
		local subordinates = GetSubordinates(menu.currentplayership)
		menu.subordinategroups = {}
		for _, subordinate in ipairs(subordinates) do
			local subordinate64 = ConvertIDTo64Bit(subordinate)
			local group = GetComponentData(subordinate, "subordinategroup")
			if group and group > 0 then
				if menu.subordinategroups[group] then
					local isdocked = C.GetContextByClass(subordinate64, "container", true) == menu.currentplayership
					if isdocked then
						menu.subordinategroups[group].numdockedatcommander = menu.subordinategroups[group].numdockedatcommander + 1
					end
					table.insert(menu.subordinategroups[group].subordinates, subordinate)
				else
					local isdocked = C.GetContextByClass(subordinate64, "container", true) == menu.currentplayership
					menu.subordinategroups[group] = { assignment = ffi.string(C.GetSubordinateGroupAssignment(menu.currentplayership, group)), subordinates = { subordinate }, numdockedatcommander = isdocked and 1 or 0 }
				end
			end
		end
	end
end

function menu.buttonActiveSubordinateGroupLaunch(i)
	menu.updateSubordinateGroupInfo()
	if menu.subordinategroups[i] then
		return (menu.subordinategroups[i].assignment ~= "trade") and (menu.subordinategroups[i].assignment ~= "mining") and (menu.subordinategroups[i].assignment ~= "follow") and (menu.subordinategroups[i].assignment ~= "assist") and (menu.subordinategroups[i].assignment ~= "supplyfleet")
	end
	return false
end

function menu.infoText()
	if ffi.string(C.UndockPlayerShip(true)) == "tradecomputerbusy" then
		menu.haswarning = true
		return ReadText(1001, 8609)
	end
	if menu.currentplayership ~= 0 then
		local constructions = {}
		-- builds in progress
		local n = C.GetNumBuildTasks(menu.currentcontainer, 0, true, true)
		local buf = ffi.new("BuildTaskInfo[?]", n)
		n = C.GetBuildTasks(buf, n, menu.currentcontainer, 0, true, true)
		for i = 0, n - 1 do
			table.insert(constructions, { id = buf[i].id, buildingcontainer = buf[i].buildingcontainer, component = buf[i].component, macro = ffi.string(buf[i].macro), factionid = ffi.string(buf[i].factionid), buildercomponent = buf[i].buildercomponent, price = buf[i].price, ismissingresources = buf[i].ismissingresources, queueposition = buf[i].queueposition, inprogress = true })
		end
		-- other builds
		menu.buildInProgress, menu.buildToCancel = nil, nil
		local n = C.GetNumBuildTasks(menu.currentcontainer, 0, false, true)
		local buf = ffi.new("BuildTaskInfo[?]", n)
		n = C.GetBuildTasks(buf, n, menu.currentcontainer, 0, false, true)
		for i = 0, n - 1 do
			table.insert(constructions, { id = buf[i].id, buildingcontainer = buf[i].buildingcontainer, component = buf[i].component, macro = ffi.string(buf[i].macro), factionid = ffi.string(buf[i].factionid), buildercomponent = buf[i].buildercomponent, price = buf[i].price, ismissingresources = buf[i].ismissingresources, queueposition = buf[i].queueposition, inprogress = false })
		end
		for _, entry in ipairs(constructions) do
			if (entry.component == menu.currentplayership) then
				menu.haswarning = true
				if entry.inprogress then
					menu.buildInProgress = entry.id
					if C.CanCancelConstruction(menu.currentcontainer, menu.buildInProgress) then
						-- warning but allow undock
						menu.buildToCancel = { entry.id, tonumber(entry.price) }
						return ReadText(1001, 8611)
					else
						-- may not be aborted
						return ReadText(1001, 8610) .. " (" .. ConvertTimeString(C.GetBuildProcessorEstimatedTimeLeft(entry.buildercomponent), "%h:%M:%S") .. ")"
					end
				else
					-- warning but allow undock
					menu.buildToCancel = { entry.id, tonumber(entry.price) }
					return ReadText(1001, 8611)
				end
			end
		end
	end
	menu.haswarning = nil
	return ""
end

function menu.infoBoxColor()
	if menu.haswarning then
		return Color["icon_warning"]
	end
	return Color["boxtext_box_hidden"]
end

function menu.checkboxWeaponGroupColor(groupidx, primary)
	return (C.GetDefensibleActiveWeaponGroup(menu.currentplayership, primary) == groupidx) and Color["weapon_group_highlight"] or Color["checkbox_background_default"]
end

function menu.getDropDownOption(weapon)
	local currentweapon = ffi.string(C.GetCurrentAmmoOfWeapon(weapon))
	if menu.currentammo[tostring(weapon)] ~= currentweapon then
		menu.currentammo[tostring(weapon)] = currentweapon
	end
	return menu.currentammo[tostring(weapon)]
end

function menu.getDropDownTurretModeOption(defensibleorturret, context, path, group)
	if (context == nil) and (path == nil) and (group == nil) then
		return ffi.string(C.GetWeaponMode(defensibleorturret))
	elseif context == "all" then
		local allmode
		for i, turret in ipairs(menu.turrets) do
			local mode = ffi.string(C.GetWeaponMode(turret))
			if allmode == nil then
				allmode = mode
			elseif allmode ~= mode then
				allmode = ""
				break
			end
		end
		for i, group in ipairs(menu.turretgroups) do
			if group.operational > 0 then
				local mode = ffi.string(C.GetTurretGroupMode2(defensibleorturret, group.context, group.path, group.group))
				if allmode == nil then
					allmode = mode
				elseif allmode ~= mode then
					allmode = ""
					break
				end
			end
		end
		return allmode or ""
	end
	return ffi.string(C.GetTurretGroupMode2(defensibleorturret, context, path, group))
end

function menu.areTurretsArmed(defensibleorturret)
	local alldisarmed = true
	for i, turret in ipairs(menu.turrets) do
		if C.IsWeaponArmed(turret) then
			alldisarmed = false
			break
		end
	end
	for i, group in ipairs(menu.turretgroups) do
		if group.operational > 0 then
			if C.IsTurretGroupArmed(defensibleorturret, group.context, group.path, group.group) then
				alldisarmed = false
				break
			end
		end
	end
	return not alldisarmed
end

function menu.createTopLevel(frame)
	menu.topLevelOffsetY = Helper.createTopLevelTab(menu, menu.mode, frame, "", nil, (menu.mode == "cockpit") or (menu.currentplayership == 0))
end

function menu.onTabScroll(direction)
	if direction == "right" then
		Helper.scrollTopLevel(menu, menu.mode, 1)
	elseif direction == "left" then
		Helper.scrollTopLevel(menu, menu.mode, -1)
	end
end

function menu.onInputModeChanged(_, mode)
	menu.display()
end

-- widget scripts
function menu.buttonGetUp()
	if not C.GetUp() then
		DebugError("failed getting up.")
	end
end

function menu.buttonGoToShip()
	Helper.closeMenuAndOpenNewMenu(menu, "PlatformUndockMenu", { 0, 0 }, true)
	menu.cleanup()
end

function menu.buttonBuyShip()
	local shiptrader = GetComponentData(menu.currentcontainer, "shiptrader")
	if not shiptrader then
		DebugError("menu.buttonBuyShip called but " .. ffi.string(C.GetComponentName(menu.currentcontainer)) .. " has no shiptrader.")
		return
	end
	Helper.closeMenuAndOpenNewMenu(menu, "ShipConfigurationMenu", { 0, 0, menu.currentcontainer, "purchase", {} })
	menu.cleanup()
end

function menu.buttonModifyShip()
	local shiptrader = GetComponentData(menu.currentcontainer, "shiptrader")
	if not shiptrader then
		DebugError("menu.buttonModifyShip called but " .. ffi.string(C.GetComponentName(menu.currentcontainer)) .. " has no shiptrader.")
		return
	end
	Helper.closeMenuAndOpenNewMenu(menu, "ShipConfigurationMenu", { 0, 0, menu.currentcontainer, "upgrade", {}, true })
	menu.cleanup()
end

function menu.buttonTrade(iswareexchange)
	Helper.closeMenuAndOpenNewMenu(menu, "MapMenu", { 0, 0, true, nil, nil, "tradecontext", {menu.currentcontainer, nil, iswareexchange} })
	menu.cleanup()
end

function menu.buttonUndock()
	if menu.isUndockButtonActive() then
		if menu.buildToCancel then
			Helper.closeMenuAndOpenNewMenu(menu, "UserQuestionMenu", { 0, 0, "abortupgrade", { menu.currentcontainer, menu.buildToCancel[1], menu.buildToCancel[2] } }, true)
			menu.cleanup()
		else
			Helper.closeMenu(menu, "close")
			menu.cleanup()
			if ffi.string(C.UndockPlayerShip(false)) ~= "granted" then
				DebugError("failed undocking.")
			end
		end
	end
end

function menu.buttonShipInfo()
	Helper.closeMenuAndOpenNewMenu(menu, "MapMenu", { 0, 0, true, nil, nil, "infomode", { "info", menu.currentcontainer } })
	menu.cleanup()
end

function menu.buttonDockedShipInfo()
	Helper.closeMenuAndOpenNewMenu(menu, "MapMenu", { 0, 0, true, nil, nil, "infomode", { "info", menu.currentplayership } })
	menu.cleanup()
end

function menu.buttonAutoPilot()
	C.ToggleAutoPilot(false)
	Helper.closeMenu(menu, "close")
	menu.cleanup()
end

function menu.buttonDock()
	if menu.isDockButtonActive() then
		C.QuickDock()
	end
end

function menu.buttonFlightAssist()
	C.ToggleFlightAssist()
	Helper.closeMenu(menu, "close")
	menu.cleanup()
end

function menu.buttonStopMode()
	local currentactivity = GetPlayerActivity()
	C.StopPlayerActivity(currentactivity)
	menu.display()
end

function menu.dropdownMode(_, id)
	C.StartPlayerActivity(id)
	menu.refresh = getElapsedTime() + 0.11
end

function menu.dropdownDeploy(_, idstring)
	local id, macro = string.match(idstring, "(.+):(.+)")
	for _, entry in ipairs(config.consumables) do
		if entry.id == id then
			entry.callback(menu.currentplayership, macro)
			PlaySound("ui_ship_interaction_deploy")
		end
	end
	menu.display()
end

function menu.checkboxWeaponGroup(objectid, weaponid, primary, group, active)
	C.SetWeaponGroup(objectid, weaponid, primary, group, active)
	menu.display()
end

menu.updateInterval = 0.1

-- hook to update the menu while it is being displayed
function menu.onUpdate()
	local curtime = getElapsedTime()
	if menu.secondarycontrolpost then
		if C.IsComponentClass(menu.currentcontainer, "ship") then
			local docked = GetComponentData(menu.currentcontainer, "isdocked")
			if docked ~= (menu.mode == "docked") then
				menu.mode = docked and "docked" or "cockpit"
				menu.refresh = curtime - 1
			end
		end
	end

	if menu.refresh and (menu.refresh < curtime) then
		menu.refresh = nil
		menu.display()
		return
	end

	if menu.firsttime and (menu.firsttime < curtime) then
		SelectRow(menu.table_header, 5)
		SelectColumn(menu.table_header, 2)
		menu.firsttime = nil
	end

	--print("On Update")
	menu.frame:update()
end

-- hook if the highlighted row is changed (is also called on menu creation)
function menu.onRowChanged(row, rowdata)
	--print("Row Changed")
	menu.frame:update()
end

-- hook if the highlighted row is selected
function menu.onSelectElement()
	--print("Element Selected")
end

function menu.close()
	Helper.closeMenu(menu, "close")
	menu.cleanup()
end

-- hook if the menu is being closed
function menu.onCloseElement(dueToClose)
	if ((menu.mode == "docked") and (menu.currentplayership ~= 0)) or menu.secondarycontrolpost then
		if dueToClose == "back" then
			Helper.closeMenuAndOpenNewMenu(menu, "OptionsMenu", nil)
			menu.cleanup()
		end
	else
		Helper.closeMenu(menu, dueToClose)
		menu.cleanup()
	end
end

-- kuetee start:
function menu.registerCallback (callbackName, callbackFunction)
	-- note 1: format is generally [function name]_[action]. e.g.: in kuertee_menu_transporter, "display_on_set_room_active" overrides the room's active property with the return of the callback.
	-- note 2: events have the word "_on_" followed by a PRESENT TENSE verb. e.g.: in kuertee_menu_transporter, "display_on_set_buttontable" is called after all of the rows of buttontable are set.
	-- note 3: new callbacks can be added or existing callbacks can be edited. but commit your additions/changes to the mod's GIT repository.
	-- note 4: search for the callback names to see where they are executed.
	-- note 5: if a callback requires a return value, return it in an object var. e.g. "display_on_set_room_active" requires a return of {active = true | false}.

	-- to find callbacks available for this menu,
	-- reg-ex search for callbacks\[\".*\]

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
		Helper.loadModLuas(menu.name, "menu_docked_uix")
	end
end
-- kuerte end

init()
