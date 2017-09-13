subroutine load_z_lookup_table()
#include "cpp_options.h"

#ifdef use_mixedlayer_shuffle
    use global, only: z2k,k2z,path2uvw
    implicit none
    real*4::tmp(5701),tmp1(0:420)
    open(63,file='../data/z_to_k_lookup_table.bin',&
        form='unformatted',access='direct',convert='BIG_ENDIAN',&
        status='old',recl=4*5701)
    read(63,rec=1) tmp
    z2k=real(tmp,8)
    close(63)

    open(64,file='../data/k_to_z_lookup_table.bin',&
        form='unformatted',access='direct',convert='BIG_ENDIAN',&
        status='old',recl=4*421)
    read(64,rec=1) tmp1
    k2z=real(tmp1,8)
    close(64)
#endif

end subroutine load_z_lookup_table

subroutine load_mld(tt)
#include "cpp_options.h"
#ifdef use_mixedlayer_shuffle
    use global, only: Nx,Ny,dt_mld,tend_file,fn_id_mld,mld
    real*8, intent(in) :: tt
    integer*8 :: i
    
    open(fn_id_mld,file=trim(path2uvw)//trim(fn_MLD),&
        form='unformatted',access='direct',convert='BIG_ENDIAN',&
        status='old',recl=4*Nx*Ny)

    i=int(mod(tt,tend_file)/dt_mld)+1
    print*, "load mixed layer depth data at time ",tt, "and step", i
    read(fn_id_mld,rec=i) mld(0:Nx-1,0:Ny-1)

    mld(-2:-1,:) = mld(Nx-2:Nx-1,:)
    mld(Nx:Nx+1,:)=mld(0:1,:)

    close(fn_id_mld)

#endif

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


subroutine load_3d(fn_id,irec,dout,read_flag)
#include "cpp_options.h"

    use global, only : Nx,Ny,Nz,Nrecs,xyz
    implicit none
    INTEGER*8, intent(in) :: irec,fn_id,read_flag
    real*4, dimension(-2:Nx+1,0:Ny-1,-1:Nz), intent(out) :: dout
    integer*8 :: i=0,k=0,k0=0,k1=0

    i=mod(irec,Nrecs)
    if (i .eq. 0) then
        i=Nrecs
    endif

    i=(i-1)*Nz+1
    !selectively reading data from k0 to k1 levels
    if (read_flag==1) then
      k0=max(minval(floor(xyz(:,3,:)))-1,0)
      k1=min(maxval(ceiling(xyz(:,3,:)))+1,Nz-1)
    else
      k0=0
      k1=Nz-1
    endif

    !$OMP PARALLEL DO PRIVATE(k)
    !do k=k0,k1
    do k=0,Nz-1
        read(fn_id,rec=i+k) dout(0:Nx-1,:,k)
        dout(Nx:Nx+1,:,k)=dout(0:1,:,k)
        dout(-2:-1,:,k)=dout(Nx-2:Nx-1,:,k)
    enddo
!$OMP END PARALLEL DO
end subroutine load_3d

subroutine load_uvw(irec,isw)

    use global, only : fn_uvwtsg_ids,Nx,Ny,Nz,uu,vv,ww,theta,gam,salt,Nrecs,&
                       fn_UVEL,fn_VVEL,fn_WVEL,path2uvw,filenames
    implicit none
    INTEGER*8, intent(in) :: irec,isw
    !real*4, dimension(-1:Nx+1,0:Ny-1,-1:Nz) :: tmp
    integer*8 :: i,ifile,ii,read_flag

    read_flag=1 ! 1--> read all vertical levels, selective otherwise

#ifdef monitoring
    print*, "----load uvw at irec,mod(irec,Nrecs),iswitch",irec,i,isw
#endif


#ifdef one_file_per_step
    ifile=mod(irec,Nrecs) !gives the index of the filename
    if (ifile .eq. 0) then
        ifile=Nrecs
    endif
    i=1 !always read the first record if the file only contains one step
#else

#ifdef stationary_velocity
    i=1
