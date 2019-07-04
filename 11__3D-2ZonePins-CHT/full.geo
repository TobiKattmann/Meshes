// Kattmann, 18.06.2019, 3D 2 Zone mesh
// ------------------------------------------------------------------------- //
// Geometric inputs in [mm]
length= 11; // in x-dir
width= 3; // in y dir
lower_h= 5; // height of lower (solid) block, lower block goes from zero z-Coord to negative
upper_h= 10; // height of upper (fluid) block

// Pin quantities
// height determined by upper_h, i.e. no gap on top of Points
radius_lower= 2; // usually larger than radius_upper (castable)
radius_upper= 2;

// Mesh inputs
scale_factor = 1e-3; // scales Point positions from [mm] to [m] with 1e-3
gridsize = 2 *scale_factor; 
Nx= 10;
Ny= 10;
Nz_lower= 10;
Rz_lower= 0.8;
Nz_upper= 10;
Rz_upper= 1.2;

// Feasability checks
If (radius_lower >= width || 
    radius_upper >= width ||
    radius_lower <= 0 ||
    radius_upper <= 0)
    Printf("Aborting! Bad Inputs");
    Abort;
EndIf

// ------------------------------------------------------------------------- //
// Points
// Blocks of 4 points for each height(z) level, counting counterclockwise,
// starting from x,y={0,0}. 4*3 points
Point(1) = {0, 0, -lower_h, gridsize};
Point(2) = {0, width, -lower_h, gridsize};
Point(3) = {length, width, -lower_h, gridsize};
Point(4) = {length, 0, -lower_h, gridsize};

Point(5) = {0, 0, 0, gridsize};
Point(6) = {0, width, 0, gridsize};
Point(7) = {length, width, 0, gridsize};
Point(8) = {length, 0, 0, gridsize};

Point(9) = {0, 0, upper_h, gridsize};
Point(10) = {0, width, upper_h, gridsize};
Point(11) = {length, width, upper_h, gridsize};
Point(12) = {length, 0, upper_h, gridsize};

// additional points to construct pins
// pin1 x=0, quarter pin
Point(13) = {0, width-radius_lower, 0 , gridsize}; // lower on inlet
Point(14) = {radius_lower, width, 0, gridsize}; // lower on sym
Point(15) = {0, width-radius_upper, upper_h, gridsize}; // upper on inlet
Point(16) = {radius_upper, width, upper_h, gridsize}; // upper on sym

// pin2 x=0.5*lenght, half pin
Point(17) = {0.5*length - radius_lower, 0, 0, gridsize}; // lower small x
Point(18) = {0.5*length + radius_lower, 0, 0, gridsize}; // lower large x
Point(19) = {0.5*length - radius_upper, 0, upper_h, gridsize}; // upper small x
Point(20) = {0.5*length + radius_upper, 0, upper_h, gridsize}; // upper large x
//additional middle points for pin2
Point(21) = {0.5*length, 0, 0, gridsize};
Point(22) = {0.5*length, 0, upper_h, gridsize};

// pin1 x=length, quarter pin
Point(23) = {length, width-radius_lower, 0 , gridsize}; // lower on oulet
Point(24) = {length - radius_lower, width, 0, gridsize}; // lower on sym
Point(25) = {length, width-radius_upper, upper_h, gridsize}; // upper on outlet
Point(26) = {length - radius_upper, width, upper_h, gridsize}; // upper on sym

// ------------------------------------------------------------------------- //
// Scale by a factor, everything beyond point position definition is just 
// connection and therefor independent of the scale
all_points[] = Point '*';
Dilate {{0, 0, 0}, {scale_factor, scale_factor, scale_factor}} {
   Point{all_points[]}; // Select all Points
}

// ------------------------------------------------------------------------- //
// Lines
// Connecting z-layer counterclockwise, starting at x,y={0,0}, then Connecting
// lines with next level using the same logic. Repeat. 4*3 + 4*2 lines

// bottom layer
Line(1) = {1,2};
Line(2) = {2,3};
Line(3) = {3,4};
Line(4) = {4,1};

// upward facing from bottom to middle layer
Line(5) = {1,5};
Line(6) = {2,6};
Line(7) = {3,7};
Line(8) = {4,8};

// upward facing from middle to top layer
Line(13) = {5,9};
Line(14) = {6,10};
Line(15) = {7,11};
Line(16) = {8,12};

// ------------------------------------------------------------------------- //
// Pins  
// Front pin 1, low x
Circle(100) = {13, 6,14}; // Pin1 lower
Circle(101) = {15,10,16}; // Pin1 upper
Line(102) = {13,15}; // Pin1 inlet
Line(103) = {14,16}; // Pin1 sym
Line(104) = {15,10}; Line(105) = {10,16}; // top corner
Line(106) = {13,6}; Line(107) = {6,14}; // bottom corner

Line Loop(100) = {104,105,-101}; Plane Surface(100) = {100}; // Pin 1, top
Line Loop(101) = {106,107,-100}; Plane Surface(101) = {101}; // Pin 1, bottom
Line Loop(102) = {106,14,-104,-102}; Plane Surface(102) = {102}; // Pin 1, inlet
Line Loop(103) = {-14,107,103,-105}; Plane Surface(103) = {103}; // Pin 1, sym
Line Loop(104) = {100,-102,-101,103}; Surface(104) = {104}; // Pin 1, pin interface
Surface Loop(100) = {100,101,102,103,104}; Volume (100) = {100};

// ------------------------------------------------------------------------- //
// middle pin 2
Circle(110) = {18,21,17}; // Pin2 lower
Circle(111) = {20,22,19}; // Pin2 upper
Line(112) = {17,19}; // Pin2 small x
Line(113) = {18,20}; // Pin2 large x
// split into two lines, surface takes 3/4 lines min
Line(116) = {19,22}; 
Line(117) = {22,20};
Line(118) = {17,21};
Line(119) = {21,18};

