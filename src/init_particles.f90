subroutine init_particles(IPP)
#include "cpp_options.h"
    use global, only : Npts,iswitch,xyz,fn_parti_init,tsg,&
        target_density,pickup,rec_num,tt,dt_file,pk2f,NPP
    implicit none
    integer*8, intent(in):: IPP

    if (pickup>0) then
        call load_data(IPP)
        rec_num = floor(tt/dt_file)+1
        print*, "pickup data maxval z, pk2f, rec_num", maxval(xyz(:,3,:)),maxval(pk2f),rec_num
    else
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

    endif
        print*, "maximum init", maxval(xyz(:,1,IPP)),maxval(xyz(:,2,IPP)),maxval(xyz(:,3,IPP))
    !call load_uv(rec_num,u0,v0,w0)
    !call load_uv(rec_num+1,u1,v1,w1)
    !call load_tsg(rec_num,theta0,salt0,gamma0)
    !call load_tsg(rec_num+1,theta1,salt1,gamma1)

end subroutine init_particles

