import time
import board
import busio
import struct
from adafruit_pca9685 import PCA9685
from adafruit_motor import servo
import random

SERVO_MIN_ANGLE = 0   # Minimum angle for the servos
SERVO_MAX_ANGLE = 180  # Maximum angle for the servos
NEUTRAL_ANGLE = 90     # Neutral angle for flat plate

def clamp(value, min_value, max_value):
    """Clamp the value between min_value and max_value."""
    return max(min_value, min(value, max_value))

class ServoManager:
    
    def __init__(self, i2c):
        self.servos = []
        self.pca = PCA9685(i2c)

        # Set the PWM frequency to 60hz.
        self.pca.frequency = 60

        
        # physical servo arrangement:
        #    0   Up - down
        #    1   Left - right
        
        for no in range(0,2):
            self.servos.append(servo.Servo(self.pca.channels[no]))
            
    def set_servo_angles(self,x, y, max_tilt_angle=45):
        """
        Given X and Y coordinates (in some desired range, e.g., -1 to 1), this function
        calculates the servo angles for four servos controlling the corners of the plate.
        
        Args:
            x (float): Desired X direction (from -1 to 1).
            y (float): Desired Y direction (from -1 to 1).
            max_tilt_angle (float): Maximum tilt angle for the servos in any direction.
            
        """
        
        # Clamp X and Y to the range [-1, 1]
        x = clamp(x, -1, 1)
        y = clamp(y, -1, 1)

        # Calculate the tilt contribution from X and Y direction
        x_tilt = max_tilt_angle * x
        y_tilt = max_tilt_angle * y
        
        upDownAngle = NEUTRAL_ANGLE + (y*max_tilt_angle)
        leftRightAngle = NEUTRAL_ANGLE + (x*max_tilt_angle)
        
        self.set_positions(upDownAngle,leftRightAngle)
        print("x:",x,"y:",y,"Updown:",upDownAngle,"LeftRight:", leftRightAngle)
        
    def set_positions(self,v0,v1):
        self.servos[0].angle = 180-v0
        self.servos[1].angle = v1
        
    def point_up(self):
        self.servos[0].angle=178

    def point_down(self):
        self.servos[0].angle=00

    def point_forwards(self):
        self.servos[0].angle=00

    def point_left(self):
        self.servos[1].angle=178

    def point_right(self):
        self.servos[1].angle=00

    def update_position(self,servo,update):
        self.servos[servo].angle = self.servos[servo].angle + update


# The person sensor has the I2C ID of hex 62, or decimal 98.
PERSON_SENSOR_I2C_ADDRESS = 0x62
  
# We will be reading raw bytes over I2C, and we'll need to decode them into
# data structures. These strings define the format used for the decoding, and
# are derived from the layouts defined in the developer guide.
PERSON_SENSOR_I2C_HEADER_FORMAT = "BBH"
PERSON_SENSOR_I2C_HEADER_BYTE_COUNT = struct.calcsize(
    PERSON_SENSOR_I2C_HEADER_FORMAT)

PERSON_SENSOR_FACE_FORMAT = "BBBBBBbB"
PERSON_SENSOR_FACE_BYTE_COUNT = struct.calcsize(PERSON_SENSOR_FACE_FORMAT)

PERSON_SENSOR_FACE_MAX = 4
PERSON_SENSOR_RESULT_FORMAT = PERSON_SENSOR_I2C_HEADER_FORMAT + \
    "B" + PERSON_SENSOR_FACE_FORMAT * PERSON_SENSOR_FACE_MAX + "H"
PERSON_SENSOR_RESULT_BYTE_COUNT = struct.calcsize(PERSON_SENSOR_RESULT_FORMAT)

# How long to pause between sensor polls.
PERSON_SENSOR_DELAY = 0.02


class PersonSensor():
    def __init__(self, i2c):
        self.i2c = i2c
    
    def get_faces(self):
        
        while not i2c.try_lock():
            pass
        
        read_data = bytearray(PERSON_SENSOR_RESULT_BYTE_COUNT)
        self.i2c.readfrom_into(PERSON_SENSOR_I2C_ADDRESS, read_data)
        self.i2c.unlock()

        offset = 0
        (pad1, pad2, payload_bytes) = struct.unpack_from(
            PERSON_SENSOR_I2C_HEADER_FORMAT, read_data, offset)
        offset = offset + PERSON_SENSOR_I2C_HEADER_BYTE_COUNT

        (num_faces) = struct.unpack_from("B", read_data, offset)
        num_faces = int(num_faces[0])
        offset = offset + 1

        faces = []
        for i in range(num_faces):
            (box_confidence, box_left, box_top, box_right, box_bottom, id_confidence, id,
             is_facing) = struct.unpack_from(PERSON_SENSOR_FACE_FORMAT, read_data, offset)
            offset = offset + PERSON_SENSOR_FACE_BYTE_COUNT
            face = {
                "box_confidence": box_confidence,
                "box_left": box_left,
                "box_top": box_top,
                "box_right": box_right,
                "box_bottom": box_bottom,
                "id_confidence": id_confidence,
                "id": id,
                "is_facing": is_facing,
            }
            faces.append(face)
        checksum = struct.unpack_from("H", read_data, offset)
        return faces
        
print("Getting I2C")
i2c = busio.I2C(scl=board.GP5, sda=board.GP4)    # Pi Pico RP2040
# Create a simple PCA9685 class instance.

print("Getting Servo Manager")
servoManager = ServoManager(i2c)

print("Getting person sensor")
personSensor = PersonSensor(i2c)

print("Person sensor data block size", PERSON_SENSOR_RESULT_BYTE_COUNT)
print("Person sensor face block size", PERSON_SENSOR_FACE_BYTE_COUNT)

while True:
    faces = personSensor.get_faces()
    if len(faces)>0:
        face = faces[0]
#        print(face)
#        print("    Left X: ",face["box_left"],"Top Y:",face["box_top"] )
        x = face["box_left"] + (face["box_right"] -face["box_left"])/2.0
        y = face["box_top"] + (face["box_bottom"] - face["box_top"])/2.0
#        print("    Orig X: ", x,"Orig Y:",y )
        width = face["box_right"] - face["box_left"]
        height = face["box_bottom"] - face["box_top"]
        # scale for the servo control
        sx = (x-128)/128
        sy = (y-128)/128
        
        print("    SX:", sy, " SY:", sy)
        servoManager.set_servo_angles(sx,sy)
        #print("    X: ", x,"Y:",y,"width:",width,"height:",height)
        
    time.sleep(PERSON_SENSOR_DELAY)
    

while True:
    print("Enter servo and change value")
    command = input()
    (servo,change)= command.split()
    print("Servo:",servo,"Change",change)
    servoManager.update_raw_values(int(servo),int(change))


if False:
    while True:
        time.sleep(1)
        servoManager.set_servo_angles(1,0)
        time.sleep(1)
        servoManager.set_servo_angles(-1,0)
        time.sleep(1)
    
while True:
    servoManager.point_left()
    time.sleep(1)
    continue
    servoManager.point_right()
    time.sleep(1)
    



while True:
    servoManager.set_servo_angles(0,0)
    time.sleep(1)
    continue
    servoManager.set_servo_angles(-1,1)
    time.sleep(1)
    servoManager.set_servo_angles(-1,-1)
    time.sleep(1)
    servoManager.set_servo_angles(1,-1)
    time.sleep(1)
    servoManager.set_servo_angles(1,1)
    time.sleep(1)



        
            
