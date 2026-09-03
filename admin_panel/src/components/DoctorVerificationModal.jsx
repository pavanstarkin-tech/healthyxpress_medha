import React, { useState } from 'react';
import { X, ShieldCheck, CheckCircle2, AlertCircle, FileText, Check, Ban } from 'lucide-react';

export default function DoctorVerificationModal({ isOpen, onClose, doctor, onVerified }) {
  const [checklist, setChecklist] = useState({
    identity: true,
    mci: true,
    qualification: true,
    affiliation: true,
  });

  if (!isOpen || !doctor) return null;

  const handleApprove = () => {
    onVerified(doctor.id || doctor.name, 'Verified');
    onClose();
  };

  const handleReject = () => {
    onVerified(doctor.id || doctor.name, 'Rejected');
    onClose();
  };

  return (
    <div className="modal-overlay">
      <div className="modal-content" style={{ width: '620px' }}>
        <div className="modal-header">
          <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
            <ShieldCheck size={26} color="var(--primary)" />
            <div>
              <h3>Doctor Verification Workspace</h3>
              <p style={{ fontSize: '0.78rem', color: 'var(--text-muted)' }}>MCI Registration & Clinical Credentialing</p>
            </div>
          </div>
          <button className="icon-btn" onClick={onClose}>
            <X size={18} />
          </button>
        </div>

        {/* Doctor Identity Header */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 14, padding: '16px', background: 'var(--bg-main)', borderRadius: 'var(--radius-md)', marginBottom: 20 }}>
          <img src={doctor.avatar} alt={doctor.name} style={{ width: 56, height: 56, borderRadius: '50%', objectFit: 'cover' }} />
          <div>
            <h4 style={{ fontSize: '1.1rem', fontWeight: 800 }}>{doctor.name}</h4>
            <p style={{ fontSize: '0.85rem', color: 'var(--text-muted)' }}>
              {doctor.specialty} • {doctor.hospital || 'KIMS Hospitals'}
            </p>
            <div style={{ marginTop: 4, display: 'flex', gap: 8 }}>
              <span className="status-badge" style={{ background: 'var(--primary-light)', color: 'var(--primary)', fontSize: '0.72rem' }}>
                Reg: {doctor.registrationNumber || 'MCI-TS-2012-88421'}
              </span>
              <span className="status-badge" style={{ background: 'var(--success-bg)', color: 'var(--success-text)', fontSize: '0.72rem' }}>
                {doctor.exp}
              </span>
            </div>
          </div>
        </div>

        {/* Verification Checklist */}
        <div style={{ marginBottom: 20 }}>
          <h4 style={{ fontSize: '0.9rem', fontWeight: 800, marginBottom: 10 }}>Credentialing Verification Checklist</h4>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
            <label style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '10px 14px', border: '1px solid var(--border)', borderRadius: 'var(--radius-md)', cursor: 'pointer' }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                <CheckCircle2 size={18} color={checklist.identity ? 'var(--success)' : 'var(--text-muted)'} />
                <span style={{ fontSize: '0.88rem', fontWeight: 600 }}>Government Photo Identity (Aadhaar / Passport)</span>
              </div>
              <input type="checkbox" checked={checklist.identity} onChange={e => setChecklist({ ...checklist, identity: e.target.checked })} />
            </label>

            <label style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '10px 14px', border: '1px solid var(--border)', borderRadius: 'var(--radius-md)', cursor: 'pointer' }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                <CheckCircle2 size={18} color={checklist.mci ? 'var(--success)' : 'var(--text-muted)'} />
                <span style={{ fontSize: '0.88rem', fontWeight: 600 }}>Medical Council of India (MCI) / State Council License</span>
              </div>
              <input type="checkbox" checked={checklist.mci} onChange={e => setChecklist({ ...checklist, mci: e.target.checked })} />
            </label>

            <label style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '10px 14px', border: '1px solid var(--border)', borderRadius: 'var(--radius-md)', cursor: 'pointer' }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                <CheckCircle2 size={18} color={checklist.qualification ? 'var(--success)' : 'var(--text-muted)'} />
                <span style={{ fontSize: '0.88rem', fontWeight: 600 }}>Post-Graduate Degree Certificates (MBBS, MD, DM)</span>
              </div>
              <input type="checkbox" checked={checklist.qualification} onChange={e => setChecklist({ ...checklist, qualification: e.target.checked })} />
            </label>

            <label style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '10px 14px', border: '1px solid var(--border)', borderRadius: 'var(--radius-md)', cursor: 'pointer' }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                <CheckCircle2 size={18} color={checklist.affiliation ? 'var(--success)' : 'var(--text-muted)'} />
                <span style={{ fontSize: '0.88rem', fontWeight: 600 }}>Hospital Head of Department (HOD) Authorization</span>
              </div>
              <input type="checkbox" checked={checklist.affiliation} onChange={e => setChecklist({ ...checklist, affiliation: e.target.checked })} />
            </label>
          </div>
        </div>

        {/* Action Decision */}
        <div className="form-actions" style={{ display: 'flex', justifyContent: 'space-between' }}>
          <button type="button" className="btn-outline" style={{ color: 'var(--error)', borderColor: 'var(--error)' }} onClick={handleReject}>
            <Ban size={15} /> Reject Application
          </button>

          <div style={{ display: 'flex', gap: 10 }}>
            <button type="button" className="btn-outline" onClick={onClose}>
              Request Changes
            </button>
            <button type="button" className="btn-primary" onClick={handleApprove}>
              <Check size={16} /> Approve & Verify Doctor
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
