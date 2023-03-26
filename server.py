import socket
import cv2
import numpy as np

HOST = "192.168.226.104"
PORT = 8123

def recvall(sock, n):
    data = bytearray()
    while len(data) < n:
        packet = sock.recv(n - len(data))
        if not packet:
            return None
        data.extend(packet)
    return data

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.bind((HOST, PORT))
    s.listen()
    while True:
        conn, addr = s.accept()
        with conn:
            print(f"Connected by {addr}")

            width = int.from_bytes(recvall(conn, 4), byteorder='big')
            height = int.from_bytes(recvall(conn, 4), byteorder='big')

            while True:
                yuv_data = recvall(conn, width * height * 3 // 2)  # Adjust this according to the specific YUV format
                if yuv_data is None:
                    break

                yuv_frame = np.frombuffer(yuv_data, dtype=np.uint8).reshape((height * 3 // 2, width))
                bgr_frame = cv2.cvtColor(yuv_frame, cv2.COLOR_YUV2BGR_I420)  # Change this according to the specific YUV format

                if bgr_frame is not None:
                    cv2.imshow('Video Stream', bgr_frame)

                key = cv2.waitKey(1) & 0xFF
                if key == ord("q"):
                    break

cv2.destroyAllWindows()
