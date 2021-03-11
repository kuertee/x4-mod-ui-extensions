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
				callback = function (...) return mapMenu.filterMiningResources(...) end,
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

	contextBorder = 5
}
