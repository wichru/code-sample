# Tjekvik tech lead coding exercise

This example represents a data (appointment) import into our system that needs refactoring and being extended with new functionality.


We import data for a restricted period of time, where after it's automatically deleted.

## Goal

Goal of the exercise is to see your approach to solving a technical challenge in Ruby on Rails.

Your assignment is to produce one (or several) Pull Requests that would do the following:

- Refactor the existing code with practices that you deem are best in terms for clean code
- Correct the existing failing spec
- Tread this code as it will be deployed to production (error handling etc)
- Extend the functionality by implementing Feature 1 described bellow
- (Bonus) use dry-monads

You're welcome to modify code, create new specs as you see fit.

We suggest time-boxing the solution to 3 - 4 hours, any code / refactoring that would take too long to write, you're welcome to mention as code comments or during our followup call.

## Feature 1

After the appointments are imported, send a SMS message to customers to their contact phone number (from import data) notifying them about their expected appointment start date.

The message body the customer would receive should equal "Dear Dejan Stokanic, we're looking forward to seeing you on Wednesday, 18th of March".

But only send the SMS to customers where job laborCode from import json is set to "CD".

You can use Twilio gem as SMS gateway or a fake SMS gateway.
And data is source is in import_data.json fixture.

## What we'll evaluate

Next step will be a second technical oriented call where we'll go over the submitted solution together and we'll cover things like:

- How you structured the code overall
- How you structured commit messages (eg which files are included, how is the message written)
- How potential errors/exceptions are handled
- The decisions made within the code
- Any other alternatives one could use for the solution

Best of luck
