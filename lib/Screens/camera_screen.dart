import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';


class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: const Text("Camera Detection"),)
      ,
      body: Camera(camera: widget.cameras[0]),
    );
  }
}


class Camera extends StatefulWidget {
  final CameraDescription camera;

  const Camera({Key? key, required this.camera}) : super(key: key);

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late CameraController controller ;
  final _faceDetector = GoogleMlKit.vision.faceDetector();
  double smile = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = CameraController(widget.camera, ResolutionPreset.ultraHigh);
    // GoogleMlKit.vision.faceDetector().processImage(inputImage);
    // controller.startImageStream((image) => null)
    controller.initialize().then((value){
        if(!mounted){
          return;
        }
        setState(() {

        });
    });




  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return (controller.value.isInitialized)?Column(children: [
        Container(child: CameraPreview(controller), height: size.height*0.8, width: size.width,),
        StreamBuilder(builder: (context, snapshot){
          return Text("$smile");
        }, stream: process(),)
    ],): Text("pls wait");

  }
  Stream<double>process() async*{


    WriteBuffer allBytes = WriteBuffer();

    controller.startImageStream((image) async{
      try {
        for (var plan in image.planes) {
          allBytes.putUint8List(plan.bytes);
        }
      } on AssertionError catch(e){
        smile = 0.0;
        return;
      }





      Uint8List bytes = allBytes.done().buffer.asUint8List();

      final planeData = image.planes.map(
            (Plane plane) {
          return InputImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        },
      ).toList();

      final Size imageSize =
      Size(image.width.toDouble(), image.height.toDouble());

      final InputImageRotation imageRotation =
          InputImageRotationMethods.fromRawValue(controller.description.sensorOrientation) ??
              InputImageRotation.Rotation_0deg;

      final InputImageFormat inputImageFormat =
          InputImageFormatMethods.fromRawValue(image.format.raw) ??
              InputImageFormat.NV21;

      final inputImageData = InputImageData(
        size: imageSize,
        imageRotation: imageRotation,
        inputImageFormat: inputImageFormat,
        planeData: planeData,
      );


      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        inputImageData: inputImageData,
      );
      print("hhh");
      return _faceDetector.processImage(inputImage).then((faces){
        for (var face in faces) {

          smile =  face.smilingProbability ?? 0.0;
          return;
        }
      });

    });

    yield smile;
  }
}


