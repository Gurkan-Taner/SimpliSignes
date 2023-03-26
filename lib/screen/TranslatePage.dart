import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
import 'dart:convert';

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
  late Socket socket;

  Uint8List intToBytes(int value, int byteCount, Endian endian) {
    final data = ByteData(byteCount);
    data.setInt32(0, value, endian);
    return data.buffer.asUint8List();
  }

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
      try {
        socket = await Socket.connect('192.168.0.18', 65432);
        /*
        print("connected to socket");
        socket.write('Hello from Flutter!');
        socket.listen((data) {
          print('Received: ${String.fromCharCodes(data)}');
          socket.destroy();
        });
        */
        bool sendDimension = true;
        socket.listen((List<int> event) {
          String message = utf8.decode(event);
          print("Message from server: $message");
        });
        Uint8List delimiter = Uint8List.fromList(
            [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]);
        cameraController.startImageStream((CameraImage image) async {
          int y_plane_length = image.planes[0].bytes.length;
          int uv_plane_length = (image.width * image.height) ~/ 4;
          Uint8List bytes = Uint8List(y_plane_length + 2 * uv_plane_length);

          // Set the Y plane
          bytes.setRange(0, y_plane_length, image.planes[0].bytes);

          // Set the U plane, cropping the extra data
          bytes.setRange(y_plane_length, y_plane_length + uv_plane_length,
              image.planes[1].bytes.sublist(0, uv_plane_length));

          // Set the V plane, cropping the extra data
          bytes.setRange(
              y_plane_length + uv_plane_length,
              y_plane_length + 2 * uv_plane_length,
              image.planes[2].bytes.sublist(0, uv_plane_length));

          // Send the frame dimensions after connecting to the server
          if (sendDimension) {
            socket.add(intToBytes(
                image.width, 4, Endian.big)); // Send the frame width (4 bytes)
            socket.add(intToBytes(image.height, 4,
                Endian.big)); // Send the frame height (4 bytes)
            sendDimension = false;
          }

          int yuv_data_length = bytes.length;

          // Send the length of the YUV data
          socket.add(intToBytes(yuv_data_length, 4, Endian.big));

          // Send the YUV data
          socket.add(bytes);
          //socket.close();

          // Listen socket
          socket.listen((data) {
            print('Received: ${String.fromCharCodes(data)}');
          });
        });
      } catch (e) {
        print('Error socket: $e');
      }
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
