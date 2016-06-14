/*
 * register custom modules/functions in Ares
 */

/*
 * AI
 */

[
    "AE - AI",
    "[U] Allow Crew In Immobile",
    {
        [{
            (vehicle _this) allowCrewInImmobile true;
        }, _this] call Ares_Extras_fnc_ForUnits;
    }
] call Ares_fnc_RegisterCustomModule;

[
    "AE - AI",
    "[G] Force WP behaviour",
    {
        [{
            [_this, currentWaypoint _this] setWaypointForceBehaviour true;
        }, _this] call Ares_Extras_fnc_ForGroups;
    }
] call Ares_fnc_RegisterCustomModule;

[
    "AE - AI",
    "[U] Unload cargo in combat - On",
    {
        [{
            (vehicle _this) setUnloadInCombat [true, false];
        }, _this] call Ares_Extras_fnc_ForUnitsMP;
    }
] call Ares_fnc_RegisterCustomModule;
[
    "AE - AI",
    "[U] Unload cargo in combat - Off",
    {
        [{
            (vehicle _this) setUnloadInCombat [false, false];
        }, _this] call Ares_Extras_fnc_ForUnitsMP;
    }
] call Ares_fnc_RegisterCustomModule;

[
    "AE - AI",
    "[G] Fleeing - On",
    {
        [{ _this allowFleeing 1 }, _this] call Ares_Extras_fnc_ForGroupsMP;
    }
] call Ares_fnc_RegisterCustomModule;
[
    "AE - AI",
    "[G] Fleeing - Off",
    {
        [{ _this allowFleeing 0 }, _this] call Ares_Extras_fnc_ForGroupsMP;
    }
] call Ares_fnc_RegisterCustomModule;

[
    "AE - AI",
    "[U] Force vehicle lights",
    {
        [{
            private _veh = vehicle _this;
            if (!local _veh) exitWith {};
            _veh call Ares_Extras_fnc_vehLightOn;
        }, _this] call Ares_Extras_fnc_ForUnitsMP;
    }
] call Ares_fnc_RegisterCustomModule;

/*
 * Environment
 */

[
    "AE - Environment",
    "[P] Terrain Objects - Hide",
    {
        params ["_pos", "_unit"];

        private _radius = [
            "Hide terrain objects",
            "" call Ares_Extras_fnc_StdDistances
        ] call Ares_Extras_fnc_Dialog;
        if (isNil "_radius") exitWith {};

        [[_pos, _radius], {
            params ["_pos", "_radius"];
            {
                _x hideObjectGlobal true;
            } count nearestTerrainObjects [_pos, [], _radius];
        }] call Ares_Extras_fnc_execServer;
    }
] call Ares_fnc_RegisterCustomModule;
[
    "AE - Environment",
    "[P] Terrain Objects - Show",
    {
        params ["_pos", "_unit"];

        private _radius = [
            "Hide terrain objects",
            "" call Ares_Extras_fnc_StdDistances
        ] call Ares_Extras_fnc_Dialog;
        if (isNil "_radius") exitWith {};

        [[_pos, _radius], {
            params ["_pos", "_radius"];
            {
                _x hideObjectGlobal false;
            } count nearestTerrainObjects [_pos, [], _radius];
        }] call Ares_Extras_fnc_execServer;
    }
] call Ares_fnc_RegisterCustomModule;

[
    "AE - Environment",
    "[U] Align to Surface Level",
    {
        [{ [_this] call Ares_Extras_fnc_setPosAGLS }, _this]
            call Ares_Extras_fnc_ForUnitsMP;
    }
] call Ares_fnc_RegisterCustomModule;
[
    "AE - Environment",
    "[U] Align to Surface Vector",
    {
        [{ _this setVectorUp surfaceNormal position _this }, _this]
            call Ares_Extras_fnc_ForUnitsMP;
    }
] call Ares_fnc_RegisterCustomModule;

/*
 * Equipment
 */

