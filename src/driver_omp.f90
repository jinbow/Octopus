program main

#include "cpp_options.h"
    use global
    use omp_lib

    implicit none
    integer*8 :: n_threads=1
    integer*8 :: i,IPP
    character(len=10)     :: date,time0,time1,zone
    integer*8,dimension(8):: time

    CALL DATE_AND_TIME(date,time0,zone,time)

    call omp_set_num_threads(n_threads)
    call read_namelist()

    call allocate_parti()

    call calc_parameters()
  
    call open_files()

    ! load z to k lookup table for mixed layer process
    call load_z_lookup_table() 
   
    call load_grid()
   
    call load_reflect()
   

    ! initilize particles on neutral density surfaces
    print*, "================================================="
    print*, "initializing particles ......... "

    do IPP = 1, NPP
        call init_particles(IPP)
    enddo

    if (pickup>0) then
        call read_pickup()
        call load_uvw(marker(1),marker(2))
        call load_uvw(marker(1)+1,abs(1-marker(2)))
    else
        iswitch=1
        call check_and_save(NPP)
        call load_uvw(1,0)
        call load_uvw(2,1)
    endif

    do while (tt<=tend)
    print*, "=========================================================="
        SNPP = min(int(tt/dt_case)+1,NPP)
    print*, "SNPP = ", SNPP
        if ( mod(tt,dt_case)==0 .and. int(tt/dt_case,8)+1<=NPP) then
            call init_particles(SNPP)
        endif

        do i=1,int(dt_file/dt)
            !CALL DATE_AND_TIME(date,time,zone,time0)
            dtp = real(mod(tt,dt_file))/real(dt_file)
            call rk4(SNPP)
            tt=tt+dt
            count_step=count_step+1
        enddo

        if (mod(rec_num,Nrecs)==0) then
            call load_uvw(1,0)
            call load_uvw(2,1)
            rec_num=rec_num+2
            marker(1:2)=(/2,1/)
#ifndef isArgo
#ifdef jump_looping
            do IPP=1,SNPP
                call jump(IPP)
            enddo
#endif
#endif
            iswitch=1
        else
            rec_num=rec_num+1
            iswitch=abs(iswitch-1)
            call load_uvw(rec_num,iswitch)
            marker(1:2)=(/rec_num,iswitch/)
        endif
#ifndef isArgo
        if (mod(int(tt),int(saveFreq,8)) .eq. 0) then
            call check_and_save(SNPP)
        endif
        if (mod(int(tt),int(pickupFreq,8)) .eq. 0) then
            call save_pickup()
        endif
#endif
    enddo
    CALL DATE_AND_TIME(date,time1,zone,time)
    print*, "Program started at", time0, "and ended ", time1
    call close_files()

end program main

