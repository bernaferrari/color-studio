import 'package:flutter/material.dart';

class Home2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Color Studio",
                  style: Theme.of(context).textTheme.headline4,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xff00f5a0), Color(0xff00d9f5)],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Gradient",
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              color: Colors.black,
                            ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
