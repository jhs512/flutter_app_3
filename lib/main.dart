import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.freezed.dart';

part 'main.g.dart';

@riverpod
class CountState extends _$CountState {
  @override
  int build() => 0;

  void increment() {
    state++;
  }
}

@freezed
class Todo with _$Todo {
  const factory Todo({
    required String title,
    required String description,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}

@riverpod
class TodosState extends _$TodosState {
  @override
  List<Todo> build() => [
        Todo(
          title: 'title',
          description: 'description',
        ),
        Todo(
          title: 'title',
          description: 'description',
        )
      ];

  void add(Todo todo) {
    state = [...state, todo];
  }
}

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosState = ref.watch(todosStateProvider);
    final countStateValue = ref.watch(countStateProvider);
    final countState = ref.read(countStateProvider.notifier);

    final count2State = useState(0);

    return GestureDetector(
      onTap: () => {
        countState.increment(),
        count2State.value++,
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
            Text(
              '${countStateValue}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              '${count2State.value}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(todosStateProvider.notifier).add(
                      Todo(
                        title: 'title',
                        description: 'description',
                      ),
                    );
              },
              child: const Text('Add Todo'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: todosState.length,
                itemBuilder: (context, index) {
                  final todo = todosState[index];
                  return ListTile(
                    title: Text(todo.title),
                    subtitle: Text(todo.description),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
