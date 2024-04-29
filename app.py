from flask import Flask, render_template, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import text

app = Flask(__name__)
app.config.from_pyfile('config.py')
db = SQLAlchemy(app)

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        selected_table = request.form.get('table_name')
        query = text(f"SELECT * FROM {selected_table}")
        result = db.session.execute(query)
        columns = list(result.keys())  # Explicitly convert to list
        data = [dict(zip(columns, row)) for row in result.fetchall()]  # Fetch all rows at once
        return jsonify({'data': data, 'columns': columns})  # Return data as JSON
    else:
        query = text("SHOW TABLES")
        result = db.session.execute(query)
        tables = [row[0] for row in result]
        return render_template('index.html', tables=tables)

if __name__ == '__main__':
    app.run(debug=True)
