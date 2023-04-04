local ffi = require ("ffi")
local C = ffi.C
local Lib = require ("extensions.sn_mod_support_apis.lua_interface").Library
local shipConfigurationMenu
local oldFuncs = {}
local newFuncs = {}
local callbacks = {}
local isInited
local function init ()
	-- DebugError ("kuertee_menu_ship_configuration.init")
	if not isInited then
		isInited = true
		shipConfigurationMenu = Lib.Get_Egosoft_Menu ("ShipConfigurationMenu")
		shipConfigurationMenu.registerCallback = newFuncs.registerCallback
		-- rewrites: 
		oldFuncs.displaySlots = shipConfigurationMenu.displaySlots
		shipConfigurationMenu.displaySlots = newFuncs.displaySlots
	end
end
function newFuncs.registerCallback (callbackName, callbackFunction)
	-- note 1: format is generally [function name]_[action]. e.g.: in kuertee_menu_transporter, "display_on_set_room_active" overrides the room's active property with the return of the callback.
	-- note 2: events have the word "_on_" followed by a PRESET TENSE verb. e.g.: in kuertee_menu_transporter, "display_on_set_buttontable" is called after all of the rows of buttontable are set.
	-- note 3: new callbacks can be added or existing callbacks can be edited. but commit your additions/changes to the mod's GIT repository.
	-- note 4: search for the callback names to see where they are executed.
	-- note 5: if a callback requires a return value, return it in an object var. e.g. "display_on_set_room_active" requires a return of {active = true | false}.
	-- available callbacks:
	-- displaySlots_on_before_create_button_mouseovertext ()
	--
	if callbacks [callbackName] == nil then
		callbacks [callbackName] = {}
	end
	table.insert (callbacks [callbackName], callbackFunction)
