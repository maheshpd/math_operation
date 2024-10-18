import 'package:flutter/material.dart';
import 'models/math_problem.dart';
import 'services/math_problem_generator.dart';

void main() {
  runApp(MathOperationsApp());
}

class MathOperationsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Operations Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MathHomePage(),
    );
  }
}

class MathHomePage extends StatefulWidget {
  @override
  _MathHomePageState createState() => _MathHomePageState();
}

class _MathHomePageState extends State<MathHomePage> {
  final MathProblemGenerator _generator = MathProblemGenerator();
  MathProblem? _currentProblem;
  final TextEditingController _controller = TextEditingController();
  String _feedback = '';

  String _selectedOperation = '+'; // Default operation
  int _selectedDigits = 1; // Default number of digits

  final Map<int, String> _operationMap = {
    1: '+',
    2: '-',
    3: '×',
  };

  final Map<String, String> _operationNames = {
    '+': 'Addition (+)',
    '-': 'Subtraction (-)',
    '×': 'Multiplication (×)',
  };

  @override
  void initState() {
    super.initState();
    _generateNewProblem();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _generateNewProblem() {
    setState(() {
      _currentProblem =
          _generator.generateProblem(operation: _selectedOperation, digits: _selectedDigits);
      _controller.clear();
      _feedback = '';
    });
  }

  void _checkAnswer() {
    if (_currentProblem == null) return;

    int? userAnswer = int.tryParse(_controller.text);
    if (userAnswer == null) {
      setState(() {
        _feedback = 'Please enter a valid number.';
      });
      return;
    }

    setState(() {
      if (userAnswer == _currentProblem!.answer) {
        _feedback = 'Correct!';
      } else {
        _feedback =
            'Incorrect. The correct answer is ${_currentProblem!.answer}.';
      }
    });
  }

  // Digit selection dropdown
  Widget _buildDigitSelection() {
    return DropdownButton<int>(
      value: _selectedDigits,
      items: List.generate(9, (index) => index + 1).map((digit) {
        return DropdownMenuItem<int>(
          value: digit,
          child: Text('$digit digit${digit > 1 ? 's' : ''}'),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedDigits = value!;
          _generateNewProblem(); // Generate a new problem on selection change
        });
      },
    );
  }

  // Operation selection dropdown
  Widget _buildOperationSelection() {
    return DropdownButton<String>(
      value: _selectedOperation,
      items: _operationNames.entries.map((entry) {
        return DropdownMenuItem<String>(
          value: entry.key,
          child: Text(entry.value),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedOperation = value!;
          _generateNewProblem(); // Generate a new problem on selection change
        });
      },
    );
  }

  // Widget to Display the Math Problem Vertically
  Widget _buildVerticalMathProblem() {
    if (_currentProblem == null) return Container();

    int maxDigits = _currentProblem!.num1.toString().length >
            _currentProblem!.num2.toString().length
        ? _currentProblem!.num1.toString().length
        : _currentProblem!.num2.toString().length;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _currentProblem!.num1.toString(),
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                _currentProblem!.operation,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 5),
              Text(
                _currentProblem!.num2.toString(),
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5.0),
            height: 2,
            color: Colors.black,
            width: maxDigits * 16.0,
          ),
          Text(
            '?',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Math Operations Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _currentProblem == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Operation Selection
                    Text(
                      'Select Operation:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    _buildOperationSelection(),
                    SizedBox(height: 30),

                    // Digit Selection
                    Text(
                      'Select Number of Digits:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    _buildDigitSelection(),
                    SizedBox(height: 30),

                    // Display the current math problem vertically
                    Center(
                      child: _buildVerticalMathProblem(),
                    ),
                    SizedBox(height: 20),

                    // Answer input field
                    TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Your Answer',
                      ),
                    ),
                    SizedBox(height: 10),

                    // Submit button
                    ElevatedButton(
                      onPressed: _checkAnswer,
                      child: Text('Submit'),
                    ),
                    SizedBox(height: 10),

                    // Feedback display
                    Text(
                      _feedback,
                      style: TextStyle(
                          fontSize: 20,
                          color: _feedback == 'Correct!'
                              ? Colors.green
                              : Colors.red),
                    ),

                    
                    // Next Problem button
                    ElevatedButton(
                      onPressed: _generateNewProblem,
                      child: Text('Next Problem'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
