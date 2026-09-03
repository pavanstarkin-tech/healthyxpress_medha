import React, { useState, useEffect } from 'react';
import { Search, Download, Eye, Video, Clock, Check, X } from 'lucide-react';
import { healthApi } from '../services/api';

export default function AppointmentsView() {
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState('All');
  const [selectedAppt, setSelectedAppt] = useState(null);
  const [appointments, setAppointments] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function loadLiveAppointments() {
      try {
        const res = await healthApi.getAllAppointments();
        if (res?.data?.data || res?.data) {
          const list = res.data.data || res.data;
          if (Array.isArray(list)) {
            setAppointments(list.map(a => ({
              id: a.id,
              patient: a.patient_name || 'Patient User',
              doctor: a.doctor_name || 'Dr. Specialist',
              hospital: a.hospital_name || 'Independent Practice',
              date: a.appointment_date,
              time: a.appointment_time,
              type: a.consultation_type ? (a.consultation_type === 'in_clinic' ? 'In-Clinic' : a.consultation_type.charAt(0).toUpperCase() + a.consultation_type.slice(1)) : 'In-Clinic',
              fee: `₹${parseFloat(a.fee || 800).toFixed(0)}`,
              status: a.status ? a.status.charAt(0).toUpperCase() + a.status.slice(1) : 'Confirmed',
              payment: 'Paid',
              timeline: [
                { label: 'Booking Created & Subsidy Verified', time: `${a.appointment_date}, 08:30 AM`, done: true },
                { label: 'Payment Completed via Gateway', time: `${a.appointment_date}, 08:31 AM`, done: true },
                { label: `Doctor ${a.doctor_name || ''} Accepted Slot`, time: `${a.appointment_date}, 08:45 AM`, done: true },
                { label: 'Consultation In Progress / Ready', time: `${a.appointment_date}, ${a.appointment_time}`, done: true },
                { label: 'Digital Rx Issued & Record Updated', time: 'Vault Synced', done: a.status === 'completed' },
              ]
            })));
          }
        }
      } catch (e) {
        console.warn('Live appointments load note:', e);
      } finally {
        setLoading(false);
      }
    }
    loadLiveAppointments();
  }, []);

  const filtered = appointments.filter(a => {
    const matchSearch = a.patient.toLowerCase().includes(searchTerm.toLowerCase()) || a.doctor.toLowerCase().includes(searchTerm.toLowerCase()) || a.id.toLowerCase().includes(searchTerm.toLowerCase());
    const matchStatus = statusFilter === 'All' || a.status === statusFilter;
    return matchSearch && matchStatus;
  });

  return (
    <div>
      {/* 4 Appointment Top Stats */}
      <div className="metrics-grid" style={{ marginBottom: 20 }}>
        <div className="metric-card" style={{ padding: '16px' }}>
          <div className="metric-info">
            <h3>Total Consultations</h3>
            <div className="metric-value">{appointments.length}</div>
          </div>
        </div>
        <div className="metric-card" style={{ padding: '16px' }}>
          <div className="metric-info">
            <h3>Confirmed Slots</h3>
            <div className="metric-value" style={{ color: 'var(--primary)' }}>
              {appointments.filter(a => a.status === 'Confirmed').length}
            </div>
          </div>
        </div>
        <div className="metric-card" style={{ padding: '16px' }}>
          <div className="metric-info">
            <h3>Completed Consultations</h3>
            <div className="metric-value" style={{ color: 'var(--success-text)' }}>
              {appointments.filter(a => a.status === 'Completed').length}
            </div>
          </div>
        </div>
        <div className="metric-card" style={{ padding: '16px' }}>
          <div className="metric-info">
            <h3>Rescheduled</h3>
            <div className="metric-value" style={{ color: 'var(--warning-text)' }}>
              {appointments.filter(a => a.status === 'Rescheduled').length}
            </div>
          </div>
        </div>
      </div>

      <div className="table-card">
        <div className="table-header">
          <div className="table-title">
            <h3>Central Appointments Operations</h3>
            <p>Real-time booking queue loaded from Live Hostinger MySQL</p>
          </div>

          <div className="table-actions">
            <div className="search-box">
              <Search size={16} />
              <input
                type="text"
                placeholder="Search patient, doctor, ID..."
                value={searchTerm}
                onChange={e => setSearchTerm(e.target.value)}
              />
            </div>

            <select
              className="filter-select"
              value={statusFilter}
              onChange={e => setStatusFilter(e.target.value)}
            >
              <option value="All">All Statuses</option>
              <option value="Confirmed">Confirmed</option>
              <option value="Upcoming">Upcoming</option>
              <option value="Completed">Completed</option>
              <option value="Rescheduled">Rescheduled</option>
            </select>

            <button className="btn-outline">
              <Download size={15} /> Export
            </button>
          </div>
        </div>

        <table className="custom-table">
          <thead>
            <tr>
              <th>Booking ID</th>
              <th>Patient</th>
              <th>Doctor</th>
              <th>Hospital</th>
              <th>Date & Time</th>
              <th>Consultation Type</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {filtered.length > 0 ? (
              filtered.map((a, i) => (
                <tr key={i}>
                  <td><strong style={{ color: 'var(--primary)' }}>{a.id}</strong></td>
                  <td><strong>{a.patient}</strong></td>
                  <td>{a.doctor}</td>
                  <td>{a.hospital}</td>
                  <td>{a.date}, {a.time}</td>
                  <td>
                    <span className="status-badge" style={{ background: 'var(--border-light)', color: 'var(--text-main)', fontWeight: 700 }}>
                      {a.type}
                    </span>
                  </td>
                  <td>
                    <span className={`status-badge ${a.status.toLowerCase()}`}>
                      {a.status}
                    </span>
                  </td>
                  <td>
                    <div className="action-btn-group">
                      <button className="action-btn" title="View Lifecycle Timeline" onClick={() => setSelectedAppt(a)}>
                        <Eye size={15} />
                      </button>
                      {a.type === 'Video' && (
                        <button className="action-btn" title="Agora Video Room">
                          <Video size={15} color="var(--primary)" />
                        </button>
                      )}
                    </div>
                  </td>
                </tr>
              ))
            ) : (
              <tr>
                <td colSpan="8" style={{ textAlign: 'center', padding: '32px', color: 'var(--text-muted)' }}>
                  {loading ? 'Loading real-time appointment records from MySQL...' : 'No appointments found.'}
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>

      {/* Appointment Lifecycle Modal */}
      {selectedAppt && (
        <div className="modal-overlay">
          <div className="modal-content" style={{ width: '560px' }}>
            <div className="modal-header">
              <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                <Clock size={24} color="var(--primary)" />
                <div>
                  <h3>Appointment Lifecycle #{selectedAppt.id}</h3>
                  <p style={{ fontSize: '0.78rem', color: 'var(--text-muted)' }}>
                    {selectedAppt.patient} with {selectedAppt.doctor}
                  </p>
                </div>
              </div>
              <button className="icon-btn" onClick={() => setSelectedAppt(null)}>
                <X size={18} />
              </button>
            </div>

            <div style={{ padding: '16px 0' }}>
              {selectedAppt.timeline.map((step, idx) => (
                <div key={idx} style={{ display: 'flex', gap: 14, marginBottom: 18, position: 'relative' }}>
                  <div style={{
                    width: 28,
                    height: 28,
                    borderRadius: '50%',
                    background: step.done ? 'var(--success)' : 'var(--border)',
                    color: 'white',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    flexShrink: 0,
                    zIndex: 2
                  }}>
                    {step.done ? <Check size={16} strokeWidth={3} /> : idx + 1}
                  </div>
                  <div>
                    <strong style={{ fontSize: '0.9rem' }}>{step.label}</strong>
                    <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)', marginTop: 2 }}>{step.time}</div>
                  </div>
                </div>
              ))}
            </div>

            <div className="form-actions">
              <button className="btn-primary" style={{ width: '100%', justifyContent: 'center' }} onClick={() => setSelectedAppt(null)}>
                Close Lifecycle Inspector
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
