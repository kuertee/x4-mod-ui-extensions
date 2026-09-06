-- ffi setup
local ffi = require("ffi")
local C = ffi.C
ffi.cdef[[
	typedef uint64_t UniverseID;
	typedef struct {
		const char* name;
		float hull;
		float shield;
		int speed;
		bool hasShield;
	} ComponentDetails;
	typedef struct {
		const char* type;
		const char* name;
		const char* desc;
		const char* hackeddesc;
		int64_t price;
		int32_t numrequiredwares;
		bool ishack;
		bool hacked;
		double hackduration;
		double hackexpiretime;
	} ControlPanelInfo;
	typedef struct {
		const char* factionID;
		const char* factionName;
		const char* factionIcon;
	} FactionDetails;
	typedef struct {
		uint64_t poiID;
		UniverseID componentID;
		const char* messageType;
		const char* connectionName;
		bool isAssociative;
		bool isMissionTarget;
		bool isPriorityMissionTarget;
		bool showIndicator;
		bool hasAdditionalOffset;
	} MessageDetails3;
	typedef struct {
		const char* missionName;
		const char* missionDescription;
		const char* missionIcon;
		int difficulty;
		int upkeepalertlevel;
		const char* threadType;
		const char* mainType;
		const char* subType;
		const char* subTypeName;
		const char* faction;
		int64_t reward;
		const char* rewardText;
		size_t numBriefingObjectives;
		int activeBriefingStep;
		const char* opposingFaction;
		const char* license;
		float timeLeft;
		double duration;
		bool abortable;
		bool hasObjective;
		UniverseID associatedComponent;
		UniverseID threadMissionID;
	} MissionDetails2;
	typedef struct {
		const char* id;
		const char* name;
		const char* desc;
		uint32_t amount;
		uint32_t numtiers;
		bool canhire;
	} PeopleInfo;
	typedef struct {
		UniverseID softtargetID;
		const char* softtargetConnectionName;
		uint32_t messageID;
	} SofttargetDetails2;
	typedef struct {
		UniverseID component;
		const char* connection;
	} UIComponentSlot;
	typedef struct {
		const char* ware;
		const char* macro;
		int amount;
	} UIWareInfo;
	uint64_t GetActiveMissionID(void);
	uint32_t GetCargoTransportTypes(StorageInfo* result, uint32_t resultlen, UniverseID containerid, bool merge, bool aftertradeorders);
	ComponentDetails GetComponentDetails(const UniverseID componentid, const char*const connectionname);
	const char* GetCompSlotControlPosition(UniverseID componentid, const char* connectionname);
	const char* GetCompSlotPlayerActionTriggeredConnection(UniverseID componentid, const char* connectionname);
	ControlPanelInfo GetControlPanelInfo(UIComponentSlot controlpanel);
	uint32_t GetControlPanelRequiredWares(UIWareInfo* result, uint32_t resultlen, UIComponentSlot controlpanel);
	float GetCurrentBuildProgress(UniverseID containerid);
	double GetCurrentGameTime(void);
	FactionDetails GetFactionDetails(const char* factionid);
	const char* GetHUDScaleOption(void);
	float GetHUDUIScale(const bool scalewithresolution);
	MessageDetails3 GetMessageDetails3(const uint32_t messageid);
	MissionDetails2 GetMissionIDDetails2(uint64_t missionid);
	uint32_t GetNumAllRoles(void);
	uint32_t GetNumCargoTransportTypes(UniverseID containerid, bool merge);
	size_t GetNumUpgradeSlots(UniverseID destructibleid, const char* macroname, const char* upgradetypename);
	size_t GetNumVirtualUpgradeSlots(UniverseID objectid, const char* macroname, const char* upgradetypename);
	const char* GetObjectIDCode(UniverseID objectid);
	uint32_t GetPeople2(PeopleInfo* result, uint32_t resultlen, UniverseID controllableid, bool includearriving);
	uint32_t GetPeopleCapacity(UniverseID controllableid, const char* macroname, bool includepilot);
	UniverseID GetPlayerOccupiedShipID(void);
	SofttargetDetails2 GetSofttarget2();
	float GetTextWidth(const char*const text, const char*const fontname, const float fontsize);
	float GetUIScale(const bool scalewithresolution);
	UniverseID GetUpgradeSlotCurrentComponent(UniverseID destructibleid, const char* upgradetypename, size_t slot);
	const char* GetVirtualUpgradeSlotCurrentMacro(UniverseID defensibleid, const char* upgradetypename, size_t slot);
]]

-- NOTE: Same defaults as in notification.cpp
local defaults = {
	headercolor = Color["text_notification_header"],
	headerfont = "Zekton",
	headerfontsize = 22,

	textcolor = Color["text_notification_text"],
	textfont = "Zekton",
	textfontsize = 22,

	boldfont = "Zekton Bold",

	monitorwidth = 700,   -- NOTE: Just an estimated value to prevent overlapping texts (left and right) in the same row
	maxnumrows = 7,
}

local private = {}

if ffi.string(C.GetHUDScaleOption()) ~= "off" then
	local hudUIScale = C.GetHUDUIScale(true)
	local uiScale = C.GetUIScale(true)
	private.textUIScale = uiScale / hudUIScale
else
	private.textUIScale = 1.0
end

local livedatacache = {
	-- referenceComponent,
	-- referenceConnectionName,
}

local function createTextDescription(text, color, font, fontsize)
	return {
		text = text,
		color = color or defaults.textcolor,
		font = font or defaults.textfont,
		fontsize = fontsize or defaults.textfontsize
	}
end

local function createHeaderDescription(text, color, font, fontsize)
	return {
		text = text,
		color = color or defaults.headercolor,
		font = font or defaults.headerfont,
		fontsize = fontsize or defaults.headerfontsize
	}
end

local function addRowText(row, alignment, textdesc)
	if type(textdesc) ~= "table" then
		textdesc = createTextDescription(textdesc)
	end
	row[alignment] = textdesc
end

local function addRow(textrows, lefttextdesc, righttextdesc)
	if #textrows < defaults.maxnumrows then
		local row = { }
		table.insert(textrows, row)
		if lefttextdesc then
			-- add row.left
			addRowText(row, "left", lefttextdesc)
		end
		if righttextdesc then
			-- add row.right
			addRowText(row, "right", righttextdesc)
		end
	end
end

local function addTwoRows(textrows, lefttextdesc1, righttextdesc1, lefttextdesc2, righttextdesc2)
	if #textrows < defaults.maxnumrows - 1 then -- only add rows if there's room for two of them
		addRow(textrows, lefttextdesc1, righttextdesc1)
		addRow(textrows, lefttextdesc2, righttextdesc2)
	end
