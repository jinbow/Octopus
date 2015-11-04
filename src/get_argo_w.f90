subroutine get_argo_w(argow)
#include "cpp_options.h"
    implicit none
    integer*8 :: ia
    real*8,intent(out) :: argow

#ifdef isArgo

    use global, only : xyz,argo_clock,parking_time,surfacing_time
    !add noise to the vertical velocity
    !call random_number(tmp0)
    !tmp0=(tmp0-0.5)*0.05

    ia=argo_clock(1)

    if ( ia==0 ) then
        argo_clock(1)=1
        argow = 0.047
    elseif (ia==1) then
        !save the surface position
        !descending
        !stay at the bottom after hitting the bottom
        if (xyz(1,3,1)<21.842105263157894 ) then
            !descending toward 1000 meters
            argow = 0.047
        else
            !reached parking depth
            argo_clock(1)=2
            argo_clock(2)=0
            argow = 0
        endif

    elseif (ia==2) then !-> spend parking time
        if (argo_clock(2) .le. parking_time) then
            argow = 0.0 !argo_w(3)
        else !-> descend to 2000 meters
            argo_clock(2) = 0.0
            argo_clock(1) = 3
            argow = 0.047
        endif

    elseif (ia==3) then
        !descending to 2000
        !if ( xyz(1,3,1)<26.826741996233523 .and. &
        !    depth<sose_depth(ixyz(ip,1),ixyz(ip,2))) then

        if ( xyz(1,3,1)<26.826741996233523 ) then
            argow = 0.047
        else
            argow = -0.055
            argo_clock(1) = 4
            argo_clock(2) =0.0
        endif

    elseif (ia==4) then
        !up from 2000
        if ( xyz(1,3,1) > 0.001 ) then
            argow = -0.055
           !argow = 0.06*depth/2000 - 0.12 + tmp0 !linearly increase above 2000m
        else
            !reach the surface
            xyz(1,3,1)=0.001
            argow = 0.0
            argo_clock(1) = 5
            argo_clock(2) =0.0

            call dump_argo()
        endif

    elseif (ia==5) then
        if (argo_clock(2) .le. surfacing_time) then
            argow = 0.0 !argo_w(3)
        else
            argo_clock(1) = 0
            argo_clock(2) =0.0
            argow = 0.047
        endif

    endif
#endif

end subroutine get_argo_w
