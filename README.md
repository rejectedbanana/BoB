# BoB
**Did you know that Apple Watches have the same sensors that scientists already use to study the ocean and the earth?**

This is an app that turns your watch into a scientific instrument, gathering environmental data from anyone, anytime, anywhere.

[![DOI](https://zenodo.org/badge/739093324.svg)](https://doi.org/10.5281/zenodo.15604059)

## Project Description
This app uses the sensors on your Apple Watch to log location, motion, and submersion data for environmental monitoring

Through the WatchOS app, the Apple Watch logs environmental data from the motion, submersion, and location sensors. That data is then uploaded to the cloud and shared with the companion phone app. The iPhone app is used to view and share the data. Data is output as a machine readable JSON via AirDrop, email, or any app on your phone that can share data. 

This app is initially designed by oceanographers as a low-cost sensor to meaure properties of oceans and lakes such as water temperature, depth, wave height, and wave period. But with that many sensors that are used in so many areas of science, the applications are endless!

### Apple Watch Sensors
- Motion - 3-axis accelerometer, gyroscope and magnetic field sensor (compass)

- Submersion - Water temperature and depth sensors

- Location - Latitude and Longitude from L1 and L5 GPS, GLONASS, Galileo, QZSS, or BeiDou (whichever is available where you are)

More info on this project: https://experiment.com/projects/can-we-use-a-smartwatch-for-coastal-monitoring-and-research

## How to install and run the code
This code is written in SwiftUI, and during this development stage, only runs on Apple Products. To install this code, you will need a computer running XCode, an Apple iPhone, and an Apple Watch. To get submersion data, you will need an Apple Watch Ultra which has the temperature and pressure sensors. 

Here are instructions from Apple on how to run this code on your devices, you should be able to do this without a developer license https://developer.apple.com/documentation/xcode/running-your-app-in-simulator-or-on-a-device

If you run into issues, please reach out to me at kmartini@tiniscientific.com

## How to use the app
- Open the app on your watch. 

- Tap the "Start Sampling Button"!

- On the next screen, tap the "Start" Button.

- That's it! You should see the display recording live data. Deploy as you wish!

- To stop taking data, turn off the water lock, then press the stop button.

- To view the data, open the companion BoB app on your phone. 

- Click on the record you choose in the LogBook list for a detailed view.

- To export, tap the "Share" icon in the upper righthand corner of the "Details" view.

## Screenshots
### Watch App
<p float="center">
<img src="https://github.com/rejectedbanana/BoB/blob/main/ScreenShots/WatchBoBContentView.PNG" width=200>
<img src="https://github.com/rejectedbanana/BoB/blob/main/ScreenShots/WatchBoBSamplingView.PNG" width=200>
</p>

### Phone App
<p float="center">
<img src="https://github.com/rejectedbanana/BoB/blob/main/ScreenShots/BoBLogbookView.PNG" width=200>
<img src="https://github.com/rejectedbanana/BoB/blob/main/ScreenShots/BoBDetailView.PNG" width=200>
<img src="https://github.com/rejectedbanana/BoB/blob/main/ScreenShots/BoBDetailDataView.PNG" width=200>
</p>

## Coders and Collaborators
Thanks to the coders who helped along the way with this development as I am learning SwiftUI: Hasan K Armoush via DevSignal and Phil Parham.

And to our alpha testers Virginia Schutte and Michelle Weirathmueller.

## License
See MIT License tab above.


