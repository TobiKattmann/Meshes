// ----------------------------------------------------------------------------------- //
// Kattmann 18.04.2023, O mesh for airfoil (points list given)
// The fully structured O mesh around the airfoil consists out of two half cylinders.
// ----------------------------------------------------------------------------------- //

// Evoque Meshing Algorithm?
Do_Meshing= 1; // 0=false, 1=true
// Write Mesh files in .cgns format
Write_mesh= 1; // 0=false, 1=true
mesh_name= "Cmesh.cgns";
// Control the number of cells and progression parameters
Mesh_parameter= 3;

//Geometric inputs
airfoil_length = 1;
z_thickness= 0.01;
// The farfield is a circle around (0,0,0) with the radius mesh_radius
front_radius = 20 * airfoil_length;
back_extension = 20 * airfoil_length;

// ----------------------------------------------------------------------------------- //
//Mesh inputs
gridsize = 0.1; // not relevant for fully structured grid, but we still have to provide it
If (Mesh_parameter == 1)
  Nairfoil = 8;
  Rfarfield= 1.0;
  Nradial = 40;
  Rradial = 1.2;
  Nback = 25;
  Rback = 1.1;
ElseIf (Mesh_parameter == 2)
  // Requirements
  // 1. first cell height 1e-5 -> achieved by adding a helper point 1e-5 away from wall and dialing in manually
  // 2. farfield at 20 chord -> see front_radius and back_extension above
  // 3. 256 points on the airfoil -> there are 4 section on the airfoil and 2x2 arcs have the same length.
  // Note that we set the set the number of points in a section with Nx but the patches intersect in 4 locations,
  // so when adding up the Nx contributions we have to substract 4.
  // Choose N1 arbitrary, compute (N1-1)*2 + (N2-1)*2 = 256 => N2 = 130 - N1 and dial in a smooth transition.
  Nairfoil = 12;
  Rfarfield= 1.0;
  Nradial = 130;
  Rradial = 1.1;
  Nback = 100;
  Rback = 1.05;
ElseIf (Mesh_parameter == 3)
  // Requirements
  // 1. first cell height 2e-5 -> achieved by adding a helper point 2e-5 away from wall and dialing in manually
  // 2. farfield at 20 chord -> see front_radius and back_extension above
  // 3. 656 points on the surface
  Nairfoil = 330;
  Rfarfield= 1.02;
  Nradial = 130;
  Rradial = 1.094;
  Nback = 120;
  Rback = 1.05;
EndIf

// ----------------------------------------------------------------------------------- //
// Airfoil Points
Point(1)  = { 0.00000,   0.00000, 0.0, gridsize}; // Leading edge
Point(500)  = {-2e-5,    0.00000, z_thickness, gridsize}; // helper point to dial in first cell height
Point(2)  = {  .00049,    .00403, 0.0, gridsize};
Point(3)  = {  .00509,    .01446, 0.0, gridsize};
Point(4)  = {  .01393,    .02573, 0.0, gridsize};
Point(5)  = {  .02687,    .03729, 0.0, gridsize};
Point(6)  = {  .04383,    .04870, 0.0, gridsize};
Point(7)  = {  .06471,    .05964, 0.0, gridsize};
Point(8)  = {  .08936,    .06984, 0.0, gridsize};
Point(9)  = {  .11761,    .07904, 0.0, gridsize};
Point(10) = {  .14925,    .08707, 0.0, gridsize};
Point(11) = {  .18404,    .09374, 0.0, gridsize};
Point(12) = {  .22169,    .09892, 0.0, gridsize};
Point(13) = {  .26187,    .10247, 0.0, gridsize};
Point(14) = {  .30422,    .10425, 0.0, gridsize};
Point(15) = {  .34839,    .10405, 0.0, gridsize};
Point(16) = {  .39438,    .10162, 0.0, gridsize};
Point(17) = {  .44227,    .09729, 0.0, gridsize};
Point(18) = {  .49172,    .09166, 0.0, gridsize};
Point(19) = {  .54204,    .08515, 0.0, gridsize};
Point(20) = {  .59256,    .07801, 0.0, gridsize};
Point(21) = {  .64262,    .07047, 0.0, gridsize};
Point(22) = {  .69155,    .06272, 0.0, gridsize};
Point(23) = {  .73872,    .05493, 0.0, gridsize};
Point(24) = {  .78350,    .04724, 0.0, gridsize};
Point(25) = {  .82530,    .03977, 0.0, gridsize};
Point(26) = {  .86357,    .03265, 0.0, gridsize};
Point(27) = {  .89779,    .02594, 0.0, gridsize};
Point(28) = {  .92749,    .01974, 0.0, gridsize};
Point(29) = {  .95224,    .01400, 0.0, gridsize};
Point(30) = {  .97197,    .00862, 0.0, gridsize};
Point(31) = {  .98686,    .00398, 0.0, gridsize};
Point(32) = {  .99656,    .00098, 0.0, gridsize};
Point(33) = { 1.00000,    .00000, 0.0, gridsize}; // trailing edge
// Point(34) = { 0.00000,   0.00000, 0.0, gridsize}; // also leading edge 
Point(35) = {  .00073,   -.00439, 0.0, gridsize};
Point(36) = {  .00709,   -.01154, 0.0, gridsize};
Point(37) = {  .01956,   -.01883, 0.0, gridsize};
Point(38) = {  .03708,   -.02594, 0.0, gridsize};
Point(39) = {  .05933,   -.03254, 0.0, gridsize};
Point(40) = {  .08609,   -.03847, 0.0, gridsize};
Point(41) = {  .11708,   -.04361, 0.0, gridsize};
Point(42) = {  .15200,   -.04787, 0.0, gridsize};
Point(43) = {  .19050,   -.05121, 0.0, gridsize};
Point(44) = {  .23218,   -.05357, 0.0, gridsize};
Point(45) = {  .27659,   -.05494, 0.0, gridsize};
Point(46) = {  .32326,   -.05529, 0.0, gridsize};
Point(47) = {  .37167,   -.05462, 0.0, gridsize};
Point(48) = {  .42127,   -.05291, 0.0, gridsize};
Point(49) = {  .47150,   -.05009, 0.0, gridsize};
Point(50) = {  .52175,   -.04614, 0.0, gridsize};
Point(51) = {  .57122,   -.04063, 0.0, gridsize};
Point(52) = {  .62019,   -.03250, 0.0, gridsize};
Point(53) = {  .67014,   -.02231, 0.0, gridsize};
Point(54) = {  .72107,   -.01221, 0.0, gridsize};
Point(55) = {  .77156,   -.00364, 0.0, gridsize};
Point(56) = {  .82012,    .00278, 0.0, gridsize};
Point(57) = {  .86536,    .00667, 0.0, gridsize};
Point(58) = {  .90576,    .00792, 0.0, gridsize};
Point(59) = {  .93978,    .00696, 0.0, gridsize};
Point(60) = {  .96638,    .00478, 0.0, gridsize};
Point(61) = {  .98520,    .00242, 0.0, gridsize};
Point(62) = {  .99633,    .00065, 0.0, gridsize};
// Point(63) = { 1.00000,    .00000, 0.0, gridsize}; // also trailing edge

