# ============================================================================
# Name        : Makefile
# Author      : Jinbo Wang <jinbow@gmail.com>
# Version     : 1.0
# Copyright   : MIT License
# Description : Lagrangian integration
# ============================================================================

objects = global.o allocate_vars.o interp_tracer.o \
          random.o driver_omp.o  io.o  get_particle_index.o \
          get_velocity.o rk4.o interp_trilinear.o \
          apply_jump.o init_particles.o mixing.o read_namelist.o \
          apply_boundaryCondition.o utils.o c_filenames.o  read_pickup.o\
          save_pickup.o load_reflect.o load_depth.o mixing_mld.o\
          check_and_save.o calc_parameters.o get_glider_velocity.o\
          calc_gradient.o interp_bilinear.o set_file_ids.o get_roms_depth.o

obj_argo = global.o allocate_vars.o \
          random.o driver_omp.o  io.o  get_particle_index.o \
          get_velocity.o rk4.o interp_trilinear.o \
          init_particles.o mixing.o read_namelist.o \
          utils.o open_files.o close_files.o read_pickup.o\
          save_pickup.o load_depth.o c_filenames.o \
          check_and_save.o calc_parameters.o  interp_bilinear.o\
          get_argo_w.o set_file_ids.o interp_tracer.o get_roms_depth.o

obj_glider= global.o allocate_vars.o interp_tracer.o \
          random.o driver_omp.o  io.o  get_particle_index.o \
          get_velocity.o rk4.o interp_trilinear.o \
          apply_jump.o init_particles.o mixing.o read_namelist.o \
          apply_boundaryCondition.o utils.o open_files.o close_files.o read_pickup.o\
          save_pickup.o load_reflect.o load_depth.o mixing_mld.o c_filenames.o \
          check_and_save.o calc_parameters.o  calc_gradient.o interp_bilinear.o\
          get_glider_velocity.o set_file_ids.o get_roms_depth.o
	
FORTRAN_COMPILER = gfortran

#FFLAGS = -x f95-cpp-input  -Wall -fopenmp -O3 -mcmodel=large -fdefault-integer-8 -fdefault-real-8
FFLAGS = -x f95-cpp-input -fopenmp -O3 -mcmodel=large -fdefault-integer-8 -fdefault-real-8

opt: $(objects); $(FORTRAN_COMPILER) -o O.particle -fopenmp $(objects)

argo: $(obj_argo); $(FORTRAN_COMPILER) -o O.argo -fopenmp $(obj_argo)

glider: $(obj_glider); $(FORTRAN_COMPILER) -o O.glider -fopenmp $(obj_glider)

%.o: %.f90; $(FORTRAN_COMPILER) ${FFLAGS} -c $<

clean: 
	rm *.o *.mod
