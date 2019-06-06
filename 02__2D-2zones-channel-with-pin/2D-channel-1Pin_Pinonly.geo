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
