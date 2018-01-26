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
	call compile preprocessFileLineNumbers "oo_helloworld.sqf";

	sleep 2;

	 _unittest = "new" call OO_UNITTEST;
	 _helloworld = "new" call OO_HELLOWORLD;

	 // should succeed
	_result = ["assert_equal", [_helloworld, "helloworld", "i got it", nil]] call _unittest;
	//shoud failed
	_result = ["assert_not_equal", [_helloworld, "helloworld", "i got it", nil]] call _unittest; 
	//should failed
	_result = ["assert_equal", [_helloworld, "hellowor", "i got it", nil]] call _unittest; 
	//should passed
	_result = ["assert_equal", [nil, "helloworld", "i got it", nil]] call _unittest;

	 "dump" call _unittest;


