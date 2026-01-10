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
import 'greetings/greeting.dart' as _i2;
import 'price_level.dart' as _i3;
import 'stop.dart' as _i4;
import 'stop_status.dart' as _i5;
import 'trip.dart' as _i6;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i7;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i8;
export 'greetings/greeting.dart';
export 'price_level.dart';
export 'stop.dart';
export 'stop_status.dart';
export 'trip.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.Greeting) {
      return _i2.Greeting.fromJson(data) as T;
    }
    if (t == _i3.PriceLevel) {
      return _i3.PriceLevel.fromJson(data) as T;
    }
    if (t == _i4.Stop) {
      return _i4.Stop.fromJson(data) as T;
    }
    if (t == _i5.StopStatus) {
      return _i5.StopStatus.fromJson(data) as T;
    }
    if (t == _i6.Trip) {
      return _i6.Trip.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Greeting?>()) {
      return (data != null ? _i2.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.PriceLevel?>()) {
      return (data != null ? _i3.PriceLevel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.Stop?>()) {
      return (data != null ? _i4.Stop.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.StopStatus?>()) {
      return (data != null ? _i5.StopStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.Trip?>()) {
      return (data != null ? _i6.Trip.fromJson(data) : null) as T;
    }
    try {
      return _i7.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i8.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.Greeting => 'Greeting',
      _i3.PriceLevel => 'PriceLevel',
      _i4.Stop => 'Stop',
      _i5.StopStatus => 'StopStatus',
      _i6.Trip => 'Trip',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'road_trip_butler.',
        '',
      );
    }

    switch (data) {
      case _i2.Greeting():
        return 'Greeting';
      case _i3.PriceLevel():
        return 'PriceLevel';
      case _i4.Stop():
        return 'Stop';
      case _i5.StopStatus():
        return 'StopStatus';
      case _i6.Trip():
        return 'Trip';
    }
    className = _i7.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i8.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i2.Greeting>(data['data']);
    }
    if (dataClassName == 'PriceLevel') {
      return deserialize<_i3.PriceLevel>(data['data']);
    }
    if (dataClassName == 'Stop') {
      return deserialize<_i4.Stop>(data['data']);
    }
    if (dataClassName == 'StopStatus') {
      return deserialize<_i5.StopStatus>(data['data']);
    }
    if (dataClassName == 'Trip') {
      return deserialize<_i6.Trip>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i7.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i8.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i7.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i8.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
