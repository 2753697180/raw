[Mesh]
   file = 'fuel3.e' 
[]
[Variables]
  [temperature]
    initial_condition = 300 # Start at room temperature
  []
[]
[Functions]
 [inner_temp]
    type=ParsedFunction
    expression=1000+30*sin(t)
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
    boundary = "4 2 3" 
    value = 0 # (q)
  []
  [wall_temperature]
    type=FunctionDirichletBC
    boundary='5'
    variable=temperature
    function=inner_temp
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
[Executioner]
  type = Transient
  solve_type = 'PJFNK'
  automatic_scaling = true
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  end_time = 80 
  dt = 0.5 
  start_time = -1
  steady_state_tolerance = 1e-5
  steady_state_detection = true
[]
[Outputs]
  exodus = true
[]
