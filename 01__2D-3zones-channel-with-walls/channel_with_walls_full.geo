//Kattmann, 04.05.2018, Channel with blocks on top and bottom
// ----------------------------------------------------------------------------------- //

// Which domain part should be handled
Which_Mesh_Part= 3;// 0=all, 1=Fluid, 2=top-solid, 3=bottom-solid
// Evoque Meshing Algorithm?
Do_Meshing= 1; // 0=false, 1=true
// Write Mesh files in .su2 format
Write_mesh= 1; // 0=false, 1=true

//Geometric inputs
channel_height = 1e-3;
channel_length = 5e-3;
block_height = 0.2e-3;

//fixed, do not change
top_dist = channel_length/2;
bottom_dist = channel_length/2;

Printf("===================================");
Printf("Free parameters:");
Printf("-> channel height: %g", channel_height);
Printf("-> channel length: %g", channel_length);
Printf("-> block height: %g", block_height);
Printf("===================================");

//Mesh inputs
gridsize = 0.0001;
Nx = 51; //must be odd!
Ny_channel = 51; //should be odd
Ry_channel = 0.1; //Bump

Ny_block = 11; //should be odd as well
Ry_block = 1.3; //Progression

//Each zone is completely self-sufficient (i.e. points, lines, etc.)!
// ----------------------------------------------------------------------------------- //
//Fluid zone, channel
If (Which_Mesh_Part == 0 || Which_Mesh_Part == 1)

    Point(1) = {0, 0, 0, gridsize};
    Point(2) = {0, channel_height, 0, gridsize};
    Point(3) = {channel_length, channel_height, 0, gridsize};
    Point(4) = {channel_length,0 , 0, gridsize};

    Line(1) = {1,2};
    Line(2) = {2,3};
    Line(3) = {3,4};
    Line(4) = {4,1};

    Line Loop(1) = {1,2,3,4};
    Plane Surface(1) = {1};

    //make structured channel
    Transfinite Line{1,-3} = Ny_channel Using Bump Ry_channel;
    Transfinite Line{2,4} = Nx;
    Transfinite Surface{1};
    Recombine Surface{1};

    //Physical Groups
    Physical Line("inlet") = {1};
    Physical Line("outlet") = {3};
    Physical Line("fluid_top") = {2};
    Physical Line("fluid_bottom") = {4};
    Physical Surface("fluid_body") = {1};

EndIf

// ----------------------------------------------------------------------------------- //
//Top block, solid zone
If (Which_Mesh_Part == 0 || Which_Mesh_Part == 2)

    Point(11) = {0, channel_height, 0, gridsize};
    Point(12) = {0, channel_height+block_height, 0, gridsize};
    Point(13) = {channel_length, channel_height+block_height, 0, gridsize};
    Point(14) = {channel_length,channel_height , 0, gridsize};
    Point(15) = {top_dist, channel_height+block_height, 0, gridsize};
    Point(16) = {top_dist, channel_height, 0, gridsize};

    Line(11) = {11,12};
    Line(12) = {12,15};
    Line(13) = {15,13};
    Line(14) = {13,14};
    Line(15) = {14,16};
    Line(16) = {16,11};
    Line(17) = {15,16};

    Line Loop(11) = {11,12,17,16};
    Line Loop(12) = {-17,13,14,15};
    Plane Surface(11) = {11};
    Plane Surface(12) = {12};

    //make structured blocks
    //left
    Transfinite Line{11,-17,-14} = Ny_block Using Progression Ry_block;
    Transfinite Line{12,16} = Nx/2+1;
    Transfinite Surface{11};
    Recombine Surface{11};
    //right
    Transfinite Line{-14,-17} = Ny_block Using Progression Ry_block;
    Transfinite Line{13,15} = Nx/2+1;
    Transfinite Surface{12};
    Recombine Surface{12};

    //Physical Groups
    Physical Line("top_block_walls") = {11,14};
    Physical Line("top_block_fluid_interface") = {16,15};
    Physical Line("top_block_topleft") = {12};
    Physical Line("top_block_topright") = {13};
    Physical Surface("solid_top") = {11,12};

EndIf

// ----------------------------------------------------------------------------------- //
//Bottom  block, solid zone
If (Which_Mesh_Part == 0 || Which_Mesh_Part == 3)

    Point(21) = {0, 0, 0, gridsize};
    Point(22) = {channel_length, 0, 0, gridsize};
    Point(23) = {channel_length, -block_height, 0, gridsize};
    Point(24) = {0, -block_height, 0, gridsize};
    Point(25) = {bottom_dist, 0, 0, gridsize};
    Point(26) = {bottom_dist, -block_height, 0, gridsize};

    Line(21) = {21,25};
    Line(22) = {25,22};
    Line(23) = {22,23};
    Line(24) = {23,26};
    Line(25) = {26,24};
    Line(26) = {24,21};
    Line(27) = {25,26};

    Line Loop(21) = {21,27,25,26};
    Line Loop(22) = {22,23,24,-27};
    Plane Surface(21) = {21};
    Plane Surface(22) = {22};

    //make structured blocks
    //left
    Transfinite Line{-26,27} = Ny_block Using Progression Ry_block;
    Transfinite Line{21,25} = Nx/2+1;
    Transfinite Surface{21};
    Recombine Surface{21};
    //right
    Transfinite Line{27,23} = Ny_block Using Progression Ry_block;
    Transfinite Line{22,24} = Nx/2+1;
    Transfinite Surface{22};
    Recombine Surface{22};

    //Physical Groups
    Physical Line("bottom_block_walls") = {26,23};
    Physical Line("bottom_block_fluid_interface") = {21,22};
    Physical Line("bottom_block_bottomleft") = {25};
    Physical Line("bottom_block_bottomright") = {24};
    Physical Surface("solid_bottom") = {21,22};

EndIf

// ----------------------------------------------------------------------------------- //
// Meshing
If (Do_Meshing == 1)
    Mesh 1; Mesh 2;
EndIf

// ----------------------------------------------------------------------------------- //
// Write .su2 meshfile
If (Write_mesh == 1)

    Mesh.Format = 42; // .su2 mesh format, 
    If (Which_Mesh_Part == 1)
        Save "fluid.su2";
    ElseIf (Which_Mesh_Part == 2)
        Save "solid-top.su2";
    ElseIf (Which_Mesh_Part == 3)
        Save "solid-bottom.su2";
    Else
        Printf("Unvalid Which_Mesh_Part variable.");
        Abort;
    EndIf

EndIf