end
-- just copy the whole config - but ensure that all references to "menu." is correct.
local config = {
	mainLayer = 5,
	infoLayer = 4,
	contextLayer = 2,
	classorder = { "ship_xl", "ship_l", "ship_m", "ship_s", "ship_xs" },
	leftBar = {
		{ name = ReadText(1001, 1103),	icon = "shipbuildst_engine",		mode = "engine",		iscapship = false },
		{ name = ReadText(1001, 8520),	icon = "shipbuildst_enginegroups",	mode = "enginegroup",	iscapship = true },
		{ name = ReadText(1001, 8001),	icon = "shipbuildst_thruster",		mode = "thruster" },
		{ name = ReadText(1001, 1317),	icon = "shipbuildst_shield",		mode = "shield" },
		{ name = ReadText(1001, 2663),	icon = "shipbuildst_weapon",		mode = "weapon" },
		{ name = ReadText(1001, 1319),	icon = "shipbuildst_turret",		mode = "turret",		iscapship = false },
		{ name = ReadText(1001, 7901),	icon = "shipbuildst_turretgroups",	mode = "turretgroup",	iscapship = true },
		{ name = ReadText(1001, 87),	icon = "shipbuildst_software",		mode = "software" },
		{ spacing = true,																			comparison = false },
		{ name = ReadText(1001, 8003),	icon = "shipbuildst_consumable",	mode = "consumables",	comparison = false },
		{ name = ReadText(1001, 80),	icon = "shipbuildst_crew",			mode = "crew",			comparison = false },
		{ spacing = true,																			customgamestart = false,	comparison = false,		hascontainer = true },
		{ name = ReadText(1001, 3000),	icon = "shipbuildst_repair",		mode = "repair",		customgamestart = false,	comparison = false,		hascontainer = true },
		{ spacing = true,																			comparison = false,			hascontainer = true },
		{ name = ReadText(1001, 8549),	icon = "tlt_optionsmenu",			mode = "settings",		comparison = false,			hascontainer = true },
	},
	leftBarMods = {
		{ name = ReadText(1001, 8038),	icon = "shipbuildst_chassis",		mode = "shipmods",		upgrademode = "ship",	modclass = "ship" },
		{ name = ReadText(1001, 6600),	icon = "shipbuildst_weapon",		mode = "weaponmods",	upgrademode = "weapon",	modclass = "weapon" },
		{ name = ReadText(1001, 8004),	icon = "shipbuildst_turret",		mode = "turretmods",	upgrademode = "turret",	modclass = "weapon" },
		{ name = ReadText(1001, 8515),	icon = "shipbuildst_shield",		mode = "shieldmods",	upgrademode = "shield",	modclass = "shield" },
		{ name = ReadText(1001, 8028),	icon = "shipbuildst_engine",		mode = "enginemods",	upgrademode = "engine",	modclass = "engine" },
		{ name = ReadText(1001, 8510),	icon = "shipbuildst_paint",			mode = "paintmods",		upgrademode = "paint",	modclass = "paint" },
	},
	dropDownTextProperties = {
		halign = "center",
		font = Helper.standardFont,
		fontsize = Helper.scaleFont(Helper.standardFont, Helper.standardFontSize),
		color = Helper.color.white,
		x = 0,
		y = 0
	},
	stateKeys = {
		{ "object", "UniverseID" },
		{ "macro" },
		{ "class" },
		{ "upgradetypeMode" },
		{ "currentSlot" },
		{ "upgradeplan" },
		{ "crew" },
		{ "editingshoppinglist" },
		{ "loadoutName" },
		{ "captainSelected", "bool" },
		{ "validLicence", "bool" },
		{ "validLoadoutPossible", "bool" },
		{ "shoppinglist" },
	},
	dropdownRatios = {
		class = 0.7,
		ship = 1.3,
	},
	stats = {
		{ id = "HullValue",					name = ReadText(1001, 8048),	unit = ReadText(1001, 118),	type = "float",		accuracy = 0 },
		{ id = "ShieldValue",				name = ReadText(1001, 8049),	unit = ReadText(1001, 118),	type = "float",		accuracy = 0 },
		{ id = "ShieldRate",				name = "   " .. ReadText(1001, 8553),	unit = ReadText(1001, 119),	type = "float",		accuracy = 0 },
		{ id = "ShieldDelay",				name = "   " .. ReadText(1001, 8554),	unit = ReadText(1001, 100),	type = "double",	accuracy = 2,	inverted = true },
		{ id = "GroupedShieldValue",		name = ReadText(1001, 8533),	unit = ReadText(1001, 118),	type = "float",		accuracy = 0,	mouseovertext = ReadText(1026, 8018) },
		{ id = "GroupedShieldRate",			name = "   " .. ReadText(1001, 8553),	unit = ReadText(1001, 119),	type = "float",		accuracy = 0 },
		{ id = "GroupedShieldDelay",		name = "   " .. ReadText(1001, 8554),	unit = ReadText(1001, 100),	type = "double",	accuracy = 2,	inverted = true },
		{ id = "RadarRange",				name = ReadText(1001, 8068),	unit = ReadText(1001, 108),	type = "float",		accuracy = 0 },
		{ id = "BurstDPS",					name = ReadText(1001, 8073),	unit = ReadText(1001, 119),	type = "float",		accuracy = 0 },
		{ id = "SustainedDPS",				name = ReadText(1001, 8074),	unit = ReadText(1001, 119),	type = "float",		accuracy = 0 },
		{ id = "TurretSustainedDPS",		name = ReadText(1001, 8532),	unit = ReadText(1001, 119),	type = "float",		accuracy = 0,	mouseovertext = ReadText(1026, 8017),	capshipid = "GroupedTurretSustainedDPS" },
		{ id = "" },
		{ id = "CrewCapacity",				name = ReadText(1001, 8057),	unit = "",					type = "UINT",		accuracy = 0 },
		{ id = "UnitCapacity",				name = ReadText(1001, 8061),	unit = "",					type = "UINT",		accuracy = 0 },
		{ id = "MissileCapacity",			name = ReadText(1001, 8062),	unit = "",					type = "UINT",		accuracy = 0 },
		{ id = "DeployableCapacity",		name = ReadText(1001, 8064),	unit = "",					type = "UINT",		accuracy = 0 },
		{ id = "CountermeasureCapacity",	name = ReadText(1001, 8063),	unit = "",					type = "UINT",		accuracy = 0 },
		{ id = "" },
		{ id = "" },
		-- new column
		{ id = "ForwardSpeed",				name = ReadText(1001, 8051),	unit = ReadText(1001, 113),	type = "float",		accuracy = 0 },
		{ id = "ForwardAcceleration",		name = ReadText(1001, 8069),	unit = ReadText(1001, 111),	type = "float",		accuracy = 0 },
		{ id = "BoostSpeed",				name = ReadText(1001, 8052),	unit = ReadText(1001, 113),	type = "float",		accuracy = 0 },
		{ id = "TravelSpeed",				name = ReadText(1001, 8053),	unit = ReadText(1001, 113),	type = "float",		accuracy = 0 },
		{ id = "HorizontalStrafeSpeed",		name = ReadText(1001, 8559),	unit = ReadText(1001, 113),	type = "float",		accuracy = 1 },
		{ id = "HorizontalStrafeAcceleration",	name = ReadText(1001, 8560),	unit = ReadText(1001, 111),	type = "float",		accuracy = 1 },
		{ id = "YawSpeed",					name = ReadText(1001, 8054),	unit = ReadText(1001, 117),	type = "float",		accuracy = 1 },
		{ id = "PitchSpeed",				name = ReadText(1001, 8055),	unit = ReadText(1001, 117),	type = "float",		accuracy = 1 },
		{ id = "RollSpeed",					name = ReadText(1001, 8056),	unit = ReadText(1001, 117),	type = "float",		accuracy = 1 },
		{ id = "" },
		{ id = "ContainerCapacity",			name = ReadText(1001, 8058),	unit = ReadText(1001, 110),	type = "UINT",		accuracy = 0 },
		{ id = "SolidCapacity",				name = ReadText(1001, 8059),	unit = ReadText(1001, 110),	type = "UINT",		accuracy = 0 },
		{ id = "LiquidCapacity",			name = ReadText(1001, 8060),	unit = ReadText(1001, 110),	type = "UINT",		accuracy = 0 },
		{ id = "CondensateCapacity",		name = ReadText(20109, 9801),	unit = ReadText(1001, 110),	type = "UINT",		accuracy = 0 },
		{ id = "" },
		{ id = "NumDocksShipMedium",		name = ReadText(1001, 8524),	unit = "",					type = "UINT",		accuracy = 0 },
		{ id = "NumDocksShipSmall",			name = ReadText(1001, 8525),	unit = "",					type = "UINT",		accuracy = 0 },
		{ id = "ShipCapacityMedium",		name = ReadText(1001, 8526),	unit = "",					type = "UINT",		accuracy = 0 },
		{ id = "ShipCapacitySmall",			name = ReadText(1001, 8527),	unit = "",					type = "UINT",		accuracy = 0 },
	},
	scaleSize = 2,
	deployableOrder = {
		["satellite"]		= 1,
		["navbeacon"]		= 2,
		["resourceprobe"]	= 3,
		["lasertower"]		= 4,
		["mine"]			= 5,
		[""]				= 6,
	},
	maxStatusRowCount = 9,
	comparisonShipLibraries = { "shiptypes_xl", "shiptypes_l", "shiptypes_m", "shiptypes_s" },
	comparisonEquipmentLibraries = {
		{ library = "weapons_lasers",			type = "weapon" },
		{ library = "weapons_missilelaunchers",	type = "weapon" },
		{ library = "weapons_turrets",			type = "turret" },
		{ library = "weapons_missileturrets",	type = "turret" },
		{ library = "shieldgentypes",			type = "shield" },
		{ library = "enginetypes",				type = "engine" },
		{ library = "thrustertypes",			type = "thruster" },
	},
	maxSlotRows = 50,
	undoSteps = 100,
	maxSidePanelWidth = 800,
	maxCenterPanelWidth = 1600,
	compatibilityFontSize = 5,
	equipmentfilter_races_width = 300,
}
function newFuncs.displaySlots(frame, firsttime)
	local menu = shipConfigurationMenu

	if menu.upgradetypeMode and ((menu.mode ~= "purchase") or menu.validLicence) then
		local upgradetype = Helper.findUpgradeType(menu.upgradetypeMode)

		local count, rowcount, slidercount = 1, 0, 0
		menu.groupedupgrades = {}

		local slots = {}
		if (menu.upgradetypeMode ~= "enginegroup") and (menu.upgradetypeMode ~= "turretgroup") and (menu.upgradetypeMode ~= "consumables") and (menu.upgradetypeMode ~= "crew") and (menu.upgradetypeMode ~= "repair") and (menu.upgradetypeMode ~= "software") and (menu.upgradetypeMode ~= "settings") then
			if (upgradetype.supertype == "macro") or (upgradetype.supertype == "virtualmacro") then
				slots = menu.slots[menu.upgradetypeMode] or {}
			end
		end

		menu.currentSlot = menu.checkCurrentSlot(slots, menu.currentSlot)
		local currentSlotInfo = {}

		if (menu.upgradetypeMode == "enginegroup") or (menu.upgradetypeMode == "turretgroup") then
			local upgradegroup = menu.groups[menu.currentSlot]
			if upgradegroup then
				for i, upgradetype2 in ipairs(Helper.upgradetypes) do
					local upgradegroupcount = 1
					if upgradetype2.supertype == "group" then
						menu.groupedupgrades[upgradetype2.grouptype] = {}
						for i, macro in ipairs(upgradegroup[upgradetype2.grouptype].possiblemacros) do
							local macroname, makerrace, makerracename = GetMacroData(macro, "name", "makerraceid", "makerracename")
							for race_i, race in ipairs(makerrace) do
								if (not menu.equipmentfilter_races[race]) then
									menu.equipmentfilter_races[race] = { id = race, name = makerracename[race_i] }
								end
								if (not menu.equipmentfilter_races[race].upgradeTypes) then
									menu.equipmentfilter_races[race].upgradeTypes = {}
								end
								if (not menu.equipmentfilter_races[race].upgradeTypes[menu.upgradetypeMode]) then
									menu.equipmentfilter_races[race].upgradeTypes[menu.upgradetypeMode] = true
								end
							end
							if (#menu.equipmentsearchtext == 0) or menu.filterUpgradeByText(macro, menu.equipmentsearchtext) then
								local group = math.ceil(upgradegroupcount / 3)
								menu.groupedupgrades[upgradetype2.grouptype][group] = menu.groupedupgrades[upgradetype2.grouptype][group] or {}
								table.insert(menu.groupedupgrades[upgradetype2.grouptype][group], { macro = macro, icon = (C.IsIconValid("upgrade_" .. macro) and ("upgrade_" .. macro) or "upgrade_notfound"), name = macroname })
								upgradegroupcount = upgradegroupcount + 1
							end
						end

						if (not menu.isReadOnly) and upgradetype2.allowempty then
							local group = math.ceil(upgradegroupcount / 3)
							menu.groupedupgrades[upgradetype2.grouptype][group] = menu.groupedupgrades[upgradetype2.grouptype][group] or {}
							table.insert(menu.groupedupgrades[upgradetype2.grouptype][group], { macro = "", icon = "upgrade_empty", name = ReadText(1001, 7906) })
							upgradegroupcount = upgradegroupcount + 1
						end
					end
					if upgradegroupcount > 1 then
						slidercount = slidercount + 1
					end
					rowcount = rowcount + math.ceil((upgradegroupcount - 1) / 3)
				end
			end
		elseif (menu.upgradetypeMode == "repair") then
			if menu.objectgroup then
				for i, ship in ipairs(menu.objectgroup.ships) do
					if #menu.objectgroup.shipdata[i].damagedcomponents > 0 then
						local group = math.ceil(count / 3)
						menu.groupedupgrades[group] = menu.groupedupgrades[group] or {}
						table.insert(menu.groupedupgrades[group], { macro = ship.macro, icon = (C.IsIconValid("ship_" .. ship.macro) and ("ship_" .. ship.macro) or "ship_notfound"), name = ship.name, component = ship.ship })
						count = count + 1
					end
				end
			else
				local component = menu.object
				local group = math.ceil(count / 3)
				local macro = GetComponentData(ConvertStringTo64Bit(tostring(component)), "macro")
				local macroname, makerrace, makerracename = GetMacroData(macro, "name", "makerraceid", "makerracename")
				for race_i, race in ipairs(makerrace) do
					if (not menu.equipmentfilter_races[race]) then
						menu.equipmentfilter_races[race] = { id = race, name = makerracename[race_i] }
					end
					if (not menu.equipmentfilter_races[race].upgradeTypes) then
						menu.equipmentfilter_races[race].upgradeTypes = {}
					end
					if (not menu.equipmentfilter_races[race].upgradeTypes[menu.upgradetypeMode]) then
						menu.equipmentfilter_races[race].upgradeTypes[menu.upgradetypeMode] = true
					end
				end
				menu.groupedupgrades[group] = menu.groupedupgrades[group] or {}
				table.insert(menu.groupedupgrades[group], { macro = macro, icon = (C.IsIconValid("ship_" .. macro) and ("ship_" .. macro) or "ship_notfound"), name = macroname, component = component })
				count = count + 1
			end
			rowcount = rowcount + math.ceil(count / 3)
		elseif (menu.upgradetypeMode ~= "consumables") and (menu.upgradetypeMode ~= "crew") and (menu.upgradetypeMode ~= "software") and (menu.upgradetypeMode ~= "settings") then
			if #slots > 0 then
				if (upgradetype.supertype == "macro") or (upgradetype.supertype == "virtualmacro") then
					for i, macro in ipairs(slots[menu.currentSlot].possiblemacros) do
						local macroname, makerrace, makerracename = GetMacroData(macro, "name", "makerraceid", "makerracename")
						for race_i, race in ipairs(makerrace) do
							if (not menu.equipmentfilter_races[race]) then
								menu.equipmentfilter_races[race] = { id = race, name = makerracename[race_i] }
							end
							if (not menu.equipmentfilter_races[race].upgradeTypes) then
								menu.equipmentfilter_races[race].upgradeTypes = {}
							end
							if (not menu.equipmentfilter_races[race].upgradeTypes[menu.upgradetypeMode]) then
								menu.equipmentfilter_races[race].upgradeTypes[menu.upgradetypeMode] = true
							end
						end
						if (#menu.equipmentsearchtext == 0) or menu.filterUpgradeByText(macro, menu.equipmentsearchtext) then
							local group = math.ceil(count / 3)
							menu.groupedupgrades[group] = menu.groupedupgrades[group] or {}
							table.insert(menu.groupedupgrades[group], { macro = macro, icon = (C.IsIconValid("upgrade_" .. macro) and ("upgrade_" .. macro) or "upgrade_notfound"), name = macroname })
							count = count + 1
						end
					end

					if (not menu.isReadOnly) and (upgradetype.allowempty and (not C.IsSlotMandatory(menu.object, 0, menu.macro, false, upgradetype.type, menu.currentSlot))) then
						local group = math.ceil(count / 3)
						menu.groupedupgrades[group] = menu.groupedupgrades[group] or {}
						table.insert(menu.groupedupgrades[group], { macro = "", icon = "upgrade_empty", name = ReadText(1001, 7906) })
						count = count + 1
					end
				end
			end
			rowcount = rowcount + math.ceil(count / 3)
		end

		menu.groupedslots = {}
		local groupedslots = {}
		if (menu.upgradetypeMode == "enginegroup") or (menu.upgradetypeMode == "turretgroup") then
			local groupcount = 1
			for i, upgradegroup in ipairs(menu.groups) do
				if (menu.upgradetypeMode == "enginegroup") == (upgradegroup["engine"].total > 0) then
					local groupname = upgradegroup.groupname
					local slotsize = upgradegroup[upgradetype.grouptype].slotsize
					local compatibilities = upgradegroup[upgradetype.grouptype].compatibilities

					if i == menu.currentSlot then
						currentSlotInfo.slotsize = slotsize
						currentSlotInfo.compatibilities = compatibilities
					end

					table.insert(groupedslots, { i, upgradegroup, groupname, sizecount = i, slotsize = slotsize, compatibilities = compatibilities })
					groupcount = groupcount + 1
				end
			end
		elseif menu.upgradetypeMode == "repair" then
			local slotcount = 1
			menu.repairslots = {}

			if menu.objectgroup then
				for i, ship in ipairs(menu.objectgroup.ships) do
					if #menu.objectgroup.shipdata[i].damagedcomponents > 0 then
						local group = math.ceil(i / 3)

						menu.repairslots[group] = menu.repairslots[group] or {}
						table.insert(menu.repairslots[group], { i, ship.macro, i, ship.ship })
					end
				end
			else
				if #menu.damagedcomponents > 0 then
					local component = menu.object
					local group = math.ceil(slotcount / 3)
					local macro = GetComponentData(ConvertStringTo64Bit(tostring(component)), "macro")
					local slotnum = 1

					menu.repairslots[group] = menu.repairslots[group] or {}
					table.insert(menu.repairslots[group], {slotnum, macro, slotcount, component})
				end
			end
		elseif (menu.upgradetypeMode ~= "consumables") and (menu.upgradetypeMode ~= "software") and (menu.upgradetypeMode ~= "settings") then
			if not upgradetype.mergeslots then
				for i, slot in ipairs(slots) do
					if not slot.isgroup then
						local slotname = slot.slotname
						local slotsize = slot.slotsize

						local compatibilities
						local n = C.GetNumSlotCompatibilities(menu.object, 0, menu.macro, false, upgradetype.type, i)
						if n > 0 then
							compatibilities = {}
							local buf = ffi.new("EquipmentCompatibilityInfo[?]", n)
							n = C.GetSlotCompatibilities(buf, n, menu.object, 0, menu.macro, false, upgradetype.type, i)
							for j = 0, n - 1 do
								compatibilities[ffi.string(buf[j].tag)] = ffi.string(buf[j].name)
							end
						end

						if i == menu.currentSlot then
							currentSlotInfo.slotsize = slotsize
							currentSlotInfo.compatibilities = compatibilities
						end

						table.insert(groupedslots, { i, slot, slotname, sizecount = i, slotsize = slotsize, compatibilities = compatibilities })
					end
				end
			else
				if upgradetype.supertype == "macro" then
					currentSlotInfo.slotsize = ffi.string(C.GetSlotSize(menu.object, 0, menu.macro, false, upgradetype.type, menu.currentSlot))

					local n = C.GetNumSlotCompatibilities(menu.object, 0, menu.macro, false, upgradetype.type, menu.currentSlot)
					if n > 0 then
						currentSlotInfo.compatibilities = {}
						local buf = ffi.new("EquipmentCompatibilityInfo[?]", n)
						n = C.GetSlotCompatibilities(buf, n, menu.object, 0, menu.macro, false, upgradetype.type, menu.currentSlot)
						for j = 0, n - 1 do
							currentSlotInfo.compatibilities[ffi.string(buf[j].tag)] = ffi.string(buf[j].name)
						end
					end
				end
			end
		end
		table.sort(groupedslots, Helper.sortSlots)

		for i, entry in ipairs(groupedslots) do
			local group = math.ceil(i / 9)
			menu.groupedslots[group] = menu.groupedslots[group] or {}
			table.insert(menu.groupedslots[group], entry)
		end

		menu.rowHeight = math.max(23, Helper.scaleY(Helper.standardTextHeight))
		menu.extraFontSize = Helper.scaleFont(Helper.standardFont, Helper.standardFontSize)
		local maxSlotWidth = math.floor((menu.slotData.width - 8 * Helper.borderSize) / 9)

		local hasScrollbar = false
		local headerHeight = menu.titleData.height + #menu.groupedslots * (maxSlotWidth + Helper.borderSize) + menu.rowHeight + 2 * Helper.borderSize
		local boxTextHeight = math.ceil(C.GetTextHeight(" \n ", Helper.standardFont, menu.extraFontSize, 0)) + 2 * Helper.borderSize
		--[[ Keep for simpler debugging
			print((Helper.viewHeight - 2 * menu.slotData.offsetY) .. " vs " .. (headerHeight + rowcount * (3 * (maxSlotWidth + Helper.borderSize) + boxTextHeight) + slidercount * (menu.subHeaderRowHeight + Helper.borderSize)))
			print(headerHeight)
			print(boxTextHeight)
			print(rowcount .. " * " .. 3 * (maxSlotWidth + Helper.borderSize))
			print(slidercount .. " * " .. menu.subHeaderRowHeight + Helper.borderSize) --]]
		if (Helper.viewHeight - 2 * menu.slotData.offsetY) < (headerHeight + rowcount * (3 * (maxSlotWidth + Helper.borderSize) + boxTextHeight) + slidercount * (menu.subHeaderRowHeight + Helper.borderSize)) then
			hasScrollbar = true
		end

		local slotWidth = maxSlotWidth - math.floor((hasScrollbar and Helper.scrollbarWidth or 0) / 9)
		local extraPixels = (menu.slotData.width - 8 * Helper.borderSize) % 9
		local slotWidths = { slotWidth, slotWidth, slotWidth, slotWidth, slotWidth, slotWidth, slotWidth, slotWidth, slotWidth }
		if extraPixels > 0 then
			for i = 1, extraPixels do
				slotWidths[i] = slotWidths[i] + 1
			end
		end
		-- prevent negative column width
		if slotWidths[1] - menu.rowHeight - Helper.borderSize < 1 then
			slotWidths[1] = menu.rowHeight + Helper.borderSize + 1
		end
		local columnWidths = {}
		local maxColumnWidth = 0
		for i = 1, 3 do
			columnWidths[i] = slotWidths[(i - 1) * 3 + 1] + slotWidths[(i - 1) * 3 + 2] + slotWidths[(i - 1) * 3 + 3] + 2 * Helper.borderSize
			maxColumnWidth = math.max(maxColumnWidth, columnWidths[i])
		end
		local slidercellWidth = menu.slotData.width - math.floor(hasScrollbar and Helper.scrollbarWidth or 0)

		local maxVisibleHeight
		local highlightmode = "column"
		if (menu.upgradetypeMode == "consumables") or (menu.upgradetypeMode == "crew") or (menu.upgradetypeMode == "software") or (menu.upgradetypeMode == "settings") then
			highlightmode = "on"
		end
		local ftable = frame:addTable(11, { tabOrder = 1, width = menu.slotData.width, maxVisibleHeight = Helper.viewHeight - 2 * menu.slotData.offsetY, x = menu.slotData.offsetX, y = menu.slotData.offsetY, scaling = false, reserveScrollBar = menu.upgradetypeMode == "consumables", highlightMode = highlightmode, backgroundID = "solid", backgroundColor = Helper.color.transparent60 })
		if menu.setdefaulttable then
			ftable.properties.defaultInteractiveObject = true
			menu.setdefaulttable = nil
		end
		ftable:setColWidth(1, menu.rowHeight)
		ftable:setColWidth(2, slotWidths[1] - menu.rowHeight - Helper.borderSize)
		-- exact col widths are unimportant in these menus, keeping them variable and equal helps with scrollbar support
		if (menu.upgradetypeMode ~= "consumables") and (menu.upgradetypeMode ~= "crew") and (menu.upgradetypeMode ~= "software") and (menu.upgradetypeMode ~= "settings") then
			for i = 2, 8 do
				ftable:setColWidth(i + 1, slotWidths[i])
			end
		end
		ftable:setColWidth(11, menu.rowHeight)
		ftable:setDefaultColSpan(1, 4)
		ftable:setDefaultColSpan(5, 3)
		ftable:setDefaultColSpan(8, 4)

		local name = menu.getLeftBarEntry(menu.upgradetypeMode).name or ""
		local sizeicon
		if (menu.upgradetypeMode ~= "enginegroup") and (menu.upgradetypeMode ~= "turretgroup") and (menu.upgradetypeMode ~= "consumables") and (menu.upgradetypeMode ~= "crew") and (menu.upgradetypeMode ~= "repair") and (menu.upgradetypeMode ~= "software") and (menu.upgradetypeMode ~= "settings") then
			if upgradetype.supertype == "macro" and ((menu.object ~= 0) or (menu.macro ~= "")) then
				if currentSlotInfo.slotsize and (currentSlotInfo.slotsize ~= "") then
					name = upgradetype.text[currentSlotInfo.slotsize]
					sizeicon = "be_upgrade_size_" .. currentSlotInfo.slotsize
				end
			elseif upgradetype.supertype == "virtualmacro" then
				if menu.class == "ship_s" then
					name = upgradetype.text["small"]
					sizeicon = "be_upgrade_size_small"
				elseif menu.class == "ship_m" then
					name = upgradetype.text["medium"]
					sizeicon = "be_upgrade_size_medium"
				elseif menu.class == "ship_l" then
					name = upgradetype.text["large"]
					sizeicon = "be_upgrade_size_large"
				elseif menu.class == "ship_xl" then
					name = upgradetype.text["extralarge"]
					sizeicon = "be_upgrade_size_extralarge"
				end
			end
		end

		local color = Helper.color.white
		if upgradetype then
			local allowempty = upgradetype.allowempty
			if upgradetype.supertype == "macro" then
				allowempty = allowempty and (not C.IsSlotMandatory(menu.object, 0, menu.macro, false, upgradetype.type, menu.currentSlot))
			end
			if not allowempty then
				if menu.upgradeplan[upgradetype.type][menu.currentSlot].macro == "" then
					color = Helper.color.red
				end
			end
		end
		local row = ftable:addRow(false, { fixed = true, bgColor = Helper.defaultTitleBackgroundColor })
		row[1]:setColSpan(11):createText(name, menu.headerTextProperties)
		row[1].properties.color = color

		for _, group in ipairs(menu.groupedslots) do
			local row = ftable:addRow(true, { bgColor = Helper.color.transparent })
			for i = 1, 9 do
				if group[i] then
					local col = (i > 1) and (i + 1) or 1
					local colspan = ((i == 1) or (i == 9)) and 2 or 1

					local color = Helper.color.white
					local bgcolor = Helper.defaultTitleBackgroundColor
					if group[i][1] == menu.currentSlot then
						bgcolor = Helper.defaultArrowRowBackgroundColor
					end
					local count, total = 0, 0
					if (menu.upgradetypeMode == "enginegroup") or (menu.upgradetypeMode == "turretgroup") then
						for _, upgradetype2 in ipairs(Helper.upgradetypes) do
							if upgradetype2.supertype == "group" then
								if menu.groups[group[i][1]][upgradetype2.grouptype].total > 0 then
									if upgradetype2.mergeslots then
										count = count + ((menu.upgradeplan[upgradetype2.type][group[i][1]].count > 0) and 1 or 0)
										total = total + 1
									else
										count = count + menu.upgradeplan[upgradetype2.type][group[i][1]].count
										total = total + menu.groups[group[i][1]][upgradetype2.grouptype].total
									end
									if upgradetype2.allowempty == false then
										if menu.upgradeplan[upgradetype2.type][group[i][1]].macro == "" then
											color = Helper.color.red
										end
									end
								end
							end
						end
					else
						total = 1
						if menu.upgradeplan[upgradetype.type][group[i][1]].macro == "" then
							if (upgradetype.allowempty == false) or C.IsSlotMandatory(menu.object, 0, menu.macro, false, upgradetype.type, group[i][1]) then
								color = Helper.color.red
							end
						else
							count = 1
						end
					end

					local mouseovertext = ""
					if upgradetype then
						mouseovertext = ReadText(1001, 66) .. " " .. group[i][3]
					else
						mouseovertext = ReadText(1001, 8023) .. " " .. group[i][3]
					end

					row[col]:setColSpan(colspan):createButton({ height = slotWidths[i], width = slotWidths[i], bgColor = bgcolor, mouseOverText = mouseovertext }):setText(group[i][3], { halign = "center", fontsize = Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), color = color })
					if total > 0 then
						local width = math.max(1, math.floor(count * (slotWidths[i] - 2 * menu.scaleSize) / total))
						row[col]:setIcon("solid", { color = Helper.color.white, width = width + 2 * Helper.configButtonBorderSize, height = menu.scaleSize + 2 * Helper.configButtonBorderSize, x = menu.scaleSize - Helper.configButtonBorderSize, y = slotWidths[i] - 2 * menu.scaleSize - Helper.configButtonBorderSize })
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
						row[col]:setText2(compatibilitytext, { halign = "center", fontsize = fontsize, y = (slotWidths[i] - compatibilityTextHeight) / 2 })
					end
					row[col].handlers.onClick = function () return menu.buttonSelectSlot(group[i][1], row.index, col) end
				end
			end
		end

		if currentSlotInfo.compatibilities then
			local row = ftable:addRow(nil, { fixed = true, bgColor = Helper.color.transparent, scaling = true })
			row[1]:setBackgroundColSpan(11):setColSpan(5):createText(ReadText(1001, 8548) .. ReadText(1001, 120))
			local compatibilitytext = ""
			for _, entry in ipairs(Helper.equipmentCompatibilities) do
				if currentSlotInfo.compatibilities[entry.tag] then
					compatibilitytext = compatibilitytext .. " " .. Helper.convertColorToText(entry.color) .. currentSlotInfo.compatibilities[entry.tag]
				end
			end
			row[6]:setColSpan(6):createText(compatibilitytext, { halign = "right" })
		end

		if next(menu.groupedupgrades) then
			if (menu.upgradetypeMode == "enginegroup") or (menu.upgradetypeMode == "turretgroup") then
				for i, upgradetype2 in ipairs(Helper.upgradetypes) do
					if upgradetype2.supertype == "group" then
						if menu.groups[menu.currentSlot] and (menu.groups[menu.currentSlot][upgradetype2.grouptype].total > 0) then
							local plandata = menu.upgradeplan[upgradetype2.type][menu.currentSlot]
							local slotsize = menu.groups[menu.currentSlot][upgradetype2.grouptype].slotsize

							local name = upgradetype2.headertext.default
							if slotsize ~= "" then
								name = upgradetype2.headertext[slotsize]
							end

							local row = ftable:addRow(nil, { fixed = true, bgColor = Helper.color.transparent, scaling = true })
							row[1]:setBackgroundColSpan(11):setColSpan(5):createText(name .. ReadText(1001, 120))
							if not upgradetype2.mergeslots then
								row[6]:setColSpan(6):createText(plandata.count .. " / " .. menu.groups[menu.currentSlot][upgradetype2.grouptype].total, { halign = "right" })
							else
								row[6]:setColSpan(6):createText(((plandata.macro == "") and 0 or menu.groups[menu.currentSlot][upgradetype2.grouptype].total) .. " / " .. menu.groups[menu.currentSlot][upgradetype2.grouptype].total, { halign = "right" })
							end
						end
					end
				end
			end
		end

		ftable:addEmptyRow(Helper.standardTextHeight / 2)

		-- local editboxheight = math.max(23, Helper.scaleY(Helper.standardTextHeight))
		local rowy = ftable:getFullHeight()
		local row = ftable:addRow(true, { fixed = true })
		local issearchandfilteractive = menu.upgradetypeMode ~= "crew" and menu.upgradetypeMode ~= "repair" and menu.upgradetypeMode ~= "settings"
		row[1]:setColSpan(10):createEditBox({ active = issearchandfilteractive, defaultText = ReadText(1001, 3250), scaling = true }):setText("", { x = Helper.standardTextOffsetx }):setHotkey("INPUT_STATE_DETAILMONITOR_0", { displayIcon = true })
		row[1].handlers.onEditBoxDeactivated = menu.editboxSearchUpdateText
		menu.equipmentsearch_editboxrow = row.index
		row[11]:createButton({ active = issearchandfilteractive, height = menu.rowHeight }):setIcon("menu_filter")
		menu.equipmentfilter_races_y = menu.slotData.offsetY + rowy + Helper.borderSize
		row[11].handlers.onClick = function () return menu.buttonEquipmentFilter(menu.equipmentfilter_races_y) end

		if #menu.equipmentsearchtext > 0 and issearchandfilteractive then
			table.sort(menu.equipmentsearchtext, function (a, b)
				if a.race == b.race then
					return a.text < b.text
				end
				if (a.race == "generic") or (b.race == "generic") then
					return a.race == "generic"
				end
				return a.text < b.text
			end)
			local row = ftable:addRow((#menu.equipmentsearchtext > 0), { fixed = true, bgColor = Helper.color.transparent })
			local searchindex = 0
			local cols = { 1, 5, 8 }
			for i = 1, math.min(3, #menu.equipmentsearchtext) do
				searchindex = searchindex + 1
				local truncatedString = TruncateText(menu.equipmentsearchtext[i].text, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), row[cols[i]]:getWidth() - 3 * Helper.scaleX(10))
				if i < 3 or #menu.equipmentsearchtext <= 3 then
					row[cols[i]]:createButton({ scaling = true, height = Helper.standardTextHeight, mouseOverText = (truncatedString ~= menu.equipmentsearchtext[i].text) and menu.equipmentsearchtext[i].text or "" }):setText(truncatedString, { halign = "center" }):setText2("X", { halign = "right" })
				else
					row[cols[i]]:setColSpan(2):createButton({ scaling = true, height = Helper.standardTextHeight, mouseOverText = (truncatedString ~= menu.equipmentsearchtext[i].text) and menu.equipmentsearchtext[i].text or "" }):setText(truncatedString, { halign = "center" }):setText2("X", { halign = "right" })
				end
				if menu.equipmentsearchtext[i].race then
					row[cols[i]]:setIcon("menu_filter", { width = Helper.standardTextHeight, height = Helper.standardTextHeight })
				end
				row[cols[i]].handlers.onClick = function () return menu.buttonRemoveSearchEntry(i) end
			end
			if #menu.equipmentsearchtext > 3 then
				row[10]:setColSpan(2):createText(string.format("%+d", #menu.equipmentsearchtext - 3), { scaling = true })
			end
		end

		local row = ftable:addEmptyRow(Helper.standardTextHeight / 2)
		row.properties.fixed = true

		if next(menu.groupedupgrades) then
			if (menu.upgradetypeMode == "enginegroup") or (menu.upgradetypeMode == "turretgroup") then
				for i, upgradetype2 in ipairs(Helper.upgradetypes) do
					if upgradetype2.supertype == "group" then
						if menu.groups[menu.currentSlot] and (menu.groups[menu.currentSlot][upgradetype2.grouptype].total > 0) then
							local hasmod, modicon = menu.checkMod(upgradetype2.grouptype, menu.groups[menu.currentSlot][upgradetype2.grouptype].currentcomponent, true)

							local color = Helper.color.white
							if upgradetype2.allowempty == false then
								if menu.upgradeplan[upgradetype2.type][menu.currentSlot].macro == "" then
									color = Helper.color.red
								end
							end
							local plandata = menu.upgradeplan[upgradetype2.type][menu.currentSlot]

							local row = ftable:addRow(true, { bgColor = (not upgradetype2.mergeslots) and Helper.color.transparent or nil })
							local name = upgradetype2.text.default
							local slotsize = menu.groups[menu.currentSlot][upgradetype2.grouptype].slotsize
							if slotsize ~= "" then
								name = upgradetype2.text[slotsize]
								sizeicon = "be_upgrade_size_" .. slotsize
							end

							if plandata.macro ~= "" then
								name = GetMacroData(plandata.macro, "name")
							end

							if not upgradetype2.mergeslots then
								local scale = {
									min       = 0,
									minSelect = (plandata.macro == "") and 0 or 1,
									max       = menu.groups[menu.currentSlot][upgradetype2.grouptype].total,
								}
								scale.maxSelect = (plandata.macro == "") and 0 or scale.max

								-- handle already installed equipment
								if (plandata.macro == menu.groups[menu.currentSlot][upgradetype2.grouptype].currentmacro) then
									local haslicence = menu.checkLicence(plandata.macro)
									if not haslicence then
										scale.maxSelect = math.min(scale.maxSelect, menu.groups[menu.currentSlot][upgradetype2.grouptype].count)
										menu.upgradeplan[upgradetype2.type][menu.currentSlot].count = math.min(scale.maxSelect, menu.upgradeplan[upgradetype2.type][menu.currentSlot].count)
									end
									local j = menu.findUpgradeMacro(upgradetype2.grouptype, plandata.macro)
									if j then
										local upgradeware = menu.upgradewares[upgradetype2.grouptype][j]
										if not upgradeware.isFromShipyard then
											scale.maxSelect = math.min(scale.maxSelect, menu.objectgroup and 0 or menu.groups[menu.currentSlot][upgradetype2.grouptype].count)
											if menu.objectgroup then
												scale.minSelect = 0
											end
											menu.upgradeplan[upgradetype2.type][menu.currentSlot].count = math.min(scale.maxSelect, menu.upgradeplan[upgradetype2.type][menu.currentSlot].count)
										end
									end
								end
								scale.start = math.max(scale.minSelect, math.min(scale.maxSelect, plandata.count))

								local mouseovertext = ""
								if hasmod then
									mouseovertext = "\27R" .. ReadText(1026, 8009) .. "\27X"
								end

								row[1]:setColSpan(11):createSliderCell({ width = slidercellWidth, height = menu.subHeaderRowHeight, valueColor = Helper.color.slidervalue, min = scale.min, minSelect = scale.minSelect, max = scale.max, maxSelect = scale.maxSelect, start = scale.start, readOnly = hasmod or menu.isReadOnly, mouseOverText = mouseovertext }):setText(name, menu.subHeaderSliderCellTextProperties)
								row[1].handlers.onSliderCellChanged = function (_, ...) return menu.slidercellSelectGroupAmount(upgradetype2.type, menu.currentSlot, row.index, false, ...) end
								row[1].properties.text.color = color
							else
								row[1]:setColSpan(11):createText(name, menu.subHeaderTextProperties)
								row[1].properties.color = color
							end

							if #menu.groupedupgrades[upgradetype2.grouptype] > 0 then
								for _, group in ipairs(menu.groupedupgrades[upgradetype2.grouptype]) do
									local row = ftable:addRow(true, { bgColor = Helper.color.transparent, borderBelow = false })
									local row2 = ftable:addRow(false, { bgColor = Helper.color.transparent })
									for i = 1, 3 do
										if group[i] then
											local column = i * 3 - 2
											if i > 1 then
												column = column + 1
											end

											local haslicence, icon, overridecolor, mouseovertext = menu.checkLicence(group[i].macro)
											local extraText = ""
											local untruncatedExtraText = ""

											-- handle already installed equipment
											if (group[i].macro == menu.groups[menu.currentSlot][upgradetype2.grouptype].currentmacro) and (not haslicence) then
												haslicence = true
												mouseovertext = mouseovertext .. "\n" .. "\27G" .. ReadText(1026, 8004)
											end

											local weaponicon, compatibility = GetMacroData(group[i].macro, "ammoicon", "compatibility")
											if weaponicon and (weaponicon ~= "") and C.IsIconValid(weaponicon) then
												weaponicon = "\27[" .. weaponicon .. "]"
											else
												weaponicon = ""
											end
											if compatibility then
												local color = Helper.color.white
												for _, entry in ipairs(Helper.equipmentCompatibilities) do
													if entry.tag == compatibility then
														color = entry.color
														break
													end
												end
												weaponicon = Helper.convertColorToText(color) .. "\27[menu_weaponmount]\27X" .. weaponicon
											end
											if hasmod then
												mouseovertext = "\27R" .. ReadText(1026, 8009) .. "\27X\n" .. mouseovertext
											end

											local price
											local hasstock = group[i].macro == ""
											local j = menu.findUpgradeMacro(upgradetype2.grouptype, group[i].macro)
											if j then
												local upgradeware = menu.upgradewares[upgradetype2.grouptype][j]

												local isvolatile = GetWareData(upgradeware.ware, "volatile")
												if isvolatile then
													icon = "\27[bse_venture]"
												end

												if (not menu.isReadOnly) and (not menu.isplayerowned) and (menu.mode ~= "customgamestart") and (menu.mode ~= "comparison") and (not isvolatile) then
													price = tonumber(C.GetBuildWarePrice(menu.container, upgradeware.ware))
													if upgradetype2.mergeslots then
														price = menu.groups[menu.currentSlot][upgradetype2.grouptype].total * price
													end
												end

												hasstock = upgradeware.isFromShipyard or (menu.groups[menu.currentSlot][upgradetype2.grouptype].currentmacro == group[i].macro)
											end

											local amounttext = ""
											if upgradetype2.mergeslots and (menu.groups[menu.currentSlot][upgradetype2.grouptype].total > 1) then
												amounttext = menu.groups[menu.currentSlot][upgradetype2.grouptype].total .. ReadText(1001, 42) .. " "
											end
											if group[i].macro ~= "" then
												local shortname, infolibrary = GetMacroData(group[i].macro, "shortname", "infolibrary")
												extraText, untruncatedExtraText = menu.getExtraText(columnWidths[i], amounttext .. shortname, group[i].macro, price)
												AddKnownItem(infolibrary, group[i].macro)
											else
												extraText, untruncatedExtraText = menu.getExtraText(columnWidths[i], amounttext .. group[i].name, nil, price)
											end

											local installicon, installcolor = (group[i].macro ~= "") and (sizeicon or "") or ""
											if not haslicence then
												installcolor = Helper.color.darkgrey
											elseif (group[i].macro ~= "") then
												if (group[i].macro == menu.groups[menu.currentSlot][upgradetype2.grouptype].currentmacro) and (group[i].macro ~= plandata.macro) then
													installicon = "be_upgrade_uninstalled"
													installcolor = Helper.color.red
												elseif (group[i].macro == plandata.macro) then
													installicon = "be_upgrade_installed"
													installcolor = Helper.color.green
													if hasmod then
														weaponicon = weaponicon .. " " .. modicon
													end
													if firsttime then
														menu.selectedRows.slots = row.index
														menu.selectedCols.slots = column
														firsttime = nil
													end
												end
											end
											local active = ((group[i].macro == plandata.macro) or (not hasmod)) 

											-- start: mycu call-back
											if callbacks ["displaySlots_on_before_create_button_mouseovertext"] then
												for _, callback in ipairs (callbacks ["displaySlots_on_before_create_button_mouseovertext"]) do
													result = callback (group[i].macro, plandata.macro, mouseovertext)
													if result then
														mouseovertext = result.mouseovertext
													end
												end
											end
											-- end: mycu call-back

											local useable = hasstock and haslicence
											row[column]:createButton({
												active = active,
												width = columnWidths[i],
												height = maxColumnWidth,
												mouseOverText = mouseovertext,
												bgColor = useable and Helper.defaultButtonBackgroundColor or Helper.defaultUnselectableButtonBackgroundColor,
												highlightColor = useable and Helper.defaultButtonHighlightColor or Helper.defaultUnselectableButtonHighlightColor,
											}):setIcon(group[i].icon):setIcon2(installicon, { color = installcolor }):setText(icon, { y = maxColumnWidth / 2 - Helper.scaleY(Helper.standardTextHeight) / 2 - Helper.configButtonBorderSize, halign = "right", color = overridecolor, fontsize = Helper.scaleFont(Helper.standardFont, Helper.standardFontSize) }):setText2(weaponicon, { x = 3, y = -maxColumnWidth / 2 + Helper.scaleY(Helper.standardTextHeight) / 2 + Helper.configButtonBorderSize, fontsize = Helper.scaleFont(Helper.standardFont, Helper.standardFontSize) })
											if useable then
												row[column].handlers.onClick = function () return menu.buttonSelectGroupUpgrade(upgradetype2.type, menu.currentSlot, group[i].macro, row.index, column) end
											end
											if group[i].macro ~= "" then
												row[column].handlers.onRightClick = function (...) return menu.buttonInteract({ type = upgradetype2.type, name = group[i].name, macro = group[i].macro }, ...) end
											end

											row2[column]:createBoxText(extraText, { width = columnWidths[i], fontsize = menu.extraFontSize, color = overridecolor, boxColor = (active and useable) and Helper.defaultButtonBackgroundColor or Helper.defaultUnselectableButtonBackgroundColor, mouseOverText = untruncatedExtraText })
										end
									end
									if (maxVisibleHeight == nil) and row.index >= config.maxSlotRows then
										maxVisibleHeight = ftable:getFullHeight()
									end
								end
							else
								local row = ftable:addRow(nil, { bgColor = Helper.color.transparent, scaling = true })
								row[1]:setColSpan(11):createText("--- " .. upgradetype2.nonetext.default .. " ---")
							end
						end
					end
				end
			elseif menu.upgradetypeMode == "repair" then
				for k, group in ipairs(menu.groupedupgrades) do
					local row = ftable:addRow(true, { bgColor = Helper.color.transparent, borderBelow = false })
					local row2 = ftable:addRow(false, { bgColor = Helper.color.transparent })
					for i = 1, 3 do
						if group[i] then
							local repairslotdata = menu.repairslots[k][i]
							local componentstring = tostring(repairslotdata[4])

							local totalprice = 0
							local mouseovertext = ""
							if menu.objectgroup then
								for j, ship in ipairs(menu.objectgroup.ships) do
									if ship.ship == repairslotdata[4] then
										for k = #menu.objectgroup.shipdata[j].damagedcomponents, 1, -1 do
											local component = menu.objectgroup.shipdata[j].damagedcomponents[k]
											if k ~= #menu.objectgroup.shipdata[j].damagedcomponents then
												mouseovertext = mouseovertext .. "\n"
											end

											local price = tonumber(C.GetRepairPrice(component, menu.container))
											if price then
												totalprice = totalprice + price
											end
											local hull = GetComponentData(ConvertStringTo64Bit(tostring(component)), "hullpercent")
											mouseovertext = mouseovertext .. group[i].name .. " (" .. (100 - hull) .. "% " .. ReadText(1001, 1) .. ")"
										end
										break
									end
								end
							else
								for j = #menu.damagedcomponents, 1, -1 do
									local component = menu.damagedcomponents[j]
									local macro

									if component == menu.object then
										macro = GetComponentData(ConvertStringTo64Bit(tostring(component)), "macro")
									else
										for _, upgradetype in ipairs(Helper.upgradetypes) do
											if upgradetype.supertype == "macro" then
												if menu.slots[upgradetype.type] then
													for k = 1, #menu.slots[upgradetype.type] do
														if menu.slots[upgradetype.type][k].component == component then
															macro = GetComponentData(ConvertStringTo64Bit(tostring(component)), "macro")
															break
														end
													end
												end
											end
										end
									end
									if macro then
										if j ~= #menu.damagedcomponents then
											mouseovertext = mouseovertext .. "\n"
										end

										local price = tonumber(C.GetRepairPrice(component, menu.container))
										if price then
											totalprice = totalprice + price
										end
										local shortname = GetMacroData(macro, "shortname")
										local hull = GetComponentData(ConvertStringTo64Bit(tostring(component)), "hullpercent")
										mouseovertext = mouseovertext .. shortname .. " (" .. (100 - hull) .. "% " .. ReadText(1001, 1) .. ")"
									end
								end
							end

							if #menu.repairdiscounts > 0 then
								if mouseovertext ~= "" then
									mouseovertext = mouseovertext .. "\n\n"
								end
								mouseovertext = mouseovertext .. ReadText(1001, 2819) .. ReadText(1001, 120)
								for _, entry in ipairs(menu.repairdiscounts) do
									mouseovertext = mouseovertext .. "\n· " .. entry.name .. ReadText(1001, 120) .. " " .. entry.amount .. " %"
								end
							end

							local shortname
							if menu.objectgroup then
								shortname = group[i].name .. "\n" .. ffi.string(C.GetObjectIDCode(group[i].component))
							else
								shortname = GetMacroData(group[i].macro, "shortname")
							end
							local extraText, untruncatedExtraText = menu.getExtraText(columnWidths[i], shortname, group[i].macro, (totalprice > 0) and totalprice * menu.repairdiscounts.totalfactor or nil, repairslotdata[4])

							local color = Helper.defaultButtonBackgroundColor
							-- TODO: handle button colors for queued items here.

							local installicon, installcolor = sizeicon or ""
							menu.repairplan[componentstring] = menu.repairplan[componentstring] or {}
							if menu.repairplan[componentstring][componentstring] then
								installicon = "be_upgrade_installed"
								installcolor = Helper.color.green
							end

							local column = i * 3 - 2
							if i > 1 then
								column = column + 1
							end
							--print("adding button for component: " .. tostring(componentstring) .. " row: " .. tostring(row.index) .. ", col: " .. tostring(column))
							row[column]:createButton({ width = columnWidths[i], height = maxColumnWidth, bgColor = color, mouseOverText = mouseovertext }):setIcon(group[i].icon):setIcon2(installicon, { color = installcolor })
							row[column].handlers.onClick = function () return menu.buttonSelectRepair(row.index, column, componentstring) end
							row2[column]:createBoxText(extraText, { width = columnWidths[i], fontsize = menu.extraFontSize, mouseOverText = untruncatedExtraText })
						end
					end
					if (maxVisibleHeight == nil) and row.index >= config.maxSlotRows then
						maxVisibleHeight = ftable:getFullHeight()
					end
				end
			else
				local plandata = menu.upgradeplan[menu.upgradetypeMode][menu.currentSlot]
				local hasmod, modicon = menu.checkMod(upgradetype.type, slots[menu.currentSlot].component)

				for _, group in ipairs(menu.groupedupgrades) do
					local row = ftable:addRow(true, { bgColor = Helper.color.transparent, borderBelow = false })
					local row2 = ftable:addRow(false, { bgColor = Helper.color.transparent })
					for i = 1, 3 do
						if group[i] then
							local column = i * 3 - 2
							if i > 1 then
								column = column + 1
							end

							local haslicence, icon, overridecolor, mouseovertext = menu.checkLicence(group[i].macro, nil, false)
							local extraText = ""
							local untruncatedExtraText = ""

							-- handle already installed equipment
							if (group[i].macro == slots[menu.currentSlot].currentmacro) and (not haslicence) then
								haslicence = true
								mouseovertext = mouseovertext .. "\n" .. "\27G" .. ReadText(1026, 8004)
							end

							local weaponicon, compatibility
							if upgradetype.supertype == "macro" then
								weaponicon, compatibility = GetMacroData(group[i].macro, "ammoicon", "compatibility")
							end
							if weaponicon and (weaponicon ~= "") and C.IsIconValid(weaponicon) then
								weaponicon = "\27[" .. weaponicon .. "]"
							else
								weaponicon = ""
							end
							if compatibility then
								local color = Helper.color.white
								for _, entry in ipairs(Helper.equipmentCompatibilities) do
									if entry.tag == compatibility then
										color = entry.color
										break
									end
								end
								weaponicon = Helper.convertColorToText(color) .. "\27[menu_weaponmount]\27X" .. weaponicon
							end
							if hasmod then
								mouseovertext = "\27R" .. ReadText(1026, 8009) .. "\27X\n" .. mouseovertext
							end

							local price
							local hasstock = group[i].macro == ""
							local j = menu.findUpgradeMacro(upgradetype.type, group[i].macro)
							if j then
								local upgradeware = menu.upgradewares[upgradetype.type][j]

								local isvolatile = GetWareData(upgradeware.ware, "volatile")
								if isvolatile then
									icon = "\27[bse_venture]"
								end

								if (not menu.isReadOnly) and (not menu.isplayerowned) and (menu.mode ~= "customgamestart") and (menu.mode ~= "comparison") and (not isvolatile) then
									price = tonumber(C.GetBuildWarePrice(menu.container, upgradeware.ware))
									if upgradetype.mergeslots then
										price = #menu.upgradeplan[upgradetype.type] * price
									end
								end

								hasstock = upgradeware.isFromShipyard or (slots[menu.currentSlot].currentmacro == group[i].macro)
							end

							local amounttext = ""
							if upgradetype.mergeslots and (#menu.upgradeplan[upgradetype.type] > 1) then
								amounttext = #menu.upgradeplan[upgradetype.type] .. ReadText(1001, 42) .. " "
							end
							if group[i].macro ~= "" then
								local shortname, infolibrary = GetMacroData(group[i].macro, "shortname", "infolibrary")
								extraText, untruncatedExtraText = menu.getExtraText(columnWidths[i], amounttext .. shortname, group[i].macro, price, nil, upgradetype.type)
								AddKnownItem(infolibrary, group[i].macro)
							else
								extraText, untruncatedExtraText = menu.getExtraText(columnWidths[i], amounttext .. group[i].name, nil, price)
							end

							local installicon, installcolor = (group[i].macro ~= "") and (sizeicon or "") or ""
							if not haslicence then
								installcolor = Helper.color.darkgrey
							else
								if (group[i].macro ~= "") then
									if (group[i].macro == slots[menu.currentSlot].currentmacro) and (group[i].macro ~= plandata.macro) then
										installicon = "be_upgrade_uninstalled"
										installcolor = Helper.color.red
									elseif (group[i].macro == plandata.macro) then
										installicon = "be_upgrade_installed"
										installcolor = Helper.color.green
										if hasmod then
											weaponicon = weaponicon .. " " .. modicon
										end
										if firsttime then
											menu.selectedRows.slots = row.index
											menu.selectedCols.slots = column
											firsttime = nil
										end
									end
								end
							end

							-- start: mycu call-back
							if callbacks ["displaySlots_on_before_create_button_mouseovertext"] then
								for _, callback in ipairs (callbacks ["displaySlots_on_before_create_button_mouseovertext"]) do
									result = callback (group[i].macro, plandata.macro, mouseovertext)
									if result then
										mouseovertext = result.mouseovertext
									end
								end
							end
							-- end: mycu call-back

							local active = ((group[i].macro == plandata.macro) or (not hasmod))
							local useable = hasstock and haslicence
							row[column]:createButton({
								active = active,
								width = columnWidths[i],
								height = maxColumnWidth,
								mouseOverText = mouseovertext,
								bgColor = useable and Helper.defaultButtonBackgroundColor or Helper.defaultUnselectableButtonBackgroundColor,
								highlightColor = useable and Helper.defaultButtonHighlightColor or Helper.defaultUnselectableButtonHighlightColor,
							}):setIcon(group[i].icon):setIcon2(installicon, { color = installcolor }):setText(icon, { y = maxColumnWidth / 2 - Helper.scaleY(Helper.standardTextHeight) / 2 - Helper.configButtonBorderSize, halign = "right", color = overridecolor, fontsize = Helper.scaleFont(Helper.standardFont, Helper.standardFontSize) }):setText2(weaponicon, { x = 3, y = -maxColumnWidth / 2 + Helper.scaleY(Helper.standardTextHeight) / 2 + Helper.configButtonBorderSize, fontsize = Helper.scaleFont(Helper.standardFont, Helper.standardFontSize) })
							if useable then
								row[column].handlers.onClick = function () return menu.buttonSelectUpgradeMacro(menu.upgradetypeMode, menu.currentSlot, group[i].macro, row.index, column) end
							end
							if group[i].macro ~= "" then
								row[column].handlers.onRightClick = function (...) return menu.buttonInteract({ type = menu.upgradetypeMode, name = group[i].name, macro = group[i].macro }, ...) end
							end
							row2[column]:createBoxText(extraText, { width = columnWidths[i], fontsize = menu.extraFontSize, color = overridecolor, boxColor = (active and useable) and Helper.defaultButtonBackgroundColor or Helper.defaultUnselectableButtonBackgroundColor, mouseOverText = untruncatedExtraText })
						end
					end
					if (maxVisibleHeight == nil) and row.index >= config.maxSlotRows then
						maxVisibleHeight = ftable:getFullHeight()
					end
				end
			end
		else
			if menu.upgradetypeMode == "consumables" then
				-- ammo
				local titlefirst = true
				for _, upgradetype in ipairs(Helper.upgradetypes) do
					if upgradetype.supertype == "ammo" then
						if next(menu.ammo[upgradetype.type]) then
							local total, capacity = menu.getAmmoUsage(upgradetype.type)
							local display = false
							for macro, _ in pairs(menu.ammo[upgradetype.type]) do
								if (total > 0) or menu.isAmmoCompatible(upgradetype.type, macro) then
									display = true
									break
								end
							end

							if ((total > 0) or (capacity > 0)) and display then
								if not titlefirst then
									ftable:addEmptyRow(Helper.standardTextHeight / 2)
								end
								titlefirst = false

								local name = upgradetype.type
								if upgradetype.type == "drone" then
									name = ReadText(1001, 8)
								elseif upgradetype.type == "missile" then
									name = ReadText(1001, 1304)
								elseif upgradetype.type == "deployable" then
									name = ReadText(1001, 1332)		-- "Deployables"
								elseif upgradetype.type == "countermeasure" then
									name = ReadText(1001, 8063)		-- "Countermeasures"
								end

								local row = ftable:addRow(false, { bgColor = Helper.defaultHeaderBackgroundColor })
								row[1]:setColSpan(7):setBackgroundColSpan(10):createText(name, menu.subHeaderTextProperties)
								row[8]:setColSpan(4):createText(total .. "\27X" .. " / " .. capacity, menu.subHeaderTextProperties)
								row[8].properties.halign = "right"
								row[8].properties.color = (total > capacity) and Helper.color.red or Helper.color.white

								local first = true
								local sortedammo = Helper.orderedKeys(menu.ammo[upgradetype.type], menu.sortAmmo)
								for _, macro in ipairs(sortedammo) do
									local macroname, makerrace, makerracename = GetMacroData(macro, "name", "makerraceid", "makerracename")
									for race_i, race in ipairs(makerrace) do
										if (not menu.equipmentfilter_races[race]) then
											menu.equipmentfilter_races[race] = { id = race, name = makerracename[race_i] }
										end
										if (not menu.equipmentfilter_races[race].upgradeTypes) then
											menu.equipmentfilter_races[race].upgradeTypes = {}
										end
										if (not menu.equipmentfilter_races[race].upgradeTypes[menu.upgradetypeMode]) then
											menu.equipmentfilter_races[race].upgradeTypes[menu.upgradetypeMode] = true
										end
									end
									if (#menu.equipmentsearchtext == 0) or menu.filterUpgradeByText(macro, menu.equipmentsearchtext) then
										local row = menu.displayAmmoSlot(ftable, upgradetype.type, macro, total, capacity, first)
										first = false
										if (maxVisibleHeight == nil) and row and row.index >= config.maxSlotRows then
											maxVisibleHeight = ftable:getFullHeight()
										end
									end
								end
							end
						end
					end
				end
			elseif menu.upgradetypeMode == "crew" then
				-- crew
				if ((menu.mode == "purchase") or (not menu.usemacro)) and (not menu.isReadOnly) then
					-- total hires on the shoppinglist without current ship
					local totalhiring = 0
					for idx, entry in ipairs(menu.shoppinglist) do
						if idx ~= menu.editingshoppinglist then
							totalhiring = totalhiring + entry.amount * entry.crew.hired
						end
					end
					-- amount of current ship
					local shoppinglistamount = 1
					if menu.editingshoppinglist then
						shoppinglistamount = menu.shoppinglist[menu.editingshoppinglist].amount
					end
					-- still available workforce
					local availableworkforce = menu.crew.availableworkforce + menu.crew.availabledockcrew - menu.addedCrewByPlayerBuildTasks - totalhiring - shoppinglistamount * menu.crew.hired
					-- resources for next resource shift
					local resourceinfos = GetWorkForceRaceResources(ConvertStringTo64Bit(tostring(menu.container)))
					local races = {}
					local n = C.GetNumAllRaces()
					local buf = ffi.new("RaceInfo[?]", n)
					n = C.GetAllRaces(buf, n)
					for i = 0, n - 1 do
						local entry = {}
						entry.id = ffi.string(buf[i].id)
						entry.name = ffi.string(buf[i].name)

						table.insert(races, entry)
					end
					local workforceresources = {}
					for _, race in ipairs(races) do
						local workforceinfo = C.GetWorkForceInfo(menu.container, race.id)
						if workforceinfo.capacity > 0 then
							local resourcedata
							for _, resourceinfo in ipairs(resourceinfos) do
								if resourceinfo.race == race.id then
									resourcedata = resourceinfo
								end
							end
							for i, resource in ipairs(resourcedata.resources) do
								local amount = Helper.round(resource.cycle * workforceinfo.current / resourcedata.productamount)
								if workforceresources[resource.ware] then
									workforceresources[resource.ware] = workforceresources[resource.ware] + amount
								else
									workforceresources[resource.ware] = amount
								end
							end
						end
					end
					-- compare with station cargo
					local resourceerror
					local cargo = GetComponentData(ConvertStringTo64Bit(tostring(menu.container)), "cargo")
					for ware, amount in pairs(workforceresources) do
						if (cargo[ware] or 0) < amount then
							resourceerror = ReadText(1001, 8540)
							break
						end
					end

					local errormessage, errorcolor
					local color = Helper.color.white
					if availableworkforce < 0 then
						errormessage = C.IsComponentClass(menu.container, "station") and ReadText(1001, 8541) or ReadText(1001, 8545)
						errorcolor = Helper.color.red
						color = Helper.color.red
					elseif menu.crew.availableworkforce + menu.crew.availabledockcrew - totalhiring < shoppinglistamount * menu.crew.capacity then
						errormessage = C.IsComponentClass(menu.container, "station") and ReadText(1001, 8538) or ReadText(1001, 8544)
						errorcolor = Helper.color.orange
						color = Helper.color.orange
					end

					local row = ftable:addRow(nil, { bgColor = Helper.color.transparent })
					row[1]:setColSpan(11):createText(C.IsComponentClass(menu.container, "station") and ReadText(1001, 8542) or ReadText(1001, 8543), menu.subHeaderTextProperties)

					local row = ftable:addRow(false, { bgColor = Helper.color.transparent, scaling = true })
					row[1]:setColSpan(8):createText(string.format(ReadText(1001, 8024), ffi.string(C.GetComponentName(menu.container))), { mouseOverText = menu.isplayerowned and "" or (ReadText(1001, 2808) .. ReadText(1001, 120) .. " " .. ConvertMoneyString(menu.crew.price, false, true, 0, true, false) .. " " .. ReadText(1001, 101)) })
					row[9]:setColSpan(3):createText(math.max(0, availableworkforce), { halign = "right", color = color })

					if menu.mode == "purchase" then
						local row = ftable:addRow(nil, { bgColor = Helper.color.transparent, scaling = true })
						row[1]:setColSpan(11):createText(ReadText(1001, 8539), { wordwrap = true })
					end

					if errormessage then
						local row = ftable:addRow(nil, { bgColor = Helper.color.transparent, scaling = true })
						row[1]:setColSpan(11):createText(errormessage, { wordwrap = true, color = errorcolor })
					end
					if resourceerror then
						local row = ftable:addRow(nil, { bgColor = Helper.color.transparent, scaling = true })
						row[1]:setColSpan(11):createText(resourceerror, { wordwrap = true, color = Helper.color.orange })
					end

					local row = ftable:addRow(false, { bgColor = Helper.color.transparent, scaling = true })
					row[1]:setColSpan(11):createText("")
				end

				local isbigship = (menu.class == "ship_m") or (menu.class == "ship_l") or (menu.class == "ship_xl")
				if menu.mode == "customgamestart" then
					if menu.modeparam.shippilotproperty or menu.modeparam.playerpropertyid then
						local value = 0
						if next(menu.customgamestartpilot) then
							local skills = {}
							for skill, value in pairs(menu.customgamestartpilot.skills or {}) do
								table.insert(skills, { id = skill, value = value })
							end
							local buf = ffi.new("CustomGameStartPersonEntry")
							buf.race = Helper.ffiNewString(menu.customgamestartpilot.race or "")
							buf.tags = Helper.ffiNewString(menu.customgamestartpilot.tags or "")
							buf.numskills = #skills
							buf.skills = Helper.ffiNewHelper("SkillInfo[?]", buf.numskills)
							for i, entry in ipairs(skills) do
								buf.skills[i - 1].id = Helper.ffiNewString(entry.id)
								buf.skills[i - 1].value = entry.value
							end
							value = tonumber(C.GetCustomGameStartShipPersonValue(menu.modeparam.gamestartid, buf))
						end

						local row = ftable:addRow(nil, { bgColor = Helper.color.transparent })
						if menu.modeparam.creative then
							row[1]:setColSpan(11):createText(isbigship and ReadText(1001, 4848) or ReadText(1001, 4847), menu.subHeaderTextProperties)
						else
							row[1]:setColSpan(7):setBackgroundColSpan(11):createText(isbigship and ReadText(1001, 4848) or ReadText(1001, 4847), menu.subHeaderTextProperties)
							row[8]:setColSpan(4):createText(ConvertIntegerString(value, true, 0, true)  .. " " .. Helper.convertColorToText(Helper.color.red) .. "\27[gamestart_custom_people]", menu.subHeaderTextProperties)
							row[8].properties.halign = "right"
						end

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

						local row = ftable:addRow(true, { bgColor = Helper.color.transparent, scaling = true })
						row[1]:setColSpan(11):createDropDown(raceoptions, { startOption = (menu.customgamestartpilot.race and (menu.customgamestartpilot.race ~= "")) and menu.customgamestartpilot.race or "any", height = Helper.standardTextHeight, x = Helper.standardTextOffsetx })
						row[1].handlers.onDropDownConfirmed = function(_, raceid) if raceid == "any" then menu.customgamestartpilot.race = "" else menu.customgamestartpilot.race = raceid end; menu.refreshMenu() end

						ftable:addEmptyRow(Helper.standardTextHeight / 2)

						local numskills = C.GetNumSkills()
						local buf = ffi.new("SkillInfo[?]", numskills)
						numskills = C.GetSkills(buf, numskills)
						for i = 0, numskills - 1 do
							local id = ffi.string(buf[i].id)

							local row = ftable:addRow(true, { bgColor = Helper.color.transparent, scaling = true })
							row[1]:setColSpan(11):createSliderCell({ height = Helper.standardTextHeight, valueColor = Helper.color.slidervalue, min = 0, max = 15, start = menu.customgamestartpilot.skills and menu.customgamestartpilot.skills[id] or 0, step = 1 }):setText(ReadText(1013, buf[i].textid))
							row[1].handlers.onSliderCellChanged = function(_, newamount) if menu.customgamestartpilot.skills then menu.customgamestartpilot.skills[id] = newamount else menu.customgamestartpilot.skills = { [id] = newamount } end end
						end

						ftable:addEmptyRow()
					end
				end

				if (menu.mode ~= "customgamestart") or (menu.crew.capacity > 0) then
					local row = ftable:addRow(menu.mode ~= "customgamestart", { bgColor = Helper.color.transparent })
					row[1]:setColSpan(7):setBackgroundColSpan(9):createText(ReadText(1001, 80), menu.subHeaderTextProperties)
					-- include the +1 for the captain
					if menu.mode ~= "customgamestart" then
						row[8]:setColSpan(3):createText((menu.crew.total + menu.crew.hired - #menu.crew.fired + (menu.captainSelected and 1 or 0)) .. " / " .. (menu.crew.capacity + 1), menu.subHeaderTextProperties)
						row[8].properties.halign = "right"
						row[11]:createButton({ active = (not menu.isReadOnly), mouseOverText = ReadText(1026, 8001), height = menu.rowHeight, y = math.max(0, row:getHeight() - menu.rowHeight) }):setIcon("menu_reset")
						row[11].handlers.onClick = menu.buttonResetCrew
					elseif not menu.modeparam.creative then
						local value = tonumber(C.GetCustomGameStartShipPeopleValue2(menu.modeparam.gamestartid, menu.macro, menu.customgamestartpeopledef, menu.customgamestartpeoplefillpercentage))

						row[8]:setColSpan(4):createText(ConvertIntegerString(value, true, 0, true)  .. " " .. Helper.convertColorToText(Helper.color.red) .. "\27[gamestart_custom_people]", menu.subHeaderTextProperties)
						row[8].properties.halign = "right"
					else
						row[8]:setColSpan(4):createText(" ", menu.subHeaderTextProperties)
					end
				end

				if menu.mode ~= "customgamestart" then
					local row = ftable:addRow(true, { scaling = true, bgColor = Helper.color.transparent })
					row[1]:setColSpan(1):createCheckBox(menu.captainSelected, { scaling = false, active = (menu.mode == "purchase") and (not menu.captainSelected), width = menu.rowHeight, height = menu.rowHeight })
					row[1].handlers.onClick = function () return menu.checkboxSelectCaptain(row.index) end
					row[2]:setColSpan(7):createText(isbigship and ReadText(1001, 4848) or ReadText(1001, 4847), { color = ((menu.mode ~= "purchase") or menu.captainSelected) and Helper.color.white or Helper.color.red })
					if menu.usemacro then
						row[9]:setColSpan(3):createText(ReadText(1001, 8047), { halign = "right", color = menu.captainSelected and Helper.color.white or Helper.color.red })
					end
				end

				if menu.crew.capacity > 0 then
					if menu.mode == "customgamestart" then
						local peopleoptions = {}
						local n = C.GetNumPlayerPeopleDefinitions()
						local buf = ffi.new("PeopleDefinitionInfo[?]", n)
						n = C.GetPlayerPeopleDefinitions(buf, n)
						for i = 0, n - 1 do
							table.insert(peopleoptions, { id = ffi.string(buf[i].id), text = ffi.string(buf[i].name), icon = "", displayremoveoption = false, mouseovertext = ffi.string(buf[i].desc) })
						end
						table.sort(peopleoptions, function (a, b) return a.text < b.text end)
						table.insert(peopleoptions, 1, { id = "none", text = ReadText(1001, 9931), icon = "", displayremoveoption = false })

						local row = ftable:addRow(true, { bgColor = Helper.color.transparent, scaling = true })
						row[1]:setColSpan(11):createDropDown(peopleoptions, { startOption = (menu.customgamestartpeopledef and (menu.customgamestartpeopledef ~= "")) and menu.customgamestartpeopledef or "none", height = Helper.standardTextHeight, x = Helper.standardTextOffsetx })
						row[1].handlers.onDropDownConfirmed = function(_, peopledefid) if peopledefid == "none" then menu.customgamestartpeopledef = "" else menu.customgamestartpeopledef = peopledefid end; menu.refreshMenu() end

						local row = ftable:addRow(true, { bgColor = Helper.color.transparent, scaling = true })
						row[1]:setColSpan(11):createSliderCell({ height = Helper.standardTextHeight, valueColor = Helper.color.slidervalue, min = 0, max = menu.crew.capacity, start = (menu.customgamestartpeopledef == "") and 0 or Helper.round(menu.crew.capacity * menu.customgamestartpeoplefillpercentage / 100), step = 1, readOnly = menu.customgamestartpeopledef == "" }):setText(ReadText(1001, 47))
						row[1].handlers.onSliderCellChanged = function(_, newamount) menu.customgamestartpeoplefillpercentage = newamount / menu.crew.capacity * 100 end
					else
						local row = ftable:addRow(false, { bgColor = Helper.color.transparent, scaling = true })
						row[1]:setColSpan(11):createText("")

						if (not menu.usemacro) and (not menu.isReadOnly) then
							local color = Helper.color.white
							if #menu.crew.unassigned > 0 then
								color = Helper.color.red
							end

							local row = ftable:addRow(true, { scaling = true, bgColor = Helper.color.transparent })
							row[1]:setColSpan(7):createText(ReadText(1001, 8025))
							row[8]:setColSpan(3):createText(#menu.crew.unassigned, { halign = "right", color = color })
							row[11]:createButton({ active = (not menu.isReadOnly), mouseOverText = ReadText(1026, 8002) }):setIcon("menu_dismiss")
							row[11].handlers.onClick = menu.buttonFireCrew
						end

						local first = true
						for i, entry in ipairs(menu.crew.roles) do
							local row = menu.displayCrewSlot(ftable, i, entry, buttonWidth, menu.crew.price, first)
							first = false
							if (maxVisibleHeight == nil) and row.index >= config.maxSlotRows then
								maxVisibleHeight = ftable:getFullHeight()
							end
						end
					end
				end
			elseif menu.upgradetypeMode == "software" then
				-- software
				local first = true
				if menu.software[menu.upgradetypeMode] then
					for slot, slotdata in ipairs(menu.software[menu.upgradetypeMode]) do
						if #slotdata.possiblesoftware > 0 then
							if first then
								first = false
							else
								local row = ftable:addRow(false, { bgColor = Helper.color.transparent })
								row[1]:setColSpan(11):createText(" ")
							end
							local row = menu.displaySoftwareSlot(ftable, menu.upgradetypeMode, slot, slotdata)
							if (maxVisibleHeight == nil) and row.index >= config.maxSlotRows then
								maxVisibleHeight = ftable:getFullHeight()
							end
						end
					end
				end
			elseif menu.upgradetypeMode == "settings" then
				-- settings
				-- blacklists
				local row = ftable:addRow(false, { bgColor = Helper.defaultHeaderBackgroundColor })
				row[1]:setColSpan(11):setBackgroundColSpan(10):createText(ReadText(1001, 9143), menu.subHeaderTextProperties)

				local blacklists = Helper.getBlackLists()

				local purpose = GetMacroData(menu.macro, "primarypurpose")
				local group = ((purpose == "fight") or (purpose == "auxiliary")) and "military" or "civilian"
				local types = {
					{ type = "sectortravel",	name = ReadText(1001, 9165) },
					{ type = "sectoractivity",	name = ReadText(1001, 9166) },
					{ type = "objectactivity",	name = ReadText(1001, 9167) },
				}
				for i, entry in ipairs(types) do
					row = ftable:addRow(false, { scaling = true, bgColor = Helper.color.transparent })
					row[1]:setColSpan(11):createText(entry.name .. ReadText(1001, 120))

					local blacklistid = menu.settings.blacklists[entry.type] or 0

					local rowdata = "orders_blacklist_" .. entry.type .. "_global"
					local row = ftable:addRow({ rowdata }, { scaling = true, bgColor = Helper.color.transparent })
					row[1]:setColSpan(1):createCheckBox(blacklistid == 0, { width = Helper.standardTextHeight, height = Helper.standardTextHeight })
					row[1].handlers.onClick = function(_, checked) menu.settings.blacklists[entry.type] = checked and 0 or -1; menu.refreshMenu() end
					row[2]:setColSpan(10):createText(ReadText(1001, 8367))

					local locresponses = {
						{ id = -1, text = ReadText(1001, 7726), icon = "", displayremoveoption = false },
					}

					local defaultblacklistid = -1
					for _, blacklist in ipairs(blacklists) do
						if blacklist.type == entry.type then
							if blacklist.defaults[group] then
								defaultblacklistid = blacklist.id
							end
							table.insert(locresponses, { id = blacklist.id, text = blacklist.name, icon = "", displayremoveoption = false })
						end
					end
					local row = ftable:addRow("orders_resupply", { scaling = true, bgColor = Helper.color.transparent })
					row[1]:setColSpan(10):createDropDown(locresponses, { startOption = (blacklistid ~= 0) and blacklistid or defaultblacklistid, active = blacklistid ~= 0 })
					row[1].handlers.onDropDownConfirmed = function (_, id) menu.settings.blacklists[entry.type] = tonumber(id) end
					row[11]:createButton({ mouseOverText = ReadText(1026, 8413) }):setIcon("menu_edit")
					row[11].handlers.onClick = menu.buttonEditBlacklist

					ftable:addEmptyRow()
				end

				-- fight rules
				local row = ftable:addRow(false, { bgColor = Helper.defaultHeaderBackgroundColor })
				row[1]:setColSpan(11):setBackgroundColSpan(10):createText(ReadText(1001, 7753), menu.subHeaderTextProperties)

				local fightrules = Helper.getFightRules()

				local fightruleid = menu.settings.fightrules["attack"] or 0

				local rowdata = "orders_fightrule_attack_global"
				local row = ftable:addRow({ rowdata }, { scaling = true, bgColor = Helper.color.transparent })
				row[1]:setColSpan(1):createCheckBox(fightruleid == 0, { width = Helper.standardTextHeight, height = Helper.standardTextHeight })
				row[1].handlers.onClick = function(_, checked) menu.settings.fightrules["attack"] = checked and 0 or -1; menu.refreshMenu() end
				row[2]:setColSpan(10):createText(ReadText(1001, 8367))

				local locresponses = {
					{ id = -1, text = ReadText(1001, 7726), icon = "", displayremoveoption = false },
				}

				local defaultfightruleid = -1
				for _, fightrule in ipairs(fightrules) do
					if fightrule.defaults["attack"] then
						defaultfightruleid = fightrule.id
					end
					table.insert(locresponses, { id = fightrule.id, text = fightrule.name, icon = "", displayremoveoption = false })
				end
				local row = ftable:addRow("orders_resupply", { scaling = true, bgColor = Helper.color.transparent })
				row[1]:setColSpan(10):createDropDown(locresponses, { startOption = (fightruleid ~= 0) and fightruleid or defaultfightruleid, active = fightruleid ~= 0 })
				row[1].handlers.onDropDownConfirmed = function (_, id) menu.settings.fightrules["attack"] = tonumber(id) end
				row[11]:createButton({ mouseOverText = ReadText(1026, 8414) }):setIcon("menu_edit")
				row[11].handlers.onClick = menu.buttonEditFightRule
				-- blacklists
				local row = ftable:addRow(false, { bgColor = Helper.defaultHeaderBackgroundColor })
				row[1]:setColSpan(11):setBackgroundColSpan(10):createText(ReadText(1001, 9143), menu.subHeaderTextProperties)

				local blacklists = Helper.getBlackLists()

				local purpose = GetMacroData(menu.macro, "primarypurpose")
				local group = ((purpose == "fight") or (purpose == "auxiliary")) and "military" or "civilian"
				local types = {
					{ type = "sectortravel",	name = ReadText(1001, 9165) },
					{ type = "sectoractivity",	name = ReadText(1001, 9166) },
					{ type = "objectactivity",	name = ReadText(1001, 9167) },
				}
				for i, entry in ipairs(types) do
					row = ftable:addRow(false, { scaling = true, bgColor = Helper.color.transparent })
					row[1]:setColSpan(11):createText(entry.name .. ReadText(1001, 120))

					local blacklistid = menu.settings.blacklists[entry.type] or 0

					local rowdata = "orders_blacklist_" .. entry.type .. "_global"
					local row = ftable:addRow({ rowdata }, { scaling = true, bgColor = Helper.color.transparent })
					row[1]:setColSpan(1):createCheckBox(blacklistid == 0, { width = Helper.standardTextHeight, height = Helper.standardTextHeight })
					row[1].handlers.onClick = function(_, checked) menu.settings.blacklists[entry.type] = checked and 0 or -1; menu.refreshMenu() end
					row[2]:setColSpan(10):createText(ReadText(1001, 8367))

					local locresponses = {
						{ id = -1, text = ReadText(1001, 7726), icon = "", displayremoveoption = false },
					}

					local defaultblacklistid = -1
					for _, blacklist in ipairs(blacklists) do
						if blacklist.type == entry.type then
							if blacklist.defaults[group] then
								defaultblacklistid = blacklist.id
							end
							table.insert(locresponses, { id = blacklist.id, text = blacklist.name, icon = "", displayremoveoption = false })
						end
					end
					local row = ftable:addRow("orders_resupply", { scaling = true, bgColor = Helper.color.transparent })
					row[1]:setColSpan(10):createDropDown(locresponses, { startOption = (blacklistid ~= 0) and blacklistid or defaultblacklistid, active = blacklistid ~= 0 })
					row[1].handlers.onDropDownConfirmed = function (_, id) menu.settings.blacklists[entry.type] = tonumber(id) end
					row[11]:createButton({ mouseOverText = ReadText(1026, 8413) }):setIcon("menu_edit")
					row[11].handlers.onClick = menu.buttonEditBlacklist

					ftable:addEmptyRow()
				end

				-- fight rules
				local row = ftable:addRow(false, { bgColor = Helper.defaultHeaderBackgroundColor })
				row[1]:setColSpan(11):setBackgroundColSpan(10):createText(ReadText(1001, 7753), menu.subHeaderTextProperties)

				local fightrules = Helper.getFightRules()

				local fightruleid = menu.settings.fightrules["attack"] or 0

				local rowdata = "orders_fightrule_attack_global"
				local row = ftable:addRow({ rowdata }, { scaling = true, bgColor = Helper.color.transparent })
				row[1]:setColSpan(1):createCheckBox(fightruleid == 0, { width = Helper.standardTextHeight, height = Helper.standardTextHeight })
				row[1].handlers.onClick = function(_, checked) menu.settings.fightrules["attack"] = checked and 0 or -1; menu.refreshMenu() end
				row[2]:setColSpan(10):createText(ReadText(1001, 8367))

				local locresponses = {
					{ id = -1, text = ReadText(1001, 7726), icon = "", displayremoveoption = false },
				}

				local defaultfightruleid = -1
				for _, fightrule in ipairs(fightrules) do
					if fightrule.defaults["attack"] then
						defaultfightruleid = fightrule.id
					end
					table.insert(locresponses, { id = fightrule.id, text = fightrule.name, icon = "", displayremoveoption = false })
				end
				local row = ftable:addRow("orders_resupply", { scaling = true, bgColor = Helper.color.transparent })
				row[1]:setColSpan(10):createDropDown(locresponses, { startOption = (fightruleid ~= 0) and fightruleid or defaultfightruleid, active = fightruleid ~= 0 })
				row[1].handlers.onDropDownConfirmed = function (_, id) menu.settings.fightrules["attack"] = tonumber(id) end
				row[11]:createButton({ mouseOverText = ReadText(1026, 8414) }):setIcon("menu_edit")
				row[11].handlers.onClick = menu.buttonEditFightRule

				-- missile launchers
				local hasmissilelauncher = false
				for slot, data in pairs(menu.upgradeplan.weapon) do
					if data.macro ~= "" then
						if IsMacroClass(data.macro, "missilelauncher") then
							hasmissilelauncher = true
							break
						end
					end
				end
				if hasmissilelauncher then
					ftable:addEmptyRow()

					local row = ftable:addRow(false, { bgColor = Helper.defaultHeaderBackgroundColor })
					row[1]:setColSpan(11):setBackgroundColSpan(10):createText(ReadText(1001, 9030), menu.subHeaderTextProperties)
					for slot, data in pairs(menu.upgradeplan.weapon) do
						if data.macro ~= "" then
							if IsMacroClass(data.macro, "missilelauncher") then
								menu.displayWeaponAmmoSelection(ftable, "weapon", slot, data)
							end
						end
					end
				end
				-- turrets
				local hasindividualturrets = false
				for slot, data in pairs(menu.upgradeplan.turret) do
					if data.macro ~= "" then
						hasindividualturrets = true
						break
					end
				end
				if hasindividualturrets then
					ftable:addEmptyRow()

					local row = ftable:addRow(false, { bgColor = Helper.defaultHeaderBackgroundColor })
					row[1]:setColSpan(11):setBackgroundColSpan(10):createText(ReadText(1001, 1319), menu.subHeaderTextProperties)
					for slot, data in pairs(menu.upgradeplan.turret) do
						if data.macro ~= "" then
							menu.displayWeaponModeSelection(ftable, "turret", slot, data)
						end
					end
				end
				-- turret groups
				if next(menu.upgradeplan.turretgroup) then
					ftable:addEmptyRow()

					local row = ftable:addRow(false, { bgColor = Helper.defaultHeaderBackgroundColor })
					row[1]:setColSpan(11):setBackgroundColSpan(10):createText(ReadText(1001, 7901), menu.subHeaderTextProperties)
					for slot, groupdata in pairs(menu.upgradeplan.turretgroup) do
						if groupdata.macro ~= "" then
							menu.displayWeaponModeSelection(ftable, "turretgroup", slot, groupdata)
						end
					end
				end
			end
		end

		if maxVisibleHeight ~= nil then
			ftable.properties.maxVisibleHeight = maxVisibleHeight
		end

		ftable:setTopRow(menu.topRows.slots)
		ftable:setSelectedRow(menu.selectedRows.slots)
		ftable:setSelectedCol(menu.selectedCols.slots or 0)
	end

	menu.topRows.slots = nil
	menu.selectedRows.slots = nil
	menu.selectedCols.slots = nil
end
init ()