end

local function addHullShieldRows(textrows, component)
	addRow(textrows, ReadText(1001, 1), "$hullpercent$%")
	if GetComponentData(component, "shieldmax") ~= 0 then
		addRow(textrows, ReadText(1001, 2), "$shieldpercent$%")
	end
end

local function setKnown(component, faction)
	if component then
		local macro = GetComponentData(component, "macro")
		if IsComponentClass(component, "station") then
			AddKnownItem("stationtypes", macro)
		elseif GetMacroData(macro, "islasertower") then
			AddKnownItem("lasertowers", macro)
		elseif IsComponentClass(component, "ship_xs") then
			AddKnownItem("shiptypes_xs", macro)
		elseif IsComponentClass(component, "entity") then
			local entityrace = GetMacroData(macro, "entityrace")
			if entityrace ~= "" then
				AddKnownItem("races", entityrace)
			end
		else
			if IsComponentClass(component, "ship_xl") then
				AddKnownItem("shiptypes_xl", macro)
			elseif IsComponentClass(component, "ship_l") then
				AddKnownItem("shiptypes_l", macro)
			elseif IsComponentClass(component, "ship_m") then
				AddKnownItem("shiptypes_m", macro)
			elseif IsComponentClass(component, "ship_s") then
				AddKnownItem("shiptypes_s", macro)
			end
			-- Also add integrated equipment that cannot be targeted individually
			local component64 = ConvertIDTo64Bit(component)
			local types = {}
			if IsComponentClass(component, "ship_xl") or IsComponentClass(component, "ship_l") then
				types = { "weapon" }
			else
				types = { "engine", "shield", "weapon", "turret" }
			end
			for _, upgradetype in ipairs(types) do
				local numslots = 0
				if IsComponentClass(component, "defensible") then
					numslots = tonumber(C.GetNumUpgradeSlots(component64, "", upgradetype))
				end
				for j = 1, numslots do
					local current = C.GetUpgradeSlotCurrentComponent(component64, upgradetype, j)
					if current ~= 0 then
						local macro = GetComponentData(ConvertStringTo64Bit(tostring(current)), "macro")
						local infolibrary = GetMacroData(macro, "infolibrary")
						AddKnownItem(infolibrary, macro)
					end
				end
			end
			local numslots = tonumber(C.GetNumVirtualUpgradeSlots(component64, "", "thruster"))
			for j = 1, numslots do
				local currentmacro = ffi.string(C.GetVirtualUpgradeSlotCurrentMacro(component64, "thruster", j))
				if currentmacro ~= "" then
					local infolibrary = GetMacroData(currentmacro, "infolibrary")
					AddKnownItem(infolibrary, currentmacro)
				end
			end
		end
		faction = faction or GetComponentData(component, "owner")
	end
	if faction then
		if IsFactionKnown(faction) then
			AddKnownItem("factions", faction)
			local primaryrace = GetFactionData(faction, "primaryrace")
			if primaryrace ~= "" then
				AddKnownItem("races", primaryrace)
			end
		end
	end
end

local function unlockInfo(unlocked, cellcontent)
	if unlocked then
		return cellcontent
	else
		return ReadText(1001, 3210)
	end
end

local function estimateString(estimated)
	if estimated then
		return ReadText(1001, 70) .. " "
	else
		return ""
	end
end

local function hasInventory(object)
	local function hasEntityInventory(entity)
		if entity then
			inventory = GetInventory(entity)
			if next(inventory) then
				return true
			end
		end
		return false
	end

	local pilot, tradenpc, engineer = GetComponentData(object, "pilot", "tradenpc", "engineer")

	return hasEntityInventory(pilot) or hasEntityInventory(tradenpc) or hasEntityInventory(engineer)
end

local function addStorageWarningPlaceholders(textrows)
	local remainingrows = defaults.maxnumrows - #textrows
	if remainingrows >= 2 then
		if remainingrows > 2 then
			-- add empty line as separation if there's enough space left
			table.insert(textrows, { })
		end
		local color = Color["text_notification_text_lowlight"]
		addRow(textrows, createTextDescription("$storagewarning$", color))
		addRow(textrows, createTextDescription("$storagereason$", color))
	end
end

local function getWareStorageName(transporttype, container)
	if transporttype == "container" or transporttype == "solid" or transporttype == "liquid" then
		-- transporttype fits into universal storage - if container has universal storage, use that as storage name
		local transporttypes = { }
		local n = C.GetNumCargoTransportTypes(container, true)
		local buf = ffi.new("StorageInfo[?]", n)
		n = C.GetCargoTransportTypes(buf, n, container, true, false)
		for i = 0, n - 1 do
			local tags = {}
			for w in string.gmatch(ffi.string(buf[i].transport), "%S+") do		-- non-space
				tags[w] = true
			end
			if tags.container and tags.solid and tags.liquid then -- do not add Condensate Storage!
				return ReadText(20109, 801)		-- Universal Storage
			end
		end
	end

	if transporttype == "container" then
		return ReadText(20109, 101)		-- Container Storage
	elseif transporttype == "solid" then
		return ReadText(20109, 301)		-- Solid Storage
	elseif transporttype == "liquid" then
		return ReadText(20109, 601)		-- Liquid Storage
	elseif transporttype == "condensate" then
		return ReadText(20109, 9801)	-- Condensate Storage
	end
	return transporttype		-- Should never happen!
end

local function getHeaderName(object, part2)
	local width = defaults.monitorwidth
	if part2 then
		part2 = " - " .. part2
	elseif IsComponentClass(object, "container") then
		part2 = string.format(" (%s)", ffi.string(C.GetObjectIDCode(ConvertIDTo64Bit(object))))
	end
	if part2 then
		width = width - C.GetTextWidth(part2, defaults.headerfont, math.ceil(defaults.headerfontsize * private.textUIScale))
		if width < 250 then
			width = 250
		end
	end

	return unlockInfo(IsInfoUnlockedForPlayer(object, "name"), GetComponentName(object, defaults.headerfont, math.ceil(defaults.headerfontsize * private.textUIScale), width, true, part2 and true)) .. (part2 and part2 or "")
end

