from flask import Flask, render_template, request, redirect, url_for

app = Flask(__name__)

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
    selected_account_type = None

    if request.method == 'POST':
        # Get the selected account type from the form
        selected_account_type = request.form.get('account-type')

        # You can add logic here to handle volunteer vs organisation
        # For now, just stay on the registration page and maybe show a message
        # Example: pass it to the template
        # flash(f"You selected {selected_account_type}") # optional message

    # Render the registration page, passing the selected option if any
    return render_template('registration.html', selected_account_type=selected_account_type)

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
