-- ffi setup
local ffi = require("ffi")
local C = ffi.C
ffi.cdef[[
	typedef struct {
		const char* name;
		const char* desc;
		const char* value;
		float score;
		float maxscore;
		bool hasscore;
	} ScenarioStat;
	
	void EnableScenarioLoading(bool reverse, const char* gamestartid);
	void FadeScreen2(float fadeouttime, float fadeintime, float holdtime);
	const char* GetGameStartName();
	uint32_t GetNumScenarioStats(void);
	const char* GetUserData(const char* name);
	float GetScenarioScoreForNextStar(const char* scenarioid);
	float GetScenarioScoreForRating(const char* scenarioid, uint32_t rating);
	uint32_t GetScenarioStats(ScenarioStat* result, uint32_t resultlen);
	bool IsGameModified(void);
	bool IsOnlineEnabled(void);
	const char* ReplaceGlyphsWithAToZ(const char* inputtext);
]]

local menu = {
	name = "ScenarioDebriefingMenu",
	ladderDisplayMode = 0,
}

local config = {
	infoFrameLayer = 5,
	infoFrame2Layer = 4,

	scenarioFadeOutTime = 1,
	scenarioFadeHoldDuration = 0.1,

	ratingFontSize = 22,
	currentRatingFontSize = 36,
}

-- kuertee start:
menu.uix_callbacks = {}
-- kuertee end

local function init()
	Menus = Menus or { }
	table.insert(Menus, menu)
	if Helper then
		Helper.registerMenu(menu)
	end

	menu.isStartmenu = C.IsStartmenu()

	RegisterEvent("timelinesScoreUploaded", menu.onTimelinesScoreUploaded)
	RegisterEvent("timelinesRankingsReceived", menu.onTimelinesRankingsReceived)

	-- kuertee start:
	menu.init_kuertee()
	-- kuertee end
end

-- kuertee start:
function menu.init_kuertee ()
end
-- kuertee end

function menu.onTimelinesScoreUploaded()
	if menu.shown then
		OnlineRequestScenarioRankings(menu.scenarioid, menu.ladderDisplayMode)
	end
end

function menu.onTimelinesRankingsReceived(_, success)
	if menu.shown then
		menu.scenario.ladder.isrequested = false
		menu.scenario.ladder.isvalid = success
		if success then
			menu.scenario.ladder.rankings = OnlineGetScenarioRankings(menu.scenarioid)
		end
		menu.refreshInfoFrame()
	end
end

function menu.cleanup()
	if menu.paused then
		Unpause()
		menu.paused = nil
	end

	menu.scenario = nil
end

function menu.onShowMenu()
	if not menu.isStartmenu then
		menu.paused = true
		Pause()
	end

	menu.scenarioid = ffi.string(C.GetGameStartName())

	local gamemodules = GetRegisteredModules()
	for _, module in ipairs(gamemodules) do
		if module.id == menu.scenarioid then
			menu.scenario = module

			menu.scenario.stats = {
				currentduration = tonumber(ffi.string(C.GetUserData(menu.scenarioid .. "_last_duration"))) or 0,
				numcompleted = tonumber(ffi.string(C.GetUserData(menu.scenarioid .. "_times_finished"))) or 0,
				stars = tonumber(ffi.string(C.GetUserData(menu.scenarioid .. "_best_rating"))) or 0,
				score = tonumber(ffi.string(C.GetUserData(menu.scenarioid .. "_best_score"))) or 0,
				currentstars = tonumber(ffi.string(C.GetUserData(menu.scenarioid .. "_last_rating"))) or 0,
				currentscore = tonumber(ffi.string(C.GetUserData(menu.scenarioid .. "_last_score"))) or 0,
				nextstarscore = C.GetScenarioScoreForNextStar(menu.scenarioid),
			}

			menu.scenario.ladder = {
				isvalid = false,
				isrequested = false,
				rankings = {},
			}

			break
		end
	end

	menu.scenariostats = {}
	local n = C.GetNumScenarioStats()
	if n > 0 then
		-- if the scenario ended, pause until the module is exited
		Pause(nil, true)

		local buf = ffi.new("ScenarioStat[?]", n)
		n = C.GetScenarioStats(buf, n)
		for i = 0, n - 1 do
			table.insert(menu.scenariostats, {
				name = ffi.string(buf[i].name),
				desc = ffi.string(buf[i].desc),
				value = ffi.string(buf[i].value),
				score = buf[i].score,
				maxscore = buf[i].maxscore,
				hasscore = buf[i].hasscore,
			})
		end
	end

	if menu.scenario then
		if n > 0 and OnlineHasSession() then
			local result = OnlineUploadScenarioStats(menu.scenarioid)
			if result ~= "success" and result ~= "modified" then
				DebugError("Unable to upload stats to leaderboards")
			end
			menu.scenario.ladder.isrequested = true
		end
		-- see if we already have data for this scenario
		menu.scenario.ladder.rankings = OnlineGetScenarioRankings(menu.scenarioid)

		-- kuertee start:
		-- if next(menu.scenario.ladder.rankings) then
		if menu.scenario.ladder.rankings and next(menu.scenario.ladder.rankings) then
		-- kuertee end
			menu.scenario.ladder.isvalid = true
		end

		menu.displayMenu(true)
	else
		DebugError("Could not find gamestart with id '" .. menu.scenarioid .. "' in order to display scenario debriefing menu.")
	end
