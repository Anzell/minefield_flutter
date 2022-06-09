import 'package:dartz/dartz.dart';
import 'package:minefield/core/failures/failures.dart';

abstract class Converter<ReturnType, Params> {
  Either<ValidationFailure, ReturnType> call(Params params);
}

