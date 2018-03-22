SUBROUTINE get_argo_w(ip,ipp,argow)
#include "cpp_options.h"

#ifdef isArgo
  USE global, ONLY : tt,xyz,argo_clock,parking_time,surfacing_time,SNPP,save_argo_FnID
  !add noise to the vertical velocity
  !call random_number(tmp0)
  !tmp0=(tmp0-0.5)*0.05

  IMPLICIT NONE
  REAL*8,INTENT(out) :: argow
  INTEGER*8,INTENT(in) :: ip,ipp
  INTEGER*8 :: ia,i
  ia=argo_clock(ip,1,ipp)

  IF ( ia==0 ) THEN
     argo_clock(ip,1,ipp)=1
     argow = 0.047

     WRITE(save_argo_FnID,*) tt,ip,ipp,xyz(i,:,IPP)

     !do i=1, SNPP
     !    call save_data(SNPP)
     !enddo
     IF (ip==1 .AND. ipp==1) THEN
        PRINT*, "==========================================" 
        PRINT*, "output Argo data at tt=",tt
     ENDIF
  ELSEIF (ia==1) THEN
     !save the surface position
     !descending
     !stay at the bottom after hitting the bottom
     IF (xyz(ip,3,ipp)<21.842105263157894 ) THEN
        !descending toward 1000 meters
        argow = 0.047
     ELSE
        !reached parking depth
        argo_clock(ip,1,ipp)=2
        argo_clock(ip,2,ipp)=0
        argow = 0
     ENDIF

  ELSEIF (ia==2) THEN !-> spend parking time
     IF (argo_clock(ip,2,ipp) .LE. parking_time) THEN
        argow = 0.0 !argo_w(3)
     ELSE !-> descend to 2000 meters
        argo_clock(ip,2,ipp) = 0
        argo_clock(ip,1,ipp) = 3
        argow = 0.047
     ENDIF

  ELSEIF (ia==3) THEN
     !descending to 2000
     !if ( xyz(1,3,1)<26.826741996233523 .and. &
     !    depth<sose_depth(ixyz(ip,1),ixyz(ip,2))) then

     IF ( xyz(ip,3,ipp)<26.826741996233523 ) THEN
        argow = 0.047
     ELSE
        argow = -0.055
        argo_clock(ip,1,ipp) = 4
        argo_clock(ip,2,ipp) =0
     ENDIF

  ELSEIF (ia==4) THEN
     !up from 2000
     IF ( xyz(ip,3,ipp) > 0.001 ) THEN
        argow = -0.055
        !argow = 0.06*depth/2000 - 0.12 + tmp0 !linearly increase above 2000m
     ELSE
        !reach the surface
        xyz(ip,3,ipp)=0.001
        argow = 0.0
        argo_clock(ip,1,ipp) = 5
        argo_clock(ip,2,ipp) =0
     ENDIF

  ELSEIF (ia==5) THEN
     IF (argo_clock(ip,2,ipp) .LE. surfacing_time) THEN
        argow = 0.0 !argo_w(3)
     ELSE
        argo_clock(ip,1,ipp) = 0
        argo_clock(ip,2,ipp) =0
        argow = 0.047
     ENDIF

  ENDIF

#endif

END SUBROUTINE get_argo_w
