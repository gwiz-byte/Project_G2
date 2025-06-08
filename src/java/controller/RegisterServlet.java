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

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("Register.jsp").forward(request, response);
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy thông tin từ form
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String fullname = request.getParameter("fullname");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");

            // Kiểm tra mật khẩu xác nhận
            if (!password.equals(confirmPassword)) {
                request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
                request.getRequestDispatcher("Register.jsp").forward(request, response);
                return;
            }

            UserDAO userDAO = UserDAO.getInstance();
            
            // Kiểm tra email đã tồn tại chưa
            if (userDAO.isEmailExists(email)) {
                request.setAttribute("error", "Email đã được sử dụng!");
                request.getRequestDispatcher("Register.jsp").forward(request, response);
                return;
            }

            // Tạo đối tượng Users mới
            User newUser = new User(username, password, "customer", fullname, email, phone, address);
            
            // Thực hiện đăng ký
            if (userDAO.register(newUser)) {
                response.sendRedirect("login.jsp");
            } else {
                request.setAttribute("error", "Đăng ký thất bại!");
                request.getRequestDispatcher("Register.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("Register.jsp").forward(request, response);
        }
    }
} 