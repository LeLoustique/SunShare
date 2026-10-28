//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:sunshare_api/src/date_serializer.dart';
import 'package:sunshare_api/src/model/date.dart';

import 'package:sunshare_api/src/model/address_suggestion.dart';
import 'package:sunshare_api/src/model/http_validation_error.dart';
import 'package:sunshare_api/src/model/health_out.dart';
import 'package:sunshare_api/src/model/meter_create.dart';
import 'package:sunshare_api/src/model/meter_direction.dart';
import 'package:sunshare_api/src/model/meter_out.dart';
import 'package:sunshare_api/src/model/refresh_request.dart';
import 'package:sunshare_api/src/model/token_pair.dart';
import 'package:sunshare_api/src/model/user_create.dart';
import 'package:sunshare_api/src/model/user_out.dart';
import 'package:sunshare_api/src/model/user_role.dart';
import 'package:sunshare_api/src/model/validation_error.dart';
import 'package:sunshare_api/src/model/validation_error_loc_inner.dart';

part 'serializers.g.dart';

@SerializersFor([
  AddressSuggestion,
  HTTPValidationError,
  HealthOut,
  MeterCreate,
  MeterDirection,
  MeterOut,
  RefreshRequest,
  TokenPair,
  UserCreate,
  UserOut,
  UserRole,
  ValidationError,
  ValidationErrorLocInner,
])
Serializers serializers = (_$serializers.toBuilder()
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(AddressSuggestion)]),
        () => ListBuilder<AddressSuggestion>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(MeterOut)]),
        () => ListBuilder<MeterOut>(),
      )
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer()))
    .build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
