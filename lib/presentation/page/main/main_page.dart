import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MainPage extends HookWidget {
  static final _pageBuilders = [
    () => Container(color: Colors.blueGrey),
    () => Container(color: Colors.blue),
    () => Container(color: Colors.red),
    () => Container(color: Colors.amber),
  ];

  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final index = useState(0);
    final pageStorage = useMemoized(() => <int, Widget>{});

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _getPage(pageStorage, index.value),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wifi),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Your data',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: index.value,
        onTap: (newIndex) => index.value = newIndex,
      ),
    );
  }

  Widget _getPage(Map<int, Widget> storage, int index) {
    final storedPage = storage[index];
    if (storedPage != null) return storedPage;

    final newPage = _pageBuilders[index]();
    storage[index] = newPage;

    return newPage;
  }
}
