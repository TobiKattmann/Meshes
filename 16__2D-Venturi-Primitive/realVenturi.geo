// ----------------------------------------------------------------------------------- //
// Tobias Kattmann, 22.10.2021, 2D Venturi with fully structured mesh
// ----------------------------------------------------------------------------------- //

// Evoque Meshing Algorithm?
Do_Meshing= 1; // 0=false, 1=true
// Write Mesh files in .su2 format
Write_mesh= 0; // 0=false, 1=true

// Geometric inputs
gas_inlet_radius= 0.1; // radius of the gas inlet (the actual boundary marker)
gas_inlet_length= 1.0; // length of the gas tube until the venturi mixer
gas_nozzle_radius= 0.05; // radius of the gas nozzle at the end of the gas port

diffusor_length= 4.0; // length of the domain after the gas-air-seperator tip
outlet_radius= 1.0; // full outlet radius.

gas_air_separator_height= 0.05; // height of the seperating piece between the gas and air inlet

air_inlet_setback= 0.5; // setback of the front air_inlet point compared to gas-air-seperator tip
air_inlet_width= 0.3; // width of the air inlet
air_inlet_height= 0.5; // absolute height is "gas_nozzle_radius+gas_air_separator_height+air_inlet_height", height of the air inlet
air_inlet_height_chokepoint= 0.3; // absolute height is "gas_nozzle_radius+gas_air_separator_height+air_inlet_height_chokepoint", point of the venturi chokepoint
// air_inlet_height_chokepoint < air_inlet_height required

// ----------------------------------------------------------------------------------- //
// side computation: outlet height frations
// The outlet_radius has to be shared by 3 structured mesh parts. Therefore we compute 
// their respective share of the outlet_radius by their "inlet" bits.
complete_inlet= gas_nozzle_radius + gas_air_separator_height + air_inlet_height_chokepoint; // complete "inlet" height
lower_height= outlet_radius * (gas_nozzle_radius/complete_inlet); // height bit for the lower portion of the diffusor
middle_height= outlet_radius * (gas_air_separator_height/complete_inlet); // height bit for the middle portion of the diffusor
// upper height unnecessary because that would be "=outlet_radius-lower_height-middle_height"


// Mesh sizing inputs
gridsize= 0.1; // Later on not important as structured mesh is achieved

N_air_downstream= 50;
R_air_downstream= 1.1; // Progression towards mixing area in the diffusor
N_air_width= 50;
R_air_width= 0.1; // Bump towards walls

N_gas_downstream= 50;
R_gas_downstream= 1.1; // Progression towards mixing area in the diffusor
N_gas_width= 50;
R_gas_width= 0.1; // Bump towards walls

N_middle_width= 50;
R_middle_width= 4*R_air_width;// Bump towards corner points (maybe one can have no bump on the outlet?!)

N_diffusor_downstream= 50; // Nodes in downstream direction of the diffusor
R_diffusor_downstream= 1.1; // Progression towards mixing area in the diffusor

// ----------------------------------------------------------------------------------- //
/// gas inlet
Point(1) = {0, 0, 0, gridsize}; // lower inlet
Point(2) = {0, gas_inlet_radius, 0, gridsize}; // upper inlet
Point(3) = {gas_inlet_length, 0, 0, gridsize}; // lower "outlet"
Point(4) = {gas_inlet_length, gas_nozzle_radius, 0, gridsize}; // upper "outlet" (lower gas-air-seperator tip)
// helper points for bezier curve
Point(5) = {gas_inlet_length/2, gas_inlet_radius, 0, gridsize}; // helper point for the inlet
Point(6) = {gas_inlet_length/2, gas_nozzle_radius, 0, gridsize};  // helper point for the mixing point

// Bezier curve of the upper gas port, the syntax is:
// (start point, refpoint for start, refpoint for end, end point)
Bezier(1) = {2,5,6,4}; Physical Line("wall") = {1}; // upper gas port wall
Line(2) = {1,2}; Physical Line("gas_inlet") = {2}; // gas inlet
Line(3) = {3,4}; // gas tube "outlet"
Line(4) = {1,3}; Physical Line("symmetry") = {4}; // symmetry

