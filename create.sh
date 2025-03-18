#!/bin/bash

# Root folders
mkdir -p lib/core/constants
mkdir -p lib/core/utils
mkdir -p lib/core/theme
mkdir -p lib/core/localization
mkdir -p lib/data/models
mkdir -p lib/data/repositories
mkdir -p lib/data/services
mkdir -p lib/presentation/screens/splash
mkdir -p lib/presentation/screens/onboarding
mkdir -p lib/presentation/screens/home
mkdir -p lib/presentation/screens/thumbnail_preview
mkdir -p lib/presentation/screens/batch_download
mkdir -p lib/presentation/screens/history
mkdir -p lib/presentation/screens/settings
mkdir -p lib/presentation/screens/about
mkdir -p lib/presentation/widgets
mkdir -p lib/presentation/dialogs
mkdir -p lib/presentation/routes
mkdir -p lib/state/providers
mkdir -p lib/state/controllers
mkdir -p lib/generated
mkdir -p assets/images
mkdir -p assets/icons
mkdir -p assets/fonts
mkdir -p assets/lottie

# Create common files
touch lib/main.dart
touch lib/core/constants/app_strings.dart
touch lib/core/constants/app_colors.dart
touch lib/core/constants/app_sizes.dart
touch lib/core/constants/app_routes.dart
touch lib/core/utils/validators.dart
touch lib/core/utils/formatters.dart
touch lib/core/utils/logger.dart
touch lib/core/theme/app_theme.dart
touch lib/core/theme/app_text_styles.dart
touch lib/core/theme/app_button_styles.dart
touch lib/core/localization/app_localizations.dart
touch lib/data/models/thumbnail_model.dart
touch lib/data/models/user_model.dart
touch lib/data/repositories/thumbnail_repository.dart
touch lib/data/services/api_service.dart
touch lib/data/services/storage_service.dart
touch lib/data/services/image_service.dart
touch lib/presentation/screens/splash/splash_screen.dart
touch lib/presentation/screens/onboarding/onboarding_screen.dart
touch lib/presentation/screens/home/home_screen.dart
touch lib/presentation/screens/thumbnail_preview/thumbnail_preview_screen.dart
touch lib/presentation/screens/batch_download/batch_download_screen.dart
touch lib/presentation/screens/history/history_screen.dart
touch lib/presentation/screens/settings/settings_screen.dart
touch lib/presentation/screens/about/about_screen.dart
touch lib/presentation/widgets/custom_button.dart
touch lib/presentation/widgets/custom_text_field.dart
touch lib/presentation/widgets/network_image_view.dart
touch lib/presentation/dialogs/error_dialog.dart
touch lib/presentation/dialogs/confirmation_dialog.dart
touch lib/presentation/routes/app_routes.dart
touch lib/presentation/routes/route_generator.dart
touch lib/state/providers/theme_provider.dart
touch lib/state/providers/thumbnail_provider.dart
touch lib/state/controllers/home_controller.dart
touch lib/state/controllers/batch_controller.dart

# Print completion message
echo "Flutter folder structure created successfully!"
