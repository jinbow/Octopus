subroutine read_namelist()
    !=========================================
    !      read configuration file
    use global, only : casename,path2uvw,path2grid,&
        dt,dt_reinit,tend,dt_case,&
        dt_mld,pickupFreq,pickup,saveFreq,diagFreq,tstart,fn_parti_init,&
        target_density,Khdiff,Kvdiff,NPP,Npts,output_dir,&
        fn_PHIHYD,fn_MLD,DumpClock
    implicit none
!    integer*8, intent(in) :: inml
!    character*32 :: fn

    namelist /PARAM/ casename,path2uvw,path2grid,&
        dt,tend,&
        pickup,pickupFreq,saveFreq,diagFreq,tstart,fn_parti_init,&
        target_density,dt_reinit,dt_mld,dt_case,&
        Khdiff,Kvdiff,NPP,Npts,output_dir,fn_PHIHYD,fn_MLD,DumpClock

!    read (*,NML=PARAM)
!from the namelist file
!    write(fn,"(I4.4)") inml
!    print*, 'NML.DP_'//fn
    OPEN (UNIT=212, FILE='data.nml')
    read (212,NML=PARAM) !from the namelist file
    close(212)

end subroutine read_namelist


