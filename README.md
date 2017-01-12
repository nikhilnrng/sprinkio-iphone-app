# Sprinkio Sprinkler Controller

### Overview

Sprinkio is a smart, WiFi-connected household sprinkler controller. Sprinkio gives users the ability to control their sprinklers and reduce their water bills, all from a smartphone app. The controller uses environmental temperature and moisture sensor inputs to build a custom schedule that waters just the right amount. 

The controller was built as part of a senior capstone project. The hardware combines an Atmel ATmega 328p microcontroller and a Raspberry Pi to provide manual zone controls, zone status, WiFi connectivity, and a real-time clocking mechanism. The project also utilizes an iOS app to give users control of zone status remotely, on a shared WiFi network. 

This project utilizes three repositories: 

- [sprinkio-atmel-firmware](https://github.com/nikhilnrng/sprinkio-atmel-firmware): the firmware for the Atmel ATmega 328p microcontroller
- [sprinkio-raspberry-pi-firmware](https://github.com/nikhilnrng/sprinkio-atmel-firmware): the firmware for the Raspberry Pi
- [sprinkio-iphone-app](https://github.com/nikhilnrng/sprinkio-iphone-app): an iOS app that provides user with zone control over WiFi

### Sprinkio iOS App

The Sprinkio iOS application allows remote access to the device as long as a user is on the same WiFi network as the sprinkler controller. The application provides the user with the simple functionality to manually turn zones on and off. The application was written in Objective-C and uses the Apple NSStream library to establish a TCP network connection with the controller. 

In order to use the application, a user must enter the IP address of the device they would like to connect to, and then press Connect. If a connection is established successfully, a success notification will display on the screen. From there, a user can use the zone picker to select the zone they would like to turn ON or OFF. The user can then toggle the zone ON or OFF using the segmented control switch located below the zone picker.

The sprinkler controller operates on a static IP address, such that once the WiFi network is initially set up, the IP address will remain the same. This is a safe decision for local home networks, where the number of available IP address fair outnumbers the number of addresses that are usually used. Additionally, this means that once a user has initially entered the IP address in the field, they should be able to continually connect to their device using that same address. The IP address is conveniently stored for the user after it is entered once, but the user is free to change the IP address if their device address does change, or if they connect their Sprinkio device to a different WiFi network.

For a detailed report on the system operation, message me at nikhilnrng@gmail.com. 
