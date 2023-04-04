local ffi = require ("ffi")
local C = ffi.C
local Lib = require ("extensions.sn_mod_support_apis.lua_interface").Library
local stationConfigurationMenu = Lib.Get_Egosoft_Menu ("StationConfigurationMenu")
local menu = stationConfigurationMenu
local oldFuncs = {}
local newFuncs = {}
local callbacks = {}
local isInited
local function init ()
	-- DebugError ("kuertee_menu_station_overview.init")
	if not isInited then
		isInited = true
		stationConfigurationMenu = Lib.Get_Egosoft_Menu ("StationConfigurationMenu")
		stationConfigurationMenu.registerCallback = newFuncs.registerCallback
		-- rewrites:
		oldFuncs.cleanup = stationConfigurationMenu.cleanup
		stationConfigurationMenu.cleanup = newFuncs.cleanup
		oldFuncs.displayPlan = stationConfigurationMenu.displayPlan
		stationConfigurationMenu.displayPlan = newFuncs.displayPlan
	end
end
function newFuncs.registerCallback (callbackName, callbackFunction)
	-- note 1: format is generally [function name]_[action]. e.g.: in kuertee_menu_transporter, "display_on_set_room_active" overrides the room's active property with the return of the callback.
	-- note 2: events have the word "_on_" followed by a PRESET TENSE verb. e.g.: in kuertee_menu_transporter, "display_on_set_buttontable" is called after all of the rows of buttontable are set.
	-- note 3: new callbacks can be added or existing callbacks can be edited. but commit your additions/changes to the mod's GIT repository.
	-- note 4: search for the callback names to see where they are executed.
	-- note 5: if a callback requires a return value, return it in an object var. e.g. "display_on_set_room_active" requires a return of {active = true | false}.
	-- available callbacks:
	-- cleanup()
	-- displayPlan_getWareName(ware, name)
	-- isbreak = displayPlan_render_incoming_ware(row, name, reservation)
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
	leftBar = {
		{ name = ReadText(1001, 2421),	icon = "stationbuildst_production",		mode = "moduletypes_production",	helpOverlayID = "stationbuildst_production",	helpOverlayText = ReadText(1028, 3250)  },
		{ name = ReadText(1001, 2439),	icon = "stationbuildst_buildmodule",	mode = "moduletypes_build",			helpOverlayID = "stationbuildst_buildmodule",	helpOverlayText = ReadText(1028, 3251)  },
		{ name = ReadText(1001, 2422),	icon = "stationbuildst_storage",		mode = "moduletypes_storage",		helpOverlayID = "stationbuildst_storage",		helpOverlayText = ReadText(1028, 3252)  },
		{ name = ReadText(1001, 2451),	icon = "stationbuildst_habitation",		mode = "moduletypes_habitation",	helpOverlayID = "stationbuildst_habitation",	helpOverlayText = ReadText(1028, 3253)  },
		{ name = ReadText(1001, 9620),	icon = "stationbuildst_welfare",		mode = "moduletypes_welfare",		helpOverlayID = "stationbuildst_welfare",		helpOverlayText = ReadText(1028, 3258)  },
		{ name = ReadText(1001, 2452),	icon = "stationbuildst_dock",			mode = "moduletypes_dock",			helpOverlayID = "stationbuildst_dock",			helpOverlayText = ReadText(1028, 3254)  },
		{ name = ReadText(1001, 2424),	icon = "stationbuildst_defense",		mode = "moduletypes_defence",		helpOverlayID = "stationbuildst_defense",		helpOverlayText = ReadText(1028, 3255)  },
		{ name = ReadText(1001, 9621),	icon = "stationbuildst_processing",		mode = "moduletypes_processing",	helpOverlayID = "stationbuildst_processing",	helpOverlayText = ReadText(1028, 3259)  },
		{ name = ReadText(1001, 2453),	icon = "stationbuildst_other",			mode = "moduletypes_other",			helpOverlayID = "stationbuildst_other",			helpOverlayText = ReadText(1028, 3256)  },
		{ name = ReadText(1001, 2454),	icon = "stationbuildst_venture",		mode = "moduletypes_venture",		helpOverlayID = "stationbuildst_venture",		helpOverlayText = ReadText(1028, 3257)  },
	},
	leftBarLoadout = {
		{ name = ReadText(1001, 7901),	icon = "shipbuildst_turretgroups",		mode = "turretgroup" },
	},
	equipmentBlueprintGroups = {
		{ type = "turret", library = "weapons_turrets" },
		{ type = "turret", library = "weapons_missileturrets" },
		{ type = "shield", library = "shieldgentypes" },
	},
	dropDownTextProperties = {
		halign = "center",
		font = Helper.standardFont,
		fontsize = Helper.scaleFont(Helper.standardFont, Helper.standardFontSize),
		color = Helper.color.white,
		x = 0,
		y = 0
	},
	scaleSize = 2,
	stateKeys = {
		{ "container", "UniverseID" },
		{ "buildstorage", "UniverseID" },
		{ "loadoutModuleIdx" },
		{ "modulesMode", },
		-- { "upgradeplan" }, -- reserved for loadoutModuleIdx information
		{ "origDefaultLoadout", "bool" },
	},
	sizeSorting = {
		["small"] = 1,
		["medium"] = 2,
		["large"] = 3,
		["extralarge"] = 4,
	},
	maxSidePanelWidth = 800,
	maxCenterPanelWidth = 1600,
	fileExtension = ".xml",
	slotSizeOrder = {
		["extralarge"]	= 1,
		["large"]		= 2,
		["medium"]		= 3,
		["small"]		= 4,
	},
	compatibilityFontSize = 5,
	mapfilterversion = 1,
	discreteAngleSlider = {
		min = 5,
		max = 180,
		step = 5,
	},
	moduleFilterWidth = 300,
}
function newFuncs.cleanup()
	oldFuncs.cleanup()

	-- kuertee start: callback
	if callbacks ["cleanup"] then
		for _, callback in ipairs (callbacks ["cleanup"]) do
			callback ()
		end
	end
	-- kuertee end: callback
