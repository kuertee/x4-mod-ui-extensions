local config = {
	infoFrameLayer = 4,
	contextFrameLayer = 3,

	leftBar = {
		{ name = ReadText(1001, 3224),	icon = "mapst_objectlist",			mode = "objectlist",	helpOverlayID = "map_sidebar_objectlist",			helpOverlayText = ReadText(1028, 3201) },
		{ name = ReadText(1001, 1000),	icon = "mapst_propertyowned",		mode = "propertyowned",	helpOverlayID = "map_sidebar_propertyowned",		helpOverlayText = ReadText(1028, 3203) },
		{ spacing = true },
		{ name = ReadText(1001, 3324),	icon = "mapst_mission_offers",		mode = "missionoffer",	helpOverlayID = "map_sidebar_mission_offers",		helpOverlayText = ReadText(1028, 3205) },
		{ name = ReadText(1001, 3323),	icon = "mapst_mission_accepted",	mode = "mission",		helpOverlayID = "map_sidebar_mission_accepted",		helpOverlayText = ReadText(1028, 3207) },
		{ spacing = true },
		{ name = ReadText(1001, 2427),	icon = "mapst_information",			mode = "info",			helpOverlayID = "map_sidebar_information",			helpOverlayText = ReadText(1028, 3209) },
		{ spacing = true },
		{ name = ReadText(1001, 3226),	icon = "mapst_plotmanagement",		mode = "plots",			helpOverlayID = "map_sidebar_plotmanagement",		helpOverlayText = ReadText(1028, 3211) },
		{ spacing = true,																			condition = IsCheatVersion }, -- (cheats only)
		{ name = "Cheats",				icon = "mapst_cheats",				mode = "cheats",		condition = IsCheatVersion }, -- (cheats only)
	},
	propertyCategories = {
		{ category = "propertyall",				name = ReadText(1001, 8380),	icon = "mapst_propertyowned",		helpOverlayID = "mapst_po_propertyowned",		helpOverlayText = ReadText(1028, 3220) },
		{ category = "stations",				name = ReadText(1001, 8379),	icon = "mapst_ol_stations",			helpOverlayID = "mapst_po_stations",			helpOverlayText = ReadText(1028, 3221) },
		{ category = "fleets",					name = ReadText(1001, 8326),	icon = "mapst_ol_fleets",			helpOverlayID = "mapst_po_fleets",				helpOverlayText = ReadText(1028, 3223) },
		{ category = "unassignedships",			name = ReadText(1001, 8327),	icon = "mapst_ol_unassigned",		helpOverlayID = "mapst_po_unassigned",			helpOverlayText = ReadText(1028, 3224) },
		{ category = "inventoryships",			name = ReadText(1001, 8381),	icon = "mapst_ol_inventory",		helpOverlayID = "mapst_po_inventory",			helpOverlayText = ReadText(1028, 3225) },
		{ category = "deployables",				name = ReadText(1001, 1332),	icon = "mapst_ol_deployables",		helpOverlayID = "mapst_po_deployables",			helpOverlayText = ReadText(1028, 3226) },
	},

	layers = {
		{ name = ReadText(1001, 3252),	icon = "mapst_fs_trade",		mode = "layer_trade",		helpOverlayID = "layer_trade",		helpOverlayText = ReadText(1028, 3214)  },
		{ name = ReadText(1001, 8329),	icon = "mapst_fs_mining",		mode = "layer_mining",		helpOverlayID = "layer_mining",		helpOverlayText = ReadText(1028, 3216)  },
		{ name = ReadText(1001, 3254),	icon = "mapst_fs_other",		mode = "layer_other",		helpOverlayID = "layer_other",		helpOverlayText = ReadText(1028, 3217)  },
	},

	layersettings = {
		["layer_trade"] = {
			callback = function (value) return C.SetMapRenderTradeOffers(mapMenu.holomap, value) end,
			[1] = {
				caption = ReadText(1001, 46),
				info = ReadText(1001, 3279),
				overrideText = ReadText(1001, 8378),
				type = "multiselectlist",
				id = "trade_wares",
				callback = function (...) return mapMenu.filterTradeWares(...) end,
				listOptions = function (...) return mapMenu.getFilterTradeWaresOptions(...) end,
				displayOption = function (option) return "\27[maptr_supply] " .. GetWareData(option, "name") end,
			},
			[2] = {
				caption = ReadText(1001, 1400),
				type = "checkbox",
				callback = function (...) return mapMenu.filterTradeStorage(...) end,
				[1] = {
					id = "trade_storage_container",
					name = ReadText(20205, 100),
					info = ReadText(1001, 3280),
					param = "container",
				},
				[2] = {
					id = "trade_storage_solid",
					name = ReadText(20205, 200),
					info = ReadText(1001, 3281),
					param = "solid",
				},
				[3] = {
					id = "trade_storage_liquid",
					name = ReadText(20205, 300),
					info = ReadText(1001, 3282),
					param = "liquid",
				},
				[4] = {
					id = "trade_storage_condensate",
					name = ReadText(20205, 1100),
					info = ReadText(1001, 11614),
					param = "condensate",
				},
			},
			[3] = {
				caption = ReadText(1001, 2808),
				type = "slidercell",
				callback = function (...) return mapMenu.filterTradePrice(...) end,
				[1] = {
					id = "trade_price_maxprice",
					name = ReadText(1001, 3284),
					info = ReadText(1001, 3283),
					param = "maxprice",
					scale = {
						min       = 0,
						max       = 10000,
						step      = 1,
						suffix    = ReadText(1001, 101),
						exceedmax = true
					}
				},
			},
			[4] = {
				caption = ReadText(1001, 8357),
				type = "dropdown",
				callback = function (...) return mapMenu.filterTradeVolume(...) end,
				[1] = {
					id = "trade_volume",
					info = ReadText(1001, 8358),
					listOptions = function (...) return mapMenu.getFilterTradeVolumeOptions(...) end,
					param = "volume"
				},
			},
			[5] = {
				caption = ReadText(1001, 11205),
				type = "dropdown",
				callback = function (...) return mapMenu.filterTradePlayerOffer(...) end,
				[1] = {
					id = "trade_playeroffer_buy",
					info = ReadText(1001, 11209),
					listOptions = function (...) return mapMenu.getFilterTradePlayerOfferOptions(true) end,
					param = "playeroffer_buy"
				},
				[2] = {
					id = "trade_playeroffer_sell",
					info = ReadText(1001, 11210),
					listOptions = function (...) return mapMenu.getFilterTradePlayerOfferOptions(false) end,
					param = "playeroffer_sell"
				},
			},
			[6] = {
				caption = ReadText(1001, 11240),
				type = "checkbox",
				callback = function (...) return mapMenu.filterTradeRelation(...) end,
				[1] = {
					id = "trade_relation_enemy",
					name = ReadText(1001, 11241),
					info = ReadText(1001, 11242),
					param = "enemy",
				},
			},
			[7] = {
				caption = ReadText(1001, 8343),
				type = "slidercell",
				callback = function (...) return mapMenu.filterTradeOffer(...) end,
				[1] = {
					id = "trade_offer_number",
					name = ReadText(1001, 8344),
					info = ReadText(1001, 8345),
					param = "number",
					scale = {
						min       = 0,
						minSelect = 1,
						max       = 5,
						step      = 1,
						exceedmax = true,
					}
				},
			},
		},
		["layer_fight"] = {},
		["layer_think"] = {},
		["layer_build"] = {},
		["layer_diplo"] = {},
		["layer_mining"] = {
			callback = function (value) return mapMenu.filterMining(value) end,
			[1] = {
				caption = ReadText(1001, 8330),
				type = "checkbox",
				callback = function (...) return mapMenu.filterMiningResources(...) end,
				[1] = {
					id = "mining_resource_display",
					name = ReadText(1001, 8331),
					info = ReadText(1001, 8332),
					param = "display"
				},
			},
		},
		["layer_other"] = {
			callback = function (value) return mapMenu.filterOther(value) end,
			[1] = {
				caption = ReadText(1001, 3285),
				type = "dropdown",
				callback = function (...) return mapMenu.filterThinkAlert(...) end,
				[1] = {
					info = ReadText(1001, 3286),
					id = "think_alert",
					listOptions = function (...) return mapMenu.getFilterThinkAlertOptions(...) end,
					param = "alert"
				},
			},
			[2] = {
				caption = ReadText(1001, 11204),
				type = "checkbox",
				callback = function (...) return mapMenu.filterThinkDiplomacy(...) end,
				[1] = {
					id = "think_diplomacy_factioncolor",
					name = ReadText(1001, 11203),
					param = "factioncolor",
				},
				[2] = {
					id = "think_diplomacy_highlightvisitor",
					name = ReadText(1001, 11216),
					info = ReadText(1001, 11217),
					param = "highlightvisitors",
				},
			},
			[3] = {
				caption = ReadText(1001, 2664),
				type = "checkbox",
				callback = function (...) return mapMenu.filterOtherMisc(...) end,
				[1] = {
					id = "other_misc_ecliptic",
					name = ReadText(1001, 3297),
					info = ReadText(1001, 3298),
					param = "ecliptic",
				},
				[2] = {
					id = "other_misc_wrecks",
					name = ReadText(1001, 8382),
					info = ReadText(1001, 8383),
					param = "wrecks",
				},
				[3] = {
					id = "other_misc_selection_lines",
					name = ReadText(1001, 11214),
					info = ReadText(1001, 11215),
					param = "selectionlines",
				},
				[4] = {
					id = "other_misc_gate_connections",
					name = ReadText(1001, 11243),
					info = ReadText(1001, 11244),
					param = "gateconnections",
				},
				[5] = {
					id = "other_misc_opacity",
					name = ReadText(1001, 11245),
					info = ReadText(1001, 11246),
					param = "opacity",
				},
				[6] = {
					id = "other_misc_coveroverride",
					name = ReadText(1001, 11604),
					info = ReadText(1001, 11605),
					param = "coveroverride",
					active = Helper.isPlayerCovered,
				},
			},
			[4] = {
				caption = ReadText(1001, 8336),
				type = "checkbox",
				callback = function (...) return mapMenu.filterOtherShip(...) end,
				[1] = {
					id = "other_misc_orderqueue",
					name = ReadText(1001, 3287),
					info = ReadText(1001, 8372),
					param = "orderqueue",
				},
				[2] = {
					id = "other_misc_allyorderqueue",
					name = ReadText(1001, 8370),
					info = ReadText(1001, 8371),
					param = "allyorderqueue",
				},
				[3] = {
					id = "other_misc_crew",
					name = ReadText(1001, 3295),
					info = ReadText(1001, 3296),
					param = "crew",
				},
			},
			[5] = {
				caption = ReadText(1001, 8335),
				type = "checkbox",
				callback = function (...) return mapMenu.filterOtherStation(...) end,
				[1] = {
					id = "other_misc_missions",
					name = ReadText(1001, 3291),
					info = ReadText(1001, 3292),
					param = "missions",
				},
				[2] = {
					id = "other_misc_cargo",
					name = ReadText(1001, 3289),
					info = ReadText(1001, 3290),
					param = "cargo",
				},
				[3] = {
					id = "other_misc_workforce",
					name = ReadText(1001, 3293),
					info = ReadText(1001, 3294),
					param = "workforce",
				},
				[4] = {
					id = "other_misc_dockedships",
					name = ReadText(1001, 3275),
					info = ReadText(1001, 3299),
					param = "dockedships",
				},
				[5] = {
					id = "other_misc_civilian",
					name = ReadText(1001, 8333),
					info = ReadText(1001, 8334),
					param = "civilian",
				},
			},
		},
	},
	mapfilterversion = 18,

	-- custom default row properties, different from Helper defaults
	mapRowHeight = Helper.standardTextHeight,
	mapFontSize = Helper.standardFontSize,
	plotPairedDimension = { posX = "negX", negX = "posX", posY = "negY", negY = "posY", posZ = "negZ", negZ = "posZ" },
	maxPlotSize = 20,

	contextBorder = 5,

	missionOfferCategories = {
		{ category = "plot",		name = ReadText(1001, 3340),	icon = "mapst_mission_main",		helpOverlayID = "mapst_mission_offer_plot",			helpOverlayText = ReadText(1028, 3240) },
		{ category = "guild",		name = ReadText(1001, 3331),	icon = "mapst_mission_guild",		helpOverlayID = "mapst_mission_offer_guild",		helpOverlayText = ReadText(1028, 3227) },
		{ category = "coalition",	name = ReadText(1001, 8801),	icon = "mapst_mission_other",		helpOverlayID = "mapst_mission_offer_coalition",	helpOverlayText = "",					showtab = false },
		{ category = "other",		name = ReadText(1001, 3332),	icon = "mapst_mission_other",		helpOverlayID = "mapst_mission_offer_other",		helpOverlayText = ReadText(1028, 3228) },
	},

	missionCategories = {
		{ category = "plot",		name = ReadText(1001, 3341),	icon = "mapst_mission_main",		helpOverlayID = "mapst_mission_active_main",		helpOverlayText = ReadText(1028, 3241) },
		{ category = "guild",		name = ReadText(1001, 3333),	icon = "mapst_mission_guild",		helpOverlayID = "mapst_mission_active_guild",		helpOverlayText = ReadText(1028, 3229),	showtab = false },
		{ category = "coalition",	name = ReadText(1001, 8801),	icon = "mapst_mission_other",		helpOverlayID = "mapst_mission_active_coalition",	helpOverlayText = "",					showtab = false },
		{ category = "other",		name = ReadText(1001, 3334),	icon = "mapst_mission_other",		helpOverlayID = "mapst_mission_active_other",		helpOverlayText = ReadText(1028, 3230),	showtab = false },
		{ category = "upkeep",		name = ReadText(1001, 3305),	icon = "mapst_mission_upkeep",		helpOverlayID = "mapst_mission_active_upkeep",		helpOverlayText = ReadText(1028, 3231) },
		{ category = "guidance",	name = ReadText(1001, 3329),	icon = "mapst_mission_guidance",	helpOverlayID = "mapst_mission_active_guidance",	helpOverlayText = ReadText(1028, 3232) },
	}
}
function newFuncs.buttonToggleObjectList(objectlistparam)
	local menu = mapMenu

	-- kuertee start: callback
	if callbacks ["buttonToggleObjectList_on_start"] then
		for _, callback in ipairs (callbacks ["buttonToggleObjectList_on_start"]) do
			callback (objectlistparam, config)
		end
	end
	-- kuertee end: callback

	local oldidx, newidx
	local leftbar = menu.showMultiverse and config.leftBarMultiverse or config.leftBar
	local count = 1
	for _, entry in ipairs(leftbar) do
		if (entry.condition == nil) or entry.condition() then
			if entry.mode then
				if type(entry.mode) == "table" then
					for _, mode in ipairs(entry.mode) do
						if mode == menu.infoTableMode then
							oldidx = count
						end
						if mode == objectlistparam then
							newidx = count
						end
					end
				else
					if entry.mode == menu.infoTableMode then
						oldidx = count
					end
					if entry.mode == objectlistparam then
						newidx = count
					end
				end
			end
			count = count + 1
		end
		if oldidx and newidx then
			break
		end
	end
	if newidx then
		Helper.updateButtonColor(menu.sideBar, newidx, 1, Helper.defaultArrowRowBackgroundColor)
	end
	if oldidx then
		Helper.updateButtonColor(menu.sideBar, oldidx, 1, Helper.defaultButtonBackgroundColor)
	end

	menu.createInfoFrameRunning = true
	if (menu.infoTableMode == "missionoffer") or (menu.infoTableMode == "mission") then
		menu.missionModeCurrent = nil
		if menu.missionModeContext then
			menu.closeContextMenu()
			menu.missionModeContext = nil
		end
	elseif (menu.infoTableMode == "ventureoperation") or (menu.infoTableMode == "ventureinventory") then
		Helper.callExtensionFunction("multiverse", "onCloseMenuTab", menu, menu.infoTableMode, objectlistparam)
	end
	AddUITriggeredEvent(menu.name, objectlistparam, menu.infoTableMode == objectlistparam and "off" or "on")
	if menu.infoTableMode == objectlistparam then
		menu.settoprow = GetTopRow(menu.infoTable)
		menu.topRows.infotableleft = menu.settoprow
		PlaySound("ui_negative_back")
		menu.infoTableMode = nil
		if oldidx then
			SelectRow(menu.sideBar, oldidx)
		end
	else
		menu.settoprow = nil
		menu.topRows.infotableleft = nil
		menu.infoTable = nil
		menu.infoTable2 = nil
		PlaySound("ui_positive_select")
		if (menu.infoTableMode == "missionoffer") or (menu.infoTableMode == "mission") then
			if menu.missionModeContext then
				menu.closeContextMenu()
				menu.missionModeContext = nil
			end
		end
		menu.infoTableMode = objectlistparam
		if newidx then
			SelectRow(menu.sideBar, newidx)
		end
		if menu.infoTableMode == "plots" then
			menu.updatePlotData("plots_new", true)
			menu.storeCurrentPlots()
			--menu.plotDoNotUpdate = true
			menu.mode = "selectbuildlocation"
			C.ShowBuildPlotPlacementMap(menu.holomap, menu.currentsector)
		elseif (menu.mode ~= "selectCV") and (menu.mode ~= "hire") and (menu.mode ~= "orderparam_object") and (menu.mode ~= "selectComponent") then
			menu.plots_initialized = nil
			menu.plotData = {}
			menu.mode = nil
			menu.removeMouseCursorOverride(3)
			if not menu.showMultiverse then
				local startpos = ffi.new("UIPosRot")
				C.ShowUniverseMap2(menu.holomap, false, false, false, 0, startpos)
			end
		end
		if menu.infoTableMode == "missionoffer" then
			menu.updateMissionOfferList(true)
		end
		Helper.textArrayHelper(menu.searchtext, function (numtexts, texts) return C.SetMapFilterString(menu.holomap, numtexts, texts) end, "text")
		menu.applyFilterSettings()
	end
	menu.setrow = nil
	menu.setcol = nil
	menu.selectedRows.infotableleft = nil
	menu.selectedCols.infotableleft = nil
	menu.refreshMainFrame = true
	menu.createInfoFrame()
end
function newFuncs.buttonMissionActivate()
	local menu = mapMenu

	local active = menu.contextMenuData.missionid == C.GetActiveMissionID()
	for _, submissionEntry in ipairs(menu.contextMenuData.subMissions) do
		if submissionEntry.active then
			active = true
		end
	end
	if active then
		C.SetActiveMission(0)
	else
		C.SetActiveMission(menu.contextMenuData.missionid)
		PlaySound("ui_mission_set_active")

		-- kuertee start: callback
		if callbacks ["buttonMissionActivate_on_activate"] then
			-- get active mission first, because the clicked item may have been a group
			local activeMissionId
			local numMissions = GetNumMissions ()
			for i = 1, numMissions do
				local entry = mapMenu.getMissionInfoHelper (i)
				if entry.active then
					activeMissionId = entry.ID
				end
			end
			for _, callback in ipairs (callbacks ["buttonMissionActivate_on_activate"]) do
				-- callback (menu.contextMenuData.missionid)
				callback (activeMissionId)
			end
		end
		-- kuertee end: callback

	end
	menu.closeContextMenu()
	menu.refreshIF = getElapsedTime()
end
function newFuncs.buttonSelectHandler()
	local menu = mapMenu
	-- DebugError ("kuertee_menu_map.ui.buttonSelectHandler menu.mode " .. tostring (menu.mode))
	-- DebugError ("kuertee_menu_map.ui.buttonSelectHandler menu.modeparam[1] " .. tostring (menu.modeparam[1]))
	if menu.mode == "hire" then
		if C.IsComponentClass(menu.contextMenuData.component, "controllable") then
			local isplayerowned, isdock, isonlineobject = GetComponentData(menu.contextMenuData.component, "isplayerowned", "isdock", "isonlineobject")
			if not isonlineobject and (isplayerowned or (isdock and C.IsComponentClass(menu.contextMenuData.component, "station"))) then
				if menu.hireShip ~= menu.contextMenuData.component then
					menu.hireShip = menu.contextMenuData.component
					menu.hireRole = nil
					menu.hireIsPost = nil
					menu.hireIsMission = nil

					menu.refreshMainFrame = true
				end
			end
		end
	elseif menu.mode == "selectCV" then
		menu.selectCV(menu.contextMenuData.component)
	elseif menu.mode == "orderparam_object" then
		if menu.checkForOrderParamObject(menu.contextMenuData.component) then
			menu.modeparam[1](ConvertStringToLuaID(tostring(menu.contextMenuData.component)))
		end
	elseif menu.mode == "selectComponent" then

		-- kuertee start: callback
		if menu.modeparam[6] ~= nil then
			-- if selectComponent returnsection is nil, then do a AddUITriggeredEvent instead
			DebugError ("kuertee_menu_map.ui.buttonSelectHandler menu.contextMenuData.component " .. tostring (menu.contextMenuData.component))
			DebugError ("kuertee_menu_map.ui.buttonSelectHandler menu.contextMenuData.component " .. tostring (ConvertStringToLuaID (tostring (menu.contextMenuData.component))))
			AddUITriggeredEvent (menu.modeparam[6], "select_component", ConvertStringToLuaID (tostring (menu.contextMenuData.component)))
			menu.mode = menu.old_mode
			menu.modeparam = menu.old_modeparam
			menu.infoTableMode = menu.old_infoTableMode
			menu.closeContextMenu()
			menu.refreshMainFrame = true
			menu.refreshInfoFrame()
			return
		end

		-- if menu.checkForSelectComponent(menu.contextMenuData.component) then
		if menu.modeparam[1] and menu.checkForSelectComponent(menu.contextMenuData.component) then
		-- kuertee end: callback

			C.ClearMapObjectFilter(menu.holomap)
			Helper.closeMenuForSection(menu, menu.modeparam[1], { ConvertStringToLuaID(tostring(menu.contextMenuData.component)) })
			menu.cleanup()
		end
	end
	menu.closeContextMenu()
end
function newFuncs.createInfoFrame()
	local menu = mapMenu

	menu.createInfoFrameRunning = true
	menu.refreshed = true
	menu.noupdate = false

	-- remove old data
	Helper.clearDataForRefresh(menu, config.infoFrameLayer)

	-- infoTable
	local infoTableHeight = Helper.viewHeight - menu.infoTableOffsetY - menu.borderOffset

	menu.infoFrame = Helper.createFrameHandle(menu, {
		x = menu.infoTableOffsetX,
		y = menu.infoTableOffsetY,
		width = menu.infoTableWidth,
		height = infoTableHeight,
		layer = config.infoFrameLayer,
		backgroundID = "solid",
		backgroundColor = Helper.color.semitransparent,
		standardButtons = {},
		autoFrameHeight = true,
		helpOverlayID = "map_infoframe",
	})

	menu.autopilottarget = GetAutoPilotTarget()
	menu.softtarget = C.GetSofttarget().softtargetID
	menu.populateUpkeepMissionData()

	if (menu.infoTableMode ~= "info") and (menu.mode ~= "orderparam_object") then
		menu.infoTablePersistentData.left.cashtransferdetails = {}
		menu.infoTablePersistentData.left.drops = {}
		menu.infoTablePersistentData.left.crew.object = nil
		menu.infoTablePersistentData.left.macrostolaunch = {}
	end

	if menu.holomap ~= 0 then
		if menu.infoTableMode then
			C.SetMapStationInfoBoxMargin(menu.holomap, "left", menu.infoTableOffsetX + menu.infoTableWidth + config.contextBorder)
		else
			C.SetMapStationInfoBoxMargin(menu.holomap, "left", 0)
		end
	end

	Helper.clearTableConnectionColumn(menu, 2)

	local helpOverlayText = ""

	local infotabledesc, infotabledesc2
	menu.infoTableData = menu.infoTableData or {}
	menu.infoTableData.left = {}
	if menu.infoTableMode == "objectlist" then
		infotabledesc, infotabledesc2 = menu.createObjectList(menu.infoFrame, "left")
	elseif menu.infoTableMode == "propertyowned" then
		infotabledesc = menu.createPropertyOwned(menu.infoFrame, "left")
	elseif menu.infoTableMode == "plots" then
		menu.createPlotMode(menu.infoFrame)
	elseif menu.infoTableMode == "info" then
		if menu.infoMode.left == "objectinfo" then
			menu.infoFrame.properties.autoFrameHeight = false
			menu.createInfoSubmenu(menu.infoFrame, "left")
		elseif menu.infoMode.left == "objectcrew" then
			menu.createCrewInfoSubmenu(menu.infoFrame, "left")
		elseif menu.infoMode.left == "objectloadout" then
			menu.createLoadoutInfoSubmenu(menu.infoFrame, "left")
		elseif menu.infoMode.left == "objectlogbook" then
			menu.createLogbookInfoSubmenu(menu.infoFrame, "left")
		elseif menu.infoMode.left == "orderqueue" then
			menu.createOrderQueue(menu.infoFrame, menu.infoMode.left, "left")
		elseif menu.infoMode.left == "orderqueue_advanced" then
			menu.createOrderQueue(menu.infoFrame, menu.infoMode.left, "left")
		elseif menu.infoMode.left == "standingorders" then
			menu.createStandingOrdersMenu(menu.infoFrame, "left")
		end
	elseif menu.infoTableMode == "missionoffer" then
		menu.createMissionMode(menu.infoFrame)
	elseif menu.infoTableMode == "mission" then
		menu.createMissionMode(menu.infoFrame)
	elseif menu.infoTableMode == "ventureseason" then
		if menu.seasonMode.left == "currentseason" then
			menu.createVentureSeason(menu.infoFrame, "left")
		elseif menu.seasonMode.left == "coalition" then
			Helper.callExtensionFunction("multiverse", "createVentureCoalition", menu, menu.infoFrame, "left")
		elseif menu.seasonMode.left == "ventureteam" then
			Helper.callExtensionFunction("multiverse", "createVentureTeam", menu, menu.infoFrame, "left")
		elseif menu.seasonMode.left == "pastseasons" then
			Helper.callExtensionFunction("multiverse", "createVenturePastSeasons", menu, menu.infoFrame, "left")
		end
	elseif menu.infoTableMode == "ventureoperation" then
		Helper.callExtensionFunction("multiverse", "createVentureOperation", menu, menu.infoFrame, "left")
	elseif menu.infoTableMode == "venturelogbook" then
		Helper.callExtensionFunction("multiverse", "createVentureLogbook", menu, menu.infoFrame, "left")
	elseif menu.infoTableMode == "ventureinventory" then
		Helper.callExtensionFunction("multiverse", "createVentureInventory", menu, menu.infoFrame, "left")
	elseif menu.infoTableMode == "cheats" then
		menu.createCheats(menu.infoFrame)
	else
		-- empty

		-- menu.infoFrame.properties.backgroundID = ""
		-- menu.infoFrame.properties.autoFrameHeight = false
		-- menu.infoFrame:addTable(0)

		-- kuertee start: callback
		local isCreated = false
		if callbacks ["createInfoFrame_on_menu_infoTableMode"] then
			for _, callback in ipairs (callbacks ["createInfoFrame_on_menu_infoTableMode"]) do
				if callback (menu.infoFrame) then
					isCreated = true
				end
			end
		end
		if isCreated ~= true then
			menu.infoFrame.properties.backgroundID = ""
			menu.infoFrame.properties.autoFrameHeight = false
			menu.infoFrame:addTable(0)
		end
		-- kuertee end: callback

	end

		-- start Forleyor_infoCenter callback:
		local isCreated = false
		if callbacks ["ic_createInfoFrame"] then
			for _, callback in ipairs (callbacks ["ic_createInfoFrame"]) do
				if callback (menu.infoFrame) then
					isCreated = true
				end
			end
		end
		if isCreated ~= true then
			menu.infoFrame:addTable(0)
		end
		-- end Forleyor_infoCenter callback:

	if menu.infoFrame then
		menu.infoFrame.properties.helpOverlayText = helpOverlayText
		menu.infoFrame:display()
	else
		-- create legacy info frame
		-- NOTE: descriptor table is {infotabledesc} if infotabledesc2 == nil
		Helper.displayFrame(menu, {infotabledesc, infotabledesc2}, false, "solid", "", {}, nil, config.infoFrameLayer, Helper.color.semitransparent, nil, false, true, nil, nil, menu.infoTableWidth, infoTableHeight, menu.infoTableOffsetX, menu.infoTableOffsetY)
	end

	if menu.holomap and (menu.holomap ~= 0) then
		menu.setSelectedMapComponents()
	end
