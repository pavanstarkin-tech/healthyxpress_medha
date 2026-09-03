import React from 'react';
import { 
  LayoutDashboard, 
  Building2, 
  UserRound, 
  Users, 
  CalendarCheck, 
  CreditCard, 
  LifeBuoy, 
  Sparkles,
  FileText,
  Bell,
  BarChart3, 
  ShieldCheck,
  Settings,
  Activity,
  ChevronRight
} from 'lucide-react';

const NAV_SECTIONS = [
  {
    title: 'OPERATIONS',
    items: [
      { id: 'dashboard', label: 'Dashboard', icon: LayoutDashboard },
      { id: 'hospitals', label: 'Hospitals', icon: Building2, badge: '8' },
      { id: 'doctors', label: 'Doctors', icon: UserRound, badge: '32' },
      { id: 'users', label: 'Users & Patients', icon: Users },
      { id: 'appointments', label: 'Appointments', icon: CalendarCheck },
      { id: 'payments', label: 'Payments & Ledger', icon: CreditCard },
      { id: 'tickets', label: 'Support Tickets', icon: LifeBuoy, badge: '17' },
    ]
  },
  {
    title: 'AI & CONTENT',
    items: [
      { id: 'ai', label: 'AI Configuration', icon: Sparkles },
      { id: 'content', label: 'Content & CMS', icon: FileText },
      { id: 'notifications', label: 'Notifications', icon: Bell },
    ]
  },
  {
    title: 'ANALYTICS & SYSTEM',
    items: [
      { id: 'analytics', label: 'Analytics & Reports', icon: BarChart3 },
      { id: 'audit', label: 'Audit Logs', icon: ShieldCheck },
      { id: 'settings', label: 'System Settings', icon: Settings },
    ]
  }
];

export default function Sidebar({ activeTab, setActiveTab }) {
  return (
    <aside className="sidebar">
      <div className="sidebar-logo">
        <div className="logo-icon">
          <Activity size={22} strokeWidth={2.5} />
        </div>
        <div className="logo-text">
          <h2>HealthExpress</h2>
          <span>Operations Center</span>
        </div>
      </div>

      <nav className="sidebar-nav">
        {NAV_SECTIONS.map((section, sIdx) => (
          <div key={sIdx} style={{ marginBottom: 16 }}>
            <div style={{
              fontSize: '0.7rem',
              fontWeight: 800,
              color: 'var(--text-muted)',
              letterSpacing: '0.8px',
              padding: '0 16px 8px 16px',
              textTransform: 'uppercase'
            }}>
              {section.title}
            </div>

            {section.items.map((item) => {
              const Icon = item.icon;
              const isActive = activeTab === item.id;
              return (
                <button
                  key={item.id}
                  className={`nav-link ${isActive ? 'active' : ''}`}
                  onClick={() => setActiveTab(item.id)}
                >
                  <Icon size={18} strokeWidth={isActive ? 2.5 : 2} />
                  <span style={{ flex: 1, textAlign: 'left' }}>{item.label}</span>
                  {item.badge && (
                    <span style={{
                      fontSize: '0.7rem',
                      fontWeight: 800,
                      padding: '2px 7px',
                      borderRadius: '10px',
                      background: isActive ? 'rgba(255,255,255,0.25)' : 'var(--primary-light)',
                      color: isActive ? 'white' : 'var(--primary)'
                    }}>
                      {item.badge}
                    </span>
                  )}
                </button>
              );
            })}
          </div>
        ))}
      </nav>

      <div className="sidebar-footer">
        <div className="admin-card-mini">
          <img
            src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200"
            alt="Super Admin"
          />
          <div className="admin-mini-info" style={{ flex: 1 }}>
            <h4>Super Admin</h4>
            <p>admin@healthexpress.ai</p>
          </div>
          <ChevronRight size={14} color="var(--text-muted)" />
        </div>
      </div>
    </aside>
  );
}
