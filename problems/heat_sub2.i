[Mesh]
  file = 'heat_wall3.e' 
  #construct_side_list_from_node_list=true
[]
[Variables]
  [temperature]
    initial_condition=600
  []
[]  
  
[AuxVariables]
  [temperature1] 
  #initial_condition=0.001
  # heat_flux
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
  [outerwall]
    type=Heatflow
    variable=temperature
    boundary='1'
    temperature=temperature1
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
  end_time = 90
  dt = 2
  start_time=-1
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
[]
[Outputs]
  exodus = true
[]
