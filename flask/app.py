from flask import Flask, request, jsonify
from flask_mysqldb import MySQL
import MySQLdb.cursors
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from flask import Flask, request, jsonify
from send_email import send_email  
import smtplib

app = Flask(__name__)

# Database configuration
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'ulterior'
app.config['MYSQL_PORT'] = 3306

mysql = MySQL(app)

@app.route('/register', methods=['POST'])
def register():
    try:
        data = request.get_json()  # Get JSON data from request
        username = data['username']  # Access username from JSON
        password = data['password']
        first_name = data['first_name']
        last_name = data['last_name']
        email = data['email']
        
        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO users (user_name, password, first_name, last_name, email) VALUES (%s, %s, %s, %s, %s)",
                    (username, password, first_name, last_name, email))
        mysql.connection.commit()
        cur.close()
        
        # Send registration confirmation email
        subject = 'Registration Successful'
        body = f"Dear {first_name} {last_name},\n\n"
        body += "Thank you for registering with us!\n"
        body += "You can now login to your account.\n\n"
        body += "Best regards,\n"
        body += "Ulterior Tea."

        send_email(email, subject, body)

        return jsonify({'message': 'User registered successfully'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.route('/login', methods=['POST'])
def login():
    try:
        username = request.form['username']
        password = request.form['password']
        
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cur.execute("SELECT * FROM users WHERE user_name = %s AND password = %s", (username, password))
        user = cur.fetchone()
        
        if user:
            return jsonify({'message': 'Login successful'}), 200
        else:
            return jsonify({'message': 'Incorrect username or password'}), 401
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
@app.route('/submit_feedback', methods=['POST'])
def submit_feedback():
    try:
        username = request.form['username']
        feedback = request.form['feedback']
        rating = request.form['rating']
        
        cur = mysql.connection.cursor()
        cur.execute("UPDATE users SET feedback = %s, rating = %s WHERE user_name = %s", (feedback, rating, username))
        mysql.connection.commit()
        cur.close()
        
        return jsonify({'message': 'Feedback submitted successfully'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
@app.route('/change_password', methods=['POST'])
def change_password():
    try:
        username = request.form['username']
        new_password = request.form['new_password']
        
        cur = mysql.connection.cursor()
        cur.execute("UPDATE users SET password = %s WHERE user_name = %s", (new_password, username))
        mysql.connection.commit()
        cur.close()
        
        return jsonify({'message': 'Password changed successfully'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    

@app.route('/check_email', methods=['POST'])
def check_email():
    try:
        data = request.get_json()  # Get JSON data from request
        email = data['email']  # Access email from JSON
        
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cur.execute("SELECT * FROM users WHERE email = %s", [email])
        user = cur.fetchone()
        
        if user:
            return jsonify({'exists': True}), 200
        else:
            return jsonify({'exists': False}), 200
    except Exception as e:
        print(f"Error in check_email endpoint: {str(e)}")  # Print detailed error message
        return jsonify({'error': str(e)}), 500
    
if __name__ == '__main__':
    app.run(debug=True)
