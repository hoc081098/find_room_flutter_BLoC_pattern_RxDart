import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

GeoPoint geoPointFromJson(GeoPoint geoPoint) => geoPoint;

GeoPoint geoPointToJson(GeoPoint geoPoint) => geoPoint;

DocumentReference documentReferenceFromJson(DocumentReference ref) => ref;

DocumentReference documentReferenceToJson(DocumentReference ref) => ref;

Timestamp timestampFromJson(Timestamp timestamp) => timestamp;

Timestamp timestampToJson(Timestamp timestamp) => timestamp;

Map<String, dynamic> withId(DocumentSnapshot doc) => CombinedMapView([
      doc.data,
      <String, dynamic>{'documentID': doc.documentID}
    ]);
