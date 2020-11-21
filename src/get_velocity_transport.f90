subroutine find_particle_uvw(t_amend,ip,IPP,t0,t1,uvw)
#include "cpp_options.h"

    use global, only : Nx,Ny,Nz,Npts,xyz

    implicit none
    ! in case with analytical velocity function, t_amend, t0, t1 are not used but kept for consistency
    real*8, intent(in) :: t_amend
    integer*8,intent(in) :: t0,t1,ip,IPP

    real*8,dimension(3),intent(out) :: uvw

    real*8 :: x,y,z,u,v,w 

    x=xyz(ip,1,IPP)
    y=xyz(ip,2,IPP)
    z=xyz(ip,3,IPP)

    call velocity_2D_exact(x,y,z,u,v,w)

    uvw=(/u,v,w/)

end subroutine find_particle_uvw
