
```
moodopti/
│
├── backend/
│   ├── cloud_functions/
│   │   ├── chatbot_integration/
│   │   ├── data_collection/
│   │   ├── data_processing/
│   │   ├── report_generation/
│   │   └── README.md
│   ├── dataflow/
│   │   ├── pipelines/
│   │   └── README.md
│   ├── bigquery_ml/
│   │   ├── models/
│   │   └── README.md
│   ├── scheduler_tasks/
│   │   ├── data_collection/
│   │   ├── model_training/
│   │   ├── report_generation/
│   │   └── README.md
│   ├── tests/
│   │   ├── cloud_functions_tests/
│   │   ├── dataflow_tests/
│   │   ├── bigquery_ml_tests/
│   │   └── scheduler_tasks_tests/
│   └── terraform/
│       ├── environments/
│       ├── modules/
│       ├── backend.tf
│       ├── provider.tf
│       ├── variables.tf
│       └── outputs.tf
├── mobile_app/
│   ├── components/
│   ├── data_collection/
│   ├── data_processing/
│   ├── machine_learning/
│   ├── visualization/
│   ├── models/
│   ├── screens/
│   ├── services/
│   ├── utils/
│   ├── theme/
│   ├── test/
│   ├── assets/
│   ├── README.md
│   └── pubspec.yaml
├── gcp_architecture/
│   ├── cloud_functions/
│   ├── bigquery/
│   ├── dataflow/
│   ├── cloud_scheduler/
│   ├── firestore/
│   ├── cloud_storage/
│   ├── cloud_run_app_engine/
│   ├── README.md
│   └── .gitignore
├── ci_cd/
│   ├── cloudbuild.yaml
│   ├── deploy.yaml
│   ├── release.yaml
│   └── README.md
├── analytics/
│   ├── google_analytics/
│   ├── firebase_analytics/
│   └── README.md
├── push_notifications/
│   ├── firebase_cloud_messaging/
│   ├── pusher/
│   └── README.md
├── dark_mode_support/
│   ├── mobile_app/
│   ├── backend/
│   └── README.md
└── README.md
│
├── mobile_app/
│ ├── lib/
│ │ ├── screens/
│ │ │ ├── dashboard/
│ │ │ │ ├── dashboard_screen.dart
│ │ │ │ └── dashboard_widgets.dart
│ │ │ ├── mood_input/
│ │ │ │ ├── mood_input_screen.dart
│ │ │ │ └── mood_input_widgets.dart
│ │ │ ├── goal_setting/
│ │ │ │ ├── goal_setting_screen.dart
│ │ │ │ └── goal_setting_widgets.dart
│ │ │ ├── reports/
│ │ │ │ ├── report_screen.dart
│ │ │ │ └── report_widgets
│ │ │ ├── visualization/
│ │ │ │ ├── visualization_screen.dart
│ │ │ │ └── visualization_widgets.dart
│ │ │ ├── settings/
│ │ │ │ ├── settings_screen.dart
│ │ │ │ └── settings_widgets.dart
│ │ │ ├── chatbot/
│ │ │ │ ├── chatbot_screen.dart
│ │ │ │ └── chatbot_widgets.dart
│ │ │ └── onboarding/
│ │ │ ├── onboarding_screen.dart
│ │ │ └── onboarding_widgets.dart
│ │ ├── widgets/
│ │ │ ├── common/
│ │ │ │ ├── app_bar.dart
│ │ │ │ ├── drawer.dart
│ │ │ │ ├── progress_indicator.dart
│ │ │ │ └── custom_button.dart
│ │ │ ├── custom_text_field/
│ │ │ │ ├── custom_text_field.dart
│ │ │ │ └── custom_text_field_test.dart
│ │ │ └── custom_picker/
│ │ │ ├── custom_picker.dart
│ │ │ └── custom_picker_test.dart
│ │ ├── navigation/
│ │ │ ├── app_routes.dart
│ │ │ └── navigation_service.dart
│ │ ├── theme/
│ │ │ ├── app_colors.dart
│ │ │ ├── app_text_styles.dart
│ │ │ └── app_theme.dart
│ │ └── main.dart
│ ├── assets/
│ │ ├── images/
│ │ │ ├── logo.png
│ │ │ └── icons/
│ │ │ ├── mood_icons/
│ │ │ │ ├── happy.png
│ │ │ │ ├── sad.png
│ │ │ │ ├── angry.png
│ │ │ │ └── neutral.png
│ │ │ └── other_icons/
│ │ │ ├── settings.png
│ │ │ └── chatbot.png
│ │ └── fonts/
│ │ └── custom_font.ttf
│ │ └── i18n/
│ │ │ ├── en.json
│ │ │ └── de.json
│ ├── android/
│ ├── ios/
│ ├── test/
│ │ ├── screens_tests/
│ │ │ ├── dashboard_screen_test.dart
│ │ │ ├── mood_input_screen_test.dart
│ │ │ ├── goal_setting_screen_test.dart
│ │ │ ├── reports_screen_test.dart
│ │ │ ├── visualization_screen_test.dart
│ │ │ ├── settings_screen_test.dart
│ │ │ ├── chatbot_screen_test.dart
│ │ │ └── onboarding_screen_test.dart
│ │ ├── widgets_tests/
│ │ │ ├── common_widgets_test.dart
│ │ │ ├── custom_text_field_test.dart
│ │ │ └── custom_picker_test.dart
│ │ └── navigation_tests/
│ │ ├── app_routes_test.dart
│ │ └── navigation_service_test.dart
│ ├── pubspec.yaml
│ └── README.md
├── .gitignore
├── cloudbuild.yaml
├── .gcloudignore
├── .github/
│ ├── workflows/
│ ├── test.yml
│ └── deploy.yml
├── docs/
│ ├── diagrams/
│ │ └── architecture_diagram.png
│ ├── api_documentation.md
│ └── onboarding_guide.md
└── README.md
```
