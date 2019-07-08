// Kattmann, 07.02.2019, 3D 2 Zone Block mesh
// ------------------------------------------------------------------------- //

// Which domain part should be handled
Which_Mesh_Part= 0;// 0=all, 1=Fluid, 2=Solid
// Evoque Meshing Algorithm?
Do_Meshing= 1; // 0=false, 1=true
// Write Mesh files in .su2 format
Write_mesh= 1; // 0=false, 1=true

// Geometric inputs
length= 2;
width= 0.5;
lower_h= 1; // height of lower (solid) block
upper_h= 1; // height of upper (fluid) block

// Mesh inputs
gridsize = 0.1; // unimportant once everything is structured
Nx= 20;
Ny= 4;
Nz_solid= 15;
Rz_solid= 1.25;
Nz_fluid= 25;
Rz_fluid= 1.1;

// ------------------------------------------------------------------------- //
// interface mesh
Point(1) = {0, 0, 0, gridsize};
Point(2) = {0, width, 0, gridsize};
Point(3) = {length, width, 0, gridsize};
Point(4) = {length, 0, 0, gridsize};
Point(5) = {length/2, width, 0, gridsize};
Point(6) = {length/2, 0, 0, gridsize};

Line(1) = {2, 1};
Line(2) = {1, 6};
Line(3) = {6, 4};
Line(4) = {4, 3};
Line(5) = {3, 5};
Line(6) = {5, 2};
Line(7) = {5, 6};

Line Loop(1) = {1, 2, -7, 6}; Plane Surface(1) = {1};
Line Loop(2) = {4, 5, 7, 3}; Plane Surface(2) = {2};

Transfinite Line{1,7,4} = Ny;
Transfinite Line{2,6,3,5} = Nx;

If (Which_Mesh_Part == 1) // fluid
    Physical Surface("interface_1_fluid") = {1};
    Physical Surface("interface_2_fluid") = {2};
ElseIf (Which_Mesh_Part == 2) // solid
    Physical Surface("interface_1_solid") = {1};
    Physical Surface("interface_2_solid") = {2};
Else // whole mesh
    Physical Surface("interface_1") = {1};
    Physical Surface("interface_2") = {2};
EndIf

// ------------------------------------------------------------------------- //
// Fluid mesh
If (Which_Mesh_Part == 0 || Which_Mesh_Part == 1)

    Point(11) = {0, 0, upper_h, gridsize};
    Point(12) = {0, width, upper_h, gridsize};
    Point(13) = {length, width, upper_h, gridsize};
    Point(14) = {length, 0, upper_h, gridsize};
    Point(15) = {length/2, width, upper_h, gridsize};
    Point(16) = {length/2, 0, upper_h, gridsize};

    // Top Lines
    Line(11) = {12, 11};
    Line(12) = {11, 16};
    Line(13) = {16, 14};
    Line(14) = {14, 13};
    Line(15) = {13, 15};
    Line(16) = {15, 12};
    Line(17) = {15, 16};

    // In z-direction
    Line(18) = {1, 11};
    Line(19) = {6, 16};
    Line(20) = {4, 14};
    Line(21) = {3, 13};
    Line(22) = {5, 15};
    Line(23) = {2, 12};

    // Surface definition
    Line Loop(11) = {11, 12, -17, 16}; Plane Surface(11) = {11}; // top front
    Line Loop(12) = {14, 15,  17, 13}; Plane Surface(12) = {12}; // top back
    Line Loop(13) = {18, 12, -19, -2}; Plane Surface(13) = {13}; // side right front
    Line Loop(14) = {19, 13, -20, -3}; Plane Surface(14) = {14}; // side right back
    Line Loop(15) = {23, -16, -22, 6}; Plane Surface(15) = {15}; // side left front
    Line Loop(16) = {22, -15, -21, 5}; Plane Surface(16) = {16}; // side left back
    Line Loop(17) = {23, 11, -18, -1}; Plane Surface(17) = {17}; // inlet
    Line Loop(18) = {4, 21, -14, -20}; Plane Surface(18) = {18}; // outlet
    Line Loop(19) = {17, -19, -7, 22}; Plane Surface(19) = {19}; // inner face

    // Volume definition
    Surface Loop(1) = {13, 17, 15, 11, 1, 19}; Volume(1) = {1}; // front
    Surface Loop(2) = {14, 12, 18, 2, 16, 19}; Volume(2) = {2}; // back

    // Structured meshing
    Transfinite Line{11,17,14} = Ny;
    Transfinite Line{12,16,13,15} = Nx;
    Transfinite Line{18,19,20,21,22,23} = Nz_fluid Using Progression Rz_fluid;

    Physical Surface("fluid_inlet") = {17};
    Physical Surface("fluid_outlet") = {18};
    Physical Surface("fluid_top") = {11,12};
    Physical Surface("fluid_sides") = {13,14,15,16};
    Physical Volume("fluid_volume") = {1,2};

