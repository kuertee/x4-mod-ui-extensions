local ffi = require ("ffi")
local C = ffi.C
local utf8 = require("utf8")
local Lib = require ("extensions.sn_mod_support_apis.lua_interface").Library
local interactMenu = Lib.Get_Egosoft_Menu ("InteractMenu")
local menu = interactMenu
local mapMenu = Lib.Get_Egosoft_Menu ("MapMenu")
local oldFuncs = {}
local newFuncs = {}
local callbacks = {}
local isInited
-- just copy the whole config - but ensure that all references to "menu." is correct.
-- add custom menu groups
local config = {
	layer = 2,
	width = 260,
	rowHeight = 16,
	entryFontSize = Helper.standardFontSize,
	entryX = 3,
	mouseOutRange = 100,
	border = 5,
	subsectionDelay = 0.5,

	sections = {
		{ id = "main",					text = "",						isorder = false },
		{ id = "interaction",			text = ReadText(1001, 7865),	isorder = false },
		{ id = "hiringbuilderoption",	text = "",						isorder = false,	subsections = {
			{ id = "hiringbuilder",	text = ReadText(1001, 7873) },
		}},
		-- kuertee start: add custom actions group
		{ id = "custom_actions",	text = ReadText(101475, 100),		isorder = false,	subsections = {
			{ id = "custom_tabs",	text = ReadText(26124, 100) },
			{ id = "ship_built_notifications", text = ReadText(24627, 100) },
		}},
		-- kuertee end: add custom actions group
		{ id = "trade",					text = ReadText(1001, 7104),	isorder = false },
		{ id = "playersquad_orders",	text = ReadText(1001, 1002),	isorder = false },	-- Broadcast
		{ id = "overrideorderoption",	text = ReadText(1001, 11118),	isorder = false,	subsections = {
			{ id = "overrideorder",		text = ReadText(1001, 11248) },
		}},
		{ id = "main_orders",			text = ReadText(1001, 7802),	isorder = false },
		{ id = "formationshapeoption",	text = "",						isorder = false,	subsections = {
			{ id = "formationshape",	text = ReadText(1001, 7862) },
		}},
		{ id = "main_assignments",		text = ReadText(1001, 7803),	isorder = false },
		{ id = "main_assignments_subsections",	text = ReadText(1001, 7805),	isorder = false,	subsections = {
			{ id = "main_assignments_defence",				text = ReadText(20208, 40304) },
			{ id = "main_assignments_positiondefence",		text = ReadText(20208, 41504) },
			{ id = "main_assignments_attack",				text = ReadText(20208, 40904) },
			{ id = "main_assignments_interception",			text = ReadText(20208, 41004) },
			{ id = "main_assignments_bombardment",			text = ReadText(20208, 41604) },
			{ id = "main_assignments_follow",				text = ReadText(20208, 41304) },
			{ id = "main_assignments_supplyfleet",			text = ReadText(20208, 40704) },
			{ id = "main_assignments_mining",				text = ReadText(20208, 40204) },
			{ id = "main_assignments_trade",				text = ReadText(20208, 40104) },
			{ id = "main_assignments_tradeforbuildstorage",	text = ReadText(20208, 40804) },
			{ id = "main_assignments_assist",				text = ReadText(20208, 41204) },
			{ id = "main_assignments_salvage",				text = ReadText(20208, 41404) },
		}},
		{ id = "order",					text = "",						isorder = nil },
		{ id = "syncpoint",				text = "",						isorder = nil },
		{ id = "intersectordefencegroup",	text = "",					isorder = nil },
		{ id = "guidance",				text = "",						isorder = nil,		isplayerinteraction = true },
		{ id = "player_interaction",	text = ReadText(1001, 7843),	isorder = false,	isplayerinteraction = true },
		{ id = "consumables",			text = ReadText(1001, 7846),	isorder = false,	subsections = {
			{ id = "consumables_civilian",	text = ReadText(1001, 7847) },
			{ id = "consumables_military",	text = ReadText(1001, 7848) },
		}},
		{ id = "venturereport",			text = ReadText(1001, 12110),	isorder = false },
		{ id = "cheats",				text = "Cheats",				isorder = false }, -- (cheat only)
		{ id = "selected_orders_all",	text = ReadText(1001, 7804),	isorder = true,		showloop = true },
		{ id = "selected_orders",		text = ReadText(1001, 7804),	isorder = true,		showloop = true },
		{ id = "mining_orders",			text = "",						isorder = true,		showloop = true,		subsections = {
			{ id = "mining",			text = "\27[order_miningplayer] " .. ReadText(1041, 351) },
		}},
		{ id = "venturedockoption",		text = "",						isorder = true,		showloop = true,		subsections = {
			{ id = "venturedock",	text = "\27[order_dockandwait] " .. ReadText(1001, 7844) },
		}},
		{ id = "selected_disable",	text = "",	isorder = true,		subsections = {
			{ id = "selected_disable_attack",		text = ReadText(1001, 11128),	orderid = "Attack" },
		}},
		-- kuertee start: add custom orders group
		{ id = "custom_orders",	text = ReadText(101475, 101),		isorder = true,	showloop = true, subsections = {
			{ id = "custom_tabs",	text = ReadText(26124, 100) },
			{ id = "urgent_orders",	text = ReadText(12115, 1) },
			{ id = "subsystem_targeting_orders", text = ReadText(92015, 1) },
		}},
		-- kuertee end: add custom orders group

		{ id = "trade_orders",			text = ReadText(1001, 7861),	isorder = true,		showloop = true },
		{ id = "selected_assignments_all", text = ReadText(1001, 7886),	isorder = true },
		{ id = "selected_change_assignments",	text = ReadText(1001, 11119),	isorder = true,		subsections = {
			{ id = "selected_change_assignments_defence",				text = ReadText(20208, 40304),	helpOverlayID = "interactmenu_change_assign",	helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "selected_change_assignments_positiondefence",		text = ReadText(20208, 41504) },
			{ id = "selected_change_assignments_attack",				text = ReadText(20208, 40904) },
			{ id = "selected_change_assignments_interception",			text = ReadText(20208, 41004) },
			{ id = "selected_change_assignments_bombardment",			text = ReadText(20208, 41604) },
			{ id = "selected_change_assignments_follow",				text = ReadText(20208, 41304) },
			{ id = "selected_change_assignments_supplyfleet",			text = ReadText(20208, 40704) },
			{ id = "selected_change_assignments_mining",				text = ReadText(20208, 40204) },
			{ id = "selected_change_assignments_trade",					text = ReadText(20208, 40104) },
			{ id = "selected_change_assignments_tradeforbuildstorage",	text = ReadText(20208, 40804) },
			{ id = "selected_change_assignments_assist",				text = ReadText(20208, 41204) },
			{ id = "selected_change_assignments_salvage",				text = ReadText(20208, 41404) },
		}},
		{ id = "selected_assignments",	text = ReadText(1001, 7805),	isorder = true,		subsections = {
			{ id = "selected_assignments_defence",				text = ReadText(20208, 40304),	helpOverlayID = "interactmenu_assign",	helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "selected_assignments_positiondefence",		text = ReadText(20208, 41504) },
			{ id = "selected_assignments_attack",				text = ReadText(20208, 40904) },
			{ id = "selected_assignments_interception",			text = ReadText(20208, 41004) },
			{ id = "selected_assignments_bombardment",			text = ReadText(20208, 41604) },
			{ id = "selected_assignments_follow",				text = ReadText(20208, 41304) },
			{ id = "selected_assignments_supplyfleet",			text = ReadText(20208, 40704) },
			{ id = "selected_assignments_mining",				text = ReadText(20208, 40204) },
			{ id = "selected_assignments_trade",				text = ReadText(20208, 40104) },
			{ id = "selected_assignments_tradeforbuildstorage",	text = ReadText(20208, 40804) },
			{ id = "selected_assignments_assist",				text = ReadText(20208, 41204) },
			{ id = "selected_assignments_salvage",				text = ReadText(20208, 41404) },
		}},
		{ id = "selected_consumables",	text = ReadText(1001, 7849),	isorder = true,		subsections = {
			{ id = "selected_consumables_civilian",	text = "\27[order_deployobjectatposition] " .. ReadText(1001, 7847) },
			{ id = "selected_consumables_military",	text = "\27[order_deployobjectatposition] " .. ReadText(1001, 7848) },
		}},
		{ id = "shipconsole",			text = "",						isorder = false },
	},

	assignments = {
		["defence"]					= { name = ReadText(20208, 40304) },
		["positiondefence"]			= { name = ReadText(20208, 41504) },
		["attack"]					= { name = ReadText(20208, 40904) },
		["interception"]			= { name = ReadText(20208, 41004) },
		["bombardment"]				= { name = ReadText(20208, 41604) },
		["follow"]					= { name = ReadText(20208, 41304) },
		["supplyfleet"]				= { name = ReadText(20208, 40704) },
		["mining"]					= { name = ReadText(20208, 40204) },
		["trade"]					= { name = ReadText(20208, 40104) },
		["tradeforbuildstorage"]	= { name = ReadText(20208, 40804) },
		["assist"]					= { name = ReadText(20208, 41204) },
		["salvage"]					= { name = ReadText(20208, 41401) },
	},
}
local function init ()
	-- DebugError ("kuertee_menu_interactmenu.init")
	if not isInited then
		isInited = true
		interactMenu.registerCallback = newFuncs.registerCallback
		-- rewrites: interact menu
		oldFuncs.createContentTable = interactMenu.createContentTable
		interactMenu.createContentTable = newFuncs.createContentTable
		oldFuncs.prepareSections = interactMenu.prepareSections
		interactMenu.prepareSections = newFuncs.prepareSections
		-- rewrites: map menu
		oldFuncs.onRenderTargetMouseDown = mapMenu.onRenderTargetMouseDown
		mapMenu.onRenderTargetMouseDown = newFuncs.onRenderTargetMouseDown
		RegisterEvent ("Interact_Menu_API.Add_Custom_Actions_Group_Id", newFuncs.Add_Custom_Actions_Group_Id)
		RegisterEvent ("Interact_Menu_API.Add_Custom_Actions_Group_Text", newFuncs.Add_Custom_Actions_Group_Text)
	end
