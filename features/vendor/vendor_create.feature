Feature: Vendor Create

  [KFSQA-638] Vendor Create e2e - Standard-Individual, Contract No, Insurance No, Cornell University
              pays vendors for good and services. The University captures legal, tax and procurement
              information based on ownership type as required by federal laws, state laws, and
              university policies.

  [KFSQA-635] Vendor Create e2e - Standard, Contract Yes, Insurance Yes, Cornell University
              pays vendors for good and services. The University captures legal, tax and
              procurement information based on ownership type as required by federal laws,
              state laws, and university policies.

  [KFSQA-633] Vendor Create - VN E2E-1a - eShop vendor,
  Cornell University pays vendors for goods and services. The University captures legal, tax and procurement information based on ownership type as required by federal laws, state laws, and university policies.

  [KFSQA-634] Vendor Create VN E2E-1b - Foreign vendor,
  Cornell University pays vendors for goods and services. The University captures legal, tax and procurement information based on ownership type as required by federal laws, state laws, and university policies.

  [KFSQA-636] Vendor Create e2e - Standard, ContractYes, InsuranceN0,
  Cornell University pays vendors for goods and services. The University captures legal, tax and procurement information based on ownership type as required by federal laws, state laws, and university policies.

  [KFSQA-637] Vendor Create e2e - Standard-Individual, ContractNo, InsuranceYes,
  Cornell University pays vendors for goods and services. The University captures legal, tax and procurement information based on ownership type as required by federal laws, state laws, and university policies.

  @KFSQA-638 @cornell @tortoise
  Scenario: I want to create a vendor with ownership type INDIVIDUAL
    Given   I am logged in as a KFS User
    When    I start an empty Vendor document
    And     I save the Vendor document
    And     I add an Attachment to the Vendor document
    And     I submit the Vendor document
    And     the Vendor document goes to ENROUTE
    And     I am logged in as a Vendor Reviewer
    And     I view the Vendor document
    And     I approve the Vendor document
    Then    the Vendor document goes to FINAL
    When    I am logged in as a KFS User
    Then    the Vendor document should be in my action list

  @KFSQA-635 @cornell @tortoise
  Scenario: I want to create a vendor with ownership type CORPORATION that is NON-FOREIGN
    Given   I am logged in as a KFS User
    When    I create a Corporation and Non-Foreign Vendor with Contract and Insurance
    And     I save the Vendor document
    And     I add an Attachment to the Vendor document
    And     I add a Contract to the Vendor document
    And     I submit the Vendor document
    And     the Vendor document goes to ENROUTE
    And     I am logged in as a Vendor Reviewer
    And     I view the Vendor document
    And     I approve the Vendor document
    Then    the Vendor document goes to FINAL
    When    I am logged in as a KFS User
    Then    the Vendor document should be in my action list

  @KFSQA-633
  Scenario: I want to create a vendor with ownership type CORPORATION that is eShop
    Given   I am logged in as a KFS User
    When    I create a Corporation and eShop Vendor
    And     I save the Vendor document
    And     I add an Attachment to the Vendor document
    And     I submit the Vendor document
    And     the Vendor document goes to ENROUTE
    And     I am logged in as a Vendor Reviewer
    And     I view the Vendor document
    And     I approve the Vendor document
    Then    the Vendor document goes to FINAL
    When    I am logged in as a KFS User
    Then    the Vendor document should be in my action list

  @KFSQA-634
  Scenario: I want to create a vendor with ownership type CORPORATION that is Foreign
    Given   I am logged in as a KFS User
    When    I create a Corporation and Foreign Vendor
    And     I save the Vendor document
    And     I add an Attachment to the Vendor document
    And     I submit the Vendor document
    And     the Vendor document goes to ENROUTE
    And     I am logged in as a Vendor Reviewer
    And     I view the Vendor document
    And     I approve the Vendor document
    Then    the Vendor document goes to FINAL
    When    I am logged in as a KFS User
    Then    the Vendor document should be in my action list

  @KFSQA-636
  Scenario: I want to create a vendor with ownership type CORPORATION that is NON-FOREIGN with Contract
    Given   I am logged in as a KFS User
    When    I create a Corporation and Non-Foreign Vendor with Contract
    And     I save the Vendor document
    And     I add an Attachment to the Vendor document
    And     I submit the Vendor document
    And     the Vendor document goes to ENROUTE
    And     I am logged in as a Vendor Reviewer
    And     I view the Vendor document
    And     I approve the Vendor document
    Then    the Vendor document goes to FINAL
    When    I am logged in as a KFS User
    Then    the Vendor document should be in my action list

  @KFSQA-637
  Scenario: I want to create a vendor with ownership type INDIVIDUAL that is NON-FOREIGN with Insurance
    Given   I am logged in as a KFS User
    When    I create an Individual and Non-Foreign Vendor with Insurance
    And     I save the Vendor document
    And     I add an Attachment to the Vendor document
    And     I submit the Vendor document
    And     the Vendor document goes to ENROUTE
    And     I am logged in as a Vendor Reviewer
    And     I view the Vendor document
    And     I approve the Vendor document
    Then    the Vendor document goes to FINAL
    When    I am logged in as a KFS User
    Then    the Vendor document should be in my action list
