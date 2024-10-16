import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent {
  title = 'The title of App Component';

  today = new Date();

  imageUrl = "https://dotnethow.net/images/movies/movie-1.jpg"

  price =10; 
}