end
function newFuncs.registerCallback (callbackName, callbackFunction)
	-- note 1: format is generally [function name]_[action]. e.g.: in kuertee_menu_transporter, "display_on_set_room_active" overrides the room's active property with the return of the callback.
	-- note 2: events have the word "_on_" followed by a PRESENT TENSE verb. e.g.: in kuertee_menu_transporter, "display_on_set_buttontable" is called after all of the rows of buttontable are set.
	-- note 3: new callbacks can be added or existing callbacks can be edited. but commit your additions/changes to the mod's GIT repository.
	-- note 4: search for the callback names to see where they are executed.
	-- note 5: if a callback requires a return value, return it in an object var. e.g. "display_on_set_room_active" requires a return of {active = true | false}.
	-- available callbacks:
	-- none yet
	--
	if callbacks [callbackName] == nil then
		callbacks [callbackName] = {}
	end
	table.insert (callbacks [callbackName], callbackFunction)
end
function newFuncs.prepareSections()
	local menu = interactMenu
	menu.actions = {}
	for _, section in ipairs(config.sections) do
		if section.subsections then
			-- kuertee start: add section initializer
			menu.actions[section.id] = {}
			-- kuertee end: add section initializer
			for _, subsection in ipairs(section.subsections) do
				menu.actions[subsection.id] = {}
			end
		else
			menu.actions[section.id] = {}
		end
	end
