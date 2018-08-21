//Kattmann, 13.05.2018, Channel with 1 Pin
//-------------------------------------------------------------------------------------//
//Geometric inputs, ch: channel, Pin center is origin
//ch_height > pin_outer_r + ch_box
ch_height = 2e-3;
//ch_front & ch_back > pin_outer_r + ch_box
ch_front = 3e-3; // front length
ch_back = 5e-3; // back length
ch_box = 0.5e-3; // for extension of pin mesh

pin_outer_r = 1e-3;
pin_inner_r = 0.25e-3;

//Mesh inputs
gridsize = 0.1; // unimportant one everything is structured

//ch_box 
Nch_box = 30;
Rch_box = 1.1;

Nch_front = 30;
Nch_back = 60;

//upper wall
Nupper_wall = 20;
Rupper_wall = 1.1;

//Pin in radial direction
Npin_radial = 80; // for all pin segments
Rpin_radial = 1.;
//Pin in circumferential direction
Npin1_circ = 40; 
Npin2_circ = 2*Npin1_circ;
Npin3_circ = Npin1_circ;

//-------------------------------------------------------------------------------------//
//Fluid zone
//Points
Point(1) = {0, 0, 0, gridsize};
Point(2) = {-pin_outer_r, 0, 0, gridsize};
Point(3) = {-pin_outer_r*Cos(45*Pi/180), pin_outer_r*Sin(45*Pi/180), 0, gridsize};
Point(4) = {pin_outer_r*Cos(45*Pi/180), pin_outer_r*Sin(45*Pi/180), 0, gridsize};
Point(5) = {pin_outer_r, 0, 0, gridsize};

Point(6) = {-(pin_outer_r+ch_box), 0, 0, gridsize};
Point(7) = {-(pin_outer_r+ch_box), pin_outer_r+ch_box, 0, gridsize};
Point(8) = {pin_outer_r+ch_box, pin_outer_r+ch_box, 0, gridsize};
Point(9) = {pin_outer_r+ch_box, 0, 0, gridsize};

Point(10) = {-ch_front, 0, 0, gridsize};
Point(11) = {-ch_front, pin_outer_r+ch_box, 0, gridsize};
Point(12) = {-ch_front, ch_height, 0, gridsize};
Point(13) = {-(pin_outer_r+ch_box), ch_height, 0, gridsize};
Point(14) = {(pin_outer_r+ch_box), ch_height, 0, gridsize};
Point(15) = {ch_back, ch_height, 0, gridsize};
Point(16) = {ch_back, pin_outer_r+ch_box, 0, gridsize};
Point(17) = {ch_back, 0, 0, gridsize};

//Lines
Circle(1) = {2, 1, 3};
Circle(2) = {3, 1, 4};
Circle(3) = {4, 1, 5};

Line(4) = {6,2};
Line(5) = {10,6};
Line(6) = {10,11};
Line(7) = {11,12};
Line(8) = {12,13};
Line(9) = {11,7};
Line(10) = {7,13};
Line(11) = {6,7};
Line(12) = {7,3};
Line(13) = {13,14};
Line(14) = {7,8};
Line(15) = {4,8};
Line(16) = {5,9};
Line(17) = {9,8};
Line(18) = {8,14};
Line(19) = {14,15};
Line(20) = {8,16};
Line(21) = {9,17};
Line(22) = {17,16};
Line(23) = {16,15};

//Lineloops and surfaces
Line Loop(1) = {-4, 11, 12, -1};
Plane Surface(1) = {1};

Line Loop(2) = {-2, -12, 14, -15};
Plane Surface(2) = {2};

Line Loop(3) = {-16, -3, 15, -17};
Plane Surface(3) = {3};

Line Loop(4) = {-5, 6, 9, -11};
Plane Surface(4) = {4};

Line Loop(5) = {-9, 7, 8, -10};
Plane Surface(5) = {5};

Line Loop(6) = {-14, 10, 13, -18};
Plane Surface(6) = {6};

