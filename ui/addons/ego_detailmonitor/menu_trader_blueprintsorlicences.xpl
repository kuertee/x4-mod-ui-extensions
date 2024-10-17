-- param == { 0, 0, traderentity, mode }

-- modes:	- "blueprint"
--			- "licence"

-- ffi setup
local ffi = require("ffi")
local C = ffi.C
ffi.cdef[[
	typedef uint64_t UniverseID;
	typedef struct {
		const char* name;
		const char* icon;
	} LicenceInfo;
	typedef struct {
		const char* macro;
		const char* ware;
		const char* productionmethodid;
	} UIBlueprint;
	uint32_t GetNumWares(const char* tags, bool research, const char* licenceownerid, const char* exclusiontags);
	uint32_t GetBlueprints(UIBlueprint* result, uint32_t resultlen, const char* set, const char* category, const char* macroname);
	bool GetLicenceInfo(LicenceInfo* result, const char* factionid, const char* licenceid);
	const char* GetMacroClass(const char* macroname);
	uint32_t GetNumBlueprints(const char* set, const char* category, const char* macroname);
	UniverseID GetPlayerComputerID(void);
	uint32_t GetWares(const char** result, uint32_t resultlen, const char* tags, bool research, const char* licenceownerid, const char* exclusiontags);
	void LearnBlueprint(const char* wareid);
]]

-- menu variable - used by Helper and used for dynamic variables (e.g. inventory content, etc.)
local menu = {
	name = "BlueprintOrLicenceTraderMenu"
}

-- config variable - put all static setup here
local config = {
	deployableOrder = {
		["satellite"]		= 1,
		["navbeacon"]		= 2,
		["resourceprobe"]	= 3,
		["lasertower"]		= 4,
		["mine"]			= 5,
		[""]				= 6,
	},
	blueprintorder = {
		["module"] = {
			{ key = "moduletypes_production" },
			{ key = "moduletypes_build" },
			{ key = "moduletypes_storage" },
			{ key = "moduletypes_habitation" },
			{ key = "moduletypes_welfare" },
			{ key = "moduletypes_defence" },
			{ key = "moduletypes_dock" },
			{ key = "moduletypes_processing" },
			{ key = "moduletypes_other" },
			{ key = "moduletypes_venture" },
		},
		["ship"] = {
			{ key = "ship_xl" },
			{ key = "ship_l" },
			{ key = "ship_m" },
			{ key = "ship_s" },
		},
	},
	categorynames = {
		["moduletypes_production"]		= ReadText(1001, 2421),
		["moduletypes_build"]			= ReadText(1001, 2439),
		["moduletypes_storage"]			= ReadText(1001, 2422),
		["moduletypes_habitation"]		= ReadText(1001, 2451),
		["moduletypes_welfare"]			= ReadText(1001, 9620),
		["moduletypes_defence"]			= ReadText(1001, 2424),
		["moduletypes_dock"]			= ReadText(1001, 2452),
		["moduletypes_processing"]		= ReadText(1001, 9621),
		["moduletypes_other"]			= ReadText(1001, 2453),
		["moduletypes_venture"]			= ReadText(1001, 2454),
		["ship_xl"]						= ReadText(1001, 11003),
		["ship_l"]						= ReadText(1001, 11002),
		["ship_m"]						= ReadText(1001, 11001),
		["ship_s"]						= ReadText(1001, 11000),
	}
}

-- kuertee start:
local callbacks = {}
-- kuertee end

-- init menu and register with Helper
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

-- cleanup variables in menu, no need for the menu variable to keep all the data while the menu is not active
function menu.cleanup()
	menu.playermoney = nil
	menu.totalprice = nil

	menu.blueprintstopurchase = {}
	menu.equipmenttagnames = {}
	menu.equipmenttags = {}
	menu.equipmentnumwares = {}
	menu.licencestopurchase = {}
	menu.licences = {}
	menu.primarytagnames = {}
	menu.primarytags = {}
	menu.tradecontainer = nil
	menu.traderfaction = nil
	menu.trader = nil

	menu.title = nil
	menu.header = nil
	menu.uirelations = nil
	menu.selectedrowdata = nil

	menu.table_top = {}
	menu.table_wares = {}

	menu.expanded = {}
	menu.queueupdate = nil
	menu.selectedrow = nil
	menu.toprow = nil

	menu.frame = nil
end

