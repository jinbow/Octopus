subroutine get_glider_velocity(uvw_g,ip,IPP)
#include "cpp_options.h"

#ifdef isGlider
    use global, only : tt,dt,xyz,glider_clock,glider_position,&
                       parking_time,surfacing_time,SNPP,&
                       dive_depth,save_glider_FnIDs,glider_cycle,&
                       output_dir,glider_uv,glider_angle,absv
       !add noise to the vertical velocity
       !call random_number(tmp0)
       !tmp0=(tmp0-0.5)*0.05

    implicit none

    integer*8,intent(in) :: ip, IPP
    real*8,dimension(3), intent(out) :: uvw_g
    character*6 :: id_str,cycle_str,IPP_str
    character(len=255) :: glider_fn

    integer*8 :: i
    real*8 :: i0,i1,j0,j1,dx,dy,glider_direction,&
              ia,angle,gu,gw,dist

    angle=glider_angle(ip,IPP)
    gw=absv*sin(angle/180.0*3.1415926)
    gu=absv*cos(angle/180.0*3.1415926)

    ia=glider_clock(ip,1,IPP)

    if ( ia==0 ) then 
    
    !- set horizontal velocity
    !- set the glider horizontal velocity depending on the direction 
    !- relative to the target position

    i0=glider_position(ip,1,IPP) !- old position
    j0=glider_position(ip,2,IPP) !- old position

    i1=glider_position(ip,3,IPP) !- target position
    j1=glider_position(ip,4,IPP) !- target position


#if dive_angle==adjustable
    dist=sqrt((real(i1-i0,8))**2+(real(j1-j0,8))**2)
    if (dist>3) then
        glider_angle(ip,IPP)=30.0
    else
        glider_angle(ip,IPP)=60.0
    endif
    gw=absv*sin(angle/180.0*3.1415926)
    gu=absv*cos(angle/180.0*3.1415926)
#else
    glider_angle(ip,IPP)=60.0
    gw=absv*sin(angle/180.0*3.1415926)
    gu=absv*cos(angle/180.0*3.1415926)
#endif
    
    glider_direction=atan(real(abs(j1-j0))/real(abs(i1-i0)))

    glider_uv(ip,1,IPP)=gu * sign( cos(glider_direction), i1-i0)
    glider_uv(ip,2,IPP)=gu * sign( sin(glider_direction), j1-j0)

    !ia=0 indicates the instrument is at surface
    !save the position and start to descend

        glider_clock(ip,1,IPP)=1
        uvw_g(3) = gw
        
       ! do i=1, SNPP
       !     call save_data(SNPP)
       ! enddo
        
    elseif (ia==1) then
        !descending
        !stay at the bottom after hitting the bottom
        if (xyz(ip,3,IPP)<dive_depth ) then
            !descending toward glider max depth 
            uvw_g(3) = gw
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
            uvw_g(3) = -1*gw
        endif

    elseif (ia==3.0) then
        !up from max depth 
        if ( xyz(ip,3,IPP) > 0) then
            uvw_g(3) = -1*gw
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

!==>  close data file
            close(save_glider_FnIDs(ip,IPP))

!==> reopen new data file

            glider_cycle(ip,IPP)=glider_cycle(ip,IPP)+1
            write(id_str,"(I6.6)") ip
            write(IPP_str,"(I6.6)") IPP
            write(cycle_str,"(I6.6)") glider_cycle(ip,IPP)

            glider_fn=trim(output_dir)//"G.IPP."//IPP_str//".ip."//id_str//".cycle."//trim(cycle_str)//".data"

            open(save_glider_FnIDs(ip,IPP),file=trim(glider_fn),&
                form='formatted',access='append',&
                status='new')
            uvw_g(3) = gw
        endif

    endif

    uvw_g(1:2)=glider_uv(ip,:,IPP)
#endif

end subroutine get_glider_velocity
