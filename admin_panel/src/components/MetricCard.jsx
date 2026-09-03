import React from 'react';
import { ArrowUpRight, ArrowDownRight } from 'lucide-react';

export default function MetricCard({ title, value, change, isPositive = true, icon: Icon, color = 'blue' }) {
  return (
    <div className="metric-card">
      <div className="metric-info">
        <h3>{title}</h3>
        <div className="metric-value">{value}</div>
        <div className={`metric-trend ${isPositive ? 'up' : 'down'}`}>
          {isPositive ? <ArrowUpRight size={13} strokeWidth={2.5} /> : <ArrowDownRight size={13} strokeWidth={2.5} />}
          <span>{change} vs last week</span>
        </div>
      </div>
      <div className={`metric-icon-box ${color}`}>
        <Icon size={24} strokeWidth={2.2} />
      </div>
    </div>
  );
}
