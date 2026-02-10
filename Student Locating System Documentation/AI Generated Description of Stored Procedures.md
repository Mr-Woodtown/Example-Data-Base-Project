## **Stored Procedure Documentation**

### **1. `enter_pulltime`**

**Purpose:** Records when a student was pulled for help with a specific date

- **Parameters:**
    - `S_Name` (CHAR(30)) - Student's name
    - `Entered_Date` (DATE) - Date the student received help
- **Action:** Inserts a new record into the TimePulled table
- **Use Case:** Manual entry of historical help sessions with specific dates

---

### **2. `just_pulled`**

**Purpose:** Records when a student is currently being pulled and retrieves their help history

- **Parameters:**
    - `S_Name` (CHAR(30)) - Student's name
    - `Cur_Period` (TINYINT UNSIGNED) - Current class period
- **Actions:**
    - Inserts new record with student name and period
    - Returns student's help history (name and dates)
- **Use Case:** Real-time logging when pulling a student from class

---

### **3. `studentSessions`**

**Purpose:** Retrieves complete help session history for a specific student

- **Parameters:**
    - `S_Name` (CHAR(30)) - Student's name
- **Returns:** Student's help dates and name, ordered chronologically
- **Use Case:** Reviewing a student's tutoring attendance pattern

---

### **4. `teacherLunch`**

**Purpose:** Looks up a teacher's lunch period

- **Parameters:**
    - `T_Name` (VARCHAR(20)) - Teacher's name
- **Returns:** Teacher name and their lunch period
- **Use Case:** Scheduling - finding when a teacher is available during lunch

---

### **5. `studentPeriod`**

**Purpose:** Gets comprehensive information about a student's class during a specific period

- **Parameters:**
    - `S_Name` (VARCHAR(30)) - Student's name
    - `Cur_Period` (TINYINT) - Class period number
- **Returns:**
    - Student name and preferences
    - Teacher name and room number
    - Whether student is easy to pull from this class
- **Use Case:** Determining optimal times to pull students without disrupting their education

---

### **6. `update_grade`**

**Purpose:** Updates a student's approximate math grade

- **Parameters:**
    - `S_Name` (VARCHAR(30)) - Student's name
    - `Grade` (VARCHAR(3)) - New grade (e.g., "A+", "B-", "C")
- **Action:** Updates the student's math grade in the Student table
- **Use Case:** Maintaining current academic standing for tutoring prioritization

---

**Note:** There appears to be a small issue in the `just_pulled` procedure - the SELECT statement references `Cur_Period` but it should likely be `PeriodPulled` to match the inserted column.