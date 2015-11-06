subroutine interp_tracer(t0,t1,IPP)
    use global,only: Nx,Ny,dtp,xyz,dic,djc,dkc,pi2c,pj2c,pk2c,Npts,theta,salt,gam,tsg,NPP,tt,phihyd,fn_PHIHYD
    implicit none
    integer*8,intent(in) :: t0,t1,IPP
    integer*8 :: i,j,k,ip
    real*8 :: tmp0,tmp1
    real*4 :: tmp(2,2,2)

   if (trim(fn_PHIHYD) .ne. '') then
   call load_PHIHYD(tt)
   endif

!$OMP PARALLEL DO PRIVATE(ip,i,j,k,tmp0,tmp1) SHARED(IPP,t0,t1,dic,djc,dkc,theta,salt,gam,tsg,dtp,phihyd) SCHEDULE(dynamic)
        do ip=1,npts

            if (xyz(ip,2,IPP)<Ny-1) then
                tmp0=0d0
                tmp1=0d0
                i=floor(mod(xyz(ip,1,IPP),real(Nx-1))-0.5d0)
                j=floor(xyz(ip,2,IPP)-0.5d0)
                k=floor(xyz(ip,3,IPP)-0.5d0)
                
                tmp=theta(i:i+1,j:j+1,k:k+1,t0)
                where(tmp==0)tmp=maxval(tmp)
                call interp_trilinear(dic(ip,IPP),djc(ip,IPP),dkc(ip,IPP),tmp,tmp0)
                tmp=theta(i:i+1,j:j+1,k:k+1,t1)
                where(tmp==0)tmp=maxval(tmp)
                call interp_trilinear(dic(ip,IPP),djc(ip,IPP),dkc(ip,IPP),tmp,tmp1)
                tsg(ip,1,IPP) = (tmp1-tmp0)*dtp+ tmp0

                tmp=salt(i:i+1,j:j+1,k:k+1,t0)
                where(tmp==0)tmp=maxval(tmp)
                call interp_trilinear(dic(ip,IPP),djc(ip,IPP),dkc(ip,IPP),tmp,tmp0)
                tmp=salt(i:i+1,j:j+1,k:k+1,t1)
                where(tmp==0)tmp=maxval(tmp)
                call interp_trilinear(dic(ip,IPP),djc(ip,IPP),dkc(ip,IPP),tmp,tmp1)
                tsg(ip,2,IPP) = (tmp1-tmp0)*dtp + tmp0

                tmp=gam(i:i+1,j:j+1,k:k+1,t0)
                where(tmp==0)tmp=maxval(tmp)
                call interp_trilinear(dic(ip,IPP),djc(ip,IPP),dkc(ip,IPP),tmp,tmp0)
                tmp=gam(i:i+1,j:j+1,k:k+1,t1)
                where(tmp==0)tmp=maxval(tmp)
                call interp_trilinear(dic(ip,IPP),djc(ip,IPP),dkc(ip,IPP),tmp,tmp1)
                tsg(ip,3,IPP) = (tmp1-tmp0)*dtp + tmp0

                if (trim(fn_PHIHYD) .ne. '') then
                    call interp_bilinear(dic(ip,IPP),djc(ip,IPP),phihyd(i:i+1,j:j+1),tmp0)
                    tsg(ip,4,IPP) = tmp0
                endif

            endif
    enddo
!$OMP END PARALLEL DO


end subroutine interp_tracer
