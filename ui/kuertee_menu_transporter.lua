local ffi = require ("ffi")
local C = ffi.C
local Lib = require ("extensions.sn_mod_support_apis.lua_library")
local transporterMenu
local origFuncs = {}
local newFuncs = {}
local callbacks = {}
local function init ()
	DebugError ("kuertee_menu_transporter.init")
	transporterMenu = Lib.Get_Egosoft_Menu ("TransporterMenu")
	transporterMenu.registerCallback = newFuncs.registerCallback
	origFuncs.addEntry = transporterMenu.addEntry
	origFuncs.display = transporterMenu.display
	transporterMenu.addEntry = newFuncs.addEntry
	transporterMenu.display = newFuncs.display
end
function newFuncs.registerCallback (callbackName, callbackFunction)
	-- DebugError ("kuertee_menu_transporter.lua.registerCallback " .. tostring (callbackName) .. " " .. tostring (callbackFunction))
	-- note 1: format is generally [function name]_[action]. e.g.: in kuertee_menu_transporter.lua, "display_on_set_room_active" overrides the room's active property with the return of the callback.
	-- note 2: events have the word "_on_" followed by a PRESET TENSE verb. e.g.: in kuertee_menu_transporter.lua, "display_on_set_buttontable" is called after all of the rows of buttontable are set.
	-- note 3: new callbacks can be added or existing callbacks can be edited. but commit your additions/changes to the mod's GIT repository.
	-- note 4: search for the callback names to see where they are executed.
	-- note 5: if a callback requires a return value, return it in an object var. e.g. "display_on_set_room_active" requires a return of {active = true | false}.
	-- available callbacks:
	-- addEntry_on_set_room_name
	-- display_on_set_room_active
	-- display_on_set_buttontable
	--
	if callbacks [callbackName] == nil then
		callbacks [callbackName] = {}
	end
	table.insert (callbacks [callbackName], callbackFunction)
