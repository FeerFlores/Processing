from time import sleep_ms
from MPU6050 import MPU6050

mpu = MPU6050()

while True:
    a = mpu.read_accel_data()   # m/s²
    g = mpu.read_gyro_data()    # °/s

    # ax ay az gx gy gz
    print("{:.2f} {:.2f} {:.2f} {:.2f} {:.2f} {:.2f}".format(
        a["x"], a["y"], a["z"],
        g["x"], g["y"], g["z"]
    ))

    sleep_ms(50)