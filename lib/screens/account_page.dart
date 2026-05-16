import 'package:flutter/material.dart';

import '../favourites/favourites.dart';
import '../models/models.dart';

typedef LogoutCallback = void Function(bool didLogout);

class AccountPage extends StatefulWidget {
  const AccountPage({
    super.key,
    required this.onLogOut,
    required this.onOpenSupportChat,
    required this.onOpenFavouriteVehicle,
    this.favouriteVehicles = const [],
    this.favouriteError,
    required this.user,
  });

  final User user;
  final LogoutCallback onLogOut;
  final VoidCallback onOpenSupportChat;
  final ValueChanged<String> onOpenFavouriteVehicle;
  final List<FavouriteVehicle> favouriteVehicles;
  final String? favouriteError;

  static const supportTileKey = Key('account_support_tile');
  static const logoutTileKey = Key('account_logout_tile');
  static const favouritesSectionKey = Key('account_favourites_section');

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  ImageProvider<Object> _profileImage(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return NetworkImage(imagePath);
    }
    return AssetImage(imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          buildProfile(),
          const SizedBox(height: 20),
          buildMembershipCard(),
          const SizedBox(height: 20),
          buildFavouritesSection(),
          const SizedBox(height: 20),
          buildMenu(),
        ],
      ),
    );
  }

  Widget buildMembershipCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF0B1220), Color(0xFF1A4F8C)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Echelon Plus',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Priority access to performance vehicles, lower hourly '
            'rates, and free extra-driver coverage.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.82)),
          ),
        ],
      ),
    );
  }

  Widget buildMenu() {
    return Column(
      children: [
        const ListTile(
          leading: Icon(Icons.credit_card_outlined),
          title: Text('Billing and passes'),
          subtitle: Text('Manage payment methods and trip credits'),
        ),
        ListTile(
          key: AccountPage.supportTileKey,
          leading: const Icon(Icons.support_agent),
          title: const Text('Support'),
          subtitle: const Text('Roadside help, damage reporting, and FAQs'),
          onTap: widget.onOpenSupportChat,
        ),
        ListTile(
          key: AccountPage.logoutTileKey,
          leading: const Icon(Icons.logout),
          title: const Text('Log out'),
          onTap: () {
            widget.onLogOut(true);
          },
        ),
      ],
    );
  }

  Widget buildFavouritesSection() {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      key: AccountPage.favouritesSectionKey,
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Favourite vehicles',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            if (widget.favouriteError != null)
              Text(
                widget.favouriteError!,
                style: TextStyle(color: colorScheme.error),
              )
            else if (widget.favouriteVehicles.isEmpty)
              const Text('No favourite vehicles yet.')
            else
              ...widget.favouriteVehicles.map(
                (vehicle) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      vehicle.vehicleImageUrl,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return ColoredBox(
                          color: colorScheme.surfaceContainerHighest,
                          child: const SizedBox(
                            width: 56,
                            height: 56,
                            child: Icon(Icons.directions_car),
                          ),
                        );
                      },
                    ),
                  ),
                  title: Text(vehicle.vehicleName),
                  subtitle: Text(
                    '${vehicle.vehicleClass} | '
                    '\$${vehicle.hourlyRate.toStringAsFixed(0)}/hr',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    widget.onOpenFavouriteVehicle(vehicle.vehicleId);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildProfile() {
    return Column(
      children: [
        CircleAvatar(
          radius: 56,
          backgroundImage: _profileImage(widget.user.profileImageUrl),
        ),
        const SizedBox(height: 16),
        Text(
          '${widget.user.firstName} ${widget.user.lastName}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        Text(widget.user.role),
        Text('${widget.user.points} member points'),
      ],
    );
  }
}
