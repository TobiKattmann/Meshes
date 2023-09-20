//-------------------------------------------------------------------------------------//
// T. Kattmann, 13.05.2018, 3D Butterfly mesh in a circular pipe
// Create the mesh by calling this geo file with 'gmsh <this>.geo'.
//-------------------------------------------------------------------------------------//

Do_Meshing= 1; // 0=false, 1=true
Write_mesh= 1; // 0=false, 1=true
Mesh_format= 1; // 0=cgns, 1=su2
mesh_name= "pipe"; // basename
// Control the number of cells and progression parameters, also the geometry
Mesh_parameter= 3;

// ----------------------------------------------------------------------------------- //
//Mesh inputs
gridsize = 0.1; // unimportant once everything is structured
// Note: Pipe center is origin
If (Mesh_parameter == 0)
    // Pipe with L/D=200
    Radius= 0.5e-3; // Pipe Radius
    InnerBox= Radius/3; // Distance to the inner Block of the butterfly mesh

    Nbox = 8; // Inner Box points in x & y direction
    Ncircu = 10; // Outer ring circu. points
    Rcircu = 1.05; // Spacing towards wall

    pipe_length = 0.2;
    Npipe = 25; // Number of cells(!) in downstream direction

    // The mesh size is given as #FaceCells x #downstreamCells
    // #FacePoints = (Nbox-1)**2 + 4*(Nbox-1)*(Ncircu-1)
    mesh_name = StrCat(mesh_name, "_coarse_301x25");

ElseIf (Mesh_parameter == 1)
    // Pipe with L/D=200
    Radius= 0.5e-3; // Pipe Radius
    InnerBox= Radius/3; // Distance to the inner Block of the butterfly mesh

    Nbox = 13; // Inner Box points in x & y direction
    Ncircu = 18; // Outer ring circu. points
    Rcircu = 1.05; // Spacing towards wall

    pipe_length = 0.2;
    Npipe = 50; // Number of cells(!) in downstream direction

    // The mesh size is given as #FaceCells x #downstreamCells
    // #FacePoints = (Nbox-1)**2 + 4*(Nbox-1)*(Ncircu-1)
    mesh_name = StrCat(mesh_name, "_medium_960x50");

ElseIf (Mesh_parameter == 2)
    // Pipe with L/D=200
    Radius= 0.5e-3; // Pipe Radius
    InnerBox= Radius/3; // Distance to the inner Block of the butterfly mesh

    Nbox = 25; // Inner Box points in x & y direction
    Ncircu = 35; // Outer ring circu. points
    Rcircu = 1.05; // Spacing towards wall

    pipe_length = 0.2;
    Npipe = 100; // Number of cells(!) in downstream direction

    // The mesh size is given as #FaceCells x #downstreamCells
    // #FacePoints = (Nbox-1)**2 + 4*(Nbox-1)*(Ncircu-1)
    mesh_name = StrCat(mesh_name, "_fine_3840x100");

ElseIf (Mesh_parameter == 3)
    // Pipe with L/D=200
    Radius= 0.5e-3; // Pipe Radius
    InnerBox= Radius/3; // Distance to the inner Block of the butterfly mesh

    Nbox = 45; // Inner Box points in x & y direction
    Ncircu = 70; // Outer ring circu. points
    Rcircu = 1.03; // Spacing towards wall

    pipe_length = 0.2;
    Npipe = 200; // Number of cells(!) in downstream direction

    // The mesh size is given as #FaceCells x #downstreamCells
    // #FacePoints = (Nbox-1)**2 + 4*(Nbox-1)*(Ncircu-1)
    mesh_name = StrCat(mesh_name, "_finest_14080x200");
ElseIf (Mesh_parameter == 4)
    // Pipe Slice with 1 cell in downstream direction. Meant for periodic BC's. 
    Radius= 0.5e-2; // Pipe Radius
    InnerBox= Radius/3; // Distance to the inner Block of the butterfly mesh

    Nbox = 13; // Inner Box points in x & y direction
    Ncircu = 18; // Outer ring circu. points
    Rcircu = 1.05; // Spacing towards wall

    pipe_length = 0.0005;
    Npipe = 1; // Number of cells(!) in downstream direction

    // The mesh size is given as #FaceCells x #downstreamCells
    // #FacePoints = Nbox**2 + 4*Nbox*Ncircu
    mesh_name = StrCat(mesh_name, "_medium_960x1");