end
function newFuncs.displayPlan(frame)
	if not menu.loadoutMode then
		local ftable, modulestatustable, resourcetable
		local statusBars = {}
		if menu.planMode == "construction" then
			-- MODULE CHANGES
			ftable = frame:addTable(5, { tabOrder = 3, width = menu.planData.width, maxVisibleHeight = 0.4 * Helper.viewHeight, x = menu.planData.offsetX, y = menu.planData.offsetY, reserveScrollBar = true, backgroundID = "solid", backgroundColor = Helper.color.transparent60 })
			ftable:setColWidth(1, Helper.scaleY(Helper.standardTextHeight), false)
			ftable:setColWidth(2, Helper.scaleY(Helper.standardTextHeight), false)
			ftable:setColWidth(4, 0.25 * menu.planData.width, false)
			ftable:setColWidth(5, Helper.scaleY(Helper.standardTextHeight), false)

			local prevfullheight = 0
			-- modules
			local row = ftable:addRow(false, { bgColor = Helper.defaultTitleBackgroundColor, fixed = true })
			row[1]:setColSpan(5):createText(ReadText(1001, 7924), menu.headerTextProperties)
			-- unchanged modules
			local sortedModules = {}
			local changedCount = 0
			local habitationadded = 0
			local workforceneedadded = 0
			for i = 1, #menu.constructionplan do
				local infolibrary = GetMacroData(menu.constructionplan[i].macro, "infolibrary")
				if not menu.changedModulesIndices[i] then
					if sortedModules[infolibrary] then
						table.insert(sortedModules[infolibrary], menu.constructionplan[i])
					else
						sortedModules[infolibrary] = { menu.constructionplan[i] }
					end
				else
					changedCount = changedCount + 1
					if infolibrary == "moduletypes_habitation" then
						habitationadded = habitationadded + GetMacroData(menu.constructionplan[i].macro, "workforcecapacity")
					elseif infolibrary == "moduletypes_production" then
						workforceneedadded = workforceneedadded + GetMacroData(menu.constructionplan[i].macro, "maxworkforce")
					end
				end
			end
			for _, entry in ipairs(config.leftBar) do
				if sortedModules[entry.mode] then
					local isextended = menu.isEntryExtended(menu.container, entry.mode)

					local row = ftable:addRow(true, { bgColor = Helper.defaultTitleBackgroundColor })
					row[1]:createButton({  }):setText(isextended and "-" or "+", { halign = "center" })
					row[1].handlers.onClick = function () return menu.buttonExtendEntry(entry.mode, row.index) end
					row[2]:setColSpan(2):setBackgroundColSpan(4):createText(entry.name, Helper.subHeaderTextProperties)
					row[4]:setColSpan(2):createText(#sortedModules[entry.mode], Helper.subHeaderTextProperties)
					row[4].properties.halign = "right"
					prevfullheight = menu.moduleHeightHelper(ftable, prevfullheight)

					if isextended then
						table.sort(sortedModules[entry.mode], menu.moduleSorter)
						for i = 1, #sortedModules[entry.mode] do
							local row = menu.displayModuleRow(ftable, i .. "entry.mode", sortedModules[entry.mode][i], false, false)
							prevfullheight = menu.moduleHeightHelper(ftable, prevfullheight)
						end

						if entry.mode == "moduletypes_habitation" then
							local workforceinfo = C.GetWorkForceInfo(menu.container, "");

							ftable:addEmptyRow()
							local row = ftable:addRow(true, { bgColor = Helper.color.transparent })
							row[2]:setColSpan(2):createText("   " .. ReadText(1001, 9611))
							row[4]:createText(ConvertIntegerString(workforceinfo.capacity, true, 0, true, false) .. ((habitationadded > 0) and (" (" .. ConvertIntegerString(workforceinfo.capacity + habitationadded, true, 0, true, false) .. ")") or ""), { halign = "right" })
							local row = ftable:addRow(true, { bgColor = Helper.color.transparent })
							row[2]:setColSpan(2):createText("   " .. ReadText(1001, 8412))
							row[4]:createText(ConvertIntegerString(workforceinfo.current, true, 0, true, false), { halign = "right" })
							local row = ftable:addRow(true, { bgColor = Helper.color.transparent })
							row[2]:setColSpan(2):createText("   " .. ReadText(1001, 8413))
							row[4]:createText(ConvertIntegerString(workforceinfo.optimal, true, 0, true, false) .. ((workforceneedadded > 0) and (" (" .. ConvertIntegerString(workforceinfo.optimal + workforceneedadded, true, 0, true, false) .. ")") or ""), { halign = "right" })
						end
					end
				end
			end
			-- removed modules
			if #menu.removedModules > 0 then
				local isextended = menu.isEntryExtended(menu.container, "removed")

				local row = ftable:addRow(true, { bgColor = Helper.defaultTitleBackgroundColor })
				row[1]:createButton({  }):setText(isextended and "-" or "+", { halign = "center" })
				row[1].handlers.onClick = function () return menu.buttonExtendEntry("removed", row.index) end
				row[2]:setColSpan(2):setBackgroundColSpan(4):createText(ReadText(1001, 7964), Helper.subHeaderTextProperties)
				row[2].properties.color = Helper.color.red
				row[4]:setColSpan(2):createText(#menu.removedModules, Helper.subHeaderTextProperties)
				row[4].properties.halign = "right"
				prevfullheight = menu.moduleHeightHelper(ftable, prevfullheight)
				if isextended then
					for i, entry in ipairs(menu.removedModules) do
						menu.displayModuleRow(ftable, i, entry, false, true)
						prevfullheight = menu.moduleHeightHelper(ftable, prevfullheight)
					end
				end
			end
			-- changed or new modules
			if changedCount > 0 then
				local isextended = menu.isEntryExtended(menu.container, "planned")

				local row = ftable:addRow(true, { bgColor = Helper.defaultTitleBackgroundColor })
				row[1]:createButton({  }):setText(isextended and "-" or "+", { halign = "center" })
				row[1].handlers.onClick = function () return menu.buttonExtendEntry("planned", row.index) end
				row[2]:setColSpan(2):setBackgroundColSpan(4):createText(ReadText(1001, 7963), Helper.subHeaderTextProperties)
				row[2].properties.color = Helper.color.green
				row[4]:setColSpan(2):createText(changedCount, Helper.subHeaderTextProperties)
				row[4].properties.halign = "right"
				prevfullheight = menu.moduleHeightHelper(ftable, prevfullheight)
				if isextended then
					for i = 1, #menu.constructionplan do
						if menu.changedModulesIndices[i] then
							local row = menu.displayModuleRow(ftable, i, menu.constructionplan[i], true, false)
							if (not menu.selectedRows.plan) then
								menu.selectedRows.plan = row.index
							end
							prevfullheight = menu.moduleHeightHelper(ftable, prevfullheight)
						end
					end
				end
			end
			menu.totalprice = GetComponentData(ConvertStringTo64Bit(tostring(menu.buildstorage)), "wantedmoney")

			if menu.selectedRows.plan == "last" then
				menu.selectedRows.plan = ftable.rows[#ftable.rows].index
			end
			if menu.selectedRows.plan == "first" then
				menu.selectedRows.plan = 2
			else
				local numdisplayedlines = math.floor((ftable:getVisibleHeight() - menu.titleData.height) / (Helper.scaleY(Helper.subHeaderHeight) + Helper.borderSize))
				if menu.topRows.plan and menu.selectedRows.plan then
					if menu.topRows.plan + numdisplayedlines - 1 < menu.selectedRows.plan then
						menu.topRows.plan = menu.selectedRows.plan - numdisplayedlines + 3
					elseif menu.selectedRows.plan < menu.topRows.plan then
						menu.topRows.plan = menu.selectedRows.plan
					end
				elseif menu.selectedRows.plan then
					menu.topRows.plan = menu.selectedRows.plan - numdisplayedlines + 3
				end
			end
			ftable:setTopRow(menu.topRows.plan)
			ftable:setSelectedRow(menu.selectedRows.plan)
			menu.topRows.plan = nil
			menu.selectedRows.plan = nil

			-- MODULE LOADOUTS & STATUS
			local yoffset = ftable.properties.y + ftable:getVisibleHeight() + 2 * Helper.borderSize
			modulestatustable = frame:addTable(6, { tabOrder = 4, width = menu.planData.width, x = menu.planData.offsetX, y = yoffset, reserveScrollBar = true, backgroundID = "solid", backgroundColor = Helper.color.transparent60 })
			local smallColWidth = Helper.scaleY(Helper.standardTextHeight)
			modulestatustable:setColWidth(1, smallColWidth, false)
			modulestatustable:setColWidth(2, smallColWidth, false)
			modulestatustable:setColWidth(3, 0.5 * menu.planData.width - 2 * smallColWidth, false)
			modulestatustable:setColWidth(5, 0.3 * menu.planData.width, false)
			modulestatustable:setColWidth(6, smallColWidth, false)

			-- station-wide loadout
			local row = modulestatustable:addRow(false, { bgColor = Helper.defaultTitleBackgroundColor })
			row[1]:setColSpan(6):createText(ReadText(1001, 7966), menu.headerTextProperties)
			-- selection
			local row = modulestatustable:addRow(true, { bgColor = Helper.color.transparent })
			row[1]:setColSpan(4):createText(ReadText(1001, 7967) .. ReadText(1001, 120))
			local loadoutOptions = {
				{ id = 0,	text = ReadText(1001, 7990), icon = "", displayremoveoption = false },
				{ id = 0.1,	text = ReadText(1001, 7910), icon = "", displayremoveoption = false },
				{ id = 0.5,	text = ReadText(1001, 7911), icon = "", displayremoveoption = false },
				{ id = 1.0,	text = ReadText(1001, 7912), icon = "", displayremoveoption = false },
				{ id = -1,	text = ReadText(1001, 7968), icon = "", displayremoveoption = false },
			}
			row[5]:setColSpan(2):createDropDown(loadoutOptions, { startOption = function () return tostring(menu.defaultLoadout) end }):setTextProperties({ halign = "center" })
			row[5].handlers.onDropDownConfirmed = menu.dropdownDefaultLoadout

			-- preferred build method
			local row = modulestatustable:addRow(false, { bgColor = Helper.defaultTitleBackgroundColor })
			row[1]:setColSpan(6):createText(ReadText(1001, 11298), menu.headerTextProperties)

			local cursetting = ffi.string(C.GetContainerBuildMethod(menu.buildstorage))
			local curglobalsetting = ffi.string(C.GetPlayerBuildMethod())
			local foundcursetting = false
			local locresponses = {}
			local n = C.GetNumPlayerBuildMethods()
			if n > 0 then
				local buf = ffi.new("ProductionMethodInfo[?]", n)
				n = C.GetPlayerBuildMethods(buf, n)
				for i = 0, n - 1 do
					local id = ffi.string(buf[i].id)
					-- check if the curglobalsetting (which can be the method of the player's race) is in the list of options
					if id == curglobalsetting then
						foundcursetting = true
					end
					table.insert(locresponses, { id = id, text = ffi.string(buf[i].name), icon = "", displayremoveoption = false })
				end
			end
			-- if the setting is not in the list, default to default (if the race method is not in the list, there is no ware that has this method and it will always use default)
			if not foundcursetting then
				curglobalsetting = "default"
			end
			local hasownsetting = cursetting ~= ""

			local rowdata = "info_buildrule_global"
			local row = modulestatustable:addRow({ rowdata }, { bgColor = Helper.color.transparent })
			row[1]:setColSpan(5):createText(ReadText(1001, 8367))
			row[6]:createCheckBox(not hasownsetting, { width = config.mapRowHeight, height = config.mapRowHeight })
			row[6].handlers.onClick = function(_, checked) return menu.checkboxSetBuildRuleOverride(menu.buildstorage, checked, curglobalsetting) end

			local row = modulestatustable:addRow("info_buildrule", { bgColor = Helper.color.transparent })
			row[1]:setColSpan(6):createDropDown(locresponses, { height = Helper.standardTextHeight, startOption = hasownsetting and cursetting or curglobalsetting, active = hasownsetting }):setTextProperties({ fontsize = config.mapFontSize })
			row[1].handlers.onDropDownConfirmed = function (_, id) return menu.dropdownBuildRule(menu.buildstorage, id) end
			row[1].handlers.onDropDownActivated = function () menu.noupdate = true end

			-- module status here
			local row = modulestatustable:addRow(false, { fixed = true, bgColor = Helper.defaultTitleBackgroundColor })
			row[1]:setColSpan(6):createText(ReadText(1001, 7991), menu.headerTextProperties)
		
			local infoCount = 0
			local visibleHeight
			for _, errorentry in Helper.orderedPairs(menu.criticalmoduleerrors) do
				row = modulestatustable:addRow(true, { bgColor = Helper.color.transparent })
				row[1]:setColSpan(6):createText(errorentry, { color = Helper.color.red, wordwrap = true })
			end
			for _, errorentry in Helper.orderedPairs(menu.moduleerrors) do
				row = modulestatustable:addRow(true, { bgColor = Helper.color.transparent })
				row[1]:setColSpan(6):createText(errorentry, { color = Helper.color.red, wordwrap = true })
			end
			for _, warningentry in Helper.orderedPairs(menu.modulewarnings) do
				row = modulestatustable:addRow(true, { bgColor = Helper.color.transparent })
				row[1]:setColSpan(6):createText(warningentry, { color = Helper.color.orange, wordwrap = true })
			end
			if (not next(menu.criticalmoduleerrors)) and (not next(menu.moduleerrors)) and (not next(menu.modulewarnings)) then
				row = modulestatustable:addRow(true, { bgColor = Helper.color.transparent })
				row[1]:setColSpan(6):createText(ReadText(1001, 7923), { color = Helper.color.green })
			end

			-- BUTTONS
			if menu.cancelRequested then
				local row = modulestatustable:addRow(false, { fixed = true, bgColor = Helper.defaultTitleBackgroundColor })
				row[1]:setColSpan(6):createText(ReadText(1001, 9705), menu.headerTextProperties)

				local row = modulestatustable:addRow(true, { fixed = true, bgColor = Helper.defaultTitleBackgroundColor })
				row[1]:setColSpan(3):createButton({  }):setText(ReadText(1001, 2617), { halign = "center" })
				row[1].handlers.onClick = menu.buttonCancelConfirm
				row[4]:setColSpan(3):createButton({  }):setText(ReadText(1001, 2618), { halign = "center" })
				row[4].handlers.onClick = menu.buttonCancelCancel
			else
				local row = modulestatustable:addRow(true, { fixed = true, bgColor = Helper.defaultTitleBackgroundColor })
				if (ffi.string(C.GetGameStartName()) == "x4ep1_gamestart_workshop") and (not menu.confirmModuleChangesActive()) and ((C.GetCurrentBuildProgress(menu.container) >= 0) or C.IsBuildWaitingForSecondaryComponentResources(menu.container)) then
					row[1]:setColSpan(3):createButton({ helpOverlayID = "force_modulechanges", helpOverlayText = " ",  helpOverlayHighlightOnly = true, active = true }):setText(ReadText(1001, 11919), { halign = "center" })
					row[1].handlers.onClick = menu.buttonForceBuild
				else
					row[1]:setColSpan(3):createButton({ helpOverlayID = "confirm_modulechanges", helpOverlayText = " ",  helpOverlayHighlightOnly = true, active = menu.confirmModuleChangesActive }):setText(ReadText(1001, 7919), { halign = "center" })
					row[1].handlers.onClick = menu.buttonConfirm
					row[1].properties.uiTriggerID = "confirmmodulechanges"
				end
				row[4]:setColSpan(3):createButton({ helpOverlayID = "cancel_modulechanges", helpOverlayText = " ",  helpOverlayHighlightOnly = true, active = menu.haschanges }):setText(ReadText(1001, 7918), { halign = "center" })
				row[4].handlers.onClick = menu.buttonCancel
				row[4].properties.uiTriggerID = "cancelmodulechanges"
			end

			-- BUILD RESOURCES
			local yoffset = modulestatustable.properties.y + modulestatustable:getVisibleHeight() + 2 * Helper.borderSize
			resourcetable = frame:addTable(6, { tabOrder = 5, width = menu.planData.width, x = menu.planData.offsetX, y = yoffset, reserveScrollBar = true, backgroundID = "solid", backgroundColor = Helper.color.transparent60 })
			resourcetable:setColWidth(1, smallColWidth, false)
			resourcetable:setColWidth(2, smallColWidth, false)
			resourcetable:setColWidth(3, 0.5 * menu.planData.width - 2 * smallColWidth, false)
			resourcetable:setColWidth(5, 0.3 * menu.planData.width, false)
			resourcetable:setColWidth(6, smallColWidth, false)

			menu.tradewares = {}
			local n = C.GetNumWares("stationbuilding", false, "", "")
			local buf = ffi.new("const char*[?]", n)
			n = C.GetWares(buf, n, "stationbuilding", false, "", "")
			for i = 0, n - 1 do
				table.insert(menu.tradewares, { ware = ffi.string(buf[i]) })
			end

			-- resources
			local row = resourcetable:addRow(false, { bgColor = Helper.defaultTitleBackgroundColor })
			row[1]:setColSpan(6):createText(ReadText(1001, 7925), menu.headerTextProperties)
			-- have
			local row = resourcetable:addRow(true, { bgColor = Helper.defaultTitleBackgroundColor })
			if not menu.selectedRows.planresources then
				menu.selectedRows.planresources = row.index
			end
			local isextended = menu.isResourceEntryExtended("buildstorage")
			row[1]:createButton({ helpOverlayID = "plot_resources_available", helpOverlayText = " ",  helpOverlayHighlightOnly = true  }):setText(isextended and "-" or "+", { halign = "center" })
			row[1].handlers.onClick = function () return menu.buttonExtendResourceEntry("buildstorage", row.index) end
			row[2]:setColSpan(5):createText(ReadText(1001, 7927) .. (menu.newWareReservation and " \27G[+" .. menu.newWareReservation .. "]" or ""), Helper.subHeaderTextProperties)

			if isextended then
				-- reservations
				local reservations = {}
				local n = C.GetNumContainerWareReservations2(menu.buildstorage, false, false, true)
				local buf = ffi.new("WareReservationInfo2[?]", n)
				n = C.GetContainerWareReservations2(buf, n, menu.buildstorage, false, false, true)
				for i = 0, n - 1 do
					local ware = ffi.string(buf[i].ware)
					local tradedeal = buf[i].tradedealid
					if not menu.dirtyreservations[tostring(tradedeal)] then
						if reservations[ware] then
							table.insert(reservations[ware], { reserver = buf[i].reserverid, amount = buf[i].amount, eta = buf[i].eta, tradedeal = tradedeal })
						else
							reservations[ware] = { { reserver = buf[i].reserverid, amount = buf[i].amount, eta = buf[i].eta, tradedeal = tradedeal } }
						end
					end
				end
				for _, data in pairs(reservations) do
					table.sort(data, menu.etaSorter)
				end

				local resources = {}
				for _, resource in ipairs(menu.neededresources) do
					if resource.amount > 0 then
						local current = 0
						local idx = menu.findWareIdx(menu.buildstorageresources, resource.ware)
						if idx then
							current =  menu.buildstorageresources[idx].amount
						end

						local reserved = 0
						if reservations[resource.ware] then
							for _, reservation in ipairs(reservations[resource.ware]) do
								reserved = reserved + reservation.amount
							end
						end

						table.insert(resources, { ware = resource.ware, name = GetWareData(resource.ware, "name"), needed = resource.amount, current = current, reserved = reserved })
					end
				end
				for _, resource in ipairs(menu.buildstorageresources) do
					local idx = menu.findWareIdx(resources, resource.ware)
					if not idx then
						local needed = 0
						local idx = menu.findWareIdx(menu.neededresources, resource.ware)
						if idx then
							needed =  menu.neededresources[idx].amount
						end

						local reserved = 0
						if reservations[resource.ware] then
							for _, reservation in ipairs(reservations[resource.ware]) do
								reserved = reserved + reservation.amount
							end
						end

						table.insert(resources, { ware = resource.ware, name = GetWareData(resource.ware, "name"), needed = needed, current = resource.amount, reserved = reserved })
					end
				end
				for ware, reservationentry in pairs(reservations) do
					local idx = menu.findWareIdx(resources, ware)
					if not idx then
						local current = 0
						local idx = menu.findWareIdx(menu.buildstorageresources, ware)
						if idx then
							current =  menu.buildstorageresources[idx].amount
						end

						local needed = 0
						local idx = menu.findWareIdx(menu.neededresources, ware)
						if idx then
							needed =  menu.neededresources[idx].amount
						end

						local reserved = 0
						if reservationentry then
							for _, reservation in ipairs(reservations[ware]) do
								reserved = reserved + reservation.amount
							end
						end

						table.insert(resources, { ware = ware, name = GetWareData(ware, "name"), needed = needed, current = current, reserved = reserved })
					end
				end
				table.sort(resources, Helper.sortName)

				for i, resource in ipairs(resources) do
					local row = resourcetable:addRow(true, { bgColor = Helper.color.transparent })
					local xoffset = row[1]:getWidth() + row[2]:getWidth() + row[3]:getWidth() + 3 * Helper.borderSize
					statusBars[i] = row[1]:createStatusBar({ current = resource.current + resource.reserved, start = resource.current, max = resource.needed, cellBGColor = Helper.color.transparent, valueColor = Helper.defaultSliderCellValueColor, posChangeColor = Helper.defaultSimpleBackgroundColor, width = menu.planData.width - xoffset, x = xoffset, scaling = false })
					row[2]:setColSpan(2):createText(GetWareData(resource.ware, "name"))
					row[4]:setColSpan(3):createText(((resource.current < resource.needed) and "\27R" or "") .. ConvertIntegerString(resource.current, true, 0, true) .. "\27X" .. ((resource.reserved > 0) and (" (\27G+" .. ConvertIntegerString(resource.reserved, true, 0, true) .. "\27X)") or "") .. " / " .. ConvertIntegerString(resource.needed, true, 0, true), { halign = "right", cellBGColor = Helper.color.darkgrey })
				end

				menu.newWareReservation = nil
				if next(reservations) then
					local row = resourcetable:addRow(true, { bgColor = Helper.color.transparent })
					row[1]:setColSpan(6):createText(ReadText(1001, 7946), Helper.subHeaderTextProperties)
					row[1].properties.halign = "center"
					for _, ware in ipairs(menu.tradewares) do
						if reservations[ware.ware] then
							local isextended = menu.isResourceEntryExtended("reservation" .. ware.ware, true)
							local titlerow = resourcetable:addRow(true, { bgColor = Helper.color.transparent })
							titlerow[1]:createButton({  }):setText(isextended and "-" or "+", { halign = "center" })
							titlerow[1].handlers.onClick = function () return menu.buttonExtendResourceEntry("reservation" .. ware.ware, titlerow.index) end
							local color = Helper.color.white
							if menu.newWareReservationWares[ware.ware] then
								color = Helper.color.green
							end
							titlerow[2]:setColSpan(3):createText(GetWareData(ware.ware, "name"), { color = color })
							local total = 0
							for _, reservation in ipairs(reservations[ware.ware]) do
								total = total + reservation.amount
								if isextended then
									local row = resourcetable:addRow(true, { bgColor = Helper.color.transparent })
									local reserverid = ConvertStringTo64Bit(tostring(reservation.reserver))
									local name = ffi.string(C.GetComponentName(reservation.reserver)) .. " (" .. ffi.string(C.GetObjectIDCode(reservation.reserver)) .. ")"
									local colorprefix = GetComponentData(reserverid, "isplayerowned") and "\27G" or ""

									-- kuertee start: callback
									-- row[2]:setColSpan(3):createText(function () return Helper.getETAString(colorprefix .. name, reservation.eta) end, { font = Helper.standardFontMono })
									if callbacks ["displayPlan_render_incoming_ware"] then
										for _, callback in ipairs (callbacks ["displayPlan_render_incoming_ware"]) do
											isbreak = callback (row, colorprefix, name, reservation)
											if isbreak then
												break
											end
										end
									end
									-- kuertee end: callback

									local color = Helper.color.white
									if menu.newWareReservationWares[ware.ware] and menu.newWareReservationWares[ware.ware][tostring(reserverid)] then
										color = Helper.color.green
									end
									row[5]:createText(ConvertIntegerString(reservation.amount, true, 0, false), { halign = "right", color = color })
									row[6]:createButton({ active = function () return C.CancelPlayerInvolvedTradeDeal(menu.container, reservation.tradedeal, true) end, mouseOverText = ReadText(1026, 7924) }):setText("X", { halign = "center" })
									row[6].handlers.onClick = function () return menu.buttonCancelTrade(reservation.tradedeal) end
								end
							end
							titlerow[5]:setColSpan(2):createText(ConvertIntegerString(total, true, 0, false), { halign = "right" })
						end
					end
				end
				resourcetable:addEmptyRow(Helper.standardTextHeight / 2)
				menu.newWareReservationWares = {}
			end

			-- config
			local row = resourcetable:addRow(true, { bgColor = Helper.defaultTitleBackgroundColor })
			local isextended = menu.isResourceEntryExtended("resourceconfig")
			row[1]:createButton({ helpOverlayID = "plot_resources_buyoffers", helpOverlayText = " ",  helpOverlayHighlightOnly = true }):setText(isextended and "-" or "+", { halign = "center" })
			row[1].handlers.onClick = function () return menu.buttonExtendResourceEntry("resourceconfig", row.index) end
			row[1].properties.uiTriggerID = "extendresourceentry"
			row[2]:setColSpan(5):createText(ReadText(1001, 7928), Helper.subHeaderTextProperties)
			if isextended then
				local row = resourcetable:addRow(false, { bgColor = Helper.color.transparent })
				row[2]:setColSpan(5):createText(ReadText(1001, 7944), Helper.subHeaderTextProperties)
				row[2].properties.halign = "center"

				-- trade rule
				local hasownlist = C.HasContainerOwnTradeRule(menu.buildstorage, "buy", "") or C.HasContainerOwnTradeRule(menu.buildstorage, "sell", "")
				local traderuleid = C.GetContainerTradeRuleID(menu.buildstorage, "buy", "")
				if traderuleid ~= C.GetContainerTradeRuleID(menu.buildstorage, "sell", "") then
					DebugError("Mismatch between buy and sell trade rule on supply ship: " .. tostring(traderuleid) .. " vs " .. tostring(C.GetContainerTradeRuleID(menu.buildstorage, "sell", "")))
				end
				local row = resourcetable:addRow(nil, { bgColor = Helper.color.unselectable })
				row[1].properties.cellBGColor = Helper.color.transparent
				row[2]:setColSpan(5):createText(ReadText(1001, 11013) .. ReadText(1001, 120), textproperties)
				-- global
				local row = resourcetable:addRow("order_wares_global", { bgColor = Helper.color.transparent })
				row[2]:setColSpan(4):createText(ReadText(1001, 8367) .. ReadText(1001, 120), textproperties)
				row[6]:createCheckBox(not hasownlist, { height = config.mapRowHeight })
				row[6].handlers.onClick = function(_, checked) return menu.checkboxSetTradeRuleOverride(menu.buildstorage, "trade", checked) end
				-- current
				local row = resourcetable:addRow("order_wares_current", { bgColor = Helper.color.transparent })
				row[2]:setColSpan(4):createDropDown(Helper.traderuleOptions, { startOption = (traderuleid ~= 0) and traderuleid or -1, active = hasownlist }):setTextProperties({ fontsize = config.mapFontSize })
				row[2].handlers.onDropDownConfirmed = function (_, id) return menu.dropdownTradeRule(menu.buildstorage, "trade", id, "", true) end
				row[2].handlers.onSliderCellActivated = function() menu.noupdate = true end
				row[2].handlers.onSliderCellDeactivated = function() menu.noupdate = false end
				row[6]:createButton({ mouseOverText = ReadText(1026, 8407) }):setIcon("menu_edit")
				row[6].handlers.onClick = menu.buttonEditTradeRule

				resourcetable:addEmptyRow()

				-- global price modifier
				local row = resourcetable:addRow(true, { bgColor = Helper.color.transparent })
				menu.globalpricefactor = C.GetContainerGlobalPriceFactor(menu.buildstorage)
				local hasvalidmodifier = menu.globalpricefactor >= 0
				row[2]:createCheckBox(hasvalidmodifier, { })
				row[2].handlers.onClick = menu.checkboxToggleGlobalWarePriceModifier
				row[3]:setColSpan(4):createText(ReadText(1001, 7945))
				local row = resourcetable:addRow(true, { bgColor = Helper.color.transparent })
				local currentfactor = menu.globalpricefactor * 100
				row[2]:setColSpan(5):createSliderCell({ height = Helper.standardTextHeight, valueColor = hasvalidmodifier and Helper.color.slidervalue or Helper.color.grey, min = 0, max = 100, start = hasvalidmodifier and currentfactor or 100, suffix = "%", readOnly = not hasvalidmodifier, hideMaxValue = true }):setText(ReadText(1001, 2808))
				row[2].handlers.onSliderCellChanged = function (_, ...) return menu.slidercellGlobalWarePriceFactor(row.index, ...) end
				row[2].handlers.onSliderCellActivated = function() menu.noupdate = true end
				row[2].handlers.onSliderCellDeactivated = function() menu.noupdate = false end
				-- trade restrictions
				local row = resourcetable:addRow(false, { bgColor = Helper.color.transparent })
				row[2]:setColSpan(5):createText(ReadText(1001, 7931), Helper.subHeaderTextProperties)
				row[2].properties.halign = "center"

				for i, ware in ipairs(menu.tradewares) do
					local isextended = menu.isResourceEntryExtended("resourceconfig" .. ware.ware)
					local row = resourcetable:addRow(true, { bgColor = Helper.color.transparent })
					row[2]:createButton({ helpOverlayID = "plot_resources_resourceconfig" .. ware.ware, helpOverlayText = " ",  helpOverlayHighlightOnly = true }):setText(isextended and "-" or "+", { halign = "center" })
					row[2].handlers.onClick = function () return menu.buttonExtendResourceEntry("resourceconfig" .. ware.ware, row.index) end
					row[2].properties.uiTriggerID = "extendresourceentry" .. ware.ware
					
					-- kuertee start: callback
					-- row[3]:setColSpan(2):createText(GetWareData(ware.ware, "name"))
					if callbacks ["displayPlan_getWareName"] then
						local name
						for _, callback in ipairs (callbacks ["displayPlan_getWareName"]) do
							name = callback (ware.ware, name)
						end
						if name then
							row[3]:setColSpan(2):createText(name)
						else
							row[3]:setColSpan(2):createText(GetWareData(ware.ware, "name"))
						end
					end
					-- kuertee end: callback

					if C.GetContainerTradeRuleID(menu.buildstorage, "buy", ware.ware) > 0 then
						row[5]:setColSpan(2):createText("\27[lso_error]", { halign = "right", color = Helper.color.warningorange, mouseOverText = ReadText(1026, 8404) })
					end
				
					ware.minprice, ware.maxprice = GetWareData(ware.ware, "minprice", "maxprice")
					if isextended then
						-- trade rule
						local hasownlist = C.HasContainerOwnTradeRule(menu.buildstorage, "buy", ware.ware) or C.HasContainerOwnTradeRule(menu.buildstorage, "sell", ware.ware)
						local traderuleid = C.GetContainerTradeRuleID(menu.buildstorage, "buy", ware.ware)
						if traderuleid ~= C.GetContainerTradeRuleID(menu.buildstorage, "sell", ware.ware) then
							DebugError("Mismatch between buy and sell trade rule on supply ship: " .. tostring(traderuleid) .. " vs " .. tostring(C.GetContainerTradeRuleID(menu.buildstorage, "sell", ware.ware)))
						end
						local row = resourcetable:addRow(nil, { bgColor = Helper.color.unselectable })
						row[1].properties.cellBGColor = Helper.color.transparent
						row[2].properties.cellBGColor = Helper.color.transparent
						row[3]:setColSpan(4):createText(ReadText(1001, 11013) .. ReadText(1001, 120), textproperties)
						-- global
						local row = resourcetable:addRow("order_wares_global", { bgColor = Helper.color.transparent })
						row[3]:setColSpan(3):createText(ReadText(1001, 11033) .. ReadText(1001, 120), textproperties)
						row[6]:createCheckBox(not hasownlist, { height = config.mapRowHeight })
						row[6].handlers.onClick = function(_, checked) return menu.checkboxSetTradeRuleOverride(menu.buildstorage, "trade", checked, ware.ware) end
						-- current
						local row = resourcetable:addRow("order_wares_current", { bgColor = Helper.color.transparent })
						row[3]:setColSpan(3):createDropDown(Helper.traderuleOptions, { startOption = (traderuleid ~= 0) and traderuleid or -1, active = hasownlist }):setTextProperties({ fontsize = config.mapFontSize })
						row[3].handlers.onDropDownConfirmed = function (_, id) return menu.dropdownTradeRule(menu.buildstorage, "trade", id, ware.ware, true) end
						row[3].handlers.onSliderCellActivated = function() menu.noupdate = true end
						row[3].handlers.onSliderCellDeactivated = function() menu.noupdate = false end
						row[6]:createButton({ mouseOverText = ReadText(1026, 8407) }):setIcon("menu_edit")
						row[6].handlers.onClick = menu.buttonEditTradeRule

						resourcetable:addEmptyRow(Helper.standardTextHeight / 2)

						local row = resourcetable:addRow(true, { bgColor = Helper.color.transparent })
						ware.row = row.index
						local currentprice = math.max(ware.minprice, math.min(ware.maxprice, GetContainerWarePrice(menu.buildstorage, ware.ware, true, true)))
						row[3]:setColSpan(4):createSliderCell({ height = Helper.standardTextHeight, valueColor = Helper.color.slidervalue, min = ware.minprice, max = ware.maxprice, start = currentprice, suffix = ReadText(1001, 101), readOnly = restricted, hideMaxValue = true }):setText(ReadText(1001, 2808))
						row[3].handlers.onSliderCellChanged = function (_, ...) return menu.slidercellWarePriceOverride(ware.ware, row.index, ...) end
						row[3].handlers.onSliderCellActivated = function() menu.noupdate = true end
						row[3].handlers.onSliderCellDeactivated = function() menu.noupdate = false end

						if i ~= #menu.tradewares then
							resourcetable:addEmptyRow()
						end
					end
				end
				-- price
				local row = resourcetable:addRow(false, { bgColor = Helper.color.transparent })
				row[2]:setColSpan(5):createText(ReadText(1001, 7929), Helper.subHeaderTextProperties)
				row[2].properties.halign = "center"
				local row = resourcetable:addRow(true, { bgColor = Helper.color.transparent })
				row[2]:setColSpan(5):createText(ConvertMoneyString(menu.totalprice, false, true, 0, true) .. " " .. ReadText(1001, 101), { halign = "right" })
				-- account
				local row = resourcetable:addRow(false, { bgColor = Helper.color.transparent })
				row[2]:setColSpan(5):createText(ReadText(1001, 7930), Helper.subHeaderTextProperties)
				row[2].properties.halign = "center"
				row[2].properties.helpOverlayID = "construction_available_funds"
				row[2].properties.helpOverlayText = " "
				row[2].properties.helpOverlayHighlightOnly = true
				local row = resourcetable:addRow(true, { bgColor = Helper.color.transparent })
				local buildstoragemoney = GetComponentData(ConvertStringTo64Bit(tostring(menu.buildstorage)), "money")
				local playermoney = GetPlayerMoney()
				local min = 0
				local max = buildstoragemoney + playermoney
				local start = math.max(min, math.min(max, menu.newAccountValue or buildstoragemoney))
				row[2]:setColSpan(5):createSliderCell({ height = Helper.standardTextHeight, valueColor = Helper.color.slidervalue, min = min, max = max, start = start, suffix = ReadText(1001, 101), hideMaxValue = true })
				row[2].handlers.onSliderCellChanged = menu.slidercellMoney
				row[2].handlers.onSliderCellActivated = function() menu.noupdate = true end
				row[2].handlers.onSliderCellDeactivated = function() menu.noupdate = false end
				local row = resourcetable:addRow(true, { bgColor = Helper.color.transparent })
				row[2]:setColSpan(3):createButton({ helpOverlayID = "confirm_credits", helpOverlayText = " ", helpOverlayHighlightOnly = true, active = function () return (menu.newAccountValue ~= nil) and (menu.newAccountValue ~= buildstoragemoney) and GetComponentData(ConvertStringTo64Bit(tostring(menu.buildstorage)), "isplayerowned") end }):setText(ReadText(1001, 2821), { halign = "center" })
				row[2].handlers.onClick = menu.buttonConfirmMoney
				row[2].properties.uiTriggerID = "confirmcredits"
				row[5]:setColSpan(2):createButton({ active = function () local money, isplayerowned = GetComponentData(ConvertStringTo64Bit(tostring(menu.buildstorage)), "money", "isplayerowned"); return ((money + GetPlayerMoney()) > menu.totalprice) and isplayerowned end }):setText(ReadText(1001, 7965), { halign = "center" })
				row[5].handlers.onClick = menu.buttonSetMoneyToEstimate
			end

			-- CVs
			local row = resourcetable:addRow(false, { bgColor = Helper.defaultTitleBackgroundColor })
			row[1]:setColSpan(6):createText(ReadText(1001, 7932), menu.headerTextProperties)
			row[1].properties.halign = "center"
			row[1].properties.helpOverlayID = "construction_builders_header"
			row[1].properties.helpOverlayText = " "
			row[1].properties.helpOverlayHighlightOnly = true

			if #menu.constructionvessels > 0 then
				for _, component in ipairs(menu.constructionvessels) do
					row = resourcetable:addRow(true, { bgColor = Helper.color.transparent })
					row[1]:setColSpan(6):createText(ffi.string(C.GetComponentName(component)) .. " (" .. ffi.string(C.GetObjectIDCode(component)) .. ")")
				end
			else
				row = resourcetable:addRow(true, { bgColor = Helper.color.transparent })
				row[1]:setColSpan(6):createText(ReadText(1001, 7933))
			end
			row = resourcetable:addRow(true, { bgColor = Helper.color.transparent })
			if #menu.constructionvessels == 0 then
				local active = C.DoesConstructionSequenceRequireBuilder(menu.container)
				row[1]:setColSpan(6):createButton({ active = active, helpOverlayID = "assign_hire_builder", helpOverlayText = " ",  helpOverlayHighlightOnly = true, mouseOverText = active and "" or ReadText(1026, 7923) }):setText(ReadText(1001, 7934), { halign = "center" })
				row[1].handlers.onClick = menu.buttonAssignConstructionVessel
				row[1].properties.uiTriggerID = "assignhirebuilder"
			else
				local deployorderidx
				local numorders = C.GetNumOrders(menu.constructionvessels[1])
				local currentorders = ffi.new("Order[?]", numorders)
				numorders = C.GetOrders(currentorders, numorders, menu.constructionvessels[1])
				for i = 1, numorders do
					if ffi.string(currentorders[i - 1].orderdef) == "DeployToStation" then
						deployorderidx = i
						break
					end
				end

				row[1]:setColSpan(5):createButton({ active = (deployorderidx ~= nil) and C.RemoveOrder2(menu.constructionvessels[1], deployorderidx, true, true, true) }):setText(ReadText(1001, 7961), { halign = "center" })
				row[1].handlers.onClick = function () return menu.buttonFireConstructionVessel(menu.constructionvessels[1], deployorderidx) end
				row[1].properties.uiTriggerID = "firebuilder"
			end

			resourcetable:setTopRow(menu.topRows.planresources)
			resourcetable:setSelectedRow(menu.selectedRows.planresources)
			menu.topRows.planresources = nil
			menu.selectedRows.planresources = nil
		end

		-- STATUS
		local statustable = frame:addTable(2, { tabOrder = 6, width = menu.planData.width, x = menu.planData.offsetX, y = 0, reserveScrollBar = false, highlightMode = "off", skipTabChange = true, backgroundID = "solid", backgroundColor = Helper.color.transparent60 })
		statustable:setDefaultColSpan(1, 2)

		local row = statustable:addRow(false, { fixed = true, bgColor = Helper.defaultTitleBackgroundColor })
		row[1]:createText(ReadText(1001, 7922), menu.headerTextProperties)
		
		for _, errorentry in Helper.orderedPairs(menu.criticalerrors) do
			row = statustable:addRow(true, { bgColor = Helper.color.transparent })
			row[1]:createText(errorentry, { color = Helper.color.red, wordwrap = true })
		end
		for _, errorentry in Helper.orderedPairs(menu.errors) do
			row = statustable:addRow(true, { bgColor = Helper.color.transparent })
			row[1]:createText(errorentry, { color = Helper.color.red, wordwrap = true })
		end
		for _, warningentry in Helper.orderedPairs(menu.warnings) do
			row = statustable:addRow(true, { bgColor = Helper.color.transparent })
			row[1]:createText(warningentry, { color = Helper.color.orange, wordwrap = true })
		end
		if (not next(menu.criticalerrors)) and (not next(menu.errors)) and (not next(menu.warnings)) then
			row = statustable:addRow(true, { bgColor = Helper.color.transparent })
			row[1]:createText(ReadText(1001, 7923), { color = Helper.color.green })
		end

		local row = statustable:addRow(true, { bgColor = Helper.color.transparent })
		row[1]:setColSpan(1)
		row[2]:createButton({  }):setText(ReadText(1001, 8035), { halign = "center" })
		row[2].handlers.onClick = function () menu.modulesMode = nil; return menu.onCloseElement("back") end

		statustable.properties.y = Helper.viewHeight - statustable:getFullHeight() - Helper.frameBorder
		if menu.planMode == "construction" then
			resourcetable.properties.maxVisibleHeight = statustable.properties.y - resourcetable.properties.y - 2 * Helper.borderSize
			if resourcetable.properties.maxVisibleHeight < resourcetable:getFullHeight() then
				for _, statusbar in ipairs(statusBars) do
					statusbar.properties.width = statusbar.properties.width - Helper.scrollbarWidth
				end
			end

			ftable:addConnection(1, 4, true)
			modulestatustable:addConnection(2, 4)
			resourcetable:addConnection(3, 4)
			statustable:addConnection(4, 4)
		else
			statustable:addConnection(1, 4, true)
		end
	else
		-- BUTTONS
		local buttontable = frame:addTable(2, { tabOrder = 7, width = menu.planData.width, height = Helper.scaleY(Helper.standardButtonHeight), x = menu.planData.offsetX, y = Helper.viewHeight - Helper.scaleY(Helper.standardButtonHeight) - Helper.frameBorder, reserveScrollBar = false, backgroundID = "solid", backgroundColor = Helper.color.transparent60 })
		if menu.cancelRequested then
			local row = buttontable:addRow(false, { fixed = true, bgColor = Helper.defaultTitleBackgroundColor })
			row[1]:setColSpan(2):createText(ReadText(1001, 9705), menu.headerTextProperties)

			local row = buttontable:addRow(true, { fixed = true, bgColor = Helper.defaultTitleBackgroundColor })
			row[1]:createButton({  }):setText(ReadText(1001, 2617), { halign = "center" })
			row[1].handlers.onClick = menu.buttonCancelLoadout
			row[2]:createButton({  }):setText(ReadText(1001, 2618), { halign = "center" })
			row[2].handlers.onClick = menu.buttonCancelCancel
		else
			local row = buttontable:addRow(true, { fixed = true, bgColor = Helper.defaultTitleBackgroundColor })
			row[1]:createButton({  }):setText(ReadText(1001, 7921), { halign = "center" })
			row[1].handlers.onClick = menu.buttonConfirmLoadout
			row[2]:createButton({  }):setText(ReadText(1001, 7920), { halign = "center" })
			row[2].handlers.onClick = menu.buttonCancel
		end
		buttontable.properties.y = Helper.viewHeight - buttontable:getFullHeight() - Helper.frameBorder

		if menu.loadoutPlanMode == "normal" then
			-- EQUIPMENT
			local ftable = frame:addTable(5, { tabOrder = 3, width = menu.planData.width, maxVisibleHeight = buttontable.properties.y - menu.planData.offsetY, x = menu.planData.offsetX, y = menu.planData.offsetY, reserveScrollBar = true, skipTabChange = true, highlightMode = "off", backgroundID = "solid", backgroundColor = Helper.color.transparent60 })
			ftable:setColWidth(1, Helper.standardTextHeight)
			ftable:setColWidth(2, Helper.standardTextHeight)
			ftable:setColWidth(4, 0.3 * menu.planData.width)
			ftable:setColWidth(5, Helper.standardTextHeight)

			local row = ftable:addRow(false, { bgColor = Helper.defaultTitleBackgroundColor })
			row[1]:setColSpan(5):createText(ReadText(1001, 7935), menu.headerTextProperties)

			local removedEquipment = {}
			local currentEquipment = {}
			local newEquipment = {}
			for i, upgradetype in ipairs(Helper.upgradetypes) do
				local slots = menu.constructionplan[menu.loadoutMode].upgradeplan[upgradetype.type]
				local first = true
				for slot, macro in pairs(slots) do
					if first or (not upgradetype.mergeslots) then
						first = false
						if upgradetype.supertype == "group" then
							local data = macro
							local oldslotdata = menu.groups[slot][upgradetype.grouptype]

							if data.macro ~= "" then
								local i = menu.findUpgradeMacro(upgradetype.grouptype, data.macro)
								if not i then
									break
								end
								local upgradeware = menu.upgradewares[upgradetype.grouptype][i]

								if oldslotdata.currentmacro ~= "" then
									local j = menu.findUpgradeMacro(upgradetype.grouptype, oldslotdata.currentmacro)
									if not j then
										break
									end
									local oldupgradeware = menu.upgradewares[upgradetype.grouptype][j]

									if data.macro == oldslotdata.currentmacro then
										if upgradetype.mergeslots then
											menu.insertWare(currentEquipment, upgradeware.ware, (upgradetype.mergeslots and #slots or data.count))
										else
											if oldslotdata.count < data.count then
												menu.insertWare(currentEquipment, upgradeware.ware, oldslotdata.count)
												menu.insertWare(newEquipment, upgradeware.ware, data.count - oldslotdata.count)
											elseif oldslotdata.count > data.count then
												menu.insertWare(currentEquipment, upgradeware.ware, data.count)
												menu.insertWare(removedEquipment, upgradeware.ware, oldslotdata.count - data.count)
											else
												menu.insertWare(currentEquipment, upgradeware.ware, (upgradetype.mergeslots and #slots or data.count))
											end
										end
									else
										menu.insertWare(removedEquipment, oldupgradeware.ware, (upgradetype.mergeslots and #slots or oldslotdata.count))
										menu.insertWare(newEquipment, upgradeware.ware, (upgradetype.mergeslots and #slots or data.count))
									end
								else
									menu.insertWare(newEquipment, upgradeware.ware, (upgradetype.mergeslots and #slots or data.count))
								end
							elseif oldslotdata.currentmacro ~= "" then
								local j = menu.findUpgradeMacro(upgradetype.grouptype, oldslotdata.currentmacro)
								if not j then
									break
								end
								local oldupgradeware = menu.upgradewares[upgradetype.grouptype][j]

								menu.insertWare(removedEquipment, oldupgradeware.ware, (upgradetype.mergeslots and #slots or oldslotdata.count))
							end
						end
					end
				end
			end

			if (#removedEquipment > 0) or (#newEquipment > 0) then
				menu.haschanges = true
			else
				menu.haschanges = false
			end

			if (#removedEquipment > 0) or (#currentEquipment > 0) or (#newEquipment > 0) then
				for _, entry in ipairs(removedEquipment) do
					row = ftable:addRow(true, { bgColor = Helper.color.transparent })
					row[1]:setColSpan(5):createText(entry.amount .. ReadText(1001, 42) .. " " .. GetWareData(entry.ware, "name"), { color = Helper.color.red })
				end
				for _, entry in ipairs(currentEquipment) do
					row = ftable:addRow(true, { bgColor = Helper.color.transparent })
					row[1]:setColSpan(5):createText(entry.amount .. ReadText(1001, 42) .. " " .. GetWareData(entry.ware, "name"))
				end
				for _, entry in ipairs(newEquipment) do
					row = ftable:addRow(true, { bgColor = Helper.color.transparent })
					row[1]:setColSpan(5):createText(entry.amount .. ReadText(1001, 42) .. " " .. GetWareData(entry.ware, "name"), { color = Helper.color.green })
				end
			else
				row = ftable:addRow(true, { bgColor = Helper.color.transparent })
				row[1]:setColSpan(5):createText("--- " .. ReadText(1001, 7936) .. " ---", { halign = "center" } )
			end

			ftable:addConnection(1, 4, true)
			buttontable:addConnection(2, 4)
		else
			buttontable:addConnection(1, 4, true)
		end
	end
end
init ()
