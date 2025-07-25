/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package shop.entities;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.FieldDefaults;
import shop.anotation.*;

/**
 *
 * @author admin
 */
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@Getter
@Setter
@Table(name = "users")
public class User {

    @Id
    @Column(name = "user_id")
    Integer id;

    @Column(name = "name")
    String username;

    @Column(name = "email")
    String email;

    @Column(name = "password")
    String password;

    @Column(name = "role")
    @Enumerated
    String role;
}
