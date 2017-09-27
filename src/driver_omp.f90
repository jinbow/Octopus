program main

#include "cpp_options.h"
    use global
    use omp_lib

    implicit none
    integer*8 :: n_threads=1
    integer*8 :: i,IPP
    character(len=10)     :: date,time0,time1,zone
    character(len=6)     :: id_str,IPP_str
    character(len=255)     :: glider_fn
    integer*8,dimension(8):: time

    CALL DATE_AND_TIME(date,time0,zone,time)

    call omp_set_num_threads(n_threads)
    call read_namelist()

    call allocate_parti()

    call calc_parameters()
  
    call c_filenames()
   
    ! load z to k lookup table for mixed layer process
    call load_z_lookup_table() 
   
    call load_grid()
   
    print*, "finish initialization"
#ifndef isArgo
    call load_reflect()
#endif
   
    ! initilize particles on neutral density surfaces
    print*, "================================================="
    print*, "initializing particles ......... "

    do IPP = 1, NPP
        call init_particles(IPP)

#ifdef isGlider
       do i=1,Npts
            write(id_str,"(I6.6)") i
            write(IPP_str,"(I6.6)") IPP
            glider_fn=trim(output_dir)//"G.IPP."//IPP_str//".ip."//id_str//".cycle.000000.data"
            open(save_glider_FnIDs(i,IPP),file=trim(glider_fn),&
                form='formatted',access='append',&
                status='new')
      enddo
#endif

    enddo

    if (pickup>0) then
        call read_pickup()
        call load_uvw(marker(1),marker(2))
        call load_uvw(marker(1)+1,abs(1-marker(2)))
    else
        iswitch=1

#ifdef isGider
           call save_glider_data(NPP)
#else
            call check_and_save(NPP)
#endif

        call load_uvw(1,0)
        call load_uvw(2,1)

#ifdef saveTSG
       call load_tsg(1,0)
       call load_tsg(2,1)
       call get_roms_depth(real(zeta,8))
#endif

    endif
        
    do while (tt<=tend)

        SNPP = min(int(tt/dt_case)+1,NPP)

        do i=1,int(dt_file/dt)
            dtp = real(mod(tt,dt_file))/real(dt_file)
            call rk4(SNPP)
            tt=tt+dt
            count_step=count_step+1

#ifdef isGlider
           call save_glider_data(SNPP)
#else
            call check_and_save(SNPP)
#endif

        enddo

        if (mod(rec_num,Nrecs)==0) then
            call load_uvw(1,0)
            call load_uvw(2,1)

#ifdef saveTSG
            call load_tsg(1,0)
            call load_tsg(2,1)
#endif

            rec_num=rec_num+2
            marker(1:2)=(/2,1/)

#ifdef jump_looping
            do IPP=1,SNPP
                call jump(IPP)
            enddo
#endif

            iswitch=1
        else
            rec_num=rec_num+1
            iswitch=abs(iswitch-1)
            call load_uvw(rec_num,iswitch)
#ifdef saveTSG
            call load_tsg(rec_num,iswitch)
#endif
            marker(1:2)=(/rec_num,iswitch/)

#if model==2
            call get_roms_depth(real(zeta,8))
#endif

        endif
    enddo

!#ifdef isGlider
!    do i=1,Npts
!       do IPP=1,NPP
!         close(save_glider_FnIDs(i,IPP))
!       enddo
!    enddo
!#endif

    CALL DATE_AND_TIME(date,time1,zone,time)
    print*, "Program started at", time0, "and ended ", time1
    !call close_files()

end program main

