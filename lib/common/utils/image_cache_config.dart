import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Глобальная конфигурация кэша изображений
class ImageCacheConfig {
  static void configure() {
    // Увеличиваем размер кэша изображений для лучшей производительности
    PaintingBinding.instance.imageCache.maximumSize =
        1000; // Максимум изображений в памяти
    PaintingBinding.instance.imageCache.maximumSizeBytes =
        200 << 20; // 200MB максимум в памяти

    // Disk cache настраивается автоматически через CachedNetworkImage
    // с параметрами maxWidthDiskCache и maxHeightDiskCache
    if (!kIsWeb) {
      // Настройки только для мобильных платформ
      // НЕ очищаем кэш при запуске для лучшего UX
    }
  }

  /// Очистить кэш изображений (для отладки)
  static void clearCache() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
    // Disk cache очищается автоматически CachedNetworkImage при необходимости
  }

  /// Получить размеры для кэширования изображений в зависимости от типа устройства
  static ImageCacheSize getCacheSizeForDevice() {
    // Определяем размеры кэша в зависимости от устройства
    final double pixelRatio = PaintingBinding
        .instance
        .platformDispatcher
        .views
        .first
        .devicePixelRatio;

    if (pixelRatio > 2.0) {
      // Высокое разрешение (Retina, XXXHDPI)
      return const ImageCacheSize(
        memCacheWidth: 800,
        memCacheHeight: 1000,
        maxWidthDiskCache: 1600,
        maxHeightDiskCache: 2000,
      );
    } else if (pixelRatio > 1.5) {
      // Среднее разрешение (XXHDPI, XHDPI)
      return const ImageCacheSize(
        memCacheWidth: 600,
        memCacheHeight: 800,
        maxWidthDiskCache: 1200,
        maxHeightDiskCache: 1600,
      );
    } else {
      // Низкое разрешение
      return const ImageCacheSize(
        memCacheWidth: 400,
        memCacheHeight: 600,
        maxWidthDiskCache: 800,
        maxHeightDiskCache: 1200,
      );
    }
  }
}

/// Размеры кэша изображений
class ImageCacheSize {
  final int memCacheWidth;
  final int memCacheHeight;
  final int maxWidthDiskCache;
  final int maxHeightDiskCache;

  const ImageCacheSize({
    required this.memCacheWidth,
    required this.memCacheHeight,
    required this.maxWidthDiskCache,
    required this.maxHeightDiskCache,
  });
}