EndIf

Printf("Number of face cells: %g", (Nbox-1)^2 + 4*(Nbox-1)*(Ncircu-1));

//-------------------------------------------------------------------------------------//
// Points
// Inner Box
Point(1) = {-InnerBox, -InnerBox, 0, gridsize};
Point(2) = {-InnerBox, InnerBox, 0, gridsize};
Point(3) = {InnerBox, InnerBox, 0, gridsize};
Point(4) = {InnerBox, -InnerBox, 0, gridsize};

// Outer Ring
sqrtTwo = Cos(45*Pi/180); // Helper var
Point(5) = {-Radius*sqrtTwo, -Radius*sqrtTwo, 0, gridsize};
Point(6) = {-Radius*sqrtTwo, Radius*sqrtTwo, 0, gridsize};
Point(7) = {Radius*sqrtTwo, Radius*sqrtTwo, 0, gridsize};
Point(8) = {Radius*sqrtTwo, -Radius*sqrtTwo, 0, gridsize};

Point(9) = {0,0,0,gridsize}; // Helper Point for circles

//-------------------------------------------------------------------------------------//
// Lines
// Inner Box (clockwise)
Line(1) = {1,2};
Line(2) = {2,3};
Line(3) = {3,4};
Line(4) = {4,1};

// Walls (clockwise)
Circle(5) = {5, 9, 6};
Circle(6) = {6, 9, 7};
Circle(7) = {7, 9, 8};
Circle(8) = {8, 9, 5};

// Connecting lines (outward facing)
Line(9) = {1, 5};
Line(10) = {2, 6};
Line(11) = {3, 7};
Line(12) = {4, 8};

//-------------------------------------------------------------------------------------//
// ineloops and surfaces
// Inner Box (clockwise)
Line Loop(1) = {1,2,3,4}; Plane Surface(1) = {1};

// Ring sections (clockwise starting at 9 o'clock)
Line Loop(2) = {5, -10, -1, 9}; Plane Surface(2) = {2};
Line Loop(3) = {10, 6, -11, -2}; Plane Surface(3) = {3};
Line Loop(4) = {-3, 11, 7, -12}; Plane Surface(4) = {4};
Line Loop(5) = {12, 8, -9, -4}; Plane Surface(5) = {5};

// Make structured mesh with transfinite lines
// Radial
Transfinite Line{1, 2, 3, 4, 5, 6, 7, 8} = Nbox;
// Circumferential
Transfinite Line{-9, -10, -11, -12} = Ncircu Using Progression Rcircu;

Transfinite Surface{1,2,3,4,5};
Recombine Surface{1,2,3,4,5};

// Extrude mesh
Extrude {0, 0, pipe_length} {
    Surface{1}; Surface{2}; Surface{3}; Surface{4}; Surface{5};
    Layers{Npipe};
    Recombine; 
}
Coherence;

// Physical groups
Physical Surface("inlet") = {4, 1, 5, 3, 2};
Physical Surface("outlet") = {100, 122, 56, 78, 34};
Physical Surface("wall") = {69, 95, 113, 43};
Physical Volume("fluid_volume") = {1, 2, 3, 4, 5};

// ----------------------------------------------------------------------------------- //
// Meshing
Transfinite Surface "*";
Recombine Surface "*";

If (Do_Meshing == 1)
    Mesh 1; Mesh 2; Mesh 3;
EndIf

// ----------------------------------------------------------------------------------- //
// Write mesh
If (Write_mesh == 1)
  If (Mesh_format == 0)
    Mesh.Format = 32; // 32 = .cgns
    mesh_name = StrCat(mesh_name, ".cgns");

  ElseIf (Mesh_format == 1)
    Mesh.Format = 42; // 42 = .su2 
    mesh_name = StrCat(mesh_name, ".su2");

  EndIf
  Save Str(mesh_name);

EndIf