local function getTargetDataForDisplay(component, templateConnectionName, isSofttarget)
	if not IsValidComponent(component) then
		return nil
	end
	local component64 = ConvertIDTo64Bit(component)
	-- Collect data about the component slot
	local targetdata = { }
	targetdata.component = component
	targetdata.templateConnectionName = templateConnectionName
	targetdata.triggeredConnectionName = templateConnectionName ~= "" and ffi.string(C.GetCompSlotPlayerActionTriggeredConnection(component64, templateConnectionName)) or ""
	targetdata.controlposition = (templateConnectionName ~= "" and (IsComponentClass(component, "ship") or IsComponentClass(component, "cockpit"))) and ffi.string(C.GetCompSlotControlPosition(component64, templateConnectionName)) or ""

	-- Decide what we actually want to display
	if targetdata.triggeredConnectionName ~= "" then
		-- If target is a ship console on a docking bay, change it to the docked ship
		if HasTag(targetdata.component, targetdata.triggeredConnectionName, "shipconsole") and IsComponentClass(targetdata.component, "dockingbay") then
			local dockedships = ffi.new("UniverseID[1]")
			local numdockedships = C.GetDockedShips(dockedships, 1, component64, nil)
			if numdockedships == 1 then
				targetdata.component = ConvertStringTo64Bit(tostring(dockedships[0]))
				targetdata.templateConnectionName = ""
				targetdata.triggeredConnectionName = ""
			end
		end
	elseif targetdata.controlposition ~= "" then
		-- Show info about the controllable of this controlposition
		targetdata.component = GetContextByClass(targetdata.component, "controllable", true)
		targetdata.templateConnectionName = ""
		targetdata.triggeredConnectionName = ""
	elseif targetdata.templateConnectionName ~= "" and HasTag(targetdata.component, targetdata.templateConnectionName, "trigger_interact") then
		-- interactive part for which we have no triggeredConnectionName: Don't show anything
		return nil
	end

	if isSofttarget then
		local softtargetDetails = C.GetSofttarget2()
		if softtargetDetails.messageID ~= 0 then
			local messageDetails = C.GetMessageDetails3(softtargetDetails.messageID)
			if messageDetails.isMissionTarget and messageDetails.hasAdditionalOffset then
				targetdata.hasMissionTargetAdditionalOffset = true
			end
		end
	end

	-- Repeat validation since component may have changed
	if not IsValidComponent(targetdata.component) then
		return nil
	end
	return targetdata
end

