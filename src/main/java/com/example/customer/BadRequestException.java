package com.example.customer;

public class BadRequestException extends RuntimeException {

    public BadRequestException(String message) {
        super(message);
    }    
    
}