// upper section airfoil
// Spline(1) = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33};
Spline(1) = {33,32,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1};
// bottom section airfoil
Spline(2) = {1,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,33};

// ----------------------------------------------------------------------------------- //
// Points for the front half circle
Point(100) = {airfoil_length, 0, 0, gridsize}; // circle mid point
Point(110) = {-front_radius+airfoil_length, 0, 0, gridsize}; // half cylinder most left point
// Additional points for the quarter cylinder
Point(101) = {airfoil_length, front_radius, 0, gridsize}; // top half cylinder
Point(102) = {airfoil_length, -front_radius, 0, gridsize}; // bottom half cylinder

Circle(200) = {101, 100, 110}; // top quarter cylinder farfield
Circle(201) = {102, 100, 110}; // bottom quarter cylinder farfield
Line(202) = {1, 110}; // airfoil front to farfield 

Point(103) = {back_extension, front_radius, 0, gridsize}; // top right corner
Point(104) = {back_extension, -front_radius, 0, gridsize}; // bottom right corner
Point(105) = {back_extension, 0, 0, gridsize}; // middle right 

// Connecting lines between back points
Line(101) = {33, 105}; // upper airfoil tip to middle
Line(102) = {105, 103}; // middle to top right
Line(103) = {103, 101}; // top right to half cylinder
Line(104) = {102, 104}; // half cylinder to bottom left
Line(105) = {104, 105};// bottom left to middle

// Separate back boxes from middle boxes
Line(106) = {33, 101}; // airfoil tip top half cylinder 
Line(107) = {33, 102}; // airfoil tip bottom half cylinder 

// ----------------------------------------------------------------------------------- //
// Create Surfaces (counter-clockwise line loops, starting at airfoil tip)

// top front
Curve Loop(1) = {200, -202, -1, 106};
Plane Surface(1) = {1};
// bottom front
Curve Loop(2) = {202, -201, -107, -2};
Plane Surface(2) = {2};

// top back box
Line Loop(3) = {101, 102, 103, -106};
Plane Surface(3) = {3};
// bottom back box
Line Loop(4) = {107, 104, 105, -101};
Plane Surface(4) = {4};

// ----------------------------------------------------------------------------------- //
// extrude all surfaces 0.2 in z-direction
Extrude {0, 0, z_thickness} {
  Surface{1}; Surface{2}; Surface{3}; Surface{4}; 
}

// create named sections for bcs
Physical Surface("symmetry", 301) = {224, 1, 268, 3, 290, 4, 246, 2};
Physical Surface("airfoil_upper", 302) = {219};
Physical Surface("airfoil_lower", 304) = {245};
Physical Surface("fafield", 303) = {211, 263, 237, 281, 285, 259};

Physical Volume("volume") = {1, 2, 3, 4};

// ----------------------------------------------------------------------------------- //
// Mesh definition
// Make structured mesh with transfinite lines

// airfoil surface
Transfinite Curve {1, 2, 206, 229} = Nairfoil;
// quarter cylinder surface
Transfinite Curve {204, 200, -227, 201} = Nairfoil Using Progression Rfarfield;

// radial part
Transfinite Curve {102, 249, 207, 106, 202, -205, 107, -228, -105, -272} = Nradial Using Progression Rradial;

// back box
Transfinite Curve{-103, 101, 104} = Nback Using Progression Rback;
Transfinite Curve {271, 248, -250} = Nback Using Progression Rback;

// 1 cell in depth
Transfinite Curve {214, 218, 209, 258, 254, 210, 236, 280, 280} = 3 Using Progression 1.0;

// ----------------------------------------------------------------------------------- //

Transfinite Surface "*";
Recombine Surface "*";
Transfinite Volume "*";
// Recombine Volume "*";

If (Do_Meshing == 1)
    Mesh 1; Mesh 2; Mesh 3;
EndIf

// ----------------------------------------------------------------------------------- //
// Write .cgns meshfile
If (Write_mesh == 1)

    Mesh.Format = 32; // .msh mesh format 
    Save Str(mesh_name);

EndIf
