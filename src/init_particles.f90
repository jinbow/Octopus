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

        open(FnPartiInitId,file=trim(FnPartiInit),form='unformatted',&
            recl=8*Npts*3,convert='BIG_ENDIAN',&
            access='direct',status='old')
        read(FnPartiInitId,rec=1) xyz(:,:,IPP)
        close(FnPartiInitId)


#ifdef isArgo
        xyz(:,3,IPP)=0
#endif

#ifdef isGlider
       xyz(:,3,IPP)=0
       !xyz(1,1,IPP)= 101.1
       !xyz(1,2,IPP)= 200.1
       !xyz(2,1,IPP)= 99.9
       !xyz(2,2,IPP)= 199.9

       glider_position(:,3,IPP)=xyz(:,1,IPP)
       glider_position(:,4,IPP)=xyz(:,2,IPP)

       xyz(:,1:2,IPP)=xyz(:,1:2,IPP)+0.01
       !xyz(1,1:2,IPP)=2
       glider_position(:,1,IPP)=xyz(:,1,IPP)
       glider_position(:,2,IPP)=xyz(:,2,IPP)


       

       glider_clock(:,1,IPP)=0
       glider_cycle(:,:)=0
       glider_angle(:,:)=60

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