function menu.onShowMenu()
	menu.trader = C.GetPlayerComputerID()
	if menu.param[3] then
		menu.trader = ConvertIDTo64Bit(menu.param[3])
	end
	menu.traderfaction = GetComponentData(menu.trader, "owner")
	menu.tradecontainer = GetContextByClass(menu.trader, "container", false)
	--print("trader: " .. tostring(GetComponentData(menu.trader, "name")) .. " container: " .. tostring(GetComponentData(menu.tradecontainer, "name")))
	menu.playermoney = GetPlayerMoney()
	menu.totalprice = 0
	menu.mode = "blueprint"
	if menu.param[4] then
		menu.mode = menu.param[4]
	end

	if menu.mode == "licence" then
		menu.title = ReadText(1001, 62)		-- Licences
		menu.header = ReadText(1001, 61)		-- Licence
		menu.uirelation = GetUIRelation(menu.traderfaction)
		menu.licences = GetOwnLicences(menu.traderfaction)
	else
		menu.title = ReadText(1001, 98)		-- "Blueprints"
		menu.header = ReadText(1001, 97)		-- "Blueprint"
		menu.primarytags = {"module", "ship", "equipment"}
		menu.primarytagnames = {ReadText(1001, 7924), ReadText(1001, 6), ReadText(1001, 7935)}	-- Modules, Ships, Equipment
		menu.equipmenttags = { "weapon", "turret", "shield", "engine", "thruster", "missile", "drone", "consumables", "countermeasure" }
		menu.consumabletags = { "lasertower", "satellite", "mine", "navbeacon", "resourceprobe" }
		menu.equipmenttagnames = { ReadText(1001, 1301), ReadText(1001, 1319), ReadText(1001, 1317), ReadText(1001, 1103), ReadText(1001, 8001), ReadText(1001, 1304), ReadText(1001, 8), ReadText(1001, 8003), ReadText(1001, 8063) }	-- Weapons, Turrets, Shields, Engines, Thrusters, Missiles, Drones, Consumables, Countermeasures
		menu.equipmentnumwares = { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	end

	menu.table_top = {}
	menu.expanded = {}

	menu.initData()

	-- add content
	menu.display(true)
end

function menu.onShowMenuSound()
	-- no sound
end

function menu.initData()
	menu.blueprintstopurchase = {}
	menu.licencestopurchase = {}

	if menu.mode == "licence" then

	else
		menu.table_wares = {}

		local numblueprints = C.GetNumBlueprints("", "", "")
		local blueprints = ffi.new("UIBlueprint[?]", numblueprints)
		numblueprints = C.GetBlueprints(blueprints, numblueprints, "", "", "")
		menu.blueprintlist = {}
		for i = 0, numblueprints-1 do
			menu.blueprintlist[ffi.string(blueprints[i].ware)] = true
		end

		for _, tag in ipairs(menu.primarytags) do
			if not menu.table_wares[tag] then
				menu.table_wares[tag] = {}
			end
			if tag == "equipment" then
				for i, equipmenttag in ipairs(menu.equipmenttags) do
					if not menu.table_wares[tag][equipmenttag] then
						menu.table_wares[tag][equipmenttag] = {}
					end
					local concattag = equipmenttag
					if equipmenttag == "consumables" then
						concattag = ""
						for _, tag in ipairs(menu.consumabletags) do
							concattag = concattag .. " " .. tag
						end
					end
					--print("tag: " .. tostring(concattag))
					local numwares = C.GetNumWares(concattag, false, menu.traderfaction, "noplayerblueprint missiononly")
					local wares = ffi.new("const char*[?]", numwares)
					numwares = C.GetWares(wares, numwares, concattag, false, menu.traderfaction, "noplayerblueprint missiononly")
					for j = 0, numwares - 1 do
						local locware = ffi.string(wares[j])
						local avgprice, macro = GetWareData(locware, "avgprice", "component")
						local hasinfoalias = (macro ~= "") and GetMacroData(macro, "hasinfoalias")
						local locprice = avgprice * 10
						if not hasinfoalias then
							menu.table_wares[tag][equipmenttag][locware] = locprice
							menu.equipmentnumwares[i] = menu.equipmentnumwares[i] + 1
						end
					end
				end
			else
				--print("tag: " .. tostring(tag))
				local numwares = C.GetNumWares(tag, false, menu.traderfaction, "noplayerblueprint missiononly")
				local wares = ffi.new("const char*[?]", numwares)
				numwares = C.GetWares(wares, numwares, tag, false, menu.traderfaction, "noplayerblueprint missiononly")
				for i = 0, numwares-1 do
					local locware = ffi.string(wares[i])
					local avgprice, maxprice, hasblueprint = GetWareData(locware, "avgprice", "maxprice", "hasblueprint")
					--print(locware .. (hasblueprint and ": hasblueprint" or ": no blueprint"))
					if hasblueprint then
						local locprice = avgprice * 10
						if tag == "module" then
							locprice = maxprice
						end
						menu.table_wares[tag][locware] = locprice
					end
				end
			end
		end
	end
end

function menu.display(firsttime)
	Helper.removeAllWidgetScripts(menu)

	menu.skiprowchange = not firsttime

	local width = Helper.viewWidth / 2
	local height = Helper.viewHeight / 2
	local xoffset = width / 2
	local yoffset = height / 2

	menu.frame = Helper.createFrameHandle(menu, { width = width + 2 * Helper.borderSize, height = height + 2 * Helper.borderSize, x = xoffset - Helper.borderSize, y = yoffset - Helper.borderSize })
	menu.frame:setBackground("solid", { color = Color["frame_background_semitransparent"] })
	local table_bottom, row

	-- we need table_bottom first because we need the y offset of table_bottom to figure out the height of table_top
	table_bottom = menu.frame:addTable(2, { tabOrder = 2, width = width / 2 - Helper.borderSize, x = width / 2 + 2 * Helper.borderSize })

	local row = table_bottom:addRow(false, {fixed = true})
	row[1]:setColSpan(2):createText(ReadText(1001, 2006), Helper.subHeaderTextProperties)		-- Transaction Details
	row[1].properties.halign = "center"

	row = table_bottom:addRow(false, {fixed = true})
	row[1]:createText((ReadText(1001, 2005) .. ReadText(1001, 120)))		-- Transaction Value:
	row[2]:createText(function() return (ConvertMoneyString(tostring(-menu.totalprice), false, true, nil, true) .. " " .. ReadText(1001, 101)) end, {halign = "right"})
	row[2].properties.color = function() return menu.totalprice < 0 and Color["text_positive"] or Color["text_negative"] end

	local row = table_bottom:addRow(false, {fixed = true})
	row[1]:createText((ReadText(1001, 2003) .. ReadText(1001, 120)))		-- Current Balance
	row[2]:createText(function() return (ConvertMoneyString(tostring(GetPlayerMoney()), false, true, nil, true) .. " " .. ReadText(1001, 101)) end, {halign = "right"})

	local row = table_bottom:addRow(false, {fixed = true})
	row[1]:createText((ReadText(1001, 2004) .. ReadText(1001, 120)))		-- Final Balance
	row[2]:createText(function() return (ConvertMoneyString(tostring(GetPlayerMoney() - menu.totalprice), false, true, nil, true) .. " " .. ReadText(1001, 101)) end, {halign = "right"})

	local row = table_bottom:addRow("buttonrow", { fixed = true })
	row[1]:createButton({ active = function() return (menu.totalprice ~= 0) and (GetPlayerMoney() >= menu.totalprice) end, helpOverlayID = "trader_purchase_confirm" , helpOverlayText = " ",  helpOverlayHighlightOnly = true })
	row[1]:setText(ReadText(1001, 2821), { halign = "center" })		-- Confirm
	row[1].handlers.onClick = function() return menu.buttonConfirm() end
	row[2]:createButton({ active = true, helpOverlayID = "trader_purchase_cancel", helpOverlayText = " ",  helpOverlayHighlightOnly = true })
	--row[2]:createButton({ active = function() return menu.totalprice ~= 0 end })
	row[2]:setText(ReadText(1001, 64), {halign = "center"})		-- Cancel
	row[2].handlers.onClick = function() return menu.buttonCancel() end

	table_bottom.properties.y = height - table_bottom:getVisibleHeight() + Helper.borderSize

	menu.table_top = menu.frame:addTable(5, { tabOrder = 1, maxVisibleHeight = table_bottom.properties.y - Helper.borderSize, x = Helper.borderSize, y = Helper.borderSize, width = width})
	menu.table_top:setColWidth(1, Helper.scaleY(Helper.standardTextHeight), false)
	menu.table_top:setColWidth(2, Helper.scaleY(Helper.standardTextHeight), false)
	menu.table_top:setColWidthPercent(4, 25)
	menu.table_top:setColWidthPercent(5, 25)

	-- standard header
	row = menu.table_top:addRow(false, { fixed = true, bgColor = Color["row_title_background"] })
	row[1]:setColSpan(5):createText(menu.title, Helper.titleTextProperties)

	row = menu.table_top:addRow(false, { fixed = true, bgColor = Color["row_background_unselectable"] })
	row[1]:setBackgroundColSpan(5)
	row[3]:createText(menu.header, { font = Helper.standaradFontBold })
	row[4]:createText(ReadText(1001, 2808), { font = Helper.standaradFontBold, halign = "center" })		-- Price

	row = menu.table_top:addRow(false, { fixed = true, bgColor = Color["row_separator"] })
	row[1]:setColSpan(5):createText("", { height = 1 })

	if menu.mode == "licence" then
		for _, licence in ipairs(menu.licences) do
			if licence.issellable then
				local haslicence = HasLicence("player", licence.type, menu.traderfaction)
				local precursorname = ""
				local canpurchase = not haslicence
				--print("canpurchase: " .. tostring(canpurchase))
				if canpurchase then
					if licence.precursor ~= nil then
						local hasprecursor = HasLicence("player", licence.precursor, menu.traderfaction)
						local licenceinfo = ffi.new("LicenceInfo")
						C.GetLicenceInfo(licenceinfo, menu.traderfaction, licence.precursor)
						precursorname = ffi.string(licenceinfo.name)
						--print("hasprecursor: " .. tostring(hasprecursor) .. ", precursor: " .. tostring(precursorname))
						if (licence.minrelation > menu.uirelation) or (not hasprecursor) then
							canpurchase = false
						end
					elseif licence.minrelation > menu.uirelation then
						canpurchase = false
					end
				end

				row = menu.table_top:addRow({ "entry", licence.id }, {  })

				row[1]:setColSpan(3):createText(licence.name, {color = function() return menu.licencestopurchase[licence.id] and Color["text_positive"] or Color["text_normal"] end})

				if not haslicence then
					row[4]:createText((ConvertMoneyString(tostring(licence.price), false, true, nil, true) .. " " .. ReadText(1001, 101)), {halign = "right", color = function() return menu.licencestopurchase[licence.id] and Color["text_positive"] or Color["text_normal"] end})
				end

				--print("available cash: " .. tostring(menu.playermoney - menu.totalprice) .. " price: " .. tostring(price) .. " active? " .. tostring((menu.playermoney - menu.totalprice) > price) .. " total cash: " .. tostring(menu.playermoney) .. " total price: " .. tostring(menu.totalprice))
				--print("licence: " .. tostring(licence) .. " canpurchase: " .. tostring(canpurchase))
				if haslicence then
					row[5]:createText(ReadText(1001, 84), { halign = "center", color = Color["text_player"], x = 0 })
				else
					row[5]:createButton({ active = (menu.licencestopurchase[licence.id] and true) or (canpurchase and (menu.playermoney - menu.totalprice) > licence.price) or false })
					row[5]:setText(function() return (HasLicence("player", licence.type, menu.traderfaction) and ReadText(1001, 84)) or (menu.licencestopurchase[licence.id] and ReadText(1001, 17)) or ReadText(1001, 3102) end, {halign = "center"})		-- Owned, Selected, Select
					row[5].handlers.onClick = function() return menu.buttonSelectLicence(licence, licence.price) end	-- TODO
					row[5].properties.bgColor = function() return menu.licencestopurchase[licence.id] and Color["row_background_selected"] or Color["button_background_default"] end
					row[5].properties.mouseOverText = row[5].properties.active and "" or (canpurchase and ReadText(1026, 8101) or string.format(ReadText(1026, 8103), ColorText["licence"] .. precursorname .. "\27X", licence.minrelation))	-- "You cannot afford this licence.", "Requires the %s($LICENCE_NAME$) ceremony \(Relation: %s\)."
				end
				AddKnownItem("licences", licence.id)
			end
		end
	else
		for tagindex, tag in ipairs(menu.primarytags) do
			row = menu.table_top:addRow({ "category", tag }, {  })
			row[1]:createButton({ active = true, height = Helper.scaleY(Helper.standardTextHeight), scaling = false, helpOverlayID = "trader_purchase_" .. tag, helpOverlayText = " ",  helpOverlayHighlightOnly = true })
			row[1]:setText(function() return menu.expanded[tag] and "-" or "+" end, {halign = "center"})
			row[1].handlers.onClick = function() return menu.buttonExpand(tag) end
			row[2]:setBackgroundColSpan(4)
			row[3]:createText(menu.primarytagnames[tagindex])

			if menu.expanded[tag] then
				if tag == "equipment" then
					for equipmenttagindex, equipmenttag in ipairs(menu.equipmenttags) do
						row = menu.table_top:addRow({ "category", equipmenttag }, {  })
						row[2]:createButton({ active = (menu.equipmentnumwares[equipmenttagindex] > 0), height = Helper.scaleY(Helper.standardTextHeight), scaling = false })
						row[2]:setText(function() return menu.expanded[equipmenttag] and "-" or "+" end, {halign = "center"})
						row[2].handlers.onClick = function() return menu.buttonExpand(equipmenttag) end
						row[3]:setBackgroundColSpan(3)
						row[3]:createText(menu.equipmenttagnames[equipmenttagindex], {x = Helper.standardTextOffsetx + Helper.standardIndentStep})

						if menu.expanded[equipmenttag] then
							local sortedwares = Helper.orderedKeys(menu.table_wares[tag][equipmenttag], (equipmenttag == "consumables") and menu.sortAmmo or Helper.sortWareName)
							for i = 1, #sortedwares do
								local ware = sortedwares[i]
								local price = menu.table_wares[tag][equipmenttag][ware]
								local tradelicence = GetWareData(ware, "tradelicence")
								local licenced = HasLicence("player", tradelicence, menu.traderfaction)
								local licencename, precursorname = "", ""

								local licencedata = GetLibraryEntry("licences", menu.traderfaction .. "." .. tradelicence)
								licencename = licencedata.name
								if licencedata.precursor ~= nil then
									local licenceinfo = ffi.new("LicenceInfo")
									C.GetLicenceInfo(licenceinfo, menu.traderfaction, licencedata.precursor)
									precursorname = ffi.string(licenceinfo.name)
								end
								row = menu.table_top:addRow({ "entry", ware }, {  })

								row[3]:createText(GetWareData(ware, "name"), {color = function() return menu.blueprintstopurchase[ware] and Color["text_positive"] or Color["text_normal"] end, x = Helper.standardTextOffsetx + Helper.standardIndentStep * 2})

								-- start: mycu callback
								if callbacks ["display_on_after_create_equipment_text"] then
									for _, callback in ipairs (callbacks ["display_on_after_create_equipment_text"]) do
										local name, macro = GetWareData(ware, "name", "component")
										result = callback (macro, macro, name)
										if result then
											row[3].properties.mouseOverText = result.mouseovertext
										end
									end
								end
								-- end: mycu callback

								if not menu.blueprintlist[ware] then
									row[4]:createText((ConvertMoneyString(tostring(price), false, true, nil, true) .. " " .. ReadText(1001, 101)), {halign = "right", color = function() return menu.blueprintstopurchase[ware] and Color["text_positive"] or Color["text_normal"] end})
								end

								if menu.blueprintlist[ware] then
									row[5]:createText(ReadText(1001, 84), { halign = "center", color = Color["text_player"], x = 0 })
								else
									row[5]:createButton({ active = menu.blueprintstopurchase[ware] and true or (licenced and (menu.playermoney - menu.totalprice) > price) })
									row[5]:setText(function() return menu.blueprintstopurchase[ware] and ReadText(1001, 17) or ReadText(1001, 3102) end, {halign = "center"})		-- Selected, Select
									row[5].handlers.onClick = function() return menu.buttonSelectBlueprint(ware, price) end
									row[5].properties.bgColor = function() return menu.blueprintstopurchase[ware] and Color["row_background_selected"] or Color["button_background_default"] end
									row[5].properties.mouseOverText = row[5].properties.active and "" or (licenced and ReadText(1026, 8111) or string.format(ReadText(1026, 8104), ColorText["licence"] .. licencename .. "\27X", ColorText["licence"] .. precursorname .. "\27X", licencedata.minrelation))		-- "You cannot afford this blueprint.", "Requires the %s($LICENCE_NAME$) awarded in the %s($OTHER_LICENCE_NAME$) ceremony \(Relation: %s\)."
								end
							end
						end
					end
				else
					local wares = {}
					for ware in pairs(menu.table_wares[tag]) do
						local name, macro = GetWareData(ware, "name", "component")
						local icon, class, purpose, infolibrary = ""
						if tag == "ship" then
							class = ffi.string(C.GetMacroClass(macro))
							local shipicon, primarypurpose = GetMacroData(macro, "icon", "primarypurpose")
							icon = "\27[" .. shipicon .. "] "
							purpose = primarypurpose
							infolibrary = class
						elseif tag == "module" then
							local moduleinfolibrary = GetMacroData(macro, "infolibrary")
							infolibrary = moduleinfolibrary
						end
						if infolibrary then
							if wares[infolibrary] then
								table.insert(wares[infolibrary], { ware = ware, name = icon .. name, class = class, purpose = purpose, objectid = "" })
							else
								wares[infolibrary] = { { ware = ware, name = icon .. name, class = class, purpose = purpose, objectid = "" } }
							end
						else
							table.insert(wares, { ware = ware, name = icon .. name, class = class, purpose = purpose, objectid = "" }) -- objectid used by Helper.sortShipsByClassAndPurpose
						end
					end
					if tag == "ship" then
						for _, data in pairs(wares) do
							table.sort(data, Helper.sortShipsByClassAndPurpose)
						end
					else
						if #wares > 0 then
							table.sort(wares, Helper.sortName)
						else
							for _, data in pairs(wares) do
								table.sort(data, Helper.sortName)
							end
						end
					end
					if config.blueprintorder[tag] then
						for _, key in ipairs(config.blueprintorder[tag]) do
							if wares[key.key] then
								row = menu.table_top:addRow({ "category", key.key }, {  })
								row[2]:createButton({ height = Helper.scaleY(Helper.standardTextHeight), scaling = false })
								row[2]:setText(function() return menu.expanded[key.key] and "-" or "+" end, {halign = "center"})
								row[2].handlers.onClick = function() return menu.buttonExpand(key.key) end
								row[3]:setBackgroundColSpan(3)
								row[3]:createText(config.categorynames[key.key], { x = Helper.standardTextOffsetx + Helper.standardIndentStep })
								if menu.expanded[key.key] then
									for _, entry in ipairs(wares[key.key]) do
										menu.showEntry(entry, tag, 2)
									end
								end
							end
						end
					else
						for _, entry in ipairs(wares) do
							menu.showEntry(entry, tag, 1)
						end
					end
				end
			end
		end
	end

	if menu.selectedrow then
		menu.table_top:setSelectedRow(menu.selectedrow)
		menu.selectedrow = nil
		if menu.toprow then
			menu.table_top:setTopRow(menu.toprow)
			menu.toprow = nil
		end
	end

	local table_desc = menu.frame:addTable(1, { width = width / 2, x = Helper.borderSize, tabOrder = 3, highlightMode = "off", skipTabChange = true })

	local row = table_desc:addRow(false, { fixed = true })
	row[1]:createText(ReadText(1001, 2404), Helper.subHeaderTextProperties)
	row[1].properties.halign = "center"

	local text = ""
	if menu.selectedrowdata then
		if menu.mode == "licence" then
			for _, licence in ipairs(menu.licences) do
				if licence.id == menu.selectedrowdata then
					text = licence.desc
					break
				end
			end
		else
			text = GetWareData(menu.selectedrowdata, "description")
		end
	end
	local textwidth = width / 2 - 2 * Helper.standardTextOffsetx
	local description = GetTextLines(text, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), textwidth)
	if #description > 4 then
		description = GetTextLines(text, Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize), textwidth - Helper.scrollbarWidth)
	end
	for i, line in ipairs(description) do
		local row = table_desc:addRow(true, {  })
		row[1]:createText(line)
		if i == 4 then
			table_desc.properties.maxVisibleHeight = table_desc:getFullHeight()
		end
	end

	local yoffset = math.max(table_bottom:getVisibleHeight(), table_desc:getVisibleHeight()) --+ Helper.borderSize
	table_bottom.properties.y = height - yoffset
	table_desc.properties.y = height - yoffset
	menu.table_top.properties.maxVisibleHeight = table_bottom.properties.y - Helper.borderSize

	menu.table_top:addConnection(1, 1, true)
	table_bottom:addConnection(2, 1)

	menu.frame:display()
