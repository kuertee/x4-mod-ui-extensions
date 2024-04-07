-- ffi setup
local ffi = require("ffi")
local C = ffi.C
ffi.cdef[[
	const char* ConvertInputString(const char* text, const char* defaultvalue);
	uint64_t ConvertStringTo64Bit(const char* idstring);
	const char* FormatDateTimeString(int64_t time, const char* uiformat);
	const char* GetChatAuthorColor2(const char* authorname);
	int64_t GetCurrentUTCDataTime(void);
	const char* GetUserData(const char* name);
	bool IsVentureSeasonSupported(void);
	void NotifyChatMessageRead(void);
	void SetUserData(const char* name, const char* value);
	void TriggerInputFeedback(const char* type, const char* idname, const char* triggerid, const char* contextid);
]]

local menu = {
	name = "ChatWindow",
	active = false,
	userColors = {},
	mouseover = {},
	editboxstate = { text = "" },
	privatemessages = {},
	privateMessageIndex = 0,
	selectedPrivateMessages = 0,
}

local function init()
	-- register callbacks
	registerForEvent("chatMessageReceived", getElement("Scene.UIContract"), menu.onChatMessageReceived)
	RegisterEvent("announcementReceived", menu.onAnnouncementReceived)
	RegisterEvent("chatreported", menu.onChatReported)
	RegisterEvent("showchatwindow", function () return menu.toggleChatWindow() end)

	-- init variables
	menu.isStartmenu = C.IsStartmenu()

	SetScript("onHotkey", menu.onHotkey)

	-- register menu
	Menus = Menus or {}
	table.insert(Menus, menu)
	if Helper then
		Helper.registerMenu(menu)
	end
end


--- config ---

local config = {
	layer = 3,
	contextLayer = 2,
	width = 400,
	frameBackgroundFactor = 1.3,
	currentVersion = 3,
	frameXDefault = 50,
	frameYDefault = Helper.viewHeight / 2,
	frameSizeDefault = "normal",
	timeout = 5,
	fadeout = 2,
	mouseOutRange = 100,
	contextMenuWidth = 260,
	announcementAgeCutOff = 3600,
}

-- __CORE_CHAT_WINDOW = {
--		version = number	-- data version
--		x = number			-- frame x offset
--		y = number			-- frame y offset
--		size = number		-- frame size
--		announcements = {}	-- announcement buffer
-- }
__CORE_CHAT_WINDOW = __CORE_CHAT_WINDOW or { version = config.currentVersion, x = config.frameXDefault, y = config.frameYDefault, size = config.frameSizeDefault, announcements = {} }
-- patch
if __CORE_CHAT_WINDOW.version <= 1 then
	__CORE_CHAT_WINDOW = { version = 2, x = config.frameXDefault, y = config.frameYDefault, size = config.frameSizeDefault }
end
if __CORE_CHAT_WINDOW.version <= 2 then
	__CORE_CHAT_WINDOW.announcements = {}
end
__CORE_CHAT_WINDOW.version = config.currentVersion


--- widget hooks ---

function menu.onHotkey(action)
	if action == "INPUT_ACTION_SHOW_CHAT_WINDOW" then
		local active = (not menu.shown) or (not menu.active) or next(Helper.chatParams)
		C.TriggerInputFeedback("action", "INPUT_ACTION_SHOW_CHAT_WINDOW", active and "active" or "inactive", "")
		menu.toggleChatWindow()
	end
end

