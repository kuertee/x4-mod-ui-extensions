-- modes: - "selectComponent",      param: { returnsection, classlist[, category][, playerowned][, customheading][, screenname] }
--        - if "returnsection" == null, insted of "closeMenuForSection", an "AddUITriggeredEvent" is sent with screen = "MapMenu", control = "selectComponent" and param3 = selectedComponent
--        - valid categories are: null or "deployables"
--        - playerowned: 1 (default) or 0
--        - customheading: custom prompt otherwise, {1001, 8325} Select Object (default)
--        - screenname: AddUITriggeredEvent screen name

local ffi = require ("ffi")
local C = ffi.C
local Lib = require ("extensions.sn_mod_support_apis.lua_interface").Library
local dockedMenu = Lib.Get_Egosoft_Menu ("DockedMenu")
local menu = dockedMenu
local oldFuncs = {}
local newFuncs = {}
local callbacks = {}
local isInited
local function init ()
	-- DebugError ("kuertee_menu_docked.init")
	if not isInited then
		isInited = true
		dockedMenu.registerCallback = newFuncs.registerCallback
		-- docked menu rewrites:
		oldFuncs.display = dockedMenu.display
		dockedMenu.display = newFuncs.display
	end
end
function newFuncs.registerCallback (callbackName, callbackFunction)
	-- note 1: format is generally [function name]_[action]. e.g.: in kuertee_menu_transporter, "display_on_set_room_active" overrides the room's active property with the return of the callback.
	-- note 2: events have the word "_on_" followed by a PRESENT TENSE verb. e.g.: in kuertee_menu_transporter, "display_on_set_buttontable" is called after all of the rows of buttontable are set.
	-- note 3: new callbacks can be added or existing callbacks can be edited. but commit your additions/changes to the mod's GIT repository.
	-- note 4: search for the callback names to see where they are executed.
	-- note 5: if a callback requires a return value, return it in an object var. e.g. "display_on_set_room_active" requires a return of {active = true | false}.
	-- available callbacks:
	-- 
	-- sto_addTurretBehavioursDockMenu ()
	-- (true | false) = rd_addReactiveDockingDockMenu (row, menu.currentplayership, i, active, mouseovertext)
	-- display_on_after_main_interactions (ftable)
	if callbacks [callbackName] == nil then
		callbacks [callbackName] = {}
	end
	table.insert (callbacks [callbackName], callbackFunction)
