module params_mod

  implicit none

  ! Contant parameters
  real, parameter :: pi = atan(1.0) * 4.0
  real, parameter :: rad_to_deg = 180.0 / pi
  real, parameter :: deg_to_rad = pi / 180.0
  real, parameter :: omega = 2.0 * pi / 86400.0
  real, parameter :: radius = 6.37122e6
  real, parameter :: g = 9.80616

  integer num_lon
  integer num_lat
  integer :: subcycles = 4
  real(8) time_step_size

  logical :: use_diffusion = .false.
  real diffusion_coef
  integer :: diffusion_order = 2

  integer :: run_days    = 0
  integer :: run_hours   = 0
  integer :: run_minutes = 0
  integer :: run_seconds = 0
  integer :: start_time(5) = [0, 0, 0, 0, 0]
  integer :: end_time(5) = [0, 0, 0, 0, 0]
  character(30) :: time_units = 'days'

  character(30) test_case
  character(256) case_name
  character(256) case_desc
  character(256) author
  character(30) :: history_periods(1) = ['6 hours']
  character(30) :: restart_period = ''

  character(256) namelist_file
  character(256) :: restart_file = ''

  ! Options:
  ! - predict-correct
  ! - runge-kutta
  character(30) time_scheme ! Time integration scheme
  integer time_order ! Time integration order (different schemes will have different meanings)
  logical qcon_modified ! Switch whether quadratic conservation modification is added

  ! Options:
  ! - csp1
  ! - csp2
  ! - isp
  ! - none
  character(30) split_scheme

  ! Options:
  ! - center_diff
  ! - upwind
  ! - weno
  character(30) :: uv_adv_scheme = 'center_diff'
  real :: uv_adv_upwind_lon_beta = 0.0
  real :: uv_adv_upwind_lat_beta = 0.5
  integer :: weno_order = 2

  logical is_restart_run

  logical :: use_zonal_tend_filter = .true.
  integer :: zonal_tend_filter_cutoff_wavenumber(20) = 0

  namelist /dycore_params/ &
    num_lon, &
    num_lat, &
    subcycles, &
    run_days, &
    run_hours, &
    run_minutes, &
    run_seconds, &
    start_time, &
    end_time, &
    time_units, &
    time_step_size, &
    test_case, &
    case_name, &
    case_desc, &
    author, &
    history_periods, &
    restart_period, &
    restart_file, &
    time_scheme, &
    time_order, &
    qcon_modified, &
    split_scheme, &
    uv_adv_scheme, &
    uv_adv_upwind_lon_beta, &
    uv_adv_upwind_lat_beta, &
    use_zonal_tend_filter, &
    zonal_tend_filter_cutoff_wavenumber, &
    use_diffusion, &
    diffusion_order, &
    diffusion_coef

contains

  subroutine params_read(file_path)

    character(*), intent(in) :: file_path

    namelist_file = file_path

    open(10, file=file_path)
    read(10, nml=dycore_params)
    close(10)

    is_restart_run = restart_file /= ''
    if (restart_period == '') restart_period = history_periods(1)

  end subroutine params_read

end module params_mod
