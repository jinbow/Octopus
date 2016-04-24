subroutine save_pickup()
#include "cpp_options.h"
    use global, only: casename,tt,DumpClock,tsg,xyz,iswitch,rec_num,output_dir,marker
    implicit none
    character(len=64) :: fn

    write(fn,"(I10.10)") int(tt/DumpClock)+1
    open(0,file=trim(output_dir)//trim(casename)//'.pickup.'//trim(fn)//'.data',form='unformatted',&
        access='stream',convert='BIG_ENDIAN',status='replace')
    write(0) xyz,tsg,tt,iswitch,rec_num,marker

#ifdef monitoring
    print*, "save data from pickup file ",fn
    print*, 'data saved marker, rec_num iswitch,tt',marker,rec_num,iswitch,tt
    print*, 'in the pickup file, (min,max xyz), (min max tsg), ', xyz(1,:,1)
#endif

    close(0)
end subroutine save_pickup
