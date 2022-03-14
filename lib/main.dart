import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'Screens/camera_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expression Recognition'),
      ),
      body: SingleChildScrollView(
        child: Column(
            children: [
              SizedBox(height: size.height*.2,),

              Center(
                child: SvgPicture.asset("lib/assets/svg/exciting.svg",
                  width: size.width*.4,
                  ),

              ),
              SizedBox(height: size.height*.2,),
              ElevatedButton(onPressed: () async{
                await availableCameras().then((cameras){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> CameraScreen(cameras: cameras)),);

                });
              }, child: const Text("Press me !"), )

            ],

        ),
      ),
    );
  }
}
