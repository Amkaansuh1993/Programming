package org.example.implementation;

import org.example.interfaces.Speakers;
import org.springframework.stereotype.Component;

@Component
public class BoseSpeaker implements Speakers {

    public String makeSound() {
        return "Playing music from Bose Speakers";
    }
}
