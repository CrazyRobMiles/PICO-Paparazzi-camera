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
        #    0   1
        #    2   3
        # each servo is connected to a corner of the camera holder
        # direction 1 means pull the corner, -1 means push the corner
        # We get different camera positions by pulling and pushing the 
        
        for no in range(0,4):
            self.servos.append(servo.Servo(self.pca.channels[no]))
            
        
            
    def set_servo_angles(self,x, y, max_tilt_angle=45):
        """
        Given X and Y coordinates (in some desired range, e.g., -1 to 1), this function
        calculates the servo angles for four servos controlling the corners of the plate.
        
        Args:
            x (float): Desired X direction (from -1 to 1).
            y (float): Desired Y direction (from -1 to 1).
            max_tilt_angle (float): Maximum tilt angle for the servos in any direction.
            
        Returns:
            dict: Servo angles for each of the four servos.
        """
        
        # Clamp X and Y to the range [-1, 1]
        x = clamp(x, -1, 1)
        y = clamp(y, -1, 1)

        # Calculate the tilt contribution from X and Y direction
        x_tilt = max_tilt_angle * x
        y_tilt = max_tilt_angle * y
        
        # Calculate servo angles based on tilt
        # Assuming servos are arranged at the corners of a rectangle: 
        # top-left (Servo 1), top-right (Servo 2), bottom-left (Servo 3), bottom-right (Servo 4)
        servo1_angle = NEUTRAL_ANGLE + y_tilt + x_tilt   # top-left
        servo2_angle = NEUTRAL_ANGLE + y_tilt - x_tilt   # top-right
        servo3_angle = NEUTRAL_ANGLE - y_tilt + x_tilt   # bottom-left
        servo4_angle = NEUTRAL_ANGLE - y_tilt - x_tilt   # bottom-right

        # Clamp servo angles to valid range
        servo1_angle = clamp(servo1_angle, SERVO_MIN_ANGLE, SERVO_MAX_ANGLE)
        servo2_angle = clamp(servo2_angle, SERVO_MIN_ANGLE, SERVO_MAX_ANGLE)
        servo3_angle = clamp(servo3_angle, SERVO_MIN_ANGLE, SERVO_MAX_ANGLE)
        servo4_angle = clamp(servo4_angle, SERVO_MIN_ANGLE, SERVO_MAX_ANGLE)
        
        self.set_raw_values(servo1_angle,servo2_angle,servo3_angleservo4_angle)
        print(x,y,servo1_angle,servo2_angle,servo3_angle,servo3_angle)
        
    def set_positions(self,v0,v1,v2,v3):
        self.servos[0].angle = 180-v0;
        self.servos[1].angle = v1;
        self.servos[2].angle = v2;
        self.servos[3].angle = 180-v3;
        
    def point_up(self):
        pass
        
    def point_down(self):
        pass


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
PERSON_SENSOR_DELAY = 0.2


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

print("Setting initial positions")
servoManager.set_positions(90,90,90,90)

print("Getting person sensor")
personSensor = PersonSensor(i2c)

print("Person sensor data block size", PERSON_SENSOR_RESULT_BYTE_COUNT)
print("Person sensor face block size", PERSON_SENSOR_FACE_BYTE_COUNT)

while True:
    faces = personSensor.get_faces()
    if len(faces)>0:
        face = faces[0]
        print(face)
        print("    Left X: ",face["box_left"],"Top Y:",face["box_top"] )
        x = face["box_left"] + (face["box_right"] -face["box_left"])/2.0
        y = face["box_top"] + (face["box_bottom"] - face["box_top"])/2.0
        print("    Orig X: ", x,"Orig Y:",y )
        # scale for the servo control
        x = (x-128)/128
        y = (y-128)/128
        print("    X: ", x,"Y:",y )
    time.sleep(PERSON_SENSOR_DELAY)
    

servoManager.set_servo_angles(90,90)


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
    


        
            
