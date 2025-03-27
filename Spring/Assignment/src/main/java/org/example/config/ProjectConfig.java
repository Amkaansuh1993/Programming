package org.example.config;

import org.example.beans.Person;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

@Configuration
@ComponentScan(basePackages = {"org.example.implementation","org.example.services"})
@ComponentScan(basePackageClasses = {org.example.beans.Person.class,org.example.beans.Vehicle.class})
public class ProjectConfig {

}
