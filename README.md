# Adopt-A-Float
iOS app to track marine floating scientific instruments in the oceans. More details about the project can be found in this project's Wiki


## Installing the project
To run this project on your computer, you will need to have a Macbook with Xcode installed. Once you have installed Xcode follow the steps below:
1) Clone the repository onto your device.
2) In your terminal run the following commmands
```
cd path\to\your\cloned\repository
cp private.plost private.plist
```
This creates a file `private.plist` to store your API key securely.
3) Within your cloned repository, open `Adopt-A-Float.xcworkspace`. This will open up the project in the Xcode editor
4) Using the editor, add your [Google Maps API
Key](https://developers.google.com/maps/documentation/ios-sdk/) to 'private.plist'.
5) Create a .gitignore file in the folder whose contents is just the
line "private.plist". This will keep your API key private when pushing
changes to GitHub.

## Running the project
1) Open `Adopt-A-Float.xcworkspace`. 
2) Select the device that you would like to run the app on (either a physical device plugged into your laptop or a simulator from Xcode).
3) Click the Play button at the top of the Xcode editor to run the application

## Troubleshooting errors
In case of any errors when running the app, troubleshooting using error pages like Github and Stackoverflow is helpful. For any bugs in the app or its code, you can create an issue on Github.

## Becoming a beta tester
The app is nearing the beta testing phase! If you are interested in becoming a tester email mwesigwa@princeton.edu to be added to the waitlist

