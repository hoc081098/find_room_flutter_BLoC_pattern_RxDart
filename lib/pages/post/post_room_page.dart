import 'package:find_room/app/app.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/models/category_entity.dart';
import 'package:find_room/pages/post/post_room_bloc.dart';
import 'package:flutter/material.dart';
import 'package:stream_loader/stream_loader.dart';
import 'package:built_collection/built_collection.dart';

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
        title: Text('Category'),
        content: const _SelectCategoryStep(),
        isActive: currentStep == 0,
      ),
      Step(
        title: Text('Address'),
        content: Text('Address'),
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

class _SelectCategoryStep extends StatefulWidget {
  const _SelectCategoryStep({ Key key }) : super(key: key);

  @override
  __SelectCategoryStepState createState() => __SelectCategoryStepState();
}

class __SelectCategoryStepState extends State<_SelectCategoryStep> {
  @override
  Widget build(BuildContext context) {
    final postRoomBloc = BlocProvider.of<PostRoomBloc>(context);
    final postRoomCategoriesBloc =
        BlocProvider.of<PostRoomCategoriesBloc>(context);
    final state$ = postRoomCategoriesBloc.state$;

    return StreamBuilder<LoaderState<BuiltList<CategoryEntity>>>(
      stream: state$,
      initialData: state$.value,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return StreamBuilder<String>(
          stream: postRoomBloc.selectedCategoryId$,
          initialData: postRoomBloc.selectedCategoryId$.value,
          builder: (context, snapshot) {
            final selectedId = snapshot.data;

            return Column(
              children: [
                for (final category in state.content)
                  ListTile(
                    leading:
                        category.id == selectedId ? Icon(Icons.check) : Icon(null),
                    selected: category.id == selectedId,
                    title: Text(category.name),
                    onTap: () => postRoomBloc.selectedCategoryIdChanged(category.id),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
