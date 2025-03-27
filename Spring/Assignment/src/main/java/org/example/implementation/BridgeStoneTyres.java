package org.example.implementation;

import org.example.interfaces.Tyres;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Component;

@Component
@Primary
public class BridgeStoneTyres implements Tyres {
    public String rotate() {
        return "Rotating BridgeStone Tyres";
    }
}
