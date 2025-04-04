package org.example.beans;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

@Component
@Scope(BeanDefinition.SCOPE_PROTOTYPE)
public class Person {
    public Person() {
        System.out.println("Person bean created by Spring");
    }

    private String name="Lucy";
    private Vehicle vehicle;

    @Autowired
    private Person(Vehicle vehicle) {
        System.out.println("Called Autowired Constructor");
        this.vehicle = vehicle;
    }



    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Vehicle getVehicle() {
        return vehicle;
    }



}
