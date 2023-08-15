// ----------------------------------------------------------------------------------- //
// Kattmann 15.08.2023, flat plate mesh (simple extrusion in 3rd dimension)
// ----------------------------------------------------------------------------------- //

// Evoque Meshing Algorithm?
Do_Meshing= 1; // 0=false, 1=true
// Write Mesh files in .cgns format
Write_mesh= 1; // 0=false, 1=true
mesh_name= "flatplate.cgns";
// Control the number of cells and progression parameters
Mesh_parameter= 2;

// The flat plate consists out of a front section and a back section,
// where the front bottom is designated sym and the back bottom is no-slip.
// The start of the no-slip part is at x=0, (or at the origin to be precise)
// Geometric inputs:
xstart = 0.0;
xmin = -0.06096; // must be <0
xmax = 0.3048; // must be >0
ymin = 0.0;
ymax = 0.03;
zmin = 0.0;
zmax = 0.01;

// ----------------------------------------------------------------------------------- //
//Mesh inputs
gridsize = 0.1; // not relevant for fully structured grid, but we still have to provide it
If (Mesh_parameter == 1)
  // This is equivalent to the SU2 mesh mesh_flatplate_65x65.su2
  // 1st cell height is 1.6e-5m with a mild progression
  // First Cell width at x=0 in x-direction is 1e-3m, again mild progression
  Nx_front = 33;
  Rx_front = 1.04   ; 

  Nx_back = 33;
  Rx_back = 1.12;

  Ny = 65;
  Ry = 1.08;
  Nz = 2;

  // Helper Points to dial in mesh sizing
  Point(100)  = {xstart, 1.6e-5, zmax, gridsize};
  Point(101)  = {xstart + 1e-3, 0, zmax, gridsize};
  Point(102)  = {xstart - 1e-3, 0, zmax, gridsize};
ElseIf (Mesh_parameter == 2)
  // Goal here to is to have 
  // 1. a finer mesh in x-direction near the leading edge of the flat plate
  // 2. a finer mesh in x-direction near the outlet
  // -> this is best done with a Bump instead of Progression for the wall
  Nx_front = 33;
  Rx_front = 1.04   ; 

  Nx_back = 100;
  Rx_back = 0.025;

  Ny = 65;
  Ry = 1.08;
  Nz = 2;

  // Helper Points to dial in mesh sizing
  Point(100)  = {xstart, 1.6e-5, zmax, gridsize};
  Point(101)  = {xstart + 1e-3, 0, zmax, gridsize};
  Point(102)  = {xstart - 1e-3, 0, zmax, gridsize};
EndIf
// ----------------------------------------------------------------------------------- //
// front/freestream points
Point(1)  = {xmin, ymin, zmin, gridsize}; 
Point(2)  = {xstart, ymin, zmin, gridsize}; 
Point(3)  = {xstart, ymax, zmin, gridsize};
Point(4)  = {xmin, ymax, zmin, gridsize};

// additional back/no-slip points
Point(5)  = {xmax, ymin, zmin, gridsize}; 
Point(6)  = {xmax, ymax, zmin, gridsize};



// front box lines
Line(1)  = {1,2};
Line(2)  = {2,3};
Line(3)  = {3,4};
Line(4)  = {4,1};

// additional back box lines
Line(5)  = {2,5};
Line(6)  = {5,6};
Line(7)  = {6,3};

// ----------------------------------------------------------------------------------- //
// Surfaces
Line Loop(1) = {4, 1, 2, 3}; Plane Surface(1) = {1};
Line Loop(2) = {7, -2, 5, 6}; Plane Surface(2) = {2};

// ----------------------------------------------------------------------------------- //
// extrude all surfaces zmax in z-direction
Extrude {0, 0, zmax} {
  Surface{1}; Surface{2};
}

// I think the extrude already creates a surface loop and creates a volume
// Surface Loop(1) = {29, 16, 1, 20, 28, 24};
// Volume(3) = {1};
// Surface Loop(2) = {51, 38, 2, 46, 50, 24};
// Volume(4) = {2};

Physical Surface("zplus", 52) = {29, 51};
Physical Surface("zminus", 53) = {2, 1};
Physical Surface("top", 54) = {28, 38};
Physical Surface("inlet", 55) = {16};
Physical Surface("outlet", 56) = {50};
Physical Surface("bottom_sym", 57) = {20};
Physical Surface("bottom_wall", 58) = {46};

Physical Volume("volume", 59) = {1, 2};

// // ----------------------------------------------------------------------------------- //
// // Mesh definition
// // Make structured mesh with transfinite lines

Transfinite Curve {-1, -10, 12, 3} = Nx_front Using Progression Rx_front;
If (Mesh_parameter == 2)
    Transfinite Curve {-7, -31, 33, 5} = Nx_back Using Bump Rx_back;
Else
    Transfinite Curve {-7, -31, 33, 5} = Nx_back Using Progression Rx_back;
EndIf
Transfinite Curve {-9, -4, 2, 11, 34, 6} = Ny Using Progression Ry;
Transfinite Curve {23, 14, 15, 19, 45, 36} = Rx;

// // ----------------------------------------------------------------------------------- //

Transfinite Surface "*";
Recombine Surface "*";
Transfinite Volume "*";
// Recombine Volume "*";

If (Do_Meshing == 1)
    Mesh 1; Mesh 2; Mesh 3;
EndIf

// // ----------------------------------------------------------------------------------- //
// Write .cgns meshfile
If (Write_mesh == 1)
    
    Mesh.Format = 32; // .cgns mesh format 
    Save Str(mesh_name);

EndIf
