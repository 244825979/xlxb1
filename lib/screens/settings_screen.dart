import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_colors.dart';
import '../utils/iap_debug_helper.dart';
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