#else
    i=mod(irec,Nrecs)
    if (i .eq. 0) then
        i=Nrecs
    endif
#endif

    ifile=1 !if all records are saved in one file, the program always reads filename(1,i)

#endif

    !$OMP PARALLEL SECTIONS
    !$OMP SECTION

#ifdef monitoring
    print*, ifile,trim(path2uvw)//trim(filenames(ifile,1))
#endif

do ii = 1, 3
open(fn_uvwtsg_ids(ii),file=trim(path2uvw)//trim(filenames(ifile,ii)),&
        form='unformatted',access='direct',convert='BIG_ENDIAN',&
        status='old',recl=4*Nx*Ny)
enddo


    call load_3d(fn_uvwtsg_ids(1),i,uu(:,0:Ny-1,:,isw),read_flag)
    uu(:,:,-1,isw)=uu(:,:,0,isw)
    uu(:,:,Nz,isw)=uu(:,:,Nz-1,isw)

    !$OMP SECTION
    call load_3d(fn_uvwtsg_ids(2),i,vv(:,0:Ny-1,:,isw),read_flag)
    vv(:,:,-1,isw)=vv(:,:,0,isw)
    vv(:,:,Nz,isw)=vv(:,:,Nz-1,isw)
#ifdef reflective_meridional_boundary
    vv(:,Ny:Ny+1,:,isw) = -1d0
    vv(:,-2:-1,:,isw) = 1d0
#endif
    !$OMP SECTION
#ifndef isArgo
    call load_3d(fn_uvwtsg_ids(3),i,ww(:,0:Ny-1,:,isw),read_flag)
    ww(:,:,-1,isw)=-1d-5 !reflective surface ghost cell 
    ww(:,:,Nz,isw)=1d-5 !reflective bottom  ghost cell
#endif

#ifdef monitoring
    print*, "====>> load VVEL", irec, "min() =", minval(vv(:,:,:,isw))
    print*, "====>> load VVEL", irec, "max() =", maxval(vv(:,:,:,isw))
    print*, "====>> load UVEL", irec, "min() =", minval(uu(:,:,:,isw))
    print*, "====>> load UVEL", irec, "max() =", maxval(uu(:,:,:,isw))
    print*, "====>> load WVEL", irec, "min() =", minval(ww(:,:,:,isw))
    print*, "====>> load WVEL", irec, "max() =", maxval(ww(:,:,:,isw))
#endif

    !$OMP END PARALLEL SECTIONS

    do ii = 1, 3
        close(fn_uvwtsg_ids(ii))
    enddo

end subroutine load_uvw


subroutine load_tsg(irec,isw)
#include "cpp_options.h"

#ifdef saveTSG
#ifndef isArgo

use global, only : fn_uvwtsg_ids,Nx,Ny,Nz,uu,path2uvw,filenames,&
	           vv,ww,theta,gam,salt,Nrecs

    implicit none
    INTEGER*8, intent(in) :: irec,isw
    !real*4, dimension(-1:Nx+1,0:Ny-1,-1:Nz) :: tmp
    integer*8 :: i,ifile,ii,read_flag

    read_flag=1  !  1 : read all vertical levels, selective otherwise

#ifdef one_file_per_step
    ifile=mod(irec,Nrecs)
    if (ifile .eq. 0) then
        ifile=Nrecs
    endif
    i=1 !always read the first record if the file only contains one step
#else
    i=mod(irec,Nrecs)
    if (i .eq. 0) then
        i=Nrecs
    endif
    ifile=1
#endif

do ii = 4, 5
open(fn_uvwtsg_ids(ii),file=trim(path2uvw)//trim(filenames(ifile,ii)),&
        form='unformatted',access='direct',convert='BIG_ENDIAN',&
        status='old',recl=4*Nx*Ny)