end
-- just copy the whole config - but ensure that all references to "menu." is correct.
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
	inactiveButtonProperties = { bgColor = Helper.defaultUnselectableButtonBackgroundColor, highlightColor = Helper.defaultUnselectableButtonHighlightColor },
	activeButtonTextProperties = { halign = "center" },
	inactiveButtonTextProperties = { halign = "center", color = Helper.color.grey },
	dronetypes = {
		{ id = "orecollector",	name = ReadText(20214, 500) },
		{ id = "gascollector",	name = ReadText(20214, 400) },
		{ id = "defence",		name = ReadText(20214, 300) },
		{ id = "transport",		name = ReadText(20214, 900) },
	},
}
function newFuncs.display()
	Helper.removeAllWidgetScripts(menu)

	local width = Helper.viewWidth
	local height = Helper.viewHeight
	local xoffset = 0
	local yoffset = 0

	menu.frame = Helper.createFrameHandle(menu, { width = width, x = xoffset, y = yoffset, backgroundID = "solid", backgroundColor = Helper.color.semitransparent, standardButtons = (((menu.mode == "docked") and (menu.currentplayership ~= 0)) or menu.secondarycontrolpost) and {} or { close = true, back = true } })

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
	--print("cantrade: " .. tostring(cantrade) .. ", canbuyship: " .. tostring(canbuyship) .. ", canmodifyship: " .. tostring(canmodifyship))

	width = (width / 3) - Helper.borderSize

	-- set up a new table
	table_topleft = menu.frame:addTable(1, { tabOrder = 0, width = Helper.playerInfoConfig.width, height = Helper.playerInfoConfig.height, x = Helper.playerInfoConfig.offsetX, y = Helper.playerInfoConfig.offsetY, scaling = false })

	row = table_topleft:addRow(false, { fixed = true, bgColor = Helper.color.transparent60 })
	local icon = row[1]:createIcon(function () local logo = C.GetCurrentPlayerLogo(); return ffi.string(logo.icon) end, { width = Helper.playerInfoConfig.height, height = Helper.playerInfoConfig.height, color = Helper.getPlayerLogoColor })

	local fontsize = Helper.scaleFont(Helper.standardFont, Helper.standardFontSize)
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

	local row = table_header:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
	local color = Helper.color.white
	if isplayerowned then
		if menu.currentcontainer == C.GetPlayerObjectID() then
			color = Helper.color.playergreen
		else
			color = Helper.color.green
		end
	end
	row[1]:setColSpan(11):createText(menu.currentcontainer and ffi.string(C.GetComponentName(menu.currentcontainer)) or "", Helper.headerRowCenteredProperties)
	row[1].properties.color = color

	height = Helper.scaleY(Helper.standardTextHeight)

	local row = table_header:addRow(false, { fixed = true, bgColor = Helper.color.unselectable })
	if menu.mode == "cockpit" then
		row[2]:createText(ffi.string(C.GetObjectIDCode(menu.currentcontainer)), { halign = "center", color = color })
	else
		row[1]:createIcon(ownericon, { width = height, height = height, x = row[1]:getWidth() - height, scaling = false })
		row[2]:createText(function() return GetComponentData(menu.currentcontainer, "ownername") end, { halign = "center" })
		row[7]:createText(function() return "[" .. GetUIRelation(GetComponentData(menu.currentcontainer, "owner")) .. "]" end, { halign = "left" })
	end

	table_header:addEmptyRow(yoffset)

	if menu.mode == "cockpit" then
		local row = table_header:addRow("buttonRow1", { bgColor = Helper.color.transparent, fixed = true })
		row[1]:createButton(config.inactiveButtonProperties):setText("", config.inactiveButtonTextProperties)	-- dummy
		local active = ((menu.currentplayership ~= 0) or menu.secondarycontrolpost) and C.CanPlayerStandUp()
		row[2]:createButton(active and { mouseOverText = GetLocalizedKeyName("action", 277), helpOverlayID = "docked_getup", helpOverlayText = " ", helpOverlayHighlightOnly = true } or config.inactiveButtonProperties):setText(ReadText(1002, 20014), active and config.activeButtonTextProperties or config.inactiveButtonTextProperties)	-- "Get Up"
		if active then
			row[2].handlers.onClick = menu.buttonGetUp
		end
		row[7]:createButton({ mouseOverText = GetLocalizedKeyName("action", 316), helpOverlayID = "docked_shipinformation", helpOverlayText = " ", helpOverlayHighlightOnly = true }):setText(ReadText(1001, 8602), { halign = "center" })	-- "Ship Information"
		row[7].handlers.onClick = menu.buttonShipInfo

		local row = table_header:addRow("buttonRow3", { bgColor = Helper.color.transparent, fixed = true })
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
			row[2]:createDropDown(modes, {
				helpOverlayID = "docked_modes",		
				helpOverlayText = " ", 
				helpOverlayHighlightOnly = true, 
				height = Helper.standardButtonHeight,
				startOption = "",
				textOverride = ReadText(1002, 1001),
				bgColor = active and Helper.defaultButtonBackgroundColor or Helper.defaultUnselectableButtonBackgroundColor,
				highlightColor = active and Helper.defaultButtonHighlightColor or Helper.defaultUnselectableButtonHighlightColor
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
								table.insert(civilian, { id = consumabledata.id .. ":" .. macro, text = GetMacroData(macro, "name"), text2 = "(" .. consumables[j].amount .. ")", icon = "", displayremoveoption = false })
							else
								table.insert(military, { id = consumabledata.id .. ":" .. macro, text = GetMacroData(macro, "name"), text2 = "(" .. consumables[j].amount .. ")", icon = "", displayremoveoption = false })
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
			bgColor = active and Helper.defaultButtonBackgroundColor or Helper.defaultUnselectableButtonBackgroundColor,
			highlightColor = active and Helper.defaultButtonHighlightColor or Helper.defaultUnselectableButtonHighlightColor,
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
			bgColor = active and Helper.defaultButtonBackgroundColor or Helper.defaultUnselectableButtonBackgroundColor,
			highlightColor = active and Helper.defaultButtonHighlightColor or Helper.defaultUnselectableButtonHighlightColor,
			mouseOverText = mouseovertext,
		}):setTextProperties(active and config.activeButtonTextProperties or config.inactiveButtonTextProperties):setText2Properties(active and config.activeButtonTextProperties or config.inactiveButtonTextProperties)	-- Deploy Military
		row[7].properties.text2.halign = "right"
		row[7].properties.text2.x = Helper.standardTextOffsetx
		if active then
			row[7].handlers.onDropDownConfirmed = menu.dropdownDeploy
		end

		local row = table_header:addRow("buttonRow2", { bgColor = Helper.color.transparent, fixed = true })
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

				local titlerow = table_header:addRow(false, { bgColor = Helper.color.transparent })
				titlerow[1]:setColSpan(11):createText(ReadText(1001, 9409), Helper.headerRowCenteredProperties)
				titlerow[1].properties.helpOverlayID = "docked_weaponconfig"
				titlerow[1].properties.helpOverlayText = " "
				titlerow[1].properties.helpOverlayHeight = titlerow:getHeight()
				titlerow[1].properties.helpOverlayHighlightOnly = true
				titlerow[1].properties.helpOverlayScaling = false

				local row = table_header:addRow(false, { bgColor = Helper.color.unselectable })
				row[2]:createText(ReadText(1001, 9410), { font = Helper.standardFontBold, halign = "center" })
				row[7]:createText(ReadText(1001, 9411), { font = Helper.standardFontBold, halign = "center" })
				titlerow[1].properties.helpOverlayHeight = titlerow[1].properties.helpOverlayHeight + row:getHeight() + Helper.borderSize

				-- active weapon groups
				local row = table_header:addRow("weaponconfig_active", { bgColor = Helper.color.transparent })
				row[1]:setColSpan(2):createText(ReadText(1001, 11218))
				row[7]:setColSpan(1)
				for j = 1, 4 do
					row[2 + j]:createCheckBox(function () return C.GetDefensibleActiveWeaponGroup(menu.currentplayership, true) == j end, { width = Helper.standardTextHeight, height = Helper.standardTextHeight, symbol = "arrow", bgColor = function () return menu.checkboxWeaponGroupColor(j, true) end })
					row[2 + j].handlers.onClick = function () C.SetDefensibleActiveWeaponGroup(menu.currentplayership, true, j) end
				end
				for j = 1, 4 do
					row[7 + j]:createCheckBox(function () return C.GetDefensibleActiveWeaponGroup(menu.currentplayership, false) == j end, { width = Helper.standardTextHeight, height = Helper.standardTextHeight, symbol = "arrow", bgColor = function () return menu.checkboxWeaponGroupColor(j, false) end })
					row[7 + j].handlers.onClick = function () C.SetDefensibleActiveWeaponGroup(menu.currentplayership, false, j) end
				end
				table_header:addEmptyRow(Helper.standardTextHeight / 2)

				for _, weapon in ipairs(weapons) do
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

					local row = table_header:addRow("weaponconfig", { bgColor = Helper.color.transparent })
					row[1]:setColSpan(2):createText(ffi.string(C.GetComponentName(weapon)))
					row[7]:setColSpan(1)
					for j = 1, 4 do
						row[2 + j]:createCheckBox(uiweapongroups.primary[j], { width = Helper.standardTextHeight, height = Helper.standardTextHeight, bgColor = function () return menu.checkboxWeaponGroupColor(j, true) end })
						row[2 + j].handlers.onClick = function() menu.checkboxWeaponGroup(menu.currentplayership, weapon, true, j, not uiweapongroups.primary[j]) end
					end
					for j = 1, 4 do
						row[7 + j]:createCheckBox(uiweapongroups.secondary[j], { width = Helper.standardTextHeight, height = Helper.standardTextHeight, bgColor = function () return menu.checkboxWeaponGroupColor(j, false) end })
						row[7 + j].handlers.onClick = function() menu.checkboxWeaponGroup(menu.currentplayership, weapon, false, j, not uiweapongroups.secondary[j]) end
					end
					titlerow[1].properties.helpOverlayHeight = titlerow[1].properties.helpOverlayHeight + row:getHeight() + Helper.borderSize

					if C.IsComponentClass(weapon, "missilelauncher") then
						local nummissiletypes = C.GetNumAllMissiles(menu.currentplayership)
						local missilestoragetable = ffi.new("AmmoData[?]", nummissiletypes)
						nummissiletypes = C.GetAllMissiles(missilestoragetable, nummissiletypes, menu.currentplayership)

						local weaponmacro = GetComponentData(ConvertStringTo64Bit(tostring(weapon)), "macro")
						local dropdowndata = {}
						for j = 0, nummissiletypes-1 do
							local ammomacro = ffi.string(missilestoragetable[j].macro)
							if C.IsAmmoMacroCompatible(weaponmacro, ammomacro) then
								table.insert(dropdowndata, {id = ammomacro, text = GetMacroData(ammomacro, "name"), icon = "", displayremoveoption = false})
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

						local row = table_header:addRow("ammo_config", { bgColor = Helper.color.transparent })
						row[1]:createText("    " .. ReadText(1001, 2800) .. ReadText(1001, 120))	-- Ammunition, :
						row[2]:setColSpan(10):createDropDown(dropdowndata, { startOption = function () return menu.getDropDownOption(weapon) end, active = dropdownactive })
						row[2].handlers.onDropDownConfirmed = function(_, newammomacro) C.SetAmmoOfWeapon(weapon, newammomacro) end
						titlerow[1].properties.helpOverlayHeight = titlerow[1].properties.helpOverlayHeight + row:getHeight() + Helper.borderSize
					elseif pilot and C.IsComponentClass(weapon, "bomblauncher") then
						local pilot64 = ConvertIDTo64Bit(pilot)
						local numbombtypes = C.GetNumAllInventoryBombs(pilot64)
						local bombstoragetable = ffi.new("AmmoData[?]", numbombtypes)
						numbombtypes = C.GetAllInventoryBombs(bombstoragetable, numbombtypes, pilot64)

						local weaponmacro = GetComponentData(ConvertStringTo64Bit(tostring(weapon)), "macro")
						local dropdowndata = {}
						for j = 0, numbombtypes-1 do
							local ammomacro = ffi.string(bombstoragetable[j].macro)
							if C.IsAmmoMacroCompatible(weaponmacro, ammomacro) then
								table.insert(dropdowndata, { id = ammomacro, text = GetMacroData(ammomacro, "name"), icon = "", displayremoveoption = false })
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

						local row = table_header:addRow("ammo_config", { bgColor = Helper.color.transparent })
						row[1]:createText("    " .. ReadText(1001, 2800) .. ReadText(1001, 120))	-- Ammunition, :
						row[2]:setColSpan(10):createDropDown(dropdowndata, { startOption = function () return menu.getDropDownOption(weapon) end, active = dropdownactive })
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

				local row = table_header:addRow(false, { bgColor = Helper.color.transparent })
				row[1]:setColSpan(11):createText(ReadText(1001, 8612), Helper.headerRowCenteredProperties)

				local row = table_header:addRow(false, { bgColor = Helper.color.unselectable })
				row[2]:createText(ReadText(1001, 8620), { font = Helper.standardFontBold, halign = "center" })
				row[7]:createText(ReadText(1001, 12),   { font = Helper.standardFontBold, halign = "center" })

				local row = table_header:addRow("turret_config", { bgColor = Helper.color.transparent })
				row[1]:createText(ReadText(1001, 2963))

				-- Start Subsystem Targeting Orders callback
				local sto_callbackVal
				if callbacks ["sto_addTurretBehavioursDockMenu"] then
				  for _, callback in ipairs (callbacks ["sto_addTurretBehavioursDockMenu"]) do
				    sto_callbackVal = callback (row)
				  end
				end
				if not sto_callbackVal then
					row[2]:setColSpan(5):createDropDown(Helper.getTurretModes(nil, not hasonlytugturrets), { startOption = function () return menu.getDropDownTurretModeOption(menu.currentplayership, "all") end, helpOverlayID = "docked_turretconfig_modes", helpOverlayText = " ", helpOverlayHighlightOnly = true  })
					row[2].handlers.onDropDownConfirmed = function(_, newturretmode) C.SetAllTurretModes(menu.currentplayership, newturretmode) end
				end
				-- End Subsystem Targeting Orders callback
				row[7]:setColSpan(5):createButton({ helpOverlayID = "docked_turretconfig_arm", helpOverlayText = " ", helpOverlayHighlightOnly = true  }):setText(function () return menu.areTurretsArmed(menu.currentplayership) and ReadText(1001, 8631) or ReadText(1001, 8632) end, { halign = "center" })
				row[7].handlers.onClick = function () return C.SetAllTurretsArmed(menu.currentplayership, not menu.areTurretsArmed(menu.currentplayership)) end

				local turretscounter = 0
				for i, turret in ipairs(menu.turrets) do
					local row = table_header:addRow("turret_config", { bgColor = Helper.color.transparent })
					turretscounter = turretscounter + 1
					local turretname = ffi.string(C.GetComponentName(turret))
					local mouseovertext = ""
					local textwidth = C.GetTextWidth(turretname, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize)) + Helper.scaleX(Helper.standardTextOffsetx)
					if (textwidth > row[1]:getWidth()) then
						mouseovertext = turretname
					end
					row[1]:createText(turretname, { mouseOverText = mouseovertext })
					row[2]:setColSpan(5):createDropDown(Helper.getTurretModes(turret), { startOption = function () return menu.getDropDownTurretModeOption(turret) end, helpOverlayID = "docked_turrets_modes".. turretscounter, helpOverlayText = " ", helpOverlayHighlightOnly = true  })
					row[2].handlers.onDropDownConfirmed = function(_, newturretmode) C.SetWeaponMode(turret, newturretmode) end
					row[7]:setColSpan(5):createButton({helpOverlayID = "docked_turrets_arm" .. turretscounter, helpOverlayText = " ", helpOverlayHighlightOnly = true   }):setText(function () return C.IsWeaponArmed(turret) and ReadText(1001, 8631) or ReadText(1001, 8632) end, { halign = "center" })
					row[7].handlers.onClick = function () return C.SetWeaponArmed(turret, not C.IsWeaponArmed(turret)) end
				end

				local turretgroupscounter = 0
				for i, group in ipairs(menu.turretgroups) do
					local row = table_header:addRow("turret_config", { bgColor = Helper.color.transparent })
					turretgroupscounter = turretgroupscounter + 1
					local groupname = ReadText(1001, 8023) .. " " .. Helper.getSlotSizeText(group.slotsize) .. group.sizecount .. ((group.currentmacro ~= "") and (" (" .. Helper.getSlotSizeText(group.slotsize) .. " " .. GetMacroData(group.currentmacro, "shortname") .. ")") or "")
					local mouseovertext = ""
					local textwidth = C.GetTextWidth(groupname, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize)) + Helper.scaleX(Helper.standardTextOffsetx)
					if (textwidth > row[1]:getWidth()) then
						mouseovertext = groupname
					end
					row[1]:createText(groupname, { color = (group.operational > 0) and Helper.color.white or Helper.color.red, mouseOverText = mouseovertext })
					row[2]:setColSpan(5):createDropDown(Helper.getTurretModes(group.currentcomponent ~= 0 and group.currentcomponent or nil), { startOption = function () return menu.getDropDownTurretModeOption(menu.currentplayership, group.context, group.path, group.group) end, active = group.operational > 0, helpOverlayID = "docked_turretgroups_modes".. turretgroupscounter, helpOverlayText = " ", helpOverlayHighlightOnly = true  })
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

				local row = table_header:addRow(false, { bgColor = Helper.color.transparent })
				row[1]:setColSpan(11):createText(ReadText(1001, 8619), Helper.headerRowCenteredProperties)

				local row = table_header:addRow(false, { bgColor = Helper.color.unselectable })
				row[2]:createText(ReadText(1001, 8620), { font = Helper.standardFontBold, halign = "center" })
				row[7]:createText(ReadText(1001, 12), { font = Helper.standardFontBold, halign = "center" })

				for _, entry in ipairs(menu.drones) do
					local isblocked = C.IsDroneTypeBlocked(menu.currentplayership, entry.type)
					local row = table_header:addRow("drone_config", { bgColor = Helper.color.transparent })
					row[1]:createText(function () return entry.name .. " (" .. (C.IsDroneTypeArmed(menu.currentplayership, entry.type) and (C.GetNumUnavailableUnits(menu.currentplayership, entry.type) .. "/") or "") .. C.GetNumStoredUnits(menu.currentplayership, entry.type, false) ..")" end, { color = isblocked and Helper.color.warningorange or nil })
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

				local row = table_header:addRow(false, { bgColor = Helper.color.transparent })
				row[1]:setColSpan(11):createText(ReadText(1001, 8626), Helper.headerRowCenteredProperties)

				local row = table_header:addRow(false, { bgColor = Helper.color.unselectable })
				row[1]:createText(ReadText(1001, 8627), { font = Helper.standardFontBold, halign = "center" })
				row[2]:createText(ReadText(1001, 8373), { font = Helper.standardFontBold, halign = "center" })
				row[7]:createText(ReadText(1001, 8628), { font = Helper.standardFontBold, halign = "center" })

				for i = 1, 10 do
					if groups[i] then
						local supplyactive = (groups[i].numassignableresupplyships == #groups[i].subordinates) and ((not usedassignments["supplyfleet"]) or (usedassignments["supplyfleet"] == i))
						local subordinateassignments = {
							[1] = { id = "defence",			text = ReadText(20208, 40301),	icon = "",	displayremoveoption = false },
							[2] = { id = "supplyfleet",		text = ReadText(20208, 40701),	icon = "",	displayremoveoption = false, active = supplyactive, mouseovertext = supplyactive and "" or ReadText(1026, 8601) },
						}

						if C.IsComponentClass(menu.currentplayership, "station") then
							local miningactive = (groups[i].numassignableminingships == #groups[i].subordinates) and ((not usedassignments["mining"]) or (usedassignments["mining"] == i))
							table.insert(subordinateassignments, { id = "mining", text = ReadText(20208, 40201), icon = "", displayremoveoption = false, active = miningactive, mouseovertext = miningactive and "" or ReadText(1026, 8602) })
							local tradeactive = (not usedassignments["trade"]) or (usedassignments["trade"] == i)
							table.insert(subordinateassignments, { id = "trade", text = ReadText(20208, 40101), icon = "", displayremoveoption = false, active = tradeactive, mouseovertext = tradeactive and ((groups[i].numassignableminingships > 0) and (Helper.convertColorToText(Helper.color.warningorange) .. ReadText(1026, 8607)) or "") or ReadText(1026, 7840) })
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

						local isdockingpossible = false
						for _, subordinate in ipairs(groups[i].subordinates) do
							if IsDockingPossible(subordinate, menu.currentplayership) then
								isdockingpossible = true
								break
							end
						end
						local active = true
						local mouseovertext = ""
						if not GetComponentData(menu.currentplayership, "hasshipdockingbays") then
							active = false
							mouseovertext = ReadText(1026, 8604)
						elseif not isdockingpossible then
							active = false
							mouseovertext = ReadText(1026, 8605)
						end

						local row = table_header:addRow("subordinate_config", { bgColor = Helper.color.transparent })
						row[1]:createText(function () menu.updateSubordinateGroupInfo(); return ReadText(20401, i) .. (menu.subordinategroups[i] and (" (" .. ((not C.ShouldSubordinateGroupDockAtCommander(menu.currentplayership, i)) and ((#menu.subordinategroups[i].subordinates - menu.subordinategroups[i].numdockedatcommander) .. "/") or "") .. #menu.subordinategroups[i].subordinates ..")") or "") end, { color = isblocked and Helper.color.warningorange or nil })
						row[2]:setColSpan(5):createDropDown(subordinateassignments, { startOption = function () menu.updateSubordinateGroupInfo(); return menu.subordinategroups[i] and menu.subordinategroups[i].assignment or "" end })
						row[2].handlers.onDropDownConfirmed = function(_, newassignment) Helper.dropdownAssignment(_, nil, i, menu.currentplayership, newassignment) end
						
						-- Start Reactive Docking callback
						local rd_callbackVal
						if callbacks ["rd_addReactiveDockingDockMenu"] then
				  			for _, callback in ipairs (callbacks ["rd_addReactiveDockingDockMenu"]) do
				    			rd_callbackVal = callback (row, menu.currentplayership, i, active, mouseovertext)
				  			end
						end
						if not rd_callbackVal then
							row[7]:setColSpan(5):createButton({ active = active, mouseOverText = mouseovertext }):setText(function () return C.ShouldSubordinateGroupDockAtCommander(menu.currentplayership, i) and ReadText(1001, 8630) or ReadText(1001, 8629) end, { halign = "center" })
							row[7].handlers.onClick = function () return C.SetSubordinateGroupDockAtCommander(menu.currentplayership, i, not C.ShouldSubordinateGroupDockAtCommander(menu.currentplayership, i)) end
						end
						-- End Reactive Docking callback
					end
				end
			end
		end
	else
		local row = table_header:addRow("buttonRow1", { bgColor = Helper.color.transparent, fixed = true })
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
		row[2].handlers.onClick = menu.buttonGetUp
		local active = menu.currentplayership ~= 0
		row[7]:createButton(active and { mouseOverText = GetLocalizedKeyName("action", 316), helpOverlayID = "docked_shipinfo", helpOverlayText = " ", helpOverlayHighlightOnly = true } or config.inactiveButtonProperties):setText(ReadText(1001, 8602), active and config.activeButtonTextProperties or config.inactiveButtonTextProperties)	-- "Ship Information"
		if active then
			row[7].handlers.onClick = menu.buttonDockedShipInfo
		end

		local row = table_header:addRow("buttonRow2", { bgColor = Helper.color.transparent, fixed = true })
		local active = canbuyship
		row[1]:createButton(active and {helpOverlayID = "docked_buyships", helpOverlayText = " ", helpOverlayHighlightOnly = true } or config.inactiveButtonProperties):setText(ReadText(1002, 8008), active and config.activeButtonTextProperties or config.inactiveButtonTextProperties)	-- "Buy Ships"
		if active then
			row[1].handlers.onClick = menu.buttonBuyShip
		end
		local active = cantrade
		row[2]:createButton(active and {helpOverlayID = "docked_trade", helpOverlayText = " ", helpOverlayHighlightOnly = true } or config.inactiveButtonProperties):setText(ReadText(1002, 9005), active and config.activeButtonTextProperties or config.inactiveButtonTextProperties)	-- "Trade"
		if active then
			row[2].handlers.onClick = function() return menu.buttonTrade(false) end
			row[2].properties.uiTriggerID = "docked_trade"
		end
		local active = canmodifyship
		row[7]:createButton(active and {helpOverlayID = "docked_upgrade_repair", helpOverlayText = " ", helpOverlayHighlightOnly = true } or config.inactiveButtonProperties):setText(issupplyship and ReadText(1001, 7877) or ReadText(1001, 7841), active and config.activeButtonTextProperties or config.inactiveButtonTextProperties)	-- Upgrade / Repair Ship
		if dockedplayerships[1] and (not canequip) then
			row[7].properties.mouseOverText = (C.IsComponentClass(dockedplayerships[1], "ship_l") or C.IsComponentClass(dockedplayerships[1], "ship_xl")) and ReadText(1026, 7807) or ReadText(1026, 7806)
		elseif not isdock then
			row[7].properties.mouseOverText = ReadText(1026, 8014)
		end
		if active then
			row[7].handlers.onClick = menu.buttonModifyShip
		end

		local row = table_header:addRow("buttonRow3", { bgColor = Helper.color.transparent, fixed = true })
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
				bgColor = active and Helper.defaultButtonBackgroundColor or Helper.defaultUnselectableButtonBackgroundColor,
				highlightColor = active and Helper.defaultButtonHighlightColor or Helper.defaultUnselectableButtonHighlightColor
			}):setTextProperties(active and config.activeButtonTextProperties or config.inactiveButtonTextProperties)	-- Modes
			if active then
				row[1].handlers.onDropDownConfirmed = menu.dropdownMode
				row[1].properties.uiTriggerID = "startmode"
			end
		end
		if menu.currentplayership ~= 0 then
			row[2]:createButton({ mouseOverText = GetLocalizedKeyName("action", 175), bgColor = menu.undockButtonBGColor, highlightColor = menu.undockButtonHighlightColor, helpOverlayID = "docked_undock", helpOverlayText = " ", helpOverlayHighlightOnly = true }):setText(ReadText(1002, 20013), { halign = "center", color = menu.undockButtonTextColor })	-- "Undock"
			row[2].handlers.onClick = menu.buttonUndock
		else
			row[2]:createButton({ mouseOverText = GetLocalizedKeyName("action", 175), helpOverlayID = "docked_gotoship", helpOverlayText = " ", helpOverlayHighlightOnly = true }):setText(ReadText(1001, 7305), { halign = "center" })	-- "Go to Ship"
			row[2].handlers.onClick = menu.buttonGoToShip
		end
		row[7]:createButton(config.inactiveButtonProperties):setText("", config.inactiveButtonTextProperties)	-- dummy

		-- start: kuertee call-back
		if callbacks ["display_on_after_main_interactions"] then
  			for _, callback in ipairs (callbacks ["display_on_after_main_interactions"]) do
  				callback (table_header)
  			end
  		end
		-- end: kuertee call-back

		local row = table_header:addRow(false, { bgColor = Helper.color.transparent, fixed = true })
		row[1]:setColSpan(11):createBoxText(menu.infoText, { halign = "center", color = Helper.color.warningorange, boxColor = menu.infoBoxColor })
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
init ()
