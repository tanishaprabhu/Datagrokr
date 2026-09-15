import pandas as pd
from datetime import datetime
class BankAccount:
    def __init__(self, account_number, name, balance=0):
        self.account_number = account_number
        self.name = name
        self.balance = balance
        self.transactions = []

    def deposit(self, amount):
        if amount <= 0:
            print("Invalid amount")
            return
        self.balance += amount
        self.transactions.append({
            "Account": self.account_number,
            "Name": self.name,
            "Type": "Deposit",
            "Amount": amount,
            "Balance": self.balance,
            "Date": datetime.now()
        })

        print("Amount deposited successfully.")
        print("Current balance:", self.balance)

    def withdraw(self, amount):
        if amount <= 0:
            print("Invalid amount")
            return

        if amount > self.balance:
            print("Insufficient balance")
            return

        self.balance -= amount
        self.transactions.append({
            "Account": self.account_number,
            "Name": self.name,
            "Type": "Withdrawal",
            "Amount": amount,
            "Balance": self.balance,
            "Date": datetime.now()
        })
        print("Amount withdrawn successfully.")
        print("Current balance:", self.balance)

    def check_balance(self):
        print("\nAccount Holder:", self.name)
        print("Account Number:", self.account_number)
        print("Current Balance:", self.balance)

    def show_transactions(self):
        if len(self.transactions) == 0:
            print("No transactions found.")
            return

        df = pd.DataFrame(self.transactions)

        print("\n===== TRANSACTION HISTORY =====")
        print(df.to_string(index=False))

def save_all_transactions(accounts):
    all_transactions = []
    for account in accounts.values():
        all_transactions.extend(account.transactions)

    if len(all_transactions) == 0:
        print("No transactions to save.")
        return

    df = pd.DataFrame(all_transactions)

    df.to_csv("all_transactions.csv", index=False)

    print("All account transactions saved successfully.")
    print("File: all_transactions.csv")
accounts = {}
while True:

    print("\n BANK ACCOUNT SYSTEM ")
    print("1. Create Account")
    print("2. Deposit")
    print("3. Withdraw")
    print("4. Check Balance")
    print("5. Transaction History")
    print("6. Save All Transactions")
    print("7. Exit")

    choice = input("Enter your choice: ")
    if choice == "1":

        account_number = input("Enter account number: ")

        if account_number in accounts:
            print("Account already exists.")
            continue

        name = input("Enter account holder name: ")

        balance = float(input("Enter initial balance: "))

        if balance < 0:
            print("Initial balance cannot be negative.")
            continue

        accounts[account_number] = BankAccount(
            account_number,
            name,
            balance
        )
        print("Account created successfully.")
    elif choice == "2":
        account_number = input("Enter account number: ")
        if account_number not in accounts:
            print("Account not found.")
            continue
        amount = float(input("Enter deposit amount: "))
        accounts[account_number].deposit(amount)    
    elif choice == "3":
        account_number = input("Enter account number: ")
        if account_number not in accounts:
            print("Account not found.")
            continue

        amount = float(input("Enter withdrawal amount: "))
        accounts[account_number].withdraw(amount)
    elif choice == "4":
        account_number = input("Enter account number: ")
        if account_number not in accounts:
            print("Account not found.")
            continue

        accounts[account_number].check_balance()    
    elif choice == "5":

        account_number = input("Enter account number: ")

        if account_number not in accounts:
            print("Account not found.")
            continue

        accounts[account_number].show_transactions()
    elif choice == "6":

        save_all_transactions(accounts)    
    elif choice == "7":

        print("Thank you for using the Bank Account System.")
        break
    else:
        print("Invalid choice.")
