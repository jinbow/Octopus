#include "cppdefs.h"
#ifdef allow_particle

MODULE particles
  USE header, ONLY :
NI,NJ,NK,uf,vf,wf,Jifc,Jjfc,J2d,ux,vy,NPR,wz,PI,dtf,vor,shear,rho,strain,zf,&
                    &s,parti_file_num,DL,rc_kind, pcx, pcy, pcz, pcr,
dirout

  ! define the class for particles
  TYPE particle
     REAL(kind=rc_kind) ::
i,j,k,x,y,z,u,v,w,s,t,u0,v0,w0,id,vor,strain,shear,rho,time
  END TYPE particle

  TYPE (particle), DIMENSION(:), ALLOCATABLE :: parti
  REAL(kind=rc_kind) ::  dz,swap1,swap2,swap3
  INTEGER,ALLOCATABLE :: file_id(:)
  INTEGER :: NPR_eachfile
  CHARACTER(len=3) :: file_id_char 

  PRIVATE   :: NPR_eachfile, file_id_char, dz, swap1, swap2, swap3,
file_id
  PUBLIC    :: parti

CONTAINS

  SUBROUTINE open_parti_files()
    IMPLICIT NONE
    INTEGER :: fi

    ALLOCATE (file_id(parti_file_num)) 
    IF (MOD(NPR,parti_file_num) .NE. 0) THEN
      PRINT*, "Error: Please make sure NPR/file_num = integer in
mod_particles.f90"
      PRINT*, "Stop model"
      STOP
    ENDIF

    NPR_eachfile = NPR/parti_file_num !the particle number in each file
    ! PRINT*, "# each file contains ",NPR_eachfile,"particles"

    !open files
    DO fi = 1, parti_file_num
      WRITE(file_id_char,'(I3.3)') fi
      file_id(fi) = 2000 + fi
      OPEN(file_id(fi), file =
TRIM(dirout)//'op.parti-'//file_id_char//'.bin', &
          &form = 'unformatted', access = 'stream', status = 'replace')
      ! PRINT*, "open file
      ! "//TRIM(dirout)//'op.parti-'//file_id_char//'.bin'
    ENDDO

  END SUBROUTINE open_parti_files

  SUBROUTINE save_parti()
    IMPLICIT NONE
    INTEGER :: i_file,i

    PRINT*,"SAVE PARTICLES"
    SELECT CASE(0)
    CASE (0)
       !save limited variables
       DO i_file = 1, parti_file_num
          DO i = (i_file - 1) * NPR_eachfile + 1, i_file * NPR_eachfile
             WRITE(file_id(i_file)) parti(i)%i, &
                  parti(i)%j, &
                  parti(i)%k, &
                  parti(i)%z, &
                  !parti(i)%u, &
                  !parti(i)%v, &
                  parti(i)%w, &
                  parti(i)%rho, &
                  !parti(i)%s,   &
                  !parti(i)%t,   &
                  parti(i)%vor, &
                  parti(i)%shear, &
                  parti(i)%strain
          ENDDO
       ENDDO

    END SELECT

  END SUBROUTINE save_parti


  SUBROUTINE ini_particles(time)
    IMPLICIT NONE
    INTEGER :: i,j,k,time,itmp,npr_eachline
    REAL(kind=rc_kind) ::  rand,r,theta, x1, y1
    INTEGER,PARAMETER :: seed = 86456  

    ! PRINT*, "initialize files to save particles"
    CALL open_parti_files()

    CALL RANDOM_SEED()

    ! PRINT*, "# ini particles' velocities",NPR
    DO i=1, NPR
       parti(i)%time = DBLE(time)
       parti(i)%u0=0d0
       parti(i)%v0=0d0
       parti(i)%w0=0d0
       parti(i)%u=0d0
       parti(i)%v=0d0
       parti(i)%w=0d0
       parti(i)%t=0d0
       parti(i)%s=0d0
       parti(i)%rho=0d0
       parti(i)%vor=0d0
       parti(i)%shear=0d0
       parti(i)%strain=0d0
    ENDDO
    ! PRINT*, "# finish intial particles' velocities"

    DO i=1, NPR
      parti(i)%i=REAL(i*REAL(NI)/REAL(NPR))
      parti(i)%j=90.
      parti(i)%k=2.
    ENDDO
 
  END SUBROUTINE ini_particles


  SUBROUTINE get_parti_vel(time)
    IMPLICIT NONE
    INTEGER :: i,j,k,ip,ic,jc,kc,ifc,jfc,kfc,time
    REAL(kind=rc_kind) ::  dic,djc,dkc,dif,djf,dkf
    REAL(kind=rc_kind), DIMENSION(    0:NI,0:NJ+1        )        :: uxf
    REAL(kind=rc_kind), DIMENSION(    0:NI+1,0:NJ        )        :: vyf
    REAL(kind=rc_kind), DIMENSION(    0:NI+1,0:NJ+1,0:NK )        :: wzf
    REAL(kind=rc_kind), DIMENSION(      NI,  0:NJ,     NK)        :: vfp
    REAL(kind=rc_kind), DIMENSION(    0:NI+1,0:NJ,   0:NK+1)      ::
