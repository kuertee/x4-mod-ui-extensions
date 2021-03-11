local config = {
	mainFrameLayer = 6,
	infoFrameLayer2 = 5,
	infoFrameLayer = 4,
	contextFrameLayer = 3,

	complexOrderParams = {
		["trade"] = {
			[1] = { id = "trade_location", name = ReadText(1001, 2943), type = "object", inputparams = { class = "sector" }, value = function (data) return next(data) and data.station and GetComponentData(data.station, "zoneid") or nil end },
			[2] = { id = "trade_partner", name = ReadText(1001, 23), type = "object", inputparams = { class = "container" }, value = function (data) return data.station end },
			[3] = { id = "trade_ware", name = ReadText(1001, 7104), type = "trade_ware", value = function (data) return next(data) and data.ware and {data.isbuyoffer, data.ware} or nil end },
			[4] = { id = "trade_amount", name = ReadText(1001, 6521), type = "trade_amount", value = function (data) return data.ware and {data.desiredamount, data.amount} or nil end },
			data = function (value) return (value and menu.isInfoModeValidFor(menu.infoSubmenuObject, "orderqueue") and GetTradeData(value, ConvertStringTo64Bit(tostring(menu.infoSubmenuObject)))) or {} end
		}
	},
	moduletypes = {
		{ type = "moduletypes_production", name = ReadText(1001, 2421) },
		{ type = "moduletypes_build",      name = ReadText(1001, 2439) },
		{ type = "moduletypes_storage",    name = ReadText(1001, 2422) },
		{ type = "moduletypes_habitation", name = ReadText(1001, 2451) },
		{ type = "moduletypes_dock",       name = ReadText(1001, 2452) },
		{ type = "moduletypes_defence",    name = ReadText(1001, 2424) },
		{ type = "moduletypes_other",      name = ReadText(1001, 2453) },
		{ type = "moduletypes_venture",    name = ReadText(1001, 2454) },
	},
	stateKeys = {
		{"mode"},
		{"modeparam"},
		{"lastactivetable"},
		{"focuscomponent", "UniverseID"},
		{"currentsector", "UniverseID"},
		{"selectedcomponents"},
		{"searchtext"},
		{"infoTableMode"},
		{"searchTableMode"},
		{"infoSubmenuObject", "UniverseID"},
		{"showMultiverse", "bool"},
	},
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
	leftBarMultiverse = {
		{ name = ReadText(1001, 11288),	icon = "vt_season",					mode = "ventureseason",		helpOverlayID = "multimap_season",				helpOverlayText = ReadText(1028, 3263) },
		{ spacing = true, },
		{ name = ReadText(1001, 11318),	icon = "vt_mission",				mode = "ventureoperation",	helpOverlayID = "multimap_operation",			helpOverlayText = ReadText(1028, 3266) },
		{ name = ReadText(1001, 8802),	icon = "vt_reward",					mode = "ventureoutcomes",	helpOverlayID = "multimap_rewards",				helpOverlayText = ReadText(1028, 3265) },
		{ name = ReadText(1001, 11319),	icon = "vt_logbook",				mode = "venturelogbook",	helpOverlayID = "multimap_logbook",				helpOverlayText = ReadText(1028, 3267) },
		{ spacing = true, },
		{ name = ReadText(1001, 11320),	icon = "vt_team",					mode = "ventureteam",		helpOverlayID = "multimap_team",				helpOverlayText = ReadText(1028, 3268) },
		{ name = ReadText(1001, 7720),	icon = "vt_inventory",				mode = "ventureinventory",	helpOverlayID = "multimap_inventory",			helpOverlayText = ReadText(1028, 3269) },
	},
	rightBar = {
		{ name = ReadText(1001, 3227),	icon = "mapst_filtersystem",		mode = "filter",		helpOverlayID = "mapst_filter",						helpOverlayText = ReadText(1028, 3212) },
		{ name = ReadText(1001, 9801),	icon = "mapst_legend",				mode = "legend",		helpOverlayID = "mapst_legend",						helpOverlayText = ReadText(1028, 3213) },
		{ spacing = true },
		{ name = ReadText(1001, 2427),	icon = "mapst_information",			mode = "info",			helpOverlayID = "map_sidebar_information2",			helpOverlayText = ReadText(1028, 3209) },
	},
	infoCategories = {
		{ category = "objectinfo",				name = ReadText(1001, 2427),	icon = "mapst_information",			helpOverlayID = "mapst_ao_information",			helpOverlayText = ReadText(1028, 3234) },
		{ category = "objectcrew",				name = ReadText(1001, 80),		icon = "shipbuildst_crew",			helpOverlayID = "mapst_ao_info_crew",			helpOverlayText = ReadText(1028, 3237) },
		{ category = "objectloadout",			name = ReadText(1001, 9413),	icon = "mapst_loadout",				helpOverlayID = "mapst_ao_info_loadout",		helpOverlayText = ReadText(1028, 3238) },
		{ category = "objectlogbook",			name = ReadText(1001, 5700),	icon = "pi_logbook",				helpOverlayID = "mapst_ao_info_logbook",		helpOverlayText = ReadText(1028, 3238) },
		{ empty = true },
		{ category = "orderqueue",				name = ReadText(1001, 8360),	icon = "mapst_ao_orderqueue",		helpOverlayID = "mapst_ao_orderqueue",			helpOverlayText = ReadText(1028, 3235) },
		{ category = "orderqueue_advanced",		name = ReadText(1001, 8361),	icon = "mapst_orderqueue_advanced",	helpOverlayID = "mapst_ao_orderqueue_advanced",	helpOverlayText = ReadText(1028, 3236) },
		{ category = "standingorders",			name = ReadText(1001, 8396),	icon = "mapst_standing_orders",		helpOverlayID = "mapst_ao_standing_orders",		helpOverlayText = ReadText(1028, 3239) },
	},
	objectCategories = {
		{ category = "objectall",				name = ReadText(1001, 8380),	icon = "mapst_objectlist",			helpOverlayID = "mapst_ol_objectlist",			helpOverlayText = ReadText(1028, 3220) },
		{ category = "stations",				name = ReadText(1001, 8379),	icon = "mapst_ol_stations",			helpOverlayID = "mapst_ol_stations",			helpOverlayText = ReadText(1028, 3221) },
		{ category = "ships",					name = ReadText(1001, 6),		icon = "mapst_ol_ships",			helpOverlayID = "mapst_ol_fleets",				helpOverlayText = ReadText(1028, 3222) },
		{ category = "deployables",				name = ReadText(1001, 1332),	icon = "mapst_ol_deployables",		helpOverlayID = "mapst_ol_deployables",			helpOverlayText = ReadText(1028, 3226) },
	},
	propertyCategories = {
		{ category = "propertyall",				name = ReadText(1001, 8380),	icon = "mapst_propertyowned",		helpOverlayID = "mapst_po_propertyowned",		helpOverlayText = ReadText(1028, 3220) },
		{ category = "stations",				name = ReadText(1001, 8379),	icon = "mapst_ol_stations",			helpOverlayID = "mapst_po_stations",			helpOverlayText = ReadText(1028, 3221) },
		{ category = "fleets",					name = ReadText(1001, 8326),	icon = "mapst_ol_fleets",			helpOverlayID = "mapst_po_fleets",				helpOverlayText = ReadText(1028, 3223) },
		{ category = "unassignedships",			name = ReadText(1001, 8327),	icon = "mapst_ol_unassigned",		helpOverlayID = "mapst_po_unassigned",			helpOverlayText = ReadText(1028, 3224) },
		{ category = "inventoryships",			name = ReadText(1001, 8381),	icon = "mapst_ol_inventory",		helpOverlayID = "mapst_po_inventory",			helpOverlayText = ReadText(1028, 3225) },
		{ category = "deployables",				name = ReadText(1001, 1332),	icon = "mapst_ol_deployables",		helpOverlayID = "mapst_po_deployables",			helpOverlayText = ReadText(1028, 3226) },
	},
	seasonCategories = {
		{ category = "currentseason",			name = ReadText(1001, 11322),	icon = "vt_season_current",			helpOverlayID = "mapst_ven_curseason",			helpOverlayText = ReadText(1028, 3270) },
		{ category = "coalition",				name = ReadText(1001, 11323),	icon = "vt_guild",					helpOverlayID = "mapst_ven_coalitions",			helpOverlayText = ReadText(1028, 3271) },
		{ category = "pastseasons",				name = ReadText(1001, 11324),	icon = "vt_season_previous",		helpOverlayID = "mapst_ven_pastseason",			helpOverlayText = ReadText(1028, 3264) },
	},
	ventureInventoryCategories = {
		{ category = "playerinventory",			name = ReadText(1001, 11326),	icon = "vt_inventory_player",		helpOverlayID = "mapst_ven_playerinventory",	helpOverlayText = ReadText(1028, 3269) },
		{ category = "teaminventory",			name = ReadText(1001, 11327),	icon = "vt_inventory_team",			helpOverlayID = "mapst_ven_teaminventory",		helpOverlayText = ReadText(1028, 3272) },
	},
	layers = {
		{ name = ReadText(1001, 3252),	icon = "mapst_fs_trade",		mode = "layer_trade",		helpOverlayID = "layer_trade",		helpOverlayText = ReadText(1028, 3214)  },
		{ name = ReadText(1001, 8329),	icon = "mapst_fs_mining",		mode = "layer_mining",		helpOverlayID = "layer_mining",		helpOverlayText = ReadText(1028, 3216)  },
		{ name = ReadText(1001, 3254),	icon = "mapst_fs_other",		mode = "layer_other",		helpOverlayID = "layer_other",		helpOverlayText = ReadText(1028, 3217)  },
	},
	layersettings = {
		["layer_trade"] = {
			callback = function (value) return C.SetMapRenderTradeOffers(menu.holomap, value) end,
			[1] = {
				caption = ReadText(1001, 46),
				info = ReadText(1001, 3279),
				overrideText = ReadText(1001, 8378),
				type = "multiselectlist",
				id = "trade_wares",
				callback = function (...) return menu.filterTradeWares(...) end,
				listOptions = function (...) return menu.getFilterTradeWaresOptions(...) end,
				displayOption = function (option) return "\27[maptr_supply] " .. GetWareData(option, "name") end,
			},
			[2] = {
				caption = ReadText(1001, 1400),
				type = "checkbox",
				callback = function (...) return menu.filterTradeStorage(...) end,
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
			},
			[3] = {
				caption = ReadText(1001, 2808),
				type = "slidercell",
				callback = function (...) return menu.filterTradePrice(...) end,
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
				callback = function (...) return menu.filterTradeVolume(...) end,
				[1] = {
					id = "trade_volume",
					info = ReadText(1001, 8358),
					listOptions = function (...) return menu.getFilterTradeVolumeOptions(...) end,
					param = "volume"
				},
			},
			[5] = {
				caption = ReadText(1001, 11205),
				type = "dropdown",
				callback = function (...) return menu.filterTradePlayerOffer(...) end,
				[1] = {
					id = "trade_playeroffer_buy",
					info = ReadText(1001, 11209),
					listOptions = function (...) return menu.getFilterTradePlayerOfferOptions(true) end,
					param = "playeroffer_buy"
				},
				[2] = {
					id = "trade_playeroffer_sell",
					info = ReadText(1001, 11210),
					listOptions = function (...) return menu.getFilterTradePlayerOfferOptions(false) end,
					param = "playeroffer_sell"
				},
			},
			[6] = {
				caption = ReadText(1001, 11240),
				type = "checkbox",
				callback = function (...) return menu.filterTradeRelation(...) end,
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
				callback = function (...) return menu.filterTradeOffer(...) end,
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
			callback = function (value) return menu.filterMining(value) end,
			[1] = {
				caption = ReadText(1001, 8330),
				type = "checkbox",
				callback = function (...) return menu.filterMiningResources(...) end,
				[1] = {
					id = "mining_resource_display",
					name = ReadText(1001, 8331),
					info = ReadText(1001, 8332),
					param = "display"
				},
			},
		},
		["layer_other"] = {
			callback = function (value) return menu.filterOther(value) end,
			[1] = {
				caption = ReadText(1001, 3285),
				type = "dropdown",
				callback = function (...) return menu.filterThinkAlert(...) end,
				[1] = {
					info = ReadText(1001, 3286),
					id = "think_alert",
					listOptions = function (...) return menu.getFilterThinkAlertOptions(...) end,
					param = "alert"
				},
			},
			[2] = {
				caption = ReadText(1001, 11204),
				type = "checkbox",
				callback = function (...) return menu.filterThinkDiplomacy(...) end,
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
				callback = function (...) return menu.filterOtherMisc(...) end,
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
				callback = function (...) return menu.filterOtherShip(...) end,
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
				callback = function (...) return menu.filterOtherStation(...) end,
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

	classOrder = {
		["station"]		= 1,
		["ship_xl"]		= 2,
		["ship_l"]		= 3,
		["ship_m"]		= 4,
		["ship_s"]		= 5,
		["ship_xs"]		= 6,
	},
	purposeOrder = {
		["fight"]		= 1,
		["auxiliary"]	= 2,
		["build"]		= 3,
		["mine"]		= 4,
		["trade"]		= 5,
	},

	missionMainTypeOrder = {
		["plot"] = 1,
		["tutorial"] = 2,
		["generic"] = 3,
		["upkeep"] = 4,
		["guidance"] = 5,
	},

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
	},

	missionContextWidth = 400,
	missionContextIconWidthFactor = 0.4,

	autopilotmarker = ">> ",
	softtargetmarker_l = "> ",

	tradeContextMenuWidth = math.min(Helper.scaleX(900), 0.5 * Helper.viewWidth + Helper.scrollbarWidth),
	tradeContextMenuInfoBorder = 15,

	legend = {
		-- hexes
		{ icon = "maplegend_hexagon_fog_01",		text = ReadText(10002, 606),	width = Helper.sidebarWidth,	height = Helper.sidebarWidth },														-- Unknown location
		{ icon = "maplegend_hexagon_01",			text = ReadText(1001, 9806),	width = Helper.sidebarWidth,	height = Helper.sidebarWidth,	color = { r = 255, g = 0, b = 0, a = 100 } },		-- Mineral Region
		{ icon = "maplegend_hexagon_01",			text = ReadText(1001, 9807),	width = Helper.sidebarWidth,	height = Helper.sidebarWidth,	color = { r = 0, g = 0, b = 255, a = 100 }  },		-- Gas Region
		{ icon = "maplegend_hexagon_01",			text = ReadText(1001, 9812),	width = Helper.sidebarWidth,	height = Helper.sidebarWidth,	color = { r = 255, g = 0, b = 255, a = 100 }  },	-- Mineral/Gas Region
		-- highways, gates, etc
		{ icon = "solid",							text = ReadText(1001, 9809),	width = Helper.sidebarWidth,	height = Helper.standardTextHeight / 2,	minRowHeight = Helper.sidebarWidth / 2 },	-- Jump Gate Connection
		{ icon = "maplegend_hw_01",					text = ReadText(20001, 601),	width = Helper.sidebarWidth,	height = Helper.sidebarWidth / 2,	color = "superhighwaycolor" },					-- Superhighway
		{ icon = "maplegend_hw_01",					text = ReadText(20001, 501),	width = Helper.sidebarWidth,	height = Helper.sidebarWidth / 2,	color = "highwaycolor" },						-- Local Highway
		{ icon = "mapob_jumpgate",					text = ReadText(20001, 701),	color = "gatecolor" },			-- Jump Gate
		{ icon = "mapob_transorbital_accelerator",	text = ReadText(20001, 1001),	color = "gatecolor" },			-- Accelarator
		{ icon = "mapob_superhighway",				text = ReadText(1001, 9810),	color = "highwaygatecolor" },	-- Superhighway Gate
		{ icon = "ship_s_fight_01",					text = ReadText(1001, 5200),	color = "playercolor" },		-- Owned
		{ icon = "ship_s_fight_01",					text = ReadText(1001, 5202),	color = "friendcolor" },		-- Neutral
		{ icon = "ship_s_fight_01",					text = ReadText(1001, 5201),	color = "enemycolor" },			-- Enemy
		{ icon = "ship_s_fight_01",					text = ReadText(1001, 5212),	color = "hostilecolor" },		-- Hostile
		-- stations
		{ text = ReadText(1001, 4) },																																					-- Stations
		{ icon = "mapob_playerhq",					text = ReadText(20102, 2011),	width = 0.8 * Helper.sidebarWidth,	height = 0.8 * Helper.sidebarWidth,	color = "playercolor" },	-- Headquarters
		{ icon = "maplegend_hq_01",					text = ReadText(1001, 9808),	width = 0.8 * Helper.sidebarWidth,	height = 0.8 * Helper.sidebarWidth,	color = "friendcolor" },	-- Faction Headquarters
		{ icon = "mapob_shipyard",					text = ReadText(1001, 92),		width = 0.8 * Helper.sidebarWidth,	height = 0.8 * Helper.sidebarWidth,	color = "friendcolor" },	-- Shipyard
		{ icon = "mapob_wharf",						text = ReadText(1001, 9805),	width = 0.8 * Helper.sidebarWidth,	height = 0.8 * Helper.sidebarWidth,	color = "friendcolor" },	-- Wharf
		{ icon = "mapob_equipmentdock",				text = ReadText(1001, 9804),	width = 0.8 * Helper.sidebarWidth,	height = 0.8 * Helper.sidebarWidth,	color = "friendcolor" },	-- Equipment Dock
		{ icon = "mapob_tradestation",				text = ReadText(1001, 9803),	width = 0.8 * Helper.sidebarWidth,	height = 0.8 * Helper.sidebarWidth,	color = "friendcolor" },	-- Trading Station
		{ icon = "mapob_defensestation",			text = ReadText(1001, 9802),	width = 0.8 * Helper.sidebarWidth,	height = 0.8 * Helper.sidebarWidth,	color = "friendcolor" },	-- Defence Platform
		{ icon = "mapob_piratestation",				text = ReadText(20102, 1511),	width = 0.8 * Helper.sidebarWidth,	height = 0.8 * Helper.sidebarWidth,	color = "friendcolor" },	-- Free Port
		{ icon = "mapob_factory",					text = ReadText(20102, 1001),	width = 0.8 * Helper.sidebarWidth,	height = 0.8 * Helper.sidebarWidth,	color = "friendcolor" },	-- Factory
		-- xl ships
		{ text = ReadText(1001, 6) .. ReadText(1001, 120) .. " " .. ReadText(20111, 5041) },					-- Ships: XL
		{ icon = "ship_xl_fight_01",				text = ReadText(20221, 2011),	color = "friendcolor" },	-- Fighter
		{ icon = "ship_xl_neutral_01",				text = ReadText(20221, 5011),	color = "friendcolor" },	-- Auxiliary
		--{ icon = "ship_xl_mine_01",				text = ReadText(20221, 3041),	color = "friendcolor" },	-- Miner
		{ icon = "ship_xl_build_01",				text = ReadText(20221, 5021),	color = "friendcolor" },	-- Builder
		-- l ships
		{ text = ReadText(1001, 6) .. ReadText(1001, 120) .. " " .. ReadText(20111, 5031) },					-- Ships: L
		{ icon = "ship_l_fight_01",					text = ReadText(20221, 2011),	color = "friendcolor" },	-- Fighter
		{ icon = "ship_l_trade_01",					text = ReadText(20221, 4011),	color = "friendcolor" },	-- Freighter
		{ icon = "ship_l_mine_01",					text = ReadText(20221, 3041),	color = "friendcolor" },	-- Miner
		-- m ships
		{ text = ReadText(1001, 6) .. ReadText(1001, 120) .. " " .. ReadText(20111, 5021) },					-- Ships: M
		{ icon = "ship_m_fight_01",					text = ReadText(20221, 2011),	color = "friendcolor" },	-- Fighter
		{ icon = "ship_m_trade_01",					text = ReadText(20221, 3031),	color = "friendcolor" },	-- Transporter
		{ icon = "ship_m_mine_01",					text = ReadText(20221, 3041),	color = "friendcolor" },	-- Miner
		-- s ships
		{ text = ReadText(1001, 6) .. ReadText(1001, 120) .. " " .. ReadText(20111, 5011) },					-- Ships: S
		{ icon = "ship_s_fight_01",					text = ReadText(20221, 2011),	color = "friendcolor" },	-- Fighter
		{ icon = "ship_s_trade_01",					text = ReadText(20221, 3031),	color = "friendcolor" },	-- Transporter
		{ icon = "ship_s_mine_01",					text = ReadText(20221, 3041),	color = "friendcolor" },	-- Miner
		-- xs ships
		{ text = ReadText(1001, 22) },																			-- Units
		{ icon = "ship_xs_fight_01",				text = ReadText(20101, 100401),	color = "friendcolor" },	-- Defence Drone
		{ icon = "ship_xs_trade_01",				text = ReadText(20101, 100101),	color = "friendcolor" },	-- Cargo Drone
		{ icon = "ship_xs_mine_01",					text = ReadText(20101, 100501),	color = "friendcolor" },	-- Mining Drone
		{ icon = "ship_xs_neutral_01",				text = ReadText(20101, 110201),	color = "friendcolor" },	-- Civilian Ship
		{ icon = "ship_xs_build_01",				text = ReadText(20101, 100301),	color = "friendcolor" },	-- Building Drone
		-- misc
		{ text = ReadText(1001, 2664) },																								-- Misc
		{ icon = "mapob_lasertower_xs",				text = ReadText(20201, 20501),	color = "friendcolor" },							-- Laser Tower Mk1
		{ icon = "mapob_lasertower_s",				text = ReadText(20201, 20601),	color = "friendcolor" },							-- Laser Tower Mk2
		{ icon = "mapob_mine",						text = ReadText(20201, 20201),	color = "friendcolor" },							-- Mine
		{ icon = "solid",							text = ReadText(1001, 1304),	width = 4,	height = 4,	color = "missilecolor" },	-- Missiles
		{ icon = "mapob_satellite_01",				text = ReadText(20201, 20301),	color = "friendcolor" },							-- Satellite
		{ icon = "mapob_satellite_02",				text = ReadText(20201, 20401),	color = "friendcolor" },							-- Advanced Satellite
		{ icon = "mapob_resourceprobe",				text = ReadText(20201, 20701),	color = "friendcolor" },							-- Resource Probe
		{ icon = "mapob_navbeacon",					text = ReadText(20201, 20801),	color = "friendcolor" },							-- Nav Beacon
		{ icon = "mapob_poi",						text = ReadText(1001, 9811),	color = "friendcolor" },							-- Point of Interest
		{ icon = "mapob_unknown",					text = ReadText(20109, 5001) },														-- Unknown Object
		{ icon = "npc_factionrep",					text = ReadText(20208, 10601),	color = "friendcolor" },							-- Faction Representative
		{ icon = "npc_missionactor",				text = ReadText(30260, 1901),	color = "missioncolor" },							-- Person of Interest
		{ icon = "npc_shadyguy",					text = ReadText(20208, 10801),	color = "friendcolor" },							-- Black Marketeer
		{ icon = "missiontype_fight",				text = ReadText(1001, 3291),	color = "missioncolor" },							-- Mission Offers
		{ icon = "mapob_missiontarget",				text = ReadText(1001, 3325),	color = "missioncolor" },							-- Accepted Missions
		-- orders
		{ text = ReadText(1001, 8360) },												-- Behaviours
		{ icon = "order_movegeneric",				text = ReadText(1041, 541) },		-- Fly
		{ icon = "order_wait",						text = ReadText(1041, 101) },		-- Hold Position
		{ icon = "order_waitforsignal",				text = ReadText(1041, 111) },		-- Wait for Signal
		{ icon = "order_dockat",					text = ReadText(1041, 441) },		-- Dock
		{ icon = "order_dockandwait",				text = ReadText(1041, 451) },		-- Dock and Wait
		{ icon = "order_undock",					text = ReadText(1041, 531) },		-- Undock
		{ icon = "order_follow",					text = ReadText(1041, 321) },		-- Follow Ship

		{ icon = "order_attack",					text = ReadText(1041, 431) },		-- Attack
		{ icon = "order_attackinrange",				text = ReadText(1041, 631) },		-- Attack targets in range
		{ icon = "order_patrol",					text = ReadText(1041, 391) },		-- Patrol
		{ icon = "order_protectposition",			text = ReadText(1041, 381) },		-- Protect Position
		{ icon = "order_police",					text = ReadText(1041, 671) },		-- Police
		{ icon = "order_plunder",					text = ReadText(1041, 231) },		-- Plunder
		{ icon = "order_board",						text = ReadText(1041, 421) },		-- Board
		{ icon = "order_escort",					text = ReadText(1041, 411) },		-- Escort Ship
		{ icon = "order_recon",						text = ReadText(1041, 291) },		-- Recon
		{ icon = "order_flee",						text = ReadText(1041, 551) },		-- Flee

		{ icon = "order_findbuildtasks",			text = ReadText(1041, 491) },		-- Find Build Tasks
		{ icon = "order_deploytostation",			text = ReadText(1041, 511) },		-- Deploy to Station

		{ icon = "order_explore",					text = ReadText(1041, 311) },		-- Explore
		{ icon = "order_exploreupdate",				text = ReadText(1041, 301) },		-- Revisit known stations

		{ icon = "order_miningroutine",				text = ReadText(1041, 561) },		-- Mine Resources

		{ icon = "order_tradeperform",				text = ReadText(1041, 171) },		-- Execute Trade
		{ icon = "order_tradeexchange",				text = ReadText(1041, 121) },		-- Ware Exchange
		{ icon = "order_traderoutine",				text = ReadText(1041, 161) },		-- AutoTrade
		{ icon = "order_player_docktotrade",		text = ReadText(1041, 461) },		-- Dock to Trade
		{ icon = "order_disitributewares",			text = ReadText(1041, 181) },		-- Distribute Wares
		{ icon = "order_crewexchange",				text = ReadText(1041, 681) },		-- Transfer Crew

		{ icon = "order_supplyfleet",				text = ReadText(1041, 641) },		-- Supply Fleet
		{ icon = "order_getsupplies",				text = ReadText(1041, 621) },		-- Get Supplies
		{ icon = "order_resupply",					text = ReadText(1041, 191) },		-- Repair and Resupply
		{ icon = "order_restocksubordinates",		text = ReadText(1041, 201) },		-- Restock Subordinates
		{ icon = "order_recallsubordinates",		text = ReadText(1041, 221) },		-- Recall Subordinates
		{ icon = "order_assigncommander",			text = ReadText(1041, 521) },		-- Assign to new Commander
		{ icon = "order_equip",						text = ReadText(1041, 501) },		-- Change Equipment

		{ icon = "order_collect",					text = ReadText(1041, 481) },		-- Collect
		{ icon = "order_collectdropsinradius",		text = ReadText(1041, 571) },		-- Collect Drops
		{ icon = "order_collectlockbox",			text = ReadText(1041, 661) },		-- Collect Lockbox
		{ icon = "order_deployobjectatposition",	text = ReadText(1041, 471) },		-- Deploy Object At Position
		{ icon = "order_depositinventory",			text = ReadText(1041, 651) },		-- Deposit Inventory
	},

	dropInventoryWidth = 500,
	crewTransferWidth = 600,
	renameWidth = 300,
	orderqueueContextWidth = 350,
	tradeLoopWidth = 500,
	venturePatronWidth = 400,

	orderDragSupport = {
	--	order name					position parameter
		["MoveWait"]				= 1,
		["CollectDropsInRadius"]	= 1,
		["DeployObjectAtPosition"]	= 1,
		["AttackInRange"]			= 1,
		["ProtectPosition"]			= 1,
		["MiningCollect"]			= 1,
		["MiningPlayer"]			= 1,
		["Explore"]					= 2,
		["ExploreUpdate"]			= 2,
	},

	assignments = {
		["defence"]					= { name = ReadText(20208, 40301) },
		["attack"]					= { name = ReadText(20208, 40901) },
		["interception"]			= { name = ReadText(20208, 41001) },
		["follow"]					= { name = ReadText(20208, 41301) },
		["supplyfleet"]				= { name = ReadText(20208, 40701) },
		["mining"]					= { name = ReadText(20208, 40201) },
		["trade"]					= { name = ReadText(20208, 40101) },
		["tradeforbuildstorage"]	= { name = ReadText(20208, 40801) },
		["assist"]					= { name = ReadText(20208, 41201) }
	},

	ventures = {
		maxShipRows = 6,
		maxDescRows = 6,
	},

	ventureLogbook = {
		pageSize = 100,
		queryLimit = 1000,
	},

	venturePastSeasons = {
		pageSize = 2,
	},

	infoLogbook = {
		category = "all",
		pageSize = 100,
		queryLimit = 1000,
	},

	ventureSeasons = {
		maxDescRows = 6,
	},
}
