// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'data_phone_number_page_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$DataPhoneNumberPageStateTearOff {
  const _$DataPhoneNumberPageStateTearOff();

  _DataPhoneNumberPageStateIdle idle(String phoneNumber) {
    return _DataPhoneNumberPageStateIdle(
      phoneNumber,
    );
  }

  _DataPhoneNumberPageStateLoading loading() {
    return _DataPhoneNumberPageStateLoading();
  }
}

/// @nodoc
const $DataPhoneNumberPageState = _$DataPhoneNumberPageStateTearOff();

/// @nodoc
mixin _$DataPhoneNumberPageState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String phoneNumber) idle,
    required TResult Function() loading,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String phoneNumber)? idle,
    TResult Function()? loading,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DataPhoneNumberPageStateIdle value) idle,
    required TResult Function(_DataPhoneNumberPageStateLoading value) loading,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DataPhoneNumberPageStateIdle value)? idle,
    TResult Function(_DataPhoneNumberPageStateLoading value)? loading,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DataPhoneNumberPageStateCopyWith<$Res> {
  factory $DataPhoneNumberPageStateCopyWith(DataPhoneNumberPageState value,
          $Res Function(DataPhoneNumberPageState) then) =
      _$DataPhoneNumberPageStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$DataPhoneNumberPageStateCopyWithImpl<$Res>
    implements $DataPhoneNumberPageStateCopyWith<$Res> {
  _$DataPhoneNumberPageStateCopyWithImpl(this._value, this._then);

  final DataPhoneNumberPageState _value;
  // ignore: unused_field
  final $Res Function(DataPhoneNumberPageState) _then;
}

/// @nodoc
abstract class _$DataPhoneNumberPageStateIdleCopyWith<$Res> {
  factory _$DataPhoneNumberPageStateIdleCopyWith(
          _DataPhoneNumberPageStateIdle value,
          $Res Function(_DataPhoneNumberPageStateIdle) then) =
      __$DataPhoneNumberPageStateIdleCopyWithImpl<$Res>;
  $Res call({String phoneNumber});
}

/// @nodoc
class __$DataPhoneNumberPageStateIdleCopyWithImpl<$Res>
    extends _$DataPhoneNumberPageStateCopyWithImpl<$Res>
    implements _$DataPhoneNumberPageStateIdleCopyWith<$Res> {
  __$DataPhoneNumberPageStateIdleCopyWithImpl(
      _DataPhoneNumberPageStateIdle _value,
      $Res Function(_DataPhoneNumberPageStateIdle) _then)
      : super(_value, (v) => _then(v as _DataPhoneNumberPageStateIdle));

  @override
  _DataPhoneNumberPageStateIdle get _value =>
      super._value as _DataPhoneNumberPageStateIdle;

  @override
  $Res call({
    Object? phoneNumber = freezed,
  }) {
    return _then(_DataPhoneNumberPageStateIdle(
      phoneNumber == freezed
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@Implements(BuildState)
class _$_DataPhoneNumberPageStateIdle implements _DataPhoneNumberPageStateIdle {
  _$_DataPhoneNumberPageStateIdle(this.phoneNumber);

  @override
  final String phoneNumber;

  @override
  String toString() {
    return 'DataPhoneNumberPageState.idle(phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _DataPhoneNumberPageStateIdle &&
            (identical(other.phoneNumber, phoneNumber) ||
                const DeepCollectionEquality()
                    .equals(other.phoneNumber, phoneNumber)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(phoneNumber);

  @JsonKey(ignore: true)
  @override
  _$DataPhoneNumberPageStateIdleCopyWith<_DataPhoneNumberPageStateIdle>
      get copyWith => __$DataPhoneNumberPageStateIdleCopyWithImpl<
          _DataPhoneNumberPageStateIdle>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String phoneNumber) idle,
    required TResult Function() loading,
  }) {
    return idle(phoneNumber);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String phoneNumber)? idle,
    TResult Function()? loading,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(phoneNumber);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DataPhoneNumberPageStateIdle value) idle,
    required TResult Function(_DataPhoneNumberPageStateLoading value) loading,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DataPhoneNumberPageStateIdle value)? idle,
    TResult Function(_DataPhoneNumberPageStateLoading value)? loading,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class _DataPhoneNumberPageStateIdle
    implements DataPhoneNumberPageState, BuildState {
  factory _DataPhoneNumberPageStateIdle(String phoneNumber) =
      _$_DataPhoneNumberPageStateIdle;

  String get phoneNumber => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  _$DataPhoneNumberPageStateIdleCopyWith<_DataPhoneNumberPageStateIdle>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$DataPhoneNumberPageStateLoadingCopyWith<$Res> {
  factory _$DataPhoneNumberPageStateLoadingCopyWith(
          _DataPhoneNumberPageStateLoading value,
          $Res Function(_DataPhoneNumberPageStateLoading) then) =
      __$DataPhoneNumberPageStateLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$DataPhoneNumberPageStateLoadingCopyWithImpl<$Res>
    extends _$DataPhoneNumberPageStateCopyWithImpl<$Res>
    implements _$DataPhoneNumberPageStateLoadingCopyWith<$Res> {
  __$DataPhoneNumberPageStateLoadingCopyWithImpl(
      _DataPhoneNumberPageStateLoading _value,
      $Res Function(_DataPhoneNumberPageStateLoading) _then)
      : super(_value, (v) => _then(v as _DataPhoneNumberPageStateLoading));

  @override
  _DataPhoneNumberPageStateLoading get _value =>
      super._value as _DataPhoneNumberPageStateLoading;
}

/// @nodoc

@Implements(BuildState)
class _$_DataPhoneNumberPageStateLoading
    implements _DataPhoneNumberPageStateLoading {
  _$_DataPhoneNumberPageStateLoading();

  @override
  String toString() {
    return 'DataPhoneNumberPageState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _DataPhoneNumberPageStateLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String phoneNumber) idle,
    required TResult Function() loading,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String phoneNumber)? idle,
    TResult Function()? loading,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DataPhoneNumberPageStateIdle value) idle,
    required TResult Function(_DataPhoneNumberPageStateLoading value) loading,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DataPhoneNumberPageStateIdle value)? idle,
    TResult Function(_DataPhoneNumberPageStateLoading value)? loading,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _DataPhoneNumberPageStateLoading
    implements DataPhoneNumberPageState, BuildState {
  factory _DataPhoneNumberPageStateLoading() =
      _$_DataPhoneNumberPageStateLoading;
}
