// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'send_server.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RsSendServerError {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RsSendServerError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RsSendServerError()';
}


}

/// @nodoc
class $RsSendServerErrorCopyWith<$Res>  {
$RsSendServerErrorCopyWith(RsSendServerError _, $Res Function(RsSendServerError) __);
}


/// Adds pattern-matching-related methods to [RsSendServerError].
extension RsSendServerErrorPatterns on RsSendServerError {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RsSendServerError_InvalidUrl value)?  invalidUrl,TResult Function( RsSendServerError_Status value)?  status,TResult Function( RsSendServerError_InvalidResponse value)?  invalidResponse,TResult Function( RsSendServerError_Network value)?  network,TResult Function( RsSendServerError_Io value)?  io,TResult Function( RsSendServerError_Cancelled value)?  cancelled,TResult Function( RsSendServerError_Crypto value)?  crypto,TResult Function( RsSendServerError_UploadAuthRequired value)?  uploadAuthRequired,TResult Function( RsSendServerError_UploadAuthFailed value)?  uploadAuthFailed,TResult Function( RsSendServerError_UnsupportedUploadAuth value)?  unsupportedUploadAuth,TResult Function( RsSendServerError_Other value)?  other,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RsSendServerError_InvalidUrl() when invalidUrl != null:
return invalidUrl(_that);case RsSendServerError_Status() when status != null:
return status(_that);case RsSendServerError_InvalidResponse() when invalidResponse != null:
return invalidResponse(_that);case RsSendServerError_Network() when network != null:
return network(_that);case RsSendServerError_Io() when io != null:
return io(_that);case RsSendServerError_Cancelled() when cancelled != null:
return cancelled(_that);case RsSendServerError_Crypto() when crypto != null:
return crypto(_that);case RsSendServerError_UploadAuthRequired() when uploadAuthRequired != null:
return uploadAuthRequired(_that);case RsSendServerError_UploadAuthFailed() when uploadAuthFailed != null:
return uploadAuthFailed(_that);case RsSendServerError_UnsupportedUploadAuth() when unsupportedUploadAuth != null:
return unsupportedUploadAuth(_that);case RsSendServerError_Other() when other != null:
return other(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RsSendServerError_InvalidUrl value)  invalidUrl,required TResult Function( RsSendServerError_Status value)  status,required TResult Function( RsSendServerError_InvalidResponse value)  invalidResponse,required TResult Function( RsSendServerError_Network value)  network,required TResult Function( RsSendServerError_Io value)  io,required TResult Function( RsSendServerError_Cancelled value)  cancelled,required TResult Function( RsSendServerError_Crypto value)  crypto,required TResult Function( RsSendServerError_UploadAuthRequired value)  uploadAuthRequired,required TResult Function( RsSendServerError_UploadAuthFailed value)  uploadAuthFailed,required TResult Function( RsSendServerError_UnsupportedUploadAuth value)  unsupportedUploadAuth,required TResult Function( RsSendServerError_Other value)  other,}){
final _that = this;
switch (_that) {
case RsSendServerError_InvalidUrl():
return invalidUrl(_that);case RsSendServerError_Status():
return status(_that);case RsSendServerError_InvalidResponse():
return invalidResponse(_that);case RsSendServerError_Network():
return network(_that);case RsSendServerError_Io():
return io(_that);case RsSendServerError_Cancelled():
return cancelled(_that);case RsSendServerError_Crypto():
return crypto(_that);case RsSendServerError_UploadAuthRequired():
return uploadAuthRequired(_that);case RsSendServerError_UploadAuthFailed():
return uploadAuthFailed(_that);case RsSendServerError_UnsupportedUploadAuth():
return unsupportedUploadAuth(_that);case RsSendServerError_Other():
return other(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RsSendServerError_InvalidUrl value)?  invalidUrl,TResult? Function( RsSendServerError_Status value)?  status,TResult? Function( RsSendServerError_InvalidResponse value)?  invalidResponse,TResult? Function( RsSendServerError_Network value)?  network,TResult? Function( RsSendServerError_Io value)?  io,TResult? Function( RsSendServerError_Cancelled value)?  cancelled,TResult? Function( RsSendServerError_Crypto value)?  crypto,TResult? Function( RsSendServerError_UploadAuthRequired value)?  uploadAuthRequired,TResult? Function( RsSendServerError_UploadAuthFailed value)?  uploadAuthFailed,TResult? Function( RsSendServerError_UnsupportedUploadAuth value)?  unsupportedUploadAuth,TResult? Function( RsSendServerError_Other value)?  other,}){
final _that = this;
switch (_that) {
case RsSendServerError_InvalidUrl() when invalidUrl != null:
return invalidUrl(_that);case RsSendServerError_Status() when status != null:
return status(_that);case RsSendServerError_InvalidResponse() when invalidResponse != null:
return invalidResponse(_that);case RsSendServerError_Network() when network != null:
return network(_that);case RsSendServerError_Io() when io != null:
return io(_that);case RsSendServerError_Cancelled() when cancelled != null:
return cancelled(_that);case RsSendServerError_Crypto() when crypto != null:
return crypto(_that);case RsSendServerError_UploadAuthRequired() when uploadAuthRequired != null:
return uploadAuthRequired(_that);case RsSendServerError_UploadAuthFailed() when uploadAuthFailed != null:
return uploadAuthFailed(_that);case RsSendServerError_UnsupportedUploadAuth() when unsupportedUploadAuth != null:
return unsupportedUploadAuth(_that);case RsSendServerError_Other() when other != null:
return other(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  invalidUrl,TResult Function( int status)?  status,TResult Function( String field0)?  invalidResponse,TResult Function( String field0)?  network,TResult Function( String field0)?  io,TResult Function()?  cancelled,TResult Function()?  crypto,TResult Function()?  uploadAuthRequired,TResult Function()?  uploadAuthFailed,TResult Function( String field0)?  unsupportedUploadAuth,TResult Function( String field0)?  other,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RsSendServerError_InvalidUrl() when invalidUrl != null:
return invalidUrl();case RsSendServerError_Status() when status != null:
return status(_that.status);case RsSendServerError_InvalidResponse() when invalidResponse != null:
return invalidResponse(_that.field0);case RsSendServerError_Network() when network != null:
return network(_that.field0);case RsSendServerError_Io() when io != null:
return io(_that.field0);case RsSendServerError_Cancelled() when cancelled != null:
return cancelled();case RsSendServerError_Crypto() when crypto != null:
return crypto();case RsSendServerError_UploadAuthRequired() when uploadAuthRequired != null:
return uploadAuthRequired();case RsSendServerError_UploadAuthFailed() when uploadAuthFailed != null:
return uploadAuthFailed();case RsSendServerError_UnsupportedUploadAuth() when unsupportedUploadAuth != null:
return unsupportedUploadAuth(_that.field0);case RsSendServerError_Other() when other != null:
return other(_that.field0);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  invalidUrl,required TResult Function( int status)  status,required TResult Function( String field0)  invalidResponse,required TResult Function( String field0)  network,required TResult Function( String field0)  io,required TResult Function()  cancelled,required TResult Function()  crypto,required TResult Function()  uploadAuthRequired,required TResult Function()  uploadAuthFailed,required TResult Function( String field0)  unsupportedUploadAuth,required TResult Function( String field0)  other,}) {final _that = this;
switch (_that) {
case RsSendServerError_InvalidUrl():
return invalidUrl();case RsSendServerError_Status():
return status(_that.status);case RsSendServerError_InvalidResponse():
return invalidResponse(_that.field0);case RsSendServerError_Network():
return network(_that.field0);case RsSendServerError_Io():
return io(_that.field0);case RsSendServerError_Cancelled():
return cancelled();case RsSendServerError_Crypto():
return crypto();case RsSendServerError_UploadAuthRequired():
return uploadAuthRequired();case RsSendServerError_UploadAuthFailed():
return uploadAuthFailed();case RsSendServerError_UnsupportedUploadAuth():
return unsupportedUploadAuth(_that.field0);case RsSendServerError_Other():
return other(_that.field0);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  invalidUrl,TResult? Function( int status)?  status,TResult? Function( String field0)?  invalidResponse,TResult? Function( String field0)?  network,TResult? Function( String field0)?  io,TResult? Function()?  cancelled,TResult? Function()?  crypto,TResult? Function()?  uploadAuthRequired,TResult? Function()?  uploadAuthFailed,TResult? Function( String field0)?  unsupportedUploadAuth,TResult? Function( String field0)?  other,}) {final _that = this;
switch (_that) {
case RsSendServerError_InvalidUrl() when invalidUrl != null:
return invalidUrl();case RsSendServerError_Status() when status != null:
return status(_that.status);case RsSendServerError_InvalidResponse() when invalidResponse != null:
return invalidResponse(_that.field0);case RsSendServerError_Network() when network != null:
return network(_that.field0);case RsSendServerError_Io() when io != null:
return io(_that.field0);case RsSendServerError_Cancelled() when cancelled != null:
return cancelled();case RsSendServerError_Crypto() when crypto != null:
return crypto();case RsSendServerError_UploadAuthRequired() when uploadAuthRequired != null:
return uploadAuthRequired();case RsSendServerError_UploadAuthFailed() when uploadAuthFailed != null:
return uploadAuthFailed();case RsSendServerError_UnsupportedUploadAuth() when unsupportedUploadAuth != null:
return unsupportedUploadAuth(_that.field0);case RsSendServerError_Other() when other != null:
return other(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class RsSendServerError_InvalidUrl extends RsSendServerError {
  const RsSendServerError_InvalidUrl(): super._();







@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RsSendServerError_InvalidUrl);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RsSendServerError.invalidUrl()';
}


}




/// @nodoc


class RsSendServerError_Status extends RsSendServerError {
  const RsSendServerError_Status({required this.status}): super._();


 final  int status;

/// Create a copy of RsSendServerError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RsSendServerError_StatusCopyWith<RsSendServerError_Status> get copyWith => _$RsSendServerError_StatusCopyWithImpl<RsSendServerError_Status>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RsSendServerError_Status&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,status);

@override
String toString() {
  return 'RsSendServerError.status(status: $status)';
}


}

/// @nodoc
abstract mixin class $RsSendServerError_StatusCopyWith<$Res> implements $RsSendServerErrorCopyWith<$Res> {
  factory $RsSendServerError_StatusCopyWith(RsSendServerError_Status value, $Res Function(RsSendServerError_Status) _then) = _$RsSendServerError_StatusCopyWithImpl;
@useResult
$Res call({
 int status
});




}
/// @nodoc
class _$RsSendServerError_StatusCopyWithImpl<$Res>
    implements $RsSendServerError_StatusCopyWith<$Res> {
  _$RsSendServerError_StatusCopyWithImpl(this._self, this._then);

  final RsSendServerError_Status _self;
  final $Res Function(RsSendServerError_Status) _then;

/// Create a copy of RsSendServerError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? status = null,}) {
  return _then(RsSendServerError_Status(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class RsSendServerError_InvalidResponse extends RsSendServerError {
  const RsSendServerError_InvalidResponse(this.field0): super._();


 final  String field0;

/// Create a copy of RsSendServerError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RsSendServerError_InvalidResponseCopyWith<RsSendServerError_InvalidResponse> get copyWith => _$RsSendServerError_InvalidResponseCopyWithImpl<RsSendServerError_InvalidResponse>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RsSendServerError_InvalidResponse&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'RsSendServerError.invalidResponse(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $RsSendServerError_InvalidResponseCopyWith<$Res> implements $RsSendServerErrorCopyWith<$Res> {
  factory $RsSendServerError_InvalidResponseCopyWith(RsSendServerError_InvalidResponse value, $Res Function(RsSendServerError_InvalidResponse) _then) = _$RsSendServerError_InvalidResponseCopyWithImpl;
@useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$RsSendServerError_InvalidResponseCopyWithImpl<$Res>
    implements $RsSendServerError_InvalidResponseCopyWith<$Res> {
  _$RsSendServerError_InvalidResponseCopyWithImpl(this._self, this._then);

  final RsSendServerError_InvalidResponse _self;
  final $Res Function(RsSendServerError_InvalidResponse) _then;

/// Create a copy of RsSendServerError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(RsSendServerError_InvalidResponse(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RsSendServerError_Network extends RsSendServerError {
  const RsSendServerError_Network(this.field0): super._();


 final  String field0;

/// Create a copy of RsSendServerError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RsSendServerError_NetworkCopyWith<RsSendServerError_Network> get copyWith => _$RsSendServerError_NetworkCopyWithImpl<RsSendServerError_Network>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RsSendServerError_Network&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'RsSendServerError.network(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $RsSendServerError_NetworkCopyWith<$Res> implements $RsSendServerErrorCopyWith<$Res> {
  factory $RsSendServerError_NetworkCopyWith(RsSendServerError_Network value, $Res Function(RsSendServerError_Network) _then) = _$RsSendServerError_NetworkCopyWithImpl;
@useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$RsSendServerError_NetworkCopyWithImpl<$Res>
    implements $RsSendServerError_NetworkCopyWith<$Res> {
  _$RsSendServerError_NetworkCopyWithImpl(this._self, this._then);

  final RsSendServerError_Network _self;
  final $Res Function(RsSendServerError_Network) _then;

/// Create a copy of RsSendServerError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(RsSendServerError_Network(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RsSendServerError_Io extends RsSendServerError {
  const RsSendServerError_Io(this.field0): super._();


 final  String field0;

/// Create a copy of RsSendServerError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RsSendServerError_IoCopyWith<RsSendServerError_Io> get copyWith => _$RsSendServerError_IoCopyWithImpl<RsSendServerError_Io>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RsSendServerError_Io&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'RsSendServerError.io(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $RsSendServerError_IoCopyWith<$Res> implements $RsSendServerErrorCopyWith<$Res> {
  factory $RsSendServerError_IoCopyWith(RsSendServerError_Io value, $Res Function(RsSendServerError_Io) _then) = _$RsSendServerError_IoCopyWithImpl;
@useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$RsSendServerError_IoCopyWithImpl<$Res>
    implements $RsSendServerError_IoCopyWith<$Res> {
  _$RsSendServerError_IoCopyWithImpl(this._self, this._then);

  final RsSendServerError_Io _self;
  final $Res Function(RsSendServerError_Io) _then;

/// Create a copy of RsSendServerError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(RsSendServerError_Io(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RsSendServerError_Cancelled extends RsSendServerError {
  const RsSendServerError_Cancelled(): super._();







@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RsSendServerError_Cancelled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RsSendServerError.cancelled()';
}


}




/// @nodoc


class RsSendServerError_Crypto extends RsSendServerError {
  const RsSendServerError_Crypto(): super._();







@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RsSendServerError_Crypto);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RsSendServerError.crypto()';
}


}




/// @nodoc


class RsSendServerError_UploadAuthRequired extends RsSendServerError {
  const RsSendServerError_UploadAuthRequired(): super._();







@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RsSendServerError_UploadAuthRequired);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RsSendServerError.uploadAuthRequired()';
}


}




/// @nodoc


class RsSendServerError_UploadAuthFailed extends RsSendServerError {
  const RsSendServerError_UploadAuthFailed(): super._();







@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RsSendServerError_UploadAuthFailed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RsSendServerError.uploadAuthFailed()';
}


}




/// @nodoc


class RsSendServerError_UnsupportedUploadAuth extends RsSendServerError {
  const RsSendServerError_UnsupportedUploadAuth(this.field0): super._();


 final  String field0;

/// Create a copy of RsSendServerError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RsSendServerError_UnsupportedUploadAuthCopyWith<RsSendServerError_UnsupportedUploadAuth> get copyWith => _$RsSendServerError_UnsupportedUploadAuthCopyWithImpl<RsSendServerError_UnsupportedUploadAuth>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RsSendServerError_UnsupportedUploadAuth&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'RsSendServerError.unsupportedUploadAuth(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $RsSendServerError_UnsupportedUploadAuthCopyWith<$Res> implements $RsSendServerErrorCopyWith<$Res> {
  factory $RsSendServerError_UnsupportedUploadAuthCopyWith(RsSendServerError_UnsupportedUploadAuth value, $Res Function(RsSendServerError_UnsupportedUploadAuth) _then) = _$RsSendServerError_UnsupportedUploadAuthCopyWithImpl;
@useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$RsSendServerError_UnsupportedUploadAuthCopyWithImpl<$Res>
    implements $RsSendServerError_UnsupportedUploadAuthCopyWith<$Res> {
  _$RsSendServerError_UnsupportedUploadAuthCopyWithImpl(this._self, this._then);

  final RsSendServerError_UnsupportedUploadAuth _self;
  final $Res Function(RsSendServerError_UnsupportedUploadAuth) _then;

/// Create a copy of RsSendServerError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(RsSendServerError_UnsupportedUploadAuth(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RsSendServerError_Other extends RsSendServerError {
  const RsSendServerError_Other(this.field0): super._();


 final  String field0;

/// Create a copy of RsSendServerError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RsSendServerError_OtherCopyWith<RsSendServerError_Other> get copyWith => _$RsSendServerError_OtherCopyWithImpl<RsSendServerError_Other>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RsSendServerError_Other&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'RsSendServerError.other(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $RsSendServerError_OtherCopyWith<$Res> implements $RsSendServerErrorCopyWith<$Res> {
  factory $RsSendServerError_OtherCopyWith(RsSendServerError_Other value, $Res Function(RsSendServerError_Other) _then) = _$RsSendServerError_OtherCopyWithImpl;
@useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$RsSendServerError_OtherCopyWithImpl<$Res>
    implements $RsSendServerError_OtherCopyWith<$Res> {
  _$RsSendServerError_OtherCopyWithImpl(this._self, this._then);

  final RsSendServerError_Other _self;
  final $Res Function(RsSendServerError_Other) _then;

/// Create a copy of RsSendServerError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(RsSendServerError_Other(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$RsSendServerUploadEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RsSendServerUploadEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RsSendServerUploadEvent()';
}


}

/// @nodoc
class $RsSendServerUploadEventCopyWith<$Res>  {
$RsSendServerUploadEventCopyWith(RsSendServerUploadEvent _, $Res Function(RsSendServerUploadEvent) __);
}


/// Adds pattern-matching-related methods to [RsSendServerUploadEvent].
extension RsSendServerUploadEventPatterns on RsSendServerUploadEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RsSendServerUploadEvent_Progress value)?  progress,TResult Function( RsSendServerUploadEvent_Finished value)?  finished,TResult Function( RsSendServerUploadEvent_Failed value)?  failed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RsSendServerUploadEvent_Progress() when progress != null:
return progress(_that);case RsSendServerUploadEvent_Finished() when finished != null:
return finished(_that);case RsSendServerUploadEvent_Failed() when failed != null:
return failed(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RsSendServerUploadEvent_Progress value)  progress,required TResult Function( RsSendServerUploadEvent_Finished value)  finished,required TResult Function( RsSendServerUploadEvent_Failed value)  failed,}){
final _that = this;
switch (_that) {
case RsSendServerUploadEvent_Progress():
return progress(_that);case RsSendServerUploadEvent_Finished():
return finished(_that);case RsSendServerUploadEvent_Failed():
return failed(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RsSendServerUploadEvent_Progress value)?  progress,TResult? Function( RsSendServerUploadEvent_Finished value)?  finished,TResult? Function( RsSendServerUploadEvent_Failed value)?  failed,}){
final _that = this;
switch (_that) {
case RsSendServerUploadEvent_Progress() when progress != null:
return progress(_that);case RsSendServerUploadEvent_Finished() when finished != null:
return finished(_that);case RsSendServerUploadEvent_Failed() when failed != null:
return failed(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( BigInt sent,  BigInt total,  double progress)?  progress,TResult Function( String id,  String url,  String? password)?  finished,TResult Function( RsSendServerError error)?  failed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RsSendServerUploadEvent_Progress() when progress != null:
return progress(_that.sent,_that.total,_that.progress);case RsSendServerUploadEvent_Finished() when finished != null:
return finished(_that.id,_that.url,_that.password);case RsSendServerUploadEvent_Failed() when failed != null:
return failed(_that.error);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( BigInt sent,  BigInt total,  double progress)  progress,required TResult Function( String id,  String url,  String? password)  finished,required TResult Function( RsSendServerError error)  failed,}) {final _that = this;
switch (_that) {
case RsSendServerUploadEvent_Progress():
return progress(_that.sent,_that.total,_that.progress);case RsSendServerUploadEvent_Finished():
return finished(_that.id,_that.url,_that.password);case RsSendServerUploadEvent_Failed():
return failed(_that.error);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( BigInt sent,  BigInt total,  double progress)?  progress,TResult? Function( String id,  String url,  String? password)?  finished,TResult? Function( RsSendServerError error)?  failed,}) {final _that = this;
switch (_that) {
case RsSendServerUploadEvent_Progress() when progress != null:
return progress(_that.sent,_that.total,_that.progress);case RsSendServerUploadEvent_Finished() when finished != null:
return finished(_that.id,_that.url,_that.password);case RsSendServerUploadEvent_Failed() when failed != null:
return failed(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class RsSendServerUploadEvent_Progress extends RsSendServerUploadEvent {
  const RsSendServerUploadEvent_Progress({required this.sent, required this.total, required this.progress}): super._();


 final  BigInt sent;
 final  BigInt total;
 final  double progress;

/// Create a copy of RsSendServerUploadEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RsSendServerUploadEvent_ProgressCopyWith<RsSendServerUploadEvent_Progress> get copyWith => _$RsSendServerUploadEvent_ProgressCopyWithImpl<RsSendServerUploadEvent_Progress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RsSendServerUploadEvent_Progress&&(identical(other.sent, sent) || other.sent == sent)&&(identical(other.total, total) || other.total == total)&&(identical(other.progress, progress) || other.progress == progress));
}


@override
int get hashCode => Object.hash(runtimeType,sent,total,progress);

@override
String toString() {
  return 'RsSendServerUploadEvent.progress(sent: $sent, total: $total, progress: $progress)';
}


}

/// @nodoc
abstract mixin class $RsSendServerUploadEvent_ProgressCopyWith<$Res> implements $RsSendServerUploadEventCopyWith<$Res> {
  factory $RsSendServerUploadEvent_ProgressCopyWith(RsSendServerUploadEvent_Progress value, $Res Function(RsSendServerUploadEvent_Progress) _then) = _$RsSendServerUploadEvent_ProgressCopyWithImpl;
@useResult
$Res call({
 BigInt sent, BigInt total, double progress
});




}
/// @nodoc
class _$RsSendServerUploadEvent_ProgressCopyWithImpl<$Res>
    implements $RsSendServerUploadEvent_ProgressCopyWith<$Res> {
  _$RsSendServerUploadEvent_ProgressCopyWithImpl(this._self, this._then);

  final RsSendServerUploadEvent_Progress _self;
  final $Res Function(RsSendServerUploadEvent_Progress) _then;

/// Create a copy of RsSendServerUploadEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? sent = null,Object? total = null,Object? progress = null,}) {
  return _then(RsSendServerUploadEvent_Progress(
sent: null == sent ? _self.sent : sent // ignore: cast_nullable_to_non_nullable
as BigInt,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as BigInt,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class RsSendServerUploadEvent_Finished extends RsSendServerUploadEvent {
  const RsSendServerUploadEvent_Finished({required this.id, required this.url, this.password}): super._();


 final  String id;
 final  String url;
 final  String? password;

/// Create a copy of RsSendServerUploadEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RsSendServerUploadEvent_FinishedCopyWith<RsSendServerUploadEvent_Finished> get copyWith => _$RsSendServerUploadEvent_FinishedCopyWithImpl<RsSendServerUploadEvent_Finished>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RsSendServerUploadEvent_Finished&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,id,url,password);

@override
String toString() {
  return 'RsSendServerUploadEvent.finished(id: $id, url: $url, password: $password)';
}


}

/// @nodoc
abstract mixin class $RsSendServerUploadEvent_FinishedCopyWith<$Res> implements $RsSendServerUploadEventCopyWith<$Res> {
  factory $RsSendServerUploadEvent_FinishedCopyWith(RsSendServerUploadEvent_Finished value, $Res Function(RsSendServerUploadEvent_Finished) _then) = _$RsSendServerUploadEvent_FinishedCopyWithImpl;
@useResult
$Res call({
 String id, String url, String? password
});




}
/// @nodoc
class _$RsSendServerUploadEvent_FinishedCopyWithImpl<$Res>
    implements $RsSendServerUploadEvent_FinishedCopyWith<$Res> {
  _$RsSendServerUploadEvent_FinishedCopyWithImpl(this._self, this._then);

  final RsSendServerUploadEvent_Finished _self;
  final $Res Function(RsSendServerUploadEvent_Finished) _then;

/// Create a copy of RsSendServerUploadEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? url = null,Object? password = freezed,}) {
  return _then(RsSendServerUploadEvent_Finished(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class RsSendServerUploadEvent_Failed extends RsSendServerUploadEvent {
  const RsSendServerUploadEvent_Failed({required this.error}): super._();


 final  RsSendServerError error;

/// Create a copy of RsSendServerUploadEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RsSendServerUploadEvent_FailedCopyWith<RsSendServerUploadEvent_Failed> get copyWith => _$RsSendServerUploadEvent_FailedCopyWithImpl<RsSendServerUploadEvent_Failed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RsSendServerUploadEvent_Failed&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'RsSendServerUploadEvent.failed(error: $error)';
}


}

/// @nodoc
abstract mixin class $RsSendServerUploadEvent_FailedCopyWith<$Res> implements $RsSendServerUploadEventCopyWith<$Res> {
  factory $RsSendServerUploadEvent_FailedCopyWith(RsSendServerUploadEvent_Failed value, $Res Function(RsSendServerUploadEvent_Failed) _then) = _$RsSendServerUploadEvent_FailedCopyWithImpl;
@useResult
$Res call({
 RsSendServerError error
});


$RsSendServerErrorCopyWith<$Res> get error;

}
/// @nodoc
class _$RsSendServerUploadEvent_FailedCopyWithImpl<$Res>
    implements $RsSendServerUploadEvent_FailedCopyWith<$Res> {
  _$RsSendServerUploadEvent_FailedCopyWithImpl(this._self, this._then);

  final RsSendServerUploadEvent_Failed _self;
  final $Res Function(RsSendServerUploadEvent_Failed) _then;

/// Create a copy of RsSendServerUploadEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(RsSendServerUploadEvent_Failed(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as RsSendServerError,
  ));
}

/// Create a copy of RsSendServerUploadEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RsSendServerErrorCopyWith<$Res> get error {

  return $RsSendServerErrorCopyWith<$Res>(_self.error, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}

// dart format on
