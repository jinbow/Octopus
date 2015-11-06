# ============================================================================
# Name        : Makefile
# Author      : Jinbo Wang <jinbow@gmail.com>
# Version     : 1.0
# Copyright   : MIT
# Description : Lagrangian integration
# ============================================================================

objects = global.o allocate_vars.o interp_tracer.o \
          random.o driver_omp.o  io.o  get_particle_index.o \
          get_velocity.o rk4.o interp_trilinear.o \
          apply_jump.o init_particles.o mixing.o read_namelist.o \
          apply_boundaryCondition.o utils.o open_files.o close_files.o read_pickup.o\
          save_pickup.o load_reflect.o load_depth.o \
          check_and_save.o calc_parameters.o load_data.o calc_gradient.o interp_bilinear.o

obj_argo = global.o allocate_vars.o \
          random.o driver_omp.o  io.o  get_particle_index.o \
          get_velocity.o rk4.o interp_trilinear.o \
          apply_jump.o init_particles.o mixing.o read_namelist.o \
          apply_boundaryCondition.o utils.o open_files.o close_files.o read_pickup.o\
          save_pickup.o load_reflect.o load_depth.o \
          check_and_save.o calc_parameters.o load_data.o interp_bilinear.o get_argo_w.o
	
FORTRAN_COMPILER = gfortran

FFLAGS = -cpp -Wall -fopenmp -O3 -mcmodel=large -fdefault-integer-8 -fdefault-real-8

opt: $(objects); $(FORTRAN_COMPILER) -o O.particle -fopenmp $(objects)

argo: $(obj_argo); $(FORTRAN_COMPILER) -o O.argo -fopenmp $(obj_argo)

%.o: %.f90; $(FORTRAN_COMPILER) ${FFLAGS} -c $<

clean: 
	rm *.o *.mod
