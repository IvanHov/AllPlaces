import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../modules/explore/explore_page.dart';
import '../../modules/explore/bloc/explore_bloc.dart';
// import '../../message/message_page.dart';
// import '../../profile/profile_page.dart';
// import '../../saved/saved_page.dart';
// import '../../trips/trips_page.dart';

class AppBottomNavigationBar extends StatefulWidget {
  const AppBottomNavigationBar({super.key});

  @override
  State<AppBottomNavigationBar> createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  // int _currentIndex = 0;

  // final List<BottomNavigationBarItem> _items = [
  //   const BottomNavigationBarItem(
  //     icon: Icon(Icons.explore_outlined),
  //     activeIcon: Icon(Icons.explore),
  //     label: 'Explore',
  //   ),
  //   const BottomNavigationBarItem(
  //     icon: Icon(Icons.bookmark_border),
  //     activeIcon: Icon(Icons.bookmark),
  //     label: 'Saved',
  //   ),
  //   const BottomNavigationBarItem(icon: Icon(Icons.sync_alt), label: 'Trips'),
  //   const BottomNavigationBarItem(
  //     icon: Icon(Icons.chat_bubble_outline),
  //     activeIcon: Icon(Icons.chat_bubble),
  //     label: 'Message',
  //   ),
  //   const BottomNavigationBarItem(
  //     icon: Icon(Icons.person_outline),
  //     activeIcon: Icon(Icons.person),
  //     label: 'Profile',
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExploreBloc(),
      child: const Scaffold(
        body: ExplorePage(),
        // bottomNavigationBar: Theme(
        //   data: Theme.of(context).copyWith(
        //     splashFactory: NoSplash.splashFactory,
        //     highlightColor: Colors.transparent,
        //   ),
        //   child: BottomNavigationBar(
        //     items: _items,
        //     currentIndex: _currentIndex,
        //     onTap: (index) {
        //       setState(() {
        //         _currentIndex = index;
        //       });
        //     },
        //     type: BottomNavigationBarType.fixed,
        //     selectedItemColor: Colors.green,
        //     unselectedItemColor: Colors.grey,
        //     showSelectedLabels: true,
        //     showUnselectedLabels: true,
        //     selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        //     unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        //   ),
        // ),
      ),
    );
  }

  // Widget _getCurrentPage() {
  //   switch (_currentIndex) {
  //     case 0:
  //       return const ExplorePage();
  //     case 1:
  //       return const SavedPage();
  //     case 2:
  //       return const TripsPage();
  //     case 3:
  //       return const MessagePage();
  //     case 4:
  //       return const ProfilePage();
  //     default:
  //       throw Exception('Invalid index: $_currentIndex');
  //   }
  // }
}
