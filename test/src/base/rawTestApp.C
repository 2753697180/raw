//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "rawTestApp.h"
#include "rawApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"

InputParameters
rawTestApp::validParams()
{
  InputParameters params = rawApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

rawTestApp::rawTestApp(InputParameters parameters) : MooseApp(parameters)
{
  rawTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

rawTestApp::~rawTestApp() {}

void
rawTestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  rawApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"rawTestApp"});
    Registry::registerActionsTo(af, {"rawTestApp"});
  }
}

void
rawTestApp::registerApps()
{
  registerApp(rawApp);
  registerApp(rawTestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
rawTestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  rawTestApp::registerAll(f, af, s);
}
extern "C" void
rawTestApp__registerApps()
{
  rawTestApp::registerApps();
}
