subroutine load_z_lookup_table()

    use global, only: z2k,k2z,path2uvw
    implicit none
    real*4::tmp(5701),tmp1(0:420)
    open(63,file=trim(path2uvw)//'z_to_k_lookup_table.bin',&
        form='unformatted',access='direct',convert='BIG_ENDIAN',&
        status='old',recl=4*5701)
    read(63,rec=1) tmp
    z2k=real(tmp,8)
    close(63)

    open(64,file=trim(path2uvw)//'k_to_z_lookup_table.bin',&
        form='unformatted',access='direct',convert='BIG_ENDIAN',&
        status='old',recl=4*421)
    read(64,rec=1) tmp1
    k2z=real(tmp1,8)
    close(64)

end subroutine load_z_lookup_table

subroutine load_mld(tt)

    use global, only: Nx,Ny,dt_mld,tend_file,fn_id_mld,mld
    real*8, intent(in) :: tt
    integer*8 :: i
    
    i=int(mod(tt,tend_file)/dt_mld)+1
    print*, "load mixed layer depth data at time ",tt, "and step", i
    read(fn_id_mld,rec=i) mld(0:Nx-1,0:Ny-1)

    mld(-2:-1,:) = mld(Nx-2:Nx-1,:)
    mld(Nx:Nx+1,:)=mld(0:1,:)

end subroutine load_mld


subroutine load_PHIHYD(tt)

    use global, only: Nx,Ny,dt_mld,tend_file,fn_uvwtsg_ids,phihyd
    real*8, intent(in) :: tt
    integer*8 :: i

    i=int(mod(tt,tend_file)/dt_mld)+1
    print*, "load PHIHYD data at time ",tt, "and step", i
    read(fn_uvwtsg_ids(7),rec=i) phihyd(0:Nx-1,0:Ny-1)

    phihyd(-2:-1,:) = phihyd(Nx-2:Nx-1,:)
    phihyd(Nx:Nx+1,:)=phihyd(0:1,:)

end subroutine load_PHIHYD


subroutine load_3d(fn_id,irec,dout)
    use global, only : Nx,Ny,Nz,Nrecs,xyz
    implicit none
    INTEGER*8, intent(in) :: irec,fn_id
    real*4, dimension(-2:Nx+1,0:Ny-1,-1:Nz), intent(out) :: dout
    integer*8 :: i,k,k0,k1

    i=mod(irec,Nrecs)
    if (i .eq. 0) then
        i=Nrecs
    endif
    i=(i-1)*Nz+1
    k0=max(minval(floor(xyz(:,3,:)))-1,0)
    k1=min(maxval(ceiling(xyz(:,3,:)))+1,Nz-1)
!$OMP PARALLEL DO PRIVATE(k)
    do k=k0,k1
        read(fn_id,rec=i+k) dout(0:Nx-1,:,k)
        dout(Nx:Nx+1,:,k)=dout(0:1,:,k)
        dout(-2:-1,:,k)=dout(Nx-2:Nx-1,:,k)
    enddo
!$OMP END PARALLEL DO
end subroutine load_3d

subroutine load_uvwtsg(irec,isw)
    use global, only : fn_uvwtsg_ids,Nx,Ny,Nz,uu,vv,ww,theta,gam,salt,Nrecs
    implicit none
    INTEGER*8, intent(in) :: irec,isw
    !real*4, dimension(-1:Nx+1,0:Ny-1,-1:Nz) :: tmp
    integer*8 :: i
    i=mod(irec,Nrecs)
    if (i .eq. 0) then
        i=Nrecs
    endif
!$OMP PARALLEL SECTIONS
!$OMP SECTION
    call load_3d(fn_uvwtsg_ids(1),irec,uu(:,:,:,isw))
    uu(:,:,-1,isw)=uu(:,:,0,isw)
    uu(:,:,Nz,isw)=uu(:,:,Nz-1,isw)
    print*, "====>> load UVEL", irec, "min() =", minval(uu(:,:,:,isw))
!$OMP SECTION
    call load_3d(fn_uvwtsg_ids(2),irec,vv(:,:,:,isw))

    vv(:,:,-1,isw)=vv(:,:,0,isw)
    vv(:,:,Nz,isw)=vv(:,:,Nz-1,isw)
    print*, "====>> load VVEL", irec, "min() =", minval(vv(:,:,:,isw))
!$OMP SECTION
    call load_3d(fn_uvwtsg_ids(3),irec,ww(:,:,:,isw))
   
    ww(:,:,-1,isw)=0d0 !reflective surface ghost cell 
    ww(:,:,Nz,isw)=0d0 !reflective bottom  ghost cell

    print*, "====>> load WVEL", irec, "min() =", minval(ww(:,:,:,isw))

