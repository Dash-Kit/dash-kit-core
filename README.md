# Dash Kit Core

The library providing basic architecture components.

Dash Kit Core built upon **Async Redux** package and provides additional API such as Operation State API for watching the current status of the operation in the app and StoreList for efficient data storing and updating.

## What is AsyncRedux?

This is how `async_redux` flow looks like:

![Flow Diagram](https://miro.medium.com/max/1400/1*O34Rwgxfa3NiE7F_QW683Q.png)

So the conceptual difference with classical redux here is:

#### Async Reducer

If you want to do some asynchronous work, you simply declare the action’reducer to return Future<AppState> then change the state and return it. There is no need of any "middleware", like for other Redux versions.
As an example, suppose you want to increment a counter by a value you get from the database. The database access is async, so you must use an async reducer:

```Dart
class QueryAndIncrementAction extends ReduxAction<AppState> {                    
  @override
  Future<AppState> reduce() async {
    int value = await getAmount();
    return state.copy(counter: state.counter + value));
  }
}
```

To learn more you can check:
- This [medium article](https://medium.com/flutter-community/https-medium-com-marcglasberg-async-redux-33ac5e27d5f6) by Marcelo Glasberg
 who is a  creator of `async_redux`;
- [async_redux](https://pub.dev/packages/async_redux) package page;

## Operations

During development you come across a lot of async operations which you need to execute and do something after they are finished.  
So we went a little bit further and added opportunity to get state of async operations.  
We added a wrapper on ReduxAction for it which is just `Action`, so basicaly you can use it, but `operationKey` is an `Object` there, so to use safe our own type we can write another wrapper:  
```Dart
abstract class BaseAction extends Action<AppState> {
  // Action<AppState> contains all logic for tracking state and uses ReduxAction inside;
  BaseAction({
    bool isRefreshing,
  }) : super(isRefreshing: isRefreshing);

  @override
  // We defined Operation type here instead of Object in base Action;
  Operation get operationKey => null;
}
```

Operation can be anything you want, but we suggest using `enum` like here:
```Dart
enum Operation {
  // Auth
  login,
  loginViaFacebook,
  loginViaGoogle,
  loginViaApple,
}
```

And lets imagine that we want to integrate sign in request to our app.

Let's create our app state first:

```Dart
// We use this package to make store immutable
import 'package:built_value/built_value.dart';

part 'app_state.g.dart';

// The main thing you should notice here is GlobalState;
abstract class AppState
    implements Built<AppState, AppStateBuilder>, GlobalState {
  factory AppState([void Function(AppStateBuilder) updates]) = _$AppState;

  AppState._();

  // You should make ProfileState immutable either
  ProfileState get profile;

  // And implementation of GlobalState interface
  @override
  BuiltMap<Object, OperationState> get operationsState;

  // You should add an update of immutable state for operation inside this
  @override
  T updateOperation<T extends GlobalState>(
    Object operationKey,
    OperationState operationState,
  ) {
    final GlobalState newState = rebuild(
      (s) => s.operationsState[operationKey] = operationState,
    );
    return newState;
  }

  @override
  OperationState getOperationState(Object operationKey) {
    return operationsState[operationKey] ?? OperationState.idle;
  }

  static AppState initial() {
    return AppState(
      (b) => b.profile = ProfileState.initial().toBuilder(),
    );
  }
}
```

 Then we will make approximately the next action:
```Dart
class LoginAction extends BaseAction {
  LoginAction({
    @required this.email,
    @required this.password,
  })  : assert(email != null),
        assert(password != null);

  final String email;
  final String password;

  @override
  Operation get operationKey => Operation.login;

  @override
  Future<AppState> reduce() async {
    // It's not neccessary to use GetIt;
    final userService = GetIt.I.get<UserService>();

    // Here you can add any logic to get your user;
    final currentUser = await userService.login(
      email: email,
      password: password,
    );

    // You should return the udated state;
    return state.rebuild((s) {
      s.profile.currentUser = currentUser;
    });
  }
}
```

The rest is really simple, let's use the action and its state in our UI:
```Dart
class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // Use default StoreConnector and convert data to OperationState
    return StoreConnector<AppState, OperationState>(
      converter: (store) => store.state.getOperationState(Operation.login),
      builder: (context, loginOperation) => LoadableView(
        // Magic is here, loginOperation has .isInProgress
        isLoading: loginOperation.isInProgress,
        child: Column(
          children: <Widget>[
            const Spacer(flex: 5),
            // Handle login button press
            LoginForm(onLogin: onLogin),
            const Spacer(flex: 4),
          ],
        ),
      ),
    );
  }

  void onLogin(String email, String password) {
    dispatch(action)
      // We can route to some page here
      .then((value) => _onLoginSuccess())
      // And show some dialog here
      .catchError((error) => _onLoginError();
  }
}
```
`LoadableView` is very simple widget which displays progress indicator above main content, you can find that widget on [GitHub here](https://github.com/Dash-Kit/dash-kit-loadable) or on [pub.dev here](https://pub.dev/packages/dash_kit_loadable).

## StoreList

We also added a wrapper for `BuiltList`(learn more [here](https://pub.dev/packages/built_collection)) to have a more convenient way to update data in store from reducers.

If you need to store some `Map` (Dictionary), you can use `StoreList`:
```Dart
// E.g UserProfile, but it can be any data item
class UserProfile implements StoreListItem {
  UserProfile({Object id}) : super(id);
}
```
Now you can use StoreList with this UserProfyle type everywhere, but the best place to use it is GlobalState of Redux.

```Dart
StoreList<UserProfile> get userProfiles;

// And everywhere you need you can get Map with <id, UserProfile>
state.userProfiles.itemsMap;
// Or get all ids
state.userProfiles.itemsIds;
// Or get only one item
state.userProfiles.getItem('Some ID according to type which you use');
```

Also, instead of calling `rebuild(...)`, copying lists and changing the copied list e.g for deleting item in list, you can use just `deleteItem`:
```Dart
// Before
@override
Future<AppState> reduce() async {
  final updatedList = [...s.someOldList]
      .where((item) => item.id != conditionItemId)
      .toList();

  return state.rebuild((s) {
    s.dataStructure.someOldList = updatedList;
  });
}

// After: You can use only one method right now
@override
Future<AppState> reduce() async {
  return state.dataStructure
          .someOldList
          // someOldList will be rebuilt
          .deleteItem(conditionItemId);
}
```

### Availabe API
All of this methods will rebuild the main list, so your list will be immutable, and you don't need to call `rebuild`:

- void updateList(Iterable<T> items)
- void addItem(Object id, T value)
- void addAll(Iterable<T> values)
- void updateItem(Object id, T value)
- void deleteItem(Object id)
- void clear()

## PaginatedList

To incapsulate data for lists that you can download page by page, we wrote `PaginatedList`.

Ussualy you can meet the next meta information for paginated resources:
```js
'data': {
  'items':[YOUR_DATA],
  'meta': {
    'prev_page': 0,
    'current_page': 0,
    'next_page': 1,
    'total_count': 20
  }
}
```

But on UI all you need is to know the state of your requests and whether your data fully loaded or not.  
It looks like:
```Dart
class PaginatedList<T extends StoreListItem> {
  final StoreList<T> items;
  // Use it when you load the list the first time
  final OperationState loadListRequestState;
  // Use it when you load the next page of data
  final OperationState loadPageRequestState;
  final bool isAllItemsLoaded;
}
```
It allows you to put it into widgets as one object and it will be enough to draw UI according to the data of this object.

To init data use `empty()` constructor: 
```Dart
// E.g you decided to use it in GlobalState, so you need to initialise it as empty
static AppState initial() {
  return AppState(
    (b) => b.paginatedList = PaginatedList<YourType>.empty(),
  );
}
```
To update data use `update()` method: 
```Dart
@override
Future<AppState> reduce() async {
  // E.g after you got the first bunch of data
  return state.paginatedList
          .update(
            items: newItems,
            loadListRequestState: OperationState.success,
            isAllItemsLoaded: false,
          );
}
```