import 'package:bio_pin_access/ui/widgets/pin_code_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home Screen"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                    builder: (ctx) => const PinCodeWidget(),
                  ),
                );
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: const Center(
        child: Text("Authenticated Success"),
      ),
    );
  }
}
