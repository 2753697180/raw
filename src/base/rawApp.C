#include "rawApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
rawApp::validParams()
{
  InputParameters params = MooseApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

rawApp::rawApp(InputParameters parameters) : MooseApp(parameters)
{
  rawApp::registerAll(_factory, _action_factory, _syntax);
}

rawApp::~rawApp() {}

void
rawApp::registerAll(Factory & f, ActionFactory & af, Syntax & syntax)
{
  ModulesApp::registerAllObjects<rawApp>(f, af, syntax);
  Registry::registerObjectsTo(f, {"rawApp"});
  Registry::registerActionsTo(af, {"rawApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
rawApp::registerApps()
{
  registerApp(rawApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
rawApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  rawApp::registerAll(f, af, s);
}
extern "C" void
rawApp__registerApps()
{
  rawApp::registerApps();
}
