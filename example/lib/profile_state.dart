library profile_state;

import 'package:built_value/built_value.dart';

part 'profile_state.g.dart';

abstract class ProfileState
    implements Built<ProfileState, ProfileStateBuilder> {
  factory ProfileState([void Function(ProfileStateBuilder) updates]) =
      _$ProfileState;

  ProfileState._();

  factory ProfileState.initial() => ProfileState(
        (b) => b..name = '',
      );

  String get name;
}
