# Local Development Setup & Database Configuration Guide
**Project**: eFile941 - IRS Form 941 Web Portal  
**Target Environment**: Windows / Linux / macOS  
**Document Created**: August 20, 2026  
**Last Updated**: August 22, 2026  

---

## 1. Local Prerequisites & Required Software

To set up and run **eFile941** on your local machine, install the following software components:

| Component | Minimum Version | Recommended Version | Purpose |
| :--- | :--- | :--- | :--- |
| **Java Development Kit (JDK)** | JDK 17 | OpenJDK / Temurin 17 or 21 | Core Java runtime and compilation |
| **Apache Tomcat** | Tomcat 10.1.0+ | Tomcat 10.1.18+ | Jakarta EE 10 Servlet Container |
| **PostgreSQL Database** | PostgreSQL 14 | PostgreSQL 15 or 16 | Relational Database Engine |
| **Apache Maven** | Maven 3.8.0+ | Maven 3.9.x | Build and dependency management |
| **Integrated Development Environment (IDE)** | Eclipse 2023-09+ / IntelliJ IDEA | Eclipse IDE for Enterprise Java & Web | Code development & Tomcat deployment |

> [!IMPORTANT]
> **Tomcat 10.1+ Requirement**: This project requires **Apache Tomcat 10.1+** because it uses native `jakarta.servlet` namespace (Jakarta EE 10). Do not run on Tomcat 9 or earlier (`javax.servlet`), as JSP pages and Spring MVC servlets will fail to load.

---

## 2. Database Setup & Initialization

### Step 2.1: Create PostgreSQL Database
1. Open **pgAdmin** or connect to PostgreSQL via `psql` command line:
   ```bash
   psql -U postgres
   ```
2. Create the target database:
   ```sql
   CREATE DATABASE efile941_db WITH OWNER = postgres ENCODING = 'UTF8';
   ```

### Step 2.2: Execute Schema Migration Script
1. Connect to the `efile941_db` database:
   ```sql
   \c efile941_db;
   ```
2. Run the database migration script located in the codebase at:
   `src/main/resources/db/migration/V1__init_schema.sql`

   Or run via command line:
   ```bash
   psql -U postgres -d efile941_db -f src/main/resources/db/migration/V1__init_schema.sql
   ```

---

## 3. Configuration Properties Files (3 Dedicated Files)

The application separates core settings into **3 distinct configuration files** located under `src/main/resources/`:

| Config File | Path | Description |
| :--- | :--- | :--- |
| 🗄️ **`db.properties`** | `src/main/resources/db.properties` | PostgreSQL connection URL, credentials, and HikariCP connection pool settings. |
| 🏛️ **`irs-mef.properties`** | `src/main/resources/irs-mef.properties` | IRS Modernized e-File (MeF) transmission EFIN, ETIN, Software ID, and gateway endpoints. |
| 💳 **`authorize.properties`** | `src/main/resources/authorize.properties` | Authorize.Net payment gateway API Login ID, Transaction Key, Environment, and Filing Fee. |

---

### Step 3.1: `db.properties` Configuration

📁 `src/main/resources/db.properties`

```properties
# Database Connection Properties
db.driver=org.postgresql.Driver
db.url=jdbc:postgresql://localhost:5432/efile941_db?options=-c%20timezone=UTC
db.username=postgres
db.password=root

# HikariCP Connection Pool Defaults
db.hikari.maximumPoolSize=20
db.hikari.minimumIdle=5
db.hikari.idleTimeout=300000
db.hikari.connectionTimeout=30000
```

---

### Step 3.2: `irs-mef.properties` Configuration

📁 `src/main/resources/irs-mef.properties`

```properties
# IRS MeF Transmission Credentials
irs.mef.efin=${IRS_MEF_EFIN:10-1234}
irs.mef.etin=${IRS_MEF_ETIN:12345}
irs.mef.dgvrPin=${IRS_MEF_DGVR_PIN:54321}
irs.mef.softwareId=${IRS_MEF_SOFTWARE_ID:SW941APP2026}
irs.mef.returnVersion=${IRS_MEF_RETURN_VERSION:2026v4.0}
irs.mef.formVersion=${IRS_MEF_FORM_VERSION:2026v1.0}
irs.mef.namespace=${IRS_MEF_NAMESPACE:http://www.irs.gov/efile}

# IRS MeF Endpoints
irs.mef.useProduction=${IRS_MEF_USE_PRODUCTION:false}
irs.mef.endpoint.ats=${IRS_MEF_ENDPOINT_ATS:https://mefats.irs.gov/mefv2/services/MefSubmissionService}
irs.mef.endpoint.production=${IRS_MEF_ENDPOINT_PRODUCTION:https://mef.irs.gov/mefv2/services/MefSubmissionService}
```

---

### Step 3.3: `authorize.properties` Configuration

📁 `src/main/resources/authorize.properties`

```properties
# Authorize.Net Payment Gateway API Credentials
authorizenet.apiLoginId=${AUTHORIZENET_API_LOGIN_ID:API_LOGIN_ID_HERE}
authorizenet.transactionKey=${AUTHORIZENET_TRANSACTION_KEY:TRANSACTION_KEY_HERE}
authorizenet.clientKey=${AUTHORIZENET_CLIENT_KEY:CLIENT_KEY_HERE}

# Environment: SANDBOX or PRODUCTION
authorizenet.environment=${AUTHORIZENET_ENVIRONMENT:SANDBOX}

# Form 941 E-Filing Fee ($ USD)
authorizenet.filingFee=${AUTHORIZENET_FILING_FEE:19.99}
```

---

## 4. Build and Running the Application

### Step 4.1: Build WAR File with Maven
In the project root directory, run:
```bash
mvn clean package
```
This produces the packaged WAR file at `target/efile941.war`.

### Step 4.2: Deploy to Apache Tomcat 10
1. Copy `target/efile941.war` to your Tomcat `webapps/` folder.
2. Start Tomcat:
   - **Windows**: `bin/startup.bat`
   - **Linux/macOS**: `bin/startup.sh`
3. Access the portal in your browser:
   `http://localhost:8080/efile941/`

---

## 5. Summary Checklist for Quick Setup

- [ ] Installed **JDK 17** and set `JAVA_HOME`.
- [ ] Installed **Apache Tomcat 10.1+**.
- [ ] Created PostgreSQL database named `efile941_db`.
- [ ] Executed `src/main/resources/db/migration/V1__init_schema.sql`.
- [ ] Configured `src/main/resources/db.properties`.
- [ ] Configured `src/main/resources/irs-mef.properties`.
- [ ] Configured `src/main/resources/authorize.properties`.
- [ ] Built project with `mvn clean package`.
- [ ] Deployed `efile941.war` to Tomcat 10 and verified portal at `http://localhost:8080/efile941/`.
