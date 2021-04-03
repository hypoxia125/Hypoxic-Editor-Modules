// MODULE PARAM
private _modulelogic = param [0, objNull, [objNull]];
private _syncedentities = param [1, [], [[]]];
private _isActivated = param [2, true, [true]];

_modulelogic setVariable ["module_units", _syncedEntities];

REFUEL_DEBUG = false;

// FUNCTIONS

HYP_run_refuel = {

	params ["_vehicle", "_time"];

	private _fuel = fuel _vehicle;
	private _perSec = 100 / _time / 100;

	if !(isEngineOn _vehicle) then {
		if (fuel _vehicle <= 1) then {
			if (speed _vehicle < 5) then {
				private _newfuel = _fuel + _perSec;
				_vehicle setFuel _newfuel;
			};
		};
	};

	true;
};

// CODE

if !(_isActivated) exitWith {};
if !(isServer) exitWith {};

// PERSISTENT ADDING OF VEHICLES

if (_modulelogic getVariable ["persistent", false]) then {

	[_modulelogic] spawn {

		params ["_modulelogic"];

		private _units = _modulelogic getVariable ["module_units", []];
		private _classes = [];
		{
			_classes pushBackUnique typeOf _x;
		} forEach _units;

		while {true} do {

			{
				_units pushBackUnique _x;
			} forEach entities [_classes, [], false, true];
			_units = _units select {alive _x};
			_modulelogic setVariable ["module_units", _units];
			sleep 2;
			if REFUEL_DEBUG then { systemChat format ["Current Units = %1", _units]};
			if REFUEL_DEBUG then { systemChat format ["Current Classes = %1", _classes]};
		};
	};
};

// REFUELING LOOP

[_modulelogic] spawn {

	params ["_modulelogic"];

	private _time = _modulelogic getVariable ["time", 600];

	while {true} do {

		private _units = _modulelogic getVariable ["module_units", []];
		if !(_units isEqualTo []) then {
	
			_units = _units select {alive _x};
			{
				[_x, _time] remoteExec ["HYP_run_refuel", _x];
			} forEach _units;
		};
		sleep 1;
		if REFUEL_DEBUG then { systemChat format ["Units Fueled = %1", _units]};
	};
};

true