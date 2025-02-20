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
[]
[AuxKernels]
  [Hw_ak]
    type = ADMaterialRealAux
    variable = Hw
    property = 'Hw'
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
    length = ${units 1000 mm -> m}
    n_elems = 25
    A = 7.2548e-3             
    D_h = 7.0636e-2
  []
  [core_bc]
    type= HeatTransferFromExternalAppTemperature1Phase
    flow_channel= 'core_chan'
    Hw = 1000
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
[UserObjects]
  [T_uo]
    type = LayeredAverage
    direction = z
    variable = T
    num_layers = 25
    block = core_chan
  []
  [T_wall]
    type = LayeredAverage
    direction = z
    variable = T_wall
    num_layers = 25
    block = core_chan
  []
[]
[Postprocessors]
  [T_avg]
    type = ElementAverageValue
    variable = T
    execute_on = 'INITIAL TIMESTEP_END'
  []  
  [htc_avg]
    type = ElementAverageValue
    variable = Hw
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [T_wall_avg]
    type = ElementAverageValue
    variable = T_wall
    execute_on = 'INITIAL TIMESTEP_END'
  []
[]
[VectorPostprocessors]
  [T_uo_p]
    type = SpatialUserObjectVectorPostprocessor
    userobject = T_uo
  []
  [T_wall_p]
    type = SpatialUserObjectVectorPostprocessor
    userobject = T_wall
  []
[]
[Executioner]
  type = Transient
  solve_type = PJFNK
  line_search = basic
  start_time = -1
  end_time =10
  dt = 0.5
  dtmin=1e-7
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-8
  nl_max_its = 25
[]
[Outputs]
  file_base=sub
  exodus = true
  [csv]
    type = CSV
  []
  [console]
    type = Console
    max_rows = 1
    outlier_variable_norms = false
  []
  print_linear_residuals = false
[]
