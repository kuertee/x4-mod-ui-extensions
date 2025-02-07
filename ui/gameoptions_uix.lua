local menu = Helper.getMenu("OptionsMenu")
if menu.uix_callbacks then
    -- OptionsMenu already UIX initialised by stand-alone UIX mod, do not continue with this file.
    Helper.debugText_forced("gameoptions_uix.lua already loaded by stand-alone UIX mod.")
    return
end

local ModLua = {}

local ffi = require("ffi")
local C = ffi.C
ffi.cdef[[]]

--- config ---

local config = {
    contextLayer = 2,
    optionsLayer = 4,
    topLevelLayer = 5,

    backarrow = "table_arrow_inv_left",
    backarrowOffsetX = 3,

    font = "Zekton outlined",
    fontBold = "Zekton bold outlined",

    headerFontSize = 13,
    infoFontSize = 9,
    standardFontSize = 10,

    headerTextHeight = 34,
    subHeaderTextHeight = 22,
    standardTextHeight = 19,
    infoTextHeight = 16,

    headerTextOffsetX = 5,
    standardTextOffsetX = 5,
    infoTextOffsetX = 5,

    idleTime = 10,

    saveReloadInterval = 60,

    hubFadeOutTime = 2,
    hubFadeOutHoldDuration = 0.1,

    numRecommendedGamestarts = 2,

    minGamestartInfoRows = 8,
}

config.frame = {
    x = C.IsVRMode() and 100 or 0,
    y = 0,
    width = 800,
    widthExtraWide = 1220,
    height = 1080,
    bgTexture = "optionsmenu_bg",
    fgTexture = "", --C.IsVRMode() and "" or "optionsMenu_fg",
}

config.table = {
    x = 45,
    y = 45,
    width = 710,
    widthExtraWide = 1130,
    widthWithExtraInfo = 370,
    height = 980,
    arrowColumnWidth = 20,
    infoColumnWidth = 330,
}

config.headerTextProperties = {
    font = config.fontBold,
    fontsize = config.headerFontSize,
    x = config.headerTextOffsetX,
    y = 6,
    minRowHeight = config.headerTextHeight,
    titleColor = Color["row_title"],
}

config.subHeaderTextProperties = {
    font = config.fontBold,
    fontsize = config.standardFontSize,
    x = config.standardTextOffsetX,
    y = 2,
    minRowHeight = config.subHeaderTextHeight,
    halign = "center",
    titleColor = Color["row_title"],
}

config.subHeaderLeftTextProperties = {
    font = config.fontBold,
    fontsize = config.standardFontSize,
    x = config.standardTextOffsetX,
    y = 2,
    minRowHeight = config.subHeaderTextHeight,
    titleColor = Color["row_title"],
}

config.infoTextProperties = {
    font = config.font,
    fontsize = config.infoFontSize,
    x = config.infoTextOffsetX,
    y = 2,
    wordwrap = true,
    minRowHeight = config.infoTextHeight,
    titleColor = Color["row_title"],
}

config.warningTextProperties = {
    font = config.font,
    fontsize = config.infoFontSize,
    x = config.infoTextOffsetX,
    y = 2,
    wordwrap = true,
    minRowHeight = config.infoTextHeight,
}

config.standardTextProperties = {
    font = config.font,
    fontsize = config.standardFontSize,
    x = config.standardTextOffsetX,
    y = 2,
}

config.standardRightTextProperties = {
    font = config.font,
    fontsize = config.standardFontSize,
    halign = "right",
    x = config.standardTextOffsetX,
    y = 2,
}

config.disabledTextProperties = {
    font = config.font,
    fontsize = config.standardFontSize,
    x = config.standardTextOffsetX,
    y = 2,
    color = Color["text_inactive"],
}

config.input = {
    controltextpage = {
        ["actions"] = 1005,
        ["states"]  = 1006,
        ["ranges"]  = 1007,
    },
    modifiers = {
        [1] = { id = "shift",           name = ReadText(1001, 12644),   offset = 256 },
        [2] = { id = "ctrl",            name = ReadText(1001, 12645),   offset = 512 },
        [3] = { id = "joystickmod1",    name = ReadText(1001, 12745),   offset = 1024,  controller = true },
        [4] = { id = "joystickmod2",    name = ReadText(1001, 12746),   offset = 2048,  controller = true },
    },
    iscontrollermodifier = {
        ["joystickmod1"] = true,
        ["joystickmod2"] = true,
    },
    modifierFilter = 256,
    forbiddenKeys = {
        [1]   = true, -- Escape
        [211] = true, -- Delete
        [466] = true, -- Shift+Insert
        [467] = true, -- Shift+Delete
        [557] = true, -- Ctrl+X
        [558] = true, -- Ctrl+C
        [559] = true, -- Ctrl+V
        [722] = true, -- Ctrl+Insert
    },
    forbiddenMouseButtons = {
        [2]  = true, -- LMB doubleclick
        [4]  = true, -- RMB doubleclick
        [6]  = true, -- MMB doubleclick
        [8]  = true, -- Side1 MB doubleclick
        [10] = true, -- Side2 MB doubleclick
    },
    cheatControls = {
        ["actions"]   = { [120] = true, [121] = true },
        ["states"]    = {},
        ["ranges"]    = {},
        ["functions"] = {},
    },
}
    -- Define input functions here (serveral actions, states or ranges which can only be changed at the same time)
    -- entry: [keycode] = { ["actions"] = { action1, action2, ... }, ["states"] = {}, ["name"] = name for display }
config.input.controlFunctions = {
    [1] = {
        ["name"] = ReadText(1005, 16),  -- "Menu back"
        --["name"] = ReadText(1001, 2669),  -- "Back"
        ["definingcontrol"] = {"actions", 16},
        ["actions"] = { 16, 103, 375 },
        ["states"] = {},
        ["ranges"] = {},
        ["contexts"]= { 1, 2, 3, 4, 5 },
    },
    [2] = {
        ["name"] = ReadText(1001, 2670),    -- "Close"
        ["definingcontrol"] = {"actions", 19},
        ["actions"] = { 19, 104, 326 },
        ["states"] = {},
        ["ranges"] = {},
        ["contexts"]= { 1, 2, 3, 4, 5 },
    },
    [3] = {
        ["name"] = ReadText(1001, 5102),
        ["definingcontrol"] = {"states", 22},
        ["actions"] = { 124 },
        ["states"] = { 1, 22, 23 },
        ["ranges"] = {},
        ["contexts"]= { 1, 2 },
    },
    [4] = {
        ["name"] = ReadText(1006, 12),
        ["definingcontrol"] = {"states", 12},
        ["actions"] = {},
        ["states"] = { 12 },
        ["ranges"] = {},
        ["contexts"]= { 2 },
    },
    [5] = {
        ["name"] = ReadText(1005, 128),
        ["definingcontrol"] = {"actions", 128},
        ["actions"] = { 128, 163 },
        ["states"] = {},
        ["ranges"] = {},
        ["contexts"]= { 1, 2, 10 },
    },
    [6] = {
        ["name"] = ReadText(1005, 129),
        ["definingcontrol"] = {"actions", 129},
        ["actions"] = { 129, 164 },
        ["states"] = {},
        ["ranges"] = {},
        ["contexts"]= { 1, 2, 10 },
    },
    [7] = {
        ["name"] = ReadText(1006, 10),
        ["definingcontrol"] = {"states", 10},
        ["actions"] = { 218 },
        ["states"] = { 10 },
        ["ranges"] = {},
        ["contexts"]= { 2 },
    },
    [8] = {
        ["name"] = ReadText(1006, 11),
        ["definingcontrol"] = {"states", 11},
        ["actions"] = { 217 },
        ["states"] = { 11 },
        ["ranges"] = {},
        ["contexts"]= { 2 },
    },
    [9] = {
        ["name"] = ReadText(1005, 179),
        ["definingcontrol"] = {"actions", 179},
        ["actions"] = { 179, 208 },
        ["states"] = {},
        ["ranges"] = {},
        ["contexts"]= { 1, 2, 10 },
    },
    [10] = {
        ["name"] = ReadText(1005, 175),
        ["definingcontrol"] = {"actions", 175},
        ["actions"] = { 175, 211 },
        ["states"] = {},
        ["ranges"] = {},
        ["contexts"]= { 1, 2 },
    },
    [11] = {
        ["name"] = ReadText(1005, 180),
        ["definingcontrol"] = {"actions", 180},
        ["actions"] = { 180, 231 },
        ["states"] = {},
        ["ranges"] = {},
        ["contexts"]= { 1, 2 },
    },
    [12] = {
        ["name"] = ReadText(1005, 182),
        ["definingcontrol"] = {"actions", 182},
        ["actions"] = { 182, 232 },
        ["states"] = {},
        ["ranges"] = {},
        ["contexts"]= { 1, 2 },
    },
    [13] = {
        ["name"] = ReadText(1005, 113),
        ["definingcontrol"] = {"actions", 113},
        ["actions"] = { 113, 312 },
        ["states"] = {},
        ["ranges"] = {},
        ["contexts"]= { 1, 2, 10 },
    },
    [14] = {
        ["name"] = ReadText(1005, 314),
        ["definingcontrol"] = {"actions", 314},
        ["actions"] = { 314, 315 },
        ["states"] = {},
        ["ranges"] = {},
        ["contexts"]= { 1, 2, 10 },
    },
    [15] = {
        ["name"] = ReadText(1005, 319),
        ["definingcontrol"] = {"actions", 319},
        ["actions"] = { 319, 222 },
        ["states"] = {},
        ["ranges"] = {},
        ["contexts"]= { 1, 2, 10 },
    },
    [16] = {
        ["name"] = ReadText(1005, 303),
        ["definingcontrol"] = {"actions", 303},
        ["actions"] = { 303, 322 },
        ["states"] = {},
        ["ranges"] = {},
        ["contexts"]= { 1, 2, 10 },
    },
    [17] = {
        ["name"] = ReadText(1005, 225),
        ["definingcontrol"] = {"actions", 225},
        ["actions"] = { 225, 323 },
        ["states"] = {},
        ["ranges"] = {},
        ["contexts"]= { 1, 2, 10 },
    },
    [18] = {
        ["name"] = ReadText(1005, 363),
        ["definingcontrol"] = {"actions", 363},
        ["actions"] = { 332, 363 },
        ["states"] = {},
        ["ranges"] = {},
        ["contexts"]= { 1, 2, 10 },
    },
    [19] = {
        ["name"] = ReadText(1005, 364),
        ["definingcontrol"] = {"actions", 364},
        ["actions"] = { 364, 365 },
        ["states"] = {},
        ["ranges"] = {},
        ["contexts"]= { 1, 2, 10 },
    },
    [20] = {
        ["name"] = ReadText(1005, 209),
        ["definingcontrol"] = {"actions", 209},
        ["actions"] = { 209, 369 },
        ["states"] = {},
        ["ranges"] = {},
        ["contexts"]= { 1, 2, 10 },
    },
    [21] = {
        ["name"] = ReadText(1005, 316),
        ["definingcontrol"] = {"actions", 316},
        ["actions"] = { 316, 370 },
        ["states"] = {},
        ["ranges"] = {},
        ["contexts"]= { 1, 2, 10 },
    },
    [22] = {
        ["name"] = ReadText(1005, 320),
        ["definingcontrol"] = {"actions", 320},
        ["actions"] = { 320, 373 },
        ["states"] = {},
        ["ranges"] = {},
        ["contexts"]= { 1, 2, 10 },
    },
    [23] = {
        ["name"] = ReadText(1005, 210),
        ["definingcontrol"] = {"actions", 210},
        ["actions"] = { 210, 372 },
        ["states"] = {},
        ["ranges"] = {},
        ["contexts"]= { 1, 2, 10 },
    },
    [24] = {
        ["name"] = ReadText(1005, 368),
        ["definingcontrol"] = {"actions", 368},
        ["actions"] = { 368, 378 },
        ["states"] = {},
        ["ranges"] = {},
        ["contexts"]= { 9 },
    },
}

config.input.controlsorder = {
    ["space"] = {
        [1] = {
            ["title"] = ReadText(1001, 4865),   -- "Steering: Analog"
            ["mappable"] = true,
            { "ranges", 21, nil, ReadText(1026, 2629) },
            { "ranges", 22, nil, ReadText(1026, 2630) },
            { "ranges", 2 },
            { "ranges", 5 },
            { "ranges", 6 },
            { "ranges", 4, { 1, 2 } },
            { "ranges", 10, { 1, 2 }, nil, true, mousewheelonly = true },
            { "states", 90, { 1, 2 } },
            { "ranges", 32, 2, ReadText(1026, 2629), true },
            { "ranges", 33, 2, ReadText(1026, 2630), true },
            { "ranges", 30, 2, nil, true },
        },
        [2] = {
            ["title"] = ReadText(1001, 4866),   -- "Steering: Digital"
            ["mappable"] = true,
            { "states", 4, { 1, 2 } },
            { "states", 5, { 1, 2 } },
            { "states", 2, { 1, 2 } },
            { "states", 3, { 1, 2 } },
            { "states", 112, { 1, 2 } },
            { "states", 113, { 1, 2 } },
            { "states", 114, { 1, 2 } },
            { "states", 115, { 1, 2 } },
            { "states", 8, { 1, 2 } },
            { "states", 9, { 1, 2 } },
            { "states", 6, { 1, 2 } },
            { "states", 7, { 1, 2 } },
            { "states", 116, { 1, 2 } },
            { "states", 117, { 1, 2 } },
            { "states", 118, { 1, 2 } },
            { "states", 119, { 1, 2 } },
            { "states", 13, { 1, 2 } },
            { "states", 14, { 1, 2 } },
            { "states", 15, { 1, 2 } },
            { "states", 16, { 1, 2 } },
            { "states", 91, { 1, 2 } },
            { "actions", 123, { 1, 2 } },
            { "states", 17, { 1, 2 } },
            { "states", 18, { 1, 2 } },
            { "states", 19, { 1, 2 } },
            { "states", 20, { 1, 2 } },
            { "actions", 7, { 1, 2 }, ReadText(1026, 2600) },
            { "actions", 324, { 1, 2 }, ReadText(1026, 2692) },
            { "actions", 221, { 1, 2 }, ReadText(1026, 2601) },
            { "states", 133, { 1, 2 } },
            { "actions", 261, { 1, 2 } },
            { "actions", 330, { 1, 2 } },
        },
        [3] = {
            ["title"] = ReadText(1001, 2663),   -- "Weapons"
            ["mappable"] = true,
            { "states", 24, { 1, 2 } },
            { "states", 48, { 1, 2 } },
            { "states", 25, { 1, 2 } },
            { "actions", 8, { 1, 2 } },
            { "actions", 9, { 1, 2 } }, -- "Previous weapon"
            { "actions", 10, { 1, 2 } },
            { "actions", 11, { 1, 2 } },    -- "Previous missile"
            { "actions", 331, { 1, 2 } },
            { "actions", 321, { 1, 2 } },   -- "Next ammo"
            { "actions", 307, { 1, 2 } },
            { "actions", 139, { 1, 2 } },
            { "actions", 140, { 1, 2 } },
            { "actions", 141, { 1, 2 } },
            { "actions", 142, { 1, 2 } },
            { "actions", 149, { 1, 2 } },
            { "actions", 150, { 1, 2 } },
            { "actions", 151, { 1, 2 } },
            { "actions", 152, { 1, 2 } },
        },
        [4] = {
            ["title"] = ReadText(1002, 1001),   -- "Modes"
            ["mappable"] = true,
            { "states", 84, display = function () return C.IsVROculusTouchActive() or C.IsVRViveControllerActive() end },
            { "functions", 16 },
            { "actions", 304, { 1, 2 } },
            { "actions", 305, { 1, 2 } },
            { "functions", 17, nil, ReadText(1026, 2610) },
        },
        [5] = {
            ["title"] = ReadText(1001, 7245),   -- "Menu Access"
            ["mappable"] = true,
            { "states", 126, { 1, 2 } },
            { "states", 127, { 1, 2 } },
            { "actions", 317, { 1, 2 } },
            { "functions", 13 },
            { "functions", 14 },
            { "functions", 20 },
            { "functions", 18 },
            { "functions", 22 },
            { "functions", 21 },
            { "functions", 23 },
            { "functions", 3 },
            { "functions", 5, nil, ReadText(1026, 2602) },
            { "functions", 6, nil, ReadText(1026, 2603) },
            { "actions", 327, { 1, 2 }, ReadText(1026, 2651) },
            { "functions", 19, nil, ReadText(1026, 2667) },
            { "actions", 216, 10 },
            { "actions", 371, 10 },
        },
        [6] = {
            ["title"] = ReadText(1001, 2600),   -- "Options Menu"
            ["mappable"] = true,
            { "actions", 132, { 1, 2 } },
            { "actions", 160, { 1, 2 } },
            { "actions", 161, { 1, 2 } },
            { "actions", 162, { 1, 2 } },
            { "actions", 130, { 1, 2 } },
            { "actions", 131, { 1, 2 } },
        },
        [7] = {
            ["title"] = ReadText(1001, 4860),   -- "Camera"
            ["mappable"] = true,
            { "states", 81, { 1, 2, 9 } },
            { "functions", 11, { 1, 2, 9 }, ReadText(1026, 2605) },
            { "actions", 181, { 1, 2, 9 }, ReadText(1026, 2606) },
            { "functions", 12, { 1, 2, 9 }, ReadText(1026, 2607) },
            { "actions", 262, { 1, 2, 9 } },
            { "actions", 353, { 1, 2, 9 } },
            { "states", 70, 9 },
            { "states", 71, 9 },
            { "states", 72, { 1, 2, 9 } },
            { "states", 73, { 1, 2, 9 } },
            { "states", 74, { 1, 2, 9 } },
            { "states", 75, { 1, 2, 9 } },
            { "states", 76, { 1, 2, 9 } },
            { "states", 77, { 1, 2, 9 } },
            { "states", 78, { 1, 2, 9 } },
            { "states", 79, { 1, 2, 9 } },
            { "actions", 184, { 1, 2, 9 } },
            { "actions", 318, { 1, 2, 9 } },
            { "functions", 24, 9 },
            { "actions", 366, { 1, 2 } },
            { "actions", 367, { 1, 2 } },
        },
        [8] = {
            ["title"] = ReadText(1001, 12696),  --"Target Management (Mouse)"
            ["mappable"] = true,
            ["mouseonly"] = true,
            ["filter"] = { [""] = true, ["keyboard"] = true },
            ["compassmenusupport"] = false,
            { "states", 130, 7 },
            { "states", 131, 8 },
        },
        [9] = {
            ["title"] = ReadText(1001, 7282),   --"Target Management"
            ["mappable"] = true,
            { "actions", 167, { 1, 2 } },
            { "actions", 168, { 1, 2 }, ReadText(1026, 2604) }, -- "Target Object" (near crosshair)
            { "functions", 3 },
            { "actions", 289, { 1, 2 } },
            { "actions", 169, { 1, 2 } },
            { "actions", 170, { 1, 2 } },
            { "actions", 213, { 1, 2 } },
            { "actions", 214, { 1, 2 } },
            { "actions", 275, { 1, 2 } },
        },
        [10] = {
            ["title"] = ReadText(1001, 12655),  --"Accessibility"
            ["mappable"] = true,
            { "actions", 374, { 1, 2 }, ReadText(1026, 2675) },
        },
        [11] = {
            ["title"] = ReadText(1001, 2664),   --"Misc"
            ["mappable"] = true,
            { "functions", 10 },
            { "actions", 277, { 1, 2 } },
            { "actions", 178, { 1, 2 }, ReadText(1026, 2609) },
            { "functions", 9 },
            { "functions", 15 },
            { "actions", 117, { 1, 2 } },
            { "actions", 120, { 1, 2 } },
            { "actions", 219, { 1, 2 } },
            { "states", 80, { 1, 2 }, ReadText(1026, 2612) },
            { "actions", 260, { 1, 2 } },
            { "actions", 325, { 1, 2 } },
            { "actions", 328, { 1, 2 } },
            { "actions", 329, { 1, 2 } },
            { "actions", 343, { 1, 2 } },
            { "actions", 344, { 1, 2 } },
            { "actions", 345, { 1, 2 } },
            { "actions", 346, { 1, 2 } },
            { "actions", 347, { 1, 2 } },
            { "actions", 348, { 1, 2 } },
            { "actions", 349, { 1, 2 } },
            { "actions", 350, { 1, 2 } },
            { "actions", 351, { 1, 2 } },
            { "actions", 352, { 1, 2 } },
            { "actions", 377, { 1, 2 }, ReadText(1026, 4809) },
        },
        [12] = {
            ["title"] = ReadText(1001, 4815),   -- "Expert Settings - Use with Caution!"
            ["mappable"] = true,
            { "actions", 310, { 1, 2 } },
            { "states", 96, { 1, 2 } },
            { "actions", 137, { 1, 2 } },
            { "actions", 121, { 1, 2 } },
            { "actions", 166, { 1, 2 } },
            { "actions", 224, { 1, 2 } },
            { "actions", 306, { 1, 2 } },
            { "actions", 223, { 1, 2 }, ReadText(1026, 2611) },
        },
    },
    ["menus"] = {
        [1] = {
            ["title"] = ReadText(1001, 7296),   -- "Menus - Analog"
            ["mappable"] = true,
            { "ranges", 23, { 2, 6 } },
            { "ranges", 24, { 2, 6 } },
            { "ranges", 25, 2 },
            { "ranges", 26, 2 },
            { "ranges", 27, 2 },
            { "ranges", 28, 2 },
        },
        [2] = {
            ["title"] = ReadText(1001, 2665),   -- "Menus - Digital"
            ["mappable"] = false,
            { "actions", 21, 2 },
            { "actions", 20, 2 },
            { "functions", 7 },
            { "functions", 8 },
            { "functions", 4, nil, nil, nil, true },
            { "states", 97, 2 },
            { "actions", 18, 2 },
            { "actions", 17, 2 },
            { "actions", 22, 2 },
            { "actions", 308, 2 },
            { "actions", 309, 2 },
            { "functions", 1, nil, nil, nil, true },
            { "functions", 2, nil, nil, nil, true },
            { "states", 128, 2 },
            { "states", 129, 2 },
            { "states", 92, 6 },
            { "states", 93, 6 },
            { "states", 94, 6 },
            { "states", 99, { 2, 6 } },
            { "states", 100, { 2, 6 } },
            { "states", 101, { 2, 6 } },
            { "states", 102, { 2, 6 } },
            { "states", 103, { 2, 6 } },
            { "states", 104, { 2, 6 } },
            { "states", 105, { 2, 6 } },
            { "states", 106, { 2, 6 } },
            { "states", 39, 6 },
            { "states", 40, 6 },
            { "states", 41, 6 },
            { "states", 42, 6 },
            { "states", 43, 6 },
            { "states", 44, 6 },
            { "states", 45, 6 },
            { "states", 46, 6 },
            { "states", 37, 6 },
            { "states", 38, 6 },
        },
        [3] = {
            ["title"] = ReadText(1001, 2666),
            ["mappable"] = false,
            { "states", 1, 3 },
            { "actions", 294, 3 },
            { "actions", 376, 9, nil, nil, nil, true },
            { "actions", 97, 3 },
            { "actions", 98, 3 },
            { "actions", 99, 3 },
            { "actions", 100, 3 },
            { "actions", 101, 3 },
            { "actions", 102, 3 },
            { "actions", 198, 3 },
            { "actions", 199, 3 },
            { "actions", 200, 3 },
            { "actions", 201, 3 },
            { "actions", 202, 3 },
            { "actions", 203, 3 },
            { "actions", 299, 3 },
            { "actions", 300, 3 },
            { "actions", 301, 3 },
            { "actions", 302, 3 },
            { "ranges", 11, { 3 } },
            { "ranges", 12, { 3 } },
        },
        [4] = {
            ["title"] = ReadText(1001, 3245),   -- "Map"
            ["mappable"] = true,
            { "actions", 216, 2 },  -- "Target Object" (in map)
            { "actions", 264, 2 },
            { "actions", 265, 2 },
            { "actions", 222, 2 },
            { "actions", 263, 2 },
        },
        [5] = {
            ["title"] = ReadText(1001, 12665),
            ["mappable"] = false,
            { "ranges", 36, 5 },
            { "ranges", 37, 5 },
        },
        [6] = {
            ["title"] = ReadText(1001, 2664),
            ["mappable"] = false,
            { "actions", 336, 7 },
            { "actions", 337, 7 },
        },
        [7] = {
            ["title"] = ReadText(1001, 11788),
            ["mappable"] = true,
            { "states", 98, 2 },
            { "states", 121, 2 },
            { "states", 122, 2 },
            { "states", 123, 2 },
        },
    },
    ["firstperson"] = {
        [1] = {
            ["title"] = ReadText(1001, 12689),
            ["mappable"] = true,
            { "ranges", 15 },
            { "ranges", 16 },
            { "ranges", 13 },
            { "ranges", 14 },
        },
        [2] = {
            ["title"] = ReadText(1001, 12690),
            ["mappable"] = true,
            { "states", 26 },
            { "states", 27 },
            { "states", 32 },
            { "states", 33 },
            { "states", 87 },
            { "states", 30 },
            { "states", 31 },
            { "states", 28 },
            { "states", 29 },
            { "states", 34 },
            { "states", 35 },
            { "states", 36 },
            { "actions", 220 },
            { "functions", 3 },
        },
    },
}

