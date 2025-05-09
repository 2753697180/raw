//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "fuel.h"
#include "Function.h"

registerMooseObject("rawApp", fuel);

InputParameters
fuel::validParams()
{
  InputParameters params = Material::validParams();

  // Parameter for radius of the spheres used to interpolate permeability.
  params.addParam<Real>(
      "density",
       10000,
      "The density ($\\mu$) of the fuel in kg/m^3, the default is for water at 30 degrees C.");
  params.addParam<Real>(
      "thermal_conductivity",
       70,
      "The thermal_conductivity($\\mu$) of the fuel in W/(m*K), the default is for water at 30 degrees C.");
  params.addParam<Real>(
      "specific_heat",
       200,
      "The specific_heat ($\\mu$) of the fuel in J/(kg*K) , the default is for water at 30 degrees C.");
  


  return params;
}

fuel::fuel(const InputParameters & parameters)
  : Material(parameters),

    // Get the parameters from the input file
    _input_density(getParam<Real>("density")),
    _input_thermal_conductivity(getParam<Real>("thermal_conductivity")),
    _input_specific_heat(getParam<Real>("specific_heat")),
    // Declare two material properties by getting a reference from the MOOSE Material system
    _density(declareADProperty<Real>("density")),
    _thermal_conductivity(declareADProperty<Real>("thermal_conductivity")),
    _specific_heat(declareADProperty<Real>("specific_heat"))

{
}

void
fuel::computeQpProperties()
{
  // From the paper: Table 1

  _density[_qp] = _input_density;
  _thermal_conductivity[_qp] = _input_thermal_conductivity;
  _specific_heat[_qp] = _input_specific_heat;

}
  // We'll calculate permeability using a simple linear interpolation of the two points above:
  //          y0 * (x1 - x) + y1 * (x - x0)
  //  y(x) = -------------------------------
  //                     x1 - x0
 
