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

	call compile preprocessFileLineNumbers "oo_unittest.sqf";

	sleep 2;

	 _unittest = "new" call OO_UNITTEST;

	 helloworld = { "hello world"; };

	cheatfunction = { 
	 	for "_i" from 0 to 9999 step 1 do {
	 		hint "blabla";
	 	};
	 	"hello world";
	};
	 
	_result = ["assert_equal", [helloworld, "ho world", ""]] call _unittest;
	_result = ["assert_equal", [toto, "hello world", ""]] call _unittest;
	_result = ["assert_equal", ["helpjdfq", "hello world", ""]] call _unittest;
	_result = ["assert_equal", ["helloworld", "hello world", ""]] call _unittest;
	_result = ["assert_equal", ["cheatfunction", "hello world", ""]] call _unittest;
	_result = ["assert_equal", ["helloworld", "hello robert", ""]] call _unittest;
	_result = ["assert_not_equal", ["helloworld", "hello jojo la frite", ""]] call _unittest;
	_result = ["assert_equal", ["helloworld", "hello renaud et sa grosse bécane", ""]] call _unittest;

	//_result = ["checkObject", [_unittest,"helloworld", "hello world", ""]] call _unittest;
	// assert_contain

	 
	 "dump" call _unittest;


