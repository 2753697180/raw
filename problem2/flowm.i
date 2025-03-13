T_in = 300. # K
m_dot_in = 0.01 # kg/s
press = 1e5 # Pa
[GlobalParams]
  initial_p = ${press} 
  initial_vel = 0.01
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
    family = MONOMIAL
    order = CONSTANT
    block = core_chan
  []
  [T_wall]
    family=LAGRANGE
    order = FIRST
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
    length = 1
    n_elems = 25
    A = 7.85e-5             
    D_h = 3.14e-2
  []
  [core_bc]
    type=HeatTransferFromHeatFlux1Phase
    flow_channel= 'core_chan'
    q_wall= 1000
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
[]
[Postprocessors]
  [T_1]
    type = PointValue
    variable = T
    point='0 0 1'
    execute_on = 'INITIAL TIMESTEP_END'
  []  
  [htc_1]
    type =  PointValue
    variable = Hw
    point='0 0 1'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [htc_0]
    type =  PointValue
    variable = Hw
    point='0 0 0'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [T_0]
    type = PointValue
    variable = T
    point='0 0 0'
    execute_on = 'INITIAL TIMESTEP_END'
  [] 
[]
[VectorPostprocessors]
  [T_uo_p]
    type = SpatialUserObjectVectorPostprocessor
    userobject = T_uo
  []
[]
[Executioner]
  type = Transient
  solve_type = PJFNK
  line_search = basic
  start_time = -1
  end_time =1
  dt = 0.01
  dtmin=1e-4
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-8
  nl_max_its = 25
[]
[Outputs]
  file_base=sub
  exodus = true
  [console]
    type = Console
    max_rows = 1
    outlier_variable_norms = false
  []
  print_linear_residuals = false
[]