end
function newFuncs.refreshInfoFrame(setrow, setcol)
	local menu = mapMenu

	if (menu.mode == "tradecontext") or (menu.mode == "dropwarescontext") or (menu.mode == "renamecontext") or (menu.mode == "crewtransfercontext") or (menu.mode == "venturepatroninfo") then
		return
	end
	if not menu.createInfoFrameRunning then
		menu.settoprow = menu.settoprow or GetTopRow(menu.infoTable)
		menu.topRows.infotableleft = menu.settoprow
		if menu.setplottoprow then
			menu.settoprow = menu.setplottoprow
			menu.setplottoprow = nil
		end

		-- if (menu.infoTableMode ~= "objectlist") and (menu.infoTableMode ~= "propertyowned") then
		-- kuertee start: callback
		if (not string.find ("" .. tostring (menu.infoTableMode), "objectlist")) and (not string.find ("" .. tostring (menu.infoTableMode), "propertyowned")) then
		-- kuertee end: callback

			menu.setrow = setrow or Helper.currentTableRow[menu.infoTable]
			menu.selectedRows.infotableleft = menu.setrow
			if menu.setplotrow then
				menu.setrow = menu.setplotrow
				menu.setplotrow = nil
			end
			menu.setcol = setcol or Helper.currentTableCol[menu.infoTable]
			menu.selectedCols.infotableleft = menu.setcol
		end

		menu.selectedRows.infotable2 = nil
		if menu.infoTable2 then
			menu.selectedRows.infotable2 = Helper.currentTableRow[menu.infoTable2]
		end
		if menu.infoTable3 then
			menu.topRows.infotable3left = GetTopRow(menu.infoTable3)
			menu.selectedRows.infotable3left = Helper.currentTableRow[menu.infoTable3]
		end
		if menu.orderHeaderTable and menu.lastactivetable == menu.orderHeaderTable.id then
			menu.selectedRows.orderHeaderTableleft = menu.selectedRows.orderHeaderTableleft or Helper.currentTableRow[menu.orderHeaderTable.id] or 1
			menu.selectedCols.orderHeaderTableleft = menu.selectedCols.orderHeaderTableleft or Helper.currentTableCol[menu.orderHeaderTable.id]
		end
		if menu.ventureSeasonHeaderTableLeft and menu.lastactivetable == menu.ventureSeasonHeaderTableLeft.id then
			menu.selectedRows.ventureSeasonHeaderTableleft = menu.selectedRows.ventureSeasonHeaderTableleft or Helper.currentTableRow[menu.ventureSeasonHeaderTableLeft.id] or 1
			menu.selectedCols.ventureSeasonHeaderTableleft = menu.selectedCols.ventureSeasonHeaderTableleft or Helper.currentTableCol[menu.ventureSeasonHeaderTableLeft.id]
		end
		if menu.ventureInventoryHeaderTableLeft and menu.lastactivetable == menu.ventureInventoryHeaderTableLeft.id then
			menu.selectedRows.ventureInventoryHeaderTableleft = menu.selectedRows.ventureInventoryHeaderTableleft or Helper.currentTableRow[menu.ventureInventoryHeaderTableLeft.id] or 1
			menu.selectedCols.ventureInventoryHeaderTableleft = menu.selectedCols.ventureInventoryHeaderTableleft or Helper.currentTableCol[menu.ventureInventoryHeaderTableLeft.id]
		end
		menu.createInfoFrame()
	end
	menu.refreshInfoFrame2()
