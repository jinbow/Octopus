
subroutine diag()
    use global, only : tsg,xyz,uvwp
    implicit none
    print*, "========================================="
    print*, "particle diagnoses"
    print*, "Temperature maximum  = ",maxval(tsg(:,1,:))
    print*, "Temperature  minimum = ",minval(tsg(:,1,:))
    print*, "Salinity maximum     = ",maxval(tsg(:,2,:))
    print*, "Salinity minimum     = ",minval(tsg(:,2,:))
    print*, "Density maximum      = ",maxval(tsg(:,3,:))
    print*, "Density minimum      = ",minval(tsg(:,3,:))
    print*, "Depth minimum        = ",minval(xyz(:,3,:))
    print*, "Depth maximum        = ",maxval(xyz(:,3,:))
    print*, "x minimum            = ",minval(xyz(:,1,:))
    print*, "x maximum            = ",maxval(xyz(:,1,:))
    print*, "y minimum            = ",minval(xyz(:,2,:))
    print*, "y maximum            = ",maxval(xyz(:,2,:))
    print*, "z minimum            = ",minval(xyz(:,3,:))
    print*, "z maximum            = ",maxval(xyz(:,3,:))
    print*, "u maximum            = ",maxval(uvwp(:,1,:))
    print*, "v maximum            = ",maxval(uvwp(:,2,:))
    print*, "w maximum            = ",maxval(uvwp(:,3,:))

end subroutine diag

subroutine count_stagnant()

    use global, only : tsg,Npts,NPP
    implicit none
    integer*8 :: ip,nstag,IPP
    nstag=0

    do IPP=1,NPP
        do ip=1,Npts
            if (tsg(ip,1,IPP) .eq. 0) then
                nstag=nstag+1
            endif
        enddo
    enddo


    print*, "Number of stagnant particles:  ", nstag

end subroutine count_stagnant


subroutine read_filenames()
    use global, only : Nrecs
    implicit none
    character(28), dimension(Nrecs,3) :: fns
    integer :: i
    !read filenames
    open(4,file='filelist.u',form='formatted')
    open(5,file='filelist.v',form='formatted')
    open(6,file='filelist.w',form='formatted')
    do i=1,Nrecs
        read(4, "(A28)") fns(i,1)
        read(5, "(A28)") fns(i,2)
        read(6, "(A28)") fns(i,3)
    enddo
    close(4)
    close(5)
    close(6)
end subroutine read_filenames


