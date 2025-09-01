import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_theme.dart';

class AppUserAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final VoidCallback? onTap;
  final bool showBorder;
  final Color? borderColor;

  const AppUserAvatar({
    super.key,
    this.imageUrl,
    this.radius = 24.0,
    this.onTap,
    this.showBorder = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: showBorder
              ? Border.all(
                  color: borderColor ?? AppTheme.accentColor,
                  width: 2.0,
                )
              : null,
        ),
        child: CircleAvatar(
          radius: radius,
          backgroundColor: AppTheme.darkGrey,
          backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
              ? CachedNetworkImageProvider(imageUrl!)
              : null,
          child: imageUrl == null || imageUrl!.isEmpty
              ? Icon(
                  Icons.person,
                  size: radius * 1.2,
                  color: Colors.white70,
                )
              : null,
        ),
      ),
    );
  }
}

class AppImageWithLoader extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const AppImageWithLoader({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    // Check if imageUrl is empty or invalid
    if (imageUrl.isEmpty) {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        child: Container(
          width: width,
          height: height,
          color: AppTheme.darkGrey,
          child: const Icon(
            Icons.image_not_supported_outlined,
            color: Colors.white60,
          ),
        ),
      );
    }
    
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: AppTheme.darkGrey,
          highlightColor: AppTheme.darkSurface,
          child: Container(
            width: width,
            height: height,
            color: AppTheme.darkGrey,
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: AppTheme.darkGrey,
          child: const Icon(
            Icons.error_outline,
            color: Colors.white60,
          ),
        ),
      ),
    );
  }
}

class AppGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Gradient gradient;
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final bool isLoading;

  const AppGradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradient = AppTheme.primaryGradient,
    this.width = double.infinity,
    this.height = 50,
    this.borderRadius,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            offset: const Offset(0, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                text,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
      ),
    );
  }
}

class AppEmptyState extends StatelessWidget {
  final String message;
  final String? animationAsset;
  final double? animationSize;
  final IconData? icon;
  final double? iconSize;

  const AppEmptyState({
    super.key,
    required this.message,
    this.animationAsset,
    this.animationSize = 200,
    this.icon,
    this.iconSize = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (animationAsset != null) ...[
              // If we use Lottie animation here, we would add it here
              // For now, using an icon as a placeholder
              Icon(
                icon ?? Icons.fitness_center,
                size: iconSize,
                color: AppTheme.lightGrey,
              ),
              const SizedBox(height: 24),
            ],
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.lightGrey,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class AppSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAllPressed;
  
  const AppSectionHeader({
    super.key,
    required this.title,
    this.onSeeAllPressed,
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTheme.headerAltStyle.copyWith(fontSize: 22),
          ),
          if (onSeeAllPressed != null)
            TextButton(
              onPressed: onSeeAllPressed,
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.accentColor,
                padding: EdgeInsets.zero,
                minimumSize: const Size(40, 30),
              ),
              child: const Text('See All'),
            ),
        ],
      ),
    );
  }
}
