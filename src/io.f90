SUBROUTINE load_z_lookup_table()
#include "cpp_options.h"

#ifdef use_mixedlayer_shuffle
  USE global, ONLY: z2k,k2z,path2uvw
  IMPLICIT NONE
  REAL*4::tmp(5701),tmp1(0:420)
  OPEN(63,file='../data/z_to_k_lookup_table.bin',&
       form='unformatted',access='direct',convert='BIG_ENDIAN',&
       status='old',recl=4*5701)
  READ(63,rec=1) tmp
  z2k=REAL(tmp,8)
  CLOSE(63)

  OPEN(64,file='../data/k_to_z_lookup_table.bin',&
       form='unformatted',access='direct',convert='BIG_ENDIAN',&
       status='old',recl=4*421)
  READ(64,rec=1) tmp1
  k2z=REAL(tmp1,8)
  CLOSE(64)
#endif

END SUBROUTINE load_z_lookup_table

SUBROUTINE load_mld(tt)
#include "cpp_options.h"
#ifdef use_mixedlayer_shuffle
  USE global, ONLY: Nx,Ny,dt_mld,tend_file,fn_id_mld,mld
  REAL*8, INTENT(in) :: tt
  INTEGER*8 :: i

  OPEN(fn_id_mld,file=TRIM(path2uvw)//TRIM(fn_MLD),&
       form='unformatted',access='direct',convert='BIG_ENDIAN',&
       status='old',recl=4*Nx*Ny)

  i=INT(MOD(tt,tend_file)/dt_mld)+1
  PRINT*, "load mixed layer depth data at time ",tt, "and step", i
  READ(fn_id_mld,rec=i) mld(0:Nx-1,0:Ny-1)

  mld(-2:-1,:) = mld(Nx-2:Nx-1,:)
  mld(Nx:Nx+1,:)=mld(0:1,:)

  CLOSE(fn_id_mld)

#endif

END SUBROUTINE load_mld


SUBROUTINE load_PHIHYD(tt)

  USE global, ONLY: Nx,Ny,dt_mld,tend_file,fn_uvwtsg_ids,phihyd
  REAL*8, INTENT(in) :: tt
  INTEGER*8 :: i

  i=INT(MOD(tt,tend_file)/dt_mld)+1
  PRINT*, "load PHIHYD data at time ",tt, "and step", i
  READ(fn_uvwtsg_ids(7),rec=i) phihyd(0:Nx-1,0:Ny-1)

  phihyd(-2:-1,:) = phihyd(Nx-2:Nx-1,:)
  phihyd(Nx:Nx+1,:)=phihyd(0:1,:)

END SUBROUTINE load_PHIHYD


SUBROUTINE load_3d(fn_id,irec,dout,read_flag)
#include "cpp_options.h"

  USE global, ONLY : Nx,Ny,Nz,Nrecs,xyz
  IMPLICIT NONE
  INTEGER*8, INTENT(in) :: irec,fn_id,read_flag
  REAL*4, DIMENSION(-2:Nx+1,0:Ny-1,-1:Nz), INTENT(out) :: dout
  INTEGER*8 :: i=0,k=0,k0=0,k1=0

  i=MOD(irec,Nrecs)
  IF (i .EQ. 0) THEN
     i=Nrecs
  ENDIF

  i=(i-1)*Nz+1
  !selectively reading data from k0 to k1 levels
  IF (read_flag==1) THEN
     k0=MAX(MINVAL(FLOOR(xyz(:,3,:)))-1,0)
     k1=MIN(MAXVAL(CEILING(xyz(:,3,:)))+1,Nz-1)
  ELSE
     k0=0
     k1=Nz-1
  ENDIF

  !$OMP PARALLEL DO PRIVATE(k)
  !do k=k0,k1
  DO k=0,Nz-1
     READ(fn_id,rec=i+k) dout(0:Nx-1,:,k)
     dout(Nx:Nx+1,:,k)=dout(0:1,:,k)
     dout(-2:-1,:,k)=dout(Nx-2:Nx-1,:,k)
  ENDDO
  !$OMP END PARALLEL DO
END SUBROUTINE load_3d

SUBROUTINE load_uvw(irec,isw)

  USE global, ONLY : fn_uvwtsg_ids,Nx,Ny,Nz,uu,vv,ww,theta,gam,salt,Nrecs,&
       fn_UVEL,fn_VVEL,fn_WVEL,path2uvw,filenames
  IMPLICIT NONE
  INTEGER*8, INTENT(in) :: irec,isw
  !real*4, dimension(-1:Nx+1,0:Ny-1,-1:Nz) :: tmp
  INTEGER*8 :: i,ifile,ii,read_flag

  read_flag=1 ! 1--> read all vertical levels, selective otherwise

