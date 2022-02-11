import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:journal/screens/home_screen.dart';
import 'package:video_player/video_player.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/images/Onboarding2.mp4');
    _controller.setLooping(true);
    _controller.play();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Journal app",
          body: "Keep a track of what's happing in your life with Journal!",
          image: Image(
            image: AssetImage("assets/images/Onboarding1.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        PageViewModel(
          title: "Deleting an entry is just a swipe away!",
          body: "Just swipe from left to right to delete an entry",
          image: Image(
            image: AssetImage("assets/images/Onboarding2.png"),
          ),
        ),
        PageViewModel(
          title: "Shivam Pachchigar",
          body:
              "This app is made by Shivam Pachchigar. \n All rights reserved.",
          image: CircleAvatar(
            foregroundImage: AssetImage("assets/images/shivam.jpg"),
            radius: 120,
          ),
        ),
      ],
      done: Text("Got it!"),
      onDone: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      },
      showSkipButton: false,
      next: Icon(Icons.arrow_forward),
    );
  }
}

class Onboarding2 extends StatelessWidget {
  const Onboarding2({
    Key? key,
    required VideoPlayerController controller,
  })  : _controller = controller,
        super(key: key);

  final VideoPlayerController _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          VideoPlayer(_controller),
          Text(
            "Deleting entry is just a swipe away!",
          )
        ],
      ),
    );
  }
}

class Onboarding1 extends StatelessWidget {
  const Onboarding1({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Image(image: AssetImage("assets/images/Onboarding1.jpeg")),
    ));
  }
}
