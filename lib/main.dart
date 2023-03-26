import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

late List<CameraDescription> _cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: const MyHomePage(title: 'SimpliSignes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final outputController = TextEditingController();
  late CameraController cameraController;
  late Socket socket;

  Uint8List intToBytes(int value, int byteCount, Endian endian) {
    final data = ByteData(byteCount);
    data.setInt32(0, value, endian);
    return data.buffer.asUint8List();
  }

  @override
  void initState() {
    super.initState();
    cameraController = CameraController(
        _cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front),
        ResolutionPreset.low,
        enableAudio: false);
    cameraController.initialize().then((_) async {
      if (!mounted) {
        return;
      }
      setState(() {});
      /*
      await cameraController.startImageStream((CameraImage availableImage) async {
        print(availableImage.format.raw);
      });*/
      try {
        socket = await Socket.connect('192.168.208.153', 8123);
        /*
        print("connected to socket");
        socket.write('Hello from Flutter!');
        socket.listen((data) {
          print('Received: ${String.fromCharCodes(data)}');
          socket.destroy();
        });
        */
        bool sendDimension = true;
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
    if (!cameraController.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: MediaQuery.of(context).size.width - 10,
                height: MediaQuery.of(context).size.height / 1.6,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromRGBO(255, 255, 255, 0.3),
                        width: 2.0),
                    borderRadius: BorderRadius.circular(25.0)),
                clipBehavior: Clip.hardEdge,
                child: CameraPreview(cameraController),
              ),
            ),
            const Text(
              'Français',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Bonjour"),
                controller: outputController,
                readOnly: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
