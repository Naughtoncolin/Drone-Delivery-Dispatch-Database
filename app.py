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

@app.route('/remove_drone_pilot', methods=['POST'])
def remove_drone_pilot():
    data = request.form
    try:
        db.session.execute(
            text("CALL remove_drone_pilot(:uname)"),
            {'uname': data['uname']}
        )
        db.session.commit()
        return jsonify({'success': True})
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)})

@app.route('/remove_drone', methods=['POST'])
def remove_drone():
    data = request.form
    try:
        db.session.execute(
            text("CALL remove_drone(:storeID, :droneTag)"),
            {'storeID': data['storeID'], 'droneTag': int(data['droneTag'])}
        )
        db.session.commit()
        return jsonify({'success': True})
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)})

@app.route('/remove_product', methods=['POST'])
def remove_product():
    data = request.form
    try:
        result = db.session.execute(
            text("CALL remove_product(:barcode)"),
            {'barcode': data['barcode']}
        )
        for row in result:
            if 'Error' in row:
                return jsonify({'error': row[0]})
        db.session.commit()
        return jsonify({'success': True})
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)})

@app.route('/add_product', methods=['POST'])
def add_product():
    data = request.form
    try:
        db.session.execute(
            text("CALL add_product(:barcode, :pname, :weight)"),
            {'barcode': data['barcode'], 'pname': data['pname'], 'weight': int(data['weight'])}
        )
        db.session.commit()
        return jsonify({'success': True})
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)})

@app.route('/add_drone', methods=['POST'])
def add_drone():
    data = request.form
    try:
        db.session.execute(
            text("CALL add_drone(:storeID, :droneTag, :capacity, :remaining_trips, :pilot)"),
            {'storeID': data['storeID'], 'droneTag': int(data['droneTag']), 'capacity': int(data['capacity']), 'remaining_trips': int(data['remaining_trips']), 'pilot': data['pilot']}
        )
        db.session.commit()
        return jsonify({'success': True})
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)})

@app.route('/increase_customer_credits', methods=['POST'])
def increase_customer_credits():
    data = request.form
    try:
        db.session.execute(
            text("CALL increase_customer_credits(:uname, :money)"),
            {'uname': data['uname'], 'money': int(data['money'])}
        )
        db.session.commit()
        return jsonify({'success': True})
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)})

@app.route('/swap_drone_control', methods=['POST'])
def swap_drone_control():
    data = request.form
    try:
        db.session.execute(
            text("CALL swap_drone_control(:incoming_pilot, :outgoing_pilot)"),
            {'incoming_pilot': data['incoming_pilot'], 'outgoing_pilot': data['outgoing_pilot']}
        )
        db.session.commit()
        return jsonify({'success': True})
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)})

@app.route('/repair_refuel_drone', methods=['POST'])
def repair_refuel_drone():
    data = request.form
    try:
        db.session.execute(
            text("CALL repair_refuel_drone(:drone_store, :drone_tag, :refueled_trips)"),
            {'drone_store': data['drone_store'], 'drone_tag': int(data['drone_tag']), 'refueled_trips': int(data['refueled_trips'])}
        )
        db.session.commit()
        return jsonify({'success': True})
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)})

@app.route('/begin_order', methods=['POST'])
def begin_order():
    data = request.form
    try:
        db.session.execute(
            text("CALL begin_order(:orderID, :sold_on, :purchased_by, :carrier_store, :carrier_tag, :barcode, :price, :quantity)"),
            {'orderID': data['orderID'], 'sold_on': data['sold_on'], 'purchased_by': data['purchased_by'], 'carrier_store': data['carrier_store'], 'carrier_tag': int(data['carrier_tag']), 'barcode': data['barcode'], 'price': int(data['price']), 'quantity': int(data['quantity'])}
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

@app.route('/role_distribution', methods=['GET'])
def role_distribution():
    query = text("SELECT * FROM role_distribution")
    result = db.session.execute(query)
    columns = list(result.keys())
    data = [dict(zip(columns, row)) for row in result.fetchall()]
    return jsonify({'data': data, 'columns': columns})

if __name__ == '__main__':
    app.run(debug=True)
