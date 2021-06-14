import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/page/home/home_page.dart';
import 'package:logpass_me/presentation/page/main/main_page_cubit.dart';
import 'package:logpass_me/presentation/page/service_list/service_list_page.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/info_snackbar.dart';
import 'package:logpass_me/generated/local_keys.g.dart';

class MainPage extends HookWidget {
  const MainPage({Key? key}) : super(key: key);

  void _cubitListener(
    MainPageCubit cubit,
    MainPageState state,
    BuildContext context,
    AppThemeColors colors,
    AppTypography typography,
    Widget snackBarContent,
  ) {
    state.maybeWhen(
      error: (message) {},
      showAction: () {
        showInformationSnackBar(
          content: snackBarContent,
          context: context,
          colors: colors,
          typography: typography,
        );
      },
      orElse: () {},
    );
  }

  Widget _buildActionSnackBarContent(AppTypography typography, VoidCallback callback) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          tr(LocaleKeys.main_new_action),
          style: typography.snackBar,
          textAlign: TextAlign.center,
        ),
        GestureDetector(
          onTap: callback,
          child: Text(
            tr(LocaleKeys.main_open_action_label),
            style: typography.snackBar,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<MainPageCubit>();
    final color = useAppThemeColors();
    final typography = useAppTypography();
    final index = useState(0);
    final snackBarContent = _buildActionSnackBarContent(typography, () {
      // TODO: implement functionality after button tap
    });
    useCubitListener<MainPageCubit, MainPageState>(
      cubit,
      (cubit, state, context) => _cubitListener(cubit, state, context, color, typography, snackBarContent),
    );

    useEffect(() {
      cubit.init();
      return;
    }, [cubit]);

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
