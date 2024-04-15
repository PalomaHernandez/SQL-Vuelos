#Archivo batch (vuelos.sql) para la creación de la 
#Base de datos del Proyecto N°2 

#Creación de la base de datos
CREATE DATABASE vuelos;

# Selección dela base de datos sobre la cual se harán modificaciones
USE vuelos;

#-------------------------------------------------------------------------
# Creación Tablas para las entidades

CREATE TABLE ubicaciones(
	pais VARCHAR(20) NOT NULL,
	estado VARCHAR(20) NOT NULL,
	ciudad VARCHAR(20) NOT NULL,
	huso SMALLINT NOT NULL CHECK(huso > (-13) AND huso < 13),
	
	CONSTRAINT pk_ubicaciones
	PRIMARY KEY (pais,estado,ciudad)
)ENGINE=InnoDB;

CREATE TABLE modelos_avion(
	modelo VARCHAR(20) NOT NULL,
	fabricante VARCHAR(20) NOT NULL,
	cabinas SMALLINT UNSIGNED NOT NULL,
	cant_asientos SMALLINT UNSIGNED NOT NULL,
	
	CONSTRAINT pk_modelos_avion
	PRIMARY KEY (modelo)
)ENGINE=InnoDB;

CREATE TABLE clases(
	nombre VARCHAR(20) NOT NULL,
	porcentaje DECIMAL(2,2) UNSIGNED NOT NULL CHECK(porcentaje > 0 AND porcentaje < 0.99),
	
	CONSTRAINT pk_clases
	PRIMARY KEY (nombre)
)ENGINE=InnoDB;

CREATE TABLE comodidades(
	codigo SMALLINT UNSIGNED NOT NULL,
	descripcion TEXT(45) NOT NULL,
	
	CONSTRAINT pk_comodidades
	PRIMARY KEY (codigo)
)ENGINE=InnoDB;

CREATE TABLE pasajeros(
	doc_tipo VARCHAR(45) NOT NULL,
	doc_nro INT UNSIGNED NOT NULL, 
	apellido VARCHAR(20) NOT NULL, 
	nombre VARCHAR(20) NOT NULL, 
	direccion VARCHAR(40) NOT NULL, 
	telefono VARCHAR (15) NOT NULL, 
	nacionalidad VARCHAR(20) NOT NULL,

	CONSTRAINT pk_pasajeros
	PRIMARY KEY (doc_tipo, doc_nro)
)ENGINE=InnoDB;

CREATE TABLE empleados(
	legajo INT UNSIGNED NOT NULL,
	password CHAR(32) NOT NULL,
	doc_tipo VARCHAR (45) NOT NULL,
	doc_nro INT UNSIGNED NOT NULL, 
	apellido VARCHAR(20) NOT NULL, 
	nombre VARCHAR(20) NOT NULL, 
	direccion VARCHAR(40) NOT NULL, 
	telefono VARCHAR (15) NOT NULL, 

	CONSTRAINT pk_empleados
	PRIMARY KEY (legajo)
)ENGINE=InnoDB;

