/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package shop.DAO;

import java.sql.SQLException;
import java.util.List;
import shop.JDBC.GenericDAO;
import shop.anotation.FindBy;
import shop.entities.OrderDetail;

/**
 *
 * @author admin
 */
public class OrderDetailDAO extends GenericDAO<OrderDetail, Integer>{
    
    public OrderDetailDAO() {
        super(OrderDetail.class);
    }
    
    @FindBy(columns = "order_id")
    public List<OrderDetail> getByOrderId(Integer orderId) throws SQLException{
        return findByAnd(orderId);
    }
    
}
