package shop.controller.rest;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletConfig;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import shop.DAO.CartItemDAO;
import shop.entities.CartItem;
import shop.entities.User;
import shop.utils.ResponseUtils;

@WebServlet(name = "CartApiServlet", urlPatterns = {"/CartApiServlet"})
public class CartApiServlet extends HttpServlet {

    private final CartItemDAO cartItemDAO = new CartItemDAO();
    private final Gson gson = new Gson();

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        config.getServletContext().setAttribute("/CartApiServlet", this);
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Get all cart items for user
                handleGetCartItems(request, response);
            } else {
                ResponseUtils.sendErrorResponse(response, 404, "Endpoint not found");
            }
        } catch (Exception e) {
            e.printStackTrace();
            ResponseUtils.sendErrorResponse(response, 500, "Internal server error: " + e.getMessage());
        }
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        try {
            handleAddToCart(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            ResponseUtils.sendErrorResponse(response, 500, "Internal server error: " + e.getMessage());
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        try {
            handleUpdateQuantity(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            ResponseUtils.sendErrorResponse(response, 500, "Internal server error: " + e.getMessage());
        }
    }

    @Override
    public void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        try {
            handleRemoveItem(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            ResponseUtils.sendErrorResponse(response, 500, "Internal server error: " + e.getMessage());
        }
    }

    private void handleGetCartItems(HttpServletRequest request, HttpServletResponse response)
            throws IOException, Exception {

        User userAuth = (User) request.getSession().getAttribute("userAuth2");
        int userId = userAuth.getId();
        List<CartItem> cartItems = cartItemDAO.getAllByUserId(userId);

        // Set product data for each cart item
        for (CartItem item : cartItems) {
            item.setProductFunc();
        }

        JsonObject responseObj = new JsonObject();
        responseObj.addProperty("success", true);
        responseObj.addProperty("message", "Cart items retrieved successfully");
        responseObj.add("data", gson.toJsonTree(cartItems));

        ResponseUtils.sendJsonResponse(response, responseObj);
    }

    private void handleAddToCart(HttpServletRequest request, HttpServletResponse response)
            throws IOException, Exception {

        String requestBody = ResponseUtils.getRequestBody(request);
        CartItemRequest cartRequest = gson.fromJson(requestBody, CartItemRequest.class);

        if (cartRequest.userId == null || cartRequest.productId == null || cartRequest.quantity == null) {
            ResponseUtils.sendErrorResponse(response, 400, "userId, productId, and quantity are required");
            return;
        }

        // Check if item already exists in cart
        CartItem existingItem = cartItemDAO.getByUserIdAndProductId(cartRequest.userId, cartRequest.productId);

        if (existingItem != null) {
            // Update quantity
            existingItem.setQuantity(existingItem.getQuantity() + cartRequest.quantity);
            cartItemDAO.update(existingItem);
        } else {
            // Create new cart item
            CartItem newItem = CartItem.builder()
                    .userId(cartRequest.userId)
                    .productId(cartRequest.productId)
                    .quantity(cartRequest.quantity)
                    .build();
            cartItemDAO.insert(newItem);
        }

        JsonObject responseObj = new JsonObject();
        responseObj.addProperty("success", true);
        responseObj.addProperty("message", "Item added to cart successfully");

        ResponseUtils.sendJsonResponse(response, responseObj);
    }

    private void handleUpdateQuantity(HttpServletRequest request, HttpServletResponse response)
            throws IOException, Exception {

        String requestBody = ResponseUtils.getRequestBody(request);
        UpdateQuantityRequest updateRequest = gson.fromJson(requestBody, UpdateQuantityRequest.class);

        if (updateRequest.id == null || updateRequest.quantity == null) {
            ResponseUtils.sendErrorResponse(response, 400, "id and quantity are required");
            return;
        }

        if (updateRequest.quantity <= 0) {
            ResponseUtils.sendErrorResponse(response, 400, "Quantity must be greater than 0");
            return;
        }

        CartItem cartItem = cartItemDAO.getById(updateRequest.id);
        if (cartItem == null) {
            ResponseUtils.sendErrorResponse(response, 404, "Cart item not found");
            return;
        }

        cartItem.setQuantity(updateRequest.quantity);
        cartItemDAO.update(cartItem);

        JsonObject responseObj = new JsonObject();
        responseObj.addProperty("success", true);
        responseObj.addProperty("message", "Quantity updated successfully");

        ResponseUtils.sendJsonResponse(response, responseObj);
    }

    private void handleRemoveItem(HttpServletRequest request, HttpServletResponse response)
            throws IOException, Exception {

        String idStr = request.getParameter("id");
        if (idStr == null) {
            ResponseUtils.sendErrorResponse(response, 400, "id parameter is required");
            return;
        }

        int id = Integer.parseInt(idStr);
        CartItem cartItem = cartItemDAO.getById(id);

        if (cartItem == null) {
            ResponseUtils.sendErrorResponse(response, 404, "Cart item not found");
            return;
        }

        cartItemDAO.deleteById(id);

        JsonObject responseObj = new JsonObject();
        responseObj.addProperty("success", true);
        responseObj.addProperty("message", "Item removed from cart successfully");

        ResponseUtils.sendJsonResponse(response, responseObj);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
    
    
// Request DTOs
    private static class CartItemRequest {

        Integer userId;
        Integer productId;
        Integer quantity;
    }

    private static class UpdateQuantityRequest {

        Integer id;
        Integer quantity;
    }
}
