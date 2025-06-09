import { Component } from '@angular/core';
import { MatTabsModule } from '@angular/material/tabs';

import { Movies } from '../movies/movies';

@Component({
  selector: 'app-tabs',
  imports: [MatTabsModule,    Movies],
  templateUrl: './tabs.html',
  styleUrl: './tabs.scss'
})
export class Tabs {

}
