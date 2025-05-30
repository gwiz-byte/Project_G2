package model;

public class Blog {
    private int id;
    private String title;
    private String content;
    private int user_id;
    private String created_at;
    private String updated_at;

    public Blog(int id, String title, String content, int user_id, String created_at, String updated_at) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.user_id = user_id;
        this.created_at = created_at;
        this.updated_at = updated_at;
    }

    // Getters
    public int getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public String getContent() {
        return content;
    }

    public int getUser_id() {
        return user_id;
    }

    public String getCreated_at() {
        return created_at;
    }

    public String getUpdated_at() {
        return updated_at;
    }

    // Setters
    public void setId(int id) {
        this.id = id;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public void setCreated_at(String created_at) {
        this.created_at = created_at;
    }

    public void setUpdated_at(String updated_at) {
        this.updated_at = updated_at;
    }

    @Override
    public String toString() {
        return "Blog{" + "id=" + id + ", title=" + title + ", content=" + content + 
               ", user_id=" + user_id + ", created_at=" + created_at + ", updated_at=" + updated_at + '}';
    }
} 