
import 'package:finbul/Widgets/icons.dart';
import 'package:flutter/material.dart';

enum Status {
  none,
  right,
  left,
}

class CustomSlider extends StatefulWidget {
  final ValueChanged<Status> valueChanged;

  CustomSlider({this.valueChanged});

  @override
  CustomSliderState createState() {
    return new CustomSliderState();
  }
}

class CustomSliderState extends State<CustomSlider> {
  ValueNotifier<double> valueListener = ValueNotifier(.0);

  var state = Status.none;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 15.0, bottom: 10),
          child: Icon(
            MyFlutterApp.bull,
            color: state == Status.left
                ? Color(0xFF26D375)
                : Color(0xFFF0F0F0),
          ),
        ),
        Container(
          width: 56,
          height: 27.0,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          //padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Stack(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      child: Container(
                        height: 20.0,
                        width: 18,
                        color: Colors.transparent,
                        child: Text(''),
                      ),
                      onTap: () {
                        setState(() {
                          state = Status.left;
                          if (widget.valueChanged != null) {
                            widget.valueChanged(state);
                          }
                        });
                      },
                    ),
                    InkWell(
                      child: Container(
                        height: 20.0,
                        width: 18,
                        color: Colors.transparent,
                        child: Text(''),
                      ),
                      onTap: () {
                        setState(() {
                          state = Status.none;
                          if (widget.valueChanged != null) {
                            widget.valueChanged(state);
                          }
                        });
                      },
                    ),
                    InkWell(
                      child: Container(
                        height: 20.0,
                        width: 18,
                        color: Colors.transparent,
                        child: Text(''),
                      ),
                      onTap: () {
                        setState(() {
                          state = Status.right;
                          if (widget.valueChanged != null) {
                            widget.valueChanged(state);
                          }
                        });
                      },
                    )
                  ],
                ),
                width: 56,
                height: 27.0,
                decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    border: Border.all(color: Color(0xFFF1F1FD)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black54.withOpacity(0.5),
                          blurRadius: 1.0,
                          offset: Offset(0.3, 1.0))
                    ],
                    borderRadius: BorderRadius.circular(20)),
              ),
              Builder(
                builder: (context) {
                  final handle = GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      if (valueListener.value >= 0.6) {

                        setState(() {
                          state = Status.right;
                          if (widget.valueChanged != null) {
                            widget.valueChanged(state);
                          }
                        });
                      } else if (valueListener.value <= 0.2) {

                        setState(() {
                          state = Status.left;
                          if (widget.valueChanged != null) {
                            widget.valueChanged(state);
                          }
                        });
                      } else {

                        setState(() {
                          state = Status.none;
                          if (widget.valueChanged != null) {
                            widget.valueChanged(state);
                          }
                        });
                      }

                      valueListener.value = (valueListener.value +
                          details.delta.dx / context.size.width)
                          .clamp(.0, 1.0);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        width: 17,
                        height: 17,
                        decoration: BoxDecoration(
                          color: state == Status.left
                              ? Color(0xFF26D375)
                              : state == Status.right
                              ? Colors.red
                              : Color(0xFF707070),
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                      ),
                    ),
                  );

                  return AnimatedBuilder(
                    animation: valueListener,
                    builder: (context, child) {
                      return AnimatedAlign(
                        alignment: state == Status.left
                            ? Alignment.centerLeft
                            : state == Status.right
                            ? Alignment.centerRight
                            : Alignment.center,
                        duration: const Duration(seconds: 1),
                        curve: Curves.fastOutSlowIn,
                        child: child,
                      );
                    },
                    child: handle,
                  );
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Icon(
            MyFlutterApp.bear,
            size: 25,
            color:  state == Status.right
                ? Colors.red
                : Color(0xFFF0F0F0),
          ),
        ),
      ],
    );
  }
}
