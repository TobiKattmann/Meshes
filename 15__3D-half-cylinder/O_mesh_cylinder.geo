// ----------------------------------------------------------------------------------- //
// Kattmann 20.08.2018, O mesh for vortex shedding behind cylinder
// The O mesh around the cylinder consists out of two half cylinders
// ----------------------------------------------------------------------------------- //

// Evoque Meshing Algorithm?
Do_Meshing= 1; // 0=false, 1=true
// Write Mesh files in .su2 format
Write_mesh= 1; // 0=false, 1=true
mesh_name= "half_cylinder_3D_finest.su2";

//Geometric inputs
cylinder_diameter = 1;
cylinder_radius = cylinder_diameter/2;
mesh_radius = 10 * cylinder_diameter;
cylinder_length = 2;

// ----------------------------------------------------------------------------------- //
//Mesh inputs
gridsize = 0.01;
Ncylinder = 160;
Nradial = 80;
Rradial = 1.1;
Ndepth = 100;

// ----------------------------------------------------------------------------------- //
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

// Lineloops and surfaces
Line Loop(2) = {1, -5, 2, 6}; Plane Surface(2) = {2}; // upper half cylinder

// ----------------------------------------------------------------------------------- //
// Copied slice in positive z direction
Point(11) = {-mesh_radius, 0, cylinder_length, gridsize};
Point(12) = {-cylinder_radius, 0, cylinder_length, gridsize};
Point(13) = {cylinder_radius, 0, cylinder_length, gridsize};
Point(14) = {mesh_radius, 0, cylinder_length, gridsize};
Point(15) = {0, 0, cylinder_length, gridsize};

//helping point to know height of first layer
//Point(6) = {-cylinder_radius - 0.002, 0, 0, gridsize};

// Lines
Line(11) = {11, 12}; // to the left
Line(12) = {13, 14}; // to the right

Circle(15) = {13, 15, 12}; // upper inner
Circle(16) = {14, 15, 11}; // upper outer

// Lineloops and surfaces
Line Loop(12) = {11, -15, 12, 16}; Plane Surface(12) = {12}; // upper half cylinder

// ----------------------------------------------------------------------------------- //
// connecting slices
Line(17) = {1, 11};
Line(18) = {2, 12};
Line(19) = {3, 13};
Line(20) = {4, 14};

// surface upper arch
Curve Loop(15) = {17, -16, -20, 6}; Surface(15) = {15};

// surface cylinder
Curve Loop(16) = {18, -15, -19, 5}; Surface(16) = {16};

// surface bottom parts
Line Loop(13) = {17, 11, -18, -1}; Plane Surface(13) = {13};
Line Loop(14) = {19, 12, -20, -2}; Plane Surface(14) = {14};

// ----------------------------------------------------------------------------------- //
// Mesh definition
// make structured mesh with transfinite Lines

// upper left and right
Transfinite Line{-5, -6, -15, -16} = Ncylinder;
Transfinite Line{-1, 2, -11, 12} = Nradial Using Progression Rradial;
// connecting lines
Transfinite Line{17, 18, 19, 20} = Ndepth;

// Physical Groups
Physical Surface("cylinder") = {16};
Physical Surface("farfield") = {15};
Physical Surface("bottom") = {13, 14};
Physical Surface("left_side") = {2};
Physical Surface("right_side") = {12};

// create Volume
Surface Loop(1) = {15, 13, 12, 16, 14, 2}; Volume(1) = {1};
Physical Volume("fluid") = {1};

// ----------------------------------------------------------------------------------- //
Transfinite Surface "*";
Recombine Surface "*";
Transfinite Volume "*";

If (Do_Meshing == 1)
    Mesh 1; Mesh 2; Mesh 3;
EndIf

// ----------------------------------------------------------------------------------- //
// Write .su2 meshfile
If (Write_mesh == 1)

    Mesh.Format = 42; // .su2 mesh format, 
    Save Str(mesh_name);

EndIf
