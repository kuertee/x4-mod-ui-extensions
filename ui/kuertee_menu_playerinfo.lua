local ffi = require ("ffi")
local C = ffi.C
local Lib = require ("extensions.sn_mod_support_apis.lua_interface").Library
local playerInfoMenu = Lib.Get_Egosoft_Menu ("PlayerInfoMenu")
local menu = playerInfoMenu
local oldFuncs = {}
local newFuncs = {}
local callbacks = {}
local isInited
local function init ()
	-- DebugError ("kuertee_menu_playerinfo.init")
	if not isInited then
		isInited = true
		playerInfoMenu.registerCallback = newFuncs.registerCallback
		-- map menu rewrites:
		oldFuncs.buttonTogglePlayerInfo = playerInfoMenu.buttonTogglePlayerInfo
		playerInfoMenu.buttonTogglePlayerInfo = newFuncs.buttonTogglePlayerInfo
		oldFuncs.createPlayerInfo = playerInfoMenu.createPlayerInfo
		playerInfoMenu.createPlayerInfo = newFuncs.createPlayerInfo
		oldFuncs.createInfoFrame = playerInfoMenu.createInfoFrame
		playerInfoMenu.createInfoFrame = newFuncs.createInfoFrame
		oldFuncs.createFactions = playerInfoMenu.createFactions
		playerInfoMenu.createFactions = newFuncs.createFactions
		oldFuncs.onRowChanged = playerInfoMenu.onRowChanged
		playerInfoMenu.onRowChanged = newFuncs.onRowChanged
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
	-- buttonTogglePlayerInfo_on_start (mode, config)
	-- createPlayerInfo_on_start (config)
	-- createInfoFrame_on_start ()
	-- createInfoFrame_on_info_frame_mode (infoFrame, tableProperties)
	-- createFactions_on_before_render_licences (frame, tableProperties, relation.id, infotable)
	-- createFactions_on_after_declare_war_button(frame, tableProperties, relation.id, infotable)
	-- createAccounts_add_new_table (frame, tableProperties, tabOrderOffset)
	-- createAccounts_add_new_table (frame, tableProperties, tabOrderOffset)
	-- onRowChanged (row, rowdata, uitable, modified, input)
	if callbacks [callbackName] == nil then
		callbacks [callbackName] = {}
	end
	table.insert (callbacks [callbackName], callbackFunction)
