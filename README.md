# Cross-platform-mobile-development

## Echelon

Echelon is a Flutter car-sharing application with fleet discovery, booking, trip management, and a profile area. The app was redesigned around real vehicle browsing, Astana pickup hubs, and a more polished rental flow.

## Implemented Flutter Features

1. `SearchAnchor` + `SearchBar`
   Link: https://api.flutter.dev/flutter/material/SearchAnchor-class.html
   Use in the app: lets the user search cars by model, class, or Astana location, and shows live search suggestions with real car images.

2. `SliverAppBar`
   Link: https://api.flutter.dev/flutter/material/SliverAppBar-class.html
   Use in the app: creates the large collapsible header on the Discover page, making the fleet screen feel more modern and premium.

3. `TabBar`
   Link: https://api.flutter.dev/flutter/material/TabBar-class.html
   Use in the app: shows the car classes as tabs: `Economy`, `Comfort`, `Premium`, and `Electric`.

4. `TabBarView`
   Link: https://api.flutter.dev/flutter/material/TabBarView-class.html
   Use in the app: lets the user swipe or switch between the different car-class pages while keeping the content organized.

5. `TabController`
   Link: https://api.flutter.dev/flutter/material/TabController-class.html
   Use in the app: controls the active tab and lets search results automatically switch to the correct car class.

6. `NestedScrollView`
   Link: https://api.flutter.dev/flutter/widgets/NestedScrollView-class.html
   Use in the app: combines the collapsible header and tabbed content into one smooth scrolling experience on the Discover page.

7. `DraggableScrollableSheet`
   Link: https://api.flutter.dev/flutter/widgets/DraggableScrollableSheet-class.html
   Use in the app: turns the booking panel into a draggable sheet that slides up from the bottom, so renting a car feels like a real mobile app flow.

8. `showModalBottomSheet`
   Link: https://api.flutter.dev/flutter/material/showModalBottomSheet.html
   Use in the app: opens the booking interface and add-on details from the bottom of the screen instead of navigating to a separate page.

9. `Hero`
   Link: https://api.flutter.dev/flutter/widgets/Hero-class.html
   Use in the app: animates the car image smoothly from the fleet card into the car detail page.

10. `Dismissible`
    Link: https://api.flutter.dev/flutter/widgets/Dismissible-class.html
    Use in the app: allows the user to swipe a reservation or add-on to remove it.

11. `SnackBar`
    Link: https://api.flutter.dev/flutter/material/SnackBar-class.html
    Use in the app: shows feedback after actions like cancelling a reservation, and gives an `Undo` option.

12. `FilterChip`
    Link: https://api.flutter.dev/flutter/material/FilterChip-class.html
    Use in the app: lets the user quickly filter cars such as `Budget picks`, `Top rated`, or `Near center`.

13. `SegmentedButton`
    Link: https://api.flutter.dev/flutter/material/SegmentedButton-class.html
    Use in the app: used in booking so the user can switch between `Round Trip / One Way` and `Hours / Days`.

14. `showDatePicker`
    Link: https://api.flutter.dev/flutter/material/showDatePicker.html
    Use in the app: lets the user choose the pickup date for renting a car.

15. `showTimePicker`
    Link: https://api.flutter.dev/flutter/material/showTimePicker.html
    Use in the app: lets the user choose the pickup time for the reservation.

16. `CustomScrollView`
    Link: https://api.flutter.dev/flutter/widgets/CustomScrollView-class.html
    Use in the app: used on the car details page to combine the image header, vehicle info, and optional add-ons in one scrollable layout.
