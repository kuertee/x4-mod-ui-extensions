-- param == { 0, 0, enablesecretscenarios }

-- ffi setup
local ffi = require("ffi")
local C = ffi.C
ffi.cdef[[
	void EnableScenarioLoading(bool reverse, const char* gamestartid);
	void FadeScreen2(float fadeouttime, float fadeintime, float holdtime);
	const char* GetUserData(const char* name);
	float GetScenarioScoreForNextStar(const char* scenarioid);
	bool IsOnlineEnabled(void);
	void LeaveScenarioConsole(void);
	const char* ReplaceGlyphsWithAToZ(const char* inputtext);
	void SetUserData(const char* name, const char* value);
]]

local menu = {
	name = "ScenarioSelectionMenu",
	selectedchapter = 1,
	ladderDisplayMode = 0,

	topRows = {},
	selectedRows = {},
	selectedCols = {},
}

local config = {
	infoFrameLayer = 5,
	infoFrame2Layer = 4,

	scenarioFadeOutTime = 1,
	scenarioFadeHoldDuration = 0.1,

	tabScrollSpacing = 40,

	ratingFontSize = 22,
	terminusRatingFontSize = 29,
}

-- kuertee start:
menu.uix_callbacks = {}
function menu.uix_getConfig() return config end
-- kuertee end

local function init()
	Menus = Menus or { }
	table.insert(Menus, menu)
	if Helper then
		Helper.registerMenu(menu)
	end

	RegisterEvent("timelinesRankingsReceived", menu.onTimelinesRankingsReceived)

	-- kuertee start:
	menu.init_kuertee()
	-- kuertee end
end

-- kuertee start:
function menu.init_kuertee ()
end
-- kuertee end

function menu.onTimelinesRankingsReceived(_, success)
	if menu.shown then
		local scenario = menu.scenariosByID[menu.selectedscenario]
		scenario.ladder.isrequested = false
		scenario.ladder.isvalid = success
		if success then
			scenario.ladder.rankings = OnlineGetScenarioRankings(menu.selectedscenario)
		else
			scenario.ladder.nexttime = getElapsedTime() + 10
		end
		menu.refreshInfoFrame()
	end
end

function menu.cleanup()
	C.LeaveScenarioConsole()

	if menu.hasInputModeChangedRegistered then
		unregisterForEvent("inputModeChanged", getElement("Scene.UIContract"), menu.onInputModeChanged)
		menu.hasInputModeChangedRegistered = nil
	end

	menu.setpiecescenario = nil
	menu.selectedscenario = nil
	menu.selectedchapter = 1
end

