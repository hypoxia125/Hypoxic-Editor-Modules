// MODULE PARAM
private _moduleLogic = param [0, objNull, [objNull]];
private _syncedentities = param [1, [], [[]]];
private _isActivated = param [2, true, [true]];

_moduleLogic setVariable ["module_jammer_units", _syncedEntities];

// FUNCTIONS

HYP_run_jam = {

	params ["_vehicle", "_moduleLogic"];

	private _mines = _moduleLogic getVariable ["allMines", []];
	private _range = _moduleLogic getVariable ["range", 50];
	private _explode = _moduleLogic getVariable ["explode", false];

	{
		if (_x distance _vehicle <= _range) then {

			if (_explode) then {
				_x setdamage 1;
			} else {
				_x enableSimulationGlobal false;
			};
		};

		if (_x distance _vehicle > _range) then {

			_x enableSimulationGlobal true;
		};
	} forEach _mines;

	true;
};

// CODE

if !(_isActivated) exitWith {};
if !(isServer) exitWith {};

// PERSISTENT ADDING OF VEHICLES

if (_moduleLogic getVariable ["persistent", false]) then {

	[_moduleLogic] spawn {

		params ["_moduleLogic"];

		private _units = _moduleLogic getVariable ["module_jammer_units", []];
		private _classes = [];
		{
			_classes pushBackUnique typeOf _x;
		} forEach _units;

		while {true} do {

			{
				_units pushBackUnique _x;
			} forEach entities [_classes, [], false, true];
			_units = _units select {alive _x};
			_moduleLogic setVariable ["module_jammer_units", _units];
			sleep 2;
		};
	};
};

// MINE ADD LOOP

[_moduleLogic] spawn {

	params ["_moduleLogic"];

	private _addlClasses = _moduleLogic getVariable ["addlClasses", []];
	_addlClasses = parseSimpleArray _addlClasses;

	while {true} do {

		private _mines = allMines;

		if !(_addlClasses isEqualTo []) then {
			{
				_mines pushBackUnique _x;
			} forEach entities [_addlClasses, [], false, true];
		};
		_moduleLogic setVariable ["allMines", _mines];
		sleep 2;
	};
};

// MINE JAM LOOP

[_moduleLogic] spawn {

	params ["_moduleLogic"];

	private _units = _moduleLogic getVariable ["module_jammer_units", []];
	while {true} do {

		if !(_units isEqualTo []) then {

			{
				[_x, _moduleLogic] remoteExec ["HYP_run_jam", _x];
			} forEach _units;
		};
		sleep 1;
	};
};