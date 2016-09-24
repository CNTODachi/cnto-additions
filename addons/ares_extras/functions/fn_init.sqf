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

[
    "AE - AI",
    "[U] Suppress (manual, ~90sec)",
    {
        params ["_pos", "_unit"];
        if (isNil "_unit" || isNull _unit) then {
            _unit = _pos;  /* use pos as dst */
        };
        /* use selected unit as a suppression destination, let user
         * mouse-drag-select suppression source(s) */
        [[_unit, {
            params ["_dst", "_units"];
            // remoteExec could break global variable suppression state lock
            _units = _units select { local _x };
            {
                [_dst, _x] call Ares_Extras_fnc_manualSuppress;
            } forEach _units;
        }], [[0,0,0],objNull]] call Ares_Extras_fnc_Selection;
        /*      ^^^^^^^^ force mouse selection */
    }
] call Ares_fnc_RegisterCustomModule;
[
    "AE - AI",
    "[U] Suppress (bis, ~90sec)",
    {
        params ["_pos", "_unit"];
        if (isNil "_unit" || isNull _unit) then {
            _unit = _pos;  /* use pos as dst */
        };
        [[_unit, {
            params ["_dst", "_units"];
            {
                [_dst, _x] remoteExec ["Ares_Extras_fnc_bisSuppress", _dst];
            } forEach _units;
        }], [[0,0,0],objNull]] call Ares_Extras_fnc_Selection;
    }
] call Ares_fnc_RegisterCustomModule;
[
    "AE - AI",
    "[U] Suppress (bis)",
    {
        params ["_pos", "_unit"];
        if (isNil "_unit" || isNull _unit) then {
            _unit = _pos;  /* use pos as dst */
        };
        [[_unit, {
            params ["_dst", "_units"];
            {
                [_dst, _x, 0, 0] remoteExec ["Ares_Extras_fnc_bisSuppress", _dst];
            } forEach _units;
        }], [[0,0,0],objNull]] call Ares_Extras_fnc_Selection;
    }
] call Ares_fnc_RegisterCustomModule;

/*
 * AI Features
 */

{

[
    "AE - AI Features",
    format ["[U] %1 - Disable", _x],
    compile format [
        "[{ _this disableAI ""%1"" }, _this] call Ares_Extras_fnc_ForUnitsMP", _x
    ]
] call Ares_fnc_RegisterCustomModule;
[
    "AE - AI Features",
    format ["[U] %1 - Enable", _x],
    compile format [
        "[{ _this enableAI ""%1"" }, _this] call Ares_Extras_fnc_ForUnitsMP", _x
    ]
] call Ares_fnc_RegisterCustomModule;

} forEach ["MOVE", "ANIM", "AUTOCOMBAT", "PATH"];

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
        }] remoteExec ["call", 2];
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
        }] remoteExec ["call", 2];
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

[
    "AE - Environment",
    "End Mission - Won",
    { ["end1", true] remoteExec ["BIS_fnc_endMission"] }
] call Ares_fnc_RegisterCustomModule;
[
    "AE - Environment",
    "End Mission - Lost",
    { ["end1", false] remoteExec ["BIS_fnc_endMission"] }
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
 * Respawn
 */

[
    "AE - Respawn",
    "Move respawn",
    {
        params ["_pos", "_unit"];
        "respawn" setMarkerPos _pos;
    }
] call Ares_fnc_RegisterCustomModule;
[
    "AE - Respawn",
    "Move respawn_west",
    {
        params ["_pos", "_unit"];
        "respawn_west" setMarkerPos _pos;
    }
] call Ares_fnc_RegisterCustomModule;
[
    "AE - Respawn",
    "Move respawn_east",
    {
        params ["_pos", "_unit"];
        "respawn_east" setMarkerPos _pos;
    }
] call Ares_fnc_RegisterCustomModule;
[
    "AE - Respawn",
    "Move respawn_guerrila",
    {
        params ["_pos", "_unit"];
        "respawn_guerrila" setMarkerPos _pos;
        "respawn_guerilla" setMarkerPos _pos;
        "respawn_guerrilla" setMarkerPos _pos;
    }
] call Ares_fnc_RegisterCustomModule;
[
    "AE - Respawn",
    "Move respawn_civilian",
    {
        params ["_pos", "_unit"];
        "respawn_civilian" setMarkerPos _pos;
    }
] call Ares_fnc_RegisterCustomModule;

[
    "AE - Respawn",
    "Move JIP teleport point",
    {
        /* needs the Editor_Extensions pbo */
        params ["_pos", "_unit"];
        a3ee_teleport_on_jip_pos = _pos;
        publicVariable "a3ee_teleport_on_jip_pos";
    }
] call Ares_fnc_RegisterCustomModule;

/*
 * Util
 */

[
    "AE - Util",
    "[U] Captive - On",
    {
        [{ _this setCaptive true }, _this] call Ares_Extras_fnc_ForUnitsMP;
    }
] call Ares_fnc_RegisterCustomModule;
[
    "AE - Util",
    "[U] Captive - Off",
    {
        [{ _this setCaptive false }, _this] call Ares_Extras_fnc_ForUnitsMP;
    }
] call Ares_fnc_RegisterCustomModule;

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
        }] remoteExec ["call", 2];
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
        }] remoteExec ["call", 2];
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
            }] remoteExec ["call", 2];
        }, _this] call Ares_Extras_fnc_Selection;
    }
] call Ares_fnc_RegisterCustomModule;

