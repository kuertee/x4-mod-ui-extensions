UI Extensions and HUD
https://www.nexusmods.com/x4foundations/mods/552
Code: https://github.com/kuertee/x4-mod-ui-extensions
by kuertee

What this is:
=============
Modded Lua files with callbacks to allow more than one mod to change the same UI element. Functionality to add new HUD elements to the Top Level Menu.

Update:
=======
v1.1.0, 2 Nov 2020:
-New feature: Features that allow totally custom panels that work like the Objects and Properties panel. I.e. Items in these custom panels are interactive and can be clicked, multi-selected, right-clicked, expanded, etc. See the UI screenshots in my "Crime has consequences" mod (https://www.nexusmods.com/x4foundations/mods/566).

Mod effects:
============
This is a modder's resource/API. By itself, this mod does not affect the game.

Modders can use this API to mod the game's Lua files with compatibility with other mods that also use this API.

Without this API, some Lua elements can be modified by only one mod. For example, my mods, "NPC reactions/NPC taxi" and "Teleport from transporter room" add buttons to the bottom of the Transporter Room panel. Because its Lua's display () function constructs its frame, table, rows, and content AND THEN immediately calls the frame:display () function, it is impossible for both mods to "rewrite" the display () function and expect both "rewrites" to work.

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
v1.0.0, 27 Aug 2020: Initial release.
