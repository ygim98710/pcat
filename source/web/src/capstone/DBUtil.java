package capstone;
import java.sql.*;

public class DBUtil {
	public static Connection getMySQLConnection() {
		Connection conn=null;
		
		try {
			String DB_URL = "jdbc:mysql://18.188.109.51:3306/clientInfo";
		    String DB_USER = "root";
		    String DB_PASSWORD = "root1234";
		    
		    Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);   
		}catch(ClassNotFoundException e) {
			e.printStackTrace();
		}catch (SQLException e) {
			e.printStackTrace();
		}
		
		return conn;
	}
	
	public static void close(Connection conn) {
		try {if(conn != null) conn.close();}catch(Exception e) {e.printStackTrace();}
	}
	
	public static void close(Statement stmt) {
		try {if(stmt != null) stmt.close();}catch(Exception e) {e.printStackTrace();}
	}
	
	public static void close(PreparedStatement pstmt) {
		try {if(pstmt != null) pstmt.close();}catch(Exception e) {e.printStackTrace();}
	}
	
	public static void close(ResultSet rs) {
		try {if(rs != null) rs.close();} catch(Exception e) {e.printStackTrace();}
	}
}
