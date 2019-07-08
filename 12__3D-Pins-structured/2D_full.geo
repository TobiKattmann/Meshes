// Kattmann, 18.06.2019, 3D 2 Zone mesh
// ------------------------------------------------------------------------- //
// Geometric inputs in [mm]

// Which domain part should be handled
Which_Mesh_Part= 0;// 0=all, 1=Fluid, 2=Solid
// Evoque Meshing Algorithm?
Do_Meshing= 1; // 0=false, 1=true
// Write Mesh files in .su2 format
Write_mesh= 0; // 0=false, 1=true

// Free parameters
dist= 6.44; // distance between pin midpoints, each pin has 6 surrounding pins, i.e. 60 deg between each
r_pin_lower= 2.0; // lower pin radius
r_pin_upper= 1.5; // upper pin radius

// dependent parameters
rad2deg= Pi/180; // conversion factor as gmsh Cos/Sin functions take radian values
length= 2 * Cos(30*rad2deg)*dist; // length (in x-dir)
width= Sin(30*rad2deg)*dist; // width (in y-dir)

// fix parameters
upper_h= 10.0; // height (z-dir) of fluid domain/pins
lower_h= 5.0; // height (z-dir) of solid domain/pins

Printf("===================================");
Printf("Free parameters:");
Printf("-> distance between pins: %g", dist);
Printf("-> lower pin radius: %g", r_pin_lower);
Printf("-> upper pin radius: %g", r_pin_upper);
Printf("Dependent parameters");
Printf("-> length: %g", length);
Printf("-> width: %g", width);
Printf("Fixed parameters");
Printf("-> pin height: %g", upper_h);
Printf("-> solid thickness: %g", lower_h);
Printf("===================================");


// Mesh inputs
scale_factor =1; // scales Point positions from [mm] to [m] with 1e-3
gs = 2 *scale_factor; // gridsize

// interface meshing parameteres. Also sufficient for fluid domain meshing.
N_x_flow= 20; // #gridpoints in flow x-direction on a patch. Also N_x_flow/2 on smaller patches employed.

N_y_flow = 15; // #gridpoints normal to pin surface, y-direction
R_y_flow= 1.1; // Progression normal to pin surface

N_z_flow= 50; // #gridpoints in height z-direction
R_z_flow= 0.1; // Bump in height as top and bottom are walls

// Additional meshing parameters for solid domain
InnerRadiusFactor= 0.6; // How much of the inner pin is unstructured mesh (0.9=mostly unstructured, 0.1= mostly structured). Requires 0 < value < 1. 
N_y_innerPin= 10; // #gridpoints of the structured first part of the inner Pin in y-direction / normal to the pin
R_y_innerPin= 0.9; // Progression towards interface


// Feasability checks
If (r_pin_lower >= width || 
    r_pin_upper >= width ||
    r_pin_lower <= 0 ||
    r_pin_upper <= 0)
    Printf("Aborting! Bad Inputs");
    Abort;
EndIf

// ------------------------------------------------------------------------- //
// Point distribution rules:
// Line/curve orientation rules (in that order): 
//   1. always pointing in positive z-direction
//   2. in x-y-plane, always pointing in positive x-direction
//   3. in y-direction, always pointing in positive y-direction
// Surface normal orientation rules: none

// ------------------------------------------------------------------------- //
// CHT Interface, complete description as it is part of fluid and solid
// Id's starting with in the range (1-99)

// Points
// Lower Pin1
Point(10) = {0, width, 0, gs}; // lower pin1 midpoint
Point(11) = {0, width-r_pin_lower, 0, gs}; // lower pin1 on inlet
Point(12) = {Sin(30*rad2deg)*r_pin_lower, width-Cos(30*rad2deg)*r_pin_lower, 0, gs}; // lower pin1 in between
Point(13) = {r_pin_lower, width, 0, gs}; // lower pin1 on sym
Circle(10) = {11,10,12}; // lower pin1 smaller first part
Circle(11) = {12,10,13}; // lower pin1 larger second part

// Lower Pin2
Point(20) = {0.5*length, 0, 0, gs}; // pin midpoint
Point(21) = {0.5*length - r_pin_lower, 0, 0, gs}; // lower small x
Point(22) = {length/2 - Sin(30*rad2deg)*r_pin_lower, Cos(30*rad2deg)*r_pin_lower, 0, gs}; // small intermediate
Point(23) = {length/2 + Sin(30*rad2deg)*r_pin_lower, Cos(30*rad2deg)*r_pin_lower, 0, gs}; // large intermediate
Point(24) = {0.5*length + r_pin_lower, 0, 0, gs}; // lower large x
Circle(20) = {21,20,22}; // first segment
Circle(21) = {22,20,23}; // second segment
Circle(22) = {23,20,24}; // third segment

