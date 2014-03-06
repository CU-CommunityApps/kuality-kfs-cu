Feature: import csv for accounting lines on multiple documents

[KFSQA-643] 14-Accounting Line Description from Import Template updates General Ledger. Cornell University requires an Accounting Line Description uploaded through an Import Template to be recorded in the General Ledger.

@wip @KFSQA-643 @cornell
Scenario Outline: Checking General Ledger for Accounting Line Description using from Import Template
  Given   I am logged in as a KFS User for the <type code> document
  And     I start a <document> document for "<file name>" file import
  And     On the <document> I import the <From To> Accounting Lines from a csv file
  And     I submit the <document> document
  And I sleep for 5
  And     I am logged in as "dh273"
  When    I view the <document> document
  When    I blanket approve the <document> document
  And     I am logged in as a KFS System Manager
#  And    I Run the Nightly Process
  When    I view the <document> document
  #from the General Ledger
#  When    I lookup the Document ID from the General Ledger
#  Then    The Template Accounting Line Description equal the General Ledger
#Accounting Line Description for all these eDocs
Examples:
 | document               |type code| From To | file name            |
 | Auxiliary Voucher      | AV      | From    | AV_import.csv        |
 | Non Check Disbursement | ND      | From    | ND_import.csv        |
 | Advance Deposit        | AD      | From    | AD_import.csv        |
#| Credit Card Receipt    | CCR     | From    | CCR_import.csv       |
     #ccr needs ccs1 to blanket approve
  #SB needs chl52 initiate,

  @wip @KFSQA-643 @cornell
  Scenario Outline: Checking General Ledger for Accounting Line Description using from and to Import Templates
    Given   I am logged in as a KFS User for the <type code> document
    And     I start a <document> document for from "<From file name>" file import and to "<To file name>" file import
    And     On the <document> I import the From Accounting Lines from a csv file
    And     On the <document> I import the To Accounting Lines from a csv file
    And     I submit the <document> document
    And I sleep for 10
    And     I am logged in as "dh273"
# TO FIX
    When    I view the <document> document
    When    I blanket approve the <document> document
    And     I am logged in as a KFS System Manager
  #  And    I Run the Nightly Process
    When    I view the <document> document
    #from the General Ledger
  #  When    I lookup the Document ID from the General Ledger
#    Then    The Template Accounting Line Description equal the General Ledger
  #Accounting Line Description for all these eDocs

Examples:
| document                             | type code | From file name                | To file name               |
| Budget Adjustment                    | BA        | BA_import_from.csv            | BA_import_to.csv           |
| Distribution of Income and Expense   | DI        | DI_import_from.csv            | DI_import_to.csv           |
| General Error Correction             | GEC       | GEC_import_from.csv           | GEC_import_to.csv          |
| Internal Billing                     | IB        | IB_expense_import.csv         | IB_income_import.csv       |
| Service Billing                      | SB        | SB_expense_line2_import.csv   | SB_income_line1_import.csv |
| Transfer of Funds                    | TF        | TF_import_from.csv            | TF_import_to.csv           |
#   IB should be dh273 blanket approve


#Examples:
# | Journal Voucher | JV | JV-1_offset_bal_type_import.csv | JV-2_non_offset_bal_type_import.csv | JV-3_ext_encumbr_import.csv |