CREATE TABLE aeropuertos(
    codigo VARCHAR(45) NOT NULL,
    nombre VARCHAR(40) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    direccion VARCHAR(30) NOT NULL,
    pais VARCHAR(20) NOT NULL,
    estado VARCHAR(20) NOT NULL,
    ciudad VARCHAR(20) NOT NULL,

    CONSTRAINT pk_aeropuertos
    PRIMARY KEY (codigo),

    CONSTRAINT FK_aeropuertos_ubicacion
    FOREIGN KEY (pais,estado,ciudad) REFERENCES ubicaciones(pais,estado,ciudad)
        ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB;

CREATE TABLE vuelos_programados(
    numero VARCHAR(10) NOT NULL,
    aeropuerto_salida VARCHAR(45) NOT NULL,
    aeropuerto_llegada VARCHAR(45) NOT NULL,

    CONSTRAINT pk_vuelos_programados 
    PRIMARY KEY (numero),

    CONSTRAINT FK_vuelos_programados_aeropuerto_salida
    FOREIGN KEY (aeropuerto_salida) REFERENCES aeropuertos(codigo)
        ON DELETE RESTRICT ON UPDATE CASCADE,
		
	CONSTRAINT FK_vuelos_programados_aeropuerto_llegada
    FOREIGN KEY (aeropuerto_llegada) REFERENCES aeropuertos(codigo)
        ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB;

CREATE TABLE salidas(
	vuelo VARCHAR(10) NOT NULL,
	dia ENUM('do','lu','ma','mi','ju','vi','sa') NOT NULL,
	hora_sale TIME NOT NULL,
	hora_llega TIME NOT NULL,
	modelo_avion VARCHAR(20) NOT NULL,
	
	CONSTRAINT pk_salidas
	PRIMARY KEY (vuelo,dia),
	
	CONSTRAINT FK_salidas_vuelo
	FOREIGN KEY (vuelo) REFERENCES vuelos_programados(numero)
		ON DELETE RESTRICT ON UPDATE CASCADE,
		
	CONSTRAINT FK_salidas_modelo_avion
	FOREIGN KEY (modelo_avion) REFERENCES modelos_avion(modelo)
		ON DELETE RESTRICT ON UPDATE CASCADE
	
)ENGINE=InnoDB;

CREATE TABLE instancias_vuelo(
	vuelo VARCHAR(10) NOT NULL,
	fecha DATE NOT NULL,
	dia ENUM('do','lu','ma','mi','ju','vi','sa') NOT NULL,
	estado VARCHAR(15),
	
	CONSTRAINT pk_instancias_vuelo
	PRIMARY KEY (vuelo,fecha),
	
	CONSTRAINT FK_instancias_vuelo_salidas
	FOREIGN KEY (vuelo, dia) REFERENCES salidas(vuelo, dia)
		ON DELETE RESTRICT ON UPDATE CASCADE
	
)ENGINE=InnoDB;

CREATE TABLE reservas(
	numero INT UNSIGNED NOT NULL AUTO_INCREMENT,
	fecha DATE NOT NULL,
	vencimiento DATE NOT NULL,
	estado VARCHAR (15) NOT NULL,
	doc_tipo VARCHAR (45) NOT NULL,
	doc_nro INT UNSIGNED NOT NULL, 
	legajo INT UNSIGNED NOT NULL, 

	CONSTRAINT pk_reservas
	PRIMARY KEY (numero),

	CONSTRAINT FK_reservas_pasajero
	FOREIGN KEY (doc_tipo, doc_nro) REFERENCES pasajeros(doc_tipo, doc_nro)
		ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT FK_reservas_legajo
	FOREIGN KEY (legajo) REFERENCES empleados(legajo)
		ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB;

#-------------------------------------------------------------------------
# Creación Tablas para las relaciones

CREATE TABLE brinda(
	vuelo VARCHAR(10) NOT NULL,
	dia ENUM('do','lu','ma','mi','ju','vi','sa') NOT NULL,
	clase VARCHAR(20) NOT NULL,
	precio DECIMAL(7,2) UNSIGNED NOT NULL,
	cant_asientos INT UNSIGNED NOT NULL,

	CONSTRAINT pk_brinda
	PRIMARY KEY (vuelo,dia,clase),

	CONSTRAINT FK_brinda_salida
	FOREIGN KEY (vuelo,dia) REFERENCES salidas(vuelo, dia)
		ON DELETE RESTRICT ON UPDATE CASCADE,

	CONSTRAINT FK_brinda_clase
	FOREIGN KEY (clase) REFERENCES clases(nombre)
		ON DELETE RESTRICT ON UPDATE CASCADE		
)ENGINE=InnoDB;

CREATE TABLE posee(
	clase VARCHAR(20) NOT NULL,
	comodidad SMALLINT UNSIGNED NOT NULL,

	CONSTRAINT pk_posee
	PRIMARY KEY (clase, comodidad),

	CONSTRAINT FK_posee_clase
	FOREIGN KEY (clase) REFERENCES clases(nombre)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	
	CONSTRAINT FK_posee_comodidad
	FOREIGN KEY (comodidad) REFERENCES comodidades(codigo)
		ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB;

CREATE TABLE reserva_vuelo_clase(
	numero INT UNSIGNED NOT NULL,
	vuelo VARCHAR(10) NOT NULL,
	fecha_vuelo DATE NOT NULL,
	clase VARCHAR(20) NOT NULL,

	CONSTRAINT pk_reserva_vuelo_clase
	PRIMARY KEY (numero,vuelo,fecha_vuelo),

	CONSTRAINT FK_reserva_vuelo_clase_nro_reserva
	FOREIGN KEY (numero) REFERENCES reservas(numero)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	
	CONSTRAINT FK_reserva_vuelo_clase_nro_vuelo
	FOREIGN KEY (vuelo, fecha_vuelo) REFERENCES instancias_vuelo(vuelo, fecha)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	
	CONSTRAINT FK_reserva_vuelo_clase_nro_reserva_nombre_clase
	FOREIGN KEY (clase) REFERENCES clases (nombre)
		ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB;


CREATE TABLE asientos_reservados(
	vuelo VARCHAR(10) NOT NULL,
	fecha DATE NOT NULL,
	clase VARCHAR(20) NOT NULL,
	cantidad INT UNSIGNED NOT NULL,

	CONSTRAINT pk_asientos_reservados
	PRIMARY KEY (vuelo,fecha,clase),

	CONSTRAINT FK_asientos_reservados_vuelo
	FOREIGN KEY (vuelo, fecha) REFERENCES instancias_vuelo(vuelo, fecha)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	
	CONSTRAINT FK_asientos_reservados_clase
	FOREIGN KEY (clase) REFERENCES clases(nombre)
		ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB;

#----------------------------------------------------------------------
# Creacion de vista 
CREATE VIEW vuelos_disponibles AS
	SELECT A.numero as nro_vuelo, M.modelo as modelo, I.fecha as fecha, B.dia as dia_sale, B.hora_sale as hora_sale, B.hora_llega as hora_llega,
	IF(B.hora_llega > B.hora_sale, TIMEDIFF(B.hora_llega, B.hora_sale), TIMEDIFF('24:00:00', TIMEDIFF(B.hora_sale, B.hora_llega))) as tiempo_estimado,
	AeroSalida.codigo as codigo_aero_sale, AeroSalida.nombre as nombre_aero_sale, AeroSalida.ciudad as ciudad_sale, 
	AeroSalida.estado as estado_sale, AeroSalida.pais as pais_sale, AeroLlegada.codigo as codigo_aero_llega, 
	AeroLlegada.nombre as nombre_aero_llega, AeroLlegada.ciudad as ciudad_llega,
	AeroLlegada.estado as estado_llega, AeroLlegada.pais as pais_llega, J.precio as precio, 
	(J.cant_asientos + ROUND(C.porcentaje*J.cant_asientos)- D.cantidad) as asientos_disponibles, D.clase as clase
	FROM ((((((((instancias_vuelo I NATURAL JOIN salidas B)
	INNER JOIN modelos_avion M ON B.modelo_avion = M.modelo)
	INNER JOIN vuelos_programados A ON A.numero = B.vuelo) 
	INNER JOIN brinda J ON B.vuelo=J.vuelo AND B.dia = J.dia)
	LEFT JOIN asientos_reservados D ON I.vuelo = D.vuelo AND D.fecha = I.fecha AND D.clase = J.clase) 
	INNER JOIN clases C ON J.clase = C.nombre) 
	INNER JOIN aeropuertos AeroSalida ON A.aeropuerto_salida = AeroSalida.codigo) 
	INNER JOIN aeropuertos AeroLlegada ON A.aeropuerto_llegada = AeroLlegada.codigo);

#-------------------------------------------------------------------------
#-- RESERVASOLOIDA


delimiter !
  create procedure reservaSoloIda(IN numero_vuelo INT, IN vuelo_fecha DATE, IN clase CHAR(20), IN tipo_documento CHAR(45), IN nro_documento INT, IN legajo_empleado INT, OUT resultado CHAR(45), OUT numero_reserva INT)
  	begin
		DECLARE fecha_reserva DATE;
        DECLARE vencimiento DATE;
        DECLARE nro_reserva INT;
        DECLARE estado VARCHAR(15);
        DECLARE cant_reservas INT;
        DECLARE asientos INT;
		
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
            SELECT "SQLEXCEPTION, reserva abortada" AS resultado;
            ROLLBACK;
     	 END;  

  		start transaction;
      	IF EXISTS (SELECT * FROM vuelos_disponibles V WHERE nro_vuelo = numero_vuelo AND fecha = vuelo_fecha AND V.clase = clase) THEN
			IF EXISTS(SELECT * FROM pasajeros WHERE doc_tipo = tipo_documento AND doc_nro = nro_documento) THEN
				IF EXISTS (SELECT * FROM empleados WHERE legajo = legajo_empleado) THEN
					IF EXISTS (SELECT * FROM vuelos_disponibles I WHERE nro_vuelo = numero_vuelo AND fecha = vuelo_fecha AND I.clase = clase AND asientos_disponibles >= 1) THEN
						SELECT * FROM asientos_reservados FOR UPDATE;			
						SET fecha_reserva = CURDATE(); 
						SET vencimiento = DATE_SUB(vuelo_fecha, INTERVAL 15 DAY);
						SELECT cantidad into cant_reservas FROM asientos_reservados WHERE vuelo = numero_vuelo AND fecha = vuelo_fecha;
						SELECT cant_asientos into asientos FROM brinda B WHERE vuelo = numero_vuelo AND B.clase = clase;

						IF(cant_reservas < asientos) THEN
						  SET estado = "confirmada";
						ELSE
						  SET estado = "en espera";
						END IF;

						INSERT INTO reservas (fecha,vencimiento,estado,doc_tipo,doc_nro,legajo) VALUES(fecha_reserva, vencimiento, estado, tipo_documento, nro_documento, legajo_empleado);
						SELECT last_insert_id() INTO nro_reserva;

						INSERT INTO reserva_vuelo_clase VALUES(nro_reserva, numero_vuelo, vuelo_fecha, clase); 

						UPDATE asientos_reservados SET cantidad = cantidad + 1 WHERE vuelo = numero_vuelo AND fecha = vuelo_fecha;
							
						SELECT "Exito" INTO resultado;
						SELECT	nro_reserva INTO numero_reserva;
        
					ELSE
						SELECT "No hay asientos disponibles para el vuelo." INTO resultado; 
					END IF;
				ELSE
					SELECT "Los datos del empleado son incorrectos." INTO resultado;
				END IF;
			ELSE 
				SELECT "Los datos del pasajero son incorrectos." INTO resultado;
			END IF;
		ELSE 
			SELECT "El vuelo no esta disponible." INTO resultado;
		END IF;
				
      commit;
  	end; !
  delimiter ;
  
#--------------------------------------------------------------------------
#-- RESERVAIDAYVUELTA

delimiter !
  create procedure reservaIdaVuelta(IN nro_vuelo_ida INT, IN fecha_vuelo_ida DATE, IN clase_ida CHAR(20), IN nro_vuelo_vuelta INT, In fecha_vuelo_vuelta DATE, IN clase_vuelta CHAR(20), IN tipo_documento CHAR(45), IN nro_documento INT, IN legajo_empleado INT, OUT resultado CHAR(20), OUT numero_reserva INT)
  	begin
     DECLARE fecha_reserva DATE;
     DECLARE vencimiento DATE;
     DECLARE nro_reserva INT;
     DECLARE estado VARCHAR(15);
     DECLARE cant_reservas_ida INT;
     DECLARE asientos_ida INT;
     DECLARE cant_reservas_vuelta INT;
     DECLARE asientos_vuelta INT;
	 
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
            SELECT "SQLEXCEPTION, reserva abortada" AS resultado;
            ROLLBACK;
     	 END;  
          
    start transaction;
    IF EXISTS (SELECT * FROM pasajeros WHERE doc_tipo = tipo_documento AND doc_nro = nro_documento) THEN 
		IF EXISTS (SELECT * FROM empleados WHERE legajo = legajo_empleado) THEN
			IF EXISTS (SELECT * FROM vuelos_disponibles WHERE nro_vuelo = nro_vuelo_ida AND fecha = fecha_vuelo_ida AND clase = clase_ida) THEN
				IF EXISTS (SELECT * FROM vuelos_disponibles WHERE nro_vuelo = nro_vuelo_vuelta AND fecha = fecha_vuelo_vuelta AND clase = clase_vuelta) THEN
					IF EXISTS (SELECT * FROM vuelos_disponibles WHERE asientos_disponibles >= 1 AND nro_vuelo = nro_vuelo_ida AND fecha = fecha_vuelo_ida AND clase = clase_ida) THEN
						IF EXISTS (SELECT * FROM vuelos_disponibles WHERE asientos_disponibles >= 1 AND nro_vuelo = nro_vuelo_vuelta AND fecha = fecha_vuelo_vuelta AND clase = clase_vuelta) THEN
							SELECT * FROM asientos_reservados FOR UPDATE;
              
							SET fecha_reserva = CURDATE(); 
							SET vencimiento = DATE_SUB(fecha_vuelo_ida, INTERVAL 15 DAY);
							SELECT cantidad into cant_reservas_ida FROM asientos_reservados WHERE vuelo = nro_vuelo_ida AND fecha = fecha_vuelo_ida;
							SELECT cant_asientos into asientos_ida FROM brinda WHERE vuelo = nro_vuelo_ida AND clase = clase_ida;
							SELECT cantidad into cant_reservas_vuelta FROM asientos_reservados WHERE vuelo = nro_vuelo_vuelta AND fecha = fecha_vuelo_vuelta;
							SELECT cant_asientos into asientos_vuelta FROM brinda WHERE vuelo = nro_vuelo_vuelta AND clase = clase_vuelta;
							
							IF(cant_reservas_ida < asientos_ida OR cant_reservas_vuelta < asientos_vuelta) THEN
								SET estado = "confirmada";
							ELSE
								SET estado = "en espera";
							END IF;

							INSERT INTO reservas VALUES(NULL, fecha_reserva, vencimiento, estado, tipo_documento, nro_documento, legajo_empleado);
							SELECT last_insert_id() INTO nro_reserva;
							INSERT INTO reserva_vuelo_clase VALUES(nro_reserva, nro_vuelo_ida, fecha_vuelo_ida, clase_ida);

							INSERT INTO reserva_vuelo_clase VALUES(nro_reserva, nro_vuelo_vuelta, fecha_vuelo_vuelta, clase_vuelta);

							UPDATE asientos_reservados SET cantidad = cantidad + 1 WHERE (vuelo = nro_vuelo_ida AND fecha = fecha_vuelo_ida) OR (vuelo = nro_vuelo_vuelta AND fecha = fecha_vuelo_vuelta);
							SELECT "Exito" INTO resultado;
							SELECT nro_reserva INTO numero_reserva;
						ELSE
							SELECT "No hay asientos disponibles para el vuelo de vuelta" INTO resultado;
						END IF;
					ELSE
						SELECT "No hay asientos disponibles para el vuelo de ida" INTO resultado;
					END IF;
				ELSE
					SELECT "El vuelo de vuelta no esta disponible" INTO resultado;
				END IF;
			ELSE
				SELECT "El vuelo de ida no esta disponible" INTO resultado;
			END IF;
		ELSE
			SELECT "Los datos del empleado son incorrectos." INTO resultado;
		END IF;
	ELSE 
		SELECT "Los datos del pasajero son incorrectos." INTO resultado;
	END IF;
		
    commit;
  	end; !
  delimiter ;
  
 #--------------------------------------------------------------------------
 #--TRIGGER
 
delimiter !
CREATE TRIGGER inicializar_vuelos
AFTER INSERT ON instancias_vuelo
FOR EACH ROW
	BEGIN
  	CALL inicializar_cant_asientos();
	END; !
delimiter ;

delimiter !
	create procedure inicializar_cant_asientos()
  begin
  	declare fin boolean default false;
  	DECLARE nro_vuelo INT;
    DECLARE fecha_vuelo DATE;
    DECLARE clase_vuelo VARCHAR(20);
    DECLARE C cursor for SELECT vuelo,fecha,clase FROM instancias_vuelo NATURAL JOIN brinda;
    declare continue handler for not found set fin = true;
    
    open C;
    fetch C into nro_vuelo,fecha_vuelo,clase_vuelo;
    while not fin do
    	if not exists(select * from asientos_reservados where vuelo = nro_vuelo and fecha = fecha_vuelo and clase = clase_vuelo) THEN
        insert into asientos_reservados values(nro_vuelo,fecha_vuelo,clase_vuelo,0);
      end if;
        fetch C into nro_vuelo, fecha_vuelo, clase_vuelo; 
    end while;
    close C; 
  end; !
delimiter ;
  
#-------------------------------------------------------------------------
# Creación de usuarios y otorgamiento de privilegios

DROP USER ''@'localhost'; 

CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';
GRANT ALL PRIVILEGES ON vuelos.* TO 'admin'@'localhost' WITH GRANT OPTION;

CREATE USER 'empleado'@'%' IDENTIFIED BY 'empleado';
GRANT SELECT ON vuelos.* TO 'empleado'@'%';
GRANT UPDATE,DELETE,INSERT ON TABLE reservas TO 'empleado'@'%';
GRANT UPDATE,DELETE,INSERT ON TABLE reserva_vuelo_clase TO 'empleado'@'%';
GRANT UPDATE,DELETE,INSERT ON TABLE pasajeros TO 'empleado'@'%';
GRANT EXECUTE ON PROCEDURE reservaSoloIda TO 'empleado'@'%';
GRANT EXECUTE ON PROCEDURE reservaIdaVuelta TO 'empleado'@'%';


CREATE USER 'cliente'@'%' IDENTIFIED BY 'cliente';
GRANT SELECT ON vuelos_disponibles TO 'cliente'@'%';