package org.example.main;

import org.example.beans.Vehicle;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.Random;
import java.util.function.Supplier;

public class Example9 {

    public static void main(String[] args) {

       var context = new ClassPathXmlApplicationContext("beans.xml");
       Vehicle vehicle = context.getBean(Vehicle.class);
       System.out.println("Bean Created using XML Configuration "+vehicle.getName());
    }
}
