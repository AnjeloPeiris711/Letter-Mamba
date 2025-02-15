import 'package:flutter/material.dart';
import 'package:finger_painter/finger_painter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:math';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:vocabulary/routes/snake_game.dart';

class QuizzesDashbordScreen extends StatefulWidget {
  const QuizzesDashbordScreen({super.key});

  @override
  QuizzesDashbordScreenState createState() => QuizzesDashbordScreenState();
}

class QuizzesDashbordScreenState extends State<QuizzesDashbordScreen> {
  late PainterController _painterController;
  Timer? _timer;
  int timeLeft = 10;
  String? imageUrl;
  int score = 0;
  bool timeUp = false;
  bool isClearing = false;
  late SharedPreferences _prefs;
  bool isProcessing = false;
  String _recognitionResult = '';
  Interpreter? _interpreter;
  Map<String, int> retryAttempts = {};
  bool isGameComplete = false;

// List of image names
  List<String> imageList = [
    'cat.png',
    'dog.png',
    'mango.png', // Add your images here
    'panda.png',
    'rabbit.png',
    'parrot.png'
  ];
  List<String> usedImages = [];

  @override
  void initState() {
    super.initState();
    _painterController = PainterController()
      ..setStrokeColor(const Color.fromARGB(255, 192, 12, 12))
      ..setMinStrokeWidth(3)
      ..setMaxStrokeWidth(10);
    loadScore();
    startTimer();
    loadRandomImage();
    initTensorFlow();
  }

// Load saved score
  Future<void> loadScore() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      score = _prefs.getInt('score') ?? 0; // Get saved score or default to 0
    });
  }

