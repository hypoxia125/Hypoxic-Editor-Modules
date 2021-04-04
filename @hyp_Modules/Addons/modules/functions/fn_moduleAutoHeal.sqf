// MODULE PARAM
private _modulelogic = param [0, objNull, [objNull]];
private _syncedentities = param [1, [], [[]]];
private _isActivated = param [2, true, [true]];
_moduleLogic setVariable ["module_units", _syncedentities];

// FUNCTIONS

HYP_run_heal = {

	params ["_vehicle", "_time"];

	private _perSecond = 100 / _time / 100;
	private _allHitPoints = getAllHitPointsDamage _vehicle;
	private _hitPointnames = _allHitPoints select 0;
	private _damageValues = _allHitPoints select 2;
		
	private _newdamageValues = [];
	{
		_x = _x - _perSecond;
		_newdamageValues pushBack _x;
	} forEach _damageValues;
		
	for "_i" from 0 to (count _hitPointnames) do {
		private _hitPoint = _hitPointnames select _i;
		private _damage = _newdamageValues select _i;
		if (!isnil "_hitPoint") then {
			if (_damage >= 0) then {
				_vehicle setHitPointDamage [_hitPoint, _damage, true];
			};
		};
	};
	
	true
};

// ------------------CODE-------------------- //

if !(_isActivated) exitWith {};
if !(isServer) exitWith {};

// PERSISTENT ADDING OF UNITS

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
		};
	};
};

// HEALING LOOP

[_modulelogic] spawn {

	params ["_modulelogic"];

	private _time = _modulelogic getVariable ["time", 600];

	while {true} do {

		private _units = _modulelogic getVariable ["module_units", []];
		if !(_units isEqualTo []) then {
	
			_units = _units select {alive _x};
			{
				[_x, _time] remoteExec ["HYP_run_heal", _x];
			} forEach _units;
		};
		sleep 1;
	};
};

true
