package org.example.main;

import org.example.beans.Person;
import org.example.beans.Vehicle;
import org.example.config.ProjectConfig;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

public class Example15 {

    public static void main(String[] args) {

        var context = new AnnotationConfigApplicationContext(ProjectConfig.class);
        Person person = context.getBean(Person.class);
        Person person2 = context.getBean(Person.class);

        System.out.println("Person Name from Spring Context is: "+ person.hashCode());
        System.out.println("Person Name from Spring Context is: "+ person2.hashCode());

    }
}
