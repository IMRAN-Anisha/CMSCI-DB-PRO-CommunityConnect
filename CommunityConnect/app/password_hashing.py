import sqlite3
from werkzeug.security import generate_password_hash

DATABASE = 'path_to_your_db/CommunityConnect.db'  # adjust path

conn = sqlite3.connect(DATABASE)
cursor = conn.cursor()

# Fetch all users
users = cursor.execute("SELECT UserID, Password FROM Users").fetchall()

for user in users:
    plain_pw = user[1]
    # Skip if already hashed (hashed passwords usually start with 'pbkdf2:' or 'scrypt:')
    if not plain_pw.startswith(('pbkdf2:', 'scrypt:')):
        hashed_pw = generate_password_hash(plain_pw)
        cursor.execute(
            "UPDATE Users SET Password = ? WHERE UserID = ?",
            (hashed_pw, user[0])
        )

conn.commit()
conn.close()
print("All plain-text passwords have been hashed successfully.")
