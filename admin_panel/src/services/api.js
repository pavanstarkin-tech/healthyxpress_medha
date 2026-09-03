import axios from 'axios';

// Connects to local dev or live Hostinger PHP REST API
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:5000/api';

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

export const healthApi = {
  // Live Telemetry & Computed Stats
  getHealth: () => api.get('/health'),
  getAdminStats: () => api.get('/admin/stats'),
  getHospitalRankings: () => api.get('/admin/hospital-rankings'),
  getConsultationDistribution: () => api.get('/admin/consultation-distribution'),
  getActivityLogs: () => api.get('/admin/activity-logs'),

  // Users & Patients Ledger
  getUsers: () => api.get('/users'),

  // Hospitals
  getHospitals: () => api.get('/hospitals'),
  getHospitalDetail: (id) => api.get(`/hospitals/${id}`),
  createHospital: (data) => api.post('/hospitals', data),

  // Doctors
  getDoctors: (params) => api.get('/doctors', { params }),
  getDoctorDetail: (id) => api.get(`/doctors/${id}`),
  toggleDoctorStatus: (id, isOnline) => api.put(`/doctors/${id}/status`, { isOnline }),
  verifyDoctor: (id, status, notes) => api.put(`/doctors/${id}/verify`, { status, notes }),

  // Appointments
  getAllAppointments: () => api.get('/appointments'),
  getBookings: () => api.get('/appointments/user/USR-101'),
  getDoctorQueue: (doctorId) => api.get(`/appointments/doctor/${doctorId}`),

  // Payments & Ledger
  getPayments: () => api.get('/payments'),

  // Support & Dispute Desk
  getTickets: () => api.get('/tickets'),
  createTicket: (data) => api.post('/tickets', data),

  // Pharmacy Catalog
  getMedicines: () => api.get('/pharmacy/medicines'),

  // Aarogyasri Health Pass
  getAarogyasriProfile: (id) => api.get(`/auth/aarogyasri/${id}`),
};

export default api;
