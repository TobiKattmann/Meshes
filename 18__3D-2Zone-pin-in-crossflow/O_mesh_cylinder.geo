// ----------------------------------------------------------------------------------- //
// T. Kattmann 08.10.2021, 3D O mesh for CHT vortex shedding behind cylinder
// The O mesh around the cylinder consists out of two half cylinders.
// The pin has an extension below the fluid domain.
// ----------------------------------------------------------------------------------- //

// Which domain part should be handled
Which_Mesh_Part= 2;// 0=all, 1=Fluid, 2=Solid
// bool whether to mirrir mesh along x-axes. In case of not mirrored, a symmetry bc is necessary
Mirror_Mesh= 1; // 0=false, 1=true
// Evoke Meshing Algorithm?
Do_Meshing= 1; // 0=false, 1=true
// Write Mesh files in .su2 format
Write_mesh= 0; // 0=false, 1=true

//Geometric inputs
m_to_mm_scale= 1e-3;
pin_d_lower = 4.6  * m_to_mm_scale; // lower pin diameter
pin_d_upper = 4.6 * m_to_mm_scale; // upper pin diameter, choose smaller for conical pin (1.06 before)
pin_r_lower = pin_d_lower/2; // radius
pin_r_upper = pin_d_lower/2;
pin_height= 10 * m_to_mm_scale;

bf_factor= 0.3; // Must be smaller than 1
bf_length_lower= pin_r_lower * bf_factor; // side length of inner pin butterfly mesh, lower surface
bf_length_upper= pin_r_upper * bf_factor; // side length of inner pin butterfly mesh, upper surface

heater_depth= 5 * m_to_mm_scale; // extension of the heater
heater_d= 3 * pin_d_lower; // must be bigger than pin_d_lower but smaller than mesh_radius
heater_r= heater_d/2;

mesh_radius = 20 * pin_d_lower;

rad2deg= Pi/180; // conversion factor as gmsh Cos/Sin functions take radian values
// ----------------------------------------------------------------------------------- //
//Mesh inputs
gridsize = 0.1;

// interface, relevant for fluid and solid
N_pin_height= 20; // points in pin height direction
R_pin_height= 1.1; // Progression to bottom wall

N_pin_circ_eigth= 5; // points in circumferencial direction for an eigth pin (2 eigth and 1 quarter)

N_radial_heater= 20; // points leading away from pin radially on the heater
R_radial_heater= 1.1; // Progression

// fluid only
N_radial_freestream = 35; // points leading away from inner fluid box radially to freestream
R_radial_freestream = 1.0; // points leading away from inner fluid box radially to freestream

// solid only
N_pin_solid_radial_outer= 14; // points radially outward facing in inner pin
R_pin_solid_radial_outer= 0.9; // corresponding progression, maybe match with spacing on the fluid side

N_heater_depth= 10; // points in depth directin of the heater
R_heater_depth= 1.2; // corresponding progression, match with pin progression to wall

Do_not_use_progression_for_bottom_heat= 1; // 0=false, 1=true