end
function newFuncs.addEntry(ftable, target, indent, parentcomponent)
	local menu = transporterMenu

	local componentIndent = ""
	local subtargetIndent = "   "
	for i = 1, indent do
		componentIndent = componentIndent .. "   "
		subtargetIndent = subtargetIndent .. "   "
	end

	local displaysubtargets = false
	for _, subtarget in ipairs(target.subtargets) do
		local display = true
		local room = C.GetRoomForTransporter(subtarget)
		if room ~= 0 then
			local dockedships = {}
			if ffi.string(C.GetComponentClass(room)) == "dockingbay" then
				Helper.ffiVLA(dockedships, "UniverseID", C.GetNumDockedShips, C.GetDockedShips, room, "player")
				if #dockedships == 0 then
					display = false
				end
			end
		end
		if display then
			displaysubtargets = true
			break
		end
	end

	local row = ftable:addRow({ target = target.directtarget, issubtarget = false, hassubentries = (#target.subcomponents > 0) or displaysubtargets }, { bgColor = Helper.color.transparent })
	local name = ffi.string(C.GetComponentName(target.component))

	local font = Helper.standardFont
	local color = menu.white
	if GetComponentData(ConvertStringTo64Bit(tostring(target.component)), "isplayerowned") then
		color = menu.green
	end
	local objectid
	if C.IsComponentClass(target.component, "ship") then
		objectid = ffi.string(C.GetObjectIDCode(target.component))
	end
	if target.component == menu.topcontext then
		name = ffi.string(C.GetTransporterLocationName(target.directtarget))
		if menu.checkPlayerProperty(target.directtarget) then
			color = menu.green
		end
	end
	local current = ""
	if target.iscurrent then
		current = " [" .. ReadText(1001, 6301) .. "]"
		if not menu.preselectrow then
			menu.preselectrow = row.index
		end
	end
	if target.directtarget then
		local ismissiontarget = false
		if ffi.string(C.GetActiveObjectiveType()) == "usespacesuit" then
			ismissiontarget = target.type == "zone"
		else
			local locationcomponent = C.GetTransporterLocationComponent(target.directtarget) -- Note: context can be NULL if the component is a zone, which is the case for the space suit target
			ismissiontarget = (locationcomponent ~= 0) and (not displaysubtargets) and (not target.nomissiontarget) and GetComponentData(ConvertStringTo64Bit(tostring(locationcomponent)), "ismissiontarget")
		end
		if ismissiontarget then
			font = Helper.standardFontBold
			color = Helper.color.mission
		end
		if (menu.currentselection.target == target.directtarget) then
			menu.buttontext = ReadText(1001, 6303)
			if (target.type == "ship") or (target.type == "cockpit") then
				if C.IsComponentClass(target.component, "ship_m") or C.IsComponentClass(target.component, "ship_s") then
					menu.infotext = string.format(ReadText(1001, 6308), ffi.string(C.GetComponentName(target.component)))
				else
					menu.infotext = string.format(ReadText(1001, 6307), ffi.string(C.GetComponentName(target.component)))
				end
			elseif target.type == "parent" then
				menu.infotext = ReadText(1001, 6309)
			elseif target.type == "zone" then
				menu.infotext = ReadText(1001, 6311)
				menu.buttontext = ReadText(1001, 6312)
			elseif target.type == "dyninterior" then
				menu.infotext = string.format(ReadText(1001, 6306), name)
			elseif target.type == "walkablemodule" then
				menu.infotext = string.format(ReadText(1001, 6305), ffi.string(C.GetComponentName(parentcomponent)))
			end
		end
	end
	--[[ collapsing support disabled for now for better controller support
	if (#target.subcomponents > 0) or displaysubtargets then
		row[1]:createButton({ height = Helper.standardTextHeight }):setText(menu.extendedcategories[tostring(target.component)] and "-" or "+", { halign = "center" })
		row[1].handlers.onClick = function () return menu.buttonExtendCategory(tostring(target.component)) end
	end --]]

	-- start kuertee_lua_with_callbacks:
	if callbacks ["addEntry_on_set_room_name"] then
		local result
		for _, callback in ipairs (callbacks ["addEntry_on_set_room_name"]) do
			result = callback (name, target)
		end
		-- DebugError ("kuertee_menu_transporter.lua.addEntry_on_set_room_name name pre " .. tostring (name))
		name = result.name
		-- DebugError ("kuertee_menu_transporter.lua.addEntry_on_set_room_name name post " .. tostring (name))
	end
	-- end kuertee_lua_with_callbacks:

	if objectid then
		row[2]:createText(componentIndent .. name .. current, { color = color, font = font })
		row[3]:createText(objectid, { color = color, font = font, halign = "right" })
	else
		row[2]:setColSpan(2):createText(componentIndent .. name .. current, { color = color, font = font })
	end

	if menu.extendedcategories[tostring(target.component)] then
		local hasmissionshipsubtarget = false
		for _, subtarget in ipairs(target.subtargets) do
			if menu.hasShipOrRoomMissionTarget(subtarget) then
				hasmissionshipsubtarget = true
				break
			end
		end

		for _, subtarget in ipairs(target.subtargets) do
			local name, objectid, display, icon, isship = menu.getSubTargetName(subtarget)

			local font = Helper.standardFont
			local color = menu.white
			if menu.checkPlayerProperty(subtarget) then
				color = menu.green
			end
			if hasmissionshipsubtarget then
				if menu.hasShipOrRoomMissionTarget(subtarget) then
					font = Helper.standardFontBold
					color = Helper.color.mission
				end
			else
				if isship then
					local context = C.GetContextForTransporterCheck(subtarget.component) -- Note by Matthias: context can be NULL if the component is a zone, which is the case for the space suit target
					if (context ~= 0) and GetComponentData(ConvertStringTo64Bit(tostring(context)), "ismissiontarget") then
						font = Helper.standardFontBold
						color = Helper.color.mission
					end
				else
					local locationcomponent = C.GetTransporterLocationComponent(subtarget) -- Note: context can be NULL if the component is a zone, which is the case for the space suit target
					if (locationcomponent ~= 0) and GetComponentData(ConvertStringTo64Bit(tostring(locationcomponent)), "ismissiontarget") then
						font = Helper.standardFontBold
						color = Helper.color.mission
					end
				end
			end

			if display then
				local row = ftable:addRow({ target = subtarget, issubtarget = true }, { bgColor = Helper.color.transparent })
				local current = ""
				if menu.transportercomponent == subtarget.component and menu.transporterconnection == subtarget.connection then
					current = " [" .. ReadText(1001, 6301) .. "]"
					if not menu.preselectrow then
						menu.preselectrow = row.index
					end
				end
				if (menu.currentselection.target == subtarget) and (menu.currentselection.issubtarget == true) then
					menu.infotext = string.format(ReadText(1001, 6310), name)
				end

				if objectid then
					row[2]:createText(subtargetIndent .. string.format("\027[%s] %s", icon, name) .. current, { color = color, font = font })
					row[3]:createText(objectid, { color = color, font = font, halign = "right" })
				else
					row[2]:setColSpan(2):createText(subtargetIndent .. name .. current, { color = color, font = font })
				end
			end
		end

		for _, subcomponent in ipairs(target.subcomponents) do
			menu.addEntry(ftable, subcomponent, indent + 1, target.component)
		end
	end
end
function newFuncs.display()
	local menu = transporterMenu

	-- remove old data
	Helper.clearDataForRefresh(menu)

	local width = Helper.scaleX(720)
	local height = Helper.scaleY(400)

	local frame = Helper.createFrameHandle(menu, {
		width = (menu.extendInfo and 1 or 0.5) * width + 2 * Helper.borderSize,
		height = height + 2 * Helper.borderSize,
		x = (Helper.viewWidth - 0.5 * width) / 2,
		y = (Helper.viewHeight - height) / 2,
		backgroundID = "solid",
		backgroundColor = Helper.color.semitransparent,
	})

	menu.infotext = ""

	local ftable = frame:addTable(3, { tabOrder = 1, width = 0.5 * width, x = Helper.borderSize, y = Helper.borderSize })
	ftable:setColWidth(1, Helper.standardTextHeight)
	ftable:setColWidthPercent(3, 20)

	local row = ftable:addRow(false, { fixed = true })
	row[1]:setColSpan(3):createText(ReadText(1001, 6302), Helper.headerRow1Properties)

	local row = ftable:addRow(false, {  })
	row[1]:setColSpan(3):createText(ffi.string(C.GetComponentName(menu.topcontext)), Helper.subHeaderTextProperties)

	for _, target in ipairs(menu.targets) do
		menu.addEntry(ftable, target, 0, menu.topcontext)
	end

	ftable:setTopRow(menu.pretoprow)
	ftable:setSelectedRow(menu.preselectrow)
	menu.pretoprow = nil
	menu.preselectrow = nil

	local buttontable = frame:addTable(3, { tabOrder = 3, width = 0.5 * width, x = Helper.borderSize, skipTabChange = true })
	buttontable:setColWidth(1, 0.25 * width, false)
	local iconsize = Helper.scaleY(2 * Helper.standardTextHeight)
	buttontable:setColWidth(3, iconsize, false)

	local buttonrow = buttontable:addRow(true, { fixed = true })
	buttonrow[1]:setColSpan(2):createText(menu.infotext, { minRowHeight = 2 * Helper.standardTextHeight, wordwrap = true })
	local textheight = buttonrow[1]:getMinTextHeight(true)
	buttonrow[3]:createButton({ height = textheight, scaling = false }):setIcon(menu.extendInfo and "widget_arrow_left_01" or "widget_arrow_right_01", { width = iconsize, height = iconsize, y = (textheight - iconsize) / 2 })
	buttonrow[3].handlers.onClick = menu.buttonExpand

	local buttonrow = buttontable:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
	local active = (not menu.currentselection.hassubentries) and ((menu.transportercomponent ~= menu.currentselection.target.component) or (menu.transporterconnection ~= menu.currentselection.target.connection))
	-- start kuertee_lua_with_callbacks:
	if callbacks ["display_on_set_room_active"] then
		local activeCount = 0
		local callbacksCount = 0
		local result
		for _, callback in ipairs (callbacks ["display_on_set_room_active"]) do
			callbacksCount = callbacksCount + 1
			result = callback (active)
			if result.active then
				activeCount = activeCount + 1
			end
		end
		active = activeCount == callbacksCount
	end
	-- end kuertee_lua_with_callbacks:
	buttonrow[2]:setColSpan(2):createButton({ active = active, height = Helper.standardTextHeight }):setText(menu.buttontext, { halign = "center" })
	buttonrow[2].handlers.onClick = menu.buttonGoTo

	-- start kuertee_lua_with_callbacks:
	if callbacks ["display_on_set_buttontable"] then
		for _, callback in ipairs (callbacks ["display_on_set_buttontable"]) do
			callback (buttontable)
		end
	end
	-- end kuertee_lua_with_callbacks:

	buttontable.properties.y = height + Helper.borderSize - buttontable:getFullHeight()
	ftable.properties.maxVisibleHeight = buttontable.properties.y

	if menu.extendInfo then
		local infotable = frame:addTable(4, { tabOrder = 2, width = width - ftable.properties.width - Helper.borderSize, x = ftable.properties.x + ftable.properties.width + Helper.borderSize, y = Helper.borderSize, highlightMode = "off", skipTabChange = true })
		infotable:setColWidth(1, Helper.standardTextHeight)
		infotable:setColWidthPercent(3, 25)
		infotable:setColWidthPercent(4, 30)

		local row = infotable:addRow(false, { fixed = true })
		row[1]:setColSpan(4):createText(ReadText(1001, 2427), Helper.headerRow1Properties)

		menu.room = C.GetRoomForTransporter(menu.currentselection.target)
		if menu.room ~= 0 then
			--- SHIPS ---
			local internalstoragecontext
			if not menu.currentselection.issubtarget then
				internalstoragecontext = C.GetContextByClass(menu.room, "container", false)
			end
			local dockedships = {}
			if menu.currentselection.issubtarget then
				if ffi.string(C.GetComponentClass(menu.room)) == "dockingbay" then
					Helper.ffiVLA(dockedships, "UniverseID", C.GetNumDockedShips, C.GetDockedShips, menu.room, "player")
					if #dockedships > 0 then
						internalstoragecontext = dockedships[1]
					end
				end
			end

			dockedships = {}
			if internalstoragecontext then
				Helper.ffiVLA(dockedships, "UniverseID", C.GetNumDockedShips, C.GetDockedShips, internalstoragecontext, "player")
				for i = #dockedships, 1, -1 do
					if C.IsShipAtExternalDock(dockedships[i]) then
						table.remove(dockedships, i)
					end
				end
			end
			
			if #dockedships > 0 then
				local row = infotable:addRow(true, { bgColor = Helper.color.transparent })
				row[1]:createButton():setText(menu.extendedcategories["ships"] and "-" or "+", { halign = "center" })
				row[1].handlers.onClick = function () return menu.buttonExtendCategory("ships") end
				row[2]:setColSpan(3):createText(ReadText(1001, 6304), Helper.subHeaderTextProperties)
				if menu.extendedcategories["ships"] then
					table.sort(dockedships, Helper.sortUniverseIDName)
					for _, ship in ipairs(dockedships) do
						local ship64 = ConvertStringTo64Bit(tostring(ship))
						local font = Helper.standardFont
						local color = menu.white
						local shiptext = ffi.string(C.GetComponentName(ship))
						local objectid = ffi.string(C.GetObjectIDCode(ship))
						local ismissiontarget, isplayerowned = GetComponentData(ship64, "ismissiontarget", "isplayerowned")

						if ismissiontarget then
							font = Helper.standardFontBold
							color = Helper.color.mission
						elseif isplayerowned then
							color = menu.green
						end
						local row = infotable:addRow(true, { bgColor = Helper.color.transparent })
						row[2]:setColSpan(2):createText(shiptext, { color = color, font = font })
						row[4]:createText(objectid, { color = color, font = font, halign = "right" })
					end
				end
			end

			--- NPCS ---
			dockedships = {}
			if ffi.string(C.GetComponentClass(menu.room)) == "dockingbay" then
				Helper.ffiVLA(dockedships, "UniverseID", C.GetNumDockedShips, C.GetDockedShips, menu.room, nil)
			end
			menu.npcs = menu.getNPCs(menu.room, dockedships, menu.currentselection.issubtarget)
			if #menu.npcs > 0 then
				local row = infotable:addRow(true, { bgColor = Helper.color.transparent })
				row[1]:createButton():setText(menu.extendedcategories["npcs"] and "-" or "+", { halign = "center" })
				row[1].handlers.onClick = function () return menu.buttonExtendCategory("npcs") end
				row[2]:setColSpan(3):createText(ReadText(1001, 6300), Helper.subHeaderTextProperties)
				if menu.extendedcategories["npcs"] then
					for _, npc in ipairs(menu.npcs) do
						local name, typestring, typeicon, typename, isenemy, isplayerowned, ismissiontarget, postname, rolename = GetComponentData(npc, "name", "typestring", "typeicon", "typename", "isenemy", "isplayerowned", "ismissiontarget", "postname", "rolename")
						local font = Helper.standardFont
						local color = menu.white
						if ismissiontarget then
							font = Helper.standardFontBold
							color = Helper.color.mission
						elseif isenemy then
							color = menu.red
						elseif isplayerowned then
							color = menu.green
						end
						local title = postname
						if title == "" then
							title = rolename
							if title == "" then
								title = typename
							end
						end
						local row = infotable:addRow(true, { bgColor = Helper.color.transparent })
						row[2]:createText(title, { color = color, font = font })
						row[3]:setColSpan(2):createText(name, { color = color, font = font })
					end
				end
			end
		end

		infotable.properties.maxVisibleHeight = buttontable.properties.y
	end

	frame:display()
end
init ()
