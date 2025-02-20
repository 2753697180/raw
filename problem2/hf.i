[Mesh]
   file = 'test.e' 
[]
[Variables]
  [T]
    family = MONOMIAL
    order = CONSTANT
    initial_condition = 600 # Start at room temperature
  []
[]
[AuxVariables]
  [T_fluid]
    family = MONOMIAL
    order = CONSTANT
    initial_condition = 300
  []
  [htc]
    family = MONOMIAL
    order = CONSTANT
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
[Materials]
  [column]
    type = PackedColumn
  []
[]
[Problem]
  type = FEProblem
[]
[CoupledHeatTransfers]
  [right]
    boundary = '2'
    T_fluid = 'T_fluid'
    T = T
    T_wall = T_wall
    htc = 'htc'
    multi_app = thm
    T_fluid_user_objects = 'T_uo'
    htc_user_objects = 'Hw_uo'
    position = '0 0 0'
    orientation = '0 1 0'
    length = 1
    n_elems = 25
    skip_coordinate_collapsing = true
  []
[]
[MultiApps]
  [thm]
    type = TransientMultiApp 
    input_files = flow2c.i
    execute_on = 'timestep_end'
    output_in_position = true
  []
[]
[Executioner]
  type = Transient  
  solve_type = 'PJFNK'
  automatic_scaling = true
  petsc_options_iname = '-pc_type -pc_hypre_type'
  #fixed_point_max_its = 10
  petsc_options_value = 'hypre boomeramg'
  end_time = 80
  dt=0.1
  start_time = -1
  steady_state_tolerance = 1e-5
  steady_state_detection = true
[]  
[Outputs]
  exodus = true
[]

