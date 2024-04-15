package vuelos.modelo.empleado.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import vuelos.modelo.empleado.beans.AeropuertoBean;
import vuelos.modelo.empleado.beans.DetalleVueloBean;
import vuelos.modelo.empleado.beans.EmpleadoBean;
import vuelos.modelo.empleado.beans.InstanciaVueloBean;
import vuelos.modelo.empleado.beans.InstanciaVueloBeanImpl;
import vuelos.modelo.empleado.beans.InstanciaVueloClaseBean;
import vuelos.modelo.empleado.beans.InstanciaVueloClaseBeanImpl;
import vuelos.modelo.empleado.beans.PasajeroBean;
import vuelos.modelo.empleado.beans.ReservaBean;
import vuelos.modelo.empleado.beans.ReservaBeanImpl;
import vuelos.utils.Fechas;

public class DAOReservaImpl implements DAOReserva {

	private static Logger logger = LoggerFactory.getLogger(DAOReservaImpl.class);
	
	//conexión para acceder a la Base de Datos
	private Connection conexion;
	
	public DAOReservaImpl(Connection conexion) {
		this.conexion = conexion;
	}
		
	
	@Override
	public int reservarSoloIda(PasajeroBean pasajero, 
							   InstanciaVueloBean vuelo, 
							   DetalleVueloBean detalleVuelo,
							   EmpleadoBean empleado) throws Exception {
		logger.info("Realiza la reserva de solo ida con pasajero {}", pasajero.getNroDocumento());
	
		int retorno = 0;
	    java.sql.Date date = Fechas.convertirDateADateSQL(vuelo.getFechaVuelo());
	   
	    try{
	    	CallableStatement cstmt = this.conexion.prepareCall("{CALL reservaSoloIda(?,?,?,?,?,?,?,?)}");
	      	cstmt.setString(1, vuelo.getNroVuelo());
	        cstmt.setDate(2, date);
	        cstmt.setString(3,detalleVuelo.getClase());
	        cstmt.setString(4, pasajero.getTipoDocumento());
	        cstmt.setInt(5, pasajero.getNroDocumento());
	        cstmt.setInt(6, empleado.getLegajo());
	        cstmt.registerOutParameter(7, java.sql.Types.CHAR);
		   	cstmt.registerOutParameter(8, java.sql.Types.INTEGER);
	         
			cstmt.execute();
			ResultSet rs = cstmt.getResultSet();
	      
			if(rs.next()) {
				String resultado = cstmt.getString(7);
		        if(resultado.equals("Exito")) {
		       		 retorno = cstmt.getInt(8);
		        }	 
		        else
		        	throw new Exception(resultado); 
			}
			  }
			  catch (SQLException ex){
			  		logger.debug("Error al consultar la BD. SQLException: {}. SQLState: {}. VendorError: {}.", ex.getMessage(), ex.getSQLState(), ex.getErrorCode());
			   		throw ex;
			  } 
	    return retorno;
	}
  
  
	
	@Override
	public int reservarIdaVuelta(PasajeroBean pasajero, 
				 				 InstanciaVueloBean vueloIda,
				 				 DetalleVueloBean detalleVueloIda,
				 				 InstanciaVueloBean vueloVuelta,
				 				 DetalleVueloBean detalleVueloVuelta,
				 				 EmpleadoBean empleado) throws Exception {
		
		logger.info("Realiza la reserva de ida y vuelta con pasajero {}", pasajero.getNroDocumento());
		
		int retorno = 0;
	    java.sql.Date dateIda = Fechas.convertirDateADateSQL(vueloIda.getFechaVuelo());
	    java.sql.Date dateVuelta = Fechas.convertirDateADateSQL(vueloVuelta.getFechaVuelo());

	    try{
	    	CallableStatement cstmt = this.conexion.prepareCall("{CALL reservaIdaVuelta(?,?,?,?,?,?,?,?,?,?,?)}");
	      	cstmt.setString(1, vueloIda.getNroVuelo());
	        cstmt.setDate(2, dateIda);
	        cstmt.setString(3,detalleVueloIda.getClase());
	        cstmt.setString(4, vueloVuelta.getNroVuelo());
	        cstmt.setDate(5, dateVuelta);
	        cstmt.setString(6,detalleVueloVuelta.getClase());
	        cstmt.setString(7, pasajero.getTipoDocumento());
	        cstmt.setInt(8, pasajero.getNroDocumento());
	        cstmt.setInt(9, empleado.getLegajo());
	        cstmt.registerOutParameter(10, java.sql.Types.CHAR);
		   	cstmt.registerOutParameter(11, java.sql.Types.INTEGER);
	         
			cstmt.execute();
			ResultSet rs = cstmt.getResultSet();
	      
			if(rs.next()) {
				String resultado = cstmt.getString(10);
		        if(resultado.equals("Exito")) {
		       		 retorno = cstmt.getInt(11);
		        }	 
		        else
		        	throw new Exception(resultado); 
			}
			  }
			  catch (SQLException ex){
			  		logger.debug("Error al consultar la BD. SQLException: {}. SQLState: {}. VendorError: {}.", ex.getMessage(), ex.getSQLState(), ex.getErrorCode());
			   		throw ex;
			  } 
	    return retorno;
	}
	
