import 'dart:async';

import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {

  final DateTime dueDate;
  const CountdownTimer({super.key,required this.dueDate});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {

  late DateTime _dueDate;
  late Duration _remainingTime;
  late Timer _timer;

  void _calculateRemainingTime(){
    setState(() {
      _remainingTime = _dueDate.difference(DateTime.now());
    });
  }

void _updateRemainingTime(){
  if(_remainingTime.inSeconds >0){
    setState(() {
      _remainingTime = _dueDate.difference(DateTime.now());
    });
  }else{
    _timer.cancel();
  }
}
String _formatDuration(Duration duration){
  if(duration.inSeconds < 0){
    return "deadline passed";
  }
  final hours = duration.inHours;
  final minutes = duration.inMinutes % 60;
  final seconds = duration.inSeconds % 60;
  return "${hours.toString().padLeft(2,"0")}:${minutes.toString().padLeft(2,"0")}:${seconds.toString().padLeft(2,"0")}";
}

  @override
  void initState() { 
    super.initState();
    _dueDate = widget.dueDate;
    _calculateRemainingTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateRemainingTime());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    final String formattedTime = _formatDuration(_remainingTime);
    return Text(formattedTime,style: const TextStyle(fontSize: 24 , fontWeight: FontWeight.bold));
  }
}