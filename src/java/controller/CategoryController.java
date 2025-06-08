package controller;

import dal.CategoryDAO;
import model.Category;

import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CategoryController extends HttpServlet {

    public void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String search = request.getParameter("search");
        String sortOrder = request.getParameter("sort"); // asc, desc, or default
        
        // Nếu không có sort order, mặc định là default (không sắp xếp)
        //Easter Egg hehehehe
        if (sortOrder == null) {
            sortOrder = "default";
        }

        // Xóa category
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            CategoryDAO.deleteCategory(id);
            response.sendRedirect("category");
            return;
        }

        // Hiển thị form thêm/sửa
        if ("edit".equals(action)) {
            String idStr = request.getParameter("id");
            Category category = null;

            if (idStr != null && !idStr.isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr);
                    category = CategoryDAO.getCategoryById(id);
                } catch (NumberFormatException e) {
                    // giữ category = null
                }
            }

            request.setAttribute("category", category);
            request.getRequestDispatcher("/categoryForm.jsp").forward(request, response);
            return;
        }

        // Lấy trang hiện tại
        int currentPage = 1;
        String pageParam = request.getParameter("page");
        try {
            if (pageParam != null) {
                currentPage = Integer.parseInt(pageParam);
            }
        } catch (NumberFormatException e) {
            currentPage = 1;
        }

        List<Category> categories;
        int totalRecords;
        int totalPages;
        int pageSize;

        if (search != null && !search.isEmpty()) {
            // Tìm kiếm có phân trang - 7 bản ghi/trang
            pageSize = 7;
            categories = CategoryDAO.searchCategoryWithPaging(search, currentPage, pageSize);
            totalRecords = CategoryDAO.getTotalSearchResults(search);
            totalPages = (int) Math.ceil((double) totalRecords / pageSize);
            request.setAttribute("search", search);
        } else {
            // Hiển thị thông thường - 5 bản ghi/trang
            pageSize = 5;
            categories = CategoryDAO.getCategoriesByPageAndSort(currentPage, pageSize, sortOrder);
            totalRecords = CategoryDAO.getTotalCategories();
            totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        }

        request.setAttribute("categories", categories);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("sortOrder", sortOrder);
        request.getRequestDispatcher("/categoryList.jsp").forward(request, response);
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String name = request.getParameter("name");
        String desc = request.getParameter("description");

        if ("add".equals(action)) {
            CategoryDAO.addCategory(new Category(0, name, desc));
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            CategoryDAO.updateCategory(new Category(id, name, desc));
        }

        response.sendRedirect("category");
    }

    @Override
    public String getServletInfo() {
        return "Category Controller Servlet";
    }
}
