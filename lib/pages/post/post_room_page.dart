import 'package:find_room/app/app.dart';
import 'package:find_room/dependency_injection.dart';
import 'package:find_room/models/category_entity.dart';
import 'package:flutter/material.dart';
import 'package:stream_loader/stream_loader.dart';
import 'package:built_collection/built_collection.dart';

class PostRoomPage extends StatefulWidget {
  const PostRoomPage({Key key}) : super(key: key);

  @override
  _PostRoomPageState createState() => _PostRoomPageState();
}

class _PostRoomPageState extends State<PostRoomPage> {
  final steps = <Step>[
    Step(
      title: Text('Category'),
      content: _SelectCategoryStep(),
    ),
    Step(
      title: Text('Address'),
      content: Text('Address'),
    ),
  ];
  var currentStep = 0;

  @override
  Widget build(BuildContext context) {
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
          type: StepperType.horizontal,
          currentStep: currentStep,
          onStepTapped: (index) => setState(() => currentStep = index),
          onStepContinue: () {
            if (currentStep < steps.length - 1) {
              setState(() => currentStep++);
            }
          },
          onStepCancel: () {
            if (currentStep > 0) {
              setState(() => currentStep--);
            }
          },
          steps: steps,
        ),
      ),
    );
  }
}

class _SelectCategoryStep extends StatefulWidget {
  @override
  __SelectCategoryStepState createState() => __SelectCategoryStepState();
}

class __SelectCategoryStepState extends State<_SelectCategoryStep> {
  @override
  Widget build(BuildContext context) {
    var categoriesRepository = Injector.of(context).categoriesRepository;
    return LoaderWidget<BuiltList<CategoryEntity>>(
      blocProvider: () => LoaderBloc(
        loaderFunction: categoriesRepository.getAllCategories,
        enableLogger: true,
        initialContent: BuiltList.of([]),
      ),
      builder: (context, state, bloc) {
        if (state.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Column(
          children: state.content
              .map(
                (cat) => ListTile(
                  title: Text(cat.name),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
