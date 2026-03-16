import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/view_models/collection_view_model.dart';
import '../../common/router/route_name.dart';
import '../../common/widgets/back_button_widget.dart';
import '../../common/widgets/location_item_widget.dart';

class CollectionPage extends StatelessWidget {
  final CollectionViewModel collectionViewModel;

  const CollectionPage({super.key, required this.collectionViewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(collectionViewModel.getName(context)),
        leading: const BackButtonWidget(),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 2,
          mainAxisSpacing: 6,
        ),
        itemCount: collectionViewModel.locations.length,
        itemBuilder: (context, index) {
          final location = collectionViewModel.locations[index];
          return LocationItemWidget(
            key: ValueKey(location.id),
            location: location,
            onTap: () => context.push(RouteName.location, extra: location),
          );
        },
      ),
    );
  }
}
