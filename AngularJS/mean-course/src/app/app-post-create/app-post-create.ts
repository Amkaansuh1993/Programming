import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { MatCard } from '@angular/material/card';

@Component({
  selector: 'app-app-post-create',
  imports: [FormsModule , MatInputModule, MatButtonModule, MatCard],
  templateUrl: './app-post-create.html',
  styleUrl: './app-post-create.scss'
})
export class AppPostCreate {
  enteredValue='';
  newPost = 'NO CONTENT';

  onAddPost(){
  }
}
