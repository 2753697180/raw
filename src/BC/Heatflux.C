//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "Heatflux.h"

registerMooseObject("rawApp", Heatflux);

InputParameters
Heatflux::validParams()
{
  InputParameters params = ADIntegratedBC::validParams();
  params.addRequiredCoupledVar("temperature", "temperature field.");
  params.addClassDescription("Compute the outflow boundary condition.");
  return params;
}

Heatflux::Heatflux(const InputParameters & parameters)
  : ADIntegratedBC(parameters),
_temperature(coupledValue("temperature"))
{
}

ADReal
Heatflux::computeQpResidual()
{
  return -_test[_i][_qp]  * _temperature[_qp];
}
