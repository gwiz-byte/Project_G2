package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Vector;
import model.*;

//Them "connection" trong DBContext
//----------------------------Get all product
public class ProductDAO {

    public Vector<Products> getAllProduct() {
        DBContext db = DBContext.getInstance();
        Vector<Products> listProduct = new Vector<>();
        String sql = "SELECT * FROM products";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
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
                        rs.getString("image_url"),
                        rs.getString("description"),
                        jsonSpec,
                        rs.getString("status")
                );
                listProduct.add(p);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return listProduct;
    }

    public Vector<Products> getAllProductWithCategoryName() {
        DBContext db = DBContext.getInstance();
        Vector<Products> listProduct = new Vector<>();
        String sql = "SELECT p.*, c.name AS category_name "
                + "FROM products p "
                + "JOIN categories c ON p.category_id = c.id";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
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
                        rs.getString("image_url"),
                        rs.getString("description"),
                        jsonSpec,
                        rs.getString("status"),
                        rs.getString("category_name") // categoryName from JOIN
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
        DBContext db = DBContext.getInstance();
        Vector<Products> list = new Vector<>();
        String sql = "SELECT * FROM products WHERE name LIKE ?";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
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
                        rs.getString("image_url"),
                        rs.getString("description"),
                        jsonSpec,
                        rs.getString("status")
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
        DBContext db = DBContext.getInstance();
        String sql = "INSERT INTO products "
                + "(name, brand, category_id, price, "
                + "stock, image_url, description, spec_description, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ptm.setString(1, p.getName());
            ptm.setString(2, p.getBrand());
            ptm.setInt(3, p.getCategory_id());
            ptm.setDouble(4, p.getPrice());
            ptm.setInt(5, p.getStock());
            ptm.setString(6, p.getImage_url());
            ptm.setString(7, p.getDescription());
            ptm.setString(8, p.getSpec_description());
            ptm.setString(9, p.getStatus());
            ptm.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

//--------------------------Update product
    public void updateProduct(Products p) {
        DBContext db = DBContext.getInstance();
        String sql = "UPDATE products SET name = ?, brand = ?, category_id = ?, price = ?, "
                + "stock = ?, "
                + "image_url = ?, description = ?, spec_description = ?, status = ? WHERE id = ?";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ptm.setString(1, p.getName());
            ptm.setString(2, p.getBrand());
            ptm.setInt(3, p.getCategory_id());
            ptm.setDouble(4, p.getPrice());
            ptm.setInt(5, p.getStock());
            ptm.setString(6, p.getImage_url());
            ptm.setString(7, p.getDescription());
            ptm.setString(8, p.getSpec_description());
            ptm.setString(9, p.getStatus());
            ptm.setInt(10, p.getId());
            ptm.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

//---------------------Delete/Deactivate
    public void deactivateProduct(int id) {
        DBContext db = DBContext.getInstance();
        String sql = "UPDATE products SET status = 'inactive' WHERE id = ?";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ptm.setInt(1, id);
            ptm.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

//--------------------Filter by category
    public Vector<Products> filterByCategory(int categoryId) {
        DBContext db = DBContext.getInstance();
        Vector<Products> list = new Vector<>();
        String sql = "SELECT * FROM products WHERE category_id = ?";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
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
                        rs.getString("image_url"),
                        rs.getString("description"),
                        jsonSpec,
                        rs.getString("status")
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
        DBContext db = DBContext.getInstance();
        Products p = null;
        String sql = "SELECT id, name, brand, category_id, price, stock, image_url, description, spec_description, status "
                + "FROM products WHERE id=?";
        try {
            PreparedStatement ps = db.getConnection().prepareStatement(sql);
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
                        rs.getString("image_url"),
                        rs.getString("description"),
                        jsonSpec,
                        rs.getString("status")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return p;
    }

    public Vector<Products> getSortedProduct(String sortBy, String order) {
        DBContext db = DBContext.getInstance();
        Vector<Products> list = new Vector<>();

        if (sortBy == null || order == null) {
            sortBy = "id";
            order = "asc";
        }

        String validSortBy;
        switch (sortBy) {
            case "id", "category_id", "price", "stock":
                validSortBy = sortBy;
                break;
            default:
                validSortBy = "id";
        }
        String sortOrder = "asc".equalsIgnoreCase(order) ? "ASC" : "DESC";

        String sql = "SELECT * FROM products ORDER BY " + validSortBy + " " + sortOrder;
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
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
                        rs.getString("image_url"),
                        rs.getString("description"),
                        jsonSpec,
                        rs.getString("status")
                );
                list.add(p);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }

    public Vector<Products> getProductByBrand(String brand) {
        DBContext db = DBContext.getInstance();
        Vector<Products> list = new Vector<>();
        String sql = "SELECT * FROM products WHERE brand = ?";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ptm.setString(1, brand);
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
                        rs.getString("image_url"),
                        rs.getString("description"),
                        jsonSpec,
                        rs.getString("status")
                );
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Vector<Products> getProductByCategory(int categoryId) {
        DBContext db = DBContext.getInstance();
        Vector<Products> list = new Vector<>();
        String sql = "SELECT * FROM products WHERE category_id = ?";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
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
                        rs.getString("image_url"),
                        rs.getString("description"),
                        jsonSpec,
                        rs.getString("status")
                );
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public static Vector<String> getAllBrands() {
        DBContext db = DBContext.getInstance();
        Vector<String> listBrands = new Vector<>();
        String sql = "SELECT DISTINCT brand FROM products";

        try {
            PreparedStatement statement = db.getConnection().prepareStatement(sql);
            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                String brand = rs.getString("brand");
                listBrands.add(brand);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return listBrands;
    }

    //---------------Get total CPU products count
    public int getTotalCPUProducts() {
        DBContext db = DBContext.getInstance();
        String sql = "SELECT COUNT(*) FROM products WHERE category_id = 1 AND status = 'active'";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ResultSet rs = ptm.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    //---------------Get CPU products with pagination
    public Vector<Products> getCPUProductsWithPaging(int page, int productsPerPage) {
        DBContext db = DBContext.getInstance();
        Vector<Products> list = new Vector<>();
        String sql = "SELECT * FROM products WHERE category_id = 1 AND status = 'active' "
                + "ORDER BY id "
                + "LIMIT ? OFFSET ?";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ptm.setInt(1, productsPerPage);
            ptm.setInt(2, (page - 1) * productsPerPage);
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
                        rs.getString("image_url"),
                        rs.getString("description"),
                        jsonSpec,
                        rs.getString("status")
                );
                list.add(p);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
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
