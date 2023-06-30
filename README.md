
## iOS Assignment

Take Home Assignment [Weather App]

## Technical Components

-   MVVM Pattern
-   UI: SwiftUI
-   Dependency Injection: Custom Dependency Injection (Assembler)
-   Data binding using Combine
-   Includes tests
-   Third party libraries used:
    -   [Alamofire](https://github.com/Alamofire/Alamofire): For creating HTTP Requests and handling network tasks.

## Documentation

-   **Application**  layer: - The main group contains  `App` implementation,  `Assets`, etc. - The  `DefaultAssembler`  class is responsible for connecting all other layers through dependency injection.
-   **Data**  layer: - Responsible for providing the data from the api client  `NetworkService.swift` as well as `LocationManager.swift` which simulates location updates,   to the presentation layer (ViewModel) through  `UseCase`  components.
-   **Presentation**  layer: - Follows the MVVM pattern. The Main page is `MainView` with it's own `MainViewModel`.

## Feature/Improvements in real usecase scenario

 1. Better UI
 2. Better Animations (Ideally animations for each cell update, handle independently from the MainView), Animatable background.
 3. Graph to better show temperature fluctuations for the current day, + extra forecast attributes.
 4. Detail page for each daily forecast that would display hourly forecast.
 5. Dynamic icons, ideally for each hourly/daily forecast to also show the weather conditions. (Couldn't find them in the api, perhaps a custom mapping from the app? )
 6. More Unit Test coverage, Ideally all non UI component's to be tested.
 7. Dedicated UI for error handling. (Perhaps a page with a message and retry button that would refresh the data with the current location without restarting the timer or change the user location at the given moment).
 8. Git: Each layer to be develop in an independet branch and to be merged with a Pull Request to better organise the development phase.

## Better architecture/approach

We can substract a new layer (domain) from data layer, where the dependency would be as follows:  **presentation -> domain <- datta**. This way we would have implemented a Clean Architecture, but for the purpose of 1 page in total, it would have been a little redundant.

Thank you!  
Madrit Kacabumi