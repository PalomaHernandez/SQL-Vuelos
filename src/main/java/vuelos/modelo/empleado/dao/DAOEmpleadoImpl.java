package vuelos.modelo.empleado.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import vuelos.modelo.empleado.beans.EmpleadoBean;
import vuelos.modelo.empleado.beans.EmpleadoBeanImpl;

public class DAOEmpleadoImpl implements DAOEmpleado {

	private static Logger logger = LoggerFactory.getLogger(DAOEmpleadoImpl.class);
	
	//conexión para acceder a la Base de Datos
	private Connection conexion;
	
	public DAOEmpleadoImpl(Connection c) {
		this.conexion = c;
	}


	@Override
	public EmpleadoBean recuperarEmpleado(int legajo) throws Exception {
		logger.info("recupera el empleado que corresponde al legajo {}.", legajo);
		
		EmpleadoBean empleado = null;
		
		  try{
			
				java.sql.Statement stmt = conexion.createStatement();
				String sql = "SELECT * FROM empleados WHERE legajo=" + legajo + ";";
				java.sql.ResultSet rs = stmt.executeQuery(sql);
				
				
			while(rs.next()){
			  empleado = new EmpleadoBeanImpl();
				empleado.setLegajo(rs.getInt("legajo"));
				empleado.setPassword(rs.getString("password")); // md5(9);
				empleado.setTipoDocumento(rs.getString("doc_tipo"));
				empleado.setNroDocumento(rs.getInt("doc_nro"));
				empleado.setApellido(rs.getString("apellido"));
				empleado.setNombre(rs.getString("nombre"));
				empleado.setDireccion(rs.getString("direccion"));
				empleado.setTelefono(rs.getString("telefono"));
				}
		
		  	rs.close();
			stmt.close();
		  }
		    catch (java.sql.SQLException ex ) {
		    	logger.info("No es posible acceder a los empleados.");
		    }
		 

		return empleado;
		  
	}	
}
