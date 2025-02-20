[Mesh]
   file = 'fuel_cut_two.e' 
[]
[Variables]
  [temperature]
    initial_condition = 600 # Start at room temperature
  []
[]
[AuxVariables]
  [q]
    order = CONSTANT
    family = MONOMIAL_VEC
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
    block='1'
  []
  [heat_conduction_time_derivative]
    type = ADHeatConductionTimeDerivative
    variable = temperature
  []
[]
[AuxKernels]
  [heatflux1]
   type=heatflux
   variable=q
   temperature=temperature
   block='3'
  []
 []
[BCs]
  [heat_q]
    type=NeumannBC
    variable = temperature
    boundary = "1 2 3" 
    value = 0 # (q)
  []
  [wall_temperature]
    type=FunctionDirichletBC
    boundary='4'
    variable=temperature
    function=inner_temp
  []
[] 
[Materials]
  [column]
    type = PackedColumn
  []
[]
[Postprocessors] 
 [heat_flux]
  type = ADSideDiffusiveFluxIntegral
  variable = temperature
  boundary = '5'
  diffusivity = thermal_conductivity
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
  end_time = 140
  dt =2
  start_time = -1
  steady_state_tolerance = 1e-5
  steady_state_detection = true
[]
[Outputs]
  exodus = true
[]
 