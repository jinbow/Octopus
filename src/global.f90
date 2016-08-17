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
    REAL*8 :: z2k(5701), k2z(0:420)

    !timing parameters
    REAL*8 :: t_amend, saveFreq,DumpClock=60, diagFreq, target_density
    REAL*8 :: tt,dtp,dt,dt_mld,tstart,tend,tend_file,dt_reinit,dt_case=15*86400
    INTEGER*8 :: rec_num
    logical :: vel_stationary
    integer*8 :: iswitch,count_step=0


    !file names
    INTEGER*8, ALLOCATABLE :: fn_ids(:,:)
    INTEGER*8 :: fn_uvwtsg_ids(7),fn_xyz_tsg_mld_ids(3),fn_id_mld

    INTEGER*8 :: file_i0
#ifdef one_file_per_step
    CHARACTER (len=255),dimension(Nrecs) :: fn_UVEL,fn_VVEL,fn_WVEL,fn_THETA,fn_SALT,fn_GAMMA
#else
    CHARACTER (len=255) :: casename,path2uvw,path2grid,fn_parti_init,&
#endif


    !mixing parameters
    REAL*8 :: Khdiff, Kvdiff, kvdt2, khdt2
#ifdef isArgo
    integer*8 :: argo_clock(2)=0,parking_time,surfacing_time
#endif

end module global
