// ----------------------------------------------------------------------------------- //
// Kattmann 20.06.2023, rectangle/cube mesh for various things
// ----------------------------------------------------------------------------------- //

//SetFactory("OpenCASCADE");

// Evoque Meshing Algorithm?
Do_Meshing= 1; // 0=false, 1=true
// Write Mesh files in .cgns format
Write_mesh= 1; // 0=false, 1=true
mesh_name= "rectangle.cgns";
// Control the number of cells and progression parameters
Mesh_parameter= 1;

//Geometric inputs
xmin = 0;
xmax = 1;
ymin = 0;
ymax = 1;
zmin = 0;
zmax = 0.1;

// ----------------------------------------------------------------------------------- //
//Mesh inputs
gridsize = 0.1; // not relevant for fully structured grid, but we still have to provide it
If (Mesh_parameter == 1)
  Nx = 11;
  Ny = 11;
  Nz = 2;
  
  R = 1.0;
  Rx = R;
  Ry = R;
  Rz = 1;
ElseIf (Mesh_parameter == 2)
  // nothing yet
EndIf
// ----------------------------------------------------------------------------------- //
// Airfoil Points
Point(1)  = {xmin, ymin, zmin, gridsize}; 
Point(2)  = {xmax, ymin, zmin, gridsize}; 
Point(3)  = {xmax, ymax, zmin, gridsize};
Point(4)  = {xmin, ymax, zmin, gridsize};
Point(5)  = {xmin, ymin, zmax, gridsize}; 
Point(6)  = {xmax, ymin, zmax, gridsize}; 
Point(7)  = {xmax, ymax, zmax, gridsize};
Point(8)  = {xmin, ymax, zmax, gridsize};

Line(1)  = {1,2};
Line(2)  = {2,3};
Line(3)  = {3,4};
Line(4)  = {4,1};

Line(5)  = {5,6};
Line(6)  = {6,7};
Line(7)  = {7,8};
Line(8)  = {8,5};

Line(9)  = {1,5};
Line(10) = {2,6};
Line(11) = {3,7};
Line(12) = {4,8};

// ----------------------------------------------------------------------------------- //
// Surfaces
//+
Line Loop(1) = {1, 2, 3, 4}; Plane Surface(1) = {1};
Line Loop(2) = {5, 6, 7, 8}; Plane Surface(2) = {2};

Line Loop(3) = {1, 10, -5, -9};  Plane Surface(3) = {3};
Line Loop(4) = {2, 11, -6, -10}; Plane Surface(4) = {4};
Line Loop(5) = {3, 12, -7, -11}; Plane Surface(5) = {5};
Line Loop(6) = {9, -8, -12, 4};  Plane Surface(6) = {6};

Physical Surface("zmin") = {1};
Physical Surface("zmax") = {2};
Physical Surface("ymin") = {3};
Physical Surface("ymax") = {5};
Physical Surface("xmin") = {4};
Physical Surface("xmax") = {6};

Surface Loop(1) = {2, 3, 1, 4, 5, 6}; Volume(1) = {1};
Physical Volume("volume") = {1};

// ----------------------------------------------------------------------------------- //
// Mesh definition
// Make structured mesh with transfinite lines

Transfinite Line {1, 5, 3, 7} = Nx Using Bump Rx;
Transfinite Line {4, 8, 2, 6} = Ny Using Bump Ry;
Transfinite Line {9, 10, 11, 12} = Nz Using Bump Rz;

// ----------------------------------------------------------------------------------- //

Transfinite Surface "*";
Recombine Surface "*";
Transfinite Volume "*";
// // Recombine Volume "*";

If (Do_Meshing == 1)
    Mesh 1; Mesh 2; Mesh 3;
EndIf

// ----------------------------------------------------------------------------------- //
// Write .cgns meshfile
If (Write_mesh == 1)
    
    Mesh.Format = 32; // .cgns mesh format 
    Save Str(mesh_name);

EndIf
