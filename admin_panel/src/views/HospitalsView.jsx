import React, { useState } from 'react';
import { Plus, Search, Eye, ShieldCheck, Trash2, Building2, MapPin, Phone, Layers, Users, X } from 'lucide-react';
import AddHospitalMultiStepModal from '../components/AddHospitalMultiStepModal';

export default function HospitalsView({ hospitals, onOpenAddHospital }) {
  const [searchTerm, setSearchTerm] = useState('');
  const [isMultiStepOpen, setIsMultiStepOpen] = useState(false);
  const [selectedHospitalDetail, setSelectedHospitalDetail] = useState(null);

  const defaultHospitals = [
    {
      name: 'KIMS Hospitals',
      location: 'Hyderabad, TS',
      address: '1-8-31/1, Minister Rd, Begumpet, Hyderabad',
      type: 'Super Specialty',
      license: 'TS-HYD-HOSP-1995-0012',
      doctors: 120,
      departments: ['Cardiology', 'Neurology', 'Orthopedics', 'Gynecology', 'Pediatrics', 'General Medicine', 'Gastroenterology', 'Urology'],
      beds: '500 (60 ICU)',
      users: '5,230',
      status: 'Active',
      phone: '+91 40 4488 5000'
    },
    {
      name: 'Apollo Hospitals',
      location: 'Hyderabad, TS',
      address: 'Road No 72, Jubilee Hills, Hyderabad',
      type: 'Super Specialty',
      license: 'TS-HYD-HOSP-1988-0005',
      doctors: 98,
      departments: ['Cardiology', 'Oncology', 'Neurology', 'Organ Transplant', 'Robotic Surgery'],
      beds: '700 (90 ICU)',
      users: '4,850',
      status: 'Active',
      phone: '+91 40 2360 7777'
    },
    {
      name: 'Yashoda Hospitals',
      location: 'Secunderabad, TS',
      address: 'Alexander Rd, Secunderabad',
      type: 'Super Specialty',
      license: 'TS-HYD-HOSP-1992-0018',
      doctors: 85,
      departments: ['Neurology', 'Cardiology', 'Nephrology', 'Pulmonology'],
      beds: '500 (50 ICU)',
      users: '3,920',
      status: 'Active',
      phone: '+91 40 4567 4567'
    },
    {
      name: 'CARE Hospitals',
      location: 'Banjara Hills, TS',
      address: 'Road No 1, Banjara Hills, Hyderabad',
      type: 'Multi Specialty',
      license: 'TS-HYD-HOSP-1997-0034',
      doctors: 60,
      departments: ['Cardiology', 'Critical Care', 'Orthopedics', 'General Surgery'],
      beds: '400 (45 ICU)',
      users: '2,150',
      status: 'Active',
      phone: '+91 40 6165 6565'
    },
    {
      name: 'Continental Hospitals',
      location: 'Gachibowli, TS',
      address: 'Financial District, Gachibowli, Hyderabad',
      type: 'Super Specialty',
      license: 'TS-HYD-HOSP-2013-0045',
      doctors: 55,
      departments: ['Cardiology', 'Oncology', 'Gastroenterology'],
      beds: '350 (40 ICU)',
      users: '1,980',
      status: 'Inactive',
      phone: '+91 40 6700 0000'
    },
  ];

  const [hospList, setHospList] = useState(hospitals && hospitals.length > 0 ? hospitals : defaultHospitals);

  const handleHospitalAdded = (newH) => {
    setHospList([newH, ...hospList]);
  };

  const filtered = hospList.filter(h => h.name.toLowerCase().includes(searchTerm.toLowerCase()) || (h.location && h.location.toLowerCase().includes(searchTerm.toLowerCase())));

  return (
    <div>
      {/* 4 Hospital KPI Stats */}
      <div className="metrics-grid" style={{ marginBottom: 20 }}>
        <div className="metric-card" style={{ padding: '16px' }}>
          <div className="metric-info">
            <h3>Registered Facilities</h3>
            <div className="metric-value">184</div>
          </div>
        </div>
        <div className="metric-card" style={{ padding: '16px' }}>
          <div className="metric-info">
            <h3>Active Empaneled</h3>
            <div className="metric-value" style={{ color: 'var(--success-text)' }}>176</div>
          </div>
        </div>
        <div className="metric-card" style={{ padding: '16px' }}>
          <div className="metric-info">
            <h3>Pending Onboarding</h3>
            <div className="metric-value" style={{ color: 'var(--warning-text)' }}>8</div>
          </div>
        </div>
        <div className="metric-card" style={{ padding: '16px' }}>
          <div className="metric-info">
            <h3>Total Network Beds</h3>
            <div className="metric-value" style={{ color: 'var(--primary)' }}>14,200</div>
          </div>
        </div>
      </div>

      <div className="table-card">
        <div className="table-header">
          <div className="table-title">
            <h3>Hospitals & Healthcare Facilities Management</h3>
            <p>Manage hospital empanelment, bed capacity, license compliance, and clinical departments</p>
          </div>

          <div className="table-actions">
            <div className="search-box">
              <Search size={16} />
              <input
                type="text"
                placeholder="Search hospitals..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
              />
            </div>

            <button className="btn-primary" onClick={() => setIsMultiStepOpen(true)}>
              <Plus size={16} /> Empanel Hospital (8-Step)
            </button>
          </div>
        </div>

        <table className="custom-table">
          <thead>
            <tr>
              <th>Hospital Facility</th>
              <th>Location</th>
              <th>Staff Doctors</th>
              <th>Bed Capacity</th>
              <th>Status</th>
              <th>Verification</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {filtered.map((h, i) => (
              <tr key={i}>
                <td>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                    <div style={{ width: 36, height: 36, borderRadius: 8, background: 'var(--primary-light)', display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--primary)' }}>
                      <Building2 size={18} />
                    </div>
                    <div>
                      <strong>{h.name}</strong>
                      <div style={{ fontSize: '0.72rem', color: 'var(--text-muted)' }}>{h.type || 'Super Specialty'}</div>
                    </div>
                  </div>
                </td>
                <td>{h.location}</td>
                <td><strong>{h.doctors}</strong></td>
                <td>{h.beds || '500 Beds'}</td>
                <td>
                  <span className={`status-badge ${h.status === 'Active' ? 'active' : 'inactive'}`}>
                    {h.status}
                  </span>
                </td>
                <td>
                  <span className="status-badge active" style={{ fontSize: '0.72rem' }}>
                    ✓ Verified
                  </span>
                </td>
                <td>
                  <div className="action-btn-group">
                    <button className="action-btn" title="View Facility Details" onClick={() => setSelectedHospitalDetail(h)}>
                      <Eye size={15} />
                    </button>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Multi-Step Onboarding Modal */}
      <AddHospitalMultiStepModal
        isOpen={isMultiStepOpen}
        onClose={() => setIsMultiStepOpen(false)}
        onHospitalAdded={handleHospitalAdded}
      />

      {/* Hospital Detail Drawer Modal */}
      {selectedHospitalDetail && (
        <div className="modal-overlay">
          <div className="modal-content" style={{ width: '640px' }}>
            <div className="modal-header">
              <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                <Building2 size={24} color="var(--primary)" />
                <div>
                  <h3>{selectedHospitalDetail.name}</h3>
                  <p style={{ fontSize: '0.78rem', color: 'var(--text-muted)' }}>License: {selectedHospitalDetail.license || 'TS-HYD-HOSP-2024'}</p>
                </div>
              </div>
              <button className="icon-btn" onClick={() => setSelectedHospitalDetail(null)}>
                <X size={18} />
              </button>
            </div>

            <div style={{ background: 'var(--bg-main)', padding: '16px', borderRadius: 'var(--radius-md)', marginBottom: 20 }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: '0.85rem', marginBottom: 6 }}>
                <MapPin size={16} color="var(--primary)" />
                <span>{selectedHospitalDetail.address || selectedHospitalDetail.location}</span>
              </div>
              <div style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: '0.85rem' }}>
                <Phone size={16} color="var(--primary)" />
                <span>{selectedHospitalDetail.phone || '+91 40 4488 5000'} (24/7 Hotline: 1066)</span>
              </div>
            </div>

            <div>
              <h4 style={{ fontSize: '0.9rem', fontWeight: 800, marginBottom: 10 }}>Empaneled Clinical Departments</h4>
              <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8, marginBottom: 20 }}>
                {(selectedHospitalDetail.departments || ['Cardiology', 'Neurology', 'Orthopedics', 'Pediatrics', 'General Medicine']).map((dept, idx) => (
                  <span key={idx} className="status-badge" style={{ background: 'var(--primary-light)', color: 'var(--primary)', fontWeight: 700, padding: '6px 12px' }}>
                    {dept}
                  </span>
                ))}
              </div>
            </div>

            <div className="form-actions">
              <button className="btn-primary" style={{ width: '100%', justifyContent: 'center' }} onClick={() => setSelectedHospitalDetail(null)}>
                Close Hospital Inspector
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
