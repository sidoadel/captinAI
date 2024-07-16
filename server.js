const express = require('express');
const bodyParser = require('body-parser');
const sql = require('mssql');
const cors = require('cors');

const app = express();
const port = 3000;

app.use(cors());
app.use(bodyParser.json());

const dbConfig = {
  user: 'sa',
  password: 'Abc12345',
  server: 'localhost',
  database: 'CaptainAI',
  options: {
    encrypt: true,
    trustServerCertificate: true,
  }
};

async function executeQuery(query) {
  try {
    let pool = await sql.connect(dbConfig);
    let result = await pool.request().query(query);
    return result.recordset;
  } catch (error) {
    throw new Error(`Error executing query: ${error}`);
  }
}

app.post('/signup', async (req, res) => {
  const { username, email, password, role } = req.body;

  const checkUserQuery = `SELECT * FROM Users WHERE Email = '${email}'`;
  const createUserQuery = `INSERT INTO Users (UserName, Email, Password, Role) 
                           VALUES (N'${username}', N'${email}', '${password}', N'${role}')`; // Ensure N' for Unicode support

  try {
    const existingUser = await executeQuery(checkUserQuery);
    if (existingUser.length > 0) {
      res.status(400).json({ message: 'Email already exists' });
    } else {
      await executeQuery(createUserQuery);
      res.status(200).json({ message: 'User created successfully' });
    }
  } catch (error) {
    res.status(500).json({ message: `Error creating user: ${error.message}` });
  }
});

app.post('/login', async (req, res) => {
  const { email, password } = req.body;
  const query = `SELECT * FROM Users WHERE Email = '${email}' AND Password = '${password}'`;

  try {
    const result = await executeQuery(query);
    if (result.length > 0) {
      const user = result[0];
      res.status(200).json({ message: 'Login successful', role: user.Role });
    } else {
      res.status(401).json({ message: 'Invalid credentials' });
    }
  } catch (error) {
    res.status(500).json({ message: `Error logging in: ${error.message}` });
  }
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
