UI Extensions and HUD
https://www.nexusmods.com/x4foundations/mods/552
Code: https://github.com/kuertee/x4-mod-ui-extensions
by kuertee. Contributors: Erixon, Forleyor, Mycu, Runekn, AlexandreTK, IALuir, sticeIO.

Updates
=======
v7.1.19, 25 Jan 2025:
-New feature: UI callback, updatePlotSize_on_before_extend, in Map Menu for sticeIO's mod.

v7.1.18, 12 Jan 2025:
-New: UI Call-backs for the AEGS Faction mod by IALuir.

Instructions for players
========================
Just install UI Extensions as normal - that is IF you have a mod that requires UI Extensions.
You don't need UI Extensions if you're not using mods that require UI Extensions.
When extracting the package from github, ensure that the folder you install the mod to is: "game/extensions/kuertee_ui_extensions/".
Extracting the package from Nexus Mods will extract it to "game/extensions/kuertee_ui_extensions/". But be sure it does anyway.
Read the CHANGES BUILT INTO THIS MOD (for players) section.

Instructions for developers
===========================
An overview on how to mod for UIX:
1. Install the mod as a player.
2. Copy the "game/extensions/kuertee_ui_extensions/ui" folder into the "game/ui" folder. This will overwrite UIX's XPL files into the game.
3. Launch the game with the "-prefersinglefiles" option. This will make the game use UIX XPL files instead of the base game's corresponding files that are in its cat/dat files.
4. Examine one of the callbacks in any of those XPL files. Search for "callback". Add any callback you need in any of the XPL files IN THE GAME FOLDER. If you need a add callbacks to a menu file that UIX doesn't have let me know (on Discord, Nexus or kuertee@gmail.com).
5. When done adding your callbacks, send me the changed XPL files.
6. I'll merge them with the master UIX files.
7. We'll coordinate release dates so that the new UIX mod with your callbacks is released near the time you release your mod.

An an alternative installation instructions for advanced developers:
1. Pull the github files into the "game/extensions/kuertee_ui_extensions" folder.
2. To copy the UIX XPL files that are in "game/extensions/kuertee_ui_extensions/ui" to the "game/ui" folder, run the "dev-make_symlink_files.bat". This will copy-linked files from UIX's folder into the game folder. Any changes you make in the UIX folder will be automatically mirrored in the files in the game folder.
3. Examine one of the callbacks in any of those XPL files. Search for "callback". Add any callback you need in any of the XPL files IN THE MOD FOLDER. If you need a add callbacks to a menu file that UIX doesn't have let me know (on Discord, Nexus or kuertee@gmail.com).
4. When done adding your callbacks, commit your changes to github.
5. We'll coordinate release dates so that the new UIX mod with your callbacks is released near the time you release your mod.

Any questions, it's best to @ me on Egosoft's unofficial Discord modding channel: https://discord.gg/RzAGhcY

Read the CHANGES BUILT INTO THIS MOD sections.

Mod-specific lua files
======================
The actual lua that modifies the UI need to exist in the mod's lua file in the mod's folder.
The file needs to be named the lua file it will be modding.
Extract and examine "kuertee_uix_mod_sample.ZIP".
It adds a "Hello world" menu item in both the left and right side bars of the Map Menu.
In this example, the lua file is named: "menu_map_uix.lua" because it will be modding the base-game's "menu_map.lua" file.

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

CHANGES BUILT INTO THIS MOD (for players)
=========================================

Map Menu: Distance tool
=======================
Click on an object or a position on the map.
Right-click on another object or another position on the map.
The distance between the two points will be listed.

Map Menu: Multi-rename
======================
When renaming multiple objects, these special texts in the name will be replaced with the listed value.
	$name: The object's current name.
	$name_AR: The object's internal name used with UniTrader's Advanced Renaming.
	$i: The object's position in the list based on descending DPS value.
Examples:
	"Red $i" will name all the objects "Red X" in which X is the object's order in the list.
	"$name $i" will add the object's order in the list to the object's current name.

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

CHANGES BUILT INTO THIS MOD (for developers)
============================================

