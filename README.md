# XBee-Java-application-script
Script to create XBee Java application use XBee Java Library on Linux based in Getting Started with Java Library Guide

https://docs.digi.com/display/XBJLIB/Getting+started+with+XBee+Java+Library

Run script:

    sudo sh app.sh

To list available usb serial ports use next command and if the port that you can use is different than /dev/ttyUSB0, replace in script.

    dmesg | grep tty
