subroutine read_namelist()
    !=========================================
    !      read configuration file
!    use global, only : casename,path2uvw,path2grid,&
!        dt,dt_reinit,tend,dt_case,&
!        dt_mld,pickupFreq,pickup,saveFreq,diagFreq,tstart,FnPartiInit,&
!        target_density,Khdiff,Kvdiff,NPP,Npts,output_dir,&
!        fn_PHIHYD,fn_MLD,DumpClock

    use global

    implicit none

    namelist /PARAM/ casename,path2uvw,path2grid,&
        dt,tend,&
        pickup,pickupFreq,saveFreq,diagFreq,tstart,FnPartiInit,&
        target_density,dt_reinit,dt_mld,dt_case,&
        Khdiff,Kvdiff,NPP,Npts,output_dir,fn_PHIHYD,fn_MLD,DumpClock

    OPEN (UNIT=212, FILE='data.nml')
    read (212,NML=PARAM) !from the namelist file
    close(212)

#ifdef isGlider
    namelist /PARAMG/ parking_time,surfacing_time,dive_depth

    OPEN (UNIT=212, FILE='data.glider.nml')
    read (212,NML=PARAMG) !from the namelist file
    close(212)


#endif

end subroutine read_namelist


