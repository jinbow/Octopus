Customize velocity fields
=========================

The following can help you get started to implement your own analytic functions for velocities. 

The procedure of loading velocities
--------------------------------------

There are usually many individual files used to save velocity data from numerical simulations. In order to read it, we need to map a list of filename to those data. The relavent fortran Character variables are defined in global.f90 as the following block.

:: 

    !file names
    INTEGER*8, ALLOCATABLE :: fn_ids(:,:)
    INTEGER*8 :: fn_uvwtsg_ids(7),fn_xyz_tsg_mld_ids(3),fn_id_mld,FnPartiInitId

    INTEGER*8 :: file_i0
    INTEGER*8 :: filename_increment=1
    CHARACTER (len=64) :: casename,path2uvw,path2grid,FnPartiInit,output_dir,fn_phihyd,fn_mld
    CHARACTER (len=64) :: fn_UVEL,fn_VVEL,fn_WVEL,fn_THETA,fn_SALT,fn_GAMMA

    CHARACTER (len=64), dimension(Nrecs, Nvar2read) :: filenames


If one-record-per-file, the program will use c_filenames.f90 to pre-calculate the filenames and save them to variable **filenames(N,M)**, where **N** is the number of records and **M** is the number of variables. 

The velocity data will be loaded into memeory by the subroutine load_uvw() in **io.f90**. 

The velocity data will next be used by **find_particle_uvw()** in **get_velocity.f90**. 

After the velocity data interpolated onto the particle positions, **rk4()** will be used to intergrate the trajectory position. Because **rk4** uses several time steps, the subroutine **find_particle_uvw()** will be used four times in **rk4**, each time with an updated velocity.  


