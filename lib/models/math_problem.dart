// lib/models/math_problem.dart

class MathProblem {
  final int num1;
  final int num2;
  final String operation;
  final int answer;

  MathProblem({
    required this.num1,
    required this.num2,
    required this.operation,
    required this.answer,
  });

  String get question => '$num1 $operation $num2 = ?';
}
