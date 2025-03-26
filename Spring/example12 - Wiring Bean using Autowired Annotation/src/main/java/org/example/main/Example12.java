package org.example.main;

import org.example.beans.Person;
import org.example.beans.Vehicle;
import org.example.config.ProjectConfig;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

public class Example12 {

    public static void main(String[] args) {

        var context = new AnnotationConfigApplicationContext(ProjectConfig.class);
        Person person = context.getBean(Person.class);
        Vehicle vehicle = context.getBean(Vehicle.class);

        System.out.println("Person Name from Spring Context is: "+ person.getName());
        System.out.println("Vehicle Name from Spring Context is: "+ vehicle.getName());
        System.out.println("Vehicle that Person own is: "+ person.getVehicle());

    }
}
