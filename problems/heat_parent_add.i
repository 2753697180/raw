[Mesh]
   file = 'fuel_cut2.e' 
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
    block= 1
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
    #positions='0,0,275'
    input_files = 'heat_sub.i'
    execute_on = 'timestep_end'
    output_in_position = true
  []
  [sub_app1]
    type = TransientMultiApp 
    #positions_file = positions.txt
    #positions='0,0,275'
    input_files = 'heat_sub1.i'
    execute_on = 'timestep_end'
    output_in_position = true
  []
  [sub_app2]
    type = TransientMultiApp 
    #positions_file = positions.txt
    #positions='0,0,275'
    input_files = 'heat_sub2.i'
    execute_on = 'timestep_end'
    output_in_position = true
  []
  [sub_app3]
    type = TransientMultiApp 
    #positions_file = positions.txt
    #positions='0,0,275'
    input_files = 'heat_sub3.i'
    execute_on = 'timestep_end'
    output_in_position = true
  []
  [sub_app4]
    type = TransientMultiApp 
    #positions_file = positions.txt
    #positions='0,0,275'
    input_files = 'heat_sub4.i'
    execute_on = 'timestep_end'
    output_in_position = true
  []
  [sub_app5]
    type = TransientMultiApp 
    #positions_file = positions.txt
    #positions='0,0,275'
    input_files = 'heat_sub5.i'
    execute_on = 'timestep_end'
    output_in_position = true
  []
  [sub_app6]
    type = TransientMultiApp 
    #positions_file = positions.txt
    #positions='0,0,275'
    input_files = 'heat_sub6.i'
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
  #fixed_point_max_its = 10
  end_time = 120
  dt=2
  start_time = -1
  steady_state_tolerance = 1e-5
  steady_state_detection = true
[] 
[Outputs]
  exodus = true
[]
[Transfers]
  [data_from]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    variable = temperature
    source_variable=temperature
    execute_on = 'timestep_end'
    from_blocks='2'
    to_blocks='2'
  []
  [data_to]
    type=MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app=sub_app
    variable=temperature
    source_variable=temperature
    execute_on='timestep_end'
    from_blocks='9'
    to_blocks='1'
  []
  [data_from1]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app1
    variable = temperature
    source_variable=temperature
    execute_on = 'timestep_end'
    from_blocks='2'
    to_blocks='3'
  []
  [data_to1]
    type=MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app=sub_app1
    variable=temperature
    source_variable=temperature
    execute_on='timestep_end'
    from_blocks='10'
    to_blocks='1'
  []
  [data_from2]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app2
    variable = temperature
    source_variable=temperature
    execute_on = 'timestep_end'
    from_blocks='2'
    to_blocks='4'
  []
  [data_to2]
    type=MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app=sub_app2
    variable=temperature
    source_variable=temperature
    execute_on='timestep_end'
    from_blocks='11'
    to_blocks='1'
  []
  [data_from3]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app3
    variable = temperature
    source_variable=temperature
    execute_on = 'timestep_end'
    from_blocks='2'
    to_blocks='5'
  []
  [data_to3]
    type=MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app=sub_app3
    variable=temperature
    source_variable=temperature
    execute_on='timestep_end'
    from_blocks='12'
    to_blocks='1'
  []
  [data_from4]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app4
    variable = temperature
    source_variable=temperature
    execute_on = 'timestep_end'
    from_blocks='2'
    to_blocks='6'
  []
  [data_to4]
    type=MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app=sub_app4
    variable=temperature
    source_variable=temperature
    execute_on='timestep_end'
    from_blocks='13'
    to_blocks='1'
  []
  [data_from5]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app5
    variable = temperature
    source_variable=temperature
    execute_on = 'timestep_end'
    from_blocks='2'
    to_blocks='7'
  []
  [data_to5]
    type=MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app=sub_app6
    variable=temperature
    source_variable=temperature
    execute_on='timestep_end'
    from_blocks='14'
    to_blocks='1'
  []
  [data_from6]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app5
    variable = temperature
    source_variable=temperature
    execute_on = 'timestep_end'
    from_blocks='2'
    to_blocks='8'
  []
  [data_to6]
    type=MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app=sub_app6
    variable=temperature
    source_variable=temperature
    execute_on='timestep_end'
    from_blocks='15'
    to_blocks='1'
  []
[]
