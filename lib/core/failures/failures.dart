abstract class Failure{}

class ValidationFailure extends Failure{
  final String message;

  ValidationFailure({required this.message});
}