config.input.directInputHookDefinitions = {
    {"keyboardInput", 1, 0},
    {"mouseaxesInputPosSgn", 18, 1},
    {"mouseaxesInputNegSgn", 18, -1},
    {"mousebuttonsInput", 19, 0},
    {"oculustouchaxesInputPosSgn", 20, 1},
    {"oculustouchaxesInputNegSgn", 20, -1},
    {"oculusremoteaxesInputPosSgn", 21, 1},
    {"oculusremoteaxesInputNegSgn", 21, -1},
    {"viverightaxesInputPosSgn", 22, 1},
    {"viverightaxesInputNegSgn", 22, -1},
    {"viveleftaxesInputPosSgn", 23, 1},
    {"viveleftaxesInputNegSgn", 23, -1},
    {"oculustouchbuttonsInput", 24, 0},
    {"oculusremotebuttonsInput", 25, 0},
    {"viverightbuttonsInput", 26, 0},
    {"viveleftbuttonsInput", 27, 0},
}
for i = 1, 8 do
    table.insert(config.input.directInputHookDefinitions, {"joyaxesInputPosSgn" .. i, i + 1, 1})
    table.insert(config.input.directInputHookDefinitions, {"joyaxesInputNegSgn" .. i, i + 1, -1})
    table.insert(config.input.directInputHookDefinitions, {"joybuttonsInput" .. i, i + 9, 0})
end

config.input.directInputHooks = {}
for i, entry in ipairs(config.input.directInputHookDefinitions) do
    table.insert(config.input.directInputHooks, function (_, keycode) menu.remapInput(entry[2], keycode, entry[3]) end)
end

config.input.filters = {
    { id = "", sources = {} },
    { id = "keyboard",      sources = { [1] = true, [18] = true, [19] = true } },
    { id = "controller_1",  sources = { [2] = true, [10] = true } },
    { id = "controller_2",  sources = { [3] = true, [11] = true } },
    { id = "controller_3",  sources = { [4] = true, [12] = true } },
    { id = "controller_4",  sources = { [5] = true, [13] = true } },
    { id = "controller_5",  sources = { [6] = true, [14] = true } },
    { id = "controller_6",  sources = { [7] = true, [15] = true } },
    { id = "controller_7",  sources = { [8] = true, [16] = true } },
    { id = "controller_8",  sources = { [9] = true, [17] = true } },
}

config.ventureDLCStates = {
    [0] = "valid",
    [1] = "userdisabled",
    [2] = "userskipped",
    [3] = "notpossible",
    [4] = "updatedisabled",
    [5] = "updateskipped",
    [6] = "updatenotpossible",
    [7] = "usercanceled",
    [8] = "unknownerror",
}

config.inputfeedback = {
    options = {
        { id = "off",               text = ReadText(1001, 12641),   icon = "", displayremoveoption = false },
        { id = "text",              text = ReadText(1001, 12633),   icon = "", displayremoveoption = false },
        { id = "voice",             text = ReadText(1001, 12634),   icon = "", displayremoveoption = false },
        { id = "textandvoice",      text = ReadText(1001, 12635),   icon = "", displayremoveoption = false },
    },
    textoptions = {
        { id = "off",               text = ReadText(1001, 12641),   icon = "", displayremoveoption = false },
        { id = "ticker",            text = ReadText(1001, 12629),   icon = "", displayremoveoption = false },
        { id = "controlmessage",    text = ReadText(1001, 12630),   icon = "", displayremoveoption = false },
    },
    voiceoptions = {
        { id = "off",               text = ReadText(1001, 12641),   icon = "", displayremoveoption = false },
        { id = "on",                text = ReadText(1001, 12642),   icon = "", displayremoveoption = false },
    },
}

