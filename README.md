# PICO-Paparazzi-camera
![Point and shoot camera floating above a picture frame](images/device.jpg)
A camera that follows you around the room. Most of the time. 

This project started with a simple idea and then I found ways to make it more complicated. I had a lot of broken film cameras and 
I wanted to make something that made one follow me round the room. I found a sensor that can detect the position of people 
in front of it, and I started with a Raspberry Pi PICO and some servos to see if I could make something which pointed the 
servos at person. I called it the Paparazzi camera. If it went well the next step would be to make a larger 
installation with lots of cameras. It's been an interesting ride, and I'm still not sure if I've properly arrived, but it turns out 
that you can have a lot of fun with this stuff either way. The project is a work in progress and I've been through several iterations.
## Pan and tilt
![pan and tilt mechanism](/images/pan%20and%20tilt%20version.jpg)

![top view of pan and tilt](/images/pan%20and%20tilt%20detail.jpg)

A pan and tilt mechanism was the first thing I made that could follow you with a camera. It uses two MG995 servos to create a pan and tilt mechanism. The camera rests on a support at the front. The mechanism 
works fine and will also support a smartphone (you can use it to shoot panoramas if you like).

![pan and tilt components](/images/pantilt.png)
You can find the designs for these components in the 3d printing folder in this repository. Panning and tilting was fun but I really wanted something I could hang on the wall....
## Picture Camera mounting
So I moved on to a wall mounted device inside a six inch square picture frame. These are easy to get hold of from craft shops and are deep enough to allow electronics to be fitted in the back of the frame. Just make sure you get ones with removable glass. 
Some frames have the glass glued in, which makes it very had to remove without breaking it. You can see the picture frame version of the camera in the image at the top of this page. The camera seems to float out of the picture. 
At least, I think it does. 

![four servo version showing servos](/images/four%20servo%20version.jpg)

This version uses a picture panel containing four tiny little servos, a Raspberry Pi PICO, a servo driver board and a Useful Sensors [Person sensor](https://github.com/usefulsensors/person_sensor_docs/blob/main/README.md). 

The camera is mounted on 3D printed ball and socket joint which is fitted inside the camera, ideally close to the camera's centre of balance. The idea is that the joint supports the weight of the camera, and the low powered servos only have to move the camera, not support its weight. To make sure there is enough movement force I used four stepper motors rather than two.

![control wires linking to the camera support](/images/control%20wires.jpg)

This shows how the control wires are connected from the servo horns to the camera support. 

![3D printed parts for mounting servos](/images/frame%20hardware.png)

These are the 3D printable parts for the base, camera support pillar and the camera support. The servo motors fit between the support pillars and are glued into place. The camera fitting snaps onto the ball on top of the support. There are pillars to support the other components. There are also versions of the camera plate for a universal joint version of the camera support. The fittings are created by an OpenSCAD script you can find in the 3d printing folder. 

This version works quite well, but it has problems if the camera is not balanced correctly on the end of the support. This causes the camera to twist so that it is not horizontal. It also affects the way that the camera moves. If the camera is not balanced the small servos are unable to lift its weight.

So I thought I'd move on to make a version that uses more powerful servos that can lift the camera weight. I also switched to a universal joint rather than a ball and socket for the camera support. The joint provides pan and tilt motion but not twisting. You can find the universal joints that I used [here](https://www.amazon.co.uk/dp/B09NXJ9QF4).

## Two and Four servos

The four servo design uses SG90 servos. The two servo version of the design uses the same MG995 servos as the original pan and tilt mechanism. These can easily lift the camera up and down, although they are more heavily geared which means that the movement is slightly slower. The two servo backplate design is in the 3d printing folder. 

## Circuitry

The servos are driven by a PCA9685 16 Channel 12-bit PWM Servo motor driver. Both the servo driver board and the person sensor are connected to I2C. This is made easy by the way that the server driver board has i2c pass through. 

### Servo controller connection
The servo controller pins are connected as follows:

* scl GPIO5
* sda GPIO4

The power for the servos is obtained from the VBUS connection. This means that the servos are powered from the PICO USB connection. This is fine for the servos we are using, but if you start to use larger servos, heavier cameras or more servos you might want to consider 

### Servo connection for 2 servos
* Up/down - servo S0
* left/right - servo S1

### Servo connection for 4 servos

* Up - servo S0
* Left - servo S1
* Right - servo S2
* Down - servo S3

### The Person Sensor
The best way to connect the Person Sensor is by using a QWIIC connector brought out to four sockets which to to pins soldered onto the servo driver board. See the picture above for more details. 

The Person Sensor does work, although it can be a bit reticent. You need to make sure that the area where the camera is being used is well it and if clearing the background behind the image viewed by the sensor also improves recognition.

## Software

The software controlling the device is written in Circuit Python. It uses a set of AdaFruit libraries to control the servos. You can find the software and the libraries in the python folder. Just copy the contents of this folder onto the root directory of the storage for the Circuit Python drive which appears when the PICO is connected to the computer. The program is stored in a file called code.py and will run automatically when your PICO is powered up. When it starts up it moves the camera to each corner in turn and then back into the middle. 

### Servo configuration

You can select the servo configuration by changing the value on the first line of the code:
```
number_of_servos = 2
```
The number of servos can be 2 or 4. Any other number will cause an exception to be raised. 

### Paparazzi class

The Paparazzi class creates a PersonSensor object and an appropriate servo driver object. You can then repeatedly update the position of the camera by calling the update method on the Paparazzi instance:
```
pap = Paparazzi(number_of_servos)


while True:
    pap.update()
    time.sleep(0.1)

```
The code above updates the sensor every tenth of a second. You can use the scan method to test all the positions of the servos:

```
pap = Paparazzi(number_of_servos)

pap.scan()
```

This causes the program to scan the camera from left to right and up and down. It is very useful for tuning the lengths of the control wires.

Have fun!

Rob Miles