end
-- just copy the whole config - but ensure that all references to "menu." is correct.
local config = {
	mode = "empire",
	mainLayer = 5,
	infoLayer = 4,
	contextLayer = 2,
	rowHeight = 17,
	leftBar = {
		{ name = ReadText(1001, 7717),		icon = "pi_empire",					mode = "empire",			active = true, helpOverlayID = "playerinfo_sidebar_empire",			helpOverlayText = ReadText(1028, 7701) },
		{ name = ReadText(1001, 7703),		icon = "pi_diplomacy",				mode = "factions",			active = true, helpOverlayID = "playerinfo_sidebar_factions",		helpOverlayText = ReadText(1028, 7715) },
		{ name = ReadText(1001, 2500),		icon = "pi_statistics",				mode = "stats",				active = true, helpOverlayID = "playerinfo_sidebar_stats",			helpOverlayText = ReadText(1028, 7717) },
		{ spacing = true },
		{ name = ReadText(1001, 2202),		icon = "pi_inventory",				mode = "inventory",			active = true, helpOverlayID = "playerinfo_sidebar_inventory",		helpOverlayText = ReadText(1028, 7703) },
		--{ name = ReadText(1001, 7701),		icon = "pi_crafting",				mode = "crafting",			active = true },
		{ name = ReadText(1001, 8031),		icon = "pi_equipmentmods",			mode = "equipmentmods",		active = true, helpOverlayID = "playerinfo_sidebar_equipmentmods",	helpOverlayText = ReadText(1028, 7705) },
		{ name = ReadText(1001, 7716),		icon = "pi_spacesuit",				mode = "spacesuit",			active = true, helpOverlayID = "playerinfo_sidebar_spacesuit",		helpOverlayText = ReadText(1028, 7707) },
		{ spacing = true },
		{ name = ReadText(1001, 9171),		icon = "mapst_ao_default_global",	mode = "globalorders",		active = true, helpOverlayID = "playerinfo_sidebar_globalorders",	helpOverlayText = ReadText(1028, 7709) },
		{ name = ReadText(1001, 7708),		icon = "pi_accountmanagement",		mode = "accounts",			active = true, helpOverlayID = "playerinfo_sidebar_accounts",		helpOverlayText = ReadText(1028, 7713) },
		{ name = ReadText(1001, 11034),		icon = "pi_personnelmanagement",	mode = "personnel",			active = true, helpOverlayID = "playerinfo_sidebar_personnel",		helpOverlayText = ReadText(1028, 7718) },
		{ spacing = true },
		{ name = ReadText(1001, 7730),		icon = function () return playerInfoMenu.messageSidebarIcon() end,		mode = "messages",			active = true, helpOverlayID = "playerinfo_sidebar_messages",		helpOverlayText = ReadText(1028, 7712),		iconcolor = function () return playerInfoMenu.messageSidebarIconColor() end },
		{ name = ReadText(1001, 7702),		icon = "pi_transactionlog",			mode = "transactionlog",	active = true, helpOverlayID = "playerinfo_sidebar_transactions",	helpOverlayText = ReadText(1028, 7719) },
		{ name = ReadText(1001, 5700),		icon = "pi_logbook",				mode = "logbook",			active = true, helpOverlayID = "playerinfo_sidebar_logbook",		helpOverlayText = ReadText(1028, 7711) },
	},
	rightAlignTextProperties = {
		halign = "right"
	},
	rightAlignBoldTextProperties = {
		font = Helper.standardFontBold,
		halign = "right"
	},
	logbookCategories = {
		{ name = ReadText(1001, 2963),	icon = "pi_logbook",		mode = "all" },
		{ empty = true },
		{ name = ReadText(1001, 5701),	icon = "logbook_general",	mode = "general" },
		{ name = ReadText(1001, 5702),	icon = "logbook_missions",	mode = "missions" },
		{ name = ReadText(1001, 5721),	icon = "logbook_news",		mode = "news" },
		{ name = ReadText(1001, 5714),	icon = "logbook_alerts",	mode = "alerts" },
		{ name = ReadText(1001, 5704),	icon = "logbook_upkeep",	mode = "upkeep" },
		{ name = ReadText(1001, 5708),	icon = "logbook_tips",		mode = "tips" },
	},
	logbookPage = 100,
	logbookQueryLimit = 1000,
	messageCategories = {
		{ name = ReadText(1001, 7741),	icon = "pi_message_read_high",	icon_unread = "pi_message_unread_high",	mode = "highprio" },
		{ name = ReadText(1001, 7742),	icon = "pi_message_read_low",	icon_unread = "pi_message_unread_low",	mode = "lowprio" },
	},
	messageCutscenes = {
		["OrbitIndefinitely"] = true,
		["terraforming_scaleplate_green"] = true,
		["terraforming_black_hole_sun"] = true,
		["terraforming_getsu_fune"] = true,
		["terraforming_frontier_edge"] = true,
		["terraforming_atiyas_misfortune"] = true,
		["terraforming_18billion"] = true,
		["terraforming_memory_of_profit"] = true,
		["terraforming_tharkas_cascade"] = true
	},
	mouseOutRange = 100,
	modCountColumnWidth = 60,
	equipmentModClasses = {
		{ name = ReadText(1001, 8008), modclass = "ship" },
		{ name = ReadText(1001, 1301), modclass = "weapon" },
		{ name = ReadText(1001, 1317), modclass = "shield" },
		{ name = ReadText(1001, 1103), modclass = "engine" },
	},
	inventoryCategories = {
		{ id = "crafting",		name = ReadText(1001, 2827) },
		{ id = "upgrade",		name = ReadText(1001, 7716) },
		{ id = "paintmod",		name = ReadText(1001, 8510) },
		{ id = "useful",		name = ReadText(1001, 2828) },
		{ id = "tradeonly",		name = ReadText(1001, 2829) },
	},
	inventoryTabs = {
		{ category = "normal",	name = ReadText(1001, 2202),	icon = "pi_inventory",			helpOverlayID = "playerinfo_inventory_normal",		helpOverlayText = ReadText(1028, 7703) },
	},
	blacklistTypes = {
		[1] = { id = "sectortravel",	text = ReadText(1001, 9165), icon = "", displayremoveoption = false, mouseovertext = ReadText(1026, 9101), shorttext = ReadText(1001, 9162) },
		[2] = { id = "sectoractivity",	text = ReadText(1001, 9166), icon = "", displayremoveoption = false, mouseovertext = ReadText(1026, 9102), shorttext = ReadText(1001, 9163) },
		[3] = { id = "objectactivity",	text = ReadText(1001, 9167), icon = "", displayremoveoption = false, mouseovertext = ReadText(1026, 9103), shorttext = ReadText(1001, 9164) },
	},
	classDefinitions = {
		["object"]	= ReadText(1001, 9198),
		["station"]	= ReadText(1001, 3),
		["ship_xl"]	= ReadText(1001, 11003),
		["ship_l"]	= ReadText(1001, 11002),
		["ship_m"]	= ReadText(1001, 11001),
		["ship_s"]	= ReadText(1001, 11000),
	},
	personnelPage = 100,
}
function newFuncs.buttonTogglePlayerInfo(mode)
	-- kuertee start: callback
	if callbacks ["buttonTogglePlayerInfo_on_start"] then
		for _, callback in ipairs (callbacks ["buttonTogglePlayerInfo_on_start"]) do
			callback (mode, config)
		end
	end
	-- kuertee end: callback

	local oldidx, newidx
	for i, entry in ipairs(config.leftBar) do
		if entry.mode then
			if entry.mode == menu.mode then
				oldidx = i
			end
			if entry.mode == mode then
				newidx = i
			end
		end
		if oldidx and newidx then
			break
		end
	end
	if newidx then
		Helper.updateButtonColor(menu.mainTable, newidx + 2, 1, Helper.defaultArrowRowBackgroundColor)
	end
	if oldidx then
		Helper.updateButtonColor(menu.mainTable, oldidx + 2, 1, Helper.defaultButtonBackgroundColor)
	end

	-- Mark items as read when hiding them
	if (menu.mode == "inventory") or (menu.mode == "spacesuit") or (menu.empireData.mode and (menu.empireData.mode[1] == "empire_call") and (menu.empireData.mode[2] == "inventory")) then
		menu.inventoryData.selectedWares = {}
		C.ReadAllInventoryWares()
		if menu.inventoryData.mode == "online" then
			if Helper.hasExtension("multiverse") then
				Helper.callExtensionFunction("multiverse", "unregisterOnlineEvents", menu)
				Helper.callExtensionFunction("multiverse", "onCloseMenuTab", menu, "ventureinventory", mode)
			end
		end
	elseif menu.mode == "messages" then
		if next(menu.messageData.curEntry) then
			C.SetMessageRead(menu.messageData.curEntry.id, menu.messageData.curEntry.category)
			AddUITriggeredEvent(menu.name, "message_read", ConvertStringTo64Bit(tostring(menu.messageData.curEntry.id)))
		end
		menu.messageData.showFullscreen = nil
		menu.cleanupCutsceneRenderTarget()
	end
	
	AddUITriggeredEvent(menu.name, mode, menu.mode == mode and "off" or "on")
	if mode == menu.mode then
		PlaySound("ui_negative_back")
		menu.mode = nil
		menu.personnelData.curEntry = {}
		if oldidx then
			SelectRow(menu.mainTable, oldidx + 2)
		end
	else
		menu.setdefaulttable = true
		PlaySound("ui_positive_select")
		menu.mode = mode
		if mode == "personnel" then
			menu.empireData.init = true
		end
		if newidx then
			SelectRow(menu.mainTable, newidx + 2)
		end
	end

	menu.refreshInfoFrame(1, 1)
