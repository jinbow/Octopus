subroutine get_roms_depth (zeta)
#include "cpp_options.h"
      use global, only: Nx,Ny,Nz,roms_h,drf_r

      implicit none

      real*8 :: hmin=10.0,Tcline=10.0,theta_s=6.0,hc,theta_b=0.0
     
      real*8, intent(in) :: zeta(Nx,Ny)

      integer*8 :: i,j,k,N

      real*8, dimension (0:Nz) :: sc_w,Cs_w,sc_r,Cs_r
      real*8, dimension (Nx,Ny) :: hinv,Zt_avg1,h
      real*8 :: cff,cff_r,cff1_r,cff2_r, cff_w,cff1_w,& 
                cff1,cff2,cff3,cff2_w, z_r0,z_w0
      real*8, dimension (Nx,Ny,0:Nz) :: z_w
      real*8, dimension (Nx,Ny,Nz) :: z_r,Hz


      N=Nz

      h=roms_h

      hc=min(hmin,Tcline)
      cff1=1./sinh(theta_s)
      cff2=0.5/tanh(0.5*theta_s)

      sc_w(0)=-1.0
      Cs_w(0)=-1.0

      cff=1./real(N,8)

      do k=1,N,+1
        sc_w(k)=cff*float(k-N)
        Cs_w(k)=(1.-theta_b)*cff1*sinh(theta_s*sc_w(k)) &
                  +theta_b*(cff2*tanh(theta_s*(sc_w(k)+0.5))-0.5)

!        sc_r(k)=cff*(float(k-N)-0.5)
!        Cs_r(k)=(1.-theta_b)*cff1*sinh(theta_s*sc_r(k)) &
!                  +theta_b*(cff2*tanh(theta_s*(sc_r(k)+0.5))-0.5)
      enddo

        do j=1,Ny! /or restart: copy initial
          do i=1,Nx                ! free surface field into
            hinv(i,j)=1./h(i,j)        ! array for holding fast-time
            Zt_avg1(i,j)=zeta(i,j)   ! averaged free surface.
          enddo
        enddo

      do j=1,Ny !!! WARNING: Setting old-new (!<,!>)

        do i=1,Nx  !!!          must be consistent with
          z_w(i,j,0)=-h(i,j)    !!!          similar setting in
        enddo                   !!!          omega.F
        do k=1,Nz,+1
          cff_w=hc*(sc_w(k)-Cs_w(k))
          cff1_w=Cs_w(k)
          cff2_w=sc_w(k)+1.

          !cff_r=hc*(sc_r(k)-Cs_r(k))
          !cff1_r=Cs_r(k)
          !cff2_r=sc_r(k)+1.

          do i=1,Nx
            z_w0=cff_w+cff1_w*h(i,j)                               !<
            z_w(i,j,k)=z_w0+Zt_avg1(i,j)*(1.+z_w0*hinv(i,j))       !<

            ! z_r0=cff_r+cff1_r*h(i,j)                               !<
            ! z_r(i,j,k)=z_r0+Zt_avg1(i,j)*(1.+z_r0*hinv(i,j))       !<

            Hz(i,j,k)=z_w(i,j,k)-z_w(i,j,k-1)
          enddo
        enddo

      enddo


      do k=Nz,1,-1
         drf_r(:,:,Nz-k)=Hz(:,:,k) !reverse roms vertical grid, k=0 at the surface
      enddo
         drf_r(:,:,-1)=drf_r(:,:,0)
         drf_r(:,:,Nz)=drf_r(:,:,Nz-1)


      end subroutine get_roms_depth
