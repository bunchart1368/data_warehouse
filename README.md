# Data Warehousing Final Project  

This repository contains the final project for the **Data Warehousing course** at the **Faculty of Engineering, Chulalongkorn University, Thailand**.  

The project demonstrates an **end-to-end pipeline** for data warehousing: from **data extraction, cleaning, and transformation** to **loading into a warehouse** and finally producing **business insights via visualization**.  

The implementation showcases our ability to combine **engineering concepts with business understanding**, using **AWS cloud services** and **data modeling techniques** to illustrate the business impact of analytics.  

---

## 📑 Table of Contents  
1. [Objectives](#-objectives)  
2. [Tools & Technologies](#-tools--technologies)  
3. [Source System](#-source-system)  
4. [Data Preparation & Cleaning](#-data-preparation--cleaning)  
5. [Slowly Changing Dimensions (SCD)](#-slowly-changing-dimensions-scd)  
6. [Schema Design](#-schema-design)  
7. [ETL Workflow](#-etl-workflow)  
8. [Visualization & Business Insights](#-visualization--business-insights)  
9. [Authors](#-authors)  
10. [Project Structure](#-project-structure)  

---

## 📚 Objectives  
- Design and implement a data warehouse from an **OLTP source system** (AdventureWorks).  
- Apply **ETL processes** for data preparation and transformation.  
- Implement **data modeling concepts** including fact/dimension tables and slowly changing dimensions (SCD).  
- Build **dashboards and reports** to highlight actionable **business insights**.  

---

## 🛠 Tools & Technologies  
- **Microsoft SQL Server (SSMS)** – database management and SQL queries.  
- **AWS Relational Database Service (RDS)** – cloud-based data warehouse.  
- **AWS Glue** – ETL orchestration and workflow management.  
- **Power BI** – data visualization and dashboard creation.  

---

## 📊 Source System  
We used **AdventureWorks**, a sample Microsoft database simulating a bike and gear retail company.  

### Key Activities Modeled:
- **Sales Orders**  
  - Sales per order & per product  
  - Dimensions: Date, Customer, Employee, Currency Rate, Credit Card, Shipment, Address, Store  
  - Metrics: SubTotal, TaxAmt, Freight, TotalDue, Discounts, Net Price, Total Product Order  

- **Purchasing Products**  
  - Purchases per order & per product  
  - Dimensions: Date, Product, Employee, Shipment, Vendor  
  - Metrics: OrderQty, UnitPrice, LineTotal, ReceivedQty, RejectedQty, StockedQty, SubTotal, TaxAmt, Freight, TotalDue  

---

## 🧹 Data Preparation & Cleaning  
- Removed invalid customers (null `PersonID` or `StoreID`).  
- Filtered `Person.Person` to include only Employees and Customers.  
- Removed SalesPersons with `SalesQuota = null`.  
- Aggregated `SalesOrderDetail` into **OrderPromotionDim** for order-level summaries.  

---

## 🔄 Slowly Changing Dimensions (SCD)  
We applied different SCD strategies:  
- **Type 0** – Static data (Date).  
- **Type 1** – Overwrite changes (Currency Rate, Credit Card, Vendor).  
- **Type 2** – Track history (Customer, Address, Product, Store).  
- **Hybrid (Type 7)** – Current + historical tracking (Employee, Sales Employee).  

---

## 🏗 Schema Design  
- **Entity-Relationship Diagrams** designed in Power BI.  
- **Conformed Bus Matrix** ensures consistent dimensions across facts:  

**FactSalesOrder Dimensions:**  
Date_Dim, Customer_Dim, Sales_Employee_Dim, Employee_Dim,  
CustomerAddress_Dim, Shipment_Dim, CreditCard_Dim,  
CurrencyRate_Dim, Store_Dim  

**FactPurchasingProduct Dimensions:**  
Date_Dim, Employee_Dim, Shipment_Dim, Product_Dim, Vendor_Dim  


---

## ⚙️ ETL Workflow  
- **AWS Glue** used for ETL orchestration.  
- Data transformations executed in Glue and loaded into **fact/dimension tables** on AWS RDS.  
- Final clean tables loaded back to the source database for visualization.  

---

## 📈 Visualization & Business Insights  
- **Power BI dashboard** built on top of fact/dimension tables.  
- Provided business insights on **sales trends, purchasing efficiency, and financial performance**.  
- Showed the **impact of discounts, freight costs, and employee sales performance**.  

---

## 👨‍🎓 Authors  
- **Kantapong Horaraung**  
- **Pasin Sukumalchan**  
- **Norapath Arjanurak**  
- **Tanyaton Oranrigsupak**  

---

## 📑 Project Structure  
- `AWS Glue (ETL process)/` – Scripts and workflow for ETL.  
- `All_DW_ddl.sql` – DDL scripts for creating warehouse schema.  
- `Purchasing_fact_diagram.png` – ER diagram for purchasing fact.  
- `Sales_fact_diagram.pdf` – ER diagram for sales fact.  
- `starschema_snowflake_diagram.pdf` – Schema design.  
- `BI dashboard/` – Power BI reports and visualizations.  
- `Slide_presentation_project1.pdf` – Final project presentation.  
