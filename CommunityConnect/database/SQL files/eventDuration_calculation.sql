CREATE TABLE Events_new (
    EventID INTEGER PRIMARY KEY AUTOINCREMENT,
    EventName TEXT NOT NULL,
    EventDate TEXT NOT NULL,
    EventStartTime TEXT NOT NULL,
    EventEndTime TEXT NOT NULL,
    EventLocation TEXT NOT NULL,
    EventFee REAL DEFAULT 0,
    EventManager INTEGER DEFAULT 0,
    CompanyID INTEGER NOT NULL,
    EventDuration AS (
        (strftime('%s', EventEndTime) - strftime('%s', EventStartTime)) / 60
    ) STORED,
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID)
);

INSERT INTO Events_new (
    EventID, EventName, EventDate, EventStartTime, EventEndTime, EventLocation, EventFee, EventManager, CompanyID
)
SELECT EventID, EventName, EventDate, EventStartTime, EventEndTime, EventLocation, EventFee, EventManager, CompanyID
FROM Events;

PRAGMA foreign_keys = OFF;

ALTER TABLE Events RENAME TO Events_old;
ALTER TABLE Events_new RENAME TO Events;

PRAGMA foreign_keys = ON;

-- Verify structure
PRAGMA table_info(Events);
