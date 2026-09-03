import React from 'react';
import { Search, Bell, Moon, ChevronDown } from 'lucide-react';

export default function Header({ activeTab }) {
  const titles = {
    dashboard: { title: 'Dashboard Overview', subtitle: 'Real-time operational health metrics and telemetry' },
    hospitals: { title: 'Hospitals Management', subtitle: 'Manage partner hospital empanelment, beds & departments' },
    doctors: { title: 'Doctors Directory', subtitle: 'MCI Council verification, hospital affiliations and schedules' },
    users: { title: 'Users Management', subtitle: 'Registered patients, Aarogyasri health ID passes & medical vault' },
    bookings: { title: 'Bookings Management', subtitle: 'Consultation requests, video room dispatch & rescheduling' },
    payments: { title: 'Payments & Revenue', subtitle: 'Platform earnings ledger, doctor payouts & Razorpay gateway' },
    tickets: { title: 'Tickets / Support Requests', subtitle: 'Customer support resolution and dispute ticketing' },
    reports: { title: 'Reports & Analytics', subtitle: 'Hospital booking volumes, patient retention and platform growth' },
    promotions: { title: 'Promotions & Campaigns', subtitle: 'Manage healthcare vouchers, Aarogyasri subsidies and campaigns' },
    settings: { title: 'Admin Settings & Security', subtitle: 'System preferences, role permissions and access audit logs' },
  };

  const current = titles[activeTab] || titles.dashboard;

  return (
    <header className="top-header">
      <div className="header-left">
        <h1>{current.title}</h1>
        <p>{current.subtitle}</p>
      </div>

      <div className="header-right">
        <div className="search-box">
          <Search size={17} />
          <input type="text" placeholder="Search anything (ID, name)..." />
        </div>

        <button className="icon-btn" title="Notifications">
          <Bell size={18} />
          <span className="notification-badge"></span>
        </button>

        <button className="icon-btn" title="Theme Toggle">
          <Moon size={18} />
        </button>

        <div className="user-profile-menu">
          <img
            src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200"
            alt="Admin User"
          />
          <span>Admin</span>
          <ChevronDown size={15} color="var(--text-muted)" />
        </div>
      </div>
    </header>
  );
}
