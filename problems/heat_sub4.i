[Mesh]
  file = 'heat_wall.e' 
[]
[Variables]
  [temperature]
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
    kappa = 0
  []
  [heat_conduction_time_derivative]
    type = ADHeatConductionTimeDerivative
    variable = temperature
  []
[]
[Functions]
  [wall_temperature]
    type = ParsedFunction
    expression =1000+30*sin(t)
  []
[] 
[BCs]
  [heat_wall]
    type = FunctionDirichletBC
    variable = temperature
    boundary ='2'
    function  =wall_temperature
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
  end_time = 120
  dt = 2
  start_time=-1
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
[]
[Outputs]
  exodus = true
[]
