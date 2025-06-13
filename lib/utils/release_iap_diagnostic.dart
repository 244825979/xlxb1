import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart' as iap;

class ReleaseIAPDiagnostic {
  
  static Future<Map<String, dynamic>> diagnoseReleaseIssues() async {
    final results = <String, dynamic>{};
    
    try {
      // 1. 基本环境检查
      results['platform'] = Platform.operatingSystem;
      results['isIOS'] = Platform.isIOS;
      results['isDebugMode'] = kDebugMode;
      results['isReleaseMode'] = kReleaseMode;
      
      // 2. 设备类型检查
      bool isSimulator = Platform.environment.containsKey('SIMULATOR_DEVICE_NAME') || 
                        Platform.environment.containsKey('FLUTTER_TEST');
      results['isSimulator'] = isSimulator;
      results['isRealDevice'] = !isSimulator;
      
      // 3. 网络连接检查
      try {
        final result = await InternetAddress.lookup('apple.com');
        results['appleNetworkReachable'] = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } catch (e) {
        results['appleNetworkReachable'] = false;
        results['networkError'] = e.toString();
      }
      
      try {
        final result = await InternetAddress.lookup('buy.itunes.apple.com');
        results['appStoreNetworkReachable'] = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } catch (e) {
        results['appStoreNetworkReachable'] = false;
        results['appStoreNetworkError'] = e.toString();
      }
      
      // 4. 内购服务检查
      try {
        final iapInstance = iap.InAppPurchase.instance;
        
        // 检查服务可用性
        final isAvailable = await iapInstance.isAvailable();
        results['iapServiceAvailable'] = isAvailable;
        
        if (!isAvailable) {
          // 如果服务不可用，尝试更多诊断
          results['iapServiceUnavailableReason'] = await _diagnoseUnavailableReason();
        } else {
          // 如果服务可用，尝试查询商品
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
      
      // 5. 设备配置检查
      if (Platform.isIOS) {
        results['deviceChecks'] = await _checkiOSDeviceConfiguration();
      }
      
      return results;
    } catch (e) {
      results['generalError'] = e.toString();
      return results;
    }
  }
  
  static Future<String> _diagnoseUnavailableReason() async {
    final reasons = <String>[];
    
    // 检查是否在模拟器上
    bool isSimulator = Platform.environment.containsKey('SIMULATOR_DEVICE_NAME') || 
                      Platform.environment.containsKey('FLUTTER_TEST');
    if (isSimulator) {
      reasons.add('运行在模拟器上（内购服务在模拟器上不可用）');
    }
    
    // 检查网络连接
    try {
      await InternetAddress.lookup('apple.com');
    } catch (e) {
      reasons.add('无法连接到Apple服务器');
    }
    
    if (reasons.isEmpty) {
      reasons.add('可能的原因：设备未登录Apple ID、地区限制、或App Store Connect配置问题');
    }
    
    return reasons.join('; ');
  }
  
  static Future<Map<String, dynamic>> _checkiOSDeviceConfiguration() async {
    final config = <String, dynamic>{};
    
    try {
      // 检查设备设置（这些检查在Release模式下可能受限）
      config['canCheckDeviceSettings'] = true;
      
      // 注意：在Release模式下，某些系统信息可能无法访问
      config['note'] = 'Release模式下设备信息检查受限';
      
    } catch (e) {
      config['error'] = e.toString();
    }
    
    return config;
  }
  
  static String formatReleaseResults(Map<String, dynamic> results) {
    final buffer = StringBuffer();
    
    buffer.writeln('=== Release模式内购诊断报告 ===');
    buffer.writeln('');
    
    // 环境信息
    buffer.writeln('🏗️ 构建环境:');
    buffer.writeln('  - 平台: ${results['platform']}');
    buffer.writeln('  - 是否iOS: ${results['isIOS']}');
    buffer.writeln('  - 调试模式: ${results['isDebugMode']}');
    buffer.writeln('  - 生产模式: ${results['isReleaseMode']}');
    buffer.writeln('  - 真实设备: ${results['isRealDevice']}');
    buffer.writeln('  - 模拟器: ${results['isSimulator']}');
    buffer.writeln('');
    
    // 网络连接
    buffer.writeln('🌐 网络连接:');
    if (results['appleNetworkReachable'] == true) {
      buffer.writeln('  ✅ Apple服务器连接正常');
    } else {
      buffer.writeln('  ❌ Apple服务器连接失败');
      if (results['networkError'] != null) {
        buffer.writeln('     错误: ${results['networkError']}');
      }
    }
    
    if (results['appStoreNetworkReachable'] == true) {
      buffer.writeln('  ✅ App Store服务器连接正常');
    } else {
      buffer.writeln('  ❌ App Store服务器连接失败');
      if (results['appStoreNetworkError'] != null) {
        buffer.writeln('     错误: ${results['appStoreNetworkError']}');
      }
    }
    buffer.writeln('');
    
    // 内购服务状态
    buffer.writeln('💰 内购服务状态:');
    if (results['iapServiceAvailable'] == true) {
      buffer.writeln('  ✅ 内购服务可用');
      
      if (results['productQuerySuccess'] == true) {
        buffer.writeln('  ✅ 商品查询成功');
        buffer.writeln('     找到商品: ${results['foundProducts']}');
        if (results['notFoundProducts'] != null && (results['notFoundProducts'] as List).isNotEmpty) {
          buffer.writeln('     未找到商品: ${results['notFoundProducts']}');
        }
      } else {
        buffer.writeln('  ❌ 商品查询失败');
        if (results['productQueryError'] != null) {
          buffer.writeln('     错误: ${results['productQueryError']}');
        }
      }
    } else {
      buffer.writeln('  ❌ 内购服务不可用');
      if (results['iapServiceError'] != null) {
        buffer.writeln('     错误: ${results['iapServiceError']}');
      }
      if (results['iapServiceUnavailableReason'] != null) {
        buffer.writeln('     可能原因: ${results['iapServiceUnavailableReason']}');
      }
    }
    buffer.writeln('');
    
    // Release模式特殊说明
    buffer.writeln('⚠️ Release模式特殊要求:');
    buffer.writeln('  1. 必须在真实设备上运行');
    buffer.writeln('  2. 设备必须登录有效的Apple ID');
    buffer.writeln('  3. 应用必须在App Store Connect中正确配置');
    buffer.writeln('  4. 商品必须处于"准备提交"或"已批准"状态');
    buffer.writeln('  5. Bundle ID必须与App Store Connect中的完全匹配');
    buffer.writeln('  6. 如果是测试环境，需要使用沙盒测试账号');
    buffer.writeln('');
    
    // 解决建议
    buffer.writeln('🔧 Release模式问题解决建议:');
    buffer.writeln('');
    
    if (results['isSimulator'] == true) {
      buffer.writeln('  ❌ 当前在模拟器运行');
      buffer.writeln('     解决: 在真实iOS设备上测试');
      buffer.writeln('');
    }
    
    if (results['appleNetworkReachable'] == false) {
      buffer.writeln('  ❌ 网络连接问题');
      buffer.writeln('     解决: 检查网络连接，确保能访问Apple服务');
      buffer.writeln('');
    }
    
    if (results['iapServiceAvailable'] == false) {
      buffer.writeln('  ❌ 内购服务不可用的解决步骤:');
      buffer.writeln('     1. 确认设备已登录Apple ID（设置→iTunes Store与App Store）');
      buffer.writeln('     2. 检查Apple ID是否有效且未被限制');
      buffer.writeln('     3. 确认应用已在App Store Connect中配置');
      buffer.writeln('     4. 验证Bundle ID: com.aoyou.xinbo');
      buffer.writeln('     5. 检查地区设置是否支持内购');
      buffer.writeln('     6. 确认设备时间和时区设置正确');
      buffer.writeln('     7. 尝试重启设备');
      buffer.writeln('     8. 如果是企业证书分发，需要特殊配置');
      buffer.writeln('');
    }
    
    return buffer.toString();
  }
} 