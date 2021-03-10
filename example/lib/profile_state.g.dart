// GENERATED CODE - DO NOT MODIFY BY HAND

part of profile_state;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProfileState extends ProfileState {
  @override
  final String name;

  factory _$ProfileState([void Function(ProfileStateBuilder)? updates]) =>
      (new ProfileStateBuilder()..update(updates)).build();

  _$ProfileState._({required this.name}) : super._() {
    BuiltValueNullFieldError.checkNotNull(name, 'ProfileState', 'name');
  }

  @override
  ProfileState rebuild(void Function(ProfileStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProfileStateBuilder toBuilder() => new ProfileStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfileState && name == other.name;
  }

  @override
  int get hashCode {
    return $jf($jc(0, name.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ProfileState')..add('name', name))
        .toString();
  }
}

class ProfileStateBuilder
    implements Builder<ProfileState, ProfileStateBuilder> {
  _$ProfileState? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ProfileStateBuilder();

  ProfileStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProfileState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProfileState;
  }

  @override
  void update(void Function(ProfileStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ProfileState build() {
    final _$result = _$v ??
        new _$ProfileState._(
            name: BuiltValueNullFieldError.checkNotNull(
                name, 'ProfileState', 'name'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