#ifdef monitoring
  PRINT*, "----load uvw at irec,mod(irec,Nrecs),iswitch",irec,i,isw
#endif


#ifdef one_file_per_step
  ifile=MOD(irec,Nrecs) !gives the index of the filename
  IF (ifile .EQ. 0) THEN
     ifile=Nrecs
  ENDIF
  i=1 !always read the first record if the file only contains one step
#else

#ifdef stationary_velocity
  i=1
#else
  i=MOD(irec,Nrecs)
  IF (i .EQ. 0) THEN
     i=Nrecs
  ENDIF
#endif

  ifile=1 !if all records are saved in one file, the program always reads filename(1,i)

#endif

  !$OMP PARALLEL SECTIONS
  !$OMP SECTION

#ifdef monitoring
  PRINT*, ifile,TRIM(path2uvw)//TRIM(filenames(ifile,1))
#endif

#ifdef isArgo
  DO ii = 1, 2
#else
  DO ii = 1, 3
#endif

     OPEN(fn_uvwtsg_ids(ii),file=TRIM(path2uvw)//TRIM(filenames(ifile,ii)),&
          form='unformatted',access='direct',convert='BIG_ENDIAN',&
          status='old',recl=4*Nx*Ny)
  ENDDO


  CALL load_3d(fn_uvwtsg_ids(1),i,uu(:,0:Ny-1,:,isw),read_flag)
  uu(:,:,-1,isw)=uu(:,:,0,isw)
  uu(:,:,Nz,isw)=uu(:,:,Nz-1,isw)

  !$OMP SECTION
  CALL load_3d(fn_uvwtsg_ids(2),i,vv(:,0:Ny-1,:,isw),read_flag)
  vv(:,:,-1,isw)=vv(:,:,0,isw)
  vv(:,:,Nz,isw)=vv(:,:,Nz-1,isw)
#ifdef reflective_meridional_boundary
  vv(:,Ny:Ny+1,:,isw) = -1d0
  vv(:,-2:-1,:,isw) = 1d0
#endif
  !$OMP SECTION
#ifndef isArgo
  CALL load_3d(fn_uvwtsg_ids(3),i,ww(:,0:Ny-1,:,isw),read_flag)
  ww(:,:,-1,isw)=-1d-5 !reflective surface ghost cell 
  ww(:,:,Nz,isw)=1d-5 !reflective bottom  ghost cell
#endif

#ifdef monitoring
  PRINT*, "====>> load VVEL", irec, "min() =", MINVAL(vv(:,:,:,isw))
  PRINT*, "====>> load VVEL", irec, "max() =", MAXVAL(vv(:,:,:,isw))
  PRINT*, "====>> load UVEL", irec, "min() =", MINVAL(uu(:,:,:,isw))
  PRINT*, "====>> load UVEL", irec, "max() =", MAXVAL(uu(:,:,:,isw))
  PRINT*, "====>> load WVEL", irec, "min() =", MINVAL(ww(:,:,:,isw))
  PRINT*, "====>> load WVEL", irec, "max() =", MAXVAL(ww(:,:,:,isw))
#endif

  !$OMP END PARALLEL SECTIONS

  DO ii = 1, 3
     CLOSE(fn_uvwtsg_ids(ii))
  ENDDO

END SUBROUTINE load_uvw


SUBROUTINE load_tsg(irec,isw)
#include "cpp_options.h"

#ifdef saveTSG
#ifndef isArgo

  USE global, ONLY : fn_uvwtsg_ids,Nx,Ny,Nz,uu,path2uvw,filenames,&
       vv,ww,theta,gam,salt,Nrecs

  IMPLICIT NONE
  INTEGER*8, INTENT(in) :: irec,isw
  !real*4, dimension(-1:Nx+1,0:Ny-1,-1:Nz) :: tmp
  INTEGER*8 :: i,ifile,ii,read_flag

  read_flag=1  !  1 : read all vertical levels, selective otherwise

#ifdef one_file_per_step
  ifile=MOD(irec,Nrecs)
  IF (ifile .EQ. 0) THEN
     ifile=Nrecs
  ENDIF
  i=1 !always read the first record if the file only contains one step
#else
  i=MOD(irec,Nrecs)
  IF (i .EQ. 0) THEN
     i=Nrecs
  ENDIF
  ifile=1
