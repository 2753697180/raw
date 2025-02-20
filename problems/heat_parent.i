[Mesh]
   file = 'fuel_cut_two.e' 
[]
[Variables]
  [temperature]
    initial_condition = 600 # Start at room temperature
  []
[]
[AuxVariables]
 [heat_flux]
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
[]
[UserObjects] 
 [heat_flux]
  type = ADSideDiffusiveFluxIntegral
  variable = temperature
  boundary = '5'
  diffusivity = thermal_conductivity
 []
[]
[Executioner]
  type = Transient  
  solve_type = 'PJFNK'
  automatic_scaling = true
  petsc_options_iname = '-pc_type -pc_hypre_type'
  #fixed_point_max_its = 10
  petsc_options_value = 'hypre boomeramg'
  end_time = 140
  dt=0.25
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
[]
[Transfers]
  [data_to]
    type=MultiAppUserObjectTransfer
    to_multi_app=sub_app
    user_object=heat_flux
    variable=q
    execute_on='timestep_end'
  []
[]  