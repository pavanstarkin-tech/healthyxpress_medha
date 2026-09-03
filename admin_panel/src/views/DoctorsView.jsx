import React, { useState, useEffect } from 'react';
import { Plus, Search, Eye, ShieldCheck, CheckCircle, AlertCircle } from 'lucide-react';
import DoctorVerificationModal from '../components/DoctorVerificationModal';
import { healthApi } from '../services/api';

export default function DoctorsView({ onOpenAddDoctor }) {
  const [searchTerm, setSearchTerm] = useState('');
  const [specialtyFilter, setSpecialtyFilter] = useState('All');
  const [selectedDoctorForVerify, setSelectedDoctorForVerify] = useState(null);
  const [doctors, setDoctors] = useState([]);
  const [loading, setLoading] = useState(true);

  const loadDoctors = async () => {
    try {
      const res = await healthApi.getDoctors();
      const list = res?.data?.data || res?.data || [];
      if (Array.isArray(list)) {
        setDoctors(list.map(d => ({
          id: d.id,
          name: d.name,
          hospital: d.hospital_name || 'Independent Practice',
          specialty: d.specialty || 'General Physician',
          exp: `${d.experience_years || 5}+ Years`,
          registrationNumber: d.registration_number || 'MCI-TS-PENDING',
          status: d.verification_status === 'verified' ? 'Verified' : 'Pending',
          avatar: d.photo_url || 'https://images.unsplash.com/photo-1622253692010-333f2da6031d?auto=format&fit=crop&q=80&w=200',
        })));
      }
    } catch (e) {
      console.warn('Live doctors fetch note:', e);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadDoctors();
  }, []);

  const handleVerified = (docIdentifier, newStatus) => {
    setDoctors(doctors.map(d => (d.id === docIdentifier || d.name === docIdentifier) ? { ...d, status: newStatus } : d));
  };

  const filtered = doctors.filter(d => {
    const matchSearch = d.name.toLowerCase().includes(searchTerm.toLowerCase()) || (d.hospital && d.hospital.toLowerCase().includes(searchTerm.toLowerCase()));
    const matchSpecialty = specialtyFilter === 'All' || d.specialty === specialtyFilter;
    return matchSearch && matchSpecialty;
  });

  const verifiedCount = doctors.filter(d => d.status === 'Verified').length;
  const pendingCount = doctors.filter(d => d.status === 'Pending').length;

  return (
    <div>
      {/* 4 Doctor Summary Stat Cards (Calculated directly from Live MySQL) */}
      <div className="metrics-grid" style={{ marginBottom: 20 }}>
        <div className="metric-card" style={{ padding: '16px' }}>
          <div className="metric-info">
            <h3>Total Registered</h3>
            <div className="metric-value">{doctors.length}</div>
          </div>
        </div>
        <div className="metric-card" style={{ padding: '16px' }}>
          <div className="metric-info">
            <h3>Verified Doctors</h3>
            <div className="metric-value" style={{ color: 'var(--success-text)' }}>{verifiedCount}</div>
          </div>
        </div>
        <div className="metric-card" style={{ padding: '16px' }}>
          <div className="metric-info">
            <h3>Pending KYC Review</h3>
            <div className="metric-value" style={{ color: 'var(--warning-text)' }}>{pendingCount}</div>
          </div>
        </div>
        <div className="metric-card" style={{ padding: '16px' }}>
          <div className="metric-info">
            <h3>Verification Rate</h3>
            <div className="metric-value" style={{ color: 'var(--primary)' }}>
              {doctors.length > 0 ? `${Math.round((verifiedCount / doctors.length) * 100)}%` : '0%'}
            </div>
          </div>
        </div>
      </div>

      <div className="table-card">
        <div className="table-header">
          <div className="table-title">
            <h3>Doctors Directory & Credentialing</h3>
            <p>Live doctors roster from Hostinger MySQL</p>
          </div>

          <div className="table-actions">
            <div className="search-box">
              <Search size={16} />
              <input
                type="text"
                placeholder="Search doctor, hospital..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
              />
            </div>

            <select
              className="filter-select"
              value={specialtyFilter}
              onChange={(e) => setSpecialtyFilter(e.target.value)}
            >
              <option value="All">All Specialties</option>
              <option value="Cardiologist">Cardiologist</option>
              <option value="General Physician">General Physician</option>
              <option value="Orthopedic Surgeon">Orthopedic Surgeon</option>
              <option value="Gynecologist">Gynecologist</option>
              <option value="RMP Doctor (Home Visit)">RMP Doctor (Home Visit)</option>
              <option value="Pediatrician">Pediatrician</option>
            </select>

            <button className="btn-primary" onClick={onOpenAddDoctor}>
              <Plus size={16} /> Add Doctor
            </button>
          </div>
        </div>

        <table className="custom-table">
          <thead>
            <tr>
              <th>Doctor Name</th>
              <th>Specialty</th>
              <th>Hospital Affiliation</th>
              <th>Experience</th>
              <th>Verification Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {filtered.length > 0 ? (
              filtered.map((d, i) => (
                <tr key={d.id || i}>
                  <td>
                    <div className="table-user-cell">
                      <img src={d.avatar} className="table-avatar" alt={d.name} />
                      <div>
                        <strong>{d.name}</strong>
                        <div style={{ fontSize: '0.72rem', color: 'var(--text-muted)' }}>{d.registrationNumber}</div>
                      </div>
                    </div>
                  </td>
                  <td>
                    <span style={{ fontWeight: 600, fontSize: '0.85rem' }}>{d.specialty}</span>
                  </td>
                  <td>
                    <span style={{ fontSize: '0.85rem' }}>{d.hospital}</span>
                  </td>
                  <td>{d.exp}</td>
                  <td>
                    <span className={`status-badge ${d.status === 'Verified' ? 'active' : 'pending'}`}>
                      {d.status}
                    </span>
                  </td>
                  <td>
                    <div className="action-btn-group">
                      <button className="action-btn" title="View Credentials" onClick={() => setSelectedDoctorForVerify(d)}>
                        <Eye size={15} />
                      </button>
                      {d.status === 'Pending' && (
                        <button className="action-btn" title="Approve Verification" onClick={() => handleVerified(d.id, 'Verified')}>
                          <CheckCircle size={15} color="var(--success)" />
                        </button>
                      )}
                    </div>
                  </td>
                </tr>
              ))
            ) : (
              <tr>
                <td colSpan="6" style={{ textAlign: 'center', padding: '32px', color: 'var(--text-muted)' }}>
                  {loading ? 'Loading live doctors from MySQL...' : 'No doctors found in the database.'}
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>

      {/* Doctor Verification Modal */}
      {selectedDoctorForVerify && (
        <DoctorVerificationModal
          isOpen={!!selectedDoctorForVerify}
          onClose={() => setSelectedDoctorForVerify(null)}
          doctor={selectedDoctorForVerify}
          onVerified={handleVerified}
        />
      )}
    </div>
  );
}