config.optionDefinitions = {
    ["main"] = {
        name = function () return menu.isStartmenu and ReadText(1001, 2681) or ReadText(1001, 2600) end,
        info = function () return ReadText(1001, 2655) .. ReadText(1001, 120) .. " " .. GetVersionString() .. "\n" .. ffi.string(C.GetBuildVersionSuffix()) .. (C.IsGameModified() and (ColorText["text_warning"] .. "(" .. ReadText(1001, 8901) .. ")") or "") end,
        [1] = {
            id = "onlineseason",
            name = function () return menu.nameOnlineSeason() end,
            callback = function () return menu.callbackOnlineSeason() end,
            selectable = function () return menu.selectableOnlineSeason() end,
            wordwrap = true,
            display = function () return C.IsVentureSeasonSupported() and (not C.IsTimelinesScenario()) and (ffi.string(C.GetGameStartName()) ~= "x4ep1_gamestart_hub") end,
        },
        [2] = {
            id = "continue",
            name = function () return menu.nameContinue() end,
            mouseOverText = function () return menu.isStartmenu and ReadText(1026, 4803) or "" end,
            callback = function () return menu.callbackContinue() end,
            selectable = function () return menu.selectableContinue() end,
            wordwrap = true,
        },
        [3] = {
            id = "load",
            name = function () return (menu.autoReloadSave or C.IsSaveListLoadingComplete()) and ReadText(1001, 2604) or ReadText(1001, 7203) end,
            mouseOverText = ReadText(1026, 4804),
            submenu = "load",
            selectable = function () return C.IsSaveListLoadingComplete() and C.HasSavegame() end,
        },
        [4] = {
            id = "save",
            name = ReadText(1001, 2605),
            submenu = "save",
            selectable = IsSavingPossible,
            display = function () return not menu.isStartmenu end,
            mouseOverText = function () return menu.saveMouseOverText() end,
        },
        [5] = {
            id = "line",
            linecolor = Color["row_background"],
        },
        [6] = {
            id = "tutorials",
            name = ReadText(1001, 12660),
            prefixicon = function () return menu.prefixIconTopLevel("tutorials") end,
            mouseOverText = ReadText(1026, 4805),
            submenu = "tutorials",
        },
        [7] = {
            id = "timelines",
            name = ReadText(1001, 12661),
            prefixicon = function () return menu.prefixIconTopLevel("timelines") end,
            mouseOverText = ReadText(1026, 2696) .. "\n\n" .. ReadText(1026, 2681),
            submenu = "timelines",
            selectable = function () return ffi.string(C.GetGameStartName()) ~= "x4ep1_gamestart_hub" end,
        },
        [8] = {
            id = "new",
            name = ReadText(1001, 12662),
            prefixicon = function () return menu.prefixIconTopLevel("new") end,
            submenu = "new",
            mouseOverText = ReadText(1026, 4801) .. "\n\n" .. ReadText(1026, 4802),
        },
        [9] = {
            id = "multiplayer",
            name = ReadText(1001,7283),
            submenu = "multiplayer",
            display = C.IsNetworkEngineEnabled,
        },
        [10] = {
            id = "line",
            linecolor = Color["row_background"],
        },
        [11] = {
            id = "settings",
            name = function () return menu.nameSettings() end,
            submenu = "settings",
        },
        [12] = {
            id = "credits",
            name = ReadText(1001, 4811),
            submenu = "credits",
            display = function () return menu.isStartmenu end,
        },
        [13] = {
            id = "returntohub",
            name = function () return menu.nameReturnToHub() end,
            prefixicon = function () return "menu_recommended", Color["gamestart_recommended"] end,
            callback = function () return menu.callbackReturnToHub() end,
            display = function () return (not menu.isStartmenu) and C.IsTimelinesScenario() end,
        },
        [14] = {
            id = "exit",
            name = ReadText(1001, 11791),
            submenu = "exit",
            display = function () return not menu.isStartmenu end,
        },
        [15] = {
            id = "quit",
            name = ReadText(1001, 4876),
            submenu = "quit",
        },
    },
    ["timelines"] = {
        name = ReadText(1021, 67),
        [1] = {
            id = "timelines_start",
            name = function () return (ffi.string(C.GetUserData("timelines_scenarios_finished")) ~= "") and ReadText(1001, 12620) or ReadText(1001, 12619) end,
            callback = function () return menu.callbackTimelines() end,
            selectable = function () return (not C.HasExtension("ego_dlc_timelines", false)) or C.IsExtensionEnabled("ego_dlc_timelines", false) end,
            mouseOverText = function () return (ffi.string(C.GetUserData("timelines_scenarios_finished")) ~= "") and ReadText(1026, 2698) or ReadText(1026, 2697) end,
        },
        [2] = {
            id = "timelines_reset",
            name = ReadText(1001, 12621),
            submenu = "timelines_reset",
            selectable = function () return C.IsExtensionEnabled("ego_dlc_timelines", false) and (ffi.string(C.GetUserData("timelines_scenarios_finished")) ~= "") end,
            mouseOverText = ReadText(1026, 2699)
        },
    },
    ["load"] = {
        name = ReadText(1001, 2604)
    },
    ["save"] = {
        name = ReadText(1001, 2605)
    },
    ["saveoffline"] = {
        name = ReadText(1001, 11712)
    },
    ["multiplayer"] = {
        name = ReadText(1001,7283),
        [1] = {
            id = "multiplayer_server",
            name = ReadText(1001,7284),
            submenu = "multiplayer_server",
        },
        [2] = {
            id = "lobby",
            name = ReadText(1001,7285),
            submenu = "lobby",
        },
    },
    ["online"] = {
        [1] = {
            id = "language",
            name = ReadText(1001, 11765),
            info = ReadText(1001, 11766),
            valuetype = "dropdown",
            value = function () return menu.valueOnlinePreferredLanguage() end,
            callback = function (id, option) return menu.callbackOnlinePreferredLanguage(id, option) end,
        },
        [2] = {
            id = "visitornames",
            name = ReadText(1001, 7298),
            info = ReadText(1001, 7297),
            valuetype = "button",
            value = function () return C.GetVisitorNamesShownOption() and ReadText(1001, 2617) or ReadText(1001, 2618) end,
            callback = function () return menu.callbackOnlineVisitorNames() end,
            display = function () return C.AreVenturesEnabled() end,
        },
        [3] = {
            id = "acceptinvitations",
            name = ReadText(1001, 11763),
            info = ReadText(1001, 11764),
            valuetype = "button",
            value = function () return menu.valueOnlineAllowInvites() end,
            callback = function () return menu.callbackOnlineAllowInvites() end,
            display = function () return C.IsVentureSeasonSupported() and OnlineHasSession() end,
        },
        [4] = {
            id = "acceptprivatemessages",
            name = ReadText(1001, 11772),
            info = ReadText(1001, 11773),
            valuetype = "button",
            value = function () return menu.valueOnlineAllowPrivateMessages() end,
            callback = function () return menu.callbackOnlineAllowPrivateMessages() end,
            display = function () return C.IsVentureSeasonSupported() and OnlineHasSession() end,
        },
        [5] = {
            id = "seasonupdates",
            name = ReadText(1001, 11309),
            valuetype = "dropdown",
            value = function () return menu.valueOnlineSeasonUpdates() end,
            callback = function (id, option) return menu.callbackOnlineSeasonUpdates(id, option) end,
            display = function () return false end,
        },
        [6] = {
            id = "operationupdates",
            name = ReadText(1001, 11310),
            valuetype = "dropdown",
            value = function () return menu.valueOnlineOperationUpdates() end,
            callback = function (id, option) return menu.callbackOnlineOperationUpdates(id, option) end,
            display = function () return false end,
        },
        [7] = {
            id = "promotion",
            name = ReadText(1001, 11311),
            valuetype = "dropdown",
            value = function () return menu.valueOnlinePromotion() end,
            callback = function (id, option) return menu.callbackOnlinePromotion(id, option) end,
            display = function () return false end,
        },
        [8] = {
            id = "seasonsummary",
            name = ReadText(1001, 11312),
            valuetype = "dropdown",
            value = function () return menu.valueOnlineSeasonSummary() end,
            callback = function (id, option) return menu.callbackOnlineSeasonSummary(id, option) end,
            display = function () return false end,
        },
    },
    ["extensionsettings"] = {
        name = function () return menu.nameExtensionSettings() end,
        warning = function () return menu.warningExtensionSettings() end,
        [1] = {
            id = "enable",
            name = function () return menu.nameExtensionSettingEnabled() end,
            value = function () return menu.valueExtensionSettingEnabled() end,
            callback = function () return menu.callbackExtensionSettingEnabled() end,
        },
        [2] = {
            id = "sync",
            name = ReadText(1001, 4824),
            value = function () return menu.valueExtensionSettingSync() end,
            callback = function () return menu.callbackExtensionSettingSync() end,
            display = function () return menu.selectedExtension.isworkshop end,
        },
        [3] = {
            id = "workshop",
            name = ReadText(1001, 4828),
            callback = function () return menu.callbackExtensionSettingWorkshop() end,
            display = function () return menu.selectedExtension.isworkshop end,
        },
    },
    ["settings"] = {
        name = ReadText(1001, 2679),
        warning = function () return menu.warningSettings() end,
        [1] = {
            id = "online",
            name = function () return menu.nameOnline() end,
            submenu = "online",

            -- kuertee start:
            -- selectable = C.IsOnlineEnabled,
            selectable = function () return false end,
            -- kuertee end

            mouseOverText = function () return C.IsOnlineEnabled() and (ReadText(1026, 4806) .. "\n\n" .. ReadText(1026, 4807)) or ReadText(1001, 11592) end,
        },
        [2] = {
            id = "extensions",
            name = function () return menu.nameExtension() end,
            mouseOverText = ReadText(1026, 4808),
            submenu = "extensions",
            display = function () return not C.IsDemoVersion() end,
        },
        [3] = {
            id = "bonus",
            name = ReadText(1001, 4800),
            submenu = "bonus",
            display = function () return false end, -- hidden, not needed in X4
        },
        [4] = {
            id = "line",
        },
        [5] = {
            id = "display",
            name = function () return menu.nameDisplay() end,
            submenu = "display",
        },
        [6] = {
            id = "gfx",
            name = function () return menu.nameGfx() end,
            submenu = "gfx",
        },
        [7] = {
            id = "sfx",
            name = ReadText(1001, 2611),
            submenu = "sfx",
        },
        [8] = {
            id = "game",
            name = ReadText(1001, 2613),
            submenu = "game",
        },
        [9] = {
            id = "accessibility",
            name = function () return menu.nameAccessibility() end,
            submenu = "accessibility",
        },
        [10] = {
            id = "input",
            name = function () return menu.nameInput() end,
            submenu = "input",
        },
        [11] = {
            id = "privacy",
            name = ReadText(1001, 4870),
            submenu = "privacy",
        },
        [12] = {
            id = "language",
            name = function () return menu.nameLanguage() end,
            submenu = "language",
            display = function () return menu.isStartmenu and C.IsLanguageSettingEnabled() end
        },
        [13] = {
            id = "line",
        },
        [14] = {
            id = "defaults",
            name = ReadText(1001, 8981),
            submenu = "defaults",
        },
    },
    ["display"] = {
        name = ReadText(1001, 12771),
        warning = function () return menu.warningDisplay() end,
        [1] = {
            id = "fullscreen",
            name = function () return C.IsVRVersion() and ReadText(1001, 7213) or ReadText(1001, 4817) end,
            mouseOverText = ReadText(1026, 4826),
            valuetype = "dropdown",
            value = function () return menu.valueGfxFullscreen() end,
            callback = function (id, option) return menu.callbackGfxFullscreen(id, option) end,
            selectable = function () return menu.selectableGfxFullscreen() end,
        },
        [2] = {
            id = "hmd_resolution",
            name = ReadText(1001, 2619),
            value = function () return menu.valueGfxHMDResolution() end,
            display = C.IsVRVersion,
        },
        [3] = {
            -- non-VR case
            id = "resolution",
            name = ReadText(1001, 2619),
            mouseOverText = ReadText(1026, 4821),
            valuetype = "dropdown",
            value = function () return menu.valueGfxResolution() end,
            callback = function (id, option) return menu.callbackGfxResolution(id, option) end,
            display = function () return not C.IsVRVersion() end,
            selectable = function () return menu.selectableGfxResolution() end,
        },
        [4] = {
            id = "antialias",
            name = ReadText(1001, 2620),
            mouseOverText = function () return (not C.GetDLSSOption(false)) and ReadText(1026, 4822) or (ColorText["text_error"] ..  ReadText(1026, 4813)) end,
            valuetype = "dropdown",
            value = function () return menu.valueGfxAA() end,
            callback = function (id, option) return menu.callbackGfxAA(id, option) end,
            selectable = function () return not C.GetDLSSOption(false) end,
        },
        [5] = {
            id = "fsr1",
            name = ReadText(1001, 11726),
            mouseOverText = function () return menu.mouseOverTextGfxUpscaling() end,
            valuetype = "dropdown",
            value = function () return menu.valueGfxFSR1() end,
            callback = function (id, option) return menu.callbackGfxFSR1(id, option) end,
            selectable = function () return menu.selectableGfxUpscaling() == 0 end,
        },
        [6] = {
            id = "dlss",
            name = ReadText(1001, 12735),
            mouseOverText = ReadText(1026, 4824),
            valuetype = "dropdown",
            value = function () return menu.valueGfxDLSS() end,
            callback = function (id, option) return menu.callbackGfxDLSS(id, option) end,
            display = C.IsDLSSSupported,
        },
        [7] = {
            id = "dlssmode",
            name = "    " .. ReadText(1001, 12736),
            mouseOverText = ReadText(1026, 4825),
            valuetype = "dropdown",
            value = function () return menu.valueGfxDLSSMode() end,
            callback = function (id, option) return menu.callbackGfxDLSSMode(id, option) end,
            selectable = function () return C.GetDLSSOption(false) end,
            display = C.IsDLSSSupported,
        },
        [8] = {
            id = "adaptivesampling",
            name = ReadText(1001, 7221),
            valuetype = "dropdown",
            value = function () return menu.valueGfxAdaptiveSampling() end,
            callback = function (id, option) return menu.callbackGfxAdaptiveSampling(id, option) end,
            display = C.IsVRVersion,
        },
        [9] = {
            id = "hmd_fullscreen",
            name = ReadText(1001, 4817),
            value = function () return ReadText(1001, 2622), Color["text_normal"] end,
            display = C.IsVRVersion,
        },
        [10] = {
            id = "hmd_sdk",
            name = ReadText(1001, 7214),
            value = function () return ffi.string(C.GetTrackerSDKOption()), Color["text_normal"] end,
            display = C.IsVRVersion,
        },
        [11] = {
            id = "line",
            display = C.IsVRVersion,
        },
        [12] = {
            id = "hmd_adapter",
            name = ReadText(1001, 2623),
            value = function () return ffi.string(C.GetTrackerNameOption()), Color["text_normal"] end,
            display = C.IsVRVersion,
        },
        [13] = {
            id = "screendisplay",
            name = ReadText(1001, 7210),
            valuetype = "button",
            value = function () return C.GetScreenDisplayOption() and ReadText(1001, 12641) or ReadText(1001, 12642) end,
            callback = function () return menu.callbackGfxScreenDisplay() end,
            display = C.IsVRVersion,
        },
        [14] = {
            -- VR case
            id = "resolution",
            name = ReadText(1001, 7211),
            valuetype = "dropdown",
            value = function () return menu.valueGfxResolution() end,
            callback = function (id, option) return menu.callbackGfxResolution(id, option) end,
            display = C.IsVRVersion,
            selectable = function () return menu.selectableGfxResolution() end,
        },
        [15] = {
            id = "autogpu",
            name = ReadText(1001, 11709),
            mouseOverText = ReadText(1026, 4827),
            valuetype = "button",
            value = function () return C.IsGPUAutomaticallySelected() and ReadText(1001, 12642) or ReadText(1001, 12641) end,
            callback = function () return menu.callbackGfxAutoGPU() end,
        },
        [16] = {
            id = "gpu",
            name = ReadText(1001, 8920),
            mouseOverText = ReadText(1026, 4828),
            valuetype = "dropdown",
            value = function () return menu.valueGfxGPU() end,
            callback = function (id, option) return menu.callbackGfxGPU(id, option) end,
            selectable = function () return menu.selectableGfxGPU() end,
        },
        [17] = {
            id = "adapter",
            name = ReadText(1001, 8921),
            mouseOverText = ReadText(1026, 4829),
            valuetype = "dropdown",
            value = function () return menu.valueGfxAdapter() end,
            callback = function (id, option) return menu.callbackGfxAdapter(id, option) end,
            selectable = function () return menu.selectableGfxAdapter() end,
        },
        [18] = {
            id = "presentmode",
            name = ReadText(1001, 7268),
            mouseOverText = ReadText(1026, 4830),
            valuetype = "dropdown",
            value = function () return menu.valueGfxPresentMode() end,
            callback = function (id, option) return menu.callbackGfxPresentMode(id, option) end,
        },
        [19] = {
            id = "lut",
            name = ReadText(1001, 7238),
            mouseOverText = ReadText(1026, 4831),
            valuetype = "dropdown",
            value = function () return menu.valueGfxLUT(false) end,
            callback = function (id, option) return menu.callbackGfxLUT(id, option) end,
        },
        [20] = {
            id = "gamma",
            name = ReadText(1001, 2629),
            mouseOverText = ReadText(1026, 4832),
            valuetype = "slidercell",
            value = function () return menu.valueGfxGamma() end,
            callback = function (value) return menu.callbackGfxGamma(value) end,
        },
        [21] = {
            id = "fov",
            name = ReadText(1001, 4814),
            mouseOverText = ReadText(1026, 4833),
            valuetype = "slidercell",
            value = function () return menu.valueGfxFOV() end,
            callback = function (value) return menu.callbackGfxFOV(value) end,
        },
        [22] = {
            id = "line",
        },
        [23] = {
            id = "display_defaults",
            name = ReadText(1001, 12772),
            submenu = "display_defaults",
        },
    },
    ["gfx"] = {
        name = ReadText(1001, 2606),
        warning = function () return menu.warningGfx() end,
        [1] = {
            id = "gfx_preset",
            name = ReadText(1001, 4840),
            mouseOverText = ReadText(1026, 4834),
            valuetype = "dropdown",
            value = function () return menu.valueGfxPreset() end,
            callback = function (id, option) return menu.callbackGfxPreset(id, option) end,
        },
        [2] = {
            id = "texturequality",
            name = ReadText(1001, 8900),
            mouseOverText = ReadText(1026, 4835),
            valuetype = "dropdown",
            value = function () return menu.valueGfxTexture() end,
            callback = function (id, option) return menu.callbackGfxTexture(id, option) end,
        },
        [3] = {
            id = "shadows",
            name = ReadText(1001, 2625),
            mouseOverText = ReadText(1026, 4836),
            valuetype = "dropdown",
            value = function () return menu.valueGfxShadows() end,
            callback = function (id, option) return menu.callbackGfxShadows(id, option) end,
        },
        [4] = {
            id = "softshadows",
            name = ReadText(1001, 4841),
            mouseOverText = ReadText(1026, 4837),
            valuetype = "button",
            value = function () return GetSoftShadowsOption() and ReadText(1001, 12642) or ReadText(1001, 12641) end,
            callback = function () return menu.callbackGfxSoftShadows() end,
        },
        [5] = {
            id = "ssao",
            name = ReadText(1001, 2626),
            mouseOverText = ReadText(1026, 4838),
            valuetype = "dropdown",
            value = function () return menu.valueGfxSSAO() end,
            callback = function (id, option) return menu.callbackGfxSSAO(id, option) end,
        },
        [6] = {
            id = "glow",
            name = ReadText(1001, 11752),
            mouseOverText = ReadText(1026, 4839),
            valuetype = "dropdown",
            value = function () return menu.valueGfxGlow() end,
            callback = function (id, option) return menu.callbackGfxGlow(id, option) end,
        },
        [7] = {
            id = "uiglow",
            name = ReadText(1001, 11779),
            mouseOverText = ReadText(1026, 4840),
            valuetype = "dropdown",
            value = function () return menu.valueGfxUIGlow() end,
            callback = function (id, option) return menu.callbackGfxUIGlow(id, option) end,
        },
        [8] = {
            id = "uiglowintensity",
            name = ReadText(1001, 12701),
            mouseOverText = ReadText(1026, 4841),
            valuetype = "slidercell",
            value = function () return menu.valueGfxUIGlowIntensity() end,
            callback = function (value) return menu.callbackGfxUIGlowIntensity(value) end,
        },
        [9] = {
            id = "chromaticaberration",
            name = ReadText(1001, 8987),
            mouseOverText = ReadText(1026, 4842),
            valuetype = "button",
            value = function () return C.GetChromaticAberrationOption() and ReadText(1001, 12642) or ReadText(1001, 12641) end,
            callback = function () return menu.callbackGfxChromaticAberration() end,
        },
        [10] = {
            id = "distortion",
            name = ReadText(1001, 4822),
            mouseOverText = ReadText(1026, 4843),
            valuetype = "button",
            value = function () return GetDistortionOption() and ReadText(1001, 12642) or ReadText(1001, 12641) end,
            callback = function () return menu.callbackGfxDistortion() end,
        },
        [11] = {
            id = "pom",
            name = ReadText(1001, 11731),
            mouseOverText = ReadText(1026, 4844),
            valuetype = "dropdown",
            value = function () return menu.valueGfxPOM() end,
            callback = function (id, option) return menu.callbackGfxPOM(id, option) end,
        },
        [12] = {
            id = "lod",
            name = ReadText(1001, 2628),
            mouseOverText = ReadText(1026, 4845),
            valuetype = "slidercell",
            value = function () return menu.valueGfxLOD() end,
            callback = function (value) return menu.callbackGfxLOD(value) end,
        },
        [13] = {
            id = "effectdist",
            name = ReadText(1001, 2699),
            mouseOverText = ReadText(1026, 4846),
            valuetype = "slidercell",
            value = function () return menu.valueGfxEffectDistance() end,
            callback = function (value) return menu.callbackGfxEffectDistance(value) end,
        },
        [14] = {
            id = "shaderquality",
            name = ReadText(1001, 2680),
            valuetype = "dropdown",
            value = function () return menu.valueGfxShaderQuality() end,
            callback = function (id, option) return menu.callbackGfxShaderQuality(id, option) end,
            display = function () return false end, -- TEMP hidden until we get shaders with different quality
        },
        [15] = {
            id = "radar",
            name = ReadText(1001, 1706),
            mouseOverText = ReadText(1026, 4847),
            valuetype = "dropdown",
            value = function () return menu.valueGfxRadar() end,
            callback = function (id, option) return menu.callbackGfxRadar(id, option) end,
        },
        [16] = {
            id = "ssr",
            name = ReadText(1001, 7288),
            mouseOverText = ReadText(1026, 4848),
            valuetype = "dropdown",
            value = function () return menu.valueGfxSSR() end,
            callback = function (id, option) return menu.callbackGfxSSR(id, option) end,
        },
        [17] = {
            id = "envmapprobes",
            name = ReadText(1001, 11733),
            mouseOverText = ReadText(1026, 4849),
            valuetype = "dropdown",
            value = function () return menu.valueGfxEnvMapProbes() end,
            callback = function (id, option) return menu.callbackGfxEnvMapProbes(id, option) end,
        },
        [18] = {
            id = "volumetric",
            name = ReadText(1001, 8990),
            mouseOverText = ReadText(1026, 4850),
            valuetype = "dropdown",
            value = function () return menu.valueGfxVolumetric() end,
            callback = function (id, option) return menu.callbackGfxVolumetric(id, option) end,
        },
        [19] = {
            id = "line",
        },
        [20] = {
            id = "envmapprobesinsideglassfade",
            name = ReadText(1001, 11754),
            mouseOverText = ReadText(1026, 4851),
            valuetype = "slidercell",
            value = function () return menu.valueGfxEnvMapProbesInsideGlassFade() end,
            callback = function (value) return menu.callbackGfxEnvMapProbesInsideGlassFade(value) end,
        },
        [21] = {
            id = "capturehq",
            name = ReadText(1001, 4816),
            mouseOverText = ReadText(1026, 4852),
            valuetype = "button",
            value = function () return GetCaptureHQOption() and ReadText(1001, 12642) or ReadText(1001, 12641) end,
            callback = function () return menu.callbackGfxCaptureHQ() end,
        },
        [22] = {
            id = "line",
        },
        [23] = {
            id = "gfx_defaults",
            name = ReadText(1001, 8982),
            submenu = "gfx_defaults",
        },
    },
    ["sfx"] = {
        name = ReadText(1001, 2611),
        [1] = {
            id = "sounddevice",
            name = ReadText(1001, 8960),
            valuetype = "dropdown",
            value = function () return menu.valueSfxDevice() end,
            callback = function (id, option) return menu.callbackSfxDevice(id, option) end,
        },
        [2] = {
            id = "sound",
            name = ReadText(1001, 2630),
            valuetype = "button",
            value = function () return GetSoundOption() and ReadText(1001, 12642) or ReadText(1001, 12641) end,
            callback = function () return menu.callbackSfxSound() end,
        },
        [3] = {
            id = "master",
            name = ReadText(1001, 2631),
            valuetype = "slidercell",
            value = function () return menu.valueSfxSetting("master") end,
            callback = function (value) return menu.callbackSfxSetting("master", value) end,
        },
        [4] = {
            id = "music",
            name = ReadText(1001, 2632),
            valuetype = "slidercell",
            value = function () return menu.valueSfxSetting("music") end,
            callback = function (value) return menu.callbackSfxSetting("music", value) end,
        },
        [5] = {
            id = "voice",
            name = ReadText(1001, 2633),
            valuetype = "slidercell",
            value = function () return menu.valueSfxSetting("voice") end,
            callback = function (value) return menu.callbackSfxSetting("voice", value) end,
        },
        [6] = {
            id = "ambient",
            name = ReadText(1001, 2634),
            valuetype = "slidercell",
            value = function () return menu.valueSfxSetting("ambient") end,
            callback = function (value) return menu.callbackSfxSetting("ambient", value) end,
        },
        [7] = {
            id = "ui",
            name = ReadText(1001, 2635),
            valuetype = "slidercell",
            value = function () return menu.valueSfxSetting("ui") end,
            callback = function (value) return menu.callbackSfxSetting("ui", value) end,
        },
        [8] = {
            id = "effect",
            name = ReadText(1001, 2636),
            valuetype = "slidercell",
            value = function () return menu.valueSfxSetting("effect") end,
            callback = function (value) return menu.callbackSfxSetting("effect", value) end,
        },
        [9] = {
            id = "line",
        },
        [10] = {
            id = "sfx_defaults",
            name = ReadText(1001, 8983),
            submenu = "sfx_defaults",
        },
    },
    ["game"] = {
        name = ReadText(1001, 2613),
        [1] = {
            id = "header",
            name = ReadText(1001, 8974),
        },
        [2] = {
            id = "autosave",
            name = ReadText(1001, 407),
            valuetype = "button",
            value = function () return GetAutosaveOption() and ReadText(1001, 12642) or ReadText(1001, 12641) end,
            callback = function () return menu.callbackGameAutosave() end,
        },
        [3] = {
            id = "autosaveinterval",
            name = ReadText(1001, 8930),
            mouseOverText = ReadText(1026, 2641),
            valuetype = "dropdown",
            value = function () return menu.valueGameAutosaveInterval() end,
            callback = function (id, option) return menu.callbackGameAutosaveInterval(id, option) end,
            selectable = GetAutosaveOption,
        },
        [4] = {
            id = "header",
            name = ReadText(1001, 11706),
        },
        [5] = {
            id = "emergencyeject",
            name = ReadText(1001, 11705),
            mouseOverText = ReadText(1026, 3267),
            valuetype = "button",
            value = function () return C.GetEmergencyEjectOption() and ReadText(1001, 12642) or ReadText(1001, 12641) end,
            callback = function () return menu.callbackGameEmergencyEject() end,
        },
        [6] = {
            id = "header",
            name = ReadText(1001, 8973),
        },
        [7] = {
            id = "autoroll",
            name = ReadText(1001, 2644),
            valuetype = "button",
            value = function () return GetAutorollOption() and ReadText(1001, 12642) or ReadText(1001, 12641) end,
            callback = function () return menu.callbackGameAutoroll() end,
        },
        [8] = {
            id = "collision",
            name = ReadText(1001, 2698),
            valuetype = "button",
            value = function () return GetCollisionAvoidanceAssistOption() and ReadText(1001, 12642) or ReadText(1001, 12641) end,
            callback = function () return menu.callbackGameCollision() end,
        },
        [9] = {
            id = "boost",
            name = ReadText(1001, 2646),
            valuetype = "button",
            value = function () return GetBoostToggleOption() and ReadText(1001, 12642) or ReadText(1001, 12641) end,
            callback = function () return menu.callbackGameBoost() end,
        },
        [10] = {
            id = "aimassist",
            name = ReadText(1001, 2696),
            valuetype = "dropdown",
            value = function () return menu.valueGameAimAssist() end,
            callback = function (id, option) return menu.callbackGameAimAssist(id, option) end,
        },
        [11] = {
            id = "stopshipinmenu",
            name = ReadText(1001, 4884),
            valuetype = "button",
            value = function () return GetStopShipInMenuOption() and ReadText(1001, 12641) or ReadText(1001, 12642) end,
            callback = function () return menu.callbackGameStopInMenu() end,
        },
        [12] = {
            id = "header",
            name = ReadText(1001, 8972),
        },
        [13] = {
            id = "subtitles",
            name = ReadText(1001, 2643),
            valuetype = "dropdown",
            value = function () return menu.valueGameSubtitles() end,
            callback = function (id, option) return menu.callbackGameSubtitles(id, option) end,
        },
        [14] = {
            id = "speaktargetname",
            name = ReadText(1001, 8924),
            valuetype = "button",
            value = function () return C.GetSpeakTargetNameOption() and ReadText(1001, 12642) or ReadText(1001, 12641) end,
            callback = function () return menu.callbackGameSpeakTargetName() end,
        },
        [15] = {
            id = "inputfeedback",
            name = ReadText(1001, 12632),
            valuetype = "dropdown",
            value = function () return menu.valueGameInputFeedback() end,
            callback = function (id, option) return menu.callbackGameInputFeedback(id, option) end,
        },
        [16] = {
            id = "mouselook",
            name = ReadText(1001, 4895),
            valuetype = "button",
            value = function () return GetMouseLookToggleOption() and ReadText(1001, 12642) or ReadText(1001, 12641) end,
            callback = function () return menu.callbackGameMouselook() end,
        },
        [17] = {
            id = "rumble",
            name = ReadText(1001, 2678),
            valuetype = "slidercell",
            value = function () return menu.valueGameRumble() end,
            callback = function (value) return menu.callbackGameRumble(value) end,
        },
        [18] = {
            id = "forceshoottocursor",
            name = ReadText(1001, 7218),
            valuetype = "button",
            value = function () return C.GetForceShootingAtCursorOption() and ReadText(1001, 12642) or ReadText(1001, 12641) end,
            callback = function () return menu.callbackGameShootAtCursor() end,
            display = C.IsVRVersion,
        },
        [19] = {
            id = "mouseover",
            name = ReadText(1001, 4882),
            valuetype = "button",
            value = function () return C.GetMouseOverTextOption() and ReadText(1001, 12642) or ReadText(1001, 12641) end,
            callback = function () return menu.callbackGameMouseOver() end,
        },
        [20] = {
            id = "radardisplay",
            name = ReadText(1001, 7258),
            valuetype = "dropdown",
            value = function () return menu.valueGameRadar() end,
            callback = function (id, option) return menu.callbackGameRadar(id, option) end,
        },
        [21] = {
            id = "line",
            linecolor = Color["row_background"],
            lineheight = 4,
        },
        [22] = {
            id = "uiscale",
            name = ReadText(1001, 7209),
            mouseOverText = ReadText(1026, 2626),
            valuetype = "slidercell",
            value = function () return menu.valueGameUIScale() end,
            callback = function (value) return menu.callbackGameUIScale(value) end,
            confirmline = {
                positive = function () return menu.callbackGameUIScaleConfirm() end,
                pos_name = ReadText(1001, 2821),
                pos_selectable = function () return menu.selectableGameUIScaleConfirm() end,
                negative = function () return menu.callbackGameUIScaleReset() end,
                neg_name = ReadText(1001, 3318),
                neg_selectable = function () return menu.selectableGameUIScaleConfirm() end,
            },
        },
        [23] = {
            id = "hudscale",
            name = ReadText(1001, 12624),
            mouseOverText = ReadText(1026, 2671),
            valuetype = "dropdown",
            value = function () return menu.valueGameHUDScale() end,
            callback = function (id, option) return menu.callbackGameHUDScale(id, option) end,
        },
        [24] = {
            id = "line",
            linecolor = Color["row_background"],
            lineheight = 4,
        },
        [25] = {
            id = "menuwidthscale",
            name = ReadText(1001, 11792),
            mouseOverText = ReadText(1026, 2669),
            valuetype = "slidercell",
            value = function () return menu.valueGameMenuWidthScale() end,
            callback = function (value) return menu.callbackGameMenuWidthScale(value) end,
            confirmline = {
                positive = function () return menu.callbackGameMenuWidthScaleConfirm() end,
                pos_name = ReadText(1001, 2821),
                pos_selectable = function () return menu.selectableGameMenuWidthScaleConfirm() end,
                negative = function () return menu.callbackGameMenuWidthScaleReset() end,
                neg_name = ReadText(1001, 3318),
                neg_selectable = function () return menu.selectableGameMenuWidthScaleConfirm() end,
            },
        },
        [26] = {
            id = "line",
            linecolor = Color["row_background"],
            lineheight = 4,
        },
        [27] = {
            id = "controlmodemessages",
            name = ReadText(1001, 4861),
            valuetype = "button",
            value = function () return GetSteeringNoteOption() and ReadText(1001, 12642) or ReadText(1001, 12641) end,
            callback = function () return menu.callbackGameControlModeMessages() end,
        },
        [28] = {
            id = "resetuserquestions",
            name = ReadText(1001, 8985),
            mouseOverText = ReadText(1026, 2652),
            valuetype = "confirmation",
            value = ReadText(1001, 8986),
            callback = function () return menu.callbackGameResetUserQuestions() end,
            selectable = function () return menu.selectableGameResetUserQuestions() end,
            inactive_text = ReadText(1026, 2653),
        },
        [29] = {
            id = "enemywarning_nearby",
            name = ReadText(1001, 11729),
            valuetype = "sounddropdown",
            value = function () return menu.valueGameEnemyNearby() end,
            callback = function (id, option) return menu.callbackGameEnemyNearby(id, option) end,
        },
        [30] = {
            id = "enemywarning_attack",
            name = ReadText(1001, 11730),
            valuetype = "sounddropdown",
            value = function () return menu.valueGameEnemyAttack() end,
            callback = function (id, option) return menu.callbackGameEnemyAttack(id, option) end,
        },
        [31] = {
            id = "startmenu_background",
            name = ReadText(1001, 11761),
            valuetype = "dropdown",
            value = function () return menu.valueGameStartmenuBackground() end,
            callback = function (id, option) return menu.callbackGameStartmenuBackground(id, option) end,
            display = function () return menu.isStartmenu end,
        },
        [32] = {
            id = "velocityindicator",
            name = ReadText(1001, 12773),
            valuetype = "button",
            value = function () return C.GetVelocityIndicatorOption() and ReadText(1001, 12642) or ReadText(1001, 12641) end,
            callback = function () return menu.callbackGameVelocityIndicator() end,
        },
        [33] = {
            id = "header",
            name = ReadText(1001, 4860),
        },
        [34] = {
            id = "thirdpersonflight",
            name = ReadText(1001, 11785),
            valuetype = "dropdown",
            value = function () return menu.valueGameThirdPersonFlight() end,
            callback = function (id, option) return menu.callbackThirdPersonFlight(id, option) end,
            display = function () return false end, -- hidden due to not being used for the moment
        },
        [35] = {
            id = "cockpitcamera",
            name = ReadText(1001, 7289),
            valuetype = "slidercell",
            value = function () return menu.valueGameCockpitCamera() end,
            callback = function (value) return menu.callbackGameCockpitCamera(value) end,
        },
        [36] = {
            id = "autozoomreset",
            name = ReadText(1001, 12702),
            valuetype = "button",
            value = function () return C.GetAutoZoomResetOption() and ReadText(1001, 12642) or ReadText(1001, 12641) end,
            callback = function () return menu.callbackGameAutoZoomReset() end,
        },
        [37] = {
            id = "header",
            name = ReadText(1001, 2661),
        },
        [38] = {
            id = "game_defaults",
            name = ReadText(1001, 8984),
            submenu = "game_defaults",
        },
    },
    ["accessibility"] = {
        name = ReadText(1001, 8994),
        [1] = {
            id = "signalleakindicator",
            name = ReadText(1001, 8995),
            valuetype = "button",
            value = function () return C.GetSignalLeakIndicatorOption() and ReadText(1001, 12642) or ReadText(1001, 12641) end,
            callback = function () return menu.callbackAccessibilitySignalLeak() end,
        },
        [2] = {
            id = "longrangescanindicator",
            name = ReadText(1001, 8996),
            valuetype = "button",
            value = function () return C.GetLongRangeScanIndicatorOption() and ReadText(1001, 12642) or ReadText(1001, 12641) end,
            callback = function () return menu.callbackAccessibilityLongRangeScan() end,
        },
        [3] = {
            id = "globallightscale",
            name = ReadText(1001, 11755),
            valuetype = "slidercell",
            value = function () return menu.valueAccessibilityGlobalLightScale() end,
            callback = function (value) return menu.callbackAccessibilityGlobalLightScale(value) end,
        },
        [4] = {
            id = "lut",
            name = ReadText(1001, 7238),
            valuetype = "dropdown",
            value = function () return menu.valueGfxLUT(true) end,
            callback = function (id, option) return menu.callbackGfxLUT(id, option) end,
            display = function () return false end, -- TODO Florian
        },
        [5] = {
            id = "reducedspeedmode",
            name = ReadText(1001, 12654),
            mouseOverText = ReadText(1026, 2676),
            valuetype = "slidercell",
            value = function () return menu.valueAccessibilityReducedSpeedMode() end,
            callback = function (value) return menu.callbackAccessibilityReducedSpeedMode(value) end,
        },
        [6] = {
            id = "stardustintensity",
            name = ReadText(1001, 12763),
            valuetype = "slidercell",
            value = function () return menu.valueAccessibilityStardustIntensity() end,
            callback = function (value) return menu.callbackAccessibilityStardustIntensity(value) end,
        },
        [7] = {
            id = "line",
        },
        [8] = {
            id = "colorlibrary",
            name = function () return menu.nameColorBlind() end,
            submenu = "colorlibrary",
        },
        [9] = {
            id = "inputfeedback",
            name = ReadText(1001, 12628),
            submenu = "inputfeedback",
        },
        [10] = {
            id = "line",
        },
        [11] = {
            id = "accessibility_defaults",
            name = ReadText(1001, 8998),
            submenu = "accessibility_defaults",
        },
    },
    ["input"] = {
        name = ReadText(1001, 2656),
        warning = function () return menu.warningInput() end,
        [1] = {
            id = "header",
            name = ReadText(1001, 7227),
            display = C.IsVROculusTouchActive,
        },
        [2] = {
            id = "vrtouch_space",
            name = ReadText(1001, 12686),
            submenu = "vrtouch_space",
            display = C.IsVROculusTouchActive,
        },
        [3] = {
            id = "vrtouch_firstperson",
            name = ReadText(1001, 12687),
            submenu = "vrtouch_firstperson",
            display = C.IsVROculusTouchActive,
        },
        [4] = {
            id = "vrtouch_menus",
            name = ReadText(1001, 2660),
            submenu = "vrtouch_menus",
            display = C.IsVROculusTouchActive,
        },
        [5] = {
            id = "line",
            linecolor = Color["row_background"],
            lineheight = 4,
            display = C.IsVROculusTouchActive,
        },
        [6] = {
            id = "header",
            name = ReadText(1001, 7228),
            display = C.IsVRViveControllerActive,
        },
        [7] = {
            id = "vrvive_space",
            name = ReadText(1001, 12686),
            submenu = "vrvive_space",
            display = C.IsVRViveControllerActive,
        },
        [8] = {
            id = "vrvive_firstperson",
            name = ReadText(1001, 12687),
            submenu = "vrvive_firstperson",
            display = C.IsVRViveControllerActive,
        },
        [9] = {
            id = "vrvive_menus",
            name = ReadText(1001, 2660),
            submenu = "vrvive_menus",
            display = C.IsVRViveControllerActive,
        },
        [10] = {
            id = "vrvive_pointingdevice",
            name = ReadText(1001, 7224),
            valuetype = "dropdown",
            value = function () return menu.valueInputVivePointingDevice() end,
            callback = function (id, option) return menu.callbackInputVivePointingDevice(id, option) end,
            display = C.IsVRViveControllerActive,
        },
        [11] = {
            id = "line",
            linecolor = Color["row_background"],
            lineheight = 4,
            display = C.IsVRViveControllerActive,
        },
        [12] = {
            id = "header",
            name = function () return (C.IsVROculusTouchActive() or C.IsVRViveControllerActive()) and ReadText(1001, 7229) or ReadText(1001, 2656) end,
        },
        [13] = {
            id = "keyboard_space",
            name = ReadText(1001, 12686),
            submenu = "keyboard_space",
        },
        [14] = {
            id = "keyboard_firstperson",
            name = ReadText(1001, 12687),
            submenu = "keyboard_firstperson",
        },
        [15] = {
            id = "keyboard_menus",
            name = ReadText(1001, 2660),
            submenu = "keyboard_menus",
        },
        [16] = {
            id = "line",
            linecolor = Color["row_background"],
            lineheight = 4,
        },
        [17] = {
            id = "header",
            name = ReadText(1001, 4857),
        },
        [18] = {
            id = "profile_load",
            name = ReadText(1001, 12684),
            submenu = "profile_load",
        },
        [19] = {
            id = "profile_save",
            name = ReadText(1001, 12685),
            submenu = "profile_save",
        },
        [20] = {
            id = "line",
            linecolor = Color["row_background"],
            lineheight = 4,
        },
        [21] = {
            id = "header",
            name = ReadText(1001, 12691),
        },
        [22] = {
            id = "joysticks",
            name = ReadText(1001, 4856),
            submenu = "joysticks",
        },
        [23] = {
            id = "joystick_invert",
            name = ReadText(1001, 12678),
            submenu = "joystick_invert",
        },
        [24] = {
            id = "joystick_sensitivity",
            name = ReadText(1001, 12680),
            submenu = "joystick_sensitivity",
        },
        [25] = {
            id = "joystick_deadzone",
            name = ReadText(1001, 4835),
            valuetype = "slidercell",
            value = function () return menu.valueInputJoystickDeadzone() end,
            callback = function(value) return menu.callbackInputJoystickDeadzone(value) end,
        },
        [26] = {
            id = "joystick_bidirectional_throttle",
            name = ReadText(1001, 7261),
            mouseOverText = ReadText(1026, 2683),
            valuetype = "button",
            value = function () return C.IsThrottleBidirectional() and ReadText(1001, 12642) or ReadText(1001, 12641) end,
            callback = function () return menu.callbackInputJoystickBidirectionalThrottle() end,
        },
        [27] = {
            id = "gamepadmode",
            name = ReadText(1001, 4867),
            mouseOverText = ReadText(1026, 2684),
            valuetype = "dropdown",
            value = function () return menu.valueInputGamepadMode() end,
            callback = function (id, option) return menu.callbackInputGamepadMode(id, option) end,
        },
        [28] = {
            id = "joystick_steering_adaptive",
            name = ReadText(1001, 12682),
            mouseOverText = ReadText(1026, 2682),
            valuetype = "button",
            value = function () return C.IsJoystickSteeringAdapative() and ReadText(1001, 12642) or ReadText(1001, 12641) end,
            callback = function () return menu.callbackInputJoystickSteeringAdaptive() end,
        },
        [29] = {
            id = "line",
            linecolor = Color["row_background"],
            lineheight = 4,
        },
        [30] = {
            id = "header",
            name = ReadText(1001, 12692),
        },
        [31] = {
            id = "mouse_invert",
            name = ReadText(1001, 12679),
            submenu = "mouse_invert",
        },
        [32] = {
            id = "mouse_sensitivity",
            name = ReadText(1001, 12681),
            submenu = "mouse_sensitivity",
        },
        [33] = {
            id = "mouse_capture",
            name = ReadText(1001, 4820),
            valuetype = "button",
            value = function () return GetConfineMouseOption() and ReadText(1001, 12642) or ReadText(1001, 12641) end,
            callback = function () return menu.callbackInputMouseCapture() end,
        },
        [34] = {
            id = "mouse_steering_adaptive",
            name = ReadText(1001, 12683),
            mouseOverText = ReadText(1026, 2682),
            valuetype = "button",
            value = function () return C.IsMouseSteeringAdapative() and ReadText(1001, 12642) or ReadText(1001, 12641) end,
            callback = function () return menu.callbackInputMouseSteeringAdaptive() end,
        },
        [35] = {
            id = "mouse_steering_persistent",
            name = ReadText(1001, 11768),
            mouseOverText = ReadText(1026, 2685),
            valuetype = "button",
            value = function () return C.IsMouseSteeringPersistent() and ReadText(1001, 12642) or ReadText(1001, 12641) end,
            callback = function () return menu.callbackInputMouseSteeringPersistent() end,
        },
        [36] = {
            id = "mouse_steering_line",
            name = ReadText(1001, 11769),
            mouseOverText = ReadText(1026, 2686),
            valuetype = "button",
            value = function () return C.IsMouseSteeringLineEnabled() and ReadText(1001, 12642) or ReadText(1001, 12641) end,
            callback = function () return menu.callbackInputMouseSteeringLine() end,
        },
        [37] = {
            id = "line",
            linecolor = Color["row_background"],
            lineheight = 4,
        },
        [38] = {
            id = "header",
            name = ReadText(1001, 12729),
            display = C.IsOpenTrackEnabled,
        },
        [39] = {
            id = "tracker_support_opentrack",
            name = ReadText(1001, 12730),
            mouseOverText = ReadText(1026, 4810),
            valuetype = "button",
            value = function () return menu.valueInputOpenTrackSupport() end,
            callback = function () return menu.callbackInputOpenTrackSupport() end,
            display = C.IsOpenTrackEnabled,
        },
        [40] = {
            id = "tracker_support_opentrack_info",
            name = "",
            value = function () return menu.valueInputOpenTrackStatus() end,
            display = C.GetOpenTrackSupportOption,
            interactive = false,
        },
        [41] = {
            id = "line",
            linecolor = Color["row_background"],
            lineheight = 4,
            display = C.IsOpenTrackEnabled,
        },
        [42] = {
            id = "header",
            name = function () return ffi.string(C.GetActiveHeadTrackerName()) end,
            display = C.IsActiveHeadTrackerAvailable,
        },
        [43] = {
            id = "tracker_mode",
            name = ReadText(1001, 8941),
            valuetype = "dropdown",
            value = function () return menu.valueInputTrackerMode() end,
            callback = function (id, option) return menu.callbackInputTrackerMode(id, option) end,
            display = function () return C.IsActiveHeadTrackerAvailable() and C.IsActiveHeadTrackerSettingSupported("mode") end,
        },
        [44] = {
            id = "tracker_headfilterstrength",
            name = ReadText(1001, 8954),
            mouseOverText = ReadText(1026, 2647),
            valuetype = "slidercell",
            value = function () return menu.valueInputTrackerHeadFilterStrength() end,
            callback = function(value) return menu.callbackInputTrackerHeadFilterStrength(value) end,
            display = function () return C.IsActiveHeadTrackerAvailable() and C.IsActiveHeadTrackerSettingSupported("filterstrength") end,
        },
        [45] = {
            id = "tracker_anglefactor",
            name = ReadText(1001, 8950),
            mouseOverText = ReadText(1026, 2644),
            valuetype = "slidercell",
            value = function () return menu.valueInputTrackerAngleFactor() end,
            callback = function(value) return menu.callbackInputTrackerAngleFactor(value) end,
            display = function () return C.IsActiveHeadTrackerAvailable() and C.IsActiveHeadTrackerSettingSupported("anglefactor") end,
        },
        [46] = {
            id = "tracker_deadzoneangle",
            name = ReadText(1001, 8952),
            mouseOverText = ReadText(1026, 2645),
            valuetype = "slidercell",
            value = function () return menu.valueInputTrackerDeadzoneAngle() end,
            callback = function(value) return menu.callbackInputTrackerDeadzoneAngle(value) end,
            display = function () return C.IsActiveHeadTrackerAvailable() and C.IsActiveHeadTrackerSettingSupported("deadzoneangle") end,
        },
        [47] = {
            id = "tracker_positionfactor",
            name = ReadText(1001, 8958),
            mouseOverText = ReadText(1026, 2650),
            valuetype = "slidercell",
            value = function () return menu.valueInputTrackerPositionFactor() end,
            callback = function(value) return menu.callbackInputTrackerPositionFactor(value) end,
            display = function () return C.IsActiveHeadTrackerAvailable() and C.IsActiveHeadTrackerSettingSupported("positionfactor") end,
        },
        [48] = {
            id = "tracker_deadzoneposition",
            name = ReadText(1001, 8953),
            mouseOverText = ReadText(1026, 2646),
            valuetype = "slidercell",
            value = function () return menu.valueInputTrackerDeadzonePosition() end,
            callback = function(value) return menu.callbackInputTrackerDeadzonePosition(value) end,
            display = function () return C.IsActiveHeadTrackerAvailable() and C.IsActiveHeadTrackerSettingSupported("deadzoneposition") end,
        },
        [49] = {
            id = "tracker_gazefilterstrength",
            name = ReadText(1001, 8955),
            mouseOverText = ReadText(1026, 2648),
            valuetype = "slidercell",
            value = function () return menu.valueInputTrackerGazeFilterStrength() end,
            callback = function(value) return menu.callbackInputTrackerGazeFilterStrength(value) end,
            display = function () return C.IsActiveHeadTrackerAvailable() and C.IsActiveHeadTrackerSettingSupported("gazefilterstrength") end,
        },
        [50] = {
            id = "tracker_gazeanglefactor",
            name = ReadText(1001, 8951),
            mouseOverText = ReadText(1026, 2644),
            valuetype = "slidercell",
            value = function () return menu.valueInputTrackerGazeAngleFactor() end,
            callback = function(value) return menu.callbackInputTrackerGazeAngleFactor(value) end,
            display = function () return C.IsActiveHeadTrackerAvailable() and C.IsActiveHeadTrackerSettingSupported("gazeanglefactor") end,
        },
        [51] = {
            id = "tracker_gazedeadzone",
            name = ReadText(1001, 8949),
            mouseOverText = ReadText(1026, 2649),
            valuetype = "slidercell",
            value = function () return menu.valueInputTrackerGazeDeadzone() end,
            callback = function(value) return menu.callbackInputTrackerGazeDeadzone(value) end,
            display = function () return C.IsActiveHeadTrackerAvailable() and C.IsActiveHeadTrackerSettingSupported("gazedeadzone") end,
        },
        [52] = {
            id = "line",
            linecolor = Color["row_background"],
            lineheight = 4,
            display = C.IsActiveHeadTrackerAvailable,
        },
        [53] = {
            id = "header",
            name = function () return ReadText(1001, 4815) end,
        },
        [54] = {
            id = "input_modifiers",
            name = ReadText(1001, 12643),
            submenu = "input_modifiers",
        },
    },
    ["joystick_invert"] = {
        name = ReadText(1001, 2674) .. ReadText(1001, 120) .. " " .. ReadText(1001, 2675),
        [1] = {
            id = "header",
            name = ReadText(1001, 2662),
        },
        [2] = {
            id = "invert_steering_yaw",
            name = ReadText(config.input.controltextpage.ranges, 1),
            valuetype = "button",
            value = function () return menu.valueInputInvert(1) end,
            callback = function () return menu.callbackInputInvert(1, "invert_steering_yaw") end,
        },
        [3] = {
            id = "invert_steering_pitch",
            name = ReadText(config.input.controltextpage.ranges, 2),
            valuetype = "button",
            value = function () return menu.valueInputInvert(2) end,
            callback = function () return menu.callbackInputInvert(2, "invert_steering_pitch") end,
        },
        [4] = {
            id = "invert_steering_roll",
            name = ReadText(config.input.controltextpage.ranges, 3),
            valuetype = "button",
            value = function () return menu.valueInputInvert(3) end,
            callback = function () return menu.callbackInputInvert(3, "invert_steering_roll") end,
        },
        [5] = {
            id = "invert_throttle",
            name = ReadText(config.input.controltextpage.ranges, 4),
            valuetype = "button",
            value = function () return menu.valueInputInvert(4) end,
            callback = function () return menu.callbackInputInvert(4, "invert_throttle") end,
        },
        [6] = {
            id = "invert_strafe_left_right",
            name = ReadText(config.input.controltextpage.ranges, 5),
            valuetype = "button",
            value = function () return menu.valueInputInvert(5) end,
            callback = function () return menu.callbackInputInvert(5, "invert_strafe_left_right") end,
        },
        [7] = {
            id = "invert_strafe_up_down",
            name = ReadText(config.input.controltextpage.ranges, 6),
            valuetype = "button",
            value = function () return menu.valueInputInvert(6) end,
            callback = function () return menu.callbackInputInvert(6, "invert_strafe_up_down") end,
        },
        [8] = {
            id = "header",
            name = ReadText(1001, 12688),
        },
        [9] = {
            id = "invert_fp_yaw",
            name = ReadText(config.input.controltextpage.ranges, 13),
            valuetype = "button",
            value = function () return menu.valueInputInvert(13) end,
            callback = function () return menu.callbackInputInvert(13, "invert_fp_yaw") end,
        },
        [10] = {
            id = "invert_fp_pitch",
            name = ReadText(config.input.controltextpage.ranges, 14),
            valuetype = "button",
            value = function () return menu.valueInputInvert(14) end,
            callback = function () return menu.callbackInputInvert(14, "invert_fp_pitch") end,
        },
        [11] = {
            id = "invert_fp_walk",
            name = ReadText(config.input.controltextpage.ranges, 15),
            valuetype = "button",
            value = function () return menu.valueInputInvert(15) end,
            callback = function () return menu.callbackInputInvert(15, "invert_fp_walk") end,
        },
        [12] = {
            id = "invert_fp_strafe",
            name = ReadText(config.input.controltextpage.ranges, 16),
            valuetype = "button",
            value = function () return menu.valueInputInvert(16) end,
            callback = function () return menu.callbackInputInvert(16, "invert_fp_strafe") end,
        },
        [13] = {
            id = "header",
            name = ReadText(1001, 4836),
        },
        [14] = {
            id = "invert_controllermouse_x",
            name = ReadText(config.input.controltextpage.ranges, 23),
            valuetype = "button",
            value = function () return menu.valueInputInvert(23) end,
            callback = function () return menu.callbackInputInvert(23, "invert_controllermouse_x") end,
        },
        [15] = {
            id = "invert_controllermouse_y",
            name = ReadText(config.input.controltextpage.ranges, 24),
            valuetype = "button",
            value = function () return menu.valueInputInvert(24) end,
            callback = function () return menu.callbackInputInvert(24, "invert_controllermouse_y") end,
        },
        [16] = {
            id = "invert_compassmenu_x",
            name = ReadText(config.input.controltextpage.ranges, 36),
            valuetype = "button",
            value = function () return menu.valueInputInvert(36) end,
            callback = function () return menu.callbackInputInvert(36, "invert_compassmenu_x") end,
        },
        [17] = {
            id = "invert_compassmenu_y",
            name = ReadText(config.input.controltextpage.ranges, 37),
            valuetype = "button",
            value = function () return menu.valueInputInvert(37) end,
            callback = function () return menu.callbackInputInvert(37, "invert_compassmenu_y") end,
        },
    },
    ["joystick_sensitivity"] = {
        name = ReadText(1001, 2674) .. ReadText(1001, 120) .. " " .. ReadText(1001, 2684),
        [1] = {
            id = "header",
            name = ReadText(1001, 12688),
        },
        [2] = {
            id = "sensitivity_fp_yaw",
            name = ReadText(config.input.controltextpage.ranges, 13),
            valuetype = "slidercell",
            value = function () return menu.valueInputSensitivity(13) end,
            callback = function (value) return menu.callbackInputSensitivity(13, "sensitivity_fp_yaw", value) end,
        },
        [3] = {
            id = "sensitivity_fp_pitch",
            name = ReadText(config.input.controltextpage.ranges, 14),
            valuetype = "slidercell",
            value = function () return menu.valueInputSensitivity(14) end,
            callback = function (value) return menu.callbackInputSensitivity(14, "sensitivity_fp_pitch", value) end,
        },
    },
    ["mouse_invert"] = {
        name = ReadText(1001, 2683) .. ReadText(1001, 120) .. " " .. ReadText(1001, 2675),
        [1] = {
            id = "header",
            name = ReadText(1001, 2662),
        },
        [2] = {
            id = "invert_mouse_pitch",
            name = ReadText(1001, 8975),
            valuetype = "button",
            value = function () return menu.valueInputMouseSteeringInvert("invert_mouse_pitch") end,
            callback = function () return menu.callbackInputMouseSteeringInvert("invert_mouse_pitch") end,
        },
        [3] = {
            id = "invert_mouse_yaw",
            name = ReadText(1001, 8976),
            valuetype = "button",
            value = function () return menu.valueInputMouseSteeringInvert("invert_mouse_yaw") end,
            callback = function () return menu.callbackInputMouseSteeringInvert("invert_mouse_yaw") end,
        },
        [4] = {
            id = "invert_mouse_roll",
            name = ReadText(1001, 8977),
            valuetype = "button",
            value = function () return menu.valueInputMouseSteeringInvert("invert_mouse_roll") end,
            callback = function () return menu.callbackInputMouseSteeringInvert("invert_mouse_roll") end,
        },
        [5] = {
            id = "invert_direct_mouse_steering_yaw",
            name = ReadText(config.input.controltextpage.ranges, 29),
            valuetype = "button",
            value = function () return menu.valueInputInvert(29) end,
            callback = function () return menu.callbackInputInvert(29, "invert_direct_mouse_steering_yaw") end,
        },
        [6] = {
            id = "invert_direct_mouse_steering_pitch",
            name = ReadText(config.input.controltextpage.ranges, 30),
            valuetype = "button",
            value = function () return menu.valueInputInvert(30) end,
            callback = function () return menu.callbackInputInvert(30, "invert_direct_mouse_steering_pitch") end,
        },
        [7] = {
            id = "invert_direct_mouse_steering_roll",
            name = ReadText(config.input.controltextpage.ranges, 31),
            valuetype = "button",
            value = function () return menu.valueInputInvert(31) end,
            callback = function () return menu.callbackInputInvert(31, "invert_direct_mouse_steering_roll") end,
        },
        [8] = {
            id = "header",
            name = ReadText(1001, 12688),
        },
        [9] = {
            id = "invert_fp_mouse_yaw",
            name = ReadText(config.input.controltextpage.ranges, 7),
            valuetype = "button",
            value = function () return menu.valueInputInvert(7) end,
            callback = function () return menu.callbackInputInvert(7, "invert_fp_mouse_yaw") end,
        },
        [10] = {
            id = "invert_fp_mouse_pitch",
            name = ReadText(config.input.controltextpage.ranges, 8),
            valuetype = "button",
            value = function () return menu.valueInputInvert(8) end,
            callback = function () return menu.callbackInputInvert(8, "invert_fp_mouse_pitch") end,
        },
    },
    ["mouse_sensitivity"] = {
        name = ReadText(1001, 2683) .. ReadText(1001, 120) .. " " .. ReadText(1001, 2684),
        [1] = {
            id = "header",
            name = ReadText(1001, 2662),
        },
        [2] = {
            id = "sensitivity_direct_mouse_steering_yaw",
            name = ReadText(config.input.controltextpage.ranges, 29),
            valuetype = "slidercell",
            value = function () return menu.valueInputSensitivity(29) end,
            callback = function (value) return menu.callbackInputSensitivity(29, "sensitivity_direct_mouse_steering_yaw", value) end,
        },
        [3] = {
            id = "sensitivity_direct_mouse_steering_pitch",
            name = ReadText(config.input.controltextpage.ranges, 30),
            valuetype = "slidercell",
            value = function () return menu.valueInputSensitivity(30) end,
            callback = function (value) return menu.callbackInputSensitivity(30, "sensitivity_direct_mouse_steering_pitch", value) end,
        },
        [4] = {
            id = "sensitivity_direct_mouse_steering_roll",
            name = ReadText(config.input.controltextpage.ranges, 31),
            valuetype = "slidercell",
            value = function () return menu.valueInputSensitivity(31) end,
            callback = function (value) return menu.callbackInputSensitivity(31, "sensitivity_direct_mouse_steering_roll", value) end,
        },
        [5] = {
            id = "header",
            name = ReadText(1001, 12688),
        },
        [6] = {
            id = "sensitivity_fp_mouse_yaw",
            name = ReadText(config.input.controltextpage.ranges, 7),
            valuetype = "slidercell",
            value = function () return menu.valueInputSensitivity(7) end,
            callback = function (value) return menu.callbackInputSensitivity(7, "sensitivity_fp_mouse_yaw", value) end,
        },
        [7] = {
            id = "sensitivity_fp_mouse_pitch",
            name = ReadText(config.input.controltextpage.ranges, 8),
            valuetype = "slidercell",
            value = function () return menu.valueInputSensitivity(8) end,
            callback = function (value) return menu.callbackInputSensitivity(8, "sensitivity_fp_mouse_pitch", value) end,
        },
    },
    ["privacy"] = {
        name = ReadText(1001, 4870),
        [1] = {
            id = "crashreport",
            name = ReadText(1001, 4871),
            info = ReadText(1001, 4874),
            valuetype = "button",
            value = function () return GetCrashReportOption() and ReadText(1001, 2617) or ReadText(1001, 2618) end,
            callback = function () return menu.callbackPrivacyCrash() end,
        },
        [2] = {
            id = "senduserid",
            name = ReadText(1001, 4873),
            info = ReadText(1001, 4875),
            valuetype = "button",
            value = function () return GetPersonalizedCrashReportsOption() and ReadText(1001, 2617) or ReadText(1001, 2618) end,
            callback = function () return menu.callbackPrivacyUserID() end,
            display = C.AllowPersonalizedData
        },
        [3] = {
            id = "policy",
            name = ReadText(1001, 7292),
            info = ReadText(1001, 7293),
            valuetype = "button",
            value = "\27[mm_externallink]",
            callback = function () return menu.buttonPrivacyPolicy() end,
            selectable = C.CanOpenWebBrowser,
        },
    },
}

