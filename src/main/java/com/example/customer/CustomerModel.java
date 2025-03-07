package com.example.customer;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.hateoas.Link;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CustomerModel {
    private Long id;
    private String name;
    private String email;

    private Link selfLink;
    private Link customersLink;
}
