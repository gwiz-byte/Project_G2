package model;

public class Products {

    private int id;
    private String name;
    private String brand;
    private int category_id;
    private double price;
    private int stock;
    private String image_url;
    private String description;
    private String spec_description;
    private String status;

    public Products(){
        
    }
    
    public Products(int id, String name, String brand, int category_id, double price,
                int stock, String image_url,
                String description, String spec_description, String status) {
        this.id = id;
        this.name = name;
        this.brand = brand;
        this.category_id = category_id;
        this.price = price;
        this.stock = stock;
        this.image_url = image_url;
        this.description = description;
        this.spec_description = spec_description;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getBrand() {
        return brand;
    }

    public int getCategory_id() {
        return category_id;
    }

    public double getPrice() {
        return price;
    }

    public int getStock() {
        return stock;
    }

    public String getStatus() {
        return status;
    }

    public String getImage_url() {
        return image_url;
    }

    public String getDescription() {
        return description;
    }

    public String getSpec_description() {
        return spec_description;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public void setCategory_id(int category_id) {
        this.category_id = category_id;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setImage_url(String image_url) {
        this.image_url = image_url;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setSpec_description(String spec_description) {
        this.spec_description = spec_description;
    }

    @Override
    public String toString() {
        return "Products{" + "id=" + id + ", name=" + name + ", brand=" + brand + ", category_id=" + category_id + ", price=" + price + ", stock=" + stock + ", status=" + status + ", image_url=" + image_url + ", description=" + description + ", spec_description=" + spec_description + '}';
    }

}