end

function menu.showEntry(entry, tag, indent)
	local ware = entry.ware
	local price = menu.table_wares[tag][ware]
	local tradelicence = GetWareData(ware, "tradelicence")
	local licenced = HasLicence("player", tradelicence, menu.traderfaction)
	local licenceinfo = ffi.new("LicenceInfo")
	local licencename, precursorname, minrelation = "", ""

	local licencedata = GetLibraryEntry("licences", menu.traderfaction .. "." .. tradelicence)
	licencename = licencedata.name or ""
	if licencedata.precursor ~= nil then
		local licenceinfo = ffi.new("LicenceInfo")
		C.GetLicenceInfo(licenceinfo, menu.traderfaction, licencedata.precursor)
		precursorname = ffi.string(licenceinfo.name)
	end

	row = menu.table_top:addRow({ "entry", ware }, {})
	row[3]:createText(entry.name, { color = function() return menu.blueprintstopurchase[ware] and Color["text_positive"] or Color["text_normal"] end, x = Helper.standardTextOffsetx + Helper.standardIndentStep * indent })

	if not menu.blueprintlist[ware] then
		row[4]:createText((ConvertMoneyString(tostring(price), false, true, nil, true) .. " " .. ReadText(1001, 101)), {halign = "right", color = function() return menu.blueprintstopurchase[ware] and Color["text_positive"] or Color["text_normal"] end})
	end

	--print("available cash: " .. tostring(menu.playermoney - menu.totalprice) .. " price: " .. tostring(price) .. " active? " .. tostring((menu.playermoney - menu.totalprice) > price) .. " total cash: " .. tostring(menu.playermoney) .. " total price: " .. tostring(menu.totalprice))
	--print("ware: " .. tostring(ware) .. " trade licence: " .. tostring(GetWareData(ware, "tradelicence")) .. " player has licence: " .. tostring(HasLicence("player", GetWareData(ware, "tradelicence"), menu.traderfaction)))
	if menu.blueprintlist[ware] then
		row[5]:createText(ReadText(1001, 84), { halign = "center", color = Color["text_player"], x = 0 })
	else
		row[5]:createButton({ active = menu.blueprintstopurchase[ware] and true or (licenced and (menu.playermoney - menu.totalprice) > price) })
		row[5].properties.helpOverlayID = "trader_purchase_" .. tostring(ware)
		row[5].properties.helpOverlayText = " "
		row[5].properties.helpOverlayHighlightOnly = true
		row[5]:setText(function() return menu.blueprintstopurchase[ware] and ReadText(1001, 17) or ReadText(1001, 3102) end, { halign = "center" })		-- Selected, Select
		row[5].properties.mouseOverText = row[5].properties.active and "" or (licenced and ReadText(1026, 8111) or string.format(ReadText(1026, 8104), ColorText["licence"] .. licencename .. "\27X", ColorText["licence"] .. precursorname .. "\27X", licencedata.minrelation))		-- "You cannot afford this blueprint.", "Requires the %s($LICENCE_NAME$) awarded in the %s($OTHER_LICENCE_NAME$) ceremony \(Relation: %s\)."
		row[5].handlers.onClick = function() return menu.buttonSelectBlueprint(ware, price) end
		row[5].properties.bgColor = function() return menu.blueprintstopurchase[ware] and Color["row_background_selected"] or Color["button_background_default"] end
	end