// ----------------------------------------------------------------------------------- //
/// air inlet
Point(11) = {gas_inlet_length, gas_nozzle_radius + gas_air_separator_height, 0, gridsize}; // lower "outlet" (upper gas-air-seperator tip)
Point(12) = {gas_inlet_length, gas_nozzle_radius+gas_air_separator_height+air_inlet_height_chokepoint, 0, gridsize}; // upper air port "outlet"
Point(13) = {gas_inlet_length - air_inlet_setback - air_inlet_width, gas_nozzle_radius+gas_air_separator_height+air_inlet_height, 0, gridsize}; // left air inlet point
Point(14) = {gas_inlet_length - air_inlet_setback                  , gas_nozzle_radius+gas_air_separator_height+air_inlet_height, 0, gridsize}; // right air inlet point
// helper points for venturi bezier curve
Point(15) = {gas_inlet_length*3/4, gas_nozzle_radius+gas_air_separator_height+air_inlet_height_chokepoint, 0, gridsize}; // upper air port "outlet" helper (!Needs to mirrored around the point for the outlet portion in order to create smooth transition of the bezier curve!)
Point(16) = {gas_inlet_length*3/4, gas_nozzle_radius+gas_air_separator_height+air_inlet_height_chokepoint, 0, gridsize}; // right air inlet helper point
// helper point for lower air inlet bezier curve
Point(17) = {gas_inlet_length - air_inlet_setback - air_inlet_width, gas_nozzle_radius + gas_air_separator_height, 0, gridsize}; // x from left-air-inlet, y from upper gas-air-seperator-tip


Bezier(11) = {14,16,15,12}; Physical Line("wall") += {11}; // upper venturi wall of the air inlet
Bezier(12) = {13,17,11}; Physical Line("wall") += {12}; // lower air inlet wall

Line(13) = {13,14}; Physical Line("air_inlet") = {13}; // air inlet
Line(14) = {11,12}; // air port "outlet"

// ----------------------------------------------------------------------------------- //
// upper diffusor (diffusor part 1/3)
Point(21) = {gas_inlet_length + diffusor_length, outlet_radius, 0, gridsize}; // upper real outlet point
Point(22) = {(gas_inlet_length + diffusor_length)/2, outlet_radius, 0, gridsize}; // upper real outlet helper point
Point(23) = {gas_inlet_length*5/4, gas_nozzle_radius+gas_air_separator_height+air_inlet_height_chokepoint, 0, gridsize}; // helper point on the air "outlet" side (helper points need mirroring around endpoint)
Point(24) = {gas_inlet_length + diffusor_length, lower_height + middle_height, 0, gridsize}; // lower outlet point

// create bezier curve for the upper venturi wall
Bezier(21) = {12,23,22,21}; Physical Line("wall") += {21};
Line(22) = {21, 24}; Physical Line("outlet") = {22}; // upper outlet bit
Line(23) = {24, 11}; // inner wall, separating middle and upper diffusor

// ----------------------------------------------------------------------------------- //
// middle diffusor (diffusor part 1/3)
Point(31) = {gas_inlet_length + diffusor_length, lower_height, 0, gridsize}; // lower outlet point
Line(31) = {24, 31}; Physical Line("outlet") += {41}; // midlle outlet bit
Line(32) = {31, 4}; // separator middle and lower diffusor
Line(33) = {4, 11}; Physical Line("wall") += {33}; // air-gas-separator tip

// ----------------------------------------------------------------------------------- //
// lower diffusor (diffusor part 1/3)
Point(41) = {gas_inlet_length + diffusor_length, 0, 0, gridsize}; // lower outlet point
Line(41) = {31, 41}; Physical Line("outlet") += {41}; // lower outlet bit
Line(42) = {41, 3}; Physical Line("symmetry") += {42}; // diffusor symmetry part

// ----------------------------------------------------------------------------------- //
// creating surfaces, 5 total
Curve Loop(1) = {1, -3, -4, 2}; Plane Surface(1) = {1}; // gas port
Curve Loop(2) = {12, 14, -11, -13}; Plane Surface(2) = {2}; // air port
Curve Loop(3) = {21, 22, 23, 14}; Plane Surface(3) = {3}; // upper diffusor
Curve Loop(4) = {33, -23, 31, 32}; Plane Surface(4) = {4}; // middle diffusor
Curve Loop(5) = {42, 3, -32, 41}; Plane Surface(5) = {5}; // lower diffusor
Physical Surface("fluid") = {1,2,3,4,5};

// ----------------------------------------------------------------------------------- //
// Meshing - Making Transfinite Lines
Transfinite Line{-11,-12} = N_air_downstream Using Progression R_air_downstream; // air-inlet downstream
Transfinite Line{13,14,22} = N_air_width Using Bump R_air_width; // air-inlet width

Transfinite Line{-1,-4} = N_gas_downstream Using Progression R_gas_downstream; // gas-inlet downstream
Transfinite Line{2,3,41} = N_gas_width Using Bump R_gas_width; // gas-inlet width

Transfinite Line{31,33} = N_middle_width Using Bump R_middle_width; // middle diffusor layer width

Transfinite Line{21,-23,-32,-42} = N_diffusor_downstream Using Progression R_diffusor_downstream; // diffusor downstream

// ----------------------------------------------------------------------------------- //
// Meshing
Coherence;
Transfinite Surface "*";
Recombine Surface "*";

If (Do_Meshing == 1)
    Mesh 1; Mesh 2;
EndIf

// ----------------------------------------------------------------------------------- //
// Write .su2 meshfile
If (Write_mesh == 1)

    Mesh.Format = 42; // .su2 mesh format,
    Save "realVenturi.su2";

EndIf
