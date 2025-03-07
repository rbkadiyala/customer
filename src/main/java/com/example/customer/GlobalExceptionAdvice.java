package com.example.customer;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.context.request.WebRequest;

@ControllerAdvice
public class GlobalExceptionAdvice {

    @ExceptionHandler(Exception.class)
    public ResponseEntity<?> handleGlobalException(Exception ex, WebRequest request) {
        return new ResponseEntity<>(ex.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
    }

    @ExceptionHandler({ EntityNotFoundException.class })
    public ResponseEntity<?> handleNotFound(Exception ex, WebRequest request) {
        ErrorResponse errorResponse = new ErrorResponse(HttpStatus.NOT_FOUND.value(), "Client Error", ex.getMessage());
        return new ResponseEntity<>(errorResponse, HttpStatus.NOT_FOUND);
    }

    // Handle 3xx Redirection Errors
    @ExceptionHandler(RedirectionException.class)
    public ResponseEntity<ErrorResponse> handleRedirection(RedirectionException ex) {
        ErrorResponse errorResponse = new ErrorResponse(HttpStatus.MULTIPLE_CHOICES.value(), "Redirection Error", ex.getMessage());
        return new ResponseEntity<>(errorResponse, HttpStatus.MULTIPLE_CHOICES);
    }

    // Handle 4xx Client Errors
    @ExceptionHandler({ BadRequestException.class, IllegalStateException.class })
    public ResponseEntity<?> handleBadRequest(Exception ex, WebRequest request) {
        return new ResponseEntity<>(ex.getMessage(), HttpStatus.BAD_REQUEST);
    }

    // Handle 5xx Server Errors
    @ExceptionHandler({ ServiceUnavailableException.class })
    public ResponseEntity<?> handleServiceUnavailable(Exception ex, WebRequest request) {
        return new ResponseEntity<>(ex.getMessage(), HttpStatus.SERVICE_UNAVAILABLE);
    }
}