// lower Pin3
Point(30) = {length, width, 0, gs}; // midpoint
Point(31) = {length, width-r_pin_lower, 0, gs}; // on outlet
Point(32) = {length-Sin(30*rad2deg)*r_pin_lower, width-Cos(30*rad2deg)*r_pin_lower,0, gs};
Point(33) = {length - r_pin_lower, width, 0, gs}; // on sym
Circle(30) = {31,30,32}; // first segment
Circle(31) = {32,30,33}; // second segment

// lower additional structured mesh points
Point(40) = {length/4 + Tan(30*rad2deg)*width/2, width, 0, gs}; // first half, large y
Point(41) = {length/4 - Tan(30*rad2deg)*width/2, 0, 0, gs}; // first half, small y
Point(42) = {length*3/4 - Tan(30*rad2deg)*width/2, width, 0, gs}; // second half, large y
Point(43) = {length*3/4 + Tan(30*rad2deg)*width/2, 0, 0, gs}; // second half, small y
Point(44) = {0, 0, 0, gs}; // corner point inlet
Point(45) = {length, 0, 0, gs}; // corner point outlet

// lower additional structured mesh lines
// outer boundary
Line(40) = {11, 44};
Line(41) = {44, 41};
Line(42) = {41, 21};
Line(43) = {43, 24};
Line(44) = {43, 45};
Line(45) = {45, 31};
Line(46) = {33, 42};
Line(47) = {42, 40};
Line(48) = {40, 13};
// inner lines
Line(49) = {41, 12};
Line(50) = {41, 40};
Line(51) = {22, 40};
Line(52) = {23, 42};
Line(53) = {42, 43};
Line(54) = {43, 32};

// line loops and surfaces on lower domain interface
Line Loop(10) = {40, 41, 49, -10}; Plane Surface(10) = {10};
Line Loop(11) = {-49, 50, 48, -11}; Plane Surface(11) = {11};
Line Loop(12) = {42, 20, 51, -50}; Plane Surface(12) = {12};
Line Loop(13) = {-51, 21, 52, 47}; Plane Surface(13) = {13};
Line Loop(14) = {53, 43, -22, 52}; Plane Surface(14) = {14};
Line Loop(15) = {53, 54, 31, 46}; Plane Surface(15) = {15};
Line Loop(16) = {44, 45, 30, -54}; Plane Surface(16) = {16};

// No progression in flow direction on the pin surface
Transfinite Line {11,50,20,47,21,22,53,31} = N_x_flow;
Transfinite Line {10,41,30,44} = N_x_flow/2;
// Progression normal to the pin surface
Transfinite Line {40, -49, -48, -42, 51, 52, -43, 46, -54, -45} = N_y_flow Using Progression R_y_flow; 

// Upper Pin1
Point(10+100) = {0, width, upper_h, gs}; // lower pin1 midpoint
Point(11+100) = {0, width-r_pin_upper, upper_h, gs}; // lower pin1 on inlet
Point(12+100) = {Sin(30*rad2deg)*r_pin_upper, width-Cos(30*rad2deg)*r_pin_upper, upper_h, gs}; // lower pin1 in between
Point(13+100) = {r_pin_upper, width, upper_h, gs}; // lower pin1 on sym
Circle(10+100) = {11+100,10+100,12+100}; // lower pin1 smaller first part
Circle(11+100) = {12+100,10+100,13+100}; // lower pin1 larger second part

// Upper Pin2
Point(20+100) = {0.5*length, 0, upper_h, gs}; // pin midpoint
Point(21+100) = {0.5*length - r_pin_upper, 0, upper_h, gs}; // lower small x
Point(22+100) = {length/2 - Sin(30*rad2deg)*r_pin_upper, Cos(30*rad2deg)*r_pin_upper, upper_h, gs}; // small intermediate
Point(23+100) = {length/2 + Sin(30*rad2deg)*r_pin_upper, Cos(30*rad2deg)*r_pin_upper, upper_h, gs}; // large intermediate
Point(24+100) = {0.5*length + r_pin_upper, 0, upper_h, gs}; // lower large x
Circle(20+100) = {21+100,20+100,22+100}; // first segment
Circle(21+100) = {22+100,20+100,23+100}; // second segment
Circle(22+100) = {23+100,20+100,24+100}; // third segment

