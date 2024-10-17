-- param == { 0, 0, transporter, transporterconnection }

-- ffi setup
local ffi = require("ffi")
local C = ffi.C
ffi.cdef[[
	typedef struct {
		const char* factionID;
		const char* factionName;
		const char* factionIcon;
	} FactionDetails;
	typedef struct {
		UniverseID component;
		const char* connection;
	} UIComponentSlot;
	typedef uint64_t UniverseID;
	const char* GetActiveObjectiveType(void);
	const char* GetComponentClass(UniverseID componentid);
	const char* GetComponentName(UniverseID componentid);
	UniverseID GetContextByClass(UniverseID componentid, const char* classname, bool includeself);
	UniverseID GetContextForTransporterCheck(UniverseID positionalid);
	UniverseID GetSlotComponent(UIComponentSlot slot);
	uint32_t GetDockedShips(UniverseID* result, uint32_t resultlen, UniverseID dockingbayorcontainerid, const char* factionid);
	uint32_t GetNumDockedShips(UniverseID dockingbayorcontainerid, const char* factionid);
	uint32_t GetNumValidTransporterTargets2(UniverseID componentid, UIComponentSlot currentlocation);
	const char* GetObjectIDCode(UniverseID objectid);
	FactionDetails GetOwnerDetails(UniverseID componentid);
	UniverseID GetRoomForTransporter(UIComponentSlot transporter);
	UniverseID GetTransporterLocationComponent(UIComponentSlot transporter);
	const char* GetTransporterLocationName(UIComponentSlot transporter);
	uint32_t GetValidTransporterTargets2(UIComponentSlot* result, uint32_t resultlen, UniverseID componentid, UIComponentSlot currentlocation);
	bool IsComponentClass(UniverseID componentid, const char* classname);
	bool IsShipAtExternalDock(UniverseID shipid);
	void SetTrackedMenuFullscreen(const char* menu, bool fullscreen);
	void TransportPlayerToTarget(UIComponentSlot target);
]]

local menu = {
	name = "TransporterMenu",
	extendedcategories = {
		["ships"] = true,
		["npcs"] = true,
	},
}

local config = {
	sortOrder = {
		["dyninterior"] = 1,
		["cockpit"] = 2,
		["shipinterior"] = 3,
		["walkablemodule"] = 4,
		["ship"] = 5,
		["parent"] = 6,
		["zone"] = 7,
	},
	roomClassSortOrder = {
		["room"] = 1,
		["dockingbay"] = 2,
	},
}

-- kuertee start:
local callbacks = {}
-- kuertee end

local function init()
	Menus = Menus or { }
	table.insert(Menus, menu)
	if Helper then
		Helper.registerMenu(menu)
	end

	-- kuertee start:
	menu.init_kuertee()
	-- kuertee end
end

-- kuertee start:
function menu.init_kuertee ()
	menu.loadModLuas()
	-- DebugError("uix load success: " .. tostring(debug.getinfo(1).source))
end
-- kuertee end

function menu.cleanup()
	menu.transportercomponent = nil
	menu.transporterconnection = nil
	menu.targets = {}
	menu.currentselection = nil
	menu.npcs = {}
	menu.extendInfo = nil
	
	menu.refresh = nil
	
	menu.pretoprow = nil
	menu.preselectrow = nil

	menu.infotable = nil
	menu.selecttable = nil
end

-- Menu member functions

function menu.buttonGoTo()
	if (not menu.currentselection.hassubentries) or menu.currentselection.target then
		if (menu.transportercomponent ~= menu.currentselection.target.component) or (menu.transporterconnection ~= menu.currentselection.target.connection) then
			if C.IsComponentClass(menu.currentselection.target.component, "zone") then
				-- space suit case
				Helper.closeMenuAndOpenNewMenu(menu, "UserQuestionMenu", { 0, 0, "transporter", { menu.currentselection.target.component, menu.currentselection.target.connection } })
			else
				C.TransportPlayerToTarget(menu.currentselection.target)
				Helper.closeMenuAndReturn(menu)
			end
			menu.cleanup()
		end
	end
