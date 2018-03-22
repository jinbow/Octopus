SUBROUTINE open_files()
#include "cpp_options.h"

  USE global,ONLY:fn_uvwtsg_ids,fn_ids,fn_id_mld,path2uvw,fn_UVEL,&
       fn_VVEL,fn_WVEL,fn_THETA,fn_SALT,fn_GAMMA,fn_PHIHYD,&
#ifdef isArgo
  save_argo_FnID,&
#endif
        Nx,Ny,Nz,fn_MLD,casename,output_dir

  IMPLICIT NONE
  INTEGER*8 :: i
  CHARACTER(len=6) :: fnip
  CHARACTER(len=3) :: fnipp

#ifndef one_file_per_step

  OPEN(fn_uvwtsg_ids(1),file=TRIM(path2uvw)//TRIM(fn_UVEL),&
       form='unformatted',access='direct',convert='BIG_ENDIAN',&
       status='old',recl=4*Nx*Ny)
  OPEN(fn_uvwtsg_ids(2),file=TRIM(path2uvw)//TRIM(fn_VVEL),&
       form='unformatted',access='direct',convert='BIG_ENDIAN',&
       status='old',recl=4*Nx*Ny)


  OPEN(fn_uvwtsg_ids(3),file=TRIM(path2uvw)//TRIM(fn_WVEL),&
       form='unformatted',access='direct',convert='BIG_ENDIAN',&
       status='old',recl=4*Nx*Ny)



  IF (TRIM(fn_PHIHYD) .NE. '') THEN
     OPEN(fn_uvwtsg_ids(7),file=TRIM(path2uvw)//TRIM(fn_PHIHYD),&
          form='unformatted',access='direct',convert='BIG_ENDIAN',&
          status='old',recl=4*Nx*Ny)
  ENDIF

  OPEN(fn_uvwtsg_ids(4),file=TRIM(path2uvw)//TRIM(fn_THETA),&
       form='unformatted',access='direct',convert='BIG_ENDIAN',&
       status='old',recl=4*Nx*Ny)
  OPEN(fn_uvwtsg_ids(5),file=TRIM(path2uvw)//TRIM(fn_SALT),&
       form='unformatted',access='direct',convert='BIG_ENDIAN',&
       status='old',recl=4*Nx*Ny)
  IF (TRIM(fn_GAMMA) .NE. '') THEN
     OPEN(fn_uvwtsg_ids(6),file=TRIM(path2uvw)//TRIM(fn_GAMMA),&
          form='unformatted',access='direct',convert='BIG_ENDIAN',&
          status='old',recl=4*Nx*Ny)
  ENDIF


#ifdef use_mixedlayer_shuffle
  OPEN(fn_id_mld,file=TRIM(path2uvw)//TRIM(fn_MLD),&
       form='unformatted',access='direct',convert='BIG_ENDIAN',&
       status='old',recl=4*Nx*Ny)
#endif

#endif


#ifdef isArgo
  save_argo_FnID=1111
  open(save_argo_FnID,file=TRIM(output_dir)//'/'//TRIM(casename)//'.argo.surface.XYZ.data',&
       form='formatted',access='append',status='new')
#endif


END SUBROUTINE open_files
