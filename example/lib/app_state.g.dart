// GENERATED CODE - DO NOT MODIFY BY HAND

part of app_state;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AppState extends AppState {
  @override
  final ProfileState profileState;
  @override
  final BuiltMap<Object, OperationState> operationsState;

  factory _$AppState([void Function(AppStateBuilder)? updates]) =>
      (new AppStateBuilder()..update(updates)).build();

  _$AppState._({required this.profileState, required this.operationsState})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        profileState, 'AppState', 'profileState');
    BuiltValueNullFieldError.checkNotNull(
        operationsState, 'AppState', 'operationsState');
  }

  @override
  AppState rebuild(void Function(AppStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AppStateBuilder toBuilder() => new AppStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppState &&
        profileState == other.profileState &&
        operationsState == other.operationsState;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, profileState.hashCode), operationsState.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AppState')
          ..add('profileState', profileState)
          ..add('operationsState', operationsState))
        .toString();
  }
}

class AppStateBuilder implements Builder<AppState, AppStateBuilder> {
  _$AppState? _$v;

  ProfileStateBuilder? _profileState;
  ProfileStateBuilder get profileState =>
      _$this._profileState ??= new ProfileStateBuilder();
  set profileState(ProfileStateBuilder? profileState) =>
      _$this._profileState = profileState;

  MapBuilder<Object, OperationState>? _operationsState;
  MapBuilder<Object, OperationState> get operationsState =>
      _$this._operationsState ??= new MapBuilder<Object, OperationState>();
  set operationsState(MapBuilder<Object, OperationState>? operationsState) =>
      _$this._operationsState = operationsState;

  AppStateBuilder();

  AppStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _profileState = $v.profileState.toBuilder();
      _operationsState = $v.operationsState.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AppState;
  }

  @override
  void update(void Function(AppStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AppState build() {
    _$AppState _$result;
    try {
      _$result = _$v ??
          new _$AppState._(
              profileState: profileState.build(),
              operationsState: operationsState.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'profileState';
        profileState.build();
        _$failedField = 'operationsState';
        operationsState.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'AppState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
