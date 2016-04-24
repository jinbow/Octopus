subroutine find_index(ip,IPP)
    !find particle index for C-grid variable and their distance to grid faces
    use global
    integer*8, intent(in) :: ip,IPP
    real*8 :: x

        x=mod(xyz(ip,1,IPP),real(Nx-1,8))

        xyz(ip,3,IPP) = min(abs(xyz(ip,3,IPP)),real(Nz-1,8))
        xyz(ip,2,IPP) = min(abs(xyz(ip,2,IPP)),real(Ny-1,8))

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
        
        dic(ip,IPP) = x-pi2c(ip,IPP)-0.5
        djc(ip,IPP) = xyz(ip,2,IPP)-pj2c(ip,IPP)-0.5d0
        dkc(ip,IPP) = xyz(ip,3,IPP)-pk2c(ip,IPP)-0.5d0

end subroutine find_index
