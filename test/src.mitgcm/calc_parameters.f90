subroutine calc_parameters()
    use global, only: fn_uvwtsg_ids,nrecs,dt_file,t_amend,&
                      tend,tend_file, Kvdiff,Khdiff,dt,fn_ids,&
                      khdt2,kvdt2,output_dir,fn_id_mld,NPP,&
                      pickup,DumpClock,tt,tstart,rec_num
    implicit none
    integer*8 :: i,j

    if (pickup>0) then
        tt=(pickup-1)*DumpClock
        rec_num = floor(tt/dt_file)+1
    else
        tt=tstart
        rec_num = floor(tt/dt_file)+1
    endif
    kvdt2 = sqrt(2*Kvdiff*dt)
    khdt2 = sqrt(2*Khdiff*dt)
    !time stepping
    tend_file=nrecs*dt_file
    if (tend<=0) then
        tend = nrecs*dt_file
    endif
    t_amend=real(dt/dt_file/2d0,8)

    ! file ids
    do i=0,11
       do j=0,NPP-1
        fn_ids(i+1,j+1) = 1000+j*12+i
       enddo
    enddo
    fn_uvwtsg_ids = (/2001,2002,2003,2004,2005,2006,2007/)
    fn_id_mld=3000

    call system('mkdir -p '//trim(output_dir))

end subroutine calc_parameters
