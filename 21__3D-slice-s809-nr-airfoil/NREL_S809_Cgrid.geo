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
// The farfield is a circle around (0,0,0) with the radius mesh_radius
front_radius = 20 * airfoil_length;
back_extension = 20 * airfoil_length;

// ----------------------------------------------------------------------------------- //
//Mesh inputs
gridsize = 0.1; // not relevant for fully structured grid, but we still have to provide it
If (Mesh_parameter == 1)
  Nairfoil = 8;
  Nradial = 40;
  Rradial = 1.2;
  Nback = 25;
  Rback = 1.1;
  Nmiddle = 50;
ElseIf (Mesh_parameter == 2)
  // Requirements
  // 1. first cell height 1e-5 -> achieved by adding a helper point 1e-5 away from wall and dialing in manually
  // 2. farfield at 20 chord -> see front_radius and back_extension above
  // 3. 256 points on the airfoil -> there are 4 section on the airfoil and 2x2 arcs have the same length.
  // Note that we set the set the number of points in a section with Nx but the patches intersect in 4 locations,
  // so when adding up the Nx contributions we have to substract 4.
  // Choose N1 arbitrary, compute (N1-1)*2 + (N2-1)*2 = 256 => N2 = 130 - N1 and dial in a smooth transition.
  Nairfoil = 12;
  Nradial = 130;
  Rradial = 1.1;
  Nback = 100;
  Rback = 1.05;
  Nmiddle = 118;
ElseIf (Mesh_parameter == 3)
  // Requirements
  // 1. first cell height 2e-5 -> achieved by adding a helper point 2e-5 away from wall and dialing in manually
  // 2. farfield at 20 chord -> see front_radius and back_extension above
  // 3. 656 points on the surface
  Nairfoil = 30;
  Nradial = 130;
  Rradial = 1.094;
  Nback = 120;
  Rback = 1.05;
  Nmiddle = 300;
EndIf

