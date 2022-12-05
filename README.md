# Group-Project
CS 329 Bulko Group Project w/ Christopher Lee, Jayashree Ganesan, Brian Herron, Justin Vu

**Name of Project**: Geocatcher

**Team Members**: Brian Herron, Christopher Lee, Justin Vu, Jayashree Ganesan

**List of Dependencies**: Firebase w/ FirebaseAuth, FirebaseFirestore, FirebaseFirestoreSwift, Xcode 14.0, Swift 5

**Special Instructions:**



* Use a iPhone 14 simulator
* If necessary, re-install Firebase (not an issue with app, just an issue with Firebase)
* For resetting the password:
    * Do NOT use an @utexas email for resetting the password, it doesn’t work for some reason (regular gmails do, though)
    * Don’t forget to check the spam folder.
* Recommended to build from XCode to download the app once. Then run on the phone as a normal app.
* Put the iPhone on light mode.

**Required Feature Checklist**



1. Login/register path with Firebase (Done)
2. “Settings” screen and the three behaviors implemented are: (Done)
    1. Notifications Distance (Done)
    2. Enable Notifications (Done)
    3. Reset Tutorial (Done)
3. Non-default fonts and colors used (Done)

Two major elements used:



1. Core Data (Done for Past Caches)
2. User Profile path using camera and photo library (Done)
3. Multithreading
4. SwiftUI

Minor Elements used:



1. Two additional view types such as sliders, segmented controllers, etc. the two we implemented are: Image View on all the backgrounds, Slider on the notifications distance in settings, segmented control in the Create Cache VC for difficulty

One of the following:



1. Table View (on Settings)
2. Collection View
3. Tab VC (On Home Screen / MapViewController)
4. Page VC

         


Two of the following:



1. Alerts (Done)
2. Popovers (Done)
3. Stack Views
4. Scroll Views
5. Haptics
6. User Defaults

At least one of the following per team members:



1. Local notifications (Done via Cache Notification)
2. Core Graphics
3. Gesture Recognition
4. Animation (Done via Tutorial)
5. Calendar
6. Core Motion
7. Core Location/ Mapkit (Done via MapView on Home Screen)
8. Core Audio
9. QR Code (Done Via QR ViewControllers)

Work Distribution Table


<table>
  <tr>
   <td><strong>Required Feature</strong>
   </td>
   <td><strong>Description</strong>
   </td>
   <td><strong>Who/Percent Worked On</strong>
   </td>
  </tr>
  <tr>
   <td>Login/Register/Reset Password
   </td>
   <td>Allows user to create account, login, and reset password
   </td>
   <td>Christopher (100%)
   </td>
  </tr>
  <tr>
   <td>UI Design
   </td>
   <td>Layout of items on view controllers and constraints; colors, fonts, and background images
   </td>
   <td>Jayashree (70%)
<p>
Justin (30%)
   </td>
  </tr>
  <tr>
   <td>Settings
   </td>
   <td>Allows users to enable/disable notifications, set notifications distance, reset tutorial, log out, and delete accounts.
   </td>
   <td>Christopher (40%)
<p>
Justin (40%)
<p>
Brian (20%)
   </td>
  </tr>
  <tr>
   <td>User Profile Path + Edit Profile
   </td>
   <td>Displays user information and amount of finds. Allows users to edit profile info and picture w/ camera or photo library
   </td>
   <td>Christopher (100%)
   </td>
  </tr>
  <tr>
   <td>GPS Map View/Home Page
   </td>
   <td>Allows users to see caches on map. Includes tab controller to navigate. 
   </td>
   <td>Justin (100%)
   </td>
  </tr>
  <tr>
   <td>QR Code Scanner
   </td>
   <td>Allows users to scan caches so that they can be added to the map view, and also collect caches.
   </td>
   <td>Brian (100%)
   </td>
  </tr>
  <tr>
   <td>Create Cache + All Related VCs
   </td>
   <td>Includes CreateCacheVC, ConfirmationVC, QRGenVC. Lets users create a geocache via QR code with necessary information.
   </td>
   <td>Justin (80%)
<p>
Brian (20%)
   </td>
  </tr>
  <tr>
   <td>Cache
   </td>
   <td>Actual display of cache view controller and its information.
   </td>
   <td>Brian (80%)
<p>
Justin (20%)
   </td>
  </tr>
  <tr>
   <td>Past Caches
   </td>
   <td>Lets users see past caches that have been collected.
   </td>
   <td>Justin (100%)
   </td>
  </tr>
  <tr>
   <td>Tutorial
   </td>
   <td>Allows users to see basic animated tutorial after signing up, and after logging in if “reset tutorial” is pressed in settings.
   </td>
   <td>Justin (100%)
   </td>
  </tr>
  <tr>
   <td>Other Elements
   </td>
   <td>Debugging and troubleshooting a variety of different features across the project
   </td>
   <td>Justin (50%)
<p>
Christopher (35%)
<p>
Brian (15%)
   </td>
  </tr>
</table>
