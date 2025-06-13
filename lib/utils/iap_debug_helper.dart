import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart' as iap;

class IAPDebugHelper {
  static Future<Map<String, dynamic>> diagnoseIAPIssues() async {
    final results = <String, dynamic>{};
    
    try {
      // 1. 检查平台
      results['platform'] = Platform.operatingSystem;
      results['isIOS'] = Platform.isIOS;
      results['isAndroid'] = Platform.isAndroid;
      
      // 2. 检查是否是模拟器
      bool isSimulator = Platform.environment.containsKey('SIMULATOR_DEVICE_NAME') || 
                        Platform.environment.containsKey('FLUTTER_TEST');
      results['isSimulator'] = isSimulator;
      results['isRealDevice'] = !isSimulator;
      
      // 3. 检查调试模式
      results['isDebugMode'] = kDebugMode;
      results['isReleaseMode'] = kReleaseMode;
      results['isProfileMode'] = kProfileMode;
      
      // 4. 检查内购服务可用性
      try {
        final iapInstance = iap.InAppPurchase.instance;
        final isAvailable = await iapInstance.isAvailable();
        results['iapServiceAvailable'] = isAvailable;
        
        if (isAvailable) {
          // 5. 尝试查询测试商品
          try {
            final testProductIds = {'xin_coin_ios_12'};
            final response = await iapInstance.queryProductDetails(testProductIds);
            results['productQuerySuccess'] = true;
            results['foundProducts'] = response.productDetails.length;
            results['notFoundProducts'] = response.notFoundIDs;
            results['queryError'] = response.error?.message;
          } catch (e) {
            results['productQuerySuccess'] = false;
            results['productQueryError'] = e.toString();
          }
        }
      } catch (e) {
        results['iapServiceAvailable'] = false;
        results['iapServiceError'] = e.toString();
      }
      
      // 6. 检查网络连接
      try {
        final result = await InternetAddress.lookup('apple.com');
        results['networkConnected'] = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } catch (e) {
        results['networkConnected'] = false;
        results['networkError'] = e.toString();
      }
      
      // 7. 环境变量检查
      results['environment'] = {
        'SIMULATOR_DEVICE_NAME': Platform.environment['SIMULATOR_DEVICE_NAME'],
        'FLUTTER_TEST': Platform.environment['FLUTTER_TEST'],
      };
      
      return results;
    } catch (e) {
      results['generalError'] = e.toString();
      return results;
    }
  }
  
  static String formatDiagnosisResults(Map<String, dynamic> results) {
    final buffer = StringBuffer();
    
    buffer.writeln('=== 内购服务诊断报告 ===');
    buffer.writeln('');
    
    // 基本信息
    buffer.writeln('📱 平台信息:');
    buffer.writeln('  - 操作系统: ${results['platform']}');
    buffer.writeln('  - 是否iOS: ${results['isIOS']}');
    buffer.writeln('  - 是否真机: ${results['isRealDevice']}');
    buffer.writeln('  - 是否模拟器: ${results['isSimulator']}');
    buffer.writeln('  - 调试模式: ${results['isDebugMode']}');
    buffer.writeln('');
    
    // 网络连接
    buffer.writeln('🌐 网络连接:');
    if (results['networkConnected'] == true) {
      buffer.writeln('  ✅ 网络连接正常');
    } else {
      buffer.writeln('  ❌ 网络连接失败');
      if (results['networkError'] != null) {
        buffer.writeln('  错误: ${results['networkError']}');
      }
    }
    buffer.writeln('');
    
    // 内购服务
    buffer.writeln('💰 内购服务:');
    if (results['iapServiceAvailable'] == true) {
      buffer.writeln('  ✅ 内购服务可用');
      
      if (results['productQuerySuccess'] == true) {
        buffer.writeln('  ✅ 商品查询成功');
        buffer.writeln('  找到商品数量: ${results['foundProducts']}');
        if (results['notFoundProducts'] != null && (results['notFoundProducts'] as List).isNotEmpty) {
          buffer.writeln('  未找到的商品ID: ${results['notFoundProducts']}');
        }
      } else {
        buffer.writeln('  ❌ 商品查询失败');
        if (results['productQueryError'] != null) {
          buffer.writeln('  错误: ${results['productQueryError']}');
        }
      }
    } else {
      buffer.writeln('  ❌ 内购服务不可用');
      if (results['iapServiceError'] != null) {
        buffer.writeln('  错误: ${results['iapServiceError']}');
      }
    }
    buffer.writeln('');
    
    // 建议
    buffer.writeln('💡 问题排查建议:');
    
    if (results['isSimulator'] == true) {
      buffer.writeln('  ⚠️  当前在模拟器上运行，内购功能可能不可用');
      buffer.writeln('  建议：在真实设备上测试内购功能');
    }
    
    if (results['networkConnected'] == false) {
      buffer.writeln('  ❌ 网络连接问题');
      buffer.writeln('  建议：检查设备网络连接和防火墙设置');
    }
    
    if (results['iapServiceAvailable'] == false) {
      buffer.writeln('  ❌ 内购服务不可用');
      buffer.writeln('  建议：');
      buffer.writeln('    1. 确保设备已登录Apple ID');
      buffer.writeln('    2. 检查App Store Connect中的商品配置');
      buffer.writeln('    3. 确认应用的Bundle ID匹配');
      buffer.writeln('    4. 检查应用是否已在App Store Connect中设置');
    }
    
    if (results['notFoundProducts'] != null && (results['notFoundProducts'] as List).isNotEmpty) {
      buffer.writeln('  ⚠️  部分商品未在App Store Connect中配置');
      buffer.writeln('  建议：在App Store Connect中添加缺失的商品ID');
    }
    
    return buffer.toString();
  }
} 