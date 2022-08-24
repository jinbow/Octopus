subroutine jump(IPP)
    !introduce an artificial jump in z to enforce a constant density

    use global, only: Npts, xyz, tsg,Nx,Ny, Nz,gam,hFacC,pi2f,pj2f,pk2c

    implicit none

    integer*8, intent(in) :: IPP
    integer*8 :: i,ip,k
    real*8, dimension(-1:Nz) :: gam1d
    integer*8 :: i1,j1,k1
    real*8 :: maxgam

    print*, "apply jumping condition at the looping transition"
    print*, "gamma min and max are ", maxval(gam), minval(gam)
    print*, "mean z",  sum(xyz(:,3,IPP))/Npts
    print*, "mean gamma ",  sum(tsg(:,3,IPP))/Npts

!$OMP PARALLEL DO PRIVATE(ip,i1,j1,k1,gam1d,maxgam,k,i) SCHEDULE(dynamic)
    do ip = 1, Npts
        if (xyz(ip,2,IPP)<=Ny-1) then
            i1=pi2f(ip,IPP)
            j1=pj2f(ip,IPP)
            k1=pk2c(ip,IPP)
            if (hFacC(i1,j1,k1) .eq. 1 .and. gam(i1,j1,k1,0) .gt. 10) then
                !gam1d1 = (gamma1(i1+1,j1,:)-gamma1(i1,j1,:))*(xyz(ip,1)-ixyz(ip,1))+gamma1(i1,j1,:)
                !gam1d2 = (gamma1(i1+1,j1+1,:)-gamma1(i1,j1+1,:))*(xyz(ip,1)-ixyz(ip,1))+gamma1(i1,j1+1,:)
                !gam1d = (gam1d2-gam1d1)*(xyz(ip,2)-j1)+gam1d1
                gam1d = gam(i1,j1,:,0)
                maxgam = maxval(gam1d)
                where(gam1d==20) gam1d=maxgam
            
                if ( tsg(ip,3,IPP) < gam1d(0) ) then
                    xyz(ip,3,IPP) = 0.5d0
                elseif ( tsg(ip,3,IPP) > maxgam ) then
                    xyz(ip,3,IPP) = xyz(ip,3,IPP)
                else
                    k=0
                    i=1
                    do while ( tsg(ip,3,IPP) > gam1d(k) )
                        k=k+1
                    enddo

                    xyz(ip,3,IPP) = real(k-1,8)+(tsg(ip,3,IPP)-gam1d(k-1))/(gam1d(k)-gam1d(k-1))+0.5d0
                    if (xyz(ip,3,IPP)/=xyz(ip,3,IPP)) then
                        print*, 'k,xyz,tsg(ip,3),gam1d(k-1),',k,xyz(ip,3,IPP),tsg(ip,3,IPP),gam1d(k-1)
                    endif
                endif
            endif
        endif
    enddo
!$OMP END PARALLEL DO
!    print*, "gamma min and max are ", maxval(gam), minval(gam)
!    print*, "mean z",  sum(xyz(:,3,IPP))/Npts
!    print*, "mean gamma ",  sum(tsg(:,3,IPP))/Npts

end subroutine jump
