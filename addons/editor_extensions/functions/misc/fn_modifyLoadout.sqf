/*
 * alters player's loadout, swapping/removing/adding items in their respective
 * places of the getUnitLoadout array
 *
 * should be used from init.sqf
 */

/*
 * input: array of arrays, each with 2-4 members, first being the action
 * ie.
 *   [
 *     ["add",  "some_magazine", "vest", 10], // "uniform", "vest" or "backpack"
 *     ["swap", "old_item", "new_item"],
 *     ["del",  "some_weapon"],
 *     ["exec", { some code }]
 *   ]
 */

if (isNil "a3ee_modifyLoadout_gear") then {
    a3ee_modifyLoadout_gear = _this;
    player addEventHandler ["Respawn", {
        a3ee_modifyLoadout_gear call a3ee_fnc_modifyLoadout;
    }];
};

/* input arr: getUnitLoadout standard container format (uniform/vest/pack) */
private _add_container = {
    params ["_arr", "_item", "_cnt"];
    if (count _arr == 0) exitWith {};
    private "_toadd";
    if (isClass (configFile >> "CfgMagazines" >> _item)) then {
        _toadd = [_item, 0, _cnt];
    } else {
        _toadd = [_item, _cnt];
    };
    (_arr select 1) pushBack _toadd;
};

/* input arr: getUnitLoadout standard weapon array format */
private _swap_weapon = {
    params ["_arr", "_old", "_new"];
    if (count _arr == 0) exitWith {};
    /* weapon itself + attachments */
    for "_i" from 0 to 3 do {
        if ((_arr select _i) isEqualTo _old) then { _arr set [_i, _new] };
    };
    /* weapon mags */
    private _primag = _arr select 4;
    if ((count _primag > 0) && {(_secmag select 0) isEqualTo _old}) then { _primag set [0, _new] };
    private _secmag = _arr select 5;
    if ((count _secmag > 0) && {(_secmag select 0) isEqualTo _old}) then { _secmag set [0, _new] };
    /* weapon bipod */
    if ((_arr select 6) isEqualTo _old) then { _arr set [6, _new] };
};
/* input arr: getUnitLoadout standard container format (uniform/vest/pack) */
private _swap_container = {
    params ["_arr", "_old", "_new"];
    if (count _arr == 0) exitWith {};
    if ((_arr select 0) isEqualTo _old) then { _arr set [0, _new] };
    {
        if ((_x select 0) isEqualTo _old) then { _x set [0, _new] };
    } forEach (_arr select 1);
};

/* input arr: getUnitLoadout standard weapon array format */
private _del_weapon = {
    params ["_arr", "_item"];
    if (count _arr == 0) exitWith {};
    /* weapon itself = delete everything */
    if ((_arr select 0) isEqualTo _item) exitWith {
        while {count _arr > 0} do { _arr deleteAt 0 };  //inplace
    };
    /* attachments */
    for "_i" from 1 to 3 do {
        if ((_arr select _i) isEqualTo _item) then { _arr set [_i, ""] };
    };
    /* weapon mags */
    private _primag = _arr select 4;
    if ((count _primag > 0) && {(_primag select 0) isEqualTo _item}) then { _arr set [4, []] };
    private _secmag = _arr select 5;
    if ((count _secmag > 0) && {(_secmag select 0) isEqualTo _item}) then { _arr set [5, []] };
    /* weapon bipod */
    if ((_arr select 6) isEqualTo _item) then { _arr set [6, ""] };
};
/* input arr: getUnitLoadout standard container format (uniform/vest/pack) */
private _del_container = {
    params ["_arr", "_old", "_new"];
    if (count _arr == 0) exitWith {};
    /* container itself = delete everything */
    if ((_arr select 0) isEqualTo _item) exitWith {
        while {count _arr > 0} do { _arr deleteAt 0 };  //inplace
    };
    /* reverse, to avoid shifting counter on delete */
    private _items = _arr select 1;
    private "_i";
    for [{_i = count _items - 1}, {_i >= 0}, {_i = _i - 1}] do {
        private _name = ((_items select _i) select 0);
        if (_name isEqualTo _item) then { _items deleteAt _i };
    };
};

/* https://community.bistudio.com/wiki/Talk:getUnitLoadout */
private _gear = getUnitLoadout player;
_gear params ["_priweap", "_launcher", "_handgun", "_uniform", "_vest",
              "_backpack", "_helmet", "_facewear", "_binoc", "_linked"];
{
    switch (_x select 0) do {
        case "add": {
            _x params ["_act", "_item", "_where", "_cnt"];
            switch (_where) do {
                case "uniform": {
                    [_uniform, _item, _cnt] call _add_container;
                };
                case "vest": {
                    [_vest, _item, _cnt] call _add_container;
                };
                case "backpack": {
                    [_backpack, _item, _cnt] call _add_container;
                };
            };
        };
        case "swap": {
            _x params ["_act", "_old", "_new"];
            [_priweap, _old, _new] call _swap_weapon;
            [_launcher, _old, _new] call _swap_weapon;
            [_handgun, _old, _new] call _swap_weapon;
            [_uniform, _old, _new] call _swap_container;
            [_vest, _old, _new] call _swap_container;
            [_backpack, _old, _new] call _swap_container;
            if (_helmet isEqualTo _old) then { _gear set [6, _new] };
            // facewear not supported
            [_binoc, _old, _new] call _swap_weapon;
            for "_i" from 0 to (count _linked - 1) do {
                private _item = _linked select _i;
                if ((_item isEqualTo _old)) then { _linked set [_i, _new] };
            };
        };
        case "del": {
            _x params ["_act", "_item"];
            [_priweap, _item] call _del_weapon;
            [_launcher, _item] call _del_weapon;
            [_handgun, _item] call _del_weapon;
            [_uniform, _item] call _del_container;
            [_vest, _item] call _del_container;
            [_backpack, _item] call _del_container;
            if (_helmet isEqualTo _item) then { _gear set [6, ""] };
            // facewear not supported
            [_binoc, _item] call _del_weapon;
            for "_i" from 0 to (count _linked - 1) do {
                private _name = _linked select _i;
                if ((_item isEqualTo _name)) then { _linked set [_i, ""] };
            };
        };
        case "exec": {
            _x params ["_act", "_code"];
            player call _code;
        };
    };
} forEach _this;
player setUnitLoadout [_gear, true];
