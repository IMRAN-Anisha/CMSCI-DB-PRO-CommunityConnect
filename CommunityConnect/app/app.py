from flask import Flask, render_template, request, redirect, url_for
import sqlite3
import os

app = Flask(__name__)
app.secret_key = 'your_secret_key'
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
        return redirect(url_for('volunteer_dashboard'))
    return render_template('login.html')

# ---------------- Volunteer Registration ---------------- #
@app.route('/register_volunteer', methods=['GET', 'POST'])
def register_volunteer():
    if request.method == 'POST':
        first_name = request.form.get('first-name')
        last_name = request.form.get('last-name')
        dob = request.form.get('dob')
        address = request.form.get('address')
        phone = request.form.get('phone')
        email = request.form.get('email')
        password = request.form.get('password')

        try:
            with get_db_connection() as conn:
                cursor = conn.cursor()
                # Insert into Users
                cursor.execute(
                    "INSERT INTO Users (Email, Username, Password, Role) VALUES (?, ?, ?, ?)",
                    (email, f"{first_name} {last_name}", password, "volunteer")
                )
                user_id = cursor.lastrowid

                # Insert into Volunteer
                cursor.execute(
                    "INSERT INTO Volunteer (FirstName, LastName, DOB, PhoneNumber, Address, UserID) VALUES (?, ?, ?, ?, ?, ?)",
                    (first_name, last_name, dob, phone, address, user_id)
                )
                conn.commit()
        except sqlite3.Error as e:
            print(f"Database error: {e}")
            return render_template('register_volunteer.html', error="Something went wrong. Try again.")

        return render_template('RegistrationSuccessful.html', name=first_name)

    return render_template('register_volunteer.html')


# ---------------- Organisation Registration ---------------- #
@app.route('/register_organisation', methods=['GET', 'POST'])
def register_organisation():
    if request.method == 'POST':
        company_name = request.form.get('company-name')
        company_email = request.form.get('company-email')
        company_phone = request.form.get('company-phone')
        location = request.form.get('location')
        password = request.form.get('password')

        try:
            with get_db_connection() as conn:
                cursor = conn.cursor()
                # Insert into Users
                cursor.execute(
                    "INSERT INTO Users (Email, Username, Password, Role) VALUES (?, ?, ?, ?)",
                    (company_email, company_name, password, "organisation")
                )
                user_id = cursor.lastrowid

                # Insert into Companies
                cursor.execute(
                    "INSERT INTO Companies (CompanyName, CompanyEmail, CompanyPhone, CompanyLocation, UserID) VALUES (?, ?, ?, ?, ?)",
                    (company_name, company_email, company_phone, location, user_id)
                )
                conn.commit()
        except sqlite3.Error as e:
            print(f"Database error: {e}")
            return render_template('register_organisation.html', error="Something went wrong. Try again.")

        return render_template('RegistrationSuccessful.html', name=company_name)

    return render_template('register_organisation.html')


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
    return redirect(url_for('account_settings'))

@app.route('/update_password', methods=['POST'])
def update_password():
    current_password = request.form.get('current_password')
    new_password = request.form.get('new_password')
    confirm_password = request.form.get('confirm_password')
    return redirect(url_for('account_settings'))

@app.route('/delete_account', methods=['POST'])
def delete_account():
    return redirect(url_for('index'))

@app.route('/edit_event', methods=['POST'])
def edit_event():
    return redirect(url_for('edit_post_events'))

# ---------------- Logout ---------------- #
@app.route('/logout')
def logout():
    return redirect(url_for('index'))

# ---------------- Run App ---------------- #
if __name__ == "__main__":
    app.run(debug=True)