Map Menu: selectComponent mode
==============================
The selectComponent mode is now available to use from directly within the Map Menu. In the base game, the use of this mode is limited to conversations triggered from the Mission Director (md). E.g. &lt;open_conversation_menu menu="MapMenu" param="[0, 0, true, player.entity, null, 'selectComponent', ['kTFTR_set_destination', [class.ship_s, class.ship_m, class.ship_l, class.ship_xl, class.station]]]" /&gt;. Which then triggers an "event_conversation_next_section" with the menu.modeparam[1] as the section of the conversation. In this version, this mode can be called directly from the Map Menu.

To use:
1. Call "mapMenu.setSelectComponentMode (returnsection, classlist, category, playerowned, customheading, screenname)"
2. The parameters are described at the top of the base game's menu_map.lua file. They are described in more detail at the top of UIX's kuertee_menu_map.lua file.
3. To trigger an "AddUITriggeredEvent" after the player selects an object, set screenname in the mapMenu.setSelectComponentMode call.
4. To disable the default "event_conversation_next_section" after the player selects an object, set returnsection to nil in the mapMenu.setSelectComponentMode call.

Add Custom Actions/Orders Group to the Interact Menu (via MD)
=============================================================
1. Load UIX's customised Interact Menu with: <raise_lua_event name="'Lua_Loader.Load'" param="'extensions.kuertee_ui_extensions.ui.kuertee_menu_interactmenu'"/>
2. At <event_ui_triggered screen="'UIXInteractMenu'" control="'loaded'" />, add the Custom Actions/Orders below.
3. Add the new Custom Actions/Orders Group Id <raise_lua_event name="'Interact_Menu_API.Add_Custom_Actions_Group_Id'" param="'my_custom_actions_group_id'" />
4. Add the new Custom Actions/Orders Group Name <raise_lua_event name="'Interact_Menu_API.Add_Custom_Actions_Group_Text'" param="'My Custom Actions/Orders Group'" />
5. Use the new id in Mod Support API's Add_Action function like this:
					<signal_cue_instantly cue="md.Interact_Menu_API.Add_Action" param = "table[
						$id = 'my_custom_action_1,
						$section = 'my_custom_actions_group_id',
						$text = 'My Custom Action 1',
						$mouseover = 'My Custom Action 1 mouse over',
						$callback = My_Custom_Action_1_Cue
					]" />
					<signal_cue_instantly cue="md.Interact_Menu_API.Add_Action" param = "table[
						$id = 'my_custom_action_2,
						$section = 'my_custom_actions_group_id',
						$text = 'My Custom Action 1',
						$mouseover = 'My Custom Action 2 mouse over',
						$callback = My_Custom_Action_2_Cue
					]" />
6. The custom commands will be added to both the Custom Actions and Custom Orders sub-menus.
7. To add only to one sub-menu and not the other, start the section name with either "actions_" or "orders_". E.g. "actions_my_custom_actions" will add the custom action to only the Custom Actions sub-menu. And "orders_my_custom_orders" will add the custom order to only the Custom Orders sub-menu.

Requirements
============
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

Credits
=======
kuertee
French localisation by Calvitix.

History
=======
v7.1.17, 27 Dec 2024:
-New: French language file. Thanks, Calvitix!
-Bug-fix: Multi-rename function was sometimes still adding some objects (e.g. the sector) that shouldn't be renamed in the list of objects to rename.

v7.1.15, 11 Nov 2024:
-Bug-fix: The multi-rename feature was buggy. e.g. preventing the single-rename function from working. In this version, the right-clicked object needs to be in the selected list for the multi-rename button to be active.

v7.1.14, 7 Nov 2024:
-Bug-fix: The multi-rename feature was renaming a non-player-owned object if it was right-clicked on along with selected playerr objects.

v7.1.12, 2 Nov 2024:
-New feature: Rename multiple objects. More information in the Multi-rename section.
-New feature: The Custom Actions menu is shown when no menu is valid. E.g. when selecting multiple stations. Allows setting a station profile from the Trade Analytics mod to multiple stations at once.
-Tweak: Tweaked some callbacks for UT Advanced Renaming.

