// lib/services/math_problem_generator.dart

import 'dart:math';
import '../models/math_problem.dart';

class MathProblemGenerator {
  final Random _random = Random();

  // Define possible operations
  final List<String> _operations = ['+', '-', '×'];

  // Generate problem based on selected operation and digit count
  MathProblem generateProblem({required String operation, required int digits}) {
    String selectedOperation = operation;

    // Calculate minimum and maximum values based on digit count
    int min = pow(10, digits - 1).toInt();
    int max = pow(10, digits).toInt() - 1;

    int num1 = _random.nextInt(max - min + 1) + min;
    int num2 = _random.nextInt(max - min + 1) + min;

    // For subtraction, ensure the result is non-negative
    if (selectedOperation == '-') {
      if (num1 < num2) {
        int temp = num1;
        num1 = num2;
        num2 = temp;
      }
    }

    // Calculate the answer
    int answer;
    switch (selectedOperation) {
      case '+':
        answer = num1 + num2;
        break;
      case '-':
        answer = num1 - num2;
        break;
      case '×':
        answer = num1 * num2;
        break;
      default:
        answer = 0;
    }

    return MathProblem(
      num1: num1,
      num2: num2,
      operation: selectedOperation,
      answer: answer,
    );
  }
}
