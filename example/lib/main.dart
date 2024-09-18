import 'package:flutter/material.dart';
import 'package:null_shield/null_shield.dart';

void main() {
  NullSafetyUtils.setLogger((String message) {
    debugPrint('NullShield: $message');
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Null Shield Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class UserManager extends ChangeNotifier with NullSafeChangeNotifier {
  final NullSafeValueNotifier<User> userNotifier = NullSafeValueNotifier();

  void createUser() {
    userNotifier.updateValue(User('John Doe', 30));
    setValue('lastAction', 'User created');
  }

  void setUserToNull() {
    userNotifier.updateValue(null);
    setValue('lastAction', 'User set to null');
  }

  void getUserName() {
    final name = NullSafetyUtils.autoSafeGet(userNotifier.value, (u) => u.name);
    setValue('lastAction', 'User name: ${name ?? "N/A"}');
  }

  void celebrateBirthday() {
    NullSafetyUtils.safeCall(userNotifier.value, (u) => u.celebrateBirthday());
    setValue('lastAction', 'Tried to celebrate birthday');
  }

  Future<void> getAsyncSecretData() async {
    final result = await NullSafetyUtils.retry(() async {
      if (userNotifier.value == null) throw Exception('User is null');
      return userNotifier.value!.getAsyncSecretData();
    });
    setValue('lastAction', 'Async secret data (with retry): ${result ?? "N/A"}');
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserManager userManager = UserManager();

  @override
  void initState() {
    super.initState();
    userManager.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    userManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Null Shield Example'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  userManager.createUser();
                },
                child: const Text('Create User'),
              ),
              ElevatedButton(
                onPressed: () {
                  userManager.setUserToNull();
                },
                child: const Text('Set User to Null'),
              ),
              NullSafeBuilder<User>(
                value: userManager.userNotifier.value,
                builder: (context, user) => Text('User: ${user.name}, Age: ${user.age}'),
                fallback: const Text('No user available'),
              ),
              ElevatedButton(
                onPressed: () {
                  userManager.getUserName();
                },
                child: const Text('Get User Name (Safe)'),
              ),
              ElevatedButton(
                onPressed: () {
                  userManager.celebrateBirthday();
                },
                child: const Text('Celebrate Birthday (Safe)'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await userManager.getAsyncSecretData();
                },
                child: const Text('Get Async Secret Data (With Retry)'),
              ),
              NullSafeFutureBuilder<String>(
                future: Future.delayed(const Duration(seconds: 2), () => 'Loaded Data'),
                builder: (context, data) => Text('Loaded: $data'),
                loadingWidget: const CircularProgressIndicator(),
                fallback: const Text('Failed to load data'),
              ),
              const SizedBox(height: 20),
              Text(userManager.getValueOrDefault('lastAction', 'No action performed yet'),
                  style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}

class User {
  final String name;
  int age;

  User(this.name, this.age);

  void celebrateBirthday() {
    age++;
    print('Happy Birthday, $name! You are now $age years old.');
  }

  Future<String> getAsyncSecretData() async {
    await Future.delayed(const Duration(seconds: 1));
    if (age < 18) throw Exception('User is too young for async secret data');
    return 'Very secret async information';
  }
}