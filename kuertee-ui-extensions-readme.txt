UI Extensions and HUD
https://www.nexusmods.com/x4foundations/mods/552
Code: https://github.com/kuertee/x4-mod-ui-extensions
by kuertee. Contributors: Forleyor, Mycu, Runekn.

Updates
=======
v6.0.001, 4 Apr 2023:
-Tweaks: Compatibility with v6.0 RC 1 of the base game.

Instructions for players
========================
Just install UI Extensions as normal - that is IF you have a mod that requires UI Extensions.
You don't need UI Extensions if you don't have a mod that requires UI Extensions.

Instructions for developers
===========================
All other information as described below.

Features
========
Modded Lua files with callbacks that allow more than one mod to change the same UI element.

Functionality that adds HUD elements to the Top Level Menu.

Allows other mods to create guidance missions (i.e. missiontype.guidance) that will be listed in the Guidance Missions tab. Also enables the Set Active and Set Inactive buttons in missions listed in the Guidance Missions tab. Examples of these are my mods: Loot mining, Ship scanner, Signal leak hunter - increasing range, Station scanner, and Waypoint fields for deployments.

Mod effects
===========
This is a modder's resource/API. By itself, this mod does not affect the game.

Modders can use this API to mod the game's Lua files that helps compatibility with other mods that also use this API.

Without this API, some Lua elements can be modified by only one mod. For example, my mods, "NPC reactions: NPC taxis" and "Teleport from transporter room" add buttons to the bottom of the Transporter Room panel. Because its Lua's display () function constructs its frame, table, rows, and content AND THEN immediately calls the frame:display () function, it is impossible for both mods to "rewrite" the display () function and expect both "rewrites" to work.

With this API, specifically its callbacks, it is possible.

Files in this API will be referred to as UIXs.

Summary of how to use
=====================
In the mod's Lua file:
----------------------
1. Create a pointer to the base game's menu to be modded.
2. Register a callback.
3. Write your changes in the callback.
4. Return what the callback expects - if it expects any.

5. If a new callback is required in a function that already exists in the UIXs, simply insert a new callback where it's needed.

6. If a new callback is required in a function that DOESN'T yet exists in the UIX, copy the function from the base game's menu.
7. Paste that function in the relevant UIX.
8. Insert the callback where it's needed.
9. Push your changes to Git.

In the mod's MD file:
---------------------
1. Load the UIX required with SirNukes Mod Support APIs. For example: <raise_lua_event name="'Lua_Loader.Load'" param="'extensions.kuertee_ui_extensions.ui.kuertee_menu_transporter'" />
2. Load the mod's Lua with SirNukes Mod Support APIs. For example: <raise_lua_event name="'Lua_Loader.Load'" param="'extensions.kuertee_npc_reactions.ui.kuertee_npc_reactions'"/>

In your mod's release:
----------------------
Make this mod a required download for your mod.

Documentation
=============
Soon.

But the callbacks, along with their function parameters and their expected returns, are listed in each of the new Lua files. Learning at which point in the code they execute is as easy as searching for them in the code. Examples of how they are used can be seen in my mods that use them. My mods "NPC reactions/NPC taxi" and "Teleport from transporter room" both have changes to the "TransporterMenu".

But here is documentation on NEW features (not connected to mod-specific changes via call-backs) that UIX offers.

CHANGES BUILT INTO THIS MOD
===========================

Map Menu: Sort by distance
==========================
The Player Owned list can be sorted by distance from the player or from the last selected object.
Note that Egosoft's sorting icons (the up and down arrows) signify direction of the list NOT ascending descending orders.
E.g. The down arrow actually sorts the list in ascending order. The list is sorted from least to greatest.

Map Menu: Mission Guidance tab
==============================
Any mission with the "missiontype.guidance" will now be listed in the Mission Guidance tab.
In the base game, the Mission Guidance tab lists only the Guidance created manually with the right-click mouse button. 

The "Set to inactive" and "Set to active" buttons are available on missions listed in the Mission Guidance tab.
The base game makes these buttons unavailable for Guidance Missions.

