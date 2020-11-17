SUBROUTINE interp_bilinear(di,dj,var,velp)
    !== give 4 corner points of a square, interpolate point values inside
    !== di is the distance of the particle to the left face
    !== dj is the distance of the particle to the southern face

    IMPLICIT NONE
    REAL*8, INTENT(in) :: di,dj
    REAL*4, INTENT(in), DIMENSION( 2, 2 ) :: var
    REAL*8, INTENT(out) :: velp
    REAL*8 :: i1,i4

    ! calcuate the bilinear interpolation
    i1 = (var(2,1) - var(1,1))*di + var(1,1)
    i4 = (var(2,2) - var(1,2))*di + var(1,2)
    velp = (i4 - i1)*dj + i1

END SUBROUTINE interp_bilinear
