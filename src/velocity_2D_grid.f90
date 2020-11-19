SUBROUTINE velocity_2D_grid(x,y,z,U,V,W)
    !== generates positions x,y,z and velocity transport U,V,W 
    use global, only : Nx,Ny,dxg_r,dyg_r,drf_r,PI
     IMPLICIT NONE
    INTEGER*8 :: i,j,k
    REAL*8, DIMENSION(-2:Nx+1,-2:Ny+1), INTENT(out) ::  :: U,V,W
    REAL*8, DIMENSION(-2:Nx+1,-2:Ny+1),INTENT(out) ::  :: x,y
    REAL*8 :: Lx,Ly,a,b,z
    z=0.d0
    a=0.8d0
    b=1.2d0
    do i=-2,NX+1
       x(i,j)=1.d0/float(Nx+1)*float(i+1)
       do j=-2,Ny+1
          y(i,j)=1.d0/float(Ny+1)*float(j+1)
          U(i,j)=0.d0
          V(i,j)=0.d0
          W(i,j)=0.0d0
       enddo
    enddo
    do i=0,NX-1
       x(i,j)=1.d0/float(Nx+1)*float(i+1)
       do j=0,Ny-1
          y(i,j)=1.d0/float(Ny+1)*float(j+1)
          U(i,j)=-2.d0*(x(i,j)*(x(i,j)-1.d0))**2*(y(i,j)*(y(i,j)-1.d0)**2+y(i,j)**2*(y(i,j)-1.d0))*sin(PI*(a*x(i,j)-b*y(i,j)))&
               +b*PI*cos(PI*(a*x(i,j)-b*y(i,j))*(x(i,j)*(x(i,j)-1.d0))**2*(y(i,j)*(y(i,j)-1.d0))**2
          U(i,j)=U(i,j)/float(Ny+1)
       enddo
    enddo
    do i=0,NX-1
       do j=0,Ny-1
          V(i,j+1)=V(i,j)- U(i+1,j)+U(i,j)
       enddo
    enddo
END SUBROUTINE velocity_2D_grid
