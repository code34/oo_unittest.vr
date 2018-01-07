	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2018 Nicolas BOITEUX

	CLASS OO_UNITTEST
	
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
	
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>. 
	*/

	#include "oop.h"

	CLASS("OO_UNITTEST")
		PRIVATE VARIABLE("array", "log");
		
		PUBLIC FUNCTION("","constructor") { 
			DEBUG(#, "OO_UNITTEST::constructor")
			MEMBER("log", []);
		};

		PUBLIC FUNCTION("", "helloworld") {
			"hello world";
		};

		PUBLIC FUNCTION("","dump") {
			DEBUG(#, "OO_UNITTEST::dump")
			private _log = "";
			{
				_log = _log + _x + endl;
			} forEach MEMBER("log", nil);
			copyToClipboard _log;
			hint "Results were copied to your clipboard";
		};

		PUBLIC FUNCTION("array", "call") {
			DEBUG(#, "OO_UNITTEST::call")
			_result = MEMBER("check", _this);
			if(_result) then {_result = "SUCCESS";} else {"FAILED";};
			private _parameters = _this select 2;
			if(isNil _parameters) then  { _parameters = "none"};
			private _log = "==> ";
			_log = _log + format ["Function: %1", _this select 0] + endl;
			_log = _log + format ["Params: %1", _parameters] + endl; 
			_log = _log + format ["Result expected: %1", _this select 1] + endl; 
			_log = _log + format ["Pass Through: %1" , _result] + endl;
			_log = _log + "==============================" + endl;
			MEMBER("log", nil) pushBack _log;
		};

		/*
		1 - function name
		2 - return expected
		3 - parameters
		*/
		PUBLIC FUNCTION("array", "check") {
			DEBUG(#, "OO_UNITTEST::check")
			params ["_function", "_return","_parameters"];
			if(typeName _function isEqualTo "STRING") then { _function = missionNamespace getVariable "_function"; };
			if!(typeName _function isEqualTo "CODE") exitWith {false;};
			private _result = _parameters call _function;
			if!(_result isEqualTo _return) then {false;} else {true;};
		};

		/*
		1 - object
		2 - function name
		3 - return expected
		4 - parameters
		*/
		PUBLIC FUNCTION("array", "checkObject") {
			DEBUG(#, "OO_UNITTEST::checkObject")
			params ["_object", "_function", "_return","_parameters"];
			private _result = _return;
			if!(typeName _object isEqualTo "CODE") exitWith {false;};
			if!(typeName _function isEqualTo "STRING") exitWith {false;};
			if(isNil "_parameters") then { _parameters = "";};
			if(_parameters isEqualTo "") then {
				_result = _function call _object;
			} else {
				_result = [_function, _parameters] call _object;
			};
			if(_result isEqualTo _return) then {true;} else {false;};
		};

		PUBLIC FUNCTION("","deconstructor") {
			DEBUG(#, "OO_UNITTEST::deconstructor")
			DELETE_VARIABLE("log");
		};
	ENDCLASS;