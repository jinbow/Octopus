subroutine apply_mixing_mld(IPP)
#include "cpp_options.h"

    use global, only: Npts,hFacC,xyz,z2k,k2z,Nx,Ny,dt_mld,tt,mld,&
        parti_mld,kvdt2,khdt2,dxg_r,dyg_r,drf_r,pi2f
    use random, only: random_normal
    implicit none
    integer*8 :: i,icount
    integer*8 :: ip,jp,kp
    real*8 :: num, z, pz
    logical :: ivok_mld
    integer*8, intent(in) :: IPP

    ivok_mld= (mod(tt,dt_mld) .eq. 0)

        call load_mld(tt)
        !where (mld>1000) mld=1000d0
        parti_mld=0d0
        call random_seed(put=int(pi2f(1:30,1),8))

        icount=0
!$OMP PARALLEL DO PRIVATE(i,ip,jp,kp,pz,num,z)
        do i =1,Npts
            if (xyz(i,2,IPP)<Ny-1) then
                !ip=pi2f(i)
                !jp=pj2f(i)
                !kp=pk2f(i)
                ip=floor(mod(xyz(i,1,IPP),real(Nx-1)))
                jp=floor(xyz(i,2,IPP))
                kp=floor(xyz(i,3,IPP))
                    pz = k2z(int(xyz(i,3,IPP)*10))
                    !mixed layer uniform mixing
                    if (pz .lt. mld(ip,jp) ) then
                        icount=icount+1
                        call random_number(num)
                        !extend mixing to the level 50 meters below the mixed layer,
                        !or 0.25 of the depth of the mixed layer whichever is smaller.
                        z =  num * (mld(ip,jp) + min(20d0,mld(ip,jp)*0.25))
                        !convert depth to index
                        parti_mld(i,IPP)=z-pz
                        xyz(i,3,IPP) =real(z2k(floor(z)),8)
                    endif
            endif
        enddo
!$OMP END PARALLEL DO
        print*, "%============================================================"
        print*, "%              MLD            +"
        print*, "%Total ",icount," particles in the mixed layer at day ", tt/86400.
        print*, "%============================================================"

end subroutine apply_mixing_mld

