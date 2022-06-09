import 'package:dartz/dartz.dart';
import 'package:minefield/core/failures/failures.dart';
import 'package:minefield/domain/entities/custom_dificulty.dart';
import 'package:minefield/presenters/minefield/converter/custom_dificulty_converter.dart';

class HomeController {
  late CustomDificultyConverter _customDificultyConverter;

  HomeController({required CustomDificultyConverter customDificultyConverter}) : _customDificultyConverter = customDificultyConverter;

  Option failure = None();

  CustomDificulty? validateGameDificulty({String? widthL, String? widthC, String? numberBombs}) {
    failure = None();
    final resultConverter = _customDificultyConverter(CustomDificultyConverterParams(numberBombs: numberBombs, widthC: widthC, widthL: widthL));
    final result = resultConverter.fold((failure) => failure, (convertedObject) => convertedObject);
    if(result is ValidationFailure){
      failure = optionOf(result.message);
    } else if(result is CustomDificulty){
      return result;
    }
    return null;
  }
}
