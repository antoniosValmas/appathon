# 092020 Appathon
## Requirements
- Java 6
- MySQL 5.7 (jdbc)
- Tomcat 9.0
- Eclipse EE

## Setup

Import project into eclipse and resolve any missing/invalid dependencies

Edit DBService to change the mysql credentials

Create two directories:
- products: Directory that contains product data to be imported
- order: Directory where orders are saved

and edit the respective paths in `import-products.jsp`, `OrderServlet.java`

Run the server and go to `localhost:8080/Appathon/` (login screen)

Create user with username `admin` to have access to the `products-import` functionality

Once you login click the `import products link` to seed the database with products

You should add data manually to the `vouchers` (studentdiscount) and `country_vat` tables

## Import products CSV format
Columns:
- Id {integer} The product id. Must be unique
- Name {String} The product's name. Cannot be more than 200 characters
- Image {URL} The product's image. Can be a url, or a local path (relative or absolute)
- price {Double} The product's price without VAT

The name of the csv must be "products.csv". However you can change this by editing the path on `import-products.jsp`