config.DLSSmodes = {
    ["off"] = ReadText(1001, 12641),
    ["auto"] = ReadText(1001, 12737),
    ["quality"] = ReadText(1001, 12738),
    ["balanced"] = ReadText(1001, 12739),
    ["performance"] = ReadText(1001, 12740),
    ["ultra_performance"] = ReadText(1001, 12741),
    ["dlaa"] = ReadText(1001, 12742),
}

-- kuertee start: rewrites

local OldFuncs = {}
menu.uix_callbacks = {}

function ModLua.rewriteFunctions()
    OldFuncs.loadSaveCallback = menu.loadSaveCallback
    menu.loadSaveCallback = ModLua.loadSaveCallback
    OldFuncs.addSavegameRow = menu.addSavegameRow
    menu.addSavegameRow = ModLua.addSavegameRow
    OldFuncs.cleanup = menu.cleanup
    menu.cleanup = ModLua.cleanup
    OldFuncs.submenuHandler = menu.submenuHandler
    menu.submenuHandler = ModLua.submenuHandler
    OldFuncs.loadGameCallback = menu.loadGameCallback
    menu.loadGameCallback = ModLua.loadGameCallback
    OldFuncs.callbackDeleteSave = menu.callbackDeleteSave
    menu.callbackDeleteSave = ModLua.callbackDeleteSave
    OldFuncs.displayOptions = menu.displayOptions
    menu.displayOptions = ModLua.displayOptions
    OldFuncs.extensionSorter = menu.extensionSorter
    menu.extensionSorter = ModLua.extensionSorter
    OldFuncs.displayExtensions = menu.displayExtensions
    menu.displayExtensions = ModLua.displayExtensions
    OldFuncs.displayExtensionRow = menu.displayExtensionRow
    menu.displayExtensionRow = ModLua.displayExtensionRow
    OldFuncs.displaySavegameOptions = menu.displaySavegameOptions
    menu.displaySavegameOptions = ModLua.displaySavegameOptions
    OldFuncs.onUpdate = menu.onUpdate
    menu.onUpdate = ModLua.onUpdate
    OldFuncs.newGameCallback = menu.newGameCallback
    menu.newGameCallback = ModLua.newGameCallback
