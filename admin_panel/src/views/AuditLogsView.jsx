import React, { useState } from 'react';
import { ShieldCheck, Search, Filter, Lock, Clock } from 'lucide-react';

export default function AuditLogsView() {
  const [searchTerm, setSearchTerm] = useState('');

  const logs = [
    {
      id: 'AUD-9912',
      actor: 'Super Admin',
      role: 'Super Administrator',
      action: 'APPROVED_DOCTOR_KYC',
      entity: 'Doctor: Dr. Sandeep Attawar (DOC-1024)',
      details: 'MCI credentials verified and primary affiliation linked to KIMS Hospitals',
      ip: '147.93.101.73',
      timestamp: '03 Sep 2026, 09:20 AM'
    },
    {
      id: 'AUD-9911',
      actor: 'Dr. Sandeep Attawar',
      role: 'doctor',
      action: 'ACCESSED_PATIENT_HEALTH_RECORDS_VIA_QR',
      entity: 'Patient: Rahul Kumar (USR-101)',
      details: 'Patient QR consent token validated. Medical history & past appendectomy unlocked.',
      ip: '103.21.14.88',
      timestamp: '03 Sep 2026, 09:15 AM'
    },
    {
      id: 'AUD-9910',
      actor: 'Super Admin',
      role: 'Super Administrator',
      action: 'EMPANEL_NEW_HOSPITAL',
      entity: 'Hospital: Apollo Hospitals (HOSP-02)',
      details: 'JCI Accredited super specialty hospital activated with 22 departments',
      ip: '147.93.101.73',
      timestamp: '02 Sep 2026, 04:30 PM'
    },
    {
      id: 'AUD-9909',
      actor: 'System Gateway',
      role: 'system',
      action: 'RAZORPAY_PAYMENT_VERIFIED',
      entity: 'Payment: order_TXQBNeSogOwCoQ',
      details: 'Signature verified for ₹800.00 INR consultation booking',
      ip: '52.76.104.22',
      timestamp: '02 Sep 2026, 02:10 PM'
    },
    {
      id: 'AUD-9908',
      actor: 'Super Admin',
      role: 'Super Administrator',
      action: 'RESOLVED_SUPPORT_TICKET',
      entity: 'Ticket: TK2561 (Aarogyasri claim)',
      details: '50% state subsidy discount confirmed and credited',
      ip: '147.93.101.73',
      timestamp: '01 Sep 2026, 11:45 AM'
    },
  ];

  const filtered = logs.filter(l => l.actor.toLowerCase().includes(searchTerm.toLowerCase()) || l.action.toLowerCase().includes(searchTerm.toLowerCase()) || l.entity.toLowerCase().includes(searchTerm.toLowerCase()));

  return (
    <div className="table-card">
      <div className="table-header">
        <div className="table-title">
          <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
            <Lock size={20} color="var(--primary)" />
            <h3>Immutable System & Security Audit Logs</h3>
          </div>
          <p>ABDM Compliance & Clinical Data Access Logs</p>
        </div>

        <div className="table-actions">
          <div className="search-box">
            <Search size={16} />
            <input
              type="text"
              placeholder="Search action, actor, entity..."
              value={searchTerm}
              onChange={e => setSearchTerm(e.target.value)}
            />
          </div>

          <select className="filter-select">
            <option>All Modules</option>
            <option>Doctor Verification</option>
            <option>QR Consent Access</option>
            <option>Payment Gateway</option>
            <option>Hospital Management</option>
          </select>
        </div>
      </div>

      <table className="custom-table">
        <thead>
          <tr>
            <th>Log ID</th>
            <th>Actor & Role</th>
            <th>Action Taken</th>
            <th>Target Entity & Clinical Details</th>
            <th>IP Address</th>
            <th>Timestamp</th>
          </tr>
        </thead>
        <tbody>
          {filtered.map((l, i) => (
            <tr key={i}>
              <td><strong style={{ color: 'var(--primary)' }}>{l.id}</strong></td>
              <td>
                <div>
                  <strong>{l.actor}</strong>
                  <div style={{ fontSize: '0.72rem', color: 'var(--text-muted)' }}>{l.role}</div>
                </div>
              </td>
              <td>
                <span className="status-badge" style={{ background: 'var(--primary-light)', color: 'var(--primary)', fontSize: '0.72rem', fontWeight: 800 }}>
                  {l.action}
                </span>
              </td>
              <td>
                <div style={{ fontWeight: 700 }}>{l.entity}</div>
                <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>{l.details}</div>
              </td>
              <td><code style={{ fontSize: '0.75rem', background: 'var(--bg-main)', padding: '2px 6px', borderRadius: 4 }}>{l.ip}</code></td>
              <td>
                <div style={{ display: 'flex', alignItems: 'center', gap: 6, fontSize: '0.8rem', color: 'var(--text-muted)' }}>
                  <Clock size={13} /> {l.timestamp}
                </div>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
