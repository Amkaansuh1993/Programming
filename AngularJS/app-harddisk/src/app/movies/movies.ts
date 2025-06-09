import { Component } from '@angular/core';

import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';

import { MatCardModule } from '@angular/material/card';
import { MatPaginatorModule } from '@angular/material/paginator';


@Component({
  selector: 'app-movies',
  imports: [FormsModule,CommonModule,    MatCardModule,   MatPaginatorModule],
  templateUrl: './movies.html',
  styleUrl: './movies.scss'
})
export class Movies {
  moviesList = [];
}
