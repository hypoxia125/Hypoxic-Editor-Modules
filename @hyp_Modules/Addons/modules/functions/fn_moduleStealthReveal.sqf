// MODULE PARAM
private _modulelogic = param [0, objNull, [objNull]];
private _syncedentities = param [1, [], [[]]];
private _isActivated = param [2, true, [true]];
_moduleLogic setVariable ["module_units", _syncedentities];

// VARIABLES

// FUNCTIONS

HYP_fnc_startStealth = {

	// LOCAL EXEC

	params ["_unit"];
	
	_unit hideObject true;
	_unit setVariable ["isStealthed", true];
	_unit setVariable ["isStealthedNew", false];

	true;
};

HYP_fnc_stealthEventHandler = {

	// LOCAL EXEC

	[
		"visionMode",
		{
			if (currentVisionMode player == 2) then {

				{
					if (_x getVariable ["isStealthed", false]) then {
						_x hideObject false;
					};
				} forEach allUnits;
			};

			if (currentVisionMode player != 2) then {

				{
					if (_x getVariable ["isStealthed", false]) then {
						_x hideObject true;
					};
				} forEach allUnits;
			};
		},
		true
	] call CBA_fnc_addPlayerEventHandler;

	true;
};



// CODE

// PERSISTENT ADDING OF CLASSES AND STEALTH LOOP

if (_modulelogic getVariable ["persistent", false]) then {

	[_modulelogic] spawn {

		params ["_modulelogic"];

		private _units = _modulelogic getVariable ["module_units", []];
		private _classes = [];
		{
			_classes pushBackUnique typeOf _x;
			[_x] call HYP_fnc_startStealth;
		} forEach _units;

		while {true} do {

			{
				if !(_x in _units) then {
					_x setVariable ["isStealthedNew", true];
					[_x] call HYP_fnc_startStealth;
				};
				_units pushBackUnique _x;
			} forEach entities [_classes, [], false, true];
			_units = _units select {alive _x};
			_modulelogic setVariable ["module_units", _units];
			sleep 2;
		};
	};
};

[] call HYP_fnc_stealthEventHandler;