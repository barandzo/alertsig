import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AlerteZoneComponent } from './alerte-zone.component';

describe('AlerteZoneComponent', () => {
  let component: AlerteZoneComponent;
  let fixture: ComponentFixture<AlerteZoneComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [AlerteZoneComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(AlerteZoneComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
