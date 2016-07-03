/* create a new Curator instance, with all addons allowed, returning it */

if (!isServer) exitWith {};

/*
 * While the Curator doesn't require any client-side configuration and once
 * assigned, it Just Works for the assigned client, there are some nice features
 * and keybinds people know from BIS configuration of Curator and these need to
 * be set locally on each client that is going to use the Curator.
 *
 * Hence the following:
 *
 * _forclient:
 *   player object or client id to create EHs for, 0 = everybody
 * _onjip:
 *   if _forclient would match JIPing player, create EHs on it
 */
params [["_forclient", 0], ["_onjip", true]];

private _logic = (creategroup sideLogic) createUnit ["Insta_Zeus_Dumb_Curator", [0,0,0], [], 0, "NONE"];

/* "forEach" or "CODE count" doesn't work with configs */
private _addons = [];
private _cfg = configfile >> "CfgPatches";
for "_i" from 0 to (count _cfg - 1) do {
    private _x = _cfg select _i;
    if (isClass _x) then { _addons pushBack configName _x };
};
removeAllCuratorAddons _logic;
_logic addCuratorAddons _addons;

[_logic, {
    params ["_logic"];
    if (!hasInterface) exitWith {};
    waitUntil { !isNull _logic };
    /* ModuleCurator_F has function="BIS_fnc_moduleCurator", the following
    * is taken from it to register vanilla Zeus behavior */
    _logic addeventhandler ["curatorFeedbackMessage",{_this call bis_fnc_showCuratorFeedbackMessage;}];
    _logic addeventhandler ["curatorPinged",{_this call bis_fnc_curatorPinged;}];
    _logic addeventhandler ["curatorObjectPlaced",{_this call bis_fnc_curatorObjectPlaced;}];
    _logic addeventhandler ["curatorObjectEdited",{_this call bis_fnc_curatorObjectEdited;}];
    _logic addeventhandler ["curatorWaypointPlaced",{_this call bis_fnc_curatorWaypointPlaced;}];
    _logic addeventhandler ["curatorObjectDoubleClicked",{(_this select 1) call bis_fnc_showCuratorAttributes;}];
    _logic addeventhandler ["curatorGroupDoubleClicked",{(_this select 1) call bis_fnc_showCuratorAttributes;}];
    _logic addeventhandler ["curatorWaypointDoubleClicked",{(_this select 1) call bis_fnc_showCuratorAttributes;}];
    _logic addeventhandler ["curatorMarkerDoubleClicked",{(_this select 1) call bis_fnc_showCuratorAttributes;}];
    player call bis_fnc_curatorRespawn;
}] remoteExec ["spawn", _forclient, _onjip];

_logic;
