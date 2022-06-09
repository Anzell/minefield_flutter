

import 'package:dartz/dartz.dart';
import 'package:minefield/core/failures/failures.dart';
import 'package:minefield/domain/entities/custom_dificulty.dart';

import '../../../core/converter/converter.dart';

class CustomDificultyConverter implements Converter<CustomDificulty, CustomDificultyConverterParams> {
  @override
  Either<ValidationFailure, CustomDificulty> call(CustomDificultyConverterParams params) {
    if(params.widthL == null || int.tryParse(params.widthL!) == null || int.parse(params.widthL!) <= 0){
      return Left(ValidationFailure(message: CustomDificultyConverterErrorMessages.missingL));
    }
    if(params.widthC == null || int.tryParse(params.widthC!) == null || int.parse(params.widthC!) <= 0){
      return Left(ValidationFailure(message: CustomDificultyConverterErrorMessages.missingC));
    }
    if(params.numberBombs == null || int.tryParse(params.numberBombs!) == null){
      return Left(ValidationFailure(message: CustomDificultyConverterErrorMessages.missingNumberBombs));
    }
    if(int.parse(params.numberBombs!) <= 0){
      return Left(ValidationFailure(message: CustomDificultyConverterErrorMessages.invalidNumberBombs));
    }
    if(int.parse(params.numberBombs!) >= int.parse(params.widthC!) * int.parse(params.widthL!)){
      return Left(ValidationFailure(message: CustomDificultyConverterErrorMessages.manyBombs));
    }
    return Right(
      CustomDificulty(
        widthC: int.parse(params.widthC!),
        widthL: int.parse(params.widthL!),
        bombsNumber: int.parse(params.numberBombs!),
      )
    );
  }

}

class CustomDificultyConverterParams {
  final String? widthL;
  final String? widthC;
  final String? numberBombs;

  CustomDificultyConverterParams({required this.numberBombs, required this.widthC, required this.widthL});
}

class CustomDificultyConverterErrorMessages {
  static const missingL = "É necessário informar a largura";
  static const missingC = "É necessário informar a quantidade de colunas";
  static const missingNumberBombs = "É necessário informar o número de bombas";
  static const invalidNumberBombs = "Deve existir ao menos 1 bomba";
  static const manyBombs = "Número de bombas maior que o permitido";
}