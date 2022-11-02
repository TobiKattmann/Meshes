// ----------------------------------------------------------------------------------- //
// Tobias Kattmann, 09.09.2021, 2D Venturi Primitive for faster debugging
// ----------------------------------------------------------------------------------- //

// Evoque Meshing Algorithm?
Do_Meshing= 1; // 0=false, 1=true
// Write Mesh files in .su2 format
Write_mesh= 1; // 0=false, 1=true

// Geometric inputs
height= 0.025;
length= 0.1;

// Mesh sizing inputs
Nheight= 30; // Nodes for all spacings
Nlength= 90;
gridsize= 0.1; // Later on not important as structured mesh is achieved

// ----------------------------------------------------------------------------------- //
// POINTS

// Starting in the origin, which is the most low-left point, and going clockwise.
// Gas inlet
Point(1) = {0, 0, 0, gridsize};
Point(2) = {0, height, 0, gridsize};
Point(3) = {length, height, 0, gridsize};
Point(4) = {length, 0, 0, gridsize};


// ----------------------------------------------------------------------------------- //
// LINES

// Gas inlet box, clockwise
Line(1) = {1,2};
Line(2) = {2,3};
Line(3) = {3,4};
Line(4) = {4,1};

// ----------------------------------------------------------------------------------- //
// SURFACES (and Lineloops)
Curve Loop(1) = {1, 2, 3, 4}; Plane Surface(1) = {1}; // Gas inlet box

// make structured mesh with transfinite Lines
// NOTE: The usage of Nwall and the progression has to be tuned again for any changes.
Transfinite Line{1,-3} = Nheight Using Bump 0.2; // Spacing to the wall of the long tube, progression towards top wall
Transfinite Line{2,-4} = Nlength; // Downstream spacing of gas inlet, progression towards air inlet

// ----------------------------------------------------------------------------------- //
// PHYSICAL GROUPS

Physical Line("inlet") = {1};
Physical Line("outlet") = {3};
Physical Line("top") = {2};
Physical Line("bottom") = {4};

Physical Surface("fluid") = {1,2,3,4};

// ----------------------------------------------------------------------------------- //
// Meshing
Transfinite Surface "*";
Recombine Surface "*";

If (Do_Meshing == 1)
    Mesh 1; Mesh 2;
EndIf

// ----------------------------------------------------------------------------------- //
// Write .su2 meshfile
If (Write_mesh == 1)

    Mesh.Format = 42; // .su2 mesh format, 
    Save "channel.su2";

EndIf