#endif

  DO ii = 4, 5
     OPEN(fn_uvwtsg_ids(ii),file=TRIM(path2uvw)//TRIM(filenames(ifile,ii)),&
          form='unformatted',access='direct',convert='BIG_ENDIAN',&
          status='old',recl=4*Nx*Ny)
  ENDDO

  !$OMP PARALLEL SECTIONS
  !$OMP SECTION
  CALL load_3d(fn_uvwtsg_ids(4),i,theta(:,:,:,isw),read_flag)
  theta(:,:,-1,isw)=theta(:,:,0,isw)
  theta(:,:,Nz,isw)=theta(:,:,Nz-1,isw)
  PRINT*, "====>> load THETA", irec, "min() =", MINVAL(theta(:,:,:,isw)),MAXVAL(theta(:,:,:,isw))

  !$OMP SECTION
  CALL load_3d(fn_uvwtsg_ids(5),i,salt(:,:,:,isw),read_flag)

  salt(:,:,-1,isw)=salt(:,:,0,isw)
  salt(:,:,Nz,isw)=salt(:,:,Nz-1,isw)

  PRINT*, "====>> load SALT", i, "min() =", MINVAL(salt(:,:,:,isw)),MAXVAL(salt(:,:,:,isw))


#ifndef isGlider
  !$OMP SECTION
  CALL load_3d(fn_uvwtsg_ids(6),i,gam(:,:,:,isw),read_flag)

  gam(:,:,-1,isw)=gam(:,:,0,isw)
  gam(:,:,Nz,isw)=gam(:,:,Nz-1,isw)

  WHERE(gam(:,:,:,isw)<20) gam(:,:,:,isw)=0d0
  PRINT*, "====>> load GAMMA", irec, "min() =", MINVAL(gam(:,:,:,isw))
#endif


  !$OMP END PARALLEL SECTIONS


  PRINT*, "end loading data"

  DO ii = 4, 6
     CLOSE(fn_uvwtsg_ids(ii))
  ENDDO

#endif
#endif


END SUBROUTINE load_tsg


SUBROUTINE load_grid()
#include "cpp_options.h"

  USE global, ONLY : dxg_r,dyg_r,drf_r,Nx,Ny,Nz,hFacC,path2grid!,hFacS,hFacW

  IMPLICIT NONE
  REAL*4 :: tmp(0:Nx-1,0:Ny-1),tmp1(0:Nz-1)

  PRINT*, "================================================="
  PRINT*, "loading grid ......... "

  OPEN(91,file=TRIM(path2grid)//'DXG.data',&
       form='unformatted',access='direct',convert='BIG_ENDIAN',&
       status='old',recl=4*Nx*Ny)
  READ(91,rec=1) tmp
  dxg_r(0:Nx-1,0:Ny-1)=REAL(tmp,8)
  dxg_r(Nx:Nx+1,:)=dxg_r(0:1,:)
  dxg_r(-2:-1,:)=dxg_r(Nx-2:Nx-1,:)
  dxg_r = 1.0/dxg_r
  CLOSE(91)

  OPEN(92,file=TRIM(path2grid)//'DYG.data',&
       form='unformatted',access='direct',convert='BIG_ENDIAN',&
       status='old',recl=4*Nx*Ny)
  READ(92,rec=1) tmp
  dyg_r(0:Nx-1,0:Ny-1)=REAL(tmp,8)
  dyg_r(Nx:Nx+1,:)=dyg_r(0:1,:)
  dyg_r(-2:-1,:)=dyg_r(Nx-2:Nx-1,:)
  dyg_r = 1.0/dyg_r
  CLOSE(92)

  OPEN(93,file=TRIM(path2grid)//'DRF.data',&
       form='unformatted',access='direct',convert='BIG_ENDIAN',&
       status='old',recl=4*Nz)
  READ(93,rec=1) tmp1
  drf_r(0:Nz-1)=REAL(tmp1,8)
  drf_r(-1)=drf_r(0)
  drf_r(Nz)=drf_r(Nz-1)
  drf_r = 1.0/drf_r
  CLOSE(93)

#ifndef isArgo
  OPEN(94,file=TRIM(path2grid)//'hFacC.data',&
       form='unformatted',access='direct',convert='BIG_ENDIAN',&
       status='old',recl=4*Nz*Ny*Nx)
  READ(94,rec=1) hFacC(0:Nx-1,0:Ny-1,0:Nz-1)
  hFacC(Nx:Nx+1,:,:)=hFacC(0:1,:,:)
  hFacC(-2:-1,:,:)=hFacC(Nx-2:Nx-1,:,:)
  hFacC(:,:,-1)=hFacC(:,:,0)
  hFacC(:,:,Nz)=0d0
  CLOSE(94)