// First, the interface is created and meshed, then the remaining parts of the fluid and
// solid zone are created and meshed
//
// ----------------------------------------------------------------------------------- //
// Interface
If (Which_Mesh_Part == 0 || Which_Mesh_Part == 1 || Which_Mesh_Part == 2)

    /// Pin Surface
    // lower pin
    Point(1) = {0, 0, 0, gridsize};
    Point(2) = {-pin_r_lower, 0, 0, gridsize};
    Point(3) = { pin_r_lower, 0, 0, gridsize};

    Point(4) = {-Sin(45*rad2deg)*pin_r_lower, Sin(45*rad2deg)*pin_r_lower, 0, gridsize}; // butterly points on the interface
    Point(5) = { Sin(45*rad2deg)*pin_r_lower, Sin(45*rad2deg)*pin_r_lower, 0, gridsize};

    Circle(1) = {2,1,4}; // 3 circle segments from front to back
    Circle(2) = {4,1,5};
    Circle(3) = {5,1,3};
    // Transfinite Lines below.

    // upper pin
    Point(11) = {0, 0, pin_height, gridsize};
    Point(12) = {-pin_r_upper, 0, pin_height, gridsize};
    Point(13) = { pin_r_upper, 0, pin_height, gridsize};

    Point(14) = {-Sin(45*rad2deg)*pin_r_upper, Sin(45*rad2deg)*pin_r_upper, pin_height, gridsize}; // butterly points on the interface
    Point(15) = { Sin(45*rad2deg)*pin_r_upper, Sin(45*rad2deg)*pin_r_upper, pin_height, gridsize};

    Circle(11) = {12,11,14};
    Circle(12) = {14,11,15};
    Circle(13) = {15,11,13};
    // Transfinite Lines below.

    // connecting lines from lower to upper cyinder, front to back
    Line(20) = {2,12};
    Line(21) = {3,13};
    Line(22) = {4,14};
    Line(23) = {5,15}; // Line orientation has to be swapped, because fluid mesh mirroring doesnt like it
    Transfinite Line {20,21,22,23} = N_pin_height Using Progression R_pin_height;

    // pin surfaces
    Curve Loop(1) = {1, 22, -11, -20}; Surface(1) = {1};
    Curve Loop(2) = {2, 23, -12, -22}; Surface(2) = {2};
    Curve Loop(3) = {-3, -21, 13, 23}; Surface(3) = {3};

    /// bottom interface
    Point(32) = {-heater_d, 0, 0, gridsize};
    Point(33) = { heater_d, 0, 0, gridsize};

    Point(34) = {-Sin(45*rad2deg)*heater_d, Sin(45*rad2deg)*heater_d, 0, gridsize}; // butterly points on the interface
    Point(35) = { Sin(45*rad2deg)*heater_d, Sin(45*rad2deg)*heater_d, 0, gridsize};

    Circle(34) = {32,1,34};
    Circle(35) = {34,1,35};
    Circle(36) = {35,1,33};
    // eigths segments
    Transfinite Line {1,3,11,13,34,36} = N_pin_circ_eigth;
    // quarter segments
    Transfinite Line {2,12,35} = 2*N_pin_circ_eigth;

    // Connecting lines between bottom interface and pin
    Line(30) = {2,32};
    Line(31) = {3,33};
    Line(32) = {4,34};
    Line(33) = {5,35};
    Transfinite Line {30,31,32,33} = N_radial_heater Using Progression R_radial_heater;

    Curve Loop(4) = {1, 32, -34, -30}; Surface(4) = {4};
    Curve Loop(5) = {2, 33, -35, -32}; Surface(5) = {5};
    Curve Loop(6) = {-3, -31, 36, 33}; Surface(6) = {6};

    //Physical Tags
    If (Which_Mesh_Part==1)
        Physical Surface("fluid_pin_interface") = {1,2,3};
        Physical Surface("fluid_heater_interface") = {4,5,6};

    ElseIf (Which_Mesh_Part==2)
        Physical Surface("solid_pin_interface") = {1,2,3};
        Physical Surface("solid_heater_interface") = {4,5,6};

    EndIf

EndIf

