SUBROUTINE velocity_2D_exact(x0,y0,z0,U,V,W)
    !== takes positions x,y,z and gives velocity transport U,V,W 
    use global, only : Nx,Ny,dxg_r,dyg_r,drf_r,PI
    IMPLICIT NONE
    REAL*8,INTENT(out) :: U,V,W
    REAL*8,INTENT(in) :: x0,y0,z0
    REAL*8 :: Lx,Ly,a,b,x,y,z

    print*, "velocity 2D exact xyz", x0,y0,z0
    !z=0.d0
    a=0.8d0
    b=1.2d0

    Lx=Nx
    Ly=Ny
    x=x0/Lx
    y=y0/Ly

    U=-2.d0*(x*(x-1.d0))**2*(y*(y-1.d0)**2+y**2*(y-1.d0))*sin(PI*(a*x-b*y))
    U=U+b*PI*cos(PI*(a*x-b*y))*(x*(x-1.d0))**2*(y*(y-1.d0))**2
    V=2.d0*(y*(y-1.d0))**2*(x*(x-1.d0)**2+x**2*(x-1.d0))*sin(PI*(a*x-b*y))
    V=V+a*PI*cos(PI*(a*x-b*y))*(x*(x-1.d0))**2*(y*(y-1.d0))**2

    !U=U/float(Ny+1)
    !V=V/float(Nx+1)

    if (x.le.0.d0) then
    U=0.d0
    V=0.d0
    endif
    if(x .ge. Nx) then
    U=0.d0
    V=0.d0
    endif
    if(y .le. 0.d0) then
    U=0.d0
    V=0.d0
    endif
    if(y .ge. Ny) then
    U=0.d0
    V=0.d0
    endif
    print*, "velocity 2D exact, uv",U,V
END SUBROUTINE velocity_2D_exact
