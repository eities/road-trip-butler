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
import 'price_level.dart' as _i2;
import 'stop_status.dart' as _i3;

abstract class Stop implements _i1.SerializableModel {
  Stop._({
    this.id,
    required this.tripId,
    required this.name,
    required this.slotTitle,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.category,
    required this.butlerNote,
    this.rating,
    required this.priceLevel,
    required this.status,
    this.detourTimeMinutes,
  });

  factory Stop({
    int? id,
    required int tripId,
    required String name,
    required String slotTitle,
    required String address,
    required double latitude,
    required double longitude,
    required String category,
    required String butlerNote,
    double? rating,
    required _i2.PriceLevel priceLevel,
    required _i3.StopStatus status,
    int? detourTimeMinutes,
  }) = _StopImpl;

  factory Stop.fromJson(Map<String, dynamic> jsonSerialization) {
    return Stop(
      id: jsonSerialization['id'] as int?,
      tripId: jsonSerialization['tripId'] as int,
      name: jsonSerialization['name'] as String,
      slotTitle: jsonSerialization['slotTitle'] as String,
      address: jsonSerialization['address'] as String,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      category: jsonSerialization['category'] as String,
      butlerNote: jsonSerialization['butlerNote'] as String,
      rating: (jsonSerialization['rating'] as num?)?.toDouble(),
      priceLevel: _i2.PriceLevel.fromJson(
        (jsonSerialization['priceLevel'] as String),
      ),
      status: _i3.StopStatus.fromJson((jsonSerialization['status'] as String)),
      detourTimeMinutes: jsonSerialization['detourTimeMinutes'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int tripId;

  String name;

  String slotTitle;

  String address;

  double latitude;

  double longitude;

  String category;

  String butlerNote;

  double? rating;

  _i2.PriceLevel priceLevel;

  _i3.StopStatus status;

  int? detourTimeMinutes;

  /// Returns a shallow copy of this [Stop]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Stop copyWith({
    int? id,
    int? tripId,
    String? name,
    String? slotTitle,
    String? address,
    double? latitude,
    double? longitude,
    String? category,
    String? butlerNote,
    double? rating,
    _i2.PriceLevel? priceLevel,
    _i3.StopStatus? status,
    int? detourTimeMinutes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Stop',
      if (id != null) 'id': id,
      'tripId': tripId,
      'name': name,
      'slotTitle': slotTitle,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'category': category,
      'butlerNote': butlerNote,
      if (rating != null) 'rating': rating,
      'priceLevel': priceLevel.toJson(),
      'status': status.toJson(),
      if (detourTimeMinutes != null) 'detourTimeMinutes': detourTimeMinutes,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StopImpl extends Stop {
  _StopImpl({
    int? id,
    required int tripId,
    required String name,
    required String slotTitle,
    required String address,
    required double latitude,
    required double longitude,
    required String category,
    required String butlerNote,
    double? rating,
    required _i2.PriceLevel priceLevel,
    required _i3.StopStatus status,
    int? detourTimeMinutes,
  }) : super._(
         id: id,
         tripId: tripId,
         name: name,
         slotTitle: slotTitle,
         address: address,
         latitude: latitude,
         longitude: longitude,
         category: category,
         butlerNote: butlerNote,
         rating: rating,
         priceLevel: priceLevel,
         status: status,
         detourTimeMinutes: detourTimeMinutes,
       );

  /// Returns a shallow copy of this [Stop]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Stop copyWith({
    Object? id = _Undefined,
    int? tripId,
    String? name,
    String? slotTitle,
    String? address,
    double? latitude,
    double? longitude,
    String? category,
    String? butlerNote,
    Object? rating = _Undefined,
    _i2.PriceLevel? priceLevel,
    _i3.StopStatus? status,
    Object? detourTimeMinutes = _Undefined,
  }) {
    return Stop(
      id: id is int? ? id : this.id,
      tripId: tripId ?? this.tripId,
      name: name ?? this.name,
      slotTitle: slotTitle ?? this.slotTitle,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      category: category ?? this.category,
      butlerNote: butlerNote ?? this.butlerNote,
      rating: rating is double? ? rating : this.rating,
      priceLevel: priceLevel ?? this.priceLevel,
      status: status ?? this.status,
      detourTimeMinutes: detourTimeMinutes is int?
          ? detourTimeMinutes
          : this.detourTimeMinutes,
    );
  }
}
