#include"source.h"
registerMooseObject("rawApp", source);
//注册类名，括号里前面为项目名称+App，后面为类名，通过这个将类注入程序使用
InputParameters
source::validParams()
{
  InputParameters params = ADKernelValue::validParams(); //初始化静态成员函数
  params.addClassDescription("The diffusion term of the equation"); //加入对象描述
  params.addParam<Real>("kappa",1.0,"The source term of the equation");
  //定义输入卡中的参数value，默认数值为1.0，类型为实数类型
  return params;
}
source::source(const InputParameters & parameters)
  : ADKernelValue(parameters), //构造函数
  _kappa(getParam<Real>("kappa")) //将输入卡中的value值用来初始化_value
  //此处与扩散项的构造函数不同
    // Set the coefficients for the diffusion kernel
{
}

ADReal
source::precomputeQpResidual()
{
  return _kappa; //实际上就是_kappa * _test[_i][_qp]
}