// Upper Pin3
Point(30+100) = {length, width, upper_h, gs}; // midpoint
Point(31+100) = {length, width-r_pin_upper, upper_h, gs}; // on outlet
Point(32+100) = {length-Sin(30*rad2deg)*r_pin_upper, width-Cos(30*rad2deg)*r_pin_upper, upper_h, gs};
Point(33+100) = {length - r_pin_upper, width, upper_h, gs}; // on sym
Circle(30+100) = {31+100,30+100,32+100}; // first segment
Circle(31+100) = {32+100,30+100,33+100}; // second segment

// connection in height/z-direction
// Pin1
Line(61) = {11,11+100};
Line(62) = {12,12+100};
Line(63) = {13,13+100};

// Pin2
Line(71) = {21,21+100};
Line(72) = {22,22+100};
Line(73) = {23,23+100};
Line(74) = {24,24+100};

// Pin3
Line(81) = {31,31+100};
Line(82) = {32,32+100};
Line(83) = {33,33+100};

// Pin surfaces
Line Loop(20) = {61, 10+100, -62, -10}; Surface(20) = {20};
Line Loop(21) = {62, 11+100, -63, -11}; Surface(21) = {21};
Line Loop(22) = {71, 20+100, -72, -20}; Surface(22) = {22};
Line Loop(23) = {73, -(21+100), -72, 21}; Surface(23) = {23};
Line Loop(24) = {74, -(22+100), -73, 22}; Surface(24) = {24};
Line Loop(25) = {83, -(31+100), -82, 31}; Surface(25) = {25};
Line Loop(26) = {82, -(30+100), -81, 30}; Surface(26) = {26};

Transfinite Line {11+100,20+100,21+100,22+100,31+100} = N_x_flow;
Transfinite Line {10+100,30+100} = N_x_flow/2;
Transfinite Line {61,62,63,71,72,73,74,81,82,83} = N_z_flow Using Bump R_z_flow;

Transfinite Surface "*";
Recombine Surface "*";

//Physical Tags
Physical Surface("bottom_interface") = {13, 14, 15, 12, 11, 16, 10};
Physical Surface("pin1") = {20, 21};
Physical Surface("pin2") = {24, 23, 22};
Physical Surface("pin3") = {25, 26};

