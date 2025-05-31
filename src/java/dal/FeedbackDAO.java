package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;
import model.Feedback;

public class FeedbackDAO {

    // Get all feedback for a specific product
    public Vector<Feedback> getFeedbackByProduct(int productId) {
        DBContext db = DBContext.getInstance();
        Vector<Feedback> listFeedback = new Vector<>();
        String sql = "SELECT * FROM feedback WHERE product_id = ?";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ptm.setInt(1, productId);
            ResultSet rs = ptm.executeQuery();
            while (rs.next()) {
                Feedback f = new Feedback(
                    rs.getInt("id"),
                    rs.getInt("product_id"),
                    rs.getInt("user_id"),
                    rs.getInt("rating"),
                    rs.getString("content"),
                    rs.getString("created_at")
                );
                listFeedback.add(f);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return listFeedback;
    }

    // Get all feedback by a specific user
    public Vector<Feedback> getFeedbackByUser(int userId) {
         DBContext db = DBContext.getInstance();
        Vector<Feedback> listFeedback = new Vector<>();
        String sql = "SELECT * FROM feedback WHERE user_id = ?";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ptm.setInt(1, userId);
            ResultSet rs = ptm.executeQuery();
            while (rs.next()) {
                Feedback f = new Feedback(
                    rs.getInt("id"),
                    rs.getInt("product_id"),
                    rs.getInt("user_id"),
                    rs.getInt("rating"),
                    rs.getString("content"),
                    rs.getString("created_at")
                );
                listFeedback.add(f);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return listFeedback;
    }

    // Add new feedback
    public void insertFeedback(Feedback f) {
         DBContext db = DBContext.getInstance();
        String sql = "INSERT INTO feedback (product_id, user_id, rating, content) VALUES (?, ?, ?, ?)";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ptm.setInt(1, f.getProduct_id());
            ptm.setInt(2, f.getUser_id());
            ptm.setInt(3, f.getRating());
            ptm.setString(4, f.getContent());
            ptm.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    // Update existing feedback
    public void updateFeedback(Feedback f) {
         DBContext db = DBContext.getInstance();
        String sql = "UPDATE feedback SET rating = ?, content = ? WHERE id = ? AND user_id = ?";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ptm.setInt(1, f.getRating());
            ptm.setString(2, f.getContent());
            ptm.setInt(3, f.getId());
            ptm.setInt(4, f.getUser_id());
            ptm.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    // Delete feedback
    public void deleteFeedback(int feedbackId, int userId) {
         DBContext db = DBContext.getInstance();
        String sql = "DELETE FROM feedback WHERE id = ? AND user_id = ?";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ptm.setInt(1, feedbackId);
            ptm.setInt(2, userId);
            ptm.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    // Get average rating for a product
    public double getAverageRating(int productId) {
         DBContext db = DBContext.getInstance();
        String sql = "SELECT AVG(rating) as avg_rating FROM feedback WHERE product_id = ?";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ptm.setInt(1, productId);
            ResultSet rs = ptm.executeQuery();
            if (rs.next()) {
                return rs.getDouble("avg_rating");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0.0;
    }

    // Get feedback by ID
    public Feedback getFeedbackById(int feedbackId) {
         DBContext db = DBContext.getInstance();
        String sql = "SELECT * FROM feedback WHERE id = ?";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ptm.setInt(1, feedbackId);
            ResultSet rs = ptm.executeQuery();
            if (rs.next()) {
                return new Feedback(
                    rs.getInt("id"),
                    rs.getInt("product_id"),
                    rs.getInt("user_id"),
                    rs.getInt("rating"),
                    rs.getString("content"),
                    rs.getString("created_at")
                );
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    // Get all feedback with optional pagination
    public Vector<Feedback> getAllFeedback(int page, int pageSize) {
         DBContext db = DBContext.getInstance();
        Vector<Feedback> listFeedback = new Vector<>();
        String sql = "SELECT * FROM feedback ORDER BY created_at DESC LIMIT ? OFFSET ?";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ptm.setInt(1, pageSize);
            ptm.setInt(2, (page - 1) * pageSize);
            ResultSet rs = ptm.executeQuery();
            while (rs.next()) {
                Feedback f = new Feedback(
                    rs.getInt("id"),
                    rs.getInt("product_id"),
                    rs.getInt("user_id"),
                    rs.getInt("rating"),
                    rs.getString("content"),
                    rs.getString("created_at")
                );
                listFeedback.add(f);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return listFeedback;
    }

    // Get total count of feedback
    public int getTotalFeedbackCount() {
         DBContext db = DBContext.getInstance();
        String sql = "SELECT COUNT(*) as total FROM feedback";
        try {
            PreparedStatement ptm = db.getConnection().prepareStatement(sql);
            ResultSet rs = ptm.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    public static void main(String[] args) {
        FeedbackDAO dao = new FeedbackDAO();
        // Test with product ID 1
        Vector<Feedback> feedbacks = dao.getFeedbackByProduct(3);
        
        System.out.println("Feedbacks for product ID 1:");
        if (feedbacks.isEmpty()) {
            System.out.println("No feedback found for this product.");
        } else {
            for (Feedback f : feedbacks) {
                System.out.println(f.toString());
            }
        }
        
        // Also print the average rating
        double avgRating = dao.getAverageRating(1);
        System.out.println("\nAverage rating for product ID 1: " + avgRating);
    }
} 