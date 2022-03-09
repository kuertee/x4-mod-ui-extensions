﻿local config = {
	layer = 3,
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
			{ id = "main_assignments_attack",				text = ReadText(20208, 40904) },
			{ id = "main_assignments_interception",			text = ReadText(20208, 41004) },
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
		{ id = "guidance",				text = "",						isorder = nil,		isplayerinteraction = true },
		{ id = "player_interaction",	text = ReadText(1001, 7843),	isorder = false,	isplayerinteraction = true },
		{ id = "consumables",			text = ReadText(1001, 7846),	isorder = false,	subsections = {
			{ id = "consumables_civilian",	text = ReadText(1001, 7847) },
			{ id = "consumables_military",	text = ReadText(1001, 7848) },
		}},
		{ id = "cheats",				text = "Cheats",				isorder = false }, -- (cheat only)
		{ id = "selected_orders_all",	text = ReadText(1001, 7804),	isorder = true,		showloop = true },
		{ id = "selected_orders",		text = ReadText(1001, 7804),	isorder = true,		showloop = true },
		{ id = "mining_orders",			text = "",						isorder = true,		showloop = true,		subsections = {
			{ id = "mining",			text = "\27[order_miningplayer] " .. ReadText(1041, 351) },
		}},
		{ id = "venturedockoption",		text = "",						isorder = true,		showloop = true,		subsections = {
			{ id = "venturedock",	text = "\27[order_dockandwait] " .. ReadText(1001, 7844) },
		}},
		{ id = "trade_orders",			text = ReadText(1001, 7861),	isorder = true,		showloop = true },
		{ id = "selected_assignments_all", text = ReadText(1001, 7886),	isorder = true },
		{ id = "selected_change_assignments",	text = ReadText(1001, 11119),	isorder = true,		subsections = {
			{ id = "selected_change_assignments_defence",				text = ReadText(20208, 40304),	helpOverlayID = "interactmenu_change_assign",	helpOverlayText = " ",	helpOverlayHighlightOnly = true },
			{ id = "selected_change_assignments_attack",				text = ReadText(20208, 40904) },
			{ id = "selected_change_assignments_interception",			text = ReadText(20208, 41004) },
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
			{ id = "selected_assignments_attack",				text = ReadText(20208, 40904) },
			{ id = "selected_assignments_interception",			text = ReadText(20208, 41004) },
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
		["attack"]					= { name = ReadText(20208, 40904) },
		["interception"]			= { name = ReadText(20208, 41004) },
		["follow"]					= { name = ReadText(20208, 41304) },
		["supplyfleet"]				= { name = ReadText(20208, 40704) },
		["mining"]					= { name = ReadText(20208, 40204) },
		["trade"]					= { name = ReadText(20208, 40104) },
		["tradeforbuildstorage"]	= { name = ReadText(20208, 40804) },
		["assist"]					= { name = ReadText(20208, 41204) },
		["salvage"]					= { name = ReadText(20208, 41401) },
	},
}
function menu.createContentTable(frame, position)
	local x = 0
	if position == "right" then
		x = menu.width + Helper.borderSize
	end

	local ftable = frame:addTable(4, { tabOrder = menu.subsection and 2 or 1, x = x, width = menu.width, backgroundID = "solid", backgroundColor = Helper.color.semitransparent, highlightMode = "off" })
	ftable:setDefaultCellProperties("text",   { minRowHeight = config.rowHeight, fontsize = config.entryFontSize, x = config.entryX })
	ftable:setDefaultCellProperties("button", { height = config.rowHeight })
	ftable:setDefaultComplexCellProperties("button", "text", { fontsize = config.entryFontSize, x = config.entryX })
	ftable:setDefaultComplexCellProperties("button", "text2", { fontsize = config.entryFontSize, x = config.entryX })

	local text = menu.texts.targetShortName
	local color = menu.colors.target
	if menu.construction then
		text = menu.texts.constructionName
	end

	local modetext = ReadText(1001, 7804)
	if (not menu.syncpoint) and (not menu.syncpointorder) and (not menu.mission) and (not menu.missionoffer) then
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
			"\n   showPlayerInteractions: " .. tostring(menu.texts.showPlayerInteractions) ..
			"\n   syncpoint: " .. tostring(menu.texts.syncpoint) ..
			"\n   syncpointorder: " .. tostring(menu.texts.syncpointorder) ..
			"\n   mission: " .. tostring(menu.texts.mission) ..
			"\n   missionoffer: " .. tostring(menu.texts.missionoffer) ..
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

	ftable:setColWidth(1, borderwidth, false)
	ftable:setColWidth(3, math.ceil(0.4 * menu.width - borderwidth - Helper.borderSize), false)
	ftable:setColWidth(4, borderwidth, false)
	ftable:setDefaultBackgroundColSpan(1, 4)
	ftable:setDefaultColSpan(1, 2)
	ftable:setDefaultColSpan(3, 2)

	local height = 0
	if (((not menu.showPlayerInteractions) and (#menu.selectedplayerships > 0)) or ((#menu.selectedplayerships == 0) and (#menu.selectedotherobjects > 0))) and (not menu.syncpoint) and (not menu.syncpointorder) and (not menu.mission) and (not menu.missionoffer) then
		-- modemarker
		local row = ftable:addRow(false, { bgColor = Helper.color.transparent })
		row[1]:setColSpan(1):createIcon("be_diagonal_01", { width = bordericonsize, height = bordericonsize, x = borderwidth - bordericonsize + Helper.borderSize, scaling = false, color = Helper.defaultTitleTrapezoidBackgroundColor })
		row[3]:setColSpan(1)
		row[2]:setColSpan(2)
		local width = row[2]:getColSpanWidth() + Helper.scrollbarWidth + Helper.borderSize
		row[2]:createIcon("solid", { height = bordericonsize, width = width, scaling = false, color = Helper.defaultTitleTrapezoidBackgroundColor }):setText(modetext, { font = Helper.headerRow1Font, fontsize = Helper.scaleFont(Helper.headerRow1Font, Helper.headerRow1FontSize, true), halign = "center", x = math.ceil((width - Helper.borderSize) / 2) })
		row[4]:setColSpan(1):createIcon("be_diagonal_02", { width = bordericonsize, height = bordericonsize, scaling = false, color = Helper.defaultTitleTrapezoidBackgroundColor })
		height = height + row:getHeight() + Helper.borderSize
	end
	-- title
	local row = ftable:addRow(false, { bgColor = Helper.color.transparent })
	text = TruncateText(text, Helper.standardFontBold, Helper.scaleFont(Helper.standardFontBold, Helper.headerRow1FontSize), menu.width - Helper.scaleX(Helper.standardButtonWidth) - 2 * config.entryX)
	row[1]:setColSpan(4):createText(text, Helper.headerRowCenteredProperties)
	row[1].properties.color = color
	height = height + row:getHeight() + Helper.borderSize
	if menu.subordinategroup and (#menu.selectedplayerships == 0) then
		row[1].properties.titleColor = nil
		local row = ftable:addRow(nil, { bgColor = Helper.color.transparent })
		row[1]:setColSpan(4):createText(string.format(ReadText(1001, 8398), ReadText(20401, menu.subordinategroup)), Helper.headerRowCenteredProperties)
		row[1].properties.color = color
	end

	-- entries
	local convertedComponent = ConvertStringTo64Bit(tostring(menu.componentSlot.component))
	local isonlinetarget, isplayerownedtarget
	if convertedComponent ~= 0 then
		isonlinetarget, isplayerownedtarget = GetComponentData(convertedComponent, "isonlineobject", "isplayerowned")
	end

	local skipped = false
	if (not menu.syncpoint) and (not menu.syncpointorder) and (not menu.mission) and (not menu.missionoffer) then
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
			row[1]:setColSpan(4):createText(reason, { wordwrap = true, color = Helper.color.grey })
			skipped = true
		elseif isonlinetarget and isplayerownedtarget then
			local row = ftable:addRow(true, { fixed = true, bgColor = Helper.color.darkgrey })
			row[1]:setColSpan(4):createText(ReadText(1001, 7868), { wordwrap = true, color = Helper.color.grey })
			skipped = true
		elseif (#menu.ventureships > 0) and (#menu.selectedplayerships == 0) then
			local row = ftable:addRow(true, { fixed = true, bgColor = Helper.color.darkgrey })
			row[1]:setColSpan(4):createText(ReadText(1001, 7868), { wordwrap = true, color = Helper.color.grey })
			skipped = true
		elseif (menu.numorderloops > 0) and (#menu.selectedplayerships ~= menu.numorderloops) then
			local row = ftable:addRow(true, { fixed = true, bgColor = Helper.color.darkgrey })
			row[1]:setColSpan(4):createText(ReadText(1001, 11108), { wordwrap = true, color = Helper.color.grey })
			skipped = true
		elseif (menu.numorderloops > 1) then
			local row = ftable:addRow(true, { fixed = true, bgColor = Helper.color.darkgrey })
			row[1]:setColSpan(4):createText(ReadText(1001, 11109), { wordwrap = true, color = Helper.color.grey })
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
							local button = row[1]:setColSpan(4):createButton({
								bgColor = #menu.actions[subsection.id] > 0 and Helper.color.transparent or Helper.color.darkgrey,
								highlightColor = #menu.actions[subsection.id] > 0 and Helper.defaultButtonHighlightColor or Helper.defaultUnselectableButtonHighlightColor,
								mouseOverText = (#menu.actions[subsection.id] > 0) and "" or menu.forceSubSection[subsection.id],
								helpOverlayID = subsection.helpOverlayID,
								helpOverlayText = subsection.helpOverlayText,
								helpOverlayHighlightOnly = subsection.helpOverlayHighlightOnly,
							}):setText(subsection.text, { color = Helper.color.white }):setIcon("table_arrow_inv_right", { scaling = false, width = iconHeight, height = iconHeight, x = menu.width - iconHeight })
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
						local button = row[1]:setColSpan(4):createButton({
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
			local button = row[1]:setColSpan(4):createButton({ active = false, bgColor = Helper.color.darkgrey }):setText("---", { halign = "center", color = Helper.color.red })
		end
	end

	ftable:setSelectedRow(menu.selectedRows.contentTable)
	ftable:setTopRow(menu.topRows.contentTable)
	menu.selectedRows.contentTable = nil
	menu.topRows.contentTable = nil

	return ftable
end