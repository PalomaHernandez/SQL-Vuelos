#-------------------------------------------------------------------------
# Carga de datos de Prueba

# Ubicaciones ------------------------------------------------------------------------------------
INSERT INTO ubicaciones VALUES ("Argentina", "Buenos Aires", "Buenos Aires", -3);
INSERT INTO ubicaciones VALUES ("Colombia","Cundinamarca","Bogota", -5);
INSERT INTO ubicaciones VALUES ("Chile","Metrop Santiago","Santiago Chile", -4);
INSERT INTO ubicaciones VALUES ("Peru","Provincia de Callao","Callao", -5);


# Aeropuertos ------------------------------------------------------------------------------------
INSERT INTO aeropuertos VALUES ("AEP", "Aeroparque Jorge Newberparque", "11 5480 6111", "Av. Costanera Rafael O", "Argentina","Buenos Aires","Buenos Aires");
INSERT INTO aeropuertos VALUES ("EZE", "Aeropuerto Ezeiza", "114852-6900", "Autopista Teniente G", "Argentina","Buenos Aires","Buenos Aires");
INSERT INTO aeropuertos VALUES ("BOG", "Aeropuerto Internacional El Dorado", "601 2662000", "Av. El Dorado #103-9", "Colombia","Cundinamarca","Bogota");
INSERT INTO aeropuertos VALUES ("SCL", "Aeropuerto Merino Benitez", "2 2690 1796", "Armando Cortine", "Chile","Metrop Santiago","Santiago Chile");
INSERT INTO aeropuertos VALUES ("LIM", "Aeropuerto Inter Chavez", "2 2690 1796", "Armando Cortinez ", "Peru","Provincia de Callao","Callao");

# Modelos_Avion -----------------------------------------------------------------------------------
INSERT INTO modelos_avion VALUES ("Boeing 737-800", "The Boeing Company ",1,174);
INSERT INTO modelos_avion VALUES ("Airbus A330", "Airbus",1,260);
INSERT INTO modelos_avion VALUES ("Airbus A220", "Airbus",1,160);

# Vuelos_Programados ------------------------------------------------------------------------------
INSERT INTO vuelos_programados VALUES ("1","AEP","BOG");
INSERT INTO vuelos_programados VALUES ("2","AEP","LIM");
INSERT INTO vuelos_programados VALUES ("3","BOG","AEP");
INSERT INTO vuelos_programados VALUES ("4","EZE","SCL");
INSERT INTO vuelos_programados VALUES ("5","SCL","BOG");
# ver como incrementar automaticamente el numero de vuelo

# Salidas -----------------------------------------------------------------------------------------
INSERT INTO salidas VALUES ("1", "lu", "12:00:00", "15:00:00", "Boeing 737-800");
INSERT INTO salidas VALUES ("2", "ma", "12:00:00", "14:30:00", "Airbus A330");
INSERT INTO salidas VALUES ("3", "mi", "18:00:00", "21:00:00", "Airbus A220");
INSERT INTO salidas VALUES ("4", "ju", "8:00:00", "10:00:00", "Boeing 737-800");
INSERT INTO salidas VALUES ("5", "vi", "22:00:00", "23:30:00", "Boeing 737-800");

# Instancias_vuelo —------------------------------------------------------------------------------
INSERT INTO instancias_vuelo VALUES("1","2022-9-10","lu","a tiempo");
INSERT INTO instancias_vuelo VALUES("2","2022-9-11","ma","a tiempo");
INSERT INTO instancias_vuelo VALUES("3","2022-9-12","mi","a tiempo");
INSERT INTO instancias_vuelo VALUES("4","2022-9-13","ju","a tiempo");
INSERT INTO instancias_vuelo VALUES("5","2022-9-14","vi","a tiempo");

# Clases —------------------------------------------------------------------------------
INSERT INTO clases VALUES("Turista", 0.33);
INSERT INTO clases VALUES("Ejecutiva", 0.50);

# Comodidades ----------------------------------------------------------------
INSERT INTO comodidades VALUES(1, "desayuno");
INSERT INTO comodidades VALUES(2, "television");
INSERT INTO comodidades VALUES(3, "internet");
INSERT INTO comodidades VALUES(4, "bebidas");

