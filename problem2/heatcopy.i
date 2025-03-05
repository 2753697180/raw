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
    type = ConvectiveHeatFluxBC
    T_infinity = 300
    boundary = '2'
    heat_transfer_coefficient = 150
    variable = T
  []
[]

[Materials]
  [column]
    type = PackedColumn
  []
[]

[Executioner]
  # fixed_point_max_its = 10
  type = Transient
  solve_type = PJFNK
  automatic_scaling = true
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  end_time = 20
  dt = 1
  dtmin = 1e-7
  start_time = -1
  steady_state_tolerance = 1e-5
  steady_state_detection = true
[]

[Outputs]
  exodus = true
  file_base = heatflux
[]
