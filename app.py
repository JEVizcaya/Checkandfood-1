from flask import Flask, render_template, request, redirect, url_for, session
import pymysql
import db
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)
app.secret_key = "123456"

# Ruta principal (Home)
@app.route('/')
def home():
    return render_template('home.html')




# Ruta para registro de restaurantes
@app.route('/registro_restaurantes', methods=['GET', 'POST'])
def registro_restaurantes():
    if request.method == 'POST':
        nombre = request.form['name']
        email = request.form['email']
        telefono = request.form['telefono']
        password = request.form['password']
        confirm_password = request.form['confirm_password']
        direccion = request.form['address']
        capacidad = request.form['capacity']

        if password == confirm_password:
            hashed_password = generate_password_hash(password)

            try:
                connection = db.get_connection()
                with connection.cursor() as cursor:
                    sql = "INSERT INTO restaurant (name, email, password, phone_number, address, capacity) VALUES (%s, %s, %s, %s, %s, %s)"
                    cursor.execute(sql, (nombre, email, hashed_password, telefono, direccion, capacidad))
                    connection.commit()
                connection.close()
                return redirect(url_for('login_restaurantes'))
            except Exception as e:
                return f"Ha ocurrido un error en la base de datos: {e}"
        else:
            return "Las contraseñas no coinciden"
    return render_template('registro_restaurantes.html')



# Ruta para login de restaurantes
@app.route('/login_restaurantes', methods=['GET', 'POST'])
def login_restaurantes():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']

        try:
           connection = db.get_connection()
           cursor = connection.cursor()

           with connection.cursor() as cursor:
                sql = "SELECT * FROM restaurant WHERE email=%s"
                cursor.execute(sql, (email,))
                restaurant = cursor.fetchone()
                connection.close()

                if restaurant and check_password_hash(restaurant['password'], password):
                    session['restaurant_id'] = restaurant['restaurant_id']
                    session['restaurant_name'] = restaurant['name']
                    return redirect(url_for('dashboard_restaurantes'))
                else:
                    return redirect(url_for('login_restaurantes', mensaje="Correo o contraseña inválidos"))
        except Exception as e:
            return f"Ha ocurrido un error en la base de datos: {e}"
    return render_template('login_restaurantes.html')



# Ruta para registro de clientes
@app.route('/registro_clientes', methods=['GET', 'POST'])
def registro_clientes():
    if request.method == 'POST':
        nombre = request.form['nombre']
        email = request.form['email']
        telefono = request.form['telefono']
        password = request.form['password']
        confirm_password = request.form['confirm_password']

        if password == confirm_password:
            hashed_password = generate_password_hash(password)

            try:
                connection = db.get_connection()
                with connection.cursor() as cursor:
                    sql = "INSERT INTO customer (name, email, password, phone_number) VALUES (%s, %s, %s, %s)"
                    cursor.execute(sql, (nombre, email, hashed_password, telefono))
                    connection.commit()
                connection.close()
                return redirect(url_for('login_clientes'))
            except Exception as e:
                return f"Ha ocurrido un error en la base de datos: {e}"
        else:
            return "Las contraseñas no coinciden"
    return render_template('registro_clientes.html')



# Ruta para login de clientes
@app.route('/login_clientes', methods=['GET', 'POST'])
def login_clientes():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']

        try:
            connection = db.get_connection()
            with connection.cursor() as cursor:
                sql = "SELECT * FROM customer WHERE email=%s"
                cursor.execute(sql, (email,))
                user = cursor.fetchone()
                connection.close()

            if user and check_password_hash(user['password'], password):
                session['user_id'] = user['customer_id']
                session['user_name'] = user['name']
                return redirect(url_for('dashboard_clientes'))
            else:
                return render_template('login_clientes.html', mensaje="Usuario o contraseña inválidos")
        except Exception as e:
            return f"Ha ocurrido un error en la base de datos: {e}"
    return render_template('login_clientes.html')




# Ruta para el dashboard del restaurante (ejemplo de página de inicio después de login)
@app.route('/dashboard_restaurantes', methods=['GET', 'POST'])
def dashboard_restaurantes():
  
    # Comprobar si el restaurante está logueado
    if 'restaurant_id' not in session:
        return redirect(url_for('login_restaurantes'))

    restaurant_id = session['restaurant_id']

    try:
        connection = db.get_connection()
        with connection.cursor() as cursor:
            # Obtener información básica del restaurante
            sql_restaurant = "SELECT name, email, phone_number, address, capacity FROM restaurant WHERE restaurant_id = %s"
            cursor.execute(sql_restaurant, (restaurant_id,))
            restaurant_info = cursor.fetchone()

            # Obtener todas las reservas del restaurante
            sql_reservations = """SELECT r.reserve_id, r.reserve_time, c.name AS customer_name, r.number_of_people
                                    FROM reserve r
                                    JOIN customer c ON r.customer_id = c.customer_id
                                    WHERE r.restaurant_id = %s
                                    AND r.estatus = 'activa'
                                    ORDER BY r.reserve_time"""
            cursor.execute(sql_reservations, (restaurant_id,))
            active_reservations = cursor.fetchall()

            # Cerrar la conexión
            connection.close()

        return render_template('dashboard_restaurantes.html', restaurant=restaurant_info, reservations=active_reservations)

    except Exception as e:
        return f"Ha ocurrido un error en la base de datos: {e}"

    
    

    