end

function menu.displayMenu()
	menu.createInfoFrame()
	menu.createInfo2Frame()
end

function menu.createEmptyFrame()
	Helper.clearFrame(menu, config.infoFrame2Layer)

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
	}):setBackground2("solid", { width = menu.size + 2 * Helper.frameBorder, height = menu.size, color = Color["frame_background_black"] }):setBackground("gradient_alpha_03", { width = backgroundfactor_x * Helper.viewWidth, height = backgroundfactor_y * Helper.viewHeight, rotationStart = (Helper.viewWidth > Helper.viewHeight) and 90 or 0 })
	
	menu.titletable = menu.createTitleTable(menu.infoFrame)
	local tablewidth = math.ceil(3 / 8 * menu.size) - 2 * Helper.borderSize
	menu.tileHeight = math.floor(5 / 8 * menu.size) * 9 / 16 / 2
	local xoffset = (Helper.viewWidth - menu.size) / 2 + (menu.size - tablewidth)
	local yoffset = menu.titletable.properties.y + menu.titletable:getFullHeight() + Helper.scaleY(Helper.standardTextHeight)

	local showladder = C.IsOnlineEnabled()

	local desctable, descheight = menu.createDescTable(menu.infoFrame, tablewidth, xoffset, yoffset)
	yoffset = yoffset + descheight + Helper.borderSize
	local statstable = menu.createStatsTable(menu.infoFrame, tablewidth, xoffset, yoffset)
	local buttontable = menu.createButtonTable(menu.infoFrame, tablewidth, xoffset, yoffset)
	local laddertable
	if showladder then
		local maxVisibleHeight = buttontable.properties.y - (yoffset + menu.tileHeight) - Helper.borderSize
		laddertable = menu.createLadderTable(menu.infoFrame, tablewidth, xoffset, yoffset, maxVisibleHeight)
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

	menu.size = math.min(Helper.viewHeight, Helper.viewWidth)

	menu.info2Frame = Helper.createFrameHandle(menu, {
		layer = config.infoFrame2Layer,
		standardButtons = {},
		width = Helper.viewWidth,
		height = Helper.viewHeight,
		x = 0,
		y = 0,
	})

	local yoffset = menu.titletable.properties.y + menu.titletable:getFullHeight() + Helper.scaleY(Helper.standardTextHeight)
	menu.scenariotable = menu.createScenarioTable(menu.info2Frame, yoffset)

	menu.scenariotable:addConnection(1, 1, true)

	menu.info2Frame:display()
end

function menu.refreshInfo2Frame()
	if not menu.createInfo2FrameRunning then
		menu.createInfo2Frame()
	end
end

