subroutine roms_point_k2z(xyz,z_w)
#include "cpp_options.h"

      use global, only: Nx,Ny,Nz,roms_h,zeta

      implicit none

      real*8 :: hmin=10.0,Tcline=10.0,theta_s=6.0,hc,theta_b=0.0
     
      real*8, intent(in) :: xyz(3)
      real*8, intent(out) :: z_w

      real*8 :: sc_w,Cs_w,sc_w0,Cs_w0,k,h
      real*8 :: hinv,Zt_avg1
      real*8 :: cff,cff_r,cff1_r,cff2_r, cff_w,cff1_w,& 
                cff1,cff2,cff3,cff2_w, z_r0,z_w0
      integer*8 :: i,j

      i=floor(xyz(1))
      j=floor(xyz(2))
      k=xyz(3)

      h=roms_h(i,j)

      hc=min(hmin,Tcline)
      cff1=1./sinh(theta_s)
      cff2=0.5/tanh(0.5*theta_s)

      sc_w0=-1.0
      Cs_w0=-1.0

      cff=1./real(Nz,8)

      sc_w=cff*real(k-Nz,8)
      Cs_w=(1.-theta_b)*cff1*sinh(theta_s*sc_w) &
              +theta_b*(cff2*tanh(theta_s*(sc_w+0.5))-0.5)

      cff_w=hc*(sc_w-Cs_w)
      cff1_w=Cs_w
      cff2_w=sc_w+1.

      z_w0=cff_w+cff1_w*h
      z_w=-1*(z_w0+zeta(i,j)*(1.+z_w0/h))

      !print*, "roms depth at ",k, xyz(3), "is ", z_w, h


end subroutine roms_point_k2z
