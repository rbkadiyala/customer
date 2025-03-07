# Use the official OpenJDK 17 image from the Docker Hub
FROM openjdk:17

# Copy the JAR file from the target folder into the container
COPY target/customer-eks.jar customer-eks.jar

# Expose port 8080 to the outside world
EXPOSE 8080

# Define the command to run the application
ENTRYPOINT ["java", "-jar", "customer-eks.jar"]