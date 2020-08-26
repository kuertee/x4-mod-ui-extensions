UI Extensions and HUD v0.9.0 beta
https://www.nexusmods.com/x4foundations/mods/552
by kuertee

Mod effects:
============
Modded Lua files with callbacks to allow more than one mod to change the same UI element. Functionality to add new HUD elements to the Top Level Menu.

Documentation:
==============
Soon.

But the callbacks, along with their function parameters and their expected returns, are listed in each of the new Lua files. Learning at which point in the code they execute is as easy as searching for them in the code. Examples on how they are used can be seen in my mods that use them. My mods "High security rooms are locked" and "Teleport from transporter" both have changes to the "TransporterMenu". With "UI Extensions and HUD", the changes from both mods can be applied. Without "UI Extensions and HUD", only one could.

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
