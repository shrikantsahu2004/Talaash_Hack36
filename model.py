
import matplotlib.pyplot as plt
import os

import sys
import cv2
from deepface import DeepFace
import matplotlib
matplotlib.use('Agg')


models = ["VGG-Face", "Facenet", "Facenet512",
          "OpenFace", "DeepFace", "DeepID", "ArcFace", "Dlib"]


def face_comparison(upload_img, db_path):
    print(upload_img)
    print(db_path)

    df = DeepFace.find(upload_img, db_path, detector_backend='mtcnn',
                       enforce_detection=False, model_name=models[1])
    image_info = []
    try:
        og = cv2.imread(upload_img)
        og = cv2.resize(og, (180, 250), interpolation=cv2.INTER_AREA)
        # print(og)
        plt.subplot(1, 2, 1)
        plt.imshow(og[:, :, ::-1])
        plt.axis('off')
        plt.title('Target Image')

        print(df.columns)
        if(len(df) == 0):
            print("Match Not Found!")
            return None
        else:

            if(len(df) == 1):
                img_path = df.iloc[0].identity
                accuracy = (1 - df.iloc[0].Facenet_cosine)*100
                image_info.append(img_path)
                image_info.append(accuracy)

            else:
                # Here if image is in same directory then index-1 else index 0
                img_path = df.iloc[0].identity
                accuracy = (1-df.iloc[0].Facenet_cosine)*100
                image_info.append(img_path)
                image_info.append(accuracy)

            print("Image_info: ", image_info)
            print("Image Path is:", img_path)
            print(" % Match is:", accuracy)

            file_1 = cv2.imread(img_path)
            file_1 = cv2.resize(file_1, (180, 250),
                                interpolation=cv2.INTER_AREA)
            # print(file_1)
            # plt.figure(figsize=(4, 4))
            plt.subplot(1, 2, 2)
            plt.imshow(file_1[:, :, ::-1])
            plt.axis('off')
            plt.title('Best Match Found')
            return image_info
            # plt.show()
            # print(file_1)
    except Exception as e:
        print(e)
        print("Image Error!!!")
        return None
