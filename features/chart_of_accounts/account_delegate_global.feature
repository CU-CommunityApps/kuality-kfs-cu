Feature: Account Delegate Global

  [KFSQA-568]           As a KFS Chart Manager I want to cancel the Edit of an
                        Account Delegate Model and automatically return to the Main Menu.
  [KFSQA-602/KFSQA-570] As a KFS Chart Manager I want to add multiple account lines to the
                        Account Delegate Global using Organizational Codes because this
                        will save me time

  @KFSQA-568 @AcctDelegate @KFSMI-7977 @hare @solid
  Scenario: Edit and Cancel an Account Delegate Model
    Given   I am logged in as a KFS Chart Administrator
    And     I edit an Account Delegate Model
    When    I cancel the Account Delegate Model document
    Then    I should return to the Main Menu

  @KFSQA-602 @KFSQA-570 @cornell @AcctLookup @COA @KITI-2553 @hare @needs-clean-up
  Scenario: Create an Account Delegate Global using an organization hierarchy
    # TODO: Tony, this works despite the fact that we don't actually add multiple account lines. Should we do something about that?
    Given   I am logged in as a KFS Chart Manager
    And     I create an Account Delegate Global with multiple account lines
    When    I submit the Account Delegate Global document
    Then    the Account Delegate Global document goes to FINAL

