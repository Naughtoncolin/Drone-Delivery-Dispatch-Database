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

@app.route('/add_drone_pilot', methods=['POST'])
def add_drone_pilot():
    data = request.form
    try:
        db.session.execute(
            text("""
                CALL add_drone_pilot(:uname, :first_name, :last_name, :address, :birthdate, :taxID, :service, :salary, :licenseID, :experience)
            """),
            {
                'uname': data['uname'],
                'first_name': data['first_name'],
                'last_name': data['last_name'],
                'address': data['address'],
                'birthdate': data['birthdate'],
                'taxID': data['taxID'],
                'service': int(data['service']),
                'salary': int(data['salary']),
                'licenseID': data['licenseID'],
                'experience': int(data['experience'])
            }
        )
        db.session.commit()
        return jsonify({'success': True})
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)})

@app.route('/remove_customer', methods=['POST'])
def remove_customer():
    data = request.form
    try:
        db.session.execute(
            text("CALL remove_customer(:uname)"),
            {'uname': data['uname']}
        )
        db.session.commit()
        return jsonify({'success': True})
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)})

@app.route('/customer_credit_check', methods=['GET'])
def customer_credit_check():
    query = text("SELECT * FROM customer_credit_check")
    result = db.session.execute(query)
    columns = list(result.keys())
    data = [dict(zip(columns, row)) for row in result.fetchall()]
    return jsonify({'data': data, 'columns': columns})

@app.route('/drone_traffic_control', methods=['GET'])
def drone_traffic_control():
    query = text("SELECT * FROM drone_traffic_control")
    result = db.session.execute(query)
    columns = list(result.keys())
    data = [dict(zip(columns, row)) for row in result.fetchall()]
    return jsonify({'data': data, 'columns': columns})

@app.route('/most_popular_products', methods=['GET'])
def most_popular_products():
    query = text("SELECT * FROM most_popular_products")
    result = db.session.execute(query)
    columns = list(result.keys())
    data = [dict(zip(columns, row)) for row in result.fetchall()]
    return jsonify({'data': data, 'columns': columns})

@app.route('/drone_pilot_roster', methods=['GET'])
def drone_pilot_roster():
    query = text("SELECT * FROM drone_pilot_roster")
    result = db.session.execute(query)
    columns = list(result.keys())
    data = [dict(zip(columns, row)) for row in result.fetchall()]
    return jsonify({'data': data, 'columns': columns})

@app.route('/store_sales_overview', methods=['GET'])
def store_sales_overview():
    query = text("SELECT * FROM store_sales_overview")
    result = db.session.execute(query)
    columns = list(result.keys())
    data = [dict(zip(columns, row)) for row in result.fetchall()]
    return jsonify({'data': data, 'columns': columns})

@app.route('/orders_in_progress', methods=['GET'])
def orders_in_progress():
    query = text("SELECT * FROM orders_in_progress")
    result = db.session.execute(query)
    columns = list(result.keys())
    data = [dict(zip(columns, row)) for row in result.fetchall()]
    return jsonify({'data': data, 'columns': columns})

if __name__ == '__main__':
    app.run(debug=True)