end

function ModLua.loadSaveCallback(_, filename)
    if (type(filename) ~= "string") or (not C.IsSaveValid(filename)) then
        DebugError("Lua Event 'loadSave' got an invalid filename '" .. tostring(filename) .. "'.")
        return
    end
    C.SkipNextStartAnimation()
    menu.delayedLoadGame = filename

    -- kuertee start: callback
    -- Helper.addDelayedOneTimeCallbackOnUpdate(function () LoadGame(filename) end, true, getElapsedTime() + 0.1)
    Helper.addDelayedOneTimeCallbackOnUpdate(
        function ()
            if menu.uix_callbacks ["loadGameCallback_preLoadGame"] then
                for uix_id, uix_callback in pairs (menu.uix_callbacks ["loadGameCallback_preLoadGame"]) do
                    uix_callback(filename)
                end
            end
            LoadGame(filename)
        end
        , true, getElapsedTime() + 0.1)
    -- kuertee end: callback

    menu.displayInit()
end

function ModLua.addSavegameRow(ftable, savegame, name, slot, maxSlot)
    -- kuertee start: callback
    local isAddSaveGameToList = true
    savegame.uix_isDisplayedInList = true
    if menu.uix_callbacks ["addSavegameRow_isListSaveGame"] then
        for uix_id, uix_callback in pairs (menu.uix_callbacks ["addSavegameRow_isListSaveGame"]) do
            isAddSaveGameToList = uix_callback(ftable, savegame, name, slot)
            if not isAddSaveGameToList then
                break
            end
        end
        if not isAddSaveGameToList then
            savegame.uix_isDisplayedInList = nil
            return 0
        end
    end
    -- kuertee end: callback


    -- kuertee start: callback
    if menu.uix_callbacks ["addSavegameRow_changeSaveGameDisplayName"] then
        for uix_id, uix_callback in pairs (menu.uix_callbacks ["addSavegameRow_changeSaveGameDisplayName"]) do
            name = uix_callback(ftable, savegame, name, slot) or name
        end
    end
    -- kuertee end: callback

    -- kuertee start: callback
    if menu.uix_callbacks ["addSavegameRow_preSaveGameRowAdd"] then
        for uix_id, uix_callback in pairs (menu.uix_callbacks ["addSavegameRow_preSaveGameRowAdd"]) do
            uix_callback(ftable, savegame, name, slot, maxSlot, config)
        end
    end
    -- kuertee end: callback

    local invalid = false
    if menu.currentOption == "load" then
        invalid = savegame.error or savegame.invalidgameid or savegame.invalidversion or savegame.invalidpatches
    end

    local row = ftable:addRow(savegame, {  })
    if menu.preselectOption == nil then
        menu.preselectOption = savegame.filename
    end
    if savegame.filename == menu.preselectOption then
        ftable:setSelectedRow(row.index)
        menu.selectedOption = savegame
    end

    if slot then
        row[2]:createText(slot, (not invalid) and config.standardTextProperties or config.disabledTextProperties)
        row[2].properties.halign = "right"
    end

    local nametruncated = TruncateText(name, config.fontBold, Helper.scaleFont(config.font, config.standardFontSize), row[3]:getWidth() - Helper.scaleX(config.standardTextOffsetX))
    local mouseovertext = ""
    if nametruncated ~= name then
        mouseovertext = name
    end

    local isonlinesaveinofflineslot = IsCheatVersion() and savegame.isonline and not savegame.isonlinesavefilename

    local height = Helper.scaleY(config.standardTextHeight) + Helper.borderSize

    -- kuertee start: callback
    local uix_isAddRowHeightForExtraInfo = nil
    if menu.uix_callbacks ["addSavegameRow_getRowHeightForExtraInfo"] then
        for uix_id, uix_callback in pairs (menu.uix_callbacks ["addSavegameRow_getRowHeightForExtraInfo"]) do
            uix_isAddRowHeightForExtraInfo = uix_isAddRowHeightForExtraInfo or uix_callback(ftable, savegame, name, slot)
        end
    end
    if uix_isAddRowHeightForExtraInfo ~= false then
    -- kuertee end: callback

        if invalid or savegame.modified or isonlinesaveinofflineslot then
            height = 2 * Helper.scaleY(config.standardTextHeight) + Helper.borderSize
        end

    -- kuertee start: callback
    end
    -- kuertee end: callback

    local warningicon = ""
    if savegame.isonline then
        if C.IsClientModified() or (not OnlineHasSession()) or (C.GetVentureDLCStatus() ~= 0) then
            warningicon = ColorText["icon_warning"] .. "\27[workshop_error]\27X"
        end
    end

    local icon = row[3]:createIcon("solid", { width = row[3]:getWidth(), height = height, color = Color["icon_transparent"], scaling = false, mouseOverText = mouseovertext }):setText(warningicon .. nametruncated, (not invalid) and config.standardTextProperties or config.disabledTextProperties)

    -- kuertee start: callback
    local uix_isBoldFileName = nil
    if menu.uix_callbacks ["addSavegameRow_getIsBoldFilename"] then
        for uix_id, uix_callback in pairs (menu.uix_callbacks ["addSavegameRow_getIsBoldFilename"]) do
            uix_isBoldFileName = uix_isBoldFileName or uix_callback(ftable, savegame, name, slot)
        end
    end
    if uix_isBoldFileName ~= false then
    -- kuertee end: callback

        row[3].properties.text.font = config.fontBold

    -- kuertee start: callback
    end
    -- kuertee end: callback

    row[3].properties.text.scaling = true

    -- kuertee start:
    if uix_isAddRowHeightForExtraInfo ~= false then
    -- kuertee end

        if invalid then
            icon:setText2(function () return menu.errorSavegame(savegame) end, (not invalid) and config.standardTextProperties or config.disabledTextProperties)
            row[3].properties.text2.y = config.standardTextHeight
            row[3].properties.text2.scaling = true
        elseif savegame.modified then
            icon:setText2(ColorText["text_warning"] .. ReadText(1001, 8901) .. "\27X", (not invalid) and config.standardTextProperties or config.disabledTextProperties)
            row[3].properties.text2.y = config.standardTextHeight
            row[3].properties.text2.scaling = true
        elseif isonlinesaveinofflineslot then
            icon:setText2(ColorText["text_online_save"] .. ReadText(1001, 11570) .. "\27X", (not invalid) and config.standardTextProperties or config.disabledTextProperties)
            row[3].properties.text2.y = config.standardTextHeight
            row[3].properties.text2.scaling = true
        end

    -- kuertee start:
    end
    -- kuertee end

    row[4]:setColSpan(2):createText(savegame.error and "" or savegame.time, (not invalid) and config.standardTextProperties or config.disabledTextProperties)
    row[4].properties.halign = "right"

    -- kuertee start: callback
    -- return row:getHeight()
    local maxRowHeight = row:getHeight()
    if menu.uix_callbacks ["addSavegameRow_postSaveGameRowAdd"] then
        for uix_id, uix_callback in pairs (menu.uix_callbacks ["addSavegameRow_postSaveGameRowAdd"]) do
            maxRowHeight = math.max(maxRowHeight, uix_callback(ftable, savegame, name, slot, maxSlot, config))
        end
    end
    -- kuertee end: callback

    return maxRowHeight
end

function ModLua.cleanup()
    if not menu.isStartmenu then
        if menu.paused then
            Unpause()
            menu.paused = nil
        end
        if menu.hasInputModeChangedRegistered then
            unregisterForEvent("inputModeChanged", getElement("Scene.UIContract"), menu.onInputModeChanged)
            menu.hasInputModeChangedRegistered = nil
        end
    end

    C.ResetEncryptedDirectInputData()
    if menu.onlineData then
        menu.onlineData.password = ""
    end

    menu.currentOption = nil
    menu.selectedOption = nil
    menu.preselectOption = nil
    menu.preselectTopRow = nil
    menu.preselectCol = nil
    menu.animationDelay = nil

    menu.selectedRows = {}
    menu.selectedCols = {}
    menu.topRows = {}

    menu.history = {}
    menu.savegames = nil
    menu.onlinesave = nil
    menu.languagedata = {}
    menu.remapControl = nil
    menu.directInputActive = nil
    menu.lobby = {}
    menu.updateServers = nil
    menu.selectedExtension = {}
    menu.curDropDownOption = {}
    menu.idleTimer = nil

    menu.controls = {}

    menu.contextFrame = nil

    menu.titleTable = nil
    menu.optionTable = nil
    menu.infoTable = nil
    menu.rendertarget = nil

    menu.width = nil
    menu.widthExtraWide = nil
    menu.height = nil
    menu.frameOffsetX = nil
    menu.frameOffsetXExtraWide = nil
    menu.frameOffsetY = nil

    menu.table = {}

    -- kuertee start: callback
    if menu.uix_callbacks ["cleanup"] then
        for uix_id, uix_callback in pairs (menu.uix_callbacks ["cleanup"]) do
            uix_callback()
        end
    end
    -- kuertee end: callback
end