EndIf
// ------------------------------------------------------------------------- //
// Solid mesh
If (Which_Mesh_Part == 0 || Which_Mesh_Part == 2)

    Point(31) = {0, 0, -lower_h, gridsize};
    Point(32) = {0, width, -lower_h, gridsize};
    Point(33) = {length, width, -lower_h, gridsize};
    Point(34) = {length, 0, -lower_h, gridsize};
    Point(35) = {length/2, width, -lower_h, gridsize};
    Point(36) = {length/2, 0, -lower_h, gridsize};

    // Top Lines
    Line(31) = {32, 31};
    Line(32) = {31, 36};
    Line(33) = {36, 34};
    Line(34) = {34, 33};
    Line(35) = {33, 35};
    Line(36) = {35, 32};
    Line(37) = {35, 36};

    // In z-direction
    Line(38) = {1, 31};
    Line(39) = {6, 36};
    Line(40) = {4, 34};
    Line(41) = {3, 33};
    Line(42) = {5, 35};
    Line(43) = {2, 32};

    // Surface definition
    Line Loop(21) = {31, 32, -37, 36};  Plane Surface(21) = {21}; // bottom front
    Line Loop(22) = {37, 33, 34, 35};   Plane Surface(22) = {22}; // bottom back
    Line Loop(23) = {38, 32, -39, -2};  Plane Surface(23) = {23}; // side right front
    Line Loop(24) = {39, 33, -40, -3};  Plane Surface(24) = {24}; // side right back
    Line Loop(25) = {43, -36, -42, 6};  Plane Surface(25) = {25}; // side left front
    Line Loop(26) = {42, -35, -41, 5};  Plane Surface(26) = {26}; // side left back
    Line Loop(27) = {43, 31, -38, -1};  Plane Surface(27) = {27}; // inlet
    Line Loop(28) = {41, -34, -40, 4};  Plane Surface(28) = {28}; // outlet
    Line Loop(29) = {42, 37, -39, -7};  Plane Surface(29) = {29}; // inner face

    // Volume definition
    Surface Loop(3) = {23, 27, 25, 21, 1, 29}; Volume(3) = {3};
    Surface Loop(4) = {28, 26, 22, 24, 2, 29}; Volume(4) = {4};

    // Structured meshing
    Transfinite Line{31,37,34} = Ny;
    Transfinite Line{32,36,33,35} = Nx;
    Transfinite Line{38,39,40,41,42,43} = Nz_solid Using Progression Rz_solid;

    Physical Surface("solid_inlet") = {27};
    Physical Surface("solid_outlet") = {28};
    Physical Surface("solid_bottom") = {21,22};
    Physical Surface("solid_sides") = {23,24,25,26};
    Physical Volume("solid_volume") = {3,4};

EndIf

// ------------------------------------------------------------------------- //
// Meshing
Transfinite Surface "*";
Recombine Surface "*";
Transfinite Volume "*";

If (Do_Meshing == 1)
    Mesh 1; Mesh 2; Mesh 3;
EndIf

// ------------------------------------------------------------------------- //
// Write .su2 meshfile
If (Write_mesh == 1)

    Mesh.Format = 42; // .su2 mesh format, 
    If (Which_Mesh_Part == 1)
        Save "fluid.su2";
    ElseIf (Which_Mesh_Part == 2)
        Save "solid.su2";
    Else
        Printf("Unvalid Which_Mesh_Part variable.");
        Abort;
    EndIf

EndIf
