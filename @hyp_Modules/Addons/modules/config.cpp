class CfgPatches
{
	class hyp_Modules
	{
		units[] = {
			"hyp_moduleAutoRefuel",
			"hyp_moduleAutoRepair",
			"hyp_moduleAutoRearm",
			"hyp_moduleFuelConsumption"
		};
		requiredVersion = 1.0;
		requiredAddons[] = {"A3_Modules_F"};
	};
};

class CfgFactionClasses
{
	class NO_CATEGORY;
	class hyp_vehicleModifiers: NO_CATEGORY
	{
		displayName = "Vehicle Modifiers";
	};
	class hyp_infantryModifiers: NO_CATEGORY
	{
		displayName = "Infantry Modifiers";
	};
};

class CfgFunctions
{
	class HYP
	{
		class fnc
		{
			file = "\modules\functions";
			class moduleAutoRefuel {};
			class moduleAutoRepair {};
			class moduleAutoRearm {};
			class moduleFuelConsumption {};
		};
	};
};

class CfgVehicles
{
	class Logic;
	class Module_F: Logic
	{
		class AttributesBase
		{
			class Default;
			class Edit;					// Default edit box (i.e., text input field)
			class Combo;				// Default combo box (i.e., drop-down menu)
			class Checkbox;				// Default checkbox (returned value is Boolean)
			class CheckboxNumber;		// Default checkbox (returned value is Number)
			class ModuleDescription;	// Module description
			class Units;				// Selection of units on which the module is applied
		};
		// Description base classes, for more information see below
		class ModuleDescription
		{
			class AnyVehicle;
		};
	};
	//Include Modules Below - Hypoxic
	#include "\modules\config\module_autoRefuel.cpp"
	#include "\modules\config\module_autoRepair.cpp"
	#include "\modules\config\module_autoRearm.cpp"
	#include "\modules\config\module_fuelConsumption.cpp"
};