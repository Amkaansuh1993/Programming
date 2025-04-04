package org.example.implementation;

import org.example.interfaces.Speakers;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Component;

@Component

public class SonySpeakers implements Speakers {

    public String makeSound() {
        return "Playing music from Sony Speakers";
    }
}