Line Loop(7) = {-20, 18, 19, -23};
Plane Surface(7) = {7};

Line Loop(8) = {-21, 17, 20, -22};
Plane Surface(8) = {8};

//make structured mesh with transfinite lines
//ch_box
Transfinite Line{1, 11, 6} = Npin1_circ;
Transfinite Line{2, 14, 13} = Npin2_circ;
Transfinite Line{3, -17, -22} = Npin3_circ;
Transfinite Line{-4, -12, 15, 16} = Nch_box Using Progression Rch_box;
//
Transfinite Line{-7, -10, -18, -23} = Nupper_wall Using Progression Rupper_wall;
Transfinite Line{5, 9, 8} = Nch_front;
Transfinite Line{21, 20, 19} = Nch_back;

Transfinite Surface{1,2,3,4,5,6,7,8};
Recombine Surface{1,2,3,4,5,6,7,8};

//Physical Groups
Physical Line("inlet") = {6, 7};
Physical Line("outlet") = {22, 23};
Physical Line("fluid_top") = {8, 13, 19};
Physical Line("fluid_pin_interface") = {1, 2, 3};
Physical Line("fluid_sym") = {5, 4, 16, 21};
Physical Surface("fluid_body") = {1,2,3,4,5,6,7,8};
//-------------------------------------------------------------------------------------//
//Pin zone
//Points
Point(31) = {0, 0, 0, gridsize};

Point(32) = {-pin_inner_r, 0, 0, gridsize};
Point(33) = {-pin_outer_r, 0, 0, gridsize};
Point(34) = {-pin_outer_r*Cos(45*Pi/180), pin_outer_r*Sin(45*Pi/180), 0, gridsize};
Point(35) = {-pin_inner_r*Cos(45*Pi/180), pin_inner_r*Sin(45*Pi/180), 0, gridsize};

Point(36) = {pin_outer_r*Cos(45*Pi/180), pin_outer_r*Sin(45*Pi/180), 0, gridsize};
Point(37) = {pin_inner_r*Cos(45*Pi/180), pin_inner_r*Sin(45*Pi/180), 0, gridsize};

Point(38) = {pin_outer_r, 0, 0, gridsize};
Point(39) = {pin_inner_r, 0, 0, gridsize};

//Lines
Line(31) = {32, 33};
Circle(32) = {33, 31, 34};
Line(33) = {34, 35};
Circle(34) = {35, 31, 32};

Circle(35) = {34, 31, 36};
Line(36) = {36, 37};
Circle(37) = {37, 31, 35};

Circle(38) = {36, 31, 38};
Line(39) = {38, 39};
Circle(40) = {39, 31, 37};

//Lineloops and surfaces
//segment 1
Line Loop(31) = {31, 32, 33, 34};
Plane Surface(31) = {31};
//segment 2
Line Loop(32) = {37, -33, 35, 36};
Plane Surface(32) = {32};
//segment 3
Line Loop(33) = {39, 40, -36, 38};
Plane Surface(33) = {33};

//make structured mesh with transfinite lines
//segment 1
Transfinite Line{-31, 33} = Npin_radial Using Progression Rpin_radial;
Transfinite Line{32, -34} = Npin1_circ;
Transfinite Surface{31};
Recombine Surface{31};

//segment 2
Transfinite Line{33, 36} = Npin_radial Using Progression Rpin_radial;
Transfinite Line{35, -37} = Npin2_circ;
Transfinite Surface{32};
Recombine Surface{32};

//segement 3
Transfinite Line{36, 39} = Npin_radial Using Progression Rpin_radial;
Transfinite Line{38, -40} = Npin3_circ;
Transfinite Surface{33};
Recombine Surface{33};

//Physical Groups
Physical Line("pin_fluid_interface") = {32, 35, 38};
Physical Line("pin_sym") = {31, 39};
Physical Line("pin_inner") = {34, 36, 40};
Physical Surface("pin_body") = {31, 32, 33};
