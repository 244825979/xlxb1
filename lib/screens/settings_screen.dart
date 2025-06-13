import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_colors.dart';
import '../utils/iap_debug_helper.dart';
import '../services/apple_signin_service.dart';
import 'feedback_screen.dart';
import 'user_agreement_screen.dart';
import 'privacy_policy_screen.dart';
import 'about_us_screen.dart';
import 'my_reports_screen.dart';
import 'blocked_content_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 设置状态栏为黑色
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ));

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            '设置',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            // 功能设置分组
            _buildSectionTitle('功能设置'),
            SizedBox(height: 16),
            _buildSettingItem(
              context,
              icon: Icons.flag_outlined,
              title: '我的举报',
              subtitle: '查看举报记录和处理状态',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyReportsScreen()),
              ),
            ),
            SizedBox(height: 12),
            _buildSettingItem(
              context,
              icon: Icons.block,
              title: '屏蔽管理',
              subtitle: '查看和管理已屏蔽的内容',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BlockedContentScreen()),
              ),
            ),
            SizedBox(height: 12),
            _buildSettingItem(
              context,
              icon: Icons.feedback_outlined,
              title: '意见反馈',
              subtitle: '告诉我们您的建议',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedbackScreen()),
              ),
            ),
            
            // 只在调试模式下显示内购诊断
            if (kDebugMode) ...[
              SizedBox(height: 12),
              _buildSettingItem(
                context,
                icon: Icons.bug_report,
                title: '内购服务诊断',
                subtitle: '调试内购服务问题',
                onTap: () => _showIAPDiagnosisDialog(context),
              ),
            ],
            
            SizedBox(height: 12),
            _buildDangerousSettingItem(
              context,
              icon: Icons.delete_forever,
              title: '注销账户',
              subtitle: '永久删除账户及所有数据',
              onTap: () => _showDeleteAccountDialog(context),
            ),
            
            SizedBox(height: 32),
            
            // 法律协议分组
            _buildSectionTitle('法律协议'),
            SizedBox(height: 16),
            _buildSettingItem(
              context,
              icon: Icons.description_outlined,
              title: '用户协议',
              subtitle: '查看用户服务协议',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserAgreementScreen()),
              ),
            ),
            SizedBox(height: 12),
            _buildSettingItem(
              context,
              icon: Icons.security_outlined,
              title: '隐私政策',
              subtitle: '了解心聊想伴的隐私保护',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
              ),
            ),
            
            SizedBox(height: 32),
            
            // 关于应用分组
            _buildSectionTitle('关于应用'),
            SizedBox(height: 16),
            _buildSettingItem(
              context,
              icon: Icons.info_outline,
              title: '关于我们',
              subtitle: '了解心聊想伴',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutUsScreen()),
              ),
            ),
            
            SizedBox(height: 40),
            
            // 版本信息
            _buildVersionInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppColors.softShadow],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: AppColors.textSecondary,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  // 危险操作的设置项（红色主题）
  Widget _buildDangerousSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppColors.softShadow],
        border: Border.all(
          color: Colors.red.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.red,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.red,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.red,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildVersionInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.favorite,
            color: AppColors.primary,
            size: 32,
          ),
          SizedBox(height: 12),
          Text(
            '心聊想伴',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Version 1.0.0',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '记录每一刻心情',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textLight,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
  
  // 显示注销账户确认对话框
  void _showDeleteAccountDialog(BuildContext context) async {
    // 首先检查是否已登录Apple账户
    final isSignedIn = await AppleSignInService.isAppleSignedIn();
    
    // 检查组件是否还挂载
    if (!context.mounted) return;
    
    if (!isSignedIn) {
      // 未登录，显示提示信息
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.info, color: AppColors.primary, size: 24),
              SizedBox(width: 8),
              Text(
                '提示',
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            '你还没有进行登录，无法进行注销操作~',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text('知道了'),
            ),
          ],
        ),
      );
      return;
    }
    
    // 已登录，显示注销确认对话框
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red, size: 24),
            SizedBox(width: 8),
            Text(
              '注销账户',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '此操作将永久删除您的账户和所有数据，包括：',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 12),
            _buildDeleteItem('• Apple登录信息'),
            _buildDeleteItem('• 账户金币余额'),
            _buildDeleteItem('• VIP会员状态'),
            _buildDeleteItem('• 所有本地数据'),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.red, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '此操作无法撤销，请谨慎操作！',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              '取消',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _performDeleteAccount(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('确认注销'),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  // 执行注销账户操作
  void _performDeleteAccount(BuildContext context) async {
    // 显示加载对话框
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('正在注销账户...'),
          ],
        ),
      ),
    );

    try {
      // 执行注销操作
      final result = await AppleSignInService.deleteAccount();
      
      // 检查组件是否还挂载
      if (!context.mounted) return;
      
      // 关闭加载对话框
      Navigator.of(context).pop();
      
      if (result['success'] == true) {
        // 注销成功，显示成功消息并返回
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 24),
                SizedBox(width: 8),
                Text('注销成功'),
              ],
            ),
            content: Text('您的账户已成功注销，所有数据已清除。'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 关闭对话框
                  Navigator.of(context).pop(); // 返回上一页
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: Text('确定'),
              ),
            ],
          ),
        );
      } else {
        // 注销失败，显示错误消息
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? '注销失败'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // 检查组件是否还挂载
      if (!context.mounted) return;
      
      // 关闭加载对话框
      Navigator.of(context).pop();
      
      // 显示错误消息
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('注销过程中发生错误: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // 显示内购诊断对话框
  void _showIAPDiagnosisDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => FutureBuilder<Map<String, dynamic>>(
        future: IAPDebugHelper.diagnoseIAPIssues(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return AlertDialog(
              title: Text('正在诊断内购服务...'),
              content: Container(
                height: 100,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
          
          if (snapshot.hasError) {
            return AlertDialog(
              title: Text('诊断失败'),
              content: Text('诊断过程中发生错误: ${snapshot.error}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('关闭'),
                ),
              ],
            );
          }
          
          final results = snapshot.data!;
          final diagnosis = IAPDebugHelper.formatDiagnosisResults(results);
          
          return AlertDialog(
            title: Text('内购服务诊断报告'),
            content: Container(
              width: double.maxFinite,
              constraints: BoxConstraints(maxHeight: 500),
              child: SingleChildScrollView(
                child: Text(
                  diagnosis,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('关闭'),
              ),
              TextButton(
                onPressed: () {
                  // 复制诊断信息到剪贴板
                  Clipboard.setData(ClipboardData(text: diagnosis));
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('诊断信息已复制到剪贴板')),
                  );
                },
                child: Text('复制'),
              ),
            ],
          );
        },
      ),
    );
  }
  

} 