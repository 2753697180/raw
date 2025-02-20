//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "Heatflow.h"
registerMooseObject("rawApp", Heatflow);

InputParameters
Heatflow::validParams()
{
  InputParameters params = ADIntegratedBC::validParams();
  params.addClassDescription("Compute the outflow boundary condition.");
  params.addRequiredCoupledVar("temperature", "temperature field.");

  return params;
}

Heatflow::Heatflow(const InputParameters & parameters)
  : ADIntegratedBC(parameters),
    _thermal_conductivity(getADMaterialProperty<Real>("thermal_conductivity")),
    _temperature_gradient(coupledGradient("temperature"))

{
}

ADReal
Heatflow::computeQpResidual()
{
  return -_test[_i][_qp] * _thermal_conductivity[_qp]/1000* _temperature_gradient[_qp] * _normals[_qp];
}

