'''Query database using langchain query chain'''

#pip install -U langchain langchain-community langchain-openai
#pip install pymysql
import config
from langchain_openai import ChatOpenAI
from langchain.chains import create_sql_query_chain
from langchain_community.utilities import SQLDatabase

import pymysql
pymysql.install_as_MySQLdb()

db_location = config.mnt_location
db = SQLDatabase.from_uri(db_location) # Required creating remote account and allowing access

llm = ChatOpenAI(model="gpt-4", temperature=0)
chain = create_sql_query_chain(llm, db)
#response = chain.invoke({"question": "How many employees are there"})
response = chain.invoke({"question": "Print the names and salaries of the drone pilots with salaries over $40k."})
print(response)'''