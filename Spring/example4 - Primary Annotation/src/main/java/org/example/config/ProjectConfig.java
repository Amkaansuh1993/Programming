package org.example.config;

import org.example.beans.Vehicle;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

@Configuration
public class ProjectConfig {
    

    @Bean("audi")
    Vehicle vehicle(){
        var veh = new Vehicle();
        veh.setName("Audi8");
        return veh;
    }

    @Bean(name = "honda")
    Vehicle vehicle2(){
        var veh = new Vehicle();
        veh.setName("HondaCity");
        return veh;
    }

    @Primary
    @Bean(value = "ferrari")
    Vehicle vehicle3(){
        var veh = new Vehicle();
        veh.setName("Ferrari");
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
