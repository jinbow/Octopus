subroutine load_reflect()
    use global, only: reflect_x,reflect_y,Nx,Ny,Nz,path2uvw
    implicit none
    open(43,file=trim(path2uvw)//'reflect_x.bin',&
        form='unformatted',access='direct',convert='BIG_ENDIAN',&
        status='old',recl=4*Nz*(Nx+4)*Ny)
    read(43,rec=1)    reflect_x(-2:Nx+1,0:Ny-1,0:Nz-1)
    close(43)
    !  reflect_x(-2:-1,:,:)=reflect_x(Nx-2:Nx-1,:,:)
    !  reflect_x(Nx:Nx+1,:,:)=reflect_x(0:1,:,:)
    reflect_x(:,:,Nz)=reflect_x(:,:,Nz-1)
    reflect_x(:,:,-1)=reflect_x(:,:,0)
    print*, "=================================================="
    print*, "loading reflect_x"

    open(43,file=trim(path2uvw)//'reflect_y.bin',&
        form='unformatted',access='direct',convert='BIG_ENDIAN',&
        status='old',recl=4*Nz*(Nx+4)*Ny)
    read(43,rec=1) reflect_y(-2:Nx+1,0:Ny-1,0:Nz-1)
    close(43)
    !  reflect_y(-2:-1,:,:)=reflect_y(Nx-2:Nx-1,:,:)
    !  reflect_y(Nx:Nx+1,:,:)=reflect_y(0:1,:,:)
    reflect_y(:,:,Nz)=reflect_y(:,:,Nz-1)
    reflect_y(:,:,-1)=reflect_y(:,:,0)
    print*, "=================================================="
    print*, "loading reflect_y"


end subroutine load_reflect
