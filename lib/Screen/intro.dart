



import 'package:finbul/Screen/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/slide_object.dart';

class IntroScreen extends StatefulWidget {

  @override
  IntroScreenState createState() => IntroScreenState();
}


class IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = [];

  Function goToTab;

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "WELCOME TO FINBUL",
        styleTitle: TextStyle(
          color: Colors.white,
          fontSize: 30.0,

        ),
        description:
        " \n\n\n\nGet Financial data of Stocks."
       ,
        styleDescription:
        TextStyle(color: Color(0xFFFEB904), fontSize: 20.0),
        pathImage: 'assets/slide2.png',
      ),
    );
    slides.add(
      new Slide(
        maxLineTextDescription: 6,
        title: "CHAT WITH FRIENDS",
        styleTitle:
        TextStyle(color: Colors.white, fontSize: 30.0,),
        description: "\n\n\nInteract with other individuals in the stock market.",
        styleDescription:
        TextStyle(color:  Color(0xFFFEB904), fontSize: 20.0,),
        pathImage:  'assets/slide1.png',
      ),
    );

  }

  void onDonePress() {
    // Back to the first tab
    this.goToTab(0);
  }

  void onTabChangeCompleted(index) {
    // Index of current tab is focused
    print(index);
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: Color(0xffffcc5c),
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: Color(0xffffcc5c),
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: Color(0xffffcc5c),
    );
  }

  ButtonStyle myButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(StadiumBorder()),
      backgroundColor: MaterialStateProperty.all<Color>(Color(0x33ffcc5c)),
      overlayColor: MaterialStateProperty.all<Color>(Color(0x33ffcc5c)),
    );
  }

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = [];
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(Container(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          margin: EdgeInsets.only(bottom: 60.0, top: 60.0),
          child: ListView(
            children: <Widget>[
              GestureDetector(
                  child: Image.asset(
                    currentSlide.pathImage,
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.contain,
                  )),
              Container(
                child: Text(
                  currentSlide.title,
                  style: currentSlide.styleTitle,
                  textAlign: TextAlign.center,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
              Container(
                child: Text(
                  currentSlide.description,
                  style: currentSlide.styleDescription,
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
            ],
          ),
        ),
      ));
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Color(0xFF372C6A),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Text(''),
        ),
        LayoutBuilder(
          builder: (_, constraints) => Image(
            image: AssetImage('assets/yellow.png'),
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.55,
            width: constraints.maxWidth,
            fit: BoxFit.fill,
          ),
        ),
        new IntroSlider(
          // Skip button
          renderSkipBtn: this.renderSkipBtn(),
          skipButtonStyle: myButtonStyle(),

          // Next button
          renderNextBtn: this.renderNextBtn(),
          nextButtonStyle: myButtonStyle(),

          // Done button
          renderDoneBtn: this.renderDoneBtn(),
          onDonePress: (){
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return SignUpScreen();
                },
                transitionsBuilder: (context, animation, secondaryAnimation, child){
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          },
          doneButtonStyle: myButtonStyle(),

          // Dot indicator
          colorDot: Color(0xffffcc5c),
          sizeDot: 13.0,
          typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,

          // Tabs
          listCustomTabs: this.renderListCustomTabs(),
          backgroundColorAllSlides: Colors.transparent,
          refFuncGoToTab: (refFunc) {
            this.goToTab = refFunc;
          },

          // Behavior
          scrollPhysics: BouncingScrollPhysics(),

          // Show or hide status bar
          hideStatusBar: true,

          // On tab change completed
          onTabChangeCompleted: this.onTabChangeCompleted,
        ),
      ],
    );
  }
}