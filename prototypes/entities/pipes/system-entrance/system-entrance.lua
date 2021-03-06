local util = require("__logistics-pipes__/api").util
local resistances = data.raw["wall"]["stone-wall"].resistances
local IpixelShift = (util.by_pixel(0,1))[2]
data:extend({
    {
        type="wall",
        name="system-entrance-logistics-pipe",
        icon="__logistics-pipes__/graphics/icons/pipes/system-entrance.png",
        icon_size=64,
        localised_name="system-entrance logistics pipe",
        localised_description="",
        collision_box={
            {-0.29,-0.29},
            {0.29,0.29}
        },
        collision_mask={
            "item-layer",
            "object-layer",
            "water-tile"
        },
        selection_box={
            {-0.45,-0.45},
            {0.45,0.45}
        },
        minable = {
            mining_time = 0.2,
            result = "system-entrance-logistics-pipe",
            count = 1,
            mining_particle = "iron-ore-particle"
        },
        flags={
            "not-rotatable",
            "placeable-player",
            "placeable-neutral",
            "player-creation"
        },
        resistances=resistances,
        max_health=100,
        pictures={
            single={
                filename="__logistics-pipes__/graphics/pipes/system-entrance/single.png",
                width=128,
                height=128,
                scale=0.15,
            },
            straight_vertical={
                filename="__logistics-pipes__/graphics/pipes/system-entrance/straight-vertical.png",
                width=126,
                height=215,
                scale=0.15,
                shift={0,0.23}
            },
            straight_horizontal={
                filename="__logistics-pipes__/graphics/pipes/system-entrance/straight-horizontal.png",
                width=305,
                height=126,
                scale=0.15,
                shift=util.by_pixel(0,0.5)
            },
            corner_right_down={
                filename="__logistics-pipes__/graphics/pipes/system-entrance/corner-right-down.png", 
                width=214,
                height=215,
                scale=0.15,
                shift={0.21,0.23}
            },
            corner_left_down={
                filename="__logistics-pipes__/graphics/pipes/system-entrance/corner-left-down.png",
                width=214,
                height=215,
                scale=0.15,
                shift={-0.225,0.24}
            },
            t_up={
                filename="__logistics-pipes__/graphics/pipes/system-entrance/t_up.png",
                width=305,
                height=217,
                scale=0.15,
                shift={-0.02,0.25}
            },
            ending_right={
                filename="__logistics-pipes__/graphics/pipes/system-entrance/ending-left.png",
                width=215,
                height=126,
                scale=0.15,
                shift={0.25,IpixelShift}
            },
            ending_left={
                filename="__logistics-pipes__/graphics/pipes/system-entrance/ending-right.png",
                width=215,
                height=126,
                scale=0.15,
                shift={-0.24,IpixelShift}
            }
        }
    },
    {
        type="wall",
        name="system-entrance-logistics-pipe-powered",
        icon="__logistics-pipes__/graphics/icons/pipes/system-entrance.png",
        icon_size=64,
        localised_name="system-entrance logistics pipe",
        localised_description="",
        collision_box={
            {-0.29,-0.29},
            {0.29,0.29}
        },
        collision_mask={
            "item-layer",
            "object-layer",
            "water-tile"
        },
        selection_box={
            {-0.45,-0.45},
            {0.45,0.45}
        },
        minable = {
            mining_time = 0.2,
            result = "system-entrance-logistics-pipe",
            count = 1,
            mining_particle = "iron-ore-particle"
        },
        flags={
            "not-rotatable",
            "placeable-player",
            "placeable-neutral",
            "player-creation"
        },
        resistances=resistances,
        max_health=100,
        pictures={
            single={
                filename="__logistics-pipes__/graphics/pipes/system-entrance/powered/single.png",
                width=128,
                height=128,
                scale=0.15,
            },
            straight_vertical={
                filename="__logistics-pipes__/graphics/pipes/system-entrance/powered/straight-vertical.png",
                width=126,
                height=215,
                scale=0.15,
                shift={0,0.23}
            },
            straight_horizontal={
                filename="__logistics-pipes__/graphics/pipes/system-entrance/powered/straight-horizontal.png",
                width=305,
                height=126,
                scale=0.15,
                shift=util.by_pixel(0,0.5)
            },
            corner_right_down={
                filename="__logistics-pipes__/graphics/pipes/system-entrance/powered/corner-right-down.png", 
                width=214,
                height=215,
                scale=0.15,
                shift={0.21,0.23}
            },
            corner_left_down={
                filename="__logistics-pipes__/graphics/pipes/system-entrance/powered/corner-left-down.png",
                width=214,
                height=215,
                scale=0.15,
                shift={-0.225,0.24}
            },
            t_up={
                filename="__logistics-pipes__/graphics/pipes/system-entrance/powered/t_up.png",
                width=305,
                height=217,
                scale=0.15,
                shift={-0.02,0.25}
            },
            ending_right={
                filename="__logistics-pipes__/graphics/pipes/system-entrance/powered/ending-left.png",
                width=215,
                height=126,
                scale=0.15,
                shift={0.25,IpixelShift}
            },
            ending_left={
                filename="__logistics-pipes__/graphics/pipes/system-entrance/powered/ending-right.png",
                width=215,
                height=126,
                scale=0.15,
                shift={-0.24,IpixelShift}
            }
        }
    }
})