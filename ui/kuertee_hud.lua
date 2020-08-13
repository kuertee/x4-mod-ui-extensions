local ffi = require ("ffi")
local C = ffi.C
local Lib = require ("extensions.sn_mod_support_apis.lua_library")
local kHUD = {
	name = "kHUD"
}
local function init ()
	Menus = Menus or {}
	table.insert(Menus, kHUD)
	if Helper then
		Helper.registerMenu (kHUD)
	end
	OpenMenu ("kHUD", {0, 0}, nil)
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
