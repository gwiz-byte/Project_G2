package shop.entities;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import lombok.*;
import lombok.experimental.FieldDefaults;
import shop.DAO.OrderDetailDAO;
import shop.anotation.*;

/**
 *
 * @author admin
 */
@Table(name = "orders")
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@Getter
@Setter
public class Order {
    @Id
    @Column(name = "id")
    Integer id;
    
    @Column(name = "user_id")
    Integer userId;
    
    @Column(name = "order_date")
    Date orderDate;
    
    @Column(name = "total_price")
    BigDecimal totalPrice;
    
    @Column(name = "payment_method_id")
    Integer paymentMethodId;
    
    @Column(name = "status")
    @Enumerated
    String status; // 'pending', 'shipping', 'completed', 'cancelled'
    
    @Column(name = "address")
    String address;
    
    List<OrderDetail> orderDetails;
    
    public void setorderDetailsFunc(){
        try {
            this.orderDetails = new OrderDetailDAO().getByOrderId(this.id);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}