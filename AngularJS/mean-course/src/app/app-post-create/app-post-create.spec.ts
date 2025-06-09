import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AppPostCreate } from './app-post-create';

describe('AppPostCreate', () => {
  let component: AppPostCreate;
  let fixture: ComponentFixture<AppPostCreate>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [AppPostCreate]
    })
    .compileComponents();

    fixture = TestBed.createComponent(AppPostCreate);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
