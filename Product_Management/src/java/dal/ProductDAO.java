package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;
import model.*;

//Them "connection" trong DBContext
//----------------------------Get all product
public class ProductDAO extends DBContext {

    public Vector<Products> getAllProduct() {
        Vector<Products> listProduct = new Vector<>();
        String sql = "SELECT * FROM products";
        try {
            PreparedStatement ptm = connection.prepareStatement(sql);
            ResultSet rs = ptm.executeQuery();
            while (rs.next()) {
                String jsonSpec = rs.getString("spec_description");

                Products p = new Products(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("brand"),
                        rs.getInt("category_id"),
                        rs.getDouble("price"),
                        rs.getInt("stock"),
                        rs.getString("status"),
                        rs.getString("image_url"),
                        rs.getString("description"),
                        jsonSpec
                );
                listProduct.add(p);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return listProduct;
    }

//----------------------------------Search product
    public Vector<Products> searchProduct(String productName) {
        Vector<Products> list = new Vector<>();
        String sql = "SELECT * FROM products WHERE name LIKE ?";
        try {
            PreparedStatement ptm = connection.prepareStatement(sql);
            ptm.setString(1, "%" + productName + "%");
            ResultSet rs = ptm.executeQuery();
            while (rs.next()) {
                String jsonSpec = rs.getString("spec_description");
                Products p = new Products(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("brand"),
                        rs.getInt("category_id"),
                        rs.getDouble("price"),
                        rs.getInt("stock"),
                        rs.getString("status"),
                        rs.getString("image_url"),
                        rs.getString("description"),
                        jsonSpec
                );
                list.add(p);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }

//-----------------------------Insert product
    public void insertProduct(Products p) {
        String sql = "INSERT INTO products "
                + "(name, brand, category_id, price, "
                + "stock, status, image_url, description, spec_description) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ptm = connection.prepareStatement(sql);
            ptm.setString(1, p.getName());
            ptm.setString(2, p.getBrand());
            ptm.setInt(3, p.getCategory_id());
            ptm.setDouble(4, p.getPrice());
            ptm.setInt(5, p.getStock());
            ptm.setString(6, p.getStatus());
            ptm.setString(7, p.getImage_url());
            ptm.setString(8, p.getDescription());
            ptm.setString(9, p.getSpec_description());
            ptm.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

//--------------------------Update product
    public void updateProduct(Products p) {
        String sql = "UPDATE products SET name = ?, brand = ?, category_id = ?, price = ?, "
                + "stock = ?, status = ?, "
                + "image_url = ?, description = ?, spec_description = ? WHERE id = ?";
        try {
            PreparedStatement ptm = connection.prepareStatement(sql);
            ptm.setString(1, p.getName());
            ptm.setString(2, p.getBrand());
            ptm.setInt(3, p.getCategory_id());
            ptm.setDouble(4, p.getPrice());
            ptm.setInt(7, p.getStock());
            ptm.setString(8, p.getStatus());
            ptm.setString(9, p.getImage_url());
            ptm.setString(10, p.getDescription());
            ptm.setString(11, p.getSpec_description());
            ptm.setInt(12, p.getId());
            ptm.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

//---------------------Delete/Deactivate
    public void deactivateProduct(int id) {
        String sql = "UPDATE products SET status = 'inactive' WHERE id = ?";
        try {
            PreparedStatement ptm = connection.prepareStatement(sql);
            ptm.setInt(1, id);
            ptm.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

//--------------------Filter by category
    public Vector<Products> filterByCategory(int categoryId) {
        Vector<Products> list = new Vector<>();
        String sql = "SELECT * FROM products WHERE category_id = ?";
        try {
            PreparedStatement ptm = connection.prepareStatement(sql);
            ptm.setInt(1, categoryId);
            ResultSet rs = ptm.executeQuery();
            while (rs.next()) {
                String jsonSpec = rs.getString("spec_description");
                Products p = new Products(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("brand"),
                        rs.getInt("category_id"),
                        rs.getDouble("price"),
                        rs.getInt("stock"),
                        rs.getString("status"),
                        rs.getString("image_url"),
                        rs.getString("description"),
                        jsonSpec
                );
                list.add(p);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }

//---------------View product detail
    public Products getProductById(int productId) {
        Products p = null;
        String sql = "SELECT id, name, brand, category_id, price, stock, status, image_url, description, spec_description "
                + "FROM products WHERE id=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String jsonSpec = rs.getString("spec_description");
                p = new Products(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("brand"),
                        rs.getInt("category_id"),
                        rs.getDouble("price"),
                        rs.getInt("stock"),
                        rs.getString("status"),
                        rs.getString("image_url"),
                        rs.getString("description"),
                        jsonSpec
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return p;
    }

    public static void main(String[] args) {
        ProductDAO dao = new ProductDAO();
        Vector<Products> products = dao.getAllProduct();

        System.out.println("Total products: " + products.size());
        for (Products p : products) {
            System.out.println(p);
        }
    }

}