// ----------------------------------------------------------------------------------- //
// Airfoil Points
Point(1)  = {1.000000,   0.000000, 0, gridsize}; // Tail point
Point(2)  = {0.996203,   0.000487, 0, gridsize};
Point(3)  = {0.985190,   0.002373, 0, gridsize};
Point(4)  = {0.967844,   0.005960, 0, gridsize};
Point(5)  = {0.945073,   0.011024, 0, gridsize};
Point(6)  = {0.917488,   0.017033, 0, gridsize};
Point(7)  = {0.885293,   0.023458, 0, gridsize};
Point(8)  = {0.848455,   0.030280, 0, gridsize};
Point(9)  = {0.807470,   0.037766, 0, gridsize};
Point(10) = {0.763042,   0.045974, 0, gridsize};
Point(11) = {0.715952,   0.054872, 0, gridsize};
Point(12) = {0.667064,   0.064353, 0, gridsize};
Point(13) = {0.617331,   0.074214, 0, gridsize};
Point(14) = {0.567830,   0.084095, 0, gridsize};
Point(15) = {0.519832,   0.093268, 0, gridsize};
Point(16) = {0.474243,   0.099392, 0, gridsize};
Point(17) = {0.428461,   0.101760, 0, gridsize};
Point(18) = {0.382612,   0.101840, 0, gridsize};
Point(19) = {0.337260,   0.100070, 0, gridsize};
Point(20) = {0.292970,   0.096703, 0, gridsize};
Point(21) = {0.250247,   0.091908, 0, gridsize};
Point(22) = {0.209576,   0.085851, 0, gridsize};
Point(23) = {0.171409,   0.078687, 0, gridsize};
Point(24) = {0.136174,   0.070580, 0, gridsize};
Point(25) = {0.104263,   0.061697, 0, gridsize};
Point(26) = {0.076035,   0.052224, 0, gridsize};
Point(27) = {0.051823,   0.042352, 0, gridsize};
Point(28) = {0.031910,   0.032299, 0, gridsize};
Point(29) = {0.016590,   0.022290, 0, gridsize};
Point(30) = {0.006026,   0.012615, 0, gridsize};
Point(31) = {0.000658,   0.003723, 0, gridsize};
Point(32) = {0.000204,   0.001942, 0, gridsize};
Point(33) = {0.000000,  -0.000020, 0, gridsize}; // leading edge point
Point(500)  = {-2e-5,   -0.000020, 0.2, gridsize}; // helper point to dial in first cell height
Point(34) = {0.000213,  -0.001794, 0, gridsize};
Point(35) = {0.001045,  -0.003477, 0, gridsize};
Point(36) = {0.001208,  -0.003724, 0, gridsize};
Point(37) = {0.002398,  -0.005266, 0, gridsize};
Point(38) = {0.009313,  -0.011499, 0, gridsize};
Point(39) = {0.023230,  -0.020399, 0, gridsize};
Point(40) = {0.042320,  -0.030269, 0, gridsize};
Point(41) = {0.065877,  -0.040821, 0, gridsize};
Point(42) = {0.093426,  -0.051923, 0, gridsize};
Point(43) = {0.124111,  -0.063082, 0, gridsize};
Point(44) = {0.157653,  -0.073730, 0, gridsize};
Point(45) = {0.193738,  -0.083567, 0, gridsize};
Point(46) = {0.231914,  -0.092442, 0, gridsize};
Point(47) = {0.271438,  -0.099905, 0, gridsize};
Point(48) = {0.311968,  -0.105281, 0, gridsize};
Point(49) = {0.353370,  -0.108181, 0, gridsize};
Point(50) = {0.395329,  -0.108011, 0, gridsize};
Point(51) = {0.438273,  -0.104552, 0, gridsize};
Point(52) = {0.481920,  -0.097347, 0, gridsize};
Point(53) = {0.527928,  -0.086571, 0, gridsize};
Point(54) = {0.576211,  -0.073979, 0, gridsize};
Point(55) = {0.626092,  -0.060644, 0, gridsize};
Point(56) = {0.676744,  -0.047441, 0, gridsize};
Point(57) = {0.727211,  -0.035100, 0, gridsize};
Point(58) = {0.776432,  -0.024204, 0, gridsize};
Point(59) = {0.823285,  -0.015163, 0, gridsize};
Point(60) = {0.866630,  -0.008204, 0, gridsize};
Point(61) = {0.905365,  -0.003363, 0, gridsize};
Point(62) = {0.938474,  -0.000487, 0, gridsize};
Point(63) = {0.965086,   0.000743, 0, gridsize};
Point(64) = {0.984478,   0.000775, 0, gridsize};
Point(65) = {0.996141,   0.000290, 0, gridsize};
// Point(66) = {1.000000, 0.000000, 0, gridsize}; // Also tail point like Point(1) -> This belongs to the bottom part
// Line(1) = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66};

// front upper section airfoil
Bezier(1) = {26,27,28,29,30,31,32,33};
// top section airfoil
Bezier(2) = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26};
// bottom section airfoil
Bezier(3) = {41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,1};
// front lower section airfoil
Bezier(4) = {33,34,35,36,37,38,39,40,41};
//Ellipse(4) = {33, 1000, 33, 41};

// ----------------------------------------------------------------------------------- //
// Points for the front half circle
factor = 4;
Point(100) = {-factor*airfoil_length, 0, 0, gridsize}; // circle mid point
Point(106) = {-factor*airfoil_length, front_radius, 0, gridsize}; // top half cylinder
Point(107) = {-factor*airfoil_length, -front_radius, 0, gridsize}; // bottom half cylinder

Point(110) = {-front_radius-factor*airfoil_length, 0, 0, gridsize}; // half cylinder most left point

Circle(200) = {106, 100, 110}; // front half cylinder farfield
Circle(201) = {107, 100, 110}; // front half cylinder farfield
Line(202) = {33, 110}; // airfoil front to farfield 

