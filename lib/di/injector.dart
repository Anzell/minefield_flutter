import 'package:get_it/get_it.dart';
import 'package:minefield/presenters/home/controller/home_controller.dart';
import 'package:minefield/presenters/minefield/controller/minefield_controller.dart';
import 'package:minefield/presenters/minefield/converter/custom_dificulty_converter.dart';

final getIt = GetIt.instance;

void initDependencies(){
  getIt.registerFactory<CustomDificultyConverter>(() => CustomDificultyConverter());
  getIt.registerFactory<HomeController>(() => HomeController(customDificultyConverter: getIt()));
  getIt.registerFactory<MinefieldController>(() => MinefieldController());
}