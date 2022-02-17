local util = require("__logistics-pipes__/api").util
local resistances = data.raw["wall"]["stone-wall"].resistances
local IpixelShift = (util.by_pixel(0,1))[2]
data:extend({
    {
        type="accumulator",
        name="logistics-power-junction",
        icon="__logistics-pipes__/graphics/icons/misc/power-junction.png",
        icon_size=64,
        localised_name="logistics power junction",
        localised_description="provides power for the logistics network",
        charge_cooldown=5,
        discharge_cooldown=5,
        energy_source={
            buffer_capacity="10000000J",
            usage_priority="primary-output",
            input_flow_limit="1000000W",
            output_flow_limit="0W",
            drain="1000000W",
            render_no_power_icon=false,
        },
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
            mining_time = 0.5,
            result = "logistics-power-junction",
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
        max_health=400,
        subgroup="logistics-pipes-item-subgroup",
        picture={
            filename="__logistics-pipes__/graphics/atlases/logistics_solid_block.png",
            x=64,
            y=0,
            width=16,
            height=16,
            scale=2
        }
    },
    {
        type="accumulator",
        name="logistics-power-junction-powered",
        icon="__logistics-pipes__/graphics/icons/misc/power-junction.png",
        icon_size=64,
        localised_name="logistics power junction",
        localised_description="provides power for the logistics network",
        charge_cooldown=5,
        discharge_cooldown=5,
        energy_source={
            buffer_capacity="10000000J",
            usage_priority="primary-output",
            input_flow_limit="1000000W",
            output_flow_limit="0W",
            drain="1000000W",
            render_no_power_icon=false,
        },
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
            mining_time = 0.5,
            result = "logistics-power-junction",
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
        max_health=400,
        subgroup="logistics-pipes-item-subgroup",
        picture={
            filename="__logistics-pipes__/graphics/atlases/logistics_solid_block.png",
            x=64,
            y=16,
            width=16,
            height=16,
            scale=2
        }
    },
    {
        type="accumulator",
        name="logistics-power-junction-ignore",
        icon="__logistics-pipes__/graphics/atlases/empty.png",
        icon_size=1 ,
        localised_name="logistics power junction",
        localised_description="provides power for the logistics network",
        charge_cooldown=5,
        discharge_cooldown=5,
        energy_source={
            buffer_capacity="1000000J",
            usage_priority="primary-output",
            input_flow_limit="0W",
            output_flow_limit="0W",
            drain="0W",
            render_no_power_icon=false,
        },
        collision_mask={},
        flags={
            "not-rotatable",
            "hidden",
            "not-in-kill-statistics",
        },
        selectable_in_game=false,
        resistances=resistances,
        max_health=1,
        destructive=false,
        subgroup="logistics-pipes-item-subgroup",
        picture={
            filename="__logistics-pipes__/graphics/atlases/empty.png",
            width=1,
            height=1,
            scale=0
        }
    }
})