// Public parameters

base_height = 40;
base_width = 30;
base_thickness = 2;

support_distance = 12;
plastic_support_radius = 5;
plastic_support_depth = 3;
plastic_support_thickness = 2;
screw_hole_radius = 4;

channel_depth = 20;
channel_thickness = 3.5;
channel_radius = 9.5;

$fn = 100;

// PRIVATE =================================

delta = 0.01;
shift = - delta / 2;

// Modules

module plastic_support(d, r, t, x, y, z) {
    inner_r = r - (t / 2);
    translate([x,y,z]){
        difference() {
            cylinder(h = d, r = r);
                translate([0,0,t]){
                    cylinder(h = d+ delta + t, r = inner_r);
            }
        }   
    }
}

module base(w, h, t) {
    union() {
        translate([w/2,w/2,0]) {
            cylinder(h=t, r=w/2);
        }
        translate([w/2,h - w/2,0]) {
            cylinder(h=t, r=w/2);
        }
        translate([0,w/2+shift,0]) {
            cube([w, h - w + delta, t]);
        }
   }
}

module screw(r, t, x, y){
    translate([x, y, shift]) {
        cylinder(h=t+delta, r=r);
    }
}

module channel(r, t, d, x, y) {
    o_r = r + t;
    translate([x,y,-d-shift]){
        difference(){
            cylinder(h=d, r = o_r);
            translate([-o_r+shift,shift,shift]){
                cube([o_r*2+delta,o_r+delta,d+delta]);
            }
            translate([0,0, shift])
            cylinder(h=d + delta, r=r);
        }
    }
}

// Main

center_to_edge = (base_height - support_distance) / 2;

screw_hole_x = base_width/2;
screw_hole_y = center_to_edge;

plastic_support_x = screw_hole_x;
plastic_support_y = base_height - center_to_edge;

channel_x = screw_hole_x;
channel_y = screw_hole_y;

union() {        
    plastic_support(plastic_support_depth, plastic_support_radius, plastic_support_thickness, plastic_support_x, plastic_support_y, base_thickness);
    difference() {
        base(base_width, base_height, base_thickness);
        screw(screw_hole_radius, base_thickness, base_width/2,center_to_edge);
    }    channel(channel_radius, channel_thickness, channel_depth, channel_x, channel_y);
}
