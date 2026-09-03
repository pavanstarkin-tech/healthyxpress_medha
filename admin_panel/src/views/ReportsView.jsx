import React from 'react';
import { Users, UserRound, CalendarCheck, Building2, TrendingUp } from 'lucide-react';
import { Line } from 'react-chartjs-2';
import MetricCard from '../components/MetricCard';

export default function ReportsView() {
  const trendData = {
    labels: ['May 12', 'May 13', 'May 14', 'May 15', 'May 16', 'May 17', 'May 18'],
    datasets: [
      {
        label: 'Bookings Volume',
        data: [420, 580, 510, 720, 680, 840, 960],
        borderColor: '#1E60F6',
        backgroundColor: 'rgba(30, 96, 246, 0.08)',
        fill: true,
        tension: 0.4,
      },
    ],
  };

  const topHospitals = [
    { name: 'KIMS Hospitals', bookings: 1245, pct: 100 },
    { name: 'Apollo Hospitals', bookings: 987, pct: 79 },
    { name: 'Yashoda Hospitals', bookings: 654, pct: 52 },
    { name: 'CARE Hospitals', bookings: 342, pct: 27 },
    { name: 'Continental Hospitals', bookings: 210, pct: 17 },
  ];

  return (
    <div>
      {/* 4 Top Metric Cards */}
      <div className="metrics-grid">
        <MetricCard
          title="Total Users"
          value="45,231"
          change="+ 22%"
          icon={Users}
          color="blue"
        />
        <MetricCard
          title="Total Doctors"
          value="1,256"
          change="+ 18%"
          icon={UserRound}
          color="blue"
        />
        <MetricCard
          title="Total Bookings"
          value="3,248"
          change="+ 15%"
          icon={CalendarCheck}
          color="orange"
        />
        <MetricCard
          title="Total Hospitals"
          value="128"
          change="+ 12%"
          icon={Building2}
          color="blue"
        />
      </div>

      {/* 2 Analytics Columns */}
      <div className="charts-grid">
        {/* Top Hospitals by Bookings Ranking */}
        <div className="chart-card">
          <div className="chart-header">
            <h3>Top Hospitals by Bookings</h3>
          </div>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 16, marginTop: 10 }}>
            {topHospitals.map((h, i) => (
              <div key={i}>
                <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '0.88rem', fontWeight: 700, marginBottom: 6 }}>
                  <span>{h.name}</span>
                  <span style={{ color: 'var(--primary)' }}>{h.bookings.toLocaleString()}</span>
                </div>
                <div style={{ height: 8, background: 'var(--bg-main)', borderRadius: 4, overflow: 'hidden' }}>
                  <div style={{ width: `${h.pct}%`, height: '100%', background: 'linear-gradient(90deg, var(--primary), var(--secondary))', borderRadius: 4 }}></div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Bookings Trend Line Chart */}
        <div className="chart-card">
          <div className="chart-header">
            <h3>Bookings Trend</h3>
          </div>
          <div style={{ height: '220px' }}>
            <Line data={trendData} options={{ responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false } } }} />
          </div>
        </div>
      </div>

      {/* 4 Bottom Today's Performance Indicators */}
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 16, marginTop: 24 }}>
        <div className="chart-card" style={{ padding: '18px 20px' }}>
          <div style={{ fontSize: '0.78rem', color: 'var(--text-muted)', fontWeight: 700, textTransform: 'uppercase' }}>Today's Bookings</div>
          <div style={{ fontSize: '1.6rem', fontWeight: 800, marginTop: 4 }}>245</div>
          <div style={{ fontSize: '0.75rem', color: 'var(--success)', fontWeight: 700, marginTop: 4 }}>↑ 12% vs yesterday</div>
        </div>

        <div className="chart-card" style={{ padding: '18px 20px' }}>
          <div style={{ fontSize: '0.78rem', color: 'var(--text-muted)', fontWeight: 700, textTransform: 'uppercase' }}>Today's Revenue</div>
          <div style={{ fontSize: '1.6rem', fontWeight: 800, marginTop: 4 }}>₹2,45,300</div>
          <div style={{ fontSize: '0.75rem', color: 'var(--success)', fontWeight: 700, marginTop: 4 }}>↑ 15% vs yesterday</div>
        </div>

        <div className="chart-card" style={{ padding: '18px 20px' }}>
          <div style={{ fontSize: '0.78rem', color: 'var(--text-muted)', fontWeight: 700, textTransform: 'uppercase' }}>New Users Today</div>
          <div style={{ fontSize: '1.6rem', fontWeight: 800, marginTop: 4 }}>112</div>
          <div style={{ fontSize: '0.75rem', color: 'var(--success)', fontWeight: 700, marginTop: 4 }}>↑ 10% vs yesterday</div>
        </div>

        <div className="chart-card" style={{ padding: '18px 20px' }}>
          <div style={{ fontSize: '0.78rem', color: 'var(--text-muted)', fontWeight: 700, textTransform: 'uppercase' }}>Active Doctors</div>
          <div style={{ fontSize: '1.6rem', fontWeight: 800, marginTop: 4 }}>876</div>
          <div style={{ fontSize: '0.75rem', color: 'var(--success)', fontWeight: 700, marginTop: 4 }}>↑ 8% vs yesterday</div>
        </div>
      </div>
    </div>
  );
}
