from flask import Flask, render_template, request, jsonify, redirect, url_for
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import text

app = Flask(__name__)
app.config.from_pyfile('config.py')
db = SQLAlchemy(app)

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST' and 'table_name' in request.form:
        selected_table = request.form['table_name']
        query = text(f"SELECT * FROM {selected_table}")
        result = db.session.execute(query)
        columns = list(result.keys())
        data = [dict(zip(columns, row)) for row in result.fetchall()]
        return jsonify({'data': data, 'columns': columns})
    else:
        query = text("SHOW TABLES")
        result = db.session.execute(query)
        tables = [row[0] for row in result]
        return render_template('index.html', tables=tables)

@app.route('/add_customer', methods=['POST'])
def add_customer():
    data = request.form
    try:
        db.session.execute(
            text("CALL add_customer(:uname, :first_name, :last_name, :address, :birthdate, :rating, :credit)"),
            {
                'uname': data['uname'],
                'first_name': data['first_name'],
                'last_name': data['last_name'],
                'address': data['address'],
                'birthdate': data['birthdate'],
                'rating': data['rating'],
                'credit': data['credit']
            }
        )
        db.session.commit()
        return jsonify({'success': True})
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)})

if __name__ == '__main__':
    app.run(debug=True)