vf_ex
    REAL(kind=rc_kind), DIMENSION(    0:NI,    NJ,     NK)        :: ufp
    REAL(kind=rc_kind), DIMENSION(    0:NI,  0:NJ+1, 0:NK+1)      ::
uf_ex
    REAL(kind=rc_kind), DIMENSION(      NI,    NJ,   0:NK)        :: wfp
    REAL(kind=rc_kind), DIMENSION(    0:NI+1,0:NJ+1, 0:NK)        ::
wf_ex

    !rearrange the ux and vy to face grids
    !uxf = 0.5d0*(ux(0:NI,:)+ux(1:NI+1,:))
    !vyf = 0.5d0*(vy(:,0:NJ)+vy(:,1:NJ+1))
    wzf = 0.5d0*(wz(:,:,0:NK) + wz(:,:,1:NK+1))

    !calculate the face velocity
    k=0
    wfp(:,:,k) = wf(:,:,k)/J2d(1:NI,1:NJ)*wzf(1:NI,1:NJ,k)

    DO k = 1, NK
       ufp(:,:,k) = uf(:,:,k)/Jifc(:,:,k)
       vfp(:,:,k) = vf(:,:,k)/Jjfc(:,:,k)
       wfp(:,:,k) = wf(:,:,k)/J2d(1:NI,1:NJ)*wzf(1:NI,1:NJ,k)
    ENDDO
    uf_ex=0d0
    uf_ex(:,1:NJ,1:NK) = ufp
    !=== vertical extrapolation
    uf_ex(:,:,NK+1) = 2*uf_ex(:,:,NK)-uf_ex(:,:,NK-1) ! extrapolation

    vf_ex=0d0
    vf_ex(1:NI,:,1:NK) = vfp
    !=== zonally periodic
    vf_ex(0,:,:) = vf_ex(NI,:,:)
    vf_ex(NI+1,:,:)=vf_ex(1,:,:)
    !=== vertical extrapolation
    vf_ex(:,:,NK+1) = 2*vf_ex(:,:,NK)-vf_ex(:,:,NK-1)

    wf_ex=0d0
    wf_ex(1:NI,1:NJ,:) = wfp
    !===zonal periodic condition
    wf_ex(0,:,:) = wf_ex(NI,:,:)
    wf_ex(NI+1,:,:) = wf_ex(1,:,:)
    !===
    DO ip = 1, NPR
       parti(ip)%time=DBLE(time)
       IF (parti(ip)%j < NJ .AND. parti(ip)%j > 0 .AND. &
            parti(ip)%k < NK .AND. parti(ip)%k > 0) THEN
          !ic, jc, kc, is the integer index of the particle relative to 
          !the grids center. Use these values for variables with the
          !ghost points.
          !ifc, jfc, and kfc is the index relative to the coordinates of
          !grid faces. 
          !Use these values for variables on faces.
          ic = INT(parti(ip)%i+0.5d0)
          jc = INT(parti(ip)%j+0.5d0)
          kc = INT(parti(ip)%k+0.5d0)

          ifc = INT(parti(ip)%i)
          jfc = INT(parti(ip)%j)
          kfc = INT(parti(ip)%k)

          dif = parti(ip)%i - ifc
          djf = parti(ip)%j - jfc
          dkf = parti(ip)%k - kfc

          !call sigma2z(ifc,jfc,parti(ip)%k,parti(ip)%z)
          !dzf is the normalized distance of a particle to bottom faces.
          !dzf = (parti(ip)%z - zf(ifc,jfc,kfc)) / ( zf(ifc,jfc,kfc+1) -
          !zf(ifc,jfc,kfc) )

          dic = parti(ip)%i - ic + 0.5d0
          djc = parti(ip)%j - jc + 0.5d0
          dkc = parti(ip)%k - kc + 0.5d0
          !calcuate the zonal velocity 
          CALL
          Csigma2z(parti(ip)%i,parti(ip)%j+0.5d0,parti(ip)%k+0.5,swap1)
          CALL sigma2z(parti(ip)%i,parti(ip)%j+0.5d0,dble(kc),swap2)
          CALL sigma2z(parti(ip)%i,parti(ip)%j+0.5d0,dble(kc+1),swap3)
          dz = (swap1 - swap2) / ( swap3 - swap2 )

          CALL
          Cinterp_trilinear(dif,djc,dz,uf_ex(ifc:ifc+1,jc:jc+1,kc:kc+1),parti(ip)%u)
          !CALL
          !interp_trilinear(dif,djc,dkc,uf_ex(ifc:ifc+1,jc:jc+1,kc:kc+1),parti(ip)%u)

          !calcuate the meridional velocity
          CALL
          Csigma2z(parti(ip)%i+0.5d0,parti(ip)%j,parti(ip)%k+0.5d0,swap1)
          CALL sigma2z(parti(ip)%i+0.5d0,parti(ip)%j,dble(kc),swap2)
          CALL sigma2z(parti(ip)%i+0.5d0,parti(ip)%j,dble(kc+1),swap3)
          dz = (swap1 - swap2) / ( swap3 - swap2 )
          CALL
          Cinterp_trilinear(dic,djf,dz,vf_ex(ic:ic+1,jfc:jfc+1,kc:kc+1),parti(ip)%v)
          !CALL
          !interp_trilinear(dic,djf,dkc,vf_ex(ic:ic+1,jfc:jfc+1,kc:kc+1),parti(ip)%v)

          !calcuate the vertical velocity
          CALL sigma2z(parti(ip)%i,parti(ip)%j,parti(ip)%k,swap1)
          CALL sigma2z(parti(ip)%i,parti(ip)%j,dble(kfc),swap2)
          CALL sigma2z(parti(ip)%i,parti(ip)%j,dble(kfc+1),swap3)
          dz = (swap1 - swap2) / ( swap3 - swap2 )
          parti(ip)%z=swap1*DL
          CALL
          Cinterp_trilinear(dic,djc,dz,wf_ex(ic:ic+1,jc:jc+1,kfc:kfc+1),parti(ip)%w)
          !CALL
          !interp_trilinear(dic,djc,dkf,wf_ex(ic:ic+1,jc:jc+1,kfc:kfc+1),parti(ip)%w)

          !diagnose other properties
          CALL
          Csigma2z(parti(ip)%i+0.5d0,parti(ip)%j+0.5d0,parti(ip)%k+0.5d0,swap1)
          CALL
          Csigma2z(parti(ip)%i+0.5d0,parti(ip)%j+0.5d0,dble(kc),swap2)
          CALL
          Csigma2z(parti(ip)%i+0.5d0,parti(ip)%j+0.5d0,dble(kc+1),swap3)
          dz = (swap1 - swap2) / ( swap3 - swap2 )

          CALL
          Cinterp_trilinear(dic,djc,dz,vor(ic:ic+1,jc:jc+1,kc:kc+1),parti(ip)%vor)
          CALL
          Cinterp_trilinear(dic,djc,dz,rho(ic:ic+1,jc:jc+1,kc:kc+1),parti(ip)%rho)
          CALL
          Cinterp_trilinear(dic,djc,dz,shear(ic:ic+1,jc:jc+1,kc:kc+1),parti(ip)%shear)
          CALL
          Cinterp_trilinear(dic,djc,dz,strain(ic:ic+1,jc:jc+1,kc:kc+1),parti(ip)%strain)