function menu.createTitleTable(frame)
	local numcols = 11
	local ftable = frame:addTable(numcols, { tabOrder = 3, width = menu.size, x = (Helper.viewWidth - menu.size) / 2, y = Helper.frameBorder })
	for i = 2, numcols, 2 do
		ftable:setColWidth(i, Helper.standardTextHeight)
	end

	local row = ftable:addRow(nil, {  })
	row[1]:setColSpan(numcols):createText((menu.scenario.scenariochapterfinale and ReadText(1001, 12504) or ReadText(1001, 12501)) .. " - " .. ReadText(1001, 12415) .. " " .. menu.scenario.scenariodata.chapter .. " - " .. menu.scenario.name, Helper.titleTextProperties)

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
	local hasscenariodescription = menu.scenario.scenariodata.scenariodesc ~= ""

	local scenariodescriptiontext, headertext = {}, {}
	if hasscenariodescription then
		scenariodescriptiontext = GetTextLines(menu.scenario.scenariodata.scenariodesc, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), tablewidth - 2 * Helper.scaleX(Helper.standardTextOffsetx))
		headertext = GetTextLines(ReadText(30600, 1201), Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), tablewidth - 2 * Helper.scaleX(Helper.standardTextOffsetx))
	end
	local descriptiontext = GetTextLines(menu.scenario.description, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), tablewidth - 2 * Helper.scaleX(Helper.standardTextOffsetx))

	if #descriptiontext + (hasscenariodescription and (#scenariodescriptiontext + #headertext + 1) or 0) > math.min((ftable.properties.maxVisibleHeight - titleHeight) / (Helper.scaleY(Helper.standardTextHeight) + Helper.borderSize)) then
		-- scrollbar case
		descriptiontext = GetTextLines(menu.scenario.description, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), tablewidth - 2 * Helper.scaleX(Helper.standardTextOffsetx) - Helper.scrollbarWidth)
		if hasscenariodescription then
			scenariodescriptiontext = GetTextLines(menu.scenario.scenariodata.scenariodesc, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), tablewidth - 2 * Helper.scaleX(Helper.standardTextOffsetx) - Helper.scrollbarWidth)
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

	local row = ftable:addRow(true, {  })
	row[1]:createText(ReadText(1001, 12416))
	row[2]:createText(ConvertTimeString(menu.scenario.stats.currentduration, ReadText(1001, 209)), { halign = "right" })

	local row = ftable:addRow(true, {  })
	row[1]:createText(ReadText(1001, 12408))
	row[2]:createText(ConvertIntegerString(menu.scenario.stats.numcompleted, true, 0, true), { halign = "right" })

	local row = ftable:addRow(true, {  })
	row[1]:createText(ReadText(1001, 12409))
	row[2]:createText(ConvertIntegerString(menu.scenario.stats.score, true, 0, true), { halign = "right" })

	local row = ftable:addRow(true, {  })
	row[1]:createText(ReadText(1001, 12410))
	local iscompleted = menu.scenario.stats.stars == menu.scenario.scenariodata.maxrating
	local ratingIcon = "\27[menu_rating_0" .. menu.scenario.stats.stars .. "]"
	if menu.scenario.stats.numcompleted == 0 then
		ratingIcon = "\27[menu_rating_unrated]"
	end
	row[2]:createText(ratingIcon, { fontsize = config.ratingFontSize, halign = "right", color = iscompleted and Color["scenario_completed"] or (menu.scenario.stats.numcompleted == 0) and Color["text_inactive"] or nil })

	if menu.scenario.stats.stars < menu.scenario.scenariodata.maxrating then
		local row = ftable:addRow(true, {  })
		row[1]:createText(ReadText(1001, 12411))
		row[2]:createText(ConvertIntegerString(menu.scenario.stats.nextstarscore, true, 0, true), { halign = "right" })
	end

	if menu.scenario.scenariodata.scoredesc ~= "" then
		ftable:addEmptyRow()

		local curHeight = ftable:getFullHeight()

		local descriptiontext = GetTextLines(menu.scenario.scenariodata.scoredesc, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), tablewidth - 2 * Helper.scaleX(Helper.standardTextOffsetx))
		if #descriptiontext > math.min((ftable.properties.maxVisibleHeight - curHeight) / (Helper.scaleY(Helper.standardTextHeight) + Helper.borderSize)) then
			-- scrollbar case
			descriptiontext = GetTextLines(menu.scenario.scenariodata.scoredesc, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), tablewidth - 2 * Helper.scaleX(Helper.standardTextOffsetx) - Helper.scrollbarWidth)
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
	local titleHeight = ftable:getFullHeight()

	if OnlineHasSession() then
		if menu.scenario.ladder.isvalid then
			local row = ftable:addRow(true, { fixed = true })
			row[1]:createCheckBox(menu.ladderDisplayMode == 2, { width = Helper.standardTextHeight, height = Helper.standardTextHeight })
			row[1].handlers.onClick = menu.checkboxUseLadderContacts
			row[2]:setColSpan(numcols - 1):createText(ReadText(1001, 12420))
			
			if #menu.scenario.ladder.rankings > 0 then
				local hasscrollbar = math.floor((maxVisibleHeight - ftable:getFullHeight()) / (Helper.scaleY(Helper.standardTextHeight) + Helper.borderSize)) < #menu.scenario.ladder.rankings

				local _, userid = OnlineGetUserName()
				for _, ranking in ipairs(menu.scenario.ladder.rankings) do
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
		elseif menu.scenario.ladder.isrequested then
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

	return ftable, titleHeight
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
	local numcols = 2
	local ftable = frame:addTable(numcols, { tabOrder = 7, width = tablewidth, x = xoffset, y = yoffset, defaultInteractiveObject = true })

	if C.IsGameModified() then
		local row = ftable:addRow(nil, { fixed = true })
		row[1]:setColSpan(numcols):createText(ReadText(1001, 12514), { wordwrap = true, color = Color["text_warning"] })
	elseif #menu.scenariostats > 0 then
		local row = ftable:addRow(nil, { fixed = true })
		row[1]:setColSpan(numcols):createText(menu.scenario.scenariochapterfinale and ReadText(1001, 12511) or ReadText(1001, 12510), { wordwrap = true })
	else
		ftable:addEmptyRow()
	end

	local row = ftable:addRow(true, { fixed = true })
	row[1]:createButton({  }):setText(menu.scenario.scenariochapterfinale and ReadText(1001, 12516) or ReadText(1001, 12515), { halign = "center" })
	row[1].handlers.onClick = function () menu.startScenario(menu.scenario) end
	row[2]:createButton({  }):setText(ReadText(1001, 12503), { halign = "center" })
	row[2].handlers.onClick = function () menu.returnToHub("x4ep1_gamestart_hub") end

	if #menu.scenariostats == 0 then
		local row = ftable:addRow(true, { fixed = true })
		row[1]:setColSpan(2):createButton({  }):setText(menu.scenario.scenariochapterfinale and ReadText(1001, 12518) or ReadText(1001, 12517), { halign = "center" })
		row[1].handlers.onClick = function () return menu.onCloseElement("close") end

		ftable:setSelectedRow(row.index)
	end

	ftable.properties.y = yoffset + 2 * menu.tileHeight
	
	ftable:addConnection(4, 2)
	return ftable
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