function menu.onShowMenu()
	menu.enableSecretScenarios = menu.param and (menu.param[3] ~= 0)

	menu.chapters = {}
	menu.scenarios = {}
	local gamemodules = GetRegisteredModules(true)
	for _, module in ipairs(gamemodules) do
		if module.timelinesscenario then
			local chapter = module.scenariodata.chapter
			if (not menu.enableSecretScenarios) or ((chapter == 0) and ((not module.hasunlockconditions) or module.unlocked)) then
				if menu.enableSecretScenarios then
					chapter = 1
				end
				if menu.chapters[chapter] then
					table.insert(menu.chapters[chapter].scenarios, module.id)
				else
					menu.chapters[chapter] = { scenarios = { module.id }, amount = 0, total = 0, locked = chapter > 1 }
				end

				table.insert(menu.scenarios, module)
				local scenario = menu.scenarios[#menu.scenarios]

				scenario.stats = {
					numcompleted = tonumber(ffi.string(C.GetUserData(scenario.id .. "_times_finished"))) or 0,
					stars = tonumber(ffi.string(C.GetUserData(scenario.id .. "_best_rating"))) or 0,
					score = tonumber(ffi.string(C.GetUserData(scenario.id .. "_best_score"))) or 0,
					nextstarscore = C.GetScenarioScoreForNextStar(scenario.id),
				}

				scenario.ladder = {
					isvalid = false,
					isrequested = false,
					rankings = {},
					nexttime = 0,
				}
			end
		end
	end

	menu.scenariosByID = {}
	for _, scenario in ipairs(menu.scenarios) do
		menu.scenariosByID[scenario.id] = scenario
	end

	for i, chapter in ipairs(menu.chapters) do
		local unlockedstars = 0
		for _, scenarioid in ipairs(chapter.scenarios) do
			local scenario = menu.scenariosByID[scenarioid]
			if scenario.hasunlockconditions then
				chapter.amount = scenario.unlockprogress
				chapter.total = scenario.unlocktotal
			else
				unlockedstars = unlockedstars + scenario.stats.stars
			end
		end

		if i > 1 then
			for _, scenarioid in ipairs(menu.chapters[i - 1].scenarios) do
				local scenario = menu.scenariosByID[scenarioid]
				if scenario.hasunlockconditions then
					chapter.locked = scenario.stats.stars == 0
				end
			end
		end
		if not chapter.locked then
			menu.selectedchapter = i
		else
			-- found the first locked chapter, no need to process further
			break
		end
	end

	Helper.setTabScrollCallback(menu, menu.onTabScroll)
	registerForEvent("inputModeChanged", getElement("Scene.UIContract"), menu.onInputModeChanged)
	menu.hasInputModeChangedRegistered = true

	menu.displayMenu(true)
end

function menu.displayMenu()
	menu.createInfoFrame()
	menu.createInfo2Frame()
end

function menu.createEmptyFrame()
	Helper.clearFrame(menu, config.infoFrame2Layer)
	Helper.clearTableConnectionColumn(menu, 1)
	Helper.clearTableConnectionColumn(menu, 2)

	Helper.removeAllWidgetScripts(menu, config.infoFrameLayer)

	menu.infoFrame = Helper.createFrameHandle(menu, {
		layer = config.infoFrameLayer,
		width = Helper.viewWidth,
		height = Helper.viewHeight,
		x = 0,
		y = 0,
	})

	local ftable = menu.infoFrame:addTable(1, { tabOrder = 1, width = 100, y = 100 })

	local row = ftable:addRow(nil, {  })
	row[1]:createText("", { color = Color["text_hidden"] })

	menu.infoFrame:display()
end

function menu.createInfoFrame()
	if menu.starttime then
		-- we are starting a scenario, ignore calls to display this
		return
	end
	menu.createInfoFrameRunning = true
	-- remove old data
	Helper.removeAllWidgetScripts(menu, config.infoFrameLayer)

	menu.size = math.min(Helper.viewHeight, Helper.viewWidth)
	local backgroundfactor_x, backgroundfactor_y = 1, 1
	if Helper.viewWidth > Helper.viewHeight then
		backgroundfactor_x = 1.1 * Helper.viewHeight / (Helper.viewWidth * 9 / 16)
	else
		backgroundfactor_y = 1.2
	end

	menu.infoFrame = Helper.createFrameHandle(menu, {
		layer = config.infoFrameLayer,
		standardButtonX = (Helper.viewWidth - menu.size) / 2,
		standardButtonY = Helper.borderSize,
		width = Helper.viewWidth,
		height = Helper.viewHeight,
		x = 0,
		y = 0,
	}):setBackground2("solid", { width = menu.size + 2 * Helper.frameBorder, height = menu.size, color = Color["frame_background_black"] }):setBackground("gradient_alpha_03", { width = backgroundfactor_x * Helper.viewWidth, height = backgroundfactor_y * Helper.viewHeight, rotationStart = (Helper.viewWidth > Helper.viewHeight) and 90 or 0, color = Color["frame_background_black"] })

	if menu.selectedscenario then
		local showladder = C.IsOnlineEnabled()
		if showladder then
			local scenario = menu.scenariosByID[menu.selectedscenario]
			local curtime = getElapsedTime()
			if (not scenario.ladder.isvalid) and (scenario.ladder.nexttime < curtime) and OnlineHasSession() then
				scenario.ladder.nexttime = curtime + 10
				OnlineRequestScenarioRankings(menu.selectedscenario, menu.ladderDisplayMode)
				scenario.ladder.isrequested = true
			end
			-- see if we already have data for this scenario
			scenario.ladder.rankings = OnlineGetScenarioRankings(menu.selectedscenario)

			-- kuertee start:
			-- if next(scenario.ladder.rankings) then
			if scenario.ladder.rankings and next(scenario.ladder.rankings) then
			-- kuertee end

				scenario.ladder.isvalid = true
			end
		end

		local tablewidth = math.ceil(3 / 8 * menu.size) - 2 * Helper.borderSize
		local xoffset = (Helper.viewWidth - menu.size) / 2 + (menu.size - tablewidth)
		local yoffset = menu.titletable and (menu.titletable.properties.y + menu.titletable:getFullHeight() + Helper.scaleY(Helper.standardTextHeight)) or 0

		local desctable, descheight = menu.createDescTable(menu.infoFrame, tablewidth, xoffset, yoffset)
		yoffset = yoffset + descheight + Helper.borderSize
		local statstable = menu.createStatsTable(menu.infoFrame, tablewidth, xoffset, yoffset)
		local buttontable = menu.createButtonTable(menu.infoFrame, tablewidth, xoffset, yoffset)
		local laddertable
		if showladder then
			local maxVisibleHeight = buttontable.properties.y - (yoffset + menu.tileHeight) - Helper.borderSize
			laddertable = menu.createLadderTable(menu.infoFrame, tablewidth, xoffset, yoffset, maxVisibleHeight)
		end
	end

	menu.infoFrame:display()
end

function menu.refreshInfoFrame()
	if not menu.createInfoFrameRunning then
		menu.createInfoFrame()
	end
end

function menu.createInfo2Frame()
	menu.createInfo2FrameRunning = true
	-- remove old data
	Helper.removeAllWidgetScripts(menu, config.infoFrame2Layer)

	menu.size = math.min(Helper.viewHeight, Helper.viewWidth - 2 * (Helper.scaleX(config.tabScrollSpacing) + Helper.borderSize))

	menu.info2Frame = Helper.createFrameHandle(menu, {
		layer = config.infoFrame2Layer,
		standardButtonX = (Helper.viewWidth - menu.size) / 2,
		standardButtonY = Helper.borderSize,
		width = Helper.viewWidth,
		height = Helper.viewHeight,
		x = 0,
		y = 0,
	})

	menu.titletable = menu.createTitleTable(menu.info2Frame)
	local yoffset = menu.titletable.properties.y + menu.titletable:getFullHeight() + Helper.scaleY(Helper.standardTextHeight)
	menu.scenariotable, menu.setpiecetable = menu.createScenarioTable(menu.info2Frame, yoffset)

	menu.info2Frame:display()
end

function menu.refreshInfo2Frame()
	if not menu.createInfo2FrameRunning then
		menu.topRows["scenarioTable"] = menu.topRows["scenarioTable"] or GetTopRow(menu.scenariotable.id)
		menu.selectedRows["scenarioTable"] = menu.selectedRows["scenarioTable"] or Helper.currentTableRow[menu.scenariotable.id] or 1
		menu.selectedCols["scenarioTable"] = menu.selectedCols["scenarioTable"] or Helper.currentTableCol[menu.scenariotable.id]

		menu.createInfo2Frame()
	end
end

function menu.createTitleTable(frame)
	local tabScrollSpacing = Helper.scaleX(config.tabScrollSpacing)

	local numcols = 13
	local ftable = frame:addTable(numcols, { tabOrder = 3, width = menu.size + 2 * (tabScrollSpacing + Helper.borderSize), x = (Helper.viewWidth - menu.size) / 2 - tabScrollSpacing - Helper.borderSize, y = Helper.frameBorder })
	for i = 3, numcols + 1, 2 do
		ftable:setColWidth(i, Helper.standardTextHeight)
	end
	ftable:setColWidth(1, tabScrollSpacing, false)
	ftable:setColWidth(13, tabScrollSpacing, false)

	local row = ftable:addRow(nil, {  })
	row[2]:setColSpan(numcols - 2):createText(ReadText(1001, 12401), Helper.titleTextProperties)

	if not menu.enableSecretScenarios then
		ftable:addEmptyRow()

		local row = ftable:addRow(true, { fixed = true })
		local height = 2 * Helper.standardTextHeight
		local scaleSize = Helper.scaleX(2)
		for i, chapter in ipairs(menu.chapters) do
			if i > 1 then
				row[i * 2 - 1]:createIcon("widget_arrow_right_02", { height = height })
			end
			local button = row[i * 2]:createButton({ height = height, active = not chapter.locked, bgColor = (menu.selectedchapter == i) and Color["row_background_selected"] or Color["row_title_background"] }):setText(ReadText(1001, 12415) .. " " .. i, { halign = "center"})
			if (chapter.total > 0) and (chapter.amount > 0) then
				local width = math.max(1, math.floor(chapter.amount * (row[i * 2]:getWidth() - 2 * scaleSize) / chapter.total))
				button:setIcon("solid", { scaling = false, width = width + 3 * Helper.configButtonBorderSize, height = scaleSize + 2 * Helper.configButtonBorderSize, x = scaleSize - Helper.configButtonBorderSize, y = Helper.scaleY(height) - 2 * scaleSize - Helper.configButtonBorderSize })
			end
			if chapter.locked then
				button:setIcon2("menu_locked", { width = height, height = height })
				break
			end
			button.handlers.onClick = function () menu.selectedchapter = i; menu.refreshInfo2Frame() end

			if menu.selectedchapter == i then
				ftable:setSelectedCol(i * 2)
			end
		end

		if GetControllerInfo() ~= "mouseCursor" then
			row[1]:createText(ffi.string(C.GetMappedInputName("INPUT_ACTION_WIDGET_TABSCROLL_LEFT")), { fontsize = Helper.titleFontSize, halign = "right" })
			row[13]:createText(ffi.string(C.GetMappedInputName("INPUT_ACTION_WIDGET_TABSCROLL_RIGHT")), { fontsize = Helper.titleFontSize })
		end
	end

	ftable:addConnection(1, 1, true)
	return ftable
end

function menu.createDescTable(frame, tablewidth, xoffset, yoffset)
	local numcols = 1
	local height = math.min(2 * menu.tileHeight, Helper.viewHeight - yoffset - 2.5 * menu.tileHeight)
	local ftable = frame:addTable(numcols, { tabOrder = 4, width = tablewidth, x = xoffset, y = yoffset, highlightMode = "off", maxVisibleHeight = height })

	local row = ftable:addRow(nil, { fixed = true })
	row[1]:setColSpan(numcols):createText(ReadText(1001, 2404), Helper.subHeaderTextProperties)
	local titleHeight = ftable:getFullHeight()

	local connection = false
	local scenario = menu.scenariosByID[menu.selectedscenario]
	local hasscenariodescription = scenario.scenariodata.scenariodesc ~= ""

	local scenariodescriptiontext, headertext = {}, {}
	if hasscenariodescription then
		scenariodescriptiontext = GetTextLines(scenario.scenariodata.scenariodesc, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), tablewidth - 2 * Helper.scaleX(Helper.standardTextOffsetx))
		headertext = GetTextLines(ReadText(30600, 1201), Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), tablewidth - 2 * Helper.scaleX(Helper.standardTextOffsetx))
	end
	local descriptiontext = GetTextLines(scenario.description, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), tablewidth - 2 * Helper.scaleX(Helper.standardTextOffsetx))

	if #descriptiontext + (hasscenariodescription and (#scenariodescriptiontext + #headertext + 1) or 0) > math.min((ftable.properties.maxVisibleHeight - titleHeight) / (Helper.scaleY(Helper.standardTextHeight) + Helper.borderSize)) then
		-- scrollbar case
		descriptiontext = GetTextLines(scenario.description, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), tablewidth - 2 * Helper.scaleX(Helper.standardTextOffsetx) - Helper.scrollbarWidth)
		if hasscenariodescription then
			scenariodescriptiontext = GetTextLines(scenario.scenariodata.scenariodesc, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), tablewidth - 2 * Helper.scaleX(Helper.standardTextOffsetx) - Helper.scrollbarWidth)
			headertext = GetTextLines(ReadText(30600, 1201), Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), tablewidth - 2 * Helper.scaleX(Helper.standardTextOffsetx) - Helper.scrollbarWidth)
		end

		connection = true
	end

	if hasscenariodescription then
		for linenum, descline in ipairs(scenariodescriptiontext) do
			local row = ftable:addRow(true, {  })
			row[1]:createText(descline)
		end
		ftable:addEmptyRow()
		for linenum, descline in ipairs(headertext) do
			local row = ftable:addRow(true, {  })
			row[1]:createText(descline, { font = Helper.standardFontBold })
		end
	end
	for linenum, descline in ipairs(descriptiontext) do
		local row = ftable:addRow(true, {  })
		row[1]:createText(descline)
	end

	if connection then
		ftable:addConnection(1, 2, true)
	else
		Helper.clearTableConnectionColumn(menu, 2)
	end
	return ftable, height
