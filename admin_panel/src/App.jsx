import React, { useState, useEffect } from 'react';
import Sidebar from './components/Sidebar';
import Header from './components/Header';
import AddDoctorModal from './components/AddDoctorModal';

// Views
import DashboardView from './views/DashboardView';
import HospitalsView from './views/HospitalsView';
import DoctorsView from './views/DoctorsView';
import UsersView from './views/UsersView';
import AppointmentsView from './views/AppointmentsView';
import PaymentsView from './views/PaymentsView';
import TicketsView from './views/TicketsView';
import AiManagementView from './views/AiManagementView';
import NotificationsView from './views/NotificationsView';
import ReportsView from './views/ReportsView';
import AuditLogsView from './views/AuditLogsView';
import SettingsView from './views/SettingsView';

import { healthApi } from './services/api';

export default function App() {
  const [activeTab, setActiveTab] = useState('dashboard');
  const [isAddDoctorOpen, setIsAddDoctorOpen] = useState(false);

  // Live data states
  const [hospitals, setHospitals] = useState([]);
  const [doctors, setDoctors] = useState([]);

  // Fetch live hospitals and doctors from Node.js / MySQL backend
  useEffect(() => {
    async function loadData() {
      try {
        const [hospRes, docRes] = await Promise.all([
          healthApi.getHospitals().catch(() => null),
          healthApi.getDoctors().catch(() => null),
        ]);

        if (hospRes?.data && hospRes.data.length > 0) {
          setHospitals(hospRes.data.map(h => ({
            name: h.name,
            location: h.location || h.city || 'Hyderabad, TS',
            address: h.address || 'Hyderabad, TS',
            type: h.hospital_type || 'Super Specialty',
            license: h.license_number || 'TS-HYD-HOSP-1995-0012',
            doctors: h.staff_count || 120,
            beds: '500 (60 ICU)',
            departments: ['Cardiology', 'Neurology', 'Orthopedics', 'Gynecology', 'Pediatrics', 'General Medicine'],
            users: (h.reviews_count ? h.reviews_count * 5 : 4500).toLocaleString(),
            status: h.status || 'Active',
            phone: h.primary_phone || '+91 40 4488 5000'
          })));
        }

        if (docRes?.data && docRes.data.length > 0) {
          setDoctors(docRes.data.map(d => ({
            id: d.id,
            name: d.name,
            hospital: d.hospital_name || 'KIMS Hospitals',
            specialty: d.specialty,
            exp: `${d.experience_years || 10}+ Years`,
            registrationNumber: d.registration_number || 'MCI-TS-2012-88421',
            status: d.verification_status || 'Verified',
            avatar: d.photo_url || 'https://images.unsplash.com/photo-1622253692010-333f2da6031d?auto=format&fit=crop&q=80&w=200',
          })));
        }
      } catch (e) {
        console.warn('Backend live loading note:', e);
      }
    }
    loadData();
  }, []);

  const handleDoctorAdded = (newDoc) => {
    setDoctors([newDoc, ...doctors]);
  };

  return (
    <div className="app-container">
      {/* Left Navigation Sidebar */}
      <Sidebar activeTab={activeTab} setActiveTab={setActiveTab} />

      {/* Main Content Area */}
      <div className="main-wrapper">
        <Header activeTab={activeTab} />

        <main className="content-body">
          {activeTab === 'dashboard' && (
            <DashboardView
              onNavigate={setActiveTab}
              onOpenAddHospital={() => setActiveTab('hospitals')}
              onOpenAddDoctor={() => setIsAddDoctorOpen(true)}
            />
          )}

          {activeTab === 'hospitals' && (
            <HospitalsView
              hospitals={hospitals}
            />
          )}

          {activeTab === 'doctors' && (
            <DoctorsView
              doctors={doctors}
              onOpenAddDoctor={() => setIsAddDoctorOpen(true)}
            />
          )}

          {activeTab === 'users' && <UsersView />}

          {activeTab === 'appointments' && <AppointmentsView />}

          {activeTab === 'payments' && <PaymentsView />}

          {activeTab === 'tickets' && <TicketsView />}

          {activeTab === 'ai' && <AiManagementView />}

          {activeTab === 'content' && (
            <div className="chart-card" style={{ padding: '40px 24px' }}>
              <h3 style={{ fontSize: '1.25rem', fontWeight: 800, marginBottom: 8 }}>Content & CMS Center</h3>
              <p style={{ color: 'var(--text-muted)', marginBottom: 20 }}>
                Manage patient health education articles, symptom categories, seasonal outbreak banners, and emergency advisories.
              </p>
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 14 }}>
                <div style={{ padding: '16px', border: '1px solid var(--border)', borderRadius: 'var(--radius-md)' }}>
                  <strong style={{ fontSize: '0.95rem' }}>Seasonal Viral Flu Protocol</strong>
                  <p style={{ fontSize: '0.78rem', color: 'var(--text-muted)', marginTop: 4 }}>Updated 01 Sep 2026 • 24.5k Views</p>
                </div>
                <div style={{ padding: '16px', border: '1px solid var(--border)', borderRadius: 'var(--radius-md)' }}>
                  <strong style={{ fontSize: '0.95rem' }}>Aarogyasri Subsidized Procedures</strong>
                  <p style={{ fontSize: '0.78rem', color: 'var(--text-muted)', marginTop: 4 }}>Updated 28 Aug 2026 • 18.2k Views</p>
                </div>
                <div style={{ padding: '16px', border: '1px solid var(--border)', borderRadius: 'var(--radius-md)' }}>
                  <strong style={{ fontSize: '0.95rem' }}>Doorstep RMP Nursing Guide</strong>
                  <p style={{ fontSize: '0.78rem', color: 'var(--text-muted)', marginTop: 4 }}>Updated 24 Aug 2026 • 12.1k Views</p>
                </div>
              </div>
            </div>
          )}

          {activeTab === 'notifications' && <NotificationsView />}

          {activeTab === 'analytics' && <ReportsView />}

          {activeTab === 'audit' && <AuditLogsView />}

          {activeTab === 'settings' && <SettingsView />}
        </main>
      </div>

      {/* Verify Doctor Modal */}
      <AddDoctorModal
        isOpen={isAddDoctorOpen}
        onClose={() => setIsAddDoctorOpen(false)}
        onDoctorAdded={handleDoctorAdded}
      />
    </div>
  );
}