end

-- widget scripts
function menu.buttonExpand(tag)
	if menu.expanded[tag] then
		menu.expanded[tag] = nil
	else
		menu.expanded[tag] = true
	end

	menu.toprow = GetTopRow(menu.table_top.id)
	menu.selectedrow = Helper.currentTableRow[menu.table_top.id]
	menu.queueupdate = true
end

function menu.buttonConfirm()
	if GetPlayerMoney() >= menu.totalprice then
		if menu.mode == "licence" then
			for licenceid, licenceinfo in pairs(menu.licencestopurchase) do
				--print("adding licence " .. tostring(licenceid) .. " from " .. tostring(menu.traderfaction))
				AddLicence("player",  licenceinfo.type, menu.traderfaction)
			end
		else
			for ware, _ in pairs(menu.blueprintstopurchase) do
				C.LearnBlueprint(ware)
			end
		end
		TransferPlayerMoneyTo(menu.totalprice, menu.tradecontainer)
	end
	menu.initData()
	menu.tallyTotalPrice()
	-- activate this and remove Helper.closeMenuAndReturn() and menu.cleanup if we later decide to keep the menu open.
	--[[
	-- NB: doing this here rather than in onUpdate so that hitting Cancel resets your position in the menu. remove here and activate in onUpdate if we prefer that the menu position is never reset.
	menu.toprow = GetTopRow(menu.table_top.id)
	menu.selectedrow = Helper.currentTableRow[menu.table_top.id]
	-- NB: we only need to refresh the menu here because we cannot set button.properties.active to a function and run those functions upon frame:update()
	menu.queueupdate = true
	]]
	Helper.closeMenuAndReturn(menu)
	menu.cleanup()
