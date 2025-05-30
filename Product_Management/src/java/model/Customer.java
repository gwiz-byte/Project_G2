package model;

public class Customer {
    private int id;
    private String name;
    private String email;
    private String password;
    private String phone_number;
    private String address;
    private String role;

    public Customer(int id, String name, String email, String password, 
                   String phone_number, String address, String role) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.password = password;
        this.phone_number = phone_number;
        this.address = address;
        this.role = role;
    }

    // Getters
    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public String getPhone_number() {
        return phone_number;
    }

    public String getAddress() {
        return address;
    }

    public String getRole() {
        return role;
    }

    // Setters
    public void setId(int id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setPhone_number(String phone_number) {
        this.phone_number = phone_number;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public void setRole(String role) {
        this.role = role;
    }

    @Override
    public String toString() {
        return "Customer{" + 
               "id=" + id + 
               ", name='" + name + '\'' + 
               ", email='" + email + '\'' + 
               ", phone_number='" + phone_number + '\'' + 
               ", address='" + address + '\'' + 
               ", role='" + role + '\'' + 
               '}';
    }
} 