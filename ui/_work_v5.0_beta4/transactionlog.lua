local config = {
	infoLayer = 3,
}
function menu.createFrame(toprow, selectedrow)
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

	menu.infoFrame:display()
	menu.lastRefreshTime = getElapsedTime()
end
