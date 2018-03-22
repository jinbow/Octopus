subroutine rk4(SNPP)
#include "cpp_options.h"

    ! integrate in time using RK4 scheme
#ifdef isGlider
    use global, only : tt,Npts,iswitch,xyz,dt,Nx,Ny,Nz,glider_clock,&
#endif
#ifdef isArgo
    use global, only : tt,Npts,iswitch,xyz,dt,Nx,Ny,Nz,argo_clock,&
#endif
#ifndef isArgo
#ifndef isGlider
    use global, only : tt,Npts,iswitch,xyz,dt,Nx,Ny,Nz,&
#endif
#endif
                       uvwp,dt_file,t_amend
    implicit none
    real*8, dimension(3) :: x0,x1,uvw
    integer*8 :: t0,t1,ip,IPP
    integer*8, intent(in) :: SNPP

    t0=abs(iswitch-1)
    t1=iswitch
    do IPP=1,SNPP

#ifdef isGlider
!$OMP PARALLEL DO DEFAULT(NONE) PRIVATE(x0,x1,uvw,ip) SHARED(glider_clock,IPP,SNPP,Npts,xyz,t_amend,t0,t1,dt)
#endif
#ifdef isArgo
!$OMP PARALLEL DO DEFAULT(NONE) PRIVATE(x0,x1,uvw,ip) SHARED(argo_clock,IPP,SNPP,Npts,xyz,t_amend,t0,t1,dt)
#endif
#ifndef isGlider
#ifndef isArgo
!$OMP PARALLEL DO DEFAULT(NONE) PRIVATE(x0,x1,uvw,ip) SHARED(IPP,SNPP,Npts,xyz,t_amend,t0,t1,dt)
#endif
#endif


        do ip=1,Npts

            x0=xyz(ip,:,IPP)
            x1=xyz(ip,:,IPP)

            call find_particle_uvw(0.0,ip,IPP,t0,t1,uvw)
            x1=x1+dt*uvw/6.0
            xyz(ip,:,IPP)=x0+dt*uvw/2.0

            call find_particle_uvw(t_amend,ip,IPP,t0,t1,uvw)
            x1=x1+dt*uvw/3.0
            xyz(ip,:,IPP)=x0+dt*uvw/2.0

            call find_particle_uvw(t_amend,ip,IPP,t0,t1,uvw)
            x1=x1+dt*uvw/3.0
            xyz(ip,:,IPP)=x0+dt*uvw

            call find_particle_uvw(t_amend*2.0,ip,IPP,t0,t1,uvw)
            xyz(ip,:,IPP)=x1+dt*uvw/6.0

#ifdef isArgo
            argo_clock(ip,2,IPP)=argo_clock(ip,2,IPP)+dt
#endif
#ifdef isGlider
            glider_clock(ip,2,IPP)=glider_clock(ip,2,IPP)+dt
#endif

        enddo

!$OMP END PARALLEL DO

#ifdef use_Laplacian_diffusion
    call apply_Laplacian_diffusion(IPP)
#endif

#ifdef use_mixedlayer_shuffle
    call apply_mixing_mld(IPP)
#endif

#ifdef reflective_continent
    call set_boundary(IPP)
#endif

!if (ip==1) then
!   print*, "=====",xyz(1,:,1)
!endif
 

    enddo

end subroutine rk4
