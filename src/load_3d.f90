
subroutine load_3d(fn_id,irec,dout)
    use global, only : Nx,Ny,Nz,Nrecs
    implicit none
    INTEGER*8, intent(in) :: irec,fn_id
    real*4, dimension(-2:Nx+1,0:Ny-1,-1:Nz), intent(out) :: dout
    integer*8 :: i,k

    i=mod(irec,Nrecs)
    if (i .eq. 0) then
        i=Nrecs
    endif

    i=(i-1)*Nz+1
!$OMP PARALLEL DO PRIVATE(k)
    do k=0,Nz-1
        read(fn_id,rec=i+k) dout(0:Nx-1,:,k)
        dout(Nx:Nx+1,:,k)=dout(0:1,:,k)
        dout(-2:-1,:,k)=dout(Nx-2:Nx-1,:,k)
    enddo
!$OMP END PARALLEL DO


end subroutine load_3d
