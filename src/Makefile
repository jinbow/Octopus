# ============================================================================
# Name        : Makefile
# Author      : Jinbo Wang <jinbow@gmail.com>
# Version     : 1.0
# Copyright   : MIT
# Description : Lagrangian integration
# ============================================================================

objects = global.o allocate_vars.o interp_tracer.o \
          random.o driver_omp.o  io.o  c_find_particle_index.o \
          c_find_uvw.o c_forward_rk4.o c_interp_trilinear.o \
          c_loop_jump.o init_particles.o c_mixing.o r_namelist.o \
          c_set_boundary.o utils.o open_files.o close_files.o read_pickup.o\
          save_pickup.o save_data.o load_reflect.o load_depth.o load_3d.o \
          check_and_save.o calc_parameters.o load_data.o c_gradient.o c_interp_bilinear.o

obj_argo = $(objects) get_argo_w.o
	
FORTRAN_COMPILER = gfortran

FFLAGS = -cpp -Wall -fopenmp -O3 -mcmodel=large -fdefault-integer-8 -fdefault-real-8

opt: $(objects); $(FORTRAN_COMPILER) -o O.particle -fopenmp $(objects)

argo: $(obj_argo); $(FORTRAN_COMPILER) -o O.argo -fopenmp $(obj_argo)

%.o: %.f90; $(FORTRAN_COMPILER) ${FFLAGS} -c $<

clean: 
	rm *.o *.mod