end
function newFuncs.createPlayerInfo(frame, width, height, offsetx, offsety)
	-- kuertee start: callback
	if callbacks ["createPlayerInfo_on_start"] then
		for _, callback in ipairs (callbacks ["createPlayerInfo_on_start"]) do
			callback (config)
		end
	end
	-- kuertee end: callback

	local ftable = frame:addTable(2, { tabOrder = 3, scaling = false, borderEnabled = false, x = offsetx, y = offsety, reserveScrollBar = false })
	ftable:setColWidth(1, menu.sideBarWidth, false)
	ftable:setColWidth(2, width - menu.sideBarWidth - Helper.borderSize, false)

	local row = ftable:addRow(false, { fixed = true, bgColor = Helper.color.transparent60 })
	local icon = row[1]:setColSpan(2):createIcon(function () local logo = C.GetCurrentPlayerLogo(); return ffi.string(logo.icon) end, { width = height, height = height, color = Helper.getPlayerLogoColor })

	local textheight = math.ceil(C.GetTextHeight(Helper.playerInfoConfigTextLeft(), Helper.standardFont, Helper.playerInfoConfig.fontsize, width - height - Helper.borderSize))
	icon:setText(Helper.playerInfoConfigTextLeft,		{ fontsize = Helper.playerInfoConfig.fontsize, halign = "left",  x = height + Helper.borderSize, y = (height - textheight) / 2 })
	icon:setText2(Helper.playerInfoConfigTextRight,	{ fontsize = Helper.playerInfoConfig.fontsize, halign = "right", x = Helper.borderSize,          y = (height - textheight) / 2 })

	local spacingHeight = menu.sideBarWidth / 4
	row = ftable:addRow(false, { fixed = true })
	row[1]:createText(" ", { minRowHeight = menu.sideBarWidth + Helper.scaleY(Helper.titleTextProperties.height) + 2 * Helper.borderSize })
	for _, entry in ipairs(config.leftBar) do
		if entry.spacing then
			row = ftable:addRow(false, { fixed = true })
			row[1]:createIcon("mapst_seperator_line", { width = menu.sideBarWidth, height = spacingHeight })
		else
			row = ftable:addRow(true, { fixed = true })
			row[1]:createButton({ active = entry.active, height = menu.sideBarWidth, bgColor = (menu.mode == entry.mode) and Helper.defaultArrowRowBackgroundColor or Helper.defaultTitleBackgroundColor, mouseOverText = entry.name, helpOverlayID = entry.helpOverlayID, helpOverlayText = entry.helpOverlayText }):setIcon(entry.icon, { color = entry.iconcolor })
			row[1].handlers.onClick = function () return menu.buttonTogglePlayerInfo(entry.mode) end
		end
	end

	ftable:addConnection(1, 1, true)
