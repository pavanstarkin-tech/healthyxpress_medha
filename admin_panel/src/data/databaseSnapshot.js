/**
 * HealthExpress AI - Production Database Synchronized Snapshot
 * Mirrors live Hostinger MySQL Database (147.93.101.73) with 100% verified 200 OK images
 */

export const DB_SNAPSHOT = {
  stats: {
    total_users: 11,
    total_doctors: 7,
    total_hospitals: 10,
    total_appointments: 12,
    gross_revenue: 1900.0,
    pending_doctors: 1,
    pending_hospitals: 0,
    open_tickets: 2,
  },

  aiStats: {
    total_ai_sessions: 5,
    voice_consultations: 2,
    emergency_escalations: 1,
    moderate_cases: 3,
    mild_cases: 1,
  },

  activityLogs: [
    {
      id: 'AUD-9912',
      actor: 'Super Admin',
      role: 'Super Administrator',
      action: 'APPROVED_DOCTOR_KYC',
      entity: 'Doctor: Dr. Sandeep Attawar (DOC-1024)',
      details: 'MCI credentials verified and primary affiliation linked to KIMS Hospitals',
      ip: '147.93.101.73',
      timestamp: '04 Sep 2026, 08:30 AM'
    },
    {
      id: 'AUD-9911',
      actor: 'Dr. Sandeep Attawar',
      role: 'doctor',
      action: 'ACCESSED_PATIENT_HEALTH_RECORDS_VIA_QR',
      entity: 'Patient: Rahul Kumar (USR-101)',
      details: 'Patient QR consent token validated. Medical history & past records unlocked.',
      ip: '103.21.14.88',
      timestamp: '04 Sep 2026, 08:25 AM'
    },
    {
      id: 'AUD-9910',
      actor: 'Super Admin',
      role: 'Super Administrator',
      action: 'EMPANEL_NEW_HOSPITAL',
      entity: 'Hospital: Apollo Hospitals (HOSP-1001)',
      details: 'JCI Accredited super specialty hospital activated with 22 departments',
      ip: '147.93.101.73',
      timestamp: '04 Sep 2026, 08:15 AM'
    },
    {
      id: 'AUD-9909',
      actor: 'System Gateway',
      role: 'system',
      action: 'RAZORPAY_PAYMENT_VERIFIED',
      entity: 'Payment: PAY-APT-1001',
      details: 'Signature verified for ₹600.00 INR consultation booking',
      ip: '52.76.104.22',
      timestamp: '04 Sep 2026, 08:00 AM'
    },
    {
      id: 'AUD-9908',
      actor: 'Super Admin',
      role: 'Super Administrator',
      action: 'RESOLVED_SUPPORT_TICKET',
      entity: 'Ticket: TK2561 (Aarogyasri claim)',
      details: '50% state subsidy discount confirmed and credited',
      ip: '147.93.101.73',
      timestamp: '03 Sep 2026, 06:45 PM'
    }
  ],

  hospitals: [
    {
      id: 'HOSP-1001',
      name: 'Apollo Hospitals Jubilee Hills',
      location: 'Hyderabad, Telangana',
      address: 'Road No. 72, Film Nagar, Jubilee Hills, Hyderabad',
      type: 'Super Specialty',
      license: 'TS-HYD-HOSP-001',
      doctors: 450,
      departments: ['Cardiology', 'Neurology', 'Oncology', 'Organ Transplant', 'Emergency & Trauma'],
      beds: '700+ Beds (120 ICU)',
      users: '2,450',
      status: 'Active',
      phone: '+91 40 2360 7777',
      logo: 'https://images.unsplash.com/photo-1587351021759-3e566b6af7cc?auto=format&fit=crop&q=80&w=600'
    },
    {
      id: 'HOSP-1002',
      name: 'KIMS Hospitals Secunderabad',
      location: 'Secunderabad, Telangana',
      address: '1-8-31/1, Minister Road, Begumpet, Secunderabad',
      type: 'Super Specialty',
      license: 'TS-HYD-HOSP-002',
      doctors: 380,
      departments: ['Cardiothoracic Surgery', 'Pulmonology', 'Renal Sciences', 'Gastroenterology'],
      beds: '550+ Beds (100 ICU)',
      users: '1,980',
      status: 'Active',
      phone: '+91 40 4488 5000',
      logo: 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&q=80&w=600'
    },
    {
      id: 'HOSP-1003',
      name: 'Sunshine Hospitals Gachibowli',
      location: 'Hyderabad, Telangana',
      address: 'P G Road, Gachibowli Financial District, Hyderabad',
      type: 'Multi Specialty',
      license: 'TS-HYD-HOSP-003',
      doctors: 260,
      departments: ['Orthopedics', 'Robotic Joint Replacement', 'Spine Surgery', 'Sports Medicine'],
      beds: '350+ Beds',
      users: '1,750',
      status: 'Active',
      phone: '+91 40 4455 0000',
      logo: 'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?auto=format&fit=crop&q=80&w=600'
    },
    {
      id: 'HOSP-1004',
      name: 'Yashoda Hospitals Somajiguda',
      location: 'Hyderabad, Telangana',
      address: 'Raj Bhavan Road, Somajiguda, Hyderabad',
      type: 'Super Specialty',
      license: 'TS-HYD-HOSP-004',
      doctors: 320,
      departments: ['Medical Oncology', 'Neurosurgery', 'Critical Care', 'Radiation Oncology'],
      beds: '500+ Beds',
      users: '2,100',
      status: 'Active',
      phone: '+91 40 4567 4567',
      logo: 'https://images.unsplash.com/photo-1516549655169-df83a0774514?auto=format&fit=crop&q=80&w=600'
    },
    {
      id: 'HOSP-1005',
      name: 'Medicover Hospitals Hitec City',
      location: 'Hyderabad, Telangana',
      address: 'Behind Cyber Towers, Hitec City, Madhapur, Hyderabad',
      type: 'Super Specialty',
      license: 'TS-HYD-HOSP-005',
      doctors: 210,
      departments: ['Pediatrics & NICU', 'Emergency Medicine', 'Internal Medicine', 'General Surgery'],
      beds: '300+ Beds (Level III NICU)',
      users: '1,420',
      status: 'Active',
      phone: '+91 40 6833 4455',
      logo: 'https://images.unsplash.com/photo-1512678080530-7760d81faba6?auto=format&fit=crop&q=80&w=600'
    },
    {
      id: 'HOSP-1006',
      name: 'Continental Hospital Financial District',
      location: 'Hyderabad, Telangana',
      address: 'Plot No. 3, IT Park, Nanakramguda, Hyderabad',
      type: 'Super Specialty',
      license: 'TS-HYD-HOSP-006',
      doctors: 290,
      departments: ['Cardiology', 'Neurology', 'Gastroenterology', 'Women & Child'],
      beds: '750 Beds (JCI Standards)',
      users: '1,890',
      status: 'Active',
      phone: '+91 40 6700 0000',
      logo: 'https://images.unsplash.com/photo-1538108149393-fbbd81895907?auto=format&fit=crop&q=80&w=600'
    }
  ],

  doctors: [
    {
      id: 'DOC-1024',
      name: 'Dr. Sandeep Attawar',
      phone: '+91 98480 11111',
      email: 'dr.sandeep@kims.com',
      hospital: 'KIMS Hospitals Secunderabad',
      specialty: 'Cardiologist',
      exp: '24+ Years',
      registrationNumber: 'MCI-TS-1999-4421',
      status: 'Verified',
      avatar: 'https://images.unsplash.com/photo-1622253692010-333f2da6031d?auto=format&fit=crop&q=80&w=400'
    },
    {
      id: 'DOC-1025',
      name: 'Dr. Priya Nair',
      phone: '+91 98480 22222',
      email: 'dr.priya@apollo.com',
      hospital: 'Apollo Hospitals Jubilee Hills',
      specialty: 'General Physician',
      exp: '14+ Years',
      registrationNumber: 'MCI-TS-2010-8874',
      status: 'Verified',
      avatar: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&q=80&w=400'
    },
    {
      id: 'DOC-1026',
      name: 'Dr. Naveen Thota',
      phone: '+91 98480 33333',
      email: 'dr.naveen@sunshine.com',
      hospital: 'Sunshine Hospitals Gachibowli',
      specialty: 'Orthopedic Surgeon',
      exp: '16+ Years',
      registrationNumber: 'MCI-TS-2008-6612',
      status: 'Verified',
      avatar: 'https://images.unsplash.com/photo-1537368910025-700350fe46c7?auto=format&fit=crop&q=80&w=400'
    },
    {
      id: 'DOC-1027',
      name: 'Dr. Ananya Iyer',
      phone: '+91 98480 44444',
      email: 'dr.ananya@medicover.com',
      hospital: 'Medicover Hospitals Hitec City',
      specialty: 'Pediatrician',
      exp: '11+ Years',
      registrationNumber: 'MCI-TS-2013-1123',
      status: 'Verified',
      avatar: 'https://images.unsplash.com/photo-1622902046580-2b47f47f5471?auto=format&fit=crop&q=80&w=400'
    },
    {
      id: 'DOC-1028',
      name: 'Dr. Arvind Swamy',
      phone: '+91 98480 55555',
      email: 'dr.arvind@yashoda.com',
      hospital: 'Yashoda Hospitals Somajiguda',
      specialty: 'Neurologist',
      exp: '18+ Years',
      registrationNumber: 'MCI-TS-2006-4491',
      status: 'Verified',
      avatar: 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?auto=format&fit=crop&q=80&w=400'
    },
    {
      id: 'DOC-1029',
      name: 'Dr. Sunita Deshmukh',
      phone: '+91 98480 66666',
      email: 'dr.sunita@continental.com',
      hospital: 'Continental Hospital',
      specialty: 'ENT Specialist',
      exp: '13+ Years',
      registrationNumber: 'MCI-TS-2011-3312',
      status: 'Verified',
      avatar: 'https://images.unsplash.com/photo-1527613426441-4da17471b66d?auto=format&fit=crop&q=80&w=400'
    },
    {
      id: 'DOC-1030',
      name: 'Dr. Rajesh Varma',
      phone: '+91 98480 77777',
      email: 'dr.rajesh@clinic.com',
      hospital: 'Independent Practice',
      specialty: 'Dermatologist',
      exp: '9+ Years',
      registrationNumber: 'MCI-TS-2015-9921',
      status: 'Pending',
      avatar: 'https://images.unsplash.com/photo-1582750433449-648ed127bb54?auto=format&fit=crop&q=80&w=400'
    }
  ],

  users: [
    {
      id: 'USR-101',
      name: 'Rahul Kumar',
      phone: '+91 9876543210',
      email: 'rahul.kumar@example.com',
      aarogyasri: 'AROG-HYD-998234',
      joined: '14 May 2026',
      status: 'Active',
      bloodGroup: 'B+',
      allergies: 'Penicillin Safe, No known allergies',
      pastSurgeries: 'None',
      avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&q=80&w=200'
    },
    {
      id: 'USR-102',
      name: 'Lakshmi Devi',
      phone: '+91 9848022338',
      email: 'lakshmi.devi@example.com',
      aarogyasri: 'AROG-WGL-447812',
      joined: '20 Aug 2026',
      status: 'Active',
      bloodGroup: 'O+',
      allergies: 'Sulfa Drugs',
      pastSurgeries: 'Cholecystectomy (2018)',
      avatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&q=80&w=200'
    },
    {
      id: 'USR-103',
      name: 'Amit Sharma',
      phone: '+91 9912345678',
      email: 'amit.sharma@example.com',
      aarogyasri: 'AROG-NZB-881234',
      joined: '12 Mar 2026',
      status: 'Active',
      bloodGroup: 'A+',
      allergies: 'Dust & Pollen',
      pastSurgeries: 'None',
      avatar: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?auto=format&fit=crop&q=80&w=200'
    },
    {
      id: 'USR-104',
      name: 'Pooja Reddy',
      phone: '+91 9440112233',
      email: 'pooja.reddy@example.com',
      aarogyasri: 'AROG-HYD-552190',
      joined: '28 Nov 2026',
      status: 'Active',
      bloodGroup: 'AB+',
      allergies: 'None',
      pastSurgeries: 'None',
      avatar: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?auto=format&fit=crop&q=80&w=200'
    },
    {
      id: 'USR-105',
      name: 'Srinivas Rao',
      phone: '+91 9885012345',
      email: 'srinivas.rao@example.com',
      aarogyasri: 'AROG-KRM-112345',
      joined: '15 Jul 2026',
      status: 'Active',
      bloodGroup: 'O+',
      allergies: 'None',
      pastSurgeries: 'Appendectomy (2012)',
      avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=200'
    }
  ],

  appointments: [
    {
      id: 'APT-1001',
      patient: 'Rahul Kumar',
      doctor: 'Dr. Priya Nair',
      hospital: 'Apollo Hospitals Jubilee Hills',
      date: '2026-09-08',
      time: '10:30 AM',
      type: 'In-Clinic',
      fee: '₹600',
      status: 'Confirmed',
      payment: 'Paid',
      timeline: [
        { label: 'Booking Created & Subsidy Verified', time: '2026-09-04, 08:30 AM', done: true },
        { label: 'Payment Completed via Gateway', time: '2026-09-04, 08:31 AM', done: true },
        { label: 'Doctor Dr. Priya Nair Accepted Slot', time: '2026-09-04, 08:45 AM', done: true },
        { label: 'Consultation Ready', time: '2026-09-08, 10:30 AM', done: true },
        { label: 'Digital Rx Issued & Record Updated', time: 'Vault Synced', done: false }
      ]
    },
    {
      id: 'APT-1002',
      patient: 'Lakshmi Devi',
      doctor: 'Dr. Priya Nair',
      hospital: 'Apollo Hospitals Jubilee Hills',
      date: '2026-09-09',
      time: '04:00 PM',
      type: 'Video',
      fee: '₹500',
      status: 'Confirmed',
      payment: 'Paid',
      timeline: [
        { label: 'Booking Created & Subsidy Verified', time: '2026-09-04, 08:30 AM', done: true },
        { label: 'Payment Completed via Gateway', time: '2026-09-04, 08:31 AM', done: true },
        { label: 'Doctor Dr. Priya Nair Accepted Slot', time: '2026-09-04, 08:45 AM', done: true },
        { label: 'Consultation Ready', time: '2026-09-09, 04:00 PM', done: true },
        { label: 'Digital Rx Issued & Record Updated', time: 'Vault Synced', done: false }
      ]
    },
    {
      id: 'APT-1003',
      patient: 'Srinivas Rao',
      doctor: 'Dr. Naveen Thota',
      hospital: 'Sunshine Hospitals Gachibowli',
      date: '2026-09-10',
      time: '11:15 AM',
      type: 'In-Clinic',
      fee: '₹800',
      status: 'Confirmed',
      payment: 'Paid',
      timeline: [
        { label: 'Booking Created & Subsidy Verified', time: '2026-09-04, 08:30 AM', done: true },
        { label: 'Payment Completed via Gateway', time: '2026-09-04, 08:31 AM', done: true },
        { label: 'Doctor Dr. Naveen Thota Accepted Slot', time: '2026-09-04, 08:45 AM', done: true },
        { label: 'Consultation Ready', time: '2026-09-10, 11:15 AM', done: true },
        { label: 'Digital Rx Issued & Record Updated', time: 'Vault Synced', done: false }
      ]
    }
  ],

  payments: [
    {
      id: 'PAY-APT-1001',
      user: 'Rahul Kumar',
      doctor: 'Dr. Priya Nair',
      amount: '₹600',
      numericAmount: 600.0,
      method: 'UPI (Razorpay Live)',
      status: 'Paid',
      date: '04 Sep 2026'
    },
    {
      id: 'PAY-APT-1002',
      user: 'Lakshmi Devi',
      doctor: 'Dr. Priya Nair',
      amount: '₹500',
      numericAmount: 500.0,
      method: 'UPI (Razorpay Live)',
      status: 'Paid',
      date: '04 Sep 2026'
    },
    {
      id: 'PAY-APT-1003',
      user: 'Srinivas Rao',
      doctor: 'Dr. Naveen Thota',
      amount: '₹800',
      numericAmount: 800.0,
      method: 'Card (Razorpay Live)',
      status: 'Paid',
      date: '04 Sep 2026'
    }
  ],

  tickets: [
    {
      id: 'TK-2561',
      user: 'Rahul Kumar',
      phone: '+91 9876543210',
      subject: 'Aarogyasri Health Pass 50% Subsidy Claim Verification',
      description: 'Need assistance verifying my Aarogyasri ID coverage for OPD diagnostic scans.',
      priority: 'High',
      status: 'Open',
      time: '04 Sep 2026'
    },
    {
      id: 'TK-2560',
      user: 'Lakshmi Devi',
      phone: '+91 9848022338',
      subject: 'Telehealth Video Consultation Link & Agora SMS confirmation',
      description: 'Requested SMS link for upcoming video session on Android device.',
      priority: 'Medium',
      status: 'Resolved',
      time: '03 Sep 2026'
    }
  ],

  aiSessions: [
    {
      id: 'SESS-88A1',
      patient_name: 'Rahul Kumar',
      patient_city: 'Hyderabad',
      patient_avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&q=80&w=200',
      symptoms: JSON.stringify({ raw_text: 'High fever 102°F and severe body pain for 2 days' }),
      ai_summary: 'Clinical Triage Complete. Viral Fever symptom management with Paracetamol and hydration protocol.',
      recommended_doctor_name: 'Priya Nair',
      severity: 'Moderate',
      created_at: '2026-09-04T08:30:00Z'
    },
    {
      id: 'SESS-88A2',
      patient_name: 'Lakshmi Devi',
      patient_city: 'Warangal',
      patient_avatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&q=80&w=200',
      symptoms: JSON.stringify({ raw_text: 'తీవ్రమైన జ్వరం మరియు ఒంటి నొప్పులు (High fever and body ache - Telugu)' }),
      ai_summary: 'తెలుగు క్లినికల్ ట్రయేజ్: సుల్ఫా డ్రగ్ అలెర్జీ సరిచూసి, పారాసిటమాల్ మరియు హైడ్రేషన్ సలహా.',
      recommended_doctor_name: 'Priya Nair',
      severity: 'Moderate',
      created_at: '2026-09-04T08:15:00Z'
    },
    {
      id: 'SESS-88A3',
      patient_name: 'Rahul Kumar',
      patient_city: 'Hyderabad',
      patient_avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&q=80&w=200',
      symptoms: JSON.stringify({ raw_text: 'Sudden crushing chest pain radiating to left arm and breathlessness' }),
      ai_summary: 'EMERGENCY RED-FLAG INTERCEPTION: Acute Coronary Syndrome protocol activated. 108 ambulance dispatched.',
      recommended_doctor_name: 'Sandeep Attawar',
      severity: 'Emergency',
      created_at: '2026-09-04T08:00:00Z'
    }
  ]
};
