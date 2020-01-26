import 'package:find_room/app/app.dart';
import 'package:find_room/pages/post/steppers/address_step.dart';
import 'package:find_room/pages/post/steppers/category_step.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostRoomPage extends StatefulWidget {
  const PostRoomPage({Key key}) : super(key: key);

  @override
  _PostRoomPageState createState() => _PostRoomPageState();
}

class _PostRoomPageState extends State<PostRoomPage> {
  var currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final steps = <Step>[
      Step(
        title: Text('Select a category'),
        content: const SelectCategoryStep(),
        isActive: currentStep == 0,
      ),
      Step(
        title: Text('Address'),
        content: const AddressStep(),
        isActive: currentStep == 1,
      ),
      Step(
        title: Text('Photos'),
        content: Container(
          height: 500,
          color: Colors.redAccent,
        ),
        isActive: currentStep == 2,
      ),
      Step(
        title: Text('Other information'),
        content: Container(
          height: 500,
          color: Colors.deepOrangeAccent,
        ),
        isActive: currentStep == 3,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Post room'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => RootScaffold.openDrawer(context),
        ),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: Stepper(
          physics: ClampingScrollPhysics(),
          type: StepperType.vertical,
          currentStep: currentStep,
          onStepTapped: (index) {
            if (currentStep != index) {
              setState(() => currentStep = index);
            }
          },
          onStepContinue: () {
            if (currentStep < steps.length - 1) {
              setState(() => currentStep++);
            } else {
              print('Submit');
            }
          },
          onStepCancel: currentStep > 0
              ? () {
                  if (currentStep > 0) {
                    setState(() => currentStep--);
                  }
                }
              : null,
          steps: steps,
        ),
      ),
    );
  }
}
