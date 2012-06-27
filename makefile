#!/usr/sh
########################################################################
# Makefile for parallel MD
#     by Ryo Kobayashi
########################################################################

# cpp path
CPP= gcc -E

#-----------------------------------------------------------------------
# ifort and linux (pen4)
#FC= ifort
#FFLAGS= -O3 -ip 
#MPIFC= /usr/local/gridmpi-2.0/intel/bin/mpif90
#MPIFC= /usr/local/mpich-1.2.6/intel/bin/mpif90
MPIFC= /usr/local/openmpi-1.2.8-intel64-v11.0.081/bin/mpif90
# MPIFC= mpif90
MPIFLAGS= -xHOST -O3 -ip -no-prec-div -g -CB

#CPPFLAGS= -D__SHEAR__ -D__DISL__
CPPFLAGS=
#-----------------------------------------------------------------------
# # for mp-rk
# MPIFC= mpif90
# MPIFLAGS= -O4 -g
#-----------------------------------------------------------------------
# suffixes
.SUFFIXES: .o .f .F .f90 .F90
.f.o: 
	$(MPIFC) -c $(MPIFLAGS) $<
.F.o: 
	$(MPIFC) -c $(MPIFLAGS) $(CPPFLAGS) $<
.f90.o: 
	$(MPIFC) -c $(MPIFLAGS) $<
.F90.o: 
	$(MPIFC) -c $(MPIFLAGS) $(CPPFLAGS) $<

pmd= read_input.o parallel_md.o util_vec.o routines_dislocation.o
mods= mod_variables.o

#-----------------------------------------------------------------------
# Uncomment only one force routine
# (These provide same 'get_force' routines)
#-----------------------------------------------------------------------
# force= force_LJ_Ar.o
# params= params_LJ_Ar.h
# force= force_EAM_Al.o
# params= params_EAM_Al.h
# force= force_EAM_Fe.o
# params= params_EAM_Fe.h
force= force_EAM_Fe-H.o
params= params_EAM_Fe-H.h
# force= force_Brenner.o
# params= params_Brenner.h
# force= force_SW_Si.o
# params= params_SW_Si.h
# force= force_EDIP_Si.o
# params= params_EDIP_Si.h
# force= force_Vashishta_AlN.o
# params= params_Vashishta_AlN.h
# force= force_RK_wurtzite.o
# params= params_RK_wurtzite.h
# force= force_RK_VLS1.o
# params= params_RK_VLS1.h

#-----mkconf program selection
# mkconf= mkconf_Al_fcc.F
# mkconf= mkconf_Al_FCC_edge-disl.o
# mkconf= mkconf_2D_2kind.o
# mkconf= mkconf_2D_edge_disl.o
# mkconf= mkconf_Al_fcc_nanorod.o
# mkconf= mkconf_Si111_2lc.o
mkconf= mkconf_BCC.o

#-----------------------------------------------------------------------
# Post process programs
#
comb= combine_pmd.o read_input.o


#-----------------------------------------------------------------------
# Make rule entries
#
all: 10mkconf 20nconv pmd 40combine akr2cna akr2pot boxsize rdpmd

clean:
	rm -f *.o *.mod *~ 10mkconf 20nconv pmd 40combine akr2cna \
		akr2pot boxsize rdpmd

install: pmd 10mkconf 20nconv
	cp pmd 10mkconf 20nconv ../

10mkconf: ${mkconf} util_pmd.o
	${MPIFC} -o $@ ${mkconf} util_pmd.o

20nconv: node_conv.o $(mods) read_input.o util_pmd.o
	${MPIFC} -o $@ $(mods) node_conv.o read_input.o util_pmd.o

pmd: $(mods) ${pmd} ${force} ${params}
	${MPIFC} ${MPIFLAGS} -o $@ $(mods) ${force} ${pmd}

40combine: $(comb) $(mods)
	${MPIFC} -o $@  $(mods) $(comb)

akr2cna: akr2cna.o sort.o
	${MPIFC} -o $@ akr2cna.o sort.o

akr2pot: akr2pot.o
	${MPIFC} -o $@ akr2pot.o

rdpmd: read_pmd.o $(mods)
	$(MPIFC) -o $@ read_pmd.o $(mods)

boxsize: change_pmd_boxsize.o $(mods)
	$(MPIFC) -o $@ change_pmd_boxsize.o $(mods)

#.....Module dependencies
parallel_md.o: $(mods)
read_input.o:  $(mods)
node_conv.o:   $(mods)
combine_pmd.o: $(mods)


