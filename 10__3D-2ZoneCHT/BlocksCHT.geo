// Kattmann, 06.06.2019, 3D 2 Zone Block mesh
// ------------------------------------------------------------------------- //
// Geometric inputs
length= 2;
width= 0.5;
lower_h= 1; // height of lower (solid) block
upper_h= 1; // height of upper (fluid) block

// Mesh inputs
gridsize = 0.1; // unimportant once everything is structured
Nx= 10;
Ny= 10;
Nz_lower= 10;
Rz_lower= 0.8;
Nz_upper= 10;
Rz_upper= 1.2;

// ------------------------------------------------------------------------- //
// Points
// Blocks of 4 points for eacj height(z) level, counting counterclockwise,
// starting from x,y={0,0}. 4*3 points
Point(1) = {0, 0, 0, gridsize};
Point(2) = {0, width, 0, gridsize};
Point(3) = {length, width, 0, gridsize};
Point(4) = {length, 0, 0, gridsize};

Point(5) = {0, 0, lower_h, gridsize};
Point(6) = {0, width, lower_h, gridsize};
Point(7) = {length, width, lower_h, gridsize};
Point(8) = {length, 0, lower_h, gridsize};

Point(9) = {0, 0, lower_h+upper_h, gridsize};
Point(10) = {0, width, lower_h+upper_h, gridsize};
Point(11) = {length, width, lower_h+upper_h, gridsize};
Point(12) = {length, 0, lower_h+upper_h, gridsize};

// ------------------------------------------------------------------------- //
// Lines
// Connecting z-layer counterclockwise, starting at x,y={0,0}, then Connecting
// lines with next level using the same logic. Repeat. 4*3 + 4*2 lines
Line(1) = {1,2};
Line(2) = {2,3};
Line(3) = {3,4};
Line(4) = {4,1};

Line(5) = {1,5};
Line(6) = {2,6};
Line(7) = {3,7};
Line(8) = {4,8};

Line(9) =  {5,6};
Line(10) = {6,7};
Line(11) = {7,8};
Line(12) = {8,5};

Line(13) = {5,9};
Line(14) = {6,10};
Line(15) = {7,11};
Line(16) = {8,12};

Line(17) = {9,10};
Line(18) = {10,11};
Line(19) = {11,12};
Line(20) = {12,9};

//-------------------------------------------------------------------------------------//
// Lineloops and surfaces
// Create (starting from low z) face pointing in z direction, then counterclockwise 
// starting with the y-z plane on the lower x coordinate
// bottom
Line Loop(1) = {1,2,3,4};
Plane Surface(1) = {1};

// lower faces
Line Loop(2) = {1,6,-9,-5};
Plane Surface(2) = {2};

Line Loop(3) = {2,7,-10,-6};
Plane Surface(3) = {3};

Line Loop(4) = {3,8,-11,-7};
Plane Surface(4) = {4};

Line Loop(5) = {4,5,-12,-8};
Plane Surface(5) = {5};

// middle 
Line Loop(6) = {9,10,11,12};
Plane Surface(6) = {6};

// upper faces
Line Loop(7) = {9,14,-17,-13};
Plane Surface(7) = {7};

Line Loop(8) = {10,15,-18,-14};
Plane Surface(8) = {8};

Line Loop(9) = {11,16,-19,-15};
Plane Surface(9) = {9};

Line Loop(10) = {12,13,-20,-16};
Plane Surface(10) = {10};

// top
Line Loop(11) = {17,18,19,20};
Plane Surface(11) = {11};

//-------------------------------------------------------------------------------------//
// Surface loops and volumes
If(1)
Surface Loop (1) = {1,2,3,4,5,6};
Volume(1) = {1};

Surface Loop (2) = {6,7,8,9,10,11};
Volume(2) = {2};
EndIf

//-------------------------------------------------------------------------------------//
//make structured mesh with transfinite lines
// in lenght(x) direction
Transfinite Line{2,4,10,12,18,20} = Nx;
// in width(y) direction
Transfinite Line{1,3,9,11,17,19} = Ny;
// lower block in z-direction (height)
Transfinite Line{5,6,7,8} = Nz_lower Using Progression Rz_lower;
// lower block in z-direction (height)
Transfinite Line{13,14,15,16} = Nz_upper Using Progression Rz_upper;

Transfinite Surface{1,2,3,4,5,6,7,8,9,10,11};
Recombine Surface{1,2,3,4,5,6,7,8,9,10,11};

Transfinite Volume{1,2};
Recombine Volume{1,2};

//-------------------------------------------------------------------------------------//
// Fluid
Physical Surface("inlet") = {7};
Physical Surface("outlet") = {9};
Physical Surface("fluid_top") = {11};
Physical Surface("fluid_sym") = {8,10};

// Solid
Physical Surface("solid_sym") = {3,5};
Physical Surface("solid_front") = {2};
Physical Surface("solid_back") = {4};
Physical Surface("bottom") = {1};

// Interface
Physical Surface("fluid_interface") = {6};
//Physical Surface("solid_interface") = {6};

Physical Volume("fluid") = {2};
Physical Volume("solid") = {1};

Mesh 3;