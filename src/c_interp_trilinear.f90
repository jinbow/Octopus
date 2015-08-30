SUBROUTINE interp_trilinear(di,dj,dk,var,velp)
    !== give 8 corner points of a cube, interpolate point values inside
    !of the cube var(i,j,k)
    !== di is the distance of the particle to the left face
    !== dj is the distance of the particle to the southern face
    !== dk is the distance of the particle to the bottom face
    IMPLICIT NONE
    REAL*8, INTENT(in) :: di,dj,dk
    REAL*4, INTENT(in), DIMENSION( 2, 2 , 2 ) :: var
    REAL*8, INTENT(out) :: velp
    REAL*8 :: i1,i2,i3,i4,j1,j2

    ! calcuate the Trilinear interpolation
    i1 = (var(2,1, 1) - var(1,1, 1))*di + var(1,1, 1)
    i2 = (var(2,1, 2) - var(1,1,2))*di + var(1,1, 2)
    i3 = (var(2,2,2) - var(1,2,2))*di +var(1,2,2)
    i4 = (var(2,2,1) - var(1,2,1))*di + var(1,2,1)

    j1 = (i3 - i2)*dj + i2
    j2 = (i4 - i1)*dj + i1
  
    
    velp = (j1 - j2) * dk + j2

END SUBROUTINE interp_trilinear
