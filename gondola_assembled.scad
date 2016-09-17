include <gondola_base.scad>
include <gondola_arm.scad>

color([0,0,1])
	Base();
color([0,1,0])
translate([0, 0, base_height + holder_base_height])
Arm();