!!$          if (ip == 8001) then
!!$          print*, 'dkc,dz=',dkc,dz
!!$          print*, 'dic,djc',dic,djc
!!$          Print*, 'rho=',rho(ic:ic+1,jc:jc+1,kc:kc+1)
!!$          print*, 'parti(ip)rho=',parti(ip)%rho
!!$          endif
          !CALL
          !interp_trilinear(dic,djc,dkc,vor(ic:ic+1,jc:jc+1,kc:kc+1),parti(ip)%vor)
          !CALL
          !interp_trilinear(dic,djc,dkc,s(ic:ic+1,jc:jc+1,kc:kc+1,0),parti(ip)%vor)
          !CALL
          !interp_trilinear(dic,djc,dkc,shear(ic:ic+1,jc:jc+1,kc:kc+1),parti(ip)%shear)
          !CALL
          !interp_trilinear(dic,djc,dkc,strain(ic:ic+1,jc:jc+1,kc:kc+1),parti(ip)%strain)
          !parti(ip)%shear = dz
          !parti(ip)%strain = dkc
          !parti(ip)%r = rho(ic:ic+1,jc:jc+1,kc:kc+1)

       ELSE
          parti(ip)%u=0d0
          parti(ip)%v=0d0
          parti(ip)%w=0d0
       ENDIF
    ENDDO
    ! get the zonal velocity u

  END SUBROUTINE get_parti_vel

  SUBROUTINE parti_forward()
    IMPLICIT NONE
    INTEGER :: i
    DO i = 1, NPR
       parti(i)%i = parti(i)%i + 0.5d0 * dtf * (3d0 * parti(i)%u -
parti(i)%u0)
       IF (parti(i)%i >NI)   parti(i)%i = parti(i)%i - REAL(NI)
       IF (parti(i)%i <0d0 ) parti(i)%i = parti(i)%i + REAL(NI)

       IF (parti(i)%j>NJ-1 .AND. parti(i)%v>0) THEN
          parti(i)%j = parti(i)%j + parti(i)%v * dtf / (1d0 +
(parti(i)%v * dtf)/(DBLE(NJ) - parti(i)%j) )
       ELSE IF (parti(i)%j<1 .AND. parti(i)%v<0) THEN
          parti(i)%j = parti(i)%j + parti(i)%v * dtf / ( 1d0 -
dtf/parti(i)%j )
       ELSE
          parti(i)%j = parti(i)%j + 0.5d0 * dtf * (3d0 * parti(i)%v -
parti(i)%v0)
       ENDIF

       IF (parti(i)%k>NK-1 .AND. parti(i)%w>0) THEN
          parti(i)%k = parti(i)%k + parti(i)%w * dtf / (1d0 +
(parti(i)%w * dtf)/(DBLE(NK) - parti(i)%k) )
       ELSE IF (parti(i)%k<1 .AND. parti(i)%w<0) THEN
          parti(i)%k = parti(i)%k + parti(i)%w * dtf / ( 1d0 -
dtf/parti(i)%k ) 
       ELSE
          parti(i)%k = parti(i)%k + 0.5d0 * dtf * (3d0 * parti(i)%w -
parti(i)%w0)
       ENDIF

       !debug part
       IF (parti(i)%j<0d0 .OR. parti(i)%j>NJ .OR. parti(i)%k>NK .OR.
parti(i)%k<0d0 ) THEN
          PRINT*, "particles coordinates are wrong,
