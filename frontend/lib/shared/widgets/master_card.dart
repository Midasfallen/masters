import 'package:flutter/material.dart';
import '../models/master.dart';
import '../../core/constants/app_sizes.dart';

class MasterCard extends StatelessWidget {
  final Master master;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final bool isFavorite;

  const MasterCard({
    super.key,
    required this.master,
    this.onTap,
    this.onFavorite,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(master.avatar),
              ),
              const SizedBox(width: AppSizes.md),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + Verified badge
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            master.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (master.verified) ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.verified,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Rating + Distance
                    Text(
                      '⭐ ${master.rating} (${master.reviewsCount}) · ${master.distance.toStringAsFixed(1)} км',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 2),

                    // Category + Price
                    Text(
                      '${master.category} · от ${master.priceFrom}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),

              // Favorite button
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_outline,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: onFavorite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
