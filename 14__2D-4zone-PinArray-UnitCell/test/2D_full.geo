// ------------------------------------------------------------------------- //
// T. Kattmann, 18.06.2019, 2D 2 Zone mesh
// Create the mesh by calling this geo file with 'gmsh <this>.geo'.
// For multizone mesh the zonal meshes have to be created using the first 
// option 'Which_Mesh_Part' below and have to be married appropriatley.
// ------------------------------------------------------------------------- //

// Which domain part should be handled
Which_Mesh_Part= 1; // 0=all, 1=Fluid, 2=Solid, 3=InterfaceOnly
// Add outlet diffusor
OutletDiffusor= 0; // 0=false, 1=true
// Evoque Meshing Algorithm?
Do_Meshing= 1; // 0=false, 1=true
// Write Mesh files in .su2 format
Write_mesh= 1; // 0=false, 1=true
// Mesh Resolution
Mesh_Resolution= 2; // 0=debugRes, 1=Res1, 2=Res2
// show the FFD corner points
FFD_corner_point= 0; // 0=false, 1=true
// Mirror the mesh
Mirror_Mesh= 1; // 0=false, 1=true

// Free parameters
scale_factor= 1e-3; // scales Point positions from [mm] to [m] with 1e-3
dist= 6.44 * scale_factor; // distance between pin midpoints, each pin has 6 surrounding pins, i.e. 60 deg between each
r_pin_lower= 2.0 * scale_factor; // lower pin radius
InnerRadiusFactor= 0.3; // Thickness of the pin solid (0.9=small pin wall, 0.1= close to filled circle arc). Requires 0 < value < 1.
// Diffusor inputs are below in the respective section

// Dependent parameters
rad2deg= Pi/180; // conversion factor as gmsh Cos/Sin functions take radian values
length= 2 * Cos(30*rad2deg)*dist; // domain length (in x-dir)
width= Sin(30*rad2deg)*dist; // domain width (in y-dir)

Printf("===================================");
Printf("Free parameters:");
Printf("-> distance between pins: %g", dist);
Printf("-> lower pin radius: %g", r_pin_lower);
Printf("Dependent parameters");
Printf("-> length: %g", length);
Printf("-> width: %g", width);
Printf("===================================");

// Mesh inputs
gs = 0.5 *scale_factor; // gridsize

If(Mesh_Resolution==0) // debugRes
    // interface meshing parameteres. Also sufficient for fluid domain meshing.
    N_x_flow= 10; // #gridpoints in flow x-direction on a patch. Also N_x_flow/2 on smaller patches employed.

    N_y_flow = 10; // #gridpoints normal to pin surface, y-direction
    R_y_flow= 1.08; // Progression normal to pin surface

    N_z_flow= 20; // #gridpoints in height z-direction
    R_z_flow= 0.05; // Bump in height as top and bottom are walls

    // Additional meshing parameters for solid domain
    N_y_innerPin= 5; // #gridpoints of the structured first part of the inner Pin in y-direction / normal to the pin
    R_y_innerPin= 0.93; // Progression towards interface
    N_z_solid= 10; // #points from bottom interface to heater surface
    R_z_solid= 1.18; // progression for N_z_solid

ElseIf(Mesh_Resolution==1) // Res1
    // interface meshing parameteres. Also sufficient for fluid domain meshing.
    N_x_flow= 20; // #gridpoints in flow x-direction on a patch. Also N_x_flow/2 on smaller patches employed.

    N_y_flow = 40; // #gridpoints normal to pin surface, y-direction
    R_y_flow= 1.08; // Progression normal to pin surface

    N_z_flow= 100; // #gridpoints in height z-direction
    R_z_flow= 0.05; // Bump in height as top and bottom are walls

    // Additional meshing parameters for solid domain
    N_y_innerPin= 30; // #gridpoints of the structured first part of the inner Pin in y-direction / normal to the pin
    R_y_innerPin= 0.93; // Progression towards interface
    N_z_solid= 20; // #points from bottom interface to heater surface
    R_z_solid= 1.18; // progression for N_z_solid

ElseIf(Mesh_Resolution==2) // Res2
    // interface meshing parameteres. Also sufficient for fluid domain meshing.
    N_x_flow= 30; // #gridpoints in flow x-direction on a patch. Also N_x_flow/2 on smaller patches employed.

    N_y_flow = 50; // #gridpoints normal to pin surface, y-direction
    R_y_flow= 1.08; // Progression normal to pin surface

    N_z_flow= 200; // #gridpoints in height z-direction
    R_z_flow= 0.05; // Bump in height as top and bottom are walls

    // Additional meshing parameters for solid domain
    N_y_innerPin= 40; // #gridpoints of the structured first part of the inner Pin in y-direction / normal to the pin
    R_y_innerPin= 0.91; // Progression towards interface
    N_z_solid= 30; // #points from bottom interface to heater surface
    R_z_solid= 1.18; // progression for N_z_solid

EndIf

// Feasability checks
If (r_pin_lower >= width ||
    r_pin_lower <= 0)
    Printf("Aborting! Bad Inputs");
    Abort;
