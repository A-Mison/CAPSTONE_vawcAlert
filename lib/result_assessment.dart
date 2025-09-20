import 'package:flutter/material.dart';


class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String? _selectedOption;

  final List<String> _options = [
    'Oo, madalas',
    'Oo, paminsan-minsan',
    'Halos hindi',
    'Hindi kailanman',
  ];

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: Container(
       color: Colors.white,
     ),
   );
  }



