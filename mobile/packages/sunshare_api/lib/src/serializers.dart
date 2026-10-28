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
import 'package:sunshare_api/src/model/admin_loop_out.dart';
import 'package:sunshare_api/src/model/admin_member_out.dart';
import 'package:sunshare_api/src/model/allocation_mode.dart';
import 'package:sunshare_api/src/model/approve_request.dart';
import 'package:sunshare_api/src/model/available_loop.dart';
import 'package:sunshare_api/src/model/consumer_summary.dart';
import 'package:sunshare_api/src/model/curve_step.dart';
import 'package:sunshare_api/src/model/dashboard.dart';
import 'package:sunshare_api/src/model/data_source.dart';
import 'package:sunshare_api/src/model/day_curves.dart';
import 'package:sunshare_api/src/model/http_validation_error.dart';
import 'package:sunshare_api/src/model/health_out.dart';
import 'package:sunshare_api/src/model/join_request.dart';
import 'package:sunshare_api/src/model/loop_create.dart';
import 'package:sunshare_api/src/model/loop_out.dart';
import 'package:sunshare_api/src/model/loop_stats.dart';
import 'package:sunshare_api/src/model/loop_status.dart';
import 'package:sunshare_api/src/model/loop_update.dart';
import 'package:sunshare_api/src/model/membership_out.dart';
import 'package:sunshare_api/src/model/membership_status.dart';
import 'package:sunshare_api/src/model/meter_create.dart';
import 'package:sunshare_api/src/model/meter_direction.dart';
import 'package:sunshare_api/src/model/meter_out.dart';
import 'package:sunshare_api/src/model/producer_summary.dart';
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
  AdminLoopOut,
  AdminMemberOut,
  AllocationMode,
  ApproveRequest,
  AvailableLoop,
  ConsumerSummary,
  CurveStep,
  Dashboard,
  DataSource,
  DayCurves,
  HTTPValidationError,
  HealthOut,
  JoinRequest,
  LoopCreate,
  LoopOut,
  LoopStats,
  LoopStatus,
  LoopUpdate,
  MembershipOut,
  MembershipStatus,
  MeterCreate,
  MeterDirection,
  MeterOut,
  ProducerSummary,
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
        const FullType(BuiltList, [FullType(AdminMemberOut)]),
        () => ListBuilder<AdminMemberOut>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(AvailableLoop)]),
        () => ListBuilder<AvailableLoop>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(AdminLoopOut)]),
        () => ListBuilder<AdminLoopOut>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(MeterOut)]),
        () => ListBuilder<MeterOut>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(MembershipOut)]),
        () => ListBuilder<MembershipOut>(),
      )
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer()))
    .build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
