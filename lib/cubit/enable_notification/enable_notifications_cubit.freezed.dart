// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'enable_notifications_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EnableNotificationsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnableNotificationsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EnableNotificationsState()';
}


}

/// @nodoc
class $EnableNotificationsStateCopyWith<$Res>  {
$EnableNotificationsStateCopyWith(EnableNotificationsState _, $Res Function(EnableNotificationsState) __);
}


/// Adds pattern-matching-related methods to [EnableNotificationsState].
extension EnableNotificationsStatePatterns on EnableNotificationsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _PermanentlyDenied value)?  permanentlyDenied,TResult Function( _Denied value)?  denied,TResult Function( _Approved value)?  approved,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _PermanentlyDenied() when permanentlyDenied != null:
return permanentlyDenied(_that);case _Denied() when denied != null:
return denied(_that);case _Approved() when approved != null:
return approved(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _PermanentlyDenied value)  permanentlyDenied,required TResult Function( _Denied value)  denied,required TResult Function( _Approved value)  approved,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _PermanentlyDenied():
return permanentlyDenied(_that);case _Denied():
return denied(_that);case _Approved():
return approved(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _PermanentlyDenied value)?  permanentlyDenied,TResult? Function( _Denied value)?  denied,TResult? Function( _Approved value)?  approved,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _PermanentlyDenied() when permanentlyDenied != null:
return permanentlyDenied(_that);case _Denied() when denied != null:
return denied(_that);case _Approved() when approved != null:
return approved(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  permanentlyDenied,TResult Function()?  denied,TResult Function()?  approved,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _PermanentlyDenied() when permanentlyDenied != null:
return permanentlyDenied();case _Denied() when denied != null:
return denied();case _Approved() when approved != null:
return approved();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  permanentlyDenied,required TResult Function()  denied,required TResult Function()  approved,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _PermanentlyDenied():
return permanentlyDenied();case _Denied():
return denied();case _Approved():
return approved();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  permanentlyDenied,TResult? Function()?  denied,TResult? Function()?  approved,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _PermanentlyDenied() when permanentlyDenied != null:
return permanentlyDenied();case _Denied() when denied != null:
return denied();case _Approved() when approved != null:
return approved();case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements EnableNotificationsState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EnableNotificationsState.initial()';
}


}




/// @nodoc


class _PermanentlyDenied implements EnableNotificationsState {
  const _PermanentlyDenied();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PermanentlyDenied);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EnableNotificationsState.permanentlyDenied()';
}


}




/// @nodoc


class _Denied implements EnableNotificationsState {
  const _Denied();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Denied);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EnableNotificationsState.denied()';
}


}




/// @nodoc


class _Approved implements EnableNotificationsState {
  const _Approved();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Approved);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EnableNotificationsState.approved()';
}


}




// dart format on
