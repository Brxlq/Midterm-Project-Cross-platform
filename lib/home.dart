import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/components.dart';
import '../favourites/favourites.dart';
import '../models/models.dart';
import '../screens/screens.dart';
import 'constants.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.auth,
    required this.cartManager,
    required this.ordersManager,
    required this.favouriteManager,
    required this.changeTheme,
    required this.changeColor,
    required this.colorSelected,
    required this.onTabSelected,
    required this.tab,
  });

  final YummyAuth auth;
  final int tab;
  final CartManager cartManager;
  final OrderManager ordersManager;
  final FavouriteVehicleManager favouriteManager;
  final ColorSelection colorSelected;
  final Future<void> Function(bool useLightMode) changeTheme;
  final Future<void> Function(int value) changeColor;
  final Future<void> Function(int value) onTabSelected;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<NavigationDestination> appBarDestinations = const [
    NavigationDestination(
      icon: Icon(Icons.explore_outlined),
      label: 'Discover',
      selectedIcon: Icon(Icons.explore),
    ),
    NavigationDestination(
      icon: Icon(Icons.route_outlined),
      label: 'Trips',
      selectedIcon: Icon(Icons.route),
    ),
    NavigationDestination(
      icon: Icon(Icons.person_2_outlined),
      label: 'Profile',
      selectedIcon: Icon(Icons.person),
    ),
  ];

  @override
  void initState() {
    super.initState();
    widget.favouriteManager.addListener(_handleFavouriteUpdate);
    widget.favouriteManager.start();
  }

  @override
  void didUpdateWidget(covariant Home oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.favouriteManager != widget.favouriteManager) {
      oldWidget.favouriteManager.removeListener(_handleFavouriteUpdate);
      widget.favouriteManager.addListener(_handleFavouriteUpdate);
    }
  }

  void _handleFavouriteUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.favouriteManager.removeListener(_handleFavouriteUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      ExplorePage(
        cartManager: widget.cartManager,
        orderManager: widget.ordersManager,
        favouriteManager: widget.favouriteManager,
      ),
      MyOrdersPage(orderManager: widget.ordersManager),
      AccountPage(
        onLogOut: (logout) async {
          await widget.auth.signOut();
          if (!context.mounted) return;
          context.go('/login');
        },
        onOpenSupportChat: () {
          context.go('/${widget.tab}/support-chat');
        },
        onOpenFavouriteVehicle: (vehicleId) {
          context.go('/${EchelonTab.discover.value}/vehicle/$vehicleId');
        },
        favouriteVehicles: widget.favouriteManager.favourites,
        favouriteError: widget.favouriteManager.error,
        user: User(
          firstName: 'Yerkebulan',
          lastName: 'Sovet',
          role: 'Echelon Member',
          profileImageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/Red_Hood_Logo.svg/512px-Red_Hood_Logo.svg.png',
          points: 2400,
          darkMode: true,
        ),
      ),
    ];

    final subtitle = switch (widget.tab) {
      0 => 'Shared vehicles for every kind of city day',
      1 => 'Your upcoming reservations',
      _ => 'Membership, preferences, and support',
    };

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ECHELON',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        actions: [
          ThemeButton(changeThemeMode: widget.changeTheme),
          ColorButton(
            changeColor: widget.changeColor,
            colorSelected: widget.colorSelected,
          ),
        ],
      ),
      body: IndexedStack(index: widget.tab, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.tab,
        onDestinationSelected: (index) async {
          await widget.onTabSelected(index);
          if (!context.mounted) return;
          context.go('/$index');
        },
        destinations: appBarDestinations,
      ),
    );
  }
}