v7.1.11, 18 Oct 2024:
-Bug-fix: one more deregisterCallback bug.

v7.1.10, 17 Oct 2024:
-New callbacks: for an upcoming mod from NS.88.NS.
-Bug-fixes: deregisterCallback was only not deregistering callbacks except when the first callback registered is deregistered.

v7.1.09, 10 Oct 2024:
-New callbacks: to support updates to some mods (e.g. Mycu's Equipment Tooltip, etc.).

v7.1.07, 17 Sep 2024:
-New callbacks in the Station Overview menu (for an update for the Trade Analytics mod) and in the Encyclopedia menu (for a feature in the StarWars Interworlds mod).

v7.1.06, 8 Aug 2024:
-Compatibility: Requires base game v7.10.

v7.1.05, 1 Aug 2024:
-Compatibility: Requires base game v7.10 beta 5.

v7.1.04, 29 Jul 2024:
-Compatibility: Requires base game v7.10 beta 4.

v7.1.031, 22 Jul 2024:
-New feature: New Encyclopedia callback for extra ship data after ship's weapons list.

v7.1.03, 19 Jul 2024:
-Compatibility: Requires base game v7.10 beta 3.

v7.1.02, 13 Jul 2024:
-Compatibility: Requires base game v7.10 beta 2.

v7.1.01, 7 Jul 2024:
-Bug-fix: Some mods (e.g. my Trade Analytics) were trying to update the Transaction Log menu even when it wasn't open.
-Tweak: Extensions menu lists enabled mods first before disabled mods.
-Bug-fix: Callback 7.x compatibility in Ship Configuration menu.

v7.1.00, 3 Jul 2024:
-Compatibility: Requires base game v7.10 beta 1.

v7.0.02, 28 Jun 2024:
-Compatibility: Requires base game v7.00 HF 1.

beta v7.0.01, 14 Jun 2024:
-Compatibility: Requires base game v7.00 RC 1.

beta v7.0.008, 8 Jun 2024:
-Compatibility: Requires base game v7.0.0 beta 8.

beta v7.0.007, 30 May 2024:
-Compatibility: Requires base game v7.0.0 beta 7.

beta v7.0.006, 23 May 2024:
-Compatibility: Requires base game v7.0.0 beta 6.

beta v7.0.005, 9 May 2024:
-Compatibility: Requires base game beta v7.0.0.

beta v7.0.002, 10 Apr 2024:
-Bug-fix: missed lines from base beta 7.0.0 that resulted in the trade sections not showing in the Interact Menu.

beta v7.0.001, 7 Apr 2024:
-Compatibility: Requires base game beta v7.0.0.

v6.2.014, 4 Mar 2024:
-Bug-fix: The callback for starting new games with an intro monologue (e.g. Segaris Pioneer gamestart) was sending an invalid variable causing the game to not proceed after the intro monologue.

v6.2.012, 19 Feb 2024:
-Bug-fix: UIX wasn't properly getting initialised sometimes - i.e. when no other mod requests UIX functions. UIX should get initialised regardless. Fixed in this version.

v6.2.011, 18 Feb 2024:
-New feature: (by Erixon) New callbacks for smart_supply mod to be released by Erixon soon after this release.
-New feature: (by Forleyor) New callbacks for  UniTrader's Advanced Renaming mod (https://github.com/UniTrader/ut_advanced_renaming).
-New feature: (by Mycu) New callbacks for 'Verbose transaction log' mod to be released by Erixon soon after this release.
-New features: New callbacks for Grouped save files mod (https://www.nexusmods.com/x4foundations/mods/1310) that is required by the new Ironman mode feature of the Alternatives to death mod (https://www.nexusmods.com/x4foundations/mods/551).

v6.2.010, 28 Dec 2023:
-New feature: New callback in the Map Menu for an upcoming mod.

v6.2.0093, 24 Dec 2023:
-Bug-fix: Trigger an init event from UIX even if no mods have custom lua files loaded in case the event is required by a mod's MD.
-Bug-fix: The github releases were crashing the game due to github changing the line feed character in the XMLs and likely in the cat/dat files. ref: https://docs.github.com/en/get-started/getting-started-with-git/configuring-git-to-handle-line-endings

v6.2.009, 17 Dec 2023:
-New feature: Lua files of mods are now loaded when the base-game lua files are loaded. i.e. They don't need a signal from the Mission Director like in previous versions. Mods that use the old method still work, so there's no need for the mod author to update their mod. This new version allows modifications to lua files that are not in-game specific. E.g. customgame.lua.

v6.2.008, 9 Dec 2023:
-New feature: New call back to the Ship Configuration menu for another unreleased mod.

v6.2.007, 4 Dec 2023:
-Tweak: The Custom Actions/Orders are now listed after the trade orders.
-New features: Ship Configuration menu and Encyclopedia menu callbacks for a new unreleased mod.

v6.2.005, 18 Oct 2023:
-Bug-fix: "Station Configuration > Configure individual buy offers" menu was broken without my Trade Analytics mod.

v6.2.001, 2 Sep 2023:
-Tweak: 6.2 Compatibility.

v6.1.004, 1 Aug 2023:
-Modders resource: UIX's Interact Menu now sends a signal to the MD that it has been loaded. The modder can listen for this before setting up their custom actions/orders.
-Compatibility: Mycu's tweaks for better compatibility with his updated mods.

v6.1.003, 29 Jul 2023:
-Modders resource: Custom orders are now added to the Custom Actions and Custom Orders sub-menus. To add only to one or the other, prefix the section name with either "actions_" or "orders_". Read the Add Custom Actions/Orders Group to the Interact Menu (via MD) section below.

v6.1.001, 27 Jun 2023:
-modders resource: Add Custom Actions/Orders Group to the Interact Menu (via MD):
1. Load UIX's customised Interact Menu with: <raise_lua_event name="'Lua_Loader.Load'" param="'extensions.kuertee_ui_extensions.ui.kuertee_menu_interactmenu'"/>
2. Add the new Custom Actions/Orders Group Id <raise_lua_event name="'Interact_Menu_API.Add_Custom_Actions_Group_Id'" param="'my_custom_actions_group_id'" />
3. Add the new Custom Actions/Orders Group Name <raise_lua_event name="'Interact_Menu_API.Add_Custom_Actions_Group_Text'" param="'My Custom Actions/Orders Group'" />
4. Use the new id in Mod Support API's Add_Action function like this:
					<signal_cue_instantly cue="md.Interact_Menu_API.Add_Action" param = "table[
						$id = 'my_custom_action_1,
						$section = 'my_custom_actions_group_id',
						$text = 'My Custom Action 1',
						$mouseover = 'My Custom Action 1 mouse over',
						$callback = My_Custom_Action_1_Cue
					]" />
					<signal_cue_instantly cue="md.Interact_Menu_API.Add_Action" param = "table[
						$id = 'my_custom_action_2,
						$section = 'my_custom_actions_group_id',
						$text = 'My Custom Action 1',
						$mouseover = 'My Custom Action 2 mouse over',
						$callback = My_Custom_Action_2_Cue
					]" />

v6.0.004, 10 May 2023:
-Mycu's contribution: custom nested Interact Menu actions.
-Mycu's contribution: support for Urgent Orders mod and Subsystem Targeting Orders mod.
-Mycu's contribution: support for Custom Tabs mod.
-Mycu's contribution: new map menu callback: displayDefaultBehaviour_change_param_behaviouractive.
-Note: From here-on, I'll be noting the contributions of other authors in the change logs. Apologies to Forleyor and Runekn for not noting them before. But you're still credited in the code directly in your code comments.

v6.0.003, 25 Apr 2023:
-Bug-fix: Infocentre compatibility.
-Bug-fix: Open Briefing button was disblaed unless the Emergent Missions mod was installed.

v6.0.002, 13 Apr 2023:
-Tweaks: Compatibility with v6.0 final of the base game.

v6.0.001, 4 Apr 2023:
-Tweaks: Compatibility with v6.0 RC 1 of the base game.

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
