#Wanderlust

## How to run
- Open Wanderlust.xcworkspace file with Xcode. App is tested with Xcode Version 6.2 (6C131e).
- Select a simulator or device to run with in the Xcode menu. (For best user experience and feel, running on a device is highly recommended.)
- Make sure Wanderlust scheme is selected next to the device/simulator selection menu (it should be automatically)
- Hit run button in Xcode to run on your device or simulator.
- Supports iOS 8 and up.

## Features
- Re-usable CardsStackView that holds a stack of cards, and allows right and left swiping. It can be customized with delegate methods and filled with data by any view controller via its dataSource and delegate objects.
- Single tapping on a card opens a map view with the coordinates and pin of the location shown on the map.
- Swiping right on a card favorites it and swiping left discards it. Changes are persisted in a sqlite database via the iOS Core Data framework.
- Tapping 'View Favorites' button opens up the list of favorite places that are persisted with a custom animation, and fetches the favorited places from the local data store.

## Future enhancements to consider
- Allow user to un-favorite a place from the list of favorites.
- Make CardsStackView more customizable by implementing additional delegate methods.
- Re-factor and improve Core Data layer, and go over its thread-safety. De-couple managed object contexts from the view controllers.
- After getting new places from the API, consider returning back all places that are stored in Core Data, as opposed to just the currently received ones (Wouldn't actually make a difference in this case since API always returns the same items.)