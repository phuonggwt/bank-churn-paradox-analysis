# ⚙️ Feature Specification: Automated "Welcome Back" Triggers

> **Document Purpose:** This document translates the data-driven insights from the "Loyalty Slumber" paradox into an actionable system feature. It outlines the process flow, business rules, and functional requirements needed to automate customer retention.

---
### 1. Process Flow Design (BPMN)
*This diagram illustrates the automated daily batch job and the cross-system data flow between Core Banking, CRM, and the Customer's Mobile App.*

![BPMN Flow: Automated Retention Triggers](./BPMN%20Diagram.drawio.png)

---

### 2. Business Rules (System Logic)
The automated batch job evaluates the customer database against the following rules. A customer must meet **ALL** conditions to be triggered for the retention campaign.

| Rule ID | Parameter | Logic / Condition | Business Context |
| :--- | :--- | :--- | :--- |
| **BR-01** | Account Status | `Account_Status = 'Active'` AND `Balance > 0` | Ensures the bank is not spending marketing budget on closed accounts or accounts with zero profitability. |
| **BR-02** | Veteran Segment | `Tenure >= 84 months` (7 years) | Targets the specific "Loyalty Slumber" segment identified in the data analysis phase. |
| **BR-03** | Inactivity Trigger | `Days_Since_Last_User_Txn >= 90 days` | Defines "inactive" as no user-initiated Debit/Credit transactions in the last 3 months (excludes system maintenance fees). |
| **BR-04** | Frequency Cap | `Last_Campaign_Date < (Today - 30 days)` | Prevents notification spamming and offer abuse by limiting the incentive to maximum 1 time per month per user. |

---

### 3. Functional Requirements (User Stories)

#### User Story 1: Daily Batch Job & Data Push (Core Banking)
> **As a** System Administrator,
> **I want** the Core Banking system to automatically run a daily scan at 00:00 to identify customers matching the "Loyalty Slumber" criteria and send their data to the CRM,
> **So that** the marketing team can proactively target them without manual data extraction.

**Acceptance Criteria (Given / When / Then):**
* **Given** the system clock hits 00:00 AM daily.
* **When** the batch job executes.
* **Then** the system must successfully filter the database using rules `BR-01`, `BR-02`, `BR-03`, and `BR-04`.
* **And** generate a JSON payload containing `[CustomerID, FullName, CurrentBalance]`.
* **And** successfully invoke the CRM API to push this payload.
* **And** log the number of processed records in the System Audit Trail.

#### User Story 2: Automated "Welcome Back" Push Notification (CRM)
> **As a** Campaign Manager,
> **I want** the CRM system to receive the eligible customer list and automatically trigger a personalized Push Notification with a cashback voucher,
> **So that** we can incentivize inactive veteran users to open the mobile app and perform a new transaction.

**Acceptance Criteria:**
* **Given** the CRM system receives the JSON payload from Core Banking.
* **When** the payload is processed.
* **Then** the CRM must generate a unique 5% cashback promo code for each `CustomerID`.
* **And** send a Push Notification to the user's Mobile App with the text: *"Hi [FullName], we miss you! Here is a 5% cashback voucher for your next transaction."*
* **And** if the user performs a transaction within 7 days, the Core Banking system must update their status tag to `ACTIVE`.
