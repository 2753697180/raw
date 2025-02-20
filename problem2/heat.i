[Mesh]
   file = 'test.e' 
[]
[Variables]
  [T]
    family = MONOMIAL
    order = CONSTANT
    initial_condition = 300 # Start at room temperature
  []
[]
[AuxVariables]
  [T_fluid]
    family = MONOMIAL
    order = CONSTANT
    initial_condition = 300
  []
  [htcp]
    family=MONOMIAL
    order =CONSTANT
    initial_condition = 1600
  []
[]
[Kernels]
  [heat_conduction]
    type = ADHeatConduction
    variable =T
  []
  [heat_source]
    type = source
    variable =T
    kappa = -0.0225
  []
  [heat_conduction_time_derivative]
    type = ADHeatConductionTimeDerivative
    variable = T
  []
[]
[BCs]
  [heat_q]
    type=NeumannBC
    variable = T
    boundary = "1"
    value = 0 # (q)
  []
[]
[UserObjects]
  [T_wall]
    type=LayeredSideAverage
    num_layers = 25
    boundary='2'
    variable=T
    direction='z'
    execute_on='timestep_end'
  []
[]
[Materials]
  [column]
    type = PackedColumn
  []
[]
[Postprocessors]
  [T_wall_source]
    type = SideAverageValue
    boundary = '2'
    variable = T
  []
[]
[Executioner]
  type = Transient  
  solve_type = 'PJFNK'
  automatic_scaling = true
  petsc_options_iname = '-pc_type -pc_hypre_type'
  #fixed_point_max_its = 10
  petsc_options_value = 'hypre boomeramg'
  end_time = 10
  dt=1
  dtmin=1e-7
  start_time = -1
  steady_state_tolerance = 1e-5
  steady_state_detection = true
[]  
[Outputs]
  exodus = true
[]