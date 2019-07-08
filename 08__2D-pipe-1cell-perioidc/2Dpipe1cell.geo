//-----------------------------------------------------------------------------
// Kattmann, 16.10.2018, 2D pipe 1 cell in streamwise direction for streamwise periodicity
//-----------------------------------------------------------------------------

// Evoque Meshing Algorithm?
Do_Meshing= 1; // 0=false, 1=true
// Write Mesh files in .su2 format
Write_mesh= 0; // 0=false, 1=true

// Geometric inputs
height=  2e-3; // pipe height
width= 1e-4; // width of the one cell layer

// Mesh sizing inputs
Npipe= 30; // number of points in channel height direction
Nstreamwise= 2; // Number of points in streamwise direction
gridsize= 0.1; // no meaning

//-----------------------------------------------------------------------------
// POINTS

Point(1) = {0, 0, 0, gridsize};
Point(2) = {0, height, 0, gridsize};
Point(3) = {width, height, 0, gridsize};
Point(4) = {width, 0, 0, gridsize};

//-----------------------------------------------------------------------------
// LINES

// pipe (clockwise)
Line(1) = {1,2};
Line(2) = {2,3};
Line(3) = {3,4};
Line(4) = {4,1};

//-----------------------------------------------------------------------------
// SURFACES (and Lineloops)

// pipe (clockwise)
Line Loop(1) = {1,2,3,4}; Plane Surface(1) = {1};

// make structured mesh with transfinite Lines
Transfinite Line{2,-4} = Nstreamwise; // streamwise direction
Transfinite Line{1,-3} = Npipe Using Bump 0.1; // pipe height direction

//-----------------------------------------------------------------------------
// PHYSICAL GROUPS

Physical Line("inlet") = {1};
Physical Line("outlet") = {3};
Physical Line("walls") = {2,4};
Physical Surface("fluid") = {1};

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
    Save "pipe1cell2D.su2";

EndIf
