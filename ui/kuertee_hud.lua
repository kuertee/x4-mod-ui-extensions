local ffi = require ("ffi")
local C = ffi.C
local Lib = require ("extensions.sn_mod_support_apis.lua_library")
local kHUD = {
	name = "kHUD"
}
local origFuncs = {}
local newFuncs = {}
local function init ()
	for i, menu in ipairs (View.menus) do
		if (not origFuncs.showMenuCallback) then
			origFuncs.showMenuCallback = menu.showMenuCallback
		end
		menu.showMenuCallback = function (...) newFuncs.showMenuCallback (menu, ...) end
	end
	-- register and open
	Menus = Menus or {}
	table.insert(Menus, kHUD)
	if Helper then
		Helper.registerMenu (kHUD)
	end
	OpenMenu ("kHUD", {0, 0}, nil)
end
function newFuncs.showMenuCallback (menu, ...)
	DebugError ("kuertee_ui_extensions.ui.kuertee_hud.newFuncs.showMenuCallback menu.name " .. tostring (menu.name))
	if not menu.shown then
		-- Set up menu parameters
		menu.param, menu.param2 = GetMenuParameters()
		DebugError ("kuertee_ui_extensions.ui.kuertee_hud.newFuncs.showMenuCallback menu.param " .. tostring (menu.param))
		DebugError ("kuertee_ui_extensions.ui.kuertee_hud.newFuncs.showMenuCallback menu.param2 " .. tostring (menu.param2))
		if menu.name == "DockedMenu" then
			-- if the top level tab is open, open the docked menu anyway
			if (not Helper.topLevelMenu) and View.hasMenu({ Helper = true }) then
				return
			end
			if Helper.topLevelMenu then
				local topLevelMenu = Helper.topLevelMenu
				Helper.closeMenu(topLevelMenu, "close")
				topLevelMenu.cleanup()
			end
			Helper.topLevelMenu = nil
			Helper.dockedMenu = menu
		elseif menu.name == "TopLevelMenu" then
			-- if the docked menu is open, open the top level tab anyway
			if (not Helper.dockedMenu) and View.hasMenu({ Helper = true }) then
				return
			end
			if Helper.dockedMenu then
				local dockedMenu = Helper.dockedMenu
				Helper.closeMenu(dockedMenu, "close")
				dockedMenu.cleanup()
			end
			Helper.dockedMenu = nil
			Helper.topLevelMenu = menu
		elseif menu.name ~= "kHUD" then
			if Helper.dockedMenu then
				local dockedMenu = Helper.dockedMenu
				Helper.closeMenu(dockedMenu, "close")
				dockedMenu.cleanup()
			end
			if Helper.topLevelMenu then
				local topLevelMenu = Helper.topLevelMenu
				Helper.closeMenu(topLevelMenu, "close")
				topLevelMenu.cleanup()
			end
		end

		menu.shown = true
		menu.minimized = false
		if menu.name == "OptionsMenu" then
			-- the options menu is never a conversation menu, but is allowed during inescapable conversations
			-- force flag to false so the unrelated conversations do not get returned when closing the menu
			menu.conversationMenu = false
		else
			menu.conversationMenu = C.IsConversationActive()
		end
		View.clearMenus({ Helper = true })

		if menu.onUpdate then
			local nextUpdateTime = 0
			onUpdateHandler = function()
								if GetCurRealTime() >= nextUpdateTime then
									menu.onUpdate()
									nextUpdateTime = GetCurRealTime() + (menu.updateInterval or 0)
								end
							end
		end

		RegisterEvent("conversationCancelled", menu.onConversationCancelled)
		RegisterEvent("dialogOptionSelected", menu.onDialogOptionSelected)
		local state = nil
		if menu.param2 and menu.param2[1] == "restore" then
			state = menu.param2[2]
			menu.param2 = menu.param2[3]
		end
		C.TrackMenu(menu.name, true)
		AddUITriggeredEvent(menu.name, "", menu.param)
		if menu.onShowMenuSound then
			menu.onShowMenuSound()
		else
			if not C.IsNextStartAnimationSkipped(false) then
				PlaySound("ui_map_open")
			else
				PlaySound("ui_menu_changed")
			end
		end
		local excludeEmulation = Helper.excludeFromMouseEmulation[menu.name]
		if type(excludeEmulation) == "function" then
			excludeEmulation = excludeEmulation()
		end
		if not excludeEmulation then
			C.EnableAutoMouseEmulation()
		end
		-- The actual callback
		menu.onShowMenu(state, ...)
	elseif menu.minimized then
		if onRestoreMenuSound then
			onRestoreMenuSound()
		else
			PlaySound("ui_map_open")
		end
		local excludeEmulation = Helper.excludeFromMouseEmulation[menu.name]
		if type(excludeEmulation) == "function" then
			excludeEmulation = excludeEmulation()
		end
		if not excludeEmulation then
			C.EnableAutoMouseEmulation()
		end
		Helper.restoreMenu(menu)
	end
end
-- start Helper API required:
function kHUD.onCloseElement (dueToClose)
	DebugError ("kuertee_ui_extensions.ui.kuertee_hud.kHUD.onCloseElement dueToClose " .. tostring (dueToClose))
	kHUD.close ()
end
function kHUD.close ()
	DebugError ("kuertee_ui_extensions.ui.kuertee_hud.kHUD.close")
	kHUD.cleanUp ()
end
function kHUD.cleanUp ()
	kHUD.cleanUpActual ()
end
function kHUD.onShowMenu (state)
	DebugError ("kuertee_ui_extensions.ui.kuertee_hud.kHUD.onShowMenu state " .. tostring (state))
	kHUD.display ()
end
function kHUD.display ()
	kHUD.displayActual ()
end
function kHUD.onUpdate ()
	if kHUD.refresh and (kHUD.refresh < getElapsedTime ()) then
		DebugError ("kuertee_ui_extensions.ui.kuertee_hud.kHUD.onUpdate getElapsedTime " .. tostring (getElapsedTime ()))
		kHUD.refresh = nil
		kHUD.displayActual ()
	end
end
-- end Helper API required:
function kHUD.requestUpdate ()
	kHUD.refresh = getElapsedTime () + 0.25
end
function kHUD.displayActual ()
	Helper.clearDataForRefresh (kHUD)
	kHUD.frame = Helper.createFrameHandle (
		kHUD,
		{
			layer = 7,
			width = Helper.viewWidth,
			height = Helper.viewHeight,
			backgroundID = "",
			standardButtons = {},
			playerControls = true,
			enableDefaultInteractions = true,
			startAnimation = false
		}
	)
	kHUD.table = kHUD.frame:addTable (
		1,
		{
			borderEnabled = true
		}
	)
	local row = kHUD.table:addRow (false, {bgColor = Helper.color.transparent})
	row [1]:createText ("kHUD", {halign = "center"})
	kHUD.frame:display()
end
function kHUD.cleanUpActual ()
end
init ()