[
    "AE - Util",
    "[U] Delete units (really)",
    {
        [{ deleteVehicle _this }, _this] call Ares_Extras_fnc_ForUnits;
    }
] call Ares_fnc_RegisterCustomModule;

[
    "AE - Util",
    "[G] Locality - Get",
    {
        [{
            [[clientOwner, _this], {
                params ["_client", "_groups"];
                private _owners = _groups apply { [groupOwner _x, _x] };
                /* callback to the client */
                [_owners, {
                    {
                        _x params ["_owner", "_grp"];
                        systemChat format ["%1: %2", _owner, _grp];
                    } forEach _this;
                }] remoteExec ["call", _client];
            }] remoteExec ["call", 2];
        }, _this, true] call Ares_Extras_fnc_Selection;
    }
] call Ares_fnc_RegisterCustomModule;
[
    "AE - Util",
    "[G] Locality - Set",
    {
        private _hcs = (entities "HeadlessClient_F") select { _x in allPlayers };
        if (count _hcs < 1) exitWith {
            ["No Headless Clients found."] call Ares_fnc_ShowZeusMessage;
        };
        _hcs = _hcs apply { [name _x, _x] };

        private _reply = [
            "Set locality / owner of groups", [
                "Choose new owner",
                _hcs
            ]
        ] call Ares_Extras_fnc_Dialog;
        if (isNil "_reply") exitWith {};

        [[_reply, {
            [_this, {
                params ["_newowner", "_groups"];
                _newowner = owner _newowner;  /* passed unit */
                { _x setGroupOwner _newowner; sleep 10; } forEach _groups;
            }] remoteExec ["spawn", 2];
        }], _this, true] call Ares_Extras_fnc_Selection;
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
[
    "AE - Util",
    "[U] Teleport (high alt.)",
    {
        params ["_pos", "_unit"];
        _pos = [_pos select 0, _pos select 1, 3000];
        [[_pos, {
            params ["_pos", "_units"];
            [_units, _pos] call Ares_Extras_fnc_teleport;
        }], _this] call Ares_Extras_fnc_Selection;
    }
] call Ares_fnc_RegisterCustomModule;

[
    "AE - Util",
    "Give Zeus to player",
    {
        params ["_pos", "_unit"];
        if (isNil "_unit" || isNull _unit) exitWith {
            ["No unit selected."] call Ares_fnc_ShowZeusMessage;
        };
        if (!isNull getAssignedCuratorLogic _unit) exitWith {
            ["Player already has Zeus."] call Ares_fnc_ShowZeusMessage;
        };
        [_unit, {
            if (!isNull getAssignedCuratorLogic _this) exitWith {};
            private _curator = ([_this, false] call insta_zeus_fnc_mkCurator);
            0 = [_curator, _this] spawn {
                params ["_curator", "_unit"];
                waitUntil {
                    _unit assignCurator _curator;
                    !isNull getAssignedCuratorUnit _curator;
                };
            };
        }] remoteExec ["call", 2];
    }
] call Ares_fnc_RegisterCustomModule;
