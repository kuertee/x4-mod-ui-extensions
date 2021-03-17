function menu.createTable(frame, tableProperties)
	local numCols = (menu.mode == "custom") and 5 or 6
	local ftable = frame:addTable(numCols, { tabOrder = 1, borderEnabled = true, width = tableProperties.width, x = tableProperties.x, y = tableProperties.y, defaultInteractiveObject = true })
	if menu.mode == "custom" then
		local leftwith = math.ceil(C.GetTextWidth(menu.modeparam[3][2] or "", Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize)))
		local rightwidth = math.ceil(C.GetTextWidth(menu.modeparam[4][2] or "", Helper.standardFont, Helper.scaleFont(Helper.standardFont, Helper.standardFontSize)))
		local minbuttonwidth = 0.2 * tableProperties.width - Helper.borderSize
		local maxbuttonwidth = (tableProperties.width - 4 * Helper.borderSize - 3) / 2

		local buttonwidth = math.max(minbuttonwidth, math.min(maxbuttonwidth, math.max(leftwith, rightwidth) + 2 * Helper.standardTextOffsetx))
		ftable:setColWidth(2, buttonwidth, false)
		ftable:setColWidth(4, buttonwidth, false)
	else
		ftable:setColWidth(1, Helper.scaleY(Helper.standardButtonHeight), false)
		ftable:setColWidthPercent(5, 25, false)
		ftable:setColWidthPercent(6, 25, false)
	end

	if menu.mode == "hackpanel" then
		local row = ftable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
		row[1]:setColSpan(numCols):createText(ReadText(1001, 9701), Helper.headerRowCenteredProperties)

		local row = ftable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
		row[1]:setColSpan(numCols):createText(ReadText(1001, 9702) .. ReadText(1001, 120))
		
		local row = ftable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
		row[1]:setColSpan(numCols):createText(ffi.string(C.GetControlPanelName(menu.hacktarget)))
	elseif menu.mode == "abortupgrade" then
		local row = ftable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
		row[1]:setColSpan(numCols):createText(ReadText(1001, 9703), Helper.headerRowCenteredProperties)

		local row = ftable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
		row[1]:setColSpan(numCols):createText(ReadText(1001, 9704), { wordwrap = true })
	elseif menu.mode == "transporter" then
		local row = ftable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
		row[1]:setColSpan(numCols):createText(ReadText(1001, 9707), Helper.headerRowCenteredProperties)

		local row = ftable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
		row[1]:setColSpan(numCols):createText(ReadText(1001, 9708), { wordwrap = true })
	elseif menu.mode == "markashostile" then
		local row = ftable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
		row[1]:setColSpan(numCols):createText(ReadText(1001, 11114), Helper.headerRowCenteredProperties)

		local row = ftable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
		row[1]:setColSpan(numCols):createText(ReadText(1001, 9710), { wordwrap = true })
	elseif menu.mode == "custom" then
		local row = ftable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
		row[1]:setColSpan(numCols):createText(menu.modeparam[1] or "", Helper.headerRowCenteredProperties)

		local row = ftable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
		row[1]:setColSpan(numCols):createText(menu.modeparam[2] or "", { wordwrap = true })
	end

	local row = ftable:addRow(false, { fixed = true, bgColor = Helper.color.transparent })
	row[1]:setColSpan(numCols):createText("")

	if menu.mode == "custom" then
		local row = ftable:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
		row[2]:createButton({ helpOverlayID = "custom_" .. menu.mode .. "_confirm", helpOverlayText = " ", helpOverlayHighlightOnly = true }):setText(menu.modeparam[3][2] or "", { halign = "center" })
		row[2].handlers.onClick = function () return menu.customOption(menu.modeparam[3][1], menu.modeparam[3]) end
		row[4]:createButton({ helpOverlayID = "custom_" .. menu.mode .. "_confirm", helpOverlayText = " ", helpOverlayHighlightOnly = true }):setText(menu.modeparam[4][2] or "", { halign = "center" })
		row[4].handlers.onClick = function () return menu.customOption(menu.modeparam[4][1], menu.modeparam[4]) end

		if menu.modeparam[6] == "right" then
			ftable:setSelectedCol(4)
		elseif menu.modeparam[6] == "left" then
			ftable:setSelectedCol(2)
		end
	else
		local row = ftable:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
		row[1]:createCheckBox(function () return menu.saveOption end, { height = Helper.standardButtonHeight })
		row[1].handlers.onClick = function () menu.saveOption = not menu.saveOption end
		row[2]:setColSpan(3):createButton({ bgColor = Helper.color.transparent }):setText(ReadText(1001, 9709))
		row[2].handlers.onClick = function () menu.saveOption = not menu.saveOption end
		row[5]:createButton({ helpOverlayID = "custom_" .. menu.mode .. "_confirm", helpOverlayText = " ", helpOverlayHighlightOnly = true }):setText(ReadText(1001, 2821), { halign = "center" })
		row[5].handlers.onClick = menu.confirm
		row[6]:createButton({ helpOverlayID = "custom_" .. menu.mode .. "_cancel", helpOverlayText = " ", helpOverlayHighlightOnly = true }):setText(ReadText(1001, 64), { halign = "center" })
		row[6].handlers.onClick = function () return menu.onCloseElement("back", true) end
		ftable:setSelectedCol(5)
	end

	return ftable
end
