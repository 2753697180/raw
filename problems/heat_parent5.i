[Mesh]
   file = 'fuel_cut_two4.e' 
[]
[Variables]
  [temperature]
    initial_condition = 600 # Start at room temperature
  []
[]
[AuxVariables]
 [temperature2]
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
    block='2'
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
  [heat_wall]
    type=Heatflux2
    boundary ='13'
    temperature =temperature2
    variable = temperature
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
  [sub_app1]
    type = TransientMultiApp 
    #positions_file = positions.txt
    #positions='0,0,275'
    input_files = 'heat_sub.i'
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
[]
[Executioner]
  type = Transient  
  solve_type = 'PJFNK'
  automatic_scaling = true
  petsc_options_iname = '-pc_type -pc_hypre_type'
  fixed_point_max_its = 10
  petsc_options_value = 'hypre boomeramg'
  end_time = 80
  dt=2
  start_time = -1
  steady_state_tolerance = 1e-5
  steady_state_detection = true
[]  
[Outputs]
  exodus = true
[]
[Transfers]
  [data_from1]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app1
    variable = temperature2
    source_variable=temperature
    execute_on = 'timestep_end'
    from_boundaries =' 1'
    to_boundaries ='5'
  []
  [data_to1]
    type =MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = sub_app1
    variable =temperature1
    source_variable=temperature                     
    execute_on = 'timestep_end'
    from_boundaries='6'
    to_boundaries='1'
  []
  [data_from2]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app1
    variable = temperature2
    source_variable=temperature
    execute_on = 'timestep_end'
    from_boundaries =' 1'
    to_boundaries ='8'
  []
  [data_to2]
    type =MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = sub_app1
    variable =temperature1
    source_variable=temperature                     
    execute_on = 'timestep_end'
    from_boundaries='6'
    to_boundaries='1'
  []
  [data_from3]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app1
    variable = temperature2
    source_variable=temperature
    execute_on = 'timestep_end'
    from_boundaries =' 1'
    to_boundaries ='9'
  []
  [data_to3]
    type =MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = sub_app1
    variable =temperature1
    source_variable=temperature                     
    execute_on = 'timestep_end'
    from_boundaries='6'
    to_boundaries='1'
  []
  [data_from4]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app1
    variable = temperature2
    source_variable=temperature
    execute_on = 'timestep_end'
    from_boundaries =' 1'
    to_boundaries ='10'
  []
  [data_to4]
    type =MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = sub_app1
    variable =temperature1
    source_variable=temperature                     
    execute_on = 'timestep_end'
    from_boundaries='6'
    to_boundaries='1'
  []
  [data_from5]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app1
    variable = temperature2
    source_variable=temperature
    execute_on = 'timestep_end'
    from_boundaries =' 1'
    to_boundaries ='11'
  []
  [data_to5]
    type =MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = sub_app1
    variable =temperature1
    source_variable=temperature                     
    execute_on = 'timestep_end'
    from_boundaries='6'
    to_boundaries='1'
  []
  [data_from6]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app1
    variable = temperature2
    source_variable=temperature
    execute_on = 'timestep_end'
    from_boundaries =' 1'
    to_boundaries ='12'
  []
  [data_to6]
    type =MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = sub_app1
    variable =temperature1
    source_variable=temperature                     
    execute_on = 'timestep_end'
    from_boundaries='6'
    to_boundaries='1'
  []
  [data_from_middle]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app2
    variable = temperature2
    source_variable=temperature
    execute_on = 'timestep_end'
    from_boundaries = '1'
    to_boundaries='7'
  []
  [data_to_middle]
    type =MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = sub_app2
    variable =temperature1
    source_variable=temperature                     
    execute_on = 'timestep_end'
    from_boundaries='4'
    to_boundaries='1'
  []
[]