end

function menu.createStatsTable(frame, tablewidth, xoffset, yoffset)
	local numcols = 2
	local ftable = frame:addTable(numcols, { tabOrder = 5, width = tablewidth, x = xoffset, y = yoffset, highlightMode = "off", maxVisibleHeight = menu.tileHeight })
	ftable:setColWidthPercent(1, 60)

	local row = ftable:addRow(nil, { fixed = true })
	row[1]:setColSpan(numcols):createText(ReadText(1001, 2500), Helper.subHeaderTextProperties)
	local titleHeight = ftable:getFullHeight()

	local scenario = menu.scenariosByID[menu.selectedscenario]
	local row = ftable:addRow(true, {  })
	row[1]:createText(ReadText(1001, 12408))
	row[2]:createText(ConvertIntegerString(scenario.stats.numcompleted, true, 0, true), { halign = "right" })

	local row = ftable:addRow(true, {  })
	row[1]:createText(ReadText(1001, 12409))
	row[2]:createText(ConvertIntegerString(scenario.stats.score, true, 0, true), { halign = "right" })

	local row = ftable:addRow(true, {  })
	row[1]:createText(ReadText(1001, 12410))
	local iscompleted = scenario.stats.stars == scenario.scenariodata.maxrating
	local ratingIcon = "\27[menu_rating_0" .. scenario.stats.stars .. "]"
	if scenario.stats.numcompleted == 0 then
		ratingIcon = "\27[menu_rating_unrated]"
	end
	row[2]:createText(ratingIcon, { fontsize = config.ratingFontSize, halign = "right", color = iscompleted and Color["scenario_completed"] or (scenario.stats.numcompleted == 0) and Color["text_inactive"] or nil })

	if scenario.stats.stars < scenario.scenariodata.maxrating then
		local row = ftable:addRow(true, {  })
		row[1]:createText(ReadText(1001, 12411))
		row[2]:createText(ConvertIntegerString(scenario.stats.nextstarscore, true, 0, true), { halign = "right" })
	end

	if scenario.scenariodata.scoredesc ~= "" then
		ftable:addEmptyRow()

		local curHeight = ftable:getFullHeight()

		local descriptiontext = GetTextLines(scenario.scenariodata.scoredesc, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), tablewidth - 2 * Helper.scaleX(Helper.standardTextOffsetx))
		if #descriptiontext > math.min((ftable.properties.maxVisibleHeight - curHeight) / (Helper.scaleY(Helper.standardTextHeight) + Helper.borderSize)) then
			-- scrollbar case
			descriptiontext = GetTextLines(scenario.scenariodata.scoredesc, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), tablewidth - 2 * Helper.scaleX(Helper.standardTextOffsetx) - Helper.scrollbarWidth)
		end
		for linenum, descline in ipairs(descriptiontext) do
			local row = ftable:addRow(true, {  })
			row[1]:setColSpan(numcols):createText(descline)
		end
	end

	if ftable:getFullHeight() > ftable.properties.maxVisibleHeight - titleHeight then
		ftable:addConnection(2, 2)
	end

	return ftable
