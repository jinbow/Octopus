SUBROUTINE incompressibile_correction_2D(di,dj,varU,varV,delU,delV)
    !== give 4 corner points of a square, interpolate point values inside
    !== di is the distance of the particle to the left face
    !== dj is the distance of the particle to the southern face
    IMPLICIT NONE
    REAL*8, INTENT(in) :: di,dj
    REAL*4, INTENT(in), DIMENSION( 2, 2 ) :: varU,varV
    REAL*8, INTENT(out) :: delU,delV
    REAL*8 :: alpha,beta
    !varU(1,1)=u(i,j),varU(2,1)=u(i+1,j),varU(1,2)=u(i,j+1),varU(2,2)=u(i+1,j+1)
    !varV(1,1)=v(i,j),varV(2,1)=v(i+1,j),varV(1,2)=v(i,j+1),varV(2,2)=v(i+1,j+1)

    ! calculate the correction to the bilinear interpolation

    alpha =varU(1,1)+varU(2,2)-varU(1,2)-varU(2,1)
    beta =varV(1,1)+varV(2,2)-varV(1,2)-varV(2,1)
    delU=-0.5*beta*di*(di-1.d0)
    delV =-0.5*alpha*dj*(dj-1.d0)

END SUBROUTINE incompressibile_correction_2D

