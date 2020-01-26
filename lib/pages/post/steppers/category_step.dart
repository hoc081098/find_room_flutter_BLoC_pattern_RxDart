import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/models/category_entity.dart';
import 'package:find_room/pages/post/post_room_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stream_loader/stream_loader.dart';
import 'package:built_collection/built_collection.dart';

class SelectCategoryStep extends StatelessWidget {
  const SelectCategoryStep({Key key}) : super(key: key);

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
                    leading: category.id == selectedId
                        ? Icon(Icons.check)
                        : Icon(null),
                    selected: category.id == selectedId,
                    title: Text(category.name),
                    onTap: () =>
                        postRoomBloc.selectedCategoryIdChanged(category.id),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
