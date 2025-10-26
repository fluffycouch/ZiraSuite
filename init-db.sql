-- Initialize project database with some sample data
CREATE TABLE IF NOT EXISTS deployments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    status TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    environment TEXT NOT NULL,
    notes TEXT
);

CREATE TABLE IF NOT EXISTS insights (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    insight TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Insert some sample deployment data
INSERT INTO deployments (name, status, environment, notes) VALUES 
('ManagerServer-v1.0', 'running', 'production', 'Initial deployment with Docker + auth proxy'),
('ManagerServer-v1.1', 'pending', 'staging', 'Testing JWT verification improvements'),
('Database-Migration', 'completed', 'production', 'Added user analytics tables');

-- Insert a sample insight
INSERT INTO insights (insight) VALUES 
('Docker containerization reduced deployment time by 60% compared to manual setup');