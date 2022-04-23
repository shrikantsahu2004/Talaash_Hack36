
import re
from threading import Lock
from distutils.log import debug
from email import message
from email.mime import base
from fileinput import filename
from msilib.schema import Error
from cv2 import redirectError
from numpy import broadcast
import pyrebase
from flask import Flask, render_template, request, url_for, redirect, flash, jsonify, make_response, url_for

from werkzeug.utils import secure_filename

# for login ----------------------
# from flask_sqlalchemy import SQLAlchemy
# from flask_login import UserMixin

# class User(db.Model, UserMixin):
#     id = db.Column(db.Integer, primary_key=True)
#     username = db.Column(db.String(20),nullable=False)
#     password = db.Column(db.String(80),nullable=False)

# from dbservices import dbservices
from datetime import datetime
from datetime import timedelta

import matplotlib as plt
import base64
from PIL import Image
import io
import os
import shutil
import codecs
import uuid

import base64
import requests
import json
import cv2

from dbservices import get_alerts

from model import face_comparison


import firebase_admin
from firebase_admin import credentials
from firebase_admin import db as admin_db

# from flask_socketio import SocketIO, emit, disconnect
# async_mode = None

app = Flask(__name__)

if __name__ == '__main__':
    app.run(debug=True)
    
app.secret_key = "super_secret_key"
app_root = os.path.dirname(os.path.abspath(__file__))
UPLOAD_FOLDER = './static/uploaded_image/'
ALLOWED_EXTENSIONS = set(['png', 'jpg', 'jpeg', 'gif'])
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER


# socketio = SocketIO(app, cors_allowed_origins="*")
# thread = None
# thread_lock = Lock()

# config = {
#     "apiKey": "AIzaSyC1IrB995nClG5Aj8TD7FcGsg9adLSSZxg",
#     "authDomain": "kjsce-hack-6.firebaseapp.com",
#     "databaseURL": "https://kjsce-hack-6-default-rtdb.firebaseio.com",
#     "projectId": "kjsce-hack-6",
#     "storageBucket": "kjsce-hack-6.appspot.com",
#     "messagingSenderId": "732851077638",
#     "appId": "1:732851077638:web:2b58fb2f26de96c6f97987",
#     "measurementId": "G-3ZX7MZNR6T",
#     "serviceAccount": "services\kjsce-hack-6-firebase-adminsdk-syajz-7cc4f5b3f5.json"
# }
# Login db_new-----------------------------------------------
# db_new = SQLAlchemy(app)
# app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///database.db'
# app.config['SECRET_KEY'] = 'thisisasecretkey'

config = {
    "apiKey": "AIzaSyCN7ZMLr6u4ZSg6Lfo9UDhwO0DSMoaem0Q",
    "authDomain": "hack36-96442.firebaseapp.com",
    "databaseURL": "https://hack36-96442-default-rtdb.firebaseio.com",
    "projectId": "hack36-96442",
    "storageBucket": "hack36-96442.appspot.com",
    "messagingSenderId": "147590467158",
    "appId": "1:147590467158:web:f7a248869bd178af3c35f7"
}

firebase = pyrebase.initialize_app(config)

# Firebase authentication : Email and Password
auth = firebase.auth()
# email = input("Enter email: \n")
# password = input("Enter password: \n")
# user = auth.create_user_with_email_and_password(email,password)
# user = auth.sign_in_with_email_and_password(email, password)
# print(user['registered'])


##############################################################################################
db = firebase.database()

cred = credentials.Certificate(
    "services\hack36-96442-firebase-adminsdk-3dgwe-c39d3b02be.json")

firebase_admin.initialize_app(cred, {
    "databaseURL": "https://hack36-96442-default-rtdb.firebaseio.com",
    "databaseAuthVariableOverride": None
})


# Fetch missing details, alert details and missing images from database
def get_missing_details():
    print("Fetching missing details from database")
    global k1
    db = firebase.database()
    missing_child = db.child("Missing_Details").child().get()
    mc = missing_child.val()
    k1 = mc.values()
    fetch_missing_db(k1)


