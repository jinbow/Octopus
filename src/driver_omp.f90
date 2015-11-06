program main
    !#include "cppdefs.f90"
    use global
    use omp_lib

    implicit none
    integer*8 :: n_threads=16
    integer*8 :: i,IPP
    !integer*8, dimension(2) :: ipts
    character(len=10)     :: date,time0,time1,zone
    integer*8,dimension(8):: time
    integer*8 :: count_step=0

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
   

    ! call open_files()
    ! initilize particles on neutral density surfaces
    print*, "================================================="
    print*, "initializing particles ......... "

    do IPP = 1, NPP
        call init_particles(IPP)
    enddo
        call load_uvw(rec_num,0)
        call load_uvw(rec_num+1,1)
        iswitch=1

    call check_and_save(NPP)

    do while (tt<=tend)
        SNPP = min(int(tt/dt_case)+1,NPP)
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
            do IPP=1,SNPP
                call jump(IPP)
            enddo
            iswitch=1
        else
            rec_num=rec_num+1
            iswitch=abs(iswitch-1)
            print*, iswitch
            call load_uvw(rec_num,iswitch)
        endif
#ifndef isArgo
        if (mod(count_step,int(saveFreq,8)) .eq. 0) then
        call check_and_save(SNPP)
        endif
#endif
    enddo
    CALL DATE_AND_TIME(date,time1,zone,time)
    print*, "Program started at", time0, "and ended ", time1
    call close_files()

end program main