// ------------------------------------------------------------------------- //
If (Which_Mesh_Part == 0 || Which_Mesh_Part == 1)
    // Fluid only description
    // upper additional structured mesh points
    Point(40+100) = {length/4 + Tan(30*rad2deg)*width/2, width, upper_h, gs}; // first half, large y
    Point(41+100) = {length/4 - Tan(30*rad2deg)*width/2, 0, upper_h, gs}; // first half, small y
    Point(42+100) = {length*3/4 - Tan(30*rad2deg)*width/2, width, upper_h, gs}; // second half, large y
    Point(43+100) = {length*3/4 + Tan(30*rad2deg)*width/2, 0, upper_h, gs}; // second half, small y
    Point(44+100) = {0, 0, upper_h, gs}; // corner point inlet
    Point(45+100) = {length, 0, upper_h, gs}; // corner point outlet

    // upper additional structured mesh lines
    // outer boundary
    Line(40+100) = {11+100, 44+100};
    Line(41+100) = {44+100, 41+100};
    Line(42+100) = {41+100, 21+100};
    Line(43+100) = {43+100, 24+100};
    Line(44+100) = {43+100, 45+100};
    Line(45+100) = {45+100, 31+100};
    Line(46+100) = {33+100, 42+100};
    Line(47+100) = {42+100, 40+100};
    Line(48+100) = {40+100, 13+100};
    // inner lines
    Line(49+100) = {41+100, 12+100};
    Line(50+100) = {41+100, 40+100};
    Line(51+100) = {22+100, 40+100};
    Line(52+100) = {23+100, 42+100};
    Line(53+100) = {42+100, 43+100};
    Line(54+100) = {43+100, 32+100};

    // line loops and surfaces on lower domain interface
    Line Loop(10+100) = {40+100, 41+100, 49+100, -(10+100)}; Plane Surface(10+100) = {10+100};
    Line Loop(11+100) = {-(49+100), 50+100, 48+100, -(11+100)}; Plane Surface(11+100) = {11+100};
    Line Loop(12+100) = {42+100, 20+100, 51+100, -(50+100)}; Plane Surface(12+100) = {12+100};
    Line Loop(13+100) = {-(51+100), 21+100, 52+100, 47+100}; Plane Surface(13+100) = {13+100};
    Line Loop(14+100) = {53+100, 43+100, -(22+100), 52+100}; Plane Surface(14+100) = {14+100};
    Line Loop(15+100) = {53+100, 54+100, 31+100, 46+100}; Plane Surface(15+100) = {15+100};
    Line Loop(16+100) = {44+100, 45+100, 30+100, -(54+100)}; Plane Surface(16+100) = {16+100};

    // No progression in flow direction on the pin surface
    Transfinite Line {50+100,47+100,53+100} = N_x_flow;
    Transfinite Line {41+100,44+100} = N_x_flow/2;
    // Progression normal to the pin surface
    Transfinite Line {40+100, -(49+100), -(48+100), -(42+100), 51+100, 52+100, -(43+100), 46+100, -(54+100), -(45+100)} = N_y_flow Using Progression R_y_flow;

    // Side Faces on the outside of the domain
    // additional lines in z-direction on fluid boundary
    Line(160) = {44, 144};
    Line(161) = {41, 141};
    Line(162) = {43, 143};
    Line(163) = {45, 145};
    Line(164) = {42, 142};
    Line(165) = {40, 140};
    Transfinite Line {160,161,162,163,164,165} = N_z_flow Using Bump 0.1;

    // Side-faces
    Line Loop(117) = {61, 140, -160, -40}; Surface(117) = {117};
    Line Loop(118) = {160, 141, -161, -41}; Surface(118) = {118};
    Line Loop(119) = {161, 142, -71, -42}; Surface(119) = {119};
    Line Loop(120) = {74, -143, -162, 43}; Surface(120) = {120};
    Line Loop(121) = {162, 144, -163, -44}; Surface(121) = {121};
    Line Loop(122) = {163, 145, -81, -45}; Surface(122) = {122};
    Line Loop(123) = {83, 146, -164, -46}; Surface(123) = {123};
    Line Loop(124) = {164, 147, -165, -47}; Surface(124) = {124};
    Line Loop(125) = {165, 148, -63, -48}; Surface(125) = {125};

    // Internal fluid faces
    Line Loop(126) = {62, -149, -161, 49}; Surface(126) = {126};
    Line Loop(127) = {165, -150, -161, 50}; Surface(127) = {127};
    Line Loop(128) = {165, -151, -72, 51}; Surface(128) = {128};
    Line Loop(129) = {164, -152, -73, 52}; Surface(129) = {129};
    Line Loop(130) = {164, 153, -162, -53}; Surface(130) = {130};
    Line Loop(131) = {82, -154, -162, 54}; Surface(131) = {131};

    // Definition
    Surface Loop(1) = {110, 117, 20, 10, 118, 126}; Volume(1) = {1};
    Surface Loop(2) = {111, 125, 21, 11, 126, 127}; Volume(2) = {2};
    Surface Loop(3) = {112, 119, 22, 12, 127, 128}; Volume(3) = {3};
    Surface Loop(4) = {113, 23, 13, 124, 128, 129}; Volume(4) = {4};
    Surface Loop(5) = {114, 120, 24, 14, 129, 130}; Volume(5) = {5};
    Surface Loop(6) = {115, 25, 123, 15, 130, 131}; Volume(6) = {6};
    Surface Loop(7) = {116, 121, 122, 26, 16, 131}; Volume(7) = {7};

    Transfinite Surface "*";
    Recombine Surface "*";
    Transfinite Volume "*";

    //Physical Tags
    Physical Volume("fluid_volume") = {1, 2, 3, 4, 5, 7, 6};
    Physical Surface("top_fluid") = {110, 111, 112, 113, 114, 115, 116};
    Physical Surface("inlet_fluid") = {117};
    Physical Surface("outlet_fluid") = {122};
    Physical Surface("sym_sides_fluid") = {119, 118, 120, 121, 123, 124, 125};

