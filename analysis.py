import pandas as pd


try:

    df = pd.read_csv("all_transactions.csv")

    print("\n ALL TRANSACTIONS ")
    print(df.to_string(index=False))


    
    deposits = df[df["Type"] == "Deposit"]
    withdrawals = df[df["Type"] == "Withdrawal"]


    print("\n OVERALL ANALYSIS ")

    print("Total Deposited:",
          deposits["Amount"].sum())

    print("Total Withdrawn:",
          withdrawals["Amount"].sum())

    print("Number of Deposits:",
          len(deposits))

    print("Number of Withdrawals:",
          len(withdrawals))


    if len(deposits) > 0:
        print("Average Deposit:",
              deposits["Amount"].mean())

    if len(withdrawals) > 0:
        print("Average Withdrawal:",
              withdrawals["Amount"].mean())


    # Account-wise analysis
    print("\nACCOUNT-WISE ANALYSIS")

    account_summary = df.groupby(
        ["Account", "Name"]
    )["Amount"].sum()

    print(account_summary)


except FileNotFoundError:

    print("all_transactions.csv not found.")
    print("First run bank_account.py and choose")
    print("'Save All Transactions'.")
