import 'package:flutter/material.dart';
import 'qr_scanner_page.dart';
import 'list_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  void _goToPage(int index) {
    if (_currentPageIndex != index) {
      setState(() {
        _currentPageIndex = index;
      });
    }
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            QRScannerPage(),
            ListPage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: _goToPage,
        selectedIconTheme: const IconThemeData(size: 32),
        unselectedIconTheme: const IconThemeData(size: 24),
        items: [
          BottomNavigationBarItem(
            icon: _buildIcon('assets/images/qr_icon.png', false),
            activeIcon: _buildIcon('assets/images/qr_icon.png', true),
            label: 'Сканер',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon('assets/images/list_icon.png', false),
            activeIcon: _buildIcon('assets/images/list_icon.png', true),
            label: 'Список',
          ),
        ],
      ),
    );
  }

  static Widget _buildIcon(String assetPath, bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? 82 : 64,
      height: isActive ? 64.06 : 50,
      child: Image.asset(
        assetPath,
        fit: BoxFit.contain,
      ),
    );
  }
}
