module global
#include "cpp_options.h"

    implicit none
    include "size.h"
    !for particle
    integer*8 :: Npts,NPP,SNPP


    CHARACTER(32) :: fn_particle_init
    REAL*4 , DIMENSION(-2:Nx+1,-2:Ny+1,-1:Nz,0:1) :: uu=0d0,vv=0d0,ww=0d0
    REAL*4 , DIMENSION(-2:Nx+1,0:Ny-1,-1:Nz,0:1) :: theta=0e0,salt=0e0,gam=0e0
    REAL*4 , DIMENSION(-2:Nx+1,0:Ny-1,-1:Nz) :: hFacC
    REAL*4 , DIMENSION(-2:Nx+1,0:Ny-1, -1:Nz) :: reflect_x,reflect_y
    REAL*4 , DIMENSION(-2:Nx+1,0:Ny-1) :: mld,phihyd

    REAL*4 :: sose_depth(-2:Nx+1,0:Ny-1)
    REAL*8, parameter     :: PI=3.141592653589793238462643383279502884197d0
    REAL*8, DIMENSION(:,:,:), ALLOCATABLE :: xyz, xyz0, uvwp, dxyz_fac


    REAL*8, DIMENSION(:,:,:), ALLOCATABLE :: tsg


!#ifdef saveGradient
    REAL*8, DIMENSION(:,:,:), ALLOCATABLE :: grad
!#endif

    !pickup
    REAL*8 :: pickup=0
    integer*8 :: marker(2)=0
    REAL*8 :: pickupFreq=7776000.0

    INTEGER*8, DIMENSION(:,:), ALLOCATABLE :: pi2f,pj2f,pk2f,pi2c,pj2c,pk2c
    REAL*8, DIMENSION(:,:), ALLOCATABLE :: dif, djf, dkf, dic, djc, dkc !distance to face and cell center
    REAL*8, DIMENSION(:,:), ALLOCATABLE :: parti_mld

    !grid
    REAL*8, DIMENSION(-2:Nx+1,0:Ny-1) :: dxg_r, dyg_r
    REAL*8, DIMENSION(-1:Nz):: drf_r
    REAL*8 :: z2k(5701), k2z(0:1040)

    !timing parameters
    integer*8 :: saveFreq, diagFreq,iswitch,count_step=0,rec_num
    REAL*8 :: t_amend, DumpClock=60, target_density,tt,dtp,&
              dt,dt_mld,tstart=0,tend,tend_file,dt_reinit,dt_case=30*86400
    logical :: vel_stationary


    !file names
    INTEGER*8, ALLOCATABLE :: fn_ids(:,:)
    INTEGER*8 :: fn_uvwtsg_ids(7),fn_xyz_tsg_mld_ids(3),fn_id_mld,FnPartiInitId

    INTEGER*8 :: file_i0
    INTEGER*8 :: filename_increment=1
    CHARACTER (len=64) :: casename,path2uvw,path2grid,FnPartiInit,output_dir,fn_phihyd,fn_mld
    CHARACTER (len=64) :: fn_UVEL,fn_VVEL,fn_WVEL,fn_THETA,fn_SALT,fn_GAMMA

    CHARACTER (len=64), dimension(Nrecs, Nvar2read) :: filenames

    !mixing parameters
    REAL*8 :: Khdiff, Kvdiff, kvdt2, khdt2

#ifdef isArgo
    integer*8 :: parking_time=864000,surfacing_time=600,save_argo_FnID
    real*8 :: parking_depth=20,max_depth=30
    integer*8, DIMENSION(:,:,:), ALLOCATABLE :: argo_clock
    integer*8, allocatable :: save_argo_FnIDs(:,:)

#ifdef saveArgoProfile
    integer*8, allocatable :: save_argo_profileIDs(:,:)
    integer*8 :: argoprofilerec=1
#endif

#endif

#ifdef isGlider
    real*8 :: parking_time=1,surfacing_time=60
    real*8, ALLOCATABLE :: glider_clock(:,:,:),glider_position(:,:,:),glider_uv(:,:,:),glider_angle(:,:)
    integer*8, ALLOCATABLE :: glider_cycle(:,:)
    real*8 :: dive_depth,absv
    integer*8, allocatable :: save_glider_FnIDs(:,:)
#endif

end module global