# Ruta para el dashboard del cliente (ejemplo de página de inicio después de login)
@app.route('/dashboard_clientes', methods=['GET', 'POST'])
def dashboard_clientes():
    if 'user_id' not in session:  # Si el cliente no está logueado
        return redirect(url_for('login_clientes'))

    try:
        # Obtén el ID del cliente de la sesión
        customer_id = session['user_id']

        # Conexión a la base de datos
        connection = db.get_connection()
        with connection.cursor() as cursor:
            # Obtener las reservas activas del cliente
            sql = """
               SELECT r.reserve_id, r.reserve_time, t.table_name, r.number_of_people, r.estatus
                FROM reserve r
                JOIN `table` t ON r.table_id = t.table_id
                JOIN time_slot ts ON r.time_slot_id = ts.time_slot_id
                WHERE r.customer_id = %s AND r.estatus = 'activa'
                ORDER BY r.reserve_time
            """
            cursor.execute(sql, (customer_id,))
            reservas = cursor.fetchall()  # Obtener todas las reservas activas

        connection.close()

        # Renderizar la plantilla y pasar las reservas activas
        return render_template('dashboard_clientes.html', reservas=reservas)

    except Exception as e:
        return f"Ha ocurrido un error en la base de datos: {e}"
    
#reservas


@app.route('/reservar', methods=['GET', 'POST'])
def reservar():
    if 'user_id' not in session:
        return redirect(url_for('login_clientes'))  # Redirige al login si no está logueado

    # Obtener la lista de restaurantes disponibles
    try:
        connection = db.get_connection()
        with connection.cursor() as cursor:
            cursor.execute("SELECT restaurant_id, name FROM restaurant")
            restaurantes = cursor.fetchall()
            connection.close()
    except Exception as e:
        return f"Error al obtener restaurantes: {e}"

    # Si el formulario es enviado (POST)
    if request.method == 'POST':
        restaurant_id = request.form['restaurant_id']
        time_slot_id = request.form['time_slot_id']
        number_of_people = request.form['number_of_people']

        # Verificar disponibilidad (esto puede incluir un procedimiento para comprobar capacidad)
        try:
            connection = db.get_connection()
            with connection.cursor() as cursor:
                # Primero obtenemos la capacidad máxima del restaurante
                cursor.execute("""SELECT capacity FROM restaurant WHERE restaurant_id = %s""", (restaurant_id,))
                capacity = cursor.fetchone()[0]

                if not capacity:
                    connection.close()
                    return "No se encontró la capacidad del restaurante."

                capacity = capacity[0]
                print(f"Capacidad máxima del restaurante: {capacity}")

                # Verificar las reservas ya existentes y la capacidad total para la franja horaria seleccionada
                cursor.execute("""SELECT SUM(number_of_people) FROM reserve WHERE restaurant_id = %s AND time_slot_id = %s""", (restaurant_id, time_slot_id))
                total_reserved = cursor.fetchone()[0] or 0  # Si no hay reservas, asumimos que es 0

                print(f"Total de personas reservadas en la franja horaria: {total_reserved}")
                print(f"Total personas + nuevas reservas: {total_reserved + int(number_of_people)}")

                if total_reserved + int(number_of_people) <= capacity:
                    # Proceder con la reserva
                    print(f"Inserting reservation: restaurant_id={restaurant_id}, customer_id={session['user_id']}, time_slot_id={time_slot_id}, number_of_people={number_of_people}")

                    cursor.execute("""INSERT INTO reserve (restaurant_id, customer_id, time_slot_id, number_of_people, reserve_time, estatus) 
                                      VALUES (%s, %s, %s, %s, NOW(), 'activa')""", 
                                      (restaurant_id, session['user_id'], time_slot_id, number_of_people))
                    connection.commit()
                    connection.close()
                    return redirect(url_for('dashboard_clientes'))  # Redirige al dashboard del cliente
                else:
                    connection.close()
                    return "No hay suficiente espacio para la cantidad de personas en esta franja horaria."

        except Exception as e:
            connection.close()
            return f"Error al realizar la reserva: {e}"

    # Si el método es GET, muestra los restaurantes y franjas horarias
    return render_template('reservar.html', restaurantes=restaurantes)




    # Ruta para logout
@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('home'))

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=80)





