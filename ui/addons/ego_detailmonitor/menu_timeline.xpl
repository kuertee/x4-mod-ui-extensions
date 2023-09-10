-- param == { 0, 0 }

-- ffi setup
local ffi = require("ffi")
local C = ffi.C
ffi.cdef[[
	typedef struct {
		const char* id;
		const char* name;
		const char* description;
		const char* image;
		const char* video;
		const char* voice;
		float date;
		uint32_t group;
	} TimelineInfo;
	void ClearRendertarget(const char* rendertarget);
	uint32_t GetNumTimeline(void);
	UniverseID GetPlayerComputerID(void);
	uint32_t GetTimeline(TimelineInfo* result, uint32_t resultlen);
	bool IsKnownItemRead(const char* libraryid, const char* itemid);
	void ReadKnownItem(const char* libraryid, const char* itemid, bool read);
	void StartVoiceSequence2(const char* sequenceid, UniverseID entityid, const char* gamestartid);
	void StopVoiceSequence(void);
]]

local menu = {
	name = "TimelineMenu",
	dateFormat = "nt",
	encyclopediaMode = "timeline",
}

local config = {
	leftBar = {
		[1] = { name = ReadText(1001, 2400),	icon = "tlt_encyclopedia",	mode = "encyclopedia" },
		[2] = { name = ReadText(1001, 8201),	icon = "ency_timeline_01",	mode = "timeline" },
		[3] = { name = ReadText(1001, 3700),	icon = "ency_ship_comparison_01",	mode = "shipcomparison" },
	},
	dateFormats = {
		{ id = "nt", text = ReadText(1001, 8203), mouseovertext = ReadText(1001, 8208), icon = "", displayremoveoption = false },
		{ id = "zt", text = ReadText(1001, 8205), mouseovertext = ReadText(1001, 8210), icon = "", displayremoveoption = false },
		{ id = "ad", text = ReadText(1001, 8204), mouseovertext = ReadText(1001, 8209), icon = "", displayremoveoption = false },
		{ id = "he", text = ReadText(1001, 8207), mouseovertext = ReadText(1001, 8211), icon = "", displayremoveoption = false },
	},
	gapHeight = Helper.standardTextHeight * 1.5,
	minDescriptionRows = 4,
}

local function init()
	Menus = Menus or { }
	table.insert(Menus, menu)
	if Helper then
		Helper.registerMenu(menu)
	end

	registerForEvent("cutsceneStopped", getElement("Scene.UIContract"), menu.onCutsceneStopped)
end

function menu.cleanupHelper()
	HideAllShapes()
	if menu.cutsceneid then
		StopCutscene(menu.cutsceneid)
		menu.cutsceneid = nil
	end
	if menu.cutscenedesc then
		ReleaseCutsceneDescriptor(menu.cutscenedesc)
		menu.cutscenedesc = nil
	end
	-- C.StopVoiceSequence()
end

function menu.cleanup()
	unregisterForEvent("inputModeChanged", getElement("Scene.UIContract"), menu.onInputModeChanged)

	menu.cleanupHelper()

	menu.infoFrame = nil
	menu.toplevel = nil
	menu.sidebar = nil
	menu.timelineTable = nil
	menu.rendertarget = nil
	menu.descriptionTable = nil
	menu.encyclopediaMode = "timeline"

	menu.topLevelOffsetY = nil
	menu.activatecutscene = nil
	menu.hasclearedrendertarget = nil
	menu.timeline = {}
end

-- widget scripts

function menu.buttonToggleEncyclopediaMode(mode)
	if mode == "timeline" then
		AddUITriggeredEvent(menu.name, mode, menu.encyclopediaMode == mode and "off" or "on")
		if menu.encyclopediaMode then
			PlaySound("ui_negative_back")
			menu.encyclopediaMode = nil
			menu.cleanupHelper()
		else
			menu.setdefaulttable = true
			PlaySound("ui_positive_select")
			menu.encyclopediaMode = mode
		end
		menu.refresh = true
	elseif mode == "encyclopedia" then
		Helper.closeMenuAndOpenNewMenu(menu, "EncyclopediaMenu", { 0, 0 }, true)
		menu.cleanup()
	elseif mode == "shipcomparison" then
		Helper.closeMenuAndOpenNewMenu(menu, "ShipComparisonMenu", { 0, 0 }, true)
		menu.cleanup()
	end