// ----------------------------------------------------------------------------------- //
// Fluid zone
If (Which_Mesh_Part == 0 || Which_Mesh_Part == 1)

    /// First create mesh around pin attached to the heater, then go for the outer part
    // upper extended heater interface
    Point(142) = {-heater_d, 0, pin_height, gridsize};
    Point(143) = { heater_d, 0, pin_height, gridsize};

    Point(144) = {-Sin(45*rad2deg)*heater_d, Sin(45*rad2deg)*heater_d, pin_height, gridsize}; // butterly points on the interface
    Point(145) = { Sin(45*rad2deg)*heater_d, Sin(45*rad2deg)*heater_d, pin_height, gridsize};

    Circle(144) = {142,11,144};
    Circle(145) = {144,11,145};
    Circle(146) = {145,11,143};

    // Connecting lines between upper interface and pin
    Line(140) = {12,142};
    Line(141) = {13,143};
    Line(142) = {14,144};
    Line(143) = {15,145}; // had to be reversed because the mirrored mesh sometimes fucks this up for some reason.
    Transfinite Line {140,141,142,143} = N_radial_heater Using Progression R_radial_heater;

    // connecting lines between lower and upper outer heater surface
    Line(147) = {32, 142};
    Line(148) = {34, 144};
    Line(149) = {35, 145};
    Line(150) = {33, 143};
    Transfinite Line {147,148,149,150} = N_pin_height Using Progression R_pin_height;

    // Surfaces between extended heater and freestream mesh, doesnt need naming
    Curve Loop(107) = {147, 144, -148, -34}; Surface(107) = {107};
    Curve Loop(108) = {35, 149, -145, -148}; Surface(108) = {108};
    Curve Loop(109) = {36, 150, -146, -149}; Surface(109) = {109};

    // symmetry of fluid heater domain
    Curve Loop(110) = {30, 147, -140, -20}; Plane Surface(110) = {110};
    Curve Loop(111) = {21, 141, -150, -31}; Plane Surface(111) = {111};

    // fluid top
    Curve Loop(112) = {142, -144, -140, 11}; Plane Surface(112) = {112};
    Curve Loop(113) = {142, 145, -143, -12}; Plane Surface(113) = {113};
    Curve Loop(114) = {146, -141, -13, 143}; Plane Surface(114) = {114};
    Physical Surface("fluid_top") = {112,113,114};

    // Inner surfaces from from pin sectioning
    Curve Loop(115) = {142, -148, -32, 22}; Plane Surface(115) = {115};
    Curve Loop(116) = {33, 149, -143, -23}; Plane Surface(116) = {116};

    // Fluid extended heater domain, volume definition
    Surface Loop(11) = {110, 4, 1, 112, 107, 115}; Volume(11) = {11};
    Surface Loop(12) = {111, 3, 6, 109, 114, 116}; Volume(12) = {12};
    Surface Loop(13) = {113, 108, 5, 2, 115, 116}; Volume(13) = {13};
    Physical Volume("fluid_volume") = {11,12,13};

    /// From here the outer freestream mesh
    // lower part
    Point(162) = {-mesh_radius, 0, 0, gridsize};
    Point(163) = { mesh_radius, 0, 0, gridsize};
    Point(164) = {-Sin(45*rad2deg)*mesh_radius, Sin(45*rad2deg)*mesh_radius, 0, gridsize}; // butterly points on the interface
    Point(165) = { Sin(45*rad2deg)*mesh_radius, Sin(45*rad2deg)*mesh_radius, 0, gridsize};

    Circle(164) = {162,1,164}; // 3 circle segments from front to back
    Circle(165) = {164,1,165};
    Circle(166) = {165,1,163};
    // Transfinite Lines below.

    Line(160) = {32,162}; // Lines connecting to heater box, inside out
    Line(161) = {33,163};
    Line(162) = {34,164};
    Line(163) = {35,165};
    // Transfinite Lines below.

    // upper part
    Point(172) = {-mesh_radius, 0, pin_height, gridsize};
    Point(173) = { mesh_radius, 0, pin_height, gridsize};
    Point(174) = {-Sin(45*rad2deg)*mesh_radius, Sin(45*rad2deg)*mesh_radius, pin_height, gridsize}; // butterly points on the interface
    Point(175) = { Sin(45*rad2deg)*mesh_radius, Sin(45*rad2deg)*mesh_radius, pin_height, gridsize};

    Circle(174) = {172,11,174}; // 3 circle segments from front to back
    Circle(175) = {174,11,175};
    Circle(176) = {175,11,173};
    Transfinite Line {164,166,174,176,144,146} = N_pin_circ_eigth;
    Transfinite Line {145,175,165} = 2*N_pin_circ_eigth;

    Line(170) = {142,172}; // Lines connecting to heater box, inside out
    Line(171) = {143,173};
    Line(172) = {144,174};
    Line(173) = {145,175};
    Transfinite Line {160,161,162,163,170,171,172,173} = N_radial_freestream Using Progression R_radial_freestream;

    // Lines connecting upper and lower outer box
    Line(177) = {162, 172};
    Line(178) = {164, 174};
    Line(179) = {165, 175};
    Line(180) = {163, 173};
    Transfinite Line {177,178,179,180} = N_pin_height Using Progression R_pin_height;

    // Surfaces to freestream
    Curve Loop(118) = {164, 178, -174, -177}; Surface(118) = {118};
    Curve Loop(119) = {165, 179, -175, -178}; Surface(119) = {119};
    Curve Loop(120) = {166, 180, -176, -179}; Surface(120) = {120};
    Physical Surface("fluid_freestream") = {118,119,120};

    // symmetry of fluid heater domain, doesnt need naming
    Curve Loop(121) = {160, 177, -170, -147}; Plane Surface(121) = {121};
    Curve Loop(122) = {161, 180, -171, -150}; Plane Surface(122) = {122};

    // fluid top
    Curve Loop(123) = {170, 174, -172, -144}; Plane Surface(123) = {123};
    Curve Loop(124) = {175, -173, -145, 172}; Plane Surface(124) = {124};
    Curve Loop(125) = {176, -171, -146, 173}; Plane Surface(125) = {125};
    Physical Surface("fluid_top") += {123,124,125};

    // Inner surfaces from from pin sectioning
    Curve Loop(126) = {162, 178, -172, -148}; Plane Surface(126) = {126};
    Curve Loop(127) = {149, 173, -179, -163}; Plane Surface(127) = {127};

    // fluid bottom, only the freestream part
    Curve Loop(128) = {160, 164, -162, -34}; Plane Surface(128) = {128};
    Curve Loop(129) = {35, 163, -165, -162}; Plane Surface(129) = {129};
    Curve Loop(130) = {36, 161, -166, -163}; Plane Surface(130) = {130};
    Physical Surface("fluid_bottom") = {128,129,130};

    // Fluid freestream domain, volume definition
    Surface Loop(14) = {121, 128, 118, 123, 126, 107}; Volume(14) = {14};
    Surface Loop(15) = {119, 129, 124, 126, 127, 108}; Volume(15) = {15};
    Surface Loop(16) = {125, 120, 130, 122, 127, 109}; Volume(16) = {16};
    Physical Volume("fluid_volume") += {14,15,16};

