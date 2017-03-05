/*
 * just object/group attributes, Eden UI global attributes are elsewhere
 */

class Object {
    class AttributeCategories {
        class Extended_Gear {
            displayName = "Extended Gear";
            collapsed = 1;
            class Attributes {
                class goggles {
                    property = "a3ee_extgear_goggles";
                    control = "ComboCfgGlasses";
                    displayName = "Goggles";
                    expression = "[_this, _value] call a3ee_fnc_eg_goggles";
                    condition = "objectBrain";
                    defaultValue = "''";
                    tooltip = "Override goggles/glasses/facewear on a player.\n\nUse ""None"" to force remove any goggles.";
                };
                class insignia {
                    property = "a3ee_extgear_insignia";
                    control = "ComboInsignia";
                    displayName = "Insignia";
                    expression = "[_this, _value] call a3ee_fnc_eg_insignia";
                    condition = "objectBrain";
                    defaultValue = "''";
                    tooltip = "Insignia from CfgUnitInsignia (mod or description.ext).\n\n""Use player insignia"" tries to find a variable named ""a3ee_player_insignia"" in the client profile, specifying a CfgUnitInsignia class name - if found, it is assigned. Otherwise behaves like ""No change"".";
                };
                class face {
                    property = "a3ee_extgear_face";
                    control = "FaceWithNoChange";
                    displayName = "Face";
                    expression = "[_this, _value] call a3ee_fnc_eg_face";
                    condition = "objectBrain";
                    defaultValue = "''";
                    tooltip = "Override player face.";
                };
            };
        };
        class Control {
            class Attributes {
                class a3ee_teamcolor {
                    property = "a3ee_teamcolor";
                    control = "Combo";
                    displayName = "Team color";
                    expression = "[_this, _value] call a3ee_fnc_o_teamColor";
                    condition = "objectBrain";
                    class Values {
                        class Default { name = "Default"; value = "MAIN"; };
                        class Red { name = "Red"; value = "RED"; };
                        class Green { name = "Green"; value = "GREEN"; };
                        class Blue { name = "Blue"; value = "BLUE"; };
                        class Yellow { name = "Yellow"; value = "YELLOW"; };
                    };
                    typeName = "STRING";
                    defaultValue = """MAIN""";
                    tooltip = "Set unit color inside a group.";
                };
            };
        };
    };
};

class Group {
    class AttributeCategories {
        class Init {
            class Attributes {
                class a3ee_persistent_callsign {
                    property = "a3ee_persistent_callsign";
                    control = "Edit";
                    displayName = "Persistent Callsign";
                    expression = "";
                    typeName = "STRING";
                    defaultValue = """""";
                    tooltip = "Set a persistent callsign for a group. This callsign can be restored via the Eden editor Tools menu, overriding the default Callsign field above.";
                };
            };
        };
        class State {
            class Attributes {
                class a3ee_locality_transfer {
                    property = "a3ee_locality_transfer";
                    control = "Checkbox";
                    displayName = "Move group to HC";
                    expression = "_this setVariable [""%s"",_value]";
                    defaultValue = "false";
                    tooltip = "Transfer this group to a Headless Client before mission start, but after any unit/group initialization finishes.\nNote that any changes with local effect will be lost.\n\nThis functionality needs a module counterpart.";
                };
            };
        };
    };
};