end
function newFuncs.createPropertyOwned(frame, instance)
	local menu = mapMenu

	-- kuertee start: callback
	if callbacks ["createPropertyOwned_on_start"] then
		for _, callback in ipairs (callbacks ["createPropertyOwned_on_start"]) do
			callback (config)
		end
	end
	-- kuertee end: callback

	local infoTableData = menu.infoTableData[instance]

	-- TODO: Move to config table?
	infoTableData.maxIcons = 5
	infoTableData.shipIconWidth = menu.getShipIconWidth()
	local maxicons = infoTableData.maxIcons

	local ftable = frame:addTable(5 + maxicons, { tabOrder = 1, multiSelect = true })
	ftable:setDefaultCellProperties("text", { minRowHeight = config.mapRowHeight, fontsize = config.mapFontSize })
	ftable:setDefaultCellProperties("button", { height = config.mapRowHeight })
	ftable:setDefaultComplexCellProperties("button", "text", { fontsize = config.mapFontSize })

	--  [+/-] [Object Name][Location] [Sub_1] [Sub_2] [Sub_3] ... [Sub_N] [Shield/Hull Bar]
	ftable:setColWidth(1, Helper.scaleY(config.mapRowHeight), false)
	ftable:setDefaultBackgroundColSpan(2, 4 + maxicons)
	ftable:setColWidthMinPercent(2, 14)
	ftable:setColWidthMinPercent(4, 5)
	for i = 1, maxicons do
		ftable:setColWidth(5 + i - 1, infoTableData.shipIconWidth, false)
	end
	ftable:setColWidth(5 + maxicons, infoTableData.shipIconWidth, false)

	local row = ftable:addRow(false, { fixed = true, bgColor = Helper.defaultTitleBackgroundColor })
	row[1]:setColSpan(5 + maxicons):createText(ReadText(1001, 1000), Helper.headerRowCenteredProperties)

	infoTableData.stations = { }
	infoTableData.fleetLeaderShips = { }
	infoTableData.unassignedShips = { }
	infoTableData.constructionShips = { }
	infoTableData.inventoryShips = { }
	infoTableData.deployables = { }
	infoTableData.subordinates = { }
	infoTableData.dockedships = { }
	infoTableData.constructions = { }
	infoTableData.moduledata = { }

	-- kuertee start: callback
	if callbacks ["createPropertyOwned_on_init_infoTableData"] then
		for _, callback in ipairs (callbacks ["createPropertyOwned_on_init_infoTableData"]) do
			callback (infoTableData)
		end
	end
	-- kuertee end: callback

	local onlineitems = {}
	if menu.propertyMode == "inventoryships" then
		onlineitems = OnlineGetUserItems()
	end

	local playerobjects = {}
	if Helper.isPlayerCovered() and (not C.IsUICoverOverridden()) then
		playerobjects[1] = ConvertStringTo64Bit(tostring(C.GetPlayerOccupiedShipID()))
	else
		playerobjects = GetContainedObjectsByOwner("player")
	end
	for i = #playerobjects, 1, -1 do
		local object = playerobjects[i]
		local object64 = ConvertIDTo64Bit(object)
		if menu.isObjectValid(object64) then
			local hull, purpose, uirelation = GetComponentData(object, "hullpercent", "primarypurpose", "uirelation")
			playerobjects[i] = { id = object, name = ffi.string(C.GetComponentName(object64)), fleetname = menu.getFleetName(object64), objectid = ffi.string(C.GetObjectIDCode(object64)), class = ffi.string(C.GetComponentClass(object64)), hull = hull, purpose = purpose, relation = uirelation }
		else
			table.remove(playerobjects, i)
		end
	end

	table.sort(playerobjects, menu.componentSorter(menu.propertySorterType))

	for _, entry in ipairs(playerobjects) do
		local object = entry.id
		local object64 = ConvertIDTo64Bit(object)
		-- Determine subordinates that may appear in the menu
		local subordinates = {}
		if C.IsComponentClass(object64, "controllable") then
			subordinates = GetSubordinates(object)
		end
		for i = #subordinates, 1, -1 do
			local subordinate = subordinates[i]
			if not menu.isObjectValid(ConvertIDTo64Bit(subordinate)) then
				table.remove(subordinates, i)
			end
		end
		subordinates.hasRendered = #subordinates > 0
		infoTableData.subordinates[tostring(object)] = subordinates
		-- Find docked ships
		local dockedships = {}
		if C.IsComponentClass(object64, "container") then
			Helper.ffiVLA(dockedships, "UniverseID", C.GetNumDockedShips, C.GetDockedShips, object64, nil)
		end
		for i = #dockedships, 1, -1 do
			local convertedID = ConvertStringToLuaID(tostring(dockedships[i]))
			local loccommander = GetCommander(convertedID)
			if not loccommander then
				dockedships[i] = convertedID
			else
				table.remove(dockedships, i)
			end
		end
		infoTableData.dockedships[tostring(object)] = dockedships
		-- Check if object is station, fleet leader or unassigned
		local commander
		if C.IsComponentClass(object64, "controllable") then
			commander = GetCommander(object)
		end
		if not commander then
			if C.IsRealComponentClass(object64, "station") then
				table.insert(infoTableData.stations, object)
			elseif GetComponentData(object, "isdeployable") or C.IsComponentClass(object64, "lockbox") then
				table.insert(infoTableData.deployables, object)
			elseif #subordinates > 0 then
				table.insert(infoTableData.fleetLeaderShips, object)
			else
				table.insert(infoTableData.unassignedShips, object)
			end
		end

		if C.IsRealComponentClass(object64, "station") then
			local constructions = {}
			local constructionshipsbymacro = {}
			-- builds in progress
			local n = C.GetNumBuildTasks(object64, 0, true, false)
			local buf = ffi.new("BuildTaskInfo[?]", n)
			n = C.GetBuildTasks(buf, n, object64, 0, true, false)
			for i = 0, n - 1 do
				table.insert(constructions, { id = buf[i].id, buildingcontainer = buf[i].buildingcontainer, component = buf[i].component, macro = ffi.string(buf[i].macro), factionid = ffi.string(buf[i].factionid), buildercomponent = buf[i].buildercomponent, price = buf[i].price, ismissingresources = buf[i].ismissingresources, queueposition = buf[i].queueposition, inprogress = true })
			end
			if #constructions > 0 then
				table.insert(constructions, { empty = true })
			end
			-- other builds
			local n = C.GetNumBuildTasks(object64, 0, false, false)
			local buf = ffi.new("BuildTaskInfo[?]", n)
			n = C.GetBuildTasks(buf, n, object64, 0, false, false)
			for i = 0, n - 1 do
				local component = buf[i].component
				local macro = ffi.string(buf[i].macro)
				if (component == 0) and (macro ~= "") then
					if constructionshipsbymacro[macro] then
						constructions[constructionshipsbymacro[macro]].amount = constructions[constructionshipsbymacro[macro]].amount + 1
					else
						table.insert(constructions, { id = buf[i].id, buildingcontainer = buf[i].buildingcontainer, component = component, macro = macro, factionid = ffi.string(buf[i].factionid), buildercomponent = buf[i].buildercomponent, price = buf[i].price, ismissingresources = buf[i].ismissingresources, queueposition = buf[i].queueposition, inprogress = false, amount = 1 })
						constructionshipsbymacro[macro] = #constructions
					end
				else
					table.insert(constructions, { id = buf[i].id, buildingcontainer = buf[i].buildingcontainer, component = component, macro = macro, factionid = ffi.string(buf[i].factionid), buildercomponent = buf[i].buildercomponent, price = buf[i].price, ismissingresources = buf[i].ismissingresources, queueposition = buf[i].queueposition, inprogress = false })
				end
			end
			infoTableData.constructions[tostring(object)] = constructions
		elseif C.IsComponentClass(object64, "ship") then
			if menu.propertyMode == "inventoryships" then
				local pilot = ConvertIDTo64Bit(GetComponentData(object, "assignedpilot"))
				if pilot and (pilot ~= C.GetPlayerID()) then
					local inventory = GetInventory(pilot)
					if next(inventory) then
						local sortedWares = {}
						for ware, entry in pairs(inventory) do
							local ispersonalupgrade = GetWareData(ware, "ispersonalupgrade")
							if (not ispersonalupgrade) and (not onlineitems[ware]) then
								table.insert(infoTableData.inventoryShips, object)
								break
							end
						end
					end
				end
			end

			-- kuertee start: callback
			if callbacks ["createPropertyOwned_on_add_ship_infoTableData"] then
				for _, callback in ipairs (callbacks ["createPropertyOwned_on_add_ship_infoTableData"]) do
					callback (infoTableData, object)
				end
			end
			-- kuertee end: callback

		end
	end

	-- kuertee start: callback
	if callbacks ["createPropertyOwned_on_add_other_objects_infoTableData"] then
		for _, callback in ipairs (callbacks ["createPropertyOwned_on_add_other_objects_infoTableData"]) do
			callback (infoTableData)
		end
	end
	-- kuertee end: callback

	local constructionshipsbymacro = {}
	local n = C.GetNumPlayerShipBuildTasks(true, false)
	local buf = ffi.new("BuildTaskInfo[?]", n)
	n = C.GetPlayerShipBuildTasks(buf, n, true, false)
	for i = 0, n - 1 do
		local factionid = ffi.string(buf[i].factionid)
		if factionid == "player" then
			table.insert(infoTableData.constructionShips, { id = buf[i].id, buildingcontainer = buf[i].buildingcontainer, component = buf[i].component, macro = ffi.string(buf[i].macro), factionid = factionid, buildercomponent = buf[i].buildercomponent, price = buf[i].price, ismissingresources = buf[i].ismissingresources, queueposition = buf[i].queueposition, inprogress = true })
		end
	end
	if #infoTableData.constructionShips > 0 then
		table.insert(infoTableData.constructionShips, { empty = true })
	end
	local n = C.GetNumPlayerShipBuildTasks(false, false)
	local buf = ffi.new("BuildTaskInfo[?]", n)
	n = C.GetPlayerShipBuildTasks(buf, n, false, false)
	for i = 0, n - 1 do
		local factionid = ffi.string(buf[i].factionid)
		if factionid == "player" then
			local component = buf[i].component
			local macro = ffi.string(buf[i].macro)
			if (component == 0) and (macro ~= "") then
				if constructionshipsbymacro[macro] then
					infoTableData.constructionShips[constructionshipsbymacro[macro]].amount = infoTableData.constructionShips[constructionshipsbymacro[macro]].amount + 1
				else
					table.insert(infoTableData.constructionShips, { id = buf[i].id, buildingcontainer = buf[i].buildingcontainer, component = component, macro = macro, factionid = factionid, buildercomponent = buf[i].buildercomponent, price = buf[i].price, ismissingresources = buf[i].ismissingresources, queueposition = buf[i].queueposition, inprogress = false, amount = 1 })
					constructionshipsbymacro[macro] = #infoTableData.constructionShips
				end
			else
				table.insert(infoTableData.constructionShips, { id = buf[i].id, buildingcontainer = buf[i].buildingcontainer, component = component, macro = macro, factionid = factionid, buildercomponent = buf[i].buildercomponent, price = buf[i].price, ismissingresources = buf[i].ismissingresources, queueposition = buf[i].queueposition, inprogress = false })
			end
		end
	end

	local numdisplayed = 0
	local maxvisibleheight = ftable:getFullHeight()
	if menu.mode ~= "selectCV" then
		if (menu.propertyMode == "stations") or (menu.propertyMode == "propertyall") then
			numdisplayed = menu.createPropertySection(instance, "ownedstations", ftable, ReadText(1001, 8379), infoTableData.stations, "-- " .. ReadText(1001, 33) .. " --", menu.mode ~= "hire", numdisplayed, nil, menu.propertySorterType)
		end
	end
	if (menu.propertyMode == "fleets") or (menu.propertyMode == "propertyall") then
		numdisplayed = menu.createPropertySection(instance, "ownedfleets", ftable, ReadText(1001, 8326), infoTableData.fleetLeaderShips, "-- " .. ReadText(1001, 34) .. " --", nil, numdisplayed, nil, menu.propertySorterType)			-- {1001,8326} = Fleets
	end
	if (menu.propertyMode == "unassignedships") or (menu.propertyMode == "propertyall") then
		numdisplayed = menu.createPropertySection(instance, "ownedships", ftable, ReadText(1001, 8327), infoTableData.unassignedShips, "-- " .. ReadText(1001, 34) .. " --", nil, numdisplayed, nil, menu.propertySorterType)	-- {1001,8327} = Unassigned Ships
	end
	if menu.propertyMode == "inventoryships" then
		numdisplayed = menu.createPropertySection(instance, "inventoryships", ftable, ReadText(1001, 8381), infoTableData.inventoryShips, "-- " .. ReadText(1001, 34) .. " --", nil, numdisplayed, true, menu.propertySorterType)	-- {1001,8327} = Ships with Inventory
	end
	if (menu.propertyMode == "unassignedships") or (menu.propertyMode == "propertyall") then
		-- construction rows do not use the shield/hull bar widget
		menu.createConstructionSection(instance, "constructionships", ftable, ReadText(1001, 8328), infoTableData.constructionShips)
	end
	if menu.mode ~= "selectCV" then
		if menu.propertyMode == "deployables" then
			numdisplayed = menu.createPropertySection(instance, "owneddeployables", ftable, ReadText(1001, 1332), infoTableData.deployables, "-- " .. ReadText(1001, 34) .. " --", nil, numdisplayed, nil, menu.propertySorterType)
		end
	end

	-- kuertee start: callback
	if callbacks ["createPropertyOwned_on_createPropertySection_unassignedships"] then
		local result
		for _, callback in ipairs (callbacks ["createPropertyOwned_on_createPropertySection_unassignedships"]) do
			result = callback (numdisplayed, instance, ftable, infoTableData)
			if result and result.numdisplayed > numdisplayed then
				numdisplayed = result.numdisplayed
			end
		end
	end
	-- kuertee end: callback

	if numdisplayed > 50 then
		ftable.properties.maxVisibleHeight = maxvisibleheight + 50 * (Helper.scaleY(config.mapRowHeight) + Helper.borderSize)
	end

	menu.numFixedRows = ftable.numfixedrows

	menu.settoprow = ((not menu.settoprow) or (menu.settoprow == 0)) and ((menu.setrow and menu.setrow > 31) and (menu.setrow - 27) or 3) or menu.settoprow
	ftable:setTopRow(menu.settoprow)
	if menu.infoTable then
		local result = GetShiftStartEndRow(menu.infoTable)
		if result then
			ftable:setShiftStartEnd(table.unpack(result))
		end
	end
	ftable:setSelectedRow(menu.sethighlightborderrow or menu.setrow)
	menu.setrow = nil
	menu.settoprow = nil
	menu.setcol = nil
	menu.sethighlightborderrow = nil

	-- kuertee start: re-written product categories and sorter table
	-- purpose: allows mods to add more product categories without destroying the sorter's layout
	local isUseEgosoftProductCategoriesTab = false
	local tabtable
	if isUseEgosoftProductCategoriesTab then
		-- egosoft start: original product categories and sorter table
		tabtable = frame:addTable(#config.propertyCategories + 3, { tabOrder = 2, reserveScrollBar = false })
		for i = 1, #config.propertyCategories do
			tabtable:setColWidth(i, menu.sideBarWidth, false)
		end
		local sorterWidth = menu.infoTableWidth - 3 * (menu.sideBarWidth + Helper.borderSize) - (#config.propertyCategories - 1) * Helper.borderSize
		local availableWidthForExtraColumns = menu.infoTableWidth - #config.propertyCategories * (menu.sideBarWidth + Helper.borderSize) - 2 * Helper.borderSize
		local colwidth = sorterWidth / 3
		local colspan = 3
		if colwidth > 3 * menu.sideBarWidth + 2 * Helper.borderSize then
			colspan = 4
		elseif colwidth < 2 * menu.sideBarWidth + Helper.borderSize then
			colspan = 2
			colwidth = (menu.infoTableWidth - 6 * (menu.sideBarWidth + Helper.borderSize) - 2 * Helper.borderSize) / 2
		end

		if 2 * colwidth >= availableWidthForExtraColumns then
			colwidth = math.floor((availableWidthForExtraColumns - 1) / 2)
		end

		tabtable:setColWidth(#config.propertyCategories + 2, colwidth, false)
		tabtable:setColWidth(#config.propertyCategories + 3, colwidth, false)

		local row = tabtable:addRow("property_tabs", { fixed = true, bgColor = Helper.color.transparent })
		for i, entry in ipairs(config.propertyCategories) do
			local bgcolor = Helper.defaultTitleBackgroundColor
			local color = Helper.color.white
			if entry.category == menu.propertyMode then
				bgcolor = Helper.defaultArrowRowBackgroundColor
			end

			local active = true
			if menu.mode == "hire" then
				active = entry.category ~= "deployables"
			elseif menu.mode == "selectCV" then
				active = entry.category == "propertyall"
			elseif (menu.mode == "selectComponent") and (menu.modeparam[3] == "deployables") then
				active = entry.category == "deployables"
				if active and (menu.selectedCols.propertytabs == nil) then
					menu.selectedCols.propertytabs = i
				end
			end

			row[i]:createButton({ height = menu.sideBarWidth, bgColor = bgcolor, mouseOverText = entry.name, scaling = false, helpOverlayID = entry.helpOverlayID, helpOverlayText = entry.helpOverlayText, active = active }):setIcon(entry.icon, { color = color})
			row[i].handlers.onClick = function () return menu.buttonPropertySubMode(entry.category, i) end
		end

		local row = tabtable:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
		row[1]:setColSpan(3):createText(ReadText(1001, 2906) .. ReadText(1001, 120))

		local buttonheight = Helper.scaleY(config.mapRowHeight)
		local button = row[4]:setColSpan(colspan):createButton({ scaling = false, height = buttonheight }):setText(ReadText(1001, 8026), { halign = "center", scaling = true })
		if menu.propertySorterType == "class" then
			button:setIcon("table_arrow_inv_down", { width = buttonheight, height = buttonheight, x = button:getColSpanWidth() - buttonheight })
		elseif menu.propertySorterType == "classinverse" then
			button:setIcon("table_arrow_inv_up", { width = buttonheight, height = buttonheight, x = button:getColSpanWidth() - buttonheight })
		end
		row[4].handlers.onClick = function () return menu.buttonPropertySorter("class") end
		local button = row[#config.propertyCategories + colspan - 2]:setColSpan(5 - colspan):createButton({ scaling = false, height = buttonheight }):setText(ReadText(1001, 2809), { halign = "center", scaling = true })
		if menu.propertySorterType == "name" then
			button:setIcon("table_arrow_inv_down", { width = buttonheight, height = buttonheight, x = button:getColSpanWidth() - buttonheight })
		elseif menu.propertySorterType == "nameinverse" then
			button:setIcon("table_arrow_inv_up", { width = buttonheight, height = buttonheight, x = button:getColSpanWidth() - buttonheight })
		end
		row[#config.propertyCategories + colspan - 2].handlers.onClick = function () return menu.buttonPropertySorter("name") end
		local button = row[#config.propertyCategories + 3]:createButton({ scaling = false, height = buttonheight }):setText(ReadText(1001, 1), { halign = "center", scaling = true })
		if menu.propertySorterType == "hull" then
			button:setIcon("table_arrow_inv_down", { width = buttonheight, height = buttonheight, x = button:getColSpanWidth() - buttonheight })
		elseif menu.propertySorterType == "hullinverse" then
			button:setIcon("table_arrow_inv_up", { width = buttonheight, height = buttonheight, x = button:getColSpanWidth() - buttonheight })
		end
		row[#config.propertyCategories + 3].handlers.onClick = function () return menu.buttonPropertySorter("hull") end
		-- egosoft end: original product categories and sorter table
	else
		local maxNumCategoryColumns =  math.floor (menu.infoTableWidth / (menu.sideBarWidth + Helper.borderSize))
		if maxNumCategoryColumns > 13 then
			maxNumCategoryColumns = 13
		end
		local numOfSorterColumns = 4 -- "sort by", "size", "name", "hull"
		local colSpanPerSorterColumn = math.floor (maxNumCategoryColumns / numOfSorterColumns)
		tabtable = frame:addTable(maxNumCategoryColumns, { tabOrder = 2, reserveScrollBar = false })
		if maxNumCategoryColumns > 0 then
			for i = 1, maxNumCategoryColumns do
				tabtable:setColWidth(i, menu.sideBarWidth, false)
			end
		end
		local diff = menu.infoTableWidth - maxNumCategoryColumns * (menu.sideBarWidth + Helper.borderSize)
		tabtable:setColWidth(maxNumCategoryColumns, menu.sideBarWidth + diff, false)
		-- product categories row
		local row = tabtable:addRow("property_tabs", { fixed = true, bgColor = Helper.color.transparent })
		if #config.propertyCategories > 0 then
			for i, entry in ipairs(config.propertyCategories) do
				local bgcolor = Helper.defaultTitleBackgroundColor
				local color = Helper.color.white
				if entry.category == menu.propertyMode then
					bgcolor = Helper.defaultArrowRowBackgroundColor
				end
				local active = true
				if menu.mode == "selectCV" then
					active = entry.category == "propertyall"
				elseif (menu.mode == "selectComponent") and (menu.modeparam[3] == "deployables") then
					active = entry.category == "deployables"
					if active and (menu.selectedCols.propertytabs == nil) then
						menu.selectedCols.propertytabs = i
					end
				end
				row[i]:createButton({ height = menu.sideBarWidth, bgColor = bgcolor, mouseOverText = entry.name, scaling = false, helpOverlayID = entry.helpOverlayID, helpOverlayText = entry.helpOverlayText, active = active }):setIcon(entry.icon, { color = color})
				row[i].handlers.onClick = function () return menu.buttonPropertySubMode(entry.category, i) end
			end
		end
		local row = tabtable:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
		-- sorter row
		-- "sort by"
		row[1]:setColSpan(colSpanPerSorterColumn):createText(ReadText(1001, 2906) .. ReadText(1001, 120))
		local buttonheight = Helper.scaleY(config.mapRowHeight)
		-- "size"
		local sorterColumn = 2
		local tableColumn = (sorterColumn - 1) * colSpanPerSorterColumn + 1
		local button = row[tableColumn]:setColSpan(colSpanPerSorterColumn):createButton({ scaling = false, height = buttonheight }):setText(ReadText(1001, 8026), { halign = "center", scaling = true })
		if menu.propertySorterType == "class" then
			button:setIcon("table_arrow_inv_down", { width = buttonheight, height = buttonheight, x = button:getColSpanWidth() - buttonheight })
		elseif menu.propertySorterType == "classinverse" then
			button:setIcon("table_arrow_inv_up", { width = buttonheight, height = buttonheight, x = button:getColSpanWidth() - buttonheight })
		end
		row[tableColumn].handlers.onClick = function () return menu.buttonPropertySorter("class") end
		-- "name"
		sorterColumn = 3
		tableColumn = (sorterColumn - 1) * colSpanPerSorterColumn + 1
		local button = row[tableColumn]:setColSpan(colSpanPerSorterColumn):createButton({ scaling = false, height = buttonheight }):setText(ReadText(1001, 2809), { halign = "center", scaling = true })
		if menu.propertySorterType == "name" then
			button:setIcon("table_arrow_inv_down", { width = buttonheight, height = buttonheight, x = button:getColSpanWidth() - buttonheight })
		elseif menu.propertySorterType == "nameinverse" then
			button:setIcon("table_arrow_inv_up", { width = buttonheight, height = buttonheight, x = button:getColSpanWidth() - buttonheight })
		end
		row[tableColumn].handlers.onClick = function () return menu.buttonPropertySorter("name") end
		-- "hull"
		sorterColumn = 4
		tableColumn = (sorterColumn - 1) * colSpanPerSorterColumn + 1
		local button = row[tableColumn]:setColSpan(colSpanPerSorterColumn):createButton({ scaling = false, height = buttonheight }):setText(ReadText(1001, 1), { halign = "center", scaling = true })
		if menu.propertySorterType == "hull" then
			button:setIcon("table_arrow_inv_down", { width = buttonheight, height = buttonheight, x = button:getColSpanWidth() - buttonheight })
		elseif menu.propertySorterType == "hullinverse" then
			button:setIcon("table_arrow_inv_up", { width = buttonheight, height = buttonheight, x = button:getColSpanWidth() - buttonheight })
		end
		row[tableColumn].handlers.onClick = function () return menu.buttonPropertySorter("hull") end
	end
	-- kuertee end: re-written product categories and sorter table

	tabtable:setSelectedRow(menu.selectedRows.propertytabs or menu.selectedRows.infotable2 or 0)
	tabtable:setSelectedCol(menu.selectedCols.propertytabs or Helper.currentTableCol[menu.infoTable2] or 0)
	menu.selectedRows.propertytabs = nil
	menu.selectedCols.propertytabs = nil

	ftable.properties.y = tabtable.properties.y + tabtable:getFullHeight() + Helper.borderSize

	tabtable:addConnection(1, 2, true)
	ftable:addConnection(2, 2)
end
function newFuncs.createPropertyRow(instance, ftable, component, iteration, commanderlocation, showmodules, hidesubordinates, numdisplayed, sorter)
	local menu = mapMenu

	local maxicons = menu.infoTableData[instance].maxIcons

	local subordinates = menu.infoTableData[instance].subordinates[tostring(component)] or {}
	local dockedships = menu.infoTableData[instance].dockedships[tostring(component)] or {}
	local constructions = menu.infoTableData[instance].constructions[tostring(component)] or {}
	local convertedComponent = ConvertStringTo64Bit(tostring(component))

	-- kuertee start: callback
	if callbacks ["createPropertyRow_on_init_vars"] then
		local result
		for _, callback in ipairs (callbacks ["createPropertyRow_on_init_vars"]) do
			result = callback (maxicons, subordinates, dockedships, constructions, convertedComponent, iteration)
			if result then
				maxicons = result.maxicons
				subordinates = result.subordinates
				dockedships = result.dockedships
				constructions = result.constructions
				convertedComponent = result.convertedComponent
				iteration = result.iteration
			end
		end
	end
	-- kuertee end: callback

	if (#menu.searchtext == 0) or Helper.textArrayHelper(menu.searchtext, function (numtexts, texts) return C.FilterComponentByText(convertedComponent, numtexts, texts, true) end, "text") then
		if (menu.mode == "orderparam_object") and (not menu.checkForOrderParamObject(convertedComponent)) then
			return numdisplayed
		elseif (menu.mode == "selectComponent") and (not menu.checkForSelectComponent(convertedComponent)) then
			return numdisplayed
		end

		numdisplayed = numdisplayed + 1

		if (not menu.isPropertyExtended(tostring(component))) and (menu.isCommander(component) or menu.isConstructionContext(convertedComponent)) then
			menu.extendedproperty[tostring(component)] = true
		end
		if (not menu.isPropertyExtended(tostring(component))) and menu.isDockContext(convertedComponent) then

			-- if menu.infoTableMode ~= "propertyowned" then
			-- kuertee start: callback
			if not string.find (menu.infoTableMode, "propertyowned") then
			-- kuertee end: callback

				menu.extendedproperty[tostring(component)] = true
			end
		end

		local isstation = IsComponentClass(component, "station")
		local isdoublerow = (iteration == 0 and (isstation or #subordinates > 0))
		local name, color, bgcolor, font, mouseover, factioncolor = menu.getContainerNameAndColors(component, iteration, isdoublerow, false)
		local alertString = ""
		local alertMouseOver = ""
		if menu.getFilterOption("layer_think") then
			local alertStatus, missionlist = menu.getContainerAlertLevel(component)
			local minAlertLevel = menu.getFilterOption("think_alert")
			if (minAlertLevel ~= 0) and alertStatus >= minAlertLevel then
				local color = Helper.color.white
				if alertStatus == 1 then
					color = menu.holomapcolor.lowalertcolor
				elseif alertStatus == 2 then
					color = menu.holomapcolor.mediumalertcolor
				else
					color = menu.holomapcolor.highalertcolor
				end
				alertString = Helper.convertColorToText(color) .. "\027[workshop_error]\027X"
				alertMouseOver = ReadText(1001, 3305) .. ReadText(1001, 120) .. "\n" .. missionlist
			end
		end
		local location, locationtext, isdocked, aipilot, isplayerowned, isonlineobject, iscovered, isenemy, macro = GetComponentData(component, "sectorid", "sector", "isdocked", "assignedaipilot", "isplayerowned", "isonlineobject", "iscovered", "isenemy", "macro")
		if isplayerowned and iscovered then
			alertString = alertString .. factioncolor .. "\27[menu_hidden]\27X"
		end

		if menu.mode == "selectCV" then
			if isenemy then
				mouseover = "\027R" .. ReadText(1026, 8014) .. "\027X"
			elseif C.IsBuilderBusy(convertedComponent) then
				mouseover = "\027R" .. ReadText(1001, 7939) .. "\027X"
			elseif not isplayerowned then
				local fee = tonumber(C.GetBuilderHiringFee())
				mouseover = ((fee > GetPlayerMoney()) and "\027R" or "\027G") .. ReadText(1001, 7940) .. ReadText(1001, 120) .. " " .. ConvertMoneyString(fee, false, true, nil, true) .. " " .. ReadText(1001, 101) .. "\027X"
			end
		end

		local row = ftable:addRow({"property", component, nil, iteration}, { bgColor = bgcolor, multiSelected = menu.isSelectedComponent(component) })
		if (menu.getNumSelectedComponents() == 1) and menu.isSelectedComponent(component) then
			menu.setrow = row.index
		end
		if IsSameComponent(component, menu.highlightedbordercomponent) then
			menu.sethighlightborderrow = row.index
		end

		-- Set up columns
		--  [+/-] [Object Name] [Top Level Shield/Hull Bar] [Location] [Sub_1] [Sub_2] [Sub_3] ... [Sub_N or Shield/Hull Bar]
		if showmodules or (subordinates.hasRendered and (not hidesubordinates)) or (#dockedships > 0) or (isstation and (#constructions > 0)) then
			row[1]:createButton({ scaling = false }):setText(menu.isPropertyExtended(tostring(component)) and "-" or "+", { scaling = true, halign = "center" })
			row[1].handlers.onClick = function () return menu.buttonExtendProperty(tostring(component)) end
		end

		local displaylocation = location and not (commanderlocation and IsSameComponent(location, commanderlocation))
		local currentordericon, currentorderrawicon, currentordercolor, currentordername, currentorderisoverride, currentordermouseovertext = "", "", nil, "", false
		if IsComponentClass(component, "ship") then
			currentordericon, currentorderrawicon, currentordercolor, currentordername, currentorderisoverride, currentordermouseovertext = menu.getOrderInfo(convertedComponent)
		end
		local fleettypes = IsComponentClass(component, "controllable") and menu.getPropertyOwnedFleetData(instance, component, maxicons) or {}

		if isplayerowned and isonlineobject then
			locationtext = Helper.convertColorToText(menu.holomapcolor.visitorcolor) .. ReadText(1001, 11231) .. "\27X"
			currentordericon = Helper.convertColorToText(menu.holomapcolor.visitorcolor) .. "\27[order_venture]\27X"
			currentorderrawicon = "order_venture"
			currentordercolor = menu.holomapcolor.visitorcolor
			currentordername = ReadText(1001, 7868)
			currentordermouseovertext = nil
			isdocked = false
		end

		-- kuertee start: callback
		if callbacks ["createPropertyRow_on_set_locationtext"] then
			local result
			for _, callback in ipairs (callbacks ["createPropertyRow_on_set_locationtext"]) do
				result = callback (locationtext, component)
				if result then
					locationtext = result.locationtext
				end
			end
		end
		-- kuertee end: callback

		local namecolspan = 1
		if menu.infoTableMode == "objectlist" then
			displaylocation = false
		end
		if not displaylocation then
			if (currentordericon ~= "") or isdocked then
				namecolspan = namecolspan + maxicons - 2
			else
				namecolspan = namecolspan + maxicons
			end
		end

		if isdoublerow then
			if isstation then
				-- station case
				local secondline = ""
				if displaylocation then
					secondline = locationtext
				end
				row[2]:setColSpan(4 + maxicons - #fleettypes - 1)
				local stationname = alertString .. Helper.convertColorToText(color) .. name .. "\27X"
				local stationnametruncated = TruncateText(stationname, font, Helper.scaleFont(font, config.mapFontSize), row[2]:getColSpanWidth() - Helper.scaleX(Helper.standardTextOffsetx))
				if stationnametruncated ~= stationname then
					mouseover = stationname .. ((mouseover ~= "") and ("\n" .. mouseover) or "")
				end
				if alertMouseOver ~= "" then
					if mouseover ~= "" then
						mouseover = mouseover .. "\n\n"
					end
					mouseover = mouseover .. alertMouseOver
				end
				row[2]:createText(stationname .. "\n" .. secondline, { font = font, mouseOverText = mouseover })
			else
				-- fleet case
				local textheight = C.GetTextHeight(" \n ", font, Helper.scaleFont(font, config.mapFontSize), Helper.viewWidth)
				local icon = row[2]:setColSpan(4 + maxicons - #fleettypes - 1):createIcon("solid", { scaling = false, color = { r = 0, g = 0, b = 0, a = 1 }, height = textheight })
				
				local secondtext1 = ""
				local secondtext2 = ""
				if displaylocation or (currentordericon ~= "") or isdocked then
					if displaylocation then
						secondtext1 = locationtext
					end
					secondtext2 = (currentordericon ~= "") and currentordericon or ""
					if isdocked then
						secondtext2 = secondtext2 .. " \27[order_dockat]"
					end
				end
				secondtext1truncated = TruncateText(secondtext1, font, Helper.scaleFont(font, config.mapFontSize), icon:getColSpanWidth() - Helper.scaleX(Helper.standardTextOffsetx))
				local secondtext1width = C.GetTextWidth(secondtext1truncated, font, Helper.scaleFont(font, config.mapFontSize))
				local secondtext2width = C.GetTextWidth(secondtext2, font, Helper.scaleFont(font, config.mapFontSize))

				local fleetname = ffi.string(C.GetFleetName(convertedComponent))
				local shipname = alertString .. name
				local fleetnametruncated = TruncateText(fleetname, font, Helper.scaleFont(font, config.mapFontSize), icon:getColSpanWidth() - Helper.scaleX(Helper.standardTextOffsetx) - secondtext1width - Helper.scaleX(10))
				local shipnametruncated = TruncateText(shipname, font, Helper.scaleFont(font, config.mapFontSize), icon:getColSpanWidth() - Helper.scaleX(Helper.standardTextOffsetx) - secondtext2width - Helper.scaleX(10))

				local mouseovertext = ""
				if fleetnametruncated ~= fleetname then
					mouseovertext = mouseovertext .. fleetname
				end
				if shipnametruncated ~= shipname then
					if mouseovertext ~= "" then
						mouseovertext = mouseovertext .. "\n"
					end
					mouseovertext = mouseovertext .. alertString .. Helper.convertColorToText(color) .. name .. "\27X"
				end
				if secondtext1truncated ~= secondtext1 then
					if mouseovertext ~= "" then
						mouseovertext = mouseovertext .. "\n"
					end
					mouseovertext = mouseovertext .. secondtext1
				end
				if currentordername ~= "" then
					if mouseovertext ~= "" then
						mouseovertext = mouseovertext .. "\n"
					end
					mouseovertext = mouseovertext .. currentordername .. (currentordermouseovertext and ("\n\27R" .. currentordermouseovertext .. "\27X") or "")
				end
				if alertMouseOver ~= "" then
					if mouseovertext ~= "" then
						mouseovertext = mouseovertext .. "\n\n"
					end
					mouseovertext = mouseovertext .. alertMouseOver
				end
				icon.properties.mouseOverText = mouseovertext

				icon:setText(string.format("%s\n%s%s", fleetnametruncated, Helper.convertColorToText(color), shipnametruncated), { scaling = true, font = font, x = Helper.standardTextOffsetx })
				icon:setText2(currentorderisoverride and function () return menu.overrideOrderIcon(currentordercolor, true, currentorderrawicon, secondtext1truncated .. "\n", isdocked and "\27[order_dockat]" or "") end or (secondtext1truncated .. "\n" .. secondtext2), { scaling = true, font = font, halign = "right", x = Helper.standardTextOffsetx })
			end
			-- fleet info
			for i, fleetdata in ipairs(fleettypes) do
				local colidx = 5 + maxicons - #fleettypes + i - 1
				if fleetdata.icon then
					row[colidx]:createText(string.format("\027[%s]\n%d", fleetdata.icon, fleetdata.count), { halign = "center", x = 0 })
				else
					row[colidx]:createText(string.format("...\n%d", fleetdata.count), { halign = "center", x = 0 })
				end
			end
			-- shieldhullbar
			row[5 + maxicons]:createObjectShieldHullBar(component, { y = isstation and Helper.standardTextHeight / 2 or 1.5 * Helper.standardTextHeight })
		else
			-- unassigned ship case
			row[2]:setColSpan(namecolspan + 1)
			local indentation, actualname = string.match(name, "([ ]*)(.*)")
			local shipname = indentation .. alertString .. actualname
			local shipnametruncated = TruncateText(shipname, font, Helper.scaleFont(font, config.mapFontSize), row[2]:getColSpanWidth() - Helper.scaleX(Helper.standardTextOffsetx))
			if shipnametruncated ~= shipname then
				mouseover = indentation .. alertString .. actualname .. "\27X" .. ((mouseover ~= "") and ("\n" .. mouseover) or "")
			end
			if alertMouseOver ~= "" then
				if mouseover ~= "" then
					mouseover = mouseover .. "\n\n"
				end
				mouseover = mouseover .. alertMouseOver
			end

			-- row[2]:createText(shipname, { font = font, color = color, mouseOverText = mouseover })
			-- kuertee start: callback
			if not callbacks ["createPropertyRow_override_row_shipname_createText"] then
				row[2]:createText(shipname, { font = font, color = color, mouseOverText = mouseover })
			else
				local result
				for _, callback in ipairs (callbacks ["createPropertyRow_override_row_shipname_createText"]) do
					result = callback (shipname, { font = font, color = color, mouseOverText = mouseover }, component)
					if result then
						row[2]:createText(result.shipname, result.properties)
					end
				end
				if not result then
					row[2]:createText(shipname, { font = font, color = color, mouseOverText = mouseover })
				end
			end
			-- kuertee end: callback

			-- location / order
			if displaylocation then
				local colspan = 5 + maxicons - 3 - namecolspan
				if currentordericon ~= "" then
					colspan = colspan - 1
				end
				if isdocked then
					colspan = colspan - 1
				end
				row[3 + namecolspan]:setColSpan(colspan)
				local locationtexttruncated = TruncateText(locationtext, font, Helper.scaleFont(font, config.mapFontSize), row[3 + namecolspan]:getColSpanWidth())
				local mouseovertext = ""
				if locationtexttruncated ~= locationtext then
					mouseovertext = locationtext
				end

				-- row[3 + namecolspan]:createText(locationtext, { halign = "right", font = font, mouseOverText = mouseovertext, x = 0 })
				-- kuertee start: callback
				if not callbacks ["createPropertyRow_override_row_location_createText"] then
					row[3 + namecolspan]:createText(locationtext, { halign = "right", font = font, mouseOverText = mouseovertext, x = 0 })
				else
					local result
					for _, callback in ipairs (callbacks ["createPropertyRow_override_row_location_createText"]) do
						result = callback (locationtext, {halign = "right", font = font, mouseOverText = mouseovertext, x = 0}, component)
						if result then
							row[3 + namecolspan]:createText(result.locationtext, result.properties)
						end
					end
					if not result then
						row[3 + namecolspan]:createText(locationtext, { halign = "right", font = font, mouseOverText = mouseovertext, x = 0 })
					end
				end
				-- kuertee end: callback

			end
			if (currentordericon ~= "") or isdocked then
				if isdocked then
					row[4 + maxicons]:createIcon("order_dockat", { width = config.mapRowHeight, height = config.mapRowHeight, mouseOverText = ReadText(1001, 3249) })
					if currentordericon ~= "" then
						row[3 + maxicons]:createIcon(currentorderrawicon, { color = currentorderisoverride and function () return menu.overrideOrderIcon(currentordercolor, false) end or currentordercolor, width = config.mapRowHeight, height = config.mapRowHeight, mouseOverText = currentordername .. (currentordermouseovertext and ("\n\27R" .. currentordermouseovertext .. "\27X") or "") })
					end
				else
					row[4 + maxicons]:createIcon(currentorderrawicon, { color = currentorderisoverride and function () return menu.overrideOrderIcon(currentordercolor, false) end or currentordercolor, width = config.mapRowHeight, height = config.mapRowHeight, mouseOverText = currentordername .. (currentordermouseovertext and ("\n\27R" .. currentordermouseovertext .. "\27X") or "") })
				end
			end
			-- shieldhullbar
			row[5 + maxicons]:createObjectShieldHullBar(component)
		end

		if row[1].type == "button" then
			if isdoublerow and (not isstation) then
				row[1].properties.height = row[2]:getHeight()
			else
				row[1].properties.height = row[2]:getMinTextHeight(true)
			end
		end

		if IsComponentClass(component, "station") then
			AddKnownItem("stationtypes", macro)
		elseif IsComponentClass(component, "ship_xl") then
			AddKnownItem("shiptypes_xl", macro)
		elseif IsComponentClass(component, "ship_l") then
			AddKnownItem("shiptypes_l", macro)
		elseif IsComponentClass(component, "ship_m") then
			AddKnownItem("shiptypes_m", macro)
		elseif GetMacroData(macro, "islasertower") then
			AddKnownItem("lasertowers", macro)
		elseif IsComponentClass(component, "ship_s") then
			AddKnownItem("shiptypes_s", macro)
		elseif IsComponentClass(component, "ship_xs") then
			AddKnownItem("shiptypes_xs", macro)
		end

		if menu.isPropertyExtended(tostring(component)) then
			-- modules
			if showmodules then
				menu.createModuleSection(instance, ftable, component, iteration)
			end
			-- subordinates
			if subordinates.hasRendered and (not hidesubordinates) then
				numdisplayed = menu.createSubordinateSection(instance, ftable, component, isstation, iteration, location or commanderlocation, numdisplayed, sorter)
			end
			-- dockedships
			if #dockedships > 0 then
				local isdockedshipsextended = menu.isDockedShipsExtended(tostring(component), isstation)
				if (not isdockedshipsextended) and menu.isDockContext(convertedComponent) then

					-- if menu.infoTableMode ~= "propertyowned" then
					-- kuertee start: callback
					if not string.find (menu.infoTableMode, "propertyowned") then
					-- kuertee end: callback

						menu.extendeddockedships[tostring(component)] = true
						isdockedshipsextended = true
					end
				end

				local row = ftable:addRow({"dockedships", component}, { bgColor = Helper.color.transparent })
				row[1]:createButton():setText(isdockedshipsextended and "-" or "+", { halign = "center" })
				row[1].handlers.onClick = function () return menu.buttonExtendDockedShips(tostring(component), isstation) end
				local text = ReadText(1001, 3265)
				for i = 1, iteration + 1 do
					text = "    " .. text
				end
				row[2]:setColSpan(3):createText(text)
				if IsSameComponent(component, menu.highlightedbordercomponent) and (menu.highlightedborderstationcategory == "dockedships") then
					menu.sethighlightborderrow = row.index
				end
				if isdockedshipsextended then
					dockedships = menu.sortComponentListHelper(dockedships, sorter)
					for _, dockedship in ipairs(dockedships) do
						numdisplayed = menu.createPropertyRow(instance, ftable, dockedship, iteration + 2, location or commanderlocation, nil, true, numdisplayed, sorter)
					end
				end
			end
			if isstation then
				-- construction
				if #constructions > 0 then
					menu.createConstructionSubSection(ftable, component, constructions)
				end
			end
		end
	end

	return numdisplayed
end
-- kuertee start: show mission progress
newFuncs.missionProgress = {}
-- kuertee end: show mission progress
function newFuncs.createMissionMode(frame)
	local menu = mapMenu
	-- kuertee start: show mission progress
	newFuncs.missionProgress = {}
	-- kuertee end: show mission progress

	menu.setrow = 3
	menu.missionDoNotUpdate = true

	if menu.infoTableMode == "missionoffer" then
		menu.updateMissionOfferList()
	elseif menu.infoTableMode == "mission" then
		menu.updateMissions()

		if menu.missionMode == menu.activeMissionMode then
			if menu.highlightLeftBar[menu.infoTableMode] then
				menu.highlightLeftBar[menu.infoTableMode] = nil
				menu.refreshMainFrame = true
			end
		end
	end

	local ftable = frame:addTable(9 , { tabOrder = 1 })
	ftable:addConnection(1, 2, true)
	ftable:setDefaultCellProperties("text", { minRowHeight = config.mapRowHeight, fontsize = config.mapFontSize })
	ftable:setDefaultCellProperties("button", { height = config.mapRowHeight })
	ftable:setDefaultComplexCellProperties("button", "text", { fontsize = config.mapFontSize })

	ftable:setColWidth(1, Helper.scaleY(config.mapRowHeight), false)
	ftable:setColWidth(2, Helper.scaleY(config.mapRowHeight), false)
	-- in smaller resolutions, e.g. 1280x720, this can get negative due to different scalings used (this would be solved if we unify the scaling support as planned)
	ftable:setColWidth(3, math.max(1, menu.sideBarWidth - 2 * (Helper.scaleY(config.mapRowHeight) + Helper.borderSize)), false)
	ftable:setColWidth(4, menu.sideBarWidth / 2, false)
	ftable:setColWidth(5, menu.sideBarWidth / 2 - Helper.borderSize, false)
	ftable:setColWidth(6, menu.sideBarWidth, false)
	ftable:setColWidth(7, menu.sideBarWidth, false)
	ftable:setColWidthPercent(9, 20)

	ftable:setDefaultBackgroundColSpan(2, 8)

	local title = ""

	if menu.infoTableMode == "mission" then
		local row = ftable:addRow("tabs", { fixed = true, bgColor = Helper.color.transparent })
		if menu.missionModeCurrent == "tabs" then
			menu.setrow = row.index
		else
			menu.setcol = nil
		end
		local categories = (menu.infoTableMode == "missionoffer") and config.missionOfferCategories or config.missionCategories
		local index = 1
		for _, entry in ipairs(categories) do
			if entry.showtab ~= false then
				local colindex = index
				if index == 1 then
					row[colindex]:setColSpan(3)
				elseif index == 2 then
					colindex = colindex + 2
					row[colindex]:setColSpan(2)
				else
					colindex = colindex + 3
				end

				local bgcolor = Helper.defaultTitleBackgroundColor
				local color = Helper.color.white
				if menu.infoTableMode == "missionoffer" then
					if entry.category == menu.missionOfferMode then
						title = entry.name
						bgcolor = Helper.defaultArrowRowBackgroundColor
					end
				else
					if entry.category == menu.missionMode then
						title = entry.name
						bgcolor = Helper.defaultArrowRowBackgroundColor
						if menu.missionModeCurrent == "tabs" then
							if menu.setcol == nil then
								menu.setcol = colindex
							end
						end
					end
					if entry.category == menu.activeMissionMode then
						color = Helper.color.mission
					end
				end

				row[colindex]:createButton({ height = menu.sideBarWidth, bgColor = bgcolor, mouseOverText = entry.name, scaling = false, helpOverlayID = entry.helpOverlayID, helpOverlayText = entry.helpOverlayText }):setIcon(entry.icon, { color = color})
				if menu.infoTableMode == "missionoffer" then
					row[colindex].handlers.onClick = function () return menu.buttonMissionOfferSubMode(entry.category, colindex) end
				else
					row[colindex].handlers.onClick = function () return menu.buttonMissionSubMode(entry.category, colindex) end
				end
				index = index + 1
			end
		end
	end

	if menu.infoTableMode == "missionoffer" then
		local found = false
		-- important
		if #menu.missionOfferList["plot"] > 0 then
			local row = ftable:addRow(nil, { bgColor = Helper.defaultTitleBackgroundColor })
			row[1]:setColSpan(9):createText(ReadText(1001, 3340), Helper.headerRowCenteredProperties)
			for _, entry in ipairs(menu.missionOfferList["plot"]) do
				found = true
				menu.addMissionRow(ftable, entry)
			end
			if not found then
				local row = ftable:addRow("plotnone", { bgColor = Helper.color.transparent, interactive = false })
				if menu.missionModeCurrent == "plotnone" then
					menu.setrow = row.index
				end
				row[1]:setColSpan(9):createText("--- " .. ReadText(1001, 3302) .. " ---", { halign = "center" })
			end
		end
		-- guild
		found = false
		local row = ftable:addRow(nil, { bgColor = Helper.defaultTitleBackgroundColor })
		row[1]:setColSpan(9):createText(ReadText(1001, 3331), Helper.headerRowCenteredProperties)

		-- kuertee start: callback
		if callbacks ["createMissionMode_on_missionoffer_guild_start"] then
			for _, callback in ipairs (callbacks ["createMissionMode_on_missionoffer_guild_start"]) do
				callback (ftable)
			end
		end
		-- kuertee end: callback

		for _, data in ipairs(menu.missionOfferList["guild"]) do
			if #data.missions > 0 then
				found = true

				-- check if we need to expand for the current selected mission
				for _, entry in ipairs(data.missions) do
					if entry.ID == menu.missionModeCurrent then
						menu.expandedMissionGroups[data.id] = true
					end
				end

				local isexpanded = menu.expandedMissionGroups[data.id] ~= false
				local row = ftable:addRow(data.id, { bgColor = Helper.color.transparent })
				if data.id == menu.missionModeCurrent then
					menu.setrow = row.index
				end
				row[1]:createButton():setText(isexpanded and "-" or "+", { halign = "center" })
				row[1].handlers.onClick = function () return menu.buttonExpandMissionGroup(data.id, row.index) end
				row[2]:setColSpan(7):createText(data.name)
				row[9]:createText((#data.missions == 1) and ReadText(1001, 3335) or string.format(ReadText(1001, 3336), #data.missions), { halign = "right" })
			
				if isexpanded then
					for _, entry in ipairs(data.missions) do
						menu.addMissionRow(ftable, entry, 1)
					end
				end
			end
		end
		if not found then
			local row = ftable:addRow("guildnone", { bgColor = Helper.color.transparent, interactive = false })
			if menu.missionModeCurrent == "guildnone" then
				menu.setrow = row.index
			end
			row[1]:setColSpan(9):createText("--- " .. ReadText(1001, 3302) .. " ---", { halign = "center" })
		end
		-- other
		found = false
		local row = ftable:addRow(nil, { bgColor = Helper.defaultTitleBackgroundColor })
		row[1]:setColSpan(9):createText(ReadText(1001, 3332), Helper.headerRowCenteredProperties)
		for _, entry in ipairs(menu.missionOfferList["other"]) do
			found = true
			menu.addMissionRow(ftable, entry)
		end
		if not found then
			local row = ftable:addRow("othernone", { bgColor = Helper.color.transparent, interactive = false })
			if menu.missionModeCurrent == "othernone" then
				menu.setrow = row.index
			end
			row[1]:setColSpan(9):createText("--- " .. ReadText(1001, 3302) .. " ---", { halign = "center" })
		end
	elseif menu.infoTableMode == "mission" then
		local found = false

		-- kuertee start: callback
		if callbacks ["createMissionMode_replaceMissionModeCurrent"] then
			local oldMissionModeCurrent = menu.missionModeCurrent
			for _, callback in ipairs (callbacks ["createMissionMode_replaceMissionModeCurrent"]) do
				menu.missionModeCurrent = callback (menu.missionModeCurrent)
				if menu.missionModeCurrent ~= oldMissionModeCurrent then
					-- break immediately if changed
					break
				end
			end
		end
		-- kuertee end: callback

		if menu.missionMode == "plot" then
			-- important
			local row = ftable:addRow(nil, { bgColor = Helper.defaultTitleBackgroundColor })
			row[1]:setColSpan(9):createText(ReadText(1001, 3341), Helper.headerRowCenteredProperties)
			local hadThreadMission = false
			for _, entry in ipairs(menu.missionList["plot"]) do
				found = true
				if entry.threadtype ~= "" then
					hadThreadMission = true
				end
				if hadThreadMission and (entry.threadtype == "") then
					-- first non thread mission after threads
					hadThreadMission = false
					local row = ftable:addRow(false, { bgColor = Helper.color.transparent })
					row[1]:setColSpan(9):createText("")
				end
				menu.addMissionRow(ftable, entry)
			end
			if not found then
				local row = ftable:addRow("plotnone", { bgColor = Helper.color.transparent, interactive = false })
				if menu.missionModeCurrent == "plotnone" then
					menu.setrow = row.index
				end
				row[1]:setColSpan(9):createText("--- " .. ReadText(1001, 3302) .. " ---", { halign = "center" })
			end
			-- guild
			local row = ftable:addRow(nil, { bgColor = Helper.defaultTitleBackgroundColor })
			row[1]:setColSpan(9):createText(ReadText(1001, 3333), Helper.headerRowCenteredProperties)
			found = false
			for _, data in ipairs(menu.missionList["guild"]) do
				found = true

				-- check if we need to expand for the current selected mission
				for _, entry in ipairs(data.missions) do
					if entry.ID == menu.missionModeCurrent then
						menu.expandedMissionGroups[data.id] = true
					end
					for i, submission in ipairs(entry.subMissions) do
						if submission.ID == menu.missionModeCurrent then
							menu.expandedMissionGroups[data.id] = true
							menu.expandedMissionGroups[entry.ID] = true
						end
					end
				end

				local isexpanded = menu.expandedMissionGroups[data.id]
				local row = ftable:addRow(data.id, { bgColor = Helper.color.transparent })
				if data.id == menu.missionModeCurrent then
					menu.setrow = row.index
				end

				local color = Helper.color.white
				if data.active then
					color = Helper.color.mission
				end

				row[1]:createButton():setText(isexpanded and "-" or "+", { halign = "center" })
				row[1].handlers.onClick = function () return menu.buttonExpandMissionGroup(data.id, row.index) end
				row[2]:setColSpan(7):createText(data.name, { color = color, font = font })
				row[9]:createText((#data.missions == 1) and ReadText(1001, 3337) or string.format(ReadText(1001, 3338), #data.missions), { halign = "right", color = color })
			
				if isexpanded then
					local hadThreadMission = false
					for _, entry in ipairs(data.missions) do
						if entry.threadtype ~= "" then
							hadThreadMission = true
						end
						if hadThreadMission and (entry.threadtype == "") then
							-- first non thread mission after threads
							hadThreadMission = false
							local row = ftable:addRow(false, { bgColor = Helper.color.transparent })
							row[1]:setColSpan(9):createText("")
						end
						menu.addMissionRow(ftable, entry, 1)
					end
				end
			end
			if not found then
				local row = ftable:addRow("guildnone", { bgColor = Helper.color.transparent, interactive = false })
				if menu.missionModeCurrent == "guildnone" then
					menu.setrow = row.index
				end
				row[1]:setColSpan(9):createText("--- " .. ReadText(1001, 3302) .. " ---", { halign = "center" })
			end
			-- other
			local row = ftable:addRow(nil, { bgColor = Helper.defaultTitleBackgroundColor })
			row[1]:setColSpan(9):createText(ReadText(1001, 3334), Helper.headerRowCenteredProperties)
			found = false
			local hadThreadMission = false
			for _, entry in ipairs(menu.missionList["other"]) do
				found = true
				if entry.threadtype ~= "" then
					hadThreadMission = true
				end
				if hadThreadMission and (entry.threadtype == "") then
					-- first non thread mission after threads
					hadThreadMission = false
					local row = ftable:addRow(false, { bgColor = Helper.color.transparent })
					row[1]:setColSpan(9):createText("")
				end
				menu.addMissionRow(ftable, entry)
			end
			if not found then
				local row = ftable:addRow("othernone", { bgColor = Helper.color.transparent, interactive = false })
				if menu.missionModeCurrent == "othernone" then
					menu.setrow = row.index
				end
				row[1]:setColSpan(9):createText("--- " .. ReadText(1001, 3302) .. " ---", { halign = "center" })
			end
			found = true
			-- online
			if #menu.missionList["coalition"] > 0 then
				local row = ftable:addRow(nil, { bgColor = Helper.defaultTitleBackgroundColor })
				row[1]:setColSpan(9):createText(ReadText(1001, 11609), Helper.headerRowCenteredProperties)
				for _, entry in ipairs(menu.missionList["coalition"]) do
					menu.addMissionRow(ftable, entry)
				end
			end
		elseif menu.missionMode == "upkeep" then
			-- title
			local row = ftable:addRow(false, { fixed = true, bgColor = Helper.defaultTitleBackgroundColor })
			row[1]:setColSpan(9):createText(title, Helper.headerRowCenteredProperties)
			for containeridstring, data in pairs(menu.missionList[menu.missionMode]) do
				found = true

				-- check if we need to expand for the current selected mission
				for _, entry in ipairs(data.missions) do
					if entry.ID == menu.missionModeCurrent then
						menu.expandedMissionGroups[containeridstring] = true
					end
					for i, submission in ipairs(entry.subMissions) do
						if submission.ID == menu.missionModeCurrent then
							menu.expandedMissionGroups[containeridstring] = true
							menu.expandedMissionGroups[entry.ID] = true
						end
					end
				end

				local isexpanded = menu.expandedMissionGroups[containeridstring]
				local row = ftable:addRow(containeridstring, { bgColor = Helper.color.transparent })
				if containeridstring == menu.missionModeCurrent then
					menu.setrow = row.index
				end

				local color = Helper.color.white
				if data.active then
					color = Helper.color.mission
				end

				row[1]:createButton():setText(isexpanded and "-" or "+", { halign = "center" })
				row[1].handlers.onClick = function () return menu.buttonExpandMissionGroup(containeridstring, row.index) end
				local container = ConvertStringTo64Bit(containeridstring)
				row[2]:setColSpan(7):createText(ffi.string(C.GetComponentName(container)) .. " (" .. ffi.string(C.GetObjectIDCode(container)) .. ")" , { color = color })
				row[9]:createText((#data.missions == 1) and ReadText(1001, 3337) or string.format(ReadText(1001, 3338), #data.missions), { halign = "right", color = color })
			
				if isexpanded then
					local hadThreadMission = false
					for _, entry in ipairs(data.missions) do
						if entry.threadtype ~= "" then
							hadThreadMission = true
						end
						if hadThreadMission and (entry.threadtype == "") then
							-- first non thread mission after threads
							hadThreadMission = false
							local row = ftable:addRow(false, { bgColor = Helper.color.transparent })
							row[1]:setColSpan(9):createText("")
						end
						menu.addMissionRow(ftable, entry, 1)
					end
				end
			end
		else
			-- title
			local row = ftable:addRow(false, { fixed = true, bgColor = Helper.defaultTitleBackgroundColor })
			row[1]:setColSpan(9):createText(title, Helper.headerRowCenteredProperties)
			local hadThreadMission = false
			for _, entry in ipairs(menu.missionList[menu.missionMode]) do
				found = true
				if entry.threadtype ~= "" then
					hadThreadMission = true
				end
				if hadThreadMission and (entry.threadtype == "") then
					-- first non thread mission after threads
					hadThreadMission = false
					local row = ftable:addRow(false, { bgColor = Helper.color.transparent })
					row[1]:setColSpan(9):createText("")
				end
				menu.addMissionRow(ftable, entry)
			end
		end
		if not found then
			local row = ftable:addRow("othernone", { bgColor = Helper.color.transparent, interactive = false })
			if menu.missionModeCurrent == "othernone" then
				menu.setrow = row.index
			end
			row[1]:setColSpan(9):createText("--- " .. ReadText(1001, 3302) .. " ---", { halign = "center" })
		end
	end

	ftable:setTopRow(menu.settoprow)
	ftable:setSelectedRow(menu.setrow)
	ftable:setSelectedCol(menu.setcol or 0)
	menu.setrow = nil
	menu.settoprow = nil
	menu.setcol = nil
end
function newFuncs.getMissionInfoHelper(mission)
	local menu = mapMenu

	local missionID, name, description, difficulty, threadtype, maintype, subtype, subtypename, faction, reward, rewardtext, _, _, _, _, _, missiontime, _, abortable, disableguidance, associatedcomponent, upkeepalertlevel, hasobjective, threadmissionid = GetMissionDetails(mission)
	local missionid64 = ConvertIDTo64Bit(missionID)
	local missionGroup = C.GetMissionGroupDetails(missionid64)
	local groupID, groupName = ffi.string(missionGroup.id), ffi.string(missionGroup.name)
	local onlineinfo = C.GetMissionOnlineInfo(missionid64)
	local onlinechapter, onlineid = ffi.string(onlineinfo.chapter), ffi.string(onlineinfo.onlineid)
	local objectiveText, timeout, progressname, curProgress, maxProgress = GetMissionObjective(mission)
	local subMissions, buf = {}, {}
	local subactive = false
	Helper.ffiVLA(buf, "MissionID", C.GetNumMissionThreadSubMissions, C.GetMissionThreadSubMissions, missionid64)
	for _, submission in ipairs(buf) do
		local submissionEntry = menu.getMissionIDInfoHelper(submission)
		table.insert(subMissions, submissionEntry)
		if submissionEntry.active then
			subactive = true
		end
	end
	local entry = {
		["active"] = (mission == GetActiveMission()) or subactive,
		["name"] = name,
		["description"] = description,
		["difficulty"] = difficulty,
		["missionGroup"] = { id = groupID, name = groupName },
		["threadtype"] = threadtype,
		["maintype"] = maintype,
		["type"] = subtype,
		["faction"] = faction,
		["reward"] = reward,
		["rewardtext"] = rewardtext,
		["duration"] = (timeout and timeout ~= -1) and timeout or (missiontime or -1),		-- timeout can be nil, if mission has no objective
		["ID"] = tostring(missionid64),
		["associatedcomponent"] = ConvertIDTo64Bit(associatedcomponent),
		["abortable"] = abortable,
		["threadMissionID"] = ConvertIDTo64Bit(threadmissionid) or 0,
		["subMissions"] = subMissions,
		["onlinechapter"] = onlinechapter,
		["onlineID"] = onlineid,
	}

	-- kuertee start: show mission progress
	newFuncs.missionProgress [tostring (missionid64)] = {
		["objectiveText"] = objectiveText,
		["progressname"] = progressname,
		["curProgress"] = curProgress,
		["maxProgress"] = maxProgress,
	}
	-- kuertee end: show mission progress

	return entry
end
function newFuncs.createSideBar(firsttime, frame, width, height, offsetx, offsety)
	local menu = mapMenu

	-- kuertee start: callback
	if callbacks ["createSideBar_on_start"] then
		for _, callback in ipairs (callbacks ["createSideBar_on_start"]) do
			callback (config)
		end
	end
	-- kuertee end: callback

	-- start Forleyor_infoCenter Callback:
	if callbacks ["ic_createSideBar"] then
		for _, callback in ipairs (callbacks ["ic_createSideBar"]) do
			callback (config)
		end
	end
	-- end Forleyor_infoCenter:

	local spacingHeight = menu.sideBarWidth / 4
	local ftable = frame:addTable(1, { tabOrder = 3, width = width, height = height, x = offsetx, y = offsety, scaling = false, borderEnabled = false, reserveScrollBar = false, defaultInteractiveObject = menu.infoTableMode == nil })
	ftable:addConnection(1, 1, true)

	local firstactive, foundselection
	local leftbar = menu.showMultiverse and config.leftBarMultiverse or config.leftBar
	for _, entry in ipairs(leftbar) do
		if (entry.condition == nil) or entry.condition() then
			if not entry.spacing then
				entry.active = true
				if menu.showMultiverse then
					if entry.mode ~= "ventureseason" then
						local isonline = Helper.isOnlineGame()
						entry.active = isonline
					end
				else
					if menu.mode == "selectCV" then

						-- if (entry.mode ~= "objectlist") and (entry.mode ~= "propertyowned") then
						-- kuertee start: callback
						if (not string.find (entry.mode, "objectlist")) and (not string.find (entry.mode, "propertyowned")) then
						-- kuertee end: callback

							entry.active = false
						end
					elseif menu.mode == "hire" then

						-- if entry.mode ~= "propertyowned" then
						-- kuertee start: callback
						if not string.find (entry.mode, "propertyowned") then
						-- kuertee end: callback

							entry.active = false
						end
					elseif menu.mode == "orderparam_object" then

						-- if (entry.mode ~= "objectlist") and (entry.mode ~= "propertyowned") then
						-- kuertee start: callback
						if (not string.find (entry.mode, "objectlist")) and (not string.find (entry.mode, "propertyowned")) then
						-- kuertee end: callback

							entry.active = false
						end
					elseif menu.mode == "selectComponent" then

						-- if (entry.mode ~= "objectlist") and (entry.mode ~= "propertyowned") then
						-- kuertee start: callback
						if (not string.find (entry.mode, "objectlist")) and (not string.find (entry.mode, "propertyowned")) then
						-- kuertee end: callback

							entry.active = false
						end
					end
				end
				if entry.active then
					local selectedmode = false
					if type(entry.mode) == "table" then
						for _, mode in ipairs(entry.mode) do
							if mode == menu.infoTableMode then
								selectedmode = true
								break
							end
						end
					else
						if entry.mode == menu.infoTableMode then
							selectedmode = true
						end
					end
					if selectedmode then
						firstactive = nil
						foundselection = true
					end
					if (not foundselection) and (not firstactive) then
						firstactive = entry.mode
					end
				end
			end
		end
	end
	if firstactive and firsttime then
		menu.infoTableMode = firstactive
		firstactive = nil
	end

	for _, entry in ipairs(leftbar) do
		if (entry.condition == nil) or entry.condition() then
			if entry.spacing then
				local row = ftable:addRow(false, { fixed = true })
				row[1]:createIcon("mapst_seperator_line", { width = menu.sideBarWidth, height = spacingHeight })
			else
				local mode = entry.mode
				if type(entry.mode) == "table" then
					mode = mode[1]
				end
				local row = ftable:addRow(true, { fixed = true })
				local bgcolor = Helper.defaultTitleBackgroundColor
				if type(entry.mode) == "table" then
					for _, mode in ipairs(entry.mode) do
						if mode == menu.infoTableMode then
							bgcolor = Helper.defaultArrowRowBackgroundColor
							break
						end
					end
				else
					if entry.mode == menu.infoTableMode then
						bgcolor = Helper.defaultArrowRowBackgroundColor
					end
				end
				local color = Helper.color.white
				if menu.highlightLeftBar[mode] then
					color = Helper.color.mission
				end
				
				row[1]:createButton({ active = entry.active, height = menu.sideBarWidth, bgColor = bgcolor, mouseOverText = entry.name, helpOverlayID = entry.helpOverlayID, helpOverlayText = entry.helpOverlayText }):setIcon(entry.icon, { color = color })
				row[1].handlers.onClick = function () return menu.buttonToggleObjectList(mode) end
			end
		end
	end

	ftable:setSelectedRow(menu.selectedRows.sideBar)
	menu.selectedRows.sideBar = nil
end
function newFuncs.createMissionContext(frame)
	local menu = mapMenu

	local tablespacing = Helper.standardTextHeight
	local maxObjectiveLines = 10

	-- description table
	local desctable = frame:addTable(1, { tabOrder = 3, highlightMode = "off", maxVisibleHeight = menu.contextMenuData.descriptionHeight, x = Helper.borderSize, y = Helper.borderSize, width = menu.contextMenuData.width })

	-- title
	local visibleHeight
	local row = desctable:addRow(false, { fixed = true })
	row[1]:createText(menu.contextMenuData.name, Helper.headerRowCenteredProperties)

	-- briefing icon if any
	local icontable
	if menu.contextMenuData.briefingicon then
		icontable = frame:addTable(1, { tabOrder = 0, highlightMode = "off", maxVisibleHeight = menu.contextMenuData.descriptionHeight, x = Helper.borderSize, y = desctable.properties.y + desctable:getFullHeight() + Helper.borderSize, width = menu.contextMenuData.briefingiconwidth })

		local row = icontable:addRow(nil, { bgColor = Helper.color.transparent })
		row[1]:createIcon(menu.contextMenuData.briefingicon, { scaling = false, height = menu.contextMenuData.briefingiconwidth })
		
		local row = icontable:addRow(nil, { bgColor = Helper.color.transparent })
		row[1]:createText(menu.contextMenuData.briefingiconcaption, { wordwrap = true })
	end

	-- description
	for linenum, descline in ipairs(menu.contextMenuData.description) do
		local row = desctable:addRow(true, { bgColor = Helper.color.transparent })
		row[1]:createText(descline, { scaling = false, fontsize = Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), x = menu.contextMenuData.briefingiconwidth and (menu.contextMenuData.briefingiconwidth + Helper.borderSize + Helper.scaleX(Helper.standardTextOffsetx)) or nil, minRowHeight = Helper.scaleY(Helper.standardTextHeight) })
		if linenum == menu.contextMenuData.descriptionLines then
			visibleHeight = desctable:getFullHeight()
		end
	end
	if visibleHeight then
		desctable.properties.maxVisibleHeight = visibleHeight
	else
		desctable.properties.maxVisibleHeight = desctable:getFullHeight()
	end

	local objectiveOffsetY = desctable.properties.y + desctable:getVisibleHeight()
	if icontable then
		objectiveOffsetY = math.max(objectiveOffsetY, menu.contextMenuData.descriptionHeight)
	end
	objectiveOffsetY = objectiveOffsetY + tablespacing + Helper.borderSize

	-- objectives table
	local objectivetable = frame:addTable(2, { tabOrder = 4, highlightMode = "off", x = Helper.borderSize, y = objectiveOffsetY, maxVisibleHeight = menu.contextMenuData.objectiveHeight, width = menu.contextMenuData.width })
	objectivetable:setColWidth(2, Helper.standardTextHeight)
	objectivetable:setDefaultColSpan(1, 2)

	-- objectives
	local visibleHeight
	if menu.contextMenuData.threadtype ~= "" then
		-- title
		local row = objectivetable:addRow(false, { fixed = true })
		row[1]:createText(ReadText(1001, 3418), Helper.headerRowCenteredProperties)
		if menu.contextMenuData.isoffer then
			if #menu.contextMenuData.briefingmissions > 0 then
				for i, details in ipairs(menu.contextMenuData.briefingmissions) do
					local infotext = ""
					local textProperties = {}
					if i < details.activeobjective then
						infotext = " - " .. ReadText(1001, 3416)
						textProperties.color = Helper.color.grey
					end
					local row = objectivetable:addRow(true, { bgColor = Helper.color.transparent })
					row[1]:setColSpan(1):createText(((menu.contextMenuData.threadtype == "sequential") and (i .. ReadText(1001, 120)) or "·") .. " " .. details.name .. infotext, textProperties)
					row[2]:createIcon("missiontype_" .. details.type, { height = Helper.standardTextHeight })
					if i == maxObjectiveLines then
						visibleHeight = objectivetable:getFullHeight()
					end
				end
			else
				local row = objectivetable:addRow(true, { bgColor = Helper.color.transparent })
				row[1]:createText("--- " .. ReadText(1001, 3410) .. " ---")
			end
		else
			if #menu.contextMenuData.subMissions > 0 then
				for i, submissionEntry in ipairs(menu.contextMenuData.subMissions) do
					local infotext = ""
					local textProperties = {}
					if i < submissionEntry.activebriefingstep then
						infotext = " - " .. ReadText(1001, 3416)
						textProperties.color = Helper.color.grey
					elseif i == submissionEntry.activebriefingstep then
						if submissionEntry.active then
							textProperties.color = Helper.color.mission
						end
					else
						-- nothing to do
					end
					local row = objectivetable:addRow(true, { bgColor = Helper.color.transparent })
					row[1]:setColSpan(1):createText(((menu.contextMenuData.threadtype == "sequential") and (i .. ReadText(1001, 120)) or "·") .. " " .. submissionEntry.name .. infotext, textProperties)
					row[2]:createIcon("missiontype_" .. submissionEntry.type, { height = Helper.standardTextHeight })
					if i == maxObjectiveLines then
						visibleHeight = objectivetable:getFullHeight()
					end
				end
			else
				local row = objectivetable:addRow(true, { bgColor = Helper.color.transparent })
				row[1]:createText("--- " .. ReadText(1001, 3410) .. " ---")
			end
		end
	else
		-- title
		local row = objectivetable:addRow(false, { fixed = true })
		row[1]:createText(ReadText(1001, 3402), Helper.headerRowCenteredProperties)
		if #menu.contextMenuData.briefingobjectives > 0 then
			for linenum, briefingobjective in ipairs(menu.contextMenuData.briefingobjectives) do
				local infotext = ""
				local textProperties = {}
				if linenum < menu.contextMenuData.activebriefingstep then
					infotext = " - " .. (briefingobjective.failed and ReadText(1001, 3422) or ReadText(1001, 3416))
					textProperties.color = Helper.color.grey
				elseif linenum == menu.contextMenuData.activebriefingstep then
					if (not menu.isOffer) and (menu.contextMenuData.missionid == C.GetActiveMissionID()) then
						textProperties.color = Helper.color.mission
					end
				else
					if briefingobjective.completedoutofsequence then
						infotext = " - " .. ReadText(1001, 3416)
						textProperties.color = Helper.color.grey
					end
				end
				local row = objectivetable:addRow(true, { bgColor = Helper.color.transparent })
				row[1]:setColSpan(briefingobjective.encyclopedia and 1 or 2):createText(briefingobjective.step .. ReadText(1001, 120) .. " " .. briefingobjective.text .. infotext, textProperties)

				-- kuertee start: show mission progress
				if menu.infoTableMode == "mission" and linenum == menu.contextMenuData.activebriefingstep then
					-- DebugError ("missionid64: " .. tostring (menu.contextMenuData.missionid))
					-- local row = objectivetable:addRow(true, { bgColor = Helper.color.transparent })
					-- row[1]:setColSpan(2):createText(tostring (newFuncs.missionProgress [tostring (menu.contextMenuData.missionid)].objectiveText))
					local progressText = newFuncs.missionProgress [tostring (menu.contextMenuData.missionid)].progressname
					local curProgress = newFuncs.missionProgress [tostring (menu.contextMenuData.missionid)].curProgress
					local maxProgress = newFuncs.missionProgress [tostring (menu.contextMenuData.missionid)].maxProgress
					if curProgress > 0 or  maxProgress > 0 then
						if not string.find (briefingobjective.text, tostring (curProgress) .. " / ") then
							local row = objectivetable:addRow(true, { bgColor = Helper.color.transparent })
							local progressLine
							if progressText ~= nil then
								progressLine = "    " .. newFuncs.missionProgress [tostring (menu.contextMenuData.missionid)].progressname .. ReadText(1001, 120) .. " "
							else
								progressLine = "    " .. ReadText (1001, 9513) .. ReadText(1001, 120) .. " "
							end
							progressLine = progressLine .. tostring (newFuncs.missionProgress [tostring (menu.contextMenuData.missionid)].curProgress) .. " / " .. tostring (newFuncs.missionProgress [tostring (menu.contextMenuData.missionid)].maxProgress)
							row [1]:setColSpan (2):createText (progressLine, textProperties)
						end
					end
				end
				-- kuertee end: show mission progress

				if briefingobjective.encyclopedia then
					row[2]:createButton({ active = briefingobjective.encyclopedia.known, height = Helper.standardTextHeight, mouseOverText = briefingobjective.encyclopedia.known and ReadText(1001, 2416) or ReadText(1026, 3259) }):setIcon("mm_externallink")
					row[2].handlers.onClick = function () Helper.closeMenuAndOpenNewMenu(menu, "EncyclopediaMenu", { 0, 0, briefingobjective.encyclopedia.mode, briefingobjective.encyclopedia.library, briefingobjective.encyclopedia.id, briefingobjective.encyclopedia.object }); menu.cleanup() end
				end
				if linenum == maxObjectiveLines then
					visibleHeight = objectivetable:getFullHeight()
				end
			end
		else
			local row = objectivetable:addRow(true, { bgColor = Helper.color.transparent })
			row[1]:createText("--- " .. ReadText(1001, 3410) .. " ---")
		end
	end
	if visibleHeight then
		objectivetable.properties.maxVisibleHeight = visibleHeight
	else
		objectivetable.properties.maxVisibleHeight = objectivetable:getFullHeight()
	end

	-- bottom table (info and buttons)
	local bottomtable = frame:addTable(2, { tabOrder = 2, x = Helper.borderSize, y = objectivetable.properties.y + objectivetable:getVisibleHeight() + tablespacing, width = menu.contextMenuData.width, highlightMode = "off" })

	-- faction
	if menu.contextMenuData.factionName then
		local row = bottomtable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
		row[1]:createText(ReadText(1001, 43) .. ReadText(1001, 120))
		row[2]:createText(menu.contextMenuData.factionName, { halign = "right" })
	end
	-- reward
	local rewardtext
	if menu.contextMenuData.rewardmoney ~= 0 then
		rewardtext = ConvertMoneyString(menu.contextMenuData.rewardmoney, false, true, 0, true) .. " " .. ReadText(1001, 101)
		if menu.contextMenuData.rewardtext ~= "" then
			rewardtext = rewardtext .. " \n" .. menu.contextMenuData.rewardtext
		end
	else
		rewardtext = menu.contextMenuData.rewardtext
	end
	local row = bottomtable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
	row[1]:createText(ReadText(1001, 3301) .. ReadText(1001, 120))
	row[2]:createText(rewardtext, { halign = "right", wordwrap = true })
	-- difficulty
	if menu.contextMenuData.difficulty ~= 0 then
		local row = bottomtable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
		row[1]:createText(ReadText(1001, 3403) .. ReadText(1001, 120))
		row[2]:createText(ConvertMissionLevelString(menu.contextMenuData.difficulty), { halign = "right" })
	end
	-- time left
	local row = bottomtable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
	row[1]:createText(ReadText(1001, 3404) .. ReadText(1001, 120))
	row[2]:createText(menu.getMissionContextTime, { halign = "right" })

	-- buttons
	if menu.contextMenuData.isoffer then
		-- Accept & Briefing
		local row = bottomtable:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
		local active = true
		local mouseovertext
		if C.IsMissionLimitReached(false, false, false) then
			active = false
			mouseovertext = ReadText(1026, 3242)
		elseif menu.contextMenuData.onlinechapter ~= "" then
			if C.HasAcceptedOnlineMission() then
				mouseovertext = "\27R" .. ReadText(1026, 11306)
			end
		end
		row[1]:createButton({ active = active, mouseOverText = mouseovertext, helpOverlayID = "map_acceptmission", helpOverlayText = " ", helpOverlayHighlightOnly = true }):setText(ReadText(1001, 57), { halign = "center" })
		row[1].handlers.onClick = menu.buttonMissionOfferAccept
		row[1].properties.uiTriggerID = "missionofferaccept"
		row[2]:createButton({  }):setText(ReadText(1001, 3326), { halign = "center" })
		row[2].handlers.onClick = menu.buttonMissionOfferBriefing
		row[2].properties.uiTriggerID = "missionofferbriefing"
	else
		-- Abort & Briefing
		local active = menu.contextMenuData.abortable
		local mouseovertext = ""
		if menu.contextMenuData.threadMissionID ~= 0 then
			local details = menu.getMissionIDInfoHelper(menu.contextMenuData.threadMissionID)
			active = active and (details.threadtype ~= "sequential")
			if details.threadtype == "sequential" then
				mouseovertext = ReadText(1026, 3405)
			end
		end
		local row = bottomtable:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
		row[1]:createButton({ active = active, mouseOverText = mouseovertext, helpOverlayID = "map_abortmission", helpOverlayText = " ",  helpOverlayHighlightOnly = true }):setText(ReadText(1001, 3407), { halign = "center" })
		row[1].handlers.onClick = menu.buttonMissionAbort
		row[1].properties.uiTriggerID = "missionabort"
		row[2]:createButton({  }):setText(ReadText(1001, 3326), { halign = "center" })
		row[2].handlers.onClick = menu.buttonMissionBriefing
		row[2].properties.uiTriggerID = "missionbriefing"
		local row

		-- kuertee start: callback
		-- if menu.contextMenuData.type ~= "guidance" then
		-- kuertee end: callback

			-- Set active
			local active = menu.contextMenuData.missionid == C.GetActiveMissionID()
			for _, submissionEntry in ipairs(menu.contextMenuData.subMissions) do
				if submissionEntry.active then
					active = true
				end
			end
			row = bottomtable:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
			row[1]:createButton({  }):setText(active and ReadText(1001, 3413) or ReadText(1001, 3406), { halign = "center" })
			row[1].handlers.onClick = menu.buttonMissionActivate
			row[1].properties.uiTriggerID = "missionactivate"

		-- kuertee start: callback
		-- end
		-- kuertee end: callback

		-- deliver wares
		if #menu.contextMenuData.deliveryWares > 0 then
			if not row then
				row = bottomtable:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
			end

			row[2]:createButton({ active = menu.checkDeliverWaresCargo, mouseOverText = function () return menu.checkDeliverWaresCargo() and "" or ("\27R" .. ReadText(1026, 3406)) end }):setText(ReadText(1001, 3423), { halign = "center" })
			row[2].handlers.onClick = menu.buttonMissionDeliverWares
			row[2].properties.uiTriggerID = "missiondeliverwares"
		end
	end
	local neededheight = bottomtable.properties.y + bottomtable:getFullHeight() + Helper.frameBorder
	if frame.properties.y + neededheight > Helper.viewHeight then
		frame.properties.y = Helper.viewHeight - neededheight
	end

	desctable.properties.nextTable = objectivetable.index
	objectivetable.properties.prevTable = desctable.index

	objectivetable.properties.nextTable = bottomtable.index
	bottomtable.properties.prevTable = objectivetable.index
end
function newFuncs.onRowChanged(row, rowdata, uitable, modified, input, source)
	local menu = mapMenu

	-- start Forleyor_infoCenter Callback:
	if callbacks ["ic_onRowChanged"] then
		for _, callback in ipairs (callbacks ["ic_onRowChanged"]) do
			callback (row, rowdata, uitable, modified, input, source)
		end
	end
	-- end Forleyor_infoCenter:

	-- Lock button over updates
	menu.lock = getElapsedTime()

	-- handle map modes without a holomap first
	if (menu.mode == "boardingcontext") and menu.boardingtable_shipselection and (uitable == menu.boardingtable_shipselection.id) and (type(rowdata) == "table") and (rowdata[1] == "boardingship") and C.IsComponentClass(rowdata[2], "defensible") and (menu.boardingData.selectedship ~= rowdata[2]) then
		--print("queueing refresh on next frame. ship: " .. ffi.string(C.GetComponentName(rowdata[2])) .. " " .. tostring(rowdata[2]))
		menu.boardingData.selectedship = rowdata[2]
		menu.queuecontextrefresh = true
	elseif menu.contextMenuMode == "trade" then
		if uitable == menu.contextshiptable then
			if rowdata then
				if (type(rowdata) == "table") and next(rowdata) then
					menu.selectedTradeWare = rowdata
				else
					menu.selectedTradeWare = nil
				end
				if (not menu.skipTradeRowChange) and (not menu.tradeSliderLock) then
					menu.queuetradecontextrefresh = true
				end
				menu.skipTradeRowChange = nil
			end
		end
	end

	if menu.holomap == 0 then
		return
	end

	if (menu.infoTableMode == "info") then
		if uitable == menu.infoTable then
			if (menu.infoMode.left == "objectinfo") or (menu.infoMode.left == "objectcrew") or (menu.infoMode.left == "objectloadout") then
				menu.selectedRows.infotableleft = row
				if menu.infoMode.left == "objectloadout" then
					local infomacrostolaunch = menu.infoTablePersistentData.left.macrostolaunch
					if (type(rowdata) == "table") and (rowdata[1] == "info_deploy") then
						if GetMacroData(rowdata[2], "islasertower") and (infomacrostolaunch.lasertower ~= rowdata[2]) then
							menu.infoTablePersistentData.left.macrostolaunch = { lasertower = rowdata[2] }
						elseif IsMacroClass(rowdata[2], "mine") and (infomacrostolaunch.mine ~= rowdata[2]) then
							menu.infoTablePersistentData.left.macrostolaunch = { mine = rowdata[2] }
						elseif IsMacroClass(rowdata[2], "navbeacon") and (infomacrostolaunch.navbeacon ~= rowdata[2]) then
							menu.infoTablePersistentData.left.macrostolaunch = { navbeacon = rowdata[2] }
						elseif IsMacroClass(rowdata[2], "resourceprobe") and (infomacrostolaunch.resourceprobe ~= rowdata[2]) then
							menu.infoTablePersistentData.left.macrostolaunch = { resourceprobe = rowdata[2] }
						elseif IsMacroClass(rowdata[2], "satellite") and (infomacrostolaunch.satellite ~= rowdata[2]) then
							menu.infoTablePersistentData.left.macrostolaunch = { satellite = rowdata[2] }
						end
					else
						menu.infoTablePersistentData.left.macrostolaunch = {}
					end
				end
			elseif (menu.infoMode.left == "orderqueue") or (menu.infoMode.left == "orderqueue_advanced") or (menu.infoMode.left == "standingorders") then
				menu.infoTablePersistentData.left.selectedorder = rowdata
				if type(menu.infoTablePersistentData.left.selectedorder) == "table" then
					menu.infoTablePersistentData.left.selectedorder.object = menu.infoSubmenuObject
				end
			end
		end

	-- kuertee start: callback
	-- elseif (menu.infoTableMode == "objectlist") or (menu.infoTableMode == "propertyowned") then
	elseif (string.find ("" .. tostring (menu.infoTableMode), "objectlist")) or (string.find ("" .. tostring (menu.infoTableMode), "propertyowned")) then
	-- kuertee end: callback

		if uitable == menu.infoTable then
			if type(rowdata) == "table" then
				local convertedComponent = ConvertIDTo64Bit(rowdata[2])
				if (source ~= "auto") and convertedComponent then
					local convertedcomponentclass = ffi.string(C.GetComponentClass(convertedComponent))
					if convertedcomponentclass  == "station" then
						AddUITriggeredEvent(menu.name, "selection_station", convertedComponent)
					end
					if (convertedcomponentclass  == "ship_s") or (convertedcomponentclass  == "ship_m") or (convertedcomponentclass  == "ship_l") or (convertedcomponentclass  == "ship_xl") then
						AddUITriggeredEvent(menu.name, "selection_ship", convertedComponent)
					end
					if (convertedcomponentclass == "resourceprobe") then
						AddUITriggeredEvent(menu.name, "selection_resourceprobe", convertedComponent)
					end

					if (menu.mode ~= "orderparam_object") and (input ~= "rightmouse") then
						menu.infoSubmenuObject = convertedComponent
						if menu.infoTableMode == "info" then
							menu.refreshInfoFrame(nil, 0)
						elseif menu.searchTableMode == "info" then
							menu.refreshInfoFrame2(nil, 0)
						end
					end
				end
				menu.updateSelectedComponents(modified, source == "auto", convertedComponent)
				menu.setSelectedMapComponents()
			end
		end
	elseif menu.infoTableMode == "plots" then
		if menu.plotDoNotUpdate then
			menu.plotDoNotUpdate = nil
		elseif menu.table_plotlist and (uitable == menu.table_plotlist.id) then
			menu.settoprow = GetTopRow(menu.table_plotlist)
			menu.setrow = Helper.currentTableRow[menu.table_plotlist]
			if not rowdata then
				print("rowdata empty. table id: " .. tostring(uitable) .. ", row: " .. tostring(row) .. ", rowdata: " .. tostring(rowdata))
			elseif input == "mouse" then
				--print("table id: " .. tostring(uitable) .. ", row: " .. tostring(row) .. ", rowdata: " .. tostring(rowdata) .. ", menu.table_plotlist.id: " .. tostring(menu.table_plotlist.id) .. ", uitable == menu.table_plotlist.id? " .. tostring(uitable == menu.table_plotlist.id))
				if rowdata == "plots_new" then
					menu.updatePlotData("plots_new", true)
				else
					C.SetFocusMapComponent(menu.holomap, rowdata, true)
				end
				menu.updatePlotData(rowdata)
			end
		end
	elseif (menu.infoTableMode == "missionoffer") or (menu.infoTableMode == "mission") then
		if uitable == menu.infoTable then
			local oldmission = menu.missionModeCurrent
			if type(rowdata) == "table" then
				local missionid = ConvertStringTo64Bit(rowdata[1])
				menu.missionModeCurrent = rowdata[1]
				if menu.missionDoNotUpdate then
					menu.missionDoNotUpdate = nil
				elseif input == "mouse" then
					if menu.contextMenuData and menu.contextMenuData.missionid and (menu.contextMenuData.missionid == missionid) then
						menu.closeContextMenu()
						menu.missionModeContext = nil
					else
						menu.closeContextMenu()
						menu.showMissionContext(missionid)
						menu.missionModeContext = true
					end
				end
			elseif type(rowdata) == "string" then
				menu.missionModeCurrent = rowdata
				if menu.missionDoNotUpdate then
					menu.missionDoNotUpdate = nil
				elseif input == "mouse" then
					menu.closeContextMenu()
					menu.missionModeContext = nil
				end
			end
			if menu.missionDoNotUpdate then
				menu.missionDoNotUpdate = nil
			elseif menu.missionModeCurrent ~= oldmission then
				if source ~= "auto" then
					menu.refreshInfoFrame()
				end
			end
		end
	elseif menu.infoTableMode == "ventureoperation" then
		if uitable == menu.infoTable then
			Helper.callExtensionFunction("multiverse", "onRowChanged", menu, menu.infoTableMode, row, rowdata, uitable, modified, input, source)
		end
	end

	if (menu.searchTableMode == "info") then
		if uitable == menu.infoTableRight then
			if (menu.infoMode.right == "objectinfo") or (menu.infoMode.right == "objectcrew") or (menu.infoMode.right == "objectloadout") then
				menu.selectedRows.infotableright = row
				if menu.infoMode.right == "objectloadout" then
					local infomacrostolaunch = menu.infoTablePersistentData.right.macrostolaunch
					if (type(rowdata) == "table") and (rowdata[1] == "info_deploy") then
						if GetMacroData(rowdata[2], "islasertower") and (infomacrostolaunch.lasertower ~= rowdata[2]) then
							menu.infoTablePersistentData.right.macrostolaunch = { lasertower = rowdata[2] }
						elseif IsMacroClass(rowdata[2], "mine") and (infomacrostolaunch.mine ~= rowdata[2]) then
							menu.infoTablePersistentData.right.macrostolaunch = { mine = rowdata[2] }
						elseif IsMacroClass(rowdata[2], "navbeacon") and (infomacrostolaunch.navbeacon ~= rowdata[2]) then
							menu.infoTablePersistentData.right.macrostolaunch = { navbeacon = rowdata[2] }
						elseif IsMacroClass(rowdata[2], "resourceprobe") and (infomacrostolaunch.resourceprobe ~= rowdata[2]) then
							menu.infoTablePersistentData.right.macrostolaunch = { resourceprobe = rowdata[2] }
						elseif IsMacroClass(rowdata[2], "satellite") and (infomacrostolaunch.satellite ~= rowdata[2]) then
							menu.infoTablePersistentData.right.macrostolaunch = { satellite = rowdata[2] }
						end
					else
						menu.infoTablePersistentData.right.macrostolaunch = {}
					end
				end
			elseif (menu.infoMode.right == "orderqueue") or (menu.infoMode.right == "orderqueue_advanced") or (menu.infoMode.right == "standingorders") then
				menu.infoTablePersistentData.right.selectedorder = rowdata
				if type(menu.infoTablePersistentData.right.selectedorder) == "table" then
					menu.infoTablePersistentData.right.selectedorder.object = menu.infoSubmenuObject
				end
			end
		end
	end
end
function newFuncs.onSelectElement(uitable, modified, row, isdblclick, input)
	local menu = mapMenu

	-- start Forleyor_infoCenter Callback:
	if callbacks ["ic_onSelectElement"] then
		for _, callback in ipairs (callbacks ["ic_onSelectElement"]) do
			callback (uitable, modified, row, isdblclick, input)
		end
	end
	-- end Forleyor_infoCenter:

	local rowdata = Helper.getCurrentRowData(menu, uitable)

	-- if (menu.infoTableMode == "objectlist") or (menu.infoTableMode == "propertyowned") then
	-- kuertee start: callback
	if (string.find ("" .. tostring (menu.infoTableMode), "objectlist")) or (string.find ("" .. tostring (menu.infoTableMode), "propertyowned")) then
	-- kuertee end: callback

		if uitable == menu.infoTable then
			if type(rowdata) == "table" then
				local convertedRowComponent = ConvertIDTo64Bit(rowdata[2])
				menu.setSelectedMapComponents()

				if convertedRowComponent and (convertedRowComponent ~= 0) then
					local isonlineobject, isplayerowned = GetComponentData(rowdata[2], "isonlineobject", "isplayerowned")
					if (isdblclick or (input ~= "mouse")) and (ffi.string(C.GetComponentClass(convertedRowComponent)) ~= "sector") then
						if string.find(rowdata[1], "subordinates") then
							local subordinates = menu.infoTableData.left.subordinates[tostring(rowdata[2])] or {}
							local groups = {}
							for _, subordinate in ipairs(subordinates) do
								local group = GetComponentData(subordinate, "subordinategroup")
								if group and group > 0 then
									if groups[group] then
										table.insert(groups[group].subordinates, subordinate)
									else
										groups[group] = { assignment = ffi.string(C.GetSubordinateGroupAssignment(convertedRowComponent, group)), subordinates = { subordinate } }
									end
								end
							end

							if groups[rowdata[3]] then
								C.SetFocusMapComponent(menu.holomap, ConvertIDTo64Bit(groups[rowdata[3]].subordinates[1]), true)
								menu.addSelectedComponents(groups[rowdata[3]].subordinates, modified ~= "shift")
							end
						elseif isplayerowned and isonlineobject then
							local assigneddock = ConvertIDTo64Bit(GetComponentData(convertedRowComponent, "assigneddock"))
							if assigneddock then
								local container = C.GetContextByClass(assigneddock, "container", false)
								if container then
									C.SetFocusMapComponent(menu.holomap, container, true)
								end
							end
						else
							C.SetFocusMapComponent(menu.holomap, convertedRowComponent, true)
						end
					end
				end
			end
		end
	elseif menu.infoTableMode == "plots" then
		if menu.plotDoNotUpdate then
			menu.plotDoNotUpdate = nil
		elseif menu.table_plotlist and (uitable == menu.table_plotlist.id) then
			if rowdata == "plots_new" then
				menu.updatePlotData("plots_new", true)
			else
				C.SetFocusMapComponent(menu.holomap, rowdata, true)
			end
			menu.updatePlotData(rowdata)
		end
	elseif (menu.infoTableMode == "missionoffer") or (menu.infoTableMode == "mission") then
		if uitable == menu.infoTable then
			if type(rowdata) == "table" then
				menu.missionModeCurrent = rowdata[1]
				local missionid = ConvertStringTo64Bit(rowdata[1])
				if menu.contextMenuData and menu.contextMenuData.missionid and (menu.contextMenuData.missionid == missionid) then
					menu.closeContextMenu()
					menu.missionModeContext = nil
				else
					menu.closeContextMenu()
					menu.showMissionContext(missionid)
					menu.missionModeContext = true
				end
			elseif type(rowdata) == "string" then
				menu.missionModeCurrent = rowdata
				if menu.missionDoNotUpdate then
					menu.missionDoNotUpdate = nil
				else
					menu.closeContextMenu()
					menu.missionModeContext = nil
				end
			end
		end
	elseif (menu.infoTableMode == "info") then
		if (isdblclick or (input ~= "mouse")) then
			if (rowdata == "info_focus") or ((type(rowdata) == "table") and (rowdata[1] == "info_focus")) then
				C.SetFocusMapComponent(menu.holomap, menu.infoSubmenuObject, true)
			end
			if (menu.infoMode.left == "orderqueue") or (menu.infoMode.left == "orderqueue_advanced") then
				if (type(rowdata) == "table") and (type(rowdata[1]) == "number") then
					C.SetFocusMapOrder(menu.holomap, menu.infoSubmenuObject, rowdata[1], true)
				end
			end
		end
	elseif menu.infoTableMode == "ventureoperation" then
		if uitable == menu.infoTable then
			Helper.callExtensionFunction("multiverse", "onSelectRow", menu, menu.infoTableMode, uitable, modified, row, isdblclick, input)
		end
	end

	if (menu.searchTableMode == "info") then
		if (isdblclick or (input ~= "mouse")) then
			if (rowdata == "info_focus") or ((type(rowdata) == "table") and (rowdata[1] == "info_focus")) then
				C.SetFocusMapComponent(menu.holomap, menu.infoSubmenuObject, true)
			end
			if (menu.infoMode.right == "orderqueue") or (menu.infoMode.right == "orderqueue_advanced") then
				if (type(rowdata) == "table") and (type(rowdata[1]) == "number") then
					C.SetFocusMapOrder(menu.holomap, menu.infoSubmenuObject, rowdata[1], true)
				end
			end
		end
	end
end
function newFuncs.onRenderTargetSelect(modified)
	local menu = mapMenu

	local offset = table.pack(GetLocalMousePosition())
	-- Check if the mouse button was down less than 0.5 seconds and the mouse was moved more than a distance of 5px
	if (not menu.leftdown) or ((menu.leftdown.time + 0.5 > getElapsedTime()) and not Helper.comparePositions(menu.leftdown.position, offset, 5)) then
		if menu.showMultiverse then
			local pickedplayer = C.GetPickedMultiverseMapPlayer(menu.holomap)
			-- TODO
		elseif menu.mode == "selectbuildlocation" then
			local station = 0
			if menu.plotData.active then
				local offset = ffi.new("UIPosRot")
				local offsetsector = C.GetBuildMapStationLocation2(menu.holomap, offset)
				if offsetsector ~= 0 then
					AddUITriggeredEvent(menu.name, "plotplaced")
					menu.plotData.sector = offsetsector
					station = C.ReserveBuildPlot(offsetsector, "player", menu.plotData.set, offset, menu.plotData.size.x * 1000, menu.plotData.size.y * 1000, menu.plotData.size.z * 1000)
					if GetComponentData(ConvertStringTo64Bit(tostring(offsetsector)), "isplayerowned") then
						local size = { x = menu.plotData.size.x * 1000, y = menu.plotData.size.y * 1000, z = menu.plotData.size.z * 1000 }
						local plotcenter = { x = offset.x, y = offset.y, z = offset.z }
						C.PayBuildPlotSize(station, size, plotcenter)
					end
					C.ClearMapBuildPlot(menu.holomap)
					menu.plotData.active = nil
					SetMouseOverOverride(menu.map, nil)
				end
			else
				local pickedcomponent = C.GetPickedMapComponent(menu.holomap)
				local pickedcomponentclass = ffi.string(C.GetRealComponentClass(pickedcomponent))
				if (pickedcomponentclass == "station") and GetComponentData(ConvertStringToLuaID(tostring(pickedcomponent)), "isplayerowned") then
					station = pickedcomponent
				end
			end

			if station ~= 0 then
				for _, row in ipairs(menu.table_plotlist.rows) do
					if row.rowdata == station then
						menu.setplotrow = row.index
						menu.setplottoprow = (row.index - 12) > 1 and (row.index - 12) or 1
						break
					end
				end

				menu.updatePlotData(station, true)
				menu.refreshInfoFrame()
			end
		elseif menu.mode == "orderparam_position" then
			local offset = ffi.new("UIPosRot")
			local eclipticoffset = ffi.new("UIPosRot")
			local offsetcomponent = C.GetMapPositionOnEcliptic2(menu.holomap, offset, false, 0, eclipticoffset)
			if offsetcomponent ~= 0 then
				local class = ffi.string(C.GetComponentClass(offsetcomponent))
				if (not menu.modeparam[2].inputparams.class) or (class == menu.modeparam[2].inputparams.class) then
					menu.modeparam[1]({ConvertStringToLuaID(tostring(offsetcomponent)), {offset.x, offset.y, offset.z}})
				elseif (menu.modeparam[2].inputparams.class == "zone") and (class == "sector") then
					offsetcomponent = C.GetZoneAt(offsetcomponent, offset)
					menu.modeparam[1]({ConvertStringToLuaID(tostring(offsetcomponent)), {offset.x, offset.y, offset.z}})
				end
			end
		elseif (menu.mode == "orderparam_selectenemies") or (menu.mode == "orderparam_selectplayerdeployables") then
			menu.mode = nil
			menu.modeparam = {}
			SetMouseCursorOverride("default")
			menu.removeMouseCursorOverride(3)
		elseif menu.mode == "boardingcontext" then

		else
			local colspan = 1
			if menu.editboxHeight >= Helper.scaleY(config.mapRowHeight) then
				colspan = 2
			end
			if menu.searchField then
				Helper.confirmEditBoxInput(menu.searchField, 1, colspan + 2)
			end
			local pickedcomponent = C.GetPickedMapComponent(menu.holomap)
			local pickedorder = ffi.new("Order")
			local isintermediate = ffi.new("bool[1]", 0)
			local pickedordercomponent = C.GetPickedMapOrder(menu.holomap, pickedorder, isintermediate)
			local pickedcomponentclass = ffi.string(C.GetComponentClass(pickedcomponent))
			local ispickedcomponentship = C.IsComponentClass(pickedcomponent, "ship") and not C.IsUnit(pickedcomponent)
			local pickedtradeoffer = C.GetPickedMapTradeOffer(menu.holomap)
			if pickedordercomponent ~= 0 then
				local sectorcontext = C.GetContextByClass(pickedordercomponent, "sector", false)
				if sectorcontext ~= menu.currentsector then
					menu.currentsector = sectorcontext
				end

				menu.createInfoFrame()
			elseif pickedtradeoffer ~= 0 then
				local tradeid = ConvertStringToLuaID(tostring(pickedtradeoffer))
				local tradedata = GetTradeData(tradeid)
				if tradedata.ware then
					local setting = config.layersettings["layer_trade"][1]
					local rawwarelist = menu.getFilterOption(setting.id) or {}
					local found = false
					for i, ware in ipairs(rawwarelist) do
						if ware == tradedata.ware then
							found = i
							break
						end
					end
					AddUITriggeredEvent(menu.name, "filterwareselected", tradedata.isbuyoffer and "buyoffer" or "selloffer")
					if found then
						menu.removeFilterOption(setting, setting.id, found)
					else
						menu.setFilterOption("layer_trade", setting, setting.id, tradedata.ware)
					end
				end
			elseif pickedcomponent ~= 0 then
				if (not menu.sound_selectedelement) or (menu.sound_selectedelement ~= pickedcomponent) or (modified == "ctrl") or (modified == "shift") then
					local isselected = menu.isSelectedComponent(pickedcomponent)
					if (not isselected) and (modified == "shift") then
						PlaySound("ui_positive_multiselect")
					elseif modified == "ctrl" then
						if isselected then
							PlaySound("ui_positive_deselect")
						else
							PlaySound("ui_positive_multiselect")
						end
					elseif (pickedcomponentclass == "sector") then
						PlaySound("ui_positive_deselect")
					else
						PlaySound("ui_positive_select")
					end
				end
				menu.sound_selectedelement = pickedcomponent
				if menu.mode ~= "orderparam_object" then
					menu.infoSubmenuObject = ConvertStringTo64Bit(tostring(pickedcomponent))
					if menu.infoTableMode == "info" then
						menu.refreshInfoFrame(nil, 0)
					elseif menu.searchTableMode == "info" then
						menu.refreshInfoFrame2(nil, 0)
					end
				end

				if pickedcomponentclass == "sector" then
					AddUITriggeredEvent(menu.name, "selection_reset")
					menu.clearSelectedComponents()
					if pickedcomponent ~= menu.currentsector then
						menu.currentsector = pickedcomponent
						menu.updateMapAndInfoFrame()
					end
				elseif (#menu.searchtext == 0) or Helper.textArrayHelper(menu.searchtext, function (numtexts, texts) return C.FilterComponentByText(pickedcomponent, numtexts, texts, true) end) then
					local isconstruction = IsComponentConstruction(ConvertStringTo64Bit(tostring(pickedcomponent)))
					if (C.IsComponentOperational(pickedcomponent) and (pickedcomponentclass ~= "player") and (pickedcomponentclass ~= "collectablewares") and (not menu.createInfoFrameRunning)) or
						(pickedcomponentclass == "gate") or (pickedcomponentclass == "asteroid") or isconstruction
					then
						local sectorcontext = C.GetContextByClass(pickedcomponent, "sector", false)
						if sectorcontext ~= menu.currentsector then
							menu.currentsector = sectorcontext
						end
						
						if modified == "ctrl" then
							menu.toggleSelectedComponent(pickedcomponent)
						else
							if pickedcomponentclass == "station" then
								AddUITriggeredEvent(menu.name, "selection_station", ConvertStringTo64Bit(tostring(pickedcomponent)))
							end
							if (pickedcomponentclass == "ship_s") or (pickedcomponentclass == "ship_m") or (pickedcomponentclass == "ship_l") or (pickedcomponentclass == "ship_xl") then
								AddUITriggeredEvent(menu.name, "selection_ship", ConvertStringTo64Bit(tostring(pickedcomponent)))
							end
							if (pickedcomponentclass == "resourceprobe") then
								AddUITriggeredEvent(menu.name, "selection_resourceprobe", ConvertStringTo64Bit(tostring(pickedcomponent)))
							end

							local newmode
							if (menu.mode ~= "selectComponent") or (menu.modeparam[3] ~= "deployables") then

								-- kuertee start: callback
								-- if menu.infoTableMode == "objectlist" then
								if string.find ("" .. tostring (menu.infoTableMode), "objectlist") then
								-- kuertee end: callback

									local isdeployable = GetComponentData(ConvertStringTo64Bit(tostring(pickedcomponent)), "isdeployable")
									if isdeployable or (pickedcomponentclass == "lockbox") then
										newmode = "deployables"
									elseif menu.objectMode ~= "objectall" then
										if C.IsRealComponentClass(pickedcomponent, "station") then
											newmode = "stations"
										elseif ispickedcomponentship then
											local found = false
											local commanderlist = GetAllCommanders(ConvertStringTo64Bit(tostring(pickedcomponent)))
											for i, entry in ipairs(commanderlist) do
												if IsComponentClass(entry, "station") then
													found = true
													break
												end
											end
											if found then
												newmode = "stations"
											else
												newmode = "ships"
											end
										end
									end

								-- kuertee start: callback
								-- elseif menu.infoTableMode == "propertyowned" then
								elseif string.find ("" .. tostring (menu.infoTableMode), "propertyowned") then
								-- kuertee end: callback

									local isplayerowned, isdeployable = GetComponentData(ConvertStringTo64Bit(tostring(pickedcomponent)), "isplayerowned", "isdeployable")
									if isplayerowned then
										if isdeployable or (pickedcomponentclass == "lockbox") then
											newmode = "deployables"
										elseif menu.propertyMode ~= "propertyall" then
											if C.IsRealComponentClass(pickedcomponent, "station") then
												newmode = "stations"
											elseif ispickedcomponentship then
												local found = false
												local commanderlist = GetAllCommanders(ConvertStringTo64Bit(tostring(pickedcomponent)))
												for i, entry in ipairs(commanderlist) do
													if IsComponentClass(entry, "station") then
														found = true
														break
													end
												end
												if found then
													newmode = "stations"
												else
													if #commanderlist > 0 then
														newmode = "fleets"
													else
														newmode = "unassignedships"
													end
												end
											end
										end
									end
								end
							end
							menu.addSelectedComponent(pickedcomponent, not modified)
							if newmode then

								-- kuertee start: callback
								-- if menu.infoTableMode == "objectlist" then
								if string.find ("" .. tostring (menu.infoTableMode), "objectlist") then
								-- kuertee end: callback

									if newmode ~= menu.objectMode then
										menu.objectMode = newmode
										menu.refreshInfoFrame()
									end

								-- kuertee start: callback
								-- elseif menu.infoTableMode == "propertyowned" then
								elseif string.find ("" .. tostring (menu.infoTableMode), "propertyowned") then
								-- kuertee end: callback

									if newmode ~= menu.propertyMode then
										menu.propertyMode = newmode
										menu.refreshInfoFrame()
									end
								end
							end
						end
					end
				end
			else
				if (menu.mode ~= "info") or (not menu.infoMode.left) or (menu.infoMode.left == "objectinfo") or (menu.infoMode.left == "objectcrew") or (menu.infoMode.left == "objectloadout") or (menu.infoMode.left == "objectlogbook") then
					AddUITriggeredEvent(menu.name, "selection_reset")
					menu.clearSelectedComponents()
				end
			end
		end
	end
	menu.leftdown = nil
end
function newFuncs.onTableRightMouseClick(uitable, row, posx, posy)
	local menu = mapMenu

	-- start Forleyor_infoCenter Callback:
	if callbacks ["ic_onTableRightMouseClick"] then
		for _, callback in ipairs (callbacks ["ic_onTableRightMouseClick"]) do
			callback (uitable, row, posx, posy)
		end
	end
	-- end Forleyor_infoCenter:

	if (menu.mode == "orderparam_position") then
		menu.resetOrderParamMode()
	else
		if row > (menu.numFixedRows or 0) then
			local rowdata = menu.rowDataMap[uitable] and menu.rowDataMap[uitable][row]

			-- kuertee start: callback
			-- if (menu.infoTableMode == "objectlist") or (menu.infoTableMode == "propertyowned") then
			if (string.find ("" .. tostring (menu.infoTableMode), "objectlist")) or (string.find ("" .. tostring (menu.infoTableMode), "propertyowned")) then
			-- kuertee end: callback

				if uitable == menu.infoTable then
					if type(rowdata) == "table" then
						local convertedRowComponent = ConvertIDTo64Bit(rowdata[2])
						if convertedRowComponent and (convertedRowComponent ~= 0) then
							local x, y = GetLocalMousePosition()
							if x == nil then
								-- gamepad case
								if posx ~= nil then
									x = posx + Helper.viewWidth / 2
									y = posy + Helper.viewHeight / 2
								end
							else
								x = x + Helper.viewWidth / 2
								y = Helper.viewHeight / 2 - y
							end

							if menu.mode == "hire" then
								if GetComponentData(convertedRowComponent, "isplayerowned") and C.IsComponentClass(convertedRowComponent, "controllable") then
									menu.contextMenuMode = "hire"
									menu.contextMenuData = { hireObject = convertedRowComponent, xoffset = x, yoffset = y }

									local width = Helper.scaleX(config.hireContextWidth)
									if menu.contextMenuData.xoffset + width > Helper.viewWidth then
										menu.contextMenuData.xoffset = Helper.viewWidth - width - Helper.frameBorder
									end

									menu.createContextFrame(width, nil, menu.contextMenuData.xoffset, menu.contextMenuData.yoffset)
								end
							elseif menu.mode == "selectCV" then
								menu.contextMenuData = { component = convertedRowComponent, xoffset = x, yoffset = y }
								menu.contextMenuMode = "select"
								menu.createContextFrame(menu.selectWidth)
							elseif menu.mode == "orderparam_object" then
								if menu.checkForOrderParamObject(convertedRowComponent) then
									menu.contextMenuData = { component = convertedRowComponent, xoffset = x, yoffset = y }
									menu.contextMenuMode = "select"
									menu.createContextFrame(menu.selectWidth)
								end
							elseif menu.mode == "selectComponent" then
								if menu.checkForSelectComponent(convertedRowComponent) then
									menu.contextMenuData = { component = convertedRowComponent, xoffset = x, yoffset = y }
									menu.contextMenuMode = "select"
									menu.createContextFrame(menu.selectWidth)
								end
							else
								local missions = {}
								Helper.ffiVLA(missions, "MissionID", C.GetNumMapComponentMissions, C.GetMapComponentMissions, menu.holomap, convertedRowComponent)
								
								local playerships, otherobjects, playerdeployables = menu.getSelectedComponentCategories()
								if rowdata[1] == "construction" then
									menu.interactMenuComponent = convertedRowComponent
									Helper.openInteractMenu(menu, { component = convertedRowComponent, playerships = playerships, otherobjects = otherobjects, playerdeployables = playerdeployables, mouseX = posx, mouseY = posy, construction = rowdata[3], componentmissions = missions })
								elseif string.find(rowdata[1], "subordinates") then
									menu.interactMenuComponent = convertedRowComponent
									Helper.openInteractMenu(menu, { component = convertedRowComponent, playerships = playerships, otherobjects = otherobjects, playerdeployables = playerdeployables, mouseX = posx, mouseY = posy, subordinategroup = rowdata[3], componentmissions = missions })
								else
									menu.interactMenuComponent = convertedRowComponent
									Helper.openInteractMenu(menu, { component = convertedRowComponent, playerships = playerships, otherobjects = otherobjects, playerdeployables = playerdeployables, mouseX = posx, mouseY = posy, componentmissions = missions })
								end
							end
						end
					end
				end
			elseif menu.infoTableMode == "info" then
				if uitable == menu.infoTable then
					menu.prepareInfoContext(rowdata, "left")
				end
			elseif menu.infoTableMode == "missionoffer" then
				if uitable == menu.infoTable then
					if type(rowdata) == "table" then
						menu.closeContextMenu()

						local missionid = ConvertStringTo64Bit(rowdata[1])
						local playerships, otherobjects, playerdeployables = menu.getSelectedComponentCategories()
						Helper.openInteractMenu(menu, { missionoffer = missionid, playerships = playerships, otherobjects = otherobjects, playerdeployables = playerdeployables })
					end
				end
			elseif menu.infoTableMode == "mission" then
				if uitable == menu.infoTable then
					if type(rowdata) == "table" then
						menu.closeContextMenu()

						local missionid = ConvertStringTo64Bit(rowdata[1])
						local playerships, otherobjects, playerdeployables = menu.getSelectedComponentCategories()
						Helper.openInteractMenu(menu, { mission = missionid, playerships = playerships, otherobjects = otherobjects, playerdeployables = playerdeployables })
					end
				end
			end

			if menu.searchTableMode == "info" then
				if uitable == menu.infoTableRight then
					menu.prepareInfoContext(rowdata, "right")
				end
			end
		else
			menu.closeContextMenu()
		end
	end
end
function newFuncs.onInteractiveElementChanged(element)
	local menu = mapMenu

	menu.lastactivetable = element
	-- kuertee start: callback
	-- if (menu.infoTableMode == "objectlist") or (menu.infoTableMode == "propertyowned") then
	if (string.find ("" .. tostring (menu.infoTableMode), "objectlist")) or (string.find ("" .. tostring (menu.infoTableMode), "propertyowned")) then
	-- kuertee end: callback
		if menu.lastactivetable == menu.infoTable then
			if not menu.arrowsRegistered then
				RegisterAddonBindings("ego_detailmonitor", "map_arrows")
				menu.arrowsRegistered = true
			end
		else
			if menu.arrowsRegistered then
				UnregisterAddonBindings("ego_detailmonitor", "map_arrows")
				menu.arrowsRegistered = nil
			end
		end
	end
end
function newFuncs.closeContextMenu(dueToClose)
	local menu = mapMenu

	if Helper.closeInteractMenu() then
		return true
	end
	if menu.contextMenuMode then
		if menu.contextMenuMode == "trade" then
			if C.IsComponentOperational(menu.contextMenuData.currentShip) then
				SetVirtualCargoMode(ConvertStringToLuaID(tostring(menu.contextMenuData.currentShip)), false)
			end
			if menu.contextMenuData.wareexchange then
				if C.IsComponentOperational(menu.contextMenuData.component) then
					SetVirtualCargoMode(ConvertStringToLuaID(tostring(menu.contextMenuData.component)), false)
				end
			end
			menu.selectedTradeWare = nil
		elseif menu.contextMenuMode == "mission" then
			if menu.holomap ~= 0 then
				C.SetMapRenderMissionGuidance(menu.holomap, 0)
			end
			if menu.contextMenuData.isoffer then
				UnregisterEvent("missionofferremoved", menu.onMissionOfferRemoved)
			else
				UnregisterEvent("missionremoved", menu.onMissionRemoved)
			end
		elseif menu.contextMenuMode == "boardingcontext" then
			-- restore old mode and old info table mode
			menu.mode = menu.oldmode
			menu.oldmode = nil
			menu.infoTableMode = menu.oldInfoTableMode
			menu.refreshMainFrame = true
			menu.oldInfoTableMode = nil
			menu.boardingData = {}
			menu.contexttoprow = nil
			menu.contextselectedrow = nil
		elseif menu.contextMenuMode == "onlinemode" then
			if dueToClose == "back" then
				return false
			end
		elseif (menu.contextMenuMode == "ventureconfig") or (menu.contextMenuMode == "venturecreateparty") or (menu.contextMenuMode == "ventureoutcome") then
			Helper.callExtensionFunction("multiverse", "closeContextMenu", menu, menu.contextMenuMode, dueToClose)
		end
		-- REMOVE this block once the mouse out/over event order is correct -> This should be unnessecary due to the global tablemouseout event reseting the picking
		if menu.currentMouseOverTable and (
			(menu.currentMouseOverTable == menu.contexttable)
			or (menu.currentMouseOverTable == menu.contextshiptable)
			or (menu.currentMouseOverTable == menu.contextbuttontable)
			or (menu.currentMouseOverTable == menu.contextdesctable)
			or (menu.currentMouseOverTable == menu.contextobjectivetable)
			or (menu.currentMouseOverTable == menu.contextbottomtable)
			or (menu.contextMenuMode == "boardingcontext")
			or (menu.contextMenuMode == "dropwares")
			or (menu.contextMenuMode == "crewtransfer")
			or (menu.contextMenuMode == "rename")
			or (menu.contextMenuMode == "userquestion")
			or (menu.contextMenuMode == "mission")
			or (menu.contextMenuMode == "venturepatron")
			or (menu.contextMenuMode == "filter_multiselectlist")
			or (menu.contextMenuMode == "hire")
		) then
			menu.picking = true
			menu.currentMouseOverTable = nil
		end
		-- END
		menu.contextFrame = nil
		Helper.clearFrame(menu, config.contextFrameLayer)
		menu.contextMenuData = {}
		menu.contextMenuMode = nil
		if (menu.mode == "tradecontext") or (menu.mode == "dropwarescontext") or (menu.mode == "renamecontext") or (menu.mode == "crewtransfercontext") or(menu.mode == "venturepatroninfo") or menu.closemapwithmenu then
			Helper.closeMenu(menu, dueToClose)
			menu.cleanup()
		end
		return true
	end
	return false
end
function newFuncs.updateSelectedComponents(modified, keepselection, changedComponent)
	local menu = mapMenu

	local components = {}
	local rows, highlightedborderrow = GetSelectedRows(menu.infoTable)

	for _, row in ipairs(rows) do
		local rowdata = menu.rowDataMap[menu.infoTable][row]
		if type(rowdata) == "table" then
			if (rowdata[1] ~= "moduletype") and (not string.find(rowdata[1], "subordinates")) and (rowdata[1] ~= "dockedships") and (rowdata[1] ~= "constructions") then
				if rowdata[1] == "construction" then
					if rowdata[3].component ~= 0 then
						table.insert(components, ConvertStringTo64Bit(tostring(rowdata[3].component)))
					end
				else
					table.insert(components, rowdata[2])
				end
			end
		end
	end

	if modified or keepselection then
		for id in pairs(menu.selectedcomponents) do
			local component = ConvertStringTo64Bit(id)
			-- keep gates, satellites, etc. selected even if they don't have their own list entries
			if C.IsComponentClass(component, "gate") or C.IsComponentClass(component, "asteroid") or C.IsComponentClass(component, "buildstorage") or C.IsComponentClass(component, "highwayentrygate") then
				table.insert(components, component)
			end

			-- kuertee start: callback
			-- if menu.infoTableMode == "propertyowned" then
			if string.find ("" .. tostring (menu.infoTableMode), "propertyowned") then
			-- kuertee end: callback

				local isplayerowned, isdeployable = GetComponentData(component, "isplayerowned", "isdeployable")
				if not isplayerowned then
					-- keep npc ships selected
					table.insert(components, component)
				elseif menu.propertyMode ~= "propertyall" then
					-- keep other property selected that is currently not displayed
					if (menu.propertyMode ~= "stations") and C.IsRealComponentClass(component, "station") then
						table.insert(components, component)
					end
					if (modified ~= "ctrl") or (component ~= changedComponent) then
						if C.IsComponentClass(component, "ship") then
							table.insert(components, component)
						end
					end
				end
				if (menu.propertyMode ~= "deployables") and (isdeployable or C.IsComponentClass(component, "lockbox")) then
					table.insert(components, component)
				end

			-- kuertee start: callback
			-- elseif menu.infoTableMode == "objectlist" then
			elseif string.find ("" .. tostring (menu.infoTableMode), "objectlist") then
			-- kuertee end: callback

				local isdeployable = GetComponentData(component, "isdeployable")
				if menu.objectMode ~= "objectall" then
					-- keep other property selected that is currently not displayed
					if (menu.objectMode ~= "stations") and C.IsRealComponentClass(component, "station") then
						table.insert(components, component)
					end
						if (modified ~= "ctrl") or (component ~= changedComponent) then
						if C.IsComponentClass(component, "ship") then
							table.insert(components, component)
						end
					end
				end
				if (menu.objectMode ~= "deployables") and (isdeployable or C.IsComponentClass(component, "lockbox")) then
					table.insert(components, component)
				end
			end
		end
	end

	local rowdata = menu.rowDataMap[menu.infoTable][highlightedborderrow]
	if type(rowdata) == "table" then
		menu.highlightedbordercomponent = rowdata[2]
		if rowdata[1] == "construction" then
			if rowdata[3].component ~= 0 then
				menu.highlightedbordercomponent = ConvertStringTo64Bit(tostring(rowdata[3].component))
			end
		end
		local oldselectedstationcategory = menu.selectedstationcategory
		menu.highlightedbordermoduletype = nil
		menu.highlightedborderstationcategory = nil
		menu.selectedstationcategory = nil
		menu.highlightedplannedmodule = nil
		menu.highlightedconstruction = nil
		menu.selectedconstruction = nil
		if rowdata[1] == "moduletype" then
			menu.highlightedbordermoduletype = rowdata[3]
		elseif rowdata[1] == "module" then
			menu.highlightedbordermoduletype = rowdata[3]
			if rowdata[6] then
				menu.highlightedbordercomponent = rowdata[5]
				menu.highlightedplannedmodule = rowdata[6]
			end
		elseif string.find(rowdata[1], "subordinates") then
			menu.highlightedborderstationcategory = rowdata[1]
			if (keepselection and (oldselectedstationcategory == rowdata[1])) or (modified ~= "ctrl") then
				menu.selectedstationcategory = rowdata[1]
			end
		elseif rowdata[1] == "dockedships" then
			menu.highlightedborderstationcategory = "dockedships"
		elseif rowdata[1] == "constructions" then
			menu.highlightedborderstationcategory = "constructions"
		elseif rowdata[1] == "construction" then
			menu.highlightedconstruction = rowdata[3]
			if (modified ~= "ctrl") then
				menu.selectedconstruction = rowdata[3]
			end
		end
		menu.highlightedbordersection = nil
	elseif type(rowdata) == "string" then
		menu.highlightedbordercomponent = nil
		menu.highlightedbordermoduletype = nil
		menu.highlightedborderstationcategory = nil
		menu.selectedstationcategory = nil
		menu.highlightedconstruction = nil
		menu.selectedconstruction = nil
		menu.highlightedbordersection = rowdata
	end

	menu.addSelectedComponents(components, modified)
end
function newFuncs.updateTableSelection(lastcomponent)
	local menu = mapMenu

	menu.refreshMainFrame = true

	-- if (menu.infoTableMode == "objectlist") or (menu.infoTableMode == "propertyowned") then
	-- kuertee start: callback
	if (string.find ("" .. tostring (menu.infoTableMode), "objectlist")) or (string.find ("" .. tostring (menu.infoTableMode), "propertyowned")) then
	-- kuertee end: callback

		-- check if sections need to be extended - if so we need a refresh
		local refresh = false
		for id in pairs(menu.selectedcomponents) do
			local component = ConvertStringTo64Bit(id)
			-- build queues contain components that are not connected to the universe yet
			if IsValidComponent(component) then
				local commanderlist = C.IsComponentClass(component, "controllable") and GetAllCommanders(component) or {}
				for i, entry in ipairs(commanderlist) do
					if (not menu.isPropertyExtended(tostring(entry))) then
						menu.extendedproperty[tostring(entry)] = true
						refresh = true
					end
				end
			end
		end
		if refresh then
			menu.refreshInfoFrame()
			return
		end

		if menu.rowDataMap[menu.infoTable] then
			local rows = {}
			local curRow
			for row, rowdata in pairs(menu.rowDataMap[menu.infoTable]) do
				if type(rowdata) == "table" then
					if rowdata[1] == nil then
						print(TraceBack())
					end
					if (rowdata[1] ~= "moduletype") and (not string.find(rowdata[1], "subordinates")) and (rowdata[1] ~= "dockedships") and (rowdata[1] ~= "constructions") and (rowdata[1] ~= "construction") and menu.isSelectedComponent(rowdata[2]) then
						table.insert(rows, row)
						if ConvertStringTo64Bit(tostring(rowdata[2])) == lastcomponent then
							curRow = row
						end
					elseif (rowdata[1] == "construction") and (rowdata[3].component ~= 0) and menu.isSelectedComponent(rowdata[3].component) then
						table.insert(rows, row)
						if ConvertStringTo64Bit(tostring(rowdata[3].component)) == lastcomponent then
							curRow = row
						end
					elseif (rowdata[1] == "construction") and rowdata[2] and menu.selectedconstruction and (menu.selectedconstruction.id == rowdata[3].id) then
						table.insert(rows, row)
						if ConvertStringTo64Bit(tostring(rowdata[2])) == lastcomponent then
							curRow = row
						end
					elseif string.find(rowdata[1], "subordinates") and (rowdata[1] == menu.selectedstationcategory) then
						table.insert(rows, row)
					end
				end
			end
			SetSelectedRows(menu.infoTable, rows, curRow or (Helper.currentTableRow[menu.infoTable] or 0))
		end
	end
	menu.setSelectedMapComponents()
end
function newFuncs.setupLoadoutInfoSubmenuRows(mode, inputtable, inputobject, instance)
	local menu = mapMenu

	local object64 = ConvertStringTo64Bit(tostring(inputobject))
	local isplayerowned, isonlineobject, isenemy, ishostile = GetComponentData(object64, "isplayerowned", "isonlineobject", "isenemy", "ishostile")
	local titlecolor = Helper.color.white
	if isplayerowned then
		titlecolor = menu.holomapcolor.playercolor
		if object64 == C.GetPlayerObjectID() then
			titlecolor = menu.holomapcolor.currentplayershipcolor
		end
	elseif isonlineobject and menu.getFilterOption("layer_think") and menu.getFilterOption("think_diplomacy_highlightvisitor") then
		titlecolor = menu.holomapcolor.visitorcolor
	elseif ishostile then
		titlecolor = menu.holomapcolor.hostilecolor
	elseif isenemy then
		titlecolor = menu.holomapcolor.enemycolor
	end

	local loadout = {}
	if mode == "ship" or mode == "station" then
		loadout = { ["component"] = {}, ["macro"] = {}, ["ware"] = {} }
		for i, upgradetype in ipairs(Helper.upgradetypes) do
			if upgradetype.supertype == "macro" then
				loadout.component[upgradetype.type] = {}
				local numslots = 0
				if C.IsComponentClass(inputobject, "defensible") then
					numslots = tonumber(C.GetNumUpgradeSlots(inputobject, "", upgradetype.type))
				end
				for j = 1, numslots do
					local current = C.GetUpgradeSlotCurrentComponent(inputobject, upgradetype.type, j)
					if current ~= 0 then
						table.insert(loadout.component[upgradetype.type], current)
					end
				end
			elseif upgradetype.supertype == "virtualmacro" then
				loadout.macro[upgradetype.type] = {}
				local numslots = tonumber(C.GetNumVirtualUpgradeSlots(inputobject, "", upgradetype.type))
				for j = 1, numslots do
					local current = ffi.string(C.GetVirtualUpgradeSlotCurrentMacro(inputobject, upgradetype.type, j))
					if current ~= "" then
						table.insert(loadout.macro[upgradetype.type], current)
					end
				end
			elseif upgradetype.supertype == "software" then
				loadout.ware[upgradetype.type] = {}
				local numslots = C.GetNumSoftwareSlots(inputobject, "")
				local buf = ffi.new("SoftwareSlot[?]", numslots)
				numslots = C.GetSoftwareSlots(buf, numslots, inputobject, "")
				for j = 0, numslots - 1 do
					local current = ffi.string(buf[j].current)
					if current ~= "" then
						table.insert(loadout.ware[upgradetype.type], current)
					end
				end
			elseif upgradetype.supertype == "ammo" then
				loadout.macro[upgradetype.type] = {}
			end
		end
	end

	local cheatsecrecy = false
	-- secrecy stuff
	local nameinfo =					cheatsecrecy or C.IsInfoUnlockedForPlayer(inputobject, "name")
	local defenceinfo_low =				cheatsecrecy or C.IsInfoUnlockedForPlayer(inputobject, "defence_level")
	local defenceinfo_high =			cheatsecrecy or C.IsInfoUnlockedForPlayer(inputobject, "defence_status")
	local unitinfo_capacity =			cheatsecrecy or C.IsInfoUnlockedForPlayer(inputobject, "units_capacity")
	local unitinfo_amount =				cheatsecrecy or C.IsInfoUnlockedForPlayer(inputobject, "units_amount")
	local unitinfo_details =			cheatsecrecy or C.IsInfoUnlockedForPlayer(inputobject, "units_details")
	local equipment_mods =				cheatsecrecy or C.IsInfoUnlockedForPlayer(inputobject, "equipment_mods")

	--- title ---
	local row = inputtable:addRow(false, {fixed = true, bgColor = Helper.defaultTitleBackgroundColor})
	row[1]:setColSpan(13):createText(ReadText(1001, 9413), Helper.headerRow1Properties)

	local objectname = Helper.unlockInfo(nameinfo, ffi.string(C.GetComponentName(inputobject)))
	-- object name
	local row = inputtable:addRow("info_focus", { fixed = true, bgColor = Helper.defaultTitleBackgroundColor })
	row[13]:createButton({ width = config.mapRowHeight, cellBGColor = Helper.color.transparent }):setIcon("menu_center_selection", { width = config.mapRowHeight, height = config.mapRowHeight, y = (Helper.headerRow1Height - config.mapRowHeight) / 2 })
	row[13].handlers.onClick = function () return C.SetFocusMapComponent(menu.holomap, menu.infoSubmenuObject, true) end
	if (mode == "ship") or (mode == "station") then
		row[1]:setBackgroundColSpan(12):setColSpan(6):createText(objectname, Helper.headerRow1Properties)
		row[1].properties.color = titlecolor
		row[7]:setColSpan(6):createText(Helper.unlockInfo(nameinfo, ffi.string(C.GetObjectIDCode(inputobject))), Helper.headerRow1Properties)
		row[7].properties.halign = "right"
		row[7].properties.color = titlecolor
	else
		row[1]:setBackgroundColSpan(12):setColSpan(12):createText(objectname, Helper.headerRow1Properties)
		row[1].properties.color = titlecolor
	end

	if mode == "ship" then
		local pilot = GetComponentData(inputobject, "assignedpilot")
		pilot = ConvertIDTo64Bit(pilot)
		local pilotname, skilltable, postname, aicommandstack, aicommand, aicommandparam, aicommandaction, aicommandactionparam = "-", {}, ReadText(1001, 4847), {}
		if pilot and IsValidComponent(pilot) then
			pilotname, skilltable, postname, aicommandstack, aicommand, aicommandparam, aicommandaction, aicommandactionparam = GetComponentData(pilot, "name", "skills", "postname", "aicommandstack", "aicommand", "aicommandparam", "aicommandaction", "aicommandactionparam")
		end

		local isbigship = C.IsComponentClass(inputobject, "ship_m") or C.IsComponentClass(inputobject, "ship_l") or C.IsComponentClass(inputobject, "ship_xl")
		-- weapon config
		if isplayerowned and (#loadout.component.weapon > 0) then
			local row = inputtable:addRow(false, { bgColor = Helper.defaultTitleBackgroundColor })
			row[1]:setColSpan(13):createText(ReadText(1001, 9409), Helper.headerRowCenteredProperties) -- Weapon Configuration
			-- subheader
			local row = inputtable:addRow(false, { bgColor = Helper.color.unselectable })
			row[3]:setColSpan(5):createText(ReadText(1001, 9410), { font = Helper.standardFontBold }) -- Primary
			row[8]:setColSpan(6):createText(ReadText(1001, 9411), { font = Helper.standardFontBold }) -- Secondary
			-- active weapon groups
			local row = inputtable:addRow("info_weaponconfig_active", { bgColor = Helper.color.transparent })
			row[2]:createText(ReadText(1001, 11218))
			for j = 1, 4 do
				row[2 + j]:createCheckBox(function () return C.GetDefensibleActiveWeaponGroup(inputobject, true) == j end, { width = config.mapRowHeight, height = config.mapRowHeight, symbol = "arrow", bgColor = function () return menu.infoWeaponGroupCheckBoxColor(inputobject, j, true) end })
				row[2 + j].handlers.onClick = function () C.SetDefensibleActiveWeaponGroup(inputobject, true, j) end
			end
			for j = 1, 4 do
				row[7 + j]:createCheckBox(function () return C.GetDefensibleActiveWeaponGroup(inputobject, false) == j end, { width = config.mapRowHeight, height = config.mapRowHeight, symbol = "arrow", bgColor = function () return menu.infoWeaponGroupCheckBoxColor(inputobject, j, false) end })
				row[7 + j].handlers.onClick = function () C.SetDefensibleActiveWeaponGroup(inputobject, false, j) end
			end
			inputtable:addEmptyRow(config.mapRowHeight / 2)
			-- weapons
			for i, gun in ipairs(loadout.component.weapon) do
				local gun = ConvertStringTo64Bit(tostring(gun))
				local numweapongroups = C.GetNumWeaponGroupsByWeapon(inputobject, gun)
				local rawweapongroups = ffi.new("UIWeaponGroup[?]", numweapongroups)
				numweapongroups = C.GetWeaponGroupsByWeapon(rawweapongroups, numweapongroups, inputobject, gun)
				local uiweapongroups = { primary = {}, secondary = {} }
				for j = 0, numweapongroups - 1 do
					-- there are two sets: primary and secondary.
					-- each set has four groups.
					-- .primary tells you if this particular weapon is active in a group in the primary or secondary group set.
					-- .idx tells you which group in that group set it is active in.
					if rawweapongroups[j].primary then
						uiweapongroups.primary[rawweapongroups[j].idx] = true
					else
						uiweapongroups.secondary[rawweapongroups[j].idx] = true
					end
					--print("primary: " .. tostring(rawweapongroups[j].primary) .. ", idx: " .. tostring(rawweapongroups[j].idx))
				end

				local row = inputtable:addRow("info_weaponconfig" .. i, { bgColor = Helper.color.transparent })
				row[2]:createText(ffi.string(C.GetComponentName(gun)))

				-- primary weapon groups
				for j = 1, 4 do
					row[2 + j]:createCheckBox(uiweapongroups.primary[j], { width = config.mapRowHeight, height = config.mapRowHeight, bgColor = function () return menu.infoWeaponGroupCheckBoxColor(inputobject, j, true) end })
					row[2 + j].handlers.onClick = function() menu.infoSetWeaponGroup(inputobject, gun, true, j, not uiweapongroups.primary[j]) end
				end

				-- secondary weapon groups
				for j = 1, 4 do
					row[7 + j]:createCheckBox(uiweapongroups.secondary[j], { width = config.mapRowHeight, height = config.mapRowHeight, bgColor = function () return menu.infoWeaponGroupCheckBoxColor(inputobject, j, false) end })
					row[7 + j].handlers.onClick = function() menu.infoSetWeaponGroup(inputobject, gun, false, j, not uiweapongroups.secondary[j]) end
				end

				if IsComponentClass(gun, "missilelauncher") then
					local nummissiletypes = C.GetNumAllMissiles(inputobject)
					local missilestoragetable = ffi.new("AmmoData[?]", nummissiletypes)
					nummissiletypes = C.GetAllMissiles(missilestoragetable, nummissiletypes, inputobject)

					local gunmacro = GetComponentData(gun, "macro")
					local dropdowndata = {}
					for j = 0, nummissiletypes-1 do
						local ammomacro = ffi.string(missilestoragetable[j].macro)
						if C.IsAmmoMacroCompatible(gunmacro, ammomacro) then
							table.insert(dropdowndata, {id = ammomacro, text = GetMacroData(ammomacro, "name"), icon = "", displayremoveoption = false})
						end
					end

					-- if the ship has no compatible ammunition in ammo storage, have the dropdown print "Out of ammo" and make it inactive.
					local currentammomacro = "empty"
					local dropdownactive = true
					if #dropdowndata == 0 then
						dropdownactive = false
						table.insert(dropdowndata, {id = "empty", text = ReadText(1001, 9412), icon = "", displayremoveoption = false})	-- Out of ammo
					else
						-- NB: currentammomacro can be null
						currentammomacro = ffi.string(C.GetCurrentAmmoOfWeapon(gun))
					end

					row = inputtable:addRow(("info_weaponconfig" .. i .. "_ammo"), { bgColor = Helper.color.transparent })
					row[2]:createText((ReadText(1001, 2800) .. ReadText(1001, 120)))	-- Ammunition, :
					row[3]:setColSpan(11):createDropDown(dropdowndata, {startOption = currentammomacro, active = dropdownactive})
					row[3].handlers.onDropDownConfirmed = function(_, newammomacro) C.SetAmmoOfWeapon(gun, newammomacro) end
				elseif pilot and IsValidComponent(pilot) and IsComponentClass(gun, "bomblauncher") then
					local numbombtypes = C.GetNumAllInventoryBombs(pilot)
					local bombstoragetable = ffi.new("AmmoData[?]", numbombtypes)
					numbombtypes = C.GetAllInventoryBombs(bombstoragetable, numbombtypes, pilot)

					local gunmacro = GetComponentData(gun, "macro")
					local dropdowndata = {}
					for j = 0, numbombtypes-1 do
						local ammomacro = ffi.string(bombstoragetable[j].macro)
						if C.IsAmmoMacroCompatible(gunmacro, ammomacro) then
							table.insert(dropdowndata, {id = ammomacro, text = GetMacroData(ammomacro, "name"), icon = "", displayremoveoption = false})
						end
					end

					-- if the ship has no compatible ammunition in ammo storage, have the dropdown print "Out of ammo" and make it inactive.
					local currentammomacro = "empty"
					local dropdownactive = true
					if #dropdowndata == 0 then
						dropdownactive = false
						table.insert(dropdowndata, {id = "empty", text = ReadText(1001, 9412), icon = "", displayremoveoption = false})	-- Out of ammo
					else
						-- NB: currentammomacro can be null
						currentammomacro = ffi.string(C.GetCurrentAmmoOfWeapon(gun))
					end

					row = inputtable:addRow(("info_weaponconfig" .. i .. "_ammo"), { bgColor = Helper.color.transparent })
					row[2]:createText((ReadText(1001, 2800) .. ReadText(1001, 120)))	-- Ammunition, :
					row[3]:setColSpan(11):createDropDown(dropdowndata, {startOption = currentammomacro, active = dropdownactive})
					row[3].handlers.onDropDownConfirmed = function(_, newammomacro) C.SetAmmoOfWeapon(gun, newammomacro) end
				end
			end
		end
	end
	if (mode == "ship") or (mode == "station") then
		-- turret behaviour
		if isplayerowned and #loadout.component.turret > 0 then
			local hasnormalturrets = false
			local hasmissileturrets = false
			local hasoperationalnormalturrets = false
			local hasoperationalmissileturrets = false

			local row = inputtable:addRow(false, { bgColor = Helper.defaultTitleBackgroundColor })
			row[1]:setColSpan(13):createText(ReadText(1001, 8612), Helper.headerRowCenteredProperties) -- Turret Behaviour
			menu.turrets = {}
			local numslots = tonumber(C.GetNumUpgradeSlots(inputobject, "", "turret"))
			for j = 1, numslots do
				local groupinfo = C.GetUpgradeSlotGroup(inputobject, "", "turret", j)
				if (ffi.string(groupinfo.path) == "..") and (ffi.string(groupinfo.group) == "") then
					local current = C.GetUpgradeSlotCurrentComponent(inputobject, "turret", j)
					if current ~= 0 then
						if (not hasmissileturrets) or (not hasnormalturrets) then
							local ismissileturret = C.IsComponentClass(current, "missileturret")
							hasmissileturrets = hasmissileturrets or ismissileturret
							hasnormalturrets = hasnormalturrets or (not ismissileturret)
						end
						table.insert(menu.turrets, current)
					end
				end
			end

			menu.turretgroups = {}
			local n = C.GetNumUpgradeGroups(inputobject, "")
			local buf = ffi.new("UpgradeGroup2[?]", n)
			n = C.GetUpgradeGroups2(buf, n, inputobject, "")
			for i = 0, n - 1 do
				if (ffi.string(buf[i].path) ~= "..") or (ffi.string(buf[i].group) ~= "") then
					local group = { context = buf[i].contextid, path = ffi.string(buf[i].path), group = ffi.string(buf[i].group) }
					local groupinfo = C.GetUpgradeGroupInfo2(inputobject, "", group.context, group.path, group.group, "turret")
					if (groupinfo.count > 0) then
						group.operational = groupinfo.operational
						group.currentmacro = ffi.string(groupinfo.currentmacro)
						group.slotsize = ffi.string(groupinfo.slotsize)
						if (not hasmissileturrets) or (not hasnormalturrets) then
							local ismissileturret = IsMacroClass(group.currentmacro, "missileturret")
							hasmissileturrets = hasmissileturrets or ismissileturret
							hasnormalturrets = hasnormalturrets or (not ismissileturret)
							if ismissileturret then
								if not hasoperationalmissileturrets then
									hasoperationalmissileturrets = group.operational > 0
								end
							else
								if not hasoperationalnormalturrets then
									hasoperationalnormalturrets = group.operational > 0
								end
							end
						end
						table.insert(menu.turretgroups, group)
					end
				end
			end

			if (#menu.turrets > 0) or (#menu.turretgroups > 0) then
				if mode == "ship" then
					local turretmodes = {
						[1] = { id = "defend",			text = ReadText(1001, 8613),	icon = "",	displayremoveoption = false },
						[2] = { id = "attackenemies",	text = ReadText(1001, 8614),	icon = "",	displayremoveoption = false },
						[3] = { id = "attackcapital",	text = ReadText(1001, 8624),	icon = "",	displayremoveoption = false },
						[4] = { id = "attackfighters",	text = ReadText(1001, 8625),	icon = "",	displayremoveoption = false },
						[5] = { id = "mining",			text = ReadText(1001, 8616),	icon = "",	displayremoveoption = false },
						[6] = { id = "missiledefence",	text = ReadText(1001, 8615),	icon = "",	displayremoveoption = false },
						[7] = { id = "autoassist",		text = ReadText(1001, 8617),	icon = "",	displayremoveoption = false },
					}

					local row = inputtable:addRow("info_turretconfig", { bgColor = Helper.color.transparent })
					row[2]:setColSpan(3):createText(ReadText(1001, 2963))

					-- Start Subsystem Targeting Orders callback
					local sto_callbackVal
					if callbacks ["sto_addTurretBehavioursMapMenu"] then
					  for _, callback in ipairs (callbacks ["sto_addTurretBehavioursMapMenu"]) do
					    sto_callbackVal = callback (row, inputobject)
					  end
					end
					if not sto_callbackVal then
						row[5]:setColSpan(9):createDropDown(turretmodes, { startOption = function () return menu.getDropDownTurretModeOption(inputobject, "all") end })
						row[5].handlers.onDropDownConfirmed = function(_, newturretmode) menu.noupdate = false; C.SetAllTurretModes(inputobject, newturretmode) end
					end
					-- End Subsystem Targeting Orders callback
					row[5].handlers.onDropDownActivated = function () menu.noupdate = true end

					local row = inputtable:addRow("info_turretconfig_2", { bgColor = Helper.color.transparent })
					row[5]:setColSpan(9):createButton({ height = config.mapRowHeight }):setText(function () return menu.areTurretsArmed(inputobject) and ReadText(1001, 8631) or ReadText(1001, 8632) end, { halign = "center" })
					row[5].handlers.onClick = function () return C.SetAllTurretsArmed(inputobject, not menu.areTurretsArmed(inputobject)) end

					local dropdownCount = 1
					for i, turret in ipairs(menu.turrets) do
						inputtable:addEmptyRow(config.mapRowHeight / 2)

						local row = inputtable:addRow("info_turretconfig" .. i, { bgColor = Helper.color.transparent })
						row[2]:setColSpan(3):createText(ffi.string(C.GetComponentName(turret)))
						row[5]:setColSpan(9):createDropDown(turretmodes, { startOption = function () return menu.getDropDownTurretModeOption(turret) end })
						row[5].handlers.onDropDownConfirmed = function(_, newturretmode) menu.noupdate = false; C.SetWeaponMode(turret, newturretmode) end
						row[5].handlers.onDropDownActivated = function () menu.noupdate = true end
						dropdownCount = dropdownCount + 1
						if dropdownCount == 14 then
							inputtable.properties.maxVisibleHeight = inputtable:getFullHeight()
						end

						local row = inputtable:addRow("info_turretconfig" .. i .. "_2", { bgColor = Helper.color.transparent })
						row[5]:setColSpan(9):createButton({ height = config.mapRowHeight }):setText(function () return C.IsWeaponArmed(turret) and ReadText(1001, 8631) or ReadText(1001, 8632) end, { halign = "center" })
						row[5].handlers.onClick = function () return C.SetWeaponArmed(turret, not C.IsWeaponArmed(turret)) end
					end

					for i, group in ipairs(menu.turretgroups) do
						inputtable:addEmptyRow(config.mapRowHeight / 2)

						local name = ReadText(1001, 8023) .. " " .. i .. ((group.currentmacro ~= "") and (" (" .. menu.getSlotSizeText(group.slotsize) .. " " .. GetMacroData(group.currentmacro, "shortname") .. ")") or "")

						local row = inputtable:addRow("info_turretgroupconfig" .. i, { bgColor = Helper.color.transparent })
						row[2]:setColSpan(3):createText(name, { color = (group.operational > 0) and Helper.color.white or Helper.color.red })
						row[5]:setColSpan(9):createDropDown(turretmodes, { startOption = function () return menu.getDropDownTurretModeOption(inputobject, group.context, group.path, group.group) end, active = group.operational > 0 })
						row[5].handlers.onDropDownConfirmed = function(_, newturretmode) menu.noupdate = false; C.SetTurretGroupMode2(inputobject, group.context, group.path, group.group, newturretmode) end
						row[5].handlers.onDropDownActivated = function () menu.noupdate = true end
						dropdownCount = dropdownCount + 1
						if dropdownCount == 14 then
							inputtable.properties.maxVisibleHeight = inputtable:getFullHeight()
						end

						local row = inputtable:addRow("info_turretgroupconfig" .. i .. "_2", { bgColor = Helper.color.transparent })
						row[5]:setColSpan(9):createButton({ height = config.mapRowHeight }):setText(function () return C.IsTurretGroupArmed(inputobject, group.context, group.path, group.group) and ReadText(1001, 8631) or ReadText(1001, 8632) end, { halign = "center" })
						row[5].handlers.onClick = function () return C.SetTurretGroupArmed(inputobject, group.context, group.path, group.group, not C.IsTurretGroupArmed(inputobject, group.context, group.path, group.group)) end
					end
				elseif mode == "station" then
					local turretmodes = {
						[1] = { id = "defend",			text = ReadText(1001, 8613),	icon = "",	displayremoveoption = false },
						[2] = { id = "attackenemies",	text = ReadText(1001, 8614),	icon = "",	displayremoveoption = false },
						[3] = { id = "attackcapital",	text = ReadText(1001, 8624),	icon = "",	displayremoveoption = false },
						[4] = { id = "attackfighters",	text = ReadText(1001, 8625),	icon = "",	displayremoveoption = false },
						[5] = { id = "missiledefence",	text = ReadText(1001, 8615),	icon = "",	displayremoveoption = false },
					}

					if hasnormalturrets then
						-- non-missile
						local row = inputtable:addRow("info_turretconfig", { bgColor = Helper.color.transparent })
						row[2]:setColSpan(3):createText(ReadText(1001, 8397))
						row[5]:setColSpan(9):createDropDown(turretmodes, { startOption = function () return menu.getDropDownTurretModeOption(inputobject, "all", false) end, active = hasoperationalnormalturrets, mouseOverText = (not hasoperationalnormalturrets) and ReadText(1026, 3235) or nil })
						row[5].handlers.onDropDownConfirmed = function(_, newturretmode) menu.noupdate = false; C.SetAllNonMissileTurretModes(inputobject, newturretmode) end
						row[5].handlers.onDropDownActivated = function () menu.noupdate = true end

						local row = inputtable:addRow("info_turretconfig_2", { bgColor = Helper.color.transparent })
						row[5]:setColSpan(9):createButton({ height = config.mapRowHeight }):setText(function () return menu.areTurretsArmed(inputobject, false) and ReadText(1001, 8631) or ReadText(1001, 8632) end, { halign = "center" })
						row[5].handlers.onClick = function () return C.SetAllNonMissileTurretsArmed(inputobject, not menu.areTurretsArmed(inputobject, false)) end
					end
					if hasmissileturrets then
						-- missile
						local row = inputtable:addRow("info_turretconfig_missile", { bgColor = Helper.color.transparent })
						row[2]:setColSpan(3):createText(ReadText(1001, 9031))
						row[5]:setColSpan(9):createDropDown(turretmodes, { startOption = function () return menu.getDropDownTurretModeOption(inputobject, "all", true) end, active = hasoperationalmissileturrets, mouseOverText = (not hasoperationalnormalturrets) and ReadText(1026, 3235) or nil })
						row[5].handlers.onDropDownConfirmed = function(_, newturretmode) menu.noupdate = false; C.SetAllMissileTurretModes(inputobject, newturretmode) end
						row[5].handlers.onDropDownActivated = function () menu.noupdate = true end

						local row = inputtable:addRow("info_turretconfig_missile_2", { bgColor = Helper.color.transparent })
						row[5]:setColSpan(9):createButton({ height = config.mapRowHeight }):setText(function () return menu.areTurretsArmed(inputobject, true) and ReadText(1001, 8631) or ReadText(1001, 8632) end, { halign = "center" })
						row[5].handlers.onClick = function () return C.SetAllMissileTurretsArmed(inputobject, not menu.areTurretsArmed(inputobject, true)) end
					end
				end
			end
		end
		-- drones
		local isplayeroccupiedship = menu.infoSubmenuObject == ConvertStringTo64Bit(tostring(C.GetPlayerOccupiedShipID()))

		local unitstoragetable = C.IsComponentClass(object64, "defensible") and GetUnitStorageData(object64) or { stored = 0, capacity = 0 }
		local locunitcapacity = Helper.unlockInfo(unitinfo_capacity, tostring(unitstoragetable.capacity))
		local locunitcount = Helper.unlockInfo(unitinfo_amount, tostring(unitstoragetable.stored))
		menu.drones = {}
		local dronetypes = {
			{ id = "orecollector",	name = ReadText(20214, 500),	displayonly = true },
			{ id = "gascollector",	name = ReadText(20214, 400),	displayonly = true },
			{ id = "defence",		name = ReadText(20214, 300) },
			{ id = "transport",		name = ReadText(20214, 900) },
			{ id = "build",			name = ReadText(20214, 1000),	skipmode = true },
			{ id = "repair",		name = ReadText(20214, 1100),	skipmode = true },
		}
		for _, dronetype in ipairs(dronetypes) do
			if C.GetNumStoredUnits(inputobject, dronetype.id, false) > 0 then
				local entry
				if not dronetype.skipmode then
					entry = {
						type = dronetype.id,
						name = dronetype.name,
						current = ffi.string(C.GetCurrentDroneMode(inputobject, dronetype.id)),
						modes = {},
						displayonly = dronetype.displayonly,
					}
					local n = C.GetNumDroneModes(inputobject, dronetype.id)
					local buf = ffi.new("DroneModeInfo[?]", n)
					n = C.GetDroneModes(buf, n, inputobject, dronetype.id)
					for i = 0, n - 1 do
						local id = ffi.string(buf[i].id)
						if (id ~= "trade") or (id == entry.current) then
							table.insert(entry.modes, { id = id, text = ffi.string(buf[i].name), icon = "", displayremoveoption = false })
						end
					end
				else
					entry = {
						type = dronetype.id,
						name = dronetype.name,
					}
				end
				table.insert(menu.drones, entry)
			end
		end
		if unitstoragetable.capacity > 0 then
			-- title
			local row = inputtable:addRow(false, { bgColor = Helper.defaultTitleBackgroundColor })
			row[1]:setColSpan(13):createText(ReadText(1001, 8619), Helper.headerRowCenteredProperties)
			-- capcity
			local row = inputtable:addRow(false, { bgColor = Helper.color.unselectable })
			row[2]:createText(ReadText(1001, 8393))
			row[8]:setColSpan(6):createText(locunitcount .. " / " .. locunitcapacity, { halign = "right" })
			-- drones
			if unitinfo_details then
				for i, entry in ipairs(menu.drones) do
					if i ~= 1 then
						inputtable:addEmptyRow(config.mapRowHeight / 2)
					end
					local hasmodes = (mode == "ship") and entry.current
					-- drone name, amount and mode
					local row1 = inputtable:addRow("drone_config", { bgColor = Helper.color.transparent })
					row1[2]:createText(entry.name)
					row1[3]:setColSpan(isplayerowned and 2 or 11):createText(function () return Helper.unlockInfo(unitinfo_amount, C.GetNumStoredUnits(inputobject, entry.type, false)) end, { halign = isplayerowned and "left" or "right" })
					-- active and armed status
					local row2 = inputtable:addRow("drone_config", { bgColor = Helper.color.transparent })
					row2[2]:createText("    " .. ReadText(1001, 11229), { color = hasmodes and function () return C.IsDroneTypeArmed(inputobject, entry.type) and Helper.color.white or Helper.color.grey end or nil })
					row2[3]:setColSpan(isplayerowned and 2 or 11):createText(function () return Helper.unlockInfo(unitinfo_amount, C.GetNumUnavailableUnits(inputobject, entry.type)) end, { halign = isplayerowned and "left" or "right", color = hasmodes and function () return C.IsDroneTypeBlocked(inputobject, entry.type) and Helper.color.warningorange or (C.IsDroneTypeArmed(inputobject, entry.type) and Helper.color.white or Helper.color.grey) end or nil })
					
					-- drone mode support - disabled for mining drones, to avoid conflicts with order defined drone behaviour
					if hasmodes then
						local isblocked = C.IsDroneTypeBlocked(inputobject, entry.type)
						if isplayerowned then
							local active = (isplayeroccupiedship or (not entry.displayonly)) and (not isblocked)
							local mouseovertext = ""
							if isblocked then
								mouseovertext = ReadText(1026, 3229)
							elseif (not isplayeroccupiedship) and entry.displayonly then
								mouseovertext = ReadText(1026, 3230)
							end

							row1[5]:setColSpan(9):createDropDown(entry.modes, { startOption = function () return ffi.string(C.GetCurrentDroneMode(inputobject, entry.type)) end, active = active, mouseOverText = mouseovertext })
							row1[5].handlers.onDropDownConfirmed = function (_, newdronemode) C.SetDroneMode(inputobject, entry.type, newdronemode) end

							row2[5]:setColSpan(9):createButton({ active = active, mouseOverText = mouseovertext, height = config.mapRowHeight }):setText(function () return C.IsDroneTypeArmed(inputobject, entry.type) and ReadText(1001, 8622) or ReadText(1001, 8623) end, { halign = "center" })
							row2[5].handlers.onClick = function () return C.SetDroneTypeArmed(inputobject, entry.type, not C.IsDroneTypeArmed(inputobject, entry.type)) end
						end
					end
				end
			end
		end
		-- subordinates
		if isplayerowned then
			if C.IsComponentClass(inputobject, "controllable") then
				local subordinates = GetSubordinates(inputobject)
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
						else
							local assignment = ffi.string(C.GetSubordinateGroupAssignment(inputobject, group))
							usedassignments[assignment] = group
							groups[group] = { assignment = assignment, subordinates = { subordinate }, numassignableresupplyships = (shiptype == "resupplier") and 1 or 0, numassignableminingships = (purpose == "mine") and 1 or 0 }
						end
					end
				end

				if #subordinates > 0 then
					-- title
					local row = inputtable:addRow(false, { bgColor = Helper.defaultTitleBackgroundColor })
					row[1]:setColSpan(13):createText(ReadText(1001, 8626), Helper.headerRowCenteredProperties)

					local isstation = C.IsComponentClass(inputobject, "station")
					for i = 1, isstation and 4 or 10 do
						if groups[i] then
							local supplyactive = (groups[i].numassignableresupplyships == #groups[i].subordinates) and ((not usedassignments["supplyfleet"]) or (usedassignments["supplyfleet"] == i))
							local subordinateassignments = {
								[1] = { id = "defence",			text = ReadText(20208, 40301),	icon = "",	displayremoveoption = false },
								[2] = { id = "supplyfleet",		text = ReadText(20208, 40701),	icon = "",	displayremoveoption = false, active = supplyactive, mouseovertext = supplyactive and "" or ReadText(1026, 8601) },
							}
							if GetComponentData(inputobject, "shiptype") == "resupplier" then
								table.insert(subordinateassignments, { id = "trade",			text = ReadText(20208, 40101),	icon = "",	displayremoveoption = false })
							end

							if isstation then
								local miningactive = (groups[i].numassignableminingships == #groups[i].subordinates) and ((not usedassignments["mining"]) or (usedassignments["mining"] == i))
								table.insert(subordinateassignments, { id = "mining", text = ReadText(20208, 40201), icon = "", displayremoveoption = false, active = miningactive, mouseovertext = miningactive and "" or ReadText(1026, 8602) })
								local tradeactive = ((not usedassignments["trade"]) or (usedassignments["trade"] == i))
								table.insert(subordinateassignments, { id = "trade", text = ReadText(20208, 40101), icon = "", displayremoveoption = false, active = tradeactive, mouseovertext = tradeactive and ((groups[i].numassignableminingships > 0) and (Helper.convertColorToText(Helper.color.warningorange) .. ReadText(1026, 8607)) or "") or ReadText(1026, 7840) })
								local tradeforbuildstorageactive = (groups[i].numassignableminingships == 0) and ((not usedassignments["tradeforbuildstorage"]) or (usedassignments["tradeforbuildstorage"] == i))
								table.insert(subordinateassignments, { id = "tradeforbuildstorage", text = ReadText(20208, 40801), icon = "", displayremoveoption = false, active = tradeforbuildstorageactive, mouseovertext = tradeforbuildstorageactive and "" or ReadText(1026, 8603) })
							elseif C.IsComponentClass(inputobject, "ship") then
								table.insert(subordinateassignments, { id = "attack", text = ReadText(20208, 40901), icon = "", displayremoveoption = false })
								table.insert(subordinateassignments, { id = "interception", text = ReadText(20208, 41001), icon = "", displayremoveoption = false })
								table.insert(subordinateassignments, { id = "follow", text = ReadText(20208, 41301), icon = "", displayremoveoption = false })
								local active = true
								local mouseovertext = ""
								local buf = ffi.new("Order")
								if not C.GetDefaultOrder(buf, inputobject) then
									active = false
									mouseovertext = ReadText(1026, 8606)
								end
								table.insert(subordinateassignments, { id = "assist", text = ReadText(20208, 41201), icon = "", displayremoveoption = false, active = active, mouseovertext = mouseovertext })
							end

							local isdockingpossible = false
							for _, subordinate in ipairs(groups[i].subordinates) do
								if IsDockingPossible(subordinate, inputobject) then
									isdockingpossible = true
									break
								end
							end
							local active = true
							local mouseovertext = ""
							if not GetComponentData(inputobject, "hasshipdockingbays") then
								active = false
								mouseovertext = ReadText(1026, 8604)
							elseif not isdockingpossible then
								active = false
								mouseovertext = ReadText(1026, 8605)
							end

							local row = inputtable:addRow("subordinate_config", { bgColor = Helper.color.transparent })
							row[2]:createText(function () menu.updateSubordinateGroupInfo(inputobject); return ReadText(20401, i) .. (menu.subordinategroups[i] and (" (" .. ((not C.ShouldSubordinateGroupDockAtCommander(inputobject, i)) and ((#menu.subordinategroups[i].subordinates - menu.subordinategroups[i].numdockedatcommander) .. "/") or "") .. #menu.subordinategroups[i].subordinates ..")") or "") end, { color = isblocked and Helper.color.warningorange or nil })
							row[3]:setColSpan(11):createDropDown(subordinateassignments, { startOption = function () menu.updateSubordinateGroupInfo(inputobject); return menu.subordinategroups[i] and menu.subordinategroups[i].assignment or "" end })
							row[3].handlers.onDropDownActivated = function () menu.noupdate = true end
							row[3].handlers.onDropDownConfirmed = function (_, newassignment) C.SetSubordinateGroupAssignment(inputobject, i, newassignment); menu.noupdate = false end
							local row = inputtable:addRow("subordinate_config", { bgColor = Helper.color.transparent })

							-- Start Reactive Docking callback
							local rd_callbackVal
							if callbacks ["rd_addReactiveDockingMapMenu"] then
				  				for _, callback in ipairs (callbacks ["rd_addReactiveDockingMapMenu"]) do
				    				rd_callbackVal = callback (row, inputobject, i, mode, active, mouseovertext)
				  				end
							end
							if not rd_callbackVal then
								row[3]:setColSpan(11):createButton({ active = active, mouseOverText = mouseovertext, height = config.mapRowHeight }):setText(function () return C.ShouldSubordinateGroupDockAtCommander(inputobject, i) and ReadText(1001, 8630) or ReadText(1001, 8629) end, { halign = "center" })
								row[3].handlers.onClick = function () return C.SetSubordinateGroupDockAtCommander(inputobject, i, not C.ShouldSubordinateGroupDockAtCommander(inputobject, i)) end
							end
							-- End Reactive Docking callback
						end
					end
				end
			end
		end
		-- ammunition
		local nummissiletypes = C.GetNumAllMissiles(inputobject)
		local missilestoragetable = ffi.new("AmmoData[?]", nummissiletypes)
		nummissiletypes = C.GetAllMissiles(missilestoragetable, nummissiletypes, inputobject)
		local totalnummissiles = 0
		for i = 0, nummissiletypes - 1 do
			totalnummissiles = totalnummissiles + missilestoragetable[i].amount
		end
		local missilecapacity = 0
		if C.IsComponentClass(inputobject, "defensible") then
			missilecapacity = GetComponentData(inputobject, "missilecapacity")
		end
		local locmissilecapacity = Helper.unlockInfo(defenceinfo_low, tostring(missilecapacity))
		local locnummissiles = Helper.unlockInfo(defenceinfo_high, tostring(totalnummissiles))
		if totalnummissiles > 0 then
			-- title
			local row = inputtable:addRow(false, { bgColor = Helper.defaultTitleBackgroundColor })
			row[1]:setColSpan(12):createText(ReadText(1001, 2800), Helper.headerRowCenteredProperties) -- Ammunition
			-- capcity
			local row = inputtable:addRow(false, { bgColor = Helper.color.unselectable })
			row[2]:createText(ReadText(1001, 8393))
			row[8]:setColSpan(6):createText(locnummissiles .. " / " .. locmissilecapacity, { halign = "right" })
			if defenceinfo_high then
				for i = 0, nummissiletypes - 1 do
					local macro = ffi.string(missilestoragetable[i].macro)
					local row = inputtable:addRow({ "info_weapons", macro, inputobject }, { bgColor = Helper.color.transparent })
					row[2]:createText(GetMacroData(macro, "name"))
					row[8]:setColSpan(6):createText(tostring(missilestoragetable[i].amount), { halign = "right" })
				end
			end
		end
	end
	if mode == "ship" then
		-- countermeasures
		local numcountermeasuretypes = C.GetNumAllCountermeasures(inputobject)
		local countermeasurestoragetable = ffi.new("AmmoData[?]", numcountermeasuretypes)
		numcountermeasuretypes = C.GetAllCountermeasures(countermeasurestoragetable, numcountermeasuretypes, inputobject)
		local totalnumcountermeasures = 0
		for i = 0, numcountermeasuretypes - 1 do
			totalnumcountermeasures = totalnumcountermeasures + countermeasurestoragetable[i].amount
		end
		local countermeasurecapacity = GetComponentData(object64, "countermeasurecapacity")
		local loccountermeasurecapacity = Helper.unlockInfo(defenceinfo_low, tostring(countermeasurecapacity))
		local locnumcountermeasures = Helper.unlockInfo(defenceinfo_high, tostring(totalnumcountermeasures))
		if totalnumcountermeasures > 0 then
			-- title
			local row = inputtable:addRow(false, { bgColor = Helper.defaultTitleBackgroundColor })
			row[1]:setColSpan(13):createText(ReadText(20215, 1701), Helper.headerRowCenteredProperties) -- Countermeasures
			-- capcity
			local row = inputtable:addRow(false, { bgColor = Helper.color.unselectable })
			row[2]:createText(ReadText(1001, 8393))
			row[8]:setColSpan(6):createText(locnumcountermeasures .. " / " .. loccountermeasurecapacity, { halign = "right" })
			if defenceinfo_high then
				for i = 0, numcountermeasuretypes - 1 do
					local row = inputtable:addRow(true, { bgColor = Helper.color.transparent, interactive = false })
					row[2]:createText(GetMacroData(ffi.string(countermeasurestoragetable[i].macro), "name"))
					row[8]:setColSpan(6):createText(tostring(countermeasurestoragetable[i].amount), { halign = "right" })
				end
			end
		end
		-- deployables
		local consumables = {
			{ id = "satellite",		type = "civilian",	getnum = C.GetNumAllSatellites,		getdata = C.GetAllSatellites,		callback = C.LaunchSatellite },
			{ id = "navbeacon",		type = "civilian",	getnum = C.GetNumAllNavBeacons,		getdata = C.GetAllNavBeacons,		callback = C.LaunchNavBeacon },
			{ id = "resourceprobe",	type = "civilian",	getnum = C.GetNumAllResourceProbes,	getdata = C.GetAllResourceProbes,	callback = C.LaunchResourceProbe },
			{ id = "lasertower",	type = "military",	getnum = C.GetNumAllLaserTowers,	getdata = C.GetAllLaserTowers,		callback = C.LaunchLaserTower },
			{ id = "mine",			type = "military",	getnum = C.GetNumAllMines,			getdata = C.GetAllMines,			callback = C.LaunchMine },
		}
		local totalnumdeployables = 0
		local consumabledata = {}
		for _, entry in ipairs(consumables) do
			local n = entry.getnum(inputobject)
			local buf = ffi.new("AmmoData[?]", n)
			n = entry.getdata(buf, n, inputobject)
			consumabledata[entry.id] = {}
			for i = 0, n - 1 do
				table.insert(consumabledata[entry.id], { macro = ffi.string(buf[i].macro), name = GetMacroData(ffi.string(buf[i].macro), "name"), amount = buf[i].amount, capacity = buf[i].capacity })
				totalnumdeployables = totalnumdeployables + buf[i].amount
			end
		end
		local deployablecapacity = C.GetDefensibleDeployableCapacity(inputobject)
		local printednumdeployables = Helper.unlockInfo(defenceinfo_low, tostring(totalnumdeployables))
		local printeddeployablecapacity = Helper.unlockInfo(defenceinfo_low, tostring(deployablecapacity))
		if totalnumdeployables > 0 then
			-- title
			local row = inputtable:addRow(false, { bgColor = Helper.defaultTitleBackgroundColor })
			row[1]:setColSpan(13):createText(ReadText(1001, 1332), Helper.headerRowCenteredProperties) -- Deployables
			-- capcity
			local row = inputtable:addRow(false, { bgColor = Helper.color.unselectable })
			row[2]:createText(ReadText(1001, 8393))
			row[8]:setColSpan(6):createText(printednumdeployables .. " / " .. printeddeployablecapacity, { halign = "right" })
			if defenceinfo_high then
				for _, entry in ipairs(consumables) do
					if #consumabledata[entry.id] > 0 then
						for _, data in ipairs(consumabledata[entry.id]) do
							local row = inputtable:addRow({ "info_deploy", data.macro, inputobject }, { bgColor = Helper.color.transparent })
							row[2]:createText(data.name)
							row[8]:setColSpan(6):createText(data.amount, { halign = "right" })
						end
					end
				end
				if isplayerowned then
					-- deploy
					local row = inputtable:addRow("info_deploy", { bgColor = Helper.color.transparent })
					row[3]:setColSpan(11):createButton({ height = config.mapRowHeight, active = function () return next(menu.infoTablePersistentData[instance].macrostolaunch) ~= nil end }):setText(ReadText(1001, 8390), { halign = "center" })
					row[3].handlers.onClick = function () return menu.buttonDeploy(instance) end
				end
			end
		end
	end
	if (mode == "ship") or (mode == "station") then
		-- loadout
		if (#loadout.component.weapon > 0) or (#loadout.component.turret > 0) or (#loadout.component.shield > 0) or (#loadout.component.engine > 0) or (#loadout.macro.thruster > 0) or (#loadout.ware.software > 0) then
			if defenceinfo_high then
				local hasshown = false
				-- title
				local row = inputtable:addRow(false, { bgColor = Helper.defaultTitleBackgroundColor })
				row[1]:setColSpan(13):createText(ReadText(1001, 9413), Helper.headerRowCenteredProperties) -- Loadout
				local row = inputtable:addRow(false, { bgColor = Helper.color.unselectable })
				row[2]:setColSpan(5):createText(ReadText(1001, 7935), { font = Helper.standardFontBold })
				row[7]:setColSpan(4):createText(ReadText(1001, 1311), { font = Helper.standardFontBold, halign = "right" })
				row[11]:setColSpan(3):createText(ReadText(1001, 12), { font = Helper.standardFontBold, halign = "right" })

				inputtable:addEmptyRow(config.mapRowHeight / 2)

				local macroequipment = {
					{ type = "weapon", encyclopedia = "info_weapon" },
					{ type = "turret", encyclopedia = "info_weapon" },
					{ type = "shield", encyclopedia = "info_equipment" },
					{ type = "engine", encyclopedia = "info_equipment" },
				}
				for _, entry in ipairs(macroequipment) do
					if #loadout.component[entry.type] > 0 then
						if hasshown then
							inputtable:addEmptyRow(config.mapRowHeight / 2)
						end
						hasshown = true
						local locmacros = menu.infoCombineLoadoutComponents(loadout.component[entry.type])
						for macro, data in pairs(locmacros) do
							local row = inputtable:addRow({ entry.encyclopedia, macro, inputobject }, { bgColor = Helper.color.transparent })
							row[2]:setColSpan(5):createText(GetMacroData(macro, "name"))
							row[7]:setColSpan(4):createText(data.count .. " / " .. data.count + data.construction, { halign = "right" })
							local shieldpercent = data.shieldpercent
							local hullpercent = data.hullpercent
							if data.count > 0 then
								shieldpercent = shieldpercent / data.count
								hullpercent = hullpercent / data.count
							end
							row[11]:setColSpan(3):createShieldHullBar(shieldpercent, hullpercent, { scaling = false, width = row[11]:getColSpanWidth() / 2, x = row[11]:getColSpanWidth() / 4 })

							AddKnownItem(GetMacroData(macro, "infolibrary"), macro)
						end
					end
				end

				if #loadout.macro.thruster > 0 then
					if hasshown then
						inputtable:addEmptyRow(config.mapRowHeight / 2)
					end
					hasshown = true
					-- ships normally only have 1 set of thrusters. in case a ship has more, this will list all of them.
					for i, val in ipairs(loadout.macro.thruster) do
						local row = inputtable:addRow({ "info_equipment", macro, inputobject }, { bgColor = Helper.color.transparent })
						row[2]:setColSpan(12):createText(GetMacroData(val, "name"))

						AddKnownItem(GetMacroData(val, "infolibrary"), val)
					end
				end
				if #loadout.ware.software > 0 then
					if hasshown then
						inputtable:addEmptyRow(config.mapRowHeight / 2)
					end
					hasshown = true
					for i, val in ipairs(loadout.ware.software) do
						local row = inputtable:addRow({ "info_software", val, inputobject }, { bgColor = Helper.color.transparent })
						row[2]:setColSpan(12):createText(GetWareData(val, "name"))

						AddKnownItem("software", val)
					end
				end
			else
				local row = inputtable:addRow(false, { bgColor = Helper.color.unselectable })
				row[2]:setColSpan(12):createText(ReadText(1001, 3210))
			end
		end
	end
	if mode == "ship" then
		-- mods
		-- title
		local row = inputtable:addRow(false, { bgColor = Helper.defaultTitleBackgroundColor })
		row[1]:setColSpan(13):createText(ReadText(1001, 8031), Helper.headerRowCenteredProperties)
		if equipment_mods and GetComponentData(object64, "hasanymod") then
			local hasshown = false
			-- chassis
			local hasinstalledmod, installedmod = Helper.getInstalledModInfo("ship", inputobject)
			if hasinstalledmod then
				if hasshown then
					inputtable:addEmptyRow(config.mapRowHeight / 2)
				end
				hasshown = true
				row = menu.addEquipmentModInfoRow(inputtable, "ship", installedmod, ReadText(1001, 8008))
			end
			-- weapon
			for i, weapon in ipairs(loadout.component.weapon) do
				local hasinstalledmod, installedmod = Helper.getInstalledModInfo("weapon", weapon)
				if hasinstalledmod then
					if hasshown then
						inputtable:addEmptyRow(config.mapRowHeight / 2)
					end
					hasshown = true
					row = menu.addEquipmentModInfoRow(inputtable, "weapon", installedmod, ffi.string(C.GetComponentName(weapon)))
				end
			end
			-- turret
			for i, turret in ipairs(loadout.component.turret) do
				local hasinstalledmod, installedmod = Helper.getInstalledModInfo("turret", turret)
				if hasinstalledmod then
					if hasshown then
						inputtable:addEmptyRow(config.mapRowHeight / 2)
					end
					hasshown = true
					row = menu.addEquipmentModInfoRow(inputtable, "weapon", installedmod, ffi.string(C.GetComponentName(turret)))
				end
			end
			-- shield
			local shieldgroups = {}
			local n = C.GetNumShieldGroups(inputobject)
			local buf = ffi.new("ShieldGroup[?]", n)
			n = C.GetShieldGroups(buf, n, inputobject)
			for i = 0, n - 1 do
				local entry = {}
				entry.context = buf[i].context
				entry.group = ffi.string(buf[i].group)
				entry.component = buf[i].component

				table.insert(shieldgroups, entry)
			end
			for i, entry in ipairs(shieldgroups) do
				if (entry.context == inputobject) and (entry.group == "") then
					shieldgroups.hasMainGroup = true
					-- force maingroup to first index
					table.insert(shieldgroups, 1, entry)
					table.remove(shieldgroups, i + 1)
					break
				end
			end
			for i, shieldgroupdata in ipairs(shieldgroups) do
				local hasinstalledmod, installedmod = Helper.getInstalledModInfo("shield", inputobject, shieldgroupdata.context, shieldgroupdata.group)
				if hasinstalledmod then
					local name = GetMacroData(GetComponentData(ConvertStringTo64Bit(tostring(shieldgroupdata.component)), "macro"), "name")
					if (i == 1) and shieldgroups.hasMainGroup then
						name = ReadText(1001, 8044)
					end
					if hasshown then
						inputtable:addEmptyRow(config.mapRowHeight / 2)
					end
					hasshown = true
					row = menu.addEquipmentModInfoRow(inputtable, "shield", installedmod, name)
				end
			end
			-- engine
			local hasinstalledmod, installedmod = Helper.getInstalledModInfo("engine", inputobject)
			if hasinstalledmod then
				if hasshown then
					inputtable:addEmptyRow(config.mapRowHeight / 2)
				end
				hasshown = true
				row = menu.addEquipmentModInfoRow(inputtable, "engine", installedmod, ffi.string(C.GetComponentName(loadout.component.engine[1])))
			end
		else
			local row = inputtable:addRow(false, { bgColor = Helper.color.unselectable })
			row[2]:setColSpan(12):createText(Helper.unlockInfo(equipment_mods, ReadText(1001, 8394)))
		end
	end
	if mode == "none" then
		local row = inputtable:addRow(false, { bgColor = Helper.color.unselectable })
		row[2]:setColSpan(12):createText(ReadText(1001, 6526))
	end
end
