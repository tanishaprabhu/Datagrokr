import csv
subjects = ("Python", "Math", "Data Structures", "English", "Computer Networks")

students = {}

def calculate_grade(average, pass_mark=40):
    if average >= 90:
        return "A+"
    elif average >= 80:
        return "A"
    elif average >= 70:
        return "B"
    elif average >= 60:
        return "C"
    elif average >= pass_mark:
        return "D"
    else:
        return "F"

def add_student():
    name = input("Enter student name: ").strip().title()

    marks = []

    for subject in subjects:
        while True:
            try:
                mark = int(input("Enter marks in " + subject + ": "))

                if mark < 0 or mark > 100:
                    print("Marks must be between 0 and 100.")
                    continue

                marks.append(mark)
                break

            except ValueError:
                print("Please enter a valid number.")

    total = sum(marks)
    average = total / len(marks)
    grade = calculate_grade(average)

    students[name] = {
        "marks": marks,
        "total": total,
        "average": average,
        "grade": grade
    }

    print("\nStudent added successfully!")
    print("Name:", name)
    print("Total:", total)
    print("Average:", round(average, 2))
    print("Grade:", grade)

def view_students():
    if not students:
        print("\nNo student records found.")
        return

    print("\n  STUDENT RESULTS  ")

    for name, details in students.items():
        print("\nName:", name)
        print("Marks:", details["marks"])
        print("Total:", details["total"])
        print("Average:", round(details["average"], 2))
        print("Grade:", details["grade"])

def search_student():
    name = input("Enter student name to search: ").strip().title()

    if name in students:
        details = students[name]

        print("\nStudent Found!")
        print("Name:", name)
        print("Marks:", details["marks"])
        print("Total:", details["total"])
        print("Average:", round(details["average"], 2))
        print("Grade:", details["grade"])
    else:
        print("Student not found.")

def save_to_csv(filename="grades.csv"):
    with open(filename, "w", newline="") as file:
        writer = csv.writer(file)

        writer.writerow([
            "Name",
            "Python",
            "Math",
            "Data Structures",
            "English",
            "Computer Networks",
            "Total",
            "Average",
            "Grade"
        ])

        for name, details in students.items():
            writer.writerow([
                name,
                *details["marks"],
                details["total"],
                round(details["average"], 2),
                details["grade"]
            ])

    print("\nData saved to", filename)

def read_csv(filename="grades.csv"):
    try:
        with open(filename, "r") as file:
            reader = csv.reader(file)

            print("\n    CSV DATA    ")

            for row in reader:
                print(row)

    except FileNotFoundError:
        print("CSV file does not exist.")

    finally:
        print("File operation completed.")


while True:

    print("CLI GRADE CALCULATOR")
    print("1. Add Student")
    print("2. View Students")
    print("3. Search Student")
    print("4. Save Results to CSV")
    print("5. Read Results from CSV")
    print("6. Exit")

    choice = input("Enter your choice: ")

    if choice == "1":
        add_student()

    elif choice == "2":
        view_students()

    elif choice == "3":
        search_student()

    elif choice == "4":
        save_to_csv()

    elif choice == "5":
        read_csv()

    elif choice == "6":
        print("Thank you!")
        break

    else:
        print("Invalid choice. Try again.")