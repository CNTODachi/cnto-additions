class CfgPatches {
    class Ares_Extras {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {};
    };
};

class CfgFunctions {
    class Ares_Extras {
        class All {
            file = "\ares_extras\functions";
            class init { postInit = 1; };
            class Dialog;
            class ForGroups;
            class ForGroupsMP;
            class ForUnits;
            class ForUnitsMP;
            class Selection;
            class StdDistances;
        };
        /* these came from the original A3MT */
        class A3MT {
            file = "\ares_extras\functions\a3mt";
            class teleport;
            class addRemoveNVGs;
            class vehLightOn;
            class setPosAGLS;
        };
        /* these provide A3MT-like functionality, but didn't come from it */
        class New {
            file = "\ares_extras\functions\new";
            class manualSuppress;
            class bisSuppress;
        };
    };
};
