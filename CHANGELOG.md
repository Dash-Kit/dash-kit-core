## [4.7.2]

- Remove `_isSuccessfullyCompleted` and `wrapReduce` from `Action` class

## [4.7.1]

- Change `FutureOr<T?> wrapReduce(Reducer<T> reduce)` to `Future<T?> wrapReduce(Reducer<T> reduce)` to fix the issue

## [4.7.0]

- Bump dependencies

## [4.6.3]

- Bump dependencies

## [4.6.2]

- Fix an issue with the default background color in `LoadableView` & `LoadableItemView`

## [4.6.1]

- Fix empty state.

## [4.6.0]

- Refactored LoadableList & PaginatedeLoadableList constructors signature
- BREAKING CHANGE: `items` replaced with `itemCount`. `itemBuilder` and `itemSeparator` now requires additional param `BuildContext` according to the `ListView.builder` constructor

## [4.5.0]

- Bump dependencies

## [4.4.0]

- BREAKING CHANGE: Removed PaginatedList from the ViewModels constructors

## [4.3.0]

- Bump dependencies
- Breaking changes in async_redux package
- BREAKING CHANGE: `backgroundColor` property in Loadable widgets now uses `Theme.of(context).colorScheme.background by default

## [4.2.0]

- Bump dependencies

## [4.1.1]

- Added default padding value - `EdgetInsets.zero` for `LoadableGridView`

## [4.1.0]

- Wrapped `CustomScroll` view into `ScrollNotification` in `LoadableGridView` due to the outer
  scrollController dispose.

## [4.0.0]

- Upgraded dart to v3
- Upgraded `dash_kit_lints` dependency
- Added `physics` param to `LoadableGridView`

## [3.7.3]

- Added `RefreshIndicator` support on Android in `loadable_list`

## [3.7.2]

- Added `RefreshIndicator` support on Android in `loadable_paginated_list`

## [3.7.1]

- Fixed rendering empty and error states in `loadable_list`

## [3.7.0]

- Fixed an issue with disposing scroll controllers
- Fixed processing of the refresh state in `loadable_list.dart`

## [3.6.1]

- Added customization of scroll controller into lists
- Added opportunity to use custom slivers as headers

## [3.6.0]

- Update `analysis_options.yaml`
- `analysis_options` now extends from `dash_kit_lints` rules

## [3.5.1]

- Fixed [PaginatedList.update] method

## [3.5.0]

- Incremented the Flutter SDK version to 3.7.0

## [3.4.1]

- Covered with the documentation comments

## [3.4.0]

- Add the shrinkWrap parameter to LoadableGridViewModel

## [3.3.1]

- Removed unused Store entity

## [3.3.0]

- Updated PaginatedList model and PaginatedList view structure.

## [3.2.2]

- Added maxScrollExtent to the ScrollListener

## [3.2.1]

- Removed redundant parameters in LoadableListViewModel

## [3.2.0]

- Upgraded dependencies

## [3.1.10]

- Fixed lists for using slivers

## [3.1.9]

- Fixed lists for using slivers
- Fixed analyzer warnings

## [3.1.8]

- Fixed equals in paginated list

## [3.1.7]

- Fixed scroll listeners

## [3.1.6]

- Fixes for 3.1.5

## [3.1.5]

- Added endListWidget to PaginatedListView, temporary removed equals operator from paginated_list

## [3.1.4]

- Added `reverse` to loadable and paginated lists

## [3.1.3]

- Added equals to paginated list

## [3.1.2]

- Fixed an issue with wrap reduce method

## [3.1.1]

- Fixed an issue with async_redux dependency version

## [3.1.0]

- Added Flutter 3.0 support

## [3.0.3]

- Updated README and bumped dependencies

## [3.0.2]

- Added ability to set scrollDirection for PaginatedListView

## [3.0.1]

- Added ability to change shrinkWrap for PaginatedListView

## [3.0.0]

- Release 3.0.0

## [3.0.0-dev.9]

- Fixed loading state for list refreshing

## [3.0.0-dev.8]

- Added example

## [3.0.0-dev.7]

- Renamed parameter in PaginatedList update function

## [3.0.0-dev.6]

- Updated async_redux to version 12.0.0
- Added loadable widgets

## [3.0.0-dev.5]

- Fixed an issue with types

## [3.0.0-dev.4]

- Fixed an issue with types

## [3.0.0-dev.3]

- Fixed an issue with types

## [3.0.0-dev.2]

- Updated store list getter

## [3.0.0-dev.1]

- Updated dependencies and added null-safety support

## [2.1.3]

- Added README

## [2.1.2]

- Fixed `SetOperation` action

## [2.1.1]

- Fixed `SetOperation` action

## [2.1.0]

- Updated dependencies versions

## [2.0.2]

- Fix BuildContext extension for action dispatching

## [2.0.1]

- Added BuildContext extension for action dispatching

## [2.0.0]

- Switched to architecture components from Async Redux
- Implemented Operation State API

## [1.0.5]

- Improved working with equality for request states.

## [1.0.4]

- Fixed issue with equality for request states.

## [1.0.3]

- Fixed issue with using requests states in `switch`.

## [1.0.2]

- Increased package score.

## [1.0.1]

- Fixed lint issues.

## [1.0.0]

- Initial release of the core component.
