package org.example.main;

import org.example.beans.Vehicle;
import org.example.config.ProjectConfig;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

public class Example6 {

    public static void main(String[] args) {
        Vehicle vehicle = new Vehicle();
        vehicle.setName("HondaCity");
        System.out.println("Vehicle name from non-spring context is "+ vehicle.getName());

        var context = new AnnotationConfigApplicationContext(ProjectConfig.class);
        Vehicle veh = context.getBean("honda",Vehicle.class);
        System.out.println("Vehicle name from spring context is"+ veh.getName());

        Vehicle veh2 = context.getBean("audi",Vehicle.class);
        System.out.println("Vehicle name from spring context is"+ veh2.getName());

        Vehicle veh3 = context.getBean(Vehicle.class);
        System.out.println("Vehicle name from spring context is"+ veh3.getName());
        veh3.printHello();

        String hello = context.getBean(String.class);
        System.out.println("String value from Spring Context is: " + hello);
        Integer num = context.getBean(Integer.class);
        System.out.println("Integer value from Spring Context is: " + num);


    }
}
