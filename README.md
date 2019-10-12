# Flutter Platform Architecture Core

### 1. Action

Action is an object with data that represents events in the app. 
Must extend from base class Action or AsyncAction.
Actions are grouped by type in files.

**Sync Action**

Sync action is a simple action in the app that usually used to change some data in the global application state. 
For example, an action intended to set user email in the global app state: 

```dart
class SetCurrentUserEmailAction extends Action {
  final String email;

  SetCurrentUserEmailAction(this.email);
}
```

**Async action**

Async action represents a process in the application that can start for execution and should be completed with a success or an error. AsyncAction contains 2 type parameters that represent the success model and error model that will be stored in the action when the process completes. Also, AsyncAction can include any information used to perform the process.

For example, login in the application, when login completed we'll receive an enum with a result of login, or on failure, we'll receive a description with the reason of error:

```dart
enum LoginResult { success, emailNotConfirmed }

class LoginAsyncAction extends AsyncAction<LoginResult, String> {
  final UserCredentials credentials;

  LoginAsyncAction(this.credentials);
}
```
When the process completes, you should invoke the `complete` or `fail` method. It will write your success or error model to action. Only one method can be called for the action; otherwise, assert will be triggered for warning you about incorrect using of the action. Those methods usually used in the epics. An example for login:
```dart
action.complete(LoginResult.success);
action.complete(LoginResult.emailNotConfirmed);
action.fail("Login Failed: Incorrect credentials");
```
Async action also includes API for accessing the current state of the action (that usually used in the reducers):
```dart
action
    .onStart(() => /* your code */)
    .onSuccess((result) => /* your code */)
    .onError((errorModel) => /* your code */);
```

### 2. Reducer

Reducer is the component in charge of changing the global application state. According to dispatched action, it changes global state that related to that type of event of the app or data attached to the action object. 

Reducer is a pure function that means that it does not have any side effects. It takes action and the current state and produces a new state according to the action.

Reducer can be root (related to the global state of the application) or specific (related to some part of the global state). All specific reducers are combined with root reducer.

Example of specific reducer:
```dart
final authReducer = Reducer<AuthState>()
  ..on<LogoutSuccessAction>((state, action) => AuthState.initial())
  ..on<SetCurrentUserEmailAction>(
    (state, action) => state.rebuild((b) => b.currentUserEmail = action.email),
  )
  ..on<LoginAsyncAction>(
    (state, action) => state.rebuild((b) => action
        .onStart(() => b.authRequestState = RequestState.inProgress)
        .onSuccess((result) => b.authRequestState = RequestState.idle)
        .onError((errorModel) => b.authRequestState = RequestState.error)),
  );
```
Example of root reducer:
```dart
final rootReducer = Reducer<AppState>(
  isRoot: true,
  rootReducerAction: (state, action) => state.rebuild(
    (s) => s
      ..auth = authReducer.reduce(state.auth, action).toBuilder()
      ..registration = registrationReducer.reduce(state.registration, action).toBuilder()
      ..profile = profileReducer.reduce(state.profile, action).toBuilder(),
  ),
);
```
### 3. State

The global application state is an immutable shared data available to all parts of the application. Then it changes the store notifies all listeners about the new state, and it's guaranteed that across all application we will have actual application data.

The State combines from models that responsible for some part of app data like authorization, registration or profile information, etc.

Immutability guarantee to us that the state of the application will be mutated only by the explicit way - actions. 
That brings clarity to the changing of app data, and all changes in the data can be tracked. 
For easier achieving immutability goals, we are using the built_value package provided by Google.

**built_value docs:**

https://github.com/google/built_value.dart

**built_value article:**

https://medium.com/dartlang/darts-built-value-for-immutable-object-models-83e2497922d4

When app state models defined, you should use a command attached below to generate code that provides immutability for the app data models.

Code generation: 
```sh
flutter packages pub run build_runner build --delete-conflicting-outputs
```

We commit generated files. It will prevent problems with generated files on branch switching.
On merge conflicts, just rerun the generation command.

Example of specific state: 
```dart
library auth_state;
import 'package:built_value/built_value.dart';
part 'auth_state.g.dart';

abstract class AuthState implements Built<AuthState, AuthStateBuilder> {
  RequestState get loginRequestState;
  RequestState get logoutRequestState;
  @nullable
  String get currentUserEmail;

  AuthState._();

  factory AuthState([updates(AuthStateBuilder b)]) = _$AuthState;

  static AuthState initial() => AuthState(
        (b) => b
          ..loginRequestState = RequestState.idle
          ..logoutRequestState = RequestState.idle
          ..currentUserEmail = null,
      );
}
```
Example of app global state: 
```dart
/* Library, Import and Part Of compiler directives like in previous example */

abstract class AppState implements Built<AppState, AppStateBuilder> {
  AuthState get auth;
  RegistrationState get registration;
  ProfileState get profile;

  AppState._();

  factory AppState([void Function(AppStateBuilder) updates]) = _$AppState;

  static AppState initial() {
    return AppState(
      (b) => b
        ..auth = AuthState.initial().toBuilder()
        ..registration = RegistrationState.initial().toBuilder()
        ..profile = ProfileState.initial().toBuilder(),
    );
  }
}
```