end

function menu.deactivateEncyclopediaMode()
	PlaySound("ui_negative_back")
	menu.encyclopediaMode = nil
	menu.cleanupHelper()
	SelectRow(menu.sidebar, 2)
	menu.refresh = true
end

function menu.dropdownDate(_, newid)
	if newid ~= menu.dateFormat then
		menu.dateFormat = newid
		menu.refresh = true
	end
end

-- Menu member functions

function menu.onShowMenu()
	-- Init
	Helper.setTabScrollCallback(menu, menu.onTabScroll)
	registerForEvent("inputModeChanged", getElement("Scene.UIContract"), menu.onInputModeChanged)
	menu.selectedRows = {}

	menu.timeline = {}
	local n = C.GetNumTimeline();
	local buf = ffi.new("TimelineInfo[?]", n)
	n = C.GetTimeline(buf, n)
	for i = 0, n - 1 do
		table.insert(menu.timeline, { id = ffi.string(buf[i].id), name = ffi.string(buf[i].name), description = ffi.string(buf[i].description), image = ffi.string(buf[i].image), video = ffi.string(buf[i].video), voice = ffi.string(buf[i].voice), date = buf[i].date, group = buf[i].group })
	end
	table.sort(menu.timeline, function (a, b) return a.date < b.date end)

	AddUITriggeredEvent(menu.name, menu.encyclopediaMode)

	-- display main frame
	menu.createFrame()
end

function menu.createTopLevel(frame)
	menu.topLevelOffsetY = Helper.createTopLevelTab(menu, "encyclopedia", frame, "", nil, true)
end

function menu.onTabScroll(direction)
	if direction == "right" then
		Helper.scrollTopLevel(menu, "playerinfo", 1)
	elseif direction == "left" then
		Helper.scrollTopLevel(menu, "playerinfo", -1)
	end
end

function menu.onInputModeChanged(_, mode)
	menu.refresh = true
end

function menu.onCutsceneStopped()
	if menu.cutsceneid then
		if menu.cutscenedesc then
			ReleaseCutsceneDescriptor(menu.cutscenedesc)
		end
		menu.cutscenedesc = nil
		menu.cutsceneid = nil

		menu.rendertargetTexture = GetRenderTargetTexture(menu.rendertarget)
		if menu.rendertargetTexture then
			C.ClearRendertarget(menu.rendertargetTexture)
		end
	end
end

function menu.createFrame()
	-- remove old data
	Helper.clearDataForRefresh(menu, config.infoLayer)

	local frameProperties = {
		standardButtons = {},
		width = Helper.viewWidth,
		height = Helper.viewHeight,
		x = 0,
		y = 0,
		backgroundID = "solid",
		backgroundColor = Helper.color.semitransparent,
		standardButtons = { back = true, close = true, help = true  }
	}
	menu.infoFrame = Helper.createFrameHandle(menu, frameProperties)

	menu.sidebarWidth = Helper.scaleX(Helper.sidebarWidth)

	menu.createTopLevel(menu.infoFrame)
	menu.createSideBar(menu.infoFrame)
	if menu.encyclopediaMode == "timeline" then
		local timelineTable = menu.createTimelineTable(menu.infoFrame)
		menu.createRendertargetAndDescription(menu.infoFrame, timelineTable)
	end

	menu.infoFrame:display()
end

