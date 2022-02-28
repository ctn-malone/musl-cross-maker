STAT = -static --static
FLAG = -g0 -O2 -fno-align-functions -fno-align-jumps -fno-align-loops -fno-align-labels
ifneq ($(NATIVE),)
COMMON_CONFIG += CC="$(HOST)-gcc ${STAT}" CXX="$(HOST)-g++ ${STAT}" FC="$(HOST)-gfortran ${STAT}"
else
COMMON_CONFIG += CC="gcc ${STAT}" CXX="g++ ${STAT}" FC="gfortran ${STAT}"
endif
COMMON_CONFIG += CFLAGS="${FLAG}" CXXFLAGS="${FLAG}" FFLAGS="${FLAG}" LDFLAGS="-s ${STAT}"
COMMON_CONFIG += --disable-nls --disable-bootstrap

GCC_VER = 6.5.0
BINUTILS_VER = 2.25.1
#MUSL_VER = git-a60b9e06861e56c0810bae0249b421e1758d281a
MUSL_VER = 1.2.2
GMP_VER = 6.1.2
MPC_VER = 1.1.0
MPFR_VER = 4.0.2

LINUX_VER = 4.19.44