def get_alert_details():
    global k2
    db = firebase.database()
    child_alert = db.child("Alert_Details").child().get()
    ca = child_alert.val()
    k2 = ca.values()


def fetch_missing_db(k1):
    cur_dir = os.getcwd()
    inner_dir = 'static/child_images/'
    dir_path = os.path.join(cur_dir, inner_dir)
    if os.path.exists(dir_path) and os.path.isdir(dir_path):
        shutil.rmtree(dir_path)
    os.mkdir(dir_path)
    for i, imageData in enumerate(k1):
        if "Image" in imageData:
            image = imageData["Image"]
            imageId = imageData["Id"]
            image = base64.b64decode(image)
            filename = dir_path + "child_" + str(imageId) + ".jpg"
            with open(filename, 'wb') as f:
                f.write(image)


k1 = None
k2 = None

get_missing_details()
get_alert_details()

user = None
# @socketio.on('connect')
# def test_connect():
#     print("Server Connected")


# @socketio.on('client connected')
# def test_client_connect(message):
#     print(message)
#     print("Client Connected")
#     emit("check", {"data": "Success"})

#     # emit('my response', {'data': 'Connected'})


# @socketio.on('disconnect')
# def test_disconnect():
#     print('Client disconnected')


# @socketio.on('my_event')
# def test_message(message):
#     emit('some event', {'data': 42}, broadcast=True)
#     print(message)


def ignore_first_call(fn):
    called = False

    def wrapper(*args, **kwargs):
        nonlocal called
        if called:
            return fn(*args, **kwargs)
        else:
            called = True
            return None

    return wrapper


@ignore_first_call
def missing_details_handler(event):
    print(event.event_type)  # put
    if(event.event_type == "put" or event.event_type == "patch"):
        get_missing_details()


        # data = event.path.split("/")
        # doc_id = data[1]
        # doc_attr = data[2]
        # data_to_change = db.child("Missing_Details").child(doc_id).get().val()
        # Id = data_to_change["Id"]
        # filter(lambda x: x[], A)
        # print(data)
        # print(event.data)
admin_db.reference('Missing_Details').listen(missing_details_handler)


@ignore_first_call
def alert_details_handler(event):
    print(event.event_type)  # put
    if(event.event_type == "put" or event.event_type == "patch"):
        get_alert_details()


admin_db.reference('Alert_Details').listen(alert_details_handler)


# Different routes
@app.route('/', methods=["GET"])
def homepage():
    return render_template('index.html')


@app.route('/login', methods=['GET', 'POST'])
def login():
    if auth.current_user and auth.current_user['localId']:
        return redirect("/home")
    error = None
    if request.method == 'POST':
        print(request.method)
        email = request.form['email']
        password = request.form['password']
        print(email)
        print(password)
        global user
        user = None
        try:
            user = auth.sign_in_with_email_and_password(email, password)
            auth.get_account_info(user['idToken'])
            if user:
                return redirect(url_for('home'))
        except Exception as e:
            print(e)
            return render_template('login.html', error="Invalid Credentials")
        # else:
        #     return render_template('login.html', error=error)
    return render_template('login.html', error=error)
# print(user['registered'])

# @app.route('/register',methods=['POST','GET'])
# def register():
#     return render_template('register.html')


@app.route('/logout', methods=['GET', 'POST'])
def logout():
    if request.method == "POST":
        global auth
        auth.current_user = None
        print(auth.current_user)
        return render_template('index.html')


@app.route('/home', methods=['POST', 'GET'])
def home():
    if(auth.current_user and auth.current_user['localId']):
        if request.method == "POST":
            search = request.form['search']
            filter_name = request.form['filter']
            tmp = [x for x in k1 if re.search(
                search.lower(), x[filter_name].lower()) is not None]
            return render_template('home.html', val=tmp)
        return render_template('home.html', val=k1)
    else:
        return redirect(url_for('login'))


@app.route('/missing_desc/<id>/', methods=['POST', 'GET'])
def missing_desc(id):
    if(auth.current_user and auth.current_user['localId']):
        for i in k1:
            if i["Id"] == id:
                temp = i
        return render_template('description.html', details=temp)
    else:
        return redirect(url_for('login'))

    # return render_template('decription.html')


