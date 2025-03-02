CREATE TABLE Department (
    Num_S INT PRIMARY KEY,
    Label VARCHAR(255) NOT NULL,
    Manager_Name VARCHAR(255)
);

CREATE TABLE Employee (
    Num_E INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Position VARCHAR(255),
    Salary DECIMAL(10, 2),
    Department_Num_S INT,
    FOREIGN KEY (Department_Num_S) REFERENCES Department(Num_S)
);

CREATE TABLE Project (
    Num_P INT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Start_Date DATE,
    End_Date DATE,
    Department_Num_S INT,
    FOREIGN KEY (Department_Num_S) REFERENCES Department(Num_S)
);

CREATE TABLE Employee_Project (
    Employee_Num_E INT,
    Project_Num_P INT,
    Role VARCHAR(255),
    PRIMARY KEY (Employee_Num_E, Project_Num_P),
    FOREIGN KEY (Employee_Num_E) REFERENCES Employee(Num_E),
    FOREIGN KEY (Project_Num_P) REFERENCES Project(Num_P)
);


-- Retrieve names of employees assigned to more than one project with total project count
SELECT Employee.Name, COUNT(Employee_Project.Project_Num_P) AS Total_Projects
FROM Employee
JOIN Employee_Project ON Employee.Num_E = Employee_Project.Employee_Num_E
GROUP BY Employee.Name
HAVING COUNT(Employee_Project.Project_Num_P) > 1;

-- Retrieve projects managed by each department
SELECT Department.Label AS Department, Department.Manager_Name, Project.Title AS Project_Title
FROM Department
JOIN Project ON Department.Num_S = Project.Department_Num_S;

-- Retrieve employees working on 'Website Redesign' project with their roles
SELECT Employee.Name, Employee_Project.Role
FROM Employee
JOIN Employee_Project ON Employee.Num_E = Employee_Project.Employee_Num_E
JOIN Project ON Employee_Project.Project_Num_P = Project.Num_P
WHERE Project.Title = 'Website Redesign';

-- Retrieve department with the highest number of employees
SELECT Department.Label AS Department, Department.Manager_Name, COUNT(Employee.Num_E) AS Total_Employees
FROM Department
JOIN Employee ON Department.Num_S = Employee.Department_Num_S
GROUP BY Department.Label, Department.Manager_Name
ORDER BY Total_Employees DESC

-- Retrieve employees earning more than 60,000 with their department names
SELECT Employee.Name, Employee.Position, Department.Label AS Department
FROM Employee
JOIN Department ON Employee.Department_Num_S = Department.Num_S
WHERE Employee.Salary > 60000;

-- Retrieve number of employees assigned to each project
SELECT Project.Title AS Project_Title, COUNT(Employee_Project.Employee_Num_E) AS Total_Employees
FROM Project
LEFT JOIN Employee_Project ON Project.Num_P = Employee_Project.Project_Num_P
GROUP BY Project.Title;

-- Retrieve summary of roles employees have across projects
SELECT Employee.Name, Project.Title AS Project_Title, Employee_Project.Role
FROM Employee
JOIN Employee_Project ON Employee.Num_E = Employee_Project.Employee_Num_E
JOIN Project ON Employee_Project.Project_Num_P = Project.Num_P;

-- Retrieve total salary expenditure for each department
SELECT Department.Label AS Department, Department.Manager_Name, SUM(Employee.Salary) AS Total_Salary_Expenditure
FROM Department
JOIN Employee ON Department.Num_S = Employee.Department_Num_S
GROUP BY Department.Label, Department.Manager_Name;
