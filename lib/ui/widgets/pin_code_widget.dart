import 'package:bio_pin_access/ui/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinCodeWidget extends StatefulWidget {
  const PinCodeWidget({super.key});

  @override
  State<PinCodeWidget> createState() => _PinCodeWidgetState();
}

class _PinCodeWidgetState extends State<PinCodeWidget> {
  String enteredPin = '';
  bool isPinVisible = false;
  final storage = const FlutterSecureStorage();
  bool isSetupMode = false;

  @override
  void initState() {
    super.initState();
    _checkIfPinExists();
  }

  Future<void> _checkIfPinExists() async {
    final pin = await storage.read(key: 'pin_code');
    setState(() {
      isSetupMode = pin == null;
    });
  }

  Future<void> _savePin(String pin) async {
    await storage.write(key: 'pin_code', value: pin);
  }

  Future<void> _checkPin(String pin) async {
    final storedPin = await storage.read(key: 'pin_code');
    if (pin == storedPin) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (ctx) => const HomeScreen()),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Incorrect PIN.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Widget numButton(int number) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextButton(
        onPressed: () {
          setState(() {
            if (enteredPin.length < 4) {
              enteredPin += number.toString();
            }
          });
        },
        child: Text(
          number.toString(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          physics: const BouncingScrollPhysics(),
          children: [
            const Center(
              child: Text(
                "Enter Your PIN",
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  margin: const EdgeInsets.all(6.0),
                  width: isPinVisible ? 50 : 16,
                  height: isPinVisible ? 50 : 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: index < enteredPin.length
                        ? isPinVisible
                            ? Colors.green
                            : CupertinoColors.activeBlue
                        : CupertinoColors.activeBlue.withOpacity(0.1),
                  ),
                  child: isPinVisible && index < enteredPin.length
                      ? Center(
                          child: Text(
                            enteredPin[index],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : null,
                );
              }),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  isPinVisible = !isPinVisible;
                });
              },
              icon:
                  Icon(isPinVisible ? Icons.visibility_off : Icons.visibility),
            ),
            SizedBox(height: isPinVisible ? 50.0 : 8.0),
            for (var i = 0; i < 3; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    3,
                    (index) => numButton(1 + 3 * i + index),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TextButton(
                    onPressed: null,
                    child: SizedBox(),
                  ),
                  numButton(0),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        if (enteredPin.isNotEmpty) {
                          enteredPin =
                              enteredPin.substring(0, enteredPin.length - 1);
                        }
                      });
                    },
                    child: const Icon(
                      Icons.backspace,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  enteredPin = '';
                });
              },
              child: const Text(
                "Reset",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ElevatedButton(
                onPressed: () async {
                  if (enteredPin.length == 4) {
                    if (isSetupMode) {
                      await _savePin(enteredPin);
                      Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                          builder: (ctx) => const HomeScreen(),
                        ),
                      );
                    } else {
                      _checkPin(enteredPin);
                    }
                  }
                },
                child: Text(isSetupMode ? 'Save PIN' : 'Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
