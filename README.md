# Radar-detection-system
Radar system controlled by Processing and Arduino development environments
## How it works?
Radar detects objects using HC – SR04 Ultrasonic Sensor in the range of 30 cm and 180 degrees, and plots results on a graphical display.
Control and detection was achieved using the Arduino, and a graphical radar display of the obtained values of distance and angle from the target object was realized in the development environment Processing
## Circuit
According to the circuit diagram, attach the HC – SR04 Ultrasonic Sensor to a servo motor,and hook them up to an Arduino board.
## Code
### Arduino code
Sweeps the servo back and forth in the range od 180 degrees.
After every step, it will read the distance off the ultrasonic sensor and write the value to Serial.
### Processing code
Listens for "readings" (off the Serial port) from the Arduino and plots the result with simple graphics.

You can read more about Processing [here](https://processing.org/).
## Final result
vidi vidi li ti se nazovslike ovdje i promijeni poveznice na nove slike
#### Object detected
![Object detected](https://github.com/mateax/Radar_detection_system/blob/main/Object_in_scope.png)
#### Object out of scope
![Object out of scope](Out_of_scope.jpg)
