# Customizations of Volunteers for Salesforce for Encircle
This repo contains the custom Salesforce work for [Encircle: An LGBTQ+ Youth and Family Resource Center](http://www.encircletogether.org). 
## Getting Started
You are free to borrow, copy, and/or steal the anything you'd like from this repo. A rising tide lifts all boats.

Keep in mind, however, that there are very specific customizations in this code. For example, email addresses pointing to Encircle-specific accounts are located in some of the code and templates. Obviously, you'll want to change those and anything else, such as logos, colors, and wording, that doesn't apply to your organization.

The best way to use this repo would be as a place to see examples of customizations to [Volunteers for Salesforce](https://powerofus.force.com/articles/Resource/Volunteers-for-Salesforce). You would not want to simply deploy this code to your orgs without first making your own customizations.

## Customizations
Below is a list of some of the customizations and custom apps we've built for Encircle and their specific needs. Any public facing customizations were made using custom lightning components and can be found in the [/src/aura](https://github.com/jcschultz/encircle/tree/master/src/aura) and [/src/classes](https://github.com/jcschultz/encircle/tree/master/src/classes) directories.

### Volunteer Registration
With V4S, people can come to your site, register as a volunteer, and immediately sign up for volunteering shifts. At Encircle, volunteers must first go through a background check and attend trainings before they are able to sign up for volunteering shifts.

We've added a custom object called [Volunteer Training](https://github.com/jcschultz/encircle/blob/master/src/objects/Volunteer_Training__c.object) for creating dates on which trainings are being offered. Registrants can choose a training while registering, and a [Volunteer Training Attendance](https://github.com/jcschultz/encircle/blob/master/src/objects/Volunteer_Training_Attendance__c.object) junction object record is created to link their contact record to the training record.

### Volunteer Shift Sign Up and Management
After attending training and being marked as approved for shifts, volunteers can return to the site and sign up for volunteer shifts. Although a volunteer contact record is created during registration, a volunteer without the approved checkbox checked cannot sign up for shifts and will not be found when attempting to log in.

Volunteers do not have user accounts. They only exist in Salesforce as contacts. To add some level of security or psuedo-authentication, we've created a system where volunteers must enter their email address or phone number, followed by their last name to match them up with their contact record. After "logging in," volunteers can sign up for shifts or manage their shifts they've already signed up for.

### Door Survey iPad App
Volunteers sign in to their shifts using a Door Survey app that runs on an iPad that hangs at the front door. The app is simply a Communities page running in Safari.

Visitors to Encircle also use the app to complete a short, one-tap survey so that Encircle can collect data about the age demographics of their visitors, as well as when people are visiting. These demographics are stored in a custom object called [Door Activity](https://github.com/jcschultz/encircle/blob/master/src/objects/Door_Activity__c.object). One record per day per age range is created to keep data usage low.
