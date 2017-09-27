subroutine read_namelist()
#include "cpp_options.h"
    !=========================================
    !      read configuration file
!    use global, only : casename,path2uvw,path2grid,&
!        dt,dt_reinit,tend,dt_case,&
!        dt_mld,pickupFreq,pickup,saveFreq,diagFreq,tstart,FnPartiInit,&
!        target_density,Khdiff,Kvdiff,NPP,Npts,output_dir,&
!        fn_PHIHYD,fn_MLD,DumpClock

    use global

    implicit none

#ifdef isGlider
    namelist /PARAMG/ parking_time,surfacing_time,&
                      dive_depth,absv,dive_angle
#endif

    namelist /PARAM/ casename,path2uvw,path2grid,&
        dt,tend,&
        pickup,pickupFreq,saveFreq,diagFreq,tstart,FnPartiInit,&
        target_density,dt_reinit,dt_mld,dt_case,&
        Khdiff,Kvdiff,NPP,Npts,output_dir,fn_PHIHYD,fn_MLD,DumpClock

    OPEN (UNIT=212, FILE='data.nml')
    read (212,NML=PARAM) !from the namelist file
    close(212)

#ifdef isGlider

    OPEN (UNIT=212, FILE='data.glider.nml')
    read (212,NML=PARAMG) !from the namelist file
    close(212)

    print*, '====', dive_depth,parking_time

#endif

end subroutine read_namelist


