//-------------------------------------------------------------------------------------//
// Kattmann 20.08.2018, O mesh for vortex shedding behind cylinder
// The O mesh around the cylinder consists out of two half cylinders
//-------------------------------------------------------------------------------------//

// Evoque Meshing Algorithm?
Do_Meshing= 1; // 0=false, 1=true
// Write Mesh files in .su2 format
Write_mesh= 0; // 0=false, 1=true

//Geometric inputs
cylinder_diameter = 1;
cylinder_radius = cylinder_diameter/2;
mesh_radius = 20 * cylinder_diameter;

//Mesh inputs
gridsize = 0.01;
Ncylinder = 202/2;
Nradial = 112;
Rradial = 1.06;

//-------------------------------------------------------------------------------------//
// Geometry definition
// Points
Point(1) = {-mesh_radius, 0, 0, gridsize};
Point(2) = {-cylinder_radius, 0, 0, gridsize};
Point(3) = {cylinder_radius, 0, 0, gridsize};
Point(4) = {mesh_radius, 0, 0, gridsize};
Point(5) = {0, 0, 0, gridsize};

//helping point to know height of first layer
//Point(6) = {-cylinder_radius - 0.002, 0, 0, gridsize};

// Lines
Line(1) = {1, 2}; // to the left
Line(2) = {3, 4}; // to the right

Circle(5) = {3, 5, 2}; // upper inner
Circle(6) = {4, 5, 1}; // upper outer

Line Loop(2) = {1, -5, 2, 6}; Plane Surface(2) = {2}; // upper half cylinder

//-------------------------------------------------------------------------------------//
// Mesh definition
// make structured mesh with transfinite Lines
Transfinite Line{-5, -6} = Ncylinder;
Transfinite Line{-1, 2} = Nradial Using Progression Rradial;

// Physical Groups
Physical Line("cylinder") = {5};
Physical Line("farfield") = {6};
Physical Line("symmetry") = {1, 2};
Physical Surface("surface_mesh") = {1, 2};

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
    Save "halfCylinder2D.su2";

EndIf