end
function newFuncs.createInfoFrame()
	-- kuertee start: callback
	if callbacks ["createInfoFrame_on_start"] then
		for _, callback in ipairs (callbacks ["createInfoFrame_on_start"]) do
			callback (menu.infoFrame, tableProperties)
		end
	end
	-- kuertee end: callback

	-- remove old data
	Helper.clearDataForRefresh(menu, config.infoLayer)

	local width = Helper.playerInfoConfig.width
	if (menu.mode == "empire") or (menu.mode == "globalorders") or (menu.mode == "messages") or (menu.mode == "factions") then
		width = menu.playerInfoFullWidth
	end

	local frameProperties = {
		standardButtons = {},
		width = Helper.viewWidth,
		height = Helper.viewHeight,
		x = 0,
		y = 0,
		layer = config.infoLayer,
	}

	menu.infoFrame = Helper.createFrameHandle(menu, frameProperties)

	if not menu.messageData.showFullscreen then
		menu.createTopLevel(menu.infoFrame)
	end

	local tableProperties = {
		width = width - menu.sideBarWidth - Helper.borderSize,
		x = Helper.playerInfoConfig.offsetX + menu.sideBarWidth + Helper.borderSize,
		y = Helper.playerInfoConfig.offsetY + Helper.playerInfoConfig.height + Helper.borderSize,
	}
	tableProperties.height = Helper.viewHeight - tableProperties.y

	Helper.clearTableConnectionColumn(menu, 2)
	Helper.clearTableConnectionColumn(menu, 3)

	if menu.mode == "inventory" then
		menu.createInventory(menu.infoFrame, tableProperties)
	elseif menu.mode == "crafting" then
		menu.createCrafting(menu.infoFrame, tableProperties)
	elseif menu.mode == "equipmentmods" then
		menu.createEquipmentMods(menu.infoFrame, tableProperties)
	elseif menu.mode == "spacesuit" then
		menu.createInventory(menu.infoFrame, tableProperties, "personalupgrade")
	elseif menu.mode == "globalorders" then
		menu.createEmpire(menu.infoFrame, tableProperties)
	elseif menu.mode == "factions" then
		menu.createFactions(menu.infoFrame, tableProperties)
	elseif menu.mode == "transactionlog" then
		tableProperties.width = tableProperties.width * 5 / 4
		tableProperties.x2 = Helper.frameBorder
		Helper.createTransactionLog(menu.infoFrame, C.GetPlayerID(), tableProperties, menu.refreshInfoFrame, { toprow = menu.settoprow, selectedrow = menu.setselectedrow })
		menu.lastTransactionLogRefreshTime = getElapsedTime()
	elseif menu.mode == "empire" then
		menu.createEmpire(menu.infoFrame, tableProperties)
	elseif menu.mode == "accounts" then
		tableProperties.width = tableProperties.width * 3 / 2
		menu.createAccounts(menu.infoFrame, tableProperties)
	elseif menu.mode == "stats" then
		menu.createStats(menu.infoFrame, tableProperties)
	elseif menu.mode == "logbook" then
		tableProperties.width = tableProperties.width * 5 / 4
		menu.createLogbook(menu.infoFrame, tableProperties)
	elseif menu.mode == "messages" then
		menu.createMessages(menu.infoFrame, tableProperties)
	elseif menu.mode == "personnel" then
		menu.createPersonnelInfo(menu.infoFrame, tableProperties)
	end

	-- kuertee start: callback
	if callbacks ["createInfoFrame_on_info_frame_mode"] then
		for _, callback in ipairs (callbacks ["createInfoFrame_on_info_frame_mode"]) do
			callback (menu.infoFrame, tableProperties)
		end
	end
	-- kuertee end: callback

	menu.infoFrame:display()
