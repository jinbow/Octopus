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
                      dive_depth,fixedangle,absv,&
                      uv_factor,w_factor
#endif

#ifdef isArgo
    namelist /PARAMA/ parking_time,surfacing_time,parking_depth,max_depth
#endif

#ifdef one_file_per_step
    namelist /PARAM/ casename,path2uvw,path2grid,&
        dt,tend,&
        pickup,pickupFreq,saveFreq,diagFreq,tstart,FnPartiInit,&
        target_density,dt_reinit,dt_mld,dt_case,&
        Khdiff,Kvdiff,NPP,Npts,output_dir,fn_PHIHYD,fn_MLD,DumpClock,&
#else
    namelist /PARAM/ casename,path2uvw,path2grid,&
        dt,tend, fn_UVEL, fn_VVEL, fn_WVEL, fn_THETA, fn_SALT, fn_GAMMA,&
        pickup,pickupFreq,saveFreq,diagFreq,tstart,FnPartiInit,&
        target_density,dt_reinit,dt_mld,dt_case,&
        Khdiff,Kvdiff,NPP,Npts,output_dir,fn_PHIHYD,fn_MLD,DumpClock,&
#endif
        barrier_north,barrier_south,barrier_east,barrier_west





    OPEN (UNIT=212, FILE='data.nml')
    read (212,NML=PARAM) !from the namelist file
    close(212)

#ifdef isGlider

    OPEN (UNIT=212, FILE='data.glider.nml')
    read (212,NML=PARAMG) !from the namelist file
    close(212)

    print*, '====', dive_depth,parking_time,fixedangle

#endif

#ifdef isArgo

    OPEN (UNIT=212, FILE='data.Argo.nml')
    read (212,NML=PARAMA) !from the namelist file
    close(212)
#endif


end subroutine read_namelist


