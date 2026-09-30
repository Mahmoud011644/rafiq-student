import 'package:flutter/material.dart';
import '../models/admin_model.dart';
import '../services/admin_storage_service.dart';
import '../services/auth_service.dart';
import 'admin_login_screen.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({Key? key}) : super(key: key);

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  late AdminSettings _settings;
  bool _isLoading = true;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await AdminStorageService.getAdminSettings();
    setState(() {
      _settings = settings;
      _isLoading = false;
    });
  }

  Future<void> _handleLogout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const AdminLoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('لوحة التحكم')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة التحكم الإدارية'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('تغيير كلمة المرور'),
                value: 'change_password',
              ),
              PopupMenuItem(
                child: const Text('تسجيل خروج'),
                value: 'logout',
              ),
            ],
            onSelected: (value) async {
              if (value == 'logout') {
                await _handleLogout();
              } else if (value == 'change_password') {
                _showChangePasswordDialog();
              }
            },
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              TabBar(
                tabs: const [
                  Tab(text: 'الخدمات'),
                  Tab(text: 'خطط الاشتراك'),
                  Tab(text: 'مميزات إضافية'),
                ],
                onTap: (index) {
                  setState(() => _selectedTabIndex = index);
                },
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildServicesSection(),
                    _buildSubscriptionPlansSection(),
                    _buildServiceFeaturesSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServicesSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إدارة الخدمات الرئيسية',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _buildServiceToggle(
                'المساعد الذكي',
                'تفعيل/تعطيل المساعد الذكي AI',
                _settings.aiAssistantEnabled,
                (value) async {
                  setState(() => _settings.aiAssistantEnabled = value);
                  await AdminStorageService.updateAdminSettings(_settings);
                },
              ),
              _buildServiceToggle(
                'تلخيص الدروس',
                'تفعيل/تعطيل خاصية تلخيص الدروس',
                _settings.lessonSummarizerEnabled,
                (value) async {
                  setState(() => _settings.lessonSummarizerEnabled = value);
                  await AdminStorageService.updateAdminSettings(_settings);
                },
              ),
              _buildServiceToggle(
                'الاختبارات',
                'تفعيل/تعطيل الاختبارات والاختبارات',
                _settings.quizEnabled,
                (value) async {
                  setState(() => _settings.quizEnabled = value);
                  await AdminStorageService.updateAdminSettings(_settings);
                },
              ),
              _buildServiceToggle(
                'الوضع بلا إنترنت',
                'تفعيل/تعطيل تنزيل الدروس',
                _settings.offlineModeEnabled,
                (value) async {
                  setState(() => _settings.offlineModeEnabled = value);
                  await AdminStorageService.updateAdminSettings(_settings);
                },
              ),
              _buildServiceToggle(
                'التنبيهات',
                'تفعيل/تعطيل إشعارات التطبيق',
                _settings.pushNotificationsEnabled,
                (value) async {
                  setState(() => _settings.pushNotificationsEnabled = value);
                  await AdminStorageService.updateAdminSettings(_settings);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionPlansSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إدارة خطط الاشتراك',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ..._settings.subscriptionPlans.map((plan) {
                    return _buildSubscriptionPlanCard(plan);
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionPlanCard(SubscriptionPlan plan) {
    final priceController = TextEditingController(text: plan.price.toString());

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'السعر: ${plan.price.toStringAsFixed(0)} SDG',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: plan.isEnabled,
                  onChanged: (value) async {
                    setState(() => plan.isEnabled = value);
                    await AdminStorageService.updateSubscriptionPlan(
                      plan.id,
                      plan.price,
                      plan.features,
                      value,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'تغيير السعر:',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: priceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: 'السعر الجديد',
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    final newPrice =
                        double.tryParse(priceController.text) ?? plan.price;
                    setState(() => plan.price = newPrice);
                    await AdminStorageService.updateSubscriptionPlan(
                      plan.id,
                      newPrice,
                      plan.features,
                      plan.isEnabled,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم تحديث السعر')),
                    );
                  },
                  child: const Text('تحديث'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'المميزات:',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            ...plan.features.map((feature) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  const Icon(Icons.check, size: 16, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      feature,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceFeaturesSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إدارة مميزات خدمة إضافية',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ..._settings.serviceFeatures.map((feature) {
                return _buildServiceFeatureCard(feature);
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceFeatureCard(ServiceFeature feature) {
    final priceController =
        TextEditingController(text: (feature.price ?? 0).toString());

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feature.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        feature.description,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: feature.isEnabled,
                  onChanged: (value) async {
                    setState(() => feature.isEnabled = value);
                    await AdminStorageService.toggleServiceFeature(
                      feature.id,
                      value,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'السعر الإضافي:',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: priceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: 'السعر (اترك فارغاً إذا لم يكن هناك)',
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    final newPrice = priceController.text.isEmpty
                        ? null
                        : double.tryParse(priceController.text);
                    setState(() => feature.price = newPrice);
                    await AdminStorageService.updateServiceFeaturePrice(
                      feature.id,
                      newPrice,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم تحديث السعر')),
                    );
                  },
                  child: const Text('تحديث'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceToggle(
    String title,
    String description,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تغيير كلمة المرور'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'كلمة المرور القديمة',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'كلمة المرور الجديدة',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'تأكيد كلمة المرور الجديدة',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (newPasswordController.text !=
                  confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(كلما المرور الجديدة غير متطابقة')),
                );
                return;
              }

              final success = await AuthService.changePassword(
                'admin@rafiqstudent.app',
                oldPasswordController.text,
                newPasswordController.text,
              );

              if (mounted) {
                if (success) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('تم تغيير كلمة المرور بنجاح')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('فشل تغيير كلمة المرور')),
                  );
                }
              }
            },
            child: const Text('تغيير'),
          ),
        ],
      ),
    );
  }
}
