SUBROUTINE velocity_2D_exact(x,y,z,U,V,W)
    !== takes positions x,y,z and gives velocity transport U,V,W 
    use global, only : Nx,Ny,dxg_r,dyg_r,drf_r,PI
     IMPLICIT NONE
    REAL*8, INTENT(out) ::  :: U,V,W
    REAL*8,INTENT(in) ::  :: x,y,z
    REAL*8 :: Lx,Ly,a,b

    z=0.d0
    a=0.8d0
    b=1.2d0
    U=-2.d0*(x*(x-1.d0))**2*(y*(y-1.d0)**2+y**2*(y-1.d0))*sin(PI*(a*x-b*y))&
         +b*PI*cos(PI*(a*x-b*y)*(x*(x-1.d0))**2*(y*(y-1.d0))**2
    V=2.d0*(y*(y-1.d0))**2*(x*(x-1.d0)**2+x**2*(x-1.d0))*sin(PI*(a*x-b*y))&
         +a*PI*cos(PI*(a*x-b*y)*(x*(x-1.d0))**2*(y*(y-1.d0))**2
    U=U/float(Ny+1)
    V=V/float(Nx+1)
    if(x.le.0.d0)
    U=0.d0
    V=0.d0
    endif
    if(x.ge.1.d0)
    U=0.d0
    V=0.d0
    endif
    if(y.le.0.d0)
    U=0.d0
    V=0.d0
    endif
    if(y.ge.1.d0)
    U=0.d0
    V=0.d0
    endif
END SUBROUTINE velocity_2D_exact
