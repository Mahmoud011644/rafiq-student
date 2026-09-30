class AdminSettings {
  bool aiAssistantEnabled;
  bool lessonSummarizerEnabled;
  bool quizEnabled;
  bool offlineModeEnabled;
  bool pushNotificationsEnabled;
  List<SubscriptionPlan> subscriptionPlans;
  List<ServiceFeature> serviceFeatures;

  AdminSettings({
    this.aiAssistantEnabled = true,
    this.lessonSummarizerEnabled = true,
    this.quizEnabled = true,
    this.offlineModeEnabled = false,
    this.pushNotificationsEnabled = true,
    List<SubscriptionPlan>? subscriptionPlans,
    List<ServiceFeature>? serviceFeatures,
  })  : subscriptionPlans = subscriptionPlans ?? [
          SubscriptionPlan(
            id: 'starter',
            name: 'الباقة الأساسية',
            price: 150.0,
            isEnabled: true,
            features: ['الوصول إلى جميع الدورات الأساسية'],
          ),
        ],
        serviceFeatures = serviceFeatures ?? [
          ServiceFeature(
            id: 'ai_coach',
            name: 'مدرب ذكي',
            description: 'إحصائيات مخصصة ومساعدة فورية',
            isEnabled: true,
            price: 30.0,
          ),
        ];
}

class SubscriptionPlan {
  final String id;
  final String name;
  double price;
  bool isEnabled;
  final List<String> features;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.isEnabled,
    required this.features,
  });
}

class ServiceFeature {
  final String id;
  final String name;
  final String description;
  bool isEnabled;
  double? price;

  ServiceFeature({
    required this.id,
    required this.name,
    required this.description,
    required this.isEnabled,
    this.price,
  });
}
