import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

# Gmail account details
# sender_email = 'covid19.detectionsystem@gmail.com'
sender_email = 'ulteriortea@gmail.com'
app_password = 'baoevuvxmoiaqrqb'

def send_email(to_email, subject, body):
    try:
        # Create a multipart message and set the headers
        msg = MIMEMultipart()
        msg['From'] = sender_email
        msg['To'] = to_email
        msg['Subject'] = subject

        # Attach the message to the email
        msg.attach(MIMEText(body, 'plain'))

        # Connect to the Gmail SMTP server
        with smtplib.SMTP('smtp.gmail.com', 587) as server:
            # Start TLS encryption
            server.starttls()

            # Log in to your Gmail account using app password
            server.login(sender_email, app_password)

            # Send the email
            server.sendmail(sender_email, to_email, msg.as_string())

        print('Email sent successfully to', to_email)
    except Exception as e:
        print('An error occurred while sending the email:', str(e))
