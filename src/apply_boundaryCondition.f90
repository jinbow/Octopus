subroutine set_boundary(IPP)
    use global
    implicit none
    integer*8 :: ip
    integer*8, intent(in) :: IPP


!$OMP PARALLEL DO PRIVATE(ip) SCHEDULE(dynamic)
    do ip =1,Npts
        !print*, ip, xyz(ip,:,IPP)
        !if (xyz(ip,3,IPP)<0) then 
        !   print*, ip,IPP,xyz(ip,3,IPP)
        !endif

        !xyz(ip,3,IPP) = min(abs(xyz(ip,3,IPP)),real(Nz-1,8))
        !xyz(ip,2,IPP) = sign(xyz(ip,2,IPP),1e0)
        !xyz(ip,2,IPP) = min(xyz(ip,2,IPP),real(Ny-1,8))

        call find_index(ip,IPP)

        !reflective boundary condition
        if (hFacC(pi2f(ip,IPP),pj2f(ip,IPP),pk2f(ip,IPP))<1e-5) then
            xyz(ip,1,IPP)=xyz(ip,1,IPP)+reflect_x(pi2f(ip,IPP),pj2f(ip,IPP),pk2f(ip,IPP)) !semi-reflective boundary
            xyz(ip,2,IPP)=xyz(ip,2,IPP)+reflect_y(pi2f(ip,IPP),pj2f(ip,IPP),pk2f(ip,IPP)) !semi-reflective boundary
        endif


    enddo
!$OMP END PARALLEL DO

end subroutine set_boundary
