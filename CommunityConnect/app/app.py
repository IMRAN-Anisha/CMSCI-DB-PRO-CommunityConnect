from flask import Flask, render_template, request, redirect, url_for, session, flash
from werkzeug.utils import secure_filename
import sqlite3
import os
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)
app.secret_key = 'your_secret_key'
DATABASE = os.path.join(os.path.dirname(__file__), '..', 'database', 'CommunityConnect.db')


UPLOAD_FOLDER = os.path.join(app.root_path, 'static', 'uploads')
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

def get_db_connection():
    conn = sqlite3.connect(DATABASE, timeout=10)
    conn.row_factory = sqlite3.Row
    return conn

# ---------------- GET ROUTES ---------------- #
@app.route('/')
def index():
    return render_template('index.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form.get('email', '').strip()
        password = request.form.get('password', '').strip()
        if not email or not password:
            flash("Please fill all fields.", "error")
            return render_template('login.html')

        conn = get_db_connection()
        user = conn.execute(
            "SELECT * FROM Users WHERE Email = ?", 
            (email,)
        ).fetchone()

        if user and check_password_hash(user['Password'], password):
            session['user_id'] = user['UserID']
            session['role'] = user['Role']  # store role

            # Get display name based on role
            if user['Role'].lower() == 'volunteer':
                volunteer = conn.execute(
                    "SELECT FirstName FROM Volunteer WHERE UserID = ?", 
                    (user['UserID'],)
                ).fetchone()
                session['display_name'] = volunteer['FirstName']
                conn.close()
                return redirect(url_for('volunteer_dashboard'))
            elif user['Role'].lower() == 'organisation':
                company = conn.execute(
                    "SELECT CompanyName FROM Companies WHERE UserID = ?", 
                    (user['UserID'],)
                ).fetchone()
                session['display_name'] = company['CompanyName']
                conn.close()
                return redirect(url_for('organisation_dashboard'))
            else:
                conn.close()
                flash("Role not recognized.", "error")
                return render_template('login.html')
        else:
            conn.close()
            flash("Invalid email or password.", "error")
            return render_template('login.html')

    return render_template('login.html')


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

        # Hash the password
        hashed_password = generate_password_hash(password)

        try:
            with get_db_connection() as conn:
                cursor = conn.cursor()
                cursor.execute(
                    "INSERT INTO Users (Email, Username, Password, Role) VALUES (?, ?, ?, ?)",
                    (email, f"{first_name} {last_name}", hashed_password, "volunteer")
                )
                user_id = cursor.lastrowid
                cursor.execute(
                    "INSERT INTO Volunteer (FirstName, LastName, DOB, PhoneNumber, Address, UserID) VALUES (?, ?, ?, ?, ?, ?)",
                    (first_name, last_name, dob, phone, address, user_id)
                )
                volunteer_id = cursor.lastrowid
                cursor.execute(
                    "INSERT INTO VolunteerProfile (VolunteerID, profile_image_url) VALUES (?, ?)",
                    (volunteer_id, 'static/images/defaultProfileImage.png')
                )
                conn.commit()
        except sqlite3.Error as e:
            print(f"Database error: {e}")
            return render_template('register_volunteer.html', error="Something went wrong. Try again.")

        flash("Volunteer registration successful!", "success")
        return render_template('RegistrationSuccessful.html', name=first_name)

    return render_template('register_volunteer.html')

@app.route('/register_organisation', methods=['GET', 'POST'])
def register_organisation():
    if request.method == 'POST':
        company_name = request.form.get('company-name')
        company_email = request.form.get('company-email')
        company_phone = request.form.get('company-phone')
        location = request.form.get('location')
        password = request.form.get('password')

        # Hash the password
        hashed_password = generate_password_hash(password)

        try:
            with get_db_connection() as conn:
                cursor = conn.cursor()
                cursor.execute(
                    "INSERT INTO Users (Email, Username, Password, Role) VALUES (?, ?, ?, ?)",
                    (company_email, company_name, hashed_password, "organisation")
                )
                user_id = cursor.lastrowid
                cursor.execute(
                    "INSERT INTO Companies (CompanyName, CompanyEmail, CompanyPhone, CompanyLocation, UserID) VALUES (?, ?, ?, ?, ?)",
                    (company_name, company_email, company_phone, location, user_id)
                )
                conn.commit()
        except sqlite3.Error as e:
            print(f"Database error: {e}")
            return render_template('register_organisation.html', error="Something went wrong. Try again.")

        flash("Organisation registration successful!", "success")
        return render_template('RegistrationSuccessful.html', name=company_name)

    return render_template('register_organisation.html')


@app.route('/privacy')
def privacy_policy():
    return render_template('PrivacyPolicy.html')

@app.route('/volunteer_dashboard')
def volunteer_dashboard():
    user_id = session.get('user_id')
    if not user_id:
        flash("Please log in to access your dashboard.", "error")
        return redirect(url_for('login'))

    conn = get_db_connection()
    volunteer = conn.execute("SELECT FirstName, LastName FROM Volunteer WHERE UserID = ?", (user_id,)).fetchone()
    conn.close()

    first_name = volunteer['FirstName'] if volunteer else "Volunteer"
    return render_template('VolunteerUserDashboard.html', first_name=first_name)

@app.route('/event_search', methods=['GET', 'POST'])
def event_search():
    if request.method == 'POST' and request.form.get('clear'):
        # Clear filters
        return redirect(url_for('event_search'))

    conn = get_db_connection()
    search_name = request.args.get('search', '').strip()
    search_date = request.args.get('date', '').strip()
    search_location = request.args.get('location', '').strip()

    query = "SELECT E.*, C.CompanyName FROM Events E JOIN Companies C ON E.CompanyID = C.CompanyID WHERE 1=1"
    params = []

    if search_name:
        query += " AND E.EventName LIKE ?"
        params.append(f"%{search_name}%")
    if search_date:
        query += " AND E.EventDate = ?"
        params.append(search_date)
    if search_location:
        query += " AND E.EventLocation LIKE ?"
        params.append(f"%{search_location}%")

    query += " ORDER BY E.EventDate ASC"
    events = conn.execute(query, params).fetchall()
    conn.close()

    return render_template('EventSearch.html', events=events,
                           search_name=search_name, search_date=search_date, search_location=search_location)


@app.route('/notifications')
def notifications():
    return render_template('Notifications.html')

@app.route('/account_settings')
def account_settings():
    user_id = session.get('user_id')
    if not user_id:
        flash("Please log in first.", "error")
        return redirect(url_for('login'))

    conn = get_db_connection()
    user = conn.execute("SELECT Email FROM Users WHERE UserID = ?", (user_id,)).fetchone()
    conn.close()

    email = user['Email'] if user else ""
    return render_template('AccountSettings.html', email=email)


@app.route('/organisation_dashboard')
def organisation_dashboard():
    return render_template('OrganisationUserDashboard.html')

@app.route('/edit_post_events', methods=['GET', 'POST'])
def edit_post_events():
    if request.method == 'POST':
        event_name = request.form.get('event-name')
        event_date = request.form.get('event-date')
        start_time = request.form.get('start-time')
        end_time = request.form.get('end-time')
        location = request.form.get('location')
        fee = request.form.get('fee', 0)
        manager = request.form.get('Manager', 0)
        company_id = session.get('user_id', 1)  # temp fallback

        try:
            conn = get_db_connection()
            conn.execute("""
                INSERT INTO Events 
                (EventName, EventDate, EventStartTime, EventEndTime, EventLocation, EventFee, EventManager, CompanyID)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """, (event_name, event_date, start_time, end_time, location, fee, manager, company_id))
            conn.commit()
            conn.close()

            flash("✅ Event created successfully!", "success")
            return redirect(url_for('edit_post_events'))
        except sqlite3.Error as e:
            print(f"Database error: {e}")
            flash("❌ Error saving event. Try again.", "error")

    return render_template('EditPostEvents.html')

# ---------------- Profile Page ---------------- #
@app.route('/volunteer_profile', methods=['GET', 'POST'])
def volunteer_profile():
    user_id = session.get('user_id')
    if not user_id:
        return redirect(url_for('login'))

    conn = get_db_connection()
    volunteer = conn.execute("""
        SELECT V.FirstName, V.LastName, V.DOB, V.PhoneNumber, V.Address, U.Email, V.VolunteerID
        FROM Volunteer V
        JOIN Users U ON V.UserID = U.UserID
        WHERE V.UserID = ?
    """, (user_id,)).fetchone()

    if not volunteer:
        conn.close()
        flash("Volunteer data not found.", "error")
        return redirect(url_for('volunteer_dashboard'))

    profile = conn.execute("SELECT profile_image_url FROM VolunteerProfile WHERE VolunteerID = ?", (volunteer['VolunteerID'],)).fetchone()
    if not profile:
        conn.execute("INSERT INTO VolunteerProfile (VolunteerID, profile_image_url) VALUES (?, ?)",
                     (volunteer['VolunteerID'], 'static/images/defaultProfileImage.png'))
        conn.commit()
        profile_image = url_for('static', filename='images/defaultProfileImage.png')
    else:
        profile_image = profile['profile_image_url'] or url_for('static', filename='images/defaultProfileImage.png')

    conn.close()
    full_name = f"{volunteer['FirstName']} {volunteer['LastName']}"
    return render_template(
        'VolunteerProfilePage.html',
        volunteer_name=full_name,
        first_name=volunteer['FirstName'],
        last_name=volunteer['LastName'],
        dob=volunteer['DOB'],
        phone=volunteer['PhoneNumber'],
        address=volunteer['Address'],
        email=volunteer['Email'],
        profile_image=profile_image,
        current_year=2025
    )

@app.route('/update_profile_image', methods=['POST'])
def update_profile_image():
    user_id = session.get('user_id')
    if not user_id:
        flash("Please log in first.", "error")
        return redirect(url_for('login'))

    file = request.files.get('profile_image')
    if not file:
        flash("Please select an image to upload.", "error")
        return redirect(url_for('volunteer_profile'))

    filename = secure_filename(file.filename)
    save_path = os.path.join(UPLOAD_FOLDER, filename)
    file.save(save_path)

    conn = get_db_connection()
    volunteer_id = conn.execute("SELECT VolunteerID FROM Volunteer WHERE UserID = ?", (user_id,)).fetchone()['VolunteerID']
    conn.execute("UPDATE VolunteerProfile SET profile_image_url = ? WHERE VolunteerID = ?", (f'static/uploads/{filename}', volunteer_id))
    conn.commit()
    conn.close()

    flash("Profile picture updated successfully!", "success")
    return redirect(url_for('volunteer_profile'))

# ---------------- Update in Account Settings ---------------- #
@app.route('/update_email', methods=['POST'])
def update_email():
    user_id = session.get('user_id')
    if not user_id:
        flash("Please log in first.", "error")
        return redirect(url_for('login'))

    current_email = request.form.get('current_email')
    new_email = request.form.get('new_email')

    if not current_email or not new_email:
        flash("Please fill all fields.", "error")
        return redirect(url_for('account_settings'))

    conn = get_db_connection()
    conn.execute("UPDATE Users SET Email = ? WHERE UserID = ?", (new_email, user_id))
    conn.commit()
    conn.close()

    flash("Email updated successfully!", "success")
    return redirect(url_for('account_settings'))

@app.route('/update_password', methods=['POST'])
def update_password():
    user_id = session.get('user_id')
    if not user_id:
        flash("Please log in first.", "error")
        return redirect(url_for('login'))

    current_password = request.form.get('current_password')
    new_password = request.form.get('new_password')
    confirm_password = request.form.get('confirm_password')

    if not current_password or not new_password or not confirm_password:
        flash("Please fill all fields.", "error")
        return redirect(url_for('account_settings'))

    if new_password != confirm_password:
        flash("New password and confirmation do not match.", "error")
        return redirect(url_for('account_settings'))

    conn = get_db_connection()
    user = conn.execute("SELECT Password FROM Users WHERE UserID = ?", (user_id,)).fetchone()
    if not user or user['Password'] != current_password:
        conn.close()
        flash("Current password is incorrect.", "error")
        return redirect(url_for('account_settings'))

    conn.execute("UPDATE Users SET Password = ? WHERE UserID = ?", (new_password, user_id))
    conn.commit()
    conn.close()

    flash("Password updated successfully!", "success")
    return redirect(url_for('account_settings'))

@app.route('/delete_account', methods=['POST'])
def delete_account():
    user_id = session.get('user_id')
    if not user_id:
        flash("Please log in first.", "error")
        return redirect(url_for('login'))

    # Optional: confirm user wants to delete account
    conn = get_db_connection()
    # Delete from VolunteerProfile if exists
    volunteer = conn.execute("SELECT VolunteerID FROM Volunteer WHERE UserID = ?", (user_id,)).fetchone()
    if volunteer:
        conn.execute("DELETE FROM VolunteerProfile WHERE VolunteerID = ?", (volunteer['VolunteerID'],))
        conn.execute("DELETE FROM Volunteer WHERE UserID = ?", (user_id,))

    # Delete user from Users table
    conn.execute("DELETE FROM Users WHERE UserID = ?", (user_id,))
    conn.commit()
    conn.close()

    session.clear()
    flash("Your account has been deleted.", "success")
    return redirect(url_for('index'))

@app.route('/statistics')
def statistics():
    conn = get_db_connection()

    # Number of volunteers per skill
    volunteers_per_skill = conn.execute("""
        SELECT S.SkillID, COUNT(VS.VolunteerID) AS VolunteersWithSkill
        FROM VolunteerSkills VS
        JOIN Skill S ON VS.SkillID = S.SkillID
        GROUP BY S.SkillID;
    """).fetchall()

    # Total volunteers per event
    total_volunteers_per_event = conn.execute("""
        SELECT E.EventID, E.EventName, COUNT(VE.VolunteerID) AS TotalVolunteers
        FROM Events E
        INNER JOIN VolunteerEvents VE ON E.EventID = VE.EventID
        GROUP BY E.EventID;
    """).fetchall()

    # Average experience per skill
    avg_experience_per_skill = conn.execute("""
        SELECT S.SkillID, AVG(VP.YearsOfExperience) AS AvgExperience
        FROM VolunteerSkills VS
        JOIN Volunteer V ON VS.VolunteerID = V.VolunteerID
        JOIN VolunteerProfile VP ON V.VolunteerID = VP.VolunteerID
        JOIN Skill S ON VS.SkillID = S.SkillID
        GROUP BY S.SkillID;
    """).fetchall()

    # Min and max experience per skill
    min_max_experience_per_skill = conn.execute("""
        SELECT S.SkillID, MIN(VP.YearsOfExperience) AS MinExperience, MAX(VP.YearsOfExperience) AS MaxExperience
        FROM VolunteerSkills VS
        JOIN Volunteer V ON VS.VolunteerID = V.VolunteerID
        JOIN VolunteerProfile VP ON V.VolunteerID = VP.VolunteerID
        JOIN Skill S ON VS.SkillID = S.SkillID
        GROUP BY S.SkillID;
    """).fetchall()

    # Total event fees collected per company
    total_events_fees_per_company = conn.execute("""
        SELECT C.CompanyID, C.CompanyName, COUNT(E.EventID) AS TotalEvents, SUM(E.EventFee) AS TotalFeesCollected
        FROM Companies C
        JOIN Events E ON C.CompanyID = E.CompanyID
        GROUP BY C.CompanyID;
    """).fetchall()

    # Overall stats
    overall_stats = conn.execute("""
        SELECT
            COUNT(DISTINCT V.VolunteerID) AS TotalVolunteers,
            COUNT(DISTINCT E.EventID) AS TotalEvents,
            AVG(VP.YearsOfExperience) AS AvgExperience,
            MIN(VP.YearsOfExperience) AS MinExperience,
            MAX(VP.YearsOfExperience) AS MaxExperience,
            SUM(E.EventFee) AS TotalFeesCollected
        FROM Volunteer V
        JOIN VolunteerProfile VP ON V.VolunteerID = VP.VolunteerID
        JOIN VolunteerEvents VE ON V.VolunteerID = VE.VolunteerID
        JOIN Events E ON VE.EventID = E.EventID;
    """).fetchone()

    conn.close()

    return render_template(
        'StatisticsDashboard.html',
        volunteers_per_skill=volunteers_per_skill,
        total_volunteers_per_event=total_volunteers_per_event,
        avg_experience_per_skill=avg_experience_per_skill,
        min_max_experience_per_skill=min_max_experience_per_skill,
        total_events_fees_per_company=total_events_fees_per_company,
        overall_stats=overall_stats
    )

@app.route('/search_volunteer', methods=['GET'])
def search_volunteer():
    user_role = session.get('role')
    if user_role != 'organisation':
        flash("Only organisations can access this page.", "error")
        return redirect(url_for('index'))

    conn = get_db_connection()

    # Get skill columns dynamically (excluding SkillID)
    skill_columns = [col for col in conn.execute("PRAGMA table_info(skill)").fetchall() if col['name'] != 'SkillID']
    skills = [col['name'] for col in skill_columns]

    # Get selected skill from GET params
    selected_skill = request.args.get('skill_name')  # matches dropdown "name"

    search_results = None
    if selected_skill and selected_skill in skills:
        # Query volunteers who have this skill (1 in that column)
        search_results = conn.execute(f"""
            SELECT V.VolunteerID, V.FirstName, V.LastName, V.PhoneNumber,
                   VP.YearsOfExperience, VP.Certificates, VP.Availability
            FROM Volunteer V
            INNER JOIN VolunteerProfile VP ON V.VolunteerID = VP.VolunteerID
            INNER JOIN skill S ON V.VolunteerID = S.SkillID
            WHERE S."{selected_skill}" = 1
        """).fetchall()

    conn.close()

    return render_template(
        'SearchVolunteers.html',
        skills=skills,
        search_results=search_results
    )

@app.route('/select_event_for_volunteers')
def select_event_for_volunteers():
    user_role = session.get('role')
    if user_role != 'organisation':
        flash("Only organisations can access this page.", "error")
        return redirect(url_for('index'))

    conn = get_db_connection()
    # Get all events created by this organisation
    events = conn.execute("""
        SELECT EventID, EventName
        FROM events
        WHERE CompanyID = (
            SELECT CompanyID FROM companies WHERE UserID = ?
        )
    """, (session.get('user_id'),)).fetchall()
    conn.close()

    return render_template('SelectEvent.html', events=events)

@app.route('/event_volunteers_dashboard/<int:event_id>')
def event_volunteers_dashboard(event_id):
    user_role = session.get('role')
    if user_role != 'organisation':
        flash("Only organisations can access this page.", "error")
        return redirect(url_for('index'))

    conn = get_db_connection()
    volunteers = conn.execute("""
        SELECT V.VolunteerID, V.FirstName, V.LastName, V.PhoneNumber,
               VP.YearsOfExperience, VP.Certificates, VP.Availability
        FROM volunteerevents VE
        JOIN volunteer V ON VE.VolunteerID = V.VolunteerID
        JOIN volunteerprofile VP ON V.VolunteerID = VP.VolunteerID
        WHERE VE.EventID = ?
    """, (event_id,)).fetchall()
    conn.close()

    return render_template('EventVolunteersDashboard.html', volunteers=volunteers)

@app.route('/manage_events')
def manage_events():
    conn = get_db_connection()
    events = conn.execute("SELECT * FROM Events ORDER BY EventDate ASC").fetchall()
    conn.close()
    return render_template('manage_events.html', events=events)

@app.route('/logout')
def logout():
    session.clear()
    flash("You have been logged out.", "success")
    return redirect(url_for('index'))

# ---------------- Run App ---------------- #
if __name__ == "__main__":
    app.run(debug=True)