--
-- Return table format documentation: https://www.egosoft.com:8444/confluence/pages/viewpage.action?pageId=59742033
--
function GetTargetMonitorDetails(component, templateConnectionName, isSofttarget)
	-- DiCrash start: target details override
	if Helper.uix_callbacks and Helper.uix_callbacks["GetTargetMonitorDetails_on_get_details"] then
		for uix_id, uix_callback in pairs(Helper.uix_callbacks["GetTargetMonitorDetails_on_get_details"]) do
			local uix_result = uix_callback(component, templateConnectionName, isSofttarget)

			if type(uix_result) == "table" and type(uix_result.details) == "table" then
				return uix_result.details
			end
		end
	end
	-- DiCrash end:

	local targetdata = getTargetDataForDisplay(component, templateConnectionName, isSofttarget)
	if not targetdata then
		return { }	-- ignore invalid component
	end

	-- Update values
	component = targetdata.component
	templateConnectionName = targetdata.templateConnectionName

	-- Common preparations
	local textrows = { }
	local component64 = ConvertIDTo64Bit(component)

	local header = getHeaderName(component)
	local faction, factionIcon, isplayerowned = GetComponentData(component, "owner", "ownericon", "isplayerowned")
	local notorietyComponent = component64
	local interaction = nil
	local interactionComponent = component

	if not IsInfoUnlockedForPlayer(component, "name") and not IsComponentClass(component, "space") then
		-- the retrieved object name will be "Unknown Object/Ship/Station" as required
		header = GetComponentData(component, "name")
		factionIcon = nil

	-- check parts first, then classes
	elseif targetdata.triggeredConnectionName ~= "" then

		if HasTag(component, targetdata.triggeredConnectionName, "transporter") then
			header = ReadText(20109, 5801)		-- Transporter Room
			-- TODO
		elseif HasTag(component, targetdata.triggeredConnectionName, "shipconsole") then
			header = ReadText(20109, 5901)		-- Ship Console
			-- nothing else to display here
		elseif HasTag(component, targetdata.triggeredConnectionName, "workbench") then
			header = ReadText(20109, 6001)		-- Workbench
			-- TODO
		elseif HasTag(component, targetdata.triggeredConnectionName, "inventoryworkbench") then
			header = ReadText(20109, 7401)		-- Crafting Bench
		elseif HasTag(component, targetdata.triggeredConnectionName, "ventureconsole") then
			header = ReadText(20109, 8801)		-- Venture Console
		elseif HasTag(component, targetdata.triggeredConnectionName, "inventoryconsole") then
			header = ReadText(20109, 9001)		-- Safe Deposit Storage
		elseif HasTag(component, targetdata.triggeredConnectionName, "door") then
			header = ReadText(20109, 6101)		-- Door
			-- nothing else to display here
		elseif HasTag(component, targetdata.triggeredConnectionName, "elevator") then
			header = ReadText(20109, 7201)		-- Elevator
			-- nothing else to display here
		elseif HasTag(component, targetdata.triggeredConnectionName, "scenarioconsole") then
			header = ReadText(20109, 14601)		-- Timelines Scenario Console
			-- nothing else to display here
		elseif HasTag(component, targetdata.triggeredConnectionName, "hack") then
			-- ControlPanel
			local controlpanel = ffi.new("UIComponentSlot")
			controlpanel.component = component64
			controlpanel.connection = targetdata.triggeredConnectionName
			local controlpanelinfo = C.GetControlPanelInfo(controlpanel)

			factionIcon = nil
			header = ffi.string(controlpanelinfo.name)
			if header == "" then
				header = ReadText(20109, 1801)			-- Security Control Panel (fallback for unnamed template components)
			end
			if not controlpanelinfo.hacked then
				local description = ffi.string(controlpanelinfo.desc)
				local hackduration = controlpanelinfo.hackduration
				if description ~= "" or hackduration > 0 then
					if description ~= "" then
						local lines = GetTextLines(description, defaults.textfont, defaults.textfontsize, defaults.monitorwidth)
						for _, line in ipairs(lines) do
							addRow(textrows, line)
						end
					end
					if hackduration > 0 then
						addRow(textrows, ReadText(1015, 71), Helper.formatTimeLeft(hackduration))		-- Duration:
					end
					addRow(textrows, "")
				end
				local price = controlpanelinfo.price
				if price > 0 then
					local color = (GetPlayerMoney() < price) and Color["text_negative"] or defaults.textcolor
					local lefttext = createTextDescription(ReadText(1001, 2808), color)		-- Price
					local righttext = createTextDescription(ConvertMoneyString(price, false, true, 0, true) .. " " .. ReadText(1001, 101), color)
					addRow(textrows, lefttext, righttext)
				end
				local n = controlpanelinfo.numrequiredwares
				local headlineprinted = false
				if n > 0 then
					local playerinventory = GetPlayerInventory()
					local requireditems = ffi.new("UIWareInfo[?]", n)
					n = C.GetControlPanelRequiredWares(requireditems, n, controlpanel)
					for i = 0, n - 1 do
						local wareid = ffi.string(requireditems[i].ware)
						local warename = GetWareData(wareid, "name")
						local requiredamount = requireditems[i].amount
						local playeramount = playerinventory[wareid] and playerinventory[wareid].amount or 0

						local color = (playeramount < requiredamount) and Color["text_negative"] or defaults.textcolor
						local lefttext = createTextDescription("  " .. warename, color)
						local righttext = createTextDescription(string.format("%s (%s)", requiredamount, playeramount), color)
						if not headlineprinted then
							addTwoRows(textrows, ReadText(1001, 4750), nil, lefttext, righttext)	-- Required for hacking:
							headlineprinted = true
						else
							addRow(textrows, lefttext, righttext)
						end
					end
				end
			else
				local hackeddescription = ffi.string(controlpanelinfo.hackeddesc)
				if hackeddescription ~= "" then
					local lines = GetTextLines(hackeddescription, defaults.textfont, defaults.textfontsize, defaults.monitorwidth)
					for _, line in ipairs(lines) do
						addRow(textrows, line)
					end
					addRow(textrows, "")
				end
				if controlpanelinfo.hackexpiretime > 0 then
					addRow(textrows, ReadText(1001, 4760), "$hackexpirationtime$")		-- Hack expires in:
				end
			end
		end

	elseif targetdata.hasMissionTargetAdditionalOffset then
		-- offset case
		header = "$locationheader$"
		factionIcon = nil

	elseif IsComponentClass(component, "highway") or IsComponentClass(component, "highwayentrygate") or IsComponentClass(component, "highwayexitgate") then
		-- Highway
		local sector, destsector = GetComponentData(component, "sector", "destinationsector")
		if destsector and destsector ~= sector then
			header = ReadText(1001, 5205) .. ReadText(1001, 120) .. " " .. GetComponentData(destsector, "name")
		else
			header = nil
		end
		factionIcon = nil

	elseif IsComponentClass(component, "gate") then
		-- Gate
		local destspace = Helper.getDisplayableGateDestinationSpace(component)
		if destspace then
			header = ReadText(1001, 5205) .. ReadText(1001, 120) .. " " .. GetComponentData(destspace, "name")
		end
		factionIcon = nil

	elseif IsComponentClass(component, "zone") then
		-- Zone
		header = "$zoneheader$"
		factionIcon = nil
		-- TODO: Area properties
		-- TODO: Check templateConnectionName (e.g. build location)

	elseif IsComponentClass(component, "turret") then
		-- Turret
		header = "$containerheader$"
		local container = GetContextByClass(component, "container")
		if container then
			setKnown(container)
		end
		addHullShieldRows(textrows, component)
		local macro = GetComponentData(component, "macro")
		local library = GetMacroData(macro, "infolibrary")
		AddKnownItem(library, macro)
		if C.IsStoryFeatureUnlocked("x4ep1_encyclopedia") then
			interaction = "encyclopedia interaction"
			interactionComponent = { library, component }
		end

	elseif IsComponentClass(component, "shieldgenerator") then
		-- Shield generator
		header = "$containerheader$"
		local container = GetContextByClass(component, "container")
		if container then
			setKnown(container)
		end
		addHullShieldRows(textrows, component)
		AddKnownItem("shieldgentypes", GetComponentData(component, "macro"))
		if C.IsStoryFeatureUnlocked("x4ep1_encyclopedia") then
			interaction = "encyclopedia interaction"
			interactionComponent = { "shieldgentypes", component }
		end

	elseif IsComponentClass(component, "engine") then
		-- engines
		header = "$containerheader$"
		local container = GetContextByClass(component, "container")
		if container then
			setKnown(container)
		end
		addHullShieldRows(textrows, component)
		AddKnownItem("enginetypes", GetComponentData(component, "macro"))

	elseif IsComponentClass(component, "module") then
		-- station modules
		header = "$containerheader$"
		local container = GetContextByClass(component, "container")
		if container then
			setKnown(container)
		end
		addHullShieldRows(textrows, component)
		if IsComponentClass(container, "station") then
			local macro = GetComponentData(component, "macro")
			local library = GetMacroData(macro, "infolibrary")
			AddKnownItem(library, macro)
		end

	elseif IsComponentClass(component, "asteroid") then
		-- Asteroid
		factionIcon = nil
		local wares = GetComponentData(component, "wares")
		local displayed = false
		if wares then
			for warenum, ware in ipairs(wares) do
				if ware.amount > 0 then
					displayed = true
					local warename = GetWareData(ware.ware, "name")
					addTwoRows(textrows, warename, nil, ReadText(1001, 3214) .. ReadText(1001, 120), ware.amount)	-- Yield:
				end
			end
		end
		if not displayed then
			addRow(textrows, ReadText(1001, 2915)) -- empty
		else
			addStorageWarningPlaceholders(textrows)
		end

	elseif IsComponentClass(component, "resourceprobe") then
		-- Resource Probe
		addHullShieldRows(textrows, component)
		-- Note: Calculation and display is in sync with display in holomap
		local curyield = GetComponentData(component, "currentyield")
		if #curyield > 0 and isplayerowned then
			addRow(textrows, ReadText(1001, 3212) .. ReadText(1001, 120))	-- Yields:
			for _, ware in ipairs(curyield) do
				local curamount = ware.amount
				if curamount > 0 then
					local warename = GetWareData(ware.ware, "name")

					local ratingtext = "?"
					local int, frac = math.modf(ware.rating / 3)
					-- full stars
					ratingtext = string.rep("\27[menu_star_04]", int)
					if frac > 0.66 then
						-- 2/3 star
						ratingtext = ratingtext .. "\27[menu_star_03]"
					elseif frac > 0.33 then
						-- 1/3 star
						ratingtext = ratingtext .. "\27[menu_star_02]"
					elseif 5 - int > 0 then
						-- empty star
						ratingtext = ratingtext .. "\27[menu_star_01]"
					end
					-- empty stars
					if 5 - int - 1 > 0 then
						ratingtext = ratingtext .. string.rep("\27[menu_star_01]", 5 - int - 1)
					end

					addRow(textrows, "    " .. warename .. ReadText(1001, 120) .. string.format(" %s", curamount), ratingtext)
				end
			end
		end
		setKnown(component)

	elseif IsComponentClass(component, "satellite")
		or IsComponentClass(component, "mine")
		or IsComponentClass(component, "navbeacon") then
		-- Various objects with hull
		addHullShieldRows(textrows, component)

	elseif IsComponentClass(component, "collectable") then
		-- Collectable
		factionIcon = nil
		local collectable = GetCollectableData(component)
		if collectable.type == "ammo" then
			addTwoRows(textrows, collectable.name, nil, ReadText(1001, 1202) .. ReadText(1001, 120), collectable.amount)	-- Amount:
		elseif collectable.type == "wares" then
			local totalprice = 0
			for warenum, ware in ipairs(collectable.wares) do
				local warename, avgprice, inventory, ispaintmod = GetWareData(ware.ware, "name", "avgprice", "inventory", "ispaintmod")
				addTwoRows(textrows, warename, nil, ReadText(1001, 1202) .. ReadText(1001, 120), ware.amount)	-- Amount:
				totalprice = totalprice + (avgprice * ware.amount)
				AddKnownItem(inventory and (ispaintmod and "paintmods" or "inventory_wares") or "wares", ware.ware)
				if not interaction then
					if C.IsStoryFeatureUnlocked("x4ep1_encyclopedia") then
						interaction = "encyclopedia interaction"
						interactionComponent = { inventory and "inventory_wares" or "wares", ware.ware }
					end
				end
			end
			if totalprice > 0 then
				addRow(textrows, ReadText(1001, 2980) .. ReadText(1001, 120), ConvertMoneyString(totalprice, false, true, 0, true) .. " " .. ReadText(1001, 101))	-- Average Price:
			end
			if collectable.money > 0 then
				addRow(textrows, ReadText(1001, 37) .. ReadText(1001, 120), ConvertMoneyString(collectable.money, false, true, 0, true) .. " " .. ReadText(1001, 101)) -- Credits:
			else
				addStorageWarningPlaceholders(textrows)
			end
		elseif collectable.type == "shieldrestore" then
			if collectable.restoretype == "duration" then
				addRow(textrows, ReadText(1001, 82) .. ReadText(1001, 120), string.format("%d %s", collectable.value, ReadText(1001, 100)))		-- Charging Duration:
			elseif collectable.restoretype == "percent" then
				addRow(textrows, ReadText(1001, 83) .. ReadText(1001, 120), string.format("%d%%", collectable.value))		-- Strength:
			elseif collectable.restoretype == "hp" then
				addRow(textrows, ReadText(1001, 83) .. ReadText(1001, 120), collectable.value)		-- Strength:
			end
		end

	elseif IsComponentClass(component, "crate") then
		-- Crate
		factionIcon = nil
		local wares, money = GetComponentData(component, "wares", "money")
		local totalprice = 0
		if wares then
			-- remove "unknown" ware
			for warenum, ware in ipairs(wares) do
				if ware.ware == "unknown" then
					table.remove(wares, warenum)
					break
				end
			end
			for warenum, ware in ipairs(wares) do
				if #textrows >= defaults.maxnumrows - 1 then break end  -- leave room for total price
				local warename, avgprice, inventory, ispaintmod = GetWareData(ware.ware, "name", "avgprice", "inventory", "ispaintmod")
				addTwoRows(textrows, warename, nil, ReadText(1001, 1202) .. ReadText(1001, 120), ware.amount)	-- Amount:
				totalprice = totalprice + (avgprice * ware.amount)
				AddKnownItem(inventory and (ispaintmod and "paintmods" or "inventory_wares") or "wares", ware.ware)
				if not interaction then
					if C.IsStoryFeatureUnlocked("x4ep1_encyclopedia") then
						interaction = "encyclopedia interaction"
						interactionComponent = { inventory and "inventory_wares" or "wares", ware.ware }
					end
				end
			end
			if totalprice > 0 then
				addRow(textrows, ReadText(1001, 2980) .. ReadText(1001, 120), ConvertMoneyString(totalprice, false, true, 0, true) .. " " .. ReadText(1001, 101))	-- Average Price:
			end
		end
		if money and money > 0 then
			addRow(textrows, ReadText(1001, 37) .. ReadText(1001, 120), ConvertMoneyString(money, false, true, 0, true) .. " " .. ReadText(1001, 101))	-- Credits:
		end

	elseif IsComponentClass(component, "lockbox") then
		-- Lockbox
		factionIcon = nil
		addHullShieldRows(textrows, component)
		addRow(textrows, ReadText(1015, 110) .. ReadText(1001, 120), "$numlocks$")			-- Locks:

	elseif IsComponentClass(component, "datavault") then
		-- DataVault
		factionIcon = nil
		addRow(textrows, ReadText(1001, 12) .. ReadText(1001, 120), "$datavaultunlockstate$")	-- Status:

	elseif IsComponentClass(component, "dockingbay") then
		-- DockingBay
		header = "$containerheader$"
		local container = GetContextByClass(component, "container")
		if container then
			setKnown(container)
		end
		local npcs = GetPrioritizedPlatformNPCs(component)
		if npcs and #npcs > 0 then
			local showntypes = { }
			local shownnpcs = { }
			-- Go through list of NPCs in two passes
			for i = 1, 2, 1 do
				for npcnum, npc in ipairs(npcs) do
					if #textrows <= defaults.maxnumrows and not shownnpcs[npc] then
						-- NPC is not in the list yet
						local npcname, npcfaction, npctype, npcoccupationname = GetComponentData(npc, "name", "ownershortname", "typestring", "occupationname")
						-- In first pass, only add NPCs of a type that was not added before. In second pass, add any remaining NPCs.
						if not (i == 1 and showntypes[npctype]) then
							addTwoRows(textrows, npcname, npcfaction, nil, npcoccupationname)
							showntypes[npctype] = true
							shownnpcs[npc] = true
						end
					end
				end
			end
		end
		interaction = "platform interaction"

	elseif IsComponentClass(component, "entity") then
		-- Entity
		local occupationname, skills = GetComponentData(component, "occupationname", "skills")
		addRow(textrows, { text = occupationname, color = defaults.textcolor, font = defaults.boldfont, fontsize = defaults.textfontsize })

		table.sort(skills, function(a, b) return a.relevance > b.relevance end)
		for _, skill in ipairs(skills) do
			local skilltext = "?"
			local bold = ""
			if skill.relevance > 0 then
				bold = "_bold"
			end

			local int, frac = math.modf(skill.value / 3)
			-- full stars
			skilltext = string.rep("\27[menu_star_04" .. bold .. "]", int)
			if frac > 0.66 then
				-- 2/3 star
				skilltext = skilltext .. "\27[menu_star_03" .. bold .. "]"
			elseif frac > 0.33 then
				-- 1/3 star
				skilltext = skilltext .. "\27[menu_star_02" .. bold .. "]"
			elseif 5 - int > 0 then
				-- empty star
				skilltext = skilltext .. "\27[menu_star_01" .. bold .. "]"
			end
			-- empty stars
			if 5 - int - 1 > 0 then
				skilltext = skilltext .. string.rep("\27[menu_star_01" .. bold .. "]", 5 - int - 1)
			end

			if skill.relevance > 0 then
				addRow(textrows, { text = ReadText(1013, skill.textid), color = defaults.textcolor, font = defaults.boldfont, fontsize = defaults.textfontsize }, skilltext)
			else
				addRow(textrows, ReadText(1013, skill.textid), skilltext)
			end
		end
		setKnown(component)

	elseif IsComponentClass(component, "container") or HasTag(component, templateConnectionName, "info") then
		-- Ship or Station
		local isstation = IsComponentClass(component, "station")
		local infopoint = HasTag(component, templateConnectionName, "info")
		header = infopoint and "$infopointheader$" or "$unlockheader$"

		local pilot, macro, isonlineobject = GetComponentData(component, "pilot", "macro", "isonlineobject")
		-- percentage revealed and commander
		local commander = (not infopoint) and GetCommander(component)
		if not isplayerowned or (not infopoint and not isstation) then
			if not isplayerowned then
				addRow(textrows, ReadText(1001, 81), "$revealpercent$%")		-- Information unlocked
			end
			if commander or (isplayerowned and not infopoint and not isstation) then
				addRow(textrows, ReadText(1001, 1112), "$commander$")
			end
		end
		if isonlineobject then
			local patroninfo = OnlineGetMultiversePatronInfo(component)
			addRow(textrows, ReadText(1001, 11804), patroninfo.team)
			addRow(textrows, ReadText(1001, 9121), "$currentventurename$")
		else
			-- command and action
			if pilot then
				addRow(textrows, ReadText(1001, 78), "$aicommand$")
				addRow(textrows, "", "$aicommandaction$")
			end
		end
		-- shield/hull
		addHullShieldRows(textrows, component)
		-- building
		if IsComponentClass(component, "container") then
			local buildanchor = GetBuildAnchor(component)
			if buildanchor then
				local curprogress = C.GetCurrentBuildProgress(ConvertIDTo64Bit(buildanchor))
				if curprogress >= 0 then
					addRow(textrows, "$buildingprogress$")
				end
			end
		end
		-- storage
		local storagearray = GetStorageData(component)
		local units = { }
		if IsComponentClass(component, "defensible") then
			units = GetUnitStorageData(component)
		end
		if next(storagearray) and (storagearray.capacity > 0 or storagearray.estimated) then
			addRow(textrows, ReadText(1001, 1400), "$storagedata$")
		elseif #units > 0 then
			addRow(textrows, ReadText(1001, 22), string.format("$unitsstored$ / %s", ConvertIntegerString(units.capacity, true, 4, true)))
		elseif hasInventory(component) then
			addRow(textrows, ReadText(1001, 2202))	-- Inventory
		else
			addRow(textrows, ReadText(1001, 1400), ReadText(1001, 9))	-- Storage -- None
		end
		-- crew
		if (not isonlineobject) and IsComponentClass(component, "ship") then
			addRow(textrows, ReadText(1001, 80), "$crew$")				-- Crew
		end
		-- weapon systems
		--addRow(textrows, ReadText(1001, 1105), "$weaponsystems$")	-- Weapon Systems
		-- productions
		if infopoint or isstation then
			local productionmodules = GetProductionModules(component)
			if productionmodules and #productionmodules > 0 then
				addRow(textrows, ReadText(1001, 1613), #productionmodules)	-- Productions
			else
				addRow(textrows, ReadText(1001, 1613), ReadText(1001, 29))	-- Productions -- None
			end
		end
		if infopoint then
			local container = GetContextByClass(component, "container", true)
			if container then
				-- Add station to encyclopedia
				AddKnownItem("stationtypes", GetComponentData(container, "macro"))
				-- Add module to encyclopedia
				if IsComponentClass(component, "production") then
					AddKnownItem("moduletypes_production", macro)
				elseif IsComponentClass(component, "storage") then
					AddKnownItem("moduletypes_storage", macro)
				elseif IsComponentClass(component, "radar") then
					AddKnownItem("moduletypes_communication", macro)
				elseif IsComponentClass(component, "habitation") then
					AddKnownItem("moduletypes_habitation", macro)
				elseif IsComponentClass(component, "welfaremodule") then
					AddKnownItem("moduletypes_welfare", macro)
				elseif IsComponentClass(component, "processingmodule") then
					AddKnownItem("moduletypes_processing", macro)
				elseif IsComponentClass(component, "radar") then
					AddKnownItem("moduletypes_radar", macro)
				end
			end
		end
		setKnown(component, faction)
		interaction = "object interaction"

	elseif HasTag(component, templateConnectionName, "mission") then
		local mname, mdesc, mfaction, mtype, mlevel, mreward, mrewardtext, moppfactionname, mlicencename, _, mid = GetMissionOfferAtConnection(component, templateConnectionName)
		local container = GetContextByClass(component, "container", true)
		if container and mname then
			header = mname
			faction = mfaction
			local factionDetails = C.GetFactionDetails(faction)
			factionIcon = ffi.string(factionDetails.factionIcon)
			notorietyComponent = nil
			-- Reward
			local rewardtext = ""
			if mreward ~= 0 then
				rewardtext = ConvertMoneyString(mreward, false, true, 0, true) .. " " .. ReadText(1001, 101)
				if mrewardtext and mrewardtext ~= "" then
					rewardtext = rewardtext .. ", " .. mrewardtext
				end
			else
				rewardtext = mrewardtext
			end
			addRow(textrows, ReadText(1001, 3301) .. ReadText(1001, 120), rewardtext)	-- Reward:
			-- Difficulty
			if not (mlevel == 0) then
				addRow(textrows, ReadText(1001, 3403) .. ReadText(1001, 120), ConvertMissionLevelString(mlevel))	-- Difficulty:
			end
			-- licence
			if mlicencename then
				addTwoRows(textrows, ReadText(1001, 3412) .. ReadText(1001, 120), nil, mlicencename)	-- Licence required:
			end
			-- Opposing faction
			if moppfactionname and moppfactionname ~= "" then
				addRow(textrows, ReadText(1001, 3411) .. ReadText(1001, 120), moppfactionname)	-- Opposing Faction:
			end
			-- Set faction known
			setKnown(nil, mfaction)
		end
		interaction = "missionoffer interaction"
		interactionComponent = mid

	elseif IsComponentConstruction(component) then
		header = "$unlockheader$"
		-- shield/hull
		addHullShieldRows(textrows, component)

	elseif not IsComponentOperational(component) or IsComponentClass(component, "recyclable") then
		-- Wreck or Recyclable
		if not IsComponentClass(component, "recyclable") then
			header = ReadText(1001, 27)		-- Wreck
		end
		factionIcon = nil
		local wares = GetComponentData(component, "recyclingwares")
		addRow(textrows, ReadText(1001, 5213))		-- Processable Wares:
		local displayed = false
		if wares then
			for warenum, ware in ipairs(wares) do
				if ware.amount > 0 then
					displayed = true
					local warename = GetWareData(ware.ware, "name")
					addTwoRows(textrows, "  " .. warename, nil, "  " .. ReadText(1001, 1202) .. ReadText(1001, 120), ware.amount)	-- Amount:
				end
			end
		end
		if not displayed then
			addRow(textrows, "  " .. ReadText(1001, 32)) -- none
		end
	end

	-- fill livedatacache to detect layout/data mismatches
	livedatacache.referenceComponent = component
	livedatacache.referenceConnectionName = templateConnectionName

	-- Assemble result table
	local result = { }

	-- Header and text elements
	if header then
		local color
		local activemissionid = C.GetActiveMissionID()
		if activemissionid ~= 0 and GetComponentData(component, "ismissiontarget") then
			-- Highlighted header for mission objective target
			-- NOTE: This requires a target monitor refresh whenever the current target starts or stops being a mission target - this is ensured in GetLiveData() via targetmonitorstate
			local missiondetails = C.GetMissionIDDetails2(activemissionid)
			local missionicon = ffi.string(missiondetails.missionIcon)
			if missionicon ~= "" then
				header = string.format("\027[%s] %s", missionicon, header)
			end
			color = Color["text_mission"]
		end
		result.header = createHeaderDescription(header, color)
	else
		result.header = createHeaderDescription("")
	end

	result.text = textrows
	result.duration = 0 -- infinite

	-- Faction data
	if factionIcon then
		result.notorietyIcon = factionIcon
		result.notorietyEffect = false
		result.notorietyFaction = faction
		result.notorietyComponent = notorietyComponent
	end

	-- Interaction
	if interaction then
		local universeIDType = ffi.typeof("UniverseID")
		if ffi.istype(universeIDType, interactionComponent) then
			interactionComponent = ConvertStringToLuaID(tostring(interactionComponent))
		end
		-- note: before 3.00 Beta 6 we added result.interactionDescriptor (through CreateInteractionDescriptor())
		--       since that function was deprecated, we dropped the usage - while technically this is a backwards
		--       compatibility breaking change, GetTargetMonitorDetails() is not considered part of the public UI API
		--       therefore we simply dropped the interactionDescriptor rather than trying to preserve it
		result.interactionID = CreateInteractionDescriptor2(interaction, interactionComponent)
	end

	return result
end

function GetLiveData(placeholder, component, templateConnectionName)
	-- First find the component we are interested in
	local targetdata = getTargetDataForDisplay(component, templateConnectionName)
	if targetdata then
		-- Update values
		component = targetdata.component
		templateConnectionName = targetdata.templateConnectionName

		if placeholder == "targetmonitorstate" then
			-- Hardcoded placeholder to determine whether the provided arguments are still valid.
			-- Return a consistent state value - once this state changes, the target monitor will refresh.
			if (not IsSameComponent(component, livedatacache.referenceComponent)) or (templateConnectionName ~= livedatacache.referenceConnectionName) then
				-- the actual live data reference componentslot has changed, tell the monitors presentation to update
				return "$update$"
			end
			if GetComponentData(component, "ismissiontarget") then
				return "missiontarget"
			end
			return "normal"

		elseif placeholder == "unitsstored" then
			if IsComponentClass(component, "defensible") then
				local units = GetUnitStorageData(component)
				return next(units) and ConvertIntegerString(units.stored, true, 4, true) or 0
			end

		elseif placeholder == "containerheader" or placeholder == "buyofferheader" or placeholder == "sellofferheader" then
			local header = (placeholder == "containerheader" and getHeaderName(component) or (placeholder == "buyofferheader" and ReadText(1001, 2954) or ReadText(1001, 2955)))
			local container = GetContextByClass(component, "container")
			if container then
				header = getHeaderName(container, header)
			end
			return header

		elseif placeholder == "unlockheader" or placeholder == "infopointheader" then
			local header = unlockInfo(IsInfoUnlockedForPlayer(component, "name"), getHeaderName(component, IsComponentConstruction(component) and ReadText(1001, 71) or nil))
			if placeholder == "infopointheader" then
				local container = GetContextByClass(component, "container", true)
				if container then
					header = getHeaderName(container, (header ~= "" and header or ReadText(1001, 56)))
				end
			end
			return header

		elseif placeholder == "zoneheader" then
			return getHeaderName(component)

		elseif placeholder == "locationheader" then
			if IsComponentClass(component, "space") then
				return string.format(ReadText(1001, 5218), getHeaderName(component))
			else
				return string.format(ReadText(1001, 5217), getHeaderName(component))
			end

		elseif placeholder == "commander" then
			if IsComponentClass(component, "controllable") then
				local commander = GetCommander(component)
				local unlocked_operator_name = IsInfoUnlockedForPlayer(component, "operator_name")
				return unlockInfo(unlocked_operator_name, commander and GetComponentData(commander, "name") or ReadText(1001, 85))
			end

		elseif placeholder == "aicommand" then
			local pilot = GetComponentData(component, "pilot")
			if pilot then
				local unlocked_operator_commands = IsInfoUnlockedForPlayer(component, "operator_commands")
				local aicommandstack, aicommand, aicommandparam, aicommandaction, aicommandactionparam = GetComponentData(pilot, "aicommandstack", "aicommand", "aicommandparam", "aicommandaction", "aicommandactionparam")
				if #aicommandstack > 0 then
					aicommand = aicommandstack[1].command
					aicommandparam = aicommandstack[1].param
				end
				return unlockInfo(unlocked_operator_commands, string.format(aicommand, IsComponentClass(aicommandparam, "component") and GetComponentData(aicommandparam, "name") or nil))
			else
				return ""
			end

		elseif placeholder == "aicommandaction" then
			local pilot = GetComponentData(component, "pilot")
			if pilot then
				local unlocked_operator_commands = IsInfoUnlockedForPlayer(component, "operator_commands")
				local aicommandstack, aicommand, aicommandparam, aicommandaction, aicommandactionparam = GetComponentData(pilot, "aicommandstack", "aicommand", "aicommandparam", "aicommandaction", "aicommandactionparam")
				local numaicommands = #aicommandstack
				if numaicommands > 1 then
					aicommandaction = aicommandstack[numaicommands].command
					aicommandactionparam = aicommandstack[numaicommands].param
				end
				return unlockInfo(unlocked_operator_commands, string.format(aicommandaction, IsComponentClass(aicommandactionparam, "component") and GetComponentData(aicommandactionparam, "name") or nil))
			else
				return ""
			end

		elseif placeholder == "hackexpirationtime" then
			local controlpanel = ffi.new("UIComponentSlot")
			controlpanel.component = ConvertIDTo64Bit(component)
			controlpanel.connection = templateConnectionName
			local controlpanelinfo = C.GetControlPanelInfo(controlpanel)
			local hackexpire = controlpanelinfo.hackexpiretime
			return ConvertTimeString(hackexpire > 0 and math.max(hackexpire - C.GetCurrentGameTime(), 0) or 0, "%T")

		elseif placeholder == "buildingprogress" then
			local buildanchor = GetBuildAnchor(component)
			if buildanchor then
				local progress = C.GetCurrentBuildProgress(ConvertIDTo64Bit(buildanchor))
				if progress >= 0 then
					return string.format(ReadText(1001, 1805), progress)
				else
					return ""
				end
			else
				return ""
			end

		elseif placeholder == "numlocks" then
			local numlocks, numlockslots = GetComponentData(component, "numlocks", "numlockslots")
			return string.format("%d / %d", numlocks, numlockslots)

		elseif placeholder == "datavaultunlockstate" then
			local unlockstate = GetComponentData(component, "datavaultunlockstate")
			if unlockstate == "unlocked" then
				return ReadText(1001, 5221)
			elseif unlockstate == "partial_unlock" then
				return ReadText(1001, 5220)
			else
				return ReadText(1001, 5219)
			end

		elseif placeholder == "storagedata" then
			local isstation = IsComponentClass(component, "station")
			local storagearray = GetStorageData(component)
			local unlocked_storage_amounts = IsInfoUnlockedForPlayer(component, "storage_amounts") or (isstation and storagearray.estimated ~= nil)
			local unlocked_storage_capacity = IsInfoUnlockedForPlayer(component, "storage_capacity") or (isstation and storagearray.estimated ~= nil)
			local storageamount = unlockInfo(unlocked_storage_amounts, next(storagearray) and ConvertIntegerString(storagearray.stored, true, 4, true) or 0)
			local storagecapacity = unlockInfo(unlocked_storage_capacity, next(storagearray) and ConvertIntegerString(storagearray.capacity, true, 4, true) or 0)
			return estimateString(isstation and storagearray.estimated) .. storageamount .. " / " .. storagecapacity

		elseif placeholder == "crew" then
			local unlocked_operator_name = IsInfoUnlockedForPlayer(component, "operator_name")
			local totalcrewcapacity = C.GetPeopleCapacity(ConvertIDTo64Bit(component), "", true)
			local totalcrewcount = GetComponentData(component, "assignedaipilot") and 1 or 0
			local numroles = C.GetNumAllRoles()
			local peopletable = ffi.new("PeopleInfo[?]", numroles)
			numroles = C.GetPeople2(peopletable, numroles, ConvertIDTo64Bit(component), true)
			for i = 0, numroles - 1 do
				totalcrewcount = totalcrewcount + peopletable[i].amount
			end
			return unlockInfo(unlocked_operator_name, totalcrewcount .. " / " .. totalcrewcapacity)

		elseif placeholder == "weaponsystems" then
			local weapons = GetAllWeapons(component)
			local unlocked_defence_status = IsInfoUnlockedForPlayer(component, "defence_status")
			local weapontext
			if (next(weapons.weapons) and (#weapons.weapons ~= 0)) or (next(weapons.missiles) and (#weapons.missiles ~= 0)) then
				weapontext = #weapons.weapons + #weapons.missiles
			else
				weapontext = ReadText(1001, 28) -- None
			end
			return unlockInfo(unlocked_defence_status, weapontext)

		elseif placeholder == "shieldpercent" then
			local details = C.GetComponentDetails(ConvertIDTo64Bit(component), "")
			return tostring(Helper.round(details.shield))

		elseif placeholder == "storagewarning" or placeholder == "storagereason" then
			local wares, isdroppedcontainer
			if IsComponentClass(component, "asteroid") then		-- asteroid
				wares = GetComponentData(component, "wares")
				isdroppedcontainer = false
			else												-- collectablewares
				local collectable = GetCollectableData(component)
				wares = collectable.wares
				isdroppedcontainer = collectable.isdroppedcontainer
			end
			-- Generate warning if there is a cargo ware that cannot be collected by the player-controlled ship
			if wares then
				for _, ware in ipairs(wares) do
					if ware.amount > 0 and GetWareData(ware.ware, "iscargo") then
						local playeroccupiedship64 = C.GetPlayerOccupiedShipID()
						if playeroccupiedship64 ~= 0 then
							local playeroccupiedship = ConvertStringTo64Bit(tostring(playeroccupiedship64))
							-- check free cargo space for ware on player ship
							if GetWareCapacity(playeroccupiedship, ware.ware, false) == 0 then
								if placeholder == "storagewarning" then
									return isdroppedcontainer and ReadText(1015, 55) or ReadText(1015, 56)			-- Cannot collect container / Cannot collect materials
								else			-- "storagereason"
									local hascapacity = GetWareCapacity(playeroccupiedship, ware.ware, true) ~= 0
									local reasontext = hascapacity and ReadText(1015, 53) or ReadText(1015, 54)		-- Cargo storage full ($STORAGETYPE$) / Incompatible storage type ($STORAGETYPE$)
									return Helper.substituteText(reasontext, { ["$STORAGETYPE$"] = getWareStorageName(GetWareData(ware.ware, "transport"), playeroccupiedship64) })
								end
							end
						end
					end
				end
			end
			return ""

		else
			-- default case: pass placeholder directly to GetComponentData()
			local data = GetComponentData(component, placeholder)
			if data then
				return tostring(data)
			end
		end
	end
end