function menu.createSideBar(frame)
	local ftable = frame:addTable(1, { tabOrder = 2, width = menu.sidebarWidth, x = Helper.frameBorder, y = menu.topLevelOffsetY + Helper.borderSize, scaling = false, borderEnabled = false, reserveScrollBar = false })

	for _, entry in ipairs(config.leftBar) do
		local mode = entry.mode
		local row = ftable:addRow(true, { fixed = true })
		local active = true
		local bgcolor = Helper.defaultTitleBackgroundColor
		if entry.mode == "timeline" then
			bgcolor = Helper.defaultArrowRowBackgroundColor
		end
		local color = Helper.color.white
		row[1]:createButton({ active = active, height = menu.sidebarWidth, bgColor = bgcolor, mouseOverText = entry.name }):setIcon(entry.icon, { color = color })
		row[1].handlers.onClick = function () return menu.buttonToggleEncyclopediaMode(mode) end
	end

	ftable:setSelectedRow(menu.selectedRows.sidebar)
	menu.selectedRows.sidebar = nil
end

function menu.createTimelineTable(frame)
	local ftable = frame:addTable(4, { 
		tabOrder = 1,
		width = 0.3 * Helper.viewWidth,
		x = Helper.frameBorder + menu.sidebarWidth + Helper.borderSize,
		y = menu.topLevelOffsetY + Helper.borderSize,
		maxVisibleHeight = Helper.viewHeight - menu.topLevelOffsetY - Helper.borderSize - Helper.frameBorder,
	})
	if menu.setdefaulttable then
		ftable.properties.defaultInteractiveObject = true
		menu.setdefaulttable = nil
	end
	ftable:setColWidth(1, Helper.standardTextHeight)
	ftable:setColWidthPercent(2, 15)

	local lineoffsetY = 0
	local row = ftable:addRow(false, { fixed = true })
	row[1]:setColSpan(4):createText(ReadText(1001, 8201), Helper.headerRow1Properties)
	lineoffsetY = lineoffsetY + row:getHeight() + Helper.borderSize

	local row = ftable:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
	local format = ""
	for _, entry in ipairs(config.dateFormats) do
		if entry.id == menu.dateFormat then
			format = entry.text
		end
	end
	--row[1]:setColSpan(2):createText(ReadText(1001, 8206) .. " (" .. format .. ")", { font = Helper.standardFontBold })
	row[1]:setColSpan(2):createDropDown(config.dateFormats, {startOption = menu.dateFormat, height = Helper.standardTextHeight, textOverride = ReadText(1001, 8206) .. " (" .. format .. ")" }):setTextProperties({ font = Helper.standardFontBold })
	row[1].handlers.onDropDownConfirmed = menu.dropdownDate
	row[3]:setColSpan(2):createText(ReadText(1001, 8202), { font = Helper.standardFontBold })
	lineoffsetY = lineoffsetY + row:getHeight() + Helper.borderSize

	local currentGroup = -1
	for _, entry in ipairs(menu.timeline) do
		local isknown = IsKnownItem("timeline", entry.id)
		if entry.group ~= currentGroup then
			if currentGroup ~= -1 then
				ftable:addEmptyRow(config.gapHeight)
			end
			currentGroup = entry.group
		end
		local row = ftable:addRow(entry, { bgColor = Helper.color.transparent })
		row[1]:createIcon("ency_timeline_dot_01", { width = Helper.standardTextHeight, height = Helper.standardTextHeight })
		if isknown then
			if C.IsKnownItemRead("timeline", entry.id) then
				row[2]:createText(menu.convertDate(entry.date), { halign = "right", font = Helper.standardFontBold })
				row[3]:setColSpan(2):createText(entry.name, { wordwrap = true })
			else
				row[2]:createText(menu.convertDate(entry.date), { halign = "right", font = Helper.standardFontBold })
				row[3]:createText(entry.name, { wordwrap = true })
				row[4]:createText("\27G(" .. ReadText(1001, 2449) .. ")", { wordwrap = true, halign = "right" })
			end
		end

		if menu.selectedEntry and (entry.id == menu.selectedEntry.id) then
			ftable:setSelectedRow(row.index)
		end
	end

	local linethickness = Helper.scaleX(2)
	if linethickness % 2 == 0 then
		linethickness = linethickness - 1
	end
	local lineoffsetX = Helper.scaleX(Helper.standardTextHeight) / 2
	local lineend = { x = ftable.properties.x + lineoffsetX, y = ftable.properties.y + ftable.properties.maxVisibleHeight }
	Helper.drawLine( { x = ftable.properties.x + lineoffsetX, y = ftable.properties.y + lineoffsetY }, { x = lineend.x, y = lineend.y }, linethickness, nil, Helper.color.white, true )

	Helper.drawLine( { x = lineend.x - lineoffsetX, y = lineend.y - lineoffsetX }, { x = lineend.x + math.floor(linethickness / 2), y = lineend.y + math.floor(linethickness / 2) }, linethickness, nil, Helper.color.white, true )
	Helper.drawLine( { x = lineend.x, y = lineend.y }, { x = lineend.x + lineoffsetX, y = lineend.y - lineoffsetX }, linethickness, nil, Helper.color.white, true )

	ftable:setSelectedRow(menu.setrow or 1)
	if menu.toprow then
		ftable:setTopRow(menu.toprow)
	end
	menu.setrow = nil
	menu.toprow = nil

	return ftable
