//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "Heatflux2.h"

registerMooseObject("rawApp", Heatflux2);

InputParameters
Heatflux2::validParams()
{
  InputParameters params = NodalBC::validParams();
  params.addRequiredCoupledVar("temperature", "temperature field.");
  params.addClassDescription("Compute the outflow boundary condition.");
  return params;
}

Heatflux2::Heatflux2(const InputParameters & parameters)
  : NodalBC(parameters),
_temperature(coupledValue("temperature"))
{
}

Real
Heatflux2::computeQpResidual()
{
  return _u[_qp] -_temperature[_qp];
}
