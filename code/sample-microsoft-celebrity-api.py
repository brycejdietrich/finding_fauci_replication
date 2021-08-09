"""
Use Microsoft Azure API - face and celebrity detection

Built upon Microsoft Azure resource:
https://docs.microsoft.com/en-us/azure/cognitive-services/computer-vision/quickstarts-sdk/client-library?tabs=visual-studio&pivots=programming-language-python

This example takes the images from data/images and produces output in output/image_output. This code will NOT work until
information in lines 29 and 36-41 are replaced with your project's information.

Additional notes:
1. Require's microsoft subscription key
2. All images need to be uploaded to Microsoft's cloud
"""

from azure.cognitiveservices.vision.computervision import ComputerVisionClient
from azure.cognitiveservices.vision.computervision.models import OperationStatusCodes
from azure.cognitiveservices.vision.computervision.models import VisualFeatureTypes
from msrest.authentication import CognitiveServicesCredentials

from array import array
import csv
import os
import pandas as pd
from PIL import Image
import sys
import time

#Authenticate
subscription_key = "###################"   #"<your subscription key>"
endpoint = "https://face-celebrity.cognitiveservices.azure.com/"    #"<your API endpoint>"

computervision_client = ComputerVisionClient(endpoint, CognitiveServicesCredentials(subscription_key))


# set directories
username = "YOUR_USER_NAME_HERE"
dirname = "/Users/" + username + "/path/to/data/"

img_dir = dirname + "path/to/images/"
img_cloud_dir = 'https://myaccount.blob.core.windows.net/mycontainer/myblob' #described here: https://docs.microsoft.com/en-us/rest/api/storageservices/get-blob
out_dir = dirname + "path/to/output/"

def writefilename(path, extension):
    '''
    Microsoft Azure dislikes direct url converting (e.g. img_cloud_dir + filename)
    Therefore, this function stores url names and create output csv file

    input: folder path(str) and file extension (str)
    output: csv file
    '''

    fileList = [img_cloud_dir + file for file in os.listdir(path) if file.endswith('.' + extension)]
    outputfile = out_dir + 'microsoft-api-url.csv'

    df = pd.DataFrame(fileList)
    df.columns = ['urls']
    df.to_csv(outputfile, index = False)


def imageurl(inputfile):
    '''
    input: csv file with urls
    return: remote_image_url(list)
    '''
    global remote_image_url

    with open(inputfile) as input_file:
        reader = csv.reader(input_file, delimiter = ',')
        next(reader)
        temp_list = [line for line in reader]

    remote_image_url = [line[0] for line in temp_list]

    return remote_image_url


def detection(urllist):
    '''
    detect face and celebrities in the file (url form; not local)
    input: urllist for Mircosoft api
    return: temp_faceout(list), errorList_face(list), temp_celebrityout(list), errorList_celebrity(list)
    '''
    print('********** DETECTION: #file is ' + str(len(urllist)) + ' **********')

    remote_image_url = urllist

    #face detection setup
    global temp_faceout
    global errorList_face
    temp_faceout = list()
    errorList_face = list()
    remote_image_features = ["faces"]

    #celebrity detection setup
    global temp_celebrityout
    global errorList_celebrity
    temp_celebrityout = list()
    errorList_celebrity = list()

    #loop through each url image
    for image in remote_image_url:
        filename = image.replace(image_cloud_dir, "")

        #face detection#
        detect_faces_results_remote = computervision_client.analyze_image(image, remote_image_features)
        if (len(detect_faces_results_remote.faces) == 0):
            print("No faces detected in " + filename)

        else:
            face_counter = 0
            face_count = len(detect_faces_results_remote.faces)

            try:
                for face in detect_faces_results_remote.faces:
                    face_counter += 1
                    face_num = 'face' + str(face_counter)
                    temp_gender = face.gender
                    temp_gender = temp_gender.replace("Gender.", "")
                    temp_age = face.age

                    temp_left = face.face_rectangle.left
                    temp_top =  face.face_rectangle.top
                    temp_width = face.face_rectangle.width
                    temp_height = face.face_rectangle.height
                    temp_bound = [[temp_left, temp_top],[temp_left+temp_width, temp_top],[temp_left+temp_width, temp_top+temp_height], [temp_left, temp_top+temp_height]]

                    temp_list = [filename, face_count, face_num, temp_gender, temp_age, temp_bound, temp_left, temp_top, temp_width, temp_height]
                    temp_faceout.append(temp_list)

            except:
                errorList_face.append(image) #append filenames when error occurs
                print('Face detection error occurs with ' + filename)

        #celebrity detection#
        detect_domain_results_celebs_remote = computervision_client.analyze_image_by_domain("celebrities", image)
        if len(detect_domain_results_celebs_remote.result["celebrities"]) == 0:
            print("No celebrities detected in " + filename)

        else:
            celebrity_counter = 0
            celebrity_count = len(detect_domain_results_celebs_remote.result["celebrities"])

            try:
                for celeb in detect_domain_results_celebs_remote.result["celebrities"]:
                    celebrity_counter += 1
                    celeb_num = 'celebrity' + str(celebrity_counter)
                    temp_confidence = celeb["confidence"]
                    temp_name = celeb["name"]
                    temp_left = celeb["faceRectangle"]["left"]
                    temp_top = celeb["faceRectangle"]["top"]
                    temp_width = celeb["faceRectangle"]["width"]
                    temp_height = celeb["faceRectangle"]["height"]
                    temp_bound = [[temp_left, temp_top],[temp_left+temp_width, temp_top],[temp_left+temp_width, temp_top+temp_height], [temp_left, temp_top+temp_height]]

                    temp_list = [filename, celebrity_count, celeb_num, temp_confidence, temp_name, temp_bound, temp_left, temp_top, temp_width, temp_height]
                    temp_celebrityout.append(temp_list)

            except:
                errorList_celebrity.append(image) #append filenames when error occurs
                print('Celebrity detection error occurs with ' + image)

        time.sleep(5)
    return temp_faceout, errorList_face, temp_celebrityout, errorList_celebrity


def filewrite(temp_output, errorList, task, colname_list):
    '''
    write cs file of face detection result or object detection result
    input: temp_output(list), errorList(list), task(str), colname_list(list)
    output: write outputfile csv file and error csv file
    '''
    outputfile = out_dir + 'microsoft-api-' + task + '-result.csv'

    df = pd.DataFrame(temp_output)
    df.columns = colname_list
    df.to_csv(outputfile, index = False)

    errorfile = out_dir + 'microsoft-api-' + task + '-errors.csv'
    if errorList != []:
        df_error = pd.DataFrame({"errorfile": errorList})
        df_error.to_csv(errorList, index = False)


def main():

    writefilename(img_dir, 'jpg')
    outputfile = out_dir + 'microsoft-api-url.csv'
    imageurl(outputfile)

    #detection -- both face and celebrity
    detection(remote_image_url)

    #face detection - result file
    face_colname = ['filename', 'num_faces', 'face', 'gender', 'age', 'face_bound', 'left', 'top', 'width', 'height']
    filewrite(temp_faceout, errorList_face, 'face', face_colname)

    #celebrity detection - result file
    celebrity_colname = ['filename', 'num_celebrities', 'celebrity', 'detection_confidence', 'name', 'face_bound', 'left', 'top', 'width', 'height']
    filewrite(temp_celebrityout, errorList_celebrity, 'celebrity', celebrity_colname)


main()