end
function newFuncs.createFactions(frame, tableProperties)
	local narrowtablewidth = Helper.playerInfoConfig.width - menu.sideBarWidth - Helper.borderSize
	local iconheight = math.ceil(config.rowHeight * 1.5)
	local iconoffset = 2

	local infotable = frame:addTable(3, { tabOrder = 1, borderEnabled = true, width = narrowtablewidth, x = tableProperties.x, y = tableProperties.y })

	-- kuertee start: callback
	infotable:setDefaultCellProperties("text", {minRowHeight = config.rowHeight, fontsize = Helper.standardFontSize})
	infotable:setDefaultCellProperties("button", {height = config.rowHeight})
	-- kuertee end: callback

	if menu.setdefaulttable then
		infotable.properties.defaultInteractiveObject = true
		menu.setdefaulttable = nil
	end
	infotable:setColWidth(1, Helper.scaleX(iconheight) + 2 * iconoffset, false)
	infotable:setColWidthPercent(3, 33)
	infotable:setDefaultBackgroundColSpan(1, 3)

	-- title
	local row = infotable:addRow(nil, { fixed = true, bgColor = Helper.defaultTitleBackgroundColor })
	row[1]:setColSpan(3):createText(ReadText(1001, 7703), Helper.titleTextProperties)
	row[1].properties.height = row[1].properties.height + Helper.borderSize

	-- cover override
	if Helper.isPlayerCovered() then
		local row = infotable:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
		row[1]:createCheckBox(C.IsUICoverOverridden(), { width = Helper.standardTextHeight, height = Helper.standardTextHeight, mouseOverText = ReadText(1026, 7713) })
		row[1].handlers.onClick = function(_, checked) C.SetUICoverOverride(checked); menu.refreshInfoFrame() end
		row[2]:setColSpan(2):createText(ReadText(1001, 11604), { mouseOverText = ReadText(1026, 7713) })
	end

	menu.relations = GetLibrary("factions")
	for i, relation in ipairs(menu.relations) do
		if relation.id == "player" then
			table.remove(menu.relations, i)
			break
		end
	end
	table.sort(menu.relations, Helper.sortName)	
	menu.licences = {}
	for i, relation in ipairs(menu.relations) do
		menu.licences[relation.id] = GetOwnLicences(relation.id)
		table.sort(menu.licences[relation.id], menu.sortLicences)
	end

	if #menu.relations == 0 then
		row = infotable:addRow(true, { bgColor = Helper.color.transparent })
		row[1]:setColSpan(3):createText("--- " .. ReadText(1001, 38) .. " ---", { halign = "center" })
	else
		for i, relation in ipairs(menu.relations) do
			local shortname = GetFactionData(relation.id, "shortname")
			row = infotable:addRow({ "faction", relation }, { bgColor = Helper.color.transparent })
			row[1]:createIcon((relation.icon ~= "") and relation.icon or "solid", { height = iconheight, x = iconoffset, color = function () return menu.relationColor(relation.id) end, mouseOverText = function () local prioritizedrelationrangename = GetFactionData(relation.id, "prioritizedrelationrangename"); return prioritizedrelationrangename end })
			row[2]:createText("[" .. shortname .. "] " .. relation.name, { fontsize = 14, color = function () return menu.relationColor(relation.id) end, y = 2 * iconoffset, minRowHeight = iconheight + 2 * iconoffset, mouseOverText = function () local prioritizedrelationrangename = GetFactionData(relation.id, "prioritizedrelationrangename"); return prioritizedrelationrangename end })
			row[3]:createText(
				function () return string.format("%+d", GetUIRelation(relation.id)) end,
				{ font = Helper.standardFontMono, color = function () return menu.relationColor(relation.id) end, fontsize = 14, halign = "right", y = 2 * iconoffset, mouseOverText = function () local prioritizedrelationrangename = GetFactionData(relation.id, "prioritizedrelationrangename"); return prioritizedrelationrangename end })
		end
	end
	infotable:setTopRow(menu.settoprow)
	infotable:setSelectedRow(menu.setselectedrow)
	menu.settoprow = nil
	menu.setselectedrow = nil

	-- faction details
	local detailtable = frame:addTable(3, { tabOrder = 2, width = tableProperties.width - 2 * (narrowtablewidth + Helper.borderSize), x = tableProperties.x + infotable.properties.width + Helper.borderSize, y = infotable.properties.y, highlightMode = "grey" })
	detailtable:setColWidth(1, 2 * Helper.titleHeight)

	local relation = menu.factionData.curEntry

	local row = detailtable:addRow(nil, { fixed = true, bgColor = Helper.defaultTitleBackgroundColor })
	row[1]:setBackgroundColSpan(3):createText(next(relation) and ("\27[" .. relation.icon .. "]") or "", Helper.titleTextProperties)
	local name
	if next(relation) then
		local shortname = GetFactionData(relation.id, "shortname")
		name = "[" .. shortname .. "] " .. relation.name
	end
	row[2]:setColSpan(2):createText(name, Helper.titleTextProperties)
	row[2].properties.height = row[2].properties.height + Helper.borderSize

	if next(relation) then
		local isrelationlocked, relationlockreason, willclaimspace = GetFactionData(relation.id, "isrelationlocked", "relationlockreason", "willclaimspace")
		-- sector ownership
		if not willclaimspace then
			local row = detailtable:addRow(nil, { bgColor = Helper.color.transparent })
			row[1]:setColSpan(3):createText(ReadText(1001, 7784))

			detailtable:addEmptyRow(Helper.standardTextHeight / 2)
		end

		-- kuertee start: callback
		if callbacks ["createFactions_on_before_render_licences"] then
			for _, callback in ipairs (callbacks ["createFactions_on_before_render_licences"]) do
				callback (frame, tableProperties, relation.id, detailtable)
			end
		end
		-- kuertee end: callback

		-- licences
		if menu.licences[relation.id] and #menu.licences[relation.id] > 0 then
			local row = detailtable:addRow(nil, { bgColor = Helper.color.transparent })
			row[1]:setBackgroundColSpan(3):setColSpan(2):createText(ReadText(1001, 62), Helper.subHeaderTextProperties)
			row[3]:createText(ReadText(1001, 7748), Helper.subHeaderTextProperties)
			row[3].properties.halign = "right"

			for i, licence in ipairs(menu.licences[relation.id]) do
				local row = detailtable:addRow({ "licence", licence.id }, { bgColor = Helper.color.transparent })
				local color = Helper.color.grey
				if HasLicence("player", licence.type, relation.id) then
					color = Helper.color.white
				end
				local name = licence.name
				if licence.precursor then
					name = "    " .. name
				end
				local info
				if licence.price > 0 then
					info = ConvertMoneyString(licence.price, false, true, 0, true) .. " " .. ReadText(1001, 101)
				elseif not licence.precursor then
					info = string.format("%+d", licence.minrelation)
				end
				row[2]:createText(name, { color = color, mouseOverText = licence.desc })
				row[3]:createText(info, { halign = "right", color = color })
				AddKnownItem("licences", licence.id)
			end

			detailtable:addEmptyRow(Helper.standardTextHeight / 2)
		end
		-- relation
		local row = detailtable:addRow(nil, { bgColor = Helper.color.transparent })
		row[1]:setColSpan(3):createText(ReadText(1001, 7749), Helper.subHeaderTextProperties)

		local row = detailtable:addRow(true, { bgColor = Helper.color.transparent })
		row[2]:setColSpan(2):createText(ffi.string(C.GenerateFactionRelationText(relation.id)))

		detailtable:addEmptyRow(Helper.standardTextHeight / 2)
		-- war declaration
		local row = detailtable:addRow(true, { bgColor = Helper.color.transparent })
		local active = true
		local mouseovertext
		if GetUIRelation(relation.id) <= -25 then
			active = false
			mouseovertext = ReadText(1026, 7702)
		elseif isrelationlocked then
			active = false
			mouseovertext = (relationlockreason ~= "") and relationlockreason or ReadText(20229, 100)
		end
		row[3]:createButton({ active = active, mouseOverText = mouseovertext }):setText(ReadText(1001, 7750), { halign = "center" })
		row[3].handlers.onClick = function () return menu.buttonWarDeclarationConfirm(relation.id) end

		-- kuertee start: callback
		if callbacks ["createFactions_on_after_declare_war_button"] then
			for _, callback in ipairs (callbacks ["createFactions_on_after_declare_war_button"]) do
				callback (frame, tableProperties, relation.id, detailtable)
			end
		end
		-- kuertee end: callback
	end

	infotable:addConnection(1, 2, true)
	detailtable:addConnection(1, 3, true)