iPR=",i,"j,k",parti(i)%j,parti(i)%k
          !stop
       ENDIF

       parti(i)%u0 = parti(i)%u
       parti(i)%v0 = parti(i)%v
       parti(i)%w0 = parti(i)%w
    ENDDO

  END SUBROUTINE parti_forward


  SUBROUTINE interp_trilinear(di,dj,dk,var,velp)
    !== give 8 corner points of a cube, interpolate point values inside
    !of the cube
    !== di is the distance between the particle to the left face
    !== dj is the distance between the particle to the southern face
    !== dk is the distance between the particle and the bottom face
    IMPLICIT NONE
    REAL(kind=rc_kind), INTENT(in) :: di,dj,dk
    REAL(kind=rc_kind), INTENT(in), DIMENSION(    2,    2  ,   2  )
:: var
    REAL(kind=rc_kind), INTENT(out) :: velp
    REAL(kind=rc_kind) ::  i1,i2,i3,i4,j1,j2,ti,tj,tk

    ! calcuate the Trilinear interpolation
    i1 = (var(2,1,  1)   - var(1,1,  1))*di + var(1,1,  1)
    i2 = (var(2,1,  2) - var(1,1,2))*di + var(1,1,  2)
    i3 = (var(2,2,2) - var(1,2,2))*di +var(1,2,2)
    i4 = (var(2,2,1)   - var(1,2,1))*di + var(1,2,1)

    j1 = (i3 - i2)*dj + i2
    j2 = (i4 - i1)*dj + i1

    velp = (j1 - j2) * dk + j2
    !print*, 'dz,j1,j2,velp=',dk,j1,j2,velp
  END SUBROUTINE interp_trilinear

  SUBROUTINE  get_parti_vel_ana()
    INTEGER :: ip
    DO ip = 1, NPR
       parti(ip)%u =
-1*SIN(pi*parti(ip)%i/REAL(NI))*COS(pi*parti(ip)%j/REAL(NJ))
       parti(ip)%v =
COS(pi*parti(ip)%i/REAL(NI))*SIN(pi*parti(ip)%j/REAL(NJ))
    ENDDO
  END SUBROUTINE get_parti_vel_ana


END MODULE particles

#endif