!$OMP SECTION
    call load_3d(fn_uvwtsg_ids(4),irec,theta(:,:,:,isw))
    theta(:,:,-1,isw)=theta(:,:,0,isw)
    theta(:,:,Nz,isw)=theta(:,:,Nz-1,isw)
    print*, "====>> load THETA", irec, "min() =", minval(theta(:,:,:,isw)),maxval(theta(:,:,:,isw))

!$OMP SECTION
    call load_3d(fn_uvwtsg_ids(5),irec,salt(:,:,:,isw))

    salt(:,:,-1,isw)=salt(:,:,0,isw)
    salt(:,:,Nz,isw)=salt(:,:,Nz-1,isw)

    print*, "====>> load SALT", irec, "min() =", minval(salt(:,:,:,isw))
!$OMP SECTION
    call load_3d(fn_uvwtsg_ids(6),irec,gam(:,:,:,isw))

    gam(:,:,-1,isw)=gam(:,:,0,isw)
    gam(:,:,Nz,isw)=gam(:,:,Nz-1,isw)

    where(gam(:,:,:,isw)<20) gam(:,:,:,isw)=0d0
    print*, "====>> load GAMMA", irec, "min() =", minval(gam(:,:,:,isw))
!$OMP END PARALLEL SECTIONS

    print*, "end loading data"
end subroutine load_uvwtsg


subroutine load_grid()

    use global, only : dxg_r,dyg_r,drf_r,Nx,Ny,Nz,hFacC,path2uvw!,hFacS,hFacW
    
    implicit none
    real*4 :: tmp(0:Nx-1,0:Ny-1),tmp1(0:Nz-1)

    print*, '11'
    print*, "================================================="
    print*, "loading grid ......... "

    open(91,file=trim(path2uvw)//'dxg.bin',&
        form='unformatted',access='direct',convert='BIG_ENDIAN',&
        status='old',recl=4*Nx*Ny)
    read(91,rec=1) tmp
    dxg_r(0:Nx-1,0:Ny-1)=real(tmp,8)
    dxg_r(Nx:Nx+1,:)=dxg_r(0:1,:)
    dxg_r(-2:-1,:)=dxg_r(Nx-2:Nx-1,:)
    dxg_r = 1.0/dxg_r
    close(91)

    open(92,file=trim(path2uvw)//'dyg.bin',&
        form='unformatted',access='direct',convert='BIG_ENDIAN',&
        status='old',recl=4*Nx*Ny)
    read(92,rec=1) tmp
    dyg_r(0:Nx-1,0:Ny-1)=real(tmp,8)
    dyg_r(Nx:Nx+1,:)=dyg_r(0:1,:)
    dyg_r(-2:-1,:)=dyg_r(Nx-2:Nx-1,:)
    dyg_r = 1.0/dyg_r
    close(92)

    open(93,file=trim(path2uvw)//'drf.bin',&
        form='unformatted',access='direct',convert='BIG_ENDIAN',&
        status='old',recl=4*Nz)
    read(93,rec=1) tmp1
    drf_r(0:Nz-1)=real(tmp1,8)
    drf_r(-1)=drf_r(0)
    drf_r(Nz)=drf_r(Nz-1)
    drf_r = 1.0/drf_r
    close(93)
    print*, '11'
    open(94,file=trim(path2uvw)//'hFacC.bin',&
        form='unformatted',access='direct',convert='BIG_ENDIAN',&
        status='old',recl=4*Nz*Ny*Nx)
    read(94,rec=1) hFacC(0:Nx-1,0:Ny-1,0:Nz-1)
    hFacC(Nx:Nx+1,:,:)=hFacC(0:1,:,:)
    hFacC(-2:-1,:,:)=hFacC(Nx-2:Nx-1,:,:)
    hFacC(:,:,-1)=hFacC(:,:,0)
    hFacC(:,:,Nz)=0d0
    close(94)
!
!    open(4,file='hFacS.bin',&
!        form='unformatted',access='direct',convert='BIG_ENDIAN',&
!        status='old',recl=4*Nz*Ny*Nx)
!    read(4,rec=1) hFacS(0:Nx-1,:,0:Nz-1)
!    hFacS(Nx:Nx+1,:,:)=hFacS(0:1,:,:)
!    hFacS(-1,:,:)=hFacS(Nx-1,:,:)
!    hFacS(:,:,-1)=hFacS(:,:,0)
!    close(4)

!    open(4,file='hFacW.bin',&
!        form='unformatted',access='direct',convert='BIG_ENDIAN',&
!        status='old',recl=4*Nz*Ny*Nx)
!   read(4,rec=1) hFacW(0:Nx-1,:,0:Nz-1)
!    hFacW(Nx:Nx+1,:,:)=hFacW(0:1,:,:)
!    hFacW(-1,:,:)=hFacW(Nx-1,:,:)
!    hFacW(:,:,-1)=hFacW(:,:,0)
!    close(4)

end subroutine load_grid



