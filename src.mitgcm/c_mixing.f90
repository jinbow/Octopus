subroutine apply_mixing(IPP)

    use global, only: Npts,hFacC,xyz,z2k,k2z,Nx,Ny,dt_mld,tt,mld,&
        useMLD,parti_mld,kvdt2,khdt2,dxg_r,dyg_r,drf_r,pi2f
    use random, only: random_normal
    implicit none
    !integer*4, target :: ixyz(Npts,3)
    !    real*4 , dimension(-1:Nx,0:Ny-1) :: mld
    integer*8 :: i,icount

    integer*8 :: ip,jp,kp
    real*8 :: num, z, pz
    logical :: ivok_mld
    integer*8, intent(in) :: IPP

    ivok_mld= (mod(tt,dt_mld) .eq. 0) .and. useMLD

    if (ivok_mld) then
        call load_mld(tt)
        where (mld>1000) mld=1000d0
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
                if (hFacC(ip,jp,kp) .eq. 1) then
                    pz = k2z(int(xyz(i,3,IPP)*10))
                    !mixed layer uniform mixing
                    if (pz .lt. mld(ip,jp) .and. ivok_mld) then
                        icount=icount+1
                        call random_number(num)
                        !extend mixing to the level 50 meters below the mixed layer,
                        !or 0.25 of the depth of the mixed layer whichever is smaller.
                        z =  num * (mld(ip,jp) + min(20d0,mld(ip,jp)*0.25))
                        !convert depth to index
                        parti_mld(i,IPP)=z-pz
                        xyz(i,3,IPP) =real(z2k(floor(z)),8)
                    else
                        !random displacement for vertical diffusion
                        xyz(i,3,IPP) = xyz(i,3,IPP)+random_normal()*kvdt2*drf_r(kp)
                        !if (hFacC(ip,jp,kp) .lt. 1) then
                        !    xyz(i,3) = 2*real(floor(xyz(i,3))) - xyz(i,3)
                        !endif
                        !mirror boundary condition at the surface
                        if (xyz(i,3,IPP)<0) then
                            xyz(i,3,IPP)=-xyz(i,3,IPP)
                        endif
                    endif
                    !horizontal mixing
                    xyz(i,1,IPP) = xyz(i,1,IPP)+random_normal()*khdt2*dxg_r(ip,jp)
                    xyz(i,2,IPP) = xyz(i,2,IPP)+random_normal()*khdt2*dyg_r(ip,jp)
                endif
            endif
        enddo
!$OMP END PARALLEL DO
    endif
    if (ivok_mld) then
        print*, "%============================================================"
        print*, "%              MLD            +"
        print*, "%Total ",icount," particles in the mixed layer at day ", tt/86400.
        print*, "%============================================================"
    endif

end subroutine apply_mixing

