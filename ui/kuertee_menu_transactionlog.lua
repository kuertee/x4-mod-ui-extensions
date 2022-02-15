local ffi = require ("ffi")
local C = ffi.C
local Lib = require ("extensions.sn_mod_support_apis.lua_interface").Library
local transactionLogMenu = Lib.Get_Egosoft_Menu ("TransactionLogMenu")
local menu = transactionLogMenu
local oldFuncs = {}
local newFuncs = {}
local callbacks = {}
local isInited
local function init ()
	-- DebugError ("kuertee_menu_transactionlog.init")
	if not isInited then
		isInited = true
		transactionLogMenu.registerCallback = newFuncs.registerCallback
		-- rewrites: 
		oldFuncs.createFrame = transactionLogMenu.createFrame
		transactionLogMenu.createFrame = newFuncs.createFrame
	end
end
function newFuncs.registerCallback (callbackName, callbackFunction)
	-- note 1: format is generally [function name]_[action]. e.g.: in kuertee_menu_transporter, "display_on_set_room_active" overrides the room's active property with the return of the callback.
	-- note 2: events have the word "_on_" followed by a PRESET TENSE verb. e.g.: in kuertee_menu_transporter, "display_on_set_buttontable" is called after all of the rows of buttontable are set.
	-- note 3: new callbacks can be added or existing callbacks can be edited. but commit your additions/changes to the mod's GIT repository.
	-- note 4: search for the callback names to see where they are executed.
	-- note 5: if a callback requires a return value, return it in an object var. e.g. "display_on_set_room_active" requires a return of {active = true | false}.
	-- available callbacks:
	-- createFrame_on_create_transaction_log ()
	--
	if callbacks [callbackName] == nil then
		callbacks [callbackName] = {}
	end
	table.insert (callbacks [callbackName], callbackFunction)
end
-- only have config stuff here that are used in this file
local config = {
	infoLayer = 3,
}
function newFuncs.createFrame(toprow, selectedrow)
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

	if menu.isstation then
		Helper.createRightSideBar(menu.infoFrame, menu.container, true, "transactions", menu.buttonRightBar)
	end

	local tableProperties = {
		width = Helper.playerInfoConfig.width * 5 / 4,
		height = Helper.viewHeight - 2 * Helper.frameBorder,
		x = Helper.frameBorder,
		y = Helper.frameBorder,
		x2 = menu.isstation and (menu.sidebarWidth + Helper.borderSize + Helper.frameBorder) or Helper.frameBorder,
	}
	local selection = {}
	if menu.infoTable then
		selection = { toprow = toprow or GetTopRow(menu.infoTable), selectedrow = selectedrow or Helper.currentTableRow[menu.infoTable] }
	end
	Helper.createTransactionLog(menu.infoFrame, menu.container, tableProperties, menu.createFrame, selection)

	-- start: kuertee call-back
	if callbacks ["createFrame_on_create_transaction_log"] then
			for _, callback in ipairs (callbacks ["createFrame_on_create_transaction_log"]) do
				callback ()
			end
		end
	-- end: kuertee call-back

	menu.infoFrame:display()
	menu.lastRefreshTime = getElapsedTime()
end
init ()
