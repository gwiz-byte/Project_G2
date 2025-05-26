package model;

public class Feedback {
    private int id;
    private int product_id;
    private int user_id;
    private int rating;
    private String content;
    private String created_at;

    public Feedback(int id, int product_id, int user_id, int rating, String content, String created_at) {
        this.id = id;
        this.product_id = product_id;
        this.user_id = user_id;
        this.rating = rating;
        this.content = content;
        this.created_at = created_at;
    }

    // Getters
    public int getId() {
        return id;
    }

    public int getProduct_id() {
        return product_id;
    }

    public int getUser_id() {
        return user_id;
    }

    public int getRating() {
        return rating;
    }

    public String getContent() {
        return content;
    }

    public String getCreated_at() {
        return created_at;
    }

    // Setters
    public void setId(int id) {
        this.id = id;
    }

    public void setProduct_id(int product_id) {
        this.product_id = product_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public void setCreated_at(String created_at) {
        this.created_at = created_at;
    }

    @Override
    public String toString() {
        return "Feedback{" + "id=" + id + ", product_id=" + product_id + ", user_id=" + user_id + 
               ", rating=" + rating + ", content=" + content + ", created_at=" + created_at + '}';
    }
} 