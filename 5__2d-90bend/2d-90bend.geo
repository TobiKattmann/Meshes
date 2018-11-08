// Kattmann, 16.10.2018, 2D 90 degree bend with inflow and outflow pipe
//-----------------------------------------------------------------------------
// Geometric inputs
d_pipe= 1.0; // pipe diameter
r_bend= 3.0; // outer radius of the bend, i.e. r_bend>d_pipe !!
l_in= 3.0; // length of inflow pipe
l_out= 3.0; // length of outflow pipe

// Mesh sizing inputs
Nflow= 100; // Nodes in flow direction
Nwall= 30; // Nodes from wall to wall
Rwall= 1.0; // Scaling at the wall
gridsize= 0.1; // Later on not important as structured mesh is achieved

//-----------------------------------------------------------------------------
// POINTS

// Inflow Pipe
Point(1) = {0, r_bend+l_in, 0, gridsize};
Point(2) = {d_pipe, r_bend+l_in, 0, gridsize};
Point(3) = {0, r_bend, 0, gridsize};
Point(4) = {d_pipe, r_bend, 0, gridsize};

// Outflow Pipe
Point(5) = {r_bend+l_in, 0, 0, gridsize};
Point(6) = {r_bend+l_in, d_pipe, 0, gridsize};
Point(7) = {r_bend, 0, 0, gridsize};
Point(8) = {r_bend, d_pipe, 0, gridsize};

// Circle Point
Point(9) = {r_bend, r_bend, 0, gridsize};

//-----------------------------------------------------------------------------
// LINES

// Inflow (clockwise)
Line(1) = {1,2};
Line(2) = {2,4};
Line(3) = {4,3};
Line(4) = {3,1};

// Outflow (clockwise)
Line(5) = {8,6};
Line(6) = {6,5};
Line(7) = {5,7};
Line(8) = {7,8};

// Circle parts (clockwise)
Circle(9) = {4,9,8};
Circle(10) = {7,9,3};
//-----------------------------------------------------------------------------
// SURFACES (and Lineloops)

// Inflow (clockwise)
Line Loop(1) = {1,2,3,4};
Plane Surface(1) = {1};

// Outflow (clockwise)
Line Loop(2) = {5,6,7,8};
Plane Surface(2) = {2};

// Bend (clockwise)
Line Loop(3) = {-3,9,-8,10};
Plane Surface(3) = {3};

// make structured mesh with transfinite Lines
Transfinite Line{2,-4,5,-7,9,-10} = Nflow;
Transfinite Line{1,-3,8,-6} = Nwall Using Bump 0.1;

Transfinite Surface{1,2,3};
Recombine Surface{1,2,3};
//-----------------------------------------------------------------------------
// PHYSICAL GROUPS

Physical Line("inlet") = {1};
Physical Line("outlet") = {6};
Physical Line("bend") = {9,10};
Physical Line("in_pipe") = {2,4};
Physical Line("out_pipe") = {5,7};
Physical Surface("fluid") = {1,2,3};


