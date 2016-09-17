t = 10;          // base_z
tp = 3;         // support & frame thickness
t1 = 2;         // base_hole_spacing
t2 = 6.8;         // base_hole_height

r = 10;         // motor_radius
rp = 3;         // screw_radius

bt = 3;         // bracket thickness
w = 75;        // base_x
wp = 35;       // frame_x / default: w
wp1 = 4.5 - rp;        // screw_x_offset - rp

h = 61.5;        // base_y
motor_frame_height = 35;       // frame_y
hpp1 = 4.5 - 3 ;       // screw_y_offset
hppp = 0.9*h;   // base_hole_y
support_height = 43;

x_offset = (w - wp)/2;

module LeftCorner(){
    difference(){
        MotorHolder();
            color([0,1,0])      // base hole, left corner
                translate([w - 0.9*w, 0, t1/2])
                    resize([0.9*w, hppp, t2])
                        cube(1);
    }
    Bracket();
}

module RightCorner(){
    difference(){
        MotorHolder();
        color([0,1,0])      // base hole, right corner
            translate([0, 0, t1])
                resize([0.9*w, hppp, t - 2*t1])
                    cube(1);
    }
    Bracket();
}
module MotorHolder(){
    Base();
    MotorSupport();
    MotorFrame();   
}
module Base(){
    color([1,0,0])                    
        resize([w, h, t])
            cube(1);                      
}
module MotorSupport(){
    translate([x_offset, h - motor_frame_height, t])
        resize([wp, tp, support_height])
            cube(1);
}
module MotorFrame(){
    // motor face
    position = [x_offset, h - motor_frame_height + tp, support_height + t];
    difference(){                     
        translate(position)
            resize([wp, motor_frame_height + tp, tp])
                cube(1);
        MotorScrews();
    }
    // round edge
    difference(){
        translate(position + [0, - 0, 0])
            rotate([0, 90, 0])
                cylinder(r = tp, h = wp);
        translate(position - [0, 0, tp])
            cube([wp, tp, tp]);
    }
}
module MotorScrews(){
    // center
    translate([x_offset + wp/2, h - motor_frame_height/2 + tp, support_height + t])             
            cylinder(tp, r = 1.2*r, true);
    /* bottom-left
    translate([x_offset + wp1 + rp, h - motor_frame_height+ rp + hpp1 + tp, support_height + t])
        cylinder(tp, r = rp, true);
    // bottom-right
    translate([x_offset + wp - rp - wp1, h - motor_frame_height+ rp + hpp1 + tp, support_height + t]) 
        cylinder(tp, r = rp, true);*/
    // top-right
    translate([x_offset + wp - rp - wp1, h - rp - hpp1 + tp, support_height + t])      
        cylinder(tp, r = rp, true);
    // top-left
    translate([x_offset + wp1 + rp, h - rp - hpp1 + tp, support_height + t])           
        cylinder(tp, r = rp, true);
}
module Bracket(){
    module B(){
            rotate([0, -90, 0])
                linear_extrude(bt)
                    polygon(points = [
                                      [0, 0], 
                                      [0, h - motor_frame_height], 
                                      [support_height, h - motor_frame_height]
                                     ], 
                           faces =  [[0, 1, 2]]);
    }
    
    translate([0.25*wp + x_offset, 0, t]) B();
    translate([0.75*wp + x_offset, 0, t]) B();
}

LeftCorner();
translate([w + 10, 0, 0]) RightCorner();