end

function menu.buttonExtendCategory(category)
	if menu.extendedcategories[category] then
		menu.extendedcategories[category] = nil
	else
		menu.extendedcategories[category] = true
	end
	menu.pretoprow = GetTopRow(menu.selecttable)
	menu.preselectrow = Helper.currentTableRow[menu.selecttable]
	menu.display()
end

function menu.buttonExpand(category)
	menu.extendInfo = not menu.extendInfo
	menu.pretoprow = GetTopRow(menu.selecttable)
	menu.preselectrow = Helper.currentTableRow[menu.selecttable]
	menu.display()
end

function menu.onShowMenu()
	C.SetTrackedMenuFullscreen(menu.name, false)
	menu.transportercomponent = ConvertIDTo64Bit(menu.param[3])
	menu.transporterconnection = ffi.string(menu.param[4])

	menu.extendInfo = false

	menu.topcontext = menu.transportercomponent
	while true do
		if C.IsComponentClass(menu.topcontext, "ship_m") or C.IsComponentClass(menu.topcontext, "ship_s") then
			break
		end
		local context = C.GetContextByClass(menu.topcontext, "container", false)
		if context ~= 0 then
			menu.topcontext = context
		else
			break
		end
	end

	menu.targets = {}
	local targets = {}
	if menu.transportercomponent ~= 0 then
		local curLocationSlot = ffi.new("UIComponentSlot")
		curLocationSlot.component = menu.transportercomponent
		curLocationSlot.connection = menu.transporterconnection

		local n = C.GetNumValidTransporterTargets2(menu.transportercomponent, curLocationSlot)
		local buf = ffi.new("UIComponentSlot[?]", n)
		n = C.GetValidTransporterTargets2(buf, n, menu.transportercomponent, curLocationSlot)
		local found = false
		for i = 0, n - 1 do
			local component = buf[i].component
			local connection = ffi.string(buf[i].connection)
			table.insert(targets, { component = component, connection = connection })
			if (component == menu.transportercomponent) and (connection == menu.transporterconnection) then
				found = true
			end
		end
		if not found then
			table.insert(targets, { component = menu.transportercomponent, connection = menu.transporterconnection })
		end
	end

	for _, target in ipairs(targets) do
		local iscurrent
		if menu.transportercomponent == target.component and menu.transporterconnection == target.connection then
			iscurrent = true
		end
		local parent, roomtype = GetComponentData(ConvertStringTo64Bit(tostring(target.component)), "parent", "roomtype")
		parent = ConvertIDTo64Bit(parent)
		if C.IsComponentClass(parent, "walkablemodule") then
			local containercontext = C.GetContextByClass(parent, "container", false)
			if containercontext == menu.topcontext then
				local i = menu.findArrayEntry(menu.targets, parent)
				if i == nil then
					table.insert(menu.targets, { type = "walkablemodule", component = parent, directtarget = target, subtargets = { target }, subcomponents = {}, iscurrent = iscurrent, hasshiptradercorner = roomtype == "shiptradercorner", hastradercorner = roomtype == "tradercorner" })
					menu.extendedcategories[tostring(parent)] = true
				else
					if iscurrent then
						menu.targets[i].iscurrent = iscurrent
					end
					if roomtype == "shiptradercorner" then
						menu.targets[i].hasshiptradercorner = true
					end
					if roomtype == "tradercorner" then
						menu.targets[i].hastradercorner = true
					end
					table.insert(menu.targets[i].subtargets, target)
				end
			else
				local i = menu.findArrayEntry(menu.targets, containercontext)
				if i == nil then
					table.insert(menu.targets, { type = "walkablemodule", component = containercontext, subtargets = {}, subcomponents = { { component = parent, directtarget = target, subtargets = { target }, subcomponents = {}, iscurrent = iscurrent } } })
					menu.extendedcategories[tostring(containercontext)] = true
				else
					local subcomponents = menu.targets[i].subcomponents
					local j = menu.findArrayEntry(subcomponents, parent)
					if j == nil then
						table.insert(subcomponents, { type = "walkablemodule", component = parent, directtarget = target, subtargets = { target }, subcomponents = {}, iscurrent = iscurrent })
						menu.extendedcategories[tostring(parent)] = true
					else
						if iscurrent then
							subcomponents[j].iscurrent = iscurrent
						end
						table.insert(subcomponents[j].subtargets, target)
					end
				end
			end
		elseif C.IsComponentClass(parent, "ship") then
			local iscockpit, isexit = false, false
			local room = C.GetRoomForTransporter(target)
			if room ~= 0 then
				if C.IsComponentClass(room, "cockpit") then
					iscockpit = true
				elseif C.GetContextByClass(room, "container", false) ~= parent then
					isexit = true
				end
			end
			if isexit then
				-- If ship is mission target, the exit should not be highlighted as mission target
				local shipismissiontarget = GetComponentData(ConvertStringTo64Bit(tostring(parent)), "ismissiontarget")
				table.insert(menu.targets, { type = "parent", component = C.GetContextByClass(parent, "container", false), directtarget = target, subtargets = {}, subcomponents = {}, iscurrent = iscurrent, nomissiontarget = shipismissiontarget })
			else
				local i = menu.findArrayEntry(menu.targets, parent)
				if i == nil then
					if iscockpit then
						local type = "ship"
						local subtarget = target
						if parent == menu.topcontext then
							type = "cockpit"
							subtarget = nil
						end
						table.insert(menu.targets, { type = type, component = parent, directtarget = target, subtargets = { subtarget }, subcomponents = {}, iscurrent = iscurrent })
					else
						table.insert(menu.targets, { type = "ship", component = parent, subtargets = { target }, subcomponents = {}, iscurrent = iscurrent })
					end
					menu.extendedcategories[tostring(parent)] = true
				else
					if iscurrent then
						menu.targets[i].iscurrent = iscurrent
					end
					if iscockpit then
						if parent == menu.topcontext then
							menu.targets[i].type = "cockpit"
						else
							table.insert(menu.targets[i].subtargets, target)
						end
						menu.targets[i].directtarget = target
					else
						table.insert(menu.targets[i].subtargets, target)
					end
				end
			end
		elseif C.IsComponentClass(parent, "navcontext") then
			local containercontext = C.GetContextByClass(parent, "container", true)
			if containercontext == menu.topcontext then
				table.insert(menu.targets, { type = "dyninterior", component = parent, directtarget = target, subtargets = {}, subcomponents = {}, iscurrent = iscurrent })
			else
				local i = menu.findArrayEntry(menu.targets, containercontext)
				if i == nil then
					table.insert(menu.targets, { type = "ship", component = containercontext, subtargets = {}, subcomponents = { { component = parent, directtarget = target, subtargets = {}, subcomponents = {}, iscurrent = iscurrent } } })
					menu.extendedcategories[tostring(containercontext)] = true
				else
					local subcomponents = menu.targets[i].subcomponents
					local j = menu.findArrayEntry(subcomponents, parent)
					if j == nil then
						table.insert(subcomponents, { type = "ship", component = parent, directtarget = target, subtargets = {}, subcomponents = {}, iscurrent = iscurrent })
						menu.extendedcategories[tostring(parent)] = true
					else
						if iscurrent then
							subcomponents[j].iscurrent = iscurrent
						end
						table.insert(subcomponents[j].subtargets, target)
					end
				end
			end
		elseif C.IsComponentClass(parent, "ventureplatform") or C.IsComponentClass(parent, "connectionmodule") then
			table.insert(menu.targets, { type = "dyninterior", component = parent, directtarget = target, subtargets = {}, subcomponents = {}, iscurrent = iscurrent })
		elseif C.IsComponentClass(target.component, "ship") then
			local iscockpit, isexit = false, false
			local room = C.GetRoomForTransporter(target)
			if room ~= 0 then
				if C.IsComponentClass(room, "cockpit") then
					iscockpit = true
				elseif C.GetContextByClass(room, "container", false) ~= parent then
					isexit = true
				end
			end
			if isexit then
				-- If ship is mission target, the exit should not be highlighted as mission target
				local shipismissiontarget = GetComponentData(ConvertStringTo64Bit(tostring(target.component)), "ismissiontarget")
				table.insert(menu.targets, { type = "parent", component = C.GetContextByClass(parent, "container", false), directtarget = target, subtargets = {}, subcomponents = {}, iscurrent = iscurrent, nomissiontarget = shipismissiontarget })
			else
				local i = menu.findArrayEntry(menu.targets, target.component)
				if i == nil then
					if iscockpit then
						local subtarget = target
						if target.component == menu.topcontext then
							subtarget = nil
						end
						table.insert(menu.targets, { type = "cockpit", component = target.component, directtarget = target, subtargets = { subtarget }, subcomponents = {}, iscurrent = iscurrent })
					else
						table.insert(menu.targets, { type = "shipinterior", component = target.component, subtargets = { target }, subcomponents = {}, iscurrent = iscurrent })
					end
					menu.extendedcategories[tostring(target.component)] = true
				else
					if iscockpit then
						menu.targets[i].type = "cockpit"
						menu.targets[i].directtarget = target
						if target.component ~= menu.topcontext then
							table.insert(menu.targets[i].subtargets, target)
						end
					else
						table.insert(menu.targets[i].subtargets, target)
					end
				end
			end
		elseif C.IsComponentClass(target.component, "zone") then
			table.insert(menu.targets, { type = "zone", component = menu.topcontext, directtarget = target, subtargets = {}, subcomponents = {}, iscurrent = iscurrent })
		end
	end
	table.sort(menu.targets, menu.sortTargets)

	for _, target in ipairs(menu.targets) do
		table.sort(target.subtargets, menu.sortSubTargets)
	end
	menu.currentselection = {}
	menu.currentselection.target = ffi.new("UIComponentSlot")
	menu.currentselection.target.component = menu.transportercomponent
	menu.currentselection.target.connection = menu.transporterconnection

	menu.display()
