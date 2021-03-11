local config = {
	mainLayer = 5,
	infoLayer = 4,
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
	messageCategories = {
		{ name = ReadText(1001, 7741),	icon = "pi_message_read_high",	icon_unread = "pi_message_unread_high",	mode = "highprio" },
		{ name = ReadText(1001, 7742),	icon = "pi_message_read_low",	icon_unread = "pi_message_unread_low",	mode = "lowprio" },
	},
}
function newFuncs.buttonTogglePlayerInfo(mode)
	local menu = playerInfoMenu

	-- start kuertee_lua_with_callbacks:
	if callbacks ["buttonTogglePlayerInfo_on_start"] then
		for _, callback in ipairs (callbacks ["buttonTogglePlayerInfo_on_start"]) do
			callback (mode, config)
		end
	end
	-- end kuertee_lua_with_callbacks:

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
	elseif menu.mode == "messages" then
		if next(menu.messageData.curEntry) then
			C.SetMessageRead(menu.messageData.curEntry.id, menu.messageData.curEntry.category)
			AddUITriggeredEvent(menu.name, "message_read", ConvertStringTo64Bit(tostring(menu.messageData.curEntry.id)))
		end
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
	local menu = playerInfoMenu

	-- start kuertee_lua_with_callbacks:
	if callbacks ["createPlayerInfo_on_start"] then
		for _, callback in ipairs (callbacks ["createPlayerInfo_on_start"]) do
			callback (config)
		end
	end
	-- end kuertee_lua_with_callbacks:

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
end
function newFuncs.createInfoFrame()
	local menu = playerInfoMenu

	-- start kuertee_lua_with_callbacks:
	if callbacks ["createInfoFrame_on_start"] then
		for _, callback in ipairs (callbacks ["createInfoFrame_on_start"]) do
			callback (menu.infoFrame, tableProperties)
		end
	end
	-- end kuertee_lua_with_callbacks:

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

	menu.createTopLevel(menu.infoFrame)

	local tableProperties = {
		width = width - menu.sideBarWidth - Helper.borderSize,
		x = Helper.playerInfoConfig.offsetX + menu.sideBarWidth + Helper.borderSize,
		y = Helper.playerInfoConfig.offsetY + Helper.playerInfoConfig.height + Helper.borderSize,
	}
	tableProperties.height = Helper.viewHeight - tableProperties.y

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
		menu.createLogbook(menu.infoFrame, tableProperties)
	elseif menu.mode == "messages" then
		menu.createMessages(menu.infoFrame, tableProperties)
	elseif menu.mode == "personnel" then
		menu.createPersonnelInfo(menu.infoFrame, tableProperties)

	else
		-- start kuertee_lua_with_callbacks:
		if callbacks ["createInfoFrame_on_info_frame_mode"] then
			for _, callback in ipairs (callbacks ["createInfoFrame_on_info_frame_mode"]) do
				callback (menu.infoFrame, tableProperties)
			end
		end
		-- end kuertee_lua_with_callbacks:
	end

	menu.infoFrame:display()
end
function newFuncs.createFactions(frame, tableProperties)
	local menu = playerInfoMenu

	local narrowtablewidth = Helper.playerInfoConfig.width - menu.sideBarWidth - Helper.borderSize
	local iconheight = math.ceil(config.rowHeight * 1.5)
	local iconoffset = 2

	local infotable = frame:addTable(3, { tabOrder = 1, borderEnabled = true, width = narrowtablewidth, x = tableProperties.x, y = tableProperties.y })

	-- start kuertee_lua_with_callbacks:
	infotable:setDefaultCellProperties("text", {minRowHeight = config.rowHeight, fontsize = Helper.standardFontSize})
	infotable:setDefaultCellProperties("button", {height = config.rowHeight})
	-- end kuertee_lua_with_callbacks:

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
			row[1]:createIcon((relation.icon ~= "") and relation.icon or "solid", { height = iconheight, x = iconoffset, color = function () return menu.relationColor(relation.id) end })
			row[2]:createText("[" .. shortname .. "] " .. relation.name, { fontsize = 14, color = function () return menu.relationColor(relation.id) end, y = 2 * iconoffset, minRowHeight = iconheight + 2 * iconoffset })
			row[3]:createText(
				function () return string.format("%+d", GetUIRelation(relation.id)) end,
				{ font = Helper.standardFontMono, color = function () return menu.relationColor(relation.id) end, fontsize = 14, halign = "right", y = 2 * iconoffset })

			-- start kuertee_lua_with_callbacks:
			if callbacks ["createFactions_on_before_render_licences"] then
				for _, callback in ipairs (callbacks ["createFactions_on_before_render_licences"]) do
					callback (frame, tableProperties, relation.id, infotable)
				end
			end
			-- end kuertee_lua_with_callbacks:

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
		local isrelationlocked, relationlockreason = GetFactionData(relation.id, "isrelationlocked", "relationlockreason")
		if GetUIRelation(relation.id) <= -25 then
			active = false
			mouseovertext = ReadText(1026, 7702)
		elseif isrelationlocked then
			active = false
			mouseovertext = (relationlockreason ~= "") and relationlockreason or ReadText(20229, 100)
		end
		row[3]:createButton({ active = active, mouseOverText = mouseovertext }):setText(ReadText(1001, 7750), { halign = "center" })
		row[3].handlers.onClick = function () return menu.buttonWarDeclarationConfirm(relation.id) end
	end
end
