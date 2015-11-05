subroutine find_index(ip,IPP)
    !find particle index for C-grid variable and their distance to grid faces
    use global, only: pi2f,pj2f,pk2f,pi2c,pj2c,pk2c,xyz, &
        dif, djf, dkf, dic, djc, dkc,Nx,Nz,Ny
    integer*8, intent(in) :: ip,IPP
    real*8 :: x
    ! these ifs make sure the index does not go beyond the allowed values, otherwise
    ! unpredicted segmentation error occurs

    !if (xyz(ip,1)>Nx+1) then
    !    xyz(ip,1)=Nx+0.5
    !elseif (xyz(ip,1)<-1) then
    !    xyz(ip,1)=-0.5
    !endif
    if (xyz(ip,2,IPP)<Ny-1) then
        x=mod(xyz(ip,1,IPP),real(Nx-1,8))
        !if (xyz(ip,3)>Nz-0.5) then
        !    xyz(ip,3)=Nz-1.5
        !elseif (xyz(ip,3)<-1) then
        !    xyz(ip,3)=0.0
        !endif

        ! pi2f(ip)=floor(xyz(ip,1))
        pi2f(ip,IPP)=floor(x)
        pj2f(ip,IPP)=floor(xyz(ip,2,IPP))
        pk2f(ip,IPP)=floor(xyz(ip,3,IPP))
        ! pi2c(ip)=floor(xyz(ip,1)-0.5d0)
        pi2c(ip,IPP)=floor(x-0.5d0)
        pj2c(ip,IPP)=floor(xyz(ip,2,IPP)-0.5d0)
        pk2c(ip,IPP)=floor(xyz(ip,3,IPP)-0.5d0)

        ! dif(ip) = xyz(ip,1)-pi2f(ip)
        dif(ip,IPP) = x-pi2f(ip,IPP)
        djf(ip,IPP) = xyz(ip,2,IPP)-pj2f(ip,IPP)
        dkf(ip,IPP) = xyz(ip,3,IPP)-pk2f(ip,IPP)
        
        ! dic(ip) = xyz(ip,1)-pi2c(ip)-0.5d0
        dic(ip,IPP) = x-pi2c(ip,IPP)-0.5d0
        djc(ip,IPP) = xyz(ip,2,IPP)-pj2c(ip,IPP)-0.5d0
        dkc(ip,IPP) = xyz(ip,3,IPP)-pk2c(ip,IPP)-0.5d0

        !if (maxval(pj2f(ipts(1):ipts(2)))>321 .or. minval(pj2f(ipts(1):ipts(2)))<-1 ) then
        !   print*, "something wrong, maxval(pj2f)"
        !endif
        !    if (pi2f(ip)>Nx-1 .or. pi2f(ip)<-1) then
        !       print*, 'something wrong in pi2f'
        !    endif
        if (pk2f(ip,IPP)<-2 .or. pk2f(ip,IPP)>41) then
            xyz(ip,3,IPP)=mod(abs(xyz(ip,3,IPP)),real(Nz-1,8))
            print*, "something wrong in pk2f",pk2f(ip,IPP),'changed the vertical coordinate to',xyz(ip,3,IPP)
        endif
    endif
end subroutine find_index
