!> \file gmtb_scm_output.f90
!!  Contains output-related subroutines

module gmtb_scm_output

use netcdf
use gmtb_scm_input, only: check
use gmtb_scm_kinds, only: sp, dp, qp

implicit none

contains

!> \ingroup SCM
!! @{
!! \defgroup output gmtb_scm_output
!! @{
!! Contains output-related subroutines

!> This subroutine initializes the output netCDF file, "output.nc", placed in the directory specified by the case_config file used.
subroutine output_init(scm_state)
  use gmtb_scm_type_defs, only: scm_state_type

  type(scm_state_type), intent(in) :: scm_state

  INTEGER :: ncid, time_id, hor_dim_id, vert_dim_id, vert_dim_id2,vert_dim_i_id, dummy_id, year_id, month_id, day_id, hour_id
  !> \section output_init_alg Algorithm
  !! @{

  !> - Create the output file in the output directory.
  CALL CHECK(NF90_CREATE(PATH=TRIM(scm_state%output_dir)//"/"//TRIM(scm_state%output_file)//".nc",CMODE=NF90_CLOBBER,NCID=ncid))

  !> - Define netCDF dimensions.
  CALL CHECK(NF90_DEF_DIM(NCID=ncid,NAME="time_dim",LEN=NF90_UNLIMITED,DIMID=time_id))
  CALL CHECK(NF90_DEF_DIM(NCID=ncid,NAME="hor_dim_layer",LEN=scm_state%n_cols,DIMID=hor_dim_id))
  CALL CHECK(NF90_DEF_DIM(NCID=ncid,NAME="vert_dim_layer",LEN=scm_state%n_levels,DIMID=vert_dim_id))
  CALL CHECK(NF90_DEF_DIM(NCID=ncid,NAME="vert_dim_soil",LEN=scm_state%n_soil,DIMID=vert_dim_id2))
  CALL CHECK(NF90_DEF_DIM(NCID=ncid,NAME="vert_dim_interface",LEN=scm_state%n_levels+1,DIMID=vert_dim_i_id))

  !> - Define the dimension variables.
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME="time",XTYPE=NF90_FLOAT,DIMIDS=(/ time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="model elapsed time"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="s"))

  !> - Define the pressure-related variables.
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='pres',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="pressure on model layer centers"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="Pa"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='pres_i',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_i_id, time_id /), &
    VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="pressure on model layer interfaces"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="Pa"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='sigma',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="sigma (p/p_s) on model layer centers"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="none"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='sigma_i',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_i_id, time_id /), &
    VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="sigma (p/p_s) on model layer interfaces"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="none"))
  ! CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='phi',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), VARID=dummy_id))
  ! CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='phi_i',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_i_id, time_id /), &
  !   VARID=dummy_id))

  !> - Define the state variables.
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='qv',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",&
    VALUES="water vapor specific humidity on model layer centers"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="kg kg-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='T',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="absolute temperature on model layer centers"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="K"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='u',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="x-wind on model layer centers"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="m s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='v',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="y-wind on model layer centers"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="m s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='ql',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="suspended cloud water on model layer centers"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="kg kg-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='qi',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="suspended cloud ice on model layer centers"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="kg kg-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='qs',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="suspended snow on model layer centers"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="kg kg-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='qr',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="suspended rain on model layer centers"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="kg kg-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='qg',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="suspended graupel on model layer centers"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="kg kg-1"))

  !> - Define the forcing-related variables.
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='qv_force_tend',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
    VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",&
    VALUES="total forcing tendency for water vapor specific humidity"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="kg kg-1 s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='T_force_tend',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
    VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",&
    VALUES="total forcing tendency for absolute temperature"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="K s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='u_force_tend',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
    VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",&
    VALUES="total forcing tendency for x-wind"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="m s-2"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='v_force_tend',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
    VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",&
    VALUES="total forcing tendency for y-wind"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="m s-2"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='w_ls',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="large-scale vertical velocity forcing"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="m s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='u_g',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="geostrophic x-wind forcing"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="m s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='v_g',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="geostrophic y-wind forcing"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="m s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='dT_dt_rad_forc',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
    VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="prescribed radiative heating rate forcing"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="K s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='h_advec_thil',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
    VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",&
    VALUES="large-scale horizontal advective heating rate for ice-liquid water potential temperature"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="K s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='h_advec_qt',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
    VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",&
    VALUES="large-scale horizontal advective moistening rate for total water specific humidity"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="kg kg-1 s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='v_advec_thil',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
    VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",&
    VALUES="large-scale vertical advective heating rate for ice-liquid water potential temperature"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="K s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='v_advec_qt',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
    VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",&
    VALUES="large-scale vertical advective moistening rate for total water specific humidity"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="kg kg-1 s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='T_s',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="surface temperature"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="K"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='pres_s',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="surface pressure"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="Pa"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='lhf',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="surface latent heat flux"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="W m-2"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='shf',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="surface sensible heat flux"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="W m-2"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='tau_u',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="surface x-wind stress"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="Pa"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='tau_v',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="surface y-wind stress"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="Pa"))

  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='nirbmd',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="near IR beam down flux"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="W m-2"))

  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='nirbmu',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="near IR beam up flux"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="W m-2"))

  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='nirdfd',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="near IR diffuse down flux"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="W m-2"))

  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='nirdfu',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="near IR diffuse up flux"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="W m-2"))

  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='visbmd',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="visible beam down flux"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="W m-2"))

  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='visbmu',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="visible beam up flux"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="W m-2"))

  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='visdfd',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="visible diffuse down flux"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="W m-2"))

  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='visdfu',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="visible diffuse up flux"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="W m-2"))

  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='toaulw',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="TOA upward LW flux"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="W m-2"))

  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='toaulwc',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="TOA upward LW flux clear-ske"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="W m-2"))

  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='toausw',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="TOA upward SW flux"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="W m-2"))

  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='toadsw',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="TOA downward SW flux"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="W m-2"))

  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='toauswc',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="TOA upward SW flux clear-ske"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="W m-2"))

  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='sfcusw',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="surface upward SW flux"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="W m-2"))

  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='sfcdsw',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="surface downward SW flux"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="W m-2"))

  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='sfculw',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="surface upward LW flux"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="W m-2"))

  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='sfcdlw',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="surface downward LW flux"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="W m-2"))

  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='swup',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="upward SW flux"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="W m-2"))

  if (scm_state%model_ics) then
     CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='stc',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id2, time_id /), VARID=dummy_id))
     CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="soil temperature"))
     CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="K"))

     CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='smcref',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id2, time_id /), VARID=dummy_id))
     CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="soil moisture capacity"))
     CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES=""))

     CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='smc',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id2, time_id /), VARID=dummy_id))
     CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="soil moisture"))
     CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES=""))

     CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='slc',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id2, time_id /), VARID=dummy_id))
     CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="soil liquid"))
     CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES=""))

     CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='srunoff',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
     CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="surface runoff"))
     CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="Kg m-2"))

     CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='runoff',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
     CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="total runoff"))
     CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="Kg m-2"))

     CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='drain',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
     CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="subsurface runoff"))
     CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="m timestep -1"))

     CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='canopy',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
     CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="canopy_water_amount"))
     CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="kg m-2"))

     CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='canopy_lhf',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
     CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="canopy_upward_latent_heat_flux"))
     CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="W m-2"))

  endif

  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='swdown',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="downward SW flux"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="W m-2"))

  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='sppt_wts',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="weights for stochastic sppt"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="none"))

  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='shum_wts',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="weights for stochastic shum"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="none"))

  !> - Define the diagnostics variables.
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='cldcov',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
     VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="cloud fraction"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="none"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='cldcov_conv',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
     VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="convective cloud fraction"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="none"))
