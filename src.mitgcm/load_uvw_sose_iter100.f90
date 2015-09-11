subroutine load_uv(irec,ut,vt,wt)
    use global, only : Nx,Ny,Nz,Nrecs,fns,path2uvw,fn_UVEL,fn_VVEL,fn_WVEL
    implicit none
    integer*4, intent(in) :: irec
    real*4, dimension(0:Nx,0:Ny-1,0:Nz-1), intent(out) :: ut,vt,wt
    !character(255), parameter :: path2uvw='/mdata4/mmazloff/SOSE/ITERS/SO6_Iter100/'

    !open(0,file=trim(path2uvw)//'UVEL.0000000100.data',&
    open(0,file=trim(path2uvw)//trim(fn_UVEL),&
        form='unformatted',access='direct',convert='BIG_ENDIAN',&
        status='old',recl=4*Nx*Ny*Nz)
    !open(1,file=trim(path2uvw)//'VVEL.0000000100.data',&
    open(1,file=trim(path2uvw)//trim(fn_VVEL),&
        form='unformatted',access='direct',convert='BIG_ENDIAN',&
        status='old',recl=4*Nx*Ny*Nz)
    !open(2,file=trim(path2uvw)//'WVEL.0000000100.data',&
    open(2,file=trim(path2uvw)//trim(fn_WVEL),&
        form='unformatted',access='direct',convert='BIG_ENDIAN',&
        status='old',recl=4*Nx*Ny*Nz)
    print*, "loading velocity fields, u ..............."
    read(0,rec=irec) ut(0:Nx-1,:,:)
    print*, "loading velocity fields, v ..............."
    read(1,rec=irec) vt(0:Nx-1,:,:)
    print*, "loading velocity fields, w ..............."
    read(2,rec=irec) wt(0:Nx-1,:,:)
    ut(Nx,:,:)=ut(0,:,:)
    vt(Nx,:,:)=vt(0,:,:)
    wt(Nx,:,:)=wt(0,:,:)
    wt=-1.0*wt
    close(0)
    close(1)
    close(2)

end subroutine load_uv
