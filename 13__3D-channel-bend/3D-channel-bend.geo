//Kattmann, 25.10.2019, 3D rectangular channel with variable bend
// ----------------------------------------------------------------------------------- //

// Evoque Meshing Algorithm?
Do_Meshing= 1; // 0=false, 1=true
// Write Mesh files in .su2 format
Write_mesh= 1; // 0=false, 1=true

// ----------------------------------------------------------------------------------- //
// Geometric inputs
height= 0.00040489;
width= 0.00055427;
inlet_length= width*4;
outlet_length= width*10;
bend_angle= 45; // in degree
midpoint_radius= width*2;

// Check geometric inputs for invalid options
If (bend_angle <= 0 || bend_angle >= 180 ||
    height <= 0 || width <= 0 || inlet_length <= 0 || outlet_length <= 0 ||
    midpoint_radius <= width/2)

    Printf("Aborting! Invalid input values. Choose appropriate geometric values.");
    Abort;

EndIf

deg2rad= Pi/180; // conversion factor as gmsh Cos/Sin functions take radian values, but degrees are input.
bend_angle= bend_angle*deg2rad;

// ----------------------------------------------------------------------------------- //
// Mesh inputs
Nh= 30; // points in height/z-direction
Rh= 0.1; // non-uniformity of the mesh spacing (smaller -> more non-uniformity, 1 -> uniform spacing)

Nw= Nh; // points in width/y-direction
Rw= 0.1; // non-uniformity of the mesh spacing (smaller -> more non-uniformity, 1 -> uniform spacing)

Nx_in= 80; // points in flow direction in inlet channel
Nx_out= 200; // points in flow direction in outlet channel
Nx_bend= 40; // points in flow direction in bend channel

gridsize = 0.1; // only formally necessary, this does NOT control gridsize

// Check mesh inputs for invalid options
If (Nh<2 || Nw<2 || Nx_in<2 || Nx_out<2 || Nx_bend<2 ||
    Rh<=0 || Rw<=0)

    Printf("Aborting! Invalid input values. Choose appropriate meshing values.");
    Abort;

EndIf

// ----------------------------------------------------------------------------------- //
// Points
If (0==0)
  Point(1) = {0, 0, 0, gridsize}; // circle midpoint
  Point(2) = {0, 0, height, gridsize}; // circle midpoint

  // bend points, low height
  Point(3) = {0, midpoint_radius-width/2, 0, gridsize};
  Point(4) = {0, midpoint_radius+width/2, 0, gridsize};
  Point(5) = {(midpoint_radius-width/2) * Sin(bend_angle), (midpoint_radius-width/2) * Cos(bend_angle), 0, gridsize};
  Point(6) = {(midpoint_radius+width/2) * Sin(bend_angle), (midpoint_radius+width/2) * Cos(bend_angle), 0, gridsize};
  // bend points, high height
  Point(7) = {0, midpoint_radius-width/2, height, gridsize};
  Point(8) = {0, midpoint_radius+width/2, height, gridsize};
  Point(9) = {(midpoint_radius-width/2) * Sin(bend_angle), (midpoint_radius-width/2) * Cos(bend_angle), height, gridsize};
  Point(10)= {(midpoint_radius+width/2) * Sin(bend_angle), (midpoint_radius+width/2) * Cos(bend_angle), height, gridsize};

  // inlet points (convention inner radius->outer radius and first low height-> high hight)
  Point(11) = {-inlet_length, midpoint_radius-width/2, 0, gridsize};
  Point(12) = {-inlet_length, midpoint_radius+width/2, 0, gridsize};
  Point(13) = {-inlet_length, midpoint_radius-width/2, height, gridsize};
  Point(14) = {-inlet_length, midpoint_radius+width/2, height, gridsize};

  // outlet points
  Point(15) = {(midpoint_radius-width/2)*Sin(bend_angle) + outlet_length*Cos(bend_angle), (midpoint_radius-width/2)*Cos(bend_angle) - outlet_length*Sin(bend_angle), 0, gridsize};
  Point(16) = {(midpoint_radius+width/2)*Sin(bend_angle) + outlet_length*Cos(bend_angle), (midpoint_radius+width/2)*Cos(bend_angle) - outlet_length*Sin(bend_angle), 0, gridsize};
  Point(17) = {(midpoint_radius-width/2)*Sin(bend_angle) + outlet_length*Cos(bend_angle), (midpoint_radius-width/2)*Cos(bend_angle) - outlet_length*Sin(bend_angle), height, gridsize};
  Point(18) = {(midpoint_radius+width/2)*Sin(bend_angle) + outlet_length*Cos(bend_angle), (midpoint_radius+width/2)*Cos(bend_angle) - outlet_length*Sin(bend_angle), height, gridsize};
EndIf

