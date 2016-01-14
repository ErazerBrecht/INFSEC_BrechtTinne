import subprocess
import smtplib
import socket
from email.mime.text import MIMEText
import datetime

# Verander naar eigen accunt informatie
to = 'tinne.vdabb@skynet.be'
gmail_user = 'penpi2.tinnebrecht@gmail.com'
gmail_password = 'TINNEBRECHT'

#smtp server = simple mail transfer protocol server
smtpserver = smtplib.SMTP('smtp.gmail.com', 587)

#ehlo (helo) identificeert dat de server de verbinding initieert
smtpserver.ehlo()
smtpserver.starttls()
smtpserver.ehlo
smtpserver.login(gmail_user, gmail_password)
today = datetime.date.today()
# Very Linux Specific
arg='ip route list'
p=subprocess.Popen(arg,shell=True,stdout=subprocess.PIPE)
data = p.communicate()
split_data = data[0].split()
ipaddr = split_data[split_data.index('src')+1]

#opent het text bestand met deze naam
file = open('password.txt', 'r')

# msg = message
# MIMEText hebben we vanboven geïmporteerd.
# file die gelezen word door read functie is de file die hierboven gedefinieerd wordt.
msg = MIMEText(file.read())
msg['Subject'] = 'Password from RaspberryPi on %s' % today.strftime('%b %d %Y')
msg['From'] = gmail_user
msg['To'] = to
smtpserver.sendmail(gmail_user, [to], msg.as_string())
smtpserver.quit()