@app.route('/alerts', methods=['POST', 'GET'])
def alerts():
    if(auth.current_user and auth.current_user['localId']):
        if request.method == "POST":
            search = request.form['search']
            filter_name = request.form['filter']
            tmp = [x for x in k2 if re.search(
                search.lower(), x[filter_name].lower()) is not None]
            return render_template('alerts.html', val=tmp)
        return render_template('alerts.html', val=k2)
    else:
        return redirect(url_for('login'))


@app.route('/alert_desc/<id>/', methods=['POST', 'GET'])
def alert_desc(id):
    if(auth.current_user and auth.current_user['localId']):
        for i in k1:
            if i["Id"] == id:
                temp1 = i
        lst = []
        for i in k2:
            if i["Id"] == id:
                temp2 = i
        return render_template('alert_description.html', details=temp1, val2=temp2)
    else:
        return redirect(url_for('login'))


@app.route('/add_child', methods=['POST', 'GET'])
def add_child():
    if(auth.current_user and auth.current_user['localId']):
        if request.method == 'POST':
            name = request.form.get('name')
            age = request.form.get('age')
            file = request.files['file']
            print(file)
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            loc = "./static/uploaded_image/" + filename
            with open(loc, "rb") as img_file:
                b64_string = base64.b64encode(img_file.read())
            k = b64_string.decode('utf-8')
            os.remove(loc)
            gender = request.form.get('gender')
            weight = request.form.get('weight')
            height = request.form.get('height')
            missing_from = request.form.get('missing_from')
            missing_date = request.form.get('missing_date')
            id = str(uuid.uuid4())[0:6]
            print(name, age, id, gender, weight,
                  height, missing_date, missing_from)
            db.child("Missing_Details").push({
                "Id": id,
                "Name": name,
                "Age": age,
                "Sex": gender,
                "Weight": weight,
                "Height": height,
                "Missing_From": missing_from,
                "Missing_date": missing_date,
                "Image": k
            })
        return render_template('add_child.html')
    else:
        return redirect(url_for('login'))


@app.route('/report_sighting', methods=['POST'])
def report_desc():
    if request.method == 'POST':
        request_data = request.get_json()
        aloneStatus = None
        address = None
        contact = None
        image = None

        if "address" in request_data:
            address = request_data["address"]
        else:
            return jsonify(
                status="error",
                message="address must be provided",
            )
        if "aloneStatus" in request_data:
            aloneStatus = request_data["aloneStatus"]
        else:
            return jsonify(
                status="error",
                message="alone status must be provided",
            )
        if "contact" in request_data:
            contact = request_data["contact"]

        if "image" in request_data:
            # try:
            image = request_data["image"]
            image = base64.b64decode(image)

            filename = 'static/input.jpg'  # I assume you have a way of picking unique filenames

            with open(filename, 'wb') as f:
                f.write(image)

            print(filename)
            result = face_comparison(filename, 'static/child_images')

            print(result)

            if result is None:
                return jsonify(status="error", message="No face detected")

            with open(result[0], "rb") as img_file:
                image_64_encode = base64.b64encode(img_file.read())
            image_64_encode = str(image_64_encode)[2:-1]

            # print(image_64_encode)

            data = {'image': image_64_encode, "match_percent": result[1]}

            child_alert = db.child("Alert_Details")
            child_id = result[0].split("/")[-1].split(".")[0].split("_")[-1]

            missing_child = None
            for i in k1:
                if i["Id"] == child_id:
                    missing_child = i
                    break

            print(missing_child)

            alert_data = {
                "Alone": aloneStatus,
                "Contact": contact if contact is not None else "",
                "Location": address,
                'Image': str(image_64_encode),
                "Id": missing_child["Id"],
            }

            child_alert.push(alert_data)

            get_alert_details()

            return jsonify(
                status="success",
                message="Face detected",
                image=str(image_64_encode),
                match_percent=result[1],
                missing_child=missing_child
            )


@app.errorhandler(404)
def not_found(e):
    return render_template("404.html")