#endif

END SUBROUTINE load_grid


SUBROUTINE save_data(IPP)
#include "cpp_options.h"
  !output particle data
  USE omp_lib
  USE global

  IMPLICIT NONE
  CHARACTER(len=128) :: fn
  CHARACTER(len=16) :: fn1
  INTEGER*8 :: iwrite
  INTEGER*8,INTENT(in) :: IPP

  iwrite=INT(tt/DumpClock)+1

  WRITE(fn,"(I10.10)") iwrite
  WRITE(fn1,"(I4.4)") IPP

  !$OMP PARALLEL SECTIONS

  !$OMP SECTION
  OPEN(fn_ids(1,IPP),file=TRIM(output_dir)//'/'//TRIM(casename)//'_'//TRIM(fn1)//'.XYZ.'//TRIM(fn)//'.data',&
       access='direct',form='unformatted', convert='BIG_ENDIAN',recl=3*4*Npts,status='unknown')
  WRITE(fn_ids(1,IPP),rec=1) REAL(xyz(:,:,IPP),4)
  CLOSE(fn_ids(1,IPP))

#ifdef saveTSG
  !$OMP SECTION
  OPEN(fn_ids(2,IPP),file=TRIM(output_dir)//'/'//TRIM(casename)//'_'//TRIM(fn1)//'.TSG.'//TRIM(fn)//'.data',&
       access='direct',form='unformatted',convert='BIG_ENDIAN',recl=4*4*Npts,status='unknown')
  WRITE(fn_ids(2,IPP),rec=1) REAL(tsg(:,:,IPP),4)
  CLOSE(fn_ids(2,IPP))

#endif

#ifdef use_mixedlayer_shuffle
  !$OMP SECTION
  OPEN(fn_ids(3,IPP),file=TRIM(output_dir)//'/'//TRIM(casename)//'_'//TRIM(fn1)//'.MLD.'//TRIM(fn)//'.data',&
       access='direct',form='unformatted',convert='BIG_ENDIAN',recl=4*Npts,status='unknown')
  WRITE(fn_ids(3,IPP),rec=1) REAL(parti_mld(:,IPP),4)
  CLOSE(fn_ids(3,IPP))
#endif

#ifdef saveGradient
  !$OMP SECTION
  OPEN(fn_ids(4,IPP),file=TRIM(output_dir)//'/'//TRIM(casename)//'_'//TRIM(fn1)//'.GRAD.'//TRIM(fn)//'.data',&
       access='direct',form='unformatted', convert='BIG_ENDIAN',recl=5*4*Npts,status='unknown')
  WRITE(fn_ids(4,IPP),rec=1) REAL(grad(:,:,IPP),4)
  CLOSE(fn_ids(4,IPP))
#endif
  !$OMP END PARALLEL SECTIONS

END SUBROUTINE save_data


SUBROUTINE save_glider_data(SNPP)
#include "cpp_options.h"
#ifdef isGlider
  USE global, ONLY :tt,saveFreq,Npts,&
       iswitch,count_step,&
       save_glider_FnIDs,glider_uv,glider_angle,&
       xyz,uvwp,tsg,theta

  IMPLICIT NONE
  INTEGER*8 :: i,IPP,t0,t1
  INTEGER*8, INTENT(in) :: SNPP

  t0=ABS(iswitch-1)
  t1=iswitch

  IF (MOD(count_step,saveFreq) .EQ. 0) THEN
     DO IPP=1,SNPP
#ifdef saveTSG
        CALL interp_tracer(t0,t1,IPP)
#endif
        DO i=1,Npts
           WRITE(save_glider_FnIDs(i,IPP),"(11F13.5)") tt, xyz(i,:,IPP),&
                tsg(i,1:2,IPP),uvwp(i,1:2,IPP),glider_uv(i,:,IPP),&
                glider_angle(i,IPP)
           !  if (i==2) then
           !  write(*,"(6F9.3)") xyz(i,:,IPP),tsg(i,1:2,IPP),theta(i,floor(xyz(i,2,IPP)),floor(xyz(i,3,IPP)),0)
           !  endif
        ENDDO
     ENDDO
  ENDIF

#endif
END SUBROUTINE save_glider_data
