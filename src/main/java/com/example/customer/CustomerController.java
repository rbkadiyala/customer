
package com.example.customer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.hateoas.CollectionModel;
import org.springframework.hateoas.EntityModel;
import org.springframework.hateoas.IanaLinkRelations;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/customers")
public class CustomerController {
    private final CustomerRepository repository;
    private final CustomerModelAssembler assembler;
    public CustomerController(CustomerRepository repository, CustomerModelAssembler assembler) {
        this.repository = repository;
        this.assembler = assembler;
    }  

    @GetMapping
    public CollectionModel<EntityModel<CustomerModel>> getCustomers() {
        List<EntityModel<CustomerModel>> customers = repository.findAll().stream()
            .map(assembler::toModel) //
            .collect(Collectors.toList());
        return CollectionModel.of(customers, linkTo(methodOn(CustomerController.class).getCustomers()).withSelfRel());
    }

    @GetMapping("/{id}")
    public EntityModel<CustomerModel> getCustomer(@PathVariable Long id) {
        Customer customer = repository.findById(id)
            .orElseThrow(() -> new EntityNotFoundException("Customer not found with id " + id));
            return assembler.toModel(customer);
    }

    @PostMapping
    public ResponseEntity<?> createCustomer(@RequestBody Customer customer) {
        EntityModel<CustomerModel> customerModel = assembler.toModel(repository.save(customer));
        return ResponseEntity //
            .created(customerModel.getRequiredLink(IanaLinkRelations.SELF).toUri()) //
            .body(customerModel);
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateCustomer(@PathVariable Long id, @RequestBody Customer newCustomer) {
        Customer updatedCustomer = repository.findById(id)
        .map(customer -> {
            customer.setName(newCustomer.getName());
            customer.setEmail(newCustomer.getEmail());            
            return repository.save(newCustomer);
        })
        .orElseGet(() -> {
            return repository.save(newCustomer);
        });

        EntityModel<CustomerModel> entityModel = assembler.toModel(updatedCustomer);

        return ResponseEntity //
            .created(entityModel.getRequiredLink(IanaLinkRelations.SELF).toUri()) //
            .body(entityModel);
    }

    @PatchMapping("/{id}")
    public ResponseEntity<?> patchCustomer(@PathVariable Long id, @RequestBody Customer newCustomer) {
        Customer updatedCustomer = repository.findById(id)
        .map(customer -> {
            if (newCustomer.getName() != null) {
                customer.setName(newCustomer.getName());
            }
            if (newCustomer.getEmail() != null) {
                customer.setEmail(newCustomer.getEmail());
            }
            return repository.save(customer);
        })
        .orElseThrow(() -> new EntityNotFoundException("Customer not found with id " + id));

        EntityModel<CustomerModel> entityModel = assembler.toModel(updatedCustomer);

        return ResponseEntity //
            .ok(entityModel);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteCustomer(@PathVariable Long id) {
        return repository.findById(id)
            .map(customer -> {
                repository.delete(customer);
                return ResponseEntity.notFound().build();
            })
            .orElseThrow(() -> new EntityNotFoundException("Customer not found with id " + id));
    }
 
}
