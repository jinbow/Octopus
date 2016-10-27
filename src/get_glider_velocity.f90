subroutine get_glider_velocity(uvw_g,ip,IPP)
#include "cpp_options.h"

#ifdef isGlider
    use global, only : tt,dt,xyz,glider_clock,glider_position,&
                       parking_time,surfacing_time,SNPP,&
                       dive_depth
       !add noise to the vertical velocity
       !call random_number(tmp0)
       !tmp0=(tmp0-0.5)*0.05

    implicit none

    integer*8,intent(in) :: ip, IPP
    real*8,dimension(3), intent(out) :: uvw_g

    integer*8 :: i
    real*8 :: i0,i1,j0,j1,glider_direction,ia

    !- get horizontal velocity
    !- set the glider horizontal velocity depending on the direction 
    !- relative to the target position
    i0=glider_position(ip,1,IPP) !- old position
    j0=glider_position(ip,2,IPP) !- old position
    i1=glider_position(ip,3,IPP) !- target position
    j1=glider_position(ip,4,IPP) !- target position
    
    glider_direction=atan(real(abs(j1-j0))/real(abs(i1-i0)))

    uvw_g(1)=0.5 * sign( cos(atan(glider_direction)), i1-i0)
    uvw_g(2)=0.5 * sign( sin(atan(glider_direction)), j1-j0)


    ia=glider_clock(ip,1,IPP)

    if ( ia==0 ) then 
    !ia=0 indicates the instrument is at surface
    !save the position and start to descend


        glider_clock(ip,1,IPP)=1
        uvw_g(3) = 0.047
        
        do i=1, SNPP
            call save_data(SNPP)
        enddo
        
    elseif (ia==1) then
        !descending
        !stay at the bottom after hitting the bottom
        if (xyz(ip,3,IPP)<dive_depth ) then
            !descending toward glider max depth 
            uvw_g(3) = 0.2
        else
            !reached the max depth
            !start to ascend
            glider_clock(ip,1,IPP)=2
            glider_clock(ip,2,IPP)=0
            uvw_g(3) = 0
        endif

    elseif (ia==2) then !->spend the parking time
        if (glider_clock(ip,2,IPP) .le. parking_time) then
            uvw_g(3) = 0.0 !glider_w(3)
            glider_clock(ip,2,IPP)=glider_clock(ip,2,IPP)+dt/4.0
        else !-> ascend 
            glider_clock(ip,2,IPP) = 0.0
            glider_clock(ip,1,IPP) = 3.0
            uvw_g(3) = -0.2
        endif

    elseif (ia==3.0) then
        !up from max depth 
        if ( xyz(ip,3,IPP) > 0) then
            uvw_g(3) = -0.2
        else
            !reach the surface
            !xyz(ip,3,IPP)=0.0
            uvw_g(3) = 0.0
            glider_clock(ip,1,IPP) = 4.0
            glider_clock(ip,2,IPP) =0.0

        endif

    elseif (ia==4.0) then
        if (glider_clock(ip,2,IPP) .le. surfacing_time) then
            uvw_g(3) = 0.0 !glider_w(3)
            glider_clock(ip,2,IPP)=glider_clock(ip,2,IPP)+dt/4.0
        else
            glider_clock(ip,1,IPP) = 0
            glider_clock(ip,2,IPP) =0.0

            !==> save the glider position at the surface
            glider_position(ip,1,IPP)=xyz(ip,1,IPP)
            glider_position(ip,2,IPP)=xyz(ip,2,IPP)

            uvw_g(3) = 0.2
        endif

    endif

!    if (ip==1) then
!       print*, '++++',xyz(ip,:,IPP),ia,uvw_g(:)
!    endif

#endif

end subroutine get_glider_velocity
