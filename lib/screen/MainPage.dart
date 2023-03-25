import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //mainAxisAlignment: MainAxisAlignment.center,
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
                              image: AssetImage("assets/images/account.png")
                            ),
                          )
                        )
                      ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                    child: InkWell(
                      child: Container(
                        alignment: Alignment.center,
                        height: size.height / 5,
                        decoration: BoxDecoration(
                          color: const Color(0xff472583),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Image(
                                  image: AssetImage("assets/images/translate_stf.png"),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Text(
                                  "Traduire\nun signe",
                                  style: GoogleFonts.lexendDeca(
                                    color: Colors.white,
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: SizedBox(),
                              )
                            ]
                          ),
                        ),
                      ),
                    )
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                    child: InkWell(
                      child: Container(
                        alignment: Alignment.center,
                        height: size.height / 5,
                        decoration: BoxDecoration(
                          color: const Color(0xff472583),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Image(
                                  image: AssetImage("assets/images/translate_fts.png"),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Text(
                                  "Traduire\nun mot",
                                  style: GoogleFonts.lexendDeca(
                                    color: Colors.white,
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: SizedBox(),
                              )
                            ]
                          ),
                        ),
                      ),
                    )
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                    child: InkWell(
                      child: Container(
                        alignment: Alignment.center,
                        height: size.height / 5,
                        decoration: BoxDecoration(
                          color: const Color(0xff472583),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Image(
                                  image: AssetImage("assets/images/add.png"),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Text(
                                  "Ajouter\nun signe",
                                  style: GoogleFonts.lexendDeca(
                                    color: Colors.white,
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: SizedBox(),
                              )
                            ]
                          ),
                        ),
                      ),
                    )
                ),
              ],
            ),
            const Expanded(child: SizedBox()),
            Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    "Mentions légales",
                    style: GoogleFonts.lexendDeca(),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
