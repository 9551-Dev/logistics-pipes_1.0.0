local buttons = {}
buttons.empty = {
    type="sprite",
    x=0,
    y=0,
    width=35,
    height=20
}
buttons.empty_hover = {
    type="sprite",
    x=20,
    y=0,
    width=35,
    height=20
}
buttons.yes = {
    type="sprite",
    x=35,
    y=0,
    width=35,
    height=20
}
buttons.yes_hover = {
    type="sprite",
    x=35,
    y=20,
    width=35,
    height=20
}
buttons.no = {
    type="sprite",
    x=70,
    y=0,
    width=35,
    height=20
}
buttons.no_hover = {
    type="sprite",
    x=70,
    y=20,
    width=35,
    height=20
}

local chassis = {}
chassis.mk1 = {
    type="sprite",
    x=0,
    y=0,
    width=195,
    height=99,
}
chassis.mk2 = {
    type="sprite",
    x=0,
    y=99,
    width=195,
    height=99,
}
chassis.mk3 = {
    type="sprite",
    x=0,
    y=198,
    width=195,
    height=99,
}
chassis.mk4 = {
    type="sprite",
    x=0,
    y=297,
    width=195,
    height=99,
}
chassis.mk5 = {
    type="sprite",
    x=195,
    y=0,
    width=195,
    height=176,
}

local checkmark
checkmark.off = {
    type="sprite",
    x=0,
    y=0,
    width=10,
    height=10,
}
checkmark.off_hover = {
    type="sprite",
    x=10,
    y=0,
    width=10,
    height=10,
}
checkmark.on = {
    type="sprite",
    x=0,
    y=10,
    width=14,
    height=12,
}
checkmark.on_hover = {
    type="sprite",
    x=14,
    y=10,
    width=14,
    height=12,
}

local GUI_simple = {
    crafting={
        type="sprite",
        x=0,
        y=0,
        width=195,
        height=99
    },
    extractor={
        type="sprite",
        x=0,
        y=0,
        width=159,
        height=199
    },
    filter={
        type="sprite",
        x=0,
        y=0,
        width=180,
        height=66
    },
    item_sink={
        type="sprite",
        x=0,
        y=0,
        width=176,
        height=62,
    },
    power_junction={
        type="sprite",
        x=0,
        y=0,
        width=174,
        height=80
    },
    satelite={
        type="sprite",
        x=0,
        y=0,
        width=117,
        height=71
    },
    supplier={
        type="sprite"
    }
}

local GUI_elements = {
    slots={
        small={
            type="sprite",
            x=44,
            y=0,
            width=8,
            height=8
        },
        medium={
            type="sprite",
            x=26,
            y=0,
            width=18,
            height=18
        },
        large={
            type="sprite",
            x=0,
            y=0,
            width=26,
            height=26
        }
    },
    gui_background={
        type="sprite",
        x=0,
        y=0,
        width=45,
        height=45
    },
    junction_bar={
        type="sprite",
        x=176,
        y=0,
        width=5,
        height=59
    },
    minecraft_flame={},
    solder_procces={}
}

local soldering_station = {}

data:extend({

})