# ESPCAMv2

Simple camera webserver



## Author / Origin:

based on Espressifs demo file espressif/esp32-camera

## Changes	
Trying to connect to WiFi with stored credentials, if this fails the credentials are requested via bluetooth.
Automatic reconnect if WiFi connection is lost.
## Usage

Define your device name in CameraWebServer.cpp (MYNAME). This name will be used as DNS-Name, Bluetooth device name and NV-Flash pathname).

The CameraWebserver tries to connect to the last known WiFi network. 
If no connection could be established a SSID and Password will be requested via bluetooth after 45s. 
Connect your bluetooth terminal to the bluetooth connection. Select the ssid from the list and enter the password. 

If the connection could be established, the credentials will be stored for further use in the NV-Flash.


## Demo script for captureing frames

ESPCAM-Capture.sh is a very basic demo script how to capture frames from the ESPCAM.
It contains also some information how to mange camera settings. 

If you want to capture the stream use ffmpeg:
e.g. `ffmpeg -re -f mjpeg -t 300 -i http://ESPCAM00:81/stream   -an -c:v libx265 -crf 29 -preset fast /tmp/ESPCAMStream.mp4`

(x265 will not work on Raspi 3...)


