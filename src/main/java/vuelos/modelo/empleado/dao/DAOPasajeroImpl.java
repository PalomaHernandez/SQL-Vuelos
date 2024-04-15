package vuelos.modelo.empleado.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import vuelos.modelo.empleado.beans.PasajeroBean;
import vuelos.modelo.empleado.beans.PasajeroBeanImpl;

public class DAOPasajeroImpl implements DAOPasajero {

	private static Logger logger = LoggerFactory.getLogger(DAOPasajeroImpl.class);
	
	private static final long serialVersionUID = 1L;

	//conexión para acceder a la Base de Datos
	private Connection conexion;
	
	public DAOPasajeroImpl(Connection conexion) {
		this.conexion = conexion;
	}


	@Override
	public PasajeroBean recuperarPasajero(String tipoDoc, int nroDoc) throws Exception {
		
		java.sql.Statement stmt = conexion.createStatement();
		String sql = "SELECT * FROM pasajeros WHERE doc_tipo ='"+tipoDoc+"' AND doc_nro = '"+ nroDoc + "';";
			
	    PasajeroBean pasajero=null;
	    
	    try{
	    	pasajero = new PasajeroBeanImpl();
	    	ResultSet rs = stmt.executeQuery(sql);
	    	
	    	if(rs.next()){
	      	pasajero.setApellido(rs.getString("apellido"));
	        pasajero.setNombre(rs.getString("nombre"));
	        pasajero.setTipoDocumento(rs.getString("doc_tipo"));
	        pasajero.setNroDocumento(rs.getInt("doc_nro"));
	        pasajero.setDireccion(rs.getString("direccion"));
	        pasajero.setTelefono(rs.getString("telefono"));
	        pasajero.setNacionalidad(rs.getString("nacionalidad"));
	    	}
	    	else
	    		throw new Exception("No existe pasajero.");
	    	
	    	rs.close();
			stmt.close();
	    }	
	    catch(SQLException ex){
	    	logger.debug("SQLException: {}",ex.getMessage());
	    	logger.debug("SQLState: {}", ex.getSQLState());
	    	logger.debug("VendorError: {}", ex.getErrorCode());
	    	throw new Exception("No es posible recuperar el pasajero.");
	    }
	    
	  
		logger.info("El DAO retorna al pasajero {} {}", pasajero.getApellido(), pasajero.getNombre());
			
		return pasajero;
	}
	
}
