# MissingChild_Hack36

### Domain : Tech Against Crime

### Problem Definition: 
1. Each year millions of children go missing around the globe.
2. Only about half of them are able to be traced by the authorities.
3. Remaining half often get trapped in crimes such as Child Kidnappings and Abduction , making them vulnerable to such brutal crimes.

### Objective of our project:
A Full Fledged (Web+Mobile) Application tracking system which allows citizens to confirm if an unattended child is missing or not using Facial Recognition by Comparison from our Database of Missing Children.

## Project Structure:
### Project has two Apps linked to each other:
1. **User Mobile App(Flutter)** : For Users to Report sighting of missing children.
2. **Admin Web App(Flask)** : For Admin from Concerned Authority who can see alerts when sightings are reported by users in our Mobile App.

### Google Maps used in our App for Sighting Location of missing child:

## Standard Solution being used t:
* Tracking a missing child using Manual investigation requires both time and experience (to ask right questions). 
* Most of the time, investigation method is time consuming as well as costly and can be unsuccessful if the person (missing) has been shifted/moved to different location (city/country).
* In such cases, the ideal approach is to go through CCTV footages and evidences. Again, this can be very time consuming and given the number of children that go missing everyday, it can be a challanage to keep up with it.

## Our Proposed Solution:
* By Using Machine learning & AI, build a Missing Children Tracking system on the go to assist Central authorities(Gov, NGOs etc).
* Here we will have a database of Missing people, and whenever someone try to ping any photo against it, an algorithm hits off thats start matching those photographs with available database using our Face Recognition Mode .
* It would allow the user to report exact location of sighting of the child using Google Maps.
* We will allow filters based on all info available of the missing child to search them from admin side in our Web App.
* From admin side, we also allow admin to add details of a child he spots an unattended child and upload his/her image with details in our Web App.
* It will be an open-source product and free-to-use application that citizens can use to identify if an unattended child is missing or not.

### Tech Stack:

* [Flutter](https://flutter.dev/) : For Android Application(User)
* [Flask](https://flask.palletsprojects.com/en/2.1.x/) : For Web Application(Admin)
* [DeepFace](https://pypi.org/project/deepface/) : For our Face Recognition( pre-trained FaceNet512 Model accuracy of 99.45%)
* [Firebase](https://firebase.google.com/?gclsrc=aw.ds)  : For Database
* [Google Maps API](https://developers.google.com/maps) : For Reporting Sighted location of unattended Child

## Contributors (Team Cryptasylum)
- Shrikant Sahu
- Rishabh Kothari
- R. Vishal
- Piyush Sharma
