subroutine calc_gradient(t0,IPP)

    use global, only: uu,vv,dic,djc,dkc,dif,djf,dkf,pi2c,pj2c,pk2c,pi2f,pj2f,grad,npts,dxg_r,dyg_r,Npts
    implicit none
    integer*8, intent(in) :: IPP,t0
    real*8 :: tmp0,tmp1,dx,dy,dr
    integer*8:: i,j,k,ip

    !$OMP PARALLEL DO PRIVATE(ip,i,j,k,dx,dy,dr,tmp0,tmp1) SHARED(IPP,t0,dic,djc,dkc,uu,vv,grad,dxg_r,dyg_r) SCHEDULE(dynamic)
    do ip=1,npts

        dx=dif(ip,IPP)
        dy=djc(ip,IPP)
        dr=dkc(ip,IPP)

        !du/dx
        i=pi2f(ip,IPP)
        j=pj2c(ip,IPP)
        k=pk2c(ip,IPP)
        call interp_bilinear(dy,dr,uu(i,j:j+1,k:k+1,t0),tmp0)
        call interp_bilinear(dy,dr,uu(i+1,j:j+1,k:k+1,t0),tmp1)
        grad(ip,1,IPP)=(tmp1-tmp0)*dxg_r(i,j)
        !du/dy
        call interp_bilinear(dx,dr,uu(i:i+1,j,k:k+1,t0),tmp0)
        call interp_bilinear(dx,dr,uu(i:i+1,j+1,k:k+1,t0),tmp1)
        grad(ip,2,IPP)=(tmp1-tmp0)*dyg_r(i,j)

        !dv/dx
        i=pi2c(ip,IPP)
        j=pj2f(ip,IPP)

        dy=djf(ip,IPP)
        dx=dic(ip,IPP)

        call interp_bilinear(dy,dr,vv(i,j:j+1,k:k+1,t0),tmp0)
        call interp_bilinear(dy,dr,vv(i+1,j:j+1,k:k+1,t0),tmp1)
        grad(ip,3,IPP)=(tmp1-tmp0)*dxg_r(i,j)
        !dv/dy

        call interp_bilinear(dx,dr,vv(i:i+1,j,k:k+1,t0),tmp0)
        call interp_bilinear(dx,dr,vv(i:i+1,j+1,k:k+1,t0),tmp1)
        grad(ip,4,IPP)=(tmp1-tmp0)*dyg_r(i,j)


    enddo
!$OMP END PARALLEL DO

end subroutine calc_gradient
