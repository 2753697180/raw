T_in = 300. # K
m_dot_in = 1e-2 # kg/s
press = 10e5 # Pa

[GlobalParams]
  initial_p = ${press}
  initial_vel = 0.0001
  initial_T = ${T_in}
  gravity_vector = '0 0 0'

  rdg_slope_reconstruction = minmod
  scaling_factor_1phase = '1 1e-2 1e-4'
  closures = thm_closures
  fp = he
[]
[FluidProperties]
  [he]
    type = IdealGasFluidProperties
    molar_mass = 4e-3
    gamma = 1.67
    k = 0.2556
    mu = 3.22639e-5
  []
[]
[Closures]
  [thm_closures]
    type = Closures1PhaseTHM
  []
[]
[AuxVariables]
  [Hw]
    family = monomial
    order = constant
    block = core_chan
  []
  [T_wall]
    family=monomial
    order = constant
    block = core_chan
[]
[AuxKernels]
  [Hw_ak]
    type = ADMaterialRealAux
    variable = Hw
    property = 'Hw'
  []
[]
[UserObjects]
  [T_uo]
    type = LayeredAverage
    direction = y
    variable = T
    num_layers = 10
    block = core_chan
  []
  [Hw_uo]
    type = LayeredAverage
    direction = y
    variable = Hw
    num_layers = 10
    block = core_chan
  []
[]
[Components]
  [inlet]
    type = InletMassFlowRateTemperature1Phase
    input = 'core_chan:in'
    m_dot = ${m_dot_in}
    T = ${T_in}
  []
  [core_chan]
    type = FlowChannel1Phase
    position = '0 0 0'
    orientation = '0 0 1'
    length = 1
    n_elems = 25
    A = 7.2548e-3
    D_h = 7.0636e-2
  []
  [core_bc]
    type=HeatTransferFromExteranlAppTemperature1Phase
    flow_channel= 'core_chan'
    Hw = 10000
    P_hf = 6.28319e-01
    initial_T_wall = 300.
    var_type = elemental
    T_ext= T_wall
  []
  [outlet]
    type = Outlet1Phase
    input = 'core_chan:out'
    p = ${press}
  []
[]
[Preconditioning]
  [pc]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  line_search = basic

  start_time = 0
  end_time = 100
  dt = 0.1

  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'

  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-8
  nl_max_its = 25

[]

[Outputs]
  exodus = true

  [console]
    type = Console
    max_rows = 1
    outlier_variable_norms = false
  []
  print_linear_residuals = false
[]
