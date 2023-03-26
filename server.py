import socket
import cv2
import mediapipe as mp
import numpy as np
import tensorflow as tf
from PIL import Image
from tensorflow import keras
from matplotlib import pyplot as plt

HOST = "192.168.0.18"
PORT = 65432

def recvall(sock, n):
    data = bytearray()
    while len(data) < n:
        packet = sock.recv(n - len(data))
        if not packet:
            return None
        data.extend(packet)
    return data

def recvall_until_delimiter(sock, delimiter):
    data = bytearray()
    delimiter_len = len(delimiter)
    print(f"delimiter_len={delimiter_len}")
    while True:
        byte = sock.recv(1)
        if not byte:
            return None
        data.extend(byte)
        if data[-delimiter_len:] == delimiter:
            print(data[-delimiter_len:])
            print(f"Current data length: {len(data)}")
            break
    return data[:-delimiter_len]

mp_drawing = mp.solutions.drawing_utils
mp_drawing_styles = mp.solutions.drawing_styles
mp_hands = mp.solutions.hands
model1 = keras.models.load_model('./model.h5')

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s, mp_hands.Hands(
    model_complexity=0,
    min_detection_confidence=0.5,
    min_tracking_confidence=0.5) as hands:
    s.bind((HOST, PORT))
    s.listen()
    conn, addr = s.accept()
    while conn:
        #with conn:
            print(f"Connected by {addr}")
            width = int.from_bytes(recvall(conn, 4), byteorder='big')
            height = int.from_bytes(recvall(conn, 4), byteorder='big')
            print(f"Received width={width} and height={height}")
            frame_number = 0;
            delimiter = b'\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF'

            while True:
                #yuv_data = recvall(conn, width * height * 3 // 2)  # Adjust this according to the specific YUV format
                frame_length_data = recvall(conn, 4)
                if not frame_length_data:
                    break
                frame_length = int.from_bytes(frame_length_data, byteorder='big')
                print(f"FRAME_LENGTH={frame_length}")
                #yuv_data = recvall_until_delimiter(conn, delimiter)
                yuv_data = recvall(conn, frame_length)
                if yuv_data is None:
                    break
                expected_size = height * 3 // 2 * width
                received_size = len(yuv_data)
                print(f"Expected size: {expected_size}, received size: {received_size}")

                yuv_frame = np.frombuffer(yuv_data, dtype=np.uint8).reshape((height * 3 // 2, width))
                bgr_frame = cv2.cvtColor(yuv_frame, cv2.COLOR_YUV2BGR_I420)  # Change this according to the specific YUV format

                if bgr_frame is not None:
                    results = hands.process(bgr_frame)
                    font = cv2.FONT_HERSHEY_PLAIN
                    scale = 1.0
                    color = (255, 255, 255)
                    x_pos = 10
                    y_pos = bgr_frame.shape[0] - 10


                    coords=[]
                    if results.multi_hand_landmarks:
                        frame_count = 1
                        for hand_no, hand_landmarks in enumerate(results.multi_hand_landmarks):
                
                            for i in range(21):
                                lm = hand_landmarks.landmark[i]
                                x, y, z = lm.x, lm.y, lm.z
                                if hand_no == 0:
                                    hand = "Left"
                                else:
                                    hand = "Right"
                                name = i+1
                                coords.append([hand_no+1, name, x, y, z,frame_count])
                        
                            coord_rs = coords                    
                            live_pred = model1.predict(coord_rs)
                
                            affichage = live_pred
                            text = f"Prediction : {affichage}"
                
                            #bgr_frame = cv2.putText(bgr_frame, text, (int(x_pos), int(y_pos)), font, scale, color, thickness = 2)
                            conn.send(text.encode('utf-8'))
                            mp_drawing.draw_landmarks(
                                bgr_frame,
                                hand_landmarks,
                                mp_hands.HAND_CONNECTIONS,
                                mp_drawing_styles.get_default_hand_landmarks_style(),
                                mp_drawing_styles.get_default_hand_connections_style())

                    cv2.imshow('Video Stream', bgr_frame)
                    #cv2.imwrite(f"frame_{frame_number:04d}.png", bgr_frame)
                    frame_number += 1

                key = cv2.waitKey(1) & 0xFF
                if key == ord("q"):
                    break

cv2.destroyAllWindows()