// Additional points for the back half
Point(101) = {airfoil_length, front_radius, 0, gridsize}; // top half cylinder
Point(102) = {airfoil_length, -front_radius, 0, gridsize}; // bottom half cylinder

Point(103) = {back_extension, front_radius, 0, gridsize}; // top right corner
Point(104) = {back_extension, -front_radius, 0, gridsize}; // bottom right corner
Point(105) = {back_extension, 0, 0, gridsize}; // middle right 

// Connecting lines between back points
Line(101) = {1, 105}; // upper airfoil tip to middle
Line(102) = {105, 103}; // middle to top right
Line(103) = {103, 101}; // top right to half cylinder
Line(104) = {102, 104}; // half cylinder to bottom left
Line(105) = {104, 105};// bottom left to middle

// Separate middle boxes from front
Line(109) = {26, 106}; // airfoil tip top half cylinder 
Line(110) = {41, 107}; // airfoil tip bottom half cylinder 

// Separate back boxes from middle boxes
Line(106) = {1, 101}; // airfoil tip top half cylinder 
Line(107) = {1, 102}; // airfoil tip bottom half cylinder 

// Close middle boxes on the farfield
Line(111) = {101, 106};
Line(112) = {107, 102};

// ----------------------------------------------------------------------------------- //
// Create Surfaces (counter-clockwise line loops, starting at airfoil tip)

// Front upper quarter cylinder 
Curve Loop(1) = {-1, 109, 200, -202};
Plane Surface(1) = {1};

// Front lower quarter cylinder 
Curve Loop(6) = {-4, 202, -201, -110};
Plane Surface(6) = {6};

// top middle box
Line Loop(2) = {-2, 106, 111, -109};
Plane Surface(2) = {2};
// bottom middle box
Line Loop(3) = {110, 112, -107, -3};
Plane Surface(3) = {3};

// top back box
Line Loop(4) = {101, 102, 103, -106};
Plane Surface(4) = {4};
// bottom back box
Line Loop(5) = {107, 104, 105, -101};
Plane Surface(5) = {5};

// ----------------------------------------------------------------------------------- //
// extrude all surfaces 0.2 in z-direction
Extrude {0, 0, 0.2} {
  Surface{6}; Surface{1}; Surface{2}; Surface{3}; Surface{5}; Surface{4}; 
}

// create named sections for bcs
Physical Surface("symmetry", 335) = {246, 1, 224, 6, 290, 3, 312, 5, 4, 334, 268, 2};
Physical Surface("airfoil", 336) = {255, 289, 233, 211};
Physical Surface("farfield", 337) = {329, 263, 241, 219, 281, 303, 325, 307};

Physical Volume("volume") = {1, 2, 3, 6, 5, 4};

// ----------------------------------------------------------------------------------- //
// Mesh definition
// Make structured mesh with transfinite lines
Transfinite Curve{1, 4, 200, -201} = Nairfoil;
Transfinite Curve {228, 206, 226, 204} = Nairfoil;

Transfinite Curve{106, 109, 202, 107, 110, 102, -105} = Nradial Using Progression Rradial;
Transfinite Curve {315, 249, 227, 205, -207, -272, -294} = Nradial Using Progression Rradial;
// middle box
Transfinite Curve{2, 3, 111, 112} = Nmiddle;
Transfinite Curve {250, 248, 273, 271} = Nmiddle;

// back box
Transfinite Curve{-103, 101, 104} = Nback Using Progression Rback;
Transfinite Curve {-316, -295, 293} = Nback Using Progression Rback;

// 1 cell in depth
Transfinite Curve {324, 258, 236, 254, 306, 302, 214, 218, 280, 209, 210, 232} = 3 Using Progression 1;

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

//+
Coherence;
//+
Coherence;
//+
Coherence;
//+
Coherence;
