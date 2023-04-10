InsightMe Documentation
=======================

Technical Specifications
------------------------
### General Specifications
1.  Development Practices
    -   Implement CI/CD using GCP Cloud Build and GitHub
        - https://github.com/christianreiser/InsightMe
        - git branch: dev_incl_backend
        - gcp project id: bubbly-reducer-279907
        - region europe-west3
        
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

### File Structure
```
├── backend
│   ├── extract
│   │   └── g_fit
│   │       ├── main.py
│   │       └── requirements.txt
│   └── store
│       └── bigquery
├── chrisi.reiser.github.key.txt
├── chrisi.reiser.github.key.txt.pub
├── ci_cd
│   └── cloudbuild.yaml
├── docs
│   ├── business_requirements.md
│   ├── docs.md
│   └── file_structure.md
├── mobile_app
└── terraform
    ├── bigquery.tf
    ├── extract_g_fit
    ├── extraction_scheduler.tf
    ├── g_fit_extraction.tf
    ├── __main__.tf
    ├── project_services.tf
    ├── __service_account__.tf
    └── __variables__.tf
```