EndIf

// Show and print possible FFD corner points
If (FFD_corner_point==1)
    boxFactor= 1.3;

    xLo= 0.5*length - boxFactor*r_pin_lower;
    xHi= 0.5*length + boxFactor*r_pin_lower;
    yLo= 0;
    yHi= boxFactor*r_pin_lower;

    // counterclockwise from lowest x&y value
    Printf("===================================");
    Printf("FFD corner points:");
    Printf("%g | %g", xLo, yLo);
    Printf("%g | %g", xHi, yLo);
    Printf("%g | %g", xHi, yHi);
    Printf("%g | %g", xLo, yHi);
    Printf("===================================");

    Point(1000) = {xLo, yLo, 0, gs};
    Point(1001) = {xHi, yLo, 0, gs};
    Point(1002) = {xHi, yHi, 0, gs};
    Point(1003) = {xLo, yHi, 0, gs};

    Line(1000) = {1000,1001};
    Line(1001) = {1001,1002};
    Line(1002) = {1002,1003};
    Line(1003) = {1003,1000};
EndIf

// ------------------------------------------------------------------------- //
// CHT Interface, complete description as it is part of fluid and solid
// Id's starting with in the range (1-99)
// Interface only description
If (Which_Mesh_Part == 0 || Which_Mesh_Part == 1 || Which_Mesh_Part == 2 || Which_Mesh_Part == 3)
    // Points
    // Lower Pin1
    Point(10) = {0, width, 0, gs}; // lower pin1 midpoint
    Point(11) = {0, width-r_pin_lower, 0, gs}; // lower pin1 on inlet
    Point(12) = {Sin(30*rad2deg)*r_pin_lower, width-Cos(30*rad2deg)*r_pin_lower, 0, gs}; // lower pin1 in between
    Point(13) = {r_pin_lower, width, 0, gs}; // lower pin1 on sym
    Circle(10) = {11,10,12}; // lower pin1 smaller first part
    Circle(11) = {12,10,13}; // lower pin1 larger second part

    // Lower Pin2
    Point(20) = {0.5*length, 0, 0, gs}; // pin midpoint
    Point(21) = {0.5*length - r_pin_lower, 0, 0, gs}; // lower small x
    Point(22) = {length/2 - Sin(30*rad2deg)*r_pin_lower, Cos(30*rad2deg)*r_pin_lower, 0, gs}; // small intermediate
    Point(23) = {length/2 + Sin(30*rad2deg)*r_pin_lower, Cos(30*rad2deg)*r_pin_lower, 0, gs}; // large intermediate
    Point(24) = {0.5*length + r_pin_lower, 0, 0, gs}; // lower large x
    Circle(20) = {21,20,22}; // first segment
    Circle(21) = {22,20,23}; // second segment
    Circle(22) = {23,20,24}; // third segment

    // lower Pin3
    Point(30) = {length, width, 0, gs}; // midpoint
    Point(31) = {length, width-r_pin_lower, 0, gs}; // on outlet
    Point(32) = {length-Sin(30*rad2deg)*r_pin_lower, width-Cos(30*rad2deg)*r_pin_lower,0, gs};
    Point(33) = {length - r_pin_lower, width, 0, gs}; // on sym
    Circle(30) = {31,30,32}; // first segment
    Circle(31) = {32,30,33}; // second segment

    // No progression in flow direction on the pin surface
    Transfinite Line {11,20,21,22,31} = N_x_flow;
    Transfinite Line {10,30} = N_x_flow/2;

    //Physical Tags
    If (Which_Mesh_Part==1)
        Physical Line("fluid_pin1_interface") = {10, 11};
        Physical Line("fluid_pin2_interface") = {20, 21, 22};
        Physical Line("fluid_pin3_interface") = {30, 31};

    ElseIf (Which_Mesh_Part==2)
        Physical Line("solid_pin1_interface") = {10, 11};
        Physical Line("solid_pin2_interface") = {20, 21, 22};
        Physical Line("solid_pin3_interface") = {30, 31};

    EndIf

EndIf

