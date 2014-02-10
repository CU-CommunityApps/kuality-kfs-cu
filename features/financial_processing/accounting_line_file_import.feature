Feature: import csv for accounting lines on multiple documents

[KFSQA-643] 14-Accounting Line Description from Import Template updates General Ledger

Background: Cornell University requires an Accounting Line Description uploaded through an Import Template to be recorded in the General Ledger.

Scenario Outline: Accounting Line Description from Import Template updates General Ledger

  Given    I am logged in as a KFS Technical Administrator
#  And      I create an empty <document> document
  And      I create a blank '<document>' document
#  And       I enter a description for using the <document> document name
  And      For the <document> document I upload a csv file <from file name> with From accounting lines
  And      For the <document> document I upload a csv file <to file name> with To accounting lines
#  And      I upload csv file <to file name> containing to accounting lines
  When     I blanket approve the <document> document

#  And      I am logged in as a KFS Administrator
#  And      I Run the Nightly Process
#  When   I lookup the Document ID from the General Ledger for all these eDocs
#  Then    The Template Accounting Line Description equal the General Ledger
#Accounting Line Description for all these eDocs

Examples:
 | document                             | from file name               | to file name               |
#single accoutning lines | Auxiliary Voucher                    | AV_accounting_lines_from.csv | AV_accounting_lines_to.csv |
 | Budget Adjustment                    | BA_accounting_lines_from.csv | BA_accounting_lines_to.csv |
 | Distribution of Income and Expense   | DI_accounting_lines_from.csv | DI_accounting_lines_to.csv |
 | General Error Correction             | GC_accounting_lines_from.csv | GC_accounting_lines_to.csv |
#special | Internal Billing                     | IB_accounting_lines_from.csv | IB_accounting_lines_to.csv |
 | Non Check Disbursement               | ND_accounting_lines_from.csv | ND_accounting_lines_to.csv |
 | Pre Encumbrance                      | PE_accounting_lines_from.csv | PE_accounting_lines_to.csv |
 | Transfer of Funds                    | TF_accounting_lines_from.csv | TF_accounting_lines_to.csv |

