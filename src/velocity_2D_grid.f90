SUBROUTINE velocity_2D_grid(x,y,z,dx,dy,dz,U,V,W)
    !== generates positions x,y,z and velocity transport U,V,W 
    use global, only : Nx,Ny,dxg_r,dyg_r,drf_r,PI
     IMPLICIT NONE
    INTEGER*8 :: i,j,k
    REAL*8, DIMENSION(-2:Nx+1,-2:Ny+1), INTENT(out) ::  :: U,V,W
    REAL*8, DIMENSION(-2:Nx+1,-2:Ny+1),INTENT(out) ::  :: x,y
    REAL*8, DIMENSION(-2:Nx+1,-2:Ny+1),INTENT(out) ::  :: dx,dy
    REAL*8, DIMENSION(0:Nz-1),INTENT(out) ::  :: dz
    REAL*8 :: Lx,Ly,H,a,b,z,psi0
    z=0.d0
    a=0.8d0
    b=1.2d0
    Lx=1.d6
    Ly=1.d6
    H=1.d3
    U0=5.d0
    do k=0:Nz-1
    dz(k)=H/float(Nz)
    enddo
    do i=-2,NX+1
       dx(i,j)=Lx/float(Nx+1)
       x(i,j)=Lx/float(Nx+1)*float(i+1)
       do j=-2,Ny+1
          dy(i,j)=Ly/float(Ny+1)
          y(i,j)=Ly/float(Ny+1)*(float(j+1)+.5d0)
          U(i,j)=0.d0
          V(i,j)=0.d0
          W(i,j)=0.0d0
       enddo
    enddo
    !interior points are defined here velocity vanishes at pts -1,Nx,Ny
    do i=0,NX-1
       xx=1.d0/float(Nx+1)*float(i+1)
       do j=0,Ny-1
          yy=1.d0/float(Ny+1)*(float(j+1)+.5d0)
          U(i,j)=-2.d0*(xx*(xx-1.d0))**2*(yy*(yy-1.d0)**2+yy**2*(yy-1.d0))*sin(PI*(a*xx-b*yy))&
               +b*PI*cos(PI*(a*xx-b*yy))*(xx*(xx-1.d0))**2*(yy*(yy-1.d0))**2
          U(i,j)=U0*U(i,j)*dy(i,j)*dz(0)
       enddo
    enddo
    do i=0,NX-1
       do j=0,Ny-1
          V(i,j+1)=V(i,j)- U(i+1,j)+U(i,j)
       enddo
    enddo
END SUBROUTINE velocity_2D_grid
