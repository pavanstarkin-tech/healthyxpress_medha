const express = require('express');
const router = express.Router();
const { pool } = require('../database');

// GET /api/doctors — Fetch real verified doctors with filtering
router.get('/', async (req, res) => {
  const { specialty, hospitalId, isRmp, practiceType } = req.query;
  try {
    let query = `
      SELECT d.*, h.name AS hospital_name, h.city AS hospital_location
      FROM doctors d
      LEFT JOIN doctor_hospitals dh ON d.id = dh.doctor_id
      LEFT JOIN hospitals h ON dh.hospital_id = h.id
      WHERE 1=1
    `;
    const params = [];

    if (specialty && specialty !== 'All') {
      query += ' AND d.specialty = ?';
      params.push(specialty);
    }
    if (hospitalId) {
      query += ' AND dh.hospital_id = ?';
      params.push(hospitalId);
    }
    if (isRmp === 'true') {
      query += ' AND d.is_rmp_doctor = TRUE';
    }
    if (practiceType) {
      query += ' AND d.practice_type = ?';
      params.push(practiceType);
    }

    query += ' ORDER BY d.rating DESC, d.experience_years DESC';

    const [rows] = await pool.query(query, params);
    return res.json(rows);
  } catch (err) {
    console.error('Error fetching doctors:', err.message);
    return res.status(500).json({ error: 'Failed to fetch doctors from database' });
  }
});

// GET /api/doctors/:id — Doctor details with schedules and affiliations
router.get('/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const [docRows] = await pool.query('SELECT * FROM doctors WHERE id = ?', [id]);
    if (docRows.length === 0) {
      return res.status(404).json({ error: 'Doctor not found' });
    }
    const [affRows] = await pool.query(
      `SELECT dh.*, h.name AS hospital_name, h.city AS hospital_location 
       FROM doctor_hospitals dh 
       JOIN hospitals h ON dh.hospital_id = h.id 
       WHERE dh.doctor_id = ?`,
      [id]
    );
    const [schedRows] = await pool.query('SELECT * FROM doctor_schedules WHERE doctor_id = ?', [id]);

    const doctor = docRows[0];
    doctor.affiliations = affRows;
    doctor.schedules = schedRows;

    return res.json(doctor);
  } catch (err) {
    console.error('Error fetching doctor detail:', err.message);
    return res.status(500).json({ error: 'Failed to fetch doctor details' });
  }
});

// PUT /api/doctors/:id/status — Toggle Online/Offline
router.put('/:id/status', async (req, res) => {
  const { id } = req.params;
  const { isOnline } = req.body;
  try {
    await pool.query('UPDATE doctors SET is_online = ? WHERE id = ?', [isOnline ? 1 : 0, id]);
    return res.json({ message: 'Doctor availability status updated in database', isOnline });
  } catch (err) {
    console.error('Status toggle error:', err.message);
    return res.status(500).json({ error: 'Failed to update doctor status' });
  }
});

module.exports = router;