end

function newFuncs.debugText (data1, data2, indent, isForced)
	local isDebug = false
	if isDebug == true or isForced == true then
		if indent == nil then
			indent = ""
		end
		if type (data1) == "table" then
			for i, value in pairs (data1) do
				DebugError (indent .. tostring (i) .. ": " .. tostring (value))
				if type (value) == "table" then
					newFuncs.debugText (value, nil, indent .. "    ", isForced)
				end
			end
		else
			DebugError (indent .. tostring (data1))
		end
		if data2 then
			newFuncs.debugText (data2, nil, indent .. "    ", isForced)
		end
	end
end
function newFuncs.debugText_forced (data1, data2, indent)
	return newFuncs.debugText (data1, data2, indent, true)
end
newFuncs.kuertee_sector_freeDistFrom = nil
newFuncs.kuertee_offset_freeDistFrom = nil
function newFuncs.onRenderTargetMouseDown (modified)
	local menu = mapMenu
	oldFuncs.onRenderTargetMouseDown (modified)
	newFuncs.kuertee_offset_freeDistFrom = ffi.new ("UIPosRot")
	local eclipticoffset = ffi.new ("UIPosRot")
	newFuncs.kuertee_sector_freeDistFrom = C.GetMapPositionOnEcliptic2 (menu.holomap, newFuncs.kuertee_offset_freeDistFrom, false, 0, eclipticoffset)
