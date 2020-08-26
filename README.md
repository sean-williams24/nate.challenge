# nate.challenge

My attempt at creating a small app which displays products fetched via a REST API through Docker.

## Pre-requisites   

Required SDK's (included):
  
  pod 'Kingfisher', '~> 5.0'      
  pod 'Spring'       
  
I used Kingfisher to assist with caching images in the collection view on the Products view controller to boost performance and ensure a smooth scrolling experieince for the user.

I used the Spring library to assist with implementing animations throughout the app.

## Getting Started
Clone or download the project and run the xcworkspace file. I built the app using the MVC architecture with a dedicated netwrorking client for API calls to the local server.

The app launches with a brief animation as Products are fetched from the server and loaded into the collection view on the Products VC. Seamless pagination has been implemented so the user can endlessly scroll - using the scrollViewDidScroll delegate method I detect when the user is nearing the bottom and make a new call to fetch a new set of products.

Tapping a cell will display the products details in full in a popup view, where the user can swipe through all available images, tap 'View Website' to luanch in Safari, tap the trashcn icon to delete the product from the database, or 'Edit' to launch another View COntroller to make ammendments.