	@Override
	public ReservaBean recuperarReserva(int codigoReserva) throws Exception {
		
		logger.info("Solicita recuperar información de la reserva con codigo {}", codigoReserva);
    
		String sql = "SELECT * FROM reservas WHERE numero = '"+ codigoReserva +"'";
	    java.sql.Statement stmt = conexion.createStatement();
		ReservaBean reserva = null;
		DAOPasajero p = new DAOPasajeroImpl(this.conexion);
		DAOEmpleado e = new DAOEmpleadoImpl(this.conexion);
		ArrayList<InstanciaVueloClaseBean> vuelosClase = null;
	    try{
	    	reserva = new ReservaBeanImpl();
	    	ResultSet rs = stmt.executeQuery(sql);
	      
	    	if(rs.next()){
	      	reserva.setNumero(rs.getInt("numero"));
	        reserva.setFecha(rs.getDate("fecha"));
	        reserva.setVencimiento(rs.getDate("vencimiento"));
	        reserva.setEstado(rs.getString("estado"));
	  		PasajeroBean pasajero = p.recuperarPasajero(rs.getString("doc_tipo"),rs.getInt("doc_nro"));
	        EmpleadoBean empleado = e.recuperarEmpleado(rs.getInt("legajo"));
	        vuelosClase = obtenerInstanciaVuelo(reserva.getNumero());
	        reserva.setPasajero(pasajero);
	        reserva.setEmpleado(empleado);
	      	reserva.setVuelosClase(vuelosClase);
	    	}
	    	else
	    		 throw new Exception("No es posible recuperar la reserva.");
		    if(vuelosClase.size() == 2){
		    	reserva.setEsIdaVuelta(true); 
		      }
		      else{
		      	reserva.setEsIdaVuelta(false);
		      }
		    	rs.close();
				stmt.close();
	    }	
	    catch(SQLException ex){
	    	logger.debug("SQLException: {}",ex.getMessage());
	      logger.debug("SQLState: {}", ex.getSQLState());
	      logger.debug("VendorError: {}", ex.getErrorCode());
	    }
	  
			logger.debug("Se recuperó la reserva: {}, {}", reserva.getNumero(), reserva.getEstado());
			
			return reserva;
	}
	
  private ArrayList<InstanciaVueloClaseBean> obtenerInstanciaVuelo(int nro_reserva) throws Exception{
  	 String sql = "SELECT * FROM reserva_vuelo_clase WHERE numero = '"+ nro_reserva +"'";
     java.sql.Statement stmt = conexion.createStatement();
     ArrayList<InstanciaVueloClaseBean> vuelosClase = new ArrayList<InstanciaVueloClaseBean>();
     DAOVuelos v = new DAOVuelosImpl(this.conexion);
     try{
     ResultSet rs = stmt.executeQuery(sql);
     while(rs.next()){
    	InstanciaVueloClaseBean instancia = new InstanciaVueloClaseBeanImpl();
    	InstanciaVueloBean vuelo;
    	ArrayList<DetalleVueloBean> list_detalle;
		try {
			vuelo = obtenerVuelo(rs.getInt("vuelo"), rs.getDate("fecha_vuelo"));
			instancia.setVuelo(vuelo);
			list_detalle = v.recuperarDetalleVuelo(vuelo);
			DetalleVueloBean detalle = list_detalle.get(0);
			instancia.setClase(detalle);
		} catch (Exception e) {
			e.printStackTrace();
		}
     
        vuelosClase.add(instancia);
     }
     rs.close();
		stmt.close();
     }catch(SQLException ex){
    	logger.debug("SQLException: {}",ex.getMessage());
      logger.debug("SQLState: {}", ex.getSQLState());
      logger.debug("VendorError: {}", ex.getErrorCode());
      throw new Exception("No es posible recuperar la instancia vuelo.");
    }
	return vuelosClase;
    
  }
  
  private InstanciaVueloBean obtenerVuelo(int nro_vuelo, Date fecha_vuelo) throws Exception{
	
  	String sql = "SELECT * FROM vuelos_disponibles WHERE nro_vuelo = '"+ nro_vuelo +"' AND fecha = '"+ fecha_vuelo+"';"; 
    java.sql.Statement stmt = conexion.createStatement();
    DAOVuelos v = new DAOVuelosImpl(this.conexion);
    InstanciaVueloBean b = null;
  	try{
    ResultSet rs = stmt.executeQuery(sql);
    while(rs.next()) {
				b = new InstanciaVueloBeanImpl(); 	
				AeropuertoBean aeroSalida;
				try {
					aeroSalida = v.obtenerAeropuerto(rs.getString("codigo_aero_sale"));
					AeropuertoBean aeroLlegada = v.obtenerAeropuerto(rs.getString("codigo_aero_llega"));
					b.setAeropuertoSalida(aeroSalida);
					b.setAeropuertoLlegada(aeroLlegada);
				} catch (Exception e) {
					e.printStackTrace();
				}
				b.setDiaSalida(rs.getString("dia_sale"));
				b.setFechaVuelo(rs.getDate("fecha"));
				b.setHoraLlegada(rs.getTime("hora_llega"));
				b.setHoraSalida(rs.getTime("hora_sale"));
				b.setModelo(rs.getString("modelo"));
				b.setNroVuelo(rs.getString("nro_vuelo"));
				b.setTiempoEstimado(rs.getTime("tiempo_estimado"));
			}
    rs.close();
    stmt.close();
    }catch(SQLException ex){
    	logger.debug("SQLException: {}",ex.getMessage());
      logger.debug("SQLState: {}", ex.getSQLState());
      logger.debug("VendorError: {}", ex.getErrorCode());
      throw new Exception("No es posible recuperar el vuelo.");
    }	
  	
  	return b;
  }
  
}
