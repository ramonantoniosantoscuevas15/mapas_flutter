import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class ManualMarker extends StatelessWidget {
  const ManualMarker({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(children: [
        const Positioned(top: 70, left: 20, child: _BtnBack()),
        Center(
          child: Transform.translate(
            offset: const Offset(0, -22),
            child: BounceInDown(
                from: 100,
                child: const Icon(
                  Icons.location_on_rounded,
                  size: 60,
                )),
          ),
        ),
        //Botton de confirmar
        Positioned(
          bottom: 70,
          left: 40,
          child: FadeInUp(
            
            child: MaterialButton(
              minWidth: size.width - 120,
              color: Colors.black,
              elevation: 0,
              height: 50,
              shape: const StadiumBorder(),
              onPressed: (){},
              child: const Text('Comfirmar destino', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),)
              ),
          )
          )
      ]),
    );
  }
}

class _BtnBack extends StatelessWidget {
  const _BtnBack({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      //duration: const Duration(milliseconds: 300),
      child: CircleAvatar(
        maxRadius: 25,
        backgroundColor: Colors.white,
        child: IconButton(onPressed: () {
          
        }, icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black,),),
      ),
    );
  }
}
