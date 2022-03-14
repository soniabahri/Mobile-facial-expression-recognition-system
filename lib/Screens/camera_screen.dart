import 'package:flutter/material.dart';
import 'package:camera/camera.dart';


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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = CameraController(widget.camera, ResolutionPreset.ultraHigh);

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
    return (!controller.value.isInitialized)? Container(): CameraPreview(controller);
  }

}