end
function newFuncs.createContentTable(frame, position)
	local menu = interactMenu
	local x = 0
	if position == "right" then
		x = menu.width + Helper.borderSize
	end

	local ftable = frame:addTable(5, { tabOrder = menu.subsection and 2 or 1, x = x, width = menu.width, backgroundID = "solid", backgroundColor = Helper.color.semitransparent, highlightMode = "off" })
	ftable:setDefaultCellProperties("text",   { minRowHeight = config.rowHeight, fontsize = config.entryFontSize, x = config.entryX })
	ftable:setDefaultCellProperties("button", { height = config.rowHeight })
	ftable:setDefaultCellProperties("checkbox", { height = config.rowHeight, width = config.rowHeight })
	ftable:setDefaultComplexCellProperties("button", "text", { fontsize = config.entryFontSize, x = config.entryX })
	ftable:setDefaultComplexCellProperties("button", "text2", { fontsize = config.entryFontSize, x = config.entryX })

	local text = menu.texts.targetShortName
	local color = menu.colors.target
	if menu.construction then
		text = menu.texts.constructionName
	end

	local modetext = ReadText(1001, 7804)
	if (not menu.syncpoint) and (not menu.syncpointorder) and (not menu.intersectordefencegroup) and (not menu.mission) and (not menu.missionoffer) then
		if (not menu.showPlayerInteractions) and (#menu.selectedplayerships > 0) then
			if #menu.actions["selected_orders_all"] > 0 then
				modetext = ReadText(1001, 7804)
				text = menu.texts.selectedNameAll
			elseif #menu.actions["selected_orders"] > 0 then
				modetext = ReadText(1001, 7804)
				text = menu.texts.selectedName
			elseif #menu.actions["trade_orders"] > 0 then
				modetext = ReadText(1001, 7861)
				text = menu.texts.selectedName
			elseif #menu.actions["selected_assignments_all"] > 0 then
				modetext = ReadText(1001, 7886)
				text = menu.texts.selectedNameAll
			else
				-- fallback if no section is used (aka no interaction possible)
				text = menu.texts.selectedName
			end
			if menu.numorderloops > 0 then
				modetext = utf8.char(8734) .. " " .. modetext
			end
			color = menu.colors.selected
		elseif (#menu.selectedplayerships == 0) and (#menu.selectedotherobjects > 0) then
			modetext = ReadText(1001, 7804)
			text = menu.texts.otherName
			color = menu.colors.selected
		elseif (#menu.ventureships > 0) and (#menu.selectedplayerships == 0) then
			text = menu.texts.ventureName
			color = menu.colors.venture
		end
	end
	if text == nil then
		DebugError("Interact title text is nil [Florian]" ..
				"\n   targetShortName: " ..tostring(menu.texts.targetShortName) ..
				"\n   construction: " .. tostring(menu.construction) ..
				"\n   constructionName: " .. tostring(menu.texts.constructionName) ..
				"\n   selectedNameAll: " .. tostring(menu.texts.selectedNameAll) ..
				"\n   selectedName: " .. tostring(menu.texts.selectedName) ..
				"\n   otherName: " .. tostring(menu.texts.otherName) ..
				"\n   ventureName: " .. tostring(menu.texts.ventureName) ..
				"\n   #menu.selectedplayerships: " .. tostring(#menu.selectedplayerships) ..
				"\n   #menu.selectedotherobjects: " .. tostring(#menu.selectedotherobjects) ..
				"\n   #menu.ventureships: " .. tostring(#menu.ventureships) ..
				"\n   showPlayerInteractions: " .. tostring(menu.showPlayerInteractions) ..
				"\n   syncpoint: " .. tostring(menu.syncpoint) ..
				"\n   syncpointorder: " .. tostring(menu.syncpointorder) ..
				"\n   intersectordefencegroup: " .. tostring(menu.intersectordefencegroup) ..
				"\n   mission: " .. tostring(menu.mission) ..
				"\n   missionoffer: " .. tostring(menu.missionoffer) ..
				"\n   #menu.actions['selected_orders_all']: " .. tostring(#menu.actions["selected_orders_all"]) ..
				"\n   #menu.actions['selected_orders']: " .. tostring(#menu.actions["selected_orders"]) ..
				"\n   #menu.actions['trade_orders']: " .. tostring(#menu.actions["trade_orders"]) ..
				"\n   #menu.actions['selected_assignments_all']: " .. tostring(#menu.actions["selected_assignments_all"])
		)
		text = ""
	end

	-- need a min width here, otherwise column 3 gets a negative width if the mode text would fit into column 2
	local modetextwidth = math.ceil(math.max(0.2 * menu.width + 2 * Helper.borderSize, C.GetTextWidth(" " .. modetext .. " ", Helper.standardFontBold, Helper.scaleFont(Helper.standardFont, Helper.headerRow1FontSize, true))))
	local bordericonsize = Helper.scaleX(Helper.headerRow1Height)
	local borderwidth = math.ceil(math.max(bordericonsize, (menu.width - modetextwidth - 2 * Helper.borderSize) / 2))
	borderwidth = math.max(borderwidth, Helper.scaleX(config.rowHeight) + Helper.borderSize + 1)

	ftable:setColWidth(1, config.rowHeight)
	ftable:setColWidth(2, borderwidth - Helper.scaleX(config.rowHeight) - Helper.borderSize, false)
	ftable:setColWidth(4, math.ceil(0.4 * menu.width - borderwidth - Helper.borderSize), false)
	ftable:setColWidth(5, borderwidth, false)
	ftable:setDefaultBackgroundColSpan(1, 4)
	ftable:setDefaultColSpan(1, 3)
	ftable:setDefaultColSpan(4, 2)

	local height = 0
	if (((not menu.showPlayerInteractions) and (#menu.selectedplayerships > 0)) or ((#menu.selectedplayerships == 0) and (#menu.selectedotherobjects > 0))) and (not menu.syncpoint) and (not menu.syncpointorder) and (not menu.intersectordefencegroup) and (not menu.mission) and (not menu.missionoffer) then
		-- modemarker
		local row = ftable:addRow(false, { bgColor = Helper.color.transparent })
		row[1]:setBackgroundColSpan(5):setColSpan(2):createIcon("be_diagonal_01", { width = bordericonsize, height = bordericonsize, x = borderwidth - bordericonsize + Helper.borderSize, scaling = false, color = Helper.defaultTitleTrapezoidBackgroundColor })
		row[4]:setColSpan(1)
		row[3]:setColSpan(2)
		local width = row[3]:getColSpanWidth() + Helper.scrollbarWidth + Helper.borderSize
		row[3]:createIcon("solid", { height = bordericonsize, width = width, scaling = false, color = Helper.defaultTitleTrapezoidBackgroundColor }):setText(modetext, { font = Helper.headerRow1Font, fontsize = Helper.scaleFont(Helper.headerRow1Font, Helper.headerRow1FontSize, true), halign = "center", x = math.ceil((width- Helper.borderSize) / 2) })
		row[5]:setColSpan(1):createIcon("be_diagonal_02", { width = bordericonsize, height = bordericonsize, scaling = false, color = Helper.defaultTitleTrapezoidBackgroundColor })
		height = height + row:getHeight() + Helper.borderSize
	end
	-- title
	local row = ftable:addRow(false, { bgColor = Helper.color.transparent })
	text = TruncateText(text, Helper.standardFontBold, Helper.scaleFont(Helper.standardFontBold, Helper.headerRow1FontSize), menu.width - Helper.scaleX(Helper.standardButtonWidth) - 2 * config.entryX)
	row[1]:setColSpan(5):createText(text, Helper.headerRowCenteredProperties)
	row[1].properties.color = color
	height = height + row:getHeight() + Helper.borderSize
	if (menu.subordinategroup or menu.intersectordefencegroup) and (#menu.selectedplayerships == 0) then
		row[1].properties.titleColor = nil
		local row = ftable:addRow(nil, { bgColor = Helper.color.transparent })
		row[1]:setColSpan(5):createText(string.format(ReadText(1001, 8398), ReadText(20401, menu.subordinategroup or menu.intersectordefencegroup)), Helper.headerRowCenteredProperties)
		row[1].properties.color = color
	end

	-- kuertee start: add distance
	if mapMenu and mapMenu.holomap then
		local kuertee_component_distFrom
		local kuertee_isFreeDistFrom
		if #menu.selectedplayerships > 0 then
			newFuncs.debugText ("#menu.selectedplayerships: " .. tostring (#menu.selectedplayerships))
			kuertee_component_distFrom = menu.selectedplayerships [1]
		elseif #menu.selectedotherobjects > 0 then
			newFuncs.debugText ("#menu.selectedotherobjects: " .. tostring (#menu.selectedotherobjects))
			kuertee_component_distFrom = menu.selectedotherobjects [1]
		elseif #menu.selectedplayerdeployables > 0 then
			newFuncs.debugText ("#menu.selectedplayerdeployables: " .. tostring (#menu.selectedplayerdeployables))
			kuertee_component_distFrom = menu.selectedplayerdeployables [1]
		else
			local kuertee_selectedComponents = {}
			Helper.ffiVLA (kuertee_selectedComponents, "UniverseID", C.GetNumMapSelectedComponents, C.GetMapSelectedComponents, mapMenu.holomap)
			if #kuertee_selectedComponents > 0 then
				newFuncs.debugText ("#kuertee_selectedComponents: " .. tostring (#kuertee_selectedComponents))
				kuertee_component_distFrom = kuertee_selectedComponents [1]
			elseif newFuncs.kuertee_sector_freeDistFrom and newFuncs.kuertee_offset_freeDistFrom then
				newFuncs.debugText ("kuertee_sector_freeDistFrom: " .. tostring (newFuncs.kuertee_sector_freeDistFrom))
				newFuncs.debugText ("kuertee_offset_freeDistFrom: " .. tostring (newFuncs.kuertee_offset_freeDistFrom))
				kuertee_isFreeDistFrom = true
				kuertee_component_distFrom = newFuncs.kuertee_sector_freeDistFrom
			end
		end
		newFuncs.debugText ("kuertee_component_distFrom: " .. tostring (kuertee_component_distFrom))
		if kuertee_component_distFrom then
			local kuertee_component_distTo
			if menu.componentSlot.component then
				newFuncs.debugText ("menu.componentSlot.component: " .. tostring (menu.componentSlot.component))
				kuertee_component_distTo = ConvertStringTo64Bit (tostring (menu.componentSlot.component))
				if kuertee_component_distTo then
					kuertee_component_distTo = ConvertStringTo64Bit (tostring (kuertee_component_distTo))
					newFuncs.debugText ("kuertee_component_distTo: " .. tostring (kuertee_component_distTo))
					local kuertee_dist
					local kuertee_isSector_distTo = C.IsComponentClass (kuertee_component_distTo, "sector")
					local kuertee_dist_isApprox = false
					if kuertee_isSector_distTo then
						local kuertee_sector_check
						newFuncs.debugText ("kuertee_isFreeDistFrom: " .. tostring (kuertee_isFreeDistFrom))
						if kuertee_isFreeDistFrom == true then
							kuertee_sector_check = ConvertStringTo64Bit (tostring (kuertee_component_distFrom))
						else
							kuertee_sector_check = GetComponentData (ConvertStringTo64Bit (tostring (kuertee_component_distFrom)), "sectorid")
							kuertee_sector_check = ConvertStringTo64Bit (tostring (kuertee_sector_check))
						end
						newFuncs.debugText ("kuertee_sector_check: " .. tostring (kuertee_sector_check))
						-- local isSameSector = kuertee_sector_check == kuertee_component_distTo or kuertee_isFreeDistFrom ~= true
						local isSameSector = kuertee_sector_check == kuertee_component_distTo
						if isSameSector then
							newFuncs.debugText ("kuertee_isSector_distTo: " .. tostring (kuertee_isSector_distTo))
							local kuertee_posFrom
							if kuertee_isFreeDistFrom then
								kuertee_posFrom = newFuncs.kuertee_offset_freeDistFrom
							else
								kuertee_posFrom = ffi.new ("UIPosRot")
								kuertee_posFrom = C.GetObjectPositionInSector (kuertee_component_distFrom)
							end
							newFuncs.debugText ("kuertee_posFrom: " .. tostring (kuertee_posFrom.x) .. " " .. tostring (kuertee_posFrom.y) .. " " .. tostring (kuertee_posFrom.z))
							newFuncs.debugText ("menu.offset: " .. tostring (menu.offset.x) .. " " .. tostring (menu.offset.y) .. " " .. tostring (menu.offset.z))
							-- https://www.engineeringtoolbox.com/distance-relationship-between-two-points-d_1854.html
							-- d = ((x2 - x1)2 + (y2 - y1)2 + (z2 - z1)2)1/2
							local x_delta = math.abs (kuertee_posFrom.x - menu.offset.x)
							local y_delta = math.abs (kuertee_posFrom.y - menu.offset.y)
							local z_delta = math.abs (kuertee_posFrom.z - menu.offset.z)
							newFuncs.debugText ("deltas: " .. tostring (x_delta) .. " " .. tostring (y_delta) .. " " .. tostring (z_delta))
							kuertee_dist = math.pow (math.pow (x_delta, 2) + math.pow (y_delta, 2) + math.pow (z_delta, 2), 0.5)
						else
							kuertee_dist_isApprox = true
							local kuertee_posFrom
							if kuertee_isFreeDistFrom then
								-- free distance from sector to sector = distance of point to current sector + distance between the two sectors
								-- kuertee_posFrom = newFuncs.kuertee_offset_freeDistFrom
								-- local x_delta = math.abs (kuertee_posFrom.x - menu.offset.x)
								-- local y_delta = math.abs (kuertee_posFrom.y - menu.offset.y)
								-- local z_delta = math.abs (kuertee_posFrom.z - menu.offset.z)
								-- kuertee_dist = math.pow (math.pow (x_delta, 2) + math.pow (y_delta, 2) + math.pow (z_delta, 2), 0.5)
								-- kuertee_dist = kuertee_dist + C.GetDistanceBetween (kuertee_sector_check, kuertee_component_distTo)
								kuertee_dist = 0
							else
								kuertee_posFrom = ffi.new ("UIPosRot")
								kuertee_posFrom = C.GetObjectPositionInSector (kuertee_component_distFrom)
								kuertee_dist = C.GetDistanceBetween (kuertee_component_distFrom, kuertee_component_distTo)
							end
						end
					else
						kuertee_dist = C.GetDistanceBetween (kuertee_component_distFrom, kuertee_component_distTo)
					end
					if kuertee_dist and kuertee_dist > 0 then
						newFuncs.debugText ("kuertee_dist: " .. tostring (kuertee_dist))
						kuertee_dist = kuertee_dist / 1000.0
						kuertee_dist = math.floor (kuertee_dist * 100 + 0.5) / 100
						row = ftable:addRow (false, {bgColor = Helper.color.transparent})
						if kuertee_dist_isApprox then
							kuertee_dist = "+/- " .. tostring(kuertee_dist)
						end
						local kuertee_text = ReadText (1001, 2957) .. ReadText (1001, 120) .. " " .. tostring (kuertee_dist) .. " " .. ReadText (1001, 108) -- Distance colon space X space km
						row [1]:setColSpan (5):createText (kuertee_text, {halign = "center"})
					end
				end
			end
		end
	end
	-- kuertee end: add distance

	-- entries
	local convertedComponent = ConvertStringTo64Bit(tostring(menu.componentSlot.component))
	local isonlinetarget, isplayerownedtarget
	if convertedComponent ~= 0 then
		isonlinetarget, isplayerownedtarget = GetComponentData(convertedComponent, "isonlineobject", "isplayerowned")
	end

	local skipped = false
	if (not menu.syncpoint) and (not menu.syncpointorder) and (not menu.intersectordefencegroup) and (not menu.mission) and (not menu.missionoffer) then
		if (#menu.selectedplayerships == 0) and (#menu.selectedotherobjects > 0) then
			-- show the player that they cannot do anything with their selection
			menu.noopreason = {}
			for _, selectedcomponent in ipairs(menu.selectedotherobjects) do
				if C.IsRealComponentClass(selectedcomponent, "ship") then
					local selected64 = ConvertStringTo64Bit(tostring(selectedcomponent))
					if GetComponentData(selected64, "isplayerowned") then
						if IsComponentConstruction(selected64) then
							-- player ship in construction
							menu.noopreason[1] = ReadText(1001, 11106)
						end
					else
						-- npc ship
						menu.noopreason[2] = ReadText(1001, 7852)
					end
				else
					-- station case
					menu.noopreason[3] = ReadText(1001, 11104)
				end
			end
			local reason = ""
			if menu.noopreason[1] then
				reason = menu.noopreason[1]
			end
			if menu.noopreason[2] then
				if reason ~= "" then
					reason = reason .. "\n"
				end
				reason = reason .. menu.noopreason[2]
			elseif menu.noopreason[3] then
				if reason ~= "" then
					reason = reason .. "\n"
				end
				reason = reason .. menu.noopreason[3]
			end

			local row = ftable:addRow(true, { bgColor = Helper.color.darkgrey })
			row[1]:setColSpan(5):createText(reason, { wordwrap = true, color = Helper.color.grey })
			skipped = true
		elseif isonlinetarget and isplayerownedtarget then
			local row = ftable:addRow(true, { fixed = true, bgColor = Helper.color.darkgrey })
			row[1]:setColSpan(5):createText(ReadText(1001, 7868), { wordwrap = true, color = Helper.color.grey })
			skipped = true
		elseif (#menu.ventureships > 0) and (#menu.selectedplayerships == 0) then
			local row = ftable:addRow(true, { fixed = true, bgColor = Helper.color.darkgrey })
			row[1]:setColSpan(5):createText(ReadText(1001, 7868), { wordwrap = true, color = Helper.color.grey })
			skipped = true
		elseif (menu.numorderloops > 0) and (#menu.selectedplayerships ~= menu.numorderloops) then
			local row = ftable:addRow(true, { fixed = true, bgColor = Helper.color.darkgrey })
			row[1]:setColSpan(5):createText(ReadText(1001, 11108), { wordwrap = true, color = Helper.color.grey })
			skipped = true
		elseif (menu.numorderloops > 1) then
			local row = ftable:addRow(true, { fixed = true, bgColor = Helper.color.darkgrey })
			row[1]:setColSpan(5):createText(ReadText(1001, 11109), { wordwrap = true, color = Helper.color.grey })
			skipped = true
		end
	end
	if not skipped then
		local first = true
		for _, section in ipairs(config.sections) do
			local pass = false
			if menu.showPlayerInteractions then
				if section.isplayerinteraction or (menu.shown and (not section.isorder)) then
					pass = true
				end
			elseif (section.isorder == nil) or (section.isorder == (#menu.selectedplayerships > 0)) then
				pass = true
			end

			if pass then
				if section.subsections then
					local hastitle = false
					for _, subsection in ipairs(section.subsections) do
						if (#menu.actions[subsection.id] > 0) or menu.forceSubSection[subsection.id] then
							if not hastitle then
								height = height + menu.addSectionTitle(ftable, section, first)
								first = false
								hastitle = true
							end
							local data = { id = subsection.id, y = height }
							local row = ftable:addRow(data, { bgColor = Helper.color.transparent })
							local iconHeight = Helper.scaleY(config.rowHeight)
							local button = row[1]:setColSpan(5):createButton({
								bgColor = #menu.actions[subsection.id] > 0 and Helper.color.transparent or Helper.color.darkgrey,
								highlightColor = #menu.actions[subsection.id] > 0 and Helper.defaultButtonHighlightColor or Helper.defaultUnselectableButtonHighlightColor,
								mouseOverText = (#menu.actions[subsection.id] > 0) and "" or menu.forceSubSection[subsection.id],
								helpOverlayID = subsection.helpOverlayID,
								helpOverlayText = subsection.helpOverlayText,
								helpOverlayHighlightOnly = subsection.helpOverlayHighlightOnly,
							}):setText((subsection.orderid and menu.orderIconText(subsection.orderid) or "") .. subsection.text, { color = Helper.color.white }):setIcon("table_arrow_inv_right", { scaling = false, width = iconHeight, height = iconHeight, x = menu.width - iconHeight })
							row[1].handlers.onClick = function () return menu.handleSubSectionOption(data, true) end
							height = height + row:getHeight() + Helper.borderSize
						end
					end
				elseif #menu.actions[section.id] > 0 then
					height = height + menu.addSectionTitle(ftable, section, first)
					first = false
					local availabletextwidth
					if (section.id == "main") or (section.id == "selected_orders") or (section.id == "trade_orders") or (section.id == "selected_assignments") or (section.id == "player_interaction") or (section.id == "trade") then
						local maxtextwidth = 0
						for _, entry in ipairs(menu.actions[section.id]) do
							if not entry.hidetarget then
								maxtextwidth = math.max(maxtextwidth, C.GetTextWidth(entry.text .. " ", Helper.standardFont, Helper.scaleFont(Helper.standardFont, config.entryFontSize, true)))
							end
						end
						availabletextwidth = menu.width - maxtextwidth - 2 * Helper.scaleX(config.entryX) - Helper.borderSize
					end

					for _, entry in ipairs(menu.actions[section.id]) do
						if entry.active == nil then
							entry.active = true
						end
						local row = ftable:addRow(true, { bgColor = Helper.color.transparent })
						if entry.checkbox ~= nil then
							row[1]:setColSpan(1):createCheckBox(entry.checkbox, { active = entry.active, mouseOverText = entry.mouseOverText })
							row[1].properties.uiTriggerID = entry.type
							row[2]:setColSpan(4):createText(entry.text, {
								color = entry.active and Helper.color.white or Helper.color.lightgrey,
								mouseOverText = entry.mouseOverText,
								helpOverlayID = entry.helpOverlayID,
								helpOverlayText = entry.helpOverlayText,
								helpOverlayHighlightOnly = entry.helpOverlayHighlightOnly,
							})
						else
							local button = row[1]:setColSpan(5):createButton({
								bgColor = entry.active and Helper.color.transparent or Helper.color.darkgrey,
								highlightColor = entry.active and Helper.defaultButtonHighlightColor or Helper.defaultUnselectableButtonHighlightColor,
								mouseOverText = entry.mouseOverText,
								helpOverlayID = entry.helpOverlayID,
								helpOverlayText = entry.helpOverlayText,
								helpOverlayHighlightOnly = entry.helpOverlayHighlightOnly,
							}):setText(entry.text, { color = entry.active and Helper.color.white or Helper.color.lightgrey })
							button.properties.uiTriggerID = entry.type
							if (section.id == "selected_orders") or (section.id == "trade_orders") or (section.id == "selected_assignments") or (section.id == "player_interaction") or (section.id == "trade") then
								if not entry.hidetarget then
									local text2 = ""
									if entry.text2 then
										text2 = entry.text2
									else
										if ((section.id == "trade_orders") or (section.id == "trade") or (section.id == "player_interaction")) and entry.buildstorage then
											text2 = menu.texts.buildstorageName
										else
											text2 = menu.texts.targetBaseName or menu.texts.targetShortName
										end
									end
									text2 = TruncateText(text2, button.properties.text.font, Helper.scaleFont(button.properties.text.font, button.properties.text.fontsize, button.properties.scaling), availabletextwidth)
									button:setText2(text2, { halign = "right", color = menu.colors.target })
									if (entry.mouseOverText == nil) or (entry.mouseOverText == "") then
										button.properties.mouseOverText = entry.text .. " " .. (entry.buildstorage and menu.texts.buildstorageFullName or menu.texts.targetName)
									end
								end
							elseif (section.id == "main") then
								if entry.text2 then
									local text2 = entry.text2
									text2 = TruncateText(text2, button.properties.text.font, Helper.scaleFont(button.properties.text.font, button.properties.text.fontsize, button.properties.scaling), availabletextwidth)
									button:setText2(text2, { halign = "right", color = menu.colors.target })
								end
							end
						end
						if entry.active then
							row[1].handlers.onClick = entry.script
						end
						height = height + row:getHeight() + Helper.borderSize
					end
				end
			end
		end

		if first then
			local row = ftable:addRow(true, { bgColor = Helper.color.transparent })
			local button = row[1]:setColSpan(5):createButton({ active = false, bgColor = Helper.color.darkgrey }):setText("---", { halign = "center", color = Helper.color.red })
		end
	end

	ftable:setSelectedRow(menu.selectedRows.contentTable)
	ftable:setTopRow(menu.topRows.contentTable)
	menu.selectedRows.contentTable = nil
	menu.topRows.contentTable = nil

	return ftable
end

local newCustomGroupId
local newCustomGroupText
function newFuncs.Add_Custom_Actions_Group_Id(_, id)
	newCustomGroupId = id
	if newCustomGroupId and newCustomGroupText then
		newFuncs.Add_Custom_Actions_Group(newCustomGroupId, newCustomGroupText)
		newCustomGroupId = nil
		newCustomGroupText = nil
	end
end
function newFuncs.Add_Custom_Actions_Group_Text(_, text)
	newCustomGroupText = text
	if newCustomGroupId and newCustomGroupText then
		newFuncs.Add_Custom_Actions_Group(newCustomGroupId, newCustomGroupText)
		newCustomGroupId = nil
		newCustomGroupText = nil
	end
end
function newFuncs.Add_Custom_Actions_Group(id, text)
	local customActionsSection
	local isFound = false
	newFuncs.debugText("Add_Custom_Actions_Group id: " .. tostring(id) .. " text: " .. tostring(text))
	for _, section in ipairs(config.sections) do
		if section.id == "custom_actions" then
			customActionsSection = section
			for _, subsection in ipairs(section.subsections) do
				if subsection.id == id then
					isFound = true
				end
			end
		end
	end
	if customActionsSection and (not isFound) then
		local subsection = 
		table.insert (customActionsSection.subsections, {id = id, text = text})
		newFuncs.debugText("Add_Custom_Actions_Group customActionsSection.subsections", customActionsSection.subsections)
	end
end
init ()
