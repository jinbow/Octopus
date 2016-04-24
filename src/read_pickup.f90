subroutine read_pickup()
#include "cpp_options.h"
    use global, only: casename,xyz,tsg,tt,pickup,rec_num,iswitch,output_dir,marker
    implicit none
    character(len=128) :: fn

    write(fn,"(I10.10)") int(pickup)
    fn=trim(output_dir)//trim(casename)//'.pickup.'//trim(fn)//'.data'
    open(10,file=trim(fn),form='unformatted',&
        access='stream',convert='BIG_ENDIAN',status='old')


    read(10) xyz,tsg,tt,iswitch,rec_num,marker

#ifdef monitoring
    print*, "========================================="
    print*, "pickup data from "//fn
    print*, 'data in pickup file marker, rec_num iswitch,tt',marker,rec_num,iswitch,tt
    print*, 'in the pickup file, (min,max xyz), (min max tsg), ', xyz(1,:,1)
#endif

    close(10)

end subroutine read_pickup
