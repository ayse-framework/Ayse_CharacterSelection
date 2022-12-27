config = {
    changeCharacterCommand = "changecharacter",
    enableAppearance = true,

    backgrounds = {
        "https://wallpaperaccess.com/full/2020799.jpg"
    },

    departments = {
        ["Civilian"] = {"1029724677632954420"},
        ["Police Officer"] = {"1047385777560096860"},
        ["Doctor/EMS"] = {"1047417998622859344"},
        ["Mechanic"] = {"1047418123525029898"}
    },

    departmentPaychecks = true,
    paycheckInterval = 24,
    departmentSalaries = {
        ["Civilian"] = 200,
        ["Police Officer"] = 400,
        ["Doctor/EMS"] = 400,
        ["Mechanic"] = 400
    },

    spawns = {
        ["DEFAULT"] = {
            {x = -1037.7343, y = -2738.0723, z = 20.1693, name = "Airport"},
            {x = -747.2906, y = -1305.2629, z = 5.0004, name = "Harbour"}
        },
        ["Police Officer"] = {
            {x = 432.6136, y = -981.9318, z = 30.7116, name = "Mission Row PD"}
        },
        ["Doctor/EMS"] = {
            {x = 296.5099, y = -591.5170, z = 43.2765, name = "Pillbox Hospital"}
        },
        ["Mechanic"] = {
            {x = -200.0984, y = -1309.7445, z = 31.2947, name = "Benny's MotorWorks"}
        }
    }
}
