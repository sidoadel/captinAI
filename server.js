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

async function executeQuery(query, params = []) {
  try {
    let pool = await sql.connect(dbConfig);
    let request = pool.request();

    for (const param of params) {
      request = request.input(param.name, param.type, param.value);
    }

    let result = await request.query(query);
    pool.close(); // Close the connection after the query

    // Return result object with recordset and rowsAffected
    return {
      recordset: result.recordset,
      rowsAffected: result.rowsAffected
    };
  } catch (error) {
    console.error('SQL error:', error);
    throw new Error(`Error executing query: ${error}`);
  }
}

// Login route
app.post('/login', async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: 'Email and password are required' });
  }

  const query = `SELECT Id, UserName, Role FROM Users WHERE Email = @Email AND Password = @Password`;
  const params = [
    { name: 'Email', type: sql.NVarChar, value: email },
    { name: 'Password', type: sql.NVarChar, value: password }
  ];

  try {
    const result = await executeQuery(query, params);
    
    if (result.recordset.length > 0) {
      res.status(200).json(result.recordset[0]); // Return user info excluding sensitive data
    } else {
      res.status(401).json({ message: 'Invalid credentials' });
    }
  } catch (error) {
    res.status(500).json({ message: `Error logging in: ${error.message}` });
  }
});

// Signup route
app.post('/signup', async (req, res) => {
  const { email, password, role, username } = req.body;

  if (!email || !password || !role || !username) {
    return res.status(400).json({ message: 'All fields are required' });
  }

  const checkUserQuery = `SELECT * FROM Users WHERE Email = @Email`;
  const createUserQuery = `INSERT INTO Users (UserName, Email, Password, Role) 
                           VALUES (@UserName, @Email, @Password, @Role); SELECT SCOPE_IDENTITY() AS Id;`;

  try {
    const params = [
      { name: 'Email', type: sql.NVarChar, value: email }
    ];
    const checkUserResult = await executeQuery(checkUserQuery, params);
    
    if (checkUserResult.recordset.length > 0) {
      res.status(400).json({ message: 'Email already exists' });
    } else {
      const createParams = [
        { name: 'UserName', type: sql.NVarChar, value: username },
        { name: 'Email', type: sql.NVarChar, value: email },
        { name: 'Password', type: sql.NVarChar, value: password },
        { name: 'Role', type: sql.NVarChar, value: role }
      ];
      const result = await executeQuery(createUserQuery, createParams);
      res.status(200).json({ message: 'User created successfully', Id: result.recordset[0].Id });
    }
  } catch (error) {
    res.status(500).json({ message: `Error creating user: ${error.message}` });
  }
});

// Fetch profile route
app.get('/profile', async (req, res) => {
  try {
    const id = parseInt(req.query.id, 10);
    if (!id) {
      return res.status(400).json({ message: 'Id is required' });
    }

    const query = `SELECT Id, UserName, Email, Role FROM Users WHERE Id = @Id`;
    const params = [
      { name: 'Id', type: sql.Int, value: id }
    ];
    const result = await executeQuery(query, params);

    if (result.recordset.length > 0) {
      res.status(200).json(result.recordset[0]);
    } else {
      res.status(404).json({ message: 'Profile not found' });
    }
  } catch (err) {
    console.error('Error fetching profile: ', err);
    res.status(500).json({ message: 'Server error' });
  }
});

