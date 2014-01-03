Feature: Account Delegate Global

As a KFS Chart Manager I want to cancel the Edit of an Account Delegate Model and automatically return to the Main Menu.

Scenario: Edit and Cancel an Account Delegate Model KFSQA-568
Given I am logged in as a KFS Chart User
And    I Edit an Account Delegate Model
When I cancel the eDoc
Then  I should return to the Main Menu