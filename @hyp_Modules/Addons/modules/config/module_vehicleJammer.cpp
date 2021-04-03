class hyp_moduleVehicleJammer: Module_F
{
    // Standard object definitions
    scope = 2; // Editor visibility; 2 will show it in the menu, 1 will hide it.
    displayName = "Vehicle IED/Mine Jammer"; // Name displayed in the menu
    icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\danger_ca.paa"; // Map icon. Delete this entry to use the default icon
    portrait = "\A3\ui_f\data\igui\cfg\simpleTasks\types\danger_ca.paa";
    category = "hyp_vehicleModifiers";
    canSetArea = 0;
    canSetAreaShape = 0;

    // Name of function triggered once conditions are met
    function = "hyp_fnc_moduleVehicleJammer";
    // Execution priority, modules with lower number are executed first. 0 is used when the attribute is undefined
    functionPriority = 0;
    // 0 for server only execution, 1 for global execution, 2 for persistent global execution
    isGlobal = 1;
    // 1 for module waiting until all synced triggers are activated
    isTriggerActivated = 1;
    // 1 to run init function in Eden Editor as well
    is3DEN = 0;

    // Menu displayed when the module is placed or double-clicked on by Zeus
    curatorInfoType = "";

    // Module attributes, uses https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes#Entity_Specific
    class Attributes: AttributesBase
    {
        // Arguments shared by specific module type (have to be mentioned in order to be present)
        class Units: Units
        {
            property = "";
        };

        // Module specific arguments
        class Range: Edit
        {
            // Unique property, use "<moduleClass>_<attributeClass>" format to make sure the name is unique in the world
            property = "hyp_moduleJamRange";
            displayName = "Jamming Range (3D)"; // Argument label
            tooltip = "Distance (m) from mines before activation"; // Tooltip description
            typeName = "NUMBER"; // Value type, can be "NUMBER", "STRING" or "BOOL"
            defaultValue = 50; // Default attribute value. WARNING: This is an expression, and its returned value will be used (50 in this case)
        };

        class addlClasses: Edit
        {
            property = "hyp_moduleJamAddlClasses";
            displayName = "Additional Classes";
            tooltip = "Add more classes of explosives here (CUP and Stuff)";
            defaultValue = [];
        };

        class Explode: Checkbox
        {
            property = "hyp_moduleJamExplode";
            displayName = "Explode?";
            tooltip = "Explode IEDs/Mines when in range";
            defaultValue = false;
        };

        class Persistent: Checkbox
        {
            property = "hyp_moduleJam_Persistent";
            displayName = "Apply Universal Classes";
            tooltip = "Applies module to all synced vehicle classes.";
            defaultValue = false;
        };

        class ModuleDescription: ModuleDescription
        {

        }; // Module description should be shown last
    };

    // Module description. Must inherit from base class, otherwise pre-defined entities won't be available
    class ModuleDescription: ModuleDescription
    {
        description = "Sync vehicles to allow for IED/Mine Jamming."; // Short description, will be formatted as structured text
        sync[] = {
            "AnyVehicle"
        };
    };
};