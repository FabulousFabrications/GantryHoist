use <steel section.scad>;

section_d = 70;
section_t = 3;
gantry_width = 3000;
side_width = 1000;
height = 1600;

// cut from
// http://www.fhbrundle.co.uk/products/30031506__Mild_Steel_Flat_Bar_150_x_6mm_x_6_0_6_1m_Grade_S275
plate_t = 10;
plate_d = 150;
plate_hole = 10;

module section(l) {
    echo(str("section with length ", l));
    cube([section_d, section_d, l]);
    //square_section(section_d, section_t, l);
}

module gantry() {
    translate([0, 0, section_d + height]) rotate([-90, 0, 0]) section(gantry_width);
}

module plate() {
    difference() {
        translate([0, 0, plate_t/2]) cube([plate_d, plate_d, plate_t], center=true);
        translate([plate_d/2 - plate_hole*2, plate_d/2 - plate_hole*2, -0.5]) cylinder(d=plate_hole, h=plate_t+1);
        translate([-(plate_d/2 - plate_hole*2), plate_d/2 - plate_hole*2, -0.5]) cylinder(d=plate_hole, h=plate_t+1);
        translate([plate_d/2 - plate_hole*2, -(plate_d/2 - plate_hole*2), -0.5]) cylinder(d=plate_hole, h=plate_t+1);
        translate([-(plate_d/2 - plate_hole*2), -(plate_d/2 - plate_hole*2), -0.5]) cylinder(d=plate_hole, h=plate_t+1);
    }
}

module side() {
    translate([section_d/2, section_d/2, height-10]) plate();
    translate([section_d/2, section_d/2, height-20]) plate();
    translate([0, 0, height/2]) section(height/2 - plate_t*2);
    one_side_width = side_width/2;
    one_side_height = height/2 + section_d*2 - plate_t*2;
    tri_length = sqrt(one_side_width*one_side_width + one_side_height*one_side_height);
    a = atan(one_side_width/one_side_height);
    translate([-one_side_width, 0, 0]) rotate([0, a, 0]) mitre(a, tri_length) section(tri_length);
    translate([one_side_width + section_d, section_d, 0]) rotate([0, -a, 0])
    rotate([0, 0, 180]) mitre(a, tri_length) section(tri_length);
}

module mitre(a, tri_length) {
    render() rotate([0, a-a, 0]) difference() {
        children();
        rotate([0, 90-a, 0]) translate([0, 0, -section_d]) cube([section_d, section_d, tri_length]);
        
        // TODO: this bit isn't right
        translate([0, 0, tri_length]) rotate([0, -a, 0]) translate([0, 0, -tri_length]) cube([section_d, section_d, tri_length+section_d]);
    }
}

side();
gantry();
translate([0, gantry_width - section_d, 0]) side();