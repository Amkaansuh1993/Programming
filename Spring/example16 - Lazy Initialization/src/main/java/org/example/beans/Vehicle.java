package org.example.beans;

import jakarta.annotation.PostConstruct;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Component;

@Component
@Lazy
public class Vehicle {

    private String name;

    public Vehicle() {
        System.out.println("Vehicle bean created by Spring");
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void printHello(){
        System.out.println("Printing Hello from Component Vehicle Bean");
    }
    @PostConstruct
    public void initialize(){
        this.name="New Honda City";
    }


    @Override
    public String toString() {
        return name;
    }
}
