module square_section(h, t, l, miter) {
	box_section(h, h, t, l, miter);
}

module box_section(h, w, t, l, miter) {
	//echo(str(l, "mm box ", h, "x", w, "x", t, "mm"));
	translate([h/2, w/2, 0]) render() difference() {
		linear_extrude(l) translate([-w/2, -h/2]) difference() {
			polygon([[0, 0], [0, h], [w, h], [w, 0]]);
			polygon([[t, t], [t, h-t], [w-t, h-t], [w-t, t]]);
		}
		if (miter) {
			translate([h/2, 0, 0]) rotate([0, 45, 0]) translate([-h*2, -w, -h]) cube([h*3, w*2, h]);
			translate([h/2, 0, l]) rotate([0, -45, 0]) translate([-h*2, -w, 0]) cube([h*3, w*2, h]);
		}
	}
}

module angle_section(h, w, t, l) {
	//echo(str(l, "mm angle ", h, "x", w, "x", t, "mm"));
	linear_extrude(l) translate([-w/2, -h/2]) {
		polygon([[0, 0], [h, 0], [h, t], [t, t], [t, w], [0, w]]);
	}
}

square_section(10, 1, 100);