end
function newFuncs.onRowChanged(row, rowdata, uitable, modified, input)
	if uitable == menu.infoTable then
		if (menu.mode == "inventory") or (menu.mode == "spacesuit") then
			menu.onInventoryRowChange(row, rowdata, input, menu.mode)
		elseif menu.mode == "crafting" then
			if type(rowdata) == "table" then
				if menu.inventoryData.mode ~= "craft" then
					local isunbundleammo, component = GetWareData(rowdata[1], "isunbundleammo", "component")
					local ammospace = false
					if isunbundleammo then
						local playership = C.GetPlayerOccupiedShipID()
						if playership ~= 0 then
							ammospace = AddAmmo(ConvertStringToLuaID(tostring(playership)), component, 1, true) == 1
						end
					end

					local row = 1
					if menu.inventoryData.craftingHistory[1] then
						row = row + math.min(3, #menu.inventoryData.craftingHistory) + 2
					end

					if menu.findInventoryWare(menu.craftable, rowdata[1]) then
						local mot_craft = ""
						local active = false
						if rowdata[2].craftable > 0 then
							if (not isunbundleammo) or ammospace then
								mot_craft = ReadText(1026, 3900)
								active = true
							else
								mot_craft = ReadText(1026, 3903)
							end
						else
							mot_craft = ReadText(1026, 3901)
						end

						Helper.removeButtonScripts(menu, menu.buttonTable, row, 1)
						SetCellContent(menu.buttonTable, Helper.createButton(Helper.createTextInfo(ReadText(1001, 7706), "center", Helper.standardFont, Helper.standardFontSize, 255, 255, 255, 100), nil, false, active, 0, 0, 0, Helper.standardButtonHeight, nil, nil, nil, mot_craft), row, 1)
						Helper.setButtonScript(menu, nil, menu.buttonTable, row, 1, menu.buttonInventoryCraft)
					else
						Helper.removeButtonScripts(menu, menu.buttonTable, row, 1)
						SetCellContent(menu.buttonTable, Helper.getEmptyCellDescriptor(), row, 1)
					end
				end
			end
		elseif menu.mode == "factions" then
			if type(rowdata) == "table" then
				if rowdata[2].id ~= menu.factionData.curEntry.id then
					menu.factionData.curEntry = rowdata[2]
					menu.refresh = getElapsedTime()
				end
			end
		elseif menu.mode == "messages" then
			if type(rowdata) == "table" then
				if rowdata.id ~= menu.messageData.curEntry.id then
					if next(menu.messageData.curEntry) then
						C.SetMessageRead(menu.messageData.curEntry.id, menu.messageData.curEntry.category)
						AddUITriggeredEvent(menu.name, "message_read", ConvertStringTo64Bit(tostring(menu.messageData.curEntry.id)))
					end
					menu.messageData.curEntry = rowdata
					menu.messageData.showFullscreen = nil
					menu.cleanupCutsceneRenderTarget()
					menu.refresh = getElapsedTime()
				end
			end
		elseif menu.mode == "personnel" then
			if type(rowdata) == "table" then
				if rowdata[2].id ~= menu.personnelData.curEntry.id then
					menu.personnelData.curEntry = rowdata[2]
					menu.refresh = getElapsedTime()
				end
			end
		elseif menu.mode == "transactionlog" then
			Helper.onTransactionLogRowChanged(rowdata)
		elseif (menu.mode == "empire") or (menu.mode == "globalorders") then
			if (type(rowdata) == "table") and ((menu.empireData.mode[2] ~= rowdata[2]) or ((type(rowdata[3]) == "table") and ((menu.empireData.mode[3].id ~= rowdata[3].id) or (menu.empireData.mode[3].index ~= rowdata[3].index)))) then
				--print("onRowChanged. row: " .. tostring(row) .. ". rowdata 1: " .. tostring(rowdata[1]) .. ", rowdata 2: " .. tostring(rowdata[2]) .. ". oldmode 1: " .. tostring(menu.empireData.mode[1]) .. ", oldmode 2: " .. tostring(menu.empireData.mode[2]))
				--menu.empireData.oldmode = menu.empireData.mode
				if ((menu.empireData.mode[1] == "empire_call") and (menu.empireData.mode[2] == "inventory")) then
					menu.inventoryData.selectedWares = {}
					C.ReadAllInventoryWares()
				end
				menu.empireData.mode = rowdata

				-- always clear the selected object when changing modes. selectedobject will be populated right after as appropriate.
				menu.empireData.selectedobject = nil
				menu.empireData.objecttype = nil

				menu.over = true
			end
		end
	elseif ((menu.mode == "empire") or (menu.mode == "globalorders")) and menu.empireData.mode and (type(menu.empireData.mode) == "table") then
		--print("mode 1: " .. tostring(menu.empireData.mode[1]) .. ", mode 2: " .. tostring(menu.empireData.mode[2]))
		if (menu.empireData.mode[1] == "empire_grid") then
			local changed = nil

			if (menu.empireData.mode[2] == "logo") or (menu.empireData.mode[2] == "painttheme") then
				local locship = ConvertStringTo64Bit(tostring(C.GetLastPlayerControlledShipID()))
				if locship and (locship ~= 0) and (locship ~= menu.empireData.selectedobject) and menu.empireCanShowObject(locship) and (not C.IsComponentClass(locship, "spacesuit")) and (not GetComponentData(locship, "paintmodlocked")) then
					--print("changing object from: " .. tostring(menu.empireData.selectedobject) .. " to: " .. tostring(locship))
					menu.empireData.selectedobject = locship
					menu.empireData.objecttype = "object"
					changed = true
				end

				if (not menu.empireData.selectedobject) and (#menu.empireData.ships > 0) then
					for _, ship in ipairs(menu.empireData.ships) do
						if menu.empireCanShowObject(ship) and (not GetComponentData(ship, "paintmodlocked")) then
							menu.empireData.selectedobject = ship
							menu.empireData.objecttype = "object"
							changed = true
							break
						end
					end
				end
				--print("grid. selected object: " .. tostring(menu.empireData.selectedobject))
			elseif (menu.empireData.mode[2] == "uniform") then
				if not menu.empireData.selectedobject or (menu.empireData.objecttype ~= "npc") then
					for _, employeedata in ipairs(menu.empireData.employees) do
						if (employeedata.type == "entity") and menu.empireCanShowObject(employeedata.id) then
							if (menu.empireData.selectedobject ~= employeedata.id) then
								--print("switching selectedobject from: " .. tostring(menu.empireData.selectedobject) .. " to: " .. tostring(employeedata.id))
								menu.empireData.selectedobject = employeedata.id
								menu.empireData.objecttype = "npc"
								changed = true
							end
							break
						end
					end
				end
			end

			if changed then
				menu.over = true
			end
		elseif (menu.empireData.mode[1] == "empire_list") then
			--print("rowdata type: " .. tostring(type(rowdata)) .. ", rowdata: " .. tostring(rowdata))
			if (type(rowdata) == "table") then
				local changed = nil

				if (rowdata[1] == "painttheme") then
					local locship = ConvertStringTo64Bit(tostring(C.GetLastPlayerControlledShipID()))
					if locship and (locship ~= 0) and (locship ~= menu.empireData.selectedobject) and menu.empireCanShowObject(locship) and not C.IsComponentClass(locship, "spacesuit") then
						--print("changing object from: " .. tostring(menu.empireData.selectedobject) .. " to: " .. tostring(locship))
						menu.empireData.selectedobject = locship
						menu.empireData.objecttype = "object"
						changed = true
					end

					if not menu.empireData.selectedobject and #menu.empireData.ships > 0 then
						for _, ship in ipairs(menu.empireData.ships) do
							if menu.empireCanShowObject(ship) then
								menu.empireData.selectedobject = ship
								menu.empireData.objecttype = "object"
								changed = true
								break
							end
						end
					end

					--print("current theme: " .. ffi.string(C.GetPlayerPaintTheme()) .. ", new theme: " .. tostring(rowdata[2]))
					if (ffi.string(C.GetPlayerPaintTheme()) ~= rowdata[2]) then
						C.SetPlayerPaintTheme(rowdata[2])
						--print("new paint theme set: " .. ffi.string(C.GetPlayerPaintTheme()))
					end
				elseif (rowdata[1] == "uniform") then
					if not menu.empireData.selectedobject or (menu.empireData.objecttype ~= "npc") then
						for _, employeedata in ipairs(menu.empireData.employees) do
							if (employeedata.type == "entity") and menu.empireCanShowObject(employeedata.id) then
								if (menu.empireData.selectedobject ~= employeedata.id) then
									--print("switching selectedobject from: " .. tostring(menu.empireData.selectedobject) .. " to: " .. tostring(employeedata.id))
									menu.empireData.selectedobject = employeedata.id
									menu.empireData.objecttype = "npc"
									changed = true
								end
								break
							end
						end
					end

					--print("current uniform: " .. ffi.string(C.GetPlayerClothingTheme()) .. ", new uniform: " .. tostring(rowdata[2]))
					if (ffi.string(C.GetPlayerClothingTheme()) ~= rowdata[2]) then
						C.SetPlayerClothingTheme(rowdata[2])
						--print("new uniform set: " .. ffi.string(C.GetPlayerClothingTheme()))
					end
				elseif (rowdata[1] == "empire_ship") or (rowdata[1] == "empire_station") or (rowdata[1] == "empire_onlineship") then
					if rowdata[2] and menu.empireCanShowObject(rowdata[2]) then
						if (menu.empireData.selectedobject ~= rowdata[2]) then
							menu.empireData.selectedobject = rowdata[2]
							menu.empireData.objecttype = "object"
							changed = true
							--print("selected object: " .. ffi.string(C.GetComponentName(rowdata[2])))
						end
					end
				elseif (rowdata[1] == "empire_employee") then
					if (rowdata[2].type == "entity") then
						if menu.empireCanShowObject(rowdata[2].id) and (menu.empireData.selectedobject ~= rowdata[2].id) then
							--print("switching selectedobject from: " .. tostring(menu.empireData.selectedobject) .. " to: " .. tostring(rowdata[2].id))
							menu.empireData.selectedobject = rowdata[2].id
							menu.empireData.objecttype = "npc"
							changed = true
							--print("selected entity: " .. rowdata[2].name .. " " .. tostring(rowdata[2].id))
						end
					elseif (rowdata[2].type == "person") then
						local instantiatedperson = ConvertStringTo64Bit(tostring(C.GetInstantiatedPerson(rowdata[2].id, rowdata[2].container)))
						if (instantiatedperson ~= 0) and menu.empireCanShowObject(instantiatedperson) and (menu.empireData.selectedobject ~= instantiatedperson) then
							menu.empireData.selectedobject = instantiatedperson
							menu.empireData.objecttype = "npc"
							changed = true
							--print("selected person: " .. rowdata[2].name .. " " .. tostring(rowdata[2].id))
						end
					else
						DebugError("Empire Menu: unsupported employee type: " .. tostring(rowdata[2].type))
					end
				end

				if changed then
					menu.setselectedrow2 = row
					menu.over = true
				end
			end
		elseif (menu.empireData.mode[1] == "empire_call") then
			local changed = nil

			if (menu.empireData.mode[2] == "inventory") then
				if (type(rowdata) == "table") and (not menu.empireData.selectedobject or menu.empireData.selectedobject ~= rowdata[1]) then
					--print("ware: " .. tostring(rowdata[1]))
					menu.empireData.selectedobject = rowdata[1]
					menu.empireData.objecttype = "ware"
					changed = true
				end
				menu.onInventoryRowChange(row, rowdata, input, menu.empireData.mode[2])
			end

			if changed then
				menu.setselectedrow2 = row
				menu.over = true
			end
		end
	end

	-- kuertee start: callback
	if callbacks ["onRowChanged"] then
		for _, callback in ipairs (callbacks ["onRowChanged"]) do
			callback (row, rowdata, uitable, modified, input)
		end
	end
	-- kuertee end: callback
end
init ()