enddo

    !$OMP PARALLEL SECTIONS
    !$OMP SECTION
    call load_3d(fn_uvwtsg_ids(4),i,theta(:,:,:,isw),read_flag)
    theta(:,:,-1,isw)=theta(:,:,0,isw)
    theta(:,:,Nz,isw)=theta(:,:,Nz-1,isw)
    print*, "====>> load THETA", irec, "min() =", minval(theta(:,:,:,isw)),maxval(theta(:,:,:,isw))
    print*, theta(100,200,:,isw)

    !$OMP SECTION
    call load_3d(fn_uvwtsg_ids(5),i,salt(:,:,:,isw),read_flag)

    salt(:,:,-1,isw)=salt(:,:,0,isw)
    salt(:,:,Nz,isw)=salt(:,:,Nz-1,isw)

    print*, "====>> load SALT", i, "min() =", minval(salt(:,:,:,isw)),maxval(salt(:,:,:,isw))


#if instrument!=glider
    !$OMP SECTION
    call load_3d(fn_uvwtsg_ids(6),i,gam(:,:,:,isw),read_flag)

    gam(:,:,-1,isw)=gam(:,:,0,isw)
    gam(:,:,Nz,isw)=gam(:,:,Nz-1,isw)

    where(gam(:,:,:,isw)<20) gam(:,:,:,isw)=0d0
    print*, "====>> load GAMMA", irec, "min() =", minval(gam(:,:,:,isw))
#endif


    !$OMP END PARALLEL SECTIONS


    print*, "end loading data"

    do ii = 4, 6
        close(fn_uvwtsg_ids(ii))
    enddo

#endif
#endif


end subroutine load_tsg


subroutine load_grid()
#include "cpp_options.h"

    use global, only : dxg_r,dyg_r,drf_r,Nx,Ny,Nz,hFacC,path2grid!,hFacS,hFacW
    
    implicit none
    real*4 :: tmp(0:Nx-1,0:Ny-1),tmp1(0:Nz-1)

    print*, "================================================="
    print*, "loading grid ......... "

    open(91,file=trim(path2grid)//'DXG.data',&
        form='unformatted',access='direct',convert='BIG_ENDIAN',&
        status='old',recl=4*Nx*Ny)
    read(91,rec=1) tmp
    dxg_r(0:Nx-1,0:Ny-1)=real(tmp,8)
    dxg_r(Nx:Nx+1,:)=dxg_r(0:1,:)
    dxg_r(-2:-1,:)=dxg_r(Nx-2:Nx-1,:)
    dxg_r = 1.0/dxg_r
    close(91)

    open(92,file=trim(path2grid)//'DYG.data',&
        form='unformatted',access='direct',convert='BIG_ENDIAN',&
        status='old',recl=4*Nx*Ny)
    read(92,rec=1) tmp
    dyg_r(0:Nx-1,0:Ny-1)=real(tmp,8)
    dyg_r(Nx:Nx+1,:)=dyg_r(0:1,:)
    dyg_r(-2:-1,:)=dyg_r(Nx-2:Nx-1,:)
    dyg_r = 1.0/dyg_r
    close(92)

#ifdef MITgcm
    open(93,file=trim(path2grid)//'DRF.data',&
        form='unformatted',access='direct',convert='BIG_ENDIAN',&
        status='old',recl=4*Nz)
    read(93,rec=1) tmp1
    drf_r(0:Nz-1)=real(tmp1,8)
    drf_r(-1)=drf_r(0)
    drf_r(Nz)=drf_r(Nz-1)
    drf_r = 1.0/drf_r
    close(93)
#endif

#ifdef ROMS
    open(93,file=trim(path2grid)//'DRF.data',&
        form='unformatted',access='direct',convert='BIG_ENDIAN',&
        status='old',recl=4*Nz)
    read(93,rec=1) tmp1
    drf_r(0:Nz-1)=real(tmp1,8)
    drf_r(-1)=drf_r(0)
    drf_r(Nz)=drf_r(Nz-1)
    drf_r = 1.0/drf_r
    close(93)
#endif

