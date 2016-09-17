include <gondola_base.scad>

holder_radio_shrink = 2;
arm_height = 10;
arm_belt_radius = 10;
$fn = 30;
trap_distance = 1.2; 
belt_height = 6;
arm_delta = 0.4;

/* 
 * Excerpt from... 
 * Parametric Encoder Wheel 
 * by Alex Franke (codecreations), March 2012
 * http://www.theFrankes.com
 * Licenced under Creative Commons Attribution - Non-Commercial - Share Alike 3.0 
*/
 
module arc( height, depth, radius, degrees ) {
    // This dies a horible death if it's not rendered here 
    // -- sucks up all memory and spins out of control 
    render() {
        difference() {
            // Outer ring
            rotate_extrude($fn = 100)
                translate([radius - height, 0, 0])
                    square([height,depth]);
         
            // Cut half off
            translate([0,-(radius+1),-.5]) 
                cube ([radius+1,(radius+1)*2,depth+1]);
         
            // Cover the other half as necessary
            rotate([0,0,180-degrees])
            translate([0,-(radius+1),-.5]) 
                cube ([radius+1,(radius+1)*2,depth+1]);
         
        }
    }
}

// Nicked from https://cdn.thingiverse.com/zipfiles/da/60/31/e2/71/RepRap_Pro_Ormerod_iamburnys_Y-axis_Belt_Clamp_-_Parametric.zip
module teeth(){
	module tooth() {
		x = 1.3;
		y = arm_height + belt_height;
		z= 0.75;
		a = 0.4;
	
		polyhedron(
			points=[[0,0,0] , [a,0,z] , [x-a,0,z] , [x,0,0] ,[0,y,0] , [a,y,z] , [x-a,y,z] , [x,y,0]],
			triangles=[[3,4,0],[3,7,4],  [1,5,2],[2,5,6],  [0,1,2],[0,2,3], [0,4,5], [0,5,1],  [7,6,5], [7,5,4],  [3,2,6], [3,6,7]
			]);
	}

	translate ([0,-10,0])
	        cube([arm_height + belt_height,10,2]);
	
	for (i = [0:4]) {
		translate([arm_height + belt_height,-10+(i*2),2])
			rotate([0,0,90])
				tooth();
    
	}
}

module ArmBase(){
	difference(){
	    arc(20, arm_height, holder_base_radio + arm_belt_radius + arm_delta, 33.75);   
	    translate([0, 0, arm_height/2]) arc(20, arm_height/2, holder_base_radio + arm_belt_radius+ arm_delta, 33.75);   
	}
}


module Trap(){
		translate([-3.5 - 2 - trap_distance, -5, (arm_height + belt_height)/2])
			resize([0, 0, arm_height + belt_height])
				rotate([180,-90, 0])
					hull(){
						cube([7, 10, 2], true);
						translate([0, -3.5/2, 3.5/3])rotate([0,90,0]) cylinder(7, 1.5, 1.5, true);
						translate([0, 5 - 3.5/2, 3.5/3])rotate([0,90,0]) cylinder(7, 1.5, 1.5, true);
					}
}


module RightArmTrap(){
	translate([0.5, -holder_base_radio + arm_belt_radius - 4 - arm_height/2, 0])
		rotate([0,0,-33.75/2]){
			translate([-(trap_distance + 6.5), -10,0])	
				rotate([0,0,180])
			union(){
				rotate([0,-90,0])
					teeth();
		
				Trap();
			}
		}
}


module ArmTrap(){
	translate([0.5, -holder_base_radio + arm_belt_radius - 4 - arm_height/2, 0])
		rotate([0,0,-33.75/2]){
			rotate([0,-90,0])
				teeth();

			Trap();
		}
}


module Arm(){
	difference(){
	    union(){
	        HolderBase(delta=arm_delta);
	        ArmBase();
	        RightArmTrap();
	
	        rotate(90){
	            ArmBase();
	            ArmTrap();
	        }
	    }
	    cylinder(r = holder_radio + arm_delta, h = holder_base_height);
	}
}

/*HolderBase();
//Base();
//	translate([0,0,20])
		color([1,0,1])
		Arm();
*/

Arm();