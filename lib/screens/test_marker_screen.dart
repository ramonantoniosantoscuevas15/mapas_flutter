import 'package:flutter/material.dart';
import 'package:mapas/markers/markers.dart';

class TextMarkerScreen extends StatelessWidget {
   
  const TextMarkerScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
         child: SizedBox(
          
          width: 350,
          height: 150,
          child: CustomPaint(
            painter: EndMarkerPainter(destination: 'Por hay en Algun sitio del Mundo klk wawawa hola munfo', kilometers: 33),
          ),
         ),
      ),
    );
  }
}