function ModLua.submenuHandler(optionParameter)
    menu.userQuestion = nil

    if optionParameter == nil then
        DebugError("Invalid call to menu.submenuHandler(): ")
        DebugError(TraceBack())
        return
    end

    AddUITriggeredEvent(menu.name, "menu_" .. optionParameter)

    if optionParameter ~= "main" then
        C.HidePromo()
    end

    -- kuertee start: callback
    if menu.uix_callbacks ["submenuHandler_preDisplayOptions"] then
        for uix_id, uix_callback in pairs (menu.uix_callbacks ["submenuHandler_preDisplayOptions"]) do
            uix_callback(optionParameter)
        end
    end
    -- kuertee end: callback

    if optionParameter == "main" then
        if menu.isStartmenu then
            C.ShowPromo()
        end
        menu.displayOptions(optionParameter)
    elseif optionParameter == "new" then
        menu.displayNewGame(false, false, false)
    elseif optionParameter == "tutorials" then
        menu.displayNewGame(false, false, true)
    elseif optionParameter == "load" then
        menu.displaySavegameOptions(optionParameter)
    elseif optionParameter == "save" then
        menu.displaySavegameOptions(optionParameter)
    elseif optionParameter == "saveoffline" then
        menu.displaySavegameOptions(optionParameter)
    elseif optionParameter == "multiplayer_server" then
        menu.displayNewGame(true, false, false)
    elseif optionParameter == "new_timelines" then
        menu.displayNewGame(false, true, false)
    elseif optionParameter == "lobby" then
        menu.displayLobby()
    elseif optionParameter == "online" then
        __CORE_GAMEOPTIONS_PRIVACYPOLICY = false
        menu.displayOnlineLogin()
    elseif optionParameter == "extensions" then
        menu.displayExtensions()
    elseif optionParameter == "bonus" then
        menu.displayBonusContent()
    elseif optionParameter == "defaults" then
        menu.displayUserQuestion(ReadText(1001, 2653), function () return menu.callbackDefaults() end)
    elseif optionParameter == "gfx_defaults" then
        menu.displayUserQuestion(ReadText(1001, 2653), function () return menu.callbackGfxDefaults() end)
    elseif optionParameter == "sfx_defaults" then
        menu.displayUserQuestion(ReadText(1001, 2653), function () return menu.callbackSfxDefaults() end)
    elseif optionParameter == "game_defaults" then
        menu.displayUserQuestion(ReadText(1001, 2653), function () return menu.callbackGameDefaults() end)
    elseif optionParameter == "accessibility_defaults" then
        menu.displayUserQuestion(ReadText(1001, 2653), function () return menu.callbackAccessibilityDefaults() end)
    elseif optionParameter == "timelines_reset" then
        menu.displayUserQuestion(ReadText(1001, 12622), function () return menu.callbackResetTimelines() end, nil, nil, nil, nil, nil, ReadText(1001, 12623))
    elseif  (optionParameter == "vrtouch_space") or
            (optionParameter == "vrtouch_firstperson") or
            (optionParameter == "vrtouch_menus") or
            (optionParameter == "vrvive_space") or
            (optionParameter == "vrvive_firstperson") or
            (optionParameter == "vrvive_menus") or
            (optionParameter == "keyboard_space") or
            (optionParameter == "keyboard_firstperson") or
            (optionParameter == "keyboard_menus")
    then
        menu.displayControls(optionParameter)
    elseif optionParameter == "joysticks" then
        menu.displayJoysticks()
    elseif optionParameter == "profile_load" then
        menu.displayInputProfiles(optionParameter)
    elseif optionParameter == "profile_save" then
        menu.displayInputProfiles(optionParameter)
    elseif optionParameter == "language" then
        menu.displayLanguageOptions()
    elseif optionParameter == "onlineseason" then
        menu.displayOnlineSeason(optionParameter)
    elseif optionParameter == "credits" then
        menu.displayCredits(optionParameter)
    elseif optionParameter == "idle" then
        menu.displayCredits(optionParameter)
    elseif optionParameter == "exit" then
        menu.displayUserQuestion(ReadText(1001, 2645), function () return menu.callbackExit(false) end, nil, nil, nil, nil, nil, Helper.isOnlineGame() and ReadText(1001, 11710) or nil)
    elseif optionParameter == "quit" then
        menu.displayUserQuestion(ReadText(1001, 4876), function () return menu.callbackExit(true) end)
    elseif optionParameter == "privacy" then
        menu.displayOptionsInfo(optionParameter)
    elseif optionParameter == "mapeditor" then
        menu.displayMapEditor()
    elseif optionParameter == "colorlibrary" then
        menu.displayColorLibrary()
    elseif optionParameter == "inputfeedback" then
        menu.displayInputFeedback()
    elseif optionParameter == "input_modifiers" then
        menu.displayInputModifiers()
    elseif optionParameter == "timelines" then
        menu.displayTimelines()
    elseif config.optionDefinitions[optionParameter] then
        menu.displayOptions(optionParameter)
    end
end

function ModLua.loadGameCallback(filename, checked)
    local playerinventory = GetPlayerInventory()
    local onlineitems = OnlineGetUserItems()

    -- kuertee start:
    if not onlineitems then
        onlineitems = {}
    end
    -- kuertee end

    local hasnotuploadeditems = false
    for ware, waredata in Helper.orderedPairs(playerinventory) do
        local isbraneitem, isoperationvolatile, isseasonvolatile, isventureuploadallowed = GetWareData(ware, "isbraneitem", "isoperationvolatile", "isseasonvolatile", "isventureuploadallowed")
        if isbraneitem then
            local serveramount = 0
            if onlineitems[ware] then
                serveramount = onlineitems[ware].amount
            end
            if isventureuploadallowed and (waredata.amount > serveramount) then
                hasnotuploadeditems = true
                break
            end
        end
    end

    if (not checked) and (not menu.isStartmenu) and Helper.isOnlineGame() and hasnotuploadeditems then
        table.insert(menu.history, 1, { optionParameter = menu.currentOption, topRow = GetTopRow(menu.optionTable), selectedOption = filename })
        menu.displayUserQuestion(ReadText(1001, 2604) .. " - " .. ReadText(1001, 7720), function () return menu.loadGameCallback(filename, true) end, nil, nil, nil, nil, nil, ReadText(1001, 11707))
    else
        -- kuertee start: callback
        -- Helper.addDelayedOneTimeCallbackOnUpdate(function () LoadGame(filename) end, true, getElapsedTime() + 0.1)
        Helper.addDelayedOneTimeCallbackOnUpdate(
            function ()
                if menu.uix_callbacks ["loadGameCallback_preLoadGame"] then
                    for uix_id, uix_callback in pairs (menu.uix_callbacks ["loadGameCallback_preLoadGame"]) do
                        uix_callback(filename)
                    end
                end
                LoadGame(filename)
            end
        , true, getElapsedTime() + 0.1)
        -- kuertee end: callback

        menu.displayInit()
    end
end

function ModLua.callbackDeleteSave(filename)
    C.DeleteSavegame(filename)

    menu.savegames = nil
    menu.onlinesave = nil
    C.ReloadSaveList()
    menu.onCloseElement("back")

    -- kuertee start: callback
    if menu.uix_callbacks ["callbackDeleteSave_onDeleteSave"] then
        for uix_id, uix_callback in pairs (menu.uix_callbacks ["callbackDeleteSave_onDeleteSave"]) do
            uix_callback(filename)
        end
    end
    -- kuertee end: callback
end

function ModLua.displayOptions(optionParameter)
    -- remove old data
    Helper.clearDataForRefresh(menu, config.optionsLayer)
    menu.selectedOption = nil

    menu.currentOption = optionParameter
    local options = config.optionDefinitions[optionParameter]

    -- kuertee start: callback
    if menu.uix_callbacks ["displayOptions_modifyOptions"] then
        for uix_id, uix_callback in pairs (menu.uix_callbacks ["displayOptions_modifyOptions"]) do
            options = uix_callback(options)
        end
    end
    -- kuertee end: callback

    local frame = menu.createOptionsFrame()

    local ftable = frame:addTable(5, { tabOrder = 1, x = menu.table.x, y = menu.table.y, width = menu.table.width, maxVisibleHeight = menu.table.height })
    ftable:setColWidth(1, menu.table.arrowColumnWidth, false)
    ftable:setColWidth(3, menu.table.infoColumnWidth / 2, false)
    ftable:setColWidth(4, menu.table.infoColumnWidth / 2 - Helper.scaleY(config.infoTextHeight) - Helper.borderSize, false)
    ftable:setColWidth(5, Helper.scaleY(config.infoTextHeight), false)
    ftable:setDefaultColSpan(3, 3)
    ftable:setDefaultCellProperties("button", { height = config.standardTextHeight })
    ftable:setDefaultComplexCellProperties("button", "text", { x = config.standardTextOffsetX, fontsize = config.standardFontSize })
    ftable:setDefaultCellProperties("dropdown", { height = config.standardTextHeight })
    ftable:setDefaultComplexCellProperties("dropdown", "text", { x = config.standardTextOffsetX, fontsize = config.standardFontSize })
    ftable:setDefaultCellProperties("slidercell", { height = config.standardTextHeight })
    ftable:setDefaultComplexCellProperties("slidercell", "text", { x = config.standardTextOffsetX, fontsize = config.standardFontSize })

    -- title
    local row = ftable:addRow(menu.currentOption ~= "main", { fixed = true })
    row[1]:setBackgroundColSpan(5)
    local colOffset = 1
    if menu.currentOption ~= "main" then
        row[1]:createButton({ height = config.headerTextHeight }):setIcon(config.backarrow, { x = config.backarrowOffsetX })
        row[1].handlers.onClick = function () return menu.onCloseElement("back") end
        colOffset = 0
    end
    if options.info then
        row[2 - colOffset]:setColSpan(2 + colOffset):createText(options.name, config.headerTextProperties)
        row[4]:setColSpan(2):createText(options.info, config.infoTextProperties)
    else
        row[2 - colOffset]:setColSpan(4 + colOffset):createText(options.name, config.headerTextProperties)
    end

    -- warning
    if options.warning then
        local warning, warningFont = options.warning()
        local row = ftable:addRow(false, { fixed = true })
        row[1]:setColSpan(5):createText(function () local text = options.warning() return text end, config.warningTextProperties)
        if warningFont then
            row[1].properties.font = warningFont
        end
    end

    -- options
    for optionIdx, option in ipairs(options) do
        menu.displayOption(ftable, option)
    end

    ftable:setTopRow(menu.preselectTopRow)
    menu.preselectTopRow = nil
    menu.preselectOption = nil

    frame:display()
end

function ModLua.extensionSorter(a, b)
    local agroup = menu.getExtensionGroup(a)
    local bgroup = menu.getExtensionGroup(b)
    if agroup ~= bgroup then
        return agroup < bgroup
    end
    if agroup == 1 then
        local aisminidlc = string.find(a.id, "^ego_dlc_mini_")
        local bisminidlc = string.find(b.id, "^ego_dlc_mini_")
        if aisminidlc ~= bisminidlc then
            return not aisminidlc       -- non-mini DLC before mini DLC
        end
        return Helper.sortDate(a, b)    -- sort DLC of either type by date
    end

    -- kuertee start: sort by enabled then by name
    -- return Helper.sortName(a, b)        -- sort other extensions by name
    if a.enabled and b.enabled then
        return a.name < b.name
    elseif a.enabled then
        return true
    elseif b.enabled then
        return false
    else
        return a.name < b.name
    end
    -- kuertee end: sort by enabled then by name
end

function ModLua.displayExtensions()
    -- remove old data
    Helper.clearDataForRefresh(menu, config.optionsLayer)
    menu.selectedOption = nil

    menu.currentOption = "extensions"

    local frame = menu.createOptionsFrame(true)

    local infowidth = menu.table.width - menu.table.widthWithExtraInfo - Helper.borderSize

    local titletable = frame:addTable(2, { tabOrder = 2, x = menu.table.x, y = menu.table.y, width = menu.table.widthExtraWide, skipTabChange = true })
    titletable:setColWidth(1, menu.table.arrowColumnWidth, false)

    -- title
    local row = titletable:addRow(true, { fixed = true })
    row[1]:setBackgroundColSpan(2)
    row[1]:createButton({ height = config.headerTextHeight }):setIcon(config.backarrow, { x = config.backarrowOffsetX })
    row[1].handlers.onClick = function () return menu.onCloseElement("back") end
    row[2]:createText(ReadText(1001, 2697), config.headerTextProperties)

    -- warning
    local row = titletable:addRow(false, { fixed = true })
    row[2]:createText(menu.warningExtensions, config.warningTextProperties)

    local offsety = titletable.properties.y + titletable:getVisibleHeight() + Helper.borderSize
    local height = menu.table.height - offsety

    local optiontable = frame:addTable(7, { tabOrder = 1, x = menu.table.x, y = offsety, width = menu.table.widthExtraWide - infowidth - Helper.borderSize, maxVisibleHeight = height })
    optiontable:setColWidth(1, menu.table.arrowColumnWidth, false)
    optiontable:setColWidthPercent(2, 40)
    optiontable:setColWidthPercent(4, 13)
    optiontable:setColWidthPercent(6, 10)
    optiontable:setColWidth(7, menu.table.arrowColumnWidth, false)

    local extensions = GetExtensionList()
    menu.extensionSettings = GetAllExtensionSettings()

    local addline = false
    if IsSteamworksEnabled() then
        addline = true

        local row = optiontable:addRow("globalsync", {  })
        row[2]:createText(ReadText(1001, 4830), config.standardTextProperties)
        row[6]:createButton({  }):setText(function () local text = menu.valueExtensionGlobalSync() return text end, { fontsize = config.standardFontSize, halign = "center", color = function () local _, color = menu.valueExtensionGlobalSync() return color end })
        row[6].handlers.onClick = menu.buttonExtensionGlobalSync

        local row = optiontable:addRow("workshop", {  })
        row[2]:setColSpan(5):createText(ReadText(1001, 4831), config.standardTextProperties)
    end

    if #extensions > 0 then
        addline = true

        local row = optiontable:addRow( "defaults", {  })
        row[2]:setColSpan(6):createText(ReadText(1001, 2647), config.standardTextProperties)
        if menu.preselectOption == "defaults" then
            optiontable:setSelectedRow(row.index)
        end
    end

    if addline then
        local row = optiontable:addRow(false, {  })
        row[2]:setColSpan(6):createText(" ", { fontsize = 1, height = Helper.borderSize, cellBGColor = Color["row_separator"] })
    end

    local row = optiontable:addRow("uisecurity", {  })
    row[2]:createText(ReadText(1001, 12723), config.standardTextProperties)
    row[2].properties.mouseOverText = ReadText(1001, 12725)
    row[6]:createButton({ mouseOverText = ReadText(1001, 12725) }):setText(function () return GetUISafeModeOption() and ReadText(1001, 2648) or ReadText(1001, 2649) end, { fontsize = config.standardFontSize, halign = "center" })
    row[6].handlers.onClick = menu.buttonExtensionUISecurityMode

    local row = optiontable:addRow(false, {  })
    row[2]:setColSpan(6):createText(" ", { fontsize = 1, height = Helper.borderSize, cellBGColor = Color["row_separator"] })

    row = optiontable:addRow(false, {  })
    row[2]:createText(ReadText(1001, 8999), config.subHeaderLeftTextProperties)
    row[3]:createText(ReadText(1001, 4823), config.subHeaderLeftTextProperties)
    row[4]:createText(ReadText(1001, 2655), config.subHeaderLeftTextProperties)
    row[5]:createText(ReadText(1001, 2691), config.subHeaderLeftTextProperties)
    if #extensions > 0 then
        table.sort(extensions, menu.extensionSorter)
        local lastextensiongroup
        for _, extension in ipairs(extensions) do
            local extensiongroup = menu.getExtensionGroup(extension)
            if lastextensiongroup and extensiongroup ~= lastextensiongroup then
                -- add separators between extension groups
                row = optiontable:addRow(false, {  })
                row[2]:setColSpan(6):createText(" ", { fontsize = 1, height = Helper.borderSize, cellBGColor = Color["row_separator"] })
            end
            menu.displayExtensionRow(optiontable, extension, menu.extensionSettings[extension.index])
            lastextensiongroup = extensiongroup
        end
    else
        local row = optiontable:addRow(false, {  })
        row[2]:setColSpan(2):createText(ReadText(1001, 2693), config.disabledTextProperties)
    end

    optiontable:setTopRow(menu.preselectTopRow)
    menu.preselectTopRow = nil
    menu.preselectOption = nil

    local offsetx = menu.table.x + menu.table.widthExtraWide - infowidth
    local infotable = frame:addTable(1, { tabOrder = 0, x = offsetx, y = offsety, width = infowidth, maxVisibleHeight = height })

    local row = infotable:addRow(false, { bgColor = Color["optionsmenu_cell_background"] })
    row[1]:createText(menu.descriptionExtension, { scaling = false, width = infowidth, height = height, wordwrap = true, fontsize = Helper.scaleFont(config.font, config.infoFontSize) })

    titletable.properties.nextTable = optiontable.index
    optiontable.properties.prevTable = titletable.index

    frame:display()
end

function ModLua.displayExtensionRow(ftable, extension, extensionSetting)
    local row = ftable:addRow(extension, {  })
    if extension.id == menu.preselectOption then
        ftable:setSelectedRow(row.index)
    end

    local textcolor = Color["text_normal"]
    if extension.error and extension.enabled then
        textcolor = Color["text_error"]
    elseif extension.warning then
        textcolor = Color["text_warning"]

    -- kuertee start: gray disabled extensions
    elseif not extension.enabled then
        textcolor = Helper.color.grey
    -- kuertee end

    end

    row[2]:createText(extension.name, config.standardTextProperties)
    row[2].properties.color = textcolor
    row[3]:createText(extension.id, config.standardTextProperties)
    row[4]:createText(extension.version, config.standardTextProperties)
    row[4].properties.halign = "right"
    row[5]:createText(extension.date, config.standardTextProperties)
    row[5].properties.halign = "right"
    row[6]:createButton({ }):setText(function() return menu.valueExtensionStatus(extension) end, { fontsize = config.standardFontSize, halign = "center", color = function () local _, color = menu.valueExtensionStatus(extension); return color end })
    row[6].handlers.onClick = function () return menu.callbackExtensionSettingEnabled(extension) end
    row[7]:createButton({ }):setText("...", { fontsize = config.standardFontSize, halign = "center" })
    row[7].handlers.onClick = function () menu.selectedExtension = extension; menu.openSubmenu("extensionsettings", extension.id) end
end

