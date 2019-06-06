// Kattmann, 16.10.2018, 2D square cylinder with structured mesh
//-----------------------------------------------------------------------------
// Geometric inputs
D = 1; // edge length of square cylinder, used as relative measure, center of square is origin
r = 0.5*D; // "radius", half edge length
h = 5.5*D; // height (orthogonal to flow) on each side, counted from origin
lfront = 5.5*D; // downstream extension
lback = 10.5*D; // upstream extension 

// Mesh sizing inputs, x in flow direction
Nx_front = 100;
Nx_middle = 100;
Nx_back = 100;
Ny_top = 100; // domain axisymmetric around y-axis, so Ny_top=Ny_bottom
Ny_middle = 100; 

// input for Progression and Bump
Rx_front = 0.8;
Rx_middle = 0.2;
Rx_back = 1.1;
Ry_top = 0.8;
Ry_middle = 0.2;

gridsize = 0.1; // arbitrary, without influence

//-----------------------------------------------------------------------------
// POINTS

// cylinder points
Point(1) = {-r, r, 0, gridsize};
Point(2) = {r, r, 0, gridsize};
Point(3) = {r, -r, 0, gridsize};
Point(4) = {-r, -r, 0, gridsize};

// farfield points
Point(5) = {-lfront, h, 0, gridsize};
Point(6) = {-r, h, 0, gridsize};
Point(7) = {r, h, 0, gridsize};
Point(8) = {lback, h, 0, gridsize};
Point(9) = {lback, r, 0, gridsize};
Point(10) = {lback, -r, 0, gridsize};
Point(11) = {lback, -h, 0, gridsize};
Point(12) = {r, -h, 0, gridsize};
Point(13) = {-r, -h, 0, gridsize};
Point(14) = {-lfront, -h, 0, gridsize};
Point(15) = {-lfront, -r, 0, gridsize};
Point(16) = {-lfront, r, 0, gridsize};
//-----------------------------------------------------------------------------
// LINES

// cylinder
Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};

// farfield
Line(5) = {5, 6};
Line(6) = {6, 7};
Line(7) = {7, 8};
Line(8) = {8, 9};
Line(9) = {9, 10};
Line(10) = {10, 11};
Line(11) = {11, 12};
Line(12) = {12, 13};
Line(13) = {13, 14};
Line(14) = {14, 15};
Line(15) = {15, 16};
Line(16) = {16, 5};


// inner connections
Line(17) = {1, 6};
Line(18) = {2, 7};
Line(19) = {2, 9};
Line(20) = {3, 10};
Line(21) = {3, 12};
Line(22) = {4, 13};
Line(23) = {4, 15};
Line(24) = {1, 16};


//-----------------------------------------------------------------------------
// SURFACES (and Lineloops)

// upper left, always in clockwise direction starting from upper edge
Line Loop(1) = {5, -17, 24, 16};
Plane Surface(1) = {1};

// upper left
Line Loop(2) = {6, -18, -1, 17};
Plane Surface(2) = {2};

// upper left
Line Loop(3) = {7, 8, -19, 18};
Plane Surface(3) = {3};

// upper left
Line Loop(4) = {19, 9, -20, -2};
Plane Surface(4) = {4};

// upper left
Line Loop(5) = {20, 10, 11, -21};
Plane Surface(5) = {5};

// upper left
Line Loop(6) = {-3, 21, 12, -22};
Plane Surface(6) = {6};

// upper left
Line Loop(7) = {-23, 22, 13, 14};
Plane Surface(7) = {7};

// upper left
Line Loop(8) = {-24, -4, 23, 15};
Plane Surface(8) = {8};

// make structured mesh with transfinite lines, lines always directed towards origin
Transfinite Line{5, -24, -23, -13} = Nx_front Using Progression Rx_front;
Transfinite Line{6, 1, -3, -12} = Nx_middle Using Bump Rx_middle; // positive direction
Transfinite Line{7, 19, 20, -11} = Nx_back Using Progression Rx_back;

Transfinite Line{-16, -17, -18, 8, 14, -22, -21, -10} = Ny_top Using Progression Ry_top; // also meshes bottom
Transfinite Line{15, 4, -2, -9} = Ny_middle Using Bump Ry_middle; // positive direction

Transfinite Surface{1,2,3,4,5,6,7,8};
Recombine Surface{1,2,3,4,5,6,7,8};
//-----------------------------------------------------------------------------
// PHYSICAL GROUPS

Physical Line("cylinder") = {1,2,3,4};
Physical Line("farfield") = {5,6,7,8,9,10,11,12,13,14,15,16};
Physical Surface("fluid") = {1,2,3,4,5,6,7,8};
