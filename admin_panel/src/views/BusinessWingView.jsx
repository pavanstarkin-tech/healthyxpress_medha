import React, { useState } from 'react';
import { 
  TrendingUp, 
  ShoppingBag, 
  Users, 
  Package, 
  CheckCircle2, 
  Sparkles, 
  ArrowUpRight, 
  Percent, 
  Activity, 
  HeartPulse, 
  Bone, 
  Baby, 
  ShieldCheck, 
  Plus, 
  Search, 
  Flame, 
  Zap, 
  DollarSign, 
  Settings2,
  Stethoscope,
  Filter,
  Layers,
  ArrowRight,
  ChevronRight
} from 'lucide-react';
import MetricCard from '../components/MetricCard';
import { DB_SNAPSHOT } from '../data/databaseSnapshot';

export default function BusinessWingView() {
  const [activeSubTab, setActiveSubTab] = useState('segments'); // 'segments' | 'products' | 'leads' | 'rules'
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedSegment, setSelectedSegment] = useState('ALL');
  const [promoCode, setPromoCode] = useState('HEALTHEXPRESS20');
  const [maxProducts, setMaxProducts] = useState('2');
  const [inChatEnabled, setInChatEnabled] = useState(true);

  // Live state seeded from DB_SNAPSHOT
  const products = DB_SNAPSHOT.businessProducts || [];
  const leads = DB_SNAPSHOT.userLeadSegments || [];
  const stats = DB_SNAPSHOT.businessStats || {
    total_leads_generated: 1240,
    active_monetized_users: 856,
    total_gmv: 342800.0,
    total_commission: 68560.0,
    overall_conversion_rate: 19.4,
    avg_order_value: 1280.0,
    top_converting_product: 'HealthExpress Smart Glucometer Kit'
  };
  const segmentBreakdown = DB_SNAPSHOT.segmentBreakdown || [];

  // Filtered leads
  const filteredLeads = leads.filter(l => {
    const matchesSearch = l.userName.toLowerCase().includes(searchTerm.toLowerCase()) ||
      l.primarySegment.toLowerCase().includes(searchTerm.toLowerCase()) ||
      l.detectedProblems.some(p => p.toLowerCase().includes(searchTerm.toLowerCase()));
    const matchesSegment = selectedSegment === 'ALL' || l.primarySegment === selectedSegment;
    return matchesSearch && matchesSegment;
  });

  // Filtered products
  const filteredProducts = products.filter(p => {
    const matchesSearch = p.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
      p.category.toLowerCase().includes(searchTerm.toLowerCase()) ||
      p.targetConditions.some(c => c.toLowerCase().includes(searchTerm.toLowerCase()));
    const matchesSegment = selectedSegment === 'ALL' || p.targetSegments.some(s => s === selectedSegment);
    return matchesSearch && matchesSegment;
  });

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 24 }}>
      {/* Hero Monetization Banner */}
      <div style={{
        background: 'linear-gradient(135deg, #0F172A 0%, #1E3A8A 50%, #0D9488 100%)',
        borderRadius: 16,
        padding: '28px 32px',
        color: 'white',
        boxShadow: '0 10px 25px rgba(15, 23, 42, 0.15)',
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
        flexWrap: 'wrap',
        gap: 20
      }}>
        <div style={{ maxWidth: 620 }}>
          <div style={{
            display: 'inline-flex',
            alignItems: 'center',
            gap: 6,
            padding: '4px 12px',
            background: 'rgba(255, 255, 255, 0.15)',
            backdropFilter: 'blur(8px)',
            borderRadius: 20,
            fontSize: '0.75rem',
            fontWeight: 800,
            marginBottom: 10,
            border: '1px solid rgba(255, 255, 255, 0.25)',
            letterSpacing: '0.4px',
            textTransform: 'uppercase'
          }}>
            <Sparkles size={13} color="#FACC15" /> AI Problem-to-Product Recommendation Wing
          </div>
          <h2 style={{ fontSize: '1.7rem', fontWeight: 900, letterSpacing: '-0.5px', marginBottom: 8 }}>
            AI Business & Lead Monetization
          </h2>
          <p style={{ fontSize: '0.9rem', color: '#E2E8F0', lineHeight: 1.5 }}>
            Sarvam AI segregates patient inquiries into 7 high-intent health interest segments and contextually recommends HealthExpress diagnostic packages, monitoring devices, and care passes in real-time.
          </p>
        </div>

        <div style={{ display: 'flex', gap: 12, alignItems: 'center' }}>
          <button 
            onClick={() => setActiveSubTab('rules')}
            style={{
              padding: '10px 18px',
              background: 'rgba(255, 255, 255, 0.12)',
              border: '1px solid rgba(255, 255, 255, 0.25)',
              borderRadius: 10,
              color: 'white',
              fontSize: '0.85rem',
              fontWeight: 700,
              display: 'flex',
              alignItems: 'center',
              gap: 8,
              cursor: 'pointer'
            }}
          >
            <Settings2 size={16} /> Recommendation Rules
          </button>
          <button 
            onClick={() => setActiveSubTab('products')}
            style={{
              padding: '10px 20px',
              background: '#10B981',
              border: 'none',
              borderRadius: 10,
              color: 'white',
              fontSize: '0.85rem',
              fontWeight: 800,
              display: 'flex',
              alignItems: 'center',
              gap: 8,
              cursor: 'pointer',
              boxShadow: '0 4px 14px rgba(16, 185, 129, 0.4)'
            }}
          >
            <ShoppingBag size={16} /> View Products ({products.length})
          </button>
        </div>
      </div>

      {/* 4 Standard Top KPI Metric Cards */}
      <div className="metrics-grid">
        <MetricCard
          title="Gross Merchandise Value"
          value={`₹${stats.total_gmv.toLocaleString('en-IN')}`}
          change="34.8% MoM Growth"
          icon={DollarSign}
          color="green"
        />
        <MetricCard
          title="AI Qualified Leads"
          value={stats.total_leads_generated.toLocaleString('en-IN')}
          change={`${stats.active_monetized_users} Active Intent`}
          icon={Users}
          color="blue"
        />
        <MetricCard
          title="AI Conversion Rate"
          value={`${stats.overall_conversion_rate}%`}
          change="4.6x Industry Avg"
          icon={Zap}
          color="orange"
        />
        <MetricCard
          title="Average Order Value"
          value={`₹${stats.avg_order_value.toLocaleString('en-IN')}`}
          change={stats.top_converting_product.split(' ')[2] || 'High Margin'}
          icon={TrendingUp}
          color="blue"
        />
      </div>

      {/* Navigation Sub-Tabs Bar */}
      <div style={{
        display: 'flex',
        gap: 10,
        background: 'var(--card-bg)',
        padding: '8px',
        borderRadius: 12,
        border: '1px solid var(--border)',
        boxShadow: 'var(--shadow-sm)'
      }}>
        <button
          onClick={() => setActiveSubTab('segments')}
          style={{
            flex: 1,
            padding: '10px 16px',
            fontSize: '0.85rem',
            fontWeight: 800,
            borderRadius: 8,
            border: 'none',
            color: activeSubTab === 'segments' ? '#FFFFFF' : 'var(--text-muted)',
            background: activeSubTab === 'segments' ? 'var(--primary)' : 'transparent',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            gap: 8,
            cursor: 'pointer',
            transition: 'all 0.2s'
          }}
        >
          <Activity size={16} /> User Interest Segmentation ({leads.length})
        </button>

        <button
          onClick={() => setActiveSubTab('products')}
          style={{
            flex: 1,
            padding: '10px 16px',
            fontSize: '0.85rem',
            fontWeight: 800,
            borderRadius: 8,
            border: 'none',
            color: activeSubTab === 'products' ? '#FFFFFF' : 'var(--text-muted)',
            background: activeSubTab === 'products' ? 'var(--primary)' : 'transparent',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            gap: 8,
            cursor: 'pointer',
            transition: 'all 0.2s'
          }}
        >
          <Package size={16} /> Products & Packages Catalog ({products.length})
        </button>

        <button
          onClick={() => setActiveSubTab('leads')}
          style={{
            flex: 1,
            padding: '10px 16px',
            fontSize: '0.85rem',
            fontWeight: 800,
            borderRadius: 8,
            border: 'none',
            color: activeSubTab === 'leads' ? '#FFFFFF' : 'var(--text-muted)',
            background: activeSubTab === 'leads' ? 'var(--primary)' : 'transparent',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            gap: 8,
            cursor: 'pointer',
            transition: 'all 0.2s'
          }}
        >
          <Flame size={16} /> Live AI Lead Conversion Stream
        </button>

        <button
          onClick={() => setActiveSubTab('rules')}
          style={{
            flex: 1,
            padding: '10px 16px',
            fontSize: '0.85rem',
            fontWeight: 800,
            borderRadius: 8,
            border: 'none',
            color: activeSubTab === 'rules' ? '#FFFFFF' : 'var(--text-muted)',
            background: activeSubTab === 'rules' ? 'var(--primary)' : 'transparent',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            gap: 8,
            cursor: 'pointer',
            transition: 'all 0.2s'
          }}
        >
          <Settings2 size={16} /> AI Monetization Rules
        </button>
      </div>

      {/* SUB-TAB 1: USER SEGMENTATION MATRIX */}
      {activeSubTab === 'segments' && (
        <div style={{ display: 'flex', flexDirection: 'column', gap: 20 }}>
          {/* Segment Breakdown Category Cards */}
          <div className="chart-card" style={{ padding: 22 }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 16 }}>
              <div>
                <h3 style={{ fontSize: '1.05rem', fontWeight: 800, color: 'var(--text-main)' }}>
                  Therapeutic Problem Breakdown & Lead Volume
                </h3>
                <p style={{ fontSize: '0.8rem', color: 'var(--text-muted)' }}>
                  Click any segment card to filter patient leads and targeted catalog offerings.
                </p>
              </div>
              {selectedSegment !== 'ALL' && (
                <button
                  onClick={() => setSelectedSegment('ALL')}
                  style={{
                    padding: '6px 14px',
                    borderRadius: 8,
                    background: 'var(--primary-light)',
                    color: 'var(--primary)',
                    fontSize: '0.8rem',
                    fontWeight: 700,
                    cursor: 'pointer'
                  }}
                >
                  Show All Segments
                </button>
              )}
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))', gap: 14 }}>
              {segmentBreakdown.map((seg, idx) => {
                const isSelected = selectedSegment === seg.segment;
                return (
                  <div 
                    key={idx}
                    onClick={() => setSelectedSegment(isSelected ? 'ALL' : seg.segment)}
                    style={{
                      padding: 16,
                      borderRadius: 12,
                      border: isSelected ? `2px solid ${seg.color}` : '1px solid var(--border)',
                      background: isSelected ? `${seg.color}15` : 'var(--bg-main)',
                      cursor: 'pointer',
                      transition: 'all 0.2s',
                      display: 'flex',
                      flexDirection: 'column',
                      gap: 10
                    }}
                  >
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                      <span style={{ fontSize: '0.82rem', fontWeight: 800, color: seg.color }}>{seg.segment}</span>
                      <span style={{ fontSize: '0.9rem', fontWeight: 900, color: 'var(--text-main)' }}>{seg.percent}%</span>
                    </div>

                    <div style={{ height: 6, width: '100%', background: 'var(--border)', borderRadius: 3, overflow: 'hidden' }}>
                      <div style={{ height: '100%', width: `${seg.percent}%`, background: seg.color, borderRadius: 3 }} />
                    </div>

                    <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '0.75rem', color: 'var(--text-muted)' }}>
                      <span><strong>{seg.count}</strong> Leads</span>
                      <span style={{ color: '#10B981', fontWeight: 700 }}>High Intent</span>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>

          {/* User Segmented Leads Table */}
          <div className="table-card">
            <div className="table-header" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', flexWrap: 'wrap', gap: 12 }}>
              <div>
                <h3 style={{ fontSize: '1.05rem', fontWeight: 800, color: 'var(--text-main)' }}>
                  Segmented Patients & AI Recommended Products ({filteredLeads.length})
                </h3>
                <p style={{ fontSize: '0.8rem', color: 'var(--text-muted)' }}>
                  Real-time matching based on symptom triage, vitals, chronic conditions & language questions.
                </p>
              </div>

              <div style={{ position: 'relative' }}>
                <Search size={15} color="var(--text-muted)" style={{ position: 'absolute', left: 10, top: 10 }} />
                <input
                  type="text"
                  placeholder="Search patient, problem..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  style={{
                    padding: '8px 12px 8px 32px',
                    borderRadius: 8,
                    border: '1px solid var(--border)',
                    fontSize: '0.85rem',
                    background: 'var(--bg-main)',
                    width: 240
                  }}
                />
              </div>
            </div>

            <div className="table-container">
              <table>
                <thead>
                  <tr>
                    <th>PATIENT</th>
                    <th>DETECTED HEALTH PROBLEMS</th>
                    <th>PRIMARY SEGMENT</th>
                    <th>AI RECOMMENDED PRODUCT</th>
                    <th>AFFINITY</th>
                    <th>LEAD STAGE</th>
                    <th>ORDER VALUE</th>
                    <th>LAST AI TOUCH</th>
                  </tr>
                </thead>
                <tbody>
                  {filteredLeads.map((lead) => (
                    <tr key={lead.id}>
                      <td>
                        <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                          <img
                            src={lead.userAvatar}
                            alt={lead.userName}
                            style={{ width: 38, height: 38, borderRadius: '50%', objectFit: 'cover' }}
                          />
                          <div>
                            <strong style={{ display: 'block', fontSize: '0.88rem' }}>{lead.userName}</strong>
                            <span style={{ fontSize: '0.72rem', color: 'var(--text-muted)' }}>{lead.userCity} • {lead.userId}</span>
                          </div>
                        </div>
                      </td>
                      <td>
                        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 4 }}>
                          {lead.detectedProblems.map((prob, pIdx) => (
                            <span
                              key={pIdx}
                              style={{
                                padding: '3px 8px',
                                background: '#F1F5F9',
                                color: '#334155',
                                borderRadius: 6,
                                fontSize: '0.72rem',
                                fontWeight: 600
                              }}
                            >
                              {prob}
                            </span>
                          ))}
                        </div>
                      </td>
                      <td>
                        <span style={{
                          padding: '4px 10px',
                          borderRadius: 6,
                          fontSize: '0.75rem',
                          fontWeight: 700,
                          background: lead.primarySegment.includes('Diabetes') ? '#EFF6FF' :
                            lead.primarySegment.includes('Cardiac') ? '#FEE2E2' :
                            lead.primarySegment.includes('Ortho') ? '#FEF3C7' : '#F3E8FF',
                          color: lead.primarySegment.includes('Diabetes') ? '#1E60F6' :
                            lead.primarySegment.includes('Cardiac') ? '#EF4444' :
                            lead.primarySegment.includes('Ortho') ? '#D97706' : '#7C3AED',
                        }}>
                          {lead.primarySegment}
                        </span>
                      </td>
                      <td>
                        <div style={{ maxWidth: 220 }}>
                          <strong style={{ fontSize: '0.82rem', color: 'var(--text-main)', display: 'block' }}>
                            {lead.recommendedProduct}
                          </strong>
                          <span style={{ fontSize: '0.7rem', color: 'var(--text-muted)' }}>
                            Trigger: {lead.aiTrigger}
                          </span>
                        </div>
                      </td>
                      <td>
                        <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
                          <div style={{ width: 44, height: 6, background: '#E2E8F0', borderRadius: 3, overflow: 'hidden' }}>
                            <div style={{ width: `${lead.affinityScore}%`, height: '100%', background: '#10B981' }} />
                          </div>
                          <span style={{ fontSize: '0.78rem', fontWeight: 800, color: '#10B981' }}>{lead.affinityScore}%</span>
                        </div>
                      </td>
                      <td>
                        <span style={{
                          padding: '4px 8px',
                          borderRadius: 6,
                          fontSize: '0.72rem',
                          fontWeight: 700,
                          background: lead.leadStage === 'Purchased' ? '#DCFCE7' : lead.leadStage === 'High Intent' ? '#FEF3C7' : '#F1F5F9',
                          color: lead.leadStage === 'Purchased' ? '#166534' : lead.leadStage === 'High Intent' ? '#92400E' : '#475569',
                          display: 'inline-flex',
                          alignItems: 'center',
                          gap: 4
                        }}>
                          {lead.leadStage === 'Purchased' && <CheckCircle2 size={12} />}
                          {lead.leadStage}
                        </span>
                      </td>
                      <td>
                        <strong style={{ fontSize: '0.88rem', color: 'var(--text-main)' }}>
                          ₹{lead.orderValue.toLocaleString('en-IN')}
                        </strong>
                      </td>
                      <td style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>
                        {lead.lastInteraction}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      )}

      {/* SUB-TAB 2: PRODUCTS & PACKAGES CATALOG */}
      {activeSubTab === 'products' && (
        <div style={{ display: 'flex', flexDirection: 'column', gap: 20 }}>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(320px, 1fr))', gap: 20 }}>
            {filteredProducts.map((product) => (
              <div
                key={product.id}
                className="chart-card"
                style={{
                  padding: 0,
                  overflow: 'hidden',
                  display: 'flex',
                  flexDirection: 'column',
                  border: '1px solid var(--border)',
                  borderRadius: 14
                }}
              >
                <div style={{ position: 'relative', height: 160, background: '#F8FAFC' }}>
                  <img
                    src={product.imageUrl}
                    alt={product.title}
                    style={{ width: '100%', height: '100%', objectFit: 'cover' }}
                  />
                  <span style={{
                    position: 'absolute',
                    top: 12,
                    left: 12,
                    padding: '4px 10px',
                    borderRadius: 20,
                    background: 'rgba(15, 23, 42, 0.85)',
                    backdropFilter: 'blur(4px)',
                    color: 'white',
                    fontSize: '0.72rem',
                    fontWeight: 800,
                    textTransform: 'uppercase',
                    letterSpacing: '0.5px'
                  }}>
                    {product.badge}
                  </span>
                  <span style={{
                    position: 'absolute',
                    top: 12,
                    right: 12,
                    padding: '4px 8px',
                    borderRadius: 6,
                    background: '#10B981',
                    color: 'white',
                    fontSize: '0.72rem',
                    fontWeight: 800
                  }}>
                    {product.discountPercent}% OFF
                  </span>
                </div>

                <div style={{ padding: 18, display: 'flex', flexDirection: 'column', flex: 1 }}>
                  <div style={{ fontSize: '0.75rem', fontWeight: 800, color: 'var(--primary)', textTransform: 'uppercase', marginBottom: 4 }}>
                    {product.category}
                  </div>
                  <h4 style={{ fontSize: '1rem', fontWeight: 800, color: 'var(--text-main)', marginBottom: 8, lineHeight: 1.3 }}>
                    {product.title}
                  </h4>

                  {/* Target Conditions Tags */}
                  <div style={{ display: 'flex', flexWrap: 'wrap', gap: 4, marginBottom: 14 }}>
                    {product.targetConditions.slice(0, 3).map((cond, cIdx) => (
                      <span
                        key={cIdx}
                        style={{
                          padding: '2px 6px',
                          background: '#EFF6FF',
                          color: '#1E60F6',
                          borderRadius: 4,
                          fontSize: '0.7rem',
                          fontWeight: 600
                        }}
                      >
                        {cond}
                      </span>
                    ))}
                  </div>

                  {/* Pricing and Revenue Stats */}
                  <div style={{ marginTop: 'auto', paddingTop: 12, borderTop: '1px solid var(--border-light)' }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 8 }}>
                      <div>
                        <span style={{ fontSize: '1.25rem', fontWeight: 900, color: 'var(--text-main)' }}>
                          ₹{product.price.toLocaleString('en-IN')}
                        </span>
                        <span style={{ fontSize: '0.85rem', color: 'var(--text-muted)', textDecoration: 'line-through', marginLeft: 6 }}>
                          ₹{product.originalPrice.toLocaleString('en-IN')}
                        </span>
                      </div>
                      <span style={{ fontSize: '0.78rem', fontWeight: 700, color: '#10B981' }}>
                        {product.marginPercent}% Profit Margin
                      </span>
                    </div>

                    <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '0.75rem', color: 'var(--text-muted)' }}>
                      <span><strong>{product.salesCount}</strong> units sold</span>
                      <span><strong>₹{product.revenueGenerated.toLocaleString('en-IN')}</strong> GMV</span>
                      <span>Conv: <strong>{product.conversionRate}</strong></span>
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* SUB-TAB 3: LIVE AI LEAD STREAM */}
      {activeSubTab === 'leads' && (
        <div className="chart-card" style={{ padding: 22 }}>
          <h3 style={{ fontSize: '1.05rem', fontWeight: 800, marginBottom: 16, color: 'var(--text-main)' }}>
            Real-Time AI Problem Detection & Commercial Suggestion Stream
          </h3>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
            {leads.map((lead, idx) => (
              <div
                key={idx}
                style={{
                  padding: 16,
                  borderRadius: 12,
                  background: 'var(--bg-main)',
                  border: '1px solid var(--border)',
                  display: 'flex',
                  justifyContent: 'space-between',
                  alignItems: 'center',
                  flexWrap: 'wrap',
                  gap: 14
                }}
              >
                <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
                  <img
                    src={lead.userAvatar}
                    alt={lead.userName}
                    style={{ width: 44, height: 44, borderRadius: '50%', objectFit: 'cover' }}
                  />
                  <div>
                    <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                      <strong style={{ fontSize: '0.92rem' }}>{lead.userName}</strong>
                      <span style={{ fontSize: '0.72rem', padding: '2px 6px', background: '#DCFCE7', color: '#166534', borderRadius: 4, fontWeight: 700 }}>
                        {lead.leadStage}
                      </span>
                    </div>
                    <p style={{ fontSize: '0.82rem', color: 'var(--text-muted)', marginTop: 2 }}>
                      💬 <em>"{lead.aiTrigger}"</em>
                    </p>
                  </div>
                </div>

                <div style={{ textAlign: 'right' }}>
                  <span style={{ fontSize: '0.75rem', color: 'var(--primary)', fontWeight: 800, display: 'block' }}>
                    → {lead.recommendedProduct}
                  </span>
                  <span style={{ fontSize: '0.88rem', fontWeight: 900, color: 'var(--text-main)' }}>
                    ₹{lead.orderValue} • {lead.lastInteraction}
                  </span>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* SUB-TAB 4: MONETIZATION & RECOMMENDATION RULES */}
      {activeSubTab === 'rules' && (
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(360px, 1fr))', gap: 20 }}>
          <div className="chart-card" style={{ padding: 22 }}>
            <h3 style={{ fontSize: '1.05rem', fontWeight: 800, marginBottom: 14 }}>
              🎯 AI Product Suggestion Guardrails
            </h3>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '12px 0', borderBottom: '1px solid var(--border-light)' }}>
                <div>
                  <strong style={{ fontSize: '0.88rem', display: 'block' }}>Automated In-Chat Product Cards</strong>
                  <span style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>Display complementary care products during triage</span>
                </div>
                <input 
                  type="checkbox" 
                  checked={inChatEnabled} 
                  onChange={(e) => setInChatEnabled(e.target.checked)} 
                  style={{ width: 18, height: 18, accentColor: 'var(--primary)' }} 
                />
              </div>

              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '12px 0', borderBottom: '1px solid var(--border-light)' }}>
                <div>
                  <strong style={{ fontSize: '0.88rem', display: 'block' }}>Red-Flag Emergency Suppression</strong>
                  <span style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>Strictly hide commercial products during acute cardiac/stroke</span>
                </div>
                <span style={{ padding: '2px 8px', background: '#DCFCE7', color: '#166534', borderRadius: 4, fontSize: '0.72rem', fontWeight: 800 }}>
                  ACTIVE (LOCKED)
                </span>
              </div>

              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '12px 0', borderBottom: '1px solid var(--border-light)' }}>
                <div>
                  <strong style={{ fontSize: '0.88rem', display: 'block' }}>Max Products Per Consultation</strong>
                  <span style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>Prevent cluttering clinical advice</span>
                </div>
                <select 
                  value={maxProducts} 
                  onChange={(e) => setMaxProducts(e.target.value)} 
                  style={{ padding: '6px 12px', borderRadius: 6, border: '1px solid var(--border)', fontSize: '0.82rem', background: 'var(--bg-main)' }}
                >
                  <option value="1">1 (Ultra Subtle)</option>
                  <option value="2">2 (Optimal Balance)</option>
                  <option value="3">3 (Commercial Push)</option>
                </select>
              </div>

              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '12px 0' }}>
                <div>
                  <strong style={{ fontSize: '0.88rem', display: 'block' }}>Active Promo Code Multiplier</strong>
                  <span style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>Auto-applied in AI chat</span>
                </div>
                <input
                  type="text"
                  value={promoCode}
                  onChange={(e) => setPromoCode(e.target.value)}
                  style={{ width: 160, padding: '6px 10px', borderRadius: 6, border: '1px solid var(--border)', fontSize: '0.82rem', fontWeight: 700, background: 'var(--bg-main)' }}
                />
              </div>
            </div>
          </div>

          <div className="chart-card" style={{ padding: 22 }}>
            <h3 style={{ fontSize: '1.05rem', fontWeight: 800, marginBottom: 14 }}>
              📈 Revenue Attribution & Payouts
            </h3>
            <p style={{ fontSize: '0.82rem', color: 'var(--text-muted)', marginBottom: 16 }}>
              HealthExpress shares up to 15% partner commission with empanelled diagnostic labs and device manufacturers.
            </p>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
              <div style={{ padding: 12, borderRadius: 8, background: '#EFF6FF', display: 'flex', justifyContent: 'space-between', border: '1px solid #DBEAFE' }}>
                <span style={{ fontSize: '0.82rem', fontWeight: 600 }}>Diagnostic Lab Partners (Apollo / MedPlus):</span>
                <strong style={{ color: '#1E60F6' }}>35% Platform Margin</strong>
              </div>
              <div style={{ padding: 12, borderRadius: 8, background: '#F0FDF4', display: 'flex', justifyContent: 'space-between', border: '1px solid #DCFCE7' }}>
                <span style={{ fontSize: '0.82rem', fontWeight: 600 }}>Smart Devices (Glucometers / BP Kits):</span>
                <strong style={{ color: '#10B981' }}>28% Platform Margin</strong>
              </div>
              <div style={{ padding: 12, borderRadius: 8, background: '#FAF5FF', display: 'flex', justifyContent: 'space-between', border: '1px solid #F3E8FF' }}>
                <span style={{ fontSize: '0.82rem', fontWeight: 600 }}>Gold Family Annual Care Pass:</span>
                <strong style={{ color: '#8B5CF6' }}>45% Platform Margin</strong>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
