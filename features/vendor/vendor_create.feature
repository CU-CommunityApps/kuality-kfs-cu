Feature: Vendor Create

[KFSQA-638]	Vendor Create e2e - Standard-Individual, Contract No, Insurance No, Cornell University pays vendors for
            good and services. The University captures legal, tax and procurement information based on ownership type as required by federal laws, state laws, and university policies.

  @KFSQA-638 @wip
  Scenario: I want to create a vendor with ownership type INDIVIDUAL
    Given   I am logged in as a KFS User
    And     I start an empty Vendor document
    And     I save the Vendor document
    And     I add an Attachment to the Vendor document
    And     I submit the Vendor document
    And     the Vendor document goes to ENROUTE
    And     I am logged in as a Vendor Reviewer
    And     I view the Vendor document
    And     I approve the Vendor document
    And     the Vendor document goes to FINAL
    When    I am logged in as a KFS User

    Then    the Vendor document should be in my action list
