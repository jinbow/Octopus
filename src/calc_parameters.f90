subroutine calc_parameters()
    use global, only: fn_uvwtsg_ids,nrecs,dt_file,t_amend,&
                      tend,tend_file, Kvdiff,Khdiff,dt,fn_ids,&
                      khdt2,kvdt2,output_dir,fn_id_mld,NPP,&
                      pickup,DumpClock,tt,tstart,rec_num
    implicit none
    integer*8 :: i,j

    tt=tstart
    rec_num = floor(tt/dt_file)+1
    print*, 'record number in calc_par...',rec_num,tt,tstart

    kvdt2 = sqrt(2*Kvdiff*dt)
    khdt2 = sqrt(2*Khdiff*dt)
    !time stepping
    tend_file=nrecs*dt_file
    if (tend<=0) then
        tend = nrecs*dt_file
    endif
    t_amend=real(dt/dt_file/2d0,8)

    call set_file_ids()

end subroutine calc_parameters