[
    "AE - Equipment",
    "[U] Flashlights/lasers",
    {
        private _reply = [
            "Modify weapon fleshlights / lasers", [
                [
                    "Gun flashlights",
                    [["Force On","forceOn"],
                     ["Force Off","forceOff"],
                     ["Auto","AUTO"]]
                ], [
                    "Allow IR lasers",
                    [["Yes",true], ["No",false]]
                ], [
                    "Weapon attachment",
                    [["Leave unmodified",0],
                     ["Add flashlights if missing",1],
                     ["Add IR lasers if missing",2],
                     ["Force add flashlights",3],
                     ["Force add IR lasers",4],
                     ["Force none",5]]
                ], [
                    "NV Googles",
                    [["Depends on attachment",0],
                     ["Force add",1],
                     ["Force remove",2],
                     ["Leave unchanged",3]]
                ]
            ]
        ] call Ares_Extras_fnc_Dialog;
        if (isNil "_reply") exitWith {};

        [[_reply, {
            params ["_reply", "_unit"];
            _reply params ["_gunlight", "_allowir", "_attach", "_nvg"];

            private _item = "";
            switch (_attach) do {
                case 1;
                case 3: { _item = "acc_flashlight" };
                case 2;
                case 4: { _item = "acc_pointer_IR" };
            };
            switch (_attach) do {
                case 1;
                case 2: {
                    if (((primaryWeaponItems _unit) select 1) == "") then {
                         _unit addPrimaryWeaponItem _item;
                    };
                };
                case 3;
                case 4: { _unit addPrimaryWeaponItem _item };
                case 5: {
                    private _rail = (primaryWeaponItems _unit) select 1;
                    _unit removePrimaryWeaponItem _rail;
                };
            };
            /* buggy, doesn't always work - try repeating it for 3 secs */
            0 = [_unit, _gunlight, _allowir] spawn {
                params ["_unit", "_gunlight", "_allowir"];
                for "_x" from 1 to 30 do {
                    _unit enableGunLights _gunlight;
                    _unit enableIRLasers _allowir;
                    sleep 0.1;
                };
            };
            switch (_nvg) do {
                case 0: {
                    switch ((primaryWeaponItems _unit) select 1) do {
                        case "acc_flashlight": { [_unit, false] call Ares_Extras_fnc_addRemoveNVGs };
                        case "acc_pointer_IR": { [_unit, true] call Ares_Extras_fnc_addRemoveNVGs };
                    };
                };
                case 1: { [_unit, true] call Ares_Extras_fnc_addRemoveNVGs };
                case 2: { [_unit, false] call Ares_Extras_fnc_addRemoveNVGs };
            };
        }], _this] call Ares_Extras_fnc_ForUnitsMP;
    }
] call Ares_fnc_RegisterCustomModule;

/*
 * Util
 */

[
    "AE - Util",
    "[P] Curator - Add",
    {
        params ["_pos", "_unit"];

        private _radius = [
            "Add objects to Curator / Zeus",
            "" call Ares_Extras_fnc_StdDistances
        ] call Ares_Extras_fnc_Dialog;
        if (isNil "_radius") exitWith {};

        private _toadd = (_pos nearObjects _radius)
                       + (_pos nearSupplies _radius);

        private _curator = getAssignedCuratorLogic player;
        [[_curator, _toadd], {
            params ["_curator", "_units"];
            _curator addCuratorEditableObjects [_units, true];
        }] call Ares_Extras_fnc_execServer;
    }
] call Ares_fnc_RegisterCustomModule;
[
    "AE - Util",
    "[P] Curator - Remove",
    {
        params ["_pos", "_unit"];

        private _radius = [
            "Remove objects from Curator / Zeus",
            "" call Ares_Extras_fnc_StdDistances
        ] call Ares_Extras_fnc_Dialog;
        if (isNil "_radius") exitWith {};

        private _todel = (_pos nearObjects _radius)
                       + (_pos nearSupplies _radius);

        private _curator = getAssignedCuratorLogic player;
        [[_curator, _todel], {
            params ["_curator", "_units"];
            _curator removeCuratorEditableObjects [_units, true];
        }] call Ares_Extras_fnc_execServer;
    }
] call Ares_fnc_RegisterCustomModule;
[
    "AE - Util",
    "[U] Curator - Remove",
    {
        [{
            private _curator = getAssignedCuratorLogic player;
            [[_curator, _this], {
                params ["_curator", "_units"];
                _curator removeCuratorEditableObjects [_units, true];
            }] call Ares_Extras_fnc_execServer;
        }, _this] call Ares_Extras_fnc_Selection;
    }
] call Ares_fnc_RegisterCustomModule;

[
    "AE - Util",
    "[U] Immortal - On",
    {
        [{ _this allowDamage false }, _this] call Ares_Extras_fnc_ForUnitsMP;
    }
] call Ares_fnc_RegisterCustomModule;
[
    "AE - Util",
    "[U] Immortal - Off",
    {
        [{ _this allowDamage true }, _this] call Ares_Extras_fnc_ForUnitsMP;
    }
] call Ares_fnc_RegisterCustomModule;

[
    "AE - Util",
    "[U] Reset anim state",
    {
        [{ _this switchMove "" }, _this, 0] call Ares_Extras_fnc_ForUnitsMP;
    }
] call Ares_fnc_RegisterCustomModule;

[
    "AE - Util",
    "[U] Simulation - On",
    {
        [{ _this enableSimulationGlobal true }, _this, 2]
            call Ares_Extras_fnc_ForUnitsMP;
    }
] call Ares_fnc_RegisterCustomModule;
[
    "AE - Util",
    "[U] Simulation - Off",
    {
        [{ _this enableSimulationGlobal false }, _this, 2]
            call Ares_Extras_fnc_ForUnitsMP;
    }
] call Ares_fnc_RegisterCustomModule;

[
    "AE - Util",
    "[U] Teleport",
    {
        params ["_pos", "_unit"];
        [[_pos, {
            params ["_pos", "_units"];
            [_units, _pos] call Ares_Extras_fnc_teleport;
        }], _this] call Ares_Extras_fnc_Selection;
    }
] call Ares_fnc_RegisterCustomModule;