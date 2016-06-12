#!/bin/bash
#Author: Eduardo Avelar
#Nickname: eavelardev
#File: app.sh
#Description: Script to create XBee Java application use XBee Java Library on Linux

wget https://github.com/digidotcom/XBeeJavaLibrary/releases/download/v1.1.1/XBJL-1.1.1.zip
apt-get install unzip
unzip -q XBJL-1.1.1.zip
mkdir myFirstXBeeApp
cd myFirstXBeeApp/
mkdir -p src/com/digi/xbee/example libs bin
cp ../XBJL-1.1.1/xbjlib-1.1.1.jar  libs/
cp -r ../XBJL-1.1.1/extra-libs/* libs/
export XBJL_CLASS_PATH=libs/xbjlib-1.1.1.jar:libs/rxtx-2.2.jar:libs/slf4j-api-1.7.12.jar:libs/slf4j-nop-1.7.12.jar

FILE="src/com/digi/xbee/example/MainApp.java"

/bin/cat <<EOM >$FILE
package com.digi.xbee.example;

import com.digi.xbee.api.XBeeDevice;
import com.digi.xbee.api.exceptions.XBeeException;

public class MainApp {
    /* Constants */
    // TODO Replace with the port where your sender module is connected to.
    private static final String PORT = "/dev/ttyUSB0";
    // TODO Replace with the baud rate of your sender module.
    private static final int BAUD_RATE = 9600;

    private static final String DATA_TO_SEND = "Hello XBee World!";

    public static void main(String[] args) {
        XBeeDevice myDevice = new XBeeDevice(PORT, BAUD_RATE);
        byte[] dataToSend = DATA_TO_SEND.getBytes();

        try {
            myDevice.open();

            System.out.format("Sending broadcast data: '%s'", new String(dataToSend));

            myDevice.sendBroadcastData(dataToSend);

            System.out.println(" >> Success");

        } catch (XBeeException e) {
            System.out.println(" >> Error");
            e.printStackTrace();
            System.exit(1);
        } finally {
            myDevice.close();
        }
    }
}
EOM

javac -sourcepath src -classpath $XBJL_CLASS_PATH -d bin src/com/digi/xbee/example/*.java

FILE="manifest.mf"

/bin/cat <<EOM >$FILE
Main-Class: com.digi.xbee.example.MainApp
Class-Path: libs/xbjlib-1.1.1.jar libs/rxtx-2.2.jar libs/slf4j-api-1.7.12.jar libs/slf4j-nop-1.7.12.jar

EOM

cd bin/
jar cvfm myFirstXBeeApp.jar ../manifest.mf .
mv myFirstXBeeApp.jar ../
cd ..
java -Djava.library.path=libs/native/Linux/x86_64-unknown-linux-gnu/ -jar myFirstXBeeApp.jar
