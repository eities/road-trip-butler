/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class SuggestedStop implements _i1.SerializableModel {
  SuggestedStop._({
    this.id,
    required this.tripId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.category,
    required this.butlerNote,
    this.rating,
    this.priceLevel,
    required this.status,
    required this.estimatedArrivalTime,
  });

  factory SuggestedStop({
    int? id,
    required int tripId,
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required String category,
    required String butlerNote,
    double? rating,
    int? priceLevel,
    required int status,
    required DateTime estimatedArrivalTime,
  }) = _SuggestedStopImpl;

  factory SuggestedStop.fromJson(Map<String, dynamic> jsonSerialization) {
    return SuggestedStop(
      id: jsonSerialization['id'] as int?,
      tripId: jsonSerialization['tripId'] as int,
      name: jsonSerialization['name'] as String,
      address: jsonSerialization['address'] as String,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      category: jsonSerialization['category'] as String,
      butlerNote: jsonSerialization['butlerNote'] as String,
      rating: (jsonSerialization['rating'] as num?)?.toDouble(),
      priceLevel: jsonSerialization['priceLevel'] as int?,
      status: jsonSerialization['status'] as int,
      estimatedArrivalTime: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['estimatedArrivalTime'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int tripId;

  String name;

  String address;

  double latitude;

  double longitude;

  String category;

  String butlerNote;

  double? rating;

  int? priceLevel;

  int status;

  DateTime estimatedArrivalTime;

  /// Returns a shallow copy of this [SuggestedStop]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SuggestedStop copyWith({
    int? id,
    int? tripId,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    String? category,
    String? butlerNote,
    double? rating,
    int? priceLevel,
    int? status,
    DateTime? estimatedArrivalTime,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SuggestedStop',
      if (id != null) 'id': id,
      'tripId': tripId,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'category': category,
      'butlerNote': butlerNote,
      if (rating != null) 'rating': rating,
      if (priceLevel != null) 'priceLevel': priceLevel,
      'status': status,
      'estimatedArrivalTime': estimatedArrivalTime.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SuggestedStopImpl extends SuggestedStop {
  _SuggestedStopImpl({
    int? id,
    required int tripId,
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required String category,
    required String butlerNote,
    double? rating,
    int? priceLevel,
    required int status,
    required DateTime estimatedArrivalTime,
  }) : super._(
         id: id,
         tripId: tripId,
         name: name,
         address: address,
         latitude: latitude,
         longitude: longitude,
         category: category,
         butlerNote: butlerNote,
         rating: rating,
         priceLevel: priceLevel,
         status: status,
         estimatedArrivalTime: estimatedArrivalTime,
       );

  /// Returns a shallow copy of this [SuggestedStop]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SuggestedStop copyWith({
    Object? id = _Undefined,
    int? tripId,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    String? category,
    String? butlerNote,
    Object? rating = _Undefined,
    Object? priceLevel = _Undefined,
    int? status,
    DateTime? estimatedArrivalTime,
  }) {
    return SuggestedStop(
      id: id is int? ? id : this.id,
      tripId: tripId ?? this.tripId,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      category: category ?? this.category,
      butlerNote: butlerNote ?? this.butlerNote,
      rating: rating is double? ? rating : this.rating,
      priceLevel: priceLevel is int? ? priceLevel : this.priceLevel,
      status: status ?? this.status,
      estimatedArrivalTime: estimatedArrivalTime ?? this.estimatedArrivalTime,
    );
  }
}
