import React, { useState } from 'react';
import { Plus, Search, Eye, ShieldCheck, Trash2, CheckCircle, AlertCircle } from 'lucide-react';
import DoctorVerificationModal from '../components/DoctorVerificationModal';

export default function DoctorsView({ doctors, onOpenAddDoctor }) {
  const [searchTerm, setSearchTerm] = useState('');
  const [specialtyFilter, setSpecialtyFilter] = useState('All');
  const [selectedDoctorForVerify, setSelectedDoctorForVerify] = useState(null);

  const defaultDoctors = [
    { id: 'DOC-1024', name: 'Dr. Sandeep Attawar', hospital: 'KIMS Hospitals', specialty: 'Cardiologist', exp: '15+ Years', status: 'Verified', registrationNumber: 'MCI-TS-1999-44812', avatar: 'https://images.unsplash.com/photo-1622253692010-333f2da6031d?auto=format&fit=crop&q=80&w=200' },
    { id: 'DOC-1025', name: 'Dr. Priya Nair', hospital: 'Apollo Hospitals', specialty: 'General Physician', exp: '8+ Years', status: 'Verified', registrationNumber: 'MCI-TS-2011-33219', avatar: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&q=80&w=200' },
    { id: 'DOC-1026', name: 'Dr. Naveen Thota', hospital: 'Yashoda Hospitals', specialty: 'Orthopedic Surgeon', exp: '10+ Years', status: 'Verified', registrationNumber: 'MCI-TS-2008-11290', avatar: 'https://images.unsplash.com/photo-1537368910025-700350fe46c7?auto=format&fit=crop&q=80&w=200' },
    { id: 'DOC-1027', name: 'Dr. Madhavi Latha', hospital: 'CARE Hospitals', specialty: 'Gynecologist', exp: '11+ Years', status: 'Verified', registrationNumber: 'MCI-TS-2005-77341', avatar: 'https://images.unsplash.com/photo-1594824813680-77a83d739824?auto=format&fit=crop&q=80&w=200' },
    { id: 'DOC-1028', name: 'Dr. Suresh RMP', hospital: 'Independent Practice', specialty: 'RMP Doctor (Home Visit)', exp: '14+ Years', status: 'Verified', registrationNumber: 'RMP-TS-2010-9941', avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=200' },
    { id: 'DOC-1029', name: 'Dr. Anil Kumar', hospital: 'Apollo Hospitals', specialty: 'General Physician', exp: '5+ Years', status: 'Pending', registrationNumber: 'MCI-TS-2019-11029', avatar: 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?auto=format&fit=crop&q=80&w=200' },
    { id: 'DOC-1030', name: 'Dr. Kavya S', hospital: 'CARE Hospitals', specialty: 'Pediatrician', exp: '6+ Years', status: 'Pending', registrationNumber: 'MCI-TS-2018-44912', avatar: 'https://images.unsplash.com/photo-1594824813680-77a83d739824?auto=format&fit=crop&q=80&w=200' },
  ];

  const [docList, setDocList] = useState(doctors && doctors.length > 0 ? doctors : defaultDoctors);

  const handleVerified = (docIdentifier, newStatus) => {
    setDocList(docList.map(d => (d.id === docIdentifier || d.name === docIdentifier) ? { ...d, status: newStatus } : d));
  };

  const filtered = docList.filter(d => {
    const matchSearch = d.name.toLowerCase().includes(searchTerm.toLowerCase()) || d.hospital.toLowerCase().includes(searchTerm.toLowerCase());
    const matchSpecialty = specialtyFilter === 'All' || d.specialty === specialtyFilter;
    return matchSearch && matchSpecialty;
  });

  return (
    <div>
      {/* 4 Doctor Summary Stat Cards */}
      <div className="metrics-grid" style={{ marginBottom: 20 }}>
        <div className="metric-card" style={{ padding: '16px' }}>
          <div className="metric-info">
            <h3>Total Registered</h3>
            <div className="metric-value">1,284</div>
          </div>
        </div>
        <div className="metric-card" style={{ padding: '16px' }}>
          <div className="metric-info">
            <h3>Verified Doctors</h3>
            <div className="metric-value" style={{ color: 'var(--success-text)' }}>1,252</div>
          </div>
        </div>
        <div className="metric-card" style={{ padding: '16px' }}>
          <div className="metric-info">
            <h3>Pending KYC Review</h3>
            <div className="metric-value" style={{ color: 'var(--warning-text)' }}>32</div>
          </div>
        </div>
        <div className="metric-card" style={{ padding: '16px' }}>
          <div className="metric-info">
            <h3>Independent Practice</h3>
            <div className="metric-value" style={{ color: 'var(--primary)' }}>240</div>
          </div>
        </div>
      </div>

      <div className="table-card">
        <div className="table-header">
          <div className="table-title">
            <h3>Doctors Directory & Credentialing</h3>
            <p>MCI Council verification and hospital practice affiliations</p>
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
            {filtered.map((d, i) => (
              <tr key={i}>
                <td>
                  <div className="table-user-cell">
                    <img src={d.avatar} className="table-avatar" alt={d.name} />
                    <div>
                      <strong>{d.name}</strong>
                      <div style={{ fontSize: '0.72rem', color: 'var(--text-muted)' }}>
                        {d.registrationNumber || 'MCI-TS-2012-88421'}
                      </div>
                    </div>
                  </div>
                </td>
                <td><strong>{d.specialty}</strong></td>
                <td>
                  <span style={{ fontWeight: d.hospital === 'Independent Practice' ? 600 : 700, color: d.hospital === 'Independent Practice' ? 'var(--text-muted)' : 'var(--text-main)' }}>
                    {d.hospital}
                  </span>
                </td>
                <td>{d.exp}</td>
                <td>
                  <span className={`status-badge ${d.status === 'Verified' ? 'active' : d.status === 'Pending' ? 'pending' : 'inactive'}`}>
                    {d.status === 'Verified' ? '✓ Verified' : d.status === 'Pending' ? '● Pending KYC' : 'Rejected'}
                  </span>
                </td>
                <td>
                  <div className="action-btn-group">
                    <button className="action-btn" title="Verify Credentials" onClick={() => setSelectedDoctorForVerify(d)}>
                      <ShieldCheck size={16} color="var(--primary)" />
                    </button>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      <DoctorVerificationModal
        isOpen={!!selectedDoctorForVerify}
        onClose={() => setSelectedDoctorForVerify(null)}
        doctor={selectedDoctorForVerify}
        onVerified={handleVerified}
      />
    </div>
  );
}
