import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';

import {VERSION as CDK_VERSION} from '@angular/cdk';
import {VERSION as MAT_VERSION, provideNativeDateAdapter} from '@angular/material/core';

import { Toolbar } from "./toolbar/toolbar";
import { Tabs } from "./tabs/tabs";
 
@Component({
  selector: 'app-root',
  imports: [RouterOutlet,   Toolbar,Tabs],
  templateUrl: './app.html',
  styleUrl: './app.scss'
})
export class App {
  protected title = 'app-harddisk';
}
