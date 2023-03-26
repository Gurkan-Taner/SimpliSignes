import socket
import cv2
import numpy as np

HOST = "192.168.208.153"
PORT = 8123

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

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.bind((HOST, PORT))
    s.listen()
    while True:
        conn, addr = s.accept()
        with conn:
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
                    cv2.imshow('Video Stream', bgr_frame)
                    #cv2.imwrite(f"frame_{frame_number:04d}.png", bgr_frame)
                    frame_number += 1

                key = cv2.waitKey(1) & 0xFF
                if key == ord("q"):
                    break

cv2.destroyAllWindows()
