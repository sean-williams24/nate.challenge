# nate.challenge

My attempt at creating a small app which displays products fetched via a REST API through Docker.

## Pre-requisites   

Required SDK's (included):
  
  pod 'Kingfisher', '~> 5.0'      
  pod 'Spring'       
  
I used Kingfisher to assist with caching images in the collection view on the Products view controller to boost performance and ensure a smooth scrolling experience for the user.

I used the Spring library to assist with implementing animations throughout the app.

## Getting Started
Clone or download the project and run the xcworkspace file. 

I built the app using the MVC architecture with a dedicated networking client for API calls to the local server.

The app launches with a brief animation as Products are fetched from the server and loaded into the collection view on the Products VC. Seamless pagination has been implemented so the user can endlessly scroll - using the scrollViewDidScroll delegate method I detect when the user is nearing the bottom and make a new call to fetch a new set of products.

Tapping a cell will display the products details in full in a popup view, where the user can swipe through all available images, tap 'View Website' to launch in Safari, tap the trashcan icon to delete the product from the database, or 'Edit' to launch another View Controller to make amendments.

When the aforementioned Edit button or the Add Product button on the Products VC is tapped, the Adjust Products VC is launched containing textfields for the user to edit or enter new data. 

I have written a few Unit and UI tests to test the Product data model, textfield and button UI.
