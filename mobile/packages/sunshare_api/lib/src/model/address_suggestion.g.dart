// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_suggestion.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AddressSuggestion extends AddressSuggestion {
  @override
  final String label;
  @override
  final String postcode;
  @override
  final String city;
  @override
  final num latitude;
  @override
  final num longitude;

  factory _$AddressSuggestion([void Function(AddressSuggestionBuilder)? updates]) =>
      (AddressSuggestionBuilder()..update(updates))._build();

  _$AddressSuggestion._(
      {required this.label,
      required this.postcode,
      required this.city,
      required this.latitude,
      required this.longitude})
      : super._();
  @override
  AddressSuggestion rebuild(void Function(AddressSuggestionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AddressSuggestionBuilder toBuilder() => AddressSuggestionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AddressSuggestion &&
        label == other.label &&
        postcode == other.postcode &&
        city == other.city &&
        latitude == other.latitude &&
        longitude == other.longitude;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, postcode.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AddressSuggestion')
          ..add('label', label)
          ..add('postcode', postcode)
          ..add('city', city)
          ..add('latitude', latitude)
          ..add('longitude', longitude))
        .toString();
  }
}

class AddressSuggestionBuilder implements Builder<AddressSuggestion, AddressSuggestionBuilder> {
  _$AddressSuggestion? _$v;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _postcode;
  String? get postcode => _$this._postcode;
  set postcode(String? postcode) => _$this._postcode = postcode;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  AddressSuggestionBuilder() {
    AddressSuggestion._defaults(this);
  }

  AddressSuggestionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _label = $v.label;
      _postcode = $v.postcode;
      _city = $v.city;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AddressSuggestion other) {
    _$v = other as _$AddressSuggestion;
  }

  @override
  void update(void Function(AddressSuggestionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AddressSuggestion build() => _build();

  _$AddressSuggestion _build() {
    final _$result = _$v ??
        _$AddressSuggestion._(
          label: BuiltValueNullFieldError.checkNotNull(label, r'AddressSuggestion', 'label'),
          postcode:
              BuiltValueNullFieldError.checkNotNull(postcode, r'AddressSuggestion', 'postcode'),
          city: BuiltValueNullFieldError.checkNotNull(city, r'AddressSuggestion', 'city'),
          latitude:
              BuiltValueNullFieldError.checkNotNull(latitude, r'AddressSuggestion', 'latitude'),
          longitude:
              BuiltValueNullFieldError.checkNotNull(longitude, r'AddressSuggestion', 'longitude'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
