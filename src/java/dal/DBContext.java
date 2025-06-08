package dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    private static DBContext instance = null;
    private Connection connection;

    public static synchronized DBContext getInstance() {
        if (instance == null) {
            instance = new DBContext();
        }
        return instance;
    }

    public Connection getConnection() throws SQLException {
        try {
            if (connection == null || connection.isClosed()) {
                String user = "root";
                String password = "msqldt154A!";
                String url = "jdbc:mysql://localhost:3306/project_g2?useSSL=false&serverTimezone=UTC";

                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection(url, user, password);
                System.out.println("Kết nối MySQL thành công!");
            }
        } catch (ClassNotFoundException e) {
            System.out.println("Lỗi Driver MySQL: " + e.getMessage());
            throw new SQLException("Không thể tìm thấy MySQL Driver");
        } catch (SQLException e) {
            System.out.println("Lỗi kết nối MySQL: " + e.getMessage());
            throw e;
        }
        return connection;
    }

    private DBContext() {
        // Private constructor để đảm bảo Singleton
    }

    public void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                System.out.println("Đã đóng kết nối MySQL!");
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi đóng kết nối: " + e.getMessage());
        }
    }

    public static void testConnection() {
        try {
            Connection conn = DBContext.getInstance().getConnection();
            System.out.println("Database đã kết nối thành công!");
            DBContext.getInstance().closeConnection();
        } catch (SQLException e) {
            System.out.println("Không thể kết nối đến database: " + e.getMessage());
        }
    }

    public static void main(String[] args) {
        testConnection();
    }
} 