Line Loop(110) = {-110, -112, 111, 113}; Surface(110) = {110}; // Pin2 surfaces, interface
Line Loop(111) = {111, 116, 117}; Plane Surface(111) = {111}; // Pin2 surfaces, top pin
Line Loop(112) = {110, 118, 119}; Plane Surface(112) = {112}; // Pin2 surfaces, bottom pin 
Line Loop(113) = {118,119, 113, -116,-117, - 112}; Plane Surface(113) = {113}; // Pin2 surfaces, sym
Surface Loop(110) = {110,111,112,113}; Volume(110) = {110};

// ------------------------------------------------------------------------- //
// back pin 3, high x value
Circle(120) = {23, 7,24}; // Pin3 lower
Circle(121) = {25,11,26}; // Pin3 upper
Line(122) = {23,25}; // Pin1 inlet
Line(123) = {24,26}; // Pin1 sym
// split corners into 2 lines as surface take 3 min
Line(124) = {26,11}; Line(125) = {11,25}; // top corner
Line(126) = {24,7}; Line(127) = {7,23}; // bottom corner

Line Loop(120) = {124,125,121}; Plane Surface(120) = {120}; // Pin 3, top
Line Loop(121) = {126,127,120}; Plane Surface(121) = {121}; // Pin 3, bottom
Line Loop(122) = {127,122,-125,-15}; Plane Surface(122) = {122}; // Pin 3, outlet
Line Loop(123) = {126,15,-124,-123}; Plane Surface(123) = {123}; // Pin 3, sym
Line Loop(124) = {120,-122,-121,123}; Surface(124) = {124}; // Pin 3, interface
Surface Loop(120) = {120,121,122,123,124}; Volume(120) = {120};

// ------------------------------------------------------------------------- //
// Fluid Volume
// Additional Lines
Line(130) = {13,5}; // lower inlet
Line(131) = {15,9}; // upper inlet

Line(132) = {8,23}; // lower outlet
Line(133) = {12,25}; // upper outlet

Line(134) = {5,17}; // sym left 1, lower
Line(135) = {9,19}; // sym left 1, upper

Line(136) = {18,8}; // sym left 2, lower
Line(137) = {20,12}; // sym left 2, upper

Line(138) = {26,16}; // sym right upper
Line(139) = {24,14}; // sym right lower

// Lineloops and Surfaces
Line Loop(130) = {-130,102,131,-13}; Plane Surface(130) = {130}; // inlet
Line Loop(131) = {132,122,-133,-16}; Plane Surface(131) = {131}; // outlet
Line Loop(132) = {-134,13,135,-112}; Plane Surface(132) = {132}; // sym left 1, lower x (seen in positive x-dir)
Line Loop(133) = {-136,113,137,-16}; Plane Surface(133) = {133}; // sym left 2, higher x (seen in positive x-dir)
Line Loop(134) = {139,103,-138,-123}; Plane Surface(134) = {134}; // sym right (seen in positive x-dir)
Line Loop(135) = {135,-111,137,133,121,138,-101,131}; Plane Surface(135) = {135}; // top
Line Loop(136) = {134,-110,136,132,120,139,-100,130}; Plane Surface(136) = {136}; // bottom
Surface Loop(130) = {130,131,132,133,134,135,136,104,110,124}; Volume(130) = {130}; // 13? surfaces + Pin surfaces
Physical Volume("fluid") = {130};


// ------------------------------------------------------------------------- //
// Solid Bottom Volume (without pins which are already meshed)

Line Loop(140) = {1,6,-106,130,-5}; Plane Surface(140) = {140}; // Front
Line Loop(141) = {-3,7,127,-132,-8}; Plane Surface(141) = {141}; // back
Line Loop(142) = {4,5,134,118,119,136,-8}; Plane Surface(142) = {142}; // sym right
Line Loop(143) = {2,7,-126,139,-107,-6}; Plane Surface(143) = {143}; // sym left
Line Loop(144) = {1,2,3,4}; Plane Surface(144) = {144};// heater surfacer
// top (start of pins)
Surface Loop(140) = {140,141,142,143,144,136,121,112,101}; Volume(140) = {140};
//Physical Volume("solid") = {140,100,110,120};




// ------------------------------------------------------------------------- //
// Physical Tags

// Fluid specific
Physical Surface("inlet_fluid") = {130};
Physical Surface("outlet_fluid") = {131};
Physical Surface("sym-sides_fluid") = {132,133,134};
Physical Surface("top-wall_fluid") = {135};

// Solid specific
Physical Surface("front_solid") = {140};
Physical Surface("back_solid") = {141};
Physical Surface("sym-sides_solid") = {142,143, 103,113,123};
Physical Surface("bottom_solid") = {144};
Physical Surface("pin1-tip_solid") = {100};
Physical Surface("pin2-tip_solid") = {111};
Physical Surface("pin3-tip_solid") = {120};
Physical Surface("pin1-front_solid") = {102};
Physical Surface("pin3-back_solid") = {122};

// interface
Physical Surface("pin1-interface_fluid") = {104};
Physical Surface("pin1-interface_solid") = {104};

Physical Surface("pin2-interface_fluid") = {110};
Physical Surface("pin2-interface_solid") = {110};

Physical Surface("pin3-interface_fluid") = {124};
Physical Surface("pin3-interface_solid") = {124};

Physical Surface("bottom-interface_fluid") = {136};
Physical Surface("bottom-interface_solid") = {136};

//Mesh 2;
//Mesh 3;
//Abort;