EndIf

// ----------------------------------------------------------------------------------- //
// Pin zone
If (Which_Mesh_Part == 0 || Which_Mesh_Part == 2)

    /// Lower inner pin
    Point(82) = {-bf_length_lower, 0,         0, gridsize};
    Point(83) = { bf_length_lower, 0,         0, gridsize};
    Point(84) = {-bf_length_lower, bf_length_lower, 0, gridsize};
    Point(85) = { bf_length_lower, bf_length_lower, 0, gridsize};

    // radial outward going between butterfly core and pin interface
    Line(37) = {82, 2};
    Line(38) = {84, 4};
    Line(39) = {85, 5};
    Line(40) = {83, 3};
    // Transfinite Lines below.

    // eigth pin, inner butterfly core
    Line(41) = {82, 84};
    Line(42) = {83, 85};
    // Transfinite Lines below.

    // quarter pin, inner butterfly core
    Line(43) = {84, 85};
    Line(44) = {82, 83};
    // Transfinite Lines below.


    /// Upper inner pin
    Point(92) = {-bf_length_upper, 0,         pin_height, gridsize};
    Point(93) = { bf_length_upper, 0,         pin_height, gridsize};
    Point(94) = {-bf_length_upper, bf_length_upper, pin_height, gridsize};
    Point(95) = { bf_length_upper, bf_length_upper, pin_height, gridsize};

    // radial outward going between butterfly core and pin interface
    Line(45) = {92, 12};
    Line(46) = {14, 94};
    Line(47) = {15, 95};
    Line(48) = {93, 13};
    Transfinite Line {37,38,39,40,45,-46,-47,48} = N_pin_solid_radial_outer Using Progression R_pin_solid_radial_outer;

    // eigth pin, inner butterfly core
    Line(49) = {92, 94};
    Line(51) = {95, 93};
    Transfinite Line {41,42,49,51} = N_pin_circ_eigth;

    // quarter pin, inner butterfly core
    Line(50) = {94, 95};
    Line(52) = {93, 92};
    Transfinite Line {43,44,50,52} = 2*N_pin_circ_eigth;

    // Lines connecting bottom pin to upper pin
    Line(53) = {84, 94};
    Line(54) = {82, 92};
    Line(55) = {85, 95};
    Line(56) = {83, 93};
    Transfinite Line {53,54,55,56} = N_pin_height Using Progression R_pin_height;

    // Solid pin symmetry doesnt need naming
    Curve Loop(7) = {37, 20, -45, -54}; Plane Surface(7) = {7};
    Curve Loop(8) = {44, 56, 52, -54};  Plane Surface(8) = {8};
    Curve Loop(9) = {40, 21, -48, -56}; Plane Surface(9) = {9};

    // solid pin top
    Curve Loop(10) = {11, 46, -49, 45}; Plane Surface(10) = {10};
    Curve Loop(11) = {12, 47, -50, -46}; Plane Surface(11) = {11};
    Curve Loop(12) = {13, -48, -51, -47}; Plane Surface(12) = {12};
    Curve Loop(13) = {52, 49, 50, 51};   Plane Surface(13) = {13};
    Physical Surface("solid_pin_top") = {10,11,12,13};

    // solid pin lower surfaces, inner surfaces, do not need naming
    Curve Loop(14) = {37, 1, -38, -41}; Plane Surface(14) = {14};
    Curve Loop(15) = {43, 39, -2, -38}; Plane Surface(15) = {15};
    Curve Loop(16) = {42, 39, 3, -40};  Plane Surface(16) = {16};
    Curve Loop(17) = {44, 42, -43, -41};Plane Surface(17) = {17};

    // pin inner surfaces, do not need naming
    Curve Loop(18) = {38, 22, 46, -53}; Plane Surface(18) = {18};
    Curve Loop(19) = {-47, -23, -39, 55}; Plane Surface(19) = {19};
    Curve Loop(20) = {41, 53, -49, -54}; Plane Surface(20) = {20};
    Curve Loop(21) = {50, -55, -43, 53}; Plane Surface(21) = {21};
    Curve Loop(22) = {55, 51, -56, 42};  Plane Surface(22) = {22};

    // Create solid pin volumes, 4 parts (3 circle parts, 1 inner rectangle)
    Surface Loop(1) = {7, 14, 1, 10, 20, 18};  Volume(1) = {1};
    Surface Loop(2) = {11, 2, 18, 19, 15, 21}; Volume(2) = {2};
    Surface Loop(3) = {19, 3, 9, 16, 12, 22};  Volume(3) = {3};
    Surface Loop(100) = {13, 8, 17, 21, 20, 22}; Volume(100) = {100};
    // To above line: Use high number so that new volumes from extrude will get same number between
    // solid only and full mesh.
    Physical Volume("solid_volume") = {1,2,3,100};

    // Make a useless line with a high line number in order to have the same line number for solid
    // and fluid+solid mesh. The hypothesis is, that the automatic numbering used during the Extrusion
    // is taking the highest given number and adds 1.
    Line(400) = {82, 83};

    // Extrude the pin butterfly mesh (including the full heater) down to heater surface
    Extrude {0, 0, -heater_depth} {
        Surface{4}; Surface{5}; Surface{6}; Surface{15}; Surface{14}; Surface{17}; Surface{16};
        // Layers {2}; // Lines kept for completeness, not necessary right now.
        // Recombine;
    }
    
    // Unfortunately one cannot extrude with keeping meshing information and can change meshing information
    // of single lines afterwards. So one has to extrude without that and mesh everyhting by hand again.
    // This is maybe not so bad here as therefore we can remove the Progressions for the heater bottom.
    // And only introduce a Progression into the depth direction.

    If (Do_not_use_progression_for_bottom_heat == 1)
        R_radial_heater= 1.0;
        R_pin_solid_radial_outer= 1.0;
    EndIf

    // Lines in depth direction. Progression to match fluid bottom mesh
    //Transfinite Curve {416, 407, 473, 495, 518, 452, 456, 412, 408, 474, 430, 434} = N_heater_depth Using Progression R_heater_depth;
    Transfinite Curve {416, 408, 407, 473, 495, 474, 518, 430, 451, 460, 434, 412} = N_heater_depth Using Progression R_heater_depth;

    // eigths pin parts
    Transfinite Curve {404, 402, 493, 513, 446, 448} = N_pin_circ_eigth;

    // quarter pin parts
    Transfinite Curve {426, 424, 468, 512} = 2*N_pin_circ_eigth;

    // radially outer heater surface
    Transfinite Curve {405, 403, 449, 425} = N_radial_heater Using Progression R_radial_heater;

    // radially inner pin
    Transfinite Curve {490, 471, 469, 537} = N_pin_solid_radial_outer Using Progression R_pin_solid_radial_outer;

    Coherence; // Remove all identical entities

    // create named surfaces and volumes, Mirrored part below
    Physical Surface("solid_heater_bottom", 872) = {422, 444, 466, 510, 554, 532, 488};
    Physical Surface("solid_heater_sides", 873) = {417, 439, 461};
    Physical Volume("solid_volume", 4) += {101, 102, 103, 104, 107, 105, 106};



    
