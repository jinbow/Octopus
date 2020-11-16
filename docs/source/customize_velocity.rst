Customize velocity fields
=========================

The following can help you get started to implement your own analytic functions for velocities. 

The procedure of loading the velocities
--------------------------------------

There are usually many indivisual files used to save velocity data from numerical simulations. In order to read it, we need to map a list of filename to those data. The relavent fortran Character variables are defined in global.f90 as the following block. 

:: 

    !file names
    INTEGER*8, ALLOCATABLE :: fn_ids(:,:)
    INTEGER*8 :: fn_uvwtsg_ids(7),fn_xyz_tsg_mld_ids(3),fn_id_mld,FnPartiInitId

    INTEGER*8 :: file_i0
    INTEGER*8 :: filename_increment=1
    CHARACTER (len=64) :: casename,path2uvw,path2grid,FnPartiInit,output_dir,fn_phihyd,fn_mld
    CHARACTER (len=64) :: fn_UVEL,fn_VVEL,fn_WVEL,fn_THETA,fn_SALT,fn_GAMMA

    CHARACTER (len=64), dimension(Nrecs, Nvar2read) :: filenames

