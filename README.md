# WeatherDemoApp

## Features
- track current weather in real-time.
- search for cities to get weather conditions for the current time.
- maintain list of cities by adding and deleting cities.
- see historical weather data for each city.

## Installation:

clone this repo:
https://github.com/ahmed-ibrahim-salim/WeatherDemoApp

-  write in the terminal and execute: <br />

      ```sh
      pod install
      ```

if you are faceing error "Double-quoted include" while building:

- use:
    ```sh
        rm -rf ~/Library/Developer/Xcode/DerivedData/
        rm -rf ~/Library/Caches/CocoaPods/
        pod deintegrate
        pod update
    ```

## Linting
used SwiftLint to enforce code style with warnings & errors.

## Used
MVVM, Combine, Realm DB & UI programmatically.

## Dark Theme
change os theme from settings to try dark and light theme.


## Unit-Testing
because my schedule was tight, I had no time to add unit tests, but I improved the code to be testable as much as possible by using dependency injection (initialiser & method), so we can use test doubles:
- we can inject other DB (CoreData) to LocalStorageManager.
- we can inject other Database Manager to viewModels. 

