subroutine load_depth()
    use global, only: sose_depth,Nx,Ny,path2uvw
    implicit none
    open(53,file=trim(path2uvw)//'sose_depth.bin',&
        form='unformatted',access='direct',convert='BIG_ENDIAN',&
        status='old',recl=4*Nx*Ny)
    read(53,rec=1) sose_depth
    close(53)
end subroutine load_depth
