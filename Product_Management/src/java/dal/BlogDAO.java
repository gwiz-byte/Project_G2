package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;
import model.Blog;

public class BlogDAO extends DBContext {

    // Get all blogs with pagination
    public Vector<Blog> getAllBlogs(int page, int pageSize) {
        Vector<Blog> listBlogs = new Vector<>();
        String sql = "SELECT * FROM blogs ORDER BY created_at DESC LIMIT ? OFFSET ?";
        try {
            PreparedStatement ptm = getConnection().prepareStatement(sql);
            ptm.setInt(1, pageSize);
            ptm.setInt(2, (page - 1) * pageSize);
            ResultSet rs = ptm.executeQuery();
            while (rs.next()) {
                Blog b = new Blog(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("content"),
                    rs.getInt("user_id"),
                    rs.getString("created_at"),
                    rs.getString("updated_at")
                );
                listBlogs.add(b);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return listBlogs;
    }

    // Get blog by ID
    public Blog getBlogById(int blogId) {
        String sql = "SELECT * FROM blogs WHERE id = ?";
        try {
            PreparedStatement ptm = getConnection().prepareStatement(sql);
            ptm.setInt(1, blogId);
            ResultSet rs = ptm.executeQuery();
            if (rs.next()) {
                return new Blog(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("content"),
                    rs.getInt("user_id"),
                    rs.getString("created_at"),
                    rs.getString("updated_at")
                );
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    // Get blogs by user ID
    public Vector<Blog> getBlogsByUser(int userId) {
        Vector<Blog> listBlogs = new Vector<>();
        String sql = "SELECT * FROM blogs WHERE user_id = ? ORDER BY created_at DESC";
        try {
            PreparedStatement ptm = getConnection().prepareStatement(sql);
            ptm.setInt(1, userId);
            ResultSet rs = ptm.executeQuery();
            while (rs.next()) {
                Blog b = new Blog(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("content"),
                    rs.getInt("user_id"),
                    rs.getString("created_at"),
                    rs.getString("updated_at")
                );
                listBlogs.add(b);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return listBlogs;
    }

    // Insert new blog
    public void insertBlog(Blog b) {
        String sql = "INSERT INTO blogs (title, content, user_id) VALUES (?, ?, ?)";
        try {
            PreparedStatement ptm = getConnection().prepareStatement(sql);
            ptm.setString(1, b.getTitle());
            ptm.setString(2, b.getContent());
            ptm.setInt(3, b.getUser_id());
            ptm.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    // Update existing blog
    public void updateBlog(Blog b) {
        String sql = "UPDATE blogs SET title = ?, content = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ? AND user_id = ?";
        try {
            PreparedStatement ptm = getConnection().prepareStatement(sql);
            ptm.setString(1, b.getTitle());
            ptm.setString(2, b.getContent());
            ptm.setInt(3, b.getId());
            ptm.setInt(4, b.getUser_id());
            ptm.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    // Delete blog
    public void deleteBlog(int blogId, int userId) {
        String sql = "DELETE FROM blogs WHERE id = ? AND user_id = ?";
        try {
            PreparedStatement ptm = getConnection().prepareStatement(sql);
            ptm.setInt(1, blogId);
            ptm.setInt(2, userId);
            ptm.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    // Get total count of blogs
    public int getTotalBlogCount() {
        String sql = "SELECT COUNT(*) as total FROM blogs";
        try {
            PreparedStatement ptm = getConnection().prepareStatement(sql);
            ResultSet rs = ptm.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    // Search blogs by title
    public Vector<Blog> searchBlogsByTitle(String searchTerm, int page, int pageSize) {
        Vector<Blog> listBlogs = new Vector<>();
        String sql = "SELECT * FROM blogs WHERE title LIKE ? ORDER BY created_at DESC LIMIT ? OFFSET ?";
        try {
            PreparedStatement ptm = getConnection().prepareStatement(sql);
            ptm.setString(1, "%" + searchTerm + "%");
            ptm.setInt(2, pageSize);
            ptm.setInt(3, (page - 1) * pageSize);
            ResultSet rs = ptm.executeQuery();
            while (rs.next()) {
                Blog b = new Blog(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("content"),
                    rs.getInt("user_id"),
                    rs.getString("created_at"),
                    rs.getString("updated_at")
                );
                listBlogs.add(b);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return listBlogs;
    }

    public static void main(String[] args) {
        BlogDAO dao = new BlogDAO();
        
        System.out.println("=== Blog DAO Test Cases ===\n");
        
        // Test 1: Insert a new blog
        System.out.println("Test 1: Inserting a new blog");
        Blog newBlog = new Blog(0, "Test Blog Title", "This is a test blog content", 1, null, null);
        dao.insertBlog(newBlog);
        System.out.println("Blog inserted successfully\n");
        
        // Test 2: Get all blogs and count
        System.out.println("Test 2: Getting all blogs (page 1, 5 items per page)");
        Vector<Blog> blogs = dao.getAllBlogs(1, 5);
        System.out.println("Total blogs in database: " + dao.getTotalBlogCount());
        System.out.println("Blogs on first page:");
        for (Blog b : blogs) {
            System.out.println("- " + b.getTitle() + " (ID: " + b.getId() + ")");
        }
        System.out.println();
        
        // Test 3: Get blog by ID (using first blog from previous test)
        if (!blogs.isEmpty()) {
            System.out.println("Test 3: Getting blog by ID");
            int testBlogId = blogs.get(0).getId();
            Blog foundBlog = dao.getBlogById(testBlogId);
            if (foundBlog != null) {
                System.out.println("Found blog: " + foundBlog.getTitle());
                
                // Test 4: Update blog
                System.out.println("\nTest 4: Updating blog");
                foundBlog.setTitle("Updated Blog Title");
                foundBlog.setContent("This content has been updated");
                dao.updateBlog(foundBlog);
                
                // Verify update
                Blog updatedBlog = dao.getBlogById(testBlogId);
                System.out.println("Updated blog title: " + updatedBlog.getTitle());
            }
            System.out.println();
        }
        
        // Test 5: Get blogs by user
        System.out.println("Test 5: Getting blogs by user (user_id = 1)");
        Vector<Blog> userBlogs = dao.getBlogsByUser(1);
        System.out.println("Found " + userBlogs.size() + " blogs for user 1");
        for (Blog b : userBlogs) {
            System.out.println("- " + b.getTitle());
        }
        System.out.println();
        
        // Test 6: Search blogs by title
        System.out.println("Test 6: Searching blogs with title containing 'Test'");
        Vector<Blog> searchResults = dao.searchBlogsByTitle("Test", 1, 10);
        System.out.println("Found " + searchResults.size() + " blogs containing 'Test'");
        for (Blog b : searchResults) {
            System.out.println("- " + b.getTitle());
        }
        System.out.println();
        
        // Test 7: Delete a blog (if we have search results)
        if (!searchResults.isEmpty()) {
            System.out.println("Test 7: Deleting a blog");
            Blog blogToDelete = searchResults.get(0);
            dao.deleteBlog(blogToDelete.getId(), blogToDelete.getUser_id());
            
            // Verify deletion
            Blog deletedBlog = dao.getBlogById(blogToDelete.getId());
            if (deletedBlog == null) {
                System.out.println("Blog successfully deleted");
            } else {
                System.out.println("Blog deletion failed");
            }
        }
        
        System.out.println("\n=== Test Cases Completed ===");
    }
} 