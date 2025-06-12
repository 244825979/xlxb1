import 'package:flutter/material.dart';

class AppColors {
  // 主色调
  static const Color primary = Color(0xFFFF6B6B);
  static const Color primaryLight = Color(0xFFFFE5E5);
  static const Color primaryDark = Color(0xFFFF4F4F);
  static const Color primaryBlue = Color(0xFF4A90E2); // 蓝色主题色，用于心情分析
  
  // 背景色
  static const Color background = Color(0xFFFAFAFA);
  static const Color cardBackground = Colors.white;
  
  // 文字颜色
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textLight = Color(0xFFB2BEC3);
  
  // 功能色
  static const Color playButton = Color(0xFFFF6B6B);
  static const Color playButtonHover = Color(0xFFFF4F4F);
  static const Color favoriteRed = Color(0xFFFF6B6B);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFB74D);
  static const Color error = Color(0xFFFF3B30);
  
  // 渐变色
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFE5E5),
      Color(0xFFFAFAFA),
    ],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF6B6B), Color(0xFFFF4F4F)],
  );
  
  // 阴影色
  static BoxShadow get cardShadow => BoxShadow(
    blurRadius: 12,
    color: primary.withOpacity(0.12),
    offset: const Offset(0, 4),
  );
  
  static BoxShadow get softShadow => BoxShadow(
    blurRadius: 8,
    color: primary.withOpacity(0.08),
    offset: const Offset(0, 2),
  );
} 