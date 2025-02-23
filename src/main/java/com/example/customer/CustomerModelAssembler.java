package com.example.customer;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.hateoas.EntityModel;
import org.springframework.hateoas.server.RepresentationModelAssembler;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.databind.ObjectMapper;

@Component

public class CustomerModelAssembler implements RepresentationModelAssembler<Customer, EntityModel<CustomerModel>> {

    @Autowired
    private ObjectMapper objectMapper;

    @Override
    public EntityModel<CustomerModel> toModel(Customer customer) {
        CustomerModel customerModel = toCustomerModel(customer);

        customerModel.setSelfLink( linkTo(methodOn(CustomerController.class).getCustomer(customer.getId())).withSelfRel() );
        customerModel.setCustomersLink( linkTo(methodOn(CustomerController.class).getCustomers()).withRel("customers") );
    
        return EntityModel.of(customerModel);
    }

    private CustomerModel toCustomerModel(Customer customer) {
        return objectMapper.convertValue(customer, CustomerModel.class);
    }    
}