end

function menu.onShowMenuSound()
	-- no sound
end

function menu.sortTargets(a, b)
	if config.sortOrder[a.type] == config.sortOrder[b.type] then
		if a.directtarget and b.directtarget then
			if a.iscurrent ~= b.iscurrent then
				return a.iscurrent and (not b.iscurrent)
			end
			if a.hasshiptradercorner ~= b.hasshiptradercorner then
				return a.hasshiptradercorner and (not b.hasshiptradercorner)
			end
			if a.hastradercorner ~= b.hastradercorner then
				return a.hastradercorner and (not b.hastradercorner)
			end
			return ffi.string(C.GetTransporterLocationName(a.directtarget)) < ffi.string(C.GetTransporterLocationName(b.directtarget))
		end
		return a.directtarget and not b.directtarget
	end
	return config.sortOrder[a.type] < config.sortOrder[b.type]
end

function menu.sortSubTargets(a, b)
	local aroom = ffi.string(C.GetComponentClass(C.GetRoomForTransporter(a)))
	local broom = ffi.string(C.GetComponentClass(C.GetRoomForTransporter(b)))
	if aroom == broom then
		return menu.getSubTargetName(a) < menu.getSubTargetName(b)
	end
	return (config.roomClassSortOrder[aroom] or 0) < (config.roomClassSortOrder[broom] or 0)