Map Menu: selectComponent mode
==============================
The selectComponent mode is now available to use from directly within the Map Menu. In the base game, the use of this mode is limited to conversations triggered from the Mission Director (md). E.g. &lt;open_conversation_menu menu="MapMenu" param="[0, 0, true, player.entity, null, 'selectComponent', ['kTFTR_set_destination', [class.ship_s, class.ship_m, class.ship_l, class.ship_xl, class.station]]]" /&gt;. Which then triggers an "event_conversation_next_section" with the menu.modeparam[1] as the section of the conversation. In this version, this mode can be called directly from the Map Menu.

To use:
1. Call "mapMenu.setSelectComponentMode (returnsection, classlist, category, playerowned, customheading, screenname)"
2. The parameters are described at the top of the base game's menu_map.lua file. They are described in more detail at the top of UIX's kuertee_menu_map.lua file.
3. To trigger an "AddUITriggeredEvent" after the player selects an object, set screenname in the mapMenu.setSelectComponentMode call.
4. To disable the default "event_conversation_next_section" after the player selects an object, set returnsection to nil in the mapMenu.setSelectComponentMode call.

Requirement
===========
SirNukes Mod Support APIs mod (https://www.nexusmods.com/x4foundations/mods/503) - to load the custom Lua files

Install
=======
-Unzip to 'X4 Foundations/extensions/kuertee_ui_extensions/'.
-Make sure the sub-folders and files are in 'X4 Foundations/extensions/kuertee_ui_extensions/' and not in 'X4 Foundations/extensions/kuertee_ui_extensions/kuertee_ui_extensions/'.

Uninstall
=========
-Delete the mod folder.

Troubleshooting
===============
(1) Do not change the file structure of the mod. If you do, you'll need to troubleshoot problems you encounter yourself.
(2) Allow the game to log events to a text file by adding "-debug all -logfile debug.log" to its launch parameters.
(3) Enable the mod-specific Debug Log in the mod's Extension Options.
(4) Play for long enough for the mod to log its events.
(5) Send me (at kuertee@gmail.com) the log found in My Documents\Egosoft\X4\(your player-specific number)\debug.log.

History
=======
v6.0.0007, 25 Mar 2023:
-Bug-fix: Removed function no longer required by UIX.

v6.0.0006, 16 Mar 2023:
-Tweak: Compatibility with 6.0 beta 6.

v6.0.0005, 13 Mar 2023:
-Tweak: Compatibility with 6.0 beta 5.

v6.0.00041, 24 Feb 2023:
-Tweak: Compatibility with 6.0 beta 4.

v6.0.0004, 18 Feb 2023:
-Tweak: Transaction Log: The graph is half its screen's height, giving Trade Analytics mod (https://www.nexusmods.com/x4foundations/mods/764) more vertical space.

v6.0.0002, 11 Feb 2023:
-Tweak: Compatibility with 6.0 beta 3.
-Bug-fix: The Logbook on the Map Menu would make the menu unresponsive.

v6.0.0001, 07 Feb 2023:
-Tweak: Compatibility with 6.0 public beta
-Removed: Sort by Name, then Sector, then Id Code. Already in the 6.x base game.
-Removed: Logbook entries of non-player-owned properties. Already in the 6.x base game.
-Removed: Auto-expand of subordinates list. Already in the 6.x base game.
-Removed: Mission progress in the mission objective list. Already in the 6.x base game.

v5.1.0314, 06 Dec 2022:
-Tweak: removed the right-click distance tool when measuring distance to a map point in another sector. The distance value is just wrong. But the distance between two objects across any number of sectors is still available and correct.
-Tweak: added callback for Mission menu that allows new actions to be added. i.e. Waypoint Field for Deployments mod.
-New features: callbacks for Station Overview menu, Station Configuration menu, and Helper API to support unreleased Trade Analytics mod features.

v5.1.0307, 29 Sep 2022:
-Bug-fix: Removed the stutter when the map is open. The bug was introduced when the sort by name then sector was added in a previous version.
-Bug-fix: Trade Analytic mod's location and intended sector destination display wasn't working.
-Bug-fix: Auto-expand feature was preventing the subordinates list from collapsing. Note that the base-game's functionality have station subordinates lists closed by default. 

v5.1.0306, 18 Sep 2022:
-Tweak: Expanding a fleet or a station will auto expand their ship sections.
-New feature: Callbacks to support Trade Analytic's new idlers and away icons and location (final sector destination) ship row data.

v5.1.0303, 1 Sep 2022:
-New feature: Sort by distance from: Player or selected object in the Player Owned menu.
-Tweak: Sort by Name is sort by name, then sector, then object id. The base-game sorting order was by name then by object id - which is useless. :D
-New feature: The Logbook button in the Information menu is now enabled for all objects. If an object has a logbook entry, it's allowed to be listed here.
-Note: These new quality-of-life features are, of course, available in games that load this new kuertee_menu_map.lua file. A lot of my other mods do.

v5.1.0301, 17 Jul 2022:
-Returned feature: Support for Subsystem Targeting Orders.
-Bug-fix: (For real this time.) Re-enabled custom HUDs.

v5.1.0012, 12 Jun 2022:
-Bug-fix: The last version prevented custom HUDs (e.g. the destruction countdown from my Alternatives To Death mod) from showing.

v5.1.0011, 27 May 2022:
-Bug-fix: Removed an FPS killer. Thanks to Mycu for finding the problem.

v5.1.0001, 8 Apr 2022:
-Compatibility: Updated ship configuration menu with 5.1 changes.

v5.0.001, 17 Mar 2022:
-Bug-fix: I missed adding the Reactive Docking support into the previous 5.0.x betas.

v5.0.0008 BETA, 9 Mar 2022:
-New feature: new call-backs by Mycu for his new upcoming mod.

v5.0.0007 BETA, 2 Mar 2022:
-Bug-fix: Updates to work in the v5.0 RC 1 of the base game.

v5.0.00061 BETA, 28 Feb 2022:
-Bug-fix: Update kuertee_menu_ship_configuration.lua to include 5.0 beta 6 version of menu_ship_configuration.lua of the base game.

v4.2.0807, 9 Mar 2022:
-New feature: new call-backs by Mycu for his new upcoming mod.

v5.0.0006 BETA, 24 Feb 2022:
-Bug-fix: Updates to work in the v5.0 beta 6 of the base game. Includes updates from v4.2.00806.

v4.2.0806, 24 Feb 2022:
-New feature: kuertee_menu_ship_configuration.lua: call-back by mycu: displaySlots_on_before_create_button_mouseovertext ()

v5.0.0002 BETA, 17 Feb 2022:
-Bug-fix: Updates to work in the v5.0 beta 5 of the base game.

v5.0.0001 BETA, 15 Feb 2022:
-New feature: Updates to work in the v5.0 beta 4 of the base game.

v4.2.0805, 11 Feb 2022:
-New feature: kuertee_menu_map.lua: 3 call-backs by Mycu: refreshInfoFrame2_on_start (), createInfoFrame2_on_menu_infoModeRight (menu.infoFrame2), createRightBar_on_start (config)

v4.2.0804, 2 Feb 2022:
-New feature: new callback in the MapMenu that allows new buttons to be added to accepted mission descriptions to support the mod Emergent Missions' "Add A Ship Or Fleet" to that mod's missions.

v4.2.0801, 24 Jan 2022:
-New feature: new callbacks in the MapMenu to disable mission offer buttons to support the Emergent Missions' download data from mission feature of its Search And Destroy mission types.

v4.2.06, 31 Dec 2021:
-Bug-fix: The distance tool of the previous version killed the Repeat Orders function. Fixed now.

v4.2.05, 24 Dec 2021:
-Bug-fix: The distance tool wasn't working when taking measurements from accelerators.

v4.2.04, 22 Dec 2021:
-New feature: Distance tool: The Interact Menu (i.e. right-click) shows the distance from the selected object or from the last left-click on the holo-map. Requires a mod that loads the new kuertee_menu_interactmenu.lua file. E.g. Trade Analytics (https://www.nexusmods.com/x4foundations/mods/764) and/or Waypoint Fields For Deployment (https://www.nexusmods.com/x4foundations/mods/585).

v4.2.0, 10 Dec 2021:
-Tweak: PlayerInfo menu: The callback, "createFactions_on_before_render_licences", now occurs BEFORE the list of faction licences - to support the new 4.x 2-panel factions list.

v4.1.03, 06 Nov 2021:
-Tweak: PlayerInfo menu: Allow custom panels to be shown next to default panels.

v4.1.02, 16 Sep 2021:
-Bug-fix: hiring or "work elsewhere" ui was unresponsive when selecting the position's new location.

v4.1.01, 14 Sep 2021:
-Bug-fix: unresponsive right-click "Select" button e.g. when hiring construction ships.

v4.1.0, 14 Sep 2021:
-New feature: compatibility with version 4.1 of the game.

For v4.0 of the game:
v2.2.4, 9 Sep 2021:
-New feature: call back in Transaction Log screen to support UI: Trade Analytics (https://www.nexusmods.com/x4foundations/mods/764).

For v4.1beta1 of the game:
v2.2.0, 15 Jun 2021:
-New feature: compatibility with 4.1beta1 of the game.
-New feature: playerinfo menu new callback: onRowChanged.

For v4.0 of the game:
v2.2.3, 5 Aug 2021:
-New feature: support for Accessibility Features mod (https://www.nexusmods.com/x4foundations/mods/748).

For v4.0 of the game:
v2.2.2, 11 Jul 2021:
-Tweak: Removed an unnecessary argument in onRowChanged () from kuertee_menu_playerinfo.lua added in v2.2.1.

For v4.0 of the game:
v2.2.1, 19 Jun 2021:
-Compatibility: Update so the previous changes for v4.1beta1 of the game work in v4.0 of the game.

For v4.0 of the game:
v2.1.2, 16 Jun 2021:
-New feature: playerinfo menu new callback: onRowChanged.

v2.1.1, 29 May 2021:
-New feature: show objective progress for current objective in mission description.
-New callback: createMissionMode_replaceMissionModeCurrent for mission switching between original mission and Waypoint Field mission in WFFD mod.

v2.1.0, 14 May 2021:
-New callbacks: UserQuestionMenu.createInfoFrame_custom_frame_properties, UserQuestionMenu.createTable_new_custom_table: allows the creation of new menus that look like they are not connected to other menus. See my other mod, "Modification parts trader".

v2.0.6, 16 Apr 2021:
-New supported mods: Allectus' Subsystem Targeting, Runkn's Reactive Docking. Compatibility code by Forleyor.

v2.0.5, 29 Mar 2021:
-Bug-fix: Too many columns bug in my changes to the Property Owned Category tabs.

v2.0.4, 26 Mar 2021:
-Update for 4.0.0 hot-fix 2 beta 1.
-Tweak: Property Owned Categories rendering with out unsightly gaps when mods add new Categories, e.g. like Crime Has Consequences do.

v2.0.3, 20 Mar 2021:
-Bug-fix: Property Owned menu hanging bug-fix.

v2.0.2, 17 Mar 2021:
-Bug-fix: PlayerInfo menu fix: the 2ndary tables (logo, paint mod, faction, etc.) weren't getting rendered.

v2.0.1, 17 Mar 2021:
-Update for version 4.0 of the base game.

v2.0.0, 11 Mar 2021:
-Updated for version 4.0 beta 11 of the base game.

v1.2.2, 15 Dec 2020:
-Allows the "selectComponent" mode to work directly from the MapMenu instead of only from the ConversationMenu.
-Also for "selectComponent" mode, if menu.modeparam[6] is set, an "AddUITriggeredEvent", with screen = menu.modeparam[6] and control = "select_component", will trigger.
-Also for "selectComponent" mode, if menu.modeparam[1] is nil, the next conversation section will not trigger.
-Documented the two features (Mission Guidance tab, and selectComponent mode directly from the menu) that are not related to the call-backs available in this mod. See the section "Documentation".

v1.2.1, 13 Dec 2020:
-New feature: Support for Info Center (https://www.nexusmods.com/x4foundations/mods/268) by Forleyor provided by Forleyor.

v1.2.0, 8 Dec 2020:
-New feature: Allow mods to create guidance missions (i.e. missiontype.guidance) that will be listed in the Guidance Missions tab. This also enables the Set Active and Set Inactive buttons in missions listed in the Guidance Missions tab. Examples of these are my mods: Loot mining, Ship scanner, Signal leak hunter - increasing range, Station scanner, and Waypoint fields for deployments.

v1.1.0, 2 Nov 2020:
-New feature: Features that allow totally custom panels that work like the Objects and Properties panel. I.e. Items in these custom panels are interactive and can be clicked, multi-selected, right-clicked, expanded, etc. See the UI screenshots in my "Crime has consequences" mod (https://www.nexusmods.com/x4foundations/mods/566).

v1.0.0, 27 Aug 2020: Initial release.
