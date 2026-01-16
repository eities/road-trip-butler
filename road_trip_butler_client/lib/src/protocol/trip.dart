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
import 'stop.dart' as _i2;
import 'package:road_trip_butler_client/src/protocol/protocol.dart' as _i3;

abstract class Trip implements _i1.SerializableModel {
  Trip._({
    this.id,
    required this.description,
    required this.startAddress,
    required this.endAddress,
    required this.departureTime,
    required this.personality,
    required this.polyline,
    this.preferences,
    this.totalDurationMinutes,
    this.stops,
  });

  factory Trip({
    int? id,
    required String description,
    required String startAddress,
    required String endAddress,
    required DateTime departureTime,
    required String personality,
    required String polyline,
    String? preferences,
    int? totalDurationMinutes,
    List<_i2.Stop>? stops,
  }) = _TripImpl;

  factory Trip.fromJson(Map<String, dynamic> jsonSerialization) {
    return Trip(
      id: jsonSerialization['id'] as int?,
      description: jsonSerialization['description'] as String,
      startAddress: jsonSerialization['startAddress'] as String,
      endAddress: jsonSerialization['endAddress'] as String,
      departureTime: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['departureTime'],
      ),
      personality: jsonSerialization['personality'] as String,
      polyline: jsonSerialization['polyline'] as String,
      preferences: jsonSerialization['preferences'] as String?,
      totalDurationMinutes: jsonSerialization['totalDurationMinutes'] as int?,
      stops: jsonSerialization['stops'] == null
          ? null
          : _i3.Protocol().deserialize<List<_i2.Stop>>(
              jsonSerialization['stops'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String description;

  String startAddress;

  String endAddress;

  DateTime departureTime;

  String personality;

  String polyline;

  String? preferences;

  int? totalDurationMinutes;

  List<_i2.Stop>? stops;

  /// Returns a shallow copy of this [Trip]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Trip copyWith({
    int? id,
    String? description,
    String? startAddress,
    String? endAddress,
    DateTime? departureTime,
    String? personality,
    String? polyline,
    String? preferences,
    int? totalDurationMinutes,
    List<_i2.Stop>? stops,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Trip',
      if (id != null) 'id': id,
      'description': description,
      'startAddress': startAddress,
      'endAddress': endAddress,
      'departureTime': departureTime.toJson(),
      'personality': personality,
      'polyline': polyline,
      if (preferences != null) 'preferences': preferences,
      if (totalDurationMinutes != null)
        'totalDurationMinutes': totalDurationMinutes,
      if (stops != null) 'stops': stops?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TripImpl extends Trip {
  _TripImpl({
    int? id,
    required String description,
    required String startAddress,
    required String endAddress,
    required DateTime departureTime,
    required String personality,
    required String polyline,
    String? preferences,
    int? totalDurationMinutes,
    List<_i2.Stop>? stops,
  }) : super._(
         id: id,
         description: description,
         startAddress: startAddress,
         endAddress: endAddress,
         departureTime: departureTime,
         personality: personality,
         polyline: polyline,
         preferences: preferences,
         totalDurationMinutes: totalDurationMinutes,
         stops: stops,
       );

  /// Returns a shallow copy of this [Trip]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Trip copyWith({
    Object? id = _Undefined,
    String? description,
    String? startAddress,
    String? endAddress,
    DateTime? departureTime,
    String? personality,
    String? polyline,
    Object? preferences = _Undefined,
    Object? totalDurationMinutes = _Undefined,
    Object? stops = _Undefined,
  }) {
    return Trip(
      id: id is int? ? id : this.id,
      description: description ?? this.description,
      startAddress: startAddress ?? this.startAddress,
      endAddress: endAddress ?? this.endAddress,
      departureTime: departureTime ?? this.departureTime,
      personality: personality ?? this.personality,
      polyline: polyline ?? this.polyline,
      preferences: preferences is String? ? preferences : this.preferences,
      totalDurationMinutes: totalDurationMinutes is int?
          ? totalDurationMinutes
          : this.totalDurationMinutes,
      stops: stops is List<_i2.Stop>?
          ? stops
          : this.stops?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
