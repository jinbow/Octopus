subroutine dump_data(IPP)
#include "cpp_options.h"
!output particle data
    use omp_lib
    use global, only: casename,tt,fn_ids,xyz,tsg,&
        Npts,parti_mld,DumpClock,&
        NPP,output_dir,grad
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
        access='direct',form='unformatted', convert='BIG_ENDIAN',recl=3*4*Npts,status='replace')
    write(fn_ids(1,IPP),rec=1) real(xyz(:,:,IPP),4)
    close(fn_ids(1,IPP))

#ifdef saveTSG
    !$OMP SECTION
        open(fn_ids(2,IPP),file=trim(output_dir)//'/'//trim(casename)//'_'//trim(fn1)//'.TSG.'//trim(fn)//'.data',&
            access='direct',form='unformatted',convert='BIG_ENDIAN',recl=4*4*Npts,status='replace')
        write(fn_ids(2,IPP),rec=1) real(tsg(:,:,IPP),4)
        close(fn_ids(2,IPP))

#endif

#ifdef useMLD
    !$OMP SECTION
        open(fn_ids(3,IPP),file=trim(output_dir)//'/'//trim(casename)//'_'//trim(fn1)//'.MLD.'//trim(fn)//'.data',&
            access='direct',form='unformatted',convert='BIG_ENDIAN',recl=4*Npts,status='replace')
        write(fn_ids(3,IPP),rec=1) real(parti_mld(:,IPP),4)
        close(fn_ids(3,IPP))
#endif

    !$OMP SECTION
    open(fn_ids(4,IPP),file=trim(output_dir)//'/'//trim(casename)//'_'//trim(fn1)//'.GRAD.'//trim(fn)//'.data',&
        access='direct',form='unformatted', convert='BIG_ENDIAN',recl=4*4*Npts,status='replace')
    write(fn_ids(4,IPP),rec=1) real(grad(:,:,IPP),4)
    close(fn_ids(4,IPP))

!$OMP END PARALLEL SECTIONS

end subroutine dump_data
