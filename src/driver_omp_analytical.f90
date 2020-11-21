program main

#include "cpp_options.h"
    use global
    use omp_lib

    implicit none
    integer*8 :: n_threads=1
    integer*8 :: i,IPP
    character(len=10)     :: date,time0,time1,zone
    character(len=6)     :: id_str,IPP_str
    character(len=255)     :: glider_fn,argo_fn
    integer*8,dimension(8):: time

    CALL DATE_AND_TIME(date,time0,zone,time)

    call omp_set_num_threads(n_threads)
    call read_namelist()

    call allocate_parti()

    call calc_parameters()
  
    ! initilize particles on neutral density surfaces
    print*, "================================================="
    print*, "initializing particles ......... "

    do IPP = 1, NPP
        call init_particles(IPP)
    enddo


    do while (tt<=tend)
    print*, "tt,tend =====",tt,tend,xyz(1,1,1)
        SNPP = min(int(tt/dt_case)+1,NPP)

            dtp = real(mod(tt,dt_file))/real(dt_file)
            call rk4(SNPP)
            tt=tt+dt
            count_step=count_step+1
            call check_and_save(SNPP)
    enddo


    CALL DATE_AND_TIME(date,time1,zone,time)
    print*, "Program started at", time0, "and ended ", time1
    !call close_files()

end program main

