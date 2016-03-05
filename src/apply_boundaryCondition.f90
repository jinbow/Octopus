subroutine set_boundary(IPP)
    use global
    implicit none
    integer*8 :: ip
    integer*8, intent(in) :: IPP


!$OMP PARALLEL DO PRIVATE(ip) SCHEDULE(dynamic)
    do ip =1,Npts
        !print*, ip, xyz(ip,:,IPP)
        if (xyz(ip,3,IPP)<0) then
            xyz(ip,3,IPP)=-xyz(ip,3,IPP)
        endif

        if (xyz(ip,3,IPP)>Nz-1) then
            xyz(ip,3,IPP)=real(Nz-2d0,8)
        endif
        
        call find_index(ip,IPP)

        !reflective boundary condition
        if (hFacC(pi2f(ip,IPP),pj2f(ip,IPP),pk2f(ip,IPP))<1e-5) then
            xyz(ip,1,IPP)=xyz(ip,1,IPP)+reflect_x(pi2f(ip,IPP),pj2f(ip,IPP),pk2f(ip,IPP)) !semi-reflective boundary
            xyz(ip,2,IPP)=xyz(ip,2,IPP)+reflect_y(pi2f(ip,IPP),pj2f(ip,IPP),pk2f(ip,IPP)) !semi-reflective boundary
        endif


    enddo
!$OMP END PARALLEL DO

end subroutine set_boundary
