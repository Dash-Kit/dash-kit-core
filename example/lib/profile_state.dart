library profile_state;

import 'package:built_value/built_value.dart';

part 'profile_state.g.dart';

abstract class ProfileState
    implements Built<ProfileState, ProfileStateBuilder> {
  factory ProfileState([
    void Function(ProfileStateBuilder state) updates,
  ]) = _$ProfileState;

  ProfileState._();

  factory ProfileState.initial() => ProfileState(
        (state) => state..name = '',
      );

  String get name;
}