end

function menu.createLadderTable(frame, tablewidth, xoffset, yoffset, maxVisibleHeight)
	local numcols = 4
	local ftable = frame:addTable(numcols, { tabOrder = 6, width = tablewidth, x = xoffset, y = yoffset + menu.tileHeight, highlightMode = "off", maxVisibleHeight = maxVisibleHeight })
	ftable:setColWidth(1, Helper.standardTextHeight)
	ftable:setColWidth(2, 0.15 * tablewidth - Helper.scaleY(Helper.standardTextHeight) - Helper.borderSize, false)
	ftable:setColWidthPercent(4, 20)

	local row = ftable:addRow(nil, { fixed = true })
	row[1]:setColSpan(numcols):createText(ReadText(1001, 12406), Helper.subHeaderTextProperties)

	local scenario = menu.scenariosByID[menu.selectedscenario]
	if OnlineHasSession() then
		if scenario.ladder.isvalid then
			local row = ftable:addRow(true, { fixed = true })
			row[1]:createCheckBox(menu.ladderDisplayMode == 2, { width = Helper.standardTextHeight, height = Helper.standardTextHeight })
			row[1].handlers.onClick = menu.checkboxUseLadderContacts
			row[2]:setColSpan(numcols - 1):createText(ReadText(1001, 12420))

			if #scenario.ladder.rankings > 0 then
				local hasscrollbar = math.floor((maxVisibleHeight - ftable:getFullHeight()) / (Helper.scaleY(Helper.standardTextHeight) + Helper.borderSize)) < #scenario.ladder.rankings

				local _, userid = OnlineGetUserName()
				for _, ranking in ipairs(scenario.ladder.rankings) do
					local row = ftable:addRow(hasscrollbar, {  })
					local namefont, otherfont = Helper.standardFont
					if not ranking.usestandardfont then
						namefont = Helper.fallbackFont
						ranking.username = ffi.string(C.ReplaceGlyphsWithAToZ(ranking.username))
					end
					if ranking.userid == userid then
						namefont = ranking.usestandardfont and Helper.standardFontBold or Helper.fallbackFontBold
						otherfont = Helper.standardFontBold
					end
					row[1]:setColSpan(2):createText(ranking.rank, { halign = "right", font = otherfont })
					row[3]:createText(ranking.username, { font = namefont })
					row[4]:createText(ConvertIntegerString(ranking.score, true, 0, true), { halign = "right", font = otherfont })
				end
			else
				local row = ftable:addRow(nil, {  })
				row[2]:setColSpan(numcols - 1):createText(ReadText(1001, 12421))
			end
		elseif scenario.ladder.isrequested then
			local row = ftable:addRow(nil, {  })
			row[1]:setColSpan(numcols):createText(menu.ladderPending)
		else
			local row = ftable:addRow(nil, {  })
			row[1]:setColSpan(numcols):createText(ReadText(1001, 12419), { wordwrap = true })
		end
	else
		local row = ftable:addRow(nil, {  })
		row[1]:setColSpan(numcols):createText(ReadText(1001, 12418), { wordwrap = true })
	end

	ftable:addConnection(3, 2)

	return ftable
end

function menu.ladderPending()
	local _, secondfraction = math.modf(getElapsedTime())
	local dots = "."
	if secondfraction > 0.6666 then
		dots = "..."
	elseif secondfraction > 0.3333 then
		dots = ".."
	end
	return ReadText(1001, 12417) .. dots
end

function menu.createButtonTable(frame, tablewidth, xoffset, yoffset)
	local numcols = 1
	local ftable = frame:addTable(numcols, { tabOrder = 7, width = tablewidth, x = xoffset, y = yoffset })

	local scenario = menu.scenariosByID[menu.selectedscenario]
	local row = ftable:addRow(true, { fixed = true })
	row[1]:createButton({ active = (not scenario.hasunlockconditions) or scenario.unlocked }):setText(scenario.scenariochapterfinale and ReadText(1001, 12414) or ReadText(1001, 12407), { halign = "center" })
	row[1].handlers.onClick = function () return menu.startScenario(scenario) end

	ftable.properties.y = yoffset + 2 * menu.tileHeight

	ftable:addConnection(4, 2)
	return ftable