### 4. Epic

Epic is a component that is providing access to the business logic layer of the app.
In epics, we run async operations like network requests, accessing cache or databases, etc.
Epic is a function that takes a stream of actions and the current state of the app and transforms it into the output stream of actions that includes data about the executed process. 

Epics use services to execute the logic of actions. Services should be injected as arguments of function that creates epic. It provides testability to the epic layer of the app.

Example of epic:
```dart
Epic<AppState> authEpic({
  @required UserService userService,
  @required PushService pushService,
}) {
  Epic<AppState> loginEpic = (action$, store) => Observable(action$)
      .whereType<LoginAsyncAction>()
      .where((action) => action.isStarted)
      .flatMap((action) => userService
          .login(action.credentials)
          .map((response) => response.completedOnboarding
              ? action.complete(LoginResult.success)
              : action.complete(LoginResult.registrationNotCompleted))
          .onErrorReturnWith((e) => action.fail(getErrorMessage(e))));

  Epic<AppState> logoutEpic = (action$, store) => Observable(action$)
      .whereType<LogoutAsyncAction>()
      .where((action) => action.isStarted)
      .flatMap((action) => (action.ignoreErrors
              ? userService.logout()
              : Observable.zip(
                    [pushService.removeToken(), userService.logout()], (_) => null
                ))
          .map(action.complete(null))
          .onErrorReturnWith((e) => action.fail('Error on log out')));

  return combineEpics([
    loginEpic,
    logoutEpic,
  ]);
}
```

### 5. Service

Service - is the place where business logic lives. 
Interaction with API, storage should be placed here.
Services shouldn’t store any state. 
The state must be stored in the AppState model that attached to Store or local storage

How service will be written completely depends on you. 
But for example, simple UserService represented below:

```dart
class UserService {
  UserService({
    @required ApiClient apiClient,
    @required TokenStorage tokenStorage,
    @required ProfileCache profileCache,
  })  : _apiClient = apiClient,
        _tokenStorage = tokenStorage,
        _profileCache = profileCache;

  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;
  final ProfileCache _profileCache;

  Observable<LoginResponseModel> login(UserCredentials credentials) {
    return _apiClient.login(credentials).doOnData(_saveAuthTokens);
  }

  Observable<void> logout() {
    return Observable.fromFuture(_tokenStorage.clearTokens());
  }

  Observable<LoginResponseModel> refreshToken() {
    return Observable.fromFuture(_tokenStorage.getRefreshToken())
        .flatMap((refreshToken) => _apiClient.refresh(refreshToken))
        .doOnData(_saveAuthTokens);
  }

  Observable<UserProfile> registration(UserProfile profile) {
    return _apiClient.registerUser(profile);
  }

  Observable<UserProfile> loadProfile() {
    return _apiClient.getProfile().doOnData(_saveProfile);
  }

  Observable<UserProfile> getProfileFromCache() {
    return Observable.just(_profileCache.getUserProfile());
  }

  void _saveAuthTokens(LoginResponseModel response) {
    _tokenStorage.saveTokens(
      authToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
  }

  void _saveProfile(UserProfile profile) {
    _profileCache.saveUserProfile(profile);
  }
}

```

### 6. Store Provider

Store - a component that combines all together. The Redux framework itself provides it. 
Store responsible for dispatching actions, managing application state, notifying listeners of state changes, managing middlewares.
Architecture Core framework introduces the StoreProvider component that reduces the complexity of store configuration.

Example of configuration of store provider:

```dart
Future<StoreProvider<AppState>> configureStoreProvider() async {
  final rootEpic = await createRootEpic();
  final appReducer = AppReducer();
  final logMiddleware = LogMiddleware();

  return StoreProvider<AppState>(
    initialState: AppState.initial(),
    appReducer: appReducer,
    appEpic: rootEpic,
    middleware: [
      logMiddleware,
    ],
  );
}
```

### 7. Store Connector & Redux Component
It’s a component that connects the store with UI. 

**StoreConnector** - a descendant Widget that gets the Store from the nearest StoreProvider ancestor, converts the Store into a ViewModel with the given converter function and passes the ViewModel to a builder function. Any time the Store emits a change event, the Widget will automatically be rebuilt.

```dart
StoreConnector<AppState, UserProfile>(
    converter: (store) => store.state.profile.currentUserProfile,
    builder: (context, profile) {
        return Text(profile.fullName);
    },
)
```

**ReduxComponent** - mixin for more comfortable dispatching actions and listening actions. API of ReduxComponent:
```dart
/// Dispathing any action of the app
void dispatch(Action action);

/// Dispatching AsyncAction and listening result
Observable<T> dispatchAsyncAction<T extends AsyncAction>(T action);

/// Listening any action dispatched in the app
Observable<T> onAction<T extends Action>();

/// Disposing all subscriptions. For StatefullWidget should be called in the `onDispose` method
void disposeSubscriptions();
```