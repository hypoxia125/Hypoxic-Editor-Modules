// MODULE PARAM
private _modulelogic = param [0, objNull, [objNull]];
private _syncedentities = param [1, [], [[]]];
private _isActivated = param [2, true, [true]];

_modulelogic setVariable ["module_units", _syncedEntities];

// FUNCTIONS

HYP_run_rearm = {

	params ["_vehicle"];
	
	private _isNew = _vehicle getVariable ["isNew_Rearm", true];

	if (_isNew) then {
		private _magInfo = magazinesAllTurrets _vehicle;
		_vehicle setVariable ["magazinesAllTurrets", _magInfo];
		_vehicle setVariable ["isNew_Rearm", false];
	};

	private _currentAmmoCount = [];
	{
		_currentAmmoCount pushBack (_x#2);
	} forEach (magazinesAllTurrets _vehicle);
	
	private _modifyAllMags = _vehicle getVariable "magazinesAllTurrets";
	private _magazine = [];
	private _turret = [];
	{
		_magazine pushBack _x#0;
		_turret pushBack _x#1;
	} forEach (magazinesAllTurrets _vehicle);
	
	//Code
	for "_i" from 0 to (count _modifyAllMags) do {
	
		if (_currentAmmoCount#_i <= 0) then {
	
			_vehicle removeMagazineTurret [_magazine#_i, _turret#_i];
			_vehicle addMagazineTurret [_magazine#_i, _turret#_i];
		};
	};	
	true
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
			_x setVariable ["isNew_Rearm", true];
		} forEach _units;

		while {true} do {

			{
				if !(_x in _units) then {
					_x setVariable ["isNew_Rearm", true];
				};
				_units pushBackUnique _x;
			} forEach entities [_classes, [], false, true];
			_units = _units select {alive _x};
			_modulelogic setVariable ["module_units", _units];
			sleep 2;
		};
	};
};

// REARMING LOOP

[_modulelogic] spawn {

	params ["_modulelogic"];

	private _time = _modulelogic getVariable ["time", 150];

	while {true} do {

		private _units = _modulelogic getVariable ["module_units", []];
		if !(_units isEqualTo []) then {
	
			_units = _units select {alive _x};
			{
				[_x] remoteExec ["HYP_run_rearm", _x];
			} forEach _units;
		};
		sleep _time;
	};
};

true