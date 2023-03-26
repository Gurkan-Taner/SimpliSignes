import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';

class TranslatePage extends StatefulWidget {
  const TranslatePage({required this.cameras, required this.stf, Key? key}) : super(key: key);
  final List<CameraDescription> cameras;
  final bool stf;

  @override
  State<TranslatePage> createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  late CameraController cameraController;
  late String first;
  late String second;

  @override
  void initState() {
    super.initState();
    first = widget.stf ? "LSF" : "Français";
    second = widget.stf ?"Français" : "LSF";
    cameraController = CameraController(widget.cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front), ResolutionPreset.high, enableAudio: false);
    cameraController.initialize().then((_) async {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
          // Handle access errors here.
            break;
          default:
          // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if(!cameraController.value.isInitialized){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

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
                                  child: Text(first,
                                      style: GoogleFonts.lexendDeca(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                      )))),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: InkWell(
                          onTap: _onTapSwitch,
                          child: Image(
                            image: AssetImage('assets/images/switch.png'),
                          ),
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
                                  child: Text(second,
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
                child: CameraPreview(cameraController),
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

  void _onTapSwitch() {
    setState(() {
      String temp = first;
      first = second;
      second = temp;
    });
  }
}
