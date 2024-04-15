package vuelos.modelo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import vuelos.utils.Conexion;


public class ModeloImpl implements Modelo {
	
	private static Logger logger = LoggerFactory.getLogger(ModeloImpl.class);	

	protected Connection conexion = null;
	
	@Override
	public boolean conectar(String username, String password) {
		logger.info("Se establece la conexión a la BD.");
		
		this.conexion = Conexion.getConnection(username,password);
	    return (conexion!=null);  
	}
	

	@Override
	public void desconectar() {
		logger.info("Se cierra la conexión a la BD.");
		Conexion.closeConnection(this.conexion);		
	}

	@Override
	public ResultSet consulta(String sql) 
	{
		logger.info("Se intenta realizar la siguiente consulta {}",sql);
		ResultSet rs= null;		
		
		try
		{   
			java.sql.Statement stmt = conexion.createStatement();
			rs = stmt.executeQuery(sql);
		}
		catch (SQLException ex){
		   logger.error("SQLException: " + ex.getMessage());
		   logger.error("SQLState: " + ex.getSQLState());
		   logger.error("VendorError: " + ex.getErrorCode());				   
		}	
		
		return rs;
	}	
	

	@Override
	public void actualizacion (String sql)
	{
		logger.info("Se intenta realizar la siguiente actualizacion {}",sql);
				
		try
		{       
			java.sql.Statement stmt = conexion.createStatement();
			stmt.execute(sql);
			stmt.close();
		}
		catch (SQLException ex){
		   logger.error("SQLException: " + ex.getMessage());
		   logger.error("SQLState: " + ex.getSQLState());
		   logger.error("VendorError: " + ex.getErrorCode());				   
		}	
			
	}	
}