// Update profile route
app.put('/profile', async (req, res) => {
  try {
    const id = parseInt(req.query.id, 10);
    const { UserName, Password } = req.body;

    if (!id || !UserName) {
      return res.status(400).json({ message: 'Id and UserName are required' });
    }

    // Base query to update profile
    let query = 'UPDATE Users SET UserName = @UserName';
    let params = [
      { name: 'UserName', type: sql.NVarChar, value: UserName },
      { name: 'Id', type: sql.Int, value: id }
    ];

    // Append password to query if provided
    if (Password) {
      query += ', Password = @Password';
      params.push({ name: 'Password', type: sql.NVarChar, value: Password });
    }

    query += ' WHERE Id = @Id';

    // Connect to the database and execute the query
    let pool;
    try {
      pool = await sql.connect(dbConfig);
      const request = pool.request();
      params.forEach(param => request.input(param.name, param.type, param.value));

      const result = await request.query(query);

      if (result.rowsAffected[0] === 0) {
        return res.status(404).json({ message: 'Profile not found' });
      }

      res.status(200).json({ message: 'Profile updated successfully' });
    } finally {
      if (pool) {
        pool.close();
      }
    }
  } catch (err) {
    console.error('Error updating profile: ', err.message);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
});

// Create team route
app.post('/createTeam', async (req, res) => {
  const { teamName, members, headCoachId } = req.body;
  const createTeamQuery = `INSERT INTO Teams (TeamName, HeadCoachId) 
                           VALUES (@TeamName, @HeadCoachId); SELECT SCOPE_IDENTITY() AS TeamId;`;

  try {
    const createTeamParams = [
      { name: 'TeamName', type: sql.NVarChar, value: teamName },
      { name: 'HeadCoachId', type: sql.Int, value: headCoachId }
    ];

    const teamResult = await executeQuery(createTeamQuery, createTeamParams);
    const teamId = teamResult.recordset[0].TeamId;

    for (const memberId of members) {
      const addMemberQuery = `INSERT INTO TeamMembers (TeamId, MemberId) VALUES (@TeamId, @MemberId)`;
      const addMemberParams = [
        { name: 'TeamId', type: sql.Int, value: teamId },
        { name: 'MemberId', type: sql.Int, value: memberId }
      ];
      await executeQuery(addMemberQuery, addMemberParams);
    }

    res.status(200).json({ message: 'Team created successfully', teamId });
  } catch (error) {
    res.status(500).json({ message: `Error creating team: ${error.message}` });
  }
});

// Save a new chat
app.post('/save-chat', async (req, res) => {
  const { userId, chatContent } = req.body;

  if (!userId || !chatContent) {
    return res.status(400).json({ message: 'UserId and ChatContent are required' });
  }

  const query = `INSERT INTO SavedChats (UserId, ChatContent, Timestamp) VALUES (@UserId, @ChatContent, @Timestamp);`;
  const params = [
    { name: 'UserId', type: sql.Int, value: parseInt(userId, 10) },
    { name: 'ChatContent', type: sql.NVarChar, value: chatContent },
    { name: 'Timestamp', type: sql.DateTime, value: new Date() },
  ];

  try {
    await executeQuery(query, params);
    res.status(200).json({ message: 'Chat saved successfully' });
  } catch (error) {
    res.status(500).json({ message: `Error saving chat: ${error.message}` });
  }
});

// Fetch saved chats
app.get('/saved-chats', async (req, res) => {
  try {
    const result = await executeQuery('SELECT Id, UserId, ChatContent, Timestamp FROM SavedChats', []);
    res.status(200).json(result.recordset);
  } catch (error) {
    res.status(500).json({ message: `Error fetching saved chats: ${error.message}` });
  }
});

// Delete a chat
app.delete('/delete-chat', async (req, res) => {
  const { id } = req.query;

  if (!id) {
    return res.status(400).json({ message: 'Chat ID is required' });
  }

  // Ensure id is an integer
  const chatId = parseInt(id, 10);
  if (isNaN(chatId)) {
    return res.status(400).json({ message: 'Invalid Chat ID' });
  }

  const query = 'DELETE FROM SavedChats WHERE Id = @Id';
  const params = [
    { name: 'Id', type: sql.Int, value: chatId },
  ];

  try {
    const result = await executeQuery(query, params);
    if (result.rowsAffected[0] === 0) {
      return res.status(404).json({ message: 'Chat not found' });
    }
    res.status(200).json({ message: 'Chat deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: `Error deleting chat: ${error.message}` });
  }
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
