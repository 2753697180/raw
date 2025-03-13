[Mesh]
  file = test2.e
[]

[Variables]
  [T]
    family = LAGRANGE
    order = FIRST
    initial_condition = '300' # Start at room temperature
  []
[]

[AuxVariables]
  [T_fluid]
    family = LAGRANGE
    order = FIRST
    initial_condition = '300'
  []
  [htcp]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[Kernels]
  [heat_conduction]
    type = ADHeatConduction
    variable = T
  []
  [heat_source]
    type = source
    variable = T
    kappa = -22500000
  []
  [heat_conduction_time_derivative]
    type = ADHeatConductionTimeDerivative
    variable = T
  []
[]

[BCs]
  [heat_q]
    type = NeumannBC
    variable = T
    boundary = '1'
    value = 0 # (q)
  []
  [uo]
    type = CoupledConvectiveHeatFluxBC
    boundary = '2'
    variable = T
    htc = 'htcp'
    T_infinity = 'T_fluid'
    alpha = '1.0'
    scale_factor = '1.0'
  []
[]

[UserObjects]
  [T_wall]
    type = LayeredSideAverage
    num_layers = 25
    boundary = '2'
    variable = 'T'
    direction = z
    execute_on = 'timestep_end'
  []
  [T_fluid_uo]
    type = LayeredSideAverage
    num_layers = 25
    boundary = '2'
    variable = 'T_fluid'
    direction = z
    execute_on = 'timestep_end'
  []
[]

[Materials]
  [column]
    type = PackedColumn
  []
[]

[MultiApps]
  [sub_app]
    # poistion='0,0,1'
    type = TransientMultiApp
    input_files = 'flowm.i'
    execute_on = 'timestep_end INITIAL'
  []
[]


[VectorPostprocessors]
  [T_fluid_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = T_fluid_uo
  []
  [T_wall_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = T_wall
  []
[]

[Executioner]
  # fixed_point_max_its = 10
  type = Transient
  solve_type = PJFNK
  automatic_scaling = true
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  end_time = 5
  dt = 0.5
  dtmin = 1e-4
  start_time = -1
  steady_state_tolerance = 1e-5
  steady_state_detection = true
[]

[Outputs]
  exodus = true
  file_base = 0304
[]

[Transfers]
  [T_fluid]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sub_app
    source_variable = 'T'
    variable = 'T_fluid'
    execute_on = 'timestep_end INITIAL'
    num_nearest_points = 2
  []
  [htc]
    type = MultiAppGeneralFieldNearestLocationTransfer
    source_variable = 'Hw'
    variable = 'htcp'
    from_multi_app = sub_app
    execute_on = 'timestep_end INITIAL'
    num_nearest_points = 2
  []
  [T_wall]
    type = MultiAppGeneralFieldUserObjectTransfer
    to_multi_app = sub_app
    variable = 'T_wall'
    source_user_object = T_wall
    execute_on = 'timestep_end INITIAL'
  []
[]
