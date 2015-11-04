subroutine find_particle_uvw(t_amend,ip,IPP,t0,t1,uvw)
#include "cpp_options.h"

    use global, only : Nx,Ny,Nz,Npts,xyz,&
        dxg_r,dyg_r,drf_r,dtp,&
        uu,vv,ww,hFacC,tsg,theta,salt,&
        gam,tt, &
        pi2f,pj2f,pk2f,pi2c,pj2c,pk2c, &
        dif, djf, dkf, dic, djc, dkc

    implicit none

    real*8, intent(in) :: t_amend
    integer*8,intent(in) :: t0,t1,ip,IPP

    real*8,dimension(3),intent(out) :: uvw=0.0

    real*8,dimension(3) :: dxyz_fac
    integer*8 :: i,j,k
    real*8 :: tmp0,tmp1,tamend,deltat

    if (dtp+t_amend>1) then
        tamend=0.0
        deltat=1d0
    else
        tamend=t_amend
        deltat=dtp+t_amend
    endif


    call find_index(ip,IPP)

    dxyz_fac(1) = dxg_r(pi2f(ip,IPP),pj2c(ip,IPP))
    dxyz_fac(2) = dyg_r(pi2c(ip,IPP),pj2f(ip,IPP))
    dxyz_fac(3) = drf_r(pk2f(ip,IPP))

    i=pi2f(ip,IPP)
    j=pj2c(ip,IPP)
    k=pk2c(ip,IPP)

    call interp_trilinear(dif(ip,IPP),djc(ip,IPP),dkc(ip,IPP),&
        uu(i:i+1,j:j+1,k:k+1,t0),tmp0)
    call interp_trilinear(dif(ip,IPP),djc(ip,IPP),dkc(ip,IPP),&
        uu(i:i+1,j:j+1,k:k+1,t1),tmp1)
    uvw(1)= (tmp1-tmp0)*deltat + tmp0

    i=pi2c(ip,IPP)
    j=pj2f(ip,IPP)
    call interp_trilinear(dic(ip,IPP),djf(ip,IPP),dkc(ip,IPP),&
        vv(i:i+1,j:j+1,k:k+1,t0),tmp0)
    call interp_trilinear(dic(ip,IPP),djf(ip,IPP),dkc(ip,IPP),&
        vv(i:i+1,j:j+1,k:k+1,t1),tmp1)

    uvw(2) = (tmp1-tmp0)*deltat + tmp0

#ifdef isArgo
    call get_argo_w(uvw(3))
#else
    j=pj2c(ip,IPP)
    k=pk2f(ip,IPP)

    call interp_trilinear(dic(ip,IPP),djc(ip,IPP),dkf(ip,IPP),&
        ww(i:i+1,j:j+1,k:k+1,t0),tmp0)
    call interp_trilinear(dic(ip,IPP),djc(ip,IPP),dkf(ip,IPP),&
        ww(i:i+1,j:j+1,k:k+1,t1),tmp1)

    uvw(3) = (-tmp1+tmp0)*deltat - tmp0 !positive velocity points downward
#endif

    uvw=uvw*dxyz_fac


end subroutine find_particle_uvw
