# Adopt-A-Float
iOS app to track marine floating scientific instruments in the oceans.

Read about the instruments that Adopt-A-Float tracks on the
Mermaid page: \
http://geoweb.princeton.edu/people/simons/MERMAID.html \
and on the Son-O-Mermaid page: \
http://geoweb.princeton.edu/people/simons/Son-O-Mermaid.html \
and on the EarthScope-Oceans page: \
http://www.earthscopeoceans.org 

## Running locally with Xcode
1) Open `Adopt-A-Float.xcworkspace`, not the .xcodeproj
2) Add your [Google Maps API
Key](https://developers.google.com/maps/documentation/ios-sdk/) to the 'private.plist' file . We are only exchanging the fake 'private.plost' file without the key.
3) Create a .gitignore file in the folder whose contents is just the
line "private.plist". This will keep your API key private when pushing
changes to GitHub.  
4) Run it now.