end

function menu.convertDate(date)
	local year = math.modf(date)
	if menu.dateFormat == "nt" then
		return year
	elseif menu.dateFormat == "ad" then
		return year + 2170
	elseif menu.dateFormat == "he" then
		return year + 12170
	elseif menu.dateFormat == "zt" then
		return year - 200 --math.floor((year - 750) * 1.36 + 550) -- 750nt == 550zt
	end
end

function menu.createRendertargetAndDescription(frame, timelineTable)
	local isknown = false
	menu.hasRendertarget = false
	if menu.selectedEntry then
		isknown = IsKnownItem("timeline", menu.selectedEntry.id)
		menu.hasRendertarget = isknown and (menu.selectedEntry.video ~= "")
	end

	local rendertargetWidth = Helper.viewWidth - timelineTable.properties.x - timelineTable.properties.width - Helper.borderSize - Helper.frameBorder
	-- make sure we can display at least two description line
	local maxHeight = Helper.viewHeight - menu.topLevelOffsetY - Helper.scaleY(Helper.headerRow1Height) - 4 *  Helper.borderSize - config.minDescriptionRows * (Helper.scaleY(Helper.standardTextHeight) + Helper.borderSize) - Helper.frameBorder
	local rendertargetHeight = math.min(maxHeight, math.floor(rendertargetWidth * 9 / 16))
	rendertargetWidth = math.min(rendertargetWidth, math.floor(rendertargetHeight * 16 / 9))
	local ftable
	if menu.hasRendertarget then
		menu.activatecutscene = nil
		menu.hasclearedrendertarget = nil
		local rendertarget = menu.infoFrame:addRenderTarget({ width = rendertargetWidth, height = rendertargetHeight, x = timelineTable.properties.x + timelineTable.properties.width + Helper.borderSize, y = menu.topLevelOffsetY + Helper.borderSize, alpha = 90 })

		ftable = frame:addTable(1, { 
			tabOrder = 3,
			width = rendertargetWidth,
			x = timelineTable.properties.x + timelineTable.properties.width + Helper.borderSize,
			y = rendertarget.properties.y + rendertarget.properties.height + Helper.borderSize,
			highlightMode = "off",
			maxVisibleHeight = Helper.viewHeight - rendertarget.properties.y - rendertarget.properties.height - Helper.borderSize - Helper.frameBorder
		})
	else
		ftable = frame:addTable(1, { 
			tabOrder = 3,
			width = rendertargetWidth,
			x = timelineTable.properties.x + timelineTable.properties.width + Helper.borderSize,
			y = menu.topLevelOffsetY + Helper.borderSize,
			highlightMode = "off",
			maxVisibleHeight = Helper.viewHeight - menu.topLevelOffsetY - Helper.borderSize - Helper.frameBorder
		})
	end

	if not menu.hasRendertarget then
		local row = ftable:addRow(false, { fixed = true, bgColor = Helper.color.semitransparent })
		local image = "ency_timeline_empty_01"
		if isknown and (menu.selectedEntry.image ~= "") then
			image = menu.selectedEntry.image
		end
		row[1]:createIcon(image, { width = rendertargetWidth, height = rendertargetHeight, scaling = false })
	end

	local row = ftable:addRow(false, { fixed = true })
	row[1]:createText(ReadText(1001, 2404), Helper.headerRow1Properties)

	local text = isknown and menu.selectedEntry.description or ""
	local width = ftable.properties.width - 2 * Helper.scaleX(Helper.standardTextOffsetx)
	local description = GetTextLines(text, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), width)
	if #description * (Helper.scaleY(Helper.standardTextHeight) + Helper.borderSize) > (ftable.properties.maxVisibleHeight - ftable:getFullHeight()) then
		description = GetTextLines(text, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), width - Helper.scrollbarWidth)
	end

	for _, line in ipairs(description) do
		local row = ftable:addRow(true, { bgColor = Helper.color.transparent })
		row[1]:createText(line)
	end
