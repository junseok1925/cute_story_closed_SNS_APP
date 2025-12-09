// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_post_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AddPostState {

 XFile? get pickedFile; VideoPlayerController? get videoController; bool get isLoading; String? get error;
/// Create a copy of AddPostState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddPostStateCopyWith<AddPostState> get copyWith => _$AddPostStateCopyWithImpl<AddPostState>(this as AddPostState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddPostState&&(identical(other.pickedFile, pickedFile) || other.pickedFile == pickedFile)&&(identical(other.videoController, videoController) || other.videoController == videoController)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,pickedFile,videoController,isLoading,error);

@override
String toString() {
  return 'AddPostState(pickedFile: $pickedFile, videoController: $videoController, isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class $AddPostStateCopyWith<$Res>  {
  factory $AddPostStateCopyWith(AddPostState value, $Res Function(AddPostState) _then) = _$AddPostStateCopyWithImpl;
@useResult
$Res call({
 XFile? pickedFile, VideoPlayerController? videoController, bool isLoading, String? error
});




}
/// @nodoc
class _$AddPostStateCopyWithImpl<$Res>
    implements $AddPostStateCopyWith<$Res> {
  _$AddPostStateCopyWithImpl(this._self, this._then);

  final AddPostState _self;
  final $Res Function(AddPostState) _then;

/// Create a copy of AddPostState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pickedFile = freezed,Object? videoController = freezed,Object? isLoading = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
pickedFile: freezed == pickedFile ? _self.pickedFile : pickedFile // ignore: cast_nullable_to_non_nullable
as XFile?,videoController: freezed == videoController ? _self.videoController : videoController // ignore: cast_nullable_to_non_nullable
as VideoPlayerController?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AddPostState].
extension AddPostStatePatterns on AddPostState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddPostState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddPostState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddPostState value)  $default,){
final _that = this;
switch (_that) {
case _AddPostState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddPostState value)?  $default,){
final _that = this;
switch (_that) {
case _AddPostState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( XFile? pickedFile,  VideoPlayerController? videoController,  bool isLoading,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddPostState() when $default != null:
return $default(_that.pickedFile,_that.videoController,_that.isLoading,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( XFile? pickedFile,  VideoPlayerController? videoController,  bool isLoading,  String? error)  $default,) {final _that = this;
switch (_that) {
case _AddPostState():
return $default(_that.pickedFile,_that.videoController,_that.isLoading,_that.error);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( XFile? pickedFile,  VideoPlayerController? videoController,  bool isLoading,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _AddPostState() when $default != null:
return $default(_that.pickedFile,_that.videoController,_that.isLoading,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _AddPostState implements AddPostState {
  const _AddPostState({this.pickedFile, this.videoController, this.isLoading = false, this.error});
  

@override final  XFile? pickedFile;
@override final  VideoPlayerController? videoController;
@override@JsonKey() final  bool isLoading;
@override final  String? error;

/// Create a copy of AddPostState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddPostStateCopyWith<_AddPostState> get copyWith => __$AddPostStateCopyWithImpl<_AddPostState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddPostState&&(identical(other.pickedFile, pickedFile) || other.pickedFile == pickedFile)&&(identical(other.videoController, videoController) || other.videoController == videoController)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,pickedFile,videoController,isLoading,error);

@override
String toString() {
  return 'AddPostState(pickedFile: $pickedFile, videoController: $videoController, isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class _$AddPostStateCopyWith<$Res> implements $AddPostStateCopyWith<$Res> {
  factory _$AddPostStateCopyWith(_AddPostState value, $Res Function(_AddPostState) _then) = __$AddPostStateCopyWithImpl;
@override @useResult
$Res call({
 XFile? pickedFile, VideoPlayerController? videoController, bool isLoading, String? error
});




}
/// @nodoc
class __$AddPostStateCopyWithImpl<$Res>
    implements _$AddPostStateCopyWith<$Res> {
  __$AddPostStateCopyWithImpl(this._self, this._then);

  final _AddPostState _self;
  final $Res Function(_AddPostState) _then;

/// Create a copy of AddPostState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pickedFile = freezed,Object? videoController = freezed,Object? isLoading = null,Object? error = freezed,}) {
  return _then(_AddPostState(
pickedFile: freezed == pickedFile ? _self.pickedFile : pickedFile // ignore: cast_nullable_to_non_nullable
as XFile?,videoController: freezed == videoController ? _self.videoController : videoController // ignore: cast_nullable_to_non_nullable
as VideoPlayerController?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
