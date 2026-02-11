import 'dart:async';
import 'dart:math';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'dart:developer' as dev;
import 'package:rive/rive.dart' as rive;
import 'item_data.dart';
import 'package:flutter/material.dart';
import 'package:page_flip/page_flip.dart'; // Import the package
import 'BookCoverUI.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
void main(){
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey = "pk_test_51SzWtQ7cjiKqLFmnkI4Gmy6sQXSXb6iBmR5H1V3HZjE2YpDlipcAyJLacpY1ryFJFOCelWEIesQ9rcCXhVUNg0Ag00gyYNQfe0";
  runApp(const MaterialApp(
    home: RealisticBookApp(),
    debugShowCheckedModeBanner: false,

  ));
}

class RealisticBookApp extends StatefulWidget {
  const RealisticBookApp({super.key});

  @override
  State<RealisticBookApp> createState() => _RealisticBookAppState();
}

class _RealisticBookAppState extends State<RealisticBookApp> with SingleTickerProviderStateMixin{
  final GlobalKey<PageFlipWidgetState> _controller = GlobalKey<PageFlipWidgetState>();
  late AnimationController _hingeController;
  late Animation<double> _hingeAnimation;
  ValueNotifier<bool> swipeNotifier = ValueNotifier(true);
  bool _showCover = true;

  @override
  void initState() {
    super.initState();
    //print("heloo");
    Timer( Duration(seconds: 12), () {
      //print("REbuild again");
        swipeNotifier.value=false;
        //print(_swipe);
    });
    _hingeController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Rotates from 0 to 90 degrees (Hinge Open)
    _hingeAnimation = Tween<double>(begin: 0.0, end: pi / 2).animate(
      CurvedAnimation(parent: _hingeController, curve: Curves.easeInOutCubic),
    );

    // Sequence: Wait 2 seconds, then swing cover open
    Future.delayed(const Duration(seconds: 4), () {
      _hingeController.forward().then((_) {
        setState(() {
          _showCover = false; // Hide cover after it swings open to save memory
        });
      });
    });
  }

  @override
  void dispose() {
    _hingeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Background behind the book
      body: Column(
        children: [
          SizedBox(height: 20,),
          Expanded(
            child: Stack(
              children:[
                Container(color: const Color(0xFF004D40)),
                PageFlipWidget(
                key: _controller,
                // The animation curve for the flip
                cutoffForward: 1,
                cutoffPrevious: 1,
                  backgroundColor: Colors.transparent,
                duration: Duration(milliseconds: 600),
                children: [
                  for (int i = 0; i < myProducts.length; i++)
                    _buildProductPage(
                        myProducts[i],
                        i + 1, // Current page index (accounting for cover)
                        myProducts.length + 1 // Total pages including cover
                    ),
                  // _buildProductPage("Pro Headphones", "assets/images/headphones.png", "\$250"),
                  // _buildProductPage("Gaming Mouse", "assets/images/mouse.png", "\$80"),
                  // _buildProductPage("Mechanical Keyboard", "assets/images/keyboard.png", "\$150"),
                ],
              ),
                if (_showCover)
                  AnimatedBuilder(
                    animation: _hingeAnimation,
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.centerLeft, // THE HINGE POINT
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001) // Perspective (Depth)
                          ..rotateY(_hingeAnimation.value),
                        child: BookCoverUI(),
                      );
                    },
                  ),
            ]
            ),
          ),
        ],
      ),
    );
  }



  // --- 2. PRODUCT PAGE (White Page inside Red Frame) ---


  Widget _buildProductPage(ProductItem item, int currentIndex, int totalPages) {
    int remainingPages = totalPages - currentIndex - 1;
    double pageWidth = MediaQuery.of(context).size.width * 0.95;
    //double pageheight=MediaQuery.of(context).size.height*0.85;
    // print("rebuild product page");
    // print(_swipe.toString());
    return Align(
      alignment: Alignment.centerLeft,
      child: Stack(
        //alignment: Alignment.centerRight,
        clipBehavior: Clip.none,
        children: [
          // 1. THE 3D DEPTH LAYERS (Add these first so they sit behind)
          if (remainingPages > 0) ...[
            _buildBackPageLayer(pageWidth, 8), // Furthest back
            _buildBackPageLayer(pageWidth, 4), // Middle
          ],

          // 2. THE MAIN WHITE PAGE
          Container(
            width: pageWidth,
            height: MediaQuery.of(context).size.height * 0.92,
            decoration: BoxDecoration(
              color: const Color(0xFFFDFCF8),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.3),
                  blurRadius: 12,
                  offset: const Offset(4, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                _buildSpineShadow(), // The left fold shadow

                // Your Product Content
                Column(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 40),
                    Align(alignment: Alignment.center,
                        child: Text(item.name, style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold))
                    ),
                    Divider(height: 7.0,thickness: 5,color: Colors.black,),
                    Flexible(
                      child: AspectRatio(
                        aspectRatio: 1/1,
                        child: ModelViewer(
                          backgroundColor: Colors.transparent,
                          src: item.imagePath, // Your 3D file
                          alt: "A 3D model of a product",
                          ar: true, // Allows user to place it in their room using AR
                          autoRotate: true,
                          autoPlay: true,
                          cameraControls: true,
                          loading:Loading.lazy,// Allows user to zoom and rotate with fingers
                        ),
                      ),
                    ),
                    Divider(height: 7.0,thickness: 5,color: Colors.black,),
                    Text("Price : ${item.price}", style: TextStyle(fontSize: 40, color: Colors.red,fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    ElevatedButton(onPressed: (){},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Pill shape
                        ),
                        elevation: 5,
                      ),
                      child: const Text("BUY NOW"),
                    ),
                    //const SizedBox(height: 50),
                    ValueListenableBuilder(
                        valueListenable: swipeNotifier,
                        builder: (context,value,child){
                          return value?SizedBox(
                              child: AspectRatio(aspectRatio: 2/1,
                                child: rive.RiveAnimation.asset('assests/swipe.riv'),
                              )
                          ):SizedBox.shrink();
                        })
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // HELPER METHOD for 3D depth
  Widget _buildBackPageLayer(double width, double offset) {
    return Transform.translate(
      offset: Offset(offset, 2),
      child: Container(
        width: width,
        height: MediaQuery.of(context).size.height * 0.92,
        decoration: BoxDecoration(
          color: const Color(0xFFE8E4D8),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(4),
            bottomRight: Radius.circular(4),
          ),
          border: Border(right: BorderSide(color: Colors.black.withOpacity(0.1))),
        ),
      ),
    );
  }

  // --- 3. REUSABLE SPINE SHADOW ---
  Widget _buildSpineShadow() {
    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      child: Container(
        width: 43,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.black.withValues(alpha: 0.4),
              Colors.black.withValues(alpha:0.3),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}