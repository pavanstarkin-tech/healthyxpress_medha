# 🏥 HealthExpress AI — Intelligent Healthcare Platform & Control Center

[![IBM Bob](https://img.shields.io/badge/Implemented_With-IBM_Bob-052FAD?logo=ibm&logoColor=white)](https://bob.ibm.com/)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![React](https://img.shields.io/badge/React-19-61DAFB?logo=react&logoColor=black)](https://react.dev)
[![Vite](https://img.shields.io/badge/Vite-6.x-646CFF?logo=vite&logoColor=white)](https://vitejs.dev)
[![PHP](https://img.shields.io/badge/PHP-8.2+-777BB4?logo=php&logoColor=white)](https://www.php.net)
[![MariaDB](https://img.shields.io/badge/MariaDB-Live_Production-4479A1?logo=mariadb&logoColor=white)](https://mariadb.org)
[![NVIDIA NIM](https://img.shields.io/badge/NVIDIA_NIM-GPT--OSS--20B-76B900?logo=nvidia&logoColor=white)](https://www.nvidia.com)
[![Sarvam AI](https://img.shields.io/badge/Sarvam_AI-Saaras_v3_STT-FF6F00?logo=fastapi&logoColor=white)](https://sarvam.ai)
[![Agora](https://img.shields.io/badge/Agora-WebRTC_HD_Video-099DFD?logo=agora&logoColor=white)](https://www.agora.io)
[![Mapbox](https://img.shields.io/badge/Mapbox-GL_Vector_GPS-000000?logo=mapbox&logoColor=white)](https://www.mapbox.com)
[![Razorpay](https://img.shields.io/badge/Razorpay-Live_Payments-0C2340?logo=razorpay&logoColor=white)](https://razorpay.com)
[![GitHub Pages](https://img.shields.io/badge/Live_Deployment-GitHub_Pages-22C55E?logo=github&logoColor=white)](https://pavanstarkin-tech.github.io/healthyxpress_medha/)

> **HealthExpress AI** is an end-to-end, high-performance healthcare super-app and operational command center. It unifies **multilingual voice-first AI clinical intake (Telugu, Hindi, English)**, **embedded Agora HD video teleconsultations**, **15-minute hyperlocal dark-store emergency medicine delivery**, **home diagnostic lab test sample collections**, and **ABDM & Aarogyasri government health scheme integrations** into a single, synchronized platform.

---

## 🌐 Live Production Links

* **📱 Patient & Doctor Web App**: [https://pavanstarkin-tech.github.io/healthyxpress_medha/](https://pavanstarkin-tech.github.io/healthyxpress_medha/)
* **💻 Super Admin & Hospital Operations Dashboard**: [https://pavanstarkin-tech.github.io/healthyxpress_medha/admin/](https://pavanstarkin-tech.github.io/healthyxpress_medha/admin/)
* **🐘 Live Hostinger REST API Health**: [https://vedvaidyam.com/healthexpress/api/health](https://vedvaidyam.com/healthexpress/api/health)

---

## 🤖 Implemented with IBM Bob

This entire project was architected, developed, optimized, and deployed using **[IBM Bob](https://bob.ibm.com/)**.

### What is IBM Bob?
**[IBM Bob](https://bob.ibm.com/)** is an AI-powered software development partner from IBM. It helps developers build, understand, modify, test, and modernize software using natural-language instructions.

> *In simple words: **IBM Bob is like an AI coding teammate** that can understand your project and help you go from **idea → planning → coding → testing → modernization**.* ([IBM Bob Documentation](https://bob.ibm.com/docs/ide/tutorials/introduction?utm_source=chatgpt.com))

### Main Features of IBM Bob
* ⚡ **Code Generation** – creates clean, idiomatic, production-grade code across Flutter, React, PHP, and SQL from plain-language instructions.
* 🔍 **Code Debugging & Refactoring** – identifies edge cases, resolves WebRTC streaming bugs, optimizes SQL queries, and cleans asynchronous state management.
* 🧠 **Codebase Understanding** – deeply maps and indexes existing cross-repository files, configurations, and API surfaces to provide contextual answers.
* 🤖 **Autonomous AI Agents** – divides complex development milestones into parallelized sub-tasks (e.g., simultaneous Flutter UI and PHP REST API development).
* 💻 **Bob Shell** – executes build tools, analyzes package trees, and runs deployment scripts directly from the command-line environment.
* 📝 **Technical Documentation** – continuously produces comprehensive architecture diagrams, database schemas, and developer onboarding manuals.
* 🔄 **Legacy Modernization** – bridges modern WebRTC & AI microservices with traditional database architectures and enterprise systems.

### 🛠️ How IBM Bob Powered HealthExpress AI Development

```mermaid
flowchart TD
    subgraph Phase1["1. Ideation & Planning"]
        Idea["💡 Natural Language Project Spec<br/>(15-Min Healthcare Super-App)"] --> BobPlan["🤖 IBM Bob Architecture Planner<br/>(ABDM, Aarogyasri, Multi-tier Schema)"]
    end

    subgraph Phase2["2. Full-Stack Code Generation"]
        BobPlan --> BobFlutter["📱 Flutter Web & Mobile App<br/>(Voice AI, Agora WebRTC, Mapbox)"]
        BobPlan --> BobReact["💻 React 19 + Vite Admin<br/>(Live Telemetry, Bed Tracking)"]
        BobPlan --> BobPHP["🐘 Hostinger PHP 8.2+ REST API<br/>(16 Endpoints, PDO Singleton)"]
        BobPlan --> BobDB["🗄️ MariaDB Relational Database<br/>(16 Normalized Tables, Indexes)"]
    end

    subgraph Phase3["3. Debugging & AI Integration"]
        BobFlutter & BobPHP --> BobDebug["🔍 IBM Bob Refactoring & QA Engine<br/>• Real-time Audio Energy VAD Auto-Cut<br/>• Sarvam STT & NVIDIA NIM Prompting<br/>• WebRTC Local PiP Video Stream Fix"]
    end

    subgraph Phase4["4. Dual Build & CI/CD Deployment"]
        BobDebug --> BobShell["💻 IBM Bob Shell Automation<br/>(flutter analyze lib -> 0 errors)"]
        BobShell --> Deploy["🚀 Dual Deployment to GitHub Pages<br/>(App: / | Admin: /admin/)"]
    end

    style Phase1 fill:#E0F2FE,stroke:#0284C7,stroke-width:2px
    style Phase2 fill:#EDE9FE,stroke:#7C3AED,stroke-width:2px
    style Phase3 fill:#FEF3C7,stroke:#D97706,stroke-width:2px
    style Phase4 fill:#DCFCE7,stroke:#16A34A,stroke-width:2px
```

* Explore the official [IBM Bob website](https://bob.ibm.com/?utm_source=chatgpt.com) and [IBM Bob Documentation](https://bob.ibm.com/docs/ide/tutorials/introduction?utm_source=chatgpt.com) for more details.

---

## 📑 Table of Contents

1. [User Interface & Screen Gallery](#1-user-interface--screen-gallery)
2. [System Architecture](#2-system-architecture)
3. [Venn Diagram: HealthExpress Convergence](#3-venn-diagram-healthexpress-convergence)
4. [Core Workflows & Detailed Flowcharts](#4-core-workflows--detailed-flowcharts)
   - [A. The "Golden 15-Minute" Care Loop](#a-the-golden-15-minute-care-loop)
   - [B. Multilingual Voice AI Triage & Intake Engine](#b-multilingual-voice-ai-triage--intake-engine)
   - [C. Doctor Teleconsultation & Live E-Prescription Workflow](#c-doctor-teleconsultation--live-e-prescription-workflow)
   - [D. 15-Minute Hyperlocal Dark Store Medicine Dispatch](#d-15-minute-hyperlocal-dark-store-medicine-dispatch)
   - [E. ABDM QR Consent & Aarogyasri Health Pass Verification](#e-abdm-qr-consent--aarogyasri-health-pass-verification)
5. [State Diagrams & Lifecycle State Machines](#5-state-diagrams--lifecycle-state-machines)
   - [A. Multilingual Clinical AI Triage State Machine](#a-multilingual-clinical-ai-triage-state-machine)
   - [B. 15-Minute Medicine Order Lifecycle](#b-15-minute-medicine-order-lifecycle)
   - [C. Video Teleconsultation State Machine](#c-video-teleconsultation-state-machine)
6. [Role-Wise Capabilities & Feature Matrix](#6-role-wise-capabilities--feature-matrix)
7. [Production Relational Database Schema & ER Diagram](#7-production-relational-database-schema--er-diagram)
8. [Complete REST API Endpoint Directory](#8-complete-rest-api-endpoint-directory)
9. [Technology Stack & Directory Structure](#9-technology-stack--directory-structure)
10. [Setup, Local Development & Deployment Guide](#10-setup-local-development--deployment-guide)
11. [Compliance & Clinical Standards](#11-compliance--clinical-standards)

---

## 1. User Interface & Screen Gallery

### 💻 Super Admin & Hospital Operations Command Center
| Hospital & Bed Operations | Super Admin Telemetry & Metrics | Inventory & Store Verifications |
| :---: | :---: | :---: |
| <img src="ui/admin-1.png" width="350" alt="Hospital Bed Operations" /> | <img src="ui/admin-2.png" width="350" alt="Super Admin Telemetry" /> | <img src="ui/admin-3.png" width="350" alt="Store Verifications" /> |

### 📱 Patient Super-App & Doctor Telehealth Console
| Home Care & Quick Actions | Voice AI Clinical Intake | Doctor Discovery & Booking |
| :---: | :---: | :---: |
| <img src="ui/app-ui-1.png" width="260" alt="Patient Home Dashboard" /> | <img src="ui/app-ui-2.png" width="260" alt="Voice AI Triage" /> | <img src="ui/app-ui-3.png" width="260" alt="Doctor Booking" /> |

| 15-Min Pharmacy & Lab Tests | ABDM Health Locker & Aarogyasri |
| :---: | :---: |
| <img src="ui/app-ui-4.png" width="260" alt="Pharmacy & Tests" /> | <img src="ui/app-ui-5.png" width="260" alt="ABDM & Aarogyasri" /> |

---

## 2. System Architecture

```mermaid
graph TD
    subgraph ClientLayer["1. Client Applications Layer"]
        PatientApp["📱 Flutter Patient Web/Mobile Super-App<br/>(Voice AI Triage, 15-Min Cart, Mapbox GPS)"]
        DoctorApp["🩺 Flutter Doctor Telehealth Portal<br/>(Agora Video Room, ABDM QR Scan, Rx Builder)"]
        AdminApp["💻 React 19 + Vite Super Admin Dashboard<br/>(3D Metrics, Dark Store KYC, Bed Allocations)"]
    end

    subgraph APILayer["2. API Gateway & Microservices Layer"]
        PHPBackend["🐘 Hostinger PHP 8.2+ REST API<br/>(Apache Mod_Rewrite / PDO Singleton / JWT Auth)"]
    end

    subgraph DatabaseLayer["3. Persistent Relational Data Layer"]
        LiveDB[("🗄️ Hostinger MariaDB Database<br/>u170253497_healthexpress (Port 3306)<br/>16 Relational Tables & Immutable Audit Trail")]
    end

    subgraph CloudServices["4. External Engines & Cloud APIs"]
        SarvamAI["🎙️ Sarvam AI (saaras:v3 / bulbul:v3)<br/>Multilingual Regional STT & TTS (Telugu, Hindi, Eng)"]
        NvidiaNIM["🧠 NVIDIA NIM (GPT-OSS-20B)<br/>Clinical SOAP Reasoning & Triage Engine"]
        AgoraRTC["🎥 Agora RTC Engine<br/>Encrypted HD WebRTC Video & Audio"]
        MapboxGL["🗺️ Mapbox GL Vector Maps<br/>Hyperlocal GPS Delivery Route Calculation"]
        RazorpayGW["💳 Razorpay Live Payment Gateway<br/>UPI, Cards, NetBanking & HMAC-SHA256"]
    end

    PatientApp -->|HTTPS REST| PHPBackend
    DoctorApp -->|HTTPS REST| PHPBackend
    AdminApp -->|Axios REST| PHPBackend

    PatientApp -.->|16kHz Audio Stream| SarvamAI
    PatientApp -.->|WebRTC Video & Audio| AgoraRTC
    PatientApp -.->|Vector GPS Tiles| MapboxGL
    PatientApp -.->|Payment SDK| RazorpayGW

    DoctorApp -.->|WebRTC Video Call| AgoraRTC

    PHPBackend -->|PDO Prepared Statements| LiveDB
    PHPBackend -->|Clinical Prompts| NvidiaNIM
    PHPBackend -->|Token Generation| AgoraRTC
    PHPBackend -->|Signature Verification| RazorpayGW

    style ClientLayer fill:#F8FAFC,stroke:#64748B,stroke-width:2px
    style APILayer fill:#EFF6FF,stroke:#3B82F6,stroke-width:2px
    style DatabaseLayer fill:#ECFDF5,stroke:#10B981,stroke-width:2px
    style CloudServices fill:#FFF7ED,stroke:#F97316,stroke-width:2px
```

---

## 3. Venn Diagram: HealthExpress Convergence

HealthExpress AI unites four traditionally disconnected healthcare silos into an integrated patient experience:

```mermaid
flowchart TD
    subgraph HealthExpressSuperApp["🏥 HealthExpress AI Super-App Synergy"]
        A["🧠 Multilingual Clinical AI<br/>• Real-time Voice Triage<br/>• Auto-Detect Telugu/Hindi/English<br/>• Differential SOAP Diagnosis"]
        B["🏬 Hyperlocal Dark-Store Logistics<br/>• 15-Minute Emergency Drop<br/>• 3-5 km Radius Dark Stores<br/>• Live Mapbox GPS Tracking"]
        C["🏛️ Government Health Schemes<br/>• ABDM 15-Min Dynamic QR Consent<br/>• Aarogyasri 5L Cashless Pass<br/>• Empaneled Hospital Directory"]
        D["🎥 Real-Time Teleconsultation<br/>• Agora HD Video Calls<br/>• Real-time Volume Metering<br/>• Digital Signed E-Prescriptions"]
    end

    A --- B
    B --- C
    C --- D
    D --- A

    A -.-> Core(["⭐ 15-Minute Unified Golden Care Loop"])
    B -.-> Core
    C -.-> Core
    D -.-> Core

    style HealthExpressSuperApp fill:#F0FDF4,stroke:#16A34A,stroke-width:2px
    style Core fill:#1E60F6,color:#FFFFFF,stroke:#0B42BA,stroke-width:3px
```

---

## 4. Core Workflows & Detailed Flowcharts

### A. The "Golden 15-Minute" Care Loop

```mermaid
flowchart TD
    Start([👤 Patient Feels Unwell]) --> VoiceIntake["🎙️ Speak Symptoms in Mother Tongue<br/>(Telugu / Hindi / English)"]
    VoiceIntake --> AutoDetect["🌐 AI Auto-Detects Language & Dialect<br/>(Native Script, Tanglish, Hinglish)"]
    AutoDetect --> AITriage["🧠 Sarvam STT + NVIDIA NIM Reasoning<br/>(Urgency Rating, Red Flag Check & Home Care)"]
    AITriage --> Decision{Emergency or Doctor Needed?}
    
    Decision -- Immediate Emergency --> SOS["🚨 1-Tap 108 Emergency Ambulance Dispatch<br/>+ Hospital Trauma Bed Reserve"]
    Decision -- Telehealth Consult --> VideoDoc["🎥 1-Click Agora HD Video Consultation<br/>(Doctor views Pre-Loaded AI SOAP Notes)"]
    
    VideoDoc --> DigitalRx["✍️ Doctor Signs Digital E-Prescription"]
    DigitalRx --> AutoCart["🛒 Auto-Populates 15-Min Pharmacy Cart"]
    
    AutoCart --> DarkStore["🏬 Nearest Dark Store (3-5km) Packs Order"]
    DarkStore --> Dispatch["🛵 Mapbox GPS Tracked 15-Min Doorstep Drop"]
    
    DigitalRx --> ABDMVault["🔒 Prescriptions & Records Synced to<br/>ABDM Health Vault & Aarogyasri Profile"]
    Dispatch --> Delivered([✅ Patient Healed & Relieved in <15 Mins])

    style Start fill:#EF4444,color:#FFFFFF,stroke:#B91C1C,stroke-width:2px
    style Delivered fill:#10B981,color:#FFFFFF,stroke:#047857,stroke-width:2px
    style Decision fill:#FEF08A,stroke:#CA8A04,stroke-width:2px
```

---

### B. Multilingual Voice AI Triage & Intake Engine

```mermaid
sequenceDiagram
    autonumber
    actor User as 👤 Patient
    participant Mic as 🎙️ Browser Audio & VAD
    participant Sarvam as 🔊 Sarvam AI (saaras:v3 / bulbul:v3)
    participant Provider as ⚡ AiAssistantProvider
    participant NIM as 🧠 NVIDIA NIM / Sarvam LLM
    participant PHP as 🐘 Hostinger API
    participant DB as 🗄️ MariaDB Database

    User->>Mic: Speaks audio in native language (Telugu / Hindi / English)
    Mic->>Sarvam: 16kHz Mono WAV Audio Stream
    Sarvam-->>Provider: Real-Time Transcript & Detected Language
    
    Provider->>Provider: detectLanguage() -> Auto-switch language mode
    Provider->>PHP: POST /api/ai/triage (User Transcript, Language, Stage)
    PHP->>NIM: Structured Clinical Intake Prompt (Strict Target Language Output)
    NIM-->>PHP: JSON (Assessment, Next 2 Questions, Matched Remedies)
    
    PHP->>DB: INSERT into ai_triage_sessions (Session ID: SESS-XXXX)
    DB-->>PHP: Persisted
    PHP-->>Provider: Triage Report + Dynamic Action Cards
    Provider->>Sarvam: speakText(ResponseText, targetLang)
    Sarvam-->>User: HD Regional Female Voice (Kavitha / Kavya / Priya)
```

---

### C. Doctor Teleconsultation & Live E-Prescription Workflow

```mermaid
sequenceDiagram
    autonumber
    actor Patient as 👤 Patient
    actor Doctor as 🩺 Doctor
    participant App as 📱 Flutter App
    participant API as 🐘 PHP Backend
    participant Agora as 🎥 Agora WebRTC
    participant DB as 🗄️ MariaDB Database

    Patient->>App: Selects Doctor and Chooses Time Slot
    App->>API: POST /api/appointments/book (Slot, Consultation Type: video)
    API->>DB: INSERT appointments (Status: confirmed, Room: HEAL-XXXX)
    DB-->>API: Confirmed (APT-1001)
    API-->>App: Booking Ready
    
    Patient->>App: Joins Call
    Doctor->>App: Joins Call
    App->>API: POST /api/telehealth/generate-agora-token
    API->>Agora: Generate 24h RTC Token for Channel HEAL-XXXX
    Agora-->>API: Encrypted Channel Token
    API-->>App: Tokens Delivered

    Patient->>Doctor: 2-Way HD Video & Live Audio Stream
    Doctor->>App: Inspects AI Pre-Consultation SOAP Notes
    Doctor->>App: Adds Medicines, Dosages & Diagnostic Tests
    Doctor->>App: Digitally Signs and Submits Prescription
    App->>API: PUT /api/appointments/APT-1001/prescription
    API->>DB: INSERT prescriptions and UPDATE health_records
    API-->>Patient: Prescription Displayed + 1-Tap "Order in 15 Mins" Button
```

---

### D. 15-Minute Hyperlocal Dark Store Medicine Dispatch

```mermaid
flowchart LR
    subgraph OrderPlacement["1. Order Placement"]
        Prescription["📄 E-Prescription / Search"] --> StockCheck["🔍 Real-Time Shelf Stock Verification"]
        StockCheck --> Payment["💳 Instant Razorpay / Aarogyasri Cashless"]
    end

    subgraph DarkStoreProcessing["2. Dark Store Processing"]
        Payment --> DarkStoreQueue["🏬 Nearest Verified Dark Store<br/>(3-5 km Radius SLA)"]
        DarkStoreQueue --> PickPack["📦 Pharmacist Picks & Packs Order"]
        PickPack --> RiderAssign["🛵 Delivery Partner Assigned"]
    end

    subgraph LiveNavigation["3. Live GPS Drop"]
        RiderAssign --> MapboxGPS["🗺️ Mapbox GL Live Vector GPS Tracking"]
        MapboxGPS --> Doorstep["🚪 Doorstep Drop in < 15 Mins"]
    end

    style OrderPlacement fill:#EFF6FF,stroke:#3B82F6,stroke-width:1px
    style DarkStoreProcessing fill:#FEF3C7,stroke:#D97706,stroke-width:1px
    style LiveNavigation fill:#DCFCE7,stroke:#16A34A,stroke-width:1px
```

---

### E. ABDM QR Consent & Aarogyasri Health Pass Verification

```mermaid
sequenceDiagram
    autonumber
    actor Patient as 👤 Patient
    actor Doctor as 🩺 Doctor / Hospital Admin
    participant App as 📱 Flutter App
    participant API as 🐘 PHP Backend
    participant DB as 🗄️ MariaDB Database

    Patient->>App: Generates ABDM 15-Minute Dynamic QR Code
    App->>API: POST /api/consent/generate-token
    API->>DB: INSERT qr_consent_tokens (Expiry: NOW + 15 mins)
    DB-->>API: Token Generated
    API-->>App: Displays Secure QR Code

    Doctor->>App: Scans Patient QR Code
    App->>API: POST /api/consent/doctor-scan (Token, Doctor ID)
    API->>DB: Validate Token & Fetch health profiles and records
    DB-->>API: Unlocks Medical History, Allergies, Surgeries and Past Reports
    API-->>Doctor: Complete EHR Timeline Displayed

    Patient->>App: Enter Aarogyasri Pass ID (AROG-TG-44910)
    App->>API: GET /api/aarogyasri/lookup?code=AROG-TG-44910
    API->>DB: Query users, health profiles, user addresses
    DB-->>API: 5 Lakh INR Cashless Balance & Active Eligibility
    API-->>App: Empaneled Hospitals & Cashless Coverage Confirmed
```

---

## 5. State Diagrams & Lifecycle State Machines

### A. Multilingual Clinical AI Triage State Machine

```mermaid
stateDiagram-v2
    [*] --> Idle_Greeting: App Opened / Welcome Screen
    Idle_Greeting --> Stage1_ChiefComplaint: User speaks/types symptoms
    
    state Stage1_ChiefComplaint {
        [*] --> DetectLanguage
        DetectLanguage --> LockLanguage: Telugu / Hindi / English Identified
        LockLanguage --> AskDurationAndChills: 2 Focused Questions
    }

    Stage1_ChiefComplaint --> Stage2_SymptomDetails: Duration provided
    
    state Stage2_SymptomDetails {
        [*] --> RecordSeverity
        RecordSeverity --> AskAssociatedSymptoms: Pain scale, nausea, fever temp
    }

    Stage2_SymptomDetails --> Stage3_HistoryMeds: Severity detailed
    
    state Stage3_HistoryMeds {
        [*] --> CheckPastConditions
        CheckPastConditions --> CheckExistingMedications: Allergies, BP, Diabetes
    }

    Stage3_HistoryMeds --> Stage4_CarePlanAndRx: Intake completed (Turn >= 3)
    
    state Stage4_CarePlanAndRx {
        [*] --> GenerateSOAPSummary
        GenerateSOAPSummary --> RecommendMedicines
        RecommendMedicines --> DisplayActionCards: Match Doctors, Labs & 108 SOS
    }

    Stage4_CarePlanAndRx --> [*]: Care Plan Delivered
```

---

### B. 15-Minute Medicine Order Lifecycle

```mermaid
stateDiagram-v2
    [*] --> OrderCreated: User confirms cart
    OrderCreated --> PaymentVerified: Razorpay / Cashless Confirmed
    PaymentVerified --> StoreAllocated: Geofence matched to nearest dark store (3-5km)
    StoreAllocated --> PackingInProgress: Pharmacist scans & packages items
    PackingInProgress --> RiderAssigned: Delivery partner arrives at dark store
    RiderAssigned --> OutForDelivery: Rider departs with package
    OutForDelivery --> Delivered: Live Mapbox GPS Drop (<15 mins)
    Delivered --> [*]

    OrderCreated --> Cancelled: Payment Failed / Out of Stock
    StoreAllocated --> Cancelled: Store Capacity Exceeded
```

---

### C. Video Teleconsultation State Machine

```mermaid
stateDiagram-v2
    [*] --> SlotBooked: Patient reserves doctor slot
    SlotBooked --> PreConsultationAI: AI Triage notes attached to appointment
    PreConsultationAI --> TokenGenerated: Agora RTC channel token issued
    TokenGenerated --> WaitingRoom: Patient & Doctor enter room
    WaitingRoom --> InConsultation: 2-Way HD Video & Volume Metering active
    InConsultation --> PrescriptionDrafting: Doctor creates E-Prescription
    PrescriptionDrafting --> Completed: Prescription Digitally Signed & Synced
    Completed --> [*]
```

---

## 6. Role-Wise Capabilities & Feature Matrix

```
┌────────────────────────────────────────────────────────────────────────┐
│                        HealthExpress AI Roles                          │
├─────────────────┬─────────────────┬──────────────────┬─────────────────┤
│ 👤 Patient      │ 🩺 Doctor       │ 🏥 Hospital      │ 🏬 Store / Super│
│ • Voice AI      │ • Agora Video   │ • Bed Tracking   │ • 15-Min Order  │
│ • 15-Min Drops  │ • Rx Builder    │ • Admissions     │ • KYC Audit     │
│ • Aarogyasri    │ • ABDM QR Scan  │ • Empanelment    │ • API Health    │
└─────────────────┴─────────────────┴──────────────────┴─────────────────┘
```

| Role | Key Capabilities & Functionalities |
| :--- | :--- |
| **👤 Patient** | • Multilingual voice AI clinical intake in Telugu, Hindi, English.<br>• Search and filter doctors by specialty, distance, fee, and rating.<br>• Book in-clinic or instant Agora HD video consultations.<br>• 15-minute emergency medicine delivery with Mapbox live GPS tracking.<br>• Book home diagnostic lab test collection packages (CBC, Lipid, HbA1c, Dengue, Thyroid).<br>• Verify Aarogyasri health pass & generate ABDM 15-minute QR consent tokens.<br>• 1-tap emergency 108 ambulance dispatch and live hospital bed vacancy tracker. |
| **🩺 Doctor** | • Manage appointment queue (in-clinic, video, home visit).<br>• Review pre-consultation AI-generated SOAP notes and triage summaries.<br>• Conduct encrypted HD video/audio teleconsultations.<br>• Build and digitally sign E-Prescriptions with integrated dosage guidelines.<br>• Scan patient ABDM QR codes to securely access past medical histories and allergies.<br>• Configure weekly consultation schedules, slots, and fees. |
| **🏥 Hospital Admin** | • Real-time bed management: General, ICU, and Emergency Trauma beds.<br>• Manage patient admission, discharge, and emergency transfers.<br>• Maintain hospital department rosters and primary vs visiting doctor affiliations.<br>• Process Aarogyasri cashless pre-authorizations and insurance claims. |
| **🏬 Pharmacy Partner**| • Self-onboarding with Drug License, GST verification, and delivery radius (3–5 km).<br>• Live inventory catalog management with batch numbers, pricing, and stock levels.<br>• Receive instant 15-minute emergency order alerts with fast-pack workflow.<br>• Delivery rider dispatch and Mapbox route synchronization. |
| **👑 Super Admin** | • Platform-wide KPI telemetry: Total active users, doctors, hospitals, and revenue ledger.<br>• Pharmacy dark store drug license review and approval/rejection queue.<br>• Doctor Medical Council registration certificate verification.<br>• Real-time API uptime health monitor and MariaDB connectivity diagnostics. |

---

## 7. Production Relational Database Schema & ER Diagram

```mermaid
erDiagram
    users ||--o{ health_profiles : has
    users ||--o{ user_addresses : resides_at
    users ||--o{ appointments : books
    users ||--o{ qr_consent_tokens : generates
    users ||--o{ health_records : owns
    users ||--o{ tickets : files
    
    hospitals ||--o{ departments : contains
    hospitals ||--o{ doctor_hospitals : employs
    hospitals ||--o{ appointments : hosts
    
    doctors ||--o{ doctor_hospitals : belongs_to
    doctors ||--o{ doctor_schedules : defines
    doctors ||--o{ appointments : conducts
    
    appointments ||--o| prescriptions : produces
    appointments ||--o| payments : settles
    
    users {
        string id PK
        string name
        string phone
        string email
        string role
        string aarogyasri_id
        date dob
        string gender
    }

    health_profiles {
        string user_id PK,FK
        string blood_group
        text allergies
        text chronic_conditions
        text past_surgeries
    }

    hospitals {
        string id PK
        string name
        string hospital_type
        string license_number
        int total_beds
        int icu_beds
        float lat
        float lng
    }

    doctors {
        string id PK
        string user_id FK
        string name
        string specialty
        string registration_number
        float consultation_fee
    }

    appointments {
        string id PK
        string user_id FK
        string doctor_id FK
        string hospital_id FK
        date appointment_date
        string time_slot
        string status
        float fee
    }

    prescriptions {
        string id PK
        string appointment_id FK
        text medicines
        text clinical_notes
        text diagnostic_tests
    }

    medicines {
        string id PK
        string name
        string category
        float price
        int stock_quantity
        boolean requires_prescription
    }
```

### Authoritative MariaDB Tables (`u170253497_healthexpress`):

| # | Table Name | Key Columns | Purpose |
| :---: | :--- | :--- | :--- |
| **1** | `users` | `id`, `name`, `phone`, `email`, `role`, `aarogyasri_id`, `dob`, `gender` | Primary user identity directory and authentication |
| **2** | `health_profiles` | `user_id`, `blood_group`, `allergies`, `chronic_conditions`, `past_surgeries` | Comprehensive EHR vault and clinical history |
| **3** | `user_addresses` | `id`, `user_id`, `address_line1`, `city`, `state`, `pincode`, `latitude`, `longitude` | Geolocation coordinates for 15-minute delivery routing |
| **4** | `hospitals` | `id`, `name`, `hospital_type`, `license_number`, `total_beds`, `icu_beds`, `lat`, `lng` | Empaneled hospital facility registry and GPS coordinates |
| **5** | `departments` | `id`, `hospital_id`, `name`, `description` | Hospital clinical specialty departments |
| **6** | `doctors` | `id`, `user_id`, `name`, `specialty`, `registration_number`, `consultation_fee` | Doctor medical credentials, fee, and verification status |
| **7** | `doctor_hospitals` | `doctor_id`, `hospital_id`, `department_id`, `affiliation_type` | Multi-facility doctor hospital affiliations |
| **8** | `doctor_schedules` | `doctor_id`, `day_of_week`, `start_time`, `end_time`, `slot_duration_minutes` | Weekly recurring consultation availability slots |
| **9** | `appointments` | `id`, `user_id`, `doctor_id`, `hospital_id`, `appointment_date`, `time_slot`, `fee` | Central appointment lifecycle and video room mapping |
| **10** | `prescriptions` | `id`, `appointment_id`, `medicines`, `clinical_notes`, `diagnostic_tests` | Digital signed E-Prescriptions synced to patient cart |
| **11** | `medicines` | `id`, `name`, `category`, `price`, `stock_quantity`, `requires_prescription` | 15-minute pharmacy catalog & live inventory |
| **12** | `qr_consent_tokens` | `id`, `token`, `user_id`, `expires_at`, `status`, `scanned_by` | ABDM 15-minute dynamic consent tokens |
| **13** | `health_records` | `id`, `user_id`, `record_type`, `title`, `file_url`, `created_at` | Encrypted digital medical document vault |
| **14** | `payments` | `id`, `appointment_id`, `razorpay_order_id`, `amount`, `currency`, `status` | Razorpay Live transactions and revenue ledger |
| **15** | `tickets` | `id`, `user_id`, `category`, `subject`, `description`, `status`, `priority` | 24x7 customer support dispute ticketing system |
| **16** | `chat_messages` | `id`, `sender_id`, `receiver_id`, `message`, `is_read`, `created_at` | 2-way doctor-patient encrypted clinical chat |

---

## 8. Complete REST API Endpoint Directory

All endpoints are hosted live on Hostinger at `https://vedvaidyam.com/healthexpress/api`:

| HTTP Method | Route | Description | Status |
| :--- | :--- | :--- | :---: |
| `GET` | `/health` | Live database connectivity & server status check | `200 OK` |
| `GET` | `/hospitals` | Hospital directory with proximity distance calculation | `200 OK` |
| `GET` | `/doctors` | Registered doctors with specialty & hospital affiliation | `200 OK` |
| `GET` | `/pharmacy/medicines` | 15-minute delivery medicine catalog & stock count | `200 OK` |
| `GET` | `/diagnostic/lab-tests` | Diagnostic lab test packages & fasting criteria | `200 OK` |
| `GET` | `/orders/business-products` | Home medical devices & wellness checkup packages | `200 OK` |
| `GET` | `/aarogyasri/lookup` | Real-time Aarogyasri health pass eligibility lookup | `200 OK` |
| `POST` | `/auth/register` | Quick patient registration & Aarogyasri pass generation | `200 OK` |
| `POST` | `/appointments/book` | Real-time slot booking with subsidy calculation | `200 OK` |
| `GET` | `/appointments/user/:id` | Retrieve patient appointment history & statuses | `200 OK` |
| `PUT` | `/appointments/:id/prescription`| Doctor issues digitally signed E-Prescription | `200 OK` |
| `POST` | `/telehealth/generate-agora-token`| Generates 24-hour Agora RTC WebRTC video token | `200 OK` |
| `POST` | `/consent/generate-token`| Generates 15-minute dynamic ABDM QR consent token | `200 OK` |
| `POST` | `/consent/doctor-scan` | Doctor scans QR to unlock patient clinical vault | `200 OK` |
| `POST` | `/ai/triage` | Persist and score AI clinical symptom intake | `200 OK` |
| `GET` | `/ai/sessions/user/:id` | Historical AI triage sessions & clinical SOAP notes | `200 OK` |
| `POST` | `/payments/create-order` | Create Razorpay Live payment order ID | `200 OK` |
| `POST` | `/payments/verify` | Verify Razorpay payment signature (HMAC-SHA256) | `200 OK` |

---

## 9. Technology Stack & Directory Structure

```
healthyxpress_medha/
├── 3D-ILLUS/                     # 🎨 High-resolution 3D asset source files
│   ├── ADMIN-PANAL/              # 3D illustration metrics (1.png - 8.png)
│   ├── illustratuions/           # High-resolution hero assets (health-ai.png)
│   └── user-home-quickactions/   # Patient dashboard action assets (1.png - 7.png)
│
├── ui/                           # 📸 Production screenshots for README & docs
│   ├── admin-1.png               # Hospital bed & ward operations view
│   ├── admin-2.png               # Super admin telemetry & KPI dashboard
│   ├── admin-3.png               # Dark store KYC & verification queue
│   ├── app-ui-1.png              # Patient home dashboard & quick actions
│   ├── app-ui-2.png              # Multilingual voice AI clinical triage
│   ├── app-ui-3.png              # Doctor discovery & appointment booking
│   ├── app-ui-4.png              # 15-minute pharmacy & lab tests catalog
│   └── app-ui-5.png              # ABDM digital health locker & Aarogyasri
│
├── healthexpress/                # 📱 Flutter Web & Mobile Super-App
│   ├── lib/
│   │   ├── core/config/          # Live API URLs, Keys (NVIDIA, Sarvam, Agora, Razorpay)
│   │   ├── core/theme/           # Glassmorphism design tokens & Medical Teal palette
│   │   ├── models/               # Hospital, Doctor, Medicine, Appointment, User models
│   │   ├── providers/            # Riverpod & Provider state managers (AI, Auth, Pharmacy)
│   │   ├── services/             # REST client, Agora WebRTC, Sarvam STT, NVIDIA NIM
│   │   └── screens/              # Patient & Doctor multi-role responsive screens
│   └── web/                      # PWA shell, Mapbox GL JS, Web Audio API VAD, CanvasKit
│
├── admin_panel/                  # 💻 React 19 + Vite Super Admin Dashboard
│   ├── src/
│   │   ├── components/           # MetricCard, Modal, Navbar, Sidebar
│   │   ├── views/                # 12 Operational Workspaces (Beds, Stores, Doctors, etc.)
│   │   └── services/             # Axios REST client for live MariaDB telemetry
│   └── package.json
│
├── php_backend/                  # 🐘 Hostinger Production PHP 8.2+ REST API
│   ├── .htaccess                 # Apache mod_rewrite clean routing
│   ├── index.php                 # Front Controller & 16-route REST dispatcher
│   ├── config/                   # PDO database singleton with connection pooling
│   ├── controllers/              # 15 Specialized Controllers (Ai, Auth, Doctor, etc.)
│   └── database/schema.sql       # 16-table relational MariaDB schema
│
└── deploy.ps1                    # 🚀 Automated dual-deployment build & push script
```

---

## 10. Setup, Local Development & Deployment Guide

### A. Flutter Mobile & Web Super-App
```bash
cd healthexpress

# 1. Install Flutter dependencies
flutter pub get

# 2. Run unit & widget tests
flutter test

# 3. Launch Flutter Web locally on Chrome
flutter run -d chrome
```

### B. React 19 Super Admin Dashboard
```bash
cd admin_panel

# 1. Install NPM packages
npm install

# 2. Launch Vite development server (http://localhost:5173)
npm run dev

# 3. Build optimized production bundle
npm run build
```

### C. Automated Dual Deployment (GitHub Pages)
A single PowerShell script builds both Flutter Web and React Admin, then deploys them simultaneously to GitHub Pages:
```powershell
# Run dual deployment
powershell -ExecutionPolicy Bypass -File .\deploy.ps1
```

---

## 11. Compliance & Clinical Standards

* **ABDM (Ayushman Bharat Digital Mission)**: Complete 15-minute tokenized consent architecture with instant QR EHR unlocks.
* **Aarogyasri Health Scheme**: Native lookup and 100% cashless pre-authorization workflows for empaneled procedures.
* **Zero Plain-Text Credentials**: Environment-based configuration, HMAC-SHA256 payment validation, and parameterized SQL queries.
* **DISHA / HIPAA Ready**: Immutable audit trail logging every administrative and clinical data access event.

---

<div align="center">
  <sub>Implemented with ❤️ using <strong><a href="https://bob.ibm.com/">IBM Bob</a></strong>, <strong>Sarvam AI</strong>, and <strong>NVIDIA NIM</strong>.</sub>
</div>
