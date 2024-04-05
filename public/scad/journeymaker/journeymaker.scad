font1="Play";
serial="JM.XXX";
logo=true;

if ( logo ) {
    difference() {
    rotate([0,-90,0]) translate([3,0,4]) import("logoplate.stl", center=true); 
    rotate([90,0,0]) translate([0,6,-1]) linear_extrude(20) text(text=serial, font=font1, size=8, halign="center");
}
}
else{
    difference() {
    rotate([0,-90,0]) translate([3,0,0]) import("plate.stl", center=true); 
    rotate([90,0,0]) translate([0,6,-1]) linear_extrude(20) text(text=serial, font=font1, size=8, halign="center");
}
}