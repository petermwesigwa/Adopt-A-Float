# Adopt-A-Float
iOS app to track marine floating scientific instruments in the oceans. More details about the project can be found in this project's Wiki


## Installing the project
To run this project on your computer, you will need to have a Macbook with Xcode installed. Once you have installed Xcode follow the steps below:
1) Clone the repository onto your device.
2) In your terminal, run `cd` into the repository you just cloned. Once you are done run 
```
cp private.plost private.plist
```
2) Within your cloned repository, open `Adopt-A-Float.xcworkspace`. This will open up the project in the Xcode editor
3) Add your [Google Maps API
Key](https://developers.google.com/maps/documentation/ios-sdk/) to the 'private.plist' file . We are only exchanging the fake 'private.plost' file without the key.
4) Create a .gitignore file in the folder whose contents is just the
line "private.plist". This will keep your API key private when pushing
changes to GitHub.  

## Running the project
To run, open `Adopt-A-Float.xcworkspace`. Select the device that you would like to run the app on (either a physical device plugged into your laptop or a simulator from Xcode) and click the Play button at the top of the Xcode editor.

### Troubleshooting errors

