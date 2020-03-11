import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:damilk_app/src/ui/screens/dashboard/dashboard_screen.dart';
import 'package:damilk_app/src/extensions/parser.dart';

class DashboardWidget extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
            child: Text(
          "Main screen",
          style: TextStyle(fontSize: 28.sp()),
        )),
      ),
    );
  }
}
