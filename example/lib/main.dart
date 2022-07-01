import 'package:example/app_state.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(StoreProvider<AppState>(
    store: Store(initialState: AppState.initial()),
    child: MyApp(),
  ));
}

enum Operation {
  login,
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StoreConnector<AppState, OperationState>(
        converter: (store) => store.state.getOperationState(Operation.login),
        builder: (context, operationState) => LoadableView(
          isLoading: operationState.isInProgress,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: 'Email'),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(hintText: 'Password'),
                    obscureText: true,
                  ),
                  TextButton(onPressed: _onLoginPressed, child: Text('LOG IN')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onLoginPressed() async {
    context
        .dispatch(
          LoginAction(
            email: _emailController.text,
            password: _passwordController.text,
          ),
        )
        .then((_) => _openSuccessDialog())
        .catchError(_onError);
  }

  void _onError(dynamic error) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            backgroundColor: Colors.white,
            child: SizedBox(
              height: 100,
              width: 100,
              child: Center(
                child: Text('ERROR: something went wrong'),
              ),
            ),
          );
        });
  }

  void _openSuccessDialog() {
    final state = StoreProvider.state<AppState>(context);
    final userName = state!.profileState.name;

    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            backgroundColor: Colors.white,
            child: SizedBox(
              height: 100,
              width: 100,
              child: Center(
                child: Text('Hi, $userName!'),
              ),
            ),
          );
        });
  }
}

class LoginAction extends Action<AppState> {
  LoginAction({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  Operation get operationKey => Operation.login;

  @override
  Future<AppState> reduce() async {
    // Here you can add any logic to get your user;
    final currentUserName = await Future.delayed(Duration(seconds: 5), () {
      if (email.isNotEmpty && password.isNotEmpty) {
        return 'UserName';
      }
    });

    // You should return the updated state;
    return state.rebuild((s) {
      s.profileState.name = currentUserName;
    });
  }
}