end

function menu.getSubTargetName(subtarget)
	local display = true
	local name = ffi.string(C.GetTransporterLocationName(subtarget))
	local objectid, icon, isship
	local room = C.GetRoomForTransporter(subtarget)
	if room ~= 0 then
		local dockedships = {}
		if ffi.string(C.GetComponentClass(room)) == "dockingbay" then
			Helper.ffiVLA(dockedships, "UniverseID", C.GetNumDockedShips, C.GetDockedShips, room, "player")
			if #dockedships > 0 then
				name = ffi.string(C.GetComponentName(dockedships[1]))
				objectid = ffi.string(C.GetObjectIDCode(dockedships[1]))
				icon = GetComponentData(ConvertStringTo64Bit(tostring(dockedships[1])), "icon")
				isship = true
			else
				name = ffi.string(C.GetComponentName(room))
				display = GetComponentData(ConvertStringTo64Bit(tostring(room)), "ismissiontarget")
			end
		end
	end

	return name, objectid, display, icon, isship
end

function menu.hasShipOrRoomMissionTarget(subtarget)
	local room = C.GetRoomForTransporter(subtarget)
	if room ~= 0 then
		if ffi.string(C.GetComponentClass(room)) == "dockingbay" then
			local dockedships = {}
			Helper.ffiVLA(dockedships, "UniverseID", C.GetNumDockedShips, C.GetDockedShips, room, "player")
			if #dockedships > 0 then
				return GetComponentData(ConvertStringTo64Bit(tostring(dockedships[1])), "ismissiontarget")
			end
		end
		return GetComponentData(ConvertStringTo64Bit(tostring(room)), "ismissiontarget")
	end
