from flask import Flask, render_template, request, redirect, url_for
import sqlite3
import os

app = Flask(__name__)
app.secret_key = 'your_secret_key'  # Needed for flash messages
DATABASE = os.path.join(os.path.dirname(__file__), '..', 'database', 'CommunityConnect.db')
print(DATABASE)

# ---------------- SQLite Database Connection ---------------- #
def get_db_connection():
    conn = sqlite3.connect(DATABASE, timeout=10)
    conn.row_factory = sqlite3.Row
    return conn

# ---------------- GET Routes ---------------- #
@app.route('/')
def index():
    return render_template('index.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        # Placeholder: handle login logic here
        return redirect(url_for('volunteer_dashboard'))
    return render_template('login.html')

@app.route('/registration', methods=['GET', 'POST'])
def registration():
    if request.method == 'POST':
        account_type = request.form.get('account-type')
        full_name = request.form.get('full-name')
        email = request.form.get('email')
        password = request.form.get('password')  # ideally hash this

        # Split full name for volunteer first and last names
        first_name = full_name.split()[0]
        last_name = full_name.split()[-1] if len(full_name.split()) > 1 else ""

        # Use a context manager to safely open and close the database connection
        try:
            with get_db_connection() as conn:
                cursor = conn.cursor()

                # Insert into Users
                cursor.execute(
                    "INSERT INTO Users (Email, Username, Password, Role) VALUES (?, ?, ?, ?)",
                    (email, full_name, password, account_type)
                )
                user_id = cursor.lastrowid

                # Insert into Volunteers or Companies
                if account_type == 'volunteer':
                    cursor.execute(
                        "INSERT INTO Volunteers (FirstName, LastName, DOB, PhoneNumber, Address, UserID) VALUES (?, ?, ?, ?, ?, ?)",
                        (first_name, last_name, "2000-01-01", "0000000000", "Address", user_id)
                    )
                else:  # organisation
                    cursor.execute(
                        "INSERT INTO Companies (CompanyName, CompanyEmail, CompanyPhone, CompanyLocation, CompanyWebsite, CompanyCEO, UserID) VALUES (?, ?, ?, ?, ?, ?, ?)",
                        (full_name, email, "0000000000", "Location", "Website", "CEO Name", user_id)
                    )

                # Commit is automatic with context manager, but can be explicit
                conn.commit()

        except sqlite3.Error as e:
            # Optional: flash an error or print it for debugging
            print(f"Database error: {e}")
            return render_template('registration.html', error="Something went wrong. Try again.")

        # Show a registration success page
        return render_template('RegistrationSuccessful.html', name=first_name)

    # GET request: show registration form
    return render_template('registration.html')

@app.route('/privacy')
def privacy_policy():
    return render_template('PrivacyPolicy.html')

@app.route('/volunteer_dashboard')
def volunteer_dashboard():
    return render_template('VolunteerUserDashboard.html', volunteer_name="Your Name")

@app.route('/volunteer_profile')
def volunteer_profile():
    return render_template('VolunteerProfilePage.html')

@app.route('/event_search')
def event_search():
    return render_template('EventSearch.html')

@app.route('/notifications')
def notifications():
    return render_template('Notifications.html')

@app.route('/account_settings')
def account_settings():
    return render_template('Accountsettings.html')

@app.route('/organisation_dashboard')
def organisation_dashboard():
    return render_template('organisationDashboard.html')

@app.route('/edit_post_events')
def edit_post_events():
    return render_template('EditPostEvents.html')

# ---------------- POST Routes ---------------- #
@app.route('/update_email', methods=['POST'])
def update_email():
    current_email = request.form.get('current_email')
    new_email = request.form.get('new_email')
    # Placeholder: process email update
    return redirect(url_for('account_settings'))

@app.route('/update_password', methods=['POST'])
def update_password():
    current_password = request.form.get('current_password')
    new_password = request.form.get('new_password')
    confirm_password = request.form.get('confirm_password')
    # Placeholder: process password update
    return redirect(url_for('account_settings'))

@app.route('/delete_account', methods=['POST'])
def delete_account():
    # Placeholder: delete account
    return redirect(url_for('index'))

@app.route('/edit_event', methods=['POST'])
def edit_event():
    # Placeholder: handle event creation/edit
    return redirect(url_for('edit_post_events'))

# ---------------- Logout ---------------- #
@app.route('/logout')
def logout():
    return redirect(url_for('index'))

# ---------------- Run App ---------------- #
if __name__ == "__main__":
    app.run(debug=True)