end

function menu.buttonCancel()
	menu.blueprintstopurchase = {}
	menu.licencestopurchase = {}
	menu.tallyTotalPrice()
	-- activate this and remove Helper.closeMenuAndReturn() and menu.cleanup if we later decide to keep the menu open.
	--[[
	menu.expanded = {}
	-- NB: we only need to refresh the menu here because we cannot set button.properties.active to a function and run those functions upon frame:update()
	menu.queueupdate = true
	]]
	Helper.closeMenuAndReturn(menu)
	menu.cleanup()
end

function menu.buttonSelectLicence(licence, price)
	if not menu.licencestopurchase[licence.id] then
		menu.licencestopurchase[licence.id] = { type = licence.type, price = price }
	else
		menu.licencestopurchase[licence.id] = nil
	end
	AddUITriggeredEvent(menu.name,  "trader_purchase_" .. licence.name, menu.licencestopurchase[licence.id] and true or false)
	-- NB: doing this here rather than in onUpdate so that hitting Cancel resets your position in the menu. remove here and activate in onUpdate if we prefer that the menu position is never reset.
	menu.toprow = GetTopRow(menu.table_top.id)
	menu.selectedrow = Helper.currentTableRow[menu.table_top.id]
	menu.tallyTotalPrice()
	menu.queueupdate = true
