import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/page/home/home_page.dart';
import 'package:logpass_me/presentation/page/main/main_page_cubit.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

class MainPage extends HookWidget {
  // TODO: fix reinit of pages since each of them is being
  // reinitialized after tab change
  static final _pageBuilders = [
    () => HomePage(),
    () => Container(color: Colors.blue),
    () => Container(color: Colors.red),
    () => Container(color: Colors.amber),
  ];

  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<MainPageCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(() {
      cubit.init();
      return;
    }, [cubit]);

    final index = useState(0);
    final pageStorage = useMemoized(() => <int, Widget>{});

    return Scaffold(
      body: state.maybeWhen(
        idle: () => _PageContent(
          _getPage(pageStorage, index.value),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        orElse: () => const SizedBox(),
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

class _PageContent extends StatelessWidget {
  final Widget page;

  const _PageContent(this.page);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: page,
        ),
      ],
    );
  }
}
