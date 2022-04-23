# from distutils.command.config import config
import pyrebase

config = {
    "apiKey": "AIzaSyC1IrB995nClG5Aj8TD7FcGsg9adLSSZxg",
    "authDomain": "kjsce-hack-6.firebaseapp.com",
    "databaseURL": "https://kjsce-hack-6-default-rtdb.firebaseio.com",
    "projectId": "kjsce-hack-6",
    "storageBucket": "kjsce-hack-6.appspot.com",
    "messagingSenderId": "732851077638",
    "appId": "1:732851077638:web:2b58fb2f26de96c6f97987",
    "measurementId": "G-3ZX7MZNR6T"
}

firebase = pyrebase.initialize_app(config)

db = firebase.database()
def get_alerts():
    result = db.child("Alert_Details").get()
    return result



# children = db.child("Missing_Details").child().get()
# c = children.val()
# k = c.values()
# for i in k:
#     print(i["Age"])

# class dbservice:
#     def __init__(self):
#         self.connector = None
#         self.dbcursor = None
#         self.connect_database()
#         self.create_table()
    
#     def connect_database(self):
#         self.connector = mysql.connect(host='127.0.0.1', user='root', password='mysql27')

#         self.dbcursor = self.connector.cursor()
#         self.dbcursor.execute('USE Library')
    
#     def signin_user(self, table_name, input_data):
#         paswd = input_data["Password"]
#         user = input_data["Username"]
#         print(paswd)
#         #Preparing Query
#         pwd = (f"SELECT Username FROM {table_name} WHERE Password = %(paswd)s")
#         try:
#             self.dbcursor.execute(pwd,{'paswd':paswd})
#             records = self.dbcursor.fetchone()
            
#             if records == None:
#                 return 0
#             else:
#                 return 1
#         except Exception as e:
#             print(e)
#         return 0