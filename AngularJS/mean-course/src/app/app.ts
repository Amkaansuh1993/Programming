import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { AppPostCreate } from './app-post-create/app-post-create';




@Component({
  selector: 'app-root',
  imports: [RouterOutlet,AppPostCreate],
  templateUrl: './app.html',
  styleUrl: './app.scss'
})
export class App {
  protected title = 'mean-course';
}
