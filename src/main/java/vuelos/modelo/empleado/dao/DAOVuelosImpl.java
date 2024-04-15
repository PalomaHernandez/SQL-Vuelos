package vuelos.modelo.empleado.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import vuelos.modelo.empleado.beans.AeropuertoBean;
import vuelos.modelo.empleado.beans.AeropuertoBeanImpl;
import vuelos.modelo.empleado.beans.DetalleVueloBean;
import vuelos.modelo.empleado.beans.DetalleVueloBeanImpl;
import vuelos.modelo.empleado.beans.InstanciaVueloBean;
import vuelos.modelo.empleado.beans.InstanciaVueloBeanImpl;
import vuelos.modelo.empleado.beans.UbicacionesBean;
import vuelos.modelo.empleado.beans.UbicacionesBeanImpl;
import vuelos.utils.Fechas;

public class DAOVuelosImpl implements DAOVuelos {

	private static Logger logger = LoggerFactory.getLogger(DAOVuelosImpl.class);
	
	//conexión para acceder a la Base de Datos
	private Connection conexion;
	
	public DAOVuelosImpl(Connection conexion) {
		this.conexion = conexion;
	}

	@Override
	public ArrayList<InstanciaVueloBean> recuperarVuelosDisponibles(Date fechaVuelo, UbicacionesBean origen, UbicacionesBean destino)  throws Exception {
		
		java.sql.Date date = Fechas.convertirDateADateSQL(fechaVuelo);
		logger.debug("La fecha es: {}", date);
		String sql = "SELECT distinct * FROM vuelos_disponibles WHERE fecha = '"+ date +"' AND pais_sale = '"+ origen.getPais() +"' AND pais_llega = '"+destino.getPais() + "' AND estado_llega = '"+ destino.getEstado() +
				"' AND estado_sale = '"+ origen.getEstado() +"' AND ciudad_sale = '"+ origen.getCiudad()+ "' AND ciudad_llega = '" + destino.getCiudad() + "';";
		java.sql.Statement stmt = conexion.createStatement();
		
		
		ArrayList<InstanciaVueloBean> resultado = new ArrayList<InstanciaVueloBean>();
		try {
			ResultSet rs = stmt.executeQuery(sql);
			while(rs.next()) {
				InstanciaVueloBean b = new InstanciaVueloBeanImpl(); 	
				
				AeropuertoBean aeroSalida = obtenerAeropuerto(rs.getString("codigo_aero_sale"));
				AeropuertoBean aeroLlegada = obtenerAeropuerto(rs.getString("codigo_aero_llega"));
				
				b.setAeropuertoSalida(aeroSalida);
				b.setAeropuertoLlegada(aeroLlegada);
				b.setDiaSalida(rs.getString("dia_sale"));
				b.setFechaVuelo(rs.getDate("fecha"));
				b.setHoraLlegada(rs.getTime("hora_llega"));
				b.setHoraSalida(rs.getTime("hora_sale"));
				b.setModelo(rs.getString("modelo"));
				b.setNroVuelo(rs.getString("nro_vuelo"));
				b.setTiempoEstimado(rs.getTime("tiempo_estimado"));
			
	
				resultado.add(b);
			}
		}
		catch (SQLException ex) {	            	 
        	logger.debug("SQLException: {}",ex.getMessage());
        	logger.debug("SQLState: {}", ex.getSQLState());
        	logger.debug("VendorError: {}", ex.getErrorCode());
        	throw new Exception("No es posible acceder a los vuelos disponibles.");
        }
		stmt.close();
		
		return resultado;
	}

	
	public AeropuertoBean obtenerAeropuerto(String codigoAero) throws Exception {
		String sql = "SELECT * FROM aeropuertos WHERE codigo ='" + codigoAero + "';";
		java.sql.Statement stmt = conexion.createStatement();
		
		AeropuertoBean a = new AeropuertoBeanImpl();
		try {
			ResultSet rs = stmt.executeQuery(sql);
			while(rs.next()) {
				UbicacionesBean u = obtenerUbicacion(rs.getString("pais"), rs.getString("estado"), rs.getString("ciudad"));
				a.setCodigo(rs.getString("codigo"));
				a.setDireccion(rs.getString("direccion"));
				a.setNombre(rs.getString("nombre"));
				a.setTelefono(rs.getString("telefono"));
				a.setUbicacion(u);
			}
		}
		catch(SQLException ex){
        	logger.debug("SQLException: {}",ex.getMessage());
        	logger.debug("SQLState: {}", ex.getSQLState());
        	logger.debug("VendorError: {}", ex.getErrorCode());
        	throw new Exception("No es posible acceder a aeropuertos.");
		}	
		stmt.close();
		return a;
	}
	
	private UbicacionesBean obtenerUbicacion(String pais, String estado, String ciudad) throws Exception{
		String sql = "SELECT * FROM ubicaciones WHERE pais ='" + pais + "' AND estado ='"+ estado+ "' AND ciudad = '"+ ciudad + "';";
		java.sql.Statement stmt = conexion.createStatement();
		
		UbicacionesBean u = new UbicacionesBeanImpl();
		try {
			ResultSet rs = stmt.executeQuery(sql);
			while(rs.next()) {
				u.setCiudad(ciudad);
				u.setEstado(estado);
				u.setPais(pais);
				u.setHuso(rs.getInt("huso"));
			}
		}
		catch(SQLException ex) {
        	logger.debug("SQLException: {}",ex.getMessage());
        	logger.debug("SQLState: {}", ex.getSQLState());
        	logger.debug("VendorError: {}", ex.getErrorCode());
        	throw new Exception("No es posible acceder a ubicaciones.");
		}
		stmt.close();
		return u;
	}
	
	@Override
	public ArrayList<DetalleVueloBean> recuperarDetalleVuelo(InstanciaVueloBean vuelo) throws Exception { 
		
		ArrayList<DetalleVueloBean> listDetalles = new ArrayList<DetalleVueloBean>();
		String vueloBean=  vuelo.getNroVuelo();
		DetalleVueloBean detalle= null;
		Date fechaBean = vuelo.getFechaVuelo();
		
		try {
		java.sql.Statement stmt = this.conexion.createStatement();
		String sql = "SELECT clase, precio, asientos_disponibles FROM vuelos_disponibles WHERE nro_vuelo = '"+ vueloBean +"' AND fecha = '"+ fechaBean + "';";
		java.sql.ResultSet rs = stmt.executeQuery(sql);
		
		while(rs.next()) {
			detalle = new DetalleVueloBeanImpl();
			detalle.setClase(rs.getString("clase"));
			detalle.setPrecio(rs.getFloat("precio"));
			detalle.setAsientosDisponibles(rs.getInt("asientos_disponibles"));
			detalle.setVuelo(vuelo);
			listDetalles.add(detalle);
		}
		
		}catch(java.sql.SQLException ex)
		{
            logger.error("SQLException: " + ex.getMessage());
            logger.error("SQLState: " + ex.getSQLState());
            logger.error("VendorError: " + ex.getErrorCode());
            throw new Exception("No es posible acceder a el detalle del vuelo.");
        }
		
		return listDetalles; 
	}
}
