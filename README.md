# Drone-Delivery-Dispatch-Database


Database application to manage and view a system that monitors deliveries of grocery products to customers. The 
cstomers will place orders with the service. The service will coordinate with grocery stores to find the products 
(at variable – but hopefully the lowest – prices) and arrange for a drone to deliver the products to the customer.
On delivery, the store will be paid electronically by the customer.


# How to set up:

Navigate into the main directory where the requirements.txt is located. use the following command to install all dependencies: 'pip install -r requirements.txt' This should setup your code. then follow instructions to run the application.


# How to run:

Navigate to the directory containing app.py. Run the Flask application using the following command: 'Flask run' or 'python app.py'



# Brief Explanation of Technologies and How They Work:

Flask: A micro web framework for Python, used for building web applications.

Flask-SQLAlchemy: An extension for Flask that adds support for SQLAlchemy, which is a SQL toolkit and Object-Relational Mapping (ORM) system for Python.

LangChain: A library that facilitates the building of applications combining language models with other systems, like databases. It allows developers to harness the power of large language models for tasks that involve understanding and generating human-like responses based on complex data sources.

ChatOpenAI: A component of LangChain that interfaces with OpenAI's models (like GPT-3.5 or GPT-4) to generate responses. This is used in your scripts to generate SQL queries or process natural language queries related to the database.

pymysql: A Python library that implements the MySQL client protocol; it allows Python to interact with a MySQL database server.



# Contributors: 
Our team for CS 4400 consisted of the following members:

Naughton, Colin P (naughtoncolin)
Riddhi, Sheikh Munim (sriddhi3)
Joshi, Lokesh (lokeshj)
Otsuka, Ryan G (rotsuka6)