end

function menu.viewCreated(layer, ...)
	if menu.hasRendertarget then
		menu.toplevel, menu.sidebar, menu.timelineTable, menu.rendertarget, menu.descriptionTable = ...
	else
		menu.toplevel, menu.sidebar, menu.timelineTable, menu.descriptionTable = ...
	end

	if menu.encyclopediaMode == "timeline" then
		if menu.activatecutscene == nil then
			menu.activatecutscene = getElapsedTime()
		end
	end
end

-- update
menu.updateInterval = 0.1

function menu.onUpdate()
	local curtime = getElapsedTime()
	if menu.activatecutscene then
		if not menu.hasclearedrendertarget then
			menu.rendertargetTexture = GetRenderTargetTexture(menu.rendertarget)
			if menu.rendertargetTexture then
				menu.hasclearedrendertarget = true
				C.ClearRendertarget(menu.rendertargetTexture)
			end
		end

		if menu.activatecutscene + 1 < curtime then
			if IsKnownItem("timeline", menu.selectedEntry.id) and menu.selectedEntry.voice ~= "" then
				C.StartVoiceSequence2(menu.selectedEntry.voice, C.GetPlayerComputerID(), "")
			end
			menu.rendertargetTexture = GetRenderTargetTexture(menu.rendertarget)
			if menu.rendertargetTexture then
				menu.cutscenedesc = CreateCutsceneDescriptor(menu.selectedEntry.video, {})
				menu.cutsceneid = StartCutscene(menu.cutscenedesc, menu.rendertargetTexture)

				if not menu.cutsceneStoppedNotification then
					menu.cutsceneStoppedNotification = true
					NotifyOnCutsceneStopped(getElement("Scene.UIContract"))
				end

				menu.hasclearedrendertarget = nil
				menu.activatecutscene = nil
			end
		end
	end

	if menu.refresh then
		menu.refresh = nil
		menu.toprow = GetTopRow(menu.timelineTable)
		menu.setrow = Helper.currentTableRow[menu.timelineTable]
		menu.selectedRows.sidebar = Helper.currentTableRow[menu.sidebar]
		menu.createFrame()
		return
	end

	menu.infoFrame:update()
end

function menu.onRowChanged(row, rowdata, uitable)
	if uitable == menu.timelineTable then
		local changed = false
		if type(rowdata) == "table" then
			if (menu.selectedEntry == nil) or (menu.selectedEntry.id ~= rowdata.id) then
				menu.selectedEntry = rowdata
				C.ReadKnownItem("timeline", menu.selectedEntry.id, true)

				if menu.cutsceneid then
					StopCutscene(menu.cutsceneid)
					menu.cutsceneid = nil
				end
				if menu.cutscenedesc then
					ReleaseCutsceneDescriptor(menu.cutscenedesc)
					menu.cutscenedesc = nil
				end
				C.StopVoiceSequence()
				menu.refresh = true
			end
		end
	end
end

function menu.onSelectElement(uitable, modified, row)
end

function menu.onCloseElement(dueToClose)
	if menu.encyclopediaMode and (dueToClose == "back") then
		menu.deactivateEncyclopediaMode()
		return
	end

	Helper.closeMenu(menu, dueToClose)
	menu.cleanup()
end

init()
