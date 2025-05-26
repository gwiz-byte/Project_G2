package dal;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBContext {
    private static DBContext instance = new DBContext();
    private Connection connection;

    //Static
    public static DBContext getInstance() {
        return instance;
    }

    public Connection getConnection() {
        return connection;
    }

    protected DBContext() {
        try {
            if (connection == null || connection.isClosed()) {
                String user = "root";
                String password = "msqldt154A!";
                String url = "jdbc:mysql://localhost:3306/project_g2?useSSL=false&serverTimezone=UTC";

                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection(url, user, password);
                System.out.println("✅ Kết nối MySQL thành công!");
            }
        } catch (Exception e) {
            connection = null;
            System.out.println("❌ Kết nối MySQL thất bại: " + e.getMessage());
        }
    }

    public static void testConnection() {
        Connection conn = DBContext.getInstance().getConnection();
        if (conn != null) {
            System.out.println("✅ Database đã kết nối!");
        } else {
            System.out.println("❌ Không thể kết nối đến database!");
        }
    }
    
    
    public static void main(String[] args) {
        testConnection();
    }
}
