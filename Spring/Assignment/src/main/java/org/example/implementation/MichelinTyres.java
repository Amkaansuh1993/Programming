package org.example.implementation;

import org.example.interfaces.Tyres;
import org.springframework.stereotype.Component;

@Component
public class MichelinTyres implements Tyres {
    public String rotate() {
        return "Rotating Michelin Tyres";
    }
}
