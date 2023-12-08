cd ..\..
mkdir ui
cd ui
mkdir addons

mkdir addons\ego_chatwindow
cd addons\ego_chatwindow
del chatwindow.xpl
mklink /h chatwindow.xpl "..\..\..\extensions\kuertee_ui_extensions\ui\addons\ego_chatwindow\chatwindow.xpl"
cd ..\..

mkdir addons\ego_detailmonitor
cd addons\ego_detailmonitor
del menu_docked.xpl
del menu_encyclopedia.xpl
del menu_map.xpl
del menu_playerinfo.xpl
del menu_ship_configuration.xpl
del menu_station_configuration.xpl
del menu_station_overview.xpl
del menu_toplevel.xpl
del menu_transactionlog.xpl
del menu_transporter.xpl
del menu_userquestion.xpl
mklink /h menu_docked.xpl "..\..\..\extensions\kuertee_ui_extensions\ui\addons\ego_detailmonitor\menu_docked.xpl"
mklink /h menu_encyclopedia.xpl "..\..\..\extensions\kuertee_ui_extensions\ui\addons\ego_detailmonitor\menu_encyclopedia.xpl"
mklink /h menu_map.xpl "..\..\..\extensions\kuertee_ui_extensions\ui\addons\ego_detailmonitor\menu_map.xpl"
mklink /h menu_playerinfo.xpl "..\..\..\extensions\kuertee_ui_extensions\ui\addons\ego_detailmonitor\menu_playerinfo.xpl"
mklink /h menu_ship_configuration.xpl "..\..\..\extensions\kuertee_ui_extensions\ui\addons\ego_detailmonitor\menu_ship_configuration.xpl"
mklink /h menu_station_configuration.xpl "..\..\..\extensions\kuertee_ui_extensions\ui\addons\ego_detailmonitor\menu_station_configuration.xpl"
mklink /h menu_station_overview.xpl "..\..\..\extensions\kuertee_ui_extensions\ui\addons\ego_detailmonitor\menu_station_overview.xpl"
mklink /h menu_toplevel.xpl "..\..\..\extensions\kuertee_ui_extensions\ui\addons\ego_detailmonitor\menu_toplevel.xpl"
mklink /h menu_transactionlog.xpl "..\..\..\extensions\kuertee_ui_extensions\ui\addons\ego_detailmonitor\menu_transactionlog.xpl"
mklink /h menu_transporter.xpl "..\..\..\extensions\kuertee_ui_extensions\ui\addons\ego_detailmonitor\menu_transporter.xpl"
mklink /h menu_userquestion.xpl "..\..\..\extensions\kuertee_ui_extensions\ui\addons\ego_detailmonitor\menu_userquestion.xpl"
cd ..\..

mkdir addons\ego_detailmonitorhelper
cd addons\ego_detailmonitorhelper
del helper.xpl
mklink /h helper.xpl "..\..\..\extensions\kuertee_ui_extensions\ui\addons\ego_detailmonitorhelper\helper.xpl"
cd ..\..

mkdir addons\ego_gameoptions
cd addons\ego_gameoptions
del gameoptions.xpl
del customgame.xpl
mklink /h gameoptions.xpl "..\..\..\extensions\kuertee_ui_extensions\ui\addons\ego_gameoptions\gameoptions.xpl"
mklink /h customgame.xpl "..\..\..\extensions\kuertee_ui_extensions\ui\addons\ego_gameoptions\customgame.xpl"
cd ..\..

mkdir addons\ego_interactmenu
cd addons\ego_interactmenu
del menu_interactmenu.xpl
mklink /h menu_interactmenu.xpl "..\..\..\extensions\kuertee_ui_extensions\ui\addons\ego_interactmenu\menu_interactmenu.xpl"
cd ..\..

cd ..\extensions\kuertee_ui_extensions

set /p DUMMY=Hit ENTER to exit...