# Pasajeros ------------------------------------------------------------------
INSERT INTO pasajeros VALUES("DNI", 43681455, "Arce", "Ezequiel", "Avellaneda 52", "2920667788", "Argentina");
INSERT INTO pasajeros VALUES("DNI", 44115840, "Hernandez", "Paloma", "Alem 222", "2931502703", "Argentina");
INSERT INTO pasajeros VALUES("DNI", 23912008, "Fernandez", "Enzo", "San Martin 13", "2931091218", "Argentina");
INSERT INTO pasajeros VALUES("DNI", 40861573, "Alvarez", "Julieta", "Calle 21", "2011880766", "Uruguay");
INSERT INTO pasajeros VALUES("DNI", 38761239, "Solari", "Pablo", "Arturo Prat 21", "2820123456", "Chile");

# Empleados ------------------------------------------------------------------
INSERT INTO empleados VALUES(330667, MD5("pwempleado1"),"DNI",26708992, "Suarez", "Matias", "Estomba 32", "2921080907");
INSERT INTO empleados VALUES(410347, MD5("pwempleado2"),"DNI",30812356, "Martinez", "David", "Mendoza 88", "2035050988");
INSERT INTO empleados VALUES(225056, MD5("pwempleado3"),"DNI",29876541, "Diaz", "Agustina", "Belgrano 11", "1520864533");
INSERT INTO empleados VALUES(232021, MD5("pwempleado4"),"DNI",20675442, "Palacios", "Exequiel", "Yrigoyen 196", "7654689755");
INSERT INTO empleados VALUES(306548, MD5("pwempleado5"),"DNI",22320088, "Lertora", "Martina", "Mitre 213", "2785546867");

# Reservas —------------------------------------------------------------------------------
INSERT INTO reservas VALUES(1,"2022-9-1","2022-9-6","Pagada","DNI",43681455, 330667);
INSERT INTO reservas VALUES(2,"2022-9-2","2022-9-7","Pagada", "DNI",44115840, 410347);
INSERT INTO reservas VALUES(3,"2022-9-3","2022-9-8","En espera","DNI",23912008, 225056);
INSERT INTO reservas VALUES(4,"2022-9-4","2022-9-9","Confirmada","DNI",40861573, 232021);
INSERT INTO reservas VALUES(5,"2022-9-5","2022-9-10","Confirmada","DNI",38761239, 306548);

# Brinda —------------------------------------------------------------------------------
INSERT INTO brinda VALUES("1","lu","Turista", 10000.50, 174);
INSERT INTO brinda VALUES("2","ma","Turista",  12000.00, 260);
INSERT INTO brinda VALUES("3","mi","Ejecutiva", 18500.50, 160);
INSERT INTO brinda VALUES("4","ju","Ejecutiva", 20000.00, 174);
INSERT INTO brinda VALUES("5","vi","Turista", 14500.00, 174);

# Posee —------------------------------------------------------------------------------
INSERT INTO posee VALUES("Turista",1);
INSERT INTO posee VALUES("Turista",2);
INSERT INTO posee VALUES("Ejecutiva",3);
INSERT INTO posee VALUES("Ejecutiva",4);
INSERT INTO posee VALUES("Turista",4);

# Reserva_vuelo_clase —------------------------------------------------------------------------------
INSERT INTO reserva_vuelo_clase VALUES(1,"1","2022-9-10","Turista");
INSERT INTO reserva_vuelo_clase VALUES(2,"2","2022-9-11","Turista");
INSERT INTO reserva_vuelo_clase VALUES(3,"3","2022-9-12","Ejecutiva");
INSERT INTO reserva_vuelo_clase VALUES(4,"4","2022-9-13","Ejecutiva");
INSERT INTO reserva_vuelo_clase VALUES(5,"5","2022-9-14","Turista");


# Asientos_Reservados ----------------------------------------------
INSERT INTO asientos_reservados VALUES("1","2022-9-10","Turista",50);
INSERT INTO asientos_reservados VALUES("2","2022-9-11","Turista",60);
INSERT INTO asientos_reservados VALUES("3","2022-9-12","Ejecutiva",35);
INSERT INTO asientos_reservados VALUES("4","2022-9-13","Ejecutiva",30);
INSERT INTO asientos_reservados VALUES("5","2022-9-14","Turista",65);