function menu.onChatMessageReceived()
	if menu.shown then
		menu.messagesOutdated = true

		local messagetexts = menu.messagetexts
		if menu.selectedPrivateMessages > 0 then
			messagetexts = menu.privatemessages[menu.selectedPrivateMessages].messages
		end

		if menu.active then
			local toprow = GetTopRow(menu.chatTable)
			if toprow == ((#messagetexts < menu.numchatlines) and 3 or (#messagetexts + 3 - menu.numchatlines)) then
				menu.settoprow = nil
			else
				menu.settoprow = toprow
			end
		else
			if menu.fadetoprow == ((#messagetexts < menu.numchatlines) and 3 or (#messagetexts + 3 - menu.numchatlines)) then
				menu.settoprow = nil
			end
		end
		if not menu.dragging then
			if menu.typing then
				menu.activateeditbox = true
			end
			menu.onShowMenu()
		end
	end
end

function menu.onAnnouncementReceived(_, message)
	if (#__CORE_CHAT_WINDOW.announcements == 0) or (__CORE_CHAT_WINDOW.announcements[#__CORE_CHAT_WINDOW.announcements].text ~= message) then
		-- have to convert timestamp to string for saving in uidata.xml
		table.insert(__CORE_CHAT_WINDOW.announcements, { text = message, prefix = ColorText["text_chat_message_server"] .. ReadText(1001, 12109) .. ReadText(1001, 120) .. " ", timestamp = tostring(C.GetCurrentUTCDataTime() * 1000), announcement = true })
		if not menu.shown then
			menu.toggleChatWindow(true)
		end
	end
end

function menu.onChatReported(_, timestamp)
	if menu.shown then
		menu.messagesOutdated = true
		menu.onShowMenu()
	end
end

--- helper functions ---

function menu.toggleChatWindow(noeditboxactivation)
	if (not menu.shown) or (not menu.active) or next(Helper.chatParams) then
		menu.active = true
		menu.lastInteraction = getElapsedTime()
		Helper.setChatUpdateHandler(menu)
		menu.messagesOutdated = true
		menu.settoprow = nil

		if (not menu.shown) and (not noeditboxactivation) then
			menu.activateeditbox = true
		end

		if next(Helper.chatParams) then
			_, menu.selectedPrivateMessages = menu.getPrivateMessages(Helper.chatParams.id, Helper.chatParams.name)
			if menu.selectedPrivateMessages > menu.privateMessageIndex + 2 then
				menu.privateMessageIndex = menu.selectedPrivateMessages - 2
			elseif menu.selectedPrivateMessages < menu.privateMessageIndex then
				menu.privateMessageIndex = menu.selectedPrivateMessages
			end
			Helper.chatParams = {}
		end

		menu.onShowMenu()
	else
		menu.closeMenu("close")
	end
end

function menu.cleanup()
	menu.chatFrame = nil
	menu.active = false
	menu.dragging = nil
	menu.fadefactor = nil
	menu.islocked = nil

	menu.contextMenuMode = nil
	menu.contextMenuData = {}
	menu.mouseOutBox = nil
	
	menu.shown = nil
	menu.mouseover = {}
end

function menu.getChatColor(author, authorid, userid)
	if not menu.userColors[author] then
		if authorid == userid then
			menu.userColors[author] = Color["text_player"]
		else
			local colorid = ffi.string(C.GetChatAuthorColor2(author))
			menu.userColors[author] = Color[colorid]
		end
	end
	return menu.userColors[author]
end

function menu.getMessageReceiverID(userid, groupid)
	menu.chatgroups = menu.chatgroups or {}
	if not menu.chatgroups[groupid] then
		menu.chatgroups[groupid] = OnlineGetChatGroupUsers(groupid)
		if not next(menu.chatgroups[groupid]) then
			menu.chatgroups[groupid] = nil
			return -1, ""
		end
	end
	for _, user in ipairs(menu.chatgroups[groupid]) do
		if user.id ~= userid then
			return user.id, user.name
		end
	end
	return -1, ""
end

function menu.getPrivateMessages(receiverid, receivername, groupid, timestamp)
	local currentlastmessageread = groupid and C.ConvertStringTo64Bit(C.GetUserData("chat_group_" .. groupid)) or 0

	for i, entry in ipairs(menu.privatemessages) do
		if entry.receiverid == receiverid then
			if groupid and (menu.privatemessages[i].groupid == nil) then
				menu.privatemessages[i].groupid = groupid
			end
			if menu.privatemessages[i].hidden and ((not timestamp) or (timestamp > currentlastmessageread)) then
				menu.privatemessages[i].hidden = false
			end
			return menu.privatemessages[i].messages, i
		end
	end

	table.insert(menu.privatemessages, { receiverid = receiverid, name = receivername, groupid = groupid, hiden = (not timestamp) or (timestamp > currentlastmessageread), messages = {} })
	return menu.privatemessages[#menu.privatemessages].messages, #menu.privatemessages
end

function menu.getChatMessages()
	if menu.messagesOutdated then
		local username, userid = OnlineGetUserName()
		local fontsize = Helper.scaleFont(Helper.standardFont, Helper.standardFontSize)
		menu.messagetexts = {}
		for i in ipairs(menu.privatemessages) do
			menu.privatemessages[i].messages = {}
		end

		local prevdate = ""
		local messages = OnlineGetChatMessages()
		for i, message in ipairs(messages) do
			local color = menu.getChatColor(message.author, message.authorid, userid)

			local timestamp = C.ConvertStringTo64Bit(tostring(message.time))
			local date = ffi.string(C.FormatDateTimeString(timestamp / 1000, "%Y-%m-%d"))
			if date ~= prevdate then
				prevdate = date
				table.insert(menu.messagetexts, { line = -1, text = "--- " .. date .. " ---", prefix = nil, timestamp = timestamp, authorid = message.authorid, datedivider = true })
			end

			local prefix = ffi.string(C.FormatDateTimeString(timestamp / 1000, "%H:%M")) .. " " .. Helper.convertColorToText(color) .. message.author .. "\27X" .. ReadText(1001, 120) .. " "
			local indent = C.GetTextWidth(prefix, Helper.standardFont, fontsize) + Helper.scaleX(Helper.standardTextOffsetx)

			local lines = GetTextLines(message.reported and ReadText(1001, 12116) or message.text, Helper.standardFont, fontsize, menu.width - indent - Helper.scaleX(Helper.standardTextOffsetx) - Helper.scrollbarWidth)
			for j, line in ipairs(lines) do
				local text = message.reported and (ColorText["text_inactive"] .. line .. "\27X") or line

				if message.isprivate then
					local receiverid, receivername = menu.getMessageReceiverID(userid, message.groupid)
					if receiverid >= 0 then
						local messages, receiverid = menu.getPrivateMessages(receiverid, receivername, message.groupid, timestamp)
						table.insert(messages, { line = j, text = text, prefix = (j == 1) and prefix or nil, timestamp = timestamp, author = message.author, authorcolor = color, reported = message.reported, authorid = message.authorid })
					end
				else
					table.insert(menu.messagetexts, { line = j, text = text, prefix = (j == 1) and prefix or nil, timestamp = timestamp, author = message.author, authorcolor = color, reported = message.reported, authorid = message.authorid })
				end
			end
		end

		local announcementagecutoff = (C.GetCurrentUTCDataTime() - config.announcementAgeCutOff) * 1000
		for i = #__CORE_CHAT_WINDOW.announcements, 1, -1 do
			local announcement = Helper.tableCopy(__CORE_CHAT_WINDOW.announcements[i])
			announcement.timestamp = C.ConvertStringTo64Bit(announcement.timestamp)
			if announcement.timestamp < announcementagecutoff then
				table.remove(__CORE_CHAT_WINDOW.announcements, i)
			else
				local indent = C.GetTextWidth(announcement.prefix, Helper.standardFont, fontsize) + Helper.scaleX(Helper.standardTextOffsetx)
				local lines = GetTextLines(announcement.text, Helper.standardFont, fontsize, menu.width - indent - Helper.scaleX(Helper.standardTextOffsetx) - Helper.scrollbarWidth)
				for j, line in ipairs(lines) do
					local announcementline = Helper.tableCopy(announcement)
					announcementline.text = ColorText["text_chat_message_server"] .. line .. "\27X"
					if j > 1 then
						announcementline.prefix = nil
					end
					announcementline.line = j
					table.insert(menu.messagetexts, announcementline)
				end
			end
		end
		table.sort(menu.messagetexts, menu.sortMessages)

		menu.messagesOutdated = nil
	end
end

function menu.sortMessages(a, b)
	if a.timestamp == b.timestamp then
		if a.authorid == b.authorid then
			return a.line < b.line
		end
		return a.authorid < b.authorid
	end
	return a.timestamp < b.timestamp
end

function menu.buttonDrag()
	local x, y = GetLocalMousePosition()
	local framex, framey = GetFramePosition(menu.chatFrame.id)

	menu.dragoffset = { x = x + Helper.viewWidth / 2 - framex, y = Helper.viewHeight / 2 - y - framey }
	menu.dragging = not menu.dragging
end

function menu.buttonReportMessage(timestamp, author)
	OpenMenu("MapMenu", { 0, 0, true, nil, nil, 'venturereport', { "chat", "Inappropriate chat message", ConvertStringToLuaID(tostring(timestamp)), author } }, nil) -- hardcoded text only visible in venture server moderator interface
	menu.mouseover = {}
	menu.islocked = true
	menu.closeContextMenu(true)
end

function menu.buttonReportUser(userid)
	OpenMenu("MapMenu", { 0, 0, true, nil, nil, 'venturereport', { "user", "Offensive user name", nil, nil, nil, userid } }, nil) -- hardcoded text only visible in venture server moderator interface
	menu.mouseover = {}
	menu.islocked = true
	menu.closeContextMenu(true)
end

function menu.buttonContactMessage(menu, userid, username)
	_, menu.selectedPrivateMessages = menu.getPrivateMessages(userid, username)
	if menu.selectedPrivateMessages > menu.privateMessageIndex + 2 then
		menu.privateMessageIndex = menu.selectedPrivateMessages - 2
	elseif menu.selectedPrivateMessages < menu.privateMessageIndex then
		menu.privateMessageIndex = menu.selectedPrivateMessages
	end
	menu.closeContextMenu(true)
	menu.onShowMenu()
end

function menu.buttonNextChannel()
	menu.selectedPrivateMessages = math.min(#menu.privatemessages, menu.selectedPrivateMessages + 1)
	if menu.selectedPrivateMessages > menu.privateMessageIndex + 2 then
		menu.privateMessageIndex = menu.selectedPrivateMessages - 2
	end
	menu.settoprow = nil
	menu.onShowMenu()
end

function menu.buttonPrevChannel()
	menu.selectedPrivateMessages = math.max(0, menu.selectedPrivateMessages - 1)
	if menu.selectedPrivateMessages < menu.privateMessageIndex then
		menu.privateMessageIndex = menu.selectedPrivateMessages
	end
	menu.settoprow = nil
	menu.onShowMenu()
end

function menu.buttonClosePrivateChat(idx)
	local entry = menu.privatemessages[idx]
	table.remove(menu.privatemessages, idx)
	menu.selectedPrivateMessages = math.min(menu.selectedPrivateMessages, #menu.privatemessages)
	if entry.groupid then
		C.SetUserData("chat_group_" .. entry.groupid, tostring(entry.messages[#entry.messages].timestamp))
		C.NotifyChatMessageRead()
	end
	menu.onShowMenu()
end

function menu.checkboxMute(_, checked)
	local userdataid = "chat_general_muted"
	if menu.selectedPrivateMessages > 0 then
		local entry = menu.privatemessages[menu.selectedPrivateMessages]
		userdataid = entry.groupid and ("chat_group_" .. entry.groupid .. "_muted") or ""
	end
	C.SetUserData(userdataid, checked and "1" or "0")
end

function menu.editboxActivated()
	if not menu.activateeditbox then
		C.TriggerInputFeedback("state", "INPUT_STATE_ADDON_CHATWINDOW_COMMANDBAR", "active", "")
	end
	menu.typing = true
	if menu.normalBackground then
		menu.activateeditbox = true
		menu.onShowMenu()
	end
end

function menu.editboxMessageChanged(_, text)
	menu.editboxstate.text = text
end

function menu.editboxMessageCursorChanged(_, cursorpos, shiftstartpos)
	menu.editboxstate.cursorpos = cursorpos
	menu.editboxstate.shiftstartpos = shiftstartpos
end

function menu.editboxSendMessage(_, text, textchanged, isconfirmed, wastableclick)
	menu.typing = nil
	if not wastableclick then
		menu.editboxstate = { text = "" }
	end
	if (text == "") or wastableclick then
		menu.onShowMenu()
		return
	end

	-- kuertee start: signal md
	AddUITriggeredEvent("Chat_Window_API", "text_entered", {terms = {""}, text = text})
	DebugError("uix: chatwindow.xpl.editboxSendMessage text_entered: " .. tostring(text))
	-- kuertee end

	local parameter = ""
	if string.sub(text, 1, 1) ~= "/" then
		-- no special command - interpret as chat message
		local userid = 0
		if menu.selectedPrivateMessages > 0 then
			userid = menu.privatemessages[menu.selectedPrivateMessages].receiverid
		end
		OnlineSendChatMessage(text, userid)
	elseif #text == 1 then
		DebugError("Invalid syntax. No command specified.")
		return -- abort command execution
	elseif string.sub(text, 2, 2) == " " then
		DebugError("Invalid syntax. A command must not be prefixed by whitespaces.")
		return -- abort command execution
	else
		-- otherwise we have a command
		-- check if we have (a) command parameter(s)
		local pos = string.find(text, " ") or 0

		-- subsitude the parameter (if any)
		if pos ~= 0 then
			parameter = string.sub(text, pos + 1) -- skip " "
		end

		-- substitude the command (strip the leading / and the parameter(s))
		text = string.sub(text, 2, pos - 1)

		-- finally execute the command	
		ExecuteDebugCommand(text, parameter)
	end

	menu.onShowMenu()
end

function menu.tabIconColor(messageindex)
	local userdataid = "chat_general_muted"
	if messageindex > 0 then
		local entry = menu.privatemessages[messageindex]
		userdataid = entry.groupid and ("chat_group_" .. entry.groupid .. "_muted") or ""
	end
	local muted = ffi.string(C.GetUserData(userdataid)) == "1"
	return muted and Color["icon_normal"] or Color["icon_hidden"]
end

function menu.closeContextMenu(skiptoplevelmenu)
	if menu.contextMenuMode then
		Helper.clearFrame(menu, config.contextLayer)
		menu.contextMenuMode = nil
		menu.mouseOutBox = nil

		if not skiptoplevelmenu then
			local occupiedship = ConvertStringTo64Bit(tostring(C.GetPlayerOccupiedShipID()))
			if (occupiedship ~= 0) and (not GetComponentData(occupiedship, "isdocked")) then
				OpenMenu("TopLevelMenu", { 0, 0 }, nil)
			end
		end
	end
end

--- menus ---

function menu.displayChat()
	Helper.clearDataForRefresh(menu, config.layer)

	local framebackgroundcolor = Helper.tableCopy(Color["chat_background"])
	local textcolor = Helper.tableCopy(Color["text_inactive"])
	local boxtextcolor = Helper.tableCopy(Color["row_background_unselectable"])
	local linecolor = Helper.tableCopy(Color["row_background_blue"])
	if menu.fadefactor then
		framebackgroundcolor.a = menu.fadefactor * framebackgroundcolor.a
		textcolor.a = math.max(1, menu.fadefactor * textcolor.a)
		boxtextcolor.a = menu.fadefactor * boxtextcolor.a
		linecolor.a = menu.fadefactor * linecolor.a
	end

	menu.chatFrame = Helper.createFrameHandle(menu, {
		layer = config.layer,
		x = __CORE_CHAT_WINDOW.x,
		y = __CORE_CHAT_WINDOW.y,
		width = menu.width,
		height = menu.height,
		standardButtons = {},
		startAnimation = false,
		playerControls = true,
		viewHelperType = "Chat",
	})

	menu.table = {
		width = menu.width,
		x = 0,
	}

	local numcols = 10
	local ftable = menu.chatFrame:addTable(numcols, {
		tabOrder = menu.active and 2 or 0,
		x = menu.table.x,
		width = menu.table.width,
		highlightMode = "off",
		reserveScrollBar = false
	})
	local buttonWidth = Helper.scaleY(Helper.standardButtonHeight)
	local remainingWidth = menu.table.width - 4 * (buttonWidth + Helper.borderSize)
	local tabWidth = math.floor((remainingWidth - 2 * Helper.borderSize) / 3)
	ftable:setColWidth(1, buttonWidth, false)
	ftable:setColWidth(3, buttonWidth, false)
	ftable:setColWidth(4, tabWidth - buttonWidth - Helper.borderSize, false)
	ftable:setColWidth(5, buttonWidth, false)
	ftable:setColWidth(6, tabWidth - buttonWidth - Helper.borderSize, false)
	ftable:setColWidth(7, buttonWidth, false)
	ftable:setColWidth(8, buttonWidth, false)
	ftable:setColWidth(9, buttonWidth, false)
	ftable:setColWidth(10, math.max(buttonWidth, Helper.scrollbarWidth), false)

	-- header
	local row = ftable:addRow(menu.active, { fixed = true })
	row[1]:createButton({ active = menu.active and (menu.selectedPrivateMessages > 0) }):setIcon("widget_arrow_left_01")
	row[1].handlers.onClick = menu.buttonPrevChannel

	menu.privateMessageIndex = math.max(0, math.min(#menu.privatemessages, menu.privateMessageIndex))
	local col = 2
	local shown = 0
	local messageindex = menu.privateMessageIndex
	while (shown < 3) and (messageindex <= #menu.privatemessages) do
		if messageindex == 0 then
			row[col]:setColSpan(2):createButton({ active = menu.active, bgColor = (menu.selectedPrivateMessages == 0) and Color["row_background_blue"] or nil }):setText(C.IsVentureSeasonSupported() and ReadText(1001, 11648) or ReadText(1001, 12101)):setIcon("menu_sound_off", { scaling = false, color = function () return menu.tabIconColor(0) end, width = buttonWidth, height = buttonWidth, x = tabWidth - buttonWidth })
			row[col].handlers.onClick = function () menu.selectedPrivateMessages = 0; menu.settoprow = nil; menu.onShowMenu() end
			col = col + 2
			shown = shown + 1
			messageindex = messageindex + 1
		else
			local i = messageindex
			local entry = menu.privatemessages[i]
			if not entry.hidden then
				local width = row[col]:getWidth() + Helper.borderSize
				row[col]:setBackgroundColSpan(2):createButton({ scaling = false, active = menu.active, bgColor = (menu.selectedPrivateMessages == i) and Color["row_background_blue"] or nil, width = width, height = Helper.scaleY(Helper.standardButtonHeight) }):setText(entry.name, { scaling = true }):setIcon("menu_sound_off", { color = function () return menu.tabIconColor(i) end, width = buttonWidth, height = buttonWidth, x = width - buttonWidth })
				row[col].handlers.onClick = function () menu.selectedPrivateMessages = i; menu.settoprow = nil; menu.onShowMenu() end
				row[col + 1]:createButton({ active = menu.active, bgColor = (menu.selectedPrivateMessages == i) and Color["row_background_blue"] or nil, width = Helper.standardButtonHeight }):setIcon("widget_cross_01")
				row[col + 1].handlers.onClick = function () menu.buttonClosePrivateChat(i) end
				col = col + 2
				shown = shown + 1
			end
			messageindex = messageindex + 1
		end
	end

	row[8]:createButton({ active = menu.active and (menu.selectedPrivateMessages < #menu.privatemessages) }):setIcon("widget_arrow_right_01")
	row[8].handlers.onClick = menu.buttonNextChannel

	row[9]:createButton({
		active = menu.active,
		bgColor = function () return menu.dragging and Color["chat_move_background"] or Color["button_background_default"] end,
		highlightColor = function () return menu.dragging and Color["chat_move_background"] or Color["button_highlight_default"] end,
		mouseOverText = ReadText(1026, 12101),
	}):setIcon("menu_move")
	row[9].handlers.onClick = menu.buttonDrag

	row[10]:createButton({ active = menu.active, mouseOverText = ffi.string(C.ConvertInputString(ReadText(1026, 12102), ReadText(1001, 2670))), width = Helper.standardButtonHeight }):setIcon("widget_cross_01")
	row[10].handlers.onClick = function () menu.closeMenu() end

	-- line
	local row = ftable:addRow(false, { fixed = true, bgColor = linecolor })
	row[1]:setColSpan(numcols):createText(" ", { fontsize = 1, minRowHeight = 2 })

	local headerheight = ftable:getFullHeight()
	local messagetexts = menu.messagetexts
	if menu.selectedPrivateMessages > 0 then
		messagetexts = menu.privatemessages[menu.selectedPrivateMessages].messages
	end

	-- empty lines
	if #messagetexts < menu.numchatlines then
		for i = 1, menu.numchatlines - #messagetexts do
			local row = ftable:addRow(menu.active, {  })
			row[1]:setColSpan(numcols):createText("")
		end
	end

	-- message lines
	local indent = 0
	local fontsize = Helper.scaleFont(Helper.standardFont, Helper.standardFontSize)
	for i, entry in ipairs(messagetexts) do
		if menu.active or (i >= menu.fadetoprow - 2) and (i < menu.fadetoprow - 2 + menu.numchatlines) then
			local row = ftable:addRow((menu.active and (not entry.datedivider) and (not entry.announcement)) and { timestamp = entry.timestamp, author = entry.author, authorcolor = entry.authorcolor, reported = entry.reported, announcement = entry.announcement, authorid = entry.authorid } or nil, {  })
			if entry.prefix then
				indent = C.GetTextWidth(entry.prefix, Helper.standardFont, fontsize) + Helper.scaleX(Helper.standardTextOffsetx)
				row[1]:setColSpan(numcols):createText(entry.prefix .. entry.text, { color = menu.active and Color["text_normal"] or textcolor })
			elseif entry.datedivider then
				
				row[1]:setColSpan(numcols):createText(entry.text, { color = menu.active and Color["text_normal"] or textcolor, halign = "center" })
			else
				row[1]:setColSpan(numcols):createText(entry.text, { scaling = false, x = indent, fontsize = fontsize, minRowHeight = Helper.scaleY(Helper.standardTextHeight), color = menu.active and Color["text_normal"] or textcolor })
			end
		end
	end

	menu.settoprow = menu.settoprow or ((#messagetexts < menu.numchatlines) and 3 or (#messagetexts + 3 - menu.numchatlines))

	ftable:setTopRow(menu.settoprow)
	ftable:setSelectedRow(#messagetexts + 2)

	ftable.properties.maxVisibleHeight = headerheight + menu.numchatlines * (Helper.scaleY(Helper.standardTextHeight) + Helper.borderSize)

	if menu.chatFrame.properties.y + ftable.properties.maxVisibleHeight > Helper.viewHeight then
		__CORE_CHAT_WINDOW.y = Helper.viewHeight - ftable.properties.maxVisibleHeight
		menu.chatFrame.properties.y = __CORE_CHAT_WINDOW.y
		menu.chatFrame.properties.height = ftable.properties.maxVisibleHeight
	end

	-- editbox and options
	numcols = 4
	local ftable2 = menu.chatFrame:addTable(numcols, { tabOrder = menu.active and 1 or 0, x = menu.table.x, width = menu.table.width })
	ftable2:setColWidth(1, Helper.standardButtonHeight)

	local row = ftable2:addRow(menu.active, { fixed = true })
	if menu.active then
		row[1]:setColSpan(numcols):createEditBox({ height = Helper.standardButtonHeight, description = ReadText(1001, 12108), maxChars = 255, selectTextOnActivation = false }):setText(menu.editboxstate.text, {  }):setHotkey("INPUT_STATE_ADDON_CHATWINDOW_COMMANDBAR", { displayIcon = true })
		row[1].handlers.onEditBoxActivated = menu.editboxActivated
		row[1].handlers.onTextChanged = menu.editboxMessageChanged
		row[1].handlers.onCursorChanged = menu.editboxMessageCursorChanged
		row[1].handlers.onEditBoxDeactivated = menu.editboxSendMessage
	else
		row[1]:setColSpan(numcols):createBoxText("", { boxColor = boxtextcolor })
	end

	--local row = ftable2:addRow(menu.active, { fixed = true })
	--row[1]:createButton({ active = menu.active }):setText(ReadText(1001, 12106), { halign = "center" })
	--row[1].handlers.onClick = function () menu.options = not menu.options; menu.onShowMenu() end

	--if menu.options then
		local row = ftable2:addRow(menu.active, { fixed = true })
		local userdataid = "chat_general_muted"
		if menu.selectedPrivateMessages > 0 then
			local entry = menu.privatemessages[menu.selectedPrivateMessages]
			userdataid = entry.groupid and ("chat_group_" .. entry.groupid .. "_muted") or ""
		end
		local muted = ffi.string(C.GetUserData(userdataid)) == "1"
		row[1]:createCheckBox(muted, { active = menu.active, width = Helper.standardButtonHeight })
		row[1].handlers.onClick = menu.checkboxMute
		row[2]:createText(ReadText(1001, 12107), { halign = "left" })

		local sizeoptions = {
			{ id = "small",		text = ReadText(1001, 12102),	icon = "", displayremoveoption = false },
			{ id = "normal",	text = ReadText(1001, 12103),	icon = "", displayremoveoption = false },
			{ id = "large",		text = ReadText(1001, 12104),	icon = "", displayremoveoption = false },
		}
		row[4]:createDropDown(sizeoptions, { startOption = __CORE_CHAT_WINDOW.size, height = Helper.standardButtonHeight, textOverride = ReadText(1001, 12105), active = menu.active }):setTextProperties({ halign = "center" })
		row[4].handlers.onDropDownConfirmed = function (_, id) __CORE_CHAT_WINDOW.size = id; menu.messagesOutdated = true; menu.settoprrow = nil; menu.onShowMenu() end
	--end

	ftable.properties.nextTable = ftable2.index
	ftable2.properties.prevTable = ftable.index

	local height = ftable:getVisibleHeight()
	ftable2.properties.y = ftable.properties.y + height + Helper.borderSize

	local height2 = ftable2:getFullHeight()
	menu.height = ftable2.properties.y + height2
	ftable2.properties.y = ftable.properties.y + height + Helper.borderSize
	menu.chatFrame.properties.height = menu.height
	if menu.activateeditbox then
		menu.chatFrame:setBackground("solid", { color = Color["frame_background_semitransparent"], width = 2 * Helper.viewWidth, height = 2 * Helper.viewHeight })
		menu.chatFrame.properties.playerControls = false
		menu.normalBackground = false
	else
		menu.chatFrame:setBackground("gui_chat_background_01", { color = framebackgroundcolor, width = menu.width * config.frameBackgroundFactor, height = menu.height * config.frameBackgroundFactor })
		menu.normalBackground = true
	end

	if menu.chatFrame.properties.x + menu.chatFrame.properties.width > Helper.viewWidth then
		__CORE_CHAT_WINDOW.x = Helper.viewWidth - menu.chatFrame.properties.width
		menu.chatFrame.properties.x = __CORE_CHAT_WINDOW.x
	end

	if menu.chatFrame.properties.y + menu.chatFrame.properties.height > Helper.viewHeight then
		__CORE_CHAT_WINDOW.y = Helper.viewHeight - menu.chatFrame.properties.height
		menu.chatFrame.properties.y = __CORE_CHAT_WINDOW.y
	end

	menu.chatFrame:display()
end

function menu.createContextFrame(data, x, y, width, nomouseout)
	if Helper.topLevelMenu then
		local topLevelMenu = Helper.topLevelMenu
		Helper.closeMenu(topLevelMenu, "close")
		topLevelMenu.cleanup()
	end
	Helper.topLevelMenu = nil

	Helper.removeAllWidgetScripts(menu, config.contextLayer)
	PlaySound("ui_positive_click")

	local contextmenuwidth = width or menu.contextMenuWidth

	menu.contextFrame = Helper.createFrameHandle(menu, {
		layer = config.contextLayer,
		standardButtons = { close = true },
		width = contextmenuwidth,
		x = x,
		y = 0,
		autoFrameHeight = true,
		startAnimation = false,
		playerControls = true,
		viewHelperType = "Chat",
	})
	menu.contextFrame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	if menu.contextMenuMode == "report" then
		menu.createReportContext(menu.contextFrame)
	end

	if menu.contextFrame.properties.x + contextmenuwidth > Helper.viewWidth then
		menu.contextFrame.properties.x = Helper.viewWidth - contextmenuwidth - Helper.frameBorder
	end
	local height = menu.contextFrame:getUsedHeight()
	if y + height > Helper.viewHeight then
		menu.contextFrame.properties.y = Helper.viewHeight - height - Helper.frameBorder
	else
		menu.contextFrame.properties.y = y
	end

	menu.contextFrame:display()

	if not nomouseout then
		menu.mouseOutBox = {
			x1 =   menu.contextFrame.properties.x -  Helper.viewWidth / 2                    - config.mouseOutRange,
			x2 =   menu.contextFrame.properties.x -  Helper.viewWidth / 2 + contextmenuwidth + config.mouseOutRange,
			y1 = - menu.contextFrame.properties.y + Helper.viewHeight / 2                    + config.mouseOutRange,
			y2 = - menu.contextFrame.properties.y + Helper.viewHeight / 2 - height           - config.mouseOutRange
		}
	end
end

function menu.createReportContext(frame)
	local data = menu.contextMenuData.rowdata

	local ftable = frame:addTable(1, { tabOrder = 4, highlightMode = "off" })

	local row = ftable:addRow(false, { fixed = true })
	row[1]:createText(data.author, Helper.headerRowCenteredProperties)
	row[1].properties.color = data.authorcolor

	local _, userid = OnlineGetUserName()
	if data.authorid ~= userid then
		local row = ftable:addRow(true, { fixed = true })
		row[1]:createButton({  }):setText(ReadText(1001, 12115))
		row[1].handlers.onClick = function () return menu.buttonContactMessage(menu, data.authorid, data.author) end
	end

	ftable:addEmptyRow(Helper.standardTextHeight / 2)

	local row = ftable:addRow(nil, { fixed = true })
	row[1]:createText(ReadText(1001, 12110), Helper.subHeaderTextProperties)

	local row = ftable:addRow(true, { fixed = true })
	row[1]:createButton({  }):setText(ReadText(1001, 12111))
	row[1].handlers.onClick = function () return menu.buttonReportUser(data.authorid) end
	
	local row = ftable:addRow(true, { fixed = true })
	row[1]:createButton({ active = (not data.reported) and (not data.announcement) }):setText(ReadText(1001, 12112))
	row[1].handlers.onClick = function () return menu.buttonReportMessage(data.timestamp, data.author) end
end

--- Helper hooks ---

function menu.onShowMenu()
	menu.shown = true
	menu.typing = nil

	menu.width = Helper.scaleX(config.width)
	menu.numchatlines = 9
	if __CORE_CHAT_WINDOW.size == "small" then
		menu.width = math.floor(menu.width * 2 / 3)
		menu.numchatlines = 6
	elseif __CORE_CHAT_WINDOW.size == "large" then
		menu.width = math.floor(menu.width * 5 / 3)
		menu.numchatlines = 15
	end
	menu.height = Helper.viewHeight - __CORE_CHAT_WINDOW.y

	menu.getChatMessages()

	menu.displayChat()
end

function menu.viewCreated(layer, ...)
	if layer == config.layer then
		menu.chatTable, menu.optionTable = ...
	end
end

menu.updateInterval = 0.01
function menu.onUpdate()
	local curtime = getElapsedTime()
	if menu.dragging then
		menu.lastInteraction = curtime

		local x, y = GetLocalMousePosition()
		__CORE_CHAT_WINDOW.x = math.max(0, math.min(Helper.viewWidth - menu.width, Helper.viewWidth / 2 + x - menu.dragoffset.x))
		__CORE_CHAT_WINDOW.y = math.max(0, math.min(Helper.viewHeight - menu.height, Helper.viewHeight / 2 - y - menu.dragoffset.y))

		if menu.settoprow then
			menu.settoprow = GetTopRow(menu.chatTable)
		end
		menu.onShowMenu()
		return
	end

	if menu.typing then
		menu.lastInteraction = curtime
	end

	if next(menu.mouseover) then
		menu.lastInteraction = curtime
	end

	if menu.islocked then
		menu.lastInteraction = curtime
	end

	if menu.lastInteraction + config.timeout + config.fadeout < curtime then
		menu.closeMenu()
		return
	elseif menu.lastInteraction + config.timeout < curtime then
		if menu.active then
			menu.active = false
			menu.closeContextMenu()
			menu.fadetoprow = GetTopRow(menu.chatTable)
		end

		menu.fadefactor = 1 - (curtime - menu.lastInteraction - config.timeout) / config.fadeout
		menu.onShowMenu()
		return
	elseif menu.fadefactor then
		menu.active = true
		menu.fadefactor = nil
		menu.onShowMenu()
		return
	end

	if menu.mouseOutBox then
		if (GetControllerInfo() ~= "gamepad") or (C.IsMouseEmulationActive()) then
			local curpos = table.pack(GetLocalMousePosition())
			if curpos[1] and ((curpos[1] < menu.mouseOutBox.x1) or (curpos[1] > menu.mouseOutBox.x2)) then
				menu.closeContextMenu()
			elseif curpos[2] and ((curpos[2] > menu.mouseOutBox.y1) or (curpos[2] < menu.mouseOutBox.y2)) then
				menu.closeContextMenu()
			end
		end
	end

	if menu.activateeditbox then
		Helper.activateEditBox(menu.optionTable, 1, 1, menu.editboxstate.cursorpos, menu.editboxstate.shiftstartpos)
		menu.activateeditbox = nil
	end

	menu.chatFrame:update()
end

function menu.onRowChanged(row, rowdata, uitable, modified, input, source)
	if not menu.fadefactor then
		menu.lastInteraction = getElapsedTime()
	end
	local messagetexts = menu.messagetexts
	local userdataid = "chat_general"
	if menu.selectedPrivateMessages > 0 then
		local entry = menu.privatemessages[menu.selectedPrivateMessages]
		messagetexts = entry.messages
		userdataid = entry.groupid and ("chat_group_" .. entry.groupid) or ""
	end
	if (userdataid ~= "") and (#messagetexts > 0) then
		local toprow = GetTopRow(menu.chatTable)
		local lastshownline = math.max(1, math.min(#messagetexts, toprow + menu.numchatlines - 1))
		local lastmessageread = messagetexts[lastshownline].timestamp

		local currentlastmessageread = C.ConvertStringTo64Bit(C.GetUserData(userdataid))
		if lastmessageread > currentlastmessageread then
			C.SetUserData(userdataid, tostring(lastmessageread))
			C.NotifyChatMessageRead()
		end
	end
end

function menu.onSelectElement(uitable, modified, row)
end

function menu.onTableRightMouseClick(uitable, row, posx, posy)
	if uitable == menu.chatTable then
		local rowdata = menu.rowDataMap[uitable] and menu.rowDataMap[uitable][row]
		if type(rowdata) == "table" then
			local username, userid = OnlineGetUserName()
			if rowdata.authorid ~= userid then
				local x, y = GetLocalMousePosition()
				if x == nil then
					-- gamepad case
					x = posx
					y = -posy
				end

				menu.contextMenuMode = "report"
				menu.contextMenuData = { rowdata = rowdata }
				menu.createContextFrame(rowdata, x + Helper.viewWidth / 2, Helper.viewHeight / 2 - y, Helper.scaleX(config.contextMenuWidth))
			end
		end
	end
end

function menu.onTableMouseOver(uitable, row)
	menu.mouseover[uitable] = true
end

function menu.onTableMouseOut(uitable, row)
	menu.mouseover[uitable] = nil
end

function menu.onRowChangedSound(row, rowdata, uitable, layer, modified, input, source)
	if not menu.dragging then
		PlaySound("ui_positive_hover_normal")
	end
end

function menu.onButtonOverSound(uitable, row, col, button, input)
	if not menu.dragging then
		if not menu.sound_selectedelement or button ~= menu.sound_selectedelement then
			if input == "mouse" then
				if (not menu.sound_buttonOverLock) then
					PlaySound("ui_positive_hover_normal")
					menu.sound_buttonOverLock = true
				end
			end
		end
		menu.sound_selectedelement = button
	end
end

function menu.closeMenu()
	Helper.clearChatUpdateHandler()
	Helper.clearFrame(menu, config.layer)
	menu.closeContextMenu()
	menu.cleanup()
end

function menu.onCloseElement(dueToClose, layer)
	if layer == config.contextLayer then
		menu.closeContextMenu()
		return
	end
	menu.closeMenu()
end

function menu.callback(param)
	if param == "unlock" then
		menu.islocked = nil
	end
end

--- init ---

init()
