subroutine get_glider_w(uvw_g,ip,IPP)
#include "cpp_options.h"

#ifdef isGlider
    use global, only : xyz,glider_clock,glider_position,parking_time,surfacing_time,SNPP
       !add noise to the vertical velocity
       !call random_number(tmp0)
       !tmp0=(tmp0-0.5)*0.05

    implicit none

    integer*8,intent(in) :: ip, IPP
    real*8,dimension(3), intent(out) :: uvw_g

    integer*8 :: ia,i
    real*8 :: i0,i1,j0,j1,glider_direction
    ia=glider_clock(ip,IPP)

    !- get horizontal velocity
    !- set the glider horizontal velocity depending on the direction 
    !- relative to the target position
    i0=glider_position(ip,1,IPP) !- old position
    j0=glider_position(ip,2,IPP) !- old position
    i1=glider_position(ip,3,IPP) !- target position
    j1=glider_position(ip,4,IPP) !- target position
    
    glider_direction=arctan(real(abs(j1-j0))/real(abs(i1-i0)))
    uvw_g(1)=0.5 * sign( cos(arctan(glider_direction)), i1-i0)
    uvw_g(2)=0.5 * sign( sin(arctan(glider_direction)), j1-j0)

    if ( ia==0 ) then 
    !ia=0 indicates the instrument is at surface
    !save the position and start to descend


        glider_clock(ip,IPP,1)=1
        uvw_g(3) = 0.047
        
        do i=1, SNPP
            call save_data(SNPP)
        enddo
        
        print*, "==========================================" 
        print*, "output Argo data"

    elseif (ia==1) then
        !descending
        !stay at the bottom after hitting the bottom
        if (xyz(1,3,1)<21.842105263157894 ) then
            !descending toward glider max depth 
            uvw_g(3) = 0.047
        else
            !reached the max depth
            !start to ascend
            glider_clock(ip,IPP,1)=2
            glider_clock(ip,IPP,2)=0
            uvw_g(3) = 0
        endif

    elseif (ia==2) then !->spend the parking time
        if (glider_clock(ip,IPP,2) .le. parking_time) then
            uvw_g(3) = 0.0 !glider_w(3)
        else !-> ascend 
            glider_clock(ip,IPP,2) = 0.0
            glider_clock(ip,IPP,1) = 3
            uvw_g(3) = -0.047
        endif

    elseif (ia==3) then
        !up from max depth 
        if ( xyz(1,3,1) > 0.001 ) then
            uvw_g(3) = -0.055
           !uvw_g = 0.06*depth/2000 - 0.12 + tmp0 !linearly increase above 2000m
        else
            !reach the surface
            xyz(1,3,1)=0.001
            uvw_g(3) = 0.0
            glider_clock(ip,IPP,1) = 4
            glider_clock(ip,IPP,2) =0.0

        endif

    elseif (ia==4) then
        if (glider_clock(ip,IPP,2) .le. surfacing_time) then
            uvw_g(3) = 0.0 !glider_w(3)
        else
            glider_clock(ip,IPP,1) = 0
            glider_clock(ip,IPP,2) =0.0

            !==> save the glider position at the surface
            glider_position(ip,1,IPP)=xyz(ip,1,IPP)
            glider_position(ip,2,IPP)=xyz(ip,2,IPP)

            uvw_g(3) = 0.047
        endif

    endif

#endif

end subroutine get_glider_w
