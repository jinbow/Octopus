subroutine init_particles(IPP)
#include "cpp_options.h"

!    use global, only : Npts,iswitch,xyz,tsg,&
!                       target_density,pickup,&
!                       rec_num,tt,dt_file,pk2f,&
!                       NPP,FnPartiInit,glider_position
     use global

    implicit none
    integer*8, intent(in):: IPP

        print*, "initialize particles for case", IPP

        open(301,file=trim(FnPartiInit),form='unformatted',&
            recl=8*Npts*3,convert='BIG_ENDIAN',&
            access='direct',status='old')
        read(301,rec=1) xyz(:,:,IPP)
        close(301)


#ifdef isArgo
        xyz(:,3,IPP)=0
#endif

#ifdef isGlider
       xyz(:,3,IPP)=0
       glider_position(:,1,IPP)=xyz(:,1,IPP)
       glider_position(:,2,IPP)=xyz(:,2,IPP)
       glider_position(:,3,IPP)=350
       glider_position(:,4,IPP)=100
       glider_clock(:,1,IPP)=0
#endif

#ifndef isArgo
#ifndef isGlider
        call set_boundary(IPP)
        ! Reset the particle depth to find the particle density
        if (target_density>0) then
            tsg(:,3,IPP)=target_density
            call jump(IPP)
        endif
#endif
#endif

        print*, "maximum init", maxval(xyz(:,1,IPP)),maxval(xyz(:,2,IPP)),maxval(xyz(:,3,IPP))

end subroutine init_particles

