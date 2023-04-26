# Meshes
Just a place to drop very simple meshes for CFD-solver SU2. The meshes are for testing purposes only!
Tested with 'Pyhton 3.6.0' and 'gmsh 2.8.5'. Just run './buildmesh.py' to build meshes for each zone and the combined multizone mesh (if there are multiple zones).

Due to some Linux things I need to start gmsh using `LIBGL_ALWAYS_SOFTWARE=true gmsh` when I want to be able to use th GUI, see [this gmsh-issue](https://gitlab.onelab.info/gmsh/gmsh/-/issues/2161).