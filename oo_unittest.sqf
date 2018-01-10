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
		PRIVATE VARIABLE("array", "stats");
		
		PUBLIC FUNCTION("","constructor") { 
			DEBUG(#, "OO_UNITTEST::constructor")
			MEMBER("init", nil);
		};

		PUBLIC FUNCTION("","init") {
			DEBUG(#, "OO_UNITTEST::init")
			MEMBER("log", []);
			private _array = [0,0,0];
			MEMBER("stats", _array);
		};

		PRIVATE FUNCTION("array", "pushLog") {
			params ["_function", "_parameters", "_condition", "_returnexpected", "_return", "_ticktime", "_result", "_reason"];
			private _log = "==> ";
			_log = _log + format ["Function: %1", _function] + endl;
			_log = _log + format ["Params: %1", _parameters] + endl; 
			_log = _log + format ["Condition: %1", _condition] + endl; 
			_log = _log + format ["Return expected: %1 (%2)", typename _returnexpected, _returnexpected] + endl; 
			_log = _log + format ["Return: %1 (%2)", typename _return, _return] + endl; 
			_log = _log + format ["Time: %1 ms" , _ticktime] + endl;
			_log = _log + format ["Result: %1" , _result] + endl;
			_log = _log + format ["Error Message: %1" , _reason] + endl;
			_log = _log + "<==" + endl;
			MEMBER("log", nil) pushBack _log;
		};

		PUBLIC FUNCTION("","dump") {
			DEBUG(#, "OO_UNITTEST::dump")
			private _log = "";
			private _stats = MEMBER("stats", nil);
			{
				_log = _log + _x + endl;
			} forEach MEMBER("log", nil);
			_log = _log + "Global Results:" + endl;
			_log = _log + "============" + endl;
			_log = _log + format ["Successed: %1", _stats select 0] + endl;
			_log = _log + format ["Passed: %1 ", _stats select 1] + endl;
			_log = _log + format ["Failed: %1", _stats select 2] + endl;
			copyToClipboard _log;
			hint "Results were copied to your clipboard";
			MEMBER("init", nil);
		};

		PUBLIC FUNCTION("array","assert_equal") {
			_this pushBack "assert_equal";
			if(count _this > 4) then {
				MEMBER("executeAssertOnObject", _this);
			} else {
				MEMBER("executeAssert", _this);
			};
		};

		PUBLIC FUNCTION("array","assert_not_equal") {
			_this pushBack "assert_not_equal";
			if(count _this > 4) then {
				MEMBER("executeAssertOnObject", _this);
			} else {
				MEMBER("executeAssert", _this);
			};
		};

		PRIVATE FUNCTION("array", "executeAssert") {
			DEBUG(#, "OO_UNITTEST::call")
			params ["_function", "_returnexpected","_parameters", "_condition"];
			
			private _return = "";
			private _reason = "";
			private 	_result = "SUCCESSED";
			private _code = "";
			private _stats = MEMBER("stats", nil);
			private _ticktime = 0;
			//if!(toLower(_condition) in ["assert_equal", "assert_not_equal", "assert_instance_of", "assert_kind_of", "assert_respond_to"]) then {_condition = "assert_equal";};
			if!(toLower(_condition) in ["assert_equal", "assert_not_equal"]) then {_condition = "assert_equal";};
			try { 
				if(isnil "_function") then { throw "FUNCTIONNOTSTRING"; };
				if!(typeName _function isEqualTo "STRING") then { throw "FUNCTIONNOTSTRING"; };
				if(isnil "_returnexpected") then { throw "RESULTNOTDEFINED"; };
				
				_code = missionNamespace getVariable _function;
				if(isNil "_code") then { throw "FUNCTIONNOTDECLARED";};

				isnil { 
					_ticktime = diag_tickTime;
					_return = _parameters call _code;
					_ticktime = diag_tickTime - _ticktime;
				};

				if(isNil "_return") then { throw "FUNCTIONRESULTISNIL"; };
				switch (_condition) do {
					case "assert_equal": {
						if!(_return isEqualTo _returnexpected) then { throw "RESULTNOTEXPECTED"; };
					};
					case "assert_not_equal": {
						if(_return isEqualTo _returnexpected) then { throw "RESULTNOTEXPECTED"; };
					};
				};
				
				_stats = [(_stats select 0) + 1, (_stats select 1) , (_stats select 2)];
				MEMBER("stats", _stats);
			} catch {
				switch (_exception) do { 
					case "RESULTNOTDEFINED" : {
						_reason = "Exception: result expected was not define";
						_function = format ["%1", _function];
						_result = "PASSED";
						_stats = [(_stats select 0), (_stats select 1) + 1 , (_stats select 2)];
						MEMBER("stats", _stats);
						_return = nil;
					};
					case "FUNCTIONNOTSTRING" : {
						_reason = "Exception: function name is not string";
						_function = format ["%1", _function];
						_result = "PASSED";
						_stats = [(_stats select 0), (_stats select 1) + 1 , (_stats select 2)];
						MEMBER("stats", _stats);
						_return = nil;
					}; 
					case "FUNCTIONNOTDECLARED" : {
						_reason = "Exception: function is not declared";
						_result = "PASSED";
						_stats = [(_stats select 0), (_stats select 1) + 1 , (_stats select 2)];
						MEMBER("stats", _stats);
						_return = nil;
					}; 
					case "FUNCTIONRESULTISNIL" : {
						_reason = "Exception: function result is nil";
						_result = "FAILED";
						_stats = [(_stats select 0), (_stats select 1), (_stats select 2)+1];
						MEMBER("stats", _stats);
					};
					case "RESULTNOTEXPECTED" : {
						_reason = "Exception: result is not the one expected";
						_result = "FAILED";
						_stats = [(_stats select 0), (_stats select 1), (_stats select 2)+1];
						MEMBER("stats", _stats);
					};
					default {
						_reason = "Exception: not handle";
					}; 
				};
			};
			_array = [_function, _parameters, _condition, _returnexpected, _return, _ticktime, _result, _reason];
			MEMBER("pushLog", _array);
		};


		PRIVATE FUNCTION("array", "executeAssertOnObject") {
			DEBUG(#, "OO_UNITTEST::call")
			params ["_object", "_function", "_returnexpected","_parameters", "_condition"];
			
			private _return = "";
			private _reason = "";
			private 	_result = "SUCCESSED";
			private _code = "";
			private _stats = MEMBER("stats", nil);
			private _ticktime = 0;
			//if!(toLower(_condition) in ["assert_equal", "assert_not_equal", "assert_instance_of", "assert_kind_of", "assert_respond_to"]) then {_condition = "assert_equal";};
			if!(toLower(_condition) in ["assert_equal", "assert_not_equal"]) then {_condition = "assert_equal";};
			try { 
				if(isnil "_object") then { throw "OBJECTISNOTDEFINED"; };
				if!(typeName _object isEqualTo "CODE") then { throw "OBJECTISNOTDEFINED"; };
				if(isnil "_function") then { throw "FUNCTIONNOTSTRING"; };
				if!(typeName _function isEqualTo "STRING") then { throw "FUNCTIONNOTSTRING"; };
				if(isnil "_returnexpected") then { throw "RESULTNOTDEFINED"; };
				
				isnil { 
					if!(isNil "_parameters") then  {
						_ticktime = diag_tickTime;
						_return = [_function, _parameters] call _object;
						_ticktime = diag_tickTime - _ticktime;
					} else {
						_ticktime = diag_tickTime;
						_return = _function call _object;
						_ticktime = diag_tickTime - _ticktime;
					};
				};

				if(isNil "_return") then { throw "FUNCTIONRESULTISNIL"; };
				switch (_condition) do {
					case "assert_equal": {
						if!(_return isEqualTo _returnexpected) then { throw "RESULTNOTEXPECTED"; };
					};
					case "assert_not_equal": {
						if(_return isEqualTo _returnexpected) then { throw "RESULTNOTEXPECTED"; };
					};
				};
				_stats = [(_stats select 0) + 1, (_stats select 1) , (_stats select 2)];
				MEMBER("stats", _stats);
			} catch {
				switch (_exception) do { 
					case "OBJECTISNOTDEFINED" : {
						_reason = "Exception: object was not define";
						_object = format ["%1", _object];
						_function = format ["%1", _function];
						_result = "PASSED";
						_stats = [(_stats select 0), (_stats select 1) + 1 , (_stats select 2)];
						MEMBER("stats", _stats);
						_return = nil;
					};
					case "RESULTNOTDEFINED" : {
						_reason = "Exception: result expected was not define";
						_function = format ["%1", _function];
						_result = "PASSED";
						_stats = [(_stats select 0), (_stats select 1) + 1 , (_stats select 2)];
						MEMBER("stats", _stats);
						_return = nil;
					};
					case "FUNCTIONNOTSTRING" : {
						_reason = "Exception: function name is not string";
						_function = format ["%1", _function];
						_result = "PASSED";
						_stats = [(_stats select 0), (_stats select 1) + 1 , (_stats select 2)];
						MEMBER("stats", _stats);
						_return = nil;
					}; 
					case "FUNCTIONRESULTISNIL" : {
						_reason = "Exception: function result is nil";
						_result = "FAILED";
						_stats = [(_stats select 0), (_stats select 1), (_stats select 2)+1];
						MEMBER("stats", _stats);
					};
					case "RESULTNOTEXPECTED" : {
						_reason = "Exception: result is not the one expected";
						_result = "FAILED";
						_stats = [(_stats select 0), (_stats select 1), (_stats select 2)+1];
						MEMBER("stats", _stats);
					};
					default {
						_reason = "Exception: not handle";
					}; 
				};
			};
			_array = [_function, _parameters, _condition, _returnexpected, _return, _ticktime, _result, _reason];
			MEMBER("pushLog", _array);
		};

		PUBLIC FUNCTION("","deconstructor") {
			DEBUG(#, "OO_UNITTEST::deconstructor")
			DELETE_VARIABLE("log");
			DELETE_VARIABLE("stats");
		};
	ENDCLASS;