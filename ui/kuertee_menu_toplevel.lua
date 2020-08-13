local ffi = require ("ffi")
local C = ffi.C
local Lib = require ("extensions.sn_mod_support_apis.lua_library")
local topLevelMenu
local origFuncs = {}
local newFuncs = {}
local callbacks = {}
local function init ()
	DebugError ("kuertee_menu_toplevel.init")
	topLevelMenu = Lib.Get_Egosoft_Menu ("TopLevelMenu")
	topLevelMenu.registerCallback = newFuncs.registerCallback
	topLevelMenu.config = config
	topLevelMenu.callbacks = callbacks
	origFuncs.createInfoFrame = topLevelMenu.createInfoFrame
	topLevelMenu.createInfoFrame = newFuncs.createInfoFrame
end
function newFuncs.registerCallback (callbackName, callbackFunction)
	-- DebugError ("kuertee_menu_transporter.lua.registerCallback " .. tostring (callbackName) .. " " .. tostring (callbackFunction))
	-- note 1: format is generally [function name]_[action]. e.g.: in kuertee_menu_transporter.lua, "display_on_set_room_active" overrides the room's active property with the return of the callback.
	-- note 2: events have the word "_on_" followed by a PRESET TENSE verb. e.g.: in kuertee_menu_transporter.lua, "display_on_set_buttontable" is called after all of the rows of buttontable are set.
	-- note 3: new callbacks can be added or existing callbacks can be edited. but commit your additions/changes to the mod's GIT repository.
	-- note 4: search for the callback names to see where they are executed.
	-- note 5: if a callback requires a return value, return it in an object var. e.g. "display_on_set_room_active" requires a return of {active = true | false}.
	-- available callbacks:
	-- createInfoFrame_on_before_frame_display
	-- kHUD_create_new_HUD_table
	--
	if callbacks [callbackName] == nil then
		callbacks [callbackName] = {}
	end
	table.insert (callbacks [callbackName], callbackFunction)
end
local config = {
	width = Helper.sidebarWidth,
	height = Helper.sidebarWidth,
	offsetY = 0,
	layer = 3,
	mouseOutRange = 100,
}
function newFuncs.createInfoFrame ()
	local menu = topLevelMenu

	-- remove old data
	Helper.clearDataForRefresh(menu, config.infoLayer)

	local frameProperties = {
		standardButtons = {},
		width = menu.width + 2 * Helper.borderSize,
		x = (Helper.viewWidth - menu.width) / 2,
		y = Helper.scaleY(config.offsetY),
		layer = config.layer,
		startAnimation = false,
		playerControls = true,
		useMiniWidgetSystem = (not menu.showTabs) and (not menu.over),
		enableDefaultInteractions = false,
	}

	menu.infoFrame = Helper.createFrameHandle(menu, frameProperties)

	local tableProperties = {
		width = menu.width,
		x = Helper.borderSize,
		y = Helper.borderSize,
	}
	
	if menu.showTabs then
		if not menu.hasRegistered then
			menu.hasRegistered = true
			Helper.setTabScrollCallback(menu, menu.onTabScroll)
			registerForEvent("inputModeChanged", getElement("Scene.UIContract"), menu.onInputModeChanged)
		end

		menu.infoFrame.properties.width = Helper.viewWidth
		menu.infoFrame.properties.x = 0
		menu.topLevelHeight, menu.topLevelWidth = Helper.createTopLevelTab(menu, "", menu.infoFrame, "", nil, nil, true)
		menu.infoFrame.properties.height = menu.topLevelHeight + Helper.borderSize

		menu.mouseOutBox = {
			x1 = - menu.topLevelWidth / 2                    - config.mouseOutRange,
			x2 =   menu.topLevelWidth / 2                    + config.mouseOutRange,
			y1 = Helper.viewHeight / 2,
			y2 = Helper.viewHeight / 2 - menu.topLevelHeight - config.mouseOutRange
		}
	else
		if menu.hasRegistered then
			Helper.removeAllTabScrollCallbacks(menu)
			unregisterForEvent("inputModeChanged", getElement("Scene.UIContract"), menu.onInputModeChanged)
			menu.hasRegistered = nil
		end
		local ftable = menu.createTable(menu.infoFrame, tableProperties)
		menu.infoFrame.properties.height = ftable.properties.y + ftable:getVisibleHeight() + Helper.borderSize
	end

	-- start kuertee_lua_with_callbacks:
	if callbacks ["createInfoFrame_on_before_frame_display"] then
		for _, callback in ipairs (callbacks ["createInfoFrame_on_before_frame_display"]) do
			callback (menu.infoFrame)
		end
	end
	-- end kuertee_lua_with_callbacks:

	menu.infoFrame:display()
end
init ()
