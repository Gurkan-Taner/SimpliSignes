import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TranslatePage extends StatelessWidget {
  const TranslatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              height: 90.0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(child: SizedBox(), flex: 1),
                    const Expanded(
                      flex: 1,
                      child: Image(
                          fit: BoxFit.fitHeight,
                          image:
                              AssetImage("assets/images/logo_horizontal.png")),
                    ),
                    //Expanded(child: SizedBox()),
                    Expanded(
                        flex: 1,
                        child: Container(
                            alignment: Alignment.centerRight,
                            child: const Padding(
                              padding: EdgeInsets.only(top: 13.0, bottom: 13.0),
                              child: Image(
                                  fit: BoxFit.fitHeight,
                                  image:
                                      AssetImage("assets/images/account.png")),
                            ))),
                  ],
                ),
              ),
            ),
            // Direction switcher
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Container(
                height: 50.0,
                decoration: BoxDecoration(
                  color: const Color(0xff4CB5CB),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(color: Colors.white),
                              ),
                              alignment: Alignment.center,
                              child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text("LSF",
                                      style: GoogleFonts.lexendDeca(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                      )))),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Image(
                          image: AssetImage('assets/images/switch.png'),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(color: Colors.white),
                              ),
                              alignment: Alignment.center,
                              child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text("Français",
                                      style: GoogleFonts.lexendDeca(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                      )))),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            // Camera view
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Placeholder(
                  fallbackHeight: 128,
                  fallbackWidth: 72,
                ),
              ),
            ),
            // Card
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Bonjour",
                style: GoogleFonts.lexendDeca(
                  fontSize: 30.0,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