// Save score
  Future<void> saveScore() async {
    await _prefs.setInt('score', score);
  }

  //Load the file
  Future<void> initTensorFlow() async {
    try {
      _interpreter =
          await Interpreter.fromAsset('assets/model/quize_mobilenet.tflite');
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  // Preprocess image for model input
  List<List<List<List<num>>>> preprocessImage(Uint8List bytes) {
    // Decode the image bytes
    final image = img.decodeImage(bytes);
    if (image == null) return [];

    // Resize image to match model input size (assuming 224x224)
    final resizedImage = img.copyResize(image, width: 224, height: 224);

    // Convert to RGB format and normalize to 0-255 (quantized model)
    var imageMatrix = List.generate(
      1,
      (i) => List.generate(
        224,
        (y) => List.generate(
          224,
          (x) => List.generate(3, (c) {
            // Get pixel color
            final pixel = resizedImage.getPixel(x, y);
            // Extract RGB components using the updated methods
            return c == 0
                ? pixel.r // Red component
                : c == 1
                    ? pixel.g.toDouble() // Green component
                    : pixel.b.toDouble(); // Blue component
          }),
        ),
      ),
    );
    print('image matrix: $imageMatrix');
    return imageMatrix;
  }

  // Add method to process the drawing
  Future<void> analyzeDrawing(Uint8List bytes) async {
    if (isProcessing || _interpreter == null) return;

    setState(() {
      isProcessing = true;
    });

    try {
      // Preprocess the image
      final input = preprocessImage(bytes);
      if (input.isEmpty) {
        throw Exception('Failed to preprocess image');
      }

      // Prepare output tensor
      var output = List<List<num>>.filled(
          1,
          List<num>.filled(6,
              0)); // Adjust based on your model's output shape // Print all class probabilities
      // Run inference
      _interpreter!.run(input, output);

      // Process results
      var maxScore = 0.0;
      var maxIndex = 0;
      for (var i = 0; i < output[0].length; i++) {
        if (output[0][i] > maxScore) {
          maxScore = output[0][i].toDouble();
          maxIndex = i;
        }
      }
      print('Model output: ${output[0]}');
      print('Max score: $maxScore at index: $maxIndex');
      // Get label (you'll need to load and process your labels file)
      final label = await getLabel(maxIndex);
      print("lable: $label");
      setState(() {
        _recognitionResult = label;
        checkAnswer();
      });
    } catch (e) {
      print('Error during inference: $e');
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  Future<String> getLabel(int index) async {
    // Load and process your labels.txt file
    List<String> labels = [
      'cat',
      'dog',
      'mango', // Add your images here
      'panda',
      'rabbit',
      'parrot'
    ];
    // This is a placeholder implementation

    return labels[index];
  }

  void checkAnswer() {
    if (imageUrl == null) return;
    final currentImage =
        imageUrl!.split('/').last.split('.').first.toLowerCase();
    final prediction = _recognitionResult.toLowerCase();
    print('current image: $currentImage');
    print('predeiction: $prediction');
    if (currentImage == prediction) {
      int pointsToAdd = 10; // Default points for first attempt
      if (retryAttempts.containsKey(currentImage)) {
        pointsToAdd = 5; // Reduced points for retry attempts
      }
      // Correct answer
      setState(() {
        score += pointsToAdd;
        retryAttempts
            .remove(currentImage); // Clear retry attempts for this image
      });

      // Show success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Correct! +$pointsToAdd points'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );

      // Load next image
      loadRandomImage();
      // Clear the canvas
      _painterController.clearContent(
        clearColor: const Color.fromARGB(255, 237, 255, 143),
      );
    } else {
      // Wrong answer
      setState(() {
        if (!retryAttempts.containsKey(currentImage)) {
          retryAttempts[currentImage] = 1;
        } else {
          retryAttempts[currentImage] = retryAttempts[currentImage]! + 1;
        }
      });

      // Show "Try again" message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Try again! (Next correct attempt will be worth 5 points)'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        setState(() {
          timeUp = true;
          _timer?.cancel();
          // Clear the current drawing
          _painterController.clearContent(
            clearColor: const Color.fromARGB(255, 237, 255, 143),
          );
          // Load a new image when time is up
          loadRandomImage();
          // Reset the timer and timeUp flag
          timeLeft = 10;
          timeUp = false;
          // Start the timer again
          startTimer();
        });
      }
    });
  }

  void loadRandomImage() {
    if (usedImages.length == imageList.length) {
      navigateToDashboard();
      return;
      // All images used, reset the used list to start again
      // usedImages.clear();
      // retryAttempts.clear();
    }

    final random = Random();
    String selectedImage;
    do {
      selectedImage = imageList[random.nextInt(imageList.length)];
    } while (usedImages.contains(selectedImage));

    setState(() {
      imageUrl = 'assets/quizzes/$selectedImage';
      usedImages.add(selectedImage);
    });
  }

  void navigateToDashboard() {
    // Cancel timer before navigating
    _timer?.cancel();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SnakeSplashScreen(), // Pass the score to dashboard
      ),
    );
  }

  void submitAnswer() {
    setState(() {
      score += 10;
      saveScore(); // Save score whenever it changes
    });
  }

  Future<void> saveDrawing(Uint8List bytes) async {
    // Only save if we're not clearing the canvas
    if (!isClearing) {
      await ImageGallerySaverPlus.saveImage(Uint8List.fromList(bytes));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header with greeting, timer, and score
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hello, child!',
                    style: GoogleFonts.irishGrover(
                      fontSize: 24,
                      color: const Color(0xFF8A70FF),
                    ),
                  ),
                  // Timer circle gauge
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(
                          minimum: 0,
                          maximum: 1,
                          startAngle: 90,
                          endAngle: 90,
                          showLabels: false,
                          showTicks: false,
                          axisLineStyle: const AxisLineStyle(
                            thickness: 5,
                            color: Color.fromARGB(255, 191, 181, 236),
                            thicknessUnit: GaugeSizeUnit.logicalPixel,
                          ),
                          ranges: <GaugeRange>[
                            GaugeRange(
                              startValue: 0,
                              endValue: (timeLeft / 60)
                                  .toDouble(), // This will represent the progress
                              color:
                                  const Color(0xFF8A70FF), // Progress bar color
                              startWidth: 5,
                              endWidth: 5,
                            ),
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                              widget: Text(
                                timeLeft.toString().padLeft(2, '0'),
                                style: GoogleFonts.irishGrover(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              angle: 90,
                              positionFactor: 0.1,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8A70FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          score.toString().padLeft(3, '0'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // ClipOval to make the image circular
                        ClipOval(
                          child: Image.asset(
                            'assets/images/coin.png',
                            height: 30, // Desired image size
                            width: 30, // Desired image size
                            fit: BoxFit
                                .cover, // Ensures the image fills the circle
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),

              const SizedBox(height: 20),

              // Image Display Box
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF8A70FF),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(197, 158, 158, 158),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          imageUrl!,
                          fit: BoxFit.contain,
                        ),
                      )
                    : const Center(
                        child: Text(
                          'Image will appear here',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
              ),

              const SizedBox(height: 20),

              // Drawing Area
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 237, 255, 143),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF8A70FF),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Painter(
                          controller: _painterController,
                          backgroundColor:
                              const Color.fromARGB(255, 237, 255, 143),
                          size: const Size(double.infinity, double.infinity),
                          child: Container(),
                          // onDrawingEnded: (Uint8List? bytes) {
                          //   if (bytes != null && bytes.isNotEmpty) {
                          //     analyzeDrawing(bytes);
                          //     saveDrawing(bytes);
                          //   }
                          // },
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Row(
                          children: [
                            // Submit Button
                            Container(
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: isProcessing
                                    ? CircularProgressIndicator()
                                    : Icon(Icons.check, color: Colors.green),
                                onPressed: isProcessing
                                    ? null
                                    : () async {
                                        final bytes =
                                            _painterController.getImageBytes();
                                        if (bytes != null) {
                                          await analyzeDrawing(bytes);
                                        }
                                      },
                              ),
                            ),
                            // Clear Button
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    isClearing = true;
                                  });
                                  _painterController.clearContent(
                                    clearColor: const Color.fromARGB(
                                        255, 237, 255, 143),
                                  );
                                  setState(() {
                                    isClearing = false;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
