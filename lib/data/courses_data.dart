import '../models/course_model.dart';

class CoursesData {
  static final List<Course> allCourses = [
    // الحاسوب
    Course(
      id: 'computer_1',
      title: 'أساسيات الحاسوب',
      description: 'تعرف على أساسيات استخدام الحاسوب والمهارات الأساسية',
      category: 'الحاسوب',
      difficulty: 'مبتدئ',
      imageUrl: '💻',
      totalLessons: 5,
      lessons: [
        Lesson(
          id: 'lesson_1',
          title: 'مقدمة عن الحاسوب',
          content: 'الحاسوب هو جهاز إلكتروني يقوم بمعالجة البيانات وتخزينها',
          sections: ['تعريف الحاسوب', 'أنواع الحاسوب', 'الفوائد'],
          bulletPoints: [
            'جهاز معالجة بيانات',
            'يتكون من أجزاء فيزيائية وبرمجية',
            'يستخدم في التعليم والعمل',
          ],
          quiz: Quiz(
            id: 'quiz_1',
            title: 'اختبار مقدمة الحاسوب',
            questions: [
              QuizQuestion(
                id: 'q1',
                question: 'ما هو الحاسوب؟',
                options: ['جهاز معالجة البيانات', 'جهاز تشغيل الموسيقى', 'جهاز طهي', 'جهاز غسيل'],
                correctAnswerIndex: 0,
              ),
              QuizQuestion(
                id: 'q2',
                question: 'كم عدد أنواع الحاسوب الرئيسية؟',
                options: ['2', '3', '4', '5'],
                correctAnswerIndex: 2,
              ),
            ],
          ),
        ),
        Lesson(
          id: 'lesson_2',
          title: 'مكونات الحاسوب الأساسية',
          content: 'يتكون الحاسوب من مكونات فيزيائية وبرمجية مهمة',
          sections: ['المكونات الفيزيائية', 'المكونات البرمجية'],
          bulletPoints: [
            'المعالج (CPU)',
            'الذاكرة العشوائية (RAM)',
            'القرص الصلب (HDD/SSD)',
            'اللوحة الأم',
          ],
        ),
      ],
    ),
    Course(
      id: 'computer_2',
      title: 'مكونات الحاسوب',
      description: 'تعرف على المكونات الداخلية والخارجية للحاسوب',
      category: 'الحاسوب',
      difficulty: 'مبتدئ',
      imageUrl: '⚙️',
      totalLessons: 4,
      lessons: [
        Lesson(
          id: 'lesson_3',
          title: 'المعالج',
          content: 'المعالج هو دماغ الحاسوب',
          sections: ['وظيفة المعالج', 'أنواع المعالجات', 'سرعة المعالج'],
          bulletPoints: [
            'معالجة التعليمات',
            'إجراء الحسابات',
            'التحكم في العمليات',
          ],
        ),
      ],
    ),
    Course(
      id: 'computer_3',
      title: 'أنظمة التشغيل',
      description: 'تعلم عن أنظمة التشغيل المختلفة',
      category: 'الحاسوب',
      difficulty: 'مبتدئ',
      imageUrl: '🖥️',
      totalLessons: 6,
      lessons: [],
    ),
    // البرمجة
    Course(
      id: 'programming_1',
      title: 'مقدمة في البرمجة',
      description: 'ابدأ رحلتك في عالم البرمجة من الصفر',
      category: 'البرمجة',
      difficulty: 'مبتدئ',
      imageUrl: '👨‍💻',
      totalLessons: 8,
      lessons: [
        Lesson(
          id: 'lesson_4',
          title: 'ما هي البرمجة؟',
          content: 'البرمجة هي عملية كتابة التعليمات للحاسوب',
          sections: ['تعريف البرمجة', 'لغات البرمجة', 'المجالات'],
          bulletPoints: [
            'كتابة أوامر للحاسوب',
            'استخدام لغات برمجة',
            'حل المشاكل',
          ],
          quiz: Quiz(
            id: 'quiz_2',
            title: 'اختبار مقدمة البرمجة',
            questions: [
              QuizQuestion(
                id: 'q3',
                question: 'ما هي البرمجة؟',
                options: ['كتابة الشعر', 'كتابة التعليمات للحاسوب', 'رسم الصور', 'تصوير الفيديو'],
                correctAnswerIndex: 1,
              ),
            ],
          ),
        ),
      ],
    ),
    Course(
      id: 'programming_2',
      title: 'أساسيات Dart',
      description: 'تعلم لغة Dart المستخدمة في Flutter',
      category: 'البرمجة',
      difficulty: 'مبتدئ',
      imageUrl: '🎯',
      totalLessons: 10,
      lessons: [],
    ),
    Course(
      id: 'programming_3',
      title: 'أساسيات Flutter',
      description: 'بناء تطبيقات الهاتف باستخدام Flutter',
      category: 'البرمجة',
      difficulty: 'متقدم',
      imageUrl: '📱',
      totalLessons: 12,
      lessons: [],
    ),
    // البرمجيات
    Course(
      id: 'software_1',
      title: 'Microsoft Word',
      description: 'تعلم استخدام Microsoft Word بشكل احترافي',
      category: 'البرمجيات',
      difficulty: 'مبتدئ',
      imageUrl: '📄',
      totalLessons: 5,
      lessons: [],
    ),
    Course(
      id: 'software_2',
      title: 'Microsoft Excel',
      description: 'اتقن استخدام جداول البيانات',
      category: 'البرمجيات',
      difficulty: 'متوسط',
      imageUrl: '📊',
      totalLessons: 8,
      lessons: [],
    ),
    // الكهرباء
    Course(
      id: 'electricity_1',
      title: 'أساسيات الكهرباء',
      description: 'تعرف على الكهرباء ومفاهيمها الأساسية',
      category: 'الكهرباء',
      difficulty: 'مبتدئ',
      imageUrl: '⚡',
      totalLessons: 7,
      lessons: [
        Lesson(
          id: 'lesson_5',
          title: 'مقدمة عن الكهرباء',
          content: 'الكهرباء هي تدفق الإلكترونات عبر مادة موصلة',
          sections: ['تعريف الكهرباء', 'مصادر الطاقة', 'الأمان'],
          bulletPoints: [
            'تدفق الإلكترونات',
            'من مصادر طبيعية وصناعية',
            'استخدام آمن مهم',
          ],
          quiz: Quiz(
            id: 'quiz_3',
            title: 'اختبار أساسيات الكهرباء',
            questions: [
              QuizQuestion(
                id: 'q4',
                question: 'ما هي الكهرباء؟',
                options: ['تدفق الماء', 'تدفق الإلكترونات', 'تدفق الهواء', 'تدفق النار'],
                correctAnswerIndex: 1,
              ),
            ],
          ),
        ),
      ],
    ),
    Course(
      id: 'electricity_2',
      title: 'قانون أوم',
      description: 'فهم العلاقة بين الجهد والتيار والمقاومة',
      category: 'الكهرباء',
      difficulty: 'متوسط',
      imageUrl: '⚙️',
      totalLessons: 5,
      lessons: [],
    ),
  ];
}
