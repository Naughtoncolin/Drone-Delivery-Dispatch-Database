'''Query database using langchain agent'''

#pip install -U langchain langchain-community langchain-openai
#pip install pymysql
import config
from langchain_openai import ChatOpenAI
from langchain_community.utilities import SQLDatabase
from langchain_community.agent_toolkits import create_sql_agent
import pymysql


# Identify database
pymysql.install_as_MySQLdb()
db_location = config.mnt_location
db = SQLDatabase.from_uri(db_location) # Required creating remote account and allowing access

# Initialize llm parameters
llm = ChatOpenAI(model="gpt-3.5-turbo", temperature=0) 
#llm = ChatOpenAI(model="gpt-4", temperature=0) # Using gpt-4 allows for formatting output better.

# Testing implementation of Mistral-7b
#from langchain_community.llms import Ollama
#llm = Ollama(model="mistral-7b")

# Read database schema
# Note: The agent didn't appear to reference all necessary table when multiple joins where needed when only using the database.
# thus the schema layout is used as a prompt to ensure all necessary tables are referenced.
schema_path = "/mnt/c/Users/Naugh/OneDrive - Georgia Institute of Technology/School/CS-4400/cs4400_phase2_database_team27.sql" # Path to file with create table and insert statements for initializing database
with open(schema_path, "r") as file:
    schema_layout = file.read()

# Initialize llm agent
# TODO: Make custom agent that uses schema layout as prompt
agent_executor = create_sql_agent(llm, db=db, agent_type="openai-tools", verbose=True)

# Have agent execute query
agent_executor.invoke(
    #"How many employees are there?"
    #"How many employees are there with salaries over $40k?"
    #"How many drone pilots are there with salaries over $40k?"
    #"Print the names and salaries of the drone pilots with salaries over $40k.
    "Print the names, addresses, and salaries of the drone pilots with salaries over $40k in table format. Use the following schema layout:" + schema_layout

)