end

function menu.findArrayEntry(array, component)
	for i, entry in ipairs(array) do
		if entry.component == component then
			return i
		end
	end
end

function menu.addEntry(ftable, target, indent, parentcomponent)
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

	local row = ftable:addRow({ target = target.directtarget, issubtarget = false, hassubentries = (#target.subcomponents > 0) or displaysubtargets }, {  })
	local name = ffi.string(C.GetComponentName(target.component))

	local font = Helper.standardFont
	local color = Color["text_normal"]
	if GetComponentData(ConvertStringTo64Bit(tostring(target.component)), "isplayerowned") then
		color = Color["text_player"]
	end
	local objectid
	if C.IsComponentClass(target.component, "ship") then
		objectid = ffi.string(C.GetObjectIDCode(target.component))
	end
	if target.component == menu.topcontext then
		name = ffi.string(C.GetTransporterLocationName(target.directtarget))
		if menu.checkPlayerProperty(target.directtarget) then
			color = Color["text_player"]
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
			ismissiontarget = (locationcomponent ~= 0) and (not target.nomissiontarget) and GetComponentData(ConvertStringTo64Bit(tostring(locationcomponent)), "ismissiontarget")
		end
		if ismissiontarget then
			font = Helper.standardFontBold
			color = Color["text_mission"]
		end
		if (menu.currentselection.target == target.directtarget) then
			menu.buttontext = ReadText(1001, 6303)
			if (target.type == "ship") or (target.type == "cockpit") then
				if C.IsComponentClass(target.component, "ship_m") or C.IsComponentClass(target.component, "ship_s") then
					menu.infotext = string.format(ReadText(1001, 6308), ffi.string(C.GetComponentName(target.component)))
				elseif C.IsComponentClass(target.component, "navcontext") then
					menu.infotext = string.format(ReadText(1001, 6306), name)
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

	-- kuertee start: callback
	if callbacks ["addEntry_on_set_room_name"] then
		local result
		for _, callback in ipairs (callbacks ["addEntry_on_set_room_name"]) do
			result = callback (name, target)
			if result then
				-- DebugError ("kuertee_menu_transporter.addEntry_on_set_room_name name pre " .. tostring (name))
				name = result.name
				-- DebugError ("kuertee_menu_transporter.addEntry_on_set_room_name name post " .. tostring (name))
			end
		end
	end
	-- kuertee end: callback

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
			local color = Color["text_normal"]
			if menu.checkPlayerProperty(subtarget) then
				color = Color["text_player"]
			end
			if hasmissionshipsubtarget then
				if menu.hasShipOrRoomMissionTarget(subtarget) then
					font = Helper.standardFontBold
					color = Color["text_mission"]
				end
			else
				if isship then
					local context = C.GetContextForTransporterCheck(subtarget.component) -- Note by Matthias: context can be NULL if the component is a zone, which is the case for the space suit target
					if (context ~= 0) and GetComponentData(ConvertStringTo64Bit(tostring(context)), "ismissiontarget") then
						font = Helper.standardFontBold
						color = Color["text_mission"]
					end
				else
					local locationcomponent = C.GetTransporterLocationComponent(subtarget) -- Note: context can be NULL if the component is a zone, which is the case for the space suit target
					if (locationcomponent ~= 0) and GetComponentData(ConvertStringTo64Bit(tostring(locationcomponent)), "ismissiontarget") then
						font = Helper.standardFontBold
						color = Color["text_mission"]
					end
				end
			end

			if display then
				local row = ftable:addRow({ target = subtarget, issubtarget = true }, {  })
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

function menu.display()
	-- remove old data
	Helper.clearDataForRefresh(menu)

	local width = Helper.scaleX(720)
	local height = Helper.scaleY(400)

	local frame = Helper.createFrameHandle(menu, {
		width = (menu.extendInfo and 1 or 0.5) * width + 2 * Helper.borderSize,
		height = height + 2 * Helper.borderSize,
		x = (Helper.viewWidth - 0.5 * width) / 2,
		y = (Helper.viewHeight - height) / 2,
	})
	frame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	menu.infotext = ""

	local ftable = frame:addTable(3, { tabOrder = 1, width = 0.5 * width, x = Helper.borderSize, y = Helper.borderSize })
	ftable:setColWidth(1, Helper.standardTextHeight)
	ftable:setColWidthPercent(3, 20)

	local row = ftable:addRow(false, { fixed = true, bgColor = Color["row_background_blue"] })
	row[1]:setColSpan(3):createText(ReadText(1001, 6302), Helper.headerRow1Properties)

	local row = ftable:addRow(false, { bgColor = Color["row_background_blue"] })
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

	local buttonrow = buttontable:addRow(true, { fixed = true, bgColor = Color["row_background_blue"] })
	buttonrow[1]:setColSpan(2):createText(menu.infotext, { minRowHeight = 2 * Helper.standardTextHeight, wordwrap = true })
	local textheight = buttonrow[1]:getMinTextHeight(true)
	buttonrow[3]:createButton({ height = textheight, scaling = false }):setIcon(menu.extendInfo and "widget_arrow_left_01" or "widget_arrow_right_01", { width = iconsize, height = iconsize, y = (textheight - iconsize) / 2 })
	buttonrow[3].handlers.onClick = menu.buttonExpand

	local buttonrow = buttontable:addRow(true, { fixed = true })
	local active = ((not menu.currentselection.hassubentries) or menu.currentselection.target) and ((menu.transportercomponent ~= menu.currentselection.target.component) or (menu.transporterconnection ~= menu.currentselection.target.connection))

	-- kuertee start: callback
	if callbacks ["display_on_set_room_active"] then
		local activeCount = 0
		local callbacksCount = 0
		local result
		for _, callback in ipairs (callbacks ["display_on_set_room_active"]) do
			callbacksCount = callbacksCount + 1
			result = callback (active)
			if result and result.active then
				activeCount = activeCount + 1
			end
		end
		active = activeCount == callbacksCount
	end
	-- kuertee end: callback

	buttonrow[2]:setColSpan(2):createButton({ active = active, height = Helper.standardTextHeight }):setText(menu.buttontext, { halign = "center" })
	buttonrow[2].handlers.onClick = menu.buttonGoTo

	-- kuertee start: callback
	if callbacks ["display_on_set_buttontable"] then
		for _, callback in ipairs (callbacks ["display_on_set_buttontable"]) do
			callback (buttontable)
		end
	end
	-- kuertee end: callback

	buttontable.properties.y = height + Helper.borderSize - buttontable:getFullHeight()
	ftable.properties.maxVisibleHeight = buttontable.properties.y

	if menu.extendInfo then
		local infotable = frame:addTable(4, { tabOrder = 2, width = width - ftable.properties.width - Helper.borderSize, x = ftable.properties.x + ftable.properties.width + Helper.borderSize, y = Helper.borderSize, highlightMode = "off", skipTabChange = true })
		infotable:setColWidth(1, Helper.standardTextHeight)
		infotable:setColWidthPercent(3, 25)
		infotable:setColWidthPercent(4, 30)

		local row = infotable:addRow(false, { fixed = true, bgColor = Color["row_background_blue"] })
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
				local row = infotable:addRow(true, {  })
				row[1]:createButton():setText(menu.extendedcategories["ships"] and "-" or "+", { halign = "center" })
				row[1].handlers.onClick = function () return menu.buttonExtendCategory("ships") end
				row[2]:setColSpan(3):createText(ReadText(1001, 6304), Helper.subHeaderTextProperties)
				if menu.extendedcategories["ships"] then
					table.sort(dockedships, Helper.sortUniverseIDName)
					for _, ship in ipairs(dockedships) do
						local ship64 = ConvertStringTo64Bit(tostring(ship))
						local font = Helper.standardFont
						local color = Color["text_normal"]
						local shiptext = ffi.string(C.GetComponentName(ship))
						local objectid = ffi.string(C.GetObjectIDCode(ship))
						local ismissiontarget, isplayerowned = GetComponentData(ship64, "ismissiontarget", "isplayerowned")

						if ismissiontarget then
							font = Helper.standardFontBold
							color = Color["text_mission"]
						elseif isplayerowned then
							color = Color["text_player"]
						end
						local row = infotable:addRow(true, {  })
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
				local row = infotable:addRow(true, {  })
				row[1]:createButton():setText(menu.extendedcategories["npcs"] and "-" or "+", { halign = "center" })
				row[1].handlers.onClick = function () return menu.buttonExtendCategory("npcs") end
				row[2]:setColSpan(3):createText(ReadText(1001, 6300), Helper.subHeaderTextProperties)
				if menu.extendedcategories["npcs"] then
					for _, npc in ipairs(menu.npcs) do
						local name, typestring, typeicon, typename, isenemy, isplayerowned, ismissiontarget, postname, rolename = GetComponentData(npc, "name", "typestring", "typeicon", "typename", "isenemy", "isplayerowned", "ismissiontarget", "postname", "rolename")
						local font = Helper.standardFont
						local color = Color["text_normal"]
						if ismissiontarget then
							font = Helper.standardFontBold
							color = Color["text_mission"]
						elseif isenemy then
							color = Color["text_enemy"]
						elseif isplayerowned then
							color = Color["text_player"]
						end
						local title = postname
						if title == "" then
							title = rolename
							if title == "" then
								title = typename
							end
						end
						local row = infotable:addRow(true, {  })
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

function menu.viewCreated(layer, ...)
	menu.selecttable, menu.infotable, menu.buttontable = ...
end

menu.updateInterval = 0.1

function menu.onUpdate()
	if menu.refresh and (menu.refresh < getElapsedTime()) then
		menu.display()
		menu.refresh = nil
	end
end

function menu.onRowChanged(row, rowdata)
	rowdata = Helper.getCurrentRowData(menu, menu.defaulttable)
	if type(rowdata) == "table" then
		if (menu.currentselection.target ~= rowdata.target) or (menu.currentselection.issubtarget ~= rowdata.issubtarget) then
			menu.currentselection = rowdata
			menu.pretoprow = GetTopRow(menu.selecttable)
			menu.preselectrow = Helper.currentTableRow[menu.defaulttable]
			menu.refresh = getElapsedTime() + 0.11
		end
	end
end

function menu.onSelectElement(uitable)
	if uitable == menu.defaulttable then
		menu.buttonGoTo()
	end
end

function menu.onCloseElement(dueToClose)
	Helper.closeMenu(menu, dueToClose)
	menu.cleanup()
end

function menu.getNPCs(room, ships, issubtarget)
	local rawnpcs = GetPrioritizedPlatformNPCs(ConvertStringTo64Bit(tostring(room)))
	local npcs = {}
	
	if not issubtarget then
		if C.GetContextByClass(room, "ship", false) ~= 0 then
			npcs = GetNPCs(ConvertStringTo64Bit(tostring(room)))
		else
			npcs = rawnpcs
		end
	end
	if issubtarget then
		for _, ship in ipairs(ships) do
			local npcs2 = GetNPCs(ConvertStringTo64Bit(tostring(ship)))
			for _, npc in ipairs(npcs2) do
				table.insert(npcs, npc)
			end
		end
		for _, npc in ipairs(rawnpcs) do
			if C.GetContextByClass(ConvertIDTo64Bit(npc), "room", false) == room then
				table.insert(npcs, npc)
			end
		end
	end
	for i = #npcs, 1, -1 do
		-- filter out non-mission crowd actors
		if GetComponentData(npcs[i], "typestring") == "crowd" and GetComponentData(npcs[i], "ismissionactor") == false then
			table.remove(npcs, i)
		end
	end

	return npcs
end

function menu.checkPlayerProperty(transporter)
	if ffi.string(C.GetOwnerDetails(transporter.component).factionID) == "player" then
		return true
	end
	local room = C.GetRoomForTransporter(transporter)
	if room ~= 0 then
		local dockedships = {}
		if ffi.string(C.GetComponentClass(room)) == "dockingbay" then
			Helper.ffiVLA(dockedships, "UniverseID", C.GetNumDockedShips, C.GetDockedShips, room, nil)
			for _, ship in ipairs(dockedships) do
				if ffi.string(C.GetOwnerDetails(ship).factionID) == "player" then
					return true
				end
			end
		end

		local npcs = menu.getNPCs(room, dockedships)
		for _, npc in ipairs(npcs) do
			if GetComponentData(npc, "isplayerowned") then
				return true
			end
		end
	end

	return false
end

-- kuertee start:
function menu.registerCallback (callbackName, callbackFunction)
	-- note 1: format is generally [function name]_[action]. e.g.: in kuertee_menu_transporter, "display_on_set_room_active" overrides the room's active property with the return of the callback.
	-- note 2: events have the word "_on_" followed by a PRESET TENSE verb. e.g.: in kuertee_menu_transporter, "display_on_set_buttontable" is called after all of the rows of buttontable are set.
	-- note 3: new callbacks can be added or existing callbacks can be edited. but commit your additions/changes to the mod's GIT repository.
	-- note 4: search for the callback names to see where they are executed.
	-- note 5: if a callback requires a return value, return it in an object var. e.g. "display_on_set_room_active" requires a return of {active = true | false}.

	-- to find callbacks available for this menu,
	-- reg-ex search for callbacks.*\[\".*\]

	if callbacks [callbackName] == nil then
		callbacks [callbackName] = {}
	end
	table.insert (callbacks [callbackName], callbackFunction)
end

function menu.deregisterCallback(callbackName, callbackFunction)
	-- for i, callback in ipairs(callbacks[callbackName]) do
	if callbacks[callbackName] and #callbacks[callbackName] > 0 then
		for i = #callbacks[callbackName], 1, -1 do
			if callbacks[callbackName][i] == callbackFunction then
				table.remove(callbacks[callbackName], i)
			end
		end
	end
end

function menu.loadModLuas()
	if Helper then
		Helper.loadModLuas(menu.name, "menu_transporter_uix")
	end
end
-- kuertee end

init()
