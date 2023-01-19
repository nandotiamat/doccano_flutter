import 'package:doccano_flutter/constants/routes.dart';
import 'package:flutter/material.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                    margin: const EdgeInsets.only(right: 25),
                    child:
                        Center(child: Image.asset('images/exoticdoccano.png'))),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 50),
              ),
              const Text(
                'Mobile Client for Doccano!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 50),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, loginRoute);
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.all(16.0),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                child: const Text(
                  'Start using Doccano!!',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 150),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
