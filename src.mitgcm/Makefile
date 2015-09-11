# ============================================================================
# Name        : Makefile
# Author      : 
# Version     :
# Copyright   : Your copyright notice
# Description : Makefile for Hello World in Fortran
# ============================================================================



objects = global.o allocate_vars.o interp_tracer.o \
          random.o driver_omp.o  io.o  c_find_particle_index.o \
          c_find_uvw.o c_forward_rk4.o c_interp_trilinear.o \
          c_loop_jump.o init_particles.o c_mixing.o r_namelist.o \
          c_set_boundary.o utils.o open_files.o close_files.o read_pickup.o\
          dump_pickup.o dump_data.o load_reflect.o load_depth.o load_3d.o \
          check_and_dump.o calc_parameters.o load_data.o c_gradient.o c_interp_bilinear.o
#objects = global.o random.o thread.o driver_omp.o 
	
FORTRAN_COMPILER = gfortran

FFLAGS = -cpp -Wall -fopenmp -O3 -mcmodel=large -fdefault-integer-8 -fdefault-real-8
#FFLAGS = -cpp -O3 -mcmodel=large

opt: $(objects); $(FORTRAN_COMPILER) -o opt.ensemble -fopenmp $(objects)
#opt: $(objects); $(FORTRAN_COMPILER) -o opt $(objects)

%.o: %.f90; $(FORTRAN_COMPILER) ${FFLAGS} -c $<

clean: 
	rm $(objects) *.mod