!  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='ql',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
!     VARID=dummy_id))
!  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="cloud liquid water"))
!  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="kg kg-1"))
!  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='qi',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
!     VARID=dummy_id))
!  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="cloud ice water"))
!  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="kg kg-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='qc_conv',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
     VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="convective total cloud water"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="kg kg-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='sw_rad_heating_rate',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
     VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="shortwave radiative heating rate"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="K s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='lw_rad_heating_rate',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
     VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="longwave radiative heating rate"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="K s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='rain',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="surface total rain rate"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="m s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='rainc',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="surface convective rain rate"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="m s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='pwat',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="column precipitable water"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="kg m-2"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='dT_dt_lwrad',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
     VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",&
    VALUES="temperature tendency due to longwave radiation scheme"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="K s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='dT_dt_swrad',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /),&
     VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",&
   VALUES="temperature tendency due to shortwave radiation scheme"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="K s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='dT_dt_PBL',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
     VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",&
   VALUES="temperature tendency due to PBL scheme"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="K s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='dT_dt_deepconv',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
     VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",&
   VALUES="temperature tendency due to deep convection scheme"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="K s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='dT_dt_shalconv',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
     VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",&
   VALUES="temperature tendency due to shallow convection scheme"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="K s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='dT_dt_micro',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
     VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",&
     VALUES="temperature tendency due to microphysics scheme"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="K s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='dT_dt_gwd',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
     VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",&
     VALUES="temperature tendency due to GWD scheme"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="K s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='dq_dt_PBL',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
     VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",&
     VALUES="moisture tendency due to PBL scheme"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="kg kg-1 s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='dq_dt_deepconv',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
     VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",&
     VALUES="moisture tendency due to deep convection scheme"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="kg kg-1 s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='dq_dt_shalconv',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
     VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",&
     VALUES="moisture tendency due to shallow convection scheme"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="kg kg-1 s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='dq_dt_micro',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id,time_id /), &
     VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",&
     VALUES="cloud condensate tendency due to microphysics scheme"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="kg kg-1 s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='dqc_dt_PBL',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
     VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",&
     VALUES="cloud condensate tendency due to PBL scheme"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="kg kg-1 s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='dqc_dt_deepconv',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
     VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",&
     VALUES="cloud condensate tendency due to deep convection scheme"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="kg kg-1 s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='dqc_dt_shalconv',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
     VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",&
     VALUES="cloud condensate tendency due to shallow convection scheme"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="kg kg-1 s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='dqc_dt_micro',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id,time_id /), &
     VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",&
     VALUES="moisture tendency due to microphysics scheme"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="kg kg-1 s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='du_dt_PBL',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
    VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",&
   VALUES="x-wind tendency due to PBL scheme"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="m s-2"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='du_dt_OGWD',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
    VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",&
   VALUES="x-wind tendency due to orographic GWD scheme"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="m s-2"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='du_dt_deepconv',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
    VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",&
   VALUES="x-wind tendency due to deep convection scheme"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="m s-2"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='du_dt_CGWD',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
    VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",&
   VALUES="x-wind tendency due to convective GWD scheme"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="m s-2"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='dv_dt_PBL',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
    VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",&
   VALUES="y-wind tendency due to PBL scheme"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="m s-2"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='dv_dt_OGWD',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
    VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",&
   VALUES="y-wind tendency due to orographic GWD scheme"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="m s-2"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='dv_dt_deepconv',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
    VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",&
   VALUES="y-wind tendency due to deep convection scheme"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="m s-2"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='dv_dt_CGWD',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id, time_id /), &
    VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",&
   VALUES="y-wind tendency due to convective GWD scheme"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="m s-2"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='upd_mf',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id,time_id /), &
     VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="updraft mass flux"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="kg m-2 s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='dwn_mf',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id,time_id /), &
     VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="downdraft mass flux"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="kg m-2 s-1"))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='det_mf',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, vert_dim_id,time_id /), &
     VARID=dummy_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="description",VALUES="detrainment mass flux"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=dummy_id,NAME="units",VALUES="kg m-2 s-1"))
  ! CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='PBL_height',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  ! CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='sw_up_TOA_tot',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  ! CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='sw_dn_TOA_tot',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  ! CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='sw_up_TOA_clr',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  ! CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='sw_up_sfc_tot',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  ! CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='sw_dn_sfc_tot',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  ! CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='sw_up_sfc_clr',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  ! CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='sw_dn_sfc_clr',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  ! CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='lw_up_TOA_tot',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  ! CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='lw_up_TOA_clr',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  ! CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='lw_up_sfc_tot',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  ! CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='lw_up_sfc_clr',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  ! CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='lw_dn_sfc_tot',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))
  ! CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='lw_dn_sfc_clr',XTYPE=NF90_FLOAT,DIMIDS= (/ hor_dim_id, time_id /), VARID=dummy_id))

  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='init_year',XTYPE=NF90_FLOAT,VARID=year_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=year_id,NAME="description",VALUES="model initialization year"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=year_id,NAME="units",VALUES=""))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='init_month',XTYPE=NF90_FLOAT,VARID=month_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=month_id,NAME="description",VALUES="model initialization month"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=month_id,NAME="units",VALUES=""))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='init_day',XTYPE=NF90_FLOAT,VARID=day_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=day_id,NAME="description",VALUES="model initialization day"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=day_id,NAME="units",VALUES=""))
  CALL CHECK(NF90_DEF_VAR(NCID=ncid,NAME='init_hour',XTYPE=NF90_FLOAT,VARID=hour_id))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=hour_id,NAME="description",VALUES="model initialization hour"))
  CALL CHECK(NF90_PUT_ATT(NCID=ncid,VARID=hour_id,NAME="units",VALUES=""))


  !> - Close variable definition and the file.
  CALL CHECK(NF90_ENDDEF(NCID=ncid))
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=year_id,VALUES=scm_state%init_year))
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=month_id,VALUES=scm_state%init_month))
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=day_id,VALUES=scm_state%init_day))
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=hour_id,VALUES=scm_state%init_hour))
  CALL CHECK(NF90_CLOSE(NCID=ncid))

  !> @}
