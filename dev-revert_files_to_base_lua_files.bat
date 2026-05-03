@echo off

set "SOURCE=..\base 9.0 beta 8\ui\addons\ego_detailmonitor"
set "DEST=%~dp0\ui\addons\ego_detailmonitor"
copy "%SOURCE%\menu_diplomacy.lua" "%DEST%\menu_diplomacy.xpl"
copy "%SOURCE%\menu_docked.lua" "%DEST%\menu_docked.xpl"
copy "%SOURCE%\menu_encyclopedia.lua" "%DEST%\menu_encyclopedia.xpl"
copy "%SOURCE%\menu_map.lua" "%DEST%\menu_map.xpl"
copy "%SOURCE%\menu_playerinfo.lua" "%DEST%\menu_playerinfo.xpl"
copy "%SOURCE%\menu_research.lua" "%DEST%\menu_research.xpl"
copy "%SOURCE%\menu_scenario_debriefing.lua" "%DEST%\menu_scenario_debriefing.xpl"
copy "%SOURCE%\menu_scenario_selection.lua" "%DEST%\menu_scenario_selection.xpl"
copy "%SOURCE%\menu_ship_configuration.lua" "%DEST%\menu_ship_configuration.xpl"
copy "%SOURCE%\menu_station_configuration.lua" "%DEST%\menu_station_configuration.xpl"
copy "%SOURCE%\menu_station_overview.lua" "%DEST%\menu_station_overview.xpl"
copy "%SOURCE%\menu_toplevel.lua" "%DEST%\menu_toplevel.xpl"
copy "%SOURCE%\menu_trader_blueprintsorlicences.lua" "%DEST%\menu_trader_blueprintsorlicences.xpl"
copy "%SOURCE%\menu_transactionlog.lua" "%DEST%\menu_transactionlog.xpl"
copy "%SOURCE%\menu_transporter.lua" "%DEST%\menu_transporter.xpl"
copy "%SOURCE%\menu_userquestion.lua" "%DEST%\menu_userquestion.xpl"

set "SOURCE=..\base 9.0 beta 8\ui\addons\ego_detailmonitorhelper"
set "DEST=%~dp0\ui\addons\ego_detailmonitorhelper"
copy "%SOURCE%\helper.lua" "%DEST%\helper.xpl"

set "SOURCE=..\base 9.0 beta 8\ui\addons\ego_gameoptions"
set "DEST=%~dp0\ui\addons\ego_gameoptions"
copy "%SOURCE%\customgame.lua" "%DEST%\customgame.xpl"
copy "%SOURCE%\gameoptions.lua" "%DEST%\gameoptions.xpl"

set "SOURCE=..\base 9.0 beta 8\ui\addons\ego_interactmenu"
set "DEST=%~dp0\ui\addons\ego_interactmenu"
copy "%SOURCE%\menu_interactmenu.lua" "%DEST%\menu_interactmenu.xpl"

echo Done.
pause