#ifndef isArgo
    open(94,file=trim(path2grid)//'hFacC.data',&
        form='unformatted',access='direct',convert='BIG_ENDIAN',&
        status='old',recl=4*Nz*Ny*Nx)
    read(94,rec=1) hFacC(0:Nx-1,0:Ny-1,0:Nz-1)
    hFacC(Nx:Nx+1,:,:)=hFacC(0:1,:,:)
    hFacC(-2:-1,:,:)=hFacC(Nx-2:Nx-1,:,:)
    hFacC(:,:,-1)=hFacC(:,:,0)
    hFacC(:,:,Nz)=0d0
    close(94)
#endif

end subroutine load_grid

subroutine save_data(IPP)
#include "cpp_options.h"
    !output particle data
    use omp_lib
    use global

    implicit none
    character(len=128) :: fn
    character(len=16) :: fn1
    integer*8 :: iwrite
    integer*8,intent(in) :: IPP

    iwrite=int(tt/DumpClock)+1

    write(fn,"(I10.10)") iwrite
    write(fn1,"(I4.4)") IPP

    !$OMP PARALLEL SECTIONS

    !$OMP SECTION
    open(fn_ids(1,IPP),file=trim(output_dir)//'/'//trim(casename)//'_'//trim(fn1)//'.XYZ.'//trim(fn)//'.data',&
        access='direct',form='unformatted', convert='BIG_ENDIAN',recl=3*4*Npts,status='unknown')
    write(fn_ids(1,IPP),rec=1) real(xyz(:,:,IPP),4)
    close(fn_ids(1,IPP))

#ifdef saveTSG
    !$OMP SECTION
    open(fn_ids(2,IPP),file=trim(output_dir)//'/'//trim(casename)//'_'//trim(fn1)//'.TSG.'//trim(fn)//'.data',&
        access='direct',form='unformatted',convert='BIG_ENDIAN',recl=4*4*Npts,status='unknown')
    write(fn_ids(2,IPP),rec=1) real(tsg(:,:,IPP),4)
    close(fn_ids(2,IPP))

#endif

#ifdef use_mixedlayer_shuffle
    !$OMP SECTION
    open(fn_ids(3,IPP),file=trim(output_dir)//'/'//trim(casename)//'_'//trim(fn1)//'.MLD.'//trim(fn)//'.data',&
        access='direct',form='unformatted',convert='BIG_ENDIAN',recl=4*Npts,status='unknown')
    write(fn_ids(3,IPP),rec=1) real(parti_mld(:,IPP),4)
    close(fn_ids(3,IPP))
#endif

#ifdef saveGradient
    !$OMP SECTION
    open(fn_ids(4,IPP),file=trim(output_dir)//'/'//trim(casename)//'_'//trim(fn1)//'.GRAD.'//trim(fn)//'.data',&
        access='direct',form='unformatted', convert='BIG_ENDIAN',recl=5*4*Npts,status='unknown')
    write(fn_ids(4,IPP),rec=1) real(grad(:,:,IPP),4)
    close(fn_ids(4,IPP))
#endif
!$OMP END PARALLEL SECTIONS

end subroutine save_data


subroutine save_glider_data(SNPP)
#include "cpp_options.h"

#ifdef isGlider
    use global, only :tt,saveFreq,Npts,&
                      iswitch,count_step,&
                      save_glider_FnIDs,xyz,tsg,&
                      theta,

    implicit none
    INTEGER*8 :: i,IPP,t0,t1
    INTEGER*8, intent(in) :: SNPP

        t0=abs(iswitch-1)
        t1=iswitch

    if (mod(count_step,saveFreq) .eq. 0) then
        do IPP=1,SNPP
#ifdef saveTSG
            call interp_tracer(t0,t1,IPP)
#endif
           do i=1,Npts
              write(save_glider_FnIDs(i,IPP),"(5F9.5)") xyz(i,:,IPP),tsg(i,1:2,IPP)
              if (i==2) then
              write(*,"(6F9.3)") xyz(i,:,IPP),tsg(i,1:2,IPP),theta(i,floor(xyz(i,2,IPP)),floor(xyz(i,3,IPP)),0)
    endif
            enddo
        enddo
    endif

#endif

end subroutine save_glider_data
