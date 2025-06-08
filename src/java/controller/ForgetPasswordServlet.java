package controller;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import model.User;

@WebServlet(name = "ForgetPasswordServlet", urlPatterns = {"/forget-password"})
public class ForgetPasswordServlet extends HttpServlet {

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("forget_password.jsp").forward(request, response);
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        
        try {
            UserDAO userDAO = UserDAO.getInstance();
            User user = userDAO.getUserByEmail(email);

            if (user != null) {
                // Tạo mật khẩu mới ngẫu nhiên
                String newPassword = generateRandomPassword();
                
                // Cập nhật mật khẩu mới vào database
                if (userDAO.updatePassword(email, newPassword)) {
                    // Gửi mật khẩu mới qua email (trong thực tế)
                    // TODO: Implement email sending functionality
                    
                    // Hiển thị mật khẩu mới (chỉ để demo, không nên làm trong thực tế)
                    request.setAttribute("success", "Mật khẩu mới của bạn là: " + newPassword);
                    request.getRequestDispatcher("forget_password.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Không thể cập nhật mật khẩu!");
                    request.getRequestDispatcher("forget_password.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Email không tồn tại trong hệ thống!");
                request.getRequestDispatcher("forget_password.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("forget_password.jsp").forward(request, response);
        }
    }
    
    private String generateRandomPassword() {
        // Tạo mật khẩu ngẫu nhiên 8 ký tự
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 8; i++) {
            int index = (int) (chars.length() * Math.random());
            sb.append(chars.charAt(index));
        }
        return sb.toString();
    }
} 