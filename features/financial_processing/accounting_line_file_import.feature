Feature: import csv for accounting lines on multiple documents

[KFSQA-643] 14-Accounting Line Description from Import Template updates General Ledger. Cornell University requires an Accounting Line Description uploaded through an Import Template to be recorded in the General Ledger.

@wip @KFSQA-643 @cornell
Scenario Outline: Accounting Line Description from Import Template updates General Ledger
  Given    I am logged in as a KFS User for the <document> document
  And      I start the "Auxiliary Voucher" document by importing "<file name>" file for the accounting lines
#  And      For the <document> document I upload a csv file <from file name> with From accounting lines
#  And      For the <document> document I upload a csv file <to file name> with To accounting lines
  And I sleep for 10
  When     I blanket approve the Auxiliary Voucher document


  And      I am logged in as a KFS System Manager
#  And      I Run the Nightly Process
  When      I view the <document> document
#from the General Ledger
#  When    I lookup the Document ID from the General Ledger for all these eDocs
  Then    The Template Accounting Line Description equal the General Ledger
#Accounting Line Description for all these eDocs
Examples:
 | document                             | file name            |
# | Advance Deposit                      | AD_import.csv        |
| Auxiliary Voucher                    | AV_import.csv        |
# | Credit Card Receipt                  | CCR_import.csv       |
# | Non Check Disbursement               | ND_import.csv        |

#
# Examples:
# | Budget Adjustment                    | BA_import_from.csv            | BA_import_to.csv           |
# | Distribution of Income and Expense   | DI_import_from.csv            | DI_import_to.csv           |
# | General Error Correction             | GEC_import_from.csv           | GC_import_to.csv           |
# | Internal Billing                     | IB_expense_import.csv         | IB_income_import.csv       |
# | Service Billing                      | SB_expense_line2_import.csv   | SB_income_line1_import.csv |
# | Transfer of Funds                    | TF_import_from.csv            | TF_import_to.csv           |
#

#
#Examples:
# | Journal Voucher                      | JV-1_offset_bal_type_import.csv | JV-2_non_offset_bal_type_import.csv | JV-3_ext_encumbr_import.csv |

#  And      I am logged in as a KFS Administrator
