import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/page/home/home_page.dart';
import 'package:logpass_me/presentation/page/session_list/service_list_page.dart';
import 'package:logpass_me/presentation/page/main/main_page_cubit.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

class MainPage extends HookWidget {
  const MainPage({Key? key}) : super(key: key);

  void _cubitListener(MainPageCubit cubit, MainPageState state, BuildContext context) {
    state.maybeWhen(
      error: (message) {},
      showAction: () {},
      orElse: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<MainPageCubit>();
    final state = useCubitBuilder(cubit);
    useCubitListener<MainPageCubit, MainPageState>(
      cubit,
      (cubit, state, context) => _cubitListener(cubit, state, context),
    );

    useEffect(() {
      cubit.init();
      return;
    }, [cubit]);

    final index = useState(0);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: IndexedStack(
              index: index.value,
              children: [
                const HomePage(),
                const ServiceListPage(),
                Container(color: Colors.red),
                Container(color: Colors.amber),
              ],
            ),
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
}
