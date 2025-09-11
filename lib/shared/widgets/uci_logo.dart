import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class UCILogo extends StatelessWidget {
  final double size;
  final bool showShadow;
  final BoxFit fit;

  const UCILogo({
    super.key,
    this.size = 80.0,
    this.showShadow = true,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: size * 0.2,
                  spreadRadius: size * 0.05,
                ),
              ]
            : null,
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/logo/logo.jpg',
          width: size,
          height: size,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            // Fallback to icon if logo fails to load
            return Container(
              width: size,
              height: size,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryVariant,
                  ],
                ),
              ),
              child: Icon(
                Icons.qr_code_scanner,
                size: size * 0.5,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }
}

// Predefined logo sizes for common use cases
class UCILogoSizes {
  static const double small = 32.0;
  static const double medium = 48.0;
  static const double large = 80.0;
  static const double xlarge = 120.0;
}

// Convenience widgets for common logo sizes
class UCILogoSmall extends StatelessWidget {
  const UCILogoSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return const UCILogo(
      size: UCILogoSizes.small,
      showShadow: false,
    );
  }
}

class UCILogoMedium extends StatelessWidget {
  const UCILogoMedium({super.key});

  @override
  Widget build(BuildContext context) {
    return const UCILogo(
      size: UCILogoSizes.medium,
      showShadow: true,
    );
  }
}

class UCILogoLarge extends StatelessWidget {
  const UCILogoLarge({super.key});

  @override
  Widget build(BuildContext context) {
    return const UCILogo(
      size: UCILogoSizes.large,
      showShadow: true,
    );
  }
}

class UCILogoXLarge extends StatelessWidget {
  const UCILogoXLarge({super.key});

  @override
  Widget build(BuildContext context) {
    return const UCILogo(
      size: UCILogoSizes.xlarge,
      showShadow: true,
    );
  }
}
