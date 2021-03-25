UI Extensions and HUD
https://www.nexusmods.com/x4foundations/mods/552
Code: https://github.com/kuertee/x4-mod-ui-extensions
by kuertee

Updates:
========
v2.0.4, 26 Mar 2021:
-Update for 4.0.0 hot-fix 2 beta 1.
-Tweak: Property Owned Categories rendering with out unsightly gaps when mods add new Categories, e.g. like Crime Has Consequences do.

v2.0.3, 20 Mar 2021:
-Bug-fix: Property Owned menu hanging bug-fix.

v2.0.2, 17 Mar 2021:
-Bug-fix: PlayerInfo menu fix: the 2ndary tables (logo, paint mod, faction, etc.) weren't getting rendered.

v2.0.1, 17 Mar 2021:
-Update for version 4.0 of the base game.

Features:
=========
Modded Lua files with callbacks that allow more than one mod to change the same UI element.

Functionality that adds HUD elements to the Top Level Menu.

Allows other mods to create guidance missions (i.e. missiontype.guidance) that will be listed in the Guidance Missions tab. Also enables the Set Active and Set Inactive buttons in missions listed in the Guidance Missions tab. Examples of these are my mods: Loot mining, Ship scanner, Signal leak hunter - increasing range, Station scanner, and Waypoint fields for deployments.

Mod effects:
============
This is a modder's resource/API. By itself, this mod does not affect the game.

Modders can use this API to mod the game's Lua files that helps compatibility with other mods that also use this API.

Without this API, some Lua elements can be modified by only one mod. For example, my mods, "NPC reactions: NPC taxis" and "Teleport from transporter room" add buttons to the bottom of the Transporter Room panel. Because its Lua's display () function constructs its frame, table, rows, and content AND THEN immediately calls the frame:display () function, it is impossible for both mods to "rewrite" the display () function and expect both "rewrites" to work.

With this API, specifically its callbacks, it is possible.

Files in this API will be referred to as UIXs.

Summary of how to use:
======================
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

Documentation:
==============
Soon.

But the callbacks, along with their function parameters and their expected returns, are listed in each of the new Lua files. Learning at which point in the code they execute is as easy as searching for them in the code. Examples of how they are used can be seen in my mods that use them. My mods "NPC reactions/NPC taxi" and "Teleport from transporter room" both have changes to the "TransporterMenu".

But here is documentation on NEW features (not connected to mod-specific changes via call-backs) that UIX offers.

Map Menu: Mission Guidance tab
==============================
Any missions with the "missiontype.guidance" will now be listed in the Mission Guidance tab.  In the base game, the Mission Guidance tab is to only the Guidance created manually with the right-click mouse button. 

The "Set to inactive" and "Set to active" buttons are available on missions listed in the Mission Guidance tab. The base game makes these buttons unavailable for Guidance Missions.

Map Menu: selectComponent mode
==============================
The selectComponent mode is now available to use from directly within the Map Menu. In the base game, the use of this mode is limited to conversations triggered from the Mission Director (md). E.g. &lt;open_conversation_menu menu="MapMenu" param="[0, 0, true, player.entity, null, 'selectComponent', ['kTFTR_set_destination', [class.ship_s, class.ship_m, class.ship_l, class.ship_xl, class.station]]]" /&gt;. And it triggered an "event_conversation_next_section" with the menu.modeparam[1] as the section of the conversation.

To use:
1. Call "mapMenu.setSelectComponentMode (returnsection, classlist, category, playerowned, customheading, screenname)"
2. The parameters are described at the top of the base game's menu_map.lua file. They are described in more detail at the top of UIX's kuertee_menu_map.lua file.
3. To trigger an "AddUITriggeredEvent" after the player selects an object, set screenname in the mapMenu.setSelectComponentMode call.
4. To disable the default "event_conversation_next_section" after the player selects an object, set returnsection to nil in the mapMenu.setSelectComponentMode call.

Requirement:
============
SirNukes Mod Support APIs mod (https://www.nexusmods.com/x4foundations/mods/503) - to load the custom Lua files

Install:
========
-Unzip to 'X4 Foundations/extensions/kuertee_ui_extensions/'.
-Make sure the sub-folders and files are in 'X4 Foundations/extensions/kuertee_ui_extensions/' and not in 'X4 Foundations/extensions/kuertee_ui_extensions/kuertee_ui_extensions/'.
-If 'X4 Foundations/extensions/' is inaccessible, try 'Documents/Egosoft/X4/XXXXXXXX/extensions/kuertee_ui_extensions/' - where XXXXXXXX is a number that is specific to your computer.

Uninstall:
==========
-Delete the mod folder.

History
=======
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
