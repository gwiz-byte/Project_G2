/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package shop.DAO;

import java.sql.SQLException;
import java.util.List;
import shop.JDBC.GenericDAO;
import shop.anotation.FindBy;
import shop.anotation.Query;
import shop.entities.CartItem;

/**
 *
 * @author admin
 */
public class CartItemDAO extends GenericDAO<CartItem, Integer>{
    
    public CartItemDAO() {
        super(CartItem.class);
    }
    @FindBy(columns = {"user_id"})
    public List<CartItem> getAllByUserId(Integer userId) throws SQLException{
        return findByAnd(userId);
    }
    @FindBy(columns = {"user_id","product_id"})
    public CartItem getByUserIdAndProductId(Integer userId, Integer productId) throws SQLException {
        List<CartItem> obs = findByAnd(userId, productId);
        return !obs.isEmpty() ? obs.get(0) : null;
    }
    
    @Query(sql = """
                 delete from cart_items where user_id = ?
                 """)
    public boolean deleteByUserId(Integer userId) throws SQLException {
        return executeQueryUpdateOrCheck(userId);
    }
}