function menu.returnToHub(gamestartid)
	menu.starttime = getElapsedTime() + config.scenarioFadeOutTime
	menu.startscenario = gamestartid
	C.FadeScreen2(config.scenarioFadeOutTime, 0, config.scenarioFadeHoldDuration)
	C.EnableScenarioLoading(true, gamestartid)
	PlaySound("hub_matrix_transition")
	menu.createEmptyFrame()
end

function menu.createScenarioTable(frame, yoffset)
	local numcols = 4
	local tablewidth = math.floor(5 / 8 * menu.size)
	local ftable = frame:addTable(numcols, { tabOrder = 2, width = tablewidth, x = (Helper.viewWidth - menu.size) / 2, y = yoffset, highlightMode = "off" })
	ftable:setColWidthPercent(2, 20)
	ftable:setColWidthPercent(3, 15)
	ftable:setColWidth(4, 1.25 * Helper.standardTextHeight)

	local row = ftable:addRow(nil, { fixed = true })
	row[1]:setColSpan(numcols):createIcon(menu.scenario.image, { width = tablewidth, height = tablewidth * 9 / 16, scaling = false })

	local row = ftable:addRow(nil, { fixed = true })
	row[1]:setColSpan(2):setBackgroundColSpan(numcols):createText(menu.scenario.scenariochapterfinale and ReadText(1001, 12507) or ReadText(1001, 12506), Helper.subHeaderTextProperties)
	row[3]:createText(ReadText(1001, 12519), Helper.subHeaderTextProperties)
	row[3].properties.halign = "right"
	row[3].properties.x = 0
	row[4]:createText(" ", Helper.subHeaderTextProperties)

	local barheight = Helper.standardTextHeight * 3 / 4

	if #menu.scenariostats > 0 then
		local maxratingscore = C.GetScenarioScoreForRating(menu.scenario.id, menu.scenario.scenariodata.maxrating)
		for i, rating in ipairs(menu.scenariostats) do
			local row = ftable:addRow(true, {  })
			if rating.hasscore then
				row[1]:createText(rating.name)
				row[2]:createText(rating.value, { halign = "right", x = 0 })

				local row = ftable:addRow(nil, {  })
				local start = math.max(0, rating.score)
				local current = start
				local max = (rating.maxscore > 0) and rating.maxscore or maxratingscore
				if (rating.maxscore > 0) and (rating.score > rating.maxscore) then
					start = max
				end
				row[1]:setColSpan(2):createStatusBar({ current = current, start = start, max = max, cellBGColor = Color["row_background_unselectable"], valueColor = Color["statusbar_value_white"], posChangeColor = Color["statusbar_value_orange"], markerColor = Color["statusbar_marker_hidden"], height = barheight })
				row[3]:setBackgroundColSpan(2):createText(ConvertIntegerString(rating.score, true, 0, true), { halign = "right", height = barheight, mouseOverText = rating.desc, x = 0 })
				if rating.desc ~= "" then
					row[4]:createText("\27[tut_info]", { height = barheight, mouseOverText = rating.desc, x = 0 })
				end
			else
				row[1]:setColSpan(3):createText(rating.name)
				if rating.desc ~= "" then
					row[4]:createText("\27[tut_info]", { height = barheight, mouseOverText = rating.desc, x = 0 })
				end
			end

			ftable:addEmptyRow()
		end

		local row = ftable:addRow(true, {  })
		row[1]:setColSpan(2):createText(ReadText(1001, 12508))
		row[3]:createText(ConvertIntegerString(menu.scenario.stats.currentscore, true, 0, true), { halign = "right", x = 0 })

		local iscompleted = menu.scenario.stats.currentstars == menu.scenario.scenariodata.maxrating
		local row = ftable:addRow(true, {  })
		local ratingIcon = "\27[menu_rating_0" .. menu.scenario.stats.currentstars .. "]"
		if menu.scenario.stats.numcompleted == 0 then
			ratingIcon = "\27[menu_rating_unrated]"
		end
		row[1]:setColSpan(numcols):createText(ratingIcon, { fontsize = config.currentRatingFontSize, halign = "center", color = iscompleted and Color["scenario_completed"] or (menu.scenario.stats.numcompleted == 0) and Color["text_inactive"] or nil })

		local row = ftable:addRow(true, {  })
		row[1]:setColSpan(numcols):createText(ReadText(1001, 12509), { halign = "center" })
	else
		local row = ftable:addRow(nil, {  })
		row[1]:setColSpan(3):createText(menu.scenario.scenariochapterfinale and ReadText(1001, 12513) or ReadText(1001, 12512))
	end

	return ftable
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

	if menu.starttime and (menu.starttime < getElapsedTime()) then
		menu.starttime = nil
		NewGame(menu.startscenario)
		menu.cleanup()
	end
end

function menu.viewCreated(layer, ...)
	if layer == config.infoFrameLayer then
		menu.createInfoFrameRunning = false
	elseif layer == config.infoFrame2Layer then
		menu.createInfo2FrameRunning = false
	end
end

function menu.checkboxUseLadderContacts(_, checked)
	if checked then
		menu.ladderDisplayMode = 2
	else
		menu.ladderDisplayMode = 0
	end
	menu.scenario.ladder.nexttime = getElapsedTime() + 10
	OnlineRequestScenarioRankings(menu.scenario.id, menu.ladderDisplayMode)
	menu.scenario.ladder.isrequested = true
end

-- close menu handler
function menu.onCloseElement(dueToClose, layer)
	if dueToClose == "minimize" then
		if not menu.minimized then
			Helper.minimizeMenu(menu, menu.scenario.scenariochapterfinale and ReadText(1001, 12504) or ReadText(1001, 12501))
		else
			Helper.restoreMenu(menu)
		end
	else
		Helper.closeMenu(menu, dueToClose)
		menu.cleanup()
	end
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
