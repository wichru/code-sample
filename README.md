# Tjekvik tech lead coding exercise

This example represents a data (appointment) import into our system that needs refactoring and being extended with new functionality.

## Goal

Goal of the exercise is to see your approach to solving a technical challenge in Ruby on Rails.

Your job is to produce one (or several) Pull Requests that would meet the following criteria:

- Refactor the existing code with practices that you deem are best in terms for clean code
- Complete the failing spec
- Consider this code to be running in production
- Extend the functionality by implementing Feature 1 described bellow
- (Bonus) use dry-monads

You're welcome to modify code, create new specs as you see fit.

## Feature 1

After the appointments are imported, send a SMS message to customers to their contact phone number notifying them about their expected appointment start date.

The message body the customer would receive should equal "Dear Dejan Stokanic, we're looking forwerd to seeing you on Wedensday, 18th of March".

But only send the SMS to customers where job laborCode from import json is set to "CD".

You can use Twilio gem as SMS gateway.
And data is source is in import_data.json fixture.

## What we'll evaluate

After you submit your solution we'll look into:

- How you approached the solution 
- How you structured commit messages (eg which files are included, how is the message written)
- How potential errors are handled

Next step will be a second call where we'll go over the submitted solution togeher and we'll cover things like:
- The decisions made within the code
- Any other alternatives one could use for the solution