end

function menu.buttonSelectBlueprint(ware, price)
	if not menu.blueprintstopurchase[ware] then
		menu.blueprintstopurchase[ware] = price
	else
		menu.blueprintstopurchase[ware] = nil
	end
	AddUITriggeredEvent(menu.name,  "trader_purchase_" .. tostring(ware), menu.blueprintstopurchase[ware] and true or false)
	-- NB: doing this here rather than in onUpdate so that hitting Cancel resets your position in the menu. remove here and activate in onUpdate if we prefer that the menu position is never reset.
	menu.toprow = GetTopRow(menu.table_top.id)
	menu.selectedrow = Helper.currentTableRow[menu.table_top.id]
	menu.tallyTotalPrice()
	menu.queueupdate = true
end

-- helper functions
function menu.tallyTotalPrice()
	menu.totalprice = 0
	if menu.mode == "licence" then
		for licenceid, licenceinfo in pairs(menu.licencestopurchase) do
			menu.totalprice = menu.totalprice + licenceinfo.price
		end
	else
		for ware, price in pairs(menu.blueprintstopurchase) do
			menu.totalprice = menu.totalprice + price
		end
	end
end

function menu.sortAmmo(a, b)
	local amacro = GetWareData(a, "component")
	local bmacro = GetWareData(b, "component")

	local atype, btype = "", ""
	if IsMacroClass(amacro, "satellite") then
		atype = "satellite"
	elseif IsMacroClass(amacro, "navbeacon") then
		atype = "navbeacon"
	elseif IsMacroClass(amacro, "resourceprobe") then
		atype = "resourceprobe"
	elseif IsMacroClass(amacro, "mine") then
		atype = "mine"
	elseif GetMacroData(amacro, "islasertower") then
		atype = "lasertower"
	end
	if IsMacroClass(bmacro, "satellite") then
		btype = "satellite"
	elseif IsMacroClass(bmacro, "navbeacon") then
		btype = "navbeacon"
	elseif IsMacroClass(bmacro, "resourceprobe") then
		btype = "resourceprobe"
	elseif IsMacroClass(bmacro, "mine") then
		btype = "mine"
	elseif GetMacroData(bmacro, "islasertower") then
		btype = "lasertower"
	end

	if atype == btype then
		return Helper.sortMacroName(amacro, bmacro)
	end
	return config.deployableOrder[atype] < config.deployableOrder[btype]
end

menu.updateInterval = 0.1

function menu.onUpdate()
	menu.frame:update()

	if menu.queueupdate then
		menu.queueupdate = nil
		menu.refreshMenu()
	end
end

function menu.refreshMenu()
	menu.toprow = GetTopRow(menu.table_top.id)
	menu.selectedrow = Helper.currentTableRow[menu.table_top.id]
	menu.display()
end

function menu.onRowChanged(row, rowdata, uitable)
	if uitable == menu.table_top.id then
		if (type(rowdata) == "table") and (rowdata[1] == "entry") then
			menu.selectedrowdata = rowdata[2]
		else
			menu.selectedrowdata = nil
		end
		if not menu.skiprowchange then
			menu.queueupdate = true
		end
		menu.skiprowchange = nil
	end
end

function menu.onCloseElement(dueToClose)
	Helper.closeMenuAndReturn(menu)
	menu.cleanup()
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
		Helper.loadModLuas(menu.name, "menu_trader_blueprintsorlicences_uix")
	end
end
-- kuertee end
init()
