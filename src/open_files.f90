subroutine open_files()
    use global,only:fn_uvwtsg_ids,fn_ids,fn_id_mld,path2uvw,fn_UVEL,&
                    fn_VVEL,fn_WVEL,fn_THETA,fn_SALT,fn_GAMMA,fn_PHIHYD,&
                    Nx,Ny,Nz,fn_MLD
    implicit none

    open(fn_uvwtsg_ids(1),file=trim(path2uvw)//trim(fn_UVEL),&
        form='unformatted',access='direct',convert='BIG_ENDIAN',&
        status='old',recl=4*Nx*Ny)
    open(fn_uvwtsg_ids(2),file=trim(path2uvw)//trim(fn_VVEL),&
        form='unformatted',access='direct',convert='BIG_ENDIAN',&
        status='old',recl=4*Nx*Ny)
    open(fn_uvwtsg_ids(3),file=trim(path2uvw)//trim(fn_WVEL),&
        form='unformatted',access='direct',convert='BIG_ENDIAN',&
        status='old',recl=4*Nx*Ny)
    open(fn_uvwtsg_ids(4),file=trim(path2uvw)//trim(fn_THETA),&
        form='unformatted',access='direct',convert='BIG_ENDIAN',&
        status='old',recl=4*Nx*Ny)
    open(fn_uvwtsg_ids(5),file=trim(path2uvw)//trim(fn_SALT),&
        form='unformatted',access='direct',convert='BIG_ENDIAN',&
        status='old',recl=4*Nx*Ny)
    open(fn_uvwtsg_ids(6),file=trim(path2uvw)//trim(fn_GAMMA),&
        form='unformatted',access='direct',convert='BIG_ENDIAN',&
        status='old',recl=4*Nx*Ny)
    if (trim(fn_PHIHYD) .ne. '') then
    open(fn_uvwtsg_ids(7),file=trim(path2uvw)//trim(fn_PHIHYD),&
        form='unformatted',access='direct',convert='BIG_ENDIAN',&
        status='old',recl=4*Nx*Ny)
    endif
    open(fn_id_mld,file=trim(path2uvw)//trim(fn_MLD),&
        form='unformatted',access='direct',convert='BIG_ENDIAN',&
        status='old',recl=4*Nx*Ny)

end subroutine open_files
