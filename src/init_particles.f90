subroutine init_particles(IPP)
#include "cpp_options.h"

!    use global, only : Npts,iswitch,xyz,tsg,&
!                       target_density,pickup,&
!                       rec_num,tt,dt_file,pk2f,&
!                       NPP,FnPartiInit,glider_position
     use global

    implicit none
    integer*8, intent(in):: IPP
    real*8 :: glider_target(4,Npts)

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

        open(FnPartiInitId,file='glider_target.txt',form='formatted',&
            access='sequential',status='old')
        read(FnPartiInitId,'(F7.4,1X,F7.4,1X,F7.4,1X,F7.4)') glider_target
        close(FnPartiInitId)

       print*, "**** Read glider_target.txt"
       print*, "**** Glider targets are ", glider_target

       glider_position(:,3:6,IPP)=transpose(glider_target)

       !xyz(:,1:2,IPP)=xyz(:,1:2,IPP) !+0.01
       !xyz(1,1:2,IPP)=2

       glider_position(:,1:2,IPP)=glider_position(:,3:4,IPP)

       xyz(:,1:2,IPP)=glider_position(:,3:4,IPP)

       target_switch(:,IPP)=1

       glider_clock(:,1,IPP)=0
       glider_cycle(:,:)=0
       glider_angle(:,:)=fixedangle

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

