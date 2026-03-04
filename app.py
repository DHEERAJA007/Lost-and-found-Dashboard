from flask import Flask, render_template, request, redirect, session, url_for, flash
import mysql.connector

app = Flask(__name__)
app.secret_key = "supersecretkey"

db = mysql.connector.connect(
    host="localhost",
    user="karth",
    password="Dumbo.007",
    database="lost_found_db"
)
cursor = db.cursor(dictionary=True)

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        cursor.execute("SELECT * FROM users WHERE username=%s AND password=%s", (username, password))
        user = cursor.fetchone()

        if user:
            session['username'] = username
            flash("Login successful!", "success")
            return redirect(url_for('home'))
        else:
            flash("Invalid username or password!", "danger")
            return render_template('login.html')
    return render_template('login.html')


@app.route('/logout')
def logout():
    session.pop('username', None)
    flash("Logged out successfully.", "info")
    return redirect(url_for('login'))
@app.route('/')
def home():
    if 'username' not in session:
        return redirect(url_for('login'))

    cursor.execute("SELECT * FROM items ORDER BY date_reported DESC")
    data = cursor.fetchall()
    return render_template("index.html", items=data, username=session['username'])

@app.route('/add')
def add_page():
    if 'username' not in session:
        return redirect(url_for('login'))
    return render_template("add_item.html")

@app.route('/add_item', methods=['POST'])
def add_item():
    if 'username' not in session:
        return redirect(url_for('login'))

    name = request.form['item_name']
    desc = request.form['description']
    location = request.form['location']
    status = request.form['status']
    reporter = request.form['reporter_name']
    contact = request.form['reporter_contact']

    cursor.execute("""
        INSERT INTO items (item_name, description, location, date_reported, status, reporter_name, reporter_contact)
        VALUES (%s, %s, %s, CURDATE(), %s, %s, %s)
    """, (name, desc, location, status, reporter, contact))
    db.commit()
    return redirect('/')

@app.route('/claim/<int:item_id>')
def claim_item(item_id):
    if 'username' not in session:
        return redirect(url_for('login'))

    cursor.execute("UPDATE items SET status='Claimed' WHERE item_id=%s", (item_id,))
    db.commit()
    return redirect('/')

if __name__ == '__main__':
    app.run(debug=True)
