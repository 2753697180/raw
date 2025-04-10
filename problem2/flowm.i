T_in = 300. # K
m_dot_in = 0.001# kg/s
press = 10e5 # Pa
[GlobalParams]
  initial_p = ${press} 
  initial_T = ${T_in}
  initial_vel=0.
  gravity_vector = '0 0 0'
  rdg_slope_reconstruction = minmod
  scaling_factor_1phase = '1 1e-2 1e-4'
  closures = thm_closures
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
[]
[AuxKernels]
  [hw]
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
    T = 300
  []
  [core_chan]
    type = FlowChannel1Phase
    position = '0 0 0'
    orientation = '0 0 1'
    length = 1
    n_elems = 25
    A = 7.85e-5             
    D_h = 0.01
    fp = he
  []
  [core_bc]
    type=HeatTransferFromSpecifiedTemperature1Phase
    flow_channel= 'core_chan'
    T_wall= 500
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
  [T_out]
    type = PointValue
    variable = T
    point='0 0 1'
    execute_on = 'INITIAL TIMESTEP_END'
  []  
  [Q_W]
    type =  ADHeatRateConvection1Phase
    block = core_chan
    P_hf = 0.0314
  []
  [T_in_8]
    type = PointValue
    variable = T
    point='0 0 0.08'
    execute_on = 'INITIAL TIMESTEP_END'
  []  
  [T_in_6]
    type = PointValue
    variable = T
    point='0 0 0.06'
    execute_on = 'INITIAL TIMESTEP_END'
  [] 
  [T_in_0]
    type = PointValue
    variable = T
    point='0 0 0'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [T_in_4]
    type = PointValue
    variable = T
    point='0 0 0.04'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [T_in_25]
    type = PointValue
    variable = T
    point='0 0 0.025'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [T_in_3]
    type = PointValue
    variable = T
    point='0 0 0.03'
    execute_on = 'INITIAL TIMESTEP_END'
  [] 
  [T_in_2]
    type = PointValue
    variable = T
    point='0 0 0.02'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [average]
    type = ElementAverageValue
    variable = T
  []
  [hw_out]
    type = PointValue
    variable = Hw
    point='0 0 1'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [core_T_in]
    type = SideAverageValue
    boundary = core_chan:in
    variable = T
  []
[]
[Executioner]
  type = Transient
  solve_type = PJFNK
  line_search = basic
  start_time = 0
  end_time =0.1
  dt = 0.001
  dtmin=1e-4
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

