subroutine apply_Laplacian_diffusion(IPP)
#include "cpp_options.h"

    use global, only: Npts,hFacC,xyz,z2k,k2z,Nx,Ny,dt_mld,tt,mld,&
        parti_mld,kvdt2,khdt2,dxg_r,dyg_r,drf_r,pi2f
    use random, only: random_normal
    implicit none
    integer*8 :: i
    integer*8 :: ip,jp,kp
    integer*8, intent(in) :: IPP

    call random_seed(put=int(pi2f(1:30,1),8))

!$OMP PARALLEL DO PRIVATE(i,ip,jp)
        do i =1,Npts
                ip=floor(mod(xyz(i,1,IPP),real(Nx-1)))
                jp=floor(xyz(i,2,IPP))
                kp=floor(xyz(i,3,IPP))
                !horizontal mixing
                xyz(i,1,IPP) = xyz(i,1,IPP)+random_normal()*khdt2*dxg_r(ip,jp)
                xyz(i,2,IPP) = xyz(i,2,IPP)+random_normal()*khdt2*dyg_r(ip,jp)
                !vertical mixing
                xyz(i,3,IPP) = xyz(i,3,IPP)+random_normal()*kvdt2*drf_r(kp)
        enddo
!$OMP END PARALLEL DO
end subroutine apply_Laplacian_diffusion