function ModLua.displaySavegameOptions(optionParameter)
    -- remove old data
    Helper.clearDataForRefresh(menu, config.optionsLayer)
    menu.selectedOption = nil

    menu.currentOption = optionParameter
    local options = config.optionDefinitions[optionParameter]

    while not C.IsSaveListLoadingComplete() do
        -- wait until loading the savegame list is complete
    end
    menu.savegames = GetSaveList(Helper.validSaveFilenames)

    -- kuertee start: callback
    if menu.uix_callbacks ["displaySavegameOptions_onGetSaveGames"] then
        for uix_id, uix_callback in pairs (menu.uix_callbacks ["displaySavegameOptions_onGetSaveGames"]) do
            uix_callback(optionParameter)
        end
    end
    -- kuertee end: callback

    menu.onlinesave = nil
    for _, save in ipairs(menu.savegames) do
        if save.isonline and (save.filename == "online_save") then
            menu.onlinesave = save
            break
        end
    end
    if next(menu.savegames) then

        -- table.sort(menu.savegames, function (a, b) return a.rawtime > b.rawtime end)
        -- kuertee start: callback
        if menu.uix_callbacks ["displaySaveGameOptions_sortSaveGames"] then
            for uix_id, uix_callback in pairs (menu.uix_callbacks ["displaySaveGameOptions_sortSaveGames"]) do
                uix_callback(menu.savegames, "rawtime", true)
            end
        else
            table.sort(menu.savegames, function (a, b) return a.rawtime > b.rawtime end)
        end
        -- kuertee end: callback

    end

    local usedsavegamenames = {}
    local autosaves = {}
    local customsaves = {}
    local sortablesaves = {}
    local quicksavegame
    for i, savegame in ipairs(menu.savegames) do
        savegame.displayedname = menu.getExplicitSavegameName(savegame) or savegame.location
        if savegame.filename == "quicksave" then
            savegame.displayedname = ((savegame.description ~= "") and savegame.description or savegame.location) .. " (" .. ReadText(1001, 400) .. ")"
            quicksavegame = i
            if menu.currentOption == "load" then
                table.insert(sortablesaves, savegame)
            end
        elseif string.find(savegame.filename, "autosave_", 1, true) == 1 then
            savegame.displayedname = string.format("%s (%s)", (savegame.description ~= "") and savegame.description or savegame.location, ReadText(1001, 406))
            table.insert(autosaves, savegame)
            if menu.currentOption == "load" then
                table.insert(sortablesaves, savegame)
            end
        elseif savegame.isonlinesavefilename then
            if savegame.isonline then
                if savegame ~= menu.onlinesave then
                    -- TODO: Online autosave support
                end
            end
            -- TODO: handle offline savegame on online slot?
        elseif IsCheatVersion() and string.find(savegame.filename, "customsave[_-]", 1) == 1 then
            -- allow loading savegames with custom file names
            table.insert(customsaves, savegame)
        else
            usedsavegamenames[savegame.filename] = i
            table.insert(sortablesaves, savegame)
        end
    end

    local frame = menu.createOptionsFrame(true)

    -- list
    local ftable = frame:addTable(5, { tabOrder = 1, x = menu.table.x, y = 0, width = menu.table.widthExtraWide / 2, maxVisibleHeight = menu.table.height })
    ftable:setColWidth(1, menu.table.arrowColumnWidth, false)
    ftable:setColWidth(2, 2 * Helper.scaleY(config.infoTextHeight), false)
    ftable:setColWidthPercent(4, 25)
    ftable:setColWidth(5, Helper.scaleY(config.infoTextHeight), false)

    local maxRowHeight = 0

    local isonline = Helper.isOnlineGame()
    local showonlinesave = C.IsVentureExtensionSupported() and menu.onlinesave and ((menu.currentOption == "load") or isonline) and (menu.currentOption ~= "saveoffline")

    if showonlinesave then
        local row = ftable:addRow({ titlerow = "reload2" }, { fixed = true })
        if menu.preselectOption == "reload2" then
            ftable:setSelectedRow(row.index)
        end
        row[2]:setColSpan(3):createText(ReadText(1001, 11570), config.subHeaderTextProperties)
        row[5]:createButton({ height = config.infoTextHeight, width = config.infoTextHeight }):setIcon("menu_reload", {  })
        row[5].handlers.onClick = menu.buttonReloadSaveGames

        maxRowHeight = math.max(maxRowHeight, menu.addSavegameRow(ftable, menu.onlinesave, menu.onlinesave.displayedname))

        local row = ftable:addRow(nil, {  })
        row[2]:setColSpan(3):setBackgroundColSpan(4):createText(ReadText(1001, 11711), config.subHeaderTextProperties)
        row[5]:createText(" ", config.subHeaderTextProperties)
    end

    local nameSortButton
    if isonline and (menu.currentOption == "save") and (not menu.showofflinesaves) then
        local row = ftable:addRow({ submenu = "saveoffline" }, {  })
        if menu.preselectOption == "saveoffline" then
            ftable:setSelectedRow(row.index)
        end
        row[2]:setColSpan(4):createText(ReadText(1001, 11713), config.standardTextProperties)
    else
        -- reload
        local arrowWidth = Helper.scaleY(config.infoTextHeight)
        local row = ftable:addRow({ titlerow = "reload" }, { fixed = not showonlinesave })
        if menu.preselectOption == "reload" then
            ftable:setSelectedRow(row.index)
        end
        row[2]:createButton({ height = config.infoTextHeight }):setIcon((menu.saveSort == "slot_inv") and "table_arrow_inv_up" or "table_arrow_inv_down", { scaling = false, width = arrowWidth, height = arrowWidth, x = (row[2]:getColSpanWidth() - arrowWidth) / 2, color = ((menu.saveSort == "slot") or (menu.saveSort == "slot_inv")) and Color["icon_normal"] or Color["icon_hidden"] })
        row[2].handlers.onClick = function () menu.saveSort = (menu.saveSort == "slot") and "slot_inv" or "slot"; menu.refresh() end
        nameSortButton = row[3]:createButton({ height = config.infoTextHeight }):setText(ReadText(1001, 2809)):setIcon((menu.saveSort == "name_inv") and "table_arrow_inv_up" or "table_arrow_inv_down", { scaling = false, width = arrowWidth, height = arrowWidth, x = row[3]:getColSpanWidth() + Helper.scrollbarWidth - arrowWidth, color = ((menu.saveSort == "name") or (menu.saveSort == "name_inv")) and Color["icon_normal"] or Color["icon_hidden"] })
        row[3].handlers.onClick = function () menu.saveSort = (menu.saveSort == "name") and "name_inv" or "name"; menu.refresh() end
        row[4]:setColSpan(showonlinesave and 2 or 1):createButton({ height = config.infoTextHeight }):setText(ReadText(1001, 2691)):setIcon((menu.saveSort == "date_inv") and "table_arrow_inv_up" or "table_arrow_inv_down", { scaling = false, width = arrowWidth, height = arrowWidth, x = row[4]:getColSpanWidth() - arrowWidth, color = ((menu.saveSort == "date") or (menu.saveSort == "date_inv")) and Color["icon_normal"] or Color["icon_hidden"] })
        row[4].handlers.onClick = function () menu.saveSort = (menu.saveSort == "date") and "date_inv" or "date"; menu.refresh() end
        if not showonlinesave then
            row[5]:createButton({ height = config.infoTextHeight, width = config.infoTextHeight }):setIcon("menu_reload", {  })
            row[5].handlers.onClick = menu.buttonReloadSaveGames
        end
        maxRowHeight = math.max(maxRowHeight, row:getHeight())

        if (menu.saveSort == "slot") or (menu.saveSort == "slot_inv") then
            if menu.currentOption == "load" then
                if quicksavegame then
                    local savegame = menu.savegames[quicksavegame]
                    maxRowHeight = math.max(maxRowHeight, menu.addSavegameRow(ftable, savegame, savegame.displayedname))
                end
                if #autosaves > 0 then
                    table.sort(autosaves, function (a, b) return a.rawtime > b.rawtime end)
                    for i, savegame in ipairs(autosaves) do
                        if i <= 3 then
                            maxRowHeight = math.max(maxRowHeight, menu.addSavegameRow(ftable, savegame, savegame.displayedname))
                        end
                    end
                end
            end

            -- kuertee start: more save games
            -- local startIdx = (menu.saveSort == "slot_inv") and 10 or 1
            -- local endIdx = (menu.saveSort == "slot_inv") and 1 or 10
            -- local direction = (menu.saveSort == "slot_inv") and -1 or 1
            local startIdx = (menu.saveSort == "slot_inv") and Helper.maxSaveFiles or 1
            local endIdx = (menu.saveSort == "slot_inv") and 1 or Helper.maxSaveFiles
            local direction = (menu.saveSort == "slot_inv") and -1 or 1
            -- kuertee end: more save games

            for i = startIdx, endIdx, direction do
                local savegamestring = string.format("%03d", i)
                if usedsavegamenames["save_" .. savegamestring] then
                    local savegame = menu.savegames[usedsavegamenames["save_" .. savegamestring]]
                    maxRowHeight = math.max(maxRowHeight, menu.addSavegameRow(ftable, savegame, savegame.displayedname, i))
                else

                    -- kuertee start: callback
                    local isShowUnusedSaveFile = true
                    if menu.uix_callbacks ["displaySavegameOptions_isShowUnusedSaveGame"] then
                        for uix_id, uix_callback in pairs (menu.uix_callbacks ["displaySavegameOptions_isShowUnusedSaveGame"]) do
                            isShowUnusedSaveFile = uix_callback(i)
                            if not isShowUnusedSaveFile then
                                goto continue
                            end
                        end
                    end
                    -- kuertee end: callback

                    local row = ftable:addRow({ empty = savegamestring }, {  })
                    if string.format("save_%03d", i) == menu.preselectOption then
                        ftable:setSelectedRow(row.index)
                        menu.selectedOption = { empty = savegamestring }
                    end
                    row[2]:createText(i, ((menu.currentOption == "save") or (menu.currentOption == "saveoffline")) and config.standardTextProperties or config.disabledTextProperties)
                    row[2].properties.halign = "right"
                    row[3]:setColSpan(3):createText(ReadText(1001, 4812), { scaling = false, font = config.font, fontsize = Helper.scaleFont(config.font, config.standardFontSize), x = Helper.scaleX(config.standardTextOffsetX), y = Helper.scaleY(2), color = (menu.currentOption == "load") and Color["text_inactive"] or nil, minRowHeight = Helper.scaleY(config.standardTextHeight) + Helper.borderSize })
                    maxRowHeight = math.max(maxRowHeight, row:getHeight())
                end

                -- kuertee start: callback
                ::continue::
                -- kuertee end: callback
            end
        else
            if menu.saveSort == "date" then

                -- table.sort(sortablesaves, function (a, b) return a.rawtime > b.rawtime end)
                -- kuertee start: callback
                if menu.uix_callbacks ["displaySaveGameOptions_sortSaveGames"] then
                    for uix_id, uix_callback in pairs (menu.uix_callbacks ["displaySaveGameOptions_sortSaveGames"]) do
                        uix_callback(sortablesaves, "rawtime", true)
                    end
                else
                    table.sort(sortablesaves, function (a, b) return a.rawtime > b.rawtime end)
                end
                -- kuertee end: callback

            elseif menu.saveSort == "date_inv" then

                -- table.sort(sortablesaves, function (a, b) return a.rawtime < b.rawtime end)
                -- kuertee start: callback
                if menu.uix_callbacks ["displaySaveGameOptions_sortSaveGames"] then
                    for uix_id, uix_callback in pairs (menu.uix_callbacks ["displaySaveGameOptions_sortSaveGames"]) do
                        uix_callback(sortablesaves, "rawtime", false)
                    end
                else
                    table.sort(sortablesaves, function (a, b) return a.rawtime < b.rawtime end)
                end
                -- kuertee end: callback

            elseif menu.saveSort == "name" then

                -- table.sort(sortablesaves, function (a, b) return a.displayedname < b.displayedname end)
                -- kuertee start: callback
                if menu.uix_callbacks ["displaySaveGameOptions_sortSaveGames"] then
                    for uix_id, uix_callback in pairs (menu.uix_callbacks ["displaySaveGameOptions_sortSaveGames"]) do
                        uix_callback(sortablesaves, "displayedname", true)
                    end
                else
                    table.sort(sortablesaves, function (a, b) return a.displayedname < b.displayedname end)
                end
                -- kuertee end: callback

            elseif menu.saveSort == "name_inv" then

                -- table.sort(sortablesaves, function (a, b) return a.displayedname > b.displayedname end)
                -- kuertee start: callback
                if menu.uix_callbacks ["displaySaveGameOptions_sortSaveGames"] then
                    for uix_id, uix_callback in pairs (menu.uix_callbacks ["displaySaveGameOptions_sortSaveGames"]) do
                        uix_callback(sortablesaves, "displayedname", false)
                    end
                else
                    table.sort(sortablesaves, function (a, b) return a.displayedname < b.displayedname end)
                end
                -- kuertee end: callback
            end
            for i, savegame in ipairs(sortablesaves) do
                -- kuertee start: callback
                if menu.uix_callbacks ["displaySaveGameOptions_preSaveGameRowAdd"] then
                    if next(menu.uix_callbacks["displaySaveGameOptions_preSaveGameRowAdd"]) and (not menu.uix_isWarn_displaySaveGameOptions_preSaveGameRowAdd) then
                        menu.uix_isWarn_displaySaveGameOptions_preSaveGameRowAdd = true
                        Helper.debugText_forced("NOTE: gameoptions_uix displaySaveGameOptions_preSaveGameRowAdd call back is obsolete.")
                        Helper.debugText_forced("Use addSavegameRow_preSaveGameRowAdd.")
                        Helper.debugText_forced("displaySaveGameOptions_preSaveGameRowAdd exists only for backward-compatibility.")
                    end
                    for uix_id, uix_callback in pairs (menu.uix_callbacks ["displaySaveGameOptions_preSaveGameRowAdd"]) do
                        maxRowHeight = math.max(maxRowHeight, uix_callback(ftable, savegame, savegame.displayedname, i, #sortablesaves, config))
                    end
                end
                -- kuertee end: callback

                local idx = tonumber(string.match(savegame.filename, "^save_(%d+)"))
                maxRowHeight = math.max(maxRowHeight, menu.addSavegameRow(ftable, savegame, savegame.displayedname, i, #sortablesaves))

                -- kuertee start: callback
                if menu.uix_callbacks ["displaySaveGameOptions_postSaveGameRowAdd"] then
                    if next(menu.uix_callbacks["displaySaveGameOptions_postSaveGameRowAdd"]) and (not menu.uix_isWarn_displaySaveGameOptions_postSaveGameRowAdd) then
                        menu.uix_isWarn_displaySaveGameOptions_postSaveGameRowAdd = true
                        Helper.debugText_forced("NOTE: gameoptions_uix displaySaveGameOptions_postSaveGameRowAdd call back is obsolete.")
                        Helper.debugText_forced("Use addSavegameRow_postSaveGameRowAdd.")
                        Helper.debugText_forced("displaySaveGameOptions_postSaveGameRowAdd exists only for backward-compatibility.")
                    end
                    for uix_id, uix_callback in pairs (menu.uix_callbacks ["displaySaveGameOptions_postSaveGameRowAdd"]) do
                        maxRowHeight = math.max(maxRowHeight, uix_callback(ftable, savegame, savegame.displayedname, i, #sortablesaves))
                    end
                end
                -- kuertee end: callback
            end

            -- kuertee start: more save games
            -- for i = 1, 10 do
            for i = 1, Helper.maxSaveFiles do
            -- kuertee end: more save games

                local savegamestring = string.format("%03d", i)
                if not usedsavegamenames["save_" .. savegamestring] then

                    -- kuertee start: callback
                    local isShowUnusedSaveFile = true
                    if menu.uix_callbacks ["displaySavegameOptions_isShowUnusedSaveGame"] then
                        for uix_id, uix_callback in pairs (menu.uix_callbacks ["displaySavegameOptions_isShowUnusedSaveGame"]) do
                            isShowUnusedSaveFile = uix_callback(i)
                            if not isShowUnusedSaveFile then
                                goto continue
                            end
                        end
                    end
                    -- kuertee end: callback

                    local row = ftable:addRow({ empty = savegamestring }, {  })
                    if string.format("save_%03d", i) == menu.preselectOption then
                        ftable:setSelectedRow(row.index)
                        menu.selectedOption = { empty = savegamestring }
                    end
                    row[2]:createText(i, ((menu.currentOption == "save") or (menu.currentOption == "saveoffline")) and config.standardTextProperties or config.disabledTextProperties)
                    row[2].properties.halign = "right"
                    row[3]:setColSpan(3):createText(ReadText(1001, 4812), { scaling = false, font = config.font, fontsize = Helper.scaleFont(config.font, config.standardFontSize), x = Helper.scaleX(config.standardTextOffsetX), y = Helper.scaleY(2), color = (menu.currentOption == "load") and Color["text_inactive"] or nil, minRowHeight = Helper.scaleY(config.standardTextHeight) + Helper.borderSize })
                    maxRowHeight = math.max(maxRowHeight, row:getHeight())

                    -- kuertee start: callback
                    ::continue::
                    -- kuertee end: callback
                end
            end
        end
    end

    local customsavetitlerow
    if (menu.currentOption == "load") and (#customsaves > 0) and IsCheatVersion() then
        customsavetitlerow = ftable:addRow(nil, {  })
        customsavetitlerow[2]:setColSpan(4):createText("Custom Saves", config.subHeaderTextProperties) -- (cheat only)
        -- sort by name, but don't care whether customsave prefix is followed by _ or -
        local prefixlen = string.len("customsave_")
        if menu.saveSort == "date" then
            table.sort(customsaves, function (a, b) return a.rawtime > b.rawtime end)
        elseif menu.saveSort == "date_inv" then
            table.sort(customsaves, function (a, b) return a.rawtime < b.rawtime end)
        elseif (menu.saveSort == "name_inv") then
            table.sort(customsaves, function (a, b) return string.lower(string.sub(a.filename, prefixlen + 1)) > string.lower(string.sub(b.filename, prefixlen + 1)) end)
        else
            table.sort(customsaves, function (a, b) return string.lower(string.sub(a.filename, prefixlen + 1)) < string.lower(string.sub(b.filename, prefixlen + 1)) end)
        end
        for i, savegame in ipairs(customsaves) do
            local entry = string.format("%s - %s", string.sub(savegame.filename, prefixlen + 1), savegame.displayedname)
            savegame.displayedname = entry
            maxRowHeight = math.max(maxRowHeight, menu.addSavegameRow(ftable, savegame, entry))
        end
    end

    local titletable = frame:addTable(4, { tabOrder = 3, x = menu.table.x, y = menu.table.y, width = menu.table.widthExtraWide, maxVisibleHeight = menu.table.height, skipTabChange = true })
    titletable:setColWidth(1, menu.table.arrowColumnWidth, false)
    titletable:setColWidth(2, ftable.properties.width - menu.table.arrowColumnWidth - Helper.scaleY(config.infoTextHeight) - 2 * Helper.borderSize, false)
    titletable:setColWidth(3, Helper.scaleY(config.infoTextHeight), false)

    -- title
    local row = titletable:addRow({ titlerow = "title" }, { fixed = true })
    if menu.preselectOption == "title" then
        titletable:setSelectedRow(row.index)
    end
    row[1]:setBackgroundColSpan(4):createButton({ height = config.headerTextHeight }):setIcon(config.backarrow, { x = config.backarrowOffsetX })
    row[1].handlers.onClick = function () return menu.onCloseElement("back") end
    row[2]:setColSpan(3):createText(options.name, config.headerTextProperties)

    local offsety = titletable.properties.y + titletable:getFullHeight() + Helper.borderSize
    ftable.properties.y = offsety
    ftable.properties.maxVisibleHeight = math.max(menu.table.height - offsety, maxRowHeight + Helper.borderSize + (customsavetitlerow and (customsavetitlerow:getHeight() + Helper.borderSize) or 0))
    if ftable:hasScrollBar() then
        if (not isonline) or (menu.currentOption ~= "save") then
            nameSortButton.properties.icon.x = nameSortButton.properties.icon.x - Helper.scrollbarWidth
        end
    end

    ftable:setTopRow(menu.preselectTopRow)
    menu.preselectTopRow = nil
    menu.preselectOption = nil

    titletable.properties.nextTable = ftable.index
    ftable.properties.prevTable = titletable.index

    -- infos
    local buttontable = frame:addTable(4, { tabOrder = 2, x = menu.table.x + ftable.properties.width + Helper.borderSize, y = offsety, width = ftable.properties.width - Helper.borderSize, maxVisibleHeight = menu.table.height - offsety, highlightMode = "off" })
    buttontable:setColWidthPercent(2, 16)
    buttontable:setColWidthPercent(3, 16)
    local row = buttontable:addRow(nil, {  })
    row[1]:setColSpan(4):createText(" ")
    -- save name
    local row = buttontable:addRow((menu.currentOption == "save") or (menu.currentOption == "saveoffline"), {  })
    row[1]:setColSpan(2):createText(ReadText(1001, 8970) .. ReadText(1001, 120))
    if (menu.currentOption == "save") or (menu.currentOption == "saveoffline") then
        menu.saveNameEditBox = row[3]:setColSpan(2):createEditBox({ height = config.standardTextHeight, description = ReadText(1001, 8970), active = function () return (menu.selectedOption ~= nil) and (next(menu.selectedOption) ~= nil) and (not menu.selectedOption.isonline) end }):setText(menu.savegameName, { fontsize = config.standardFontSize, halign = "right" }):setHotkey("INPUT_STATE_DETAILMONITOR_Y", { displayIcon = true, x = 0 })
        row[3].handlers.onEditBoxActivated = function (widget) menu.noupdate = true end
        row[3].handlers.onEditBoxDeactivated = function (_, text, textchanged) menu.noupdate = nil end
        row[3].handlers.onTextChanged = menu.editboxSaveName
    else
        row[3]:setColSpan(2):createText(function () return ((menu.selectedOption ~= nil) and (next(menu.selectedOption) ~= nil)) and menu.selectedOption.displayedname or "" end, config.standardRightTextProperties)
    end
    local inforows = {}
    -- player name
    local row = buttontable:addRow(nil, {  })
    table.insert(inforows, row)
    row[1]:setColSpan(2):createText(ReadText(1001, 2809) .. ReadText(1001, 120))
    row[3]:setColSpan(2):createText(function () return ((menu.selectedOption ~= nil) and (next(menu.selectedOption) ~= nil)) and menu.selectedOption.playername or "" end, config.standardRightTextProperties)
    -- money
    local row = buttontable:addRow(nil, {  })
    table.insert(inforows, row)
    row[1]:setColSpan(2):createText(ReadText(1001, 2003) .. ReadText(1001, 120))
    row[3]:setColSpan(2):createText(function () return ((menu.selectedOption ~= nil) and (next(menu.selectedOption) ~= nil) and menu.selectedOption.playername) and (ConvertMoneyString(menu.selectedOption.money, false, true, 0, true, false).. " " .. ReadText(1001, 101)) or "" end, config.standardRightTextProperties)
    -- location
    local row = buttontable:addRow(nil, {  })
    table.insert(inforows, row)
    row[1]:setColSpan(2):createText(ReadText(1001, 2943) .. ReadText(1001, 120))
    row[3]:setColSpan(2):createText(function () return ((menu.selectedOption ~= nil) and (next(menu.selectedOption) ~= nil) and menu.selectedOption.playername) and menu.selectedOption.location or "" end, config.standardRightTextProperties)
    -- game time
    local row = buttontable:addRow(nil, {  })
    table.insert(inforows, row)
    row[1]:setColSpan(2):createText(ReadText(1001, 8969) .. ReadText(1001, 120))
    row[3]:setColSpan(2):createText(function () return ((menu.selectedOption ~= nil) and (next(menu.selectedOption) ~= nil) and menu.selectedOption.playername) and ConvertTimeString(menu.selectedOption.playtime, "%d" .. ReadText(1001, 104) .. " %H" .. ReadText(1001, 102) .. " %M" .. ReadText(1001, 103)) or "" end, config.standardRightTextProperties)
    -- version
    local row = buttontable:addRow(nil, {  })
    table.insert(inforows, row)
    row[1]:setColSpan(2):createText(ReadText(1001, 2655) .. ReadText(1001, 120))
    row[3]:setColSpan(2):createText(menu.savegameInfoVersion, config.standardRightTextProperties)
    -- gamestart
    local row = buttontable:addRow(nil, {  })
    table.insert(inforows, row)
    row[1]:setColSpan(2):createText(ReadText(1001, 8988) .. ReadText(1001, 120))
    row[3]:setColSpan(2):createText(function () return ((menu.selectedOption ~= nil) and (next(menu.selectedOption) ~= nil) and menu.selectedOption.gamestart) and menu.selectedOption.gamestart or "" end, config.standardRightTextProperties)
    -- errors
    local row = buttontable:addRow(nil, {  })
    table.insert(inforows, row)
    row[1]:setColSpan(4):createText(menu.errorSavegameInfo(), { color = (menu.currentOption == "load") and Color["text_error"] or Color["text_warning"], wordwrap = true })
    -- buttons
    local row = buttontable:addRow(true, {  })
    if menu.currentOption == "load" then
        row[1]:createButton({ bgColor = function () return menu.isValidSaveSelected() and Color["button_background_default"] or Color["button_background_inactive"] end, highlightColor = function () return menu.isValidSaveSelected() and Color["button_highlight_default"] or Color["button_highlight_inactive"] end }):setText(ReadText(1001, 8966), { halign = "center", color = function () return menu.isValidSaveSelected() and Color["text_normal"] or Color["text_inactive"] end })
        row[1].handlers.onClick = function () if menu.isValidSaveSelected() then menu.loadGameCallback(menu.selectedOption.filename, false) end end
    else
        row[1]:createButton({ active = function () return (menu.selectedOption ~= nil) and (next(menu.selectedOption) ~= nil) and (menu.selectedOption.titlerow == nil) and (menu.selectedOption.submenu == nil) end }):setText(function () local isempty = menu.selectedOption and menu.selectedOption.empty; local isonlinesave = menu.selectedOption and menu.selectedOption.isonline; return (Helper.isOnlineGame() and (not isonlinesave)) and (isempty and ReadText(1001, 11701) or ReadText(1001, 11702)) or (isempty and ReadText(1001, 8967) or ReadText(1001, 8968)) end, { halign = "center" })
        row[1].handlers.onClick = menu.buttonOverwriteSave
    end
    row[4]:createButton({ active = function () return (menu.selectedOption ~= nil) and (next(menu.selectedOption) ~= nil) and (menu.selectedOption.titlerow == nil) and (menu.selectedOption.submenu == nil) and (not menu.selectedOption.empty) end }):setText(ReadText(1001, 8931), { halign = "center" }):setHotkey("INPUT_STATE_DETAILMONITOR_X", { displayIcon = true })
    row[4].handlers.onClick = menu.buttonDeleteSave

    if buttontable:hasScrollBar() then
        buttontable.properties.highlightMode = "grey"
        for _, row in ipairs(inforows) do
            row.rowdata = true
        end
    end

    ftable.properties.nextHorizontalTable = buttontable.index
    buttontable.properties.prevHorizontalTable = ftable.index

    frame:display()
end

function ModLua.onUpdate()
    local curtime = getElapsedTime()

    -- kuertee start: callback
    if menu.uix_callbacks ["onUpdate_start"] then
        for uix_id, uix_callback in pairs (menu.uix_callbacks ["onUpdate_start"]) do
            uix_callback(curtime)
        end
    end
    -- kuertee end: callback

    if menu.animationDelay ~= nil then
        if (not menu.animationDelay[3]) and (curtime > menu.animationDelay[1] - menu.animationDelay[4]) then
            menu.animationDelay[3] = true
            C.FadeScreen2(menu.animationDelay[4], 0, menu.animationDelay[5] or 0)
            C.StopVoiceSequence()
            if menu.isStartmenu then
                C.StartStartMenuBGMusic()
            end
        end
        if curtime > menu.animationDelay[1] then
            if menu.currentOption == "multiplayer_server" then
                C.NewMultiplayerGame(menu.animationDelay[2].id)
            else

                -- kuertee start: callback
                if menu.uix_callbacks ["newGameCallback_preNewGame"] then
                    for uix_id, uix_callback in pairs (menu.uix_callbacks ["newGameCallback_preNewGame"]) do
                        uix_callback(menu.animationDelay[2].id)
                    end
                end
                -- kuertee end: callback

                NewGame(menu.animationDelay[2].id)
            end
            menu.closeMenu("close")
        end
    elseif C.IsTradeShowVersion() and (menu.currentOption ~= "idle") and (menu.idleTimer + config.idleTime < curtime) then
        if menu.isStartmenu then
            menu.openSubmenu("idle", menu.selectedOption.id)
        end
    else
        if (not menu.noupdate) and menu.delayedRefresh and (menu.delayedRefresh < curtime) then
            menu.delayedRefresh = nil
            if menu.currentOption ~= "question" then
                menu.refresh()
                return
            end
        end

        if menu.lastSaveUpdateTime + config.saveReloadInterval < curtime then
            menu.autoReloadSave = menu.nameContinue()
            menu.lastSaveUpdateTime = curtime
            menu.savegames = nil
            menu.onlinesave = nil
            C.ReloadSaveList()
            if (menu.currentOption == "save") or (menu.currentOption == "load") or (menu.currentOption == "saveoffline") then
                menu.delayedRefresh = curtime
                return
            end
        end

        local saveloadingcompleted = false
        if menu.savegames == nil then
            if C.IsSaveListLoadingComplete() then
                menu.savegames = GetSaveList(Helper.validSaveFilenames)
                menu.onlinesave = nil
                for _, save in ipairs(menu.savegames) do
                    if save.isonline and (save.filename == "online_save") then
                        menu.onlinesave = save
                        if menu.allBasicTutorialsDone then
                            break
                        end
                    end
                    if save.rawversion < 700 then
                        menu.allBasicTutorialsDone = true
                        if menu.onlinesave then
                            break
                        end
                    end
                end
                if next(menu.savegames) then

                    -- table.sort(menu.savegames, function (a, b) return a.rawtime > b.rawtime end)
                    -- kuertee start: callback
                    if menu.uix_callbacks ["displaySaveGameOptions_sortSaveGames"] then
                        for uix_id, uix_callback in pairs (menu.uix_callbacks ["displaySaveGameOptions_sortSaveGames"]) do
                            uix_callback(menu.savegames, "rawtime", true)
                        end
                    else
                        table.sort(menu.savegames, function (a, b) return a.rawtime > b.rawtime end)
                    end
                    -- kuertee end: callback

                end
                saveloadingcompleted = true
                menu.autoReloadSave = nil
            end
        end

        if (menu.currentOption == "main") or (menu.currentOption == "sandbox") then
            if saveloadingcompleted then
                -- rebuild the menu (since the current rows are simple (aka: fontstring/unselectable) rows and we cannot just reset them to selectable ones
                -- TODO: #Florian - add support to change whether a row is selectable or not and then replace rebuilding the menu here with simply adjusting the two relevant rows
                menu.preselectOption = Helper.getCurrentRowData(menu, menu.optionTable).id
                menu.submenuHandler(menu.currentOption)
                return
            end
        elseif (menu.currentOption == "new") or (menu.currentOption == "multiplayer_server") or (menu.currentOption == "new_timelines") or (menu.currentOption == "tutorials") then
            if menu.playNewGameCutscene and menu.playNewGameCutscene.movie then
                if not menu.playNewGameCutscene.cutsceneid then
                    menu.playNewGameCutscene.cutscenedesc = CreateCutsceneDescriptor(menu.playNewGameCutscene.movie, {})
                    menu.playNewGameCutscene.cutsceneid = StartCutscene(menu.playNewGameCutscene.cutscenedesc, GetRenderTargetTexture(menu.rendertarget))
                    if menu.playNewGameCutscene.movievoice ~= "" then
                        C.StartVoiceSequence2(menu.playNewGameCutscene.movievoice, 0, menu.selectedOption.id)
                    end
                end
            end
            if menu.newGameCutsceneTimer and (menu.newGameCutsceneTimer + 1 < curtime) then
                menu.newGameCutsceneTimer = nil
                if menu.selectedOption and (menu.selectedOption.cutscene ~= "") then
                    menu.playNewGameCutscene = { id = menu.selectedOption.id, movie = menu.selectedOption.cutscene, movievoice = menu.selectedOption.cutscenevoice }
                    menu.refresh()
                end
            end
        elseif menu.currentOption == "lobby" then
            if menu.updateServers then
                menu.drawLobby()
                menu.updateServers = false
            end
        elseif menu.currentOption == "online" then
            if menu.onlineRefresh then
                menu.onlineRefresh = nil
                menu.preselectTopRow = GetTopRow(menu.optionTable)
                menu.preselectOption = menu.preselectOption or Helper.currentTableRow[menu.optionTable]
                menu.displayOnlineLogin()
            end
            if menu.activatePasswordEditBox then
                SelectRow(menu.optionTable, 5)
                Helper.activateEditBox(menu.optionTable, 5, 7)
                menu.activatePasswordEditBox = nil
            end
        elseif menu.currentOption == "credits" then
            if not menu.cutsceneid then
                menu.cutscenedesc = CreateCutsceneDescriptor("credits_movie", {})
                menu.cutsceneid = StartCutscene(menu.cutscenedesc, GetRenderTargetTexture(menu.rendertarget))
                if menu.isStartmenu then
                    C.SetSceneCameraActive(false)
                    C.StopStartMenuBGMusic()
                    Unpause(true)
                end
            end
        elseif menu.currentOption == "idle" then
            if not menu.cutsceneid then
                menu.cutscenedesc = CreateCutsceneDescriptor("idle_movie", {})
                menu.cutsceneid = StartCutscene(menu.cutscenedesc, GetRenderTargetTexture(menu.rendertarget))
                C.StopStartMenuBGMusic()
            end
        elseif menu.currentOption == "question" then
            if menu.questionEditBox then
                ActivateEditBox(menu.questionEditBox.id)
                menu.questionEditBox = nil
            end
        end
        if menu.userQuestion and menu.userQuestion.timer then
            if curtime >= menu.userQuestion.timer then
                if menu.userQuestion.negCallback then
                    menu.userQuestion.negCallback()
                    menu.userQuestion = nil
                else
                    menu.onCloseElement("back")
                end
            end
        end

        if menu.remapControl and menu.remapControl.modifier then
            if menu.directInputActive and (C.IsShiftPressed() or C.IsControlPressed()) then
                menu.unregisterDirectInput()
                menu.remapControl = nil

                -- show popup
                menu.contextMenuMode = "info"
                menu.contextMenuData = { width = Helper.scaleX(400), height = Helper.scaleY(200), y = Helper.scaleY(300), infotitle = ReadText(1001, 12656), infotext = ReadText(1001, 12657) }

                menu.createContextMenu()
            end
        end

        menu.optionsFrame:update()
        if menu.contextFrame then
            menu.contextFrame:update()
        end
    end
end

function ModLua.newGameCallback(option, checked)
    if menu.playNewGameCutscene and menu.playNewGameCutscene.cutsceneid then
        StopCutscene(menu.playNewGameCutscene.cutsceneid)
        C.StopVoiceSequence()
        if menu.playNewGameCutscene.cutscenedesc then
            ReleaseCutsceneDescriptor(menu.playNewGameCutscene.cutscenedesc)
        end
        menu.playNewGameCutscene = {}
    end
    if menu.isStartmenu and (option.intro ~= "") then
        -- use non-zero holdtime to prevent the fade-out ending too early before calling NewGame(), which would result in instant fade-in
        menu.animationDelay = { getElapsedTime() + option.introlength + option.introfadeoutlength, option, false, option.introfadeoutlength, 1.0 }
        menu.displayEmptyMenu()
        C.StartIntroAnimation(option.intro)
        if option.introvoice ~= "" then
            C.StartVoiceSequence2(option.introvoice, 0, option.id)
        end
    else
        if option.customeditor then
            table.insert(menu.history, 1, { optionParameter = menu.currentOption, topRow = GetTopRow(menu.optionTable), selectedOption = option.id })
            __CORE_GAMEOPTIONS_RESTOREINFO.returnhistory = menu.history
            Helper.closeMenuAndOpenNewMenu(menu, "CustomGameMenu", { 0, 0, option.id, menu.currentOption == "multiplayer_server", option.id == "custom_creative", menu.paused ~= nil })
            menu.cleanup()
        elseif option.mapeditor then
            menu.mapEditorSettings = {
                gamestartid = option.id,
                sectors = { all = true },
            }
            menu.openSubmenu("mapeditor", option.id)
        else
            local playerinventory = GetPlayerInventory()
            local onlineitems = OnlineGetUserItems()

            -- kuertee start:
            if not onlineitems then
                onlineitems = {}
            end
            -- kuertee end

            local hasnotuploadeditems = false
            for ware, waredata in Helper.orderedPairs(playerinventory) do
                local isbraneitem, isoperationvolatile, isseasonvolatile, isventureuploadallowed = GetWareData(ware, "isbraneitem", "isoperationvolatile", "isseasonvolatile", "isventureuploadallowed")
                if isbraneitem then
                    local serveramount = 0
                    if onlineitems[ware] then
                        serveramount = onlineitems[ware].amount
                    end
                    if isventureuploadallowed and (waredata.amount > serveramount) then
                        hasnotuploadeditems = true
                        break
                    end
                end
            end

            if (not checked) and (not menu.isStartmenu) and Helper.isOnlineGame() and hasnotuploadeditems then
                table.insert(menu.history, 1, { optionParameter = menu.currentOption, topRow = GetTopRow(menu.optionTable), selectedOption = option.id })
                menu.displayUserQuestion(ReadText(1001, 2603) .. " - " .. ReadText(1001, 7720), function () return menu.newGameCallback(option, true) end, nil, nil, nil, nil, nil, ReadText(1001, 11707))
            else
                if menu.currentOption == "multiplayer_server" then
                    Helper.addDelayedOneTimeCallbackOnUpdate(function () C.NewMultiplayerGame(option.id) end, true, getElapsedTime() + 0.1)
                elseif option.tutorial then
                    local value = 1
                    if menu.isStartmenu or C.IsTutorial() then
                        value = 0
                    elseif C.IsTimelinesScenario() or (ffi.string(C.GetGameStartName()) == "x4ep1_gamestart_hub") then
                        value = 2
                    end
                    if value == 1 then
                        Helper.addDelayedOneTimeCallbackOnUpdate(function () Helper.closeMenuAndOpenNewMenu(menu, "UserQuestionMenu", { 0, 0, "starttutorial", { option.id, 1 } }); menu.cleanup() end, true, getElapsedTime() + 0.1)
                    else
                        -- kuertee start: callback
                        -- Helper.addDelayedOneTimeCallbackOnUpdate(function () C.SetUserData("tutorial_started_from", tostring(value)); NewGame(option.id) end, true, getElapsedTime() + 0.1)
                        Helper.addDelayedOneTimeCallbackOnUpdate(
                            function ()
                                C.SetUserData("tutorial_started_from", tostring(value));
                                if menu.uix_callbacks ["newGameCallback_preNewGame"] then
                                    for uix_id, uix_callback in pairs (menu.uix_callbacks ["newGameCallback_preNewGame"]) do
                                        uix_callback(option.id)
                                    end
                                end
                                NewGame(option.id)
                            end
                        , true, getElapsedTime() + 0.1)
                        -- kuertee end: callback
                    end
                else
                    -- kuertee start: callback
                    Helper.addDelayedOneTimeCallbackOnUpdate(
                        function ()
                            if menu.uix_callbacks ["newGameCallback_preNewGame"] then
                                for uix_id, uix_callback in pairs (menu.uix_callbacks ["newGameCallback_preNewGame"]) do
                                    uix_callback(option.id)
                                end
                            end
                            NewGame(option.id) 
                        end
                    , true, getElapsedTime() + 0.1)
                    -- kuertee end: callback

                end
                menu.displayInit()
            end
        end
    end
end

ModLua.rewriteFunctions()

-- kuertee end: rewrites

-- kuertee start: new funcs

function ModLua.addNewFunctions()
    menu.registerCallback = ModLua.registerCallback
    menu.deregisterCallback = ModLua.deregisterCallback
    menu.updateCallback = ModLua.updateCallback
end

menu.uix_callbackCount = 0
function ModLua.registerCallback(callbackName, callbackFunction, id)
    -- note 1: format is generally [function name]_[action]. e.g.: in kuertee_menu_transporter, "display_on_set_room_active" overrides the room's active property with the return of the callback.
    -- note 2: events have the word "_on_" followed by a PRESENT TENSE verb. e.g.: in kuertee_menu_transporter, "display_on_set_buttontable" is called after all of the rows of buttontable are set.
    -- note 3: new callbacks can be added or existing callbacks can be edited. but commit your additions/changes to the mod's GIT repository.
    -- note 4: search for the callback names to see where they are executed.
    -- note 5: if a callback requires a return value, return it in an object var. e.g. "display_on_set_room_active" requires a return of {active = true | false}.
    if menu.uix_callbacks [callbackName] == nil then
        menu.uix_callbacks [callbackName] = {}
    end
    if not menu.uix_callbacks[callbackName][id] then
        if not id then
            menu.uix_callbackCount = menu.uix_callbackCount + 1
            id = "_" .. tostring(menu.uix_callbackCount)
        end
        menu.uix_callbacks[callbackName][id] = callbackFunction
        if Helper.isDebugCallbacks then
            Helper.debugText_forced(menu.name .. " uix registerCallback: menu.uix_callbacks[" .. tostring(callbackName) .. "][" .. tostring(id) .. "]: " .. tostring(menu.uix_callbacks[callbackName][id]))
        end
    else
        Helper.debugText_forced(menu.name .. " uix registerCallback: callback at " .. callbackName .. " with id " .. tostring(id) .. " was already previously registered")
    end
end

menu.uix_isDeregisterQueued = nil
menu.uix_callbacks_toDeregister = {}
function ModLua.deregisterCallback(callbackName, callbackFunction, id)
    if not menu.uix_callbacks_toDeregister[callbackName] then
        menu.uix_callbacks_toDeregister[callbackName] = {}
    end
    if id then
        table.insert(menu.uix_callbacks_toDeregister[callbackName], id)
    else
        if menu.uix_callbacks[callbackName] then
            for id, func in pairs(menu.uix_callbacks[callbackName]) do
                if func == callbackFunction then
                    table.insert(menu.uix_callbacks_toDeregister[callbackName], id)
                end
            end
        end
    end
    if not menu.uix_isDeregisterQueued then
        menu.uix_isDeregisterQueued = true
        Helper.addDelayedOneTimeCallbackOnUpdate(ModLua.deregisterCallbacksNow, true, getElapsedTime() + 1)
    end
end

function ModLua.deregisterCallbacksNow()
    menu.uix_isDeregisterQueued = nil
    for callbackName, ids in pairs(menu.uix_callbacks_toDeregister) do
        if menu.uix_callbacks[callbackName] then
            for _, id in ipairs(ids) do
                if menu.uix_callbacks[callbackName][id] then
                    if Helper.isDebugCallbacks then
                        Helper.debugText_forced(menu.name .. " uix deregisterCallbacksNow (pre): menu.uix_callbacks[" .. tostring(callbackName) .. "][" .. tostring(id) .. "]: " .. tostring(menu.uix_callbacks[callbackName][id]))
                    end
                    menu.uix_callbacks[callbackName][id] = nil
                    if Helper.isDebugCallbacks then
                        Helper.debugText_forced(menu.name .. " uix deregisterCallbacksNow (post): menu.uix_callbacks[" .. tostring(callbackName) .. "][" .. tostring(id) .. "]: " .. tostring(menu.uix_callbacks[callbackName][id]))
                    end
                else
                    Helper.debugText_forced(menu.name .. " uix deregisterCallbacksNow: callback at " .. callbackName .. " with id " .. tostring(id) .. " doesn't exist")
                end
            end
        end
    end
    menu.uix_callbacks_toDeregister = {}
end

menu.uix_isUpdateQueued = nil
menu.uix_callbacks_toUpdate = {}
function ModLua.updateCallback(callbackName, id, callbackFunction)
    if not menu.uix_callbacks_toUpdate[callbackName] then
        menu.uix_callbacks_toUpdate[callbackName] = {}
    end
    if id then
        table.insert(menu.uix_callbacks_toUpdate[callbackName], {id = id, callbackFunction = callbackFunction})
    end
    if not menu.uix_isUpdateQueued then
        menu.uix_isUpdateQueued = true
        Helper.addDelayedOneTimeCallbackOnUpdate(ModLua.updateCallbacksNow, true, getElapsedTime() + 1)
    end
end

function ModLua.updateCallbacksNow()
    menu.uix_isUpdateQueued = nil
    for callbackName, updateDatas in pairs(menu.uix_callbacks_toUpdate) do
        if menu.uix_callbacks[callbackName] then
            for _, updateData in ipairs(updateDatas) do
                if menu.uix_callbacks[callbackName][updateData.id] then
                    if Helper.isDebugCallbacks then
                        Helper.debugText_forced(menu.name .. " uix updateCallbacksNow (pre): menu.uix_callbacks[" .. tostring(callbackName) .. "][" .. tostring(updateData.id) .. "]: " .. tostring(menu.uix_callbacks[callbackName][updateData.id]))
                    end
                    menu.uix_callbacks[callbackName][updateData.id] = updateData.callbackFunction
                    if Helper.isDebugCallbacks then
                        Helper.debugText_forced(menu.name .. " uix updateCallbacksNow (post): menu.uix_callbacks[" .. tostring(callbackName) .. "][" .. tostring(updateData.id) .. "]: " .. tostring(menu.uix_callbacks[callbackName][updateData.id]))
                    end
                else
                    Helper.debugText_forced(menu.name .. " uix updateCallbacksNow: callback at " .. callbackName .. " with id " .. tostring(id) .. " doesn't exist")
                end
            end
        end
    end
end

ModLua.addNewFunctions()

-- kuertee end: new funcs
