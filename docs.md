InsightMe Documentation
=======================

Business Requirements
---------------------

### Data Collection

-   Integrate with Google Fit, Fitbit, Netatmo, RescueTime, Apple Health, MyFitnessPal, Headspace
-   Allow manual mood input

### Data Analysis

-   Correlate data, predict mood, discover causal effects
-   Answer questions like "What affects my mood?" and "How to optimize my mood?"
-   Personalized insights and recommendations based on users' data

### Visualization and Reports

-   Display data in scatter plots and other diagrams
-   Generate automated reports
-   Customizable dashboard with relevant information and visualizations

### Chat Interface

-   Chatbot integration using fine-tuned GPT backend for answering user questions
-   Leverage auto-generated reports and high-level data to provide personalized answers

### Additional Features

-   Goal setting and tracking
-   Customizable notifications and reminders
-   Social sharing and community engagement
-   Gamification elements like challenges, badges, or leaderboards
-   Cross-platform availability (iOS and Android)

### Data Privacy and Security

-   Comply with data protection regulations and guidelines
-   Provide users with control over their data

### Onboarding Experience

-   Engaging onboarding experience for setting up an account, connecting to third-party services, and understanding app features

### Accessibility

-   Supporting multiple languages, start with English and German
-   Dark Mode Support

Technical Specifications
------------------------
### General Specifications
1.  Development Practices
    -   Implement CI/CD using GCP Cloud Build and GitHub
    -   Test-driven development
    -   Favor Python, Flutter, Terraform
2.  Project Organization
    -   Folder and file structure
        -   Organization by feature
3.  Infrastructure Management
    -   Infrastructure as code with Terraform
4.  Monitoring, Logging, and Alerting
    -   GCP logging and alerts
    -   Monitoring and alerting: Set up monitoring and alerting systems to notify the development team of critical issues or anomalies in the application's performance. This can be achieved using tools such as Google Cloud Monitoring or third-party monitoring solutions.
5.  Data Security, Privacy, and Compliance
    -   Data security and data privacy compliance
    -   GDPR compliance
        -   Ensure all GCP resources are compliant with GDPR
        -   Store and process data in the EU
        -   Store secrets in Google Secret Manager
### Backend Specifications
#### Data Pipeline Overview
##### Overview

1.  External Data Sources
2.  External Data Import
3.  Data Lake
4.  Data Transformation
5.  Data Warehouse
6.  Model Training
7.  Model Artifacts Storage
8.  Model Inference

##### 1\. External Data Sources

-   Third-party integrations:
    -   Google Fit
    -   Fitbit
    -   Netatmo
    -   RescueTime
    -   Apple Health
    -   MyFitnessPal
    -   Headspace

##### 2\. External Data Import

-   Trigger: Cloud Scheduler
-   GCP resource: Cloud Functions
-   Preferred Method: REST API
-   Data Source: External Data Sources
-   Data Sink: Data Lake

##### 3\. Data Lake

-   GCP resource: Google Cloud Storage
-   Description: Stores raw data

##### 4\. Data Transformation

-   Source: Data Lake
-   GCP resource: Cloud Dataflow
-   Trigger: New data in Data Lake
-   Sink: Data Warehouse

##### 5\. Data Warehouse

-   GCP resource: BigQuery
-   Description: Stores aggregated and cleaned data
-   Ingest: Transformation and manual logging

##### 6\. Model Training

-   Source: Data Warehouse
-   GCP resource: BigQuery ML or Cloud Functions
-   Trigger: Cloud Scheduler
-   Data Sink: Model Artifacts Storage
-   Functionality: Correlation, prediction, causal discovery

##### 7\. Model Artifacts Storage

-   GCP resource: Google Cloud Storage
-   Description: Stores model weights and metadata

##### 8\. Model Inference

-   GCP resource: Cloud Functions
-   Trigger: HTTP request from Mobile App
-   Endpoint: HTTP
-   Functionality: Generate personalized insights and recommendations

### Frontend (Mobile App)

Framework: Flutter for Cross-platform availability (iOS and Android)
Features:
-   Firestore: User authentication
-   Dashboard with customizable visualizations
-   Personalized recommendations
-   Automatic report generation
-   Chat Interface:
    -   Framework: maybe Dialogflow
    -   Description: Utilize the Dialogflow framework for natural language understanding and processing to power the chatbot, enabling it to provide personalized answers based on user data and auto-generated reports.
    -   Integration: Connect the Dialogflow chatbot to the fine-tuned GPT backend for answering more complex user questions.
         (Dialogflow and GPT)
-   Goal setting
-   Notifications and reminders
-   Manual logging
-   Social sharing and community engagement
-   Gamification elements
    -   Streaks
-   Design
    -   Dark mode support
-   Analytics: Firebase Analytics