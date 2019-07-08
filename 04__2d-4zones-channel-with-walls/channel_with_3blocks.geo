// ----------------------------------------------------------------------------------- //
// Kattmann, 04.05.2018, Channel with blocks on top and bottom
// ----------------------------------------------------------------------------------- //

// Which domain part should be handled
Which_Mesh_Part= 0; // 0=all, 1=Fluid, 2=Solid1, 3=Solid2, 4=Solid3
// Evoque Meshing Algorithm?
Do_Meshing= 1; // 0=false, 1=true
// Write Mesh files in .su2 format
Write_mesh= 0; // 0=false, 1=true

//Geometric inputs
block_height = 0.2e-3;
block_length = 0.5e-3;
channel_height = 0.2e-3;
channel_length = block_length*3 + (block_length/2)*2;

//Mesh inputs
gridsize = 0.0001;

Nx_block = 11; // must be odd
Ny_block = 9;
Ry_block = 1.3;

Nx_channel = 3*Nx_block + 2*((Nx_block-1)/2-1);
Ny_channel = 9;
Ry_channel = 0.7;

// Each zone is completely self-sufficient (i.e. points, lines, etc.)
// ----------------------------------------------------------------------------------- //
// Fluid zone, channel
If (Which_Mesh_Part == 0 || Which_Mesh_Part == 1)

    Point(51) = {0, 0, 0, gridsize};
    Point(52) = {0, channel_height, 0, gridsize};
    Point(53) = {channel_length, channel_height, 0, gridsize};
    Point(54) = {channel_length,0 , 0, gridsize};
    Point(55) = {block_length, channel_height, 0, gridsize};
    Point(56) = {block_length*3/2, channel_height, 0, gridsize};
    Point(57) = {block_length*5/2, channel_height, 0, gridsize};
    Point(58) = {block_length*3, channel_height, 0, gridsize};
    Point(59) = {block_length, 0, 0, gridsize};
    Point(60) = {block_length*3/2, 0, 0, gridsize};
    Point(61) = {block_length*5/2, 0, 0, gridsize};
    Point(62) = {block_length*3, 0, 0, gridsize};

    //inlet and outlet
    Line(51) = {51,52};
    Line(53) = {53,54};
    //fluid top
    Line(55) = {52,55};
    Line(56) = {55,56};
    Line(57) = {56,57};
    Line(58) = {57,58};
    Line(59) = {58,53};
    //fluid borrom
    Line(60) = {54,62};
    Line(61) = {62,61};
    Line(62) = {61,60};
    Line(63) = {60,59};
    Line(64) = {59,51};
    //in the domain
    Line(65) = {59,55};
    Line(66) = {60,56};
    Line(67) = {61,57};
    Line(68) = {62,58};

    Line Loop(51) = {51,55,-65,64}; Plane Surface(51) = {51};
    Line Loop(52) = {65,56,-66,63}; Plane Surface(52) = {52};
    Line Loop(53) = {66,57,-67,62}; Plane Surface(53) = {53};
    Line Loop(54) = {67,58,-68,61}; Plane Surface(54) = {54};
    Line Loop(55) = {68,59,53,60};  Plane Surface(55) = {55};

    //make structured channel
    Transfinite Line{51,65,-53,65,66,67,68,-53} = Ny_channel Using Progression Ry_channel;
    Transfinite Line{55,-64,57,59,-62,-60} = Nx_block;
    Transfinite Line{56,58,-63,-61} = (Nx_block+1)/2;

    //Physical Groups
    Physical Line("inlet") = {51};
    Physical Line("outlet") = {53};
    Physical Line("fluid_bottom") = {64,63,62,61,60};
    Physical Line("fluid_top_walls") = {56,58};
    Physical Line("fluid_top_block1") = {55};
    Physical Line("fluid_top_block2") = {57};
    Physical Line("fluid_top_block3") = {59};
    Physical Surface("fluid_body") = {51,52,53,54,55};

EndIf

// ----------------------------------------------------------------------------------- //
// Top block 1, solid zone
If (Which_Mesh_Part == 0 || Which_Mesh_Part == 2)

    Point(11) = {0, channel_height, 0, gridsize};
    Point(12) = {0, channel_height+block_height, 0, gridsize};
    Point(13) = {block_length, channel_height+block_height, 0, gridsize};
    Point(14) = {block_length, channel_height, 0, gridsize};

    Line(11) = {11,12};
    Line(12) = {12,13};
    Line(13) = {13,14};
    Line(14) = {14,11};

    Line Loop(11) = {11,12,13,14}; Plane Surface(11) = {11};

    //make structured block
    Transfinite Line{11,-13} = Ny_block Using Progression Ry_block;
    Transfinite Line{12,14} = Nx_block;

    //Physical Groups
    Physical Line("block_1_walls") = {11,13};
    Physical Line("block_1_top") = {12};
    Physical Line("block_1_interface") = {14};
    Physical Surface("block_1_body") = {11};

EndIf

// ----------------------------------------------------------------------------------- //
// Top block 2, solid zone
If (Which_Mesh_Part == 0 || Which_Mesh_Part == 3)

    Point(21) = {block_length*3/2, channel_height, 0, gridsize};
    Point(22) = {block_length*3/2, channel_height+block_height, 0, gridsize};
    Point(23) = {block_length*3/2 + block_length, channel_height+block_height, 0, gridsize};
    Point(24) = {block_length*3/2 + block_length, channel_height, 0, gridsize};

    Line(21) = {21,22};
    Line(22) = {22,23};
    Line(23) = {23,24};
    Line(24) = {24,21};

    Line Loop(21) = {21,22,23,24}; Plane Surface(21) = {21};

    //make structured block
    Transfinite Line{21,-23} = Ny_block Using Progression Ry_block;
    Transfinite Line{22,24} = Nx_block;

    //Physical Groups
    Physical Line("block_2_walls") = {21,23};
    Physical Line("block_2_top") = {22};
    Physical Line("block_2_interface") = {24};
    Physical Surface("block_2_body") = {21};

EndIf

// ----------------------------------------------------------------------------------- //
// Top block 3, solid zone
If (Which_Mesh_Part == 0 || Which_Mesh_Part == 4)

    Point(31) = {block_length*3, channel_height, 0, gridsize};
    Point(32) = {block_length*3, channel_height+block_height, 0, gridsize};
    Point(33) = {block_length*3 + block_length, channel_height+block_height, 0, gridsize};
    Point(34) = {block_length*3 + block_length, channel_height, 0, gridsize};

    Line(31) = {31,32};
    Line(32) = {32,33};
    Line(33) = {33,34};
    Line(34) = {34,31};

    Line Loop(31) = {31,32,33,34}; Plane Surface(31) = {31};

    //make structured block
    Transfinite Line{31,-33} = Ny_block Using Progression Ry_block;
    Transfinite Line{32,34} = Nx_block;

    //Physical Groups
    Physical Line("block_3_walls") = {31,33};
    Physical Line("block_3_top") = {32};
    Physical Line("block_3_interface") = {34};
    Physical Surface("block_3_body") = {31};

EndIf

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

    Mesh.Format = 42; // .su2 mesh format
    If (Which_Mesh_Part == 1)
        Save "fluid.su2";
    ElseIf (Which_Mesh_Part == 2)
        Save "solid1.su2";
    ElseIf (Which_Mesh_Part == 3)
        Save "solid2.su2";
    ElseIf (Which_Mesh_Part == 4)
        Save "solid3.su2";
    Else
        Printf("Unvalid Which_Mesh_Part variable.");
        Abort;
    EndIf

EndIf
// Note that gmsh wants line after the last statement. This comment is also enough.