// ------------------------------------------------------------------------- //
// Fluid only description
If (Which_Mesh_Part == 0 || Which_Mesh_Part == 1)

    // lower additional structured mesh points
    Point(40) = {length/4 + Tan(30*rad2deg)*width/2, width, 0, gs}; // first half, large y
    Point(41) = {length/4 - Tan(30*rad2deg)*width/2, 0, 0, gs}; // first half, small y
    Point(42) = {length*3/4 - Tan(30*rad2deg)*width/2, width, 0, gs}; // second half, large y
    Point(43) = {length*3/4 + Tan(30*rad2deg)*width/2, 0, 0, gs}; // second half, small y
    Point(44) = {0, 0, 0, gs}; // corner point inlet
    Point(45) = {length, 0, 0, gs}; // corner point outlet

    // lower additional structured mesh lines
    // outer boundary
    Line(40) = {11, 44};
    Line(41) = {44, 41};
    Line(42) = {41, 21};
    Line(43) = {43, 24};
    Line(44) = {43, 45};
    Line(45) = {45, 31};
    Line(46) = {33, 42};
    Line(47) = {42, 40};
    Line(48) = {40, 13};
    // inner lines
    Line(49) = {41, 12};
    Line(50) = {41, 40};
    Line(51) = {22, 40};
    Line(52) = {23, 42};
    Line(53) = {42, 43};
    Line(54) = {43, 32};

    // line loops and surfaces on lower domain interface
    Line Loop(10) = {40, 41, 49, -10}; Plane Surface(10) = {10};
    Line Loop(11) = {-49, 50, 48, -11}; Plane Surface(11) = {11};
    Line Loop(12) = {42, 20, 51, -50}; Plane Surface(12) = {12};
    Line Loop(13) = {-51, 21, 52, 47}; Plane Surface(13) = {13};
    Line Loop(14) = {53, 43, -22, 52}; Plane Surface(14) = {14};
    Line Loop(15) = {53, 54, 31, 46}; Plane Surface(15) = {15};
    Line Loop(16) = {44, 45, 30, -54}; Plane Surface(16) = {16};

    // No progression in flow direction on the pin surface
    Transfinite Line {50,47,53} = N_x_flow;
    Transfinite Line {41,44} = N_x_flow/2;
    // Progression normal to the pin surface
    Transfinite Line {40, -49, -48, -42, 51, 52, -43, 46, -54, -45} = N_y_flow Using Progression R_y_flow;

    // Physical tags
    Physical Line("fluid_inlet") = {40};
    
    If(OutletDiffusor==0) Physical Line("fluid_outlet") = {45}; EndIf //
    If(Mirror_Mesh==0)
        Physical Line("fluid_symmetry") = {41,42,43,44,46,47,48};
    Else
        Physical Line("fluid_symmetry") = {41,42,43,44};
    EndIf
    Physical Surface("fluid_surf") = {10,11,12,13,14,15,16};

EndIf

If (Mirror_Mesh)

    y_plane = -1;
    //d_plane = 0.00322; // 4 half pins in the domain
    d_plane = 0.0; // 4 quarter pins and full pin in the middle

    //Put all Points, Lines and Surfaces in arrays http://onelab.info/pipermail/gmsh/2017/011186.html
    p[] = Point "*";
    l[] = Line "*";
    s[] = Surface "*";

    //Removal of doubled points at stichted surfaces (in/outlet) http://gmsh.info/doc/texinfo/gmsh.html
    Geometry.AutoCoherence = 0;
    //Keep meshing iformation on duplicated domain https://stackoverflow.com/questions/49197879/duplicate-structured-surface-mesh-in-gmsh/50079210
    Geometry.CopyMeshingMethod = 1;

    // Translate all points 
    Symmetry {0, y_plane, 0, d_plane} { Duplicata { Point{ p[] }; } }

    // inlet
    new_fluid_inlet[] = Symmetry {0, y_plane, 0, d_plane} { Duplicata { Line{ 40 }; } };
    Physical Line("fluid_inlet") += { new_fluid_inlet[] };

    // outlet
    new_fluid_outlet[] = Symmetry {0, y_plane, 0, d_plane} { Duplicata { Line{ 45 }; } };
    Physical Line("fluid_outlet") += { new_fluid_outlet[] };

    // symmetry
    new_fluid_symmetry_gone[] = Symmetry {0, y_plane, 0, d_plane} { Duplicata { Line{ 46,47,48 }; } };
    new_fluid_symmetry[] = Symmetry {0, y_plane, 0, d_plane} { Duplicata { Line{ 41,42,43,44 }; } };
    Physical Line("fluid_symmetry2") += { new_fluid_symmetry[] };

    // fluid_pin123_interface
    new_pin1[] = Symmetry {0, y_plane, 0, d_plane} { Duplicata { Line{ 10, 11 }; } };
    Physical Line("fluid_pin1_interface") += { new_pin1[] };
    new_pin2[] = Symmetry {0, y_plane, 0, d_plane} { Duplicata { Line{ 20, 21, 22 }; } };
    Physical Line("fluid_pin2_interface") += { new_pin2[] };
    new_pin3[] = Symmetry {0, y_plane, 0, d_plane} { Duplicata { Line{ 30, 31 }; } };
    Physical Line("fluid_pin3_interface") += { new_pin3[] };


    // fluid surface / body
    new_fluid_surf[] = Symmetry {0, y_plane, 0, d_plane} { Duplicata { Surface{ 10,11,12,13,14,15,16 }; } };
    Physical Surface("fluid_surf") += { new_fluid_surf[] };

    Coherence; // Remove all identical entities
EndIf

// ------------------------------------------------------------------------- //
// Meshing
Coherence;
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
        If (OutletDiffusor==0)
            Save "fluid.su2";
        Else
            Save "fluid_diffusor.su2";
        EndIf

    ElseIf (Which_Mesh_Part == 2)
        If (OutletDiffusor==0)
            Save "solid.su2";
        Else
            Save "solid_diffusor.su2";
        EndIf

    Else
        Printf("Unvalid Which_Mesh_Part variable for output writing.");
        Abort;
    EndIf

EndIf