EndIf

// ----------------------------------------------------------------------------------- //
// Mirror the mesh along the symmetry axes
//Removal of doubled points at stichted surfaces (in/outlet) http://gmsh.info/doc/texinfo/gmsh.html
Geometry.AutoCoherence = 0;
// https://stackoverflow.com/questions/49197879/duplicate-structured-surface-mesh-in-gmsh/50079210
Geometry.CopyMeshingMethod = 1; // keep meshing information while copying

If (Mirror_Mesh == 1)
    
    // Put all Volumes in an array http://onelab.info/pipermail/gmsh/2017/011186.html
    volumes[] = Volume "*";

    Symmetry {0, 1, 0, 0} {
        Duplicata { Volume{ volumes[] }; }
    }

    Coherence; // Remove all identical entities

    // For some reason the copied entities do not carry their physical tags with them.
    // Therefore we have to do it manually for the mirrored parts here
    If (Which_Mesh_Part==1)
        Physical Surface("fluid_freestream", 5) += {285, 306, 342};
        Physical Surface("fluid_bottom", 7) += {280, 311, 347};
        Physical Surface("fluid_heater_interface", 2) += {187, 254, 223};
        Physical Surface("fluid_top", 3) += {290, 316, 337, 233, 244, 197};
        Physical Surface("fluid_pin_interface", 1) += {192, 259, 218};
        Physical Volume("fluid_volume", 4) += {274, 181, 243, 305, 212, 336};

    ElseIf (Which_Mesh_Part==2)
        Physical Surface("solid_heater_bottom", 872) += {1004, 1035, 1066, 1097, 1128, 1190, 1159};
        Physical Surface("solid_heater_sides", 873) += {1019, 1050, 1081};
        Physical Surface("solid_heater_interface", 2) += {1030, 1061, 999};
        Physical Surface("solid_pin_interface", 1) += {911, 942, 885};
        Physical Surface("solid_pin_top", 3) += {890, 906, 968, 957};
        Physical Volume("solid_volume", 4) += {1122, 998, 1029, 874, 1153, 1091, 967, 905, 1184, 936, 1060};

    EndIf

EndIf

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
    If (Which_Mesh_Part == 1)
        Save "fluid.su2";
    ElseIf (Which_Mesh_Part == 2)
        Save "solid.su2";
    Else
        Printf("Invalid Which_Mesh_Part variable.");
        Abort;
    EndIf

EndIf