EndIf
// ------------------------------------------------------------------------- //
// Solid only description
If (Which_Mesh_Part == 0 || Which_Mesh_Part == 2)
    // 200-er range reserved for 2nd copy of bottom interface mesh

    // Solid inner pin and bottom300-er range
    // pin 1 lower 
    Point(301) = {InnerRadiusFactor*0, width-r_pin_lower*InnerRadiusFactor, 0, gs}; // lower pin1 on inlet
    Point(302) = {InnerRadiusFactor*Sin(30*rad2deg)*r_pin_lower, width-Cos(30*rad2deg)*r_pin_lower*InnerRadiusFactor, 0, gs}; // lower pin1 in between
    Point(303) = {InnerRadiusFactor*r_pin_lower, width, 0, gs}; // lower pin1 on sym
    Circle(301) = {301,10,302};
    Circle(302) = {302,10,303};

    // pin 1 upper
    Point(304) = {InnerRadiusFactor*0, width-r_pin_upper*InnerRadiusFactor, upper_h, gs}; // lower pin1 on inlet
    Point(305) = {InnerRadiusFactor*Sin(30*rad2deg)*r_pin_upper, width-Cos(30*rad2deg)*r_pin_upper*InnerRadiusFactor, upper_h, gs}; // lower pin1 in between
    Point(306) = {InnerRadiusFactor*r_pin_upper, width, upper_h, gs}; // lower pin1 on sym
    Circle(303) = {304,110,305};
    Circle(304) = {305,110,306};

    // pin 1 additional lines
    Line(305) = {10, 301};
    Line(306) = {301, 11};
    Line(307) = {10, 303};
    Line(308) = {303, 13};
    Line(309) = {110, 304};
    Line(310) = {304, 111};
    Line(311) = {110, 306};
    Line(312) = {306, 113};
    Line(317) = {305, 112};
    Line(318) = {302, 12};

    // pin1 in z-direction
    Line(313) = {301, 304};
    Line(314) = {302, 305};
    Line(315) = {303, 306};
    Line(316) = {10, 110};

    // pin1 Line loop and surface definition
    Line Loop(27) = {313, 310, -61, -306}; Plane Surface(27) = {27};
    Line Loop(28) = {316, 309, -313, -305}; Plane Surface(28) = {28};
    Line Loop(29) = {315, -311, -316, 307}; Plane Surface(29) = {29};
    Line Loop(30) = {315, -304, -314, 302}; Surface(30) = {30};
    Line Loop(31) = {314, -303, -313, 301}; Surface(31) = {31};
    Line Loop(32) = {308, -11, -318, 302}; Plane Surface(32) = {32};
    Line Loop(33) = {318, -10, -306, 301}; Plane Surface(33) = {33};
    Line Loop(34) = {307, -302, -301, -305}; Plane Surface(34) = {34};
    Line Loop(35) = {304, 312, -111, -317}; Plane Surface(35) = {35};
    Line Loop(36) = {317, -110, -310, 303}; Plane Surface(36) = {36};
    Line Loop(37) = {311, -304, -303, -309}; Plane Surface(37) = {37};
    Line Loop(38) = {63, -312, -315, 308}; Plane Surface(38) = {38};
    Line Loop(39) = {317, -62, -318, 314}; Plane Surface(39) = {39};

    Surface Loop(8) = {33, 27, 36, 20, 39, 31}; Volume(8) = {8};
    Surface Loop(9) = {32, 38, 21, 35, 30, 39}; Volume(9) = {9};

    Transfinite Line {111,304,11,302} = N_x_flow;
    Transfinite Line {110,303,10,301} = N_x_flow/2;

    Transfinite Line {306,318,308,310,317,312} = N_y_innerPin Using Progression R_y_innerPin;

    Transfinite Line {313,314,315} = N_z_flow Using Bump R_z_flow;

    Transfinite Surface "*";
    Recombine Surface "*";

EndIf


// ------------------------------------------------------------------------- //
// Scale by a factor, everything beyond point position definition is just 
// connection and therefor independent of the scale
//all_points[] = Point '*';
//Dilate {{0, 0, 0}, {scale_factor, scale_factor, scale_factor}} {
//   Point{all_points[]}; // Select all Points
//}

// ------------------------------------------------------------------------- //
//Mesh 2;
//all_points[]= Point '*';
//Translate {0, 0, 10} {
//  Duplicata { Point{all_points[]}; }
//}

// ------------------------------------------------------------------------- //
// Meshing
Transfinite Surface "*";
Recombine Surface "*";
Transfinite Volume "*";

If (Do_Meshing == 1)
    Mesh 1; Mesh 2; Mesh 3;
EndIf

// ------------------------------------------------------------------------- //
// Write .su2 meshfile
If (Write_mesh == 1)

    Mesh.Format = 42; // .su2 mesh format, 
    If (Which_Mesh_Part == 1)
        Save "fluid.su2";
    ElseIf (Which_Mesh_Part == 2)
        Save "solid.su2";
    Else
        Printf("Unvalid Which_Mesh_Part variable for output writing.");
        Abort;
    EndIf

EndIf
