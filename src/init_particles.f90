subroutine init_particles(IPP)
#include "cpp_options.h"
    use global, only : Npts,iswitch,xyz,fn_parti_init,tsg,&
        target_density,pickup,rec_num,tt,dt_file,pk2f,NPP
    implicit none
    integer*8, intent(in):: IPP

        print*, "------------------------------------"
        print*, "initialize particles for case", IPP
        open(10,file=trim(fn_parti_init),form='unformatted',&
            recl=8*Npts*3,convert='BIG_ENDIAN',&
            access='direct',status='old')
        read(10,rec=1) xyz(:,:,IPP)
        close(10)
#ifdef isArgo
        xyz(:,3,IPP)=0
#else
        call set_boundary(IPP)
        ! Reset the particle depth to find the particle density
        if (target_density>0) then
            tsg(:,3,IPP)=target_density
            call jump(IPP)
        endif
#endif

        print*, "maximum init", maxval(xyz(:,1,IPP)),maxval(xyz(:,2,IPP)),maxval(xyz(:,3,IPP))

end subroutine init_particles

