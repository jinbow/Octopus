subroutine rk4(SNPP)
#include "cpp_options.h"

    ! integrate in time using RK4 scheme
    use global, only : tt,Npts,iswitch,xyz,dt,Nx,Ny,Nz,&
                       uvwp,dt_file,t_amend

    implicit none
    real*8, dimension(3) :: x0,x1,uvw
    integer*8 :: t0,t1,ip,IPP
    integer*8, intent(in) :: SNPP

    t0=abs(iswitch-1)
    t1=iswitch
    do IPP=1,SNPP
!$OMP PARALLEL DO DEFAULT(NONE) PRIVATE(x0,x1,uvw,ip) SHARED(IPP,SNPP,Npts,xyz,t_amend,t0,t1,dt)
        do ip=1,Npts
            x0=xyz(ip,:,IPP)
            x1=xyz(ip,:,IPP)

            call find_particle_uvw(0.0d0,ip,IPP,t0,t1,uvw)
            x1=x1+dt*uvw/6d0
            xyz(ip,:,IPP)=x0+dt*uvw/2d0

            call find_particle_uvw(t_amend,ip,IPP,t0,t1,uvw)
            x1=x1+dt*uvw/3d0
            xyz(ip,:,IPP)=x0+dt*uvw/2d0

            call find_particle_uvw(t_amend,ip,IPP,t0,t1,uvw)
            x1=x1+dt*uvw/3d0
            xyz(ip,:,IPP)=x0+dt*uvw

            call find_particle_uvw(t_amend*2d0,ip,IPP,t0,t1,uvw)
            xyz(ip,:,IPP)=x1+dt*uvw/6d0
        enddo
!$OMP END PARALLEL DO

#ifdef use_horizontal_diffusion
    call apply_mixing_Kh(IPP)
#endif

#ifdef use_mixedlayer_shuffle
    call apply_mixing_mld(IPP)
#endif

#if boundaryCondition == 1
    call set_boundary(IPP)
#endif

    enddo

end subroutine rk4
