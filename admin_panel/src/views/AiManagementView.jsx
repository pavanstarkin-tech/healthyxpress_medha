import React, { useState } from 'react';
import { Sparkles, Plus, AlertTriangle, ShieldCheck, Cpu, Sliders, CheckCircle2 } from 'lucide-react';

export default function AiManagementView() {
  const [rules, setRules] = useState([
    {
      id: 'RULE-01',
      condition: 'Fever + Cough + Body Pain',
      prioritySpecialty: 'General Physician',
      recommendedTests: 'Complete Blood Count (CBC), Dengue NS1',
      recommendedMeds: 'Paracetamol 650mg, Cetirizine 10mg',
      severity: 'Moderate',
      status: 'Active'
    },
    {
      id: 'RULE-02',
      condition: 'Chest Tightness OR Severe Breathlessness',
      prioritySpecialty: 'Cardiologist / Emergency Trauma',
      recommendedTests: 'ECG 12-Lead, Troponin-I, 2D Echo',
      recommendedMeds: 'Emergency SOS Hotline / Ambulance 108',
      severity: 'Emergency',
      status: 'Active'
    },
    {
      id: 'RULE-03',
      condition: 'Joint Swelling + Acute Knee Pain',
      prioritySpecialty: 'Orthopedic Surgeon',
      recommendedTests: 'X-Ray Knee (AP/Lateral), Serum Uric Acid',
      recommendedMeds: 'NSAID / Cold Compress',
      severity: 'Mild',
      status: 'Active'
    }
  ]);

  const [newRule, setNewRule] = useState({
    condition: '',
    prioritySpecialty: 'General Physician',
    recommendedTests: '',
    recommendedMeds: '',
    severity: 'Moderate'
  });

  const [isAdding, setIsAdding] = useState(false);

  const handleAddRule = (e) => {
    e.preventDefault();
    setRules([
      {
        id: `RULE-${Math.floor(10 + Math.random() * 90)}`,
        ...newRule,
        status: 'Active'
      },
      ...rules
    ]);
    setIsAdding(false);
    setNewRule({ condition: '', prioritySpecialty: 'General Physician', recommendedTests: '', recommendedMeds: '', severity: 'Moderate' });
  };

  return (
    <div>
      {/* 4 AI Metric Cards */}
      <div className="metrics-grid">
        <div className="metric-card">
          <div className="metric-info">
            <h3>AI Triage Sessions</h3>
            <div className="metric-value">14,820</div>
            <div className="metric-trend up">↑ 28% this month</div>
          </div>
          <div className="metric-icon-box blue"><Sparkles size={24} /></div>
        </div>

        <div className="metric-card">
          <div className="metric-info">
            <h3>Voice AI Consultations</h3>
            <div className="metric-value">6,240</div>
            <div className="metric-trend up">↑ 42% this month</div>
          </div>
          <div className="metric-icon-box purple"><Cpu size={24} /></div>
        </div>

        <div className="metric-card">
          <div className="metric-info">
            <h3>Emergency Escalations</h3>
            <div className="metric-value">182</div>
            <div className="metric-trend down">Safely Triaged</div>
          </div>
          <div className="metric-icon-box red" style={{ background: 'var(--error-bg)', color: 'var(--error)' }}><AlertTriangle size={24} /></div>
        </div>

        <div className="metric-card">
          <div className="metric-info">
            <h3>Active Clinical Rules</h3>
            <div className="metric-value">{rules.length} Rules</div>
            <div className="metric-trend up">● Operational</div>
          </div>
          <div className="metric-icon-box green"><ShieldCheck size={24} /></div>
        </div>
      </div>

      {/* Visual Rule Builder Card */}
      <div className="table-card" style={{ marginBottom: 24 }}>
        <div className="table-header">
          <div className="table-title">
            <h3>Clinical AI Recommendation Rules Engine</h3>
            <p>Configure dynamic symptom parsing, priority specialties, and emergency escalation protocols</p>
          </div>
          <button className="btn-primary" onClick={() => setIsAdding(!isAdding)}>
            <Plus size={16} /> {isAdding ? 'Close Builder' : 'Create New Rule'}
          </button>
        </div>

        {isAdding && (
          <form onSubmit={handleAddRule} style={{ padding: '20px 24px', background: 'var(--bg-main)', borderBottom: '1px solid var(--border)' }}>
            <h4 style={{ fontSize: '0.95rem', fontWeight: 800, marginBottom: 12 }}>Visual Rule Configuration</h4>
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 14 }}>
              <div className="form-group">
                <label>IF Symptoms Contain (Keywords)</label>
                <input
                  type="text"
                  required
                  placeholder="e.g. Sore Throat + Runny Nose"
                  value={newRule.condition}
                  onChange={e => setNewRule({ ...newRule, condition: e.target.value })}
                />
              </div>

              <div className="form-group">
                <label>THEN Prioritize Doctor Specialty</label>
                <select
                  value={newRule.prioritySpecialty}
                  onChange={e => setNewRule({ ...newRule, prioritySpecialty: e.target.value })}
                >
                  <option>General Physician</option>
                  <option>Cardiologist</option>
                  <option>ENT Specialist</option>
                  <option>Pulmonologist</option>
                  <option>Pediatrician</option>
                  <option>Emergency Trauma / Ambulance</option>
                </select>
              </div>

              <div className="form-group">
                <label>Suggested Diagnostic Lab Tests</label>
                <input
                  type="text"
                  placeholder="e.g. Throat Swab Culture, Rapid Antigen"
                  value={newRule.recommendedTests}
                  onChange={e => setNewRule({ ...newRule, recommendedTests: e.target.value })}
                />
              </div>

              <div className="form-group">
                <label>Suggested Care / Medicine Catalog</label>
                <input
                  type="text"
                  placeholder="e.g. Warm Salt Gargle, Cetirizine 10mg"
                  value={newRule.recommendedMeds}
                  onChange={e => setNewRule({ ...newRule, recommendedMeds: e.target.value })}
                />
              </div>
            </div>

            <div style={{ display: 'flex', justifyContent: 'flex-end', gap: 10, marginTop: 14 }}>
              <button type="button" className="btn-outline" onClick={() => setIsAdding(false)}>Cancel</button>
              <button type="submit" className="btn-primary">Save & Publish AI Rule</button>
            </div>
          </form>
        )}

        <table className="custom-table">
          <thead>
            <tr>
              <th>Rule ID</th>
              <th>Trigger Condition (IF)</th>
              <th>Recommended Action (THEN)</th>
              <th>Diagnostic Tests</th>
              <th>Severity Level</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            {rules.map((r, i) => (
              <tr key={i}>
                <td><strong style={{ color: 'var(--primary)' }}>{r.id}</strong></td>
                <td><strong>{r.condition}</strong></td>
                <td>
                  <span style={{ color: 'var(--primary)', fontWeight: 700 }}>
                    {r.prioritySpecialty}
                  </span>
                </td>
                <td>{r.recommendedTests}</td>
                <td>
                  <span className={`status-badge ${r.severity === 'Emergency' ? 'inactive' : 'confirmed'}`}>
                    {r.severity}
                  </span>
                </td>
                <td><span className="status-badge active">Active</span></td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
