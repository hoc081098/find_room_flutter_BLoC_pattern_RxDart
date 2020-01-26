import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/dependency_injection.dart';
import 'package:find_room/models/district_entity.dart';
import 'package:find_room/models/province_entity.dart';
import 'package:find_room/models/ward_entity.dart';
import 'package:find_room/pages/post/post_room_bloc.dart';
import 'package:find_room/utils/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stream_loader/stream_loader.dart';
import 'package:built_collection/built_collection.dart';

class AddressStep extends StatelessWidget {
  const AddressStep({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildProvinceTile(context),
          _buildDistrictTile(context),
          _buildWardTile(context),
          _buildLatLng(context),
        ],
      ),
    );
  }

  Widget _buildLatLng(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          title: Text('Latitude'),
          subtitle: Text('uknown'),
        ),
        ListTile(
          title: Text('Longitude'),
          subtitle: Text('uknown'),
        ),
        Row(
          children: <Widget>[
            const SizedBox(width: 12),
            IconButton(
              icon: Icon(
                Icons.location_on,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                //TODO:
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProvinceTile(BuildContext context) {
    const title = 'Select a province/city';
    final bloc = BlocProvider.of<PostRoomBloc>(context);

    return ListTile(
      title: StreamBuilder<ProvinceEntity>(
        stream: bloc.selectedProvince$,
        initialData: bloc.selectedProvince$.value,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data.name);
          }
          return Text(title);
        },
      ),
      trailing: Icon(Icons.navigate_next),
      onTap: () async {
        final provinceEntity = await showDialog<ProvinceEntity>(
          context: context,
          builder: (context) {
            final provinceDistrictWardRepo =
                Injector.of(context).provinceDistrictWardRepository;

            return _SelectAddressDialog<ProvinceEntity>(
              title: title,
              loader: provinceDistrictWardRepo.getAllProvinces,
              errorMessage: (_) => 'Error when loading provinces/cities',
              itemBuilder: (context, province) => Text(province.name),
              currentSelected: bloc.selectedProvince$.value,
            );
          },
        );

        if (provinceEntity != null) {
          bloc.selectedProvinceChanged(provinceEntity);
        }
      },
      isThreeLine: false,
    );
  }

  Widget _buildDistrictTile(BuildContext context) {
    const title = 'Select a district';
    final bloc = BlocProvider.of<PostRoomBloc>(context);

    return ListTile(
      title: StreamBuilder<DistrictEntity>(
        stream: bloc.selectedDistrict$,
        initialData: bloc.selectedDistrict$.value,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data.name);
          }
          return Text(title);
        },
      ),
      trailing: Icon(Icons.navigate_next),
      onTap: () async {
        final province = bloc.selectedProvince$.value;
        if (province == null) {
          return context.showSnackBar('Select a province/city first');
        }

        final districtEntity = await showDialog<DistrictEntity>(
          context: context,
          builder: (context) {
            final provinceDistrictWardRepo =
                Injector.of(context).provinceDistrictWardRepository;

            return _SelectAddressDialog<DistrictEntity>(
              title: title,
              loader: () =>
                  provinceDistrictWardRepo.getAllDistrictByProvince(province),
              errorMessage: (_) => 'Error when loading districts',
              itemBuilder: (context, district) => Text(district.name),
              currentSelected: bloc.selectedDistrict$.value,
            );
          },
        );

        if (districtEntity != null) {
          bloc.selectedDistrictChanged(districtEntity);
        }
      },
      isThreeLine: false,
    );
  }

  Widget _buildWardTile(BuildContext context) {
    const title = 'Select a ward';
    final bloc = BlocProvider.of<PostRoomBloc>(context);

    return ListTile(
      title: StreamBuilder<WardEntity>(
        stream: bloc.selectedWard$,
        initialData: bloc.selectedWard$.value,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data.name);
          }
          return Text(title);
        },
      ),
      trailing: Icon(Icons.navigate_next),
      onTap: () async {
        final province = bloc.selectedProvince$.value;
        final district = bloc.selectedDistrict$.value;
        if (province == null || district == null) {
          return context
              .showSnackBar('Select province/city and district first');
        }

        final wardEntity = await showDialog<WardEntity>(
          context: context,
          builder: (context) {
            final provinceDistrictWardRepo =
                Injector.of(context).provinceDistrictWardRepository;

            return _SelectAddressDialog<WardEntity>(
              title: title,
              loader: () => provinceDistrictWardRepo
                  .getAllWardByProvinceAndDistrict(province, district),
              errorMessage: (_) => 'Error when loading wards',
              itemBuilder: (context, ward) => Text(ward.name),
              currentSelected: bloc.selectedWard$.value,
            );
          },
        );

        if (wardEntity != null) {
          bloc.selectedWardChanged(wardEntity);
        }
      },
      isThreeLine: false,
    );
  }
}

class _SelectAddressDialog<T> extends StatelessWidget {
  final T currentSelected;
  final String title;
  final Stream<BuiltList<T>> Function() loader;
  final String Function(dynamic) errorMessage;
  final Widget Function(BuildContext, T) itemBuilder;

  const _SelectAddressDialog({
    Key key,
    @required this.currentSelected,
    @required this.title,
    @required this.loader,
    @required this.errorMessage,
    @required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
      ),
      content: LoaderWidget<BuiltList<T>>(
        blocProvider: () => LoaderBloc(
          loaderFunction: loader,
          initialContent: BuiltList.of([]),
        ),
        builder: (context, state, bloc) {
          if (state.error != null) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(
                    errorMessage(state.error),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle.copyWith(
                          fontSize: 14,
                        ),
                  ),
                  const SizedBox(height: 8),
                  RaisedButton(
                    onPressed: bloc.fetch,
                    color: Theme.of(context).accentColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: Text(
                      'Retry',
                    ),
                  ),
                ],
              ),
            );
          }

          if (state.isLoading) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              ],
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                for (final e in state.content)
                  ListTile(
                    title: itemBuilder(context, e),
                    onTap: () => Navigator.pop(context, e),
                    selected: currentSelected == e,
                    isThreeLine: false,
                  ),
              ],
            ),
          );
        },
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
