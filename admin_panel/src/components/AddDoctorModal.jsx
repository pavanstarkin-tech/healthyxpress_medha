import React, { useState } from 'react';
import { X, UserRound } from 'lucide-react';

export default function AddDoctorModal({ isOpen, onClose, onDoctorAdded }) {
  const [formData, setFormData] = useState({
    name: '',
    hospital: 'KIMS Hospitals',
    specialty: 'Cardiologist',
    qualifications: 'MBBS, MD',
    experience: '8+ Years',
    registrationNumber: 'MCI-TS-2016-5512',
    clinicFee: 800,
  });

  if (!isOpen) return null;

  const handleSubmit = (e) => {
    e.preventDefault();
    onDoctorAdded({
      ...formData,
      status: 'Active',
      avatar: 'https://images.unsplash.com/photo-1622253692010-333f2da6031d?auto=format&fit=crop&q=80&w=200',
    });
    onClose();
  };

  return (
    <div className="modal-overlay">
      <div className="modal-content">
        <div className="modal-header">
          <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
            <UserRound size={24} color="var(--primary)" />
            <h3>Verify & Add New Doctor</h3>
          </div>
          <button className="icon-btn" onClick={onClose}>
            <X size={18} />
          </button>
        </div>

        <form onSubmit={handleSubmit}>
          <div className="form-group">
            <label>Doctor Full Name *</label>
            <input
              type="text"
              required
              placeholder="e.g. Dr. Anil Kumar"
              value={formData.name}
              onChange={(e) => setFormData({ ...formData, name: e.target.value })}
            />
          </div>

          <div className="form-group">
            <label>Specialty *</label>
            <select
              value={formData.specialty}
              onChange={(e) => setFormData({ ...formData, specialty: e.target.value })}
            >
              <option>Cardiologist</option>
              <option>General Physician</option>
              <option>Orthopedic Surgeon</option>
              <option>Gynecologist</option>
              <option>Neurologist</option>
              <option>Pediatrician</option>
              <option>RMP Doctor (Home Visit)</option>
            </select>
          </div>

          <div className="form-group">
            <label>Primary Hospital Affiliation</label>
            <select
              value={formData.hospital}
              onChange={(e) => setFormData({ ...formData, hospital: e.target.value })}
            >
              <option>KIMS Hospitals</option>
              <option>Apollo Hospitals</option>
              <option>Yashoda Hospitals</option>
              <option>CARE Hospitals</option>
              <option>Independent Practice</option>
            </select>
          </div>

          <div className="form-group">
            <label>MCI / State Council Registration No.</label>
            <input
              type="text"
              required
              value={formData.registrationNumber}
              onChange={(e) => setFormData({ ...formData, registrationNumber: e.target.value })}
            />
          </div>

          <div className="form-actions">
            <button type="button" className="btn-outline" onClick={onClose}>
              Cancel
            </button>
            <button type="submit" className="btn-primary">
              Verify & Approve Doctor
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
