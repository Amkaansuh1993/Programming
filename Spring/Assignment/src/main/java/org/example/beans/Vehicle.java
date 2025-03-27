package org.example.beans;

import org.example.services.VehicleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component(value="VehicleBean")
public class Vehicle {

    private String vehicle = "Honda";

    private final VehicleService vehicleServices;



    @Autowired
    public Vehicle(VehicleService vehicleServices) {
        this.vehicleServices = vehicleServices;
    }

    public String getVehicle() {
        return vehicle;
    }

    public void setVehicle(String vehicle) {
        this.vehicle = vehicle;
    }

    public VehicleService getVehicleServices() {
        return vehicleServices;
    }

    @Override
    public String toString() {
        return "Vehicle{" +
                "vehicle='" + vehicle + '\'' +
                '}';
    }
}
