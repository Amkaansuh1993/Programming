package org.example.main;

import org.example.beans.Person;
import org.example.beans.Vehicle;
import org.example.config.ProjectConfig;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

public class Example16 {

    public static void main(String[] args) {

        var context = new AnnotationConfigApplicationContext(ProjectConfig.class);
        System.out.println("Spring Context is ready to use");
        Person person = context.getBean(Person.class);

        System.out.println("Person Name from Spring Context is: "+ person.hashCode());

    }
}
