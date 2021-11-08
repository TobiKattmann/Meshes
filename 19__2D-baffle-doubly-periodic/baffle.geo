// ------------------------------------------------------------------------- //
// T. Kattmann, 15.04.2021, 2D 1 Zone mesh
// Create the mesh by calling this geo file with 'gmsh <this>.geo'.
// For multizone mesh the zonal meshes have to be created using the first 
// option 'Which_Mesh_Part' below and have to be married appropriately.
// ------------------------------------------------------------------------- //

// Evoque Meshing Algorithm?
Do_Meshing= 1; // 0=false, 1=true
// Write Mesh files in .su2 format
Write_mesh= 0; // 0=false, 1=true
// Mesh Resolution
Mesh_Resolution= 1; // 0=debugRes, 1=Res1, 2=Res2

height= 1;
length= 2;

If(Mesh_Resolution==1)
    gridsize= 0.1;
    Ny= 20;
    Nx= 2*Ny;
    Nairfoil= 2*Ny;
EndIf

// ----------------------------------------------------------------------------------- //
// box
Point(1) = {0,0,0, gridsize};
Point(2) = {0,height,0, gridsize};
Point(3) = {length,height,0, gridsize};
Point(4) = {length,0,0, gridsize};

Line(1) = {1,2};
Line(2) = {2,3};
Line(3) = {3,4};
Line(4) = {4,1};
Transfinite Line{2,4} = Nx;
Transfinite Line{1,3} = Ny;

Physical Line("in") = {1};
Physical Line("top") = {2};
Physical Line("out") = {3};
Physical Line("bottom") = {4};

// ----------------------------------------------------------------------------------- //
// airfoil
Point(10) = {1.7,0.3,0, gridsize};
Point(11) = {0.1,0.9,0, gridsize};
Point(12) = {0.1,0.5,0, gridsize};
Bezier(5) = {10,11,12,10};
Curve Loop(2) = {5};
//Transfinite Line{5} = Nairfoil;
Physical Line("airfoil") = {5};

// ----------------------------------------------------------------------------------- //
// Surface 
Curve Loop(1) = {1,2,3,4,5}; Plane Surface(1) = {1,2};
Physical Surface("surf") = {1};

//Field[1] = Distance;
//Field[1].CurvesList = {5};
//Field[1].NumPointsPerCurve = 100;
////+
//Field[2] = Threshold;
//Field[2].InField = 1;
//Field[2].DistMax = 0.2; 
//Field[2].DistMin = 0.1;
//Field[2].SizeMax = 0.01;
//Field[2].SizeMin = 0.1;

// ----------------------------------------------------------------------------------- //
// Meshing 
If (Do_Meshing == 1)
    Mesh 1; Mesh 2;
EndIf

// ----------------------------------------------------------------------------------- //
// Write .su2 meshfile
If (Write_mesh == 1)

    Mesh.Format = 42; // .su2 mesh format, 
    Save "fluid.su2";

EndIf
