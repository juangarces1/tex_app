
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tex_app/constans.dart';


class LoaderComponent extends StatelessWidget {
  final String text;

  // ignore: use_key_in_widget_constructors
  const LoaderComponent({this.text = ''});

  @override
  Widget build(BuildContext context) {
    return Center(      
        child: Container(          
          width: 210,
          height: 150,
          decoration: BoxDecoration(
            gradient: kGradientHome,
            borderRadius: BorderRadius.circular(10),
            border:  Border.all(color: const Color.fromARGB(255, 5, 44, 25)),
          ),
          child: Column(            
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SpinKitCubeGrid(
                color: kContrateFondoOscuro,
              ),
              const SizedBox(height: 20,),
              Text(text, style: const TextStyle(fontSize: 18, color: kContrateFondoOscuro),),
            ],
          ),
        ),
      );    
  }
}