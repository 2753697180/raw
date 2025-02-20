[Mesh]
   file = 'fuel2.e' 
[]
[Variables]
  [temperature]
    initial_condition = 300 # Start at room temperature
  []
[]
[Kernels]
  [heat_conduction]
    type = ADHeatConduction
    variable = temperature
  []
  [heat_source]
    type = source
    variable = temperature
    kappa = -0.0225
  []
  [heat_conduction_time_derivative]
    type = ADHeatConductionTimeDerivative
    variable = temperature
  []
[]
[BCs]
  [heat_q]
    type=NeumannBC
    variable = temperature
    boundary = "1 2 3"
    value = 0 # (q)
  []
  [temperature]
    type=DirichletBC
    variable=temperature
    boundary='4'
    value=1030
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
[MultiApps]
  [sub_app]
    type = TransientMultiApp 
    #positions_file = positions.txt
    positions='0 275 0 '
    input_files = 'heat_sub.i'
    execute_on = 'timestep_end'
    output_in_position = true
  []
[]
[Executioner]
  type = Transient
  solve_type = 'PJFNK'
  automatic_scaling = true
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  end_time = 122
  dt=2
  start_time = -1
  steady_state_tolerance = 1e-5
  steady_state_detection = true
[]
[Outputs]
  exodus = true
[]
[Transfers]
  [pull_u_start]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    variable = temperature
    source_variable=temperature
    execute_on = 'timestep_end'
  []
[]