end subroutine output_init

!> This subroutine appends data to the "output.nc" file.
subroutine output_append(scm_state, physics)

  use gmtb_scm_type_defs, only: scm_state_type, physics_type

  type(scm_state_type), intent(in) :: scm_state
  type(physics_type), intent(in) :: physics

  real(kind=dp), allocatable :: dummy_1D(:), dummy_2d(:,:)

  ! real(kind=dp), intent(in)          :: hpbl(:) !< PBL height (m) (horizontal)
  ! real(kind=dp), intent(in)          :: sw_up_TOA_tot(:) !< total sky upward sw flux at toa (\f$W/m^2\f$) (horizontal)
  ! real(kind=dp), intent(in)          :: sw_dn_TOA_tot(:) !< total sky downward sw flux at toa (\f$W/m^2\f$) (horizontal)
  ! real(kind=dp), intent(in)          :: sw_up_TOA_clr(:) !< clear sky upward sw flux at toa (\f$W/m^2\f$) (horizontal)
  ! real(kind=dp), intent(in)          :: sw_up_sfc_tot(:) !< total sky upward sw flux at sfc (\f$W/m^2\f$) (horizontal)
  ! real(kind=dp), intent(in)          :: sw_dn_sfc_tot(:) !< total sky downward sw flux at sfc (\f$W/m^2\f$) (horizontal)
  ! real(kind=dp), intent(in)          :: sw_up_sfc_clr(:) !< clear sky upward sw flux at sfc (\f$W/m^2\f$) (horizontal)
  ! real(kind=dp), intent(in)          :: sw_dn_sfc_clr(:) !< clear sky downward sw flux at sfc (\f$W/m^2\f$) (horizontal)
  ! real(kind=dp), intent(in)          :: lw_up_TOA_tot(:) !< total sky upward LW flux at toa (\f$W/m^2\f$) (horizontal)
  ! real(kind=dp), intent(in)          :: lw_up_TOA_clr(:) !< clear sky upward LW flux at toa (\f$W/m^2\f$) (horizontal)
  ! real(kind=dp), intent(in)          :: lw_up_sfc_tot(:) !< total sky upward LW flux at sfc (\f$W/m^2\f$) (horizontal)
  ! real(kind=dp), intent(in)          :: lw_up_sfc_clr(:) !< clear sky upward LW flux at sfc (\f$W/m^2\f$) (horizontal)
  ! real(kind=dp), intent(in)          :: lw_dn_sfc_tot(:) !< total sky downward LW flux at sfc (\f$W/m^2\f$) (horizontal)
  ! real(kind=dp), intent(in)          :: lw_dn_sfc_clr(:) !< clear sky downward LW flux at sfc (\f$W/m^2\f$) (horizontal)


  integer :: ncid, var_id, i,k

  allocate(dummy_1D(scm_state%n_cols), dummy_2d(scm_state%n_cols, scm_state%n_levels))

  !> \section output_append_alg Algorithm
  !! @{

  !> - Open the file.
  CALL CHECK(NF90_OPEN(PATH=TRIM(scm_state%output_dir)//"/"//TRIM(scm_state%output_file)//".nc",MODE=NF90_WRITE,NCID=ncid))

  !> - Append all of the variables to the file.
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="time",VARID=var_id))
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=scm_state%model_time,START=(/ scm_state%itt_out /)))

  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="pres",VARID=var_id))
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=scm_state%pres_l(:,1,:),START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="pres_i",VARID=var_id))
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=scm_state%pres_i(:,1,:),START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="sigma",VARID=var_id))
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=scm_state%sl(:,1,:),START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="sigma_i",VARID=var_id))
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=scm_state%si(:,1,:),START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="qv",VARID=var_id))
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=scm_state%state_tracer(:,1,:,scm_state%water_vapor_index,1),&
    START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="T",VARID=var_id))
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=scm_state%state_T(:,1,:,1),START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="u",VARID=var_id))
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=scm_state%state_u(:,1,:,1),START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="v",VARID=var_id))
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=scm_state%state_v(:,1,:,1),START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="ql",VARID=var_id))
  print*,'size=',scm_state%state_tracer(:,1,:,scm_state%cloud_water_index,1),scm_state%cloud_water_index
  print*,'writing ql',maxval(scm_state%state_tracer(:,1,:,scm_state%cloud_water_index,1)),minval(scm_state%state_tracer(:,1,:,scm_state%cloud_water_index,1))
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=scm_state%state_tracer(:,1,:,scm_state%cloud_water_index,1),&
    START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="qi",VARID=var_id))
  print*,'writing ql',maxval(scm_state%state_tracer(:,1,:,scm_state%cloud_ice_index,1)),minval(scm_state%state_tracer(:,1,:,scm_state%cloud_ice_index,1))
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=scm_state%state_tracer(:,1,:,scm_state%cloud_ice_index,1),&
    START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="qr",VARID=var_id))
  print*,'writing ql',maxval(scm_state%state_tracer(:,1,:,scm_state%rain_index,1)),minval(scm_state%state_tracer(:,1,:,scm_state%rain_index,1))
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=scm_state%state_tracer(:,1,:,scm_state%rain_index,1),&
    START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="qs",VARID=var_id))
  print*,'writing ql',maxval(scm_state%state_tracer(:,1,:,scm_state%snow_index,1)),minval(scm_state%state_tracer(:,1,:,scm_state%snow_index,1))
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=scm_state%state_tracer(:,1,:,scm_state%snow_index,1),&
    START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="qg",VARID=var_id))
  print*,'writing ql',maxval(scm_state%state_tracer(:,1,:,scm_state%graupel_index,1)),minval(scm_state%state_tracer(:,1,:,scm_state%graupel_index,1))
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=scm_state%state_tracer(:,1,:,scm_state%graupel_index,1),&
    START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="qv_force_tend",VARID=var_id))
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=scm_state%qv_force_tend(:,:),START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="T_force_tend",VARID=var_id))
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=scm_state%T_force_tend(:,:),START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="u_force_tend",VARID=var_id))
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=scm_state%u_force_tend(:,:),START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="v_force_tend",VARID=var_id))
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=scm_state%v_force_tend(:,:),START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="w_ls",VARID=var_id))
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=scm_state%w_ls(:,:),START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="u_g",VARID=var_id))
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=scm_state%u_g(:,:),START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="v_g",VARID=var_id))
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=scm_state%v_g(:,:),START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="dT_dt_rad_forc",VARID=var_id))
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=scm_state%dT_dt_rad(:,:),START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="h_advec_thil",VARID=var_id))
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=scm_state%h_advec_thil(:,:),START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="h_advec_qt",VARID=var_id))
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=scm_state%h_advec_qt(:,:),START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="v_advec_thil",VARID=var_id))
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=scm_state%v_advec_thil(:,:),START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="v_advec_qt",VARID=var_id))
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=scm_state%v_advec_qt(:,:),START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="T_s",VARID=var_id))
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=scm_state%T_surf(:,1),START=(/1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="pres_s",VARID=var_id))
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=scm_state%pres_surf(:,1),START=(/1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="lhf",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_1D(i) = physics%Interstitial(i)%dqsfc1(1)
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_1D,START=(/1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="shf",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_1D(i) = physics%Interstitial(i)%dtsfc1(1)
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_1D,START=(/1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="tau_u",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_1D(i) = physics%Interstitial(i)%dusfc1(1)
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_1D,START=(/1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="tau_v",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_1D(i) = physics%Interstitial(i)%dvsfc1(1)
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_1D,START=(/1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="nirbmd",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_1D(i) = physics%Interstitial(i)%adjnirbmd(1)
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_1D,START=(/1,scm_state%itt_out /)))

  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="nirbmu",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_1D(i) = physics%Interstitial(i)%adjnirbmu(1)
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_1D,START=(/1,scm_state%itt_out /)))

  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="nirdfd",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_1D(i) = physics%Interstitial(i)%adjnirdfd(1)
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_1D,START=(/1,scm_state%itt_out /)))

  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="nirdfu",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_1D(i) = physics%Interstitial(i)%adjnirdfu(1)
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_1D,START=(/1,scm_state%itt_out /)))

  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="visbmd",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_1D(i) = physics%Interstitial(i)%adjvisbmd(1)
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_1D,START=(/1,scm_state%itt_out /)))

  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="visbmu",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_1D(i) = physics%Interstitial(i)%adjvisbmu(1)
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_1D,START=(/1,scm_state%itt_out /)))

  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="visdfd",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_1D(i) = physics%Interstitial(i)%adjvisdfd(1)
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_1D,START=(/1,scm_state%itt_out /)))

  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="visdfu",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_1D(i) = physics%Interstitial(i)%adjvisdfu(1)
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_1D,START=(/1,scm_state%itt_out /)))

  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="toausw",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_1D(i) = physics%Diag(i)%topfsw(1)%upfxc
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_1D,START=(/1,scm_state%itt_out /)))

  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="toadsw",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_1D(i) = physics%Diag(i)%topfsw(1)%dnfxc
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_1D,START=(/1,scm_state%itt_out /)))

  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="toauswc",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_1D(i) = physics%Diag(i)%topfsw(1)%upfx0
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_1D,START=(/1,scm_state%itt_out /)))

  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="toaulw",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_1D(i) = physics%Diag(i)%topflw(1)%upfxc
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_1D,START=(/1,scm_state%itt_out /)))

  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="toaulwc",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_1D(i) = physics%Diag(i)%topflw(1)%upfx0
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_1D,START=(/1,scm_state%itt_out /)))

  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="sfcusw",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_1D(i) = physics%Diag(i)%uswsfci(1)
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_1D,START=(/1,scm_state%itt_out /)))

  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="sfcdsw",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_1D(i) = physics%Diag(i)%dswsfci(1)
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_1D,START=(/1,scm_state%itt_out /)))

  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="sfculw",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_1D(i) = physics%Diag(i)%ulwsfci(1)
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_1D,START=(/1,scm_state%itt_out /)))

  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="sfcdlw",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_1D(i) = physics%Diag(i)%dlwsfci(1)
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_1D,START=(/1,scm_state%itt_out /)))

  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="swup",VARID=var_id))
  do k=1, scm_state%n_levels
     do i=1, scm_state%n_cols
        dummy_2D(i,k) = physics%Diag(i)%flxprf(1,k)%upfxc
     end do
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))

  if (scm_state%model_ics) then
     CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="stc",VARID=var_id))
     do i=1, scm_state%n_cols
        dummy_2D(i,1:scm_state%n_soil) = physics%Sfcprop(i)%stc(i,:)
     end do
     CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D(:,1:scm_state%n_soil),START=(/1,1,scm_state%itt_out /)))
   
     CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="smc",VARID=var_id))
     do i=1, scm_state%n_cols
        dummy_2D(i,1:scm_state%n_soil) = physics%Sfcprop(i)%smc(i,:)
     end do
     CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D(:,1:scm_state%n_soil),START=(/1,1,scm_state%itt_out /)))
   
     CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="slc",VARID=var_id))
     do i=1, scm_state%n_cols
        dummy_2D(i,1:scm_state%n_soil) = physics%Sfcprop(i)%slc(i,:)
     end do
     CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D(:,1:scm_state%n_soil),START=(/1,1,scm_state%itt_out /)))

     CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="srunoff",VARID=var_id))
     do i=1, scm_state%n_cols
       dummy_1D(i) = physics%Diag(i)%srunoff(1)
     end do
     CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_1D,START=(/1,scm_state%itt_out /)))

     CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="runoff",VARID=var_id))
     do i=1, scm_state%n_cols
       dummy_1D(i) = physics%Diag(i)%runoff(1)
     end do
     CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_1D,START=(/1,scm_state%itt_out /)))

     CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="drain",VARID=var_id))
     do i=1, scm_state%n_cols
       dummy_1D(i) = physics%Interstitial(i)%drain(1)
     end do
     CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_1D,START=(/1,scm_state%itt_out /)))

     CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="canopy",VARID=var_id))
     do i=1, scm_state%n_cols
       dummy_1D(i) = physics%Sfcprop(i)%canopy(1)
     end do
     CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_1D,START=(/1,scm_state%itt_out /)))

     CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="canopy_lhf",VARID=var_id))
     do i=1, scm_state%n_cols
       dummy_1D(i) = physics%Interstitial(i)%evcw(1)
     end do
     CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_1D,START=(/1,scm_state%itt_out /)))

  endif

  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="swdown",VARID=var_id))
  do k=1, scm_state%n_levels
     do i=1, scm_state%n_cols
        dummy_2D(i,k) = physics%Diag(i)%flxprf(1,k)%dnfxc
     end do
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))

  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="cldcov",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_2D(i,:) = physics%Interstitial(i)%clouds(1,:,1)
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))

  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="cldcov_conv",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_2D(i,:) = physics%Interstitial(i)%cnvc(1,:)
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
!  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="ql",VARID=var_id))
!  do i=1, scm_state%n_cols
!    dummy_2D(i,:) = physics%Interstitial(i)%clw(1,:,2)
!  end do
!  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
!  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="qi",VARID=var_id))
!  do i=1, scm_state%n_cols
!    dummy_2D(i,:) = physics%Interstitial(i)%clw(1,:,1)
!  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="qc_conv",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_2D(i,:) = physics%Interstitial(i)%cnvw(1,:)
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="rain",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_1D(i) = physics%Diag(i)%rain(1)/scm_state%dt
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_1D,START=(/1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="rainc",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_1D(i) = physics%Diag(i)%rainc(1)/scm_state%dt
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_1D,START=(/1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="pwat",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_1D(i) = physics%Diag(i)%pwat(1)
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_1D,START=(/1,scm_state%itt_out /)))

  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="sw_rad_heating_rate",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_2D(i,:) = physics%Radtend(i)%htrsw(1,:)
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="lw_rad_heating_rate",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_2D(i,:) = physics%Radtend(i)%htrlw(1,:)
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))

  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="dT_dt_lwrad",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_2D(i,:) = physics%Diag(i)%dt3dt(1,:,1)/scm_state%dt
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="dT_dt_swrad",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_2D(i,:) = physics%Diag(i)%dt3dt(1,:,2)/scm_state%dt
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="dT_dt_PBL",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_2D(i,:) = physics%Diag(i)%dt3dt(1,:,3)/scm_state%dt
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="dT_dt_deepconv",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_2D(i,:) = physics%Diag(i)%dt3dt(1,:,4)/scm_state%dt
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="dT_dt_shalconv",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_2D(i,:) = physics%Diag(i)%dt3dt(1,:,5)/scm_state%dt
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="dT_dt_micro",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_2D(i,:) = physics%Diag(i)%dt3dt(1,:,6)/scm_state%dt
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="dT_dt_gwd",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_2D(i,:) = physics%Diag(i)%dt3dt(1,:,7)/scm_state%dt
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="dq_dt_PBL",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_2D(i,:) = physics%Diag(i)%dq3dt(1,:,1)!/scm_state%dt
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="dq_dt_deepconv",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_2D(i,:) = physics%Diag(i)%dq3dt(1,:,2)!/scm_state%dt
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="dq_dt_shalconv",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_2D(i,:) = physics%Diag(i)%dq3dt(1,:,3)!/scm_state%dt
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="dq_dt_micro",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_2D(i,:) = physics%Diag(i)%dq3dt(1,:,4)!/scm_state%dt
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="dqc_dt_PBL",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_2D(i,:) = physics%Diag(i)%dqc3dt(1,:,1)!/scm_state%dt
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="dqc_dt_deepconv",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_2D(i,:) = physics%Diag(i)%dqc3dt(1,:,2)!/scm_state%dt
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="dqc_dt_shalconv",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_2D(i,:) = physics%Diag(i)%dqc3dt(1,:,3)!/scm_state%dt
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="dqc_dt_micro",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_2D(i,:) = physics%Diag(i)%dqc3dt(1,:,4)!/scm_state%dt
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="du_dt_PBL",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_2D(i,:) = physics%Diag(i)%du3dt(1,:,1)/scm_state%dt
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="du_dt_OGWD",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_2D(i,:) = physics%Diag(i)%du3dt(1,:,2)/scm_state%dt
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="du_dt_deepconv",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_2D(i,:) = physics%Diag(i)%du3dt(1,:,3)/scm_state%dt
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="du_dt_CGWD",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_2D(i,:) = physics%Diag(i)%du3dt(1,:,4)/scm_state%dt
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="dv_dt_PBL",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_2D(i,:) = physics%Diag(i)%dv3dt(1,:,1)/scm_state%dt
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="dv_dt_OGWD",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_2D(i,:) = physics%Diag(i)%dv3dt(1,:,2)/scm_state%dt
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="dv_dt_deepconv",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_2D(i,:) = physics%Diag(i)%dv3dt(1,:,3)/scm_state%dt
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="dv_dt_CGWD",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_2D(i,:) = physics%Diag(i)%dv3dt(1,:,4)/scm_state%dt
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="upd_mf",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_2D(i,:) = physics%Interstitial(i)%ud_mf(1,:)
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="dwn_mf",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_2D(i,:) = physics%Interstitial(i)%dd_mf(1,:)
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
  CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="det_mf",VARID=var_id))
  do i=1, scm_state%n_cols
    dummy_2D(i,:) = physics%Interstitial(i)%dt_mf(1,:)
  end do
  CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
  if (physics%Model(1)%do_sppt) then
     CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="sppt_wts",VARID=var_id))
     do i=1, scm_state%n_cols
       dummy_2D(i,:) = physics%Diag(i)%sppt_wts(1,:)
     end do
     CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
  endif
  if (physics%Model(1)%do_shum) then
     CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="shum_wts",VARID=var_id))
     do i=1, scm_state%n_cols
       dummy_2D(i,:) = physics%Diag(i)%shum_wts(1,:)
     end do
     CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=dummy_2D,START=(/1,1,scm_state%itt_out /)))
  endif
  ! CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="PBL_height",VARID=var_id))
  ! CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=hpbl(:),START=(/1,scm_state%itt_out /)))
  ! CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="sw_up_TOA_tot",VARID=var_id))
  ! CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=sw_up_TOA_tot(:),START=(/1,scm_state%itt_out /)))
  ! CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="sw_dn_TOA_tot",VARID=var_id))
  ! CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=sw_dn_TOA_tot(:),START=(/1,scm_state%itt_out /)))
  ! CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="sw_up_TOA_clr",VARID=var_id))
  ! CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=sw_up_TOA_clr(:),START=(/1,scm_state%itt_out /)))
  ! CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="sw_up_sfc_tot",VARID=var_id))
  ! CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=sw_up_sfc_tot(:),START=(/1,scm_state%itt_out /)))
  ! CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="sw_dn_sfc_tot",VARID=var_id))
  ! CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=sw_dn_sfc_tot(:),START=(/1,scm_state%itt_out /)))
  ! CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="sw_up_sfc_clr",VARID=var_id))
  ! CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=sw_up_sfc_clr(:),START=(/1,scm_state%itt_out /)))
  ! CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="sw_dn_sfc_clr",VARID=var_id))
  ! CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=sw_dn_sfc_clr(:),START=(/1,scm_state%itt_out /)))
  ! CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="lw_up_TOA_tot",VARID=var_id))
  ! CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=lw_up_TOA_tot(:),START=(/1,scm_state%itt_out /)))
  ! CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="lw_up_TOA_clr",VARID=var_id))
  ! CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=lw_up_TOA_clr(:),START=(/1,scm_state%itt_out /)))
  ! CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="lw_up_sfc_tot",VARID=var_id))
  ! CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=lw_up_sfc_tot(:),START=(/1,scm_state%itt_out /)))
  ! CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="lw_up_sfc_clr",VARID=var_id))
  ! CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=lw_up_sfc_clr(:),START=(/1,scm_state%itt_out /)))
  ! CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="lw_dn_sfc_tot",VARID=var_id))
  ! CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=lw_dn_sfc_tot(:),START=(/1,scm_state%itt_out /)))
  ! CALL CHECK(NF90_INQ_VARID(NCID=ncid,NAME="lw_dn_sfc_clr",VARID=var_id))
  ! CALL CHECK(NF90_PUT_VAR(NCID=ncid,VARID=var_id,VALUES=lw_dn_sfc_clr(:),START=(/1,scm_state%itt_out /)))

  !> - Close the file.
  CALL CHECK(NF90_CLOSE(ncid))

  !> @}
end subroutine output_append


!> @}
!> @}
end module gmtb_scm_output
