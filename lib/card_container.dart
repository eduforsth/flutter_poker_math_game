import 'package:flutter/material.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:flutter_flip_card/flipcard/flip_card.dart';
import 'package:flutter_flip_card/modal/flip_side.dart';

class CardContainer extends StatefulWidget {
   String showImage;
   String hiddenImage;
   FlipCardController controller;
   Animation animation;
   CardContainer({super.key, required this.showImage, required this.hiddenImage, required this.controller, required this.animation});

  @override
  State<CardContainer> createState() => _CardContainerState();
}

class _CardContainerState extends State<CardContainer> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Spacer(),
                        AnimatedBuilder(
                          animation: widget.animation,
                          builder: (context, w) {
                            return Transform.scale(
                              scale: widget.animation.value ,
                              child: Image.asset(
                                'assets/images/${widget.showImage}',
                                fit: BoxFit.cover,
                              ),
                            );
                          }
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      children: [
                        const Spacer(),
                        // Image.asset('assets/images/$hiddenImage', fit: BoxFit.cover,),
                        ////
                        FlipCard(
                            rotateSide: RotateSide.bottom,
                            onTapFlipping:
                                false, //When enabled, the card will flip automatically when touched.
                            axis: FlipAxis.horizontal,
                            controller: widget.controller,
                            frontWidget: Center(
                                child: Image.asset(
                                    'assets/images/background.png',
                                    fit: BoxFit.cover)),
                            backWidget: Image.asset(
                                'assets/images/${widget.hiddenImage}',
                                fit: BoxFit.cover)),

                        ///
                        const Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
         
          ;
  }
}