end

function menu.createScenarioTable(frame, yoffset)
	local numcols = 5
	local tablewidth = math.floor(5 / 8 * menu.size)
	local ftable = frame:addTable(numcols, { tabOrder = 1, width = tablewidth, x = (Helper.viewWidth - menu.size) / 2, y = yoffset, highlightMode = "column" })
	local buttonwidth = math.min((tablewidth - 3 * Helper.scaleX(Helper.standardTextHeight) - 4 * Helper.borderSize) / 3)
	for i = 1, numcols, 2 do
		ftable:setColWidth(i, buttonwidth, false)
	end

	menu.skipread = true

	local iconAspectRatio = 16 / 9
	local iconheight = buttonwidth / iconAspectRatio

	menu.scenariosByCell = {}
	menu.setpiecescenario = nil

	local scenarioindex = 1
	local scenariorows = {}
	local maxnumlines = 0

	for _, scenarioid in ipairs(menu.chapters[menu.selectedchapter].scenarios) do
		local scenario = menu.scenariosByID[scenarioid]
		if scenario.scenariochapterfinale then
			menu.setpiecescenario = scenario
		else
			if scenarioindex % 3 == 1 then
				if maxnumlines > 0 then
					for i, entry in ipairs(scenariorows[#scenariorows]) do
						entry.boxheight = maxnumlines * Helper.scaleY(Helper.standardTextHeight) + 4 * Helper.borderSize
						entry.height = iconheight + Helper.configButtonBorderSize + entry.boxheight
						if entry.numlines < maxnumlines then
							for j = 1, maxnumlines - entry.numlines do
								entry.formattedtext = entry.formattedtext .. "\n"
							end
						end
					end
				end
				table.insert(scenariorows, {})
				maxnumlines = 0
			end

			local entry = { scenario = scenario }

			local isread = ffi.string(C.GetUserData(scenario.id .. "_ui_read")) == "true"
			if (not isread) and (scenario.stats.numcompleted > 0) then
				C.SetUserData(scenario.id .. "_ui_read", "true")
				isread = true
			end

			local text = scenario.name
			if scenario.stats.numcompleted == 0 then
				text = text .. "\n" .. ReadText(1001, 12402)
			end
			local lines = GetTextLines(text, Helper.standardFontBold, Helper.scaleFont(Helper.standardFontBold, Helper.standardFontSize), buttonwidth - 2 * (Helper.scaleY(Helper.standardTextHeight) + Helper.borderSize))
			entry.formattedtext = (not isread) and (ColorText["text_warning"] .. "\027[workshop_error]\027X") or ""
			for i, line in ipairs(lines) do
				if i > 1 then
					entry.formattedtext = entry.formattedtext .. "\n"
				end
				entry.formattedtext = entry.formattedtext .. line
			end
			entry.numlines = #lines
			maxnumlines = math.max(2, math.max(maxnumlines, entry.numlines))
			entry.firstline = lines[1]

			table.insert(scenariorows[#scenariorows], entry)
			scenarioindex = scenarioindex + 1
		end
	end
	if maxnumlines > 0 then
		for i, entry in ipairs(scenariorows[#scenariorows]) do
			entry.boxheight = maxnumlines * Helper.scaleY(Helper.standardTextHeight) + 4 * Helper.borderSize
			entry.height = iconheight + Helper.configButtonBorderSize + entry.boxheight
			if entry.numlines < maxnumlines then
				for j = 1, maxnumlines - entry.numlines do
					entry.formattedtext = entry.formattedtext .. "\n"
				end
			end
		end
	end

	local row
	for _, scenariorow in ipairs(scenariorows) do
		if row then
			ftable:addEmptyRow()
		end

		row = ftable:addRow(true, {  })

		for i, entry in ipairs(scenariorow) do
			local col = i * 2 - 1

			menu.scenariosByCell[row.index] = menu.scenariosByCell[row.index] or {}
			menu.scenariosByCell[row.index][col] = entry.scenario.id

			local iscompleted = entry.scenario.stats.stars == entry.scenario.scenariodata.maxrating

			row[col]:createButton({ scaling = false, height = entry.height, bgColor = iscompleted and Color["scenario_completed_border"] or nil })
			row[col]:setIcon(entry.scenario.image, { height = iconheight + Helper.configButtonBorderSize, width = buttonwidth })
			row[col]:setIcon2("solid", { height = entry.boxheight + Helper.configButtonBorderSize, width = buttonwidth, x = 0, y = iconheight, color = Color["scenario_button_background"] })

			row[col]:setText(entry.formattedtext, { halign = "center", x = -Helper.scaleY(Helper.standardTextHeight), y = -entry.height / 2 + entry.boxheight - Helper.scaleY(Helper.standardTextHeight) / 2 - Helper.borderSize, font = Helper.standardFontBold, fontsize = Helper.scaleFont(Helper.standardFontBold, Helper.standardFontSize), color = iscompleted and Color["scenario_completed"] or nil })
			local ratingIcon = "\27[menu_rating_0" .. entry.scenario.stats.stars .. "]"
			if entry.scenario.stats.numcompleted == 0 then
				ratingIcon = "\27[menu_rating_unrated]"
			end
			row[col]:setText2(ratingIcon, { y = -entry.height / 2 + entry.boxheight - Helper.scaleY(Helper.standardTextHeight), fontsize = Helper.scaleFont(Helper.standardFontBold, config.ratingFontSize), halign = "right", color = iscompleted and Color["scenario_completed"] or ((entry.scenario.stats.numcompleted == 0) and Color["text_inactive"] or nil) })

			local locrow = row.index
			row[col].handlers.onClick = function (_, input) return menu.buttonNodus(ftable, input, locrow, col) end
			row[col].handlers.onDoubleClick = function () menu.buttonNodusDblClick(entry.scenario.id) end
		end
	end

	if menu.selectedRows["scenarioTable"] then
		ftable:setTopRow(menu.topRows["scenarioTable"])
		ftable:setSelectedRow(menu.selectedRows["scenarioTable"])
		ftable:setSelectedCol(menu.selectedCols["scenarioTable"] or 0)
		menu.topRows["scenarioTable"] = nil
		menu.selectedRows["scenarioTable"] = nil
		menu.selectedCols["scenarioTable"] = nil
	end

	menu.tileHeight = math.ceil(iconheight + Helper.configButtonBorderSize + 2 * Helper.scaleY(Helper.standardTextHeight) + 4 * Helper.borderSize + Helper.scaleY(Helper.standardTextHeight) + Helper.borderSize)
	ftable:addConnection(2, 1)

	local setpiecetable
	if menu.setpiecescenario then
		setpiecetable = frame:addTable(1, { tabOrder = 2, width = tablewidth, x = (Helper.viewWidth - menu.size) / 2, y = yoffset, highlightMode = "column" })

		iconAspectRatio = 32 / 9

		local row = setpiecetable:addRow(true, {  })
		local iconheight = tablewidth / iconAspectRatio
		local boxheight = 2 * Helper.scaleY(Helper.titleHeight) + 4 * Helper.borderSize
		local height = iconheight + Helper.configButtonBorderSize + boxheight

		local iscompleted = menu.setpiecescenario.stats.stars == menu.setpiecescenario.scenariodata.maxrating

		row[1]:createButton({ scaling = false, height = height, bgColor = iscompleted and Color["scenario_completed_border"] or ((not menu.setpiecescenario.unlocked) and Color["scenario_button_inactive"] or nil) })
		local icon = menu.setpiecescenario.image
		if menu.setpiecescenario.unlocked then
			icon = icon .. "_uw"
		else
			icon = icon .. "_bw"
		end
		row[1]:setIcon(icon, { height = iconheight + Helper.configButtonBorderSize, width = tablewidth })
		row[1]:setIcon2("solid", { height = boxheight + Helper.configButtonBorderSize, width = tablewidth, x = 0, y = iconheight, color = Color["scenario_button_background"] })

		local isread = ffi.string(C.GetUserData(menu.setpiecescenario.id .. "_ui_read")) == "true"
		if (not isread) and (menu.setpiecescenario.stats.numcompleted > 0) then
			C.SetUserData(menu.setpiecescenario.id .. "_ui_read", "true")
			isread = true
		end
		local name = ((not isread) and (ColorText["text_warning"] .. "\027[workshop_error]\027X") or "") .. menu.setpiecescenario.name .. "\n"
		if not menu.setpiecescenario.unlocked then
			name = name .. ReadText(1001, 12403)
		elseif menu.setpiecescenario.stats.numcompleted == 0 then
			name = name .. ReadText(1001, 12402)
		end
		row[1]:setText(name, { halign = "center", y = -(iconheight - Helper.scaleY(Helper.titleHeight) - Helper.borderSize) / 2, font = Helper.standardFontBold, fontsize = Helper.scaleFont(Helper.standardFontBold, Helper.titleFontSize), color = iscompleted and Color["scenario_completed"] or ((not menu.setpiecescenario.unlocked) and Color["text_inactive"] or nil) })
		if not menu.setpiecescenario.unlocked then
			local text = "\27[menu_locked]"
			for _, entry in ipairs(menu.setpiecescenario.unmetuserdata) do
				text = text .. "\n" .. entry
			end
			local lines = GetTextLines(text, Helper.standardFontBoldOutlined, Helper.scaleFont(Helper.standardFontBoldOutlined, Helper.titleFontSize), tablewidth - 2 * Helper.scaleX(Helper.standardTextOffsetx))
			local formattedtext = ""
			for i, line in ipairs(lines) do
				if i > 1 then
					formattedtext = formattedtext .. "\n"
				end
				formattedtext = formattedtext .. line
			end

			row[1]:setText2(formattedtext, { halign = "center", font = Helper.standardFontBoldOutlined, fontsize = Helper.scaleFont(Helper.standardFontBoldOutlined, Helper.titleFontSize), color = Color["text_inactive"], y = (boxheight + (#lines / 2) * Helper.scaleY(Helper.titleHeight)) / 2 })
		else
			local ratingIcon = "\27[menu_rating_0" .. menu.setpiecescenario.stats.stars .. "]"
			if menu.setpiecescenario.stats.numcompleted == 0 then
				ratingIcon = "\27[menu_rating_unrated]"
			end
			row[1]:setText2(ratingIcon, { y = -(iconheight - 3 * Helper.borderSize) / 2, fontsize = Helper.scaleFont(Helper.standardFontBold, config.terminusRatingFontSize), halign = "right", color = iscompleted and Color["scenario_completed"] or ((menu.setpiecescenario.stats.numcompleted == 0) and Color["text_inactive"] or nil) })
		end
		row[1].handlers.onClick = function (_, input) return menu.buttonNodus(setpiecetable, input, row.index, 1) end
		row[1].handlers.onDoubleClick = function () menu.buttonNodusDblClick(menu.setpiecescenario.id) end

		local scenarioheight = ftable:getFullHeight()
		local setpieceheight = setpiecetable:getFullHeight()
		if ftable.properties.y + scenarioheight + Helper.scaleY(Helper.standardTextHeight) + 2 * Helper.borderSize + setpieceheight + Helper.frameBorder > menu.size then
			ftable.properties.maxVisibleHeight = menu.size - ftable.properties.y - Helper.scaleY(Helper.standardTextHeight) - setpieceheight - Helper.frameBorder
			setpiecetable.properties.y = ftable.properties.y + ftable:getVisibleHeight() + Helper.scaleY(Helper.standardTextHeight) + 2 * Helper.borderSize
		else
			if #menu.scenarios < 8 then
				setpiecetable.properties.y = ftable.properties.y + 3 * menu.tileHeight
			else
				setpiecetable.properties.y = ftable.properties.y + scenarioheight + Helper.scaleY(Helper.standardTextHeight) + 2 * Helper.borderSize
			end
		end

		setpiecetable:addConnection(3, 1)
	end

	return ftable, setpiecetable
end

function menu.startScenario(scenario)
	menu.starttime = getElapsedTime() + config.scenarioFadeOutTime
	menu.startscenario = scenario.id

	if scenario.custom and scenario.usetimelinesplayercharacter then
		local playermacros = {}
		local buf = ffi.new("CustomGameStartStringPropertyState[1]")
		_ = ffi.string(C.GetCustomGameStartStringProperty(scenario.id, "player", buf))
		if ffi.string(buf[0].state) == "standard" then
			local macros = {}
			for macro in string.gmatch(ffi.string(buf[0].options), "[%w_]+") do
				playermacros[macro] = true
			end
		end

		local playermacro = ffi.string(C.GetUserData("timelines_player_character_macro"))
		if playermacro ~= "" then
			if playermacros[playermacro] then
				C.SetCustomGameStartStringProperty(scenario.id, "player", playermacro)
				local name, isfemale = GetMacroData(playermacro, "name", "entityfemale")
				C.SetCustomGameStartStringProperty(scenario.id, "playername", name)
				C.SetCustomGameStartBoolProperty(scenario.id, "playerfemale", isfemale)
			else
				DebugError("Requested timelines player character macro '" .. tostring(playermacro) .. "' not found in timelines scenario gamestart options '" .. scenario.id .. "'!")
			end
		end
	end

	C.FadeScreen2(config.scenarioFadeOutTime, 0, config.scenarioFadeHoldDuration)
	C.EnableScenarioLoading(false, scenario.id)
	PlaySound("hub_matrix_transition")
	menu.createEmptyFrame()
end

-- update
menu.updateInterval = 0.1
function menu.onUpdate()
	if menu.infoFrame then
		menu.infoFrame:update()
	end
	if menu.info2Frame then
		menu.info2Frame:update()
	end

	if menu.refreshIF and (menu.refreshIF < getElapsedTime()) then
		menu.refreshIF = nil
		menu.refreshInfoFrame()
	end

	if menu.refreshIF2 and (menu.refreshIF2 < getElapsedTime()) then
		menu.refreshIF2 = nil
		menu.refreshInfo2Frame()
	end

	if menu.starttime and (menu.starttime < getElapsedTime()) then
		menu.starttime = nil
		NewGame(menu.startscenario)
	end
end

function menu.viewCreated(layer, ...)
	if layer == config.infoFrameLayer then
		menu.createInfoFrameRunning = false
	elseif layer == config.infoFrame2Layer then
		menu.createInfo2FrameRunning = false
	end
end

function menu.onColChanged(row, col, uitable)
	if (uitable == menu.scenariotable.id) or (menu.setpiecetable and (uitable == menu.setpiecetable.id)) then
		local newscenario
		if uitable == menu.scenariotable.id then
			local row = Helper.currentTableRow[uitable]
			newscenario = menu.scenariosByCell[row][col]
		elseif uitable == menu.setpiecetable.id then
			newscenario = menu.setpiecescenario.id
		end
		if newscenario ~= menu.selectedscenario then
			menu.selectedscenario = newscenario
			if uitable == menu.scenariotable.id then
				local isread = ffi.string(C.GetUserData(newscenario .. "_ui_read")) == "true"
				if not isread then
					C.SetUserData(newscenario .. "_ui_read", "true")
					if not menu.skipread then
						menu.refreshIF2 = getElapsedTime() + 0.1
					end
				end
			end
			menu.refreshIF = getElapsedTime()
		end
	end
end

function menu.onInteractiveElementChanged(element)
	if (element == menu.scenariotable.id) or (menu.setpiecetable and (element == menu.setpiecetable.id)) then
		local newscenario
		if element == menu.scenariotable.id then
			local row = Helper.currentTableRow[element]
			local col = Helper.currentTableCol[element]
			newscenario = menu.scenariosByCell[row][col]
		elseif element == menu.setpiecetable.id then
			newscenario = menu.setpiecescenario.id
		end
		if newscenario ~= menu.selectedscenario then
			menu.selectedscenario = newscenario
			local isread = ffi.string(C.GetUserData(newscenario .. "_ui_read")) == "true"
			if not isread then
				C.SetUserData(newscenario .. "_ui_read", "true")
				if not menu.skipread then
					menu.refreshIF2 = getElapsedTime()
				end
			end
			menu.skipread = nil
			menu.refreshIF = getElapsedTime()
		end
	end
end

function menu.onTabScroll(direction)
	if not menu.enableSecretScenarios then
		if direction == "right" then
			local oldchapter = menu.selectedchapter
			local newchapter = math.min(#menu.chapters, menu.selectedchapter + 1)
			if not menu.chapters[newchapter].locked then
				menu.selectedchapter = newchapter
			end
			if menu.selectedchapter ~= oldchapter then
				menu.refreshInfo2Frame()
			end
		elseif direction == "left" then
			local oldchapter = menu.selectedchapter
			local newchapter = math.max(1, menu.selectedchapter - 1)
			if not menu.chapters[newchapter].locked then
				menu.selectedchapter = newchapter
			end
			if menu.selectedchapter ~= oldchapter then
				menu.refreshInfo2Frame()
			end
		end
	end
end

function menu.onInputModeChanged(_, mode)
	menu.refreshInfo2Frame()
end

function menu.buttonNodus(ftable, input, row, col)
	if input ~= "mouse" then
		local scenario = menu.scenariosByID[menu.selectedscenario]
		if (not scenario.hasunlockconditions) or scenario.unlocked then
			menu.startScenario(scenario)
		end
	else
		SelectRow(ftable.id, row, nil, nil, nil, true)
		SelectColumn(ftable.id, col)
	end
end

function menu.buttonNodusDblClick(scenarioid)
	local scenario = menu.scenariosByID[scenarioid]
	if (not scenario.hasunlockconditions) or scenario.unlocked then
		menu.startScenario(scenario)
	end
end

function menu.checkboxUseLadderContacts(_, checked)
	if checked then
		menu.ladderDisplayMode = 2
	else
		menu.ladderDisplayMode = 0
	end
	menu.scenariosByID[menu.selectedscenario].ladder.nexttime = getElapsedTime() + 10
	OnlineRequestScenarioRankings(menu.selectedscenario, menu.ladderDisplayMode)
	menu.scenariosByID[menu.selectedscenario].ladder.isrequested = true
end

-- close menu handler
function menu.onCloseElement(dueToClose, layer)
	Helper.closeMenu(menu, dueToClose)
	menu.cleanup()
end

-- kuetee start:
menu.uix_callbackCount = 0
function menu.registerCallback(callbackName, callbackFunction, id)
    -- note 1: format is generally [function name]_[action]. e.g.: in kuertee_menu_transporter, "display_on_set_room_active" overrides the room's active property with the return of the callback.
    -- note 2: events have the word "_on_" followed by a PRESENT TENSE verb. e.g.: in kuertee_menu_transporter, "display_on_set_buttontable" is called after all of the rows of buttontable are set.
    -- note 3: new callbacks can be added or existing callbacks can be edited. but commit your additions/changes to the mod's GIT repository.
    -- note 4: search for the callback names to see where they are executed.
    -- note 5: if a callback requires a return value, return it in an object var. e.g. "display_on_set_room_active" requires a return of {active = true | false}.
    if menu.uix_callbacks [callbackName] == nil then
        menu.uix_callbacks [callbackName] = {}
    end
    if not menu.uix_callbacks[callbackName][id] then
        if not id then
            menu.uix_callbackCount = menu.uix_callbackCount + 1
            id = "_" .. tostring(menu.uix_callbackCount)
        end
        menu.uix_callbacks[callbackName][id] = callbackFunction
        if Helper.isDebugCallbacks then
            Helper.debugText_forced(menu.name .. " uix registerCallback: menu.uix_callbacks[" .. tostring(callbackName) .. "][" .. tostring(id) .. "]: " .. tostring(menu.uix_callbacks[callbackName][id]))
        end
    else
        Helper.debugText_forced(menu.name .. " uix registerCallback: callback at " .. callbackName .. " with id " .. tostring(id) .. " was already previously registered")
    end
end

menu.uix_isDeregisterQueued = nil
menu.uix_callbacks_toDeregister = {}
function menu.deregisterCallback(callbackName, callbackFunction, id)
    if not menu.uix_callbacks_toDeregister[callbackName] then
        menu.uix_callbacks_toDeregister[callbackName] = {}
    end
    if id then
        table.insert(menu.uix_callbacks_toDeregister[callbackName], id)
    else
        if menu.uix_callbacks[callbackName] then
            for id, func in pairs(menu.uix_callbacks[callbackName]) do
                if func == callbackFunction then
                    table.insert(menu.uix_callbacks_toDeregister[callbackName], id)
                end
            end
        end
    end
    if not menu.uix_isDeregisterQueued then
        menu.uix_isDeregisterQueued = true
        Helper.addDelayedOneTimeCallbackOnUpdate(menu.deregisterCallbacksNow, true, getElapsedTime() + 1)
    end
end

function menu.deregisterCallbacksNow()
    menu.uix_isDeregisterQueued = nil
    for callbackName, ids in pairs(menu.uix_callbacks_toDeregister) do
        if menu.uix_callbacks[callbackName] then
            for _, id in ipairs(ids) do
                if menu.uix_callbacks[callbackName][id] then
                    if Helper.isDebugCallbacks then
                        Helper.debugText_forced(menu.name .. " uix deregisterCallbacksNow (pre): menu.uix_callbacks[" .. tostring(callbackName) .. "][" .. tostring(id) .. "]: " .. tostring(menu.uix_callbacks[callbackName][id]))
                    end
                    menu.uix_callbacks[callbackName][id] = nil
                    if Helper.isDebugCallbacks then
                        Helper.debugText_forced(menu.name .. " uix deregisterCallbacksNow (post): menu.uix_callbacks[" .. tostring(callbackName) .. "][" .. tostring(id) .. "]: " .. tostring(menu.uix_callbacks[callbackName][id]))
                    end
                else
                    Helper.debugText_forced(menu.name .. " uix deregisterCallbacksNow: callback at " .. callbackName .. " with id " .. tostring(id) .. " doesn't exist")
                end
            end
        end
    end
    menu.uix_callbacks_toDeregister = {}
end

menu.uix_isUpdateQueued = nil
menu.uix_callbacks_toUpdate = {}
function menu.updateCallback(callbackName, id, callbackFunction)
    if not menu.uix_callbacks_toUpdate[callbackName] then
        menu.uix_callbacks_toUpdate[callbackName] = {}
    end
    if id then
        table.insert(menu.uix_callbacks_toUpdate[callbackName], {id = id, callbackFunction = callbackFunction})
    end
    if not menu.uix_isUpdateQueued then
        menu.uix_isUpdateQueued = true
        Helper.addDelayedOneTimeCallbackOnUpdate(menu.updateCallbacksNow, true, getElapsedTime() + 1)
    end
end

function menu.updateCallbacksNow()
    menu.uix_isUpdateQueued = nil
    for callbackName, updateDatas in pairs(menu.uix_callbacks_toUpdate) do
        if menu.uix_callbacks[callbackName] then
            for _, updateData in ipairs(updateDatas) do
                if menu.uix_callbacks[callbackName][updateData.id] then
                    if Helper.isDebugCallbacks then
                        Helper.debugText_forced(menu.name .. " uix updateCallbacksNow (pre): menu.uix_callbacks[" .. tostring(callbackName) .. "][" .. tostring(updateData.id) .. "]: " .. tostring(menu.uix_callbacks[callbackName][updateData.id]))
                    end
                    menu.uix_callbacks[callbackName][updateData.id] = updateData.callbackFunction
                    if Helper.isDebugCallbacks then
                        Helper.debugText_forced(menu.name .. " uix updateCallbacksNow (post): menu.uix_callbacks[" .. tostring(callbackName) .. "][" .. tostring(updateData.id) .. "]: " .. tostring(menu.uix_callbacks[callbackName][updateData.id]))
                    end
                else
                    Helper.debugText_forced(menu.name .. " uix updateCallbacksNow: callback at " .. callbackName .. " with id " .. tostring(id) .. " doesn't exist")
                end
            end
        end
    end
end
-- kuerte end

init()
