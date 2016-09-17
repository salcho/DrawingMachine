$fn = 40;
// ------------ Base
base_radio = 50/2;
base_height = 5;
base_wall = 3;
// ------------ Holder
holder_base_radio = 25/2;
holder_base_height = base_height + 10;
holder_radio = 17/2;
holder_wall = 2;
holder_height = 50;
// ------------ Screw
screw_diameter = 4;


module HolderBase(delta = 0){
	difference(){
	    cylinder(r = holder_base_radio , h = holder_base_height);
	    cylinder(r = holder_radio - holder_wall + delta, h = holder_base_height);
	}
}

module Base(){
	module BaseBase(){
		size = [5, base_radio*2, base_height];
		difference(){
		    union(){
		        translate([0, 0, base_height/2])
		            cube(size, true);
		        rotate(90)
		            translate([0, 0, base_height/2])
		                cube(size, true);
		        }
		    cylinder(r = holder_radio - holder_wall, h = base_height);
		}
	
		difference(){
			cylinder(r = base_radio, h = base_height);
			cylinder(r = base_radio - base_wall, h = base_height);
		}
	}
	
	
	module Holder(){
		difference(){
			cylinder(r = holder_radio, h = holder_height);
			cylinder(r = holder_radio - holder_wall, h = holder_height);

translate([0, holder_radio, 0.9*holder_height])
			rotate([90,0,0])
			cylinder(r = screw_diameter/2, h = holder_radio*2);
	}
		}

BaseBase();
HolderBase();
Holder();
}
//Base();