// ----------------------------------------------------------------------------------- //
// Lines
If (0==0)
  // circular arcs
  Circle(1) = {3, 1, 5};
  Circle(2) = {4, 1, 6};
  Circle(3) = {7, 2, 9};
  Circle(4) = {8, 2, 10};

  // inlet lines
  Line(5) = {12, 11};
  Line(6) = {11, 13};
  Line(7) = {13, 14};
  Line(8) = {14, 12};

  // inlet channel
  Line(9) = {14, 8};
  Line(10) = {12, 4};
  Line(11) = {13, 7};
  Line(12) = {11, 3};

  // inlet to bend surface
  Line(13) = {8, 7};
  Line(14) = {7, 3};
  Line(15) = {3, 4};
  Line(16) = {4, 8};

  // bend to oulet surface
  Line(17) = {10, 6};
  Line(18) = {6, 5};
  Line(19) = {5, 9};
  Line(20) = {9, 10};

  // outlet channel
  Line(21) = {9, 17};
  Line(22) = {5, 15};
  Line(23) = {6, 16};
  Line(24) = {10, 18};

  //outlet surface
  Line(25) = {17, 15};
  Line(26) = {15, 16};
  Line(27) = {16, 18};
  Line(28) = {18, 17};
EndIf

// ----------------------------------------------------------------------------------- //
// Surfaces
If(0==0)
  // inlet
  Curve Loop(1) = {5, 6, 7, 8}; Plane Surface(1) = {1};

  // inlet channel walls
  Curve Loop(2) = {6, 11, 14, -12};  Plane Surface(2) = {2};
  Curve Loop(3) = {7, 9, 13, -11};   Plane Surface(3) = {3};
  Curve Loop(4) = {9, -16, -10, -8}; Plane Surface(4) = {4};
  Curve Loop(5) = {5, 12, 15, -10};  Plane Surface(5) = {5};

  // inlet to bend
  Curve Loop(6) = {16, 13, 14, 15}; Plane Surface(6) = {6};

  // bend walls
  Curve Loop(7) = {13, 3, 20, -4};  Surface(7) = {7};
  Curve Loop(8) = {4, 17, -2, 16};  Surface(8) = {8};
  Curve Loop(9) = {2, 18, -1, 15};  Surface(9) = {9};
  Curve Loop(10) = {14, 1, 19, -3}; Surface(10) = {10};

  // bend to outlet
  Curve Loop(11) = {19, 20, 17, 18}; Plane Surface(11) = {11};

  // outlet channel walls
  Curve Loop(12) = {21, -28, -24, -20}; Plane Surface(12) = {12};
  Curve Loop(13) = {17, 23, 27, -24};   Plane Surface(13) = {13};
  Curve Loop(14) = {18, 22, 26, -23};   Plane Surface(14) = {14};
  Curve Loop(15) = {19, 21, 25, -22};   Plane Surface(15) = {15};

  // outlet
  Curve Loop(16) = {25, 26, 27, 28}; Plane Surface(16) = {16};
EndIf

// ----------------------------------------------------------------------------------- //
// Volumes
If (0==0)
  Surface Loop(1) = {4, 3, 1, 5, 2, 6};       Volume(1) = {1}; // inlet channel
  Surface Loop(2) = {7, 10, 9, 8, 11, 6};     Volume(2) = {2}; // bend
  Surface Loop(3) = {12, 15, 16, 14, 13, 11}; Volume(3) = {3}; // outlet channel
EndIf

// ----------------------------------------------------------------------------------- //
// Physical groups
If (0==0)
  Physical Surface("walls")  = {3, 2, 7, 10, 12, 15, 5, 9, 14, 4, 8, 13};
  Physical Surface("inlet")  = {3, 1};
  Physical Surface("outlet") = {16};
  Physical Volume("fluid")   = {1, 2, 3};
EndIf

// ----------------------------------------------------------------------------------- //
// Structured Mesh
If (0==0)
  Transfinite Curve {5, 7, 15, 13, 20, 18, 28, 26} = Nw Using Bump Rw;
  Transfinite Curve {8, 6, 16, 14, 17, 19, 25, 27} = Nh Using Bump Rh;
  Transfinite Curve {9, 10, 12, 11} = Nx_in;
  Transfinite Curve {3, 4, 2, 1} = Nx_bend;
  Transfinite Curve {21, 24, 23, 22} = Nx_out;
EndIf

// ----------------------------------------------------------------------------------- //
// Meshing
If (Do_Meshing == 1)

  Coherence;
  Transfinite Surface "*";
  Recombine Surface "*";
  Transfinite Volume "*";

  Mesh 1; Mesh 2; Mesh 3;

EndIf

// ----------------------------------------------------------------------------------- //
// Write .su2 meshfile
If (Write_mesh == 1)

  Mesh.Format = 42; // .su2 mesh format
  Save "fluid.su2";

EndIf
