[Mesh]
   file = 'test2.e' 
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
    kappa = -22500000
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
  [T_fluid_uo]
    type=LayeredSideAverage
    num_layers = 25
    boundary='2'
    variable=T_fluid
    direction='z'
    execute_on='timestep_end'
  []
[]
[Materials]
  [column]
    type = PackedColumn
  []
[]
[MultiApps]
  [sub_app]
    type = TransientMultiApp
    #poistion='0,0,1'
    input_files = flowm.i
    execute_on = 'timestep_end'
  []
[]
[VectorPostprocessors]  
  [T_fluid_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject =T_fluid_uo
  []
[] 
[Postprocessors]
  [T_fluid_parent]
    type = SideAverageValue
    boundary = '2'
    variable = T_fluid
  []
  [T_parent]
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
  end_time = 1
  dt=0.2
  dtmin=1e-7
  start_time = -1
  steady_state_tolerance = 1e-5
  steady_state_detection = true
[]  
[Outputs]
  file_base = not_bc
  exodus = true
  [csv]
    type = CSV
  []
[]
[Transfers]
  [from]
    type = MultiAppGeometricInterpolationTransfer
    from_multi_app = sub_app
    source_variable = T
    variable = T_fluid
    execute_on = 'timestep_end'
    num_points =3
    power=1
  []
  [data_from2]
    type = MultiAppPostprocessorInterpolationTransfer
    postprocessor = htc_avg
    variable = htcp
    from_multi_app = sub_app
    execute_on = 'timestep_end'
  []
  [data_to1]
    type = MultiAppGeneralFieldUserObjectTransfer
    to_multi_app = sub_app
    variable =T_wall
    source_user_object=T_wall                 
    execute_on = 'timestep_end'
  []
[]
