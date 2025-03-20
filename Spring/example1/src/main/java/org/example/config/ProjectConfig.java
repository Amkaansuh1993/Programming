package org.example.config;

import org.example.beans.Vehicle;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ProjectConfig {
    
    @Bean
    Vehicle vehicle(){
        var veh = new Vehicle();
        veh.setName("Audi8");
        return veh;
    }

    @Bean
    Vehicle vehicle2(){
        var veh = new Vehicle();
        veh.setName("HondaCity");
        return veh;
    }

    @Bean
    String hello(){
        return "hello World";
    }

    @Bean
    Integer number(){
        return 16;
    }
}
