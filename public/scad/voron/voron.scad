font1="Play";
serial="VX.XXX";
logo=true;
use1515=false;
serial_length=len(serial);

baseplate6= logo ? "2020logo.stl" : "2020nologo.stl";
baseplate7= logo ? "2020logo7.stl" : "2020nologo7.stl";
baseplate2020= (serial_length<7)? baseplate6 : baseplate7;

baseplate0= logo ? "1515logo.stl" : "1515nologo.stl";
baseplate= use1515 ? baseplate0 : baseplate2020;

length_to_move= use1515 ? (serial_length<=7)? -41.5 : -46.5 : (serial_length<7)? -41.5 : -46.5;


difference(font1, serial, logo) {
    rotate([0,180,0]) translate([length_to_move,0,-20]) import(baseplate, center=true); 
    rotate([90,0,0]) translate([0,6,-1]) linear_extrude(20) text(text=serial, font=font1, size=8, halign="center");
}