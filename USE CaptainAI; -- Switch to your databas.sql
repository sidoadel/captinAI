USE CaptainAI; -- Switch to your database

-- Users table
EXEC sp_columns 'Users';

-- Teams table
EXEC sp_columns 'Teams';

-- TeamMembers table
EXEC sp_columns 'TeamMembers';

-- TrainingSessions table
EXEC sp_columns 'TrainingSessions';

-- PerformanceData table
EXEC sp_columns 'PerformanceData';

-- Reports table
EXEC sp_columns 'Reports';

-- ChatMessages table
EXEC sp_columns 'ChatMessages';
